#include <iostream>
#include <string>
#include <cstdlib>
#include "arduino-serial-lib.h"

int main(int argc, char * argv[]) {
	if (argc != 2) {
		std::cerr <<  "Usage drinkmixer <Serial port>\n";
		exit(1);
	}

	int send, fd, i, v0, v1, v2;
	std::string buf;
	buf.reserve(50);

	fd = serialport_init(argv[1], 9600);

	do {	
		std::cout << "Type 3 numbers for each second of the valve should be on respectively (seperated by space), or type 'fruit punch', or 'exit'\n";
		getline(std::cin, buf);
		if (!buf.compare("fruit punch")){
			send = 3;
			for (i = 0; i < 3; i ++)
				serialport_writebyte(fd, send);
		} else if (!buf.compare("exit")) {
			break;
		} else {

			v0 = atoi(buf.substr(0,buf.find(' ')).c_str());
			v1 = atoi(buf.substr(buf.find(' ', buf.find(' '))).c_str());
			v2 = atoi(buf.substr( buf.find(' ', 2) ).c_str());

			send = v0;
			serialport_writebyte(fd, send);
			send = v1;
			serialport_writebyte(fd, send);
			send = v2;	
			serialport_writebyte(fd, send);
		}
	} while(1);

	serialport_close(fd);

	return 0;
}