1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Proxy
5  * @dev Gives the possibility to delegate any call to a foreign implementation.
6  */
7 contract Proxy {
8     /**
9     * @dev Tells the address of the implementation where every call will be delegated.
10     * @return address of the implementation to which it will be delegated
11     */
12     function implementation() public view returns (address);
13 
14     /**
15     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
16     * This function will return whatever the implementation call returns
17     */
18     function () public payable {
19         address _impl = implementation();
20         require(_impl != address(0), "address invalid");
21 
22         assembly {
23             let ptr := mload(0x40)
24             calldatacopy(ptr, 0, calldatasize)
25             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
26             let size := returndatasize
27             returndatacopy(ptr, 0, size)
28 
29             switch result
30             case 0 { revert(ptr, size) }
31             default { return(ptr, size) }
32         }
33     }
34 }
35 
36 /**
37  * @title UpgradeabilityProxy
38  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
39  */
40 contract UpgradeabilityProxy is Proxy {
41     /**
42     * @dev This event will be emitted every time the implementation gets upgraded
43     * @param implementation representing the address of the upgraded implementation
44     */
45     event Upgraded(address indexed implementation);
46 
47     // Storage position of the address of the current implementation
48     bytes32 private constant implementationPosition = keccak256("you are the lucky man.proxy");
49 
50     /**
51     * @dev Constructor function
52     */
53     constructor() public {}
54 
55     /**
56     * @dev Tells the address of the current implementation
57     * @return address of the current implementation
58     */
59     function implementation() public view returns (address impl) {
60         bytes32 position = implementationPosition;
61         assembly {
62             impl := sload(position)
63         }
64     }
65 
66     /**
67     * @dev Sets the address of the current implementation
68     * @param newImplementation address representing the new implementation to be set
69     */
70     function setImplementation(address newImplementation) internal {
71         bytes32 position = implementationPosition;
72         assembly {
73             sstore(position, newImplementation)
74         }
75     }
76 
77     /**
78     * @dev Upgrades the implementation address
79     * @param newImplementation representing the address of the new implementation to be set
80     */
81     function _upgradeTo(address newImplementation) internal {
82         address currentImplementation = implementation();
83         require(currentImplementation != newImplementation, "new address is the same");
84         setImplementation(newImplementation);
85         emit Upgraded(newImplementation);
86     }
87 }
88 
89 /**
90  * @title OwnedUpgradeabilityProxy
91  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
92  */
93 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
94     /**
95     * @dev Event to show ownership has been transferred
96     * @param previousOwner representing the address of the previous owner
97     * @param newOwner representing the address of the new owner
98     */
99     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
100 
101     // Storage position of the owner of the contract
102     bytes32 private constant proxyOwnerPosition = keccak256("you are the lucky man.proxy.owner");
103 
104     /**
105     * @dev the constructor sets the original owner of the contract to the sender account.
106     */
107     constructor() public {
108         setUpgradeabilityOwner(msg.sender);
109     }
110 
111     /**
112     * @dev Throws if called by any account other than the owner.
113     */
114     modifier onlyProxyOwner() {
115         require(msg.sender == proxyOwner(), "owner only");
116         _;
117     }
118 
119     /**
120     * @dev Tells the address of the owner
121     * @return the address of the owner
122     */
123     function proxyOwner() public view returns (address owner) {
124         bytes32 position = proxyOwnerPosition;
125         assembly {
126             owner := sload(position)
127         }
128     }
129 
130     /**
131     * @dev Sets the address of the owner
132     */
133     function setUpgradeabilityOwner(address newProxyOwner) internal {
134         bytes32 position = proxyOwnerPosition;
135         assembly {
136             sstore(position, newProxyOwner)
137         }
138     }
139 
140     /**
141     * @dev Allows the current owner to transfer control of the contract to a newOwner.
142     * @param newOwner The address to transfer ownership to.
143     */
144     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
145         require(newOwner != address(0), "address is invalid");
146         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
147         setUpgradeabilityOwner(newOwner);
148     }
149 
150     /**
151     * @dev Allows the proxy owner to upgrade the current version of the proxy.
152     * @param implementation representing the address of the new implementation to be set.
153     */
154     function upgradeTo(address implementation) public onlyProxyOwner {
155         _upgradeTo(implementation);
156     }
157 
158     /**
159     * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
160     * to initialize whatever is needed through a low level call.
161     * @param implementation representing the address of the new implementation to be set.
162     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
163     * signature of the implementation to be called with the needed payload
164     */
165     function upgradeToAndCall(address implementation, bytes data) public payable onlyProxyOwner {
166         upgradeTo(implementation);
167         require(address(this).call.value(msg.value)(data), "data is invalid");
168     }
169 }