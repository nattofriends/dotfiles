def init():
    import atexit
    import os
    import readline
    import rlcompleter
    rlcompleter

    readline.parse_and_bind('tab: complete')

    histfile = os.path.join(os.environ["HOME"], ".python_history")
    if os.path.isfile(histfile):
        readline.read_history_file(histfile)
    atexit.register(readline.write_history_file, histfile)


init()
del init
