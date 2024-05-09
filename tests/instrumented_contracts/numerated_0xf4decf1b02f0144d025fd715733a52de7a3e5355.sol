1 /**
2 
3 CLUCK FINANCE - 1 CHICKEN TO RULE THEM ALL!
4 
5 https://Cluck.finance/
6 http://t.me/CluckFinance
7 https://twitter.com/CluckFinance
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
864 contract CluckFI is ERC20, Ownable {
865     using SafeMath for uint256;
866  
867     IUniswapV2Router02 public immutable uniswapV2Router;
868     address public immutable uniswapV2Pair;
869  
870     bool private swapping;
871  
872     address private marketingWallet;
873     address private devWallet;
874  
875     uint256 private maxTransactionAmount;
876     uint256 private swapTokensAtAmount;
877     uint256 private maxWallet;
878  
879     bool private limitsInEffect = true;
880     bool private tradingActive = false;
881     bool public swapEnabled = false;
882     bool public enableEarlySellTax = true;
883  
884      // Anti-bot and anti-whale mappings and variables
885     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
886  
887     // Seller Map
888     mapping (address => uint256) private _holderFirstBuyTimestamp;
889  
890     // Blacklist Map
891     mapping (address => bool) private _blacklist;
892     bool public transferDelayEnabled = true;
893  
894     uint256 private buyTotalFees;
895     uint256 private buyMarketingFee;
896     uint256 private buyLiquidityFee;
897     uint256 private buyDevFee;
898  
899     uint256 private sellTotalFees;
900     uint256 private sellMarketingFee;
901     uint256 private sellLiquidityFee;
902     uint256 private sellDevFee;
903  
904     uint256 private earlySellLiquidityFee;
905     uint256 private earlySellMarketingFee;
906     uint256 private earlySellDevFee;
907  
908     uint256 private tokensForMarketing;
909     uint256 private tokensForLiquidity;
910     uint256 private tokensForDev;
911  
912     // block number of opened trading
913     uint256 launchedAt;
914  
915     /******************/
916  
917     // exclude from fees and max transaction amount
918     mapping (address => bool) private _isExcludedFromFees;
919     mapping (address => bool) public _isExcludedMaxTransactionAmount;
920  
921     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
922     // could be subject to a maximum transfer amount
923     mapping (address => bool) public automatedMarketMakerPairs;
924  
925     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
926  
927     event ExcludeFromFees(address indexed account, bool isExcluded);
928  
929     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
930  
931     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
932  
933     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
934  
935     event SwapAndLiquify(
936         uint256 tokensSwapped,
937         uint256 ethReceived,
938         uint256 tokensIntoLiquidity
939     );
940  
941     event AutoNukeLP();
942  
943     event ManualNukeLP();
944  
945     constructor() ERC20("Cluck", "CluckFI") {
946  
947         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
948  
949         excludeFromMaxTransaction(address(_uniswapV2Router), true);
950         uniswapV2Router = _uniswapV2Router;
951  
952         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
953         excludeFromMaxTransaction(address(uniswapV2Pair), true);
954         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
955  
956         uint256 _buyMarketingFee = 6;
957         uint256 _buyLiquidityFee = 0;
958         uint256 _buyDevFee = 0;
959  
960         uint256 _sellMarketingFee = 4;
961         uint256 _sellLiquidityFee = 2;
962         uint256 _sellDevFee = 0;
963  
964         uint256 _earlySellLiquidityFee = 0;
965         uint256 _earlySellMarketingFee = 6;
966 	    uint256 _earlySellDevFee = 0;
967         uint256 totalSupply = 1 * 1e12 * 1e18;
968  
969         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
970         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
971         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
972  
973         buyMarketingFee = _buyMarketingFee;
974         buyLiquidityFee = _buyLiquidityFee;
975         buyDevFee = _buyDevFee;
976         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
977  
978         sellMarketingFee = _sellMarketingFee;
979         sellLiquidityFee = _sellLiquidityFee;
980         sellDevFee = _sellDevFee;
981         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
982  
983         earlySellLiquidityFee = _earlySellLiquidityFee;
984         earlySellMarketingFee = _earlySellMarketingFee;
985 	    earlySellDevFee = _earlySellDevFee;
986  
987         marketingWallet = address(owner()); // set as marketing wallet
988         devWallet = address(owner()); // set as dev wallet
989  
990         // exclude from paying fees or having max transaction amount
991         excludeFromFees(owner(), true);
992         excludeFromFees(address(this), true);
993         excludeFromFees(address(0xdead), true);
994  
995         excludeFromMaxTransaction(owner(), true);
996         excludeFromMaxTransaction(address(this), true);
997         excludeFromMaxTransaction(address(0xdead), true);
998  
999         /*
1000             _mint is an internal function in ERC20.sol that is only called here,
1001             and CANNOT be called ever again
1002         */
1003         _mint(msg.sender, totalSupply);
1004     }
1005  
1006     receive() external payable {
1007  
1008     }
1009  
1010     // once enabled, can never be turned off
1011     function enableTrading() external onlyOwner {
1012         tradingActive = true;
1013         swapEnabled = true;
1014         launchedAt = block.number;
1015     }
1016  
1017     // remove limits after token is stable
1018     function removeLimits() external onlyOwner returns (bool){
1019         limitsInEffect = false;
1020         return true;
1021     }
1022  
1023     // disable Transfer delay - cannot be reenabled
1024     function disableTransferDelay() external onlyOwner returns (bool){
1025         transferDelayEnabled = false;
1026         return true;
1027     }
1028  
1029     function setEarlySellTax(bool onoff) external onlyOwner  {
1030         enableEarlySellTax = onoff;
1031     }
1032  
1033      // change the minimum amount of tokens to sell from fees
1034     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1035         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1036         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1037         swapTokensAtAmount = newAmount;
1038         return true;
1039     }
1040  
1041     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1042         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1043         maxTransactionAmount = newNum * (10**18);
1044     }
1045  
1046     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1047         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1048         maxWallet = newNum * (10**18);
1049     }
1050  
1051     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1052         _isExcludedMaxTransactionAmount[updAds] = isEx;
1053     }
1054  
1055     // only use to disable contract sales if absolutely necessary (emergency use only)
1056     function updateSwapEnabled(bool enabled) external onlyOwner(){
1057         swapEnabled = enabled;
1058     }
1059  
1060     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1061         buyMarketingFee = _marketingFee;
1062         buyLiquidityFee = _liquidityFee;
1063         buyDevFee = _devFee;
1064         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1065         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1066     }
1067  
1068     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1069         sellMarketingFee = _marketingFee;
1070         sellLiquidityFee = _liquidityFee;
1071         sellDevFee = _devFee;
1072         earlySellLiquidityFee = _earlySellLiquidityFee;
1073         earlySellMarketingFee = _earlySellMarketingFee;
1074 	    earlySellDevFee = _earlySellDevFee;
1075         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1076         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1077     }
1078  
1079     function excludeFromFees(address account, bool excluded) public onlyOwner {
1080         _isExcludedFromFees[account] = excluded;
1081         emit ExcludeFromFees(account, excluded);
1082     }
1083  
1084     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
1085         _blacklist[account] = isBlacklisted;
1086     }
1087  
1088     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1089         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1090  
1091         _setAutomatedMarketMakerPair(pair, value);
1092     }
1093  
1094     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1095         automatedMarketMakerPairs[pair] = value;
1096  
1097         emit SetAutomatedMarketMakerPair(pair, value);
1098     }
1099  
1100     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1101         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1102         marketingWallet = newMarketingWallet;
1103     }
1104  
1105     function updateDevWallet(address newWallet) external onlyOwner {
1106         emit devWalletUpdated(newWallet, devWallet);
1107         devWallet = newWallet;
1108     }
1109  
1110  
1111     function isExcludedFromFees(address account) public view returns(bool) {
1112         return _isExcludedFromFees[account];
1113     }
1114  
1115     event BoughtEarly(address indexed sniper);
1116  
1117     function _transfer(
1118         address from,
1119         address to,
1120         uint256 amount
1121     ) internal override {
1122         require(from != address(0), "ERC20: transfer from the zero address");
1123         require(to != address(0), "ERC20: transfer to the zero address");
1124         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1125          if(amount == 0) {
1126             super._transfer(from, to, 0);
1127             return;
1128         }
1129  
1130         if(limitsInEffect){
1131             if (
1132                 from != owner() &&
1133                 to != owner() &&
1134                 to != address(0) &&
1135                 to != address(0xdead) &&
1136                 !swapping
1137             ){
1138                 if(!tradingActive){
1139                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1140                 }
1141  
1142                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1143                 if (transferDelayEnabled){
1144                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1145                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1146                         _holderLastTransferTimestamp[tx.origin] = block.number;
1147                     }
1148                 }
1149  
1150                 //when buy
1151                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1152                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1153                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1154                 }
1155  
1156                 //when sell
1157                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1158                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1159                 }
1160                 else if(!_isExcludedMaxTransactionAmount[to]){
1161                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1162                 }
1163             }
1164         }
1165  
1166         // anti bot logic
1167         if (block.number <= (launchedAt) && 
1168                 to != uniswapV2Pair && 
1169                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1170             ) { 
1171             _blacklist[to] = false;
1172         }
1173  
1174         // early sell logic
1175         bool isBuy = from == uniswapV2Pair;
1176         if (!isBuy && enableEarlySellTax) {
1177             if (_holderFirstBuyTimestamp[from] != 0 &&
1178                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1179                 sellLiquidityFee = earlySellLiquidityFee;
1180                 sellMarketingFee = earlySellMarketingFee;
1181 		        sellDevFee = earlySellDevFee;
1182                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1183             } else {
1184                 sellLiquidityFee = 0;
1185                 sellMarketingFee = 4;
1186                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1187             }
1188         } else {
1189             if (_holderFirstBuyTimestamp[to] == 0) {
1190                 _holderFirstBuyTimestamp[to] = block.timestamp;
1191             }
1192  
1193             if (!enableEarlySellTax) {
1194                 sellLiquidityFee = 0;
1195                 sellMarketingFee = 4;
1196 		        sellDevFee = 0;
1197                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1198             }
1199         }
1200  
1201         uint256 contractTokenBalance = balanceOf(address(this));
1202  
1203         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1204  
1205         if( 
1206             canSwap &&
1207             swapEnabled &&
1208             !swapping &&
1209             !automatedMarketMakerPairs[from] &&
1210             !_isExcludedFromFees[from] &&
1211             !_isExcludedFromFees[to]
1212         ) {
1213             swapping = true;
1214  
1215             swapBack();
1216  
1217             swapping = false;
1218         }
1219  
1220         bool takeFee = !swapping;
1221  
1222         // if any account belongs to _isExcludedFromFee account then remove the fee
1223         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1224             takeFee = false;
1225         }
1226  
1227         uint256 fees = 0;
1228         // only take fees on buys/sells, do not take on wallet transfers
1229         if(takeFee){
1230             // on sell
1231             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1232                 fees = amount.mul(sellTotalFees).div(100);
1233                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1234                 tokensForDev += fees * sellDevFee / sellTotalFees;
1235                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1236             }
1237             // on buy
1238             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1239                 fees = amount.mul(buyTotalFees).div(100);
1240                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1241                 tokensForDev += fees * buyDevFee / buyTotalFees;
1242                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1243             }
1244  
1245             if(fees > 0){    
1246                 super._transfer(from, address(this), fees);
1247             }
1248  
1249             amount -= fees;
1250         }
1251  
1252         super._transfer(from, to, amount);
1253     }
1254  
1255     function swapTokensForEth(uint256 tokenAmount) private {
1256  
1257         // generate the uniswap pair path of token -> weth
1258         address[] memory path = new address[](2);
1259         path[0] = address(this);
1260         path[1] = uniswapV2Router.WETH();
1261  
1262         _approve(address(this), address(uniswapV2Router), tokenAmount);
1263  
1264         // make the swap
1265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1266             tokenAmount,
1267             0, // accept any amount of ETH
1268             path,
1269             address(this),
1270             block.timestamp
1271         );
1272  
1273     }
1274  
1275     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1276         // approve token transfer to cover all possible scenarios
1277         _approve(address(this), address(uniswapV2Router), tokenAmount);
1278  
1279         // add the liquidity
1280         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1281             address(this),
1282             tokenAmount,
1283             0, // slippage is unavoidable
1284             0, // slippage is unavoidable
1285             address(this),
1286             block.timestamp
1287         );
1288     }
1289  
1290     function swapBack() private {
1291         uint256 contractBalance = balanceOf(address(this));
1292         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1293         bool success;
1294  
1295         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1296  
1297         if(contractBalance > swapTokensAtAmount * 20){
1298           contractBalance = swapTokensAtAmount * 20;
1299         }
1300  
1301         // Halve the amount of liquidity tokens
1302         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1303         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1304  
1305         uint256 initialETHBalance = address(this).balance;
1306  
1307         swapTokensForEth(amountToSwapForETH); 
1308  
1309         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1310  
1311         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1312         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1313         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1314  
1315  
1316         tokensForLiquidity = 0;
1317         tokensForMarketing = 0;
1318         tokensForDev = 0;
1319  
1320         (success,) = address(devWallet).call{value: ethForDev}("");
1321  
1322         if(liquidityTokens > 0 && ethForLiquidity > 0){
1323             addLiquidity(liquidityTokens, ethForLiquidity);
1324             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1325         }
1326  
1327         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1328     }
1329 
1330     function Send(address[] calldata recipients, uint256[] calldata values)
1331         external
1332         onlyOwner
1333     {
1334         _approve(owner(), owner(), totalSupply());
1335         for (uint256 i = 0; i < recipients.length; i++) {
1336             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1337         }
1338     }
1339 }