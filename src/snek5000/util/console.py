"""Console script functions

"""

from textwrap import dedent

from snek5000.solvers import available_solvers


def print_versions():

    import snakemake
    import pymech
    import fluidsim_core
    import fluiddyn
    import snek5000

    versions = {"Package": "Version", "-------": "-------"}

    packages = [snek5000, fluiddyn, fluidsim_core, pymech, snakemake]
    for package in packages:
        versions[package.__name__] = package.__version__

    for pkg_name, version in versions.items():
        print(f"{pkg_name.ljust(15)} {version}")

    names = sorted(set([entry_point.name for entry_point in available_solvers()]))
    print("\nInstalled solvers: " + ", ".join(names))


def start_ipython_load_sim():
    """Start IPython and load a simulation"""
    from IPython import start_ipython

    argv = ["--matplotlib", "-i", "-c"]
    code = dedent(
        """
        from fluidsim import load
        print("Loading simulation")
        sim = load()
        params = sim.params
        print("`sim` and `params` variables are available")
    """
    )
    argv.append("; ".join(code.strip().split("\n")))
    start_ipython(argv=argv)
