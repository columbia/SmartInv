1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity = 0.8.19;
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
16 interface IUniswapV2Pair {
17     event Sync(uint112 reserve0, uint112 reserve1);
18     function sync() external;
19 }
20 
21 interface IUniswapV2Factory {
22     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
23 
24     function createPair(address tokenA, address tokenB) external returns (address pair);
25 }
26 
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     using SafeMath for uint256;
122 
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     /**
133      * @dev Sets the values for {name} and {symbol}.
134      *
135      * The default value of {decimals} is 18. To select a different value for
136      * {decimals} you should overload it.
137      *
138      * All two of these values are immutable: they can only be set once during
139      * construction.
140      */
141     constructor(string memory name_, string memory symbol_) {
142         _name = name_;
143         _symbol = symbol_;
144     }
145 
146     /**
147      * @dev Returns the name of the token.
148      */
149     function name() public view virtual override returns (string memory) {
150         return _name;
151     }
152 
153     /**
154      * @dev Returns the symbol of the token, usually a shorter version of the
155      * name.
156      */
157     function symbol() public view virtual override returns (string memory) {
158         return _symbol;
159     }
160 
161     /**
162      * @dev Returns the number of decimals used to get its user representation.
163      * For example, if `decimals` equals `2`, a balance of `505` tokens should
164      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
165      *
166      * Tokens usually opt for a value of 18, imitating the relationship between
167      * Ether and Wei. This is the value {ERC20} uses, unless this function is
168      * overridden;
169      *
170      * NOTE: This information is only used for _display_ purposes: it in
171      * no way affects any of the arithmetic of the contract, including
172      * {IERC20-balanceOf} and {IERC20-transfer}.
173      */
174     function decimals() public view virtual override returns (uint8) {
175         return 18;
176     }
177 
178     /**
179      * @dev See {IERC20-totalSupply}.
180      */
181     function totalSupply() public view virtual override returns (uint256) {
182         return _totalSupply;
183     }
184 
185     /**
186      * @dev See {IERC20-balanceOf}.
187      */
188     function balanceOf(address account) public view virtual override returns (uint256) {
189         return _balances[account];
190     }
191 
192     /**
193      * @dev See {IERC20-transfer}.
194      *
195      * Requirements:
196      *
197      * - `recipient` cannot be the zero address.
198      * - the caller must have a balance of at least `amount`.
199      */
200     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     /**
206      * @dev See {IERC20-allowance}.
207      */
208     function allowance(address owner, address spender) public view virtual override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     /**
213      * @dev See {IERC20-approve}.
214      *
215      * Requirements:
216      *
217      * - `spender` cannot be the zero address.
218      */
219     function approve(address spender, uint256 amount) public virtual override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See {IERC20-transferFrom}.
226      *
227      * Emits an {Approval} event indicating the updated allowance. This is not
228      * required by the EIP. See the note at the beginning of {ERC20}.
229      *
230      * Requirements:
231      *
232      * - `sender` and `recipient` cannot be the zero address.
233      * - `sender` must have a balance of at least `amount`.
234      * - the caller must have allowance for ``sender``'s tokens of at least
235      * `amount`.
236      */
237     function transferFrom(
238         address sender,
239         address recipient,
240         uint256 amount
241     ) public virtual override returns (bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244         return true;
245     }
246 
247     /**
248      * @dev Atomically increases the allowance granted to `spender` by the caller.
249      *
250      * This is an alternative to {approve} that can be used as a mitigation for
251      * problems described in {IERC20-approve}.
252      *
253      * Emits an {Approval} event indicating the updated allowance.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
260         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
261         return true;
262     }
263 
264     /**
265      * @dev Atomically decreases the allowance granted to `spender` by the caller.
266      *
267      * This is an alternative to {approve} that can be used as a mitigation for
268      * problems described in {IERC20-approve}.
269      *
270      * Emits an {Approval} event indicating the updated allowance.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      * - `spender` must have allowance for the caller of at least
276      * `subtractedValue`.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
279         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
280         return true;
281     }
282 
283     /**
284      * @dev Moves tokens `amount` from `sender` to `recipient`.
285      *
286      * This is internal function is equivalent to {transfer}, and can be used to
287      * e.g. implement automatic token fees, slashing mechanisms, etc.
288      *
289      * Emits a {Transfer} event.
290      *
291      * Requirements:
292      *
293      * - `sender` cannot be the zero address.
294      * - `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      */
297     function _transfer(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) internal virtual {
302         require(sender != address(0), "ERC20: transfer from the zero address");
303         require(recipient != address(0), "ERC20: transfer to the zero address");
304 
305         _beforeTokenTransfer(sender, recipient, amount);
306 
307         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
308         _balances[recipient] = _balances[recipient].add(amount);
309         emit Transfer(sender, recipient, amount);
310     }
311 
312     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
313      * the total supply.
314      *
315      * Emits a {Transfer} event with `from` set to the zero address.
316      *
317      * Requirements:
318      *
319      * - `account` cannot be the zero address.
320      */
321     function _mint(address account, uint256 amount) internal virtual {
322         require(account != address(0), "ERC20: mint to the zero address");
323 
324         _beforeTokenTransfer(address(0), account, amount);
325 
326         _totalSupply = _totalSupply.add(amount);
327         _balances[account] = _balances[account].add(amount);
328         emit Transfer(address(0), account, amount);
329     }
330 
331     /**
332      * @dev Destroys `amount` tokens from `account`, reducing the
333      * total supply.
334      *
335      * Emits a {Transfer} event with `to` set to the zero address.
336      *
337      * Requirements:
338      *
339      * - `account` cannot be the zero address.
340      * - `account` must have at least `amount` tokens.
341      */
342     function _burn(address account, uint256 amount) internal virtual {
343         require(account != address(0), "ERC20: burn from the zero address");
344 
345         _beforeTokenTransfer(account, address(0), amount);
346 
347         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
348         _totalSupply = _totalSupply.sub(amount);
349         emit Transfer(account, address(0), amount);
350     }
351 
352     /**
353      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
354      *
355      * This internal function is equivalent to `approve`, and can be used to
356      * e.g. set automatic allowances for certain subsystems, etc.
357      *
358      * Emits an {Approval} event.
359      *
360      * Requirements:
361      *
362      * - `owner` cannot be the zero address.
363      * - `spender` cannot be the zero address.
364      */
365     function _approve(
366         address owner,
367         address spender,
368         uint256 amount
369     ) internal virtual {
370         require(owner != address(0), "ERC20: approve from the zero address");
371         require(spender != address(0), "ERC20: approve to the zero address");
372 
373         _allowances[owner][spender] = amount;
374         emit Approval(owner, spender, amount);
375     }
376 
377     /**
378      * @dev Hook that is called before any transfer of tokens. This includes
379      * minting and burning.
380      *
381      * Calling conditions:
382      *
383      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
384      * will be to transferred to `to`.
385      * - when `from` is zero, `amount` tokens will be minted for `to`.
386      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
387      * - `from` and `to` are never both zero.
388      *
389      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
390      */
391     function _beforeTokenTransfer(
392         address from,
393         address to,
394         uint256 amount
395     ) internal virtual {}
396 }
397 
398 library SafeMath {
399     /**
400      * @dev Returns the addition of two unsigned integers, reverting on
401      * overflow.
402      *
403      * Counterpart to Solidity's `+` operator.
404      *
405      * Requirements:
406      *
407      * - Addition cannot overflow.
408      */
409     function add(uint256 a, uint256 b) internal pure returns (uint256) {
410         uint256 c = a + b;
411         require(c >= a, "SafeMath: addition overflow");
412 
413         return c;
414     }
415 
416     /**
417      * @dev Returns the subtraction of two unsigned integers, reverting on
418      * overflow (when the result is negative).
419      *
420      * Counterpart to Solidity's `-` operator.
421      *
422      * Requirements:
423      *
424      * - Subtraction cannot overflow.
425      */
426     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
427         return sub(a, b, "SafeMath: subtraction overflow");
428     }
429 
430     /**
431      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
432      * overflow (when the result is negative).
433      *
434      * Counterpart to Solidity's `-` operator.
435      *
436      * Requirements:
437      *
438      * - Subtraction cannot overflow.
439      */
440     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
441         require(b <= a, errorMessage);
442         uint256 c = a - b;
443 
444         return c;
445     }
446 
447     /**
448      * @dev Returns the multiplication of two unsigned integers, reverting on
449      * overflow.
450      *
451      * Counterpart to Solidity's `*` operator.
452      *
453      * Requirements:
454      *
455      * - Multiplication cannot overflow.
456      */
457     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
458         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
459         // benefit is lost if 'b' is also tested.
460         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
461         if (a == 0) {
462             return 0;
463         }
464 
465         uint256 c = a * b;
466         require(c / a == b, "SafeMath: multiplication overflow");
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the integer division of two unsigned integers. Reverts on
473      * division by zero. The result is rounded towards zero.
474      *
475      * Counterpart to Solidity's `/` operator. Note: this function uses a
476      * `revert` opcode (which leaves remaining gas untouched) while Solidity
477      * uses an invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function div(uint256 a, uint256 b) internal pure returns (uint256) {
484         return div(a, b, "SafeMath: division by zero");
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
489      * division by zero. The result is rounded towards zero.
490      *
491      * Counterpart to Solidity's `/` operator. Note: this function uses a
492      * `revert` opcode (which leaves remaining gas untouched) while Solidity
493      * uses an invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b > 0, errorMessage);
501         uint256 c = a / b;
502         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
503 
504         return c;
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * Reverts when dividing by zero.
510      *
511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
512      * opcode (which leaves remaining gas untouched) while Solidity uses an
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      *
517      * - The divisor cannot be zero.
518      */
519     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
520         return mod(a, b, "SafeMath: modulo by zero");
521     }
522 
523     /**
524      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
525      * Reverts with custom message when dividing by zero.
526      *
527      * Counterpart to Solidity's `%` operator. This function uses a `revert`
528      * opcode (which leaves remaining gas untouched) while Solidity uses an
529      * invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
536         require(b != 0, errorMessage);
537         return a % b;
538     }
539 }
540 
541 contract Ownable is Context {
542     address private _owner;
543 
544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
545     
546     /**
547      * @dev Initializes the contract setting the deployer as the initial owner.
548      */
549     constructor () {
550         address msgSender = _msgSender();
551         _owner = msgSender;
552         emit OwnershipTransferred(address(0), msgSender);
553     }
554 
555     /**
556      * @dev Returns the address of the current owner.
557      */
558     function owner() public view returns (address) {
559         return _owner;
560     }
561 
562     /**
563      * @dev Throws if called by any account other than the owner.
564      */
565     modifier onlyOwner() {
566         require(_owner == _msgSender(), "Ownable: caller is not the owner");
567         _;
568     }
569 
570     /**
571      * @dev Leaves the contract without owner. It will not be possible to call
572      * `onlyOwner` functions anymore. Can only be called by the current owner.
573      *
574      * NOTE: Renouncing ownership will leave the contract without an owner,
575      * thereby removing any functionality that is only available to the owner.
576      */
577     function renounceOwnership() public virtual onlyOwner {
578         emit OwnershipTransferred(_owner, address(0));
579         _owner = address(0);
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Can only be called by the current owner.
585      */
586     function transferOwnership(address newOwner) public virtual onlyOwner {
587         require(newOwner != address(0), "Ownable: new owner is the zero address");
588         emit OwnershipTransferred(_owner, newOwner);
589         _owner = newOwner;
590     }
591 }
592 
593 
594 
595 library SafeMathInt {
596     int256 private constant MIN_INT256 = int256(1) << 255;
597     int256 private constant MAX_INT256 = ~(int256(1) << 255);
598 
599     /**
600      * @dev Multiplies two int256 variables and fails on overflow.
601      */
602     function mul(int256 a, int256 b) internal pure returns (int256) {
603         int256 c = a * b;
604 
605         // Detect overflow when multiplying MIN_INT256 with -1
606         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
607         require((b == 0) || (c / b == a));
608         return c;
609     }
610 
611     /**
612      * @dev Division of two int256 variables and fails on overflow.
613      */
614     function div(int256 a, int256 b) internal pure returns (int256) {
615         // Prevent overflow when dividing MIN_INT256 by -1
616         require(b != -1 || a != MIN_INT256);
617 
618         // Solidity already throws when dividing by 0.
619         return a / b;
620     }
621 
622     /**
623      * @dev Subtracts two int256 variables and fails on overflow.
624      */
625     function sub(int256 a, int256 b) internal pure returns (int256) {
626         int256 c = a - b;
627         require((b >= 0 && c <= a) || (b < 0 && c > a));
628         return c;
629     }
630 
631     /**
632      * @dev Adds two int256 variables and fails on overflow.
633      */
634     function add(int256 a, int256 b) internal pure returns (int256) {
635         int256 c = a + b;
636         require((b >= 0 && c >= a) || (b < 0 && c < a));
637         return c;
638     }
639 
640     /**
641      * @dev Converts to absolute value, and fails on overflow.
642      */
643     function abs(int256 a) internal pure returns (int256) {
644         require(a != MIN_INT256);
645         return a < 0 ? -a : a;
646     }
647 
648 
649     function toUint256Safe(int256 a) internal pure returns (uint256) {
650         require(a >= 0);
651         return uint256(a);
652     }
653 }
654 
655 library SafeMathUint {
656   function toInt256Safe(uint256 a) internal pure returns (int256) {
657     int256 b = int256(a);
658     require(b >= 0);
659     return b;
660   }
661 }
662 
663 
664 interface IUniswapV2Router01 {
665     function factory() external pure returns (address);
666     function WETH() external pure returns (address);
667 
668     function addLiquidityETH(
669         address token,
670         uint amountTokenDesired,
671         uint amountTokenMin,
672         uint amountETHMin,
673         address to,
674         uint deadline
675     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
676 }
677 
678 interface IUniswapV2Router02 is IUniswapV2Router01 {
679     function swapExactTokensForETHSupportingFeeOnTransferTokens(
680         uint amountIn,
681         uint amountOutMin,
682         address[] calldata path,
683         address to,
684         uint deadline
685     ) external;
686 }
687 
688 contract CSHIB is ERC20, Ownable {
689 
690     IUniswapV2Router02 public immutable uniswapV2Router;
691     address public immutable uniswapV2Pair;
692     address public constant deadAddress = address(0xdead);
693 
694     bool private swapping;
695 
696     address private marketingWallet;
697     address private devWallet;
698     
699     uint256 public maxTransactionAmount;
700     uint256 public swapTokensAtAmount;
701     uint256 public maxWallet;
702     
703     uint256 public percentForLPBurn = 25; // 25 = .25%
704     bool public lpBurnEnabled = false;
705     uint256 public lpBurnFrequency = 3600 seconds;
706     uint256 public lastLpBurnTime;
707     
708     uint256 public manualBurnFrequency = 30 minutes;
709     uint256 public lastManualLpBurnTime;
710 
711     bool public limitsInEffect = true;
712     bool public tradingActive = false;
713     bool public swapEnabled = false;
714     
715      // Anti-bot and anti-whale mappings and variables
716     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
717     mapping (address => bool) public isBlacklisted;
718     bool public transferDelayEnabled = true;
719 
720     uint256 public buyTotalFees;
721     uint256 public buyMarketingFee;
722     uint256 public buyLiquidityFee;
723     uint256 public buyDevFee;
724     
725     uint256 public sellTotalFees;
726     uint256 public sellMarketingFee;
727     uint256 public sellLiquidityFee;
728     uint256 public sellDevFee;
729     
730     uint256 public tokensForMarketing;
731     uint256 public tokensForLiquidity;
732     uint256 public tokensForDev;
733 
734     // exlcude from fees and max transaction amount
735     mapping (address => bool) private _isExcludedFromFees;
736     mapping (address => bool) public _isExcludedMaxTransactionAmount;
737 
738     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
739     // could be subject to a maximum transfer amount
740     mapping (address => bool) public automatedMarketMakerPairs;
741 
742     constructor() ERC20("Shibarium Classic", "CSHIB") {
743         
744         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
745         
746         excludeFromMaxTransaction(address(_uniswapV2Router), true);
747         uniswapV2Router = _uniswapV2Router;
748         
749         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
750         excludeFromMaxTransaction(address(uniswapV2Pair), true);
751         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
752         
753         uint256 _buyMarketingFee = 0;
754         uint256 _buyLiquidityFee = 0;
755         uint256 _buyDevFee = 25;
756 
757         uint256 _sellMarketingFee = 0;
758         uint256 _sellLiquidityFee = 0;
759         uint256 _sellDevFee = 25;
760         
761         uint256 totalSupply = 1000000000000 * 1e18; 
762         
763         maxTransactionAmount = totalSupply * 2 / 100; 
764         maxWallet = totalSupply * 2 / 100; 
765         swapTokensAtAmount = totalSupply * 5 / 1000; 
766 
767         buyMarketingFee = _buyMarketingFee;
768         buyLiquidityFee = _buyLiquidityFee;
769         buyDevFee = _buyDevFee;
770         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
771         
772         sellMarketingFee = _sellMarketingFee;
773         sellLiquidityFee = _sellLiquidityFee;
774         sellDevFee = _sellDevFee;
775         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
776         
777         marketingWallet = address(owner()); // set as marketing wallet
778         devWallet = address(owner()); // set as dev wallet
779 
780         // exclude from paying fees or having max transaction amount
781         excludeFromFees(owner(), true);
782         excludeFromFees(address(this), true);
783         excludeFromFees(address(0xdead), true);
784         
785         excludeFromMaxTransaction(owner(), true);
786         excludeFromMaxTransaction(address(this), true);
787         excludeFromMaxTransaction(address(0xdead), true);
788         
789         _mint(msg.sender, totalSupply);
790     }
791 
792     receive() external payable {
793 
794   	}
795 
796     // once enabled, can never be turned off
797     function openTrading() external onlyOwner {
798         tradingActive = true;
799         swapEnabled = true;
800         lastLpBurnTime = block.timestamp;
801     }
802     
803     // remove limits after token is stable
804     function removelimits() external onlyOwner returns (bool){
805         limitsInEffect = false;
806         transferDelayEnabled = false;
807         return true;
808     }
809     
810     // change the minimum amount of tokens to sell from fees
811     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
812   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
813   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
814   	    return true;
815   	}
816     
817     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
818         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
819         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
820         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
821         maxWallet = (totalSupply() * walNum / 100)/1e18;
822     }
823 
824     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
825         _isExcludedMaxTransactionAmount[updAds] = isEx;
826     }
827     
828     // only use to disable contract sales if absolutely necessary (emergency use only)
829     function updateSwapEnabled(bool enabled) external onlyOwner(){
830         swapEnabled = enabled;
831     }
832     
833     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
834         buyMarketingFee = _marketingFee;
835         buyLiquidityFee = _liquidityFee;
836         buyDevFee = _devFee;
837         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
838         require(buyTotalFees <= 40, "Must keep fees at 20% or less");
839     }
840     
841     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
842         sellMarketingFee = _marketingFee;
843         sellLiquidityFee = _liquidityFee;
844         sellDevFee = _devFee;
845         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
846         require(sellTotalFees <= 40, "Must keep fees at 25% or less");
847     }
848 
849     function excludeFromFees(address account, bool excluded) public onlyOwner {
850         _isExcludedFromFees[account] = excluded;
851     }
852 
853     function _setAutomatedMarketMakerPair(address pair, bool value) private {
854         automatedMarketMakerPairs[pair] = value;
855     }
856 
857     function changeclassicMarketingWallet(address newMarketingWallet) external onlyOwner {
858         marketingWallet = newMarketingWallet;
859     }
860     
861     function changeclassicDevWallet(address newWallet) external onlyOwner {
862         devWallet = newWallet;
863     }
864 
865     function isExcludedFromFees(address account) public view returns(bool) {
866         return _isExcludedFromFees[account];
867     }
868 
869     function updateclassic_bots(address _address, bool status) external onlyOwner {
870         require(_address != address(0),"Address should not be 0");
871         isBlacklisted[_address] = status;
872     }
873 
874     function _transfer(
875         address from,
876         address to,
877         uint256 amount
878     ) internal override {
879         require(from != address(0), "ERC20: transfer from the zero address");
880         require(to != address(0), "ERC20: transfer to the zero address");
881         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
882         
883          if(amount == 0) {
884             super._transfer(from, to, 0);
885             return;
886         }
887         
888         if(limitsInEffect){
889             if (
890                 from != owner() &&
891                 to != owner() &&
892                 to != address(0) &&
893                 to != address(0xdead) &&
894                 !swapping
895             ){
896                 if(!tradingActive){
897                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
898                 }
899 
900                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
901                 if (transferDelayEnabled){
902                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
903                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
904                         _holderLastTransferTimestamp[tx.origin] = block.number;
905                     }
906                 }
907                  
908                 //when buy
909                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
910                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
911                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
912                 }
913                 
914                 //when sell
915                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
916                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
917                 }
918                 else if(!_isExcludedMaxTransactionAmount[to]){
919                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
920                 }
921             }
922         }
923         
924 		uint256 contractTokenBalance = balanceOf(address(this));
925         
926         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
927 
928         if( 
929             canSwap &&
930             swapEnabled &&
931             !swapping &&
932             !automatedMarketMakerPairs[from] &&
933             !_isExcludedFromFees[from] &&
934             !_isExcludedFromFees[to]
935         ) {
936             swapping = true;
937             
938             swapBack();
939 
940             swapping = false;
941         }
942 
943         bool takeFee = !swapping;
944 
945         // if any account belongs to _isExcludedFromFee account then remove the fee
946         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
947             takeFee = false;
948         }
949         
950         uint256 fees = 0;
951         // only take fees on buys/sells, do not take on wallet transfers
952         if(takeFee){
953             // on sell
954             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
955                 fees = amount * sellTotalFees/100;
956                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
957                 tokensForDev += fees * sellDevFee / sellTotalFees;
958                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
959             }
960             // on buy
961             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
962         	    fees = amount * buyTotalFees/100;
963         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
964                 tokensForDev += fees * buyDevFee / buyTotalFees;
965                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
966             }
967             
968             if(fees > 0){    
969                 super._transfer(from, address(this), fees);
970             }
971         	
972         	amount -= fees;
973         }
974 
975         super._transfer(from, to, amount);
976     }
977 
978     function swapTokensForEth(uint256 tokenAmount) private {
979 
980         // generate the uniswap pair path of token -> weth
981         address[] memory path = new address[](2);
982         path[0] = address(this);
983         path[1] = uniswapV2Router.WETH();
984 
985         _approve(address(this), address(uniswapV2Router), tokenAmount);
986 
987         // make the swap
988         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
989             tokenAmount,
990             0, // accept any amount of ETH
991             path,
992             address(this),
993             block.timestamp
994         );
995         
996     }
997     
998     
999     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1000         // approve token transfer to cover all possible scenarios
1001         _approve(address(this), address(uniswapV2Router), tokenAmount);
1002 
1003         // add the liquidity
1004         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1005             address(this),
1006             tokenAmount,
1007             0, // 
1008             0, // 
1009             deadAddress,
1010             block.timestamp
1011         );
1012     }
1013 
1014     function swapBack() private {
1015         uint256 contractBalance = balanceOf(address(this));
1016         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1017         bool success;
1018         
1019         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1020 
1021         if(contractBalance > swapTokensAtAmount * 20){
1022           contractBalance = swapTokensAtAmount * 20;
1023         }
1024         
1025         // Halve the amount of liquidity tokens
1026         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1027         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1028         
1029         uint256 initialETHBalance = address(this).balance;
1030 
1031         swapTokensForEth(amountToSwapForETH); 
1032         
1033         uint256 ethBalance = address(this).balance - initialETHBalance;
1034         
1035         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1036         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1037         
1038         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1039         
1040         tokensForLiquidity = 0;
1041         tokensForMarketing = 0;
1042         tokensForDev = 0;
1043         
1044         (success,) = address(devWallet).call{value: ethForDev}("");
1045         
1046         if(liquidityTokens > 0 && ethForLiquidity > 0){
1047             addLiquidity(liquidityTokens, ethForLiquidity);
1048         }
1049         
1050         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1051     }
1052 
1053     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1054         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1055         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1056         lastManualLpBurnTime = block.timestamp;
1057         
1058 
1059         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1060         
1061    
1062         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1063         
1064     
1065         if (amountToBurn > 0){
1066             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1067         }
1068         
1069         //sync price since this is not in a swap transaction!
1070         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1071         pair.sync();
1072         return true;
1073     }
1074 }