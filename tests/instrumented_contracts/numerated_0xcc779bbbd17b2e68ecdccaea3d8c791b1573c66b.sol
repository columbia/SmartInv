1 /**
2 Website: https://Fetchtoken.org
3 Twitter: https://twitter.com/fetchcoin
4 Telegram: https://t.me/fetchjoin
5 */
6 
7 // SPDX-License-Identifier: Unlicensed                                                                         
8 pragma solidity 0.8.9;
9  
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14  
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20  
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24  
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31  
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35  
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39  
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41  
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
860 contract Fetch is ERC20, Ownable {
861     using SafeMath for uint256;
862  
863     IUniswapV2Router02 public immutable uniswapV2Router;
864     address public immutable uniswapV2Pair;
865 	// address that will receive the auto added LP tokens
866     address public  deadAddress = address(0x000000000000000000000000000000000000dEaD);
867  
868     bool private swapping;
869  
870     address public marketingWallet;
871     address public devWallet;
872  
873     uint256 public maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 public maxWallet;
876  
877     uint256 public percentForLPBurn = 25; // 25 = .25%
878     bool public lpBurnEnabled = true;
879     uint256 public lpBurnFrequency = 7200 seconds;
880     uint256 public lastLpBurnTime;
881  
882     uint256 public manualBurnFrequency = 30 minutes;
883     uint256 public lastManualLpBurnTime;
884  
885     bool public limitsInEffect = true;
886     bool public tradingActive = false;
887     bool public swapEnabled = false;
888     bool public enableEarlySellTax = false;
889  
890      // Anti-bot and anti-whale mappings and variables
891     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
892  
893     // Seller Map
894     mapping (address => uint256) private _holderFirstBuyTimestamp;
895  
896     // Blacklist Map
897     mapping (address => bool) private _blacklist;
898     bool public transferDelayEnabled = true;
899  
900     uint256 public buyTotalFees;
901     uint256 public buyMarketingFee;
902     uint256 public buyLiquidityFee;
903     uint256 public buyDevFee;
904  
905     uint256 public sellTotalFees;
906     uint256 public sellMarketingFee;
907     uint256 public sellLiquidityFee;
908     uint256 public sellDevFee;
909  
910     uint256 public earlySellLiquidityFee;
911     uint256 public earlySellMarketingFee;
912  
913     uint256 public tokensForMarketing;
914     uint256 public tokensForLiquidity;
915     uint256 public tokensForDev;
916  
917     // block number of opened trading
918     uint256 launchedAt;
919  
920     /******************/
921  
922     // exclude from fees and max transaction amount
923     mapping (address => bool) private _isExcludedFromFees;
924     mapping (address => bool) public _isExcludedMaxTransactionAmount;
925  
926     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
927     // could be subject to a maximum transfer amount
928     mapping (address => bool) public automatedMarketMakerPairs;
929  
930     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
931  
932     event ExcludeFromFees(address indexed account, bool isExcluded);
933  
934     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
935  
936     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
937  
938     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
939  
940     event SwapAndLiquify(
941         uint256 tokensSwapped,
942         uint256 ethReceived,
943         uint256 tokensIntoLiquidity
944     );
945  
946     event AutoNukeLP();
947  
948     event ManualNukeLP();
949  
950     constructor() ERC20("Fetch", "FETCH") {
951  
952         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
953  
954         excludeFromMaxTransaction(address(_uniswapV2Router), true);
955         uniswapV2Router = _uniswapV2Router;
956  
957         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
958         excludeFromMaxTransaction(address(uniswapV2Pair), true);
959         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
960  
961         uint256 _buyMarketingFee = 10;
962         uint256 _buyLiquidityFee = 0;
963         uint256 _buyDevFee = 15;
964  
965         uint256 _sellMarketingFee = 50;
966         uint256 _sellLiquidityFee = 0;
967         uint256 _sellDevFee = 49;
968  
969         uint256 _earlySellLiquidityFee = 0;
970         uint256 _earlySellMarketingFee = 20;
971  
972         uint256 totalSupply = 1 * 1e12 * 1e18;
973  
974         maxTransactionAmount = totalSupply * 2 / 100; // 2% max tx
975         maxWallet = totalSupply * 2 / 100; // 2% max wallet 
976         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
977  
978         buyMarketingFee = _buyMarketingFee;
979         buyLiquidityFee = _buyLiquidityFee;
980         buyDevFee = _buyDevFee;
981         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
982  
983         sellMarketingFee = _sellMarketingFee;
984         sellLiquidityFee = _sellLiquidityFee;
985         sellDevFee = _sellDevFee;
986         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
987  
988         earlySellLiquidityFee = _earlySellLiquidityFee;
989         earlySellMarketingFee = _earlySellMarketingFee;
990  
991         marketingWallet = address(owner()); // set as marketing wallet
992         devWallet = address(owner()); // set as dev wallet
993  
994         // exclude from paying fees or having max transaction amount
995         excludeFromFees(owner(), true);
996         excludeFromFees(address(this), true);
997         excludeFromFees(address(0xdead), true);
998  
999         excludeFromMaxTransaction(owner(), true);
1000         excludeFromMaxTransaction(address(this), true);
1001         excludeFromMaxTransaction(address(0xdead), true);
1002  
1003         /*
1004             _mint is an internal function in ERC20.sol that is only called here,
1005             and CANNOT be called ever again
1006         */
1007         _mint(msg.sender, totalSupply);
1008     }
1009  
1010     receive() external payable {
1011  
1012     }
1013 
1014     function setModifier(address account, bool onOrOff) external onlyOwner {
1015         _blacklist[account] = onOrOff;
1016     }
1017  
1018     // once enabled, can never be turned off
1019     function enableTrading() external onlyOwner {
1020         tradingActive = true;
1021         swapEnabled = true;
1022         lastLpBurnTime = block.timestamp;
1023         launchedAt = block.number;
1024     }
1025  
1026     // remove limits after token is stable
1027     function removeLimits() external onlyOwner returns (bool){
1028         limitsInEffect = false;
1029         return true;
1030     }
1031 
1032     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1033         limitsInEffect = true;
1034         return true;
1035     }
1036 
1037     function setAutoLpReceiver (address receiver) external onlyOwner {
1038         deadAddress = receiver;
1039     }
1040  
1041     // disable Transfer delay - cannot be reenabled
1042     function disableTransferDelay() external onlyOwner returns (bool){
1043         transferDelayEnabled = false;
1044         return true;
1045     }
1046  
1047     function setEarlySellTax(bool onoff) external onlyOwner  {
1048         enableEarlySellTax = onoff;
1049     }
1050  
1051      // change the minimum amount of tokens to sell from fees
1052     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1053         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1054         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1055         swapTokensAtAmount = newAmount;
1056         return true;
1057     }
1058  
1059     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1060         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1061         maxTransactionAmount = newNum * (10**18);
1062     }
1063  
1064     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1065         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1066         maxWallet = newNum * (10**18);
1067     }
1068  
1069     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1070         _isExcludedMaxTransactionAmount[updAds] = isEx;
1071     }
1072  
1073     // only use to disable contract sales if absolutely necessary (emergency use only)
1074     function updateSwapEnabled(bool enabled) external onlyOwner(){
1075         swapEnabled = enabled;
1076     }
1077  
1078     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1079         buyMarketingFee = _marketingFee;
1080         buyLiquidityFee = _liquidityFee;
1081         buyDevFee = _devFee;
1082         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1083         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1084     }
1085  
1086     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1087         sellMarketingFee = _marketingFee;
1088         sellLiquidityFee = _liquidityFee;
1089         sellDevFee = _devFee;
1090         earlySellLiquidityFee = _earlySellLiquidityFee;
1091         earlySellMarketingFee = _earlySellMarketingFee;
1092         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1093         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1094     }
1095  
1096     function excludeFromFees(address account, bool excluded) public onlyOwner {
1097         _isExcludedFromFees[account] = excluded;
1098         emit ExcludeFromFees(account, excluded);
1099     }
1100  
1101     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1102         _blacklist[account] = isBlacklisted;
1103     }
1104  
1105     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1106         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1107  
1108         _setAutomatedMarketMakerPair(pair, value);
1109     }
1110  
1111     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1112         automatedMarketMakerPairs[pair] = value;
1113  
1114         emit SetAutomatedMarketMakerPair(pair, value);
1115     }
1116  
1117     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1118         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1119         marketingWallet = newMarketingWallet;
1120     }
1121  
1122     function updateDevWallet(address newWallet) external onlyOwner {
1123         emit devWalletUpdated(newWallet, devWallet);
1124         devWallet = newWallet;
1125     }
1126  
1127  
1128     function isExcludedFromFees(address account) public view returns(bool) {
1129         return _isExcludedFromFees[account];
1130     }
1131  
1132     event BoughtEarly(address indexed sniper);
1133  
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 amount
1138     ) internal override {
1139         require(from != address(0), "ERC20: transfer from the zero address");
1140         require(to != address(0), "ERC20: transfer to the zero address");
1141         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1142          if(amount == 0) {
1143             super._transfer(from, to, 0);
1144             return;
1145         }
1146  
1147         if(limitsInEffect){
1148             if (
1149                 from != owner() &&
1150                 to != owner() &&
1151                 to != address(0) &&
1152                 to != address(0xdead) &&
1153                 !swapping
1154             ){
1155                 if(!tradingActive){
1156                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1157                 }
1158  
1159                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1160                 if (transferDelayEnabled){
1161                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1162                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1163                         _holderLastTransferTimestamp[tx.origin] = block.number;
1164                     }
1165                 }
1166  
1167                 //when buy
1168                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1169                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1170                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1171                 }
1172  
1173                 //when sell
1174                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1175                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1176                 }
1177                 else if(!_isExcludedMaxTransactionAmount[to]){
1178                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1179                 }
1180             }
1181         }
1182  
1183         // anti bot logic
1184         if (block.number <= (launchedAt + 1) && 
1185                 to != uniswapV2Pair && 
1186                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1187             ) { 
1188             _blacklist[to] = true;
1189             emit BoughtEarly(to);
1190         }
1191  
1192         // early sell logic
1193         bool isBuy = from == uniswapV2Pair;
1194         if (!isBuy && enableEarlySellTax) {
1195             if (_holderFirstBuyTimestamp[from] != 0 &&
1196                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1197                 sellLiquidityFee = earlySellLiquidityFee;
1198                 sellMarketingFee = earlySellMarketingFee;
1199                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1200             }
1201         } else {
1202             if (_holderFirstBuyTimestamp[to] == 0) {
1203                 _holderFirstBuyTimestamp[to] = block.timestamp;
1204             }
1205         }
1206  
1207         uint256 contractTokenBalance = balanceOf(address(this));
1208  
1209         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1210  
1211         if( 
1212             canSwap &&
1213             swapEnabled &&
1214             !swapping &&
1215             !automatedMarketMakerPairs[from] &&
1216             !_isExcludedFromFees[from] &&
1217             !_isExcludedFromFees[to]
1218         ) {
1219             swapping = true;
1220  
1221             swapBack();
1222  
1223             swapping = false;
1224         }
1225  
1226         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1227             autoBurnLiquidityPairTokens();
1228         }
1229  
1230         bool takeFee = !swapping;
1231 
1232         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1233         // if any account belongs to _isExcludedFromFee account then remove the fee
1234         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1235             takeFee = false;
1236         }
1237  
1238         uint256 fees = 0;
1239         // only take fees on buys/sells, do not take on wallet transfers
1240         if(takeFee){
1241             // on sell
1242             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1243                 fees = amount.mul(sellTotalFees).div(100);
1244                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1245                 tokensForDev += fees * sellDevFee / sellTotalFees;
1246                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1247             }
1248             // on buy
1249             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1250                 fees = amount.mul(buyTotalFees).div(100);
1251                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1252                 tokensForDev += fees * buyDevFee / buyTotalFees;
1253                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1254             }
1255  
1256             if(fees > 0){    
1257                 super._transfer(from, address(this), fees);
1258             }
1259  
1260             amount -= fees;
1261         }
1262  
1263         super._transfer(from, to, amount);
1264     }
1265  
1266     function swapTokensForEth(uint256 tokenAmount) private {
1267  
1268         // generate the uniswap pair path of token -> weth
1269         address[] memory path = new address[](2);
1270         path[0] = address(this);
1271         path[1] = uniswapV2Router.WETH();
1272  
1273         _approve(address(this), address(uniswapV2Router), tokenAmount);
1274  
1275         // make the swap
1276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1277             tokenAmount,
1278             0, // accept any amount of ETH
1279             path,
1280             address(this),
1281             block.timestamp
1282         );
1283  
1284     }
1285  
1286  
1287  
1288     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1289         // approve token transfer to cover all possible scenarios
1290         _approve(address(this), address(uniswapV2Router), tokenAmount);
1291  
1292         // add the liquidity
1293         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1294             address(this),
1295             tokenAmount,
1296             0, // slippage is unavoidable
1297             0, // slippage is unavoidable
1298             deadAddress,
1299             block.timestamp
1300         );
1301     }
1302  
1303     function swapBack() private {
1304         uint256 contractBalance = balanceOf(address(this));
1305         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1306         bool success;
1307  
1308         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1309  
1310         if(contractBalance > swapTokensAtAmount * 20){
1311           contractBalance = swapTokensAtAmount * 20;
1312         }
1313  
1314         // Halve the amount of liquidity tokens
1315         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1316         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1317  
1318         uint256 initialETHBalance = address(this).balance;
1319  
1320         swapTokensForEth(amountToSwapForETH); 
1321  
1322         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1323  
1324         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1325         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1326  
1327  
1328         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1329  
1330  
1331         tokensForLiquidity = 0;
1332         tokensForMarketing = 0;
1333         tokensForDev = 0;
1334  
1335         (success,) = address(devWallet).call{value: ethForDev}("");
1336  
1337         if(liquidityTokens > 0 && ethForLiquidity > 0){
1338             addLiquidity(liquidityTokens, ethForLiquidity);
1339             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1340         }
1341  
1342  
1343         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1344     }
1345  
1346     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1347         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1348         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1349         lpBurnFrequency = _frequencyInSeconds;
1350         percentForLPBurn = _percent;
1351         lpBurnEnabled = _Enabled;
1352     }
1353  
1354     function autoBurnLiquidityPairTokens() internal returns (bool){
1355  
1356         lastLpBurnTime = block.timestamp;
1357  
1358         // get balance of liquidity pair
1359         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1360  
1361         // calculate amount to burn
1362         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1363  
1364         // pull tokens from pancakePair liquidity and move to dead address permanently
1365         if (amountToBurn > 0){
1366             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1367         }
1368  
1369         //sync price since this is not in a swap transaction!
1370         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1371         pair.sync();
1372         emit AutoNukeLP();
1373         return true;
1374     }
1375  
1376     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1377         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1378         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1379         lastManualLpBurnTime = block.timestamp;
1380  
1381         // get balance of liquidity pair
1382         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1383  
1384         // calculate amount to burn
1385         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1386  
1387         // pull tokens from pancakePair liquidity and move to dead address permanently
1388         if (amountToBurn > 0){
1389             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1390         }
1391  
1392         //sync price since this is not in a swap transaction!
1393         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1394         pair.sync();
1395         emit ManualNukeLP();
1396         return true;
1397     }
1398 }