1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title Proxy
6  * @dev Implements delegation of calls to other contracts, with proper
7  * forwarding of return values and bubbling of failures.
8  * It defines a fallback function that delegates all calls to the address
9  * returned by the abstract _implementation() internal function.
10  */
11 abstract contract Proxy {
12   /**
13    * @dev Fallback function.
14    * Implemented entirely in `_fallback`.
15    */
16   fallback () payable external {
17     _fallback();
18   }
19   
20   receive () payable external {
21     _fallback();
22   }
23 
24   /**
25    * @return The Address of the implementation.
26    */
27   function _implementation() virtual internal view returns (address);
28 
29   /**
30    * @dev Delegates execution to an implementation contract.
31    * This is a low level function that doesn't return to its internal call site.
32    * It will return to the external caller whatever the implementation returns.
33    * @param implementation Address to delegate.
34    */
35   function _delegate(address implementation) internal {
36     assembly {
37       // Copy msg.data. We take full control of memory in this inline assembly
38       // block because it will not return to Solidity code. We overwrite the
39       // Solidity scratch pad at memory position 0.
40       calldatacopy(0, 0, calldatasize())
41 
42       // Call the implementation.
43       // out and outsize are 0 because we don't know the size yet.
44       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
45 
46       // Copy the returned data.
47       returndatacopy(0, 0, returndatasize())
48 
49       switch result
50       // delegatecall returns 0 on error.
51       case 0 { revert(0, returndatasize()) }
52       default { return(0, returndatasize()) }
53     }
54   }
55 
56   /**
57    * @dev Function that is run as the first thing in the fallback function.
58    * Can be redefined in derived contracts to add functionality.
59    * Redefinitions must call super._willFallback().
60    */
61   function _willFallback() virtual internal {
62       
63   }
64 
65   /**
66    * @dev fallback implementation.
67    * Extracted to enable manual triggering.
68    */
69   function _fallback() internal {
70     if(OpenZeppelinUpgradesAddress.isContract(msg.sender) && msg.data.length == 0 && gasleft() <= 2300)         // for receive ETH only from other contract
71         return;
72     _willFallback();
73     _delegate(_implementation());
74   }
75 }
76 
77 
78 /**
79  * @title BaseUpgradeabilityProxy
80  * @dev This contract implements a proxy that allows to change the
81  * implementation address to which it will delegate.
82  * Such a change is called an implementation upgrade.
83  */
84 abstract contract BaseUpgradeabilityProxy is Proxy {
85   /**
86    * @dev Emitted when the implementation is upgraded.
87    * @param implementation Address of the new implementation.
88    */
89   event Upgraded(address indexed implementation);
90 
91   /**
92    * @dev Storage slot with the address of the current implementation.
93    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
94    * validated in the constructor.
95    */
96   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
97 
98   /**
99    * @dev Returns the current implementation.
100    * @return impl Address of the current implementation
101    */
102   function _implementation() override internal view returns (address impl) {
103     bytes32 slot = IMPLEMENTATION_SLOT;
104     assembly {
105       impl := sload(slot)
106     }
107   }
108 
109   /**
110    * @dev Upgrades the proxy to a new implementation.
111    * @param newImplementation Address of the new implementation.
112    */
113   function _upgradeTo(address newImplementation) internal {
114     _setImplementation(newImplementation);
115     emit Upgraded(newImplementation);
116   }
117 
118   /**
119    * @dev Sets the implementation address of the proxy.
120    * @param newImplementation Address of the new implementation.
121    */
122   function _setImplementation(address newImplementation) internal {
123     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
124 
125     bytes32 slot = IMPLEMENTATION_SLOT;
126 
127     assembly {
128       sstore(slot, newImplementation)
129     }
130   }
131 }
132 
133 
134 /**
135  * @title BaseAdminUpgradeabilityProxy
136  * @dev This contract combines an upgradeability proxy with an authorization
137  * mechanism for administrative tasks.
138  * All external functions in this contract must be guarded by the
139  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
140  * feature proposal that would enable this to be done automatically.
141  */
142 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
143   /**
144    * @dev Emitted when the administration has been transferred.
145    * @param previousAdmin Address of the previous admin.
146    * @param newAdmin Address of the new admin.
147    */
148   event AdminChanged(address previousAdmin, address newAdmin);
149 
150   /**
151    * @dev Storage slot with the admin of the contract.
152    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
153    * validated in the constructor.
154    */
155 
156   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
157 
158   /**
159    * @dev Modifier to check whether the `msg.sender` is the admin.
160    * If it is, it will run the function. Otherwise, it will delegate the call
161    * to the implementation.
162    */
163   modifier ifAdmin() {
164     if (msg.sender == _admin()) {
165       _;
166     } else {
167       _fallback();
168     }
169   }
170 
171   /**
172    * @return The address of the proxy admin.
173    */
174   function admin() external ifAdmin returns (address) {
175     return _admin();
176   }
177 
178   /**
179    * @return The address of the implementation.
180    */
181   function implementation() external ifAdmin returns (address) {
182     return _implementation();
183   }
184 
185   /**
186    * @dev Changes the admin of the proxy.
187    * Only the current admin can call this function.
188    * @param newAdmin Address to transfer proxy administration to.
189    */
190   function changeAdmin(address newAdmin) external ifAdmin {
191     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
192     emit AdminChanged(_admin(), newAdmin);
193     _setAdmin(newAdmin);
194   }
195 
196   /**
197    * @dev Upgrade the backing implementation of the proxy.
198    * Only the admin can call this function.
199    * @param newImplementation Address of the new implementation.
200    */
201   function upgradeTo(address newImplementation) external ifAdmin {
202     _upgradeTo(newImplementation);
203   }
204 
205   /**
206    * @dev Upgrade the backing implementation of the proxy and call a function
207    * on the new implementation.
208    * This is useful to initialize the proxied contract.
209    * @param newImplementation Address of the new implementation.
210    * @param data Data to send as msg.data in the low level call.
211    * It should include the signature and the parameters of the function to be called, as described in
212    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
213    */
214   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
215     _upgradeTo(newImplementation);
216     (bool success,) = newImplementation.delegatecall(data);
217     require(success);
218   }
219 
220   /**
221    * @return adm The admin slot.
222    */
223   function _admin() internal view returns (address adm) {
224     bytes32 slot = ADMIN_SLOT;
225     assembly {
226       adm := sload(slot)
227     }
228   }
229 
230   /**
231    * @dev Sets the address of the proxy admin.
232    * @param newAdmin Address of the new proxy admin.
233    */
234   function _setAdmin(address newAdmin) internal {
235     bytes32 slot = ADMIN_SLOT;
236 
237     assembly {
238       sstore(slot, newAdmin)
239     }
240   }
241 
242   /**
243    * @dev Only fall back when the sender is not the admin.
244    */
245   function _willFallback() virtual override internal {
246     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
247     //super._willFallback();
248   }
249 }
250 
251 interface IAdminUpgradeabilityProxyView {
252   function admin() external view returns (address);
253   function implementation() external view returns (address);
254 }
255 
256 
257 /**
258  * @title UpgradeabilityProxy
259  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
260  * implementation and init data.
261  */
262 abstract contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
263   /**
264    * @dev Contract constructor.
265    * @param _logic Address of the initial implementation.
266    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
267    * It should include the signature and the parameters of the function to be called, as described in
268    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
269    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
270    */
271   constructor(address _logic, bytes memory _data) public payable {
272     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
273     _setImplementation(_logic);
274     if(_data.length > 0) {
275       (bool success,) = _logic.delegatecall(_data);
276       require(success);
277     }
278   }  
279   
280   //function _willFallback() virtual override internal {
281     //super._willFallback();
282   //}
283 }
284 
285 
286 /**
287  * @title AdminUpgradeabilityProxy
288  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
289  * initializing the implementation, admin, and init data.
290  */
291 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
292   /**
293    * Contract constructor.
294    * @param _logic address of the initial implementation.
295    * @param _admin Address of the proxy administrator.
296    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
297    * It should include the signature and the parameters of the function to be called, as described in
298    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
299    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
300    */
301   constructor(address _admin, address _logic, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
302     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
303     _setAdmin(_admin);
304   }
305   
306   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
307     super._willFallback();
308   }
309 }
310 
311 
312 /**
313  * @title InitializableUpgradeabilityProxy
314  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
315  * implementation and init data.
316  */
317 abstract contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
318   /**
319    * @dev Contract initializer.
320    * @param _logic Address of the initial implementation.
321    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
322    * It should include the signature and the parameters of the function to be called, as described in
323    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
324    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
325    */
326   function initialize(address _logic, bytes memory _data) public payable {
327     require(_implementation() == address(0));
328     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
329     _setImplementation(_logic);
330     if(_data.length > 0) {
331       (bool success,) = _logic.delegatecall(_data);
332       require(success);
333     }
334   }  
335 }
336 
337 
338 /**
339  * @title InitializableAdminUpgradeabilityProxy
340  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
341  * initializing the implementation, admin, and init data.
342  */
343 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
344   /**
345    * Contract initializer.
346    * @param _logic address of the initial implementation.
347    * @param _admin Address of the proxy administrator.
348    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
349    * It should include the signature and the parameters of the function to be called, as described in
350    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
351    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
352    */
353   function initialize(address _admin, address _logic, bytes memory _data) public payable {
354     require(_implementation() == address(0));
355     InitializableUpgradeabilityProxy.initialize(_logic, _data);
356     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
357     _setAdmin(_admin);
358   }
359   
360   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
361     super._willFallback();
362   }
363 
364 }
365 
366 
367 interface IProxyFactory {
368     function productImplementation() external view returns (address);
369     function productImplementations(bytes32 name) external view returns (address);
370 }
371 
372 
373 /**
374  * @title ProductProxy
375  * @dev This contract implements a proxy that 
376  * it is deploied by ProxyFactory, 
377  * and it's implementation is stored in factory.
378  */
379 contract ProductProxy is Proxy {
380     
381   /**
382    * @dev Storage slot with the address of the ProxyFactory.
383    * This is the keccak-256 hash of "eip1967.proxy.factory" subtracted by 1, and is
384    * validated in the constructor.
385    */
386   bytes32 internal constant FACTORY_SLOT = 0x7a45a402e4cb6e08ebc196f20f66d5d30e67285a2a8aa80503fa409e727a4af1;
387   bytes32 internal constant NAME_SLOT    = 0x4cd9b827ca535ceb0880425d70eff88561ecdf04dc32fcf7ff3b15c587f8a870;      // bytes32(uint256(keccak256('eip1967.proxy.name')) - 1)
388 
389   function _name() virtual internal view returns (bytes32 name_) {
390     bytes32 slot = NAME_SLOT;
391     assembly {  name_ := sload(slot)  }
392   }
393   
394   function _setName(bytes32 name_) internal {
395     bytes32 slot = NAME_SLOT;
396     assembly {  sstore(slot, name_)  }
397   }
398 
399   /**
400    * @dev Sets the factory address of the ProductProxy.
401    * @param newFactory Address of the new factory.
402    */
403   function _setFactory(address newFactory) internal {
404     require(OpenZeppelinUpgradesAddress.isContract(newFactory), "Cannot set a factory to a non-contract address");
405 
406     bytes32 slot = FACTORY_SLOT;
407 
408     assembly {
409       sstore(slot, newFactory)
410     }
411   }
412 
413   /**
414    * @dev Returns the factory.
415    * @return factory_ Address of the factory.
416    */
417   function _factory() internal view returns (address factory_) {
418     bytes32 slot = FACTORY_SLOT;
419     assembly {
420       factory_ := sload(slot)
421     }
422   }
423   
424   /**
425    * @dev Returns the current implementation.
426    * @return Address of the current implementation
427    */
428   function _implementation() virtual override internal view returns (address) {
429     address factory_ = _factory();
430     if(OpenZeppelinUpgradesAddress.isContract(factory_))
431         return IProxyFactory(factory_).productImplementations(_name());
432     else
433         return address(0);
434   }
435 
436 }
437 
438 
439 /**
440  * @title InitializableProductProxy
441  * @dev Extends ProductProxy with an initializer for initializing
442  * factory and init data.
443  */
444 contract InitializableProductProxy is ProductProxy {
445   /**
446    * @dev Contract initializer.
447    * @param factory_ Address of the initial factory.
448    * @param data_ Data to send as msg.data to the implementation to initialize the proxied contract.
449    * It should include the signature and the parameters of the function to be called, as described in
450    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
451    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
452    */
453   function __InitializableProductProxy_init(address factory_, bytes32 name_, bytes memory data_) public payable {
454     require(_factory() == address(0));
455     assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
456     assert(NAME_SLOT    == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
457     _setFactory(factory_);
458     _setName(name_);
459     if(data_.length > 0) {
460       (bool success,) = _implementation().delegatecall(data_);
461       require(success);
462     }
463   }  
464 }
465 
466 
467 /**
468  * @title Initializable
469  *
470  * @dev Helper contract to support initializer functions. To use it, replace
471  * the constructor with a function that has the `initializer` modifier.
472  * WARNING: Unlike constructors, initializer functions must be manually
473  * invoked. This applies both to deploying an Initializable contract, as well
474  * as extending an Initializable contract via inheritance.
475  * WARNING: When used with inheritance, manual care must be taken to not invoke
476  * a parent initializer twice, or ensure that all initializers are idempotent,
477  * because this is not dealt with automatically as with constructors.
478  */
479 contract Initializable {
480 
481   /**
482    * @dev Indicates that the contract has been initialized.
483    */
484   bool private initialized;
485 
486   /**
487    * @dev Indicates that the contract is in the process of being initialized.
488    */
489   bool private initializing;
490 
491   /**
492    * @dev Modifier to use in the initializer function of a contract.
493    */
494   modifier initializer() {
495     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
496 
497     bool isTopLevelCall = !initializing;
498     if (isTopLevelCall) {
499       initializing = true;
500       initialized = true;
501     }
502 
503     _;
504 
505     if (isTopLevelCall) {
506       initializing = false;
507     }
508   }
509 
510   /// @dev Returns true if and only if the function is running in the constructor
511   function isConstructor() private view returns (bool) {
512     // extcodesize checks the size of the code stored in an address, and
513     // address returns the current address. Since the code is still not
514     // deployed when running a constructor, any checks on its code size will
515     // yield zero, making it an effective way to detect if a contract is
516     // under construction or not.
517     address self = address(this);
518     uint256 cs;
519     assembly { cs := extcodesize(self) }
520     return cs == 0;
521   }
522 
523   // Reserved storage space to allow for layout changes in the future.
524   uint256[50] private ______gap;
525 }
526 
527 
528 /*
529  * @dev Provides information about the current execution context, including the
530  * sender of the transaction and its data. While these are generally available
531  * via msg.sender and msg.data, they should not be accessed in such a direct
532  * manner, since when dealing with GSN meta-transactions the account sending and
533  * paying for execution may not be the actual sender (as far as an application
534  * is concerned).
535  *
536  * This contract is only required for intermediate, library-like contracts.
537  */
538 contract ContextUpgradeSafe is Initializable {
539     // Empty internal constructor, to prevent people from mistakenly deploying
540     // an instance of this contract, which should be used via inheritance.
541 
542     function __Context_init() internal initializer {
543         __Context_init_unchained();
544     }
545 
546     function __Context_init_unchained() internal initializer {
547 
548 
549     }
550 
551 
552     function _msgSender() internal view virtual returns (address payable) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes memory) {
557         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
558         return msg.data;
559     }
560 
561     uint256[50] private __gap;
562 }
563 
564 /**
565  * @dev Contract module that helps prevent reentrant calls to a function.
566  *
567  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
568  * available, which can be applied to functions to make sure there are no nested
569  * (reentrant) calls to them.
570  *
571  * Note that because there is a single `nonReentrant` guard, functions marked as
572  * `nonReentrant` may not call one another. This can be worked around by making
573  * those functions `private`, and then adding `external` `nonReentrant` entry
574  * points to them.
575  *
576  * TIP: If you would like to learn more about reentrancy and alternative ways
577  * to protect against it, check out our blog post
578  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
579  */
580 contract ReentrancyGuardUpgradeSafe is Initializable {
581     bool private _notEntered;
582 
583 
584     function __ReentrancyGuard_init() internal initializer {
585         __ReentrancyGuard_init_unchained();
586     }
587 
588     function __ReentrancyGuard_init_unchained() internal initializer {
589 
590 
591         // Storing an initial non-zero value makes deployment a bit more
592         // expensive, but in exchange the refund on every call to nonReentrant
593         // will be lower in amount. Since refunds are capped to a percetange of
594         // the total transaction's gas, it is best to keep them low in cases
595         // like this one, to increase the likelihood of the full refund coming
596         // into effect.
597         _notEntered = true;
598 
599     }
600 
601 
602     /**
603      * @dev Prevents a contract from calling itself, directly or indirectly.
604      * Calling a `nonReentrant` function from another `nonReentrant`
605      * function is not supported. It is possible to prevent this from happening
606      * by making the `nonReentrant` function external, and make it call a
607      * `private` function that does the actual work.
608      */
609     modifier nonReentrant() {
610         // On the first call to nonReentrant, _notEntered will be true
611         require(_notEntered, "ReentrancyGuard: reentrant call");
612 
613         // Any calls to nonReentrant after this point will fail
614         _notEntered = false;
615 
616         _;
617 
618         // By storing the original value once again, a refund is triggered (see
619         // https://eips.ethereum.org/EIPS/eip-2200)
620         _notEntered = true;
621     }
622 
623     uint256[49] private __gap;
624 }
625 
626 /**
627  * @dev Standard math utilities missing in the Solidity language.
628  */
629 library Math {
630     /**
631      * @dev Returns the largest of two numbers.
632      */
633     function max(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a >= b ? a : b;
635     }
636 
637     /**
638      * @dev Returns the smallest of two numbers.
639      */
640     function min(uint256 a, uint256 b) internal pure returns (uint256) {
641         return a < b ? a : b;
642     }
643 
644     /**
645      * @dev Returns the average of two numbers. The result is rounded towards
646      * zero.
647      */
648     function average(uint256 a, uint256 b) internal pure returns (uint256) {
649         // (a + b) / 2 can overflow, so we distribute
650         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
651     }
652 }
653 
654 /**
655  * @dev Wrappers over Solidity's arithmetic operations with added overflow
656  * checks.
657  *
658  * Arithmetic operations in Solidity wrap on overflow. This can easily result
659  * in bugs, because programmers usually assume that an overflow raises an
660  * error, which is the standard behavior in high level programming languages.
661  * `SafeMath` restores this intuition by reverting the transaction when an
662  * operation overflows.
663  *
664  * Using this library instead of the unchecked operations eliminates an entire
665  * class of bugs, so it's recommended to use it always.
666  */
667 library SafeMath {
668     /**
669      * @dev Returns the addition of two unsigned integers, reverting on
670      * overflow.
671      *
672      * Counterpart to Solidity's `+` operator.
673      *
674      * Requirements:
675      * - Addition cannot overflow.
676      */
677     function add(uint256 a, uint256 b) internal pure returns (uint256) {
678         uint256 c = a + b;
679         require(c >= a, "SafeMath: addition overflow");
680 
681         return c;
682     }
683 
684     /**
685      * @dev Returns the subtraction of two unsigned integers, reverting on
686      * overflow (when the result is negative).
687      *
688      * Counterpart to Solidity's `-` operator.
689      *
690      * Requirements:
691      * - Subtraction cannot overflow.
692      */
693     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
694         return sub(a, b, "SafeMath: subtraction overflow");
695     }
696 
697     /**
698      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
699      * overflow (when the result is negative).
700      *
701      * Counterpart to Solidity's `-` operator.
702      *
703      * Requirements:
704      * - Subtraction cannot overflow.
705      */
706     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
707         require(b <= a, errorMessage);
708         uint256 c = a - b;
709 
710         return c;
711     }
712 
713     function sub0(uint256 a, uint256 b) internal pure returns (uint256) {
714         return a > b ? a - b : 0;
715     }
716 
717     /**
718      * @dev Returns the multiplication of two unsigned integers, reverting on
719      * overflow.
720      *
721      * Counterpart to Solidity's `*` operator.
722      *
723      * Requirements:
724      * - Multiplication cannot overflow.
725      */
726     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
727         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
728         // benefit is lost if 'b' is also tested.
729         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
730         if (a == 0) {
731             return 0;
732         }
733 
734         uint256 c = a * b;
735         require(c / a == b, "SafeMath: multiplication overflow");
736 
737         return c;
738     }
739 
740     /**
741      * @dev Returns the integer division of two unsigned integers. Reverts on
742      * division by zero. The result is rounded towards zero.
743      *
744      * Counterpart to Solidity's `/` operator. Note: this function uses a
745      * `revert` opcode (which leaves remaining gas untouched) while Solidity
746      * uses an invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      * - The divisor cannot be zero.
750      */
751     function div(uint256 a, uint256 b) internal pure returns (uint256) {
752         return div(a, b, "SafeMath: division by zero");
753     }
754 
755     /**
756      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
757      * division by zero. The result is rounded towards zero.
758      *
759      * Counterpart to Solidity's `/` operator. Note: this function uses a
760      * `revert` opcode (which leaves remaining gas untouched) while Solidity
761      * uses an invalid opcode to revert (consuming all remaining gas).
762      *
763      * Requirements:
764      * - The divisor cannot be zero.
765      */
766     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
767         // Solidity only automatically asserts when dividing by 0
768         require(b > 0, errorMessage);
769         uint256 c = a / b;
770         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
771 
772         return c;
773     }
774 
775     /**
776      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
777      * Reverts when dividing by zero.
778      *
779      * Counterpart to Solidity's `%` operator. This function uses a `revert`
780      * opcode (which leaves remaining gas untouched) while Solidity uses an
781      * invalid opcode to revert (consuming all remaining gas).
782      *
783      * Requirements:
784      * - The divisor cannot be zero.
785      */
786     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
787         return mod(a, b, "SafeMath: modulo by zero");
788     }
789 
790     /**
791      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
792      * Reverts with custom message when dividing by zero.
793      *
794      * Counterpart to Solidity's `%` operator. This function uses a `revert`
795      * opcode (which leaves remaining gas untouched) while Solidity uses an
796      * invalid opcode to revert (consuming all remaining gas).
797      *
798      * Requirements:
799      * - The divisor cannot be zero.
800      */
801     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
802         require(b != 0, errorMessage);
803         return a % b;
804     }
805 }
806 
807 /**
808  * Utility library of inline functions on addresses
809  *
810  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
811  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
812  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
813  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
814  */
815 library OpenZeppelinUpgradesAddress {
816     /**
817      * Returns whether the target address is a contract
818      * @dev This function will return false if invoked during the constructor of a contract,
819      * as the code is not actually created until after the constructor finishes.
820      * @param account address of the account to check
821      * @return whether the target address is a contract
822      */
823     function isContract(address account) internal view returns (bool) {
824         uint256 size;
825         // XXX Currently there is no better way to check if there is a contract in an address
826         // than to check the size of the code at that address.
827         // See https://ethereum.stackexchange.com/a/14016/36603
828         // for more details about how this works.
829         // TODO Check this again before the Serenity release, because all addresses will be
830         // contracts then.
831         // solhint-disable-next-line no-inline-assembly
832         assembly { size := extcodesize(account) }
833         return size > 0;
834     }
835 }
836 
837 /**
838  * @dev Collection of functions related to the address type
839  */
840 library Address {
841     /**
842      * @dev Returns true if `account` is a contract.
843      *
844      * [IMPORTANT]
845      * ====
846      * It is unsafe to assume that an address for which this function returns
847      * false is an externally-owned account (EOA) and not a contract.
848      *
849      * Among others, `isContract` will return false for the following
850      * types of addresses:
851      *
852      *  - an externally-owned account
853      *  - a contract in construction
854      *  - an address where a contract will be created
855      *  - an address where a contract lived, but was destroyed
856      * ====
857      */
858     function isContract(address account) internal view returns (bool) {
859         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
860         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
861         // for accounts without code, i.e. `keccak256('')`
862         bytes32 codehash;
863         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
864         // solhint-disable-next-line no-inline-assembly
865         assembly { codehash := extcodehash(account) }
866         return (codehash != accountHash && codehash != 0x0);
867     }
868 
869     /**
870      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
871      * `recipient`, forwarding all available gas and reverting on errors.
872      *
873      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
874      * of certain opcodes, possibly making contracts go over the 2300 gas limit
875      * imposed by `transfer`, making them unable to receive funds via
876      * `transfer`. {sendValue} removes this limitation.
877      *
878      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
879      *
880      * IMPORTANT: because control is transferred to `recipient`, care must be
881      * taken to not create reentrancy vulnerabilities. Consider using
882      * {ReentrancyGuard} or the
883      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
884      */
885     function sendValue(address payable recipient, uint256 amount) internal {
886         require(address(this).balance >= amount, "Address: insufficient balance");
887 
888         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
889         (bool success, ) = recipient.call{ value: amount }("");
890         require(success, "Address: unable to send value, recipient may have reverted");
891     }
892 }
893 
894 /**
895  * @dev Interface of the ERC20 standard as defined in the EIP.
896  */
897 interface IERC20 {
898     /**
899      * @dev Returns the amount of tokens in existence.
900      */
901     function totalSupply() external view returns (uint256);
902 
903     /**
904      * @dev Returns the amount of tokens owned by `account`.
905      */
906     function balanceOf(address account) external view returns (uint256);
907 
908     /**
909      * @dev Moves `amount` tokens from the caller's account to `recipient`.
910      *
911      * Returns a boolean value indicating whether the operation succeeded.
912      *
913      * Emits a {Transfer} event.
914      */
915     function transfer(address recipient, uint256 amount) external returns (bool);
916 
917     /**
918      * @dev Returns the remaining number of tokens that `spender` will be
919      * allowed to spend on behalf of `owner` through {transferFrom}. This is
920      * zero by default.
921      *
922      * This value changes when {approve} or {transferFrom} are called.
923      */
924     function allowance(address owner, address spender) external view returns (uint256);
925 
926     /**
927      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
928      *
929      * Returns a boolean value indicating whether the operation succeeded.
930      *
931      * IMPORTANT: Beware that changing an allowance with this method brings the risk
932      * that someone may use both the old and the new allowance by unfortunate
933      * transaction ordering. One possible solution to mitigate this race
934      * condition is to first reduce the spender's allowance to 0 and set the
935      * desired value afterwards:
936      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address spender, uint256 amount) external returns (bool);
941 
942     /**
943      * @dev Moves `amount` tokens from `sender` to `recipient` using the
944      * allowance mechanism. `amount` is then deducted from the caller's
945      * allowance.
946      *
947      * Returns a boolean value indicating whether the operation succeeded.
948      *
949      * Emits a {Transfer} event.
950      */
951     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
952 
953     /**
954      * @dev Emitted when `value` tokens are moved from one account (`from`) to
955      * another (`to`).
956      *
957      * Note that `value` may be zero.
958      */
959     event Transfer(address indexed from, address indexed to, uint256 value);
960 
961     /**
962      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
963      * a call to {approve}. `value` is the new allowance.
964      */
965     event Approval(address indexed owner, address indexed spender, uint256 value);
966 }
967 
968 /**
969  * @dev Implementation of the {IERC20} interface.
970  *
971  * This implementation is agnostic to the way tokens are created. This means
972  * that a supply mechanism has to be added in a derived contract using {_mint}.
973  * For a generic mechanism see {ERC20MinterPauser}.
974  *
975  * TIP: For a detailed writeup see our guide
976  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
977  * to implement supply mechanisms].
978  *
979  * We have followed general OpenZeppelin guidelines: functions revert instead
980  * of returning `false` on failure. This behavior is nonetheless conventional
981  * and does not conflict with the expectations of ERC20 applications.
982  *
983  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
984  * This allows applications to reconstruct the allowance for all accounts just
985  * by listening to said events. Other implementations of the EIP may not emit
986  * these events, as it isn't required by the specification.
987  *
988  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
989  * functions have been added to mitigate the well-known issues around setting
990  * allowances. See {IERC20-approve}.
991  */
992 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
993     using SafeMath for uint256;
994     using Address for address;
995 
996     mapping (address => uint256) private _balances;
997 
998     mapping (address => mapping (address => uint256)) private _allowances;
999 
1000     uint256 private _totalSupply;
1001 
1002     string private _name;
1003     string private _symbol;
1004     uint8 private _decimals;
1005 
1006     /**
1007      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1008      * a default value of 18.
1009      *
1010      * To select a different value for {decimals}, use {_setupDecimals}.
1011      *
1012      * All three of these values are immutable: they can only be set once during
1013      * construction.
1014      */
1015 
1016     function __ERC20_init(string memory name, string memory symbol) internal initializer {
1017         __Context_init_unchained();
1018         __ERC20_init_unchained(name, symbol);
1019     }
1020 
1021     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
1022 
1023 
1024         _name = name;
1025         _symbol = symbol;
1026         _decimals = 18;
1027 
1028     }
1029 
1030 
1031     /**
1032      * @dev Returns the name of the token.
1033      */
1034     function name() public view returns (string memory) {
1035         return _name;
1036     }
1037 
1038     /**
1039      * @dev Returns the symbol of the token, usually a shorter version of the
1040      * name.
1041      */
1042     function symbol() public view returns (string memory) {
1043         return _symbol;
1044     }
1045 
1046     /**
1047      * @dev Returns the number of decimals used to get its user representation.
1048      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1049      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1050      *
1051      * Tokens usually opt for a value of 18, imitating the relationship between
1052      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1053      * called.
1054      *
1055      * NOTE: This information is only used for _display_ purposes: it in
1056      * no way affects any of the arithmetic of the contract, including
1057      * {IERC20-balanceOf} and {IERC20-transfer}.
1058      */
1059     function decimals() public view returns (uint8) {
1060         return _decimals;
1061     }
1062 
1063     /**
1064      * @dev See {IERC20-totalSupply}.
1065      */
1066     function totalSupply() public view override returns (uint256) {
1067         return _totalSupply;
1068     }
1069 
1070     /**
1071      * @dev See {IERC20-balanceOf}.
1072      */
1073     function balanceOf(address account) public view override returns (uint256) {
1074         return _balances[account];
1075     }
1076 
1077     /**
1078      * @dev See {IERC20-transfer}.
1079      *
1080      * Requirements:
1081      *
1082      * - `recipient` cannot be the zero address.
1083      * - the caller must have a balance of at least `amount`.
1084      */
1085     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1086         _transfer(_msgSender(), recipient, amount);
1087         return true;
1088     }
1089 
1090     /**
1091      * @dev See {IERC20-allowance}.
1092      */
1093     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1094         return _allowances[owner][spender];
1095     }
1096 
1097     /**
1098      * @dev See {IERC20-approve}.
1099      *
1100      * Requirements:
1101      *
1102      * - `spender` cannot be the zero address.
1103      */
1104     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1105         _approve(_msgSender(), spender, amount);
1106         return true;
1107     }
1108 
1109     /**
1110      * @dev See {IERC20-transferFrom}.
1111      *
1112      * Emits an {Approval} event indicating the updated allowance. This is not
1113      * required by the EIP. See the note at the beginning of {ERC20};
1114      *
1115      * Requirements:
1116      * - `sender` and `recipient` cannot be the zero address.
1117      * - `sender` must have a balance of at least `amount`.
1118      * - the caller must have allowance for ``sender``'s tokens of at least
1119      * `amount`.
1120      */
1121     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1122         _transfer(sender, recipient, amount);
1123         if(sender != _msgSender() && _allowances[sender][_msgSender()] != uint(-1))
1124             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1125         return true;
1126     }
1127 
1128     /**
1129      * @dev Atomically increases the allowance granted to `spender` by the caller.
1130      *
1131      * This is an alternative to {approve} that can be used as a mitigation for
1132      * problems described in {IERC20-approve}.
1133      *
1134      * Emits an {Approval} event indicating the updated allowance.
1135      *
1136      * Requirements:
1137      *
1138      * - `spender` cannot be the zero address.
1139      */
1140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1142         return true;
1143     }
1144 
1145     /**
1146      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1147      *
1148      * This is an alternative to {approve} that can be used as a mitigation for
1149      * problems described in {IERC20-approve}.
1150      *
1151      * Emits an {Approval} event indicating the updated allowance.
1152      *
1153      * Requirements:
1154      *
1155      * - `spender` cannot be the zero address.
1156      * - `spender` must have allowance for the caller of at least
1157      * `subtractedValue`.
1158      */
1159     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1160         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1161         return true;
1162     }
1163 
1164     /**
1165      * @dev Moves tokens `amount` from `sender` to `recipient`.
1166      *
1167      * This is internal function is equivalent to {transfer}, and can be used to
1168      * e.g. implement automatic token fees, slashing mechanisms, etc.
1169      *
1170      * Emits a {Transfer} event.
1171      *
1172      * Requirements:
1173      *
1174      * - `sender` cannot be the zero address.
1175      * - `recipient` cannot be the zero address.
1176      * - `sender` must have a balance of at least `amount`.
1177      */
1178     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1179         require(sender != address(0), "ERC20: transfer from the zero address");
1180         require(recipient != address(0), "ERC20: transfer to the zero address");
1181 
1182         _beforeTokenTransfer(sender, recipient, amount);
1183 
1184         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1185         _balances[recipient] = _balances[recipient].add(amount);
1186         emit Transfer(sender, recipient, amount);
1187     }
1188 
1189     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1190      * the total supply.
1191      *
1192      * Emits a {Transfer} event with `from` set to the zero address.
1193      *
1194      * Requirements
1195      *
1196      * - `to` cannot be the zero address.
1197      */
1198     function _mint(address account, uint256 amount) internal virtual {
1199         require(account != address(0), "ERC20: mint to the zero address");
1200 
1201         _beforeTokenTransfer(address(0), account, amount);
1202 
1203         _totalSupply = _totalSupply.add(amount);
1204         _balances[account] = _balances[account].add(amount);
1205         emit Transfer(address(0), account, amount);
1206     }
1207 
1208     /**
1209      * @dev Destroys `amount` tokens from `account`, reducing the
1210      * total supply.
1211      *
1212      * Emits a {Transfer} event with `to` set to the zero address.
1213      *
1214      * Requirements
1215      *
1216      * - `account` cannot be the zero address.
1217      * - `account` must have at least `amount` tokens.
1218      */
1219     function _burn(address account, uint256 amount) internal virtual {
1220         require(account != address(0), "ERC20: burn from the zero address");
1221 
1222         _beforeTokenTransfer(account, address(0), amount);
1223 
1224         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1225         _totalSupply = _totalSupply.sub(amount);
1226         emit Transfer(account, address(0), amount);
1227     }
1228 
1229     /**
1230      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1231      *
1232      * This is internal function is equivalent to `approve`, and can be used to
1233      * e.g. set automatic allowances for certain subsystems, etc.
1234      *
1235      * Emits an {Approval} event.
1236      *
1237      * Requirements:
1238      *
1239      * - `owner` cannot be the zero address.
1240      * - `spender` cannot be the zero address.
1241      */
1242     function _approve(address owner, address spender, uint256 amount) internal virtual {
1243         require(owner != address(0), "ERC20: approve from the zero address");
1244         require(spender != address(0), "ERC20: approve to the zero address");
1245 
1246         _allowances[owner][spender] = amount;
1247         emit Approval(owner, spender, amount);
1248     }
1249 
1250     /**
1251      * @dev Sets {decimals} to a value other than the default one of 18.
1252      *
1253      * WARNING: This function should only be called from the constructor. Most
1254      * applications that interact with token contracts will not expect
1255      * {decimals} to ever change, and may work incorrectly if it does.
1256      */
1257     function _setupDecimals(uint8 decimals_) internal {
1258         _decimals = decimals_;
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before any transfer of tokens. This includes
1263      * minting and burning.
1264      *
1265      * Calling conditions:
1266      *
1267      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1268      * will be to transferred to `to`.
1269      * - when `from` is zero, `amount` tokens will be minted for `to`.
1270      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1271      * - `from` and `to` are never both zero.
1272      *
1273      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1274      */
1275     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1276 
1277     uint256[44] private __gap;
1278 }
1279 
1280 
1281 /**
1282  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1283  */
1284 abstract contract ERC20CappedUpgradeSafe is Initializable, ERC20UpgradeSafe {
1285     uint256 private _cap;
1286 
1287     /**
1288      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1289      * set once during construction.
1290      */
1291 
1292     function __ERC20Capped_init(uint256 cap) internal initializer {
1293         __Context_init_unchained();
1294         __ERC20Capped_init_unchained(cap);
1295     }
1296 
1297     function __ERC20Capped_init_unchained(uint256 cap) internal initializer {
1298 
1299 
1300         require(cap > 0, "ERC20Capped: cap is 0");
1301         _cap = cap;
1302 
1303     }
1304 
1305 
1306     /**
1307      * @dev Returns the cap on the token's total supply.
1308      */
1309     function cap() virtual public view returns (uint256) {
1310         return _cap;
1311     }
1312 
1313     /**
1314      * @dev See {ERC20-_beforeTokenTransfer}.
1315      *
1316      * Requirements:
1317      *
1318      * - minted tokens must not cause the total supply to go over the cap.
1319      */
1320     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1321         super._beforeTokenTransfer(from, to, amount);
1322 
1323         if (from == address(0)) { // When minting tokens
1324             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1325         }
1326     }
1327 
1328     uint256[49] private __gap;
1329 }
1330 
1331 
1332 /**
1333  * @title SafeERC20
1334  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1335  * contract returns false). Tokens that return no value (and instead revert or
1336  * throw on failure) are also supported, non-reverting calls are assumed to be
1337  * successful.
1338  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1339  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1340  */
1341 library SafeERC20 {
1342     using SafeMath for uint256;
1343     using Address for address;
1344 
1345     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1346         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1347     }
1348 
1349     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1350         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1351     }
1352 
1353     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1354         // safeApprove should only be called when setting an initial allowance,
1355         // or when resetting it to zero. To increase and decrease it, use
1356         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1357         // solhint-disable-next-line max-line-length
1358         require((value == 0) || (token.allowance(address(this), spender) == 0),
1359             "SafeERC20: approve from non-zero to non-zero allowance"
1360         );
1361         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1362     }
1363 
1364     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1365         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1366         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1367     }
1368 
1369     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1370         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1371         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1372     }
1373 
1374     /**
1375      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1376      * on the return value: the return value is optional (but if data is returned, it must not be false).
1377      * @param token The token targeted by the call.
1378      * @param data The call data (encoded using abi.encode or one of its variants).
1379      */
1380     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1381         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1382         // we're implementing it ourselves.
1383 
1384         // A Solidity high level call has three parts:
1385         //  1. The target address is checked to verify it contains contract code
1386         //  2. The call itself is made, and success asserted
1387         //  3. The return value is decoded, which in turn checks the size of the returned data.
1388         // solhint-disable-next-line max-line-length
1389         require(address(token).isContract(), "SafeERC20: call to non-contract");
1390 
1391         // solhint-disable-next-line avoid-low-level-calls
1392         (bool success, bytes memory returndata) = address(token).call(data);
1393         require(success, "SafeERC20: low-level call failed");
1394 
1395         if (returndata.length > 0) { // Return data is optional
1396             // solhint-disable-next-line max-line-length
1397             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1398         }
1399     }
1400 }
1401 
1402 
1403 // https://github.com/hamdiallam/Solidity-RLP/blob/master/contracts/RLPReader.sol
1404 /*
1405 * @author Hamdi Allam hamdi.allam97@gmail.com
1406 * Please reach out with any questions or concerns
1407 */
1408 pragma solidity >=0.5.0 <0.7.0;
1409 
1410 library RLPReader {
1411     uint8 constant STRING_SHORT_START = 0x80;
1412     uint8 constant STRING_LONG_START  = 0xb8;
1413     uint8 constant LIST_SHORT_START   = 0xc0;
1414     uint8 constant LIST_LONG_START    = 0xf8;
1415     uint8 constant WORD_SIZE = 32;
1416 
1417     struct RLPItem {
1418         uint len;
1419         uint memPtr;
1420     }
1421 
1422     struct Iterator {
1423         RLPItem item;   // Item that's being iterated over.
1424         uint nextPtr;   // Position of the next item in the list.
1425     }
1426 
1427     /*
1428     * @dev Returns the next element in the iteration. Reverts if it has not next element.
1429     * @param self The iterator.
1430     * @return The next element in the iteration.
1431     */
1432     function next(Iterator memory self) internal pure returns (RLPItem memory) {
1433         require(hasNext(self));
1434 
1435         uint ptr = self.nextPtr;
1436         uint itemLength = _itemLength(ptr);
1437         self.nextPtr = ptr + itemLength;
1438 
1439         return RLPItem(itemLength, ptr);
1440     }
1441 
1442     /*
1443     * @dev Returns true if the iteration has more elements.
1444     * @param self The iterator.
1445     * @return true if the iteration has more elements.
1446     */
1447     function hasNext(Iterator memory self) internal pure returns (bool) {
1448         RLPItem memory item = self.item;
1449         return self.nextPtr < item.memPtr + item.len;
1450     }
1451 
1452     /*
1453     * @param item RLP encoded bytes
1454     */
1455     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
1456         uint memPtr;
1457         assembly {
1458             memPtr := add(item, 0x20)
1459         }
1460 
1461         return RLPItem(item.length, memPtr);
1462     }
1463 
1464     /*
1465     * @dev Create an iterator. Reverts if item is not a list.
1466     * @param self The RLP item.
1467     * @return An 'Iterator' over the item.
1468     */
1469     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
1470         require(isList(self));
1471 
1472         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
1473         return Iterator(self, ptr);
1474     }
1475 
1476     /*
1477     * @param the RLP item.
1478     */
1479     function rlpLen(RLPItem memory item) internal pure returns (uint) {
1480         return item.len;
1481     }
1482 
1483     /*
1484      * @param the RLP item.
1485      * @return (memPtr, len) pair: location of the item's payload in memory.
1486      */
1487     function payloadLocation(RLPItem memory item) internal pure returns (uint, uint) {
1488         uint offset = _payloadOffset(item.memPtr);
1489         uint memPtr = item.memPtr + offset;
1490         uint len = item.len - offset; // data length
1491         return (memPtr, len);
1492     }
1493 
1494     /*
1495     * @param the RLP item.
1496     */
1497     function payloadLen(RLPItem memory item) internal pure returns (uint) {
1498         (, uint len) = payloadLocation(item);
1499         return len;
1500     }
1501 
1502     /*
1503     * @param the RLP item containing the encoded list.
1504     */
1505     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
1506         require(isList(item));
1507 
1508         uint items = numItems(item);
1509         RLPItem[] memory result = new RLPItem[](items);
1510 
1511         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
1512         uint dataLen;
1513         for (uint i = 0; i < items; i++) {
1514             dataLen = _itemLength(memPtr);
1515             result[i] = RLPItem(dataLen, memPtr); 
1516             memPtr = memPtr + dataLen;
1517         }
1518 
1519         return result;
1520     }
1521 
1522     // @return indicator whether encoded payload is a list. negate this function call for isData.
1523     function isList(RLPItem memory item) internal pure returns (bool) {
1524         if (item.len == 0) return false;
1525 
1526         uint8 byte0;
1527         uint memPtr = item.memPtr;
1528         assembly {
1529             byte0 := byte(0, mload(memPtr))
1530         }
1531 
1532         if (byte0 < LIST_SHORT_START)
1533             return false;
1534         return true;
1535     }
1536 
1537     /*
1538      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
1539      * @return keccak256 hash of RLP encoded bytes.
1540      */
1541     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
1542         uint256 ptr = item.memPtr;
1543         uint256 len = item.len;
1544         bytes32 result;
1545         assembly {
1546             result := keccak256(ptr, len)
1547         }
1548         return result;
1549     }
1550 
1551     /*
1552      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
1553      * @return keccak256 hash of the item payload.
1554      */
1555     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
1556         (uint memPtr, uint len) = payloadLocation(item);
1557         bytes32 result;
1558         assembly {
1559             result := keccak256(memPtr, len)
1560         }
1561         return result;
1562     }
1563 
1564     /** RLPItem conversions into data types **/
1565 
1566     // @returns raw rlp encoding in bytes
1567     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
1568         bytes memory result = new bytes(item.len);
1569         if (result.length == 0) return result;
1570         
1571         uint ptr;
1572         assembly {
1573             ptr := add(0x20, result)
1574         }
1575 
1576         copy(item.memPtr, ptr, item.len);
1577         return result;
1578     }
1579 
1580     // any non-zero byte except "0x80" is considered true
1581     function toBoolean(RLPItem memory item) internal pure returns (bool) {
1582         require(item.len == 1);
1583         uint result;
1584         uint memPtr = item.memPtr;
1585         assembly {
1586             result := byte(0, mload(memPtr))
1587         }
1588 
1589         // SEE Github Issue #5.
1590         // Summary: Most commonly used RLP libraries (i.e Geth) will encode
1591         // "0" as "0x80" instead of as "0". We handle this edge case explicitly
1592         // here.
1593         if (result == 0 || result == STRING_SHORT_START) {
1594             return false;
1595         } else {
1596             return true;
1597         }
1598     }
1599 
1600     function toAddress(RLPItem memory item) internal pure returns (address) {
1601         // 1 byte for the length prefix
1602         require(item.len == 21);
1603 
1604         return address(toUint(item));
1605     }
1606 
1607     function toUint(RLPItem memory item) internal pure returns (uint) {
1608         require(item.len > 0 && item.len <= 33);
1609 
1610         (uint memPtr, uint len) = payloadLocation(item);
1611 
1612         uint result;
1613         assembly {
1614             result := mload(memPtr)
1615 
1616             // shfit to the correct location if neccesary
1617             if lt(len, 32) {
1618                 result := div(result, exp(256, sub(32, len)))
1619             }
1620         }
1621 
1622         return result;
1623     }
1624 
1625     // enforces 32 byte length
1626     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
1627         // one byte prefix
1628         require(item.len == 33);
1629 
1630         uint result;
1631         uint memPtr = item.memPtr + 1;
1632         assembly {
1633             result := mload(memPtr)
1634         }
1635 
1636         return result;
1637     }
1638 
1639     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
1640         require(item.len > 0);
1641 
1642         (uint memPtr, uint len) = payloadLocation(item);
1643         bytes memory result = new bytes(len);
1644 
1645         uint destPtr;
1646         assembly {
1647             destPtr := add(0x20, result)
1648         }
1649 
1650         copy(memPtr, destPtr, len);
1651         return result;
1652     }
1653 
1654     /*
1655     * Private Helpers
1656     */
1657 
1658     // @return number of payload items inside an encoded list.
1659     function numItems(RLPItem memory item) private pure returns (uint) {
1660         if (item.len == 0) return 0;
1661 
1662         uint count = 0;
1663         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
1664         uint endPtr = item.memPtr + item.len;
1665         while (currPtr < endPtr) {
1666            currPtr = currPtr + _itemLength(currPtr); // skip over an item
1667            count++;
1668         }
1669 
1670         return count;
1671     }
1672 
1673     // @return entire rlp item byte length
1674     function _itemLength(uint memPtr) private pure returns (uint) {
1675         uint itemLen;
1676         uint byte0;
1677         assembly {
1678             byte0 := byte(0, mload(memPtr))
1679         }
1680 
1681         if (byte0 < STRING_SHORT_START)
1682             itemLen = 1;
1683         
1684         else if (byte0 < STRING_LONG_START)
1685             itemLen = byte0 - STRING_SHORT_START + 1;
1686 
1687         else if (byte0 < LIST_SHORT_START) {
1688             assembly {
1689                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
1690                 memPtr := add(memPtr, 1) // skip over the first byte
1691                 
1692                 /* 32 byte word size */
1693                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
1694                 itemLen := add(dataLen, add(byteLen, 1))
1695             }
1696         }
1697 
1698         else if (byte0 < LIST_LONG_START) {
1699             itemLen = byte0 - LIST_SHORT_START + 1;
1700         } 
1701 
1702         else {
1703             assembly {
1704                 let byteLen := sub(byte0, 0xf7)
1705                 memPtr := add(memPtr, 1)
1706 
1707                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
1708                 itemLen := add(dataLen, add(byteLen, 1))
1709             }
1710         }
1711 
1712         return itemLen;
1713     }
1714 
1715     // @return number of bytes until the data
1716     function _payloadOffset(uint memPtr) private pure returns (uint) {
1717         uint byte0;
1718         assembly {
1719             byte0 := byte(0, mload(memPtr))
1720         }
1721 
1722         if (byte0 < STRING_SHORT_START) 
1723             return 0;
1724         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
1725             return 1;
1726         else if (byte0 < LIST_SHORT_START)  // being explicit
1727             return byte0 - (STRING_LONG_START - 1) + 1;
1728         else
1729             return byte0 - (LIST_LONG_START - 1) + 1;
1730     }
1731 
1732     /*
1733     * @param src Pointer to source
1734     * @param dest Pointer to destination
1735     * @param len Amount of memory to copy from the source
1736     */
1737     function copy(uint src, uint dest, uint len) private pure {
1738         if (len == 0) return;
1739 
1740         // copy as many word sizes as possible
1741         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
1742             assembly {
1743                 mstore(dest, mload(src))
1744             }
1745 
1746             src += WORD_SIZE;
1747             dest += WORD_SIZE;
1748         }
1749 
1750         // left over bytes. Mask is used to remove unwanted bytes from the word
1751         uint mask = 256 ** (WORD_SIZE - len) - 1;
1752         assembly {
1753             let srcpart := and(mload(src), not(mask)) // zero out src
1754             let destpart := and(mload(dest), mask) // retrieve the bytes
1755             mstore(dest, or(destpart, srcpart))
1756         }
1757     }
1758 }
1759 
1760 
1761 // https://github.com/bakaoh/solidity-rlp-encode/blob/master/contracts/RLPEncode.sol
1762 /**
1763  * @title RLPEncode
1764  * @dev A simple RLP encoding library.
1765  * @author Bakaoh
1766  */
1767 library RLPEncode {
1768     /*
1769      * Internal functions
1770      */
1771 
1772     /**
1773      * @dev RLP encodes a byte string.
1774      * @param self The byte string to encode.
1775      * @return The RLP encoded string in bytes.
1776      */
1777     function encodeBytes(bytes memory self) internal pure returns (bytes memory) {
1778         bytes memory encoded;
1779         if (self.length == 1 && uint8(self[0]) <= 128) {
1780             encoded = self;
1781         } else {
1782             encoded = concat(encodeLength(self.length, 128), self);
1783         }
1784         return encoded;
1785     }
1786 
1787     /**
1788      * @dev RLP encodes a list of RLP encoded byte byte strings.
1789      * @param self The list of RLP encoded byte strings.
1790      * @return The RLP encoded list of items in bytes.
1791      */
1792     function encodeList(bytes[] memory self) internal pure returns (bytes memory) {
1793         bytes memory list = flatten(self);
1794         return concat(encodeLength(list.length, 192), list);
1795     }
1796 
1797     /**
1798      * @dev RLP encodes a string.
1799      * @param self The string to encode.
1800      * @return The RLP encoded string in bytes.
1801      */
1802     function encodeString(string memory self) internal pure returns (bytes memory) {
1803         return encodeBytes(bytes(self));
1804     }
1805 
1806     /** 
1807      * @dev RLP encodes an address.
1808      * @param self The address to encode.
1809      * @return The RLP encoded address in bytes.
1810      */
1811     function encodeAddress(address self) internal pure returns (bytes memory) {
1812         bytes memory inputBytes;
1813         assembly {
1814             let m := mload(0x40)
1815             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, self))
1816             mstore(0x40, add(m, 52))
1817             inputBytes := m
1818         }
1819         return encodeBytes(inputBytes);
1820     }
1821 
1822     /** 
1823      * @dev RLP encodes a uint.
1824      * @param self The uint to encode.
1825      * @return The RLP encoded uint in bytes.
1826      */
1827     function encodeUint(uint self) internal pure returns (bytes memory) {
1828         return encodeBytes(toBinary(self));
1829     }
1830 
1831     /** 
1832      * @dev RLP encodes an int.
1833      * @param self The int to encode.
1834      * @return The RLP encoded int in bytes.
1835      */
1836     function encodeInt(int self) internal pure returns (bytes memory) {
1837         return encodeUint(uint(self));
1838     }
1839 
1840     /** 
1841      * @dev RLP encodes a bool.
1842      * @param self The bool to encode.
1843      * @return The RLP encoded bool in bytes.
1844      */
1845     function encodeBool(bool self) internal pure returns (bytes memory) {
1846         bytes memory encoded = new bytes(1);
1847         encoded[0] = (self ? bytes1(0x01) : bytes1(0x80));
1848         return encoded;
1849     }
1850 
1851 
1852     /*
1853      * Private functions
1854      */
1855 
1856     /**
1857      * @dev Encode the first byte, followed by the `len` in binary form if `length` is more than 55.
1858      * @param len The length of the string or the payload.
1859      * @param offset 128 if item is string, 192 if item is list.
1860      * @return RLP encoded bytes.
1861      */
1862     function encodeLength(uint len, uint offset) private pure returns (bytes memory) {
1863         bytes memory encoded;
1864         if (len < 56) {
1865             encoded = new bytes(1);
1866             encoded[0] = bytes32(len + offset)[31];
1867         } else {
1868             uint lenLen;
1869             uint i = 1;
1870             while (len / i != 0) {
1871                 lenLen++;
1872                 i *= 256;
1873             }
1874 
1875             encoded = new bytes(lenLen + 1);
1876             encoded[0] = bytes32(lenLen + offset + 55)[31];
1877             for(i = 1; i <= lenLen; i++) {
1878                 encoded[i] = bytes32((len / (256**(lenLen-i))) % 256)[31];
1879             }
1880         }
1881         return encoded;
1882     }
1883 
1884     /**
1885      * @dev Encode integer in big endian binary form with no leading zeroes.
1886      * @notice TODO: This should be optimized with assembly to save gas costs.
1887      * @param _x The integer to encode.
1888      * @return RLP encoded bytes.
1889      */
1890     function toBinary(uint _x) private pure returns (bytes memory) {
1891         bytes memory b = new bytes(32);
1892         assembly { 
1893             mstore(add(b, 32), _x) 
1894         }
1895         uint i;
1896         for (i = 0; i < 32; i++) {
1897             if (b[i] != 0) {
1898                 break;
1899             }
1900         }
1901         bytes memory res = new bytes(32 - i);
1902         for (uint j = 0; j < res.length; j++) {
1903             res[j] = b[i++];
1904         }
1905         return res;
1906     }
1907 
1908     /**
1909      * @dev Copies a piece of memory to another location.
1910      * @notice From: https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol.
1911      * @param _dest Destination location.
1912      * @param _src Source location.
1913      * @param _len Length of memory to copy.
1914      */
1915     function memcpy(uint _dest, uint _src, uint _len) private pure {
1916         uint dest = _dest;
1917         uint src = _src;
1918         uint len = _len;
1919 
1920         for(; len >= 32; len -= 32) {
1921             assembly {
1922                 mstore(dest, mload(src))
1923             }
1924             dest += 32;
1925             src += 32;
1926         }
1927 
1928         uint mask = 256 ** (32 - len) - 1;
1929         assembly {
1930             let srcpart := and(mload(src), not(mask))
1931             let destpart := and(mload(dest), mask)
1932             mstore(dest, or(destpart, srcpart))
1933         }
1934     }
1935 
1936     /**
1937      * @dev Flattens a list of byte strings into one byte string.
1938      * @notice From: https://github.com/sammayo/solidity-rlp-encoder/blob/master/RLPEncode.sol.
1939      * @param _list List of byte strings to flatten.
1940      * @return The flattened byte string.
1941      */
1942     function flatten(bytes[] memory _list) private pure returns (bytes memory) {
1943         if (_list.length == 0) {
1944             return new bytes(0);
1945         }
1946 
1947         uint len;
1948         uint i;
1949         for (i = 0; i < _list.length; i++) {
1950             len += _list[i].length;
1951         }
1952 
1953         bytes memory flattened = new bytes(len);
1954         uint flattenedPtr;
1955         assembly { flattenedPtr := add(flattened, 0x20) }
1956 
1957         for(i = 0; i < _list.length; i++) {
1958             bytes memory item = _list[i];
1959             
1960             uint listPtr;
1961             assembly { listPtr := add(item, 0x20)}
1962 
1963             memcpy(flattenedPtr, listPtr, item.length);
1964             flattenedPtr += _list[i].length;
1965         }
1966 
1967         return flattened;
1968     }
1969 
1970     /**
1971      * @dev Concatenates two bytes.
1972      * @notice From: https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol.
1973      * @param _preBytes First byte string.
1974      * @param _postBytes Second byte string.
1975      * @return Both byte string combined.
1976      */
1977     function concat(bytes memory _preBytes, bytes memory _postBytes) private pure returns (bytes memory) {
1978         bytes memory tempBytes;
1979 
1980         assembly {
1981             tempBytes := mload(0x40)
1982 
1983             let length := mload(_preBytes)
1984             mstore(tempBytes, length)
1985 
1986             let mc := add(tempBytes, 0x20)
1987             let end := add(mc, length)
1988 
1989             for {
1990                 let cc := add(_preBytes, 0x20)
1991             } lt(mc, end) {
1992                 mc := add(mc, 0x20)
1993                 cc := add(cc, 0x20)
1994             } {
1995                 mstore(mc, mload(cc))
1996             }
1997 
1998             length := mload(_postBytes)
1999             mstore(tempBytes, add(length, mload(tempBytes)))
2000 
2001             mc := end
2002             end := add(mc, length)
2003 
2004             for {
2005                 let cc := add(_postBytes, 0x20)
2006             } lt(mc, end) {
2007                 mc := add(mc, 0x20)
2008                 cc := add(cc, 0x20)
2009             } {
2010                 mstore(mc, mload(cc))
2011             }
2012 
2013             mstore(0x40, and(
2014               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
2015               not(31)
2016             ))
2017         }
2018 
2019         return tempBytes;
2020     }
2021 }
2022 
2023 
2024 contract Governable is Initializable {
2025     address public governor;
2026 
2027     event GovernorshipTransferred(address indexed previousGovernor, address indexed newGovernor);
2028 
2029     /**
2030      * @dev Contract initializer.
2031      * called once by the factory at time of deployment
2032      */
2033     function __Governable_init_unchained(address governor_) virtual public initializer {
2034         governor = governor_;
2035         emit GovernorshipTransferred(address(0), governor);
2036     }
2037 
2038     modifier governance() {
2039         require(msg.sender == governor);
2040         _;
2041     }
2042 
2043     /**
2044      * @dev Allows the current governor to relinquish control of the contract.
2045      * @notice Renouncing to governorship will leave the contract without an governor.
2046      * It will not be possible to call the functions with the `governance`
2047      * modifier anymore.
2048      */
2049     function renounceGovernorship() public governance {
2050         emit GovernorshipTransferred(governor, address(0));
2051         governor = address(0);
2052     }
2053 
2054     /**
2055      * @dev Allows the current governor to transfer control of the contract to a newGovernor.
2056      * @param newGovernor The address to transfer governorship to.
2057      */
2058     function transferGovernorship(address newGovernor) public governance {
2059         _transferGovernorship(newGovernor);
2060     }
2061 
2062     /**
2063      * @dev Transfers control of the contract to a newGovernor.
2064      * @param newGovernor The address to transfer governorship to.
2065      */
2066     function _transferGovernorship(address newGovernor) internal {
2067         require(newGovernor != address(0));
2068         emit GovernorshipTransferred(governor, newGovernor);
2069         governor = newGovernor;
2070     }
2071 }
2072 
2073 
2074 contract ConfigurableBase {
2075     mapping (bytes32 => uint) internal config;
2076     
2077     function getConfig(bytes32 key) public view returns (uint) {
2078         return config[key];
2079     }
2080     function getConfigI(bytes32 key, uint index) public view returns (uint) {
2081         return config[bytes32(uint(key) ^ index)];
2082     }
2083     function getConfigA(bytes32 key, address addr) public view returns (uint) {
2084         return config[bytes32(uint(key) ^ uint(addr))];
2085     }
2086 
2087     function _setConfig(bytes32 key, uint value) internal {
2088         if(config[key] != value)
2089             config[key] = value;
2090     }
2091     function _setConfig(bytes32 key, uint index, uint value) internal {
2092         _setConfig(bytes32(uint(key) ^ index), value);
2093     }
2094     function _setConfig(bytes32 key, address addr, uint value) internal {
2095         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
2096     }
2097 }    
2098 
2099 contract Configurable is Governable, ConfigurableBase {
2100     function setConfig(bytes32 key, uint value) external governance {
2101         _setConfig(key, value);
2102     }
2103     function setConfigI(bytes32 key, uint index, uint value) external governance {
2104         _setConfig(bytes32(uint(key) ^ index), value);
2105     }
2106     function setConfigA(bytes32 key, address addr, uint value) public governance {
2107         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
2108     }
2109 }
2110 
2111 
2112 // Inheritancea
2113 interface IStakingRewards {
2114     // Views
2115     function lastTimeRewardApplicable() external view returns (uint256);
2116 
2117     function rewardPerToken() external view returns (uint256);
2118 
2119     function rewards(address account) external view returns (uint256);
2120 
2121     function earned(address account) external view returns (uint256);
2122 
2123     function getRewardForDuration() external view returns (uint256);
2124 
2125     function totalSupply() external view returns (uint256);
2126 
2127     function balanceOf(address account) external view returns (uint256);
2128 
2129     // Mutative
2130 
2131     function stake(uint256 amount) external;
2132 
2133     function withdraw(uint256 amount) external;
2134 
2135     function getReward() external;
2136 
2137     function exit() external;
2138 }
2139 
2140 abstract contract RewardsDistributionRecipient {
2141     address public rewardsDistribution;
2142 
2143     function notifyRewardAmount(uint256 reward) virtual external;
2144 
2145     modifier onlyRewardsDistribution() {
2146         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
2147         _;
2148     }
2149 }
2150 
2151 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuardUpgradeSafe {
2152     using SafeMath for uint256;
2153     using SafeERC20 for IERC20;
2154 
2155     /* ========== STATE VARIABLES ========== */
2156 
2157     IERC20 public rewardsToken;
2158     IERC20 public stakingToken;
2159     uint256 public periodFinish = 0;
2160     uint256 public rewardRate = 0;                  // obsoleted
2161     uint256 public rewardsDuration = 60 days;
2162     uint256 public lastUpdateTime;
2163     uint256 public rewardPerTokenStored;
2164 
2165     mapping(address => uint256) public userRewardPerTokenPaid;
2166     mapping(address => uint256) override public rewards;
2167 
2168     uint256 internal _totalSupply;
2169     mapping(address => uint256) internal _balances;
2170 
2171     /* ========== CONSTRUCTOR ========== */
2172 
2173     //constructor(
2174     function __StakingRewards_init(
2175         address _rewardsDistribution,
2176         address _rewardsToken,
2177         address _stakingToken
2178     ) public initializer {
2179         __ReentrancyGuard_init_unchained();
2180         __StakingRewards_init_unchained(_rewardsDistribution, _rewardsToken, _stakingToken);
2181     }
2182     
2183     function __StakingRewards_init_unchained(address _rewardsDistribution, address _rewardsToken, address _stakingToken) public initializer {
2184         rewardsToken = IERC20(_rewardsToken);
2185         stakingToken = IERC20(_stakingToken);
2186         rewardsDistribution = _rewardsDistribution;
2187     }
2188 
2189     /* ========== VIEWS ========== */
2190 
2191     function totalSupply() virtual override public view returns (uint256) {
2192         return _totalSupply;
2193     }
2194 
2195     function balanceOf(address account) virtual override public view returns (uint256) {
2196         return _balances[account];
2197     }
2198 
2199     function lastTimeRewardApplicable() override public view returns (uint256) {
2200         return Math.min(block.timestamp, periodFinish);
2201     }
2202 
2203     function rewardPerToken() virtual override public view returns (uint256) {
2204         if (_totalSupply == 0) {
2205             return rewardPerTokenStored;
2206         }
2207         return
2208             rewardPerTokenStored.add(
2209                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
2210             );
2211     }
2212 
2213     function earned(address account) virtual override public view returns (uint256) {
2214         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
2215     }
2216 
2217     function getRewardForDuration() virtual override external view returns (uint256) {
2218         return rewardRate.mul(rewardsDuration);
2219     }
2220 
2221     /* ========== MUTATIVE FUNCTIONS ========== */
2222 
2223     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) virtual public nonReentrant updateReward(msg.sender) {
2224         require(amount > 0, "Cannot stake 0");
2225         _totalSupply = _totalSupply.add(amount);
2226         _balances[msg.sender] = _balances[msg.sender].add(amount);
2227 
2228         // permit
2229         IPermit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
2230 
2231         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
2232         emit Staked(msg.sender, amount);
2233     }
2234 
2235     function stake(uint256 amount) virtual override public nonReentrant updateReward(msg.sender) {
2236         require(amount > 0, "Cannot stake 0");
2237         _totalSupply = _totalSupply.add(amount);
2238         _balances[msg.sender] = _balances[msg.sender].add(amount);
2239         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
2240         emit Staked(msg.sender, amount);
2241     }
2242 
2243     function withdraw(uint256 amount) virtual override public nonReentrant updateReward(msg.sender) {
2244         require(amount > 0, "Cannot withdraw 0");
2245         _totalSupply = _totalSupply.sub(amount);
2246         _balances[msg.sender] = _balances[msg.sender].sub(amount);
2247         stakingToken.safeTransfer(msg.sender, amount);
2248         emit Withdrawn(msg.sender, amount);
2249     }
2250 
2251     function getReward() virtual override public nonReentrant updateReward(msg.sender) {
2252         uint256 reward = rewards[msg.sender];
2253         if (reward > 0) {
2254             rewards[msg.sender] = 0;
2255             rewardsToken.safeTransfer(msg.sender, reward);
2256             emit RewardPaid(msg.sender, reward);
2257         }
2258     }
2259 
2260     function exit() virtual override public {
2261         withdraw(_balances[msg.sender]);
2262         getReward();
2263     }
2264 
2265     /* ========== RESTRICTED FUNCTIONS ========== */
2266 
2267     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
2268         if (block.timestamp >= periodFinish) {
2269             rewardRate = reward.div(rewardsDuration);
2270         } else {
2271             uint256 remaining = periodFinish.sub(block.timestamp);
2272             uint256 leftover = remaining.mul(rewardRate);
2273             rewardRate = reward.add(leftover).div(rewardsDuration);
2274         }
2275 
2276         // Ensure the provided reward amount is not more than the balance in the contract.
2277         // This keeps the reward rate in the right range, preventing overflows due to
2278         // very high values of rewardRate in the earned and rewardsPerToken functions;
2279         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
2280         uint balance = rewardsToken.balanceOf(address(this));
2281         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
2282 
2283         lastUpdateTime = block.timestamp;
2284         periodFinish = block.timestamp.add(rewardsDuration);
2285         emit RewardAdded(reward);
2286     }
2287 
2288     /* ========== MODIFIERS ========== */
2289 
2290     modifier updateReward(address account) virtual {
2291         rewardPerTokenStored = rewardPerToken();
2292         lastUpdateTime = lastTimeRewardApplicable();
2293         if (account != address(0)) {
2294             rewards[account] = earned(account);
2295             userRewardPerTokenPaid[account] = rewardPerTokenStored;
2296         }
2297         _;
2298     }
2299 
2300     /* ========== EVENTS ========== */
2301 
2302     event RewardAdded(uint256 reward);
2303     event Staked(address indexed user, uint256 amount);
2304     event Withdrawn(address indexed user, uint256 amount);
2305     event RewardPaid(address indexed user, uint256 reward);
2306 }
2307 
2308 interface IPermit {
2309     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2310 }
2311 
2312 
2313 contract Constants {
2314     bytes32 internal constant _TokenMapped_     = 'TokenMapped';
2315     bytes32 internal constant _MappableToken_   = 'MappableToken';
2316     bytes32 internal constant _MappingToken_    = 'MappingToken';
2317     bytes32 internal constant _fee_             = 'fee';
2318     bytes32 internal constant _feeCreate_       = 'feeCreate';
2319     bytes32 internal constant _feeRegister_     = 'feeRegister';
2320     bytes32 internal constant _feeTo_           = 'feeTo';
2321     bytes32 internal constant _onlyDeployer_    = 'onlyDeployer';
2322     bytes32 internal constant _minSignatures_   = 'minSignatures';
2323     bytes32 internal constant _initQuotaRatio_  = 'initQuotaRatio';
2324     bytes32 internal constant _autoQuotaRatio_  = 'autoQuotaRatio';
2325     bytes32 internal constant _autoQuotaPeriod_ = 'autoQuotaPeriod';
2326     //bytes32 internal constant _uniswapRounter_  = 'uniswapRounter';
2327     
2328     function _chainId() internal pure returns (uint id) {
2329         assembly { id := chainid() }
2330     }
2331 }
2332 
2333 struct Signature {
2334     address signatory;
2335     uint8   v;
2336     bytes32 r;
2337     bytes32 s;
2338 }
2339 
2340 abstract contract MappingBase is ContextUpgradeSafe, Constants {
2341 	using SafeMath for uint;
2342 
2343     bytes32 public constant RECEIVE_TYPEHASH = keccak256("Receive(uint256 fromChainId,address to,uint256 nonce,uint256 volume,address signatory)");
2344     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2345     bytes32 internal _DOMAIN_SEPARATOR;
2346     function DOMAIN_SEPARATOR() virtual public view returns (bytes32) {  return _DOMAIN_SEPARATOR;  }
2347 
2348     address public factory;
2349     uint256 public mainChainId;
2350     address public token;
2351     address public deployer;
2352     
2353     mapping (address => uint) internal _authQuotas;                                     // signatory => quota
2354     mapping (uint => mapping (address => uint)) public sentCount;                       // toChainId => to => sentCount
2355     mapping (uint => mapping (address => mapping (uint => uint))) public sent;          // toChainId => to => nonce => volume
2356     mapping (uint => mapping (address => mapping (uint => uint))) public received;      // fromChainId => to => nonce => volume
2357     mapping (address => uint) public lasttimeUpdateQuotaOf;                             // signatory => lasttime
2358     uint public autoQuotaRatio;
2359     uint public autoQuotaPeriod;
2360     
2361     function setAutoQuota(uint ratio, uint period) virtual external onlyFactory {
2362         autoQuotaRatio  = ratio;
2363         autoQuotaPeriod = period;
2364     }
2365     
2366     modifier onlyFactory {
2367         require(msg.sender == factory, 'Only called by Factory');
2368         _;
2369     }
2370     
2371     modifier updateAutoQuota(address signatory) virtual {
2372         uint quota = authQuotaOf(signatory);
2373         if(_authQuotas[signatory] != quota) {
2374             _authQuotas[signatory] = quota;
2375             lasttimeUpdateQuotaOf[signatory] = now;
2376         }
2377         _;
2378     }
2379     
2380     function authQuotaOf(address signatory) virtual public view returns (uint quota) {
2381         quota = _authQuotas[signatory];
2382         uint ratio  = autoQuotaRatio  != 0 ? autoQuotaRatio  : Factory(factory).getConfig(_autoQuotaRatio_);
2383         uint period = autoQuotaPeriod != 0 ? autoQuotaPeriod : Factory(factory).getConfig(_autoQuotaPeriod_);
2384         if(ratio == 0 || period == 0 || period == uint(-1))
2385             return quota;
2386         uint quotaCap = cap().mul(ratio).div(1e18);
2387         uint delta = quotaCap.mul(now.sub(lasttimeUpdateQuotaOf[signatory])).div(period);
2388         return Math.max(quota, Math.min(quotaCap, quota.add(delta)));
2389     }
2390     
2391     function cap() public view virtual returns (uint);
2392 
2393     function increaseAuthQuotas(address[] memory signatories, uint[] memory increments) virtual external returns (uint[] memory quotas) {
2394         require(signatories.length == increments.length, 'two array lenth not equal');
2395         quotas = new uint[](signatories.length);
2396         for(uint i=0; i<signatories.length; i++)
2397             quotas[i] = increaseAuthQuota(signatories[i], increments[i]);
2398     }
2399     
2400     function increaseAuthQuota(address signatory, uint increment) virtual public updateAutoQuota(signatory) onlyFactory returns (uint quota) {
2401         quota = _authQuotas[signatory].add(increment);
2402         _authQuotas[signatory] = quota;
2403         emit IncreaseAuthQuota(signatory, increment, quota);
2404     }
2405     event IncreaseAuthQuota(address indexed signatory, uint increment, uint quota);
2406     
2407     function decreaseAuthQuotas(address[] memory signatories, uint[] memory decrements) virtual external returns (uint[] memory quotas) {
2408         require(signatories.length == decrements.length, 'two array lenth not equal');
2409         quotas = new uint[](signatories.length);
2410         for(uint i=0; i<signatories.length; i++)
2411             quotas[i] = decreaseAuthQuota(signatories[i], decrements[i]);
2412     }
2413     
2414     function decreaseAuthQuota(address signatory, uint decrement) virtual public onlyFactory returns (uint quota) {
2415         quota = authQuotaOf(signatory);
2416         if(quota < decrement)
2417             decrement = quota;
2418         return _decreaseAuthQuota(signatory, decrement);
2419     }
2420     
2421     function _decreaseAuthQuota(address signatory, uint decrement) virtual internal updateAutoQuota(signatory) returns (uint quota) {
2422         quota = _authQuotas[signatory].sub(decrement);
2423         _authQuotas[signatory] = quota;
2424         emit DecreaseAuthQuota(signatory, decrement, quota);
2425     }
2426     event DecreaseAuthQuota(address indexed signatory, uint decrement, uint quota);
2427     
2428 
2429     function needApprove() virtual public pure returns (bool);
2430     
2431     function send(uint toChainId, address to, uint volume) virtual external payable returns (uint nonce) {
2432         return sendFrom(_msgSender(), toChainId, to, volume);
2433     }
2434     
2435     function sendFrom(address from, uint toChainId, address to, uint volume) virtual public payable returns (uint nonce) {
2436         _chargeFee();
2437         _sendFrom(from, volume);
2438         nonce = sentCount[toChainId][to]++;
2439         sent[toChainId][to][nonce] = volume;
2440         emit Send(from, toChainId, to, nonce, volume);
2441     }
2442     event Send(address indexed from, uint indexed toChainId, address indexed to, uint nonce, uint volume);
2443     
2444     function _sendFrom(address from, uint volume) virtual internal;
2445 
2446     function receive(uint256 fromChainId, address to, uint256 nonce, uint256 volume, Signature[] memory signatures) virtual external payable {
2447         _chargeFee();
2448         require(received[fromChainId][to][nonce] == 0, 'withdrawn already');
2449         uint N = signatures.length;
2450         require(N >= Factory(factory).getConfig(_minSignatures_), 'too few signatures');
2451         for(uint i=0; i<N; i++) {
2452             for(uint j=0; j<i; j++)
2453                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2454             bytes32 structHash = keccak256(abi.encode(RECEIVE_TYPEHASH, fromChainId, to, nonce, volume, signatures[i].signatory));
2455             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", _DOMAIN_SEPARATOR, structHash));
2456             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
2457             require(signatory != address(0), "invalid signature");
2458             require(signatory == signatures[i].signatory, "unauthorized");
2459             _decreaseAuthQuota(signatures[i].signatory, volume);
2460             emit Authorize(fromChainId, to, nonce, volume, signatory);
2461         }
2462         received[fromChainId][to][nonce] = volume;
2463         _receive(to, volume);
2464         emit Receive(fromChainId, to, nonce, volume);
2465     }
2466     event Receive(uint256 indexed fromChainId, address indexed to, uint256 indexed nonce, uint256 volume);
2467     event Authorize(uint256 fromChainId, address indexed to, uint256 indexed nonce, uint256 volume, address indexed signatory);
2468     
2469     function _receive(address to, uint256 volume) virtual internal;
2470     
2471     function _chargeFee() virtual internal {
2472         require(msg.value >= Math.min(Factory(factory).getConfig(_fee_), 0.1 ether), 'fee is too low');
2473         address payable feeTo = address(Factory(factory).getConfig(_feeTo_));
2474         if(feeTo == address(0))
2475             feeTo = address(uint160(factory));
2476         feeTo.transfer(msg.value);
2477         emit ChargeFee(_msgSender(), feeTo, msg.value);
2478     }
2479     event ChargeFee(address indexed from, address indexed to, uint value);
2480 
2481     uint256[47] private __gap;
2482 }    
2483     
2484     
2485 contract TokenMapped is MappingBase {
2486     using SafeERC20 for IERC20;
2487     
2488 	function __TokenMapped_init(address factory_, address token_) external initializer {
2489         __Context_init_unchained();
2490 		__TokenMapped_init_unchained(factory_, token_);
2491 	}
2492 	
2493 	function __TokenMapped_init_unchained(address factory_, address token_) public initializer {
2494         factory = factory_;
2495         mainChainId = _chainId();
2496         token = token_;
2497         deployer = address(0);
2498         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(ERC20UpgradeSafe(token).name())), _chainId(), address(this)));
2499 	}
2500 	
2501     function cap() virtual override public view returns (uint) {
2502         return IERC20(token).totalSupply();
2503     }
2504     
2505     function totalMapped() virtual public view returns (uint) {
2506         return IERC20(token).balanceOf(address(this));
2507     }
2508     
2509     function needApprove() virtual override public pure returns (bool) {
2510         return true;
2511     }
2512     
2513     function _sendFrom(address from, uint volume) virtual override internal {
2514         IERC20(token).safeTransferFrom(from, address(this), volume);
2515     }
2516 
2517     function _receive(address to, uint256 volume) virtual override internal {
2518         IERC20(token).safeTransfer(to, volume);
2519     }
2520 
2521     uint256[50] private __gap;
2522 }
2523 /*
2524 contract TokenMapped2 is TokenMapped, StakingRewards, ConfigurableBase {
2525     modifier governance {
2526         require(_msgSender() == MappingTokenFactory(factory).governor());
2527         _;
2528     }
2529     
2530     function setConfig(bytes32 key, uint value) external governance {
2531         _setConfig(key, value);
2532     }
2533     function setConfigI(bytes32 key, uint index, uint value) external governance {
2534         _setConfig(bytes32(uint(key) ^ index), value);
2535     }
2536     function setConfigA(bytes32 key, address addr, uint value) public governance {
2537         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
2538     }
2539 
2540     function rewardDelta() public view returns (uint amt) {
2541         if(begin == 0 || begin >= now || lastUpdateTime >= now)
2542             return 0;
2543             
2544         amt = rewardsToken.allowance(rewardsDistribution, address(this)).sub0(rewards[address(0)]);
2545         
2546         // calc rewardDelta in period
2547         if(lep == 3) {                                                              // power
2548             uint y = period.mul(1 ether).div(lastUpdateTime.add(rewardsDuration).sub(begin));
2549             uint amt1 = amt.mul(1 ether).div(y);
2550             uint amt2 = amt1.mul(period).div(now.add(rewardsDuration).sub(begin));
2551             amt = amt.sub(amt2);
2552         } else if(lep == 2) {                                                       // exponential
2553             if(now.sub(lastUpdateTime) < rewardsDuration)
2554                 amt = amt.mul(now.sub(lastUpdateTime)).div(rewardsDuration);
2555         }else if(now < periodFinish)                                                // linear
2556             amt = amt.mul(now.sub(lastUpdateTime)).div(periodFinish.sub(lastUpdateTime));
2557         else if(lastUpdateTime >= periodFinish)
2558             amt = 0;
2559     }
2560     
2561     function rewardPerToken() virtual override public view returns (uint256) {
2562         if (_totalSupply == 0) {
2563             return rewardPerTokenStored;
2564         }
2565         return
2566             rewardPerTokenStored.add(
2567                 rewardDelta().mul(1e18).div(_totalSupply)
2568             );
2569     }
2570 
2571     modifier updateReward(address account) virtual override {
2572         (uint delta, uint d) = (rewardDelta(), 0);
2573         rewardPerTokenStored = rewardPerToken();
2574         lastUpdateTime = now;
2575         if (account != address(0)) {
2576             rewards[account] = earned(account);
2577             userRewardPerTokenPaid[account] = rewardPerTokenStored;
2578         }
2579 
2580         address addr = address(config[_ecoAddr_]);
2581         uint ratio = config[_ecoRatio_];
2582         if(addr != address(0) && ratio != 0) {
2583             d = delta.mul(ratio).div(1 ether);
2584             rewards[addr] = rewards[addr].add(d);
2585         }
2586         rewards[address(0)] = rewards[address(0)].add(delta).add(d);
2587         _;
2588     }
2589 
2590     function getReward() virtual override public {
2591         getReward(msg.sender);
2592     }
2593     function getReward(address payable acct) virtual public nonReentrant updateReward(acct) {
2594         require(acct != address(0), 'invalid address');
2595         require(getConfig(_blocklist_, acct) == 0, 'In blocklist');
2596         bool isContract = acct.isContract();
2597         require(!isContract || config[_allowContract_] != 0 || getConfig(_allowlist_, acct) != 0, 'No allowContract');
2598 
2599         uint256 reward = rewards[acct];
2600         if (reward > 0) {
2601             paid[acct] = paid[acct].add(reward);
2602             paid[address(0)] = paid[address(0)].add(reward);
2603             rewards[acct] = 0;
2604             rewards[address(0)] = rewards[address(0)].sub0(reward);
2605             rewardsToken.safeTransferFrom(rewardsDistribution, acct, reward);
2606             emit RewardPaid(acct, reward);
2607         }
2608     }
2609 
2610     function getRewardForDuration() override external view returns (uint256) {
2611         return rewardsToken.allowance(rewardsDistribution, address(this)).sub0(rewards[address(0)]);
2612     }
2613     
2614 }
2615 */
2616 
2617 abstract contract Permit {
2618     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
2619     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
2620     function DOMAIN_SEPARATOR() virtual public view returns (bytes32);
2621 
2622     mapping (address => uint) public nonces;
2623 
2624     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
2625         require(deadline >= block.timestamp, 'permit EXPIRED');
2626         bytes32 digest = keccak256(
2627             abi.encodePacked(
2628                 '\x19\x01',
2629                 DOMAIN_SEPARATOR(),
2630                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
2631             )
2632         );
2633         address recoveredAddress = ecrecover(digest, v, r, s);
2634         require(recoveredAddress != address(0) && recoveredAddress == owner, 'permit INVALID_SIGNATURE');
2635         _approve(owner, spender, value);
2636     }
2637 
2638     function _approve(address owner, address spender, uint256 amount) internal virtual;    
2639 
2640     uint256[50] private __gap;
2641 }
2642 
2643 contract MappableToken is Permit, ERC20UpgradeSafe, MappingBase {
2644 	function __MappableToken_init(address factory_, address deployer_, string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) external initializer {
2645         __Context_init_unchained();
2646 		__ERC20_init_unchained(name_, symbol_);
2647 		_setupDecimals(decimals_);
2648 		_mint(deployer_, totalSupply_);
2649 		__MappableToken_init_unchained(factory_, deployer_);
2650 	}
2651 	
2652 	function __MappableToken_init_unchained(address factory_, address deployer_) public initializer {
2653         factory = factory_;
2654         mainChainId = _chainId();
2655         token = address(0);
2656         deployer = deployer_;
2657         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
2658 	}
2659 	
2660     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
2661         return MappingBase.DOMAIN_SEPARATOR();
2662     }
2663     
2664     function cap() virtual override public view returns (uint) {
2665         return totalSupply();
2666     }
2667     
2668     function totalMapped() virtual public view returns (uint) {
2669         return balanceOf(address(this));
2670     }
2671     
2672     function needApprove() virtual override public pure returns (bool) {
2673         return false;
2674     }
2675     
2676     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
2677         return ERC20UpgradeSafe._approve(owner, spender, amount);
2678     }
2679     
2680     function _sendFrom(address from, uint volume) virtual override internal {
2681         transferFrom(from, address(this), volume);
2682     }
2683 
2684     function _receive(address to, uint256 volume) virtual override internal {
2685         _transfer(address(this), to, volume);
2686     }
2687 
2688     uint256[50] private __gap;
2689 }
2690 
2691 
2692 contract MappingToken is Permit, ERC20CappedUpgradeSafe, MappingBase {
2693 	function __MappingToken_init(address factory_, uint mainChainId_, address token_, address deployer_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) external initializer {
2694         __Context_init_unchained();
2695 		__ERC20_init_unchained(name_, symbol_);
2696 		_setupDecimals(decimals_);
2697 		__ERC20Capped_init_unchained(cap_);
2698 		__MappingToken_init_unchained(factory_, mainChainId_, token_, deployer_);
2699 	}
2700 	
2701 	function __MappingToken_init_unchained(address factory_, uint mainChainId_, address token_, address deployer_) public initializer {
2702         factory = factory_;
2703         mainChainId = mainChainId_;
2704         token = token_;
2705         deployer = (token_ == address(0)) ? deployer_ : address(0);
2706         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
2707 	}
2708 	
2709     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
2710         return MappingBase.DOMAIN_SEPARATOR();
2711     }
2712     
2713     function cap() virtual override(ERC20CappedUpgradeSafe, MappingBase) public view returns (uint) {
2714         return ERC20CappedUpgradeSafe.cap();
2715     }
2716     
2717     function needApprove() virtual override public pure returns (bool) {
2718         return false;
2719     }
2720     
2721     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
2722         return ERC20UpgradeSafe._approve(owner, spender, amount);
2723     }
2724     
2725     function _sendFrom(address from, uint volume) virtual override internal {
2726         _burn(from, volume);
2727         if(from != _msgSender() && allowance(from, _msgSender()) != uint(-1))
2728             _approve(from, _msgSender(), allowance(from, _msgSender()).sub(volume, "ERC20: transfer volume exceeds allowance"));
2729     }
2730 
2731     function _receive(address to, uint256 volume) virtual override internal {
2732         _mint(to, volume);
2733     }
2734 
2735     uint256[50] private __gap;
2736 }
2737 
2738 
2739 contract MappingTokenProxy is ProductProxy, Constants {
2740     constructor(address factory_, uint mainChainId_, address token_, address deployer_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) public {
2741         //require(_factory() == address(0));
2742         assert(FACTORY_SLOT == bytes32(uint256(keccak256('eip1967.proxy.factory')) - 1));
2743         assert(NAME_SLOT    == bytes32(uint256(keccak256('eip1967.proxy.name')) - 1));
2744         _setFactory(factory_);
2745         _setName(_MappingToken_);
2746         (bool success,) = _implementation().delegatecall(abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', factory_, mainChainId_, token_, deployer_, name_, symbol_, decimals_, cap_));
2747         require(success);
2748     }  
2749 }
2750 
2751 
2752 contract Factory is ContextUpgradeSafe, Configurable, Constants {
2753     using SafeERC20 for IERC20;
2754     using SafeMath for uint;
2755 
2756     bytes32 public constant REGISTER_TYPEHASH   = keccak256("RegisterMapping(uint mainChainId,address token,uint[] chainIds,address[] mappingTokenMappeds,address signatory)");
2757     bytes32 public constant CREATE_TYPEHASH     = keccak256("CreateMappingToken(address deployer,uint mainChainId,address token,string name,string symbol,uint8 decimals,uint cap,address signatory)");
2758     bytes32 public constant DOMAIN_TYPEHASH     = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2759     bytes32 public DOMAIN_SEPARATOR;
2760 
2761     mapping (bytes32 => address) public productImplementations;
2762     mapping (address => address) public tokenMappeds;                // token => tokenMapped
2763     mapping (address => address) public mappableTokens;              // deployer => mappableTokens
2764     mapping (uint256 => mapping (address => address)) public mappingTokens;     // mainChainId => token or deployer => mappableTokens
2765     mapping (address => bool) public authorties;
2766     
2767     // only on ethereum mainnet
2768     mapping (address => uint) public authCountOf;                   // signatory => count
2769     mapping (address => uint256) internal _mainChainIdTokens;       // mappingToken => mainChainId+token
2770     mapping (address => mapping (uint => address)) public mappingTokenMappeds;  // token => chainId => mappingToken or tokenMapped
2771     uint[] public supportChainIds;
2772     mapping (string  => uint256) internal _certifiedTokens;         // symbol => mainChainId+token
2773     string[] public certifiedSymbols;
2774     address[] public signatories;
2775 
2776     function __MappingTokenFactory_init(address _governor, address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) external initializer {
2777         __Governable_init_unchained(_governor);
2778         __MappingTokenFactory_init_unchained(_implTokenMapped, _implMappableToken, _implMappingToken, _feeTo);
2779     }
2780     
2781     function __MappingTokenFactory_init_unchained(address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) public governance {
2782         config[_fee_]                           = 0.005 ether;
2783         config[_feeCreate_]                     = 0.100 ether;
2784         config[_feeRegister_]                   = 0.200 ether;
2785         config[_feeTo_]                         = uint(_feeTo);
2786         config[_onlyDeployer_]                  = 1;
2787         config[_minSignatures_]                 = 3;
2788         config[_initQuotaRatio_]                = 0.100 ether;  // 10%
2789         config[_autoQuotaRatio_]                = 0.010 ether;  //  1%
2790         config[_autoQuotaPeriod_]               = 1 days;
2791         //config[_uniswapRounter_]                = uint(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
2792 
2793         DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes('MappingTokenFactory')), _chainId(), address(this)));
2794         upgradeProductImplementationsTo_(_implTokenMapped, _implMappableToken, _implMappingToken);
2795         emit ProductProxyCodeHash(keccak256(type(InitializableProductProxy).creationCode));
2796     }
2797     event ProductProxyCodeHash(bytes32 codeHash);
2798 
2799     function upgradeProductImplementationsTo_(address _implTokenMapped, address _implMappableToken, address _implMappingToken) public governance {
2800         productImplementations[_TokenMapped_]   = _implTokenMapped;
2801         productImplementations[_MappableToken_] = _implMappableToken;
2802         productImplementations[_MappingToken_]  = _implMappingToken;
2803     }
2804     
2805     function setSignatories(address[] calldata signatories_) virtual external governance {
2806         signatories = signatories_;
2807         emit SetSignatories(signatories_);
2808     }
2809     event SetSignatories(address[] signatories_);
2810     
2811     function setAuthorty_(address authorty, bool enable) virtual external governance {
2812         authorties[authorty] = enable;
2813         emit SetAuthorty(authorty, enable);
2814     }
2815     event SetAuthorty(address indexed authorty, bool indexed enable);
2816     
2817     function setAutoQuota(address mappingTokenMapped, uint ratio, uint period) virtual external governance {
2818         if(mappingTokenMapped == address(0)) {
2819             config[_autoQuotaRatio_]  = ratio;
2820             config[_autoQuotaPeriod_] = period;
2821         } else
2822             MappingBase(mappingTokenMapped).setAutoQuota(ratio, period);
2823     }
2824     
2825     modifier onlyAuthorty {
2826         require(authorties[_msgSender()], 'only authorty');
2827         _;
2828     }
2829     
2830     function _initAuthQuotas(address mappingTokenMapped, uint cap) internal {
2831         uint quota = cap.mul(config[_initQuotaRatio_]).div(1e18);
2832         uint[] memory quotas = new uint[](signatories.length);
2833         for(uint i=0; i<quotas.length; i++)
2834             quotas[i] = quota;
2835         _increaseAuthQuotas(mappingTokenMapped, signatories, quotas);
2836     }
2837     
2838     function _increaseAuthQuotas(address mappingTokenMapped, address[] memory signatories_, uint[] memory increments) virtual internal returns (uint[] memory quotas) {
2839         quotas = MappingBase(mappingTokenMapped).increaseAuthQuotas(signatories_, increments);
2840         for(uint i=0; i<signatories_.length; i++)
2841             emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatories_[i], increments[i], quotas[i]);
2842     }
2843     function increaseAuthQuotas_(address mappingTokenMapped, uint[] memory increments) virtual external onlyAuthorty returns (uint[] memory quotas) {
2844         return _increaseAuthQuotas(mappingTokenMapped, signatories, increments);
2845     }
2846     function increaseAuthQuotas(address mappingTokenMapped, address[] memory signatories_, uint[] memory increments) virtual external onlyAuthorty returns (uint[] memory quotas) {
2847         return _increaseAuthQuotas(mappingTokenMapped, signatories_, increments);
2848     }
2849     
2850     function increaseAuthQuota(address mappingTokenMapped, address signatory, uint increment) virtual external onlyAuthorty returns (uint quota) {
2851         quota = MappingBase(mappingTokenMapped).increaseAuthQuota(signatory, increment);
2852         emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, increment, quota);
2853     }
2854     event IncreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint increment, uint quota);
2855     
2856     function decreaseAuthQuotas_(address mappingTokenMapped, uint[] memory decrements) virtual external returns (uint[] memory quotas) {
2857         return decreaseAuthQuotas(mappingTokenMapped, signatories, decrements);
2858     }
2859     function decreaseAuthQuotas(address mappingTokenMapped, address[] memory signatories_, uint[] memory decrements) virtual public onlyAuthorty returns (uint[] memory quotas) {
2860         quotas = MappingBase(mappingTokenMapped).decreaseAuthQuotas(signatories_, decrements);
2861         for(uint i=0; i<signatories_.length; i++)
2862             emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatories_[i], decrements[i], quotas[i]);
2863     }
2864     
2865     function decreaseAuthQuota(address mappingTokenMapped, address signatory, uint decrement) virtual external onlyAuthorty returns (uint quota) {
2866         quota = MappingBase(mappingTokenMapped).decreaseAuthQuota(signatory, decrement);
2867         emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, decrement, quota);
2868     }
2869     event DecreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint decrement, uint quota);
2870 
2871     function increaseAuthCounts_(uint[] memory increments) virtual external returns (uint[] memory counts) {
2872         return increaseAuthCounts(signatories, increments);
2873     }
2874     function increaseAuthCounts(address[] memory signatories_, uint[] memory increments) virtual public returns (uint[] memory counts) {
2875         require(signatories_.length == increments.length, 'two array lenth not equal');
2876         counts = new uint[](signatories_.length);
2877         for(uint i=0; i<signatories_.length; i++)
2878             counts[i] = increaseAuthCount(signatories_[i], increments[i]);
2879     }
2880     
2881     function increaseAuthCount(address signatory, uint increment) virtual public onlyAuthorty returns (uint count) {
2882         count = authCountOf[signatory].add(increment);
2883         authCountOf[signatory] = count;
2884         emit IncreaseAuthQuota(_msgSender(), signatory, increment, count);
2885     }
2886     event IncreaseAuthQuota(address indexed authorty, address indexed signatory, uint increment, uint quota);
2887     
2888     function decreaseAuthCounts_(uint[] memory decrements) virtual external returns (uint[] memory counts) {
2889         return decreaseAuthCounts(signatories, decrements);
2890     }
2891     function decreaseAuthCounts(address[] memory signatories_, uint[] memory decrements) virtual public returns (uint[] memory counts) {
2892         require(signatories_.length == decrements.length, 'two array lenth not equal');
2893         counts = new uint[](signatories_.length);
2894         for(uint i=0; i<signatories_.length; i++)
2895             counts[i] = decreaseAuthCount(signatories_[i], decrements[i]);
2896     }
2897     
2898     function decreaseAuthCount(address signatory, uint decrement) virtual public onlyAuthorty returns (uint count) {
2899         count = authCountOf[signatory];
2900         if(count < decrement)
2901             decrement = count;
2902         return _decreaseAuthCount(signatory, decrement);
2903     }
2904     
2905     function _decreaseAuthCount(address signatory, uint decrement) virtual internal returns (uint count) {
2906         count = authCountOf[signatory].sub(decrement);
2907         authCountOf[signatory] = count;
2908         emit DecreaseAuthCount(_msgSender(), signatory, decrement, count);
2909     }
2910     event DecreaseAuthCount(address indexed authorty, address indexed signatory, uint decrement, uint count);
2911 
2912     function supportChainCount() public view returns (uint) {
2913         return supportChainIds.length;
2914     }
2915     
2916     function mainChainIdTokens(address mappingToken) virtual public view returns(uint mainChainId, address token) {
2917         uint256 chainIdToken = _mainChainIdTokens[mappingToken];
2918         mainChainId = chainIdToken >> 160;
2919         token = address(chainIdToken);
2920     }
2921     
2922     function chainIdMappingTokenMappeds(address tokenOrMappingToken) virtual external view returns (uint[] memory chainIds, address[] memory mappingTokenMappeds_) {
2923         (, address token) = mainChainIdTokens(tokenOrMappingToken);
2924         if(token == address(0))
2925             token = tokenOrMappingToken;
2926         uint N = 0;
2927         for(uint i=0; i<supportChainCount(); i++)
2928             if(mappingTokenMappeds[token][supportChainIds[i]] != address(0))
2929                 N++;
2930         chainIds = new uint[](N);
2931         mappingTokenMappeds_ = new address[](N);
2932         uint j = 0;
2933         for(uint i=0; i<supportChainCount(); i++) {
2934             uint chainId = supportChainIds[i];
2935             address mappingTokenMapped = mappingTokenMappeds[token][chainId];
2936             if(mappingTokenMapped != address(0)) {
2937                 chainIds[j] = chainId;
2938                 mappingTokenMappeds_[j] = mappingTokenMapped;
2939                 j++;
2940             }
2941         }
2942     }
2943     
2944     function isSupportChainId(uint chainId) virtual public view returns (bool) {
2945         for(uint i=0; i<supportChainCount(); i++)
2946             if(supportChainIds[i] == chainId)
2947                 return true;
2948         return false;
2949     }
2950     
2951     function registerSupportChainId_(uint chainId_) virtual external governance {
2952         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2953         require(!isSupportChainId(chainId_), 'support chainId already');
2954         supportChainIds.push(chainId_);
2955     }
2956     
2957     function _registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual internal {
2958         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
2959         require(chainIds.length == mappingTokenMappeds_.length, 'two array lenth not equal');
2960         require(isSupportChainId(mainChainId), 'Not support mainChainId');
2961         for(uint i=0; i<chainIds.length; i++) {
2962             require(isSupportChainId(chainIds[i]), 'Not support chainId');
2963             require(token == mappingTokenMappeds_[i] || mappingTokenMappeds_[i] == calcMapping(mainChainId, token) || _msgSender() == governor, 'invalid mappingTokenMapped address');
2964             //require(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0 || _mainChainIdTokens[mappingTokenMappeds_[i]] == (mainChainId << 160) | uint(token), 'mainChainIdTokens exist already');
2965             //require(mappingTokenMappeds[token][chainIds[i]] == address(0), 'mappingTokenMappeds exist already');
2966             //if(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0)
2967                 _mainChainIdTokens[mappingTokenMappeds_[i]] = (mainChainId << 160) | uint(token);
2968             mappingTokenMappeds[token][chainIds[i]] = mappingTokenMappeds_[i];
2969             emit RegisterMapping(mainChainId, token, chainIds[i], mappingTokenMappeds_[i]);
2970         }
2971     }
2972     event RegisterMapping(uint mainChainId, address token, uint chainId, address mappingTokenMapped);
2973     
2974     function registerMapping_(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual external governance {
2975         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
2976     }
2977     
2978     function registerMapping(uint mainChainId, address token, uint nonce, uint[] memory chainIds, address[] memory mappingTokenMappeds_, Signature[] memory signatures) virtual external payable {
2979         _chargeFee(config[_feeRegister_]);
2980         require(config[_onlyDeployer_] == 0 || token == calcContract(_msgSender(), nonce), 'only deployer');
2981         uint N = signatures.length;
2982         require(N >= getConfig(_minSignatures_), 'too few signatures');
2983         for(uint i=0; i<N; i++) {
2984             for(uint j=0; j<i; j++)
2985                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2986             bytes32 structHash = keccak256(abi.encode(REGISTER_TYPEHASH, mainChainId, token, keccak256(abi.encodePacked(chainIds)), keccak256(abi.encodePacked(mappingTokenMappeds_)), signatures[i].signatory));
2987             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
2988             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
2989             require(signatory != address(0), "invalid signature");
2990             require(signatory == signatures[i].signatory, "unauthorized");
2991             _decreaseAuthCount(signatures[i].signatory, 1);
2992             emit AuthorizeRegister(mainChainId, token, signatory);
2993         }
2994         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
2995     }
2996     event AuthorizeRegister(uint indexed mainChainId, address indexed token, address indexed signatory);
2997 
2998     function certifiedCount() external view returns (uint) {
2999         return certifiedSymbols.length;
3000     }
3001     
3002     function certifiedTokens(string memory symbol) public view returns (uint mainChainId, address token) {
3003         uint256 chainIdToken = _certifiedTokens[symbol];
3004         mainChainId = chainIdToken >> 160;
3005         token = address(chainIdToken);
3006     }
3007     
3008     function allCertifiedTokens() external view returns (string[] memory symbols, uint[] memory chainIds, address[] memory tokens) {
3009         symbols = certifiedSymbols;
3010         uint N = certifiedSymbols.length;
3011         chainIds = new uint[](N);
3012         tokens = new address[](N);
3013         for(uint i=0; i<N; i++)
3014             (chainIds[i], tokens[i]) = certifiedTokens(certifiedSymbols[i]);
3015     }
3016 
3017     function registerCertified_(string memory symbol, uint mainChainId, address token) external governance {
3018         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
3019         require(isSupportChainId(mainChainId), 'Not support mainChainId');
3020         require(_certifiedTokens[symbol] == 0, 'Certified added already');
3021         if(mainChainId == _chainId())
3022             require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
3023         _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
3024         certifiedSymbols.push(symbol);
3025         emit RegisterCertified(symbol, mainChainId, token);
3026     }
3027     event RegisterCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
3028     
3029     //function updateCertified_(string memory symbol, uint mainChainId, address token) external governance {
3030     //    require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
3031     //    require(isSupportChainId(mainChainId), 'Not support mainChainId');
3032     //    //require(_certifiedTokens[symbol] == 0, 'Certified added already');
3033     //    if(mainChainId == _chainId())
3034     //        require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
3035     //    _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
3036     //    //certifiedSymbols.push(symbol);
3037     //    emit UpdateCertified(symbol, mainChainId, token);
3038     //}
3039     //event UpdateCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
3040     
3041     function calcContract(address deployer, uint nonce) public pure returns (address) {
3042         bytes[] memory list = new bytes[](2);
3043         list[0] = RLPEncode.encodeAddress(deployer);
3044         list[1] = RLPEncode.encodeUint(nonce);
3045         return address(uint(keccak256(RLPEncode.encodeList(list))));
3046     }
3047     
3048     // calculates the CREATE2 address for a pair without making any external calls
3049     function calcMapping(uint mainChainId, address tokenOrdeployer) public view returns (address) {
3050         return address(uint(keccak256(abi.encodePacked(
3051                 hex'ff',
3052                 address(this),
3053                 keccak256(abi.encodePacked(mainChainId, tokenOrdeployer)),
3054 				keccak256(type(InitializableProductProxy).creationCode)                    //hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
3055             ))));
3056     }
3057 
3058     function createTokenMapped(address token, uint nonce) external payable returns (address tokenMapped) {
3059         if(_msgSender() != governor) {
3060             _chargeFee(config[_feeCreate_]);
3061             require(config[_onlyDeployer_] == 0 || token == calcContract(_msgSender(), nonce), 'only deployer');
3062         }
3063         require(tokenMappeds[token] == address(0), 'TokenMapped created already');
3064 
3065         bytes32 salt = keccak256(abi.encodePacked(_chainId(), token));
3066 
3067         bytes memory bytecode = type(InitializableProductProxy).creationCode;
3068         assembly {
3069             tokenMapped := create2(0, add(bytecode, 32), mload(bytecode), salt)
3070         }
3071         InitializableProductProxy(payable(tokenMapped)).__InitializableProductProxy_init(address(this), _TokenMapped_, abi.encodeWithSignature('__TokenMapped_init(address,address)', address(this), token));
3072         
3073         tokenMappeds[token] = tokenMapped;
3074         _initAuthQuotas(tokenMapped, IERC20(token).totalSupply());
3075         emit CreateTokenMapped(_msgSender(), token, tokenMapped);
3076     }
3077     event CreateTokenMapped(address indexed deployer, address indexed token, address indexed tokenMapped);
3078     
3079     function createMappableToken(string memory name, string memory symbol, uint8 decimals, uint totalSupply) external payable returns (address mappableToken) {
3080         if(_msgSender() != governor)
3081             _chargeFee(config[_feeCreate_]);
3082         require(mappableTokens[_msgSender()] == address(0), 'MappableToken created already');
3083 
3084         bytes32 salt = keccak256(abi.encodePacked(_chainId(), _msgSender()));
3085 
3086         bytes memory bytecode = type(InitializableProductProxy).creationCode;
3087         assembly {
3088             mappableToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
3089         }
3090         InitializableProductProxy(payable(mappableToken)).__InitializableProductProxy_init(address(this), _MappableToken_, abi.encodeWithSignature('__MappableToken_init(address,address,string,string,uint8,uint256)', address(this), _msgSender(), name, symbol, decimals, totalSupply));
3091         
3092         mappableTokens[_msgSender()] = mappableToken;
3093         _initAuthQuotas(mappableToken, totalSupply);
3094         emit CreateMappableToken(_msgSender(), name, symbol, decimals, totalSupply, mappableToken);
3095     }
3096     event CreateMappableToken(address indexed deployer, string name, string symbol, uint8 decimals, uint totalSupply, address indexed mappableToken);
3097     
3098     function _createMappingToken(uint mainChainId, address token, address deployer, string memory name, string memory symbol, uint8 decimals, uint cap) internal returns (address mappingToken) {
3099         address tokenOrdeployer = (token == address(0)) ? deployer : token;
3100         require(mappingTokens[mainChainId][tokenOrdeployer] == address(0), 'MappingToken created already');
3101 
3102         bytes32 salt = keccak256(abi.encodePacked(mainChainId, tokenOrdeployer));
3103 
3104         bytes memory bytecode = type(InitializableProductProxy).creationCode;
3105         assembly {
3106             mappingToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
3107         }
3108         InitializableProductProxy(payable(mappingToken)).__InitializableProductProxy_init(address(this), _MappingToken_, abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', address(this), mainChainId, token, deployer, name, symbol, decimals, cap));
3109         
3110         mappingTokens[mainChainId][tokenOrdeployer] = mappingToken;
3111         _initAuthQuotas(mappingToken, cap);
3112         emit CreateMappingToken(mainChainId, token, deployer, name, symbol, decimals, cap, mappingToken);
3113     }
3114     event CreateMappingToken(uint mainChainId, address indexed token, address indexed deployer, string name, string symbol, uint8 decimals, uint cap, address indexed mappingToken);
3115     
3116     function createMappingToken_(uint mainChainId, address token, address deployer, string memory name, string memory symbol, uint8 decimals, uint cap) public payable governance returns (address mappingToken) {
3117         return _createMappingToken(mainChainId, token, deployer, name, symbol, decimals, cap);
3118     }
3119     
3120     function createMappingToken(uint mainChainId, address token, uint nonce, string memory name, string memory symbol, uint8 decimals, uint cap, Signature[] memory signatures) public payable returns (address mappingToken) {
3121         _chargeFee(config[_feeCreate_]);
3122         require(token == address(0) || config[_onlyDeployer_] == 0 || token == calcContract(_msgSender(), nonce), 'only deployer');
3123         require(signatures.length >= config[_minSignatures_], 'too few signatures');
3124         for(uint i=0; i<signatures.length; i++) {
3125             for(uint j=0; j<i; j++)
3126                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
3127             bytes32 hash = keccak256(abi.encode(CREATE_TYPEHASH, _msgSender(), mainChainId, token, keccak256(bytes(name)), keccak256(bytes(symbol)), decimals, cap, signatures[i].signatory));
3128             hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash));
3129             address signatory = ecrecover(hash, signatures[i].v, signatures[i].r, signatures[i].s);
3130             require(signatory != address(0), "invalid signature");
3131             require(signatory == signatures[i].signatory, "unauthorized");
3132             _decreaseAuthCount(signatures[i].signatory, 1);
3133             emit AuthorizeCreate(mainChainId, token, _msgSender(), name, symbol, decimals, cap, signatory);
3134         }
3135         return _createMappingToken(mainChainId, token, _msgSender(), name, symbol, decimals, cap);
3136     }
3137     event AuthorizeCreate(uint mainChainId, address indexed token, address indexed deployer, string name, string symbol, uint8 decimals, uint cap, address indexed signatory);
3138     
3139     function _chargeFee(uint fee) virtual internal {
3140         require(msg.value >= Math.min(fee, 1 ether), 'fee is too low');
3141         address payable feeTo = address(config[_feeTo_]);
3142         if(feeTo == address(0))
3143             feeTo = address(uint160(address(this)));
3144         feeTo.transfer(msg.value);
3145         emit ChargeFee(_msgSender(), feeTo, msg.value);
3146     }
3147     event ChargeFee(address indexed from, address indexed to, uint value);
3148 
3149     uint256[49] private __gap;
3150 }