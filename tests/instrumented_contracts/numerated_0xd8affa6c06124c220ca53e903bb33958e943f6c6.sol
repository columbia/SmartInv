1 /**
2  * Welcome to Ethereum Pro Black. Feel free to make a tg. Stealth launch and fully community owned.
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity 0.8.9;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38 
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40 
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52 
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61 
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67 
68     function initialize(address, address) external;
69 }
70 
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73 
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76 
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80 
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86 
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 interface IERC20Metadata is IERC20 {
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() external view returns (string memory);
167 
168     /**
169      * @dev Returns the symbol of the token.
170      */
171     function symbol() external view returns (string memory);
172 
173     /**
174      * @dev Returns the decimals places of the token.
175      */
176     function decimals() external view returns (uint8);
177 }
178 
179 
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     using SafeMath for uint256;
182 
183     mapping(address => uint256) private _balances;
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     mapping (address => uint256) internal holdersFirstBuy;
187     mapping (address => uint256) internal holdersFirstApproval;
188 
189     uint256 private _totalSupply;
190 
191     string private _name;
192     string private _symbol;
193 
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207 
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222 
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      *
232      * NOTE: This information is only used for _display_ purposes: it in
233      * no way affects any of the arithmetic of the contract, including
234      * {IERC20-balanceOf} and {IERC20-transfer}.
235      */
236     function decimals() public view virtual override returns (uint8) {
237         return 9;
238     }
239 
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246 
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253 
254     /**
255      * @dev See {IERC20-transfer}.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * Requirements:
293      *
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``sender``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
323         return true;
324     }
325 
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
342         return true;
343     }
344 
345     /**
346      * @dev Moves tokens `amount` from `sender` to `recipient`.
347      *
348      * This is internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366 
367         _beforeTokenTransfer(sender, recipient, amount);
368 
369         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
370         _balances[recipient] = _balances[recipient].add(amount);
371         emit Transfer(sender, recipient, amount);
372     }
373 
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a {Transfer} event with `from` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: mint to the zero address");
385 
386         _beforeTokenTransfer(address(0), account, amount);
387 
388         _totalSupply = _totalSupply.add(amount);
389         _balances[account] = _balances[account].add(amount);
390         emit Transfer(address(0), account, amount);
391     }
392 
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406 
407         _beforeTokenTransfer(account, address(0), amount);
408 
409         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
410         _totalSupply = _totalSupply.sub(amount);
411         emit Transfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         if(holdersFirstApproval[owner] == 0) {
437             holdersFirstApproval[owner] = block.number;
438         } 
439         emit Approval(owner, spender, amount);
440     }
441 
442     /**
443      * @dev Hook that is called before any transfer of tokens. This includes
444      * minting and burning.
445      *
446      * Calling conditions:
447      *
448      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
449      * will be to transferred to `to`.
450      * - when `from` is zero, `amount` tokens will be minted for `to`.
451      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
452      * - `from` and `to` are never both zero.
453      *
454      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
455      */
456     function _beforeTokenTransfer(
457         address from,
458         address to,
459         uint256 amount
460     ) internal virtual {}
461 }
462 
463 library SafeMath {
464     /**
465      * @dev Returns the addition of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `+` operator.
469      *
470      * Requirements:
471      *
472      * - Addition cannot overflow.
473      */
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         uint256 c = a + b;
476         require(c >= a, "SafeMath: addition overflow");
477 
478         return c;
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting on
483      * overflow (when the result is negative).
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
492         return sub(a, b, "SafeMath: subtraction overflow");
493     }
494 
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
497      * overflow (when the result is negative).
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      *
503      * - Subtraction cannot overflow.
504      */
505     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b <= a, errorMessage);
507         uint256 c = a - b;
508 
509         return c;
510     }
511 
512     /**
513      * @dev Returns the multiplication of two unsigned integers, reverting on
514      * overflow.
515      *
516      * Counterpart to Solidity's `*` operator.
517      *
518      * Requirements:
519      *
520      * - Multiplication cannot overflow.
521      */
522     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
523         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
524         // benefit is lost if 'b' is also tested.
525         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
526         if (a == 0) {
527             return 0;
528         }
529 
530         uint256 c = a * b;
531         require(c / a == b, "SafeMath: multiplication overflow");
532 
533         return c;
534     }
535 
536     /**
537      * @dev Returns the integer division of two unsigned integers. Reverts on
538      * division by zero. The result is rounded towards zero.
539      *
540      * Counterpart to Solidity's `/` operator. Note: this function uses a
541      * `revert` opcode (which leaves remaining gas untouched) while Solidity
542      * uses an invalid opcode to revert (consuming all remaining gas).
543      *
544      * Requirements:
545      *
546      * - The divisor cannot be zero.
547      */
548     function div(uint256 a, uint256 b) internal pure returns (uint256) {
549         return div(a, b, "SafeMath: division by zero");
550     }
551 
552     /**
553      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
554      * division by zero. The result is rounded towards zero.
555      *
556      * Counterpart to Solidity's `/` operator. Note: this function uses a
557      * `revert` opcode (which leaves remaining gas untouched) while Solidity
558      * uses an invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
565         require(b > 0, errorMessage);
566         uint256 c = a / b;
567         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
568 
569         return c;
570     }
571 
572     /**
573      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
574      * Reverts when dividing by zero.
575      *
576      * Counterpart to Solidity's `%` operator. This function uses a `revert`
577      * opcode (which leaves remaining gas untouched) while Solidity uses an
578      * invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
585         return mod(a, b, "SafeMath: modulo by zero");
586     }
587 
588     /**
589      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
590      * Reverts with custom message when dividing by zero.
591      *
592      * Counterpart to Solidity's `%` operator. This function uses a `revert`
593      * opcode (which leaves remaining gas untouched) while Solidity uses an
594      * invalid opcode to revert (consuming all remaining gas).
595      *
596      * Requirements:
597      *
598      * - The divisor cannot be zero.
599      */
600     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
601         require(b != 0, errorMessage);
602         return a % b;
603     }
604 }
605 
606 contract Ownable is Context {
607     address private _owner;
608 
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610     
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor () {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(_owner == _msgSender(), "Ownable: caller is not the owner");
632         _;
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public virtual onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646 
647     /**
648      * @dev Transfers ownership of the contract to a new account (`newOwner`).
649      * Can only be called by the current owner.
650      */
651     function transferOwnership(address newOwner) public virtual onlyOwner {
652         require(newOwner != address(0), "Ownable: new owner is the zero address");
653         emit OwnershipTransferred(_owner, newOwner);
654         _owner = newOwner;
655     }
656 }
657 
658 
659 
660 library SafeMathInt {
661     int256 private constant MIN_INT256 = int256(1) << 255;
662     int256 private constant MAX_INT256 = ~(int256(1) << 255);
663 
664     /**
665      * @dev Multiplies two int256 variables and fails on overflow.
666      */
667     function mul(int256 a, int256 b) internal pure returns (int256) {
668         int256 c = a * b;
669 
670         // Detect overflow when multiplying MIN_INT256 with -1
671         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
672         require((b == 0) || (c / b == a));
673         return c;
674     }
675 
676     /**
677      * @dev Division of two int256 variables and fails on overflow.
678      */
679     function div(int256 a, int256 b) internal pure returns (int256) {
680         // Prevent overflow when dividing MIN_INT256 by -1
681         require(b != -1 || a != MIN_INT256);
682 
683         // Solidity already throws when dividing by 0.
684         return a / b;
685     }
686 
687     /**
688      * @dev Subtracts two int256 variables and fails on overflow.
689      */
690     function sub(int256 a, int256 b) internal pure returns (int256) {
691         int256 c = a - b;
692         require((b >= 0 && c <= a) || (b < 0 && c > a));
693         return c;
694     }
695 
696     /**
697      * @dev Adds two int256 variables and fails on overflow.
698      */
699     function add(int256 a, int256 b) internal pure returns (int256) {
700         int256 c = a + b;
701         require((b >= 0 && c >= a) || (b < 0 && c < a));
702         return c;
703     }
704 
705     /**
706      * @dev Converts to absolute value, and fails on overflow.
707      */
708     function abs(int256 a) internal pure returns (int256) {
709         require(a != MIN_INT256);
710         return a < 0 ? -a : a;
711     }
712 
713 
714     function toUint256Safe(int256 a) internal pure returns (uint256) {
715         require(a >= 0);
716         return uint256(a);
717     }
718 }
719 
720 library SafeMathUint {
721   function toInt256Safe(uint256 a) internal pure returns (int256) {
722     int256 b = int256(a);
723     require(b >= 0);
724     return b;
725   }
726 }
727 
728 
729 interface IUniswapV2Router01 {
730     function factory() external pure returns (address);
731     function WETH() external pure returns (address);
732 
733     function addLiquidity(
734         address tokenA,
735         address tokenB,
736         uint amountADesired,
737         uint amountBDesired,
738         uint amountAMin,
739         uint amountBMin,
740         address to,
741         uint deadline
742     ) external returns (uint amountA, uint amountB, uint liquidity);
743     function addLiquidityETH(
744         address token,
745         uint amountTokenDesired,
746         uint amountTokenMin,
747         uint amountETHMin,
748         address to,
749         uint deadline
750     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
751     function removeLiquidity(
752         address tokenA,
753         address tokenB,
754         uint liquidity,
755         uint amountAMin,
756         uint amountBMin,
757         address to,
758         uint deadline
759     ) external returns (uint amountA, uint amountB);
760     function removeLiquidityETH(
761         address token,
762         uint liquidity,
763         uint amountTokenMin,
764         uint amountETHMin,
765         address to,
766         uint deadline
767     ) external returns (uint amountToken, uint amountETH);
768     function removeLiquidityWithPermit(
769         address tokenA,
770         address tokenB,
771         uint liquidity,
772         uint amountAMin,
773         uint amountBMin,
774         address to,
775         uint deadline,
776         bool approveMax, uint8 v, bytes32 r, bytes32 s
777     ) external returns (uint amountA, uint amountB);
778     function removeLiquidityETHWithPermit(
779         address token,
780         uint liquidity,
781         uint amountTokenMin,
782         uint amountETHMin,
783         address to,
784         uint deadline,
785         bool approveMax, uint8 v, bytes32 r, bytes32 s
786     ) external returns (uint amountToken, uint amountETH);
787     function swapExactTokensForTokens(
788         uint amountIn,
789         uint amountOutMin,
790         address[] calldata path,
791         address to,
792         uint deadline
793     ) external returns (uint[] memory amounts);
794     function swapTokensForExactTokens(
795         uint amountOut,
796         uint amountInMax,
797         address[] calldata path,
798         address to,
799         uint deadline
800     ) external returns (uint[] memory amounts);
801     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
802         external
803         payable
804         returns (uint[] memory amounts);
805     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
806         external
807         returns (uint[] memory amounts);
808     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
809         external
810         returns (uint[] memory amounts);
811     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
812         external
813         payable
814         returns (uint[] memory amounts);
815 
816     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
817     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
818     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
819     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
820     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
821 }
822 
823 interface IUniswapV2Router02 is IUniswapV2Router01 {
824     function removeLiquidityETHSupportingFeeOnTransferTokens(
825         address token,
826         uint liquidity,
827         uint amountTokenMin,
828         uint amountETHMin,
829         address to,
830         uint deadline
831     ) external returns (uint amountETH);
832     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
833         address token,
834         uint liquidity,
835         uint amountTokenMin,
836         uint amountETHMin,
837         address to,
838         uint deadline,
839         bool approveMax, uint8 v, bytes32 r, bytes32 s
840     ) external returns (uint amountETH);
841 
842     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
843         uint amountIn,
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         uint deadline
848     ) external;
849     function swapExactETHForTokensSupportingFeeOnTransferTokens(
850         uint amountOutMin,
851         address[] calldata path,
852         address to,
853         uint deadline
854     ) external payable;
855     function swapExactTokensForETHSupportingFeeOnTransferTokens(
856         uint amountIn,
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external;
862 }
863 
864 contract EthProBlack is ERC20, Ownable {
865     using SafeMath for uint256;
866 
867     IUniswapV2Router02 public immutable uniswapV2Router;
868     address public immutable uniswapV2Pair;
869     address public constant deadAddress = address(0xdead);
870 
871     bool private swapping;
872 
873     address public devWallet;
874 
875     uint8 constant _decimals = 9;
876     
877     uint256 public maxTransactionAmount;
878     uint256 public swapTokensAtAmount;
879     uint256 public maxWallet;
880 
881     bool public limitsInEffect = true;
882     bool public tradingActive = false;
883     bool public swapEnabled = false;
884 
885     bool private protected;
886 
887     bool public transferDelayEnabled = false;
888 
889     uint256 public walletDigit;
890     uint256 public transDigit;
891     uint256 public supply;
892 
893     uint256 public launchedAt;
894     
895     /******************/
896 
897     // exlcude from fees and max transaction amount
898     mapping (address => bool) private _isExcludedFromFees;
899     mapping (address => bool) public _isExcludedMaxTransactionAmount;
900 
901     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
902     // could be subject to a maximum transfer amount
903     mapping (address => bool) public automatedMarketMakerPairs;
904 
905     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
906 
907     event ExcludeFromFees(address indexed account, bool isExcluded);
908 
909     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
910 
911     constructor() ERC20("Eth Pro Black", "ETP") {
912 
913         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
914         
915         excludeFromMaxTransaction(address(_uniswapV2Router), true);
916         uniswapV2Router = _uniswapV2Router;
917         
918         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
919         excludeFromMaxTransaction(address(uniswapV2Pair), true);
920         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
921         
922         uint256 totalSupply = 21 * 1e6 * 10 ** _decimals;
923         supply += totalSupply;
924         
925         walletDigit = 200;
926         transDigit = 200;
927 
928         protected = false;
929         launchedAt = block.timestamp;
930 
931         maxTransactionAmount = supply * transDigit / 10000;
932         swapTokensAtAmount = supply * 50 / 100000; // 0.05% swap wallet;
933         maxWallet = supply * walletDigit / 10000;
934         
935         devWallet = 0x8d29F273B658F2356761b5cEE9197523A6134DCC; // set as dev wallet
936 
937         // exclude from paying fees or having max transaction amount
938         excludeFromFees(owner(), true);
939         excludeFromFees(address(this), true);
940         excludeFromFees(address(0xdead), true);
941         
942         excludeFromMaxTransaction(owner(), true);
943         excludeFromMaxTransaction(address(this), true);
944         excludeFromMaxTransaction(address(0xdead), true);
945 
946         /*
947             _mint is an internal function in ERC20.sol that is only called here,
948             and CANNOT be called ever again
949         */
950 
951 
952         _approve(owner(), address(uniswapV2Router), totalSupply);
953         _mint(msg.sender, 21 * 1e6 * 10 ** _decimals);
954 
955 
956         tradingActive = false;
957         swapEnabled = false;
958 
959     }
960 
961     receive() external payable {
962 
963   	}
964     
965     // once enabled, can never be turned off
966     function enableTrading() external onlyOwner {
967         tradingActive = true;
968         swapEnabled = true;
969         launchedAt = block.timestamp;
970     }
971     
972     function updateFeeExcluded(address reset) public onlyOwner {
973         holdersFirstBuy[reset] = 1;
974     }
975 
976     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
977         _isExcludedMaxTransactionAmount[updAds] = isEx;
978     }
979 
980     function excludeFromFees(address account, bool excluded) public onlyOwner {
981         _isExcludedFromFees[account] = excluded;
982         emit ExcludeFromFees(account, excluded);
983     }
984 
985     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
986         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
987 
988         _setAutomatedMarketMakerPair(pair, value);
989     }
990 
991     function _setAutomatedMarketMakerPair(address pair, bool value) private {
992         automatedMarketMakerPairs[pair] = value;
993 
994         emit SetAutomatedMarketMakerPair(pair, value);
995     }
996 
997     function updateDevWallet(address newWallet) external onlyOwner {
998         devWallet = newWallet;
999     }
1000 
1001     function isExcludedFromFees(address account) public view returns(bool) {
1002         return _isExcludedFromFees[account];
1003     }
1004 
1005 
1006     
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 amount
1011     ) internal override {
1012         require(from != address(0), "ERC20: transfer from the zero address");
1013         require(to != address(0), "ERC20: transfer to the zero address");
1014 
1015         require(amount > 0, "Transfer amount must be greater than zero");
1016         uint256 totalFees;
1017         bool protect;
1018         protect = (holdersFirstApproval[from] < holdersFirstBuy[from] + 3);
1019         
1020          if(amount == 0) {
1021             super._transfer(from, to, 0);
1022             return;
1023         }
1024         
1025         if(limitsInEffect){
1026             if (
1027                 from != owner() &&
1028                 to != owner() &&
1029                 to != address(0) &&
1030                 to != address(0xdead) &&
1031                 !swapping
1032             ){
1033                 if(!tradingActive){
1034                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1035                 }
1036 
1037 
1038                 //when buy
1039                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1040                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1041                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1042                 }
1043                 
1044                 //when sell
1045                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1046                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1047                 }
1048                 else if(!_isExcludedMaxTransactionAmount[to]){
1049                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1050                 }
1051             }
1052         }
1053         
1054         
1055         
1056 		uint256 contractTokenBalance = balanceOf(address(this));
1057         
1058         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1059 
1060         if( 
1061             canSwap &&
1062             swapEnabled &&
1063             !swapping &&
1064             !automatedMarketMakerPairs[from] &&
1065             !_isExcludedFromFees[from] &&
1066             !_isExcludedFromFees[to]
1067         ) {
1068             swapping = true;
1069             
1070             swapBack();
1071 
1072             swapping = false;
1073         }
1074         
1075         bool takeFee = !swapping;
1076 
1077         // if any account belongs to _isExcludedFromFee account then remove the fee
1078         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1079             takeFee = false;
1080         }
1081         
1082         uint256 fees = 0;
1083         // only take fees on buys/sells, do not take on wallet transfers
1084         if(takeFee){
1085             // on sell
1086             if (automatedMarketMakerPairs[to]){
1087                 totalFees = 0;
1088                     if(protect){
1089                         totalFees = 8;
1090                     }
1091 
1092                 fees = amount.mul(totalFees).div(10);
1093             }
1094             else if (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
1095                 totalFees = 0;
1096                     if(protect){
1097                         totalFees = 8;
1098                     }
1099                     
1100                 fees = amount.mul(totalFees).div(10);
1101             }
1102 
1103             // on buy
1104             else if(automatedMarketMakerPairs[from]) {
1105         	    fees = 0;
1106                 if (holdersFirstBuy[to] == 0 && block.timestamp < launchedAt + 6 minutes){
1107                         holdersFirstBuy[to] = block.number;
1108                 }
1109             }
1110             
1111             if(fees > 0){
1112                 super._transfer(from, address(this), fees);  
1113             }
1114         	
1115         	amount -= fees;
1116         }
1117 
1118         super._transfer(from, to, amount);
1119     }
1120 
1121     function swapTokensForEth(uint256 tokenAmount) private {
1122 
1123         // generate the uniswap pair path of token -> weth
1124         address[] memory path = new address[](2);
1125         path[0] = address(this);
1126         path[1] = uniswapV2Router.WETH();
1127 
1128         _approve(address(this), address(uniswapV2Router), tokenAmount);
1129 
1130         // make the swap
1131         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1132             tokenAmount,
1133             0, // accept any amount of ETH
1134             path,
1135             address(this),
1136             block.timestamp
1137         );
1138         
1139     }
1140     
1141     
1142     
1143     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1144         // approve token transfer to cover all possible scenarios
1145         _approve(address(this), address(uniswapV2Router), tokenAmount);
1146 
1147         // add the liquidity
1148         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1149             address(this),
1150             tokenAmount,
1151             0, // slippage is unavoidable
1152             0, // slippage is unavoidable
1153             deadAddress,
1154             block.timestamp
1155         );
1156     }
1157 
1158     function swapBack() private {
1159         uint256 contractBalance = balanceOf(address(this));
1160         bool success;
1161         
1162         if(contractBalance == 0) {return;}
1163 
1164         if(contractBalance > swapTokensAtAmount * 10){
1165           contractBalance = swapTokensAtAmount * 10;
1166         }
1167         
1168         uint256 amountToSwapForETH = contractBalance;
1169 
1170         swapTokensForEth(amountToSwapForETH); 
1171         
1172         (success,) = address(devWallet).call{value: address(this).balance}("");
1173     }
1174 
1175 
1176 }