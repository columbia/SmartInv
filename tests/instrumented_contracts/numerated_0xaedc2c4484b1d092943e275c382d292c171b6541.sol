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
567  * @dev Standard math utilities missing in the Solidity language.
568  */
569 library Math {
570     /**
571      * @dev Returns the largest of two numbers.
572      */
573     function max(uint256 a, uint256 b) internal pure returns (uint256) {
574         return a >= b ? a : b;
575     }
576 
577     /**
578      * @dev Returns the smallest of two numbers.
579      */
580     function min(uint256 a, uint256 b) internal pure returns (uint256) {
581         return a < b ? a : b;
582     }
583 
584     /**
585      * @dev Returns the average of two numbers. The result is rounded towards
586      * zero.
587      */
588     function average(uint256 a, uint256 b) internal pure returns (uint256) {
589         // (a + b) / 2 can overflow, so we distribute
590         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
591     }
592 }
593 
594 /**
595  * @dev Wrappers over Solidity's arithmetic operations with added overflow
596  * checks.
597  *
598  * Arithmetic operations in Solidity wrap on overflow. This can easily result
599  * in bugs, because programmers usually assume that an overflow raises an
600  * error, which is the standard behavior in high level programming languages.
601  * `SafeMath` restores this intuition by reverting the transaction when an
602  * operation overflows.
603  *
604  * Using this library instead of the unchecked operations eliminates an entire
605  * class of bugs, so it's recommended to use it always.
606  */
607 library SafeMath {
608     /**
609      * @dev Returns the addition of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `+` operator.
613      *
614      * Requirements:
615      * - Addition cannot overflow.
616      */
617     function add(uint256 a, uint256 b) internal pure returns (uint256) {
618         uint256 c = a + b;
619         require(c >= a, "SafeMath: addition overflow");
620 
621         return c;
622     }
623 
624     /**
625      * @dev Returns the subtraction of two unsigned integers, reverting on
626      * overflow (when the result is negative).
627      *
628      * Counterpart to Solidity's `-` operator.
629      *
630      * Requirements:
631      * - Subtraction cannot overflow.
632      */
633     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
634         return sub(a, b, "SafeMath: subtraction overflow");
635     }
636 
637     /**
638      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
639      * overflow (when the result is negative).
640      *
641      * Counterpart to Solidity's `-` operator.
642      *
643      * Requirements:
644      * - Subtraction cannot overflow.
645      */
646     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
647         require(b <= a, errorMessage);
648         uint256 c = a - b;
649 
650         return c;
651     }
652 
653     function sub0(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a > b ? a - b : 0;
655     }
656 
657     /**
658      * @dev Returns the multiplication of two unsigned integers, reverting on
659      * overflow.
660      *
661      * Counterpart to Solidity's `*` operator.
662      *
663      * Requirements:
664      * - Multiplication cannot overflow.
665      */
666     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
667         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
668         // benefit is lost if 'b' is also tested.
669         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
670         if (a == 0) {
671             return 0;
672         }
673 
674         uint256 c = a * b;
675         require(c / a == b, "SafeMath: multiplication overflow");
676 
677         return c;
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers. Reverts on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator. Note: this function uses a
685      * `revert` opcode (which leaves remaining gas untouched) while Solidity
686      * uses an invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      * - The divisor cannot be zero.
690      */
691     function div(uint256 a, uint256 b) internal pure returns (uint256) {
692         return div(a, b, "SafeMath: division by zero");
693     }
694 
695     /**
696      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
697      * division by zero. The result is rounded towards zero.
698      *
699      * Counterpart to Solidity's `/` operator. Note: this function uses a
700      * `revert` opcode (which leaves remaining gas untouched) while Solidity
701      * uses an invalid opcode to revert (consuming all remaining gas).
702      *
703      * Requirements:
704      * - The divisor cannot be zero.
705      */
706     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
707         // Solidity only automatically asserts when dividing by 0
708         require(b > 0, errorMessage);
709         uint256 c = a / b;
710         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
711 
712         return c;
713     }
714 
715     /**
716      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
717      * Reverts when dividing by zero.
718      *
719      * Counterpart to Solidity's `%` operator. This function uses a `revert`
720      * opcode (which leaves remaining gas untouched) while Solidity uses an
721      * invalid opcode to revert (consuming all remaining gas).
722      *
723      * Requirements:
724      * - The divisor cannot be zero.
725      */
726     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
727         return mod(a, b, "SafeMath: modulo by zero");
728     }
729 
730     /**
731      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
732      * Reverts with custom message when dividing by zero.
733      *
734      * Counterpart to Solidity's `%` operator. This function uses a `revert`
735      * opcode (which leaves remaining gas untouched) while Solidity uses an
736      * invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      * - The divisor cannot be zero.
740      */
741     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
742         require(b != 0, errorMessage);
743         return a % b;
744     }
745 }
746 
747 /**
748  * Utility library of inline functions on addresses
749  *
750  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
751  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
752  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
753  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
754  */
755 library OpenZeppelinUpgradesAddress {
756     /**
757      * Returns whether the target address is a contract
758      * @dev This function will return false if invoked during the constructor of a contract,
759      * as the code is not actually created until after the constructor finishes.
760      * @param account address of the account to check
761      * @return whether the target address is a contract
762      */
763     function isContract(address account) internal view returns (bool) {
764         uint256 size;
765         // XXX Currently there is no better way to check if there is a contract in an address
766         // than to check the size of the code at that address.
767         // See https://ethereum.stackexchange.com/a/14016/36603
768         // for more details about how this works.
769         // TODO Check this again before the Serenity release, because all addresses will be
770         // contracts then.
771         // solhint-disable-next-line no-inline-assembly
772         assembly { size := extcodesize(account) }
773         return size > 0;
774     }
775 }
776 
777 /**
778  * @dev Collection of functions related to the address type
779  */
780 library Address {
781     /**
782      * @dev Returns true if `account` is a contract.
783      *
784      * [IMPORTANT]
785      * ====
786      * It is unsafe to assume that an address for which this function returns
787      * false is an externally-owned account (EOA) and not a contract.
788      *
789      * Among others, `isContract` will return false for the following
790      * types of addresses:
791      *
792      *  - an externally-owned account
793      *  - a contract in construction
794      *  - an address where a contract will be created
795      *  - an address where a contract lived, but was destroyed
796      * ====
797      */
798     function isContract(address account) internal view returns (bool) {
799         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
800         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
801         // for accounts without code, i.e. `keccak256('')`
802         bytes32 codehash;
803         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
804         // solhint-disable-next-line no-inline-assembly
805         assembly { codehash := extcodehash(account) }
806         return (codehash != accountHash && codehash != 0x0);
807     }
808 
809     /**
810      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
811      * `recipient`, forwarding all available gas and reverting on errors.
812      *
813      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
814      * of certain opcodes, possibly making contracts go over the 2300 gas limit
815      * imposed by `transfer`, making them unable to receive funds via
816      * `transfer`. {sendValue} removes this limitation.
817      *
818      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
819      *
820      * IMPORTANT: because control is transferred to `recipient`, care must be
821      * taken to not create reentrancy vulnerabilities. Consider using
822      * {ReentrancyGuard} or the
823      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
824      */
825     function sendValue(address payable recipient, uint256 amount) internal {
826         require(address(this).balance >= amount, "Address: insufficient balance");
827 
828         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
829         (bool success, ) = recipient.call{ value: amount }("");
830         require(success, "Address: unable to send value, recipient may have reverted");
831     }
832 }
833 
834 /**
835  * @dev Interface of the ERC20 standard as defined in the EIP.
836  */
837 interface IERC20 {
838     /**
839      * @dev Returns the amount of tokens in existence.
840      */
841     function totalSupply() external view returns (uint256);
842 
843     /**
844      * @dev Returns the amount of tokens owned by `account`.
845      */
846     function balanceOf(address account) external view returns (uint256);
847 
848     /**
849      * @dev Moves `amount` tokens from the caller's account to `recipient`.
850      *
851      * Returns a boolean value indicating whether the operation succeeded.
852      *
853      * Emits a {Transfer} event.
854      */
855     function transfer(address recipient, uint256 amount) external returns (bool);
856 
857     /**
858      * @dev Returns the remaining number of tokens that `spender` will be
859      * allowed to spend on behalf of `owner` through {transferFrom}. This is
860      * zero by default.
861      *
862      * This value changes when {approve} or {transferFrom} are called.
863      */
864     function allowance(address owner, address spender) external view returns (uint256);
865 
866     /**
867      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
868      *
869      * Returns a boolean value indicating whether the operation succeeded.
870      *
871      * IMPORTANT: Beware that changing an allowance with this method brings the risk
872      * that someone may use both the old and the new allowance by unfortunate
873      * transaction ordering. One possible solution to mitigate this race
874      * condition is to first reduce the spender's allowance to 0 and set the
875      * desired value afterwards:
876      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
877      *
878      * Emits an {Approval} event.
879      */
880     function approve(address spender, uint256 amount) external returns (bool);
881 
882     /**
883      * @dev Moves `amount` tokens from `sender` to `recipient` using the
884      * allowance mechanism. `amount` is then deducted from the caller's
885      * allowance.
886      *
887      * Returns a boolean value indicating whether the operation succeeded.
888      *
889      * Emits a {Transfer} event.
890      */
891     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
892 
893     /**
894      * @dev Emitted when `value` tokens are moved from one account (`from`) to
895      * another (`to`).
896      *
897      * Note that `value` may be zero.
898      */
899     event Transfer(address indexed from, address indexed to, uint256 value);
900 
901     /**
902      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
903      * a call to {approve}. `value` is the new allowance.
904      */
905     event Approval(address indexed owner, address indexed spender, uint256 value);
906 }
907 
908 /**
909  * @dev Implementation of the {IERC20} interface.
910  *
911  * This implementation is agnostic to the way tokens are created. This means
912  * that a supply mechanism has to be added in a derived contract using {_mint}.
913  * For a generic mechanism see {ERC20MinterPauser}.
914  *
915  * TIP: For a detailed writeup see our guide
916  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
917  * to implement supply mechanisms].
918  *
919  * We have followed general OpenZeppelin guidelines: functions revert instead
920  * of returning `false` on failure. This behavior is nonetheless conventional
921  * and does not conflict with the expectations of ERC20 applications.
922  *
923  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
924  * This allows applications to reconstruct the allowance for all accounts just
925  * by listening to said events. Other implementations of the EIP may not emit
926  * these events, as it isn't required by the specification.
927  *
928  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
929  * functions have been added to mitigate the well-known issues around setting
930  * allowances. See {IERC20-approve}.
931  */
932 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
933     using SafeMath for uint256;
934     using Address for address;
935 
936     mapping (address => uint256) private _balances;
937 
938     mapping (address => mapping (address => uint256)) private _allowances;
939 
940     uint256 private _totalSupply;
941 
942     string private _name;
943     string private _symbol;
944     uint8 private _decimals;
945 
946     /**
947      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
948      * a default value of 18.
949      *
950      * To select a different value for {decimals}, use {_setupDecimals}.
951      *
952      * All three of these values are immutable: they can only be set once during
953      * construction.
954      */
955 
956     function __ERC20_init(string memory name, string memory symbol) internal initializer {
957         __Context_init_unchained();
958         __ERC20_init_unchained(name, symbol);
959     }
960 
961     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
962 
963 
964         _name = name;
965         _symbol = symbol;
966         _decimals = 18;
967 
968     }
969 
970 
971     /**
972      * @dev Returns the name of the token.
973      */
974     function name() public view returns (string memory) {
975         return _name;
976     }
977 
978     /**
979      * @dev Returns the symbol of the token, usually a shorter version of the
980      * name.
981      */
982     function symbol() public view returns (string memory) {
983         return _symbol;
984     }
985 
986     /**
987      * @dev Returns the number of decimals used to get its user representation.
988      * For example, if `decimals` equals `2`, a balance of `505` tokens should
989      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
990      *
991      * Tokens usually opt for a value of 18, imitating the relationship between
992      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
993      * called.
994      *
995      * NOTE: This information is only used for _display_ purposes: it in
996      * no way affects any of the arithmetic of the contract, including
997      * {IERC20-balanceOf} and {IERC20-transfer}.
998      */
999     function decimals() public view returns (uint8) {
1000         return _decimals;
1001     }
1002 
1003     /**
1004      * @dev See {IERC20-totalSupply}.
1005      */
1006     function totalSupply() public view override returns (uint256) {
1007         return _totalSupply;
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-balanceOf}.
1012      */
1013     function balanceOf(address account) public view override returns (uint256) {
1014         return _balances[account];
1015     }
1016 
1017     /**
1018      * @dev See {IERC20-transfer}.
1019      *
1020      * Requirements:
1021      *
1022      * - `recipient` cannot be the zero address.
1023      * - the caller must have a balance of at least `amount`.
1024      */
1025     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1026         _transfer(_msgSender(), recipient, amount);
1027         return true;
1028     }
1029 
1030     /**
1031      * @dev See {IERC20-allowance}.
1032      */
1033     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1034         return _allowances[owner][spender];
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-approve}.
1039      *
1040      * Requirements:
1041      *
1042      * - `spender` cannot be the zero address.
1043      */
1044     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1045         _approve(_msgSender(), spender, amount);
1046         return true;
1047     }
1048 
1049     /**
1050      * @dev See {IERC20-transferFrom}.
1051      *
1052      * Emits an {Approval} event indicating the updated allowance. This is not
1053      * required by the EIP. See the note at the beginning of {ERC20};
1054      *
1055      * Requirements:
1056      * - `sender` and `recipient` cannot be the zero address.
1057      * - `sender` must have a balance of at least `amount`.
1058      * - the caller must have allowance for ``sender``'s tokens of at least
1059      * `amount`.
1060      */
1061     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1062         _transfer(sender, recipient, amount);
1063         if(sender != _msgSender() && _allowances[sender][_msgSender()] != uint(-1))
1064             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1065         return true;
1066     }
1067 
1068     /**
1069      * @dev Atomically increases the allowance granted to `spender` by the caller.
1070      *
1071      * This is an alternative to {approve} that can be used as a mitigation for
1072      * problems described in {IERC20-approve}.
1073      *
1074      * Emits an {Approval} event indicating the updated allowance.
1075      *
1076      * Requirements:
1077      *
1078      * - `spender` cannot be the zero address.
1079      */
1080     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1081         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1082         return true;
1083     }
1084 
1085     /**
1086      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1087      *
1088      * This is an alternative to {approve} that can be used as a mitigation for
1089      * problems described in {IERC20-approve}.
1090      *
1091      * Emits an {Approval} event indicating the updated allowance.
1092      *
1093      * Requirements:
1094      *
1095      * - `spender` cannot be the zero address.
1096      * - `spender` must have allowance for the caller of at least
1097      * `subtractedValue`.
1098      */
1099     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1101         return true;
1102     }
1103 
1104     /**
1105      * @dev Moves tokens `amount` from `sender` to `recipient`.
1106      *
1107      * This is internal function is equivalent to {transfer}, and can be used to
1108      * e.g. implement automatic token fees, slashing mechanisms, etc.
1109      *
1110      * Emits a {Transfer} event.
1111      *
1112      * Requirements:
1113      *
1114      * - `sender` cannot be the zero address.
1115      * - `recipient` cannot be the zero address.
1116      * - `sender` must have a balance of at least `amount`.
1117      */
1118     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1119         require(sender != address(0), "ERC20: transfer from the zero address");
1120         require(recipient != address(0), "ERC20: transfer to the zero address");
1121 
1122         _beforeTokenTransfer(sender, recipient, amount);
1123 
1124         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1125         _balances[recipient] = _balances[recipient].add(amount);
1126         emit Transfer(sender, recipient, amount);
1127     }
1128 
1129     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1130      * the total supply.
1131      *
1132      * Emits a {Transfer} event with `from` set to the zero address.
1133      *
1134      * Requirements
1135      *
1136      * - `to` cannot be the zero address.
1137      */
1138     function _mint(address account, uint256 amount) internal virtual {
1139         require(account != address(0), "ERC20: mint to the zero address");
1140 
1141         _beforeTokenTransfer(address(0), account, amount);
1142 
1143         _totalSupply = _totalSupply.add(amount);
1144         _balances[account] = _balances[account].add(amount);
1145         emit Transfer(address(0), account, amount);
1146     }
1147 
1148     /**
1149      * @dev Destroys `amount` tokens from `account`, reducing the
1150      * total supply.
1151      *
1152      * Emits a {Transfer} event with `to` set to the zero address.
1153      *
1154      * Requirements
1155      *
1156      * - `account` cannot be the zero address.
1157      * - `account` must have at least `amount` tokens.
1158      */
1159     function _burn(address account, uint256 amount) internal virtual {
1160         require(account != address(0), "ERC20: burn from the zero address");
1161 
1162         _beforeTokenTransfer(account, address(0), amount);
1163 
1164         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1165         _totalSupply = _totalSupply.sub(amount);
1166         emit Transfer(account, address(0), amount);
1167     }
1168 
1169     /**
1170      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1171      *
1172      * This is internal function is equivalent to `approve`, and can be used to
1173      * e.g. set automatic allowances for certain subsystems, etc.
1174      *
1175      * Emits an {Approval} event.
1176      *
1177      * Requirements:
1178      *
1179      * - `owner` cannot be the zero address.
1180      * - `spender` cannot be the zero address.
1181      */
1182     function _approve(address owner, address spender, uint256 amount) internal virtual {
1183         require(owner != address(0), "ERC20: approve from the zero address");
1184         require(spender != address(0), "ERC20: approve to the zero address");
1185 
1186         _allowances[owner][spender] = amount;
1187         emit Approval(owner, spender, amount);
1188     }
1189 
1190     /**
1191      * @dev Sets {decimals} to a value other than the default one of 18.
1192      *
1193      * WARNING: This function should only be called from the constructor. Most
1194      * applications that interact with token contracts will not expect
1195      * {decimals} to ever change, and may work incorrectly if it does.
1196      */
1197     function _setupDecimals(uint8 decimals_) internal {
1198         _decimals = decimals_;
1199     }
1200 
1201     /**
1202      * @dev Hook that is called before any transfer of tokens. This includes
1203      * minting and burning.
1204      *
1205      * Calling conditions:
1206      *
1207      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1208      * will be to transferred to `to`.
1209      * - when `from` is zero, `amount` tokens will be minted for `to`.
1210      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1211      * - `from` and `to` are never both zero.
1212      *
1213      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1214      */
1215     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1216 
1217     uint256[44] private __gap;
1218 }
1219 
1220 
1221 /**
1222  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1223  */
1224 abstract contract ERC20CappedUpgradeSafe is Initializable, ERC20UpgradeSafe {
1225     uint256 private _cap;
1226 
1227     /**
1228      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1229      * set once during construction.
1230      */
1231 
1232     function __ERC20Capped_init(uint256 cap) internal initializer {
1233         __Context_init_unchained();
1234         __ERC20Capped_init_unchained(cap);
1235     }
1236 
1237     function __ERC20Capped_init_unchained(uint256 cap) internal initializer {
1238 
1239 
1240         require(cap > 0, "ERC20Capped: cap is 0");
1241         _cap = cap;
1242 
1243     }
1244 
1245 
1246     /**
1247      * @dev Returns the cap on the token's total supply.
1248      */
1249     function cap() public view returns (uint256) {
1250         return _cap;
1251     }
1252 
1253     /**
1254      * @dev See {ERC20-_beforeTokenTransfer}.
1255      *
1256      * Requirements:
1257      *
1258      * - minted tokens must not cause the total supply to go over the cap.
1259      */
1260     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1261         super._beforeTokenTransfer(from, to, amount);
1262 
1263         if (from == address(0)) { // When minting tokens
1264             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1265         }
1266     }
1267 
1268     uint256[49] private __gap;
1269 }
1270 
1271 
1272 /**
1273  * @title SafeERC20
1274  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1275  * contract returns false). Tokens that return no value (and instead revert or
1276  * throw on failure) are also supported, non-reverting calls are assumed to be
1277  * successful.
1278  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1279  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1280  */
1281 library SafeERC20 {
1282     using SafeMath for uint256;
1283     using Address for address;
1284 
1285     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1286         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1287     }
1288 
1289     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1290         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1291     }
1292 
1293     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1294         // safeApprove should only be called when setting an initial allowance,
1295         // or when resetting it to zero. To increase and decrease it, use
1296         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1297         // solhint-disable-next-line max-line-length
1298         require((value == 0) || (token.allowance(address(this), spender) == 0),
1299             "SafeERC20: approve from non-zero to non-zero allowance"
1300         );
1301         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1302     }
1303 
1304     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1305         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1306         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1307     }
1308 
1309     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1310         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1311         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1312     }
1313 
1314     /**
1315      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1316      * on the return value: the return value is optional (but if data is returned, it must not be false).
1317      * @param token The token targeted by the call.
1318      * @param data The call data (encoded using abi.encode or one of its variants).
1319      */
1320     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1321         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1322         // we're implementing it ourselves.
1323 
1324         // A Solidity high level call has three parts:
1325         //  1. The target address is checked to verify it contains contract code
1326         //  2. The call itself is made, and success asserted
1327         //  3. The return value is decoded, which in turn checks the size of the returned data.
1328         // solhint-disable-next-line max-line-length
1329         require(address(token).isContract(), "SafeERC20: call to non-contract");
1330 
1331         // solhint-disable-next-line avoid-low-level-calls
1332         (bool success, bytes memory returndata) = address(token).call(data);
1333         require(success, "SafeERC20: low-level call failed");
1334 
1335         if (returndata.length > 0) { // Return data is optional
1336             // solhint-disable-next-line max-line-length
1337             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1338         }
1339     }
1340 }
1341 
1342 
1343 contract Governable is Initializable {
1344     address public governor;
1345 
1346     event GovernorshipTransferred(address indexed previousGovernor, address indexed newGovernor);
1347 
1348     /**
1349      * @dev Contract initializer.
1350      * called once by the factory at time of deployment
1351      */
1352     function __Governable_init_unchained(address governor_) virtual public initializer {
1353         governor = governor_;
1354         emit GovernorshipTransferred(address(0), governor);
1355     }
1356 
1357     modifier governance() {
1358         require(msg.sender == governor);
1359         _;
1360     }
1361 
1362     /**
1363      * @dev Allows the current governor to relinquish control of the contract.
1364      * @notice Renouncing to governorship will leave the contract without an governor.
1365      * It will not be possible to call the functions with the `governance`
1366      * modifier anymore.
1367      */
1368     function renounceGovernorship() public governance {
1369         emit GovernorshipTransferred(governor, address(0));
1370         governor = address(0);
1371     }
1372 
1373     /**
1374      * @dev Allows the current governor to transfer control of the contract to a newGovernor.
1375      * @param newGovernor The address to transfer governorship to.
1376      */
1377     function transferGovernorship(address newGovernor) public governance {
1378         _transferGovernorship(newGovernor);
1379     }
1380 
1381     /**
1382      * @dev Transfers control of the contract to a newGovernor.
1383      * @param newGovernor The address to transfer governorship to.
1384      */
1385     function _transferGovernorship(address newGovernor) internal {
1386         require(newGovernor != address(0));
1387         emit GovernorshipTransferred(governor, newGovernor);
1388         governor = newGovernor;
1389     }
1390 }
1391 
1392 
1393 contract Configurable is Governable {
1394 
1395     mapping (bytes32 => uint) internal config;
1396     
1397     function getConfig(bytes32 key) public view returns (uint) {
1398         return config[key];
1399     }
1400     function getConfig(bytes32 key, uint index) public view returns (uint) {
1401         return config[bytes32(uint(key) ^ index)];
1402     }
1403     function getConfig(bytes32 key, address addr) public view returns (uint) {
1404         return config[bytes32(uint(key) ^ uint(addr))];
1405     }
1406 
1407     function _setConfig(bytes32 key, uint value) internal {
1408         if(config[key] != value)
1409             config[key] = value;
1410     }
1411     function _setConfig(bytes32 key, uint index, uint value) internal {
1412         _setConfig(bytes32(uint(key) ^ index), value);
1413     }
1414     function _setConfig(bytes32 key, address addr, uint value) internal {
1415         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1416     }
1417     
1418     function setConfig(bytes32 key, uint value) external governance {
1419         _setConfig(key, value);
1420     }
1421     function setConfig(bytes32 key, uint index, uint value) external governance {
1422         _setConfig(bytes32(uint(key) ^ index), value);
1423     }
1424     function setConfig(bytes32 key, address addr, uint value) public governance {
1425         _setConfig(bytes32(uint(key) ^ uint(addr)), value);
1426     }
1427 }
1428 
1429 
1430 contract Constants {
1431     bytes32 internal constant _TokenMapped_     = 'TokenMapped';
1432     bytes32 internal constant _MappableToken_   = 'MappableToken';
1433     bytes32 internal constant _MappingToken_    = 'MappingToken';
1434     bytes32 internal constant _fee_             = 'fee';
1435     bytes32 internal constant _feeCreate_       = 'feeCreate';
1436     bytes32 internal constant _feeTo_           = 'feeTo';
1437     bytes32 internal constant _minSignatures_   = 'minSignatures';
1438     bytes32 internal constant _uniswapRounter_  = 'uniswapRounter';
1439     
1440     function _chainId() internal pure returns (uint id) {
1441         assembly { id := chainid() }
1442     }
1443 }
1444 
1445 struct Signature {
1446     address signatory;
1447     uint8   v;
1448     bytes32 r;
1449     bytes32 s;
1450 }
1451 
1452 abstract contract MappingBase is ContextUpgradeSafe, Constants {
1453 	using SafeMath for uint;
1454 
1455     bytes32 public constant RECEIVE_TYPEHASH = keccak256("Receive(uint256 fromChainId,address to,uint256 nonce,uint256 volume,address signatory)");
1456     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1457     bytes32 internal _DOMAIN_SEPARATOR;
1458     function DOMAIN_SEPARATOR() virtual public view returns (bytes32) {  return _DOMAIN_SEPARATOR;  }
1459 
1460     address public factory;
1461     uint256 public mainChainId;
1462     address public token;
1463     address public creator;
1464     
1465     mapping (address => uint) public authQuotaOf;                                       // signatory => quota
1466     mapping (uint => mapping (address => uint)) public sentCount;                       // toChainId => to => sentCount
1467     mapping (uint => mapping (address => mapping (uint => uint))) public sent;          // toChainId => to => nonce => volume
1468     mapping (uint => mapping (address => mapping (uint => uint))) public received;      // fromChainId => to => nonce => volume
1469     
1470     modifier onlyFactory {
1471         require(msg.sender == factory, 'Only called by Factory');
1472         _;
1473     }
1474     
1475     function increaseAuthQuotas(address[] memory signatorys, uint[] memory increments) virtual external returns (uint[] memory quotas) {
1476         require(signatorys.length == increments.length, 'two array lenth not equal');
1477         quotas = new uint[](signatorys.length);
1478         for(uint i=0; i<signatorys.length; i++)
1479             quotas[i] = increaseAuthQuota(signatorys[i], increments[i]);
1480     }
1481     
1482     function increaseAuthQuota(address signatory, uint increment) virtual public onlyFactory returns (uint quota) {
1483         quota = authQuotaOf[signatory].add(increment);
1484         authQuotaOf[signatory] = quota;
1485         emit IncreaseAuthQuota(signatory, increment, quota);
1486     }
1487     event IncreaseAuthQuota(address indexed signatory, uint increment, uint quota);
1488     
1489     function decreaseAuthQuotas(address[] memory signatorys, uint[] memory decrements) virtual external returns (uint[] memory quotas) {
1490         require(signatorys.length == decrements.length, 'two array lenth not equal');
1491         quotas = new uint[](signatorys.length);
1492         for(uint i=0; i<signatorys.length; i++)
1493             quotas[i] = decreaseAuthQuota(signatorys[i], decrements[i]);
1494     }
1495     
1496     function decreaseAuthQuota(address signatory, uint decrement) virtual public onlyFactory returns (uint quota) {
1497         quota = authQuotaOf[signatory];
1498         if(quota < decrement)
1499             decrement = quota;
1500         return _decreaseAuthQuota(signatory, decrement);
1501     }
1502     
1503     function _decreaseAuthQuota(address signatory, uint decrement) virtual internal returns (uint quota) {
1504         quota = authQuotaOf[signatory].sub(decrement);
1505         authQuotaOf[signatory] = quota;
1506         emit DecreaseAuthQuota(signatory, decrement, quota);
1507     }
1508     event DecreaseAuthQuota(address indexed signatory, uint decrement, uint quota);
1509 
1510 
1511     function needApprove() virtual public pure returns (bool);
1512     
1513     function send(uint toChainId, address to, uint volume) virtual external payable returns (uint nonce) {
1514         return sendFrom(_msgSender(), toChainId, to, volume);
1515     }
1516     
1517     function sendFrom(address from, uint toChainId, address to, uint volume) virtual public payable returns (uint nonce) {
1518         _chargeFee();
1519         _sendFrom(from, volume);
1520         nonce = sentCount[toChainId][to]++;
1521         sent[toChainId][to][nonce] = volume;
1522         emit Send(from, toChainId, to, nonce, volume);
1523     }
1524     event Send(address indexed from, uint indexed toChainId, address indexed to, uint nonce, uint volume);
1525     
1526     function _sendFrom(address from, uint volume) virtual internal;
1527 
1528     function receive(uint256 fromChainId, address to, uint256 nonce, uint256 volume, Signature[] memory signatures) virtual external payable {
1529         _chargeFee();
1530         require(received[fromChainId][to][nonce] == 0, 'withdrawn already');
1531         uint N = signatures.length;
1532         require(N >= MappingTokenFactory(factory).getConfig(_minSignatures_), 'too few signatures');
1533         for(uint i=0; i<N; i++) {
1534             for(uint j=0; j<i; j++)
1535                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
1536             bytes32 structHash = keccak256(abi.encode(RECEIVE_TYPEHASH, fromChainId, to, nonce, volume, signatures[i].signatory));
1537             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", _DOMAIN_SEPARATOR, structHash));
1538             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
1539             require(signatory != address(0), "invalid signature");
1540             require(signatory == signatures[i].signatory, "unauthorized");
1541             _decreaseAuthQuota(signatures[i].signatory, volume);
1542             emit Authorize(fromChainId, to, nonce, volume, signatory);
1543         }
1544         received[fromChainId][to][nonce] = volume;
1545         _receive(to, volume);
1546         emit Receive(fromChainId, to, nonce, volume);
1547     }
1548     event Receive(uint256 indexed fromChainId, address indexed to, uint256 indexed nonce, uint256 volume);
1549     event Authorize(uint256 fromChainId, address indexed to, uint256 indexed nonce, uint256 volume, address indexed signatory);
1550     
1551     function _receive(address to, uint256 volume) virtual internal;
1552     
1553     function _chargeFee() virtual internal {
1554         require(msg.value >= MappingTokenFactory(factory).getConfig(_fee_), 'fee is too low');
1555         address payable feeTo = address(MappingTokenFactory(factory).getConfig(_feeTo_));
1556         if(feeTo == address(0))
1557             feeTo = address(uint160(factory));
1558         feeTo.transfer(msg.value);
1559         emit ChargeFee(_msgSender(), feeTo, msg.value);
1560     }
1561     event ChargeFee(address indexed from, address indexed to, uint value);
1562 
1563     uint256[50] private __gap;
1564 }    
1565     
1566     
1567 contract TokenMapped is MappingBase {
1568     using SafeERC20 for IERC20;
1569     
1570 	function __TokenMapped_init(address factory_, address token_) external initializer {
1571         __Context_init_unchained();
1572 		__TokenMapped_init_unchained(factory_, token_);
1573 	}
1574 	
1575 	function __TokenMapped_init_unchained(address factory_, address token_) public initializer {
1576         factory = factory_;
1577         mainChainId = _chainId();
1578         token = token_;
1579         creator = address(0);
1580         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(ERC20UpgradeSafe(token).name())), _chainId(), address(this)));
1581 	}
1582 	
1583     function totalMapped() virtual public view returns (uint) {
1584         return IERC20(token).balanceOf(address(this));
1585     }
1586     
1587     function needApprove() virtual override public pure returns (bool) {
1588         return true;
1589     }
1590     
1591     function _sendFrom(address from, uint volume) virtual override internal {
1592         IERC20(token).safeTransferFrom(from, address(this), volume);
1593     }
1594 
1595     function _receive(address to, uint256 volume) virtual override internal {
1596         IERC20(token).safeTransfer(to, volume);
1597     }
1598 
1599     uint256[50] private __gap;
1600 }
1601 
1602 
1603 abstract contract Permit {
1604     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1605     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1606     function DOMAIN_SEPARATOR() virtual public view returns (bytes32);
1607 
1608     mapping (address => uint) public nonces;
1609 
1610     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
1611         require(deadline >= block.timestamp, 'permit EXPIRED');
1612         bytes32 digest = keccak256(
1613             abi.encodePacked(
1614                 '\x19\x01',
1615                 DOMAIN_SEPARATOR(),
1616                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
1617             )
1618         );
1619         address recoveredAddress = ecrecover(digest, v, r, s);
1620         require(recoveredAddress != address(0) && recoveredAddress == owner, 'permit INVALID_SIGNATURE');
1621         _approve(owner, spender, value);
1622     }
1623 
1624     function _approve(address owner, address spender, uint256 amount) internal virtual;    
1625 
1626     uint256[50] private __gap;
1627 }
1628 
1629 contract MappableToken is Permit, ERC20UpgradeSafe, MappingBase {
1630 	function __MappableToken_init(address factory_, address creator_, string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) external initializer {
1631         __Context_init_unchained();
1632 		__ERC20_init_unchained(name_, symbol_);
1633 		_setupDecimals(decimals_);
1634 		_mint(creator_, totalSupply_);
1635 		__MappableToken_init_unchained(factory_, creator_);
1636 	}
1637 	
1638 	function __MappableToken_init_unchained(address factory_, address creator_) public initializer {
1639         factory = factory_;
1640         mainChainId = _chainId();
1641         token = address(0);
1642         creator = creator_;
1643         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
1644 	}
1645 	
1646     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
1647         return MappingBase.DOMAIN_SEPARATOR();
1648     }
1649     
1650     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
1651         return ERC20UpgradeSafe._approve(owner, spender, amount);
1652     }
1653     
1654     function totalMapped() virtual public view returns (uint) {
1655         return balanceOf(address(this));
1656     }
1657     
1658     function needApprove() virtual override public pure returns (bool) {
1659         return false;
1660     }
1661     
1662     function _sendFrom(address from, uint volume) virtual override internal {
1663         transferFrom(from, address(this), volume);
1664     }
1665 
1666     function _receive(address to, uint256 volume) virtual override internal {
1667         _transfer(address(this), to, volume);
1668     }
1669 
1670     uint256[50] private __gap;
1671 }
1672 
1673 
1674 contract MappingToken is Permit, ERC20CappedUpgradeSafe, MappingBase {
1675 	function __MappingToken_init(address factory_, uint mainChainId_, address token_, address creator_, string memory name_, string memory symbol_, uint8 decimals_, uint cap_) external initializer {
1676         __Context_init_unchained();
1677 		__ERC20_init_unchained(name_, symbol_);
1678 		_setupDecimals(decimals_);
1679 		__ERC20Capped_init_unchained(cap_);
1680 		__MappingToken_init_unchained(factory_, mainChainId_, token_, creator_);
1681 	}
1682 	
1683 	function __MappingToken_init_unchained(address factory_, uint mainChainId_, address token_, address creator_) public initializer {
1684         factory = factory_;
1685         mainChainId = mainChainId_;
1686         token = token_;
1687         creator = (token_ == address(0)) ? creator_ : address(0);
1688         _DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), _chainId(), address(this)));
1689 	}
1690 	
1691     function DOMAIN_SEPARATOR() virtual override(Permit, MappingBase) public view returns (bytes32) {
1692         return MappingBase.DOMAIN_SEPARATOR();
1693     }
1694     
1695     function _approve(address owner, address spender, uint256 amount) virtual override(Permit, ERC20UpgradeSafe) internal {
1696         return ERC20UpgradeSafe._approve(owner, spender, amount);
1697     }
1698     
1699     function needApprove() virtual override public pure returns (bool) {
1700         return false;
1701     }
1702     
1703     function _sendFrom(address from, uint volume) virtual override internal {
1704         _burn(from, volume);
1705         if(from != _msgSender() && allowance(from, _msgSender()) != uint(-1))
1706             _approve(from, _msgSender(), allowance(from, _msgSender()).sub(volume, "ERC20: transfer volume exceeds allowance"));
1707     }
1708 
1709     function _receive(address to, uint256 volume) virtual override internal {
1710         _mint(to, volume);
1711     }
1712 
1713     uint256[50] private __gap;
1714 }
1715 
1716 
1717 contract MappingTokenFactory is ContextUpgradeSafe, Configurable, Constants {
1718     using SafeERC20 for IERC20;
1719     using SafeMath for uint;
1720 
1721     bytes32 public constant REGISTER_TYPEHASH   = keccak256("RegisterMapping(uint mainChainId,address token,uint[] chainIds,address[] mappingTokenMappeds_)");
1722     bytes32 public constant CREATE_TYPEHASH     = keccak256("CreateMappingToken(address creator,uint mainChainId,address token,string name,string symbol,uint8 decimals,uint cap)");
1723     bytes32 public constant DOMAIN_TYPEHASH     = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1724     bytes32 public DOMAIN_SEPARATOR;
1725 
1726     mapping (bytes32 => address) public productImplementations;
1727     mapping (address => address) public tokenMappeds;                // token => tokenMapped
1728     mapping (address => address) public mappableTokens;              // creator => mappableTokens
1729     mapping (uint256 => mapping (address => address)) public mappingTokens;     // mainChainId => token or creator => mappableTokens
1730     mapping (address => bool) public authorties;
1731     
1732     // only on ethereum mainnet
1733     mapping (address => uint) public authCountOf;                   // signatory => count
1734     mapping (address => uint256) internal _mainChainIdTokens;       // mappingToken => mainChainId+token
1735     mapping (address => mapping (uint => address)) public mappingTokenMappeds;  // token => chainId => mappingToken or tokenMapped
1736     uint[] public supportChainIds;
1737     mapping (string  => uint256) internal _certifiedTokens;         // symbol => mainChainId+token
1738     string[] public certifiedSymbols;
1739 
1740     function __MappingTokenFactory_init(address _governor, address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) external initializer {
1741         __Governable_init_unchained(_governor);
1742         __MappingTokenFactory_init_unchained(_implTokenMapped, _implMappableToken, _implMappingToken, _feeTo);
1743     }
1744     
1745     function __MappingTokenFactory_init_unchained(address _implTokenMapped, address _implMappableToken, address _implMappingToken, address _feeTo) public governance {
1746         config[_fee_]                           = 0.005 ether;
1747         //config[_feeCreate_]                     = 0.200 ether;
1748         config[_feeTo_]                         = uint(_feeTo);
1749         config[_minSignatures_]                 = 3;
1750         config[_uniswapRounter_]                = uint(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1751 
1752         DOMAIN_SEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes('MappingTokenFactory')), _chainId(), address(this)));
1753         upgradeProductImplementationsTo(_implTokenMapped, _implMappableToken, _implMappingToken);
1754     }
1755 
1756     function upgradeProductImplementationsTo(address _implTokenMapped, address _implMappableToken, address _implMappingToken) public governance {
1757         productImplementations[_TokenMapped_]   = _implTokenMapped;
1758         productImplementations[_MappableToken_] = _implMappableToken;
1759         productImplementations[_MappingToken_]  = _implMappingToken;
1760     }
1761     
1762     function setAuthorty(address authorty, bool enable) virtual external governance {
1763         authorties[authorty] = enable;
1764         emit SetAuthorty(authorty, enable);
1765     }
1766     event SetAuthorty(address indexed authorty, bool indexed enable);
1767     
1768     modifier onlyAuthorty {
1769         require(authorties[_msgSender()], 'only authorty');
1770         _;
1771     }
1772     
1773     function increaseAuthQuotas(address mappingTokenMapped, address[] memory signatorys, uint[] memory increments) virtual external onlyAuthorty returns (uint[] memory quotas) {
1774         quotas = MappingBase(mappingTokenMapped).increaseAuthQuotas(signatorys, increments);
1775         for(uint i=0; i<signatorys.length; i++)
1776             emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatorys[i], increments[i], quotas[i]);
1777     }
1778     
1779     function increaseAuthQuota(address mappingTokenMapped, address signatory, uint increment) virtual external onlyAuthorty returns (uint quota) {
1780         quota = MappingBase(mappingTokenMapped).increaseAuthQuota(signatory, increment);
1781         emit IncreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, increment, quota);
1782     }
1783     event IncreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint increment, uint quota);
1784     
1785     function decreaseAuthQuotas(address mappingTokenMapped, address[] memory signatorys, uint[] memory decrements) virtual external onlyAuthorty returns (uint[] memory quotas) {
1786         quotas = MappingBase(mappingTokenMapped).decreaseAuthQuotas(signatorys, decrements);
1787         for(uint i=0; i<signatorys.length; i++)
1788             emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatorys[i], decrements[i], quotas[i]);
1789     }
1790     
1791     function decreaseAuthQuota(address mappingTokenMapped, address signatory, uint decrement) virtual external onlyAuthorty returns (uint quota) {
1792         quota = MappingBase(mappingTokenMapped).decreaseAuthQuota(signatory, decrement);
1793         emit DecreaseAuthQuota(_msgSender(), mappingTokenMapped, signatory, decrement, quota);
1794     }
1795     event DecreaseAuthQuota(address indexed authorty, address indexed mappingTokenMapped, address indexed signatory, uint decrement, uint quota);
1796 
1797     function increaseAuthCount(address[] memory signatorys, uint[] memory increments) virtual external returns (uint[] memory counts) {
1798         require(signatorys.length == increments.length, 'two array lenth not equal');
1799         counts = new uint[](signatorys.length);
1800         for(uint i=0; i<signatorys.length; i++)
1801             counts[i] = increaseAuthCount(signatorys[i], increments[i]);
1802     }
1803     
1804     function increaseAuthCount(address signatory, uint increment) virtual public onlyAuthorty returns (uint count) {
1805         count = authCountOf[signatory].add(increment);
1806         authCountOf[signatory] = count;
1807         emit IncreaseAuthQuota(_msgSender(), signatory, increment, count);
1808     }
1809     event IncreaseAuthQuota(address indexed authorty, address indexed signatory, uint increment, uint quota);
1810     
1811     function decreaseAuthCounts(address[] memory signatorys, uint[] memory decrements) virtual external returns (uint[] memory counts) {
1812         require(signatorys.length == decrements.length, 'two array lenth not equal');
1813         counts = new uint[](signatorys.length);
1814         for(uint i=0; i<signatorys.length; i++)
1815             counts[i] = decreaseAuthCount(signatorys[i], decrements[i]);
1816     }
1817     
1818     function decreaseAuthCount(address signatory, uint decrement) virtual public onlyAuthorty returns (uint count) {
1819         count = authCountOf[signatory];
1820         if(count < decrement)
1821             decrement = count;
1822         return _decreaseAuthCount(signatory, decrement);
1823     }
1824     
1825     function _decreaseAuthCount(address signatory, uint decrement) virtual internal returns (uint count) {
1826         count = authCountOf[signatory].sub(decrement);
1827         authCountOf[signatory] = count;
1828         emit DecreaseAuthCount(_msgSender(), signatory, decrement, count);
1829     }
1830     event DecreaseAuthCount(address indexed authorty, address indexed signatory, uint decrement, uint count);
1831 
1832     function supportChainCount() public view returns (uint) {
1833         return supportChainIds.length;
1834     }
1835     
1836     function mainChainIdTokens(address mappingToken) virtual public view returns(uint mainChainId, address token) {
1837         uint256 chainIdToken = _mainChainIdTokens[mappingToken];
1838         mainChainId = chainIdToken >> 160;
1839         token = address(chainIdToken);
1840     }
1841     
1842     function chainIdMappingTokenMappeds(address tokenOrMappingToken) virtual external view returns (uint[] memory chainIds, address[] memory mappingTokenMappeds_) {
1843         (, address token) = mainChainIdTokens(tokenOrMappingToken);
1844         if(token == address(0))
1845             token = tokenOrMappingToken;
1846         uint N = 0;
1847         for(uint i=0; i<supportChainCount(); i++)
1848             if(mappingTokenMappeds[token][supportChainIds[i]] != address(0))
1849                 N++;
1850         chainIds = new uint[](N);
1851         mappingTokenMappeds_ = new address[](N);
1852         uint j = 0;
1853         for(uint i=0; i<supportChainCount(); i++) {
1854             uint chainId = supportChainIds[i];
1855             address mappingTokenMapped = mappingTokenMappeds[token][chainId];
1856             if(mappingTokenMapped != address(0)) {
1857                 chainIds[j] = chainId;
1858                 mappingTokenMappeds_[j] = mappingTokenMapped;
1859                 j++;
1860             }
1861         }
1862     }
1863     
1864     function isSupportChainId(uint chainId) virtual public view returns (bool) {
1865         for(uint i=0; i<supportChainCount(); i++)
1866             if(supportChainIds[i] == chainId)
1867                 return true;
1868         return false;
1869     }
1870     
1871     function registerSupportChainId(uint chainId_) virtual external governance {
1872         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
1873         require(!isSupportChainId(chainId_), 'support chainId already');
1874         supportChainIds.push(chainId_);
1875     }
1876     
1877     function _registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual internal {
1878         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
1879         require(chainIds.length == mappingTokenMappeds_.length, 'two array lenth not equal');
1880         require(isSupportChainId(mainChainId), 'Not support mainChainId');
1881         for(uint i=0; i<chainIds.length; i++) {
1882             require(isSupportChainId(chainIds[i]), 'Not support chainId');
1883             require(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0 || _mainChainIdTokens[mappingTokenMappeds_[i]] == (mainChainId << 160) | uint(token), 'mainChainIdTokens exist already');
1884             require(mappingTokenMappeds[token][chainIds[i]] == address(0), 'mappingTokenMappeds exist already');
1885             if(_mainChainIdTokens[mappingTokenMappeds_[i]] == 0)
1886                 _mainChainIdTokens[mappingTokenMappeds_[i]] = (mainChainId << 160) | uint(token);
1887             mappingTokenMappeds[token][chainIds[i]] = mappingTokenMappeds_[i];
1888             emit RegisterMapping(mainChainId, token, chainIds[i], mappingTokenMappeds_[i]);
1889         }
1890     }
1891     event RegisterMapping(uint mainChainId, address token, uint chainId, address mappingTokenMapped);
1892     
1893     function registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_) virtual external governance {
1894         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
1895     }
1896     
1897     function registerMapping(uint mainChainId, address token, uint[] memory chainIds, address[] memory mappingTokenMappeds_, Signature[] memory signatures) virtual external payable {
1898         _chargeFee();
1899         uint N = signatures.length;
1900         require(N >= getConfig(_minSignatures_), 'too few signatures');
1901         for(uint i=0; i<N; i++) {
1902             for(uint j=0; j<i; j++)
1903                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
1904             bytes32 structHash = keccak256(abi.encode(REGISTER_TYPEHASH, mainChainId, token, chainIds, mappingTokenMappeds_, signatures[i].signatory));
1905             bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
1906             address signatory = ecrecover(digest, signatures[i].v, signatures[i].r, signatures[i].s);
1907             require(signatory != address(0), "invalid signature");
1908             require(signatory == signatures[i].signatory, "unauthorized");
1909             _decreaseAuthCount(signatures[i].signatory, 1);
1910             emit AuthorizeRegister(mainChainId, token, signatory);
1911         }
1912         _registerMapping(mainChainId, token, chainIds, mappingTokenMappeds_);
1913     }
1914     event AuthorizeRegister(uint indexed mainChainId, address indexed token, address indexed signatory);
1915 
1916     function certifiedCount() external view returns (uint) {
1917         return certifiedSymbols.length;
1918     }
1919     
1920     function certifiedTokens(string memory symbol) public view returns (uint mainChainId, address token) {
1921         uint256 chainIdToken = _certifiedTokens[symbol];
1922         mainChainId = chainIdToken >> 160;
1923         token = address(chainIdToken);
1924     }
1925     
1926     function allCertifiedTokens() external view returns (string[] memory symbols, uint[] memory chainIds, address[] memory tokens) {
1927         symbols = certifiedSymbols;
1928         uint N = certifiedSymbols.length;
1929         chainIds = new uint[](N);
1930         tokens = new address[](N);
1931         for(uint i=0; i<N; i++)
1932             (chainIds[i], tokens[i]) = certifiedTokens(certifiedSymbols[i]);
1933     }
1934 
1935     function registerCertified(string memory symbol, uint mainChainId, address token) external governance {
1936         require(_chainId() == 1 || _chainId() == 3, 'called only on ethereum mainnet');
1937         require(isSupportChainId(mainChainId), 'Not support mainChainId');
1938         require(_certifiedTokens[symbol] == 0, 'Certified added already');
1939         if(mainChainId == _chainId())
1940             require(keccak256(bytes(symbol)) == keccak256(bytes(ERC20UpgradeSafe(token).symbol())), 'symbol different');
1941         _certifiedTokens[symbol] = (mainChainId << 160) | uint(token);
1942         certifiedSymbols.push(symbol);
1943         emit RegisterCertified(symbol, mainChainId, token);
1944     }
1945     event RegisterCertified(string indexed symbol, uint indexed mainChainId, address indexed token);
1946     
1947     function createTokenMapped(address token) external payable returns (address tokenMapped) {
1948         _chargeFee();
1949         IERC20(token).totalSupply();                                                            // just for check
1950         require(tokenMappeds[token] == address(0), 'TokenMapped created already');
1951 
1952         bytes32 salt = keccak256(abi.encodePacked(_chainId(), token));
1953 
1954         bytes memory bytecode = type(InitializableProductProxy).creationCode;
1955         assembly {
1956             tokenMapped := create2(0, add(bytecode, 32), mload(bytecode), salt)
1957         }
1958         InitializableProductProxy(payable(tokenMapped)).__InitializableProductProxy_init(address(this), _TokenMapped_, abi.encodeWithSignature('__TokenMapped_init(address,address)', address(this), token));
1959         
1960         tokenMappeds[token] = tokenMapped;
1961         emit CreateTokenMapped(_msgSender(), token, tokenMapped);
1962     }
1963     event CreateTokenMapped(address indexed creator, address indexed token, address indexed tokenMapped);
1964     
1965     function createMappableToken(string memory name, string memory symbol, uint8 decimals, uint totalSupply) external payable returns (address mappableToken) {
1966         _chargeFee();
1967         require(mappableTokens[_msgSender()] == address(0), 'MappableToken created already');
1968 
1969         bytes32 salt = keccak256(abi.encodePacked(_chainId(), _msgSender()));
1970 
1971         bytes memory bytecode = type(InitializableProductProxy).creationCode;
1972         assembly {
1973             mappableToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
1974         }
1975         InitializableProductProxy(payable(mappableToken)).__InitializableProductProxy_init(address(this), _MappableToken_, abi.encodeWithSignature('__MappableToken_init(address,address,string,string,uint8,uint256)', address(this), _msgSender(), name, symbol, decimals, totalSupply));
1976         
1977         mappableTokens[_msgSender()] = mappableToken;
1978         emit CreateMappableToken(_msgSender(), name, symbol, decimals, totalSupply, mappableToken);
1979     }
1980     event CreateMappableToken(address indexed creator, string name, string symbol, uint8 decimals, uint totalSupply, address indexed mappableToken);
1981     
1982     function _createMappingToken(uint mainChainId, address token, address creator, string memory name, string memory symbol, uint8 decimals, uint cap) internal returns (address mappingToken) {
1983         _chargeFee();
1984         address tokenOrCreator = (token == address(0)) ? creator : token;
1985         require(mappingTokens[mainChainId][tokenOrCreator] == address(0), 'MappingToken created already');
1986 
1987         bytes32 salt = keccak256(abi.encodePacked(mainChainId, tokenOrCreator));
1988 
1989         bytes memory bytecode = type(InitializableProductProxy).creationCode;
1990         assembly {
1991             mappingToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
1992         }
1993         InitializableProductProxy(payable(mappingToken)).__InitializableProductProxy_init(address(this), _MappingToken_, abi.encodeWithSignature('__MappingToken_init(address,uint256,address,address,string,string,uint8,uint256)', address(this), mainChainId, token, creator, name, symbol, decimals, cap));
1994         
1995         mappingTokens[mainChainId][tokenOrCreator] = mappingToken;
1996         emit CreateMappingToken(mainChainId, token, creator, name, symbol, decimals, cap, mappingToken);
1997     }
1998     event CreateMappingToken(uint mainChainId, address indexed token, address indexed creator, string name, string symbol, uint8 decimals, uint cap, address indexed mappingToken);
1999     
2000     function createMappingToken(uint mainChainId, address token, address creator, string memory name, string memory symbol, uint8 decimals, uint cap) public payable governance returns (address mappingToken) {
2001         return _createMappingToken(mainChainId, token, creator, name, symbol, decimals, cap);
2002     }
2003     
2004     function createMappingToken(uint mainChainId, address token, string memory name, string memory symbol, uint8 decimals, uint cap, Signature[] memory signatures) public payable returns (address mappingToken) {
2005         uint N = signatures.length;
2006         require(N >= getConfig(_minSignatures_), 'too few signatures');
2007         for(uint i=0; i<N; i++) {
2008             for(uint j=0; j<i; j++)
2009                 require(signatures[i].signatory != signatures[j].signatory, 'repetitive signatory');
2010             bytes32 hash = keccak256(abi.encode(CREATE_TYPEHASH, _msgSender(), mainChainId, token, name, symbol, decimals, cap, signatures[i].signatory));
2011             hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash));
2012             address signatory = ecrecover(hash, signatures[i].v, signatures[i].r, signatures[i].s);
2013             require(signatory != address(0), "invalid signature");
2014             require(signatory == signatures[i].signatory, "unauthorized");
2015             _decreaseAuthCount(signatures[i].signatory, 1);
2016             emit AuthorizeCreate(mainChainId, token, _msgSender(), name, symbol, decimals, cap, signatory);
2017         }
2018         return _createMappingToken(mainChainId, token, _msgSender(), name, symbol, decimals, cap);
2019     }
2020     event AuthorizeCreate(uint mainChainId, address indexed token, address indexed creator, string name, string symbol, uint8 decimals, uint cap, address indexed signatory);
2021     
2022     function _chargeFee() virtual internal {
2023         require(msg.value >= config[_feeCreate_], 'fee for Create is too low');
2024         address payable feeTo = address(config[_feeTo_]);
2025         if(feeTo == address(0))
2026             feeTo = address(uint160(address(this)));
2027         feeTo.transfer(msg.value);
2028         emit ChargeFee(_msgSender(), feeTo, msg.value);
2029     }
2030     event ChargeFee(address indexed from, address indexed to, uint value);
2031 
2032     uint256[50] private __gap;
2033 }