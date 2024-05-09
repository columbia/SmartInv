1 //The World's First AI Privacy Swap.
2 
3 
4 // SPDX-License-Identifier: MIT                                                                               
5                                                             
6 pragma solidity = 0.8.19;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IUniswapV2Pair {
20     event Sync(uint112 reserve0, uint112 reserve1);
21     function sync() external;
22 }
23 
24 interface IUniswapV2Factory {
25     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
26 
27     function createPair(address tokenA, address tokenB) external returns (address pair);
28 }
29 
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 
123 contract ERC20 is Context, IERC20, IERC20Metadata {
124     using SafeMath for uint256;
125 
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string private _name;
133     string private _symbol;
134 
135     /**
136      * @dev Sets the values for {name} and {symbol}.
137      *
138      * The default value of {decimals} is 18. To select a different value for
139      * {decimals} you should overload it.
140      *
141      * All two of these values are immutable: they can only be set once during
142      * construction.
143      */
144     constructor(string memory name_, string memory symbol_) {
145         _name = name_;
146         _symbol = symbol_;
147     }
148 
149     /**
150      * @dev Returns the name of the token.
151      */
152     function name() public view virtual override returns (string memory) {
153         return _name;
154     }
155 
156     /**
157      * @dev Returns the symbol of the token, usually a shorter version of the
158      * name.
159      */
160     function symbol() public view virtual override returns (string memory) {
161         return _symbol;
162     }
163 
164     /**
165      * @dev Returns the number of decimals used to get its user representation.
166      * For example, if `decimals` equals `2`, a balance of `505` tokens should
167      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
168      *
169      * Tokens usually opt for a value of 18, imitating the relationship between
170      * Ether and Wei. This is the value {ERC20} uses, unless this function is
171      * overridden;
172      *
173      * NOTE: This information is only used for _display_ purposes: it in
174      * no way affects any of the arithmetic of the contract, including
175      * {IERC20-balanceOf} and {IERC20-transfer}.
176      */
177     function decimals() public view virtual override returns (uint8) {
178         return 18;
179     }
180 
181     /**
182      * @dev See {IERC20-totalSupply}.
183      */
184     function totalSupply() public view virtual override returns (uint256) {
185         return _totalSupply;
186     }
187 
188     /**
189      * @dev See {IERC20-balanceOf}.
190      */
191     function balanceOf(address account) public view virtual override returns (uint256) {
192         return _balances[account];
193     }
194 
195     /**
196      * @dev See {IERC20-transfer}.
197      *
198      * Requirements:
199      *
200      * - `recipient` cannot be the zero address.
201      * - the caller must have a balance of at least `amount`.
202      */
203     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     /**
209      * @dev See {IERC20-allowance}.
210      */
211     function allowance(address owner, address spender) public view virtual override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     /**
216      * @dev See {IERC20-approve}.
217      *
218      * Requirements:
219      *
220      * - `spender` cannot be the zero address.
221      */
222     function approve(address spender, uint256 amount) public virtual override returns (bool) {
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     /**
228      * @dev See {IERC20-transferFrom}.
229      *
230      * Emits an {Approval} event indicating the updated allowance. This is not
231      * required by the EIP. See the note at the beginning of {ERC20}.
232      *
233      * Requirements:
234      *
235      * - `sender` and `recipient` cannot be the zero address.
236      * - `sender` must have a balance of at least `amount`.
237      * - the caller must have allowance for ``sender``'s tokens of at least
238      * `amount`.
239      */
240     function transferFrom(
241         address sender,
242         address recipient,
243         uint256 amount
244     ) public virtual override returns (bool) {
245         _transfer(sender, recipient, amount);
246         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
247         return true;
248     }
249 
250     /**
251      * @dev Atomically increases the allowance granted to `spender` by the caller.
252      *
253      * This is an alternative to {approve} that can be used as a mitigation for
254      * problems described in {IERC20-approve}.
255      *
256      * Emits an {Approval} event indicating the updated allowance.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      */
262     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
263         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
264         return true;
265     }
266 
267     /**
268      * @dev Atomically decreases the allowance granted to `spender` by the caller.
269      *
270      * This is an alternative to {approve} that can be used as a mitigation for
271      * problems described in {IERC20-approve}.
272      *
273      * Emits an {Approval} event indicating the updated allowance.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      * - `spender` must have allowance for the caller of at least
279      * `subtractedValue`.
280      */
281     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
282         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
283         return true;
284     }
285 
286     /**
287      * @dev Moves tokens `amount` from `sender` to `recipient`.
288      *
289      * This is internal function is equivalent to {transfer}, and can be used to
290      * e.g. implement automatic token fees, slashing mechanisms, etc.
291      *
292      * Emits a {Transfer} event.
293      *
294      * Requirements:
295      *
296      * - `sender` cannot be the zero address.
297      * - `recipient` cannot be the zero address.
298      * - `sender` must have a balance of at least `amount`.
299      */
300     function _transfer(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) internal virtual {
305         require(sender != address(0), "ERC20: transfer from the zero address");
306         require(recipient != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(sender, recipient, amount);
309 
310         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
311         _balances[recipient] = _balances[recipient].add(amount);
312         emit Transfer(sender, recipient, amount);
313     }
314 
315     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
316      * the total supply.
317      *
318      * Emits a {Transfer} event with `from` set to the zero address.
319      *
320      * Requirements:
321      *
322      * - `account` cannot be the zero address.
323      */
324     function _mint(address account, uint256 amount) internal virtual {
325         require(account != address(0), "ERC20: mint to the zero address");
326 
327         _beforeTokenTransfer(address(0), account, amount);
328 
329         _totalSupply = _totalSupply.add(amount);
330         _balances[account] = _balances[account].add(amount);
331         emit Transfer(address(0), account, amount);
332     }
333 
334     /**
335      * @dev Destroys `amount` tokens from `account`, reducing the
336      * total supply.
337      *
338      * Emits a {Transfer} event with `to` set to the zero address.
339      *
340      * Requirements:
341      *
342      * - `account` cannot be the zero address.
343      * - `account` must have at least `amount` tokens.
344      */
345     function _burn(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: burn from the zero address");
347 
348         _beforeTokenTransfer(account, address(0), amount);
349 
350         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
351         _totalSupply = _totalSupply.sub(amount);
352         emit Transfer(account, address(0), amount);
353     }
354 
355     /**
356      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
357      *
358      * This internal function is equivalent to `approve`, and can be used to
359      * e.g. set automatic allowances for certain subsystems, etc.
360      *
361      * Emits an {Approval} event.
362      *
363      * Requirements:
364      *
365      * - `owner` cannot be the zero address.
366      * - `spender` cannot be the zero address.
367      */
368     function _approve(
369         address owner,
370         address spender,
371         uint256 amount
372     ) internal virtual {
373         require(owner != address(0), "ERC20: approve from the zero address");
374         require(spender != address(0), "ERC20: approve to the zero address");
375 
376         _allowances[owner][spender] = amount;
377         emit Approval(owner, spender, amount);
378     }
379 
380     /**
381      * @dev Hook that is called before any transfer of tokens. This includes
382      * minting and burning.
383      *
384      * Calling conditions:
385      *
386      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
387      * will be to transferred to `to`.
388      * - when `from` is zero, `amount` tokens will be minted for `to`.
389      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
390      * - `from` and `to` are never both zero.
391      *
392      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
393      */
394     function _beforeTokenTransfer(
395         address from,
396         address to,
397         uint256 amount
398     ) internal virtual {}
399 }
400 
401 library SafeMath {
402     /**
403      * @dev Returns the addition of two unsigned integers, reverting on
404      * overflow.
405      *
406      * Counterpart to Solidity's `+` operator.
407      *
408      * Requirements:
409      *
410      * - Addition cannot overflow.
411      */
412     function add(uint256 a, uint256 b) internal pure returns (uint256) {
413         uint256 c = a + b;
414         require(c >= a, "SafeMath: addition overflow");
415 
416         return c;
417     }
418 
419     /**
420      * @dev Returns the subtraction of two unsigned integers, reverting on
421      * overflow (when the result is negative).
422      *
423      * Counterpart to Solidity's `-` operator.
424      *
425      * Requirements:
426      *
427      * - Subtraction cannot overflow.
428      */
429     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
430         return sub(a, b, "SafeMath: subtraction overflow");
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
435      * overflow (when the result is negative).
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      *
441      * - Subtraction cannot overflow.
442      */
443     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
444         require(b <= a, errorMessage);
445         uint256 c = a - b;
446 
447         return c;
448     }
449 
450     /**
451      * @dev Returns the multiplication of two unsigned integers, reverting on
452      * overflow.
453      *
454      * Counterpart to Solidity's `*` operator.
455      *
456      * Requirements:
457      *
458      * - Multiplication cannot overflow.
459      */
460     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
461         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
462         // benefit is lost if 'b' is also tested.
463         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
464         if (a == 0) {
465             return 0;
466         }
467 
468         uint256 c = a * b;
469         require(c / a == b, "SafeMath: multiplication overflow");
470 
471         return c;
472     }
473 
474     /**
475      * @dev Returns the integer division of two unsigned integers. Reverts on
476      * division by zero. The result is rounded towards zero.
477      *
478      * Counterpart to Solidity's `/` operator. Note: this function uses a
479      * `revert` opcode (which leaves remaining gas untouched) while Solidity
480      * uses an invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function div(uint256 a, uint256 b) internal pure returns (uint256) {
487         return div(a, b, "SafeMath: division by zero");
488     }
489 
490     /**
491      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
492      * division by zero. The result is rounded towards zero.
493      *
494      * Counterpart to Solidity's `/` operator. Note: this function uses a
495      * `revert` opcode (which leaves remaining gas untouched) while Solidity
496      * uses an invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b > 0, errorMessage);
504         uint256 c = a / b;
505         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
506 
507         return c;
508     }
509 
510     /**
511      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
512      * Reverts when dividing by zero.
513      *
514      * Counterpart to Solidity's `%` operator. This function uses a `revert`
515      * opcode (which leaves remaining gas untouched) while Solidity uses an
516      * invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
523         return mod(a, b, "SafeMath: modulo by zero");
524     }
525 
526     /**
527      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
528      * Reverts with custom message when dividing by zero.
529      *
530      * Counterpart to Solidity's `%` operator. This function uses a `revert`
531      * opcode (which leaves remaining gas untouched) while Solidity uses an
532      * invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
539         require(b != 0, errorMessage);
540         return a % b;
541     }
542 }
543 
544 contract Ownable is Context {
545     address private _owner;
546 
547     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548     
549     /**
550      * @dev Initializes the contract setting the deployer as the initial owner.
551      */
552     constructor () {
553         address msgSender = _msgSender();
554         _owner = msgSender;
555         emit OwnershipTransferred(address(0), msgSender);
556     }
557 
558     /**
559      * @dev Returns the address of the current owner.
560      */
561     function owner() public view returns (address) {
562         return _owner;
563     }
564 
565     /**
566      * @dev Throws if called by any account other than the owner.
567      */
568     modifier onlyOwner() {
569         require(_owner == _msgSender(), "Ownable: caller is not the owner");
570         _;
571     }
572 
573     /**
574      * @dev Leaves the contract without owner. It will not be possible to call
575      * `onlyOwner` functions anymore. Can only be called by the current owner.
576      *
577      * NOTE: Renouncing ownership will leave the contract without an owner,
578      * thereby removing any functionality that is only available to the owner.
579      */
580     function renounceOwnership() public virtual onlyOwner {
581         emit OwnershipTransferred(_owner, address(0));
582         _owner = address(0);
583     }
584 
585     /**
586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
587      * Can only be called by the current owner.
588      */
589     function transferOwnership(address newOwner) public virtual onlyOwner {
590         require(newOwner != address(0), "Ownable: new owner is the zero address");
591         emit OwnershipTransferred(_owner, newOwner);
592         _owner = newOwner;
593     }
594 }
595 
596 
597 
598 library SafeMathInt {
599     int256 private constant MIN_INT256 = int256(1) << 255;
600     int256 private constant MAX_INT256 = ~(int256(1) << 255);
601 
602     /**
603      * @dev Multiplies two int256 variables and fails on overflow.
604      */
605     function mul(int256 a, int256 b) internal pure returns (int256) {
606         int256 c = a * b;
607 
608         // Detect overflow when multiplying MIN_INT256 with -1
609         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
610         require((b == 0) || (c / b == a));
611         return c;
612     }
613 
614     /**
615      * @dev Division of two int256 variables and fails on overflow.
616      */
617     function div(int256 a, int256 b) internal pure returns (int256) {
618         // Prevent overflow when dividing MIN_INT256 by -1
619         require(b != -1 || a != MIN_INT256);
620 
621         // Solidity already throws when dividing by 0.
622         return a / b;
623     }
624 
625     /**
626      * @dev Subtracts two int256 variables and fails on overflow.
627      */
628     function sub(int256 a, int256 b) internal pure returns (int256) {
629         int256 c = a - b;
630         require((b >= 0 && c <= a) || (b < 0 && c > a));
631         return c;
632     }
633 
634     /**
635      * @dev Adds two int256 variables and fails on overflow.
636      */
637     function add(int256 a, int256 b) internal pure returns (int256) {
638         int256 c = a + b;
639         require((b >= 0 && c >= a) || (b < 0 && c < a));
640         return c;
641     }
642 
643     /**
644      * @dev Converts to absolute value, and fails on overflow.
645      */
646     function abs(int256 a) internal pure returns (int256) {
647         require(a != MIN_INT256);
648         return a < 0 ? -a : a;
649     }
650 
651 
652     function toUint256Safe(int256 a) internal pure returns (uint256) {
653         require(a >= 0);
654         return uint256(a);
655     }
656 }
657 
658 library SafeMathUint {
659   function toInt256Safe(uint256 a) internal pure returns (int256) {
660     int256 b = int256(a);
661     require(b >= 0);
662     return b;
663   }
664 }
665 
666 
667 interface IUniswapV2Router01 {
668     function factory() external pure returns (address);
669     function WETH() external pure returns (address);
670 
671     function addLiquidityETH(
672         address token,
673         uint amountTokenDesired,
674         uint amountTokenMin,
675         uint amountETHMin,
676         address to,
677         uint deadline
678     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
679 }
680 
681 interface IUniswapV2Router02 is IUniswapV2Router01 {
682     function swapExactTokensForETHSupportingFeeOnTransferTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external;
689 }
690 
691 contract GFI is ERC20, Ownable {
692 
693     IUniswapV2Router02 public immutable uniswapV2Router;
694     address public immutable uniswapV2Pair;
695     address public constant deadAddress = address(0xdead);
696 
697     bool private swapping;
698 
699     address public marketingWallet;
700     address public devWallet;
701     
702     uint256 public maxTransactionAmount;
703     uint256 public swapTokensAtAmount;
704     uint256 public maxWallet;
705     
706     uint256 public percentForLPBurn = 25; // 25 = .25%
707     bool public lpBurnEnabled = false;
708     uint256 public lpBurnFrequency = 3600 seconds;
709     uint256 public lastLpBurnTime;
710     
711     uint256 public manualBurnFrequency = 30 minutes;
712     uint256 public lastManualLpBurnTime;
713 
714     bool public limitsInEffect = true;
715     bool public tradingActive = false;
716     bool public swapEnabled = false;
717     
718      // Anti-bot and anti-whale mappings and variables
719     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
720     mapping (address => bool) public isBlacklisted;
721     bool public transferDelayEnabled = true;
722 
723     uint256 public buyTotalFees;
724     uint256 public buyMarketingFee;
725     uint256 public buyLiquidityFee;
726     uint256 public buyDevFee;
727     
728     uint256 public sellTotalFees;
729     uint256 public sellMarketingFee;
730     uint256 public sellLiquidityFee;
731     uint256 public sellDevFee;
732     
733     uint256 public tokensForMarketing;
734     uint256 public tokensForLiquidity;
735     uint256 public tokensForDev;
736 
737     string public _websiteInformation;
738     string public _twitterInformation;
739 
740     // exlcude from fees and max transaction amount
741     mapping (address => bool) private _isExcludedFromFees;
742     mapping (address => bool) public _isExcludedMaxTransactionAmount;
743 
744     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
745     // could be subject to a maximum transfer amount
746     mapping (address => bool) public automatedMarketMakerPairs;
747 
748     constructor() ERC20(unicode"Ghost Finance", unicode"GFI") {
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
759         uint256 _buyMarketingFee = 25;
760         uint256 _buyLiquidityFee = 0;
761         uint256 _buyDevFee = 0;
762 
763         uint256 _sellMarketingFee = 35;
764         uint256 _sellLiquidityFee = 0;
765         uint256 _sellDevFee = 0;
766         
767         uint256 totalSupply = 1000000000000 * 1e18; 
768         
769         maxTransactionAmount = totalSupply * 2 / 100; // 
770         maxWallet = totalSupply * 2 / 100; //
771         swapTokensAtAmount = totalSupply * 5 / 1000; // 
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
783         marketingWallet = address(owner()); 
784         devWallet = address(owner()); // 
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
810     function Updatealllimits() external onlyOwner returns (bool){
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
844         require(buyTotalFees <= 40, "Must keep fees at 99% or less");
845     }
846     
847     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
848         sellMarketingFee = _marketingFee;
849         sellLiquidityFee = _liquidityFee;
850         sellDevFee = _devFee;
851         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
852         require(sellTotalFees <= 50, "Must keep fees at 99% or less");
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
863     function UpdateallmarketingWallet(address newMarketingWallet) external onlyOwner {
864         marketingWallet = newMarketingWallet;
865     }
866     
867     function UpdatealldevWallet(address newWallet) external onlyOwner {
868         devWallet = newWallet;
869     }
870 
871     function isExcludedFromFees(address account) public view returns(bool) {
872         return _isExcludedFromFees[account];
873     }
874 
875     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
876         for(uint256 i = 0; i < wallets.length; i++){
877         isBlacklisted[wallets[i]] = flag;
878         }
879     }
880 
881     function withdrawETH() external onlyOwner returns(bool){
882         (bool success, ) = owner().call{value: address(this).balance}("");
883         return success;
884     }
885 
886     function _transfer(
887         address from,
888         address to,
889         uint256 amount
890     ) internal override {
891         require(from != address(0), "ERC20: transfer from the zero address");
892         require(to != address(0), "ERC20: transfer to the zero address");
893         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
894     
895         
896          if(amount == 0) {
897             super._transfer(from, to, 0);
898             return;
899         }
900         
901         if(limitsInEffect){
902             if (
903                 from != owner() &&
904                 to != owner() &&
905                 to != address(0) &&
906                 to != address(0xdead) &&
907                 !swapping
908             ){
909                 if(!tradingActive){
910                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
911                 }
912 
913                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
914                 if (transferDelayEnabled){
915                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
916                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
917                         _holderLastTransferTimestamp[tx.origin] = block.number;
918                     }
919                 }
920                  
921                 //when buy
922                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
923                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
924                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
925                 }
926                 
927                 //when sell
928                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
929                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
930                 }
931                 else if(!_isExcludedMaxTransactionAmount[to]){
932                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
933                 }
934             }
935         }
936         
937 		uint256 contractTokenBalance = balanceOf(address(this));
938         
939         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
940 
941         if( 
942             canSwap &&
943             swapEnabled &&
944             !swapping &&
945             !automatedMarketMakerPairs[from] &&
946             !_isExcludedFromFees[from] &&
947             !_isExcludedFromFees[to]
948         ) {
949             swapping = true;
950             
951             swapBack();
952 
953             swapping = false;
954         }
955 
956         bool takeFee = !swapping;
957 
958         // if any account belongs to _isExcludedFromFee account then remove the fee
959         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
960             takeFee = false;
961         }
962         
963         uint256 fees = 0;
964         // only take fees on buys/sells, do not take on wallet transfers
965         if(takeFee){
966             // on sell
967             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
968                 fees = amount * sellTotalFees/100;
969                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
970                 tokensForDev += fees * sellDevFee / sellTotalFees;
971                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
972             }
973             // on buy
974             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
975         	    fees = amount * buyTotalFees/100;
976         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
977                 tokensForDev += fees * buyDevFee / buyTotalFees;
978                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
979             }
980             
981             if(fees > 0){    
982                 super._transfer(from, address(this), fees);
983             }
984         	
985         	amount -= fees;
986         }
987 
988         super._transfer(from, to, amount);
989     }
990 
991     function swapTokensForEth(uint256 tokenAmount) private {
992 
993         // generate the uniswap pair path of token -> weth
994         address[] memory path = new address[](2);
995         path[0] = address(this);
996         path[1] = uniswapV2Router.WETH();
997 
998         _approve(address(this), address(uniswapV2Router), tokenAmount);
999 
1000         // make the swap
1001         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1002             tokenAmount,
1003             0, // accept any amount of ETH
1004             path,
1005             address(this),
1006             block.timestamp
1007         );
1008         
1009     }
1010     
1011     
1012     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1013         // approve token transfer to cover all possible scenarios
1014         _approve(address(this), address(uniswapV2Router), tokenAmount);
1015 
1016         // add the liquidity
1017         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1018             address(this),
1019             tokenAmount,
1020             0, // slippage is unavoidable
1021             0, // slippage is unavoidable
1022             deadAddress,
1023             block.timestamp
1024         );
1025     }
1026 
1027     function swapBack() public {
1028         uint256 contractBalance = balanceOf(address(this));
1029         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1030         bool success;
1031         
1032         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1033 
1034         if(contractBalance > swapTokensAtAmount * 20){
1035           contractBalance = swapTokensAtAmount * 20;
1036         }
1037         
1038         // Halve the amount of liquidity tokens
1039         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1040         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1041         
1042         uint256 initialETHBalance = address(this).balance;
1043 
1044         swapTokensForEth(amountToSwapForETH); 
1045         
1046         uint256 ethBalance = address(this).balance - initialETHBalance;
1047         
1048         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1049         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1050         
1051         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1052         
1053         tokensForLiquidity = 0;
1054         tokensForMarketing = 0;
1055         tokensForDev = 0;
1056         
1057         (success,) = address(devWallet).call{value: ethForDev}("");
1058         
1059         if(liquidityTokens > 0 && ethForLiquidity > 0){
1060             addLiquidity(liquidityTokens, ethForLiquidity);
1061         }
1062         
1063         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1064     }
1065 
1066     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1067         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1068         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1069         lastManualLpBurnTime = block.timestamp;
1070         
1071         // get balance of liquidity pair
1072         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1073         
1074         // calculate amount to burn
1075         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1076         
1077         
1078         if (amountToBurn > 0){
1079             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1080         }
1081         
1082         //sync price since this is not in a swap transaction!
1083         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1084         pair.sync();
1085         return true;
1086     }
1087 
1088   
1089 
1090     /**
1091         Socials - Web & Twitter
1092     **/
1093       
1094     function setSocialswebtwitter(
1095         string calldata __websiteInformation,
1096         string calldata __twitterInformation
1097     ) external {
1098         require(
1099             msg.sender ==  address(owner()),
1100             "Only developer can adjust social links"
1101         );
1102 
1103         _websiteInformation = __websiteInformation;
1104         _twitterInformation = __twitterInformation;
1105 }  
1106 
1107     function getWebsiteInformation() public view returns (string memory) {
1108         return _websiteInformation;
1109     }
1110 
1111     function getTwitterInformation() public view returns (string memory) {
1112         return _twitterInformation;
1113     }
1114 
1115 }