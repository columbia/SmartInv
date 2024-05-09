1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 // File: interfaces/IOlympusAuthority.sol
4 
5 
6 pragma solidity =0.7.5;
7 
8 interface IOlympusAuthority {
9     /* ========== EVENTS ========== */
10     
11     event GovernorPushed(address indexed from, address indexed to, bool _effectiveImmediately);
12     event GuardianPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
13     event PolicyPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
14     event VaultPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
15 
16     event GovernorPulled(address indexed from, address indexed to);
17     event GuardianPulled(address indexed from, address indexed to);
18     event PolicyPulled(address indexed from, address indexed to);
19     event VaultPulled(address indexed from, address indexed to);
20 
21     /* ========== VIEW ========== */
22     
23     function governor() external view returns (address);
24     function guardian() external view returns (address);
25     function policy() external view returns (address);
26     function vault() external view returns (address);
27 }
28 // File: types/OlympusAccessControlled.sol
29 
30 
31 pragma solidity >=0.7.5;
32 
33 
34 abstract contract OlympusAccessControlled {
35 
36     /* ========== EVENTS ========== */
37 
38     event AuthorityUpdated(IOlympusAuthority indexed authority);
39 
40     string UNAUTHORIZED = "UNAUTHORIZED"; // save gas
41 
42     /* ========== STATE VARIABLES ========== */
43 
44     IOlympusAuthority public authority;
45 
46 
47     /* ========== Constructor ========== */
48 
49     constructor(IOlympusAuthority _authority) {
50         authority = _authority;
51         emit AuthorityUpdated(_authority);
52     }
53     
54 
55     /* ========== MODIFIERS ========== */
56     
57     modifier onlyGovernor() {
58         require(msg.sender == authority.governor(), UNAUTHORIZED);
59         _;
60     }
61     
62     modifier onlyGuardian() {
63         require(msg.sender == authority.guardian(), UNAUTHORIZED);
64         _;
65     }
66     
67     modifier onlyPolicy() {
68         require(msg.sender == authority.policy(), UNAUTHORIZED);
69         _;
70     }
71 
72     modifier onlyVault() {
73         require(msg.sender == authority.vault(), UNAUTHORIZED);
74         _;
75     }
76     
77     /* ========== GOV ONLY ========== */
78     
79     function setAuthority(IOlympusAuthority _newAuthority) external onlyGovernor {
80         authority = _newAuthority;
81         emit AuthorityUpdated(_newAuthority);
82     }
83 }
84 
85 // File: interfaces/IDistributor.sol
86 
87 
88 pragma solidity >=0.7.5;
89 
90 interface IDistributor {
91     function distribute() external;
92 
93     function bounty() external view returns (uint256);
94 
95     function retrieveBounty() external returns (uint256);
96 
97     function nextRewardAt(uint256 _rate) external view returns (uint256);
98 
99     function nextRewardFor(address _recipient) external view returns (uint256);
100 
101     function setBounty(uint256 _bounty) external;
102 
103     function addRecipient(address _recipient, uint256 _rewardRate) external;
104 
105     function removeRecipient(uint256 _index) external;
106 
107     function setAdjustment(
108         uint256 _index,
109         bool _add,
110         uint256 _rate,
111         uint256 _target
112     ) external;
113 }
114 
115 // File: interfaces/IERC20.sol
116 
117 
118 pragma solidity >=0.7.5;
119 
120 interface IERC20 {
121   /**
122    * @dev Returns the amount of tokens in existence.
123    */
124   function totalSupply() external view returns (uint256);
125 
126   /**
127    * @dev Returns the amount of tokens owned by `account`.
128    */
129   function balanceOf(address account) external view returns (uint256);
130 
131   /**
132    * @dev Moves `amount` tokens from the caller's account to `recipient`.
133    *
134    * Returns a boolean value indicating whether the operation succeeded.
135    *
136    * Emits a {Transfer} event.
137    */
138   function transfer(address recipient, uint256 amount) external returns (bool);
139 
140   /**
141    * @dev Returns the remaining number of tokens that `spender` will be
142    * allowed to spend on behalf of `owner` through {transferFrom}. This is
143    * zero by default.
144    *
145    * This value changes when {approve} or {transferFrom} are called.
146    */
147   function allowance(address owner, address spender) external view returns (uint256);
148 
149   /**
150    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151    *
152    * Returns a boolean value indicating whether the operation succeeded.
153    *
154    * IMPORTANT: Beware that changing an allowance with this method brings the risk
155    * that someone may use both the old and the new allowance by unfortunate
156    * transaction ordering. One possible solution to mitigate this race
157    * condition is to first reduce the spender's allowance to 0 and set the
158    * desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    *
161    * Emits an {Approval} event.
162    */
163   function approve(address spender, uint256 amount) external returns (bool);
164 
165   /**
166    * @dev Moves `amount` tokens from `sender` to `recipient` using the
167    * allowance mechanism. `amount` is then deducted from the caller's
168    * allowance.
169    *
170    * Returns a boolean value indicating whether the operation succeeded.
171    *
172    * Emits a {Transfer} event.
173    */
174   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
175 
176   /**
177    * @dev Emitted when `value` tokens are moved from one account (`from`) to
178    * another (`to`).
179    *
180    * Note that `value` may be zero.
181    */
182   event Transfer(address indexed from, address indexed to, uint256 value);
183 
184   /**
185    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186    * a call to {approve}. `value` is the new allowance.
187    */
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: interfaces/IgOHM.sol
192 
193 
194 pragma solidity >=0.7.5;
195 
196 
197 interface IgOHM is IERC20 {
198   function mint(address _to, uint256 _amount) external;
199 
200   function burn(address _from, uint256 _amount) external;
201 
202   function index() external view returns (uint256);
203 
204   function balanceFrom(uint256 _amount) external view returns (uint256);
205 
206   function balanceTo(uint256 _amount) external view returns (uint256);
207 
208   function migrate( address _staking, address _sOHM ) external;
209 }
210 
211 // File: interfaces/IsOHM.sol
212 
213 
214 pragma solidity >=0.7.5;
215 
216 
217 interface IsOHM is IERC20 {
218     function rebase( uint256 ohmProfit_, uint epoch_) external returns (uint256);
219 
220     function circulatingSupply() external view returns (uint256);
221 
222     function gonsForBalance( uint amount ) external view returns ( uint );
223 
224     function balanceForGons( uint gons ) external view returns ( uint );
225 
226     function index() external view returns ( uint );
227 
228     function toG(uint amount) external view returns (uint);
229 
230     function fromG(uint amount) external view returns (uint);
231 
232      function changeDebt(
233         uint256 amount,
234         address debtor,
235         bool add
236     ) external;
237 
238     function debtBalances(address _address) external view returns (uint256);
239 
240 }
241 
242 // File: libraries/SafeERC20.sol
243 
244 
245 pragma solidity >=0.7.5;
246 
247 
248 /// @notice Safe IERC20 and ETH transfer library that safely handles missing return values.
249 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/TransferHelper.sol)
250 /// Taken from Solmate
251 library SafeERC20 {
252     function safeTransferFrom(
253         IERC20 token,
254         address from,
255         address to,
256         uint256 amount
257     ) internal {
258         (bool success, bytes memory data) = address(token).call(
259             abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, amount)
260         );
261 
262         require(success && (data.length == 0 || abi.decode(data, (bool))), "TRANSFER_FROM_FAILED");
263     }
264 
265     function safeTransfer(
266         IERC20 token,
267         address to,
268         uint256 amount
269     ) internal {
270         (bool success, bytes memory data) = address(token).call(
271             abi.encodeWithSelector(IERC20.transfer.selector, to, amount)
272         );
273 
274         require(success && (data.length == 0 || abi.decode(data, (bool))), "TRANSFER_FAILED");
275     }
276 
277     function safeApprove(
278         IERC20 token,
279         address to,
280         uint256 amount
281     ) internal {
282         (bool success, bytes memory data) = address(token).call(
283             abi.encodeWithSelector(IERC20.approve.selector, to, amount)
284         );
285 
286         require(success && (data.length == 0 || abi.decode(data, (bool))), "APPROVE_FAILED");
287     }
288 
289     function safeTransferETH(address to, uint256 amount) internal {
290         (bool success, ) = to.call{value: amount}(new bytes(0));
291 
292         require(success, "ETH_TRANSFER_FAILED");
293     }
294 }
295 // File: libraries/SafeMath.sol
296 
297 
298 pragma solidity ^0.7.5;
299 
300 
301 // TODO(zx): Replace all instances of SafeMath with OZ implementation
302 library SafeMath {
303 
304     function add(uint256 a, uint256 b) internal pure returns (uint256) {
305         uint256 c = a + b;
306         require(c >= a, "SafeMath: addition overflow");
307 
308         return c;
309     }
310 
311     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312         return sub(a, b, "SafeMath: subtraction overflow");
313     }
314 
315     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b <= a, errorMessage);
317         uint256 c = a - b;
318 
319         return c;
320     }
321 
322     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
323         if (a == 0) {
324             return 0;
325         }
326 
327         uint256 c = a * b;
328         require(c / a == b, "SafeMath: multiplication overflow");
329 
330         return c;
331     }
332 
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         return div(a, b, "SafeMath: division by zero");
335     }
336 
337     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b > 0, errorMessage);
339         uint256 c = a / b;
340         assert(a == b * c + a % b); // There is no case in which this doesn't hold
341 
342         return c;
343     }
344 
345     // Only used in the  BondingCalculator.sol
346     function sqrrt(uint256 a) internal pure returns (uint c) {
347         if (a > 3) {
348             c = a;
349             uint b = add( div( a, 2), 1 );
350             while (b < c) {
351                 c = b;
352                 b = div( add( div( a, b ), b), 2 );
353             }
354         } else if (a != 0) {
355             c = 1;
356         }
357     }
358 
359 }
360 // File: Staking.sol
361 
362 
363 pragma solidity ^0.7.5;
364 
365 
366 
367 
368 
369 
370 
371 
372 contract OlympusStaking is OlympusAccessControlled {
373     /* ========== DEPENDENCIES ========== */
374 
375     using SafeMath for uint256;
376     using SafeERC20 for IERC20;
377     using SafeERC20 for IsOHM;
378     using SafeERC20 for IgOHM;
379 
380     /* ========== EVENTS ========== */
381 
382     event DistributorSet(address distributor);
383     event WarmupSet(uint256 warmup);
384 
385     /* ========== DATA STRUCTURES ========== */
386 
387     struct Epoch {
388         uint256 length; // in seconds
389         uint256 number; // since inception
390         uint256 end; // timestamp
391         uint256 distribute; // amount
392     }
393 
394     struct Claim {
395         uint256 deposit; // if forfeiting
396         uint256 gons; // staked balance
397         uint256 expiry; // end of warmup period
398         bool lock; // prevents malicious delays for claim
399     }
400 
401     /* ========== STATE VARIABLES ========== */
402 
403     IERC20 public immutable OHM;
404     IsOHM public immutable sOHM;
405     IgOHM public immutable gOHM;
406 
407     Epoch public epoch;
408 
409     IDistributor public distributor;
410 
411     mapping(address => Claim) public warmupInfo;
412     uint256 public warmupPeriod;
413     uint256 private gonsInWarmup;
414 
415     /* ========== CONSTRUCTOR ========== */
416 
417     constructor(
418         address _ohm,
419         address _sOHM,
420         address _gOHM,
421         uint256 _epochLength,
422         uint256 _firstEpochNumber,
423         uint256 _firstEpochTime,
424         address _authority
425     ) OlympusAccessControlled(IOlympusAuthority(_authority)) {
426         require(_ohm != address(0), "Zero address: OHM");
427         OHM = IERC20(_ohm);
428         require(_sOHM != address(0), "Zero address: sOHM");
429         sOHM = IsOHM(_sOHM);
430         require(_gOHM != address(0), "Zero address: gOHM");
431         gOHM = IgOHM(_gOHM);
432 
433         epoch = Epoch({length: _epochLength, number: _firstEpochNumber, end: _firstEpochTime, distribute: 0});
434     }
435 
436     /* ========== MUTATIVE FUNCTIONS ========== */
437 
438     /**
439      * @notice stake OHM to enter warmup
440      * @param _to address
441      * @param _amount uint
442      * @param _claim bool
443      * @param _rebasing bool
444      * @return uint
445      */
446     function stake(
447         address _to,
448         uint256 _amount,
449         bool _rebasing,
450         bool _claim
451     ) external returns (uint256) {
452         OHM.safeTransferFrom(msg.sender, address(this), _amount);
453         _amount = _amount.add(rebase()); // add bounty if rebase occurred
454         if (_claim && warmupPeriod == 0) {
455             return _send(_to, _amount, _rebasing);
456         } else {
457             Claim memory info = warmupInfo[_to];
458             if (!info.lock) {
459                 require(_to == msg.sender, "External deposits for account are locked");
460             }
461 
462             warmupInfo[_to] = Claim({
463                 deposit: info.deposit.add(_amount),
464                 gons: info.gons.add(sOHM.gonsForBalance(_amount)),
465                 expiry: epoch.number.add(warmupPeriod),
466                 lock: info.lock
467             });
468 
469             gonsInWarmup = gonsInWarmup.add(sOHM.gonsForBalance(_amount));
470 
471             return _amount;
472         }
473     }
474 
475     /**
476      * @notice retrieve stake from warmup
477      * @param _to address
478      * @param _rebasing bool
479      * @return uint
480      */
481     function claim(address _to, bool _rebasing) public returns (uint256) {
482         Claim memory info = warmupInfo[_to];
483 
484         if (!info.lock) {
485             require(_to == msg.sender, "External claims for account are locked");
486         }
487 
488         if (epoch.number >= info.expiry && info.expiry != 0) {
489             delete warmupInfo[_to];
490 
491             gonsInWarmup = gonsInWarmup.sub(info.gons);
492 
493             return _send(_to, sOHM.balanceForGons(info.gons), _rebasing);
494         }
495         return 0;
496     }
497 
498     /**
499      * @notice forfeit stake and retrieve OHM
500      * @return uint
501      */
502     function forfeit() external returns (uint256) {
503         Claim memory info = warmupInfo[msg.sender];
504         delete warmupInfo[msg.sender];
505 
506         gonsInWarmup = gonsInWarmup.sub(info.gons);
507 
508         OHM.safeTransfer(msg.sender, info.deposit);
509 
510         return info.deposit;
511     }
512 
513     /**
514      * @notice prevent new deposits or claims from ext. address (protection from malicious activity)
515      */
516     function toggleLock() external {
517         warmupInfo[msg.sender].lock = !warmupInfo[msg.sender].lock;
518     }
519 
520     /**
521      * @notice redeem sOHM for OHMs
522      * @param _to address
523      * @param _amount uint
524      * @param _trigger bool
525      * @param _rebasing bool
526      * @return amount_ uint
527      */
528     function unstake(
529         address _to,
530         uint256 _amount,
531         bool _trigger,
532         bool _rebasing
533     ) external returns (uint256 amount_) {
534         amount_ = _amount;
535         uint256 bounty;
536         if (_trigger) {
537             bounty = rebase();
538         }
539         if (_rebasing) {
540             sOHM.safeTransferFrom(msg.sender, address(this), _amount);
541             amount_ = amount_.add(bounty);
542         } else {
543             gOHM.burn(msg.sender, _amount); // amount was given in gOHM terms
544             amount_ = gOHM.balanceFrom(amount_).add(bounty); // convert amount to OHM terms & add bounty
545         }
546 
547         require(amount_ <= OHM.balanceOf(address(this)), "Insufficient OHM balance in contract");
548         OHM.safeTransfer(_to, amount_);
549     }
550 
551     /**
552      * @notice convert _amount sOHM into gBalance_ gOHM
553      * @param _to address
554      * @param _amount uint
555      * @return gBalance_ uint
556      */
557     function wrap(address _to, uint256 _amount) external returns (uint256 gBalance_) {
558         sOHM.safeTransferFrom(msg.sender, address(this), _amount);
559         gBalance_ = gOHM.balanceTo(_amount);
560         gOHM.mint(_to, gBalance_);
561     }
562 
563     /**
564      * @notice convert _amount gOHM into sBalance_ sOHM
565      * @param _to address
566      * @param _amount uint
567      * @return sBalance_ uint
568      */
569     function unwrap(address _to, uint256 _amount) external returns (uint256 sBalance_) {
570         gOHM.burn(msg.sender, _amount);
571         sBalance_ = gOHM.balanceFrom(_amount);
572         sOHM.safeTransfer(_to, sBalance_);
573     }
574 
575     /**
576      * @notice trigger rebase if epoch over
577      * @return uint256
578      */
579     function rebase() public returns (uint256) {
580         uint256 bounty;
581         if (epoch.end <= block.timestamp) {
582             sOHM.rebase(epoch.distribute, epoch.number);
583 
584             epoch.end = epoch.end.add(epoch.length);
585             epoch.number++;
586 
587             if (address(distributor) != address(0)) {
588                 distributor.distribute();
589                 bounty = distributor.retrieveBounty(); // Will mint ohm for this contract if there exists a bounty
590             }
591             uint256 balance = OHM.balanceOf(address(this));
592             uint256 staked = sOHM.circulatingSupply();
593             if (balance <= staked.add(bounty)) {
594                 epoch.distribute = 0;
595             } else {
596                 epoch.distribute = balance.sub(staked).sub(bounty);
597             }
598         }
599         return bounty;
600     }
601 
602     /* ========== INTERNAL FUNCTIONS ========== */
603 
604     /**
605      * @notice send staker their amount as sOHM or gOHM
606      * @param _to address
607      * @param _amount uint
608      * @param _rebasing bool
609      */
610     function _send(
611         address _to,
612         uint256 _amount,
613         bool _rebasing
614     ) internal returns (uint256) {
615         if (_rebasing) {
616             sOHM.safeTransfer(_to, _amount); // send as sOHM (equal unit as OHM)
617             return _amount;
618         } else {
619             gOHM.mint(_to, gOHM.balanceTo(_amount)); // send as gOHM (convert units from OHM)
620             return gOHM.balanceTo(_amount);
621         }
622     }
623 
624     /* ========== VIEW FUNCTIONS ========== */
625 
626     /**
627      * @notice returns the sOHM index, which tracks rebase growth
628      * @return uint
629      */
630     function index() public view returns (uint256) {
631         return sOHM.index();
632     }
633 
634     /**
635      * @notice total supply in warmup
636      */
637     function supplyInWarmup() public view returns (uint256) {
638         return sOHM.balanceForGons(gonsInWarmup);
639     }
640 
641     /**
642      * @notice seconds until the next epoch begins
643      */
644     function secondsToNextEpoch() external view returns (uint256) {
645         return epoch.end.sub(block.timestamp);
646     }
647 
648     /* ========== MANAGERIAL FUNCTIONS ========== */
649 
650     /**
651      * @notice sets the contract address for LP staking
652      * @param _distributor address
653      */
654     function setDistributor(address _distributor) external onlyGovernor {
655         distributor = IDistributor(_distributor);
656         emit DistributorSet(_distributor);
657     }
658 
659     /**
660      * @notice set warmup period for new stakers
661      * @param _warmupPeriod uint
662      */
663     function setWarmupLength(uint256 _warmupPeriod) external onlyGovernor {
664         warmupPeriod = _warmupPeriod;
665         emit WarmupSet(_warmupPeriod);
666     }
667 }