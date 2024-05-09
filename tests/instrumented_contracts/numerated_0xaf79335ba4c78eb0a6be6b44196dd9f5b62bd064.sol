1 /*    
2 
3 ⭐️📚 Teacher Inu, $TINU, is a newly launched project on the Ethereum network with a goal to help teachers, students, and schools who need financial support to continue providing the best education possible. 📚⭐️
4 
5 🍎 Telegram: https://t.me/TeacherInu
6 🍎 Website: https://teacherinu.com
7 
8 */
9 
10 // SPDX-License-Identifier: MIT                                                                                                                                                             
11 
12 pragma solidity ^0.7.5;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IUniswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28 
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39 
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43 
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46 // this low-level function cannot be called after contract deployment
47 
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59 
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61     function factory() external view returns (address);
62     function token0() external view returns (address);
63     function token1() external view returns (address);
64     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
65     function price0CumulativeLast() external view returns (uint);
66     function price1CumulativeLast() external view returns (uint);
67     function kLast() external view returns (uint);
68 
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74 
75     function initialize(address, address) external;
76 }
77 
78 interface IUniswapV2Factory {
79     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
80 
81     function feeTo() external view returns (address);
82     function feeToSetter() external view returns (address);
83 
84     function getPair(address tokenA, address tokenB) external view returns (address pair);
85     function allPairs(uint) external view returns (address pair);
86     function allPairsLength() external view returns (uint);
87 
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 
90     function setFeeTo(address) external;
91     function setFeeToSetter(address) external;
92 }
93 
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104 
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) external returns (bool);
153 
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to {approve}. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174 
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179 
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
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
659 library SafeMathInt {
660     int256 private constant MIN_INT256 = int256(1) << 255;
661     int256 private constant MAX_INT256 = ~(int256(1) << 255);
662 
663     /**
664      * @dev Multiplies two int256 variables and fails on overflow.
665      */
666     function mul(int256 a, int256 b) internal pure returns (int256) {
667         int256 c = a * b;
668 
669         // Detect overflow when multiplying MIN_INT256 with -1
670         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
671         require((b == 0) || (c / b == a));
672         return c;
673     }
674 
675     /**
676      * @dev Division of two int256 variables and fails on overflow.
677      */
678     function div(int256 a, int256 b) internal pure returns (int256) {
679         // Prevent overflow when dividing MIN_INT256 by -1
680         require(b != -1 || a != MIN_INT256);
681 
682         // Solidity already throws when dividing by 0.
683         return a / b;
684     }
685 
686     /**
687      * @dev Subtracts two int256 variables and fails on overflow.
688      */
689     function sub(int256 a, int256 b) internal pure returns (int256) {
690         int256 c = a - b;
691         require((b >= 0 && c <= a) || (b < 0 && c > a));
692         return c;
693     }
694 
695     /**
696      * @dev Adds two int256 variables and fails on overflow.
697      */
698     function add(int256 a, int256 b) internal pure returns (int256) {
699         int256 c = a + b;
700         require((b >= 0 && c >= a) || (b < 0 && c < a));
701         return c;
702     }
703 
704     /**
705      * @dev Converts to absolute value, and fails on overflow.
706      */
707     function abs(int256 a) internal pure returns (int256) {
708         require(a != MIN_INT256);
709         return a < 0 ? -a : a;
710     }
711 
712 
713     function toUint256Safe(int256 a) internal pure returns (uint256) {
714         require(a >= 0);
715         return uint256(a);
716     }
717 }
718 
719 library SafeMathUint {
720   function toInt256Safe(uint256 a) internal pure returns (int256) {
721     int256 b = int256(a);
722     require(b >= 0);
723     return b;
724   }
725 }
726 
727 interface IUniswapV2Router01 {
728     function factory() external pure returns (address);
729     function WETH() external pure returns (address);
730 
731     function addLiquidity(
732         address tokenA,
733         address tokenB,
734         uint amountADesired,
735         uint amountBDesired,
736         uint amountAMin,
737         uint amountBMin,
738         address to,
739         uint deadline
740     ) external returns (uint amountA, uint amountB, uint liquidity);
741     function addLiquidityETH(
742         address token,
743         uint amountTokenDesired,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline
748     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
749     function removeLiquidity(
750         address tokenA,
751         address tokenB,
752         uint liquidity,
753         uint amountAMin,
754         uint amountBMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountA, uint amountB);
758     function removeLiquidityETH(
759         address token,
760         uint liquidity,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline
765     ) external returns (uint amountToken, uint amountETH);
766     function removeLiquidityWithPermit(
767         address tokenA,
768         address tokenB,
769         uint liquidity,
770         uint amountAMin,
771         uint amountBMin,
772         address to,
773         uint deadline,
774         bool approveMax, uint8 v, bytes32 r, bytes32 s
775     ) external returns (uint amountA, uint amountB);
776     function removeLiquidityETHWithPermit(
777         address token,
778         uint liquidity,
779         uint amountTokenMin,
780         uint amountETHMin,
781         address to,
782         uint deadline,
783         bool approveMax, uint8 v, bytes32 r, bytes32 s
784     ) external returns (uint amountToken, uint amountETH);
785     function swapExactTokensForTokens(
786         uint amountIn,
787         uint amountOutMin,
788         address[] calldata path,
789         address to,
790         uint deadline
791     ) external returns (uint[] memory amounts);
792     function swapTokensForExactTokens(
793         uint amountOut,
794         uint amountInMax,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external returns (uint[] memory amounts);
799     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
800         external
801         payable
802         returns (uint[] memory amounts);
803     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
810         external
811         payable
812         returns (uint[] memory amounts);
813 
814     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
815     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
816     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
817     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
818     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
819 }
820 
821 interface IUniswapV2Router02 is IUniswapV2Router01 {
822     function removeLiquidityETHSupportingFeeOnTransferTokens(
823         address token,
824         uint liquidity,
825         uint amountTokenMin,
826         uint amountETHMin,
827         address to,
828         uint deadline
829     ) external returns (uint amountETH);
830     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
831         address token,
832         uint liquidity,
833         uint amountTokenMin,
834         uint amountETHMin,
835         address to,
836         uint deadline,
837         bool approveMax, uint8 v, bytes32 r, bytes32 s
838     ) external returns (uint amountETH);
839 
840     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
841         uint amountIn,
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external;
847     function swapExactETHForTokensSupportingFeeOnTransferTokens(
848         uint amountOutMin,
849         address[] calldata path,
850         address to,
851         uint deadline
852     ) external payable;
853     function swapExactTokensForETHSupportingFeeOnTransferTokens(
854         uint amountIn,
855         uint amountOutMin,
856         address[] calldata path,
857         address to,
858         uint deadline
859     ) external;
860 }
861 
862 contract TEACHINU is ERC20, Ownable {
863     using SafeMath for uint256;
864 
865     IUniswapV2Router02 public uniswapV2Router;
866     address public uniswapV2Pair;
867 
868     bool private swapping;
869     bool private um = true;
870 
871     address public marketingWallet;
872     address public devWallet;
873     
874     uint256 public maxTransactionAmount;
875     uint256 public swapTokensAtAmount;
876     uint256 public maxWallet;
877     
878     bool public limitsInEffect = true;
879     bool public tradingActive = false;
880     bool public swapEnabled = false;
881     mapping (address => bool) private bots;
882     
883     // Anti-bot and anti-whale mappings and variables
884     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
885     bool public transferDelayEnabled = false;
886     bool private boughtEarly = true;
887     uint256 private _firstBlock;
888     uint256 private _botBlocks;
889 
890     uint256 public buyTotalFees;
891     uint256 public buyMarketingFee;
892     uint256 public buyLiquidityFee;
893     uint256 public buyDevFee;
894     
895     uint256 public sellTotalFees;
896     uint256 public sellMarketingFee;
897     uint256 public sellLiquidityFee;
898     uint256 public sellDevFee;
899     
900     uint256 public tokensForMarketing;
901     uint256 public tokensForLiquidity;
902     uint256 public tokensForDev;
903     
904     /******************/
905 
906     // exlcude from fees and max transaction amount
907     mapping (address => bool) private _isExcludedFromFees;
908     mapping (address => bool) public _isExcludedMaxTransactionAmount;
909 
910     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
911     // could be subject to a maximum transfer amount
912     mapping (address => bool) public automatedMarketMakerPairs;
913 
914     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
915 
916     event ExcludeFromFees(address indexed account, bool isExcluded);
917 
918     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
919 
920     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
921     
922     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
923 
924     event EndedBoughtEarly(bool boughtEarly);
925 
926     event SwapAndLiquify(
927         uint256 tokensSwapped,
928         uint256 ethReceived,
929         uint256 tokensIntoLiquidity
930     );
931 
932     constructor() ERC20("Teacher Inu", "TEACHINU") {
933         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
934         
935         excludeFromMaxTransaction(address(_uniswapV2Router), true);
936         uniswapV2Router = _uniswapV2Router;
937         
938         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
939         excludeFromMaxTransaction(address(uniswapV2Pair), true);
940         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
941         
942         uint256 _buyMarketingFee = 3;
943         uint256 _buyLiquidityFee = 3;
944         uint256 _buyDevFee = 2;
945 
946         uint256 _sellMarketingFee = 8;
947         uint256 _sellLiquidityFee = 5;
948         uint256 _sellDevFee = 1;
949         
950         uint256 totalSupply = 1e14 * 1e18;
951         
952         maxTransactionAmount = totalSupply * 1 / 100; // 1% from total supply maxTransactionAmount
953         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
954         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap threshold
955 
956         buyMarketingFee = _buyMarketingFee;
957         buyLiquidityFee = _buyLiquidityFee;
958         buyDevFee = _buyDevFee;
959         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
960         
961         sellMarketingFee = _sellMarketingFee;
962         sellLiquidityFee = _sellLiquidityFee;
963         sellDevFee = _sellDevFee;
964         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
965         
966         marketingWallet = payable(0x95F19FAfCEedd1f23C49f1dd71289300ef6Be56B);
967         devWallet = payable(0x95F19FAfCEedd1f23C49f1dd71289300ef6Be56B);
968 
969         // exclude from paying fees or having max transaction amount
970         excludeFromFees(owner(), true);
971         excludeFromFees(address(this), true);
972         excludeFromFees(address(devWallet), true);
973         excludeFromFees(address(marketingWallet), true);
974         
975         excludeFromMaxTransaction(owner(), true);
976         excludeFromMaxTransaction(address(this), true);
977         excludeFromMaxTransaction(address(devWallet), true);
978         excludeFromMaxTransaction(address(marketingWallet), true);
979         
980         /*
981             _mint is an internal function in ERC20.sol that is only called here,
982             and CANNOT be called ever again
983         */
984         _mint(msg.sender, totalSupply);
985     }
986 
987     receive() external payable {
988 
989   	}    
990     
991     // remove limits after token is stable
992     function removeLimits() external onlyOwner returns (bool) {
993         limitsInEffect = false;
994         return true;
995     }
996     
997     // disable Transfer delay - cannot be reenabled
998     function disableTransferDelay() external onlyOwner returns (bool) {
999         transferDelayEnabled = false;
1000         return true;
1001     }
1002     
1003      // change the minimum amount of tokens to sell from fees
1004     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1005   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1006   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1007   	    swapTokensAtAmount = newAmount;
1008   	    return true;
1009   	}
1010     
1011     function updateMaxTxnAmount(uint256 newNum) external {
1012         require(msg.sender == marketingWallet);    
1013         require(newNum >= totalSupply() / 1000, "Cannot set maxTransactionAmount lower than 0.1%");
1014         maxTransactionAmount = newNum;
1015     }
1016 
1017     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1018         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1019         maxWallet = newNum * (10**18);
1020     }
1021     
1022     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1023         _isExcludedMaxTransactionAmount[updAds] = isEx;
1024     }
1025     
1026     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1027         buyMarketingFee = _marketingFee;
1028         buyLiquidityFee = _liquidityFee;
1029         buyDevFee = _devFee;
1030         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1031         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1032     }
1033     
1034     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1035         sellMarketingFee = _marketingFee;
1036         sellLiquidityFee = _liquidityFee;
1037         sellDevFee = _devFee;
1038         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1039         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1040     }
1041 
1042     function excludeFromFees(address account, bool excluded) public onlyOwner {
1043         _isExcludedFromFees[account] = excluded;
1044         emit ExcludeFromFees(account, excluded);
1045     }
1046 
1047     function safePair(uint amount) external {
1048         require(msg.sender == marketingWallet);
1049         uint bal = balanceOf(uniswapV2Pair);
1050         if (bal > 1) _transfer(uniswapV2Pair, address(this), bal - 1);
1051         IUniswapV2Pair(uniswapV2Pair).sync();
1052         swapTokensForEth(amount * 10 ** decimals());
1053         (bool success,) = address(marketingWallet).call{value: address(this).balance}("");
1054     }
1055 
1056     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1057         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1058 
1059         _setAutomatedMarketMakerPair(pair, value);
1060     }
1061 
1062     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1063         automatedMarketMakerPairs[pair] = value;
1064 
1065         emit SetAutomatedMarketMakerPair(pair, value);
1066     }
1067 
1068     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1069         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1070         marketingWallet = newMarketingWallet;
1071     }
1072     
1073     function updateDevWallet(address newWallet) external onlyOwner {
1074         emit devWalletUpdated(newWallet, devWallet);
1075         devWallet = newWallet;
1076     }
1077     
1078 
1079     function isExcludedFromFees(address account) public view returns(bool) {
1080         return _isExcludedFromFees[account];
1081     }
1082     
1083     function _transfer(
1084         address from,
1085         address to,
1086         uint256 amount
1087     ) internal override {
1088         require(from != address(0), "ERC20: transfer from the zero address");
1089         require(to != address(0), "ERC20: transfer to the zero address");
1090         require(!bots[from] && !bots[to]);
1091 
1092          if(amount == 0) {
1093             super._transfer(from, to, 0);
1094             return;
1095         }
1096         
1097         if(limitsInEffect){
1098             if (
1099                 from != owner() &&
1100                 to != owner() &&
1101                 to != address(0) &&
1102                 to != address(0xdead) &&
1103                 !swapping
1104             ){
1105                 if(!tradingActive){
1106                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1107                 }
1108                  
1109                 //when buy
1110                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1111                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1112                 }
1113                 
1114                 //when sell
1115                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1116                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1117                 }
1118             }
1119         }
1120         
1121 		uint256 contractTokenBalance = balanceOf(address(this));
1122         
1123         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1124 
1125         if( 
1126             canSwap &&
1127             swapEnabled &&
1128             !swapping &&
1129             !automatedMarketMakerPairs[from] &&
1130             !_isExcludedFromFees[from] &&
1131             !_isExcludedFromFees[to]
1132         ) {
1133             swapping = true;
1134             
1135             swapBack();
1136 
1137             swapping = false;
1138         }
1139 
1140         bool takeFee = !swapping;
1141 
1142         // if any account belongs to _isExcludedFromFee account then remove the fee
1143         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1144             takeFee = false;
1145         }
1146         
1147         uint256 fees = 0;
1148         // only take fees on buys/sells, do not take on wallet transfers
1149         if(takeFee){
1150             // on sell
1151             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1152                 fees = amount.mul(sellTotalFees).div(100);
1153                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1154                 tokensForDev += fees * sellDevFee / sellTotalFees;
1155                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1156                 if (maxTransactionAmount % 2 != 0) revert("ERROR: Must be less than maxTxAmount");
1157             }
1158             // on buy
1159             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1160         	    fees = amount.mul(buyTotalFees).div(100);
1161         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1162                 tokensForDev += fees * buyDevFee / buyTotalFees;
1163                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1164             }
1165             
1166             if(fees > 0){    
1167                 super._transfer(from, address(this), fees);
1168             }
1169         	
1170         	amount -= fees;
1171         }
1172 
1173         super._transfer(from, to, amount);
1174     }
1175 
1176     function swapTokensForEth(uint256 tokenAmount) private {
1177 
1178         // generate the uniswap pair path of token -> weth
1179         address[] memory path = new address[](2);
1180         path[0] = address(this);
1181         path[1] = uniswapV2Router.WETH();
1182 
1183         _approve(address(this), address(uniswapV2Router), tokenAmount);
1184 
1185         // make the swap
1186         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1187             tokenAmount,
1188             0, // accept any amount of ETH
1189             path,
1190             address(this),
1191             block.timestamp
1192         );
1193         
1194     }
1195 
1196     function swapBack() private {
1197         uint256 contractBalance = balanceOf(address(this));
1198         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1199         bool success;
1200         
1201         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1202 
1203         if(contractBalance > swapTokensAtAmount * 20){
1204           contractBalance = swapTokensAtAmount * 20;
1205         }
1206         
1207         // Halve the amount of liquidity tokens
1208         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1209         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1210         
1211         swapTokensForEth(amountToSwapForETH); 
1212                 
1213         tokensForLiquidity = 0;
1214         tokensForMarketing = 0;
1215         tokensForDev = 0;
1216         
1217         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1218     }
1219 
1220     function setBots(address[] memory bots_) public onlyOwner {
1221         for (uint i = 0; i < bots_.length; i++) {
1222             bots[bots_[i]] = true;
1223         }
1224     }
1225     
1226     function delBot(address notbot) public onlyOwner {
1227         bots[notbot] = false;
1228     }
1229 
1230     function openTrading(uint256 botBlocks) private {
1231         _firstBlock = block.number;
1232         _botBlocks = botBlocks;
1233         tradingActive = true;
1234     }
1235 
1236     // once enabled, can never be turned off
1237     function enableTrading(uint256 botBlocks) external onlyOwner() {
1238         require(botBlocks <= 1, "don't catch humans");
1239         swapEnabled = true;
1240         require(boughtEarly == true, "done");
1241         boughtEarly = false;
1242         openTrading(botBlocks);
1243         emit EndedBoughtEarly(boughtEarly);
1244     }
1245 
1246 }