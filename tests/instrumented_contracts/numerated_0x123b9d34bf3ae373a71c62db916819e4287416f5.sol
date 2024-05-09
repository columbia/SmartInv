1 //███╗░░░███╗██╗██████╗░░█████╗░░██████╗░███████╗
2 //████╗░████║██║██╔══██╗██╔══██╗██╔════╝░██╔════╝
3 //██╔████╔██║██║██████╔╝███████║██║░░██╗░█████╗░░
4 //██║╚██╔╝██║██║██╔══██╗██╔══██║██║░░╚██╗██╔══╝░░
5 //██║░╚═╝░██║██║██║░░██║██║░░██║╚██████╔╝███████╗
6 //╚═╝░░░░░╚═╝╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░╚══════╝
7 
8 //Website: https://Mirage.Exchange
9 
10 //Twitter: https://twitter.com/MirageSwapERC
11 
12 //Telegram: https://t.me/MirageDefi
13 
14 //Swap: https://Swap.Mirage.Exchange
15 
16 
17 // SPDX-License-Identifier: MIT                                                                               
18                                                     
19 pragma solidity = 0.8.19;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 interface IUniswapV2Pair {
33     event Sync(uint112 reserve0, uint112 reserve1);
34     function sync() external;
35 }
36 
37 interface IUniswapV2Factory {
38     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
39 
40     function createPair(address tokenA, address tokenB) external returns (address pair);
41 }
42 
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 interface IERC20Metadata is IERC20 {
119     /**
120      * @dev Returns the name of the token.
121      */
122     function name() external view returns (string memory);
123 
124     /**
125      * @dev Returns the symbol of the token.
126      */
127     function symbol() external view returns (string memory);
128 
129     /**
130      * @dev Returns the decimals places of the token.
131      */
132     function decimals() external view returns (uint8);
133 }
134 
135 
136 contract ERC20 is Context, IERC20, IERC20Metadata {
137     using SafeMath for uint256;
138 
139     mapping(address => uint256) private _balances;
140 
141     mapping(address => mapping(address => uint256)) private _allowances;
142 
143     uint256 private _totalSupply;
144 
145     string private _name;
146     string private _symbol;
147 
148     /**
149      * @dev Sets the values for {name} and {symbol}.
150      *
151      * The default value of {decimals} is 18. To select a different value for
152      * {decimals} you should overload it.
153      *
154      * All two of these values are immutable: they can only be set once during
155      * construction.
156      */
157     constructor(string memory name_, string memory symbol_) {
158         _name = name_;
159         _symbol = symbol_;
160     }
161 
162     /**
163      * @dev Returns the name of the token.
164      */
165     function name() public view virtual override returns (string memory) {
166         return _name;
167     }
168 
169     /**
170      * @dev Returns the symbol of the token, usually a shorter version of the
171      * name.
172      */
173     function symbol() public view virtual override returns (string memory) {
174         return _symbol;
175     }
176 
177     /**
178      * @dev Returns the number of decimals used to get its user representation.
179      * For example, if `decimals` equals `2`, a balance of `505` tokens should
180      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
181      *
182      * Tokens usually opt for a value of 18, imitating the relationship between
183      * Ether and Wei. This is the value {ERC20} uses, unless this function is
184      * overridden;
185      *
186      * NOTE: This information is only used for _display_ purposes: it in
187      * no way affects any of the arithmetic of the contract, including
188      * {IERC20-balanceOf} and {IERC20-transfer}.
189      */
190     function decimals() public view virtual override returns (uint8) {
191         return 18;
192     }
193 
194     /**
195      * @dev See {IERC20-totalSupply}.
196      */
197     function totalSupply() public view virtual override returns (uint256) {
198         return _totalSupply;
199     }
200 
201     /**
202      * @dev See {IERC20-balanceOf}.
203      */
204     function balanceOf(address account) public view virtual override returns (uint256) {
205         return _balances[account];
206     }
207 
208     /**
209      * @dev See {IERC20-transfer}.
210      *
211      * Requirements:
212      *
213      * - `recipient` cannot be the zero address.
214      * - the caller must have a balance of at least `amount`.
215      */
216     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
217         _transfer(_msgSender(), recipient, amount);
218         return true;
219     }
220 
221     /**
222      * @dev See {IERC20-allowance}.
223      */
224     function allowance(address owner, address spender) public view virtual override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     /**
229      * @dev See {IERC20-approve}.
230      *
231      * Requirements:
232      *
233      * - `spender` cannot be the zero address.
234      */
235     function approve(address spender, uint256 amount) public virtual override returns (bool) {
236         _approve(_msgSender(), spender, amount);
237         return true;
238     }
239 
240     /**
241      * @dev See {IERC20-transferFrom}.
242      *
243      * Emits an {Approval} event indicating the updated allowance. This is not
244      * required by the EIP. See the note at the beginning of {ERC20}.
245      *
246      * Requirements:
247      *
248      * - `sender` and `recipient` cannot be the zero address.
249      * - `sender` must have a balance of at least `amount`.
250      * - the caller must have allowance for ``sender``'s tokens of at least
251      * `amount`.
252      */
253     function transferFrom(
254         address sender,
255         address recipient,
256         uint256 amount
257     ) public virtual override returns (bool) {
258         _transfer(sender, recipient, amount);
259         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
260         return true;
261     }
262 
263     /**
264      * @dev Atomically increases the allowance granted to `spender` by the caller.
265      *
266      * This is an alternative to {approve} that can be used as a mitigation for
267      * problems described in {IERC20-approve}.
268      *
269      * Emits an {Approval} event indicating the updated allowance.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
276         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
277         return true;
278     }
279 
280     /**
281      * @dev Atomically decreases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to {approve} that can be used as a mitigation for
284      * problems described in {IERC20-approve}.
285      *
286      * Emits an {Approval} event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      * - `spender` must have allowance for the caller of at least
292      * `subtractedValue`.
293      */
294     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
295         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
296         return true;
297     }
298 
299     /**
300      * @dev Moves tokens `amount` from `sender` to `recipient`.
301      *
302      * This is internal function is equivalent to {transfer}, and can be used to
303      * e.g. implement automatic token fees, slashing mechanisms, etc.
304      *
305      * Emits a {Transfer} event.
306      *
307      * Requirements:
308      *
309      * - `sender` cannot be the zero address.
310      * - `recipient` cannot be the zero address.
311      * - `sender` must have a balance of at least `amount`.
312      */
313     function _transfer(
314         address sender,
315         address recipient,
316         uint256 amount
317     ) internal virtual {
318         require(sender != address(0), "ERC20: transfer from the zero address");
319         require(recipient != address(0), "ERC20: transfer to the zero address");
320 
321         _beforeTokenTransfer(sender, recipient, amount);
322 
323         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
324         _balances[recipient] = _balances[recipient].add(amount);
325         emit Transfer(sender, recipient, amount);
326     }
327 
328     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
329      * the total supply.
330      *
331      * Emits a {Transfer} event with `from` set to the zero address.
332      *
333      * Requirements:
334      *
335      * - `account` cannot be the zero address.
336      */
337     function _mint(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _beforeTokenTransfer(address(0), account, amount);
341 
342         _totalSupply = _totalSupply.add(amount);
343         _balances[account] = _balances[account].add(amount);
344         emit Transfer(address(0), account, amount);
345     }
346 
347     /**
348      * @dev Destroys `amount` tokens from `account`, reducing the
349      * total supply.
350      *
351      * Emits a {Transfer} event with `to` set to the zero address.
352      *
353      * Requirements:
354      *
355      * - `account` cannot be the zero address.
356      * - `account` must have at least `amount` tokens.
357      */
358     function _burn(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: burn from the zero address");
360 
361         _beforeTokenTransfer(account, address(0), amount);
362 
363         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
364         _totalSupply = _totalSupply.sub(amount);
365         emit Transfer(account, address(0), amount);
366     }
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
370      *
371      * This internal function is equivalent to `approve`, and can be used to
372      * e.g. set automatic allowances for certain subsystems, etc.
373      *
374      * Emits an {Approval} event.
375      *
376      * Requirements:
377      *
378      * - `owner` cannot be the zero address.
379      * - `spender` cannot be the zero address.
380      */
381     function _approve(
382         address owner,
383         address spender,
384         uint256 amount
385     ) internal virtual {
386         require(owner != address(0), "ERC20: approve from the zero address");
387         require(spender != address(0), "ERC20: approve to the zero address");
388 
389         _allowances[owner][spender] = amount;
390         emit Approval(owner, spender, amount);
391     }
392 
393     /**
394      * @dev Hook that is called before any transfer of tokens. This includes
395      * minting and burning.
396      *
397      * Calling conditions:
398      *
399      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
400      * will be to transferred to `to`.
401      * - when `from` is zero, `amount` tokens will be minted for `to`.
402      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
403      * - `from` and `to` are never both zero.
404      *
405      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
406      */
407     function _beforeTokenTransfer(
408         address from,
409         address to,
410         uint256 amount
411     ) internal virtual {}
412 }
413 
414 library SafeMath {
415     /**
416      * @dev Returns the addition of two unsigned integers, reverting on
417      * overflow.
418      *
419      * Counterpart to Solidity's `+` operator.
420      *
421      * Requirements:
422      *
423      * - Addition cannot overflow.
424      */
425     function add(uint256 a, uint256 b) internal pure returns (uint256) {
426         uint256 c = a + b;
427         require(c >= a, "SafeMath: addition overflow");
428 
429         return c;
430     }
431 
432     /**
433      * @dev Returns the subtraction of two unsigned integers, reverting on
434      * overflow (when the result is negative).
435      *
436      * Counterpart to Solidity's `-` operator.
437      *
438      * Requirements:
439      *
440      * - Subtraction cannot overflow.
441      */
442     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443         return sub(a, b, "SafeMath: subtraction overflow");
444     }
445 
446     /**
447      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
448      * overflow (when the result is negative).
449      *
450      * Counterpart to Solidity's `-` operator.
451      *
452      * Requirements:
453      *
454      * - Subtraction cannot overflow.
455      */
456     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
457         require(b <= a, errorMessage);
458         uint256 c = a - b;
459 
460         return c;
461     }
462 
463     /**
464      * @dev Returns the multiplication of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `*` operator.
468      *
469      * Requirements:
470      *
471      * - Multiplication cannot overflow.
472      */
473     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
474         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
475         // benefit is lost if 'b' is also tested.
476         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
477         if (a == 0) {
478             return 0;
479         }
480 
481         uint256 c = a * b;
482         require(c / a == b, "SafeMath: multiplication overflow");
483 
484         return c;
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers. Reverts on
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
499     function div(uint256 a, uint256 b) internal pure returns (uint256) {
500         return div(a, b, "SafeMath: division by zero");
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
505      * division by zero. The result is rounded towards zero.
506      *
507      * Counterpart to Solidity's `/` operator. Note: this function uses a
508      * `revert` opcode (which leaves remaining gas untouched) while Solidity
509      * uses an invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      *
513      * - The divisor cannot be zero.
514      */
515     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b > 0, errorMessage);
517         uint256 c = a / b;
518         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
519 
520         return c;
521     }
522 
523     /**
524      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
525      * Reverts when dividing by zero.
526      *
527      * Counterpart to Solidity's `%` operator. This function uses a `revert`
528      * opcode (which leaves remaining gas untouched) while Solidity uses an
529      * invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
536         return mod(a, b, "SafeMath: modulo by zero");
537     }
538 
539     /**
540      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
541      * Reverts with custom message when dividing by zero.
542      *
543      * Counterpart to Solidity's `%` operator. This function uses a `revert`
544      * opcode (which leaves remaining gas untouched) while Solidity uses an
545      * invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
552         require(b != 0, errorMessage);
553         return a % b;
554     }
555 }
556 
557 contract Ownable is Context {
558     address private _owner;
559 
560     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
561     
562     /**
563      * @dev Initializes the contract setting the deployer as the initial owner.
564      */
565     constructor () {
566         address msgSender = _msgSender();
567         _owner = msgSender;
568         emit OwnershipTransferred(address(0), msgSender);
569     }
570 
571     /**
572      * @dev Returns the address of the current owner.
573      */
574     function owner() public view returns (address) {
575         return _owner;
576     }
577 
578     /**
579      * @dev Throws if called by any account other than the owner.
580      */
581     modifier onlyOwner() {
582         require(_owner == _msgSender(), "Ownable: caller is not the owner");
583         _;
584     }
585 
586     /**
587      * @dev Leaves the contract without owner. It will not be possible to call
588      * `onlyOwner` functions anymore. Can only be called by the current owner.
589      *
590      * NOTE: Renouncing ownership will leave the contract without an owner,
591      * thereby removing any functionality that is only available to the owner.
592      */
593     function renounceOwnership() public virtual onlyOwner {
594         emit OwnershipTransferred(_owner, address(0));
595         _owner = address(0);
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         emit OwnershipTransferred(_owner, newOwner);
605         _owner = newOwner;
606     }
607 }
608 
609 
610 
611 library SafeMathInt {
612     int256 private constant MIN_INT256 = int256(1) << 255;
613     int256 private constant MAX_INT256 = ~(int256(1) << 255);
614 
615     /**
616      * @dev Multiplies two int256 variables and fails on overflow.
617      */
618     function mul(int256 a, int256 b) internal pure returns (int256) {
619         int256 c = a * b;
620 
621         // Detect overflow when multiplying MIN_INT256 with -1
622         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
623         require((b == 0) || (c / b == a));
624         return c;
625     }
626 
627     /**
628      * @dev Division of two int256 variables and fails on overflow.
629      */
630     function div(int256 a, int256 b) internal pure returns (int256) {
631         // Prevent overflow when dividing MIN_INT256 by -1
632         require(b != -1 || a != MIN_INT256);
633 
634         // Solidity already throws when dividing by 0.
635         return a / b;
636     }
637 
638     /**
639      * @dev Subtracts two int256 variables and fails on overflow.
640      */
641     function sub(int256 a, int256 b) internal pure returns (int256) {
642         int256 c = a - b;
643         require((b >= 0 && c <= a) || (b < 0 && c > a));
644         return c;
645     }
646 
647     /**
648      * @dev Adds two int256 variables and fails on overflow.
649      */
650     function add(int256 a, int256 b) internal pure returns (int256) {
651         int256 c = a + b;
652         require((b >= 0 && c >= a) || (b < 0 && c < a));
653         return c;
654     }
655 
656     /**
657      * @dev Converts to absolute value, and fails on overflow.
658      */
659     function abs(int256 a) internal pure returns (int256) {
660         require(a != MIN_INT256);
661         return a < 0 ? -a : a;
662     }
663 
664 
665     function toUint256Safe(int256 a) internal pure returns (uint256) {
666         require(a >= 0);
667         return uint256(a);
668     }
669 }
670 
671 library SafeMathUint {
672   function toInt256Safe(uint256 a) internal pure returns (int256) {
673     int256 b = int256(a);
674     require(b >= 0);
675     return b;
676   }
677 }
678 
679 
680 interface IUniswapV2Router01 {
681     function factory() external pure returns (address);
682     function WETH() external pure returns (address);
683 
684     function addLiquidityETH(
685         address token,
686         uint amountTokenDesired,
687         uint amountTokenMin,
688         uint amountETHMin,
689         address to,
690         uint deadline
691     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
692 }
693 
694 interface IUniswapV2Router02 is IUniswapV2Router01 {
695     function swapExactTokensForETHSupportingFeeOnTransferTokens(
696         uint amountIn,
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external;
702 }
703 
704 contract Mirage is ERC20, Ownable {
705 
706     IUniswapV2Router02 public immutable uniswapV2Router;
707     address public immutable uniswapV2Pair;
708     address public constant deadAddress = address(0xdead);
709 
710     bool private swapping;
711 
712     address public marketingWallet;
713     address public devWallet;
714     
715     uint256 public maxTransactionAmount;
716     uint256 public swapTokensAtAmount;
717     uint256 public maxWallet;
718     
719     uint256 public percentForLPBurn = 25; // 25 = .25%
720     bool public lpBurnEnabled = false;
721     uint256 public lpBurnFrequency = 3600 seconds;
722     uint256 public lastLpBurnTime;
723     
724     uint256 public manualBurnFrequency = 30 minutes;
725     uint256 public lastManualLpBurnTime;
726 
727     bool public limitsInEffect = true;
728     bool public tradingActive = false;
729     bool public swapEnabled = false;
730     
731      // Anti-bot and anti-whale mappings and variables
732     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
733     mapping (address => bool) public isBlacklisted;
734     bool public transferDelayEnabled = true;
735 
736     uint256 public buyTotalFees;
737     uint256 public buyMarketingFee;
738     uint256 public buyLiquidityFee;
739     uint256 public buyDevFee;
740     
741     uint256 public sellTotalFees;
742     uint256 public sellMarketingFee;
743     uint256 public sellLiquidityFee;
744     uint256 public sellDevFee;
745     
746     uint256 public tokensForMarketing;
747     uint256 public tokensForLiquidity;
748     uint256 public tokensForDev;
749 
750     string public _websiteInformation;
751     string public _telegramInformation;
752 
753     // exlcude from fees and max transaction amount
754     mapping (address => bool) private _isExcludedFromFees;
755     mapping (address => bool) public _isExcludedMaxTransactionAmount;
756 
757     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
758     // could be subject to a maximum transfer amount
759     mapping (address => bool) public automatedMarketMakerPairs;
760 
761     constructor() ERC20(unicode"Mirage", unicode"MIRAGE") {
762         
763         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
764         
765         excludeFromMaxTransaction(address(_uniswapV2Router), true);
766         uniswapV2Router = _uniswapV2Router;
767         
768         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
769         excludeFromMaxTransaction(address(uniswapV2Pair), true);
770         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
771         
772         uint256 _buyMarketingFee = 25;
773         uint256 _buyLiquidityFee = 0;
774         uint256 _buyDevFee = 0;
775 
776         uint256 _sellMarketingFee = 35;
777         uint256 _sellLiquidityFee = 0;
778         uint256 _sellDevFee = 0;
779         
780         uint256 totalSupply = 1000000000000 * 1e18; 
781         
782         maxTransactionAmount = totalSupply * 2 / 100; // 
783         maxWallet = totalSupply * 2 / 100; //
784         swapTokensAtAmount = totalSupply * 5 / 1000; // 
785 
786         buyMarketingFee = _buyMarketingFee;
787         buyLiquidityFee = _buyLiquidityFee;
788         buyDevFee = _buyDevFee;
789         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
790         
791         sellMarketingFee = _sellMarketingFee;
792         sellLiquidityFee = _sellLiquidityFee;
793         sellDevFee = _sellDevFee;
794         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
795         
796         marketingWallet = address(owner()); 
797         devWallet = address(owner()); // 
798 
799         // exclude from paying fees or having max transaction amount
800         excludeFromFees(owner(), true);
801         excludeFromFees(address(this), true);
802         excludeFromFees(address(0xdead), true);
803         
804         excludeFromMaxTransaction(owner(), true);
805         excludeFromMaxTransaction(address(this), true);
806         excludeFromMaxTransaction(address(0xdead), true);
807         
808         _mint(msg.sender, totalSupply);
809     }
810 
811     receive() external payable {
812 
813   	}
814 
815     // once enabled, can never be turned off
816     function openTrading() external onlyOwner {
817         tradingActive = true;
818         swapEnabled = true;
819         lastLpBurnTime = block.timestamp;
820     }
821     
822     // remove limits after token is stable
823     function Updatemirageimits() external onlyOwner returns (bool){
824         limitsInEffect = false;
825         transferDelayEnabled = false;
826         return true;
827     }
828     
829     // change the minimum amount of tokens to sell from fees
830     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
831   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
832   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
833   	    return true;
834   	}
835     
836     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
837         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
838         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
839         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
840         maxWallet = (totalSupply() * walNum / 100)/1e18;
841     }
842 
843     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
844         _isExcludedMaxTransactionAmount[updAds] = isEx;
845     }
846     
847     // only use to disable contract sales if absolutely necessary (emergency use only)
848     function updateSwapEnabled(bool enabled) external onlyOwner(){
849         swapEnabled = enabled;
850     }
851     
852     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
853         buyMarketingFee = _marketingFee;
854         buyLiquidityFee = _liquidityFee;
855         buyDevFee = _devFee;
856         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
857         require(buyTotalFees <= 40, "Must keep fees at 99% or less");
858     }
859     
860     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
861         sellMarketingFee = _marketingFee;
862         sellLiquidityFee = _liquidityFee;
863         sellDevFee = _devFee;
864         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
865         require(sellTotalFees <= 50, "Must keep fees at 99% or less");
866     }
867 
868     function excludeFromFees(address account, bool excluded) public onlyOwner {
869         _isExcludedFromFees[account] = excluded;
870     }
871 
872     function _setAutomatedMarketMakerPair(address pair, bool value) private {
873         automatedMarketMakerPairs[pair] = value;
874     }
875 
876     function UpdateoperationsWallet(address newMarketingWallet) external onlyOwner {
877         marketingWallet = newMarketingWallet;
878     }
879     
880     function UpdatedevWallet(address newWallet) external onlyOwner {
881         devWallet = newWallet;
882     }
883 
884     function isExcludedFromFees(address account) public view returns(bool) {
885         return _isExcludedFromFees[account];
886     }
887 
888     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
889         for(uint256 i = 0; i < wallets.length; i++){
890         isBlacklisted[wallets[i]] = flag;
891         }
892     }
893 
894     function withdrawETH() external onlyOwner returns(bool){
895         (bool success, ) = owner().call{value: address(this).balance}("");
896         return success;
897     }
898 
899     function _transfer(
900         address from,
901         address to,
902         uint256 amount
903     ) internal override {
904         require(from != address(0), "ERC20: transfer from the zero address");
905         require(to != address(0), "ERC20: transfer to the zero address");
906         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
907     
908         
909          if(amount == 0) {
910             super._transfer(from, to, 0);
911             return;
912         }
913         
914         if(limitsInEffect){
915             if (
916                 from != owner() &&
917                 to != owner() &&
918                 to != address(0) &&
919                 to != address(0xdead) &&
920                 !swapping
921             ){
922                 if(!tradingActive){
923                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
924                 }
925 
926                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
927                 if (transferDelayEnabled){
928                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
929                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
930                         _holderLastTransferTimestamp[tx.origin] = block.number;
931                     }
932                 }
933                  
934                 //when buy
935                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
936                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
937                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
938                 }
939                 
940                 //when sell
941                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
942                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
943                 }
944                 else if(!_isExcludedMaxTransactionAmount[to]){
945                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
946                 }
947             }
948         }
949         
950 		uint256 contractTokenBalance = balanceOf(address(this));
951         
952         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
953 
954         if( 
955             canSwap &&
956             swapEnabled &&
957             !swapping &&
958             !automatedMarketMakerPairs[from] &&
959             !_isExcludedFromFees[from] &&
960             !_isExcludedFromFees[to]
961         ) {
962             swapping = true;
963             
964             swapBack();
965 
966             swapping = false;
967         }
968 
969         bool takeFee = !swapping;
970 
971         // if any account belongs to _isExcludedFromFee account then remove the fee
972         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
973             takeFee = false;
974         }
975         
976         uint256 fees = 0;
977         // only take fees on buys/sells, do not take on wallet transfers
978         if(takeFee){
979             // on sell
980             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
981                 fees = amount * sellTotalFees/100;
982                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
983                 tokensForDev += fees * sellDevFee / sellTotalFees;
984                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
985             }
986             // on buy
987             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
988         	    fees = amount * buyTotalFees/100;
989         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
990                 tokensForDev += fees * buyDevFee / buyTotalFees;
991                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
992             }
993             
994             if(fees > 0){    
995                 super._transfer(from, address(this), fees);
996             }
997         	
998         	amount -= fees;
999         }
1000 
1001         super._transfer(from, to, amount);
1002     }
1003 
1004     function swapTokensForEth(uint256 tokenAmount) private {
1005 
1006         // generate the uniswap pair path of token -> weth
1007         address[] memory path = new address[](2);
1008         path[0] = address(this);
1009         path[1] = uniswapV2Router.WETH();
1010 
1011         _approve(address(this), address(uniswapV2Router), tokenAmount);
1012 
1013         // make the swap
1014         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1015             tokenAmount,
1016             0, // accept any amount of ETH
1017             path,
1018             address(this),
1019             block.timestamp
1020         );
1021         
1022     }
1023     
1024     
1025     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1026         // approve token transfer to cover all possible scenarios
1027         _approve(address(this), address(uniswapV2Router), tokenAmount);
1028 
1029         // add the liquidity
1030         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1031             address(this),
1032             tokenAmount,
1033             0, // slippage is unavoidable
1034             0, // slippage is unavoidable
1035             deadAddress,
1036             block.timestamp
1037         );
1038     }
1039 
1040     function swapBack() public {
1041         uint256 contractBalance = balanceOf(address(this));
1042         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1043         bool success;
1044         
1045         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1046 
1047         if(contractBalance > swapTokensAtAmount * 20){
1048           contractBalance = swapTokensAtAmount * 20;
1049         }
1050         
1051         // Halve the amount of liquidity tokens
1052         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1053         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1054         
1055         uint256 initialETHBalance = address(this).balance;
1056 
1057         swapTokensForEth(amountToSwapForETH); 
1058         
1059         uint256 ethBalance = address(this).balance - initialETHBalance;
1060         
1061         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1062         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1063         
1064         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1065         
1066         tokensForLiquidity = 0;
1067         tokensForMarketing = 0;
1068         tokensForDev = 0;
1069         
1070         (success,) = address(devWallet).call{value: ethForDev}("");
1071         
1072         if(liquidityTokens > 0 && ethForLiquidity > 0){
1073             addLiquidity(liquidityTokens, ethForLiquidity);
1074         }
1075         
1076         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1077     }
1078 
1079     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1080         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1081         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1082         lastManualLpBurnTime = block.timestamp;
1083         
1084         // get balance of liquidity pair
1085         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1086         
1087         // calculate amount to burn
1088         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1089         
1090         
1091         if (amountToBurn > 0){
1092             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1093         }
1094         
1095         //sync price since this is not in a swap transaction!
1096         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1097         pair.sync();
1098         return true;
1099     }
1100 
1101   
1102 
1103     /**
1104         Socials
1105     **/
1106       
1107     function setsocials(
1108         string calldata __websiteInformation,
1109         string calldata __telegramInformation
1110     ) external {
1111         require(
1112             msg.sender ==  address(owner()),
1113             "Only developer can adjust social links"
1114         );
1115 
1116         _websiteInformation = __websiteInformation;
1117         _telegramInformation = __telegramInformation;
1118 }  
1119 
1120     function getWebsiteInformation() public view returns (string memory) {
1121         return _websiteInformation;
1122     }
1123 
1124     function getTelegramInformation() public view returns (string memory) {
1125         return _telegramInformation;
1126     }
1127 
1128 }