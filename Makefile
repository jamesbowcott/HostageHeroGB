ASM = rgbasm
LINK = rgblink
FIX = rgbfix

INCDIR = inc
SOURCEDIR = src
OUTPUTDIR = build

ROM_NAME = hostagehero
FIX_FLAGS = -v -p 0

SOURCES = $(wildcard $(SOURCEDIR)/*.asm)
OBJECTS = $(patsubst $(SOURCEDIR)/%.asm, $(OUTPUTDIR)/%.o, $(SOURCES))

all: clean $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	$(LINK) -o $(OUTPUTDIR)/$@.gb -n $(OUTPUTDIR)/$@.sym -m $(OUTPUTDIR)/$@.map $(OBJECTS)
	$(FIX) $(FIX_FLAGS) $(OUTPUTDIR)/$@.gb

$(OUTPUTDIR)/%.o: $(SOURCEDIR)/%.asm
	$(ASM) -i$(INCDIR)/ -o $@ $<

clean:
	# rm -f $(ROM_NAME).gb $(ROM_NAME).sym $(OBJECTS)
	rm -Rf $(OUTPUTDIR)
	mkdir $(OUTPUTDIR)