1 // SPDX-License-Identifier: (c) Armor.Fi DAO, 2021
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @title Proxy
7  * @dev Gives the possibility to delegate any call to a foreign implementation.
8  */
9 abstract contract Proxy {
10     /**
11     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
12     * This function will return whatever the implementation call returns
13     */
14     fallback() external payable {
15         address _impl = implementation();
16         require(_impl != address(0));
17 
18         assembly {
19             let ptr := mload(0x40)
20             calldatacopy(ptr, 0, calldatasize())
21             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
22             let size := returndatasize()
23             returndatacopy(ptr, 0, size)
24 
25             switch result
26             case 0 { revert(ptr, size) }
27             default { return(ptr, size) }
28             }
29     }
30 
31     /**
32     * @dev Tells the address of the implementation where every call will be delegated.
33     * @return address of the implementation to which it will be delegated
34     */
35     function implementation() public view virtual returns (address);
36 }
37 
38 /**
39  * @title UpgradeabilityProxy
40  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
41  */
42 contract UpgradeabilityProxy is Proxy {
43     /**
44     * @dev This event will be emitted every time the implementation gets upgraded
45     * @param implementation representing the address of the upgraded implementation
46     */
47     event Upgraded(address indexed implementation);
48 
49     // Storage position of the address of the current implementation
50     bytes32 private constant IMPLEMENTATION_POSITION = keccak256("org.govblocks.proxy.implementation");
51 
52     /**
53     * @dev Constructor function
54     */
55     constructor() public {}
56 
57     /**
58     * @dev Tells the address of the current implementation
59     * @return impl address of the current implementation
60     */
61     function implementation() public view override returns (address impl) {
62         bytes32 position = IMPLEMENTATION_POSITION;
63         assembly {
64             impl := sload(position)
65         }
66     }
67 
68     /**
69     * @dev Sets the address of the current implementation
70     * @param _newImplementation address representing the new implementation to be set
71     */
72     function _setImplementation(address _newImplementation) internal {
73         bytes32 position = IMPLEMENTATION_POSITION;
74         assembly {
75         sstore(position, _newImplementation)
76         }
77     }
78 
79     /**
80     * @dev Upgrades the implementation address
81     * @param _newImplementation representing the address of the new implementation to be set
82     */
83     function _upgradeTo(address _newImplementation) internal {
84         address currentImplementation = implementation();
85         require(currentImplementation != _newImplementation);
86         _setImplementation(_newImplementation);
87         emit Upgraded(_newImplementation);
88     }
89 }
90 
91 /**
92  * @title OwnedUpgradeabilityProxy
93  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
94  */
95 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
96     /**
97     * @dev Event to show ownership has been transferred
98     * @param previousOwner representing the address of the previous owner
99     * @param newOwner representing the address of the new owner
100     */
101     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
102 
103     // Storage position of the owner of the contract
104     bytes32 private constant PROXY_OWNER_POSITION = keccak256("org.govblocks.proxy.owner");
105 
106     /**
107     * @dev the constructor sets the original owner of the contract to the sender account.
108     */
109     constructor(address _implementation) public {
110         _setUpgradeabilityOwner(msg.sender);
111         _upgradeTo(_implementation);
112     }
113 
114     /**
115     * @dev Throws if called by any account other than the owner.
116     */
117     modifier onlyProxyOwner() {
118         require(msg.sender == proxyOwner());
119         _;
120     }
121 
122     /**
123     * @dev Tells the address of the owner
124     * @return owner the address of the owner
125     */
126     function proxyOwner() public view returns (address owner) {
127         bytes32 position = PROXY_OWNER_POSITION;
128         assembly {
129             owner := sload(position)
130         }
131     }
132 
133     /**
134     * @dev Allows the current owner to transfer control of the contract to a newOwner.
135     * @param _newOwner The address to transfer ownership to.
136     */
137     function transferProxyOwnership(address _newOwner) public onlyProxyOwner {
138         require(_newOwner != address(0));
139         _setUpgradeabilityOwner(_newOwner);
140         emit ProxyOwnershipTransferred(proxyOwner(), _newOwner);
141     }
142 
143     /**
144     * @dev Allows the proxy owner to upgrade the current version of the proxy.
145     * @param _implementation representing the address of the new implementation to be set.
146     */
147     function upgradeTo(address _implementation) public onlyProxyOwner {
148         _upgradeTo(_implementation);
149     }
150 
151     /**
152      * @dev Sets the address of the owner
153     */
154     function _setUpgradeabilityOwner(address _newProxyOwner) internal {
155         bytes32 position = PROXY_OWNER_POSITION;
156         assembly {
157             sstore(position, _newProxyOwner)
158         }
159     }
160 }