1 pragma solidity 0.5.8;
2 
3 
4 /**
5  * @title Proxy
6  * @dev This is the proxy contract for the DUSDToken Registry
7  */
8 contract Proxy {
9     
10     /**
11     * @dev Tell the address of the implementation where every call will be delegated.
12     * @return address of the implementation to which it will be delegated
13     */
14     function implementation() public view returns (address);
15 
16     /**
17     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
18     * This function will return whatever the implementation call returns.
19     */
20     function() external payable {
21         address _impl = implementation();
22         require(_impl != address(0), "implementation contract not set");
23         
24         assembly {
25             let ptr := mload(0x40)
26             calldatacopy(ptr, 0, calldatasize)
27             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
28             let size := returndatasize
29             returndatacopy(ptr, 0, size)
30 
31             switch result
32             case 0 { revert(ptr, size) }
33             default { return(ptr, size) }
34         }
35     }
36 }
37 
38 
39 /**
40  * @title UpgradeabilityProxy
41  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded.
42  */
43 contract UpgradeabilityProxy is Proxy {
44 
45     // Event, it will be emitted every time the implementation gets upgraded.
46     event Upgraded(address indexed currentImplementation, address indexed newImplementation);
47 
48     // Storage position of the address of the current implementation
49     bytes32 private constant implementationPosition = keccak256("DUSD.proxy.implementation");
50 
51     /**
52     * @dev Return to the current implementation.
53     */
54     function implementation() public view returns (address impl) {
55         bytes32 position = implementationPosition;
56         assembly {
57           impl := sload(position)
58         }
59     }
60 
61     /**
62     * @dev Set the address of the current implementation.
63     * @param newImplementation address representing the new implementation to be set.
64     */
65     function _setImplementation(address newImplementation) internal {
66         bytes32 position = implementationPosition;
67         assembly {
68           sstore(position, newImplementation)
69         }
70     }
71 
72     /**
73     * @dev Upgrade the implementation address.
74     * @param newImplementation representing the address of the new implementation to be set.
75     */
76     function _upgradeTo(address newImplementation) internal {
77         address currentImplementation = implementation();
78         require(currentImplementation != newImplementation);
79         emit Upgraded(currentImplementation, newImplementation);
80         _setImplementation(newImplementation);
81     }
82 }
83 
84 
85 /**
86  * @title DUSDProxy
87  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
88  */
89 contract DUSDProxy is UpgradeabilityProxy {
90 
91     // Event to show ownership has been transferred.
92     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     // Event to show ownership transfer is pending.
95     event NewPendingOwner(address currentOwner, address pendingOwner);
96     
97     // Storage position of the owner and pendingOwner of the contract.
98     bytes32 private constant proxyOwnerPosition = keccak256("DUSD.proxy.owner");
99     bytes32 private constant pendingProxyOwnerPosition = keccak256("DUSD.pending.proxy.owner");
100 
101     /**
102     * @dev The constructor sets the original owner of the contract to the sender account.
103     */
104     constructor() public {
105         _setUpgradeabilityOwner(0xfe30e619cc2915C905Ca45C1BA8311109A3cBdB1);
106     }
107 
108     /**
109     * @dev Throw if called by any account other than the proxy owner.
110     */
111     modifier onlyProxyOwner() {
112         require(msg.sender == proxyOwner(), "only Proxy Owner");
113         _;
114     }
115 
116     /**
117     * @dev Throw if called by any account other than the pending owner.
118     */
119     modifier onlyPendingProxyOwner() {
120         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
121         _;
122     }
123 
124     /**
125     * @dev Return the address of the proxy owner.
126     * @return The address of the proxy owner.
127     */
128     function proxyOwner() public view returns (address owner) {
129         bytes32 position = proxyOwnerPosition;
130         assembly {
131             owner := sload(position)
132         }
133     }
134 
135     /**
136     * @dev Return the address of the pending proxy owner.
137     * @return The address of the pending proxy owner.
138     */
139     function pendingProxyOwner() public view returns (address pendingOwner) {
140         bytes32 position = pendingProxyOwnerPosition;
141         assembly {
142             pendingOwner := sload(position)
143         }
144     }
145 
146     /**
147     * @dev Set the address of the proxy owner.
148     */
149     function _setUpgradeabilityOwner(address newProxyOwner) internal {
150         bytes32 position = proxyOwnerPosition;
151         assembly {
152             sstore(position, newProxyOwner)
153         }
154     }
155 
156     /**
157     * @dev Set the address of the pending proxy owner.
158     */
159     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
160         bytes32 position = pendingProxyOwnerPosition;
161         assembly {
162             sstore(position, newPendingProxyOwner)
163         }
164     }
165 
166     /**
167     * @dev Change the owner of the proxy.
168     * @param newOwner The address to transfer ownership to.
169     */
170     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
171         require(newOwner != address(0));
172         _setPendingUpgradeabilityOwner(newOwner);
173         emit NewPendingOwner(proxyOwner(), newOwner);
174     }
175 
176     /**
177     * @dev Allow the pendingOwner to claim ownership of the proxy.
178     */
179     function claimProxyOwnership() external onlyPendingProxyOwner {
180         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
181         _setUpgradeabilityOwner(pendingProxyOwner());
182         _setPendingUpgradeabilityOwner(address(0));
183     }
184 
185     /**
186     * @dev Allow the proxy owner to upgrade the current version of the proxy.
187     * @param implementation representing the address of the new implementation to be set.
188     */
189     function upgradeTo(address implementation) external onlyProxyOwner {
190         _upgradeTo(implementation);
191     }
192 }