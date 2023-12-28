##########################################################################
# options
##########################################################################
option(WITH_MCU "Add the mCU type to the target file name." ON)

##########################################################################
# executables in use
##########################################################################
find_program(AVR_CC avr-gcc REQUIRED)
find_program(AVR_CXX avr-g++ REQUIRED)
find_program(AVR_OBJCOPY avr-objcopy REQUIRED)
find_program(AVR_SIZE_TOOL avr-size REQUIRED)
find_program(AVR_OBJDUMP avr-objdump REQUIRED)

##########################################################################
# toolchain starts with defining mandatory variables
##########################################################################
set(CMAKE_SYSTEM_NAME Generic PARENT_SCOPE)
set(CMAKE_SYSTEM_PROCESSOR avr PARENT_SCOPE)
set(CMAKE_C_COMPILER ${AVR_CC} PARENT_SCOPE)
set(CMAKE_CXX_COMPILER ${AVR_CXX} PARENT_SCOPE)

##########################################################################
# Identification
##########################################################################
set(AVR 1)

##########################################################################
# some necessary tools and variables for AVR builds, which may not
# defined yet
# - AVR_UPLOADTOOL
# - AVR_UPLOADTOOL_PORT
# - AVR_PROGRAMMER
# - AVR_MCU
# - AVR_SIZE_ARGS
##########################################################################

# default upload tool
if(NOT AVR_UPLOADTOOL)
  set(
    AVR_UPLOADTOOL avrdude
    CACHE STRING "Set default upload tool: avrdude"
  )
  find_program(AVR_UPLOADTOOL avrdude)
endif(NOT AVR_UPLOADTOOL)

# default upload tool port
if(NOT AVR_UPLOADTOOL_PORT)
  set(
    AVR_UPLOADTOOL_PORT usb
    CACHE STRING "Set default upload tool port: usb"
  )
endif(NOT AVR_UPLOADTOOL_PORT)

# default programmer (hardware)
if(NOT AVR_PROGRAMMER)
  set(
    AVR_PROGRAMMER avrispmkII
    CACHE STRING "Set default programmer hardware model: avrispmkII"
  )
endif(NOT AVR_PROGRAMMER)

# default MCU (chip)
if(NOT AVR_MCU)
  set(
    AVR_MCU atmega8
    CACHE STRING "Set default MCU: atmega8 (see 'avr-gcc --target-help' for valid values)"
  )
endif(NOT AVR_MCU)

#default avr-size args
if(NOT AVR_SIZE_ARGS)
  if(APPLE)
    set(AVR_SIZE_ARGS -B)
  else(APPLE)
    set(AVR_SIZE_ARGS -C;--mcu=${AVR_MCU})
  endif(APPLE)
endif(NOT AVR_SIZE_ARGS)

# prepare base flags for upload tool
set(AVR_UPLOADTOOL_BASE_OPTIONS -p ${AVR_MCU} -c ${AVR_PROGRAMMER})

# use AVR_UPLOADTOOL_BAUDRATE as baudrate for upload tool (if defined)
if(AVR_UPLOADTOOL_BAUDRATE)
  set(AVR_UPLOADTOOL_BASE_OPTIONS ${AVR_UPLOADTOOL_BASE_OPTIONS} -b ${AVR_UPLOADTOOL_BAUDRATE})
endif()

##########################################################################
# check build types:
# - Debug
# - Release
# - RelWithDebInfo
#
# Release is chosen, because of some optimized functions in the
# AVR toolchain, e.g. _delay_ms().
##########################################################################
if(NOT ((CMAKE_BUILD_TYPE MATCHES Release) OR
(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo) OR
(CMAKE_BUILD_TYPE MATCHES Debug) OR
(CMAKE_BUILD_TYPE MATCHES MinSizeRel)))
  set(
    CMAKE_BUILD_TYPE Release
    CACHE STRING "Choose cmake build type: Debug Release RelWithDebInfo MinSizeRel"
    FORCE
  )
endif(NOT ((CMAKE_BUILD_TYPE MATCHES Release) OR
(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo) OR
(CMAKE_BUILD_TYPE MATCHES Debug) OR
(CMAKE_BUILD_TYPE MATCHES MinSizeRel)))

##########################################################################

##########################################################################
# target file name add-on
##########################################################################
if(WITH_MCU)
  set(MCU_TYPE_FOR_FILENAME "-${AVR_MCU}")
else(WITH_MCU)
  set(MCU_TYPE_FOR_FILENAME "")
endif(WITH_MCU)
