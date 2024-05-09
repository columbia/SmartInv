1 pragma solidity ^0.4.13;
2 
3 contract Proxy {
4   /**
5    * @dev Fallback function.
6    * Implemented entirely in `_fallback`.
7    */
8   function () payable external {
9     _fallback();
10   }
11 
12   /**
13    * @return The Address of the implementation.
14    */
15   function _implementation() internal view returns (address);
16 
17   /**
18    * @dev Delegates execution to an implementation contract.
19    * This is a low level function that doesn't return to its internal call site.
20    * It will return to the external caller whatever the implementation returns.
21    * @param implementation Address to delegate.
22    */
23   function _delegate(address implementation) internal {
24     assembly {
25       // Copy msg.data. We take full control of memory in this inline assembly
26       // block because it will not return to Solidity code. We overwrite the
27       // Solidity scratch pad at memory position 0.
28       calldatacopy(0, 0, calldatasize)
29 
30       // Call the implementation.
31       // out and outsize are 0 because we don't know the size yet.
32       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
33 
34       // Copy the returned data.
35       returndatacopy(0, 0, returndatasize)
36 
37       switch result
38       // delegatecall returns 0 on error.
39       case 0 { revert(0, returndatasize) }
40       default { return(0, returndatasize) }
41     }
42   }
43 
44   /**
45    * @dev Function that is run as the first thing in the fallback function.
46    * Can be redefined in derived contracts to add functionality.
47    * Redefinitions must call super._willFallback().
48    */
49   function _willFallback() internal {
50   }
51 
52   /**
53    * @dev fallback implementation.
54    * Extracted to enable manual triggering.
55    */
56   function _fallback() internal {
57     _willFallback();
58     _delegate(_implementation());
59   }
60 }
61 
62 contract UpgradeabilityProxy is Proxy {
63   /**
64    * @dev Emitted when the implementation is upgraded.
65    * @param implementation Address of the new implementation.
66    */
67   event Upgraded(address indexed implementation);
68 
69   /**
70    * @dev Storage slot with the address of the current implementation.
71    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
72    * validated in the constructor.
73    */
74   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
75 
76   /**
77    * @dev Contract constructor.
78    * @param _implementation Address of the initial implementation.
79    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
80    * It should include the signature and the parameters of the function to be called, as described in
81    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
82    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
83    */
84   constructor(address _implementation, bytes _data) public payable {
85     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
86     _setImplementation(_implementation);
87     if(_data.length > 0) {
88       require(_implementation.delegatecall(_data));
89     }
90   }
91 
92   /**
93    * @dev Returns the current implementation.
94    * @return Address of the current implementation
95    */
96   function _implementation() internal view returns (address impl) {
97     bytes32 slot = IMPLEMENTATION_SLOT;
98     assembly {
99       impl := sload(slot)
100     }
101   }
102 
103   /**
104    * @dev Upgrades the proxy to a new implementation.
105    * @param newImplementation Address of the new implementation.
106    */
107   function _upgradeTo(address newImplementation) internal {
108     _setImplementation(newImplementation);
109     emit Upgraded(newImplementation);
110   }
111 
112   /**
113    * @dev Sets the implementation address of the proxy.
114    * @param newImplementation Address of the new implementation.
115    */
116   function _setImplementation(address newImplementation) private {
117     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
118 
119     bytes32 slot = IMPLEMENTATION_SLOT;
120 
121     assembly {
122       sstore(slot, newImplementation)
123     }
124   }
125 }
126 
127 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
128   /**
129    * @dev Emitted when the administration has been transferred.
130    * @param previousAdmin Address of the previous admin.
131    * @param newAdmin Address of the new admin.
132    */
133   event AdminChanged(address previousAdmin, address newAdmin);
134 
135   /**
136    * @dev Storage slot with the admin of the contract.
137    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
138    * validated in the constructor.
139    */
140   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
141 
142   /**
143    * @dev Modifier to check whether the `msg.sender` is the admin.
144    * If it is, it will run the function. Otherwise, it will delegate the call
145    * to the implementation.
146    */
147   modifier ifAdmin() {
148     if (msg.sender == _admin()) {
149       _;
150     } else {
151       _fallback();
152     }
153   }
154 
155   /**
156    * Contract constructor.
157    * It sets the `msg.sender` as the proxy administrator.
158    * @param _implementation address of the initial implementation.
159    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
160    * It should include the signature and the parameters of the function to be called, as described in
161    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
162    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
163    */
164   constructor(address _implementation, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
165     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
166 
167     _setAdmin(msg.sender);
168   }
169 
170   /**
171    * @return The address of the proxy admin.
172    */
173   function admin() external view ifAdmin returns (address) {
174     return _admin();
175   }
176 
177   /**
178    * @return The address of the implementation.
179    */
180   function implementation() external view ifAdmin returns (address) {
181     return _implementation();
182   }
183 
184   /**
185    * @dev Changes the admin of the proxy.
186    * Only the current admin can call this function.
187    * @param newAdmin Address to transfer proxy administration to.
188    */
189   function changeAdmin(address newAdmin) external ifAdmin {
190     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
191     emit AdminChanged(_admin(), newAdmin);
192     _setAdmin(newAdmin);
193   }
194 
195   /**
196    * @dev Upgrade the backing implementation of the proxy.
197    * Only the admin can call this function.
198    * @param newImplementation Address of the new implementation.
199    */
200   function upgradeTo(address newImplementation) external ifAdmin {
201     _upgradeTo(newImplementation);
202   }
203 
204   /**
205    * @dev Upgrade the backing implementation of the proxy and call a function
206    * on the new implementation.
207    * This is useful to initialize the proxied contract.
208    * @param newImplementation Address of the new implementation.
209    * @param data Data to send as msg.data in the low level call.
210    * It should include the signature and the parameters of the function to be called, as described in
211    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
212    */
213   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
214     _upgradeTo(newImplementation);
215     require(newImplementation.delegatecall(data));
216   }
217 
218   /**
219    * @return The admin slot.
220    */
221   function _admin() internal view returns (address adm) {
222     bytes32 slot = ADMIN_SLOT;
223     assembly {
224       adm := sload(slot)
225     }
226   }
227 
228   /**
229    * @dev Sets the address of the proxy admin.
230    * @param newAdmin Address of the new proxy admin.
231    */
232   function _setAdmin(address newAdmin) internal {
233     bytes32 slot = ADMIN_SLOT;
234 
235     assembly {
236       sstore(slot, newAdmin)
237     }
238   }
239 
240   /**
241    * @dev Only fall back when the sender is not the admin.
242    */
243   function _willFallback() internal {
244     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
245     super._willFallback();
246   }
247 }
248 
249 contract InvestProxy is AdminUpgradeabilityProxy {
250   /**
251    * @return The address of the implementation.
252    */
253   function implementation() external view returns (address) {
254     return _implementation();
255   }
256   /**
257    * Contract constructor.
258    * It sets the `msg.sender` as the proxy administrator.
259    * @param _implementation address of the initial implementation.
260    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
261    * It should include the signature and the parameters of the function to be called, as described in
262    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
263    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
264    */
265   constructor(address _implementation, bytes _data) AdminUpgradeabilityProxy(_implementation, _data) public payable {
266   }
267 }
268 
269 library Address {
270     /**
271      * Returns whether the target address is a contract
272      * @dev This function will return false if invoked during the constructor of a contract,
273      * as the code is not actually created until after the constructor finishes.
274      * @param account address of the account to check
275      * @return whether the target address is a contract
276      */
277     function isContract(address account) internal view returns (bool) {
278         uint256 size;
279         // XXX Currently there is no better way to check if there is a contract in an address
280         // than to check the size of the code at that address.
281         // See https://ethereum.stackexchange.com/a/14016/36603
282         // for more details about how this works.
283         // TODO Check this again before the Serenity release, because all addresses will be
284         // contracts then.
285         // solium-disable-next-line security/no-inline-assembly
286         assembly { size := extcodesize(account) }
287         return size > 0;
288     }
289 }