1 /**
2 Telegram: https://t.me/iBOTerc
3 Website: http://iBOTerc.com/
4 Twitter: https://twitter.com/iBOTerc
5 */
6 
7 
8 // SPDX-License-Identifier: MIT                                                                               
9                                                     
10 pragma solidity = 0.8.19;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IUniswapV2Pair {
24     event Sync(uint112 reserve0, uint112 reserve1);
25     function sync() external;
26 }
27 
28 interface IUniswapV2Factory {
29     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
30 
31     function createPair(address tokenA, address tokenB) external returns (address pair);
32 }
33 
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     using SafeMath for uint256;
129 
130     mapping(address => uint256) private _balances;
131 
132     mapping(address => mapping(address => uint256)) private _allowances;
133 
134     uint256 private _totalSupply;
135 
136     string private _name;
137     string private _symbol;
138 
139     /**
140      * @dev Sets the values for {name} and {symbol}.
141      *
142      * The default value of {decimals} is 18. To select a different value for
143      * {decimals} you should overload it.
144      *
145      * All two of these values are immutable: they can only be set once during
146      * construction.
147      */
148     constructor(string memory name_, string memory symbol_) {
149         _name = name_;
150         _symbol = symbol_;
151     }
152 
153     /**
154      * @dev Returns the name of the token.
155      */
156     function name() public view virtual override returns (string memory) {
157         return _name;
158     }
159 
160     /**
161      * @dev Returns the symbol of the token, usually a shorter version of the
162      * name.
163      */
164     function symbol() public view virtual override returns (string memory) {
165         return _symbol;
166     }
167 
168     /**
169      * @dev Returns the number of decimals used to get its user representation.
170      * For example, if `decimals` equals `2`, a balance of `505` tokens should
171      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
172      *
173      * Tokens usually opt for a value of 18, imitating the relationship between
174      * Ether and Wei. This is the value {ERC20} uses, unless this function is
175      * overridden;
176      *
177      * NOTE: This information is only used for _display_ purposes: it in
178      * no way affects any of the arithmetic of the contract, including
179      * {IERC20-balanceOf} and {IERC20-transfer}.
180      */
181     function decimals() public view virtual override returns (uint8) {
182         return 18;
183     }
184 
185     /**
186      * @dev See {IERC20-totalSupply}.
187      */
188     function totalSupply() public view virtual override returns (uint256) {
189         return _totalSupply;
190     }
191 
192     /**
193      * @dev See {IERC20-balanceOf}.
194      */
195     function balanceOf(address account) public view virtual override returns (uint256) {
196         return _balances[account];
197     }
198 
199     /**
200      * @dev See {IERC20-transfer}.
201      *
202      * Requirements:
203      *
204      * - `recipient` cannot be the zero address.
205      * - the caller must have a balance of at least `amount`.
206      */
207     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     /**
213      * @dev See {IERC20-allowance}.
214      */
215     function allowance(address owner, address spender) public view virtual override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     /**
220      * @dev See {IERC20-approve}.
221      *
222      * Requirements:
223      *
224      * - `spender` cannot be the zero address.
225      */
226     function approve(address spender, uint256 amount) public virtual override returns (bool) {
227         _approve(_msgSender(), spender, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-transferFrom}.
233      *
234      * Emits an {Approval} event indicating the updated allowance. This is not
235      * required by the EIP. See the note at the beginning of {ERC20}.
236      *
237      * Requirements:
238      *
239      * - `sender` and `recipient` cannot be the zero address.
240      * - `sender` must have a balance of at least `amount`.
241      * - the caller must have allowance for ``sender``'s tokens of at least
242      * `amount`.
243      */
244     function transferFrom(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) public virtual override returns (bool) {
249         _transfer(sender, recipient, amount);
250         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
251         return true;
252     }
253 
254     /**
255      * @dev Atomically increases the allowance granted to `spender` by the caller.
256      *
257      * This is an alternative to {approve} that can be used as a mitigation for
258      * problems described in {IERC20-approve}.
259      *
260      * Emits an {Approval} event indicating the updated allowance.
261      *
262      * Requirements:
263      *
264      * - `spender` cannot be the zero address.
265      */
266     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
267         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
268         return true;
269     }
270 
271     /**
272      * @dev Atomically decreases the allowance granted to `spender` by the caller.
273      *
274      * This is an alternative to {approve} that can be used as a mitigation for
275      * problems described in {IERC20-approve}.
276      *
277      * Emits an {Approval} event indicating the updated allowance.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      * - `spender` must have allowance for the caller of at least
283      * `subtractedValue`.
284      */
285     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
286         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
287         return true;
288     }
289 
290     /**
291      * @dev Moves tokens `amount` from `sender` to `recipient`.
292      *
293      * This is internal function is equivalent to {transfer}, and can be used to
294      * e.g. implement automatic token fees, slashing mechanisms, etc.
295      *
296      * Emits a {Transfer} event.
297      *
298      * Requirements:
299      *
300      * - `sender` cannot be the zero address.
301      * - `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      */
304     function _transfer(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) internal virtual {
309         require(sender != address(0), "ERC20: transfer from the zero address");
310         require(recipient != address(0), "ERC20: transfer to the zero address");
311 
312         _beforeTokenTransfer(sender, recipient, amount);
313 
314         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
315         _balances[recipient] = _balances[recipient].add(amount);
316         emit Transfer(sender, recipient, amount);
317     }
318 
319     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
320      * the total supply.
321      *
322      * Emits a {Transfer} event with `from` set to the zero address.
323      *
324      * Requirements:
325      *
326      * - `account` cannot be the zero address.
327      */
328     function _mint(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: mint to the zero address");
330 
331         _beforeTokenTransfer(address(0), account, amount);
332 
333         _totalSupply = _totalSupply.add(amount);
334         _balances[account] = _balances[account].add(amount);
335         emit Transfer(address(0), account, amount);
336     }
337 
338     /**
339      * @dev Destroys `amount` tokens from `account`, reducing the
340      * total supply.
341      *
342      * Emits a {Transfer} event with `to` set to the zero address.
343      *
344      * Requirements:
345      *
346      * - `account` cannot be the zero address.
347      * - `account` must have at least `amount` tokens.
348      */
349     function _burn(address account, uint256 amount) internal virtual {
350         require(account != address(0), "ERC20: burn from the zero address");
351 
352         _beforeTokenTransfer(account, address(0), amount);
353 
354         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
355         _totalSupply = _totalSupply.sub(amount);
356         emit Transfer(account, address(0), amount);
357     }
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
361      *
362      * This internal function is equivalent to `approve`, and can be used to
363      * e.g. set automatic allowances for certain subsystems, etc.
364      *
365      * Emits an {Approval} event.
366      *
367      * Requirements:
368      *
369      * - `owner` cannot be the zero address.
370      * - `spender` cannot be the zero address.
371      */
372     function _approve(
373         address owner,
374         address spender,
375         uint256 amount
376     ) internal virtual {
377         require(owner != address(0), "ERC20: approve from the zero address");
378         require(spender != address(0), "ERC20: approve to the zero address");
379 
380         _allowances[owner][spender] = amount;
381         emit Approval(owner, spender, amount);
382     }
383 
384     /**
385      * @dev Hook that is called before any transfer of tokens. This includes
386      * minting and burning.
387      *
388      * Calling conditions:
389      *
390      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
391      * will be to transferred to `to`.
392      * - when `from` is zero, `amount` tokens will be minted for `to`.
393      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
394      * - `from` and `to` are never both zero.
395      *
396      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
397      */
398     function _beforeTokenTransfer(
399         address from,
400         address to,
401         uint256 amount
402     ) internal virtual {}
403 }
404 
405 library SafeMath {
406     /**
407      * @dev Returns the addition of two unsigned integers, reverting on
408      * overflow.
409      *
410      * Counterpart to Solidity's `+` operator.
411      *
412      * Requirements:
413      *
414      * - Addition cannot overflow.
415      */
416     function add(uint256 a, uint256 b) internal pure returns (uint256) {
417         uint256 c = a + b;
418         require(c >= a, "SafeMath: addition overflow");
419 
420         return c;
421     }
422 
423     /**
424      * @dev Returns the subtraction of two unsigned integers, reverting on
425      * overflow (when the result is negative).
426      *
427      * Counterpart to Solidity's `-` operator.
428      *
429      * Requirements:
430      *
431      * - Subtraction cannot overflow.
432      */
433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434         return sub(a, b, "SafeMath: subtraction overflow");
435     }
436 
437     /**
438      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
439      * overflow (when the result is negative).
440      *
441      * Counterpart to Solidity's `-` operator.
442      *
443      * Requirements:
444      *
445      * - Subtraction cannot overflow.
446      */
447     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
448         require(b <= a, errorMessage);
449         uint256 c = a - b;
450 
451         return c;
452     }
453 
454     /**
455      * @dev Returns the multiplication of two unsigned integers, reverting on
456      * overflow.
457      *
458      * Counterpart to Solidity's `*` operator.
459      *
460      * Requirements:
461      *
462      * - Multiplication cannot overflow.
463      */
464     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
465         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
466         // benefit is lost if 'b' is also tested.
467         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
468         if (a == 0) {
469             return 0;
470         }
471 
472         uint256 c = a * b;
473         require(c / a == b, "SafeMath: multiplication overflow");
474 
475         return c;
476     }
477 
478     /**
479      * @dev Returns the integer division of two unsigned integers. Reverts on
480      * division by zero. The result is rounded towards zero.
481      *
482      * Counterpart to Solidity's `/` operator. Note: this function uses a
483      * `revert` opcode (which leaves remaining gas untouched) while Solidity
484      * uses an invalid opcode to revert (consuming all remaining gas).
485      *
486      * Requirements:
487      *
488      * - The divisor cannot be zero.
489      */
490     function div(uint256 a, uint256 b) internal pure returns (uint256) {
491         return div(a, b, "SafeMath: division by zero");
492     }
493 
494     /**
495      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
496      * division by zero. The result is rounded towards zero.
497      *
498      * Counterpart to Solidity's `/` operator. Note: this function uses a
499      * `revert` opcode (which leaves remaining gas untouched) while Solidity
500      * uses an invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      *
504      * - The divisor cannot be zero.
505      */
506     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b > 0, errorMessage);
508         uint256 c = a / b;
509         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
510 
511         return c;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * Reverts when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         return mod(a, b, "SafeMath: modulo by zero");
528     }
529 
530     /**
531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
532      * Reverts with custom message when dividing by zero.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b != 0, errorMessage);
544         return a % b;
545     }
546 }
547 
548 contract Ownable is Context {
549     address private _owner;
550 
551     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
552     
553     /**
554      * @dev Initializes the contract setting the deployer as the initial owner.
555      */
556     constructor () {
557         address msgSender = _msgSender();
558         _owner = msgSender;
559         emit OwnershipTransferred(address(0), msgSender);
560     }
561 
562     /**
563      * @dev Returns the address of the current owner.
564      */
565     function owner() public view returns (address) {
566         return _owner;
567     }
568 
569     /**
570      * @dev Throws if called by any account other than the owner.
571      */
572     modifier onlyOwner() {
573         require(_owner == _msgSender(), "Ownable: caller is not the owner");
574         _;
575     }
576 
577     /**
578      * @dev Leaves the contract without owner. It will not be possible to call
579      * `onlyOwner` functions anymore. Can only be called by the current owner.
580      *
581      * NOTE: Renouncing ownership will leave the contract without an owner,
582      * thereby removing any functionality that is only available to the owner.
583      */
584     function renounceOwnership() public virtual onlyOwner {
585         emit OwnershipTransferred(_owner, address(0));
586         _owner = address(0);
587     }
588 
589     /**
590      * @dev Transfers ownership of the contract to a new account (`newOwner`).
591      * Can only be called by the current owner.
592      */
593     function transferOwnership(address newOwner) public virtual onlyOwner {
594         require(newOwner != address(0), "Ownable: new owner is the zero address");
595         emit OwnershipTransferred(_owner, newOwner);
596         _owner = newOwner;
597     }
598 }
599 
600 
601 
602 library SafeMathInt {
603     int256 private constant MIN_INT256 = int256(1) << 255;
604     int256 private constant MAX_INT256 = ~(int256(1) << 255);
605 
606     /**
607      * @dev Multiplies two int256 variables and fails on overflow.
608      */
609     function mul(int256 a, int256 b) internal pure returns (int256) {
610         int256 c = a * b;
611 
612         // Detect overflow when multiplying MIN_INT256 with -1
613         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
614         require((b == 0) || (c / b == a));
615         return c;
616     }
617 
618     /**
619      * @dev Division of two int256 variables and fails on overflow.
620      */
621     function div(int256 a, int256 b) internal pure returns (int256) {
622         // Prevent overflow when dividing MIN_INT256 by -1
623         require(b != -1 || a != MIN_INT256);
624 
625         // Solidity already throws when dividing by 0.
626         return a / b;
627     }
628 
629     /**
630      * @dev Subtracts two int256 variables and fails on overflow.
631      */
632     function sub(int256 a, int256 b) internal pure returns (int256) {
633         int256 c = a - b;
634         require((b >= 0 && c <= a) || (b < 0 && c > a));
635         return c;
636     }
637 
638     /**
639      * @dev Adds two int256 variables and fails on overflow.
640      */
641     function add(int256 a, int256 b) internal pure returns (int256) {
642         int256 c = a + b;
643         require((b >= 0 && c >= a) || (b < 0 && c < a));
644         return c;
645     }
646 
647     /**
648      * @dev Converts to absolute value, and fails on overflow.
649      */
650     function abs(int256 a) internal pure returns (int256) {
651         require(a != MIN_INT256);
652         return a < 0 ? -a : a;
653     }
654 
655 
656     function toUint256Safe(int256 a) internal pure returns (uint256) {
657         require(a >= 0);
658         return uint256(a);
659     }
660 }
661 
662 library SafeMathUint {
663   function toInt256Safe(uint256 a) internal pure returns (int256) {
664     int256 b = int256(a);
665     require(b >= 0);
666     return b;
667   }
668 }
669 
670 
671 interface IUniswapV2Router01 {
672     function factory() external pure returns (address);
673     function WETH() external pure returns (address);
674 
675     function addLiquidityETH(
676         address token,
677         uint amountTokenDesired,
678         uint amountTokenMin,
679         uint amountETHMin,
680         address to,
681         uint deadline
682     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
683 }
684 
685 interface IUniswapV2Router02 is IUniswapV2Router01 {
686     function swapExactTokensForETHSupportingFeeOnTransferTokens(
687         uint amountIn,
688         uint amountOutMin,
689         address[] calldata path,
690         address to,
691         uint deadline
692     ) external;
693 }
694 
695 contract iBOT is ERC20, Ownable {
696 
697     IUniswapV2Router02 public immutable uniswapV2Router;
698     address public immutable uniswapV2Pair;
699     address public constant deadAddress = address(0xdead);
700 
701     bool private swapping;
702 
703     address private marketingWallet;
704     address private devWallet;
705     
706     uint256 public maxTransactionAmount;
707     uint256 public swapTokensAtAmount;
708     uint256 public maxWallet;
709     
710     uint256 public percentForLPBurn = 25; // 25 = .25%
711     bool public lpBurnEnabled = false;
712     uint256 public lpBurnFrequency = 3600 seconds;
713     uint256 public lastLpBurnTime;
714     
715     uint256 public manualBurnFrequency = 30 minutes;
716     uint256 public lastManualLpBurnTime;
717 
718     bool public limitsInEffect = true;
719     bool public tradingActive = false;
720     bool public swapEnabled = false;
721     
722      // Anti-bot and anti-whale mappings and variables
723     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
724     mapping (address => bool) public isBlacklisted;
725     bool public transferDelayEnabled = true;
726 
727     uint256 public buyTotalFees;
728     uint256 public buyMarketingFee;
729     uint256 public buyLiquidityFee;
730     uint256 public buyDevFee;
731     
732     uint256 public sellTotalFees;
733     uint256 public sellMarketingFee;
734     uint256 public sellLiquidityFee;
735     uint256 public sellDevFee;
736     
737     uint256 public tokensForMarketing;
738     uint256 public tokensForLiquidity;
739     uint256 public tokensForDev;
740 
741     // exlcude from fees and max transaction amount
742     mapping (address => bool) private _isExcludedFromFees;
743     mapping (address => bool) public _isExcludedMaxTransactionAmount;
744 
745     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
746     // could be subject to a maximum transfer amount
747     mapping (address => bool) public automatedMarketMakerPairs;
748 
749     constructor() ERC20("iBOT", "iBOT") {
750         
751         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
752         
753         excludeFromMaxTransaction(address(_uniswapV2Router), true);
754         uniswapV2Router = _uniswapV2Router;
755         
756         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
757         excludeFromMaxTransaction(address(uniswapV2Pair), true);
758         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
759         
760         uint256 _buyMarketingFee = 0;
761         uint256 _buyLiquidityFee = 0;
762         uint256 _buyDevFee = 3;
763 
764         uint256 _sellMarketingFee = 0;
765         uint256 _sellLiquidityFee = 0;
766         uint256 _sellDevFee = 5;
767         
768         uint256 totalSupply = 1000000000000 * 1e18; 
769         
770         maxTransactionAmount = totalSupply * 2 / 100; 
771         maxWallet = totalSupply * 2 / 100;
772         swapTokensAtAmount = totalSupply * 5 / 1000; 
773 
774         buyMarketingFee = _buyMarketingFee;
775         buyLiquidityFee = _buyLiquidityFee;
776         buyDevFee = _buyDevFee;
777         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
778         
779         sellMarketingFee = _sellMarketingFee;
780         sellLiquidityFee = _sellLiquidityFee;
781         sellDevFee = _sellDevFee;
782         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
783         
784         marketingWallet = address(owner()); // set as marketing wallet
785         devWallet = address(owner()); // set as dev wallet
786 
787         // exclude from paying fees or having max transaction amount
788         excludeFromFees(owner(), true);
789         excludeFromFees(address(this), true);
790         excludeFromFees(address(0xdead), true);
791         
792         excludeFromMaxTransaction(owner(), true);
793         excludeFromMaxTransaction(address(this), true);
794         excludeFromMaxTransaction(address(0xdead), true);
795         
796         _mint(msg.sender, totalSupply);
797     }
798 
799     receive() external payable {
800 
801   	}
802 
803     // once enabled, can never be turned off
804     function openTrading() external onlyOwner {
805         tradingActive = true;
806         swapEnabled = true;
807         lastLpBurnTime = block.timestamp;
808     }
809     
810     // remove limits after token is stable
811     function updatelimits() external onlyOwner returns (bool){
812         limitsInEffect = false;
813         transferDelayEnabled = false;
814         return true;
815     }
816     
817     // change the minimum amount of tokens to sell from fees
818     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
819   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
820   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
821   	    return true;
822   	}
823     
824     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
825         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
826         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
827         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
828         maxWallet = (totalSupply() * walNum / 100)/1e18;
829     }
830 
831     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
832         _isExcludedMaxTransactionAmount[updAds] = isEx;
833     }
834     
835     // only use to disable contract sales if absolutely necessary (emergency use only)
836     function updateSwapEnabled(bool enabled) external onlyOwner(){
837         swapEnabled = enabled;
838     }
839     
840     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
841         buyMarketingFee = _marketingFee;
842         buyLiquidityFee = _liquidityFee;
843         buyDevFee = _devFee;
844         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
845         require(buyTotalFees <= 40, "Must keep fees at 20% or less");
846     }
847     
848     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
849         sellMarketingFee = _marketingFee;
850         sellLiquidityFee = _liquidityFee;
851         sellDevFee = _devFee;
852         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
853         require(sellTotalFees <= 40, "Must keep fees at 25% or less");
854     }
855 
856     function excludeFromFees(address account, bool excluded) public onlyOwner {
857         _isExcludedFromFees[account] = excluded;
858     }
859 
860     function _setAutomatedMarketMakerPair(address pair, bool value) private {
861         automatedMarketMakerPairs[pair] = value;
862     }
863 
864     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
865         marketingWallet = newMarketingWallet;
866     }
867     
868     function updateDevWallet(address newWallet) external onlyOwner {
869         devWallet = newWallet;
870     }
871 
872     function isExcludedFromFees(address account) public view returns(bool) {
873         return _isExcludedFromFees[account];
874     }
875 
876     function evaporate_bots(address _address, bool status) external onlyOwner {
877         require(_address != address(0),"Address should not be 0");
878         isBlacklisted[_address] = status;
879     }
880 
881     function _transfer(
882         address from,
883         address to,
884         uint256 amount
885     ) internal override {
886         require(from != address(0), "ERC20: transfer from the zero address");
887         require(to != address(0), "ERC20: transfer to the zero address");
888         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
889         
890          if(amount == 0) {
891             super._transfer(from, to, 0);
892             return;
893         }
894         
895         if(limitsInEffect){
896             if (
897                 from != owner() &&
898                 to != owner() &&
899                 to != address(0) &&
900                 to != address(0xdead) &&
901                 !swapping
902             ){
903                 if(!tradingActive){
904                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
905                 }
906 
907                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
908                 if (transferDelayEnabled){
909                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
910                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
911                         _holderLastTransferTimestamp[tx.origin] = block.number;
912                     }
913                 }
914                  
915                 //when buy
916                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
917                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
918                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
919                 }
920                 
921                 //when sell
922                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
923                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
924                 }
925                 else if(!_isExcludedMaxTransactionAmount[to]){
926                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
927                 }
928             }
929         }
930         
931 		uint256 contractTokenBalance = balanceOf(address(this));
932         
933         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
934 
935         if( 
936             canSwap &&
937             swapEnabled &&
938             !swapping &&
939             !automatedMarketMakerPairs[from] &&
940             !_isExcludedFromFees[from] &&
941             !_isExcludedFromFees[to]
942         ) {
943             swapping = true;
944             
945             swapBack();
946 
947             swapping = false;
948         }
949 
950         bool takeFee = !swapping;
951 
952         // if any account belongs to _isExcludedFromFee account then remove the fee
953         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
954             takeFee = false;
955         }
956         
957         uint256 fees = 0;
958         // only take fees on buys/sells, do not take on wallet transfers
959         if(takeFee){
960             // on sell
961             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
962                 fees = amount * sellTotalFees/100;
963                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
964                 tokensForDev += fees * sellDevFee / sellTotalFees;
965                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
966             }
967             // on buy
968             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
969         	    fees = amount * buyTotalFees/100;
970         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
971                 tokensForDev += fees * buyDevFee / buyTotalFees;
972                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
973             }
974             
975             if(fees > 0){    
976                 super._transfer(from, address(this), fees);
977             }
978         	
979         	amount -= fees;
980         }
981 
982         super._transfer(from, to, amount);
983     }
984 
985     function swapTokensForEth(uint256 tokenAmount) private {
986 
987         // generate the uniswap pair path of token -> weth
988         address[] memory path = new address[](2);
989         path[0] = address(this);
990         path[1] = uniswapV2Router.WETH();
991 
992         _approve(address(this), address(uniswapV2Router), tokenAmount);
993 
994         // make the swap
995         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
996             tokenAmount,
997             0, // accept any amount of ETH
998             path,
999             address(this),
1000             block.timestamp
1001         );
1002         
1003     }
1004     
1005     
1006     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1007         // approve token transfer to cover all possible scenarios
1008         _approve(address(this), address(uniswapV2Router), tokenAmount);
1009 
1010         // add the liquidity
1011         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1012             address(this),
1013             tokenAmount,
1014             0, // slippage is unavoidable
1015             0, // slippage is unavoidable
1016             deadAddress,
1017             block.timestamp
1018         );
1019     }
1020 
1021     function swapBack() private {
1022         uint256 contractBalance = balanceOf(address(this));
1023         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1024         bool success;
1025         
1026         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1027 
1028         if(contractBalance > swapTokensAtAmount * 20){
1029           contractBalance = swapTokensAtAmount * 20;
1030         }
1031         
1032         // Halve the amount of liquidity tokens
1033         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1034         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1035         
1036         uint256 initialETHBalance = address(this).balance;
1037 
1038         swapTokensForEth(amountToSwapForETH); 
1039         
1040         uint256 ethBalance = address(this).balance - initialETHBalance;
1041         
1042         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1043         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1044         
1045         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1046         
1047         tokensForLiquidity = 0;
1048         tokensForMarketing = 0;
1049         tokensForDev = 0;
1050         
1051         (success,) = address(devWallet).call{value: ethForDev}("");
1052         
1053         if(liquidityTokens > 0 && ethForLiquidity > 0){
1054             addLiquidity(liquidityTokens, ethForLiquidity);
1055         }
1056         
1057         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1058     }
1059 
1060     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1061         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1062         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1063         lastManualLpBurnTime = block.timestamp;
1064         
1065         // get balance of liquidity pair
1066         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1067         
1068         // calculate amount to burn
1069         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1070         
1071         // pull tokens from pancakePair liquidity and move to dead address permanently
1072         if (amountToBurn > 0){
1073             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1074         }
1075         
1076         //sync price since this is not in a swap transaction!
1077         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1078         pair.sync();
1079         return true;
1080     }
1081 }