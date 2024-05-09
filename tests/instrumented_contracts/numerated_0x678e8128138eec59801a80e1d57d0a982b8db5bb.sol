1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 contract Ownable is Context {
283     address private _owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev Initializes the contract setting the deployer as the initial owner.
289      */
290     constructor () internal {
291         address msgSender = _msgSender();
292         _owner = msgSender;
293         emit OwnershipTransferred(address(0), msgSender);
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         require(isOwner(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     /**
312      * @dev Returns true if the caller is the current owner.
313      */
314     function isOwner() public view returns (bool) {
315         return _msgSender() == _owner;
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions anymore. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby removing any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public onlyOwner {
326         emit OwnershipTransferred(_owner, address(0));
327         _owner = address(0);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Can only be called by the current owner.
333      */
334     function transferOwnership(address newOwner) public onlyOwner {
335         _transferOwnership(newOwner);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      */
341     function _transferOwnership(address newOwner) internal {
342         require(newOwner != address(0), "Ownable: new owner is the zero address");
343         emit OwnershipTransferred(_owner, newOwner);
344         _owner = newOwner;
345     }
346 }
347 
348 // File: contracts/Jackpot.sol
349 
350 pragma solidity ^0.5.0;
351 
352 
353 
354 
355 
356 /**
357  * @dev Implementation of the {ERC20} interface.
358  *
359  * This implementation is agnostic to the way tokens are created. This means
360  * that a supply mechanism has to be added in a derived contract using {_mint}.
361  * For a generic mechanism see {ERC20Mintable}.
362  *
363  * TIP: For a detailed writeup see our guide
364  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
365  * to implement supply mechanisms].
366  *
367  * We have followed general OpenZeppelin guidelines: functions revert instead
368  * of returning `false` on failure. This behavior is nonetheless conventional
369  * and does not conflict with the expectations of ERC20 applications.
370  *
371  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
372  * This allows applications to reconstruct the allowance for all accounts just
373  * by listening to said events. Other implementations of the EIP may not emit
374  * these events, as it isn't required by the specification.
375  *
376  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
377  * functions have been added to mitigate the well-known issues around setting
378  * allowances. See {ERC20-approve}.
379  */
380 contract ERC20 is Context, IERC20, Ownable {
381     using SafeMath for uint256;
382     mapping(address => uint256) private _balances;
383     mapping(address => mapping(address => uint256)) private _allowances;
384     // allocating 30 million tokens for promotion, airdrop, liquidity and dev share
385     uint256 private _totalSupply = 99999900 * (10**8);
386 
387     constructor() public {
388         _balances[msg.sender] = _totalSupply;
389     }
390 
391     /**
392      * @dev See {ERC20-totalSupply}.
393      */
394     function totalSupply() public view returns (uint256) {
395         return _totalSupply;
396     }
397 
398     /**
399      * @dev See {ERC20-balanceOf}.
400      */
401     function balanceOf(address account) public view returns (uint256) {
402         return _balances[account];
403     }
404 
405     /**
406      * @dev See {ERC20-transfer}.
407      *
408      * Requirements:
409      *
410      * - `recipient` cannot be the zero address.
411      * - the caller must have a balance of at least `amount`.
412      */
413     function transfer(address recipient, uint256 amount) public returns (bool) {
414         _transfer(_msgSender(), recipient, amount);
415         return true;
416     }
417 
418     /**
419      * @dev See {ERC20-allowance}.
420      */
421     function allowance(address owner, address spender)
422         public
423         view
424         returns (uint256)
425     {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {ERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount) public returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {ERC20-transferFrom}.
443      *
444      * Emits an {Approval} event indicating the updated allowance. This is not
445      * required by the EIP. See the note at the beginning of {ERC20};
446      *
447      * Requirements:
448      * - `sender` and `recipient` cannot be the zero address.
449      * - `sender` must have a balance of at least `amount`.
450      * - the caller must have allowance for `sender`'s tokens of at least
451      * `amount`.
452      */
453     function transferFrom(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) public returns (bool) {
458         _transfer(sender, recipient, amount);
459         _approve(
460             sender,
461             _msgSender(),
462             _allowances[sender][_msgSender()].sub(
463                 amount,
464                 "ERC20: transfer amount exceeds allowance"
465             )
466         );
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {ERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     /* function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     } */
486     /**
487      * @dev Atomically decreases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {ERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      * - `spender` must have allowance for the caller of at least
498      * `subtractedValue`.
499      */
500     /* function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
502         return true;
503     } */
504     /**
505      * @dev Moves tokens `amount` from `sender` to `recipient`.
506      *
507      * This is internal function is equivalent to {transfer}, and can be used to
508      * e.g. implement automatic token fees, slashing mechanisms, etc.
509      *
510      * Emits a {Transfer} event.
511      *
512      * Requirements:
513      *
514      * - `sender` cannot be the zero address.
515      * - `recipient` cannot be the zero address.
516      * - `sender` must have a balance of at least `amount`.
517      */
518     function _transfer(
519         address sender,
520         address recipient,
521         uint256 amount
522     ) internal {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525         _balances[sender] = _balances[sender].sub(
526             amount,
527             "ERC20: transfer amount exceeds balance"
528         );
529         _balances[recipient] = _balances[recipient].add(amount);
530         emit Transfer(sender, recipient, amount);
531     }
532 
533     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534      * the total supply.
535      *
536      * Emits a {Transfer} event with `from` set to the zero address.
537      *
538      * Requirements
539      *
540      * - `to` cannot be the zero address.
541      */
542     function _mint(address account, uint256 amount) internal {
543         require(account != address(0), "ERC20: mint to the zero address");
544         _totalSupply = _totalSupply.add(amount);
545         _balances[account] = _balances[account].add(amount);
546         emit Transfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal {
561         require(account != address(0), "ERC20: burn from the zero address");
562         _balances[account] = _balances[account].sub(
563             amount,
564             "ERC20: burn amount exceeds balance"
565         );
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
572      *
573      * This is internal function is equivalent to `approve`, and can be used to
574      * e.g. set automatic allowances for certain subsystems, etc.
575      *
576      * Emits an {Approval} event.
577      *
578      * Requirements:
579      *
580      * - `owner` cannot be the zero address.
581      * - `spender` cannot be the zero address.
582      */
583     function _approve(
584         address owner,
585         address spender,
586         uint256 amount
587     ) internal {
588         require(owner != address(0), "ERC20: approve from the zero address");
589         require(spender != address(0), "ERC20: approve to the zero address");
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593     /**
594      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
595      * from the caller's allowance.
596      *
597      * See {_burn} and {_approve}.
598      */
599     /* function _burnFrom(address account, uint256 amount) internal {
600         _burn(account, amount);
601         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
602     } */
603 }
604 
605 contract GlobalsAndUtility is ERC20 {
606     /*  XfLobbyEnter
607      */
608     event XfLobbyEnter(
609         uint256 timestamp,
610         uint256 enterDay,
611         uint256 indexed entryIndex,
612         uint256 indexed rawAmount
613     );
614     /*  XfLobbyExit
615      */
616     event XfLobbyExit(
617         uint256 timestamp,
618         uint256 enterDay,
619         uint256 indexed entryIndex,
620         uint256 indexed xfAmount,
621         address indexed referrerAddr
622     );
623     /*  DailyDataUpdate
624      */
625     event DailyDataUpdate(
626         address indexed updaterAddr,
627         uint256 timestamp,
628         uint256 beginDay,
629         uint256 endDay
630     );
631     /*  StakeStart
632      */
633     event StakeStart(
634         uint40 indexed stakeId,
635         address indexed stakerAddr,
636         uint256 stakedSuns,
637         uint256 stakeShares,
638         uint256 stakedDays
639     );
640     /*  StakeGoodAccounting
641      */
642     event StakeGoodAccounting(
643         uint40 indexed stakeId,
644         address indexed stakerAddr,
645         address indexed senderAddr,
646         uint256 stakedSuns,
647         uint256 stakeShares,
648         uint256 payout,
649         uint256 penalty
650     );
651     /*  StakeEnd
652      */
653     event StakeEnd(
654         uint40 indexed stakeId,
655         uint40 prevUnlocked,
656         address indexed stakerAddr,
657         uint256 lockedDay,
658         uint256 servedDays,
659         uint256 stakedSuns,
660         uint256 stakeShares,
661         uint256 payout,
662         uint256 penalty,
663         uint256 stakeReturn
664     );
665     /*  ShareRateChange
666      */
667     event ShareRateChange(
668         uint40 indexed stakeId,
669         uint256 timestamp,
670         uint256 newShareRate
671     );
672     //uint256 internal constant ROUND_TIME = 1 days;
673     //uint256 internal constant ROUND_TIME = 2 hours;
674     uint256 public ROUND_TIME;
675     //uint256 internal constant ROUND_TIME = 5 minutes;
676     //uint256 internal constant LOTERY_ENTRY_TIME = 1 hours;
677     //uint256 internal constant LOTERY_ENTRY_TIME = 20 minutes;
678     uint256 public LOTERY_ENTRY_TIME;
679     address public defaultReferrerAddr;
680     /* Flush address */
681     address payable public flushAddr;
682     uint256 internal firstAuction = uint256(-1);
683     uint256 internal LAST_FLUSHED_DAY = 0;
684     /* ERC20 constants */
685     string public constant name = "Jackpot Ethereum";
686     string public constant symbol = "JETH";
687     uint8 public constant decimals = 8;
688     uint256 public LAUNCH_TIME; // = 1606046700;
689     uint256 public dayNumberBegin; // = 2;
690     /* Start of claim phase */
691     uint256 internal constant CLAIM_STARTING_AMOUNT =
692         2500000 * (10**uint256(decimals));
693     uint256 internal constant CLAIM_LOWEST_AMOUNT =
694         1000000 * (10**uint256(decimals));
695     /* Number of words to hold 1 bit for each transform lobby day */
696     uint256 internal constant XF_LOBBY_DAY_WORDS = ((1 + (50 * 7)) + 255) >> 8;
697     /* Stake timing parameters */
698     uint256 internal constant MIN_STAKE_DAYS = 1;
699     uint256 internal constant MAX_STAKE_DAYS = 180; // Approx 0.5 years
700     uint256 internal constant EARLY_PENALTY_MIN_DAYS = 90;
701     //uint256 private constant LATE_PENALTY_GRACE_WEEKS = 2;
702     uint256 internal constant LATE_PENALTY_GRACE_DAYS = 2 * 7;
703     //uint256 private constant LATE_PENALTY_SCALE_WEEKS = 100;
704     uint256 internal constant LATE_PENALTY_SCALE_DAYS = 100 * 7;
705     /* Stake shares Longer Pays Better bonus constants used by _stakeStartBonusSuns() */
706     //uint256 private constant LPB_BONUS_PERCENT = 20;
707     //uint256 private constant LPB_BONUS_MAX_PERCENT = 200;
708     uint256 internal constant LPB = (18 * 100) / 20; /* LPB_BONUS_PERCENT */
709     uint256 internal constant LPB_MAX_DAYS = (LPB * 200) / 100; /* LPB_BONUS_MAX_PERCENT */
710     /* Stake shares Bigger Pays Better bonus constants used by _stakeStartBonusSuns() */
711     //uint256 private constant BPB_BONUS_PERCENT = 10;
712     //uint256 private constant BPB_MAX_JACKPOT = 7 * 1e6;
713     uint256 internal constant BPB_MAX_SUNS =
714         7 *
715             1e6 * /* BPB_MAX_JACKPOT */
716             (10**uint256(decimals));
717     uint256 internal constant BPB = (BPB_MAX_SUNS * 100) / 10; /* BPB_BONUS_PERCENT */
718     /* Share rate is scaled to increase precision */
719     uint256 internal constant SHARE_RATE_SCALE = 1e5;
720     /* Share rate max (after scaling) */
721     uint256 internal constant SHARE_RATE_UINT_SIZE = 40;
722     uint256 internal constant SHARE_RATE_MAX = (1 << SHARE_RATE_UINT_SIZE) - 1;
723     /* weekly staking bonus */
724     uint8 internal constant BONUS_DAY_SCALE = 2;
725     /* Globals expanded for memory (except _latestStakeId) and compact for storage */
726     struct GlobalsCache {
727         uint256 _lockedSunsTotal;
728         uint256 _nextStakeSharesTotal;
729         uint256 _shareRate;
730         uint256 _stakePenaltyTotal;
731         uint256 _dailyDataCount;
732         uint256 _stakeSharesTotal;
733         uint40 _latestStakeId;
734         uint256 _currentDay;
735     }
736     struct GlobalsStore {
737         uint256 lockedSunsTotal;
738         uint256 nextStakeSharesTotal;
739         uint40 shareRate;
740         uint256 stakePenaltyTotal;
741         uint16 dailyDataCount;
742         uint256 stakeSharesTotal;
743         uint40 latestStakeId;
744     }
745     GlobalsStore public globals;
746     /* Daily data */
747     struct DailyDataStore {
748         uint256 dayPayoutTotal;
749         uint256 dayDividends;
750         uint256 dayStakeSharesTotal;
751     }
752     mapping(uint256 => DailyDataStore) public dailyData;
753     /* Stake expanded for memory (except _stakeId) and compact for storage */
754     struct StakeCache {
755         uint40 _stakeId;
756         uint256 _stakedSuns;
757         uint256 _stakeShares;
758         uint256 _lockedDay;
759         uint256 _stakedDays;
760         uint256 _unlockedDay;
761     }
762     struct StakeStore {
763         uint40 stakeId;
764         uint256 stakedSuns;
765         uint256 stakeShares;
766         uint16 lockedDay;
767         uint16 stakedDays;
768         uint16 unlockedDay;
769     }
770     struct UnstakeStore {
771         uint40 stakeId;
772         uint256 stakedSuns;
773         uint256 stakeShares;
774         uint16 lockedDay;
775         uint16 stakedDays;
776         uint16 unlockedDay;
777         uint256 unstakePayout;
778         uint256 unstakeDividends;
779     }
780     mapping(address => StakeStore[]) public stakeLists;
781     mapping(address => UnstakeStore[]) public endedStakeLists;
782     /* Temporary state for calculating daily rounds */
783     struct DailyRoundState {
784         uint256 _allocSupplyCached;
785         uint256 _payoutTotal;
786     }
787     struct XfLobbyEntryStore {
788         uint96 rawAmount;
789         address referrerAddr;
790     }
791     struct XfLobbyQueueStore {
792         uint40 headIndex;
793         uint40 tailIndex;
794         mapping(uint256 => XfLobbyEntryStore) entries;
795     }
796     mapping(uint256 => uint256) public xfLobby;
797     mapping(uint256 => mapping(address => XfLobbyQueueStore))
798         public xfLobbyMembers;
799     mapping(address => uint256) public fromReferrs;
800     mapping(uint256 => mapping(address => uint256))
801         public jackpotReceivedAuction;
802 
803     /*  loteryLobbyEnter
804      */
805     event loteryLobbyEnter(
806         uint256 timestamp,
807         uint256 enterDay,
808         uint256 indexed rawAmount
809     );
810     /*  loteryLobbyExit
811      */
812     event loteryLobbyExit(
813         uint256 timestamp,
814         uint256 enterDay,
815         uint256 indexed rawAmount
816     );
817     event loteryWin(uint256 day, uint256 amount, address who);
818     struct LoteryStore {
819         uint256 change;
820         uint256 chanceCount;
821     }
822     struct LoteryCount {
823         address who;
824         uint256 chanceCount;
825     }
826     struct winLoteryStat {
827         address payable who;
828         uint256 totalAmount;
829         uint256 restAmount;
830     }
831     uint256 public lastEndedLoteryDay = 0;
832     uint256 public lastEndedLoteryDayWithWinner = 0;
833     uint256 public loteryDayWaitingForWinner = 0;
834     uint256 public loteryDayWaitingForWinnerNew = 0;
835     mapping(uint256 => winLoteryStat) public winners;
836     mapping(uint256 => uint256) public dayChanceCount;
837     // day => address => chance count
838     mapping(uint256 => mapping(address => LoteryStore)) public loteryLobby;
839     mapping(uint256 => LoteryCount[]) public loteryCount;
840 
841     /**
842      * @dev PUBLIC FACING: Optionally update daily data for a smaller
843      * range to reduce gas cost for a subsequent operation
844      * @param beforeDay Only update days before this day number (optional; 0 for current day)
845      */
846     function dailyDataUpdate(uint256 beforeDay) external {
847         GlobalsCache memory g;
848         GlobalsCache memory gSnapshot;
849         _globalsLoad(g, gSnapshot);
850         /* Skip pre-claim period */
851         require(g._currentDay > 1, "JACKPOT: Too early"); /* CLAIM_PHASE_START_DAY */
852         if (beforeDay != 0) {
853             require(
854                 beforeDay <= g._currentDay,
855                 "JACKPOT: beforeDay cannot be in the future"
856             );
857             _dailyDataUpdate(g, beforeDay);
858         } else {
859             /* Default to updating before current day */
860             _dailyDataUpdate(g, g._currentDay);
861         }
862         _globalsSync(g, gSnapshot);
863     }
864 
865     /**
866      * @dev PUBLIC FACING: External helper to return multiple values of daily data with
867      * a single call.
868      * @param beginDay First day of data range
869      * @param endDay Last day (non-inclusive) of data range
870      * @return array of day stake shares total
871      * @return array of day payout total
872      */
873     /* function dailyDataRange(uint256 beginDay, uint256 endDay)
874         external
875         view
876         returns (uint256[] memory _dayStakeSharesTotal, uint256[] memory _dayPayoutTotal, uint256[] memory _dayDividends)
877     {
878         require(beginDay < endDay && endDay <= globals.dailyDataCount, "JACKPOT: range invalid");
879         _dayStakeSharesTotal = new uint256[](endDay - beginDay);
880         _dayPayoutTotal = new uint256[](endDay - beginDay);
881         _dayDividends = new uint256[](endDay - beginDay);
882         uint256 src = beginDay;
883         uint256 dst = 0;
884         do {
885             _dayStakeSharesTotal[dst] = uint256(dailyData[src].dayStakeSharesTotal);
886             _dayPayoutTotal[dst++] = uint256(dailyData[src].dayPayoutTotal);
887             _dayDividends[dst++] = dailyData[src].dayDividends;
888         } while (++src < endDay);
889         return (_dayStakeSharesTotal, _dayPayoutTotal, _dayDividends);
890     } */
891     /**
892      * @dev PUBLIC FACING: External helper to return most global info with a single call.
893      * Ugly implementation due to limitations of the standard ABI encoder.
894      * @return Fixed array of values
895      */
896     function globalInfo() external view returns (uint256[10] memory) {
897         return [
898             globals.lockedSunsTotal,
899             globals.nextStakeSharesTotal,
900             globals.shareRate,
901             globals.stakePenaltyTotal,
902             globals.dailyDataCount,
903             globals.stakeSharesTotal,
904             globals.latestStakeId,
905             block.timestamp,
906             totalSupply(),
907             xfLobby[_currentDay()]
908         ];
909     }
910 
911     /**
912      * @dev PUBLIC FACING: ERC20 totalSupply() is the circulating supply and does not include any
913      * staked Suns. allocatedSupply() includes both.
914      * @return Allocated Supply in Suns
915      */
916     function allocatedSupply() external view returns (uint256) {
917         return totalSupply().add(globals.lockedSunsTotal);
918     }
919 
920     /**
921      * @dev PUBLIC FACING: External helper for the current day number since launch time
922      * @return Current day number (zero-based)
923      */
924     function currentDay() external view returns (uint256) {
925         return _currentDay();
926     }
927 
928     function _currentDay() internal view returns (uint256) {
929         return block.timestamp.sub(LAUNCH_TIME).div(ROUND_TIME);
930     }
931 
932     function _dailyDataUpdateAuto(GlobalsCache memory g) internal {
933         _dailyDataUpdate(g, g._currentDay);
934     }
935 
936     function _globalsLoad(GlobalsCache memory g, GlobalsCache memory gSnapshot)
937         internal
938         view
939     {
940         g._lockedSunsTotal = globals.lockedSunsTotal;
941         g._nextStakeSharesTotal = globals.nextStakeSharesTotal;
942         g._shareRate = globals.shareRate;
943         g._stakePenaltyTotal = globals.stakePenaltyTotal;
944         g._dailyDataCount = globals.dailyDataCount;
945         g._stakeSharesTotal = globals.stakeSharesTotal;
946         g._latestStakeId = globals.latestStakeId;
947         g._currentDay = _currentDay();
948         _globalsCacheSnapshot(g, gSnapshot);
949     }
950 
951     function _globalsCacheSnapshot(
952         GlobalsCache memory g,
953         GlobalsCache memory gSnapshot
954     ) internal pure {
955         gSnapshot._lockedSunsTotal = g._lockedSunsTotal;
956         gSnapshot._nextStakeSharesTotal = g._nextStakeSharesTotal;
957         gSnapshot._shareRate = g._shareRate;
958         gSnapshot._stakePenaltyTotal = g._stakePenaltyTotal;
959         gSnapshot._dailyDataCount = g._dailyDataCount;
960         gSnapshot._stakeSharesTotal = g._stakeSharesTotal;
961         gSnapshot._latestStakeId = g._latestStakeId;
962     }
963 
964     function _globalsSync(GlobalsCache memory g, GlobalsCache memory gSnapshot)
965         internal
966     {
967         if (
968             g._lockedSunsTotal != gSnapshot._lockedSunsTotal ||
969             g._nextStakeSharesTotal != gSnapshot._nextStakeSharesTotal ||
970             g._shareRate != gSnapshot._shareRate ||
971             g._stakePenaltyTotal != gSnapshot._stakePenaltyTotal
972         ) {
973             globals.lockedSunsTotal = g._lockedSunsTotal;
974             globals.nextStakeSharesTotal = g._nextStakeSharesTotal;
975             globals.shareRate = uint40(g._shareRate);
976             globals.stakePenaltyTotal = g._stakePenaltyTotal;
977         }
978         if (
979             g._dailyDataCount != gSnapshot._dailyDataCount ||
980             g._stakeSharesTotal != gSnapshot._stakeSharesTotal ||
981             g._latestStakeId != gSnapshot._latestStakeId
982         ) {
983             globals.dailyDataCount = uint16(g._dailyDataCount);
984             globals.stakeSharesTotal = g._stakeSharesTotal;
985             globals.latestStakeId = g._latestStakeId;
986         }
987     }
988 
989     function _stakeLoad(
990         StakeStore storage stRef,
991         uint40 stakeIdParam,
992         StakeCache memory st
993     ) internal view {
994         /* Ensure caller's stakeIndex is still current */
995         require(
996             stakeIdParam == stRef.stakeId,
997             "JACKPOT: stakeIdParam not in stake"
998         );
999         st._stakeId = stRef.stakeId;
1000         st._stakedSuns = stRef.stakedSuns;
1001         st._stakeShares = stRef.stakeShares;
1002         st._lockedDay = stRef.lockedDay;
1003         st._stakedDays = stRef.stakedDays;
1004         st._unlockedDay = stRef.unlockedDay;
1005     }
1006 
1007     function _stakeUpdate(StakeStore storage stRef, StakeCache memory st)
1008         internal
1009     {
1010         stRef.stakeId = st._stakeId;
1011         stRef.stakedSuns = st._stakedSuns;
1012         stRef.stakeShares = st._stakeShares;
1013         stRef.lockedDay = uint16(st._lockedDay);
1014         stRef.stakedDays = uint16(st._stakedDays);
1015         stRef.unlockedDay = uint16(st._unlockedDay);
1016     }
1017 
1018     function _stakeAdd(
1019         StakeStore[] storage stakeListRef,
1020         uint40 newStakeId,
1021         uint256 newStakedSuns,
1022         uint256 newStakeShares,
1023         uint256 newLockedDay,
1024         uint256 newStakedDays
1025     ) internal {
1026         stakeListRef.push(
1027             StakeStore(
1028                 newStakeId,
1029                 newStakedSuns,
1030                 newStakeShares,
1031                 uint16(newLockedDay),
1032                 uint16(newStakedDays),
1033                 uint16(0) // unlockedDay
1034             )
1035         );
1036     }
1037 
1038     /**
1039      * @dev Efficiently delete from an unordered array by moving the last element
1040      * to the "hole" and reducing the array length. Can change the order of the list
1041      * and invalidate previously held indexes.
1042      * @notice stakeListRef length and stakeIndex are already ensured valid in stakeEnd()
1043      * @param stakeListRef Reference to stakeLists[stakerAddr] array in storage
1044      * @param stakeIndex Index of the element to delete
1045      */
1046     function _stakeRemove(StakeStore[] storage stakeListRef, uint256 stakeIndex)
1047         internal
1048     {
1049         uint256 lastIndex = stakeListRef.length.sub(1);
1050         /* Skip the copy if element to be removed is already the last element */
1051         if (stakeIndex != lastIndex) {
1052             /* Copy last element to the requested element's "hole" */
1053             stakeListRef[stakeIndex] = stakeListRef[lastIndex];
1054         }
1055         /*
1056             Reduce the array length now that the array is contiguous.
1057             Surprisingly, 'pop()' uses less gas than 'stakeListRef.length = lastIndex'
1058         */
1059         stakeListRef.pop();
1060     }
1061 
1062     /**
1063      * @dev Estimate the stake payout for an incomplete day
1064      * @param g Cache of stored globals
1065      * @param stakeSharesParam Param from stake to calculate bonuses for
1066      * @return Payout in Suns
1067      */
1068     function _estimatePayoutRewardsDay(
1069         GlobalsCache memory g,
1070         uint256 stakeSharesParam
1071     ) internal view returns (uint256 payout) {
1072         /* Prevent updating state for this estimation */
1073         GlobalsCache memory gJpt;
1074         _globalsCacheSnapshot(g, gJpt);
1075         DailyRoundState memory rs;
1076         rs._allocSupplyCached = totalSupply().add(g._lockedSunsTotal);
1077         _dailyRoundCalc(gJpt, rs);
1078         /* Stake is no longer locked so it must be added to total as if it were */
1079         gJpt._stakeSharesTotal = gJpt._stakeSharesTotal.add(stakeSharesParam);
1080         payout = rs._payoutTotal.mul(stakeSharesParam).div(gJpt._stakeSharesTotal);
1081         return payout;
1082     }
1083 
1084     function _dailyRoundCalc(GlobalsCache memory g, DailyRoundState memory rs)
1085         private
1086         pure
1087     {
1088         /*
1089             Calculate payout round
1090             Inflation of 20% inflation per 365 days             (approx 1 year)
1091             dailyInterestRate   = exp(log(1 + 20%)  / 365) - 1
1092                                 = exp(log(1 + 0.2) / 365) - 1
1093                                 = exp(log(1.2) / 365) - 1
1094                                 = 0.00049963589095561        (approx)
1095             payout  = allocSupply * dailyInterestRate
1096                     = allocSupply / (1 / dailyInterestRate)
1097                     = allocSupply / (1 / 0.00049963589095561)
1098                     = allocSupply / 2001.45749755364         (approx)
1099                     = allocSupply * 342345 / 685188967
1100         */
1101         //rs._payoutTotal = (rs._allocSupplyCached * 342345 / 685188967);
1102         rs._payoutTotal = rs._allocSupplyCached.mul(342345).div(685188967);
1103         if (g._stakePenaltyTotal != 0) {
1104             rs._payoutTotal = rs._payoutTotal.add(g._stakePenaltyTotal);
1105             g._stakePenaltyTotal = 0;
1106         }
1107     }
1108 
1109     function _dailyRoundCalcAndStore(
1110         GlobalsCache memory g,
1111         DailyRoundState memory rs,
1112         uint256 day
1113     ) private {
1114         _dailyRoundCalc(g, rs);
1115         dailyData[day].dayPayoutTotal = rs._payoutTotal;
1116         /* if (day == firstAuction + 2)
1117             dailyData[day].dayDividends = xfLobby[day] + xfLobby[firstAuction];
1118         if (day == firstAuction + 3)
1119             dailyData[day].dayDividends = xfLobby[day] + xfLobby[firstAuction + 1]; */
1120         dailyData[day].dayDividends = xfLobby[day];
1121         dailyData[day].dayStakeSharesTotal = g._stakeSharesTotal;
1122     }
1123 
1124     function _dailyDataUpdate(GlobalsCache memory g, uint256 beforeDay)
1125         private
1126     {
1127         if (g._dailyDataCount >= beforeDay) {
1128             /* Already up-to-date */
1129             return;
1130         }
1131         DailyRoundState memory rs;
1132         rs._allocSupplyCached = totalSupply().add(g._lockedSunsTotal);
1133         uint256 day = g._dailyDataCount;
1134         _dailyRoundCalcAndStore(g, rs, day);
1135         /* Stakes started during this day are added to the total the next day */
1136         if (g._nextStakeSharesTotal != 0) {
1137             g._stakeSharesTotal = g._stakeSharesTotal.add(g._nextStakeSharesTotal);
1138             g._nextStakeSharesTotal = 0;
1139         }
1140         while (++day < beforeDay) {
1141             _dailyRoundCalcAndStore(g, rs, day);
1142         }
1143         emit DailyDataUpdate(
1144             msg.sender,
1145             block.timestamp,
1146             g._dailyDataCount,
1147             day
1148         );
1149         g._dailyDataCount = day;
1150     }
1151 }
1152 
1153 contract StakeableToken is GlobalsAndUtility {
1154     modifier onlyAfterNDays(uint256 daysShift) {
1155         require(now >= LAUNCH_TIME, "JACKPOT: Too early");
1156         require(
1157             firstAuction != uint256(-1),
1158             "JACKPOT: Must be at least one auction"
1159         );
1160         require(
1161             _currentDay() >= firstAuction.add(daysShift),
1162             "JACKPOT: Too early"
1163         );
1164         _;
1165     }
1166 
1167     /**
1168      * @dev PUBLIC FACING: Open a stake.
1169      * @param newStakedSuns Number of Suns to stake
1170      * @param newStakedDays Number of days to stake
1171      */
1172     function stakeStart(uint256 newStakedSuns, uint256 newStakedDays)
1173         external
1174         onlyAfterNDays(1)
1175     {
1176         GlobalsCache memory g;
1177         GlobalsCache memory gSnapshot;
1178         _globalsLoad(g, gSnapshot);
1179         if (g._currentDay >= 1) endLoteryDay(g._currentDay.sub(1));
1180         /* Enforce the minimum stake time */
1181         require(
1182             newStakedDays >= MIN_STAKE_DAYS,
1183             "JACKPOT: newStakedDays lower than minimum"
1184         );
1185         /* Check if log data needs to be updated */
1186         _dailyDataUpdateAuto(g);
1187         _stakeStart(g, newStakedSuns, newStakedDays);
1188         /* Remove staked Suns from balance of staker */
1189         _burn(msg.sender, newStakedSuns);
1190         _globalsSync(g, gSnapshot);
1191     }
1192 
1193     /**
1194      * @dev PUBLIC FACING: Unlocks a completed stake, distributing the proceeds of any penalty
1195      * immediately. The staker must still call stakeEnd() to retrieve their stake return (if any).
1196      * @param stakerAddr Address of staker
1197      * @param stakeIndex Index of stake within stake list
1198      * @param stakeIdParam The stake's id
1199      */
1200     function stakeGoodAccounting(
1201         address stakerAddr,
1202         uint256 stakeIndex,
1203         uint40 stakeIdParam
1204     ) external {
1205         GlobalsCache memory g;
1206         GlobalsCache memory gSnapshot;
1207         _globalsLoad(g, gSnapshot);
1208         if (g._currentDay >= 1) endLoteryDay(g._currentDay.sub(1));
1209         /* require() is more informative than the default assert() */
1210         require(
1211             stakeLists[stakerAddr].length != 0,
1212             "JACKPOT: Empty stake list"
1213         );
1214         require(
1215             stakeIndex < stakeLists[stakerAddr].length,
1216             "JACKPOT: stakeIndex invalid"
1217         );
1218         StakeStore storage stRef = stakeLists[stakerAddr][stakeIndex];
1219         /* Get stake copy */
1220         StakeCache memory st;
1221         _stakeLoad(stRef, stakeIdParam, st);
1222         /* Stake must have served full term */
1223         require(
1224             g._currentDay >= st._lockedDay.add(st._stakedDays),
1225             "JACKPOT: Stake not fully served"
1226         );
1227         /* Stake must still be locked */
1228         require(st._unlockedDay == 0, "JACKPOT: Stake already unlocked");
1229         /* Check if log data needs to be updated */
1230         _dailyDataUpdateAuto(g);
1231         /* Unlock the completed stake */
1232         _stakeUnlock(g, st);
1233         /* stakeReturn & dividends values are unused here */
1234         (, uint256 payout, , uint256 penalty, uint256 cappedPenalty) =
1235             _stakePerformance(g, st, st._stakedDays);
1236         emit StakeGoodAccounting(
1237             stakeIdParam,
1238             stakerAddr,
1239             msg.sender,
1240             st._stakedSuns,
1241             st._stakeShares,
1242             payout,
1243             penalty
1244         );
1245         if (cappedPenalty != 0) {
1246             g._stakePenaltyTotal = g._stakePenaltyTotal.add(cappedPenalty);
1247         }
1248         /* st._unlockedDay has changed */
1249         _stakeUpdate(stRef, st);
1250         _globalsSync(g, gSnapshot);
1251     }
1252 
1253     /**
1254      * @dev PUBLIC FACING: Closes a stake. The order of the stake list can change so
1255      * a stake id is used to reject stale indexes.
1256      * @param stakeIndex Index of stake within stake list
1257      * @param stakeIdParam The stake's id
1258      */
1259     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external {
1260         GlobalsCache memory g;
1261         GlobalsCache memory gSnapshot;
1262         _globalsLoad(g, gSnapshot);
1263         StakeStore[] storage stakeListRef = stakeLists[msg.sender];
1264         /* require() is more informative than the default assert() */
1265         require(stakeListRef.length != 0, "JACKPOT: Empty stake list");
1266         require(
1267             stakeIndex < stakeListRef.length,
1268             "JACKPOT: stakeIndex invalid"
1269         );
1270         /* Get stake copy */
1271         StakeCache memory st;
1272         _stakeLoad(stakeListRef[stakeIndex], stakeIdParam, st);
1273         /* Check if log data needs to be updated */
1274         _dailyDataUpdateAuto(g);
1275         _globalsSync(g, gSnapshot);
1276         uint256 servedDays = 0;
1277         bool prevUnlocked = (st._unlockedDay != 0);
1278         uint256 stakeReturn;
1279         uint256 payout = 0;
1280         uint256 dividends = 0;
1281         uint256 penalty = 0;
1282         uint256 cappedPenalty = 0;
1283         if (g._currentDay >= st._lockedDay) {
1284             if (prevUnlocked) {
1285                 /* Previously unlocked in stakeGoodAccounting(), so must have served full term */
1286                 servedDays = st._stakedDays;
1287             } else {
1288                 //require(g._currentDay >= st._lockedDay + 5, "JACKPOT: Stake must serve at least 5 days");
1289                 _stakeUnlock(g, st);
1290                 servedDays = g._currentDay.sub(st._lockedDay);
1291                 if (servedDays > st._stakedDays) {
1292                     servedDays = st._stakedDays;
1293                 }
1294             }
1295             (
1296                 stakeReturn,
1297                 payout,
1298                 dividends,
1299                 penalty,
1300                 cappedPenalty
1301             ) = _stakePerformance(g, st, servedDays);
1302             msg.sender.transfer(dividends);
1303         } else {
1304             /* Stake hasn't been added to the total yet, so no penalties or rewards apply */
1305             g._nextStakeSharesTotal = g._nextStakeSharesTotal.sub(st._stakeShares);
1306             stakeReturn = st._stakedSuns;
1307         }
1308         emit StakeEnd(
1309             stakeIdParam,
1310             prevUnlocked ? 1 : 0,
1311             msg.sender,
1312             st._lockedDay,
1313             servedDays,
1314             st._stakedSuns,
1315             st._stakeShares,
1316             payout,
1317             penalty,
1318             stakeReturn
1319         );
1320         if (cappedPenalty != 0 && !prevUnlocked) {
1321             /* Split penalty proceeds only if not previously unlocked by stakeGoodAccounting() */
1322             g._stakePenaltyTotal = g._stakePenaltyTotal.add(cappedPenalty);
1323         }
1324         /* Pay the stake return, if any, to the staker */
1325         if (stakeReturn != 0) {
1326             _mint(msg.sender, stakeReturn);
1327             /* Update the share rate if necessary */
1328             _shareRateUpdate(g, st, stakeReturn);
1329         }
1330         g._lockedSunsTotal = g._lockedSunsTotal.sub(st._stakedSuns);
1331         stakeListRef[stakeIndex].unlockedDay = uint16(
1332             g._currentDay.mod(uint256(uint16(-1)))
1333         );
1334         UnstakeStore memory endedInfo;
1335         endedInfo.stakeId = stakeListRef[stakeIndex].stakeId;
1336         endedInfo.stakedSuns = stakeListRef[stakeIndex].stakedSuns;
1337         endedInfo.stakeShares = stakeListRef[stakeIndex].stakeShares;
1338         endedInfo.lockedDay = stakeListRef[stakeIndex].lockedDay;
1339         endedInfo.stakedDays = stakeListRef[stakeIndex].stakedDays;
1340         endedInfo.unlockedDay = stakeListRef[stakeIndex].unlockedDay;
1341         endedInfo.unstakePayout = stakeReturn;
1342         endedInfo.unstakeDividends = dividends;
1343         //endedStakeLists[_msgSender()].push(stakeListRef[stakeIndex]);
1344         endedStakeLists[_msgSender()].push(endedInfo);
1345         _stakeRemove(stakeListRef, stakeIndex);
1346         _globalsSync(g, gSnapshot);
1347     }
1348 
1349     uint256 private undestributedLotery = 0;
1350 
1351     function endLoteryDay(uint256 endDay) public onlyAfterNDays(0) {
1352         uint256 currDay = _currentDay();
1353         if (currDay == 0) return;
1354         if (endDay >= currDay) endDay = currDay.sub(1);
1355         if (
1356             endDay == currDay.sub(1) &&
1357             now % ROUND_TIME <= LOTERY_ENTRY_TIME &&
1358             endDay > 0
1359         ) endDay = endDay.sub(1);
1360         else if (
1361             endDay == currDay.sub(1) &&
1362             now % ROUND_TIME <= LOTERY_ENTRY_TIME &&
1363             endDay == 0
1364         ) return;
1365         while (lastEndedLoteryDay <= endDay) {
1366             uint256 ChanceCount = dayChanceCount[lastEndedLoteryDay];
1367             if (ChanceCount == 0) {
1368                 undestributedLotery = undestributedLotery.add(xfLobby[lastEndedLoteryDay].mul(25).div(1000));
1369                 lastEndedLoteryDay = lastEndedLoteryDay.add(1);
1370                 continue;
1371             }
1372             uint256 randomInt = _random(ChanceCount);
1373             //uint256 randomInt = _random(10000);
1374             uint256 count = 0;
1375             uint256 ind = 0;
1376             while (count < randomInt) {
1377                 uint256 newChanceCount =
1378                     loteryCount[lastEndedLoteryDay][ind].chanceCount;
1379                 if (count.add(newChanceCount) >= randomInt) break;
1380                 count = count.add(newChanceCount);
1381                 ind = ind.add(1);
1382             }
1383             uint256 amount = xfLobby[lastEndedLoteryDay].mul(25).div(1000);
1384             if (undestributedLotery > 0) {
1385                 amount = amount.add(undestributedLotery);
1386                 undestributedLotery = 0;
1387             }
1388             winners[lastEndedLoteryDay] = winLoteryStat(
1389                 address(uint160(loteryCount[lastEndedLoteryDay][ind].who)),
1390                 amount,
1391                 amount
1392             );
1393             lastEndedLoteryDayWithWinner = lastEndedLoteryDay;
1394             emit loteryWin(
1395                 lastEndedLoteryDay,
1396                 amount,
1397                 winners[lastEndedLoteryDay].who
1398             );
1399             //delete loteryCount[lastEndedLoteryDay];
1400             lastEndedLoteryDay = lastEndedLoteryDay.add(1);
1401         }
1402     }
1403 
1404     function loteryCountLen(uint256 day) external view returns (uint256) {
1405         return loteryCount[day].length;
1406     }
1407 
1408     function withdrawLotery(uint256 day) public {
1409         if (winners[day].restAmount != 0) {
1410             winners[day].who.transfer(winners[day].restAmount);
1411             winners[day].restAmount = 0;
1412         }
1413     }
1414 
1415     uint256 private nonce = 0;
1416 
1417     function _random(uint256 limit) private returns (uint256) {
1418         uint256 randomnumber =
1419             uint256(
1420                 keccak256(
1421                     abi.encodePacked(
1422                         now,
1423                         msg.sender,
1424                         nonce,
1425                         blockhash(block.number),
1426                         block.number,
1427                         block.coinbase,
1428                         block.difficulty
1429                     )
1430                 )
1431             ) % limit;
1432         nonce = nonce.add(1);
1433         return randomnumber;
1434     }
1435 
1436     function endedStakeCount(address stakerAddr)
1437         external
1438         view
1439         returns (uint256)
1440     {
1441         return endedStakeLists[stakerAddr].length;
1442     }
1443 
1444     /**
1445      * @dev PUBLIC FACING: Return the current stake count for a staker address
1446      * @param stakerAddr Address of staker
1447      */
1448     function stakeCount(address stakerAddr) external view returns (uint256) {
1449         return stakeLists[stakerAddr].length;
1450     }
1451 
1452     /**
1453      * @dev Open a stake.
1454      * @param g Cache of stored globals
1455      * @param newStakedSuns Number of Suns to stake
1456      * @param newStakedDays Number of days to stake
1457      */
1458     function _stakeStart(
1459         GlobalsCache memory g,
1460         uint256 newStakedSuns,
1461         uint256 newStakedDays
1462     ) internal {
1463         /* Enforce the maximum stake time */
1464         require(
1465             newStakedDays <= MAX_STAKE_DAYS,
1466             "JACKPOT: newStakedDays higher than maximum"
1467         );
1468         uint256 bonusSuns = _stakeStartBonusSuns(newStakedSuns, newStakedDays);
1469         uint256 newStakeShares = newStakedSuns.add(bonusSuns).mul(SHARE_RATE_SCALE).div(g._shareRate);
1470         /* Ensure newStakedSuns is enough for at least one stake share */
1471         require(
1472             newStakeShares != 0,
1473             "JACKPOT: newStakedSuns must be at least minimum shareRate"
1474         );
1475         /*
1476             The stakeStart timestamp will always be part-way through the current
1477             day, so it needs to be rounded-up to the next day to ensure all
1478             stakes align with the same fixed calendar days. The current day is
1479             already rounded-down, so rounded-up is current day + 1.
1480         */
1481         uint256 newLockedDay = g._currentDay.add(1);
1482         /* Create Stake */
1483         g._latestStakeId = uint40(uint256(g._latestStakeId).add(1));
1484         uint40 newStakeId = g._latestStakeId;
1485         _stakeAdd(
1486             stakeLists[msg.sender],
1487             newStakeId,
1488             newStakedSuns,
1489             newStakeShares,
1490             newLockedDay,
1491             newStakedDays
1492         );
1493         emit StakeStart(
1494             newStakeId,
1495             msg.sender,
1496             newStakedSuns,
1497             newStakeShares,
1498             newStakedDays
1499         );
1500         /* Stake is added to total in the next round, not the current round */
1501         g._nextStakeSharesTotal = g._nextStakeSharesTotal.add(newStakeShares);
1502         /* Track total staked Suns for inflation calculations */
1503         g._lockedSunsTotal = g._lockedSunsTotal.add(newStakedSuns);
1504     }
1505 
1506     /**
1507      * @dev Calculates total stake payout including rewards for a multi-day range
1508      * @param stakeSharesParam Param from stake to calculate bonuses for
1509      * @param beginDay First day to calculate bonuses for
1510      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1511      * @return Payout in Suns
1512      */
1513     function calcPayoutRewards(
1514         uint256 stakeSharesParam,
1515         uint256 beginDay,
1516         uint256 endDay
1517     ) public view returns (uint256 payout) {
1518         uint256 currDay = _currentDay();
1519         require(beginDay <= currDay, "JACKPOT: Wrong argument for beginDay");
1520         require(
1521             endDay <= currDay && beginDay <= endDay,
1522             "JACKPOT: Wrong argument for endDay"
1523         );
1524         require(globals.latestStakeId != 0, "JACKPOT: latestStakeId error.");
1525         if (beginDay == endDay) return 0;
1526         uint256 counter;
1527         uint256 day = beginDay;
1528         while (day < endDay && day < globals.dailyDataCount) {
1529             uint256 dayPayout;
1530             dayPayout =
1531                 dailyData[day].dayPayoutTotal.mul(stakeSharesParam).div(dailyData[day].dayStakeSharesTotal);
1532             if (counter < 4) {
1533                 counter = counter.add(1);
1534             }
1535             /* Eligible to receive bonus */
1536             else {
1537                 dayPayout =
1538                     dailyData[day].dayPayoutTotal.mul(stakeSharesParam).div(dailyData[day].dayStakeSharesTotal).mul(BONUS_DAY_SCALE);
1539                 counter = 0;
1540             }
1541             payout = payout.add(dayPayout);
1542             day = day.add(1);
1543         }
1544         uint256 dayStakeSharesTotal =
1545             dailyData[uint256(globals.dailyDataCount).sub(1)].dayStakeSharesTotal;
1546         if (dayStakeSharesTotal == 0) dayStakeSharesTotal = stakeSharesParam;
1547         //require(dayStakeSharesTotal != 0, "JACKPOT: dayStakeSharesTotal == 0");
1548         uint256 dayPayoutTotal =
1549             dailyData[uint256(globals.dailyDataCount).sub(1)].dayPayoutTotal;
1550         while (day < endDay) {
1551             uint256 dayPayout;
1552             dayPayout =
1553                 dayPayoutTotal.mul(stakeSharesParam).div(dayStakeSharesTotal);
1554             if (counter < 4) {
1555                 counter = counter.add(1);
1556             }
1557             // Eligible to receive bonus
1558             else {
1559                 dayPayout =
1560                     dayPayoutTotal.mul(stakeSharesParam).div(dayStakeSharesTotal).mul(BONUS_DAY_SCALE);
1561                 counter = 0;
1562             }
1563             payout = payout.add(dayPayout);
1564             day = day.add(1);
1565         }
1566         return payout;
1567     }
1568 
1569     function calcPayoutRewardsBonusDays(
1570         uint256 stakeSharesParam,
1571         uint256 beginDay,
1572         uint256 endDay
1573     ) external view returns (uint256 payout) {
1574         uint256 currDay = _currentDay();
1575         require(beginDay <= currDay, "JACKPOT: Wrong argument for beginDay");
1576         require(
1577             endDay <= currDay && beginDay <= endDay,
1578             "JACKPOT: Wrong argument for endDay"
1579         );
1580         require(globals.latestStakeId != 0, "JACKPOT: latestStakeId error.");
1581         if (beginDay == endDay) return 0;
1582         uint256 day = beginDay.add(5);
1583         while (day < endDay && day < globals.dailyDataCount) {
1584             payout = payout.add(dailyData[day].dayPayoutTotal.mul(stakeSharesParam).div(dailyData[day].dayStakeSharesTotal));
1585             day = day.add(5);
1586         }
1587         uint256 dayStakeSharesTotal =
1588             dailyData[uint256(globals.dailyDataCount).sub(1)].dayStakeSharesTotal;
1589         if (dayStakeSharesTotal == 0) dayStakeSharesTotal = stakeSharesParam;
1590         //require(dayStakeSharesTotal != 0, "JACKPOT: dayStakeSharesTotal == 0");
1591         uint256 dayPayoutTotal =
1592             dailyData[uint256(globals.dailyDataCount).sub(1)].dayPayoutTotal;
1593         while (day < endDay) {
1594             payout = payout.add(dayPayoutTotal.mul(stakeSharesParam).div(dayStakeSharesTotal));
1595             day = day.add(5);
1596         }
1597         return payout;
1598     }
1599 
1600     /**
1601      * @dev Calculates user dividends
1602      * @param stakeSharesParam Param from stake to calculate bonuses for
1603      * @param beginDay First day to calculate bonuses for
1604      * @param endDay Last day (non-inclusive) of range to calculate bonuses for
1605      * @return Payout in Suns
1606      */
1607     function calcPayoutDividendsReward(
1608         uint256 stakeSharesParam,
1609         uint256 beginDay,
1610         uint256 endDay
1611     ) public view returns (uint256 payout) {
1612         uint256 currDay = _currentDay();
1613         require(beginDay <= currDay, "JACKPOT: Wrong argument for beginDay");
1614         require(
1615             endDay <= currDay && beginDay <= endDay,
1616             "JACKPOT: Wrong argument for endDay"
1617         );
1618         require(globals.latestStakeId != 0, "JACKPOT: latestStakeId error.");
1619         if (beginDay == endDay) return 0;
1620         uint256 day = beginDay;
1621         while (day < endDay && day < globals.dailyDataCount) {
1622             uint256 dayPayout;
1623             /* user's share of 90% of the day's dividends */
1624             dayPayout = dayPayout.add(dailyData[day].dayDividends.mul(90).div(100).mul(stakeSharesParam).div(dailyData[day].dayStakeSharesTotal));
1625             payout = payout.add(dayPayout);
1626             day = day.add(1);
1627         }
1628         uint256 dayStakeSharesTotal =
1629             dailyData[uint256(globals.dailyDataCount).sub(1)].dayStakeSharesTotal;
1630         if (dayStakeSharesTotal == 0) dayStakeSharesTotal = stakeSharesParam;
1631         //require(dayStakeSharesTotal != 0, "JACKPOT: dayStakeSharesTotal == 0");
1632         while (day < endDay) {
1633             uint256 dayPayout;
1634             /* user's share of 90% of the day's dividends */
1635             dayPayout = dayPayout.add(xfLobby[day].mul(90).div(100).mul(stakeSharesParam).div(dayStakeSharesTotal));
1636             payout = payout.add(dayPayout);
1637             day = day.add(1);
1638         }
1639         return payout;
1640     }
1641 
1642     /**
1643      * @dev Calculate bonus Suns for a new stake, if any
1644      * @param newStakedSuns Number of Suns to stake
1645      * @param newStakedDays Number of days to stake
1646      */
1647     function _stakeStartBonusSuns(uint256 newStakedSuns, uint256 newStakedDays)
1648         private
1649         pure
1650         returns (uint256 bonusSuns)
1651     {
1652         /*
1653             LONGER PAYS BETTER:
1654             If longer than 1 day stake is committed to, each extra day
1655             gives bonus shares of approximately 0.0548%, which is approximately 20%
1656             extra per year of increased stake length committed to, but capped to a
1657             maximum of 200% extra.
1658             extraDays       =  stakedDays - 1
1659             longerBonus%    = (extraDays / 364) * 20%
1660                             = (extraDays / 364) / 5
1661                             =  extraDays / 1820
1662                             =  extraDays / LPB
1663             extraDays       =  longerBonus% * 1820
1664             extraDaysMax    =  longerBonusMax% * 1820
1665                             =  200% * 1820
1666                             =  3640
1667                             =  LPB_MAX_DAYS
1668             BIGGER PAYS BETTER:
1669             Bonus percentage scaled 0% to 10% for the first 7M JACKPOT of stake.
1670             biggerBonus%    = (cappedSuns /  BPB_MAX_SUNS) * 10%
1671                             = (cappedSuns /  BPB_MAX_SUNS) / 10
1672                             =  cappedSuns / (BPB_MAX_SUNS * 10)
1673                             =  cappedSuns /  BPB
1674             COMBINED:
1675             combinedBonus%  =            longerBonus%  +  biggerBonus%
1676                                       cappedExtraDays     cappedSuns
1677                             =         ---------------  +  ------------
1678                                             LPB               BPB
1679                                 cappedExtraDays * BPB     cappedSuns * LPB
1680                             =   ---------------------  +  ------------------
1681                                       LPB * BPB               LPB * BPB
1682                                 cappedExtraDays * BPB  +  cappedSuns * LPB
1683                             =   --------------------------------------------
1684                                                   LPB  *  BPB
1685             bonusSuns     = suns * combinedBonus%
1686                             = suns * (cappedExtraDays * BPB  +  cappedSuns * LPB) / (LPB * BPB)
1687         */
1688         uint256 cappedExtraDays = 0;
1689         /* Must be more than 1 day for Longer-Pays-Better */
1690         if (newStakedDays > 1) {
1691             cappedExtraDays = newStakedDays.sub(1) <= LPB_MAX_DAYS
1692                 ? newStakedDays.sub(1)
1693                 : LPB_MAX_DAYS;
1694         }
1695         uint256 cappedStakedSuns =
1696             newStakedSuns <= BPB_MAX_SUNS ? newStakedSuns : BPB_MAX_SUNS;
1697         bonusSuns = cappedExtraDays.mul(BPB).add(cappedStakedSuns.mul(LPB));
1698         bonusSuns = newStakedSuns.mul(bonusSuns).div(LPB.mul(BPB));
1699         return bonusSuns;
1700     }
1701 
1702     function _stakeUnlock(GlobalsCache memory g, StakeCache memory st)
1703         private
1704         pure
1705     {
1706         g._stakeSharesTotal = g._stakeSharesTotal.sub(st._stakeShares);
1707         st._unlockedDay = g._currentDay;
1708     }
1709 
1710     function _stakePerformance(
1711         GlobalsCache memory g,
1712         StakeCache memory st,
1713         uint256 servedDays
1714     )
1715         private
1716         view
1717         returns (
1718             uint256 stakeReturn,
1719             uint256 payout,
1720             uint256 dividends,
1721             uint256 penalty,
1722             uint256 cappedPenalty
1723         )
1724     {
1725         if (servedDays < st._stakedDays) {
1726             (payout, penalty) = _calcPayoutAndEarlyPenalty(
1727                 g,
1728                 st._lockedDay,
1729                 st._stakedDays,
1730                 servedDays,
1731                 st._stakeShares
1732             );
1733             stakeReturn = st._stakedSuns.add(payout);
1734             dividends = calcPayoutDividendsReward(
1735                 st._stakeShares,
1736                 st._lockedDay,
1737                 st._lockedDay.add(servedDays)
1738             );
1739         } else {
1740             // servedDays must == stakedDays here
1741             payout = calcPayoutRewards(
1742                 st._stakeShares,
1743                 st._lockedDay,
1744                 st._lockedDay.add(servedDays)
1745             );
1746             dividends = calcPayoutDividendsReward(
1747                 st._stakeShares,
1748                 st._lockedDay,
1749                 st._lockedDay.add(servedDays)
1750             );
1751             stakeReturn = st._stakedSuns.add(payout);
1752             penalty = _calcLatePenalty(
1753                 st._lockedDay,
1754                 st._stakedDays,
1755                 st._unlockedDay,
1756                 stakeReturn
1757             );
1758         }
1759         if (penalty != 0) {
1760             if (penalty > stakeReturn) {
1761                 /* Cannot have a negative stake return */
1762                 cappedPenalty = stakeReturn;
1763                 stakeReturn = 0;
1764             } else {
1765                 /* Remove penalty from the stake return */
1766                 cappedPenalty = penalty;
1767                 stakeReturn = stakeReturn.sub(cappedPenalty);
1768             }
1769         }
1770         return (stakeReturn, payout, dividends, penalty, cappedPenalty);
1771     }
1772 
1773     function getUnstakeParams(
1774         address user,
1775         uint256 stakeIndex,
1776         uint40 stakeIdParam
1777     )
1778         external
1779         view
1780         returns (
1781             uint256 stakeReturn,
1782             uint256 payout,
1783             uint256 dividends,
1784             uint256 penalty,
1785             uint256 cappedPenalty
1786         )
1787     {
1788         GlobalsCache memory g;
1789         GlobalsCache memory gSnapshot;
1790         _globalsLoad(g, gSnapshot);
1791         StakeStore[] storage stakeListRef = stakeLists[user];
1792         /* require() is more informative than the default assert() */
1793         require(stakeListRef.length != 0, "JACKPOT: Empty stake list");
1794         require(
1795             stakeIndex < stakeListRef.length,
1796             "JACKPOT: stakeIndex invalid"
1797         );
1798         /* Get stake copy */
1799         StakeCache memory st;
1800         _stakeLoad(stakeListRef[stakeIndex], stakeIdParam, st);
1801         uint256 servedDays = 0;
1802         bool prevUnlocked = (st._unlockedDay != 0);
1803         //return (stakeReturn, payout, dividends, penalty, cappedPenalty);
1804         if (g._currentDay >= st._lockedDay) {
1805             if (prevUnlocked) {
1806                 /* Previously unlocked in stakeGoodAccounting(), so must have served full term */
1807                 servedDays = st._stakedDays;
1808             } else {
1809                 _stakeUnlock(g, st);
1810                 servedDays = g._currentDay.sub(st._lockedDay);
1811                 if (servedDays > st._stakedDays) {
1812                     servedDays = st._stakedDays;
1813                 }
1814             }
1815             (
1816                 stakeReturn,
1817                 payout,
1818                 dividends,
1819                 penalty,
1820                 cappedPenalty
1821             ) = _stakePerformance(g, st, servedDays);
1822         } else {
1823             /* Stake hasn't been added to the total yet, so no penalties or rewards apply */
1824             stakeReturn = st._stakedSuns;
1825         }
1826         return (stakeReturn, payout, dividends, penalty, cappedPenalty);
1827     }
1828 
1829     function _calcPayoutAndEarlyPenalty(
1830         GlobalsCache memory g,
1831         uint256 lockedDayParam,
1832         uint256 stakedDaysParam,
1833         uint256 servedDays,
1834         uint256 stakeSharesParam
1835     ) private view returns (uint256 payout, uint256 penalty) {
1836         uint256 servedEndDay = lockedDayParam.add(servedDays);
1837         /* 50% of stakedDays (rounded up) with a minimum applied */
1838         uint256 penaltyDays = stakedDaysParam.add(1).div(2);
1839         if (penaltyDays < EARLY_PENALTY_MIN_DAYS) {
1840             penaltyDays = EARLY_PENALTY_MIN_DAYS;
1841         }
1842         if (servedDays == 0) {
1843             /* Fill penalty days with the estimated average payout */
1844             uint256 expected = _estimatePayoutRewardsDay(g, stakeSharesParam);
1845             penalty = expected.mul(penaltyDays);
1846             return (payout, penalty); // Actual payout was 0
1847         }
1848         if (penaltyDays < servedDays) {
1849             /*
1850                 Simplified explanation of intervals where end-day is non-inclusive:
1851                 penalty:    [lockedDay  ...  penaltyEndDay)
1852                 delta:                      [penaltyEndDay  ...  servedEndDay)
1853                 payout:     [lockedDay  .......................  servedEndDay)
1854             */
1855             uint256 penaltyEndDay = lockedDayParam.add(penaltyDays);
1856             penalty = calcPayoutRewards(
1857                 stakeSharesParam,
1858                 lockedDayParam,
1859                 penaltyEndDay
1860             );
1861             uint256 delta =
1862                 calcPayoutRewards(
1863                     stakeSharesParam,
1864                     penaltyEndDay,
1865                     servedEndDay
1866                 );
1867             payout = penalty.add(delta);
1868             return (payout, penalty);
1869         }
1870         /* penaltyDays >= servedDays  */
1871         payout = calcPayoutRewards(
1872             stakeSharesParam,
1873             lockedDayParam,
1874             servedEndDay
1875         );
1876         if (penaltyDays == servedDays) {
1877             penalty = payout;
1878         } else {
1879             /*
1880                 (penaltyDays > servedDays) means not enough days served, so fill the
1881                 penalty days with the average payout from only the days that were served.
1882             */
1883             penalty = payout.mul(penaltyDays).div(servedDays);
1884         }
1885         return (payout, penalty);
1886     }
1887 
1888     function _calcLatePenalty(
1889         uint256 lockedDayParam,
1890         uint256 stakedDaysParam,
1891         uint256 unlockedDayParam,
1892         uint256 rawStakeReturn
1893     ) private pure returns (uint256) {
1894         /* Allow grace time before penalties accrue */
1895         uint256 maxUnlockedDay =
1896             lockedDayParam.add(stakedDaysParam).add(LATE_PENALTY_GRACE_DAYS);
1897         if (unlockedDayParam <= maxUnlockedDay) {
1898             return 0;
1899         }
1900         /* Calculate penalty as a percentage of stake return based on time */
1901         return rawStakeReturn.mul(unlockedDayParam.sub(maxUnlockedDay)).div(LATE_PENALTY_SCALE_DAYS);
1902     }
1903 
1904     function _shareRateUpdate(
1905         GlobalsCache memory g,
1906         StakeCache memory st,
1907         uint256 stakeReturn
1908     ) private {
1909         if (stakeReturn > st._stakedSuns) {
1910             /*
1911                 Calculate the new shareRate that would yield the same number of shares if
1912                 the user re-staked this stakeReturn, factoring in any bonuses they would
1913                 receive in stakeStart().
1914             */
1915             uint256 bonusSuns =
1916                 _stakeStartBonusSuns(stakeReturn, st._stakedDays);
1917             uint256 newShareRate =
1918                 stakeReturn.add(bonusSuns).mul(SHARE_RATE_SCALE).div(st._stakeShares);
1919             if (newShareRate > SHARE_RATE_MAX) {
1920                 /*
1921                     Realistically this can't happen, but there are contrived theoretical
1922                     scenarios that can lead to extreme values of newShareRate, so it is
1923                     capped to prevent them anyway.
1924                 */
1925                 newShareRate = SHARE_RATE_MAX;
1926             }
1927             if (newShareRate > g._shareRate) {
1928                 g._shareRate = newShareRate;
1929                 emit ShareRateChange(
1930                     st._stakeId,
1931                     block.timestamp,
1932                     newShareRate
1933                 );
1934             }
1935         }
1936     }
1937 }
1938 
1939 contract TransformableToken is StakeableToken {
1940     /**
1941      * @dev PUBLIC FACING: Enter the auction lobby for the current round
1942      * @param referrerAddr TRX address of referring user (optional; 0x0 for no referrer)
1943      */
1944     function xfLobbyEnter(address referrerAddr) external payable {
1945         require(now >= LAUNCH_TIME, "JACKPOT: Too early");
1946         uint256 enterDay = _currentDay();
1947         require(enterDay < 365, "JACKPOT: Auction only first 365 days");
1948         if (firstAuction == uint256(-1)) firstAuction = enterDay;
1949         if (enterDay >= 1) endLoteryDay(enterDay.sub(1));
1950         uint256 rawAmount = msg.value;
1951         require(rawAmount != 0, "JACKPOT: Amount required");
1952         address sender = _msgSender();
1953         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][sender];
1954         uint256 entryIndex = qRef.tailIndex++;
1955         qRef.entries[entryIndex] = XfLobbyEntryStore(
1956             uint96(rawAmount),
1957             referrerAddr
1958         );
1959         xfLobby[enterDay] = xfLobby[enterDay].add(rawAmount);
1960         uint256 dayNumberNow = whatDayIsItToday(enterDay);
1961         //uint256 dayNumberNow = 1;
1962         bool is_good = block.timestamp.sub(LAUNCH_TIME) % ROUND_TIME <= LOTERY_ENTRY_TIME;
1963         /* if (is_good)
1964         {
1965             is_good = false;
1966             uint256 len = stakeLists[sender].length;
1967             for(uint256 i = 0; i < len && is_good == false; ++i)
1968             {
1969                 uint256 _stakedDays = stakeLists[sender][i].stakedDays;
1970                 uint256 _lockedDay = stakeLists[sender][i].lockedDay;
1971                 if (_stakedDays >= 5 &&
1972                     _lockedDay + _stakedDays >= enterDay)
1973                     is_good = true;
1974             }
1975         } */
1976         if (
1977             is_good &&
1978             dayNumberNow % 2 == 1 &&
1979             loteryLobby[enterDay][sender].chanceCount == 0
1980         ) {
1981             loteryLobby[enterDay][sender].change = 0;
1982             loteryLobby[enterDay][sender].chanceCount = 1;
1983             dayChanceCount[enterDay] = dayChanceCount[enterDay].add(1);
1984             loteryCount[enterDay].push(LoteryCount(sender, 1));
1985 
1986             _updateLoteryDayWaitingForWinner(enterDay);
1987 
1988             //loteryDayWaitingForWinner = enterDay;
1989             emit loteryLobbyEnter(block.timestamp, enterDay, rawAmount);
1990         } else if (is_good && dayNumberNow % 2 == 0) {
1991             LoteryStore storage lb = loteryLobby[enterDay][sender];
1992             uint256 oldChange = lb.change;
1993             lb.change = oldChange.add(rawAmount) % 1 ether;
1994             uint256 newEth = oldChange.add(rawAmount).div(1 ether);
1995             if (newEth > 0) {
1996                 lb.chanceCount = lb.chanceCount.add(newEth);
1997                 dayChanceCount[enterDay] = dayChanceCount[enterDay].add(newEth);
1998                 loteryCount[enterDay].push(LoteryCount(sender, newEth));
1999 
2000                 _updateLoteryDayWaitingForWinner(enterDay);
2001 
2002                 //loteryDayWaitingForWinner = enterDay;
2003                 emit loteryLobbyEnter(block.timestamp, enterDay, rawAmount);
2004             }
2005         }
2006         emit XfLobbyEnter(block.timestamp, enterDay, entryIndex, rawAmount);
2007     }
2008 
2009     function _updateLoteryDayWaitingForWinner(uint256 enterDay) private {
2010         if (dayChanceCount[loteryDayWaitingForWinner] == 0) {
2011             loteryDayWaitingForWinner = enterDay;
2012             loteryDayWaitingForWinnerNew = enterDay;
2013         } else if (loteryDayWaitingForWinnerNew < enterDay) {
2014             loteryDayWaitingForWinner = loteryDayWaitingForWinnerNew;
2015             loteryDayWaitingForWinnerNew = enterDay;
2016         }
2017     }
2018 
2019     function whatDayIsItToday(uint256 day) public view returns (uint256) {
2020         return dayNumberBegin.add(day) % 7;
2021     }
2022 
2023     /**
2024      * @dev PUBLIC FACING: Leave the transform lobby after the round is complete
2025      * @param enterDay Day number when the member entered
2026      * @param count Number of queued-enters to exit (optional; 0 for all)
2027      */
2028     function xfLobbyExit(uint256 enterDay, uint256 count) external {
2029         uint256 currDay = _currentDay();
2030         require(enterDay < currDay, "JACKPOT: Round is not complete");
2031         if (currDay >= 1) endLoteryDay(currDay.sub(1));
2032         XfLobbyQueueStore storage qRef = xfLobbyMembers[enterDay][msg.sender];
2033         uint256 headIndex = qRef.headIndex;
2034         uint256 endIndex;
2035         if (count != 0) {
2036             require(
2037                 count <= uint256(qRef.tailIndex).sub(headIndex),
2038                 "JACKPOT: count invalid"
2039             );
2040             endIndex = headIndex.add(count);
2041         } else {
2042             endIndex = qRef.tailIndex;
2043             require(headIndex < endIndex, "JACKPOT: count invalid");
2044         }
2045         uint256 waasLobby = waasLobby(enterDay);
2046         uint256 _xfLobby = xfLobby[enterDay];
2047         uint256 totalXfAmount = 0;
2048         do {
2049             uint256 rawAmount = qRef.entries[headIndex].rawAmount;
2050             address referrerAddr = qRef.entries[headIndex].referrerAddr;
2051             //delete qRef.entries[headIndex];
2052             uint256 xfAmount = waasLobby.mul(rawAmount).div(_xfLobby);
2053             if (
2054                 (referrerAddr == address(0) || referrerAddr == msg.sender) &&
2055                 defaultReferrerAddr == address(0)
2056             ) {
2057                 /* No referrer or Self-referred */
2058                 _emitXfLobbyExit(enterDay, headIndex, xfAmount, referrerAddr);
2059             } else {
2060                 if (referrerAddr == address(0) || referrerAddr == msg.sender) {
2061                     uint256 referrerBonusSuns = xfAmount.div(10);
2062                     _emitXfLobbyExit(
2063                         enterDay,
2064                         headIndex,
2065                         xfAmount,
2066                         defaultReferrerAddr
2067                     );
2068                     _mint(defaultReferrerAddr, referrerBonusSuns);
2069                     fromReferrs[defaultReferrerAddr] = fromReferrs[defaultReferrerAddr].add(referrerBonusSuns);
2070                 } else {
2071                     /* Referral bonus of 10% of xfAmount to member */
2072                     xfAmount = xfAmount.add(xfAmount.div(10));
2073                     /* Then a cumulative referrer bonus of 10% to referrer */
2074                     uint256 referrerBonusSuns = xfAmount.div(10);
2075                     _emitXfLobbyExit(
2076                         enterDay,
2077                         headIndex,
2078                         xfAmount,
2079                         referrerAddr
2080                     );
2081                     _mint(referrerAddr, referrerBonusSuns);
2082                     fromReferrs[referrerAddr] = fromReferrs[referrerAddr].add(referrerBonusSuns);
2083                 }
2084             }
2085             totalXfAmount = totalXfAmount.add(xfAmount);
2086         } while (++headIndex < endIndex);
2087         qRef.headIndex = uint40(headIndex);
2088         if (totalXfAmount != 0) {
2089             _mint(_msgSender(), totalXfAmount);
2090             jackpotReceivedAuction[enterDay][_msgSender()] = jackpotReceivedAuction[enterDay][_msgSender()].add(totalXfAmount);
2091         }
2092     }
2093 
2094     /**
2095      * @dev PUBLIC FACING: External helper to return multiple values of xfLobby[] with
2096      * a single call
2097      * @param beginDay First day of data range
2098      * @param endDay Last day (non-inclusive) of data range
2099      * @return Fixed array of values
2100      */
2101     /* function xfLobbyRange(uint256 beginDay, uint256 endDay)
2102         external
2103         view
2104         returns (uint256[] memory list)
2105     {
2106         require(
2107             beginDay < endDay && endDay <= _currentDay(),
2108             "JACKPOT: invalid range"
2109         );
2110         list = new uint256[](endDay - beginDay);
2111         uint256 src = beginDay;
2112         uint256 dst = 0;
2113         do {
2114             list[dst++] = uint256(xfLobby[src++]);
2115         } while (src < endDay);
2116         return list;
2117     } */
2118     /**
2119      * @dev PUBLIC FACING: Release 7.5% dev share from daily dividends
2120      */
2121     function xfFlush() external onlyOwner {
2122         if (LAST_FLUSHED_DAY < firstAuction.add(2))
2123             LAST_FLUSHED_DAY = firstAuction.add(2);
2124         require(address(this).balance != 0, "JACKPOT: No value");
2125         require(LAST_FLUSHED_DAY < _currentDay(), "JACKPOT: Invalid day");
2126         while (LAST_FLUSHED_DAY < _currentDay()) {
2127             flushAddr.transfer(xfLobby[LAST_FLUSHED_DAY].mul(75).div(1000));
2128             LAST_FLUSHED_DAY = LAST_FLUSHED_DAY.add(1);
2129         }
2130     }
2131 
2132     /**
2133      * @dev PUBLIC FACING: Return a current lobby member queue entry.
2134      * Only needed due to limitations of the standard ABI encoder.
2135      * @param memberAddr TRX address of the lobby member
2136      * @param enterDay asdsadsa
2137      * @param entryIndex asdsadad
2138      * @return 1: Raw amount that was entered with; 2: Referring TRX addr (optional; 0x0 for no referrer)
2139      */
2140     function xfLobbyEntry(
2141         address memberAddr,
2142         uint256 enterDay,
2143         uint256 entryIndex
2144     ) external view returns (uint256 rawAmount, address referrerAddr) {
2145         XfLobbyEntryStore storage entry =
2146             xfLobbyMembers[enterDay][memberAddr].entries[entryIndex];
2147         require(entry.rawAmount != 0, "JACKPOT: Param invalid");
2148         return (entry.rawAmount, entry.referrerAddr);
2149     }
2150 
2151     function waasLobby(uint256 enterDay)
2152         public
2153         pure
2154         returns (uint256 _waasLobby)
2155     {
2156         /* 410958904109 = ~ 1500000 * SUNS_PER_JACKPOT / 365 */
2157         if (enterDay >= 0 && enterDay <= 365) {
2158             _waasLobby = CLAIM_STARTING_AMOUNT.sub(enterDay.mul(410958904109));
2159         } else {
2160             _waasLobby = CLAIM_LOWEST_AMOUNT;
2161         }
2162         return _waasLobby;
2163     }
2164 
2165     function _emitXfLobbyExit(
2166         uint256 enterDay,
2167         uint256 entryIndex,
2168         uint256 xfAmount,
2169         address referrerAddr
2170     ) private {
2171         emit XfLobbyExit(
2172             block.timestamp,
2173             enterDay,
2174             entryIndex,
2175             xfAmount,
2176             referrerAddr
2177         );
2178     }
2179 }
2180 
2181 contract Jackpot is TransformableToken {
2182     constructor(
2183         uint256 _LAUNCH_TIME,
2184         uint256 _dayNumberBegin,
2185         uint256 _ROUND_TIME,
2186         uint256 _LOTERY_ENTRY_TIME
2187     ) public {
2188         require(_dayNumberBegin > 0 && _dayNumberBegin < 7);
2189         LAUNCH_TIME = _LAUNCH_TIME;
2190         dayNumberBegin = _dayNumberBegin;
2191         ROUND_TIME = _ROUND_TIME;
2192         LOTERY_ENTRY_TIME = _LOTERY_ENTRY_TIME;
2193         /* Initialize global shareRate to 1 */
2194         globals.shareRate = uint40(SHARE_RATE_SCALE);
2195         uint256 currDay;
2196         if (block.timestamp < _LAUNCH_TIME)
2197             currDay = 0;
2198         else
2199             currDay = _currentDay();
2200         lastEndedLoteryDay = currDay;
2201         globals.dailyDataCount = uint16(currDay);
2202         lastEndedLoteryDayWithWinner = currDay;
2203         loteryDayWaitingForWinner = currDay;
2204         loteryDayWaitingForWinnerNew = currDay;
2205         defaultReferrerAddr = address(0xe40246B91A65a569eFd3ECa2beC3FB8E12Ab8DA2);
2206         flushAddr = address(0x8b52956cd6140Cdd36Cb4113cd8a043Eea1d28af);
2207         transferOwnership(address(0x8b52956cd6140Cdd36Cb4113cd8a043Eea1d28af));
2208         transfer(address(0x8b52956cd6140Cdd36Cb4113cd8a043Eea1d28af), totalSupply());
2209     }
2210 
2211     function() external payable {}
2212 
2213     function setDefaultReferrerAddr(address _defaultReferrerAddr)
2214         external
2215         onlyOwner
2216     {
2217         defaultReferrerAddr = _defaultReferrerAddr;
2218     }
2219 
2220     function setFlushAddr(address payable _flushAddr) external onlyOwner {
2221         flushAddr = _flushAddr;
2222     }
2223 
2224     function getDayUnixTime(uint256 day) external view returns (uint256) {
2225         return LAUNCH_TIME.add(day.mul(ROUND_TIME));
2226     }
2227 
2228     function getFirstAuction() external view returns (bool, uint256) {
2229         if (firstAuction == uint256(-1)) return (false, 0);
2230         else return (true, firstAuction);
2231     }
2232 
2233     bool private isFirstTwoDaysWithdrawed = false;
2234 
2235     function ownerClaimFirstTwoDays() external onlyOwner onlyAfterNDays(2) {
2236         require(
2237             isFirstTwoDaysWithdrawed == false,
2238             "JACKPOT: Already withdrawed"
2239         );
2240 
2241         flushAddr.transfer(xfLobby[firstAuction].add(xfLobby[firstAuction.add(1)]));
2242 
2243         isFirstTwoDaysWithdrawed = true;
2244     }
2245 }