1 // File: contracts/lib/SafeMath.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 
14 /**
15  * @title SafeMath
16  * @author DODO Breeder
17  *
18  * @notice Math operations with safety checks that revert on error
19  */
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "MUL_ERROR");
28 
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0, "DIVIDING_ERROR");
34         return a / b;
35     }
36 
37     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 quotient = div(a, b);
39         uint256 remainder = a - quotient * b;
40         if (remainder > 0) {
41             return quotient + 1;
42         } else {
43             return quotient;
44         }
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b <= a, "SUB_ERROR");
49         return a - b;
50     }
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "ADD_ERROR");
55         return c;
56     }
57 
58     function sqrt(uint256 x) internal pure returns (uint256 y) {
59         uint256 z = x / 2 + 1;
60         y = x;
61         while (z < y) {
62             y = z;
63             z = (x / z + z) / 2;
64         }
65     }
66 }
67 
68 // File: contracts/lib/DecimalMath.sol
69 
70 
71 /**
72  * @title DecimalMath
73  * @author DODO Breeder
74  *
75  * @notice Functions for fixed point number with 18 decimals
76  */
77 library DecimalMath {
78     using SafeMath for uint256;
79 
80     uint256 internal constant ONE = 10**18;
81     uint256 internal constant ONE2 = 10**36;
82 
83     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
84         return target.mul(d) / (10**18);
85     }
86 
87     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
88         return target.mul(d).divCeil(10**18);
89     }
90 
91     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
92         return target.mul(10**18).div(d);
93     }
94 
95     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
96         return target.mul(10**18).divCeil(d);
97     }
98 
99     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
100         return uint256(10**36).div(target);
101     }
102 
103     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
104         return uint256(10**36).divCeil(target);
105     }
106 }
107 
108 // File: contracts/lib/Ownable.sol
109 
110 /**
111  * @title Ownable
112  * @author DODO Breeder
113  *
114  * @notice Ownership related functions
115  */
116 contract Ownable {
117     address public _OWNER_;
118     address public _NEW_OWNER_;
119 
120     // ============ Events ============
121 
122     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     // ============ Modifiers ============
127 
128     modifier onlyOwner() {
129         require(msg.sender == _OWNER_, "NOT_OWNER");
130         _;
131     }
132 
133     // ============ Functions ============
134 
135     constructor() internal {
136         _OWNER_ = msg.sender;
137         emit OwnershipTransferred(address(0), _OWNER_);
138     }
139 
140     function transferOwnership(address newOwner) external onlyOwner {
141         emit OwnershipTransferPrepared(_OWNER_, newOwner);
142         _NEW_OWNER_ = newOwner;
143     }
144 
145     function claimOwnership() external {
146         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
147         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
148         _OWNER_ = _NEW_OWNER_;
149         _NEW_OWNER_ = address(0);
150     }
151 }
152 
153 // File: contracts/intf/IERC20.sol
154 
155 
156 /**
157  * @dev Interface of the ERC20 standard as defined in the EIP.
158  */
159 interface IERC20 {
160     /**
161      * @dev Returns the amount of tokens in existence.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     function decimals() external view returns (uint8);
166 
167     function name() external view returns (string memory);
168 
169     function symbol() external view returns (string memory);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address sender,
221         address recipient,
222         uint256 amount
223     ) external returns (bool);
224 }
225 
226 // File: contracts/lib/SafeERC20.sol
227 
228 
229 
230 /**
231  * @title SafeERC20
232  * @dev Wrappers around ERC20 operations that throw on failure (when the token
233  * contract returns false). Tokens that return no value (and instead revert or
234  * throw on failure) are also supported, non-reverting calls are assumed to be
235  * successful.
236  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
237  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
238  */
239 library SafeERC20 {
240     using SafeMath for uint256;
241 
242     function safeTransfer(
243         IERC20 token,
244         address to,
245         uint256 value
246     ) internal {
247         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
248     }
249 
250     function safeTransferFrom(
251         IERC20 token,
252         address from,
253         address to,
254         uint256 value
255     ) internal {
256         _callOptionalReturn(
257             token,
258             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
259         );
260     }
261 
262     function safeApprove(
263         IERC20 token,
264         address spender,
265         uint256 value
266     ) internal {
267         // safeApprove should only be called when setting an initial allowance,
268         // or when resetting it to zero. To increase and decrease it, use
269         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
270         // solhint-disable-next-line max-line-length
271         require(
272             (value == 0) || (token.allowance(address(this), spender) == 0),
273             "SafeERC20: approve from non-zero to non-zero allowance"
274         );
275         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
276     }
277 
278     /**
279      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
280      * on the return value: the return value is optional (but if data is returned, it must not be false).
281      * @param token The token targeted by the call.
282      * @param data The call data (encoded using abi.encode or one of its variants).
283      */
284     function _callOptionalReturn(IERC20 token, bytes memory data) private {
285         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
286         // we're implementing it ourselves.
287 
288         // A Solidity high level call has three parts:
289         //  1. The target address is checked to verify it contains contract code
290         //  2. The call itself is made, and success asserted
291         //  3. The return value is decoded, which in turn checks the size of the returned data.
292         // solhint-disable-next-line max-line-length
293 
294         // solhint-disable-next-line avoid-low-level-calls
295         (bool success, bytes memory returndata) = address(token).call(data);
296         require(success, "SafeERC20: low-level call failed");
297 
298         if (returndata.length > 0) {
299             // Return data is optional
300             // solhint-disable-next-line max-line-length
301             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
302         }
303     }
304 }
305 
306 // File: contracts/DODOVendingMachine/intf/IDVM.sol
307 
308 
309 interface IDVM {
310     function init(
311         address maintainer,
312         address baseTokenAddress,
313         address quoteTokenAddress,
314         uint256 lpFeeRate,
315         address mtFeeRateModel,
316         uint256 i,
317         uint256 k,
318         bool isOpenTWAP
319     ) external;
320 
321     function _BASE_TOKEN_() external returns (address);
322 
323     function _QUOTE_TOKEN_() external returns (address);
324 
325     function _MT_FEE_RATE_MODEL_() external returns (address);
326 
327     function getVaultReserve() external returns (uint256 baseReserve, uint256 quoteReserve);
328 
329     function sellBase(address to) external returns (uint256);
330 
331     function sellQuote(address to) external returns (uint256);
332 
333     function buyShares(address to) external returns (uint256,uint256,uint256);
334 
335 }
336 
337 // File: contracts/lib/InitializableOwnable.sol
338 
339 
340 /**
341  * @title Ownable
342  * @author DODO Breeder
343  *
344  * @notice Ownership related functions
345  */
346 contract InitializableOwnable {
347     address public _OWNER_;
348     address public _NEW_OWNER_;
349     bool internal _INITIALIZED_;
350 
351     // ============ Events ============
352 
353     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
354 
355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
356 
357     // ============ Modifiers ============
358 
359     modifier notInitialized() {
360         require(!_INITIALIZED_, "DODO_INITIALIZED");
361         _;
362     }
363 
364     modifier onlyOwner() {
365         require(msg.sender == _OWNER_, "NOT_OWNER");
366         _;
367     }
368 
369     // ============ Functions ============
370 
371     function initOwner(address newOwner) public notInitialized {
372         _INITIALIZED_ = true;
373         _OWNER_ = newOwner;
374     }
375 
376     function transferOwnership(address newOwner) public onlyOwner {
377         emit OwnershipTransferPrepared(_OWNER_, newOwner);
378         _NEW_OWNER_ = newOwner;
379     }
380 
381     function claimOwnership() public {
382         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
383         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
384         _OWNER_ = _NEW_OWNER_;
385         _NEW_OWNER_ = address(0);
386     }
387 }
388 
389 // File: contracts/lib/CloneFactory.sol
390 
391 
392 interface ICloneFactory {
393     function clone(address prototype) external returns (address proxy);
394 }
395 
396 // introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/
397 // minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167
398 
399 contract CloneFactory is ICloneFactory {
400     function clone(address prototype) external override returns (address proxy) {
401         bytes20 targetBytes = bytes20(prototype);
402         assembly {
403             let clone := mload(0x40)
404             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
405             mstore(add(clone, 0x14), targetBytes)
406             mstore(
407                 add(clone, 0x28),
408                 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
409             )
410             proxy := create(0, clone, 0x37)
411         }
412         return proxy;
413     }
414 }
415 
416 // File: contracts/Factory/DVMFactory.sol
417 
418 
419 
420 
421 interface IDVMFactory {
422     function createDODOVendingMachine(
423         address baseToken,
424         address quoteToken,
425         uint256 lpFeeRate,
426         uint256 i,
427         uint256 k,
428         bool isOpenTWAP
429     ) external returns (address newVendingMachine);
430 }
431 
432 
433 /**
434  * @title DODO VendingMachine Factory
435  * @author DODO Breeder
436  *
437  * @notice Create And Register DVM Pools 
438  */
439 contract DVMFactory is InitializableOwnable {
440     // ============ Templates ============
441 
442     address public immutable _CLONE_FACTORY_;
443     address public immutable _DEFAULT_MAINTAINER_;
444     address public immutable _DEFAULT_MT_FEE_RATE_MODEL_;
445     address public _DVM_TEMPLATE_;
446 
447     // ============ Registry ============
448 
449     // base -> quote -> DVM address list
450     mapping(address => mapping(address => address[])) public _REGISTRY_;
451     // creator -> DVM address list
452     mapping(address => address[]) public _USER_REGISTRY_;
453 
454     // ============ Events ============
455 
456     event NewDVM(
457         address baseToken,
458         address quoteToken,
459         address creator,
460         address dvm
461     );
462 
463     event RemoveDVM(address dvm);
464 
465     // ============ Functions ============
466 
467     constructor(
468         address cloneFactory,
469         address dvmTemplate,
470         address defaultMaintainer,
471         address defaultMtFeeRateModel
472     ) public {
473         _CLONE_FACTORY_ = cloneFactory;
474         _DVM_TEMPLATE_ = dvmTemplate;
475         _DEFAULT_MAINTAINER_ = defaultMaintainer;
476         _DEFAULT_MT_FEE_RATE_MODEL_ = defaultMtFeeRateModel;
477     }
478 
479     function createDODOVendingMachine(
480         address baseToken,
481         address quoteToken,
482         uint256 lpFeeRate,
483         uint256 i,
484         uint256 k,
485         bool isOpenTWAP
486     ) external returns (address newVendingMachine) {
487         newVendingMachine = ICloneFactory(_CLONE_FACTORY_).clone(_DVM_TEMPLATE_);
488         {
489             IDVM(newVendingMachine).init(
490                 _DEFAULT_MAINTAINER_,
491                 baseToken,
492                 quoteToken,
493                 lpFeeRate,
494                 _DEFAULT_MT_FEE_RATE_MODEL_,
495                 i,
496                 k,
497                 isOpenTWAP
498             );
499         }
500         _REGISTRY_[baseToken][quoteToken].push(newVendingMachine);
501         _USER_REGISTRY_[tx.origin].push(newVendingMachine);
502         emit NewDVM(baseToken, quoteToken, tx.origin, newVendingMachine);
503     }
504 
505     // ============ Admin Operation Functions ============
506 
507     function updateDvmTemplate(address _newDVMTemplate) external onlyOwner {
508         _DVM_TEMPLATE_ = _newDVMTemplate;
509     }
510 
511     function addPoolByAdmin(
512         address creator,
513         address baseToken, 
514         address quoteToken,
515         address pool
516     ) external onlyOwner {
517         _REGISTRY_[baseToken][quoteToken].push(pool);
518         _USER_REGISTRY_[creator].push(pool);
519         emit NewDVM(baseToken, quoteToken, creator, pool);
520     }
521 
522     function removePoolByAdmin(
523         address creator,
524         address baseToken, 
525         address quoteToken,
526         address pool
527     ) external onlyOwner {
528         address[] memory registryList = _REGISTRY_[baseToken][quoteToken];
529         for (uint256 i = 0; i < registryList.length; i++) {
530             if (registryList[i] == pool) {
531                 registryList[i] = registryList[registryList.length - 1];
532                 break;
533             }
534         }
535         _REGISTRY_[baseToken][quoteToken] = registryList;
536         _REGISTRY_[baseToken][quoteToken].pop();
537         address[] memory userRegistryList = _USER_REGISTRY_[creator];
538         for (uint256 i = 0; i < userRegistryList.length; i++) {
539             if (userRegistryList[i] == pool) {
540                 userRegistryList[i] = userRegistryList[userRegistryList.length - 1];
541                 break;
542             }
543         }
544         _USER_REGISTRY_[creator] = userRegistryList;
545         _USER_REGISTRY_[creator].pop();
546         emit RemoveDVM(pool);
547     }
548 
549     // ============ View Functions ============
550 
551     function getDODOPool(address baseToken, address quoteToken)
552         external
553         view
554         returns (address[] memory machines)
555     {
556         return _REGISTRY_[baseToken][quoteToken];
557     }
558 
559     function getDODOPoolBidirection(address token0, address token1)
560         external
561         view
562         returns (address[] memory baseToken0Machines, address[] memory baseToken1Machines)
563     {
564         return (_REGISTRY_[token0][token1], _REGISTRY_[token1][token0]);
565     }
566 
567     function getDODOPoolByUser(address user)
568         external
569         view
570         returns (address[] memory machines)
571     {
572         return _USER_REGISTRY_[user];
573     }
574 }
575 
576 // File: contracts/lib/ReentrancyGuard.sol
577 
578 
579 /**
580  * @title ReentrancyGuard
581  * @author DODO Breeder
582  *
583  * @notice Protect functions from Reentrancy Attack
584  */
585 contract ReentrancyGuard {
586     // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
587     // zero-state of _ENTERED_ is false
588     bool private _ENTERED_;
589 
590     modifier preventReentrant() {
591         require(!_ENTERED_, "REENTRANT");
592         _ENTERED_ = true;
593         _;
594         _ENTERED_ = false;
595     }
596 }
597 
598 // File: contracts/lib/PermissionManager.sol
599 
600 
601 interface IPermissionManager {
602     function initOwner(address) external;
603 
604     function isAllowed(address) external view returns (bool);
605 }
606 
607 contract PermissionManager is InitializableOwnable {
608     bool public _WHITELIST_MODE_ON_;
609 
610     mapping(address => bool) internal _whitelist_;
611     mapping(address => bool) internal _blacklist_;
612 
613     function isAllowed(address account) external view returns (bool) {
614         if (_WHITELIST_MODE_ON_) {
615             return _whitelist_[account];
616         } else {
617             return !_blacklist_[account];
618         }
619     }
620 
621     function openBlacklistMode() external onlyOwner {
622         _WHITELIST_MODE_ON_ = false;
623     }
624 
625     function openWhitelistMode() external onlyOwner {
626         _WHITELIST_MODE_ON_ = true;
627     }
628 
629     function addToWhitelist(address account) external onlyOwner {
630         _whitelist_[account] = true;
631     }
632 
633     function removeFromWhitelist(address account) external onlyOwner {
634         _whitelist_[account] = false;
635     }
636 
637     function addToBlacklist(address account) external onlyOwner {
638         _blacklist_[account] = true;
639     }
640 
641     function removeFromBlacklist(address account) external onlyOwner {
642         _blacklist_[account] = false;
643     }
644 }
645 
646 // File: contracts/lib/FeeRateModel.sol
647 
648 
649 
650 interface IFeeRateImpl {
651     function getFeeRate(address pool, address trader) external view returns (uint256);
652 }
653 
654 interface IFeeRateModel {
655     function getFeeRate(address trader) external view returns (uint256);
656 }
657 
658 contract FeeRateModel is InitializableOwnable {
659     address public feeRateImpl;
660 
661     function setFeeProxy(address _feeRateImpl) public onlyOwner {
662         feeRateImpl = _feeRateImpl;
663     }
664     
665     function getFeeRate(address trader) external view returns (uint256) {
666         if(feeRateImpl == address(0))
667             return 0;
668         return IFeeRateImpl(feeRateImpl).getFeeRate(msg.sender,trader);
669     }
670 }
671 
672 // File: contracts/CrowdPooling/impl/CPStorage.sol
673 
674 
675 contract CPStorage is InitializableOwnable, ReentrancyGuard {
676     using SafeMath for uint256;
677 
678     // ============ Constant ============
679     
680     uint256 internal constant _SETTLEMENT_EXPIRE_ = 86400 * 7;
681     uint256 internal constant _SETTEL_FUND_ = 200 finney;
682     bool public _IS_OPEN_TWAP_ = false;
683 
684     // ============ Timeline ============
685 
686     uint256 public _PHASE_BID_STARTTIME_;
687     uint256 public _PHASE_BID_ENDTIME_;
688     uint256 public _PHASE_CALM_ENDTIME_;
689     uint256 public _SETTLED_TIME_;
690     bool public _SETTLED_;
691 
692     // ============ Core Address ============
693 
694     IERC20 public _BASE_TOKEN_;
695     IERC20 public _QUOTE_TOKEN_;
696 
697     // ============ Distribution Parameters ============
698 
699     uint256 public _TOTAL_BASE_;
700     uint256 public _POOL_QUOTE_CAP_;
701 
702     // ============ Settlement ============
703 
704     uint256 public _QUOTE_RESERVE_;
705 
706     uint256 public _UNUSED_BASE_;
707     uint256 public _UNUSED_QUOTE_;
708 
709     uint256 public _TOTAL_SHARES_;
710     mapping(address => uint256) internal _SHARES_;
711     mapping(address => bool) public _CLAIMED_;
712 
713     address public _POOL_FACTORY_;
714     address public _POOL_;
715     uint256 public _AVG_SETTLED_PRICE_;
716 
717     // ============ Advanced Control ============
718 
719     address public _MAINTAINER_;
720     IFeeRateModel public _MT_FEE_RATE_MODEL_;
721     IPermissionManager public _BIDDER_PERMISSION_;
722 
723     // ============ PMM Parameters ============
724 
725     uint256 public _K_;
726     uint256 public _I_;
727 
728     // ============ LP Token Vesting ============
729 
730     uint256 public _TOTAL_LP_AMOUNT_;
731     uint256 public _FREEZE_DURATION_;
732     uint256 public _VESTING_DURATION_;
733     uint256 public _CLIFF_RATE_;
734 
735     // ============ Modifiers ============
736 
737     modifier phaseBid() {
738         require(
739             block.timestamp >= _PHASE_BID_STARTTIME_ && block.timestamp < _PHASE_BID_ENDTIME_,
740             "NOT_PHASE_BID"
741         );
742         _;
743     }
744 
745     modifier phaseCalm() {
746         require(
747             block.timestamp >= _PHASE_BID_ENDTIME_ && block.timestamp < _PHASE_CALM_ENDTIME_,
748             "NOT_PHASE_CALM"
749         );
750         _;
751     }
752 
753     modifier phaseBidOrCalm() {
754         require(
755             block.timestamp >= _PHASE_BID_STARTTIME_ && block.timestamp < _PHASE_CALM_ENDTIME_,
756             "NOT_PHASE_BID_OR_CALM"
757         );
758         _;
759     }
760 
761     modifier phaseSettlement() {
762         require(block.timestamp >= _PHASE_CALM_ENDTIME_, "NOT_PHASE_EXE");
763         _;
764     }
765 
766     modifier phaseVesting() {
767         require(_SETTLED_, "NOT_VESTING");
768         _;
769     }
770 }
771 
772 // File: contracts/lib/DODOMath.sol
773 
774 /**
775  * @title DODOMath
776  * @author DODO Breeder
777  *
778  * @notice Functions for complex calculating. Including ONE Integration and TWO Quadratic solutions
779  */
780 library DODOMath {
781     using SafeMath for uint256;
782 
783     /*
784         Integrate dodo curve from V1 to V2
785         require V0>=V1>=V2>0
786         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
787         let V1-V2=delta
788         res = i*delta*(1-k+k(V0^2/V1/V2))
789 
790         i is the price of V-res trading pair
791 
792         support k=1 & k=0 case
793 
794         [round down]
795     */
796     function _GeneralIntegrate(
797         uint256 V0,
798         uint256 V1,
799         uint256 V2,
800         uint256 i,
801         uint256 k
802     ) internal pure returns (uint256) {
803         require(V0 > 0, "TARGET_IS_ZERO");
804         uint256 fairAmount = i.mul(V1.sub(V2)); // i*delta
805         if (k == 0) {
806             return fairAmount.div(DecimalMath.ONE);
807         }
808         uint256 V0V0V1V2 = DecimalMath.divFloor(V0.mul(V0).div(V1), V2);
809         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
810         return DecimalMath.ONE.sub(k).add(penalty).mul(fairAmount).div(DecimalMath.ONE2);
811     }
812 
813     /*
814         Follow the integration function above
815         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
816         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
817 
818         i is the price of delta-V trading pair
819         give out target of V
820 
821         support k=1 & k=0 case
822 
823         [round down]
824     */
825     function _SolveQuadraticFunctionForTarget(
826         uint256 V1,
827         uint256 delta,
828         uint256 i,
829         uint256 k
830     ) internal pure returns (uint256) {
831         if (V1 == 0) {
832             return 0;
833         }
834         if (k == 0) {
835             return V1.add(DecimalMath.mulFloor(i, delta));
836         }
837         // V0 = V1*(1+(sqrt-1)/2k)
838         // sqrt = √(1+4kidelta/V1)
839         // premium = 1+(sqrt-1)/2k
840         // uint256 sqrt = (4 * k).mul(i).mul(delta).div(V1).add(DecimalMath.ONE2).sqrt();
841         uint256 sqrt;
842         uint256 ki = (4 * k).mul(i);
843         if (ki == 0) {
844             sqrt = DecimalMath.ONE;
845         } else if ((ki * delta) / ki == delta) {
846             sqrt = (ki * delta).div(V1).add(DecimalMath.ONE2).sqrt();
847         } else {
848             sqrt = ki.div(V1).mul(delta).add(DecimalMath.ONE2).sqrt();
849         }
850         uint256 premium =
851             DecimalMath.divFloor(sqrt.sub(DecimalMath.ONE), k * 2).add(DecimalMath.ONE);
852         // V0 is greater than or equal to V1 according to the solution
853         return DecimalMath.mulFloor(V1, premium);
854     }
855 
856     /*
857         Follow the integration expression above, we have:
858         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
859         Given Q1 and deltaB, solve Q2
860         This is a quadratic function and the standard version is
861         aQ2^2 + bQ2 + c = 0, where
862         a=1-k
863         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
864         c=-kQ0^2 
865         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
866         note: another root is negative, abondan
867 
868         if deltaBSig=true, then Q2>Q1, user sell Q and receive B
869         if deltaBSig=false, then Q2<Q1, user sell B and receive Q
870         return |Q1-Q2|
871 
872         as we only support sell amount as delta, the deltaB is always negative
873         the input ideltaB is actually -ideltaB in the equation
874 
875         i is the price of delta-V trading pair
876 
877         support k=1 & k=0 case
878 
879         [round down]
880     */
881     function _SolveQuadraticFunctionForTrade(
882         uint256 V0,
883         uint256 V1,
884         uint256 delta,
885         uint256 i,
886         uint256 k
887     ) internal pure returns (uint256) {
888         require(V0 > 0, "TARGET_IS_ZERO");
889         if (delta == 0) {
890             return 0;
891         }
892 
893         if (k == 0) {
894             return DecimalMath.mulFloor(i, delta) > V1 ? V1 : DecimalMath.mulFloor(i, delta);
895         }
896 
897         if (k == DecimalMath.ONE) {
898             // if k==1
899             // Q2=Q1/(1+ideltaBQ1/Q0/Q0)
900             // temp = ideltaBQ1/Q0/Q0
901             // Q2 = Q1/(1+temp)
902             // Q1-Q2 = Q1*(1-1/(1+temp)) = Q1*(temp/(1+temp))
903             // uint256 temp = i.mul(delta).mul(V1).div(V0.mul(V0));
904             uint256 temp;
905             uint256 idelta = i.mul(delta);
906             if (idelta == 0) {
907                 temp = 0;
908             } else if ((idelta * V1) / idelta == V1) {
909                 temp = (idelta * V1).div(V0.mul(V0));
910             } else {
911                 temp = delta.mul(V1).div(V0).mul(i).div(V0);
912             }
913             return V1.mul(temp).div(temp.add(DecimalMath.ONE));
914         }
915 
916         // calculate -b value and sig
917         // b = kQ0^2/Q1-i*deltaB-(1-k)Q1
918         // part1 = (1-k)Q1 >=0
919         // part2 = kQ0^2/Q1-i*deltaB >=0
920         // bAbs = abs(part1-part2)
921         // if part1>part2 => b is negative => bSig is false
922         // if part2>part1 => b is positive => bSig is true
923         uint256 part2 = k.mul(V0).div(V1).mul(V0).add(i.mul(delta)); // kQ0^2/Q1-i*deltaB
924         uint256 bAbs = DecimalMath.ONE.sub(k).mul(V1); // (1-k)Q1
925 
926         bool bSig;
927         if (bAbs >= part2) {
928             bAbs = bAbs - part2;
929             bSig = false;
930         } else {
931             bAbs = part2 - bAbs;
932             bSig = true;
933         }
934         bAbs = bAbs.div(DecimalMath.ONE);
935 
936         // calculate sqrt
937         uint256 squareRoot =
938             DecimalMath.mulFloor(
939                 DecimalMath.ONE.sub(k).mul(4),
940                 DecimalMath.mulFloor(k, V0).mul(V0)
941             ); // 4(1-k)kQ0^2
942         squareRoot = bAbs.mul(bAbs).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
943 
944         // final res
945         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
946         uint256 numerator;
947         if (bSig) {
948             numerator = squareRoot.sub(bAbs);
949         } else {
950             numerator = bAbs.add(squareRoot);
951         }
952 
953         uint256 V2 = DecimalMath.divCeil(numerator, denominator);
954         if (V2 > V1) {
955             return 0;
956         } else {
957             return V1 - V2;
958         }
959     }
960 }
961 
962 // File: contracts/lib/PMMPricing.sol
963 
964 
965 /**
966  * @title Pricing
967  * @author DODO Breeder
968  *
969  * @notice DODO Pricing model
970  */
971 
972 library PMMPricing {
973     using SafeMath for uint256;
974 
975     enum RState {ONE, ABOVE_ONE, BELOW_ONE}
976 
977     struct PMMState {
978         uint256 i;
979         uint256 K;
980         uint256 B;
981         uint256 Q;
982         uint256 B0;
983         uint256 Q0;
984         RState R;
985     }
986 
987     // ============ buy & sell ============
988 
989     function sellBaseToken(PMMState memory state, uint256 payBaseAmount)
990         internal
991         pure
992         returns (uint256 receiveQuoteAmount, RState newR)
993     {
994         if (state.R == RState.ONE) {
995             // case 1: R=1
996             // R falls below one
997             receiveQuoteAmount = _ROneSellBaseToken(state, payBaseAmount);
998             newR = RState.BELOW_ONE;
999         } else if (state.R == RState.ABOVE_ONE) {
1000             uint256 backToOnePayBase = state.B0.sub(state.B);
1001             uint256 backToOneReceiveQuote = state.Q.sub(state.Q0);
1002             // case 2: R>1
1003             // complex case, R status depends on trading amount
1004             if (payBaseAmount < backToOnePayBase) {
1005                 // case 2.1: R status do not change
1006                 receiveQuoteAmount = _RAboveSellBaseToken(state, payBaseAmount);
1007                 newR = RState.ABOVE_ONE;
1008                 if (receiveQuoteAmount > backToOneReceiveQuote) {
1009                     // [Important corner case!] may enter this branch when some precision problem happens. And consequently contribute to negative spare quote amount
1010                     // to make sure spare quote>=0, mannually set receiveQuote=backToOneReceiveQuote
1011                     receiveQuoteAmount = backToOneReceiveQuote;
1012                 }
1013             } else if (payBaseAmount == backToOnePayBase) {
1014                 // case 2.2: R status changes to ONE
1015                 receiveQuoteAmount = backToOneReceiveQuote;
1016                 newR = RState.ONE;
1017             } else {
1018                 // case 2.3: R status changes to BELOW_ONE
1019                 receiveQuoteAmount = backToOneReceiveQuote.add(
1020                     _ROneSellBaseToken(state, payBaseAmount.sub(backToOnePayBase))
1021                 );
1022                 newR = RState.BELOW_ONE;
1023             }
1024         } else {
1025             // state.R == RState.BELOW_ONE
1026             // case 3: R<1
1027             receiveQuoteAmount = _RBelowSellBaseToken(state, payBaseAmount);
1028             newR = RState.BELOW_ONE;
1029         }
1030     }
1031 
1032     function sellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1033         internal
1034         pure
1035         returns (uint256 receiveBaseAmount, RState newR)
1036     {
1037         if (state.R == RState.ONE) {
1038             receiveBaseAmount = _ROneSellQuoteToken(state, payQuoteAmount);
1039             newR = RState.ABOVE_ONE;
1040         } else if (state.R == RState.ABOVE_ONE) {
1041             receiveBaseAmount = _RAboveSellQuoteToken(state, payQuoteAmount);
1042             newR = RState.ABOVE_ONE;
1043         } else {
1044             uint256 backToOnePayQuote = state.Q0.sub(state.Q);
1045             uint256 backToOneReceiveBase = state.B.sub(state.B0);
1046             if (payQuoteAmount < backToOnePayQuote) {
1047                 receiveBaseAmount = _RBelowSellQuoteToken(state, payQuoteAmount);
1048                 newR = RState.BELOW_ONE;
1049                 if (receiveBaseAmount > backToOneReceiveBase) {
1050                     receiveBaseAmount = backToOneReceiveBase;
1051                 }
1052             } else if (payQuoteAmount == backToOnePayQuote) {
1053                 receiveBaseAmount = backToOneReceiveBase;
1054                 newR = RState.ONE;
1055             } else {
1056                 receiveBaseAmount = backToOneReceiveBase.add(
1057                     _ROneSellQuoteToken(state, payQuoteAmount.sub(backToOnePayQuote))
1058                 );
1059                 newR = RState.ABOVE_ONE;
1060             }
1061         }
1062     }
1063 
1064     // ============ R = 1 cases ============
1065 
1066     function _ROneSellBaseToken(PMMState memory state, uint256 payBaseAmount)
1067         internal
1068         pure
1069         returns (
1070             uint256 // receiveQuoteToken
1071         )
1072     {
1073         // in theory Q2 <= targetQuoteTokenAmount
1074         // however when amount is close to 0, precision problems may cause Q2 > targetQuoteTokenAmount
1075         return
1076             DODOMath._SolveQuadraticFunctionForTrade(
1077                 state.Q0,
1078                 state.Q0,
1079                 payBaseAmount,
1080                 state.i,
1081                 state.K
1082             );
1083     }
1084 
1085     function _ROneSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1086         internal
1087         pure
1088         returns (
1089             uint256 // receiveBaseToken
1090         )
1091     {
1092         return
1093             DODOMath._SolveQuadraticFunctionForTrade(
1094                 state.B0,
1095                 state.B0,
1096                 payQuoteAmount,
1097                 DecimalMath.reciprocalFloor(state.i),
1098                 state.K
1099             );
1100     }
1101 
1102     // ============ R < 1 cases ============
1103 
1104     function _RBelowSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1105         internal
1106         pure
1107         returns (
1108             uint256 // receiveBaseToken
1109         )
1110     {
1111         return
1112             DODOMath._GeneralIntegrate(
1113                 state.Q0,
1114                 state.Q.add(payQuoteAmount),
1115                 state.Q,
1116                 DecimalMath.reciprocalFloor(state.i),
1117                 state.K
1118             );
1119     }
1120 
1121     function _RBelowSellBaseToken(PMMState memory state, uint256 payBaseAmount)
1122         internal
1123         pure
1124         returns (
1125             uint256 // receiveQuoteToken
1126         )
1127     {
1128         return
1129             DODOMath._SolveQuadraticFunctionForTrade(
1130                 state.Q0,
1131                 state.Q,
1132                 payBaseAmount,
1133                 state.i,
1134                 state.K
1135             );
1136     }
1137 
1138     // ============ R > 1 cases ============
1139 
1140     function _RAboveSellBaseToken(PMMState memory state, uint256 payBaseAmount)
1141         internal
1142         pure
1143         returns (
1144             uint256 // receiveQuoteToken
1145         )
1146     {
1147         return
1148             DODOMath._GeneralIntegrate(
1149                 state.B0,
1150                 state.B.add(payBaseAmount),
1151                 state.B,
1152                 state.i,
1153                 state.K
1154             );
1155     }
1156 
1157     function _RAboveSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1158         internal
1159         pure
1160         returns (
1161             uint256 // receiveBaseToken
1162         )
1163     {
1164         return
1165             DODOMath._SolveQuadraticFunctionForTrade(
1166                 state.B0,
1167                 state.B,
1168                 payQuoteAmount,
1169                 DecimalMath.reciprocalFloor(state.i),
1170                 state.K
1171             );
1172     }
1173 
1174     // ============ Helper functions ============
1175 
1176     function adjustedTarget(PMMState memory state) internal pure {
1177         if (state.R == RState.BELOW_ONE) {
1178             state.Q0 = DODOMath._SolveQuadraticFunctionForTarget(
1179                 state.Q,
1180                 state.B.sub(state.B0),
1181                 state.i,
1182                 state.K
1183             );
1184         } else if (state.R == RState.ABOVE_ONE) {
1185             state.B0 = DODOMath._SolveQuadraticFunctionForTarget(
1186                 state.B,
1187                 state.Q.sub(state.Q0),
1188                 DecimalMath.reciprocalFloor(state.i),
1189                 state.K
1190             );
1191         }
1192     }
1193 
1194     function getMidPrice(PMMState memory state) internal pure returns (uint256) {
1195         if (state.R == RState.BELOW_ONE) {
1196             uint256 R = DecimalMath.divFloor(state.Q0.mul(state.Q0).div(state.Q), state.Q);
1197             R = DecimalMath.ONE.sub(state.K).add(DecimalMath.mulFloor(state.K, R));
1198             return DecimalMath.divFloor(state.i, R);
1199         } else {
1200             uint256 R = DecimalMath.divFloor(state.B0.mul(state.B0).div(state.B), state.B);
1201             R = DecimalMath.ONE.sub(state.K).add(DecimalMath.mulFloor(state.K, R));
1202             return DecimalMath.mulFloor(state.i, R);
1203         }
1204     }
1205 }
1206 
1207 // File: contracts/intf/IDODOCallee.sol
1208 
1209 
1210 interface IDODOCallee {
1211     function DVMSellShareCall(
1212         address sender,
1213         uint256 burnShareAmount,
1214         uint256 baseAmount,
1215         uint256 quoteAmount,
1216         bytes calldata data
1217     ) external;
1218 
1219     function DVMFlashLoanCall(
1220         address sender,
1221         uint256 baseAmount,
1222         uint256 quoteAmount,
1223         bytes calldata data
1224     ) external;
1225 
1226     function DPPFlashLoanCall(
1227         address sender,
1228         uint256 baseAmount,
1229         uint256 quoteAmount,
1230         bytes calldata data
1231     ) external;
1232 
1233     function DSPFlashLoanCall(
1234         address sender,
1235         uint256 baseAmount,
1236         uint256 quoteAmount,
1237         bytes calldata data
1238     ) external;
1239 
1240     function CPCancelCall(
1241         address sender,
1242         uint256 amount,
1243         bytes calldata data
1244     ) external;
1245 
1246 	function CPClaimBidCall(
1247         address sender,
1248         uint256 baseAmount,
1249         uint256 quoteAmount,
1250         bytes calldata data
1251     ) external;
1252 }
1253 
1254 // File: contracts/CrowdPooling/impl/CPFunding.sol
1255 
1256 
1257 
1258 
1259 
1260 contract CPFunding is CPStorage {
1261     using SafeERC20 for IERC20;
1262     
1263     // ============ Events ============
1264     
1265     event Bid(address to, uint256 amount, uint256 fee);
1266     event Cancel(address to,uint256 amount);
1267     event Settle();
1268 
1269     // ============ BID & CALM PHASE ============
1270     
1271     modifier isBidderAllow(address bidder) {
1272         require(_BIDDER_PERMISSION_.isAllowed(bidder), "BIDDER_NOT_ALLOWED");
1273         _;
1274     }
1275 
1276     function bid(address to) external phaseBid preventReentrant isBidderAllow(to) {
1277         uint256 input = _getQuoteInput();
1278         uint256 mtFee = DecimalMath.mulFloor(input, _MT_FEE_RATE_MODEL_.getFeeRate(to));
1279         _transferQuoteOut(_MAINTAINER_, mtFee);
1280         _mintShares(to, input.sub(mtFee));
1281         _sync();
1282         emit Bid(to, input, mtFee);
1283     }
1284 
1285     function cancel(address to, uint256 amount, bytes calldata data) external phaseBidOrCalm preventReentrant {
1286         require(_SHARES_[msg.sender] >= amount, "SHARES_NOT_ENOUGH");
1287         _burnShares(msg.sender, amount);
1288         _transferQuoteOut(to, amount);
1289         _sync();
1290 
1291         if(data.length > 0){
1292             IDODOCallee(to).CPCancelCall(msg.sender,amount,data);
1293         }
1294 
1295         emit Cancel(msg.sender,amount);
1296     }
1297 
1298     function _mintShares(address to, uint256 amount) internal {
1299         _SHARES_[to] = _SHARES_[to].add(amount);
1300         _TOTAL_SHARES_ = _TOTAL_SHARES_.add(amount);
1301     }
1302 
1303     function _burnShares(address from, uint256 amount) internal {
1304         _SHARES_[from] = _SHARES_[from].sub(amount);
1305         _TOTAL_SHARES_ = _TOTAL_SHARES_.sub(amount);
1306     }
1307 
1308     // ============ SETTLEMENT ============
1309 
1310     function settle() external phaseSettlement preventReentrant {
1311         _settle();
1312 
1313         (uint256 poolBase, uint256 poolQuote, uint256 poolI, uint256 unUsedBase, uint256 unUsedQuote) = getSettleResult();
1314         _UNUSED_BASE_ = unUsedBase;
1315         _UNUSED_QUOTE_ = unUsedQuote;
1316 
1317         address _poolBaseToken;
1318         address _poolQuoteToken;
1319 
1320         if (_UNUSED_BASE_ > poolBase) {
1321             _poolBaseToken = address(_QUOTE_TOKEN_);
1322             _poolQuoteToken = address(_BASE_TOKEN_);
1323         } else {
1324             _poolBaseToken = address(_BASE_TOKEN_);
1325             _poolQuoteToken = address(_QUOTE_TOKEN_);
1326         }
1327 
1328         _POOL_ = IDVMFactory(_POOL_FACTORY_).createDODOVendingMachine(
1329             _poolBaseToken,
1330             _poolQuoteToken,
1331             3e15, // 0.3% lp feeRate
1332             poolI,
1333             DecimalMath.ONE,
1334             _IS_OPEN_TWAP_
1335         );
1336 
1337         uint256 avgPrice = unUsedBase == 0 ? _I_ : DecimalMath.divCeil(poolQuote, unUsedBase);
1338         _AVG_SETTLED_PRICE_ = avgPrice;
1339 
1340         _transferBaseOut(_POOL_, poolBase);
1341         _transferQuoteOut(_POOL_, poolQuote);
1342 
1343         (_TOTAL_LP_AMOUNT_, ,) = IDVM(_POOL_).buyShares(address(this));
1344 
1345         msg.sender.transfer(_SETTEL_FUND_);
1346 
1347         emit Settle();
1348     }
1349 
1350     // in case something wrong with base token contract
1351     function emergencySettle() external phaseSettlement preventReentrant {
1352         require(block.timestamp >= _PHASE_CALM_ENDTIME_.add(_SETTLEMENT_EXPIRE_), "NOT_EMERGENCY");
1353         _settle();
1354         _UNUSED_QUOTE_ = _QUOTE_TOKEN_.balanceOf(address(this));
1355     }
1356 
1357     function _settle() internal {
1358         require(!_SETTLED_, "ALREADY_SETTLED");
1359         _SETTLED_ = true;
1360         _SETTLED_TIME_ = block.timestamp;
1361     }
1362 
1363     // ============ Pricing ============
1364 
1365     function getSettleResult() public view returns (uint256 poolBase, uint256 poolQuote, uint256 poolI, uint256 unUsedBase, uint256 unUsedQuote) {
1366         poolQuote = _QUOTE_TOKEN_.balanceOf(address(this));
1367         if (poolQuote > _POOL_QUOTE_CAP_) {
1368             poolQuote = _POOL_QUOTE_CAP_;
1369         }
1370         (uint256 soldBase,) = PMMPricing.sellQuoteToken(_getPMMState(), poolQuote);
1371         poolBase = _TOTAL_BASE_.sub(soldBase);
1372 
1373         unUsedQuote = _QUOTE_TOKEN_.balanceOf(address(this)).sub(poolQuote);
1374         unUsedBase = _BASE_TOKEN_.balanceOf(address(this)).sub(poolBase);
1375 
1376         // Try to make midPrice equal to avgPrice
1377         // k=1, If quote and base are not balanced, one side must be cut off
1378         // DVM truncated quote, but if more quote than base entering the pool, we need set the quote to the base
1379 
1380         // m = avgPrice
1381         // i = m (1-quote/(m*base))
1382         // if quote = m*base i = 1
1383         // if quote > m*base reverse
1384         uint256 avgPrice = unUsedBase == 0 ? _I_ : DecimalMath.divCeil(poolQuote, unUsedBase);
1385         uint256 baseDepth = DecimalMath.mulFloor(avgPrice, poolBase);
1386 
1387         if (poolQuote == 0) {
1388             // ask side only DVM
1389             poolI = _I_;
1390         } else if (unUsedBase== poolBase) {
1391             // standard bonding curve
1392             poolI = 1;
1393         } else if (unUsedBase < poolBase) {
1394             // poolI up round
1395             uint256 ratio = DecimalMath.ONE.sub(DecimalMath.divFloor(poolQuote, baseDepth));
1396             poolI = avgPrice.mul(ratio).mul(ratio).divCeil(DecimalMath.ONE2);
1397         } else if (unUsedBase > poolBase) {
1398             // poolI down round
1399             uint256 ratio = DecimalMath.ONE.sub(DecimalMath.divCeil(baseDepth, poolQuote));
1400             poolI = ratio.mul(ratio).div(avgPrice);
1401         }
1402     }
1403 
1404     function _getPMMState() internal view returns (PMMPricing.PMMState memory state) {
1405         state.i = _I_;
1406         state.K = _K_;
1407         state.B = _TOTAL_BASE_;
1408         state.Q = 0;
1409         state.B0 = state.B;
1410         state.Q0 = 0;
1411         state.R = PMMPricing.RState.ONE;
1412     }
1413 
1414     function getExpectedAvgPrice() external view returns (uint256) {
1415         require(!_SETTLED_, "ALREADY_SETTLED");
1416         (uint256 poolBase, uint256 poolQuote, , , ) = getSettleResult();
1417         return DecimalMath.divCeil(poolQuote, _BASE_TOKEN_.balanceOf(address(this)).sub(poolBase));
1418     }
1419 
1420     // ============ Asset In ============
1421 
1422     function _getQuoteInput() internal view returns (uint256 input) {
1423         return _QUOTE_TOKEN_.balanceOf(address(this)).sub(_QUOTE_RESERVE_);
1424     }
1425 
1426     // ============ Set States ============
1427 
1428     function _sync() internal {
1429         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
1430         if (quoteBalance != _QUOTE_RESERVE_) {
1431             _QUOTE_RESERVE_ = quoteBalance;
1432         }
1433     }
1434 
1435     // ============ Asset Out ============
1436 
1437     function _transferBaseOut(address to, uint256 amount) internal {
1438         if (amount > 0) {
1439             _BASE_TOKEN_.safeTransfer(to, amount);
1440         }
1441     }
1442 
1443     function _transferQuoteOut(address to, uint256 amount) internal {
1444         if (amount > 0) {
1445             _QUOTE_TOKEN_.safeTransfer(to, amount);
1446         }
1447     }
1448 
1449     function getShares(address user) external view returns (uint256) {
1450         return _SHARES_[user];
1451     }
1452 }
1453 
1454 // File: contracts/CrowdPooling/impl/CPVesting.sol
1455 
1456 
1457 
1458 
1459 
1460 /**
1461  * @title CPVesting
1462  * @author DODO Breeder
1463  *
1464  * @notice Lock Token and release it linearly
1465  */
1466 
1467 contract CPVesting is CPFunding {
1468     using SafeMath for uint256;
1469     using SafeERC20 for IERC20;
1470 
1471     // ============ Events ============
1472     
1473     event Claim(address user, uint256 baseAmount, uint256 quoteAmount);
1474     event ClaimLP(uint256 amount);
1475 
1476 
1477     // ================ Modifiers ================
1478 
1479     modifier afterSettlement() {
1480         require(_SETTLED_, "NOT_SETTLED");
1481         _;
1482     }
1483 
1484     modifier afterFreeze() {
1485         require(_SETTLED_ && block.timestamp >= _SETTLED_TIME_.add(_FREEZE_DURATION_), "FREEZED");
1486         _;
1487     }
1488 
1489     // ============ Bidder Functions ============
1490 
1491     function bidderClaim(address to,bytes calldata data) external afterSettlement {
1492         require(!_CLAIMED_[msg.sender], "ALREADY_CLAIMED");
1493         _CLAIMED_[msg.sender] = true;
1494 
1495 		uint256 baseAmount = _UNUSED_BASE_.mul(_SHARES_[msg.sender]).div(_TOTAL_SHARES_);
1496 		uint256 quoteAmount = _UNUSED_QUOTE_.mul(_SHARES_[msg.sender]).div(_TOTAL_SHARES_);
1497 
1498         _transferBaseOut(to, baseAmount);
1499         _transferQuoteOut(to, quoteAmount);
1500 
1501 		if(data.length>0){
1502 			IDODOCallee(to).CPClaimBidCall(msg.sender,baseAmount,quoteAmount,data);
1503 		}
1504 
1505         emit Claim(msg.sender, baseAmount, quoteAmount);
1506     }
1507 
1508     // ============ Owner Functions ============
1509 
1510     function claimLPToken() external onlyOwner afterFreeze {
1511         uint256 lpAmount = getClaimableLPToken();
1512         IERC20(_POOL_).safeTransfer(_OWNER_, lpAmount);
1513         emit ClaimLP(lpAmount);
1514     }
1515 
1516     function getClaimableLPToken() public view afterFreeze returns (uint256) {
1517         uint256 remainingLPToken = DecimalMath.mulFloor(
1518             getRemainingLPRatio(block.timestamp),
1519             _TOTAL_LP_AMOUNT_
1520         );
1521         return IERC20(_POOL_).balanceOf(address(this)).sub(remainingLPToken);
1522     }
1523 
1524     function getRemainingLPRatio(uint256 timestamp) public view afterFreeze returns (uint256) {
1525         uint256 timePast = timestamp.sub(_SETTLED_TIME_.add(_FREEZE_DURATION_));
1526         if (timePast < _VESTING_DURATION_) {
1527             uint256 remainingTime = _VESTING_DURATION_.sub(timePast);
1528             return DecimalMath.ONE.sub(_CLIFF_RATE_).mul(remainingTime).div(_VESTING_DURATION_);
1529         } else {
1530             return 0;
1531         }
1532     }
1533 }
1534 
1535 // File: contracts/CrowdPooling/impl/CP.sol
1536 
1537 
1538 
1539 /**
1540  * @title DODO CrowdPooling
1541  * @author DODO Breeder
1542  *
1543  * @notice CrowdPooling initialization
1544  */
1545 contract CP is CPVesting {
1546     using SafeMath for uint256;
1547 
1548     receive() external payable {}
1549 
1550     function init(
1551         address[] calldata addressList,
1552         uint256[] calldata timeLine,
1553         uint256[] calldata valueList,
1554         bool isOpenTWAP
1555     ) external {
1556         /*
1557         Address List
1558         0. owner
1559         1. maintainer
1560         2. baseToken
1561         3. quoteToken
1562         4. permissionManager
1563         5. feeRateModel
1564         6. poolFactory
1565       */
1566 
1567         require(addressList.length == 7, "LIST_LENGTH_WRONG");
1568 
1569         initOwner(addressList[0]);
1570         _MAINTAINER_ = addressList[1];
1571         _BASE_TOKEN_ = IERC20(addressList[2]);
1572         _QUOTE_TOKEN_ = IERC20(addressList[3]);
1573         _BIDDER_PERMISSION_ = IPermissionManager(addressList[4]);
1574         _MT_FEE_RATE_MODEL_ = IFeeRateModel(addressList[5]);
1575         _POOL_FACTORY_ = addressList[6];
1576 
1577         /*
1578         Time Line
1579         0. phase bid starttime
1580         1. phase bid duration
1581         2. phase calm duration
1582         3. freeze duration
1583         4. vesting duration
1584         */
1585 
1586         require(timeLine.length == 5, "LIST_LENGTH_WRONG");
1587 
1588         _PHASE_BID_STARTTIME_ = timeLine[0];
1589         _PHASE_BID_ENDTIME_ = _PHASE_BID_STARTTIME_.add(timeLine[1]);
1590         _PHASE_CALM_ENDTIME_ = _PHASE_BID_ENDTIME_.add(timeLine[2]);
1591 
1592         _FREEZE_DURATION_ = timeLine[3];
1593         _VESTING_DURATION_ = timeLine[4];
1594 
1595         require(block.timestamp <= _PHASE_BID_STARTTIME_, "TIMELINE_WRONG");
1596 
1597         /*
1598         Value List
1599         0. pool quote cap
1600         1. k
1601         2. i
1602         3. cliff rate
1603         */
1604 
1605         require(valueList.length == 4, "LIST_LENGTH_WRONG");
1606 
1607         _POOL_QUOTE_CAP_ = valueList[0];
1608         _K_ = valueList[1];
1609         _I_ = valueList[2];
1610         _CLIFF_RATE_ = valueList[3];
1611 
1612         require(_I_ > 0 && _I_ <= 1e36, "I_VALUE_WRONG");
1613         require(_K_ <= 1e18, "K_VALUE_WRONG");
1614         require(_CLIFF_RATE_ <= 1e18, "CLIFF_RATE_WRONG");
1615 
1616         _TOTAL_BASE_ = _BASE_TOKEN_.balanceOf(address(this));
1617 
1618         _IS_OPEN_TWAP_ = isOpenTWAP;
1619 
1620         require(address(this).balance == _SETTEL_FUND_, "SETTLE_FUND_NOT_MATCH");
1621     }
1622     
1623      // ============ Version Control ============
1624 
1625     function version() virtual external pure returns (string memory) {
1626         return "CP 1.0.0";
1627     }
1628 }