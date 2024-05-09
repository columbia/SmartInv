1 pragma solidity 0.4.24;
2 
3 contract EternalStorage {
4 
5     mapping(bytes32 => uint256) internal uintStorage;
6     mapping(bytes32 => string) internal stringStorage;
7     mapping(bytes32 => address) internal addressStorage;
8     mapping(bytes32 => bytes) internal bytesStorage;
9     mapping(bytes32 => bool) internal boolStorage;
10     mapping(bytes32 => int256) internal intStorage;
11 
12 }
13 
14 contract UpgradeabilityOwnerStorage {
15 
16     address private _upgradeabilityOwner;
17 
18     function upgradeabilityOwner() public view returns (address) {
19         return _upgradeabilityOwner;
20     }
21 
22     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
23         _upgradeabilityOwner = newUpgradeabilityOwner;
24     }
25 
26 }
27 
28 contract Proxy {
29 
30     function () public payable {
31         address _impl = implementation();
32         require(_impl != address(0));
33         bytes memory data = msg.data;
34 
35         assembly {
36             let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
37             let size := returndatasize
38 
39             let ptr := mload(0x40)
40             returndatacopy(ptr, 0, size)
41 
42             switch result
43             case 0 { revert(ptr, size) }
44             default { return(ptr, size) }
45         }
46     }
47 
48 
49     function implementation() public view returns (address);
50 }
51 
52 
53 
54 contract UpgradeabilityStorage {
55 
56     string internal _version;
57 
58     address internal _implementation;
59 
60     function version() public view returns (string) {
61         return _version;
62     }
63 
64     function implementation() public view returns (address) {
65         return _implementation;
66     }
67 }
68 
69 
70 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
71     
72     event Upgraded(string version, address indexed implementation);
73 
74     function _upgradeTo(string version, address implementation) internal {
75         require(_implementation != implementation);
76         _version = version;
77         _implementation = implementation;
78         emit Upgraded(version, implementation);
79     }
80 }
81 
82 
83 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
84     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
85 
86     constructor(address _owner) public {
87         setUpgradeabilityOwner(_owner);
88     }
89 
90     modifier onlyProxyOwner() {
91         require(msg.sender == proxyOwner());
92         _;
93     }
94 
95     function proxyOwner() public view returns (address) {
96         return upgradeabilityOwner();
97     }
98 
99     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
100         require(newOwner != address(0));
101         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
102         setUpgradeabilityOwner(newOwner);
103     }
104 
105     function upgradeTo(string version, address implementation) public onlyProxyOwner {
106         _upgradeTo(version, implementation);
107     }
108 
109 
110     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
111         upgradeTo(version, implementation);
112         require(address(this).call.value(msg.value)(data));
113     }
114 }
115 
116 
117 contract EternalStorageProxyForAirdropper is OwnedUpgradeabilityProxy, EternalStorage {
118 
119     constructor(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
120 
121 }