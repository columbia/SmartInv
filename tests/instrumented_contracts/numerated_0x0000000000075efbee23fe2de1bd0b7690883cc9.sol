1 /**
2  *Submitted for verification at Etherscan.io on 2018-12-18
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 // This is the proxy contract for the TrustToken Registry
8 
9 // File: contracts/Proxy/Proxy.sol
10 
11 /**
12  * @title Proxy
13  * @dev Gives the possibility to delegate any call to a foreign implementation.
14  */
15 contract Proxy {
16     
17     /**
18     * @dev Tells the address of the implementation where every call will be delegated.
19     * @return address of the implementation to which it will be delegated
20     */
21     function implementation() public view returns (address);
22 
23     /**
24     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
25     * This function will return whatever the implementation call returns
26     */
27     function() external payable {
28         address _impl = implementation();
29         require(_impl != address(0), "implementation contract not set");
30         
31         assembly {
32             let ptr := mload(0x40)
33             calldatacopy(ptr, 0, calldatasize)
34             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
35             let size := returndatasize
36             returndatacopy(ptr, 0, size)
37 
38             switch result
39             case 0 { revert(ptr, size) }
40             default { return(ptr, size) }
41         }
42     }
43 }
44 
45 // File: contracts/Proxy/UpgradeabilityProxy.sol
46 
47 /**
48  * @title UpgradeabilityProxy
49  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
50  */
51 contract UpgradeabilityProxy is Proxy {
52     /**
53     * @dev This event will be emitted every time the implementation gets upgraded
54     * @param implementation representing the address of the upgraded implementation
55     */
56     event Upgraded(address indexed implementation);
57 
58     // Storage position of the address of the current implementation
59     bytes32 private constant implementationPosition = keccak256("trueUSD.proxy.implementation");
60 
61     /**
62     * @dev Tells the address of the current implementation
63     * @return address of the current implementation
64     */
65     function implementation() public view returns (address impl) {
66         bytes32 position = implementationPosition;
67         assembly {
68           impl := sload(position)
69         }
70     }
71 
72     /**
73     * @dev Sets the address of the current implementation
74     * @param newImplementation address representing the new implementation to be set
75     */
76     function _setImplementation(address newImplementation) internal {
77         bytes32 position = implementationPosition;
78         assembly {
79           sstore(position, newImplementation)
80         }
81     }
82 
83     /**
84     * @dev Upgrades the implementation address
85     * @param newImplementation representing the address of the new implementation to be set
86     */
87     function _upgradeTo(address newImplementation) internal {
88         address currentImplementation = implementation();
89         require(currentImplementation != newImplementation);
90         _setImplementation(newImplementation);
91         emit Upgraded(newImplementation);
92     }
93 }
94 
95 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
96 
97 /**
98  * @title OwnedUpgradeabilityProxy
99  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
100  */
101 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
102     /**
103     * @dev Event to show ownership has been transferred
104     * @param previousOwner representing the address of the previous owner
105     * @param newOwner representing the address of the new owner
106     */
107     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     /**
110     * @dev Event to show ownership transfer is pending
111     * @param currentOwner representing the address of the current owner
112     * @param pendingOwner representing the address of the pending owner
113     */
114     event NewPendingOwner(address currentOwner, address pendingOwner);
115     
116     // Storage position of the owner and pendingOwner of the contract
117     bytes32 private constant proxyOwnerPosition = keccak256("trueUSD.proxy.owner");
118     bytes32 private constant pendingProxyOwnerPosition = keccak256("trueUSD.pending.proxy.owner");
119 
120     /**
121     * @dev the constructor sets the original owner of the contract to the sender account.
122     */
123     constructor() public {
124         _setUpgradeabilityOwner(msg.sender);
125     }
126 
127     /**
128     * @dev Throws if called by any account other than the owner.
129     */
130     modifier onlyProxyOwner() {
131         require(msg.sender == proxyOwner(), "only Proxy Owner");
132         _;
133     }
134 
135     /**
136     * @dev Throws if called by any account other than the pending owner.
137     */
138     modifier onlyPendingProxyOwner() {
139         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
140         _;
141     }
142 
143     /**
144     * @dev Tells the address of the owner
145     * @return the address of the owner
146     */
147     function proxyOwner() public view returns (address owner) {
148         bytes32 position = proxyOwnerPosition;
149         assembly {
150             owner := sload(position)
151         }
152     }
153 
154     /**
155     * @dev Tells the address of the owner
156     * @return the address of the owner
157     */
158     function pendingProxyOwner() public view returns (address pendingOwner) {
159         bytes32 position = pendingProxyOwnerPosition;
160         assembly {
161             pendingOwner := sload(position)
162         }
163     }
164 
165     /**
166     * @dev Sets the address of the owner
167     */
168     function _setUpgradeabilityOwner(address newProxyOwner) internal {
169         bytes32 position = proxyOwnerPosition;
170         assembly {
171             sstore(position, newProxyOwner)
172         }
173     }
174 
175     /**
176     * @dev Sets the address of the owner
177     */
178     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
179         bytes32 position = pendingProxyOwnerPosition;
180         assembly {
181             sstore(position, newPendingProxyOwner)
182         }
183     }
184 
185     /**
186     * @dev Allows the current owner to transfer control of the contract to a newOwner.
187     *changes the pending owner to newOwner. But doesn't actually transfer
188     * @param newOwner The address to transfer ownership to.
189     */
190     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
191         require(newOwner != address(0));
192         _setPendingUpgradeabilityOwner(newOwner);
193         emit NewPendingOwner(proxyOwner(), newOwner);
194     }
195 
196     /**
197     * @dev Allows the pendingOwner to claim ownership of the proxy
198     */
199     function claimProxyOwnership() external onlyPendingProxyOwner {
200         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
201         _setUpgradeabilityOwner(pendingProxyOwner());
202         _setPendingUpgradeabilityOwner(address(0));
203     }
204 
205     /**
206     * @dev Allows the proxy owner to upgrade the current version of the proxy.
207     * @param implementation representing the address of the new implementation to be set.
208     */
209     function upgradeTo(address implementation) external onlyProxyOwner {
210         _upgradeTo(implementation);
211     }
212 }