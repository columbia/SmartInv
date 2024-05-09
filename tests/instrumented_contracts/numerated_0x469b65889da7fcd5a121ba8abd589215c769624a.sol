1 pragma solidity ^0.6.6;
2 
3 
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // SPDX-License-Identifier: MIT
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      *
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      *
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `*` operator.
95      *
96      * Requirements:
97      *
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b > 0, errorMessage);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return mod(a, b, "SafeMath: modulo by zero");
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts with custom message when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b != 0, errorMessage);
180         return a % b;
181     }
182 }
183 
184 
185 /**
186  * @dev Interface of the ERC20 standard as defined in the EIP.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through {transferFrom}. This is
211      * zero by default.
212      *
213      * This value changes when {approve} or {transferFrom} are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * IMPORTANT: Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20PresetMinterPauser}.
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
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) private _balances;
287 
288     mapping (address => mapping (address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     string private _name;
293     string private _symbol;
294     uint8 private _decimals;
295 
296     /**
297      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
298      * a default value of 18.
299      *
300      * To select a different value for {decimals}, use {_setupDecimals}.
301      *
302      * All three of these values are immutable: they can only be set once during
303      * construction.
304      */
305     constructor (string memory name_, string memory symbol_) public {
306         _name = name_;
307         _symbol = symbol_;
308         _decimals = 18;
309     }
310 
311     /**
312      * @dev Returns the name of the token.
313      */
314     function name() public view returns (string memory) {
315         return _name;
316     }
317 
318     /**
319      * @dev Returns the symbol of the token, usually a shorter version of the
320      * name.
321      */
322     function symbol() public view returns (string memory) {
323         return _symbol;
324     }
325 
326     /**
327      * @dev Returns the number of decimals used to get its user representation.
328      * For example, if `decimals` equals `2`, a balance of `505` tokens should
329      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
330      *
331      * Tokens usually opt for a value of 18, imitating the relationship between
332      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
333      * called.
334      *
335      * NOTE: This information is only used for _display_ purposes: it in
336      * no way affects any of the arithmetic of the contract, including
337      * {IERC20-balanceOf} and {IERC20-transfer}.
338      */
339     function decimals() public view returns (uint8) {
340         return _decimals;
341     }
342 
343     /**
344      * @dev See {IERC20-totalSupply}.
345      */
346     function totalSupply() public view override returns (uint256) {
347         return _totalSupply;
348     }
349 
350     /**
351      * @dev See {IERC20-balanceOf}.
352      */
353     function balanceOf(address account) public view override returns (uint256) {
354         return _balances[account];
355     }
356 
357     /**
358      * @dev See {IERC20-transfer}.
359      *
360      * Requirements:
361      *
362      * - `recipient` cannot be the zero address.
363      * - the caller must have a balance of at least `amount`.
364      */
365     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
366         _transfer(_msgSender(), recipient, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-allowance}.
372      */
373     function allowance(address owner, address spender) public view virtual override returns (uint256) {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public virtual override returns (bool) {
385         _approve(_msgSender(), spender, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-transferFrom}.
391      *
392      * Emits an {Approval} event indicating the updated allowance. This is not
393      * required by the EIP. See the note at the beginning of {ERC20}.
394      *
395      * Requirements:
396      *
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for ``sender``'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
441         return true;
442     }
443 
444     /**
445      * @dev Moves tokens `amount` from `sender` to `recipient`.
446      *
447      * This is internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
465         _balances[recipient] = _balances[recipient].add(amount);
466         emit Transfer(sender, recipient, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `to` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply = _totalSupply.add(amount);
484         _balances[account] = _balances[account].add(amount);
485         emit Transfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498      */
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
505         _totalSupply = _totalSupply.sub(amount);
506         emit Transfer(account, address(0), amount);
507     }
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
511      *
512      * This internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(address owner, address spender, uint256 amount) internal virtual {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     /**
531      * @dev Sets {decimals} to a value other than the default one of 18.
532      *
533      * WARNING: This function should only be called from the constructor. Most
534      * applications that interact with token contracts will not expect
535      * {decimals} to ever change, and may work incorrectly if it does.
536      */
537     function _setupDecimals(uint8 decimals_) internal {
538         _decimals = decimals_;
539     }
540 
541     /**
542      * @dev Hook that is called before any transfer of tokens. This includes
543      * minting and burning.
544      *
545      * Calling conditions:
546      *
547      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
548      * will be to transferred to `to`.
549      * - when `from` is zero, `amount` tokens will be minted for `to`.
550      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
551      * - `from` and `to` are never both zero.
552      *
553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
554      */
555     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
556 }
557 contract BIOPToken is ERC20 {
558     using SafeMath for uint256;
559     address public binaryOptions = 0x0000000000000000000000000000000000000000;
560     address public gov;
561     address public owner;
562     uint256 public earlyClaimsAvailable = 450000000000000000000000000000;
563     uint256 public totalClaimsAvailable = 300000000000000000000000000000;
564     bool public earlyClaims = true;
565     bool public binaryOptionsSet = false;
566 
567     constructor(string memory name_, string memory symbol_) public ERC20(name_, symbol_) {
568       owner = msg.sender;
569     }
570     
571     modifier onlyBinaryOptions() {
572         require(binaryOptions == msg.sender, "Ownable: caller is not the Binary Options Contract");
573         _;
574     }
575     modifier onlyOwner() {
576         require(binaryOptions == msg.sender, "Ownable: caller is not the owner");
577         _;
578     }
579 
580     function updateEarlyClaim(uint256 amount) external onlyBinaryOptions {
581         require(totalClaimsAvailable.sub(amount) >= 0, "insufficent claims available");
582         require (earlyClaims, "Launch has closed");
583         
584         earlyClaimsAvailable = earlyClaimsAvailable.sub(amount);
585         _mint(tx.origin, amount);
586         if (earlyClaimsAvailable <= 0) {
587             earlyClaims = false;
588         }
589     }
590 
591      function updateClaim( uint256 amount) external onlyBinaryOptions {
592         require(totalClaimsAvailable.sub(amount) >= 0, "insufficent claims available");
593         totalClaimsAvailable.sub(amount);
594         _mint(tx.origin, amount);
595     }
596 
597     function setupBinaryOptions(address payable options_) external {
598         require(binaryOptionsSet != true, "binary options is already set");
599         binaryOptions = options_;
600     }
601 
602     function setupGovernance(address payable gov_) external onlyOwner {
603         _mint(owner, 100000000000000000000000000000);
604         _mint(gov_, 450000000000000000000000000000);
605         owner = 0x0000000000000000000000000000000000000000;
606     }
607 }
608 
609 interface AggregatorV3Interface {
610 
611   function decimals() external view returns (uint8);
612   function description() external view returns (string memory);
613   function version() external view returns (uint256);
614 
615   // getRoundData and latestRoundData should both raise "No data present"
616   // if they do not have data to report, instead of returning unset values
617   // which could be misinterpreted as actual reported values.
618   function getRoundData(uint80 _roundId)
619     external
620     view
621     returns (
622       uint80 roundId,
623       int256 answer,
624       uint256 startedAt,
625       uint256 updatedAt,
626       uint80 answeredInRound
627     );
628   function latestRoundData()
629     external
630     view
631     returns (
632       uint80 roundId,
633       int256 answer,
634       uint256 startedAt,
635       uint256 updatedAt,
636       uint80 answeredInRound
637     );
638 
639 }
640 
641 
642 
643 interface IRC {
644     /**
645      * @notice Returns the rate to pay out for a given amount
646      * @param amount the bet amount to calc a payout for
647      * @param maxAvailable the total pooled ETH unlocked and available to bet
648      * @return profit total possible profit amount
649      */
650     function rate(uint256 amount, uint256 maxAvailable) external view returns (uint256);
651 
652 }
653 
654 contract RateCalc is IRC {
655     using SafeMath for uint256;
656      /**
657      * @notice Calculates maximum option buyer profit
658      * @param amount Option amount
659      * @return profit total possible profit amount
660      */
661     function rate(uint256 amount, uint256 maxAvailable) external view override returns (uint256)  {
662         require(amount <= maxAvailable, "greater then pool funds available");
663         uint256 oneTenth = amount.div(10);
664         uint256 halfMax = maxAvailable.div(2);
665         if (amount > halfMax) {
666             return amount.mul(2).add(oneTenth).add(oneTenth);
667         } else {
668             if(oneTenth > 0) {
669                 return amount.mul(2).sub(oneTenth);
670             } else {
671                 uint256 oneThird = amount.div(4);
672                 require(oneThird > 0, "invalid bet amount");
673                 return amount.mul(2).sub(oneThird);
674             }
675         }
676         
677     }
678 }
679 
680 
681 
682 /**
683  * @title Binary Options Eth Pool
684  * @author github.com/Shalquiana
685  * @dev Pool ETH Tokens and use it for optionss
686  * Biop
687  */
688 contract BinaryOptions is ERC20 {
689     using SafeMath for uint256;
690     address payable devFund;
691     address payable owner;
692     address public biop;
693     address public rcAddress;//address of current rate calculators
694     mapping(address=>uint256) public nextWithdraw;
695     mapping(address=>bool) public enabledPairs;
696     uint256 public minTime;
697     uint256 public maxTime;
698     address public defaultPair;
699     uint256 public lockedAmount;
700     uint256 public exerciserFee = 50;//in tenth percent
701     uint256 public expirerFee = 50;//in tenth percent
702     uint256 public devFundBetFee = 2;//tenth of percent
703     uint256 public poolLockSeconds = 2 days;
704     uint256 public contractCreated;
705     uint256 public launchEnd;
706     bool public open = true;
707     Option[] public options;
708     
709     //reward amounts
710     uint256 aStakeReward = 120000000000000000000;
711     uint256 bStakeReward = 60000000000000000000;
712     uint256 betReward = 40000000000000000000;
713     uint256 exerciseReward = 2000000000000000000;
714 
715 
716     modifier onlyOwner() {
717         require(owner == msg.sender, "Ownable: caller is not the owner");
718         _;
719     }
720 
721 
722     /* Types */
723     enum OptionType {Put, Call}
724     enum State {Active, Exercised, Expired}
725     struct Option {
726         State state;
727         address payable holder;
728         uint256 strikePrice;
729         uint256 purchaseValue;
730         uint256 lockedValue;//purchaseAmount+possible reward for correct bet
731         uint256 expiration;
732         OptionType optionType;
733         address priceProvider;
734     }
735 
736     /* Events */
737      event Create(
738         uint256 indexed id,
739         address payable account,
740         uint256 strikePrice,
741         uint256 lockedValue,
742         OptionType direction
743     );
744     event Payout(uint256 poolLost, address winner);
745     event Exercise(uint256 indexed id);
746     event Expire(uint256 indexed id);
747 
748 
749     function getMaxAvailable() public view returns(uint256) {
750         uint256 balance = address(this).balance;
751         if (balance > lockedAmount) {
752             return balance.sub(lockedAmount);
753         } else {
754             return 0;
755         }
756     }
757 
758     constructor(string memory name_, string memory symbol_, address pp_, address biop_, address rateCalc_) public ERC20(name_, symbol_){
759         devFund = msg.sender;
760         owner = msg.sender;
761         biop = biop_;
762         rcAddress = rateCalc_;
763         lockedAmount = 0;
764         contractCreated = block.timestamp;
765         launchEnd = block.timestamp+28 days;
766         enabledPairs[pp_] = true; //default pair ETH/USD
767         defaultPair = pp_;
768         minTime = 900;//15 minutes
769         maxTime = 60 minutes;
770     }
771 
772     /**
773      * @dev the default price provider. This is a convenience method
774      */
775     function defaultPriceProvider() public view returns (address) {
776         return defaultPair;
777     }
778 
779 
780      /**
781      * @dev add a price provider to the enabledPairs list
782      * @param newRC_ the address of the AggregatorV3Interface price provider contract address to add.
783      */
784     function setRateCalcAddress(address newRC_) external onlyOwner {
785         rcAddress = newRC_; 
786     }
787 
788     /**
789      * @dev add a price provider to the enabledPairs list
790      * @param newPP_ the address of the AggregatorV3Interface price provider contract address to add.
791      */
792     function addPP(address newPP_) external onlyOwner {
793         enabledPairs[newPP_] = true; 
794     }
795 
796    
797 
798     /**
799      * @dev remove a price provider from the enabledPairs list
800      * @param oldPP_ the address of the AggregatorV3Interface price provider contract address to remove.
801      */
802     function removePP(address oldPP_) external onlyOwner {
803         enabledPairs[oldPP_] = false;
804     }
805 
806     /**
807      * @dev update the max time for option bets
808      * @param newMax_ the new maximum time (in seconds) an option may be created for (inclusive).
809      */
810     function setMaxTime(uint256 newMax_) external onlyOwner {
811         maxTime = newMax_;
812     }
813 
814     /**
815      * @dev update the max time for option bets
816      * @param newMin_ the new minimum time (in seconds) an option may be created for (inclusive).
817      */
818     function setMinTime(uint256 newMin_) external onlyOwner {
819         minTime = newMin_;
820     }
821 
822     /**
823      * @dev address of this contract, convenience method
824      */
825     function thisAddress() public view returns (address){
826         return address(this);
827     }
828 
829     /**
830      * @dev set the fee users can recieve for exercising other users options
831      * @param exerciserFee_ the new fee (in tenth percent) for exercising a options itm
832      */
833     function updateExerciserFee(uint256 exerciserFee_) external onlyOwner {
834         require(exerciserFee_ > 1 && exerciserFee_ < 500, "invalid fee");
835         exerciserFee = exerciserFee_;
836     }
837 
838      /**
839      * @dev set the fee users can recieve for expiring other users options
840      * @param expirerFee_ the new fee (in tenth percent) for expiring a options
841      */
842     function updateExpirerFee(uint256 expirerFee_) external onlyOwner {
843         require(expirerFee_ > 1 && expirerFee_ < 50, "invalid fee");
844         expirerFee = expirerFee_;
845     }
846 
847     /**
848      * @dev set the fee users pay to buy an option
849      * @param devFundBetFee_ the new fee (in tenth percent) to buy an option
850      */
851     function updateDevFundBetFee(uint256 devFundBetFee_) external onlyOwner {
852         require(devFundBetFee_ >= 0 && devFundBetFee_ < 50, "invalid fee");
853         devFundBetFee = devFundBetFee_;
854     }
855 
856      /**
857      * @dev update the pool stake lock up time.
858      * @param newLockSeconds_ the new lock time, in seconds
859      */
860     function updatePoolLockSeconds(uint256 newLockSeconds_) external onlyOwner {
861         require(newLockSeconds_ >= 0 && newLockSeconds_ < 14 days, "invalid fee");
862         poolLockSeconds = newLockSeconds_;
863     }
864 
865     /**
866      * @dev used to transfer ownership
867      * @param newOwner_ the address of governance contract which takes over control
868      */
869     function transferOwner(address payable newOwner_) external onlyOwner {
870         owner = newOwner_;
871     }
872     
873     /**
874      * @dev used to transfer devfund 
875      * @param newDevFund the address of governance contract which takes over control
876      */
877     function transferDevFund(address payable newDevFund) external onlyOwner {
878         devFund = newDevFund;
879     }
880 
881 
882      /**
883      * @dev used to send this pool into EOL mode when a newer one is open
884      */
885     function closeStaking() external onlyOwner {
886         open = false;
887     }
888 
889     /**
890      * @dev update the amount of early user governance tokens that have been assigned
891      * @param amount the amount assigned
892      */
893     function updateRewards(uint256 amount) internal {
894         BIOPToken b = BIOPToken(biop);
895         if (b.earlyClaims()) {
896             b.updateEarlyClaim(amount.mul(4));
897         } else if (b.totalClaimsAvailable() > 0){
898             b.updateClaim(amount);
899         }
900     }
901 
902 
903     /**
904      * @dev send ETH to the pool. Recieve pETH token representing your claim.
905      * If rewards are available recieve BIOP governance tokens as well.
906     */
907     function stake() external payable {
908         require(open == true, "pool deposits has closed");
909         require(msg.value >= 100, "stake to small");
910         if (block.timestamp < launchEnd) {
911             nextWithdraw[msg.sender] = block.timestamp + 14 days;
912             _mint(msg.sender, msg.value);
913         } else {
914             nextWithdraw[msg.sender] = block.timestamp + poolLockSeconds;
915             _mint(msg.sender, msg.value);
916         }
917 
918         if (msg.value >= 2000000000000000000) {
919             updateRewards(aStakeReward);
920         } else {
921             updateRewards(bStakeReward);
922         }
923     }
924 
925     /**
926      * @dev recieve ETH from the pool. 
927      * If the current time is before your next available withdraw a 1% fee will be applied.
928      * @param amount The amount of pETH to send the pool.
929     */
930     function withdraw(uint256 amount) public {
931        require (balanceOf(msg.sender) >= amount, "Insufficent Share Balance");
932 
933         uint256 valueToRecieve = amount.mul(address(this).balance).div(totalSupply());
934         _burn(msg.sender, amount);
935         if (block.timestamp <= nextWithdraw[msg.sender]) {
936             //early withdraw fee
937             uint256 penalty = valueToRecieve.div(100);
938             require(devFund.send(penalty), "transfer failed");
939             require(msg.sender.send(valueToRecieve.sub(penalty)), "transfer failed");
940         } else {
941             require(msg.sender.send(valueToRecieve), "transfer failed");
942         }
943     }
944 
945      /**
946     @dev Open a new call or put options.
947     @param type_ type of option to buy
948     @param pp_ the address of the price provider to use (must be in the list of enabledPairs)
949     @param time_ the time until your options expiration (must be minTime < time_ > maxTime)
950     */
951     function bet(OptionType type_, address pp_, uint256 time_) external payable {
952         require(
953             type_ == OptionType.Call || type_ == OptionType.Put,
954             "Wrong option type"
955         );
956         require(
957             time_ >= minTime && time_ <= maxTime,
958             "Invalid time"
959         );
960         require(msg.value >= 100, "bet to small");
961         require(enabledPairs[pp_], "Invalid  price provider");
962         uint depositValue;
963         if (devFundBetFee > 0) {
964             uint256 fee = msg.value.div(devFundBetFee).div(100);
965             require(devFund.send(fee), "devFund fee transfer failed");
966             depositValue = msg.value.sub(fee);
967             
968         } else {
969             depositValue = msg.value;
970         }
971 
972         RateCalc rc = RateCalc(rcAddress);
973         uint256 lockValue = getMaxAvailable();
974         lockValue = rc.rate(depositValue, lockValue.sub(depositValue));
975         
976 
977 
978          
979         AggregatorV3Interface priceProvider = AggregatorV3Interface(pp_);
980         (, int256 latestPrice, , , ) = priceProvider.latestRoundData();
981         uint256 optionID = options.length;
982         uint256 totalLock = lockValue.add(depositValue);
983         Option memory op = Option(
984             State.Active,
985             msg.sender,
986             uint256(latestPrice),
987             depositValue,
988             totalLock,//purchaseAmount+possible reward for correct bet
989             block.timestamp + time_,//all options 1hr to start
990             type_,
991             pp_
992         );
993         lock(totalLock);
994         options.push(op);
995         emit Create(optionID, msg.sender, uint256(latestPrice), totalLock, type_);
996         updateRewards(betReward);
997     }
998 
999      /**
1000      * @notice exercises a option
1001      * @param optionID id of the option to exercise
1002      */
1003     function exercise(uint256 optionID)
1004         external
1005     {
1006         Option memory option = options[optionID];
1007         require(block.timestamp <= option.expiration, "expiration date margin has passed");
1008         AggregatorV3Interface priceProvider = AggregatorV3Interface(option.priceProvider);
1009         (, int256 latestPrice, , , ) = priceProvider.latestRoundData();
1010         uint256 uLatestPrice = uint256(latestPrice);
1011         if (option.optionType == OptionType.Call) {
1012             require(uLatestPrice > option.strikePrice, "price is to low");
1013         } else {
1014             require(uLatestPrice < option.strikePrice, "price is to high");
1015         }
1016 
1017         //option expires ITM, we pay out
1018         payout(option.lockedValue.sub(option.purchaseValue), msg.sender, option.holder);
1019         
1020         lockedAmount = lockedAmount.sub(option.lockedValue);
1021         emit Exercise(optionID);
1022         updateRewards(exerciseReward);
1023     }
1024 
1025      /**
1026      * @notice expires a option
1027      * @param optionID id of the option to expire
1028      */
1029     function expire(uint256 optionID)
1030         external
1031     {
1032         Option memory option = options[optionID];
1033         require(block.timestamp > option.expiration, "expiration date has not passed");
1034         unlock(option.lockedValue.sub(option.purchaseValue), msg.sender, expirerFee);
1035         emit Expire(optionID);
1036         lockedAmount = lockedAmount.sub(option.lockedValue);
1037 
1038         updateRewards(exerciseReward);
1039     }
1040 
1041     /**
1042     @dev called by BinaryOptions contract to lock pool value coresponding to new binary options bought. 
1043     @param amount amount in ETH to lock from the pool total.
1044     */
1045     function lock(uint256 amount) internal {
1046         lockedAmount = lockedAmount.add(amount);
1047     }
1048 
1049     /**
1050     @dev called by BinaryOptions contract to unlock pool value coresponding to an option expiring otm. 
1051     @param amount amount in ETH to unlock
1052     @param goodSamaritan the user paying to unlock these funds, they recieve a fee
1053     */
1054     function unlock(uint256 amount, address payable goodSamaritan, uint256 eFee) internal {
1055         require(amount <= lockedAmount, "insufficent locked pool balance to unlock");
1056         uint256 fee = amount.div(eFee).div(100);
1057         if (fee > 0) {
1058             require(goodSamaritan.send(fee), "good samaritan transfer failed");
1059         }
1060     }
1061 
1062     /**
1063     @dev called by BinaryOptions contract to payout pool value coresponding to binary options expiring itm. 
1064     @param amount amount in BIOP to unlock
1065     @param exerciser address calling the exercise/expire function, this may the winner or another user who then earns a fee.
1066     @param winner address of the winner.
1067     @notice exerciser fees are subject to change see updateFeePercent above.
1068     */
1069     function payout(uint256 amount, address payable exerciser, address payable winner) internal {
1070         require(amount <= lockedAmount, "insufficent pool balance available to payout");
1071         require(amount <= address(this).balance, "insufficent balance in pool");
1072         if (exerciser != winner) {
1073             //good samaratin fee
1074             uint256 fee = amount.div(exerciserFee).div(100);
1075             if (fee > 0) {
1076                 require(exerciser.send(fee), "exerciser transfer failed");
1077                 require(winner.send(amount.sub(fee)), "winner transfer failed");
1078             }
1079         } else {  
1080             require(winner.send(amount), "winner transfer failed");
1081         }
1082         emit Payout(amount, winner);
1083     }
1084 
1085 }