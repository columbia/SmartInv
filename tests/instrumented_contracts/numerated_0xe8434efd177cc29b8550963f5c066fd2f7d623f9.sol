1 /*
2 
3     San-banme no bara
4 
5 */
6 
7 // SPDX-License-Identifier: Unlicensed   
8                                                                       
9 pragma solidity ^0.8.16;
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
89 interface IERC20 {
90     /**
91      * @dev Returns the amount of tokens in existence.
92      */
93     function totalSupply() external view returns (uint256);
94  
95     /**
96      * @dev Returns the amount of tokens owned by `account`.
97      */
98     function balanceOf(address account) external view returns (uint256);
99  
100     /**
101      * @dev Moves `amount` tokens from the caller's account to `recipient`.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transfer(address recipient, uint256 amount) external returns (bool);
108  
109     /**
110      * @dev Returns the remaining number of tokens that `spender` will be
111      * allowed to spend on behalf of `owner` through {transferFrom}. This is
112      * zero by default.
113      *
114      * This value changes when {approve} or {transferFrom} are called.
115      */
116     function allowance(address owner, address spender) external view returns (uint256);
117  
118     /**
119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133  
134     /**
135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
136      * allowance mechanism. `amount` is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148  
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156  
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163  
164 interface IERC20Metadata is IERC20 {
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() external view returns (string memory);
169  
170     /**
171      * @dev Returns the symbol of the token.
172      */
173     function symbol() external view returns (string memory);
174  
175     /**
176      * @dev Returns the decimals places of the token.
177      */
178     function decimals() external view returns (uint8);
179 }
180  
181  
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     using SafeMath for uint256;
184  
185     mapping(address => uint256) private _balances;
186  
187     mapping(address => mapping(address => uint256)) private _allowances;
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
237         return 18;
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
394      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
395      *
396      * This internal function is equivalent to `approve`, and can be used to
397      * e.g. set automatic allowances for certain subsystems, etc.
398      *
399      * Emits an {Approval} event.
400      *
401      * Requirements:
402      *
403      * - `owner` cannot be the zero address.
404      * - `spender` cannot be the zero address.
405      */
406     function _approve(
407         address owner,
408         address spender,
409         uint256 amount
410     ) internal virtual {
411         require(owner != address(0), "ERC20: approve from the zero address");
412         require(spender != address(0), "ERC20: approve to the zero address");
413  
414         _allowances[owner][spender] = amount;
415         emit Approval(owner, spender, amount);
416     }
417  
418     /**
419      * @dev Hook that is called before any transfer of tokens. This includes
420      * minting and burning.
421      *
422      * Calling conditions:
423      *
424      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
425      * will be to transferred to `to`.
426      * - when `from` is zero, `amount` tokens will be minted for `to`.
427      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
428      * - `from` and `to` are never both zero.
429      *
430      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
431      */
432     function _beforeTokenTransfer(
433         address from,
434         address to,
435         uint256 amount
436     ) internal virtual {}
437 }
438  
439 library SafeMath {
440     /**
441      * @dev Returns the addition of two unsigned integers, reverting on
442      * overflow.
443      *
444      * Counterpart to Solidity's `+` operator.
445      *
446      * Requirements:
447      *
448      * - Addition cannot overflow.
449      */
450     function add(uint256 a, uint256 b) internal pure returns (uint256) {
451         uint256 c = a + b;
452         require(c >= a, "SafeMath: addition overflow");
453  
454         return c;
455     }
456  
457     /**
458      * @dev Returns the subtraction of two unsigned integers, reverting on
459      * overflow (when the result is negative).
460      *
461      * Counterpart to Solidity's `-` operator.
462      *
463      * Requirements:
464      *
465      * - Subtraction cannot overflow.
466      */
467     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
468         return sub(a, b, "SafeMath: subtraction overflow");
469     }
470  
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
473      * overflow (when the result is negative).
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482         require(b <= a, errorMessage);
483         uint256 c = a - b;
484  
485         return c;
486     }
487  
488     /**
489      * @dev Returns the multiplication of two unsigned integers, reverting on
490      * overflow.
491      *
492      * Counterpart to Solidity's `*` operator.
493      *
494      * Requirements:
495      *
496      * - Multiplication cannot overflow.
497      */
498     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
499         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
500         // benefit is lost if 'b' is also tested.
501         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
502         if (a == 0) {
503             return 0;
504         }
505  
506         uint256 c = a * b;
507         require(c / a == b, "SafeMath: multiplication overflow");
508  
509         return c;
510     }
511  
512     /**
513      * @dev Returns the integer division of two unsigned integers. Reverts on
514      * division by zero. The result is rounded towards zero.
515      *
516      * Counterpart to Solidity's `/` operator. Note: this function uses a
517      * `revert` opcode (which leaves remaining gas untouched) while Solidity
518      * uses an invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function div(uint256 a, uint256 b) internal pure returns (uint256) {
525         return div(a, b, "SafeMath: division by zero");
526     }
527  
528     /**
529      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
530      * division by zero. The result is rounded towards zero.
531      *
532      * Counterpart to Solidity's `/` operator. Note: this function uses a
533      * `revert` opcode (which leaves remaining gas untouched) while Solidity
534      * uses an invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
541         require(b > 0, errorMessage);
542         uint256 c = a / b;
543         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
544  
545         return c;
546     }
547  
548     /**
549      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
550      * Reverts when dividing by zero.
551      *
552      * Counterpart to Solidity's `%` operator. This function uses a `revert`
553      * opcode (which leaves remaining gas untouched) while Solidity uses an
554      * invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
561         return mod(a, b, "SafeMath: modulo by zero");
562     }
563  
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * Reverts with custom message when dividing by zero.
567      *
568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
569      * opcode (which leaves remaining gas untouched) while Solidity uses an
570      * invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
577         require(b != 0, errorMessage);
578         return a % b;
579     }
580 }
581  
582 contract Ownable is Context {
583     address private _owner;
584  
585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
586  
587     /**
588      * @dev Initializes the contract setting the deployer as the initial owner.
589      */
590     constructor () {
591         address msgSender = _msgSender();
592         _owner = msgSender;
593         emit OwnershipTransferred(address(0), msgSender);
594     }
595  
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view returns (address) {
600         return _owner;
601     }
602  
603     /**
604      * @dev Throws if called by any account other than the owner.
605      */
606     modifier onlyOwner() {
607         require(_owner == _msgSender(), "Ownable: caller is not the owner");
608         _;
609     }
610  
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         emit OwnershipTransferred(_owner, address(0));
620         _owner = address(0);
621     }
622  
623     /**
624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
625      * Can only be called by the current owner.
626      */
627     function transferOwnership(address newOwner) public virtual onlyOwner {
628         require(newOwner != address(0), "Ownable: new owner is the zero address");
629         emit OwnershipTransferred(_owner, newOwner);
630         _owner = newOwner;
631     }
632 }
633  
634  
635  
636 library SafeMathInt {
637     int256 private constant MIN_INT256 = int256(1) << 255;
638     int256 private constant MAX_INT256 = ~(int256(1) << 255);
639  
640     /**
641      * @dev Multiplies two int256 variables and fails on overflow.
642      */
643     function mul(int256 a, int256 b) internal pure returns (int256) {
644         int256 c = a * b;
645  
646         // Detect overflow when multiplying MIN_INT256 with -1
647         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
648         require((b == 0) || (c / b == a));
649         return c;
650     }
651  
652     /**
653      * @dev Division of two int256 variables and fails on overflow.
654      */
655     function div(int256 a, int256 b) internal pure returns (int256) {
656         // Prevent overflow when dividing MIN_INT256 by -1
657         require(b != -1 || a != MIN_INT256);
658  
659         // Solidity already throws when dividing by 0.
660         return a / b;
661     }
662  
663     /**
664      * @dev Subtracts two int256 variables and fails on overflow.
665      */
666     function sub(int256 a, int256 b) internal pure returns (int256) {
667         int256 c = a - b;
668         require((b >= 0 && c <= a) || (b < 0 && c > a));
669         return c;
670     }
671  
672     /**
673      * @dev Adds two int256 variables and fails on overflow.
674      */
675     function add(int256 a, int256 b) internal pure returns (int256) {
676         int256 c = a + b;
677         require((b >= 0 && c >= a) || (b < 0 && c < a));
678         return c;
679     }
680  
681     /**
682      * @dev Converts to absolute value, and fails on overflow.
683      */
684     function abs(int256 a) internal pure returns (int256) {
685         require(a != MIN_INT256);
686         return a < 0 ? -a : a;
687     }
688  
689  
690     function toUint256Safe(int256 a) internal pure returns (uint256) {
691         require(a >= 0);
692         return uint256(a);
693     }
694 }
695  
696 library SafeMathUint {
697   function toInt256Safe(uint256 a) internal pure returns (int256) {
698     int256 b = int256(a);
699     require(b >= 0);
700     return b;
701   }
702 }
703  
704  
705 interface IUniswapV2Router01 {
706     function factory() external pure returns (address);
707     function WETH() external pure returns (address);
708  
709     function addLiquidity(
710         address tokenA,
711         address tokenB,
712         uint amountADesired,
713         uint amountBDesired,
714         uint amountAMin,
715         uint amountBMin,
716         address to,
717         uint deadline
718     ) external returns (uint amountA, uint amountB, uint liquidity);
719     function addLiquidityETH(
720         address token,
721         uint amountTokenDesired,
722         uint amountTokenMin,
723         uint amountETHMin,
724         address to,
725         uint deadline
726     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
727     function removeLiquidity(
728         address tokenA,
729         address tokenB,
730         uint liquidity,
731         uint amountAMin,
732         uint amountBMin,
733         address to,
734         uint deadline
735     ) external returns (uint amountA, uint amountB);
736     function removeLiquidityETH(
737         address token,
738         uint liquidity,
739         uint amountTokenMin,
740         uint amountETHMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountToken, uint amountETH);
744     function removeLiquidityWithPermit(
745         address tokenA,
746         address tokenB,
747         uint liquidity,
748         uint amountAMin,
749         uint amountBMin,
750         address to,
751         uint deadline,
752         bool approveMax, uint8 v, bytes32 r, bytes32 s
753     ) external returns (uint amountA, uint amountB);
754     function removeLiquidityETHWithPermit(
755         address token,
756         uint liquidity,
757         uint amountTokenMin,
758         uint amountETHMin,
759         address to,
760         uint deadline,
761         bool approveMax, uint8 v, bytes32 r, bytes32 s
762     ) external returns (uint amountToken, uint amountETH);
763     function swapExactTokensForTokens(
764         uint amountIn,
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline
769     ) external returns (uint[] memory amounts);
770     function swapTokensForExactTokens(
771         uint amountOut,
772         uint amountInMax,
773         address[] calldata path,
774         address to,
775         uint deadline
776     ) external returns (uint[] memory amounts);
777     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
778         external
779         payable
780         returns (uint[] memory amounts);
781     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
782         external
783         returns (uint[] memory amounts);
784     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
785         external
786         returns (uint[] memory amounts);
787     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
788         external
789         payable
790         returns (uint[] memory amounts);
791  
792     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
793     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
794     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
795     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
796     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
797 }
798  
799 interface IUniswapV2Router02 is IUniswapV2Router01 {
800     function removeLiquidityETHSupportingFeeOnTransferTokens(
801         address token,
802         uint liquidity,
803         uint amountTokenMin,
804         uint amountETHMin,
805         address to,
806         uint deadline
807     ) external returns (uint amountETH);
808     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
809         address token,
810         uint liquidity,
811         uint amountTokenMin,
812         uint amountETHMin,
813         address to,
814         uint deadline,
815         bool approveMax, uint8 v, bytes32 r, bytes32 s
816     ) external returns (uint amountETH);
817  
818     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
819         uint amountIn,
820         uint amountOutMin,
821         address[] calldata path,
822         address to,
823         uint deadline
824     ) external;
825     function swapExactETHForTokensSupportingFeeOnTransferTokens(
826         uint amountOutMin,
827         address[] calldata path,
828         address to,
829         uint deadline
830     ) external payable;
831     function swapExactTokensForETHSupportingFeeOnTransferTokens(
832         uint amountIn,
833         uint amountOutMin,
834         address[] calldata path,
835         address to,
836         uint deadline
837     ) external;
838 }
839  
840 contract BARA is ERC20, Ownable {
841     using SafeMath for uint256;
842  
843     IUniswapV2Router02 public immutable uniswapV2Router;
844     address public immutable uniswapV2Pair;
845  
846     bool private swapping;
847  
848     address private deployer;
849 
850     uint256 public swapTokensAtAmount;
851     uint256 public maxWallet;
852     uint256 public maxTx;
853  
854     bool public tradingActive = false;
855     bool public swapEnabled = false;
856     bool public limitsInEffect = true;
857 
858     // Anti-bot and anti-whale mappings and variables
859     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
860     bool public transferDelayEnabled = true;
861 
862     // Taxfree logic at launch
863     bool public taxfree = true;
864     uint256 private _tokenstoswap;
865     uint256 private _tokensForLiquidity;
866     uint256 private _tokensForTax;
867  
868     uint256 public TotalFees;
869     uint256 public LiquidityFee;
870     uint256 public TaxFee;
871        
872     /******************/
873  
874     // exclude from fees and max transaction amount
875     mapping (address => bool) public _isExcludedFromFees;
876  
877     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
878     // could be subject to a maximum transfer amount
879     mapping (address => bool) public automatedMarketMakerPairs;
880  
881     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
882  
883     event ExcludeFromFees(address indexed account, bool isExcluded);
884  
885     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
886  
887     event SwapAndLiquify(
888         uint256 tokensSwapped,
889         uint256 ethReceived,
890         uint256 tokensIntoLiquidity
891     );
892  
893     constructor() ERC20("The Final Thorn", "BARA") {
894  
895         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
896 
897         uniswapV2Router = _uniswapV2Router;
898  
899         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
900         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
901 		
902 		// fees
903         uint256 _LiquidityFee = 0;
904         uint256 _TaxFee = 333;
905  
906         uint256 totalSupply = 333333333 * 1e18;
907  
908         maxWallet = (totalSupply * 2) /100  * 1e18; // Max Wallet 2%
909         maxTx = (totalSupply * 2) / 100 * 1e18; // MaxTx 2%
910         swapTokensAtAmount = (totalSupply * 1) / 1000 * 1e18; // 0.1% swap threshold for the CA
911 
912         LiquidityFee = _LiquidityFee;
913         TaxFee = _TaxFee;
914         TotalFees = LiquidityFee + TaxFee;
915  
916         deployer = address(0x2aF9956fCF5af5EBdf9359562AB61714b7e587c9);         // set as deployer wallet
917          
918         // exclude from paying fees or having max transaction amount
919         _isExcludedFromFees[deployer] = true;
920         _isExcludedFromFees[address(this)] = true;
921         _isExcludedFromFees[address(0xdead)] = true;
922       
923         /*
924             _mint is an internal function in ERC20.sol that is only called here,
925             and CANNOT be called ever again
926         */
927         _mint(msg.sender, totalSupply / 100 * 67);      // 67% of supply
928         _mint(address(this), totalSupply / 100 * 33);   // 33% of supply for taxfree start
929     }
930  
931     receive() external payable {
932  
933     }
934 
935     // once enabled, can never be turned off
936     function enableTrading() external onlyOwner {
937         tradingActive = true;
938         swapEnabled = true;
939     }
940 
941     // remove maxtx after token is stable - cannot be set back
942     function removeMaxTx() external onlyOwner returns (bool) {
943         limitsInEffect = false;
944         return true;
945     }
946 
947     // disable Transfer delay - cannot be reenabled
948     function disableTransferDelay() external onlyOwner returns (bool) {
949         transferDelayEnabled = false;
950         return true;
951     }
952 
953     function _setAutomatedMarketMakerPair(address pair, bool value) private {
954         automatedMarketMakerPairs[pair] = value;
955  
956         emit SetAutomatedMarketMakerPair(pair, value);
957     }
958 
959     function _transfer(
960         address from,
961         address to,
962         uint256 amount
963     ) internal override {
964         require(from != address(0), "ERC20: transfer from the zero address");
965         require(to != address(0), "ERC20: transfer to the zero address");
966         
967         if (amount == 0) {
968             super._transfer(from, to, 0);
969             return;
970         }
971          
972         if (
973             from != owner() &&
974             to != owner() &&
975             to != address(0) &&
976             to != address(0xdead) &&
977             !swapping
978         ){
979             if(!tradingActive){
980                 require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
981             }
982 
983             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
984             if (transferDelayEnabled) {
985                 if (
986                     to != owner() &&
987                     to != address(uniswapV2Router) &&
988                     to != address(uniswapV2Pair)
989                 ) {
990                     require(
991                         _holderLastTransferTimestamp[tx.origin] <
992                             block.number,
993                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
994                     );
995                     _holderLastTransferTimestamp[tx.origin] = block.number;
996                 }
997             }
998                 
999             if (limitsInEffect) {
1000                 require(amount <= maxTx, "MaxTx exceeded");
1001             }
1002 
1003             //when buy
1004             if (automatedMarketMakerPairs[from]) {
1005                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1006             }
1007         }
1008         
1009         uint256 contractTokenBalance;
1010         
1011         if(taxfree) {
1012             contractTokenBalance = _tokenstoswap;
1013         } else {
1014             contractTokenBalance = balanceOf(address(this));
1015         }
1016 
1017         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1018  
1019         if( 
1020             canSwap &&
1021             swapEnabled &&
1022             !swapping &&
1023             !automatedMarketMakerPairs[from] &&
1024             !_isExcludedFromFees[from] &&
1025             !_isExcludedFromFees[to]
1026         ) {
1027             swapping = true;
1028             swapBack();
1029             swapping = false;
1030         }
1031  
1032         bool takeFee = !swapping;
1033 
1034         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1035         // if any account belongs to _isExcludedFromFee account then remove the fee
1036         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1037             takeFee = false;
1038         }
1039  
1040         uint256 fees = 0;
1041 
1042         // only take fees on buys/sells, do not take on wallet transfers
1043         if(takeFee){
1044             fees = amount.mul(TotalFees).div(10000);
1045             _tokensForLiquidity += fees * LiquidityFee / TotalFees;
1046             _tokensForTax += fees * TaxFee / TotalFees;
1047 			
1048             if (taxfree) {
1049                 _tokenstoswap += fees;
1050             }
1051 
1052             if(fees > 0 && !taxfree){    
1053                 super._transfer(from, address(this), fees);
1054                 amount -= fees;
1055             }
1056         }
1057  
1058         super._transfer(from, to, amount);
1059     }
1060  
1061     function swapTokensForEth(uint256 tokenAmount) private {
1062  
1063         // generate the uniswap pair path of token -> weth
1064         address[] memory path = new address[](2);
1065         path[0] = address(this);
1066         path[1] = uniswapV2Router.WETH();
1067  
1068         _approve(address(this), address(uniswapV2Router), tokenAmount);
1069  
1070         // make the swap
1071         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1072             tokenAmount,
1073             0, // accept any amount of ETH
1074             path,
1075             deployer,
1076             block.timestamp
1077         );
1078  
1079     }
1080  
1081     function swapBack() private {
1082         uint256 contractBalance;
1083         
1084         if (taxfree) {
1085             if (_tokenstoswap > balanceOf(address(this))) {
1086                 // Preloaded tokens are sold out
1087                 _tokensForLiquidity = 0;
1088                 contractBalance = balanceOf(address(this));
1089                 taxfree = false;
1090                 TaxFee = 0;
1091                 TotalFees = 0;
1092             } else {
1093                 contractBalance = _tokensForTax;
1094             }
1095         } else {
1096             contractBalance = balanceOf(address(this));
1097         }
1098 
1099  
1100         if(contractBalance == 0) {return;}
1101  
1102         if(contractBalance > swapTokensAtAmount * 20){
1103            contractBalance = swapTokensAtAmount * 20;
1104           }
1105     
1106         // Spiral auto lp concept, transfer tokens directly to the Pair
1107         if (_tokensForLiquidity > 0) {
1108             super._transfer(address(this), uniswapV2Pair, _tokensForLiquidity);
1109             if (!taxfree) {
1110                 contractBalance = contractBalance.sub(_tokensForLiquidity);
1111             }
1112         }
1113         
1114         swapTokensForEth(contractBalance);
1115 
1116         _tokensForTax = 0;
1117         _tokensForLiquidity = 0;
1118         _tokenstoswap = 0;
1119 
1120 	}
1121 	
1122 }