1 pragma solidity 0.4.24;
2 
3 // File: zos-lib/contracts/upgradeability/Proxy.sol
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   function () payable external {
18     _fallback();
19   }
20 
21   /**
22    * @return The Address of the implementation.
23    */
24   function _implementation() internal view returns (address);
25 
26   /**
27    * @dev Delegates execution to an implementation contract.
28    * This is a low level function that doesn't return to its internal call site.
29    * It will return to the external caller whatever the implementation returns.
30    * @param implementation Address to delegate.
31    */
32   function _delegate(address implementation) internal {
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize)
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize)
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 { revert(0, returndatasize) }
49       default { return(0, returndatasize) }
50     }
51   }
52 
53   /**
54    * @dev Function that is run as the first thing in the fallback function.
55    * Can be redefined in derived contracts to add functionality.
56    * Redefinitions must call super._willFallback().
57    */
58   function _willFallback() internal {
59   }
60 
61   /**
62    * @dev fallback implementation.
63    * Extracted to enable manual triggering.
64    */
65   function _fallback() internal {
66     _willFallback();
67     _delegate(_implementation());
68   }
69 }
70 
71 // File: openzeppelin-solidity/contracts/AddressUtils.sol
72 
73 /**
74  * Utility library of inline functions on addresses
75  */
76 library AddressUtils {
77 
78   /**
79    * Returns whether the target address is a contract
80    * @dev This function will return false if invoked during the constructor of a contract,
81    * as the code is not actually created until after the constructor finishes.
82    * @param addr address to check
83    * @return whether the target address is a contract
84    */
85   function isContract(address addr) internal view returns (bool) {
86     uint256 size;
87     assembly { size := extcodesize(addr) }
88     return size > 0;
89   }
90 
91 }
92 
93 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
94 
95 /**
96  * @title UpgradeabilityProxy
97  * @dev This contract implements a proxy that allows to change the
98  * implementation address to which it will delegate.
99  * Such a change is called an implementation upgrade.
100  */
101 contract UpgradeabilityProxy is Proxy {
102   /**
103    * @dev Emitted when the implementation is upgraded.
104    * @param implementation Address of the new implementation.
105    */
106   event Upgraded(address implementation);
107 
108   /**
109    * @dev Storage slot with the address of the current implementation.
110    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
111    * validated in the constructor.
112    */
113   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
114 
115   /**
116    * @dev Contract constructor.
117    * @param _implementation Address of the initial implementation.
118    */
119   constructor(address _implementation) public {
120     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
121 
122     _setImplementation(_implementation);
123   }
124 
125   /**
126    * @dev Returns the current implementation.
127    * @return Address of the current implementation
128    */
129   function _implementation() internal view returns (address impl) {
130     bytes32 slot = IMPLEMENTATION_SLOT;
131     assembly {
132       impl := sload(slot)
133     }
134   }
135 
136   /**
137    * @dev Upgrades the proxy to a new implementation.
138    * @param newImplementation Address of the new implementation.
139    */
140   function _upgradeTo(address newImplementation) internal {
141     _setImplementation(newImplementation);
142     emit Upgraded(newImplementation);
143   }
144 
145   /**
146    * @dev Sets the implementation address of the proxy.
147    * @param newImplementation Address of the new implementation.
148    */
149   function _setImplementation(address newImplementation) private {
150     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
151 
152     bytes32 slot = IMPLEMENTATION_SLOT;
153 
154     assembly {
155       sstore(slot, newImplementation)
156     }
157   }
158 }
159 
160 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
161 
162 /**
163  * @title AdminUpgradeabilityProxy
164  * @dev This contract combines an upgradeability proxy with an authorization
165  * mechanism for administrative tasks.
166  * All external functions in this contract must be guarded by the
167  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
168  * feature proposal that would enable this to be done automatically.
169  */
170 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
171   /**
172    * @dev Emitted when the administration has been transferred.
173    * @param previousAdmin Address of the previous admin.
174    * @param newAdmin Address of the new admin.
175    */
176   event AdminChanged(address previousAdmin, address newAdmin);
177 
178   /**
179    * @dev Storage slot with the admin of the contract.
180    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
181    * validated in the constructor.
182    */
183   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
184 
185   /**
186    * @dev Modifier to check whether the `msg.sender` is the admin.
187    * If it is, it will run the function. Otherwise, it will delegate the call
188    * to the implementation.
189    */
190   modifier ifAdmin() {
191     if (msg.sender == _admin()) {
192       _;
193     } else {
194       _fallback();
195     }
196   }
197 
198   /**
199    * Contract constructor.
200    * It sets the `msg.sender` as the proxy administrator.
201    * @param _implementation address of the initial implementation.
202    */
203   constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
204     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
205 
206     _setAdmin(msg.sender);
207   }
208 
209   /**
210    * @return The address of the proxy admin.
211    */
212   function admin() external view ifAdmin returns (address) {
213     return _admin();
214   }
215 
216   /**
217    * @return The address of the implementation.
218    */
219   function implementation() external view ifAdmin returns (address) {
220     return _implementation();
221   }
222 
223   /**
224    * @dev Changes the admin of the proxy.
225    * Only the current admin can call this function.
226    * @param newAdmin Address to transfer proxy administration to.
227    */
228   function changeAdmin(address newAdmin) external ifAdmin {
229     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
230     emit AdminChanged(_admin(), newAdmin);
231     _setAdmin(newAdmin);
232   }
233 
234   /**
235    * @dev Upgrade the backing implementation of the proxy.
236    * Only the admin can call this function.
237    * @param newImplementation Address of the new implementation.
238    */
239   function upgradeTo(address newImplementation) external ifAdmin {
240     _upgradeTo(newImplementation);
241   }
242 
243   /**
244    * @dev Upgrade the backing implementation of the proxy and call a function
245    * on the new implementation.
246    * This is useful to initialize the proxied contract.
247    * @param newImplementation Address of the new implementation.
248    * @param data Data to send as msg.data in the low level call.
249    * It should include the signature and the parameters of the function to be
250    * called, as described in
251    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
252    */
253   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
254     _upgradeTo(newImplementation);
255     require(address(this).call.value(msg.value)(data));
256   }
257 
258   /**
259    * @return The admin slot.
260    */
261   function _admin() internal view returns (address adm) {
262     bytes32 slot = ADMIN_SLOT;
263     assembly {
264       adm := sload(slot)
265     }
266   }
267 
268   /**
269    * @dev Sets the address of the proxy admin.
270    * @param newAdmin Address of the new proxy admin.
271    */
272   function _setAdmin(address newAdmin) internal {
273     bytes32 slot = ADMIN_SLOT;
274 
275     assembly {
276       sstore(slot, newAdmin)
277     }
278   }
279 
280   /**
281    * @dev Only fall back when the sender is not the admin.
282    */
283   function _willFallback() internal {
284     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
285     super._willFallback();
286   }
287 }
288 
289 // File: contracts/PintuTokenProxy.sol
290 
291 /**
292  * @title PintuTokenProxy
293  * @dev This contract proxies PintuToken calls and enables PintuToken upgrades
294 */ 
295 contract PintuTokenProxy is AdminUpgradeabilityProxy {
296     constructor(address _implementation) public AdminUpgradeabilityProxy(_implementation) {
297     }
298 }