1 // Author: Nick Mudge <nick@perfectabstractions.com>
2 
3 pragma solidity 0.6.6;
4 
5 interface IERCProxy {
6     function proxyType() external pure returns (uint256 proxyTypeId);
7 
8     function implementation() external view returns (address codeAddr);
9 }
10 
11 
12 // File contracts/common/Proxy/Proxy.sol
13 
14 pragma solidity 0.6.6;
15 abstract contract Proxy is IERCProxy {
16     function delegatedFwd(address _dst, bytes memory _calldata) internal {
17         // solium-disable-next-line security/no-inline-assembly
18         assembly {
19             let result := delegatecall(
20                 sub(gas(), 10000),
21                 _dst,
22                 add(_calldata, 0x20),
23                 mload(_calldata),
24                 0,
25                 0
26             )
27             let size := returndatasize()
28 
29             let ptr := mload(0x40)
30             returndatacopy(ptr, 0, size)
31 
32             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
33             // if the call returned error data, forward it
34             switch result
35                 case 0 {
36                     revert(ptr, size)
37                 }
38                 default {
39                     return(ptr, size)
40                 }
41         }
42     }
43 
44     function proxyType() external virtual override pure returns (uint256 proxyTypeId) {
45         // Upgradeable proxy
46         proxyTypeId = 2;
47     }
48 
49     function implementation() external virtual override view returns (address);
50 }
51 
52 
53 // File contracts/common/Proxy/UpgradableProxy.sol
54 
55 pragma solidity 0.6.6;
56 contract UpgradableProxy is Proxy {
57     event ProxyUpdated(address indexed _new, address indexed _old);
58     event ProxyOwnerUpdate(address _new, address _old);
59 
60     bytes32 constant IMPLEMENTATION_SLOT = keccak256("matic.network.proxy.implementation");
61     bytes32 constant OWNER_SLOT = keccak256("matic.network.proxy.owner");
62 
63     constructor(address _proxyTo) public {
64         setProxyOwner(msg.sender);
65         setImplementation(_proxyTo);
66     }
67 
68     fallback() external payable {
69         delegatedFwd(loadImplementation(), msg.data);
70     }
71 
72     receive() external payable {
73         delegatedFwd(loadImplementation(), msg.data);
74     }
75 
76     modifier onlyProxyOwner() {
77         require(loadProxyOwner() == msg.sender, "NOT_OWNER");
78         _;
79     }
80 
81     function proxyOwner() external view returns(address) {
82         return loadProxyOwner();
83     }
84 
85     function loadProxyOwner() internal view returns(address) {
86         address _owner;
87         bytes32 position = OWNER_SLOT;
88         assembly {
89             _owner := sload(position)
90         }
91         return _owner;
92     }
93 
94     function implementation() external override view returns (address) {
95         return loadImplementation();
96     }
97 
98     function loadImplementation() internal view returns(address) {
99         address _impl;
100         bytes32 position = IMPLEMENTATION_SLOT;
101         assembly {
102             _impl := sload(position)
103         }
104         return _impl;
105     }
106 
107     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
108         require(newOwner != address(0), "ZERO_ADDRESS");
109         emit ProxyOwnerUpdate(newOwner, loadProxyOwner());
110         setProxyOwner(newOwner);
111     }
112 
113     function setProxyOwner(address newOwner) private {
114         bytes32 position = OWNER_SLOT;
115         assembly {
116             sstore(position, newOwner)
117         }
118     }
119 
120     function updateImplementation(address _newProxyTo) public onlyProxyOwner {
121         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
122         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
123 
124         emit ProxyUpdated(_newProxyTo, loadImplementation());
125         
126         setImplementation(_newProxyTo);
127     }
128 
129     function updateAndCall(address _newProxyTo, bytes memory data) payable public onlyProxyOwner {
130         updateImplementation(_newProxyTo);
131 
132         (bool success, bytes memory returnData) = address(this).call{value: msg.value}(data);
133         require(success, string(returnData));
134     }
135 
136     function setImplementation(address _newProxyTo) private {
137         bytes32 position = IMPLEMENTATION_SLOT;
138         assembly {
139             sstore(position, _newProxyTo)
140         }
141     }
142     
143     function isContract(address _target) internal view returns (bool) {
144         if (_target == address(0)) {
145             return false;
146         }
147 
148         uint256 size;
149         assembly {
150             size := extcodesize(_target)
151         }
152         return size > 0;
153     }
154 }
155 
156 
157 // File contracts/root/RootChainManager/RootChainManagerProxy.sol
158 
159 pragma solidity 0.6.6;
160 contract RootChainManagerProxy is UpgradableProxy {
161     constructor(address _proxyTo)
162         public
163         UpgradableProxy(_proxyTo)
164     {}
165 }