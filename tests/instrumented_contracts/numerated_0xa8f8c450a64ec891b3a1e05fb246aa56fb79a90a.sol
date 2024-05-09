1 
2 // File: zos-lib/contracts/upgradeability/Proxy.sol
3 
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title Proxy
8  * @dev Implements delegation of calls to other contracts, with proper
9  * forwarding of return values and bubbling of failures.
10  * It defines a fallback function that delegates all calls to the address
11  * returned by the abstract _implementation() internal function.
12  */
13 contract Proxy {
14   /**
15    * @dev Fallback function.
16    * Implemented entirely in `_fallback`.
17    */
18   function () payable external {
19     _fallback();
20   }
21 
22   /**
23    * @return The Address of the implementation.
24    */
25   function _implementation() internal view returns (address);
26 
27   /**
28    * @dev Delegates execution to an implementation contract.
29    * This is a low level function that doesn't return to its internal call site.
30    * It will return to the external caller whatever the implementation returns.
31    * @param implementation Address to delegate.
32    */
33   function _delegate(address implementation) internal {
34     assembly {
35       // Copy msg.data. We take full control of memory in this inline assembly
36       // block because it will not return to Solidity code. We overwrite the
37       // Solidity scratch pad at memory position 0.
38       calldatacopy(0, 0, calldatasize)
39 
40       // Call the implementation.
41       // out and outsize are 0 because we don't know the size yet.
42       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
43 
44       // Copy the returned data.
45       returndatacopy(0, 0, returndatasize)
46 
47       switch result
48       // delegatecall returns 0 on error.
49       case 0 { revert(0, returndatasize) }
50       default { return(0, returndatasize) }
51     }
52   }
53 
54   /**
55    * @dev Function that is run as the first thing in the fallback function.
56    * Can be redefined in derived contracts to add functionality.
57    * Redefinitions must call super._willFallback().
58    */
59   function _willFallback() internal {
60   }
61 
62   /**
63    * @dev fallback implementation.
64    * Extracted to enable manual triggering.
65    */
66   function _fallback() internal {
67     _willFallback();
68     _delegate(_implementation());
69   }
70 }
71 
72 // File: zos-lib/contracts/utils/Address.sol
73 
74 pragma solidity ^0.5.0;
75 
76 /**
77  * Utility library of inline functions on addresses
78  *
79  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
80  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
81  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
82  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
83  */
84 library ZOSLibAddress {
85     /**
86      * Returns whether the target address is a contract
87      * @dev This function will return false if invoked during the constructor of a contract,
88      * as the code is not actually created until after the constructor finishes.
89      * @param account address of the account to check
90      * @return whether the target address is a contract
91      */
92     function isContract(address account) internal view returns (bool) {
93         uint256 size;
94         // XXX Currently there is no better way to check if there is a contract in an address
95         // than to check the size of the code at that address.
96         // See https://ethereum.stackexchange.com/a/14016/36603
97         // for more details about how this works.
98         // TODO Check this again before the Serenity release, because all addresses will be
99         // contracts then.
100         // solhint-disable-next-line no-inline-assembly
101         assembly { size := extcodesize(account) }
102         return size > 0;
103     }
104 }
105 
106 // File: zos-lib/contracts/upgradeability/BaseUpgradeabilityProxy.sol
107 
108 pragma solidity ^0.5.0;
109 
110 
111 
112 /**
113  * @title BaseUpgradeabilityProxy
114  * @dev This contract implements a proxy that allows to change the
115  * implementation address to which it will delegate.
116  * Such a change is called an implementation upgrade.
117  */
118 contract BaseUpgradeabilityProxy is Proxy {
119   /**
120    * @dev Emitted when the implementation is upgraded.
121    * @param implementation Address of the new implementation.
122    */
123   event Upgraded(address indexed implementation);
124 
125   /**
126    * @dev Storage slot with the address of the current implementation.
127    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
128    * validated in the constructor.
129    */
130   bytes32 internal constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
131 
132   /**
133    * @dev Returns the current implementation.
134    * @return Address of the current implementation
135    */
136   function _implementation() internal view returns (address impl) {
137     bytes32 slot = IMPLEMENTATION_SLOT;
138     assembly {
139       impl := sload(slot)
140     }
141   }
142 
143   /**
144    * @dev Upgrades the proxy to a new implementation.
145    * @param newImplementation Address of the new implementation.
146    */
147   function _upgradeTo(address newImplementation) internal {
148     _setImplementation(newImplementation);
149     emit Upgraded(newImplementation);
150   }
151 
152   /**
153    * @dev Sets the implementation address of the proxy.
154    * @param newImplementation Address of the new implementation.
155    */
156   function _setImplementation(address newImplementation) internal {
157     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
158 
159     bytes32 slot = IMPLEMENTATION_SLOT;
160 
161     assembly {
162       sstore(slot, newImplementation)
163     }
164   }
165 }
166 
167 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
168 
169 pragma solidity ^0.5.0;
170 
171 
172 /**
173  * @title UpgradeabilityProxy
174  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
175  * implementation and init data.
176  */
177 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
178   /**
179    * @dev Contract constructor.
180    * @param _logic Address of the initial implementation.
181    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
182    * It should include the signature and the parameters of the function to be called, as described in
183    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
184    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
185    */
186   constructor(address _logic, bytes memory _data) public payable {
187     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
188     _setImplementation(_logic);
189     if(_data.length > 0) {
190       (bool success,) = _logic.delegatecall(_data);
191       require(success);
192     }
193   }  
194 }
195 
196 // File: zos-lib/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
197 
198 pragma solidity ^0.5.0;
199 
200 
201 /**
202  * @title BaseAdminUpgradeabilityProxy
203  * @dev This contract combines an upgradeability proxy with an authorization
204  * mechanism for administrative tasks.
205  * All external functions in this contract must be guarded by the
206  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
207  * feature proposal that would enable this to be done automatically.
208  */
209 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
210   /**
211    * @dev Emitted when the administration has been transferred.
212    * @param previousAdmin Address of the previous admin.
213    * @param newAdmin Address of the new admin.
214    */
215   event AdminChanged(address previousAdmin, address newAdmin);
216 
217   /**
218    * @dev Storage slot with the admin of the contract.
219    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
220    * validated in the constructor.
221    */
222   bytes32 internal constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
223 
224   /**
225    * @dev Modifier to check whether the `msg.sender` is the admin.
226    * If it is, it will run the function. Otherwise, it will delegate the call
227    * to the implementation.
228    */
229   modifier ifAdmin() {
230     if (msg.sender == _admin()) {
231       _;
232     } else {
233       _fallback();
234     }
235   }
236 
237   /**
238    * @return The address of the proxy admin.
239    */
240   function admin() external ifAdmin returns (address) {
241     return _admin();
242   }
243 
244   /**
245    * @return The address of the implementation.
246    */
247   function implementation() external ifAdmin returns (address) {
248     return _implementation();
249   }
250 
251   /**
252    * @dev Changes the admin of the proxy.
253    * Only the current admin can call this function.
254    * @param newAdmin Address to transfer proxy administration to.
255    */
256   function changeAdmin(address newAdmin) external ifAdmin {
257     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
258     emit AdminChanged(_admin(), newAdmin);
259     _setAdmin(newAdmin);
260   }
261 
262   /**
263    * @dev Upgrade the backing implementation of the proxy.
264    * Only the admin can call this function.
265    * @param newImplementation Address of the new implementation.
266    */
267   function upgradeTo(address newImplementation) external ifAdmin {
268     _upgradeTo(newImplementation);
269   }
270 
271   /**
272    * @dev Upgrade the backing implementation of the proxy and call a function
273    * on the new implementation.
274    * This is useful to initialize the proxied contract.
275    * @param newImplementation Address of the new implementation.
276    * @param data Data to send as msg.data in the low level call.
277    * It should include the signature and the parameters of the function to be called, as described in
278    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
279    */
280   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
281     _upgradeTo(newImplementation);
282     (bool success,) = newImplementation.delegatecall(data);
283     require(success);
284   }
285 
286   /**
287    * @return The admin slot.
288    */
289   function _admin() internal view returns (address adm) {
290     bytes32 slot = ADMIN_SLOT;
291     assembly {
292       adm := sload(slot)
293     }
294   }
295 
296   /**
297    * @dev Sets the address of the proxy admin.
298    * @param newAdmin Address of the new proxy admin.
299    */
300   function _setAdmin(address newAdmin) internal {
301     bytes32 slot = ADMIN_SLOT;
302 
303     assembly {
304       sstore(slot, newAdmin)
305     }
306   }
307 
308   /**
309    * @dev Only fall back when the sender is not the admin.
310    */
311   function _willFallback() internal {
312     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
313     super._willFallback();
314   }
315 }
316 
317 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
318 
319 pragma solidity ^0.5.0;
320 
321 
322 /**
323  * @title AdminUpgradeabilityProxy
324  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
325  * initializing the implementation, admin, and init data.
326  */
327 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
328   /**
329    * Contract constructor.
330    * @param _logic address of the initial implementation.
331    * @param _admin Address of the proxy administrator.
332    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
333    * It should include the signature and the parameters of the function to be called, as described in
334    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
335    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
336    */
337   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
338     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
339     _setAdmin(_admin);
340   }
341 }
342 
343 // File: contracts/edge/EdgeTokenProxy.sol
344 
345 /**
346  * @title EdgeTokenProxy
347  * @author Connor Howe <connor.howe@sygnum.com>
348  * @dev Proxies EdgeToken calls and enables EdgeToken upgradability.
349 */
350 pragma solidity 0.5.12;
351 
352 
353 
354 contract EdgeTokenProxy is AdminUpgradeabilityProxy {
355     constructor(address implementation, address proxyOwnerAddr, bytes memory data) public AdminUpgradeabilityProxy(implementation, proxyOwnerAddr, data) {
356     }
357 }
