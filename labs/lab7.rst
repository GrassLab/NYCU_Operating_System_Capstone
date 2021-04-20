==================================
Lab 7 : File System Meets Hardware
==================================

*************
Introduction
*************

In the previous lab,
the file's operations were only in the memory.
In this lab, you need to read data from an external storage device, modify it in the memory,
and write it back.
In addition, you need to implement the basic of the FAT32 file system.

**********************
Goals of this lab
**********************

* Understand how to read/write data from an SD card. 
* Implement the FAT32 file system.
* Understand how to access devices by the VFS.
* Understand how memory be used as a cache for slow external storage mediums. 

************
Background
************

SD Card 
===============

SD Card Driver
---------------

We provide an `SD controller driver
<https://github.com/GrassLab/osdi/raw/master/supplement/sdhost.c>`_
for you.

You should first call the ``sd_init()`` to set up GPIO, SD host, and initialize the SD card.
Then you can call the following APIs.

``readblock(int block_id, char buf[512])``

``writeblock(int block_id, char buf[512])``

It reads/writes 512 bytes from/to the SD card to/from buf[512].

.. note::
  You need to modify the MMIO base according to your kernel mapping.
  You can also modify the code to meet your requirements.

.. warning::
  The driver code is possibly wrong. 
  Also, it's only tested on QEMU and the rpi3 with the SD card we gave to you.
  Please report it if you encounter a problem, you can also get a bonus if you find a bug in the code.

SD Card on QEMU
----------------

It's always easier to test your code on QEMU first.

You can add the argument ``-drive if=sd,file=<img name>,format=raw`` to attach an SD card file to QEMU. 

Sector vs. Block vs. Cluster
=============================

These terms appear in the documentation a lot,
you should be able to distinguish them.

Sector
-------

A sector is the smallest unit for a hard drive to manage its data.

The size is usually 512 bytes.

Block
------

A block is the smallest unit for a block device driver to read/write a device.
It's sometimes interchangeable with a sector.

The provided SD card driver code use 512 byte as the block size.

Cluster
---------

A cluster is composed of contiguous blocks.
A file system uses it as a basic unit to store a regular file or a directory.

FAT File System
================
FAT is a simple and widely used file system.
It has at least one file allocation table(FAT) that each entry stores the allocation status, so it gets the name.
The entry's size can be varied from 12 bit(FAT12), 16 bit(FAT16), and 32 bit(FAT32).

.. note::
  You only need to implement FAT32 in this lab.

.. note::
  FAT is a portable file system and used in Windows, Linux, and some RTOS.
  Hence, your FAT file system should be able to read a file written by another operating system(e.g. Linux).
  Also, another operating system should be able to read a file written by your FAT file system.



Short Filenames(SFN) vs. Long Filenames(LFN)
--------------------------------------------
Originally, FAT uses 8 bytes to stores a file's name and 3 bytes to store the file's extension name.
For example, if the file's entire name is a.out, "a" will be stored in the 8-byte filename, "out" will be stored in the 3-byte extension name, and "." is not stored.

However, it limits the filename's size, and it's impossible to store a filename with special characters.
Hence, LFN is invented.
It stores the filename in Unicode and can stack multiple directory entries to support varied size filename.

SFN is easier than LFN, so you only need to support SFN in the required part.
The nctuos.img we provided in lab0 stores the filename in LFN.
We provide a new SFN `sfn_nctuos.img
<https://github.com/GrassLab/osdi/raw/master/supplement/sfn_nctuos.img>`_

There is also a kernel8.img inside.
The kernel8.img prints the first block and the first partition block of the SD card.
You can replace the kernel8.img with yours later on.

.. image:: img/disk_dump.png

.. note::
  In Linux, you can specify how to mount a FAT file system. 

  ``mount -t msdos <device> <dir>``: store and load filename by SFN.

  ``mount -t vfat <device> <dir>``: store and load filename by LFN.

.. hint::
  In Linux, you can set up a loop device for a file.

  ``losetup -fP sfn_nctuos.img``: set up a loop device for sfn_nctuos.img.

  ``losetup -d <loop device>``: detach the loop device from the sfn_nctuos.img.

  Then, you can update the SD image to test your code on QEMU first.

Details of FAT
--------------

In this lab, you need to understand the format of FAT to be able to find, read, and write files in FAT.
The details are not covered by this documentation.
Please refer to https://en.wikipedia.org/wiki/Design_of_the_FAT_file_system
You can find everything about FAT there.

*********
Required
*********

In the required part, you should be able to read and write existing files under the root directory of a FAT32 file system.

You can create a new text file on your host computer first.
Then read/write the file on your rpi3.

The size of a FAT32 cluster is usually larger than the block size, but you can assume that the directory and the regular file you read/write is on the first block of the cluster.

Requirement 1
===============

In this requirement, you need to mount the FAT32 file system in the SD card.
You could set the FAT32 file system as the root file system if you didn't implement the multi-levels VFS in the previous lab.

Get the FAT32 Partition
---------------------------------

You should know the location of the FAT32 file system in the SD card first before mounting it.

The SD card should already be formatted by MBR.
You can parse it to get each partition's type, size, and block index.

.. hint::
  If you use the provided sfn_nctuos.img, the FAT32 partition's block index is 2048.

``required 1-1`` Get the FAT32 partition.

Mount the FAT32 File System
-----------------------------

A FAT32 file system stores its metadata in the first sector of the partition.

You need to do the following things during mounting.

1. Parse the metadata on the SD card.

2. Create a kernel object to store the metadata in memory.

3. Get the root directory cluster number and create a FAT32's root directory object.

``required 1-2`` Parse the FAT32's metadata and set up the mount.

Requirement 2
===============

Lookup and Open a File in FAT32
--------------------------------
To look up a file in a FAT32 directory, 

1. Get the cluster of the directory and calculate its block index.

2. Read the first block of the cluster by the ``readblock()``

3. Traverse the directory entries and compare the component name with filename + extension name to find the file.

4. You can get the first cluster of the file in the directory entry.

``required 2-1`` Look up and open a file in FAT32.

Read/Write a File in FAT32
---------------------------

After you get the first cluster of the file, you can use ``readblock()``/``writeblock()`` to read/write the file.

``required 2-2`` Read/Write a file in FAT32.

.. note::
  You need to update the file's size in the FAT32's directly entry if the file's size is changed by a file write.

************
Elective
************

Create a File in FAT32
========================

To create a new file in FAT32,

1. Find an empty entry in the FAT table.

2. Find an empty directory entry in the target directory.

3. Set them to proper values.

``elective 1`` Create a file in FAT32.

FAT32 with LFN
===============
In the required part, your FAT32 file system supports only SFN.
In this part, please modify your code to support LFN.

Note that, the directory entry of LFN is stored in UCS-2. 
You may need to translate the UCS-2 strings to another format if your terminal use different formats.

``elective 2`` Implement a FAT32 with LFN support. You should create/lookup a file with special characters(e.g. Chinese) in its name.

Device File
============

A vnode in the VFS tree can also represent a device, and we call it a device file.
To support device files in the VFS, you need 

* an API for users to create a device file's vnode,

* an API for each device driver to register itself to the VFS.

Device File Registration
-------------------------

A device can register itself to the VFS in its setup.
The VFS assigns the device a unique device id.
Then the device can be recognized by the VFS.

Mknod
------

A user can use the device id to create a device file in a file system.

After the device file is found in the file system,
the VFS uses the device id to find the device driver.
Next, the driver initializes the file handle with its method.
Then, the user can read/write the file handle to access the device.

Console
---------

You need to create a device file for your UART device as the console.
Then, users can get/print characters from/to the console by reading or writing its device file

``elective 3`` Create a UART device file as the console so users can get/print characters from/to the console by reading or writing its device file.

.. note::
    Device files can be persistently stored in some file systems, but you only need to create them in the tmpfs in this lab.

Memory as Cache for External Storage
=======================================

Accessing an SD card is much slower than accessing memory.
Before a CPU shutdown or an SD card is ejected, it's not necessary to synchronize the data between memory and SD card.
Hence, it's more efficient to preserve the data in memory and use memory as a cache for external storage.

We can categorize the file's data on the storage into three types: file's content, file's name, and file's metadata.

File's Metadata
-----------------

Besides the content of a file, additional information such as file size is stored in external storage, too.
The additional information is the file's metadata.
There is also metadata for a file system such as FAT tables in FAT.

Those metadata are cached by a file system's kernel objects.
You should have already implemented it.

File's Name
------------

A pathname lookup for a file system on external storage involves,

1. Read the directory block from the external storage.

2. Parse the directory entry and compare the directory entry's filename with the component name.

3. Get the next directory location.

The VFS can reduce the time spend on reading directory block and parsing directory entry by a component name cache mechanism.
A component name cache mechanism can be implemented as:

1. Look up the component name cache of the directory first.

2. If successfully finds the vnode, return to the vnode. Otherwise, call the lookup method of the underlying file system.

3. The underlying file system looks up from external storage.

4. If it successfully finds the file, it creates a vnode for the file and puts it into the component name cache.

``elective 4-1`` Implement a component name cache mechanism for faster pathname lookup.

File's Content
-----------------

The VFS can cache a file's content in memory by page frames.
A page cache mechanism can be implemented as:

1. Check the existence of the file's page frames when read or write a file.

2. If the page frames don't exist, allocate page frames for the file. 

3. The underlying file system populates the page frames with the file's content in external storage if necessary.

4. Read or write the page frames of the file.

``elective 4-2`` Implement a page cache mechanism for faster file read and write.


Sync
------

The VFS should synchronize the file's memory cache with the external storage when the user wants to eject it.
Hence, The VFS should provide an API for users to synchronize the data, and the file system should implement the synchronize method for writing data back to the external storage.

``elective 4-3`` Implement the ``sync`` API to write back the cache data. 