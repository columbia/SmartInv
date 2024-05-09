1 /**
2  *                          
3  *      Telegram:   https://t.me/RabbithereumETH 
4  *      Miner: https://rabbithereum.network
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
863 contract CARRETH is ERC20, Ownable {
864     using SafeMath for uint256;
865 
866     IUniswapV2Router02 public uniswapV2Router;
867     address public immutable uniswapV2Pair;
868 
869     bool private swapping;
870 
871     address public taxWallet;
872     address public TVLWallet;
873         
874     uint256 public maxTransactionAmount;
875     uint256 public swapTokensAtAmount;
876     uint256 public maxWallet;
877     
878     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
879     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
880     
881     bool public limitsInEffect = true;
882     bool public tradingActive = false;
883     bool public swapEnabled = false;
884     
885      // Anti-bot and anti-whale mappings and variables
886     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
887     bool public transferDelayEnabled = true;
888     
889     
890     uint256 public totalSellFees;
891     uint256 public taxSellFee;
892     uint256 public liquiditySellFee;
893     
894     uint256 public totalBuyFees;
895     uint256 public taxBuyFee;
896     uint256 public liquidityBuyFee;
897     
898     uint256 public tokensForTax;
899     uint256 public tokensForLiquidity;
900 
901 
902     /******************/
903 
904     // exlcude from fees and max transaction amount
905     mapping (address => bool) private _isExcludedFromFees;
906 
907     mapping (address => bool) public _isExcludedMaxTransactionAmount;
908 
909     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
910     // could be subject to a maximum transfer amount
911     mapping (address => bool) public automatedMarketMakerPairs;
912 
913     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
914 
915     event ExcludeFromFees(address indexed account, bool isExcluded);
916     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
917     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
918     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
919 
920     event taxWalletUpdated(address indexed newWallet, address indexed oldWallet);
921 
922     event taxMultiplierActive(uint256 duration);
923     
924     
925     event SwapAndLiquify(
926         uint256 tokensSwapped,
927         uint256 ethReceived,
928         uint256 tokensIntoLiqudity
929     );
930 
931     constructor() ERC20("Rabbithereum", "Carreth") {
932         
933         address newOwner = address(0x66b05A08b6E42696bF0d9766C34616319edf810B);
934     
935         uint256 totalSupply = 1000000 * 10**18;
936         
937         maxTransactionAmount = totalSupply * 1 / 200; // 0,5% max transaction, will be higher
938         swapTokensAtAmount = totalSupply * 1 / 1000; // 0.1% swap tokens amount
939         maxWallet = totalSupply * 1 / 100; // 1% max wallet, will be higher
940 
941         taxSellFee = 16;   //First 2 hours
942         liquiditySellFee = 4;    //First 2 hours
943         totalSellFees = taxSellFee + liquiditySellFee;
944         
945         taxBuyFee = 4;
946         liquidityBuyFee = 1;
947         totalBuyFees = taxBuyFee + liquidityBuyFee;
948             	
949     	taxWallet = address(0x31241D95FFBd38772605929f1C0cc5D67e078856); // set as tax wallet
950 
951     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
952     	
953          // Create a uniswap pair for this new token
954         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
955             .createPair(address(this), _uniswapV2Router.WETH());
956 
957         uniswapV2Router = _uniswapV2Router;
958         uniswapV2Pair = _uniswapV2Pair;
959 
960         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
961 
962         
963         // exclude from paying fees or having max transaction amount
964         excludeFromFees(newOwner, true);
965         excludeFromFees(address(this), true);
966         excludeFromFees(address(0xdead), true);
967         excludeFromMaxTransaction(newOwner, true);
968         excludeFromMaxTransaction(address(this), true);
969         excludeFromMaxTransaction(address(_uniswapV2Router), true);
970         excludeFromMaxTransaction(address(0xdead), true);
971         
972         /*
973             createInitialSupply is a function that is only called here,
974             and CANNOT be called ever again
975         */
976         
977         createInitialSupply(newOwner, totalSupply);
978         transferOwnership(newOwner);
979     }
980 
981     receive() external payable {
982 
983   	}
984 
985  
986      // disable Transfer delay - cannot be reenabled
987     function disableTransferDelay() external onlyOwner returns (bool){
988         transferDelayEnabled = false;
989         return true;
990     }
991 
992      
993     // once enabled, can never be turned off
994     function enableTrading() external onlyOwner {
995         tradingActive = true;
996         swapEnabled = true;
997         tradingActiveBlock = block.number;
998     }
999     
1000     // only use to disable contract sales if absolutely necessary (emergency use only)
1001     function updateSwapEnabled(bool enabled) external onlyOwner(){
1002         swapEnabled = enabled;
1003     }
1004 
1005     function updateMaxAmount(uint256 newNum) external onlyOwner {
1006         require(newNum > (totalSupply() * 1 / 200)/1e18, "Cannot set maxTransactionAmount lower than 0,5%");
1007         maxTransactionAmount = newNum * (10**18);
1008     }
1009     
1010     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1011         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1012         maxWallet = newNum * (10**18);
1013     }
1014     
1015     function updateBuyFees(uint256 _taxFee, uint256 _liquidityFee) external onlyOwner {
1016         taxBuyFee = _taxFee;
1017         liquidityBuyFee = _liquidityFee;
1018         totalBuyFees = taxBuyFee + liquidityBuyFee;
1019         require(totalBuyFees <= 5, "Must keep fees at 5% or less");
1020     }
1021     
1022     function updateSellFees(uint256 _taxFee, uint256 _liquidityFee) external onlyOwner {
1023         taxSellFee = _taxFee;
1024         liquiditySellFee = _liquidityFee;
1025         totalSellFees = taxSellFee + liquiditySellFee;
1026         require(totalSellFees <= 20, "Must keep fees at 20% or less");
1027     }
1028 
1029     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1030         _isExcludedMaxTransactionAmount[updAds] = isEx;
1031         emit ExcludedMaxTransactionAmount(updAds, isEx);
1032     }
1033 
1034     function excludeFromFees(address account, bool excluded) public onlyOwner {
1035         _isExcludedFromFees[account] = excluded;
1036 
1037         emit ExcludeFromFees(account, excluded);
1038     }
1039 
1040     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1041         for(uint256 i = 0; i < accounts.length; i++) {
1042             _isExcludedFromFees[accounts[i]] = excluded;
1043         }
1044 
1045         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1046     }
1047 
1048     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1049         require(pair != uniswapV2Pair, "The UniSwap pair cannot be removed from automatedMarketMakerPairs");
1050 
1051         _setAutomatedMarketMakerPair(pair, value);
1052     }
1053 
1054     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1055         automatedMarketMakerPairs[pair] = value;
1056 
1057         excludeFromMaxTransaction(pair, value);
1058 
1059         emit SetAutomatedMarketMakerPair(pair, value);
1060     }
1061 
1062     function updatetaxWallet(address newtaxWallet) external onlyOwner {
1063         require(newtaxWallet != address(0), "cannot set to address 0");
1064         excludeFromFees(newtaxWallet, true);
1065         emit taxWalletUpdated(newtaxWallet, taxWallet);
1066         taxWallet = newtaxWallet;
1067     }
1068 
1069     function isExcludedFromFees(address account) public view returns(bool) {
1070         return _isExcludedFromFees[account];
1071     }
1072     
1073     // remove limits after token is stable
1074     function removeLimits() external onlyOwner returns (bool){
1075         limitsInEffect = false;
1076         transferDelayEnabled = false;
1077         return true;
1078     }
1079     
1080     function _transfer(
1081         address from,
1082         address to,
1083         uint256 amount
1084     ) internal override {
1085         require(from != address(0), "ERC20: transfer from the zero address");
1086         require(to != address(0), "ERC20: transfer to the zero address");
1087         
1088          if(amount == 0) {
1089             super._transfer(from, to, 0);
1090             return;
1091         }
1092         
1093         if(!tradingActive){
1094             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
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
1105 
1106                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1107                 if (transferDelayEnabled){
1108                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1109                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1110                         _holderLastTransferTimestamp[tx.origin] = block.number;
1111                     }
1112                 }
1113                 
1114                 //when buy
1115                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1116                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1117                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1118                 } 
1119                 //when sell
1120                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1121                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1122                 }
1123                 else if(!_isExcludedMaxTransactionAmount[to]) {
1124                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1125                 }
1126             }
1127         }
1128 
1129 		uint256 contractTokenBalance = balanceOf(address(this));
1130         
1131         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1132 
1133         if( 
1134             canSwap &&
1135             swapEnabled &&
1136             !swapping &&
1137             !automatedMarketMakerPairs[from] &&
1138             !_isExcludedFromFees[from] &&
1139             !_isExcludedFromFees[to]
1140         ) {
1141             swapping = true;
1142             swapBack();
1143             swapping = false;
1144         }
1145 
1146         bool takeFee = !swapping;
1147 
1148         // if any account belongs to _isExcludedFromFee account then remove the fee
1149         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1150             takeFee = false;
1151         }
1152         
1153         uint256 fees = 0;
1154         
1155         // no taxes on transfers (non buys/sells)
1156         if(takeFee){
1157             // on sell
1158             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1159                 fees = amount.mul(totalSellFees).div(100);
1160                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1161                 tokensForTax += fees * taxSellFee / totalSellFees;
1162             }
1163             // on buy
1164             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1165         	    fees = amount.mul(totalBuyFees).div(100);
1166                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1167                 tokensForTax += fees * taxBuyFee / totalBuyFees;
1168             }
1169 
1170             if(fees > 0){    
1171                 super._transfer(from, address(this), fees);
1172             }
1173         	
1174         	amount -= fees;
1175         }
1176 
1177         super._transfer(from, to, amount);
1178 
1179 
1180     }
1181 
1182     
1183     function swapTokensForEth(uint256 tokenAmount) private {
1184 
1185         // generate the uniswap pair path of token -> weth
1186         address[] memory path = new address[](2);
1187         path[0] = address(this);
1188         path[1] = uniswapV2Router.WETH();
1189 
1190         _approve(address(this), address(uniswapV2Router), tokenAmount);
1191 
1192         // make the swap
1193         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1194             tokenAmount,
1195             0, // accept any amount of ETH
1196             path,
1197             address(this),
1198             block.timestamp
1199         );
1200         
1201     }
1202     
1203     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1204         // approve token transfer to cover all possible scenarios
1205         _approve(address(this), address(uniswapV2Router), tokenAmount);
1206 
1207         // add the liquidity
1208         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1209             address(this),
1210             tokenAmount,
1211             0, // slippage is unavoidable
1212             0, // slippage is unavoidable
1213             address(0x66b05A08b6E42696bF0d9766C34616319edf810B),
1214             block.timestamp
1215         );
1216 
1217     }
1218     
1219     function swapBack() private {
1220         uint256 contractBalance = balanceOf(address(this));
1221         bool success;
1222         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTax;
1223         
1224         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1225         
1226         // Halve the amount of liquidity tokens
1227         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1228         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1229         
1230         uint256 initialETHBalance = address(this).balance;
1231 
1232         swapTokensForEth(amountToSwapForETH); 
1233         
1234         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1235         
1236         uint256 ethForTax = ethBalance.mul(tokensForTax).div(totalTokensToSwap);
1237         
1238         uint256 ethForLiquidity = ethBalance - ethForTax;
1239         
1240         tokensForLiquidity = 0;
1241         tokensForTax = 0;
1242         
1243         if(liquidityTokens > 0 && ethForLiquidity > 0){
1244             addLiquidity(liquidityTokens, ethForLiquidity);
1245             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1246         }
1247                         
1248         // send remainder to taxWallet
1249         (success,) = address(taxWallet).call{value: address(this).balance}("");
1250         
1251         
1252     }
1253     
1254     // useful for taxs or to reclaim any ETH on the contract in a way that helps holders.
1255     function taxTokens(uint256 ethAmountInWei) external onlyOwner {
1256         // generate the uniswap pair path of weth -> eth
1257         address[] memory path = new address[](2);
1258         path[0] = uniswapV2Router.WETH();
1259         path[1] = address(this);
1260 
1261         // make the swap
1262         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1263             0, // accept any amount of Ethereum
1264             path,
1265             address(0xdead),
1266             block.timestamp
1267         );
1268     }
1269     
1270     function withdrawStuckEth() external onlyOwner {
1271         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1272         require(success, "failed to withdraw");
1273     }
1274 
1275 }