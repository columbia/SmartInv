1 pragma solidity 0.5.10;
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
21  * the optional functions; to access them see {ERC20Detailed}.
22  */
23 interface TRC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      * - Subtraction cannot overflow.
145      *
146      * _Available since v2.4.0._
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      *
204      * _Available since v2.4.0._
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         // Solidity only automatically asserts when dividing by 0
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      *
241      * _Available since v2.4.0._
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 /**
250  * @dev Implementation of the {TRC20} interface.
251  *
252  * This implementation is agnostic to the way tokens are created. This means
253  * that a supply mechanism has to be added in a derived contract using {_mint}.
254  * For a generic mechanism see {ERC20Mintable}.
255  *
256  * TIP: For a detailed writeup see our guide
257  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
258  * to implement supply mechanisms].
259  *
260  * We have followed general OpenZeppelin guidelines: functions revert instead
261  * of returning `false` on failure. This behavior is nonetheless conventional
262  * and does not conflict with the expectations of ERC20 applications.
263  *
264  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
265  * This allows applications to reconstruct the allowance for all accounts just
266  * by listening to said events. Other implementations of the EIP may not emit
267  * these events, as it isn't required by the specification.
268  *
269  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
270  * functions have been added to mitigate the well-known issues around setting
271  * allowances. See {TRC20-approve}.
272  */
273 contract ERC20 is Context, TRC20 {
274     using SafeMath for uint256;
275 
276     mapping (address => uint256) private _balances;
277 
278     mapping (address => mapping (address => uint256)) private _allowances;
279 
280     // allocating 20,000,000 tokens for liquidity, promotions, airdrops
281     uint256 private _totalSupply = 20000000 * (10 ** 8);
282 
283     constructor() public {
284         _balances[msg.sender] = _totalSupply;
285     }
286 
287     /**
288      * @dev See {TRC20-totalSupply}.
289      */
290     function totalSupply() public view returns (uint256) {
291         return _totalSupply;
292     }
293 
294     /**
295      * @dev See {TRC20-balanceOf}.
296      */
297     function balanceOf(address account) public view returns (uint256) {
298         return _balances[account];
299     }
300 
301     /**
302      * @dev See {TRC20-transfer}.
303      *
304      * Requirements:
305      *
306      * - `recipient` cannot be the zero address.
307      * - the caller must have a balance of at least `amount`.
308      */
309     function transfer(address recipient, uint256 amount) public returns (bool) {
310         _transfer(_msgSender(), recipient, amount);
311         return true;
312     }
313 
314     /**
315      * @dev See {TRC20-allowance}.
316      */
317     function allowance(address owner, address spender) public view returns (uint256) {
318         return _allowances[owner][spender];
319     }
320 
321     /**
322      * @dev See {TRC20-approve}.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function approve(address spender, uint256 amount) public returns (bool) {
329         _approve(_msgSender(), spender, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {TRC20-transferFrom}.
335      *
336      * Emits an {Approval} event indicating the updated allowance. This is not
337      * required by the EIP. See the note at the beginning of {ERC20};
338      *
339      * Requirements:
340      * - `sender` and `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      * - the caller must have allowance for `sender`'s tokens of at least
343      * `amount`.
344      */
345     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
346         _transfer(sender, recipient, amount);
347         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
348         return true;
349     }
350 
351     /**
352      * @dev Atomically increases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {TRC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {TRC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
383         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
384         return true;
385     }
386 
387     /**
388      * @dev Moves tokens `amount` from `sender` to `recipient`.
389      *
390      * This is internal function is equivalent to {transfer}, and can be used to
391      * e.g. implement automatic token fees, slashing mechanisms, etc.
392      *
393      * Emits a {Transfer} event.
394      *
395      * Requirements:
396      *
397      * - `sender` cannot be the zero address.
398      * - `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      */
401     function _transfer(address sender, address recipient, uint256 amount) internal {
402         require(sender != address(0), "ERC20: transfer from the zero address");
403         require(recipient != address(0), "ERC20: transfer to the zero address");
404 
405         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
406         _balances[recipient] = _balances[recipient].add(amount);
407         emit Transfer(sender, recipient, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements
416      *
417      * - `to` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _totalSupply = _totalSupply.add(amount);
423         _balances[account] = _balances[account].add(amount);
424         emit Transfer(address(0), account, amount);
425     }
426 
427      /**
428      * @dev External function to destroys `amount` tokens from `account`, reducing the
429      * total supply.
430      */
431     function burn(uint256 amount) external {
432         require(_balances[msg.sender] >= amount, "ERC20: not enough balance!");
433 
434         _burn(msg.sender, amount);
435     }
436 
437      /**
438      * @dev Destroys `amount` tokens from `account`, reducing the
439      * total supply.
440      *
441      * Emits a {Transfer} event with `to` set to the zero address.
442      *
443      * Requirements
444      *
445      * - `account` cannot be the zero address.
446      * - `account` must have at least `amount` tokens.
447      */
448     function _burn(address account, uint256 amount) internal {
449         require(account != address(0), "ERC20: burn from the zero address");
450 
451         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
452         _totalSupply = _totalSupply.sub(amount);
453         emit Transfer(account, address(0), amount);
454     }
455 
456     /**
457      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
458      *
459      * This is internal function is equivalent to `approve`, and can be used to
460      * e.g. set automatic allowances for certain subsystems, etc.
461      *
462      * Emits an {Approval} event.
463      *
464      * Requirements:
465      *
466      * - `owner` cannot be the zero address.
467      * - `spender` cannot be the zero address.
468      */
469     function _approve(address owner, address spender, uint256 amount) internal {
470         require(owner != address(0), "ERC20: approve from the zero address");
471         require(spender != address(0), "ERC20: approve to the zero address");
472 
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     /**
478      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
479      * from the caller's allowance.
480      *
481      * See {_burn} and {_approve}.
482      */
483     function _burnFrom(address account, uint256 amount) internal {
484         _burn(account, amount);
485         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
486     }
487 }
488 
489 contract GlobalsAndUtility is ERC20 {
490     /*  XfLobbyEnter
491     */
492     event XfLobbyEnter(
493         uint256 timestamp,
494         uint256 enterDay,
495         uint256 indexed entryIndex,
496         uint256 indexed rawAmount
497     );
498 
499     /*  XfLobbyExit 
500     */
501     event XfLobbyExit(
502         uint256 timestamp,
503         uint256 enterDay,
504         uint256 indexed entryIndex,
505         uint256 indexed xfAmount,
506         address indexed referrerAddr
507     );
508 
509     /*  DailyDataUpdate
510     */
511     event DailyDataUpdate(
512         address indexed updaterAddr,
513         uint256 timestamp,
514         uint256 beginDay,
515         uint256 endDay
516     );
517 
518     /*  StakeStart
519     */
520     event StakeStart(
521         uint40 indexed stakeId,
522         address indexed stakerAddr,
523         uint256 stakedGuns,
524         uint256 stakeShares,
525         uint256 stakedDays
526     );
527     
528     /*  StakeGoodAccounting
529     */
530     event StakeGoodAccounting(
531         uint40 indexed stakeId,
532         address indexed stakerAddr,
533         address indexed senderAddr,
534         uint256 stakedGuns,
535         uint256 stakeShares,
536         uint256 payout,
537         uint256 penalty
538     );
539 
540     /*  StakeEnd 
541     */
542     event StakeEnd(
543         uint40 indexed stakeId,
544         uint40 prevUnlocked,
545         address indexed stakerAddr,
546         uint256 lockedDay,
547         uint256 servedDays,
548         uint256 stakedGuns,
549         uint256 stakeShares,
550         uint256 dividends,
551         uint256 payout,
552         uint256 penalty,
553         uint256 stakeReturn
554     );
555 
556     /*  ShareRateChange 
557     */
558     event ShareRateChange(
559         uint40 indexed stakeId,
560         uint256 timestamp,
561         uint256 newShareRate
562     );
563 
564     /* 	NUI allocation share address
565 	*	Used for 15% drip into NUI auction
566 	*	85% of the first public auction will be redistributed over the next 3 days (auction days 2, 3, 4) into the NUG auction.
567 	*/
568     address payable internal constant NUI_SHARE_ADDR = 0xc8001EA490F97b1DD673f77074edf18338853CA0;
569 
570     uint8 internal LAST_FLUSHED_DAY = 1;
571 
572     /* ERC20 constants */
573     string public constant name = "NUG";
574     string public constant symbol = "NUG";
575     uint8 public constant decimals = 8;
576 
577     /* Guns per Satoshi = 10,000 * 1e8 / 1e8 = 1e4 */
578     uint256 private constant GUNS_PER_NUG = 10 ** uint256(decimals); // 1e8
579 
580     /* Time of contract launch (Dec 3rd, 00:00:00 UTC, Auction Day 1 Starts Dec 4th, 00:00:00 UTC) */
581     uint256 internal constant LAUNCH_TIME = 1607040000;
582 
583     /* Start of claim phase */
584     uint256 internal constant PRE_CLAIM_DAYS = 1;
585     uint256 internal constant CLAIM_STARTING_AMOUNT = 1000000 * (10 ** 8);
586     uint256 internal constant CLAIM_LOWEST_AMOUNT = 500000 * (10 ** 8);
587     uint256 internal constant CLAIM_PHASE_START_DAY = PRE_CLAIM_DAYS;
588 
589     /* Number of words to hold 1 bit for each transform lobby day */
590     uint256 internal constant XF_LOBBY_DAY_WORDS = ((1 + (50 * 7)) + 255) >> 8;
591 
592     /* Stake timing parameters */
593     uint256 internal constant MIN_STAKE_DAYS = 1;
594 
595     uint256 internal constant MAX_STAKE_DAYS = 25;
596 
597     uint256 internal constant EARLY_PENALTY_MIN_DAYS = 90;
598 
599     uint256 private constant LATE_PENALTY_GRACE_WEEKS = 2;
600     uint256 internal constant LATE_PENALTY_GRACE_DAYS = LATE_PENALTY_GRACE_WEEKS * 7;
601 
602     uint256 private constant LATE_PENALTY_SCALE_WEEKS = 100;
603     uint256 internal constant LATE_PENALTY_SCALE_DAYS = LATE_PENALTY_SCALE_WEEKS * 7;
604 
605     /* Stake shares Longer Pays Better bonus constants used by _stakeStartBonusGuns() */
606     uint256 private constant LPB_BONUS_PERCENT = 20;
607     uint256 private constant LPB_BONUS_MAX_PERCENT = 200;
608     uint256 internal constant LPB = 364 * 100 / LPB_BONUS_PERCENT;
609     uint256 internal constant LPB_MAX_DAYS = LPB * LPB_BONUS_MAX_PERCENT / 100;
610 
611     /* Stake shares Bigger Pays Better bonus constants used by _stakeStartBonusGuns() */
612     uint256 private constant BPB_BONUS_PERCENT = 10;
613     uint256 private constant BPB_MAX_NUG = 7 * 1e6;
614     uint256 internal constant BPB_MAX_GUNS = BPB_MAX_NUG * GUNS_PER_NUG;
615     uint256 internal constant BPB = BPB_MAX_GUNS * 100 / BPB_BONUS_PERCENT;
616 
617     /* Share rate is scaled to increase precision */
618     uint256 internal constant SHARE_RATE_SCALE = 1e5;
619 
620     /* Share rate max (after scaling) */
621     uint256 internal constant SHARE_RATE_UINT_SIZE = 40;
622     uint256 internal constant SHARE_RATE_MAX = (1 << SHARE_RATE_UINT_SIZE) - 1;
623 
624     /* weekly staking bonus */
625     uint8 internal constant BONUS_DAY_SCALE = 2;
626 
627     /* Globals expanded for memory (except _latestStakeId) and compact for storage */
628     struct GlobalsCache {
629         uint256 _lockedGunsTotal;
630         uint256 _nextStakeSharesTotal;
631         uint256 _shareRate;
632         uint256 _stakePenaltyTotal;
633         uint256 _dailyDataCount;
634         uint256 _stakeSharesTotal;
635         uint40 _latestStakeId;
636         uint256 _currentDay;
637     }
638 
639     struct GlobalsStore {
640         uint72 lockedGunsTotal;
641         uint72 nextStakeSharesTotal;
642         uint40 shareRate;
643         uint72 stakePenaltyTotal;
644         uint16 dailyDataCount;
645         uint72 stakeSharesTotal;
646         uint40 latestStakeId;
647     }
648 
649     GlobalsStore public globals;
650 
651     /* Daily data */
652     struct DailyDataStore {
653         uint72 dayPayoutTotal;
654         uint256 dayDividends;
655         uint72 dayStakeSharesTotal;
656     }
657 
658     mapping(uint256 => DailyDataStore) public dailyData;
659 
660     /* Stake expanded for memory (except _stakeId) and compact for storage */
661     struct StakeCache {
662         uint40 _stakeId;
663         uint256 _stakedGuns;
664         uint256 _stakeShares;
665         uint256 _lockedDay;
666         uint256 _stakedDays;
667         uint256 _unlockedDay;
668     }
669 
670     struct StakeStore {
671         uint40 stakeId;
672         uint72 stakedGuns;
673         uint72 stakeShares;
674         uint16 lockedDay;
675         uint16 stakedDays;
676         uint16 unlockedDay;
677     }
678 
679     mapping(address => StakeStore[]) public stakeLists;
680 
681     /* Temporary state for calculating daily rounds */
682     struct DailyRoundState {
683         uint256 _allocSupplyCached;
684         uint256 _payoutTotal;
685     }
686 
687     struct XfLobbyEntryStore {
688         uint96 rawAmount;
689         address referrerAddr;
690     }
691 
692     struct XfLobbyQueueStore {
693         uint40 headIndex;
694         uint40 tailIndex;
695         mapping(uint256 => XfLobbyEntryStore) entries;
696     }
697 
698     mapping(uint256 => uint256) public xfLobby;
699     mapping(uint256 => mapping(address => XfLobbyQueueStore)) public xfLobbyMembers;
700 
701     /**
702      * @dev PUBLIC FACING: Optionally update daily data for a smaller
703      * range to reduce gas cost for a subsequent operation
704      * @param beforeDay Only update days before this day number (optional; 0 for current day)
705      */
706     function dailyDataUpdate(uint256 beforeDay)
707         external
708     {
709         GlobalsCache memory g;
710         GlobalsCache memory gSnapshot;
711         _globalsLoad(g, gSnapshot);
712 
713         /* Skip pre-claim period */
714         require(g._currentDay > CLAIM_PHASE_START_DAY, "NUG: Too early");
715 
716         if (beforeDay != 0) {
717             require(beforeDay <= g._currentDay, "NUG: beforeDay cannot be in the future");
718 
719             _dailyDataUpdate(g, beforeDay, false);
720         } else {
721             /* Default to updating before current day */
722             _dailyDataUpdate(g, g._currentDay, false);
723         }
724 
725         _globalsSync(g, gSnapshot);
726     }
727 
728     /**
729      * @dev PUBLIC FACING: External helper to return multiple values of daily data with
730      * a single call.
731      * @param beginDay First day of data range
732      * @param endDay Last day (non-inclusive) of data range
733      * @return array of day stake shares total
734      * @return array of day payout total
735      */
736     function dailyDataRange(uint256 beginDay, uint256 endDay)
737         external
738         view
739         returns (uint256[] memory _dayStakeSharesTotal, uint256[] memory _dayPayoutTotal, uint256[] memory _dayDividends)
740     {
741         require(beginDay < endDay && endDay <= globals.dailyDataCount, "NUG: range invalid");
742 
743         _dayStakeSharesTotal = new uint256[](endDay - beginDay);
744         _dayPayoutTotal = new uint256[](endDay - beginDay);
745         _dayDividends = new uint256[](endDay - beginDay);
746 
747         uint256 src = beginDay;
748         uint256 dst = 0;
749         do {
750             _dayStakeSharesTotal[dst] = uint256(dailyData[src].dayStakeSharesTotal);
751             _dayPayoutTotal[dst++] = uint256(dailyData[src].dayPayoutTotal);
752             _dayDividends[dst++] = dailyData[src].dayDividends;
753         } while (++src < endDay);
754 
755         return (_dayStakeSharesTotal, _dayPayoutTotal, _dayDividends);
756     }
757 
758 
759     /**
760      * @dev PUBLIC FACING: External helper to return most global info with a single call.
761      * Ugly implementation due to limitations of the standard ABI encoder.
762      * @return Fixed array of values
763      */
764     function globalInfo()
765         external
766         view
767         returns (uint256[10] memory)
768     {
769 
770         return [
771             globals.lockedGunsTotal,
772             globals.nextStakeSharesTotal,
773             globals.shareRate,
774             globals.stakePenaltyTotal,
775             globals.dailyDataCount,
776             globals.stakeSharesTotal,
777             globals.latestStakeId,
778             block.timestamp,
779             totalSupply(),
780             xfLobby[_currentDay()]
781         ];
782     }
783 
784     /**
785      * @dev PUBLIC FACING: ERC20 totalSupply() is the circulating supply and does not include any
786      * staked Guns. allocatedSupply() includes both.
787      * @return Allocated Supply in Guns
788      */
789     function allocatedSupply()
790         external
791         view
792         returns (uint256)
793     {
794         return totalSupply() + globals.lockedGunsTotal;
795     }
796 
797     /**
798      * @dev PUBLIC FACING: External helper for the current day number since launch time
799      * @return Current day number (zero-based)
800      */
801     function currentDay()
802         external
803         view
804         returns (uint256)
805     {
806         return _currentDay();
807     }
808 
809     function _currentDay()
810         internal
811         view
812         returns (uint256)
813     {
814         if (block.timestamp < LAUNCH_TIME){
815              return 0;
816         }else{
817              return (block.timestamp - LAUNCH_TIME) / 1 days;
818         }
819     }
820 
821     function _dailyDataUpdateAuto(GlobalsCache memory g)
822         internal
823     {
824         _dailyDataUpdate(g, g._currentDay, true);
825     }
826 
827     function _globalsLoad(GlobalsCache memory g, GlobalsCache memory gSnapshot)
828         internal
829         view
830     {
831         g._lockedGunsTotal = globals.lockedGunsTotal;
832         g._nextStakeSharesTotal = globals.nextStakeSharesTotal;
833         g._shareRate = globals.shareRate;
834         g._stakePenaltyTotal = globals.stakePenaltyTotal;
835         g._dailyDataCount = globals.dailyDataCount;
836         g._stakeSharesTotal = globals.stakeSharesTotal;
837         g._latestStakeId = globals.latestStakeId;
838         g._currentDay = _currentDay();
839 
840         _globalsCacheSnapshot(g, gSnapshot);
841     }
842 
843     function _globalsCacheSnapshot(GlobalsCache memory g, GlobalsCache memory gSnapshot)
844         internal
845         pure
846     {
847         gSnapshot._lockedGunsTotal = g._lockedGunsTotal;
848         gSnapshot._nextStakeSharesTotal = g._nextStakeSharesTotal;
849         gSnapshot._shareRate = g._shareRate;
850         gSnapshot._stakePenaltyTotal = g._stakePenaltyTotal;
851         gSnapshot._dailyDataCount = g._dailyDataCount;
852         gSnapshot._stakeSharesTotal = g._stakeSharesTotal;
853         gSnapshot._latestStakeId = g._latestStakeId;
854     }
855 
856     function _globalsSync(GlobalsCache memory g, GlobalsCache memory gSnapshot)
857         internal
858     {
859         if (g._lockedGunsTotal != gSnapshot._lockedGunsTotal
860             || g._nextStakeSharesTotal != gSnapshot._nextStakeSharesTotal
861             || g._shareRate != gSnapshot._shareRate
862             || g._stakePenaltyTotal != gSnapshot._stakePenaltyTotal) {
863             globals.lockedGunsTotal = uint72(g._lockedGunsTotal);
864             globals.nextStakeSharesTotal = uint72(g._nextStakeSharesTotal);
865             globals.shareRate = uint40(g._shareRate);
866             globals.stakePenaltyTotal = uint72(g._stakePenaltyTotal);
867         }
868         if (g._dailyDataCount != gSnapshot._dailyDataCount
869             || g._stakeSharesTotal != gSnapshot._stakeSharesTotal
870             || g._latestStakeId != gSnapshot._latestStakeId) {
871             globals.dailyDataCount = uint16(g._dailyDataCount);
872             globals.stakeSharesTotal = uint72(g._stakeSharesTotal);
873             globals.latestStakeId = g._latestStakeId;
874         }
875     }
876 
877     function _stakeLoad(StakeStore storage stRef, uint40 stakeIdParam, StakeCache memory st)
878         internal
879         view
880     {
881         /* Ensure caller's stakeIndex is still current */
882         require(stakeIdParam == stRef.stakeId, "NUG: stakeIdParam not in stake");
883 
884         st._stakeId = stRef.stakeId;
885         st._stakedGuns = stRef.stakedGuns;
886         st._stakeShares = stRef.stakeShares;
887         st._lockedDay = stRef.lockedDay;
888         st._stakedDays = stRef.stakedDays;
889         st._unlockedDay = stRef.unlockedDay;
890     }
891 
892     function _stakeUpdate(StakeStore storage stRef, StakeCache memory st)
893         internal
894     {
895         stRef.stakeId = st._stakeId;
896         stRef.stakedGuns = uint72(st._stakedGuns);
897         stRef.stakeShares = uint72(st._stakeShares);
898         stRef.lockedDay = uint16(st._lockedDay);
899         stRef.stakedDays = uint16(st._stakedDays);
900         stRef.unlockedDay = uint16(st._unlockedDay);
901     }
902 
903     function _stakeAdd(
904         StakeStore[] storage stakeListRef,
905         uint40 newStakeId,
906         uint256 newStakedGuns,
907         uint256 newStakeShares,
908         uint256 newLockedDay,
909         uint256 newStakedDays
910     )
911         internal
912     {
913         stakeListRef.push(
914             StakeStore(
915                 newStakeId,
916                 uint72(newStakedGuns),
917                 uint72(newStakeShares),
918                 uint16(newLockedDay),
919                 uint16(newStakedDays),
920                 uint16(0) // unlockedDay
921             )
922         );
923     }
924 
925     /**
926      * @dev Efficiently delete from an unordered array by moving the last element
927      * to the "hole" and reducing the array length. Can change the order of the list
928      * and invalidate previously held indexes.
929      * @notice stakeListRef length and stakeIndex are already ensured valid in stakeEnd()
930      * @param stakeListRef Reference to stakeLists[stakerAddr] array in storage
931      * @param stakeIndex Index of the element to delete
932      */
933     function _stakeRemove(StakeStore[] storage stakeListRef, uint256 stakeIndex)
934         internal
935     {
936         uint256 lastIndex = stakeListRef.length - 1;
937 
938         /* Skip the copy if element to be removed is already the last element */
939         if (stakeIndex != lastIndex) {
940             /* Copy last element to the requested element's "hole" */
941             stakeListRef[stakeIndex] = stakeListRef[lastIndex];
942         }
943 
944         /*
945             Reduce the array length now that the array is contiguous.
946             Surprisingly, 'pop()' uses less gas than 'stakeListRef.length = lastIndex'
947         */
948         stakeListRef.pop();
949     }
950 
951     /**
952      * @dev Estimate the stake payout for an incomplete day
953      * @param g Cache of stored globals
954      * @param stakeSharesParam Param from stake to calculate bonuses for
955      * @param day Day to calculate bonuses for
956      * @return Payout in Guns
957      */
958     function _estimatePayoutRewardsDay(GlobalsCache memory g, uint256 stakeSharesParam, uint256 day)
959         internal
960         view
961         returns (uint256 payout)
962     {
963         /* Prevent updating state for this estimation */
964         GlobalsCache memory gTmp;
965         _globalsCacheSnapshot(g, gTmp);
966 
967         DailyRoundState memory rs;
968         rs._allocSupplyCached = totalSupply() + g._lockedGunsTotal;
969 
970         _dailyRoundCalc(gTmp, rs, day);
971 
972         /* Stake is no longer locked so it must be added to total as if it were */
973         gTmp._stakeSharesTotal += stakeSharesParam;
974 
975         payout = rs._payoutTotal * stakeSharesParam / gTmp._stakeSharesTotal;
976 
977         return payout;
978     }
979 
980     function _dailyRoundCalc(GlobalsCache memory g, DailyRoundState memory rs, uint256 day)
981         private
982         view
983     {
984         /*
985             Calculate payout round
986 
987             Inflation of 5.42% inflation per 364 days             (approx 1 year)
988             dailyInterestRate   = exp(log(1 + 5.42%)  / 364) - 1
989                                 = exp(log(1 + 0.0542) / 364) - 1
990                                 = exp(log(1.0542) / 364) - 1
991                                 = 0.0.00014523452066           (approx)
992 
993             payout  = allocSupply * dailyInterestRate
994                     = allocSupply / (1 / dailyInterestRate)
995                     = allocSupply / (1 / 0.00014523452066)
996                     = allocSupply / 6885.4153644438375            (approx)
997                     = allocSupply * 50000 / 68854153             (* 50000/50000 for int precision)
998         */
999         
1000         rs._payoutTotal = (rs._allocSupplyCached * 50000 / 68854153);
1001 
1002         if (g._stakePenaltyTotal != 0) {
1003             rs._payoutTotal += g._stakePenaltyTotal;
1004             g._stakePenaltyTotal = 0;
1005         }
1006     }
1007 
1008     function _dailyRoundCalcAndStore(GlobalsCache memory g, DailyRoundState memory rs, uint256 day)
1009         private
1010     {
1011         _dailyRoundCalc(g, rs, day);
1012 
1013         dailyData[day].dayPayoutTotal = uint72(rs._payoutTotal);
1014         dailyData[day].dayDividends = xfLobby[day];
1015         dailyData[day].dayStakeSharesTotal = uint72(g._stakeSharesTotal);
1016     }
1017 
1018     function _dailyDataUpdate(GlobalsCache memory g, uint256 beforeDay, bool isAutoUpdate)
1019         private
1020     {
1021         if (g._dailyDataCount >= beforeDay) {
1022             /* Already up-to-date */
1023             return;
1024         }
1025 
1026         DailyRoundState memory rs;
1027         rs._allocSupplyCached = totalSupply() + g._lockedGunsTotal;
1028 
1029         uint256 day = g._dailyDataCount;
1030 
1031         _dailyRoundCalcAndStore(g, rs, day);
1032 
1033         /* Stakes started during this day are added to the total the next day */
1034         if (g._nextStakeSharesTotal != 0) {
1035             g._stakeSharesTotal += g._nextStakeSharesTotal;
1036             g._nextStakeSharesTotal = 0;
1037         }
1038 
1039         while (++day < beforeDay) {
1040             _dailyRoundCalcAndStore(g, rs, day);
1041         }
1042 
1043         emit DailyDataUpdate(
1044             msg.sender,
1045             block.timestamp,
1046             g._dailyDataCount, 
1047             day
1048         );
1049         
1050         g._dailyDataCount = day;
1051     }
1052 }
1053 
1054 contract StakeableToken is GlobalsAndUtility {
1055     /**
1056      * @dev PUBLIC FACING: Open a stake.
1057      * @param newStakedGuns Number of Guns to stake
1058      * @param newStakedDays Number of days to stake
1059      */
1060     function stakeStart(uint256 newStakedGuns, uint256 newStakedDays)
1061         external
1062     {
1063         GlobalsCache memory g;
1064         GlobalsCache memory gSnapshot;
1065         _globalsLoad(g, gSnapshot);
1066 
1067         /* Enforce the minimum stake time */
1068         require(newStakedDays >= MIN_STAKE_DAYS, "NUG: newStakedDays lower than minimum");
1069 
1070         /* Check if log data needs to be updated */
1071         _dailyDataUpdateAuto(g);
1072 
1073         _stakeStart(g, newStakedGuns, newStakedDays);
1074 
1075         /* Remove staked Guns from balance of staker */
1076         _burn(msg.sender, newStakedGuns);
1077 
1078         _globalsSync(g, gSnapshot);
1079     }
1080 
1081     /**
1082      * @dev PUBLIC FACING: Unlocks a completed stake, distributing the proceeds of any penalty
1083      * immediately. The staker must still call stakeEnd() to retrieve their stake return (if any).
1084      * @param stakerAddr Address of staker
1085      * @param stakeIndex Index of stake within stake list
1086      * @param stakeIdParam The stake's id
1087      */
1088     function stakeGoodAccounting(address stakerAddr, uint256 stakeIndex, uint40 stakeIdParam)
1089         external
1090     {
1091         GlobalsCache memory g;
1092         GlobalsCache memory gSnapshot;
1093         _globalsLoad(g, gSnapshot);
1094 
1095         /* require() is more informative than the default assert() */
1096         require(stakeLists[stakerAddr].length != 0, "NUG: Empty stake list");
1097         require(stakeIndex < stakeLists[stakerAddr].length, "NUG: stakeIndex invalid");
1098 
1099         StakeStore storage stRef = stakeLists[stakerAddr][stakeIndex];
1100 
1101         /* Get stake copy */
1102         StakeCache memory st;
1103         _stakeLoad(stRef, stakeIdParam, st);
1104 
1105         /* Stake must have served full term */
1106         require(g._currentDay >= st._lockedDay + st._stakedDays, "NUG: Stake not fully served");
1107 
1108         /* Stake must still be locked */
1109         require(st._unlockedDay == 0, "NUG: Stake already unlocked");
1110 
1111         /* Check if log data needs to be updated */
1112         _dailyDataUpdateAuto(g);
1113 
1114         /* Unlock the completed stake */
1115         _stakeUnlock(g, st);
1116 
1117         /* stakeReturn & dividends values are unused here */
1118         (, uint256 payout, uint256 dividends, uint256 penalty, uint256 cappedPenalty) = _stakePerformance(
1119             g,
1120             st,
1121             st._stakedDays
1122         );
1123 
1124         emit StakeGoodAccounting(
1125             stakeIdParam,
1126             stakerAddr,
1127             msg.sender,
1128             st._stakedGuns,
1129             st._stakeShares,
1130             payout,
1131             penalty
1132         );
1133 
1134         if (cappedPenalty != 0) {
1135             g._stakePenaltyTotal += cappedPenalty;
1136         }
1137 
1138         /* st._unlockedDay has changed */
1139         _stakeUpdate(stRef, st);
1140 
1141         _globalsSync(g, gSnapshot);
1142     }
1143 
1144     /**
1145      * @dev PUBLIC FACING: Closes a stake. The order of the stake list can change so
1146      * a stake id is used to reject stale indexes.
1147      * @param stakeIndex Index of stake within stake list
1148      * @param stakeIdParam The stake's id
1149      */
1150     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam)
1151         external
1152     {
1153         GlobalsCache memory g;
1154         GlobalsCache memory gSnapshot;
1155         _globalsLoad(g, gSnapshot);
1156 
1157         StakeStore[] storage stakeListRef = stakeLists[msg.sender];
1158 
1159         /* require() is more informative than the default assert() */
1160         require(stakeListRef.length != 0, "NUG: Empty stake list");
1161         require(stakeIndex < stakeListRef.length, "NUG: stakeIndex invalid");
1162 
1163         /* Get stake copy */
1164         StakeCache memory st;
1165         _stakeLoad(stakeListRef[stakeIndex], stakeIdParam, st);
1166 
1167         /* Check if log data needs to be updated */
1168         _dailyDataUpdateAuto(g);
1169 
1170         uint256 servedDays = 0;
1171 
1172         bool prevUnlocked = (st._unlockedDay != 0);
1173         uint256 stakeReturn;
1174         uint256 payout = 0;
1175         uint256 dividends = 0;
1176         uint256 penalty = 0;
1177         uint256 cappedPenalty = 0;
1178 
1179         if (g._currentDay >= st._lockedDay) {
1180             if (prevUnlocked) {
1181                 /* Previously unlocked in stakeGoodAccounting(), so must have served full term */
1182                 servedDays = st._stakedDays;
1183             } else {
1184                 _stakeUnlock(g, st);
1185 
1186                 servedDays = g._currentDay - st._lockedDay;
1187                 if (servedDays > st._stakedDays) {
1188                     servedDays = st._stakedDays;
1189                 }
1190             }
1191 
1192             (stakeReturn, payout, dividends, penalty, cappedPenalty) = _stakePerformance(g, st, servedDays);
1193 
1194             msg.sender.transfer(dividends);
1195         } else {
1196             /* Stake hasn't been added to the total yet, so no penalties or rewards apply */
1197             g._nextStakeSharesTotal -= st._stakeShares;
1198 
1199             stakeReturn = st._stakedGuns;
1200         }
1201 
1202         emit StakeEnd(
1203             stakeIdParam, 
1204             prevUnlocked ? 1 : 0,
1205             msg.sender,
1206             st._lockedDay,
1207             servedDays, 
1208             st._stakedGuns, 
1209             st._stakeShares, 
1210             dividends,
1211             payout, 
1212             penalty,
1213             stakeReturn
1214         );
1215 
1216         if (cappedPenalty != 0 && !prevUnlocked) {
1217             /* Split penalty proceeds only if not previously unlocked by stakeGoodAccounting() */
1218             g._stakePenaltyTotal += cappedPenalty;
1219         }
1220 
1221         /* Pay the stake return, if any, to the staker */
1222         if (stakeReturn != 0) {
1223             _mint(msg.sender, stakeReturn);
1224             
1225             /* Update the share rate if necessary */
1226             _shareRateUpdate(g, st, stakeReturn);
1227         }
1228         g._lockedGunsTotal -= st._stakedGuns;
1229 
1230         _stakeRemove(stakeListRef, stakeIndex);
1231 
1232         _globalsSync(g, gSnapshot);
1233     }
1234 
1235     /**
1236      * @dev PUBLIC FACING: Return the current stake count for a staker address
1237      * @param stakerAddr Address of staker
1238      */
1239     function stakeCount(address stakerAddr)
1240         external
1241         view
1242         returns (uint256)
1243     {
1244         return stakeLists[stakerAddr].length;
1245     }
1246 
1247     /**
1248      * @dev Open a stake.
1249      * @param g Cache of stored globals
1250      * @param newStakedGuns Number of Guns to stake
1251      * @param newStakedDays Number of days to stake
1252      */
1253     function _stakeStart(
1254         GlobalsCache memory g,
1255         uint256 newStakedGuns,
1256         uint256 newStakedDays
1257     )
1258         internal
1259     {
1260         /* Enforce the maximum stake time */
1261         require(newStakedDays <= MAX_STAKE_DAYS, "NUG: Max allowed staking days: 180");
1262 
1263         uint256 bonusGuns = _stakeStartBonusGuns(newStakedGuns, newStakedDays);
1264         uint256 newStakeShares = (newStakedGuns + bonusGuns) * SHARE_RATE_SCALE / g._shareRate;
1265 
1266         /* Ensure newStakedGuns is enough for at least one stake share */
1267         require(newStakeShares != 0, "NUG: newStakedGuns must be at least minimum shareRate");
1268 
1269         /*
1270             The stakeStart timestamp will always be part-way through the current
1271             day, so it needs to be rounded-up to the next day to ensure all
1272             stakes align with the same fixed calendar days. The current day is
1273             already rounded-down, so rounded-up is current day + 1.
1274         */
1275         uint256 newLockedDay = g._currentDay + 1;
1276 
1277         /* Create Stake */
1278         uint40 newStakeId = ++g._latestStakeId;
1279         _stakeAdd(
1280             stakeLists[msg.sender],
1281             newStakeId,
1282             newStakedGuns,
1283             newStakeShares,
1284             newLockedDay,
1285             newStakedDays
1286         );
1287 
1288         emit StakeStart(
1289             newStakeId, 
1290             msg.sender,
1291             newStakedGuns, 
1292             newStakeShares, 
1293             newStakedDays
1294         );
1295 
1296         /* Stake is added to total in the next round, not the current round */
1297         g._nextStakeSharesTotal += newStakeShares;
1298 
1299         /* Track total staked Guns for inflation calculations */
1300         g._lockedGunsTotal += newStakedGuns;
1301     }
1302 
1303     /**
1304      * @dev Calculates total stake payout including rewards for a multi-day range
1305      * @param g Cache of stored globals
1306      * @param stakeSharesParam Param from stake to calculate bonuses for
1307      * @param beginDay First day to calculate bonuses for
1308      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1309      * @return Payout in Guns
1310      */
1311     function _calcPayoutRewards(
1312         GlobalsCache memory g,
1313         uint256 stakeSharesParam,
1314         uint256 beginDay,
1315         uint256 endDay
1316     )
1317         private
1318         view
1319         returns (uint256 payout)
1320     {
1321         uint256 counter;
1322 
1323         for (uint256 day = beginDay; day < endDay; day++) {
1324             uint256 dayPayout;
1325 
1326             dayPayout = dailyData[day].dayPayoutTotal * stakeSharesParam
1327                 / dailyData[day].dayStakeSharesTotal;
1328 
1329             if (counter < 4) {
1330                 counter++;
1331             } 
1332             /* Eligible to receive bonus */
1333             else {
1334                 dayPayout = (dailyData[day].dayPayoutTotal * stakeSharesParam
1335                 / dailyData[day].dayStakeSharesTotal) * BONUS_DAY_SCALE;
1336                 counter = 0;
1337             }
1338 
1339             payout += dayPayout;
1340         }
1341 
1342         return payout;
1343     }
1344 
1345     /**
1346      * @dev Calculates user dividends
1347      * @param g Cache of stored globals
1348      * @param stakeSharesParam Param from stake to calculate bonuses for
1349      * @param beginDay First day to calculate bonuses for
1350      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1351      * @return Payout in Guns
1352      */
1353     function _calcPayoutDividendsReward(
1354         GlobalsCache memory g,
1355         uint256 stakeSharesParam,
1356         uint256 beginDay,
1357         uint256 endDay
1358     )
1359         private
1360         view
1361         returns (uint256 payout)
1362     {
1363 
1364         for (uint256 day = beginDay; day < endDay; day++) {
1365             uint256 dayPayout;
1366 
1367             /* user's share of 85% of the day's dividends, 15% total will drip to NUI platform */
1368             dayPayout += ((dailyData[day].dayDividends * 85) / 100) * stakeSharesParam
1369             / dailyData[day].dayStakeSharesTotal;
1370 
1371             payout += dayPayout;
1372         }
1373 
1374         return payout;
1375     }
1376 
1377     /**
1378      * @dev Calculate bonus Guns for a new stake, if any
1379      * @param newStakedGuns Number of Guns to stake
1380      * @param newStakedDays Number of days to stake
1381      */
1382     function _stakeStartBonusGuns(uint256 newStakedGuns, uint256 newStakedDays)
1383         private
1384         pure
1385         returns (uint256 bonusGuns)
1386     {
1387         /*
1388             LONGER PAYS BETTER:
1389 
1390             If longer than 1 day stake is committed to, each extra day
1391             gives bonus shares of approximately 0.0548%, which is approximately 20%
1392             extra per year of increased stake length committed to, but capped to a
1393             maximum of 200% extra.
1394 
1395             extraDays       =  stakedDays - 1
1396 
1397             longerBonus%    = (extraDays / 364) * 20%
1398                             = (extraDays / 364) / 5
1399                             =  extraDays / 1820
1400                             =  extraDays / LPB
1401 
1402             extraDays       =  longerBonus% * 1820
1403             extraDaysMax    =  longerBonusMax% * 1820
1404                             =  200% * 1820
1405                             =  3640
1406                             =  LPB_MAX_DAYS
1407 
1408             BIGGER PAYS BETTER:
1409 
1410             Bonus percentage scaled 0% to 10% for the first 7M NUG of stake.
1411 
1412             biggerBonus%    = (cappedGuns /  BPB_MAX_GUNS) * 10%
1413                             = (cappedGuns /  BPB_MAX_GUNS) / 10
1414                             =  cappedGuns / (BPB_MAX_GUNS * 10)
1415                             =  cappedGuns /  BPB
1416 
1417             COMBINED:
1418 
1419             combinedBonus%  =            longerBonus%  +  biggerBonus%
1420 
1421                                       cappedExtraDays     cappedGuns
1422                             =         ---------------  +  ------------
1423                                             LPB               BPB
1424 
1425                                 cappedExtraDays * BPB     cappedGuns * LPB
1426                             =   ---------------------  +  ------------------
1427                                       LPB * BPB               LPB * BPB
1428 
1429                                 cappedExtraDays * BPB  +  cappedGuns * LPB
1430                             =   --------------------------------------------
1431                                                   LPB  *  BPB
1432 
1433             bonusGuns     = suns * combinedBonus%
1434                             = suns * (cappedExtraDays * BPB  +  cappedGuns * LPB) / (LPB * BPB)
1435         */
1436         uint256 cappedExtraDays = 0;
1437 
1438         /* Must be more than 1 day for Longer-Pays-Better */
1439         if (newStakedDays > 1) {
1440             cappedExtraDays = newStakedDays <= LPB_MAX_DAYS ? newStakedDays - 1 : LPB_MAX_DAYS;
1441         }
1442 
1443         uint256 cappedStakedGuns = newStakedGuns <= BPB_MAX_GUNS
1444             ? newStakedGuns
1445             : BPB_MAX_GUNS;
1446 
1447         bonusGuns = cappedExtraDays * BPB + cappedStakedGuns * LPB;
1448         bonusGuns = newStakedGuns * bonusGuns / (LPB * BPB);
1449 
1450         return bonusGuns;
1451     }
1452 
1453     function _stakeUnlock(GlobalsCache memory g, StakeCache memory st)
1454         private
1455         pure
1456     {
1457         g._stakeSharesTotal -= st._stakeShares;
1458         st._unlockedDay = g._currentDay;
1459     }
1460 
1461     function _stakePerformance(GlobalsCache memory g, StakeCache memory st, uint256 servedDays)
1462         private
1463         view
1464         returns (uint256 stakeReturn, uint256 payout, uint256 dividends, uint256 penalty, uint256 cappedPenalty)
1465     {
1466         if (servedDays < st._stakedDays) {
1467             (payout, penalty) = _calcPayoutAndEarlyPenalty(
1468                 g,
1469                 st._lockedDay,
1470                 st._stakedDays,
1471                 servedDays,
1472                 st._stakeShares
1473             );
1474             stakeReturn = st._stakedGuns + payout;
1475 
1476             dividends = _calcPayoutDividendsReward(
1477                 g,
1478                 st._stakeShares,
1479                 st._lockedDay,
1480                 st._lockedDay + servedDays
1481             );
1482         } else {
1483             // servedDays must == stakedDays here
1484             payout = _calcPayoutRewards(
1485                 g,
1486                 st._stakeShares,
1487                 st._lockedDay,
1488                 st._lockedDay + servedDays
1489             );
1490 
1491             dividends = _calcPayoutDividendsReward(
1492                 g,
1493                 st._stakeShares,
1494                 st._lockedDay,
1495                 st._lockedDay + servedDays
1496             );
1497 
1498             stakeReturn = st._stakedGuns + payout;
1499 
1500             penalty = _calcLatePenalty(st._lockedDay, st._stakedDays, st._unlockedDay, stakeReturn);
1501         }
1502         if (penalty != 0) {
1503             if (penalty > stakeReturn) {
1504                 /* Cannot have a negative stake return */
1505                 cappedPenalty = stakeReturn;
1506                 stakeReturn = 0;
1507             } else {
1508                 /* Remove penalty from the stake return */
1509                 cappedPenalty = penalty;
1510                 stakeReturn -= cappedPenalty;
1511             }
1512         }
1513         return (stakeReturn, payout, dividends, penalty, cappedPenalty);
1514     }
1515 
1516     function _calcPayoutAndEarlyPenalty(
1517         GlobalsCache memory g,
1518         uint256 lockedDayParam,
1519         uint256 stakedDaysParam,
1520         uint256 servedDays,
1521         uint256 stakeSharesParam
1522     )
1523         private
1524         view
1525         returns (uint256 payout, uint256 penalty)
1526     {
1527         uint256 servedEndDay = lockedDayParam + servedDays;
1528 
1529         /* 50% of stakedDays (rounded up) with a minimum applied */
1530         uint256 penaltyDays = (stakedDaysParam + 1) / 2;
1531         if (penaltyDays < EARLY_PENALTY_MIN_DAYS) {
1532             penaltyDays = EARLY_PENALTY_MIN_DAYS;
1533         }
1534 
1535         if (servedDays == 0) {
1536             /* Fill penalty days with the estimated average payout */
1537             uint256 expected = _estimatePayoutRewardsDay(g, stakeSharesParam, lockedDayParam);
1538             penalty = expected * penaltyDays;
1539             return (payout, penalty); // Actual payout was 0
1540         }
1541 
1542         if (penaltyDays < servedDays) {
1543             /*
1544                 Simplified explanation of intervals where end-day is non-inclusive:
1545 
1546                 penalty:    [lockedDay  ...  penaltyEndDay)
1547                 delta:                      [penaltyEndDay  ...  servedEndDay)
1548                 payout:     [lockedDay  .......................  servedEndDay)
1549             */
1550             uint256 penaltyEndDay = lockedDayParam + penaltyDays;
1551             penalty = _calcPayoutRewards(g, stakeSharesParam, lockedDayParam, penaltyEndDay);
1552 
1553             uint256 delta = _calcPayoutRewards(g, stakeSharesParam, penaltyEndDay, servedEndDay);
1554             payout = penalty + delta;
1555             return (payout, penalty);
1556         }
1557 
1558         /* penaltyDays >= servedDays  */
1559         payout = _calcPayoutRewards(g, stakeSharesParam, lockedDayParam, servedEndDay);
1560 
1561         if (penaltyDays == servedDays) {
1562             penalty = payout;
1563         } else {
1564             /*
1565                 (penaltyDays > servedDays) means not enough days served, so fill the
1566                 penalty days with the average payout from only the days that were served.
1567             */
1568             penalty = payout * penaltyDays / servedDays;
1569         }
1570         return (payout, penalty);
1571     }
1572 
1573     function _calcLatePenalty(
1574         uint256 lockedDayParam,
1575         uint256 stakedDaysParam,
1576         uint256 unlockedDayParam,
1577         uint256 rawStakeReturn
1578     )
1579         private
1580         pure
1581         returns (uint256)
1582     {
1583         /* Allow grace time before penalties accrue */
1584         uint256 maxUnlockedDay = lockedDayParam + stakedDaysParam + LATE_PENALTY_GRACE_DAYS;
1585         if (unlockedDayParam <= maxUnlockedDay) {
1586             return 0;
1587         }
1588 
1589         /* Calculate penalty as a percentage of stake return based on time */
1590         return rawStakeReturn * (unlockedDayParam - maxUnlockedDay) / LATE_PENALTY_SCALE_DAYS;
1591     }
1592 
1593     function _shareRateUpdate(GlobalsCache memory g, StakeCache memory st, uint256 stakeReturn)
1594         private
1595     {
1596         if (stakeReturn > st._stakedGuns) {
1597             /*
1598                 Calculate the new shareRate that would yield the same number of shares if
1599                 the user re-staked this stakeReturn, factoring in any bonuses they would
1600                 receive in stakeStart().
1601             */
1602             uint256 bonusGuns = _stakeStartBonusGuns(stakeReturn, st._stakedDays);
1603             uint256 newShareRate = (stakeReturn + bonusGuns) * SHARE_RATE_SCALE / st._stakeShares;
1604 
1605             if (newShareRate > SHARE_RATE_MAX) {
1606                 /*
1607                     Realistically this can't happen, but there are contrived theoretical
1608                     scenarios that can lead to extreme values of newShareRate, so it is
1609                     capped to prevent them anyway.
1610                 */
1611                 newShareRate = SHARE_RATE_MAX;
1612             }
1613 
1614             if (newShareRate > g._shareRate) {
1615                 g._shareRate = newShareRate;
1616 
1617                 emit ShareRateChange(
1618                     st._stakeId,
1619                     block.timestamp,
1620                     newShareRate
1621                 );
1622             }
1623         }
1624     }
1625 
1626 }
1627 
1628 contract TransformableToken is StakeableToken {
1629     /**
1630      * @dev PUBLIC FACING: Enter the auction lobby for the current round
1631      * @param referrerAddr TRX address of referring user (optional; 0x0 for no referrer)
1632      */
1633     function xfLobbyEnter(address referrerAddr)
1634         external
1635         payable
1636     {
1637         uint256 enterDay = _currentDay();
1638 
1639         uint256 rawAmount = msg.value;
1640         require(rawAmount != 0, "NUG: Amount required");
1641 
1642         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
1643 
1644         uint256 entryIndex = qRef.tailIndex++;
1645 
1646         qRef.entries[entryIndex] = XfLobbyEntryStore(uint96(rawAmount), referrerAddr);
1647 
1648         xfLobby[enterDay] += rawAmount;
1649 
1650         emit XfLobbyEnter(
1651             block.timestamp, 
1652             enterDay, 
1653             entryIndex, 
1654             rawAmount
1655         );
1656     }
1657 
1658     /**
1659      * @dev PUBLIC FACING: Leave the transform lobby after the round is complete
1660      * @param enterDay Day number when the member entered
1661      * @param count Number of queued-enters to exit (optional; 0 for all)
1662      */
1663     function xfLobbyExit(uint256 enterDay, uint256 count)
1664         external
1665     {
1666         require(enterDay < _currentDay(), "NUG: Round is not complete");
1667 
1668         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
1669 
1670         uint256 headIndex = qRef.headIndex;
1671         uint256 endIndex;
1672 
1673         if (count != 0) {
1674             require(count <= qRef.tailIndex - headIndex, "NUG: count invalid");
1675             endIndex = headIndex + count;
1676         } else {
1677             endIndex = qRef.tailIndex;
1678             require(headIndex < endIndex, "NUG: count invalid");
1679         }
1680 
1681         uint256 waasLobby = _waasLobby(enterDay);
1682         uint256 _xfLobby = xfLobby[enterDay];
1683         uint256 totalXfAmount = 0;
1684 
1685         do {
1686             uint256 rawAmount = qRef.entries[headIndex].rawAmount;
1687             address referrerAddr = qRef.entries[headIndex].referrerAddr;
1688 
1689             delete qRef.entries[headIndex];
1690 
1691             uint256 xfAmount = waasLobby * rawAmount / _xfLobby;
1692 
1693             if (referrerAddr == address(0) || referrerAddr == msg.sender) {
1694                 /* No referrer or Self-referred */
1695                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
1696             } else {
1697                 /* Referral bonus of 5% of xfAmount to member */
1698                 uint256 referralBonusGuns = xfAmount / 20;
1699 
1700                 xfAmount += referralBonusGuns;
1701 
1702                 /* Then a cumulative referrer bonus of 10% to referrer */
1703                 uint256 referrerBonusGuns = xfAmount / 10;
1704 
1705                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
1706                 _mint(referrerAddr, referrerBonusGuns);
1707             }
1708 
1709             totalXfAmount += xfAmount;
1710         } while (++headIndex < endIndex);
1711 
1712         qRef.headIndex = uint40(headIndex);
1713 
1714         if (totalXfAmount != 0) {
1715             _mint(msg.sender, totalXfAmount);
1716         }
1717     }
1718 
1719     /**
1720      * @dev PUBLIC FACING: External helper to return multiple values of xfLobby[] with
1721      * a single call
1722      * @param beginDay First day of data range
1723      * @param endDay Last day (non-inclusive) of data range
1724      * @return Fixed array of values
1725      */
1726     function xfLobbyRange(uint256 beginDay, uint256 endDay)
1727         external
1728         view
1729         returns (uint256[] memory list)
1730     {
1731         require(
1732             beginDay < endDay && endDay <= _currentDay(),
1733             "NUG: invalid range"
1734         );
1735 
1736         list = new uint256[](endDay - beginDay);
1737 
1738         uint256 src = beginDay;
1739         uint256 dst = 0;
1740         do {
1741             list[dst++] = uint256(xfLobby[src++]);
1742         } while (src < endDay);
1743 
1744         return list;
1745     }
1746 
1747     /**
1748      * @dev PUBLIC FACING: Release 15% for NUI Drip from daily divs
1749      */
1750     function xfFlush()
1751         external
1752     {
1753         GlobalsCache memory g;
1754         GlobalsCache memory gSnapshot;
1755         _globalsLoad(g, gSnapshot);
1756         
1757         require(address(this).balance != 0, "NUG: No value");
1758 
1759         require(LAST_FLUSHED_DAY < _currentDay(), "NUG: Invalid day");
1760 
1761         _dailyDataUpdateAuto(g);
1762 
1763         NUI_SHARE_ADDR.transfer((dailyData[LAST_FLUSHED_DAY].dayDividends * 15) / 100);
1764 
1765         LAST_FLUSHED_DAY++;
1766 
1767         _globalsSync(g, gSnapshot);
1768     }
1769 
1770     /**
1771      * @dev PUBLIC FACING: Return a current lobby member queue entry.
1772      * Only needed due to limitations of the standard ABI encoder.
1773      * @param memberAddr TRX address of the lobby member
1774      * @param enterDay 
1775      * @param entryIndex 
1776      * @return 1: Raw amount that was entered with; 2: Referring TRX addr (optional; 0x0 for no referrer)
1777      */
1778     function xfLobbyEntry(address memberAddr, uint256 enterDay, uint256 entryIndex)
1779         external
1780         view
1781         returns (uint256 rawAmount, address referrerAddr)
1782     {
1783         XfLobbyEntryStore storage entry = xfLobbyMembers[enterDay][memberAddr].entries[entryIndex];
1784 
1785         require(entry.rawAmount != 0, "NUG: Param invalid");
1786 
1787         return (entry.rawAmount, entry.referrerAddr);
1788     }
1789 
1790     /**
1791      * @dev PUBLIC FACING: Return the lobby days that a user is in with a single call
1792      * @param memberAddr TRX address of the user
1793      * @return Bit vector of lobby day numbers
1794      */
1795     function xfLobbyPendingDays(address memberAddr)
1796         external
1797         view
1798         returns (uint256[XF_LOBBY_DAY_WORDS] memory words)
1799     {
1800         uint256 day = _currentDay() + 1;
1801 
1802         while (day-- != 0) {
1803             if (xfLobbyMembers[day][memberAddr].tailIndex > xfLobbyMembers[day][memberAddr].headIndex) {
1804                 words[day >> 8] |= 1 << (day & 255);
1805             }
1806         }
1807 
1808         return words;
1809     }
1810     
1811     function _waasLobby(uint256 enterDay)
1812         private
1813         returns (uint256 waasLobby)
1814     {
1815         /*
1816 		* 
1817 		* 1000000000000 = 500000 * GUNS_PER_NUG / 50
1818 		*/
1819         if (enterDay > 0 && enterDay <= 50) {                                     
1820             waasLobby = CLAIM_STARTING_AMOUNT - ((enterDay - 1) * 1000000000000);
1821         } else {
1822             waasLobby = CLAIM_LOWEST_AMOUNT;
1823         }
1824 
1825         return waasLobby;
1826     }
1827 
1828     function _emitXfLobbyExit(
1829         uint256 enterDay,
1830         uint256 entryIndex,
1831         uint256 xfAmount,
1832         address referrerAddr
1833     )
1834         private
1835     {
1836         emit XfLobbyExit(
1837             block.timestamp, 
1838             enterDay,
1839             entryIndex,
1840             xfAmount,
1841             referrerAddr
1842         );
1843     }
1844 }
1845 
1846 contract NUG is TransformableToken {
1847     constructor()
1848         public
1849     {
1850         /* Initialize global shareRate to 1 */
1851         globals.shareRate = uint40(1 * SHARE_RATE_SCALE);
1852     }
1853 
1854     function() external payable {}
1855 }