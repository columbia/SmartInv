1 pragma solidity 0.6.6;
2 
3 
4 interface IERCProxy {
5     function proxyType() external pure returns (uint256 proxyTypeId);
6 
7     function implementation() external view returns (address codeAddr);
8 }
9 
10 
11 
12 abstract contract Proxy is IERCProxy {
13     function delegatedFwd(address _dst, bytes memory _calldata) internal {
14         // solium-disable-next-line security/no-inline-assembly
15         assembly {
16             let result := delegatecall(
17                 sub(gas(), 10000),
18                 _dst,
19                 add(_calldata, 0x20),
20                 mload(_calldata),
21                 0,
22                 0
23             )
24             let size := returndatasize()
25 
26             let ptr := mload(0x40)
27             returndatacopy(ptr, 0, size)
28 
29             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
30             // if the call returned error data, forward it
31             switch result
32                 case 0 {
33                     revert(ptr, size)
34                 }
35                 default {
36                     return(ptr, size)
37                 }
38         }
39     }
40 
41     function proxyType() external virtual override pure returns (uint256 proxyTypeId) {
42         // Upgradeable proxy
43         proxyTypeId = 2;
44     }
45 
46     function implementation() external virtual override view returns (address);
47 }
48 
49 
50 
51 contract UpgradableProxy is Proxy {
52     event ProxyUpdated(address indexed _new, address indexed _old);
53     event ProxyOwnerUpdate(address _new, address _old);
54 
55     bytes32 constant IMPLEMENTATION_SLOT = keccak256("matic.network.proxy.implementation");
56     bytes32 constant OWNER_SLOT = keccak256("matic.network.proxy.owner");
57 
58     constructor(address _proxyTo) public {
59         setProxyOwner(msg.sender);
60         setImplementation(_proxyTo);
61     }
62 
63     fallback() external payable {
64         delegatedFwd(loadImplementation(), msg.data);
65     }
66 
67     receive() external payable {
68         delegatedFwd(loadImplementation(), msg.data);
69     }
70 
71     modifier onlyProxyOwner() {
72         require(loadProxyOwner() == msg.sender, "NOT_OWNER");
73         _;
74     }
75 
76     function proxyOwner() external view returns(address) {
77         return loadProxyOwner();
78     }
79 
80     function loadProxyOwner() internal view returns(address) {
81         address _owner;
82         bytes32 position = OWNER_SLOT;
83         assembly {
84             _owner := sload(position)
85         }
86         return _owner;
87     }
88 
89     function implementation() external override view returns (address) {
90         return loadImplementation();
91     }
92 
93     function loadImplementation() internal view returns(address) {
94         address _impl;
95         bytes32 position = IMPLEMENTATION_SLOT;
96         assembly {
97             _impl := sload(position)
98         }
99         return _impl;
100     }
101 
102     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
103         require(newOwner != address(0), "ZERO_ADDRESS");
104         emit ProxyOwnerUpdate(newOwner, loadProxyOwner());
105         setProxyOwner(newOwner);
106     }
107 
108     function setProxyOwner(address newOwner) private {
109         bytes32 position = OWNER_SLOT;
110         assembly {
111             sstore(position, newOwner)
112         }
113     }
114 
115     function updateImplementation(address _newProxyTo) public onlyProxyOwner {
116         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
117         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
118 
119         emit ProxyUpdated(_newProxyTo, loadImplementation());
120         
121         setImplementation(_newProxyTo);
122     }
123 
124     function updateAndCall(address _newProxyTo, bytes memory data) payable public onlyProxyOwner {
125         updateImplementation(_newProxyTo);
126 
127         (bool success, bytes memory returnData) = address(this).call{value: msg.value}(data);
128         require(success, string(returnData));
129     }
130 
131     function setImplementation(address _newProxyTo) private {
132         bytes32 position = IMPLEMENTATION_SLOT;
133         assembly {
134             sstore(position, _newProxyTo)
135         }
136     }
137     
138     function isContract(address _target) internal view returns (bool) {
139         if (_target == address(0)) {
140             return false;
141         }
142 
143         uint256 size;
144         assembly {
145             size := extcodesize(_target)
146         }
147         return size > 0;
148     }
149 }
150 
151 
152 
153 contract RootChainManagerProxy is UpgradableProxy {
154     constructor(address _proxyTo)
155         public
156         UpgradableProxy(_proxyTo)
157     {}
158 }