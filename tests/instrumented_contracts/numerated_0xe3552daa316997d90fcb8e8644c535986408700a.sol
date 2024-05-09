1 // File: contracts/EternalStorage.sol
2 
3 // Roman Storm Multi Sender
4 // To Use this Dapp: https://rstormsf.github.io/multisender
5 pragma solidity 0.4.23;
6 
7 
8 /**
9  * @title EternalStorage
10  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
11  */
12 contract EternalStorage {
13 
14     mapping(bytes32 => uint256) internal uintStorage;
15     mapping(bytes32 => string) internal stringStorage;
16     mapping(bytes32 => address) internal addressStorage;
17     mapping(bytes32 => bytes) internal bytesStorage;
18     mapping(bytes32 => bool) internal boolStorage;
19     mapping(bytes32 => int256) internal intStorage;
20 
21 }
22 
23 // File: contracts/UpgradeabilityOwnerStorage.sol
24 
25 // Roman Storm Multi Sender
26 // To Use this Dapp: https://rstormsf.github.io/multisender
27 pragma solidity 0.4.23;
28 
29 
30 /**
31  * @title UpgradeabilityOwnerStorage
32  * @dev This contract keeps track of the upgradeability owner
33  */
34 contract UpgradeabilityOwnerStorage {
35   // Owner of the contract
36     address private _upgradeabilityOwner;
37 
38     /**
39     * @dev Tells the address of the owner
40     * @return the address of the owner
41     */
42     function upgradeabilityOwner() public view returns (address) {
43         return _upgradeabilityOwner;
44     }
45 
46     /**
47     * @dev Sets the address of the owner
48     */
49     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
50         _upgradeabilityOwner = newUpgradeabilityOwner;
51     }
52 
53 }
54 
55 // File: contracts/Proxy.sol
56 
57 // Roman Storm Multi Sender
58 // To Use this Dapp: https://rstormsf.github.io/multisender
59 pragma solidity 0.4.23;
60 
61 
62 /**
63  * @title Proxy
64  * @dev Gives the possibility to delegate any call to a foreign implementation.
65  */
66 contract Proxy {
67 
68     /**
69     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
70     * This function will return whatever the implementation call returns
71     */
72     function () public payable {
73         address _impl = implementation();
74         require(_impl != address(0));
75         bytes memory data = msg.data;
76 
77         assembly {
78             let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
79             let size := returndatasize
80 
81             let ptr := mload(0x40)
82             returndatacopy(ptr, 0, size)
83 
84             switch result
85             case 0 { revert(ptr, size) }
86             default { return(ptr, size) }
87         }
88     }
89 
90     /**
91     * @dev Tells the address of the implementation where every call will be delegated.
92     * @return address of the implementation to which it will be delegated
93     */
94     function implementation() public view returns (address);
95 }
96 
97 // File: contracts/UpgradeabilityStorage.sol
98 
99 // Roman Storm Multi Sender
100 // To Use this Dapp: https://rstormsf.github.io/multisender
101 pragma solidity 0.4.23;
102 
103 
104 /**
105  * @title UpgradeabilityStorage
106  * @dev This contract holds all the necessary state variables to support the upgrade functionality
107  */
108 contract UpgradeabilityStorage {
109   // Version name of the current implementation
110     string internal _version;
111 
112     // Address of the current implementation
113     address internal _implementation;
114 
115     /**
116     * @dev Tells the version name of the current implementation
117     * @return string representing the name of the current version
118     */
119     function version() public view returns (string) {
120         return _version;
121     }
122 
123     /**
124     * @dev Tells the address of the current implementation
125     * @return address of the current implementation
126     */
127     function implementation() public view returns (address) {
128         return _implementation;
129     }
130 }
131 
132 // File: contracts/UpgradeabilityProxy.sol
133 
134 // Roman Storm Multi Sender
135 // To Use this Dapp: https://rstormsf.github.io/multisender
136 pragma solidity 0.4.23;
137 
138 
139 
140 
141 /**
142  * @title UpgradeabilityProxy
143  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
144  */
145 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
146   /**
147   * @dev This event will be emitted every time the implementation gets upgraded
148   * @param version representing the version name of the upgraded implementation
149   * @param implementation representing the address of the upgraded implementation
150   */
151     event Upgraded(string version, address indexed implementation);
152 
153     /**
154     * @dev Upgrades the implementation address
155     * @param version representing the version name of the new implementation to be set
156     * @param implementation representing the address of the new implementation to be set
157     */
158     function _upgradeTo(string version, address implementation) internal {
159         require(_implementation != implementation);
160         _version = version;
161         _implementation = implementation;
162         Upgraded(version, implementation);
163     }
164 }
165 
166 // File: contracts/OwnedUpgradeabilityProxy.sol
167 
168 // Roman Storm Multi Sender
169 // To Use this Dapp: https://rstormsf.github.io/multisender
170 pragma solidity 0.4.23;
171 
172 
173 
174 
175 /**
176  * @title OwnedUpgradeabilityProxy
177  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
178  */
179 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
180     /**
181     * @dev Event to show ownership has been transferred
182     * @param previousOwner representing the address of the previous owner
183     * @param newOwner representing the address of the new owner
184     */
185     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
186 
187     /**
188     * @dev the constructor sets the original owner of the contract to the sender account.
189     */
190     function OwnedUpgradeabilityProxy(address _owner) public {
191         setUpgradeabilityOwner(_owner);
192     }
193 
194     /**
195     * @dev Throws if called by any account other than the owner.
196     */
197     modifier onlyProxyOwner() {
198         require(msg.sender == proxyOwner());
199         _;
200     }
201 
202     /**
203     * @dev Tells the address of the proxy owner
204     * @return the address of the proxy owner
205     */
206     function proxyOwner() public view returns (address) {
207         return upgradeabilityOwner();
208     }
209 
210     /**
211     * @dev Allows the current owner to transfer control of the contract to a newOwner.
212     * @param newOwner The address to transfer ownership to.
213     */
214     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
215         require(newOwner != address(0));
216         ProxyOwnershipTransferred(proxyOwner(), newOwner);
217         setUpgradeabilityOwner(newOwner);
218     }
219 
220     /**
221     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
222     * @param version representing the version name of the new implementation to be set.
223     * @param implementation representing the address of the new implementation to be set.
224     */
225     function upgradeTo(string version, address implementation) public onlyProxyOwner {
226         _upgradeTo(version, implementation);
227     }
228 
229     /**
230     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
231     * to initialize whatever is needed through a low level call.
232     * @param version representing the version name of the new implementation to be set.
233     * @param implementation representing the address of the new implementation to be set.
234     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
235     * signature of the implementation to be called with the needed payload
236     */
237     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
238         upgradeTo(version, implementation);
239         require(this.call.value(msg.value)(data));
240     }
241 }
242 
243 // File: contracts/EternalStorageProxyForStormMultisender.sol
244 
245 // Roman Storm Multi Sender
246 // To Use this Dapp: https://rstormsf.github.io/multisender
247 pragma solidity 0.4.23;
248 
249 
250 
251 
252 /**
253  * @title EternalStorageProxy
254  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
255  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
256  * authorization control functionalities
257  */
258 contract EternalStorageProxyForStormMultisender is OwnedUpgradeabilityProxy, EternalStorage {
259 
260     function EternalStorageProxyForStormMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
261 
262 }