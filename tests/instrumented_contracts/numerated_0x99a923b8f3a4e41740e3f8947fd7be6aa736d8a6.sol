1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-31
3 */
4 
5 pragma solidity 0.5.10;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
35  * the optional functions; to access them see {ERC20Detailed}.
36  */
37 interface TRC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      *
160      * _Available since v2.4.0._
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      *
218      * _Available since v2.4.0._
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      *
255      * _Available since v2.4.0._
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 /**
264  * @dev Implementation of the {TRC20} interface.
265  *
266  * This implementation is agnostic to the way tokens are created. This means
267  * that a supply mechanism has to be added in a derived contract using {_mint}.
268  * For a generic mechanism see {ERC20Mintable}.
269  *
270  * TIP: For a detailed writeup see our guide
271  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
272  * to implement supply mechanisms].
273  *
274  * We have followed general OpenZeppelin guidelines: functions revert instead
275  * of returning `false` on failure. This behavior is nonetheless conventional
276  * and does not conflict with the expectations of ERC20 applications.
277  *
278  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
279  * This allows applications to reconstruct the allowance for all accounts just
280  * by listening to said events. Other implementations of the EIP may not emit
281  * these events, as it isn't required by the specification.
282  *
283  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
284  * functions have been added to mitigate the well-known issues around setting
285  * allowances. See {TRC20-approve}.
286  */
287 contract ERC20 is Context, TRC20 {
288     using SafeMath for uint256;
289 
290     mapping (address => uint256) private _balances;
291 
292     mapping (address => mapping (address => uint256)) private _allowances;
293 
294     // allocating 10 million tokens for xswap liquidity, promotions, airdrop and dev costs
295     uint256 private _totalSupply = 10000000 * (10 ** 8);
296 
297     constructor() public {
298         _balances[msg.sender] = _totalSupply;
299     }
300 
301     /**
302      * @dev See {TRC20-totalSupply}.
303      */
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309      * @dev See {TRC20-balanceOf}.
310      */
311     function balanceOf(address account) public view returns (uint256) {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See {TRC20-transfer}.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount) public returns (bool) {
324         _transfer(_msgSender(), recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {TRC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {TRC20-approve}.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function approve(address spender, uint256 amount) public returns (bool) {
343         _approve(_msgSender(), spender, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {TRC20-transferFrom}.
349      *
350      * Emits an {Approval} event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of {ERC20};
352      *
353      * Requirements:
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for `sender`'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
360         _transfer(sender, recipient, amount);
361         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {TRC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {TRC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
397         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
398         return true;
399     }
400 
401     /**
402      * @dev Moves tokens `amount` from `sender` to `recipient`.
403      *
404      * This is internal function is equivalent to {transfer}, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a {Transfer} event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(address sender, address recipient, uint256 amount) internal {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements
430      *
431      * - `to` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _totalSupply = _totalSupply.add(amount);
437         _balances[account] = _balances[account].add(amount);
438         emit Transfer(address(0), account, amount);
439     }
440 
441      /**
442      * @dev External function to destroys `amount` tokens from `account`, reducing the
443      * total supply.
444      */
445     function burn(uint256 amount) external {
446         require(_balances[msg.sender] >= amount, "ERC20: not enough balance!");
447 
448         _burn(msg.sender, amount);
449     }
450 
451      /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
466         _totalSupply = _totalSupply.sub(amount);
467         emit Transfer(account, address(0), amount);
468     }
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
472      *
473      * This is internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(address owner, address spender, uint256 amount) internal {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
493      * from the caller's allowance.
494      *
495      * See {_burn} and {_approve}.
496      */
497     function _burnFrom(address account, uint256 amount) internal {
498         _burn(account, amount);
499         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
500     }
501 }
502 
503 contract GlobalsAndUtility is ERC20 {
504     /*  XfLobbyEnter
505     */
506     event XfLobbyEnter(
507         uint256 timestamp,
508         uint256 enterDay,
509         uint256 indexed entryIndex,
510         uint256 indexed rawAmount
511     );
512 
513     /*  XfLobbyExit 
514     */
515     event XfLobbyExit(
516         uint256 timestamp,
517         uint256 enterDay,
518         uint256 indexed entryIndex,
519         uint256 indexed xfAmount,
520         address indexed referrerAddr
521     );
522 
523     /*  DailyDataUpdate
524     */
525     event DailyDataUpdate(
526         address indexed updaterAddr,
527         uint256 timestamp,
528         uint256 beginDay,
529         uint256 endDay
530     );
531 
532     /*  StakeStart
533     */
534     event StakeStart(
535         uint40 indexed stakeId,
536         address indexed stakerAddr,
537         uint256 stakedSuns,
538         uint256 stakeShares,
539         uint256 stakedDays
540     );
541     
542     /*  StakeGoodAccounting
543     */
544     event StakeGoodAccounting(
545         uint40 indexed stakeId,
546         address indexed stakerAddr,
547         address indexed senderAddr,
548         uint256 stakedSuns,
549         uint256 stakeShares,
550         uint256 payout,
551         uint256 penalty
552     );
553 
554     /*  StakeEnd 
555     */
556     event StakeEnd(
557         uint40 indexed stakeId,
558         uint40 prevUnlocked,
559         address indexed stakerAddr,
560         uint256 lockedDay,
561         uint256 servedDays,
562         uint256 stakedSuns,
563         uint256 stakeShares,
564         uint256 dividends,
565         uint256 payout,
566         uint256 penalty,
567         uint256 stakeReturn
568     );
569 
570     /*  ShareRateChange 
571     */
572     event ShareRateChange(
573         uint40 indexed stakeId,
574         uint256 timestamp,
575         uint256 newShareRate
576     );
577 
578     /* T2X allocation share address */
579     address payable internal constant T2X_SHARE_ADDR = 0x769902b4cB2dfD79F2370555AD255Bf599bF7155;
580 
581     uint8 internal LAST_FLUSHED_DAY = 1;
582 
583     /* ERC20 constants */
584     string public constant name = "E2X";
585     string public constant symbol = "E2X";
586     uint8 public constant decimals = 8;
587 
588     /* Suns per Satoshi = 10,000 * 1e8 / 1e8 = 1e4 */
589     uint256 private constant SUNS_PER_E2X = 10 ** uint256(decimals); // 1e8
590 
591     /* Time of contract launch (12-10-2020 T00:00:00Z) */
592     uint256 internal constant LAUNCH_TIME = 1605139200;
593 
594     /* Start of claim phase */
595     uint256 internal constant PRE_CLAIM_DAYS = 1;
596     uint256 internal constant CLAIM_STARTING_AMOUNT = 5000000 * (10 ** 8);
597     uint256 internal constant CLAIM_LOWEST_AMOUNT = 100000 * (10 ** 8);
598     uint256 internal constant CLAIM_PHASE_START_DAY = PRE_CLAIM_DAYS;
599 
600     /* Number of words to hold 1 bit for each transform lobby day */
601     uint256 internal constant XF_LOBBY_DAY_WORDS = ((1 + (50 * 7)) + 255) >> 8;
602 
603     /* Stake timing parameters */
604     uint256 internal constant MIN_STAKE_DAYS = 1;
605 
606     uint256 internal constant MAX_STAKE_DAYS = 365;
607 
608     uint256 internal constant EARLY_PENALTY_MIN_DAYS = 90;
609 
610     uint256 private constant LATE_PENALTY_GRACE_WEEKS = 2;
611     uint256 internal constant LATE_PENALTY_GRACE_DAYS = LATE_PENALTY_GRACE_WEEKS * 7;
612 
613     uint256 private constant LATE_PENALTY_SCALE_WEEKS = 100;
614     uint256 internal constant LATE_PENALTY_SCALE_DAYS = LATE_PENALTY_SCALE_WEEKS * 7;
615 
616     /* Stake shares Longer Pays Better bonus constants used by _stakeStartBonusSuns() */
617     uint256 private constant LPB_BONUS_PERCENT = 20;
618     uint256 private constant LPB_BONUS_MAX_PERCENT = 200;
619     uint256 internal constant LPB = 364 * 100 / LPB_BONUS_PERCENT;
620     uint256 internal constant LPB_MAX_DAYS = LPB * LPB_BONUS_MAX_PERCENT / 100;
621 
622     /* Stake shares Bigger Pays Better bonus constants used by _stakeStartBonusSuns() */
623     uint256 private constant BPB_BONUS_PERCENT = 10;
624     uint256 private constant BPB_MAX_E2X = 7 * 1e6;
625     uint256 internal constant BPB_MAX_SUNS = BPB_MAX_E2X * SUNS_PER_E2X;
626     uint256 internal constant BPB = BPB_MAX_SUNS * 100 / BPB_BONUS_PERCENT;
627 
628     /* Share rate is scaled to increase precision */
629     uint256 internal constant SHARE_RATE_SCALE = 1e5;
630 
631     /* Share rate max (after scaling) */
632     uint256 internal constant SHARE_RATE_UINT_SIZE = 40;
633     uint256 internal constant SHARE_RATE_MAX = (1 << SHARE_RATE_UINT_SIZE) - 1;
634 
635     /* weekly staking bonus */
636     uint8 internal constant BONUS_DAY_SCALE = 2;
637 
638     /* Globals expanded for memory (except _latestStakeId) and compact for storage */
639     struct GlobalsCache {
640         uint256 _lockedSunsTotal;
641         uint256 _nextStakeSharesTotal;
642         uint256 _shareRate;
643         uint256 _stakePenaltyTotal;
644         uint256 _dailyDataCount;
645         uint256 _stakeSharesTotal;
646         uint40 _latestStakeId;
647         uint256 _currentDay;
648     }
649 
650     struct GlobalsStore {
651         uint72 lockedSunsTotal;
652         uint72 nextStakeSharesTotal;
653         uint40 shareRate;
654         uint72 stakePenaltyTotal;
655         uint16 dailyDataCount;
656         uint72 stakeSharesTotal;
657         uint40 latestStakeId;
658     }
659 
660     GlobalsStore public globals;
661 
662     /* Daily data */
663     struct DailyDataStore {
664         uint72 dayPayoutTotal;
665         uint256 dayDividends;
666         uint72 dayStakeSharesTotal;
667     }
668 
669     mapping(uint256 => DailyDataStore) public dailyData;
670 
671     /* Stake expanded for memory (except _stakeId) and compact for storage */
672     struct StakeCache {
673         uint40 _stakeId;
674         uint256 _stakedSuns;
675         uint256 _stakeShares;
676         uint256 _lockedDay;
677         uint256 _stakedDays;
678         uint256 _unlockedDay;
679     }
680 
681     struct StakeStore {
682         uint40 stakeId;
683         uint72 stakedSuns;
684         uint72 stakeShares;
685         uint16 lockedDay;
686         uint16 stakedDays;
687         uint16 unlockedDay;
688     }
689 
690     mapping(address => StakeStore[]) public stakeLists;
691 
692     /* Temporary state for calculating daily rounds */
693     struct DailyRoundState {
694         uint256 _allocSupplyCached;
695         uint256 _payoutTotal;
696     }
697 
698     struct XfLobbyEntryStore {
699         uint96 rawAmount;
700         address referrerAddr;
701     }
702 
703     struct XfLobbyQueueStore {
704         uint40 headIndex;
705         uint40 tailIndex;
706         mapping(uint256 => XfLobbyEntryStore) entries;
707     }
708 
709     mapping(uint256 => uint256) public xfLobby;
710     mapping(uint256 => mapping(address => XfLobbyQueueStore)) public xfLobbyMembers;
711 
712     /**
713      * @dev PUBLIC FACING: Optionally update daily data for a smaller
714      * range to reduce gas cost for a subsequent operation
715      * @param beforeDay Only update days before this day number (optional; 0 for current day)
716      */
717     function dailyDataUpdate(uint256 beforeDay)
718         external
719     {
720         GlobalsCache memory g;
721         GlobalsCache memory gSnapshot;
722         _globalsLoad(g, gSnapshot);
723 
724         /* Skip pre-claim period */
725         require(g._currentDay > CLAIM_PHASE_START_DAY, "E2X: Too early");
726 
727         if (beforeDay != 0) {
728             require(beforeDay <= g._currentDay, "E2X: beforeDay cannot be in the future");
729 
730             _dailyDataUpdate(g, beforeDay, false);
731         } else {
732             /* Default to updating before current day */
733             _dailyDataUpdate(g, g._currentDay, false);
734         }
735 
736         _globalsSync(g, gSnapshot);
737     }
738 
739     /**
740      * @dev PUBLIC FACING: External helper to return multiple values of daily data with
741      * a single call.
742      * @param beginDay First day of data range
743      * @param endDay Last day (non-inclusive) of data range
744      * @return array of day stake shares total
745      * @return array of day payout total
746      */
747     function dailyDataRange(uint256 beginDay, uint256 endDay)
748         external
749         view
750         returns (uint256[] memory _dayStakeSharesTotal, uint256[] memory _dayPayoutTotal, uint256[] memory _dayDividends)
751     {
752         require(beginDay < endDay && endDay <= globals.dailyDataCount, "E2X: range invalid");
753 
754         _dayStakeSharesTotal = new uint256[](endDay - beginDay);
755         _dayPayoutTotal = new uint256[](endDay - beginDay);
756         _dayDividends = new uint256[](endDay - beginDay);
757 
758         uint256 src = beginDay;
759         uint256 dst = 0;
760         do {
761             _dayStakeSharesTotal[dst] = uint256(dailyData[src].dayStakeSharesTotal);
762             _dayPayoutTotal[dst++] = uint256(dailyData[src].dayPayoutTotal);
763             _dayDividends[dst++] = dailyData[src].dayDividends;
764         } while (++src < endDay);
765 
766         return (_dayStakeSharesTotal, _dayPayoutTotal, _dayDividends);
767     }
768 
769 
770     /**
771      * @dev PUBLIC FACING: External helper to return most global info with a single call.
772      * Ugly implementation due to limitations of the standard ABI encoder.
773      * @return Fixed array of values
774      */
775     function globalInfo()
776         external
777         view
778         returns (uint256[10] memory)
779     {
780 
781         return [
782             globals.lockedSunsTotal,
783             globals.nextStakeSharesTotal,
784             globals.shareRate,
785             globals.stakePenaltyTotal,
786             globals.dailyDataCount,
787             globals.stakeSharesTotal,
788             globals.latestStakeId,
789             block.timestamp,
790             totalSupply(),
791             xfLobby[_currentDay()]
792         ];
793     }
794 
795     /**
796      * @dev PUBLIC FACING: ERC20 totalSupply() is the circulating supply and does not include any
797      * staked Suns. allocatedSupply() includes both.
798      * @return Allocated Supply in Suns
799      */
800     function allocatedSupply()
801         external
802         view
803         returns (uint256)
804     {
805         return totalSupply() + globals.lockedSunsTotal;
806     }
807 
808     /**
809      * @dev PUBLIC FACING: External helper for the current day number since launch time
810      * @return Current day number (zero-based)
811      */
812     function currentDay()
813         external
814         view
815         returns (uint256)
816     {
817         return _currentDay();
818     }
819 
820     function _currentDay()
821         internal
822         view
823         returns (uint256)
824     {
825         if (block.timestamp < LAUNCH_TIME){
826              return 0;
827         }else{
828              return (block.timestamp - LAUNCH_TIME) / 1 days;
829         }
830     }
831 
832     function _dailyDataUpdateAuto(GlobalsCache memory g)
833         internal
834     {
835         _dailyDataUpdate(g, g._currentDay, true);
836     }
837 
838     function _globalsLoad(GlobalsCache memory g, GlobalsCache memory gSnapshot)
839         internal
840         view
841     {
842         g._lockedSunsTotal = globals.lockedSunsTotal;
843         g._nextStakeSharesTotal = globals.nextStakeSharesTotal;
844         g._shareRate = globals.shareRate;
845         g._stakePenaltyTotal = globals.stakePenaltyTotal;
846         g._dailyDataCount = globals.dailyDataCount;
847         g._stakeSharesTotal = globals.stakeSharesTotal;
848         g._latestStakeId = globals.latestStakeId;
849         g._currentDay = _currentDay();
850 
851         _globalsCacheSnapshot(g, gSnapshot);
852     }
853 
854     function _globalsCacheSnapshot(GlobalsCache memory g, GlobalsCache memory gSnapshot)
855         internal
856         pure
857     {
858         gSnapshot._lockedSunsTotal = g._lockedSunsTotal;
859         gSnapshot._nextStakeSharesTotal = g._nextStakeSharesTotal;
860         gSnapshot._shareRate = g._shareRate;
861         gSnapshot._stakePenaltyTotal = g._stakePenaltyTotal;
862         gSnapshot._dailyDataCount = g._dailyDataCount;
863         gSnapshot._stakeSharesTotal = g._stakeSharesTotal;
864         gSnapshot._latestStakeId = g._latestStakeId;
865     }
866 
867     function _globalsSync(GlobalsCache memory g, GlobalsCache memory gSnapshot)
868         internal
869     {
870         if (g._lockedSunsTotal != gSnapshot._lockedSunsTotal
871             || g._nextStakeSharesTotal != gSnapshot._nextStakeSharesTotal
872             || g._shareRate != gSnapshot._shareRate
873             || g._stakePenaltyTotal != gSnapshot._stakePenaltyTotal) {
874             globals.lockedSunsTotal = uint72(g._lockedSunsTotal);
875             globals.nextStakeSharesTotal = uint72(g._nextStakeSharesTotal);
876             globals.shareRate = uint40(g._shareRate);
877             globals.stakePenaltyTotal = uint72(g._stakePenaltyTotal);
878         }
879         if (g._dailyDataCount != gSnapshot._dailyDataCount
880             || g._stakeSharesTotal != gSnapshot._stakeSharesTotal
881             || g._latestStakeId != gSnapshot._latestStakeId) {
882             globals.dailyDataCount = uint16(g._dailyDataCount);
883             globals.stakeSharesTotal = uint72(g._stakeSharesTotal);
884             globals.latestStakeId = g._latestStakeId;
885         }
886     }
887 
888     function _stakeLoad(StakeStore storage stRef, uint40 stakeIdParam, StakeCache memory st)
889         internal
890         view
891     {
892         /* Ensure caller's stakeIndex is still current */
893         require(stakeIdParam == stRef.stakeId, "E2X: stakeIdParam not in stake");
894 
895         st._stakeId = stRef.stakeId;
896         st._stakedSuns = stRef.stakedSuns;
897         st._stakeShares = stRef.stakeShares;
898         st._lockedDay = stRef.lockedDay;
899         st._stakedDays = stRef.stakedDays;
900         st._unlockedDay = stRef.unlockedDay;
901     }
902 
903     function _stakeUpdate(StakeStore storage stRef, StakeCache memory st)
904         internal
905     {
906         stRef.stakeId = st._stakeId;
907         stRef.stakedSuns = uint72(st._stakedSuns);
908         stRef.stakeShares = uint72(st._stakeShares);
909         stRef.lockedDay = uint16(st._lockedDay);
910         stRef.stakedDays = uint16(st._stakedDays);
911         stRef.unlockedDay = uint16(st._unlockedDay);
912     }
913 
914     function _stakeAdd(
915         StakeStore[] storage stakeListRef,
916         uint40 newStakeId,
917         uint256 newStakedSuns,
918         uint256 newStakeShares,
919         uint256 newLockedDay,
920         uint256 newStakedDays
921     )
922         internal
923     {
924         stakeListRef.push(
925             StakeStore(
926                 newStakeId,
927                 uint72(newStakedSuns),
928                 uint72(newStakeShares),
929                 uint16(newLockedDay),
930                 uint16(newStakedDays),
931                 uint16(0) // unlockedDay
932             )
933         );
934     }
935 
936     /**
937      * @dev Efficiently delete from an unordered array by moving the last element
938      * to the "hole" and reducing the array length. Can change the order of the list
939      * and invalidate previously held indexes.
940      * @notice stakeListRef length and stakeIndex are already ensured valid in stakeEnd()
941      * @param stakeListRef Reference to stakeLists[stakerAddr] array in storage
942      * @param stakeIndex Index of the element to delete
943      */
944     function _stakeRemove(StakeStore[] storage stakeListRef, uint256 stakeIndex)
945         internal
946     {
947         uint256 lastIndex = stakeListRef.length - 1;
948 
949         /* Skip the copy if element to be removed is already the last element */
950         if (stakeIndex != lastIndex) {
951             /* Copy last element to the requested element's "hole" */
952             stakeListRef[stakeIndex] = stakeListRef[lastIndex];
953         }
954 
955         /*
956             Reduce the array length now that the array is contiguous.
957             Surprisingly, 'pop()' uses less gas than 'stakeListRef.length = lastIndex'
958         */
959         stakeListRef.pop();
960     }
961 
962     /**
963      * @dev Estimate the stake payout for an incomplete day
964      * @param g Cache of stored globals
965      * @param stakeSharesParam Param from stake to calculate bonuses for
966      * @param day Day to calculate bonuses for
967      * @return Payout in Suns
968      */
969     function _estimatePayoutRewardsDay(GlobalsCache memory g, uint256 stakeSharesParam, uint256 day)
970         internal
971         view
972         returns (uint256 payout)
973     {
974         /* Prevent updating state for this estimation */
975         GlobalsCache memory gTmp;
976         _globalsCacheSnapshot(g, gTmp);
977 
978         DailyRoundState memory rs;
979         rs._allocSupplyCached = totalSupply() + g._lockedSunsTotal;
980 
981         _dailyRoundCalc(gTmp, rs, day);
982 
983         /* Stake is no longer locked so it must be added to total as if it were */
984         gTmp._stakeSharesTotal += stakeSharesParam;
985 
986         payout = rs._payoutTotal * stakeSharesParam / gTmp._stakeSharesTotal;
987 
988         return payout;
989     }
990 
991     function _dailyRoundCalc(GlobalsCache memory g, DailyRoundState memory rs, uint256 day)
992         private
993         view
994     {
995         /*
996             Calculate payout round
997 
998             Inflation of 5.42% inflation per 364 days             (approx 1 year)
999             dailyInterestRate   = exp(log(1 + 5.42%)  / 364) - 1
1000                                 = exp(log(1 + 0.0542) / 364) - 1
1001                                 = exp(log(1.0542) / 364) - 1
1002                                 = 0.0.00014523452066           (approx)
1003 
1004             payout  = allocSupply * dailyInterestRate
1005                     = allocSupply / (1 / dailyInterestRate)
1006                     = allocSupply / (1 / 0.00014523452066)
1007                     = allocSupply / 6885.4153644438375            (approx)
1008                     = allocSupply * 50000 / 68854153             (* 50000/50000 for int precision)
1009         */
1010         
1011         rs._payoutTotal = (rs._allocSupplyCached * 50000 / 68854153);
1012 
1013         if (g._stakePenaltyTotal != 0) {
1014             rs._payoutTotal += g._stakePenaltyTotal;
1015             g._stakePenaltyTotal = 0;
1016         }
1017     }
1018 
1019     function _dailyRoundCalcAndStore(GlobalsCache memory g, DailyRoundState memory rs, uint256 day)
1020         private
1021     {
1022         _dailyRoundCalc(g, rs, day);
1023 
1024         dailyData[day].dayPayoutTotal = uint72(rs._payoutTotal);
1025         dailyData[day].dayDividends = xfLobby[day];
1026         dailyData[day].dayStakeSharesTotal = uint72(g._stakeSharesTotal);
1027     }
1028 
1029     function _dailyDataUpdate(GlobalsCache memory g, uint256 beforeDay, bool isAutoUpdate)
1030         private
1031     {
1032         if (g._dailyDataCount >= beforeDay) {
1033             /* Already up-to-date */
1034             return;
1035         }
1036 
1037         DailyRoundState memory rs;
1038         rs._allocSupplyCached = totalSupply() + g._lockedSunsTotal;
1039 
1040         uint256 day = g._dailyDataCount;
1041 
1042         _dailyRoundCalcAndStore(g, rs, day);
1043 
1044         /* Stakes started during this day are added to the total the next day */
1045         if (g._nextStakeSharesTotal != 0) {
1046             g._stakeSharesTotal += g._nextStakeSharesTotal;
1047             g._nextStakeSharesTotal = 0;
1048         }
1049 
1050         while (++day < beforeDay) {
1051             _dailyRoundCalcAndStore(g, rs, day);
1052         }
1053 
1054         emit DailyDataUpdate(
1055             msg.sender,
1056             block.timestamp,
1057             g._dailyDataCount, 
1058             day
1059         );
1060         
1061         g._dailyDataCount = day;
1062     }
1063 }
1064 
1065 contract StakeableToken is GlobalsAndUtility {
1066     /**
1067      * @dev PUBLIC FACING: Open a stake.
1068      * @param newStakedSuns Number of Suns to stake
1069      * @param newStakedDays Number of days to stake
1070      */
1071     function stakeStart(uint256 newStakedSuns, uint256 newStakedDays)
1072         external
1073     {
1074         GlobalsCache memory g;
1075         GlobalsCache memory gSnapshot;
1076         _globalsLoad(g, gSnapshot);
1077 
1078         /* Enforce the minimum stake time */
1079         require(newStakedDays >= MIN_STAKE_DAYS, "E2X: newStakedDays lower than minimum");
1080 
1081         /* Check if log data needs to be updated */
1082         _dailyDataUpdateAuto(g);
1083 
1084         _stakeStart(g, newStakedSuns, newStakedDays);
1085 
1086         /* Remove staked Suns from balance of staker */
1087         _burn(msg.sender, newStakedSuns);
1088 
1089         _globalsSync(g, gSnapshot);
1090     }
1091 
1092     /**
1093      * @dev PUBLIC FACING: Unlocks a completed stake, distributing the proceeds of any penalty
1094      * immediately. The staker must still call stakeEnd() to retrieve their stake return (if any).
1095      * @param stakerAddr Address of staker
1096      * @param stakeIndex Index of stake within stake list
1097      * @param stakeIdParam The stake's id
1098      */
1099     function stakeGoodAccounting(address stakerAddr, uint256 stakeIndex, uint40 stakeIdParam)
1100         external
1101     {
1102         GlobalsCache memory g;
1103         GlobalsCache memory gSnapshot;
1104         _globalsLoad(g, gSnapshot);
1105 
1106         /* require() is more informative than the default assert() */
1107         require(stakeLists[stakerAddr].length != 0, "E2X: Empty stake list");
1108         require(stakeIndex < stakeLists[stakerAddr].length, "E2X: stakeIndex invalid");
1109 
1110         StakeStore storage stRef = stakeLists[stakerAddr][stakeIndex];
1111 
1112         /* Get stake copy */
1113         StakeCache memory st;
1114         _stakeLoad(stRef, stakeIdParam, st);
1115 
1116         /* Stake must have served full term */
1117         require(g._currentDay >= st._lockedDay + st._stakedDays, "E2X: Stake not fully served");
1118 
1119         /* Stake must still be locked */
1120         require(st._unlockedDay == 0, "E2X: Stake already unlocked");
1121 
1122         /* Check if log data needs to be updated */
1123         _dailyDataUpdateAuto(g);
1124 
1125         /* Unlock the completed stake */
1126         _stakeUnlock(g, st);
1127 
1128         /* stakeReturn & dividends values are unused here */
1129         (, uint256 payout, uint256 dividends, uint256 penalty, uint256 cappedPenalty) = _stakePerformance(
1130             g,
1131             st,
1132             st._stakedDays
1133         );
1134 
1135         emit StakeGoodAccounting(
1136             stakeIdParam,
1137             stakerAddr,
1138             msg.sender,
1139             st._stakedSuns,
1140             st._stakeShares,
1141             payout,
1142             penalty
1143         );
1144 
1145         if (cappedPenalty != 0) {
1146             g._stakePenaltyTotal += cappedPenalty;
1147         }
1148 
1149         /* st._unlockedDay has changed */
1150         _stakeUpdate(stRef, st);
1151 
1152         _globalsSync(g, gSnapshot);
1153     }
1154 
1155     /**
1156      * @dev PUBLIC FACING: Closes a stake. The order of the stake list can change so
1157      * a stake id is used to reject stale indexes.
1158      * @param stakeIndex Index of stake within stake list
1159      * @param stakeIdParam The stake's id
1160      */
1161     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam)
1162         external
1163     {
1164         GlobalsCache memory g;
1165         GlobalsCache memory gSnapshot;
1166         _globalsLoad(g, gSnapshot);
1167 
1168         StakeStore[] storage stakeListRef = stakeLists[msg.sender];
1169 
1170         /* require() is more informative than the default assert() */
1171         require(stakeListRef.length != 0, "E2X: Empty stake list");
1172         require(stakeIndex < stakeListRef.length, "E2X: stakeIndex invalid");
1173 
1174         /* Get stake copy */
1175         StakeCache memory st;
1176         _stakeLoad(stakeListRef[stakeIndex], stakeIdParam, st);
1177 
1178         /* Check if log data needs to be updated */
1179         _dailyDataUpdateAuto(g);
1180 
1181         uint256 servedDays = 0;
1182 
1183         bool prevUnlocked = (st._unlockedDay != 0);
1184         uint256 stakeReturn;
1185         uint256 payout = 0;
1186         uint256 dividends = 0;
1187         uint256 penalty = 0;
1188         uint256 cappedPenalty = 0;
1189 
1190         if (g._currentDay >= st._lockedDay) {
1191             if (prevUnlocked) {
1192                 /* Previously unlocked in stakeGoodAccounting(), so must have served full term */
1193                 servedDays = st._stakedDays;
1194             } else {
1195                 _stakeUnlock(g, st);
1196 
1197                 servedDays = g._currentDay - st._lockedDay;
1198                 if (servedDays > st._stakedDays) {
1199                     servedDays = st._stakedDays;
1200                 }
1201             }
1202 
1203             (stakeReturn, payout, dividends, penalty, cappedPenalty) = _stakePerformance(g, st, servedDays);
1204 
1205             msg.sender.transfer(dividends);
1206         } else {
1207             /* Stake hasn't been added to the total yet, so no penalties or rewards apply */
1208             g._nextStakeSharesTotal -= st._stakeShares;
1209 
1210             stakeReturn = st._stakedSuns;
1211         }
1212 
1213         emit StakeEnd(
1214             stakeIdParam, 
1215             prevUnlocked ? 1 : 0,
1216             msg.sender,
1217             st._lockedDay,
1218             servedDays, 
1219             st._stakedSuns, 
1220             st._stakeShares, 
1221             dividends,
1222             payout, 
1223             penalty,
1224             stakeReturn
1225         );
1226 
1227         if (cappedPenalty != 0 && !prevUnlocked) {
1228             /* Split penalty proceeds only if not previously unlocked by stakeGoodAccounting() */
1229             g._stakePenaltyTotal += cappedPenalty;
1230         }
1231 
1232         /* Pay the stake return, if any, to the staker */
1233         if (stakeReturn != 0) {
1234             _mint(msg.sender, stakeReturn);
1235             
1236             /* Update the share rate if necessary */
1237             _shareRateUpdate(g, st, stakeReturn);
1238         }
1239         g._lockedSunsTotal -= st._stakedSuns;
1240 
1241         _stakeRemove(stakeListRef, stakeIndex);
1242 
1243         _globalsSync(g, gSnapshot);
1244     }
1245 
1246     /**
1247      * @dev PUBLIC FACING: Return the current stake count for a staker address
1248      * @param stakerAddr Address of staker
1249      */
1250     function stakeCount(address stakerAddr)
1251         external
1252         view
1253         returns (uint256)
1254     {
1255         return stakeLists[stakerAddr].length;
1256     }
1257 
1258     /**
1259      * @dev Open a stake.
1260      * @param g Cache of stored globals
1261      * @param newStakedSuns Number of Suns to stake
1262      * @param newStakedDays Number of days to stake
1263      */
1264     function _stakeStart(
1265         GlobalsCache memory g,
1266         uint256 newStakedSuns,
1267         uint256 newStakedDays
1268     )
1269         internal
1270     {
1271         /* Enforce the maximum stake time */
1272         require(newStakedDays <= MAX_STAKE_DAYS, "E2X: newStakedDays higher than maximum");
1273 
1274         uint256 bonusSuns = _stakeStartBonusSuns(newStakedSuns, newStakedDays);
1275         uint256 newStakeShares = (newStakedSuns + bonusSuns) * SHARE_RATE_SCALE / g._shareRate;
1276 
1277         /* Ensure newStakedSuns is enough for at least one stake share */
1278         require(newStakeShares != 0, "E2X: newStakedSuns must be at least minimum shareRate");
1279 
1280         /*
1281             The stakeStart timestamp will always be part-way through the current
1282             day, so it needs to be rounded-up to the next day to ensure all
1283             stakes align with the same fixed calendar days. The current day is
1284             already rounded-down, so rounded-up is current day + 1.
1285         */
1286         uint256 newLockedDay = g._currentDay + 1;
1287 
1288         /* Create Stake */
1289         uint40 newStakeId = ++g._latestStakeId;
1290         _stakeAdd(
1291             stakeLists[msg.sender],
1292             newStakeId,
1293             newStakedSuns,
1294             newStakeShares,
1295             newLockedDay,
1296             newStakedDays
1297         );
1298 
1299         emit StakeStart(
1300             newStakeId, 
1301             msg.sender,
1302             newStakedSuns, 
1303             newStakeShares, 
1304             newStakedDays
1305         );
1306 
1307         /* Stake is added to total in the next round, not the current round */
1308         g._nextStakeSharesTotal += newStakeShares;
1309 
1310         /* Track total staked Suns for inflation calculations */
1311         g._lockedSunsTotal += newStakedSuns;
1312     }
1313 
1314     /**
1315      * @dev Calculates total stake payout including rewards for a multi-day range
1316      * @param g Cache of stored globals
1317      * @param stakeSharesParam Param from stake to calculate bonuses for
1318      * @param beginDay First day to calculate bonuses for
1319      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1320      * @return Payout in Suns
1321      */
1322     function _calcPayoutRewards(
1323         GlobalsCache memory g,
1324         uint256 stakeSharesParam,
1325         uint256 beginDay,
1326         uint256 endDay
1327     )
1328         private
1329         view
1330         returns (uint256 payout)
1331     {
1332         uint256 counter;
1333 
1334         for (uint256 day = beginDay; day < endDay; day++) {
1335             uint256 dayPayout;
1336 
1337             dayPayout = dailyData[day].dayPayoutTotal * stakeSharesParam
1338                 / dailyData[day].dayStakeSharesTotal;
1339 
1340             if (counter < 4) {
1341                 counter++;
1342             } 
1343             /* Eligible to receive bonus */
1344             else {
1345                 dayPayout = (dailyData[day].dayPayoutTotal * stakeSharesParam
1346                 / dailyData[day].dayStakeSharesTotal) * BONUS_DAY_SCALE;
1347                 counter = 0;
1348             }
1349 
1350             payout += dayPayout;
1351         }
1352 
1353         return payout;
1354     }
1355 
1356     /**
1357      * @dev Calculates user dividends
1358      * @param g Cache of stored globals
1359      * @param stakeSharesParam Param from stake to calculate bonuses for
1360      * @param beginDay First day to calculate bonuses for
1361      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1362      * @return Payout in Suns
1363      */
1364     function _calcPayoutDividendsReward(
1365         GlobalsCache memory g,
1366         uint256 stakeSharesParam,
1367         uint256 beginDay,
1368         uint256 endDay
1369     )
1370         private
1371         view
1372         returns (uint256 payout)
1373     {
1374 
1375         for (uint256 day = beginDay; day < endDay; day++) {
1376             uint256 dayPayout;
1377 
1378             /* user's share of 95% of the day's dividends */
1379             dayPayout += ((dailyData[day].dayDividends * 90) / 100) * stakeSharesParam
1380             / dailyData[day].dayStakeSharesTotal;
1381 
1382             payout += dayPayout;
1383         }
1384 
1385         return payout;
1386     }
1387 
1388     /**
1389      * @dev Calculate bonus Suns for a new stake, if any
1390      * @param newStakedSuns Number of Suns to stake
1391      * @param newStakedDays Number of days to stake
1392      */
1393     function _stakeStartBonusSuns(uint256 newStakedSuns, uint256 newStakedDays)
1394         private
1395         pure
1396         returns (uint256 bonusSuns)
1397     {
1398         /*
1399             LONGER PAYS BETTER:
1400 
1401             If longer than 1 day stake is committed to, each extra day
1402             gives bonus shares of approximately 0.0548%, which is approximately 20%
1403             extra per year of increased stake length committed to, but capped to a
1404             maximum of 200% extra.
1405 
1406             extraDays       =  stakedDays - 1
1407 
1408             longerBonus%    = (extraDays / 364) * 20%
1409                             = (extraDays / 364) / 5
1410                             =  extraDays / 1820
1411                             =  extraDays / LPB
1412 
1413             extraDays       =  longerBonus% * 1820
1414             extraDaysMax    =  longerBonusMax% * 1820
1415                             =  200% * 1820
1416                             =  3640
1417                             =  LPB_MAX_DAYS
1418 
1419             BIGGER PAYS BETTER:
1420 
1421             Bonus percentage scaled 0% to 10% for the first 7M E2X of stake.
1422 
1423             biggerBonus%    = (cappedSuns /  BPB_MAX_SUNS) * 10%
1424                             = (cappedSuns /  BPB_MAX_SUNS) / 10
1425                             =  cappedSuns / (BPB_MAX_SUNS * 10)
1426                             =  cappedSuns /  BPB
1427 
1428             COMBINED:
1429 
1430             combinedBonus%  =            longerBonus%  +  biggerBonus%
1431 
1432                                       cappedExtraDays     cappedSuns
1433                             =         ---------------  +  ------------
1434                                             LPB               BPB
1435 
1436                                 cappedExtraDays * BPB     cappedSuns * LPB
1437                             =   ---------------------  +  ------------------
1438                                       LPB * BPB               LPB * BPB
1439 
1440                                 cappedExtraDays * BPB  +  cappedSuns * LPB
1441                             =   --------------------------------------------
1442                                                   LPB  *  BPB
1443 
1444             bonusSuns     = suns * combinedBonus%
1445                             = suns * (cappedExtraDays * BPB  +  cappedSuns * LPB) / (LPB * BPB)
1446         */
1447         uint256 cappedExtraDays = 0;
1448 
1449         /* Must be more than 1 day for Longer-Pays-Better */
1450         if (newStakedDays > 1) {
1451             cappedExtraDays = newStakedDays <= LPB_MAX_DAYS ? newStakedDays - 1 : LPB_MAX_DAYS;
1452         }
1453 
1454         uint256 cappedStakedSuns = newStakedSuns <= BPB_MAX_SUNS
1455             ? newStakedSuns
1456             : BPB_MAX_SUNS;
1457 
1458         bonusSuns = cappedExtraDays * BPB + cappedStakedSuns * LPB;
1459         bonusSuns = newStakedSuns * bonusSuns / (LPB * BPB);
1460 
1461         return bonusSuns;
1462     }
1463 
1464     function _stakeUnlock(GlobalsCache memory g, StakeCache memory st)
1465         private
1466         pure
1467     {
1468         g._stakeSharesTotal -= st._stakeShares;
1469         st._unlockedDay = g._currentDay;
1470     }
1471 
1472     function _stakePerformance(GlobalsCache memory g, StakeCache memory st, uint256 servedDays)
1473         private
1474         view
1475         returns (uint256 stakeReturn, uint256 payout, uint256 dividends, uint256 penalty, uint256 cappedPenalty)
1476     {
1477         if (servedDays < st._stakedDays) {
1478             (payout, penalty) = _calcPayoutAndEarlyPenalty(
1479                 g,
1480                 st._lockedDay,
1481                 st._stakedDays,
1482                 servedDays,
1483                 st._stakeShares
1484             );
1485             stakeReturn = st._stakedSuns + payout;
1486 
1487             dividends = _calcPayoutDividendsReward(
1488                 g,
1489                 st._stakeShares,
1490                 st._lockedDay,
1491                 st._lockedDay + servedDays
1492             );
1493         } else {
1494             // servedDays must == stakedDays here
1495             payout = _calcPayoutRewards(
1496                 g,
1497                 st._stakeShares,
1498                 st._lockedDay,
1499                 st._lockedDay + servedDays
1500             );
1501 
1502             dividends = _calcPayoutDividendsReward(
1503                 g,
1504                 st._stakeShares,
1505                 st._lockedDay,
1506                 st._lockedDay + servedDays
1507             );
1508 
1509             stakeReturn = st._stakedSuns + payout;
1510 
1511             penalty = _calcLatePenalty(st._lockedDay, st._stakedDays, st._unlockedDay, stakeReturn);
1512         }
1513         if (penalty != 0) {
1514             if (penalty > stakeReturn) {
1515                 /* Cannot have a negative stake return */
1516                 cappedPenalty = stakeReturn;
1517                 stakeReturn = 0;
1518             } else {
1519                 /* Remove penalty from the stake return */
1520                 cappedPenalty = penalty;
1521                 stakeReturn -= cappedPenalty;
1522             }
1523         }
1524         return (stakeReturn, payout, dividends, penalty, cappedPenalty);
1525     }
1526 
1527     function _calcPayoutAndEarlyPenalty(
1528         GlobalsCache memory g,
1529         uint256 lockedDayParam,
1530         uint256 stakedDaysParam,
1531         uint256 servedDays,
1532         uint256 stakeSharesParam
1533     )
1534         private
1535         view
1536         returns (uint256 payout, uint256 penalty)
1537     {
1538         uint256 servedEndDay = lockedDayParam + servedDays;
1539 
1540         /* 50% of stakedDays (rounded up) with a minimum applied */
1541         uint256 penaltyDays = (stakedDaysParam + 1) / 2;
1542         if (penaltyDays < EARLY_PENALTY_MIN_DAYS) {
1543             penaltyDays = EARLY_PENALTY_MIN_DAYS;
1544         }
1545 
1546         if (servedDays == 0) {
1547             /* Fill penalty days with the estimated average payout */
1548             uint256 expected = _estimatePayoutRewardsDay(g, stakeSharesParam, lockedDayParam);
1549             penalty = expected * penaltyDays;
1550             return (payout, penalty); // Actual payout was 0
1551         }
1552 
1553         if (penaltyDays < servedDays) {
1554             /*
1555                 Simplified explanation of intervals where end-day is non-inclusive:
1556 
1557                 penalty:    [lockedDay  ...  penaltyEndDay)
1558                 delta:                      [penaltyEndDay  ...  servedEndDay)
1559                 payout:     [lockedDay  .......................  servedEndDay)
1560             */
1561             uint256 penaltyEndDay = lockedDayParam + penaltyDays;
1562             penalty = _calcPayoutRewards(g, stakeSharesParam, lockedDayParam, penaltyEndDay);
1563 
1564             uint256 delta = _calcPayoutRewards(g, stakeSharesParam, penaltyEndDay, servedEndDay);
1565             payout = penalty + delta;
1566             return (payout, penalty);
1567         }
1568 
1569         /* penaltyDays >= servedDays  */
1570         payout = _calcPayoutRewards(g, stakeSharesParam, lockedDayParam, servedEndDay);
1571 
1572         if (penaltyDays == servedDays) {
1573             penalty = payout;
1574         } else {
1575             /*
1576                 (penaltyDays > servedDays) means not enough days served, so fill the
1577                 penalty days with the average payout from only the days that were served.
1578             */
1579             penalty = payout * penaltyDays / servedDays;
1580         }
1581         return (payout, penalty);
1582     }
1583 
1584     function _calcLatePenalty(
1585         uint256 lockedDayParam,
1586         uint256 stakedDaysParam,
1587         uint256 unlockedDayParam,
1588         uint256 rawStakeReturn
1589     )
1590         private
1591         pure
1592         returns (uint256)
1593     {
1594         /* Allow grace time before penalties accrue */
1595         uint256 maxUnlockedDay = lockedDayParam + stakedDaysParam + LATE_PENALTY_GRACE_DAYS;
1596         if (unlockedDayParam <= maxUnlockedDay) {
1597             return 0;
1598         }
1599 
1600         /* Calculate penalty as a percentage of stake return based on time */
1601         return rawStakeReturn * (unlockedDayParam - maxUnlockedDay) / LATE_PENALTY_SCALE_DAYS;
1602     }
1603 
1604     function _shareRateUpdate(GlobalsCache memory g, StakeCache memory st, uint256 stakeReturn)
1605         private
1606     {
1607         if (stakeReturn > st._stakedSuns) {
1608             /*
1609                 Calculate the new shareRate that would yield the same number of shares if
1610                 the user re-staked this stakeReturn, factoring in any bonuses they would
1611                 receive in stakeStart().
1612             */
1613             uint256 bonusSuns = _stakeStartBonusSuns(stakeReturn, st._stakedDays);
1614             uint256 newShareRate = (stakeReturn + bonusSuns) * SHARE_RATE_SCALE / st._stakeShares;
1615 
1616             if (newShareRate > SHARE_RATE_MAX) {
1617                 /*
1618                     Realistically this can't happen, but there are contrived theoretical
1619                     scenarios that can lead to extreme values of newShareRate, so it is
1620                     capped to prevent them anyway.
1621                 */
1622                 newShareRate = SHARE_RATE_MAX;
1623             }
1624 
1625             if (newShareRate > g._shareRate) {
1626                 g._shareRate = newShareRate;
1627 
1628                 emit ShareRateChange(
1629                     st._stakeId,
1630                     block.timestamp,
1631                     newShareRate
1632                 );
1633             }
1634         }
1635     }
1636 
1637 }
1638 
1639 contract TransformableToken is StakeableToken {
1640     /**
1641      * @dev PUBLIC FACING: Enter the auction lobby for the current round
1642      * @param referrerAddr TRX address of referring user (optional; 0x0 for no referrer)
1643      */
1644     function xfLobbyEnter(address referrerAddr)
1645         external
1646         payable
1647     {
1648         uint256 enterDay = _currentDay();
1649 
1650         uint256 rawAmount = msg.value;
1651         require(rawAmount != 0, "E2X: Amount required");
1652 
1653         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
1654 
1655         uint256 entryIndex = qRef.tailIndex++;
1656 
1657         qRef.entries[entryIndex] = XfLobbyEntryStore(uint96(rawAmount), referrerAddr);
1658 
1659         xfLobby[enterDay] += rawAmount;
1660 
1661         emit XfLobbyEnter(
1662             block.timestamp, 
1663             enterDay, 
1664             entryIndex, 
1665             rawAmount
1666         );
1667     }
1668 
1669     /**
1670      * @dev PUBLIC FACING: Leave the transform lobby after the round is complete
1671      * @param enterDay Day number when the member entered
1672      * @param count Number of queued-enters to exit (optional; 0 for all)
1673      */
1674     function xfLobbyExit(uint256 enterDay, uint256 count)
1675         external
1676     {
1677         require(enterDay < _currentDay(), "E2X: Round is not complete");
1678 
1679         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
1680 
1681         uint256 headIndex = qRef.headIndex;
1682         uint256 endIndex;
1683 
1684         if (count != 0) {
1685             require(count <= qRef.tailIndex - headIndex, "E2X: count invalid");
1686             endIndex = headIndex + count;
1687         } else {
1688             endIndex = qRef.tailIndex;
1689             require(headIndex < endIndex, "E2X: count invalid");
1690         }
1691 
1692         uint256 waasLobby = _waasLobby(enterDay);
1693         uint256 _xfLobby = xfLobby[enterDay];
1694         uint256 totalXfAmount = 0;
1695 
1696         do {
1697             uint256 rawAmount = qRef.entries[headIndex].rawAmount;
1698             address referrerAddr = qRef.entries[headIndex].referrerAddr;
1699 
1700             delete qRef.entries[headIndex];
1701 
1702             uint256 xfAmount = waasLobby * rawAmount / _xfLobby;
1703 
1704             if (referrerAddr == address(0) || referrerAddr == msg.sender) {
1705                 /* No referrer or Self-referred */
1706                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
1707             } else {
1708                 /* Referral bonus of 5% of xfAmount to member */
1709                 uint256 referralBonusSuns = xfAmount / 20;
1710 
1711                 xfAmount += referralBonusSuns;
1712 
1713                 /* Then a cumulative referrer bonus of 10% to referrer */
1714                 uint256 referrerBonusSuns = xfAmount / 10;
1715 
1716                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
1717                 _mint(referrerAddr, referrerBonusSuns);
1718             }
1719 
1720             totalXfAmount += xfAmount;
1721         } while (++headIndex < endIndex);
1722 
1723         qRef.headIndex = uint40(headIndex);
1724 
1725         if (totalXfAmount != 0) {
1726             _mint(msg.sender, totalXfAmount);
1727         }
1728     }
1729 
1730     /**
1731      * @dev PUBLIC FACING: External helper to return multiple values of xfLobby[] with
1732      * a single call
1733      * @param beginDay First day of data range
1734      * @param endDay Last day (non-inclusive) of data range
1735      * @return Fixed array of values
1736      */
1737     function xfLobbyRange(uint256 beginDay, uint256 endDay)
1738         external
1739         view
1740         returns (uint256[] memory list)
1741     {
1742         require(
1743             beginDay < endDay && endDay <= _currentDay(),
1744             "E2X: invalid range"
1745         );
1746 
1747         list = new uint256[](endDay - beginDay);
1748 
1749         uint256 src = beginDay;
1750         uint256 dst = 0;
1751         do {
1752             list[dst++] = uint256(xfLobby[src++]);
1753         } while (src < endDay);
1754 
1755         return list;
1756     }
1757 
1758     /**
1759      * @dev PUBLIC FACING: Release 5% dev share from daily dividends
1760      */
1761     function xfFlush()
1762         external
1763     {
1764         GlobalsCache memory g;
1765         GlobalsCache memory gSnapshot;
1766         _globalsLoad(g, gSnapshot);
1767         
1768         require(address(this).balance != 0, "E2X: No value");
1769 
1770         require(LAST_FLUSHED_DAY < _currentDay(), "E2X: Invalid day");
1771 
1772         _dailyDataUpdateAuto(g);
1773 
1774         T2X_SHARE_ADDR.transfer((dailyData[LAST_FLUSHED_DAY].dayDividends * 10) / 100);
1775 
1776         LAST_FLUSHED_DAY++;
1777 
1778         _globalsSync(g, gSnapshot);
1779     }
1780 
1781     /**
1782      * @dev PUBLIC FACING: Return a current lobby member queue entry.
1783      * Only needed due to limitations of the standard ABI encoder.
1784      * @param memberAddr TRX address of the lobby member
1785      * @param enterDay 
1786      * @param entryIndex 
1787      * @return 1: Raw amount that was entered with; 2: Referring TRX addr (optional; 0x0 for no referrer)
1788      */
1789     function xfLobbyEntry(address memberAddr, uint256 enterDay, uint256 entryIndex)
1790         external
1791         view
1792         returns (uint256 rawAmount, address referrerAddr)
1793     {
1794         XfLobbyEntryStore storage entry = xfLobbyMembers[enterDay][memberAddr].entries[entryIndex];
1795 
1796         require(entry.rawAmount != 0, "E2X: Param invalid");
1797 
1798         return (entry.rawAmount, entry.referrerAddr);
1799     }
1800 
1801     /**
1802      * @dev PUBLIC FACING: Return the lobby days that a user is in with a single call
1803      * @param memberAddr TRX address of the user
1804      * @return Bit vector of lobby day numbers
1805      */
1806     function xfLobbyPendingDays(address memberAddr)
1807         external
1808         view
1809         returns (uint256[XF_LOBBY_DAY_WORDS] memory words)
1810     {
1811         uint256 day = _currentDay() + 1;
1812 
1813         while (day-- != 0) {
1814             if (xfLobbyMembers[day][memberAddr].tailIndex > xfLobbyMembers[day][memberAddr].headIndex) {
1815                 words[day >> 8] |= 1 << (day & 255);
1816             }
1817         }
1818 
1819         return words;
1820     }
1821     
1822     function _waasLobby(uint256 enterDay)
1823         private
1824         returns (uint256 waasLobby)
1825     {
1826         /* 1342465753424 = ~ 4900000 * SUNS_PER_E2X / 365 */
1827         if (enterDay > 0 && enterDay <= 365) {                                     
1828             waasLobby = CLAIM_STARTING_AMOUNT - ((enterDay - 1) * 1342465753424);
1829         } else {
1830             waasLobby = CLAIM_LOWEST_AMOUNT;
1831         }
1832 
1833         return waasLobby;
1834     }
1835 
1836     function _emitXfLobbyExit(
1837         uint256 enterDay,
1838         uint256 entryIndex,
1839         uint256 xfAmount,
1840         address referrerAddr
1841     )
1842         private
1843     {
1844         emit XfLobbyExit(
1845             block.timestamp, 
1846             enterDay,
1847             entryIndex,
1848             xfAmount,
1849             referrerAddr
1850         );
1851     }
1852 }
1853 
1854 contract E2X is TransformableToken {
1855     constructor()
1856         public
1857     {
1858         /* Initialize global shareRate to 1 */
1859         globals.shareRate = uint40(1 * SHARE_RATE_SCALE);
1860     }
1861 
1862     function() external payable {}
1863 }