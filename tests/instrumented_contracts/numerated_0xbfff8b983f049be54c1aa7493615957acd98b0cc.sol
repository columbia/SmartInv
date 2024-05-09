1 // SPDX-License-Identifier: MIT                                                                               
2 
3 /*
4 
5  TG: t.me/bagsaisho
6 
7  Twitter: twitter.com/bagsaisho
8 
9  Website: bagsaisho.com
10 
11 */
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
240         return 6;
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
864 pragma solidity 0.8.9;
865 
866 contract Token is ERC20, Ownable {
867     using SafeMath for uint256;
868 
869     IUniswapV2Router02 public immutable uniswapV2Router;
870     address public immutable uniswapV2Pair;
871     address public constant deadAddress = address(0xdead);
872 
873     bool private swapping;
874         
875     uint256 public maxTransactionAmount;
876     uint256 public swapTokensAtAmount;
877     uint256 public maxWallet;
878     
879     uint256 public supply;
880 
881     address public devWallet;
882     
883     bool public limitsInEffect = true;
884     bool public tradingActive = true;
885     bool public swapEnabled = true;
886 
887     mapping(address => uint256) private _holderLastTransferTimestamp;
888 
889     bool public transferDelayEnabled = true;
890 
891     uint256 public buyBurnFee;
892     uint256 public buyDevFee;
893     uint256 public buyTotalFees;
894 
895     uint256 public sellBurnFee;
896     uint256 public sellDevFee;
897     uint256 public sellTotalFees;   
898     
899     uint256 public tokensForBurn;
900     uint256 public tokensForDev;
901 
902     uint256 public walletDigit;
903     uint256 public transDigit;
904     uint256 public delayDigit;
905     
906     /******************/
907 
908     // exlcude from fees and max transaction amount
909     mapping (address => bool) private _isExcludedFromFees;
910     mapping (address => bool) public _isExcludedMaxTransactionAmount;
911 
912     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
913     // could be subject to a maximum transfer amount
914     mapping (address => bool) public automatedMarketMakerPairs;
915 
916     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
917 
918     event ExcludeFromFees(address indexed account, bool isExcluded);
919 
920     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
921 
922     constructor() ERC20("Bagheera Saisho", "BAGS") {
923         
924         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
925         
926         excludeFromMaxTransaction(address(_uniswapV2Router), true);
927         uniswapV2Router = _uniswapV2Router;
928         
929         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
930         excludeFromMaxTransaction(address(uniswapV2Pair), true);
931         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
932         
933         uint256 _buyBurnFee = 0;
934         uint256 _buyDevFee = 5;
935 
936         uint256 _sellBurnFee = 6;
937         uint256 _sellDevFee = 19;
938         
939         uint256 totalSupply = 1 * 1e8 * 1e6;
940         supply += totalSupply;
941         
942         walletDigit = 1;
943         transDigit = 1;
944         delayDigit = 0;
945 
946         maxTransactionAmount = supply * transDigit / 100;
947         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
948         maxWallet = supply * walletDigit / 100;
949 
950         buyBurnFee = _buyBurnFee;
951         buyDevFee = _buyDevFee;
952         buyTotalFees = buyBurnFee + buyDevFee;
953         
954         sellBurnFee = _sellBurnFee;
955         sellDevFee = _sellDevFee;
956         sellTotalFees = sellBurnFee + sellDevFee;
957         
958         devWallet = 0xbEb1Eb7F7a4c0Efa867916aD0B804B6a1F67B5e9;
959 
960         excludeFromFees(owner(), true);
961         excludeFromFees(address(this), true);
962         excludeFromFees(address(0xdead), true);
963         
964         excludeFromMaxTransaction(owner(), true);
965         excludeFromMaxTransaction(address(this), true);
966         excludeFromMaxTransaction(address(0xdead), true);
967 
968         _approve(owner(), address(uniswapV2Router), totalSupply);
969         _mint(msg.sender, totalSupply);
970 
971     }
972 
973     receive() external payable {
974 
975   	}
976 
977     function enableTrading() external onlyOwner {
978         buyBurnFee = 6;
979         buyDevFee = 0;
980         buyTotalFees = buyBurnFee + buyDevFee;
981 
982         sellBurnFee = 6;
983         sellDevFee = 2;
984         sellTotalFees = sellBurnFee + sellDevFee;
985 
986         delayDigit = 5;
987     }
988     
989     function updateTransDigit(uint256 newNum) external onlyOwner {
990         require(newNum >= 1);
991         transDigit = newNum;
992         updateLimits();
993     }
994 
995     function updateWalletDigit(uint256 newNum) external onlyOwner {
996         require(newNum >= 1);
997         walletDigit = newNum;
998         updateLimits();
999     }
1000 
1001     function updateDelayDigit(uint256 newNum) external onlyOwner{
1002         delayDigit = newNum;
1003     }
1004     
1005     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1006         _isExcludedMaxTransactionAmount[updAds] = isEx;
1007     }
1008     
1009     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1010         buyBurnFee = _burnFee;
1011         buyDevFee = _devFee;
1012         buyTotalFees = buyBurnFee + buyDevFee;
1013         require(buyTotalFees <= 15, "Must keep fees at 20% or less");
1014     }
1015     
1016     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1017         sellBurnFee = _burnFee;
1018         sellDevFee = _devFee;
1019         sellTotalFees = sellBurnFee + sellDevFee;
1020         require(sellTotalFees <= 15, "Must keep fees at 25% or less");
1021     }
1022 
1023     function updateDevWallet(address newWallet) external onlyOwner {
1024         devWallet = newWallet;
1025     }
1026 
1027     function excludeFromFees(address account, bool excluded) public onlyOwner {
1028         _isExcludedFromFees[account] = excluded;
1029         emit ExcludeFromFees(account, excluded);
1030     }
1031 
1032     function updateLimits() private {
1033         maxTransactionAmount = supply * transDigit / 100;
1034         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1035         maxWallet = supply * walletDigit / 100;
1036     }
1037 
1038     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1039         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1040 
1041         _setAutomatedMarketMakerPair(pair, value);
1042     }
1043 
1044     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1045         automatedMarketMakerPairs[pair] = value;
1046 
1047         emit SetAutomatedMarketMakerPair(pair, value);
1048     }
1049 
1050     function isExcludedFromFees(address account) public view returns(bool) {
1051         return _isExcludedFromFees[account];
1052     }
1053     
1054     function _transfer(
1055         address from,
1056         address to,
1057         uint256 amount
1058     ) internal override {
1059         require(from != address(0), "ERC20: transfer from the zero address");
1060         require(to != address(0), "ERC20: transfer to the zero address");
1061         
1062          if(amount == 0) {
1063             super._transfer(from, to, 0);
1064             return;
1065         }
1066         
1067         if(limitsInEffect){
1068             if (
1069                 from != owner() &&
1070                 to != owner() &&
1071                 to != address(0) &&
1072                 to != address(0xdead) &&
1073                 !swapping
1074             ){
1075                 if(!tradingActive){
1076                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1077                 }
1078 
1079                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1080                 if (transferDelayEnabled){
1081                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1082                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1083                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1084                     }
1085                 }
1086                  
1087                 //when buy
1088                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1089                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1090                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1091                 }
1092                 
1093                 //when sell
1094                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1095                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1096                 }
1097                 else if(!_isExcludedMaxTransactionAmount[to]){
1098                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1099                 }
1100             }
1101         }
1102         uint256 contractTokenBalance = balanceOf(address(this));
1103         
1104         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1105 
1106         if( 
1107             canSwap &&
1108             !swapping &&
1109             swapEnabled &&
1110             !automatedMarketMakerPairs[from] &&
1111             !_isExcludedFromFees[from] &&
1112             !_isExcludedFromFees[to]
1113         ) {
1114             swapping = true;
1115             
1116             swapBack();
1117 
1118             swapping = false;
1119         }
1120         
1121         bool takeFee = !swapping;
1122 
1123         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1124             takeFee = false;
1125         }
1126         
1127         uint256 fees = 0;
1128 
1129         if(takeFee){
1130             // on sell
1131             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1132                 fees = amount.mul(sellTotalFees).div(100);
1133                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1134                 tokensForDev += fees * sellDevFee / sellTotalFees;
1135             }
1136 
1137             // on buy
1138             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1139 
1140         	    fees = amount.mul(buyTotalFees).div(100);
1141         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1142                 tokensForDev += fees * buyDevFee / buyTotalFees;
1143             }
1144             
1145             if(fees > 0){    
1146                 super._transfer(from, address(this), fees);
1147                 if (tokensForBurn > 0) {
1148                     _burn(address(this), tokensForBurn);
1149                     supply = totalSupply();
1150                     updateLimits();
1151                     tokensForBurn = 0;
1152                 }
1153             }
1154         	
1155         	amount -= fees;
1156         }
1157 
1158         super._transfer(from, to, amount);
1159     }
1160 
1161     function swapTokensForEth(uint256 tokenAmount) private {
1162 
1163         // generate the uniswap pair path of token -> weth
1164         address[] memory path = new address[](2);
1165         path[0] = address(this);
1166         path[1] = uniswapV2Router.WETH();
1167 
1168         _approve(address(this), address(uniswapV2Router), tokenAmount);
1169 
1170         // make the swap
1171         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1172             tokenAmount,
1173             0, // accept any amount of ETH
1174             path,
1175             address(this),
1176             block.timestamp
1177         );
1178         
1179     }
1180     
1181     function swapBack() private {
1182         uint256 contractBalance = balanceOf(address(this));
1183         bool success;
1184         
1185         if(contractBalance == 0) {return;}
1186 
1187         if(contractBalance > swapTokensAtAmount * 20){
1188           contractBalance = swapTokensAtAmount * 20;
1189         }
1190 
1191         swapTokensForEth(contractBalance); 
1192         
1193         tokensForDev = 0;
1194 
1195         (success,) = address(devWallet).call{value: address(this).balance}("");
1196     }
1197 
1198 }