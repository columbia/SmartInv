1 // SPDX-License-Identifier: MIT
2 
3 /**
4 Https://DeathWolf.io
5 Https://T.me/DeathWolfLair
6 */
7 
8 pragma solidity = 0.8.16;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24 
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31 
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35 
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39 
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41 
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53 
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62 
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68 
69     function initialize(address, address) external;
70 }
71 
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74 
75     function feeTo() external view returns (address);
76     function feeToSetter() external view returns (address);
77 
78     function getPair(address tokenA, address tokenB) external view returns (address pair);
79     function allPairs(uint) external view returns (address pair);
80     function allPairsLength() external view returns (uint);
81 
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83 
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87 
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 interface IERC20Metadata is IERC20 {
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() external view returns (string memory);
168 
169     /**
170      * @dev Returns the symbol of the token.
171      */
172     function symbol() external view returns (string memory);
173 
174     /**
175      * @dev Returns the decimals places of the token.
176      */
177     function decimals() external view returns (uint8);
178 }
179 
180 
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     using SafeMath for uint256;
183 
184     mapping(address => uint256) private _balances;
185 
186     mapping(address => mapping(address => uint256)) private _allowances;
187 
188     uint256 private _totalSupply;
189 
190     string private _name;
191     string private _symbol;
192 
193     /**
194      * @dev Sets the values for {name} and {symbol}.
195      *
196      * The default value of {decimals} is 18. To select a different value for
197      * {decimals} you should overload it.
198      *
199      * All two of these values are immutable: they can only be set once during
200      * construction.
201      */
202     constructor(string memory name_, string memory symbol_) {
203         _name = name_;
204         _symbol = symbol_;
205     }
206 
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() public view virtual override returns (string memory) {
211         return _name;
212     }
213 
214     /**
215      * @dev Returns the symbol of the token, usually a shorter version of the
216      * name.
217      */
218     function symbol() public view virtual override returns (string memory) {
219         return _symbol;
220     }
221 
222     /**
223      * @dev Returns the number of decimals used to get its user representation.
224      * For example, if `decimals` equals `2`, a balance of `505` tokens should
225      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
226      *
227      * Tokens usually opt for a value of 18, imitating the relationship between
228      * Ether and Wei. This is the value {ERC20} uses, unless this function is
229      * overridden;
230      *
231      * NOTE: This information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * {IERC20-balanceOf} and {IERC20-transfer}.
234      */
235     function decimals() public view virtual override returns (uint8) {
236         return 18;
237     }
238 
239     /**
240      * @dev See {IERC20-totalSupply}.
241      */
242     function totalSupply() public view virtual override returns (uint256) {
243         return _totalSupply;
244     }
245 
246     /**
247      * @dev See {IERC20-balanceOf}.
248      */
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     /**
254      * @dev See {IERC20-transfer}.
255      *
256      * Requirements:
257      *
258      * - `recipient` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-allowance}.
268      */
269     function allowance(address owner, address spender) public view virtual override returns (uint256) {
270         return _allowances[owner][spender];
271     }
272 
273     /**
274      * @dev See {IERC20-approve}.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * Requirements:
292      *
293      * - `sender` and `recipient` cannot be the zero address.
294      * - `sender` must have a balance of at least `amount`.
295      * - the caller must have allowance for ``sender``'s tokens of at least
296      * `amount`.
297      */
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) public virtual override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
341         return true;
342     }
343 
344     /**
345      * @dev Moves tokens `amount` from `sender` to `recipient`.
346      *
347      * This is internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) internal virtual {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(sender, recipient, amount);
367 
368         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
369         _balances[recipient] = _balances[recipient].add(amount);
370         emit Transfer(sender, recipient, amount);
371     }
372 
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _beforeTokenTransfer(address(0), account, amount);
386 
387         _totalSupply = _totalSupply.add(amount);
388         _balances[account] = _balances[account].add(amount);
389         emit Transfer(address(0), account, amount);
390     }
391 
392     /**
393      * @dev Destroys `amount` tokens from `account`, reducing the
394      * total supply.
395      *
396      * Emits a {Transfer} event with `to` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      * - `account` must have at least `amount` tokens.
402      */
403     function _burn(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: burn from the zero address");
405 
406         _beforeTokenTransfer(account, address(0), amount);
407 
408         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
409         _totalSupply = _totalSupply.sub(amount);
410         emit Transfer(account, address(0), amount);
411     }
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be to transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 }
458 
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      *
468      * - Addition cannot overflow.
469      */
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473 
474         return c;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's `-` operator.
482      *
483      * Requirements:
484      *
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         return sub(a, b, "SafeMath: subtraction overflow");
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         uint256 c = a - b;
504 
505         return c;
506     }
507 
508     /**
509      * @dev Returns the multiplication of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `*` operator.
513      *
514      * Requirements:
515      *
516      * - Multiplication cannot overflow.
517      */
518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
519         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520         // benefit is lost if 'b' is also tested.
521         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
522         if (a == 0) {
523             return 0;
524         }
525 
526         uint256 c = a * b;
527         require(c / a == b, "SafeMath: multiplication overflow");
528 
529         return c;
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         return div(a, b, "SafeMath: division by zero");
546     }
547 
548     /**
549      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
550      * division by zero. The result is rounded towards zero.
551      *
552      * Counterpart to Solidity's `/` operator. Note: this function uses a
553      * `revert` opcode (which leaves remaining gas untouched) while Solidity
554      * uses an invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
561         require(b > 0, errorMessage);
562         uint256 c = a / b;
563         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
581         return mod(a, b, "SafeMath: modulo by zero");
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * Reverts with custom message when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b != 0, errorMessage);
598         return a % b;
599     }
600 }
601 
602 contract Ownable is Context {
603     address private _owner;
604 
605     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606 
607     /**
608      * @dev Initializes the contract setting the deployer as the initial owner.
609      */
610     constructor () {
611         address msgSender = _msgSender();
612         _owner = msgSender;
613         emit OwnershipTransferred(address(0), msgSender);
614     }
615 
616     /**
617      * @dev Returns the address of the current owner.
618      */
619     function owner() public view returns (address) {
620         return _owner;
621     }
622 
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         require(_owner == _msgSender(), "Ownable: caller is not the owner");
628         _;
629     }
630 
631     /**
632      * @dev Leaves the contract without owner. It will not be possible to call
633      * `onlyOwner` functions anymore. Can only be called by the current owner.
634      *
635      * NOTE: Renouncing ownership will leave the contract without an owner,
636      * thereby removing any functionality that is only available to the owner.
637      */
638     function renounceOwnership() public virtual onlyOwner {
639         emit OwnershipTransferred(_owner, address(0));
640         _owner = address(0);
641     }
642 
643     /**
644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
645      * Can only be called by the current owner.
646      */
647     function transferOwnership(address newOwner) public virtual onlyOwner {
648         require(newOwner != address(0), "Ownable: new owner is the zero address");
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653 
654 library SafeMathInt {
655     int256 private constant MIN_INT256 = int256(1) << 255;
656     int256 private constant MAX_INT256 = ~(int256(1) << 255);
657 
658     /**
659      * @dev Multiplies two int256 variables and fails on overflow.
660      */
661     function mul(int256 a, int256 b) internal pure returns (int256) {
662         int256 c = a * b;
663 
664         // Detect overflow when multiplying MIN_INT256 with -1
665         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
666         require((b == 0) || (c / b == a));
667         return c;
668     }
669 
670     /**
671      * @dev Division of two int256 variables and fails on overflow.
672      */
673     function div(int256 a, int256 b) internal pure returns (int256) {
674         // Prevent overflow when dividing MIN_INT256 by -1
675         require(b != -1 || a != MIN_INT256);
676 
677         // Solidity already throws when dividing by 0.
678         return a / b;
679     }
680 
681     /**
682      * @dev Subtracts two int256 variables and fails on overflow.
683      */
684     function sub(int256 a, int256 b) internal pure returns (int256) {
685         int256 c = a - b;
686         require((b >= 0 && c <= a) || (b < 0 && c > a));
687         return c;
688     }
689 
690     /**
691      * @dev Adds two int256 variables and fails on overflow.
692      */
693     function add(int256 a, int256 b) internal pure returns (int256) {
694         int256 c = a + b;
695         require((b >= 0 && c >= a) || (b < 0 && c < a));
696         return c;
697     }
698 
699     /**
700      * @dev Converts to absolute value, and fails on overflow.
701      */
702     function abs(int256 a) internal pure returns (int256) {
703         require(a != MIN_INT256);
704         return a < 0 ? -a : a;
705     }
706 
707 
708     function toUint256Safe(int256 a) internal pure returns (uint256) {
709         require(a >= 0);
710         return uint256(a);
711     }
712 }
713 
714 library SafeMathUint {
715   function toInt256Safe(uint256 a) internal pure returns (int256) {
716     int256 b = int256(a);
717     require(b >= 0);
718     return b;
719   }
720 }
721 
722 interface IUniswapV2Router01 {
723     function factory() external pure returns (address);
724     function WETH() external pure returns (address);
725 
726     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
727         external
728         returns (uint[] memory amounts);
729 }
730 
731 interface IUniswapV2Router02 is IUniswapV2Router01 {
732     function swapExactTokensForETHSupportingFeeOnTransferTokens(
733         uint amountIn,
734         uint amountOutMin,
735         address[] calldata path,
736         address to,
737         uint deadline
738     ) external;
739 }
740 
741 pragma solidity >= 0.8.16;
742 
743 contract DeathWolf is ERC20, Ownable {
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
755     uint256 public maxWallet;
756 
757     uint256 public supply;
758 
759     address public MKTG_DEV_CEXAddress;
760 
761     bool public tradingActive = false;
762     bool public liquidityFeeActive = false;
763     bool public transferDelayActive = true;
764 
765     bool public limitsInEffect = true;
766     bool public swapEnabled = true;
767 
768     bool public _renounceDelayFunction = false;
769     bool public _renounceFeeFunctions = false;
770     bool public _renounceMaxUpdateFunctions = false;
771     bool public _renounceMarketMakerPairChanges = false;
772     bool public _renounceWalletChanges = false;
773     bool public _renounceExcludeInclude = false;
774 
775     mapping(address => uint256) private _holderLastTransferTimestamp;
776 
777     uint256 public buyBurnFee;
778     uint256 public buyMKTG_DEV_CEXFee;
779     uint256 public buyLiquidityFee;
780     uint256 public buyTotalFees;
781 
782     uint256 public sellBurnFee;
783     uint256 public sellMKTG_DEV_CEXFee;
784     uint256 public sellLiquidityFee;
785     uint256 public sellTotalFees;
786 
787     uint256 public feeUnits = 100;
788 
789     uint256 public tokensForBurn;
790     uint256 public tokensForMKTG_DEV_CEX;
791     uint256 public tokensForLiquidity;
792 
793     uint256 private _previousBuyLiquidityFee = 0;
794     uint256 private _previousSellLiquidityFee = 0;
795 
796     uint256 public maxWalletTotal;
797     uint256 public maxSellTransaction;
798     uint256 public walletTransferDelayTime;
799 
800     /******************/
801 
802     // exlcude from fees and max transaction amount
803     mapping (address => bool) private _isExcludedFromFees;
804     mapping (address => bool) public _isExcludedMaxSellTransactionAmount;
805 
806     // Store the automatic market maker pair addresses. Any transfer *to* these addresses
807     // could be subject to a maximum transfer amount
808     mapping (address => bool) public automatedMarketMakerPairs;
809 
810     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
811 
812     event ExcludeFromFees(address indexed account, bool isExcluded);
813 
814     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
815     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
816     event updateHolderLastTransferTimestamp(address indexed account, uint256 timestamp);
817 
818 
819     constructor() ERC20("DeathWolf", "DTH") {
820 
821         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
822 
823         excludeFromMaxSellTransaction(address(_uniswapV2Router), true);
824         uniswapV2Router = _uniswapV2Router;
825 
826         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
827         excludeFromMaxSellTransaction(address(uniswapV2Pair), true);
828         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
829 
830         uint256 _buyBurnFee = 1;
831         uint256 _buyMKTG_DEV_CEXFee = 6;
832         uint256 _buyLiquidityFee = 2;
833 
834         uint256 _sellBurnFee = 1;
835         uint256 _sellMKTG_DEV_CEXFee = 6;
836         uint256 _sellLiquidityFee = 2;
837 
838         uint256 totalSupply = 666666666 * (10 ** 18);
839         supply += totalSupply;
840 
841         maxWallet = 2;
842         maxSellTransaction = 1;
843         walletTransferDelayTime = 0;
844 
845         maxSellTransactionAmount = supply * maxSellTransaction / 100;
846         swapTokensAtAmount = supply * 5 / 1000000; 
847         maxWalletTotal = supply * maxWallet / 100;
848 
849         buyBurnFee = _buyBurnFee;
850         buyMKTG_DEV_CEXFee = _buyMKTG_DEV_CEXFee;
851         buyLiquidityFee = _buyLiquidityFee;
852         buyTotalFees = buyBurnFee + buyMKTG_DEV_CEXFee + buyLiquidityFee;
853 
854         sellBurnFee = _sellBurnFee;
855         sellMKTG_DEV_CEXFee = _sellMKTG_DEV_CEXFee;
856         sellLiquidityFee = _sellLiquidityFee;
857         sellTotalFees = sellBurnFee + sellMKTG_DEV_CEXFee + sellLiquidityFee;
858 
859         MKTG_DEV_CEXAddress = 0xbfE203e9De6b8D827d7De4aa418DD4c488078BFD;
860 
861         excludeFromFees(owner(), true);
862         excludeFromFees(address(this), true);
863         excludeFromFees(address(0xdead), true);
864 
865         excludeFromMaxSellTransaction(owner(), true);
866         excludeFromMaxSellTransaction(address(this), true);
867         excludeFromMaxSellTransaction(address(0xdead), true);
868 
869         _approve(owner(), address(uniswapV2Router), totalSupply);
870         _mint(msg.sender, totalSupply);
871     }
872 
873     receive() external payable {}
874 
875     function toggleTransferDelayActive () external onlyOwner {
876       require(!_renounceDelayFunction, "Cannot update wallet transfer delay time after renouncement");
877         transferDelayActive = !transferDelayActive;
878     }
879 
880     function toggleLiquidityFeeActive () external onlyOwner {
881       require(!_renounceFeeFunctions, "Cannot update fees after renouncemennt");
882         if (liquidityFeeActive) {
883         _previousBuyLiquidityFee = buyLiquidityFee;
884         _previousSellLiquidityFee = sellLiquidityFee;
885         }
886         buyLiquidityFee = liquidityFeeActive ? 0 : _previousBuyLiquidityFee;
887         sellLiquidityFee = liquidityFeeActive ? 0 : _previousSellLiquidityFee;
888         liquidityFeeActive = !liquidityFeeActive;
889     }
890 
891     function enableTrading() external onlyOwner {
892         buyBurnFee = 1;
893         buyMKTG_DEV_CEXFee = 97;
894         buyLiquidityFee = 1;
895         buyTotalFees = buyBurnFee + buyMKTG_DEV_CEXFee + buyLiquidityFee;
896 
897         sellBurnFee = 1;
898         sellMKTG_DEV_CEXFee = 97;
899         sellLiquidityFee = 1;
900         sellTotalFees = sellBurnFee + sellMKTG_DEV_CEXFee + sellLiquidityFee;
901 
902         walletTransferDelayTime = 60;
903 
904         tradingActive = true;
905         liquidityFeeActive = true;
906     }
907 
908     function updateMaxSellTransaction(uint256 newNum) external onlyOwner {
909       require(!_renounceMaxUpdateFunctions, "Cannot update max transaction amount after renouncement");
910         require(newNum >= 1);
911         maxSellTransaction = newNum;
912         updateLimits();
913     }
914 
915     function updateMaxWallet(uint256 newNum) external onlyOwner {
916       require(!_renounceMaxUpdateFunctions, "Cannot update max transaction amount after renouncement");
917         require(newNum >= 1);
918         maxWallet = newNum;
919         updateLimits();
920     }
921 
922     function updateWalletTransferDelayTime(uint256 newNum) external onlyOwner{
923       require(!_renounceDelayFunction, "Cannot update wallet transfer delay time after renouncement");
924         walletTransferDelayTime = newNum;
925     }
926 
927     function excludeFromMaxSellTransaction(address updAds, bool isEx) public onlyOwner {
928       require(!_renounceMaxUpdateFunctions, "Cannot update max transaction amount after renouncement");
929         _isExcludedMaxSellTransactionAmount[updAds] = isEx;
930     }
931 
932     // if want fractional % in future, need to increase the fee units
933     function updateFeeUnits(uint256 newNum) external onlyOwner {
934       require(!_renounceFeeFunctions, "Cannot update fees after renouncement");
935         feeUnits = newNum;
936     }
937 
938     function updateBuyFees(uint256 _burnFee, uint256 _MKTG_DEV_CEXFee, uint256 _buyLiquidityFee) external onlyOwner {
939       require(!_renounceFeeFunctions, "Cannot update fees after renouncement");
940         buyBurnFee = _burnFee;
941         buyMKTG_DEV_CEXFee = _MKTG_DEV_CEXFee;
942         buyLiquidityFee = _buyLiquidityFee;
943         buyTotalFees = buyBurnFee + buyMKTG_DEV_CEXFee + buyLiquidityFee;
944         require(buyTotalFees <= (feeUnits/15), "Buy fees must be 15% or less");
945     }
946 
947     function updateSellFees(uint256 _burnFee, uint256 _MKTG_DEV_CEXFee, uint256 _sellLiquidityFee) external onlyOwner {
948       require(!_renounceFeeFunctions, "Cannot update fees after renouncement");
949         sellBurnFee = _burnFee;
950         sellMKTG_DEV_CEXFee = _MKTG_DEV_CEXFee;
951         sellLiquidityFee = _sellLiquidityFee;
952         sellTotalFees = sellBurnFee + sellMKTG_DEV_CEXFee + sellLiquidityFee;
953         require(sellTotalFees <= (feeUnits/25), "Sell fees must be 25% or less");
954     }
955 
956     function updateMKTG_DEV_CEXAddress(address newWallet) external onlyOwner {
957       require(!_renounceWalletChanges, "Cannot update wallet after renouncement");
958         MKTG_DEV_CEXAddress = newWallet;
959     }
960 
961     function excludeFromFees(address account, bool excluded) public onlyOwner {
962       require(!_renounceExcludeInclude, "Cannot update excluded accounts after renouncement");
963         _isExcludedFromFees[account] = excluded;
964         emit ExcludeFromFees(account, excluded);
965     }
966 
967     function includeInFees(address account) public onlyOwner {
968       require(!_renounceExcludeInclude, "Cannot update excluded accounts after renouncement");
969         excludeFromFees(account, false);
970     }
971 
972     function setLiquidityAddress(address newAddress) public onlyOwner {
973       require(!_renounceWalletChanges, "Cannot update wallet after renouncement");
974         liquidityAddress = newAddress;
975     }
976 
977     function updateLimits() private {
978         maxSellTransactionAmount = supply * maxSellTransaction / 100;
979         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
980         maxWalletTotal = supply * maxWallet / 100;
981     }
982 
983     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
984       require(!_renounceMarketMakerPairChanges, "Cannot update market maker pairs after renouncement");
985         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
986 
987         _setAutomatedMarketMakerPair(pair, value);
988     }
989 
990     function _setAutomatedMarketMakerPair(address pair, bool value) private {
991         automatedMarketMakerPairs[pair] = value;
992 
993         emit SetAutomatedMarketMakerPair(pair, value);
994     }
995 
996     function isExcludedFromFees(address account) public view returns(bool) {
997         return _isExcludedFromFees[account];
998     }
999 
1000     function _transfer(
1001         address from,
1002         address to,
1003         uint256 amount
1004     ) internal override {
1005         require(from != address(0), "ERC20: transfer from the zero address");
1006         require(to != address(0), "ERC20: transfer to the zero address");
1007 
1008          if(amount == 0) {
1009             super._transfer(from, to, 0);
1010             return;
1011         }
1012 
1013         if(limitsInEffect){
1014             if (
1015                 from != owner() &&
1016                 to != owner() &&
1017                 to != address(0) &&
1018                 to != address(0xdead) &&
1019                 !swapping
1020             ){
1021                 if(!tradingActive){
1022                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1023                 }
1024 
1025                 // if the transfer delay is enabled, will block adding to liquidity/sells (transactions to AMM pair)
1026                 if (transferDelayActive && automatedMarketMakerPairs[to]) {
1027                         require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + walletTransferDelayTime, "Transfer delay is active.Only one sell per ~walletTransferDelayTime~ allowed.");
1028                 }
1029 
1030                 // add the wallet to the _holderLastTransferTimestamp(address, timestamp) map
1031                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
1032                 emit updateHolderLastTransferTimestamp(tx.origin, block.timestamp);
1033 
1034                 //when buy
1035                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxSellTransactionAmount[to] && !automatedMarketMakerPairs[to]){
1036                         require(amount + balanceOf(to) <= maxWalletTotal, "Max wallet exceeded");
1037                 }
1038 
1039                 //when sell
1040                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxSellTransactionAmount[from] && !automatedMarketMakerPairs[from]){
1041                         require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
1042                 }
1043                 else if(!_isExcludedMaxSellTransactionAmount[to]){
1044                     require(amount + balanceOf(to) <= maxWalletTotal, "Max wallet exceeded");
1045                 }
1046             }
1047         }
1048         uint256 contractTokenBalance = balanceOf(address(this));
1049 
1050         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1051 
1052         if(
1053             canSwap &&
1054             !swapping &&
1055             swapEnabled &&
1056             !automatedMarketMakerPairs[from] &&
1057             !_isExcludedFromFees[from] &&
1058             !_isExcludedFromFees[to]
1059         ) {
1060             swapping = true;
1061 
1062             swapBack();
1063 
1064             swapping = false;
1065         }
1066 
1067         bool takeFee = !swapping;
1068 
1069         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1070             takeFee = false;
1071         }
1072 
1073         uint256 fees = 0;
1074 
1075         if(takeFee){
1076             // on sell
1077             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1078                 fees = amount.mul(sellTotalFees).div(feeUnits);
1079                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1080                 tokensForMKTG_DEV_CEX += fees * sellMKTG_DEV_CEXFee / sellTotalFees;
1081                 if (liquidityFeeActive) {
1082                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1083                 }
1084             }
1085 
1086             // on buy
1087             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1088         	    fees = amount.mul(buyTotalFees).div(feeUnits);
1089         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1090                 tokensForMKTG_DEV_CEX += fees * buyMKTG_DEV_CEXFee / buyTotalFees;
1091                 if (liquidityFeeActive) {
1092                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1093                 }
1094             }
1095 
1096             if(fees > 0){
1097                 super._transfer(from, address(this), fees);
1098                 if (tokensForBurn > 0) {
1099                     _burn(address(this), tokensForBurn);
1100                     supply = totalSupply();
1101                     updateLimits();
1102                     tokensForBurn = 0;
1103                 }
1104             }
1105             if (tokensForLiquidity > 0) {
1106                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1107                 tokensForLiquidity = 0;
1108             }
1109         	amount -= fees;
1110         }
1111 
1112         super._transfer(from, to, amount);
1113       }
1114 
1115     function renounceFeeFunctions () public onlyOwner {
1116         require(msg.sender == owner(), "Only the owner can renounce fee functions");
1117         _renounceFeeFunctions = true;
1118     }
1119 
1120     function renounceDelayFunction () public onlyOwner {
1121         require(msg.sender == owner(), "Only the owner can renounce delay function");
1122         _renounceDelayFunction = true;
1123     }
1124 
1125     function renounceWalletChanges () public onlyOwner {
1126         require(msg.sender == owner(), "Only the owner can renounce wallet changes");
1127         _renounceWalletChanges = true;
1128     }
1129 
1130     function renounceMaxUpdateFunctions () public onlyOwner {
1131         require(msg.sender == owner(), "Only the owner can renounce max update functions");
1132         _renounceMaxUpdateFunctions = true;
1133     }
1134 
1135     function renounceMarketMakerPairChanges () public onlyOwner {
1136         require(msg.sender == owner(), "Only the owner can renounce market maker pair changes");
1137         _renounceMarketMakerPairChanges = true;
1138     }
1139 
1140     function renounceExcludeInclude () public onlyOwner {
1141         require(msg.sender == owner(), "Only the owner can renounce exclude include");
1142         _renounceExcludeInclude = true;
1143     }
1144 
1145     function swapTokensForEth(uint256 tokenAmount) private {
1146         // generate the uniswap pair path of token -> weth
1147         address[] memory path = new address[](2);
1148         path[0] = address(this);
1149         path[1] = uniswapV2Router.WETH();
1150 
1151         _approve(address(this), address(uniswapV2Router), tokenAmount);
1152 
1153         // make the swap
1154         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1155             tokenAmount,
1156             0, // accept any amount of ETH
1157             path,
1158             address(this),
1159             block.timestamp
1160         );
1161 
1162     }
1163 
1164     function swapBack() private {
1165         uint256 contractBalance = balanceOf(address(this));
1166         bool success;
1167 
1168         if(contractBalance == 0) {return;}
1169 
1170         if(contractBalance > swapTokensAtAmount * 20){
1171           contractBalance = swapTokensAtAmount * 20;
1172         }
1173 
1174         swapTokensForEth(contractBalance);
1175 
1176         tokensForMKTG_DEV_CEX = 0;
1177 
1178         (success,) = address(MKTG_DEV_CEXAddress).call{value: address(this).balance}("");
1179     }
1180 
1181 }