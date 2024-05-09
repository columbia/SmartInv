1 /*
2 
3 PumpETH
4 
5 1) 10% distribution in Ethereum
6 2) 2% swapped and added to the liquidity pool
7                                                                                    
8     _/_/_/                                        _/_/_/_/  _/_/_/_/_/  _/    _/   
9    _/    _/  _/    _/  _/_/_/  _/_/    _/_/_/    _/            _/      _/    _/    
10   _/_/_/    _/    _/  _/    _/    _/  _/    _/  _/_/_/        _/      _/_/_/_/     
11  _/        _/    _/  _/    _/    _/  _/    _/  _/            _/      _/    _/      
12 _/          _/_/_/  _/    _/    _/  _/_/_/    _/_/_/_/      _/      _/    _/       
13                                    _/                                              
14                                   _/                                               
15 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity ^0.8.4;
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 /**
173  * @dev Interface for the optional metadata functions from the ERC20 standard.
174  *
175  * _Available since v4.1._
176  */
177 interface IERC20Metadata is IERC20 {
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() external view returns (string memory);
182 
183     /**
184      * @dev Returns the symbol of the token.
185      */
186     function symbol() external view returns (string memory);
187 
188     /**
189      * @dev Returns the decimals places of the token.
190      */
191     function decimals() external view returns (uint8);
192 }
193 
194 /**
195  * @dev Implementation of the {IERC20} interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using {_mint}.
199  * For a generic mechanism see {ERC20PresetMinterPauser}.
200  *
201  * TIP: For a detailed writeup see our guide
202  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
203  * to implement supply mechanisms].
204  *
205  * We have followed general OpenZeppelin guidelines: functions revert instead
206  * of returning `false` on failure. This behavior is nonetheless conventional
207  * and does not conflict with the expectations of ERC20 applications.
208  *
209  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
210  * This allows applications to reconstruct the allowance for all accounts just
211  * by listening to said events. Other implementations of the EIP may not emit
212  * these events, as it isn't required by the specification.
213  *
214  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
215  * functions have been added to mitigate the well-known issues around setting
216  * allowances. See {IERC20-approve}.
217  */
218 contract ERC20 is Context, IERC20, IERC20Metadata {
219     using SafeMath for uint256;
220 
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229 
230     /**
231      * @dev Sets the values for {name} and {symbol}.
232      *
233      * The default value of {decimals} is 18. To select a different value for
234      * {decimals} you should overload it.
235      *
236      * All two of these values are immutable: they can only be set once during
237      * construction.
238      */
239     constructor(string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     /**
252      * @dev Returns the symbol of the token, usually a shorter version of the
253      * name.
254      */
255     function symbol() public view virtual override returns (string memory) {
256         return _symbol;
257     }
258 
259     /**
260      * @dev Returns the number of decimals used to get its user representation.
261      * For example, if `decimals` equals `2`, a balance of `505` tokens should
262      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
263      *
264      * Tokens usually opt for a value of 18, imitating the relationship between
265      * Ether and Wei. This is the value {ERC20} uses, unless this function is
266      * overridden;
267      *
268      * NOTE: This information is only used for _display_ purposes: it in
269      * no way affects any of the arithmetic of the contract, including
270      * {IERC20-balanceOf} and {IERC20-transfer}.
271      */
272     function decimals() public view virtual override returns (uint8) {
273         return 18;
274     }
275 
276     /**
277      * @dev See {IERC20-totalSupply}.
278      */
279     function totalSupply() public view virtual override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address account) public view virtual override returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See {IERC20-transfer}.
292      *
293      * Requirements:
294      *
295      * - `recipient` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
299         _transfer(_msgSender(), recipient, amount);
300         return true;
301     }
302 
303     /**
304      * @dev See {IERC20-allowance}.
305      */
306     function allowance(address owner, address spender) public view virtual override returns (uint256) {
307         return _allowances[owner][spender];
308     }
309 
310     /**
311      * @dev See {IERC20-approve}.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function approve(address spender, uint256 amount) public virtual override returns (bool) {
318         _approve(_msgSender(), spender, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-transferFrom}.
324      *
325      * Emits an {Approval} event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of {ERC20}.
327      *
328      * Requirements:
329      *
330      * - `sender` and `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      * - the caller must have allowance for ``sender``'s tokens of at least
333      * `amount`.
334      */
335     function transferFrom(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) public virtual override returns (bool) {
340         _transfer(sender, recipient, amount);
341         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
342         return true;
343     }
344 
345     /**
346      * @dev Atomically increases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to {approve} that can be used as a mitigation for
349      * problems described in {IERC20-approve}.
350      *
351      * Emits an {Approval} event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
358         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
359         return true;
360     }
361 
362     /**
363      * @dev Atomically decreases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      * - `spender` must have allowance for the caller of at least
374      * `subtractedValue`.
375      */
376     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
377         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
378         return true;
379     }
380 
381     /**
382      * @dev Moves tokens `amount` from `sender` to `recipient`.
383      *
384      * This is internal function is equivalent to {transfer}, and can be used to
385      * e.g. implement automatic token fees, slashing mechanisms, etc.
386      *
387      * Emits a {Transfer} event.
388      *
389      * Requirements:
390      *
391      * - `sender` cannot be the zero address.
392      * - `recipient` cannot be the zero address.
393      * - `sender` must have a balance of at least `amount`.
394      */
395     function _transfer(
396         address sender,
397         address recipient,
398         uint256 amount
399     ) internal virtual {
400         require(sender != address(0), "ERC20: transfer from the zero address");
401         require(recipient != address(0), "ERC20: transfer to the zero address");
402 
403         _beforeTokenTransfer(sender, recipient, amount);
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
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply = _totalSupply.add(amount);
425         _balances[account] = _balances[account].add(amount);
426         emit Transfer(address(0), account, amount);
427     }
428 
429     /**
430      * @dev Destroys `amount` tokens from `account`, reducing the
431      * total supply.
432      *
433      * Emits a {Transfer} event with `to` set to the zero address.
434      *
435      * Requirements:
436      *
437      * - `account` cannot be the zero address.
438      * - `account` must have at least `amount` tokens.
439      */
440     function _burn(address account, uint256 amount) internal virtual {
441         require(account != address(0), "ERC20: burn from the zero address");
442 
443         _beforeTokenTransfer(account, address(0), amount);
444 
445         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
446         _totalSupply = _totalSupply.sub(amount);
447         emit Transfer(account, address(0), amount);
448     }
449 
450     /**
451      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
452      *
453      * This internal function is equivalent to `approve`, and can be used to
454      * e.g. set automatic allowances for certain subsystems, etc.
455      *
456      * Emits an {Approval} event.
457      *
458      * Requirements:
459      *
460      * - `owner` cannot be the zero address.
461      * - `spender` cannot be the zero address.
462      */
463     function _approve(
464         address owner,
465         address spender,
466         uint256 amount
467     ) internal virtual {
468         require(owner != address(0), "ERC20: approve from the zero address");
469         require(spender != address(0), "ERC20: approve to the zero address");
470 
471         _allowances[owner][spender] = amount;
472         emit Approval(owner, spender, amount);
473     }
474 
475     /**
476      * @dev Hook that is called before any transfer of tokens. This includes
477      * minting and burning.
478      *
479      * Calling conditions:
480      *
481      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
482      * will be to transferred to `to`.
483      * - when `from` is zero, `amount` tokens will be minted for `to`.
484      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
485      * - `from` and `to` are never both zero.
486      *
487      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
488      */
489     function _beforeTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 }
495 
496 library SafeMath {
497     /**
498      * @dev Returns the addition of two unsigned integers, reverting on
499      * overflow.
500      *
501      * Counterpart to Solidity's `+` operator.
502      *
503      * Requirements:
504      *
505      * - Addition cannot overflow.
506      */
507     function add(uint256 a, uint256 b) internal pure returns (uint256) {
508         uint256 c = a + b;
509         require(c >= a, "SafeMath: addition overflow");
510 
511         return c;
512     }
513 
514     /**
515      * @dev Returns the subtraction of two unsigned integers, reverting on
516      * overflow (when the result is negative).
517      *
518      * Counterpart to Solidity's `-` operator.
519      *
520      * Requirements:
521      *
522      * - Subtraction cannot overflow.
523      */
524     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
525         return sub(a, b, "SafeMath: subtraction overflow");
526     }
527 
528     /**
529      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
530      * overflow (when the result is negative).
531      *
532      * Counterpart to Solidity's `-` operator.
533      *
534      * Requirements:
535      *
536      * - Subtraction cannot overflow.
537      */
538     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
539         require(b <= a, errorMessage);
540         uint256 c = a - b;
541 
542         return c;
543     }
544 
545     /**
546      * @dev Returns the multiplication of two unsigned integers, reverting on
547      * overflow.
548      *
549      * Counterpart to Solidity's `*` operator.
550      *
551      * Requirements:
552      *
553      * - Multiplication cannot overflow.
554      */
555     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
556         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
557         // benefit is lost if 'b' is also tested.
558         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
559         if (a == 0) {
560             return 0;
561         }
562 
563         uint256 c = a * b;
564         require(c / a == b, "SafeMath: multiplication overflow");
565 
566         return c;
567     }
568 
569     /**
570      * @dev Returns the integer division of two unsigned integers. Reverts on
571      * division by zero. The result is rounded towards zero.
572      *
573      * Counterpart to Solidity's `/` operator. Note: this function uses a
574      * `revert` opcode (which leaves remaining gas untouched) while Solidity
575      * uses an invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function div(uint256 a, uint256 b) internal pure returns (uint256) {
582         return div(a, b, "SafeMath: division by zero");
583     }
584 
585     /**
586      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
587      * division by zero. The result is rounded towards zero.
588      *
589      * Counterpart to Solidity's `/` operator. Note: this function uses a
590      * `revert` opcode (which leaves remaining gas untouched) while Solidity
591      * uses an invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
598         require(b > 0, errorMessage);
599         uint256 c = a / b;
600         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
601 
602         return c;
603     }
604 
605     /**
606      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
607      * Reverts when dividing by zero.
608      *
609      * Counterpart to Solidity's `%` operator. This function uses a `revert`
610      * opcode (which leaves remaining gas untouched) while Solidity uses an
611      * invalid opcode to revert (consuming all remaining gas).
612      *
613      * Requirements:
614      *
615      * - The divisor cannot be zero.
616      */
617     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
618         return mod(a, b, "SafeMath: modulo by zero");
619     }
620 
621     /**
622      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
623      * Reverts with custom message when dividing by zero.
624      *
625      * Counterpart to Solidity's `%` operator. This function uses a `revert`
626      * opcode (which leaves remaining gas untouched) while Solidity uses an
627      * invalid opcode to revert (consuming all remaining gas).
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
634         require(b != 0, errorMessage);
635         return a % b;
636     }
637 }
638 
639 /**
640  * @title SafeMathInt
641  * @dev Math operations for int256 with overflow safety checks.
642  */
643 library SafeMathInt {
644     int256 private constant MIN_INT256 = int256(1) << 255;
645     int256 private constant MAX_INT256 = ~(int256(1) << 255);
646 
647     /**
648      * @dev Multiplies two int256 variables and fails on overflow.
649      */
650     function mul(int256 a, int256 b) internal pure returns (int256) {
651         int256 c = a * b;
652 
653         // Detect overflow when multiplying MIN_INT256 with -1
654         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
655         require((b == 0) || (c / b == a));
656         return c;
657     }
658 
659     /**
660      * @dev Division of two int256 variables and fails on overflow.
661      */
662     function div(int256 a, int256 b) internal pure returns (int256) {
663         // Prevent overflow when dividing MIN_INT256 by -1
664         require(b != -1 || a != MIN_INT256);
665 
666         // Solidity already throws when dividing by 0.
667         return a / b;
668     }
669 
670     /**
671      * @dev Subtracts two int256 variables and fails on overflow.
672      */
673     function sub(int256 a, int256 b) internal pure returns (int256) {
674         int256 c = a - b;
675         require((b >= 0 && c <= a) || (b < 0 && c > a));
676         return c;
677     }
678 
679     /**
680      * @dev Adds two int256 variables and fails on overflow.
681      */
682     function add(int256 a, int256 b) internal pure returns (int256) {
683         int256 c = a + b;
684         require((b >= 0 && c >= a) || (b < 0 && c < a));
685         return c;
686     }
687 
688     /**
689      * @dev Converts to absolute value, and fails on overflow.
690      */
691     function abs(int256 a) internal pure returns (int256) {
692         require(a != MIN_INT256);
693         return a < 0 ? -a : a;
694     }
695 
696 
697     function toUint256Safe(int256 a) internal pure returns (uint256) {
698         require(a >= 0);
699         return uint256(a);
700     }
701 }
702 
703 /**
704  * @title SafeMathUint
705  * @dev Math operations with safety checks that revert on error
706  */
707 library SafeMathUint {
708     function toInt256Safe(uint256 a) internal pure returns (int256) {
709         int256 b = int256(a);
710         require(b >= 0);
711         return b;
712     }
713 }
714 
715 contract PumpETH is ERC20, Ownable {
716     using SafeMath for uint256;
717 
718     IUniswapV2Router02 public uniswapV2Router;
719     address public immutable uniswapV2Pair;
720 
721     bool private liquidating;
722 
723     PumpETHDividendTracker public dividendTracker;
724     
725     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
726     address public liquidityWallet;
727 
728     uint256 public MAX_SELL_TRANSACTION_AMOUNT = 250000000 * (10**18); // 250 Million (0.5%)
729 
730     uint256 public ETH_REWARDS_FEE = 10;
731     uint256 public LIQUIDITY_FEE = 2;
732     uint256 public TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
733 
734     // use by default 150,000 gas to process auto-claiming dividends
735     uint256 public gasForProcessing = 150000;
736 
737     // liquidate tokens for ETH when the contract reaches 100k tokens by default
738     uint256 public liquidateTokensAtAmount = 50000 * (10**18); // 50 Thousand (0.0001%);
739 
740     // whether the token can already be traded
741     bool public tradingEnabled;
742 
743     function activateTrading() public onlyOwner {
744         require(!tradingEnabled, "PumpETH: Trading is already enabled");
745         tradingEnabled = true;
746     }
747 
748     // exclude from fees and max transaction amount
749     mapping (address => bool) private _isExcludedFromFees;
750 
751     // addresses that can make transfers before presale is over
752     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
753 
754     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
755     // could be subject to a maximum transfer amount
756     mapping (address => bool) public automatedMarketMakerPairs;
757 
758     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
759 
760     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
761 
762     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
763     
764     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
765 
766     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
767 
768     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
769 
770     event Liquified(
771         uint256 tokensSwapped,
772         uint256 ethReceived,
773         uint256 tokensIntoLiqudity
774     );
775 
776     event SentDividends(
777         uint256 tokensSwapped,
778         uint256 amount
779     );
780 
781     event ProcessedDividendTracker(
782         uint256 iterations,
783         uint256 claims,
784         uint256 lastProcessedIndex,
785         bool indexed automatic,
786         uint256 gas,
787         address indexed processor
788     );
789 
790     constructor() ERC20("PumpETH", "PumpETH") {
791         assert(TOTAL_FEES == 12);
792 
793         dividendTracker = new PumpETHDividendTracker();
794         liquidityWallet = owner();
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
808         dividendTracker.excludeFromDividends(address(this));
809         dividendTracker.excludeFromDividends(owner());
810         dividendTracker.excludeFromDividends(deadAddress);
811 
812         // exclude from paying fees or having max transaction amount
813         excludeFromFees(address(this), true);
814         excludeFromFees(liquidityWallet, true);
815 
816         // enable owner wallet to send tokens before presales are over.
817         canTransferBeforeTradingIsEnabled[owner()] = true;
818 
819         /*
820             _mint is an internal function in ERC20.sol that is only called here,
821             and CANNOT be called ever again
822         */
823         _mint(owner(), 50000000000 * (10**18)); // 50 Billion (100%)
824     }
825 
826     receive() external payable {}
827     
828     function prepareForPresale() external onlyOwner {
829         ETH_REWARDS_FEE = 0;
830         LIQUIDITY_FEE = 0;
831         TOTAL_FEES = 0;
832     }
833     
834     function afterPresale() external onlyOwner {
835         ETH_REWARDS_FEE = 10;
836         LIQUIDITY_FEE = 2;
837         TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
838     }
839     
840   	function whitelistDxSale(address _presaleAddress, address _routerAddress) public onlyOwner {
841         dividendTracker.excludeFromDividends(_presaleAddress);
842         excludeFromFees(_presaleAddress, true);
843 
844         dividendTracker.excludeFromDividends(_routerAddress);
845         excludeFromFees(_routerAddress, true);
846   	}
847 
848     function updateDividendTracker(address newAddress) public onlyOwner {
849         require(newAddress != address(dividendTracker), "PumpETH: The dividend tracker already has that address");
850 
851         PumpETHDividendTracker newDividendTracker = PumpETHDividendTracker(payable(newAddress));
852 
853         require(newDividendTracker.owner() == address(this), "PumpETH: The new dividend tracker must be owned by the PumpETH token contract");
854 
855         newDividendTracker.excludeFromDividends(address(newDividendTracker));
856         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
857         newDividendTracker.excludeFromDividends(address(deadAddress));
858 
859         emit UpdatedDividendTracker(newAddress, address(dividendTracker));
860 
861         dividendTracker = newDividendTracker;
862     }
863 
864     function updateUniswapV2Router(address newAddress) public onlyOwner {
865         require(newAddress != address(uniswapV2Router), "PumpETH: The router already has that address");
866         emit UpdatedUniswapV2Router(newAddress, address(uniswapV2Router));
867         uniswapV2Router = IUniswapV2Router02(newAddress);
868     }
869 
870     function excludeFromFees(address account, bool value) public onlyOwner {
871         require(!_isExcludedFromFees[account], "PumpETH: Account is already excluded from fees");
872         _isExcludedFromFees[account] = value;
873     }
874     
875     function excludeFromDividends(address account) public onlyOwner {
876         dividendTracker.excludeFromDividends(account);
877     }
878     
879     function setMaxSellTransactionAmount(uint256 amount) external onlyOwner {
880         MAX_SELL_TRANSACTION_AMOUNT = amount * (10**18);   
881     }
882   	
883   	function setEthRewardsFee(uint256 amount) external onlyOwner {
884   	    require(amount >= 0 && amount <= 100, "PumpETH: Rewards fee must be between 0 (0%) and 100 (100%)");
885   	    ETH_REWARDS_FEE = amount;
886   	    TOTAL_FEES = LIQUIDITY_FEE + ETH_REWARDS_FEE;
887   	}
888   	
889   	function setLiquidityFee(uint256 amount) external onlyOwner {
890   	    require(amount >= 0 && amount <= 100, "PumpETH: Liquidity fee must be between 0 (0%) and 100 (100%)");
891   	    LIQUIDITY_FEE = amount;
892   	    TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
893   	}
894 
895     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
896         require(pair != uniswapV2Pair, "PumpETH: The Uniswap pair cannot be removed from automatedMarketMakerPairs");
897 
898         _setAutomatedMarketMakerPair(pair, value);
899     }
900 
901     function _setAutomatedMarketMakerPair(address pair, bool value) private {
902         require(automatedMarketMakerPairs[pair] != value, "PumpETH: Automated market maker pair is already set to that value");
903         automatedMarketMakerPairs[pair] = value;
904 
905         if (value) {
906             dividendTracker.excludeFromDividends(pair);
907         }
908 
909         emit SetAutomatedMarketMakerPair(pair, value);
910     }
911 
912     function allowTransferBeforeTradingIsEnabled(address account) public onlyOwner {
913         require(!canTransferBeforeTradingIsEnabled[account], "PumpETH: Account is already allowed to transfer before trading is enabled");
914         canTransferBeforeTradingIsEnabled[account] = true;
915     }
916     
917     function updateLiquidityWallet(address newLiquidityWallet) public onlyOwner {
918         require(newLiquidityWallet != liquidityWallet, "PumpETH: This address is already the liquidity wallet");
919         excludeFromFees(newLiquidityWallet, true);
920         emit LiquidityWalletUpdated(newLiquidityWallet, liquidityWallet);
921         liquidityWallet = newLiquidityWallet;
922     }
923 
924     function updateGasForProcessing(uint256 newValue) public onlyOwner {
925         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
926         require(newValue != gasForProcessing, "PumpETH: Cannot update gasForProcessing to same value");
927         emit GasForProcessingUpdated(newValue, gasForProcessing);
928         gasForProcessing = newValue;
929     }
930 
931     function updateLiquidationThreshold(uint256 newValue) external onlyOwner {
932         require(newValue != liquidateTokensAtAmount, "PumpETH: Cannot update gasForProcessing to same value");
933         emit LiquidationThresholdUpdated(newValue, liquidateTokensAtAmount);
934         liquidateTokensAtAmount = newValue;
935     }
936 
937     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
938         dividendTracker.updateGasForTransfer(gasForTransfer);
939     }
940 
941     function updateClaimWait(uint256 claimWait) external onlyOwner {
942         dividendTracker.updateClaimWait(claimWait);
943     }
944 
945     function getGasForTransfer() external view returns(uint256) {
946         return dividendTracker.gasForTransfer();
947     }
948 
949     function getClaimWait() external view returns(uint256) {
950         return dividendTracker.claimWait();
951     }
952 
953     function getTotalDividendsDistributed() external view returns (uint256) {
954         return dividendTracker.totalDividendsDistributed();
955     }
956 
957     function isExcludedFromFees(address account) public view returns(bool) {
958         return _isExcludedFromFees[account];
959     }
960 
961     function withdrawableDividendOf(address account) public view returns(uint256) {
962         return dividendTracker.withdrawableDividendOf(account);
963     }
964 
965     function dividendTokenBalanceOf(address account) public view returns (uint256) {
966         return dividendTracker.balanceOf(account);
967     }
968 
969     function getAccountDividendsInfo(address account)
970     external view returns (
971         address,
972         int256,
973         int256,
974         uint256,
975         uint256,
976         uint256,
977         uint256,
978         uint256) {
979         return dividendTracker.getAccount(account);
980     }
981 
982     function getAccountDividendsInfoAtIndex(uint256 index)
983     external view returns (
984         address,
985         int256,
986         int256,
987         uint256,
988         uint256,
989         uint256,
990         uint256,
991         uint256) {
992         return dividendTracker.getAccountAtIndex(index);
993     }
994 
995     function processDividendTracker(uint256 gas) external {
996         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
997         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
998     }
999 
1000     function claim() external {
1001         dividendTracker.processAccount(payable(msg.sender), false);
1002     }
1003 
1004     function getLastProcessedIndex() external view returns(uint256) {
1005         return dividendTracker.getLastProcessedIndex();
1006     }
1007 
1008     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1009         return dividendTracker.getNumberOfTokenHolders();
1010     }
1011 
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 amount
1016     ) internal override {
1017         require(from != address(0), "ERC20: transfer from the zero address");
1018         require(to != address(0), "ERC20: transfer to the zero address");
1019 
1020         bool tradingIsEnabled = tradingEnabled;
1021 
1022         // only whitelisted addresses can make transfers before the public presale is over.
1023         if (!tradingIsEnabled) {
1024             require(canTransferBeforeTradingIsEnabled[from], "PumpETH: This account cannot send tokens until trading is enabled");
1025         }
1026 
1027         if (amount == 0) {
1028             super._transfer(from, to, 0);
1029             return;
1030         }
1031 
1032         if (!liquidating &&
1033             tradingIsEnabled &&
1034             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1035             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1036             !_isExcludedFromFees[to] //no max tx-amount and wallet token amount for those excluded from fees
1037         ) {
1038             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1039         }
1040 
1041         uint256 contractTokenBalance = balanceOf(address(this));
1042 
1043         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1044 
1045         if (tradingIsEnabled &&
1046             canSwap &&
1047             !liquidating &&
1048             !automatedMarketMakerPairs[from] &&
1049             from != address(this) &&
1050             to != address(this)
1051         ) {
1052             liquidating = true;
1053 
1054             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1055             swapAndLiquify(swapTokens);
1056 
1057             uint256 sellTokens = balanceOf(address(this));
1058             swapAndSendDividends(sellTokens);
1059 
1060             liquidating = false;
1061         }
1062 
1063         bool takeFee = tradingIsEnabled && !liquidating;
1064 
1065         // if any account belongs to _isExcludedFromFee account then remove the fee
1066         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1067             takeFee = false;
1068         }
1069 
1070         if (takeFee) {
1071             uint256 fees = amount.div(100).mul(TOTAL_FEES);
1072             amount = amount.sub(fees);
1073 
1074         }
1075 
1076         super._transfer(from, to, amount);
1077 
1078         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1079         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1080 
1081         if (!liquidating) {
1082             uint256 gas = gasForProcessing;
1083 
1084             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1085                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1086             } catch {
1087 
1088             }
1089         }
1090     }
1091 
1092     function swapAndLiquify(uint256 tokens) private {
1093         // split the contract balance into halves
1094         uint256 half = tokens.div(2);
1095         uint256 otherHalf = tokens.sub(half);
1096 
1097         // capture the contract's current ETH balance.
1098         // this is so that we can capture exactly the amount of ETH that the
1099         // swap creates, and not make the liquidity event include any ETH that
1100         // has been manually sent to the contract
1101         uint256 initialBalance = address(this).balance;
1102 
1103         // swap tokens for ETH
1104         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1105 
1106         // how much ETH did we just swap into?
1107         uint256 newBalance = address(this).balance.sub(initialBalance);
1108 
1109         // add liquidity to uniswap
1110         addLiquidity(otherHalf, newBalance);
1111 
1112         emit Liquified(half, newBalance, otherHalf);
1113     }
1114 
1115     function swapTokensForEth(uint256 tokenAmount) private {
1116         // generate the uniswap pair path of token -> weth
1117         address[] memory path = new address[](2);
1118         path[0] = address(this);
1119         path[1] = uniswapV2Router.WETH();
1120 
1121         _approve(address(this), address(uniswapV2Router), tokenAmount);
1122 
1123         // make the swap
1124         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1125             tokenAmount,
1126             0, // accept any amount of ETH
1127             path,
1128             address(this),
1129             block.timestamp
1130         );
1131     }
1132 
1133     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1134         // approve token transfer to cover all possible scenarios
1135         _approve(address(this), address(uniswapV2Router), tokenAmount);
1136 
1137         // add the liquidity
1138         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1139             address(this),
1140             tokenAmount,
1141             0, // slippage is unavoidable
1142             0, // slippage is unavoidable
1143             liquidityWallet,
1144             block.timestamp
1145         );
1146     }
1147 
1148     function swapAndSendDividends(uint256 tokens) private {
1149         swapTokensForEth(tokens);
1150         uint256 dividends = address(this).balance;
1151 
1152         (bool success,) = address(dividendTracker).call{value: dividends}("");
1153         if (success) {
1154             emit SentDividends(tokens, dividends);
1155         }
1156     }
1157 }
1158 
1159 /// @title Dividend-Paying Token Interface
1160 /// @author Roger Wu (https://github.com/roger-wu)
1161 /// @dev An interface for a dividend-paying token contract.
1162 interface DividendPayingTokenInterface {
1163     /// @notice View the amount of dividend in wei that an address can withdraw.
1164     /// @param _owner The address of a token holder.
1165     /// @return The amount of dividend in wei that `_owner` can withdraw.
1166     function dividendOf(address _owner) external view returns(uint256);
1167 
1168     /// @notice Distributes ether to token holders as dividends.
1169     /// @dev SHOULD distribute the paid ether to token holders as dividends.
1170     ///  SHOULD NOT directly transfer ether to token holders in this function.
1171     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
1172     function distributeDividends() external payable;
1173 
1174     /// @notice Withdraws the ether distributed to the sender.
1175     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
1176     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
1177     function withdrawDividend() external;
1178 
1179     /// @dev This event MUST emit when ether is distributed to token holders.
1180     /// @param from The address which sends ether to this contract.
1181     /// @param weiAmount The amount of distributed ether in wei.
1182     event DividendsDistributed(
1183         address indexed from,
1184         uint256 weiAmount
1185     );
1186 
1187     /// @dev This event MUST emit when an address withdraws their dividend.
1188     /// @param to The address which withdraws ether from this contract.
1189     /// @param weiAmount The amount of withdrawn ether in wei.
1190     event DividendWithdrawn(
1191         address indexed to,
1192         uint256 weiAmount
1193     );
1194 }
1195 
1196 /// @title Dividend-Paying Token Optional Interface
1197 /// @author Roger Wu (https://github.com/roger-wu)
1198 /// @dev OPTIONAL functions for a dividend-paying token contract.
1199 interface DividendPayingTokenOptionalInterface {
1200     /// @notice View the amount of dividend in wei that an address can withdraw.
1201     /// @param _owner The address of a token holder.
1202     /// @return The amount of dividend in wei that `_owner` can withdraw.
1203     function withdrawableDividendOf(address _owner) external view returns(uint256);
1204 
1205     /// @notice View the amount of dividend in wei that an address has withdrawn.
1206     /// @param _owner The address of a token holder.
1207     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1208     function withdrawnDividendOf(address _owner) external view returns(uint256);
1209 
1210     /// @notice View the amount of dividend in wei that an address has earned in total.
1211     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1212     /// @param _owner The address of a token holder.
1213     /// @return The amount of dividend in wei that `_owner` has earned in total.
1214     function accumulativeDividendOf(address _owner) external view returns(uint256);
1215 }
1216 
1217 /// @title Dividend-Paying Token
1218 /// @author Roger Wu (https://github.com/roger-wu)
1219 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1220 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1221 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1222 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1223     using SafeMath for uint256;
1224     using SafeMathUint for uint256;
1225     using SafeMathInt for int256;
1226 
1227     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1228     // For more discussion about choosing the value of `magnitude`,
1229     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1230     uint256 constant internal magnitude = 2**128;
1231 
1232     uint256 internal magnifiedDividendPerShare;
1233 
1234     // About dividendCorrection:
1235     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1236     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1237     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1238     //   `dividendOf(_user)` should not be changed,
1239     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1240     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1241     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1242     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1243     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1244     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1245     mapping(address => int256) internal magnifiedDividendCorrections;
1246     mapping(address => uint256) internal withdrawnDividends;
1247 
1248     // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1249     uint256 public gasForTransfer;
1250 
1251     uint256 public totalDividendsDistributed;
1252 
1253     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1254         gasForTransfer = 3000;
1255     }
1256 
1257     /// @dev Distributes dividends whenever ether is paid to this contract.
1258     receive() external payable {
1259         distributeDividends();
1260     }
1261 
1262     /// @notice Distributes ether to token holders as dividends.
1263     /// @dev It reverts if the total supply of tokens is 0.
1264     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1265     /// About undistributed ether:
1266     ///   In each distribution, there is a small amount of ether not distributed,
1267     ///     the magnified amount of which is
1268     ///     `(msg.value * magnitude) % totalSupply()`.
1269     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1270     ///     (de-magnified) in a distribution can be less than 1 wei.
1271     ///   We can actually keep track of the undistributed ether in a distribution
1272     ///     and try to distribute it in the next distribution,
1273     ///     but keeping track of such data on-chain costs much more than
1274     ///     the saved ether, so we don't do that.
1275     function distributeDividends() public override payable {
1276         require(totalSupply() > 0);
1277 
1278         if (msg.value > 0) {
1279             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1280                 (msg.value).mul(magnitude) / totalSupply()
1281             );
1282             emit DividendsDistributed(msg.sender, msg.value);
1283 
1284             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1285         }
1286     }
1287 
1288     /// @notice Withdraws the ether distributed to the sender.
1289     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1290     function withdrawDividend() public virtual override {
1291         _withdrawDividendOfUser(payable(msg.sender));
1292     }
1293 
1294     /// @notice Withdraws the ether distributed to the sender.
1295     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1296     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1297         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1298         if (_withdrawableDividend > 0) {
1299             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1300             emit DividendWithdrawn(user, _withdrawableDividend);
1301             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
1302 
1303             if(!success) {
1304                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1305                 return 0;
1306             }
1307 
1308             return _withdrawableDividend;
1309         }
1310 
1311         return 0;
1312     }
1313 
1314     /// @notice View the amount of dividend in wei that an address can withdraw.
1315     /// @param _owner The address of a token holder.
1316     /// @return The amount of dividend in wei that `_owner` can withdraw.
1317     function dividendOf(address _owner) public view override returns(uint256) {
1318         return withdrawableDividendOf(_owner);
1319     }
1320 
1321     /// @notice View the amount of dividend in wei that an address can withdraw.
1322     /// @param _owner The address of a token holder.
1323     /// @return The amount of dividend in wei that `_owner` can withdraw.
1324     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1325         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1326     }
1327 
1328     /// @notice View the amount of dividend in wei that an address has withdrawn.
1329     /// @param _owner The address of a token holder.
1330     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1331     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1332         return withdrawnDividends[_owner];
1333     }
1334 
1335 
1336     /// @notice View the amount of dividend in wei that an address has earned in total.
1337     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1338     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1339     /// @param _owner The address of a token holder.
1340     /// @return The amount of dividend in wei that `_owner` has earned in total.
1341     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1342         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1343         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1344     }
1345 
1346     /// @dev Internal function that transfer tokens from one address to another.
1347     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1348     /// @param from The address to transfer from.
1349     /// @param to The address to transfer to.
1350     /// @param value The amount to be transferred.
1351     function _transfer(address from, address to, uint256 value) internal virtual override {
1352         require(false);
1353 
1354         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1355         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1356         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1357     }
1358 
1359     /// @dev Internal function that mints tokens to an account.
1360     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1361     /// @param account The account that will receive the created tokens.
1362     /// @param value The amount that will be created.
1363     function _mint(address account, uint256 value) internal override {
1364         super._mint(account, value);
1365 
1366         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1367         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1368     }
1369 
1370     /// @dev Internal function that burns an amount of the token of a given account.
1371     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1372     /// @param account The account whose tokens will be burnt.
1373     /// @param value The amount that will be burnt.
1374     function _burn(address account, uint256 value) internal override {
1375         super._burn(account, value);
1376 
1377         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1378         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1379     }
1380 
1381     function _setBalance(address account, uint256 newBalance) internal {
1382         uint256 currentBalance = balanceOf(account);
1383 
1384         if(newBalance > currentBalance) {
1385             uint256 mintAmount = newBalance.sub(currentBalance);
1386             _mint(account, mintAmount);
1387         } else if(newBalance < currentBalance) {
1388             uint256 burnAmount = currentBalance.sub(newBalance);
1389             _burn(account, burnAmount);
1390         }
1391     }
1392 }
1393 
1394 contract PumpETHDividendTracker is DividendPayingToken, Ownable {
1395     using SafeMath for uint256;
1396     using SafeMathInt for int256;
1397     using IterableMapping for IterableMapping.Map;
1398 
1399     IterableMapping.Map private tokenHoldersMap;
1400     uint256 public lastProcessedIndex;
1401 
1402     mapping (address => bool) public excludedFromDividends;
1403 
1404     mapping (address => uint256) public lastClaimTimes;
1405 
1406     uint256 public claimWait;
1407     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 200000 * (10**18); // Must hold 200,000+ tokens.
1408 
1409     event ExcludedFromDividends(address indexed account);
1410     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1411     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1412 
1413     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1414 
1415     constructor() DividendPayingToken("PumpETH_Dividend_Tracker", "PumpETH_Dividend_Tracker") {
1416         claimWait = 43200; // 12 hours
1417     }
1418 
1419     function _transfer(address, address, uint256) internal pure override {
1420         require(false, "PumpETH_Dividend_Tracker: No transfers allowed");
1421     }
1422 
1423     function withdrawDividend() public pure override {
1424         require(false, "PumpETH_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main PumpETH contract.");
1425     }
1426 
1427     function excludeFromDividends(address account) external onlyOwner {
1428         require(!excludedFromDividends[account]);
1429         excludedFromDividends[account] = true;
1430 
1431         _setBalance(account, 0);
1432         tokenHoldersMap.remove(account);
1433 
1434         emit ExcludedFromDividends(account);
1435     }
1436 
1437     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1438         require(newGasForTransfer != gasForTransfer, "PumpETH_Dividend_Tracker: Cannot update gasForTransfer to same value");
1439         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1440         gasForTransfer = newGasForTransfer;
1441     }
1442 
1443     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1444         require(newClaimWait >= 3600 && newClaimWait <= 86400, "PumpETH_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1445         require(newClaimWait != claimWait, "PumpETH_Dividend_Tracker: Cannot update claimWait to same value");
1446         emit ClaimWaitUpdated(newClaimWait, claimWait);
1447         claimWait = newClaimWait;
1448     }
1449 
1450     function getLastProcessedIndex() external view returns(uint256) {
1451         return lastProcessedIndex;
1452     }
1453 
1454     function getNumberOfTokenHolders() external view returns(uint256) {
1455         return tokenHoldersMap.keys.length;
1456     }
1457 
1458     function getAccount(address _account)
1459     public view returns (
1460         address account,
1461         int256 index,
1462         int256 iterationsUntilProcessed,
1463         uint256 withdrawableDividends,
1464         uint256 totalDividends,
1465         uint256 lastClaimTime,
1466         uint256 nextClaimTime,
1467         uint256 secondsUntilAutoClaimAvailable) {
1468         account = _account;
1469 
1470         index = tokenHoldersMap.getIndexOfKey(account);
1471 
1472         iterationsUntilProcessed = -1;
1473 
1474         if (index >= 0) {
1475             if (uint256(index) > lastProcessedIndex) {
1476                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1477             } else {
1478                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1479                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1480             }
1481         }
1482 
1483         withdrawableDividends = withdrawableDividendOf(account);
1484         totalDividends = accumulativeDividendOf(account);
1485 
1486         lastClaimTime = lastClaimTimes[account];
1487         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1488         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1489     }
1490 
1491     function getAccountAtIndex(uint256 index)
1492     public view returns (
1493         address,
1494         int256,
1495         int256,
1496         uint256,
1497         uint256,
1498         uint256,
1499         uint256,
1500         uint256) {
1501         if (index >= tokenHoldersMap.size()) {
1502             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1503         }
1504 
1505         address account = tokenHoldersMap.getKeyAtIndex(index);
1506         return getAccount(account);
1507     }
1508 
1509     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1510         if (lastClaimTime > block.timestamp)  {
1511             return false;
1512         }
1513         return block.timestamp.sub(lastClaimTime) >= claimWait;
1514     }
1515 
1516     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1517         if (excludedFromDividends[account]) {
1518             return;
1519         }
1520 
1521         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1522             _setBalance(account, newBalance);
1523             tokenHoldersMap.set(account, newBalance);
1524         } else {
1525             _setBalance(account, 0);
1526             tokenHoldersMap.remove(account);
1527         }
1528 
1529         processAccount(account, true);
1530     }
1531 
1532     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1533         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1534 
1535         if (numberOfTokenHolders == 0) {
1536             return (0, 0, lastProcessedIndex);
1537         }
1538 
1539         uint256 _lastProcessedIndex = lastProcessedIndex;
1540 
1541         uint256 gasUsed = 0;
1542         uint256 gasLeft = gasleft();
1543 
1544         uint256 iterations = 0;
1545         uint256 claims = 0;
1546 
1547         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1548             _lastProcessedIndex++;
1549 
1550             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1551                 _lastProcessedIndex = 0;
1552             }
1553 
1554             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1555 
1556             if (canAutoClaim(lastClaimTimes[account])) {
1557                 if (processAccount(payable(account), true)) {
1558                     claims++;
1559                 }
1560             }
1561 
1562             iterations++;
1563 
1564             uint256 newGasLeft = gasleft();
1565 
1566             if (gasLeft > newGasLeft) {
1567                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1568             }
1569 
1570             gasLeft = newGasLeft;
1571         }
1572 
1573         lastProcessedIndex = _lastProcessedIndex;
1574 
1575         return (iterations, claims, lastProcessedIndex);
1576     }
1577 
1578     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1579         uint256 amount = _withdrawDividendOfUser(account);
1580 
1581         if (amount > 0) {
1582             lastClaimTimes[account] = block.timestamp;
1583             emit Claim(account, amount, automatic);
1584             return true;
1585         }
1586 
1587         return false;
1588     }
1589 }
1590 
1591 library IterableMapping {
1592     // Iterable mapping from address to uint;
1593     struct Map {
1594         address[] keys;
1595         mapping(address => uint) values;
1596         mapping(address => uint) indexOf;
1597         mapping(address => bool) inserted;
1598     }
1599 
1600     function get(Map storage map, address key) public view returns (uint) {
1601         return map.values[key];
1602     }
1603 
1604     function getIndexOfKey(Map storage map, address key) public view returns (int) {
1605         if(!map.inserted[key]) {
1606             return -1;
1607         }
1608         return int(map.indexOf[key]);
1609     }
1610 
1611     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
1612         return map.keys[index];
1613     }
1614 
1615     function size(Map storage map) public view returns (uint) {
1616         return map.keys.length;
1617     }
1618 
1619     function set(Map storage map, address key, uint val) public {
1620         if (map.inserted[key]) {
1621             map.values[key] = val;
1622         } else {
1623             map.inserted[key] = true;
1624             map.values[key] = val;
1625             map.indexOf[key] = map.keys.length;
1626             map.keys.push(key);
1627         }
1628     }
1629 
1630     function remove(Map storage map, address key) public {
1631         if (!map.inserted[key]) {
1632             return;
1633         }
1634 
1635         delete map.inserted[key];
1636         delete map.values[key];
1637 
1638         uint index = map.indexOf[key];
1639         uint lastIndex = map.keys.length - 1;
1640         address lastKey = map.keys[lastIndex];
1641 
1642         map.indexOf[lastKey] = index;
1643         delete map.indexOf[key];
1644 
1645         map.keys[index] = lastKey;
1646         map.keys.pop();
1647     }
1648 }
1649 
1650 interface IUniswapV2Factory {
1651     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1652 
1653     function feeTo() external view returns (address);
1654     function feeToSetter() external view returns (address);
1655 
1656     function getPair(address tokenA, address tokenB) external view returns (address pair);
1657     function allPairs(uint) external view returns (address pair);
1658     function allPairsLength() external view returns (uint);
1659 
1660     function createPair(address tokenA, address tokenB) external returns (address pair);
1661 
1662     function setFeeTo(address) external;
1663     function setFeeToSetter(address) external;
1664 }
1665 
1666 interface IUniswapV2Pair {
1667     event Approval(address indexed owner, address indexed spender, uint value);
1668     event Transfer(address indexed from, address indexed to, uint value);
1669 
1670     function name() external pure returns (string memory);
1671     function symbol() external pure returns (string memory);
1672     function decimals() external pure returns (uint8);
1673     function totalSupply() external view returns (uint);
1674     function balanceOf(address owner) external view returns (uint);
1675     function allowance(address owner, address spender) external view returns (uint);
1676 
1677     function approve(address spender, uint value) external returns (bool);
1678     function transfer(address to, uint value) external returns (bool);
1679     function transferFrom(address from, address to, uint value) external returns (bool);
1680 
1681     function DOMAIN_SEPARATOR() external view returns (bytes32);
1682     function PERMIT_TYPEHASH() external pure returns (bytes32);
1683     function nonces(address owner) external view returns (uint);
1684 
1685     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1686 
1687     event Mint(address indexed sender, uint amount0, uint amount1);
1688     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1689     event Swap(
1690         address indexed sender,
1691         uint amount0In,
1692         uint amount1In,
1693         uint amount0Out,
1694         uint amount1Out,
1695         address indexed to
1696     );
1697     event Sync(uint112 reserve0, uint112 reserve1);
1698 
1699     function MINIMUM_LIQUIDITY() external pure returns (uint);
1700     function factory() external view returns (address);
1701     function token0() external view returns (address);
1702     function token1() external view returns (address);
1703     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1704     function price0CumulativeLast() external view returns (uint);
1705     function price1CumulativeLast() external view returns (uint);
1706     function kLast() external view returns (uint);
1707 
1708     function mint(address to) external returns (uint liquidity);
1709     function burn(address to) external returns (uint amount0, uint amount1);
1710     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1711     function skim(address to) external;
1712     function sync() external;
1713 
1714     function initialize(address, address) external;
1715 }
1716 
1717 interface IUniswapV2Router01 {
1718     function factory() external pure returns (address);
1719     function WETH() external pure returns (address);
1720 
1721     function addLiquidity(
1722         address tokenA,
1723         address tokenB,
1724         uint amountADesired,
1725         uint amountBDesired,
1726         uint amountAMin,
1727         uint amountBMin,
1728         address to,
1729         uint deadline
1730     ) external returns (uint amountA, uint amountB, uint liquidity);
1731     function addLiquidityETH(
1732         address token,
1733         uint amountTokenDesired,
1734         uint amountTokenMin,
1735         uint amountETHMin,
1736         address to,
1737         uint deadline
1738     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1739     function removeLiquidity(
1740         address tokenA,
1741         address tokenB,
1742         uint liquidity,
1743         uint amountAMin,
1744         uint amountBMin,
1745         address to,
1746         uint deadline
1747     ) external returns (uint amountA, uint amountB);
1748     function removeLiquidityETH(
1749         address token,
1750         uint liquidity,
1751         uint amountTokenMin,
1752         uint amountETHMin,
1753         address to,
1754         uint deadline
1755     ) external returns (uint amountToken, uint amountETH);
1756     function removeLiquidityWithPermit(
1757         address tokenA,
1758         address tokenB,
1759         uint liquidity,
1760         uint amountAMin,
1761         uint amountBMin,
1762         address to,
1763         uint deadline,
1764         bool approveMax, uint8 v, bytes32 r, bytes32 s
1765     ) external returns (uint amountA, uint amountB);
1766     function removeLiquidityETHWithPermit(
1767         address token,
1768         uint liquidity,
1769         uint amountTokenMin,
1770         uint amountETHMin,
1771         address to,
1772         uint deadline,
1773         bool approveMax, uint8 v, bytes32 r, bytes32 s
1774     ) external returns (uint amountToken, uint amountETH);
1775     function swapExactTokensForTokens(
1776         uint amountIn,
1777         uint amountOutMin,
1778         address[] calldata path,
1779         address to,
1780         uint deadline
1781     ) external returns (uint[] memory amounts);
1782     function swapTokensForExactTokens(
1783         uint amountOut,
1784         uint amountInMax,
1785         address[] calldata path,
1786         address to,
1787         uint deadline
1788     ) external returns (uint[] memory amounts);
1789     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1790     external
1791     payable
1792     returns (uint[] memory amounts);
1793     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1794     external
1795     returns (uint[] memory amounts);
1796     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1797     external
1798     returns (uint[] memory amounts);
1799     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1800     external
1801     payable
1802     returns (uint[] memory amounts);
1803 
1804     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1805     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1806     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1807     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1808     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1809 }
1810 
1811 interface IUniswapV2Router02 is IUniswapV2Router01 {
1812     function removeLiquidityETHSupportingFeeOnTransferTokens(
1813         address token,
1814         uint liquidity,
1815         uint amountTokenMin,
1816         uint amountETHMin,
1817         address to,
1818         uint deadline
1819     ) external returns (uint amountETH);
1820     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1821         address token,
1822         uint liquidity,
1823         uint amountTokenMin,
1824         uint amountETHMin,
1825         address to,
1826         uint deadline,
1827         bool approveMax, uint8 v, bytes32 r, bytes32 s
1828     ) external returns (uint amountETH);
1829 
1830     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1831         uint amountIn,
1832         uint amountOutMin,
1833         address[] calldata path,
1834         address to,
1835         uint deadline
1836     ) external;
1837     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1838         uint amountOutMin,
1839         address[] calldata path,
1840         address to,
1841         uint deadline
1842     ) external payable;
1843     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1844         uint amountIn,
1845         uint amountOutMin,
1846         address[] calldata path,
1847         address to,
1848         uint deadline
1849     ) external;
1850 }