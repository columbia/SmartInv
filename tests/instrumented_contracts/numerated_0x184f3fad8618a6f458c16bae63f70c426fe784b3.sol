1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 // File: libraries/SafeMath.sol
4 
5 
6 pragma solidity ^0.7.5;
7 
8 
9 // TODO(zx): Replace all instances of SafeMath with OZ implementation
10 library SafeMath {
11 
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22 
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44 
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50         return c;
51     }
52 
53     // Only used in the  BondingCalculator.sol
54     function sqrrt(uint256 a) internal pure returns (uint c) {
55         if (a > 3) {
56             c = a;
57             uint b = add( div( a, 2), 1 );
58             while (b < c) {
59                 c = b;
60                 b = div( add( div( a, b ), b), 2 );
61             }
62         } else if (a != 0) {
63             c = 1;
64         }
65     }
66 
67 }
68 // File: interfaces/IOlympusAuthority.sol
69 
70 
71 pragma solidity =0.7.5;
72 
73 interface IOlympusAuthority {
74     /* ========== EVENTS ========== */
75     
76     event GovernorPushed(address indexed from, address indexed to, bool _effectiveImmediately);
77     event GuardianPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
78     event PolicyPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
79     event VaultPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
80 
81     event GovernorPulled(address indexed from, address indexed to);
82     event GuardianPulled(address indexed from, address indexed to);
83     event PolicyPulled(address indexed from, address indexed to);
84     event VaultPulled(address indexed from, address indexed to);
85 
86     /* ========== VIEW ========== */
87     
88     function governor() external view returns (address);
89     function guardian() external view returns (address);
90     function policy() external view returns (address);
91     function vault() external view returns (address);
92 }
93 // File: types/OlympusAccessControlled.sol
94 
95 
96 pragma solidity >=0.7.5;
97 
98 
99 abstract contract OlympusAccessControlled {
100 
101     /* ========== EVENTS ========== */
102 
103     event AuthorityUpdated(IOlympusAuthority indexed authority);
104 
105     string UNAUTHORIZED = "UNAUTHORIZED"; // save gas
106 
107     /* ========== STATE VARIABLES ========== */
108 
109     IOlympusAuthority public authority;
110 
111 
112     /* ========== Constructor ========== */
113 
114     constructor(IOlympusAuthority _authority) {
115         authority = _authority;
116         emit AuthorityUpdated(_authority);
117     }
118     
119 
120     /* ========== MODIFIERS ========== */
121     
122     modifier onlyGovernor() {
123         require(msg.sender == authority.governor(), UNAUTHORIZED);
124         _;
125     }
126     
127     modifier onlyGuardian() {
128         require(msg.sender == authority.guardian(), UNAUTHORIZED);
129         _;
130     }
131     
132     modifier onlyPolicy() {
133         require(msg.sender == authority.policy(), UNAUTHORIZED);
134         _;
135     }
136 
137     modifier onlyVault() {
138         require(msg.sender == authority.vault(), UNAUTHORIZED);
139         _;
140     }
141     
142     /* ========== GOV ONLY ========== */
143     
144     function setAuthority(IOlympusAuthority _newAuthority) external onlyGovernor {
145         authority = _newAuthority;
146         emit AuthorityUpdated(_newAuthority);
147     }
148 }
149 
150 // File: interfaces/ITreasuryV1.sol
151 
152 
153 pragma solidity >=0.7.5;
154 
155 interface ITreasuryV1 {
156     function withdraw(uint256 amount, address token) external;
157     function manage(address token, uint256 amount) external;
158     function valueOf(address token, uint256 amount) external view returns (uint256);
159     function excessReserves() external view returns (uint256);
160 }
161 // File: interfaces/IStakingV1.sol
162 
163 
164 pragma solidity >=0.7.5;
165 
166 interface IStakingV1 {
167     function unstake(uint256 _amount, bool _trigger) external;
168 
169     function index() external view returns (uint256);
170 }
171 // File: interfaces/IUniswapV2Router.sol
172 
173 
174 pragma solidity >=0.7.5;
175 
176 interface IUniswapV2Router {
177     function swapExactTokensForTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external returns (uint[] memory amounts);
184 
185     function addLiquidity(
186         address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline
187         ) external returns (uint amountA, uint amountB, uint liquidity);
188         
189     function removeLiquidity(
190         address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline
191         ) external returns (uint amountA, uint amountB);
192 }
193 // File: interfaces/IOwnable.sol
194 
195 
196 pragma solidity >=0.7.5;
197 
198 
199 interface IOwnable {
200   function owner() external view returns (address);
201 
202   function renounceManagement() external;
203   
204   function pushManagement( address newOwner_ ) external;
205   
206   function pullManagement() external;
207 }
208 // File: interfaces/IStaking.sol
209 
210 
211 pragma solidity >=0.7.5;
212 
213 interface IStaking {
214     function stake(
215         address _to,
216         uint256 _amount,
217         bool _rebasing,
218         bool _claim
219     ) external returns (uint256);
220 
221     function claim(address _recipient, bool _rebasing) external returns (uint256);
222 
223     function forfeit() external returns (uint256);
224 
225     function toggleLock() external;
226 
227     function unstake(
228         address _to,
229         uint256 _amount,
230         bool _trigger,
231         bool _rebasing
232     ) external returns (uint256);
233 
234     function wrap(address _to, uint256 _amount) external returns (uint256 gBalance_);
235 
236     function unwrap(address _to, uint256 _amount) external returns (uint256 sBalance_);
237 
238     function rebase() external;
239 
240     function index() external view returns (uint256);
241 
242     function contractBalance() external view returns (uint256);
243 
244     function totalStaked() external view returns (uint256);
245 
246     function supplyInWarmup() external view returns (uint256);
247 }
248 
249 // File: interfaces/ITreasury.sol
250 
251 
252 pragma solidity >=0.7.5;
253 
254 interface ITreasury {
255     function deposit(
256         uint256 _amount,
257         address _token,
258         uint256 _profit
259     ) external returns (uint256);
260 
261     function withdraw(uint256 _amount, address _token) external;
262 
263     function tokenValue(address _token, uint256 _amount) external view returns (uint256 value_);
264 
265     function mint(address _recipient, uint256 _amount) external;
266 
267     function manage(address _token, uint256 _amount) external;
268 
269     function incurDebt(uint256 amount_, address token_) external;
270 
271     function repayDebtWithReserve(uint256 amount_, address token_) external;
272 
273     function excessReserves() external view returns (uint256);
274 }
275 
276 // File: interfaces/IERC20.sol
277 
278 
279 pragma solidity >=0.7.5;
280 
281 interface IERC20 {
282   /**
283    * @dev Returns the amount of tokens in existence.
284    */
285   function totalSupply() external view returns (uint256);
286 
287   /**
288    * @dev Returns the amount of tokens owned by `account`.
289    */
290   function balanceOf(address account) external view returns (uint256);
291 
292   /**
293    * @dev Moves `amount` tokens from the caller's account to `recipient`.
294    *
295    * Returns a boolean value indicating whether the operation succeeded.
296    *
297    * Emits a {Transfer} event.
298    */
299   function transfer(address recipient, uint256 amount) external returns (bool);
300 
301   /**
302    * @dev Returns the remaining number of tokens that `spender` will be
303    * allowed to spend on behalf of `owner` through {transferFrom}. This is
304    * zero by default.
305    *
306    * This value changes when {approve} or {transferFrom} are called.
307    */
308   function allowance(address owner, address spender) external view returns (uint256);
309 
310   /**
311    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
312    *
313    * Returns a boolean value indicating whether the operation succeeded.
314    *
315    * IMPORTANT: Beware that changing an allowance with this method brings the risk
316    * that someone may use both the old and the new allowance by unfortunate
317    * transaction ordering. One possible solution to mitigate this race
318    * condition is to first reduce the spender's allowance to 0 and set the
319    * desired value afterwards:
320    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321    *
322    * Emits an {Approval} event.
323    */
324   function approve(address spender, uint256 amount) external returns (bool);
325 
326   /**
327    * @dev Moves `amount` tokens from `sender` to `recipient` using the
328    * allowance mechanism. `amount` is then deducted from the caller's
329    * allowance.
330    *
331    * Returns a boolean value indicating whether the operation succeeded.
332    *
333    * Emits a {Transfer} event.
334    */
335   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
336 
337   /**
338    * @dev Emitted when `value` tokens are moved from one account (`from`) to
339    * another (`to`).
340    *
341    * Note that `value` may be zero.
342    */
343   event Transfer(address indexed from, address indexed to, uint256 value);
344 
345   /**
346    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
347    * a call to {approve}. `value` is the new allowance.
348    */
349   event Approval(address indexed owner, address indexed spender, uint256 value);
350 }
351 
352 // File: libraries/SafeERC20.sol
353 
354 
355 pragma solidity >=0.7.5;
356 
357 
358 /// @notice Safe IERC20 and ETH transfer library that safely handles missing return values.
359 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/TransferHelper.sol)
360 /// Taken from Solmate
361 library SafeERC20 {
362     function safeTransferFrom(
363         IERC20 token,
364         address from,
365         address to,
366         uint256 amount
367     ) internal {
368         (bool success, bytes memory data) = address(token).call(
369             abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, amount)
370         );
371 
372         require(success && (data.length == 0 || abi.decode(data, (bool))), "TRANSFER_FROM_FAILED");
373     }
374 
375     function safeTransfer(
376         IERC20 token,
377         address to,
378         uint256 amount
379     ) internal {
380         (bool success, bytes memory data) = address(token).call(
381             abi.encodeWithSelector(IERC20.transfer.selector, to, amount)
382         );
383 
384         require(success && (data.length == 0 || abi.decode(data, (bool))), "TRANSFER_FAILED");
385     }
386 
387     function safeApprove(
388         IERC20 token,
389         address to,
390         uint256 amount
391     ) internal {
392         (bool success, bytes memory data) = address(token).call(
393             abi.encodeWithSelector(IERC20.approve.selector, to, amount)
394         );
395 
396         require(success && (data.length == 0 || abi.decode(data, (bool))), "APPROVE_FAILED");
397     }
398 
399     function safeTransferETH(address to, uint256 amount) internal {
400         (bool success, ) = to.call{value: amount}(new bytes(0));
401 
402         require(success, "ETH_TRANSFER_FAILED");
403     }
404 }
405 // File: interfaces/IgOHM.sol
406 
407 
408 pragma solidity >=0.7.5;
409 
410 
411 interface IgOHM is IERC20 {
412   function mint(address _to, uint256 _amount) external;
413 
414   function burn(address _from, uint256 _amount) external;
415 
416   function index() external view returns (uint256);
417 
418   function balanceFrom(uint256 _amount) external view returns (uint256);
419 
420   function balanceTo(uint256 _amount) external view returns (uint256);
421 
422   function migrate( address _staking, address _sOHM ) external;
423 }
424 
425 // File: interfaces/IwsOHM.sol
426 
427 
428 pragma solidity >=0.7.5;
429 
430 
431 // Old wsOHM interface
432 interface IwsOHM is IERC20 {
433   function wrap(uint256 _amount) external returns (uint256);
434 
435   function unwrap(uint256 _amount) external returns (uint256);
436 
437   function wOHMTosOHM(uint256 _amount) external view returns (uint256);
438 
439   function sOHMTowOHM(uint256 _amount) external view returns (uint256);
440 }
441 
442 // File: interfaces/IsOHM.sol
443 
444 
445 pragma solidity >=0.7.5;
446 
447 
448 interface IsOHM is IERC20 {
449     function rebase( uint256 ohmProfit_, uint epoch_) external returns (uint256);
450 
451     function circulatingSupply() external view returns (uint256);
452 
453     function gonsForBalance( uint amount ) external view returns ( uint );
454 
455     function balanceForGons( uint gons ) external view returns ( uint );
456 
457     function index() external view returns ( uint );
458 
459     function toG(uint amount) external view returns (uint);
460 
461     function fromG(uint amount) external view returns (uint);
462 
463      function changeDebt(
464         uint256 amount,
465         address debtor,
466         bool add
467     ) external;
468 
469     function debtBalances(address _address) external view returns (uint256);
470 }
471 
472 // File: gOHM.sol
473 
474 
475 pragma solidity 0.7.5;
476 
477 
478 
479 
480 
481 
482 
483 
484 
485 
486 
487 
488 
489 
490 
491 contract OlympusTokenMigrator is OlympusAccessControlled {
492     using SafeMath for uint256;
493     using SafeERC20 for IERC20;
494     using SafeERC20 for IgOHM;
495     using SafeERC20 for IsOHM;
496     using SafeERC20 for IwsOHM;
497 
498     /* ========== MIGRATION ========== */
499 
500     event TimelockStarted(uint256 block, uint256 end);
501     event Migrated(address staking, address treasury);
502     event Funded(uint256 amount);
503     event Defunded(uint256 amount);
504 
505     /* ========== STATE VARIABLES ========== */
506 
507     IERC20 public immutable oldOHM;
508     IsOHM public immutable oldsOHM;
509     IwsOHM public immutable oldwsOHM;
510     ITreasuryV1 public immutable oldTreasury;
511     IStakingV1 public immutable oldStaking;
512 
513     IUniswapV2Router public immutable sushiRouter;
514     IUniswapV2Router public immutable uniRouter;
515 
516     IgOHM public gOHM;
517     ITreasury public newTreasury;
518     IStaking public newStaking;
519     IERC20 public newOHM;
520 
521     bool public ohmMigrated;
522     bool public shutdown;
523 
524     uint256 public immutable timelockLength;
525     uint256 public timelockEnd;
526 
527     uint256 public oldSupply;
528 
529     constructor(
530         address _oldOHM,
531         address _oldsOHM,
532         address _oldTreasury,
533         address _oldStaking,
534         address _oldwsOHM,
535         address _sushi,
536         address _uni,
537         uint256 _timelock,
538         address _authority
539     ) OlympusAccessControlled(IOlympusAuthority(_authority)) {
540         require(_oldOHM != address(0), "Zero address: OHM");
541         oldOHM = IERC20(_oldOHM);
542         require(_oldsOHM != address(0), "Zero address: sOHM");
543         oldsOHM = IsOHM(_oldsOHM);
544         require(_oldTreasury != address(0), "Zero address: Treasury");
545         oldTreasury = ITreasuryV1(_oldTreasury);
546         require(_oldStaking != address(0), "Zero address: Staking");
547         oldStaking = IStakingV1(_oldStaking);
548         require(_oldwsOHM != address(0), "Zero address: wsOHM");
549         oldwsOHM = IwsOHM(_oldwsOHM);
550         require(_sushi != address(0), "Zero address: Sushi");
551         sushiRouter = IUniswapV2Router(_sushi);
552         require(_uni != address(0), "Zero address: Uni");
553         uniRouter = IUniswapV2Router(_uni);
554         timelockLength = _timelock;
555     }
556 
557     /* ========== MIGRATION ========== */
558 
559     enum TYPE {
560         UNSTAKED,
561         STAKED,
562         WRAPPED
563     }
564 
565     // migrate OHMv1, sOHMv1, or wsOHM for OHMv2, sOHMv2, or gOHM
566     function migrate(
567         uint256 _amount,
568         TYPE _from,
569         TYPE _to
570     ) external {
571         require(!shutdown, "Shut down");
572 
573         uint256 wAmount = oldwsOHM.sOHMTowOHM(_amount);
574 
575         if (_from == TYPE.UNSTAKED) {
576             require(ohmMigrated, "Only staked until migration");
577             oldOHM.safeTransferFrom(msg.sender, address(this), _amount);
578         } else if (_from == TYPE.STAKED) {
579             oldsOHM.safeTransferFrom(msg.sender, address(this), _amount);
580         } else {
581             oldwsOHM.safeTransferFrom(msg.sender, address(this), _amount);
582             wAmount = _amount;
583         }
584 
585         if (ohmMigrated) {
586             require(oldSupply >= oldOHM.totalSupply(), "OHMv1 minted");
587             _send(wAmount, _to);
588         } else {
589             gOHM.mint(msg.sender, wAmount);
590         }
591     }
592 
593     // migrate all olympus tokens held
594     function migrateAll(TYPE _to) external {
595         require(!shutdown, "Shut down");
596 
597         uint256 ohmBal = 0;
598         uint256 sOHMBal = oldsOHM.balanceOf(msg.sender);
599         uint256 wsOHMBal = oldwsOHM.balanceOf(msg.sender);
600 
601         if (oldOHM.balanceOf(msg.sender) > 0 && ohmMigrated) {
602             ohmBal = oldOHM.balanceOf(msg.sender);
603             oldOHM.safeTransferFrom(msg.sender, address(this), ohmBal);
604         }
605         if (sOHMBal > 0) {
606             oldsOHM.safeTransferFrom(msg.sender, address(this), sOHMBal);
607         }
608         if (wsOHMBal > 0) {
609             oldwsOHM.safeTransferFrom(msg.sender, address(this), wsOHMBal);
610         }
611 
612         uint256 wAmount = wsOHMBal.add(oldwsOHM.sOHMTowOHM(ohmBal.add(sOHMBal)));
613         if (ohmMigrated) {
614             require(oldSupply >= oldOHM.totalSupply(), "OHMv1 minted");
615             _send(wAmount, _to);
616         } else {
617             gOHM.mint(msg.sender, wAmount);
618         }
619     }
620 
621     // send preferred token
622     function _send(uint256 wAmount, TYPE _to) internal {
623         if (_to == TYPE.WRAPPED) {
624             gOHM.safeTransfer(msg.sender, wAmount);
625         } else if (_to == TYPE.STAKED) {
626             newStaking.unwrap(msg.sender, wAmount);
627         } else if (_to == TYPE.UNSTAKED) {
628             newStaking.unstake(msg.sender, wAmount, false, false);
629         }
630     }
631 
632     // bridge back to OHM, sOHM, or wsOHM
633     function bridgeBack(uint256 _amount, TYPE _to) external {
634         if (!ohmMigrated) {
635             gOHM.burn(msg.sender, _amount);
636         } else {
637             gOHM.safeTransferFrom(msg.sender, address(this), _amount);
638         }
639 
640         uint256 amount = oldwsOHM.wOHMTosOHM(_amount);
641         // error throws if contract does not have enough of type to send
642         if (_to == TYPE.UNSTAKED) {
643             oldOHM.safeTransfer(msg.sender, amount);
644         } else if (_to == TYPE.STAKED) {
645             oldsOHM.safeTransfer(msg.sender, amount);
646         } else if (_to == TYPE.WRAPPED) {
647             oldwsOHM.safeTransfer(msg.sender, _amount);
648         }
649     }
650 
651     /* ========== OWNABLE ========== */
652 
653     // halt migrations (but not bridging back)
654     function halt() external onlyPolicy {
655         require(!ohmMigrated, "Migration has occurred");
656         shutdown = !shutdown;
657     }
658 
659     // withdraw backing of migrated OHM
660     function defund(address reserve) external onlyGovernor {
661         require(ohmMigrated, "Migration has not begun");
662         require(timelockEnd < block.number && timelockEnd != 0, "Timelock not complete");
663 
664         oldwsOHM.unwrap(oldwsOHM.balanceOf(address(this)));
665 
666         uint256 amountToUnstake = oldsOHM.balanceOf(address(this));
667         oldsOHM.approve(address(oldStaking), amountToUnstake);
668         oldStaking.unstake(amountToUnstake, false);
669 
670         uint256 balance = oldOHM.balanceOf(address(this));
671 
672         if(balance > oldSupply) {
673             oldSupply = 0;
674         } else {
675             oldSupply -= balance;
676         }
677 
678         uint256 amountToWithdraw = balance.mul(1e9);
679         oldOHM.approve(address(oldTreasury), amountToWithdraw);
680         oldTreasury.withdraw(amountToWithdraw, reserve);
681         IERC20(reserve).safeTransfer(address(newTreasury), IERC20(reserve).balanceOf(address(this)));
682 
683         emit Defunded(balance);
684     }
685 
686     // start timelock to send backing to new treasury
687     function startTimelock() external onlyGovernor {
688         require(timelockEnd == 0, "Timelock set");
689         timelockEnd = block.number.add(timelockLength);
690 
691         emit TimelockStarted(block.number, timelockEnd);
692     }
693 
694     // set gOHM address
695     function setgOHM(address _gOHM) external onlyGovernor {
696         require(address(gOHM) == address(0), "Already set");
697         require(_gOHM != address(0), "Zero address: gOHM");
698 
699         gOHM = IgOHM(_gOHM);
700     }
701 
702     // call internal migrate token function
703     function migrateToken(address token) external onlyGovernor {
704         _migrateToken(token, false);
705     }
706 
707     /**
708      *   @notice Migrate LP and pair with new OHM
709      */
710     function migrateLP(
711         address pair,
712         bool sushi,
713         address token,
714         uint256 _minA,
715         uint256 _minB
716     ) external onlyGovernor {
717         uint256 oldLPAmount = IERC20(pair).balanceOf(address(oldTreasury));
718         oldTreasury.manage(pair, oldLPAmount);
719 
720         IUniswapV2Router router = sushiRouter;
721         if (!sushi) {
722             router = uniRouter;
723         }
724 
725         IERC20(pair).approve(address(router), oldLPAmount);
726         (uint256 amountA, uint256 amountB) = router.removeLiquidity(
727             token, 
728             address(oldOHM), 
729             oldLPAmount,
730             _minA, 
731             _minB, 
732             address(this), 
733             block.timestamp
734         );
735 
736         newTreasury.mint(address(this), amountB);
737 
738         IERC20(token).approve(address(router), amountA);
739         newOHM.approve(address(router), amountB);
740 
741         router.addLiquidity(
742             token, 
743             address(newOHM), 
744             amountA, 
745             amountB, 
746             amountA, 
747             amountB, 
748             address(newTreasury), 
749             block.timestamp
750         );
751     }
752 
753     // Failsafe function to allow owner to withdraw funds sent directly to contract in case someone sends non-ohm tokens to the contract
754     function withdrawToken(
755         address tokenAddress,
756         uint256 amount,
757         address recipient
758     ) external onlyGovernor {
759         require(tokenAddress != address(0), "Token address cannot be 0x0");
760         require(tokenAddress != address(gOHM), "Cannot withdraw: gOHM");
761         require(tokenAddress != address(oldOHM), "Cannot withdraw: old-OHM");
762         require(tokenAddress != address(oldsOHM), "Cannot withdraw: old-sOHM");
763         require(tokenAddress != address(oldwsOHM), "Cannot withdraw: old-wsOHM");
764         require(amount > 0, "Withdraw value must be greater than 0");
765         if (recipient == address(0)) {
766             recipient = msg.sender; // if no address is specified the value will will be withdrawn to Owner
767         }
768 
769         IERC20 tokenContract = IERC20(tokenAddress);
770         uint256 contractBalance = tokenContract.balanceOf(address(this));
771         if (amount > contractBalance) {
772             amount = contractBalance; // set the withdrawal amount equal to balance within the account.
773         }
774         // transfer the token from address of this contract
775         tokenContract.safeTransfer(recipient, amount);
776     }
777 
778     // migrate contracts
779     function migrateContracts(
780         address _newTreasury,
781         address _newStaking,
782         address _newOHM,
783         address _newsOHM,
784         address _reserve
785     ) external onlyGovernor {
786         require(!ohmMigrated, "Already migrated");
787         ohmMigrated = true;
788         shutdown = false;
789 
790         require(_newTreasury != address(0), "Zero address: Treasury");
791         newTreasury = ITreasury(_newTreasury);
792         require(_newStaking != address(0), "Zero address: Staking");
793         newStaking = IStaking(_newStaking);
794         require(_newOHM != address(0), "Zero address: OHM");
795         newOHM = IERC20(_newOHM);
796 
797         oldSupply = oldOHM.totalSupply(); // log total supply at time of migration
798 
799         gOHM.migrate(_newStaking, _newsOHM); // change gOHM minter
800 
801         _migrateToken(_reserve, true); // will deposit tokens into new treasury so reserves can be accounted for
802 
803         _fund(oldsOHM.circulatingSupply()); // fund with current staked supply for token migration
804 
805         emit Migrated(_newStaking, _newTreasury);
806     }
807 
808     /* ========== INTERNAL FUNCTIONS ========== */
809 
810     // fund contract with gOHM
811     function _fund(uint256 _amount) internal {
812         newTreasury.mint(address(this), _amount);
813         newOHM.approve(address(newStaking), _amount);
814         newStaking.stake(address(this), _amount, false, true); // stake and claim gOHM
815 
816         emit Funded(_amount);
817     }
818 
819     /**
820      *   @notice Migrate token from old treasury to new treasury
821      */
822     function _migrateToken(address token, bool deposit) internal {
823         uint256 balance = IERC20(token).balanceOf(address(oldTreasury));
824 
825         uint256 excessReserves = oldTreasury.excessReserves();
826         uint256 tokenValue = oldTreasury.valueOf(token, balance);
827 
828         if (tokenValue > excessReserves) {
829             tokenValue = excessReserves;
830             balance = excessReserves * 10**9;
831         }
832 
833         oldTreasury.manage(token, balance);
834 
835         if (deposit) {
836             IERC20(token).safeApprove(address(newTreasury), balance);
837             newTreasury.deposit(balance, token, tokenValue);
838         } else {
839             IERC20(token).safeTransfer(address(newTreasury), balance);
840         }
841     }
842 }