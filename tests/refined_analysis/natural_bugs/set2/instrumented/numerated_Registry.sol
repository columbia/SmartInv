1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.6.8;
3 
4 // Inheritance
5 import "./openzeppelin/contracts/access/Ownable.sol";
6 
7 import "./extensions/Registrable.sol";
8 
9 contract Registry is Ownable {
10   mapping(bytes32 => address) public registry;
11 
12   // ========== EVENTS ========== //
13 
14   event LogRegistered(address indexed destination, bytes32 name);
15 
16   // ========== MUTATIVE FUNCTIONS ========== //
17 
18   function importAddresses(bytes32[] calldata _names, address[] calldata _destinations) external onlyOwner {
19     require(_names.length == _destinations.length, "Input lengths must match");
20 
21     for (uint i = 0; i < _names.length; i++) {
22       registry[_names[i]] = _destinations[i];
23       emit LogRegistered(_destinations[i], _names[i]);
24     }
25   }
26 
27   function importContracts(address[] calldata _destinations) external onlyOwner {
28     for (uint i = 0; i < _destinations.length; i++) {
29       bytes32 name = Registrable(_destinations[i]).getName();
30       registry[name] = _destinations[i];
31       emit LogRegistered(_destinations[i], name);
32     }
33   }
34 
35   function atomicUpdate(address _newContract) external onlyOwner {
36     Registrable(_newContract).register();
37 
38     bytes32 name = Registrable(_newContract).getName();
39     address oldContract = registry[name];
40     registry[name] = _newContract;
41 
42     Registrable(oldContract).unregister();
43 
44     emit LogRegistered(_newContract, name);
45   }
46 
47   // ========== VIEWS ========== //
48 
49   function requireAndGetAddress(bytes32 name) external view returns (address) {
50     address _foundAddress = registry[name];
51     require(_foundAddress != address(0), string(abi.encodePacked("Name not registered: ", name)));
52     return _foundAddress;
53   }
54 
55   function getAddress(bytes32 _bytes) external view returns (address) {
56     return registry[_bytes];
57   }
58 
59   function getAddressByString(string memory _name) public view returns (address) {
60     return registry[stringToBytes32(_name)];
61   }
62 
63   function stringToBytes32(string memory _string) public pure returns (bytes32 result) {
64     bytes memory tempEmptyStringTest = bytes(_string);
65 
66     if (tempEmptyStringTest.length == 0) {
67       return 0x0;
68     }
69 
70     // solhint-disable-next-line no-inline-assembly
71     assembly {
72       result := mload(add(_string, 32))
73     }
74   }
75 }