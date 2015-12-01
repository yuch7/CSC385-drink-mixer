CC=g++
links=arduino-serial-lib.o

%.o: %.c 
	$(CC) -g -c -o $@ $^

drinkmixer: drinkmixer.o $(links)
	$(CC) -g -o $@ $^

