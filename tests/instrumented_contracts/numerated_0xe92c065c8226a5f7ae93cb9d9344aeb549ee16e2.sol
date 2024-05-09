1 /**
2 
3 https://www.DontSellInu.Net/
4 https://twitter.com/DontSellInu
5 https://t.me/DSIeth
6 
7 
8 ██████╗░░█████╗░███╗░░██╗████████╗  ░██████╗███████╗██╗░░░░░██╗░░░░░
9 ██╔══██╗██╔══██╗████╗░██║╚══██╔══╝  ██╔════╝██╔════╝██║░░░░░██║░░░░░
10 ██║░░██║██║░░██║██╔██╗██║░░░██║░░░  ╚█████╗░█████╗░░██║░░░░░██║░░░░░
11 ██║░░██║██║░░██║██║╚████║░░░██║░░░  ░╚═══██╗██╔══╝░░██║░░░░░██║░░░░░
12 ██████╔╝╚█████╔╝██║░╚███║░░░██║░░░  ██████╔╝███████╗███████╗███████╗
13 ╚═════╝░░╚════╝░╚═╝░░╚══╝░░░╚═╝░░░  ╚═════╝░╚══════╝╚══════╝╚══════╝
14 
15 
16 */
17 
18 
19 // SPDX-License-Identifier: MIT                                                                               
20                                                     
21 pragma solidity = 0.8.19;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IUniswapV2Pair {
35     event Sync(uint112 reserve0, uint112 reserve1);
36     function sync() external;
37 }
38 
39 interface IUniswapV2Factory {
40     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
41 
42     function createPair(address tokenA, address tokenB) external returns (address pair);
43 }
44 
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 interface IERC20Metadata is IERC20 {
121     /**
122      * @dev Returns the name of the token.
123      */
124     function name() external view returns (string memory);
125 
126     /**
127      * @dev Returns the symbol of the token.
128      */
129     function symbol() external view returns (string memory);
130 
131     /**
132      * @dev Returns the decimals places of the token.
133      */
134     function decimals() external view returns (uint8);
135 }
136 
137 
138 contract ERC20 is Context, IERC20, IERC20Metadata {
139     using SafeMath for uint256;
140 
141     mapping(address => uint256) private _balances;
142 
143     mapping(address => mapping(address => uint256)) private _allowances;
144 
145     uint256 private _totalSupply;
146 
147     string private _name;
148     string private _symbol;
149 
150     /**
151      * @dev Sets the values for {name} and {symbol}.
152      *
153      * The default value of {decimals} is 18. To select a different value for
154      * {decimals} you should overload it.
155      *
156      * All two of these values are immutable: they can only be set once during
157      * construction.
158      */
159     constructor(string memory name_, string memory symbol_) {
160         _name = name_;
161         _symbol = symbol_;
162     }
163 
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() public view virtual override returns (string memory) {
168         return _name;
169     }
170 
171     /**
172      * @dev Returns the symbol of the token, usually a shorter version of the
173      * name.
174      */
175     function symbol() public view virtual override returns (string memory) {
176         return _symbol;
177     }
178 
179     /**
180      * @dev Returns the number of decimals used to get its user representation.
181      * For example, if `decimals` equals `2`, a balance of `505` tokens should
182      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
183      *
184      * Tokens usually opt for a value of 18, imitating the relationship between
185      * Ether and Wei. This is the value {ERC20} uses, unless this function is
186      * overridden;
187      *
188      * NOTE: This information is only used for _display_ purposes: it in
189      * no way affects any of the arithmetic of the contract, including
190      * {IERC20-balanceOf} and {IERC20-transfer}.
191      */
192     function decimals() public view virtual override returns (uint8) {
193         return 18;
194     }
195 
196     /**
197      * @dev See {IERC20-totalSupply}.
198      */
199     function totalSupply() public view virtual override returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204      * @dev See {IERC20-balanceOf}.
205      */
206     function balanceOf(address account) public view virtual override returns (uint256) {
207         return _balances[account];
208     }
209 
210     /**
211      * @dev See {IERC20-transfer}.
212      *
213      * Requirements:
214      *
215      * - `recipient` cannot be the zero address.
216      * - the caller must have a balance of at least `amount`.
217      */
218     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     /**
224      * @dev See {IERC20-allowance}.
225      */
226     function allowance(address owner, address spender) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(address spender, uint256 amount) public virtual override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-transferFrom}.
244      *
245      * Emits an {Approval} event indicating the updated allowance. This is not
246      * required by the EIP. See the note at the beginning of {ERC20}.
247      *
248      * Requirements:
249      *
250      * - `sender` and `recipient` cannot be the zero address.
251      * - `sender` must have a balance of at least `amount`.
252      * - the caller must have allowance for ``sender``'s tokens of at least
253      * `amount`.
254      */
255     function transferFrom(
256         address sender,
257         address recipient,
258         uint256 amount
259     ) public virtual override returns (bool) {
260         _transfer(sender, recipient, amount);
261         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
262         return true;
263     }
264 
265     /**
266      * @dev Atomically increases the allowance granted to `spender` by the caller.
267      *
268      * This is an alternative to {approve} that can be used as a mitigation for
269      * problems described in {IERC20-approve}.
270      *
271      * Emits an {Approval} event indicating the updated allowance.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
279         return true;
280     }
281 
282     /**
283      * @dev Atomically decreases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to {approve} that can be used as a mitigation for
286      * problems described in {IERC20-approve}.
287      *
288      * Emits an {Approval} event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      * - `spender` must have allowance for the caller of at least
294      * `subtractedValue`.
295      */
296     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
297         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
298         return true;
299     }
300 
301     /**
302      * @dev Moves tokens `amount` from `sender` to `recipient`.
303      *
304      * This is internal function is equivalent to {transfer}, and can be used to
305      * e.g. implement automatic token fees, slashing mechanisms, etc.
306      *
307      * Emits a {Transfer} event.
308      *
309      * Requirements:
310      *
311      * - `sender` cannot be the zero address.
312      * - `recipient` cannot be the zero address.
313      * - `sender` must have a balance of at least `amount`.
314      */
315     function _transfer(
316         address sender,
317         address recipient,
318         uint256 amount
319     ) internal virtual {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322 
323         _beforeTokenTransfer(sender, recipient, amount);
324 
325         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
326         _balances[recipient] = _balances[recipient].add(amount);
327         emit Transfer(sender, recipient, amount);
328     }
329 
330     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
331      * the total supply.
332      *
333      * Emits a {Transfer} event with `from` set to the zero address.
334      *
335      * Requirements:
336      *
337      * - `account` cannot be the zero address.
338      */
339     function _mint(address account, uint256 amount) internal virtual {
340         require(account != address(0), "ERC20: mint to the zero address");
341 
342         _beforeTokenTransfer(address(0), account, amount);
343 
344         _totalSupply = _totalSupply.add(amount);
345         _balances[account] = _balances[account].add(amount);
346         emit Transfer(address(0), account, amount);
347     }
348 
349     /**
350      * @dev Destroys `amount` tokens from `account`, reducing the
351      * total supply.
352      *
353      * Emits a {Transfer} event with `to` set to the zero address.
354      *
355      * Requirements:
356      *
357      * - `account` cannot be the zero address.
358      * - `account` must have at least `amount` tokens.
359      */
360     function _burn(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: burn from the zero address");
362 
363         _beforeTokenTransfer(account, address(0), amount);
364 
365         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
366         _totalSupply = _totalSupply.sub(amount);
367         emit Transfer(account, address(0), amount);
368     }
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
372      *
373      * This internal function is equivalent to `approve`, and can be used to
374      * e.g. set automatic allowances for certain subsystems, etc.
375      *
376      * Emits an {Approval} event.
377      *
378      * Requirements:
379      *
380      * - `owner` cannot be the zero address.
381      * - `spender` cannot be the zero address.
382      */
383     function _approve(
384         address owner,
385         address spender,
386         uint256 amount
387     ) internal virtual {
388         require(owner != address(0), "ERC20: approve from the zero address");
389         require(spender != address(0), "ERC20: approve to the zero address");
390 
391         _allowances[owner][spender] = amount;
392         emit Approval(owner, spender, amount);
393     }
394 
395     /**
396      * @dev Hook that is called before any transfer of tokens. This includes
397      * minting and burning.
398      *
399      * Calling conditions:
400      *
401      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
402      * will be to transferred to `to`.
403      * - when `from` is zero, `amount` tokens will be minted for `to`.
404      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
405      * - `from` and `to` are never both zero.
406      *
407      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
408      */
409     function _beforeTokenTransfer(
410         address from,
411         address to,
412         uint256 amount
413     ) internal virtual {}
414 }
415 
416 library SafeMath {
417     /**
418      * @dev Returns the addition of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `+` operator.
422      *
423      * Requirements:
424      *
425      * - Addition cannot overflow.
426      */
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         uint256 c = a + b;
429         require(c >= a, "SafeMath: addition overflow");
430 
431         return c;
432     }
433 
434     /**
435      * @dev Returns the subtraction of two unsigned integers, reverting on
436      * overflow (when the result is negative).
437      *
438      * Counterpart to Solidity's `-` operator.
439      *
440      * Requirements:
441      *
442      * - Subtraction cannot overflow.
443      */
444     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
445         return sub(a, b, "SafeMath: subtraction overflow");
446     }
447 
448     /**
449      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
450      * overflow (when the result is negative).
451      *
452      * Counterpart to Solidity's `-` operator.
453      *
454      * Requirements:
455      *
456      * - Subtraction cannot overflow.
457      */
458     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
459         require(b <= a, errorMessage);
460         uint256 c = a - b;
461 
462         return c;
463     }
464 
465     /**
466      * @dev Returns the multiplication of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `*` operator.
470      *
471      * Requirements:
472      *
473      * - Multiplication cannot overflow.
474      */
475     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
476         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
477         // benefit is lost if 'b' is also tested.
478         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
479         if (a == 0) {
480             return 0;
481         }
482 
483         uint256 c = a * b;
484         require(c / a == b, "SafeMath: multiplication overflow");
485 
486         return c;
487     }
488 
489     /**
490      * @dev Returns the integer division of two unsigned integers. Reverts on
491      * division by zero. The result is rounded towards zero.
492      *
493      * Counterpart to Solidity's `/` operator. Note: this function uses a
494      * `revert` opcode (which leaves remaining gas untouched) while Solidity
495      * uses an invalid opcode to revert (consuming all remaining gas).
496      *
497      * Requirements:
498      *
499      * - The divisor cannot be zero.
500      */
501     function div(uint256 a, uint256 b) internal pure returns (uint256) {
502         return div(a, b, "SafeMath: division by zero");
503     }
504 
505     /**
506      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
507      * division by zero. The result is rounded towards zero.
508      *
509      * Counterpart to Solidity's `/` operator. Note: this function uses a
510      * `revert` opcode (which leaves remaining gas untouched) while Solidity
511      * uses an invalid opcode to revert (consuming all remaining gas).
512      *
513      * Requirements:
514      *
515      * - The divisor cannot be zero.
516      */
517     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
518         require(b > 0, errorMessage);
519         uint256 c = a / b;
520         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
521 
522         return c;
523     }
524 
525     /**
526      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
527      * Reverts when dividing by zero.
528      *
529      * Counterpart to Solidity's `%` operator. This function uses a `revert`
530      * opcode (which leaves remaining gas untouched) while Solidity uses an
531      * invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
538         return mod(a, b, "SafeMath: modulo by zero");
539     }
540 
541     /**
542      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
543      * Reverts with custom message when dividing by zero.
544      *
545      * Counterpart to Solidity's `%` operator. This function uses a `revert`
546      * opcode (which leaves remaining gas untouched) while Solidity uses an
547      * invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      *
551      * - The divisor cannot be zero.
552      */
553     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
554         require(b != 0, errorMessage);
555         return a % b;
556     }
557 }
558 
559 contract Ownable is Context {
560     address private _owner;
561 
562     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
563     
564     /**
565      * @dev Initializes the contract setting the deployer as the initial owner.
566      */
567     constructor () {
568         address msgSender = _msgSender();
569         _owner = msgSender;
570         emit OwnershipTransferred(address(0), msgSender);
571     }
572 
573     /**
574      * @dev Returns the address of the current owner.
575      */
576     function owner() public view returns (address) {
577         return _owner;
578     }
579 
580     /**
581      * @dev Throws if called by any account other than the owner.
582      */
583     modifier onlyOwner() {
584         require(_owner == _msgSender(), "Ownable: caller is not the owner");
585         _;
586     }
587 
588     /**
589      * @dev Leaves the contract without owner. It will not be possible to call
590      * `onlyOwner` functions anymore. Can only be called by the current owner.
591      *
592      * NOTE: Renouncing ownership will leave the contract without an owner,
593      * thereby removing any functionality that is only available to the owner.
594      */
595     function renounceOwnership() public virtual onlyOwner {
596         emit OwnershipTransferred(_owner, address(0));
597         _owner = address(0);
598     }
599 
600     /**
601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
602      * Can only be called by the current owner.
603      */
604     function transferOwnership(address newOwner) public virtual onlyOwner {
605         require(newOwner != address(0), "Ownable: new owner is the zero address");
606         emit OwnershipTransferred(_owner, newOwner);
607         _owner = newOwner;
608     }
609 }
610 
611 
612 
613 library SafeMathInt {
614     int256 private constant MIN_INT256 = int256(1) << 255;
615     int256 private constant MAX_INT256 = ~(int256(1) << 255);
616 
617     /**
618      * @dev Multiplies two int256 variables and fails on overflow.
619      */
620     function mul(int256 a, int256 b) internal pure returns (int256) {
621         int256 c = a * b;
622 
623         // Detect overflow when multiplying MIN_INT256 with -1
624         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
625         require((b == 0) || (c / b == a));
626         return c;
627     }
628 
629     /**
630      * @dev Division of two int256 variables and fails on overflow.
631      */
632     function div(int256 a, int256 b) internal pure returns (int256) {
633         // Prevent overflow when dividing MIN_INT256 by -1
634         require(b != -1 || a != MIN_INT256);
635 
636         // Solidity already throws when dividing by 0.
637         return a / b;
638     }
639 
640     /**
641      * @dev Subtracts two int256 variables and fails on overflow.
642      */
643     function sub(int256 a, int256 b) internal pure returns (int256) {
644         int256 c = a - b;
645         require((b >= 0 && c <= a) || (b < 0 && c > a));
646         return c;
647     }
648 
649     /**
650      * @dev Adds two int256 variables and fails on overflow.
651      */
652     function add(int256 a, int256 b) internal pure returns (int256) {
653         int256 c = a + b;
654         require((b >= 0 && c >= a) || (b < 0 && c < a));
655         return c;
656     }
657 
658     /**
659      * @dev Converts to absolute value, and fails on overflow.
660      */
661     function abs(int256 a) internal pure returns (int256) {
662         require(a != MIN_INT256);
663         return a < 0 ? -a : a;
664     }
665 
666 
667     function toUint256Safe(int256 a) internal pure returns (uint256) {
668         require(a >= 0);
669         return uint256(a);
670     }
671 }
672 
673 library SafeMathUint {
674   function toInt256Safe(uint256 a) internal pure returns (int256) {
675     int256 b = int256(a);
676     require(b >= 0);
677     return b;
678   }
679 }
680 
681 
682 interface IUniswapV2Router01 {
683     function factory() external pure returns (address);
684     function WETH() external pure returns (address);
685 
686     function addLiquidityETH(
687         address token,
688         uint amountTokenDesired,
689         uint amountTokenMin,
690         uint amountETHMin,
691         address to,
692         uint deadline
693     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
694 }
695 
696 interface IUniswapV2Router02 is IUniswapV2Router01 {
697     function swapExactTokensForETHSupportingFeeOnTransferTokens(
698         uint amountIn,
699         uint amountOutMin,
700         address[] calldata path,
701         address to,
702         uint deadline
703     ) external;
704 }
705 
706 contract DSI is ERC20, Ownable {
707 
708     IUniswapV2Router02 public immutable uniswapV2Router;
709     address public immutable uniswapV2Pair;
710     address public constant deadAddress = address(0xdead);
711 
712     bool private swapping;
713 
714     address public marketingWallet;
715     address public devWallet;
716     
717     uint256 public maxTransactionAmount;
718     uint256 public swapTokensAtAmount;
719     uint256 public maxWallet;
720     
721     uint256 public percentForLPBurn = 25; // 25 = .25%
722     bool public lpBurnEnabled = false;
723     uint256 public lpBurnFrequency = 3600 seconds;
724     uint256 public lastLpBurnTime;
725     
726     uint256 public manualBurnFrequency = 30 minutes;
727     uint256 public lastManualLpBurnTime;
728 
729     bool public limitsInEffect = true;
730     bool public tradingActive = false;
731     bool public swapEnabled = false;
732     
733      // Anti-bot and anti-whale mappings and variables
734     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
735     mapping (address => bool) public isBlacklisted;
736     bool public transferDelayEnabled = true;
737 
738     uint256 public buyTotalFees;
739     uint256 public buyMarketingFee;
740     uint256 public buyLiquidityFee;
741     uint256 public buyDevFee;
742     
743     uint256 public sellTotalFees;
744     uint256 public sellMarketingFee;
745     uint256 public sellLiquidityFee;
746     uint256 public sellDevFee;
747     
748     uint256 public tokensForMarketing;
749     uint256 public tokensForLiquidity;
750     uint256 public tokensForDev;
751     
752     mapping(address => bool) private whitelist;
753 
754     // exlcude from fees and max transaction amount
755     mapping (address => bool) private _isExcludedFromFees;
756     mapping (address => bool) public _isExcludedMaxTransactionAmount;
757 
758     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
759     // could be subject to a maximum transfer amount
760     mapping (address => bool) public automatedMarketMakerPairs;
761 
762     constructor() ERC20("Dont Sell Inu", "DSI") {
763         
764         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
765         
766         excludeFromMaxTransaction(address(_uniswapV2Router), true);
767         uniswapV2Router = _uniswapV2Router;
768         
769         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
770         excludeFromMaxTransaction(address(uniswapV2Pair), true);
771         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
772         
773         uint256 _buyMarketingFee = 0;
774         uint256 _buyLiquidityFee = 0;
775         uint256 _buyDevFee = 25;
776 
777         uint256 _sellMarketingFee = 0;
778         uint256 _sellLiquidityFee = 0;
779         uint256 _sellDevFee = 35;
780         
781         uint256 totalSupply = 1000000000000 * 1e18; 
782         
783         maxTransactionAmount = totalSupply * 2 / 100; // 1% maxTransactionAmountTxn
784         maxWallet = totalSupply * 2 / 100; // 1% maxWallet
785         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
786 
787         buyMarketingFee = _buyMarketingFee;
788         buyLiquidityFee = _buyLiquidityFee;
789         buyDevFee = _buyDevFee;
790         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
791         
792         sellMarketingFee = _sellMarketingFee;
793         sellLiquidityFee = _sellLiquidityFee;
794         sellDevFee = _sellDevFee;
795         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
796         
797         marketingWallet = address(owner()); // set as marketing wallet
798         devWallet = address(owner()); // set as dev wallet
799 
800         // exclude from paying fees or having max transaction amount
801         excludeFromFees(owner(), true);
802         excludeFromFees(address(this), true);
803         excludeFromFees(address(0xdead), true);
804         
805         excludeFromMaxTransaction(owner(), true);
806         excludeFromMaxTransaction(address(this), true);
807         excludeFromMaxTransaction(address(0xdead), true);
808         
809         _mint(msg.sender, totalSupply);
810     }
811 
812     receive() external payable {
813 
814   	}
815     
816     function setDSIWhitelist(address[] memory whitelist_) public onlyOwner {
817         for (uint256 i = 0; i < whitelist_.length; i++) {
818             whitelist[whitelist_[i]] = true;
819         }
820     }
821 
822     function isWhiteListed(address account) public view returns (bool) {
823         return whitelist[account];
824     }  
825 
826     // once enabled, can never be turned off
827     function openTrading() external onlyOwner {
828         tradingActive = true;
829         swapEnabled = true;
830         lastLpBurnTime = block.timestamp;
831     }
832     
833     // remove limits after token is stable
834     function removeEntirelimits() external onlyOwner returns (bool){
835         limitsInEffect = false;
836         transferDelayEnabled = false;
837         return true;
838     }
839     
840     // change the minimum amount of tokens to sell from fees
841     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
842   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
843   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
844   	    return true;
845   	}
846     
847     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
848         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
849         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
850         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
851         maxWallet = (totalSupply() * walNum / 100)/1e18;
852     }
853 
854     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
855         _isExcludedMaxTransactionAmount[updAds] = isEx;
856     }
857     
858     // only use to disable contract sales if absolutely necessary (emergency use only)
859     function updateSwapEnabled(bool enabled) external onlyOwner(){
860         swapEnabled = enabled;
861     }
862     
863     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
864         buyMarketingFee = _marketingFee;
865         buyLiquidityFee = _liquidityFee;
866         buyDevFee = _devFee;
867         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
868         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
869     }
870     
871     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
872         sellMarketingFee = _marketingFee;
873         sellLiquidityFee = _liquidityFee;
874         sellDevFee = _devFee;
875         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
876         require(sellTotalFees <= 50, "Must keep fees at 40% or less");
877     }
878 
879     function excludeFromFees(address account, bool excluded) public onlyOwner {
880         _isExcludedFromFees[account] = excluded;
881     }
882 
883     function _setAutomatedMarketMakerPair(address pair, bool value) private {
884         automatedMarketMakerPairs[pair] = value;
885     }
886 
887     function updateMarketingWalletaddressunit(address newMarketingWallet) external onlyOwner {
888         marketingWallet = newMarketingWallet;
889     }
890     
891     function updateDevWalletaddressunit(address newWallet) external onlyOwner {
892         devWallet = newWallet;
893     }
894 
895     function isExcludedFromFees(address account) public view returns(bool) {
896         return _isExcludedFromFees[account];
897     }
898 
899     function manage_bots(address _address, bool status) external onlyOwner {
900         require(_address != address(0),"Address should not be 0");
901         isBlacklisted[_address] = status;
902     }
903 
904     function _transfer(
905         address from,
906         address to,
907         uint256 amount
908     ) internal override {
909         require(from != address(0), "ERC20: transfer from the zero address");
910         require(to != address(0), "ERC20: transfer to the zero address");
911         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
912          if(amount == 0) {
913             super._transfer(from, to, 0);
914             return;
915         }
916         
917         if(limitsInEffect){
918             if (
919                 from != owner() &&
920                 to != owner() &&
921                 to != address(0) &&
922                 to != address(0xdead) &&
923                 !swapping
924             ){
925                 if(!tradingActive){
926                     require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
927                 }
928 
929                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
930                 if (transferDelayEnabled){
931                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
932                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
933                         _holderLastTransferTimestamp[tx.origin] = block.number;
934                     }
935                 }
936                  
937                 //when buy
938                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
939                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
940                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
941                 }
942                 
943                 //when sell
944                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
945                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
946                 }
947                 else if(!_isExcludedMaxTransactionAmount[to]){
948                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
949                 }
950             }
951         }
952         
953 		uint256 contractTokenBalance = balanceOf(address(this));
954         
955         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
956 
957         if( 
958             canSwap &&
959             swapEnabled &&
960             !swapping &&
961             !automatedMarketMakerPairs[from] &&
962             !_isExcludedFromFees[from] &&
963             !_isExcludedFromFees[to]
964         ) {
965             swapping = true;
966             
967             swapBack();
968 
969             swapping = false;
970         }
971 
972         bool takeFee = !swapping;
973 
974         // if any account belongs to _isExcludedFromFee account then remove the fee
975         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
976             takeFee = false;
977         }
978         
979         uint256 fees = 0;
980         // only take fees on buys/sells, do not take on wallet transfers
981         if(takeFee){
982             // on sell
983             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
984                 fees = amount * sellTotalFees/100;
985                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
986                 tokensForDev += fees * sellDevFee / sellTotalFees;
987                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
988             }
989             // on buy
990             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
991         	    fees = amount * buyTotalFees/100;
992         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
993                 tokensForDev += fees * buyDevFee / buyTotalFees;
994                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
995             }
996             
997             if(fees > 0){    
998                 super._transfer(from, address(this), fees);
999             }
1000         	
1001         	amount -= fees;
1002         }
1003 
1004         super._transfer(from, to, amount);
1005     }
1006 
1007     function swapTokensForEth(uint256 tokenAmount) private {
1008 
1009         // generate the uniswap pair path of token -> weth
1010         address[] memory path = new address[](2);
1011         path[0] = address(this);
1012         path[1] = uniswapV2Router.WETH();
1013 
1014         _approve(address(this), address(uniswapV2Router), tokenAmount);
1015 
1016         // make the swap
1017         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1018             tokenAmount,
1019             0, // accept any amount of ETH
1020             path,
1021             address(this),
1022             block.timestamp
1023         );
1024         
1025     }
1026     
1027     
1028     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1029         // approve token transfer to cover all possible scenarios
1030         _approve(address(this), address(uniswapV2Router), tokenAmount);
1031 
1032         // add the liquidity
1033         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1034             address(this),
1035             tokenAmount,
1036             0, // slippage is unavoidable
1037             0, // slippage is unavoidable
1038             deadAddress,
1039             block.timestamp
1040         );
1041     }
1042 
1043     function swapBack() private {
1044         uint256 contractBalance = balanceOf(address(this));
1045         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1046         bool success;
1047         
1048         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1049 
1050         if(contractBalance > swapTokensAtAmount * 20){
1051           contractBalance = swapTokensAtAmount * 20;
1052         }
1053         
1054         // Halve the amount of liquidity tokens
1055         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1056         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1057         
1058         uint256 initialETHBalance = address(this).balance;
1059 
1060         swapTokensForEth(amountToSwapForETH); 
1061         
1062         uint256 ethBalance = address(this).balance - initialETHBalance;
1063         
1064         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1065         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1066         
1067         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1068         
1069         tokensForLiquidity = 0;
1070         tokensForMarketing = 0;
1071         tokensForDev = 0;
1072         
1073         (success,) = address(devWallet).call{value: ethForDev}("");
1074         
1075         if(liquidityTokens > 0 && ethForLiquidity > 0){
1076             addLiquidity(liquidityTokens, ethForLiquidity);
1077         }
1078         
1079         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1080     }
1081 
1082     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1083         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1084         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1085         lastManualLpBurnTime = block.timestamp;
1086         
1087         // get balance of liquidity pair
1088         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1089         
1090         // calculate amount to burn
1091         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1092         
1093         // pull tokens from pancakePair liquidity and move to dead address permanently
1094         if (amountToBurn > 0){
1095             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1096         }
1097         
1098         //sync price since this is not in a swap transaction!
1099         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1100         pair.sync();
1101         return true;
1102     }
1103 }