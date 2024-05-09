1 pragma solidity ^0.4.18;
2 
3    contract ETPMap{
4      mapping (address => string) internal address_map;
5      event MapAddress(address, string);
6      function get_address(address addr) constant public returns (string) {
7          return address_map[addr];
8      }
9 
10      function map_address(string etpaddr) public {
11          address addr = msg.sender;
12          address_map[addr] = etpaddr;
13          MapAddress(addr, etpaddr);
14      }
15   }