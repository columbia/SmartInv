1 /**
2 
3 https://twitter.com/SirineAti/status/1586691022544928768
4 
5 Titter the new Twitter, social media for all the dickbutts.  
6 
7 https://t.me/TitterErc
8 
9 /**
10  
11 // SPDX-License-Identifier: Unlicensed
12 
13 
14 */
15 pragma solidity 0.8.9;
16  
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21  
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27  
28 interface IUniswapV2Pair {
29     event Approval(address indexed owner, address indexed spender, uint value);
30     event Transfer(address indexed from, address indexed to, uint value);
31  
32     function name() external pure returns (string memory);
33     function symbol() external pure returns (string memory);
34     function decimals() external pure returns (uint8);
35     function totalSupply() external view returns (uint);
36     function balanceOf(address owner) external view returns (uint);
37     function allowance(address owner, address spender) external view returns (uint);
38  
39     function approve(address spender, uint value) external returns (bool);
40     function transfer(address to, uint value) external returns (bool);
41     function transferFrom(address from, address to, uint value) external returns (bool);
42  
43     function DOMAIN_SEPARATOR() external view returns (bytes32);
44     function PERMIT_TYPEHASH() external pure returns (bytes32);
45     function nonces(address owner) external view returns (uint);
46  
47     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48  
49     event Mint(address indexed sender, uint amount0, uint amount1);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59  
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61     function factory() external view returns (address);
62     function token0() external view returns (address);
63     function token1() external view returns (address);
64     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
65     function price0CumulativeLast() external view returns (uint);
66     function price1CumulativeLast() external view returns (uint);
67     function kLast() external view returns (uint);
68  
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74  
75     function initialize(address, address) external;
76 }
77  
78 interface IUniswapV2Factory {
79     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
80  
81     function feeTo() external view returns (address);
82     function feeToSetter() external view returns (address);
83  
84     function getPair(address tokenA, address tokenB) external view returns (address pair);
85     function allPairs(uint) external view returns (address pair);
86     function allPairsLength() external view returns (uint);
87  
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89  
90     function setFeeTo(address) external;
91     function setFeeToSetter(address) external;
92 }
93  
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99  
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104  
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113  
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122  
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138  
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) external returns (bool);
153  
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161  
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to {approve}. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168  
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174  
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179  
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
185  
186  
187 contract ERC20 is Context, IERC20, IERC20Metadata {
188     using SafeMath for uint256;
189  
190     mapping(address => uint256) private _balances;
191  
192     mapping(address => mapping(address => uint256)) private _allowances;
193  
194     uint256 private _totalSupply;
195  
196     string private _name;
197     string private _symbol;
198  
199     /**
200      * @dev Sets the values for {name} and {symbol}.
201      *
202      * The default value of {decimals} is 18. To select a different value for
203      * {decimals} you should overload it.
204      *
205      * All two of these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor(string memory name_, string memory symbol_) {
209         _name = name_;
210         _symbol = symbol_;
211     }
212  
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219  
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view virtual override returns (string memory) {
225         return _symbol;
226     }
227  
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei. This is the value {ERC20} uses, unless this function is
235      * overridden;
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244  
245     /**
246      * @dev See {IERC20-totalSupply}.
247      */
248     function totalSupply() public view virtual override returns (uint256) {
249         return _totalSupply;
250     }
251  
252     /**
253      * @dev See {IERC20-balanceOf}.
254      */
255     function balanceOf(address account) public view virtual override returns (uint256) {
256         return _balances[account];
257     }
258  
259     /**
260      * @dev See {IERC20-transfer}.
261      *
262      * Requirements:
263      *
264      * - `recipient` cannot be the zero address.
265      * - the caller must have a balance of at least `amount`.
266      */
267     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271  
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278  
279     /**
280      * @dev See {IERC20-approve}.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function approve(address spender, uint256 amount) public virtual override returns (bool) {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290  
291     /**
292      * @dev See {IERC20-transferFrom}.
293      *
294      * Emits an {Approval} event indicating the updated allowance. This is not
295      * required by the EIP. See the note at the beginning of {ERC20}.
296      *
297      * Requirements:
298      *
299      * - `sender` and `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``sender``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313  
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
328         return true;
329     }
330  
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349  
350     /**
351      * @dev Moves tokens `amount` from `sender` to `recipient`.
352      *
353      * This is internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371  
372         _beforeTokenTransfer(sender, recipient, amount);
373  
374         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
375         _balances[recipient] = _balances[recipient].add(amount);
376         emit Transfer(sender, recipient, amount);
377     }
378  
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390  
391         _beforeTokenTransfer(address(0), account, amount);
392  
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397  
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411  
412         _beforeTokenTransfer(account, address(0), amount);
413  
414         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
415         _totalSupply = _totalSupply.sub(amount);
416         emit Transfer(account, address(0), amount);
417     }
418  
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421      *
422      * This internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(
433         address owner,
434         address spender,
435         uint256 amount
436     ) internal virtual {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439  
440         _allowances[owner][spender] = amount;
441         emit Approval(owner, spender, amount);
442     }
443  
444     /**
445      * @dev Hook that is called before any transfer of tokens. This includes
446      * minting and burning.
447      *
448      * Calling conditions:
449      *
450      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
451      * will be to transferred to `to`.
452      * - when `from` is zero, `amount` tokens will be minted for `to`.
453      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
454      * - `from` and `to` are never both zero.
455      *
456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
457      */
458     function _beforeTokenTransfer(
459         address from,
460         address to,
461         uint256 amount
462     ) internal virtual {}
463 }
464  
465 library SafeMath {
466     /**
467      * @dev Returns the addition of two unsigned integers, reverting on
468      * overflow.
469      *
470      * Counterpart to Solidity's `+` operator.
471      *
472      * Requirements:
473      *
474      * - Addition cannot overflow.
475      */
476     function add(uint256 a, uint256 b) internal pure returns (uint256) {
477         uint256 c = a + b;
478         require(c >= a, "SafeMath: addition overflow");
479  
480         return c;
481     }
482  
483     /**
484      * @dev Returns the subtraction of two unsigned integers, reverting on
485      * overflow (when the result is negative).
486      *
487      * Counterpart to Solidity's `-` operator.
488      *
489      * Requirements:
490      *
491      * - Subtraction cannot overflow.
492      */
493     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
494         return sub(a, b, "SafeMath: subtraction overflow");
495     }
496  
497     /**
498      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
499      * overflow (when the result is negative).
500      *
501      * Counterpart to Solidity's `-` operator.
502      *
503      * Requirements:
504      *
505      * - Subtraction cannot overflow.
506      */
507     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
508         require(b <= a, errorMessage);
509         uint256 c = a - b;
510  
511         return c;
512     }
513  
514     /**
515      * @dev Returns the multiplication of two unsigned integers, reverting on
516      * overflow.
517      *
518      * Counterpart to Solidity's `*` operator.
519      *
520      * Requirements:
521      *
522      * - Multiplication cannot overflow.
523      */
524     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
525         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
526         // benefit is lost if 'b' is also tested.
527         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
528         if (a == 0) {
529             return 0;
530         }
531  
532         uint256 c = a * b;
533         require(c / a == b, "SafeMath: multiplication overflow");
534  
535         return c;
536     }
537  
538     /**
539      * @dev Returns the integer division of two unsigned integers. Reverts on
540      * division by zero. The result is rounded towards zero.
541      *
542      * Counterpart to Solidity's `/` operator. Note: this function uses a
543      * `revert` opcode (which leaves remaining gas untouched) while Solidity
544      * uses an invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function div(uint256 a, uint256 b) internal pure returns (uint256) {
551         return div(a, b, "SafeMath: division by zero");
552     }
553  
554     /**
555      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
556      * division by zero. The result is rounded towards zero.
557      *
558      * Counterpart to Solidity's `/` operator. Note: this function uses a
559      * `revert` opcode (which leaves remaining gas untouched) while Solidity
560      * uses an invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
567         require(b > 0, errorMessage);
568         uint256 c = a / b;
569         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
570  
571         return c;
572     }
573  
574     /**
575      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
576      * Reverts when dividing by zero.
577      *
578      * Counterpart to Solidity's `%` operator. This function uses a `revert`
579      * opcode (which leaves remaining gas untouched) while Solidity uses an
580      * invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
587         return mod(a, b, "SafeMath: modulo by zero");
588     }
589  
590     /**
591      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
592      * Reverts with custom message when dividing by zero.
593      *
594      * Counterpart to Solidity's `%` operator. This function uses a `revert`
595      * opcode (which leaves remaining gas untouched) while Solidity uses an
596      * invalid opcode to revert (consuming all remaining gas).
597      *
598      * Requirements:
599      *
600      * - The divisor cannot be zero.
601      */
602     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
603         require(b != 0, errorMessage);
604         return a % b;
605     }
606 }
607  
608 contract Ownable is Context {
609     address private _owner;
610  
611     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
612  
613     /**
614      * @dev Initializes the contract setting the deployer as the initial owner.
615      */
616     constructor () {
617         address msgSender = _msgSender();
618         _owner = msgSender;
619         emit OwnershipTransferred(address(0), msgSender);
620     }
621  
622     /**
623      * @dev Returns the address of the current owner.
624      */
625     function owner() public view returns (address) {
626         return _owner;
627     }
628  
629     /**
630      * @dev Throws if called by any account other than the owner.
631      */
632     modifier onlyOwner() {
633         require(_owner == _msgSender(), "Ownable: caller is not the owner");
634         _;
635     }
636  
637     /**
638      * @dev Leaves the contract without owner. It will not be possible to call
639      * `onlyOwner` functions anymore. Can only be called by the current owner.
640      *
641      * NOTE: Renouncing ownership will leave the contract without an owner,
642      * thereby removing any functionality that is only available to the owner.
643      */
644     function renounceOwnership() public virtual onlyOwner {
645         emit OwnershipTransferred(_owner, address(0));
646         _owner = address(0);
647     }
648  
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public virtual onlyOwner {
654         require(newOwner != address(0), "Ownable: new owner is the zero address");
655         emit OwnershipTransferred(_owner, newOwner);
656         _owner = newOwner;
657     }
658 }
659  
660  
661  
662 library SafeMathInt {
663     int256 private constant MIN_INT256 = int256(1) << 255;
664     int256 private constant MAX_INT256 = ~(int256(1) << 255);
665  
666     /**
667      * @dev Multiplies two int256 variables and fails on overflow.
668      */
669     function mul(int256 a, int256 b) internal pure returns (int256) {
670         int256 c = a * b;
671  
672         // Detect overflow when multiplying MIN_INT256 with -1
673         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
674         require((b == 0) || (c / b == a));
675         return c;
676     }
677  
678     /**
679      * @dev Division of two int256 variables and fails on overflow.
680      */
681     function div(int256 a, int256 b) internal pure returns (int256) {
682         // Prevent overflow when dividing MIN_INT256 by -1
683         require(b != -1 || a != MIN_INT256);
684  
685         // Solidity already throws when dividing by 0.
686         return a / b;
687     }
688  
689     /**
690      * @dev Subtracts two int256 variables and fails on overflow.
691      */
692     function sub(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a - b;
694         require((b >= 0 && c <= a) || (b < 0 && c > a));
695         return c;
696     }
697  
698     /**
699      * @dev Adds two int256 variables and fails on overflow.
700      */
701     function add(int256 a, int256 b) internal pure returns (int256) {
702         int256 c = a + b;
703         require((b >= 0 && c >= a) || (b < 0 && c < a));
704         return c;
705     }
706  
707     /**
708      * @dev Converts to absolute value, and fails on overflow.
709      */
710     function abs(int256 a) internal pure returns (int256) {
711         require(a != MIN_INT256);
712         return a < 0 ? -a : a;
713     }
714  
715  
716     function toUint256Safe(int256 a) internal pure returns (uint256) {
717         require(a >= 0);
718         return uint256(a);
719     }
720 }
721  
722 library SafeMathUint {
723   function toInt256Safe(uint256 a) internal pure returns (int256) {
724     int256 b = int256(a);
725     require(b >= 0);
726     return b;
727   }
728 }
729  
730  
731 interface IUniswapV2Router01 {
732     function factory() external pure returns (address);
733     function WETH() external pure returns (address);
734  
735     function addLiquidity(
736         address tokenA,
737         address tokenB,
738         uint amountADesired,
739         uint amountBDesired,
740         uint amountAMin,
741         uint amountBMin,
742         address to,
743         uint deadline
744     ) external returns (uint amountA, uint amountB, uint liquidity);
745     function addLiquidityETH(
746         address token,
747         uint amountTokenDesired,
748         uint amountTokenMin,
749         uint amountETHMin,
750         address to,
751         uint deadline
752     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
753     function removeLiquidity(
754         address tokenA,
755         address tokenB,
756         uint liquidity,
757         uint amountAMin,
758         uint amountBMin,
759         address to,
760         uint deadline
761     ) external returns (uint amountA, uint amountB);
762     function removeLiquidityETH(
763         address token,
764         uint liquidity,
765         uint amountTokenMin,
766         uint amountETHMin,
767         address to,
768         uint deadline
769     ) external returns (uint amountToken, uint amountETH);
770     function removeLiquidityWithPermit(
771         address tokenA,
772         address tokenB,
773         uint liquidity,
774         uint amountAMin,
775         uint amountBMin,
776         address to,
777         uint deadline,
778         bool approveMax, uint8 v, bytes32 r, bytes32 s
779     ) external returns (uint amountA, uint amountB);
780     function removeLiquidityETHWithPermit(
781         address token,
782         uint liquidity,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline,
787         bool approveMax, uint8 v, bytes32 r, bytes32 s
788     ) external returns (uint amountToken, uint amountETH);
789     function swapExactTokensForTokens(
790         uint amountIn,
791         uint amountOutMin,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapTokensForExactTokens(
797         uint amountOut,
798         uint amountInMax,
799         address[] calldata path,
800         address to,
801         uint deadline
802     ) external returns (uint[] memory amounts);
803     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         payable
806         returns (uint[] memory amounts);
807     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
808         external
809         returns (uint[] memory amounts);
810     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
811         external
812         returns (uint[] memory amounts);
813     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
814         external
815         payable
816         returns (uint[] memory amounts);
817  
818     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
819     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
820     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
821     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
822     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
823 }
824  
825 interface IUniswapV2Router02 is IUniswapV2Router01 {
826     function removeLiquidityETHSupportingFeeOnTransferTokens(
827         address token,
828         uint liquidity,
829         uint amountTokenMin,
830         uint amountETHMin,
831         address to,
832         uint deadline
833     ) external returns (uint amountETH);
834     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline,
841         bool approveMax, uint8 v, bytes32 r, bytes32 s
842     ) external returns (uint amountETH);
843  
844     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
845         uint amountIn,
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external;
851     function swapExactETHForTokensSupportingFeeOnTransferTokens(
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external payable;
857     function swapExactTokensForETHSupportingFeeOnTransferTokens(
858         uint amountIn,
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline
863     ) external;
864 }
865  
866 contract TITTER is ERC20, Ownable {
867     using SafeMath for uint256;
868  
869     IUniswapV2Router02 public immutable uniswapV2Router;
870     address public immutable uniswapV2Pair;
871  
872     bool private swapping;
873  
874     address private marketingWallet;
875     address private devWallet;
876  
877     uint256 public maxTransactionAmount;
878     uint256 public swapTokensAtAmount;
879     uint256 public maxWallet;
880  
881     bool public limitsInEffect = true;
882     bool public tradingActive = false;
883     bool public swapEnabled = false;
884  
885      // Anti-bot and anti-whale mappings and variables
886     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
887  
888     // Seller Map
889     mapping (address => uint256) private _holderFirstBuyTimestamp;
890  
891     // Blacklist Map
892     mapping (address => bool) private _blacklist;
893     bool public transferDelayEnabled = true;
894  
895     uint256 public buyTotalFees;
896     uint256 public buyMarketingFee;
897     uint256 public buyLiquidityFee;
898     uint256 public buyDevFee;
899  
900     uint256 public sellTotalFees;
901     uint256 public sellMarketingFee;
902     uint256 public sellLiquidityFee;
903     uint256 public sellDevFee;
904  
905     uint256 public tokensForMarketing;
906     uint256 public tokensForLiquidity;
907     uint256 public tokensForDev;
908  
909     // block number of opened trading
910     uint256 launchedAt;
911  
912     /******************/
913  
914     // exclude from fees and max transaction amount
915     mapping (address => bool) private _isExcludedFromFees;
916     mapping (address => bool) public _isExcludedMaxTransactionAmount;
917  
918     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
919     // could be subject to a maximum transfer amount
920     mapping (address => bool) public automatedMarketMakerPairs;
921  
922     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
923  
924     event ExcludeFromFees(address indexed account, bool isExcluded);
925  
926     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
927  
928     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
929  
930     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
931  
932     event SwapAndLiquify(
933         uint256 tokensSwapped,
934         uint256 ethReceived,
935         uint256 tokensIntoLiquidity
936     );
937  
938     event AutoNukeLP();
939  
940     event ManualNukeLP();
941  
942     constructor() ERC20("TITTER", "TITTER") {
943  
944         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
945  
946         excludeFromMaxTransaction(address(_uniswapV2Router), true);
947         uniswapV2Router = _uniswapV2Router;
948  
949         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
950         excludeFromMaxTransaction(address(uniswapV2Pair), true);
951         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
952  
953         uint256 _buyMarketingFee = 0;
954         uint256 _buyLiquidityFee = 0;
955         uint256 _buyDevFee = 3;
956  
957         uint256 _sellMarketingFee = 0;
958         uint256 _sellLiquidityFee = 0;
959         uint256 _sellDevFee = 3;
960  
961         uint256 totalSupply = 1 * 1e12 * 1e18;
962  
963         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
964         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
965         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1% swap wallet
966  
967         buyMarketingFee = _buyMarketingFee;
968         buyLiquidityFee = _buyLiquidityFee;
969         buyDevFee = _buyDevFee;
970         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
971  
972         sellMarketingFee = _sellMarketingFee;
973         sellLiquidityFee = _sellLiquidityFee;
974         sellDevFee = _sellDevFee;
975         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
976  
977         marketingWallet = address(owner()); // set as marketing wallet
978         devWallet = address(owner()); // set as dev wallet
979  
980         // exclude from paying fees or having max transaction amount
981         excludeFromFees(owner(), true);
982         excludeFromFees(address(this), true);
983         excludeFromFees(address(0xdead), true);
984  
985         excludeFromMaxTransaction(owner(), true);
986         excludeFromMaxTransaction(address(this), true);
987         excludeFromMaxTransaction(address(0xdead), true);
988  
989         /*
990             _mint is an internal function in ERC20.sol that is only called here,
991             and CANNOT be called ever again
992         */
993         _mint(msg.sender, totalSupply);
994     }
995  
996     receive() external payable {
997  
998     }
999  
1000     // once enabled, can never be turned off
1001     function enableTrading() external onlyOwner {
1002         tradingActive = true;
1003         swapEnabled = true;
1004         launchedAt = block.number;
1005     }
1006  
1007     // remove limits after token is stable
1008     function removeLimits() external onlyOwner returns (bool){
1009         limitsInEffect = false;
1010         return true;
1011     }
1012  
1013     // disable Transfer delay - cannot be reenabled
1014     function disableTransferDelay() external onlyOwner returns (bool){
1015         transferDelayEnabled = false;
1016         return true;
1017     }
1018  
1019      // change the minimum amount of tokens to sell from fees
1020     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1021         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1022         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1023         swapTokensAtAmount = newAmount;
1024         return true;
1025     }
1026  
1027     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1028         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1029         maxTransactionAmount = newNum * (10**18);
1030     }
1031  
1032     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1033         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1034         maxWallet = newNum * (10**18);
1035     }
1036  
1037     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1038         _isExcludedMaxTransactionAmount[updAds] = isEx;
1039     }
1040  
1041     // only use to disable contract sales if absolutely necessary (emergency use only)
1042     function updateSwapEnabled(bool enabled) external onlyOwner(){
1043         swapEnabled = enabled;
1044     }
1045  
1046     function excludeFromFees(address account, bool excluded) public onlyOwner {
1047         _isExcludedFromFees[account] = excluded;
1048         emit ExcludeFromFees(account, excluded);
1049     }
1050  
1051     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1052         _blacklist[account] = isBlacklisted;
1053     }
1054  
1055     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1056         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1057  
1058         _setAutomatedMarketMakerPair(pair, value);
1059     }
1060  
1061     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1062         automatedMarketMakerPairs[pair] = value;
1063  
1064         emit SetAutomatedMarketMakerPair(pair, value);
1065     }
1066  
1067     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1068         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1069         marketingWallet = newMarketingWallet;
1070     }
1071  
1072     function updateDevWallet(address newWallet) external onlyOwner {
1073         emit devWalletUpdated(newWallet, devWallet);
1074         devWallet = newWallet;
1075     }
1076  
1077  
1078     function isExcludedFromFees(address account) public view returns(bool) {
1079         return _isExcludedFromFees[account];
1080     }
1081  
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 amount
1086     ) internal override {
1087         require(from != address(0), "ERC20: transfer from the zero address");
1088         require(to != address(0), "ERC20: transfer to the zero address");
1089         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1090          if(amount == 0) {
1091             super._transfer(from, to, 0);
1092             return;
1093         }
1094  
1095         if(limitsInEffect){
1096             if (
1097                 from != owner() &&
1098                 to != owner() &&
1099                 to != address(0) &&
1100                 to != address(0xdead) &&
1101                 !swapping
1102             ){
1103                 if(!tradingActive){
1104                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1105                 }
1106  
1107                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1108                 if (transferDelayEnabled){
1109                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1110                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1111                         _holderLastTransferTimestamp[tx.origin] = block.number;
1112                     }
1113                 }
1114  
1115                 //when buy
1116                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1117                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1118                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1119                 }
1120  
1121                 //when sell
1122                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1123                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1124                 }
1125                 else if(!_isExcludedMaxTransactionAmount[to]){
1126                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1127                 }
1128             }
1129         }
1130  
1131         uint256 contractTokenBalance = balanceOf(address(this));
1132  
1133         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1134  
1135         if( 
1136             canSwap &&
1137             swapEnabled &&
1138             !swapping &&
1139             !automatedMarketMakerPairs[from] &&
1140             !_isExcludedFromFees[from] &&
1141             !_isExcludedFromFees[to]
1142         ) {
1143             swapping = true;
1144  
1145             swapBack();
1146  
1147             swapping = false;
1148         }
1149  
1150         bool takeFee = !swapping;
1151  
1152         // if any account belongs to _isExcludedFromFee account then remove the fee
1153         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1154             takeFee = false;
1155         }
1156  
1157         uint256 fees = 0;
1158         // only take fees on buys/sells, do not take on wallet transfers
1159         if(takeFee){
1160             // on sell
1161             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1162                 fees = amount.mul(sellTotalFees).div(100);
1163                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1164                 tokensForDev += fees * sellDevFee / sellTotalFees;
1165                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1166             }
1167             // on buy
1168             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1169                 fees = amount.mul(buyTotalFees).div(100);
1170                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1171                 tokensForDev += fees * buyDevFee / buyTotalFees;
1172                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1173             }
1174  
1175             if(fees > 0){    
1176                 super._transfer(from, address(this), fees);
1177             }
1178  
1179             amount -= fees;
1180         }
1181  
1182         super._transfer(from, to, amount);
1183     }
1184  
1185     function swapTokensForEth(uint256 tokenAmount) private {
1186  
1187         // generate the uniswap pair path of token -> weth
1188         address[] memory path = new address[](2);
1189         path[0] = address(this);
1190         path[1] = uniswapV2Router.WETH();
1191  
1192         _approve(address(this), address(uniswapV2Router), tokenAmount);
1193  
1194         // make the swap
1195         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1196             tokenAmount,
1197             0, // accept any amount of ETH
1198             path,
1199             address(this),
1200             block.timestamp
1201         );
1202  
1203     }
1204  
1205     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1206         // approve token transfer to cover all possible scenarios
1207         _approve(address(this), address(uniswapV2Router), tokenAmount);
1208  
1209         // add the liquidity
1210         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1211             address(this),
1212             tokenAmount,
1213             0, // slippage is unavoidable
1214             0, // slippage is unavoidable
1215             address(this),
1216             block.timestamp
1217         );
1218     }
1219  
1220     function swapBack() private {
1221         uint256 contractBalance = balanceOf(address(this));
1222         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1223         bool success;
1224  
1225         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1226  
1227         if(contractBalance > swapTokensAtAmount * 20){
1228           contractBalance = swapTokensAtAmount * 20;
1229         }
1230  
1231         // Halve the amount of liquidity tokens
1232         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1233         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1234  
1235         uint256 initialETHBalance = address(this).balance;
1236  
1237         swapTokensForEth(amountToSwapForETH); 
1238  
1239         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1240  
1241         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1242         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1243         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1244  
1245  
1246         tokensForLiquidity = 0;
1247         tokensForMarketing = 0;
1248         tokensForDev = 0;
1249  
1250         (success,) = address(devWallet).call{value: ethForDev}("");
1251  
1252         if(liquidityTokens > 0 && ethForLiquidity > 0){
1253             addLiquidity(liquidityTokens, ethForLiquidity);
1254             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1255         }
1256  
1257         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1258     }
1259 }