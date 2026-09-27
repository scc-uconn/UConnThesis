"""Exercise Rnw builds in temporary copies; never alter repository outputs."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


SOURCE = Path(__file__).resolve().parents[1] / "Rnw"


class RnwWorkflow(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="uconn-rnw-")
        self.addCleanup(self.temporary.cleanup)
        self.folder = Path(self.temporary.name) / "Rnw"
        shutil.copytree(SOURCE, self.folder)
        self.env = os.environ.copy()

    def make(self, *args, succeeds=True):
        result = subprocess.run(
            ["make", *args], cwd=self.folder, env=self.env,
            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        )
        if succeeds:
            self.assertEqual(result.returncode, 0, result.stdout)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout)
        return result

    def test_discovery_and_incremental_build(self):
        source = self.folder / "extra.Rnw"
        source.write_text("<<extra>>=\n2 + 2\n@\n")
        self.make()
        output = self.folder / "extra.tex"
        self.assertIn("## [1] 4", output.read_text())
        before = output.stat().st_mtime_ns
        self.make()
        self.assertEqual(output.stat().st_mtime_ns, before)

    def test_changed_source_rebuilds(self):
        self.make()
        source = self.folder / "mean-ci.Rnw"
        source.write_text(source.read_text() + "\nChanged source text.\n")
        output = source.with_suffix(".tex")
        # Avoid depending on the filesystem's timestamp resolution.
        older = source.stat().st_mtime - 2
        os.utime(output, (older, older))
        self.make()
        self.assertIn("Changed source text.", output.read_text())

    def test_deleted_figure_regenerates(self):
        self.make()
        output = self.folder / "bootstrap.tex"
        before = output.read_bytes()
        figure = self.folder / "figures/bootstrap/bootstrap-distribution-1.pdf"
        figure.unlink()
        self.make()
        self.assertTrue(figure.is_file())
        self.assertEqual(output.read_bytes(), before)

    def test_missing_metadata_and_tex_regenerate(self):
        (self.folder / "bootstrap.d").unlink(missing_ok=True)
        (self.folder / "mean-ci.tex").unlink()
        self.make()
        self.assertTrue((self.folder / "bootstrap.d").is_file())
        self.assertTrue((self.folder / "mean-ci.tex").is_file())

    def test_failed_knit_cannot_leave_current_output(self):
        source = self.folder / "failure.Rnw"
        source.write_text("<<failure>>=\n1 + 1\n@\n")
        self.make("failure.tex")
        source.write_text('<<failure>>=\nstop("intentional failure")\n@\n')
        output = source.with_suffix(".tex")
        older = source.stat().st_mtime - 2
        os.utime(output, (older, older))
        result = self.make("failure.tex", succeeds=False)
        self.assertIn("intentional failure", result.stdout)
        self.assertFalse(output.exists())
        self.assertFalse(source.with_suffix(".d").exists())
        self.make("failure.tex", succeeds=False)

    def test_clean_and_parallel_rebuild(self):
        self.make("clean")
        for pattern in ("*.tex", "*.d"):
            self.assertEqual(list(self.folder.glob(pattern)), [])
        self.assertFalse((self.folder / "figures").exists())
        self.assertTrue((self.folder / "bootstrap.Rnw").is_file())
        self.make("-j2")
        for filename in ("mean-ci.tex", "bootstrap.tex", "knitr-preamble.tex"):
            self.assertTrue((self.folder / filename).is_file())
        self.make("-q")


if __name__ == "__main__":
    unittest.main()
