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
1287     uint256 internal _cap;
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
1311     function cap() virtual public view returns (uint256) {
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
1405 // https://github.com/hamdiallam/Solidity-RLP/blob/master/contracts/RLPReader.sol
1406 /*
1407 * @author Hamdi Allam hamdi.allam97@gmail.com
1408 * Please reach out with any questions or concerns
1409 */
1410 pragma solidity >=0.5.0 <0.7.0;
1411 
1412 library RLPReader {
1413     uint8 constant STRING_SHORT_START = 0x80;
1414     uint8 constant STRING_LONG_START  = 0xb8;
1415     uint8 constant LIST_SHORT_START   = 0xc0;
1416     uint8 constant LIST_LONG_START    = 0xf8;
1417     uint8 constant WORD_SIZE = 32;
1418 
1419     struct RLPItem {
1420         uint len;
1421         uint memPtr;
1422     }
1423 
1424     struct Iterator {
1425         RLPItem item;   // Item that's being iterated over.
1426         uint nextPtr;   // Position of the next item in the list.
1427     }
1428 
1429     /*
1430     * @dev Returns the next element in the iteration. Reverts if it has not next element.
1431     * @param self The iterator.
1432     * @return The next element in the iteration.
1433     */
1434     function next(Iterator memory self) internal pure returns (RLPItem memory) {
1435         require(hasNext(self));
1436 
1437         uint ptr = self.nextPtr;
1438         uint itemLength = _itemLength(ptr);
1439         self.nextPtr = ptr + itemLength;
1440 
1441         return RLPItem(itemLength, ptr);
1442     }
1443 
1444     /*
1445     * @dev Returns true if the iteration has more elements.
1446     * @param self The iterator.
1447     * @return true if the iteration has more elements.
1448     */
1449     function hasNext(Iterator memory self) internal pure returns (bool) {
1450         RLPItem memory item = self.item;
1451         return self.nextPtr < item.memPtr + item.len;
1452     }
1453 
1454     /*
1455     * @param item RLP encoded bytes
1456     */
1457     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
1458         uint memPtr;
1459         assembly {
1460             memPtr := add(item, 0x20)
1461         }
1462 
1463         return RLPItem(item.length, memPtr);
1464     }
1465 
1466     /*
1467     * @dev Create an iterator. Reverts if item is not a list.
1468     * @param self The RLP item.
1469     * @return An 'Iterator' over the item.
1470     */
1471     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
1472         require(isList(self));
1473 
1474         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
1475         return Iterator(self, ptr);
1476     }
1477 
1478     /*
1479     * @param the RLP item.
1480     */
1481     function rlpLen(RLPItem memory item) internal pure returns (uint) {
1482         return item.len;
1483     }
1484 
1485     /*
1486      * @param the RLP item.
1487      * @return (memPtr, len) pair: location of the item's payload in memory.
1488      */
1489     function payloadLocation(RLPItem memory item) internal pure returns (uint, uint) {
1490         uint offset = _payloadOffset(item.memPtr);
1491         uint memPtr = item.memPtr + offset;
1492         uint len = item.len - offset; // data length
1493         return (memPtr, len);
1494     }
1495 
1496     /*
1497     * @param the RLP item.
1498     */
1499     function payloadLen(RLPItem memory item) internal pure returns (uint) {
1500         (, uint len) = payloadLocation(item);
1501         return len;
1502     }
1503 
1504     /*
1505     * @param the RLP item containing the encoded list.
1506     */
1507     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
1508         require(isList(item));
1509 
1510         uint items = numItems(item);
1511         RLPItem[] memory result = new RLPItem[](items);
1512 
1513         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
1514         uint dataLen;
1515         for (uint i = 0; i < items; i++) {
1516             dataLen = _itemLength(memPtr);
1517             result[i] = RLPItem(dataLen, memPtr); 
1518             memPtr = memPtr + dataLen;
1519         }
1520 
1521         return result;
1522     }
1523 
1524     // @return indicator whether encoded payload is a list. negate this function call for isData.
1525     function isList(RLPItem memory item) internal pure returns (bool) {
1526         if (item.len == 0) return false;
1527 
1528         uint8 byte0;
1529         uint memPtr = item.memPtr;
1530         assembly {
1531             byte0 := byte(0, mload(memPtr))
1532         }
1533 
1534         if (byte0 < LIST_SHORT_START)
1535             return false;
1536         return true;
1537     }
1538 
1539     /*
1540      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
1541      * @return keccak256 hash of RLP encoded bytes.
1542      */
1543     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
1544         uint256 ptr = item.memPtr;
1545         uint256 len = item.len;
1546         bytes32 result;
1547         assembly {
1548             result := keccak256(ptr, len)
1549         }
1550         return result;
1551     }
1552 
1553     /*
1554      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
1555      * @return keccak256 hash of the item payload.
1556      */
1557     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
1558         (uint memPtr, uint len) = payloadLocation(item);
1559         bytes32 result;
1560         assembly {
1561             result := keccak256(memPtr, len)
1562         }
1563         return result;
1564     }
1565 
1566     /** RLPItem conversions into data types **/
1567 
1568     // @returns raw rlp encoding in bytes
1569     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
1570         bytes memory result = new bytes(item.len);
1571         if (result.length == 0) return result;
1572         
1573         uint ptr;
1574         assembly {
1575             ptr := add(0x20, result)
1576         }
1577 
1578         copy(item.memPtr, ptr, item.len);
1579         return result;
1580     }
1581 
1582     // any non-zero byte except "0x80" is considered true
1583     function toBoolean(RLPItem memory item) internal pure returns (bool) {
1584         require(item.len == 1);
1585         uint result;
1586         uint memPtr = item.memPtr;
1587         assembly {
1588             result := byte(0, mload(memPtr))
1589         }
1590 
1591         // SEE Github Issue #5.
1592         // Summary: Most commonly used RLP libraries (i.e Geth) will encode
1593         // "0" as "0x80" instead of as "0". We handle this edge case explicitly
1594         // here.
1595         if (result == 0 || result == STRING_SHORT_START) {
1596             return false;
1597         } else {
1598             return true;
1599         }
1600     }
1601 
1602     function toAddress(RLPItem memory item) internal pure returns (address) {
1603         // 1 byte for the length prefix
1604         require(item.len == 21);
1605 
1606         return address(toUint(item));
1607     }
1608 
1609     function toUint(RLPItem memory item) internal pure returns (uint) {
1610         require(item.len > 0 && item.len <= 33);
1611 
1612         (uint memPtr, uint len) = payloadLocation(item);
1613 
1614         uint result;
1615         assembly {
1616             result := mload(memPtr)
1617 
1618             // shfit to the correct location if neccesary
1619             if lt(len, 32) {
1620                 result := div(result, exp(256, sub(32, len)))
1621             }
1622         }
1623 
1624         return result;
1625     }
1626 
1627     // enforces 32 byte length
1628     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
1629         // one byte prefix
1630         require(item.len == 33);
1631 
1632         uint result;
1633         uint memPtr = item.memPtr + 1;
1634         assembly {
1635             result := mload(memPtr)
1636         }
1637 
1638         return result;
1639     }
1640 
1641     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
1642         require(item.len > 0);
1643 
1644         (uint memPtr, uint len) = payloadLocation(item);
1645         bytes memory result = new bytes(len);
1646 
1647         uint destPtr;
1648         assembly {
1649             destPtr := add(0x20, result)
1650         }
1651 
1652         copy(memPtr, destPtr, len);
1653         return result;
1654     }
1655 
1656     /*
1657     * Private Helpers
1658     */
1659 
1660     // @return number of payload items inside an encoded list.
1661     function numItems(RLPItem memory item) private pure returns (uint) {
1662         if (item.len == 0) return 0;
1663 
1664         uint count = 0;
1665         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
1666         uint endPtr = item.memPtr + item.len;
1667         while (currPtr < endPtr) {
1668            currPtr = currPtr + _itemLength(currPtr); // skip over an item
1669            count++;
1670         }
1671 
1672         return count;
1673     }
1674 
1675     // @return entire rlp item byte length
1676     function _itemLength(uint memPtr) private pure returns (uint) {
1677         uint itemLen;
1678         uint byte0;
1679         assembly {
1680             byte0 := byte(0, mload(memPtr))
1681         }
1682 
1683         if (byte0 < STRING_SHORT_START)
1684             itemLen = 1;
1685         
1686         else if (byte0 < STRING_LONG_START)
1687             itemLen = byte0 - STRING_SHORT_START + 1;
1688 
1689         else if (byte0 < LIST_SHORT_START) {
1690             assembly {
1691                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
1692                 memPtr := add(memPtr, 1) // skip over the first byte
1693                 
1694                 /* 32 byte word size */
1695                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
1696                 itemLen := add(dataLen, add(byteLen, 1))
1697             }
1698         }
1699 
1700         else if (byte0 < LIST_LONG_START) {
1701             itemLen = byte0 - LIST_SHORT_START + 1;
1702         } 
1703 
1704         else {
1705             assembly {
1706                 let byteLen := sub(byte0, 0xf7)
1707                 memPtr := add(memPtr, 1)
1708 
1709                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
1710                 itemLen := add(dataLen, add(byteLen, 1))
1711             }
1712         }
1713 
1714         return itemLen;
1715     }
1716 
1717     // @return number of bytes until the data
1718     function _payloadOffset(uint memPtr) private pure returns (uint) {
1719         uint byte0;
1720         assembly {
1721             byte0 := byte(0, mload(memPtr))
1722         }
1723 
1724         if (byte0 < STRING_SHORT_START) 
1725             return 0;
1726         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
1727             return 1;
1728         else if (byte0 < LIST_SHORT_START)  // being explicit
1729             return byte0 - (STRING_LONG_START - 1) + 1;
1730         else
1731             return byte0 - (LIST_LONG_START - 1) + 1;
1732     }
1733 
1734     /*
1735     * @param src Pointer to source
1736     * @param dest Pointer to destination
1737     * @param len Amount of memory to copy from the source
1738     */
1739     function copy(uint src, uint dest, uint len) private pure {
1740         if (len == 0) return;
1741 
1742         // copy as many word sizes as possible
1743         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
1744             assembly {
1745                 mstore(dest, mload(src))
1746             }
1747 
1748             src += WORD_SIZE;
1749             dest += WORD_SIZE;
1750         }
1751 
1752         // left over bytes. Mask is used to remove unwanted bytes from the word
1753         uint mask = 256 ** (WORD_SIZE - len) - 1;
1754         assembly {
1755             let srcpart := and(mload(src), not(mask)) // zero out src
1756             let destpart := and(mload(dest), mask) // retrieve the bytes
1757             mstore(dest, or(destpart, srcpart))
1758         }
1759     }
1760 }
1761 
1762 
1763 // https://github.com/bakaoh/solidity-rlp-encode/blob/master/contracts/RLPEncode.sol
1764 /**
1765  * @title RLPEncode
1766  * @dev A simple RLP encoding library.
1767  * @author Bakaoh
1768  */
1769 library RLPEncode {
1770     /*
1771      * Internal functions
1772      */
1773 
1774     /**
1775      * @dev RLP encodes a byte string.
1776      * @param self The byte string to encode.
1777      * @return The RLP encoded string in bytes.
1778      */
1779     function encodeBytes(bytes memory self) internal pure returns (bytes memory) {
1780         bytes memory encoded;
1781         if (self.length == 1 && uint8(self[0]) <= 128) {
1782             encoded = self;
1783         } else {
1784             encoded = concat(encodeLength(self.length, 128), self);
1785         }
1786         return encoded;
1787     }
1788 
1789     /**
1790      * @dev RLP encodes a list of RLP encoded byte byte strings.
1791      * @param self The list of RLP encoded byte strings.
1792      * @return The RLP encoded list of items in bytes.
1793      */
1794     function encodeList(bytes[] memory self) internal pure returns (bytes memory) {
1795         bytes memory list = flatten(self);
1796         return concat(encodeLength(list.length, 192), list);
1797     }
1798 
1799     /**
1800      * @dev RLP encodes a string.
1801      * @param self The string to encode.
1802      * @return The RLP encoded string in bytes.
1803      */
1804     function encodeString(string memory self) internal pure returns (bytes memory) {
1805         return encodeBytes(bytes(self));
1806     }
1807 
1808     /** 
1809      * @dev RLP encodes an address.
1810      * @param self The address to encode.
1811      * @return The RLP encoded address in bytes.
1812      */
1813     function encodeAddress(address self) internal pure returns (bytes memory) {
1814         bytes memory inputBytes;
1815         assembly {
1816             let m := mload(0x40)
1817             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, self))
1818             mstore(0x40, add(m, 52))
1819             inputBytes := m
1820         }
1821         return encodeBytes(inputBytes);
1822     }
1823 
1824     /** 
1825      * @dev RLP encodes a uint.
1826      * @param self The uint to encode.
1827      * @return The RLP encoded uint in bytes.
1828      */
1829     function encodeUint(uint self) internal pure returns (bytes memory) {
1830         return encodeBytes(toBinary(self));
1831     }
1832 
1833     /** 
1834      * @dev RLP encodes an int.
1835      * @param self The int to encode.
1836      * @return The RLP encoded int in bytes.
1837      */
1838     function encodeInt(int self) internal pure returns (bytes memory) {
1839         return encodeUint(uint(self));
1840     }
1841 
1842     /** 
1843      * @dev RLP encodes a bool.
1844      * @param self The bool to encode.
1845      * @return The RLP encoded bool in bytes.
1846      */
1847     function encodeBool(bool self) internal pure returns (bytes memory) {
1848         bytes memory encoded = new bytes(1);
1849         encoded[0] = (self ? bytes1(0x01) : bytes1(0x80));
1850         return encoded;
1851     }
1852 
1853 
1854     /*
1855      * Private functions
1856      */
1857 
1858     /**
1859      * @dev Encode the first byte, followed by the `len` in binary form if `length` is more than 55.
1860      * @param len The length of the string or the payload.
1861      * @param offset 128 if item is string, 192 if item is list.
1862      * @return RLP encoded bytes.
1863      */
1864     function encodeLength(uint len, uint offset) private pure returns (bytes memory) {
1865         bytes memory encoded;
1866         if (len < 56) {
1867             encoded = new bytes(1);
1868             encoded[0] = bytes32(len + offset)[31];
1869         } else {
1870             uint lenLen;
1871             uint i = 1;
1872             while (len / i != 0) {
1873                 lenLen++;
1874                 i *= 256;
1875             }
1876 
1877             encoded = new bytes(lenLen + 1);
1878             encoded[0] = bytes32(lenLen + offset + 55)[31];
1879             for(i = 1; i <= lenLen; i++) {
1880                 encoded[i] = bytes32((len / (256**(lenLen-i))) % 256)[31];
1881             }
1882         }
1883         return encoded;
1884     }
1885 
1886     /**
1887      * @dev Encode integer in big endian binary form with no leading zeroes.
1888      * @notice TODO: This should be optimized with assembly to save gas costs.
1889      * @param _x The integer to encode.
1890      * @return RLP encoded bytes.
1891      */
1892     function toBinary(uint _x) private pure returns (bytes memory) {
1893         bytes memory b = new bytes(32);
1894         assembly { 
1895             mstore(add(b, 32), _x) 
1896         }
1897         uint i;
1898         for (i = 0; i < 32; i++) {
1899             if (b[i] != 0) {
1900                 break;
1901             }
1902         }
1903         bytes memory res = new bytes(32 - i);
1904         for (uint j = 0; j < res.length; j++) {
1905             res[j] = b[i++];
1906         }
1907         return res;
1908     }
1909 
1910     /**
1911      * @dev Copies a piece of memory to another location.
1912      * @notice From: https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol.
1913      * @param _dest Destination location.
1914      * @param _src Source location.
1915      * @param _len Length of memory to copy.
1916      */
1917     function memcpy(uint _dest, uint _src, uint _len) private pure {
1918         uint dest = _dest;
1919         uint src = _src;
1920         uint len = _len;
1921 
1922         for(; len >= 32; len -= 32) {
1923             assembly {
1924                 mstore(dest, mload(src))
1925             }
1926             dest += 32;
1927             src += 32;
1928         }
1929 
1930         uint mask = 256 ** (32 - len) - 1;
1931         assembly {
1932             let srcpart := and(mload(src), not(mask))
1933             let destpart := and(mload(dest), mask)
1934             mstore(dest, or(destpart, srcpart))
1935         }
1936     }
1937 
1938     /**
1939      * @dev Flattens a list of byte strings into one byte string.
1940      * @notice From: https://github.com/sammayo/solidity-rlp-encoder/blob/master/RLPEncode.sol.
1941      * @param _list List of byte strings to flatten.
1942      * @return The flattened byte string.
1943      */
1944     function flatten(bytes[] memory _list) private pure returns (bytes memory) {
1945         if (_list.length == 0) {
1946             return new bytes(0);
1947         }
1948 
1949         uint len;
1950         uint i;
1951         for (i = 0; i < _list.length; i++) {
1952             len += _list[i].length;
1953         }
1954 
1955         bytes memory flattened = new bytes(len);
1956         uint flattenedPtr;
1957         assembly { flattenedPtr := add(flattened, 0x20) }
1958 
1959         for(i = 0; i < _list.length; i++) {
1960             bytes memory item = _list[i];
1961             
1962             uint listPtr;
1963             assembly { listPtr := add(item, 0x20)}
1964 
1965             memcpy(flattenedPtr, listPtr, item.length);
1966             flattenedPtr += _list[i].length;
1967         }
1968 
1969         return flattened;
1970     }
1971 
1972     /**
1973      * @dev Concatenates two bytes.
1974      * @notice From: https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol.
1975      * @param _preBytes First byte string.
1976      * @param _postBytes Second byte string.
1977      * @return Both byte string combined.
1978      */
1979     function concat(bytes memory _preBytes, bytes memory _postBytes) private pure returns (bytes memory) {
1980         bytes memory tempBytes;
1981 
1982         assembly {
1983             tempBytes := mload(0x40)
1984 
1985             let length := mload(_preBytes)
1986             mstore(tempBytes, length)
1987 
1988             let mc := add(tempBytes, 0x20)
1989             let end := add(mc, length)
1990 
1991             for {
1992                 let cc := add(_preBytes, 0x20)
1993             } lt(mc, end) {
1994                 mc := add(mc, 0x20)
1995                 cc := add(cc, 0x20)
1996             } {
1997                 mstore(mc, mload(cc))
1998             }
1999 
2000             length := mload(_postBytes)
2001             mstore(tempBytes, add(length, mload(tempBytes)))
2002 
2003             mc := end
2004             end := add(mc, length)
2005 
2006             for {
2007                 let cc := add(_postBytes, 0x20)
2008             } lt(mc, end) {
2009                 mc := add(mc, 0x20)
2010                 cc := add(cc, 0x20)
2011             } {
2012                 mstore(mc, mload(cc))
2013             }
2014 
2015             mstore(0x40, and(
2016               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
2017               not(31)
2018             ))
2019         }
2020 
2021         return tempBytes;
2022     }
2023 }
2024 
2025 
2026 contract Governable is Initializable {
2027     address public governor;
2028 
2029     event GovernorshipTransferred(address indexed previousGovernor, address indexed newGovernor);
2030 
2031     /**
2032      * @dev Contract initializer.
2033      * called once by the factory at time of deployment
2034      */
2035     function __Governable_init_unchained(address governor_) virtual public initializer {
2036         governor = governor_;
2037         emit GovernorshipTransferred(address(0), governor);
2038     }
2039 
2040     modifier governance() {
2041         require(msg.sender == governor);
2042         _;
2043     }
2044 
2045     /**
2046      * @dev Allows the current governor to relinquish control of the contract.
2047      * @notice Renouncing to governorship will leave the contract without an governor.
2048      * It will not be possible to call the functions with the `governance`
2049      * modifier anymore.
2050      */
2051     function renounceGovernorship() public governance {
2052         emit GovernorshipTransferred(governor, address(0));
2053         governor = address(0);
2054     }
2055 
2056     /**
2057      * @dev Allows the current governor to transfer control of the contract to a newGovernor.
2058      * @param newGovernor The address to transfer governorship to.
2059      */
2060     function transferGovernorship(address newGovernor) public governance {
2061         _transferGovernorship(newGovernor);
2062     }
2063 
2064     /**
2065      * @dev Transfers control of the contract to a newGovernor.
2066      * @param newGovernor The address to transfer governorship to.
2067      */
2068     function _transferGovernorship(address newGovernor) internal {
2069         require(newGovernor != address(0));
2070         emit GovernorshipTransferred(governor, newGovernor);
2071         governor = newGovernor;
2072     }
2073 }
2074 
2075 
2076 contract ConfigurableBase {
2077     mapping (bytes32 => uint) internal config;
2078     
2079     function getConfig(bytes32 key) public view returns (uint) {
2080         return config[key];
2081     }
2082     function getConfigI(bytes32 key, uint index) public view returns (uint) {
2083         return config[bytes32(uint(key) ^ index)];
2084     }
2085     function getConfigA(bytes32 key, address addr) public view returns (uint) {
2086         return config[bytes32(uint(key) ^ uint(addr))];
2087     }
2088 
2089     function _setConfig(bytes32 key, uint value) internal {
2090         if(config[key] != value)
2091             config[key] = value;
2092     }
2093     function _setConfig(bytes32 key, uint index, uint value) internal {
2094         _setConfig(bytes32(uint(key) ^ index), value);
2095     }
2096     function _setConfig(bytes32 key, address addr, uint value) internal {
2097         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
2098     }
2099 }    
2100 
2101 contract Configurable is Governable, ConfigurableBase {
2102     function setConfig(bytes32 key, uint value) external governance {
2103         _setConfig(key, value);
2104     }
2105     function setConfigI(bytes32 key, uint index, uint value) external governance {
2106         _setConfig(bytes32(uint(key) ^ index), value);
2107     }
2108     function setConfigA(bytes32 key, address addr, uint value) public governance {
2109         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
2110     }
2111 }
2112 
2113 
2114 // Inheritancea
2115 interface IStakingRewards {
2116     // Views
2117     function lastTimeRewardApplicable() external view returns (uint256);
2118 
2119     function rewardPerToken() external view returns (uint256);
2120 
2121     function rewards(address account) external view returns (uint256);
2122 
2123     function earned(address account) external view returns (uint256);
2124 
2125     function getRewardForDuration() external view returns (uint256);
2126 
2127     function totalSupply() external view returns (uint256);
2128 
2129     function balanceOf(address account) external view returns (uint256);
2130 
2131     // Mutative
2132 
2133     function stake(uint256 amount) external;
2134 
2135     function withdraw(uint256 amount) external;
2136 
2137     function getReward() external;
2138 
2139     function exit() external;
2140 }
2141 
2142 abstract contract RewardsDistributionRecipient {
2143     address public rewardsDistribution;
2144 
2145     function notifyRewardAmount(uint256 reward) virtual external;
2146 
2147     modifier onlyRewardsDistribution() {
2148         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
2149         _;
2150     }
2151 }
2152 
2153 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuardUpgradeSafe {
2154     using SafeMath for uint256;
2155     using SafeERC20 for IERC20;
2156 
2157     /* ========== STATE VARIABLES ========== */
2158 
2159     IERC20 public rewardsToken;
2160     IERC20 public stakingToken;
2161     uint256 public periodFinish = 0;
2162     uint256 public rewardRate = 0;                  // obsoleted
2163     uint256 public rewardsDuration = 60 days;
2164     uint256 public lastUpdateTime;
2165     uint256 public rewardPerTokenStored;
2166 
2167     mapping(address => uint256) public userRewardPerTokenPaid;
2168     mapping(address => uint256) override public rewards;
2169 
2170     uint256 internal _totalSupply;
2171     mapping(address => uint256) internal _balances;
2172 
2173     /* ========== CONSTRUCTOR ========== */
2174 
2175     //constructor(
2176     function __StakingRewards_init(
2177         address _rewardsDistribution,
2178         address _rewardsToken,
2179         address _stakingToken
2180     ) public initializer {
2181         __ReentrancyGuard_init_unchained();
2182         __StakingRewards_init_unchained(_rewardsDistribution, _rewardsToken, _stakingToken);
2183     }
2184     
2185     function __StakingRewards_init_unchained(address _rewardsDistribution, address _rewardsToken, address _stakingToken) public initializer {
2186         rewardsToken = IERC20(_rewardsToken);
2187         stakingToken = IERC20(_stakingToken);
2188         rewardsDistribution = _rewardsDistribution;
2189     }
2190 
2191     /* ========== VIEWS ========== */
2192 
2193     function totalSupply() virtual override public view returns (uint256) {
2194         return _totalSupply;
2195     }
2196 
2197     function balanceOf(address account) virtual override public view returns (uint256) {
2198         return _balances[account];
2199     }
2200 
2201     function lastTimeRewardApplicable() override public view returns (uint256) {
2202         return Math.min(block.timestamp, periodFinish);
2203     }
2204 
2205     function rewardPerToken() virtual override public view returns (uint256) {
2206         if (_totalSupply == 0) {
2207             return rewardPerTokenStored;
2208         }
2209         return
2210             rewardPerTokenStored.add(
2211                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
2212             );
2213     }
2214 
2215     function earned(address account) virtual override public view returns (uint256) {
2216         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
2217     }
2218 
2219     function getRewardForDuration() virtual override external view returns (uint256) {
2220         return rewardRate.mul(rewardsDuration);
2221     }
2222 
2223     /* ========== MUTATIVE FUNCTIONS ========== */
2224 
2225     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) virtual public nonReentrant updateReward(msg.sender) {
2226         require(amount > 0, "Cannot stake 0");
2227         _totalSupply = _totalSupply.add(amount);
2228         _balances[msg.sender] = _balances[msg.sender].add(amount);
2229 
2230         // permit
2231         IPermit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
2232 
2233         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
2234         emit Staked(msg.sender, amount);
2235     }
2236 
2237     function stake(uint256 amount) virtual override public nonReentrant updateReward(msg.sender) {
2238         require(amount > 0, "Cannot stake 0");
2239         _totalSupply = _totalSupply.add(amount);
2240         _balances[msg.sender] = _balances[msg.sender].add(amount);
2241         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
2242         emit Staked(msg.sender, amount);
2243     }
2244 
2245     function withdraw(uint256 amount) virtual override public nonReentrant updateReward(msg.sender) {
2246         require(amount > 0, "Cannot withdraw 0");
2247         _totalSupply = _totalSupply.sub(amount);
2248         _balances[msg.sender] = _balances[msg.sender].sub(amount);
2249         stakingToken.safeTransfer(msg.sender, amount);
2250         emit Withdrawn(msg.sender, amount);
2251     }
2252 
2253     function getReward() virtual override public nonReentrant updateReward(msg.sender) {
2254         uint256 reward = rewards[msg.sender];
2255         if (reward > 0) {
2256             rewards[msg.sender] = 0;
2257             rewardsToken.safeTransfer(msg.sender, reward);
2258             emit RewardPaid(msg.sender, reward);
2259         }
2260     }
2261 
2262     function exit() virtual override public {
2263         withdraw(_balances[msg.sender]);
2264         getReward();
2265     }
2266 
2267     /* ========== RESTRICTED FUNCTIONS ========== */
2268 
2269     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
2270         if (block.timestamp >= periodFinish) {
2271             rewardRate = reward.div(rewardsDuration);
2272         } else {
2273             uint256 remaining = periodFinish.sub(block.timestamp);
2274             uint256 leftover = remaining.mul(rewardRate);
2275             rewardRate = reward.add(leftover).div(rewardsDuration);
2276         }
2277 
2278         // Ensure the provided reward amount is not more than the balance in the contract.
2279         // This keeps the reward rate in the right range, preventing overflows due to
2280         // very high values of rewardRate in the earned and rewardsPerToken functions;
2281         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
2282         uint balance = rewardsToken.balanceOf(address(this));
2283         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
2284 
2285         lastUpdateTime = block.timestamp;
2286         periodFinish = block.timestamp.add(rewardsDuration);
2287         emit RewardAdded(reward);
2288     }
2289 
2290     /* ========== MODIFIERS ========== */
2291 
2292     modifier updateReward(address account) virtual {
2293         rewardPerTokenStored = rewardPerToken();
2294         lastUpdateTime = lastTimeRewardApplicable();
2295         if (account != address(0)) {
2296             rewards[account] = earned(account);
2297             userRewardPerTokenPaid[account] = rewardPerTokenStored;
2298         }
2299         _;
2300     }
2301 
2302     /* ========== EVENTS ========== */
2303 
2304     event RewardAdded(uint256 reward);
2305     event Staked(address indexed user, uint256 amount);
2306     event Withdrawn(address indexed user, uint256 amount);
2307     event RewardPaid(address indexed user, uint256 reward);
2308 }
2309 
2310 interface IPermit {
2311     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2312 }
2313 
2314 
2315 contract Constants {
2316     bytes32 internal constant _TokenMapped_     = 'TokenMapped';
2317     bytes32 internal constant _MappableToken_   = 'MappableToken';
2318     bytes32 internal constant _MappingToken_    = 'MappingToken';
2319     bytes32 internal constant _fee_             = 'fee';
2320     bytes32 internal constant _feeCreate_       = 'feeCreate';
2321     bytes32 internal constant _feeRegister_     = 'feeRegister';
2322     bytes32 internal constant _feeTo_           = 'feeTo';
2323     bytes32 internal constant _onlyDeployer_    = 'onlyDeployer';
2324     bytes32 internal constant _minSignatures_   = 'minSignatures';
2325     bytes32 internal constant _initQuotaRatio_  = 'initQuotaRatio';
2326     bytes32 internal constant _autoQuotaRatio_  = 'autoQuotaRatio';
2327     bytes32 internal constant _autoQuotaPeriod_ = 'autoQuotaPeriod';
2328     //bytes32 internal constant _uniswapRounter_  = 'uniswapRounter';
2329     
2330     function _chainId() internal pure returns (uint id) {
2331         assembly { id := chainid() }
2332     }
2333 }
2334 
2335 struct Signature {
2336     address signatory;
2337     uint8   v;
2338     bytes32 r;
2339     bytes32 s;
2340 }
2341 
2342 abstract contract MappingBase is ContextUpgradeSafe, Constants {
2343 	using SafeMath for uint;
2344 
2345     bytes32 public constant RECEIVE_TYPEHASH = keccak256("Receive(uint256 fromChainId,address to,uint256 nonce,uint256 volume,address signatory)");
2346     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2347     bytes32 internal _DOMAIN_SEPARATOR;
2348     function DOMAIN_SEPARATOR() virtual public view returns (bytes32) {  return _DOMAIN_SEPARATOR;  }
2349 
2350     address public factory;
2351     uint256 public mainChainId;
2352     address public token;
2353     address public deployer;
2354     
2355     mapping (address => uint) internal _authQuotas;                                     // signatory => quota
2356     mapping (uint => mapping (address => uint)) public sentCount;                       // toChainId => to => sentCount
2357     mapping (uint => mapping (address => mapping (uint => uint))) public sent;          // toChainId => to => nonce => volume
2358     mapping (uint => mapping (address => mapping (uint => uint))) public received;      // fromChainId => to => nonce => volume
2359     mapping (address => uint) public lasttimeUpdateQuotaOf;                             // signatory => lasttime
2360     uint public autoQuotaRatio;
2361     uint public autoQuotaPeriod;
2362     
2363     function setAutoQuota(uint ratio, uint period) virtual external onlyFactory {
2364         autoQuotaRatio  = ratio;
2365         autoQuotaPeriod = period;
2366     }
2367     
2368     modifier onlyFactory {
2369         require(msg.sender == factory, 'Only called by Factory');
2370         _;
2371     }
2372     
2373     modifier updateAutoQuota(address signatory) virtual {
2374         uint quota = authQuotaOf(signatory);
2375         if(_authQuotas[signatory] != quota) {
2376             _authQuotas[signatory] = quota;
2377             lasttimeUpdateQuotaOf[signatory] = now;
2378         }
2379         _;
2380     }
2381     
2382     function authQuotaOf(address signatory) virtual public view returns (uint quota) {
2383         quota = _authQuotas[signatory];
2384         uint ratio  = autoQuotaRatio  != 0 ? autoQuotaRatio  : Factory(factory).getConfig(_autoQuotaRatio_);
2385         uint period = autoQuotaPeriod != 0 ? autoQuotaPeriod : Factory(factory).getConfig(_autoQuotaPeriod_);
2386         if(ratio == 0 || period == 0 || period == uint(-1))
2387             return quota;
2388         uint quotaCap = cap().mul(ratio).div(1e18);
2389         uint delta = quotaCap.mul(now.sub(lasttimeUpdateQuotaOf[signatory])).div(period);
2390         return Math.max(quota, Math.min(quotaCap, quota.add(delta)));
2391     }
2392     
2393     function cap() public view virtual returns (uint);
2394 
2395     function increaseAuthQuotas(address[] memory signatories, uint[] memory increments) virtual external returns (uint[] memory quotas) {
2396         require(signatories.length == increments.length, 'two array lenth not equal');
2397         quotas = new uint[](signatories.length);
2398         for(uint i=0; i<signatories.length; i++)
2399             quotas[i] = increaseAuthQuota(signatories[i], increments[i]);
2400     }
2401     
2402     function increaseAuthQuota(address signatory, uint increment) virtual public updateAutoQuota(signatory) onlyFactory returns (uint quota) {
2403         quota = _authQuotas[signatory].add(increment);
2404         _authQuotas[signatory] = quota;
2405         emit IncreaseAuthQuota(signatory, increment, quota);
2406     }
2407     event IncreaseAuthQuota(address indexed signatory, uint increment, uint quota);
2408     
2409     function decreaseAuthQuotas(address[] memory signatories, uint[] memory decrements) virtual external returns (uint[] memory quotas) {
2410         require(signatories.length == decrements.length, 'two array lenth not equal');
2411         quotas = new uint[](signatories.length);
2412         for(uint i=0; i<signatories.length; i++)
2413             quotas[i] = decreaseAuthQuota(signatories[i], decrements[i]);
2414     }
2415     
2416     function decreaseAuthQuota(address signatory, uint decrement) virtual public onlyFactory returns (uint quota) {
2417         quota = authQuotaOf(signatory);
2418         if(quota < decrement)
2419             decrement = quota;
2420         return _decreaseAuthQuota(signatory, decrement);
2421     }
2422     
2423     function _decreaseAuthQuota(address signatory, uint decrement) virtual internal updateAutoQuota(signatory) returns (uint quota) {
2424         quota = _authQuotas[signatory].sub(decrement);
2425         _authQuotas[signatory] = quota;
2426         emit DecreaseAuthQuota(signatory, decrement, quota);
2427     }
2428     event DecreaseAuthQuota(address indexed signatory, uint decrement, uint quota);
2429     
2430 
2431     function needApprove() virtual public pure returns (bool);
2432     
2433     function send(uint toChainId, address to, uint volume) virtual external payable returns (uint nonce) {
2434         return sendFrom(_msgSender(), toChainId, to, volume);
2435     }
2436     
2437     function sendFrom(address from, uint toChainId, address to, uint volume) virtual public payable returns (uint nonce) {
2438         _chargeFee();
2439         _sendFrom(from, volume);
2440         nonce = sentCount[toChainId][to]++;
2441         sent[toChainId][to][nonce] = volume;
2442         emit Send(from, toChainId, to, nonce, volume);
2443     }
2444     event Send(address indexed from, uint indexed toChainId, address indexed to, uint nonce, uint volume);
2445     
2446     function _sendFrom(address from, uint volume) virtual internal;
2447 
2448     function receive(uint256 fromChainId, address to, uint256 nonce, uint256 volume, Signature[] memory signatures) virtual external payable {
2449         _chargeFee();
2450         require(received[fromChainId][to][nonce] == 0, 'withdrawn already');
2451         uint N = signatures.length;
2452         require(N >= Factory(factory).getConfig(_minSignatures_), 'too few signatures');
2453         for(uint i=0; i<N; i++) {
2454             for(uint j=0; j<i; j++)
2455                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2456             bytes32 structHash = keccak256(abi.encode(RECEIVE_TYPEHASH, fromChainId, to, nonce, volume, signatures[i].signatory));
2457             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", _DOMAIN_SEPARATOR, structHash));
2458             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
2459             require(signatory != address(0), "invalid signature");
2460             require(signatory == signatures[i].signatory, "unauthorized");
2461             _decreaseAuthQuota(signatures[i].signatory, volume);
2462             emit Authorize(fromChainId, to, nonce, volume, signatory);
2463         }
2464         received[fromChainId][to][nonce] = volume;
2465         _receive(to, volume);
2466         emit Receive(fromChainId, to, nonce, volume);
2467     }
2468     event Receive(uint256 indexed fromChainId, address indexed to, uint256 indexed nonce, uint256 volume);
2469     event Authorize(uint256 fromChainId, address indexed to, uint256 indexed nonce, uint256 volume, address indexed signatory);
2470     
2471     function _receive(address to, uint256 volume) virtual internal;
2472     
2473     function _chargeFee() virtual internal {
2474         require(msg.value >= Math.min(Factory(factory).getConfig(_fee_), 0.1 ether), 'fee is too low');
2475         address payable feeTo = address(Factory(factory).getConfig(_feeTo_));
2476         if(feeTo == address(0))
2477             feeTo = address(uint160(factory));
2478         feeTo.transfer(msg.value);
2479         emit ChargeFee(_msgSender(), feeTo, msg.value);
2480     }
2481     event ChargeFee(address indexed from, address indexed to, uint value);
2482 
2483     uint256[47] private __gap;
2484 }    
2485     
2486     
2487 contract TokenMapped is MappingBase {
2488     using SafeERC20 for IERC20;
2489     
2490 	function __TokenMapped_init(address factory_, address token_) external initializer {
2491         __Context_init_unchained();
2492 		__TokenMapped_init_unchained(factory_, token_);
2493 	}
2494 	
2495 	function __TokenMapped_init_unchained(address factory_, address token_) public initializer {
2496         factory = factory_;
2497         mainChainId = _chainId();
2498         token = token_;
2499         deployer = address(0);
2500         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(ERC20UpgradeSafe(token).name())), _chainId(), address(this)));
2501 	}
2502 	
2503     function cap() virtual override public view returns (uint) {
2504         return IERC20(token).totalSupply();
2505     }
2506     
2507     function totalMapped() virtual public view returns (uint) {
2508         return IERC20(token).balanceOf(address(this));
2509     }
2510     
2511     function needApprove() virtual override public pure returns (bool) {
2512         return true;
2513     }
2514     
2515     function _sendFrom(address from, uint volume) virtual override internal {
2516         IERC20(token).safeTransferFrom(from, address(this), volume);
2517     }
2518 
2519     function _receive(address to, uint256 volume) virtual override internal {
2520         IERC20(token).safeTransfer(to, volume);
2521     }
2522 
2523     uint256[50] private __gap;
2524 }
2525 /*
2526 contract TokenMapped2 is TokenMapped, StakingRewards, ConfigurableBase {
2527     modifier governance {
2528         require(_msgSender() == MappingTokenFactory(factory).governor());
2529         _;
2530     }
2531     
2532     function setConfig(bytes32 key, uint value) external governance {
2533         _setConfig(key, value);
2534     }
2535     function setConfigI(bytes32 key, uint index, uint value) external governance {
2536         _setConfig(bytes32(uint(key) ^ index), value);
2537     }
2538     function setConfigA(bytes32 key, address addr, uint value) public governance {
2539         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
2540     }
2541 
2542     function rewardDelta() public view returns (uint amt) {
2543         if(begin == 0 || begin >= now || lastUpdateTime >= now)
2544             return 0;
2545             
2546         amt = rewardsToken.allowance(rewardsDistribution, address(this)).sub0(rewards[address(0)]);
2547         
2548         // calc rewardDelta in period
2549         if(lep == 3) {                                                              // power
2550             uint y = period.mul(1 ether).div(lastUpdateTime.add(rewardsDuration).sub(begin));
2551             uint amt1 = amt.mul(1 ether).div(y);
2552             uint amt2 = amt1.mul(period).div(now.add(rewardsDuration).sub(begin));
2553             amt = amt.sub(amt2);
2554         } else if(lep == 2) {                                                       // exponential
2555             if(now.sub(lastUpdateTime) < rewardsDuration)
2556                 amt = amt.mul(now.sub(lastUpdateTime)).div(rewardsDuration);
2557         }else if(now < periodFinish)                                                // linear
2558             amt = amt.mul(now.sub(lastUpdateTime)).div(periodFinish.sub(lastUpdateTime));
2559         else if(lastUpdateTime >= periodFinish)
2560             amt = 0;
2561     }
2562     
2563     function rewardPerToken() virtual override public view returns (uint256) {
2564         if (_totalSupply == 0) {
2565             return rewardPerTokenStored;
2566         }
2567         return
2568             rewardPerTokenStored.add(
2569                 rewardDelta().mul(1e18).div(_totalSupply)
2570             );
2571     }
2572 
2573     modifier updateReward(address account) virtual override {
2574         (uint delta, uint d) = (rewardDelta(), 0);
2575         rewardPerTokenStored = rewardPerToken();
2576         lastUpdateTime = now;
2577         if (account != address(0)) {
2578             rewards[account] = earned(account);
2579             userRewardPerTokenPaid[account] = rewardPerTokenStored;
2580         }
2581 
2582         address addr = address(config[_ecoAddr_]);
2583         uint ratio = config[_ecoRatio_];
2584         if(addr != address(0) && ratio != 0) {
2585             d = delta.mul(ratio).div(1 ether);
2586             rewards[addr] = rewards[addr].add(d);
2587         }
2588         rewards[address(0)] = rewards[address(0)].add(delta).add(d);
2589         _;
2590     }
2591 
2592     function getReward() virtual override public {
2593         getReward(msg.sender);
2594     }
2595     function getReward(address payable acct) virtual public nonReentrant updateReward(acct) {
2596         require(acct != address(0), 'invalid address');
2597         require(getConfig(_blocklist_, acct) == 0, 'In blocklist');
2598         bool isContract = acct.isContract();
2599         require(!isContract || config[_allowContract_] != 0 || getConfig(_allowlist_, acct) != 0, 'No allowContract');
2600 
2601         uint256 reward = rewards[acct];
2602         if (reward > 0) {
2603             paid[acct] = paid[acct].add(reward);
2604             paid[address(0)] = paid[address(0)].add(reward);
2605             rewards[acct] = 0;
2606             rewards[address(0)] = rewards[address(0)].sub0(reward);
2607             rewardsToken.safeTransferFrom(rewardsDistribution, acct, reward);
2608             emit RewardPaid(acct, reward);
2609         }
2610     }
2611 
2612     function getRewardForDuration() override external view returns (uint256) {
2613         return rewardsToken.allowance(rewardsDistribution, address(this)).sub0(rewards[address(0)]);
2614     }
2615     
2616 }
2617 */
2618 
2619 abstract contract Permit {
2620     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
2621     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
2622     function DOMAIN_SEPARATOR() virtual public view returns (bytes32);
2623 
2624     mapping (address => uint) public nonces;
2625 
2626     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
2627         require(deadline >= block.timestamp, 'permit EXPIRED');
2628         bytes32 digest = keccak256(
2629             abi.encodePacked(
2630                 '\x19\x01',
2631                 DOMAIN_SEPARATOR(),
2632                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
2633             )
2634         );
2635         address recoveredAddress = ecrecover(digest, v, r, s);
2636         require(recoveredAddress != address(0) && recoveredAddress == owner, 'permit INVALID_SIGNATURE');
2637         _approve(owner, spender, value);
2638     }
2639 
2640     function _approve(address owner, address spender, uint256 amount) internal virtual;    
2641 
2642     uint256[50] private __gap;
2643 }
2644 
2645 contract MappableToken is Permit, ERC20UpgradeSafe, MappingBase {
2646 	function __MappableToken_init(address factory_, address deployer_, string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) external initializer {
2647         __Context_init_unchained();
2648 		__ERC20_init_unchained(name_, symbol_);
2649 		_setupDecimals(decimals_);
2650 		_mint(deployer_, totalSupply_);
2651 		__MappableToken_init_unchained(factory_, deployer_);
2652 	}
2653 	
2654 	function __MappableToken_init_unchained(address factory_, address deployer_) public initializer {
2655         factory = factory_;
2656         mainChainId = _chainId();
2657         token = address(0);
2658         deployer = deployer_;
2659         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
2660 	}
2661 	
2662     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
2663         return MappingBase.DOMAIN_SEPARATOR();
2664     }
2665     
2666     function cap() virtual override public view returns (uint) {
2667         return totalSupply();
2668     }
2669     
2670     function totalMapped() virtual public view returns (uint) {
2671         return balanceOf(address(this));
2672     }
2673     
2674     function needApprove() virtual override public pure returns (bool) {
2675         return false;
2676     }
2677     
2678     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
2679         return ERC20UpgradeSafe._approve(owner, spender, amount);
2680     }
2681     
2682     function _sendFrom(address from, uint volume) virtual override internal {
2683         transferFrom(from, address(this), volume);
2684     }
2685 
2686     function _receive(address to, uint256 volume) virtual override internal {
2687         _transfer(address(this), to, volume);
2688     }
2689 
2690     uint256[50] private __gap;
2691 }
2692 
2693 
2694 contract MappingToken is Permit, ERC20CappedUpgradeSafe, MappingBase {
2695 	function __MappingToken_init(address factory_, uint mainChainId_, address token_, address deployer_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) external initializer {
2696         __Context_init_unchained();
2697 		__ERC20_init_unchained(name_, symbol_);
2698 		_setupDecimals(decimals_);
2699 		__ERC20Capped_init_unchained(cap_);
2700 		__MappingToken_init_unchained(factory_, mainChainId_, token_, deployer_);
2701 	}
2702 	
2703 	function __MappingToken_init_unchained(address factory_, uint mainChainId_, address token_, address deployer_) public initializer {
2704         factory = factory_;
2705         mainChainId = mainChainId_;
2706         token = token_;
2707         deployer = (token_ == address(0)) ? deployer_ : address(0);
2708         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
2709 	}
2710 	
2711     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
2712         return MappingBase.DOMAIN_SEPARATOR();
2713     }
2714     
2715     function cap() virtual override(ERC20CappedUpgradeSafe, MappingBase) public view returns (uint) {
2716         return ERC20CappedUpgradeSafe.cap();
2717     }
2718     
2719     //function setCap(uint cap_) external {
2720     //    require(_msgSender() == Factory(factory).governor());
2721     //    _cap = cap_;
2722     //}
2723     
2724     function needApprove() virtual override public pure returns (bool) {
2725         return false;
2726     }
2727     
2728     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
2729         return ERC20UpgradeSafe._approve(owner, spender, amount);
2730     }
2731     
2732     function _sendFrom(address from, uint volume) virtual override internal {
2733         _burn(from, volume);
2734         if(from != _msgSender() && allowance(from, _msgSender()) != uint(-1))
2735             _approve(from, _msgSender(), allowance(from, _msgSender()).sub(volume, "ERC20: transfer volume exceeds allowance"));
2736     }
2737 
2738     function _receive(address to, uint256 volume) virtual override internal {
2739         _mint(to, volume);
2740     }
2741 
2742     uint256[50] private __gap;
2743 }
2744 
2745 
2746 contract MappingTokenProxy is ProductProxy, Constants {
2747     constructor(address factory_, uint mainChainId_, address token_, address deployer_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) public {
2748         //require(_factory() == address(0));
2749         assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
2750         assert(NAME_SLOT    == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
2751         _setFactory(factory_);
2752         _setName(_MappingToken_);
2753         (bool success,) = _implementation().delegatecall(abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', factory_, mainChainId_, token_, deployer_, name_, symbol_, decimals_, cap_));
2754         require(success);
2755     }  
2756 }
2757 
2758 
2759 contract Factory is ContextUpgradeSafe, Configurable, Constants {
2760     using SafeERC20 for IERC20;
2761     using SafeMath for uint;
2762 
2763     bytes32 public constant REGISTER_TYPEHASH   = keccak256("RegisterMapping(uint mainChainId,address token,uint[] chainIds,address[] mappingTokenMappeds,address signatory)");
2764     bytes32 public constant CREATE_TYPEHASH     = keccak256("CreateMappingToken(address deployer,uint mainChainId,address token,string name,string symbol,uint8 decimals,uint cap,address signatory)");
2765     bytes32 public constant DOMAIN_TYPEHASH     = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2766     bytes32 public DOMAIN_SEPARATOR;
2767 
2768     mapping (bytes32 => address) public productImplementations;
2769     mapping (address => address) public tokenMappeds;                // token => tokenMapped
2770     mapping (address => address) public mappableTokens;              // deployer => mappableTokens
2771     mapping (uint256 => mapping (address => address)) public mappingTokens;     // mainChainId => token or deployer => mappableTokens
2772     mapping (address => bool) public authorties;
2773     
2774     // only on ethereum mainnet
2775     mapping (address => uint) public authCountOf;                   // signatory => count
2776     mapping (address => uint256) internal _mainChainIdTokens;       // mappingToken => mainChainId+token
2777     mapping (address => mapping (uint => address)) public mappingTokenMappeds;  // token => chainId => mappingToken or tokenMapped
2778     uint[] public supportChainIds;
2779     mapping (string  => uint256) internal _certifiedTokens;         // symbol => mainChainId+token
2780     string[] public certifiedSymbols;
2781     address[] public signatories;
2782 
2783     function __MappingTokenFactory_init(address _governor, address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) external initializer {
2784         __Governable_init_unchained(_governor);
2785         __MappingTokenFactory_init_unchained(_implTokenMapped, _implMappableToken, _implMappingToken, _feeTo);
2786     }
2787     
2788     function __MappingTokenFactory_init_unchained(address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) public governance {
2789         config[_fee_]                           = 0.005 ether;
2790         config[_feeCreate_]                     = 0.100 ether;
2791         config[_feeRegister_]                   = 0.200 ether;
2792         config[_feeTo_]                         = uint(_feeTo);
2793         config[_onlyDeployer_]                  = 1;
2794         config[_minSignatures_]                 = 3;
2795         config[_initQuotaRatio_]                = 0.100 ether;  // 10%
2796         config[_autoQuotaRatio_]                = 0.010 ether;  //  1%
2797         config[_autoQuotaPeriod_]               = 1 days;
2798         //config[_uniswapRounter_]                = uint(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
2799 
2800         DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes('MappingTokenFactory')), _chainId(), address(this)));
2801         upgradeProductImplementationsTo_(_implTokenMapped, _implMappableToken, _implMappingToken);
2802         emit ProductProxyCodeHash(keccak256(type(InitializableProductProxy).creationCode));
2803     }
2804     event ProductProxyCodeHash(bytes32 codeHash);
2805 
2806     function upgradeProductImplementationsTo_(address _implTokenMapped, address _implMappableToken, address _implMappingToken) public governance {
2807         productImplementations[_TokenMapped_]   = _implTokenMapped;
2808         productImplementations[_MappableToken_] = _implMappableToken;
2809         productImplementations[_MappingToken_]  = _implMappingToken;
2810     }
2811     
2812     function setSignatories(address[] calldata signatories_) virtual external governance {
2813         signatories = signatories_;
2814         emit SetSignatories(signatories_);
2815     }
2816     event SetSignatories(address[] signatories_);
2817     
2818     function setAuthorty_(address authorty, bool enable) virtual external governance {
2819         authorties[authorty] = enable;
2820         emit SetAuthorty(authorty, enable);
2821     }
2822     event SetAuthorty(address indexed authorty, bool indexed enable);
2823     
2824     function setAutoQuota(address mappingTokenMapped, uint ratio, uint period) virtual external governance {
2825         if(mappingTokenMapped == address(0)) {
2826             config[_autoQuotaRatio_]  = ratio;
2827             config[_autoQuotaPeriod_] = period;
2828         } else
2829             MappingBase(mappingTokenMapped).setAutoQuota(ratio, period);
2830     }
2831     
2832     modifier onlyAuthorty {
2833         require(authorties[_msgSender()], 'only authorty');
2834         _;
2835     }
2836     
2837     function _initAuthQuotas(address mappingTokenMapped, uint cap) internal {
2838         uint quota = cap.mul(config[_initQuotaRatio_]).div(1e18);
2839         uint[] memory quotas = new uint[](signatories.length);
2840         for(uint i=0; i<quotas.length; i++)
2841             quotas[i] = quota;
2842         _increaseAuthQuotas(mappingTokenMapped, signatories, quotas);
2843     }
2844     
2845     function _increaseAuthQuotas(address mappingTokenMapped, address[] memory signatories_, uint[] memory increments) virtual internal returns (uint[] memory quotas) {
2846         quotas = MappingBase(mappingTokenMapped).increaseAuthQuotas(signatories_, increments);
2847         for(uint i=0; i<signatories_.length; i++)
2848             emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatories_[i], increments[i], quotas[i]);
2849     }
2850     function increaseAuthQuotas_(address mappingTokenMapped, uint[] memory increments) virtual external onlyAuthorty returns (uint[] memory quotas) {
2851         return _increaseAuthQuotas(mappingTokenMapped, signatories, increments);
2852     }
2853     function increaseAuthQuotas(address mappingTokenMapped, address[] memory signatories_, uint[] memory increments) virtual external onlyAuthorty returns (uint[] memory quotas) {
2854         return _increaseAuthQuotas(mappingTokenMapped, signatories_, increments);
2855     }
2856     
2857     function increaseAuthQuota(address mappingTokenMapped, address signatory, uint increment) virtual external onlyAuthorty returns (uint quota) {
2858         quota = MappingBase(mappingTokenMapped).increaseAuthQuota(signatory, increment);
2859         emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, increment, quota);
2860     }
2861     event IncreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint increment, uint quota);
2862     
2863     function decreaseAuthQuotas_(address mappingTokenMapped, uint[] memory decrements) virtual external returns (uint[] memory quotas) {
2864         return decreaseAuthQuotas(mappingTokenMapped, signatories, decrements);
2865     }
2866     function decreaseAuthQuotas(address mappingTokenMapped, address[] memory signatories_, uint[] memory decrements) virtual public onlyAuthorty returns (uint[] memory quotas) {
2867         quotas = MappingBase(mappingTokenMapped).decreaseAuthQuotas(signatories_, decrements);
2868         for(uint i=0; i<signatories_.length; i++)
2869             emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatories_[i], decrements[i], quotas[i]);
2870     }
2871     
2872     function decreaseAuthQuota(address mappingTokenMapped, address signatory, uint decrement) virtual external onlyAuthorty returns (uint quota) {
2873         quota = MappingBase(mappingTokenMapped).decreaseAuthQuota(signatory, decrement);
2874         emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, decrement, quota);
2875     }
2876     event DecreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint decrement, uint quota);
2877 
2878     function increaseAuthCounts_(uint[] memory increments) virtual external returns (uint[] memory counts) {
2879         return increaseAuthCounts(signatories, increments);
2880     }
2881     function increaseAuthCounts(address[] memory signatories_, uint[] memory increments) virtual public returns (uint[] memory counts) {
2882         require(signatories_.length == increments.length, 'two array lenth not equal');
2883         counts = new uint[](signatories_.length);
2884         for(uint i=0; i<signatories_.length; i++)
2885             counts[i] = increaseAuthCount(signatories_[i], increments[i]);
2886     }
2887     
2888     function increaseAuthCount(address signatory, uint increment) virtual public onlyAuthorty returns (uint count) {
2889         count = authCountOf[signatory].add(increment);
2890         authCountOf[signatory] = count;
2891         emit IncreaseAuthQuota(_msgSender(), signatory, increment, count);
2892     }
2893     event IncreaseAuthQuota(address indexed authorty, address indexed signatory, uint increment, uint quota);
2894     
2895     function decreaseAuthCounts_(uint[] memory decrements) virtual external returns (uint[] memory counts) {
2896         return decreaseAuthCounts(signatories, decrements);
2897     }
2898     function decreaseAuthCounts(address[] memory signatories_, uint[] memory decrements) virtual public returns (uint[] memory counts) {
2899         require(signatories_.length == decrements.length, 'two array lenth not equal');
2900         counts = new uint[](signatories_.length);
2901         for(uint i=0; i<signatories_.length; i++)
2902             counts[i] = decreaseAuthCount(signatories_[i], decrements[i]);
2903     }
2904     
2905     function decreaseAuthCount(address signatory, uint decrement) virtual public onlyAuthorty returns (uint count) {
2906         count = authCountOf[signatory];
2907         if(count < decrement)
2908             decrement = count;
2909         return _decreaseAuthCount(signatory, decrement);
2910     }
2911     
2912     function _decreaseAuthCount(address signatory, uint decrement) virtual internal returns (uint count) {
2913         count = authCountOf[signatory].sub(decrement);
2914         authCountOf[signatory] = count;
2915         emit DecreaseAuthCount(_msgSender(), signatory, decrement, count);
2916     }
2917     event DecreaseAuthCount(address indexed authorty, address indexed signatory, uint decrement, uint count);
2918 
2919     function supportChainCount() public view returns (uint) {
2920         return supportChainIds.length;
2921     }
2922     
2923     function mainChainIdTokens(address mappingToken) virtual public view returns(uint mainChainId, address token) {
2924         uint256 chainIdToken = _mainChainIdTokens[mappingToken];
2925         mainChainId = chainIdToken >> 160;
2926         token = address(chainIdToken);
2927     }
2928     
2929     function chainIdMappingTokenMappeds(address tokenOrMappingToken) virtual external view returns (uint[] memory chainIds, address[] memory mappingTokenMappeds_) {
2930         (, address token) = mainChainIdTokens(tokenOrMappingToken);
2931         if(token == address(0))
2932             token = tokenOrMappingToken;
2933         uint N = 0;
2934         for(uint i=0; i<supportChainCount(); i++)
2935             if(mappingTokenMappeds[token][supportChainIds[i]] != address(0))
2936                 N++;
2937         chainIds = new uint[](N);
2938         mappingTokenMappeds_ = new address[](N);
2939         uint j = 0;
2940         for(uint i=0; i<supportChainCount(); i++) {
2941             uint chainId = supportChainIds[i];
2942             address mappingTokenMapped = mappingTokenMappeds[token][chainId];
2943             if(mappingTokenMapped != address(0)) {
2944                 chainIds[j] = chainId;
2945                 mappingTokenMappeds_[j] = mappingTokenMapped;
2946                 j++;
2947             }
2948         }
2949     }
2950     
2951     function isSupportChainId(uint chainId) virtual public view returns (bool) {
2952         for(uint i=0; i<supportChainCount(); i++)
2953             if(supportChainIds[i] == chainId)
2954                 return true;
2955         return false;
2956     }
2957     
2958     function registerSupportChainId_(uint chainId_) virtual external governance {
2959         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2960         require(!isSupportChainId(chainId_), 'support chainId already');
2961         supportChainIds.push(chainId_);
2962     }
2963     
2964     function _registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual internal {
2965         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2966         require(chainIds.length == mappingTokenMappeds_.length, 'two array lenth not equal');
2967         require(isSupportChainId(mainChainId), 'Not support mainChainId');
2968         for(uint i=0; i<chainIds.length; i++) {
2969             require(isSupportChainId(chainIds[i]), 'Not support chainId');
2970             require(token == mappingTokenMappeds_[i] || mappingTokenMappeds_[i] == calcMapping(mainChainId, token) || _msgSender() == governor, 'invalid mappingTokenMapped address');
2971             //require(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0 || _mainChainIdTokens[mappingTokenMappeds_[i]] == (mainChainId << 160) | uint(token), 'mainChainIdTokens exist already');
2972             //require(mappingTokenMappeds[token][chainIds[i]] == address(0), 'mappingTokenMappeds exist already');
2973             //if(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0)
2974                 _mainChainIdTokens[mappingTokenMappeds_[i]] = (mainChainId << 160) | uint(token);
2975             mappingTokenMappeds[token][chainIds[i]] = mappingTokenMappeds_[i];
2976             emit RegisterMapping(mainChainId, token, chainIds[i], mappingTokenMappeds_[i]);
2977         }
2978     }
2979     event RegisterMapping(uint mainChainId, address token, uint chainId, address mappingTokenMapped);
2980     
2981     function registerMapping_(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual external governance {
2982         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
2983     }
2984     
2985     function registerMapping(uint mainChainId, address token, uint nonce, uint[] memory chainIds, address[] memory mappingTokenMappeds_, Signature[] memory signatures) virtual external payable {
2986         _chargeFee(config[_feeRegister_]);
2987         require(config[_onlyDeployer_] == 0 || token == calcContract(_msgSender(), nonce), 'only deployer');
2988         uint N = signatures.length;
2989         require(N >= getConfig(_minSignatures_), 'too few signatures');
2990         for(uint i=0; i<N; i++) {
2991             for(uint j=0; j<i; j++)
2992                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2993             bytes32 structHash = keccak256(abi.encode(REGISTER_TYPEHASH, mainChainId, token, keccak256(abi.encodePacked(chainIds)), keccak256(abi.encodePacked(mappingTokenMappeds_)), signatures[i].signatory));
2994             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
2995             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
2996             require(signatory != address(0), "invalid signature");
2997             require(signatory == signatures[i].signatory, "unauthorized");
2998             _decreaseAuthCount(signatures[i].signatory, 1);
2999             emit AuthorizeRegister(mainChainId, token, signatory);
3000         }
3001         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
3002     }
3003     event AuthorizeRegister(uint indexed mainChainId, address indexed token, address indexed signatory);
3004 
3005     function certifiedCount() external view returns (uint) {
3006         return certifiedSymbols.length;
3007     }
3008     
3009     function certifiedTokens(string memory symbol) public view returns (uint mainChainId, address token) {
3010         uint256 chainIdToken = _certifiedTokens[symbol];
3011         mainChainId = chainIdToken >> 160;
3012         token = address(chainIdToken);
3013     }
3014     
3015     function allCertifiedTokens() external view returns (string[] memory symbols, uint[] memory chainIds, address[] memory tokens) {
3016         symbols = certifiedSymbols;
3017         uint N = certifiedSymbols.length;
3018         chainIds = new uint[](N);
3019         tokens = new address[](N);
3020         for(uint i=0; i<N; i++)
3021             (chainIds[i], tokens[i]) = certifiedTokens(certifiedSymbols[i]);
3022     }
3023 
3024     function registerCertified_(string memory symbol, uint mainChainId, address token) external governance {
3025         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
3026         require(isSupportChainId(mainChainId), 'Not support mainChainId');
3027         require(_certifiedTokens[symbol] == 0, 'Certified added already');
3028         if(mainChainId == _chainId())
3029             require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
3030         _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
3031         certifiedSymbols.push(symbol);
3032         emit RegisterCertified(symbol, mainChainId, token);
3033     }
3034     event RegisterCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
3035     
3036     //function updateCertified_(string memory symbol, uint mainChainId, address token) external governance {
3037     //    require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
3038     //    require(isSupportChainId(mainChainId), 'Not support mainChainId');
3039     //    //require(_certifiedTokens[symbol] == 0, 'Certified added already');
3040     //    if(mainChainId == _chainId())
3041     //        require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
3042     //    _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
3043     //    //certifiedSymbols.push(symbol);
3044     //    emit UpdateCertified(symbol, mainChainId, token);
3045     //}
3046     //event UpdateCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
3047     
3048     function calcContract(address deployer, uint nonce) public pure returns (address) {
3049         bytes[] memory list = new bytes[](2);
3050         list[0] = RLPEncode.encodeAddress(deployer);
3051         list[1] = RLPEncode.encodeUint(nonce);
3052         return address(uint(keccak256(RLPEncode.encodeList(list))));
3053     }
3054     
3055     // calculates the CREATE2 address for a pair without making any external calls
3056     function calcMapping(uint mainChainId, address tokenOrdeployer) public view returns (address) {
3057         return address(uint(keccak256(abi.encodePacked(
3058                 hex'ff',
3059                 address(this),
3060                 keccak256(abi.encodePacked(mainChainId, tokenOrdeployer)),
3061 				keccak256(type(InitializableProductProxy).creationCode)                    //hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
3062             ))));
3063     }
3064 
3065     function createTokenMapped(address token, uint nonce) external payable returns (address tokenMapped) {
3066         if(_msgSender() != governor) {
3067             _chargeFee(config[_feeCreate_]);
3068             require(config[_onlyDeployer_] == 0 || token == calcContract(_msgSender(), nonce), 'only deployer');
3069         }
3070         require(tokenMappeds[token] == address(0), 'TokenMapped created already');
3071 
3072         bytes32 salt = keccak256(abi.encodePacked(_chainId(), token));
3073 
3074         bytes memory bytecode = type(InitializableProductProxy).creationCode;
3075         assembly {
3076             tokenMapped := create2(0, add(bytecode, 32), mload(bytecode), salt)
3077         }
3078         InitializableProductProxy(payable(tokenMapped)).__InitializableProductProxy_init(address(this), _TokenMapped_, abi.encodeWithSignature('__TokenMapped_init(address,address)', address(this), token));
3079         
3080         tokenMappeds[token] = tokenMapped;
3081         _initAuthQuotas(tokenMapped, IERC20(token).totalSupply());
3082         emit CreateTokenMapped(_msgSender(), token, tokenMapped);
3083     }
3084     event CreateTokenMapped(address indexed deployer, address indexed token, address indexed tokenMapped);
3085     
3086     function createMappableToken(string memory name, string memory symbol, uint8 decimals, uint totalSupply) external payable returns (address mappableToken) {
3087         if(_msgSender() != governor)
3088             _chargeFee(config[_feeCreate_]);
3089         require(mappableTokens[_msgSender()] == address(0), 'MappableToken created already');
3090 
3091         bytes32 salt = keccak256(abi.encodePacked(_chainId(), _msgSender()));
3092 
3093         bytes memory bytecode = type(InitializableProductProxy).creationCode;
3094         assembly {
3095             mappableToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
3096         }
3097         InitializableProductProxy(payable(mappableToken)).__InitializableProductProxy_init(address(this), _MappableToken_, abi.encodeWithSignature('__MappableToken_init(address,address,string,string,uint8,uint256)', address(this), _msgSender(), name, symbol, decimals, totalSupply));
3098         
3099         mappableTokens[_msgSender()] = mappableToken;
3100         _initAuthQuotas(mappableToken, totalSupply);
3101         emit CreateMappableToken(_msgSender(), name, symbol, decimals, totalSupply, mappableToken);
3102     }
3103     event CreateMappableToken(address indexed deployer, string name, string symbol, uint8 decimals, uint totalSupply, address indexed mappableToken);
3104     
3105     function _createMappingToken(uint mainChainId, address token, address deployer, string memory name, string memory symbol, uint8 decimals, uint cap) internal returns (address mappingToken) {
3106         address tokenOrdeployer = (token == address(0)) ? deployer : token;
3107         require(mappingTokens[mainChainId][tokenOrdeployer] == address(0), 'MappingToken created already');
3108 
3109         bytes32 salt = keccak256(abi.encodePacked(mainChainId, tokenOrdeployer));
3110 
3111         bytes memory bytecode = type(InitializableProductProxy).creationCode;
3112         assembly {
3113             mappingToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
3114         }
3115         InitializableProductProxy(payable(mappingToken)).__InitializableProductProxy_init(address(this), _MappingToken_, abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', address(this), mainChainId, token, deployer, name, symbol, decimals, cap));
3116         
3117         mappingTokens[mainChainId][tokenOrdeployer] = mappingToken;
3118         _initAuthQuotas(mappingToken, cap);
3119         emit CreateMappingToken(mainChainId, token, deployer, name, symbol, decimals, cap, mappingToken);
3120     }
3121     event CreateMappingToken(uint mainChainId, address indexed token, address indexed deployer, string name, string symbol, uint8 decimals, uint cap, address indexed mappingToken);
3122     
3123     function createMappingToken_(uint mainChainId, address token, address deployer, string memory name, string memory symbol, uint8 decimals, uint cap) public payable governance returns (address mappingToken) {
3124         return _createMappingToken(mainChainId, token, deployer, name, symbol, decimals, cap);
3125     }
3126     
3127     function createMappingToken(uint mainChainId, address token, uint nonce, string memory name, string memory symbol, uint8 decimals, uint cap, Signature[] memory signatures) public payable returns (address mappingToken) {
3128         _chargeFee(config[_feeCreate_]);
3129         require(token == address(0) || config[_onlyDeployer_] == 0 || token == calcContract(_msgSender(), nonce), 'only deployer');
3130         require(signatures.length >= config[_minSignatures_], 'too few signatures');
3131         for(uint i=0; i<signatures.length; i++) {
3132             for(uint j=0; j<i; j++)
3133                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
3134             bytes32 hash = keccak256(abi.encode(CREATE_TYPEHASH, _msgSender(), mainChainId, token, keccak256(bytes(name)), keccak256(bytes(symbol)), decimals, cap, signatures[i].signatory));
3135             hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash));
3136             address signatory = ecrecover(hash, signatures[i].v, signatures[i].r, signatures[i].s);
3137             require(signatory != address(0), "invalid signature");
3138             require(signatory == signatures[i].signatory, "unauthorized");
3139             _decreaseAuthCount(signatures[i].signatory, 1);
3140             emit AuthorizeCreate(mainChainId, token, _msgSender(), name, symbol, decimals, cap, signatory);
3141         }
3142         return _createMappingToken(mainChainId, token, _msgSender(), name, symbol, decimals, cap);
3143     }
3144     event AuthorizeCreate(uint mainChainId, address indexed token, address indexed deployer, string name, string symbol, uint8 decimals, uint cap, address indexed signatory);
3145     
3146     function _chargeFee(uint fee) virtual internal {
3147         require(msg.value >= Math.min(fee, 1 ether), 'fee is too low');
3148         address payable feeTo = address(config[_feeTo_]);
3149         if(feeTo == address(0))
3150             feeTo = address(uint160(address(this)));
3151         feeTo.transfer(msg.value);
3152         emit ChargeFee(_msgSender(), feeTo, msg.value);
3153     }
3154     event ChargeFee(address indexed from, address indexed to, uint value);
3155 
3156     uint256[49] private __gap;
3157 }