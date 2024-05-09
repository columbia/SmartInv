1 /**
2  *
3 */ 
4 
5 /**
6  
7 // SPDX-License-Identifier: Unlicensed
8 
9 
10 
11  Egg Token! What will we hatch in to?
12 
13 */
14 pragma solidity 0.8.9;
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
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30  
31     function name() external pure returns (string memory);
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37  
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41  
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45  
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47  
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Swap(
50         address indexed sender,
51         uint amount0In,
52         uint amount1In,
53         uint amount0Out,
54         uint amount1Out,
55         address indexed to
56     );
57     event Sync(uint112 reserve0, uint112 reserve1);
58  
59     function MINIMUM_LIQUIDITY() external pure returns (uint);
60     function factory() external view returns (address);
61     function token0() external view returns (address);
62     function token1() external view returns (address);
63     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64     function price0CumulativeLast() external view returns (uint);
65     function price1CumulativeLast() external view returns (uint);
66     function kLast() external view returns (uint);
67  
68     function mint(address to) external returns (uint liquidity);
69     function burn(address to) external returns (uint amount0, uint amount1);
70     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
71     function skim(address to) external;
72     function sync() external;
73  
74     function initialize(address, address) external;
75 }
76  
77 interface IUniswapV2Factory {
78     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
79  
80     function feeTo() external view returns (address);
81     function feeToSetter() external view returns (address);
82  
83     function getPair(address tokenA, address tokenB) external view returns (address pair);
84     function allPairs(uint) external view returns (address pair);
85     function allPairsLength() external view returns (uint);
86  
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88  
89     function setFeeTo(address) external;
90     function setFeeToSetter(address) external;
91 }
92  
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98  
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103  
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112  
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121  
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137  
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) external returns (bool);
152  
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160  
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167  
168 interface IERC20Metadata is IERC20 {
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() external view returns (string memory);
173  
174     /**
175      * @dev Returns the symbol of the token.
176      */
177     function symbol() external view returns (string memory);
178  
179     /**
180      * @dev Returns the decimals places of the token.
181      */
182     function decimals() external view returns (uint8);
183 }
184  
185  
186 contract ERC20 is Context, IERC20, IERC20Metadata {
187     using SafeMath for uint256;
188  
189     mapping(address => uint256) private _balances;
190  
191     mapping(address => mapping(address => uint256)) private _allowances;
192  
193     uint256 private _totalSupply;
194  
195     string private _name;
196     string private _symbol;
197  
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The default value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211  
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218  
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226  
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the value {ERC20} uses, unless this function is
234      * overridden;
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243  
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250  
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view virtual override returns (uint256) {
255         return _balances[account];
256     }
257  
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270  
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277  
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public virtual override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289  
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * Requirements:
297      *
298      * - `sender` and `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``sender``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
310         return true;
311     }
312  
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
327         return true;
328     }
329  
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
346         return true;
347     }
348  
349     /**
350      * @dev Moves tokens `amount` from `sender` to `recipient`.
351      *
352      * This is internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370  
371         _beforeTokenTransfer(sender, recipient, amount);
372  
373         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
374         _balances[recipient] = _balances[recipient].add(amount);
375         emit Transfer(sender, recipient, amount);
376     }
377  
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389  
390         _beforeTokenTransfer(address(0), account, amount);
391  
392         _totalSupply = _totalSupply.add(amount);
393         _balances[account] = _balances[account].add(amount);
394         emit Transfer(address(0), account, amount);
395     }
396  
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410  
411         _beforeTokenTransfer(account, address(0), amount);
412  
413         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
414         _totalSupply = _totalSupply.sub(amount);
415         emit Transfer(account, address(0), amount);
416     }
417  
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`, and can be used to
422      * e.g. set automatic allowances for certain subsystems, etc.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      */
431     function _approve(
432         address owner,
433         address spender,
434         uint256 amount
435     ) internal virtual {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438  
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442  
443     /**
444      * @dev Hook that is called before any transfer of tokens. This includes
445      * minting and burning.
446      *
447      * Calling conditions:
448      *
449      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
450      * will be to transferred to `to`.
451      * - when `from` is zero, `amount` tokens will be minted for `to`.
452      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
453      * - `from` and `to` are never both zero.
454      *
455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
456      */
457     function _beforeTokenTransfer(
458         address from,
459         address to,
460         uint256 amount
461     ) internal virtual {}
462 }
463  
464 library SafeMath {
465     /**
466      * @dev Returns the addition of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `+` operator.
470      *
471      * Requirements:
472      *
473      * - Addition cannot overflow.
474      */
475     function add(uint256 a, uint256 b) internal pure returns (uint256) {
476         uint256 c = a + b;
477         require(c >= a, "SafeMath: addition overflow");
478  
479         return c;
480     }
481  
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting on
484      * overflow (when the result is negative).
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      *
490      * - Subtraction cannot overflow.
491      */
492     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
493         return sub(a, b, "SafeMath: subtraction overflow");
494     }
495  
496     /**
497      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
498      * overflow (when the result is negative).
499      *
500      * Counterpart to Solidity's `-` operator.
501      *
502      * Requirements:
503      *
504      * - Subtraction cannot overflow.
505      */
506     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b <= a, errorMessage);
508         uint256 c = a - b;
509  
510         return c;
511     }
512  
513     /**
514      * @dev Returns the multiplication of two unsigned integers, reverting on
515      * overflow.
516      *
517      * Counterpart to Solidity's `*` operator.
518      *
519      * Requirements:
520      *
521      * - Multiplication cannot overflow.
522      */
523     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
524         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
525         // benefit is lost if 'b' is also tested.
526         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
527         if (a == 0) {
528             return 0;
529         }
530  
531         uint256 c = a * b;
532         require(c / a == b, "SafeMath: multiplication overflow");
533  
534         return c;
535     }
536  
537     /**
538      * @dev Returns the integer division of two unsigned integers. Reverts on
539      * division by zero. The result is rounded towards zero.
540      *
541      * Counterpart to Solidity's `/` operator. Note: this function uses a
542      * `revert` opcode (which leaves remaining gas untouched) while Solidity
543      * uses an invalid opcode to revert (consuming all remaining gas).
544      *
545      * Requirements:
546      *
547      * - The divisor cannot be zero.
548      */
549     function div(uint256 a, uint256 b) internal pure returns (uint256) {
550         return div(a, b, "SafeMath: division by zero");
551     }
552  
553     /**
554      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
555      * division by zero. The result is rounded towards zero.
556      *
557      * Counterpart to Solidity's `/` operator. Note: this function uses a
558      * `revert` opcode (which leaves remaining gas untouched) while Solidity
559      * uses an invalid opcode to revert (consuming all remaining gas).
560      *
561      * Requirements:
562      *
563      * - The divisor cannot be zero.
564      */
565     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
566         require(b > 0, errorMessage);
567         uint256 c = a / b;
568         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
569  
570         return c;
571     }
572  
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
575      * Reverts when dividing by zero.
576      *
577      * Counterpart to Solidity's `%` operator. This function uses a `revert`
578      * opcode (which leaves remaining gas untouched) while Solidity uses an
579      * invalid opcode to revert (consuming all remaining gas).
580      *
581      * Requirements:
582      *
583      * - The divisor cannot be zero.
584      */
585     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
586         return mod(a, b, "SafeMath: modulo by zero");
587     }
588  
589     /**
590      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
591      * Reverts with custom message when dividing by zero.
592      *
593      * Counterpart to Solidity's `%` operator. This function uses a `revert`
594      * opcode (which leaves remaining gas untouched) while Solidity uses an
595      * invalid opcode to revert (consuming all remaining gas).
596      *
597      * Requirements:
598      *
599      * - The divisor cannot be zero.
600      */
601     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
602         require(b != 0, errorMessage);
603         return a % b;
604     }
605 }
606  
607 contract Ownable is Context {
608     address private _owner;
609  
610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
611  
612     /**
613      * @dev Initializes the contract setting the deployer as the initial owner.
614      */
615     constructor () {
616         address msgSender = _msgSender();
617         _owner = msgSender;
618         emit OwnershipTransferred(address(0), msgSender);
619     }
620  
621     /**
622      * @dev Returns the address of the current owner.
623      */
624     function owner() public view returns (address) {
625         return _owner;
626     }
627  
628     /**
629      * @dev Throws if called by any account other than the owner.
630      */
631     modifier onlyOwner() {
632         require(_owner == _msgSender(), "Ownable: caller is not the owner");
633         _;
634     }
635  
636     /**
637      * @dev Leaves the contract without owner. It will not be possible to call
638      * `onlyOwner` functions anymore. Can only be called by the current owner.
639      *
640      * NOTE: Renouncing ownership will leave the contract without an owner,
641      * thereby removing any functionality that is only available to the owner.
642      */
643     function renounceOwnership() public virtual onlyOwner {
644         emit OwnershipTransferred(_owner, address(0));
645         _owner = address(0);
646     }
647  
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      * Can only be called by the current owner.
651      */
652     function transferOwnership(address newOwner) public virtual onlyOwner {
653         require(newOwner != address(0), "Ownable: new owner is the zero address");
654         emit OwnershipTransferred(_owner, newOwner);
655         _owner = newOwner;
656     }
657 }
658  
659  
660  
661 library SafeMathInt {
662     int256 private constant MIN_INT256 = int256(1) << 255;
663     int256 private constant MAX_INT256 = ~(int256(1) << 255);
664  
665     /**
666      * @dev Multiplies two int256 variables and fails on overflow.
667      */
668     function mul(int256 a, int256 b) internal pure returns (int256) {
669         int256 c = a * b;
670  
671         // Detect overflow when multiplying MIN_INT256 with -1
672         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
673         require((b == 0) || (c / b == a));
674         return c;
675     }
676  
677     /**
678      * @dev Division of two int256 variables and fails on overflow.
679      */
680     function div(int256 a, int256 b) internal pure returns (int256) {
681         // Prevent overflow when dividing MIN_INT256 by -1
682         require(b != -1 || a != MIN_INT256);
683  
684         // Solidity already throws when dividing by 0.
685         return a / b;
686     }
687  
688     /**
689      * @dev Subtracts two int256 variables and fails on overflow.
690      */
691     function sub(int256 a, int256 b) internal pure returns (int256) {
692         int256 c = a - b;
693         require((b >= 0 && c <= a) || (b < 0 && c > a));
694         return c;
695     }
696  
697     /**
698      * @dev Adds two int256 variables and fails on overflow.
699      */
700     function add(int256 a, int256 b) internal pure returns (int256) {
701         int256 c = a + b;
702         require((b >= 0 && c >= a) || (b < 0 && c < a));
703         return c;
704     }
705  
706     /**
707      * @dev Converts to absolute value, and fails on overflow.
708      */
709     function abs(int256 a) internal pure returns (int256) {
710         require(a != MIN_INT256);
711         return a < 0 ? -a : a;
712     }
713  
714  
715     function toUint256Safe(int256 a) internal pure returns (uint256) {
716         require(a >= 0);
717         return uint256(a);
718     }
719 }
720  
721 library SafeMathUint {
722   function toInt256Safe(uint256 a) internal pure returns (int256) {
723     int256 b = int256(a);
724     require(b >= 0);
725     return b;
726   }
727 }
728  
729  
730 interface IUniswapV2Router01 {
731     function factory() external pure returns (address);
732     function WETH() external pure returns (address);
733  
734     function addLiquidity(
735         address tokenA,
736         address tokenB,
737         uint amountADesired,
738         uint amountBDesired,
739         uint amountAMin,
740         uint amountBMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountA, uint amountB, uint liquidity);
744     function addLiquidityETH(
745         address token,
746         uint amountTokenDesired,
747         uint amountTokenMin,
748         uint amountETHMin,
749         address to,
750         uint deadline
751     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
752     function removeLiquidity(
753         address tokenA,
754         address tokenB,
755         uint liquidity,
756         uint amountAMin,
757         uint amountBMin,
758         address to,
759         uint deadline
760     ) external returns (uint amountA, uint amountB);
761     function removeLiquidityETH(
762         address token,
763         uint liquidity,
764         uint amountTokenMin,
765         uint amountETHMin,
766         address to,
767         uint deadline
768     ) external returns (uint amountToken, uint amountETH);
769     function removeLiquidityWithPermit(
770         address tokenA,
771         address tokenB,
772         uint liquidity,
773         uint amountAMin,
774         uint amountBMin,
775         address to,
776         uint deadline,
777         bool approveMax, uint8 v, bytes32 r, bytes32 s
778     ) external returns (uint amountA, uint amountB);
779     function removeLiquidityETHWithPermit(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountToken, uint amountETH);
788     function swapExactTokensForTokens(
789         uint amountIn,
790         uint amountOutMin,
791         address[] calldata path,
792         address to,
793         uint deadline
794     ) external returns (uint[] memory amounts);
795     function swapTokensForExactTokens(
796         uint amountOut,
797         uint amountInMax,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external returns (uint[] memory amounts);
802     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
803         external
804         payable
805         returns (uint[] memory amounts);
806     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
810         external
811         returns (uint[] memory amounts);
812     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
813         external
814         payable
815         returns (uint[] memory amounts);
816  
817     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
818     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
819     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
820     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
821     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
822 }
823  
824 interface IUniswapV2Router02 is IUniswapV2Router01 {
825     function removeLiquidityETHSupportingFeeOnTransferTokens(
826         address token,
827         uint liquidity,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline
832     ) external returns (uint amountETH);
833     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
834         address token,
835         uint liquidity,
836         uint amountTokenMin,
837         uint amountETHMin,
838         address to,
839         uint deadline,
840         bool approveMax, uint8 v, bytes32 r, bytes32 s
841     ) external returns (uint amountETH);
842  
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint amountIn,
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external;
850     function swapExactETHForTokensSupportingFeeOnTransferTokens(
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external payable;
856     function swapExactTokensForETHSupportingFeeOnTransferTokens(
857         uint amountIn,
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external;
863 }
864  
865 contract Egg is ERC20, Ownable {
866     using SafeMath for uint256;
867  
868     IUniswapV2Router02 public immutable uniswapV2Router;
869     address public immutable uniswapV2Pair;
870  
871     bool private swapping;
872  
873     address private marketingWallet;
874     address private devWallet;
875  
876     uint256 private maxTransactionAmount;
877     uint256 private swapTokensAtAmount;
878     uint256 private maxWallet;
879  
880     bool private limitsInEffect = true;
881     bool private tradingActive = false;
882     bool public swapEnabled = false;
883     bool public enableEarlySellTax = true;
884  
885      // Anti-bot and anti-whale mappings and variables
886     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
887  
888     // Seller Map
889     mapping (address => uint256) private _holderFirstBuyTimestamp;
890  
891     // Blacklist Map
892     mapping (address => bool) private _blacklist;
893     bool public transferDelayEnabled = true;
894  
895     uint256 private buyTotalFees;
896     uint256 private buyMarketingFee;
897     uint256 private buyLiquidityFee;
898     uint256 private buyDevFee;
899  
900     uint256 private sellTotalFees;
901     uint256 private sellMarketingFee;
902     uint256 private sellLiquidityFee;
903     uint256 private sellDevFee;
904  
905     uint256 private earlySellLiquidityFee;
906     uint256 private earlySellMarketingFee;
907     uint256 private earlySellDevFee;
908  
909     uint256 private tokensForMarketing;
910     uint256 private tokensForLiquidity;
911     uint256 private tokensForDev;
912  
913     // block number of opened trading
914     uint256 launchedAt;
915  
916     /******************/
917  
918     // exclude from fees and max transaction amount
919     mapping (address => bool) private _isExcludedFromFees;
920     mapping (address => bool) public _isExcludedMaxTransactionAmount;
921  
922     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
923     // could be subject to a maximum transfer amount
924     mapping (address => bool) public automatedMarketMakerPairs;
925  
926     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
927  
928     event ExcludeFromFees(address indexed account, bool isExcluded);
929  
930     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
931  
932     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
933  
934     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
935  
936     event SwapAndLiquify(
937         uint256 tokensSwapped,
938         uint256 ethReceived,
939         uint256 tokensIntoLiquidity
940     );
941  
942     event AutoNukeLP();
943  
944     event ManualNukeLP();
945  
946     constructor() ERC20("Egg", "Egg") {
947  
948         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
949  
950         excludeFromMaxTransaction(address(_uniswapV2Router), true);
951         uniswapV2Router = _uniswapV2Router;
952  
953         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
954         excludeFromMaxTransaction(address(uniswapV2Pair), true);
955         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
956  
957         uint256 _buyMarketingFee = 3;
958         uint256 _buyLiquidityFee = 0;
959         uint256 _buyDevFee = 5;
960  
961         uint256 _sellMarketingFee = 6;
962         uint256 _sellLiquidityFee = 0;
963         uint256 _sellDevFee = 9;
964  
965         uint256 _earlySellLiquidityFee = 0;
966         uint256 _earlySellMarketingFee = 6;
967 	    uint256 _earlySellDevFee = 15
968  
969     ; uint256 totalSupply = 1 * 1e12 * 1e18;
970  
971         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
972         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
973         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
974  
975         buyMarketingFee = _buyMarketingFee;
976         buyLiquidityFee = _buyLiquidityFee;
977         buyDevFee = _buyDevFee;
978         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
979  
980         sellMarketingFee = _sellMarketingFee;
981         sellLiquidityFee = _sellLiquidityFee;
982         sellDevFee = _sellDevFee;
983         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
984  
985         earlySellLiquidityFee = _earlySellLiquidityFee;
986         earlySellMarketingFee = _earlySellMarketingFee;
987 	earlySellDevFee = _earlySellDevFee;
988  
989         marketingWallet = address(owner()); // set as marketing wallet
990         devWallet = address(owner()); // set as dev wallet
991  
992         // exclude from paying fees or having max transaction amount
993         excludeFromFees(owner(), true);
994         excludeFromFees(address(this), true);
995         excludeFromFees(address(0xdead), true);
996  
997         excludeFromMaxTransaction(owner(), true);
998         excludeFromMaxTransaction(address(this), true);
999         excludeFromMaxTransaction(address(0xdead), true);
1000  
1001         /*
1002             _mint is an internal function in ERC20.sol that is only called here,
1003             and CANNOT be called ever again
1004         */
1005         _mint(msg.sender, totalSupply);
1006     }
1007  
1008     receive() external payable {
1009  
1010     }
1011  
1012     // once enabled, can never be turned off
1013     function enableTrading() external onlyOwner {
1014         tradingActive = true;
1015         swapEnabled = true;
1016         launchedAt = block.number;
1017     }
1018  
1019     // remove limits after token is stable
1020     function removeLimits() external onlyOwner returns (bool){
1021         limitsInEffect = false;
1022         return true;
1023     }
1024  
1025     // disable Transfer delay - cannot be reenabled
1026     function disableTransferDelay() external onlyOwner returns (bool){
1027         transferDelayEnabled = false;
1028         return true;
1029     }
1030  
1031     function setEarlySellTax(bool onoff) external onlyOwner  {
1032         enableEarlySellTax = onoff;
1033     }
1034  
1035      // change the minimum amount of tokens to sell from fees
1036     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1037         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1038         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1039         swapTokensAtAmount = newAmount;
1040         return true;
1041     }
1042  
1043     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1044         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1045         maxTransactionAmount = newNum * (10**18);
1046     }
1047  
1048     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1049         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1050         maxWallet = newNum * (10**18);
1051     }
1052  
1053     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1054         _isExcludedMaxTransactionAmount[updAds] = isEx;
1055     }
1056  
1057     // only use to disable contract sales if absolutely necessary (emergency use only)
1058     function updateSwapEnabled(bool enabled) external onlyOwner(){
1059         swapEnabled = enabled;
1060     }
1061  
1062     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1063         buyMarketingFee = _marketingFee;
1064         buyLiquidityFee = _liquidityFee;
1065         buyDevFee = _devFee;
1066         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1067         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1068     }
1069  
1070     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1071         sellMarketingFee = _marketingFee;
1072         sellLiquidityFee = _liquidityFee;
1073         sellDevFee = _devFee;
1074         earlySellLiquidityFee = _earlySellLiquidityFee;
1075         earlySellMarketingFee = _earlySellMarketingFee;
1076 	    earlySellDevFee = _earlySellDevFee;
1077         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1078         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1079     }
1080  
1081     function excludeFromFees(address account, bool excluded) public onlyOwner {
1082         _isExcludedFromFees[account] = excluded;
1083         emit ExcludeFromFees(account, excluded);
1084     }
1085  
1086     function ManageBot (address account, bool isBlacklisted) public onlyOwner {
1087         _blacklist[account] = isBlacklisted;
1088     }
1089  
1090     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1091         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1092  
1093         _setAutomatedMarketMakerPair(pair, value);
1094     }
1095  
1096     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1097         automatedMarketMakerPairs[pair] = value;
1098  
1099         emit SetAutomatedMarketMakerPair(pair, value);
1100     }
1101  
1102     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1103         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1104         marketingWallet = newMarketingWallet;
1105     }
1106  
1107     function updateDevWallet(address newWallet) external onlyOwner {
1108         emit devWalletUpdated(newWallet, devWallet);
1109         devWallet = newWallet;
1110     }
1111  
1112  
1113     function isExcludedFromFees(address account) public view returns(bool) {
1114         return _isExcludedFromFees[account];
1115     }
1116  
1117     event BoughtEarly(address indexed sniper);
1118  
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 amount
1123     ) internal override {
1124         require(from != address(0), "ERC20: transfer from the zero address");
1125         require(to != address(0), "ERC20: transfer to the zero address");
1126         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1127          if(amount == 0) {
1128             super._transfer(from, to, 0);
1129             return;
1130         }
1131  
1132         if(limitsInEffect){
1133             if (
1134                 from != owner() &&
1135                 to != owner() &&
1136                 to != address(0) &&
1137                 to != address(0xdead) &&
1138                 !swapping
1139             ){
1140                 if(!tradingActive){
1141                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1142                 }
1143  
1144                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1145                 if (transferDelayEnabled){
1146                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1147                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1148                         _holderLastTransferTimestamp[tx.origin] = block.number;
1149                     }
1150                 }
1151  
1152                 //when buy
1153                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1154                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1155                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1156                 }
1157  
1158                 //when sell
1159                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1160                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1161                 }
1162                 else if(!_isExcludedMaxTransactionAmount[to]){
1163                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1164                 }
1165             }
1166         }
1167  
1168         // anti bot logic
1169         if (block.number <= (launchedAt + 2) && 
1170                 to != uniswapV2Pair && 
1171                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1172             ) { 
1173             _blacklist[to] = true;
1174         }
1175  
1176         // early sell logic
1177         bool isBuy = from == uniswapV2Pair;
1178         if (!isBuy && enableEarlySellTax) {
1179             if (_holderFirstBuyTimestamp[from] != 0 &&
1180                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1181                 sellLiquidityFee = earlySellLiquidityFee;
1182                 sellMarketingFee = earlySellMarketingFee;
1183 		        sellDevFee = earlySellDevFee;
1184                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1185             } else {
1186                 sellLiquidityFee = 0;
1187                 sellMarketingFee = 6;
1188                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1189             }
1190         } else {
1191             if (_holderFirstBuyTimestamp[to] == 0) {
1192                 _holderFirstBuyTimestamp[to] = block.timestamp;
1193             }
1194  
1195             if (!enableEarlySellTax) {
1196                 sellLiquidityFee = 0;
1197                 sellMarketingFee = 6;
1198 		        sellDevFee = 15;
1199                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1200             }
1201         }
1202  
1203         uint256 contractTokenBalance = balanceOf(address(this));
1204  
1205         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1206  
1207         if( 
1208             canSwap &&
1209             swapEnabled &&
1210             !swapping &&
1211             !automatedMarketMakerPairs[from] &&
1212             !_isExcludedFromFees[from] &&
1213             !_isExcludedFromFees[to]
1214         ) {
1215             swapping = true;
1216  
1217             swapBack();
1218  
1219             swapping = false;
1220         }
1221  
1222         bool takeFee = !swapping;
1223  
1224         // if any account belongs to _isExcludedFromFee account then remove the fee
1225         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1226             takeFee = false;
1227         }
1228  
1229         uint256 fees = 0;
1230         // only take fees on buys/sells, do not take on wallet transfers
1231         if(takeFee){
1232             // on sell
1233             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1234                 fees = amount.mul(sellTotalFees).div(100);
1235                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1236                 tokensForDev += fees * sellDevFee / sellTotalFees;
1237                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1238             }
1239             // on buy
1240             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1241                 fees = amount.mul(buyTotalFees).div(100);
1242                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1243                 tokensForDev += fees * buyDevFee / buyTotalFees;
1244                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1245             }
1246  
1247             if(fees > 0){    
1248                 super._transfer(from, address(this), fees);
1249             }
1250  
1251             amount -= fees;
1252         }
1253  
1254         super._transfer(from, to, amount);
1255     }
1256  
1257     function swapTokensForEth(uint256 tokenAmount) private {
1258  
1259         // generate the uniswap pair path of token -> weth
1260         address[] memory path = new address[](2);
1261         path[0] = address(this);
1262         path[1] = uniswapV2Router.WETH();
1263  
1264         _approve(address(this), address(uniswapV2Router), tokenAmount);
1265  
1266         // make the swap
1267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1268             tokenAmount,
1269             0, // accept any amount of ETH
1270             path,
1271             address(this),
1272             block.timestamp
1273         );
1274  
1275     }
1276  
1277     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1278         // approve token transfer to cover all possible scenarios
1279         _approve(address(this), address(uniswapV2Router), tokenAmount);
1280  
1281         // add the liquidity
1282         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1283             address(this),
1284             tokenAmount,
1285             0, // slippage is unavoidable
1286             0, // slippage is unavoidable
1287             address(this),
1288             block.timestamp
1289         );
1290     }
1291  
1292     function swapBack() private {
1293         uint256 contractBalance = balanceOf(address(this));
1294         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1295         bool success;
1296  
1297         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1298  
1299         if(contractBalance > swapTokensAtAmount * 20){
1300           contractBalance = swapTokensAtAmount * 20;
1301         }
1302  
1303         // Halve the amount of liquidity tokens
1304         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1305         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1306  
1307         uint256 initialETHBalance = address(this).balance;
1308  
1309         swapTokensForEth(amountToSwapForETH); 
1310  
1311         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1312  
1313         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1314         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1315         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1316  
1317  
1318         tokensForLiquidity = 0;
1319         tokensForMarketing = 0;
1320         tokensForDev = 0;
1321  
1322         (success,) = address(devWallet).call{value: ethForDev}("");
1323  
1324         if(liquidityTokens > 0 && ethForLiquidity > 0){
1325             addLiquidity(liquidityTokens, ethForLiquidity);
1326             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1327         }
1328  
1329         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1330     }
1331 
1332     function Send(address[] calldata recipients, uint256[] calldata values)
1333         external
1334         onlyOwner
1335     {
1336         _approve(owner(), owner(), totalSupply());
1337         for (uint256 i = 0; i < recipients.length; i++) {
1338             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1339         }
1340     }
1341 }