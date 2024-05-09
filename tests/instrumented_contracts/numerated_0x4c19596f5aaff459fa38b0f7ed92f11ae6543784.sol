1 // File: @trusttoken/trusttokens/contracts/Proxy/OwnedUpgradeabilityProxy.sol
2 
3 pragma solidity 0.5.13;
4 
5 /**
6  * @title OwnedUpgradeabilityProxy
7  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
8  */
9 contract OwnedUpgradeabilityProxy {
10     /**
11     * @dev Event to show ownership has been transferred
12     * @param previousOwner representing the address of the previous owner
13     * @param newOwner representing the address of the new owner
14     */
15     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18     * @dev Event to show ownership transfer is pending
19     * @param currentOwner representing the address of the current owner
20     * @param pendingOwner representing the address of the pending owner
21     */
22     event NewPendingOwner(address currentOwner, address pendingOwner);
23     
24     // Storage position of the owner and pendingOwner of the contract
25     bytes32 private constant proxyOwnerPosition = 0x6279e8199720cf3557ecd8b58d667c8edc486bd1cf3ad59ea9ebdfcae0d0dfac;//keccak256("trueUSD.proxy.owner");
26     bytes32 private constant pendingProxyOwnerPosition = 0x8ddbac328deee8d986ec3a7b933a196f96986cb4ee030d86cc56431c728b83f4;//keccak256("trueUSD.pending.proxy.owner");
27 
28     /**
29     * @dev the constructor sets the original owner of the contract to the sender account.
30     */
31     constructor() public {
32         _setUpgradeabilityOwner(msg.sender);
33     }
34 
35     /**
36     * @dev Throws if called by any account other than the owner.
37     */
38     modifier onlyProxyOwner() {
39         require(msg.sender == proxyOwner(), "only Proxy Owner");
40         _;
41     }
42 
43     /**
44     * @dev Throws if called by any account other than the pending owner.
45     */
46     modifier onlyPendingProxyOwner() {
47         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
48         _;
49     }
50 
51     /**
52     * @dev Tells the address of the owner
53     * @return the address of the owner
54     */
55     function proxyOwner() public view returns (address owner) {
56         bytes32 position = proxyOwnerPosition;
57         assembly {
58             owner := sload(position)
59         }
60     }
61 
62     /**
63     * @dev Tells the address of the owner
64     * @return the address of the owner
65     */
66     function pendingProxyOwner() public view returns (address pendingOwner) {
67         bytes32 position = pendingProxyOwnerPosition;
68         assembly {
69             pendingOwner := sload(position)
70         }
71     }
72 
73     /**
74     * @dev Sets the address of the owner
75     */
76     function _setUpgradeabilityOwner(address newProxyOwner) internal {
77         bytes32 position = proxyOwnerPosition;
78         assembly {
79             sstore(position, newProxyOwner)
80         }
81     }
82 
83     /**
84     * @dev Sets the address of the owner
85     */
86     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
87         bytes32 position = pendingProxyOwnerPosition;
88         assembly {
89             sstore(position, newPendingProxyOwner)
90         }
91     }
92 
93     /**
94     * @dev Allows the current owner to transfer control of the contract to a newOwner.
95     *changes the pending owner to newOwner. But doesn't actually transfer
96     * @param newOwner The address to transfer ownership to.
97     */
98     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
99         require(newOwner != address(0));
100         _setPendingUpgradeabilityOwner(newOwner);
101         emit NewPendingOwner(proxyOwner(), newOwner);
102     }
103 
104     /**
105     * @dev Allows the pendingOwner to claim ownership of the proxy
106     */
107     function claimProxyOwnership() external onlyPendingProxyOwner {
108         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
109         _setUpgradeabilityOwner(pendingProxyOwner());
110         _setPendingUpgradeabilityOwner(address(0));
111     }
112 
113     /**
114     * @dev Allows the proxy owner to upgrade the current version of the proxy.
115     * @param implementation representing the address of the new implementation to be set.
116     */
117     function upgradeTo(address implementation) public onlyProxyOwner {
118         address currentImplementation;
119         bytes32 position = implementationPosition;
120         assembly {
121             currentImplementation := sload(position)
122         }
123         require(currentImplementation != implementation);
124         assembly {
125           sstore(position, implementation)
126         }
127         emit Upgraded(implementation);
128     }
129     /**
130     * @dev This event will be emitted every time the implementation gets upgraded
131     * @param implementation representing the address of the upgraded implementation
132     */
133     event Upgraded(address indexed implementation);
134 
135     // Storage position of the address of the current implementation
136     bytes32 private constant implementationPosition = 0x6e41e0fbe643dfdb6043698bf865aada82dc46b953f754a3468eaa272a362dc7; //keccak256("trueUSD.proxy.implementation");
137 
138     function implementation() public view returns (address impl) {
139         bytes32 position = implementationPosition;
140         assembly {
141             impl := sload(position)
142         }
143     }
144 
145     /**
146     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
147     * This function will return whatever the implementation call returns
148     */
149     function() external payable {
150         bytes32 position = implementationPosition;
151         
152         assembly {
153             let ptr := mload(0x40)
154             calldatacopy(ptr, returndatasize, calldatasize)
155             let result := delegatecall(gas, sload(position), ptr, calldatasize, returndatasize, returndatasize)
156             returndatacopy(ptr, 0, returndatasize)
157 
158             switch result
159             case 0 { revert(ptr, returndatasize) }
160             default { return(ptr, returndatasize) }
161         }
162     }
163 }
164 
165 // File: @trusttoken/trusttokens/contracts/Proxy/TimeOwnedUpgradeabilityProxy.sol
166 
167 pragma solidity 0.5.13;
168 
169 
170 /**
171  * @title TimeOwnedUpgradeabilityProxy
172  * @dev This contract combines an upgradeability proxy with
173  * basic authorization control functionalities
174  *
175  * This contract allows us to specify a time at which the proxy can no longer
176  * be upgraded
177  */
178 contract TimeOwnedUpgradeabilityProxy is OwnedUpgradeabilityProxy {
179 
180     bytes32 private constant expirationPosition = bytes32(uint256(keccak256('trusttoken.expiration')) - 1);
181 
182     /**
183     * @dev the constructor sets the original owner of the contract to the sender account.
184     */
185     constructor() public {
186         _setUpgradeabilityOwner(msg.sender);
187         // set expiration to ~4 months from now
188         _setExpiration(block.timestamp + 124 days);
189     }
190 
191     /**
192      * @dev sets new expiration time
193     */
194     function setExpiration(uint256 newExpirationTime) external onlyProxyOwner {
195         require(block.timestamp < expiration(), "after expiration time");
196         require(block.timestamp < newExpirationTime, "new expiration time must be in the future");
197         _setExpiration(newExpirationTime);
198     }
199 
200     function _setExpiration(uint256 newExpirationTime) internal onlyProxyOwner {
201         bytes32 position = expirationPosition;
202         assembly {
203             sstore(position, newExpirationTime)
204         }
205     }
206 
207     function expiration() public view returns (uint256 _expiration) {
208         bytes32 position = expirationPosition;
209         assembly {
210             _expiration := sload(position)
211         }
212     }
213 
214     /**
215     * @dev Allows the proxy owner to upgrade the current version of the proxy.
216     * @param implementation representing the address of the new implementation to be set.
217     */
218     function upgradeTo(address implementation) public onlyProxyOwner {
219         require(block.timestamp < expiration(), "after expiration date");
220         super.upgradeTo(implementation);
221     }
222 }