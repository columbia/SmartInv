1 pragma solidity 0.5.17;
2 
3 
4 interface IERCProxy {
5     function proxyType() external pure returns (uint proxyTypeId);
6     function implementation() external view returns (address codeAddr);
7 }
8 
9 contract Proxy is IERCProxy {
10     function delegatedFwd(address _dst, bytes memory _calldata) internal {
11         // solium-disable-next-line security/no-inline-assembly
12         assembly {
13             let result := delegatecall(
14                 sub(gas(), 10000),
15                 _dst,
16                 add(_calldata, 0x20),
17                 mload(_calldata),
18                 0,
19                 0
20             )
21             let size := returndatasize()
22 
23             let ptr := mload(0x40)
24             returndatacopy(ptr, 0, size)
25 
26             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
27             // if the call returned error data, forward it
28             switch result
29                 case 0 {
30                     revert(ptr, size)
31                 }
32                 default {
33                     return(ptr, size)
34                 }
35         }
36     }
37 
38     function proxyType() external pure returns (uint proxyTypeId) {
39         // Upgradeable proxy
40         proxyTypeId = 2;
41     }
42 
43     function implementation() public view returns (address);
44 }
45 
46 contract OwnableProxy {
47     bytes32 constant OWNER_SLOT = keccak256("proxy.owner");
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor() internal {
52         _transferOwnership(msg.sender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns(address _owner) {
59         bytes32 position = OWNER_SLOT;
60         assembly {
61             _owner := sload(position)
62         }
63     }
64 
65     modifier onlyOwner() {
66         require(isOwner(), "NOT_OWNER");
67         _;
68     }
69 
70     function isOwner() public view returns (bool) {
71         return owner() == msg.sender;
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      */
77     function transferOwnership(address newOwner) public onlyOwner {
78         _transferOwnership(newOwner);
79     }
80 
81     function _transferOwnership(address newOwner) internal {
82         require(newOwner != address(0), "OwnableProxy: new owner is the zero address");
83         emit OwnershipTransferred(owner(), newOwner);
84         bytes32 position = OWNER_SLOT;
85         assembly {
86             sstore(position, newOwner)
87         }
88     }
89 }
90 
91 contract UpgradableProxy is OwnableProxy, Proxy {
92     bytes32 constant IMPLEMENTATION_SLOT = keccak256("proxy.implementation");
93 
94     event ProxyUpdated(address indexed previousImpl, address indexed newImpl);
95 
96     function() external payable {
97         delegatedFwd(implementation(), msg.data);
98     }
99 
100     function implementation() public view returns(address _impl) {
101         bytes32 position = IMPLEMENTATION_SLOT;
102         assembly {
103             _impl := sload(position)
104         }
105     }
106 
107     // ACLed on onlyOwner via the call to updateImplementation()
108     function updateAndCall(address _newProxyTo, bytes memory data) public {
109         updateImplementation(_newProxyTo);
110         // sometimes required to initialize the contract
111         (bool success, bytes memory returnData) = address(this).call(data);
112         require(success, string(returnData));
113     }
114 
115     function updateImplementation(address _newProxyTo) public onlyOwner {
116         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
117         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
118         emit ProxyUpdated(implementation(), _newProxyTo);
119         setImplementation(_newProxyTo);
120     }
121 
122     function setImplementation(address _newProxyTo) private {
123         bytes32 position = IMPLEMENTATION_SLOT;
124         assembly {
125             sstore(position, _newProxyTo)
126         }
127     }
128 
129     function isContract(address _target) internal view returns (bool) {
130         if (_target == address(0)) {
131             return false;
132         }
133         uint size;
134         assembly {
135             size := extcodesize(_target)
136         }
137         return size > 0;
138     }
139 }
140 
141 contract ibDUSDProxy is UpgradableProxy {
142 
143     function name() public pure returns (string memory) {
144         return "interest-bearing DUSD";
145     }
146 
147     function symbol() public pure returns (string memory) {
148         return "ibDUSD";
149     }
150 
151     /* NOTE: This information is only used for _display_ purposes: it in
152      * no way affects any of the arithmetic of the contract, including
153      * {IERC20-balanceOf} and {IERC20-transfer}.
154      */
155     function decimals() public pure returns (uint8) {
156         return 18;
157     }
158 }