1 /*
2 
3 ShibaETH
4 
5 1) 10% distribution in Ethereum (wETH)
6 2) 5% swapped and added to the liquidity pool
7 
8 ░██████╗██╗░░██╗██╗██████╗░░█████╗░███████╗████████╗██╗░░██╗
9 ██╔════╝██║░░██║██║██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║░░██║
10 ╚█████╗░███████║██║██████╦╝███████║█████╗░░░░░██║░░░███████║
11 ░╚═══██╗██╔══██║██║██╔══██╗██╔══██║██╔══╝░░░░░██║░░░██╔══██║
12 ██████╔╝██║░░██║██║██████╦╝██║░░██║███████╗░░░██║░░░██║░░██║
13 ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.4;
20 
21 /*
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) external returns (bool);
155 
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to {approve}. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 /**
172  * @dev Interface for the optional metadata functions from the ERC20 standard.
173  *
174  * _Available since v4.1._
175  */
176 interface IERC20Metadata is IERC20 {
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the symbol of the token.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the decimals places of the token.
189      */
190     function decimals() external view returns (uint8);
191 }
192 
193 /**
194  * @dev Implementation of the {IERC20} interface.
195  *
196  * This implementation is agnostic to the way tokens are created. This means
197  * that a supply mechanism has to be added in a derived contract using {_mint}.
198  * For a generic mechanism see {ERC20PresetMinterPauser}.
199  *
200  * TIP: For a detailed writeup see our guide
201  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
202  * to implement supply mechanisms].
203  *
204  * We have followed general OpenZeppelin guidelines: functions revert instead
205  * of returning `false` on failure. This behavior is nonetheless conventional
206  * and does not conflict with the expectations of ERC20 applications.
207  *
208  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
209  * This allows applications to reconstruct the allowance for all accounts just
210  * by listening to said events. Other implementations of the EIP may not emit
211  * these events, as it isn't required by the specification.
212  *
213  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
214  * functions have been added to mitigate the well-known issues around setting
215  * allowances. See {IERC20-approve}.
216  */
217 contract ERC20 is Context, IERC20, IERC20Metadata {
218     using SafeMath for uint256;
219 
220     mapping(address => uint256) private _balances;
221 
222     mapping(address => mapping(address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     string private _name;
227     string private _symbol;
228 
229     /**
230      * @dev Sets the values for {name} and {symbol}.
231      *
232      * The default value of {decimals} is 18. To select a different value for
233      * {decimals} you should overload it.
234      *
235      * All two of these values are immutable: they can only be set once during
236      * construction.
237      */
238     constructor(string memory name_, string memory symbol_) {
239         _name = name_;
240         _symbol = symbol_;
241     }
242 
243     /**
244      * @dev Returns the name of the token.
245      */
246     function name() public view virtual override returns (string memory) {
247         return _name;
248     }
249 
250     /**
251      * @dev Returns the symbol of the token, usually a shorter version of the
252      * name.
253      */
254     function symbol() public view virtual override returns (string memory) {
255         return _symbol;
256     }
257 
258     /**
259      * @dev Returns the number of decimals used to get its user representation.
260      * For example, if `decimals` equals `2`, a balance of `505` tokens should
261      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
262      *
263      * Tokens usually opt for a value of 18, imitating the relationship between
264      * Ether and Wei. This is the value {ERC20} uses, unless this function is
265      * overridden;
266      *
267      * NOTE: This information is only used for _display_ purposes: it in
268      * no way affects any of the arithmetic of the contract, including
269      * {IERC20-balanceOf} and {IERC20-transfer}.
270      */
271     function decimals() public view virtual override returns (uint8) {
272         return 18;
273     }
274 
275     /**
276      * @dev See {IERC20-totalSupply}.
277      */
278     function totalSupply() public view virtual override returns (uint256) {
279         return _totalSupply;
280     }
281 
282     /**
283      * @dev See {IERC20-balanceOf}.
284      */
285     function balanceOf(address account) public view virtual override returns (uint256) {
286         return _balances[account];
287     }
288 
289     /**
290      * @dev See {IERC20-transfer}.
291      *
292      * Requirements:
293      *
294      * - `recipient` cannot be the zero address.
295      * - the caller must have a balance of at least `amount`.
296      */
297     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
298         _transfer(_msgSender(), recipient, amount);
299         return true;
300     }
301 
302     /**
303      * @dev See {IERC20-allowance}.
304      */
305     function allowance(address owner, address spender) public view virtual override returns (uint256) {
306         return _allowances[owner][spender];
307     }
308 
309     /**
310      * @dev See {IERC20-approve}.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function approve(address spender, uint256 amount) public virtual override returns (bool) {
317         _approve(_msgSender(), spender, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-transferFrom}.
323      *
324      * Emits an {Approval} event indicating the updated allowance. This is not
325      * required by the EIP. See the note at the beginning of {ERC20}.
326      *
327      * Requirements:
328      *
329      * - `sender` and `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      * - the caller must have allowance for ``sender``'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) public virtual override returns (bool) {
339         _transfer(sender, recipient, amount);
340         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
341         return true;
342     }
343 
344     /**
345      * @dev Atomically increases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
357         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
358         return true;
359     }
360 
361     /**
362      * @dev Atomically decreases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to {approve} that can be used as a mitigation for
365      * problems described in {IERC20-approve}.
366      *
367      * Emits an {Approval} event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      * - `spender` must have allowance for the caller of at least
373      * `subtractedValue`.
374      */
375     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
377         return true;
378     }
379 
380     /**
381      * @dev Moves tokens `amount` from `sender` to `recipient`.
382      *
383      * This is internal function is equivalent to {transfer}, and can be used to
384      * e.g. implement automatic token fees, slashing mechanisms, etc.
385      *
386      * Emits a {Transfer} event.
387      *
388      * Requirements:
389      *
390      * - `sender` cannot be the zero address.
391      * - `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      */
394     function _transfer(
395         address sender,
396         address recipient,
397         uint256 amount
398     ) internal virtual {
399         require(sender != address(0), "ERC20: transfer from the zero address");
400         require(recipient != address(0), "ERC20: transfer to the zero address");
401 
402         _beforeTokenTransfer(sender, recipient, amount);
403 
404         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
405         _balances[recipient] = _balances[recipient].add(amount);
406         emit Transfer(sender, recipient, amount);
407     }
408 
409     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
410      * the total supply.
411      *
412      * Emits a {Transfer} event with `from` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      */
418     function _mint(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: mint to the zero address");
420 
421         _beforeTokenTransfer(address(0), account, amount);
422 
423         _totalSupply = _totalSupply.add(amount);
424         _balances[account] = _balances[account].add(amount);
425         emit Transfer(address(0), account, amount);
426     }
427 
428     /**
429      * @dev Destroys `amount` tokens from `account`, reducing the
430      * total supply.
431      *
432      * Emits a {Transfer} event with `to` set to the zero address.
433      *
434      * Requirements:
435      *
436      * - `account` cannot be the zero address.
437      * - `account` must have at least `amount` tokens.
438      */
439     function _burn(address account, uint256 amount) internal virtual {
440         require(account != address(0), "ERC20: burn from the zero address");
441 
442         _beforeTokenTransfer(account, address(0), amount);
443 
444         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
445         _totalSupply = _totalSupply.sub(amount);
446         emit Transfer(account, address(0), amount);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
451      *
452      * This internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an {Approval} event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(
463         address owner,
464         address spender,
465         uint256 amount
466     ) internal virtual {
467         require(owner != address(0), "ERC20: approve from the zero address");
468         require(spender != address(0), "ERC20: approve to the zero address");
469 
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     /**
475      * @dev Hook that is called before any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * will be to transferred to `to`.
482      * - when `from` is zero, `amount` tokens will be minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _beforeTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 }
494 
495 library SafeMath {
496     /**
497      * @dev Returns the addition of two unsigned integers, reverting on
498      * overflow.
499      *
500      * Counterpart to Solidity's `+` operator.
501      *
502      * Requirements:
503      *
504      * - Addition cannot overflow.
505      */
506     function add(uint256 a, uint256 b) internal pure returns (uint256) {
507         uint256 c = a + b;
508         require(c >= a, "SafeMath: addition overflow");
509 
510         return c;
511     }
512 
513     /**
514      * @dev Returns the subtraction of two unsigned integers, reverting on
515      * overflow (when the result is negative).
516      *
517      * Counterpart to Solidity's `-` operator.
518      *
519      * Requirements:
520      *
521      * - Subtraction cannot overflow.
522      */
523     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
524         return sub(a, b, "SafeMath: subtraction overflow");
525     }
526 
527     /**
528      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
529      * overflow (when the result is negative).
530      *
531      * Counterpart to Solidity's `-` operator.
532      *
533      * Requirements:
534      *
535      * - Subtraction cannot overflow.
536      */
537     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
538         require(b <= a, errorMessage);
539         uint256 c = a - b;
540 
541         return c;
542     }
543 
544     /**
545      * @dev Returns the multiplication of two unsigned integers, reverting on
546      * overflow.
547      *
548      * Counterpart to Solidity's `*` operator.
549      *
550      * Requirements:
551      *
552      * - Multiplication cannot overflow.
553      */
554     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
555         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
556         // benefit is lost if 'b' is also tested.
557         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
558         if (a == 0) {
559             return 0;
560         }
561 
562         uint256 c = a * b;
563         require(c / a == b, "SafeMath: multiplication overflow");
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the integer division of two unsigned integers. Reverts on
570      * division by zero. The result is rounded towards zero.
571      *
572      * Counterpart to Solidity's `/` operator. Note: this function uses a
573      * `revert` opcode (which leaves remaining gas untouched) while Solidity
574      * uses an invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function div(uint256 a, uint256 b) internal pure returns (uint256) {
581         return div(a, b, "SafeMath: division by zero");
582     }
583 
584     /**
585      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
586      * division by zero. The result is rounded towards zero.
587      *
588      * Counterpart to Solidity's `/` operator. Note: this function uses a
589      * `revert` opcode (which leaves remaining gas untouched) while Solidity
590      * uses an invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b > 0, errorMessage);
598         uint256 c = a / b;
599         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
600 
601         return c;
602     }
603 
604     /**
605      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
606      * Reverts when dividing by zero.
607      *
608      * Counterpart to Solidity's `%` operator. This function uses a `revert`
609      * opcode (which leaves remaining gas untouched) while Solidity uses an
610      * invalid opcode to revert (consuming all remaining gas).
611      *
612      * Requirements:
613      *
614      * - The divisor cannot be zero.
615      */
616     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
617         return mod(a, b, "SafeMath: modulo by zero");
618     }
619 
620     /**
621      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
622      * Reverts with custom message when dividing by zero.
623      *
624      * Counterpart to Solidity's `%` operator. This function uses a `revert`
625      * opcode (which leaves remaining gas untouched) while Solidity uses an
626      * invalid opcode to revert (consuming all remaining gas).
627      *
628      * Requirements:
629      *
630      * - The divisor cannot be zero.
631      */
632     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
633         require(b != 0, errorMessage);
634         return a % b;
635     }
636 }
637 
638 /**
639  * @title SafeMathInt
640  * @dev Math operations for int256 with overflow safety checks.
641  */
642 library SafeMathInt {
643     int256 private constant MIN_INT256 = int256(1) << 255;
644     int256 private constant MAX_INT256 = ~(int256(1) << 255);
645 
646     /**
647      * @dev Multiplies two int256 variables and fails on overflow.
648      */
649     function mul(int256 a, int256 b) internal pure returns (int256) {
650         int256 c = a * b;
651 
652         // Detect overflow when multiplying MIN_INT256 with -1
653         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
654         require((b == 0) || (c / b == a));
655         return c;
656     }
657 
658     /**
659      * @dev Division of two int256 variables and fails on overflow.
660      */
661     function div(int256 a, int256 b) internal pure returns (int256) {
662         // Prevent overflow when dividing MIN_INT256 by -1
663         require(b != -1 || a != MIN_INT256);
664 
665         // Solidity already throws when dividing by 0.
666         return a / b;
667     }
668 
669     /**
670      * @dev Subtracts two int256 variables and fails on overflow.
671      */
672     function sub(int256 a, int256 b) internal pure returns (int256) {
673         int256 c = a - b;
674         require((b >= 0 && c <= a) || (b < 0 && c > a));
675         return c;
676     }
677 
678     /**
679      * @dev Adds two int256 variables and fails on overflow.
680      */
681     function add(int256 a, int256 b) internal pure returns (int256) {
682         int256 c = a + b;
683         require((b >= 0 && c >= a) || (b < 0 && c < a));
684         return c;
685     }
686 
687     /**
688      * @dev Converts to absolute value, and fails on overflow.
689      */
690     function abs(int256 a) internal pure returns (int256) {
691         require(a != MIN_INT256);
692         return a < 0 ? -a : a;
693     }
694 
695 
696     function toUint256Safe(int256 a) internal pure returns (uint256) {
697         require(a >= 0);
698         return uint256(a);
699     }
700 }
701 
702 /**
703  * @title SafeMathUint
704  * @dev Math operations with safety checks that revert on error
705  */
706 library SafeMathUint {
707     function toInt256Safe(uint256 a) internal pure returns (int256) {
708         int256 b = int256(a);
709         require(b >= 0);
710         return b;
711     }
712 }
713 
714 contract ShibaETH is ERC20, Ownable {
715     using SafeMath for uint256;
716 
717     IUniswapV2Router02 public uniswapV2Router;
718     address public immutable uniswapV2Pair;
719 
720     bool private liquidating;
721 
722     ShibaETHDividendTracker public dividendTracker;
723     
724     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
725 
726     uint256 public MAX_BUY_TRANSACTION_AMOUNT = 500000000 * (10**18); // 500 Million (0.5%)
727     uint256 public MAX_SELL_TRANSACTION_AMOUNT = 100000000 * (10**18); // 100 Million (0.1%)
728     uint256 public MAX_WALLET_AMOUNT = 1000000000 * (10**18); // 1 Billion (1%)
729 
730     uint256 public constant ETH_REWARDS_FEE = 10;
731     uint256 public constant LIQUIDITY_FEE = 5;
732     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
733     
734     // sells have fees of 10 and 5 (10 * 1.3 and 5 * 1.3)
735     uint256 public SELL_FEE_INCREASE_FACTOR = 130;
736 
737     // use by default 150,000 gas to process auto-claiming dividends
738     uint256 public gasForProcessing = 150000;
739 
740     // liquidate tokens for ETH when the contract reaches 100k tokens by default
741     uint256 public liquidateTokensAtAmount = 100000 * (10**18); // 100 Thousand (0.0001%);
742 
743     // whether the token can already be traded
744     bool public tradingEnabled;
745 
746     function activateTrading() public onlyOwner {
747         require(!tradingEnabled, "ShibaETH: Trading is already enabled");
748         tradingEnabled = true;
749     }
750 
751     // exclude from fees and max transaction amount
752     mapping (address => bool) private _isExcludedFromFees;
753 
754     // addresses that can make transfers before presale is over
755     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
756 
757     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
758     // could be subject to a maximum transfer amount
759     mapping (address => bool) public automatedMarketMakerPairs;
760 
761     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
762 
763     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
764 
765     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
766 
767     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
768 
769     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
770 
771     event Liquified(
772         uint256 tokensSwapped,
773         uint256 ethReceived,
774         uint256 tokensIntoLiqudity
775     );
776 
777     event SentDividends(
778         uint256 tokensSwapped,
779         uint256 amount
780     );
781 
782     event ProcessedDividendTracker(
783         uint256 iterations,
784         uint256 claims,
785         uint256 lastProcessedIndex,
786         bool indexed automatic,
787         uint256 gas,
788         address indexed processor
789     );
790 
791     constructor() ERC20("ShibaETH", "ShibaETH") {
792         assert(TOTAL_FEES == 15);
793 
794         dividendTracker = new ShibaETHDividendTracker();
795 
796         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
797         // Create a uniswap pair for this new token
798         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
799 
800         uniswapV2Router = _uniswapV2Router;
801         uniswapV2Pair = _uniswapV2Pair;
802 
803         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
804 
805         // exclude from receiving dividends
806         dividendTracker.excludeFromDividends(address(dividendTracker));
807         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
808         dividendTracker.excludeFromDividends(deadAddress);
809 
810         // exclude from paying fees or having max transaction amount
811         excludeFromFees(address(this));
812 
813         // enable owner wallet to send tokens before presales are over.
814         canTransferBeforeTradingIsEnabled[owner()] = true;
815 
816         /*
817             _mint is an internal function in ERC20.sol that is only called here,
818             and CANNOT be called ever again
819         */
820         _mint(owner(), 100000000000 * (10**18)); // 100 Billion (100%)
821     }
822 
823     receive() external payable {}
824 
825     function updateDividendTracker(address newAddress) public onlyOwner {
826         require(newAddress != address(dividendTracker), "ShibaETH: The dividend tracker already has that address");
827 
828         ShibaETHDividendTracker newDividendTracker = ShibaETHDividendTracker(payable(newAddress));
829 
830         require(newDividendTracker.owner() == address(this), "ShibaETH: The new dividend tracker must be owned by the ShibaETH token contract");
831 
832         newDividendTracker.excludeFromDividends(address(newDividendTracker));
833         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
834         newDividendTracker.excludeFromDividends(address(deadAddress));
835 
836         emit UpdatedDividendTracker(newAddress, address(dividendTracker));
837 
838         dividendTracker = newDividendTracker;
839     }
840 
841     function updateUniswapV2Router(address newAddress) public onlyOwner {
842         require(newAddress != address(uniswapV2Router), "ShibaETH: The router already has that address");
843         emit UpdatedUniswapV2Router(newAddress, address(uniswapV2Router));
844         uniswapV2Router = IUniswapV2Router02(newAddress);
845     }
846 
847     function excludeFromFees(address account) public onlyOwner {
848         require(!_isExcludedFromFees[account], "ShibaETH: Account is already excluded from fees");
849         _isExcludedFromFees[account] = true;
850     }
851     
852     function includeForFees(address account) public onlyOwner {
853         require(_isExcludedFromFees[account], "ShibaETH: Account is already included for fees");
854         _isExcludedFromFees[account] = false;
855     }
856     
857     function excludeFromDividends(address account) public onlyOwner {
858         dividendTracker.excludeFromDividends(account);
859     }
860     
861     function setMaxBuyTransactionAmount(uint256 amount) external onlyOwner {
862         MAX_BUY_TRANSACTION_AMOUNT = amount * (10**18);
863     }
864     
865     function setMaxSellTransactionAmount(uint256 amount) external onlyOwner {
866         MAX_SELL_TRANSACTION_AMOUNT = amount * (10**18);   
867     }
868     
869     function setMaxWalletAmount(uint256 amount) external onlyOwner {
870         MAX_WALLET_AMOUNT = amount * (10**18);
871     }
872     
873     function setSellFeeIncreaseFactor(uint256 multiplier) external onlyOwner {
874   	    require(SELL_FEE_INCREASE_FACTOR >= 100 && SELL_FEE_INCREASE_FACTOR <= 200, "ShibaETH: Sell transaction multipler must be between 100 (1x) and 200 (2x)");
875   	    SELL_FEE_INCREASE_FACTOR = multiplier;
876   	}
877 
878     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
879         require(pair != uniswapV2Pair, "ShibaETH: The Uniswap pair cannot be removed from automatedMarketMakerPairs");
880 
881         _setAutomatedMarketMakerPair(pair, value);
882     }
883 
884     function _setAutomatedMarketMakerPair(address pair, bool value) private {
885         require(automatedMarketMakerPairs[pair] != value, "ShibaETH: Automated market maker pair is already set to that value");
886         automatedMarketMakerPairs[pair] = value;
887 
888         if (value) {
889             dividendTracker.excludeFromDividends(pair);
890         }
891 
892         emit SetAutomatedMarketMakerPair(pair, value);
893     }
894 
895     function allowTransferBeforeTradingIsEnabled(address account) public onlyOwner {
896         require(!canTransferBeforeTradingIsEnabled[account], "ShibaETH: Account is already allowed to transfer before trading is enabled");
897         canTransferBeforeTradingIsEnabled[account] = true;
898     }
899 
900     function updateGasForProcessing(uint256 newValue) public onlyOwner {
901         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
902         require(newValue != gasForProcessing, "ShibaETH: Cannot update gasForProcessing to same value");
903         emit GasForProcessingUpdated(newValue, gasForProcessing);
904         gasForProcessing = newValue;
905     }
906 
907     function updateLiquidationThreshold(uint256 newValue) external onlyOwner {
908         require(newValue != liquidateTokensAtAmount, "ShibaETH: Cannot update gasForProcessing to same value");
909         emit LiquidationThresholdUpdated(newValue, liquidateTokensAtAmount);
910         liquidateTokensAtAmount = newValue;
911     }
912 
913     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
914         dividendTracker.updateGasForTransfer(gasForTransfer);
915     }
916 
917     function updateClaimWait(uint256 claimWait) external onlyOwner {
918         dividendTracker.updateClaimWait(claimWait);
919     }
920 
921     function getGasForTransfer() external view returns(uint256) {
922         return dividendTracker.gasForTransfer();
923     }
924 
925     function getClaimWait() external view returns(uint256) {
926         return dividendTracker.claimWait();
927     }
928 
929     function getTotalDividendsDistributed() external view returns (uint256) {
930         return dividendTracker.totalDividendsDistributed();
931     }
932 
933     function isExcludedFromFees(address account) public view returns(bool) {
934         return _isExcludedFromFees[account];
935     }
936 
937     function withdrawableDividendOf(address account) public view returns(uint256) {
938         return dividendTracker.withdrawableDividendOf(account);
939     }
940 
941     function dividendTokenBalanceOf(address account) public view returns (uint256) {
942         return dividendTracker.balanceOf(account);
943     }
944 
945     function getAccountDividendsInfo(address account)
946     external view returns (
947         address,
948         int256,
949         int256,
950         uint256,
951         uint256,
952         uint256,
953         uint256,
954         uint256) {
955         return dividendTracker.getAccount(account);
956     }
957 
958     function getAccountDividendsInfoAtIndex(uint256 index)
959     external view returns (
960         address,
961         int256,
962         int256,
963         uint256,
964         uint256,
965         uint256,
966         uint256,
967         uint256) {
968         return dividendTracker.getAccountAtIndex(index);
969     }
970 
971     function processDividendTracker(uint256 gas) external {
972         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
973         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
974     }
975 
976     function claim() external {
977         dividendTracker.processAccount(payable(msg.sender), false);
978     }
979 
980     function getLastProcessedIndex() external view returns(uint256) {
981         return dividendTracker.getLastProcessedIndex();
982     }
983 
984     function getNumberOfDividendTokenHolders() external view returns(uint256) {
985         return dividendTracker.getNumberOfTokenHolders();
986     }
987 
988     function _transfer(
989         address from,
990         address to,
991         uint256 amount
992     ) internal override {
993         require(from != address(0), "ERC20: transfer from the zero address");
994         require(to != address(0), "ERC20: transfer to the zero address");
995 
996         bool tradingIsEnabled = tradingEnabled;
997 
998         // only whitelisted addresses can make transfers before the public presale is over.
999         if (!tradingIsEnabled) {
1000             require(canTransferBeforeTradingIsEnabled[from], "ShibaETH: This account cannot send tokens until trading is enabled");
1001         }
1002 
1003         if (amount == 0) {
1004             super._transfer(from, to, 0);
1005             return;
1006         }
1007 
1008         if (!liquidating &&
1009             tradingIsEnabled &&
1010             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1011             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1012             !_isExcludedFromFees[to] //no max tx-amount and wallet token amount for those excluded from fees
1013         ) {
1014             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1015             uint256 contractBalanceRecepient = balanceOf(to);
1016             require(contractBalanceRecepient + amount <= MAX_WALLET_AMOUNT,
1017                 "Exceeds MAX_WALLET_AMOUNT."
1018             );
1019         }
1020 
1021         uint256 contractTokenBalance = balanceOf(address(this));
1022 
1023         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1024 
1025         if (tradingIsEnabled &&
1026             canSwap &&
1027             !liquidating &&
1028             !automatedMarketMakerPairs[from] &&
1029             from != address(this) &&
1030             to != address(this)
1031         ) {
1032             liquidating = true;
1033 
1034             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1035             swapAndLiquify(swapTokens);
1036 
1037             uint256 sellTokens = balanceOf(address(this));
1038             swapAndSendDividends(sellTokens);
1039 
1040             liquidating = false;
1041         }
1042 
1043         bool takeFee = tradingIsEnabled && !liquidating;
1044 
1045         // if any account belongs to _isExcludedFromFee account then remove the fee
1046         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1047             takeFee = false;
1048         }
1049 
1050         if (takeFee) {
1051             uint256 fees = amount.div(100).mul(TOTAL_FEES);
1052             
1053             // if sell, multiply by 1.3
1054             if(automatedMarketMakerPairs[to]) {
1055                 fees = fees.div(100).mul(SELL_FEE_INCREASE_FACTOR);
1056             }
1057             
1058             amount = amount.sub(fees);
1059 
1060             super._transfer(from, address(this), fees);
1061         }
1062 
1063         super._transfer(from, to, amount);
1064 
1065         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1066         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1067 
1068         if (!liquidating) {
1069             uint256 gas = gasForProcessing;
1070 
1071             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1072                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1073             } catch {
1074 
1075             }
1076         }
1077     }
1078 
1079     function swapAndLiquify(uint256 tokens) private {
1080         // split the contract balance into halves
1081         uint256 half = tokens.div(2);
1082         uint256 otherHalf = tokens.sub(half);
1083 
1084         // capture the contract's current ETH balance.
1085         // this is so that we can capture exactly the amount of ETH that the
1086         // swap creates, and not make the liquidity event include any ETH that
1087         // has been manually sent to the contract
1088         uint256 initialBalance = address(this).balance;
1089 
1090         // swap tokens for ETH
1091         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1092 
1093         // how much ETH did we just swap into?
1094         uint256 newBalance = address(this).balance.sub(initialBalance);
1095 
1096         // add liquidity to uniswap
1097         addLiquidity(otherHalf, newBalance);
1098 
1099         emit Liquified(half, newBalance, otherHalf);
1100     }
1101 
1102     function swapTokensForEth(uint256 tokenAmount) private {
1103         // generate the uniswap pair path of token -> weth
1104         address[] memory path = new address[](2);
1105         path[0] = address(this);
1106         path[1] = uniswapV2Router.WETH();
1107 
1108         _approve(address(this), address(uniswapV2Router), tokenAmount);
1109 
1110         // make the swap
1111         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1112             tokenAmount,
1113             0, // accept any amount of ETH
1114             path,
1115             address(this),
1116             block.timestamp
1117         );
1118     }
1119 
1120     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1121         // approve token transfer to cover all possible scenarios
1122         _approve(address(this), address(uniswapV2Router), tokenAmount);
1123 
1124         // add the liquidity
1125         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1126             address(this),
1127             tokenAmount,
1128             0, // slippage is unavoidable
1129             0, // slippage is unavoidable
1130             address(this),
1131             block.timestamp
1132         );
1133     }
1134 
1135     function swapAndSendDividends(uint256 tokens) private {
1136         swapTokensForEth(tokens);
1137         uint256 dividends = address(this).balance;
1138 
1139         (bool success,) = address(dividendTracker).call{value: dividends}("");
1140         if (success) {
1141             emit SentDividends(tokens, dividends);
1142         }
1143     }
1144 }
1145 
1146 /// @title Dividend-Paying Token Interface
1147 /// @author Roger Wu (https://github.com/roger-wu)
1148 /// @dev An interface for a dividend-paying token contract.
1149 interface DividendPayingTokenInterface {
1150     /// @notice View the amount of dividend in wei that an address can withdraw.
1151     /// @param _owner The address of a token holder.
1152     /// @return The amount of dividend in wei that `_owner` can withdraw.
1153     function dividendOf(address _owner) external view returns(uint256);
1154 
1155     /// @notice Distributes ether to token holders as dividends.
1156     /// @dev SHOULD distribute the paid ether to token holders as dividends.
1157     ///  SHOULD NOT directly transfer ether to token holders in this function.
1158     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
1159     function distributeDividends() external payable;
1160 
1161     /// @notice Withdraws the ether distributed to the sender.
1162     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
1163     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
1164     function withdrawDividend() external;
1165 
1166     /// @dev This event MUST emit when ether is distributed to token holders.
1167     /// @param from The address which sends ether to this contract.
1168     /// @param weiAmount The amount of distributed ether in wei.
1169     event DividendsDistributed(
1170         address indexed from,
1171         uint256 weiAmount
1172     );
1173 
1174     /// @dev This event MUST emit when an address withdraws their dividend.
1175     /// @param to The address which withdraws ether from this contract.
1176     /// @param weiAmount The amount of withdrawn ether in wei.
1177     event DividendWithdrawn(
1178         address indexed to,
1179         uint256 weiAmount
1180     );
1181 }
1182 
1183 /// @title Dividend-Paying Token Optional Interface
1184 /// @author Roger Wu (https://github.com/roger-wu)
1185 /// @dev OPTIONAL functions for a dividend-paying token contract.
1186 interface DividendPayingTokenOptionalInterface {
1187     /// @notice View the amount of dividend in wei that an address can withdraw.
1188     /// @param _owner The address of a token holder.
1189     /// @return The amount of dividend in wei that `_owner` can withdraw.
1190     function withdrawableDividendOf(address _owner) external view returns(uint256);
1191 
1192     /// @notice View the amount of dividend in wei that an address has withdrawn.
1193     /// @param _owner The address of a token holder.
1194     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1195     function withdrawnDividendOf(address _owner) external view returns(uint256);
1196 
1197     /// @notice View the amount of dividend in wei that an address has earned in total.
1198     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1199     /// @param _owner The address of a token holder.
1200     /// @return The amount of dividend in wei that `_owner` has earned in total.
1201     function accumulativeDividendOf(address _owner) external view returns(uint256);
1202 }
1203 
1204 /// @title Dividend-Paying Token
1205 /// @author Roger Wu (https://github.com/roger-wu)
1206 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1207 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1208 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1209 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1210     using SafeMath for uint256;
1211     using SafeMathUint for uint256;
1212     using SafeMathInt for int256;
1213 
1214     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1215     // For more discussion about choosing the value of `magnitude`,
1216     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1217     uint256 constant internal magnitude = 2**128;
1218 
1219     uint256 internal magnifiedDividendPerShare;
1220 
1221     // About dividendCorrection:
1222     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1223     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1224     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1225     //   `dividendOf(_user)` should not be changed,
1226     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1227     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1228     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1229     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1230     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1231     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1232     mapping(address => int256) internal magnifiedDividendCorrections;
1233     mapping(address => uint256) internal withdrawnDividends;
1234 
1235     // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1236     uint256 public gasForTransfer;
1237 
1238     uint256 public totalDividendsDistributed;
1239 
1240     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1241         gasForTransfer = 3000;
1242     }
1243 
1244     /// @dev Distributes dividends whenever ether is paid to this contract.
1245     receive() external payable {
1246         distributeDividends();
1247     }
1248 
1249     /// @notice Distributes ether to token holders as dividends.
1250     /// @dev It reverts if the total supply of tokens is 0.
1251     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1252     /// About undistributed ether:
1253     ///   In each distribution, there is a small amount of ether not distributed,
1254     ///     the magnified amount of which is
1255     ///     `(msg.value * magnitude) % totalSupply()`.
1256     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1257     ///     (de-magnified) in a distribution can be less than 1 wei.
1258     ///   We can actually keep track of the undistributed ether in a distribution
1259     ///     and try to distribute it in the next distribution,
1260     ///     but keeping track of such data on-chain costs much more than
1261     ///     the saved ether, so we don't do that.
1262     function distributeDividends() public override payable {
1263         require(totalSupply() > 0);
1264 
1265         if (msg.value > 0) {
1266             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1267                 (msg.value).mul(magnitude) / totalSupply()
1268             );
1269             emit DividendsDistributed(msg.sender, msg.value);
1270 
1271             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1272         }
1273     }
1274 
1275     /// @notice Withdraws the ether distributed to the sender.
1276     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1277     function withdrawDividend() public virtual override {
1278         _withdrawDividendOfUser(payable(msg.sender));
1279     }
1280 
1281     /// @notice Withdraws the ether distributed to the sender.
1282     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1283     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1284         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1285         if (_withdrawableDividend > 0) {
1286             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1287             emit DividendWithdrawn(user, _withdrawableDividend);
1288             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
1289 
1290             if(!success) {
1291                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1292                 return 0;
1293             }
1294 
1295             return _withdrawableDividend;
1296         }
1297 
1298         return 0;
1299     }
1300 
1301     /// @notice View the amount of dividend in wei that an address can withdraw.
1302     /// @param _owner The address of a token holder.
1303     /// @return The amount of dividend in wei that `_owner` can withdraw.
1304     function dividendOf(address _owner) public view override returns(uint256) {
1305         return withdrawableDividendOf(_owner);
1306     }
1307 
1308     /// @notice View the amount of dividend in wei that an address can withdraw.
1309     /// @param _owner The address of a token holder.
1310     /// @return The amount of dividend in wei that `_owner` can withdraw.
1311     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1312         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1313     }
1314 
1315     /// @notice View the amount of dividend in wei that an address has withdrawn.
1316     /// @param _owner The address of a token holder.
1317     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1318     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1319         return withdrawnDividends[_owner];
1320     }
1321 
1322 
1323     /// @notice View the amount of dividend in wei that an address has earned in total.
1324     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1325     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1326     /// @param _owner The address of a token holder.
1327     /// @return The amount of dividend in wei that `_owner` has earned in total.
1328     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1329         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1330         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1331     }
1332 
1333     /// @dev Internal function that transfer tokens from one address to another.
1334     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1335     /// @param from The address to transfer from.
1336     /// @param to The address to transfer to.
1337     /// @param value The amount to be transferred.
1338     function _transfer(address from, address to, uint256 value) internal virtual override {
1339         require(false);
1340 
1341         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1342         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1343         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1344     }
1345 
1346     /// @dev Internal function that mints tokens to an account.
1347     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1348     /// @param account The account that will receive the created tokens.
1349     /// @param value The amount that will be created.
1350     function _mint(address account, uint256 value) internal override {
1351         super._mint(account, value);
1352 
1353         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1354         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1355     }
1356 
1357     /// @dev Internal function that burns an amount of the token of a given account.
1358     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1359     /// @param account The account whose tokens will be burnt.
1360     /// @param value The amount that will be burnt.
1361     function _burn(address account, uint256 value) internal override {
1362         super._burn(account, value);
1363 
1364         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1365         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1366     }
1367 
1368     function _setBalance(address account, uint256 newBalance) internal {
1369         uint256 currentBalance = balanceOf(account);
1370 
1371         if(newBalance > currentBalance) {
1372             uint256 mintAmount = newBalance.sub(currentBalance);
1373             _mint(account, mintAmount);
1374         } else if(newBalance < currentBalance) {
1375             uint256 burnAmount = currentBalance.sub(newBalance);
1376             _burn(account, burnAmount);
1377         }
1378     }
1379 }
1380 
1381 contract ShibaETHDividendTracker is DividendPayingToken, Ownable {
1382     using SafeMath for uint256;
1383     using SafeMathInt for int256;
1384     using IterableMapping for IterableMapping.Map;
1385 
1386     IterableMapping.Map private tokenHoldersMap;
1387     uint256 public lastProcessedIndex;
1388 
1389     mapping (address => bool) public excludedFromDividends;
1390 
1391     mapping (address => uint256) public lastClaimTimes;
1392 
1393     uint256 public claimWait;
1394     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 200000 * (10**18); // Must hold 200,000+ tokens.
1395 
1396     event ExcludedFromDividends(address indexed account);
1397     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1398     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1399 
1400     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1401 
1402     constructor() DividendPayingToken("ShibaETH_Dividend_Tracker", "ShibaETH_Dividend_Tracker") {
1403         claimWait = 3600;
1404     }
1405 
1406     function _transfer(address, address, uint256) internal pure override {
1407         require(false, "ShibaETH_Dividend_Tracker: No transfers allowed");
1408     }
1409 
1410     function withdrawDividend() public pure override {
1411         require(false, "ShibaETH_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main ShibaETH contract.");
1412     }
1413 
1414     function excludeFromDividends(address account) external onlyOwner {
1415         require(!excludedFromDividends[account]);
1416         excludedFromDividends[account] = true;
1417 
1418         _setBalance(account, 0);
1419         tokenHoldersMap.remove(account);
1420 
1421         emit ExcludedFromDividends(account);
1422     }
1423 
1424     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1425         require(newGasForTransfer != gasForTransfer, "ShibaETH_Dividend_Tracker: Cannot update gasForTransfer to same value");
1426         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1427         gasForTransfer = newGasForTransfer;
1428     }
1429 
1430     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1431         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ShibaETH_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1432         require(newClaimWait != claimWait, "ShibaETH_Dividend_Tracker: Cannot update claimWait to same value");
1433         emit ClaimWaitUpdated(newClaimWait, claimWait);
1434         claimWait = newClaimWait;
1435     }
1436 
1437     function getLastProcessedIndex() external view returns(uint256) {
1438         return lastProcessedIndex;
1439     }
1440 
1441     function getNumberOfTokenHolders() external view returns(uint256) {
1442         return tokenHoldersMap.keys.length;
1443     }
1444 
1445     function getAccount(address _account)
1446     public view returns (
1447         address account,
1448         int256 index,
1449         int256 iterationsUntilProcessed,
1450         uint256 withdrawableDividends,
1451         uint256 totalDividends,
1452         uint256 lastClaimTime,
1453         uint256 nextClaimTime,
1454         uint256 secondsUntilAutoClaimAvailable) {
1455         account = _account;
1456 
1457         index = tokenHoldersMap.getIndexOfKey(account);
1458 
1459         iterationsUntilProcessed = -1;
1460 
1461         if (index >= 0) {
1462             if (uint256(index) > lastProcessedIndex) {
1463                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1464             } else {
1465                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1466                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1467             }
1468         }
1469 
1470         withdrawableDividends = withdrawableDividendOf(account);
1471         totalDividends = accumulativeDividendOf(account);
1472 
1473         lastClaimTime = lastClaimTimes[account];
1474         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1475         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1476     }
1477 
1478     function getAccountAtIndex(uint256 index)
1479     public view returns (
1480         address,
1481         int256,
1482         int256,
1483         uint256,
1484         uint256,
1485         uint256,
1486         uint256,
1487         uint256) {
1488         if (index >= tokenHoldersMap.size()) {
1489             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1490         }
1491 
1492         address account = tokenHoldersMap.getKeyAtIndex(index);
1493         return getAccount(account);
1494     }
1495 
1496     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1497         if (lastClaimTime > block.timestamp)  {
1498             return false;
1499         }
1500         return block.timestamp.sub(lastClaimTime) >= claimWait;
1501     }
1502 
1503     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1504         if (excludedFromDividends[account]) {
1505             return;
1506         }
1507 
1508         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1509             _setBalance(account, newBalance);
1510             tokenHoldersMap.set(account, newBalance);
1511         } else {
1512             _setBalance(account, 0);
1513             tokenHoldersMap.remove(account);
1514         }
1515 
1516         processAccount(account, true);
1517     }
1518 
1519     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1520         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1521 
1522         if (numberOfTokenHolders == 0) {
1523             return (0, 0, lastProcessedIndex);
1524         }
1525 
1526         uint256 _lastProcessedIndex = lastProcessedIndex;
1527 
1528         uint256 gasUsed = 0;
1529         uint256 gasLeft = gasleft();
1530 
1531         uint256 iterations = 0;
1532         uint256 claims = 0;
1533 
1534         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1535             _lastProcessedIndex++;
1536 
1537             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1538                 _lastProcessedIndex = 0;
1539             }
1540 
1541             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1542 
1543             if (canAutoClaim(lastClaimTimes[account])) {
1544                 if (processAccount(payable(account), true)) {
1545                     claims++;
1546                 }
1547             }
1548 
1549             iterations++;
1550 
1551             uint256 newGasLeft = gasleft();
1552 
1553             if (gasLeft > newGasLeft) {
1554                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1555             }
1556 
1557             gasLeft = newGasLeft;
1558         }
1559 
1560         lastProcessedIndex = _lastProcessedIndex;
1561 
1562         return (iterations, claims, lastProcessedIndex);
1563     }
1564 
1565     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1566         uint256 amount = _withdrawDividendOfUser(account);
1567 
1568         if (amount > 0) {
1569             lastClaimTimes[account] = block.timestamp;
1570             emit Claim(account, amount, automatic);
1571             return true;
1572         }
1573 
1574         return false;
1575     }
1576 }
1577 
1578 library IterableMapping {
1579     // Iterable mapping from address to uint;
1580     struct Map {
1581         address[] keys;
1582         mapping(address => uint) values;
1583         mapping(address => uint) indexOf;
1584         mapping(address => bool) inserted;
1585     }
1586 
1587     function get(Map storage map, address key) public view returns (uint) {
1588         return map.values[key];
1589     }
1590 
1591     function getIndexOfKey(Map storage map, address key) public view returns (int) {
1592         if(!map.inserted[key]) {
1593             return -1;
1594         }
1595         return int(map.indexOf[key]);
1596     }
1597 
1598     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
1599         return map.keys[index];
1600     }
1601 
1602     function size(Map storage map) public view returns (uint) {
1603         return map.keys.length;
1604     }
1605 
1606     function set(Map storage map, address key, uint val) public {
1607         if (map.inserted[key]) {
1608             map.values[key] = val;
1609         } else {
1610             map.inserted[key] = true;
1611             map.values[key] = val;
1612             map.indexOf[key] = map.keys.length;
1613             map.keys.push(key);
1614         }
1615     }
1616 
1617     function remove(Map storage map, address key) public {
1618         if (!map.inserted[key]) {
1619             return;
1620         }
1621 
1622         delete map.inserted[key];
1623         delete map.values[key];
1624 
1625         uint index = map.indexOf[key];
1626         uint lastIndex = map.keys.length - 1;
1627         address lastKey = map.keys[lastIndex];
1628 
1629         map.indexOf[lastKey] = index;
1630         delete map.indexOf[key];
1631 
1632         map.keys[index] = lastKey;
1633         map.keys.pop();
1634     }
1635 }
1636 
1637 interface IUniswapV2Factory {
1638     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1639 
1640     function feeTo() external view returns (address);
1641     function feeToSetter() external view returns (address);
1642 
1643     function getPair(address tokenA, address tokenB) external view returns (address pair);
1644     function allPairs(uint) external view returns (address pair);
1645     function allPairsLength() external view returns (uint);
1646 
1647     function createPair(address tokenA, address tokenB) external returns (address pair);
1648 
1649     function setFeeTo(address) external;
1650     function setFeeToSetter(address) external;
1651 }
1652 
1653 interface IUniswapV2Pair {
1654     event Approval(address indexed owner, address indexed spender, uint value);
1655     event Transfer(address indexed from, address indexed to, uint value);
1656 
1657     function name() external pure returns (string memory);
1658     function symbol() external pure returns (string memory);
1659     function decimals() external pure returns (uint8);
1660     function totalSupply() external view returns (uint);
1661     function balanceOf(address owner) external view returns (uint);
1662     function allowance(address owner, address spender) external view returns (uint);
1663 
1664     function approve(address spender, uint value) external returns (bool);
1665     function transfer(address to, uint value) external returns (bool);
1666     function transferFrom(address from, address to, uint value) external returns (bool);
1667 
1668     function DOMAIN_SEPARATOR() external view returns (bytes32);
1669     function PERMIT_TYPEHASH() external pure returns (bytes32);
1670     function nonces(address owner) external view returns (uint);
1671 
1672     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1673 
1674     event Mint(address indexed sender, uint amount0, uint amount1);
1675     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1676     event Swap(
1677         address indexed sender,
1678         uint amount0In,
1679         uint amount1In,
1680         uint amount0Out,
1681         uint amount1Out,
1682         address indexed to
1683     );
1684     event Sync(uint112 reserve0, uint112 reserve1);
1685 
1686     function MINIMUM_LIQUIDITY() external pure returns (uint);
1687     function factory() external view returns (address);
1688     function token0() external view returns (address);
1689     function token1() external view returns (address);
1690     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1691     function price0CumulativeLast() external view returns (uint);
1692     function price1CumulativeLast() external view returns (uint);
1693     function kLast() external view returns (uint);
1694 
1695     function mint(address to) external returns (uint liquidity);
1696     function burn(address to) external returns (uint amount0, uint amount1);
1697     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1698     function skim(address to) external;
1699     function sync() external;
1700 
1701     function initialize(address, address) external;
1702 }
1703 
1704 interface IUniswapV2Router01 {
1705     function factory() external pure returns (address);
1706     function WETH() external pure returns (address);
1707 
1708     function addLiquidity(
1709         address tokenA,
1710         address tokenB,
1711         uint amountADesired,
1712         uint amountBDesired,
1713         uint amountAMin,
1714         uint amountBMin,
1715         address to,
1716         uint deadline
1717     ) external returns (uint amountA, uint amountB, uint liquidity);
1718     function addLiquidityETH(
1719         address token,
1720         uint amountTokenDesired,
1721         uint amountTokenMin,
1722         uint amountETHMin,
1723         address to,
1724         uint deadline
1725     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1726     function removeLiquidity(
1727         address tokenA,
1728         address tokenB,
1729         uint liquidity,
1730         uint amountAMin,
1731         uint amountBMin,
1732         address to,
1733         uint deadline
1734     ) external returns (uint amountA, uint amountB);
1735     function removeLiquidityETH(
1736         address token,
1737         uint liquidity,
1738         uint amountTokenMin,
1739         uint amountETHMin,
1740         address to,
1741         uint deadline
1742     ) external returns (uint amountToken, uint amountETH);
1743     function removeLiquidityWithPermit(
1744         address tokenA,
1745         address tokenB,
1746         uint liquidity,
1747         uint amountAMin,
1748         uint amountBMin,
1749         address to,
1750         uint deadline,
1751         bool approveMax, uint8 v, bytes32 r, bytes32 s
1752     ) external returns (uint amountA, uint amountB);
1753     function removeLiquidityETHWithPermit(
1754         address token,
1755         uint liquidity,
1756         uint amountTokenMin,
1757         uint amountETHMin,
1758         address to,
1759         uint deadline,
1760         bool approveMax, uint8 v, bytes32 r, bytes32 s
1761     ) external returns (uint amountToken, uint amountETH);
1762     function swapExactTokensForTokens(
1763         uint amountIn,
1764         uint amountOutMin,
1765         address[] calldata path,
1766         address to,
1767         uint deadline
1768     ) external returns (uint[] memory amounts);
1769     function swapTokensForExactTokens(
1770         uint amountOut,
1771         uint amountInMax,
1772         address[] calldata path,
1773         address to,
1774         uint deadline
1775     ) external returns (uint[] memory amounts);
1776     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1777     external
1778     payable
1779     returns (uint[] memory amounts);
1780     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1781     external
1782     returns (uint[] memory amounts);
1783     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1784     external
1785     returns (uint[] memory amounts);
1786     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1787     external
1788     payable
1789     returns (uint[] memory amounts);
1790 
1791     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1792     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1793     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1794     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1795     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1796 }
1797 
1798 interface IUniswapV2Router02 is IUniswapV2Router01 {
1799     function removeLiquidityETHSupportingFeeOnTransferTokens(
1800         address token,
1801         uint liquidity,
1802         uint amountTokenMin,
1803         uint amountETHMin,
1804         address to,
1805         uint deadline
1806     ) external returns (uint amountETH);
1807     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1808         address token,
1809         uint liquidity,
1810         uint amountTokenMin,
1811         uint amountETHMin,
1812         address to,
1813         uint deadline,
1814         bool approveMax, uint8 v, bytes32 r, bytes32 s
1815     ) external returns (uint amountETH);
1816 
1817     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1818         uint amountIn,
1819         uint amountOutMin,
1820         address[] calldata path,
1821         address to,
1822         uint deadline
1823     ) external;
1824     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1825         uint amountOutMin,
1826         address[] calldata path,
1827         address to,
1828         uint deadline
1829     ) external payable;
1830     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1831         uint amountIn,
1832         uint amountOutMin,
1833         address[] calldata path,
1834         address to,
1835         uint deadline
1836     ) external;
1837 }