1 pragma solidity 0.5.10;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
31  * the optional functions; to access them see {ERC20Detailed}.
32  */
33 interface TRC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      * - Subtraction cannot overflow.
155      *
156      * _Available since v2.4.0._
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      *
214      * _Available since v2.4.0._
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      *
251      * _Available since v2.4.0._
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 /**
260  * @dev Implementation of the {TRC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20Mintable}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {TRC20-approve}.
282  */
283 contract ERC20 is Context, TRC20 {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) private _balances;
287 
288     mapping (address => mapping (address => uint256)) private _allowances;
289 
290     // allocating 10 million tokens for xswap liquidity, promotions, airdrop and dev costs
291     uint256 private _totalSupply = 10000000 * (10 ** 8);
292 
293     constructor() public {
294         _balances[msg.sender] = _totalSupply;
295     }
296 
297     /**
298      * @dev See {TRC20-totalSupply}.
299      */
300     function totalSupply() public view returns (uint256) {
301         return _totalSupply;
302     }
303 
304     /**
305      * @dev See {TRC20-balanceOf}.
306      */
307     function balanceOf(address account) public view returns (uint256) {
308         return _balances[account];
309     }
310 
311     /**
312      * @dev See {TRC20-transfer}.
313      *
314      * Requirements:
315      *
316      * - `recipient` cannot be the zero address.
317      * - the caller must have a balance of at least `amount`.
318      */
319     function transfer(address recipient, uint256 amount) public returns (bool) {
320         _transfer(_msgSender(), recipient, amount);
321         return true;
322     }
323 
324     /**
325      * @dev See {TRC20-allowance}.
326      */
327     function allowance(address owner, address spender) public view returns (uint256) {
328         return _allowances[owner][spender];
329     }
330 
331     /**
332      * @dev See {TRC20-approve}.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      */
338     function approve(address spender, uint256 amount) public returns (bool) {
339         _approve(_msgSender(), spender, amount);
340         return true;
341     }
342 
343     /**
344      * @dev See {TRC20-transferFrom}.
345      *
346      * Emits an {Approval} event indicating the updated allowance. This is not
347      * required by the EIP. See the note at the beginning of {ERC20};
348      *
349      * Requirements:
350      * - `sender` and `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      * - the caller must have allowance for `sender`'s tokens of at least
353      * `amount`.
354      */
355     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
356         _transfer(sender, recipient, amount);
357         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
358         return true;
359     }
360 
361     /**
362      * @dev Atomically increases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to {approve} that can be used as a mitigation for
365      * problems described in {TRC20-approve}.
366      *
367      * Emits an {Approval} event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
374         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
375         return true;
376     }
377 
378     /**
379      * @dev Atomically decreases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {TRC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      * - `spender` must have allowance for the caller of at least
390      * `subtractedValue`.
391      */
392     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
393         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
394         return true;
395     }
396 
397     /**
398      * @dev Moves tokens `amount` from `sender` to `recipient`.
399      *
400      * This is internal function is equivalent to {transfer}, and can be used to
401      * e.g. implement automatic token fees, slashing mechanisms, etc.
402      *
403      * Emits a {Transfer} event.
404      *
405      * Requirements:
406      *
407      * - `sender` cannot be the zero address.
408      * - `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      */
411     function _transfer(address sender, address recipient, uint256 amount) internal {
412         require(sender != address(0), "ERC20: transfer from the zero address");
413         require(recipient != address(0), "ERC20: transfer to the zero address");
414 
415         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
416         _balances[recipient] = _balances[recipient].add(amount);
417         emit Transfer(sender, recipient, amount);
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements
426      *
427      * - `to` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _totalSupply = _totalSupply.add(amount);
433         _balances[account] = _balances[account].add(amount);
434         emit Transfer(address(0), account, amount);
435     }
436 
437      /**
438      * @dev External function to destroys `amount` tokens from `account`, reducing the
439      * total supply.
440      */
441     function burn(uint256 amount) external {
442         require(_balances[msg.sender] >= amount, "ERC20: not enough balance!");
443 
444         _burn(msg.sender, amount);
445     }
446 
447      /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
462         _totalSupply = _totalSupply.sub(amount);
463         emit Transfer(account, address(0), amount);
464     }
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
468      *
469      * This is internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(address owner, address spender, uint256 amount) internal {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
489      * from the caller's allowance.
490      *
491      * See {_burn} and {_approve}.
492      */
493     function _burnFrom(address account, uint256 amount) internal {
494         _burn(account, amount);
495         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
496     }
497 }
498 
499 contract GlobalsAndUtility is ERC20 {
500     /*  XfLobbyEnter
501     */
502     event XfLobbyEnter(
503         uint256 timestamp,
504         uint256 enterDay,
505         uint256 indexed entryIndex,
506         uint256 indexed rawAmount
507     );
508 
509     /*  XfLobbyExit 
510     */
511     event XfLobbyExit(
512         uint256 timestamp,
513         uint256 enterDay,
514         uint256 indexed entryIndex,
515         uint256 indexed xfAmount,
516         address indexed referrerAddr
517     );
518 
519     /*  DailyDataUpdate
520     */
521     event DailyDataUpdate(
522         address indexed updaterAddr,
523         uint256 timestamp,
524         uint256 beginDay,
525         uint256 endDay
526     );
527 
528     /*  StakeStart
529     */
530     event StakeStart(
531         uint40 indexed stakeId,
532         address indexed stakerAddr,
533         uint256 stakedSuns,
534         uint256 stakeShares,
535         uint256 stakedDays
536     );
537     
538     /*  StakeGoodAccounting
539     */
540     event StakeGoodAccounting(
541         uint40 indexed stakeId,
542         address indexed stakerAddr,
543         address indexed senderAddr,
544         uint256 stakedSuns,
545         uint256 stakeShares,
546         uint256 payout,
547         uint256 penalty
548     );
549 
550     /*  StakeEnd 
551     */
552     event StakeEnd(
553         uint40 indexed stakeId,
554         uint40 prevUnlocked,
555         address indexed stakerAddr,
556         uint256 lockedDay,
557         uint256 servedDays,
558         uint256 stakedSuns,
559         uint256 stakeShares,
560         uint256 dividends,
561         uint256 payout,
562         uint256 penalty,
563         uint256 stakeReturn
564     );
565 
566     /*  ShareRateChange 
567     */
568     event ShareRateChange(
569         uint40 indexed stakeId,
570         uint256 timestamp,
571         uint256 newShareRate
572     );
573 
574     /* T2X allocation share address */
575     address payable internal constant T2X_SHARE_ADDR = 0x769902b4cB2dfD79F2370555AD255Bf599bF7155;
576 
577     uint8 internal LAST_FLUSHED_DAY = 1;
578 
579     /* ERC20 constants */
580     string public constant name = "E2X";
581     string public constant symbol = "E2X";
582     uint8 public constant decimals = 8;
583 
584     /* Suns per Satoshi = 10,000 * 1e8 / 1e8 = 1e4 */
585     uint256 private constant SUNS_PER_E2X = 10 ** uint256(decimals); // 1e8
586 
587     /* Time of contract launch (30-10-2020 T00:00:00Z) */
588     uint256 internal constant LAUNCH_TIME = 1604016000;
589 
590     /* Start of claim phase */
591     uint256 internal constant PRE_CLAIM_DAYS = 1;
592     uint256 internal constant CLAIM_STARTING_AMOUNT = 5000000 * (10 ** 8);
593     uint256 internal constant CLAIM_LOWEST_AMOUNT = 1000000 * (10 ** 8);
594     uint256 internal constant CLAIM_PHASE_START_DAY = PRE_CLAIM_DAYS;
595 
596     /* Number of words to hold 1 bit for each transform lobby day */
597     uint256 internal constant XF_LOBBY_DAY_WORDS = ((1 + (50 * 7)) + 255) >> 8;
598 
599     /* Stake timing parameters */
600     uint256 internal constant MIN_STAKE_DAYS = 1;
601 
602     uint256 internal constant MAX_STAKE_DAYS = 365;
603 
604     uint256 internal constant EARLY_PENALTY_MIN_DAYS = 90;
605 
606     uint256 private constant LATE_PENALTY_GRACE_WEEKS = 2;
607     uint256 internal constant LATE_PENALTY_GRACE_DAYS = LATE_PENALTY_GRACE_WEEKS * 7;
608 
609     uint256 private constant LATE_PENALTY_SCALE_WEEKS = 100;
610     uint256 internal constant LATE_PENALTY_SCALE_DAYS = LATE_PENALTY_SCALE_WEEKS * 7;
611 
612     /* Stake shares Longer Pays Better bonus constants used by _stakeStartBonusSuns() */
613     uint256 private constant LPB_BONUS_PERCENT = 20;
614     uint256 private constant LPB_BONUS_MAX_PERCENT = 200;
615     uint256 internal constant LPB = 364 * 100 / LPB_BONUS_PERCENT;
616     uint256 internal constant LPB_MAX_DAYS = LPB * LPB_BONUS_MAX_PERCENT / 100;
617 
618     /* Stake shares Bigger Pays Better bonus constants used by _stakeStartBonusSuns() */
619     uint256 private constant BPB_BONUS_PERCENT = 10;
620     uint256 private constant BPB_MAX_E2X = 7 * 1e6;
621     uint256 internal constant BPB_MAX_SUNS = BPB_MAX_E2X * SUNS_PER_E2X;
622     uint256 internal constant BPB = BPB_MAX_SUNS * 100 / BPB_BONUS_PERCENT;
623 
624     /* Share rate is scaled to increase precision */
625     uint256 internal constant SHARE_RATE_SCALE = 1e5;
626 
627     /* Share rate max (after scaling) */
628     uint256 internal constant SHARE_RATE_UINT_SIZE = 40;
629     uint256 internal constant SHARE_RATE_MAX = (1 << SHARE_RATE_UINT_SIZE) - 1;
630 
631     /* weekly staking bonus */
632     uint8 internal constant BONUS_DAY_SCALE = 2;
633 
634     /* Globals expanded for memory (except _latestStakeId) and compact for storage */
635     struct GlobalsCache {
636         uint256 _lockedSunsTotal;
637         uint256 _nextStakeSharesTotal;
638         uint256 _shareRate;
639         uint256 _stakePenaltyTotal;
640         uint256 _dailyDataCount;
641         uint256 _stakeSharesTotal;
642         uint40 _latestStakeId;
643         uint256 _currentDay;
644     }
645 
646     struct GlobalsStore {
647         uint72 lockedSunsTotal;
648         uint72 nextStakeSharesTotal;
649         uint40 shareRate;
650         uint72 stakePenaltyTotal;
651         uint16 dailyDataCount;
652         uint72 stakeSharesTotal;
653         uint40 latestStakeId;
654     }
655 
656     GlobalsStore public globals;
657 
658     /* Daily data */
659     struct DailyDataStore {
660         uint72 dayPayoutTotal;
661         uint256 dayDividends;
662         uint72 dayStakeSharesTotal;
663     }
664 
665     mapping(uint256 => DailyDataStore) public dailyData;
666 
667     /* Stake expanded for memory (except _stakeId) and compact for storage */
668     struct StakeCache {
669         uint40 _stakeId;
670         uint256 _stakedSuns;
671         uint256 _stakeShares;
672         uint256 _lockedDay;
673         uint256 _stakedDays;
674         uint256 _unlockedDay;
675     }
676 
677     struct StakeStore {
678         uint40 stakeId;
679         uint72 stakedSuns;
680         uint72 stakeShares;
681         uint16 lockedDay;
682         uint16 stakedDays;
683         uint16 unlockedDay;
684     }
685 
686     mapping(address => StakeStore[]) public stakeLists;
687 
688     /* Temporary state for calculating daily rounds */
689     struct DailyRoundState {
690         uint256 _allocSupplyCached;
691         uint256 _payoutTotal;
692     }
693 
694     struct XfLobbyEntryStore {
695         uint96 rawAmount;
696         address referrerAddr;
697     }
698 
699     struct XfLobbyQueueStore {
700         uint40 headIndex;
701         uint40 tailIndex;
702         mapping(uint256 => XfLobbyEntryStore) entries;
703     }
704 
705     mapping(uint256 => uint256) public xfLobby;
706     mapping(uint256 => mapping(address => XfLobbyQueueStore)) public xfLobbyMembers;
707 
708     /**
709      * @dev PUBLIC FACING: Optionally update daily data for a smaller
710      * range to reduce gas cost for a subsequent operation
711      * @param beforeDay Only update days before this day number (optional; 0 for current day)
712      */
713     function dailyDataUpdate(uint256 beforeDay)
714         external
715     {
716         GlobalsCache memory g;
717         GlobalsCache memory gSnapshot;
718         _globalsLoad(g, gSnapshot);
719 
720         /* Skip pre-claim period */
721         require(g._currentDay > CLAIM_PHASE_START_DAY, "E2X: Too early");
722 
723         if (beforeDay != 0) {
724             require(beforeDay <= g._currentDay, "E2X: beforeDay cannot be in the future");
725 
726             _dailyDataUpdate(g, beforeDay, false);
727         } else {
728             /* Default to updating before current day */
729             _dailyDataUpdate(g, g._currentDay, false);
730         }
731 
732         _globalsSync(g, gSnapshot);
733     }
734 
735     /**
736      * @dev PUBLIC FACING: External helper to return multiple values of daily data with
737      * a single call.
738      * @param beginDay First day of data range
739      * @param endDay Last day (non-inclusive) of data range
740      * @return array of day stake shares total
741      * @return array of day payout total
742      */
743     function dailyDataRange(uint256 beginDay, uint256 endDay)
744         external
745         view
746         returns (uint256[] memory _dayStakeSharesTotal, uint256[] memory _dayPayoutTotal, uint256[] memory _dayDividends)
747     {
748         require(beginDay < endDay && endDay <= globals.dailyDataCount, "E2X: range invalid");
749 
750         _dayStakeSharesTotal = new uint256[](endDay - beginDay);
751         _dayPayoutTotal = new uint256[](endDay - beginDay);
752         _dayDividends = new uint256[](endDay - beginDay);
753 
754         uint256 src = beginDay;
755         uint256 dst = 0;
756         do {
757             _dayStakeSharesTotal[dst] = uint256(dailyData[src].dayStakeSharesTotal);
758             _dayPayoutTotal[dst++] = uint256(dailyData[src].dayPayoutTotal);
759             _dayDividends[dst++] = dailyData[src].dayDividends;
760         } while (++src < endDay);
761 
762         return (_dayStakeSharesTotal, _dayPayoutTotal, _dayDividends);
763     }
764 
765 
766     /**
767      * @dev PUBLIC FACING: External helper to return most global info with a single call.
768      * Ugly implementation due to limitations of the standard ABI encoder.
769      * @return Fixed array of values
770      */
771     function globalInfo()
772         external
773         view
774         returns (uint256[10] memory)
775     {
776 
777         return [
778             globals.lockedSunsTotal,
779             globals.nextStakeSharesTotal,
780             globals.shareRate,
781             globals.stakePenaltyTotal,
782             globals.dailyDataCount,
783             globals.stakeSharesTotal,
784             globals.latestStakeId,
785             block.timestamp,
786             totalSupply(),
787             xfLobby[_currentDay()]
788         ];
789     }
790 
791     /**
792      * @dev PUBLIC FACING: ERC20 totalSupply() is the circulating supply and does not include any
793      * staked Suns. allocatedSupply() includes both.
794      * @return Allocated Supply in Suns
795      */
796     function allocatedSupply()
797         external
798         view
799         returns (uint256)
800     {
801         return totalSupply() + globals.lockedSunsTotal;
802     }
803 
804     /**
805      * @dev PUBLIC FACING: External helper for the current day number since launch time
806      * @return Current day number (zero-based)
807      */
808     function currentDay()
809         external
810         view
811         returns (uint256)
812     {
813         return _currentDay();
814     }
815 
816     function _currentDay()
817         internal
818         view
819         returns (uint256)
820     {
821         if (block.timestamp < LAUNCH_TIME){
822              return 0;
823         }else{
824              return (block.timestamp - LAUNCH_TIME) / 1 days;
825         }
826     }
827 
828     function _dailyDataUpdateAuto(GlobalsCache memory g)
829         internal
830     {
831         _dailyDataUpdate(g, g._currentDay, true);
832     }
833 
834     function _globalsLoad(GlobalsCache memory g, GlobalsCache memory gSnapshot)
835         internal
836         view
837     {
838         g._lockedSunsTotal = globals.lockedSunsTotal;
839         g._nextStakeSharesTotal = globals.nextStakeSharesTotal;
840         g._shareRate = globals.shareRate;
841         g._stakePenaltyTotal = globals.stakePenaltyTotal;
842         g._dailyDataCount = globals.dailyDataCount;
843         g._stakeSharesTotal = globals.stakeSharesTotal;
844         g._latestStakeId = globals.latestStakeId;
845         g._currentDay = _currentDay();
846 
847         _globalsCacheSnapshot(g, gSnapshot);
848     }
849 
850     function _globalsCacheSnapshot(GlobalsCache memory g, GlobalsCache memory gSnapshot)
851         internal
852         pure
853     {
854         gSnapshot._lockedSunsTotal = g._lockedSunsTotal;
855         gSnapshot._nextStakeSharesTotal = g._nextStakeSharesTotal;
856         gSnapshot._shareRate = g._shareRate;
857         gSnapshot._stakePenaltyTotal = g._stakePenaltyTotal;
858         gSnapshot._dailyDataCount = g._dailyDataCount;
859         gSnapshot._stakeSharesTotal = g._stakeSharesTotal;
860         gSnapshot._latestStakeId = g._latestStakeId;
861     }
862 
863     function _globalsSync(GlobalsCache memory g, GlobalsCache memory gSnapshot)
864         internal
865     {
866         if (g._lockedSunsTotal != gSnapshot._lockedSunsTotal
867             || g._nextStakeSharesTotal != gSnapshot._nextStakeSharesTotal
868             || g._shareRate != gSnapshot._shareRate
869             || g._stakePenaltyTotal != gSnapshot._stakePenaltyTotal) {
870             globals.lockedSunsTotal = uint72(g._lockedSunsTotal);
871             globals.nextStakeSharesTotal = uint72(g._nextStakeSharesTotal);
872             globals.shareRate = uint40(g._shareRate);
873             globals.stakePenaltyTotal = uint72(g._stakePenaltyTotal);
874         }
875         if (g._dailyDataCount != gSnapshot._dailyDataCount
876             || g._stakeSharesTotal != gSnapshot._stakeSharesTotal
877             || g._latestStakeId != gSnapshot._latestStakeId) {
878             globals.dailyDataCount = uint16(g._dailyDataCount);
879             globals.stakeSharesTotal = uint72(g._stakeSharesTotal);
880             globals.latestStakeId = g._latestStakeId;
881         }
882     }
883 
884     function _stakeLoad(StakeStore storage stRef, uint40 stakeIdParam, StakeCache memory st)
885         internal
886         view
887     {
888         /* Ensure caller's stakeIndex is still current */
889         require(stakeIdParam == stRef.stakeId, "E2X: stakeIdParam not in stake");
890 
891         st._stakeId = stRef.stakeId;
892         st._stakedSuns = stRef.stakedSuns;
893         st._stakeShares = stRef.stakeShares;
894         st._lockedDay = stRef.lockedDay;
895         st._stakedDays = stRef.stakedDays;
896         st._unlockedDay = stRef.unlockedDay;
897     }
898 
899     function _stakeUpdate(StakeStore storage stRef, StakeCache memory st)
900         internal
901     {
902         stRef.stakeId = st._stakeId;
903         stRef.stakedSuns = uint72(st._stakedSuns);
904         stRef.stakeShares = uint72(st._stakeShares);
905         stRef.lockedDay = uint16(st._lockedDay);
906         stRef.stakedDays = uint16(st._stakedDays);
907         stRef.unlockedDay = uint16(st._unlockedDay);
908     }
909 
910     function _stakeAdd(
911         StakeStore[] storage stakeListRef,
912         uint40 newStakeId,
913         uint256 newStakedSuns,
914         uint256 newStakeShares,
915         uint256 newLockedDay,
916         uint256 newStakedDays
917     )
918         internal
919     {
920         stakeListRef.push(
921             StakeStore(
922                 newStakeId,
923                 uint72(newStakedSuns),
924                 uint72(newStakeShares),
925                 uint16(newLockedDay),
926                 uint16(newStakedDays),
927                 uint16(0) // unlockedDay
928             )
929         );
930     }
931 
932     /**
933      * @dev Efficiently delete from an unordered array by moving the last element
934      * to the "hole" and reducing the array length. Can change the order of the list
935      * and invalidate previously held indexes.
936      * @notice stakeListRef length and stakeIndex are already ensured valid in stakeEnd()
937      * @param stakeListRef Reference to stakeLists[stakerAddr] array in storage
938      * @param stakeIndex Index of the element to delete
939      */
940     function _stakeRemove(StakeStore[] storage stakeListRef, uint256 stakeIndex)
941         internal
942     {
943         uint256 lastIndex = stakeListRef.length - 1;
944 
945         /* Skip the copy if element to be removed is already the last element */
946         if (stakeIndex != lastIndex) {
947             /* Copy last element to the requested element's "hole" */
948             stakeListRef[stakeIndex] = stakeListRef[lastIndex];
949         }
950 
951         /*
952             Reduce the array length now that the array is contiguous.
953             Surprisingly, 'pop()' uses less gas than 'stakeListRef.length = lastIndex'
954         */
955         stakeListRef.pop();
956     }
957 
958     /**
959      * @dev Estimate the stake payout for an incomplete day
960      * @param g Cache of stored globals
961      * @param stakeSharesParam Param from stake to calculate bonuses for
962      * @param day Day to calculate bonuses for
963      * @return Payout in Suns
964      */
965     function _estimatePayoutRewardsDay(GlobalsCache memory g, uint256 stakeSharesParam, uint256 day)
966         internal
967         view
968         returns (uint256 payout)
969     {
970         /* Prevent updating state for this estimation */
971         GlobalsCache memory gTmp;
972         _globalsCacheSnapshot(g, gTmp);
973 
974         DailyRoundState memory rs;
975         rs._allocSupplyCached = totalSupply() + g._lockedSunsTotal;
976 
977         _dailyRoundCalc(gTmp, rs, day);
978 
979         /* Stake is no longer locked so it must be added to total as if it were */
980         gTmp._stakeSharesTotal += stakeSharesParam;
981 
982         payout = rs._payoutTotal * stakeSharesParam / gTmp._stakeSharesTotal;
983 
984         return payout;
985     }
986 
987     function _dailyRoundCalc(GlobalsCache memory g, DailyRoundState memory rs, uint256 day)
988         private
989         view
990     {
991         /*
992             Calculate payout round
993 
994             Inflation of 5.42% inflation per 364 days             (approx 1 year)
995             dailyInterestRate   = exp(log(1 + 5.42%)  / 364) - 1
996                                 = exp(log(1 + 0.0542) / 364) - 1
997                                 = exp(log(1.0542) / 364) - 1
998                                 = 0.0.00014523452066           (approx)
999 
1000             payout  = allocSupply * dailyInterestRate
1001                     = allocSupply / (1 / dailyInterestRate)
1002                     = allocSupply / (1 / 0.00014523452066)
1003                     = allocSupply / 6885.4153644438375            (approx)
1004                     = allocSupply * 50000 / 68854153             (* 50000/50000 for int precision)
1005         */
1006         
1007         rs._payoutTotal = (rs._allocSupplyCached * 50000 / 68854153);
1008 
1009         if (g._stakePenaltyTotal != 0) {
1010             rs._payoutTotal += g._stakePenaltyTotal;
1011             g._stakePenaltyTotal = 0;
1012         }
1013     }
1014 
1015     function _dailyRoundCalcAndStore(GlobalsCache memory g, DailyRoundState memory rs, uint256 day)
1016         private
1017     {
1018         _dailyRoundCalc(g, rs, day);
1019 
1020         dailyData[day].dayPayoutTotal = uint72(rs._payoutTotal);
1021         dailyData[day].dayDividends = xfLobby[day];
1022         dailyData[day].dayStakeSharesTotal = uint72(g._stakeSharesTotal);
1023     }
1024 
1025     function _dailyDataUpdate(GlobalsCache memory g, uint256 beforeDay, bool isAutoUpdate)
1026         private
1027     {
1028         if (g._dailyDataCount >= beforeDay) {
1029             /* Already up-to-date */
1030             return;
1031         }
1032 
1033         DailyRoundState memory rs;
1034         rs._allocSupplyCached = totalSupply() + g._lockedSunsTotal;
1035 
1036         uint256 day = g._dailyDataCount;
1037 
1038         _dailyRoundCalcAndStore(g, rs, day);
1039 
1040         /* Stakes started during this day are added to the total the next day */
1041         if (g._nextStakeSharesTotal != 0) {
1042             g._stakeSharesTotal += g._nextStakeSharesTotal;
1043             g._nextStakeSharesTotal = 0;
1044         }
1045 
1046         while (++day < beforeDay) {
1047             _dailyRoundCalcAndStore(g, rs, day);
1048         }
1049 
1050         emit DailyDataUpdate(
1051             msg.sender,
1052             block.timestamp,
1053             g._dailyDataCount, 
1054             day
1055         );
1056         
1057         g._dailyDataCount = day;
1058     }
1059 }
1060 
1061 contract StakeableToken is GlobalsAndUtility {
1062     /**
1063      * @dev PUBLIC FACING: Open a stake.
1064      * @param newStakedSuns Number of Suns to stake
1065      * @param newStakedDays Number of days to stake
1066      */
1067     function stakeStart(uint256 newStakedSuns, uint256 newStakedDays)
1068         external
1069     {
1070         GlobalsCache memory g;
1071         GlobalsCache memory gSnapshot;
1072         _globalsLoad(g, gSnapshot);
1073 
1074         /* Enforce the minimum stake time */
1075         require(newStakedDays >= MIN_STAKE_DAYS, "E2X: newStakedDays lower than minimum");
1076 
1077         /* Check if log data needs to be updated */
1078         _dailyDataUpdateAuto(g);
1079 
1080         _stakeStart(g, newStakedSuns, newStakedDays);
1081 
1082         /* Remove staked Suns from balance of staker */
1083         _burn(msg.sender, newStakedSuns);
1084 
1085         _globalsSync(g, gSnapshot);
1086     }
1087 
1088     /**
1089      * @dev PUBLIC FACING: Unlocks a completed stake, distributing the proceeds of any penalty
1090      * immediately. The staker must still call stakeEnd() to retrieve their stake return (if any).
1091      * @param stakerAddr Address of staker
1092      * @param stakeIndex Index of stake within stake list
1093      * @param stakeIdParam The stake's id
1094      */
1095     function stakeGoodAccounting(address stakerAddr, uint256 stakeIndex, uint40 stakeIdParam)
1096         external
1097     {
1098         GlobalsCache memory g;
1099         GlobalsCache memory gSnapshot;
1100         _globalsLoad(g, gSnapshot);
1101 
1102         /* require() is more informative than the default assert() */
1103         require(stakeLists[stakerAddr].length != 0, "E2X: Empty stake list");
1104         require(stakeIndex < stakeLists[stakerAddr].length, "E2X: stakeIndex invalid");
1105 
1106         StakeStore storage stRef = stakeLists[stakerAddr][stakeIndex];
1107 
1108         /* Get stake copy */
1109         StakeCache memory st;
1110         _stakeLoad(stRef, stakeIdParam, st);
1111 
1112         /* Stake must have served full term */
1113         require(g._currentDay >= st._lockedDay + st._stakedDays, "E2X: Stake not fully served");
1114 
1115         /* Stake must still be locked */
1116         require(st._unlockedDay == 0, "E2X: Stake already unlocked");
1117 
1118         /* Check if log data needs to be updated */
1119         _dailyDataUpdateAuto(g);
1120 
1121         /* Unlock the completed stake */
1122         _stakeUnlock(g, st);
1123 
1124         /* stakeReturn & dividends values are unused here */
1125         (, uint256 payout, uint256 dividends, uint256 penalty, uint256 cappedPenalty) = _stakePerformance(
1126             g,
1127             st,
1128             st._stakedDays
1129         );
1130 
1131         emit StakeGoodAccounting(
1132             stakeIdParam,
1133             stakerAddr,
1134             msg.sender,
1135             st._stakedSuns,
1136             st._stakeShares,
1137             payout,
1138             penalty
1139         );
1140 
1141         if (cappedPenalty != 0) {
1142             g._stakePenaltyTotal += cappedPenalty;
1143         }
1144 
1145         /* st._unlockedDay has changed */
1146         _stakeUpdate(stRef, st);
1147 
1148         _globalsSync(g, gSnapshot);
1149     }
1150 
1151     /**
1152      * @dev PUBLIC FACING: Closes a stake. The order of the stake list can change so
1153      * a stake id is used to reject stale indexes.
1154      * @param stakeIndex Index of stake within stake list
1155      * @param stakeIdParam The stake's id
1156      */
1157     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam)
1158         external
1159     {
1160         GlobalsCache memory g;
1161         GlobalsCache memory gSnapshot;
1162         _globalsLoad(g, gSnapshot);
1163 
1164         StakeStore[] storage stakeListRef = stakeLists[msg.sender];
1165 
1166         /* require() is more informative than the default assert() */
1167         require(stakeListRef.length != 0, "E2X: Empty stake list");
1168         require(stakeIndex < stakeListRef.length, "E2X: stakeIndex invalid");
1169 
1170         /* Get stake copy */
1171         StakeCache memory st;
1172         _stakeLoad(stakeListRef[stakeIndex], stakeIdParam, st);
1173 
1174         /* Check if log data needs to be updated */
1175         _dailyDataUpdateAuto(g);
1176 
1177         uint256 servedDays = 0;
1178 
1179         bool prevUnlocked = (st._unlockedDay != 0);
1180         uint256 stakeReturn;
1181         uint256 payout = 0;
1182         uint256 dividends = 0;
1183         uint256 penalty = 0;
1184         uint256 cappedPenalty = 0;
1185 
1186         if (g._currentDay >= st._lockedDay) {
1187             if (prevUnlocked) {
1188                 /* Previously unlocked in stakeGoodAccounting(), so must have served full term */
1189                 servedDays = st._stakedDays;
1190             } else {
1191                 _stakeUnlock(g, st);
1192 
1193                 servedDays = g._currentDay - st._lockedDay;
1194                 if (servedDays > st._stakedDays) {
1195                     servedDays = st._stakedDays;
1196                 }
1197             }
1198 
1199             (stakeReturn, payout, dividends, penalty, cappedPenalty) = _stakePerformance(g, st, servedDays);
1200 
1201             msg.sender.transfer(dividends);
1202         } else {
1203             /* Stake hasn't been added to the total yet, so no penalties or rewards apply */
1204             g._nextStakeSharesTotal -= st._stakeShares;
1205 
1206             stakeReturn = st._stakedSuns;
1207         }
1208 
1209         emit StakeEnd(
1210             stakeIdParam, 
1211             prevUnlocked ? 1 : 0,
1212             msg.sender,
1213             st._lockedDay,
1214             servedDays, 
1215             st._stakedSuns, 
1216             st._stakeShares, 
1217             dividends,
1218             payout, 
1219             penalty,
1220             stakeReturn
1221         );
1222 
1223         if (cappedPenalty != 0 && !prevUnlocked) {
1224             /* Split penalty proceeds only if not previously unlocked by stakeGoodAccounting() */
1225             g._stakePenaltyTotal += cappedPenalty;
1226         }
1227 
1228         /* Pay the stake return, if any, to the staker */
1229         if (stakeReturn != 0) {
1230             _mint(msg.sender, stakeReturn);
1231         }
1232         g._lockedSunsTotal -= st._stakedSuns;
1233 
1234         _stakeRemove(stakeListRef, stakeIndex);
1235 
1236         _globalsSync(g, gSnapshot);
1237     }
1238 
1239     /**
1240      * @dev PUBLIC FACING: Return the current stake count for a staker address
1241      * @param stakerAddr Address of staker
1242      */
1243     function stakeCount(address stakerAddr)
1244         external
1245         view
1246         returns (uint256)
1247     {
1248         return stakeLists[stakerAddr].length;
1249     }
1250 
1251     /**
1252      * @dev Open a stake.
1253      * @param g Cache of stored globals
1254      * @param newStakedSuns Number of Suns to stake
1255      * @param newStakedDays Number of days to stake
1256      */
1257     function _stakeStart(
1258         GlobalsCache memory g,
1259         uint256 newStakedSuns,
1260         uint256 newStakedDays
1261     )
1262         internal
1263     {
1264         /* Enforce the maximum stake time */
1265         require(newStakedDays <= MAX_STAKE_DAYS, "E2X: newStakedDays higher than maximum");
1266 
1267         uint256 bonusSuns = _stakeStartBonusSuns(newStakedSuns, newStakedDays);
1268         uint256 newStakeShares = (newStakedSuns + bonusSuns) * SHARE_RATE_SCALE / g._shareRate;
1269 
1270         /* Ensure newStakedSuns is enough for at least one stake share */
1271         require(newStakeShares != 0, "E2X: newStakedSuns must be at least minimum shareRate");
1272 
1273         /*
1274             The stakeStart timestamp will always be part-way through the current
1275             day, so it needs to be rounded-up to the next day to ensure all
1276             stakes align with the same fixed calendar days. The current day is
1277             already rounded-down, so rounded-up is current day + 1.
1278         */
1279         uint256 newLockedDay = g._currentDay + 1;
1280 
1281         /* Create Stake */
1282         uint40 newStakeId = ++g._latestStakeId;
1283         _stakeAdd(
1284             stakeLists[msg.sender],
1285             newStakeId,
1286             newStakedSuns,
1287             newStakeShares,
1288             newLockedDay,
1289             newStakedDays
1290         );
1291 
1292         emit StakeStart(
1293             newStakeId, 
1294             msg.sender,
1295             newStakedSuns, 
1296             newStakeShares, 
1297             newStakedDays
1298         );
1299 
1300         /* Stake is added to total in the next round, not the current round */
1301         g._nextStakeSharesTotal += newStakeShares;
1302 
1303         /* Track total staked Suns for inflation calculations */
1304         g._lockedSunsTotal += newStakedSuns;
1305     }
1306 
1307     /**
1308      * @dev Calculates total stake payout including rewards for a multi-day range
1309      * @param g Cache of stored globals
1310      * @param stakeSharesParam Param from stake to calculate bonuses for
1311      * @param beginDay First day to calculate bonuses for
1312      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1313      * @return Payout in Suns
1314      */
1315     function _calcPayoutRewards(
1316         GlobalsCache memory g,
1317         uint256 stakeSharesParam,
1318         uint256 beginDay,
1319         uint256 endDay
1320     )
1321         private
1322         view
1323         returns (uint256 payout)
1324     {
1325         uint256 counter;
1326 
1327         for (uint256 day = beginDay; day < endDay; day++) {
1328             uint256 dayPayout;
1329 
1330             dayPayout = dailyData[day].dayPayoutTotal * stakeSharesParam
1331                 / dailyData[day].dayStakeSharesTotal;
1332 
1333             if (counter < 4) {
1334                 counter++;
1335             } 
1336             /* Eligible to receive bonus */
1337             else {
1338                 dayPayout = (dailyData[day].dayPayoutTotal * stakeSharesParam
1339                 / dailyData[day].dayStakeSharesTotal) * BONUS_DAY_SCALE;
1340                 counter = 0;
1341             }
1342 
1343             payout += dayPayout;
1344         }
1345 
1346         return payout;
1347     }
1348 
1349     /**
1350      * @dev Calculates user dividends
1351      * @param g Cache of stored globals
1352      * @param stakeSharesParam Param from stake to calculate bonuses for
1353      * @param beginDay First day to calculate bonuses for
1354      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1355      * @return Payout in Suns
1356      */
1357     function _calcPayoutDividendsReward(
1358         GlobalsCache memory g,
1359         uint256 stakeSharesParam,
1360         uint256 beginDay,
1361         uint256 endDay
1362     )
1363         private
1364         view
1365         returns (uint256 payout)
1366     {
1367 
1368         for (uint256 day = beginDay; day < endDay; day++) {
1369             uint256 dayPayout;
1370 
1371             /* user's share of 95% of the day's dividends */
1372             dayPayout += ((dailyData[day].dayDividends * 90) / 100) * stakeSharesParam
1373             / dailyData[day].dayStakeSharesTotal;
1374 
1375             payout += dayPayout;
1376         }
1377 
1378         return payout;
1379     }
1380 
1381     /**
1382      * @dev Calculate bonus Suns for a new stake, if any
1383      * @param newStakedSuns Number of Suns to stake
1384      * @param newStakedDays Number of days to stake
1385      */
1386     function _stakeStartBonusSuns(uint256 newStakedSuns, uint256 newStakedDays)
1387         private
1388         pure
1389         returns (uint256 bonusSuns)
1390     {
1391         /*
1392             LONGER PAYS BETTER:
1393 
1394             If longer than 1 day stake is committed to, each extra day
1395             gives bonus shares of approximately 0.0548%, which is approximately 20%
1396             extra per year of increased stake length committed to, but capped to a
1397             maximum of 200% extra.
1398 
1399             extraDays       =  stakedDays - 1
1400 
1401             longerBonus%    = (extraDays / 364) * 20%
1402                             = (extraDays / 364) / 5
1403                             =  extraDays / 1820
1404                             =  extraDays / LPB
1405 
1406             extraDays       =  longerBonus% * 1820
1407             extraDaysMax    =  longerBonusMax% * 1820
1408                             =  200% * 1820
1409                             =  3640
1410                             =  LPB_MAX_DAYS
1411 
1412             BIGGER PAYS BETTER:
1413 
1414             Bonus percentage scaled 0% to 10% for the first 7M E2X of stake.
1415 
1416             biggerBonus%    = (cappedSuns /  BPB_MAX_SUNS) * 10%
1417                             = (cappedSuns /  BPB_MAX_SUNS) / 10
1418                             =  cappedSuns / (BPB_MAX_SUNS * 10)
1419                             =  cappedSuns /  BPB
1420 
1421             COMBINED:
1422 
1423             combinedBonus%  =            longerBonus%  +  biggerBonus%
1424 
1425                                       cappedExtraDays     cappedSuns
1426                             =         ---------------  +  ------------
1427                                             LPB               BPB
1428 
1429                                 cappedExtraDays * BPB     cappedSuns * LPB
1430                             =   ---------------------  +  ------------------
1431                                       LPB * BPB               LPB * BPB
1432 
1433                                 cappedExtraDays * BPB  +  cappedSuns * LPB
1434                             =   --------------------------------------------
1435                                                   LPB  *  BPB
1436 
1437             bonusSuns     = suns * combinedBonus%
1438                             = suns * (cappedExtraDays * BPB  +  cappedSuns * LPB) / (LPB * BPB)
1439         */
1440         uint256 cappedExtraDays = 0;
1441 
1442         /* Must be more than 1 day for Longer-Pays-Better */
1443         if (newStakedDays > 1) {
1444             cappedExtraDays = newStakedDays <= LPB_MAX_DAYS ? newStakedDays - 1 : LPB_MAX_DAYS;
1445         }
1446 
1447         uint256 cappedStakedSuns = newStakedSuns <= BPB_MAX_SUNS
1448             ? newStakedSuns
1449             : BPB_MAX_SUNS;
1450 
1451         bonusSuns = cappedExtraDays * BPB + cappedStakedSuns * LPB;
1452         bonusSuns = newStakedSuns * bonusSuns / (LPB * BPB);
1453 
1454         return bonusSuns;
1455     }
1456 
1457     function _stakeUnlock(GlobalsCache memory g, StakeCache memory st)
1458         private
1459         pure
1460     {
1461         g._stakeSharesTotal -= st._stakeShares;
1462         st._unlockedDay = g._currentDay;
1463     }
1464 
1465     function _stakePerformance(GlobalsCache memory g, StakeCache memory st, uint256 servedDays)
1466         private
1467         view
1468         returns (uint256 stakeReturn, uint256 payout, uint256 dividends, uint256 penalty, uint256 cappedPenalty)
1469     {
1470         if (servedDays < st._stakedDays) {
1471             (payout, penalty) = _calcPayoutAndEarlyPenalty(
1472                 g,
1473                 st._lockedDay,
1474                 st._stakedDays,
1475                 servedDays,
1476                 st._stakeShares
1477             );
1478             stakeReturn = st._stakedSuns + payout;
1479 
1480             dividends = _calcPayoutDividendsReward(
1481                 g,
1482                 st._stakeShares,
1483                 st._lockedDay,
1484                 st._lockedDay + servedDays
1485             );
1486         } else {
1487             // servedDays must == stakedDays here
1488             payout = _calcPayoutRewards(
1489                 g,
1490                 st._stakeShares,
1491                 st._lockedDay,
1492                 st._lockedDay + servedDays
1493             );
1494 
1495             dividends = _calcPayoutDividendsReward(
1496                 g,
1497                 st._stakeShares,
1498                 st._lockedDay,
1499                 st._lockedDay + servedDays
1500             );
1501 
1502             stakeReturn = st._stakedSuns + payout;
1503 
1504             penalty = _calcLatePenalty(st._lockedDay, st._stakedDays, st._unlockedDay, stakeReturn);
1505         }
1506         if (penalty != 0) {
1507             if (penalty > stakeReturn) {
1508                 /* Cannot have a negative stake return */
1509                 cappedPenalty = stakeReturn;
1510                 stakeReturn = 0;
1511             } else {
1512                 /* Remove penalty from the stake return */
1513                 cappedPenalty = penalty;
1514                 stakeReturn -= cappedPenalty;
1515             }
1516         }
1517         return (stakeReturn, payout, dividends, penalty, cappedPenalty);
1518     }
1519 
1520     function _calcPayoutAndEarlyPenalty(
1521         GlobalsCache memory g,
1522         uint256 lockedDayParam,
1523         uint256 stakedDaysParam,
1524         uint256 servedDays,
1525         uint256 stakeSharesParam
1526     )
1527         private
1528         view
1529         returns (uint256 payout, uint256 penalty)
1530     {
1531         uint256 servedEndDay = lockedDayParam + servedDays;
1532 
1533         /* 50% of stakedDays (rounded up) with a minimum applied */
1534         uint256 penaltyDays = (stakedDaysParam + 1) / 2;
1535         if (penaltyDays < EARLY_PENALTY_MIN_DAYS) {
1536             penaltyDays = EARLY_PENALTY_MIN_DAYS;
1537         }
1538 
1539         if (servedDays == 0) {
1540             /* Fill penalty days with the estimated average payout */
1541             uint256 expected = _estimatePayoutRewardsDay(g, stakeSharesParam, lockedDayParam);
1542             penalty = expected * penaltyDays;
1543             return (payout, penalty); // Actual payout was 0
1544         }
1545 
1546         if (penaltyDays < servedDays) {
1547             /*
1548                 Simplified explanation of intervals where end-day is non-inclusive:
1549 
1550                 penalty:    [lockedDay  ...  penaltyEndDay)
1551                 delta:                      [penaltyEndDay  ...  servedEndDay)
1552                 payout:     [lockedDay  .......................  servedEndDay)
1553             */
1554             uint256 penaltyEndDay = lockedDayParam + penaltyDays;
1555             penalty = _calcPayoutRewards(g, stakeSharesParam, lockedDayParam, penaltyEndDay);
1556 
1557             uint256 delta = _calcPayoutRewards(g, stakeSharesParam, penaltyEndDay, servedEndDay);
1558             payout = penalty + delta;
1559             return (payout, penalty);
1560         }
1561 
1562         /* penaltyDays >= servedDays  */
1563         payout = _calcPayoutRewards(g, stakeSharesParam, lockedDayParam, servedEndDay);
1564 
1565         if (penaltyDays == servedDays) {
1566             penalty = payout;
1567         } else {
1568             /*
1569                 (penaltyDays > servedDays) means not enough days served, so fill the
1570                 penalty days with the average payout from only the days that were served.
1571             */
1572             penalty = payout * penaltyDays / servedDays;
1573         }
1574         return (payout, penalty);
1575     }
1576 
1577     function _calcLatePenalty(
1578         uint256 lockedDayParam,
1579         uint256 stakedDaysParam,
1580         uint256 unlockedDayParam,
1581         uint256 rawStakeReturn
1582     )
1583         private
1584         pure
1585         returns (uint256)
1586     {
1587         /* Allow grace time before penalties accrue */
1588         uint256 maxUnlockedDay = lockedDayParam + stakedDaysParam + LATE_PENALTY_GRACE_DAYS;
1589         if (unlockedDayParam <= maxUnlockedDay) {
1590             return 0;
1591         }
1592 
1593         /* Calculate penalty as a percentage of stake return based on time */
1594         return rawStakeReturn * (unlockedDayParam - maxUnlockedDay) / LATE_PENALTY_SCALE_DAYS;
1595     }
1596 
1597 }
1598 
1599 contract TransformableToken is StakeableToken {
1600     /**
1601      * @dev PUBLIC FACING: Enter the auction lobby for the current round
1602      * @param referrerAddr TRX address of referring user (optional; 0x0 for no referrer)
1603      */
1604     function xfLobbyEnter(address referrerAddr)
1605         external
1606         payable
1607     {
1608         uint256 enterDay = _currentDay();
1609 
1610         uint256 rawAmount = msg.value;
1611         require(rawAmount != 0, "E2X: Amount required");
1612 
1613         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
1614 
1615         uint256 entryIndex = qRef.tailIndex++;
1616 
1617         qRef.entries[entryIndex] = XfLobbyEntryStore(uint96(rawAmount), referrerAddr);
1618 
1619         xfLobby[enterDay] += rawAmount;
1620 
1621         emit XfLobbyEnter(
1622             block.timestamp, 
1623             enterDay, 
1624             entryIndex, 
1625             rawAmount
1626         );
1627     }
1628 
1629     /**
1630      * @dev PUBLIC FACING: Leave the transform lobby after the round is complete
1631      * @param enterDay Day number when the member entered
1632      * @param count Number of queued-enters to exit (optional; 0 for all)
1633      */
1634     function xfLobbyExit(uint256 enterDay, uint256 count)
1635         external
1636     {
1637         require(enterDay < _currentDay(), "E2X: Round is not complete");
1638 
1639         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
1640 
1641         uint256 headIndex = qRef.headIndex;
1642         uint256 endIndex;
1643 
1644         if (count != 0) {
1645             require(count <= qRef.tailIndex - headIndex, "E2X: count invalid");
1646             endIndex = headIndex + count;
1647         } else {
1648             endIndex = qRef.tailIndex;
1649             require(headIndex < endIndex, "E2X: count invalid");
1650         }
1651 
1652         uint256 waasLobby = _waasLobby(enterDay);
1653         uint256 _xfLobby = xfLobby[enterDay];
1654         uint256 totalXfAmount = 0;
1655 
1656         do {
1657             uint256 rawAmount = qRef.entries[headIndex].rawAmount;
1658             address referrerAddr = qRef.entries[headIndex].referrerAddr;
1659 
1660             delete qRef.entries[headIndex];
1661 
1662             uint256 xfAmount = waasLobby * rawAmount / _xfLobby;
1663 
1664             if (referrerAddr == address(0) || referrerAddr == msg.sender) {
1665                 /* No referrer or Self-referred */
1666                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
1667             } else {
1668                 /* Referral bonus of 5% of xfAmount to member */
1669                 uint256 referralBonusSuns = xfAmount / 20;
1670 
1671                 xfAmount += referralBonusSuns;
1672 
1673                 /* Then a cumulative referrer bonus of 10% to referrer */
1674                 uint256 referrerBonusSuns = xfAmount / 10;
1675 
1676                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
1677                 _mint(referrerAddr, referrerBonusSuns);
1678             }
1679 
1680             totalXfAmount += xfAmount;
1681         } while (++headIndex < endIndex);
1682 
1683         qRef.headIndex = uint40(headIndex);
1684 
1685         if (totalXfAmount != 0) {
1686             _mint(msg.sender, totalXfAmount);
1687         }
1688     }
1689 
1690     /**
1691      * @dev PUBLIC FACING: External helper to return multiple values of xfLobby[] with
1692      * a single call
1693      * @param beginDay First day of data range
1694      * @param endDay Last day (non-inclusive) of data range
1695      * @return Fixed array of values
1696      */
1697     function xfLobbyRange(uint256 beginDay, uint256 endDay)
1698         external
1699         view
1700         returns (uint256[] memory list)
1701     {
1702         require(
1703             beginDay < endDay && endDay <= _currentDay(),
1704             "E2X: invalid range"
1705         );
1706 
1707         list = new uint256[](endDay - beginDay);
1708 
1709         uint256 src = beginDay;
1710         uint256 dst = 0;
1711         do {
1712             list[dst++] = uint256(xfLobby[src++]);
1713         } while (src < endDay);
1714 
1715         return list;
1716     }
1717 
1718     /**
1719      * @dev PUBLIC FACING: Release 5% dev share from daily dividends
1720      */
1721     function xfFlush()
1722         external
1723     {
1724         GlobalsCache memory g;
1725         GlobalsCache memory gSnapshot;
1726         _globalsLoad(g, gSnapshot);
1727         
1728         require(address(this).balance != 0, "E2X: No value");
1729 
1730         require(LAST_FLUSHED_DAY < _currentDay(), "E2X: Invalid day");
1731 
1732         _dailyDataUpdateAuto(g);
1733 
1734         T2X_SHARE_ADDR.transfer((dailyData[LAST_FLUSHED_DAY].dayDividends * 10) / 100);
1735 
1736         LAST_FLUSHED_DAY++;
1737 
1738         _globalsSync(g, gSnapshot);
1739     }
1740 
1741     /**
1742      * @dev PUBLIC FACING: Return a current lobby member queue entry.
1743      * Only needed due to limitations of the standard ABI encoder.
1744      * @param memberAddr TRX address of the lobby member
1745      * @param enterDay 
1746      * @param entryIndex 
1747      * @return 1: Raw amount that was entered with; 2: Referring TRX addr (optional; 0x0 for no referrer)
1748      */
1749     function xfLobbyEntry(address memberAddr, uint256 enterDay, uint256 entryIndex)
1750         external
1751         view
1752         returns (uint256 rawAmount, address referrerAddr)
1753     {
1754         XfLobbyEntryStore storage entry = xfLobbyMembers[enterDay][memberAddr].entries[entryIndex];
1755 
1756         require(entry.rawAmount != 0, "E2X: Param invalid");
1757 
1758         return (entry.rawAmount, entry.referrerAddr);
1759     }
1760 
1761     /**
1762      * @dev PUBLIC FACING: Return the lobby days that a user is in with a single call
1763      * @param memberAddr TRX address of the user
1764      * @return Bit vector of lobby day numbers
1765      */
1766     function xfLobbyPendingDays(address memberAddr)
1767         external
1768         view
1769         returns (uint256[XF_LOBBY_DAY_WORDS] memory words)
1770     {
1771         uint256 day = _currentDay() + 1;
1772 
1773         while (day-- != 0) {
1774             if (xfLobbyMembers[day][memberAddr].tailIndex > xfLobbyMembers[day][memberAddr].headIndex) {
1775                 words[day >> 8] |= 1 << (day & 255);
1776             }
1777         }
1778 
1779         return words;
1780     }
1781     
1782     function _waasLobby(uint256 enterDay)
1783         private
1784         returns (uint256 waasLobby)
1785     {
1786         /* 1342465753424 = ~ 4900000 * SUNS_PER_E2X / 365 */
1787         if (enterDay > 0 && enterDay <= 365) {                                     
1788             waasLobby = CLAIM_STARTING_AMOUNT - ((enterDay - 1) * 1342465753424);
1789         } else {
1790             waasLobby = CLAIM_LOWEST_AMOUNT;
1791         }
1792 
1793         return waasLobby;
1794     }
1795 
1796     function _emitXfLobbyExit(
1797         uint256 enterDay,
1798         uint256 entryIndex,
1799         uint256 xfAmount,
1800         address referrerAddr
1801     )
1802         private
1803     {
1804         emit XfLobbyExit(
1805             block.timestamp, 
1806             enterDay,
1807             entryIndex,
1808             xfAmount,
1809             referrerAddr
1810         );
1811     }
1812 }
1813 
1814 contract E2X is TransformableToken {
1815     constructor()
1816         public
1817     {
1818         /* Initialize global shareRate to 1 */
1819         globals.shareRate = uint40(1 * SHARE_RATE_SCALE);
1820     }
1821 
1822     function() external payable {}
1823 }