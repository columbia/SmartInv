1 /**
2 
3 Website: https://shubaduck.fun/
4 Twitter: https://twitter.com/ShubaDuckERC
5 Telegram: https://t.me/ShubaDuckERC
6 
7 */
8 
9 
10 // SPDX-License-Identifier: MIT                                                                               
11                                                     
12 pragma solidity = 0.8.19;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IUniswapV2Pair {
26     event Sync(uint112 reserve0, uint112 reserve1);
27     function sync() external;
28 }
29 
30 interface IUniswapV2Factory {
31     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
32 
33     function createPair(address tokenA, address tokenB) external returns (address pair);
34 }
35 
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 interface IERC20Metadata is IERC20 {
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() external view returns (string memory);
116 
117     /**
118      * @dev Returns the symbol of the token.
119      */
120     function symbol() external view returns (string memory);
121 
122     /**
123      * @dev Returns the decimals places of the token.
124      */
125     function decimals() external view returns (uint8);
126 }
127 
128 
129 contract ERC20 is Context, IERC20, IERC20Metadata {
130     using SafeMath for uint256;
131 
132     mapping(address => uint256) private _balances;
133 
134     mapping(address => mapping(address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string private _name;
139     string private _symbol;
140 
141     /**
142      * @dev Sets the values for {name} and {symbol}.
143      *
144      * The default value of {decimals} is 18. To select a different value for
145      * {decimals} you should overload it.
146      *
147      * All two of these values are immutable: they can only be set once during
148      * construction.
149      */
150     constructor(string memory name_, string memory symbol_) {
151         _name = name_;
152         _symbol = symbol_;
153     }
154 
155     /**
156      * @dev Returns the name of the token.
157      */
158     function name() public view virtual override returns (string memory) {
159         return _name;
160     }
161 
162     /**
163      * @dev Returns the symbol of the token, usually a shorter version of the
164      * name.
165      */
166     function symbol() public view virtual override returns (string memory) {
167         return _symbol;
168     }
169 
170     /**
171      * @dev Returns the number of decimals used to get its user representation.
172      * For example, if `decimals` equals `2`, a balance of `505` tokens should
173      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
174      *
175      * Tokens usually opt for a value of 18, imitating the relationship between
176      * Ether and Wei. This is the value {ERC20} uses, unless this function is
177      * overridden;
178      *
179      * NOTE: This information is only used for _display_ purposes: it in
180      * no way affects any of the arithmetic of the contract, including
181      * {IERC20-balanceOf} and {IERC20-transfer}.
182      */
183     function decimals() public view virtual override returns (uint8) {
184         return 18;
185     }
186 
187     /**
188      * @dev See {IERC20-totalSupply}.
189      */
190     function totalSupply() public view virtual override returns (uint256) {
191         return _totalSupply;
192     }
193 
194     /**
195      * @dev See {IERC20-balanceOf}.
196      */
197     function balanceOf(address account) public view virtual override returns (uint256) {
198         return _balances[account];
199     }
200 
201     /**
202      * @dev See {IERC20-transfer}.
203      *
204      * Requirements:
205      *
206      * - `recipient` cannot be the zero address.
207      * - the caller must have a balance of at least `amount`.
208      */
209     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     /**
215      * @dev See {IERC20-allowance}.
216      */
217     function allowance(address owner, address spender) public view virtual override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     /**
222      * @dev See {IERC20-approve}.
223      *
224      * Requirements:
225      *
226      * - `spender` cannot be the zero address.
227      */
228     function approve(address spender, uint256 amount) public virtual override returns (bool) {
229         _approve(_msgSender(), spender, amount);
230         return true;
231     }
232 
233     /**
234      * @dev See {IERC20-transferFrom}.
235      *
236      * Emits an {Approval} event indicating the updated allowance. This is not
237      * required by the EIP. See the note at the beginning of {ERC20}.
238      *
239      * Requirements:
240      *
241      * - `sender` and `recipient` cannot be the zero address.
242      * - `sender` must have a balance of at least `amount`.
243      * - the caller must have allowance for ``sender``'s tokens of at least
244      * `amount`.
245      */
246     function transferFrom(
247         address sender,
248         address recipient,
249         uint256 amount
250     ) public virtual override returns (bool) {
251         _transfer(sender, recipient, amount);
252         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
253         return true;
254     }
255 
256     /**
257      * @dev Atomically increases the allowance granted to `spender` by the caller.
258      *
259      * This is an alternative to {approve} that can be used as a mitigation for
260      * problems described in {IERC20-approve}.
261      *
262      * Emits an {Approval} event indicating the updated allowance.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
269         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
270         return true;
271     }
272 
273     /**
274      * @dev Atomically decreases the allowance granted to `spender` by the caller.
275      *
276      * This is an alternative to {approve} that can be used as a mitigation for
277      * problems described in {IERC20-approve}.
278      *
279      * Emits an {Approval} event indicating the updated allowance.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      * - `spender` must have allowance for the caller of at least
285      * `subtractedValue`.
286      */
287     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
288         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
289         return true;
290     }
291 
292     /**
293      * @dev Moves tokens `amount` from `sender` to `recipient`.
294      *
295      * This is internal function is equivalent to {transfer}, and can be used to
296      * e.g. implement automatic token fees, slashing mechanisms, etc.
297      *
298      * Emits a {Transfer} event.
299      *
300      * Requirements:
301      *
302      * - `sender` cannot be the zero address.
303      * - `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `amount`.
305      */
306     function _transfer(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) internal virtual {
311         require(sender != address(0), "ERC20: transfer from the zero address");
312         require(recipient != address(0), "ERC20: transfer to the zero address");
313 
314         _beforeTokenTransfer(sender, recipient, amount);
315 
316         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
317         _balances[recipient] = _balances[recipient].add(amount);
318         emit Transfer(sender, recipient, amount);
319     }
320 
321     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
322      * the total supply.
323      *
324      * Emits a {Transfer} event with `from` set to the zero address.
325      *
326      * Requirements:
327      *
328      * - `account` cannot be the zero address.
329      */
330     function _mint(address account, uint256 amount) internal virtual {
331         require(account != address(0), "ERC20: mint to the zero address");
332 
333         _beforeTokenTransfer(address(0), account, amount);
334 
335         _totalSupply = _totalSupply.add(amount);
336         _balances[account] = _balances[account].add(amount);
337         emit Transfer(address(0), account, amount);
338     }
339 
340     /**
341      * @dev Destroys `amount` tokens from `account`, reducing the
342      * total supply.
343      *
344      * Emits a {Transfer} event with `to` set to the zero address.
345      *
346      * Requirements:
347      *
348      * - `account` cannot be the zero address.
349      * - `account` must have at least `amount` tokens.
350      */
351     function _burn(address account, uint256 amount) internal virtual {
352         require(account != address(0), "ERC20: burn from the zero address");
353 
354         _beforeTokenTransfer(account, address(0), amount);
355 
356         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
357         _totalSupply = _totalSupply.sub(amount);
358         emit Transfer(account, address(0), amount);
359     }
360 
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
363      *
364      * This internal function is equivalent to `approve`, and can be used to
365      * e.g. set automatic allowances for certain subsystems, etc.
366      *
367      * Emits an {Approval} event.
368      *
369      * Requirements:
370      *
371      * - `owner` cannot be the zero address.
372      * - `spender` cannot be the zero address.
373      */
374     function _approve(
375         address owner,
376         address spender,
377         uint256 amount
378     ) internal virtual {
379         require(owner != address(0), "ERC20: approve from the zero address");
380         require(spender != address(0), "ERC20: approve to the zero address");
381 
382         _allowances[owner][spender] = amount;
383         emit Approval(owner, spender, amount);
384     }
385 
386     /**
387      * @dev Hook that is called before any transfer of tokens. This includes
388      * minting and burning.
389      *
390      * Calling conditions:
391      *
392      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
393      * will be to transferred to `to`.
394      * - when `from` is zero, `amount` tokens will be minted for `to`.
395      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
396      * - `from` and `to` are never both zero.
397      *
398      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
399      */
400     function _beforeTokenTransfer(
401         address from,
402         address to,
403         uint256 amount
404     ) internal virtual {}
405 }
406 
407 library SafeMath {
408     /**
409      * @dev Returns the addition of two unsigned integers, reverting on
410      * overflow.
411      *
412      * Counterpart to Solidity's `+` operator.
413      *
414      * Requirements:
415      *
416      * - Addition cannot overflow.
417      */
418     function add(uint256 a, uint256 b) internal pure returns (uint256) {
419         uint256 c = a + b;
420         require(c >= a, "SafeMath: addition overflow");
421 
422         return c;
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting on
427      * overflow (when the result is negative).
428      *
429      * Counterpart to Solidity's `-` operator.
430      *
431      * Requirements:
432      *
433      * - Subtraction cannot overflow.
434      */
435     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436         return sub(a, b, "SafeMath: subtraction overflow");
437     }
438 
439     /**
440      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
441      * overflow (when the result is negative).
442      *
443      * Counterpart to Solidity's `-` operator.
444      *
445      * Requirements:
446      *
447      * - Subtraction cannot overflow.
448      */
449     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
450         require(b <= a, errorMessage);
451         uint256 c = a - b;
452 
453         return c;
454     }
455 
456     /**
457      * @dev Returns the multiplication of two unsigned integers, reverting on
458      * overflow.
459      *
460      * Counterpart to Solidity's `*` operator.
461      *
462      * Requirements:
463      *
464      * - Multiplication cannot overflow.
465      */
466     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
467         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
468         // benefit is lost if 'b' is also tested.
469         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
470         if (a == 0) {
471             return 0;
472         }
473 
474         uint256 c = a * b;
475         require(c / a == b, "SafeMath: multiplication overflow");
476 
477         return c;
478     }
479 
480     /**
481      * @dev Returns the integer division of two unsigned integers. Reverts on
482      * division by zero. The result is rounded towards zero.
483      *
484      * Counterpart to Solidity's `/` operator. Note: this function uses a
485      * `revert` opcode (which leaves remaining gas untouched) while Solidity
486      * uses an invalid opcode to revert (consuming all remaining gas).
487      *
488      * Requirements:
489      *
490      * - The divisor cannot be zero.
491      */
492     function div(uint256 a, uint256 b) internal pure returns (uint256) {
493         return div(a, b, "SafeMath: division by zero");
494     }
495 
496     /**
497      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
498      * division by zero. The result is rounded towards zero.
499      *
500      * Counterpart to Solidity's `/` operator. Note: this function uses a
501      * `revert` opcode (which leaves remaining gas untouched) while Solidity
502      * uses an invalid opcode to revert (consuming all remaining gas).
503      *
504      * Requirements:
505      *
506      * - The divisor cannot be zero.
507      */
508     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b > 0, errorMessage);
510         uint256 c = a / b;
511         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
512 
513         return c;
514     }
515 
516     /**
517      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
518      * Reverts when dividing by zero.
519      *
520      * Counterpart to Solidity's `%` operator. This function uses a `revert`
521      * opcode (which leaves remaining gas untouched) while Solidity uses an
522      * invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
529         return mod(a, b, "SafeMath: modulo by zero");
530     }
531 
532     /**
533      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
534      * Reverts with custom message when dividing by zero.
535      *
536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
537      * opcode (which leaves remaining gas untouched) while Solidity uses an
538      * invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b != 0, errorMessage);
546         return a % b;
547     }
548 }
549 
550 contract Ownable is Context {
551     address private _owner;
552 
553     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
554     
555     /**
556      * @dev Initializes the contract setting the deployer as the initial owner.
557      */
558     constructor () {
559         address msgSender = _msgSender();
560         _owner = msgSender;
561         emit OwnershipTransferred(address(0), msgSender);
562     }
563 
564     /**
565      * @dev Returns the address of the current owner.
566      */
567     function owner() public view returns (address) {
568         return _owner;
569     }
570 
571     /**
572      * @dev Throws if called by any account other than the owner.
573      */
574     modifier onlyOwner() {
575         require(_owner == _msgSender(), "Ownable: caller is not the owner");
576         _;
577     }
578 
579     /**
580      * @dev Leaves the contract without owner. It will not be possible to call
581      * `onlyOwner` functions anymore. Can only be called by the current owner.
582      *
583      * NOTE: Renouncing ownership will leave the contract without an owner,
584      * thereby removing any functionality that is only available to the owner.
585      */
586     function renounceOwnership() public virtual onlyOwner {
587         emit OwnershipTransferred(_owner, address(0));
588         _owner = address(0);
589     }
590 
591     /**
592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
593      * Can only be called by the current owner.
594      */
595     function transferOwnership(address newOwner) public virtual onlyOwner {
596         require(newOwner != address(0), "Ownable: new owner is the zero address");
597         emit OwnershipTransferred(_owner, newOwner);
598         _owner = newOwner;
599     }
600 }
601 
602 
603 
604 library SafeMathInt {
605     int256 private constant MIN_INT256 = int256(1) << 255;
606     int256 private constant MAX_INT256 = ~(int256(1) << 255);
607 
608     /**
609      * @dev Multiplies two int256 variables and fails on overflow.
610      */
611     function mul(int256 a, int256 b) internal pure returns (int256) {
612         int256 c = a * b;
613 
614         // Detect overflow when multiplying MIN_INT256 with -1
615         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
616         require((b == 0) || (c / b == a));
617         return c;
618     }
619 
620     /**
621      * @dev Division of two int256 variables and fails on overflow.
622      */
623     function div(int256 a, int256 b) internal pure returns (int256) {
624         // Prevent overflow when dividing MIN_INT256 by -1
625         require(b != -1 || a != MIN_INT256);
626 
627         // Solidity already throws when dividing by 0.
628         return a / b;
629     }
630 
631     /**
632      * @dev Subtracts two int256 variables and fails on overflow.
633      */
634     function sub(int256 a, int256 b) internal pure returns (int256) {
635         int256 c = a - b;
636         require((b >= 0 && c <= a) || (b < 0 && c > a));
637         return c;
638     }
639 
640     /**
641      * @dev Adds two int256 variables and fails on overflow.
642      */
643     function add(int256 a, int256 b) internal pure returns (int256) {
644         int256 c = a + b;
645         require((b >= 0 && c >= a) || (b < 0 && c < a));
646         return c;
647     }
648 
649     /**
650      * @dev Converts to absolute value, and fails on overflow.
651      */
652     function abs(int256 a) internal pure returns (int256) {
653         require(a != MIN_INT256);
654         return a < 0 ? -a : a;
655     }
656 
657 
658     function toUint256Safe(int256 a) internal pure returns (uint256) {
659         require(a >= 0);
660         return uint256(a);
661     }
662 }
663 
664 library SafeMathUint {
665   function toInt256Safe(uint256 a) internal pure returns (int256) {
666     int256 b = int256(a);
667     require(b >= 0);
668     return b;
669   }
670 }
671 
672 
673 interface IUniswapV2Router01 {
674     function factory() external pure returns (address);
675     function WETH() external pure returns (address);
676 
677     function addLiquidityETH(
678         address token,
679         uint amountTokenDesired,
680         uint amountTokenMin,
681         uint amountETHMin,
682         address to,
683         uint deadline
684     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
685 }
686 
687 interface IUniswapV2Router02 is IUniswapV2Router01 {
688     function swapExactTokensForETHSupportingFeeOnTransferTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external;
695 }
696 
697 contract SHUBA is ERC20, Ownable {
698 
699     IUniswapV2Router02 public immutable uniswapV2Router;
700     address public immutable uniswapV2Pair;
701     address public constant deadAddress = address(0xdead);
702 
703     bool private swapping;
704 
705     address public marketingWallet;
706     address public devWallet;
707     
708     uint256 public maxTransactionAmount;
709     uint256 public swapTokensAtAmount;
710     uint256 public maxWallet;
711     
712     uint256 public percentForLPBurn = 25; // 25 = .25%
713     bool public lpBurnEnabled = false;
714     uint256 public lpBurnFrequency = 3600 seconds;
715     uint256 public lastLpBurnTime;
716     
717     uint256 public manualBurnFrequency = 30 minutes;
718     uint256 public lastManualLpBurnTime;
719 
720     bool public limitsInEffect = true;
721     bool public tradingActive = false;
722     bool public swapEnabled = false;
723     
724      // Anti-bot and anti-whale mappings and variables
725     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
726     mapping (address => bool) public isBlacklisted;
727     bool public transferDelayEnabled = true;
728 
729     uint256 public buyTotalFees;
730     uint256 public buyMarketingFee;
731     uint256 public buyLiquidityFee;
732     uint256 public buyDevFee;
733     
734     uint256 public sellTotalFees;
735     uint256 public sellMarketingFee;
736     uint256 public sellLiquidityFee;
737     uint256 public sellDevFee;
738     
739     uint256 public tokensForMarketing;
740     uint256 public tokensForLiquidity;
741     uint256 public tokensForDev;
742 
743     // exlcude from fees and max transaction amount
744     mapping (address => bool) private _isExcludedFromFees;
745     mapping (address => bool) public _isExcludedMaxTransactionAmount;
746 
747     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
748     // could be subject to a maximum transfer amount
749     mapping (address => bool) public automatedMarketMakerPairs;
750 
751     constructor() ERC20(unicode"Shuba Duck", unicode"SHUBA") {
752         
753         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
754         
755         excludeFromMaxTransaction(address(_uniswapV2Router), true);
756         uniswapV2Router = _uniswapV2Router;
757         
758         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
759         excludeFromMaxTransaction(address(uniswapV2Pair), true);
760         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
761         
762         uint256 _buyMarketingFee = 25;
763         uint256 _buyLiquidityFee = 0;
764         uint256 _buyDevFee = 0;
765 
766         uint256 _sellMarketingFee = 35;
767         uint256 _sellLiquidityFee = 0;
768         uint256 _sellDevFee = 0;
769         
770         uint256 totalSupply = 1000000000000 * 1e18; 
771         
772         maxTransactionAmount = totalSupply * 2 / 100; // 
773         maxWallet = totalSupply * 2 / 100; //
774         swapTokensAtAmount = totalSupply * 5 / 1000; // 
775 
776         buyMarketingFee = _buyMarketingFee;
777         buyLiquidityFee = _buyLiquidityFee;
778         buyDevFee = _buyDevFee;
779         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
780         
781         sellMarketingFee = _sellMarketingFee;
782         sellLiquidityFee = _sellLiquidityFee;
783         sellDevFee = _sellDevFee;
784         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
785         
786         marketingWallet = address(owner()); 
787         devWallet = address(owner()); // 
788 
789         // exclude from paying fees or having max transaction amount
790         excludeFromFees(owner(), true);
791         excludeFromFees(address(this), true);
792         excludeFromFees(address(0xdead), true);
793         
794         excludeFromMaxTransaction(owner(), true);
795         excludeFromMaxTransaction(address(this), true);
796         excludeFromMaxTransaction(address(0xdead), true);
797         
798         _mint(msg.sender, totalSupply);
799     }
800 
801     receive() external payable {
802 
803   	}
804 
805     // once enabled, can never be turned off
806     function openTrading() external onlyOwner {
807         tradingActive = true;
808         swapEnabled = true;
809         lastLpBurnTime = block.timestamp;
810     }
811     
812     // remove limits after token is stable
813     function updateandmanagelimits() external onlyOwner returns (bool){
814         limitsInEffect = false;
815         transferDelayEnabled = false;
816         return true;
817     }
818     
819     // change the minimum amount of tokens to sell from fees
820     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
821   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
822   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
823   	    return true;
824   	}
825     
826     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
827         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
828         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
829         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
830         maxWallet = (totalSupply() * walNum / 100)/1e18;
831     }
832 
833     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
834         _isExcludedMaxTransactionAmount[updAds] = isEx;
835     }
836     
837     // only use to disable contract sales if absolutely necessary (emergency use only)
838     function updateSwapEnabled(bool enabled) external onlyOwner(){
839         swapEnabled = enabled;
840     }
841     
842     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
843         buyMarketingFee = _marketingFee;
844         buyLiquidityFee = _liquidityFee;
845         buyDevFee = _devFee;
846         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
847         require(buyTotalFees <= 40, "Must keep fees at 99% or less");
848     }
849     
850     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
851         sellMarketingFee = _marketingFee;
852         sellLiquidityFee = _liquidityFee;
853         sellDevFee = _devFee;
854         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
855         require(sellTotalFees <= 50, "Must keep fees at 99% or less");
856     }
857 
858     function excludeFromFees(address account, bool excluded) public onlyOwner {
859         _isExcludedFromFees[account] = excluded;
860     }
861 
862     function _setAutomatedMarketMakerPair(address pair, bool value) private {
863         automatedMarketMakerPairs[pair] = value;
864     }
865 
866     function updateandmanagemarketingWallet(address newMarketingWallet) external onlyOwner {
867         marketingWallet = newMarketingWallet;
868     }
869     
870     function updateandmanagedevWallet(address newWallet) external onlyOwner {
871         devWallet = newWallet;
872     }
873 
874     function isExcludedFromFees(address account) public view returns(bool) {
875         return _isExcludedFromFees[account];
876     }
877 
878     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
879         for(uint256 i = 0; i < wallets.length; i++){
880         isBlacklisted[wallets[i]] = flag;
881         }
882     }
883 
884     function withdrawETH() external onlyOwner returns(bool){
885         (bool success, ) = owner().call{value: address(this).balance}("");
886         return success;
887     }
888 
889     function _transfer(
890         address from,
891         address to,
892         uint256 amount
893     ) internal override {
894         require(from != address(0), "ERC20: transfer from the zero address");
895         require(to != address(0), "ERC20: transfer to the zero address");
896         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
897     
898         
899          if(amount == 0) {
900             super._transfer(from, to, 0);
901             return;
902         }
903         
904         if(limitsInEffect){
905             if (
906                 from != owner() &&
907                 to != owner() &&
908                 to != address(0) &&
909                 to != address(0xdead) &&
910                 !swapping
911             ){
912                 if(!tradingActive){
913                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
914                 }
915 
916                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
917                 if (transferDelayEnabled){
918                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
919                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
920                         _holderLastTransferTimestamp[tx.origin] = block.number;
921                     }
922                 }
923                  
924                 //when buy
925                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
926                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
927                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
928                 }
929                 
930                 //when sell
931                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
932                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
933                 }
934                 else if(!_isExcludedMaxTransactionAmount[to]){
935                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
936                 }
937             }
938         }
939         
940 		uint256 contractTokenBalance = balanceOf(address(this));
941         
942         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
943 
944         if( 
945             canSwap &&
946             swapEnabled &&
947             !swapping &&
948             !automatedMarketMakerPairs[from] &&
949             !_isExcludedFromFees[from] &&
950             !_isExcludedFromFees[to]
951         ) {
952             swapping = true;
953             
954             swapBack();
955 
956             swapping = false;
957         }
958 
959         bool takeFee = !swapping;
960 
961         // if any account belongs to _isExcludedFromFee account then remove the fee
962         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
963             takeFee = false;
964         }
965         
966         uint256 fees = 0;
967         // only take fees on buys/sells, do not take on wallet transfers
968         if(takeFee){
969             // on sell
970             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
971                 fees = amount * sellTotalFees/100;
972                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
973                 tokensForDev += fees * sellDevFee / sellTotalFees;
974                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
975             }
976             // on buy
977             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
978         	    fees = amount * buyTotalFees/100;
979         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
980                 tokensForDev += fees * buyDevFee / buyTotalFees;
981                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
982             }
983             
984             if(fees > 0){    
985                 super._transfer(from, address(this), fees);
986             }
987         	
988         	amount -= fees;
989         }
990 
991         super._transfer(from, to, amount);
992     }
993 
994     function swapTokensForEth(uint256 tokenAmount) private {
995 
996         // generate the uniswap pair path of token -> weth
997         address[] memory path = new address[](2);
998         path[0] = address(this);
999         path[1] = uniswapV2Router.WETH();
1000 
1001         _approve(address(this), address(uniswapV2Router), tokenAmount);
1002 
1003         // make the swap
1004         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1005             tokenAmount,
1006             0, // accept any amount of ETH
1007             path,
1008             address(this),
1009             block.timestamp
1010         );
1011         
1012     }
1013     
1014     
1015     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1016         // approve token transfer to cover all possible scenarios
1017         _approve(address(this), address(uniswapV2Router), tokenAmount);
1018 
1019         // add the liquidity
1020         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1021             address(this),
1022             tokenAmount,
1023             0, // slippage is unavoidable
1024             0, // slippage is unavoidable
1025             deadAddress,
1026             block.timestamp
1027         );
1028     }
1029 
1030     function swapBack() public {
1031         uint256 contractBalance = balanceOf(address(this));
1032         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1033         bool success;
1034         
1035         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1036 
1037         if(contractBalance > swapTokensAtAmount * 20){
1038           contractBalance = swapTokensAtAmount * 20;
1039         }
1040         
1041         // Halve the amount of liquidity tokens
1042         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1043         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1044         
1045         uint256 initialETHBalance = address(this).balance;
1046 
1047         swapTokensForEth(amountToSwapForETH); 
1048         
1049         uint256 ethBalance = address(this).balance - initialETHBalance;
1050         
1051         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1052         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1053         
1054         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1055         
1056         tokensForLiquidity = 0;
1057         tokensForMarketing = 0;
1058         tokensForDev = 0;
1059         
1060         (success,) = address(devWallet).call{value: ethForDev}("");
1061         
1062         if(liquidityTokens > 0 && ethForLiquidity > 0){
1063             addLiquidity(liquidityTokens, ethForLiquidity);
1064         }
1065         
1066         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1067     }
1068 
1069     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1070         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1071         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1072         lastManualLpBurnTime = block.timestamp;
1073         
1074         // get balance of liquidity pair
1075         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1076         
1077         // calculate amount to burn
1078         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1079         
1080         
1081         if (amountToBurn > 0){
1082             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1083         }
1084         
1085         //sync price since this is not in a swap transaction!
1086         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1087         pair.sync();
1088         return true;
1089     }
1090 }