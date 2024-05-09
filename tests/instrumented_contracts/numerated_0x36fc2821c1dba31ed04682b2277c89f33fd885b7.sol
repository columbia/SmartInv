1 pragma solidity ^0.4.18;
2 
3 // File: contracts/land/LANDStorage.sol
4 
5 contract LANDStorage {
6 
7   mapping (address => uint) latestPing;
8 
9   uint256 constant clearLow = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
10   uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
11   uint256 constant factor = 0x100000000000000000000000000000000;
12 
13 }
14 
15 // File: contracts/registry/AssetRegistryStorage.sol
16 
17 contract AssetRegistryStorage {
18 
19   string internal _name;
20   string internal _symbol;
21   string internal _description;
22 
23   /**
24    * Stores the total count of assets managed by this registry
25    */
26   uint256 internal _count;
27 
28   /**
29    * Stores an array of assets owned by a given account
30    */
31   mapping(address => uint256[]) internal _assetsOf;
32 
33   /**
34    * Stores the current holder of an asset
35    */
36   mapping(uint256 => address) internal _holderOf;
37 
38   /**
39    * Stores the index of an asset in the `_assetsOf` array of its holder
40    */
41   mapping(uint256 => uint256) internal _indexOfAsset;
42 
43   /**
44    * Stores the data associated with an asset
45    */
46   mapping(uint256 => string) internal _assetData;
47 
48   /**
49    * For a given account, for a given opperator, store whether that operator is
50    * allowed to transfer and modify assets on behalf of them.
51    */
52   mapping(address => mapping(address => bool)) internal _operators;
53 
54   /**
55    * Simple reentrancy lock
56    */
57   bool internal _reentrancy;
58 }
59 
60 // File: contracts/upgradable/OwnableStorage.sol
61 
62 contract OwnableStorage {
63 
64   address public owner;
65 
66   function OwnableStorage() internal {
67     owner = msg.sender;
68   }
69 
70 }
71 
72 // File: contracts/upgradable/ProxyStorage.sol
73 
74 contract ProxyStorage {
75 
76   /**
77    * Current contract to which we are proxing
78    */
79   address currentContract;
80 
81 }
82 
83 // File: contracts/Storage.sol
84 
85 contract Storage is ProxyStorage, OwnableStorage, AssetRegistryStorage, LANDStorage {
86 }
87 
88 // File: contracts/upgradable/DelegateProxy.sol
89 
90 contract DelegateProxy {
91   /**
92    * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
93    * @param _dst Destination address to perform the delegatecall
94    * @param _calldata Calldata for the delegatecall
95    */
96   function delegatedFwd(address _dst, bytes _calldata) internal {
97     require(isContract(_dst));
98     assembly {
99       let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
100       let size := returndatasize
101 
102       let ptr := mload(0x40)
103       returndatacopy(ptr, 0, size)
104 
105       // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
106       // if the call returned error data, forward it
107       switch result case 0 { revert(ptr, size) }
108       default { return(ptr, size) }
109     }
110   }
111 
112   function isContract(address _target) constant internal returns (bool) {
113     uint256 size;
114     assembly { size := extcodesize(_target) }
115     return size > 0;
116   }
117 }
118 
119 // File: contracts/upgradable/IApplication.sol
120 
121 contract IApplication {
122   function initialize(bytes data) public;
123 }
124 
125 // File: contracts/upgradable/Proxy.sol
126 
127 contract Proxy is ProxyStorage, DelegateProxy {
128 
129   event Upgrade(address indexed newContract, bytes initializedWith);
130 
131   function upgrade(IApplication newContract, bytes data) public {
132     currentContract = newContract;
133     newContract.initialize(data);
134 
135     Upgrade(newContract, data);
136   }
137 
138   function () payable public {
139     require(currentContract != 0); // if app code hasn't been set yet, don't call
140     delegatedFwd(currentContract, msg.data);
141   }
142 }
143 
144 // File: contracts/upgradable/LANDProxy.sol
145 
146 contract LANDProxy is Storage, Proxy {
147 }