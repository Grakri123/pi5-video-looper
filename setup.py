from setuptools import setup, find_packages

setup(
    name='Adafruit_Video_Looper',
    version='1.0.19',
    author='Tony DiCola',
    author_email='tdicola@adafruit.com',
    description='Application to turn your Raspberry Pi into a dedicated looping video playback device, good for art installations, information displays, or just playing cat videos all day.',
    license='GNU GPLv2',
    url='https://github.com/adafruit/pi_video_looper',
    install_requires=[
        'pyudev>=0.23.1',
        'pygame',
        'six>=1.16.0',
        'RPi.GPIO',
        'pigpio'
    ],
    packages=find_packages(),
    python_requires='>=3.6',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: End Users/Desktop',
        'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Topic :: Multimedia :: Video :: Display',
    ],
)
