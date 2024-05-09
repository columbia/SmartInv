1 /**
2 
3 Website : http://NeverBrokeAgain.life/
4 Telegram: https://t.me/NBAPortal
5 Twitter : https://twitter.com/NBAERC
6 =================================================
7 
8 */
9 
10 
11 // SPDX-License-Identifier: MIT                                                                               
12                                                     
13 pragma solidity = 0.8.19;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Pair {
27     event Sync(uint112 reserve0, uint112 reserve1);
28     function sync() external;
29 }
30 
31 interface IUniswapV2Factory {
32     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
33 
34     function createPair(address tokenA, address tokenB) external returns (address pair);
35 }
36 
37 interface IERC20 {
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
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the symbol of the token.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the decimals places of the token.
125      */
126     function decimals() external view returns (uint8);
127 }
128 
129 
130 contract ERC20 is Context, IERC20, IERC20Metadata {
131     using SafeMath for uint256;
132 
133     mapping(address => uint256) private _balances;
134 
135     mapping(address => mapping(address => uint256)) private _allowances;
136 
137     uint256 private _totalSupply;
138 
139     string private _name;
140     string private _symbol;
141 
142     /**
143      * @dev Sets the values for {name} and {symbol}.
144      *
145      * The default value of {decimals} is 18. To select a different value for
146      * {decimals} you should overload it.
147      *
148      * All two of these values are immutable: they can only be set once during
149      * construction.
150      */
151     constructor(string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     /**
157      * @dev Returns the name of the token.
158      */
159     function name() public view virtual override returns (string memory) {
160         return _name;
161     }
162 
163     /**
164      * @dev Returns the symbol of the token, usually a shorter version of the
165      * name.
166      */
167     function symbol() public view virtual override returns (string memory) {
168         return _symbol;
169     }
170 
171     /**
172      * @dev Returns the number of decimals used to get its user representation.
173      * For example, if `decimals` equals `2`, a balance of `505` tokens should
174      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
175      *
176      * Tokens usually opt for a value of 18, imitating the relationship between
177      * Ether and Wei. This is the value {ERC20} uses, unless this function is
178      * overridden;
179      *
180      * NOTE: This information is only used for _display_ purposes: it in
181      * no way affects any of the arithmetic of the contract, including
182      * {IERC20-balanceOf} and {IERC20-transfer}.
183      */
184     function decimals() public view virtual override returns (uint8) {
185         return 18;
186     }
187 
188     /**
189      * @dev See {IERC20-totalSupply}.
190      */
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(address account) public view virtual override returns (uint256) {
199         return _balances[account];
200     }
201 
202     /**
203      * @dev See {IERC20-transfer}.
204      *
205      * Requirements:
206      *
207      * - `recipient` cannot be the zero address.
208      * - the caller must have a balance of at least `amount`.
209      */
210     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-allowance}.
217      */
218     function allowance(address owner, address spender) public view virtual override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     /**
223      * @dev See {IERC20-approve}.
224      *
225      * Requirements:
226      *
227      * - `spender` cannot be the zero address.
228      */
229     function approve(address spender, uint256 amount) public virtual override returns (bool) {
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     /**
235      * @dev See {IERC20-transferFrom}.
236      *
237      * Emits an {Approval} event indicating the updated allowance. This is not
238      * required by the EIP. See the note at the beginning of {ERC20}.
239      *
240      * Requirements:
241      *
242      * - `sender` and `recipient` cannot be the zero address.
243      * - `sender` must have a balance of at least `amount`.
244      * - the caller must have allowance for ``sender``'s tokens of at least
245      * `amount`.
246      */
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) public virtual override returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
254         return true;
255     }
256 
257     /**
258      * @dev Atomically increases the allowance granted to `spender` by the caller.
259      *
260      * This is an alternative to {approve} that can be used as a mitigation for
261      * problems described in {IERC20-approve}.
262      *
263      * Emits an {Approval} event indicating the updated allowance.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
270         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
271         return true;
272     }
273 
274     /**
275      * @dev Atomically decreases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      * - `spender` must have allowance for the caller of at least
286      * `subtractedValue`.
287      */
288     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
289         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
290         return true;
291     }
292 
293     /**
294      * @dev Moves tokens `amount` from `sender` to `recipient`.
295      *
296      * This is internal function is equivalent to {transfer}, and can be used to
297      * e.g. implement automatic token fees, slashing mechanisms, etc.
298      *
299      * Emits a {Transfer} event.
300      *
301      * Requirements:
302      *
303      * - `sender` cannot be the zero address.
304      * - `recipient` cannot be the zero address.
305      * - `sender` must have a balance of at least `amount`.
306      */
307     function _transfer(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) internal virtual {
312         require(sender != address(0), "ERC20: transfer from the zero address");
313         require(recipient != address(0), "ERC20: transfer to the zero address");
314 
315         _beforeTokenTransfer(sender, recipient, amount);
316 
317         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
318         _balances[recipient] = _balances[recipient].add(amount);
319         emit Transfer(sender, recipient, amount);
320     }
321 
322     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
323      * the total supply.
324      *
325      * Emits a {Transfer} event with `from` set to the zero address.
326      *
327      * Requirements:
328      *
329      * - `account` cannot be the zero address.
330      */
331     function _mint(address account, uint256 amount) internal virtual {
332         require(account != address(0), "ERC20: mint to the zero address");
333 
334         _beforeTokenTransfer(address(0), account, amount);
335 
336         _totalSupply = _totalSupply.add(amount);
337         _balances[account] = _balances[account].add(amount);
338         emit Transfer(address(0), account, amount);
339     }
340 
341     /**
342      * @dev Destroys `amount` tokens from `account`, reducing the
343      * total supply.
344      *
345      * Emits a {Transfer} event with `to` set to the zero address.
346      *
347      * Requirements:
348      *
349      * - `account` cannot be the zero address.
350      * - `account` must have at least `amount` tokens.
351      */
352     function _burn(address account, uint256 amount) internal virtual {
353         require(account != address(0), "ERC20: burn from the zero address");
354 
355         _beforeTokenTransfer(account, address(0), amount);
356 
357         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
358         _totalSupply = _totalSupply.sub(amount);
359         emit Transfer(account, address(0), amount);
360     }
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
364      *
365      * This internal function is equivalent to `approve`, and can be used to
366      * e.g. set automatic allowances for certain subsystems, etc.
367      *
368      * Emits an {Approval} event.
369      *
370      * Requirements:
371      *
372      * - `owner` cannot be the zero address.
373      * - `spender` cannot be the zero address.
374      */
375     function _approve(
376         address owner,
377         address spender,
378         uint256 amount
379     ) internal virtual {
380         require(owner != address(0), "ERC20: approve from the zero address");
381         require(spender != address(0), "ERC20: approve to the zero address");
382 
383         _allowances[owner][spender] = amount;
384         emit Approval(owner, spender, amount);
385     }
386 
387     /**
388      * @dev Hook that is called before any transfer of tokens. This includes
389      * minting and burning.
390      *
391      * Calling conditions:
392      *
393      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
394      * will be to transferred to `to`.
395      * - when `from` is zero, `amount` tokens will be minted for `to`.
396      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
397      * - `from` and `to` are never both zero.
398      *
399      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
400      */
401     function _beforeTokenTransfer(
402         address from,
403         address to,
404         uint256 amount
405     ) internal virtual {}
406 }
407 
408 library SafeMath {
409     /**
410      * @dev Returns the addition of two unsigned integers, reverting on
411      * overflow.
412      *
413      * Counterpart to Solidity's `+` operator.
414      *
415      * Requirements:
416      *
417      * - Addition cannot overflow.
418      */
419     function add(uint256 a, uint256 b) internal pure returns (uint256) {
420         uint256 c = a + b;
421         require(c >= a, "SafeMath: addition overflow");
422 
423         return c;
424     }
425 
426     /**
427      * @dev Returns the subtraction of two unsigned integers, reverting on
428      * overflow (when the result is negative).
429      *
430      * Counterpart to Solidity's `-` operator.
431      *
432      * Requirements:
433      *
434      * - Subtraction cannot overflow.
435      */
436     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
437         return sub(a, b, "SafeMath: subtraction overflow");
438     }
439 
440     /**
441      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
442      * overflow (when the result is negative).
443      *
444      * Counterpart to Solidity's `-` operator.
445      *
446      * Requirements:
447      *
448      * - Subtraction cannot overflow.
449      */
450     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b <= a, errorMessage);
452         uint256 c = a - b;
453 
454         return c;
455     }
456 
457     /**
458      * @dev Returns the multiplication of two unsigned integers, reverting on
459      * overflow.
460      *
461      * Counterpart to Solidity's `*` operator.
462      *
463      * Requirements:
464      *
465      * - Multiplication cannot overflow.
466      */
467     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
468         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
469         // benefit is lost if 'b' is also tested.
470         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
471         if (a == 0) {
472             return 0;
473         }
474 
475         uint256 c = a * b;
476         require(c / a == b, "SafeMath: multiplication overflow");
477 
478         return c;
479     }
480 
481     /**
482      * @dev Returns the integer division of two unsigned integers. Reverts on
483      * division by zero. The result is rounded towards zero.
484      *
485      * Counterpart to Solidity's `/` operator. Note: this function uses a
486      * `revert` opcode (which leaves remaining gas untouched) while Solidity
487      * uses an invalid opcode to revert (consuming all remaining gas).
488      *
489      * Requirements:
490      *
491      * - The divisor cannot be zero.
492      */
493     function div(uint256 a, uint256 b) internal pure returns (uint256) {
494         return div(a, b, "SafeMath: division by zero");
495     }
496 
497     /**
498      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
499      * division by zero. The result is rounded towards zero.
500      *
501      * Counterpart to Solidity's `/` operator. Note: this function uses a
502      * `revert` opcode (which leaves remaining gas untouched) while Solidity
503      * uses an invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b > 0, errorMessage);
511         uint256 c = a / b;
512         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
513 
514         return c;
515     }
516 
517     /**
518      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
519      * Reverts when dividing by zero.
520      *
521      * Counterpart to Solidity's `%` operator. This function uses a `revert`
522      * opcode (which leaves remaining gas untouched) while Solidity uses an
523      * invalid opcode to revert (consuming all remaining gas).
524      *
525      * Requirements:
526      *
527      * - The divisor cannot be zero.
528      */
529     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
530         return mod(a, b, "SafeMath: modulo by zero");
531     }
532 
533     /**
534      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
535      * Reverts with custom message when dividing by zero.
536      *
537      * Counterpart to Solidity's `%` operator. This function uses a `revert`
538      * opcode (which leaves remaining gas untouched) while Solidity uses an
539      * invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
546         require(b != 0, errorMessage);
547         return a % b;
548     }
549 }
550 
551 contract Ownable is Context {
552     address private _owner;
553 
554     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
555     
556     /**
557      * @dev Initializes the contract setting the deployer as the initial owner.
558      */
559     constructor () {
560         address msgSender = _msgSender();
561         _owner = msgSender;
562         emit OwnershipTransferred(address(0), msgSender);
563     }
564 
565     /**
566      * @dev Returns the address of the current owner.
567      */
568     function owner() public view returns (address) {
569         return _owner;
570     }
571 
572     /**
573      * @dev Throws if called by any account other than the owner.
574      */
575     modifier onlyOwner() {
576         require(_owner == _msgSender(), "Ownable: caller is not the owner");
577         _;
578     }
579 
580     /**
581      * @dev Leaves the contract without owner. It will not be possible to call
582      * `onlyOwner` functions anymore. Can only be called by the current owner.
583      *
584      * NOTE: Renouncing ownership will leave the contract without an owner,
585      * thereby removing any functionality that is only available to the owner.
586      */
587     function renounceOwnership() public virtual onlyOwner {
588         emit OwnershipTransferred(_owner, address(0));
589         _owner = address(0);
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public virtual onlyOwner {
597         require(newOwner != address(0), "Ownable: new owner is the zero address");
598         emit OwnershipTransferred(_owner, newOwner);
599         _owner = newOwner;
600     }
601 }
602 
603 
604 
605 library SafeMathInt {
606     int256 private constant MIN_INT256 = int256(1) << 255;
607     int256 private constant MAX_INT256 = ~(int256(1) << 255);
608 
609     /**
610      * @dev Multiplies two int256 variables and fails on overflow.
611      */
612     function mul(int256 a, int256 b) internal pure returns (int256) {
613         int256 c = a * b;
614 
615         // Detect overflow when multiplying MIN_INT256 with -1
616         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
617         require((b == 0) || (c / b == a));
618         return c;
619     }
620 
621     /**
622      * @dev Division of two int256 variables and fails on overflow.
623      */
624     function div(int256 a, int256 b) internal pure returns (int256) {
625         // Prevent overflow when dividing MIN_INT256 by -1
626         require(b != -1 || a != MIN_INT256);
627 
628         // Solidity already throws when dividing by 0.
629         return a / b;
630     }
631 
632     /**
633      * @dev Subtracts two int256 variables and fails on overflow.
634      */
635     function sub(int256 a, int256 b) internal pure returns (int256) {
636         int256 c = a - b;
637         require((b >= 0 && c <= a) || (b < 0 && c > a));
638         return c;
639     }
640 
641     /**
642      * @dev Adds two int256 variables and fails on overflow.
643      */
644     function add(int256 a, int256 b) internal pure returns (int256) {
645         int256 c = a + b;
646         require((b >= 0 && c >= a) || (b < 0 && c < a));
647         return c;
648     }
649 
650     /**
651      * @dev Converts to absolute value, and fails on overflow.
652      */
653     function abs(int256 a) internal pure returns (int256) {
654         require(a != MIN_INT256);
655         return a < 0 ? -a : a;
656     }
657 
658 
659     function toUint256Safe(int256 a) internal pure returns (uint256) {
660         require(a >= 0);
661         return uint256(a);
662     }
663 }
664 
665 library SafeMathUint {
666   function toInt256Safe(uint256 a) internal pure returns (int256) {
667     int256 b = int256(a);
668     require(b >= 0);
669     return b;
670   }
671 }
672 
673 
674 interface IUniswapV2Router01 {
675     function factory() external pure returns (address);
676     function WETH() external pure returns (address);
677 
678     function addLiquidityETH(
679         address token,
680         uint amountTokenDesired,
681         uint amountTokenMin,
682         uint amountETHMin,
683         address to,
684         uint deadline
685     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
686 }
687 
688 interface IUniswapV2Router02 is IUniswapV2Router01 {
689     function swapExactTokensForETHSupportingFeeOnTransferTokens(
690         uint amountIn,
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external;
696 }
697 
698 contract NBA is ERC20, Ownable {
699 
700     IUniswapV2Router02 public immutable uniswapV2Router;
701     address public immutable uniswapV2Pair;
702     address public constant deadAddress = address(0xdead);
703 
704     bool private swapping;
705 
706     address public marketingWallet;
707     address public devWallet;
708     
709     uint256 public maxTransactionAmount;
710     uint256 public swapTokensAtAmount;
711     uint256 public maxWallet;
712     
713     uint256 public percentForLPBurn = 25; // 25 = .25%
714     bool public lpBurnEnabled = false;
715     uint256 public lpBurnFrequency = 3600 seconds;
716     uint256 public lastLpBurnTime;
717     
718     uint256 public manualBurnFrequency = 30 minutes;
719     uint256 public lastManualLpBurnTime;
720 
721     bool public limitsInEffect = true;
722     bool public tradingActive = false;
723     bool public swapEnabled = false;
724     
725      // Anti-bot and anti-whale mappings and variables
726     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
727     mapping (address => bool) public isBlacklisted;
728     bool public transferDelayEnabled = true;
729 
730     uint256 public buyTotalFees;
731     uint256 public buyMarketingFee;
732     uint256 public buyLiquidityFee;
733     uint256 public buyDevFee;
734     
735     uint256 public sellTotalFees;
736     uint256 public sellMarketingFee;
737     uint256 public sellLiquidityFee;
738     uint256 public sellDevFee;
739     
740     uint256 public tokensForMarketing;
741     uint256 public tokensForLiquidity;
742     uint256 public tokensForDev;
743     
744     mapping(address => bool) private whitelist;
745 
746     // exlcude from fees and max transaction amount
747     mapping (address => bool) private _isExcludedFromFees;
748     mapping (address => bool) public _isExcludedMaxTransactionAmount;
749 
750     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
751     // could be subject to a maximum transfer amount
752     mapping (address => bool) public automatedMarketMakerPairs;
753 
754     constructor() ERC20("Never Broke Again", "NBA") {
755         
756         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
757         
758         excludeFromMaxTransaction(address(_uniswapV2Router), true);
759         uniswapV2Router = _uniswapV2Router;
760         
761         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
762         excludeFromMaxTransaction(address(uniswapV2Pair), true);
763         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
764         
765         uint256 _buyMarketingFee = 0;
766         uint256 _buyLiquidityFee = 0;
767         uint256 _buyDevFee = 25;
768 
769         uint256 _sellMarketingFee = 0;
770         uint256 _sellLiquidityFee = 0;
771         uint256 _sellDevFee = 35;
772         
773         uint256 totalSupply = 1000000000000 * 1e18; 
774         
775         maxTransactionAmount = totalSupply * 2 / 100; // 1% maxTransactionAmountTxn
776         maxWallet = totalSupply * 2 / 100; // 1% maxWallet
777         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
778 
779         buyMarketingFee = _buyMarketingFee;
780         buyLiquidityFee = _buyLiquidityFee;
781         buyDevFee = _buyDevFee;
782         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
783         
784         sellMarketingFee = _sellMarketingFee;
785         sellLiquidityFee = _sellLiquidityFee;
786         sellDevFee = _sellDevFee;
787         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
788         
789         marketingWallet = address(owner()); // set as marketing wallet
790         devWallet = address(owner()); // set as dev wallet
791 
792         // exclude from paying fees or having max transaction amount
793         excludeFromFees(owner(), true);
794         excludeFromFees(address(this), true);
795         excludeFromFees(address(0xdead), true);
796         
797         excludeFromMaxTransaction(owner(), true);
798         excludeFromMaxTransaction(address(this), true);
799         excludeFromMaxTransaction(address(0xdead), true);
800         
801         _mint(msg.sender, totalSupply);
802     }
803 
804     receive() external payable {
805 
806   	}
807     
808     function setWhitelist(address[] memory whitelist_) public onlyOwner {
809         for (uint256 i = 0; i < whitelist_.length; i++) {
810             whitelist[whitelist_[i]] = true;
811         }
812     }
813 
814     function isWhiteListed(address account) public view returns (bool) {
815         return whitelist[account];
816     }  
817 
818     // once enabled, can never be turned off
819     function openTrading() external onlyOwner {
820         tradingActive = true;
821         swapEnabled = true;
822         lastLpBurnTime = block.timestamp;
823     }
824     
825     // remove limits after token is stable
826     function removealllimits() external onlyOwner returns (bool){
827         limitsInEffect = false;
828         transferDelayEnabled = false;
829         return true;
830     }
831     
832     // change the minimum amount of tokens to sell from fees
833     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
834   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
835   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
836   	    return true;
837   	}
838     
839     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
840         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
841         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
842         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
843         maxWallet = (totalSupply() * walNum / 100)/1e18;
844     }
845 
846     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
847         _isExcludedMaxTransactionAmount[updAds] = isEx;
848     }
849     
850     // only use to disable contract sales if absolutely necessary (emergency use only)
851     function updateSwapEnabled(bool enabled) external onlyOwner(){
852         swapEnabled = enabled;
853     }
854     
855     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
856         buyMarketingFee = _marketingFee;
857         buyLiquidityFee = _liquidityFee;
858         buyDevFee = _devFee;
859         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
860         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
861     }
862     
863     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
864         sellMarketingFee = _marketingFee;
865         sellLiquidityFee = _liquidityFee;
866         sellDevFee = _devFee;
867         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
868         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
869     }
870 
871     function excludeFromFees(address account, bool excluded) public onlyOwner {
872         _isExcludedFromFees[account] = excluded;
873     }
874 
875     function _setAutomatedMarketMakerPair(address pair, bool value) private {
876         automatedMarketMakerPairs[pair] = value;
877     }
878 
879     function updateMarketingWalletaddress(address newMarketingWallet) external onlyOwner {
880         marketingWallet = newMarketingWallet;
881     }
882     
883     function updateDevWalletaddress(address newWallet) external onlyOwner {
884         devWallet = newWallet;
885     }
886 
887     function isExcludedFromFees(address account) public view returns(bool) {
888         return _isExcludedFromFees[account];
889     }
890 
891     function manageall_bots(address _address, bool status) external onlyOwner {
892         require(_address != address(0),"Address should not be 0");
893         isBlacklisted[_address] = status;
894     }
895 
896     function _transfer(
897         address from,
898         address to,
899         uint256 amount
900     ) internal override {
901         require(from != address(0), "ERC20: transfer from the zero address");
902         require(to != address(0), "ERC20: transfer to the zero address");
903         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
904          if(amount == 0) {
905             super._transfer(from, to, 0);
906             return;
907         }
908         
909         if(limitsInEffect){
910             if (
911                 from != owner() &&
912                 to != owner() &&
913                 to != address(0) &&
914                 to != address(0xdead) &&
915                 !swapping
916             ){
917                 if(!tradingActive){
918                     require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
919                 }
920 
921                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
922                 if (transferDelayEnabled){
923                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
924                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
925                         _holderLastTransferTimestamp[tx.origin] = block.number;
926                     }
927                 }
928                  
929                 //when buy
930                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
931                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
932                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
933                 }
934                 
935                 //when sell
936                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
937                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
938                 }
939                 else if(!_isExcludedMaxTransactionAmount[to]){
940                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
941                 }
942             }
943         }
944         
945 		uint256 contractTokenBalance = balanceOf(address(this));
946         
947         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
948 
949         if( 
950             canSwap &&
951             swapEnabled &&
952             !swapping &&
953             !automatedMarketMakerPairs[from] &&
954             !_isExcludedFromFees[from] &&
955             !_isExcludedFromFees[to]
956         ) {
957             swapping = true;
958             
959             swapBack();
960 
961             swapping = false;
962         }
963 
964         bool takeFee = !swapping;
965 
966         // if any account belongs to _isExcludedFromFee account then remove the fee
967         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
968             takeFee = false;
969         }
970         
971         uint256 fees = 0;
972         // only take fees on buys/sells, do not take on wallet transfers
973         if(takeFee){
974             // on sell
975             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
976                 fees = amount * sellTotalFees/100;
977                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
978                 tokensForDev += fees * sellDevFee / sellTotalFees;
979                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
980             }
981             // on buy
982             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
983         	    fees = amount * buyTotalFees/100;
984         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
985                 tokensForDev += fees * buyDevFee / buyTotalFees;
986                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
987             }
988             
989             if(fees > 0){    
990                 super._transfer(from, address(this), fees);
991             }
992         	
993         	amount -= fees;
994         }
995 
996         super._transfer(from, to, amount);
997     }
998 
999     function swapTokensForEth(uint256 tokenAmount) private {
1000 
1001         // generate the uniswap pair path of token -> weth
1002         address[] memory path = new address[](2);
1003         path[0] = address(this);
1004         path[1] = uniswapV2Router.WETH();
1005 
1006         _approve(address(this), address(uniswapV2Router), tokenAmount);
1007 
1008         // make the swap
1009         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1010             tokenAmount,
1011             0, // accept any amount of ETH
1012             path,
1013             address(this),
1014             block.timestamp
1015         );
1016         
1017     }
1018     
1019     
1020     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1021         // approve token transfer to cover all possible scenarios
1022         _approve(address(this), address(uniswapV2Router), tokenAmount);
1023 
1024         // add the liquidity
1025         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1026             address(this),
1027             tokenAmount,
1028             0, // slippage is unavoidable
1029             0, // slippage is unavoidable
1030             deadAddress,
1031             block.timestamp
1032         );
1033     }
1034 
1035     function swapBack() private {
1036         uint256 contractBalance = balanceOf(address(this));
1037         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1038         bool success;
1039         
1040         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1041 
1042         if(contractBalance > swapTokensAtAmount * 20){
1043           contractBalance = swapTokensAtAmount * 20;
1044         }
1045         
1046         // Halve the amount of liquidity tokens
1047         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1048         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1049         
1050         uint256 initialETHBalance = address(this).balance;
1051 
1052         swapTokensForEth(amountToSwapForETH); 
1053         
1054         uint256 ethBalance = address(this).balance - initialETHBalance;
1055         
1056         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1057         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1058         
1059         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1060         
1061         tokensForLiquidity = 0;
1062         tokensForMarketing = 0;
1063         tokensForDev = 0;
1064         
1065         (success,) = address(devWallet).call{value: ethForDev}("");
1066         
1067         if(liquidityTokens > 0 && ethForLiquidity > 0){
1068             addLiquidity(liquidityTokens, ethForLiquidity);
1069         }
1070         
1071         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1072     }
1073 
1074     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1075         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1076         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1077         lastManualLpBurnTime = block.timestamp;
1078         
1079         // get balance of liquidity pair
1080         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1081         
1082         // calculate amount to burn
1083         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1084         
1085         // pull tokens from pancakePair liquidity and move to dead address permanently
1086         if (amountToBurn > 0){
1087             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1088         }
1089         
1090         //sync price since this is not in a swap transaction!
1091         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1092         pair.sync();
1093         return true;
1094     }
1095 }