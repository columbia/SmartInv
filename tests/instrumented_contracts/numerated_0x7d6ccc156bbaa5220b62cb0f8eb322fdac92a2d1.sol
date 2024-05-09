1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, February 27, 2018
3  (UTC) */
4 
5 // File: contracts/EternalStorage.sol
6 
7 // Roman Storm Multi Sender
8 // To Use this Dapp: https://poanetwork.github.io/multisender
9 pragma solidity 0.4.20;
10 
11 
12 /**
13  * @title EternalStorage
14  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
15  */
16 contract EternalStorage {
17 
18     mapping(bytes32 => uint256) internal uintStorage;
19     mapping(bytes32 => string) internal stringStorage;
20     mapping(bytes32 => address) internal addressStorage;
21     mapping(bytes32 => bytes) internal bytesStorage;
22     mapping(bytes32 => bool) internal boolStorage;
23     mapping(bytes32 => int256) internal intStorage;
24 
25 }
26 
27 // File: contracts/UpgradeabilityOwnerStorage.sol
28 
29 // Roman Storm Multi Sender
30 // To Use this Dapp: https://poanetwork.github.io/multisender
31 pragma solidity 0.4.20;
32 
33 
34 /**
35  * @title UpgradeabilityOwnerStorage
36  * @dev This contract keeps track of the upgradeability owner
37  */
38 contract UpgradeabilityOwnerStorage {
39   // Owner of the contract
40     address private _upgradeabilityOwner;
41 
42     /**
43     * @dev Tells the address of the owner
44     * @return the address of the owner
45     */
46     function upgradeabilityOwner() public view returns (address) {
47         return _upgradeabilityOwner;
48     }
49 
50     /**
51     * @dev Sets the address of the owner
52     */
53     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
54         _upgradeabilityOwner = newUpgradeabilityOwner;
55     }
56 
57 }
58 
59 // File: contracts/Proxy.sol
60 
61 // Roman Storm Multi Sender
62 // To Use this Dapp: https://poanetwork.github.io/multisender
63 pragma solidity 0.4.20;
64 
65 
66 /**
67  * @title Proxy
68  * @dev Gives the possibility to delegate any call to a foreign implementation.
69  */
70 contract Proxy {
71 
72     /**
73     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
74     * This function will return whatever the implementation call returns
75     */
76     function () public payable {
77         address _impl = implementation();
78         require(_impl != address(0));
79         bytes memory data = msg.data;
80 
81         assembly {
82             let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
83             let size := returndatasize
84 
85             let ptr := mload(0x40)
86             returndatacopy(ptr, 0, size)
87 
88             switch result
89             case 0 { revert(ptr, size) }
90             default { return(ptr, size) }
91         }
92     }
93 
94     /**
95     * @dev Tells the address of the implementation where every call will be delegated.
96     * @return address of the implementation to which it will be delegated
97     */
98     function implementation() public view returns (address);
99 }
100 
101 // File: contracts/UpgradeabilityStorage.sol
102 
103 // Roman Storm Multi Sender
104 // To Use this Dapp: https://poanetwork.github.io/multisender
105 pragma solidity 0.4.20;
106 
107 
108 /**
109  * @title UpgradeabilityStorage
110  * @dev This contract holds all the necessary state variables to support the upgrade functionality
111  */
112 contract UpgradeabilityStorage {
113   // Version name of the current implementation
114     string internal _version;
115 
116     // Address of the current implementation
117     address internal _implementation;
118 
119     /**
120     * @dev Tells the version name of the current implementation
121     * @return string representing the name of the current version
122     */
123     function version() public view returns (string) {
124         return _version;
125     }
126 
127     /**
128     * @dev Tells the address of the current implementation
129     * @return address of the current implementation
130     */
131     function implementation() public view returns (address) {
132         return _implementation;
133     }
134 }
135 
136 // File: contracts/UpgradeabilityProxy.sol
137 
138 // Roman Storm Multi Sender
139 // To Use this Dapp: https://poanetwork.github.io/multisender
140 pragma solidity 0.4.20;
141 
142 
143 
144 
145 /**
146  * @title UpgradeabilityProxy
147  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
148  */
149 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
150   /**
151   * @dev This event will be emitted every time the implementation gets upgraded
152   * @param version representing the version name of the upgraded implementation
153   * @param implementation representing the address of the upgraded implementation
154   */
155     event Upgraded(string version, address indexed implementation);
156 
157     /**
158     * @dev Upgrades the implementation address
159     * @param version representing the version name of the new implementation to be set
160     * @param implementation representing the address of the new implementation to be set
161     */
162     function _upgradeTo(string version, address implementation) internal {
163         require(_implementation != implementation);
164         _version = version;
165         _implementation = implementation;
166         Upgraded(version, implementation);
167     }
168 }
169 
170 // File: contracts/OwnedUpgradeabilityProxy.sol
171 
172 // Roman Storm Multi Sender
173 // To Use this Dapp: https://poanetwork.github.io/multisender
174 pragma solidity 0.4.20;
175 
176 
177 
178 
179 /**
180  * @title OwnedUpgradeabilityProxy
181  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
182  */
183 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
184     /**
185     * @dev Event to show ownership has been transferred
186     * @param previousOwner representing the address of the previous owner
187     * @param newOwner representing the address of the new owner
188     */
189     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
190 
191     /**
192     * @dev the constructor sets the original owner of the contract to the sender account.
193     */
194     function OwnedUpgradeabilityProxy(address _owner) public {
195         setUpgradeabilityOwner(_owner);
196     }
197 
198     /**
199     * @dev Throws if called by any account other than the owner.
200     */
201     modifier onlyProxyOwner() {
202         require(msg.sender == proxyOwner());
203         _;
204     }
205 
206     /**
207     * @dev Tells the address of the proxy owner
208     * @return the address of the proxy owner
209     */
210     function proxyOwner() public view returns (address) {
211         return upgradeabilityOwner();
212     }
213 
214     /**
215     * @dev Allows the current owner to transfer control of the contract to a newOwner.
216     * @param newOwner The address to transfer ownership to.
217     */
218     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
219         require(newOwner != address(0));
220         ProxyOwnershipTransferred(proxyOwner(), newOwner);
221         setUpgradeabilityOwner(newOwner);
222     }
223 
224     /**
225     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
226     * @param version representing the version name of the new implementation to be set.
227     * @param implementation representing the address of the new implementation to be set.
228     */
229     function upgradeTo(string version, address implementation) public onlyProxyOwner {
230         _upgradeTo(version, implementation);
231     }
232 
233     /**
234     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
235     * to initialize whatever is needed through a low level call.
236     * @param version representing the version name of the new implementation to be set.
237     * @param implementation representing the address of the new implementation to be set.
238     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
239     * signature of the implementation to be called with the needed payload
240     */
241     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
242         upgradeTo(version, implementation);
243         require(this.call.value(msg.value)(data));
244     }
245 }
246 
247 // File: contracts/EternalStorageProxyForStormMultisender.sol
248 
249 // Roman Storm Multi Sender
250 // To Use this Dapp: https://poanetwork.github.io/multisender
251 pragma solidity 0.4.20;
252 
253 
254 
255 
256 /**
257  * @title EternalStorageProxy
258  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
259  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
260  * authorization control functionalities
261  */
262 contract EternalStorageProxyForStormMultisender is OwnedUpgradeabilityProxy, EternalStorage {
263 
264     function EternalStorageProxyForStormMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
265 
266 }