1 /**
2 SHIBCHAIN Token. The Dogechain Killer!!
3 
4 SHIBCHAIN superpowers SHIBA INU to bring crypto applications like #NFTs and #DeFi to the #SHIB community!
5 
6 * TG: https://t.me/shibchainArmy
7 * Twitter: https://twitter.com/shibchainArmy
8 
9 * 1B total supply
10 * Ownership renounced
11 
12 * Tax 5% when SELL
13 * Max transaction swap 2%
14 
15 // SPDX-License-Identifier: Unlicensed
16 */
17 
18 pragma solidity 0.8.9;
19  
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24  
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30  
31 interface IUniswapV2Pair {
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Transfer(address indexed from, address indexed to, uint value);
34  
35     function name() external pure returns (string memory);
36     function symbol() external pure returns (string memory);
37     function decimals() external pure returns (uint8);
38     function totalSupply() external view returns (uint);
39     function balanceOf(address owner) external view returns (uint);
40     function allowance(address owner, address spender) external view returns (uint);
41  
42     function approve(address spender, uint value) external returns (bool);
43     function transfer(address to, uint value) external returns (bool);
44     function transferFrom(address from, address to, uint value) external returns (bool);
45  
46     function DOMAIN_SEPARATOR() external view returns (bytes32);
47     function PERMIT_TYPEHASH() external pure returns (bytes32);
48     function nonces(address owner) external view returns (uint);
49  
50     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
51  
52     event Mint(address indexed sender, uint amount0, uint amount1);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62  
63     function MINIMUM_LIQUIDITY() external pure returns (uint);
64     function factory() external view returns (address);
65     function token0() external view returns (address);
66     function token1() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function price0CumulativeLast() external view returns (uint);
69     function price1CumulativeLast() external view returns (uint);
70     function kLast() external view returns (uint);
71  
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77  
78     function initialize(address, address) external;
79 }
80  
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83  
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86  
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90  
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92  
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96  
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102  
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107  
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116  
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125  
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141  
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156  
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164  
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171  
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177  
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182  
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188  
189 contract ERC20 is Context, IERC20, IERC20Metadata {
190     using SafeMath for uint256;
191  
192     mapping(address => uint256) private _balances;
193  
194     mapping(address => mapping(address => uint256)) private _allowances;
195  
196     uint256 private _totalSupply;
197  
198     string private _name;
199     string private _symbol;
200  
201     /**
202      * @dev Sets the values for {name} and {symbol}.
203      *
204      * The default value of {decimals} is 18. To select a different value for
205      * {decimals} you should overload it.
206      *
207      * All two of these values are immutable: they can only be set once during
208      * construction.
209      */
210     constructor(string memory name_, string memory symbol_) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214  
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() public view virtual override returns (string memory) {
219         return _name;
220     }
221  
222     /**
223      * @dev Returns the symbol of the token, usually a shorter version of the
224      * name.
225      */
226     function symbol() public view virtual override returns (string memory) {
227         return _symbol;
228     }
229  
230     /**
231      * @dev Returns the number of decimals used to get its user representation.
232      * For example, if `decimals` equals `2`, a balance of `505` tokens should
233      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
234      *
235      * Tokens usually opt for a value of 18, imitating the relationship between
236      * Ether and Wei. This is the value {ERC20} uses, unless this function is
237      * overridden;
238      *
239      * NOTE: This information is only used for _display_ purposes: it in
240      * no way affects any of the arithmetic of the contract, including
241      * {IERC20-balanceOf} and {IERC20-transfer}.
242      */
243     function decimals() public view virtual override returns (uint8) {
244         return 18;
245     }
246  
247     /**
248      * @dev See {IERC20-totalSupply}.
249      */
250     function totalSupply() public view virtual override returns (uint256) {
251         return _totalSupply;
252     }
253  
254     /**
255      * @dev See {IERC20-balanceOf}.
256      */
257     function balanceOf(address account) public view virtual override returns (uint256) {
258         return _balances[account];
259     }
260  
261     /**
262      * @dev See {IERC20-transfer}.
263      *
264      * Requirements:
265      *
266      * - `recipient` cannot be the zero address.
267      * - the caller must have a balance of at least `amount`.
268      */
269     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273  
274     /**
275      * @dev See {IERC20-allowance}.
276      */
277     function allowance(address owner, address spender) public view virtual override returns (uint256) {
278         return _allowances[owner][spender];
279     }
280  
281     /**
282      * @dev See {IERC20-approve}.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 amount) public virtual override returns (bool) {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292  
293     /**
294      * @dev See {IERC20-transferFrom}.
295      *
296      * Emits an {Approval} event indicating the updated allowance. This is not
297      * required by the EIP. See the note at the beginning of {ERC20}.
298      *
299      * Requirements:
300      *
301      * - `sender` and `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      * - the caller must have allowance for ``sender``'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         _transfer(sender, recipient, amount);
312         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
313         return true;
314     }
315  
316     /**
317      * @dev Atomically increases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
329         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
330         return true;
331     }
332  
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
349         return true;
350     }
351  
352     /**
353      * @dev Moves tokens `amount` from `sender` to `recipient`.
354      *
355      * This is internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373  
374         _beforeTokenTransfer(sender, recipient, amount);
375  
376         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
377         _balances[recipient] = _balances[recipient].add(amount);
378         emit Transfer(sender, recipient, amount);
379     }
380  
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392  
393         _beforeTokenTransfer(address(0), account, amount);
394  
395         _totalSupply = _totalSupply.add(amount);
396         _balances[account] = _balances[account].add(amount);
397         emit Transfer(address(0), account, amount);
398     }
399  
400     /**
401      * @dev Destroys `amount` tokens from `account`, reducing the
402      * total supply.
403      *
404      * Emits a {Transfer} event with `to` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      * - `account` must have at least `amount` tokens.
410      */
411     function _burn(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: burn from the zero address");
413  
414         _beforeTokenTransfer(account, address(0), amount);
415  
416         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
417         _totalSupply = _totalSupply.sub(amount);
418         emit Transfer(account, address(0), amount);
419     }
420  
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
423      *
424      * This internal function is equivalent to `approve`, and can be used to
425      * e.g. set automatic allowances for certain subsystems, etc.
426      *
427      * Emits an {Approval} event.
428      *
429      * Requirements:
430      *
431      * - `owner` cannot be the zero address.
432      * - `spender` cannot be the zero address.
433      */
434     function _approve(
435         address owner,
436         address spender,
437         uint256 amount
438     ) internal virtual {
439         require(owner != address(0), "ERC20: approve from the zero address");
440         require(spender != address(0), "ERC20: approve to the zero address");
441  
442         _allowances[owner][spender] = amount;
443         emit Approval(owner, spender, amount);
444     }
445  
446     /**
447      * @dev Hook that is called before any transfer of tokens. This includes
448      * minting and burning.
449      *
450      * Calling conditions:
451      *
452      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
453      * will be to transferred to `to`.
454      * - when `from` is zero, `amount` tokens will be minted for `to`.
455      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
456      * - `from` and `to` are never both zero.
457      *
458      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
459      */
460     function _beforeTokenTransfer(
461         address from,
462         address to,
463         uint256 amount
464     ) internal virtual {}
465 }
466  
467 library SafeMath {
468     /**
469      * @dev Returns the addition of two unsigned integers, reverting on
470      * overflow.
471      *
472      * Counterpart to Solidity's `+` operator.
473      *
474      * Requirements:
475      *
476      * - Addition cannot overflow.
477      */
478     function add(uint256 a, uint256 b) internal pure returns (uint256) {
479         uint256 c = a + b;
480         require(c >= a, "SafeMath: addition overflow");
481  
482         return c;
483     }
484  
485     /**
486      * @dev Returns the subtraction of two unsigned integers, reverting on
487      * overflow (when the result is negative).
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496         return sub(a, b, "SafeMath: subtraction overflow");
497     }
498  
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
501      * overflow (when the result is negative).
502      *
503      * Counterpart to Solidity's `-` operator.
504      *
505      * Requirements:
506      *
507      * - Subtraction cannot overflow.
508      */
509     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b <= a, errorMessage);
511         uint256 c = a - b;
512  
513         return c;
514     }
515  
516     /**
517      * @dev Returns the multiplication of two unsigned integers, reverting on
518      * overflow.
519      *
520      * Counterpart to Solidity's `*` operator.
521      *
522      * Requirements:
523      *
524      * - Multiplication cannot overflow.
525      */
526     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
527         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
528         // benefit is lost if 'b' is also tested.
529         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
530         if (a == 0) {
531             return 0;
532         }
533  
534         uint256 c = a * b;
535         require(c / a == b, "SafeMath: multiplication overflow");
536  
537         return c;
538     }
539  
540     /**
541      * @dev Returns the integer division of two unsigned integers. Reverts on
542      * division by zero. The result is rounded towards zero.
543      *
544      * Counterpart to Solidity's `/` operator. Note: this function uses a
545      * `revert` opcode (which leaves remaining gas untouched) while Solidity
546      * uses an invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function div(uint256 a, uint256 b) internal pure returns (uint256) {
553         return div(a, b, "SafeMath: division by zero");
554     }
555  
556     /**
557      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
558      * division by zero. The result is rounded towards zero.
559      *
560      * Counterpart to Solidity's `/` operator. Note: this function uses a
561      * `revert` opcode (which leaves remaining gas untouched) while Solidity
562      * uses an invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b > 0, errorMessage);
570         uint256 c = a / b;
571         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
572  
573         return c;
574     }
575  
576     /**
577      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
578      * Reverts when dividing by zero.
579      *
580      * Counterpart to Solidity's `%` operator. This function uses a `revert`
581      * opcode (which leaves remaining gas untouched) while Solidity uses an
582      * invalid opcode to revert (consuming all remaining gas).
583      *
584      * Requirements:
585      *
586      * - The divisor cannot be zero.
587      */
588     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
589         return mod(a, b, "SafeMath: modulo by zero");
590     }
591  
592     /**
593      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
594      * Reverts with custom message when dividing by zero.
595      *
596      * Counterpart to Solidity's `%` operator. This function uses a `revert`
597      * opcode (which leaves remaining gas untouched) while Solidity uses an
598      * invalid opcode to revert (consuming all remaining gas).
599      *
600      * Requirements:
601      *
602      * - The divisor cannot be zero.
603      */
604     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
605         require(b != 0, errorMessage);
606         return a % b;
607     }
608 }
609  
610 contract Ownable is Context {
611     address private _owner;
612  
613     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
614  
615     /**
616      * @dev Initializes the contract setting the deployer as the initial owner.
617      */
618     constructor () {
619         address msgSender = _msgSender();
620         _owner = msgSender;
621         emit OwnershipTransferred(address(0), msgSender);
622     }
623  
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view returns (address) {
628         return _owner;
629     }
630  
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(_owner == _msgSender(), "Ownable: caller is not the owner");
636         _;
637     }
638  
639     /**
640      * @dev Leaves the contract without owner. It will not be possible to call
641      * `onlyOwner` functions anymore. Can only be called by the current owner.
642      *
643      * NOTE: Renouncing ownership will leave the contract without an owner,
644      * thereby removing any functionality that is only available to the owner.
645      */
646     function renounceOwnership() public virtual onlyOwner {
647         emit OwnershipTransferred(_owner, address(0));
648         _owner = address(0);
649     }
650  
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(newOwner != address(0), "Ownable: new owner is the zero address");
657         emit OwnershipTransferred(_owner, newOwner);
658         _owner = newOwner;
659     }
660 }
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
730 interface IUniswapV2Router01 {
731     function factory() external pure returns (address);
732     function WETH() external pure returns (address);
733  
734     function addLiquidity(
735         address tokenA,
736         address tokenB,
737         uint amountADesired,
738         uint amountBDesired,
739         uint amountAMin,
740         uint amountBMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountA, uint amountB, uint liquidity);
744     function addLiquidityETH(
745         address token,
746         uint amountTokenDesired,
747         uint amountTokenMin,
748         uint amountETHMin,
749         address to,
750         uint deadline
751     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
752     function removeLiquidity(
753         address tokenA,
754         address tokenB,
755         uint liquidity,
756         uint amountAMin,
757         uint amountBMin,
758         address to,
759         uint deadline
760     ) external returns (uint amountA, uint amountB);
761     function removeLiquidityETH(
762         address token,
763         uint liquidity,
764         uint amountTokenMin,
765         uint amountETHMin,
766         address to,
767         uint deadline
768     ) external returns (uint amountToken, uint amountETH);
769     function removeLiquidityWithPermit(
770         address tokenA,
771         address tokenB,
772         uint liquidity,
773         uint amountAMin,
774         uint amountBMin,
775         address to,
776         uint deadline,
777         bool approveMax, uint8 v, bytes32 r, bytes32 s
778     ) external returns (uint amountA, uint amountB);
779     function removeLiquidityETHWithPermit(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountToken, uint amountETH);
788     function swapExactTokensForTokens(
789         uint amountIn,
790         uint amountOutMin,
791         address[] calldata path,
792         address to,
793         uint deadline
794     ) external returns (uint[] memory amounts);
795     function swapTokensForExactTokens(
796         uint amountOut,
797         uint amountInMax,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external returns (uint[] memory amounts);
802     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
803         external
804         payable
805         returns (uint[] memory amounts);
806     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
810         external
811         returns (uint[] memory amounts);
812     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
813         external
814         payable
815         returns (uint[] memory amounts);
816  
817     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
818     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
819     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
820     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
821     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
822 }
823  
824 interface IUniswapV2Router02 is IUniswapV2Router01 {
825     function removeLiquidityETHSupportingFeeOnTransferTokens(
826         address token,
827         uint liquidity,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline
832     ) external returns (uint amountETH);
833     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
834         address token,
835         uint liquidity,
836         uint amountTokenMin,
837         uint amountETHMin,
838         address to,
839         uint deadline,
840         bool approveMax, uint8 v, bytes32 r, bytes32 s
841     ) external returns (uint amountETH);
842  
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint amountIn,
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external;
850     function swapExactETHForTokensSupportingFeeOnTransferTokens(
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external payable;
856     function swapExactTokensForETHSupportingFeeOnTransferTokens(
857         uint amountIn,
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external;
863 }
864  
865 contract SHIBCHAIN is ERC20, Ownable {
866     using SafeMath for uint256;
867  
868     IUniswapV2Router02 public immutable uniswapV2Router;
869     address public immutable uniswapV2Pair;
870  
871     bool private swapping;
872  
873     address private marketingWallet;
874     address private devWallet;
875  
876     uint256 public maxTransactionAmount;
877     uint256 public swapTokensAtAmount;
878     uint256 public maxWallet;
879  
880     bool public limitsInEffect = true;
881     bool public tradingActive = false;
882     bool public swapEnabled = false;
883  
884      // Anti-bot and anti-whale mappings and variables
885     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
886  
887     // Seller Map
888     mapping (address => uint256) private _holderFirstBuyTimestamp;
889  
890     bool public transferDelayEnabled = true;
891  
892     uint256 public buyTotalFees;
893     uint256 public buyMarketingFee;
894     uint256 public buyLiquidityFee;
895     uint256 public buyDevFee;
896  
897     uint256 public sellTotalFees;
898     uint256 public sellMarketingFee;
899     uint256 public sellLiquidityFee;
900     uint256 public sellDevFee;
901  
902     uint256 public tokensForMarketing;
903     uint256 public tokensForLiquidity;
904     uint256 public tokensForDev;
905  
906     // block number of opened trading
907     uint256 launchedAt;
908  
909     // exclude from fees and max transaction amount
910     mapping (address => bool) private _isExcludedFromFees;
911     mapping (address => bool) public _isExcludedMaxTransactionAmount;
912  
913     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
914     // could be subject to a maximum transfer amount
915     mapping (address => bool) public automatedMarketMakerPairs;
916  
917     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
918  
919     event ExcludeFromFees(address indexed account, bool isExcluded);
920  
921     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
922  
923     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
924  
925     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
926  
927     event SwapAndLiquify(
928         uint256 tokensSwapped,
929         uint256 ethReceived,
930         uint256 tokensIntoLiquidity
931     );
932  
933     event AutoNukeLP();
934  
935     event ManualNukeLP();
936  
937     constructor() ERC20("SHIBCHAIN", "SC") {
938  
939         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
940  
941         excludeFromMaxTransaction(address(_uniswapV2Router), true);
942         uniswapV2Router = _uniswapV2Router;
943  
944         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
945         excludeFromMaxTransaction(address(uniswapV2Pair), true);
946         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
947  
948         uint256 _buyMarketingFee = 0;
949         uint256 _buyLiquidityFee = 0;
950         uint256 _buyDevFee = 0;
951  
952         uint256 _sellMarketingFee = 5;
953         uint256 _sellLiquidityFee = 0;
954         uint256 _sellDevFee = 0;
955  
956         uint256 totalSupply = 1 * 1e9 * 1e18; // 1B
957  
958         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
959         maxWallet = totalSupply * 20 / 1000; // 2% 
960         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
961  
962         buyMarketingFee = _buyMarketingFee;
963         buyLiquidityFee = _buyLiquidityFee;
964         buyDevFee = _buyDevFee;
965         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
966  
967         sellMarketingFee = _sellMarketingFee;
968         sellLiquidityFee = _sellLiquidityFee;
969         sellDevFee = _sellDevFee;
970         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
971  
972         marketingWallet = address(owner()); // set as marketing wallet
973         devWallet = address(owner()); // set as dev wallet
974  
975         // exclude from paying fees or having max transaction amount
976         excludeFromFees(owner(), true);
977         excludeFromFees(address(this), true);
978         excludeFromFees(address(0xdead), true);
979  
980         excludeFromMaxTransaction(owner(), true);
981         excludeFromMaxTransaction(address(this), true);
982         excludeFromMaxTransaction(address(0xdead), true);
983  
984         /*
985             _mint is an internal function in ERC20.sol that is only called here,
986             and CANNOT be called ever again
987         */
988         _mint(msg.sender, totalSupply);
989     }
990  
991     receive() external payable {
992  
993     }
994  
995     // once enabled, can never be turned off
996     function enableTrading() external onlyOwner {
997         tradingActive = true;
998         swapEnabled = true;
999         launchedAt = block.number;
1000     }
1001  
1002     // remove limits after token is stable
1003     function removeLimits() external onlyOwner returns (bool){
1004         limitsInEffect = false;
1005         return true;
1006     }
1007  
1008     // disable Transfer delay - cannot be reenabled
1009     function disableTransferDelay() external onlyOwner returns (bool){
1010         transferDelayEnabled = false;
1011         return true;
1012     }
1013  
1014      // change the minimum amount of tokens to sell from fees
1015     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1016         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1017         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1018         swapTokensAtAmount = newAmount;
1019         return true;
1020     }
1021  
1022     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1023         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1024         maxTransactionAmount = newNum * (10**18);
1025     }
1026  
1027     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1028         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1029         maxWallet = newNum * (10**18);
1030     }
1031  
1032     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1033         _isExcludedMaxTransactionAmount[updAds] = isEx;
1034     }
1035 
1036     function updateBuyFees(
1037         uint256 _devFee,
1038         uint256 _liquidityFee,
1039         uint256 _marketingFee
1040     ) external onlyOwner {
1041         buyDevFee = _devFee;
1042         buyLiquidityFee = _liquidityFee;
1043         buyMarketingFee = _marketingFee;
1044         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1045         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1046     }
1047 
1048     function updateSellFees(
1049         uint256 _devFee,
1050         uint256 _liquidityFee,
1051         uint256 _marketingFee
1052     ) external onlyOwner {
1053         sellDevFee = _devFee;
1054         sellLiquidityFee = _liquidityFee;
1055         sellMarketingFee = _marketingFee;
1056         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1057         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1058     }
1059  
1060     // only use to disable contract sales if absolutely necessary (emergency use only)
1061     function updateSwapEnabled(bool enabled) external onlyOwner(){
1062         swapEnabled = enabled;
1063     }
1064 
1065     // withdraw stucked ETH in smart contract
1066     function withdrawStuckETH() external onlyOwner {
1067         bool success;
1068         (success, ) = address(owner()).call{value: address(this).balance}("");
1069     }  
1070  
1071     function excludeFromFees(address account, bool excluded) public onlyOwner {
1072         _isExcludedFromFees[account] = excluded;
1073         emit ExcludeFromFees(account, excluded);
1074     }
1075  
1076     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1077         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1078  
1079         _setAutomatedMarketMakerPair(pair, value);
1080     }
1081  
1082     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1083         automatedMarketMakerPairs[pair] = value;
1084  
1085         emit SetAutomatedMarketMakerPair(pair, value);
1086     }
1087  
1088     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1089         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1090         marketingWallet = newMarketingWallet;
1091     }
1092  
1093     function updateDevWallet(address newWallet) external onlyOwner {
1094         emit devWalletUpdated(newWallet, devWallet);
1095         devWallet = newWallet;
1096     }
1097  
1098     function isExcludedFromFees(address account) public view returns(bool) {
1099         return _isExcludedFromFees[account];
1100     }
1101  
1102     function _transfer(
1103         address from,
1104         address to,
1105         uint256 amount
1106     ) internal override {
1107         require(from != address(0), "ERC20: transfer from the zero address");
1108         require(to != address(0), "ERC20: transfer to the zero address");
1109          if(amount == 0) {
1110             super._transfer(from, to, 0);
1111             return;
1112         }
1113  
1114         if(limitsInEffect){
1115             if (
1116                 from != owner() &&
1117                 to != owner() &&
1118                 to != address(0) &&
1119                 to != address(0xdead) &&
1120                 !swapping
1121             ){
1122                 if(!tradingActive){
1123                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1124                 }
1125  
1126                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1127                 if (transferDelayEnabled){
1128                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1129                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1130                         _holderLastTransferTimestamp[tx.origin] = block.number;
1131                     }
1132                 }
1133  
1134                 //when buy
1135                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1136                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1137                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1138                 }
1139  
1140                 //when sell
1141                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1142                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1143                 }
1144                 else if(!_isExcludedMaxTransactionAmount[to]){
1145                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1146                 }
1147             }
1148         }
1149  
1150         uint256 contractTokenBalance = balanceOf(address(this));
1151  
1152         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1153  
1154         if( 
1155             canSwap &&
1156             swapEnabled &&
1157             !swapping &&
1158             !automatedMarketMakerPairs[from] &&
1159             !_isExcludedFromFees[from] &&
1160             !_isExcludedFromFees[to]
1161         ) {
1162             swapping = true;
1163  
1164             swapBack();
1165  
1166             swapping = false;
1167         }
1168  
1169         bool takeFee = !swapping;
1170  
1171         // if any account belongs to _isExcludedFromFee account then remove the fee
1172         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1173             takeFee = false;
1174         }
1175  
1176         uint256 fees = 0;
1177         // only take fees on buys/sells, do not take on wallet transfers
1178         if(takeFee){
1179             // on sell
1180             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1181                 fees = amount.mul(sellTotalFees).div(100);
1182                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1183                 tokensForDev += fees * sellDevFee / sellTotalFees;
1184                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1185             }
1186             // on buy
1187             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1188                 fees = amount.mul(buyTotalFees).div(100);
1189                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1190                 tokensForDev += fees * buyDevFee / buyTotalFees;
1191                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1192             }
1193  
1194             if(fees > 0){    
1195                 super._transfer(from, address(this), fees);
1196             }
1197  
1198             amount -= fees;
1199         }
1200  
1201         super._transfer(from, to, amount);
1202     }
1203  
1204     function swapTokensForEth(uint256 tokenAmount) private {
1205  
1206         // generate the uniswap pair path of token -> weth
1207         address[] memory path = new address[](2);
1208         path[0] = address(this);
1209         path[1] = uniswapV2Router.WETH();
1210  
1211         _approve(address(this), address(uniswapV2Router), tokenAmount);
1212  
1213         // make the swap
1214         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1215             tokenAmount,
1216             0, // accept any amount of ETH
1217             path,
1218             address(this),
1219             block.timestamp
1220         );
1221  
1222     }
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
1234             address(this),
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
1262         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1263  
1264  
1265         tokensForLiquidity = 0;
1266         tokensForMarketing = 0;
1267         tokensForDev = 0;
1268  
1269         (success,) = address(devWallet).call{value: ethForDev}("");
1270  
1271         if(liquidityTokens > 0 && ethForLiquidity > 0){
1272             addLiquidity(liquidityTokens, ethForLiquidity);
1273             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1274         }
1275  
1276         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1277     }
1278 
1279 }