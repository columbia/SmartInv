1 /**
2 
3 Web:https://www.ShifuCoin.io/
4 Telegram: https://T.Me/ShifuCoin
5 Twitter: https://Twitter.com/ShifuCoin
6 -------------------------------------------------
7 Max Wallet: 1.5% Total Supply
8 Final Tax: 0/0 Buy/Sell Tax
9 Liquidity Lock: 10 Year Lock On UniCrypt
10 -------------------------------------------------
11 */
12 // SPDX-License-Identifier: MIT                                                                               
13                                                     
14 pragma solidity = 0.8.19;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IUniswapV2Pair {
28     event Sync(uint112 reserve0, uint112 reserve1);
29     function sync() external;
30 }
31 
32 interface IUniswapV2Factory {
33     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
34 
35     function createPair(address tokenA, address tokenB) external returns (address pair);
36 }
37 
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     using SafeMath for uint256;
133 
134     mapping(address => uint256) private _balances;
135 
136     mapping(address => mapping(address => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142 
143     /**
144      * @dev Sets the values for {name} and {symbol}.
145      *
146      * The default value of {decimals} is 18. To select a different value for
147      * {decimals} you should overload it.
148      *
149      * All two of these values are immutable: they can only be set once during
150      * construction.
151      */
152     constructor(string memory name_, string memory symbol_) {
153         _name = name_;
154         _symbol = symbol_;
155     }
156 
157     /**
158      * @dev Returns the name of the token.
159      */
160     function name() public view virtual override returns (string memory) {
161         return _name;
162     }
163 
164     /**
165      * @dev Returns the symbol of the token, usually a shorter version of the
166      * name.
167      */
168     function symbol() public view virtual override returns (string memory) {
169         return _symbol;
170     }
171 
172     /**
173      * @dev Returns the number of decimals used to get its user representation.
174      * For example, if `decimals` equals `2`, a balance of `505` tokens should
175      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
176      *
177      * Tokens usually opt for a value of 18, imitating the relationship between
178      * Ether and Wei. This is the value {ERC20} uses, unless this function is
179      * overridden;
180      *
181      * NOTE: This information is only used for _display_ purposes: it in
182      * no way affects any of the arithmetic of the contract, including
183      * {IERC20-balanceOf} and {IERC20-transfer}.
184      */
185     function decimals() public view virtual override returns (uint8) {
186         return 18;
187     }
188 
189     /**
190      * @dev See {IERC20-totalSupply}.
191      */
192     function totalSupply() public view virtual override returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197      * @dev See {IERC20-balanceOf}.
198      */
199     function balanceOf(address account) public view virtual override returns (uint256) {
200         return _balances[account];
201     }
202 
203     /**
204      * @dev See {IERC20-transfer}.
205      *
206      * Requirements:
207      *
208      * - `recipient` cannot be the zero address.
209      * - the caller must have a balance of at least `amount`.
210      */
211     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
212         _transfer(_msgSender(), recipient, amount);
213         return true;
214     }
215 
216     /**
217      * @dev See {IERC20-allowance}.
218      */
219     function allowance(address owner, address spender) public view virtual override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     /**
224      * @dev See {IERC20-approve}.
225      *
226      * Requirements:
227      *
228      * - `spender` cannot be the zero address.
229      */
230     function approve(address spender, uint256 amount) public virtual override returns (bool) {
231         _approve(_msgSender(), spender, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-transferFrom}.
237      *
238      * Emits an {Approval} event indicating the updated allowance. This is not
239      * required by the EIP. See the note at the beginning of {ERC20}.
240      *
241      * Requirements:
242      *
243      * - `sender` and `recipient` cannot be the zero address.
244      * - `sender` must have a balance of at least `amount`.
245      * - the caller must have allowance for ``sender``'s tokens of at least
246      * `amount`.
247      */
248     function transferFrom(
249         address sender,
250         address recipient,
251         uint256 amount
252     ) public virtual override returns (bool) {
253         _transfer(sender, recipient, amount);
254         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
255         return true;
256     }
257 
258     /**
259      * @dev Atomically increases the allowance granted to `spender` by the caller.
260      *
261      * This is an alternative to {approve} that can be used as a mitigation for
262      * problems described in {IERC20-approve}.
263      *
264      * Emits an {Approval} event indicating the updated allowance.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
271         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
272         return true;
273     }
274 
275     /**
276      * @dev Atomically decreases the allowance granted to `spender` by the caller.
277      *
278      * This is an alternative to {approve} that can be used as a mitigation for
279      * problems described in {IERC20-approve}.
280      *
281      * Emits an {Approval} event indicating the updated allowance.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      * - `spender` must have allowance for the caller of at least
287      * `subtractedValue`.
288      */
289     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
290         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
291         return true;
292     }
293 
294     /**
295      * @dev Moves tokens `amount` from `sender` to `recipient`.
296      *
297      * This is internal function is equivalent to {transfer}, and can be used to
298      * e.g. implement automatic token fees, slashing mechanisms, etc.
299      *
300      * Emits a {Transfer} event.
301      *
302      * Requirements:
303      *
304      * - `sender` cannot be the zero address.
305      * - `recipient` cannot be the zero address.
306      * - `sender` must have a balance of at least `amount`.
307      */
308     function _transfer(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) internal virtual {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315 
316         _beforeTokenTransfer(sender, recipient, amount);
317 
318         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
319         _balances[recipient] = _balances[recipient].add(amount);
320         emit Transfer(sender, recipient, amount);
321     }
322 
323     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
324      * the total supply.
325      *
326      * Emits a {Transfer} event with `from` set to the zero address.
327      *
328      * Requirements:
329      *
330      * - `account` cannot be the zero address.
331      */
332     function _mint(address account, uint256 amount) internal virtual {
333         require(account != address(0), "ERC20: mint to the zero address");
334 
335         _beforeTokenTransfer(address(0), account, amount);
336 
337         _totalSupply = _totalSupply.add(amount);
338         _balances[account] = _balances[account].add(amount);
339         emit Transfer(address(0), account, amount);
340     }
341 
342     /**
343      * @dev Destroys `amount` tokens from `account`, reducing the
344      * total supply.
345      *
346      * Emits a {Transfer} event with `to` set to the zero address.
347      *
348      * Requirements:
349      *
350      * - `account` cannot be the zero address.
351      * - `account` must have at least `amount` tokens.
352      */
353     function _burn(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: burn from the zero address");
355 
356         _beforeTokenTransfer(account, address(0), amount);
357 
358         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
359         _totalSupply = _totalSupply.sub(amount);
360         emit Transfer(account, address(0), amount);
361     }
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
365      *
366      * This internal function is equivalent to `approve`, and can be used to
367      * e.g. set automatic allowances for certain subsystems, etc.
368      *
369      * Emits an {Approval} event.
370      *
371      * Requirements:
372      *
373      * - `owner` cannot be the zero address.
374      * - `spender` cannot be the zero address.
375      */
376     function _approve(
377         address owner,
378         address spender,
379         uint256 amount
380     ) internal virtual {
381         require(owner != address(0), "ERC20: approve from the zero address");
382         require(spender != address(0), "ERC20: approve to the zero address");
383 
384         _allowances[owner][spender] = amount;
385         emit Approval(owner, spender, amount);
386     }
387 
388     /**
389      * @dev Hook that is called before any transfer of tokens. This includes
390      * minting and burning.
391      *
392      * Calling conditions:
393      *
394      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
395      * will be to transferred to `to`.
396      * - when `from` is zero, `amount` tokens will be minted for `to`.
397      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
398      * - `from` and `to` are never both zero.
399      *
400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
401      */
402     function _beforeTokenTransfer(
403         address from,
404         address to,
405         uint256 amount
406     ) internal virtual {}
407 }
408 
409 library SafeMath {
410     /**
411      * @dev Returns the addition of two unsigned integers, reverting on
412      * overflow.
413      *
414      * Counterpart to Solidity's `+` operator.
415      *
416      * Requirements:
417      *
418      * - Addition cannot overflow.
419      */
420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
421         uint256 c = a + b;
422         require(c >= a, "SafeMath: addition overflow");
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the subtraction of two unsigned integers, reverting on
429      * overflow (when the result is negative).
430      *
431      * Counterpart to Solidity's `-` operator.
432      *
433      * Requirements:
434      *
435      * - Subtraction cannot overflow.
436      */
437     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
438         return sub(a, b, "SafeMath: subtraction overflow");
439     }
440 
441     /**
442      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
443      * overflow (when the result is negative).
444      *
445      * Counterpart to Solidity's `-` operator.
446      *
447      * Requirements:
448      *
449      * - Subtraction cannot overflow.
450      */
451     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
452         require(b <= a, errorMessage);
453         uint256 c = a - b;
454 
455         return c;
456     }
457 
458     /**
459      * @dev Returns the multiplication of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `*` operator.
463      *
464      * Requirements:
465      *
466      * - Multiplication cannot overflow.
467      */
468     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
469         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
470         // benefit is lost if 'b' is also tested.
471         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
472         if (a == 0) {
473             return 0;
474         }
475 
476         uint256 c = a * b;
477         require(c / a == b, "SafeMath: multiplication overflow");
478 
479         return c;
480     }
481 
482     /**
483      * @dev Returns the integer division of two unsigned integers. Reverts on
484      * division by zero. The result is rounded towards zero.
485      *
486      * Counterpart to Solidity's `/` operator. Note: this function uses a
487      * `revert` opcode (which leaves remaining gas untouched) while Solidity
488      * uses an invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function div(uint256 a, uint256 b) internal pure returns (uint256) {
495         return div(a, b, "SafeMath: division by zero");
496     }
497 
498     /**
499      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
500      * division by zero. The result is rounded towards zero.
501      *
502      * Counterpart to Solidity's `/` operator. Note: this function uses a
503      * `revert` opcode (which leaves remaining gas untouched) while Solidity
504      * uses an invalid opcode to revert (consuming all remaining gas).
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b > 0, errorMessage);
512         uint256 c = a / b;
513         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
514 
515         return c;
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * Reverts when dividing by zero.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
531         return mod(a, b, "SafeMath: modulo by zero");
532     }
533 
534     /**
535      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
536      * Reverts with custom message when dividing by zero.
537      *
538      * Counterpart to Solidity's `%` operator. This function uses a `revert`
539      * opcode (which leaves remaining gas untouched) while Solidity uses an
540      * invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
547         require(b != 0, errorMessage);
548         return a % b;
549     }
550 }
551 
552 contract Ownable is Context {
553     address private _owner;
554 
555     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
556     
557     /**
558      * @dev Initializes the contract setting the deployer as the initial owner.
559      */
560     constructor () {
561         address msgSender = _msgSender();
562         _owner = msgSender;
563         emit OwnershipTransferred(address(0), msgSender);
564     }
565 
566     /**
567      * @dev Returns the address of the current owner.
568      */
569     function owner() public view returns (address) {
570         return _owner;
571     }
572 
573     /**
574      * @dev Throws if called by any account other than the owner.
575      */
576     modifier onlyOwner() {
577         require(_owner == _msgSender(), "Ownable: caller is not the owner");
578         _;
579     }
580 
581     /**
582      * @dev Leaves the contract without owner. It will not be possible to call
583      * `onlyOwner` functions anymore. Can only be called by the current owner.
584      *
585      * NOTE: Renouncing ownership will leave the contract without an owner,
586      * thereby removing any functionality that is only available to the owner.
587      */
588     function renounceOwnership() public virtual onlyOwner {
589         emit OwnershipTransferred(_owner, address(0));
590         _owner = address(0);
591     }
592 
593     /**
594      * @dev Transfers ownership of the contract to a new account (`newOwner`).
595      * Can only be called by the current owner.
596      */
597     function transferOwnership(address newOwner) public virtual onlyOwner {
598         require(newOwner != address(0), "Ownable: new owner is the zero address");
599         emit OwnershipTransferred(_owner, newOwner);
600         _owner = newOwner;
601     }
602 }
603 
604 
605 
606 library SafeMathInt {
607     int256 private constant MIN_INT256 = int256(1) << 255;
608     int256 private constant MAX_INT256 = ~(int256(1) << 255);
609 
610     /**
611      * @dev Multiplies two int256 variables and fails on overflow.
612      */
613     function mul(int256 a, int256 b) internal pure returns (int256) {
614         int256 c = a * b;
615 
616         // Detect overflow when multiplying MIN_INT256 with -1
617         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
618         require((b == 0) || (c / b == a));
619         return c;
620     }
621 
622     /**
623      * @dev Division of two int256 variables and fails on overflow.
624      */
625     function div(int256 a, int256 b) internal pure returns (int256) {
626         // Prevent overflow when dividing MIN_INT256 by -1
627         require(b != -1 || a != MIN_INT256);
628 
629         // Solidity already throws when dividing by 0.
630         return a / b;
631     }
632 
633     /**
634      * @dev Subtracts two int256 variables and fails on overflow.
635      */
636     function sub(int256 a, int256 b) internal pure returns (int256) {
637         int256 c = a - b;
638         require((b >= 0 && c <= a) || (b < 0 && c > a));
639         return c;
640     }
641 
642     /**
643      * @dev Adds two int256 variables and fails on overflow.
644      */
645     function add(int256 a, int256 b) internal pure returns (int256) {
646         int256 c = a + b;
647         require((b >= 0 && c >= a) || (b < 0 && c < a));
648         return c;
649     }
650 
651     /**
652      * @dev Converts to absolute value, and fails on overflow.
653      */
654     function abs(int256 a) internal pure returns (int256) {
655         require(a != MIN_INT256);
656         return a < 0 ? -a : a;
657     }
658 
659 
660     function toUint256Safe(int256 a) internal pure returns (uint256) {
661         require(a >= 0);
662         return uint256(a);
663     }
664 }
665 
666 library SafeMathUint {
667   function toInt256Safe(uint256 a) internal pure returns (int256) {
668     int256 b = int256(a);
669     require(b >= 0);
670     return b;
671   }
672 }
673 
674 
675 interface IUniswapV2Router01 {
676     function factory() external pure returns (address);
677     function WETH() external pure returns (address);
678 
679     function addLiquidityETH(
680         address token,
681         uint amountTokenDesired,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline
686     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
687 }
688 
689 interface IUniswapV2Router02 is IUniswapV2Router01 {
690     function swapExactTokensForETHSupportingFeeOnTransferTokens(
691         uint amountIn,
692         uint amountOutMin,
693         address[] calldata path,
694         address to,
695         uint deadline
696     ) external;
697 }
698 
699 contract Shifu is ERC20, Ownable {
700 
701     IUniswapV2Router02 public immutable uniswapV2Router;
702     address public immutable uniswapV2Pair;
703     address public constant deadAddress = address(0xdead);
704 
705     bool private swapping;
706 
707     address public marketingWallet;
708     address public devWallet;
709     
710     uint256 public maxTransactionAmount;
711     uint256 public swapTokensAtAmount;
712     uint256 public maxWallet;
713     
714     uint256 public percentForLPBurn = 25; // 25 = .25%
715     bool public lpBurnEnabled = false;
716     uint256 public lpBurnFrequency = 3600 seconds;
717     uint256 public lastLpBurnTime;
718     
719     uint256 public manualBurnFrequency = 30 minutes;
720     uint256 public lastManualLpBurnTime;
721 
722     bool public limitsInEffect = true;
723     bool public tradingActive = false;
724     bool public swapEnabled = false;
725     
726      // Anti-bot and anti-whale mappings and variables
727     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
728     mapping (address => bool) public isBlacklisted;
729     bool public transferDelayEnabled = true;
730 
731     uint256 public buyTotalFees;
732     uint256 public buyMarketingFee;
733     uint256 public buyLiquidityFee;
734     uint256 public buyDevFee;
735     
736     uint256 public sellTotalFees;
737     uint256 public sellMarketingFee;
738     uint256 public sellLiquidityFee;
739     uint256 public sellDevFee;
740     
741     uint256 public tokensForMarketing;
742     uint256 public tokensForLiquidity;
743     uint256 public tokensForDev;
744 
745     // exlcude from fees and max transaction amount
746     mapping (address => bool) private _isExcludedFromFees;
747     mapping (address => bool) public _isExcludedMaxTransactionAmount;
748 
749     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
750     // could be subject to a maximum transfer amount
751     mapping (address => bool) public automatedMarketMakerPairs;
752 
753     constructor() ERC20("Shifu", "SHIFU") {
754         
755         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
756         
757         excludeFromMaxTransaction(address(_uniswapV2Router), true);
758         uniswapV2Router = _uniswapV2Router;
759         
760         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
761         excludeFromMaxTransaction(address(uniswapV2Pair), true);
762         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
763         
764         uint256 _buyMarketingFee = 25;
765         uint256 _buyLiquidityFee = 0;
766         uint256 _buyDevFee = 0;
767 
768         uint256 _sellMarketingFee = 25;
769         uint256 _sellLiquidityFee = 0;
770         uint256 _sellDevFee = 0;
771         
772         uint256 totalSupply = 1000000000000 * 1e18; 
773         
774         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
775         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
776         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
777 
778         buyMarketingFee = _buyMarketingFee;
779         buyLiquidityFee = _buyLiquidityFee;
780         buyDevFee = _buyDevFee;
781         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
782         
783         sellMarketingFee = _sellMarketingFee;
784         sellLiquidityFee = _sellLiquidityFee;
785         sellDevFee = _sellDevFee;
786         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
787         
788         marketingWallet = address(owner()); // set as marketing wallet
789         devWallet = address(owner()); // set as dev wallet
790 
791         // exclude from paying fees or having max transaction amount
792         excludeFromFees(owner(), true);
793         excludeFromFees(address(this), true);
794         excludeFromFees(address(0xdead), true);
795         
796         excludeFromMaxTransaction(owner(), true);
797         excludeFromMaxTransaction(address(this), true);
798         excludeFromMaxTransaction(address(0xdead), true);
799         
800         _mint(msg.sender, totalSupply);
801     }
802 
803     receive() external payable {
804 
805   	}
806 
807     // once enabled, can never be turned off
808     function openTrading() external onlyOwner {
809         tradingActive = true;
810         swapEnabled = true;
811         lastLpBurnTime = block.timestamp;
812     }
813     
814     // remove limits after token is stable
815     function removeShifulimits() external onlyOwner returns (bool){
816         limitsInEffect = false;
817         transferDelayEnabled = false;
818         return true;
819     }
820     
821     // change the minimum amount of tokens to sell from fees
822     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
823   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
824   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
825   	    return true;
826   	}
827     
828     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
829         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
830         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
831         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
832         maxWallet = (totalSupply() * walNum / 100)/1e18;
833     }
834 
835     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
836         _isExcludedMaxTransactionAmount[updAds] = isEx;
837     }
838     
839     // only use to disable contract sales if absolutely necessary (emergency use only)
840     function updateSwapEnabled(bool enabled) external onlyOwner(){
841         swapEnabled = enabled;
842     }
843     
844     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
845         buyMarketingFee = _marketingFee;
846         buyLiquidityFee = _liquidityFee;
847         buyDevFee = _devFee;
848         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
849         require(buyTotalFees <= 60, "Must keep fees at 20% or less");
850     }
851     
852     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
853         sellMarketingFee = _marketingFee;
854         sellLiquidityFee = _liquidityFee;
855         sellDevFee = _devFee;
856         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
857         require(sellTotalFees <= 60, "Must keep fees at 25% or less");
858     }
859 
860     function excludeFromFees(address account, bool excluded) public onlyOwner {
861         _isExcludedFromFees[account] = excluded;
862     }
863 
864     function _setAutomatedMarketMakerPair(address pair, bool value) private {
865         automatedMarketMakerPairs[pair] = value;
866     }
867 
868     function updateMarketingWalletinfo(address newMarketingWallet) external onlyOwner {
869         marketingWallet = newMarketingWallet;
870     }
871     
872     function updateDevWalletinfo(address newWallet) external onlyOwner {
873         devWallet = newWallet;
874     }
875 
876     function isExcludedFromFees(address account) public view returns(bool) {
877         return _isExcludedFromFees[account];
878     }
879 
880     function manage_bots(address _address, bool status) external onlyOwner {
881         require(_address != address(0),"Address should not be 0");
882         isBlacklisted[_address] = status;
883     }
884 
885     function _transfer(
886         address from,
887         address to,
888         uint256 amount
889     ) internal override {
890         require(from != address(0), "ERC20: transfer from the zero address");
891         require(to != address(0), "ERC20: transfer to the zero address");
892         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
893         
894          if(amount == 0) {
895             super._transfer(from, to, 0);
896             return;
897         }
898         
899         if(limitsInEffect){
900             if (
901                 from != owner() &&
902                 to != owner() &&
903                 to != address(0) &&
904                 to != address(0xdead) &&
905                 !swapping
906             ){
907                 if(!tradingActive){
908                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
909                 }
910 
911                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
912                 if (transferDelayEnabled){
913                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
914                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
915                         _holderLastTransferTimestamp[tx.origin] = block.number;
916                     }
917                 }
918                  
919                 //when buy
920                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
921                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
922                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
923                 }
924                 
925                 //when sell
926                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
927                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
928                 }
929                 else if(!_isExcludedMaxTransactionAmount[to]){
930                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
931                 }
932             }
933         }
934         
935 		uint256 contractTokenBalance = balanceOf(address(this));
936         
937         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
938 
939         if( 
940             canSwap &&
941             swapEnabled &&
942             !swapping &&
943             !automatedMarketMakerPairs[from] &&
944             !_isExcludedFromFees[from] &&
945             !_isExcludedFromFees[to]
946         ) {
947             swapping = true;
948             
949             swapBack();
950 
951             swapping = false;
952         }
953 
954         bool takeFee = !swapping;
955 
956         // if any account belongs to _isExcludedFromFee account then remove the fee
957         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
958             takeFee = false;
959         }
960         
961         uint256 fees = 0;
962         // only take fees on buys/sells, do not take on wallet transfers
963         if(takeFee){
964             // on sell
965             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
966                 fees = amount * sellTotalFees/100;
967                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
968                 tokensForDev += fees * sellDevFee / sellTotalFees;
969                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
970             }
971             // on buy
972             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
973         	    fees = amount * buyTotalFees/100;
974         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
975                 tokensForDev += fees * buyDevFee / buyTotalFees;
976                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
977             }
978             
979             if(fees > 0){    
980                 super._transfer(from, address(this), fees);
981             }
982         	
983         	amount -= fees;
984         }
985 
986         super._transfer(from, to, amount);
987     }
988 
989     function swapTokensForEth(uint256 tokenAmount) private {
990 
991         // generate the uniswap pair path of token -> weth
992         address[] memory path = new address[](2);
993         path[0] = address(this);
994         path[1] = uniswapV2Router.WETH();
995 
996         _approve(address(this), address(uniswapV2Router), tokenAmount);
997 
998         // make the swap
999         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1000             tokenAmount,
1001             0, // accept any amount of ETH
1002             path,
1003             address(this),
1004             block.timestamp
1005         );
1006         
1007     }
1008     
1009     
1010     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1011         // approve token transfer to cover all possible scenarios
1012         _approve(address(this), address(uniswapV2Router), tokenAmount);
1013 
1014         // add the liquidity
1015         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1016             address(this),
1017             tokenAmount,
1018             0, // slippage is unavoidable
1019             0, // slippage is unavoidable
1020             deadAddress,
1021             block.timestamp
1022         );
1023     }
1024 
1025     function swapBack() private {
1026         uint256 contractBalance = balanceOf(address(this));
1027         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1028         bool success;
1029         
1030         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1031 
1032         if(contractBalance > swapTokensAtAmount * 20){
1033           contractBalance = swapTokensAtAmount * 20;
1034         }
1035         
1036         // Halve the amount of liquidity tokens
1037         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1038         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1039         
1040         uint256 initialETHBalance = address(this).balance;
1041 
1042         swapTokensForEth(amountToSwapForETH); 
1043         
1044         uint256 ethBalance = address(this).balance - initialETHBalance;
1045         
1046         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1047         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1048         
1049         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1050         
1051         tokensForLiquidity = 0;
1052         tokensForMarketing = 0;
1053         tokensForDev = 0;
1054         
1055         (success,) = address(devWallet).call{value: ethForDev}("");
1056         
1057         if(liquidityTokens > 0 && ethForLiquidity > 0){
1058             addLiquidity(liquidityTokens, ethForLiquidity);
1059         }
1060         
1061         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1062     }
1063 
1064     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1065         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1066         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1067         lastManualLpBurnTime = block.timestamp;
1068         
1069         // get balance of liquidity pair
1070         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1071         
1072         // calculate amount to burn
1073         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1074         
1075         // pull tokens from pancakePair liquidity and move to dead address permanently
1076         if (amountToBurn > 0){
1077             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1078         }
1079         
1080         //sync price since this is not in a swap transaction!
1081         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1082         pair.sync();
1083         return true;
1084     }
1085 }