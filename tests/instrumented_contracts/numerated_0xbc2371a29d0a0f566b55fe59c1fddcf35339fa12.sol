1 pragma solidity ^0.4.23;
2 
3 // This is the proxy contract for the UUSD Token Registry
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
25         
26         assembly {
27             let ptr := mload(0x40)
28             calldatacopy(ptr, 0, calldatasize)
29             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
30             let size := returndatasize
31             returndatacopy(ptr, 0, size)
32 
33             switch result
34             case 0 { revert(ptr, size) }
35             default { return(ptr, size) }
36         }
37     }
38 }
39 
40 // File: contracts/Proxy/UpgradeabilityProxy.sol
41 
42 /**
43  * @title UpgradeabilityProxy
44  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
45  */
46 contract UpgradeabilityProxy is Proxy {
47     /**
48     * @dev This event will be emitted every time the implementation gets upgraded
49     * @param implementation representing the address of the upgraded implementation
50     */
51     event Upgraded(address indexed implementation);
52 
53     // Storage position of the address of the current implementation
54     bytes32 private constant implementationPosition = keccak256("trueUSD.proxy.implementation");
55 
56     /**
57     * @dev Tells the address of the current implementation
58     * @return address of the current implementation
59     */
60     function implementation() public view returns (address impl) {
61         bytes32 position = implementationPosition;
62         assembly {
63           impl := sload(position)
64         }
65     }
66 
67     /**
68     * @dev Sets the address of the current implementation
69     * @param newImplementation address representing the new implementation to be set
70     */
71     function _setImplementation(address newImplementation) internal {
72         bytes32 position = implementationPosition;
73         assembly {
74           sstore(position, newImplementation)
75         }
76     }
77 
78     /**
79     * @dev Upgrades the implementation address
80     * @param newImplementation representing the address of the new implementation to be set
81     */
82     function _upgradeTo(address newImplementation) internal {
83         address currentImplementation = implementation();
84         require(currentImplementation != newImplementation);
85         _setImplementation(newImplementation);
86         emit Upgraded(newImplementation);
87     }
88 }
89 
90 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
91 
92 /**
93  * @title OwnedUpgradeabilityProxy
94  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
95  */
96 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
97     /**
98     * @dev Event to show ownership has been transferred
99     * @param previousOwner representing the address of the previous owner
100     * @param newOwner representing the address of the new owner
101     */
102     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     /**
105     * @dev Event to show ownership transfer is pending
106     * @param currentOwner representing the address of the current owner
107     * @param pendingOwner representing the address of the pending owner
108     */
109     event NewPendingOwner(address currentOwner, address pendingOwner);
110     
111     // Storage position of the owner and pendingOwner of the contract
112     bytes32 private constant proxyOwnerPosition = keccak256("trueUSD.proxy.owner");
113     bytes32 private constant pendingProxyOwnerPosition = keccak256("trueUSD.pending.proxy.owner");
114 
115     /**
116     * @dev the constructor sets the original owner of the contract to the sender account.
117     */
118     constructor() public {
119         _setUpgradeabilityOwner(msg.sender);
120     }
121 
122     /**
123     * @dev Throws if called by any account other than the owner.
124     */
125     modifier onlyProxyOwner() {
126         require(msg.sender == proxyOwner(), "only Proxy Owner");
127         _;
128     }
129 
130     /**
131     * @dev Throws if called by any account other than the pending owner.
132     */
133     modifier onlyPendingProxyOwner() {
134         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
135         _;
136     }
137 
138     /**
139     * @dev Tells the address of the owner
140     * @return the address of the owner
141     */
142     function proxyOwner() public view returns (address owner) {
143         bytes32 position = proxyOwnerPosition;
144         assembly {
145             owner := sload(position)
146         }
147     }
148 
149     /**
150     * @dev Tells the address of the owner
151     * @return the address of the owner
152     */
153     function pendingProxyOwner() public view returns (address pendingOwner) {
154         bytes32 position = pendingProxyOwnerPosition;
155         assembly {
156             pendingOwner := sload(position)
157         }
158     }
159 
160     /**
161     * @dev Sets the address of the owner
162     */
163     function _setUpgradeabilityOwner(address newProxyOwner) internal {
164         bytes32 position = proxyOwnerPosition;
165         assembly {
166             sstore(position, newProxyOwner)
167         }
168     }
169 
170     /**
171     * @dev Sets the address of the owner
172     */
173     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
174         bytes32 position = pendingProxyOwnerPosition;
175         assembly {
176             sstore(position, newPendingProxyOwner)
177         }
178     }
179 
180     /**
181     * @dev Allows the current owner to transfer control of the contract to a newOwner.
182     *changes the pending owner to newOwner. But doesn't actually transfer
183     * @param newOwner The address to transfer ownership to.
184     */
185     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
186         require(newOwner != address(0));
187         _setPendingUpgradeabilityOwner(newOwner);
188         emit NewPendingOwner(proxyOwner(), newOwner);
189     }
190 
191     /**
192     * @dev Allows the pendingOwner to claim ownership of the proxy
193     */
194     function claimProxyOwnership() external onlyPendingProxyOwner {
195         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
196         _setUpgradeabilityOwner(pendingProxyOwner());
197         _setPendingUpgradeabilityOwner(address(0));
198     }
199 
200     /**
201     * @dev Allows the proxy owner to upgrade the current version of the proxy.
202     * @param implementation representing the address of the new implementation to be set.
203     */
204     function upgradeTo(address implementation) external onlyProxyOwner {
205         _upgradeTo(implementation);
206     }
207 }