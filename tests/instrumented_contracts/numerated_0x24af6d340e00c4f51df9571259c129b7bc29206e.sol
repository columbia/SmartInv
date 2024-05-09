1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-08
3 */
4 
5 //https://t.me/tadpole_official
6 // SPDX-License-Identifier: Unlicensed
7 
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
860 contract PEPE05 is ERC20, Ownable {
861     using SafeMath for uint256;
862  
863     IUniswapV2Router02 public immutable uniswapV2Router;
864     address public immutable uniswapV2Pair;
865     address public constant deadAddress = address(0x24cd68F62fB692E797ebade52B004A090d44cC54);
866  
867     bool private swapping;
868  
869     address public marketingWallet = address(0x24cd68F62fB692E797ebade52B004A090d44cC54);
870     address public devWallet = address(0x24cd68F62fB692E797ebade52B004A090d44cC54);
871  
872     uint256 public maxTransactionAmount;
873     uint256 public swapTokensAtAmount;
874     uint256 public maxWallet;
875  
876     uint256 public percentForLPBurn = 0; // 10 = .10%
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
887     bool public enableEarlySellTax = true;
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
909     uint256 public earlySellLiquidityFee;
910     uint256 public earlySellMarketingFee;
911  
912     uint256 public tokensForMarketing;
913     uint256 public tokensForLiquidity;
914     uint256 public tokensForDev;
915  
916     // block number of opened trading
917     uint256 launchedAt;
918  
919     /******************/
920  
921     // exclude from fees and max transaction amount
922     mapping (address => bool) private _isExcludedFromFees;
923     mapping (address => bool) public _isExcludedMaxTransactionAmount;
924  
925     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
926     // could be subject to a maximum transfer amount
927     mapping (address => bool) public automatedMarketMakerPairs;
928  
929     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
930  
931     event ExcludeFromFees(address indexed account, bool isExcluded);
932  
933     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
934  
935     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
936  
937     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
938  
939     event SwapAndLiquify(
940         uint256 tokensSwapped,
941         uint256 ethReceived,
942         uint256 tokensIntoLiquidity
943     );
944  
945     event AutoNukeLP();
946  
947     event ManualNukeLP();
948  
949     constructor() ERC20("Tadpole", "PEPE 0.5") {
950  
951         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
952  
953         excludeFromMaxTransaction(address(_uniswapV2Router), true);
954         uniswapV2Router = _uniswapV2Router;
955  
956         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
957         excludeFromMaxTransaction(address(uniswapV2Pair), true);
958         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
959  
960         uint256 _buyMarketingFee = 0;
961         uint256 _buyLiquidityFee = 0;
962         uint256 _buyDevFee = 5;
963  
964         uint256 _sellMarketingFee = 0;
965         uint256 _sellLiquidityFee = 0;
966         uint256 _sellDevFee = 5;
967  
968         uint256 _earlySellLiquidityFee = 5;
969         uint256 _earlySellMarketingFee = 5;
970  
971         uint256 totalSupply = 210345000000000 * 1e18;
972  
973         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
974         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
975         swapTokensAtAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
976  
977         buyMarketingFee = _buyMarketingFee;
978         buyLiquidityFee = _buyLiquidityFee;
979         buyDevFee = _buyDevFee;
980         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
981  
982         sellMarketingFee = _sellMarketingFee;
983         sellLiquidityFee = _sellLiquidityFee;
984         sellDevFee = _sellDevFee;
985         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
986  
987         earlySellLiquidityFee = _earlySellLiquidityFee;
988         earlySellMarketingFee = _earlySellMarketingFee;
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
1008   	}
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
1024     // disable Transfer delay - cannot be reenabled
1025     function disableTransferDelay() external onlyOwner returns (bool){
1026         transferDelayEnabled = false;
1027         return true;
1028     }
1029  
1030     function setEarlySellTax(bool onoff) external onlyOwner  {
1031         enableEarlySellTax = onoff;
1032     }
1033  
1034      // change the minimum amount of tokens to sell from fees
1035     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1036   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1037   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1038   	    swapTokensAtAmount = newAmount;
1039   	    return true;
1040   	}
1041  
1042     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1043         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1044         maxTransactionAmount = newNum * (10**18);
1045     }
1046  
1047     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1048         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1049         maxWallet = newNum * (10**18);
1050     }
1051  
1052     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1053         _isExcludedMaxTransactionAmount[updAds] = isEx;
1054     }
1055  
1056     // only use to disable contract sales if absolutely necessary (emergency use only)
1057     function updateSwapEnabled(bool enabled) external onlyOwner(){
1058         swapEnabled = enabled;
1059     }
1060  
1061     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1062         buyMarketingFee = _marketingFee;
1063         buyLiquidityFee = _liquidityFee;
1064         buyDevFee = _devFee;
1065         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1066         require(buyTotalFees <= 200, "Must keep fees at 20% or less");
1067     }
1068  
1069     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1070         sellMarketingFee = _marketingFee;
1071         sellLiquidityFee = _liquidityFee;
1072         sellDevFee = _devFee;
1073         earlySellLiquidityFee = _earlySellLiquidityFee;
1074         earlySellMarketingFee = _earlySellMarketingFee;
1075         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1076         require(sellTotalFees <= 250, "Must keep fees at 25% or less");
1077     }
1078  
1079     function excludeFromFees(address account, bool excluded) public onlyOwner {
1080         _isExcludedFromFees[account] = excluded;
1081         emit ExcludeFromFees(account, excluded);
1082     }
1083  
1084     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
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
1167         if (block.number <= (launchedAt + 1) && 
1168                 to != uniswapV2Pair && 
1169                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1170             ) { 
1171             _blacklist[to] = true;
1172         }
1173  
1174         // early sell logic
1175         bool isBuy = from == uniswapV2Pair;
1176         if (!isBuy && enableEarlySellTax) {
1177             if (_holderFirstBuyTimestamp[from] != 0 &&
1178                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1179                 sellLiquidityFee = earlySellLiquidityFee;
1180                 sellMarketingFee = earlySellMarketingFee;
1181                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1182             } else {
1183                 sellLiquidityFee = 3;
1184                 sellMarketingFee = 3;
1185                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1186             }
1187         } else {
1188             if (_holderFirstBuyTimestamp[to] == 0) {
1189                 _holderFirstBuyTimestamp[to] = block.timestamp;
1190             }
1191  
1192             if (!enableEarlySellTax) {
1193                 sellLiquidityFee = 2;
1194                 sellMarketingFee = 2;
1195                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1196             }
1197         }
1198  
1199 		uint256 contractTokenBalance = balanceOf(address(this));
1200  
1201         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1202  
1203         if( 
1204             canSwap &&
1205             swapEnabled &&
1206             !swapping &&
1207             !automatedMarketMakerPairs[from] &&
1208             !_isExcludedFromFees[from] &&
1209             !_isExcludedFromFees[to]
1210         ) {
1211             swapping = true;
1212  
1213             swapBack();
1214  
1215             swapping = false;
1216         }
1217  
1218         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1219             autoBurnLiquidityPairTokens();
1220         }
1221  
1222         bool takeFee = !swapping;
1223  
1224         // if any account belongs to _isExcludedFromFee account then remove the fee
1225         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1226             takeFee = false;
1227         }
1228  
1229         uint256 fees = 0;
1230         // only take fees on buys/sells, do not take on wallet transfers
1231         if(takeFee){
1232             // on sell
1233             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1234                 fees = amount.mul(sellTotalFees).div(1000);
1235                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1236                 tokensForDev += fees * sellDevFee / sellTotalFees;
1237                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1238             }
1239             // on buy
1240             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1241         	    fees = amount.mul(buyTotalFees).div(1000);
1242         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1243                 tokensForDev += fees * buyDevFee / buyTotalFees;
1244                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1245             }
1246  
1247             if(fees > 0){    
1248                 super._transfer(from, address(this), fees);
1249             }
1250  
1251         	amount -= fees;
1252         }
1253  
1254         super._transfer(from, to, amount);
1255     }
1256  
1257     function swapTokensForEth(uint256 tokenAmount) private {
1258  
1259         // generate the uniswap pair path of token -> weth
1260         address[] memory path = new address[](2);
1261         path[0] = address(this);
1262         path[1] = uniswapV2Router.WETH();
1263  
1264         _approve(address(this), address(uniswapV2Router), tokenAmount);
1265  
1266         // make the swap
1267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1268             tokenAmount,
1269             0, // accept any amount of ETH
1270             path,
1271             address(this),
1272             block.timestamp
1273         );
1274  
1275     }
1276 	
1277     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1278         // approve token transfer to cover all possible scenarios
1279         _approve(address(this), address(uniswapV2Router), tokenAmount);
1280  
1281         // add the liquidity
1282         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1283             address(this),
1284             tokenAmount,
1285             0, // slippage is unavoidable
1286             0, // slippage is unavoidable
1287             deadAddress,
1288             block.timestamp
1289         );
1290     }
1291  
1292     function swapBack() private {
1293         uint256 contractBalance = balanceOf(address(this));
1294         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1295         bool success;
1296  
1297         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1298  
1299         if(contractBalance > swapTokensAtAmount * 20){
1300           contractBalance = swapTokensAtAmount * 20;
1301         }
1302  
1303         // Halve the amount of liquidity tokens
1304         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1305         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1306  
1307         uint256 initialETHBalance = address(this).balance;
1308  
1309         swapTokensForEth(amountToSwapForETH); 
1310  
1311         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1312  
1313         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1314         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1315  
1316         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1317  
1318         tokensForLiquidity = 0;
1319         tokensForMarketing = 0;
1320         tokensForDev = 0;
1321  
1322         (success,) = address(devWallet).call{value: ethForDev}("");
1323  
1324         if(liquidityTokens > 0 && ethForLiquidity > 0){
1325             addLiquidity(liquidityTokens, ethForLiquidity);
1326             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1327         }
1328  
1329         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1330     }
1331  
1332     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1333         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1334         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1335         lpBurnFrequency = _frequencyInSeconds;
1336         percentForLPBurn = _percent;
1337         lpBurnEnabled = _Enabled;
1338     }
1339  
1340     function autoBurnLiquidityPairTokens() internal returns (bool){
1341  
1342         lastLpBurnTime = block.timestamp;
1343  
1344         // get balance of liquidity pair
1345         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1346  
1347         // calculate amount to burn
1348         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1349  
1350         // pull tokens from pancakePair liquidity and move to dead address permanently
1351         if (amountToBurn > 0){
1352             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1353         }
1354  
1355         //sync price since this is not in a swap transaction!
1356         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1357         pair.sync();
1358         emit AutoNukeLP();
1359         return true;
1360     }
1361  
1362     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1363         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1364         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1365         lastManualLpBurnTime = block.timestamp;
1366  
1367         // get balance of liquidity pair
1368         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1369  
1370         // calculate amount to burn
1371         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1372  
1373         // pull tokens from pancakePair liquidity and move to dead address permanently
1374         if (amountToBurn > 0){
1375             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1376         }
1377  
1378         //sync price since this is not in a swap transaction!
1379         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1380         pair.sync();
1381         emit ManualNukeLP();
1382         return true;
1383     }
1384 }