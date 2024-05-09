1 pragma solidity 0.4.25;
2 
3 contract SLoader {
4   mapping (address => Package) public packages;
5 
6   struct Package{
7     bytes32 checksum;
8     string uri;
9   }
10 
11   function registerPackage(bytes32 checksum, string uri) public {
12     packages[msg.sender] = Package(checksum, uri);
13   }
14 }