1 pragma solidity ^0.4.23;
2 
3 
4 
5 contract EternalStorage {
6 
7     mapping(bytes32 => uint256) internal uintStorage;
8     mapping(bytes32 => string) internal stringStorage;
9     mapping(bytes32 => address) internal addressStorage;
10     mapping(bytes32 => bytes) internal bytesStorage;
11     mapping(bytes32 => bool) internal boolStorage;
12     mapping(bytes32 => int256) internal intStorage;
13 
14 }
15 
16 pragma solidity ^0.4.23;
17 
18 
19 contract Proxy {
20 
21     function () public payable {
22         address _impl = implementation();
23         require(_impl != address(0));
24         bytes memory data = msg.data;
25 
26         assembly {
27             let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
28             let size := returndatasize
29 
30             let ptr := mload(0x40)
31             returndatacopy(ptr, 0, size)
32 
33             switch result
34             case 0 { revert(ptr, size) }
35             default { return(ptr, size) }
36         }
37     }
38 
39     function implementation() public view returns (address);
40 }
41 
42 pragma solidity ^0.4.23;
43 
44 
45 contract UpgradeabilityStorage {
46     string internal _version;
47 
48     address internal _implementation;
49 
50     function version() public view returns (string) {
51         return _version;
52     }
53 
54     function implementation() public view returns (address) {
55         return _implementation;
56     }
57 }
58 
59 pragma solidity ^0.4.23;
60 
61 
62 
63 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
64 
65     event Upgraded(string version, address indexed implementation);
66 
67 
68     function _upgradeTo(string version, address implementation) internal {
69         require(_implementation != implementation);
70         _version = version;
71         _implementation = implementation;
72         Upgraded(version, implementation);
73     }
74 }
75 
76 pragma solidity ^0.4.23;
77 
78 
79 contract UpgradeabilityOwnerStorage {
80     address private _upgradeabilityOwner;
81 
82     function upgradeabilityOwner() public view returns (address) {
83         return _upgradeabilityOwner;
84     }
85 
86 
87     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
88         _upgradeabilityOwner = newUpgradeabilityOwner;
89     }
90 
91 }
92 
93 pragma solidity ^0.4.23;
94 
95 
96 
97 
98 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
99 
100     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
101 
102 
103     function OwnedUpgradeabilityProxy(address _owner) public {
104         setUpgradeabilityOwner(_owner);
105     }
106 
107 
108     modifier onlyProxyOwner() {
109         require(msg.sender == proxyOwner());
110         _;
111     }
112 
113 
114     function proxyOwner() public view returns (address) {
115         return upgradeabilityOwner();
116     }
117 
118 
119     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
120         require(newOwner != address(0));
121         ProxyOwnershipTransferred(proxyOwner(), newOwner);
122         setUpgradeabilityOwner(newOwner);
123     }
124 
125 
126     function upgradeTo(string version, address implementation) public onlyProxyOwner {
127         _upgradeTo(version, implementation);
128     }
129 
130 
131     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
132         upgradeTo(version, implementation);
133         require(this.call.value(msg.value)(data));
134     }
135 }
136 
137 pragma solidity ^0.4.23;
138 
139 
140 
141 contract EternalStorageProxyForPayinMultisender is OwnedUpgradeabilityProxy, EternalStorage {
142 
143     function EternalStorageProxyForPayinMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
144 
145 }