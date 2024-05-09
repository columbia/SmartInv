1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 pragma experimental ABIEncoderV2;
5 
6 contract PlaceHolder {
7     
8 }
9 
10 
11 /**
12  * @title Proxy
13  * @dev Implements delegation of calls to other contracts, with proper
14  * forwarding of return values and bubbling of failures.
15  * It defines a fallback function that delegates all calls to the address
16  * returned by the abstract _implementation() internal function.
17  */
18 abstract contract Proxy {
19   /**
20    * @dev Fallback function.
21    * Implemented entirely in `_fallback`.
22    */
23   fallback () payable external {
24     _fallback();
25   }
26   
27   receive () virtual payable external {
28     _fallback();
29   }
30 
31   /**
32    * @return The Address of the implementation.
33    */
34   function _implementation() virtual internal view returns (address);
35 
36   /**
37    * @dev Delegates execution to an implementation contract.
38    * This is a low level function that doesn't return to its internal call site.
39    * It will return to the external caller whatever the implementation returns.
40    * @param implementation Address to delegate.
41    */
42   function _delegate(address implementation) internal {
43     assembly {
44       // Copy msg.data. We take full control of memory in this inline assembly
45       // block because it will not return to Solidity code. We overwrite the
46       // Solidity scratch pad at memory position 0.
47       calldatacopy(0, 0, calldatasize())
48 
49       // Call the implementation.
50       // out and outsize are 0 because we don't know the size yet.
51       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
52 
53       // Copy the returned data.
54       returndatacopy(0, 0, returndatasize())
55 
56       switch result
57       // delegatecall returns 0 on error.
58       case 0 { revert(0, returndatasize()) }
59       default { return(0, returndatasize()) }
60     }
61   }
62 
63   /**
64    * @dev Function that is run as the first thing in the fallback function.
65    * Can be redefined in derived contracts to add functionality.
66    * Redefinitions must call super._willFallback().
67    */
68   function _willFallback() virtual internal {
69       
70   }
71 
72   /**
73    * @dev fallback implementation.
74    * Extracted to enable manual triggering.
75    */
76   function _fallback() internal {
77     if(OpenZeppelinUpgradesAddress.isContract(msg.sender) && msg.data.length == 0 && gasleft() <= 2300)         // for receive ETH only from other contract
78         return;
79     _willFallback();
80     _delegate(_implementation());
81   }
82 }
83 
84 
85 /**
86  * @title BaseUpgradeabilityProxy
87  * @dev This contract implements a proxy that allows to change the
88  * implementation address to which it will delegate.
89  * Such a change is called an implementation upgrade.
90  */
91 abstract contract BaseUpgradeabilityProxy is Proxy {
92   /**
93    * @dev Emitted when the implementation is upgraded.
94    * @param implementation Address of the new implementation.
95    */
96   event Upgraded(address indexed implementation);
97 
98   /**
99    * @dev Storage slot with the address of the current implementation.
100    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
101    * validated in the constructor.
102    */
103   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
104 
105   /**
106    * @dev Returns the current implementation.
107    * @return impl Address of the current implementation
108    */
109   function _implementation() virtual override internal view returns (address impl) {
110     bytes32 slot = IMPLEMENTATION_SLOT;
111     assembly {
112       impl := sload(slot)
113     }
114   }
115 
116   /**
117    * @dev Upgrades the proxy to a new implementation.
118    * @param newImplementation Address of the new implementation.
119    */
120   function _upgradeTo(address newImplementation) internal {
121     _setImplementation(newImplementation);
122     emit Upgraded(newImplementation);
123   }
124 
125   /**
126    * @dev Sets the implementation address of the proxy.
127    * @param newImplementation Address of the new implementation.
128    */
129   function _setImplementation(address newImplementation) internal {
130     require(newImplementation == address(0) || OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
131 
132     bytes32 slot = IMPLEMENTATION_SLOT;
133 
134     assembly {
135       sstore(slot, newImplementation)
136     }
137   }
138 }
139 
140 
141 /**
142  * @title BaseAdminUpgradeabilityProxy
143  * @dev This contract combines an upgradeability proxy with an authorization
144  * mechanism for administrative tasks.
145  * All external functions in this contract must be guarded by the
146  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
147  * feature proposal that would enable this to be done automatically.
148  */
149 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
150   /**
151    * @dev Emitted when the administration has been transferred.
152    * @param previousAdmin Address of the previous admin.
153    * @param newAdmin Address of the new admin.
154    */
155   event AdminChanged(address previousAdmin, address newAdmin);
156 
157   /**
158    * @dev Storage slot with the admin of the contract.
159    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
160    * validated in the constructor.
161    */
162 
163   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
164 
165   /**
166    * @dev Modifier to check whether the `msg.sender` is the admin.
167    * If it is, it will run the function. Otherwise, it will delegate the call
168    * to the implementation.
169    */
170   modifier ifAdmin() {
171     if (msg.sender == _admin()) {
172       _;
173     } else {
174       _fallback();
175     }
176   }
177 
178   /**
179    * @return The address of the proxy admin.
180    */
181   function admin() external ifAdmin returns (address) {
182     return _admin();
183   }
184 
185   /**
186    * @return The address of the implementation.
187    */
188   function implementation() external ifAdmin returns (address) {
189     return _implementation();
190   }
191 
192   /**
193    * @dev Changes the admin of the proxy.
194    * Only the current admin can call this function.
195    * @param newAdmin Address to transfer proxy administration to.
196    */
197   function changeAdmin(address newAdmin) external ifAdmin {
198     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
199     emit AdminChanged(_admin(), newAdmin);
200     _setAdmin(newAdmin);
201   }
202 
203   /**
204    * @dev Upgrade the backing implementation of the proxy.
205    * Only the admin can call this function.
206    * @param newImplementation Address of the new implementation.
207    */
208   function upgradeTo(address newImplementation) external ifAdmin {
209     _upgradeTo(newImplementation);
210   }
211 
212   /**
213    * @dev Upgrade the backing implementation of the proxy and call a function
214    * on the new implementation.
215    * This is useful to initialize the proxied contract.
216    * @param newImplementation Address of the new implementation.
217    * @param data Data to send as msg.data in the low level call.
218    * It should include the signature and the parameters of the function to be called, as described in
219    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
220    */
221   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
222     _upgradeTo(newImplementation);
223     (bool success,) = newImplementation.delegatecall(data);
224     require(success);
225   }
226 
227   /**
228    * @return adm The admin slot.
229    */
230   function _admin() internal view returns (address adm) {
231     bytes32 slot = ADMIN_SLOT;
232     assembly {
233       adm := sload(slot)
234     }
235   }
236 
237   /**
238    * @dev Sets the address of the proxy admin.
239    * @param newAdmin Address of the new proxy admin.
240    */
241   function _setAdmin(address newAdmin) internal {
242     bytes32 slot = ADMIN_SLOT;
243 
244     assembly {
245       sstore(slot, newAdmin)
246     }
247   }
248 
249   /**
250    * @dev Only fall back when the sender is not the admin.
251    */
252   function _willFallback() virtual override internal {
253     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
254     //super._willFallback();
255   }
256 }
257 
258 interface IAdminUpgradeabilityProxyView {
259   function admin() external view returns (address);
260   function implementation() external view returns (address);
261 }
262 
263 
264 /**
265  * @title UpgradeabilityProxy
266  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
267  * implementation and init data.
268  */
269 abstract contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
270   /**
271    * @dev Contract constructor.
272    * @param _logic Address of the initial implementation.
273    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
274    * It should include the signature and the parameters of the function to be called, as described in
275    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
276    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
277    */
278   constructor(address _logic, bytes memory _data) public payable {
279     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
280     _setImplementation(_logic);
281     if(_data.length > 0) {
282       (bool success,) = _logic.delegatecall(_data);
283       require(success);
284     }
285   }  
286   
287   //function _willFallback() virtual override internal {
288     //super._willFallback();
289   //}
290 }
291 
292 
293 /**
294  * @title AdminUpgradeabilityProxy
295  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
296  * initializing the implementation, admin, and init data.
297  */
298 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
299   /**
300    * Contract constructor.
301    * @param _logic address of the initial implementation.
302    * @param _admin Address of the proxy administrator.
303    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
304    * It should include the signature and the parameters of the function to be called, as described in
305    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
306    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
307    */
308   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
309     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
310     _setAdmin(_admin);
311   }
312   
313   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
314     super._willFallback();
315   }
316 }
317 
318 
319 /**
320  * @title BaseAdminUpgradeabilityProxy
321  * @dev This contract combines an upgradeability proxy with an authorization
322  * mechanism for administrative tasks.
323  * All external functions in this contract must be guarded by the
324  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
325  * feature proposal that would enable this to be done automatically.
326  */
327 contract __BaseAdminUpgradeabilityProxy__ is BaseUpgradeabilityProxy {
328   /**
329    * @dev Emitted when the administration has been transferred.
330    * @param previousAdmin Address of the previous admin.
331    * @param newAdmin Address of the new admin.
332    */
333   event AdminChanged(address previousAdmin, address newAdmin);
334 
335   /**
336    * @dev Storage slot with the admin of the contract.
337    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
338    * validated in the constructor.
339    */
340 
341   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
342 
343   /**
344    * @dev Modifier to check whether the `msg.sender` is the admin.
345    * If it is, it will run the function. Otherwise, it will delegate the call
346    * to the implementation.
347    */
348   //modifier ifAdmin() {
349   //  if (msg.sender == _admin()) {
350   //    _;
351   //  } else {
352   //    _fallback();
353   //  }
354   //}
355   modifier ifAdmin() {
356     require (msg.sender == _admin(), 'only admin');
357       _;
358   }
359 
360   /**
361    * @return The address of the proxy admin.
362    */
363   //function admin() external ifAdmin returns (address) {
364   //  return _admin();
365   //}
366   function __admin__() external view returns (address) {
367     return _admin();
368   }
369 
370   /**
371    * @return The address of the implementation.
372    */
373   //function implementation() external ifAdmin returns (address) {
374   //  return _implementation();
375   //}
376   function __implementation__() external view returns (address) {
377     return _implementation();
378   }
379 
380   /**
381    * @dev Changes the admin of the proxy.
382    * Only the current admin can call this function.
383    * @param newAdmin Address to transfer proxy administration to.
384    */
385   //function changeAdmin(address newAdmin) external ifAdmin {
386   //  require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
387   //  emit AdminChanged(_admin(), newAdmin);
388   //  _setAdmin(newAdmin);
389   //}
390   function __changeAdmin__(address newAdmin) external ifAdmin {
391     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
392     emit AdminChanged(_admin(), newAdmin);
393     _setAdmin(newAdmin);
394   }
395 
396   /**
397    * @dev Upgrade the backing implementation of the proxy.
398    * Only the admin can call this function.
399    * @param newImplementation Address of the new implementation.
400    */
401   //function upgradeTo(address newImplementation) external ifAdmin {
402   //  _upgradeTo(newImplementation);
403   //}
404   function __upgradeTo__(address newImplementation) external ifAdmin {
405     _upgradeTo(newImplementation);
406   }
407 
408   /**
409    * @dev Upgrade the backing implementation of the proxy and call a function
410    * on the new implementation.
411    * This is useful to initialize the proxied contract.
412    * @param newImplementation Address of the new implementation.
413    * @param data Data to send as msg.data in the low level call.
414    * It should include the signature and the parameters of the function to be called, as described in
415    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
416    */
417   //function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
418   //  _upgradeTo(newImplementation);
419   //  (bool success,) = newImplementation.delegatecall(data);
420   //  require(success);
421   //}
422   function __upgradeToAndCall__(address newImplementation, bytes calldata data) payable external ifAdmin {
423     _upgradeTo(newImplementation);
424     (bool success,) = newImplementation.delegatecall(data);
425     require(success);
426   }
427 
428   /**
429    * @return adm The admin slot.
430    */
431   function _admin() internal view returns (address adm) {
432     bytes32 slot = ADMIN_SLOT;
433     assembly {
434       adm := sload(slot)
435     }
436   }
437 
438   /**
439    * @dev Sets the address of the proxy admin.
440    * @param newAdmin Address of the new proxy admin.
441    */
442   function _setAdmin(address newAdmin) internal {
443     bytes32 slot = ADMIN_SLOT;
444 
445     assembly {
446       sstore(slot, newAdmin)
447     }
448   }
449 
450   /**
451    * @dev Only fall back when the sender is not the admin.
452    */
453   //function _willFallback() virtual override internal {
454   //  require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
455   //  //super._willFallback();
456   //}
457 }
458 
459 
460 /**
461  * @title AdminUpgradeabilityProxy
462  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
463  * initializing the implementation, admin, and init data.
464  */
465 contract __AdminUpgradeabilityProxy__ is __BaseAdminUpgradeabilityProxy__, UpgradeabilityProxy {
466   /**
467    * Contract constructor.
468    * @param _logic address of the initial implementation.
469    * @param _admin Address of the proxy administrator.
470    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
471    * It should include the signature and the parameters of the function to be called, as described in
472    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
473    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
474    */
475   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
476     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
477     _setAdmin(_admin);
478   }
479   
480   //function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
481   //  super._willFallback();
482   //}
483 }
484 
485 
486 /**
487  * @title InitializableUpgradeabilityProxy
488  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
489  * implementation and init data.
490  */
491 abstract contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
492   /**
493    * @dev Contract initializer.
494    * @param _logic Address of the initial implementation.
495    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
496    * It should include the signature and the parameters of the function to be called, as described in
497    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
498    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
499    */
500   function initialize(address _logic, bytes memory _data) public payable {
501     require(_implementation() == address(0));
502     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
503     _setImplementation(_logic);
504     if(_data.length > 0) {
505       (bool success,) = _logic.delegatecall(_data);
506       require(success);
507     }
508   }  
509 }
510 
511 
512 /**
513  * @title InitializableAdminUpgradeabilityProxy
514  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
515  * initializing the implementation, admin, and init data.
516  */
517 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
518   /**
519    * Contract initializer.
520    * @param _logic address of the initial implementation.
521    * @param _admin Address of the proxy administrator.
522    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
523    * It should include the signature and the parameters of the function to be called, as described in
524    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
525    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
526    */
527   function initialize(address _logic, address _admin, bytes memory _data) public payable {
528     require(_implementation() == address(0));
529     InitializableUpgradeabilityProxy.initialize(_logic, _data);
530     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
531     _setAdmin(_admin);
532   }
533   
534   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
535     super._willFallback();
536   }
537 
538 }
539 
540 
541 interface IProxyFactory {
542     function governor() external view returns (address);
543     function __admin__() external view returns (address);
544     function productImplementation() external view returns (address);
545     function productImplementations(bytes32 name) external view returns (address);
546 }
547 
548 
549 /**
550  * @title ProductProxy
551  * @dev This contract implements a proxy that 
552  * it is deploied by ProxyFactory, 
553  * and it's implementation is stored in factory.
554  */
555 contract ProductProxy is Proxy {
556     
557   /**
558    * @dev Storage slot with the address of the ProxyFactory.
559    * This is the keccak-256 hash of "eip1967.proxy.factory" subtracted by 1, and is
560    * validated in the constructor.
561    */
562   bytes32 internal constant FACTORY_SLOT = 0x7a45a402e4cb6e08ebc196f20f66d5d30e67285a2a8aa80503fa409e727a4af1;
563   bytes32 internal constant NAME_SLOT    = 0x4cd9b827ca535ceb0880425d70eff88561ecdf04dc32fcf7ff3b15c587f8a870;      // bytes32(uint256(keccak256('eip1967.proxy.name')) - 1)
564 
565   function _name() virtual internal view returns (bytes32 name_) {
566     bytes32 slot = NAME_SLOT;
567     assembly {  name_ := sload(slot)  }
568   }
569   
570   function _setName(bytes32 name_) internal {
571     bytes32 slot = NAME_SLOT;
572     assembly {  sstore(slot, name_)  }
573   }
574 
575   /**
576    * @dev Sets the factory address of the ProductProxy.
577    * @param newFactory Address of the new factory.
578    */
579   function _setFactory(address newFactory) internal {
580     require(newFactory == address(0) || OpenZeppelinUpgradesAddress.isContract(newFactory), "Cannot set a factory to a non-contract address");
581 
582     bytes32 slot = FACTORY_SLOT;
583 
584     assembly {
585       sstore(slot, newFactory)
586     }
587   }
588 
589   /**
590    * @dev Returns the factory.
591    * @return factory_ Address of the factory.
592    */
593   function _factory() internal view returns (address factory_) {
594     bytes32 slot = FACTORY_SLOT;
595     assembly {
596       factory_ := sload(slot)
597     }
598   }
599   
600   /**
601    * @dev Returns the current implementation.
602    * @return Address of the current implementation
603    */
604   function _implementation() virtual override internal view returns (address) {
605     address factory_ = _factory();
606     bytes32 name_ = _name();
607     if(OpenZeppelinUpgradesAddress.isContract(factory_))
608         if(name_ != 0x0)
609             return IProxyFactory(factory_).productImplementations(name_);
610         else
611             return IProxyFactory(factory_).productImplementation();
612     else
613         return address(0);
614   }
615 
616 }
617 
618 
619 /**
620  * @title InitializableProductProxy
621  * @dev Extends ProductProxy with an initializer for initializing
622  * factory and init data.
623  */
624 contract InitializableProductProxy is ProductProxy {
625   /**
626    * @dev Contract initializer.
627    * @param factory Address of the initial factory.
628    * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
629    * It should include the signature and the parameters of the function to be called, as described in
630    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
631    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
632    */
633   function __InitializableProductProxy_init(address factory, bytes32 name, bytes memory data) external payable {
634     address factory_ = _factory();
635     require(factory_ == address(0) || msg.sender == factory_ || msg.sender == IProxyFactory(factory_).governor() || msg.sender == IProxyFactory(factory_).__admin__());
636     assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
637     assert(NAME_SLOT    == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
638     _setFactory(factory);
639     _setName(name);
640     if(data.length > 0) {
641       (bool success,) = _implementation().delegatecall(data);
642       require(success);
643     }
644   }  
645 }
646 
647 
648 contract __InitializableAdminUpgradeabilityProductProxy__ is __BaseAdminUpgradeabilityProxy__, ProductProxy {
649   function __InitializableAdminUpgradeabilityProductProxy_init__(address admin, address logic, address factory, bytes32 name, bytes memory data) public payable {
650     assert(ADMIN_SLOT           == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
651     assert(IMPLEMENTATION_SLOT  == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
652     assert(FACTORY_SLOT         == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
653     assert(NAME_SLOT            == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
654     address admin_ = _admin();
655     require(admin_ == address(0) || msg.sender == admin_);
656     _setAdmin(admin);
657     _setImplementation(logic);
658     _setFactory(factory);
659     _setName(name);
660     if(data.length > 0) {
661       (bool success,) = _implementation().delegatecall(data);
662       require(success);
663     }
664   }
665   
666   function _implementation() virtual override(BaseUpgradeabilityProxy, ProductProxy) internal view returns (address impl) {
667     impl = BaseUpgradeabilityProxy._implementation();
668     if(impl == address(0))
669         impl = ProductProxy._implementation();
670   }
671 }
672 
673 contract __AdminUpgradeabilityProductProxy__ is __InitializableAdminUpgradeabilityProductProxy__ {
674   constructor(address admin, address logic, address factory, bytes32 name, bytes memory data) public payable {
675     __InitializableAdminUpgradeabilityProductProxy_init__(admin, logic, factory, name, data);
676   }
677 }
678 
679 
680 /**
681  * @title Initializable
682  *
683  * @dev Helper contract to support initializer functions. To use it, replace
684  * the constructor with a function that has the `initializer` modifier.
685  * WARNING: Unlike constructors, initializer functions must be manually
686  * invoked. This applies both to deploying an Initializable contract, as well
687  * as extending an Initializable contract via inheritance.
688  * WARNING: When used with inheritance, manual care must be taken to not invoke
689  * a parent initializer twice, or ensure that all initializers are idempotent,
690  * because this is not dealt with automatically as with constructors.
691  */
692 contract Initializable {
693 
694   /**
695    * @dev Indicates that the contract has been initialized.
696    */
697   bool private initialized;
698 
699   /**
700    * @dev Indicates that the contract is in the process of being initialized.
701    */
702   bool private initializing;
703 
704   /**
705    * @dev Modifier to use in the initializer function of a contract.
706    */
707   modifier initializer() {
708     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
709 
710     bool isTopLevelCall = !initializing;
711     if (isTopLevelCall) {
712       initializing = true;
713       initialized = true;
714     }
715 
716     _;
717 
718     if (isTopLevelCall) {
719       initializing = false;
720     }
721   }
722 
723   /// @dev Returns true if and only if the function is running in the constructor
724   function isConstructor() private view returns (bool) {
725     // extcodesize checks the size of the code stored in an address, and
726     // address returns the current address. Since the code is still not
727     // deployed when running a constructor, any checks on its code size will
728     // yield zero, making it an effective way to detect if a contract is
729     // under construction or not.
730     address self = address(this);
731     uint256 cs;
732     assembly { cs := extcodesize(self) }
733     return cs == 0;
734   }
735 
736   // Reserved storage space to allow for layout changes in the future.
737   uint256[50] private ______gap;
738 }
739 
740 
741 /*
742  * @dev Provides information about the current execution context, including the
743  * sender of the transaction and its data. While these are generally available
744  * via msg.sender and msg.data, they should not be accessed in such a direct
745  * manner, since when dealing with GSN meta-transactions the account sending and
746  * paying for execution may not be the actual sender (as far as an application
747  * is concerned).
748  *
749  * This contract is only required for intermediate, library-like contracts.
750  */
751 contract ContextUpgradeSafe is Initializable {
752     // Empty internal constructor, to prevent people from mistakenly deploying
753     // an instance of this contract, which should be used via inheritance.
754 
755     function __Context_init() internal initializer {
756         __Context_init_unchained();
757     }
758 
759     function __Context_init_unchained() internal initializer {
760 
761 
762     }
763 
764 
765     function _msgSender() internal view virtual returns (address payable) {
766         return msg.sender;
767     }
768 
769     function _msgData() internal view virtual returns (bytes memory) {
770         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
771         return msg.data;
772     }
773 
774     uint256[50] private __gap;
775 }
776 
777 /**
778  * @dev Contract module that helps prevent reentrant calls to a function.
779  *
780  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
781  * available, which can be applied to functions to make sure there are no nested
782  * (reentrant) calls to them.
783  *
784  * Note that because there is a single `nonReentrant` guard, functions marked as
785  * `nonReentrant` may not call one another. This can be worked around by making
786  * those functions `private`, and then adding `external` `nonReentrant` entry
787  * points to them.
788  *
789  * TIP: If you would like to learn more about reentrancy and alternative ways
790  * to protect against it, check out our blog post
791  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
792  */
793 contract ReentrancyGuardUpgradeSafe is Initializable {
794     bool private _notEntered;
795 
796 
797     function __ReentrancyGuard_init() internal initializer {
798         __ReentrancyGuard_init_unchained();
799     }
800 
801     function __ReentrancyGuard_init_unchained() internal initializer {
802 
803 
804         // Storing an initial non-zero value makes deployment a bit more
805         // expensive, but in exchange the refund on every call to nonReentrant
806         // will be lower in amount. Since refunds are capped to a percetange of
807         // the total transaction's gas, it is best to keep them low in cases
808         // like this one, to increase the likelihood of the full refund coming
809         // into effect.
810         _notEntered = true;
811 
812     }
813 
814 
815     /**
816      * @dev Prevents a contract from calling itself, directly or indirectly.
817      * Calling a `nonReentrant` function from another `nonReentrant`
818      * function is not supported. It is possible to prevent this from happening
819      * by making the `nonReentrant` function external, and make it call a
820      * `private` function that does the actual work.
821      */
822     modifier nonReentrant() {
823         // On the first call to nonReentrant, _notEntered will be true
824         require(_notEntered, "ReentrancyGuard: reentrant call");
825 
826         // Any calls to nonReentrant after this point will fail
827         _notEntered = false;
828 
829         _;
830 
831         // By storing the original value once again, a refund is triggered (see
832         // https://eips.ethereum.org/EIPS/eip-2200)
833         _notEntered = true;
834     }
835 
836     uint256[49] private __gap;
837 }
838 
839 /**
840  * @dev Standard math utilities missing in the Solidity language.
841  */
842 library Math {
843     /**
844      * @dev Returns the largest of two numbers.
845      */
846     function max(uint256 a, uint256 b) internal pure returns (uint256) {
847         return a >= b ? a : b;
848     }
849 
850     /**
851      * @dev Returns the smallest of two numbers.
852      */
853     function min(uint256 a, uint256 b) internal pure returns (uint256) {
854         return a < b ? a : b;
855     }
856 
857     /**
858      * @dev Returns the average of two numbers. The result is rounded towards
859      * zero.
860      */
861     function average(uint256 a, uint256 b) internal pure returns (uint256) {
862         // (a + b) / 2 can overflow, so we distribute
863         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
864     }
865 
866     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
867     function sqrt(uint256 x) internal pure returns (uint256) {
868         if (x == 0) return 0;
869         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
870         // however that code costs significantly more gas
871         uint256 xx = x;
872         uint256 r = 1;
873         if (xx >= 0x100000000000000000000000000000000) {
874             xx >>= 128;
875             r <<= 64;
876         }
877         if (xx >= 0x10000000000000000) {
878             xx >>= 64;
879             r <<= 32;
880         }
881         if (xx >= 0x100000000) {
882             xx >>= 32;
883             r <<= 16;
884         }
885         if (xx >= 0x10000) {
886             xx >>= 16;
887             r <<= 8;
888         }
889         if (xx >= 0x100) {
890             xx >>= 8;
891             r <<= 4;
892         }
893         if (xx >= 0x10) {
894             xx >>= 4;
895             r <<= 2;
896         }
897         if (xx >= 0x8) {
898             r <<= 1;
899         }
900         r = (r + x / r) >> 1;
901         r = (r + x / r) >> 1;
902         r = (r + x / r) >> 1;
903         r = (r + x / r) >> 1;
904         r = (r + x / r) >> 1;
905         r = (r + x / r) >> 1;
906         r = (r + x / r) >> 1; // Seven iterations should be enough
907         uint256 r1 = x / r;
908         return (r < r1 ? r : r1);
909     }
910 }
911 
912 /**
913  * @dev Wrappers over Solidity's arithmetic operations with added overflow
914  * checks.
915  *
916  * Arithmetic operations in Solidity wrap on overflow. This can easily result
917  * in bugs, because programmers usually assume that an overflow raises an
918  * error, which is the standard behavior in high level programming languages.
919  * `SafeMath` restores this intuition by reverting the transaction when an
920  * operation overflows.
921  *
922  * Using this library instead of the unchecked operations eliminates an entire
923  * class of bugs, so it's recommended to use it always.
924  */
925 library SafeMath {
926     /**
927      * @dev Returns the addition of two unsigned integers, reverting on
928      * overflow.
929      *
930      * Counterpart to Solidity's `+` operator.
931      *
932      * Requirements:
933      * - Addition cannot overflow.
934      */
935     function add(uint256 a, uint256 b) internal pure returns (uint256) {
936         uint256 c = a + b;
937         require(c >= a, "SafeMath: addition overflow");
938 
939         return c;
940     }
941 
942     /**
943      * @dev Returns the subtraction of two unsigned integers, reverting on
944      * overflow (when the result is negative).
945      *
946      * Counterpart to Solidity's `-` operator.
947      *
948      * Requirements:
949      * - Subtraction cannot overflow.
950      */
951     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
952         return sub(a, b, "SafeMath: subtraction overflow");
953     }
954 
955     /**
956      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
957      * overflow (when the result is negative).
958      *
959      * Counterpart to Solidity's `-` operator.
960      *
961      * Requirements:
962      * - Subtraction cannot overflow.
963      */
964     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
965         require(b <= a, errorMessage);
966         uint256 c = a - b;
967 
968         return c;
969     }
970 
971     function sub0(uint256 a, uint256 b) internal pure returns (uint256) {
972         return a > b ? a - b : 0;
973     }
974 
975     /**
976      * @dev Returns the multiplication of two unsigned integers, reverting on
977      * overflow.
978      *
979      * Counterpart to Solidity's `*` operator.
980      *
981      * Requirements:
982      * - Multiplication cannot overflow.
983      */
984     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
985         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
986         // benefit is lost if 'b' is also tested.
987         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
988         if (a == 0) {
989             return 0;
990         }
991 
992         uint256 c = a * b;
993         require(c / a == b, "SafeMath: multiplication overflow");
994 
995         return c;
996     }
997 
998     /**
999      * @dev Returns the integer division of two unsigned integers. Reverts on
1000      * division by zero. The result is rounded towards zero.
1001      *
1002      * Counterpart to Solidity's `/` operator. Note: this function uses a
1003      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1004      * uses an invalid opcode to revert (consuming all remaining gas).
1005      *
1006      * Requirements:
1007      * - The divisor cannot be zero.
1008      */
1009     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1010         return div(a, b, "SafeMath: division by zero");
1011     }
1012 
1013     /**
1014      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1015      * division by zero. The result is rounded towards zero.
1016      *
1017      * Counterpart to Solidity's `/` operator. Note: this function uses a
1018      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1019      * uses an invalid opcode to revert (consuming all remaining gas).
1020      *
1021      * Requirements:
1022      * - The divisor cannot be zero.
1023      */
1024     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1025         // Solidity only automatically asserts when dividing by 0
1026         require(b > 0, errorMessage);
1027         uint256 c = a / b;
1028         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1029 
1030         return c;
1031     }
1032 
1033     /**
1034      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1035      * Reverts when dividing by zero.
1036      *
1037      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1038      * opcode (which leaves remaining gas untouched) while Solidity uses an
1039      * invalid opcode to revert (consuming all remaining gas).
1040      *
1041      * Requirements:
1042      * - The divisor cannot be zero.
1043      */
1044     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1045         return mod(a, b, "SafeMath: modulo by zero");
1046     }
1047 
1048     /**
1049      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1050      * Reverts with custom message when dividing by zero.
1051      *
1052      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1053      * opcode (which leaves remaining gas untouched) while Solidity uses an
1054      * invalid opcode to revert (consuming all remaining gas).
1055      *
1056      * Requirements:
1057      * - The divisor cannot be zero.
1058      */
1059     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1060         require(b != 0, errorMessage);
1061         return a % b;
1062     }
1063 }
1064 
1065 /**
1066  * Utility library of inline functions on addresses
1067  *
1068  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
1069  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
1070  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
1071  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
1072  */
1073 library OpenZeppelinUpgradesAddress {
1074     /**
1075      * Returns whether the target address is a contract
1076      * @dev This function will return false if invoked during the constructor of a contract,
1077      * as the code is not actually created until after the constructor finishes.
1078      * @param account address of the account to check
1079      * @return whether the target address is a contract
1080      */
1081     function isContract(address account) internal view returns (bool) {
1082         uint256 size;
1083         // XXX Currently there is no better way to check if there is a contract in an address
1084         // than to check the size of the code at that address.
1085         // See https://ethereum.stackexchange.com/a/14016/36603
1086         // for more details about how this works.
1087         // TODO Check this again before the Serenity release, because all addresses will be
1088         // contracts then.
1089         // solhint-disable-next-line no-inline-assembly
1090         assembly { size := extcodesize(account) }
1091         return size > 0;
1092     }
1093 }
1094 
1095 /**
1096  * @dev Collection of functions related to the address type
1097  */
1098 library Address {
1099     /**
1100      * @dev Returns true if `account` is a contract.
1101      *
1102      * [IMPORTANT]
1103      * ====
1104      * It is unsafe to assume that an address for which this function returns
1105      * false is an externally-owned account (EOA) and not a contract.
1106      *
1107      * Among others, `isContract` will return false for the following
1108      * types of addresses:
1109      *
1110      *  - an externally-owned account
1111      *  - a contract in construction
1112      *  - an address where a contract will be created
1113      *  - an address where a contract lived, but was destroyed
1114      * ====
1115      */
1116     function isContract(address account) internal view returns (bool) {
1117         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1118         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1119         // for accounts without code, i.e. `keccak256('')`
1120         bytes32 codehash;
1121         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1122         // solhint-disable-next-line no-inline-assembly
1123         assembly { codehash := extcodehash(account) }
1124         return (codehash != accountHash && codehash != 0x0);
1125     }
1126 
1127     /**
1128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1129      * `recipient`, forwarding all available gas and reverting on errors.
1130      *
1131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1133      * imposed by `transfer`, making them unable to receive funds via
1134      * `transfer`. {sendValue} removes this limitation.
1135      *
1136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1137      *
1138      * IMPORTANT: because control is transferred to `recipient`, care must be
1139      * taken to not create reentrancy vulnerabilities. Consider using
1140      * {ReentrancyGuard} or the
1141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1142      */
1143     function sendValue(address payable recipient, uint256 amount) internal {
1144         require(address(this).balance >= amount, "Address: insufficient balance");
1145 
1146         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1147         (bool success, ) = recipient.call{ value: amount }("");
1148         require(success, "Address: unable to send value, recipient may have reverted");
1149     }
1150 }
1151 
1152 /**
1153  * @dev Interface of the ERC20 standard as defined in the EIP.
1154  */
1155 interface IERC20 {
1156     /**
1157      * @dev Returns the amount of tokens in existence.
1158      */
1159     function totalSupply() external view returns (uint256);
1160 
1161     /**
1162      * @dev Returns the amount of tokens owned by `account`.
1163      */
1164     function balanceOf(address account) external view returns (uint256);
1165 
1166     /**
1167      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1168      *
1169      * Returns a boolean value indicating whether the operation succeeded.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function transfer(address recipient, uint256 amount) external returns (bool);
1174 
1175     /**
1176      * @dev Returns the remaining number of tokens that `spender` will be
1177      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1178      * zero by default.
1179      *
1180      * This value changes when {approve} or {transferFrom} are called.
1181      */
1182     function allowance(address owner, address spender) external view returns (uint256);
1183 
1184     /**
1185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1186      *
1187      * Returns a boolean value indicating whether the operation succeeded.
1188      *
1189      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1190      * that someone may use both the old and the new allowance by unfortunate
1191      * transaction ordering. One possible solution to mitigate this race
1192      * condition is to first reduce the spender's allowance to 0 and set the
1193      * desired value afterwards:
1194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1195      *
1196      * Emits an {Approval} event.
1197      */
1198     function approve(address spender, uint256 amount) external returns (bool);
1199 
1200     /**
1201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1202      * allowance mechanism. `amount` is then deducted from the caller's
1203      * allowance.
1204      *
1205      * Returns a boolean value indicating whether the operation succeeded.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1210 
1211     /**
1212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1213      * another (`to`).
1214      *
1215      * Note that `value` may be zero.
1216      */
1217     event Transfer(address indexed from, address indexed to, uint256 value);
1218 
1219     /**
1220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1221      * a call to {approve}. `value` is the new allowance.
1222      */
1223     event Approval(address indexed owner, address indexed spender, uint256 value);
1224 }
1225 
1226 /**
1227  * @dev Implementation of the {IERC20} interface.
1228  *
1229  * This implementation is agnostic to the way tokens are created. This means
1230  * that a supply mechanism has to be added in a derived contract using {_mint}.
1231  * For a generic mechanism see {ERC20MinterPauser}.
1232  *
1233  * TIP: For a detailed writeup see our guide
1234  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1235  * to implement supply mechanisms].
1236  *
1237  * We have followed general OpenZeppelin guidelines: functions revert instead
1238  * of returning `false` on failure. This behavior is nonetheless conventional
1239  * and does not conflict with the expectations of ERC20 applications.
1240  *
1241  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1242  * This allows applications to reconstruct the allowance for all accounts just
1243  * by listening to said events. Other implementations of the EIP may not emit
1244  * these events, as it isn't required by the specification.
1245  *
1246  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1247  * functions have been added to mitigate the well-known issues around setting
1248  * allowances. See {IERC20-approve}.
1249  */
1250 contract ERC20UpgradeSafe is ContextUpgradeSafe, IERC20 {
1251     using SafeMath for uint256;
1252 
1253     mapping (address => uint256) internal _balances;
1254 
1255     mapping (address => mapping (address => uint256)) internal _allowances;
1256 
1257     uint256 internal _totalSupply;
1258 
1259     string internal _name;
1260     string internal _symbol;
1261     uint8 internal _decimals;
1262 
1263     /**
1264      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1265      * a default value of 18.
1266      *
1267      * To select a different value for {decimals}, use {_setupDecimals}.
1268      *
1269      * All three of these values are immutable: they can only be set once during
1270      * construction.
1271      */
1272 
1273     function __ERC20_init(string memory name, string memory symbol) internal initializer {
1274         __Context_init_unchained();
1275         __ERC20_init_unchained(name, symbol);
1276     }
1277 
1278     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
1279 
1280 
1281         _name = name;
1282         _symbol = symbol;
1283         _decimals = 18;
1284 
1285     }
1286 
1287 
1288     /**
1289      * @dev Returns the name of the token.
1290      */
1291     function name() public view returns (string memory) {
1292         return _name;
1293     }
1294 
1295     /**
1296      * @dev Returns the symbol of the token, usually a shorter version of the
1297      * name.
1298      */
1299     function symbol() public view returns (string memory) {
1300         return _symbol;
1301     }
1302 
1303     /**
1304      * @dev Returns the number of decimals used to get its user representation.
1305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1306      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1307      *
1308      * Tokens usually opt for a value of 18, imitating the relationship between
1309      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1310      * called.
1311      *
1312      * NOTE: This information is only used for _display_ purposes: it in
1313      * no way affects any of the arithmetic of the contract, including
1314      * {IERC20-balanceOf} and {IERC20-transfer}.
1315      */
1316     function decimals() public view returns (uint8) {
1317         return _decimals;
1318     }
1319 
1320     /**
1321      * @dev See {IERC20-totalSupply}.
1322      */
1323     function totalSupply() public view override returns (uint256) {
1324         return _totalSupply;
1325     }
1326 
1327     /**
1328      * @dev See {IERC20-balanceOf}.
1329      */
1330     function balanceOf(address account) public view override returns (uint256) {
1331         return _balances[account];
1332     }
1333 
1334     /**
1335      * @dev See {IERC20-transfer}.
1336      *
1337      * Requirements:
1338      *
1339      * - `recipient` cannot be the zero address.
1340      * - the caller must have a balance of at least `amount`.
1341      */
1342     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1343         _transfer(_msgSender(), recipient, amount);
1344         return true;
1345     }
1346 
1347     /**
1348      * @dev See {IERC20-allowance}.
1349      */
1350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1351         return _allowances[owner][spender];
1352     }
1353 
1354     /**
1355      * @dev See {IERC20-approve}.
1356      *
1357      * Requirements:
1358      *
1359      * - `spender` cannot be the zero address.
1360      */
1361     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1362         _approve(_msgSender(), spender, amount);
1363         return true;
1364     }
1365 
1366     /**
1367      * @dev See {IERC20-transferFrom}.
1368      *
1369      * Emits an {Approval} event indicating the updated allowance. This is not
1370      * required by the EIP. See the note at the beginning of {ERC20};
1371      *
1372      * Requirements:
1373      * - `sender` and `recipient` cannot be the zero address.
1374      * - `sender` must have a balance of at least `amount`.
1375      * - the caller must have allowance for ``sender``'s tokens of at least
1376      * `amount`.
1377      */
1378     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1379         _transfer(sender, recipient, amount);
1380         if(sender != _msgSender() && _allowances[sender][_msgSender()] != uint(-1))
1381             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1382         return true;
1383     }
1384 
1385     /**
1386      * @dev Atomically increases the allowance granted to `spender` by the caller.
1387      *
1388      * This is an alternative to {approve} that can be used as a mitigation for
1389      * problems described in {IERC20-approve}.
1390      *
1391      * Emits an {Approval} event indicating the updated allowance.
1392      *
1393      * Requirements:
1394      *
1395      * - `spender` cannot be the zero address.
1396      */
1397     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1398         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1399         return true;
1400     }
1401 
1402     /**
1403      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1404      *
1405      * This is an alternative to {approve} that can be used as a mitigation for
1406      * problems described in {IERC20-approve}.
1407      *
1408      * Emits an {Approval} event indicating the updated allowance.
1409      *
1410      * Requirements:
1411      *
1412      * - `spender` cannot be the zero address.
1413      * - `spender` must have allowance for the caller of at least
1414      * `subtractedValue`.
1415      */
1416     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1418         return true;
1419     }
1420 
1421     /**
1422      * @dev Moves tokens `amount` from `sender` to `recipient`.
1423      *
1424      * This is internal function is equivalent to {transfer}, and can be used to
1425      * e.g. implement automatic token fees, slashing mechanisms, etc.
1426      *
1427      * Emits a {Transfer} event.
1428      *
1429      * Requirements:
1430      *
1431      * - `sender` cannot be the zero address.
1432      * - `recipient` cannot be the zero address.
1433      * - `sender` must have a balance of at least `amount`.
1434      */
1435     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1436         require(sender != address(0), "ERC20: transfer from the zero address");
1437         require(recipient != address(0), "ERC20: transfer to the zero address");
1438 
1439         _beforeTokenTransfer(sender, recipient, amount);
1440 
1441         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1442         _balances[recipient] = _balances[recipient].add(amount);
1443         emit Transfer(sender, recipient, amount);
1444     }
1445 
1446     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1447      * the total supply.
1448      *
1449      * Emits a {Transfer} event with `from` set to the zero address.
1450      *
1451      * Requirements
1452      *
1453      * - `to` cannot be the zero address.
1454      */
1455     function _mint(address account, uint256 amount) internal virtual {
1456         require(account != address(0), "ERC20: mint to the zero address");
1457 
1458         _beforeTokenTransfer(address(0), account, amount);
1459 
1460         _totalSupply = _totalSupply.add(amount);
1461         _balances[account] = _balances[account].add(amount);
1462         emit Transfer(address(0), account, amount);
1463     }
1464 
1465     /**
1466      * @dev Destroys `amount` tokens from `account`, reducing the
1467      * total supply.
1468      *
1469      * Emits a {Transfer} event with `to` set to the zero address.
1470      *
1471      * Requirements
1472      *
1473      * - `account` cannot be the zero address.
1474      * - `account` must have at least `amount` tokens.
1475      */
1476     function _burn(address account, uint256 amount) internal virtual {
1477         require(account != address(0), "ERC20: burn from the zero address");
1478 
1479         _beforeTokenTransfer(account, address(0), amount);
1480 
1481         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1482         _totalSupply = _totalSupply.sub(amount);
1483         emit Transfer(account, address(0), amount);
1484     }
1485 
1486     /**
1487      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1488      *
1489      * This is internal function is equivalent to `approve`, and can be used to
1490      * e.g. set automatic allowances for certain subsystems, etc.
1491      *
1492      * Emits an {Approval} event.
1493      *
1494      * Requirements:
1495      *
1496      * - `owner` cannot be the zero address.
1497      * - `spender` cannot be the zero address.
1498      */
1499     function _approve(address owner, address spender, uint256 amount) internal virtual {
1500         require(owner != address(0), "ERC20: approve from the zero address");
1501         require(spender != address(0), "ERC20: approve to the zero address");
1502 
1503         _allowances[owner][spender] = amount;
1504         emit Approval(owner, spender, amount);
1505     }
1506 
1507     /**
1508      * @dev Sets {decimals} to a value other than the default one of 18.
1509      *
1510      * WARNING: This function should only be called from the constructor. Most
1511      * applications that interact with token contracts will not expect
1512      * {decimals} to ever change, and may work incorrectly if it does.
1513      */
1514     function _setupDecimals(uint8 decimals_) internal {
1515         _decimals = decimals_;
1516     }
1517 
1518     /**
1519      * @dev Hook that is called before any transfer of tokens. This includes
1520      * minting and burning.
1521      *
1522      * Calling conditions:
1523      *
1524      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1525      * will be to transferred to `to`.
1526      * - when `from` is zero, `amount` tokens will be minted for `to`.
1527      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1528      * - `from` and `to` are never both zero.
1529      *
1530      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1531      */
1532     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1533 
1534     uint256[44] private __gap;
1535 }
1536 
1537 
1538 /**
1539  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1540  */
1541 contract ERC20CappedUpgradeSafe is ERC20UpgradeSafe {
1542     uint256 internal _cap;
1543 
1544     /**
1545      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1546      * set once during construction.
1547      */
1548 
1549     function __ERC20Capped_init(uint256 cap) internal initializer {
1550         __Context_init_unchained();
1551         __ERC20Capped_init_unchained(cap);
1552     }
1553 
1554     function __ERC20Capped_init_unchained(uint256 cap) internal initializer {
1555         require(cap > 0, "ERC20Capped: cap is 0");
1556         _cap = cap;
1557     }
1558 
1559 
1560     /**
1561      * @dev Returns the cap on the token's total supply.
1562      */
1563     function cap() virtual public view returns (uint256) {
1564         return _cap;
1565     }
1566 
1567     /**
1568      * @dev See {ERC20-_beforeTokenTransfer}.
1569      *
1570      * Requirements:
1571      *
1572      * - minted tokens must not cause the total supply to go over the cap.
1573      */
1574     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1575         super._beforeTokenTransfer(from, to, amount);
1576 
1577         if (from == address(0)) { // When minting tokens
1578             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1579         }
1580     }
1581 
1582     uint256[49] private __gap;
1583 }
1584 
1585 
1586 abstract contract Permit {
1587     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1588     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1589     function DOMAIN_SEPARATOR() virtual public view returns (bytes32);
1590 
1591     mapping (address => uint) public nonces;
1592 
1593     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
1594         require(deadline >= block.timestamp, 'permit EXPIRED');
1595         bytes32 digest = keccak256(
1596             abi.encodePacked(
1597                 '\x19\x01',
1598                 DOMAIN_SEPARATOR(),
1599                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
1600             )
1601         );
1602         address recoveredAddress = ecrecover(digest, v, r, s);
1603         require(recoveredAddress != address(0) && recoveredAddress == owner, 'permit INVALID_SIGNATURE');
1604         _approve(owner, spender, value);
1605     }
1606 
1607     function _approve(address owner, address spender, uint256 amount) internal virtual;    
1608 
1609     uint256[50] private __gap;
1610 }
1611 
1612 contract PermitERC20UpgradeSafe is Permit, ERC20UpgradeSafe {
1613     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1614     
1615     function DOMAIN_SEPARATOR() virtual override public view returns (bytes32) {
1616         return keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
1617     }
1618     
1619     function _chainId() internal pure returns (uint id) {
1620         assembly { id := chainid() }
1621     }
1622     
1623     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
1624         return ERC20UpgradeSafe._approve(owner, spender, amount);
1625     }
1626 }
1627 
1628 
1629 /**
1630  * @title SafeERC20
1631  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1632  * contract returns false). Tokens that return no value (and instead revert or
1633  * throw on failure) are also supported, non-reverting calls are assumed to be
1634  * successful.
1635  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1636  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1637  */
1638 library SafeERC20 {
1639     using SafeMath for uint256;
1640     using Address for address;
1641 
1642     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1643         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1644     }
1645 
1646     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1647         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1648     }
1649 
1650     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1651         // safeApprove should only be called when setting an initial allowance,
1652         // or when resetting it to zero. To increase and decrease it, use
1653         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1654         // solhint-disable-next-line max-line-length
1655         require((value == 0) || (token.allowance(address(this), spender) == 0),
1656             "SafeERC20: approve from non-zero to non-zero allowance"
1657         );
1658         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1659     }
1660 
1661     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1662         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1663         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1664     }
1665 
1666     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1667         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1668         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1669     }
1670 
1671     /**
1672      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1673      * on the return value: the return value is optional (but if data is returned, it must not be false).
1674      * @param token The token targeted by the call.
1675      * @param data The call data (encoded using abi.encode or one of its variants).
1676      */
1677     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1678         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1679         // we're implementing it ourselves.
1680 
1681         // A Solidity high level call has three parts:
1682         //  1. The target address is checked to verify it contains contract code
1683         //  2. The call itself is made, and success asserted
1684         //  3. The return value is decoded, which in turn checks the size of the returned data.
1685         // solhint-disable-next-line max-line-length
1686         require(address(token).isContract(), "SafeERC20: call to non-contract");
1687 
1688         // solhint-disable-next-line avoid-low-level-calls
1689         (bool success, bytes memory returndata) = address(token).call(data);
1690         require(success, "SafeERC20: low-level call failed");
1691 
1692         if (returndata.length > 0) { // Return data is optional
1693             // solhint-disable-next-line max-line-length
1694             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1695         }
1696     }
1697 }
1698 
1699 
1700 contract Governable is Initializable {
1701     // bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1)
1702     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
1703 
1704     address public governor;
1705 
1706     event GovernorshipTransferred(address indexed previousGovernor, address indexed newGovernor);
1707 
1708     /**
1709      * @dev Contract initializer.
1710      * called once by the factory at time of deployment
1711      */
1712     function __Governable_init_unchained(address governor_) virtual public initializer {
1713         governor = governor_;
1714         emit GovernorshipTransferred(address(0), governor);
1715     }
1716 
1717     function _admin() internal view returns (address adm) {
1718         bytes32 slot = ADMIN_SLOT;
1719         assembly {
1720             adm := sload(slot)
1721         }
1722     }
1723     
1724     modifier governance() {
1725         require(msg.sender == governor || msg.sender == _admin());
1726         _;
1727     }
1728 
1729     /**
1730      * @dev Allows the current governor to relinquish control of the contract.
1731      * @notice Renouncing to governorship will leave the contract without an governor.
1732      * It will not be possible to call the functions with the `governance`
1733      * modifier anymore.
1734      */
1735     function renounceGovernorship() public governance {
1736         emit GovernorshipTransferred(governor, address(0));
1737         governor = address(0);
1738     }
1739 
1740     /**
1741      * @dev Allows the current governor to transfer control of the contract to a newGovernor.
1742      * @param newGovernor The address to transfer governorship to.
1743      */
1744     function transferGovernorship(address newGovernor) public governance {
1745         _transferGovernorship(newGovernor);
1746     }
1747 
1748     /**
1749      * @dev Transfers control of the contract to a newGovernor.
1750      * @param newGovernor The address to transfer governorship to.
1751      */
1752     function _transferGovernorship(address newGovernor) internal {
1753         require(newGovernor != address(0));
1754         emit GovernorshipTransferred(governor, newGovernor);
1755         governor = newGovernor;
1756     }
1757 }
1758 
1759 
1760 contract Configurable is Governable {
1761     mapping (bytes32 => uint) internal config;
1762     
1763     function getConfig(bytes32 key) public view returns (uint) {
1764         return config[key];
1765     }
1766     function getConfigI(bytes32 key, uint index) public view returns (uint) {
1767         return config[bytes32(uint(key) ^ index)];
1768     }
1769     function getConfigA(bytes32 key, address addr) public view returns (uint) {
1770         return config[bytes32(uint(key) ^ uint(addr))];
1771     }
1772 
1773     function _setConfig(bytes32 key, uint value) internal {
1774         if(config[key] != value)
1775             config[key] = value;
1776     }
1777     function _setConfig(bytes32 key, uint index, uint value) internal {
1778         _setConfig(bytes32(uint(key) ^ index), value);
1779     }
1780     function _setConfig(bytes32 key, address addr, uint value) internal {
1781         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1782     }
1783 
1784     function setConfig(bytes32 key, uint value) external governance {
1785         _setConfig(key, value);
1786     }
1787     function setConfigI(bytes32 key, uint index, uint value) external governance {
1788         _setConfig(bytes32(uint(key) ^ index), value);
1789     }
1790     function setConfigA(bytes32 key, address addr, uint value) public governance {
1791         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1792     }
1793 }