1 // File: contracts/common/Proxy/IERCProxy.sol
2 
3 pragma solidity 0.6.6;
4 
5 interface IERCProxy {
6     function proxyType() external pure returns (uint256 proxyTypeId);
7 
8     function implementation() external view returns (address codeAddr);
9 }
10 
11 // File: contracts/common/Proxy/Proxy.sol
12 
13 pragma solidity 0.6.6;
14 
15 
16 abstract contract Proxy is IERCProxy {
17     function delegatedFwd(address _dst, bytes memory _calldata) internal {
18         // solium-disable-next-line security/no-inline-assembly
19         assembly {
20             let result := delegatecall(
21                 sub(gas(), 10000),
22                 _dst,
23                 add(_calldata, 0x20),
24                 mload(_calldata),
25                 0,
26                 0
27             )
28             let size := returndatasize()
29 
30             let ptr := mload(0x40)
31             returndatacopy(ptr, 0, size)
32 
33             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
34             // if the call returned error data, forward it
35             switch result
36                 case 0 {
37                     revert(ptr, size)
38                 }
39                 default {
40                     return(ptr, size)
41                 }
42         }
43     }
44 
45     function proxyType() external virtual override pure returns (uint256 proxyTypeId) {
46         // Upgradeable proxy
47         proxyTypeId = 2;
48     }
49 
50     function implementation() external virtual override view returns (address);
51 }
52 
53 // File: contracts/common/Proxy/UpgradableProxy.sol
54 
55 pragma solidity 0.6.6;
56 
57 
58 contract UpgradableProxy is Proxy {
59     event ProxyUpdated(address indexed _new, address indexed _old);
60     event ProxyOwnerUpdate(address _new, address _old);
61 
62     bytes32 constant IMPLEMENTATION_SLOT = keccak256("matic.network.proxy.implementation");
63     bytes32 constant OWNER_SLOT = keccak256("matic.network.proxy.owner");
64 
65     constructor(address _proxyTo) public {
66         setProxyOwner(msg.sender);
67         setImplementation(_proxyTo);
68     }
69 
70     fallback() external payable {
71         delegatedFwd(loadImplementation(), msg.data);
72     }
73 
74     receive() external payable {
75         delegatedFwd(loadImplementation(), msg.data);
76     }
77 
78     modifier onlyProxyOwner() {
79         require(loadProxyOwner() == msg.sender, "NOT_OWNER");
80         _;
81     }
82 
83     function proxyOwner() external view returns(address) {
84         return loadProxyOwner();
85     }
86 
87     function loadProxyOwner() internal view returns(address) {
88         address _owner;
89         bytes32 position = OWNER_SLOT;
90         assembly {
91             _owner := sload(position)
92         }
93         return _owner;
94     }
95 
96     function implementation() external override view returns (address) {
97         return loadImplementation();
98     }
99 
100     function loadImplementation() internal view returns(address) {
101         address _impl;
102         bytes32 position = IMPLEMENTATION_SLOT;
103         assembly {
104             _impl := sload(position)
105         }
106         return _impl;
107     }
108 
109     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
110         require(newOwner != address(0), "ZERO_ADDRESS");
111         emit ProxyOwnerUpdate(newOwner, loadProxyOwner());
112         setProxyOwner(newOwner);
113     }
114 
115     function setProxyOwner(address newOwner) private {
116         bytes32 position = OWNER_SLOT;
117         assembly {
118             sstore(position, newOwner)
119         }
120     }
121 
122     function updateImplementation(address _newProxyTo) public onlyProxyOwner {
123         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
124         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
125 
126         emit ProxyUpdated(_newProxyTo, loadImplementation());
127         
128         setImplementation(_newProxyTo);
129     }
130 
131     function updateAndCall(address _newProxyTo, bytes memory data) payable public onlyProxyOwner {
132         updateImplementation(_newProxyTo);
133 
134         (bool success, bytes memory returnData) = address(this).call{value: msg.value}(data);
135         require(success, string(returnData));
136     }
137 
138     function setImplementation(address _newProxyTo) private {
139         bytes32 position = IMPLEMENTATION_SLOT;
140         assembly {
141             sstore(position, _newProxyTo)
142         }
143     }
144     
145     function isContract(address _target) internal view returns (bool) {
146         if (_target == address(0)) {
147             return false;
148         }
149 
150         uint256 size;
151         assembly {
152             size := extcodesize(_target)
153         }
154         return size > 0;
155     }
156 }
157 
158 // File: contracts/root/RootChainManager/RootChainManagerProxy.sol
159 
160 pragma solidity 0.6.6;
161 
162 
163 contract RootChainManagerProxy is UpgradableProxy {
164     constructor(address _proxyTo)
165         public
166         UpgradableProxy(_proxyTo)
167     {}
168 }