1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-10-30
7 */
8 
9 pragma solidity ^0.6.2;
10 
11 contract PProxyStorage {
12 
13     function readBool(bytes32 _key) public view returns(bool) {
14         return storageRead(_key) == bytes32(uint256(1));
15     }
16 
17     function setBool(bytes32 _key, bool _value) internal {
18         if(_value) {
19             storageSet(_key, bytes32(uint256(1)));
20         } else {
21             storageSet(_key, bytes32(uint256(0)));
22         }
23     }
24 
25     function readAddress(bytes32 _key) public view returns(address) {
26         return bytes32ToAddress(storageRead(_key));
27     }
28 
29     function setAddress(bytes32 _key, address _value) internal {
30         storageSet(_key, addressToBytes32(_value));
31     }
32 
33     function storageRead(bytes32 _key) public view returns(bytes32) {
34         bytes32 value;
35         //solium-disable-next-line security/no-inline-assembly
36         assembly {
37             value := sload(_key)
38         }
39         return value;
40     }
41 
42     function storageSet(bytes32 _key, bytes32 _value) internal {
43         // targetAddress = _address;  // No!
44         bytes32 implAddressStorageKey = _key;
45         //solium-disable-next-line security/no-inline-assembly
46         assembly {
47             sstore(implAddressStorageKey, _value)
48         }
49     }
50 
51     function bytes32ToAddress(bytes32 _value) public pure returns(address) {
52         return address(uint160(uint256(_value)));
53     }
54 
55     function addressToBytes32(address _value) public pure returns(bytes32) {
56         return bytes32(uint256(_value));
57     }
58 
59 }
60 
61 contract PProxy is PProxyStorage {
62 
63     bytes32 constant IMPLEMENTATION_SLOT = keccak256(abi.encodePacked("IMPLEMENTATION_SLOT"));
64     bytes32 constant OWNER_SLOT = keccak256(abi.encodePacked("OWNER_SLOT"));
65 
66     modifier onlyProxyOwner() {
67         require(msg.sender == readAddress(OWNER_SLOT), "PProxy.onlyProxyOwner: msg sender not owner");
68         _;
69     }
70 
71     constructor () public {
72         setAddress(OWNER_SLOT, msg.sender);
73     }
74 
75     function getProxyOwner() public view returns (address) {
76        return readAddress(OWNER_SLOT);
77     }
78 
79     function setProxyOwner(address _newOwner) onlyProxyOwner public {
80         setAddress(OWNER_SLOT, _newOwner);
81     }
82 
83     function getImplementation() public view returns (address) {
84         return readAddress(IMPLEMENTATION_SLOT);
85     }
86 
87     function setImplementation(address _newImplementation) onlyProxyOwner public {
88         setAddress(IMPLEMENTATION_SLOT, _newImplementation);
89     }
90 
91 
92     fallback () external payable {
93        return internalFallback();
94     }
95 
96     function internalFallback() internal virtual {
97         address contractAddr = readAddress(IMPLEMENTATION_SLOT);
98         assembly {
99             let ptr := mload(0x40)
100             calldatacopy(ptr, 0, calldatasize())
101             let result := delegatecall(gas(), contractAddr, ptr, calldatasize(), 0, 0)
102             let size := returndatasize()
103             returndatacopy(ptr, 0, size)
104 
105             switch result
106             case 0 { revert(ptr, size) }
107             default { return(ptr, size) }
108         }
109     }
110 
111 }