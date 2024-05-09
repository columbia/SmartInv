1 // Sources flattened with hardhat v2.0.8 https://hardhat.org
2 
3 // File contracts/proxies/Proxy.sol
4 
5 pragma solidity 0.6.12;
6 
7 /**
8  * @title Proxy
9  * @dev Gives the possibility to delegate any call to a foreign implementation.
10  */
11 abstract contract Proxy {
12     /**
13     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
14     * This function will return whatever the implementation call returns
15     */
16     fallback() external payable {
17         address _impl = implementation();
18         require(_impl != address(0));
19 
20         assembly {
21             let ptr := mload(0x40)
22             calldatacopy(ptr, 0, calldatasize())
23             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
24             let size := returndatasize()
25             returndatacopy(ptr, 0, size)
26 
27             switch result
28             case 0 { revert(ptr, size) }
29             default { return(ptr, size) }
30             }
31     }
32 
33     /**
34     * @dev Tells the address of the implementation where every call will be delegated.
35     * @return address of the implementation to which it will be delegated
36     */
37     function implementation() public view virtual returns (address);
38 }
39 
40 
41 // File contracts/proxies/UpgradeabilityProxy.sol
42 
43 pragma solidity 0.6.12;
44 
45 /**
46  * @title UpgradeabilityProxy
47  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
48  */
49 contract UpgradeabilityProxy is Proxy {
50     /**
51     * @dev This event will be emitted every time the implementation gets upgraded
52     * @param implementation representing the address of the upgraded implementation
53     */
54     event Upgraded(address indexed implementation);
55 
56     // Storage position of the address of the current implementation
57     bytes32 private constant IMPLEMENTATION_POSITION = keccak256("org.govblocks.proxy.implementation");
58 
59     /**
60     * @dev Constructor function
61     */
62     constructor() public {}
63 
64     /**
65     * @dev Tells the address of the current implementation
66     * @return impl address of the current implementation
67     */
68     function implementation() public view override returns (address impl) {
69         bytes32 position = IMPLEMENTATION_POSITION;
70         assembly {
71             impl := sload(position)
72         }
73     }
74 
75     /**
76     * @dev Sets the address of the current implementation
77     * @param _newImplementation address representing the new implementation to be set
78     */
79     function _setImplementation(address _newImplementation) internal {
80         bytes32 position = IMPLEMENTATION_POSITION;
81         assembly {
82         sstore(position, _newImplementation)
83         }
84     }
85 
86     /**
87     * @dev Upgrades the implementation address
88     * @param _newImplementation representing the address of the new implementation to be set
89     */
90     function _upgradeTo(address _newImplementation) internal {
91         address currentImplementation = implementation();
92         require(currentImplementation != _newImplementation);
93         _setImplementation(_newImplementation);
94         emit Upgraded(_newImplementation);
95     }
96 }
97 
98 
99 // File contracts/proxies/OwnedUpgradeabilityProxy.sol
100 
101 pragma solidity 0.6.12;
102 
103 /**
104  * @title OwnedUpgradeabilityProxy
105  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
106  */
107 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
108     /**
109     * @dev Event to show ownership has been transferred
110     * @param previousOwner representing the address of the previous owner
111     * @param newOwner representing the address of the new owner
112     */
113     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
114 
115     // Storage position of the owner of the contract
116     bytes32 private constant PROXY_OWNER_POSITION = keccak256("org.govblocks.proxy.owner");
117 
118     /**
119     * @dev the constructor sets the original owner of the contract to the sender account.
120     */
121     constructor(address _implementation) public {
122         _setUpgradeabilityOwner(msg.sender);
123         _upgradeTo(_implementation);
124     }
125 
126     /**
127     * @dev Throws if called by any account other than the owner.
128     */
129     modifier onlyProxyOwner() {
130         require(msg.sender == proxyOwner());
131         _;
132     }
133 
134     /**
135     * @dev Tells the address of the owner
136     * @return owner the address of the owner
137     */
138     function proxyOwner() public view returns (address owner) {
139         bytes32 position = PROXY_OWNER_POSITION;
140         assembly {
141             owner := sload(position)
142         }
143     }
144 
145     /**
146     * @dev Allows the current owner to transfer control of the contract to a newOwner.
147     * @param _newOwner The address to transfer ownership to.
148     */
149     function transferProxyOwnership(address _newOwner) public onlyProxyOwner {
150         require(_newOwner != address(0));
151         _setUpgradeabilityOwner(_newOwner);
152         emit ProxyOwnershipTransferred(proxyOwner(), _newOwner);
153     }
154 
155     /**
156     * @dev Allows the proxy owner to upgrade the current version of the proxy.
157     * @param _implementation representing the address of the new implementation to be set.
158     */
159     function upgradeTo(address _implementation) public onlyProxyOwner {
160         _upgradeTo(_implementation);
161     }
162 
163     /**
164      * @dev Sets the address of the owner
165     */
166     function _setUpgradeabilityOwner(address _newProxyOwner) internal {
167         bytes32 position = PROXY_OWNER_POSITION;
168         assembly {
169             sstore(position, _newProxyOwner)
170         }
171     }
172 }