1 /**
2     *Telegram - t.me/MarvinInuether
3     *Website - marvininueth.com/
4     *Twitter - https://twitter.com/marvin_inu?s=21
5     *Instagram- https://instagram.com/marvininueth
6 */
7 
8 // SPDX-License-Identifier: MIT                                                                               
9                                                     
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
126      * transacgtion ordering. One possible solution to mitigate this race
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
862 contract MarvinInu is ERC20, Ownable {
863     using SafeMath for uint256;
864 
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867     address public constant deadAddress = address(0xdead);
868 
869     bool private swapping;
870 
871     address public marketingWallet;
872     address public devWallet;
873     
874     uint256 public maxTransactionAmount;
875     uint256 public swapTokensAtAmount;
876     uint256 public maxWallet;
877     
878     uint256 public percentForLPBurn = 25; // 25 = .25%
879     bool public lpBurnEnabled = true;
880     uint256 public lpBurnFrequency = 3600 seconds;
881     uint256 public lastLpBurnTime;
882     
883     uint256 public manualBurnFrequency = 30 minutes;
884     uint256 public lastManualLpBurnTime;
885 
886     bool public limitsInEffect = true;
887     bool public tradingActive = false;
888     bool public swapEnabled = false;
889     
890      // Anti-bot and anti-whale mappings and variables
891     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
892     bool public transferDelayEnabled = true;
893 
894     uint256 public buyTotalFees;
895     uint256 public buyMarketingFee;
896     uint256 public buyLiquidityFee;
897     uint256 public buyDevFee;
898     
899     uint256 public sellTotalFees;
900     uint256 public sellMarketingFee;
901     uint256 public sellLiquidityFee;
902     uint256 public sellDevFee;
903     
904     uint256 public tokensForMarketing;
905     uint256 public tokensForLiquidity;
906     uint256 public tokensForDev;
907     
908     /******************/
909 
910     // exlcude from fees and max transaction amount
911     mapping (address => bool) private _isExcludedFromFees;
912     mapping (address => bool) public _isExcludedMaxTransactionAmount;
913 
914     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
915     // could be subject to a maximum transfer amount
916     mapping (address => bool) public automatedMarketMakerPairs;
917 
918     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
919 
920     event ExcludeFromFees(address indexed account, bool isExcluded);
921 
922     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
923 
924     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
925     
926     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
927 
928     event SwapAndLiquify(
929         uint256 tokensSwapped,
930         uint256 ethReceived,
931         uint256 tokensIntoLiquidity
932     );
933     
934     event AutoNukeLP();
935     
936     event ManualNukeLP();
937 
938     constructor() ERC20("Marvin Inu", "MARVIN") {
939         
940         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
941         
942         excludeFromMaxTransaction(address(_uniswapV2Router), true);
943         uniswapV2Router = _uniswapV2Router;
944         
945         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
946         excludeFromMaxTransaction(address(uniswapV2Pair), true);
947         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
948         
949         uint256 _buyMarketingFee = 4;
950         uint256 _buyLiquidityFee = 10;
951         uint256 _buyDevFee = 1;
952 
953         uint256 _sellMarketingFee = 5;
954         uint256 _sellLiquidityFee = 15;
955         uint256 _sellDevFee = 2;
956         
957         uint256 totalSupply = 1 * 1e12 * 1e18;
958         
959         //maxTransactionAmount = totalSupply * 25 / 1000; // 0.25% maxTransactionAmountTxn
960         maxTransactionAmount = 2500000000 * 1e18;
961         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
962         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.10% swap wallet
963 
964         buyMarketingFee = _buyMarketingFee;
965         buyLiquidityFee = _buyLiquidityFee;
966         buyDevFee = _buyDevFee;
967         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
968         
969         sellMarketingFee = _sellMarketingFee;
970         sellLiquidityFee = _sellLiquidityFee;
971         sellDevFee = _sellDevFee;
972         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
973         
974         marketingWallet = address(owner()); // set as marketing wallet
975         devWallet = address(owner()); // set as dev wallet
976 
977         // exclude from paying fees or having max transaction amount
978         excludeFromFees(owner(), true);
979         excludeFromFees(address(this), true);
980         excludeFromFees(address(0xdead), true);
981         
982         excludeFromMaxTransaction(owner(), true);
983         excludeFromMaxTransaction(address(this), true);
984         excludeFromMaxTransaction(address(0xdead), true);
985         
986         /*
987             _mint is an internal function in ERC20.sol that is only called here,
988             and CANNOT be called ever again
989         */
990         _mint(msg.sender, totalSupply);
991     }
992 
993     receive() external payable {
994 
995   	}
996 
997     // once enabled, can never be turned off
998     function enableTrading() external onlyOwner {
999         tradingActive = true;
1000         swapEnabled = true;
1001         lastLpBurnTime = block.timestamp;
1002     }
1003     
1004     // remove limits after token is stable
1005     function removeLimits() external onlyOwner returns (bool){
1006         limitsInEffect = false;
1007         return true;
1008     }
1009     
1010     // disable Transfer delay - cannot be reenabled
1011     function disableTransferDelay() external onlyOwner returns (bool){
1012         transferDelayEnabled = false;
1013         return true;
1014     }
1015     
1016      // change the minimum amount of tokens to sell from fees
1017     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1018   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1019   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1020   	    swapTokensAtAmount = newAmount;
1021   	    return true;
1022   	}
1023     
1024     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1025         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1026         maxTransactionAmount = newNum * (10**18);
1027     }
1028 
1029     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1030         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1031         maxWallet = newNum * (10**18);
1032     }
1033     
1034     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1035         _isExcludedMaxTransactionAmount[updAds] = isEx;
1036     }
1037     
1038     // only use to disable contract sales if absolutely necessary (emergency use only)
1039     function updateSwapEnabled(bool enabled) external onlyOwner(){
1040         swapEnabled = enabled;
1041     }
1042     
1043     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1044         buyMarketingFee = _marketingFee;
1045         buyLiquidityFee = _liquidityFee;
1046         buyDevFee = _devFee;
1047         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1048         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1049     }
1050     
1051     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1052         sellMarketingFee = _marketingFee;
1053         sellLiquidityFee = _liquidityFee;
1054         sellDevFee = _devFee;
1055         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1056         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1057     }
1058 
1059     function excludeFromFees(address account, bool excluded) public onlyOwner {
1060         _isExcludedFromFees[account] = excluded;
1061         emit ExcludeFromFees(account, excluded);
1062     }
1063 
1064     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1065         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1066 
1067         _setAutomatedMarketMakerPair(pair, value);
1068     }
1069 
1070     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1071         automatedMarketMakerPairs[pair] = value;
1072 
1073         emit SetAutomatedMarketMakerPair(pair, value);
1074     }
1075 
1076     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1077         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1078         marketingWallet = newMarketingWallet;
1079     }
1080     
1081     function updateDevWallet(address newWallet) external onlyOwner {
1082         emit devWalletUpdated(newWallet, devWallet);
1083         devWallet = newWallet;
1084     }
1085     
1086 
1087     function isExcludedFromFees(address account) public view returns(bool) {
1088         return _isExcludedFromFees[account];
1089     }
1090     
1091     event BoughtEarly(address indexed sniper);
1092 
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) internal override {
1098         require(from != address(0), "ERC20: transfer from the zero address");
1099         require(to != address(0), "ERC20: transfer to the zero address");
1100         
1101          if(amount == 0) {
1102             super._transfer(from, to, 0);
1103             return;
1104         }
1105         
1106         if(limitsInEffect){
1107             if (
1108                 from != owner() &&
1109                 to != owner() &&
1110                 to != address(0) &&
1111                 to != address(0xdead) &&
1112                 !swapping
1113             ){
1114                 if(!tradingActive){
1115                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1116                 }
1117 
1118                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1119                 if (transferDelayEnabled){
1120                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1121                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1122                         _holderLastTransferTimestamp[tx.origin] = block.number;
1123                     }
1124                 }
1125                  
1126                 //when buy
1127                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1128                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1129                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1130                 }
1131                 
1132                 //when sell
1133                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1134                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1135                 }
1136                 else if(!_isExcludedMaxTransactionAmount[to]){
1137                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1138                 }
1139             }
1140         }
1141         
1142         
1143         
1144 		uint256 contractTokenBalance = balanceOf(address(this));
1145         
1146         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1147 
1148         if( 
1149             canSwap &&
1150             swapEnabled &&
1151             !swapping &&
1152             !automatedMarketMakerPairs[from] &&
1153             !_isExcludedFromFees[from] &&
1154             !_isExcludedFromFees[to]
1155         ) {
1156             swapping = true;
1157             
1158             swapBack();
1159 
1160             swapping = false;
1161         }
1162         
1163         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1164             autoBurnLiquidityPairTokens();
1165         }
1166 
1167         bool takeFee = !swapping;
1168 
1169         // if any account belongs to _isExcludedFromFee account then remove the fee
1170         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1171             takeFee = false;
1172         }
1173         
1174         uint256 fees = 0;
1175         // only take fees on buys/sells, do not take on wallet transfers
1176         if(takeFee){
1177             // on sell
1178             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1179                 fees = amount.mul(sellTotalFees).div(100);
1180                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1181                 tokensForDev += fees * sellDevFee / sellTotalFees;
1182                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1183             }
1184             // on buy
1185             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1186         	    fees = amount.mul(buyTotalFees).div(100);
1187         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1188                 tokensForDev += fees * buyDevFee / buyTotalFees;
1189                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1190             }
1191             
1192             if(fees > 0){    
1193                 super._transfer(from, address(this), fees);
1194             }
1195         	
1196         	amount -= fees;
1197         }
1198 
1199         super._transfer(from, to, amount);
1200     }
1201 
1202     function swapTokensForEth(uint256 tokenAmount) private {
1203 
1204         // generate the uniswap pair path of token -> weth
1205         address[] memory path = new address[](2);
1206         path[0] = address(this);
1207         path[1] = uniswapV2Router.WETH();
1208 
1209         _approve(address(this), address(uniswapV2Router), tokenAmount);
1210 
1211         // make the swap
1212         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1213             tokenAmount,
1214             0, // accept any amount of ETH
1215             path,
1216             address(this),
1217             block.timestamp
1218         );
1219         
1220     }
1221     
1222     
1223     
1224     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1225         // approve token transfer to cover all possible scenarios
1226         _approve(address(this), address(uniswapV2Router), tokenAmount);
1227 
1228         // add the liquidity
1229         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1230             address(this),
1231             tokenAmount,
1232             0, // slippage is unavoidable
1233             0, // slippage is unavoidable
1234             deadAddress,
1235             block.timestamp
1236         );
1237     }
1238 
1239     function swapBack() private {
1240         uint256 contractBalance = balanceOf(address(this));
1241         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1242         bool success;
1243         
1244         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1245 
1246         if(contractBalance > swapTokensAtAmount * 20){
1247           contractBalance = swapTokensAtAmount * 20;
1248         }
1249         
1250         // Halve the amount of liquidity tokens
1251         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1252         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1253         
1254         uint256 initialETHBalance = address(this).balance;
1255 
1256         swapTokensForEth(amountToSwapForETH); 
1257         
1258         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1259         
1260         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1261         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1262         
1263         
1264         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1265         
1266         
1267         tokensForLiquidity = 0;
1268         tokensForMarketing = 0;
1269         tokensForDev = 0;
1270         
1271         (success,) = address(devWallet).call{value: ethForDev}("");
1272         
1273         if(liquidityTokens > 0 && ethForLiquidity > 0){
1274             addLiquidity(liquidityTokens, ethForLiquidity);
1275             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1276         }
1277         
1278         
1279         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1280     }
1281     
1282     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1283         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1284         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1285         lpBurnFrequency = _frequencyInSeconds;
1286         percentForLPBurn = _percent;
1287         lpBurnEnabled = _Enabled;
1288     }
1289     
1290     function autoBurnLiquidityPairTokens() internal returns (bool){
1291         
1292         lastLpBurnTime = block.timestamp;
1293         
1294         // get balance of liquidity pair
1295         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1296         
1297         // calculate amount to burn
1298         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1299         
1300         // pull tokens from pancakePair liquidity and move to dead address permanently
1301         if (amountToBurn > 0){
1302             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1303         }
1304         
1305         //sync price since this is not in a swap transaction!
1306         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1307         pair.sync();
1308         emit AutoNukeLP();
1309         return true;
1310     }
1311 
1312     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1313         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1314         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1315         lastManualLpBurnTime = block.timestamp;
1316         
1317         // get balance of liquidity pair
1318         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1319         
1320         // calculate amount to burn
1321         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1322         
1323         // pull tokens from pancakePair liquidity and move to dead address permanently
1324         if (amountToBurn > 0){
1325             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1326         }
1327         
1328         //sync price since this is not in a swap transaction!
1329         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1330         pair.sync();
1331         emit ManualNukeLP();
1332         return true;
1333     }
1334 }