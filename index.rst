NYCU, Operating System Capstone, Spring 2021
===========================================================

This course aims to introduce the design and implementation of operating system kernels.
You'll learn both concept and implementation from a series of labs.

This course uses `Raspberry Pi 3 Model B+ <https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/>`_ (rpi3 for short)
as the hardware platform.
Students can get their hands dirty on a **Real Machine** instead of an emulator.

Labs
-----
There are 8 + 1 labs in this course.
You'll learn how to **design** a kernel by **implementing** it yourself.

There are 2 types of labels in each lab.

================== ===========================================================================================
``required``       You're required to implement it by the description, they take up major of your scores.
``elective``       You can implement some of them to get a bonus.
================== ===========================================================================================

There is no limitation on which programming language you should use for the labs.
However, there are a lot of things which are language dependent and even compiler dependent.
You need to manage them yourself.

You can check to last year's `course website <https://grasslab.github.io/osdi>`_
and `submission repository <https://github.com/GrassLab/osdi2020>`_ to see what you might need
to do during this semester.
Yet, the requirements and descriptions may differ this semester.

Grading Policy
---------------

It's allowed and recommended to check others code, but you still need to write it on your own
instead of copy/paste.

TAs validate plagiarism by asking the detail of your implementation.
If you can't elaborate your code clearly, you only get 70% of the score.

Your code may work on an emulator even it's wrong.
Hence, you get 90% of the score if your code works on QEMU but not on real rpi3.

For late hand in, the penalty is 1% per week.

Disclaimer
----------
We're not kernel developers or experienced embedded system developers.
It's common we made mistakes in the description.
If you find any of them, send an issue to github.

.. note::
  This documentation is not self-contained, you can get more information from external references.

..
    chapters tree below

.. toctree::
  :caption: Labs
  :hidden:

  labs/lab0

.. toctree::
  :caption: Hardware
  :hidden:

  hardware/asm

.. toctree::
  :caption: Miscs
  :hidden:

  external_reference/index