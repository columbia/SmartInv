1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.11;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IUniswapV2Factory {
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     using SafeMath for uint256;
115 
116     mapping(address => uint256) private _balances;
117 
118     mapping(address => mapping(address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     string private _name;
123     string private _symbol;
124 
125     /**
126      * @dev Sets the values for {name} and {symbol}.
127      *
128      * The default value of {decimals} is 18. To select a different value for
129      * {decimals} you should overload it.
130      *
131      * All two of these values are immutable: they can only be set once during
132      * construction.
133      */
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     /**
140      * @dev Returns the name of the token.
141      */
142     function name() public view virtual override returns (string memory) {
143         return _name;
144     }
145 
146     /**
147      * @dev Returns the symbol of the token, usually a shorter version of the
148      * name.
149      */
150     function symbol() public view virtual override returns (string memory) {
151         return _symbol;
152     }
153 
154     /**
155      * @dev Returns the number of decimals used to get its user representation.
156      * For example, if `decimals` equals `2`, a balance of `505` tokens should
157      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
158      *
159      * Tokens usually opt for a value of 18, imitating the relationship between
160      * Ether and Wei. This is the value {ERC20} uses, unless this function is
161      * overridden;
162      *
163      * NOTE: This information is only used for _display_ purposes: it in
164      * no way affects any of the arithmetic of the contract, including
165      * {IERC20-balanceOf} and {IERC20-transfer}.
166      */
167     function decimals() public view virtual override returns (uint8) {
168         return 18;
169     }
170 
171     /**
172      * @dev See {IERC20-totalSupply}.
173      */
174     function totalSupply() public view virtual override returns (uint256) {
175         return _totalSupply;
176     }
177 
178     /**
179      * @dev See {IERC20-balanceOf}.
180      */
181     function balanceOf(address account) public view virtual override returns (uint256) {
182         return _balances[account];
183     }
184 
185     /**
186      * @dev See {IERC20-transfer}.
187      *
188      * Requirements:
189      *
190      * - `recipient` cannot be the zero address.
191      * - the caller must have a balance of at least `amount`.
192      */
193     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     /**
199      * @dev See {IERC20-allowance}.
200      */
201     function allowance(address owner, address spender) public view virtual override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     /**
206      * @dev See {IERC20-approve}.
207      *
208      * Requirements:
209      *
210      * - `spender` cannot be the zero address.
211      */
212     function approve(address spender, uint256 amount) public virtual override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     /**
218      * @dev See {IERC20-transferFrom}.
219      *
220      * Emits an {Approval} event indicating the updated allowance. This is not
221      * required by the EIP. See the note at the beginning of {ERC20}.
222      *
223      * Requirements:
224      *
225      * - `sender` and `recipient` cannot be the zero address.
226      * - `sender` must have a balance of at least `amount`.
227      * - the caller must have allowance for ``sender``'s tokens of at least
228      * `amount`.
229      */
230     function transferFrom(
231         address sender,
232         address recipient,
233         uint256 amount
234     ) public virtual override returns (bool) {
235         _transfer(sender, recipient, amount);
236         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
237         return true;
238     }
239 
240     /**
241      * @dev Atomically increases the allowance granted to `spender` by the caller.
242      *
243      * This is an alternative to {approve} that can be used as a mitigation for
244      * problems described in {IERC20-approve}.
245      *
246      * Emits an {Approval} event indicating the updated allowance.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
253         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
254         return true;
255     }
256 
257     /**
258      * @dev Atomically decreases the allowance granted to `spender` by the caller.
259      *
260      * This is an alternative to {approve} that can be used as a mitigation for
261      * problems described in {IERC20-approve}.
262      *
263      * Emits an {Approval} event indicating the updated allowance.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      * - `spender` must have allowance for the caller of at least
269      * `subtractedValue`.
270      */
271     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
272         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
273         return true;
274     }
275 
276     /**
277      * @dev Moves tokens `amount` from `sender` to `recipient`.
278      *
279      * This is internal function is equivalent to {transfer}, and can be used to
280      * e.g. implement automatic token fees, slashing mechanisms, etc.
281      *
282      * Emits a {Transfer} event.
283      *
284      * Requirements:
285      *
286      * - `sender` cannot be the zero address.
287      * - `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      */
290     function _transfer(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) internal virtual {
295         require(sender != address(0), "ERC20: transfer from the zero address");
296         require(recipient != address(0), "ERC20: transfer to the zero address");
297 
298         _beforeTokenTransfer(sender, recipient, amount);
299 
300         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
301         _balances[recipient] = _balances[recipient].add(amount);
302         emit Transfer(sender, recipient, amount);
303     }
304 
305     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
306      * the total supply.
307      *
308      * Emits a {Transfer} event with `from` set to the zero address.
309      *
310      * Requirements:
311      *
312      * - `account` cannot be the zero address.
313      */
314     function _createInitialSupply(address account, uint256 amount) internal virtual {
315         require(account != address(0), "ERC20: to the zero address");
316 
317         _beforeTokenTransfer(address(0), account, amount);
318 
319         _totalSupply = _totalSupply.add(amount);
320         _balances[account] = _balances[account].add(amount);
321         emit Transfer(address(0), account, amount);
322     }
323 
324     /**
325      * @dev Destroys `amount` tokens from `account`, reducing the
326      * total supply.
327      *
328      * Emits a {Transfer} event with `to` set to the zero address.
329      *
330      * Requirements:
331      *
332      * - `account` cannot be the zero address.
333      * - `account` must have at least `amount` tokens.
334      */
335     function _burn(address account, uint256 amount) internal virtual {
336         require(account != address(0), "ERC20: burn from the zero address");
337 
338         _beforeTokenTransfer(account, address(0), amount);
339 
340         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
341         _totalSupply = _totalSupply.sub(amount);
342         emit Transfer(account, address(0), amount);
343     }
344 
345     /**
346      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
347      *
348      * This internal function is equivalent to `approve`, and can be used to
349      * e.g. set automatic allowances for certain subsystems, etc.
350      *
351      * Emits an {Approval} event.
352      *
353      * Requirements:
354      *
355      * - `owner` cannot be the zero address.
356      * - `spender` cannot be the zero address.
357      */
358     function _approve(
359         address owner,
360         address spender,
361         uint256 amount
362     ) internal virtual {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365 
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370     function _beforeTokenTransfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {}
375 }
376 
377 library SafeMath {
378     /**
379      * @dev Returns the addition of two unsigned integers, reverting on
380      * overflow.
381      *
382      * Counterpart to Solidity's `+` operator.
383      *
384      * Requirements:
385      *
386      * - Addition cannot overflow.
387      */
388     function add(uint256 a, uint256 b) internal pure returns (uint256) {
389         uint256 c = a + b;
390         require(c >= a, "SafeMath: addition overflow");
391 
392         return c;
393     }
394 
395     /**
396      * @dev Returns the subtraction of two unsigned integers, reverting on
397      * overflow (when the result is negative).
398      *
399      * Counterpart to Solidity's `-` operator.
400      *
401      * Requirements:
402      *
403      * - Subtraction cannot overflow.
404      */
405     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
406         return sub(a, b, "SafeMath: subtraction overflow");
407     }
408 
409     /**
410      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
411      * overflow (when the result is negative).
412      *
413      * Counterpart to Solidity's `-` operator.
414      *
415      * Requirements:
416      *
417      * - Subtraction cannot overflow.
418      */
419     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b <= a, errorMessage);
421         uint256 c = a - b;
422 
423         return c;
424     }
425 
426     /**
427      * @dev Returns the multiplication of two unsigned integers, reverting on
428      * overflow.
429      *
430      * Counterpart to Solidity's `*` operator.
431      *
432      * Requirements:
433      *
434      * - Multiplication cannot overflow.
435      */
436     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
437         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
438         // benefit is lost if 'b' is also tested.
439         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
440         if (a == 0) {
441             return 0;
442         }
443 
444         uint256 c = a * b;
445         require(c / a == b, "SafeMath: multiplication overflow");
446 
447         return c;
448     }
449 
450     /**
451      * @dev Returns the integer division of two unsigned integers. Reverts on
452      * division by zero. The result is rounded towards zero.
453      *
454      * Counterpart to Solidity's `/` operator. Note: this function uses a
455      * `revert` opcode (which leaves remaining gas untouched) while Solidity
456      * uses an invalid opcode to revert (consuming all remaining gas).
457      *
458      * Requirements:
459      *
460      * - The divisor cannot be zero.
461      */
462     function div(uint256 a, uint256 b) internal pure returns (uint256) {
463         return div(a, b, "SafeMath: division by zero");
464     }
465 
466     /**
467      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
468      * division by zero. The result is rounded towards zero.
469      *
470      * Counterpart to Solidity's `/` operator. Note: this function uses a
471      * `revert` opcode (which leaves remaining gas untouched) while Solidity
472      * uses an invalid opcode to revert (consuming all remaining gas).
473      *
474      * Requirements:
475      *
476      * - The divisor cannot be zero.
477      */
478     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
479         require(b > 0, errorMessage);
480         uint256 c = a / b;
481         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
482 
483         return c;
484     }
485 
486     /**
487      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
488      * Reverts when dividing by zero.
489      *
490      * Counterpart to Solidity's `%` operator. This function uses a `revert`
491      * opcode (which leaves remaining gas untouched) while Solidity uses an
492      * invalid opcode to revert (consuming all remaining gas).
493      *
494      * Requirements:
495      *
496      * - The divisor cannot be zero.
497      */
498     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
499         return mod(a, b, "SafeMath: modulo by zero");
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
504      * Reverts with custom message when dividing by zero.
505      *
506      * Counterpart to Solidity's `%` operator. This function uses a `revert`
507      * opcode (which leaves remaining gas untouched) while Solidity uses an
508      * invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      *
512      * - The divisor cannot be zero.
513      */
514     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         require(b != 0, errorMessage);
516         return a % b;
517     }
518 }
519 
520 contract Ownable is Context {
521     address private _owner;
522 
523     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
524     
525     /**
526      * @dev Initializes the contract setting the deployer as the initial owner.
527      */
528     constructor () {
529         address msgSender = _msgSender();
530         _owner = msgSender;
531         emit OwnershipTransferred(address(0), msgSender);
532     }
533 
534     /**
535      * @dev Returns the address of the current owner.
536      */
537     function owner() public view returns (address) {
538         return _owner;
539     }
540 
541     /**
542      * @dev Throws if called by any account other than the owner.
543      */
544     modifier onlyOwner() {
545         require(_owner == _msgSender(), "Ownable: caller is not the owner");
546         _;
547     }
548 
549     /**
550      * @dev Leaves the contract without owner. It will not be possible to call
551      * `onlyOwner` functions anymore. Can only be called by the current owner.
552      *
553      * NOTE: Renouncing ownership will leave the contract without an owner,
554      * thereby removing any functionality that is only available to the owner.
555      */
556     function renounceOwnership() public virtual onlyOwner {
557         emit OwnershipTransferred(_owner, address(0));
558         _owner = address(0);
559     }
560 
561     /**
562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
563      * Can only be called by the current owner.
564      */
565     function transferOwnership(address newOwner) public virtual onlyOwner {
566         require(newOwner != address(0), "Ownable: new owner is the zero address");
567         emit OwnershipTransferred(_owner, newOwner);
568         _owner = newOwner;
569     }
570 }
571 
572 
573 
574 library SafeMathInt {
575     int256 private constant MIN_INT256 = int256(1) << 255;
576     int256 private constant MAX_INT256 = ~(int256(1) << 255);
577 
578     /**
579      * @dev Multiplies two int256 variables and fails on overflow.
580      */
581     function mul(int256 a, int256 b) internal pure returns (int256) {
582         int256 c = a * b;
583 
584         // Detect overflow when multiplying MIN_INT256 with -1
585         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
586         require((b == 0) || (c / b == a));
587         return c;
588     }
589 
590     /**
591      * @dev Division of two int256 variables and fails on overflow.
592      */
593     function div(int256 a, int256 b) internal pure returns (int256) {
594         // Prevent overflow when dividing MIN_INT256 by -1
595         require(b != -1 || a != MIN_INT256);
596 
597         // Solidity already throws when dividing by 0.
598         return a / b;
599     }
600 
601     /**
602      * @dev Subtracts two int256 variables and fails on overflow.
603      */
604     function sub(int256 a, int256 b) internal pure returns (int256) {
605         int256 c = a - b;
606         require((b >= 0 && c <= a) || (b < 0 && c > a));
607         return c;
608     }
609 
610     /**
611      * @dev Adds two int256 variables and fails on overflow.
612      */
613     function add(int256 a, int256 b) internal pure returns (int256) {
614         int256 c = a + b;
615         require((b >= 0 && c >= a) || (b < 0 && c < a));
616         return c;
617     }
618 
619     /**
620      * @dev Converts to absolute value, and fails on overflow.
621      */
622     function abs(int256 a) internal pure returns (int256) {
623         require(a != MIN_INT256);
624         return a < 0 ? -a : a;
625     }
626 
627 
628     function toUint256Safe(int256 a) internal pure returns (uint256) {
629         require(a >= 0);
630         return uint256(a);
631     }
632 }
633 
634 library SafeMathUint {
635   function toInt256Safe(uint256 a) internal pure returns (int256) {
636     int256 b = int256(a);
637     require(b >= 0);
638     return b;
639   }
640 }
641 
642 
643 interface IUniswapV2Router01 {
644     function factory() external pure returns (address);
645     function WETH() external pure returns (address);
646 
647     function addLiquidity(
648         address tokenA,
649         address tokenB,
650         uint amountADesired,
651         uint amountBDesired,
652         uint amountAMin,
653         uint amountBMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountA, uint amountB, uint liquidity);
657     function addLiquidityETH(
658         address token,
659         uint amountTokenDesired,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline
664     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
665     function swapExactTokensForTokens(
666         uint amountIn,
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external returns (uint[] memory amounts);
672     function swapTokensForExactTokens(
673         uint amountOut,
674         uint amountInMax,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external returns (uint[] memory amounts);
679     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
680         external
681         payable
682         returns (uint[] memory amounts);
683     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
684         external
685         returns (uint[] memory amounts);
686     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
687         external
688         returns (uint[] memory amounts);
689     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
690         external
691         payable
692         returns (uint[] memory amounts);
693 
694     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
695     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
696     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
697     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
698     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
699 }
700 
701 interface IUniswapV2Router02 is IUniswapV2Router01 {
702     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
703         uint amountIn,
704         uint amountOutMin,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external;
709     function swapExactETHForTokensSupportingFeeOnTransferTokens(
710         uint amountOutMin,
711         address[] calldata path,
712         address to,
713         uint deadline
714     ) external payable;
715     function swapExactTokensForETHSupportingFeeOnTransferTokens(
716         uint amountIn,
717         uint amountOutMin,
718         address[] calldata path,
719         address to,
720         uint deadline
721     ) external;
722 }
723 
724 contract TresorInu is ERC20, Ownable {
725 
726     IUniswapV2Router02 public immutable uniswapV2Router;
727     address public immutable uniswapV2Pair;
728     address public constant deadAddress = address(0xdead);
729 
730     bool private swapping;
731 
732     address public marketingWallet;
733     address public stakingAddress;
734     
735     uint256 public maxTransactionAmount;
736     uint256 public swapTokensAtAmount;
737 
738     bool public limitsInEffect = true;
739     bool public tradingActive = false;
740     bool public swapEnabled = false;
741 
742     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
743     uint256 public blockForPenaltyEnd;
744     mapping (address => bool) public boughtEarly;
745     uint256 public botsCaught;
746 
747     bool private gasLimitActive = true;
748     uint256 private constant gasPriceLimit = 420 * 1 gwei; // do not allow over x gwei for launch
749     
750      // Anti-bot and anti-whale mappings and variables
751     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
752     bool public transferDelayEnabled = true;
753 
754     uint256 public buyTotalFees;
755     uint256 public buyMarketingFee;
756     uint256 public buyLiquidityFee;
757     uint256 public buyStakingFee;
758     
759     uint256 public sellTotalFees;
760     uint256 public sellMarketingFee;
761     uint256 public sellLiquidityFee;
762     uint256 public sellStakingFee;
763     
764     uint256 public tokensForMarketing;
765     uint256 public tokensForLiquidity;
766     
767     // exlcude from fees and max transaction amount
768     mapping (address => bool) private _isExcludedFromFees;
769     mapping (address => bool) public _isExcludedMaxTransactionAmount;
770 
771     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
772     // could be subject to a maximum transfer amount
773     mapping (address => bool) public automatedMarketMakerPairs;
774 
775     event ExcludeFromFees(address indexed account, bool isExcluded);
776 
777     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
778 
779     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
780     event StakingAddressUpdated(address indexed newWallet, address indexed oldWallet);
781 
782     event EnabledTrading();
783     event CaughtEarlyBuyer(address sniper);
784     
785     event SwapAndLiquify(
786         uint256 tokensSwapped,
787         uint256 ethReceived,
788         uint256 tokensIntoLiquidity
789     );
790 
791     constructor() ERC20("Tresor Inu", "TINU") {
792         address newOwner = msg.sender;
793         
794         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
795         
796         excludeFromMaxTransaction(address(_uniswapV2Router), true);
797         uniswapV2Router = _uniswapV2Router;
798         
799         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
800         excludeFromMaxTransaction(address(uniswapV2Pair), true);
801         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
802   
803         uint256 totalSupply = 10 * 1e12 * 1e18;
804         
805         maxTransactionAmount = totalSupply * 25 / 10000; // 0.25% maxTransactionAmountTxn
806         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap limit
807 
808         buyMarketingFee = 70;
809         buyLiquidityFee = 20;
810         buyStakingFee = 0;
811         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyStakingFee;
812         
813         sellMarketingFee = 110;
814         sellLiquidityFee = 40;
815         sellStakingFee = 0;
816         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellStakingFee;
817         
818     	marketingWallet = address(0x3aEB96955d3Ec04C8CcF6B0e8f880Fd5EeB73137); // set as marketing wallet
819         stakingAddress = address(newOwner);
820 
821         // exclude from paying fees or having max transaction amount
822         excludeFromFees(newOwner, true);
823         excludeFromFees(address(this), true);
824         excludeFromFees(address(0xdead), true);
825         
826         excludeFromMaxTransaction(newOwner, true);
827         excludeFromMaxTransaction(address(this), true);
828         excludeFromMaxTransaction(address(0xdead), true);
829         
830         _createInitialSupply(newOwner, totalSupply);
831         transferOwnership(newOwner);
832     }
833 
834     receive() external payable {
835 
836   	}
837 
838     // once enabled, can never be turned off
839     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
840         require(!tradingActive, "Cannot reenable trading");
841         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
842         tradingActive = true;
843         swapEnabled = true;
844         tradingActiveBlock = block.number;
845         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
846         emit EnabledTrading();
847     }
848     
849     // remove limits after token is stable
850     function removeLimits() external onlyOwner returns (bool){
851         limitsInEffect = false;
852         gasLimitActive = false;
853         transferDelayEnabled = false;
854         return true;
855     }
856 
857     function removeBoughtEarly(address wallet) external onlyOwner {
858         require(boughtEarly[wallet], "Wallet is already not flagged.");
859         boughtEarly[wallet] = false;
860     }
861     
862     // disable Transfer delay - cannot be reenabled
863     function disableTransferDelay() external onlyOwner returns (bool){
864         transferDelayEnabled = false;
865         return true;
866     }
867     
868     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){
869         require(!tradingActive, "Trading is already active, cannot airdrop after launch.");
870         require(airdropWallets.length == amounts.length, "arrays must be the same length");
871         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits");
872         for(uint256 i = 0; i < airdropWallets.length; i++){
873             address wallet = airdropWallets[i];
874             uint256 amount = amounts[i];
875             _transfer(msg.sender, wallet, amount);
876         }
877         return true;
878     }
879     
880      // change the minimum amount of tokens to sell from fees
881     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
882   	    require(newAmount * 1e18 >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
883   	    require(newAmount * 1e18 <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
884   	    swapTokensAtAmount = newAmount * (10**18);
885   	    return true;
886   	}
887     
888     function updateMaxAmount(uint256 newNum) external onlyOwner {
889         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
890         maxTransactionAmount = newNum * (10**18);
891     }
892     
893     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
894         _isExcludedMaxTransactionAmount[updAds] = isEx;
895     }
896     
897     // only use to disable contract sales if absolutely necessary (emergency use only)
898     function updateSwapEnabled(bool enabled) external onlyOwner(){
899         swapEnabled = enabled;
900     }
901     
902     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _stakingFee) external onlyOwner {
903         buyMarketingFee = _marketingFee;
904         buyLiquidityFee = _liquidityFee;
905         buyStakingFee = _stakingFee;
906         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyStakingFee;
907         require(buyTotalFees <= 250, "Must keep fees at 25% or less");
908     }
909     
910     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _stakingFee) external onlyOwner {
911         sellMarketingFee = _marketingFee;
912         sellLiquidityFee = _liquidityFee;
913         sellStakingFee = _stakingFee;
914         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellStakingFee;
915         require(sellTotalFees <= 250, "Must keep fees at 25% or less");
916     }
917 
918     function excludeFromFees(address account, bool excluded) public onlyOwner {
919         _isExcludedFromFees[account] = excluded;
920         emit ExcludeFromFees(account, excluded);
921     }
922 
923     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
924         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
925 
926         _setAutomatedMarketMakerPair(pair, value);
927     }
928     
929     function _setAutomatedMarketMakerPair(address pair, bool value) private {
930         automatedMarketMakerPairs[pair] = value;
931 
932         emit SetAutomatedMarketMakerPair(pair, value);
933     }
934 
935     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
936         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
937         marketingWallet = newMarketingWallet;
938     } 
939 
940     function updateStakingAddress(address newAddress) external onlyOwner {
941         emit StakingAddressUpdated(newAddress, stakingAddress);
942         stakingAddress = newAddress;
943     }  
944 
945     function isExcludedFromFees(address account) external view returns(bool) {
946         return _isExcludedFromFees[account];
947     }
948     
949     function _transfer(
950         address from,
951         address to,
952         uint256 amount
953     ) internal override {
954         require(from != address(0), "ERC20: transfer from the zero address");
955         require(to != address(0), "ERC20: transfer to the zero address");
956         
957          if(amount == 0) {
958             super._transfer(from, to, 0);
959             return;
960         }
961 
962         if(!tradingActive){
963             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
964         }
965         
966         if(limitsInEffect){
967             if (
968                 from != owner() &&
969                 to != owner() &&
970                 to != address(0) &&
971                 to != address(0xdead) &&
972                 !swapping &&
973                 !_isExcludedFromFees[from] &&
974                 !_isExcludedFromFees[to]
975             ){
976 
977                 if(!earlyBuyPenaltyInEffect()){
978                     require((!boughtEarly[from] && !boughtEarly[to]) || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
979                 }
980                 
981                 // only use to prevent sniper buys in the first blocks.
982                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
983                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
984                 }
985 
986                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
987                 if (transferDelayEnabled){
988                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
989                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
990                         _holderLastTransferTimestamp[tx.origin] = block.number;
991                     }
992                 }
993                  
994                 //when buy
995                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
996                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
997                 }
998                 
999                 //when sell
1000                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1001                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1002                 }
1003             }
1004         }
1005         
1006 		uint256 contractTokenBalance = balanceOf(address(this));
1007         
1008         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1009 
1010         if( 
1011             canSwap &&
1012             swapEnabled &&
1013             !swapping &&
1014             !automatedMarketMakerPairs[from] &&
1015             !_isExcludedFromFees[from] &&
1016             !_isExcludedFromFees[to]
1017         ) {
1018             swapping = true;
1019             
1020             swapBack();
1021 
1022             swapping = false;
1023         }
1024         
1025         bool takeFee = !swapping;
1026 
1027         // if any account belongs to _isExcludedFromFee account then remove the fee
1028         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1029             takeFee = false;
1030         }
1031         
1032         uint256 fees = 0;
1033         uint256 stakingTokens = 0;
1034         // only take fees on buys/sells, do not take on wallet transfers
1035         if(takeFee){
1036             // bot/sniper penalty.
1037             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]){
1038                 
1039                 if(!boughtEarly[to]){
1040                     boughtEarly[to] = true;
1041                     botsCaught += 1;
1042                     emit CaughtEarlyBuyer(to);
1043                 }
1044 
1045                 fees = amount * buyTotalFees / 1000;
1046         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1047                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1048                 stakingTokens = fees * buyStakingFee / buyTotalFees;
1049             }
1050 
1051             // on sell
1052             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1053                 fees = amount * sellTotalFees / 1000;
1054                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1055                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1056                 stakingTokens = fees * sellStakingFee / sellTotalFees;
1057             }
1058             // on buy
1059             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1060         	    fees = amount * buyTotalFees / 1000;
1061         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1062                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1063                 stakingTokens = fees * buyStakingFee / buyTotalFees;
1064             }
1065             
1066             if(stakingTokens > 0){
1067                 super._transfer(from, address(stakingAddress), stakingTokens);
1068             }
1069 
1070             if(fees - stakingTokens > 0){    
1071                 super._transfer(from, address(this), fees-stakingTokens);
1072             }
1073         	
1074         	amount -= fees;
1075         }
1076 
1077         super._transfer(from, to, amount);
1078     }
1079 
1080     function swapTokensForEth(uint256 tokenAmount) private {
1081 
1082         // generate the uniswap pair path of token -> weth
1083         address[] memory path = new address[](2);
1084         path[0] = address(this);
1085         path[1] = uniswapV2Router.WETH();
1086 
1087         _approve(address(this), address(uniswapV2Router), tokenAmount);
1088 
1089         // make the swap
1090         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1091             tokenAmount,
1092             0, // accept any amount of ETH
1093             path,
1094             address(this),
1095             block.timestamp
1096         );
1097         
1098     }
1099     
1100     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1101         // approve token transfer to cover all possible scenarios
1102         _approve(address(this), address(uniswapV2Router), tokenAmount);
1103 
1104         // add the liquidity
1105         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1106             address(this),
1107             tokenAmount,
1108             0, // slippage is unavoidable
1109             0, // slippage is unavoidable
1110             address(0xdead),
1111             block.timestamp
1112         );
1113 
1114     }
1115 
1116     function earlyBuyPenaltyInEffect() public view returns (bool){
1117         return block.number < blockForPenaltyEnd;
1118     }
1119 
1120     function swapBack() private {
1121         uint256 contractBalance = balanceOf(address(this));
1122         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1123         bool success;
1124 
1125         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1126 
1127         if(contractBalance >= swapTokensAtAmount * 10){
1128             contractBalance = swapTokensAtAmount * 10;
1129         }
1130         
1131         // Halve the amount of liquidity tokens
1132         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1133         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1134         
1135         uint256 initialETHBalance = address(this).balance;
1136 
1137         swapTokensForEth(amountToSwapForETH); 
1138         
1139         uint256 ethBalance = address(this).balance - initialETHBalance;
1140         
1141         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
1142         
1143         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1144         
1145         tokensForLiquidity = 0;
1146         tokensForMarketing = 0;
1147         
1148         if(liquidityTokens > 0 && ethForLiquidity > 0){
1149             addLiquidity(liquidityTokens, ethForLiquidity);
1150             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1151         }      
1152 
1153         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1154      }
1155 
1156     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
1157         require(_token != address(0), "_token address cannot be 0");
1158         require(_token != address(this), "Can't withdraw native tokens");
1159         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1160         _sent = IERC20(_token).transfer(_to, _contractBalance);
1161     }
1162 
1163     // withdraw ETH if stuck or someone sends to the address
1164     function withdrawStuckETH() external onlyOwner {
1165         bool success;
1166         (success,) = address(msg.sender).call{value: address(this).balance}("");
1167     }
1168 }