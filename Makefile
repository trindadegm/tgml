# Makefile for C and C++ projects

# Defines compiler
CC := gcc

# Defines the the srouce file extension
SourceExt := c
# Defines the header file extension
HeaderExt := h

# The binary name
Bin := bin

# Defines where are the source files
SourceDir := src
# Defines where are the files to be included (headers
IncludeDir := include
# Defines where will be the build files placed
BuildDir := build
# Defines where will the binary placed
BinDir := bin
# Dependencies of the files will be here
DepsDir := deps
# Directory for libs, if desired.
LibsDir := libs

# The compiler flags
CFlags := -g -Wall
# The libs to link
Libs :=

# List all the source files
Sources := $(shell find $(SourceDir) -type f -name *.$(SourceExt))

# Object files will be named as the sources but will be on BuildDir
Objects := $(patsubst $(SourceDir)/%.$(SourceExt), $(BuildDir)/%.o, $(Sources))

# All the dependencies will be like this
Deps := $(patsubst $(BuildDir)/%.o, $(DepsDir)/%.d, $(Objects))

# Making the bin depends on the objects
$(BinDir)/$(Bin): $(Objects)
	@mkdir -p bin
	$(CC) $(Objects) $(CFlags) $(Libs) -o $(BinDir)/$(Bin) 

# Create dependencies using GNU compiler
$(DepsDir)/%.d: $(SourceDir)/%.$(SourceExt)
	@mkdir -p $(@D)
	$(CC) $(CFlags) $(Libs) $< -I $(IncludeDir) -MM -MF $@ -MT $@

# Compiling each file
$(BuildDir)/%.o: $(SourceDir)/%.$(SourceExt) $(DepsDir)/%.d
	@mkdir -p $(@D)
	$(CC) $(CFlags) $(Libs) -I $(IncludeDir) -c $< -o $@

# Includes dependencies makefiles
ifneq ($(MAKECMDGOALS), "clean")
-include $(Deps)
endif

# These rules make no file
.PHONY: clean

# These deletes all of the compilation intermediary files
clean:
	-rm $(shell find $(BuildDir) -type f -name *.o) $(shell find $(DepsDir) -type f -name *.d) \
		$(shell find $(BinDir) -type f -name $(Bin))
