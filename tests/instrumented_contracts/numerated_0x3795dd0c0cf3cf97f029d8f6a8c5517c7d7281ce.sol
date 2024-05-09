1 /**
2 
3 
4 ░██████╗░░█████╗░██╗░░░░░██████╗░██╗░░██╗░█████╗░
5 ██╔════╝░██╔══██╗██║░░░░░██╔══██╗██║░░██║██╔══██╗
6 ██║░░██╗░███████║██║░░░░░██████╔╝███████║███████║
7 ██║░░╚██╗██╔══██║██║░░░░░██╔═══╝░██╔══██║██╔══██║
8 ╚██████╔╝██║░░██║███████╗██║░░░░░██║░░██║██║░░██║
9 ░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝
10 
11 
12 TG: https://t.me/GAlphaETH
13 
14 */
15 
16 // SPDX-License-Identifier: MIT                                                                               
17                                                     
18 pragma solidity = 0.8.19;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 interface IUniswapV2Pair {
32     event Sync(uint112 reserve0, uint112 reserve1);
33     function sync() external;
34 }
35 
36 interface IUniswapV2Factory {
37     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
38 
39     function createPair(address tokenA, address tokenB) external returns (address pair);
40 }
41 
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 
135 contract ERC20 is Context, IERC20, IERC20Metadata {
136     using SafeMath for uint256;
137 
138     mapping(address => uint256) private _balances;
139 
140     mapping(address => mapping(address => uint256)) private _allowances;
141 
142     uint256 private _totalSupply;
143 
144     string private _name;
145     string private _symbol;
146 
147     /**
148      * @dev Sets the values for {name} and {symbol}.
149      *
150      * The default value of {decimals} is 18. To select a different value for
151      * {decimals} you should overload it.
152      *
153      * All two of these values are immutable: they can only be set once during
154      * construction.
155      */
156     constructor(string memory name_, string memory symbol_) {
157         _name = name_;
158         _symbol = symbol_;
159     }
160 
161     /**
162      * @dev Returns the name of the token.
163      */
164     function name() public view virtual override returns (string memory) {
165         return _name;
166     }
167 
168     /**
169      * @dev Returns the symbol of the token, usually a shorter version of the
170      * name.
171      */
172     function symbol() public view virtual override returns (string memory) {
173         return _symbol;
174     }
175 
176     /**
177      * @dev Returns the number of decimals used to get its user representation.
178      * For example, if `decimals` equals `2`, a balance of `505` tokens should
179      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
180      *
181      * Tokens usually opt for a value of 18, imitating the relationship between
182      * Ether and Wei. This is the value {ERC20} uses, unless this function is
183      * overridden;
184      *
185      * NOTE: This information is only used for _display_ purposes: it in
186      * no way affects any of the arithmetic of the contract, including
187      * {IERC20-balanceOf} and {IERC20-transfer}.
188      */
189     function decimals() public view virtual override returns (uint8) {
190         return 18;
191     }
192 
193     /**
194      * @dev See {IERC20-totalSupply}.
195      */
196     function totalSupply() public view virtual override returns (uint256) {
197         return _totalSupply;
198     }
199 
200     /**
201      * @dev See {IERC20-balanceOf}.
202      */
203     function balanceOf(address account) public view virtual override returns (uint256) {
204         return _balances[account];
205     }
206 
207     /**
208      * @dev See {IERC20-transfer}.
209      *
210      * Requirements:
211      *
212      * - `recipient` cannot be the zero address.
213      * - the caller must have a balance of at least `amount`.
214      */
215     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     /**
221      * @dev See {IERC20-allowance}.
222      */
223     function allowance(address owner, address spender) public view virtual override returns (uint256) {
224         return _allowances[owner][spender];
225     }
226 
227     /**
228      * @dev See {IERC20-approve}.
229      *
230      * Requirements:
231      *
232      * - `spender` cannot be the zero address.
233      */
234     function approve(address spender, uint256 amount) public virtual override returns (bool) {
235         _approve(_msgSender(), spender, amount);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-transferFrom}.
241      *
242      * Emits an {Approval} event indicating the updated allowance. This is not
243      * required by the EIP. See the note at the beginning of {ERC20}.
244      *
245      * Requirements:
246      *
247      * - `sender` and `recipient` cannot be the zero address.
248      * - `sender` must have a balance of at least `amount`.
249      * - the caller must have allowance for ``sender``'s tokens of at least
250      * `amount`.
251      */
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public virtual override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
259         return true;
260     }
261 
262     /**
263      * @dev Atomically increases the allowance granted to `spender` by the caller.
264      *
265      * This is an alternative to {approve} that can be used as a mitigation for
266      * problems described in {IERC20-approve}.
267      *
268      * Emits an {Approval} event indicating the updated allowance.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
275         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
276         return true;
277     }
278 
279     /**
280      * @dev Atomically decreases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to {approve} that can be used as a mitigation for
283      * problems described in {IERC20-approve}.
284      *
285      * Emits an {Approval} event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      * - `spender` must have allowance for the caller of at least
291      * `subtractedValue`.
292      */
293     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
295         return true;
296     }
297 
298     /**
299      * @dev Moves tokens `amount` from `sender` to `recipient`.
300      *
301      * This is internal function is equivalent to {transfer}, and can be used to
302      * e.g. implement automatic token fees, slashing mechanisms, etc.
303      *
304      * Emits a {Transfer} event.
305      *
306      * Requirements:
307      *
308      * - `sender` cannot be the zero address.
309      * - `recipient` cannot be the zero address.
310      * - `sender` must have a balance of at least `amount`.
311      */
312     function _transfer(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) internal virtual {
317         require(sender != address(0), "ERC20: transfer from the zero address");
318         require(recipient != address(0), "ERC20: transfer to the zero address");
319 
320         _beforeTokenTransfer(sender, recipient, amount);
321 
322         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
323         _balances[recipient] = _balances[recipient].add(amount);
324         emit Transfer(sender, recipient, amount);
325     }
326 
327     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
328      * the total supply.
329      *
330      * Emits a {Transfer} event with `from` set to the zero address.
331      *
332      * Requirements:
333      *
334      * - `account` cannot be the zero address.
335      */
336     function _mint(address account, uint256 amount) internal virtual {
337         require(account != address(0), "ERC20: mint to the zero address");
338 
339         _beforeTokenTransfer(address(0), account, amount);
340 
341         _totalSupply = _totalSupply.add(amount);
342         _balances[account] = _balances[account].add(amount);
343         emit Transfer(address(0), account, amount);
344     }
345 
346     /**
347      * @dev Destroys `amount` tokens from `account`, reducing the
348      * total supply.
349      *
350      * Emits a {Transfer} event with `to` set to the zero address.
351      *
352      * Requirements:
353      *
354      * - `account` cannot be the zero address.
355      * - `account` must have at least `amount` tokens.
356      */
357     function _burn(address account, uint256 amount) internal virtual {
358         require(account != address(0), "ERC20: burn from the zero address");
359 
360         _beforeTokenTransfer(account, address(0), amount);
361 
362         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
363         _totalSupply = _totalSupply.sub(amount);
364         emit Transfer(account, address(0), amount);
365     }
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
369      *
370      * This internal function is equivalent to `approve`, and can be used to
371      * e.g. set automatic allowances for certain subsystems, etc.
372      *
373      * Emits an {Approval} event.
374      *
375      * Requirements:
376      *
377      * - `owner` cannot be the zero address.
378      * - `spender` cannot be the zero address.
379      */
380     function _approve(
381         address owner,
382         address spender,
383         uint256 amount
384     ) internal virtual {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387 
388         _allowances[owner][spender] = amount;
389         emit Approval(owner, spender, amount);
390     }
391 
392     /**
393      * @dev Hook that is called before any transfer of tokens. This includes
394      * minting and burning.
395      *
396      * Calling conditions:
397      *
398      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
399      * will be to transferred to `to`.
400      * - when `from` is zero, `amount` tokens will be minted for `to`.
401      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
402      * - `from` and `to` are never both zero.
403      *
404      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
405      */
406     function _beforeTokenTransfer(
407         address from,
408         address to,
409         uint256 amount
410     ) internal virtual {}
411 }
412 
413 library SafeMath {
414     /**
415      * @dev Returns the addition of two unsigned integers, reverting on
416      * overflow.
417      *
418      * Counterpart to Solidity's `+` operator.
419      *
420      * Requirements:
421      *
422      * - Addition cannot overflow.
423      */
424     function add(uint256 a, uint256 b) internal pure returns (uint256) {
425         uint256 c = a + b;
426         require(c >= a, "SafeMath: addition overflow");
427 
428         return c;
429     }
430 
431     /**
432      * @dev Returns the subtraction of two unsigned integers, reverting on
433      * overflow (when the result is negative).
434      *
435      * Counterpart to Solidity's `-` operator.
436      *
437      * Requirements:
438      *
439      * - Subtraction cannot overflow.
440      */
441     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
442         return sub(a, b, "SafeMath: subtraction overflow");
443     }
444 
445     /**
446      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
447      * overflow (when the result is negative).
448      *
449      * Counterpart to Solidity's `-` operator.
450      *
451      * Requirements:
452      *
453      * - Subtraction cannot overflow.
454      */
455     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
456         require(b <= a, errorMessage);
457         uint256 c = a - b;
458 
459         return c;
460     }
461 
462     /**
463      * @dev Returns the multiplication of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `*` operator.
467      *
468      * Requirements:
469      *
470      * - Multiplication cannot overflow.
471      */
472     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
473         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
474         // benefit is lost if 'b' is also tested.
475         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
476         if (a == 0) {
477             return 0;
478         }
479 
480         uint256 c = a * b;
481         require(c / a == b, "SafeMath: multiplication overflow");
482 
483         return c;
484     }
485 
486     /**
487      * @dev Returns the integer division of two unsigned integers. Reverts on
488      * division by zero. The result is rounded towards zero.
489      *
490      * Counterpart to Solidity's `/` operator. Note: this function uses a
491      * `revert` opcode (which leaves remaining gas untouched) while Solidity
492      * uses an invalid opcode to revert (consuming all remaining gas).
493      *
494      * Requirements:
495      *
496      * - The divisor cannot be zero.
497      */
498     function div(uint256 a, uint256 b) internal pure returns (uint256) {
499         return div(a, b, "SafeMath: division by zero");
500     }
501 
502     /**
503      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
504      * division by zero. The result is rounded towards zero.
505      *
506      * Counterpart to Solidity's `/` operator. Note: this function uses a
507      * `revert` opcode (which leaves remaining gas untouched) while Solidity
508      * uses an invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      *
512      * - The divisor cannot be zero.
513      */
514     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         require(b > 0, errorMessage);
516         uint256 c = a / b;
517         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
518 
519         return c;
520     }
521 
522     /**
523      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
524      * Reverts when dividing by zero.
525      *
526      * Counterpart to Solidity's `%` operator. This function uses a `revert`
527      * opcode (which leaves remaining gas untouched) while Solidity uses an
528      * invalid opcode to revert (consuming all remaining gas).
529      *
530      * Requirements:
531      *
532      * - The divisor cannot be zero.
533      */
534     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
535         return mod(a, b, "SafeMath: modulo by zero");
536     }
537 
538     /**
539      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
540      * Reverts with custom message when dividing by zero.
541      *
542      * Counterpart to Solidity's `%` operator. This function uses a `revert`
543      * opcode (which leaves remaining gas untouched) while Solidity uses an
544      * invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
551         require(b != 0, errorMessage);
552         return a % b;
553     }
554 }
555 
556 contract Ownable is Context {
557     address private _owner;
558 
559     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
560     
561     /**
562      * @dev Initializes the contract setting the deployer as the initial owner.
563      */
564     constructor () {
565         address msgSender = _msgSender();
566         _owner = msgSender;
567         emit OwnershipTransferred(address(0), msgSender);
568     }
569 
570     /**
571      * @dev Returns the address of the current owner.
572      */
573     function owner() public view returns (address) {
574         return _owner;
575     }
576 
577     /**
578      * @dev Throws if called by any account other than the owner.
579      */
580     modifier onlyOwner() {
581         require(_owner == _msgSender(), "Ownable: caller is not the owner");
582         _;
583     }
584 
585     /**
586      * @dev Leaves the contract without owner. It will not be possible to call
587      * `onlyOwner` functions anymore. Can only be called by the current owner.
588      *
589      * NOTE: Renouncing ownership will leave the contract without an owner,
590      * thereby removing any functionality that is only available to the owner.
591      */
592     function renounceOwnership() public virtual onlyOwner {
593         emit OwnershipTransferred(_owner, address(0));
594         _owner = address(0);
595     }
596 
597     /**
598      * @dev Transfers ownership of the contract to a new account (`newOwner`).
599      * Can only be called by the current owner.
600      */
601     function transferOwnership(address newOwner) public virtual onlyOwner {
602         require(newOwner != address(0), "Ownable: new owner is the zero address");
603         emit OwnershipTransferred(_owner, newOwner);
604         _owner = newOwner;
605     }
606 }
607 
608 
609 
610 library SafeMathInt {
611     int256 private constant MIN_INT256 = int256(1) << 255;
612     int256 private constant MAX_INT256 = ~(int256(1) << 255);
613 
614     /**
615      * @dev Multiplies two int256 variables and fails on overflow.
616      */
617     function mul(int256 a, int256 b) internal pure returns (int256) {
618         int256 c = a * b;
619 
620         // Detect overflow when multiplying MIN_INT256 with -1
621         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
622         require((b == 0) || (c / b == a));
623         return c;
624     }
625 
626     /**
627      * @dev Division of two int256 variables and fails on overflow.
628      */
629     function div(int256 a, int256 b) internal pure returns (int256) {
630         // Prevent overflow when dividing MIN_INT256 by -1
631         require(b != -1 || a != MIN_INT256);
632 
633         // Solidity already throws when dividing by 0.
634         return a / b;
635     }
636 
637     /**
638      * @dev Subtracts two int256 variables and fails on overflow.
639      */
640     function sub(int256 a, int256 b) internal pure returns (int256) {
641         int256 c = a - b;
642         require((b >= 0 && c <= a) || (b < 0 && c > a));
643         return c;
644     }
645 
646     /**
647      * @dev Adds two int256 variables and fails on overflow.
648      */
649     function add(int256 a, int256 b) internal pure returns (int256) {
650         int256 c = a + b;
651         require((b >= 0 && c >= a) || (b < 0 && c < a));
652         return c;
653     }
654 
655     /**
656      * @dev Converts to absolute value, and fails on overflow.
657      */
658     function abs(int256 a) internal pure returns (int256) {
659         require(a != MIN_INT256);
660         return a < 0 ? -a : a;
661     }
662 
663 
664     function toUint256Safe(int256 a) internal pure returns (uint256) {
665         require(a >= 0);
666         return uint256(a);
667     }
668 }
669 
670 library SafeMathUint {
671   function toInt256Safe(uint256 a) internal pure returns (int256) {
672     int256 b = int256(a);
673     require(b >= 0);
674     return b;
675   }
676 }
677 
678 
679 interface IUniswapV2Router01 {
680     function factory() external pure returns (address);
681     function WETH() external pure returns (address);
682 
683     function addLiquidityETH(
684         address token,
685         uint amountTokenDesired,
686         uint amountTokenMin,
687         uint amountETHMin,
688         address to,
689         uint deadline
690     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
691 }
692 
693 interface IUniswapV2Router02 is IUniswapV2Router01 {
694     function swapExactTokensForETHSupportingFeeOnTransferTokens(
695         uint amountIn,
696         uint amountOutMin,
697         address[] calldata path,
698         address to,
699         uint deadline
700     ) external;
701 }
702 
703 contract GALPHA is ERC20, Ownable {
704 
705     IUniswapV2Router02 public immutable uniswapV2Router;
706     address public immutable uniswapV2Pair;
707     address public constant deadAddress = address(0xdead);
708 
709     bool private swapping;
710 
711     address public marketingWallet;
712     address public devWallet;
713     
714     uint256 public maxTransactionAmount;
715     uint256 public swapTokensAtAmount;
716     uint256 public maxWallet;
717     
718     uint256 public percentForLPBurn = 25; // 25 = .25%
719     bool public lpBurnEnabled = false;
720     uint256 public lpBurnFrequency = 3600 seconds;
721     uint256 public lastLpBurnTime;
722     
723     uint256 public manualBurnFrequency = 30 minutes;
724     uint256 public lastManualLpBurnTime;
725 
726     bool public limitsInEffect = true;
727     bool public tradingActive = false;
728     bool public swapEnabled = false;
729     
730      // Anti-bot and anti-whale mappings and variables
731     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
732     mapping (address => bool) public isBlacklisted;
733     bool public transferDelayEnabled = true;
734 
735     uint256 public buyTotalFees;
736     uint256 public buyMarketingFee;
737     uint256 public buyLiquidityFee;
738     uint256 public buyDevFee;
739     
740     uint256 public sellTotalFees;
741     uint256 public sellMarketingFee;
742     uint256 public sellLiquidityFee;
743     uint256 public sellDevFee;
744     
745     uint256 public tokensForMarketing;
746     uint256 public tokensForLiquidity;
747     uint256 public tokensForDev;
748 
749     // exlcude from fees and max transaction amount
750     mapping (address => bool) private _isExcludedFromFees;
751     mapping (address => bool) public _isExcludedMaxTransactionAmount;
752 
753     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
754     // could be subject to a maximum transfer amount
755     mapping (address => bool) public automatedMarketMakerPairs;
756 
757     constructor() ERC20("Generation Alpha", "GALPHA") {
758         
759         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
760         
761         excludeFromMaxTransaction(address(_uniswapV2Router), true);
762         uniswapV2Router = _uniswapV2Router;
763         
764         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
765         excludeFromMaxTransaction(address(uniswapV2Pair), true);
766         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
767         
768         uint256 _buyMarketingFee = 0;
769         uint256 _buyLiquidityFee = 0;
770         uint256 _buyDevFee = 25;
771 
772         uint256 _sellMarketingFee = 0;
773         uint256 _sellLiquidityFee = 0;
774         uint256 _sellDevFee = 35;
775         
776         uint256 totalSupply = 1000000000000 * 1e18; 
777         
778         maxTransactionAmount = totalSupply * 2 / 100; // 1% maxTransactionAmountTxn
779         maxWallet = totalSupply * 2 / 100; // 1% maxWallet
780         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
781 
782         buyMarketingFee = _buyMarketingFee;
783         buyLiquidityFee = _buyLiquidityFee;
784         buyDevFee = _buyDevFee;
785         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
786         
787         sellMarketingFee = _sellMarketingFee;
788         sellLiquidityFee = _sellLiquidityFee;
789         sellDevFee = _sellDevFee;
790         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
791         
792         marketingWallet = address(owner()); // set as marketing wallet
793         devWallet = address(owner()); // set as dev wallet
794 
795         // exclude from paying fees or having max transaction amount
796         excludeFromFees(owner(), true);
797         excludeFromFees(address(this), true);
798         excludeFromFees(address(0xdead), true);
799         
800         excludeFromMaxTransaction(owner(), true);
801         excludeFromMaxTransaction(address(this), true);
802         excludeFromMaxTransaction(address(0xdead), true);
803         
804         _mint(msg.sender, totalSupply);
805     }
806 
807     receive() external payable {
808 
809   	}
810 
811     // once enabled, can never be turned off
812     function openTrading() external onlyOwner {
813         tradingActive = true;
814         swapEnabled = true;
815         lastLpBurnTime = block.timestamp;
816     }
817     
818     // remove limits after token is stable
819     function removealphalimits() external onlyOwner returns (bool){
820         limitsInEffect = false;
821         transferDelayEnabled = false;
822         return true;
823     }
824     
825     // change the minimum amount of tokens to sell from fees
826     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
827   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
828   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
829   	    return true;
830   	}
831     
832     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
833         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
834         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
835         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
836         maxWallet = (totalSupply() * walNum / 100)/1e18;
837     }
838 
839     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
840         _isExcludedMaxTransactionAmount[updAds] = isEx;
841     }
842     
843     // only use to disable contract sales if absolutely necessary (emergency use only)
844     function updateSwapEnabled(bool enabled) external onlyOwner(){
845         swapEnabled = enabled;
846     }
847     
848     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
849         buyMarketingFee = _marketingFee;
850         buyLiquidityFee = _liquidityFee;
851         buyDevFee = _devFee;
852         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
853         require(buyTotalFees <= 40, "Must keep fees at 20% or less");
854     }
855     
856     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
857         sellMarketingFee = _marketingFee;
858         sellLiquidityFee = _liquidityFee;
859         sellDevFee = _devFee;
860         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
861         require(sellTotalFees <= 40, "Must keep fees at 25% or less");
862     }
863 
864     function excludeFromFees(address account, bool excluded) public onlyOwner {
865         _isExcludedFromFees[account] = excluded;
866     }
867 
868     function _setAutomatedMarketMakerPair(address pair, bool value) private {
869         automatedMarketMakerPairs[pair] = value;
870     }
871 
872     function updateMarketingWalletinformation(address newMarketingWallet) external onlyOwner {
873         marketingWallet = newMarketingWallet;
874     }
875     
876     function updateDevWalletinformation(address newWallet) external onlyOwner {
877         devWallet = newWallet;
878     }
879 
880     function isExcludedFromFees(address account) public view returns(bool) {
881         return _isExcludedFromFees[account];
882     }
883 
884     function managealpha_bots(address _address, bool status) external onlyOwner {
885         require(_address != address(0),"Address should not be 0");
886         isBlacklisted[_address] = status;
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
898          if(amount == 0) {
899             super._transfer(from, to, 0);
900             return;
901         }
902         
903         if(limitsInEffect){
904             if (
905                 from != owner() &&
906                 to != owner() &&
907                 to != address(0) &&
908                 to != address(0xdead) &&
909                 !swapping
910             ){
911                 if(!tradingActive){
912                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
913                 }
914 
915                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
916                 if (transferDelayEnabled){
917                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
918                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
919                         _holderLastTransferTimestamp[tx.origin] = block.number;
920                     }
921                 }
922                  
923                 //when buy
924                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
925                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
926                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
927                 }
928                 
929                 //when sell
930                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
931                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
932                 }
933                 else if(!_isExcludedMaxTransactionAmount[to]){
934                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
935                 }
936             }
937         }
938         
939 		uint256 contractTokenBalance = balanceOf(address(this));
940         
941         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
942 
943         if( 
944             canSwap &&
945             swapEnabled &&
946             !swapping &&
947             !automatedMarketMakerPairs[from] &&
948             !_isExcludedFromFees[from] &&
949             !_isExcludedFromFees[to]
950         ) {
951             swapping = true;
952             
953             swapBack();
954 
955             swapping = false;
956         }
957 
958         bool takeFee = !swapping;
959 
960         // if any account belongs to _isExcludedFromFee account then remove the fee
961         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
962             takeFee = false;
963         }
964         
965         uint256 fees = 0;
966         // only take fees on buys/sells, do not take on wallet transfers
967         if(takeFee){
968             // on sell
969             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
970                 fees = amount * sellTotalFees/100;
971                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
972                 tokensForDev += fees * sellDevFee / sellTotalFees;
973                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
974             }
975             // on buy
976             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
977         	    fees = amount * buyTotalFees/100;
978         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
979                 tokensForDev += fees * buyDevFee / buyTotalFees;
980                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
981             }
982             
983             if(fees > 0){    
984                 super._transfer(from, address(this), fees);
985             }
986         	
987         	amount -= fees;
988         }
989 
990         super._transfer(from, to, amount);
991     }
992 
993     function swapTokensForEth(uint256 tokenAmount) private {
994 
995         // generate the uniswap pair path of token -> weth
996         address[] memory path = new address[](2);
997         path[0] = address(this);
998         path[1] = uniswapV2Router.WETH();
999 
1000         _approve(address(this), address(uniswapV2Router), tokenAmount);
1001 
1002         // make the swap
1003         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1004             tokenAmount,
1005             0, // accept any amount of ETH
1006             path,
1007             address(this),
1008             block.timestamp
1009         );
1010         
1011     }
1012     
1013     
1014     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1015         // approve token transfer to cover all possible scenarios
1016         _approve(address(this), address(uniswapV2Router), tokenAmount);
1017 
1018         // add the liquidity
1019         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1020             address(this),
1021             tokenAmount,
1022             0, // slippage is unavoidable
1023             0, // slippage is unavoidable
1024             deadAddress,
1025             block.timestamp
1026         );
1027     }
1028 
1029     function swapBack() private {
1030         uint256 contractBalance = balanceOf(address(this));
1031         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1032         bool success;
1033         
1034         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1035 
1036         if(contractBalance > swapTokensAtAmount * 20){
1037           contractBalance = swapTokensAtAmount * 20;
1038         }
1039         
1040         // Halve the amount of liquidity tokens
1041         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1042         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1043         
1044         uint256 initialETHBalance = address(this).balance;
1045 
1046         swapTokensForEth(amountToSwapForETH); 
1047         
1048         uint256 ethBalance = address(this).balance - initialETHBalance;
1049         
1050         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1051         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1052         
1053         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1054         
1055         tokensForLiquidity = 0;
1056         tokensForMarketing = 0;
1057         tokensForDev = 0;
1058         
1059         (success,) = address(devWallet).call{value: ethForDev}("");
1060         
1061         if(liquidityTokens > 0 && ethForLiquidity > 0){
1062             addLiquidity(liquidityTokens, ethForLiquidity);
1063         }
1064         
1065         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1066     }
1067 
1068     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1069         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1070         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1071         lastManualLpBurnTime = block.timestamp;
1072         
1073         // get balance of liquidity pair
1074         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1075         
1076         // calculate amount to burn
1077         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1078         
1079         // pull tokens from pancakePair liquidity and move to dead address permanently
1080         if (amountToBurn > 0){
1081             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1082         }
1083         
1084         //sync price since this is not in a swap transaction!
1085         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1086         pair.sync();
1087         return true;
1088     }
1089 }