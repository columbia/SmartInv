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
229 /**
230  * @title SafeERC20
231  * @dev Wrappers around ERC20 operations that throw on failure (when the token
232  * contract returns false). Tokens that return no value (and instead revert or
233  * throw on failure) are also supported, non-reverting calls are assumed to be
234  * successful.
235  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
236  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
237  */
238 library SafeERC20 {
239     using SafeMath for uint256;
240 
241     function safeTransfer(
242         IERC20 token,
243         address to,
244         uint256 value
245     ) internal {
246         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
247     }
248 
249     function safeTransferFrom(
250         IERC20 token,
251         address from,
252         address to,
253         uint256 value
254     ) internal {
255         _callOptionalReturn(
256             token,
257             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
258         );
259     }
260 
261     function safeApprove(
262         IERC20 token,
263         address spender,
264         uint256 value
265     ) internal {
266         // safeApprove should only be called when setting an initial allowance,
267         // or when resetting it to zero. To increase and decrease it, use
268         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
269         // solhint-disable-next-line max-line-length
270         require(
271             (value == 0) || (token.allowance(address(this), spender) == 0),
272             "SafeERC20: approve from non-zero to non-zero allowance"
273         );
274         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
275     }
276 
277     /**
278      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
279      * on the return value: the return value is optional (but if data is returned, it must not be false).
280      * @param token The token targeted by the call.
281      * @param data The call data (encoded using abi.encode or one of its variants).
282      */
283     function _callOptionalReturn(IERC20 token, bytes memory data) private {
284         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
285         // we're implementing it ourselves.
286 
287         // A Solidity high level call has three parts:
288         //  1. The target address is checked to verify it contains contract code
289         //  2. The call itself is made, and success asserted
290         //  3. The return value is decoded, which in turn checks the size of the returned data.
291         // solhint-disable-next-line max-line-length
292 
293         // solhint-disable-next-line avoid-low-level-calls
294         (bool success, bytes memory returndata) = address(token).call(data);
295         require(success, "SafeERC20: low-level call failed");
296 
297         if (returndata.length > 0) {
298             // Return data is optional
299             // solhint-disable-next-line max-line-length
300             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
301         }
302     }
303 }
304 
305 // File: contracts/DODOVendingMachine/intf/IDVM.sol
306 
307 
308 interface IDVM {
309     function init(
310         address maintainer,
311         address baseTokenAddress,
312         address quoteTokenAddress,
313         uint256 lpFeeRate,
314         address mtFeeRateModel,
315         uint256 i,
316         uint256 k,
317         bool isOpenTWAP
318     ) external;
319 
320     function _BASE_TOKEN_() external returns (address);
321 
322     function _QUOTE_TOKEN_() external returns (address);
323 
324     function _MT_FEE_RATE_MODEL_() external returns (address);
325 
326     function getVaultReserve() external returns (uint256 baseReserve, uint256 quoteReserve);
327 
328     function sellBase(address to) external returns (uint256);
329 
330     function sellQuote(address to) external returns (uint256);
331 
332     function buyShares(address to) external returns (uint256);
333 
334 }
335 
336 // File: contracts/lib/InitializableOwnable.sol
337 
338 /**
339  * @title Ownable
340  * @author DODO Breeder
341  *
342  * @notice Ownership related functions
343  */
344 contract InitializableOwnable {
345     address public _OWNER_;
346     address public _NEW_OWNER_;
347     bool internal _INITIALIZED_;
348 
349     // ============ Events ============
350 
351     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
352 
353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
354 
355     // ============ Modifiers ============
356 
357     modifier notInitialized() {
358         require(!_INITIALIZED_, "DODO_INITIALIZED");
359         _;
360     }
361 
362     modifier onlyOwner() {
363         require(msg.sender == _OWNER_, "NOT_OWNER");
364         _;
365     }
366 
367     // ============ Functions ============
368 
369     function initOwner(address newOwner) public notInitialized {
370         _INITIALIZED_ = true;
371         _OWNER_ = newOwner;
372     }
373 
374     function transferOwnership(address newOwner) public onlyOwner {
375         emit OwnershipTransferPrepared(_OWNER_, newOwner);
376         _NEW_OWNER_ = newOwner;
377     }
378 
379     function claimOwnership() public {
380         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
381         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
382         _OWNER_ = _NEW_OWNER_;
383         _NEW_OWNER_ = address(0);
384     }
385 }
386 
387 // File: contracts/lib/CloneFactory.sol
388 
389 
390 
391 interface ICloneFactory {
392     function clone(address prototype) external returns (address proxy);
393 }
394 
395 // introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/
396 // minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167
397 
398 contract CloneFactory is ICloneFactory {
399     function clone(address prototype) external override returns (address proxy) {
400         bytes20 targetBytes = bytes20(prototype);
401         assembly {
402             let clone := mload(0x40)
403             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
404             mstore(add(clone, 0x14), targetBytes)
405             mstore(
406                 add(clone, 0x28),
407                 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
408             )
409             proxy := create(0, clone, 0x37)
410         }
411         return proxy;
412     }
413 }
414 
415 // File: contracts/Factory/DVMFactory.sol
416 
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
601 
602 interface IPermissionManager {
603     function initOwner(address) external;
604 
605     function isAllowed(address) external view returns (bool);
606 }
607 
608 contract PermissionManager is InitializableOwnable {
609     bool public _WHITELIST_MODE_ON_;
610 
611     mapping(address => bool) internal _whitelist_;
612     mapping(address => bool) internal _blacklist_;
613 
614     function isAllowed(address account) external view returns (bool) {
615         if (_WHITELIST_MODE_ON_) {
616             return _whitelist_[account];
617         } else {
618             return !_blacklist_[account];
619         }
620     }
621 
622     function openBlacklistMode() external onlyOwner {
623         _WHITELIST_MODE_ON_ = false;
624     }
625 
626     function openWhitelistMode() external onlyOwner {
627         _WHITELIST_MODE_ON_ = true;
628     }
629 
630     function addToWhitelist(address account) external onlyOwner {
631         _whitelist_[account] = true;
632     }
633 
634     function removeFromWhitelist(address account) external onlyOwner {
635         _whitelist_[account] = false;
636     }
637 
638     function addToBlacklist(address account) external onlyOwner {
639         _blacklist_[account] = true;
640     }
641 
642     function removeFromBlacklist(address account) external onlyOwner {
643         _blacklist_[account] = false;
644     }
645 }
646 
647 // File: contracts/lib/FeeRateModel.sol
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
675 
676 contract CPStorage is InitializableOwnable, ReentrancyGuard {
677     using SafeMath for uint256;
678 
679     // ============ Constant ============
680     
681     uint256 internal constant _SETTLEMENT_EXPIRE_ = 86400 * 7;
682     uint256 internal constant _SETTEL_FUND_ = 200 finney;
683     bool public _IS_OPEN_TWAP_ = false;
684 
685     // ============ Timeline ============
686 
687     uint256 public _PHASE_BID_STARTTIME_;
688     uint256 public _PHASE_BID_ENDTIME_;
689     uint256 public _PHASE_CALM_ENDTIME_;
690     uint256 public _SETTLED_TIME_;
691     bool public _SETTLED_;
692 
693     // ============ Core Address ============
694 
695     IERC20 public _BASE_TOKEN_;
696     IERC20 public _QUOTE_TOKEN_;
697 
698     // ============ Distribution Parameters ============
699 
700     uint256 public _TOTAL_BASE_;
701     uint256 public _POOL_QUOTE_CAP_;
702 
703     // ============ Settlement ============
704 
705     uint256 public _QUOTE_RESERVE_;
706 
707     uint256 public _UNUSED_BASE_;
708     uint256 public _UNUSED_QUOTE_;
709 
710     uint256 public _TOTAL_SHARES_;
711     mapping(address => uint256) internal _SHARES_;
712     mapping(address => bool) public _CLAIMED_;
713 
714     address public _POOL_FACTORY_;
715     address public _POOL_;
716     uint256 public _AVG_SETTLED_PRICE_;
717 
718     // ============ Advanced Control ============
719 
720     address public _MAINTAINER_;
721     IFeeRateModel public _MT_FEE_RATE_MODEL_;
722     IPermissionManager public _BIDDER_PERMISSION_;
723 
724     // ============ PMM Parameters ============
725 
726     uint256 public _K_;
727     uint256 public _I_;
728 
729     // ============ LP Token Vesting ============
730 
731     uint256 public _TOTAL_LP_AMOUNT_;
732     uint256 public _FREEZE_DURATION_;
733     uint256 public _VESTING_DURATION_;
734     uint256 public _CLIFF_RATE_;
735 
736     // ============ Modifiers ============
737 
738     modifier phaseBid() {
739         require(
740             block.timestamp >= _PHASE_BID_STARTTIME_ && block.timestamp < _PHASE_BID_ENDTIME_,
741             "NOT_PHASE_BID"
742         );
743         _;
744     }
745 
746     modifier phaseCalm() {
747         require(
748             block.timestamp >= _PHASE_BID_ENDTIME_ && block.timestamp < _PHASE_CALM_ENDTIME_,
749             "NOT_PHASE_CALM"
750         );
751         _;
752     }
753 
754     modifier phaseBidOrCalm() {
755         require(
756             block.timestamp >= _PHASE_BID_STARTTIME_ && block.timestamp < _PHASE_CALM_ENDTIME_,
757             "NOT_PHASE_BID_OR_CALM"
758         );
759         _;
760     }
761 
762     modifier phaseSettlement() {
763         require(block.timestamp >= _PHASE_CALM_ENDTIME_, "NOT_PHASE_EXE");
764         _;
765     }
766 
767     modifier phaseVesting() {
768         require(_SETTLED_, "NOT_VESTING");
769         _;
770     }
771 }
772 
773 // File: contracts/lib/DODOMath.sol
774 
775 
776 /**
777  * @title DODOMath
778  * @author DODO Breeder
779  *
780  * @notice Functions for complex calculating. Including ONE Integration and TWO Quadratic solutions
781  */
782 library DODOMath {
783     using SafeMath for uint256;
784 
785     /*
786         Integrate dodo curve from V1 to V2
787         require V0>=V1>=V2>0
788         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
789         let V1-V2=delta
790         res = i*delta*(1-k+k(V0^2/V1/V2))
791 
792         i is the price of V-res trading pair
793 
794         support k=1 & k=0 case
795 
796         [round down]
797     */
798     function _GeneralIntegrate(
799         uint256 V0,
800         uint256 V1,
801         uint256 V2,
802         uint256 i,
803         uint256 k
804     ) internal pure returns (uint256) {
805         require(V0 > 0, "TARGET_IS_ZERO");
806         uint256 fairAmount = i.mul(V1.sub(V2)); // i*delta
807         if (k == 0) {
808             return fairAmount.div(DecimalMath.ONE);
809         }
810         uint256 V0V0V1V2 = DecimalMath.divFloor(V0.mul(V0).div(V1), V2);
811         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
812         return DecimalMath.ONE.sub(k).add(penalty).mul(fairAmount).div(DecimalMath.ONE2);
813     }
814 
815     /*
816         Follow the integration function above
817         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
818         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
819 
820         i is the price of delta-V trading pair
821         give out target of V
822 
823         support k=1 & k=0 case
824 
825         [round down]
826     */
827     function _SolveQuadraticFunctionForTarget(
828         uint256 V1,
829         uint256 delta,
830         uint256 i,
831         uint256 k
832     ) internal pure returns (uint256) {
833         if (V1 == 0) {
834             return 0;
835         }
836         if (k == 0) {
837             return V1.add(DecimalMath.mulFloor(i, delta));
838         }
839         // V0 = V1*(1+(sqrt-1)/2k)
840         // sqrt = √(1+4kidelta/V1)
841         // premium = 1+(sqrt-1)/2k
842         // uint256 sqrt = (4 * k).mul(i).mul(delta).div(V1).add(DecimalMath.ONE2).sqrt();
843         uint256 sqrt;
844         uint256 ki = (4 * k).mul(i);
845         if (ki == 0) {
846             sqrt = DecimalMath.ONE;
847         } else if ((ki * delta) / ki == delta) {
848             sqrt = (ki * delta).div(V1).add(DecimalMath.ONE2).sqrt();
849         } else {
850             sqrt = ki.div(V1).mul(delta).add(DecimalMath.ONE2).sqrt();
851         }
852         uint256 premium =
853             DecimalMath.divFloor(sqrt.sub(DecimalMath.ONE), k * 2).add(DecimalMath.ONE);
854         // V0 is greater than or equal to V1 according to the solution
855         return DecimalMath.mulFloor(V1, premium);
856     }
857 
858     /*
859         Follow the integration expression above, we have:
860         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
861         Given Q1 and deltaB, solve Q2
862         This is a quadratic function and the standard version is
863         aQ2^2 + bQ2 + c = 0, where
864         a=1-k
865         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
866         c=-kQ0^2 
867         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
868         note: another root is negative, abondan
869 
870         if deltaBSig=true, then Q2>Q1, user sell Q and receive B
871         if deltaBSig=false, then Q2<Q1, user sell B and receive Q
872         return |Q1-Q2|
873 
874         as we only support sell amount as delta, the deltaB is always negative
875         the input ideltaB is actually -ideltaB in the equation
876 
877         i is the price of delta-V trading pair
878 
879         support k=1 & k=0 case
880 
881         [round down]
882     */
883     function _SolveQuadraticFunctionForTrade(
884         uint256 V0,
885         uint256 V1,
886         uint256 delta,
887         uint256 i,
888         uint256 k
889     ) internal pure returns (uint256) {
890         require(V0 > 0, "TARGET_IS_ZERO");
891         if (delta == 0) {
892             return 0;
893         }
894 
895         if (k == 0) {
896             return DecimalMath.mulFloor(i, delta) > V1 ? V1 : DecimalMath.mulFloor(i, delta);
897         }
898 
899         if (k == DecimalMath.ONE) {
900             // if k==1
901             // Q2=Q1/(1+ideltaBQ1/Q0/Q0)
902             // temp = ideltaBQ1/Q0/Q0
903             // Q2 = Q1/(1+temp)
904             // Q1-Q2 = Q1*(1-1/(1+temp)) = Q1*(temp/(1+temp))
905             // uint256 temp = i.mul(delta).mul(V1).div(V0.mul(V0));
906             uint256 temp;
907             uint256 idelta = i.mul(delta);
908             if (idelta == 0) {
909                 temp = 0;
910             } else if ((idelta * V1) / idelta == V1) {
911                 temp = (idelta * V1).div(V0.mul(V0));
912             } else {
913                 temp = delta.mul(V1).div(V0).mul(i).div(V0);
914             }
915             return V1.mul(temp).div(temp.add(DecimalMath.ONE));
916         }
917 
918         // calculate -b value and sig
919         // b = kQ0^2/Q1-i*deltaB-(1-k)Q1
920         // part1 = (1-k)Q1 >=0
921         // part2 = kQ0^2/Q1-i*deltaB >=0
922         // bAbs = abs(part1-part2)
923         // if part1>part2 => b is negative => bSig is false
924         // if part2>part1 => b is positive => bSig is true
925         uint256 part2 = k.mul(V0).div(V1).mul(V0).add(i.mul(delta)); // kQ0^2/Q1-i*deltaB
926         uint256 bAbs = DecimalMath.ONE.sub(k).mul(V1); // (1-k)Q1
927 
928         bool bSig;
929         if (bAbs >= part2) {
930             bAbs = bAbs - part2;
931             bSig = false;
932         } else {
933             bAbs = part2 - bAbs;
934             bSig = true;
935         }
936         bAbs = bAbs.div(DecimalMath.ONE);
937 
938         // calculate sqrt
939         uint256 squareRoot =
940             DecimalMath.mulFloor(
941                 DecimalMath.ONE.sub(k).mul(4),
942                 DecimalMath.mulFloor(k, V0).mul(V0)
943             ); // 4(1-k)kQ0^2
944         squareRoot = bAbs.mul(bAbs).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
945 
946         // final res
947         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
948         uint256 numerator;
949         if (bSig) {
950             numerator = squareRoot.sub(bAbs);
951         } else {
952             numerator = bAbs.add(squareRoot);
953         }
954 
955         uint256 V2 = DecimalMath.divCeil(numerator, denominator);
956         if (V2 > V1) {
957             return 0;
958         } else {
959             return V1 - V2;
960         }
961     }
962 }
963 
964 // File: contracts/lib/PMMPricing.sol
965 
966 
967 /**
968  * @title Pricing
969  * @author DODO Breeder
970  *
971  * @notice DODO Pricing model
972  */
973 
974 library PMMPricing {
975     using SafeMath for uint256;
976 
977     enum RState {ONE, ABOVE_ONE, BELOW_ONE}
978 
979     struct PMMState {
980         uint256 i;
981         uint256 K;
982         uint256 B;
983         uint256 Q;
984         uint256 B0;
985         uint256 Q0;
986         RState R;
987     }
988 
989     // ============ buy & sell ============
990 
991     function sellBaseToken(PMMState memory state, uint256 payBaseAmount)
992         internal
993         pure
994         returns (uint256 receiveQuoteAmount, RState newR)
995     {
996         if (state.R == RState.ONE) {
997             // case 1: R=1
998             // R falls below one
999             receiveQuoteAmount = _ROneSellBaseToken(state, payBaseAmount);
1000             newR = RState.BELOW_ONE;
1001         } else if (state.R == RState.ABOVE_ONE) {
1002             uint256 backToOnePayBase = state.B0.sub(state.B);
1003             uint256 backToOneReceiveQuote = state.Q.sub(state.Q0);
1004             // case 2: R>1
1005             // complex case, R status depends on trading amount
1006             if (payBaseAmount < backToOnePayBase) {
1007                 // case 2.1: R status do not change
1008                 receiveQuoteAmount = _RAboveSellBaseToken(state, payBaseAmount);
1009                 newR = RState.ABOVE_ONE;
1010                 if (receiveQuoteAmount > backToOneReceiveQuote) {
1011                     // [Important corner case!] may enter this branch when some precision problem happens. And consequently contribute to negative spare quote amount
1012                     // to make sure spare quote>=0, mannually set receiveQuote=backToOneReceiveQuote
1013                     receiveQuoteAmount = backToOneReceiveQuote;
1014                 }
1015             } else if (payBaseAmount == backToOnePayBase) {
1016                 // case 2.2: R status changes to ONE
1017                 receiveQuoteAmount = backToOneReceiveQuote;
1018                 newR = RState.ONE;
1019             } else {
1020                 // case 2.3: R status changes to BELOW_ONE
1021                 receiveQuoteAmount = backToOneReceiveQuote.add(
1022                     _ROneSellBaseToken(state, payBaseAmount.sub(backToOnePayBase))
1023                 );
1024                 newR = RState.BELOW_ONE;
1025             }
1026         } else {
1027             // state.R == RState.BELOW_ONE
1028             // case 3: R<1
1029             receiveQuoteAmount = _RBelowSellBaseToken(state, payBaseAmount);
1030             newR = RState.BELOW_ONE;
1031         }
1032     }
1033 
1034     function sellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1035         internal
1036         pure
1037         returns (uint256 receiveBaseAmount, RState newR)
1038     {
1039         if (state.R == RState.ONE) {
1040             receiveBaseAmount = _ROneSellQuoteToken(state, payQuoteAmount);
1041             newR = RState.ABOVE_ONE;
1042         } else if (state.R == RState.ABOVE_ONE) {
1043             receiveBaseAmount = _RAboveSellQuoteToken(state, payQuoteAmount);
1044             newR = RState.ABOVE_ONE;
1045         } else {
1046             uint256 backToOnePayQuote = state.Q0.sub(state.Q);
1047             uint256 backToOneReceiveBase = state.B.sub(state.B0);
1048             if (payQuoteAmount < backToOnePayQuote) {
1049                 receiveBaseAmount = _RBelowSellQuoteToken(state, payQuoteAmount);
1050                 newR = RState.BELOW_ONE;
1051                 if (receiveBaseAmount > backToOneReceiveBase) {
1052                     receiveBaseAmount = backToOneReceiveBase;
1053                 }
1054             } else if (payQuoteAmount == backToOnePayQuote) {
1055                 receiveBaseAmount = backToOneReceiveBase;
1056                 newR = RState.ONE;
1057             } else {
1058                 receiveBaseAmount = backToOneReceiveBase.add(
1059                     _ROneSellQuoteToken(state, payQuoteAmount.sub(backToOnePayQuote))
1060                 );
1061                 newR = RState.ABOVE_ONE;
1062             }
1063         }
1064     }
1065 
1066     // ============ R = 1 cases ============
1067 
1068     function _ROneSellBaseToken(PMMState memory state, uint256 payBaseAmount)
1069         internal
1070         pure
1071         returns (
1072             uint256 // receiveQuoteToken
1073         )
1074     {
1075         // in theory Q2 <= targetQuoteTokenAmount
1076         // however when amount is close to 0, precision problems may cause Q2 > targetQuoteTokenAmount
1077         return
1078             DODOMath._SolveQuadraticFunctionForTrade(
1079                 state.Q0,
1080                 state.Q0,
1081                 payBaseAmount,
1082                 state.i,
1083                 state.K
1084             );
1085     }
1086 
1087     function _ROneSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1088         internal
1089         pure
1090         returns (
1091             uint256 // receiveBaseToken
1092         )
1093     {
1094         return
1095             DODOMath._SolveQuadraticFunctionForTrade(
1096                 state.B0,
1097                 state.B0,
1098                 payQuoteAmount,
1099                 DecimalMath.reciprocalFloor(state.i),
1100                 state.K
1101             );
1102     }
1103 
1104     // ============ R < 1 cases ============
1105 
1106     function _RBelowSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1107         internal
1108         pure
1109         returns (
1110             uint256 // receiveBaseToken
1111         )
1112     {
1113         return
1114             DODOMath._GeneralIntegrate(
1115                 state.Q0,
1116                 state.Q.add(payQuoteAmount),
1117                 state.Q,
1118                 DecimalMath.reciprocalFloor(state.i),
1119                 state.K
1120             );
1121     }
1122 
1123     function _RBelowSellBaseToken(PMMState memory state, uint256 payBaseAmount)
1124         internal
1125         pure
1126         returns (
1127             uint256 // receiveQuoteToken
1128         )
1129     {
1130         return
1131             DODOMath._SolveQuadraticFunctionForTrade(
1132                 state.Q0,
1133                 state.Q,
1134                 payBaseAmount,
1135                 state.i,
1136                 state.K
1137             );
1138     }
1139 
1140     // ============ R > 1 cases ============
1141 
1142     function _RAboveSellBaseToken(PMMState memory state, uint256 payBaseAmount)
1143         internal
1144         pure
1145         returns (
1146             uint256 // receiveQuoteToken
1147         )
1148     {
1149         return
1150             DODOMath._GeneralIntegrate(
1151                 state.B0,
1152                 state.B.add(payBaseAmount),
1153                 state.B,
1154                 state.i,
1155                 state.K
1156             );
1157     }
1158 
1159     function _RAboveSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
1160         internal
1161         pure
1162         returns (
1163             uint256 // receiveBaseToken
1164         )
1165     {
1166         return
1167             DODOMath._SolveQuadraticFunctionForTrade(
1168                 state.B0,
1169                 state.B,
1170                 payQuoteAmount,
1171                 DecimalMath.reciprocalFloor(state.i),
1172                 state.K
1173             );
1174     }
1175 
1176     // ============ Helper functions ============
1177 
1178     function adjustedTarget(PMMState memory state) internal pure {
1179         if (state.R == RState.BELOW_ONE) {
1180             state.Q0 = DODOMath._SolveQuadraticFunctionForTarget(
1181                 state.Q,
1182                 state.B.sub(state.B0),
1183                 state.i,
1184                 state.K
1185             );
1186         } else if (state.R == RState.ABOVE_ONE) {
1187             state.B0 = DODOMath._SolveQuadraticFunctionForTarget(
1188                 state.B,
1189                 state.Q.sub(state.Q0),
1190                 DecimalMath.reciprocalFloor(state.i),
1191                 state.K
1192             );
1193         }
1194     }
1195 
1196     function getMidPrice(PMMState memory state) internal pure returns (uint256) {
1197         if (state.R == RState.BELOW_ONE) {
1198             uint256 R = DecimalMath.divFloor(state.Q0.mul(state.Q0).div(state.Q), state.Q);
1199             R = DecimalMath.ONE.sub(state.K).add(DecimalMath.mulFloor(state.K, R));
1200             return DecimalMath.divFloor(state.i, R);
1201         } else {
1202             uint256 R = DecimalMath.divFloor(state.B0.mul(state.B0).div(state.B), state.B);
1203             R = DecimalMath.ONE.sub(state.K).add(DecimalMath.mulFloor(state.K, R));
1204             return DecimalMath.mulFloor(state.i, R);
1205         }
1206     }
1207 }
1208 
1209 // File: contracts/intf/IDODOCallee.sol
1210 
1211 
1212 interface IDODOCallee {
1213     function DVMSellShareCall(
1214         address sender,
1215         uint256 burnShareAmount,
1216         uint256 baseAmount,
1217         uint256 quoteAmount,
1218         bytes calldata data
1219     ) external;
1220 
1221     function DVMFlashLoanCall(
1222         address sender,
1223         uint256 baseAmount,
1224         uint256 quoteAmount,
1225         bytes calldata data
1226     ) external;
1227 
1228     function DPPFlashLoanCall(
1229         address sender,
1230         uint256 baseAmount,
1231         uint256 quoteAmount,
1232         bytes calldata data
1233     ) external;
1234 
1235     function CPCancelCall(
1236         address sender,
1237         uint256 amount,
1238         bytes calldata data
1239     ) external;
1240 
1241 	function CPClaimBidCall(
1242         address sender,
1243         uint256 baseAmount,
1244         uint256 quoteAmount,
1245         bytes calldata data
1246     ) external;
1247 }
1248 
1249 // File: contracts/CrowdPooling/impl/CPFunding.sol
1250 
1251 
1252 contract CPFunding is CPStorage {
1253     using SafeERC20 for IERC20;
1254     
1255     // ============ Events ============
1256     
1257     event Bid(address to, uint256 amount, uint256 fee);
1258     event Cancel(address to,uint256 amount);
1259     event Settle();
1260 
1261     // ============ BID & CALM PHASE ============
1262     
1263     modifier isBidderAllow(address bidder) {
1264         require(_BIDDER_PERMISSION_.isAllowed(bidder), "BIDDER_NOT_ALLOWED");
1265         _;
1266     }
1267 
1268     function bid(address to) external phaseBid preventReentrant isBidderAllow(to) {
1269         uint256 input = _getQuoteInput();
1270         uint256 mtFee = DecimalMath.mulFloor(input, _MT_FEE_RATE_MODEL_.getFeeRate(to));
1271         _transferQuoteOut(_MAINTAINER_, mtFee);
1272         _mintShares(to, input.sub(mtFee));
1273         _sync();
1274         emit Bid(to, input, mtFee);
1275     }
1276 
1277     function cancel(address to, uint256 amount, bytes calldata data) external phaseBidOrCalm preventReentrant {
1278         require(_SHARES_[msg.sender] >= amount, "SHARES_NOT_ENOUGH");
1279         _burnShares(msg.sender, amount);
1280         _transferQuoteOut(to, amount);
1281         _sync();
1282 
1283         if(data.length > 0){
1284             IDODOCallee(to).CPCancelCall(msg.sender,amount,data);
1285         }
1286 
1287         emit Cancel(msg.sender,amount);
1288     }
1289 
1290     function _mintShares(address to, uint256 amount) internal {
1291         _SHARES_[to] = _SHARES_[to].add(amount);
1292         _TOTAL_SHARES_ = _TOTAL_SHARES_.add(amount);
1293     }
1294 
1295     function _burnShares(address from, uint256 amount) internal {
1296         _SHARES_[from] = _SHARES_[from].sub(amount);
1297         _TOTAL_SHARES_ = _TOTAL_SHARES_.sub(amount);
1298     }
1299 
1300     // ============ SETTLEMENT ============
1301 
1302     function settle() external phaseSettlement preventReentrant {
1303         _settle();
1304 
1305         (uint256 poolBase, uint256 poolQuote, uint256 poolI, uint256 unUsedBase, uint256 unUsedQuote) = getSettleResult();
1306         _UNUSED_BASE_ = unUsedBase;
1307         _UNUSED_QUOTE_ = unUsedQuote;
1308 
1309         address _poolBaseToken;
1310         address _poolQuoteToken;
1311 
1312         if (_UNUSED_BASE_ > poolBase) {
1313             _poolBaseToken = address(_QUOTE_TOKEN_);
1314             _poolQuoteToken = address(_BASE_TOKEN_);
1315         } else {
1316             _poolBaseToken = address(_BASE_TOKEN_);
1317             _poolQuoteToken = address(_QUOTE_TOKEN_);
1318         }
1319 
1320         _POOL_ = IDVMFactory(_POOL_FACTORY_).createDODOVendingMachine(
1321             _poolBaseToken,
1322             _poolQuoteToken,
1323             3e15, // 0.3% lp feeRate
1324             poolI,
1325             DecimalMath.ONE,
1326             _IS_OPEN_TWAP_
1327         );
1328 
1329         uint256 avgPrice = unUsedBase == 0 ? _I_ : DecimalMath.divCeil(poolQuote, unUsedBase);
1330         _AVG_SETTLED_PRICE_ = avgPrice;
1331 
1332         _transferBaseOut(_POOL_, poolBase);
1333         _transferQuoteOut(_POOL_, poolQuote);
1334 
1335         _TOTAL_LP_AMOUNT_ = IDVM(_POOL_).buyShares(address(this));
1336 
1337         msg.sender.transfer(_SETTEL_FUND_);
1338 
1339         emit Settle();
1340     }
1341 
1342     // in case something wrong with base token contract
1343     function emergencySettle() external phaseSettlement preventReentrant {
1344         require(block.timestamp >= _PHASE_CALM_ENDTIME_.add(_SETTLEMENT_EXPIRE_), "NOT_EMERGENCY");
1345         _settle();
1346         _UNUSED_QUOTE_ = _QUOTE_TOKEN_.balanceOf(address(this));
1347     }
1348 
1349     function _settle() internal {
1350         require(!_SETTLED_, "ALREADY_SETTLED");
1351         _SETTLED_ = true;
1352         _SETTLED_TIME_ = block.timestamp;
1353     }
1354 
1355     // ============ Pricing ============
1356 
1357     function getSettleResult() public view returns (uint256 poolBase, uint256 poolQuote, uint256 poolI, uint256 unUsedBase, uint256 unUsedQuote) {
1358         poolQuote = _QUOTE_TOKEN_.balanceOf(address(this));
1359         if (poolQuote > _POOL_QUOTE_CAP_) {
1360             poolQuote = _POOL_QUOTE_CAP_;
1361         }
1362         (uint256 soldBase,) = PMMPricing.sellQuoteToken(_getPMMState(), poolQuote);
1363         poolBase = _TOTAL_BASE_.sub(soldBase);
1364 
1365         unUsedQuote = _QUOTE_TOKEN_.balanceOf(address(this)).sub(poolQuote);
1366         unUsedBase = _BASE_TOKEN_.balanceOf(address(this)).sub(poolBase);
1367 
1368         // Try to make midPrice equal to avgPrice
1369         // k=1, If quote and base are not balanced, one side must be cut off
1370         // DVM truncated quote, but if more quote than base entering the pool, we need set the quote to the base
1371 
1372         // m = avgPrice
1373         // i = m (1-quote/(m*base))
1374         // if quote = m*base i = 1
1375         // if quote > m*base reverse
1376         uint256 avgPrice = unUsedBase == 0 ? _I_ : DecimalMath.divCeil(poolQuote, unUsedBase);
1377         uint256 baseDepth = DecimalMath.mulFloor(avgPrice, poolBase);
1378 
1379         if (poolQuote == 0) {
1380             // ask side only DVM
1381             poolI = _I_;
1382         } else if (unUsedBase== poolBase) {
1383             // standard bonding curve
1384             poolI = 1;
1385         } else if (unUsedBase < poolBase) {
1386             // poolI up round
1387             uint256 ratio = DecimalMath.ONE.sub(DecimalMath.divFloor(poolQuote, baseDepth));
1388             poolI = avgPrice.mul(ratio).mul(ratio).divCeil(DecimalMath.ONE2);
1389         } else if (unUsedBase > poolBase) {
1390             // poolI down round
1391             uint256 ratio = DecimalMath.ONE.sub(DecimalMath.divCeil(baseDepth, poolQuote));
1392             poolI = ratio.mul(ratio).div(avgPrice);
1393         }
1394     }
1395 
1396     function _getPMMState() internal view returns (PMMPricing.PMMState memory state) {
1397         state.i = _I_;
1398         state.K = _K_;
1399         state.B = _TOTAL_BASE_;
1400         state.Q = 0;
1401         state.B0 = state.B;
1402         state.Q0 = 0;
1403         state.R = PMMPricing.RState.ONE;
1404     }
1405 
1406     function getExpectedAvgPrice() external view returns (uint256) {
1407         require(!_SETTLED_, "ALREADY_SETTLED");
1408         (uint256 poolBase, uint256 poolQuote, , , ) = getSettleResult();
1409         return DecimalMath.divCeil(poolQuote, _BASE_TOKEN_.balanceOf(address(this)).sub(poolBase));
1410     }
1411 
1412     // ============ Asset In ============
1413 
1414     function _getQuoteInput() internal view returns (uint256 input) {
1415         return _QUOTE_TOKEN_.balanceOf(address(this)).sub(_QUOTE_RESERVE_);
1416     }
1417 
1418     // ============ Set States ============
1419 
1420     function _sync() internal {
1421         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
1422         if (quoteBalance != _QUOTE_RESERVE_) {
1423             _QUOTE_RESERVE_ = quoteBalance;
1424         }
1425     }
1426 
1427     // ============ Asset Out ============
1428 
1429     function _transferBaseOut(address to, uint256 amount) internal {
1430         if (amount > 0) {
1431             _BASE_TOKEN_.safeTransfer(to, amount);
1432         }
1433     }
1434 
1435     function _transferQuoteOut(address to, uint256 amount) internal {
1436         if (amount > 0) {
1437             _QUOTE_TOKEN_.safeTransfer(to, amount);
1438         }
1439     }
1440 
1441     function getShares(address user) external view returns (uint256) {
1442         return _SHARES_[user];
1443     }
1444 }
1445 
1446 // File: contracts/CrowdPooling/impl/CPVesting.sol
1447 
1448 
1449 
1450 /**
1451  * @title CPVesting
1452  * @author DODO Breeder
1453  *
1454  * @notice Lock Token and release it linearly
1455  */
1456 
1457 contract CPVesting is CPFunding {
1458     using SafeMath for uint256;
1459     using SafeERC20 for IERC20;
1460 
1461     // ============ Events ============
1462     
1463     event Claim(address user, uint256 baseAmount, uint256 quoteAmount);
1464     event ClaimLP(uint256 amount);
1465 
1466 
1467     // ================ Modifiers ================
1468 
1469     modifier afterSettlement() {
1470         require(_SETTLED_, "NOT_SETTLED");
1471         _;
1472     }
1473 
1474     modifier afterFreeze() {
1475         require(_SETTLED_ && block.timestamp >= _SETTLED_TIME_.add(_FREEZE_DURATION_), "FREEZED");
1476         _;
1477     }
1478 
1479     // ============ Bidder Functions ============
1480 
1481     function bidderClaim(address to,bytes calldata data) external afterSettlement {
1482         require(!_CLAIMED_[msg.sender], "ALREADY_CLAIMED");
1483         _CLAIMED_[msg.sender] = true;
1484 
1485 		uint256 baseAmount = _UNUSED_BASE_.mul(_SHARES_[msg.sender]).div(_TOTAL_SHARES_);
1486 		uint256 quoteAmount = _UNUSED_QUOTE_.mul(_SHARES_[msg.sender]).div(_TOTAL_SHARES_);
1487 
1488         _transferBaseOut(to, baseAmount);
1489         _transferQuoteOut(to, quoteAmount);
1490 
1491 		if(data.length>0){
1492 			IDODOCallee(to).CPClaimBidCall(msg.sender,baseAmount,quoteAmount,data);
1493 		}
1494 
1495         emit Claim(msg.sender, baseAmount, quoteAmount);
1496     }
1497 
1498     // ============ Owner Functions ============
1499 
1500     function claimLPToken() external onlyOwner afterFreeze {
1501         uint256 lpAmount = getClaimableLPToken();
1502         IERC20(_POOL_).safeTransfer(_OWNER_, lpAmount);
1503         emit ClaimLP(lpAmount);
1504     }
1505 
1506     function getClaimableLPToken() public view afterFreeze returns (uint256) {
1507         uint256 remainingLPToken = DecimalMath.mulFloor(
1508             getRemainingLPRatio(block.timestamp),
1509             _TOTAL_LP_AMOUNT_
1510         );
1511         return IERC20(_POOL_).balanceOf(address(this)).sub(remainingLPToken);
1512     }
1513 
1514     function getRemainingLPRatio(uint256 timestamp) public view afterFreeze returns (uint256) {
1515         uint256 timePast = timestamp.sub(_SETTLED_TIME_.add(_FREEZE_DURATION_));
1516         if (timePast < _VESTING_DURATION_) {
1517             uint256 remainingTime = _VESTING_DURATION_.sub(timePast);
1518             return DecimalMath.ONE.sub(_CLIFF_RATE_).mul(remainingTime).div(_VESTING_DURATION_);
1519         } else {
1520             return 0;
1521         }
1522     }
1523 }
1524 
1525 // File: contracts/CrowdPooling/impl/CP.sol
1526 
1527 
1528 /**
1529  * @title DODO CrowdPooling
1530  * @author DODO Breeder
1531  *
1532  * @notice CrowdPooling initialization
1533  */
1534 contract CP is CPVesting {
1535     using SafeMath for uint256;
1536 
1537     receive() external payable {
1538         require(_INITIALIZED_ == false, "WE_NOT_SAVE_ETH_AFTER_INIT");
1539     }
1540 
1541     function init(
1542         address[] calldata addressList,
1543         uint256[] calldata timeLine,
1544         uint256[] calldata valueList,
1545         bool isOpenTWAP
1546     ) external {
1547         /*
1548         Address List
1549         0. owner
1550         1. maintainer
1551         2. baseToken
1552         3. quoteToken
1553         4. permissionManager
1554         5. feeRateModel
1555         6. poolFactory
1556       */
1557 
1558         require(addressList.length == 7, "LIST_LENGTH_WRONG");
1559 
1560         initOwner(addressList[0]);
1561         _MAINTAINER_ = addressList[1];
1562         _BASE_TOKEN_ = IERC20(addressList[2]);
1563         _QUOTE_TOKEN_ = IERC20(addressList[3]);
1564         _BIDDER_PERMISSION_ = IPermissionManager(addressList[4]);
1565         _MT_FEE_RATE_MODEL_ = IFeeRateModel(addressList[5]);
1566         _POOL_FACTORY_ = addressList[6];
1567 
1568         /*
1569         Time Line
1570         0. phase bid starttime
1571         1. phase bid duration
1572         2. phase calm duration
1573         3. freeze duration
1574         4. vesting duration
1575         */
1576 
1577         require(timeLine.length == 5, "LIST_LENGTH_WRONG");
1578 
1579         _PHASE_BID_STARTTIME_ = timeLine[0];
1580         _PHASE_BID_ENDTIME_ = _PHASE_BID_STARTTIME_.add(timeLine[1]);
1581         _PHASE_CALM_ENDTIME_ = _PHASE_BID_ENDTIME_.add(timeLine[2]);
1582 
1583         _FREEZE_DURATION_ = timeLine[3];
1584         _VESTING_DURATION_ = timeLine[4];
1585 
1586         require(block.timestamp <= _PHASE_BID_STARTTIME_, "TIMELINE_WRONG");
1587 
1588         /*
1589         Value List
1590         0. pool quote cap
1591         1. k
1592         2. i
1593         3. cliff rate
1594         */
1595 
1596         require(valueList.length == 4, "LIST_LENGTH_WRONG");
1597 
1598         _POOL_QUOTE_CAP_ = valueList[0];
1599         _K_ = valueList[1];
1600         _I_ = valueList[2];
1601         _CLIFF_RATE_ = valueList[3];
1602 
1603         require(_I_ > 0 && _I_ <= 1e36, "I_VALUE_WRONG");
1604         require(_K_ <= 1e18, "K_VALUE_WRONG");
1605         require(_CLIFF_RATE_ <= 1e18, "CLIFF_RATE_WRONG");
1606 
1607         _TOTAL_BASE_ = _BASE_TOKEN_.balanceOf(address(this));
1608 
1609         _IS_OPEN_TWAP_ = isOpenTWAP;
1610 
1611         require(address(this).balance == _SETTEL_FUND_, "SETTLE_FUND_NOT_MATCH");
1612     }
1613 }