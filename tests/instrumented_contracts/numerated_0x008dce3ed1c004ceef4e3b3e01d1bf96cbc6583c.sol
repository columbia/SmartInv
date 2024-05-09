1 /**
2 
3 
4 ウェブ :https://Yukieth.com/
5 電報: https://T.Me/YukiOnETH
6 ツイッター : https://twitter.com/YukiOnETH
7 -------------------------------------------------
8 マックスウォレット: 2% 総供給量
9 
10 -------------------------------------------------
11 */
12 
13 // SPDX-License-Identifier: MIT                                                                               
14                                                     
15 pragma solidity = 0.8.19;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IUniswapV2Pair {
29     event Sync(uint112 reserve0, uint112 reserve1);
30     function sync() external;
31 }
32 
33 interface IUniswapV2Factory {
34     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
35 
36     function createPair(address tokenA, address tokenB) external returns (address pair);
37 }
38 
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
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 interface IERC20Metadata is IERC20 {
115     /**
116      * @dev Returns the name of the token.
117      */
118     function name() external view returns (string memory);
119 
120     /**
121      * @dev Returns the symbol of the token.
122      */
123     function symbol() external view returns (string memory);
124 
125     /**
126      * @dev Returns the decimals places of the token.
127      */
128     function decimals() external view returns (uint8);
129 }
130 
131 
132 contract ERC20 is Context, IERC20, IERC20Metadata {
133     using SafeMath for uint256;
134 
135     mapping(address => uint256) private _balances;
136 
137     mapping(address => mapping(address => uint256)) private _allowances;
138 
139     uint256 private _totalSupply;
140 
141     string private _name;
142     string private _symbol;
143 
144     /**
145      * @dev Sets the values for {name} and {symbol}.
146      *
147      * The default value of {decimals} is 18. To select a different value for
148      * {decimals} you should overload it.
149      *
150      * All two of these values are immutable: they can only be set once during
151      * construction.
152      */
153     constructor(string memory name_, string memory symbol_) {
154         _name = name_;
155         _symbol = symbol_;
156     }
157 
158     /**
159      * @dev Returns the name of the token.
160      */
161     function name() public view virtual override returns (string memory) {
162         return _name;
163     }
164 
165     /**
166      * @dev Returns the symbol of the token, usually a shorter version of the
167      * name.
168      */
169     function symbol() public view virtual override returns (string memory) {
170         return _symbol;
171     }
172 
173     /**
174      * @dev Returns the number of decimals used to get its user representation.
175      * For example, if `decimals` equals `2`, a balance of `505` tokens should
176      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
177      *
178      * Tokens usually opt for a value of 18, imitating the relationship between
179      * Ether and Wei. This is the value {ERC20} uses, unless this function is
180      * overridden;
181      *
182      * NOTE: This information is only used for _display_ purposes: it in
183      * no way affects any of the arithmetic of the contract, including
184      * {IERC20-balanceOf} and {IERC20-transfer}.
185      */
186     function decimals() public view virtual override returns (uint8) {
187         return 18;
188     }
189 
190     /**
191      * @dev See {IERC20-totalSupply}.
192      */
193     function totalSupply() public view virtual override returns (uint256) {
194         return _totalSupply;
195     }
196 
197     /**
198      * @dev See {IERC20-balanceOf}.
199      */
200     function balanceOf(address account) public view virtual override returns (uint256) {
201         return _balances[account];
202     }
203 
204     /**
205      * @dev See {IERC20-transfer}.
206      *
207      * Requirements:
208      *
209      * - `recipient` cannot be the zero address.
210      * - the caller must have a balance of at least `amount`.
211      */
212     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
213         _transfer(_msgSender(), recipient, amount);
214         return true;
215     }
216 
217     /**
218      * @dev See {IERC20-allowance}.
219      */
220     function allowance(address owner, address spender) public view virtual override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     /**
225      * @dev See {IERC20-approve}.
226      *
227      * Requirements:
228      *
229      * - `spender` cannot be the zero address.
230      */
231     function approve(address spender, uint256 amount) public virtual override returns (bool) {
232         _approve(_msgSender(), spender, amount);
233         return true;
234     }
235 
236     /**
237      * @dev See {IERC20-transferFrom}.
238      *
239      * Emits an {Approval} event indicating the updated allowance. This is not
240      * required by the EIP. See the note at the beginning of {ERC20}.
241      *
242      * Requirements:
243      *
244      * - `sender` and `recipient` cannot be the zero address.
245      * - `sender` must have a balance of at least `amount`.
246      * - the caller must have allowance for ``sender``'s tokens of at least
247      * `amount`.
248      */
249     function transferFrom(
250         address sender,
251         address recipient,
252         uint256 amount
253     ) public virtual override returns (bool) {
254         _transfer(sender, recipient, amount);
255         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
256         return true;
257     }
258 
259     /**
260      * @dev Atomically increases the allowance granted to `spender` by the caller.
261      *
262      * This is an alternative to {approve} that can be used as a mitigation for
263      * problems described in {IERC20-approve}.
264      *
265      * Emits an {Approval} event indicating the updated allowance.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
272         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
273         return true;
274     }
275 
276     /**
277      * @dev Atomically decreases the allowance granted to `spender` by the caller.
278      *
279      * This is an alternative to {approve} that can be used as a mitigation for
280      * problems described in {IERC20-approve}.
281      *
282      * Emits an {Approval} event indicating the updated allowance.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      * - `spender` must have allowance for the caller of at least
288      * `subtractedValue`.
289      */
290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
291         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
292         return true;
293     }
294 
295     /**
296      * @dev Moves tokens `amount` from `sender` to `recipient`.
297      *
298      * This is internal function is equivalent to {transfer}, and can be used to
299      * e.g. implement automatic token fees, slashing mechanisms, etc.
300      *
301      * Emits a {Transfer} event.
302      *
303      * Requirements:
304      *
305      * - `sender` cannot be the zero address.
306      * - `recipient` cannot be the zero address.
307      * - `sender` must have a balance of at least `amount`.
308      */
309     function _transfer(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) internal virtual {
314         require(sender != address(0), "ERC20: transfer from the zero address");
315         require(recipient != address(0), "ERC20: transfer to the zero address");
316 
317         _beforeTokenTransfer(sender, recipient, amount);
318 
319         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
320         _balances[recipient] = _balances[recipient].add(amount);
321         emit Transfer(sender, recipient, amount);
322     }
323 
324     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
325      * the total supply.
326      *
327      * Emits a {Transfer} event with `from` set to the zero address.
328      *
329      * Requirements:
330      *
331      * - `account` cannot be the zero address.
332      */
333     function _mint(address account, uint256 amount) internal virtual {
334         require(account != address(0), "ERC20: mint to the zero address");
335 
336         _beforeTokenTransfer(address(0), account, amount);
337 
338         _totalSupply = _totalSupply.add(amount);
339         _balances[account] = _balances[account].add(amount);
340         emit Transfer(address(0), account, amount);
341     }
342 
343     /**
344      * @dev Destroys `amount` tokens from `account`, reducing the
345      * total supply.
346      *
347      * Emits a {Transfer} event with `to` set to the zero address.
348      *
349      * Requirements:
350      *
351      * - `account` cannot be the zero address.
352      * - `account` must have at least `amount` tokens.
353      */
354     function _burn(address account, uint256 amount) internal virtual {
355         require(account != address(0), "ERC20: burn from the zero address");
356 
357         _beforeTokenTransfer(account, address(0), amount);
358 
359         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
360         _totalSupply = _totalSupply.sub(amount);
361         emit Transfer(account, address(0), amount);
362     }
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
366      *
367      * This internal function is equivalent to `approve`, and can be used to
368      * e.g. set automatic allowances for certain subsystems, etc.
369      *
370      * Emits an {Approval} event.
371      *
372      * Requirements:
373      *
374      * - `owner` cannot be the zero address.
375      * - `spender` cannot be the zero address.
376      */
377     function _approve(
378         address owner,
379         address spender,
380         uint256 amount
381     ) internal virtual {
382         require(owner != address(0), "ERC20: approve from the zero address");
383         require(spender != address(0), "ERC20: approve to the zero address");
384 
385         _allowances[owner][spender] = amount;
386         emit Approval(owner, spender, amount);
387     }
388 
389     /**
390      * @dev Hook that is called before any transfer of tokens. This includes
391      * minting and burning.
392      *
393      * Calling conditions:
394      *
395      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
396      * will be to transferred to `to`.
397      * - when `from` is zero, `amount` tokens will be minted for `to`.
398      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
399      * - `from` and `to` are never both zero.
400      *
401      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
402      */
403     function _beforeTokenTransfer(
404         address from,
405         address to,
406         uint256 amount
407     ) internal virtual {}
408 }
409 
410 library SafeMath {
411     /**
412      * @dev Returns the addition of two unsigned integers, reverting on
413      * overflow.
414      *
415      * Counterpart to Solidity's `+` operator.
416      *
417      * Requirements:
418      *
419      * - Addition cannot overflow.
420      */
421     function add(uint256 a, uint256 b) internal pure returns (uint256) {
422         uint256 c = a + b;
423         require(c >= a, "SafeMath: addition overflow");
424 
425         return c;
426     }
427 
428     /**
429      * @dev Returns the subtraction of two unsigned integers, reverting on
430      * overflow (when the result is negative).
431      *
432      * Counterpart to Solidity's `-` operator.
433      *
434      * Requirements:
435      *
436      * - Subtraction cannot overflow.
437      */
438     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439         return sub(a, b, "SafeMath: subtraction overflow");
440     }
441 
442     /**
443      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
444      * overflow (when the result is negative).
445      *
446      * Counterpart to Solidity's `-` operator.
447      *
448      * Requirements:
449      *
450      * - Subtraction cannot overflow.
451      */
452     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
453         require(b <= a, errorMessage);
454         uint256 c = a - b;
455 
456         return c;
457     }
458 
459     /**
460      * @dev Returns the multiplication of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `*` operator.
464      *
465      * Requirements:
466      *
467      * - Multiplication cannot overflow.
468      */
469     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
470         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
471         // benefit is lost if 'b' is also tested.
472         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
473         if (a == 0) {
474             return 0;
475         }
476 
477         uint256 c = a * b;
478         require(c / a == b, "SafeMath: multiplication overflow");
479 
480         return c;
481     }
482 
483     /**
484      * @dev Returns the integer division of two unsigned integers. Reverts on
485      * division by zero. The result is rounded towards zero.
486      *
487      * Counterpart to Solidity's `/` operator. Note: this function uses a
488      * `revert` opcode (which leaves remaining gas untouched) while Solidity
489      * uses an invalid opcode to revert (consuming all remaining gas).
490      *
491      * Requirements:
492      *
493      * - The divisor cannot be zero.
494      */
495     function div(uint256 a, uint256 b) internal pure returns (uint256) {
496         return div(a, b, "SafeMath: division by zero");
497     }
498 
499     /**
500      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
501      * division by zero. The result is rounded towards zero.
502      *
503      * Counterpart to Solidity's `/` operator. Note: this function uses a
504      * `revert` opcode (which leaves remaining gas untouched) while Solidity
505      * uses an invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
512         require(b > 0, errorMessage);
513         uint256 c = a / b;
514         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
515 
516         return c;
517     }
518 
519     /**
520      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
521      * Reverts when dividing by zero.
522      *
523      * Counterpart to Solidity's `%` operator. This function uses a `revert`
524      * opcode (which leaves remaining gas untouched) while Solidity uses an
525      * invalid opcode to revert (consuming all remaining gas).
526      *
527      * Requirements:
528      *
529      * - The divisor cannot be zero.
530      */
531     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
532         return mod(a, b, "SafeMath: modulo by zero");
533     }
534 
535     /**
536      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
537      * Reverts with custom message when dividing by zero.
538      *
539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
540      * opcode (which leaves remaining gas untouched) while Solidity uses an
541      * invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
548         require(b != 0, errorMessage);
549         return a % b;
550     }
551 }
552 
553 contract Ownable is Context {
554     address private _owner;
555 
556     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
557     
558     /**
559      * @dev Initializes the contract setting the deployer as the initial owner.
560      */
561     constructor () {
562         address msgSender = _msgSender();
563         _owner = msgSender;
564         emit OwnershipTransferred(address(0), msgSender);
565     }
566 
567     /**
568      * @dev Returns the address of the current owner.
569      */
570     function owner() public view returns (address) {
571         return _owner;
572     }
573 
574     /**
575      * @dev Throws if called by any account other than the owner.
576      */
577     modifier onlyOwner() {
578         require(_owner == _msgSender(), "Ownable: caller is not the owner");
579         _;
580     }
581 
582     /**
583      * @dev Leaves the contract without owner. It will not be possible to call
584      * `onlyOwner` functions anymore. Can only be called by the current owner.
585      *
586      * NOTE: Renouncing ownership will leave the contract without an owner,
587      * thereby removing any functionality that is only available to the owner.
588      */
589     function renounceOwnership() public virtual onlyOwner {
590         emit OwnershipTransferred(_owner, address(0));
591         _owner = address(0);
592     }
593 
594     /**
595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
596      * Can only be called by the current owner.
597      */
598     function transferOwnership(address newOwner) public virtual onlyOwner {
599         require(newOwner != address(0), "Ownable: new owner is the zero address");
600         emit OwnershipTransferred(_owner, newOwner);
601         _owner = newOwner;
602     }
603 }
604 
605 
606 
607 library SafeMathInt {
608     int256 private constant MIN_INT256 = int256(1) << 255;
609     int256 private constant MAX_INT256 = ~(int256(1) << 255);
610 
611     /**
612      * @dev Multiplies two int256 variables and fails on overflow.
613      */
614     function mul(int256 a, int256 b) internal pure returns (int256) {
615         int256 c = a * b;
616 
617         // Detect overflow when multiplying MIN_INT256 with -1
618         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
619         require((b == 0) || (c / b == a));
620         return c;
621     }
622 
623     /**
624      * @dev Division of two int256 variables and fails on overflow.
625      */
626     function div(int256 a, int256 b) internal pure returns (int256) {
627         // Prevent overflow when dividing MIN_INT256 by -1
628         require(b != -1 || a != MIN_INT256);
629 
630         // Solidity already throws when dividing by 0.
631         return a / b;
632     }
633 
634     /**
635      * @dev Subtracts two int256 variables and fails on overflow.
636      */
637     function sub(int256 a, int256 b) internal pure returns (int256) {
638         int256 c = a - b;
639         require((b >= 0 && c <= a) || (b < 0 && c > a));
640         return c;
641     }
642 
643     /**
644      * @dev Adds two int256 variables and fails on overflow.
645      */
646     function add(int256 a, int256 b) internal pure returns (int256) {
647         int256 c = a + b;
648         require((b >= 0 && c >= a) || (b < 0 && c < a));
649         return c;
650     }
651 
652     /**
653      * @dev Converts to absolute value, and fails on overflow.
654      */
655     function abs(int256 a) internal pure returns (int256) {
656         require(a != MIN_INT256);
657         return a < 0 ? -a : a;
658     }
659 
660 
661     function toUint256Safe(int256 a) internal pure returns (uint256) {
662         require(a >= 0);
663         return uint256(a);
664     }
665 }
666 
667 library SafeMathUint {
668   function toInt256Safe(uint256 a) internal pure returns (int256) {
669     int256 b = int256(a);
670     require(b >= 0);
671     return b;
672   }
673 }
674 
675 
676 interface IUniswapV2Router01 {
677     function factory() external pure returns (address);
678     function WETH() external pure returns (address);
679 
680     function addLiquidityETH(
681         address token,
682         uint amountTokenDesired,
683         uint amountTokenMin,
684         uint amountETHMin,
685         address to,
686         uint deadline
687     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
688 }
689 
690 interface IUniswapV2Router02 is IUniswapV2Router01 {
691     function swapExactTokensForETHSupportingFeeOnTransferTokens(
692         uint amountIn,
693         uint amountOutMin,
694         address[] calldata path,
695         address to,
696         uint deadline
697     ) external;
698 }
699 
700 contract YUKI is ERC20, Ownable {
701 
702     IUniswapV2Router02 public immutable uniswapV2Router;
703     address public immutable uniswapV2Pair;
704     address public constant deadAddress = address(0xdead);
705 
706     bool private swapping;
707 
708     address public marketingWallet;
709     address public devWallet;
710     
711     uint256 public maxTransactionAmount;
712     uint256 public swapTokensAtAmount;
713     uint256 public maxWallet;
714     
715     uint256 public percentForLPBurn = 25; // 25 = .25%
716     bool public lpBurnEnabled = false;
717     uint256 public lpBurnFrequency = 3600 seconds;
718     uint256 public lastLpBurnTime;
719     
720     uint256 public manualBurnFrequency = 30 minutes;
721     uint256 public lastManualLpBurnTime;
722 
723     bool public limitsInEffect = true;
724     bool public tradingActive = false;
725     bool public swapEnabled = false;
726     
727      // Anti-bot and anti-whale mappings and variables
728     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
729     mapping (address => bool) public isBlacklisted;
730     bool public transferDelayEnabled = true;
731 
732     uint256 public buyTotalFees;
733     uint256 public buyMarketingFee;
734     uint256 public buyLiquidityFee;
735     uint256 public buyDevFee;
736     
737     uint256 public sellTotalFees;
738     uint256 public sellMarketingFee;
739     uint256 public sellLiquidityFee;
740     uint256 public sellDevFee;
741     
742     uint256 public tokensForMarketing;
743     uint256 public tokensForLiquidity;
744     uint256 public tokensForDev;
745     
746     mapping(address => bool) private whitelist;
747 
748     // exlcude from fees and max transaction amount
749     mapping (address => bool) private _isExcludedFromFees;
750     mapping (address => bool) public _isExcludedMaxTransactionAmount;
751 
752     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
753     // could be subject to a maximum transfer amount
754     mapping (address => bool) public automatedMarketMakerPairs;
755 
756     constructor() ERC20("Yuki", "YUKI") {
757         
758         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
759         
760         excludeFromMaxTransaction(address(_uniswapV2Router), true);
761         uniswapV2Router = _uniswapV2Router;
762         
763         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
764         excludeFromMaxTransaction(address(uniswapV2Pair), true);
765         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
766         
767         uint256 _buyMarketingFee = 0;
768         uint256 _buyLiquidityFee = 0;
769         uint256 _buyDevFee = 25;
770 
771         uint256 _sellMarketingFee = 0;
772         uint256 _sellLiquidityFee = 0;
773         uint256 _sellDevFee = 25;
774         
775         uint256 totalSupply = 1000000000000 * 1e18; 
776         
777         maxTransactionAmount = totalSupply * 2 / 100; // 1% maxTransactionAmountTxn
778         maxWallet = totalSupply * 2 / 100; // 1% maxWallet
779         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
780 
781         buyMarketingFee = _buyMarketingFee;
782         buyLiquidityFee = _buyLiquidityFee;
783         buyDevFee = _buyDevFee;
784         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
785         
786         sellMarketingFee = _sellMarketingFee;
787         sellLiquidityFee = _sellLiquidityFee;
788         sellDevFee = _sellDevFee;
789         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
790         
791         marketingWallet = address(owner()); // set as marketing wallet
792         devWallet = address(owner()); // set as dev wallet
793 
794         // exclude from paying fees or having max transaction amount
795         excludeFromFees(owner(), true);
796         excludeFromFees(address(this), true);
797         excludeFromFees(address(0xdead), true);
798         
799         excludeFromMaxTransaction(owner(), true);
800         excludeFromMaxTransaction(address(this), true);
801         excludeFromMaxTransaction(address(0xdead), true);
802         
803         _mint(msg.sender, totalSupply);
804     }
805 
806     receive() external payable {
807 
808   	}
809     
810     function setWhitelist(address[] memory whitelist_) public onlyOwner {
811         for (uint256 i = 0; i < whitelist_.length; i++) {
812             whitelist[whitelist_[i]] = true;
813         }
814     }
815 
816     function isWhiteListed(address account) public view returns (bool) {
817         return whitelist[account];
818     }  
819 
820     // once enabled, can never be turned off
821     function openTrading() external onlyOwner {
822         tradingActive = true;
823         swapEnabled = true;
824         lastLpBurnTime = block.timestamp;
825     }
826     
827     // remove limits after token is stable
828     function removeYulimits() external onlyOwner returns (bool){
829         limitsInEffect = false;
830         transferDelayEnabled = false;
831         return true;
832     }
833     
834     // change the minimum amount of tokens to sell from fees
835     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
836   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
837   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
838   	    return true;
839   	}
840     
841     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
842         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
843         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
844         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
845         maxWallet = (totalSupply() * walNum / 100)/1e18;
846     }
847 
848     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
849         _isExcludedMaxTransactionAmount[updAds] = isEx;
850     }
851     
852     // only use to disable contract sales if absolutely necessary (emergency use only)
853     function updateSwapEnabled(bool enabled) external onlyOwner(){
854         swapEnabled = enabled;
855     }
856     
857     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
858         buyMarketingFee = _marketingFee;
859         buyLiquidityFee = _liquidityFee;
860         buyDevFee = _devFee;
861         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
862         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
863     }
864     
865     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
866         sellMarketingFee = _marketingFee;
867         sellLiquidityFee = _liquidityFee;
868         sellDevFee = _devFee;
869         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
870         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
871     }
872 
873     function excludeFromFees(address account, bool excluded) public onlyOwner {
874         _isExcludedFromFees[account] = excluded;
875     }
876 
877     function _setAutomatedMarketMakerPair(address pair, bool value) private {
878         automatedMarketMakerPairs[pair] = value;
879     }
880 
881     function updateMarketingWalletinfo(address newMarketingWallet) external onlyOwner {
882         marketingWallet = newMarketingWallet;
883     }
884     
885     function updateDevWalletinfo(address newWallet) external onlyOwner {
886         devWallet = newWallet;
887     }
888 
889     function isExcludedFromFees(address account) public view returns(bool) {
890         return _isExcludedFromFees[account];
891     }
892 
893     function manageYu_bots(address _address, bool status) external onlyOwner {
894         require(_address != address(0),"Address should not be 0");
895         isBlacklisted[_address] = status;
896     }
897 
898     function _transfer(
899         address from,
900         address to,
901         uint256 amount
902     ) internal override {
903         require(from != address(0), "ERC20: transfer from the zero address");
904         require(to != address(0), "ERC20: transfer to the zero address");
905         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
906          if(amount == 0) {
907             super._transfer(from, to, 0);
908             return;
909         }
910         
911         if(limitsInEffect){
912             if (
913                 from != owner() &&
914                 to != owner() &&
915                 to != address(0) &&
916                 to != address(0xdead) &&
917                 !swapping
918             ){
919                 if(!tradingActive){
920                     require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
921                 }
922 
923                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
924                 if (transferDelayEnabled){
925                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
926                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
927                         _holderLastTransferTimestamp[tx.origin] = block.number;
928                     }
929                 }
930                  
931                 //when buy
932                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
933                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
934                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
935                 }
936                 
937                 //when sell
938                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
939                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
940                 }
941                 else if(!_isExcludedMaxTransactionAmount[to]){
942                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
943                 }
944             }
945         }
946         
947 		uint256 contractTokenBalance = balanceOf(address(this));
948         
949         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
950 
951         if( 
952             canSwap &&
953             swapEnabled &&
954             !swapping &&
955             !automatedMarketMakerPairs[from] &&
956             !_isExcludedFromFees[from] &&
957             !_isExcludedFromFees[to]
958         ) {
959             swapping = true;
960             
961             swapBack();
962 
963             swapping = false;
964         }
965 
966         bool takeFee = !swapping;
967 
968         // if any account belongs to _isExcludedFromFee account then remove the fee
969         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
970             takeFee = false;
971         }
972         
973         uint256 fees = 0;
974         // only take fees on buys/sells, do not take on wallet transfers
975         if(takeFee){
976             // on sell
977             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
978                 fees = amount * sellTotalFees/100;
979                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
980                 tokensForDev += fees * sellDevFee / sellTotalFees;
981                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
982             }
983             // on buy
984             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
985         	    fees = amount * buyTotalFees/100;
986         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
987                 tokensForDev += fees * buyDevFee / buyTotalFees;
988                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
989             }
990             
991             if(fees > 0){    
992                 super._transfer(from, address(this), fees);
993             }
994         	
995         	amount -= fees;
996         }
997 
998         super._transfer(from, to, amount);
999     }
1000 
1001     function swapTokensForEth(uint256 tokenAmount) private {
1002 
1003         // generate the uniswap pair path of token -> weth
1004         address[] memory path = new address[](2);
1005         path[0] = address(this);
1006         path[1] = uniswapV2Router.WETH();
1007 
1008         _approve(address(this), address(uniswapV2Router), tokenAmount);
1009 
1010         // make the swap
1011         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1012             tokenAmount,
1013             0, // accept any amount of ETH
1014             path,
1015             address(this),
1016             block.timestamp
1017         );
1018         
1019     }
1020     
1021     
1022     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1023         // approve token transfer to cover all possible scenarios
1024         _approve(address(this), address(uniswapV2Router), tokenAmount);
1025 
1026         // add the liquidity
1027         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1028             address(this),
1029             tokenAmount,
1030             0, // slippage is unavoidable
1031             0, // slippage is unavoidable
1032             deadAddress,
1033             block.timestamp
1034         );
1035     }
1036 
1037     function swapBack() private {
1038         uint256 contractBalance = balanceOf(address(this));
1039         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1040         bool success;
1041         
1042         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1043 
1044         if(contractBalance > swapTokensAtAmount * 20){
1045           contractBalance = swapTokensAtAmount * 20;
1046         }
1047         
1048         // Halve the amount of liquidity tokens
1049         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1050         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1051         
1052         uint256 initialETHBalance = address(this).balance;
1053 
1054         swapTokensForEth(amountToSwapForETH); 
1055         
1056         uint256 ethBalance = address(this).balance - initialETHBalance;
1057         
1058         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1059         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1060         
1061         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1062         
1063         tokensForLiquidity = 0;
1064         tokensForMarketing = 0;
1065         tokensForDev = 0;
1066         
1067         (success,) = address(devWallet).call{value: ethForDev}("");
1068         
1069         if(liquidityTokens > 0 && ethForLiquidity > 0){
1070             addLiquidity(liquidityTokens, ethForLiquidity);
1071         }
1072         
1073         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1074     }
1075 
1076     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1077         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1078         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1079         lastManualLpBurnTime = block.timestamp;
1080         
1081         // get balance of liquidity pair
1082         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1083         
1084         // calculate amount to burn
1085         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1086         
1087         // pull tokens from pancakePair liquidity and move to dead address permanently
1088         if (amountToBurn > 0){
1089             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1090         }
1091         
1092         //sync price since this is not in a swap transaction!
1093         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1094         pair.sync();
1095         return true;
1096     }
1097 }