1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-04
7 */
8 
9 // SPDX-License-Identifier: Unlicensed                                                                         
10 pragma solidity 0.8.9;
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
862 contract OAK is ERC20, Ownable {
863     using SafeMath for uint256;
864  
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867 	// address that will receive the auto added LP tokens
868     address public  deadAddress = address(0xeC43B9AE01F13cA1c43C4FaDC8C8c8C23512385A);
869     address public burnAddress = address(0xdead);
870     bool private swapping;
871  
872     address public marketingWallet;
873     address public devWallet;
874  
875     uint256 public maxTransactionAmount;
876     uint256 public swapTokensAtAmount;
877     uint256 public maxWallet;
878  
879     uint256 public percentForLPBurn = 25; // 25 = .25%
880     bool public lpBurnEnabled = true;
881     uint256 public lpBurnFrequency = 7200 seconds;
882     uint256 public lastLpBurnTime;
883  
884     uint256 public manualBurnFrequency = 30 minutes;
885     uint256 public lastManualLpBurnTime;
886  
887     bool public limitsInEffect = true;
888     bool public tradingActive = false;
889     bool public swapEnabled = false;
890     bool public enableEarlySellTax = true;
891  
892      // Anti-bot and anti-whale mappings and variables
893     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
894  
895     // Seller Map
896     mapping (address => uint256) private _holderFirstBuyTimestamp;
897  
898     // Blacklist Map
899     mapping (address => bool) private _blacklist;
900     bool public transferDelayEnabled = true;
901  
902     uint256 public buyTotalFees;
903     uint256 public buyMarketingFee;
904     uint256 public buyLiquidityFee;
905     uint256 public buyDevFee;
906  
907     uint256 public sellTotalFees;
908     uint256 public sellMarketingFee;
909     uint256 public sellLiquidityFee;
910     uint256 public sellDevFee;
911  
912     uint256 public earlySellLiquidityFee;
913     uint256 public earlySellMarketingFee;
914  
915     uint256 public tokensForMarketing;
916     uint256 public tokensForLiquidity;
917     uint256 public tokensForDev;
918  
919     // block number of opened trading
920     uint256 launchedAt;
921  
922     /******************/
923  
924     // exclude from fees and max transaction amount
925     mapping (address => bool) private _isExcludedFromFees;
926     mapping (address => bool) public _isExcludedMaxTransactionAmount;
927  
928     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
929     // could be subject to a maximum transfer amount
930     mapping (address => bool) public automatedMarketMakerPairs;
931  
932     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
933     event ExcludeFromFees(address indexed account, bool isExcluded);
934     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
935     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
936     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
937     event MaxWalletUpdated (uint256 oldMaxWallet, uint256 newMaxWallet);
938     event MaxTransactionupdated(uint256 oldMaxTransaction, uint256 newMaxTransaction);
939 
940     event SwapAndLiquify(
941         uint256 tokensSwapped,
942         uint256 ethReceived,
943         uint256 tokensIntoLiquidity
944     );
945 
946     event BuyTaxesUpdated (uint256 newDevBuyTax, uint256 newMarketingBuyTax, uint256 newLPBuyTax);
947     event SellTaxesUpdated (uint256 newDevSellTax, uint256 newMarketingSellTax, uint256 newLPSellTax, uint256 earlySellMarketingFee, uint256 earlySellLiquidityFee);
948     event AutoNukeLP();
949     event ManualNukeLP();
950     event TradingEnabled(uint256 timestamp, uint256 blockNumber);
951     event LimitsRemoved(uint256 timestamp, uint256 blockNumber);
952     event SetSwapEnabled(uint256 timestamp, uint256 blockNumber, bool swapEnabled);
953     event LiquidityAdded(uint256 timestamp, uint256 blockNumber, uint256 amount);
954     event AutomaticBurn(uint256 timestamp, uint256 blockNumber, uint256 amountOfTokensBurnt);
955 
956  
957     constructor() ERC20("OAKISLAND", "OAK") {
958  
959         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
960  
961         excludeFromMaxTransaction(address(_uniswapV2Router), true);
962         uniswapV2Router = _uniswapV2Router;
963  
964         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
965         excludeFromMaxTransaction(address(uniswapV2Pair), true);
966         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
967  
968         uint256 _buyMarketingFee = 3;
969         uint256 _buyLiquidityFee = 1;
970         uint256 _buyDevFee = 0;
971  
972         uint256 _sellMarketingFee = 3;
973         uint256 _sellLiquidityFee = 1;
974         uint256 _sellDevFee = 0;
975  
976         uint256 _earlySellLiquidityFee = 5;
977         uint256 _earlySellMarketingFee = 10;
978  
979         uint256 totalSupply = 1 * 1e12 * 1e12;
980  
981         maxTransactionAmount = totalSupply * 8 / 1000; // 0.8% maxTransactionAmountTxn
982         maxWallet = totalSupply.div(100); // 1% max wallet.
983         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
984  
985         buyMarketingFee = _buyMarketingFee;
986         buyLiquidityFee = _buyLiquidityFee;
987         buyDevFee = _buyDevFee;
988         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
989  
990         sellMarketingFee = _sellMarketingFee;
991         sellLiquidityFee = _sellLiquidityFee;
992         sellDevFee = _sellDevFee;
993         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
994  
995         earlySellLiquidityFee = _earlySellLiquidityFee;
996         earlySellMarketingFee = _earlySellMarketingFee;
997  
998         marketingWallet = address(owner()); // set as marketing wallet
999         devWallet = address(owner()); // set as dev wallet
1000  
1001         // exclude from paying fees or having max transaction amount
1002         excludeFromFees(owner(), true);
1003         excludeFromFees(address(this), true);
1004         excludeFromFees(address(0xdead), true);
1005  
1006         excludeFromMaxTransaction(owner(), true);
1007         excludeFromMaxTransaction(address(this), true);
1008         excludeFromMaxTransaction(address(0xdead), true);
1009  
1010         /*
1011             _mint is an internal function in ERC20.sol that is only called here,
1012             and CANNOT be called ever again
1013         */
1014         _mint(msg.sender, totalSupply);
1015     }
1016  
1017     receive() external payable {
1018  
1019     }
1020 
1021     function setBermudaModifier(address account, bool onOrOff) external onlyOwner {
1022         _blacklist[account] = onOrOff;
1023     }
1024  
1025     // once enabled, can never be turned off
1026     function enableTrading() external onlyOwner {
1027         tradingActive = true;
1028         swapEnabled = true;
1029         lastLpBurnTime = block.timestamp;
1030         launchedAt = block.number;
1031         emit TradingEnabled(lastLpBurnTime, launchedAt);
1032     }
1033  
1034     // remove limits after token is stable
1035     function removeLimits() external onlyOwner returns (bool){
1036         limitsInEffect = false;
1037         emit LimitsRemoved(block.timestamp, block.number);
1038         return true;
1039     }
1040 
1041     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1042         limitsInEffect = true;
1043         return true;
1044     }
1045 
1046     function setAutoLpReceiver (address receiver) external onlyOwner {
1047         deadAddress = receiver;
1048     }
1049  
1050     // disable Transfer delay - cannot be reenabled
1051     function disableTransferDelay() external onlyOwner returns (bool){
1052         transferDelayEnabled = false;
1053         return true;
1054     }
1055  
1056     function setEarlySellTax(bool onoff) external onlyOwner  {
1057         enableEarlySellTax = onoff;
1058     }
1059 
1060     function updateBurnAddress (address newBurnAddress) external onlyOwner {
1061         burnAddress = address(newBurnAddress);
1062     }
1063  
1064      // change the minimum amount of tokens to sell from fees
1065     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1066         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1067         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1068         swapTokensAtAmount = newAmount;
1069         return true;
1070     }
1071  
1072     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1073         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1074         uint256 oldMax = maxTransactionAmount;
1075         maxTransactionAmount = newNum * (10**18);
1076         emit MaxTransactionupdated(oldMax, maxTransactionAmount);
1077     }
1078  
1079     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1080         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1081         uint256 oldMax = maxWallet;
1082         maxWallet = newNum * (10**18);
1083         emit MaxWalletUpdated(oldMax, maxWallet);
1084     }
1085  
1086     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1087         _isExcludedMaxTransactionAmount[updAds] = isEx;
1088     }
1089  
1090     // only use to disable contract sales if absolutely necessary (emergency use only)
1091     function updateSwapEnabled(bool enabled) external onlyOwner(){
1092         swapEnabled = enabled;
1093         emit SetSwapEnabled(block.timestamp,block.number,enabled);
1094     }
1095  
1096     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1097         buyMarketingFee = _marketingFee;
1098         buyLiquidityFee = _liquidityFee;
1099         buyDevFee = _devFee;
1100         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1101         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1102         emit BuyTaxesUpdated(buyDevFee, buyMarketingFee, buyLiquidityFee);
1103     }
1104  
1105     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1106         sellMarketingFee = _marketingFee;
1107         sellLiquidityFee = _liquidityFee;
1108         sellDevFee = _devFee;
1109         earlySellLiquidityFee = _earlySellLiquidityFee;
1110         earlySellMarketingFee = _earlySellMarketingFee;
1111         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1112         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1113         emit SellTaxesUpdated(sellDevFee, sellMarketingFee, sellLiquidityFee, earlySellLiquidityFee, earlySellMarketingFee);
1114     }
1115  
1116     function excludeFromFees(address account, bool excluded) public onlyOwner {
1117         _isExcludedFromFees[account] = excluded;
1118         emit ExcludeFromFees(account, excluded);
1119     }
1120  
1121     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1122         _blacklist[account] = isBlacklisted;
1123     }
1124  
1125     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1126         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1127  
1128         _setAutomatedMarketMakerPair(pair, value);
1129         emit SetAutomatedMarketMakerPair(pair, value);
1130     }
1131  
1132     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1133         automatedMarketMakerPairs[pair] = value;
1134         emit SetAutomatedMarketMakerPair(pair, value);
1135     }
1136  
1137     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1138         marketingWallet = newMarketingWallet;
1139         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1140     }
1141  
1142     function updateDevWallet(address newWallet) external onlyOwner {
1143         devWallet = newWallet;
1144         emit devWalletUpdated(newWallet, devWallet);
1145     }
1146  
1147  
1148     function isExcludedFromFees(address account) public view returns(bool) {
1149         return _isExcludedFromFees[account];
1150     }
1151  
1152     event BoughtEarly(address indexed sniper);
1153  
1154     function _transfer(
1155         address from,
1156         address to,
1157         uint256 amount
1158     ) internal override {
1159         require(from != address(0), "ERC20: transfer from the zero address");
1160         require(to != address(0), "ERC20: transfer to the zero address");
1161         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1162          if(amount == 0) {
1163             super._transfer(from, to, 0);
1164             return;
1165         }
1166  
1167         if(limitsInEffect){
1168             if (
1169                 from != owner() &&
1170                 to != owner() &&
1171                 to != address(0) &&
1172                 to != address(0xdead) &&
1173                 !swapping
1174             ){
1175                 if(!tradingActive){
1176                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1177                 }
1178  
1179                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1180                 if (transferDelayEnabled){
1181                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1182                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1183                         _holderLastTransferTimestamp[tx.origin] = block.number;
1184                     }
1185                 }
1186  
1187                 //when buy
1188                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1189                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1190                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1191                 }
1192  
1193                 //when sell
1194                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1195                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1196                 }
1197                 else if(!_isExcludedMaxTransactionAmount[to]){
1198                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1199                 }
1200             }
1201         }
1202  
1203         // anti bot logic
1204         // .. don't buy in the first four blocks.
1205         // .. including deadblock (launchedAt) 
1206         if (block.number <= (launchedAt + 4) && 
1207                 to != uniswapV2Pair && 
1208                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1209             ) { 
1210             _blacklist[to] = true;
1211             emit BoughtEarly(to);
1212         }
1213 
1214         uint256 initialSellMarketingFee = sellMarketingFee;
1215         uint256 initialSellLiquidityFee = sellLiquidityFee;
1216         // early sell logic
1217         bool isBuy = from == uniswapV2Pair;
1218         if (!isBuy && enableEarlySellTax) {
1219             if (_holderFirstBuyTimestamp[from] != 0 &&
1220                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1221                 initialSellLiquidityFee = earlySellLiquidityFee;
1222                 initialSellMarketingFee = earlySellMarketingFee;
1223             }
1224         } else {
1225             if (_holderFirstBuyTimestamp[to] == 0) {
1226                 _holderFirstBuyTimestamp[to] = block.timestamp;
1227             }
1228         }
1229  
1230         sellTotalFees = initialSellMarketingFee + initialSellLiquidityFee + sellDevFee;
1231 
1232         uint256 contractTokenBalance = balanceOf(address(this));
1233  
1234         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1235  
1236         if( 
1237             canSwap &&
1238             swapEnabled &&
1239             !swapping &&
1240             !automatedMarketMakerPairs[from] &&
1241             !_isExcludedFromFees[from] &&
1242             !_isExcludedFromFees[to]
1243         ) {
1244             swapping = true;
1245  
1246             swapBack();
1247  
1248             swapping = false;
1249         }
1250  
1251         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1252             autoBurnLiquidityPairTokens();
1253         }
1254  
1255         bool takeFee = !swapping;
1256 
1257         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1258         // if any account belongs to _isExcludedFromFee account then remove the fee
1259         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1260             takeFee = false;
1261         }
1262  
1263         uint256 fees = 0;
1264         // only take fees on buys/sells, do not take on wallet transfers
1265         if(takeFee){
1266             // on sell
1267             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1268                 fees = amount.mul(sellTotalFees).div(100);
1269                 tokensForLiquidity += fees * initialSellLiquidityFee / sellTotalFees;
1270                 tokensForDev += fees * sellDevFee / sellTotalFees;
1271                 tokensForMarketing += fees * initialSellMarketingFee / sellTotalFees;
1272             }
1273             // on buy
1274             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1275                 fees = amount.mul(buyTotalFees).div(100);
1276                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1277                 tokensForDev += fees * buyDevFee / buyTotalFees;
1278                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1279             }
1280  
1281             if(fees > 0){    
1282                 super._transfer(from, address(this), fees);
1283             }
1284  
1285             amount -= fees;
1286         }
1287  
1288         super._transfer(from, to, amount);
1289     }
1290  
1291     function swapTokensForEth(uint256 tokenAmount) private {
1292  
1293         // generate the uniswap pair path of token -> weth
1294         address[] memory path = new address[](2);
1295         path[0] = address(this);
1296         path[1] = uniswapV2Router.WETH();
1297  
1298         _approve(address(this), address(uniswapV2Router), tokenAmount);
1299  
1300         // make the swap
1301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1302             tokenAmount,
1303             0, // accept any amount of ETH
1304             path,
1305             address(this),
1306             block.timestamp
1307         );
1308  
1309     }
1310  
1311  
1312  
1313     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1314         // approve token transfer to cover all possible scenarios
1315         _approve(address(this), address(uniswapV2Router), tokenAmount);
1316  
1317         // add the liquidity
1318         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1319             address(this),
1320             tokenAmount,
1321             0, // slippage is unavoidable
1322             0, // slippage is unavoidable
1323             deadAddress,
1324             block.timestamp
1325         );
1326     }
1327  
1328     function swapBack() private {
1329         uint256 contractBalance = balanceOf(address(this));
1330         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1331         bool success;
1332  
1333         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1334  
1335         if(contractBalance > swapTokensAtAmount * 20){
1336           contractBalance = swapTokensAtAmount * 20;
1337         }
1338  
1339         // Halve the amount of liquidity tokens
1340         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1341         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1342  
1343         uint256 initialETHBalance = address(this).balance;
1344  
1345         swapTokensForEth(amountToSwapForETH); 
1346  
1347         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1348  
1349         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1350         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1351  
1352  
1353         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1354  
1355  
1356         tokensForLiquidity = 0;
1357         tokensForMarketing = 0;
1358         tokensForDev = 0;
1359  
1360         (success,) = address(devWallet).call{value: ethForDev}("");
1361  
1362         if(liquidityTokens > 0 && ethForLiquidity > 0){
1363             addLiquidity(liquidityTokens, ethForLiquidity);
1364             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1365         }
1366  
1367  
1368         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1369     }
1370  
1371     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1372         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1373         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1374         lpBurnFrequency = _frequencyInSeconds;
1375         percentForLPBurn = _percent;
1376         lpBurnEnabled = _Enabled;
1377     }
1378  
1379     function autoBurnLiquidityPairTokens() internal returns (bool){
1380  
1381         lastLpBurnTime = block.timestamp;
1382  
1383         // get balance of liquidity pair
1384         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1385  
1386         // calculate amount to burn
1387         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1388  
1389         // pull tokens from pancakePair liquidity and move to dead address permanently
1390         if (amountToBurn > 0){
1391             super._transfer(uniswapV2Pair, address(burnAddress), amountToBurn);
1392             emit AutomaticBurn(lastLpBurnTime, block.number, amountToBurn);
1393         }
1394  
1395         //sync price since this is not in a swap transaction!
1396         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1397         pair.sync();
1398         emit AutoNukeLP();
1399         return true;
1400     }
1401  
1402     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1403         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1404         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1405         lastManualLpBurnTime = block.timestamp;
1406  
1407         // get balance of liquidity pair
1408         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1409  
1410         // calculate amount to burn
1411         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1412  
1413         // pull tokens from pancakePair liquidity and move to dead address permanently
1414         if (amountToBurn > 0){
1415             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1416         }
1417  
1418         //sync price since this is not in a swap transaction!
1419         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1420         pair.sync();
1421         emit ManualNukeLP();
1422         return true;
1423     }
1424 }