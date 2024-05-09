1 pragma solidity 0.5.7;
2 
3 contract CuratorsInterface {
4   function checkRole(address _operator, string memory _permission) public view;
5 }
6 
7 contract pDNA {
8   CuratorsInterface public curators = CuratorsInterface(0x2D1711aDA9DD2Bf8792AD29DD4E307D6527f2Ad5);
9 
10   string public name;
11   string public symbol;
12 
13   mapping(string => string) private files;
14 
15   event FilePut(address indexed curator, string hash, string name);
16 
17   constructor(string memory _eGrid, string memory _grundstuck) public {
18     curators.checkRole(msg.sender, "authorized");
19     name = _eGrid;
20     symbol = _grundstuck;
21   }
22 
23   function getFile(string memory _name) public view returns (string memory) {
24     return files[_name];
25   }
26 
27   function putFile(string memory _hash, string memory _name) public {
28     curators.checkRole(msg.sender, "authorized");
29     files[_name] = _hash;
30     emit FilePut(msg.sender, _hash, _name);
31   }
32 }