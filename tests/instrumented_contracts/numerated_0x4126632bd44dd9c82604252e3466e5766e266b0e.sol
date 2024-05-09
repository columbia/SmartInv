1 // File: contracts/EternalStorage.sol
2 
3 // Initial code from Roman Storm Multi Sender
4 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
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
23 // File: contracts/Proxy.sol
24 
25 // Initial code from Roman Storm Multi Sender
26 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
27 pragma solidity 0.4.23;
28 
29 /**
30  * @title Proxy
31  * @dev Gives the possibility to delegate any call to a foreign implementation.
32  */
33 contract Proxy {
34 
35     /**
36     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
37     * This function will return whatever the implementation call returns
38     */
39     function () public payable {
40         address _impl = implementation();
41         require(_impl != address(0));
42         bytes memory data = msg.data;
43 
44         assembly {
45             let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
46             let size := returndatasize
47 
48             let ptr := mload(0x40)
49             returndatacopy(ptr, 0, size)
50 
51             switch result
52             case 0 { revert(ptr, size) }
53             default { return(ptr, size) }
54         }
55     }
56 
57     /**
58     * @dev Tells the address of the implementation where every call will be delegated.
59     * @return address of the implementation to which it will be delegated
60     */
61     function implementation() public view returns (address);
62 }
63 
64 // File: contracts/UpgradeabilityStorage.sol
65 
66 // Initial code from Roman Storm Multi Sender
67 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
68 pragma solidity 0.4.23;
69 
70 /**
71  * @title UpgradeabilityStorage
72  * @dev This contract holds all the necessary state variables to support the upgrade functionality
73  */
74 contract UpgradeabilityStorage {
75   // Version name of the current implementation
76     string internal _version;
77 
78     // Address of the current implementation
79     address internal _implementation;
80 
81     /**
82     * @dev Tells the version name of the current implementation
83     * @return string representing the name of the current version
84     */
85     function version() public view returns (string) {
86         return _version;
87     }
88 
89     /**
90     * @dev Tells the address of the current implementation
91     * @return address of the current implementation
92     */
93     function implementation() public view returns (address) {
94         return _implementation;
95     }
96 }
97 
98 // File: contracts/UpgradeabilityProxy.sol
99 
100 // Initial code from Roman Storm Multi Sender
101 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
102 pragma solidity 0.4.23;
103 
104 
105 
106 /**
107  * @title UpgradeabilityProxy
108  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
109  */
110 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
111   /**
112   * @dev This event will be emitted every time the implementation gets upgraded
113   * @param version representing the version name of the upgraded implementation
114   * @param implementation representing the address of the upgraded implementation
115   */
116     event Upgraded(string version, address indexed implementation);
117 
118     /**
119     * @dev Upgrades the implementation address
120     * @param version representing the version name of the new implementation to be set
121     * @param implementation representing the address of the new implementation to be set
122     */
123     function _upgradeTo(string version, address implementation) internal {
124         require(_implementation != implementation);
125         _version = version;
126         _implementation = implementation;
127         emit Upgraded(version, implementation);
128     }
129 }
130 
131 // File: contracts/UpgradeabilityOwnerStorage.sol
132 
133 // Initial code from Roman Storm Multi Sender
134 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
135 pragma solidity 0.4.23;
136 
137 /**
138  * @title UpgradeabilityOwnerStorage
139  * @dev This contract keeps track of the upgradeability owner
140  */
141 contract UpgradeabilityOwnerStorage {
142   // Owner of the contract
143     address private _upgradeabilityOwner;
144 
145     /**
146     * @dev Tells the address of the owner
147     * @return the address of the owner
148     */
149     function upgradeabilityOwner() public view returns (address) {
150         return _upgradeabilityOwner;
151     }
152 
153     /**
154     * @dev Sets the address of the owner
155     */
156     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
157         _upgradeabilityOwner = newUpgradeabilityOwner;
158     }
159 
160 }
161 
162 // File: contracts/OwnedUpgradeabilityProxy.sol
163 
164 // Initial code from Roman Storm Multi Sender
165 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
166 pragma solidity 0.4.23;
167 
168 
169 
170 /**
171  * @title OwnedUpgradeabilityProxy
172  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
173  */
174 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
175     /**
176     * @dev Event to show ownership has been transferred
177     * @param previousOwner representing the address of the previous owner
178     * @param newOwner representing the address of the new owner
179     */
180     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
181 
182     /**
183     * @dev the constructor sets the original owner of the contract to the sender account.
184     */
185     constructor(address _owner) public {
186         setUpgradeabilityOwner(_owner);
187     }
188 
189     /**
190     * @dev Throws if called by any account other than the owner.
191     */
192     modifier onlyProxyOwner() {
193         require(msg.sender == proxyOwner());
194         _;
195     }
196 
197     /**
198     * @dev Tells the address of the proxy owner
199     * @return the address of the proxy owner
200     */
201     function proxyOwner() public view returns (address) {
202         return upgradeabilityOwner();
203     }
204 
205     /**
206     * @dev Allows the current owner to transfer control of the contract to a newOwner.
207     * @param newOwner The address to transfer ownership to.
208     */
209     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
210         require(newOwner != address(0));
211         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
212         setUpgradeabilityOwner(newOwner);
213     }
214 
215     /**
216     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
217     * @param version representing the version name of the new implementation to be set.
218     * @param implementation representing the address of the new implementation to be set.
219     */
220     function upgradeTo(string version, address implementation) public onlyProxyOwner {
221         _upgradeTo(version, implementation);
222     }
223 
224     /**
225     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
226     * to initialize whatever is needed through a low level call.
227     * @param version representing the version name of the new implementation to be set.
228     * @param implementation representing the address of the new implementation to be set.
229     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
230     * signature of the implementation to be called with the needed payload
231     */
232     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
233         upgradeTo(version, implementation);
234         require(address(this).call.value(msg.value)(data));
235     }
236 }
237 
238 // File: contracts\EternalStorageProxyForBulkTokenSending.sol
239 
240 // Initial code from Roman Storm Multi Sender
241 // To Use this Dapp: https://bulktokensending.github.io/bulktokensending
242 pragma solidity 0.4.23;
243 
244 
245 
246 /**
247  * @title EternalStorageProxy
248  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
249  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
250  * authorization control functionalities
251  */
252 contract EternalStorageProxyForBulkTokenSending is OwnedUpgradeabilityProxy, EternalStorage {
253     constructor(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
254 }