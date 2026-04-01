def _pdbrc_init():
    import os.path
    import readline
    histfile = os.path.expanduser("~/.python-pdb_history")
    try:
        readline.read_history_file(histfile)
    except IOError:
        pass
    import atexit
    atexit.register(readline.write_history_file, histfile)
    readline.set_history_length(500)

_pdbrc_init()
del _pdbrc_init
