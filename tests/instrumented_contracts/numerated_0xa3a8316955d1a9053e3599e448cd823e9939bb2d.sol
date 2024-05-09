1 /**
2 */
3 
4 /*
5 https://tricktoken.com/
6 @trickcommunity
7 
8 */
9 
10 // SPDX-License-Identifier: MIT                                                                               
11                                                     
12 pragma solidity 0.8.9;
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
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57 
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66 
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72 
73     function initialize(address, address) external;
74 }
75 
76 interface IUniswapV2Factory {
77     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
78 
79     function feeTo() external view returns (address);
80     function feeToSetter() external view returns (address);
81 
82     function getPair(address tokenA, address tokenB) external view returns (address pair);
83     function allPairs(uint) external view returns (address pair);
84     function allPairsLength() external view returns (uint);
85 
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 
88     function setFeeTo(address) external;
89     function setFeeToSetter(address) external;
90 }
91 
92 interface IERC20 {
93     /**
94      * @dev Returns the amount of tokens in existence.
95      */
96     function totalSupply() external view returns (uint256);
97 
98     /**
99      * @dev Returns the amount of tokens owned by `account`.
100      */
101     function balanceOf(address account) external view returns (uint256);
102 
103     /**
104      * @dev Moves `amount` tokens from the caller's account to `recipient`.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transfer(address recipient, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Returns the remaining number of tokens that `spender` will be
114      * allowed to spend on behalf of `owner` through {transferFrom}. This is
115      * zero by default.
116      *
117      * This value changes when {approve} or {transferFrom} are called.
118      */
119     function allowance(address owner, address spender) external view returns (uint256);
120 
121     /**
122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
127      * that someone may use both the old and the new allowance by unfortunate
128      * transaction ordering. One possible solution to mitigate this race
129      * condition is to first reduce the spender's allowance to 0 and set the
130      * desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address spender, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Moves `amount` tokens from `sender` to `recipient` using the
139      * allowance mechanism. `amount` is then deducted from the caller's
140      * allowance.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transferFrom(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) external returns (bool);
151 
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 interface IERC20Metadata is IERC20 {
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() external view returns (string memory);
172 
173     /**
174      * @dev Returns the symbol of the token.
175      */
176     function symbol() external view returns (string memory);
177 
178     /**
179      * @dev Returns the decimals places of the token.
180      */
181     function decimals() external view returns (uint8);
182 }
183 
184 
185 contract ERC20 is Context, IERC20, IERC20Metadata {
186     using SafeMath for uint256;
187 
188     mapping(address => uint256) private _balances;
189 
190     mapping(address => mapping(address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193 
194     string private _name;
195     string private _symbol;
196 
197     /**
198      * @dev Sets the values for {name} and {symbol}.
199      *
200      * The default value of {decimals} is 18. To select a different value for
201      * {decimals} you should overload it.
202      *
203      * All two of these values are immutable: they can only be set once during
204      * construction.
205      */
206     constructor(string memory name_, string memory symbol_) {
207         _name = name_;
208         _symbol = symbol_;
209     }
210 
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() public view virtual override returns (string memory) {
215         return _name;
216     }
217 
218     /**
219      * @dev Returns the symbol of the token, usually a shorter version of the
220      * name.
221      */
222     function symbol() public view virtual override returns (string memory) {
223         return _symbol;
224     }
225 
226     /**
227      * @dev Returns the number of decimals used to get its user representation.
228      * For example, if `decimals` equals `2`, a balance of `505` tokens should
229      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
230      *
231      * Tokens usually opt for a value of 18, imitating the relationship between
232      * Ether and Wei. This is the value {ERC20} uses, unless this function is
233      * overridden;
234      *
235      * NOTE: This information is only used for _display_ purposes: it in
236      * no way affects any of the arithmetic of the contract, including
237      * {IERC20-balanceOf} and {IERC20-transfer}.
238      */
239     function decimals() public view virtual override returns (uint8) {
240         return 18;
241     }
242 
243     /**
244      * @dev See {IERC20-totalSupply}.
245      */
246     function totalSupply() public view virtual override returns (uint256) {
247         return _totalSupply;
248     }
249 
250     /**
251      * @dev See {IERC20-balanceOf}.
252      */
253     function balanceOf(address account) public view virtual override returns (uint256) {
254         return _balances[account];
255     }
256 
257     /**
258      * @dev See {IERC20-transfer}.
259      *
260      * Requirements:
261      *
262      * - `recipient` cannot be the zero address.
263      * - the caller must have a balance of at least `amount`.
264      */
265     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(address owner, address spender) public view virtual override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     /**
278      * @dev See {IERC20-approve}.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function approve(address spender, uint256 amount) public virtual override returns (bool) {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288 
289     /**
290      * @dev See {IERC20-transferFrom}.
291      *
292      * Emits an {Approval} event indicating the updated allowance. This is not
293      * required by the EIP. See the note at the beginning of {ERC20}.
294      *
295      * Requirements:
296      *
297      * - `sender` and `recipient` cannot be the zero address.
298      * - `sender` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``sender``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
326         return true;
327     }
328 
329     /**
330      * @dev Atomically decreases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      * - `spender` must have allowance for the caller of at least
341      * `subtractedValue`.
342      */
343     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
344         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
345         return true;
346     }
347 
348     /**
349      * @dev Moves tokens `amount` from `sender` to `recipient`.
350      *
351      * This is internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `sender` cannot be the zero address.
359      * - `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) internal virtual {
367         require(sender != address(0), "ERC20: transfer from the zero address");
368         require(recipient != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(sender, recipient, amount);
371 
372         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
373         _balances[recipient] = _balances[recipient].add(amount);
374         emit Transfer(sender, recipient, amount);
375     }
376 
377     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
378      * the total supply.
379      *
380      * Emits a {Transfer} event with `from` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      */
386     function _mint(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: mint to the zero address");
388 
389         _beforeTokenTransfer(address(0), account, amount);
390 
391         _totalSupply = _totalSupply.add(amount);
392         _balances[account] = _balances[account].add(amount);
393         emit Transfer(address(0), account, amount);
394     }
395 
396     /**
397      * @dev Destroys `amount` tokens from `account`, reducing the
398      * total supply.
399      *
400      * Emits a {Transfer} event with `to` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      * - `account` must have at least `amount` tokens.
406      */
407     function _burn(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: burn from the zero address");
409 
410         _beforeTokenTransfer(account, address(0), amount);
411 
412         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
413         _totalSupply = _totalSupply.sub(amount);
414         emit Transfer(account, address(0), amount);
415     }
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
419      *
420      * This internal function is equivalent to `approve`, and can be used to
421      * e.g. set automatic allowances for certain subsystems, etc.
422      *
423      * Emits an {Approval} event.
424      *
425      * Requirements:
426      *
427      * - `owner` cannot be the zero address.
428      * - `spender` cannot be the zero address.
429      */
430     function _approve(
431         address owner,
432         address spender,
433         uint256 amount
434     ) internal virtual {
435         require(owner != address(0), "ERC20: approve from the zero address");
436         require(spender != address(0), "ERC20: approve to the zero address");
437 
438         _allowances[owner][spender] = amount;
439         emit Approval(owner, spender, amount);
440     }
441 
442     /**
443      * @dev Hook that is called before any transfer of tokens. This includes
444      * minting and burning.
445      *
446      * Calling conditions:
447      *
448      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
449      * will be to transferred to `to`.
450      * - when `from` is zero, `amount` tokens will be minted for `to`.
451      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
452      * - `from` and `to` are never both zero.
453      *
454      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
455      */
456     function _beforeTokenTransfer(
457         address from,
458         address to,
459         uint256 amount
460     ) internal virtual {}
461 }
462 
463 library SafeMath {
464     /**
465      * @dev Returns the addition of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `+` operator.
469      *
470      * Requirements:
471      *
472      * - Addition cannot overflow.
473      */
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         uint256 c = a + b;
476         require(c >= a, "SafeMath: addition overflow");
477 
478         return c;
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting on
483      * overflow (when the result is negative).
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
492         return sub(a, b, "SafeMath: subtraction overflow");
493     }
494 
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
497      * overflow (when the result is negative).
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      *
503      * - Subtraction cannot overflow.
504      */
505     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b <= a, errorMessage);
507         uint256 c = a - b;
508 
509         return c;
510     }
511 
512     /**
513      * @dev Returns the multiplication of two unsigned integers, reverting on
514      * overflow.
515      *
516      * Counterpart to Solidity's `*` operator.
517      *
518      * Requirements:
519      *
520      * - Multiplication cannot overflow.
521      */
522     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
523         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
524         // benefit is lost if 'b' is also tested.
525         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
526         if (a == 0) {
527             return 0;
528         }
529 
530         uint256 c = a * b;
531         require(c / a == b, "SafeMath: multiplication overflow");
532 
533         return c;
534     }
535 
536     /**
537      * @dev Returns the integer division of two unsigned integers. Reverts on
538      * division by zero. The result is rounded towards zero.
539      *
540      * Counterpart to Solidity's `/` operator. Note: this function uses a
541      * `revert` opcode (which leaves remaining gas untouched) while Solidity
542      * uses an invalid opcode to revert (consuming all remaining gas).
543      *
544      * Requirements:
545      *
546      * - The divisor cannot be zero.
547      */
548     function div(uint256 a, uint256 b) internal pure returns (uint256) {
549         return div(a, b, "SafeMath: division by zero");
550     }
551 
552     /**
553      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
554      * division by zero. The result is rounded towards zero.
555      *
556      * Counterpart to Solidity's `/` operator. Note: this function uses a
557      * `revert` opcode (which leaves remaining gas untouched) while Solidity
558      * uses an invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
565         require(b > 0, errorMessage);
566         uint256 c = a / b;
567         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
568 
569         return c;
570     }
571 
572     /**
573      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
574      * Reverts when dividing by zero.
575      *
576      * Counterpart to Solidity's `%` operator. This function uses a `revert`
577      * opcode (which leaves remaining gas untouched) while Solidity uses an
578      * invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
585         return mod(a, b, "SafeMath: modulo by zero");
586     }
587 
588     /**
589      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
590      * Reverts with custom message when dividing by zero.
591      *
592      * Counterpart to Solidity's `%` operator. This function uses a `revert`
593      * opcode (which leaves remaining gas untouched) while Solidity uses an
594      * invalid opcode to revert (consuming all remaining gas).
595      *
596      * Requirements:
597      *
598      * - The divisor cannot be zero.
599      */
600     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
601         require(b != 0, errorMessage);
602         return a % b;
603     }
604 }
605 
606 contract Ownable is Context {
607     address private _owner;
608 
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610     
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor () {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(_owner == _msgSender(), "Ownable: caller is not the owner");
632         _;
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public virtual onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646 
647     /**
648      * @dev Transfers ownership of the contract to a new account (`newOwner`).
649      * Can only be called by the current owner.
650      */
651     function transferOwnership(address newOwner) public virtual onlyOwner {
652         require(newOwner != address(0), "Ownable: new owner is the zero address");
653         emit OwnershipTransferred(_owner, newOwner);
654         _owner = newOwner;
655     }
656 }
657 
658 
659 
660 library SafeMathInt {
661     int256 private constant MIN_INT256 = int256(1) << 255;
662     int256 private constant MAX_INT256 = ~(int256(1) << 255);
663 
664     /**
665      * @dev Multiplies two int256 variables and fails on overflow.
666      */
667     function mul(int256 a, int256 b) internal pure returns (int256) {
668         int256 c = a * b;
669 
670         // Detect overflow when multiplying MIN_INT256 with -1
671         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
672         require((b == 0) || (c / b == a));
673         return c;
674     }
675 
676     /**
677      * @dev Division of two int256 variables and fails on overflow.
678      */
679     function div(int256 a, int256 b) internal pure returns (int256) {
680         // Prevent overflow when dividing MIN_INT256 by -1
681         require(b != -1 || a != MIN_INT256);
682 
683         // Solidity already throws when dividing by 0.
684         return a / b;
685     }
686 
687     /**
688      * @dev Subtracts two int256 variables and fails on overflow.
689      */
690     function sub(int256 a, int256 b) internal pure returns (int256) {
691         int256 c = a - b;
692         require((b >= 0 && c <= a) || (b < 0 && c > a));
693         return c;
694     }
695 
696     /**
697      * @dev Adds two int256 variables and fails on overflow.
698      */
699     function add(int256 a, int256 b) internal pure returns (int256) {
700         int256 c = a + b;
701         require((b >= 0 && c >= a) || (b < 0 && c < a));
702         return c;
703     }
704 
705     /**
706      * @dev Converts to absolute value, and fails on overflow.
707      */
708     function abs(int256 a) internal pure returns (int256) {
709         require(a != MIN_INT256);
710         return a < 0 ? -a : a;
711     }
712 
713 
714     function toUint256Safe(int256 a) internal pure returns (uint256) {
715         require(a >= 0);
716         return uint256(a);
717     }
718 }
719 
720 library SafeMathUint {
721   function toInt256Safe(uint256 a) internal pure returns (int256) {
722     int256 b = int256(a);
723     require(b >= 0);
724     return b;
725   }
726 }
727 
728 
729 interface IUniswapV2Router01 {
730     function factory() external pure returns (address);
731     function WETH() external pure returns (address);
732 
733     function addLiquidity(
734         address tokenA,
735         address tokenB,
736         uint amountADesired,
737         uint amountBDesired,
738         uint amountAMin,
739         uint amountBMin,
740         address to,
741         uint deadline
742     ) external returns (uint amountA, uint amountB, uint liquidity);
743     function addLiquidityETH(
744         address token,
745         uint amountTokenDesired,
746         uint amountTokenMin,
747         uint amountETHMin,
748         address to,
749         uint deadline
750     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
751     function removeLiquidity(
752         address tokenA,
753         address tokenB,
754         uint liquidity,
755         uint amountAMin,
756         uint amountBMin,
757         address to,
758         uint deadline
759     ) external returns (uint amountA, uint amountB);
760     function removeLiquidityETH(
761         address token,
762         uint liquidity,
763         uint amountTokenMin,
764         uint amountETHMin,
765         address to,
766         uint deadline
767     ) external returns (uint amountToken, uint amountETH);
768     function removeLiquidityWithPermit(
769         address tokenA,
770         address tokenB,
771         uint liquidity,
772         uint amountAMin,
773         uint amountBMin,
774         address to,
775         uint deadline,
776         bool approveMax, uint8 v, bytes32 r, bytes32 s
777     ) external returns (uint amountA, uint amountB);
778     function removeLiquidityETHWithPermit(
779         address token,
780         uint liquidity,
781         uint amountTokenMin,
782         uint amountETHMin,
783         address to,
784         uint deadline,
785         bool approveMax, uint8 v, bytes32 r, bytes32 s
786     ) external returns (uint amountToken, uint amountETH);
787     function swapExactTokensForTokens(
788         uint amountIn,
789         uint amountOutMin,
790         address[] calldata path,
791         address to,
792         uint deadline
793     ) external returns (uint[] memory amounts);
794     function swapTokensForExactTokens(
795         uint amountOut,
796         uint amountInMax,
797         address[] calldata path,
798         address to,
799         uint deadline
800     ) external returns (uint[] memory amounts);
801     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
802         external
803         payable
804         returns (uint[] memory amounts);
805     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
806         external
807         returns (uint[] memory amounts);
808     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
809         external
810         returns (uint[] memory amounts);
811     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
812         external
813         payable
814         returns (uint[] memory amounts);
815 
816     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
817     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
818     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
819     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
820     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
821 }
822 
823 interface IUniswapV2Router02 is IUniswapV2Router01 {
824     function removeLiquidityETHSupportingFeeOnTransferTokens(
825         address token,
826         uint liquidity,
827         uint amountTokenMin,
828         uint amountETHMin,
829         address to,
830         uint deadline
831     ) external returns (uint amountETH);
832     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
833         address token,
834         uint liquidity,
835         uint amountTokenMin,
836         uint amountETHMin,
837         address to,
838         uint deadline,
839         bool approveMax, uint8 v, bytes32 r, bytes32 s
840     ) external returns (uint amountETH);
841 
842     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
843         uint amountIn,
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         uint deadline
848     ) external;
849     function swapExactETHForTokensSupportingFeeOnTransferTokens(
850         uint amountOutMin,
851         address[] calldata path,
852         address to,
853         uint deadline
854     ) external payable;
855     function swapExactTokensForETHSupportingFeeOnTransferTokens(
856         uint amountIn,
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external;
862 }
863 
864 contract TRICK is ERC20, Ownable {
865     using SafeMath for uint256;
866 
867     IUniswapV2Router02 public immutable uniswapV2Router;
868     address public immutable uniswapV2Pair;
869     address public constant deadAddress = address(0xdead);
870 
871     bool private swapping;
872 
873     address public marketingWallet;
874     address public devWallet;
875     
876     uint256 public maxTransactionAmount;
877     uint256 public swapTokensAtAmount;
878     uint256 public maxWallet;
879     
880     uint256 public percentForLPBurn = 25; // 25 = .25%
881     bool public lpBurnEnabled = false;
882     uint256 public lpBurnFrequency = 3600 seconds;
883     uint256 public lastLpBurnTime;
884     
885     uint256 public manualBurnFrequency = 30 minutes;
886     uint256 public lastManualLpBurnTime;
887 
888     bool public limitsInEffect = true;
889     bool public tradingActive = false;
890     bool public swapEnabled = false;
891     
892      // Anti-bot and anti-whale mappings and variables
893     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
894     bool public transferDelayEnabled = true;
895 
896     uint256 public buyTotalFees;
897     uint256 public buyMarketingFee;
898     uint256 public buyLiquidityFee;
899     uint256 public buyDevFee;
900     
901     uint256 public sellTotalFees;
902     uint256 public sellMarketingFee;
903     uint256 public sellLiquidityFee;
904     uint256 public sellDevFee;
905     
906     uint256 public tokensForMarketing;
907     uint256 public tokensForLiquidity;
908     uint256 public tokensForDev;
909     
910     /******************/
911 
912     // exlcude from fees and max transaction amount
913     mapping (address => bool) private _isExcludedFromFees;
914     mapping (address => bool) public _isExcludedMaxTransactionAmount;
915 
916     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
917     // could be subject to a maximum transfer amount
918     mapping (address => bool) public automatedMarketMakerPairs;
919 
920     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
921 
922     event ExcludeFromFees(address indexed account, bool isExcluded);
923 
924     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
925 
926     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
927     
928     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
929 
930     event SwapAndLiquify(
931         uint256 tokensSwapped,
932         uint256 ethReceived,
933         uint256 tokensIntoLiquidity
934     );
935     
936     event AutoNukeLP();
937     
938     event ManualNukeLP();
939 
940     constructor() ERC20("Trick", "TRICK") {
941         
942         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
943         
944         excludeFromMaxTransaction(address(_uniswapV2Router), true);
945         uniswapV2Router = _uniswapV2Router;
946         
947         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
948         excludeFromMaxTransaction(address(uniswapV2Pair), true);
949         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
950         
951         uint256 _buyMarketingFee = 25;
952         uint256 _buyLiquidityFee = 0;
953         uint256 _buyDevFee = 0;
954 
955         uint256 _sellMarketingFee = 38;
956         uint256 _sellLiquidityFee = 0;
957         uint256 _sellDevFee = 0;
958         
959         uint256 totalSupply = 1 * 1e12 * 1e18;
960         
961         maxTransactionAmount = totalSupply * 1 / 100; // 0.1% maxTransactionAmountTxn
962         maxWallet = totalSupply * 1 / 100; // .5% maxWallet
963         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.05% swap wallet
964 
965         buyMarketingFee = _buyMarketingFee;
966         buyLiquidityFee = _buyLiquidityFee;
967         buyDevFee = _buyDevFee;
968         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
969         
970         sellMarketingFee = _sellMarketingFee;
971         sellLiquidityFee = _sellLiquidityFee;
972         sellDevFee = _sellDevFee;
973         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
974         
975         marketingWallet = address(owner()); // set as marketing wallet
976         devWallet = address(owner()); // set as dev wallet
977 
978         // exclude from paying fees or having max transaction amount
979         excludeFromFees(owner(), true);
980         excludeFromFees(address(this), true);
981         excludeFromFees(address(0xdead), true);
982         
983         excludeFromMaxTransaction(owner(), true);
984         excludeFromMaxTransaction(address(this), true);
985         excludeFromMaxTransaction(address(0xdead), true);
986         
987         /*
988             _mint is an internal function in ERC20.sol that is only called here,
989             and CANNOT be called ever again
990         */
991         _mint(msg.sender, totalSupply);
992     }
993 
994     receive() external payable {
995 
996   	}
997 
998     // once enabled, can never be turned off
999     function enableTrading() external onlyOwner {
1000         tradingActive = true;
1001         swapEnabled = true;
1002         lastLpBurnTime = block.timestamp;
1003     }
1004     
1005     // remove limits after token is stable
1006     function removeLimits() external onlyOwner returns (bool){
1007         limitsInEffect = false;
1008         return true;
1009     }
1010     
1011     // disable Transfer delay - cannot be reenabled
1012     function disableTransferDelay() external onlyOwner returns (bool){
1013         transferDelayEnabled = false;
1014         return true;
1015     }
1016     
1017      // change the minimum amount of tokens to sell from fees
1018     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1019   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1020   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1021   	    swapTokensAtAmount = newAmount;
1022   	    return true;
1023   	}
1024     
1025     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1026         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1027         maxTransactionAmount = newNum * (10**18);
1028     }
1029 
1030     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1031         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1032         maxWallet = newNum * (10**18);
1033     }
1034     
1035     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1036         _isExcludedMaxTransactionAmount[updAds] = isEx;
1037     }
1038     
1039     // only use to disable contract sales if absolutely necessary (emergency use only)
1040     function updateSwapEnabled(bool enabled) external onlyOwner(){
1041         swapEnabled = enabled;
1042     }
1043     
1044     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1045         buyMarketingFee = _marketingFee;
1046         buyLiquidityFee = _liquidityFee;
1047         buyDevFee = _devFee;
1048         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1049         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1050     }
1051     
1052     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1053         sellMarketingFee = _marketingFee;
1054         sellLiquidityFee = _liquidityFee;
1055         sellDevFee = _devFee;
1056         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1057         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1058     }
1059 
1060     function excludeFromFees(address account, bool excluded) public onlyOwner {
1061         _isExcludedFromFees[account] = excluded;
1062         emit ExcludeFromFees(account, excluded);
1063     }
1064 
1065     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1066         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1067 
1068         _setAutomatedMarketMakerPair(pair, value);
1069     }
1070 
1071     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1072         automatedMarketMakerPairs[pair] = value;
1073 
1074         emit SetAutomatedMarketMakerPair(pair, value);
1075     }
1076 
1077     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1078         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1079         marketingWallet = newMarketingWallet;
1080     }
1081     
1082     function updateDevWallet(address newWallet) external onlyOwner {
1083         emit devWalletUpdated(newWallet, devWallet);
1084         devWallet = newWallet;
1085     }
1086     
1087 
1088     function isExcludedFromFees(address account) public view returns(bool) {
1089         return _isExcludedFromFees[account];
1090     }
1091     
1092     event BoughtEarly(address indexed sniper);
1093 
1094     function _transfer(
1095         address from,
1096         address to,
1097         uint256 amount
1098     ) internal override {
1099         require(from != address(0), "ERC20: transfer from the zero address");
1100         require(to != address(0), "ERC20: transfer to the zero address");
1101         
1102          if(amount == 0) {
1103             super._transfer(from, to, 0);
1104             return;
1105         }
1106         
1107         if(limitsInEffect){
1108             if (
1109                 from != owner() &&
1110                 to != owner() &&
1111                 to != address(0) &&
1112                 to != address(0xdead) &&
1113                 !swapping
1114             ){
1115                 if(!tradingActive){
1116                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1117                 }
1118 
1119                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1120                 if (transferDelayEnabled){
1121                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1122                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1123                         _holderLastTransferTimestamp[tx.origin] = block.number;
1124                     }
1125                 }
1126                  
1127                 //when buy
1128                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1129                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1130                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1131                 }
1132                 
1133                 //when sell
1134                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1135                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1136                 }
1137                 else if(!_isExcludedMaxTransactionAmount[to]){
1138                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1139                 }
1140             }
1141         }
1142         
1143         
1144         
1145 		uint256 contractTokenBalance = balanceOf(address(this));
1146         
1147         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1148 
1149         if( 
1150             canSwap &&
1151             swapEnabled &&
1152             !swapping &&
1153             !automatedMarketMakerPairs[from] &&
1154             !_isExcludedFromFees[from] &&
1155             !_isExcludedFromFees[to]
1156         ) {
1157             swapping = true;
1158             
1159             swapBack();
1160 
1161             swapping = false;
1162         }
1163         
1164         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1165             autoBurnLiquidityPairTokens();
1166         }
1167 
1168         bool takeFee = !swapping;
1169 
1170         // if any account belongs to _isExcludedFromFee account then remove the fee
1171         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1172             takeFee = false;
1173         }
1174         
1175         uint256 fees = 0;
1176         // only take fees on buys/sells, do not take on wallet transfers
1177         if(takeFee){
1178             // on sell
1179             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1180                 fees = amount.mul(sellTotalFees).div(100);
1181                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1182                 tokensForDev += fees * sellDevFee / sellTotalFees;
1183                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1184             }
1185             // on buy
1186             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1187         	    fees = amount.mul(buyTotalFees).div(100);
1188         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1189                 tokensForDev += fees * buyDevFee / buyTotalFees;
1190                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1191             }
1192             
1193             if(fees > 0){    
1194                 super._transfer(from, address(this), fees);
1195             }
1196         	
1197         	amount -= fees;
1198         }
1199 
1200         super._transfer(from, to, amount);
1201     }
1202 
1203     function swapTokensForEth(uint256 tokenAmount) private {
1204 
1205         // generate the uniswap pair path of token -> weth
1206         address[] memory path = new address[](2);
1207         path[0] = address(this);
1208         path[1] = uniswapV2Router.WETH();
1209 
1210         _approve(address(this), address(uniswapV2Router), tokenAmount);
1211 
1212         // make the swap
1213         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1214             tokenAmount,
1215             0, // accept any amount of ETH
1216             path,
1217             address(this),
1218             block.timestamp
1219         );
1220         
1221     }
1222     
1223     
1224     
1225     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1226         // approve token transfer to cover all possible scenarios
1227         _approve(address(this), address(uniswapV2Router), tokenAmount);
1228 
1229         // add the liquidity
1230         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1231             address(this),
1232             tokenAmount,
1233             0, // slippage is unavoidable
1234             0, // slippage is unavoidable
1235             deadAddress,
1236             block.timestamp
1237         );
1238     }
1239 
1240     function swapBack() private {
1241         uint256 contractBalance = balanceOf(address(this));
1242         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1243         bool success;
1244         
1245         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1246 
1247         if(contractBalance > swapTokensAtAmount * 20){
1248           contractBalance = swapTokensAtAmount * 20;
1249         }
1250         
1251         // Halve the amount of liquidity tokens
1252         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1253         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1254         
1255         uint256 initialETHBalance = address(this).balance;
1256 
1257         swapTokensForEth(amountToSwapForETH); 
1258         
1259         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1260         
1261         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1262         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1263         
1264         
1265         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1266         
1267         
1268         tokensForLiquidity = 0;
1269         tokensForMarketing = 0;
1270         tokensForDev = 0;
1271         
1272         (success,) = address(devWallet).call{value: ethForDev}("");
1273         
1274         if(liquidityTokens > 0 && ethForLiquidity > 0){
1275             addLiquidity(liquidityTokens, ethForLiquidity);
1276             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1277         }
1278         
1279         
1280         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1281     }
1282     
1283     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1284         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1285         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1286         lpBurnFrequency = _frequencyInSeconds;
1287         percentForLPBurn = _percent;
1288         lpBurnEnabled = _Enabled;
1289     }
1290     
1291     function autoBurnLiquidityPairTokens() internal returns (bool){
1292         
1293         lastLpBurnTime = block.timestamp;
1294         
1295         // get balance of liquidity pair
1296         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1297         
1298         // calculate amount to burn
1299         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1300         
1301         // pull tokens from pancakePair liquidity and move to dead address permanently
1302         if (amountToBurn > 0){
1303             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1304         }
1305         
1306         //sync price since this is not in a swap transaction!
1307         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1308         pair.sync();
1309         emit AutoNukeLP();
1310         return true;
1311     }
1312 
1313     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1314         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1315         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1316         lastManualLpBurnTime = block.timestamp;
1317         
1318         // get balance of liquidity pair
1319         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1320         
1321         // calculate amount to burn
1322         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1323         
1324         // pull tokens from pancakePair liquidity and move to dead address permanently
1325         if (amountToBurn > 0){
1326             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1327         }
1328         
1329         //sync price since this is not in a swap transaction!
1330         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1331         pair.sync();
1332         emit ManualNukeLP();
1333         return true;
1334     }
1335 }