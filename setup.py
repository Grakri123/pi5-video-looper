from setuptools import setup, find_packages

setup(
    name='Adafruit_Video_Looper',
    version='1.0.19',
    author='Tony DiCola',
    author_email='tdicola@adafruit.com',
    description='Application to turn your Raspberry Pi into a dedicated looping video playback device, good for art installations, information displays, or just playing cat videos all day.',
    license='GNU GPLv2',
    url='https://github.com/adafruit/pi_video_looper',
    packages=find_packages(),
    python_requires='>=3.7',
    install_requires=[
        'pyudev>=0.23.1',
        'pygame>=2.0.0',
        'six>=1.16.0',
        'RPi.GPIO>=0.7.0',
        'pigpio>=1.78'
    ],
    entry_points={
        'console_scripts': [
            'video_looper=Adafruit_Video_Looper.video_looper:main',
        ],
    },
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: End Users/Desktop',
        'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Topic :: Multimedia :: Video :: Display',
    ],
)
