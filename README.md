VIMFDB 
===============================

Scripts to integrate the [VIM](http://www.vim.org) editor with the [FDB](http://flex.apache.org/) command line debugger. 
The goal of this project is to facillitate haXe and AS3 development in VIM.

Note, this is a 0.1 release, and should be considered highly experiemental. 

Context
-----
FDB is a command line debugger developed by Adobe, that has been donated to the [Apache Flex](http://flex.apache.org/) project. 
Though it is seldom used, it turns out it is a versatile tool that can be used to easily debug haXe and AS3 projects.

As a developer, I've grown tired of slow, monolithic IDEs, and have found I am able to work more rapidly using low-level
tools like VIM. 
Flashbuilder, the de facto choice for developing AS3 applications, has become bloated and buggy. Meanwhile, debuggers 
have been slow to evolve for the haXe platform.  It turns out, FDB is a great alternative for these cases.

Setup
-----
Make sure you have installed the Flex-SDK, and the bin directory should be in your path. 

I use [Vundle](https://github.com/gmarik/Vundle.vim) to manage my VIM plugins. Put this line in your .vimrc:
````
Bundle 'adampasz/vimfdb'
````
Start VIM, and then run:
````
BundleInstall
````

Usage
-----
:FDBLaunch - calls a command to launch FDB from vim
:FDBReset - restores .fdbinit to its default state
:FDBSetBreakPoint - adds a breakpoint to .fdbinit
MORE COMING SOON


History
-------

version 0.1 - Basic Functionality
