1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /**
7  * @title Proxy
8  * @dev Implements delegation of calls to other contracts, with proper
9  * forwarding of return values and bubbling of failures.
10  * It defines a fallback function that delegates all calls to the address
11  * returned by the abstract _implementation() internal function.
12  */
13 abstract contract Proxy {
14   /**
15    * @dev Fallback function.
16    * Implemented entirely in `_fallback`.
17    */
18   fallback () payable external {
19     _fallback();
20   }
21   
22   receive () payable external {
23     _fallback();
24   }
25 
26   /**
27    * @return The Address of the implementation.
28    */
29   function _implementation() virtual internal view returns (address);
30 
31   /**
32    * @dev Delegates execution to an implementation contract.
33    * This is a low level function that doesn't return to its internal call site.
34    * It will return to the external caller whatever the implementation returns.
35    * @param implementation Address to delegate.
36    */
37   function _delegate(address implementation) internal {
38     assembly {
39       // Copy msg.data. We take full control of memory in this inline assembly
40       // block because it will not return to Solidity code. We overwrite the
41       // Solidity scratch pad at memory position 0.
42       calldatacopy(0, 0, calldatasize())
43 
44       // Call the implementation.
45       // out and outsize are 0 because we don't know the size yet.
46       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
47 
48       // Copy the returned data.
49       returndatacopy(0, 0, returndatasize())
50 
51       switch result
52       // delegatecall returns 0 on error.
53       case 0 { revert(0, returndatasize()) }
54       default { return(0, returndatasize()) }
55     }
56   }
57 
58   /**
59    * @dev Function that is run as the first thing in the fallback function.
60    * Can be redefined in derived contracts to add functionality.
61    * Redefinitions must call super._willFallback().
62    */
63   function _willFallback() virtual internal {
64       
65   }
66 
67   /**
68    * @dev fallback implementation.
69    * Extracted to enable manual triggering.
70    */
71   function _fallback() internal {
72     if(OpenZeppelinUpgradesAddress.isContract(msg.sender) && msg.data.length == 0 && gasleft() <= 2300)         // for receive ETH only from other contract
73         return;
74     _willFallback();
75     _delegate(_implementation());
76   }
77 }
78 
79 
80 /**
81  * @title BaseUpgradeabilityProxy
82  * @dev This contract implements a proxy that allows to change the
83  * implementation address to which it will delegate.
84  * Such a change is called an implementation upgrade.
85  */
86 abstract contract BaseUpgradeabilityProxy is Proxy {
87   /**
88    * @dev Emitted when the implementation is upgraded.
89    * @param implementation Address of the new implementation.
90    */
91   event Upgraded(address indexed implementation);
92 
93   /**
94    * @dev Storage slot with the address of the current implementation.
95    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
96    * validated in the constructor.
97    */
98   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
99 
100   /**
101    * @dev Returns the current implementation.
102    * @return impl Address of the current implementation
103    */
104   function _implementation() override internal view returns (address impl) {
105     bytes32 slot = IMPLEMENTATION_SLOT;
106     assembly {
107       impl := sload(slot)
108     }
109   }
110 
111   /**
112    * @dev Upgrades the proxy to a new implementation.
113    * @param newImplementation Address of the new implementation.
114    */
115   function _upgradeTo(address newImplementation) internal {
116     _setImplementation(newImplementation);
117     emit Upgraded(newImplementation);
118   }
119 
120   /**
121    * @dev Sets the implementation address of the proxy.
122    * @param newImplementation Address of the new implementation.
123    */
124   function _setImplementation(address newImplementation) internal {
125     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
126 
127     bytes32 slot = IMPLEMENTATION_SLOT;
128 
129     assembly {
130       sstore(slot, newImplementation)
131     }
132   }
133 }
134 
135 
136 /**
137  * @title BaseAdminUpgradeabilityProxy
138  * @dev This contract combines an upgradeability proxy with an authorization
139  * mechanism for administrative tasks.
140  * All external functions in this contract must be guarded by the
141  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
142  * feature proposal that would enable this to be done automatically.
143  */
144 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
145   /**
146    * @dev Emitted when the administration has been transferred.
147    * @param previousAdmin Address of the previous admin.
148    * @param newAdmin Address of the new admin.
149    */
150   event AdminChanged(address previousAdmin, address newAdmin);
151 
152   /**
153    * @dev Storage slot with the admin of the contract.
154    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
155    * validated in the constructor.
156    */
157 
158   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
159 
160   /**
161    * @dev Modifier to check whether the `msg.sender` is the admin.
162    * If it is, it will run the function. Otherwise, it will delegate the call
163    * to the implementation.
164    */
165   modifier ifAdmin() {
166     if (msg.sender == _admin()) {
167       _;
168     } else {
169       _fallback();
170     }
171   }
172 
173   /**
174    * @return The address of the proxy admin.
175    */
176   function admin() external ifAdmin returns (address) {
177     return _admin();
178   }
179 
180   /**
181    * @return The address of the implementation.
182    */
183   function implementation() external ifAdmin returns (address) {
184     return _implementation();
185   }
186 
187   /**
188    * @dev Changes the admin of the proxy.
189    * Only the current admin can call this function.
190    * @param newAdmin Address to transfer proxy administration to.
191    */
192   function changeAdmin(address newAdmin) external ifAdmin {
193     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
194     emit AdminChanged(_admin(), newAdmin);
195     _setAdmin(newAdmin);
196   }
197 
198   /**
199    * @dev Upgrade the backing implementation of the proxy.
200    * Only the admin can call this function.
201    * @param newImplementation Address of the new implementation.
202    */
203   function upgradeTo(address newImplementation) external ifAdmin {
204     _upgradeTo(newImplementation);
205   }
206 
207   /**
208    * @dev Upgrade the backing implementation of the proxy and call a function
209    * on the new implementation.
210    * This is useful to initialize the proxied contract.
211    * @param newImplementation Address of the new implementation.
212    * @param data Data to send as msg.data in the low level call.
213    * It should include the signature and the parameters of the function to be called, as described in
214    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
215    */
216   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
217     _upgradeTo(newImplementation);
218     (bool success,) = newImplementation.delegatecall(data);
219     require(success);
220   }
221 
222   /**
223    * @return adm The admin slot.
224    */
225   function _admin() internal view returns (address adm) {
226     bytes32 slot = ADMIN_SLOT;
227     assembly {
228       adm := sload(slot)
229     }
230   }
231 
232   /**
233    * @dev Sets the address of the proxy admin.
234    * @param newAdmin Address of the new proxy admin.
235    */
236   function _setAdmin(address newAdmin) internal {
237     bytes32 slot = ADMIN_SLOT;
238 
239     assembly {
240       sstore(slot, newAdmin)
241     }
242   }
243 
244   /**
245    * @dev Only fall back when the sender is not the admin.
246    */
247   function _willFallback() virtual override internal {
248     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
249     //super._willFallback();
250   }
251 }
252 
253 interface IAdminUpgradeabilityProxyView {
254   function admin() external view returns (address);
255   function implementation() external view returns (address);
256 }
257 
258 
259 /**
260  * @title UpgradeabilityProxy
261  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
262  * implementation and init data.
263  */
264 abstract contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
265   /**
266    * @dev Contract constructor.
267    * @param _logic Address of the initial implementation.
268    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
269    * It should include the signature and the parameters of the function to be called, as described in
270    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
271    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
272    */
273   constructor(address _logic, bytes memory _data) public payable {
274     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
275     _setImplementation(_logic);
276     if(_data.length > 0) {
277       (bool success,) = _logic.delegatecall(_data);
278       require(success);
279     }
280   }  
281   
282   //function _willFallback() virtual override internal {
283     //super._willFallback();
284   //}
285 }
286 
287 
288 /**
289  * @title AdminUpgradeabilityProxy
290  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
291  * initializing the implementation, admin, and init data.
292  */
293 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
294   /**
295    * Contract constructor.
296    * @param _logic address of the initial implementation.
297    * @param _admin Address of the proxy administrator.
298    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
299    * It should include the signature and the parameters of the function to be called, as described in
300    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
301    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
302    */
303   constructor(address _admin, address _logic, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
304     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
305     _setAdmin(_admin);
306   }
307   
308   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
309     super._willFallback();
310   }
311 }
312 
313 
314 /**
315  * @title InitializableUpgradeabilityProxy
316  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
317  * implementation and init data.
318  */
319 abstract contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
320   /**
321    * @dev Contract initializer.
322    * @param _logic Address of the initial implementation.
323    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
324    * It should include the signature and the parameters of the function to be called, as described in
325    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
326    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
327    */
328   function initialize(address _logic, bytes memory _data) public payable {
329     require(_implementation() == address(0));
330     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
331     _setImplementation(_logic);
332     if(_data.length > 0) {
333       (bool success,) = _logic.delegatecall(_data);
334       require(success);
335     }
336   }  
337 }
338 
339 
340 /**
341  * @title InitializableAdminUpgradeabilityProxy
342  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
343  * initializing the implementation, admin, and init data.
344  */
345 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
346   /**
347    * Contract initializer.
348    * @param _logic address of the initial implementation.
349    * @param _admin Address of the proxy administrator.
350    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
351    * It should include the signature and the parameters of the function to be called, as described in
352    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
353    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
354    */
355   function initialize(address _admin, address _logic, bytes memory _data) public payable {
356     require(_implementation() == address(0));
357     InitializableUpgradeabilityProxy.initialize(_logic, _data);
358     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
359     _setAdmin(_admin);
360   }
361   
362   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
363     super._willFallback();
364   }
365 
366 }
367 
368 
369 interface IProxyFactory {
370     function productImplementation() external view returns (address);
371     function productImplementations(bytes32 name) external view returns (address);
372 }
373 
374 
375 /**
376  * @title ProductProxy
377  * @dev This contract implements a proxy that 
378  * it is deploied by ProxyFactory, 
379  * and it's implementation is stored in factory.
380  */
381 contract ProductProxy is Proxy {
382     
383   /**
384    * @dev Storage slot with the address of the ProxyFactory.
385    * This is the keccak-256 hash of "eip1967.proxy.factory" subtracted by 1, and is
386    * validated in the constructor.
387    */
388   bytes32 internal constant FACTORY_SLOT = 0x7a45a402e4cb6e08ebc196f20f66d5d30e67285a2a8aa80503fa409e727a4af1;
389 
390   function productName() virtual public pure returns (bytes32) {
391     return 0x0;
392   }
393 
394   /**
395    * @dev Sets the factory address of the ProductProxy.
396    * @param newFactory Address of the new factory.
397    */
398   function _setFactory(address newFactory) internal {
399     require(OpenZeppelinUpgradesAddress.isContract(newFactory), "Cannot set a factory to a non-contract address");
400 
401     bytes32 slot = FACTORY_SLOT;
402 
403     assembly {
404       sstore(slot, newFactory)
405     }
406   }
407 
408   /**
409    * @dev Returns the factory.
410    * @return factory Address of the factory.
411    */
412   function _factory() internal view returns (address factory) {
413     bytes32 slot = FACTORY_SLOT;
414     assembly {
415       factory := sload(slot)
416     }
417   }
418   
419   /**
420    * @dev Returns the current implementation.
421    * @return Address of the current implementation
422    */
423   function _implementation() virtual override internal view returns (address) {
424     address factory = _factory();
425     if(OpenZeppelinUpgradesAddress.isContract(factory))
426         return IProxyFactory(factory).productImplementations(productName());
427     else
428         return address(0);
429   }
430 
431 }
432 
433 
434 /**
435  * @title InitializableProductProxy
436  * @dev Extends ProductProxy with an initializer for initializing
437  * factory and init data.
438  */
439 contract InitializableProductProxy is ProductProxy {
440   /**
441    * @dev Contract initializer.
442    * @param factory Address of the initial factory.
443    * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
444    * It should include the signature and the parameters of the function to be called, as described in
445    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
446    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
447    */
448   function initialize(address factory, bytes memory data) public payable {
449     require(_factory() == address(0));
450     assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
451     _setFactory(factory);
452     if(data.length > 0) {
453       (bool success,) = _implementation().delegatecall(data);
454       require(success);
455     }
456   }  
457 }
458 
459 
460 /**
461  * Utility library of inline functions on addresses
462  *
463  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
464  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
465  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
466  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
467  */
468 library OpenZeppelinUpgradesAddress {
469     /**
470      * Returns whether the target address is a contract
471      * @dev This function will return false if invoked during the constructor of a contract,
472      * as the code is not actually created until after the constructor finishes.
473      * @param account address of the account to check
474      * @return whether the target address is a contract
475      */
476     function isContract(address account) internal view returns (bool) {
477         uint256 size;
478         // XXX Currently there is no better way to check if there is a contract in an address
479         // than to check the size of the code at that address.
480         // See https://ethereum.stackexchange.com/a/14016/36603
481         // for more details about how this works.
482         // TODO Check this again before the Serenity release, because all addresses will be
483         // contracts then.
484         // solhint-disable-next-line no-inline-assembly
485         assembly { size := extcodesize(account) }
486         return size > 0;
487     }
488 }