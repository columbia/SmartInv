1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 pragma experimental ABIEncoderV2;
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
389   bytes32 internal constant NAME_SLOT    = 0x4cd9b827ca535ceb0880425d70eff88561ecdf04dc32fcf7ff3b15c587f8a870;      // bytes32(uint256(keccak256('eip1967.proxy.name')) - 1)
390 
391   function _name() virtual internal view returns (bytes32 name_) {
392     bytes32 slot = NAME_SLOT;
393     assembly {  name_ := sload(slot)  }
394   }
395   
396   function _setName(bytes32 name_) internal {
397     bytes32 slot = NAME_SLOT;
398     assembly {  sstore(slot, name_)  }
399   }
400 
401   /**
402    * @dev Sets the factory address of the ProductProxy.
403    * @param newFactory Address of the new factory.
404    */
405   function _setFactory(address newFactory) internal {
406     require(OpenZeppelinUpgradesAddress.isContract(newFactory), "Cannot set a factory to a non-contract address");
407 
408     bytes32 slot = FACTORY_SLOT;
409 
410     assembly {
411       sstore(slot, newFactory)
412     }
413   }
414 
415   /**
416    * @dev Returns the factory.
417    * @return factory_ Address of the factory.
418    */
419   function _factory() internal view returns (address factory_) {
420     bytes32 slot = FACTORY_SLOT;
421     assembly {
422       factory_ := sload(slot)
423     }
424   }
425   
426   /**
427    * @dev Returns the current implementation.
428    * @return Address of the current implementation
429    */
430   function _implementation() virtual override internal view returns (address) {
431     address factory_ = _factory();
432     if(OpenZeppelinUpgradesAddress.isContract(factory_))
433         return IProxyFactory(factory_).productImplementations(_name());
434     else
435         return address(0);
436   }
437 
438 }
439 
440 
441 /**
442  * @title InitializableProductProxy
443  * @dev Extends ProductProxy with an initializer for initializing
444  * factory and init data.
445  */
446 contract InitializableProductProxy is ProductProxy {
447   /**
448    * @dev Contract initializer.
449    * @param factory_ Address of the initial factory.
450    * @param data_ Data to send as msg.data to the implementation to initialize the proxied contract.
451    * It should include the signature and the parameters of the function to be called, as described in
452    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
453    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
454    */
455   function __InitializableProductProxy_init(address factory_, bytes32 name_, bytes memory data_) public payable {
456     require(_factory() == address(0));
457     assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
458     assert(NAME_SLOT    == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
459     _setFactory(factory_);
460     _setName(name_);
461     if(data_.length > 0) {
462       (bool success,) = _implementation().delegatecall(data_);
463       require(success);
464     }
465   }  
466 }
467 
468 
469 /**
470  * @title Initializable
471  *
472  * @dev Helper contract to support initializer functions. To use it, replace
473  * the constructor with a function that has the `initializer` modifier.
474  * WARNING: Unlike constructors, initializer functions must be manually
475  * invoked. This applies both to deploying an Initializable contract, as well
476  * as extending an Initializable contract via inheritance.
477  * WARNING: When used with inheritance, manual care must be taken to not invoke
478  * a parent initializer twice, or ensure that all initializers are idempotent,
479  * because this is not dealt with automatically as with constructors.
480  */
481 contract Initializable {
482 
483   /**
484    * @dev Indicates that the contract has been initialized.
485    */
486   bool private initialized;
487 
488   /**
489    * @dev Indicates that the contract is in the process of being initialized.
490    */
491   bool private initializing;
492 
493   /**
494    * @dev Modifier to use in the initializer function of a contract.
495    */
496   modifier initializer() {
497     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
498 
499     bool isTopLevelCall = !initializing;
500     if (isTopLevelCall) {
501       initializing = true;
502       initialized = true;
503     }
504 
505     _;
506 
507     if (isTopLevelCall) {
508       initializing = false;
509     }
510   }
511 
512   /// @dev Returns true if and only if the function is running in the constructor
513   function isConstructor() private view returns (bool) {
514     // extcodesize checks the size of the code stored in an address, and
515     // address returns the current address. Since the code is still not
516     // deployed when running a constructor, any checks on its code size will
517     // yield zero, making it an effective way to detect if a contract is
518     // under construction or not.
519     address self = address(this);
520     uint256 cs;
521     assembly { cs := extcodesize(self) }
522     return cs == 0;
523   }
524 
525   // Reserved storage space to allow for layout changes in the future.
526   uint256[50] private ______gap;
527 }
528 
529 
530 /*
531  * @dev Provides information about the current execution context, including the
532  * sender of the transaction and its data. While these are generally available
533  * via msg.sender and msg.data, they should not be accessed in such a direct
534  * manner, since when dealing with GSN meta-transactions the account sending and
535  * paying for execution may not be the actual sender (as far as an application
536  * is concerned).
537  *
538  * This contract is only required for intermediate, library-like contracts.
539  */
540 contract ContextUpgradeSafe is Initializable {
541     // Empty internal constructor, to prevent people from mistakenly deploying
542     // an instance of this contract, which should be used via inheritance.
543 
544     function __Context_init() internal initializer {
545         __Context_init_unchained();
546     }
547 
548     function __Context_init_unchained() internal initializer {
549 
550 
551     }
552 
553 
554     function _msgSender() internal view virtual returns (address payable) {
555         return msg.sender;
556     }
557 
558     function _msgData() internal view virtual returns (bytes memory) {
559         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
560         return msg.data;
561     }
562 
563     uint256[50] private __gap;
564 }
565 
566 /**
567  * @dev Contract module that helps prevent reentrant calls to a function.
568  *
569  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
570  * available, which can be applied to functions to make sure there are no nested
571  * (reentrant) calls to them.
572  *
573  * Note that because there is a single `nonReentrant` guard, functions marked as
574  * `nonReentrant` may not call one another. This can be worked around by making
575  * those functions `private`, and then adding `external` `nonReentrant` entry
576  * points to them.
577  *
578  * TIP: If you would like to learn more about reentrancy and alternative ways
579  * to protect against it, check out our blog post
580  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
581  */
582 contract ReentrancyGuardUpgradeSafe is Initializable {
583     bool private _notEntered;
584 
585 
586     function __ReentrancyGuard_init() internal initializer {
587         __ReentrancyGuard_init_unchained();
588     }
589 
590     function __ReentrancyGuard_init_unchained() internal initializer {
591 
592 
593         // Storing an initial non-zero value makes deployment a bit more
594         // expensive, but in exchange the refund on every call to nonReentrant
595         // will be lower in amount. Since refunds are capped to a percetange of
596         // the total transaction's gas, it is best to keep them low in cases
597         // like this one, to increase the likelihood of the full refund coming
598         // into effect.
599         _notEntered = true;
600 
601     }
602 
603 
604     /**
605      * @dev Prevents a contract from calling itself, directly or indirectly.
606      * Calling a `nonReentrant` function from another `nonReentrant`
607      * function is not supported. It is possible to prevent this from happening
608      * by making the `nonReentrant` function external, and make it call a
609      * `private` function that does the actual work.
610      */
611     modifier nonReentrant() {
612         // On the first call to nonReentrant, _notEntered will be true
613         require(_notEntered, "ReentrancyGuard: reentrant call");
614 
615         // Any calls to nonReentrant after this point will fail
616         _notEntered = false;
617 
618         _;
619 
620         // By storing the original value once again, a refund is triggered (see
621         // https://eips.ethereum.org/EIPS/eip-2200)
622         _notEntered = true;
623     }
624 
625     uint256[49] private __gap;
626 }
627 
628 /**
629  * @dev Standard math utilities missing in the Solidity language.
630  */
631 library Math {
632     /**
633      * @dev Returns the largest of two numbers.
634      */
635     function max(uint256 a, uint256 b) internal pure returns (uint256) {
636         return a >= b ? a : b;
637     }
638 
639     /**
640      * @dev Returns the smallest of two numbers.
641      */
642     function min(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a < b ? a : b;
644     }
645 
646     /**
647      * @dev Returns the average of two numbers. The result is rounded towards
648      * zero.
649      */
650     function average(uint256 a, uint256 b) internal pure returns (uint256) {
651         // (a + b) / 2 can overflow, so we distribute
652         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
653     }
654 }
655 
656 /**
657  * @dev Wrappers over Solidity's arithmetic operations with added overflow
658  * checks.
659  *
660  * Arithmetic operations in Solidity wrap on overflow. This can easily result
661  * in bugs, because programmers usually assume that an overflow raises an
662  * error, which is the standard behavior in high level programming languages.
663  * `SafeMath` restores this intuition by reverting the transaction when an
664  * operation overflows.
665  *
666  * Using this library instead of the unchecked operations eliminates an entire
667  * class of bugs, so it's recommended to use it always.
668  */
669 library SafeMath {
670     /**
671      * @dev Returns the addition of two unsigned integers, reverting on
672      * overflow.
673      *
674      * Counterpart to Solidity's `+` operator.
675      *
676      * Requirements:
677      * - Addition cannot overflow.
678      */
679     function add(uint256 a, uint256 b) internal pure returns (uint256) {
680         uint256 c = a + b;
681         require(c >= a, "SafeMath: addition overflow");
682 
683         return c;
684     }
685 
686     /**
687      * @dev Returns the subtraction of two unsigned integers, reverting on
688      * overflow (when the result is negative).
689      *
690      * Counterpart to Solidity's `-` operator.
691      *
692      * Requirements:
693      * - Subtraction cannot overflow.
694      */
695     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
696         return sub(a, b, "SafeMath: subtraction overflow");
697     }
698 
699     /**
700      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
701      * overflow (when the result is negative).
702      *
703      * Counterpart to Solidity's `-` operator.
704      *
705      * Requirements:
706      * - Subtraction cannot overflow.
707      */
708     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
709         require(b <= a, errorMessage);
710         uint256 c = a - b;
711 
712         return c;
713     }
714 
715     function sub0(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a > b ? a - b : 0;
717     }
718 
719     /**
720      * @dev Returns the multiplication of two unsigned integers, reverting on
721      * overflow.
722      *
723      * Counterpart to Solidity's `*` operator.
724      *
725      * Requirements:
726      * - Multiplication cannot overflow.
727      */
728     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
729         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
730         // benefit is lost if 'b' is also tested.
731         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
732         if (a == 0) {
733             return 0;
734         }
735 
736         uint256 c = a * b;
737         require(c / a == b, "SafeMath: multiplication overflow");
738 
739         return c;
740     }
741 
742     /**
743      * @dev Returns the integer division of two unsigned integers. Reverts on
744      * division by zero. The result is rounded towards zero.
745      *
746      * Counterpart to Solidity's `/` operator. Note: this function uses a
747      * `revert` opcode (which leaves remaining gas untouched) while Solidity
748      * uses an invalid opcode to revert (consuming all remaining gas).
749      *
750      * Requirements:
751      * - The divisor cannot be zero.
752      */
753     function div(uint256 a, uint256 b) internal pure returns (uint256) {
754         return div(a, b, "SafeMath: division by zero");
755     }
756 
757     /**
758      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
759      * division by zero. The result is rounded towards zero.
760      *
761      * Counterpart to Solidity's `/` operator. Note: this function uses a
762      * `revert` opcode (which leaves remaining gas untouched) while Solidity
763      * uses an invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      * - The divisor cannot be zero.
767      */
768     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
769         // Solidity only automatically asserts when dividing by 0
770         require(b > 0, errorMessage);
771         uint256 c = a / b;
772         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
773 
774         return c;
775     }
776 
777     /**
778      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
779      * Reverts when dividing by zero.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      * - The divisor cannot be zero.
787      */
788     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
789         return mod(a, b, "SafeMath: modulo by zero");
790     }
791 
792     /**
793      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
794      * Reverts with custom message when dividing by zero.
795      *
796      * Counterpart to Solidity's `%` operator. This function uses a `revert`
797      * opcode (which leaves remaining gas untouched) while Solidity uses an
798      * invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      * - The divisor cannot be zero.
802      */
803     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
804         require(b != 0, errorMessage);
805         return a % b;
806     }
807 }
808 
809 /**
810  * Utility library of inline functions on addresses
811  *
812  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
813  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
814  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
815  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
816  */
817 library OpenZeppelinUpgradesAddress {
818     /**
819      * Returns whether the target address is a contract
820      * @dev This function will return false if invoked during the constructor of a contract,
821      * as the code is not actually created until after the constructor finishes.
822      * @param account address of the account to check
823      * @return whether the target address is a contract
824      */
825     function isContract(address account) internal view returns (bool) {
826         uint256 size;
827         // XXX Currently there is no better way to check if there is a contract in an address
828         // than to check the size of the code at that address.
829         // See https://ethereum.stackexchange.com/a/14016/36603
830         // for more details about how this works.
831         // TODO Check this again before the Serenity release, because all addresses will be
832         // contracts then.
833         // solhint-disable-next-line no-inline-assembly
834         assembly { size := extcodesize(account) }
835         return size > 0;
836     }
837 }
838 
839 /**
840  * @dev Collection of functions related to the address type
841  */
842 library Address {
843     /**
844      * @dev Returns true if `account` is a contract.
845      *
846      * [IMPORTANT]
847      * ====
848      * It is unsafe to assume that an address for which this function returns
849      * false is an externally-owned account (EOA) and not a contract.
850      *
851      * Among others, `isContract` will return false for the following
852      * types of addresses:
853      *
854      *  - an externally-owned account
855      *  - a contract in construction
856      *  - an address where a contract will be created
857      *  - an address where a contract lived, but was destroyed
858      * ====
859      */
860     function isContract(address account) internal view returns (bool) {
861         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
862         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
863         // for accounts without code, i.e. `keccak256('')`
864         bytes32 codehash;
865         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
866         // solhint-disable-next-line no-inline-assembly
867         assembly { codehash := extcodehash(account) }
868         return (codehash != accountHash && codehash != 0x0);
869     }
870 
871     /**
872      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
873      * `recipient`, forwarding all available gas and reverting on errors.
874      *
875      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
876      * of certain opcodes, possibly making contracts go over the 2300 gas limit
877      * imposed by `transfer`, making them unable to receive funds via
878      * `transfer`. {sendValue} removes this limitation.
879      *
880      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
881      *
882      * IMPORTANT: because control is transferred to `recipient`, care must be
883      * taken to not create reentrancy vulnerabilities. Consider using
884      * {ReentrancyGuard} or the
885      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
886      */
887     function sendValue(address payable recipient, uint256 amount) internal {
888         require(address(this).balance >= amount, "Address: insufficient balance");
889 
890         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
891         (bool success, ) = recipient.call{ value: amount }("");
892         require(success, "Address: unable to send value, recipient may have reverted");
893     }
894 }
895 
896 /**
897  * @dev Interface of the ERC20 standard as defined in the EIP.
898  */
899 interface IERC20 {
900     /**
901      * @dev Returns the amount of tokens in existence.
902      */
903     function totalSupply() external view returns (uint256);
904 
905     /**
906      * @dev Returns the amount of tokens owned by `account`.
907      */
908     function balanceOf(address account) external view returns (uint256);
909 
910     /**
911      * @dev Moves `amount` tokens from the caller's account to `recipient`.
912      *
913      * Returns a boolean value indicating whether the operation succeeded.
914      *
915      * Emits a {Transfer} event.
916      */
917     function transfer(address recipient, uint256 amount) external returns (bool);
918 
919     /**
920      * @dev Returns the remaining number of tokens that `spender` will be
921      * allowed to spend on behalf of `owner` through {transferFrom}. This is
922      * zero by default.
923      *
924      * This value changes when {approve} or {transferFrom} are called.
925      */
926     function allowance(address owner, address spender) external view returns (uint256);
927 
928     /**
929      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
930      *
931      * Returns a boolean value indicating whether the operation succeeded.
932      *
933      * IMPORTANT: Beware that changing an allowance with this method brings the risk
934      * that someone may use both the old and the new allowance by unfortunate
935      * transaction ordering. One possible solution to mitigate this race
936      * condition is to first reduce the spender's allowance to 0 and set the
937      * desired value afterwards:
938      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
939      *
940      * Emits an {Approval} event.
941      */
942     function approve(address spender, uint256 amount) external returns (bool);
943 
944     /**
945      * @dev Moves `amount` tokens from `sender` to `recipient` using the
946      * allowance mechanism. `amount` is then deducted from the caller's
947      * allowance.
948      *
949      * Returns a boolean value indicating whether the operation succeeded.
950      *
951      * Emits a {Transfer} event.
952      */
953     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
954 
955     /**
956      * @dev Emitted when `value` tokens are moved from one account (`from`) to
957      * another (`to`).
958      *
959      * Note that `value` may be zero.
960      */
961     event Transfer(address indexed from, address indexed to, uint256 value);
962 
963     /**
964      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
965      * a call to {approve}. `value` is the new allowance.
966      */
967     event Approval(address indexed owner, address indexed spender, uint256 value);
968 }
969 
970 /**
971  * @dev Implementation of the {IERC20} interface.
972  *
973  * This implementation is agnostic to the way tokens are created. This means
974  * that a supply mechanism has to be added in a derived contract using {_mint}.
975  * For a generic mechanism see {ERC20MinterPauser}.
976  *
977  * TIP: For a detailed writeup see our guide
978  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
979  * to implement supply mechanisms].
980  *
981  * We have followed general OpenZeppelin guidelines: functions revert instead
982  * of returning `false` on failure. This behavior is nonetheless conventional
983  * and does not conflict with the expectations of ERC20 applications.
984  *
985  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
986  * This allows applications to reconstruct the allowance for all accounts just
987  * by listening to said events. Other implementations of the EIP may not emit
988  * these events, as it isn't required by the specification.
989  *
990  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
991  * functions have been added to mitigate the well-known issues around setting
992  * allowances. See {IERC20-approve}.
993  */
994 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
995     using SafeMath for uint256;
996     using Address for address;
997 
998     mapping (address => uint256) private _balances;
999 
1000     mapping (address => mapping (address => uint256)) private _allowances;
1001 
1002     uint256 private _totalSupply;
1003 
1004     string private _name;
1005     string private _symbol;
1006     uint8 private _decimals;
1007 
1008     /**
1009      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1010      * a default value of 18.
1011      *
1012      * To select a different value for {decimals}, use {_setupDecimals}.
1013      *
1014      * All three of these values are immutable: they can only be set once during
1015      * construction.
1016      */
1017 
1018     function __ERC20_init(string memory name, string memory symbol) internal initializer {
1019         __Context_init_unchained();
1020         __ERC20_init_unchained(name, symbol);
1021     }
1022 
1023     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
1024 
1025 
1026         _name = name;
1027         _symbol = symbol;
1028         _decimals = 18;
1029 
1030     }
1031 
1032 
1033     /**
1034      * @dev Returns the name of the token.
1035      */
1036     function name() public view returns (string memory) {
1037         return _name;
1038     }
1039 
1040     /**
1041      * @dev Returns the symbol of the token, usually a shorter version of the
1042      * name.
1043      */
1044     function symbol() public view returns (string memory) {
1045         return _symbol;
1046     }
1047 
1048     /**
1049      * @dev Returns the number of decimals used to get its user representation.
1050      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1051      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1052      *
1053      * Tokens usually opt for a value of 18, imitating the relationship between
1054      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1055      * called.
1056      *
1057      * NOTE: This information is only used for _display_ purposes: it in
1058      * no way affects any of the arithmetic of the contract, including
1059      * {IERC20-balanceOf} and {IERC20-transfer}.
1060      */
1061     function decimals() public view returns (uint8) {
1062         return _decimals;
1063     }
1064 
1065     /**
1066      * @dev See {IERC20-totalSupply}.
1067      */
1068     function totalSupply() public view override returns (uint256) {
1069         return _totalSupply;
1070     }
1071 
1072     /**
1073      * @dev See {IERC20-balanceOf}.
1074      */
1075     function balanceOf(address account) public view override returns (uint256) {
1076         return _balances[account];
1077     }
1078 
1079     /**
1080      * @dev See {IERC20-transfer}.
1081      *
1082      * Requirements:
1083      *
1084      * - `recipient` cannot be the zero address.
1085      * - the caller must have a balance of at least `amount`.
1086      */
1087     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1088         _transfer(_msgSender(), recipient, amount);
1089         return true;
1090     }
1091 
1092     /**
1093      * @dev See {IERC20-allowance}.
1094      */
1095     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1096         return _allowances[owner][spender];
1097     }
1098 
1099     /**
1100      * @dev See {IERC20-approve}.
1101      *
1102      * Requirements:
1103      *
1104      * - `spender` cannot be the zero address.
1105      */
1106     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1107         _approve(_msgSender(), spender, amount);
1108         return true;
1109     }
1110 
1111     /**
1112      * @dev See {IERC20-transferFrom}.
1113      *
1114      * Emits an {Approval} event indicating the updated allowance. This is not
1115      * required by the EIP. See the note at the beginning of {ERC20};
1116      *
1117      * Requirements:
1118      * - `sender` and `recipient` cannot be the zero address.
1119      * - `sender` must have a balance of at least `amount`.
1120      * - the caller must have allowance for ``sender``'s tokens of at least
1121      * `amount`.
1122      */
1123     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1124         _transfer(sender, recipient, amount);
1125         if(sender != _msgSender() && _allowances[sender][_msgSender()] != uint(-1))
1126             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1127         return true;
1128     }
1129 
1130     /**
1131      * @dev Atomically increases the allowance granted to `spender` by the caller.
1132      *
1133      * This is an alternative to {approve} that can be used as a mitigation for
1134      * problems described in {IERC20-approve}.
1135      *
1136      * Emits an {Approval} event indicating the updated allowance.
1137      *
1138      * Requirements:
1139      *
1140      * - `spender` cannot be the zero address.
1141      */
1142     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1143         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1144         return true;
1145     }
1146 
1147     /**
1148      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1149      *
1150      * This is an alternative to {approve} that can be used as a mitigation for
1151      * problems described in {IERC20-approve}.
1152      *
1153      * Emits an {Approval} event indicating the updated allowance.
1154      *
1155      * Requirements:
1156      *
1157      * - `spender` cannot be the zero address.
1158      * - `spender` must have allowance for the caller of at least
1159      * `subtractedValue`.
1160      */
1161     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1162         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1163         return true;
1164     }
1165 
1166     /**
1167      * @dev Moves tokens `amount` from `sender` to `recipient`.
1168      *
1169      * This is internal function is equivalent to {transfer}, and can be used to
1170      * e.g. implement automatic token fees, slashing mechanisms, etc.
1171      *
1172      * Emits a {Transfer} event.
1173      *
1174      * Requirements:
1175      *
1176      * - `sender` cannot be the zero address.
1177      * - `recipient` cannot be the zero address.
1178      * - `sender` must have a balance of at least `amount`.
1179      */
1180     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1181         require(sender != address(0), "ERC20: transfer from the zero address");
1182         require(recipient != address(0), "ERC20: transfer to the zero address");
1183 
1184         _beforeTokenTransfer(sender, recipient, amount);
1185 
1186         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1187         _balances[recipient] = _balances[recipient].add(amount);
1188         emit Transfer(sender, recipient, amount);
1189     }
1190 
1191     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1192      * the total supply.
1193      *
1194      * Emits a {Transfer} event with `from` set to the zero address.
1195      *
1196      * Requirements
1197      *
1198      * - `to` cannot be the zero address.
1199      */
1200     function _mint(address account, uint256 amount) internal virtual {
1201         require(account != address(0), "ERC20: mint to the zero address");
1202 
1203         _beforeTokenTransfer(address(0), account, amount);
1204 
1205         _totalSupply = _totalSupply.add(amount);
1206         _balances[account] = _balances[account].add(amount);
1207         emit Transfer(address(0), account, amount);
1208     }
1209 
1210     /**
1211      * @dev Destroys `amount` tokens from `account`, reducing the
1212      * total supply.
1213      *
1214      * Emits a {Transfer} event with `to` set to the zero address.
1215      *
1216      * Requirements
1217      *
1218      * - `account` cannot be the zero address.
1219      * - `account` must have at least `amount` tokens.
1220      */
1221     function _burn(address account, uint256 amount) internal virtual {
1222         require(account != address(0), "ERC20: burn from the zero address");
1223 
1224         _beforeTokenTransfer(account, address(0), amount);
1225 
1226         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1227         _totalSupply = _totalSupply.sub(amount);
1228         emit Transfer(account, address(0), amount);
1229     }
1230 
1231     /**
1232      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1233      *
1234      * This is internal function is equivalent to `approve`, and can be used to
1235      * e.g. set automatic allowances for certain subsystems, etc.
1236      *
1237      * Emits an {Approval} event.
1238      *
1239      * Requirements:
1240      *
1241      * - `owner` cannot be the zero address.
1242      * - `spender` cannot be the zero address.
1243      */
1244     function _approve(address owner, address spender, uint256 amount) internal virtual {
1245         require(owner != address(0), "ERC20: approve from the zero address");
1246         require(spender != address(0), "ERC20: approve to the zero address");
1247 
1248         _allowances[owner][spender] = amount;
1249         emit Approval(owner, spender, amount);
1250     }
1251 
1252     /**
1253      * @dev Sets {decimals} to a value other than the default one of 18.
1254      *
1255      * WARNING: This function should only be called from the constructor. Most
1256      * applications that interact with token contracts will not expect
1257      * {decimals} to ever change, and may work incorrectly if it does.
1258      */
1259     function _setupDecimals(uint8 decimals_) internal {
1260         _decimals = decimals_;
1261     }
1262 
1263     /**
1264      * @dev Hook that is called before any transfer of tokens. This includes
1265      * minting and burning.
1266      *
1267      * Calling conditions:
1268      *
1269      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1270      * will be to transferred to `to`.
1271      * - when `from` is zero, `amount` tokens will be minted for `to`.
1272      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1273      * - `from` and `to` are never both zero.
1274      *
1275      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1276      */
1277     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1278 
1279     uint256[44] private __gap;
1280 }
1281 
1282 
1283 /**
1284  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1285  */
1286 abstract contract ERC20CappedUpgradeSafe is Initializable, ERC20UpgradeSafe {
1287     uint256 private _cap;
1288 
1289     /**
1290      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1291      * set once during construction.
1292      */
1293 
1294     function __ERC20Capped_init(uint256 cap) internal initializer {
1295         __Context_init_unchained();
1296         __ERC20Capped_init_unchained(cap);
1297     }
1298 
1299     function __ERC20Capped_init_unchained(uint256 cap) internal initializer {
1300 
1301 
1302         require(cap > 0, "ERC20Capped: cap is 0");
1303         _cap = cap;
1304 
1305     }
1306 
1307 
1308     /**
1309      * @dev Returns the cap on the token's total supply.
1310      */
1311     function cap() public view returns (uint256) {
1312         return _cap;
1313     }
1314 
1315     /**
1316      * @dev See {ERC20-_beforeTokenTransfer}.
1317      *
1318      * Requirements:
1319      *
1320      * - minted tokens must not cause the total supply to go over the cap.
1321      */
1322     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1323         super._beforeTokenTransfer(from, to, amount);
1324 
1325         if (from == address(0)) { // When minting tokens
1326             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1327         }
1328     }
1329 
1330     uint256[49] private __gap;
1331 }
1332 
1333 
1334 /**
1335  * @title SafeERC20
1336  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1337  * contract returns false). Tokens that return no value (and instead revert or
1338  * throw on failure) are also supported, non-reverting calls are assumed to be
1339  * successful.
1340  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1341  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1342  */
1343 library SafeERC20 {
1344     using SafeMath for uint256;
1345     using Address for address;
1346 
1347     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1348         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1349     }
1350 
1351     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1352         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1353     }
1354 
1355     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1356         // safeApprove should only be called when setting an initial allowance,
1357         // or when resetting it to zero. To increase and decrease it, use
1358         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1359         // solhint-disable-next-line max-line-length
1360         require((value == 0) || (token.allowance(address(this), spender) == 0),
1361             "SafeERC20: approve from non-zero to non-zero allowance"
1362         );
1363         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1364     }
1365 
1366     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1367         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1368         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1369     }
1370 
1371     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1372         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1373         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1374     }
1375 
1376     /**
1377      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1378      * on the return value: the return value is optional (but if data is returned, it must not be false).
1379      * @param token The token targeted by the call.
1380      * @param data The call data (encoded using abi.encode or one of its variants).
1381      */
1382     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1383         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1384         // we're implementing it ourselves.
1385 
1386         // A Solidity high level call has three parts:
1387         //  1. The target address is checked to verify it contains contract code
1388         //  2. The call itself is made, and success asserted
1389         //  3. The return value is decoded, which in turn checks the size of the returned data.
1390         // solhint-disable-next-line max-line-length
1391         require(address(token).isContract(), "SafeERC20: call to non-contract");
1392 
1393         // solhint-disable-next-line avoid-low-level-calls
1394         (bool success, bytes memory returndata) = address(token).call(data);
1395         require(success, "SafeERC20: low-level call failed");
1396 
1397         if (returndata.length > 0) { // Return data is optional
1398             // solhint-disable-next-line max-line-length
1399             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1400         }
1401     }
1402 }
1403 
1404 
1405 contract Governable is Initializable {
1406     address public governor;
1407 
1408     event GovernorshipTransferred(address indexed previousGovernor, address indexed newGovernor);
1409 
1410     /**
1411      * @dev Contract initializer.
1412      * called once by the factory at time of deployment
1413      */
1414     function __Governable_init_unchained(address governor_) virtual public initializer {
1415         governor = governor_;
1416         emit GovernorshipTransferred(address(0), governor);
1417     }
1418 
1419     modifier governance() {
1420         require(msg.sender == governor);
1421         _;
1422     }
1423 
1424     /**
1425      * @dev Allows the current governor to relinquish control of the contract.
1426      * @notice Renouncing to governorship will leave the contract without an governor.
1427      * It will not be possible to call the functions with the `governance`
1428      * modifier anymore.
1429      */
1430     function renounceGovernorship() public governance {
1431         emit GovernorshipTransferred(governor, address(0));
1432         governor = address(0);
1433     }
1434 
1435     /**
1436      * @dev Allows the current governor to transfer control of the contract to a newGovernor.
1437      * @param newGovernor The address to transfer governorship to.
1438      */
1439     function transferGovernorship(address newGovernor) public governance {
1440         _transferGovernorship(newGovernor);
1441     }
1442 
1443     /**
1444      * @dev Transfers control of the contract to a newGovernor.
1445      * @param newGovernor The address to transfer governorship to.
1446      */
1447     function _transferGovernorship(address newGovernor) internal {
1448         require(newGovernor != address(0));
1449         emit GovernorshipTransferred(governor, newGovernor);
1450         governor = newGovernor;
1451     }
1452 }
1453 
1454 
1455 contract ConfigurableBase {
1456     mapping (bytes32 => uint) internal config;
1457     
1458     function getConfig(bytes32 key) public view returns (uint) {
1459         return config[key];
1460     }
1461     function getConfigI(bytes32 key, uint index) public view returns (uint) {
1462         return config[bytes32(uint(key) ^ index)];
1463     }
1464     function getConfigA(bytes32 key, address addr) public view returns (uint) {
1465         return config[bytes32(uint(key) ^ uint(addr))];
1466     }
1467 
1468     function _setConfig(bytes32 key, uint value) internal {
1469         if(config[key] != value)
1470             config[key] = value;
1471     }
1472     function _setConfig(bytes32 key, uint index, uint value) internal {
1473         _setConfig(bytes32(uint(key) ^ index), value);
1474     }
1475     function _setConfig(bytes32 key, address addr, uint value) internal {
1476         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1477     }
1478 }    
1479 
1480 contract Configurable is Governable, ConfigurableBase {
1481     function setConfig(bytes32 key, uint value) external governance {
1482         _setConfig(key, value);
1483     }
1484     function setConfigI(bytes32 key, uint index, uint value) external governance {
1485         _setConfig(bytes32(uint(key) ^ index), value);
1486     }
1487     function setConfigA(bytes32 key, address addr, uint value) public governance {
1488         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1489     }
1490 }
1491 
1492 
1493 // Inheritancea
1494 interface IStakingRewards {
1495     // Views
1496     function lastTimeRewardApplicable() external view returns (uint256);
1497 
1498     function rewardPerToken() external view returns (uint256);
1499 
1500     function rewards(address account) external view returns (uint256);
1501 
1502     function earned(address account) external view returns (uint256);
1503 
1504     function getRewardForDuration() external view returns (uint256);
1505 
1506     function totalSupply() external view returns (uint256);
1507 
1508     function balanceOf(address account) external view returns (uint256);
1509 
1510     // Mutative
1511 
1512     function stake(uint256 amount) external;
1513 
1514     function withdraw(uint256 amount) external;
1515 
1516     function getReward() external;
1517 
1518     function exit() external;
1519 }
1520 
1521 abstract contract RewardsDistributionRecipient {
1522     address public rewardsDistribution;
1523 
1524     function notifyRewardAmount(uint256 reward) virtual external;
1525 
1526     modifier onlyRewardsDistribution() {
1527         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
1528         _;
1529     }
1530 }
1531 
1532 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuardUpgradeSafe {
1533     using SafeMath for uint256;
1534     using SafeERC20 for IERC20;
1535 
1536     /* ========== STATE VARIABLES ========== */
1537 
1538     IERC20 public rewardsToken;
1539     IERC20 public stakingToken;
1540     uint256 public periodFinish = 0;
1541     uint256 public rewardRate = 0;                  // obsoleted
1542     uint256 public rewardsDuration = 60 days;
1543     uint256 public lastUpdateTime;
1544     uint256 public rewardPerTokenStored;
1545 
1546     mapping(address => uint256) public userRewardPerTokenPaid;
1547     mapping(address => uint256) override public rewards;
1548 
1549     uint256 internal _totalSupply;
1550     mapping(address => uint256) internal _balances;
1551 
1552     /* ========== CONSTRUCTOR ========== */
1553 
1554     //constructor(
1555     function __StakingRewards_init(
1556         address _rewardsDistribution,
1557         address _rewardsToken,
1558         address _stakingToken
1559     ) public initializer {
1560         __ReentrancyGuard_init_unchained();
1561         __StakingRewards_init_unchained(_rewardsDistribution, _rewardsToken, _stakingToken);
1562     }
1563     
1564     function __StakingRewards_init_unchained(address _rewardsDistribution, address _rewardsToken, address _stakingToken) public initializer {
1565         rewardsToken = IERC20(_rewardsToken);
1566         stakingToken = IERC20(_stakingToken);
1567         rewardsDistribution = _rewardsDistribution;
1568     }
1569 
1570     /* ========== VIEWS ========== */
1571 
1572     function totalSupply() virtual override public view returns (uint256) {
1573         return _totalSupply;
1574     }
1575 
1576     function balanceOf(address account) virtual override public view returns (uint256) {
1577         return _balances[account];
1578     }
1579 
1580     function lastTimeRewardApplicable() override public view returns (uint256) {
1581         return Math.min(block.timestamp, periodFinish);
1582     }
1583 
1584     function rewardPerToken() virtual override public view returns (uint256) {
1585         if (_totalSupply == 0) {
1586             return rewardPerTokenStored;
1587         }
1588         return
1589             rewardPerTokenStored.add(
1590                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
1591             );
1592     }
1593 
1594     function earned(address account) virtual override public view returns (uint256) {
1595         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
1596     }
1597 
1598     function getRewardForDuration() virtual override external view returns (uint256) {
1599         return rewardRate.mul(rewardsDuration);
1600     }
1601 
1602     /* ========== MUTATIVE FUNCTIONS ========== */
1603 
1604     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) virtual public nonReentrant updateReward(msg.sender) {
1605         require(amount > 0, "Cannot stake 0");
1606         _totalSupply = _totalSupply.add(amount);
1607         _balances[msg.sender] = _balances[msg.sender].add(amount);
1608 
1609         // permit
1610         IPermit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
1611 
1612         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1613         emit Staked(msg.sender, amount);
1614     }
1615 
1616     function stake(uint256 amount) virtual override public nonReentrant updateReward(msg.sender) {
1617         require(amount > 0, "Cannot stake 0");
1618         _totalSupply = _totalSupply.add(amount);
1619         _balances[msg.sender] = _balances[msg.sender].add(amount);
1620         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1621         emit Staked(msg.sender, amount);
1622     }
1623 
1624     function withdraw(uint256 amount) virtual override public nonReentrant updateReward(msg.sender) {
1625         require(amount > 0, "Cannot withdraw 0");
1626         _totalSupply = _totalSupply.sub(amount);
1627         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1628         stakingToken.safeTransfer(msg.sender, amount);
1629         emit Withdrawn(msg.sender, amount);
1630     }
1631 
1632     function getReward() virtual override public nonReentrant updateReward(msg.sender) {
1633         uint256 reward = rewards[msg.sender];
1634         if (reward > 0) {
1635             rewards[msg.sender] = 0;
1636             rewardsToken.safeTransfer(msg.sender, reward);
1637             emit RewardPaid(msg.sender, reward);
1638         }
1639     }
1640 
1641     function exit() virtual override public {
1642         withdraw(_balances[msg.sender]);
1643         getReward();
1644     }
1645 
1646     /* ========== RESTRICTED FUNCTIONS ========== */
1647 
1648     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
1649         if (block.timestamp >= periodFinish) {
1650             rewardRate = reward.div(rewardsDuration);
1651         } else {
1652             uint256 remaining = periodFinish.sub(block.timestamp);
1653             uint256 leftover = remaining.mul(rewardRate);
1654             rewardRate = reward.add(leftover).div(rewardsDuration);
1655         }
1656 
1657         // Ensure the provided reward amount is not more than the balance in the contract.
1658         // This keeps the reward rate in the right range, preventing overflows due to
1659         // very high values of rewardRate in the earned and rewardsPerToken functions;
1660         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1661         uint balance = rewardsToken.balanceOf(address(this));
1662         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
1663 
1664         lastUpdateTime = block.timestamp;
1665         periodFinish = block.timestamp.add(rewardsDuration);
1666         emit RewardAdded(reward);
1667     }
1668 
1669     /* ========== MODIFIERS ========== */
1670 
1671     modifier updateReward(address account) virtual {
1672         rewardPerTokenStored = rewardPerToken();
1673         lastUpdateTime = lastTimeRewardApplicable();
1674         if (account != address(0)) {
1675             rewards[account] = earned(account);
1676             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1677         }
1678         _;
1679     }
1680 
1681     /* ========== EVENTS ========== */
1682 
1683     event RewardAdded(uint256 reward);
1684     event Staked(address indexed user, uint256 amount);
1685     event Withdrawn(address indexed user, uint256 amount);
1686     event RewardPaid(address indexed user, uint256 reward);
1687 }
1688 
1689 interface IPermit {
1690     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1691 }
1692 
1693 
1694 contract Constants {
1695     bytes32 internal constant _TokenMapped_     = 'TokenMapped';
1696     bytes32 internal constant _MappableToken_   = 'MappableToken';
1697     bytes32 internal constant _MappingToken_    = 'MappingToken';
1698     bytes32 internal constant _fee_             = 'fee';
1699     bytes32 internal constant _feeCreate_       = 'feeCreate';
1700     bytes32 internal constant _feeTo_           = 'feeTo';
1701     bytes32 internal constant _minSignatures_   = 'minSignatures';
1702     bytes32 internal constant _uniswapRounter_  = 'uniswapRounter';
1703     
1704     function _chainId() internal pure returns (uint id) {
1705         assembly { id := chainid() }
1706     }
1707 }
1708 
1709 struct Signature {
1710     address signatory;
1711     uint8   v;
1712     bytes32 r;
1713     bytes32 s;
1714 }
1715 
1716 abstract contract MappingBase is ContextUpgradeSafe, Constants {
1717 	using SafeMath for uint;
1718 
1719     bytes32 public constant RECEIVE_TYPEHASH = keccak256("Receive(uint256 fromChainId,address to,uint256 nonce,uint256 volume,address signatory)");
1720     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1721     bytes32 internal _DOMAIN_SEPARATOR;
1722     function DOMAIN_SEPARATOR() virtual public view returns (bytes32) {  return _DOMAIN_SEPARATOR;  }
1723 
1724     address public factory;
1725     uint256 public mainChainId;
1726     address public token;
1727     address public creator;
1728     
1729     mapping (address => uint) public authQuotaOf;                                       // signatory => quota
1730     mapping (uint => mapping (address => uint)) public sentCount;                       // toChainId => to => sentCount
1731     mapping (uint => mapping (address => mapping (uint => uint))) public sent;          // toChainId => to => nonce => volume
1732     mapping (uint => mapping (address => mapping (uint => uint))) public received;      // fromChainId => to => nonce => volume
1733     
1734     modifier onlyFactory {
1735         require(msg.sender == factory, 'Only called by Factory');
1736         _;
1737     }
1738     
1739     function increaseAuthQuotas(address[] memory signatorys, uint[] memory increments) virtual external returns (uint[] memory quotas) {
1740         require(signatorys.length == increments.length, 'two array lenth not equal');
1741         quotas = new uint[](signatorys.length);
1742         for(uint i=0; i<signatorys.length; i++)
1743             quotas[i] = increaseAuthQuota(signatorys[i], increments[i]);
1744     }
1745     
1746     function increaseAuthQuota(address signatory, uint increment) virtual public onlyFactory returns (uint quota) {
1747         quota = authQuotaOf[signatory].add(increment);
1748         authQuotaOf[signatory] = quota;
1749         emit IncreaseAuthQuota(signatory, increment, quota);
1750     }
1751     event IncreaseAuthQuota(address indexed signatory, uint increment, uint quota);
1752     
1753     function decreaseAuthQuotas(address[] memory signatorys, uint[] memory decrements) virtual external returns (uint[] memory quotas) {
1754         require(signatorys.length == decrements.length, 'two array lenth not equal');
1755         quotas = new uint[](signatorys.length);
1756         for(uint i=0; i<signatorys.length; i++)
1757             quotas[i] = decreaseAuthQuota(signatorys[i], decrements[i]);
1758     }
1759     
1760     function decreaseAuthQuota(address signatory, uint decrement) virtual public onlyFactory returns (uint quota) {
1761         quota = authQuotaOf[signatory];
1762         if(quota < decrement)
1763             decrement = quota;
1764         return _decreaseAuthQuota(signatory, decrement);
1765     }
1766     
1767     function _decreaseAuthQuota(address signatory, uint decrement) virtual internal returns (uint quota) {
1768         quota = authQuotaOf[signatory].sub(decrement);
1769         authQuotaOf[signatory] = quota;
1770         emit DecreaseAuthQuota(signatory, decrement, quota);
1771     }
1772     event DecreaseAuthQuota(address indexed signatory, uint decrement, uint quota);
1773 
1774 
1775     function needApprove() virtual public pure returns (bool);
1776     
1777     function send(uint toChainId, address to, uint volume) virtual external payable returns (uint nonce) {
1778         return sendFrom(_msgSender(), toChainId, to, volume);
1779     }
1780     
1781     function sendFrom(address from, uint toChainId, address to, uint volume) virtual public payable returns (uint nonce) {
1782         _chargeFee();
1783         _sendFrom(from, volume);
1784         nonce = sentCount[toChainId][to]++;
1785         sent[toChainId][to][nonce] = volume;
1786         emit Send(from, toChainId, to, nonce, volume);
1787     }
1788     event Send(address indexed from, uint indexed toChainId, address indexed to, uint nonce, uint volume);
1789     
1790     function _sendFrom(address from, uint volume) virtual internal;
1791 
1792     function receive(uint256 fromChainId, address to, uint256 nonce, uint256 volume, Signature[] memory signatures) virtual external payable {
1793         _chargeFee();
1794         require(received[fromChainId][to][nonce] == 0, 'withdrawn already');
1795         uint N = signatures.length;
1796         require(N >= Factory(factory).getConfig(_minSignatures_), 'too few signatures');
1797         for(uint i=0; i<N; i++) {
1798             for(uint j=0; j<i; j++)
1799                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
1800             bytes32 structHash = keccak256(abi.encode(RECEIVE_TYPEHASH, fromChainId, to, nonce, volume, signatures[i].signatory));
1801             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", _DOMAIN_SEPARATOR, structHash));
1802             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
1803             require(signatory != address(0), "invalid signature");
1804             require(signatory == signatures[i].signatory, "unauthorized");
1805             _decreaseAuthQuota(signatures[i].signatory, volume);
1806             emit Authorize(fromChainId, to, nonce, volume, signatory);
1807         }
1808         received[fromChainId][to][nonce] = volume;
1809         _receive(to, volume);
1810         emit Receive(fromChainId, to, nonce, volume);
1811     }
1812     event Receive(uint256 indexed fromChainId, address indexed to, uint256 indexed nonce, uint256 volume);
1813     event Authorize(uint256 fromChainId, address indexed to, uint256 indexed nonce, uint256 volume, address indexed signatory);
1814     
1815     function _receive(address to, uint256 volume) virtual internal;
1816     
1817     function _chargeFee() virtual internal {
1818         require(msg.value >= Math.min(Factory(factory).getConfig(_fee_), 0.1 ether), 'fee is too low');
1819         address payable feeTo = address(Factory(factory).getConfig(_feeTo_));
1820         if(feeTo == address(0))
1821             feeTo = address(uint160(factory));
1822         feeTo.transfer(msg.value);
1823         emit ChargeFee(_msgSender(), feeTo, msg.value);
1824     }
1825     event ChargeFee(address indexed from, address indexed to, uint value);
1826 
1827     uint256[50] private __gap;
1828 }    
1829     
1830     
1831 contract TokenMapped is MappingBase {
1832     using SafeERC20 for IERC20;
1833     
1834 	function __TokenMapped_init(address factory_, address token_) external initializer {
1835         __Context_init_unchained();
1836 		__TokenMapped_init_unchained(factory_, token_);
1837 	}
1838 	
1839 	function __TokenMapped_init_unchained(address factory_, address token_) public initializer {
1840         factory = factory_;
1841         mainChainId = _chainId();
1842         token = token_;
1843         creator = address(0);
1844         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(ERC20UpgradeSafe(token).name())), _chainId(), address(this)));
1845 	}
1846 	
1847     function totalMapped() virtual public view returns (uint) {
1848         return IERC20(token).balanceOf(address(this));
1849     }
1850     
1851     function needApprove() virtual override public pure returns (bool) {
1852         return true;
1853     }
1854     
1855     function _sendFrom(address from, uint volume) virtual override internal {
1856         IERC20(token).safeTransferFrom(from, address(this), volume);
1857     }
1858 
1859     function _receive(address to, uint256 volume) virtual override internal {
1860         IERC20(token).safeTransfer(to, volume);
1861     }
1862 
1863     uint256[50] private __gap;
1864 }
1865 /*
1866 contract TokenMapped2 is TokenMapped, StakingRewards, ConfigurableBase {
1867     modifier governance {
1868         require(_msgSender() == MappingTokenFactory(factory).governor());
1869         _;
1870     }
1871     
1872     function setConfig(bytes32 key, uint value) external governance {
1873         _setConfig(key, value);
1874     }
1875     function setConfigI(bytes32 key, uint index, uint value) external governance {
1876         _setConfig(bytes32(uint(key) ^ index), value);
1877     }
1878     function setConfigA(bytes32 key, address addr, uint value) public governance {
1879         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1880     }
1881 
1882     function rewardDelta() public view returns (uint amt) {
1883         if(begin == 0 || begin >= now || lastUpdateTime >= now)
1884             return 0;
1885             
1886         amt = rewardsToken.allowance(rewardsDistribution, address(this)).sub0(rewards[address(0)]);
1887         
1888         // calc rewardDelta in period
1889         if(lep == 3) {                                                              // power
1890             uint y = period.mul(1 ether).div(lastUpdateTime.add(rewardsDuration).sub(begin));
1891             uint amt1 = amt.mul(1 ether).div(y);
1892             uint amt2 = amt1.mul(period).div(now.add(rewardsDuration).sub(begin));
1893             amt = amt.sub(amt2);
1894         } else if(lep == 2) {                                                       // exponential
1895             if(now.sub(lastUpdateTime) < rewardsDuration)
1896                 amt = amt.mul(now.sub(lastUpdateTime)).div(rewardsDuration);
1897         }else if(now < periodFinish)                                                // linear
1898             amt = amt.mul(now.sub(lastUpdateTime)).div(periodFinish.sub(lastUpdateTime));
1899         else if(lastUpdateTime >= periodFinish)
1900             amt = 0;
1901     }
1902     
1903     function rewardPerToken() virtual override public view returns (uint256) {
1904         if (_totalSupply == 0) {
1905             return rewardPerTokenStored;
1906         }
1907         return
1908             rewardPerTokenStored.add(
1909                 rewardDelta().mul(1e18).div(_totalSupply)
1910             );
1911     }
1912 
1913     modifier updateReward(address account) virtual override {
1914         (uint delta, uint d) = (rewardDelta(), 0);
1915         rewardPerTokenStored = rewardPerToken();
1916         lastUpdateTime = now;
1917         if (account != address(0)) {
1918             rewards[account] = earned(account);
1919             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1920         }
1921 
1922         address addr = address(config[_ecoAddr_]);
1923         uint ratio = config[_ecoRatio_];
1924         if(addr != address(0) && ratio != 0) {
1925             d = delta.mul(ratio).div(1 ether);
1926             rewards[addr] = rewards[addr].add(d);
1927         }
1928         rewards[address(0)] = rewards[address(0)].add(delta).add(d);
1929         _;
1930     }
1931 
1932     function getReward() virtual override public {
1933         getReward(msg.sender);
1934     }
1935     function getReward(address payable acct) virtual public nonReentrant updateReward(acct) {
1936         require(acct != address(0), 'invalid address');
1937         require(getConfig(_blocklist_, acct) == 0, 'In blocklist');
1938         bool isContract = acct.isContract();
1939         require(!isContract || config[_allowContract_] != 0 || getConfig(_allowlist_, acct) != 0, 'No allowContract');
1940 
1941         uint256 reward = rewards[acct];
1942         if (reward > 0) {
1943             paid[acct] = paid[acct].add(reward);
1944             paid[address(0)] = paid[address(0)].add(reward);
1945             rewards[acct] = 0;
1946             rewards[address(0)] = rewards[address(0)].sub0(reward);
1947             rewardsToken.safeTransferFrom(rewardsDistribution, acct, reward);
1948             emit RewardPaid(acct, reward);
1949         }
1950     }
1951 
1952     function getRewardForDuration() override external view returns (uint256) {
1953         return rewardsToken.allowance(rewardsDistribution, address(this)).sub0(rewards[address(0)]);
1954     }
1955     
1956 }
1957 */
1958 
1959 abstract contract Permit {
1960     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1961     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1962     function DOMAIN_SEPARATOR() virtual public view returns (bytes32);
1963 
1964     mapping (address => uint) public nonces;
1965 
1966     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
1967         require(deadline >= block.timestamp, 'permit EXPIRED');
1968         bytes32 digest = keccak256(
1969             abi.encodePacked(
1970                 '\x19\x01',
1971                 DOMAIN_SEPARATOR(),
1972                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
1973             )
1974         );
1975         address recoveredAddress = ecrecover(digest, v, r, s);
1976         require(recoveredAddress != address(0) && recoveredAddress == owner, 'permit INVALID_SIGNATURE');
1977         _approve(owner, spender, value);
1978     }
1979 
1980     function _approve(address owner, address spender, uint256 amount) internal virtual;    
1981 
1982     uint256[50] private __gap;
1983 }
1984 
1985 contract MappableToken is Permit, ERC20UpgradeSafe, MappingBase {
1986 	function __MappableToken_init(address factory_, address creator_, string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) external initializer {
1987         __Context_init_unchained();
1988 		__ERC20_init_unchained(name_, symbol_);
1989 		_setupDecimals(decimals_);
1990 		_mint(creator_, totalSupply_);
1991 		__MappableToken_init_unchained(factory_, creator_);
1992 	}
1993 	
1994 	function __MappableToken_init_unchained(address factory_, address creator_) public initializer {
1995         factory = factory_;
1996         mainChainId = _chainId();
1997         token = address(0);
1998         creator = creator_;
1999         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
2000 	}
2001 	
2002     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
2003         return MappingBase.DOMAIN_SEPARATOR();
2004     }
2005     
2006     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
2007         return ERC20UpgradeSafe._approve(owner, spender, amount);
2008     }
2009     
2010     function totalMapped() virtual public view returns (uint) {
2011         return balanceOf(address(this));
2012     }
2013     
2014     function needApprove() virtual override public pure returns (bool) {
2015         return false;
2016     }
2017     
2018     function _sendFrom(address from, uint volume) virtual override internal {
2019         transferFrom(from, address(this), volume);
2020     }
2021 
2022     function _receive(address to, uint256 volume) virtual override internal {
2023         _transfer(address(this), to, volume);
2024     }
2025 
2026     uint256[50] private __gap;
2027 }
2028 
2029 
2030 contract MappingToken is Permit, ERC20CappedUpgradeSafe, MappingBase {
2031 	function __MappingToken_init(address factory_, uint mainChainId_, address token_, address creator_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) external initializer {
2032         __Context_init_unchained();
2033 		__ERC20_init_unchained(name_, symbol_);
2034 		_setupDecimals(decimals_);
2035 		__ERC20Capped_init_unchained(cap_);
2036 		__MappingToken_init_unchained(factory_, mainChainId_, token_, creator_);
2037 	}
2038 	
2039 	function __MappingToken_init_unchained(address factory_, uint mainChainId_, address token_, address creator_) public initializer {
2040         factory = factory_;
2041         mainChainId = mainChainId_;
2042         token = token_;
2043         creator = (token_ == address(0)) ? creator_ : address(0);
2044         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
2045 	}
2046 	
2047     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
2048         return MappingBase.DOMAIN_SEPARATOR();
2049     }
2050     
2051     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
2052         return ERC20UpgradeSafe._approve(owner, spender, amount);
2053     }
2054     
2055     function needApprove() virtual override public pure returns (bool) {
2056         return false;
2057     }
2058     
2059     function _sendFrom(address from, uint volume) virtual override internal {
2060         _burn(from, volume);
2061         if(from != _msgSender() && allowance(from, _msgSender()) != uint(-1))
2062             _approve(from, _msgSender(), allowance(from, _msgSender()).sub(volume, "ERC20: transfer volume exceeds allowance"));
2063     }
2064 
2065     function _receive(address to, uint256 volume) virtual override internal {
2066         _mint(to, volume);
2067     }
2068 
2069     uint256[50] private __gap;
2070 }
2071 
2072 
2073 contract MappingTokenProxy is ProductProxy, Constants {
2074     constructor(address factory_, uint mainChainId_, address token_, address creator_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) public {
2075         //require(_factory() == address(0));
2076         assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
2077         assert(NAME_SLOT    == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
2078         _setFactory(factory_);
2079         _setName(_MappingToken_);
2080         (bool success,) = _implementation().delegatecall(abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', factory_, mainChainId_, token_, creator_, name_, symbol_, decimals_, cap_));
2081         require(success);
2082     }  
2083 }
2084 
2085 
2086 contract Factory is ContextUpgradeSafe, Configurable, Constants {
2087     using SafeERC20 for IERC20;
2088     using SafeMath for uint;
2089 
2090     bytes32 public constant REGISTER_TYPEHASH   = keccak256("RegisterMapping(uint mainChainId,address token,uint[] chainIds,address[] mappingTokenMappeds,address signatory)");
2091     bytes32 public constant CREATE_TYPEHASH     = keccak256("CreateMappingToken(address creator,uint mainChainId,address token,string name,string symbol,uint8 decimals,uint cap,address signatory)");
2092     bytes32 public constant DOMAIN_TYPEHASH     = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2093     bytes32 public DOMAIN_SEPARATOR;
2094 
2095     mapping (bytes32 => address) public productImplementations;
2096     mapping (address => address) public tokenMappeds;                // token => tokenMapped
2097     mapping (address => address) public mappableTokens;              // creator => mappableTokens
2098     mapping (uint256 => mapping (address => address)) public mappingTokens;     // mainChainId => token or creator => mappableTokens
2099     mapping (address => bool) public authorties;
2100     
2101     // only on ethereum mainnet
2102     mapping (address => uint) public authCountOf;                   // signatory => count
2103     mapping (address => uint256) internal _mainChainIdTokens;       // mappingToken => mainChainId+token
2104     mapping (address => mapping (uint => address)) public mappingTokenMappeds;  // token => chainId => mappingToken or tokenMapped
2105     uint[] public supportChainIds;
2106     mapping (string  => uint256) internal _certifiedTokens;         // symbol => mainChainId+token
2107     string[] public certifiedSymbols;
2108 
2109     function __MappingTokenFactory_init(address _governor, address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) external initializer {
2110         __Governable_init_unchained(_governor);
2111         __MappingTokenFactory_init_unchained(_implTokenMapped, _implMappableToken, _implMappingToken, _feeTo);
2112     }
2113     
2114     function __MappingTokenFactory_init_unchained(address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) public governance {
2115         config[_fee_]                           = 0.005 ether;
2116         //config[_feeCreate_]                     = 0.200 ether;
2117         config[_feeTo_]                         = uint(_feeTo);
2118         config[_minSignatures_]                 = 3;
2119         config[_uniswapRounter_]                = uint(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
2120 
2121         DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes('MappingTokenFactory')), _chainId(), address(this)));
2122         upgradeProductImplementationsTo_(_implTokenMapped, _implMappableToken, _implMappingToken);
2123         emit ProductProxyCodeHash(keccak256(type(InitializableProductProxy).creationCode));
2124     }
2125     event ProductProxyCodeHash(bytes32 codeHash);
2126 
2127     function upgradeProductImplementationsTo_(address _implTokenMapped, address _implMappableToken, address _implMappingToken) public governance {
2128         productImplementations[_TokenMapped_]   = _implTokenMapped;
2129         productImplementations[_MappableToken_] = _implMappableToken;
2130         productImplementations[_MappingToken_]  = _implMappingToken;
2131     }
2132     
2133     function setAuthorty_(address authorty, bool enable) virtual external governance {
2134         authorties[authorty] = enable;
2135         emit SetAuthorty(authorty, enable);
2136     }
2137     event SetAuthorty(address indexed authorty, bool indexed enable);
2138     
2139     modifier onlyAuthorty {
2140         require(authorties[_msgSender()], 'only authorty');
2141         _;
2142     }
2143     
2144     function increaseAuthQuotas(address mappingTokenMapped, address[] memory signatorys, uint[] memory increments) virtual external onlyAuthorty returns (uint[] memory quotas) {
2145         quotas = MappingBase(mappingTokenMapped).increaseAuthQuotas(signatorys, increments);
2146         for(uint i=0; i<signatorys.length; i++)
2147             emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatorys[i], increments[i], quotas[i]);
2148     }
2149     
2150     function increaseAuthQuota(address mappingTokenMapped, address signatory, uint increment) virtual external onlyAuthorty returns (uint quota) {
2151         quota = MappingBase(mappingTokenMapped).increaseAuthQuota(signatory, increment);
2152         emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, increment, quota);
2153     }
2154     event IncreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint increment, uint quota);
2155     
2156     function decreaseAuthQuotas(address mappingTokenMapped, address[] memory signatorys, uint[] memory decrements) virtual external onlyAuthorty returns (uint[] memory quotas) {
2157         quotas = MappingBase(mappingTokenMapped).decreaseAuthQuotas(signatorys, decrements);
2158         for(uint i=0; i<signatorys.length; i++)
2159             emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatorys[i], decrements[i], quotas[i]);
2160     }
2161     
2162     function decreaseAuthQuota(address mappingTokenMapped, address signatory, uint decrement) virtual external onlyAuthorty returns (uint quota) {
2163         quota = MappingBase(mappingTokenMapped).decreaseAuthQuota(signatory, decrement);
2164         emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, decrement, quota);
2165     }
2166     event DecreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint decrement, uint quota);
2167 
2168     function increaseAuthCount(address[] memory signatorys, uint[] memory increments) virtual external returns (uint[] memory counts) {
2169         require(signatorys.length == increments.length, 'two array lenth not equal');
2170         counts = new uint[](signatorys.length);
2171         for(uint i=0; i<signatorys.length; i++)
2172             counts[i] = increaseAuthCount(signatorys[i], increments[i]);
2173     }
2174     
2175     function increaseAuthCount(address signatory, uint increment) virtual public onlyAuthorty returns (uint count) {
2176         count = authCountOf[signatory].add(increment);
2177         authCountOf[signatory] = count;
2178         emit IncreaseAuthQuota(_msgSender(), signatory, increment, count);
2179     }
2180     event IncreaseAuthQuota(address indexed authorty, address indexed signatory, uint increment, uint quota);
2181     
2182     function decreaseAuthCounts(address[] memory signatorys, uint[] memory decrements) virtual external returns (uint[] memory counts) {
2183         require(signatorys.length == decrements.length, 'two array lenth not equal');
2184         counts = new uint[](signatorys.length);
2185         for(uint i=0; i<signatorys.length; i++)
2186             counts[i] = decreaseAuthCount(signatorys[i], decrements[i]);
2187     }
2188     
2189     function decreaseAuthCount(address signatory, uint decrement) virtual public onlyAuthorty returns (uint count) {
2190         count = authCountOf[signatory];
2191         if(count < decrement)
2192             decrement = count;
2193         return _decreaseAuthCount(signatory, decrement);
2194     }
2195     
2196     function _decreaseAuthCount(address signatory, uint decrement) virtual internal returns (uint count) {
2197         count = authCountOf[signatory].sub(decrement);
2198         authCountOf[signatory] = count;
2199         emit DecreaseAuthCount(_msgSender(), signatory, decrement, count);
2200     }
2201     event DecreaseAuthCount(address indexed authorty, address indexed signatory, uint decrement, uint count);
2202 
2203     function supportChainCount() public view returns (uint) {
2204         return supportChainIds.length;
2205     }
2206     
2207     function mainChainIdTokens(address mappingToken) virtual public view returns(uint mainChainId, address token) {
2208         uint256 chainIdToken = _mainChainIdTokens[mappingToken];
2209         mainChainId = chainIdToken >> 160;
2210         token = address(chainIdToken);
2211     }
2212     
2213     function chainIdMappingTokenMappeds(address tokenOrMappingToken) virtual external view returns (uint[] memory chainIds, address[] memory mappingTokenMappeds_) {
2214         (, address token) = mainChainIdTokens(tokenOrMappingToken);
2215         if(token == address(0))
2216             token = tokenOrMappingToken;
2217         uint N = 0;
2218         for(uint i=0; i<supportChainCount(); i++)
2219             if(mappingTokenMappeds[token][supportChainIds[i]] != address(0))
2220                 N++;
2221         chainIds = new uint[](N);
2222         mappingTokenMappeds_ = new address[](N);
2223         uint j = 0;
2224         for(uint i=0; i<supportChainCount(); i++) {
2225             uint chainId = supportChainIds[i];
2226             address mappingTokenMapped = mappingTokenMappeds[token][chainId];
2227             if(mappingTokenMapped != address(0)) {
2228                 chainIds[j] = chainId;
2229                 mappingTokenMappeds_[j] = mappingTokenMapped;
2230                 j++;
2231             }
2232         }
2233     }
2234     
2235     function isSupportChainId(uint chainId) virtual public view returns (bool) {
2236         for(uint i=0; i<supportChainCount(); i++)
2237             if(supportChainIds[i] == chainId)
2238                 return true;
2239         return false;
2240     }
2241     
2242     function registerSupportChainId_(uint chainId_) virtual external governance {
2243         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2244         require(!isSupportChainId(chainId_), 'support chainId already');
2245         supportChainIds.push(chainId_);
2246     }
2247     
2248     function _registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual internal {
2249         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2250         require(chainIds.length == mappingTokenMappeds_.length, 'two array lenth not equal');
2251         require(isSupportChainId(mainChainId), 'Not support mainChainId');
2252         for(uint i=0; i<chainIds.length; i++) {
2253             require(isSupportChainId(chainIds[i]), 'Not support chainId');
2254             //require(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0 || _mainChainIdTokens[mappingTokenMappeds_[i]] == (mainChainId << 160) | uint(token), 'mainChainIdTokens exist already');
2255             //require(mappingTokenMappeds[token][chainIds[i]] == address(0), 'mappingTokenMappeds exist already');
2256             //if(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0)
2257                 _mainChainIdTokens[mappingTokenMappeds_[i]] = (mainChainId << 160) | uint(token);
2258             mappingTokenMappeds[token][chainIds[i]] = mappingTokenMappeds_[i];
2259             emit RegisterMapping(mainChainId, token, chainIds[i], mappingTokenMappeds_[i]);
2260         }
2261     }
2262     event RegisterMapping(uint mainChainId, address token, uint chainId, address mappingTokenMapped);
2263     
2264     function registerMapping_(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual external governance {
2265         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
2266     }
2267     
2268     function registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_, Signature[] memory signatures) virtual external payable {
2269         _chargeFee();
2270         uint N = signatures.length;
2271         require(N >= getConfig(_minSignatures_), 'too few signatures');
2272         for(uint i=0; i<N; i++) {
2273             for(uint j=0; j<i; j++)
2274                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2275             bytes32 structHash = keccak256(abi.encode(REGISTER_TYPEHASH, mainChainId, token, keccak256(abi.encodePacked(chainIds)), keccak256(abi.encodePacked(mappingTokenMappeds_)), signatures[i].signatory));
2276             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
2277             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
2278             require(signatory != address(0), "invalid signature");
2279             require(signatory == signatures[i].signatory, "unauthorized");
2280             _decreaseAuthCount(signatures[i].signatory, 1);
2281             emit AuthorizeRegister(mainChainId, token, signatory);
2282         }
2283         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
2284     }
2285     event AuthorizeRegister(uint indexed mainChainId, address indexed token, address indexed signatory);
2286 
2287     function certifiedCount() external view returns (uint) {
2288         return certifiedSymbols.length;
2289     }
2290     
2291     function certifiedTokens(string memory symbol) public view returns (uint mainChainId, address token) {
2292         uint256 chainIdToken = _certifiedTokens[symbol];
2293         mainChainId = chainIdToken >> 160;
2294         token = address(chainIdToken);
2295     }
2296     
2297     function allCertifiedTokens() external view returns (string[] memory symbols, uint[] memory chainIds, address[] memory tokens) {
2298         symbols = certifiedSymbols;
2299         uint N = certifiedSymbols.length;
2300         chainIds = new uint[](N);
2301         tokens = new address[](N);
2302         for(uint i=0; i<N; i++)
2303             (chainIds[i], tokens[i]) = certifiedTokens(certifiedSymbols[i]);
2304     }
2305 
2306     function registerCertified_(string memory symbol, uint mainChainId, address token) external governance {
2307         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2308         require(isSupportChainId(mainChainId), 'Not support mainChainId');
2309         require(_certifiedTokens[symbol] == 0, 'Certified added already');
2310         if(mainChainId == _chainId())
2311             require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
2312         _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
2313         certifiedSymbols.push(symbol);
2314         emit RegisterCertified(symbol, mainChainId, token);
2315     }
2316     event RegisterCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
2317     
2318     function updateCertified_(string memory symbol, uint mainChainId, address token) external governance {
2319         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2320         require(isSupportChainId(mainChainId), 'Not support mainChainId');
2321         //require(_certifiedTokens[symbol] == 0, 'Certified added already');
2322         if(mainChainId == _chainId())
2323             require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
2324         _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
2325         //certifiedSymbols.push(symbol);
2326         emit UpdateCertified(symbol, mainChainId, token);
2327     }
2328     event UpdateCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
2329     
2330     // calculates the CREATE2 address for a pair without making any external calls
2331     function calcMapping(uint mainChainId, address tokenOrCreator) public view returns (address) {
2332         return address(uint(keccak256(abi.encodePacked(
2333                 hex'ff',
2334                 address(this),
2335                 keccak256(abi.encodePacked(mainChainId, tokenOrCreator)),
2336 				keccak256(type(InitializableProductProxy).creationCode)                    //hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
2337             ))));
2338     }
2339 
2340     function createTokenMapped(address token) external payable returns (address tokenMapped) {
2341         _chargeFee();
2342         IERC20(token).totalSupply();                                                            // just for check
2343         require(tokenMappeds[token] == address(0), 'TokenMapped created already');
2344 
2345         bytes32 salt = keccak256(abi.encodePacked(_chainId(), token));
2346 
2347         bytes memory bytecode = type(InitializableProductProxy).creationCode;
2348         assembly {
2349             tokenMapped := create2(0, add(bytecode, 32), mload(bytecode), salt)
2350         }
2351         InitializableProductProxy(payable(tokenMapped)).__InitializableProductProxy_init(address(this), _TokenMapped_, abi.encodeWithSignature('__TokenMapped_init(address,address)', address(this), token));
2352         
2353         tokenMappeds[token] = tokenMapped;
2354         emit CreateTokenMapped(_msgSender(), token, tokenMapped);
2355     }
2356     event CreateTokenMapped(address indexed creator, address indexed token, address indexed tokenMapped);
2357     
2358     function createMappableToken(string memory name, string memory symbol, uint8 decimals, uint totalSupply) external payable returns (address mappableToken) {
2359         _chargeFee();
2360         require(mappableTokens[_msgSender()] == address(0), 'MappableToken created already');
2361 
2362         bytes32 salt = keccak256(abi.encodePacked(_chainId(), _msgSender()));
2363 
2364         bytes memory bytecode = type(InitializableProductProxy).creationCode;
2365         assembly {
2366             mappableToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
2367         }
2368         InitializableProductProxy(payable(mappableToken)).__InitializableProductProxy_init(address(this), _MappableToken_, abi.encodeWithSignature('__MappableToken_init(address,address,string,string,uint8,uint256)', address(this), _msgSender(), name, symbol, decimals, totalSupply));
2369         
2370         mappableTokens[_msgSender()] = mappableToken;
2371         emit CreateMappableToken(_msgSender(), name, symbol, decimals, totalSupply, mappableToken);
2372     }
2373     event CreateMappableToken(address indexed creator, string name, string symbol, uint8 decimals, uint totalSupply, address indexed mappableToken);
2374     
2375     function _createMappingToken(uint mainChainId, address token, address creator, string memory name, string memory symbol, uint8 decimals, uint cap) internal returns (address mappingToken) {
2376         _chargeFee();
2377         address tokenOrCreator = (token == address(0)) ? creator : token;
2378         require(mappingTokens[mainChainId][tokenOrCreator] == address(0), 'MappingToken created already');
2379 
2380         bytes32 salt = keccak256(abi.encodePacked(mainChainId, tokenOrCreator));
2381 
2382         bytes memory bytecode = type(InitializableProductProxy).creationCode;
2383         assembly {
2384             mappingToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
2385         }
2386         InitializableProductProxy(payable(mappingToken)).__InitializableProductProxy_init(address(this), _MappingToken_, abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', address(this), mainChainId, token, creator, name, symbol, decimals, cap));
2387         
2388         mappingTokens[mainChainId][tokenOrCreator] = mappingToken;
2389         emit CreateMappingToken(mainChainId, token, creator, name, symbol, decimals, cap, mappingToken);
2390     }
2391     event CreateMappingToken(uint mainChainId, address indexed token, address indexed creator, string name, string symbol, uint8 decimals, uint cap, address indexed mappingToken);
2392     
2393     function createMappingToken_(uint mainChainId, address token, address creator, string memory name, string memory symbol, uint8 decimals, uint cap) public payable governance returns (address mappingToken) {
2394         return _createMappingToken(mainChainId, token, creator, name, symbol, decimals, cap);
2395     }
2396     
2397     function createMappingToken(uint mainChainId, address token, string memory name, string memory symbol, uint8 decimals, uint cap, Signature[] memory signatures) public payable returns (address mappingToken) {
2398         uint N = signatures.length;
2399         require(N >= getConfig(_minSignatures_), 'too few signatures');
2400         for(uint i=0; i<N; i++) {
2401             for(uint j=0; j<i; j++)
2402                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2403             bytes32 hash = keccak256(abi.encode(CREATE_TYPEHASH, _msgSender(), mainChainId, token, keccak256(bytes(name)), keccak256(bytes(symbol)), decimals, cap, signatures[i].signatory));
2404             hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash));
2405             address signatory = ecrecover(hash, signatures[i].v, signatures[i].r, signatures[i].s);
2406             require(signatory != address(0), "invalid signature");
2407             require(signatory == signatures[i].signatory, "unauthorized");
2408             _decreaseAuthCount(signatures[i].signatory, 1);
2409             emit AuthorizeCreate(mainChainId, token, _msgSender(), name, symbol, decimals, cap, signatory);
2410         }
2411         return _createMappingToken(mainChainId, token, _msgSender(), name, symbol, decimals, cap);
2412     }
2413     event AuthorizeCreate(uint mainChainId, address indexed token, address indexed creator, string name, string symbol, uint8 decimals, uint cap, address indexed signatory);
2414     
2415     function _chargeFee() virtual internal {
2416         require(msg.value >= Math.min(config[_feeCreate_], 1 ether), 'fee for Create is too low');
2417         address payable feeTo = address(config[_feeTo_]);
2418         if(feeTo == address(0))
2419             feeTo = address(uint160(address(this)));
2420         feeTo.transfer(msg.value);
2421         emit ChargeFee(_msgSender(), feeTo, msg.value);
2422     }
2423     event ChargeFee(address indexed from, address indexed to, uint value);
2424 
2425     uint256[50] private __gap;
2426 }