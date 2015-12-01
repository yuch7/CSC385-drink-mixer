.PRECIOUS: %.o %.elf
MAIN = drink
srcs = drink.m4.s
objs = $(patsubst %.m4.s,%.o,$(patsubst %.c,%.o,$(srcs)))

# atmega328p
arch = attiny45
# m328p
arch_short = t45

all: program

pobjs:
	echo $(objs)

clean:
	rm -f *.elf *.o *.hex ._* *.dmp

%.hex: %.elf
	avr-objcopy -j .text -j .data -O ihex $< $@

%.o: %.c
	echo "FUCK"
	avr-gcc -mmcu=$(arch) -c $< 

%.o: %.m4.s
	$(eval PROCESSED=._$(basename $(basename $<)).s)
	m4 $< > $(PROCESSED)
	avr-as -mmcu=$(arch) -o $@ -c $(PROCESSED)

$(MAIN).elf: $(objs)
	echo "BUILDING MAIN"
	avr-gcc -nostartfiles -Wall -mmcu=$(arch) -o $@ $^

%.dmp: %.hex
	avr-objdump -m avr -D $< > $@

program: $(MAIN).hex
	sudo avrdude -p $(arch_short) -c dragon_isp -B 128 -P usb -e\
		-U flash:w:$<
		 # -U lfuse:w:0x62:m \
		 # -U hfuse:w:0xD1:m \
		 # -U efuse:w:0xFF:m \

debug: $(MAIN).hex
	simavr -g -m $(arch) -f 20000000 $< &
	ddd --debugger "avr-gdb -x gdb.conf"
