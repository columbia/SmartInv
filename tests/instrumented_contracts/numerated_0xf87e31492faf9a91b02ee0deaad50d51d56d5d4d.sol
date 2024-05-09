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
13   mapping (address => bool) authorizedDeploy;
14 
15 }
16 
17 // File: contracts/upgradable/OwnableStorage.sol
18 
19 contract OwnableStorage {
20 
21   address public owner;
22 
23   function OwnableStorage() internal {
24     owner = msg.sender;
25   }
26 
27 }
28 
29 // File: contracts/upgradable/ProxyStorage.sol
30 
31 contract ProxyStorage {
32 
33   /**
34    * Current contract to which we are proxing
35    */
36   address public currentContract;
37   address public proxyOwner;
38 }
39 
40 // File: erc821/contracts/AssetRegistryStorage.sol
41 
42 contract AssetRegistryStorage {
43 
44   string internal _name;
45   string internal _symbol;
46   string internal _description;
47 
48   /**
49    * Stores the total count of assets managed by this registry
50    */
51   uint256 internal _count;
52 
53   /**
54    * Stores an array of assets owned by a given account
55    */
56   mapping(address => uint256[]) internal _assetsOf;
57 
58   /**
59    * Stores the current holder of an asset
60    */
61   mapping(uint256 => address) internal _holderOf;
62 
63   /**
64    * Stores the index of an asset in the `_assetsOf` array of its holder
65    */
66   mapping(uint256 => uint256) internal _indexOfAsset;
67 
68   /**
69    * Stores the data associated with an asset
70    */
71   mapping(uint256 => string) internal _assetData;
72 
73   /**
74    * For a given account, for a given opperator, store whether that operator is
75    * allowed to transfer and modify assets on behalf of them.
76    */
77   mapping(address => mapping(address => bool)) internal _operators;
78 
79   /**
80    * Simple reentrancy lock
81    */
82   bool internal _reentrancy;
83 }
84 
85 // File: contracts/Storage.sol
86 
87 contract Storage is ProxyStorage, OwnableStorage, AssetRegistryStorage, LANDStorage {
88 }
89 
90 // File: contracts/upgradable/DelegateProxy.sol
91 
92 contract DelegateProxy {
93   /**
94    * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
95    * @param _dst Destination address to perform the delegatecall
96    * @param _calldata Calldata for the delegatecall
97    */
98   function delegatedFwd(address _dst, bytes _calldata) internal {
99     require(isContract(_dst));
100     assembly {
101       let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
102       let size := returndatasize
103 
104       let ptr := mload(0x40)
105       returndatacopy(ptr, 0, size)
106 
107       // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
108       // if the call returned error data, forward it
109       switch result case 0 { revert(ptr, size) }
110       default { return(ptr, size) }
111     }
112   }
113 
114   function isContract(address _target) constant internal returns (bool) {
115     uint256 size;
116     assembly { size := extcodesize(_target) }
117     return size > 0;
118   }
119 }
120 
121 // File: contracts/upgradable/IApplication.sol
122 
123 contract IApplication {
124   function initialize(bytes data) public;
125 }
126 
127 // File: contracts/upgradable/Ownable.sol
128 
129 contract Ownable is Storage {
130 
131   event OwnerUpdate(address _prevOwner, address _newOwner);
132 
133   function bytesToAddress (bytes b) pure public returns (address) {
134     uint result = 0;
135     for (uint i = b.length-1; i+1 > 0; i--) {
136       uint c = uint(b[i]);
137       uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
138       result += to_inc;
139     }
140     return address(result);
141   }
142 
143   modifier onlyOwner {
144     assert(msg.sender == owner);
145     _;
146   }
147 
148   function initialize(bytes data) public {
149     owner = bytesToAddress(data);
150   }
151 
152   function transferOwnership(address _newOwner) public onlyOwner {
153     require(_newOwner != owner);
154     owner = _newOwner;
155   }
156 }
157 
158 // File: contracts/upgradable/Proxy.sol
159 
160 contract Proxy is Storage, DelegateProxy {
161 
162   event Upgrade(address indexed newContract, bytes initializedWith);
163   event OwnerUpdate(address _prevOwner, address _newOwner);
164 
165   function Proxy() public {
166     proxyOwner = msg.sender;
167   }
168 
169   modifier onlyProxyOwner() {
170     require(msg.sender == proxyOwner);
171     _;
172   }
173 
174   function transferOwnership(address _newOwner) public onlyProxyOwner {
175     require(_newOwner != proxyOwner);
176 
177     OwnerUpdate(proxyOwner, _newOwner);
178     proxyOwner = _newOwner;
179   }
180 
181   function upgrade(IApplication newContract, bytes data) public onlyProxyOwner {
182     currentContract = newContract;
183     IApplication(this).initialize(data);
184 
185     Upgrade(newContract, data);
186   }
187 
188   function () payable public {
189     require(currentContract != 0); // if app code hasn't been set yet, don't call
190     delegatedFwd(currentContract, msg.data);
191   }
192 }
193 
194 // File: contracts/upgradable/LANDProxy.sol
195 
196 contract LANDProxy is Storage, Proxy {
197 }