""" betterthreads provides an enhanced replacement for the 
    threading.Thread class geared towards cleanly stopping blocking
    threads.
"""

import gevent
import uuid

from gevent.event import Event


# Helper to generate new thread names
_counter = 0
def _newname(template="Thread-%d"):
    global _counter
    _counter = _counter + 1
    return template % _counter


class Thread(object):
    """ An enhanced replacement for the Python 
    :class:`threading.Thread` class.

    This isn't actually a true thread, instead it uses Gevent to
    implement co-routines. Using :func:`gevent.monkey.patch_all`, all
    Python blocking functions are replaced with non-blocking Gevent
    alternatives which allow 
    """

    __initialized = False

    def __init__(self, group=None, name=None):
        """ Thread constructor

        :param group: should be ``None``; reserved for future 
        extension when a :class:`ThreadGroup` class is implemented.
        :param name: the thread name.  By default, a unique name
        is constructed of the form "Thread-*N*" where *N* is a small 
        decimal number.

        If the subclass overrides the constructor, it must make sure 
        to invoke the base class constructor (``Thread.__init__()``) 
        before doing anything else to the thread.
        """

        # WARNING: Not sure about the side-effects of this...
        # Monkeypatch a bunch of blocking and thread-related
        # constructs to use gevent alternatives. Threads are now
        # co-routines which yield to each other when a Gevent
        # blocking operation is called.
        from gevent import monkey
        monkey.patch_all()

        self.__name = str(name or _newname())
        self.__ident = None
        self.__started = Event()
        self.__stopped = False
        self.__initialized = True

    def start(self):
        """ Start the thread's activity.

        It must be called at most once per thread object.  It
        arranges for the object's :meth:`run` method to be invoked in
        a separate thread of control.

        This method will raise a :exc:`RuntimeError` if called more 
        than once on the same thread object.
        """
        if not self.__initialized:
            raise RuntimeError("thread.__init__() not called")
        if self.__started.is_set():
            raise RuntimeError("thread already started")

        self._bootstrap()

    def _bootstrap(self):
        self.__ident = uuid.uuid4()
        self.__started.set()
        self._g_main = gevent.spawn(self.run)

    def stop(self, blocking=False):
        """ Stop the thread's activity.

        :param blocking: block until thread has stopped completely.
        """
        if self.__stopped:
            raise RuntimeError("threads can only be stopped once")

        self.__stopped = True
        self._g_main.kill()
        self.shutdown()
        if blocking:
            self._g_main.join()

    def run(self):
        """ Method representing the thread's activity.

        You may override this method in a subclass.
        """
        pass

    def join(self, timeout=None):
        """ Wait until the thread terminates.

        This blocks the calling thread until the
        thread whose :meth:`join` method is called terminates -- 
        either normally or through an unhandled exception -- or until
        the optional timeout occurs.

        When the *timeout* argument is present and not ``None``, it 
        should be a floating point number specifying a timeout for 
        the operation in seconds (or fractions thereof). As 
        :meth:`join` always returns ``None``, you must call 
        :meth:`isAlive` after :meth:`join` to decide whether a 
        timeout happened -- if the thread is still alive, the 
        :meth:`join` call timed out.

        When the *timeout* argument is not present or ``None``, the 
        operation will block until the thread terminates.

        A thread can be :meth:`join`\ ed many times.

        :meth:`join` raises a :exc:`RuntimeError` if an attempt is 
        made to join the current thread as that would cause a 
        deadlock. It is also an error to :meth:`join` a thread before
        it has been started and attempts to do so raises the same exception.
        """
        if not self.__initialized:
            raise RuntimeError("Thread.__init__() not called")
        if not self.__started.is_set():
            raise RuntimeError("cannot join thread before it is started")

        self._g_main.join(timeout)

    def shutdown(self):
        """ Cleanup method called when thread is stopping.

        This method is run when the thread is stopped. Any resources
        used by the thread (sockets and such) should be safely closed
        here.

        You may override this method in a subclass.
        """
        pass

    def __repr__(self):
        assert self.__initialized, "Thread.__init__() was not called"
        status = "initial"
        if self.__started.is_set():
            status = "started"
        if self.__stopped:
            status = "stopped"
        if self.__ident is not None:
            status += " %s" % self.__ident
        return "<%s(%s, %s)>" % (self.__class__.__name__, self.__name, status)

    def __enter__(self):
        return self

    def __exit__(self):
        self.stop()

    @property
    def name(self):
        assert self.__initialized, "Thread.__init__() not called"
        return self.__name

    @name.setter
    def name(self, name):
        assert self.__initialized, "Thread.__init__() not called"
        self.__name = str(name)

    @property
    def ident(self):
        assert self.__initialized, "Thread.__init__() not called"
        return self.__ident

    def isAlive(self):
        assert self.__initialized, "Thread.__init__() not called"
        return self.__started.is_set() and not self.__stopped

    is_alive = isAlive

    def getName(self):
        return self.name

    def setName(self, name):
        self.name = name