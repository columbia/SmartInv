1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title Proxy
6  * @dev Gives the possibility to delegate any call to a foreign implementation.
7  */
8 contract Proxy {
9     /**
10     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
11     * This function will return whatever the implementation call returns
12     */
13     function () external payable {
14         address _impl = implementation();
15         require(_impl != address(0));
16 
17         assembly {
18             let ptr := mload(0x40)
19             calldatacopy(ptr, 0, calldatasize)
20             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
21             let size := returndatasize
22             returndatacopy(ptr, 0, size)
23 
24             switch result
25             case 0 { revert(ptr, size) }
26             default { return(ptr, size) }
27         }
28     }
29 
30     /**
31     * @dev Tells the address of the implementation where every call will be delegated.
32     * @return address of the implementation to which it will be delegated
33     */
34     function implementation() public view returns (address);
35 }
36 
37 /**
38  * @title UpgradeabilityProxy
39  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
40  */
41 contract UpgradeabilityProxy is Proxy {
42     /**
43     * @dev This event will be emitted every time the implementation gets upgraded
44     * @param implementation representing the address of the upgraded implementation
45     */
46     event Upgraded(address indexed implementation);
47 
48     // Storage position of the address of the current implementation
49     bytes32 private constant IMPLEMENTATION_POSITION = keccak256("mintable.erc721.proxy.implementation");
50 
51     /**
52     * @dev Constructor function
53     */
54     constructor() public {}
55 
56     /**
57     * @dev Tells the address of the current implementation
58     * @return address of the current implementation
59     */
60     function implementation() public view returns (address impl) {
61         bytes32 position = IMPLEMENTATION_POSITION;
62         assembly {
63             impl := sload(position)
64         }
65     }
66 
67     /**
68     * @dev Sets the address of the current implementation
69     * @param _newImplementation address representing the new implementation to be set
70     */
71     function _setImplementation(address _newImplementation) internal {
72         bytes32 position = IMPLEMENTATION_POSITION;
73         assembly {
74             sstore(position, _newImplementation)
75         }
76     }
77 
78     /**
79     * @dev Upgrades the implementation address
80     * @param _newImplementation representing the address of the new implementation to be set
81     */
82     function _upgradeTo(address _newImplementation) internal {
83         address currentImplementation = implementation();
84         require(currentImplementation != _newImplementation);
85         _setImplementation(_newImplementation);
86         emit Upgraded(_newImplementation);
87     }
88 }
89 
90 /**
91  * @title OwnedUpgradeabilityProxy
92  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
93  */
94 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
95     /**
96     * @dev Event to show ownership has been transferred
97     * @param previousOwner representing the address of the previous owner
98     * @param newOwner representing the address of the new owner
99     */
100     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
101 
102     // Storage position of the owner of the contract
103     bytes32 private constant PROXY_OWNER_POSITION = keccak256("mintable.erc721.proxy.owner");
104 
105     /**
106     * @dev the constructor sets the original owner of the contract to the sender account.
107     */
108     constructor(address _implementation) public {
109         _setUpgradeabilityOwner(msg.sender);
110         _upgradeTo(_implementation);
111     }
112 
113     /**
114     * @dev Throws if called by any account other than the owner.
115     */
116     modifier onlyProxyOwner() {
117         require(msg.sender == proxyOwner());
118         _;
119     }
120 
121     /**
122     * @dev Tells the address of the owner
123     * @return the address of the owner
124     */
125     function proxyOwner() public view returns (address owner) {
126         bytes32 position = PROXY_OWNER_POSITION;
127         assembly {
128             owner := sload(position)
129         }
130     }
131 
132     /**
133     * @dev Allows the current owner to transfer control of the contract to a newOwner.
134     * @param _newOwner The address to transfer ownership to.
135     */
136     function transferProxyOwnership(address _newOwner) public onlyProxyOwner {
137         require(_newOwner != address(0));
138         _setUpgradeabilityOwner(_newOwner);
139         emit ProxyOwnershipTransferred(proxyOwner(), _newOwner);
140     }
141 
142     /**
143     * @dev Allows the proxy owner to upgrade the current version of the proxy.
144     * @param _implementation representing the address of the new implementation to be set.
145     */
146     function upgradeTo(address _implementation) public onlyProxyOwner {
147         _upgradeTo(_implementation);
148     }
149 
150     /**
151      * @dev Sets the address of the owner
152     */
153     function _setUpgradeabilityOwner(address _newProxyOwner) internal {
154         bytes32 position = PROXY_OWNER_POSITION;
155         assembly {
156             sstore(position, _newProxyOwner)
157         }
158     }
159 }