1 pragma solidity ^0.4.23;
2 
3 // This is the proxy contract for the TrustToken Registry
4 
5 // File: contracts/Proxy/Proxy.sol
6 
7 /**
8  * @title Proxy
9  * @dev Gives the possibility to delegate any call to a foreign implementation.
10  */
11 contract Proxy {
12     
13     /**
14     * @dev Tells the address of the implementation where every call will be delegated.
15     * @return address of the implementation to which it will be delegated
16     */
17     function implementation() public view returns (address);
18 
19     /**
20     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
21     * This function will return whatever the implementation call returns
22     */
23     function() external payable {
24         address _impl = implementation();
25         require(_impl != address(0), "implementation contract not set");
26         
27         assembly {
28             let ptr := mload(0x40)
29             calldatacopy(ptr, 0, calldatasize)
30             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
31             let size := returndatasize
32             returndatacopy(ptr, 0, size)
33 
34             switch result
35             case 0 { revert(ptr, size) }
36             default { return(ptr, size) }
37         }
38     }
39 }
40 
41 // File: contracts/Proxy/UpgradeabilityProxy.sol
42 
43 /**
44  * @title UpgradeabilityProxy
45  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
46  */
47 contract UpgradeabilityProxy is Proxy {
48     /**
49     * @dev This event will be emitted every time the implementation gets upgraded
50     * @param implementation representing the address of the upgraded implementation
51     */
52     event Upgraded(address indexed implementation);
53 
54     // Storage position of the address of the current implementation
55     bytes32 private constant implementationPosition = keccak256("trueUSD.proxy.implementation");
56 
57     /**
58     * @dev Tells the address of the current implementation
59     * @return address of the current implementation
60     */
61     function implementation() public view returns (address impl) {
62         bytes32 position = implementationPosition;
63         assembly {
64           impl := sload(position)
65         }
66     }
67 
68     /**
69     * @dev Sets the address of the current implementation
70     * @param newImplementation address representing the new implementation to be set
71     */
72     function _setImplementation(address newImplementation) internal {
73         bytes32 position = implementationPosition;
74         assembly {
75           sstore(position, newImplementation)
76         }
77     }
78 
79     /**
80     * @dev Upgrades the implementation address
81     * @param newImplementation representing the address of the new implementation to be set
82     */
83     function _upgradeTo(address newImplementation) internal {
84         address currentImplementation = implementation();
85         require(currentImplementation != newImplementation);
86         _setImplementation(newImplementation);
87         emit Upgraded(newImplementation);
88     }
89 }
90 
91 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
92 
93 /**
94  * @title OwnedUpgradeabilityProxy
95  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
96  */
97 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
98     /**
99     * @dev Event to show ownership has been transferred
100     * @param previousOwner representing the address of the previous owner
101     * @param newOwner representing the address of the new owner
102     */
103     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106     * @dev Event to show ownership transfer is pending
107     * @param currentOwner representing the address of the current owner
108     * @param pendingOwner representing the address of the pending owner
109     */
110     event NewPendingOwner(address currentOwner, address pendingOwner);
111     
112     // Storage position of the owner and pendingOwner of the contract
113     bytes32 private constant proxyOwnerPosition = keccak256("trueUSD.proxy.owner");
114     bytes32 private constant pendingProxyOwnerPosition = keccak256("trueUSD.pending.proxy.owner");
115 
116     /**
117     * @dev the constructor sets the original owner of the contract to the sender account.
118     */
119     constructor() public {
120         _setUpgradeabilityOwner(msg.sender);
121     }
122 
123     /**
124     * @dev Throws if called by any account other than the owner.
125     */
126     modifier onlyProxyOwner() {
127         require(msg.sender == proxyOwner(), "only Proxy Owner");
128         _;
129     }
130 
131     /**
132     * @dev Throws if called by any account other than the pending owner.
133     */
134     modifier onlyPendingProxyOwner() {
135         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
136         _;
137     }
138 
139     /**
140     * @dev Tells the address of the owner
141     * @return the address of the owner
142     */
143     function proxyOwner() public view returns (address owner) {
144         bytes32 position = proxyOwnerPosition;
145         assembly {
146             owner := sload(position)
147         }
148     }
149 
150     /**
151     * @dev Tells the address of the owner
152     * @return the address of the owner
153     */
154     function pendingProxyOwner() public view returns (address pendingOwner) {
155         bytes32 position = pendingProxyOwnerPosition;
156         assembly {
157             pendingOwner := sload(position)
158         }
159     }
160 
161     /**
162     * @dev Sets the address of the owner
163     */
164     function _setUpgradeabilityOwner(address newProxyOwner) internal {
165         bytes32 position = proxyOwnerPosition;
166         assembly {
167             sstore(position, newProxyOwner)
168         }
169     }
170 
171     /**
172     * @dev Sets the address of the owner
173     */
174     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
175         bytes32 position = pendingProxyOwnerPosition;
176         assembly {
177             sstore(position, newPendingProxyOwner)
178         }
179     }
180 
181     /**
182     * @dev Allows the current owner to transfer control of the contract to a newOwner.
183     *changes the pending owner to newOwner. But doesn't actually transfer
184     * @param newOwner The address to transfer ownership to.
185     */
186     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
187         require(newOwner != address(0));
188         _setPendingUpgradeabilityOwner(newOwner);
189         emit NewPendingOwner(proxyOwner(), newOwner);
190     }
191 
192     /**
193     * @dev Allows the pendingOwner to claim ownership of the proxy
194     */
195     function claimProxyOwnership() external onlyPendingProxyOwner {
196         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
197         _setUpgradeabilityOwner(pendingProxyOwner());
198         _setPendingUpgradeabilityOwner(address(0));
199     }
200 
201     /**
202     * @dev Allows the proxy owner to upgrade the current version of the proxy.
203     * @param implementation representing the address of the new implementation to be set.
204     */
205     function upgradeTo(address implementation) external onlyProxyOwner {
206         _upgradeTo(implementation);
207     }
208 }