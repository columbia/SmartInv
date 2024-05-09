1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 
10 /**
11  * @title Proxy
12  * @dev Implements delegation of calls to other contracts, with proper
13  * forwarding of return values and bubbling of failures.
14  * It defines a fallback function that delegates all calls to the address
15  * returned by the abstract _implementation() internal function.
16  */
17 abstract contract Proxy {
18   /**
19    * @dev Fallback function.
20    * Implemented entirely in `_fallback`.
21    */
22   fallback () payable external {
23     _fallback();
24   }
25   
26   receive () payable external {
27     _fallback();
28   }
29 
30   /**
31    * @return The Address of the implementation.
32    */
33   function _implementation() virtual internal view returns (address);
34 
35   /**
36    * @dev Delegates execution to an implementation contract.
37    * This is a low level function that doesn't return to its internal call site.
38    * It will return to the external caller whatever the implementation returns.
39    * @param implementation Address to delegate.
40    */
41   function _delegate(address implementation) internal {
42     assembly {
43       // Copy msg.data. We take full control of memory in this inline assembly
44       // block because it will not return to Solidity code. We overwrite the
45       // Solidity scratch pad at memory position 0.
46       calldatacopy(0, 0, calldatasize())
47 
48       // Call the implementation.
49       // out and outsize are 0 because we don't know the size yet.
50       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
51 
52       // Copy the returned data.
53       returndatacopy(0, 0, returndatasize())
54 
55       switch result
56       // delegatecall returns 0 on error.
57       case 0 { revert(0, returndatasize()) }
58       default { return(0, returndatasize()) }
59     }
60   }
61 
62   /**
63    * @dev Function that is run as the first thing in the fallback function.
64    * Can be redefined in derived contracts to add functionality.
65    * Redefinitions must call super._willFallback().
66    */
67   function _willFallback() virtual internal {
68       
69   }
70 
71   /**
72    * @dev fallback implementation.
73    * Extracted to enable manual triggering.
74    */
75   function _fallback() internal {
76     if(OpenZeppelinUpgradesAddress.isContract(msg.sender) && msg.data.length == 0 && gasleft() <= 2300)         // for receive ETH only from other contract
77         return;
78     _willFallback();
79     _delegate(_implementation());
80   }
81 }
82 
83 
84 /**
85  * @title BaseUpgradeabilityProxy
86  * @dev This contract implements a proxy that allows to change the
87  * implementation address to which it will delegate.
88  * Such a change is called an implementation upgrade.
89  */
90 abstract contract BaseUpgradeabilityProxy is Proxy {
91   /**
92    * @dev Emitted when the implementation is upgraded.
93    * @param implementation Address of the new implementation.
94    */
95   event Upgraded(address indexed implementation);
96 
97   /**
98    * @dev Storage slot with the address of the current implementation.
99    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
100    * validated in the constructor.
101    */
102   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
103 
104   /**
105    * @dev Returns the current implementation.
106    * @return impl Address of the current implementation
107    */
108   function _implementation() override internal view returns (address impl) {
109     bytes32 slot = IMPLEMENTATION_SLOT;
110     assembly {
111       impl := sload(slot)
112     }
113   }
114 
115   /**
116    * @dev Upgrades the proxy to a new implementation.
117    * @param newImplementation Address of the new implementation.
118    */
119   function _upgradeTo(address newImplementation) internal {
120     _setImplementation(newImplementation);
121     emit Upgraded(newImplementation);
122   }
123 
124   /**
125    * @dev Sets the implementation address of the proxy.
126    * @param newImplementation Address of the new implementation.
127    */
128   function _setImplementation(address newImplementation) internal {
129     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
130 
131     bytes32 slot = IMPLEMENTATION_SLOT;
132 
133     assembly {
134       sstore(slot, newImplementation)
135     }
136   }
137 }
138 
139 
140 /**
141  * @title BaseAdminUpgradeabilityProxy
142  * @dev This contract combines an upgradeability proxy with an authorization
143  * mechanism for administrative tasks.
144  * All external functions in this contract must be guarded by the
145  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
146  * feature proposal that would enable this to be done automatically.
147  */
148 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
149   /**
150    * @dev Emitted when the administration has been transferred.
151    * @param previousAdmin Address of the previous admin.
152    * @param newAdmin Address of the new admin.
153    */
154   event AdminChanged(address previousAdmin, address newAdmin);
155 
156   /**
157    * @dev Storage slot with the admin of the contract.
158    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
159    * validated in the constructor.
160    */
161 
162   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
163 
164   /**
165    * @dev Modifier to check whether the `msg.sender` is the admin.
166    * If it is, it will run the function. Otherwise, it will delegate the call
167    * to the implementation.
168    */
169   modifier ifAdmin() {
170     if (msg.sender == _admin()) {
171       _;
172     } else {
173       _fallback();
174     }
175   }
176 
177   /**
178    * @return The address of the proxy admin.
179    */
180   function admin() external ifAdmin returns (address) {
181     return _admin();
182   }
183 
184   /**
185    * @return The address of the implementation.
186    */
187   function implementation() external ifAdmin returns (address) {
188     return _implementation();
189   }
190 
191   /**
192    * @dev Changes the admin of the proxy.
193    * Only the current admin can call this function.
194    * @param newAdmin Address to transfer proxy administration to.
195    */
196   function changeAdmin(address newAdmin) external ifAdmin {
197     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
198     emit AdminChanged(_admin(), newAdmin);
199     _setAdmin(newAdmin);
200   }
201 
202   /**
203    * @dev Upgrade the backing implementation of the proxy.
204    * Only the admin can call this function.
205    * @param newImplementation Address of the new implementation.
206    */
207   function upgradeTo(address newImplementation) external ifAdmin {
208     _upgradeTo(newImplementation);
209   }
210 
211   /**
212    * @dev Upgrade the backing implementation of the proxy and call a function
213    * on the new implementation.
214    * This is useful to initialize the proxied contract.
215    * @param newImplementation Address of the new implementation.
216    * @param data Data to send as msg.data in the low level call.
217    * It should include the signature and the parameters of the function to be called, as described in
218    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
219    */
220   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
221     _upgradeTo(newImplementation);
222     (bool success,) = newImplementation.delegatecall(data);
223     require(success);
224   }
225 
226   /**
227    * @return adm The admin slot.
228    */
229   function _admin() internal view returns (address adm) {
230     bytes32 slot = ADMIN_SLOT;
231     assembly {
232       adm := sload(slot)
233     }
234   }
235 
236   /**
237    * @dev Sets the address of the proxy admin.
238    * @param newAdmin Address of the new proxy admin.
239    */
240   function _setAdmin(address newAdmin) internal {
241     bytes32 slot = ADMIN_SLOT;
242 
243     assembly {
244       sstore(slot, newAdmin)
245     }
246   }
247 
248   /**
249    * @dev Only fall back when the sender is not the admin.
250    */
251   function _willFallback() virtual override internal {
252     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
253     //super._willFallback();
254   }
255 }
256 
257 interface IAdminUpgradeabilityProxyView {
258   function admin() external view returns (address);
259   function implementation() external view returns (address);
260 }
261 
262 
263 /**
264  * @title UpgradeabilityProxy
265  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
266  * implementation and init data.
267  */
268 abstract contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
269   /**
270    * @dev Contract constructor.
271    * @param _logic Address of the initial implementation.
272    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
273    * It should include the signature and the parameters of the function to be called, as described in
274    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
275    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
276    */
277   constructor(address _logic, bytes memory _data) public payable {
278     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
279     _setImplementation(_logic);
280     if(_data.length > 0) {
281       (bool success,) = _logic.delegatecall(_data);
282       require(success);
283     }
284   }  
285   
286   //function _willFallback() virtual override internal {
287     //super._willFallback();
288   //}
289 }
290 
291 
292 /**
293  * @title AdminUpgradeabilityProxy
294  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
295  * initializing the implementation, admin, and init data.
296  */
297 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
298   /**
299    * Contract constructor.
300    * @param _logic address of the initial implementation.
301    * @param _admin Address of the proxy administrator.
302    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
303    * It should include the signature and the parameters of the function to be called, as described in
304    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
305    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
306    */
307   constructor(address _admin, address _logic, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
308     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
309     _setAdmin(_admin);
310   }
311   
312   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
313     super._willFallback();
314   }
315 }
316 
317 
318 /**
319  * @title InitializableUpgradeabilityProxy
320  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
321  * implementation and init data.
322  */
323 abstract contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
324   /**
325    * @dev Contract initializer.
326    * @param _logic Address of the initial implementation.
327    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
328    * It should include the signature and the parameters of the function to be called, as described in
329    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
330    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
331    */
332   function initialize(address _logic, bytes memory _data) public payable {
333     require(_implementation() == address(0));
334     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
335     _setImplementation(_logic);
336     if(_data.length > 0) {
337       (bool success,) = _logic.delegatecall(_data);
338       require(success);
339     }
340   }  
341 }
342 
343 
344 /**
345  * @title InitializableAdminUpgradeabilityProxy
346  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
347  * initializing the implementation, admin, and init data.
348  */
349 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
350   /**
351    * Contract initializer.
352    * @param _logic address of the initial implementation.
353    * @param _admin Address of the proxy administrator.
354    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
355    * It should include the signature and the parameters of the function to be called, as described in
356    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
357    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
358    */
359   function initialize(address _admin, address _logic, bytes memory _data) public payable {
360     require(_implementation() == address(0));
361     InitializableUpgradeabilityProxy.initialize(_logic, _data);
362     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
363     _setAdmin(_admin);
364   }
365   
366   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
367     super._willFallback();
368   }
369 
370 }
371 
372 
373 interface IProxyFactory {
374     function productImplementation() external view returns (address);
375     function productImplementations(bytes32 name) external view returns (address);
376 }
377 
378 
379 /**
380  * @title ProductProxy
381  * @dev This contract implements a proxy that 
382  * it is deploied by ProxyFactory, 
383  * and it's implementation is stored in factory.
384  */
385 contract ProductProxy is Proxy {
386     
387   /**
388    * @dev Storage slot with the address of the ProxyFactory.
389    * This is the keccak-256 hash of "eip1967.proxy.factory" subtracted by 1, and is
390    * validated in the constructor.
391    */
392   bytes32 internal constant FACTORY_SLOT = 0x7a45a402e4cb6e08ebc196f20f66d5d30e67285a2a8aa80503fa409e727a4af1;
393 
394   function productName() virtual public pure returns (bytes32) {
395     return 0x0;
396   }
397 
398   /**
399    * @dev Sets the factory address of the ProductProxy.
400    * @param newFactory Address of the new factory.
401    */
402   function _setFactory(address newFactory) internal {
403     require(OpenZeppelinUpgradesAddress.isContract(newFactory), "Cannot set a factory to a non-contract address");
404 
405     bytes32 slot = FACTORY_SLOT;
406 
407     assembly {
408       sstore(slot, newFactory)
409     }
410   }
411 
412   /**
413    * @dev Returns the factory.
414    * @return factory Address of the factory.
415    */
416   function _factory() internal view returns (address factory) {
417     bytes32 slot = FACTORY_SLOT;
418     assembly {
419       factory := sload(slot)
420     }
421   }
422   
423   /**
424    * @dev Returns the current implementation.
425    * @return Address of the current implementation
426    */
427   function _implementation() virtual override internal view returns (address) {
428     address factory = _factory();
429     if(OpenZeppelinUpgradesAddress.isContract(factory))
430         return IProxyFactory(factory).productImplementations(productName());
431     else
432         return address(0);
433   }
434 
435 }
436 
437 
438 /**
439  * @title InitializableProductProxy
440  * @dev Extends ProductProxy with an initializer for initializing
441  * factory and init data.
442  */
443 contract InitializableProductProxy is ProductProxy {
444   /**
445    * @dev Contract initializer.
446    * @param factory Address of the initial factory.
447    * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
448    * It should include the signature and the parameters of the function to be called, as described in
449    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
450    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
451    */
452   function initialize(address factory, bytes memory data) public payable {
453     require(_factory() == address(0));
454     assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
455     _setFactory(factory);
456     if(data.length > 0) {
457       (bool success,) = _implementation().delegatecall(data);
458       require(success);
459     }
460   }  
461 }
462 
463 
464 /**
465  * Utility library of inline functions on addresses
466  *
467  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
468  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
469  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
470  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
471  */
472 library OpenZeppelinUpgradesAddress {
473     /**
474      * Returns whether the target address is a contract
475      * @dev This function will return false if invoked during the constructor of a contract,
476      * as the code is not actually created until after the constructor finishes.
477      * @param account address of the account to check
478      * @return whether the target address is a contract
479      */
480     function isContract(address account) internal view returns (bool) {
481         uint256 size;
482         // XXX Currently there is no better way to check if there is a contract in an address
483         // than to check the size of the code at that address.
484         // See https://ethereum.stackexchange.com/a/14016/36603
485         // for more details about how this works.
486         // TODO Check this again before the Serenity release, because all addresses will be
487         // contracts then.
488         // solhint-disable-next-line no-inline-assembly
489         assembly { size := extcodesize(account) }
490         return size > 0;
491     }
492 }