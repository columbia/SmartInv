1 /**
2  *   Telegram : https://t.me/PepeYachtClub_Erc20
3  * 
4  *   Website: http://pepeyachtclubcoin.com/
5 */          
6 
7 //SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.9;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25 
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32 
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36 
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40 
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42 
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54 
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63 
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69 
70     function initialize(address, address) external;
71 }
72 
73 interface IUniswapV2Factory {
74     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75 
76     function feeTo() external view returns (address);
77     function feeToSetter() external view returns (address);
78 
79     function getPair(address tokenA, address tokenB) external view returns (address pair);
80     function allPairs(uint) external view returns (address pair);
81     function allPairsLength() external view returns (uint);
82 
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 
85     function setFeeTo(address) external;
86     function setFeeToSetter(address) external;
87 }
88 
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
384     function createInitialSupply(address account, uint256 amount) internal virtual {
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
862 
863 contract PepeYachtClub is ERC20, Ownable {
864     using SafeMath for uint256;
865 
866     IUniswapV2Router02 public uniswapV2Router;
867     address public immutable uniswapV2Pair;
868 
869     bool private swapping;
870 
871     address public marketingWallet;
872         
873     uint256 public maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 public maxWallet;
876     
877     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
878     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
879     
880     bool public limitsInEffect = true;
881     bool public tradingActive = false;
882     bool public swapEnabled = false;
883     
884      // Anti-bot and anti-whale mappings and variables
885     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
886     bool public transferDelayEnabled = true;
887     
888     
889     uint256 public totalSellFees;
890     uint256 public marketingSellFee;
891     uint256 public liquiditySellFee;
892     
893     uint256 public totalBuyFees;
894     uint256 public marketingBuyFee;
895     uint256 public liquidityBuyFee;
896     
897     uint256 public tokensForMarketing;
898     uint256 public tokensForLiquidity;
899 
900 
901     /******************/
902 
903     // exlcude from fees and max transaction amount
904     mapping (address => bool) private _isExcludedFromFees;
905     mapping (address => bool) public _isExcludedMaxTransactionAmount;
906 
907     //blacklist
908     bool public blacklistStatus;
909     mapping (address => bool) public isBlacklisted;
910 
911     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
912     // could be subject to a maximum transfer amount
913     mapping (address => bool) public automatedMarketMakerPairs;
914 
915     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
916 
917     event ExcludeFromFees(address indexed account, bool isExcluded);
918     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
919     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
920     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
921 
922     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
923 
924     event taxMultiplierActive(uint256 duration);
925     
926     
927     event SwapAndLiquify(
928         uint256 tokensSwapped,
929         uint256 ethReceived,
930         uint256 tokensIntoLiqudity
931     );
932 
933     constructor() ERC20("PepeYachtClub","PYC")  {
934         
935         address newOwner = address(0x1465C995fAf82D1658d7833486D6c1B1d9fB105b);
936     
937         uint256 totalSupply = 420689899999998 * 10**18;
938         
939         maxTransactionAmount = totalSupply * 2 / 100;
940         swapTokensAtAmount = totalSupply / 1000;
941         maxWallet = totalSupply * 6 / 100;
942 
943         marketingSellFee = 17;
944         liquiditySellFee = 3;
945         totalSellFees = marketingSellFee + liquiditySellFee;
946         
947         marketingBuyFee = 12;
948         liquidityBuyFee = 3;
949         totalBuyFees = marketingBuyFee  + liquidityBuyFee;
950             	
951     	marketingWallet = address(0x1465C995fAf82D1658d7833486D6c1B1d9fB105b); // set as mw
952 
953 
954     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
955     	
956          // Create a uniswap pair for this new token
957         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
958             .createPair(address(this), _uniswapV2Router.WETH());
959 
960         uniswapV2Router = _uniswapV2Router;
961         uniswapV2Pair = _uniswapV2Pair;
962 
963         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
964 
965         
966         // exclude from paying fees or having max transaction amount
967         excludeFromFees(newOwner, true);
968         excludeFromFees(address(this), true);
969         excludeFromFees(address(0xdead), true);
970         excludeFromMaxTransaction(newOwner, true);
971         excludeFromMaxTransaction(address(this), true);
972         excludeFromMaxTransaction(address(_uniswapV2Router), true);
973         excludeFromMaxTransaction(address(0xdead), true);
974         
975         /*
976             createInitialSupply is a function that is only called here,
977             and CANNOT be called ever again
978         */
979         
980         createInitialSupply(newOwner, totalSupply);
981         transferOwnership(newOwner);
982     }
983 
984     receive() external payable {
985 
986   	}
987 
988  
989      // disable Transfer delay - cannot be reenabled
990     function disableTransferDelay() external onlyOwner returns (bool){
991         transferDelayEnabled = false;
992         return true;
993     }
994 
995 
996      // set if blacklist function is enabled or disabled
997     function setBlacklistStatus(bool newValue) external onlyOwner() {
998         require(blacklistStatus != newValue, "Blacklist mode is already enabled");
999 
1000         blacklistStatus = newValue;
1001     }
1002     
1003     // set wallet as Blacklisted
1004     function setBlacklisted(address account, bool newValue) external onlyOwner() {
1005         require(newValue != isBlacklisted[account], "Wallet is blacklisted already");
1006         isBlacklisted[account] = newValue;
1007     }
1008 
1009     // set multiple wallets as blacklisted
1010     function massSetBlacklisted(address[] memory accounts, bool newValue) external onlyOwner() {
1011         for(uint256 i; i < accounts.length; i++) {
1012             require(newValue != isBlacklisted[accounts[i]], "Some of the values are already set as Blacklisted");
1013 
1014             isBlacklisted[accounts[i]] = newValue;
1015         }
1016     }
1017      
1018     // once enabled, can never be turned off
1019     function enableTrading() external onlyOwner {
1020         tradingActive = true;
1021         swapEnabled = true;
1022         tradingActiveBlock = block.number;
1023     }
1024     
1025     // only use to disable contract sales if absolutely necessary (emergency use only)
1026     function updateSwapEnabled(bool enabled) external onlyOwner(){
1027         swapEnabled = enabled;
1028     }
1029 
1030     function updateMaxAmount(uint256 newNum) external onlyOwner {
1031         require(newNum > (totalSupply() * 1 / 200)/1e18, "Cannot set maxTransactionAmount lower than 0,5%");
1032         maxTransactionAmount = newNum * (10**18);
1033     }
1034     
1035     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1036         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1037         maxWallet = newNum * (10**18);
1038     }
1039 
1040     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
1041         marketingBuyFee = _marketingFee;
1042         liquidityBuyFee = _liquidityFee;
1043         totalBuyFees = marketingBuyFee + liquidityBuyFee;
1044         require(totalBuyFees <= 20, "Must keep fees at 20% or less");
1045     }
1046     
1047     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
1048         marketingSellFee = _marketingFee;
1049         liquiditySellFee = _liquidityFee;
1050         totalSellFees = marketingSellFee + liquiditySellFee;
1051         require(totalSellFees <= 20, "Must keep fees at 20% or less");
1052     }
1053 
1054     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1055         _isExcludedMaxTransactionAmount[updAds] = isEx;
1056         emit ExcludedMaxTransactionAmount(updAds, isEx);
1057     }
1058 
1059     function excludeFromFees(address account, bool excluded) public onlyOwner {
1060         _isExcludedFromFees[account] = excluded;
1061 
1062         emit ExcludeFromFees(account, excluded);
1063     }
1064 
1065     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1066         require(pair != uniswapV2Pair, "The UniSwap pair cannot be removed from automatedMarketMakerPairs");
1067 
1068         _setAutomatedMarketMakerPair(pair, value);
1069     }
1070 
1071     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1072         automatedMarketMakerPairs[pair] = value;
1073 
1074         excludeFromMaxTransaction(pair, value);
1075 
1076         emit SetAutomatedMarketMakerPair(pair, value);
1077     }
1078 
1079     function isExcludedFromFees(address account) public view returns(bool) {
1080         return _isExcludedFromFees[account];
1081     }
1082     
1083     // remove limits after token is stable
1084     function removeLimits() external onlyOwner returns (bool){
1085         limitsInEffect = false;
1086         transferDelayEnabled = false;
1087         return true;
1088     }
1089     
1090     function _transfer(
1091         address from,
1092         address to,
1093         uint256 amount
1094     ) internal override {
1095         require(from != address(0), "ERC20: transfer from the zero address");
1096         require(to != address(0), "ERC20: transfer to the zero address");
1097 	  require(!blacklistStatus || (!isBlacklisted[from] && !isBlacklisted[to]), "Blacklisted!");
1098         
1099          if(amount == 0) {
1100             super._transfer(from, to, 0);
1101             return;
1102         }
1103         
1104         if(!tradingActive){
1105             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
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
1116 
1117                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1118                 if (transferDelayEnabled){
1119                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1120                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1121                         _holderLastTransferTimestamp[tx.origin] = block.number;
1122                     }
1123                 }
1124                 
1125                 //when buy
1126                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1127                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1128                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1129                 } 
1130                 //when sell
1131                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1132                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1133                 }
1134                 else if(!_isExcludedMaxTransactionAmount[to]) {
1135                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1136                 }
1137             }
1138         }
1139 
1140 		uint256 contractTokenBalance = balanceOf(address(this));
1141         
1142         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1143 
1144         if( 
1145             canSwap &&
1146             swapEnabled &&
1147             !swapping &&
1148             !automatedMarketMakerPairs[from] &&
1149             !_isExcludedFromFees[from] &&
1150             !_isExcludedFromFees[to]
1151         ) {
1152             swapping = true;
1153             swapBack();
1154             swapping = false;
1155         }
1156 
1157         bool takeFee = !swapping;
1158 
1159         // if any account belongs to _isExcludedFromFee account then remove the fee
1160         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1161             takeFee = false;
1162         }
1163         
1164         uint256 fees = 0;
1165         
1166         // no taxes on transfers (non buys/sells)
1167         if(takeFee){
1168             // on sell
1169             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1170                 fees = amount.mul(totalSellFees).div(100);
1171                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1172                 tokensForMarketing += fees * marketingSellFee / totalSellFees;
1173             }
1174             // on buy
1175             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1176         	    fees = amount.mul(totalBuyFees).div(100);
1177                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1178                 tokensForMarketing += fees * marketingBuyFee / totalBuyFees;
1179             }
1180 
1181             if(fees > 0){    
1182                 super._transfer(from, address(this), fees);
1183             }
1184         	
1185         	amount -= fees;
1186         }
1187 
1188         super._transfer(from, to, amount);
1189 
1190 
1191     }
1192 
1193     
1194     function swapTokensForEth(uint256 tokenAmount) private {
1195 
1196         // generate the uniswap pair path of token -> weth
1197         address[] memory path = new address[](2);
1198         path[0] = address(this);
1199         path[1] = uniswapV2Router.WETH();
1200 
1201         _approve(address(this), address(uniswapV2Router), tokenAmount);
1202 
1203         // make the swap
1204         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1205             tokenAmount,
1206             0, // accept any amount of ETH
1207             path,
1208             address(this),
1209             block.timestamp
1210         );
1211         
1212     }
1213     
1214     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1215         // approve token transfer to cover all possible scenarios
1216         _approve(address(this), address(uniswapV2Router), tokenAmount);
1217 
1218         // add the liquidity
1219         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1220             address(this),
1221             tokenAmount,
1222             0, // slippage is unavoidable
1223             0, // slippage is unavoidable
1224             address(0x1465C995fAf82D1658d7833486D6c1B1d9fB105b),
1225             block.timestamp
1226         );
1227 
1228     }
1229     
1230     function swapBack() private {
1231         uint256 contractBalance = balanceOf(address(this));
1232         bool success;
1233         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1234         
1235         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1236         
1237         // Halve the amount of liquidity tokens
1238         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1239         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1240         
1241         uint256 initialETHBalance = address(this).balance;
1242 
1243         swapTokensForEth(amountToSwapForETH); 
1244         
1245         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1246         
1247         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1248         
1249         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1250         
1251         tokensForLiquidity = 0;
1252         tokensForMarketing = 0;
1253 
1254         
1255         if(liquidityTokens > 0 && ethForLiquidity > 0){
1256             addLiquidity(liquidityTokens, ethForLiquidity);
1257             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1258         }
1259                         
1260         // send eth for wallets
1261         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
1262         
1263         
1264     }
1265     
1266     // useful for taxs or to reclaim any ETH on the contract in a way that helps holders.
1267     function marketingTokens(uint256 ethAmountInWei) external onlyOwner {
1268         // generate the uniswap pair path of weth -> eth
1269         address[] memory path = new address[](2);
1270         path[0] = uniswapV2Router.WETH();
1271         path[1] = address(this);
1272 
1273         // make the swap
1274         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1275             0, // accept any amount of Ethereum
1276             path,
1277             address(0xdead),
1278             block.timestamp
1279         );
1280     }
1281     
1282     function withdrawStuckEth() external onlyOwner {
1283         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1284         require(success, "failed to withdraw");
1285     }
1286 
1287 }