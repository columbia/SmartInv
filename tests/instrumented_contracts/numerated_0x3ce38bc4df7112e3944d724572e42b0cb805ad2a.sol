1 /**
2 
3 website https://lawyerai.org/
4 
5 */
6 // SPDX-License-Identifier: MIT
7 pragma solidity = 0.8.16;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38 
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40 
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52 
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61 
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67 
68     function initialize(address, address) external;
69 }
70 
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73 
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76 
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80 
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86 
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 interface IERC20Metadata is IERC20 {
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() external view returns (string memory);
167 
168     /**
169      * @dev Returns the symbol of the token.
170      */
171     function symbol() external view returns (string memory);
172 
173     /**
174      * @dev Returns the decimals places of the token.
175      */
176     function decimals() external view returns (uint8);
177 }
178 
179 
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     using SafeMath for uint256;
182 
183     mapping(address => uint256) private _balances;
184 
185     mapping(address => mapping(address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191 
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The default value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor(string memory name_, string memory symbol_) {
202         _name = name_;
203         _symbol = symbol_;
204     }
205 
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() public view virtual override returns (string memory) {
210         return _name;
211     }
212 
213     /**
214      * @dev Returns the symbol of the token, usually a shorter version of the
215      * name.
216      */
217     function symbol() public view virtual override returns (string memory) {
218         return _symbol;
219     }
220 
221     /**
222      * @dev Returns the number of decimals used to get its user representation.
223      * For example, if `decimals` equals `2`, a balance of `505` tokens should
224      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
225      *
226      * Tokens usually opt for a value of 18, imitating the relationship between
227      * Ether and Wei. This is the value {ERC20} uses, unless this function is
228      * overridden;
229      *
230      * NOTE: This information is only used for _display_ purposes: it in
231      * no way affects any of the arithmetic of the contract, including
232      * {IERC20-balanceOf} and {IERC20-transfer}.
233      */
234     function decimals() public view virtual override returns (uint8) {
235         return 18;
236     }
237 
238     /**
239      * @dev See {IERC20-totalSupply}.
240      */
241     function totalSupply() public view virtual override returns (uint256) {
242         return _totalSupply;
243     }
244 
245     /**
246      * @dev See {IERC20-balanceOf}.
247      */
248     function balanceOf(address account) public view virtual override returns (uint256) {
249         return _balances[account];
250     }
251 
252     /**
253      * @dev See {IERC20-transfer}.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * Requirements:
291      *
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``sender``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         _transfer(sender, recipient, amount);
303         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342 
343     /**
344      * @dev Moves tokens `amount` from `sender` to `recipient`.
345      *
346      * This is internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) internal virtual {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(sender, recipient, amount);
366 
367         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
368         _balances[recipient] = _balances[recipient].add(amount);
369         emit Transfer(sender, recipient, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply = _totalSupply.add(amount);
387         _balances[account] = _balances[account].add(amount);
388         emit Transfer(address(0), account, amount);
389     }
390 
391     /**
392      * @dev Destroys `amount` tokens from `account`, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with `to` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      * - `account` must have at least `amount` tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404 
405         _beforeTokenTransfer(account, address(0), amount);
406 
407         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
408         _totalSupply = _totalSupply.sub(amount);
409         emit Transfer(account, address(0), amount);
410     }
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be to transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 }
457 
458 library SafeMath {
459     /**
460      * @dev Returns the addition of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `+` operator.
464      *
465      * Requirements:
466      *
467      * - Addition cannot overflow.
468      */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, "SafeMath: addition overflow");
472 
473         return c;
474     }
475 
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting on
478      * overflow (when the result is negative).
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487         return sub(a, b, "SafeMath: subtraction overflow");
488     }
489 
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
492      * overflow (when the result is negative).
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b <= a, errorMessage);
502         uint256 c = a - b;
503 
504         return c;
505     }
506 
507     /**
508      * @dev Returns the multiplication of two unsigned integers, reverting on
509      * overflow.
510      *
511      * Counterpart to Solidity's `*` operator.
512      *
513      * Requirements:
514      *
515      * - Multiplication cannot overflow.
516      */
517     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
518         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
519         // benefit is lost if 'b' is also tested.
520         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
521         if (a == 0) {
522             return 0;
523         }
524 
525         uint256 c = a * b;
526         require(c / a == b, "SafeMath: multiplication overflow");
527 
528         return c;
529     }
530 
531     /**
532      * @dev Returns the integer division of two unsigned integers. Reverts on
533      * division by zero. The result is rounded towards zero.
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544         return div(a, b, "SafeMath: division by zero");
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator. Note: this function uses a
552      * `revert` opcode (which leaves remaining gas untouched) while Solidity
553      * uses an invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b > 0, errorMessage);
561         uint256 c = a / b;
562         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
563 
564         return c;
565     }
566 
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * Reverts when dividing by zero.
570      *
571      * Counterpart to Solidity's `%` operator. This function uses a `revert`
572      * opcode (which leaves remaining gas untouched) while Solidity uses an
573      * invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
580         return mod(a, b, "SafeMath: modulo by zero");
581     }
582 
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585      * Reverts with custom message when dividing by zero.
586      *
587      * Counterpart to Solidity's `%` operator. This function uses a `revert`
588      * opcode (which leaves remaining gas untouched) while Solidity uses an
589      * invalid opcode to revert (consuming all remaining gas).
590      *
591      * Requirements:
592      *
593      * - The divisor cannot be zero.
594      */
595     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
596         require(b != 0, errorMessage);
597         return a % b;
598     }
599 }
600 
601 contract Ownable is Context {
602     address private _owner;
603 
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605 
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor () {
610         address msgSender = _msgSender();
611         _owner = msgSender;
612         emit OwnershipTransferred(address(0), msgSender);
613     }
614 
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view returns (address) {
619         return _owner;
620     }
621 
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(_owner == _msgSender(), "Ownable: caller is not the owner");
627         _;
628     }
629 
630     /**
631      * @dev Leaves the contract without owner. It will not be possible to call
632      * `onlyOwner` functions anymore. Can only be called by the current owner.
633      *
634      * NOTE: Renouncing ownership will leave the contract without an owner,
635      * thereby removing any functionality that is only available to the owner.
636      */
637     function renounceOwnership() public virtual onlyOwner {
638         emit OwnershipTransferred(_owner, address(0));
639         _owner = address(0);
640     }
641 
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Can only be called by the current owner.
645      */
646     function transferOwnership(address newOwner) public virtual onlyOwner {
647         require(newOwner != address(0), "Ownable: new owner is the zero address");
648         emit OwnershipTransferred(_owner, newOwner);
649         _owner = newOwner;
650     }
651 }
652 
653 library SafeMathInt {
654     int256 private constant MIN_INT256 = int256(1) << 255;
655     int256 private constant MAX_INT256 = ~(int256(1) << 255);
656 
657     /**
658      * @dev Multiplies two int256 variables and fails on overflow.
659      */
660     function mul(int256 a, int256 b) internal pure returns (int256) {
661         int256 c = a * b;
662 
663         // Detect overflow when multiplying MIN_INT256 with -1
664         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
665         require((b == 0) || (c / b == a));
666         return c;
667     }
668 
669     /**
670      * @dev Division of two int256 variables and fails on overflow.
671      */
672     function div(int256 a, int256 b) internal pure returns (int256) {
673         // Prevent overflow when dividing MIN_INT256 by -1
674         require(b != -1 || a != MIN_INT256);
675 
676         // Solidity already throws when dividing by 0.
677         return a / b;
678     }
679 
680     /**
681      * @dev Subtracts two int256 variables and fails on overflow.
682      */
683     function sub(int256 a, int256 b) internal pure returns (int256) {
684         int256 c = a - b;
685         require((b >= 0 && c <= a) || (b < 0 && c > a));
686         return c;
687     }
688 
689     /**
690      * @dev Adds two int256 variables and fails on overflow.
691      */
692     function add(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a + b;
694         require((b >= 0 && c >= a) || (b < 0 && c < a));
695         return c;
696     }
697 
698     /**
699      * @dev Converts to absolute value, and fails on overflow.
700      */
701     function abs(int256 a) internal pure returns (int256) {
702         require(a != MIN_INT256);
703         return a < 0 ? -a : a;
704     }
705 
706 
707     function toUint256Safe(int256 a) internal pure returns (uint256) {
708         require(a >= 0);
709         return uint256(a);
710     }
711 }
712 
713 library SafeMathUint {
714   function toInt256Safe(uint256 a) internal pure returns (int256) {
715     int256 b = int256(a);
716     require(b >= 0);
717     return b;
718   }
719 }
720 
721 interface IUniswapV2Router01 {
722     function factory() external pure returns (address);
723     function WETH() external pure returns (address);
724 
725     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
726         external
727         returns (uint[] memory amounts);
728 }
729 
730 interface IUniswapV2Router02 is IUniswapV2Router01 {
731     function swapExactTokensForETHSupportingFeeOnTransferTokens(
732         uint amountIn,
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external;
738 }
739 
740 pragma solidity >= 0.8.16;
741 
742 
743 contract Lawyer is ERC20, Ownable {
744     using SafeMath for uint256;
745 
746     IUniswapV2Router02 public immutable uniswapV2Router;
747     address public immutable uniswapV2Pair;
748     address public constant deadAddress = address(0xdead);
749     address public liquidityAddress;
750 
751     bool private swapping;
752 
753     uint256 public maxSellTransactionAmount;
754     uint256 public swapTokensAtAmount;
755     uint256 public maxWallet = 1;
756 
757     uint256 public supply;
758 
759     address public marketingAddress = 0x5A8Dc4b3EB57e71ddaD90a10b317fB138232b297;
760 
761     bool public tradingActive = true;
762     bool public liquidityFeeActive = true;
763 
764     bool public limitsInEffect = true;
765     bool public swapEnabled = true;
766 
767 
768     mapping(address => uint256) private _holderLastTransferTimestamp;
769     mapping(address => bool) public bots;
770 
771     uint256 public buyBurnFee = 0;
772     uint256 public buyMarketingFee = 20;
773     uint256 public buyLiquidityFee = 0;
774     uint256 public buyTotalFees = buyBurnFee + buyMarketingFee + buyLiquidityFee;
775 
776     uint256 public sellBurnFee = 0;
777     uint256 public sellMarketingFee = 40;
778     uint256 public sellLiquidityFee = 0;
779     uint256 public sellTotalFees = sellBurnFee + sellMarketingFee + sellLiquidityFee;
780 
781     uint256 public feeUnits = 100;
782 
783     uint256 public tokensForBurn;
784     uint256 public tokensForMarketing;
785     uint256 public tokensForLiquidity;
786 
787     uint256 private _previousBuyLiquidityFee = 0;
788     uint256 private _previousSellLiquidityFee = 0;
789 
790     uint256 public maxWalletTotal;
791     uint256 public maxSellTransaction = 1;
792 
793     /******************/
794 
795     // exlcude from fees and max transaction amount
796     mapping (address => bool) private _isExcludedFromFees;
797     mapping (address => bool) public _isExcludedMaxSellTransactionAmount;
798 
799     // Store the automatic market maker pair addresses. Any transfer *to* these addresses
800     // could be subject to a maximum transfer amount
801     mapping (address => bool) public automatedMarketMakerPairs;
802 
803     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
804 
805     event ExcludeFromFees(address indexed account, bool isExcluded);
806 
807     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
808     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
809     event updateHolderLastTransferTimestamp(address indexed account, uint256 timestamp);
810 
811 
812     constructor() ERC20("Lawyer Ai ", "$Ai") {
813 
814         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
815 
816         excludeFromMaxSellTransaction(address(_uniswapV2Router), true);
817         uniswapV2Router = _uniswapV2Router;
818 
819         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
820         excludeFromMaxSellTransaction(address(uniswapV2Pair), true);
821         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
822 
823     
824         uint256 totalSupply = 1000000000 * (10 ** 18);
825         supply += totalSupply;
826 
827         maxSellTransactionAmount = supply * maxSellTransaction / 100;
828         swapTokensAtAmount = supply / 10000; // 0.1% swap wallet;
829         maxWalletTotal = supply * maxWallet / 100;
830 
831         excludeFromFees(owner(), true);
832         excludeFromFees(address(this), true);
833         excludeFromFees(address(0xdead), true);
834 
835         excludeFromMaxSellTransaction(owner(), true);
836         excludeFromMaxSellTransaction(address(this), true);
837         excludeFromMaxSellTransaction(address(0xdead), true);
838 
839         _approve(owner(), address(uniswapV2Router), totalSupply);
840         _mint(msg.sender, totalSupply);
841     }
842 
843     receive() external payable {}
844 
845     function toggleLiquidityFeeActive () external onlyOwner {
846         if (liquidityFeeActive) {
847         _previousBuyLiquidityFee = buyLiquidityFee;
848         _previousSellLiquidityFee = sellLiquidityFee;
849         }
850         buyLiquidityFee = liquidityFeeActive ? 0 : _previousBuyLiquidityFee;
851         sellLiquidityFee = liquidityFeeActive ? 0 : _previousSellLiquidityFee;
852         liquidityFeeActive = !liquidityFeeActive;
853     }
854 
855 
856     function updateMaxSellTransaction(uint256 newNum) external onlyOwner {
857         require(newNum >= 1);
858         maxSellTransaction = newNum;
859         updateLimits();
860     }
861 
862     function updateMaxWallet(uint256 newNum) external onlyOwner {
863         require(newNum >= 1);
864         maxWallet = newNum;
865         updateLimits();
866     }
867 
868     function updateLimits() private {
869         maxSellTransactionAmount = supply * maxSellTransaction / 100;
870         swapTokensAtAmount = supply / 1000; // 0.1% swap wallet;
871         maxWalletTotal = supply * maxWallet / 100;
872     }
873 
874 
875     function excludeFromMaxSellTransaction(address updAds, bool isEx) public onlyOwner {
876         _isExcludedMaxSellTransactionAmount[updAds] = isEx;
877     }
878 
879     // if want fractional % in future, need to increase the fee units
880     function updateFeeUnits(uint256 newNum) external onlyOwner {
881         feeUnits = newNum;
882     }
883 
884     function manualSend() external {
885         uint256 contractBalance = address(this).balance;
886         payable(marketingAddress).transfer(contractBalance);
887     }
888 
889     function updateBuyFees(uint256 _burnFee, uint256 _marketingFee, uint256 _buyLiquidityFee) external onlyOwner {
890         buyBurnFee = _burnFee;
891         buyMarketingFee = _marketingFee;
892         buyLiquidityFee = _buyLiquidityFee;
893         buyTotalFees = buyBurnFee + buyMarketingFee + buyLiquidityFee;
894         require(buyTotalFees <= 15 * feeUnits / 100, "Must keep fees at 15% or less");
895     }
896 
897     function updateSellFees(uint256 _burnFee, uint256 _marketingFee, uint256 _sellLiquidityFee) external onlyOwner {
898         sellBurnFee = _burnFee;
899         sellMarketingFee = _marketingFee;
900         sellLiquidityFee = _sellLiquidityFee;
901         sellTotalFees = sellBurnFee + sellMarketingFee + sellLiquidityFee;
902         require(sellTotalFees <= 25 * feeUnits / 100, "Must keep fees at 25% or less");
903     }
904 
905     function updateMarketingAddress(address newWallet) external onlyOwner {
906         marketingAddress = newWallet;
907     }
908 
909     function excludeFromFees(address account, bool excluded) public onlyOwner {
910         _isExcludedFromFees[account] = excluded;
911         emit ExcludeFromFees(account, excluded);
912     }
913 
914     function includeInFees(address account) public onlyOwner {
915         excludeFromFees(account, false);
916     }
917 
918     function setLiquidityAddress(address newAddress) public onlyOwner {
919         liquidityAddress = newAddress;
920     }
921 
922     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
923         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
924 
925         _setAutomatedMarketMakerPair(pair, value);
926     }
927 
928     function _setAutomatedMarketMakerPair(address pair, bool value) private {
929         automatedMarketMakerPairs[pair] = value;
930 
931         emit SetAutomatedMarketMakerPair(pair, value);
932     }
933 
934     function isExcludedFromFees(address account) public view returns(bool) {
935         return _isExcludedFromFees[account];
936     }
937 
938     function _transfer(
939         address from,
940         address to,
941         uint256 amount
942     ) internal override {
943         require(from != address(0), "ERC20: transfer from the zero address");
944         require(to != address(0), "ERC20: transfer to the zero address");
945         require(!bots[from] && !bots[to], "Account is blacklisted!");
946 
947          if(amount == 0) {
948             super._transfer(from, to, 0);
949             return;
950         }
951 
952         if(limitsInEffect){
953             if (
954                 from != owner() &&
955                 to != owner() &&
956                 to != address(0) &&
957                 to != address(0xdead) &&
958                 !swapping
959             ){
960                 if(!tradingActive){
961                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
962                 }
963 
964                 // add the wallet to the _holderLastTransferTimestamp(address, timestamp) map
965                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
966                 emit updateHolderLastTransferTimestamp(tx.origin, block.timestamp);
967 
968                 //when buy
969                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxSellTransactionAmount[to] && !automatedMarketMakerPairs[to]){
970                         require(amount + balanceOf(to) <= maxWalletTotal, "Max wallet exceeded");
971                 }
972 
973                 //when sell
974                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxSellTransactionAmount[from] && !automatedMarketMakerPairs[from]){
975                         require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
976                 }
977                 else if(!_isExcludedMaxSellTransactionAmount[to]){
978                     require(amount + balanceOf(to) <= maxWalletTotal, "Max wallet exceeded");
979                 }
980             }
981         }
982         uint256 contractTokenBalance = balanceOf(address(this));
983 
984         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
985 
986         if(
987             canSwap &&
988             !swapping &&
989             swapEnabled &&
990             !automatedMarketMakerPairs[from] &&
991             !_isExcludedFromFees[from] &&
992             !_isExcludedFromFees[to]
993         ) {
994             swapping = true;
995 
996             swapBack();
997 
998             swapping = false;
999         }
1000 
1001         bool takeFee = !swapping;
1002 
1003         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1004             takeFee = false;
1005         }
1006 
1007         uint256 fees = 0;
1008 
1009         if(takeFee){
1010             // on sell
1011             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1012                 fees = amount.mul(sellTotalFees).div(feeUnits);
1013                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1014                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1015                 if (liquidityFeeActive) {
1016                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1017                 }
1018             }
1019 
1020             // on buy
1021             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1022         	    fees = amount.mul(buyTotalFees).div(feeUnits);
1023         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1024                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1025                 if (liquidityFeeActive) {
1026                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1027                 }
1028             }
1029 
1030             if(fees > 0){
1031                 super._transfer(from, address(this), fees);
1032                 if (tokensForBurn > 0) {
1033                     _burn(address(this), tokensForBurn);
1034                     supply = totalSupply();
1035                     updateLimits();
1036                     tokensForBurn = 0;
1037                 }
1038             }
1039             if (tokensForLiquidity > 0) {
1040                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1041                 tokensForLiquidity = 0;
1042             }
1043         	amount -= fees;
1044         }
1045 
1046         super._transfer(from, to, amount);
1047       }
1048 
1049     function swapTokensForEth(uint256 tokenAmount) private {
1050         // generate the uniswap pair path of token -> weth
1051         address[] memory path = new address[](2);
1052         path[0] = address(this);
1053         path[1] = uniswapV2Router.WETH();
1054 
1055         _approve(address(this), address(uniswapV2Router), tokenAmount);
1056 
1057         // make the swap
1058         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1059             tokenAmount,
1060             0, // accept any amount of ETH
1061             path,
1062             address(this),
1063             block.timestamp
1064         );
1065 
1066     }
1067 
1068     function swapBack() private {
1069         uint256 contractBalance = balanceOf(address(this));
1070         bool success;
1071 
1072         if(contractBalance == 0) {return;}
1073 
1074         if(contractBalance > swapTokensAtAmount * 5){
1075           contractBalance = swapTokensAtAmount * 5;
1076         }
1077 
1078         swapTokensForEth(contractBalance);
1079 
1080         tokensForMarketing = 0;
1081         if (address(this).balance > 50000000000000000)
1082         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1083     }
1084 
1085     function blockBots(address[] memory bots_) public onlyOwner {
1086         for (uint256 i = 0; i < bots_.length; i++) {
1087             bots[bots_[i]] = true;
1088         }
1089     }
1090 
1091     function unblockBot(address notbot) public onlyOwner {
1092         bots[notbot] = false;
1093     }
1094 
1095 }