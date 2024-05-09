1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Proxy/Proxy.sol
4 
5 /**
6  * @title Proxy
7  * @dev Gives the possibility to delegate any call to a foreign implementation.
8  */
9 contract Proxy {
10     
11     /**
12     * @dev Tells the address of the implementation where every call will be delegated.
13     * @return address of the implementation to which it will be delegated
14     */
15     function implementation() public view returns (address);
16 
17     /**
18     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
19     * This function will return whatever the implementation call returns
20     */
21     function() external payable {
22         address _impl = implementation();
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
38 // File: contracts/Proxy/UpgradeabilityProxy.sol
39 
40 /**
41  * @title UpgradeabilityProxy
42  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
43  */
44 contract UpgradeabilityProxy is Proxy {
45     /**
46     * @dev This event will be emitted every time the implementation gets upgraded
47     * @param implementation representing the address of the upgraded implementation
48     */
49     event Upgraded(address indexed implementation);
50 
51     // Storage position of the address of the current implementation
52     bytes32 private constant implementationPosition = 0xdc8e328a3c0acffa7969856957539d0f8c2deaa0d39abaf20397a9fa3b45bf17; //keccak256("trueGBP.proxy.implementation");
53 
54     /**
55     * @dev Tells the address of the current implementation
56     * @return address of the current implementation
57     */
58     function implementation() public view returns (address impl) {
59         bytes32 position = implementationPosition;
60         assembly {
61           impl := sload(position)
62         }
63     }
64 
65     /**
66     * @dev Sets the address of the current implementation
67     * @param newImplementation address representing the new implementation to be set
68     */
69     function _setImplementation(address newImplementation) internal {
70         bytes32 position = implementationPosition;
71         assembly {
72           sstore(position, newImplementation)
73         }
74     }
75 
76     /**
77     * @dev Upgrades the implementation address
78     * @param newImplementation representing the address of the new implementation to be set
79     */
80     function _upgradeTo(address newImplementation) internal {
81         address currentImplementation = implementation();
82         require(currentImplementation != newImplementation);
83         _setImplementation(newImplementation);
84         emit Upgraded(newImplementation);
85     }
86 }
87 
88 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
89 
90 /**
91  * @title OwnedUpgradeabilityProxy
92  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
93  */
94 contract TGBPController is UpgradeabilityProxy {
95     /**
96     * @dev Event to show ownership has been transferred
97     * @param previousOwner representing the address of the previous owner
98     * @param newOwner representing the address of the new owner
99     */
100     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     /**
103     * @dev Event to show ownership transfer is pending
104     * @param currentOwner representing the address of the current owner
105     * @param pendingOwner representing the address of the pending owner
106     */
107     event NewPendingOwner(address currentOwner, address pendingOwner);
108     
109     // Storage position of the owner and pendingOwner of the contract
110     bytes32 private constant proxyOwnerPosition = 0x58709042d6c9a2b64c8e7802bfedabdcd2eaecc68e15ef2e896a5970c608cd16;//keccak256("trueGBP.proxy.owner");
111     bytes32 private constant pendingProxyOwnerPosition = 0xa6933dbb41d1bc3d681619c11234027db3b75954220aa88dfdc74750053ed30c;//keccak256("trueGBP.pending.proxy.owner");
112 
113     /**
114     * @dev the constructor sets the original owner of the contract to the sender account.
115     */
116     constructor() public {
117         _setUpgradeabilityOwner(msg.sender);
118     }
119 
120     /**
121     * @dev Throws if called by any account other than the owner.
122     */
123     modifier onlyProxyOwner() {
124         require(msg.sender == proxyOwner(), "only Proxy Owner");
125         _;
126     }
127 
128     /**
129     * @dev Throws if called by any account other than the pending owner.
130     */
131     modifier onlyPendingProxyOwner() {
132         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
133         _;
134     }
135 
136     /**
137     * @dev Tells the address of the owner
138     * @return the address of the owner
139     */
140     function proxyOwner() public view returns (address owner) {
141         bytes32 position = proxyOwnerPosition;
142         assembly {
143             owner := sload(position)
144         }
145     }
146 
147     /**
148     * @dev Tells the address of the owner
149     * @return the address of the owner
150     */
151     function pendingProxyOwner() public view returns (address pendingOwner) {
152         bytes32 position = pendingProxyOwnerPosition;
153         assembly {
154             pendingOwner := sload(position)
155         }
156     }
157 
158     /**
159     * @dev Sets the address of the owner
160     */
161     function _setUpgradeabilityOwner(address newProxyOwner) internal {
162         bytes32 position = proxyOwnerPosition;
163         assembly {
164             sstore(position, newProxyOwner)
165         }
166     }
167 
168     /**
169     * @dev Sets the address of the owner
170     */
171     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
172         bytes32 position = pendingProxyOwnerPosition;
173         assembly {
174             sstore(position, newPendingProxyOwner)
175         }
176     }
177 
178     /**
179     * @dev Allows the current owner to transfer control of the contract to a newOwner.
180     *changes the pending owner to newOwner. But doesn't actually transfer
181     * @param newOwner The address to transfer ownership to.
182     */
183     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
184         require(newOwner != address(0));
185         _setPendingUpgradeabilityOwner(newOwner);
186         emit NewPendingOwner(proxyOwner(), newOwner);
187     }
188 
189     /**
190     * @dev Allows the pendingOwner to claim ownership of the proxy
191     */
192     function claimProxyOwnership() external onlyPendingProxyOwner {
193         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
194         _setUpgradeabilityOwner(pendingProxyOwner());
195         _setPendingUpgradeabilityOwner(address(0));
196     }
197 
198     /**
199     * @dev Allows the proxy owner to upgrade the current version of the proxy.
200     * @param implementation representing the address of the new implementation to be set.
201     */
202     function upgradeTo(address implementation) external onlyProxyOwner {
203         _upgradeTo(implementation);
204     }
205 }