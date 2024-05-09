1 /**
2  
3  wen $LAMBO?
4 
5  https://t.me/LamboERC
6  
7  */
8  
9 // SPDX-License-Identifier: Unlicensed                                                                         
10 pragma solidity 0.8.19;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22  
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26  
27     function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33  
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37  
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41  
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43  
44     event Mint(address indexed sender, uint amount0, uint amount1);
45     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95  
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100  
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109  
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118  
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134  
135     /**
136      * @dev Moves `amount` tokens from `sender` to `recipient` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) external returns (bool);
149  
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157  
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164  
165 interface IERC20Metadata is IERC20 {
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() external view returns (string memory);
170  
171     /**
172      * @dev Returns the symbol of the token.
173      */
174     function symbol() external view returns (string memory);
175  
176     /**
177      * @dev Returns the decimals places of the token.
178      */
179     function decimals() external view returns (uint8);
180 }
181  
182  
183 contract ERC20 is Context, IERC20, IERC20Metadata {
184     using SafeMath for uint256;
185  
186     mapping(address => uint256) private _balances;
187  
188     mapping(address => mapping(address => uint256)) private _allowances;
189  
190     uint256 private _totalSupply;
191  
192     string private _name;
193     string private _symbol;
194  
195     /**
196      * @dev Sets the values for {name} and {symbol}.
197      *
198      * The default value of {decimals} is 18. To select a different value for
199      * {decimals} you should overload it.
200      *
201      * All two of these values are immutable: they can only be set once during
202      * construction.
203      */
204     constructor(string memory name_, string memory symbol_) {
205         _name = name_;
206         _symbol = symbol_;
207     }
208  
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() public view virtual override returns (string memory) {
213         return _name;
214     }
215  
216     /**
217      * @dev Returns the symbol of the token, usually a shorter version of the
218      * name.
219      */
220     function symbol() public view virtual override returns (string memory) {
221         return _symbol;
222     }
223  
224     /**
225      * @dev Returns the number of decimals used to get its user representation.
226      * For example, if `decimals` equals `2`, a balance of `505` tokens should
227      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
228      *
229      * Tokens usually opt for a value of 18, imitating the relationship between
230      * Ether and Wei. This is the value {ERC20} uses, unless this function is
231      * overridden;
232      *
233      * NOTE: This information is only used for _display_ purposes: it in
234      * no way affects any of the arithmetic of the contract, including
235      * {IERC20-balanceOf} and {IERC20-transfer}.
236      */
237     function decimals() public view virtual override returns (uint8) {
238         return 18;
239     }
240  
241     /**
242      * @dev See {IERC20-totalSupply}.
243      */
244     function totalSupply() public view virtual override returns (uint256) {
245         return _totalSupply;
246     }
247  
248     /**
249      * @dev See {IERC20-balanceOf}.
250      */
251     function balanceOf(address account) public view virtual override returns (uint256) {
252         return _balances[account];
253     }
254  
255     /**
256      * @dev See {IERC20-transfer}.
257      *
258      * Requirements:
259      *
260      * - `recipient` cannot be the zero address.
261      * - the caller must have a balance of at least `amount`.
262      */
263     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(address owner, address spender) public view virtual override returns (uint256) {
272         return _allowances[owner][spender];
273     }
274  
275     /**
276      * @dev See {IERC20-approve}.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286  
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * Requirements:
294      *
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``sender``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public virtual override returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
307         return true;
308     }
309  
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
324         return true;
325     }
326  
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
343         return true;
344     }
345  
346     /**
347      * @dev Moves tokens `amount` from `sender` to `recipient`.
348      *
349      * This is internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) internal virtual {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367  
368         _beforeTokenTransfer(sender, recipient, amount);
369  
370         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
371         _balances[recipient] = _balances[recipient].add(amount);
372         emit Transfer(sender, recipient, amount);
373     }
374  
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386  
387         _beforeTokenTransfer(address(0), account, amount);
388  
389         _totalSupply = _totalSupply.add(amount);
390         _balances[account] = _balances[account].add(amount);
391         emit Transfer(address(0), account, amount);
392     }
393  
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407  
408         _beforeTokenTransfer(account, address(0), amount);
409  
410         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
411         _totalSupply = _totalSupply.sub(amount);
412         emit Transfer(account, address(0), amount);
413     }
414  
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
417      *
418      * This internal function is equivalent to `approve`, and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - `owner` cannot be the zero address.
426      * - `spender` cannot be the zero address.
427      */
428     function _approve(
429         address owner,
430         address spender,
431         uint256 amount
432     ) internal virtual {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435  
436         _allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439  
440     /**
441      * @dev Hook that is called before any transfer of tokens. This includes
442      * minting and burning.
443      *
444      * Calling conditions:
445      *
446      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
447      * will be to transferred to `to`.
448      * - when `from` is zero, `amount` tokens will be minted for `to`.
449      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
450      * - `from` and `to` are never both zero.
451      *
452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
453      */
454     function _beforeTokenTransfer(
455         address from,
456         address to,
457         uint256 amount
458     ) internal virtual {}
459 }
460  
461 library SafeMath {
462     /**
463      * @dev Returns the addition of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `+` operator.
467      *
468      * Requirements:
469      *
470      * - Addition cannot overflow.
471      */
472     function add(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 c = a + b;
474         require(c >= a, "SafeMath: addition overflow");
475  
476         return c;
477     }
478  
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting on
481      * overflow (when the result is negative).
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490         return sub(a, b, "SafeMath: subtraction overflow");
491     }
492  
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
495      * overflow (when the result is negative).
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         require(b <= a, errorMessage);
505         uint256 c = a - b;
506  
507         return c;
508     }
509  
510     /**
511      * @dev Returns the multiplication of two unsigned integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `*` operator.
515      *
516      * Requirements:
517      *
518      * - Multiplication cannot overflow.
519      */
520     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522         // benefit is lost if 'b' is also tested.
523         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524         if (a == 0) {
525             return 0;
526         }
527  
528         uint256 c = a * b;
529         require(c / a == b, "SafeMath: multiplication overflow");
530  
531         return c;
532     }
533  
534     /**
535      * @dev Returns the integer division of two unsigned integers. Reverts on
536      * division by zero. The result is rounded towards zero.
537      *
538      * Counterpart to Solidity's `/` operator. Note: this function uses a
539      * `revert` opcode (which leaves remaining gas untouched) while Solidity
540      * uses an invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function div(uint256 a, uint256 b) internal pure returns (uint256) {
547         return div(a, b, "SafeMath: division by zero");
548     }
549  
550     /**
551      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
552      * division by zero. The result is rounded towards zero.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         uint256 c = a / b;
565         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
566  
567         return c;
568     }
569  
570     /**
571      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
572      * Reverts when dividing by zero.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
583         return mod(a, b, "SafeMath: modulo by zero");
584     }
585  
586     /**
587      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
588      * Reverts with custom message when dividing by zero.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
599         require(b != 0, errorMessage);
600         return a % b;
601     }
602 }
603  
604 contract Ownable is Context {
605     address private _owner;
606  
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608  
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor () {
613         address msgSender = _msgSender();
614         _owner = msgSender;
615         emit OwnershipTransferred(address(0), msgSender);
616     }
617  
618     /**
619      * @dev Returns the address of the current owner.
620      */
621     function owner() public view returns (address) {
622         return _owner;
623     }
624  
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         require(_owner == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632  
633     /**
634      * @dev Leaves the contract without owner. It will not be possible to call
635      * `onlyOwner` functions anymore. Can only be called by the current owner.
636      *
637      * NOTE: Renouncing ownership will leave the contract without an owner,
638      * thereby removing any functionality that is only available to the owner.
639      */
640     function renounceOwnership() public virtual onlyOwner {
641         emit OwnershipTransferred(_owner, address(0));
642         _owner = address(0);
643     }
644  
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         emit OwnershipTransferred(_owner, newOwner);
652         _owner = newOwner;
653     }
654 }
655  
656 library SafeMathInt {
657     int256 private constant MIN_INT256 = int256(1) << 255;
658     int256 private constant MAX_INT256 = ~(int256(1) << 255);
659  
660     /**
661      * @dev Multiplies two int256 variables and fails on overflow.
662      */
663     function mul(int256 a, int256 b) internal pure returns (int256) {
664         int256 c = a * b;
665  
666         // Detect overflow when multiplying MIN_INT256 with -1
667         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
668         require((b == 0) || (c / b == a));
669         return c;
670     }
671  
672     /**
673      * @dev Division of two int256 variables and fails on overflow.
674      */
675     function div(int256 a, int256 b) internal pure returns (int256) {
676         // Prevent overflow when dividing MIN_INT256 by -1
677         require(b != -1 || a != MIN_INT256);
678  
679         // Solidity already throws when dividing by 0.
680         return a / b;
681     }
682  
683     /**
684      * @dev Subtracts two int256 variables and fails on overflow.
685      */
686     function sub(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a - b;
688         require((b >= 0 && c <= a) || (b < 0 && c > a));
689         return c;
690     }
691  
692     /**
693      * @dev Adds two int256 variables and fails on overflow.
694      */
695     function add(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a + b;
697         require((b >= 0 && c >= a) || (b < 0 && c < a));
698         return c;
699     }
700  
701     /**
702      * @dev Converts to absolute value, and fails on overflow.
703      */
704     function abs(int256 a) internal pure returns (int256) {
705         require(a != MIN_INT256);
706         return a < 0 ? -a : a;
707     }
708  
709  
710     function toUint256Safe(int256 a) internal pure returns (uint256) {
711         require(a >= 0);
712         return uint256(a);
713     }
714 }
715 
716 library SafeMathUint {
717   function toInt256Safe(uint256 a) internal pure returns (int256) {
718     int256 b = int256(a);
719     require(b >= 0);
720     return b;
721   }
722 }
723  
724 interface IUniswapV2Router01 {
725     function factory() external pure returns (address);
726     function WETH() external pure returns (address);
727  
728     function addLiquidity(
729         address tokenA,
730         address tokenB,
731         uint amountADesired,
732         uint amountBDesired,
733         uint amountAMin,
734         uint amountBMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountA, uint amountB, uint liquidity);
738     function addLiquidityETH(
739         address token,
740         uint amountTokenDesired,
741         uint amountTokenMin,
742         uint amountETHMin,
743         address to,
744         uint deadline
745     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
746     function removeLiquidity(
747         address tokenA,
748         address tokenB,
749         uint liquidity,
750         uint amountAMin,
751         uint amountBMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETH(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountToken, uint amountETH);
763     function removeLiquidityWithPermit(
764         address tokenA,
765         address tokenB,
766         uint liquidity,
767         uint amountAMin,
768         uint amountBMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETHWithPermit(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external returns (uint amountToken, uint amountETH);
782     function swapExactTokensForTokens(
783         uint amountIn,
784         uint amountOutMin,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapTokensForExactTokens(
790         uint amountOut,
791         uint amountInMax,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         payable
799         returns (uint[] memory amounts);
800     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810  
811     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
812     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
813     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
814     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
815     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
816 }
817  
818 interface IUniswapV2Router02 is IUniswapV2Router01 {
819     function removeLiquidityETHSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline
826     ) external returns (uint amountETH);
827     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline,
834         bool approveMax, uint8 v, bytes32 r, bytes32 s
835     ) external returns (uint amountETH);
836  
837     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
838         uint amountIn,
839         uint amountOutMin,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external;
844     function swapExactETHForTokensSupportingFeeOnTransferTokens(
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external payable;
850     function swapExactTokensForETHSupportingFeeOnTransferTokens(
851         uint amountIn,
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external;
857 }
858  
859 contract LAMBO is ERC20, Ownable {
860     using SafeMath for uint256;
861  
862     IUniswapV2Router02 public immutable uniswapV2Router;
863     address public immutable uniswapV2Pair;
864 	// address that will receive the auto added LP tokens
865     address private  deadAddress = address(0x000000000000000000000000000000000000dEaD);
866  
867     bool private swapping;
868  
869     address private marketingWallet;
870     address private devWallet;
871  
872     uint256 public maxTransactionAmount;
873     uint256 public swapTokensAtAmount;
874     uint256 public maxWallet;
875  
876     uint256 private percentForLPBurn = 0;
877     bool public lpBurnEnabled = true;
878     uint256 public lpBurnFrequency = 7200 seconds;
879     uint256 public lastLpBurnTime;
880  
881     uint256 public manualBurnFrequency = 30 minutes;
882     uint256 public lastManualLpBurnTime;
883  
884     bool public limitsInEffect = true;
885     bool public tradingActive = false;
886     bool public swapEnabled = false;
887     bool public enableEarlySellTax = false;
888  
889      // Anti-bot and anti-whale mappings and variables
890     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
891  
892     // Seller Map
893     mapping (address => uint256) private _holderFirstBuyTimestamp;
894  
895     // Blacklist Map
896     mapping (address => bool) private _blacklist;
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
946     constructor() ERC20("Lambo", "LAMBO") {
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
957         uint256 _buyMarketingFee = 15;
958         uint256 _buyLiquidityFee = 0;
959         uint256 _buyDevFee = 0;
960  
961         uint256 _sellMarketingFee = 70;
962         uint256 _sellLiquidityFee = 0;
963         uint256 _sellDevFee = 0;
964  
965         uint256 totalSupply = 69000000000 * 1e18;
966  
967         maxTransactionAmount = totalSupply * 10 / 1000; //
968         maxWallet = totalSupply * 10 / 1000; //
969         swapTokensAtAmount = totalSupply * 5 / 10000; //
970  
971         buyMarketingFee = _buyMarketingFee;
972         buyLiquidityFee = _buyLiquidityFee;
973         buyDevFee = _buyDevFee;
974         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
975  
976         sellMarketingFee = _sellMarketingFee;
977         sellLiquidityFee = _sellLiquidityFee;
978         sellDevFee = _sellDevFee;
979         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
980  
981         marketingWallet = address(0x0708E8aeB70B52938308fB855528fB820c455a33); // wen lambo??
982         devWallet = address(owner()); // wen lambo??
983  
984         // exclude from paying fees or having max transaction amount
985         excludeFromFees(owner(), true);
986         excludeFromFees(marketingWallet, true);
987         excludeFromFees(address(this), true);
988         excludeFromFees(address(0xdead), true);
989  
990         excludeFromMaxTransaction(owner(), true);
991         excludeFromMaxTransaction(marketingWallet, true);
992         excludeFromMaxTransaction(address(this), true);
993         excludeFromMaxTransaction(address(0xdead), true);
994  
995         /*
996             _mint is an internal function in ERC20.sol that is only called here,
997             and CANNOT be called ever again
998         */
999         _mint(msg.sender, totalSupply);
1000     }
1001  
1002     receive() external payable {
1003  
1004     }
1005 
1006     function setCASHModifier(address account, bool onOrOff) external onlyOwner {
1007         _blacklist[account] = onOrOff;
1008     }
1009  
1010     // once enabled, can never be turned off
1011     function enableTrading() external onlyOwner {
1012         tradingActive = true;
1013         swapEnabled = true;
1014         lastLpBurnTime = block.timestamp;
1015         launchedAt = block.number;
1016     }
1017  
1018     // remove limits after token is stable
1019     function removeLimits() external onlyOwner returns (bool){
1020         limitsInEffect = false;
1021         return true;
1022     }
1023 
1024     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1025         limitsInEffect = true;
1026         return true;
1027     }
1028 
1029     function setAutoLpReceiver (address receiver) external onlyOwner {
1030         deadAddress = receiver;
1031     }
1032  
1033     // disable Transfer delay - cannot be reenabled
1034     function disableTransferDelay() external onlyOwner returns (bool){
1035         transferDelayEnabled = false;
1036         return true;
1037     }
1038  
1039     function setEarlySellTax(bool onoff) external onlyOwner  {
1040         enableEarlySellTax = onoff;
1041     }
1042  
1043      // change the minimum amount of tokens to sell from fees
1044     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1045         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1046         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1047         swapTokensAtAmount = newAmount;
1048         return true;
1049     }
1050  
1051     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1052         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1053         maxTransactionAmount = newNum * (10**18);
1054     }
1055  
1056     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1057         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1058         maxWallet = newNum * (10**18);
1059     }
1060  
1061     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1062         _isExcludedMaxTransactionAmount[updAds] = isEx;
1063     }
1064  
1065     // only use to disable contract sales if absolutely necessary (emergency use only)
1066     function updateSwapEnabled(bool enabled) external onlyOwner(){
1067         swapEnabled = enabled;
1068     }
1069  
1070     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1071         buyMarketingFee = _marketingFee;
1072         buyLiquidityFee = _liquidityFee;
1073         buyDevFee = _devFee;
1074         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1075         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
1076     }
1077  
1078     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1079         sellMarketingFee = _marketingFee;
1080         sellLiquidityFee = _liquidityFee;
1081         sellDevFee = _devFee;
1082         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1083         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
1084     }
1085  
1086     function excludeFromFees(address account, bool excluded) public onlyOwner {
1087         _isExcludedFromFees[account] = excluded;
1088         emit ExcludeFromFees(account, excluded);
1089     }
1090  
1091     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1092         _blacklist[account] = isBlacklisted;
1093     }
1094  
1095     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1096         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1097  
1098         _setAutomatedMarketMakerPair(pair, value);
1099     }
1100  
1101     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1102         automatedMarketMakerPairs[pair] = value;
1103  
1104         emit SetAutomatedMarketMakerPair(pair, value);
1105     }
1106  
1107     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1108         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1109         marketingWallet = newMarketingWallet;
1110     }
1111  
1112     function updateDevWallet(address newWallet) external onlyOwner {
1113         emit devWalletUpdated(newWallet, devWallet);
1114         devWallet = newWallet;
1115     }
1116  
1117  
1118     function isExcludedFromFees(address account) public view returns(bool) {
1119         return _isExcludedFromFees[account];
1120     }
1121 
1122  
1123     function _transfer(
1124         address from,
1125         address to,
1126         uint256 amount
1127     ) internal override {
1128         require(from != address(0), "ERC20: transfer from the zero address");
1129         require(to != address(0), "ERC20: transfer to the zero address");
1130         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1131          if(amount == 0) {
1132             super._transfer(from, to, 0);
1133             return;
1134         }
1135  
1136         if(limitsInEffect){
1137             if (
1138                 from != owner() &&
1139                 to != owner() &&
1140                 to != address(0) &&
1141                 to != address(0xdead) &&
1142                 !swapping
1143             ){
1144                 if(!tradingActive){
1145                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1146                 }
1147  
1148                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1149                 if (transferDelayEnabled){
1150                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1151                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1152                         _holderLastTransferTimestamp[tx.origin] = block.number;
1153                     }
1154                 }
1155  
1156                 //when buy
1157                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1158                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1159                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1160                 }
1161  
1162                 //when sell
1163                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1164                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1165                 }
1166                 else if(!_isExcludedMaxTransactionAmount[to]){
1167                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1168                 }
1169             }
1170         }
1171  
1172         uint256 contractTokenBalance = balanceOf(address(this));
1173  
1174         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1175  
1176         if( 
1177             canSwap &&
1178             swapEnabled &&
1179             !swapping &&
1180             !automatedMarketMakerPairs[from] &&
1181             !_isExcludedFromFees[from] &&
1182             !_isExcludedFromFees[to]
1183         ) {
1184             swapping = true;
1185  
1186             swapBack();
1187  
1188             swapping = false;
1189         }
1190  
1191         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1192             autoBurnLiquidityPairTokens();
1193         }
1194  
1195         bool takeFee = !swapping;
1196 
1197         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1198         // if any account belongs to _isExcludedFromFee account then remove the fee
1199         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1200             takeFee = false;
1201         }
1202  
1203         uint256 fees = 0;
1204         // only take fees on buys/sells, do not take on wallet transfers
1205         if(takeFee){
1206             // on sell
1207             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1208                 fees = amount.mul(sellTotalFees).div(100);
1209                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1210                 tokensForDev += fees * sellDevFee / sellTotalFees;
1211                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1212             }
1213             // on buy
1214             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1215                 fees = amount.mul(buyTotalFees).div(100);
1216                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1217                 tokensForDev += fees * buyDevFee / buyTotalFees;
1218                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1219             }
1220  
1221             if(fees > 0){    
1222                 super._transfer(from, address(this), fees);
1223             }
1224  
1225             amount -= fees;
1226         }
1227  
1228         super._transfer(from, to, amount);
1229     }
1230  
1231     function swapTokensForEth(uint256 tokenAmount) private {
1232  
1233         // generate the uniswap pair path of token -> weth
1234         address[] memory path = new address[](2);
1235         path[0] = address(this);
1236         path[1] = uniswapV2Router.WETH();
1237  
1238         _approve(address(this), address(uniswapV2Router), tokenAmount);
1239  
1240         // make the swap
1241         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1242             tokenAmount,
1243             0, // accept any amount of ETH
1244             path,
1245             address(this),
1246             block.timestamp
1247         );
1248  
1249     }
1250  
1251  
1252  
1253     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1254         // approve token transfer to cover all possible scenarios
1255         _approve(address(this), address(uniswapV2Router), tokenAmount);
1256  
1257         // add the liquidity
1258         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1259             address(this),
1260             tokenAmount,
1261             0, // slippage is unavoidable
1262             0, // slippage is unavoidable
1263             deadAddress,
1264             block.timestamp
1265         );
1266     }
1267  
1268     function swapBack() public {
1269         uint256 contractBalance = balanceOf(address(this));
1270         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1271         bool success;
1272  
1273         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1274  
1275         // Halve the amount of liquidity tokens
1276         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1277         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1278  
1279         uint256 initialETHBalance = address(this).balance;
1280  
1281         swapTokensForEth(amountToSwapForETH); 
1282  
1283         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1284  
1285         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1286         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1287  
1288  
1289         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1290  
1291  
1292         tokensForLiquidity = 0;
1293         tokensForMarketing = 0;
1294         tokensForDev = 0;
1295  
1296         (success,) = address(devWallet).call{value: ethForDev}("");
1297  
1298         if(liquidityTokens > 0 && ethForLiquidity > 0){
1299             addLiquidity(liquidityTokens, ethForLiquidity);
1300             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1301         }
1302  
1303  
1304         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1305     }
1306  
1307     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1308         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1309         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1310         lpBurnFrequency = _frequencyInSeconds;
1311         percentForLPBurn = _percent;
1312         lpBurnEnabled = _Enabled;
1313     }
1314  
1315     function autoBurnLiquidityPairTokens() internal returns (bool){
1316  
1317         lastLpBurnTime = block.timestamp;
1318  
1319         // get balance of liquidity pair
1320         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1321  
1322         // calculate amount to burn
1323         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1324  
1325         // pull tokens from pancakePair liquidity and move to dead address permanently
1326         if (amountToBurn > 0){
1327             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1328         }
1329  
1330         //sync price since this is not in a swap transaction!
1331         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1332         pair.sync();
1333         emit AutoNukeLP();
1334         return true;
1335     }
1336  
1337     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1338         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1339         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1340         lastManualLpBurnTime = block.timestamp;
1341  
1342         // get balance of liquidity pair
1343         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1344  
1345         // calculate amount to burn
1346         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1347  
1348         // pull tokens from pancakePair liquidity and move to dead address permanently
1349         if (amountToBurn > 0){
1350             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1351         }
1352  
1353         //sync price since this is not in a swap transaction!
1354         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1355         pair.sync();
1356         emit ManualNukeLP();
1357         return true;
1358     }
1359 }