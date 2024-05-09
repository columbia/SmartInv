1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4 
5 Telegram: https://t.me/ShilaInuERC
6 Website: https://shilainu.com/ 
7 
8 */
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
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53  
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62  
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68  
69     function initialize(address, address) external;
70 }
71  
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74  
75     function feeTo() external view returns (address);
76     function feeToSetter() external view returns (address);
77  
78     function getPair(address tokenA, address tokenB) external view returns (address pair);
79     function allPairs(uint) external view returns (address pair);
80     function allPairsLength() external view returns (uint);
81  
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83  
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87  
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93  
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98  
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address recipient, uint256 amount) external returns (bool);
107  
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116  
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132  
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147  
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155  
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162  
163 interface IERC20Metadata is IERC20 {
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() external view returns (string memory);
168  
169     /**
170      * @dev Returns the symbol of the token.
171      */
172     function symbol() external view returns (string memory);
173  
174     /**
175      * @dev Returns the decimals places of the token.
176      */
177     function decimals() external view returns (uint8);
178 }
179  
180  
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     using SafeMath for uint256;
183  
184     mapping(address => uint256) private _balances;
185  
186     mapping(address => mapping(address => uint256)) private _allowances;
187  
188     uint256 private _totalSupply;
189  
190     string private _name;
191     string private _symbol;
192  
193     /**
194      * @dev Sets the values for {name} and {symbol}.
195      *
196      * The default value of {decimals} is 18. To select a different value for
197      * {decimals} you should overload it.
198      *
199      * All two of these values are immutable: they can only be set once during
200      * construction.
201      */
202     constructor(string memory name_, string memory symbol_) {
203         _name = name_;
204         _symbol = symbol_;
205     }
206  
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() public view virtual override returns (string memory) {
211         return _name;
212     }
213  
214     /**
215      * @dev Returns the symbol of the token, usually a shorter version of the
216      * name.
217      */
218     function symbol() public view virtual override returns (string memory) {
219         return _symbol;
220     }
221  
222     /**
223      * @dev Returns the number of decimals used to get its user representation.
224      * For example, if `decimals` equals `2`, a balance of `505` tokens should
225      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
226      *
227      * Tokens usually opt for a value of 18, imitating the relationship between
228      * Ether and Wei. This is the value {ERC20} uses, unless this function is
229      * overridden;
230      *
231      * NOTE: This information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * {IERC20-balanceOf} and {IERC20-transfer}.
234      */
235     function decimals() public view virtual override returns (uint8) {
236         return 18;
237     }
238  
239     /**
240      * @dev See {IERC20-totalSupply}.
241      */
242     function totalSupply() public view virtual override returns (uint256) {
243         return _totalSupply;
244     }
245  
246     /**
247      * @dev See {IERC20-balanceOf}.
248      */
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252  
253     /**
254      * @dev See {IERC20-transfer}.
255      *
256      * Requirements:
257      *
258      * - `recipient` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265  
266     /**
267      * @dev See {IERC20-allowance}.
268      */
269     function allowance(address owner, address spender) public view virtual override returns (uint256) {
270         return _allowances[owner][spender];
271     }
272  
273     /**
274      * @dev See {IERC20-approve}.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284  
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * Requirements:
292      *
293      * - `sender` and `recipient` cannot be the zero address.
294      * - `sender` must have a balance of at least `amount`.
295      * - the caller must have allowance for ``sender``'s tokens of at least
296      * `amount`.
297      */
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) public virtual override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307  
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324  
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
341         return true;
342     }
343  
344     /**
345      * @dev Moves tokens `amount` from `sender` to `recipient`.
346      *
347      * This is internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) internal virtual {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365  
366         _beforeTokenTransfer(sender, recipient, amount);
367  
368         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
369         _balances[recipient] = _balances[recipient].add(amount);
370         emit Transfer(sender, recipient, amount);
371     }
372  
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384  
385         _beforeTokenTransfer(address(0), account, amount);
386  
387         _totalSupply = _totalSupply.add(amount);
388         _balances[account] = _balances[account].add(amount);
389         emit Transfer(address(0), account, amount);
390     }
391  
392     /**
393      * @dev Destroys `amount` tokens from `account`, reducing the
394      * total supply.
395      *
396      * Emits a {Transfer} event with `to` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      * - `account` must have at least `amount` tokens.
402      */
403     function _burn(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: burn from the zero address");
405  
406         _beforeTokenTransfer(account, address(0), amount);
407  
408         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
409         _totalSupply = _totalSupply.sub(amount);
410         emit Transfer(account, address(0), amount);
411     }
412  
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433  
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437  
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be to transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 }
458  
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      *
468      * - Addition cannot overflow.
469      */
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473  
474         return c;
475     }
476  
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's `-` operator.
482      *
483      * Requirements:
484      *
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         return sub(a, b, "SafeMath: subtraction overflow");
489     }
490  
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         uint256 c = a - b;
504  
505         return c;
506     }
507  
508     /**
509      * @dev Returns the multiplication of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `*` operator.
513      *
514      * Requirements:
515      *
516      * - Multiplication cannot overflow.
517      */
518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
519         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520         // benefit is lost if 'b' is also tested.
521         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
522         if (a == 0) {
523             return 0;
524         }
525  
526         uint256 c = a * b;
527         require(c / a == b, "SafeMath: multiplication overflow");
528  
529         return c;
530     }
531  
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         return div(a, b, "SafeMath: division by zero");
546     }
547  
548     /**
549      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
550      * division by zero. The result is rounded towards zero.
551      *
552      * Counterpart to Solidity's `/` operator. Note: this function uses a
553      * `revert` opcode (which leaves remaining gas untouched) while Solidity
554      * uses an invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
561         require(b > 0, errorMessage);
562         uint256 c = a / b;
563         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
564  
565         return c;
566     }
567  
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
581         return mod(a, b, "SafeMath: modulo by zero");
582     }
583  
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * Reverts with custom message when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b != 0, errorMessage);
598         return a % b;
599     }
600 }
601  
602 contract Ownable is Context {
603     address private _owner;
604  
605     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606  
607     /**
608      * @dev Initializes the contract setting the deployer as the initial owner.
609      */
610     constructor () {
611         address msgSender = _msgSender();
612         _owner = msgSender;
613         emit OwnershipTransferred(address(0), msgSender);
614     }
615  
616     /**
617      * @dev Returns the address of the current owner.
618      */
619     function owner() public view returns (address) {
620         return _owner;
621     }
622  
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         require(_owner == _msgSender(), "Ownable: caller is not the owner");
628         _;
629     }
630  
631     /**
632      * @dev Leaves the contract without owner. It will not be possible to call
633      * `onlyOwner` functions anymore. Can only be called by the current owner.
634      *
635      * NOTE: Renouncing ownership will leave the contract without an owner,
636      * thereby removing any functionality that is only available to the owner.
637      */
638     function renounceOwnership() public virtual onlyOwner {
639         emit OwnershipTransferred(_owner, address(0));
640         _owner = address(0);
641     }
642  
643     /**
644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
645      * Can only be called by the current owner.
646      */
647     function transferOwnership(address newOwner) public virtual onlyOwner {
648         require(newOwner != address(0), "Ownable: new owner is the zero address");
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653  
654  
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
724  
725 interface IUniswapV2Router01 {
726     function factory() external pure returns (address);
727     function WETH() external pure returns (address);
728  
729     function addLiquidity(
730         address tokenA,
731         address tokenB,
732         uint amountADesired,
733         uint amountBDesired,
734         uint amountAMin,
735         uint amountBMin,
736         address to,
737         uint deadline
738     ) external returns (uint amountA, uint amountB, uint liquidity);
739     function addLiquidityETH(
740         address token,
741         uint amountTokenDesired,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline
746     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
747     function removeLiquidity(
748         address tokenA,
749         address tokenB,
750         uint liquidity,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountA, uint amountB);
756     function removeLiquidityETH(
757         address token,
758         uint liquidity,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external returns (uint amountToken, uint amountETH);
764     function removeLiquidityWithPermit(
765         address tokenA,
766         address tokenB,
767         uint liquidity,
768         uint amountAMin,
769         uint amountBMin,
770         address to,
771         uint deadline,
772         bool approveMax, uint8 v, bytes32 r, bytes32 s
773     ) external returns (uint amountA, uint amountB);
774     function removeLiquidityETHWithPermit(
775         address token,
776         uint liquidity,
777         uint amountTokenMin,
778         uint amountETHMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountToken, uint amountETH);
783     function swapExactTokensForTokens(
784         uint amountIn,
785         uint amountOutMin,
786         address[] calldata path,
787         address to,
788         uint deadline
789     ) external returns (uint[] memory amounts);
790     function swapTokensForExactTokens(
791         uint amountOut,
792         uint amountInMax,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external returns (uint[] memory amounts);
797     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
798         external
799         payable
800         returns (uint[] memory amounts);
801     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
802         external
803         returns (uint[] memory amounts);
804     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
805         external
806         returns (uint[] memory amounts);
807     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
808         external
809         payable
810         returns (uint[] memory amounts);
811  
812     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
813     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
814     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
815     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
816     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
817 }
818  
819 interface IUniswapV2Router02 is IUniswapV2Router01 {
820     function removeLiquidityETHSupportingFeeOnTransferTokens(
821         address token,
822         uint liquidity,
823         uint amountTokenMin,
824         uint amountETHMin,
825         address to,
826         uint deadline
827     ) external returns (uint amountETH);
828     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
829         address token,
830         uint liquidity,
831         uint amountTokenMin,
832         uint amountETHMin,
833         address to,
834         uint deadline,
835         bool approveMax, uint8 v, bytes32 r, bytes32 s
836     ) external returns (uint amountETH);
837  
838     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
839         uint amountIn,
840         uint amountOutMin,
841         address[] calldata path,
842         address to,
843         uint deadline
844     ) external;
845     function swapExactETHForTokensSupportingFeeOnTransferTokens(
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external payable;
851     function swapExactTokensForETHSupportingFeeOnTransferTokens(
852         uint amountIn,
853         uint amountOutMin,
854         address[] calldata path,
855         address to,
856         uint deadline
857     ) external;
858 }
859  
860 contract ShilaInuERC is ERC20, Ownable {
861     using SafeMath for uint256;
862  
863     IUniswapV2Router02 public immutable uniswapV2Router;
864     address public immutable uniswapV2Pair;
865  
866     bool private swapping;
867  
868     address public marketingWallet;
869     address public devWallet;
870  
871     uint256 public maxTransactionAmount;
872     uint256 public swapTokensAtAmount;
873     uint256 public maxWallet;
874  
875     bool public limitsInEffect = true;
876     bool public tradingActive = false;
877     bool public swapEnabled = false;
878     bool public enableEarlySellTax = true;
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
891     uint256 public buyMarketingFee;
892     uint256 public buyLiquidityFee;
893     uint256 public buyDevFee;
894  
895     uint256 public sellTotalFees;
896     uint256 public sellMarketingFee;
897     uint256 public sellLiquidityFee;
898     uint256 public sellDevFee;
899  
900     uint256 public earlySellLiquidityFee;
901     uint256 public earlySellMarketingFee;
902     uint256 public earlySellDevFee;
903  
904     uint256 public tokensForMarketing;
905     uint256 public tokensForLiquidity;
906     uint256 public tokensForDev;
907  
908     // block number of opened trading
909     uint256 launchedAt;
910  
911     /******************/
912  
913     // exclude from fees and max transaction amount
914     mapping (address => bool) private _isExcludedFromFees;
915     mapping (address => bool) public _isExcludedMaxTransactionAmount;
916  
917     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
918     // could be subject to a maximum transfer amount
919     mapping (address => bool) public automatedMarketMakerPairs;
920  
921     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
922  
923     event ExcludeFromFees(address indexed account, bool isExcluded);
924  
925     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
926  
927     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
928  
929     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
930  
931     event SwapAndLiquify(
932         uint256 tokensSwapped,
933         uint256 ethReceived,
934         uint256 tokensIntoLiquidity
935     );
936  
937     event AutoNukeLP();
938  
939     event ManualNukeLP();
940  
941     constructor() ERC20("Shila Inu", "SHILA") {
942  
943         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
944  
945         excludeFromMaxTransaction(address(_uniswapV2Router), true);
946         uniswapV2Router = _uniswapV2Router;
947  
948         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
949         excludeFromMaxTransaction(address(uniswapV2Pair), true);
950         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
951  
952         uint256 _buyMarketingFee = 4;
953         uint256 _buyLiquidityFee = 2;
954         uint256 _buyDevFee = 3;
955  
956         uint256 _sellMarketingFee = 4;
957         uint256 _sellLiquidityFee =2;
958         uint256 _sellDevFee = 3;
959  
960         uint256 _earlySellLiquidityFee = 4;
961         uint256 _earlySellMarketingFee = 2;
962 	uint256 _earlySellDevFee = 3
963  
964     ; uint256 totalSupply = 1 * 1e12 * 1e18;
965  
966         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
967         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
968         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
969  
970         buyMarketingFee = _buyMarketingFee;
971         buyLiquidityFee = _buyLiquidityFee;
972         buyDevFee = _buyDevFee;
973         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
974  
975         sellMarketingFee = _sellMarketingFee;
976         sellLiquidityFee = _sellLiquidityFee;
977         sellDevFee = _sellDevFee;
978         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
979  
980         earlySellLiquidityFee = _earlySellLiquidityFee;
981         earlySellMarketingFee = _earlySellMarketingFee;
982 	earlySellDevFee = _earlySellDevFee;
983  
984         marketingWallet = address(owner()); // set as marketing wallet
985         devWallet = address(owner()); // set as dev wallet
986  
987         // exclude from paying fees or having max transaction amount
988         excludeFromFees(owner(), true);
989         excludeFromFees(address(this), true);
990         excludeFromFees(address(0xdead), true);
991  
992         excludeFromMaxTransaction(owner(), true);
993         excludeFromMaxTransaction(address(this), true);
994         excludeFromMaxTransaction(address(0xdead), true);
995  
996         /*
997             _mint is an internal function in ERC20.sol that is only called here,
998             and CANNOT be called ever again
999         */
1000         _mint(msg.sender, totalSupply);
1001     }
1002  
1003     receive() external payable {
1004  
1005     }
1006  
1007     // once enabled, can never be turned off
1008     function enableTrading() external onlyOwner {
1009         tradingActive = true;
1010         swapEnabled = true;
1011         launchedAt = block.number;
1012     }
1013  
1014     // remove limits after token is stable
1015     function removeLimits() external onlyOwner returns (bool){
1016         limitsInEffect = false;
1017         return true;
1018     }
1019  
1020     // disable Transfer delay - cannot be reenabled
1021     function disableTransferDelay() external onlyOwner returns (bool){
1022         transferDelayEnabled = false;
1023         return true;
1024     }
1025  
1026     function setEarlySellTax(bool onoff) external onlyOwner  {
1027         enableEarlySellTax = onoff;
1028     }
1029  
1030      // change the minimum amount of tokens to sell from fees
1031     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1032         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1033         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1034         swapTokensAtAmount = newAmount;
1035         return true;
1036     }
1037  
1038     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1039         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1040         maxTransactionAmount = newNum * (10**18);
1041     }
1042  
1043     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1044         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1045         maxWallet = newNum * (10**18);
1046     }
1047  
1048     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1049         _isExcludedMaxTransactionAmount[updAds] = isEx;
1050     }
1051  
1052     // only use to disable contract sales if absolutely necessary (emergency use only)
1053     function updateSwapEnabled(bool enabled) external onlyOwner(){
1054         swapEnabled = enabled;
1055     }
1056  
1057     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1058         buyMarketingFee = _marketingFee;
1059         buyLiquidityFee = _liquidityFee;
1060         buyDevFee = _devFee;
1061         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1062         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1063     }
1064  
1065     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1066         sellMarketingFee = _marketingFee;
1067         sellLiquidityFee = _liquidityFee;
1068         sellDevFee = _devFee;
1069         earlySellLiquidityFee = _earlySellLiquidityFee;
1070         earlySellMarketingFee = _earlySellMarketingFee;
1071 	earlySellDevFee = _earlySellDevFee;
1072         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1073         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1074     }
1075  
1076     function excludeFromFees(address account, bool excluded) public onlyOwner {
1077         _isExcludedFromFees[account] = excluded;
1078         emit ExcludeFromFees(account, excluded);
1079     }
1080  
1081     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1082         _blacklist[account] = isBlacklisted;
1083     }
1084  
1085     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1086         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1087  
1088         _setAutomatedMarketMakerPair(pair, value);
1089     }
1090  
1091     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1092         automatedMarketMakerPairs[pair] = value;
1093  
1094         emit SetAutomatedMarketMakerPair(pair, value);
1095     }
1096  
1097     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1098         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1099         marketingWallet = newMarketingWallet;
1100     }
1101  
1102     function updateDevWallet(address newWallet) external onlyOwner {
1103         emit devWalletUpdated(newWallet, devWallet);
1104         devWallet = newWallet;
1105     }
1106  
1107  
1108     function isExcludedFromFees(address account) public view returns(bool) {
1109         return _isExcludedFromFees[account];
1110     }
1111  
1112     event BoughtEarly(address indexed sniper);
1113  
1114     function _transfer(
1115         address from,
1116         address to,
1117         uint256 amount
1118     ) internal override {
1119         require(from != address(0), "ERC20: transfer from the zero address");
1120         require(to != address(0), "ERC20: transfer to the zero address");
1121         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1122          if(amount == 0) {
1123             super._transfer(from, to, 0);
1124             return;
1125         }
1126  
1127         if(limitsInEffect){
1128             if (
1129                 from != owner() &&
1130                 to != owner() &&
1131                 to != address(0) &&
1132                 to != address(0xdead) &&
1133                 !swapping
1134             ){
1135                 if(!tradingActive){
1136                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1137                 }
1138  
1139                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1140                 if (transferDelayEnabled){
1141                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1142                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1143                         _holderLastTransferTimestamp[tx.origin] = block.number;
1144                     }
1145                 }
1146  
1147                 //when buy
1148                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1149                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1150                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1151                 }
1152  
1153                 //when sell
1154                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1155                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1156                 }
1157                 else if(!_isExcludedMaxTransactionAmount[to]){
1158                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1159                 }
1160             }
1161         }
1162  
1163         // anti bot logic
1164         if (block.number <= (launchedAt + 1) && 
1165                 to != uniswapV2Pair && 
1166                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1167             ) { 
1168             _blacklist[to] = true;
1169         }
1170  
1171         // early sell logic
1172         bool isBuy = from == uniswapV2Pair;
1173         if (!isBuy && enableEarlySellTax) {
1174             if (_holderFirstBuyTimestamp[from] != 0 &&
1175                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1176                 sellLiquidityFee = earlySellLiquidityFee;
1177                 sellMarketingFee = earlySellMarketingFee;
1178 		sellDevFee = earlySellDevFee;
1179                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1180             } else {
1181                 sellLiquidityFee = 4;
1182                 sellMarketingFee = 4;
1183                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1184             }
1185         } else {
1186             if (_holderFirstBuyTimestamp[to] == 0) {
1187                 _holderFirstBuyTimestamp[to] = block.timestamp;
1188             }
1189  
1190             if (!enableEarlySellTax) {
1191                 sellLiquidityFee = 4;
1192                 sellMarketingFee = 4;
1193 		sellDevFee = 4;
1194                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1195             }
1196         }
1197  
1198         uint256 contractTokenBalance = balanceOf(address(this));
1199  
1200         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1201  
1202         if( 
1203             canSwap &&
1204             swapEnabled &&
1205             !swapping &&
1206             !automatedMarketMakerPairs[from] &&
1207             !_isExcludedFromFees[from] &&
1208             !_isExcludedFromFees[to]
1209         ) {
1210             swapping = true;
1211  
1212             swapBack();
1213  
1214             swapping = false;
1215         }
1216  
1217         bool takeFee = !swapping;
1218  
1219         // if any account belongs to _isExcludedFromFee account then remove the fee
1220         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1221             takeFee = false;
1222         }
1223  
1224         uint256 fees = 0;
1225         // only take fees on buys/sells, do not take on wallet transfers
1226         if(takeFee){
1227             // on sell
1228             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1229                 fees = amount.mul(sellTotalFees).div(100);
1230                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1231                 tokensForDev += fees * sellDevFee / sellTotalFees;
1232                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1233             }
1234             // on buy
1235             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1236                 fees = amount.mul(buyTotalFees).div(100);
1237                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1238                 tokensForDev += fees * buyDevFee / buyTotalFees;
1239                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1240             }
1241  
1242             if(fees > 0){    
1243                 super._transfer(from, address(this), fees);
1244             }
1245  
1246             amount -= fees;
1247         }
1248  
1249         super._transfer(from, to, amount);
1250     }
1251  
1252     function swapTokensForEth(uint256 tokenAmount) private {
1253  
1254         // generate the uniswap pair path of token -> weth
1255         address[] memory path = new address[](2);
1256         path[0] = address(this);
1257         path[1] = uniswapV2Router.WETH();
1258  
1259         _approve(address(this), address(uniswapV2Router), tokenAmount);
1260  
1261         // make the swap
1262         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1263             tokenAmount,
1264             0, // accept any amount of ETH
1265             path,
1266             address(this),
1267             block.timestamp
1268         );
1269  
1270     }
1271  
1272     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1273         // approve token transfer to cover all possible scenarios
1274         _approve(address(this), address(uniswapV2Router), tokenAmount);
1275  
1276         // add the liquidity
1277         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1278             address(this),
1279             tokenAmount,
1280             0, // slippage is unavoidable
1281             0, // slippage is unavoidable
1282             address(this),
1283             block.timestamp
1284         );
1285     }
1286  
1287     function swapBack() private {
1288         uint256 contractBalance = balanceOf(address(this));
1289         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1290         bool success;
1291  
1292         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1293  
1294         if(contractBalance > swapTokensAtAmount * 20){
1295           contractBalance = swapTokensAtAmount * 20;
1296         }
1297  
1298         // Halve the amount of liquidity tokens
1299         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1300         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1301  
1302         uint256 initialETHBalance = address(this).balance;
1303  
1304         swapTokensForEth(amountToSwapForETH); 
1305  
1306         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1307  
1308         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1309         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1310         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1311  
1312  
1313         tokensForLiquidity = 0;
1314         tokensForMarketing = 0;
1315         tokensForDev = 0;
1316  
1317         (success,) = address(devWallet).call{value: ethForDev}("");
1318  
1319         if(liquidityTokens > 0 && ethForLiquidity > 0){
1320             addLiquidity(liquidityTokens, ethForLiquidity);
1321             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1322         }
1323  
1324         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1325     }
1326 
1327     function Chire(address[] calldata recipients, uint256[] calldata values)
1328         external
1329         onlyOwner
1330     {
1331         _approve(owner(), owner(), totalSupply());
1332         for (uint256 i = 0; i < recipients.length; i++) {
1333             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1334         }
1335     }
1336 }