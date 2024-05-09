1 //TG: https://t.me/UkiyoDoge
2 
3 //Twitter: https://twitter.com/UkiyoDoge_ETH
4 
5 //Website: http://ukiyodoge.com/
6 
7 //Medium: https://medium.com/@UkiyoDoge/ukiyo-doge-de9ec04107e0
8 
9 //SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity 0.8.17;
12  
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17  
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23  
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27  
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34  
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38  
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42  
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44  
45     event Mint(address indexed sender, uint amount0, uint amount1);
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
862 contract UkiyoDoge is ERC20, Ownable {
863     using SafeMath for uint256;
864  
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867  
868     bool private swapping;
869  
870     address private marketingWallet;
871     address private devWallet;
872  
873     uint256 public maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 public maxWallet;
876  
877     bool public limitsInEffect = true;
878     bool public tradingActive = true;
879     bool public swapEnabled = true;
880  
881     
882     uint256 public buyTotalFees;
883     uint256 public buyMarketingFee;
884     uint256 public buyLiquidityFee;
885     uint256 public buyDevFee;
886  
887     uint256 public sellTotalFees;
888     uint256 public sellMarketingFee;
889     uint256 public sellLiquidityFee;
890     uint256 public sellDevFee;
891  
892     uint256 public tokensForMarketing;
893     uint256 public tokensForLiquidity;
894     uint256 public tokensForDev;
895  
896     // block number of opened trading
897     uint256 launchedAt;
898  
899     /******************/
900  
901     // exclude from fees and max transaction amount
902     mapping (address => bool) private _isExcludedFromFees;
903     mapping (address => bool) public _isExcludedMaxTransactionAmount;
904  
905     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
906     // could be subject to a maximum transfer amount
907     mapping (address => bool) public partners;
908  
909     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
910  
911     event ExcludeFromFees(address indexed account, bool isExcluded);
912  
913     event Setpartner(address indexed pair, bool indexed value);
914  
915     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
916  
917     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
918  
919     event SwapAndLiquify(
920         uint256 tokensSwapped,
921         uint256 ethReceived,
922         uint256 tokensIntoLiquidity
923     );
924  
925     event AutoNukeLP();
926  
927     event ManualNukeLP();
928  
929     constructor() ERC20("Ukiyo Doge","UKIYO") {
930                                      
931         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
932  
933         excludeFromMaxTransaction(address(_uniswapV2Router), true);
934         uniswapV2Router = _uniswapV2Router;
935  
936         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
937         excludeFromMaxTransaction(address(uniswapV2Pair), true);
938         _setpartner(address(uniswapV2Pair), true);
939  
940         uint256 _buyMarketingFee = 7;
941         uint256 _buyLiquidityFee = 1;
942         uint256 _buyDevFee = 0;
943  
944         uint256 _sellMarketingFee = 70;
945         uint256 _sellLiquidityFee = 20;
946         uint256 _sellDevFee = 0;
947  
948         uint256 totalSupply = 1 * 1e9 * 1e18;
949  
950         maxTransactionAmount = totalSupply * 10 / 1000; // 1%
951         maxWallet = totalSupply * 10 / 1000; // 1% 
952         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
953  
954         buyMarketingFee = _buyMarketingFee;
955         buyLiquidityFee = _buyLiquidityFee;
956         buyDevFee = _buyDevFee;
957         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
958  
959         sellMarketingFee = _sellMarketingFee;
960         sellLiquidityFee = _sellLiquidityFee;
961         sellDevFee = _sellDevFee;
962         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
963  
964         marketingWallet = 0xC88aA8a5222b2cF95E927D68cD1902e830A5D968; 
965         devWallet = 0xC88aA8a5222b2cF95E927D68cD1902e830A5D968; 
966  
967         // exclude from paying fees or having max transaction amount
968         excludeFromFees(owner(), true);
969         excludeFromFees(address(this), true);
970         excludeFromFees(address(0xdead), true);
971  
972         excludeFromMaxTransaction(owner(), true);
973         excludeFromMaxTransaction(address(this), true);
974         excludeFromMaxTransaction(address(0xdead), true);
975  
976         /*
977             _mint is an internal function in ERC20.sol that is only called here,
978             and CANNOT be called ever again
979         */
980         _mint(msg.sender, totalSupply);
981     }
982  
983     receive() external payable {
984  
985     }
986  
987     // once enabled, can never be turned off
988     function enableTrading() external onlyOwner {
989         tradingActive = true;
990         swapEnabled = true;
991         launchedAt = block.number;
992     }
993  
994     // remove limits after token is stable
995     function removeLimits() external onlyOwner returns (bool){
996         limitsInEffect = false;
997         return true;
998     }
999  
1000      
1001      // change the minimum amount of tokens to sell from fees
1002     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1003         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1004         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1005         swapTokensAtAmount = newAmount;
1006         return true;
1007     }
1008  
1009     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1010         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1011         maxTransactionAmount = newNum * (10**18);
1012     }
1013  
1014     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1015         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1016         maxWallet = newNum * (10**18);
1017     }
1018  
1019     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1020         _isExcludedMaxTransactionAmount[updAds] = isEx;
1021     }
1022 
1023           function updateBuyFees(
1024         uint256 _devFee,
1025         uint256 _liquidityFee,
1026         uint256 _marketingFee
1027     ) external onlyOwner {
1028         buyDevFee = _devFee;
1029         buyLiquidityFee = _liquidityFee;
1030         buyMarketingFee = _marketingFee;
1031         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1032         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1033     }
1034 
1035     function updateSellFees(
1036         uint256 _devFee,
1037         uint256 _liquidityFee,
1038         uint256 _marketingFee
1039     ) external onlyOwner {
1040         sellDevFee = _devFee;
1041         sellLiquidityFee = _liquidityFee;
1042         sellMarketingFee = _marketingFee;
1043         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1044         require(sellTotalFees <= 90, "Must keep fees at 90% or less");
1045     }
1046  
1047     // only use to disable contract sales if absolutely necessary (emergency use only)
1048     function updateSwapEnabled(bool enabled) external onlyOwner(){
1049         swapEnabled = enabled;
1050     }
1051  
1052     function excludeFromFees(address account, bool excluded) public onlyOwner {
1053         _isExcludedFromFees[account] = excluded;
1054         emit ExcludeFromFees(account, excluded);
1055     }
1056  
1057  
1058     function setpartner(address pair, bool value) public onlyOwner {
1059         require(pair != uniswapV2Pair, "The pair cannot be removed from partners");
1060  
1061         _setpartner(pair, value);
1062     }
1063  
1064     function _setpartner(address pair, bool value) private {
1065         partners[pair] = value;
1066  
1067         emit Setpartner(pair, value);
1068     }
1069  
1070     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1071         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1072         marketingWallet = newMarketingWallet;
1073     }
1074  
1075     function updateDevWallet(address newWallet) external onlyOwner {
1076         emit devWalletUpdated(newWallet, devWallet);
1077         devWallet = newWallet;
1078     }
1079   
1080     function isExcludedFromFees(address account) public view returns(bool) {
1081         return _isExcludedFromFees[account];
1082     }
1083  
1084     function _transfer(
1085         address from,
1086         address to,
1087         uint256 amount
1088     ) internal override {
1089         require(from != address(0), "ERC20: transfer from the zero address");
1090         require(to != address(0), "ERC20: transfer to the zero address");
1091             if(amount == 0) {
1092             super._transfer(from, to, 0);
1093             return;
1094         }
1095  
1096         if(limitsInEffect){
1097             if (
1098                 from != owner() &&
1099                 to != owner() &&
1100                 to != address(0) &&
1101                 to != address(0xdead) &&
1102                 !swapping
1103             ){
1104                 if(!tradingActive){
1105                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1106                 }
1107  
1108                 //when buy
1109                 if (partners[from] && !_isExcludedMaxTransactionAmount[to]) {
1110                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1111                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1112                 }
1113  
1114                 else if (partners[to] && !_isExcludedMaxTransactionAmount[from]) {
1115                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1116                 }
1117                 else if(!_isExcludedMaxTransactionAmount[to]){
1118                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1119                 }
1120             }
1121         }
1122  
1123         uint256 contractTokenBalance = balanceOf(address(this));
1124  
1125         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1126  
1127         if( 
1128             canSwap &&
1129             swapEnabled &&
1130             !swapping &&
1131             !partners[from] &&
1132             !_isExcludedFromFees[from] &&
1133             !_isExcludedFromFees[to]
1134         ) {
1135             swapping = true;
1136  
1137             swapBack();
1138  
1139             swapping = false;
1140         }
1141  
1142         bool takeFee = !swapping;
1143  
1144         // if any account belongs to _isExcludedFromFee account then remove the fee
1145         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1146             takeFee = false;
1147         }
1148  
1149         uint256 fees = 0;
1150         // only take fees on buys/sells, do not take on wallet transfers
1151         if(takeFee){
1152             // on sell
1153             if (partners[to] && sellTotalFees > 0){
1154                 fees = amount.mul(sellTotalFees).div(100);
1155                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1156                 tokensForDev += fees * sellDevFee / sellTotalFees;
1157                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1158             }
1159             // on buy
1160             else if(partners[from] && buyTotalFees > 0) {
1161                 fees = amount.mul(buyTotalFees).div(100);
1162                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1163                 tokensForDev += fees * buyDevFee / buyTotalFees;
1164                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1165             }
1166  
1167             if(fees > 0){    
1168                 super._transfer(from, address(this), fees);
1169             }
1170  
1171             amount -= fees;
1172         }
1173  
1174         super._transfer(from, to, amount);
1175     }
1176  
1177     function swapTokensForEth(uint256 tokenAmount) private {
1178  
1179         // generate the uniswap pair path of token -> weth
1180         address[] memory path = new address[](2);
1181         path[0] = address(this);
1182         path[1] = uniswapV2Router.WETH();
1183  
1184         _approve(address(this), address(uniswapV2Router), tokenAmount);
1185  
1186         // make the swap
1187         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1188             tokenAmount,
1189             0, // accept any amount of ETH
1190             path,
1191             address(this),
1192             block.timestamp
1193         );
1194  
1195     }
1196  
1197     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1198         // approve token transfer to cover all possible scenarios
1199         _approve(address(this), address(uniswapV2Router), tokenAmount);
1200  
1201         // add the liquidity
1202         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1203             address(this),
1204             tokenAmount,
1205             0, // slippage is unavoidable
1206             0, // slippage is unavoidable
1207             address(this),
1208             block.timestamp
1209         );
1210     }
1211  
1212     function swapBack() private {
1213         uint256 contractBalance = balanceOf(address(this));
1214         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1215         bool success;
1216  
1217         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1218  
1219         if(contractBalance > swapTokensAtAmount * 20){
1220           contractBalance = swapTokensAtAmount * 20;
1221         }
1222  
1223         // Halve the amount of liquidity tokens
1224         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1225         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1226  
1227         uint256 initialETHBalance = address(this).balance;
1228  
1229         swapTokensForEth(amountToSwapForETH); 
1230  
1231         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1232  
1233         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1234         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1235         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1236  
1237  
1238         tokensForLiquidity = 0;
1239         tokensForMarketing = 0;
1240         tokensForDev = 0;
1241  
1242         (success,) = address(devWallet).call{value: ethForDev}("");
1243  
1244         if(liquidityTokens > 0 && ethForLiquidity > 0){
1245             addLiquidity(liquidityTokens, ethForLiquidity);
1246             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1247         }
1248  
1249         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1250     }
1251 }