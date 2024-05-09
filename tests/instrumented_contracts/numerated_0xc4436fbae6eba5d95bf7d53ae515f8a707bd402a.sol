1 // File: contracts/intf/IERC20.sol
2 
3 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity 0.6.9;
7 pragma experimental ABIEncoderV2;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     function decimals() external view returns (uint8);
19 
20     function name() external view returns (string memory);
21 
22     function symbol() external view returns (string memory);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 }
78 
79 // File: contracts/lib/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @author DODO Breeder
84  *
85  * @notice Math operations with safety checks that revert on error
86  */
87 library SafeMath {
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "MUL_ERROR");
95 
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b > 0, "DIVIDING_ERROR");
101         return a / b;
102     }
103 
104     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 quotient = div(a, b);
106         uint256 remainder = a - quotient * b;
107         if (remainder > 0) {
108             return quotient + 1;
109         } else {
110             return quotient;
111         }
112     }
113 
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b <= a, "SUB_ERROR");
116         return a - b;
117     }
118 
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "ADD_ERROR");
122         return c;
123     }
124 
125     function sqrt(uint256 x) internal pure returns (uint256 y) {
126         uint256 z = x / 2 + 1;
127         y = x;
128         while (z < y) {
129             y = z;
130             z = (x / z + z) / 2;
131         }
132     }
133 }
134 
135 // File: contracts/lib/DecimalMath.sol
136 
137 /**
138  * @title DecimalMath
139  * @author DODO Breeder
140  *
141  * @notice Functions for fixed point number with 18 decimals
142  */
143 library DecimalMath {
144     using SafeMath for uint256;
145 
146     uint256 internal constant ONE = 10**18;
147     uint256 internal constant ONE2 = 10**36;
148 
149     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
150         return target.mul(d) / (10**18);
151     }
152 
153     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
154         return target.mul(d).divCeil(10**18);
155     }
156 
157     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
158         return target.mul(10**18).div(d);
159     }
160 
161     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
162         return target.mul(10**18).divCeil(d);
163     }
164 
165     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
166         return uint256(10**36).div(target);
167     }
168 
169     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
170         return uint256(10**36).divCeil(target);
171     }
172 }
173 
174 // File: contracts/lib/InitializableOwnable.sol
175 
176 /**
177  * @title Ownable
178  * @author DODO Breeder
179  *
180  * @notice Ownership related functions
181  */
182 contract InitializableOwnable {
183     address public _OWNER_;
184     address public _NEW_OWNER_;
185     bool internal _INITIALIZED_;
186 
187     // ============ Events ============
188 
189     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     // ============ Modifiers ============
194 
195     modifier notInitialized() {
196         require(!_INITIALIZED_, "DODO_INITIALIZED");
197         _;
198     }
199 
200     modifier onlyOwner() {
201         require(msg.sender == _OWNER_, "NOT_OWNER");
202         _;
203     }
204 
205     // ============ Functions ============
206 
207     function initOwner(address newOwner) public notInitialized {
208         _INITIALIZED_ = true;
209         _OWNER_ = newOwner;
210     }
211 
212     function transferOwnership(address newOwner) public onlyOwner {
213         emit OwnershipTransferPrepared(_OWNER_, newOwner);
214         _NEW_OWNER_ = newOwner;
215     }
216 
217     function claimOwnership() public {
218         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
219         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
220         _OWNER_ = _NEW_OWNER_;
221         _NEW_OWNER_ = address(0);
222     }
223 }
224 
225 // File: contracts/lib/SafeERC20.sol
226 
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
305 // File: contracts/intf/IDODOApprove.sol
306 
307 
308 interface IDODOApprove {
309     function claimTokens(address token,address who,address dest,uint256 amount) external;
310     function getDODOProxy() external view returns (address);
311 }
312 
313 // File: contracts/SmartRoute/DODOApproveProxy.sol
314 
315 
316 interface IDODOApproveProxy {
317     function isAllowedProxy(address _proxy) external view returns (bool);
318     function claimTokens(address token,address who,address dest,uint256 amount) external;
319 }
320 
321 /**
322  * @title DODOApproveProxy
323  * @author DODO Breeder
324  *
325  * @notice Allow different version dodoproxy to claim from DODOApprove
326  */
327 contract DODOApproveProxy is InitializableOwnable {
328     
329     // ============ Storage ============
330     uint256 private constant _TIMELOCK_DURATION_ = 3 days;
331     mapping (address => bool) public _IS_ALLOWED_PROXY_;
332     uint256 public _TIMELOCK_;
333     address public _PENDING_ADD_DODO_PROXY_;
334     address public immutable _DODO_APPROVE_;
335 
336     // ============ Modifiers ============
337     modifier notLocked() {
338         require(
339             _TIMELOCK_ <= block.timestamp,
340             "SetProxy is timelocked"
341         );
342         _;
343     }
344 
345     constructor(address dodoApporve) public {
346         _DODO_APPROVE_ = dodoApporve;
347     }
348 
349     function init(address owner, address[] memory proxies) external {
350         initOwner(owner);
351         for(uint i = 0; i < proxies.length; i++) 
352             _IS_ALLOWED_PROXY_[proxies[i]] = true;
353     }
354 
355     function unlockAddProxy(address newDodoProxy) public onlyOwner {
356         _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;
357         _PENDING_ADD_DODO_PROXY_ = newDodoProxy;
358     }
359 
360     function lockAddProxy() public onlyOwner {
361        _PENDING_ADD_DODO_PROXY_ = address(0);
362        _TIMELOCK_ = 0;
363     }
364 
365 
366     function addDODOProxy() external onlyOwner notLocked() {
367         _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;
368         lockAddProxy();
369     }
370 
371     function removeDODOProxy (address oldDodoProxy) public onlyOwner {
372         _IS_ALLOWED_PROXY_[oldDodoProxy] = false;
373     }
374     
375     function claimTokens(
376         address token,
377         address who,
378         address dest,
379         uint256 amount
380     ) external {
381         require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");
382         IDODOApprove(_DODO_APPROVE_).claimTokens(
383             token,
384             who,
385             dest,
386             amount
387         );
388     }
389 
390     function isAllowedProxy(address _proxy) external view returns (bool) {
391         return _IS_ALLOWED_PROXY_[_proxy];
392     }
393 }
394 
395 // File: contracts/DODOToken/vDODOToken.sol
396 
397 
398 
399 interface IGovernance {
400     function getLockedvDODO(address account) external view returns (uint256);
401 }
402 
403 interface IDODOCirculationHelper {
404     // Locked vDOOD not counted in circulation
405     function getCirculation() external view returns (uint256);
406 
407     function getDodoWithdrawFeeRatio() external view returns (uint256);
408 }
409 
410 contract vDODOToken is InitializableOwnable {
411     using SafeMath for uint256;
412 
413     // ============ Storage(ERC20) ============
414 
415     string public name = "vDODO Membership Token";
416     string public symbol = "vDODO";
417     uint8 public decimals = 18;
418     mapping(address => mapping(address => uint256)) internal _ALLOWED_;
419 
420     // ============ Storage ============
421 
422     address public immutable _DODO_TOKEN_;
423     address public immutable _DODO_APPROVE_PROXY_;
424     address public immutable _DODO_TEAM_;
425     address public _DOOD_GOV_;
426     address public _DODO_CIRCULATION_HELPER_;
427 
428     bool public _CAN_TRANSFER_;
429 
430     // staking reward parameters
431     uint256 public _DODO_PER_BLOCK_;
432     uint256 public constant _SUPERIOR_RATIO_ = 10**17; // 0.1
433     uint256 public constant _DODO_RATIO_ = 100; // 100
434     uint256 public _DODO_FEE_BURN_RATIO_;
435 
436     // accounting
437     uint112 public alpha = 10**18; // 1
438     uint112 public _TOTAL_BLOCK_DISTRIBUTION_;
439     uint32 public _LAST_REWARD_BLOCK_;
440 
441     uint256 public _TOTAL_BLOCK_REWARD_;
442     uint256 public _TOTAL_STAKING_POWER_;
443     mapping(address => UserInfo) public userInfo;
444 
445     struct UserInfo {
446         uint128 stakingPower;
447         uint128 superiorSP;
448         address superior;
449         uint256 credit;
450     }
451 
452     // ============ Events ============
453 
454     event MintVDODO(address user, address superior, uint256 mintDODO);
455     event RedeemVDODO(address user, uint256 receiveDODO, uint256 burnDODO, uint256 feeDODO);
456     event DonateDODO(address user, uint256 donateDODO);
457     event SetCantransfer(bool allowed);
458 
459     event PreDeposit(uint256 dodoAmount);
460     event ChangePerReward(uint256 dodoPerBlock);
461     event UpdateDODOFeeBurnRatio(uint256 dodoFeeBurnRatio);
462 
463     event Transfer(address indexed from, address indexed to, uint256 amount);
464     event Approval(address indexed owner, address indexed spender, uint256 amount);
465 
466     // ============ Modifiers ============
467 
468     modifier canTransfer() {
469         require(_CAN_TRANSFER_, "vDODOToken: not allowed transfer");
470         _;
471     }
472 
473     modifier balanceEnough(address account, uint256 amount) {
474         require(availableBalanceOf(account) >= amount, "vDODOToken: available amount not enough");
475         _;
476     }
477 
478     // ============ Constructor ============
479 
480     constructor(
481         address dodoGov,
482         address dodoToken,
483         address dodoApproveProxy,
484         address dodoTeam
485     ) public {
486         _DOOD_GOV_ = dodoGov;
487         _DODO_TOKEN_ = dodoToken;
488         _DODO_APPROVE_PROXY_ = dodoApproveProxy;
489         _DODO_TEAM_ = dodoTeam;
490     }
491 
492     // ============ Ownable Functions ============`
493 
494     function setCantransfer(bool allowed) public onlyOwner {
495         _CAN_TRANSFER_ = allowed;
496         emit SetCantransfer(allowed);
497     }
498 
499     function changePerReward(uint256 dodoPerBlock) public onlyOwner {
500         _updateAlpha();
501         _DODO_PER_BLOCK_ = dodoPerBlock;
502         emit ChangePerReward(dodoPerBlock);
503     }
504 
505     function updateDODOFeeBurnRatio(uint256 dodoFeeBurnRatio) public onlyOwner {
506         _DODO_FEE_BURN_RATIO_ = dodoFeeBurnRatio;
507         emit UpdateDODOFeeBurnRatio(_DODO_FEE_BURN_RATIO_);
508     }
509 
510     function updateDODOCirculationHelper(address helper) public onlyOwner {
511         _DODO_CIRCULATION_HELPER_ = helper;
512     }
513 
514     function updateGovernance(address governance) public onlyOwner {
515         _DOOD_GOV_ = governance;
516     }
517 
518     function emergencyWithdraw() public onlyOwner {
519         uint256 dodoBalance = IERC20(_DODO_TOKEN_).balanceOf(address(this));
520         IERC20(_DODO_TOKEN_).transfer(_OWNER_, dodoBalance);
521     }
522 
523     // ============ Mint & Redeem & Donate ============
524 
525     function mint(uint256 dodoAmount, address superiorAddress) public {
526         require(
527             superiorAddress != address(0) && superiorAddress != msg.sender,
528             "vDODOToken: Superior INVALID"
529         );
530         require(dodoAmount > 0, "vDODOToken: must mint greater than 0");
531 
532         UserInfo storage user = userInfo[msg.sender];
533 
534         if (user.superior == address(0)) {
535             require(
536                 superiorAddress == _DODO_TEAM_ || userInfo[superiorAddress].superior != address(0),
537                 "vDODOToken: INVALID_SUPERIOR_ADDRESS"
538             );
539             user.superior = superiorAddress;
540         }
541 
542         _updateAlpha();
543 
544         IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
545             _DODO_TOKEN_,
546             msg.sender,
547             address(this),
548             dodoAmount
549         );
550 
551         uint256 newStakingPower = DecimalMath.divFloor(dodoAmount, alpha);
552 
553         _mint(user, newStakingPower);
554 
555         emit MintVDODO(msg.sender, superiorAddress, dodoAmount);
556     }
557 
558     function redeem(uint256 vdodoAmount, bool all) public balanceEnough(msg.sender, vdodoAmount) {
559         _updateAlpha();
560         UserInfo storage user = userInfo[msg.sender];
561 
562         uint256 dodoAmount;
563         uint256 stakingPower;
564 
565         if (all) {
566             stakingPower = uint256(user.stakingPower).sub(DecimalMath.divFloor(user.credit, alpha));
567             dodoAmount = DecimalMath.mulFloor(stakingPower, alpha);
568         } else {
569             dodoAmount = vdodoAmount.mul(_DODO_RATIO_);
570             stakingPower = DecimalMath.divFloor(dodoAmount, alpha);
571         }
572 
573         _redeem(user, stakingPower);
574 
575         (uint256 dodoReceive, uint256 burnDodoAmount, uint256 withdrawFeeDodoAmount) = getWithdrawResult(dodoAmount);
576 
577         IERC20(_DODO_TOKEN_).transfer(msg.sender, dodoReceive);
578         
579         if (burnDodoAmount > 0) {
580             IERC20(_DODO_TOKEN_).transfer(address(0), burnDodoAmount);
581         }
582         
583         if (withdrawFeeDodoAmount > 0) {
584             alpha = uint112(
585                 uint256(alpha).add(
586                     DecimalMath.divFloor(withdrawFeeDodoAmount, _TOTAL_STAKING_POWER_)
587                 )
588             );
589         }
590 
591         emit RedeemVDODO(msg.sender, dodoReceive, burnDodoAmount, withdrawFeeDodoAmount);
592     }
593 
594     function donate(uint256 dodoAmount) public {
595         IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
596             _DODO_TOKEN_,
597             msg.sender,
598             address(this),
599             dodoAmount
600         );
601         alpha = uint112(
602             uint256(alpha).add(DecimalMath.divFloor(dodoAmount, _TOTAL_STAKING_POWER_))
603         );
604         emit DonateDODO(msg.sender, dodoAmount);
605     }
606 
607     function preDepositedBlockReward(uint256 dodoAmount) public {
608         IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
609             _DODO_TOKEN_,
610             msg.sender,
611             address(this),
612             dodoAmount
613         );
614         _TOTAL_BLOCK_REWARD_ = _TOTAL_BLOCK_REWARD_.add(dodoAmount);
615         emit PreDeposit(dodoAmount);
616     }
617 
618     // ============ ERC20 Functions ============
619 
620     function totalSupply() public view returns (uint256 vDODOSupply) {
621         uint256 totalDODO = IERC20(_DODO_TOKEN_).balanceOf(address(this));
622         (,uint256 curDistribution) = getLatestAlpha();
623         uint256 actualDODO = totalDODO.sub(_TOTAL_BLOCK_REWARD_.sub(curDistribution.add(_TOTAL_BLOCK_DISTRIBUTION_)));
624         vDODOSupply = actualDODO / _DODO_RATIO_;
625     }
626     
627     function balanceOf(address account) public view returns (uint256 vDODOAmount) {
628         vDODOAmount = dodoBalanceOf(account) / _DODO_RATIO_;
629     }
630 
631     function transfer(address to, uint256 vDODOAmount) public returns (bool) {
632         _updateAlpha();
633         _transfer(msg.sender, to, vDODOAmount);
634         return true;
635     }
636 
637     function approve(address spender, uint256 vDODOAmount) canTransfer public returns (bool) {
638         _ALLOWED_[msg.sender][spender] = vDODOAmount;
639         emit Approval(msg.sender, spender, vDODOAmount);
640         return true;
641     }
642 
643     function transferFrom(
644         address from,
645         address to,
646         uint256 vDODOAmount
647     ) public returns (bool) {
648         require(vDODOAmount <= _ALLOWED_[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
649         _updateAlpha();
650         _transfer(from, to, vDODOAmount);
651         _ALLOWED_[from][msg.sender] = _ALLOWED_[from][msg.sender].sub(vDODOAmount);
652         return true;
653     }
654 
655     function allowance(address owner, address spender) public view returns (uint256) {
656         return _ALLOWED_[owner][spender];
657     }
658 
659     // ============ Helper Functions ============
660 
661     function getLatestAlpha() public view returns (uint256 newAlpha, uint256 curDistribution) {
662         if (_LAST_REWARD_BLOCK_ == 0) {
663             curDistribution = 0;
664         } else {
665             curDistribution = _DODO_PER_BLOCK_ * (block.number - _LAST_REWARD_BLOCK_);
666         }
667         if (_TOTAL_STAKING_POWER_ > 0) {
668             newAlpha = uint256(alpha).add(DecimalMath.divFloor(curDistribution, _TOTAL_STAKING_POWER_));
669         } else {
670             newAlpha = alpha;
671         }
672     }
673 
674     function availableBalanceOf(address account) public view returns (uint256 vDODOAmount) {
675         if (_DOOD_GOV_ == address(0)) {
676             vDODOAmount = balanceOf(account);
677         } else {
678             uint256 lockedvDODOAmount = IGovernance(_DOOD_GOV_).getLockedvDODO(account);
679             vDODOAmount = balanceOf(account).sub(lockedvDODOAmount);
680         }
681     }
682 
683     function dodoBalanceOf(address account) public view returns (uint256 dodoAmount) {
684         UserInfo memory user = userInfo[account];
685         (uint256 newAlpha,) = getLatestAlpha();
686         uint256 nominalDodo =  DecimalMath.mulFloor(uint256(user.stakingPower), newAlpha);
687         if(nominalDodo > user.credit) {
688             dodoAmount = nominalDodo - user.credit;
689         }else {
690             dodoAmount = 0;
691         }
692     }
693 
694     function getWithdrawResult(uint256 dodoAmount)
695         public
696         view
697         returns (
698             uint256 dodoReceive,
699             uint256 burnDodoAmount,
700             uint256 withdrawFeeDodoAmount
701         )
702     {
703         uint256 feeRatio =
704             IDODOCirculationHelper(_DODO_CIRCULATION_HELPER_).getDodoWithdrawFeeRatio();
705 
706         withdrawFeeDodoAmount = DecimalMath.mulFloor(dodoAmount, feeRatio);
707         dodoReceive = dodoAmount.sub(withdrawFeeDodoAmount);
708 
709         burnDodoAmount = DecimalMath.mulFloor(withdrawFeeDodoAmount, _DODO_FEE_BURN_RATIO_);
710         withdrawFeeDodoAmount = withdrawFeeDodoAmount.sub(burnDodoAmount);
711     }
712 
713     function getDODOWithdrawFeeRatio() public view returns (uint256 feeRatio) {
714         feeRatio = IDODOCirculationHelper(_DODO_CIRCULATION_HELPER_).getDodoWithdrawFeeRatio();
715     }
716 
717     function getSuperior(address account) public view returns (address superior) {
718         return userInfo[account].superior;
719     }
720 
721     // ============ Internal Functions ============
722 
723     function _updateAlpha() internal {
724         (uint256 newAlpha, uint256 curDistribution) = getLatestAlpha();
725         uint256 newTotalDistribution = curDistribution.add(_TOTAL_BLOCK_DISTRIBUTION_);
726         require(newAlpha <= uint112(-1) && newTotalDistribution <= uint112(-1), "OVERFLOW");
727         alpha = uint112(newAlpha);
728         _TOTAL_BLOCK_DISTRIBUTION_ = uint112(newTotalDistribution);
729         _LAST_REWARD_BLOCK_ = uint32(block.number);
730     }
731 
732     function _mint(UserInfo storage to, uint256 stakingPower) internal {
733         require(stakingPower <= uint128(-1), "OVERFLOW");
734         UserInfo storage superior = userInfo[to.superior];
735         uint256 superiorIncreSP = DecimalMath.mulFloor(stakingPower, _SUPERIOR_RATIO_);
736         uint256 superiorIncreCredit = DecimalMath.mulFloor(superiorIncreSP, alpha);
737 
738         to.stakingPower = uint128(uint256(to.stakingPower).add(stakingPower));
739         to.superiorSP = uint128(uint256(to.superiorSP).add(superiorIncreSP));
740 
741         superior.stakingPower = uint128(uint256(superior.stakingPower).add(superiorIncreSP));
742         superior.credit = uint128(uint256(superior.credit).add(superiorIncreCredit));
743 
744         _TOTAL_STAKING_POWER_ = _TOTAL_STAKING_POWER_.add(stakingPower).add(superiorIncreSP);
745     }
746 
747     function _redeem(UserInfo storage from, uint256 stakingPower) internal {
748         from.stakingPower = uint128(uint256(from.stakingPower).sub(stakingPower));
749 
750         // superior decrease sp = min(stakingPower*0.1, from.superiorSP)
751         uint256 superiorDecreSP = DecimalMath.mulFloor(stakingPower, _SUPERIOR_RATIO_);
752         superiorDecreSP = from.superiorSP <= superiorDecreSP ? from.superiorSP : superiorDecreSP;
753         from.superiorSP = uint128(uint256(from.superiorSP).sub(superiorDecreSP));
754 
755         UserInfo storage superior = userInfo[from.superior];
756         uint256 creditSP = DecimalMath.divFloor(superior.credit, alpha);
757 
758         if (superiorDecreSP >= creditSP) {
759             superior.credit = 0;
760             superior.stakingPower = uint128(uint256(superior.stakingPower).sub(creditSP));
761         } else {
762             superior.credit = uint128(
763                 uint256(superior.credit).sub(DecimalMath.mulFloor(superiorDecreSP, alpha))
764             );
765             superior.stakingPower = uint128(uint256(superior.stakingPower).sub(superiorDecreSP));
766         }
767 
768         _TOTAL_STAKING_POWER_ = _TOTAL_STAKING_POWER_.sub(stakingPower).sub(superiorDecreSP);
769     }
770 
771     function _transfer(
772         address from,
773         address to,
774         uint256 vDODOAmount
775     ) internal canTransfer balanceEnough(from, vDODOAmount) {
776         require(from != address(0), "transfer from the zero address");
777         require(to != address(0), "transfer to the zero address");
778         require(from != to, "transfer from same with to");
779 
780         uint256 stakingPower = DecimalMath.divFloor(vDODOAmount * _DODO_RATIO_, alpha);
781 
782         UserInfo storage fromUser = userInfo[from];
783         UserInfo storage toUser = userInfo[to];
784 
785         _redeem(fromUser, stakingPower);
786         _mint(toUser, stakingPower);
787 
788         emit Transfer(from, to, vDODOAmount);
789     }
790 }