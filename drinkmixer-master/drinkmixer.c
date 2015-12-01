#include <iostream>
#include <string>
#include <cstdlib>
#include "arduino-serial-lib.h"

void sendinfo(int v0, int v1, int v2, int fd){
	if (v1 <= 0 && v2 <= 0 && v0 <= 0)
		return;

	int send = 0, sendt = 0, i = 0;
	send += v0 > 0 ? 1 : 0;
	send += v1 > 0 ? 2 : 0;
	send += v2 > 0 ? 4 : 0;

	if (v0 == 0) {
		sendt = std::min(v1,v2);
		if (sendt <= 0)
			sendt = std::max(v1,v2);
	} else if (v1 <= 0) {
		sendt = std::min(v0,v2);
		if (sendt <= 0)
			sendt = std::max(v0,v2);
	} else if (v2 == 0) {
		sendt = std::min(v0,v1);
		if (sendt <= 0)
			sendt = std::max(v0,v1);
	} else {
		sendt = std::min(v0,v1);
		sendt = std::min(sendt, v2);
	}

	for (i = 0; i < sendt; i ++)
		serialport_writebyte(fd, send);
	sendinfo(v0 - sendt, v1 - sendt, v2 - sendt, fd);
			
}

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
			send = 7;
			for (i = 0; i < 3; i ++)
				serialport_writebyte(fd, send);
		} else if (!buf.compare("exit")) {
			break;
		} else {

			v0 = atoi(buf.substr(0,buf.find(' ')).c_str());
			v1 = atoi(buf.substr(buf.find(' ', buf.find(' '))).c_str());
			v2 = atoi(buf.substr( buf.find(' ', 2) ).c_str());

			sendinfo(v0,v1,v2,fd);
		}
	} while(1);

	serialport_close(fd);

	return 0;
}