1 pragma solidity ^0.6.2;
2 
3 contract PProxyStorage {
4 
5     function readBool(bytes32 _key) public view returns(bool) {
6         return storageRead(_key) == bytes32(uint256(1));
7     }
8 
9     function setBool(bytes32 _key, bool _value) internal {
10         if(_value) {
11             storageSet(_key, bytes32(uint256(1)));
12         } else {
13             storageSet(_key, bytes32(uint256(0)));
14         }
15     }
16 
17     function readAddress(bytes32 _key) public view returns(address) {
18         return bytes32ToAddress(storageRead(_key));
19     }
20 
21     function setAddress(bytes32 _key, address _value) internal {
22         storageSet(_key, addressToBytes32(_value));
23     }
24 
25     function storageRead(bytes32 _key) public view returns(bytes32) {
26         bytes32 value;
27         //solium-disable-next-line security/no-inline-assembly
28         assembly {
29             value := sload(_key)
30         }
31         return value;
32     }
33 
34     function storageSet(bytes32 _key, bytes32 _value) internal {
35         // targetAddress = _address;  // No!
36         bytes32 implAddressStorageKey = _key;
37         //solium-disable-next-line security/no-inline-assembly
38         assembly {
39             sstore(implAddressStorageKey, _value)
40         }
41     }
42 
43     function bytes32ToAddress(bytes32 _value) public pure returns(address) {
44         return address(uint160(uint256(_value)));
45     }
46 
47     function addressToBytes32(address _value) public pure returns(bytes32) {
48         return bytes32(uint256(_value));
49     }
50 
51 }
52 
53 contract PProxy is PProxyStorage {
54 
55     bytes32 constant IMPLEMENTATION_SLOT = keccak256(abi.encodePacked("IMPLEMENTATION_SLOT"));
56     bytes32 constant OWNER_SLOT = keccak256(abi.encodePacked("OWNER_SLOT"));
57 
58     modifier onlyProxyOwner() {
59         require(msg.sender == readAddress(OWNER_SLOT), "PProxy.onlyProxyOwner: msg sender not owner");
60         _;
61     }
62 
63     constructor () public {
64         setAddress(OWNER_SLOT, msg.sender);
65     }
66 
67     function getProxyOwner() public view returns (address) {
68        return readAddress(OWNER_SLOT);
69     }
70 
71     function setProxyOwner(address _newOwner) onlyProxyOwner public {
72         setAddress(OWNER_SLOT, _newOwner);
73     }
74 
75     function getImplementation() public view returns (address) {
76         return readAddress(IMPLEMENTATION_SLOT);
77     }
78 
79     function setImplementation(address _newImplementation) onlyProxyOwner public {
80         setAddress(IMPLEMENTATION_SLOT, _newImplementation);
81     }
82 
83 
84     fallback () external payable {
85        return internalFallback();
86     }
87 
88     function internalFallback() internal virtual {
89         address contractAddr = readAddress(IMPLEMENTATION_SLOT);
90         assembly {
91             let ptr := mload(0x40)
92             calldatacopy(ptr, 0, calldatasize())
93             let result := delegatecall(gas(), contractAddr, ptr, calldatasize(), 0, 0)
94             let size := returndatasize()
95             returndatacopy(ptr, 0, size)
96 
97             switch result
98             case 0 { revert(ptr, size) }
99             default { return(ptr, size) }
100         }
101     }
102 
103 }