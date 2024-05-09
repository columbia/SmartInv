1 pragma solidity 0.4.20;
2 
3 
4 // This DApp let you send tokens to multiple addresses at one Transaction
5 // efficient and less errors
6 // To Use this Dapp: http://tokensender.me/
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
23 // This DApp let you send tokens to multiple addresses at one Transaction
24 // efficient and less errors
25 // To Use this Dapp: http://tokensender.me/
26 
27 pragma solidity 0.4.20;
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
55 // This DApp let you send tokens to multiple addresses at one Transaction
56 // efficient and less errors
57 // To Use this Dapp: http://tokensender.me/
58 
59 pragma solidity 0.4.20;
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
97 // This DApp let you send tokens to multiple addresses at one Transaction
98 // efficient and less errors
99 // To Use this Dapp: http://tokensender.me/
100 
101 
102 pragma solidity 0.4.20;
103 
104 
105 /**
106  * @title UpgradeabilityStorage
107  * @dev This contract holds all the necessary state variables to support the upgrade functionality
108  */
109 contract UpgradeabilityStorage {
110   // Version name of the current implementation
111     string internal _version;
112 
113     // Address of the current implementation
114     address internal _implementation;
115 
116     /**
117     * @dev Tells the version name of the current implementation
118     * @return string representing the name of the current version
119     */
120     function version() public view returns (string) {
121         return _version;
122     }
123 
124     /**
125     * @dev Tells the address of the current implementation
126     * @return address of the current implementation
127     */
128     function implementation() public view returns (address) {
129         return _implementation;
130     }
131 }
132 
133 // This DApp let you send tokens to multiple addresses at one Transaction
134 // efficient and less errors
135 // To Use this Dapp: http://tokensender.me/
136 
137 
138 pragma solidity 0.4.20;
139 
140 
141 
142 
143 /**
144  * @title UpgradeabilityProxy
145  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
146  */
147 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
148   /**
149   * @dev This event will be emitted every time the implementation gets upgraded
150   * @param version representing the version name of the upgraded implementation
151   * @param implementation representing the address of the upgraded implementation
152   */
153     event Upgraded(string version, address indexed implementation);
154 
155     /**
156     * @dev Upgrades the implementation address
157     * @param version representing the version name of the new implementation to be set
158     * @param implementation representing the address of the new implementation to be set
159     */
160     function _upgradeTo(string version, address implementation) internal {
161         require(_implementation != implementation);
162         _version = version;
163         _implementation = implementation;
164         Upgraded(version, implementation);
165     }
166 }
167 
168 // This DApp let you send tokens to multiple addresses at one Transaction
169 // efficient and less errors
170 // To Use this Dapp: http://tokensender.me/
171 
172 
173 pragma solidity 0.4.20;
174 
175 
176 
177 
178 /**
179  * @title OwnedUpgradeabilityProxy
180  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
181  */
182 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
183     /**
184     * @dev Event to show ownership has been transferred
185     * @param previousOwner representing the address of the previous owner
186     * @param newOwner representing the address of the new owner
187     */
188     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
189 
190     /**
191     * @dev the constructor sets the original owner of the contract to the sender account.
192     */
193     function OwnedUpgradeabilityProxy(address _owner) public {
194         setUpgradeabilityOwner(_owner);
195     }
196 
197     /**
198     * @dev Throws if called by any account other than the owner.
199     */
200     modifier onlyProxyOwner() {
201         require(msg.sender == proxyOwner());
202         _;
203     }
204 
205     /**
206     * @dev Tells the address of the proxy owner
207     * @return the address of the proxy owner
208     */
209     function proxyOwner() public view returns (address) {
210         return upgradeabilityOwner();
211     }
212 
213     /**
214     * @dev Allows the current owner to transfer control of the contract to a newOwner.
215     * @param newOwner The address to transfer ownership to.
216     */
217     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
218         require(newOwner != address(0));
219         ProxyOwnershipTransferred(proxyOwner(), newOwner);
220         setUpgradeabilityOwner(newOwner);
221     }
222 
223     /**
224     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
225     * @param version representing the version name of the new implementation to be set.
226     * @param implementation representing the address of the new implementation to be set.
227     */
228     function upgradeTo(string version, address implementation) public onlyProxyOwner {
229         _upgradeTo(version, implementation);
230     }
231 
232     /**
233     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
234     * to initialize whatever is needed through a low level call.
235     * @param version representing the version name of the new implementation to be set.
236     * @param implementation representing the address of the new implementation to be set.
237     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
238     * signature of the implementation to be called with the needed payload
239     */
240     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
241         upgradeTo(version, implementation);
242         require(this.call.value(msg.value)(data));
243     }
244 }
245 
246 
247 // This DApp let you send tokens to multiple addresses at one Transaction
248 // efficient and less errors
249 // To Use this Dapp: http://tokensender.me/
250 
251 pragma solidity 0.4.20;
252 
253 
254 /**
255  * @title EternalStorageProxy
256  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
257  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
258  * authorization control functionalities
259  */
260 contract EternalStorageProxyForStormMultisender is OwnedUpgradeabilityProxy, EternalStorage {
261 
262     function EternalStorageProxyForStormMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
263 
264 }