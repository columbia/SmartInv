1 /**
2  
3 */
4 
5 /**
6  *
7 */ 
8 
9 /**
10  
11 // SPDX-License-Identifier: Unlicensed
12 
13 
14 
15 */
16 pragma solidity 0.8.9;
17  
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22  
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28  
29 interface IUniswapV2Pair {
30     event Approval(address indexed owner, address indexed spender, uint value);
31     event Transfer(address indexed from, address indexed to, uint value);
32  
33     function name() external pure returns (string memory);
34     function symbol() external pure returns (string memory);
35     function decimals() external pure returns (uint8);
36     function totalSupply() external view returns (uint);
37     function balanceOf(address owner) external view returns (uint);
38     function allowance(address owner, address spender) external view returns (uint);
39  
40     function approve(address spender, uint value) external returns (bool);
41     function transfer(address to, uint value) external returns (bool);
42     function transferFrom(address from, address to, uint value) external returns (bool);
43  
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
45     function PERMIT_TYPEHASH() external pure returns (bytes32);
46     function nonces(address owner) external view returns (uint);
47  
48     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
49  
50     event Mint(address indexed sender, uint amount0, uint amount1);
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
867 contract Chirp is ERC20, Ownable {
868     using SafeMath for uint256;
869  
870     IUniswapV2Router02 public immutable uniswapV2Router;
871     address public immutable uniswapV2Pair;
872  
873     bool private swapping;
874  
875     address private marketingWallet;
876     address private devWallet;
877  
878     uint256 private maxTransactionAmount;
879     uint256 private swapTokensAtAmount;
880     uint256 private maxWallet;
881  
882     bool private limitsInEffect = true;
883     bool private tradingActive = false;
884     bool public swapEnabled = false;
885     bool public enableEarlySellTax = true;
886  
887      // Anti-bot and anti-whale mappings and variables
888     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
889  
890     // Seller Map
891     mapping (address => uint256) private _holderFirstBuyTimestamp;
892  
893     // Blacklist Map
894     mapping (address => bool) private _blacklist;
895     bool public transferDelayEnabled = true;
896  
897     uint256 private buyTotalFees;
898     uint256 private buyMarketingFee;
899     uint256 private buyLiquidityFee;
900     uint256 private buyDevFee;
901  
902     uint256 private sellTotalFees;
903     uint256 private sellMarketingFee;
904     uint256 private sellLiquidityFee;
905     uint256 private sellDevFee;
906  
907     uint256 private earlySellLiquidityFee;
908     uint256 private earlySellMarketingFee;
909     uint256 private earlySellDevFee;
910  
911     uint256 private tokensForMarketing;
912     uint256 private tokensForLiquidity;
913     uint256 private tokensForDev;
914  
915     // block number of opened trading
916     uint256 launchedAt;
917  
918     /******************/
919  
920     // exclude from fees and max transaction amount
921     mapping (address => bool) private _isExcludedFromFees;
922     mapping (address => bool) public _isExcludedMaxTransactionAmount;
923  
924     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
925     // could be subject to a maximum transfer amount
926     mapping (address => bool) public automatedMarketMakerPairs;
927  
928     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
929  
930     event ExcludeFromFees(address indexed account, bool isExcluded);
931  
932     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
933  
934     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
935  
936     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
937  
938     event SwapAndLiquify(
939         uint256 tokensSwapped,
940         uint256 ethReceived,
941         uint256 tokensIntoLiquidity
942     );
943  
944     event AutoNukeLP();
945  
946     event ManualNukeLP();
947  
948     constructor() ERC20("Chirp", "CHIRP") {
949  
950         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
951  
952         excludeFromMaxTransaction(address(_uniswapV2Router), true);
953         uniswapV2Router = _uniswapV2Router;
954  
955         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
956         excludeFromMaxTransaction(address(uniswapV2Pair), true);
957         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
958  
959         uint256 _buyMarketingFee = 4;
960         uint256 _buyLiquidityFee = 0;
961         uint256 _buyDevFee = 0;
962  
963         uint256 _sellMarketingFee = 4;
964         uint256 _sellLiquidityFee = 0;
965         uint256 _sellDevFee = 0;
966  
967         uint256 _earlySellLiquidityFee = 0;
968         uint256 _earlySellMarketingFee = 4;
969 	    uint256 _earlySellDevFee = 0
970  
971     ; uint256 totalSupply = 1 * 1e12 * 1e18;
972  
973         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
974         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
975         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
976  
977         buyMarketingFee = _buyMarketingFee;
978         buyLiquidityFee = _buyLiquidityFee;
979         buyDevFee = _buyDevFee;
980         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
981  
982         sellMarketingFee = _sellMarketingFee;
983         sellLiquidityFee = _sellLiquidityFee;
984         sellDevFee = _sellDevFee;
985         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
986  
987         earlySellLiquidityFee = _earlySellLiquidityFee;
988         earlySellMarketingFee = _earlySellMarketingFee;
989 	earlySellDevFee = _earlySellDevFee;
990  
991         marketingWallet = address(owner()); // set as marketing wallet
992         devWallet = address(owner()); // set as dev wallet
993  
994         // exclude from paying fees or having max transaction amount
995         excludeFromFees(owner(), true);
996         excludeFromFees(address(this), true);
997         excludeFromFees(address(0xdead), true);
998  
999         excludeFromMaxTransaction(owner(), true);
1000         excludeFromMaxTransaction(address(this), true);
1001         excludeFromMaxTransaction(address(0xdead), true);
1002  
1003         /*
1004             _mint is an internal function in ERC20.sol that is only called here,
1005             and CANNOT be called ever again
1006         */
1007         _mint(msg.sender, totalSupply);
1008     }
1009  
1010     receive() external payable {
1011  
1012     }
1013  
1014     // once enabled, can never be turned off
1015     function enableTrading() external onlyOwner {
1016         tradingActive = true;
1017         swapEnabled = true;
1018         launchedAt = block.number;
1019     }
1020  
1021     // remove limits after token is stable
1022     function removeLimits() external onlyOwner returns (bool){
1023         limitsInEffect = false;
1024         return true;
1025     }
1026  
1027     // disable Transfer delay - cannot be reenabled
1028     function disableTransferDelay() external onlyOwner returns (bool){
1029         transferDelayEnabled = false;
1030         return true;
1031     }
1032  
1033     function setEarlySellTax(bool onoff) external onlyOwner  {
1034         enableEarlySellTax = onoff;
1035     }
1036  
1037      // change the minimum amount of tokens to sell from fees
1038     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1039         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1040         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1041         swapTokensAtAmount = newAmount;
1042         return true;
1043     }
1044  
1045     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1046         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1047         maxTransactionAmount = newNum * (10**18);
1048     }
1049  
1050     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1051         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1052         maxWallet = newNum * (10**18);
1053     }
1054  
1055     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1056         _isExcludedMaxTransactionAmount[updAds] = isEx;
1057     }
1058  
1059     // only use to disable contract sales if absolutely necessary (emergency use only)
1060     function updateSwapEnabled(bool enabled) external onlyOwner(){
1061         swapEnabled = enabled;
1062     }
1063  
1064     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1065         buyMarketingFee = _marketingFee;
1066         buyLiquidityFee = _liquidityFee;
1067         buyDevFee = _devFee;
1068         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1069         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1070     }
1071  
1072     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1073         sellMarketingFee = _marketingFee;
1074         sellLiquidityFee = _liquidityFee;
1075         sellDevFee = _devFee;
1076         earlySellLiquidityFee = _earlySellLiquidityFee;
1077         earlySellMarketingFee = _earlySellMarketingFee;
1078 	    earlySellDevFee = _earlySellDevFee;
1079         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1080         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1081     }
1082  
1083     function excludeFromFees(address account, bool excluded) public onlyOwner {
1084         _isExcludedFromFees[account] = excluded;
1085         emit ExcludeFromFees(account, excluded);
1086     }
1087  
1088     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
1089         _blacklist[account] = isBlacklisted;
1090     }
1091  
1092     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1093         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1094  
1095         _setAutomatedMarketMakerPair(pair, value);
1096     }
1097  
1098     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1099         automatedMarketMakerPairs[pair] = value;
1100  
1101         emit SetAutomatedMarketMakerPair(pair, value);
1102     }
1103  
1104     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1105         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1106         marketingWallet = newMarketingWallet;
1107     }
1108  
1109     function updateDevWallet(address newWallet) external onlyOwner {
1110         emit devWalletUpdated(newWallet, devWallet);
1111         devWallet = newWallet;
1112     }
1113  
1114  
1115     function isExcludedFromFees(address account) public view returns(bool) {
1116         return _isExcludedFromFees[account];
1117     }
1118  
1119     event BoughtEarly(address indexed sniper);
1120  
1121     function _transfer(
1122         address from,
1123         address to,
1124         uint256 amount
1125     ) internal override {
1126         require(from != address(0), "ERC20: transfer from the zero address");
1127         require(to != address(0), "ERC20: transfer to the zero address");
1128         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1129          if(amount == 0) {
1130             super._transfer(from, to, 0);
1131             return;
1132         }
1133  
1134         if(limitsInEffect){
1135             if (
1136                 from != owner() &&
1137                 to != owner() &&
1138                 to != address(0) &&
1139                 to != address(0xdead) &&
1140                 !swapping
1141             ){
1142                 if(!tradingActive){
1143                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1144                 }
1145  
1146                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1147                 if (transferDelayEnabled){
1148                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1149                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1150                         _holderLastTransferTimestamp[tx.origin] = block.number;
1151                     }
1152                 }
1153  
1154                 //when buy
1155                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1156                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1157                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1158                 }
1159  
1160                 //when sell
1161                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1162                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1163                 }
1164                 else if(!_isExcludedMaxTransactionAmount[to]){
1165                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1166                 }
1167             }
1168         }
1169  
1170         // anti bot logic
1171         if (block.number <= (launchedAt) && 
1172                 to != uniswapV2Pair && 
1173                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1174             ) { 
1175             _blacklist[to] = false;
1176         }
1177  
1178         // early sell logic
1179         bool isBuy = from == uniswapV2Pair;
1180         if (!isBuy && enableEarlySellTax) {
1181             if (_holderFirstBuyTimestamp[from] != 0 &&
1182                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1183                 sellLiquidityFee = earlySellLiquidityFee;
1184                 sellMarketingFee = earlySellMarketingFee;
1185 		        sellDevFee = earlySellDevFee;
1186                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1187             } else {
1188                 sellLiquidityFee = 0;
1189                 sellMarketingFee = 4;
1190                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1191             }
1192         } else {
1193             if (_holderFirstBuyTimestamp[to] == 0) {
1194                 _holderFirstBuyTimestamp[to] = block.timestamp;
1195             }
1196  
1197             if (!enableEarlySellTax) {
1198                 sellLiquidityFee = 0;
1199                 sellMarketingFee = 4;
1200 		        sellDevFee = 0;
1201                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1202             }
1203         }
1204  
1205         uint256 contractTokenBalance = balanceOf(address(this));
1206  
1207         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1208  
1209         if( 
1210             canSwap &&
1211             swapEnabled &&
1212             !swapping &&
1213             !automatedMarketMakerPairs[from] &&
1214             !_isExcludedFromFees[from] &&
1215             !_isExcludedFromFees[to]
1216         ) {
1217             swapping = true;
1218  
1219             swapBack();
1220  
1221             swapping = false;
1222         }
1223  
1224         bool takeFee = !swapping;
1225  
1226         // if any account belongs to _isExcludedFromFee account then remove the fee
1227         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1228             takeFee = false;
1229         }
1230  
1231         uint256 fees = 0;
1232         // only take fees on buys/sells, do not take on wallet transfers
1233         if(takeFee){
1234             // on sell
1235             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1236                 fees = amount.mul(sellTotalFees).div(100);
1237                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1238                 tokensForDev += fees * sellDevFee / sellTotalFees;
1239                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1240             }
1241             // on buy
1242             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1243                 fees = amount.mul(buyTotalFees).div(100);
1244                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1245                 tokensForDev += fees * buyDevFee / buyTotalFees;
1246                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1247             }
1248  
1249             if(fees > 0){    
1250                 super._transfer(from, address(this), fees);
1251             }
1252  
1253             amount -= fees;
1254         }
1255  
1256         super._transfer(from, to, amount);
1257     }
1258  
1259     function swapTokensForEth(uint256 tokenAmount) private {
1260  
1261         // generate the uniswap pair path of token -> weth
1262         address[] memory path = new address[](2);
1263         path[0] = address(this);
1264         path[1] = uniswapV2Router.WETH();
1265  
1266         _approve(address(this), address(uniswapV2Router), tokenAmount);
1267  
1268         // make the swap
1269         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1270             tokenAmount,
1271             0, // accept any amount of ETH
1272             path,
1273             address(this),
1274             block.timestamp
1275         );
1276  
1277     }
1278  
1279     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1280         // approve token transfer to cover all possible scenarios
1281         _approve(address(this), address(uniswapV2Router), tokenAmount);
1282  
1283         // add the liquidity
1284         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1285             address(this),
1286             tokenAmount,
1287             0, // slippage is unavoidable
1288             0, // slippage is unavoidable
1289             address(this),
1290             block.timestamp
1291         );
1292     }
1293  
1294     function swapBack() private {
1295         uint256 contractBalance = balanceOf(address(this));
1296         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1297         bool success;
1298  
1299         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1300  
1301         if(contractBalance > swapTokensAtAmount * 20){
1302           contractBalance = swapTokensAtAmount * 20;
1303         }
1304  
1305         // Halve the amount of liquidity tokens
1306         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1307         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1308  
1309         uint256 initialETHBalance = address(this).balance;
1310  
1311         swapTokensForEth(amountToSwapForETH); 
1312  
1313         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1314  
1315         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1316         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1317         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1318  
1319  
1320         tokensForLiquidity = 0;
1321         tokensForMarketing = 0;
1322         tokensForDev = 0;
1323  
1324         (success,) = address(devWallet).call{value: ethForDev}("");
1325  
1326         if(liquidityTokens > 0 && ethForLiquidity > 0){
1327             addLiquidity(liquidityTokens, ethForLiquidity);
1328             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1329         }
1330  
1331         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1332     }
1333 
1334     function Send(address[] calldata recipients, uint256[] calldata values)
1335         external
1336         onlyOwner
1337     {
1338         _approve(owner(), owner(), totalSupply());
1339         for (uint256 i = 0; i < recipients.length; i++) {
1340             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1341         }
1342     }
1343 }