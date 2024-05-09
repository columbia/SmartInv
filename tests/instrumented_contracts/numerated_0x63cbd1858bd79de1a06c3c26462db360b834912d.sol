1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-30
3 */
4 
5 pragma solidity ^0.6.2;
6 
7 contract PProxyStorage {
8 
9     function readBool(bytes32 _key) public view returns(bool) {
10         return storageRead(_key) == bytes32(uint256(1));
11     }
12 
13     function setBool(bytes32 _key, bool _value) internal {
14         if(_value) {
15             storageSet(_key, bytes32(uint256(1)));
16         } else {
17             storageSet(_key, bytes32(uint256(0)));
18         }
19     }
20 
21     function readAddress(bytes32 _key) public view returns(address) {
22         return bytes32ToAddress(storageRead(_key));
23     }
24 
25     function setAddress(bytes32 _key, address _value) internal {
26         storageSet(_key, addressToBytes32(_value));
27     }
28 
29     function storageRead(bytes32 _key) public view returns(bytes32) {
30         bytes32 value;
31         //solium-disable-next-line security/no-inline-assembly
32         assembly {
33             value := sload(_key)
34         }
35         return value;
36     }
37 
38     function storageSet(bytes32 _key, bytes32 _value) internal {
39         // targetAddress = _address;  // No!
40         bytes32 implAddressStorageKey = _key;
41         //solium-disable-next-line security/no-inline-assembly
42         assembly {
43             sstore(implAddressStorageKey, _value)
44         }
45     }
46 
47     function bytes32ToAddress(bytes32 _value) public pure returns(address) {
48         return address(uint160(uint256(_value)));
49     }
50 
51     function addressToBytes32(address _value) public pure returns(bytes32) {
52         return bytes32(uint256(_value));
53     }
54 
55 }
56 
57 contract PProxy is PProxyStorage {
58 
59     bytes32 constant IMPLEMENTATION_SLOT = keccak256(abi.encodePacked("IMPLEMENTATION_SLOT"));
60     bytes32 constant OWNER_SLOT = keccak256(abi.encodePacked("OWNER_SLOT"));
61 
62     modifier onlyProxyOwner() {
63         require(msg.sender == readAddress(OWNER_SLOT), "PProxy.onlyProxyOwner: msg sender not owner");
64         _;
65     }
66 
67     constructor () public {
68         setAddress(OWNER_SLOT, msg.sender);
69     }
70 
71     function getProxyOwner() public view returns (address) {
72        return readAddress(OWNER_SLOT);
73     }
74 
75     function setProxyOwner(address _newOwner) onlyProxyOwner public {
76         setAddress(OWNER_SLOT, _newOwner);
77     }
78 
79     function getImplementation() public view returns (address) {
80         return readAddress(IMPLEMENTATION_SLOT);
81     }
82 
83     function setImplementation(address _newImplementation) onlyProxyOwner public {
84         setAddress(IMPLEMENTATION_SLOT, _newImplementation);
85     }
86 
87 
88     fallback () external payable {
89        return internalFallback();
90     }
91 
92     function internalFallback() internal virtual {
93         address contractAddr = readAddress(IMPLEMENTATION_SLOT);
94         assembly {
95             let ptr := mload(0x40)
96             calldatacopy(ptr, 0, calldatasize())
97             let result := delegatecall(gas(), contractAddr, ptr, calldatasize(), 0, 0)
98             let size := returndatasize()
99             returndatacopy(ptr, 0, size)
100 
101             switch result
102             case 0 { revert(ptr, size) }
103             default { return(ptr, size) }
104         }
105     }
106 
107 }