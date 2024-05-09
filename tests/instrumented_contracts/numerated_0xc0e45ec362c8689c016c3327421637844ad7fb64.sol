1 /*
2 
3 TG
4 https://t.me/BullInuEntry
5 
6 Site
7 https://bullinu.co/
8 
9 */
10 
11 // SPDX-License-Identifier: MIT                                                                               
12                                                     
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
865 contract BULL is ERC20, Ownable {
866     using SafeMath for uint256;
867 
868     IUniswapV2Router02 public immutable uniswapV2Router;
869     address public immutable uniswapV2Pair;
870     address public constant deadAddress = address(0xdead);
871 
872     bool private swapping;
873 
874     address public marketingWallet;
875     address public devWallet;
876     
877     uint256 public maxTransactionAmount;
878     uint256 public swapTokensAtAmount;
879     uint256 public maxWallet;
880     
881     uint256 public percentForLPBurn = 25; // 25 = .25%
882     bool public lpBurnEnabled = true;
883     uint256 public lpBurnFrequency = 3600 seconds;
884     uint256 public lastLpBurnTime;
885     
886     uint256 public manualBurnFrequency = 30 minutes;
887     uint256 public lastManualLpBurnTime;
888 
889     bool public limitsInEffect = true;
890     bool public tradingActive = false;
891     bool public swapEnabled = false;
892     
893      // Anti-bot and anti-whale mappings and variables
894     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
895     bool public transferDelayEnabled = true;
896 
897     uint256 public buyTotalFees;
898     uint256 public buyMarketingFee;
899     uint256 public buyLiquidityFee;
900     uint256 public buyDevFee;
901     
902     uint256 public sellTotalFees;
903     uint256 public sellMarketingFee;
904     uint256 public sellLiquidityFee;
905     uint256 public sellDevFee;
906     
907     uint256 public tokensForMarketing;
908     uint256 public tokensForLiquidity;
909     uint256 public tokensForDev;
910     
911     /******************/
912 
913     // exlcude from fees and max transaction amount
914     mapping (address => bool) private _isExcludedFromFees;
915     mapping (address => bool) public _isExcludedMaxTransactionAmount;
916 
917     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
918     // could be subject to a maximum transfer amount
919     mapping (address => bool) public automatedMarketMakerPairs;
920 
921     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
922 
923     event ExcludeFromFees(address indexed account, bool isExcluded);
924 
925     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
926 
927     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
928     
929     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
930 
931     event SwapAndLiquify(
932         uint256 tokensSwapped,
933         uint256 ethReceived,
934         uint256 tokensIntoLiquidity
935     );
936     
937     event AutoNukeLP();
938     
939     event ManualNukeLP();
940 
941     constructor() ERC20("BULL Inu", "BULL") {
942         
943         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
944         
945         excludeFromMaxTransaction(address(_uniswapV2Router), true);
946         uniswapV2Router = _uniswapV2Router;
947         
948         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
949         excludeFromMaxTransaction(address(uniswapV2Pair), true);
950         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
951         
952         uint256 _buyMarketingFee = 4;
953         uint256 _buyLiquidityFee = 10;
954         uint256 _buyDevFee = 1;
955 
956         uint256 _sellMarketingFee = 5;
957         uint256 _sellLiquidityFee = 14;
958         uint256 _sellDevFee = 1;
959         
960         uint256 totalSupply = 1 * 1e12 * 1e18;
961         
962         maxTransactionAmount = totalSupply * 1 / 1000; // 0.1% maxTransactionAmountTxn
963         maxWallet = totalSupply * 5 / 1000; // .5% maxWallet
964         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
965 
966         buyMarketingFee = _buyMarketingFee;
967         buyLiquidityFee = _buyLiquidityFee;
968         buyDevFee = _buyDevFee;
969         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
970         
971         sellMarketingFee = _sellMarketingFee;
972         sellLiquidityFee = _sellLiquidityFee;
973         sellDevFee = _sellDevFee;
974         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
975         
976         marketingWallet = address(owner()); // set as marketing wallet
977         devWallet = address(owner()); // set as dev wallet
978 
979         // exclude from paying fees or having max transaction amount
980         excludeFromFees(owner(), true);
981         excludeFromFees(address(this), true);
982         excludeFromFees(address(0xdead), true);
983         
984         excludeFromMaxTransaction(owner(), true);
985         excludeFromMaxTransaction(address(this), true);
986         excludeFromMaxTransaction(address(0xdead), true);
987         
988         /*
989             _mint is an internal function in ERC20.sol that is only called here,
990             and CANNOT be called ever again
991         */
992         _mint(msg.sender, totalSupply);
993     }
994 
995     receive() external payable {
996 
997   	}
998 
999     // once enabled, can never be turned off
1000     function enableTrading() external onlyOwner {
1001         tradingActive = true;
1002         swapEnabled = true;
1003         lastLpBurnTime = block.timestamp;
1004     }
1005     
1006     // remove limits after token is stable
1007     function removeLimits() external onlyOwner returns (bool){
1008         limitsInEffect = false;
1009         return true;
1010     }
1011     
1012     // disable Transfer delay - cannot be reenabled
1013     function disableTransferDelay() external onlyOwner returns (bool){
1014         transferDelayEnabled = false;
1015         return true;
1016     }
1017     
1018      // change the minimum amount of tokens to sell from fees
1019     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1020   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1021   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1022   	    swapTokensAtAmount = newAmount;
1023   	    return true;
1024   	}
1025     
1026     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1027         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1028         maxTransactionAmount = newNum * (10**18);
1029     }
1030 
1031     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1032         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1033         maxWallet = newNum * (10**18);
1034     }
1035     
1036     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1037         _isExcludedMaxTransactionAmount[updAds] = isEx;
1038     }
1039     
1040     // only use to disable contract sales if absolutely necessary (emergency use only)
1041     function updateSwapEnabled(bool enabled) external onlyOwner(){
1042         swapEnabled = enabled;
1043     }
1044     
1045     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1046         buyMarketingFee = _marketingFee;
1047         buyLiquidityFee = _liquidityFee;
1048         buyDevFee = _devFee;
1049         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1050         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1051     }
1052     
1053     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1054         sellMarketingFee = _marketingFee;
1055         sellLiquidityFee = _liquidityFee;
1056         sellDevFee = _devFee;
1057         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1058         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1059     }
1060 
1061     function excludeFromFees(address account, bool excluded) public onlyOwner {
1062         _isExcludedFromFees[account] = excluded;
1063         emit ExcludeFromFees(account, excluded);
1064     }
1065 
1066     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1067         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1068 
1069         _setAutomatedMarketMakerPair(pair, value);
1070     }
1071 
1072     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1073         automatedMarketMakerPairs[pair] = value;
1074 
1075         emit SetAutomatedMarketMakerPair(pair, value);
1076     }
1077 
1078     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1079         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1080         marketingWallet = newMarketingWallet;
1081     }
1082     
1083     function updateDevWallet(address newWallet) external onlyOwner {
1084         emit devWalletUpdated(newWallet, devWallet);
1085         devWallet = newWallet;
1086     }
1087     
1088 
1089     function isExcludedFromFees(address account) public view returns(bool) {
1090         return _isExcludedFromFees[account];
1091     }
1092     
1093     event BoughtEarly(address indexed sniper);
1094 
1095     function _transfer(
1096         address from,
1097         address to,
1098         uint256 amount
1099     ) internal override {
1100         require(from != address(0), "ERC20: transfer from the zero address");
1101         require(to != address(0), "ERC20: transfer to the zero address");
1102         
1103          if(amount == 0) {
1104             super._transfer(from, to, 0);
1105             return;
1106         }
1107         
1108         if(limitsInEffect){
1109             if (
1110                 from != owner() &&
1111                 to != owner() &&
1112                 to != address(0) &&
1113                 to != address(0xdead) &&
1114                 !swapping
1115             ){
1116                 if(!tradingActive){
1117                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1118                 }
1119 
1120                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1121                 if (transferDelayEnabled){
1122                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1123                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1124                         _holderLastTransferTimestamp[tx.origin] = block.number;
1125                     }
1126                 }
1127                  
1128                 //when buy
1129                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1130                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1131                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1132                 }
1133                 
1134                 //when sell
1135                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1136                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1137                 }
1138                 else if(!_isExcludedMaxTransactionAmount[to]){
1139                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1140                 }
1141             }
1142         }
1143         
1144         
1145         
1146 		uint256 contractTokenBalance = balanceOf(address(this));
1147         
1148         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1149 
1150         if( 
1151             canSwap &&
1152             swapEnabled &&
1153             !swapping &&
1154             !automatedMarketMakerPairs[from] &&
1155             !_isExcludedFromFees[from] &&
1156             !_isExcludedFromFees[to]
1157         ) {
1158             swapping = true;
1159             
1160             swapBack();
1161 
1162             swapping = false;
1163         }
1164         
1165         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1166             autoBurnLiquidityPairTokens();
1167         }
1168 
1169         bool takeFee = !swapping;
1170 
1171         // if any account belongs to _isExcludedFromFee account then remove the fee
1172         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1173             takeFee = false;
1174         }
1175         
1176         uint256 fees = 0;
1177         // only take fees on buys/sells, do not take on wallet transfers
1178         if(takeFee){
1179             // on sell
1180             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1181                 fees = amount.mul(sellTotalFees).div(100);
1182                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1183                 tokensForDev += fees * sellDevFee / sellTotalFees;
1184                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1185             }
1186             // on buy
1187             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1188         	    fees = amount.mul(buyTotalFees).div(100);
1189         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1190                 tokensForDev += fees * buyDevFee / buyTotalFees;
1191                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1192             }
1193             
1194             if(fees > 0){    
1195                 super._transfer(from, address(this), fees);
1196             }
1197         	
1198         	amount -= fees;
1199         }
1200 
1201         super._transfer(from, to, amount);
1202     }
1203 
1204     function swapTokensForEth(uint256 tokenAmount) private {
1205 
1206         // generate the uniswap pair path of token -> weth
1207         address[] memory path = new address[](2);
1208         path[0] = address(this);
1209         path[1] = uniswapV2Router.WETH();
1210 
1211         _approve(address(this), address(uniswapV2Router), tokenAmount);
1212 
1213         // make the swap
1214         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1215             tokenAmount,
1216             0, // accept any amount of ETH
1217             path,
1218             address(this),
1219             block.timestamp
1220         );
1221         
1222     }
1223     
1224     
1225     
1226     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1227         // approve token transfer to cover all possible scenarios
1228         _approve(address(this), address(uniswapV2Router), tokenAmount);
1229 
1230         // add the liquidity
1231         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1232             address(this),
1233             tokenAmount,
1234             0, // slippage is unavoidable
1235             0, // slippage is unavoidable
1236             deadAddress,
1237             block.timestamp
1238         );
1239     }
1240 
1241     function swapBack() private {
1242         uint256 contractBalance = balanceOf(address(this));
1243         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1244         bool success;
1245         
1246         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1247 
1248         if(contractBalance > swapTokensAtAmount * 20){
1249           contractBalance = swapTokensAtAmount * 20;
1250         }
1251         
1252         // Halve the amount of liquidity tokens
1253         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1254         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1255         
1256         uint256 initialETHBalance = address(this).balance;
1257 
1258         swapTokensForEth(amountToSwapForETH); 
1259         
1260         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1261         
1262         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1263         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1264         
1265         
1266         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1267         
1268         
1269         tokensForLiquidity = 0;
1270         tokensForMarketing = 0;
1271         tokensForDev = 0;
1272         
1273         (success,) = address(devWallet).call{value: ethForDev}("");
1274         
1275         if(liquidityTokens > 0 && ethForLiquidity > 0){
1276             addLiquidity(liquidityTokens, ethForLiquidity);
1277             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1278         }
1279         
1280         
1281         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1282     }
1283     
1284     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1285         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1286         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1287         lpBurnFrequency = _frequencyInSeconds;
1288         percentForLPBurn = _percent;
1289         lpBurnEnabled = _Enabled;
1290     }
1291     
1292     function autoBurnLiquidityPairTokens() internal returns (bool){
1293         
1294         lastLpBurnTime = block.timestamp;
1295         
1296         // get balance of liquidity pair
1297         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1298         
1299         // calculate amount to burn
1300         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1301         
1302         // pull tokens from pancakePair liquidity and move to dead address permanently
1303         if (amountToBurn > 0){
1304             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1305         }
1306         
1307         //sync price since this is not in a swap transaction!
1308         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1309         pair.sync();
1310         emit AutoNukeLP();
1311         return true;
1312     }
1313 
1314     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1315         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1316         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1317         lastManualLpBurnTime = block.timestamp;
1318         
1319         // get balance of liquidity pair
1320         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1321         
1322         // calculate amount to burn
1323         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1324         
1325         // pull tokens from pancakePair liquidity and move to dead address permanently
1326         if (amountToBurn > 0){
1327             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1328         }
1329         
1330         //sync price since this is not in a swap transaction!
1331         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1332         pair.sync();
1333         emit ManualNukeLP();
1334         return true;
1335     }
1336 }