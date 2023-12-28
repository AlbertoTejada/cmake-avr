##########################################################################
# "THE ANY BEVERAGE-WARE LICENSE" (Revision 42 - based on beer-ware
# license):
# <dev@layer128.net> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and
# you think this stuff is worth it, you can buy me a be(ve)er(age) in
# return. (I don't like beer much.)
#
# Matthias Kleemann
##########################################################################

##########################################################################
# The toolchain requires some variables set.
#
# AVR_MCU (default: atmega8)
#     the type of AVR the application is built for
# AVR_L_FUSE (NO DEFAULT)
#     the LOW fuse value for the MCU used
# AVR_H_FUSE (NO DEFAULT)
#     the HIGH fuse value for the MCU used
# AVR_UPLOADTOOL (default: avrdude)
#     the application used to upload to the MCU
#     NOTE: The toolchain is currently quite specific about
#           the commands used, so it needs tweaking.
# MCU_SPEED (NO DEFAULT)
#     the mC frequency as compile definition e.g. "16000000UL"
# AVR_UPLOADTOOL_PORT (default: usb)
#     the port used for the upload tool, e.g. usb
# AVR_PROGRAMMER (default: avrispmkII)
#     the programmer hardware used, e.g. avrispmkII
##########################################################################
include(generic-gcc-avr.cmake)
include(avr_functions.cmake)

################################################################################
# status messages
################################################################################
message(STATUS "Current uploadtool is: ${AVR_UPLOADTOOL}")
message(STATUS "Current programmer is: ${AVR_PROGRAMMER}")
message(STATUS "Current upload port is: ${AVR_UPLOADTOOL_PORT}")
message(STATUS "Current uploadtool options are: ${AVR_UPLOADTOOL_OPTIONS}")
message(STATUS "Current MCU is set to: ${AVR_MCU}")
message(STATUS "Current H_FUSE is set to: ${AVR_H_FUSE}")
message(STATUS "Current L_FUSE is set to: ${AVR_L_FUSE}")

################################################################################
# some cmake cross-compile necessities
################################################################################
if(DEFINED ENV{AVR_FIND_ROOT_PATH})
  set(CMAKE_FIND_ROOT_PATH $ENV{AVR_FIND_ROOT_PATH})
else(DEFINED ENV{AVR_FIND_ROOT_PATH})
  if(EXISTS "/opt/local/avr")
    set(CMAKE_FIND_ROOT_PATH "/opt/local/avr")
  elseif(EXISTS "/usr/avr")
    set(CMAKE_FIND_ROOT_PATH "/usr/avr")
  elseif(EXISTS "/usr/lib/avr")
    set(CMAKE_FIND_ROOT_PATH "/usr/lib/avr")
  elseif(EXISTS "/usr/local/CrossPack-AVR")
    set(CMAKE_FIND_ROOT_PATH "/usr/local/CrossPack-AVR")
  else(EXISTS "/opt/local/avr")
    message(FATAL_ERROR "Please set AVR_FIND_ROOT_PATH in your environment.")
  endif(EXISTS "/opt/local/avr")
endif(DEFINED ENV{AVR_FIND_ROOT_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# not added automatically, since CMAKE_SYSTEM_NAME is "generic"
set(CMAKE_SYSTEM_INCLUDE_PATH "${CMAKE_FIND_ROOT_PATH}/include")
set(CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_FIND_ROOT_PATH}/lib")

################################################################################
# status messages for generating
################################################################################
message(STATUS "Set CMAKE_FIND_ROOT_PATH to ${CMAKE_FIND_ROOT_PATH}")
message(STATUS "Set CMAKE_SYSTEM_INCLUDE_PATH to ${CMAKE_SYSTEM_INCLUDE_PATH}")
message(STATUS "Set CMAKE_SYSTEM_LIBRARY_PATH to ${CMAKE_SYSTEM_LIBRARY_PATH}")

################################################################################
# status messages for generating
################################################################################
if(DEFINED MCU_SPEED)
  add_definitions("-DF_CPU=${MCU_SPEED}")
else(DEFINED MCU_SPEED)
  message(FATAL_ERROR "Please define MCU_SPEED in your environment.")
endif(DEFINED MCU_SPEED)

################################################################################
# Find the AVR LibC library
################################################################################
find_library(C_LIB c)
message(STATUS "avr-libc: ${C_LIB}")
