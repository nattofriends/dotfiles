def init():
    # Manual rlcompleter shenanigans are unnecessary for Python 3.4+

    try:
        import fancycompleter
        fancycompleter.interact(persist_history=True)
    except ImportError:
        pass

    try:
        import ipdb

        def ipdb_breakpointhook():
            import ipdb

            # https://github.com/gotcha/ipdb/issues/272
            try:
                return ipdb.set_trace(frame=sys._getframe().f_back)
            finally:
                sys.excepthook = ipdb.pm

        sys.breakpointhook = ipdb_breakpointhook
        sys.excepthook = ipdb.pm
    except ImportError:
        pass

    try:
        import rich.pretty
        import rich.traceback

        rich.pretty.install()
        rich.traceback.install()
    except ImportError:
        pass


init()
del init
