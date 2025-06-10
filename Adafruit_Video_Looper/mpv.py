"""Implementation of MPV video player."""
import os
import subprocess
import time

class MPVPlayer:
    """Class to handle video playback using the mpv video player."""

    def __init__(self, config):
        """Create an instance of a video player that runs mpv in the background."""
        self._process = None
        # Get list of supported file extensions.
        self._extensions = config.get('mpv', 'extensions') \
                               .translate(str.maketrans('', '', ' \t\r\n.')) \
                               .split(',')
        # Get extra arguments from config.
        self._extra_args = config.get('mpv', 'extra_args').split()

    def supported_extensions(self):
        """Return list of supported file extensions."""
        return self._extensions

    def play(self, movie, **kwargs):
        """Play the provided movie file, returning True if file was found/played.
        If a duration is specified it will attempt to play the movie for that
        number of seconds.
        """
        # Check if the file exists and is accessible.
        if not os.path.exists(movie):
            return False

        # Build up the mpv command line arguments.
        args = ['mpv']
        args.extend(self._extra_args)
        args.append(movie)

        # Run mpv process and direct standard output to /dev/null.
        self._process = subprocess.Popen(args,
                                       stdout=open(os.devnull, 'wb'),
                                       stderr=open(os.devnull, 'wb'))

        # Wait for the process to start
        time.sleep(0.5)

        # Return True to indicate success
        return True

    def is_playing(self):
        """Return True if the video is still playing."""
        if self._process is None:
            return False
        return self._process.poll() is None

    def stop(self, block_timeout_sec=0):
        """Stop the current video playing."""
        # Stop the mpv process if it's running.
        if self._process is not None and self._process.poll() is None:
            # First try sending a quit command through a SIGTERM signal.
            self._process.terminate()
            # If a blocking timeout was specified, wait up to that amount of time
            # for the process to stop.
            if block_timeout_sec > 0:
                self._process.wait(timeout=block_timeout_sec)
            # Kill the process if it's still running.
            if self._process.poll() is None:
                self._process.kill()
            self._process = None

    @staticmethod
    def create_player(config):
        """Create an instance of the video player."""
        return MPVPlayer(config) 