1 //https://pepeinucoin.vip/
2 
3 //https://t.me/pepe_inu_coin
4 
5 //https://twitter.com/Pepe_Inu_Coin
6 
7 // SPDX-License-Identifier: MIT                                                                               
8                                                     
9 pragma solidity = 0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IUniswapV2Pair {
23     event Sync(uint112 reserve0, uint112 reserve1);
24     function sync() external;
25 }
26 
27 interface IUniswapV2Factory {
28     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
29 
30     function createPair(address tokenA, address tokenB) external returns (address pair);
31 }
32 
33 interface IERC20 {
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
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
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
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     using SafeMath for uint256;
128 
129     mapping(address => uint256) private _balances;
130 
131     mapping(address => mapping(address => uint256)) private _allowances;
132 
133     uint256 private _totalSupply;
134 
135     string private _name;
136     string private _symbol;
137 
138     /**
139      * @dev Sets the values for {name} and {symbol}.
140      *
141      * The default value of {decimals} is 18. To select a different value for
142      * {decimals} you should overload it.
143      *
144      * All two of these values are immutable: they can only be set once during
145      * construction.
146      */
147     constructor(string memory name_, string memory symbol_) {
148         _name = name_;
149         _symbol = symbol_;
150     }
151 
152     /**
153      * @dev Returns the name of the token.
154      */
155     function name() public view virtual override returns (string memory) {
156         return _name;
157     }
158 
159     /**
160      * @dev Returns the symbol of the token, usually a shorter version of the
161      * name.
162      */
163     function symbol() public view virtual override returns (string memory) {
164         return _symbol;
165     }
166 
167     /**
168      * @dev Returns the number of decimals used to get its user representation.
169      * For example, if `decimals` equals `2`, a balance of `505` tokens should
170      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
171      *
172      * Tokens usually opt for a value of 18, imitating the relationship between
173      * Ether and Wei. This is the value {ERC20} uses, unless this function is
174      * overridden;
175      *
176      * NOTE: This information is only used for _display_ purposes: it in
177      * no way affects any of the arithmetic of the contract, including
178      * {IERC20-balanceOf} and {IERC20-transfer}.
179      */
180     function decimals() public view virtual override returns (uint8) {
181         return 18;
182     }
183 
184     /**
185      * @dev See {IERC20-totalSupply}.
186      */
187     function totalSupply() public view virtual override returns (uint256) {
188         return _totalSupply;
189     }
190 
191     /**
192      * @dev See {IERC20-balanceOf}.
193      */
194     function balanceOf(address account) public view virtual override returns (uint256) {
195         return _balances[account];
196     }
197 
198     /**
199      * @dev See {IERC20-transfer}.
200      *
201      * Requirements:
202      *
203      * - `recipient` cannot be the zero address.
204      * - the caller must have a balance of at least `amount`.
205      */
206     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     /**
212      * @dev See {IERC20-allowance}.
213      */
214     function allowance(address owner, address spender) public view virtual override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     /**
219      * @dev See {IERC20-approve}.
220      *
221      * Requirements:
222      *
223      * - `spender` cannot be the zero address.
224      */
225     function approve(address spender, uint256 amount) public virtual override returns (bool) {
226         _approve(_msgSender(), spender, amount);
227         return true;
228     }
229 
230     /**
231      * @dev See {IERC20-transferFrom}.
232      *
233      * Emits an {Approval} event indicating the updated allowance. This is not
234      * required by the EIP. See the note at the beginning of {ERC20}.
235      *
236      * Requirements:
237      *
238      * - `sender` and `recipient` cannot be the zero address.
239      * - `sender` must have a balance of at least `amount`.
240      * - the caller must have allowance for ``sender``'s tokens of at least
241      * `amount`.
242      */
243     function transferFrom(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) public virtual override returns (bool) {
248         _transfer(sender, recipient, amount);
249         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
250         return true;
251     }
252 
253     /**
254      * @dev Atomically increases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to {approve} that can be used as a mitigation for
257      * problems described in {IERC20-approve}.
258      *
259      * Emits an {Approval} event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
266         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
267         return true;
268     }
269 
270     /**
271      * @dev Atomically decreases the allowance granted to `spender` by the caller.
272      *
273      * This is an alternative to {approve} that can be used as a mitigation for
274      * problems described in {IERC20-approve}.
275      *
276      * Emits an {Approval} event indicating the updated allowance.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      * - `spender` must have allowance for the caller of at least
282      * `subtractedValue`.
283      */
284     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
285         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
286         return true;
287     }
288 
289     /**
290      * @dev Moves tokens `amount` from `sender` to `recipient`.
291      *
292      * This is internal function is equivalent to {transfer}, and can be used to
293      * e.g. implement automatic token fees, slashing mechanisms, etc.
294      *
295      * Emits a {Transfer} event.
296      *
297      * Requirements:
298      *
299      * - `sender` cannot be the zero address.
300      * - `recipient` cannot be the zero address.
301      * - `sender` must have a balance of at least `amount`.
302      */
303     function _transfer(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) internal virtual {
308         require(sender != address(0), "ERC20: transfer from the zero address");
309         require(recipient != address(0), "ERC20: transfer to the zero address");
310 
311         _beforeTokenTransfer(sender, recipient, amount);
312 
313         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
314         _balances[recipient] = _balances[recipient].add(amount);
315         emit Transfer(sender, recipient, amount);
316     }
317 
318     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
319      * the total supply.
320      *
321      * Emits a {Transfer} event with `from` set to the zero address.
322      *
323      * Requirements:
324      *
325      * - `account` cannot be the zero address.
326      */
327     function _mint(address account, uint256 amount) internal virtual {
328         require(account != address(0), "ERC20: mint to the zero address");
329 
330         _beforeTokenTransfer(address(0), account, amount);
331 
332         _totalSupply = _totalSupply.add(amount);
333         _balances[account] = _balances[account].add(amount);
334         emit Transfer(address(0), account, amount);
335     }
336 
337     /**
338      * @dev Destroys `amount` tokens from `account`, reducing the
339      * total supply.
340      *
341      * Emits a {Transfer} event with `to` set to the zero address.
342      *
343      * Requirements:
344      *
345      * - `account` cannot be the zero address.
346      * - `account` must have at least `amount` tokens.
347      */
348     function _burn(address account, uint256 amount) internal virtual {
349         require(account != address(0), "ERC20: burn from the zero address");
350 
351         _beforeTokenTransfer(account, address(0), amount);
352 
353         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
354         _totalSupply = _totalSupply.sub(amount);
355         emit Transfer(account, address(0), amount);
356     }
357 
358     /**
359      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
360      *
361      * This internal function is equivalent to `approve`, and can be used to
362      * e.g. set automatic allowances for certain subsystems, etc.
363      *
364      * Emits an {Approval} event.
365      *
366      * Requirements:
367      *
368      * - `owner` cannot be the zero address.
369      * - `spender` cannot be the zero address.
370      */
371     function _approve(
372         address owner,
373         address spender,
374         uint256 amount
375     ) internal virtual {
376         require(owner != address(0), "ERC20: approve from the zero address");
377         require(spender != address(0), "ERC20: approve to the zero address");
378 
379         _allowances[owner][spender] = amount;
380         emit Approval(owner, spender, amount);
381     }
382 
383     /**
384      * @dev Hook that is called before any transfer of tokens. This includes
385      * minting and burning.
386      *
387      * Calling conditions:
388      *
389      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
390      * will be to transferred to `to`.
391      * - when `from` is zero, `amount` tokens will be minted for `to`.
392      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
393      * - `from` and `to` are never both zero.
394      *
395      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
396      */
397     function _beforeTokenTransfer(
398         address from,
399         address to,
400         uint256 amount
401     ) internal virtual {}
402 }
403 
404 library SafeMath {
405     /**
406      * @dev Returns the addition of two unsigned integers, reverting on
407      * overflow.
408      *
409      * Counterpart to Solidity's `+` operator.
410      *
411      * Requirements:
412      *
413      * - Addition cannot overflow.
414      */
415     function add(uint256 a, uint256 b) internal pure returns (uint256) {
416         uint256 c = a + b;
417         require(c >= a, "SafeMath: addition overflow");
418 
419         return c;
420     }
421 
422     /**
423      * @dev Returns the subtraction of two unsigned integers, reverting on
424      * overflow (when the result is negative).
425      *
426      * Counterpart to Solidity's `-` operator.
427      *
428      * Requirements:
429      *
430      * - Subtraction cannot overflow.
431      */
432     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
433         return sub(a, b, "SafeMath: subtraction overflow");
434     }
435 
436     /**
437      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
438      * overflow (when the result is negative).
439      *
440      * Counterpart to Solidity's `-` operator.
441      *
442      * Requirements:
443      *
444      * - Subtraction cannot overflow.
445      */
446     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
447         require(b <= a, errorMessage);
448         uint256 c = a - b;
449 
450         return c;
451     }
452 
453     /**
454      * @dev Returns the multiplication of two unsigned integers, reverting on
455      * overflow.
456      *
457      * Counterpart to Solidity's `*` operator.
458      *
459      * Requirements:
460      *
461      * - Multiplication cannot overflow.
462      */
463     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
464         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
465         // benefit is lost if 'b' is also tested.
466         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
467         if (a == 0) {
468             return 0;
469         }
470 
471         uint256 c = a * b;
472         require(c / a == b, "SafeMath: multiplication overflow");
473 
474         return c;
475     }
476 
477     /**
478      * @dev Returns the integer division of two unsigned integers. Reverts on
479      * division by zero. The result is rounded towards zero.
480      *
481      * Counterpart to Solidity's `/` operator. Note: this function uses a
482      * `revert` opcode (which leaves remaining gas untouched) while Solidity
483      * uses an invalid opcode to revert (consuming all remaining gas).
484      *
485      * Requirements:
486      *
487      * - The divisor cannot be zero.
488      */
489     function div(uint256 a, uint256 b) internal pure returns (uint256) {
490         return div(a, b, "SafeMath: division by zero");
491     }
492 
493     /**
494      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
495      * division by zero. The result is rounded towards zero.
496      *
497      * Counterpart to Solidity's `/` operator. Note: this function uses a
498      * `revert` opcode (which leaves remaining gas untouched) while Solidity
499      * uses an invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      *
503      * - The divisor cannot be zero.
504      */
505     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b > 0, errorMessage);
507         uint256 c = a / b;
508         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
509 
510         return c;
511     }
512 
513     /**
514      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
515      * Reverts when dividing by zero.
516      *
517      * Counterpart to Solidity's `%` operator. This function uses a `revert`
518      * opcode (which leaves remaining gas untouched) while Solidity uses an
519      * invalid opcode to revert (consuming all remaining gas).
520      *
521      * Requirements:
522      *
523      * - The divisor cannot be zero.
524      */
525     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
526         return mod(a, b, "SafeMath: modulo by zero");
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
531      * Reverts with custom message when dividing by zero.
532      *
533      * Counterpart to Solidity's `%` operator. This function uses a `revert`
534      * opcode (which leaves remaining gas untouched) while Solidity uses an
535      * invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
542         require(b != 0, errorMessage);
543         return a % b;
544     }
545 }
546 
547 contract Ownable is Context {
548     address private _owner;
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551     
552     /**
553      * @dev Initializes the contract setting the deployer as the initial owner.
554      */
555     constructor () {
556         address msgSender = _msgSender();
557         _owner = msgSender;
558         emit OwnershipTransferred(address(0), msgSender);
559     }
560 
561     /**
562      * @dev Returns the address of the current owner.
563      */
564     function owner() public view returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if called by any account other than the owner.
570      */
571     modifier onlyOwner() {
572         require(_owner == _msgSender(), "Ownable: caller is not the owner");
573         _;
574     }
575 
576     /**
577      * @dev Leaves the contract without owner. It will not be possible to call
578      * `onlyOwner` functions anymore. Can only be called by the current owner.
579      *
580      * NOTE: Renouncing ownership will leave the contract without an owner,
581      * thereby removing any functionality that is only available to the owner.
582      */
583     function renounceOwnership() public virtual onlyOwner {
584         emit OwnershipTransferred(_owner, address(0));
585         _owner = address(0);
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Can only be called by the current owner.
591      */
592     function transferOwnership(address newOwner) public virtual onlyOwner {
593         require(newOwner != address(0), "Ownable: new owner is the zero address");
594         emit OwnershipTransferred(_owner, newOwner);
595         _owner = newOwner;
596     }
597 }
598 
599 
600 
601 library SafeMathInt {
602     int256 private constant MIN_INT256 = int256(1) << 255;
603     int256 private constant MAX_INT256 = ~(int256(1) << 255);
604 
605     /**
606      * @dev Multiplies two int256 variables and fails on overflow.
607      */
608     function mul(int256 a, int256 b) internal pure returns (int256) {
609         int256 c = a * b;
610 
611         // Detect overflow when multiplying MIN_INT256 with -1
612         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
613         require((b == 0) || (c / b == a));
614         return c;
615     }
616 
617     /**
618      * @dev Division of two int256 variables and fails on overflow.
619      */
620     function div(int256 a, int256 b) internal pure returns (int256) {
621         // Prevent overflow when dividing MIN_INT256 by -1
622         require(b != -1 || a != MIN_INT256);
623 
624         // Solidity already throws when dividing by 0.
625         return a / b;
626     }
627 
628     /**
629      * @dev Subtracts two int256 variables and fails on overflow.
630      */
631     function sub(int256 a, int256 b) internal pure returns (int256) {
632         int256 c = a - b;
633         require((b >= 0 && c <= a) || (b < 0 && c > a));
634         return c;
635     }
636 
637     /**
638      * @dev Adds two int256 variables and fails on overflow.
639      */
640     function add(int256 a, int256 b) internal pure returns (int256) {
641         int256 c = a + b;
642         require((b >= 0 && c >= a) || (b < 0 && c < a));
643         return c;
644     }
645 
646     /**
647      * @dev Converts to absolute value, and fails on overflow.
648      */
649     function abs(int256 a) internal pure returns (int256) {
650         require(a != MIN_INT256);
651         return a < 0 ? -a : a;
652     }
653 
654 
655     function toUint256Safe(int256 a) internal pure returns (uint256) {
656         require(a >= 0);
657         return uint256(a);
658     }
659 }
660 
661 library SafeMathUint {
662   function toInt256Safe(uint256 a) internal pure returns (int256) {
663     int256 b = int256(a);
664     require(b >= 0);
665     return b;
666   }
667 }
668 
669 
670 interface IUniswapV2Router01 {
671     function factory() external pure returns (address);
672     function WETH() external pure returns (address);
673 
674     function addLiquidityETH(
675         address token,
676         uint amountTokenDesired,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline
681     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
682 }
683 
684 interface IUniswapV2Router02 is IUniswapV2Router01 {
685     function swapExactTokensForETHSupportingFeeOnTransferTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external;
692 }
693 
694 contract PINU is ERC20, Ownable {
695 
696     IUniswapV2Router02 public immutable uniswapV2Router;
697     address public immutable uniswapV2Pair;
698     address public constant deadAddress = address(0xdead);
699 
700     bool private swapping;
701 
702     address public marketingWallet;
703     address public devWallet;
704     
705     uint256 public maxTransactionAmount;
706     uint256 public swapTokensAtAmount;
707     uint256 public maxWallet;
708     
709     uint256 public percentForLPBurn = 25; // 25 = .25%
710     bool public lpBurnEnabled = false;
711     uint256 public lpBurnFrequency = 3600 seconds;
712     uint256 public lastLpBurnTime;
713     
714     uint256 public manualBurnFrequency = 30 minutes;
715     uint256 public lastManualLpBurnTime;
716 
717     bool public limitsInEffect = true;
718     bool public tradingActive = false;
719     bool public swapEnabled = false;
720     
721      // Anti-bot and anti-whale mappings and variables
722     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
723     mapping (address => bool) public isBlacklisted;
724     bool public transferDelayEnabled = true;
725 
726     uint256 public buyTotalFees;
727     uint256 public buyMarketingFee;
728     uint256 public buyLiquidityFee;
729     uint256 public buyDevFee;
730     
731     uint256 public sellTotalFees;
732     uint256 public sellMarketingFee;
733     uint256 public sellLiquidityFee;
734     uint256 public sellDevFee;
735     
736     uint256 public tokensForMarketing;
737     uint256 public tokensForLiquidity;
738     uint256 public tokensForDev;
739 
740     // exlcude from fees and max transaction amount
741     mapping (address => bool) private _isExcludedFromFees;
742     mapping (address => bool) public _isExcludedMaxTransactionAmount;
743 
744     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
745     // could be subject to a maximum transfer amount
746     mapping (address => bool) public automatedMarketMakerPairs;
747 
748     constructor() ERC20("Pepe Inu", "PEPINU") {
749         
750         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
751         
752         excludeFromMaxTransaction(address(_uniswapV2Router), true);
753         uniswapV2Router = _uniswapV2Router;
754         
755         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
756         excludeFromMaxTransaction(address(uniswapV2Pair), true);
757         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
758         
759         uint256 _buyMarketingFee = 0;
760         uint256 _buyLiquidityFee = 0;
761         uint256 _buyDevFee = 25;
762 
763         uint256 _sellMarketingFee = 0;
764         uint256 _sellLiquidityFee = 0;
765         uint256 _sellDevFee = 25;
766         
767         uint256 totalSupply = 1000000000000 * 1e18; 
768         
769         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
770         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
771         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
772 
773         buyMarketingFee = _buyMarketingFee;
774         buyLiquidityFee = _buyLiquidityFee;
775         buyDevFee = _buyDevFee;
776         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
777         
778         sellMarketingFee = _sellMarketingFee;
779         sellLiquidityFee = _sellLiquidityFee;
780         sellDevFee = _sellDevFee;
781         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
782         
783         marketingWallet = address(owner()); // set as marketing wallet
784         devWallet = address(owner()); // set as dev wallet
785 
786         // exclude from paying fees or having max transaction amount
787         excludeFromFees(owner(), true);
788         excludeFromFees(address(this), true);
789         excludeFromFees(address(0xdead), true);
790         
791         excludeFromMaxTransaction(owner(), true);
792         excludeFromMaxTransaction(address(this), true);
793         excludeFromMaxTransaction(address(0xdead), true);
794         
795         _mint(msg.sender, totalSupply);
796     }
797 
798     receive() external payable {
799 
800   	}
801 
802     // once enabled, can never be turned off
803     function openTrading() external onlyOwner {
804         tradingActive = true;
805         swapEnabled = true;
806         lastLpBurnTime = block.timestamp;
807     }
808     
809     // remove limits after token is stable
810     function removelimits() external onlyOwner returns (bool){
811         limitsInEffect = false;
812         transferDelayEnabled = false;
813         return true;
814     }
815     
816     // change the minimum amount of tokens to sell from fees
817     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
818   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
819   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
820   	    return true;
821   	}
822     
823     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
824         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
825         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
826         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
827         maxWallet = (totalSupply() * walNum / 100)/1e18;
828     }
829 
830     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
831         _isExcludedMaxTransactionAmount[updAds] = isEx;
832     }
833     
834     // only use to disable contract sales if absolutely necessary (emergency use only)
835     function updateSwapEnabled(bool enabled) external onlyOwner(){
836         swapEnabled = enabled;
837     }
838     
839     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
840         buyMarketingFee = _marketingFee;
841         buyLiquidityFee = _liquidityFee;
842         buyDevFee = _devFee;
843         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
844         require(buyTotalFees <= 40, "Must keep fees at 20% or less");
845     }
846     
847     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
848         sellMarketingFee = _marketingFee;
849         sellLiquidityFee = _liquidityFee;
850         sellDevFee = _devFee;
851         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
852         require(sellTotalFees <= 70, "Must keep fees at 25% or less");
853     }
854 
855     function excludeFromFees(address account, bool excluded) public onlyOwner {
856         _isExcludedFromFees[account] = excluded;
857     }
858 
859     function _setAutomatedMarketMakerPair(address pair, bool value) private {
860         automatedMarketMakerPairs[pair] = value;
861     }
862 
863     function refurbishMarketingWallet(address newMarketingWallet) external onlyOwner {
864         marketingWallet = newMarketingWallet;
865     }
866     
867     function refurbishDevWallet(address newWallet) external onlyOwner {
868         devWallet = newWallet;
869     }
870 
871     function isExcludedFromFees(address account) public view returns(bool) {
872         return _isExcludedFromFees[account];
873     }
874 
875     function govern_bots(address _address, bool status) external onlyOwner {
876         require(_address != address(0),"Address should not be 0");
877         isBlacklisted[_address] = status;
878     }
879 
880     function _transfer(
881         address from,
882         address to,
883         uint256 amount
884     ) internal override {
885         require(from != address(0), "ERC20: transfer from the zero address");
886         require(to != address(0), "ERC20: transfer to the zero address");
887         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
888         
889          if(amount == 0) {
890             super._transfer(from, to, 0);
891             return;
892         }
893         
894         if(limitsInEffect){
895             if (
896                 from != owner() &&
897                 to != owner() &&
898                 to != address(0) &&
899                 to != address(0xdead) &&
900                 !swapping
901             ){
902                 if(!tradingActive){
903                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
904                 }
905 
906                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
907                 if (transferDelayEnabled){
908                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
909                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
910                         _holderLastTransferTimestamp[tx.origin] = block.number;
911                     }
912                 }
913                  
914                 //when buy
915                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
916                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
917                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
918                 }
919                 
920                 //when sell
921                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
922                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
923                 }
924                 else if(!_isExcludedMaxTransactionAmount[to]){
925                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
926                 }
927             }
928         }
929         
930 		uint256 contractTokenBalance = balanceOf(address(this));
931         
932         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
933 
934         if( 
935             canSwap &&
936             swapEnabled &&
937             !swapping &&
938             !automatedMarketMakerPairs[from] &&
939             !_isExcludedFromFees[from] &&
940             !_isExcludedFromFees[to]
941         ) {
942             swapping = true;
943             
944             swapBack();
945 
946             swapping = false;
947         }
948 
949         bool takeFee = !swapping;
950 
951         // if any account belongs to _isExcludedFromFee account then remove the fee
952         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
953             takeFee = false;
954         }
955         
956         uint256 fees = 0;
957         // only take fees on buys/sells, do not take on wallet transfers
958         if(takeFee){
959             // on sell
960             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
961                 fees = amount * sellTotalFees/100;
962                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
963                 tokensForDev += fees * sellDevFee / sellTotalFees;
964                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
965             }
966             // on buy
967             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
968         	    fees = amount * buyTotalFees/100;
969         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
970                 tokensForDev += fees * buyDevFee / buyTotalFees;
971                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
972             }
973             
974             if(fees > 0){    
975                 super._transfer(from, address(this), fees);
976             }
977         	
978         	amount -= fees;
979         }
980 
981         super._transfer(from, to, amount);
982     }
983 
984     function swapTokensForEth(uint256 tokenAmount) private {
985 
986         // generate the uniswap pair path of token -> weth
987         address[] memory path = new address[](2);
988         path[0] = address(this);
989         path[1] = uniswapV2Router.WETH();
990 
991         _approve(address(this), address(uniswapV2Router), tokenAmount);
992 
993         // make the swap
994         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
995             tokenAmount,
996             0, // accept any amount of ETH
997             path,
998             address(this),
999             block.timestamp
1000         );
1001         
1002     }
1003     
1004     
1005     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1006         // approve token transfer to cover all possible scenarios
1007         _approve(address(this), address(uniswapV2Router), tokenAmount);
1008 
1009         // add the liquidity
1010         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1011             address(this),
1012             tokenAmount,
1013             0, // slippage is unavoidable
1014             0, // slippage is unavoidable
1015             deadAddress,
1016             block.timestamp
1017         );
1018     }
1019 
1020     function swapBack() private {
1021         uint256 contractBalance = balanceOf(address(this));
1022         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1023         bool success;
1024         
1025         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1026 
1027         if(contractBalance > swapTokensAtAmount * 20){
1028           contractBalance = swapTokensAtAmount * 20;
1029         }
1030         
1031         // Halve the amount of liquidity tokens
1032         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1033         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1034         
1035         uint256 initialETHBalance = address(this).balance;
1036 
1037         swapTokensForEth(amountToSwapForETH); 
1038         
1039         uint256 ethBalance = address(this).balance - initialETHBalance;
1040         
1041         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1042         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1043         
1044         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1045         
1046         tokensForLiquidity = 0;
1047         tokensForMarketing = 0;
1048         tokensForDev = 0;
1049         
1050         (success,) = address(devWallet).call{value: ethForDev}("");
1051         
1052         if(liquidityTokens > 0 && ethForLiquidity > 0){
1053             addLiquidity(liquidityTokens, ethForLiquidity);
1054         }
1055         
1056         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1057     }
1058 
1059     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1060         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1061         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1062         lastManualLpBurnTime = block.timestamp;
1063         
1064         // get balance of liquidity pair
1065         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1066         
1067         // calculate amount to burn
1068         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1069         
1070         // pull tokens from pancakePair liquidity and move to dead address permanently
1071         if (amountToBurn > 0){
1072             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1073         }
1074         
1075         //sync price since this is not in a swap transaction!
1076         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1077         pair.sync();
1078         return true;
1079     }
1080 }