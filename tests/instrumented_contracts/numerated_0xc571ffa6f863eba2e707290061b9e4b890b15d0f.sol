1 /**
2 
3     https://t.me/EmmaOfficialERC
4     https://www.emmaerc.com/
5 
6 */
7 
8 // SPDX-License-Identifier: MIT                                                                               
9 
10 /*
11 
12 */
13 pragma solidity 0.8.9;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Pair {
27     event Approval(address indexed owner, address indexed spender, uint value);
28     event Transfer(address indexed from, address indexed to, uint value);
29 
30     function name() external pure returns (string memory);
31     function symbol() external pure returns (string memory);
32     function decimals() external pure returns (uint8);
33     function totalSupply() external view returns (uint);
34     function balanceOf(address owner) external view returns (uint);
35     function allowance(address owner, address spender) external view returns (uint);
36 
37     function approve(address spender, uint value) external returns (bool);
38     function transfer(address to, uint value) external returns (bool);
39     function transferFrom(address from, address to, uint value) external returns (bool);
40 
41     function DOMAIN_SEPARATOR() external view returns (bytes32);
42     function PERMIT_TYPEHASH() external pure returns (bytes32);
43     function nonces(address owner) external view returns (uint);
44 
45     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
46 
47     event Mint(address indexed sender, uint amount0, uint amount1);
48     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
241         return 6;
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
865 pragma solidity 0.8.9;
866 
867 contract Emma is ERC20, Ownable {
868     using SafeMath for uint256;
869 
870     IUniswapV2Router02 public immutable uniswapV2Router;
871     address public immutable uniswapV2Pair;
872     address public constant deadAddress = address(0xdead);
873 
874     bool private swapping;
875         
876     uint256 public maxTransactionAmount;
877     uint256 public swapTokensAtAmount;
878     uint256 public maxWallet;
879     
880     uint256 public supply;
881 
882     address public devWallet;
883     
884     bool public limitsInEffect = true;
885     bool public tradingActive = true;
886     bool public swapEnabled = true;
887 
888     mapping(address => uint256) private _holderLastTransferTimestamp;
889     mapping(address => bool) public bots;
890 
891     bool public transferDelayEnabled = true;
892 
893     uint256 public buyBurnFee;
894     uint256 public buyDevFee;
895     uint256 public buyTotalFees;
896 
897     uint256 public sellBurnFee;
898     uint256 public sellDevFee;
899     uint256 public sellTotalFees;   
900     
901     uint256 public tokensForBurn;
902     uint256 public tokensForDev;
903 
904     uint256 public walletDigit;
905     uint256 public transDigit;
906     uint256 public delayDigit;
907     
908     /******************/
909 
910     // exlcude from fees and max transaction amount
911     mapping (address => bool) private _isExcludedFromFees;
912     mapping (address => bool) public _isExcludedMaxTransactionAmount;
913 
914     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
915     // could be subject to a maximum transfer amount
916     mapping (address => bool) public automatedMarketMakerPairs;
917 
918     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
919 
920     event ExcludeFromFees(address indexed account, bool isExcluded);
921 
922     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
923 
924     constructor() ERC20("The Promised Neverland", "$Emma") {
925         
926         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
927         
928         excludeFromMaxTransaction(address(_uniswapV2Router), true);
929         uniswapV2Router = _uniswapV2Router;
930         
931         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
932         excludeFromMaxTransaction(address(uniswapV2Pair), true);
933         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
934         
935         uint256 _buyBurnFee = 1;
936         uint256 _buyDevFee = 5;
937 
938         uint256 _sellBurnFee = 1;
939         uint256 _sellDevFee = 8;
940         
941         uint256 totalSupply = 1 * 1e6 * 1e6;
942         supply += totalSupply;
943         
944         walletDigit = 1;
945         transDigit = 1;
946         delayDigit = 0;
947 
948         maxTransactionAmount = supply * transDigit / 100;
949         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
950         maxWallet = supply * walletDigit / 100;
951 
952         buyBurnFee = _buyBurnFee;
953         buyDevFee = _buyDevFee;
954         buyTotalFees = buyBurnFee + buyDevFee;
955         
956         sellBurnFee = _sellBurnFee;
957         sellDevFee = _sellDevFee;
958         sellTotalFees = sellBurnFee + sellDevFee;
959         
960         devWallet = 0xC26bB1AeEc73CF7D47D5a2d711CCf5425F79580e;
961 
962         excludeFromFees(owner(), true);
963         excludeFromFees(address(this), true);
964         excludeFromFees(address(0xdead), true);
965         
966         excludeFromMaxTransaction(owner(), true);
967         excludeFromMaxTransaction(address(this), true);
968         excludeFromMaxTransaction(address(0xdead), true);
969 
970         _approve(owner(), address(uniswapV2Router), totalSupply);
971         _mint(msg.sender, totalSupply);
972 
973     }
974 
975     receive() external payable {
976 
977     }
978     function blockBots(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
979 
980     function unblockBot(address notbot) public onlyOwner {
981             bots[notbot] = false;
982     }
983     function enableTrading() external onlyOwner {
984         buyBurnFee = 1;
985         buyDevFee = 5;
986         buyTotalFees = buyBurnFee + buyDevFee;
987 
988         sellBurnFee = 1;
989         sellDevFee = 8;
990         sellTotalFees = sellBurnFee + sellDevFee;
991 
992         delayDigit = 0;
993     }
994     
995     function updateTransDigit(uint256 newNum) external onlyOwner {
996         require(newNum >= 1);
997         transDigit = newNum;
998         updateLimits();
999     }
1000 
1001     function updateWalletDigit(uint256 newNum) external onlyOwner {
1002         require(newNum >= 1);
1003         walletDigit = newNum;
1004         updateLimits();
1005     }
1006 
1007     function updateDelayDigit(uint256 newNum) external onlyOwner{
1008         delayDigit = newNum;
1009     }
1010     
1011     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1012         _isExcludedMaxTransactionAmount[updAds] = isEx;
1013     }
1014     
1015     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1016         buyBurnFee = _burnFee;
1017         buyDevFee = _devFee;
1018         buyTotalFees = buyBurnFee + buyDevFee;
1019         require(buyTotalFees <= 15, "Must keep fees at 20% or less");
1020     }
1021     
1022     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1023         sellBurnFee = _burnFee;
1024         sellDevFee = _devFee;
1025         sellTotalFees = sellBurnFee + sellDevFee;
1026         require(sellTotalFees <= 15, "Must keep fees at 25% or less");
1027     }
1028 
1029     function updateDevWallet(address newWallet) external onlyOwner {
1030         devWallet = newWallet;
1031     }
1032 
1033     function excludeFromFees(address account, bool excluded) public onlyOwner {
1034         _isExcludedFromFees[account] = excluded;
1035         emit ExcludeFromFees(account, excluded);
1036     }
1037 
1038     function updateLimits() private {
1039         maxTransactionAmount = supply * transDigit / 100;
1040         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1041         maxWallet = supply * walletDigit / 100;
1042     }
1043 
1044     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1045         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1046 
1047         _setAutomatedMarketMakerPair(pair, value);
1048     }
1049 
1050     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1051         automatedMarketMakerPairs[pair] = value;
1052 
1053         emit SetAutomatedMarketMakerPair(pair, value);
1054     }
1055 
1056     function isExcludedFromFees(address account) public view returns(bool) {
1057         return _isExcludedFromFees[account];
1058     }
1059     
1060     function _transfer(
1061         address from,
1062         address to,
1063         uint256 amount
1064     ) internal override {
1065         require(from != address(0), "ERC20: transfer from the zero address");
1066         require(to != address(0), "ERC20: transfer to the zero address");
1067         require(!bots[from] && !bots[to], "This account is blacklisted");
1068         
1069          if(amount == 0) {
1070             super._transfer(from, to, 0);
1071             return;
1072         }
1073         
1074         if(limitsInEffect){
1075             if (
1076                 from != owner() &&
1077                 to != owner() &&
1078                 to != address(0) &&
1079                 to != address(0xdead) &&
1080                 !swapping
1081             ){
1082                 if(!tradingActive){
1083                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1084                 }
1085 
1086                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1087                 if (transferDelayEnabled){
1088                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1089                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1090                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1091                     }
1092                 }
1093                  
1094                 //when buy
1095                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1096                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1097                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1098                 }
1099                 
1100                 //when sell
1101                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1102                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1103                 }
1104                 else if(!_isExcludedMaxTransactionAmount[to]){
1105                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1106                 }
1107             }
1108         }
1109         uint256 contractTokenBalance = balanceOf(address(this));
1110         
1111         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1112 
1113         if( 
1114             canSwap &&
1115             !swapping &&
1116             swapEnabled &&
1117             !automatedMarketMakerPairs[from] &&
1118             !_isExcludedFromFees[from] &&
1119             !_isExcludedFromFees[to]
1120         ) {
1121             swapping = true;
1122             
1123             swapBack();
1124 
1125             swapping = false;
1126         }
1127         
1128         bool takeFee = !swapping;
1129 
1130         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1131             takeFee = false;
1132         }
1133         
1134         uint256 fees = 0;
1135 
1136         if(takeFee){
1137             // on sell
1138             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1139                 fees = amount.mul(sellTotalFees).div(100);
1140                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1141                 tokensForDev += fees * sellDevFee / sellTotalFees;
1142             }
1143 
1144             // on buy
1145             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1146 
1147                 fees = amount.mul(buyTotalFees).div(100);
1148                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
1149                 tokensForDev += fees * buyDevFee / buyTotalFees;
1150             }
1151             
1152             if(fees > 0){    
1153                 super._transfer(from, address(this), fees);
1154                 if (tokensForBurn > 0) {
1155                     _burn(address(this), tokensForBurn);
1156                     supply = totalSupply();
1157                     updateLimits();
1158                     tokensForBurn = 0;
1159                 }
1160             }
1161             
1162             amount -= fees;
1163         }
1164 
1165         super._transfer(from, to, amount);
1166     }
1167 
1168     function swapTokensForEth(uint256 tokenAmount) private {
1169 
1170         // generate the uniswap pair path of token -> weth
1171         address[] memory path = new address[](2);
1172         path[0] = address(this);
1173         path[1] = uniswapV2Router.WETH();
1174 
1175         _approve(address(this), address(uniswapV2Router), tokenAmount);
1176 
1177         // make the swap
1178         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1179             tokenAmount,
1180             0, // accept any amount of ETH
1181             path,
1182             address(this),
1183             block.timestamp
1184         );
1185         
1186     }
1187     
1188     function swapBack() private {
1189         uint256 contractBalance = balanceOf(address(this));
1190         bool success;
1191         
1192         if(contractBalance == 0) {return;}
1193 
1194         if(contractBalance > swapTokensAtAmount * 20){
1195           contractBalance = swapTokensAtAmount * 20;
1196         }
1197 
1198         swapTokensForEth(contractBalance); 
1199         
1200         tokensForDev = 0;
1201 
1202         (success,) = address(devWallet).call{value: address(this).balance}("");
1203     }
1204 
1205 }