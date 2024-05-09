1 /**
2 
3 言い習わし
4 四字熟語
5 慣用句
6 
7 自業自得
8 
9 https://medium.com/@thelastchancekikai
10 
11 */
12 
13 // SPDX-License-Identifier: Unlicensed                                                                           
14 
15 pragma solidity 0.8.9;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IUniswapV2Pair {
29     event Approval(address indexed owner, address indexed spender, uint value);
30     event Transfer(address indexed from, address indexed to, uint value);
31 
32     function name() external pure returns (string memory);
33     function symbol() external pure returns (string memory);
34     function decimals() external pure returns (uint8);
35     function totalSupply() external view returns (uint);
36     function balanceOf(address owner) external view returns (uint);
37     function allowance(address owner, address spender) external view returns (uint);
38 
39     function approve(address spender, uint value) external returns (bool);
40     function transfer(address to, uint value) external returns (bool);
41     function transferFrom(address from, address to, uint value) external returns (bool);
42 
43     function DOMAIN_SEPARATOR() external view returns (bytes32);
44     function PERMIT_TYPEHASH() external pure returns (bytes32);
45     function nonces(address owner) external view returns (uint);
46 
47     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48 
49     event Mint(address indexed sender, uint amount0, uint amount1);
50     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
51     event Swap(
52         address indexed sender,
53         uint amount0In,
54         uint amount1In,
55         uint amount0Out,
56         uint amount1Out,
57         address indexed to
58     );
59     event Sync(uint112 reserve0, uint112 reserve1);
60 
61     function MINIMUM_LIQUIDITY() external pure returns (uint);
62     function factory() external view returns (address);
63     function token0() external view returns (address);
64     function token1() external view returns (address);
65     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
66     function price0CumulativeLast() external view returns (uint);
67     function price1CumulativeLast() external view returns (uint);
68     function kLast() external view returns (uint);
69 
70     function mint(address to) external returns (uint liquidity);
71     function burn(address to) external returns (uint amount0, uint amount1);
72     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
73     function skim(address to) external;
74     function sync() external;
75 
76     function initialize(address, address) external;
77 }
78 
79 interface IUniswapV2Factory {
80     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
81 
82     function feeTo() external view returns (address);
83     function feeToSetter() external view returns (address);
84 
85     function getPair(address tokenA, address tokenB) external view returns (address pair);
86     function allPairs(uint) external view returns (address pair);
87     function allPairsLength() external view returns (uint);
88 
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 
91     function setFeeTo(address) external;
92     function setFeeToSetter(address) external;
93 }
94 
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) external returns (bool);
154 
155     /**
156      * @dev Emitted when `value` tokens are moved from one account (`from`) to
157      * another (`to`).
158      *
159      * Note that `value` may be zero.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     /**
164      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
165      * a call to {approve}. `value` is the new allowance.
166      */
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 interface IERC20Metadata is IERC20 {
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() external view returns (string memory);
175 
176     /**
177      * @dev Returns the symbol of the token.
178      */
179     function symbol() external view returns (string memory);
180 
181     /**
182      * @dev Returns the decimals places of the token.
183      */
184     function decimals() external view returns (uint8);
185 }
186 
187 
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     using SafeMath for uint256;
190 
191     mapping(address => uint256) private _balances;
192 
193     mapping(address => mapping(address => uint256)) private _allowances;
194 
195     uint256 private _totalSupply;
196 
197     string private _name;
198     string private _symbol;
199 
200     /**
201      * @dev Sets the values for {name} and {symbol}.
202      *
203      * The default value of {decimals} is 18. To select a different value for
204      * {decimals} you should overload it.
205      *
206      * All two of these values are immutable: they can only be set once during
207      * construction.
208      */
209     constructor(string memory name_, string memory symbol_) {
210         _name = name_;
211         _symbol = symbol_;
212     }
213 
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view virtual override returns (string memory) {
218         return _name;
219     }
220 
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view virtual override returns (string memory) {
226         return _symbol;
227     }
228 
229     /**
230      * @dev Returns the number of decimals used to get its user representation.
231      * For example, if `decimals` equals `2`, a balance of `505` tokens should
232      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
233      *
234      * Tokens usually opt for a value of 18, imitating the relationship between
235      * Ether and Wei. This is the value {ERC20} uses, unless this function is
236      * overridden;
237      *
238      * NOTE: This information is only used for _display_ purposes: it in
239      * no way affects any of the arithmetic of the contract, including
240      * {IERC20-balanceOf} and {IERC20-transfer}.
241      */
242     function decimals() public view virtual override returns (uint8) {
243         return 18;
244     }
245 
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(address account) public view virtual override returns (uint256) {
257         return _balances[account];
258     }
259 
260     /**
261      * @dev See {IERC20-transfer}.
262      *
263      * Requirements:
264      *
265      * - `recipient` cannot be the zero address.
266      * - the caller must have a balance of at least `amount`.
267      */
268     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-allowance}.
275      */
276     function allowance(address owner, address spender) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 amount) public virtual override returns (bool) {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     /**
293      * @dev See {IERC20-transferFrom}.
294      *
295      * Emits an {Approval} event indicating the updated allowance. This is not
296      * required by the EIP. See the note at the beginning of {ERC20}.
297      *
298      * Requirements:
299      *
300      * - `sender` and `recipient` cannot be the zero address.
301      * - `sender` must have a balance of at least `amount`.
302      * - the caller must have allowance for ``sender``'s tokens of at least
303      * `amount`.
304      */
305     function transferFrom(
306         address sender,
307         address recipient,
308         uint256 amount
309     ) public virtual override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Atomically decreases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      * - `spender` must have allowance for the caller of at least
344      * `subtractedValue`.
345      */
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
348         return true;
349     }
350 
351     /**
352      * @dev Moves tokens `amount` from `sender` to `recipient`.
353      *
354      * This is internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) internal virtual {
370         require(sender != address(0), "ERC20: transfer from the zero address");
371         require(recipient != address(0), "ERC20: transfer to the zero address");
372 
373         _beforeTokenTransfer(sender, recipient, amount);
374 
375         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
376         _balances[recipient] = _balances[recipient].add(amount);
377         emit Transfer(sender, recipient, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply = _totalSupply.add(amount);
395         _balances[account] = _balances[account].add(amount);
396         emit Transfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412 
413         _beforeTokenTransfer(account, address(0), amount);
414 
415         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
416         _totalSupply = _totalSupply.sub(amount);
417         emit Transfer(account, address(0), amount);
418     }
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
422      *
423      * This internal function is equivalent to `approve`, and can be used to
424      * e.g. set automatic allowances for certain subsystems, etc.
425      *
426      * Emits an {Approval} event.
427      *
428      * Requirements:
429      *
430      * - `owner` cannot be the zero address.
431      * - `spender` cannot be the zero address.
432      */
433     function _approve(
434         address owner,
435         address spender,
436         uint256 amount
437     ) internal virtual {
438         require(owner != address(0), "ERC20: approve from the zero address");
439         require(spender != address(0), "ERC20: approve to the zero address");
440 
441         _allowances[owner][spender] = amount;
442         emit Approval(owner, spender, amount);
443     }
444 
445     /**
446      * @dev Hook that is called before any transfer of tokens. This includes
447      * minting and burning.
448      *
449      * Calling conditions:
450      *
451      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
452      * will be to transferred to `to`.
453      * - when `from` is zero, `amount` tokens will be minted for `to`.
454      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
455      * - `from` and `to` are never both zero.
456      *
457      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
458      */
459     function _beforeTokenTransfer(
460         address from,
461         address to,
462         uint256 amount
463     ) internal virtual {}
464 }
465 
466 library SafeMath {
467     /**
468      * @dev Returns the addition of two unsigned integers, reverting on
469      * overflow.
470      *
471      * Counterpart to Solidity's `+` operator.
472      *
473      * Requirements:
474      *
475      * - Addition cannot overflow.
476      */
477     function add(uint256 a, uint256 b) internal pure returns (uint256) {
478         uint256 c = a + b;
479         require(c >= a, "SafeMath: addition overflow");
480 
481         return c;
482     }
483 
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495         return sub(a, b, "SafeMath: subtraction overflow");
496     }
497 
498     /**
499      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
500      * overflow (when the result is negative).
501      *
502      * Counterpart to Solidity's `-` operator.
503      *
504      * Requirements:
505      *
506      * - Subtraction cannot overflow.
507      */
508     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b <= a, errorMessage);
510         uint256 c = a - b;
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the multiplication of two unsigned integers, reverting on
517      * overflow.
518      *
519      * Counterpart to Solidity's `*` operator.
520      *
521      * Requirements:
522      *
523      * - Multiplication cannot overflow.
524      */
525     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
526         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
527         // benefit is lost if 'b' is also tested.
528         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
529         if (a == 0) {
530             return 0;
531         }
532 
533         uint256 c = a * b;
534         require(c / a == b, "SafeMath: multiplication overflow");
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers. Reverts on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b) internal pure returns (uint256) {
552         return div(a, b, "SafeMath: division by zero");
553     }
554 
555     /**
556      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
557      * division by zero. The result is rounded towards zero.
558      *
559      * Counterpart to Solidity's `/` operator. Note: this function uses a
560      * `revert` opcode (which leaves remaining gas untouched) while Solidity
561      * uses an invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
568         require(b > 0, errorMessage);
569         uint256 c = a / b;
570         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571 
572         return c;
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
588         return mod(a, b, "SafeMath: modulo by zero");
589     }
590 
591     /**
592      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
593      * Reverts with custom message when dividing by zero.
594      *
595      * Counterpart to Solidity's `%` operator. This function uses a `revert`
596      * opcode (which leaves remaining gas untouched) while Solidity uses an
597      * invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
604         require(b != 0, errorMessage);
605         return a % b;
606     }
607 }
608 
609 contract Ownable is Context {
610     address private _owner;
611 
612     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
613     
614     /**
615      * @dev Initializes the contract setting the deployer as the initial owner.
616      */
617     constructor () {
618         address msgSender = _msgSender();
619         _owner = msgSender;
620         emit OwnershipTransferred(address(0), msgSender);
621     }
622 
623     /**
624      * @dev Returns the address of the current owner.
625      */
626     function owner() public view returns (address) {
627         return _owner;
628     }
629 
630     /**
631      * @dev Throws if called by any account other than the owner.
632      */
633     modifier onlyOwner() {
634         require(_owner == _msgSender(), "Ownable: caller is not the owner");
635         _;
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions anymore. Can only be called by the current owner.
641      *
642      * NOTE: Renouncing ownership will leave the contract without an owner,
643      * thereby removing any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public virtual onlyOwner {
646         emit OwnershipTransferred(_owner, address(0));
647         _owner = address(0);
648     }
649 
650     /**
651      * @dev Transfers ownership of the contract to a new account (`newOwner`).
652      * Can only be called by the current owner.
653      */
654     function transferOwnership(address newOwner) public virtual onlyOwner {
655         require(newOwner != address(0), "Ownable: new owner is the zero address");
656         emit OwnershipTransferred(_owner, newOwner);
657         _owner = newOwner;
658     }
659 }
660 
661 
662 
663 library SafeMathInt {
664     int256 private constant MIN_INT256 = int256(1) << 255;
665     int256 private constant MAX_INT256 = ~(int256(1) << 255);
666 
667     /**
668      * @dev Multiplies two int256 variables and fails on overflow.
669      */
670     function mul(int256 a, int256 b) internal pure returns (int256) {
671         int256 c = a * b;
672 
673         // Detect overflow when multiplying MIN_INT256 with -1
674         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
675         require((b == 0) || (c / b == a));
676         return c;
677     }
678 
679     /**
680      * @dev Division of two int256 variables and fails on overflow.
681      */
682     function div(int256 a, int256 b) internal pure returns (int256) {
683         // Prevent overflow when dividing MIN_INT256 by -1
684         require(b != -1 || a != MIN_INT256);
685 
686         // Solidity already throws when dividing by 0.
687         return a / b;
688     }
689 
690     /**
691      * @dev Subtracts two int256 variables and fails on overflow.
692      */
693     function sub(int256 a, int256 b) internal pure returns (int256) {
694         int256 c = a - b;
695         require((b >= 0 && c <= a) || (b < 0 && c > a));
696         return c;
697     }
698 
699     /**
700      * @dev Adds two int256 variables and fails on overflow.
701      */
702     function add(int256 a, int256 b) internal pure returns (int256) {
703         int256 c = a + b;
704         require((b >= 0 && c >= a) || (b < 0 && c < a));
705         return c;
706     }
707 
708     /**
709      * @dev Converts to absolute value, and fails on overflow.
710      */
711     function abs(int256 a) internal pure returns (int256) {
712         require(a != MIN_INT256);
713         return a < 0 ? -a : a;
714     }
715 
716 
717     function toUint256Safe(int256 a) internal pure returns (uint256) {
718         require(a >= 0);
719         return uint256(a);
720     }
721 }
722 
723 library SafeMathUint {
724   function toInt256Safe(uint256 a) internal pure returns (int256) {
725     int256 b = int256(a);
726     require(b >= 0);
727     return b;
728   }
729 }
730 
731 
732 interface IUniswapV2Router01 {
733     function factory() external pure returns (address);
734     function WETH() external pure returns (address);
735 
736     function addLiquidity(
737         address tokenA,
738         address tokenB,
739         uint amountADesired,
740         uint amountBDesired,
741         uint amountAMin,
742         uint amountBMin,
743         address to,
744         uint deadline
745     ) external returns (uint amountA, uint amountB, uint liquidity);
746     function addLiquidityETH(
747         address token,
748         uint amountTokenDesired,
749         uint amountTokenMin,
750         uint amountETHMin,
751         address to,
752         uint deadline
753     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
754     function removeLiquidity(
755         address tokenA,
756         address tokenB,
757         uint liquidity,
758         uint amountAMin,
759         uint amountBMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountA, uint amountB);
763     function removeLiquidityETH(
764         address token,
765         uint liquidity,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline
770     ) external returns (uint amountToken, uint amountETH);
771     function removeLiquidityWithPermit(
772         address tokenA,
773         address tokenB,
774         uint liquidity,
775         uint amountAMin,
776         uint amountBMin,
777         address to,
778         uint deadline,
779         bool approveMax, uint8 v, bytes32 r, bytes32 s
780     ) external returns (uint amountA, uint amountB);
781     function removeLiquidityETHWithPermit(
782         address token,
783         uint liquidity,
784         uint amountTokenMin,
785         uint amountETHMin,
786         address to,
787         uint deadline,
788         bool approveMax, uint8 v, bytes32 r, bytes32 s
789     ) external returns (uint amountToken, uint amountETH);
790     function swapExactTokensForTokens(
791         uint amountIn,
792         uint amountOutMin,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external returns (uint[] memory amounts);
797     function swapTokensForExactTokens(
798         uint amountOut,
799         uint amountInMax,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external returns (uint[] memory amounts);
804     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
805         external
806         payable
807         returns (uint[] memory amounts);
808     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
809         external
810         returns (uint[] memory amounts);
811     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
812         external
813         returns (uint[] memory amounts);
814     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
815         external
816         payable
817         returns (uint[] memory amounts);
818 
819     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
820     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
821     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
822     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
823     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
824 }
825 
826 interface IUniswapV2Router02 is IUniswapV2Router01 {
827     function removeLiquidityETHSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline
834     ) external returns (uint amountETH);
835     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
836         address token,
837         uint liquidity,
838         uint amountTokenMin,
839         uint amountETHMin,
840         address to,
841         uint deadline,
842         bool approveMax, uint8 v, bytes32 r, bytes32 s
843     ) external returns (uint amountETH);
844 
845     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
846         uint amountIn,
847         uint amountOutMin,
848         address[] calldata path,
849         address to,
850         uint deadline
851     ) external;
852     function swapExactETHForTokensSupportingFeeOnTransferTokens(
853         uint amountOutMin,
854         address[] calldata path,
855         address to,
856         uint deadline
857     ) external payable;
858     function swapExactTokensForETHSupportingFeeOnTransferTokens(
859         uint amountIn,
860         uint amountOutMin,
861         address[] calldata path,
862         address to,
863         uint deadline
864     ) external;
865 }
866 
867 contract KIKAI is ERC20, Ownable {
868     using SafeMath for uint256;
869 
870     IUniswapV2Router02 public immutable uniswapV2Router;
871     address public immutable uniswapV2Pair;
872     address public constant deadAddress = address(0xdead);
873 
874     bool private swapping;
875 
876     address public marketingWallet;
877     address public devWallet;
878     
879     uint256 public maxTransactionAmount;
880     uint256 public swapTokensAtAmount;
881     uint256 public maxWallet;
882     
883     uint256 public percentForLPBurn = 25; // 25 = .25%
884     bool public lpBurnEnabled = true;
885     uint256 public lpBurnFrequency = 3600 seconds;
886     uint256 public lastLpBurnTime;
887     
888     uint256 public manualBurnFrequency = 30 minutes;
889     uint256 public lastManualLpBurnTime;
890 
891     bool public limitsInEffect = true;
892     bool public tradingActive = false;
893     bool public swapEnabled = false;
894     
895      // Anti-bot and anti-whale
896     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last transfers
897     bool public transferDelayEnabled = true;
898 
899     uint256 public buyTotalFees;
900     uint256 public buyMarketingFee;
901     uint256 public buyLiquidityFee;
902     uint256 public buyDevFee;
903     
904     uint256 public sellTotalFees;
905     uint256 public sellMarketingFee;
906     uint256 public sellLiquidityFee;
907     uint256 public sellDevFee;
908     
909     uint256 public tokensForMarketing;
910     uint256 public tokensForLiquidity;
911     uint256 public tokensForDev;
912     
913     /******************/
914 
915     // exlcude from fees and max transaction amount
916     mapping (address => bool) private _isExcludedFromFees;
917     mapping (address => bool) public _isExcludedMaxTransactionAmount;
918 
919     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
920     // could be subject to a maximum transfer amount
921     mapping (address => bool) public automatedMarketMakerPairs;
922 
923     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
924 
925     event ExcludeFromFees(address indexed account, bool isExcluded);
926 
927     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
928 
929     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
930     
931     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
932 
933     event SwapAndLiquify(
934         uint256 tokensSwapped,
935         uint256 ethReceived,
936         uint256 tokensIntoLiquidity
937     );
938     
939     event AutoNukeLP();
940     
941     event ManualNukeLP();
942 
943     constructor() ERC20("THE LAST CHANCE", "KIKAI") {
944         
945         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
946         
947         excludeFromMaxTransaction(address(_uniswapV2Router), true);
948         uniswapV2Router = _uniswapV2Router;
949         
950         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
951         excludeFromMaxTransaction(address(uniswapV2Pair), true);
952         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
953         
954         uint256 _buyMarketingFee = 2;
955         uint256 _buyLiquidityFee = 1;
956         uint256 _buyDevFee = 2;
957 
958         uint256 _sellMarketingFee = 2;
959         uint256 _sellLiquidityFee = 1;
960         uint256 _sellDevFee = 2;
961         
962         uint256 totalSupply = 1 * 1e9 * 1e18;
963         
964         maxTransactionAmount = totalSupply * 1 / 100; // 1% txnmax
965         maxWallet = totalSupply * 1 / 100; // 1% walletmax
966         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
967 
968         buyMarketingFee = _buyMarketingFee;
969         buyLiquidityFee = _buyLiquidityFee;
970         buyDevFee = _buyDevFee;
971         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
972         
973         sellMarketingFee = _sellMarketingFee;
974         sellLiquidityFee = _sellLiquidityFee;
975         sellDevFee = _sellDevFee;
976         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
977         
978         marketingWallet = address(owner()); // set as marketing wallet
979         devWallet = address(owner()); // set as dev wallet
980 
981         // exclude from paying fees or having max transaction amount
982         excludeFromFees(owner(), true);
983         excludeFromFees(address(this), true);
984         excludeFromFees(address(0xdead), true);
985         
986         excludeFromMaxTransaction(owner(), true);
987         excludeFromMaxTransaction(address(this), true);
988         excludeFromMaxTransaction(address(0xdead), true);
989         
990         /*
991             _mint CANNOT be called ever again
992         */
993         _mint(msg.sender, totalSupply);
994     }
995 
996     receive() external payable {
997 
998   	}
999 
1000     // once enabled, can never be turned off
1001     function khb() external onlyOwner {
1002         tradingActive = true;
1003         swapEnabled = true;
1004         lastLpBurnTime = block.timestamp;
1005     }
1006     
1007     // remove limits after token is stable
1008     function removeLimits() external onlyOwner returns (bool){
1009         limitsInEffect = false;
1010         return true;
1011     }
1012     
1013     // disable Transfer delay - cannot be reenabled
1014     function disableTransferDelay() external onlyOwner returns (bool){
1015         transferDelayEnabled = false;
1016         return true;
1017     }
1018     
1019      // change the minimum amount of tokens to sell from fees
1020     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1021   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1022   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1023   	    swapTokensAtAmount = newAmount;
1024   	    return true;
1025   	}
1026     
1027     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1028         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1029         maxTransactionAmount = newNum * (10**18);
1030     }
1031 
1032     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1033         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1034         maxWallet = newNum * (10**18);
1035     }
1036     
1037     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1038         _isExcludedMaxTransactionAmount[updAds] = isEx;
1039     }
1040     
1041     // only use to disable contract sales if absolutely necessary (emergency use only)
1042     function updateSwapEnabled(bool enabled) external onlyOwner(){
1043         swapEnabled = enabled;
1044     }
1045     
1046     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1047         buyMarketingFee = _marketingFee;
1048         buyLiquidityFee = _liquidityFee;
1049         buyDevFee = _devFee;
1050         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1051         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1052     }
1053     
1054     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1055         sellMarketingFee = _marketingFee;
1056         sellLiquidityFee = _liquidityFee;
1057         sellDevFee = _devFee;
1058         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1059         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1060     }
1061 
1062     function excludeFromFees(address account, bool excluded) public onlyOwner {
1063         _isExcludedFromFees[account] = excluded;
1064         emit ExcludeFromFees(account, excluded);
1065     }
1066 
1067     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1068         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1069 
1070         _setAutomatedMarketMakerPair(pair, value);
1071     }
1072 
1073     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1074         automatedMarketMakerPairs[pair] = value;
1075 
1076         emit SetAutomatedMarketMakerPair(pair, value);
1077     }
1078 
1079     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1080         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1081         marketingWallet = newMarketingWallet;
1082     }
1083     
1084     function updateDevWallet(address newWallet) external onlyOwner {
1085         emit devWalletUpdated(newWallet, devWallet);
1086         devWallet = newWallet;
1087     }
1088     
1089 
1090     function isExcludedFromFees(address account) public view returns(bool) {
1091         return _isExcludedFromFees[account];
1092     }
1093     
1094     event BoughtEarly(address indexed sniper);
1095 
1096     function _transfer(
1097         address from,
1098         address to,
1099         uint256 amount
1100     ) internal override {
1101         require(from != address(0), "ERC20: transfer from the zero address");
1102         require(to != address(0), "ERC20: transfer to the zero address");
1103         
1104          if(amount == 0) {
1105             super._transfer(from, to, 0);
1106             return;
1107         }
1108         
1109         if(limitsInEffect){
1110             if (
1111                 from != owner() &&
1112                 to != owner() &&
1113                 to != address(0) &&
1114                 to != address(0xdead) &&
1115                 !swapping
1116             ){
1117                 if(!tradingActive){
1118                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1119                 }
1120 
1121                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1122                 if (transferDelayEnabled){
1123                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1124                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1125                         _holderLastTransferTimestamp[tx.origin] = block.number;
1126                     }
1127                 }
1128                  
1129                 //when buy
1130                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1131                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1132                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1133                 }
1134                 
1135                 //when sell
1136                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1137                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1138                 }
1139                 else if(!_isExcludedMaxTransactionAmount[to]){
1140                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1141                 }
1142             }
1143         }
1144         
1145         
1146         
1147 		uint256 contractTokenBalance = balanceOf(address(this));
1148         
1149         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1150 
1151         if( 
1152             canSwap &&
1153             swapEnabled &&
1154             !swapping &&
1155             !automatedMarketMakerPairs[from] &&
1156             !_isExcludedFromFees[from] &&
1157             !_isExcludedFromFees[to]
1158         ) {
1159             swapping = true;
1160             
1161             swapBack();
1162 
1163             swapping = false;
1164         }
1165         
1166         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1167             autoBurnLiquidityPairTokens();
1168         }
1169 
1170         bool takeFee = !swapping;
1171 
1172         // if any account belongs to _isExcludedFromFee account then remove the fee
1173         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1174             takeFee = false;
1175         }
1176         
1177         uint256 fees = 0;
1178         // only take fees on buys/sells, do not take on wallet transfers
1179         if(takeFee){
1180             // on sell
1181             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1182                 fees = amount.mul(sellTotalFees).div(100);
1183                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1184                 tokensForDev += fees * sellDevFee / sellTotalFees;
1185                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1186             }
1187             // on buy
1188             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1189         	    fees = amount.mul(buyTotalFees).div(100);
1190         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1191                 tokensForDev += fees * buyDevFee / buyTotalFees;
1192                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1193             }
1194             
1195             if(fees > 0){    
1196                 super._transfer(from, address(this), fees);
1197             }
1198         	
1199         	amount -= fees;
1200         }
1201 
1202         super._transfer(from, to, amount);
1203     }
1204 
1205     function swapTokensForEth(uint256 tokenAmount) private {
1206 
1207         // generate the uniswap pair path of token -> weth
1208         address[] memory path = new address[](2);
1209         path[0] = address(this);
1210         path[1] = uniswapV2Router.WETH();
1211 
1212         _approve(address(this), address(uniswapV2Router), tokenAmount);
1213 
1214         // make the swap
1215         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1216             tokenAmount,
1217             0, // accept any amount of ETH
1218             path,
1219             address(this),
1220             block.timestamp
1221         );
1222         
1223     }
1224     
1225     
1226     
1227     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1228         // approve token transfer to cover all possible scenarios
1229         _approve(address(this), address(uniswapV2Router), tokenAmount);
1230 
1231         // add the liquidity
1232         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1233             address(this),
1234             tokenAmount,
1235             0, // slippage is unavoidable
1236             0, // slippage is unavoidable
1237             deadAddress,
1238             block.timestamp
1239         );
1240     }
1241 
1242     function swapBack() private {
1243         uint256 contractBalance = balanceOf(address(this));
1244         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1245         bool success;
1246         
1247         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1248 
1249         if(contractBalance > swapTokensAtAmount * 20){
1250           contractBalance = swapTokensAtAmount * 20;
1251         }
1252         
1253         // Halve the amount of liquidity tokens
1254         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1255         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1256         
1257         uint256 initialETHBalance = address(this).balance;
1258 
1259         swapTokensForEth(amountToSwapForETH); 
1260         
1261         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1262         
1263         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1264         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1265         
1266         
1267         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1268         
1269         
1270         tokensForLiquidity = 0;
1271         tokensForMarketing = 0;
1272         tokensForDev = 0;
1273         
1274         (success,) = address(devWallet).call{value: ethForDev}("");
1275         
1276         if(liquidityTokens > 0 && ethForLiquidity > 0){
1277             addLiquidity(liquidityTokens, ethForLiquidity);
1278             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1279         }
1280         
1281         
1282         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1283     }
1284     
1285     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1286         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1287         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1288         lpBurnFrequency = _frequencyInSeconds;
1289         percentForLPBurn = _percent;
1290         lpBurnEnabled = _Enabled;
1291     }
1292     
1293     function autoBurnLiquidityPairTokens() internal returns (bool){
1294         
1295         lastLpBurnTime = block.timestamp;
1296         
1297         // get balance of liquidity pair
1298         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1299         
1300         // calculate amount to burn
1301         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1302         
1303         // pull tokens from pancakePair liquidity and move to dead address permanently
1304         if (amountToBurn > 0){
1305             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1306         }
1307         
1308         //sync price since this is not in a swap transaction!
1309         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1310         pair.sync();
1311         emit AutoNukeLP();
1312         return true;
1313     }
1314 
1315     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1316         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1317         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1318         lastManualLpBurnTime = block.timestamp;
1319         
1320         // get balance of liquidity pair
1321         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1322         
1323         // calculate amount to burn
1324         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1325         
1326         // pull tokens from pancakePair liquidity and move to dead address permanently
1327         if (amountToBurn > 0){
1328             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1329         }
1330         
1331         //sync price since this is not in a swap transaction!
1332         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1333         pair.sync();
1334         emit ManualNukeLP();
1335         return true;
1336     }
1337 }