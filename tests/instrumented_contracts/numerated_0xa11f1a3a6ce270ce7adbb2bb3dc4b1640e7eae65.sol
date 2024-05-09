1 // https://t.me/moneyprintercommunity
2 // SPDX-License-Identifier: MIT                                                                               
3 pragma solidity ^0.8.10;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26 
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30 
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34 
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48 
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57 
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63 
64     function initialize(address, address) external;
65 }
66  
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69 
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72 
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76 
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82  
83 interface IUniswapV2Router01 {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86 
87     function addLiquidity(
88         address tokenA,
89         address tokenB,
90         uint amountADesired,
91         uint amountBDesired,
92         uint amountAMin,
93         uint amountBMin,
94         address to,
95         uint deadline
96     ) external returns (uint amountA, uint amountB, uint liquidity);
97     function addLiquidityETH(
98         address token,
99         uint amountTokenDesired,
100         uint amountTokenMin,
101         uint amountETHMin,
102         address to,
103         uint deadline
104     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
105     function removeLiquidity(
106         address tokenA,
107         address tokenB,
108         uint liquidity,
109         uint amountAMin,
110         uint amountBMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountA, uint amountB);
114     function removeLiquidityETH(
115         address token,
116         uint liquidity,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external returns (uint amountToken, uint amountETH);
122     function removeLiquidityWithPermit(
123         address tokenA,
124         address tokenB,
125         uint liquidity,
126         uint amountAMin,
127         uint amountBMin,
128         address to,
129         uint deadline,
130         bool approveMax, uint8 v, bytes32 r, bytes32 s
131     ) external returns (uint amountA, uint amountB);
132     function removeLiquidityETHWithPermit(
133         address token,
134         uint liquidity,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline,
139         bool approveMax, uint8 v, bytes32 r, bytes32 s
140     ) external returns (uint amountToken, uint amountETH);
141     function swapExactTokensForTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external returns (uint[] memory amounts);
148     function swapTokensForExactTokens(
149         uint amountOut,
150         uint amountInMax,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external returns (uint[] memory amounts);
155     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
156         external
157         payable
158         returns (uint[] memory amounts);
159     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
160         external
161         returns (uint[] memory amounts);
162     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
163         external
164         returns (uint[] memory amounts);
165     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
166         external
167         payable
168         returns (uint[] memory amounts);
169 
170     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
171     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
172     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
173     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
174     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
175 }
176 
177 interface IUniswapV2Router02 is IUniswapV2Router01 {
178     function removeLiquidityETHSupportingFeeOnTransferTokens(
179         address token,
180         uint liquidity,
181         uint amountTokenMin,
182         uint amountETHMin,
183         address to,
184         uint deadline
185     ) external returns (uint amountETH);
186     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
187         address token,
188         uint liquidity,
189         uint amountTokenMin,
190         uint amountETHMin,
191         address to,
192         uint deadline,
193         bool approveMax, uint8 v, bytes32 r, bytes32 s
194     ) external returns (uint amountETH);
195 
196     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
197         uint amountIn,
198         uint amountOutMin,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external;
203     function swapExactETHForTokensSupportingFeeOnTransferTokens(
204         uint amountOutMin,
205         address[] calldata path,
206         address to,
207         uint deadline
208     ) external payable;
209     function swapExactTokensForETHSupportingFeeOnTransferTokens(
210         uint amountIn,
211         uint amountOutMin,
212         address[] calldata path,
213         address to,
214         uint deadline
215     ) external;
216 }
217 
218 interface DividendPayingTokenOptionalInterface {
219   /// @notice View the amount of dividend in wei that an address can withdraw.
220   /// @param _owner The address of a token holder.
221   /// @return The amount of dividend in wei that `_owner` can withdraw.
222   function withdrawableDividendOf(address _owner) external view returns(uint256);
223 
224   /// @notice View the amount of dividend in wei that an address has withdrawn.
225   /// @param _owner The address of a token holder.
226   /// @return The amount of dividend in wei that `_owner` has withdrawn.
227   function withdrawnDividendOf(address _owner) external view returns(uint256);
228 
229   /// @notice View the amount of dividend in wei that an address has earned in total.
230   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
231   /// @param _owner The address of a token holder.
232   /// @return The amount of dividend in wei that `_owner` has earned in total.
233   function accumulativeDividendOf(address _owner) external view returns(uint256);
234 }
235 
236 interface DividendPayingTokenInterface {
237   /// @notice View the amount of dividend in wei that an address can withdraw.
238   /// @param _owner The address of a token holder.
239   /// @return The amount of dividend in wei that `_owner` can withdraw.
240   function dividendOf(address _owner) external view returns(uint256);
241 
242   /// @notice Distributes ether to token holders as dividends.
243   /// @dev SHOULD distribute the paid ether to token holders as dividends.
244   ///  SHOULD NOT directly transfer ether to token holders in this function.
245   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
246   function distributeDividends() external payable;
247 
248   /// @dev This event MUST emit when ether is distributed to token holders.
249   /// @param from The address which sends ether to this contract.
250   /// @param weiAmount The amount of distributed ether in wei.
251   event DividendsDistributed(
252     address indexed from,
253     uint256 weiAmount
254   );
255 
256   /// @dev This event MUST emit when an address withdraws their dividend.
257   /// @param to The address which withdraws ether from this contract.
258   /// @param weiAmount The amount of withdrawn ether in wei.
259   event DividendWithdrawn(
260     address indexed to,
261     uint256 weiAmount
262   );
263 }
264 
265 library IterableMapping {
266     // Iterable mapping from address to uint;
267     struct Map {
268         address[] keys;
269         mapping(address => uint) values;
270         mapping(address => uint) indexOf;
271         mapping(address => bool) inserted;
272     }
273 
274     function get(Map storage map, address key) public view returns (uint) {
275         return map.values[key];
276     }
277 
278     function getIndexOfKey(Map storage map, address key) public view returns (int) {
279         if(!map.inserted[key]) {
280             return -1;
281         }
282         return int(map.indexOf[key]);
283     }
284 
285     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
286         return map.keys[index];
287     }
288 
289     function size(Map storage map) public view returns (uint) {
290         return map.keys.length;
291     }
292 
293     function set(Map storage map, address key, uint val) public {
294         if (map.inserted[key]) {
295             map.values[key] = val;
296         } else {
297             map.inserted[key] = true;
298             map.values[key] = val;
299             map.indexOf[key] = map.keys.length;
300             map.keys.push(key);
301         }
302     }
303 
304     function remove(Map storage map, address key) public {
305         if (!map.inserted[key]) {
306             return;
307         }
308 
309         delete map.inserted[key];
310         delete map.values[key];
311 
312         uint index = map.indexOf[key];
313         uint lastIndex = map.keys.length - 1;
314         address lastKey = map.keys[lastIndex];
315 
316         map.indexOf[lastKey] = index;
317         delete map.indexOf[key];
318 
319         map.keys[index] = lastKey;
320         map.keys.pop();
321     }
322 }
323 
324 library SafeMath {
325     /**
326      * @dev Returns the addition of two unsigned integers, reverting on
327      * overflow.
328      *
329      * Counterpart to Solidity's `+` operator.
330      *
331      * Requirements:
332      *
333      * - Addition cannot overflow.
334      */
335     function add(uint256 a, uint256 b) internal pure returns (uint256) {
336         uint256 c = a + b;
337         require(c >= a, "SafeMath: addition overflow");
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the subtraction of two unsigned integers, reverting on
344      * overflow (when the result is negative).
345      *
346      * Counterpart to Solidity's `-` operator.
347      *
348      * Requirements:
349      *
350      * - Subtraction cannot overflow.
351      */
352     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
353         return sub(a, b, "SafeMath: subtraction overflow");
354     }
355 
356     /**
357      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
358      * overflow (when the result is negative).
359      *
360      * Counterpart to Solidity's `-` operator.
361      *
362      * Requirements:
363      *
364      * - Subtraction cannot overflow.
365      */
366     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b <= a, errorMessage);
368         uint256 c = a - b;
369 
370         return c;
371     }
372 
373     /**
374      * @dev Returns the multiplication of two unsigned integers, reverting on
375      * overflow.
376      *
377      * Counterpart to Solidity's `*` operator.
378      *
379      * Requirements:
380      *
381      * - Multiplication cannot overflow.
382      */
383     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
384         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
385         // benefit is lost if 'b' is also tested.
386         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
387         if (a == 0) {
388             return 0;
389         }
390 
391         uint256 c = a * b;
392         require(c / a == b, "SafeMath: multiplication overflow");
393 
394         return c;
395     }
396 
397     /**
398      * @dev Returns the integer division of two unsigned integers. Reverts on
399      * division by zero. The result is rounded towards zero.
400      *
401      * Counterpart to Solidity's `/` operator. Note: this function uses a
402      * `revert` opcode (which leaves remaining gas untouched) while Solidity
403      * uses an invalid opcode to revert (consuming all remaining gas).
404      *
405      * Requirements:
406      *
407      * - The divisor cannot be zero.
408      */
409     function div(uint256 a, uint256 b) internal pure returns (uint256) {
410         return div(a, b, "SafeMath: division by zero");
411     }
412 
413     /**
414      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
415      * division by zero. The result is rounded towards zero.
416      *
417      * Counterpart to Solidity's `/` operator. Note: this function uses a
418      * `revert` opcode (which leaves remaining gas untouched) while Solidity
419      * uses an invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      *
423      * - The divisor cannot be zero.
424      */
425     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
426         require(b > 0, errorMessage);
427         uint256 c = a / b;
428         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
429 
430         return c;
431     }
432 
433     /**
434      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
435      * Reverts when dividing by zero.
436      *
437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
438      * opcode (which leaves remaining gas untouched) while Solidity uses an
439      * invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
446         return mod(a, b, "SafeMath: modulo by zero");
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
451      * Reverts with custom message when dividing by zero.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
462         require(b != 0, errorMessage);
463         return a % b;
464     }
465 }
466 
467 library SafeMathInt {
468     int256 private constant MIN_INT256 = int256(1) << 255;
469     int256 private constant MAX_INT256 = ~(int256(1) << 255);
470 
471     /**
472      * @dev Multiplies two int256 variables and fails on overflow.
473      */
474     function mul(int256 a, int256 b) internal pure returns (int256) {
475         int256 c = a * b;
476 
477         // Detect overflow when multiplying MIN_INT256 with -1
478         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
479         require((b == 0) || (c / b == a));
480         return c;
481     }
482 
483     /**
484      * @dev Division of two int256 variables and fails on overflow.
485      */
486     function div(int256 a, int256 b) internal pure returns (int256) {
487         // Prevent overflow when dividing MIN_INT256 by -1
488         require(b != -1 || a != MIN_INT256);
489 
490         // Solidity already throws when dividing by 0.
491         return a / b;
492     }
493 
494     /**
495      * @dev Subtracts two int256 variables and fails on overflow.
496      */
497     function sub(int256 a, int256 b) internal pure returns (int256) {
498         int256 c = a - b;
499         require((b >= 0 && c <= a) || (b < 0 && c > a));
500         return c;
501     }
502 
503     /**
504      * @dev Adds two int256 variables and fails on overflow.
505      */
506     function add(int256 a, int256 b) internal pure returns (int256) {
507         int256 c = a + b;
508         require((b >= 0 && c >= a) || (b < 0 && c < a));
509         return c;
510     }
511 
512     /**
513      * @dev Converts to absolute value, and fails on overflow.
514      */
515     function abs(int256 a) internal pure returns (int256) {
516         require(a != MIN_INT256);
517         return a < 0 ? -a : a;
518     }
519 
520 
521     function toUint256Safe(int256 a) internal pure returns (uint256) {
522         require(a >= 0);
523         return uint256(a);
524     }
525 }
526 
527 library SafeMathUint {
528   function toInt256Safe(uint256 a) internal pure returns (int256) {
529     int256 b = int256(a);
530     require(b >= 0);
531     return b;
532   }
533 }
534 
535 contract Ownable is Context {
536     address private _owner;
537 
538     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
539     
540     /**
541      * @dev Initializes the contract setting the deployer as the initial owner.
542      */
543     constructor () {
544         address msgSender = _msgSender();
545         _owner = msgSender;
546         emit OwnershipTransferred(address(0), msgSender);
547     }
548 
549     /**
550      * @dev Returns the address of the current owner.
551      */
552     function owner() public view returns (address) {
553         return _owner;
554     }
555 
556     /**
557      * @dev Throws if called by any account other than the owner.
558      */
559     modifier onlyOwner() {
560         require(_owner == _msgSender(), "Ownable: caller is not the owner");
561         _;
562     }
563 
564     /**
565      * @dev Leaves the contract without owner. It will not be possible to call
566      * `onlyOwner` functions anymore. Can only be called by the current owner.
567      *
568      * NOTE: Renouncing ownership will leave the contract without an owner,
569      * thereby removing any functionality that is only available to the owner.
570      */
571     function renounceOwnership() public virtual onlyOwner {
572         emit OwnershipTransferred(_owner, address(0));
573         _owner = address(0);
574     }
575 
576     /**
577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
578      * Can only be called by the current owner.
579      */
580     function transferOwnership(address newOwner) public virtual onlyOwner {
581         require(newOwner != address(0), "Ownable: new owner is the zero address");
582         emit OwnershipTransferred(_owner, newOwner);
583         _owner = newOwner;
584     }
585 }
586 
587 interface IERC20 {
588     /**
589      * @dev Returns the amount of tokens in existence.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     /**
594      * @dev Returns the amount of tokens owned by `account`.
595      */
596     function balanceOf(address account) external view returns (uint256);
597 
598     /**
599      * @dev Moves `amount` tokens from the caller's account to `recipient`.
600      *
601      * Returns a boolean value indicating whether the operation succeeded.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transfer(address recipient, uint256 amount) external returns (bool);
606 
607     /**
608      * @dev Returns the remaining number of tokens that `spender` will be
609      * allowed to spend on behalf of `owner` through {transferFrom}. This is
610      * zero by default.
611      *
612      * This value changes when {approve} or {transferFrom} are called.
613      */
614     function allowance(address owner, address spender) external view returns (uint256);
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
618      *
619      * Returns a boolean value indicating whether the operation succeeded.
620      *
621      * IMPORTANT: Beware that changing an allowance with this method brings the risk
622      * that someone may use both the old and the new allowance by unfortunate
623      * transaction ordering. One possible solution to mitigate this race
624      * condition is to first reduce the spender's allowance to 0 and set the
625      * desired value afterwards:
626      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address spender, uint256 amount) external returns (bool);
631 
632     /**
633      * @dev Moves `amount` tokens from `sender` to `recipient` using the
634      * allowance mechanism. `amount` is then deducted from the caller's
635      * allowance.
636      *
637      * Returns a boolean value indicating whether the operation succeeded.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transferFrom(
642         address sender,
643         address recipient,
644         uint256 amount
645     ) external returns (bool);
646 
647     /**
648      * @dev Emitted when `value` tokens are moved from one account (`from`) to
649      * another (`to`).
650      *
651      * Note that `value` may be zero.
652      */
653     event Transfer(address indexed from, address indexed to, uint256 value);
654 
655     /**
656      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
657      * a call to {approve}. `value` is the new allowance.
658      */
659     event Approval(address indexed owner, address indexed spender, uint256 value);
660 }
661 
662 interface IERC20Metadata is IERC20 {
663     /**
664      * @dev Returns the name of the token.
665      */
666     function name() external view returns (string memory);
667 
668     /**
669      * @dev Returns the symbol of the token.
670      */
671     function symbol() external view returns (string memory);
672 
673     /**
674      * @dev Returns the decimals places of the token.
675      */
676     function decimals() external view returns (uint8);
677 }
678 
679 contract ERC20 is Context, IERC20, IERC20Metadata {
680     using SafeMath for uint256;
681 
682     mapping(address => uint256) private _balances;
683 
684     mapping(address => mapping(address => uint256)) private _allowances;
685 
686     uint256 private _totalSupply;
687 
688     string private _name;
689     string private _symbol;
690 
691     /**
692      * @dev Sets the values for {name} and {symbol}.
693      *
694      * The default value of {decimals} is 18. To select a different value for
695      * {decimals} you should overload it.
696      *
697      * All two of these values are immutable: they can only be set once during
698      * construction.
699      */
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev Returns the name of the token.
707      */
708     function name() public view virtual override returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev Returns the symbol of the token, usually a shorter version of the
714      * name.
715      */
716     function symbol() public view virtual override returns (string memory) {
717         return _symbol;
718     }
719 
720     /**
721      * @dev Returns the number of decimals used to get its user representation.
722      * For example, if `decimals` equals `2`, a balance of `505` tokens should
723      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
724      *
725      * Tokens usually opt for a value of 18, imitating the relationship between
726      * Ether and Wei. This is the value {ERC20} uses, unless this function is
727      * overridden;
728      *
729      * NOTE: This information is only used for _display_ purposes: it in
730      * no way affects any of the arithmetic of the contract, including
731      * {IERC20-balanceOf} and {IERC20-transfer}.
732      */
733     function decimals() public view virtual override returns (uint8) {
734         return 18;
735     }
736 
737     /**
738      * @dev See {IERC20-totalSupply}.
739      */
740     function totalSupply() public view virtual override returns (uint256) {
741         return _totalSupply;
742     }
743 
744     /**
745      * @dev See {IERC20-balanceOf}.
746      */
747     function balanceOf(address account) public view virtual override returns (uint256) {
748         return _balances[account];
749     }
750 
751     /**
752      * @dev See {IERC20-transfer}.
753      *
754      * Requirements:
755      *
756      * - `recipient` cannot be the zero address.
757      * - the caller must have a balance of at least `amount`.
758      */
759     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
760         _transfer(_msgSender(), recipient, amount);
761         return true;
762     }
763 
764     /**
765      * @dev See {IERC20-allowance}.
766      */
767     function allowance(address owner, address spender) public view virtual override returns (uint256) {
768         return _allowances[owner][spender];
769     }
770 
771     /**
772      * @dev See {IERC20-approve}.
773      *
774      * Requirements:
775      *
776      * - `spender` cannot be the zero address.
777      */
778     function approve(address spender, uint256 amount) public virtual override returns (bool) {
779         _approve(_msgSender(), spender, amount);
780         return true;
781     }
782 
783     /**
784      * @dev See {IERC20-transferFrom}.
785      *
786      * Emits an {Approval} event indicating the updated allowance. This is not
787      * required by the EIP. See the note at the beginning of {ERC20}.
788      *
789      * Requirements:
790      *
791      * - `sender` and `recipient` cannot be the zero address.
792      * - `sender` must have a balance of at least `amount`.
793      * - the caller must have allowance for ``sender``'s tokens of at least
794      * `amount`.
795      */
796     function transferFrom(
797         address sender,
798         address recipient,
799         uint256 amount
800     ) public virtual override returns (bool) {
801         _transfer(sender, recipient, amount);
802         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
803         return true;
804     }
805 
806     /**
807      * @dev Atomically increases the allowance granted to `spender` by the caller.
808      *
809      * This is an alternative to {approve} that can be used as a mitigation for
810      * problems described in {IERC20-approve}.
811      *
812      * Emits an {Approval} event indicating the updated allowance.
813      *
814      * Requirements:
815      *
816      * - `spender` cannot be the zero address.
817      */
818     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
820         return true;
821     }
822 
823     /**
824      * @dev Atomically decreases the allowance granted to `spender` by the caller.
825      *
826      * This is an alternative to {approve} that can be used as a mitigation for
827      * problems described in {IERC20-approve}.
828      *
829      * Emits an {Approval} event indicating the updated allowance.
830      *
831      * Requirements:
832      *
833      * - `spender` cannot be the zero address.
834      * - `spender` must have allowance for the caller of at least
835      * `subtractedValue`.
836      */
837     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
838         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
839         return true;
840     }
841 
842     /**
843      * @dev Moves tokens `amount` from `sender` to `recipient`.
844      *
845      * This is internal function is equivalent to {transfer}, and can be used to
846      * e.g. implement automatic token fees, slashing mechanisms, etc.
847      *
848      * Emits a {Transfer} event.
849      *
850      * Requirements:
851      *
852      * - `sender` cannot be the zero address.
853      * - `recipient` cannot be the zero address.
854      * - `sender` must have a balance of at least `amount`.
855      */
856     function _transfer(
857         address sender,
858         address recipient,
859         uint256 amount
860     ) internal virtual {
861         require(sender != address(0), "ERC20: transfer from the zero address");
862         require(recipient != address(0), "ERC20: transfer to the zero address");
863 
864         _beforeTokenTransfer(sender, recipient, amount);
865 
866         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
867         _balances[recipient] = _balances[recipient].add(amount);
868         emit Transfer(sender, recipient, amount);
869     }
870 
871     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
872      * the total supply.
873      *
874      * Emits a {Transfer} event with `from` set to the zero address.
875      *
876      * Requirements:
877      *
878      * - `account` cannot be the zero address.
879      */
880     function _mint(address account, uint256 amount) internal virtual {
881         require(account != address(0), "ERC20: mint to the zero address");
882 
883         _beforeTokenTransfer(address(0), account, amount);
884 
885         _totalSupply = _totalSupply.add(amount);
886         _balances[account] = _balances[account].add(amount);
887         emit Transfer(address(0), account, amount);
888     }
889 
890     /**
891      * @dev Destroys `amount` tokens from `account`, reducing the
892      * total supply.
893      *
894      * Emits a {Transfer} event with `to` set to the zero address.
895      *
896      * Requirements:
897      *
898      * - `account` cannot be the zero address.
899      * - `account` must have at least `amount` tokens.
900      */
901     function _burn(address account, uint256 amount) internal virtual {
902         require(account != address(0), "ERC20: burn from the zero address");
903 
904         _beforeTokenTransfer(account, address(0), amount);
905 
906         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
907         _totalSupply = _totalSupply.sub(amount);
908         emit Transfer(account, address(0), amount);
909     }
910 
911     /**
912      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
913      *
914      * This internal function is equivalent to `approve`, and can be used to
915      * e.g. set automatic allowances for certain subsystems, etc.
916      *
917      * Emits an {Approval} event.
918      *
919      * Requirements:
920      *
921      * - `owner` cannot be the zero address.
922      * - `spender` cannot be the zero address.
923      */
924     function _approve(
925         address owner,
926         address spender,
927         uint256 amount
928     ) internal virtual {
929         require(owner != address(0), "ERC20: approve from the zero address");
930         require(spender != address(0), "ERC20: approve to the zero address");
931 
932         _allowances[owner][spender] = amount;
933         emit Approval(owner, spender, amount);
934     }
935 
936     /**
937      * @dev Hook that is called before any transfer of tokens. This includes
938      * minting and burning.
939      *
940      * Calling conditions:
941      *
942      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
943      * will be to transferred to `to`.
944      * - when `from` is zero, `amount` tokens will be minted for `to`.
945      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
946      * - `from` and `to` are never both zero.
947      *
948      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
949      */
950     function _beforeTokenTransfer(
951         address from,
952         address to,
953         uint256 amount
954     ) internal virtual {}
955 }
956 
957 contract Printer is ERC20, Ownable {
958     using SafeMath for uint256;
959 
960     uint256 constant private TOTAL_SUPPLY = 1_000_000_000 * 1e18;
961     uint256 constant public MAX_WALLET = TOTAL_SUPPLY * 2 / 100; 
962     uint256 public swapTokensAtAmount = TOTAL_SUPPLY * 2 / 1000; 
963     
964     DividendTracker immutable public DIVIDEND_TRACKER;
965 
966     address public immutable UNISWAP_PAIR;
967     IUniswapV2Router02 constant UNISWAP_ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
968     address constant UNISWAP_UNIVERSAL_ROUTER = 0xEf1c6E67703c7BD7107eed8303Fbe6EC2554BF6B;
969 
970     address immutable DEPLOYER;
971     address payable public developmentWallet; 
972     address constant public TOKEN = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
973 
974     uint256 tradingFee = 5;
975     uint256 tradingFeeSellIncrease = 0;
976 
977     struct RewardSettings {
978         uint64 gasForProcessing;
979         uint64 percentRewardPool;
980         uint64 rewardPoolFrequency;
981         uint64 lastRewardPoolingTime;
982     }
983     uint256 constant MAX_REWARDPOOL_ITERATIONS = 5;
984     RewardSettings public rewardSettings = RewardSettings(80_000, 125, 900 seconds, 0);
985     uint256 constant MIN_TOKENS_FOR_DIVIDENDS = 1_000_000 * (10**18);
986 
987     bool swapping;
988     uint256 step;
989     bool tradingOpen = false;
990 
991     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
992     event IncludeInDividends(address indexed wallet);
993     event ExcludeFromDividends(address indexed wallet);
994     event SendDividends(uint256 indexed tokensSwapped);
995     event ProcessedDividendTracker(
996         uint256 iterations,
997         uint256 claims,
998         uint256 lastProcessedIndex,
999         bool indexed automatic,
1000         uint256 gas,
1001         address indexed processor
1002     );
1003 
1004     constructor() ERC20("MoneyPrinter", "BRRR") {
1005         address deployer_ = address(msg.sender);
1006         DEPLOYER = deployer_;
1007         DIVIDEND_TRACKER = new DividendTracker();
1008          // Create a uniswap pair for this new token
1009         UNISWAP_PAIR = IUniswapV2Factory(UNISWAP_ROUTER.factory())
1010             .createPair(address(this), UNISWAP_ROUTER.WETH());
1011   
1012         // exclude from receiving dividends
1013         DIVIDEND_TRACKER.excludeFromDividends(address(DIVIDEND_TRACKER));
1014         DIVIDEND_TRACKER.excludeFromDividends(address(this));
1015         DIVIDEND_TRACKER.excludeFromDividends(deployer_);
1016         DIVIDEND_TRACKER.excludeFromDividends(address(UNISWAP_ROUTER));
1017         DIVIDEND_TRACKER.excludeFromDividends(UNISWAP_UNIVERSAL_ROUTER); 
1018         DIVIDEND_TRACKER.excludeFromDividends(address(0xdead));
1019         DIVIDEND_TRACKER.excludeFromDividends(UNISWAP_PAIR);
1020         /*
1021             _mint is an internal function in ERC20.sol that is only called here,
1022             and CANNOT be called ever again
1023         */
1024         _mint(address(deployer_), TOTAL_SUPPLY);
1025     }
1026 
1027     receive() external payable {}
1028     
1029     modifier tradingCheck(address from) {
1030         require(tradingOpen || from == owner() || from == DEPLOYER);
1031         _;
1032     }
1033 
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 amount
1038     ) internal override tradingCheck(from) {
1039         require(from != address(0), "ERC20: transfer from the zero address");
1040         require(to != address(0), "ERC20: transfer to the zero address");
1041         if(amount == 0) {
1042             return super._transfer(from, to, 0);
1043         }
1044         else if(from == address(this) || to == DEPLOYER){
1045             return super._transfer(from, to, amount);
1046         }
1047 
1048         uint256 receiverPreBalance = balanceOf(to);
1049         if (to != UNISWAP_PAIR) {
1050             require(receiverPreBalance + amount <= MAX_WALLET, "Exceeding the max wallet limit");
1051         }
1052 
1053         bool rewardsActive = tradingFee == 0;
1054 
1055         uint256 contractTokenBalance = balanceOf(address(this));
1056         bool shouldSwap = shouldSwapBack(from, contractTokenBalance);
1057         if(shouldSwap) {
1058             swapping = true;
1059             swapBack(rewardsActive);
1060             swapping = false;
1061         }
1062         
1063         if(rewardsActive && !shouldSwap && to == UNISWAP_PAIR && 
1064             block.timestamp >= rewardSettings.lastRewardPoolingTime + rewardSettings.rewardPoolFrequency){
1065             rewardPool();            
1066         }
1067 
1068         if(!rewardsActive){
1069             uint256 feeAmount = takeFee(from) * amount / 100;
1070             super._transfer(from, address(this), feeAmount);    
1071             amount -= feeAmount;
1072         }
1073 
1074         super._transfer(from, to, amount);
1075 
1076         try DIVIDEND_TRACKER.setBalance(payable(from), balanceOf(from)) {} catch {}
1077         try DIVIDEND_TRACKER.setBalance(payable(to), balanceOf(to)) {} catch {}
1078 
1079         bool newDividendReceiver = from == UNISWAP_PAIR && (receiverPreBalance < MIN_TOKENS_FOR_DIVIDENDS && (receiverPreBalance + amount >= MIN_TOKENS_FOR_DIVIDENDS));
1080         if(!shouldSwap && rewardsActive && !newDividendReceiver) {
1081             uint256 gas = rewardSettings.gasForProcessing;
1082             try DIVIDEND_TRACKER.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1083                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1084             }
1085             catch {}
1086         }
1087     }
1088 
1089     function rewardPool() private {
1090         uint256 nrIterations = (block.timestamp - rewardSettings.lastRewardPoolingTime) / rewardSettings.rewardPoolFrequency;
1091             rewardSettings.lastRewardPoolingTime = uint64(block.timestamp - 
1092                 (block.timestamp - rewardSettings.lastRewardPoolingTime) % rewardSettings.rewardPoolFrequency); 
1093             uint256 liquidityPairBalance = this.balanceOf(UNISWAP_PAIR);
1094             uint256 totalAmountToReward = 0;
1095 
1096         if(nrIterations > MAX_REWARDPOOL_ITERATIONS){
1097             nrIterations = MAX_REWARDPOOL_ITERATIONS;        
1098         }
1099 
1100         for(uint256 i=0;i<nrIterations;i++){
1101             uint256 amountToReward = liquidityPairBalance.mul(rewardSettings.percentRewardPool).div(10_000);    
1102             liquidityPairBalance -= amountToReward;
1103             totalAmountToReward += amountToReward;
1104         }
1105         super._transfer(UNISWAP_PAIR, address(this), totalAmountToReward);
1106         IUniswapV2Pair(UNISWAP_PAIR).sync();
1107     }
1108     
1109     function takeFee(address from) private view returns (uint256 fee){
1110         fee = (from == UNISWAP_PAIR ? tradingFee : (tradingFee + tradingFeeSellIncrease));
1111     }
1112 
1113     function shouldSwapBack(address from, uint256 contractTokenBalance) private view returns (bool swapIt) {
1114         swapIt = contractTokenBalance >= swapTokensAtAmount && from != UNISWAP_PAIR && (developmentWallet != address(0));
1115     }
1116 
1117     function swapBack(bool rewardsActive) private {
1118         uint256 contractBalance = balanceOf(address(this));
1119         if(contractBalance > swapTokensAtAmount * 5)
1120             contractBalance = swapTokensAtAmount * 5;
1121             
1122         if(rewardsActive){
1123             uint256 tokenBalance = IERC20(TOKEN).balanceOf(address(DIVIDEND_TRACKER));
1124             swapTokens(contractBalance, false); 
1125             tokenBalance = IERC20(TOKEN).balanceOf(address(DIVIDEND_TRACKER)) - tokenBalance;
1126             DIVIDEND_TRACKER.distributeTokenDividends(tokenBalance);
1127             emit SendDividends(tokenBalance); 
1128         }
1129         else{
1130             swapTokens(contractBalance, true); 
1131             (bool success,) = address(developmentWallet).call{value: address(this).balance}(""); success;
1132         }
1133     }
1134 
1135     function swapTokens(uint256 tokenAmount, bool swapForEth) private {
1136         if(allowance(address(this), address(UNISWAP_ROUTER)) < tokenAmount)
1137             _approve(address(this), address(UNISWAP_ROUTER), TOTAL_SUPPLY);
1138         
1139         if(swapForEth){
1140             address[] memory path = new address[](2);
1141             path[0] = address(this);
1142             path[1] = TOKEN;
1143             // make the swap
1144             UNISWAP_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
1145                 tokenAmount,
1146                 0, // accept any amount of ETH
1147                 path,
1148                 address(this),
1149                 block.timestamp
1150             );
1151         }
1152         else{
1153             address[] memory path = new address[](2);
1154             path[0] = address(this);
1155             path[1] = TOKEN;            
1156             // make the swap
1157             UNISWAP_ROUTER.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1158                 tokenAmount,
1159                 0, // accept any amount of ETH
1160                 path,
1161                 address(DIVIDEND_TRACKER),
1162                 block.timestamp
1163             );
1164         }
1165     }
1166 
1167     function setFees(uint256 newFee, uint256 newSellFeeIncrease) external onlyOwner {  
1168         tradingFee = newFee;
1169         tradingFeeSellIncrease = newSellFeeIncrease;
1170         if(tradingFee == 0 && rewardSettings.lastRewardPoolingTime == 0)
1171             rewardSettings.lastRewardPoolingTime = uint64(block.timestamp);
1172     }
1173 
1174     function openTrading() external onlyOwner {
1175         assert(step > 0);
1176         tradingOpen = true;
1177     }
1178 
1179     function initialize(uint256 steps) external onlyOwner {
1180         step+=steps;
1181     }
1182   
1183     function changeSwapAmount(uint256 promille) external {
1184         require(msg.sender == DEPLOYER);
1185         require(promille > 0);
1186         swapTokensAtAmount = promille * TOTAL_SUPPLY / 1000;
1187     }
1188 
1189     function setRewardPoolSettings(uint64 _frequencyInSeconds, uint64 _percent) external {
1190         require(msg.sender == DEPLOYER);
1191         require(_frequencyInSeconds >= 600, "Reward pool less frequent than every 10 minutes");
1192         require(_percent <= 1000 && _percent >= 0, "Reward pool percent not between 0% and 10%");
1193         rewardSettings.rewardPoolFrequency = _frequencyInSeconds;
1194         rewardSettings.percentRewardPool = _percent;
1195     }
1196 
1197     function withdrawStuckEth() external {
1198         require(msg.sender == DEPLOYER);
1199         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1200         require(success, "Failed to withdraw stuck eth");
1201     }
1202 
1203     function updateGasForProcessing(uint64 newValue) external {
1204         require(msg.sender == DEPLOYER);
1205         require(newValue >= 50_000 && newValue <= 200_000, "gasForProcessing must be between 50,000 and 200,000");        
1206         emit GasForProcessingUpdated(newValue, rewardSettings.gasForProcessing);
1207         rewardSettings.gasForProcessing = newValue;
1208     }
1209 
1210     function updateClaimWait(uint256 newClaimWait) external {
1211         require(msg.sender == DEPLOYER);
1212         require(newClaimWait >= 900 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 15 minutes and 24 hours");
1213         require(newClaimWait != getClaimWait(), "Dividend_Tracker: Cannot update claimWait to same value");
1214         DIVIDEND_TRACKER.updateClaimWait(newClaimWait);
1215     }
1216 
1217     function excludeFromDividends(address account) external onlyOwner {
1218         DIVIDEND_TRACKER.excludeFromDividends(account);
1219         emit ExcludeFromDividends(account);
1220     }
1221 
1222     function includeInDividends(address account) external onlyOwner {
1223         DIVIDEND_TRACKER.includeInDividends(account);
1224         emit IncludeInDividends(account);
1225     }
1226 
1227     function setDevelopmentWallet(address payable newDevelopmentWallet) external onlyOwner {
1228         require(newDevelopmentWallet != developmentWallet);
1229         developmentWallet = newDevelopmentWallet;
1230     }
1231     
1232     function getClaimWait() public view returns(uint256) {
1233         return DIVIDEND_TRACKER.claimWait();
1234     }
1235 
1236     function getTotalDividendsDistributed() external view returns (uint256) {
1237         return DIVIDEND_TRACKER.totalDividendsDistributed();
1238     }
1239 
1240     function withdrawableDividendOf(address account) public view returns(uint256) {
1241         return DIVIDEND_TRACKER.withdrawableDividendOf(account);
1242     }
1243 
1244     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1245         return DIVIDEND_TRACKER.holderBalance(account);
1246     }
1247 
1248     function getAccountDividendsInfo(address account)
1249         external view returns (
1250             address,
1251             int256,
1252             int256,
1253             uint256,
1254             uint256,
1255             uint256,
1256             uint256,
1257             uint256) {
1258         return DIVIDEND_TRACKER.getAccount(account);
1259     }
1260 
1261     function getAccountDividendsInfoAtIndex(uint256 index)
1262         external view returns (
1263             address,
1264             int256,
1265             int256,
1266             uint256,
1267             uint256,
1268             uint256,
1269             uint256,
1270             uint256) {
1271         return DIVIDEND_TRACKER.getAccountAtIndex(index);
1272     }
1273 
1274     function processDividendTracker(uint256 gas) external {
1275         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = DIVIDEND_TRACKER.process(gas);
1276         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1277     }
1278 
1279     function claim() external {
1280         uint256 lastClaimTime = DIVIDEND_TRACKER.lastClaimTimes(msg.sender);
1281         require(block.timestamp.sub(lastClaimTime) >= getClaimWait());
1282         DIVIDEND_TRACKER.processAccount(payable(msg.sender), false);
1283     }
1284 
1285     function getLastProcessedIndex() external view returns(uint256) {
1286         return DIVIDEND_TRACKER.getLastProcessedIndex();
1287     }
1288 
1289     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1290         return DIVIDEND_TRACKER.getNumberOfTokenHolders();
1291     }
1292     
1293     function getNumberOfDividends() external view returns(uint256) {
1294         return DIVIDEND_TRACKER.totalBalance();
1295     }
1296 }
1297 
1298 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
1299   using SafeMath for uint256;
1300   using SafeMathUint for uint256;
1301   using SafeMathInt for int256;
1302 
1303   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1304   // For more discussion about choosing the value of `magnitude`,
1305 
1306   uint256 constant internal MAGNITUDE = 2**128;
1307 
1308   uint256 internal magnifiedDividendPerShare;
1309  
1310   address constant public TOKEN = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
1311 
1312   constructor(){}
1313   // About dividendCorrection:
1314   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1315   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1316   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1317   //   `dividendOf(_user)` should not be changed,
1318   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1319   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1320   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1321   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1322   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1323   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1324   mapping(address => int256) internal magnifiedDividendCorrections;
1325   mapping(address => uint256) internal withdrawnDividends;
1326   
1327   mapping (address => uint256) public holderBalance;
1328   uint256 public totalBalance;
1329 
1330   uint256 public totalDividendsDistributed;
1331 
1332   /// @dev Distributes dividends whefnever ether is paid to this contract.
1333   receive() external payable {
1334     distributeDividends();
1335   }
1336 
1337   /// @notice Distributes ether to token holders as dividends.
1338   /// @dev It reverts if the total supply of tokens is 0.
1339   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1340   /// About undistributed ether:
1341   ///   In each distribution, there is a small amount of ether not distributed,
1342   ///     the magnified amount of which is
1343   ///     `(msg.value * magnitude) % totalSupply()`.
1344   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1345   ///     (de-magnified) in a distribution can be less than 1 wei.
1346   ///   We can actually keep track of the undistributed ether in a distribution
1347   ///     and try to distribute it in the next distribution,
1348   ///     but keeping track of such data on-chain costs much more than
1349   ///     the saved ether, so we don't do that.
1350     
1351   function distributeDividends() public override payable {
1352     require(false, "Cannot send eth directly to tracker as it is unrecoverable"); // 
1353   }
1354   
1355   function distributeTokenDividends(uint256 amount) public onlyOwner {
1356     require(totalBalance > 0);
1357 
1358     if (amount > 0) {
1359       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1360         (amount).mul(MAGNITUDE) / totalBalance
1361       );
1362       emit DividendsDistributed(msg.sender, amount);
1363 
1364       totalDividendsDistributed = totalDividendsDistributed.add(amount);
1365     }
1366   }
1367 
1368   /// @notice Withdraws the ether distributed to the sender.
1369   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1370   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1371     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1372     if (_withdrawableDividend > 0) {
1373       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1374       emit DividendWithdrawn(user, _withdrawableDividend);
1375       bool success = IERC20(TOKEN).transfer(user, _withdrawableDividend);
1376 
1377       if(!success) {
1378         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1379         return 0;
1380       }
1381 
1382       return _withdrawableDividend;
1383     }
1384     return 0;
1385   }
1386 
1387   /// @notice View the amount of dividend in wei that an address can withdraw.
1388   /// @param _owner The address of a token holder.
1389   /// @return The amount of dividend in wei that `_owner` can withdraw.
1390   function dividendOf(address _owner) public view override returns(uint256) {
1391     return withdrawableDividendOf(_owner);
1392   }
1393 
1394   /// @notice View the amount of dividend in wei that an address can withdraw.
1395   /// @param _owner The address of a token holder.
1396   /// @return The amount of dividend in wei that `_owner` can withdraw.
1397   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1398     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1399   }
1400 
1401   /// @notice View the amount of dividend in wei that an address has withdrawn.
1402   /// @param _owner The address of a token holder.
1403   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1404   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1405     return withdrawnDividends[_owner];
1406   }
1407 
1408   /// @notice View the amount of dividend in wei that an address has earned in total.
1409   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1410   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1411   /// @param _owner The address of a token holder.
1412   /// @return The amount of dividend in wei that `_owner` has earned in total.
1413   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1414     return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
1415       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / MAGNITUDE;
1416   }
1417 
1418   /// @dev Internal function that increases tokens to an account.
1419   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1420   /// @param account The account that will receive the created tokens.
1421   /// @param value The amount that will be created.
1422   function _increase(address account, uint256 value) internal {
1423     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1424       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1425   }
1426 
1427   /// @dev Internal function that reduces an amount of the token of a given account.
1428   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1429   /// @param account The account whose tokens will be burnt.
1430   /// @param value The amount that will be burnt.
1431   function _reduce(address account, uint256 value) internal {
1432     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1433       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1434   }
1435 
1436   function _setBalance(address account, uint256 newBalance) internal {
1437     uint256 currentBalance = holderBalance[account];
1438     holderBalance[account] = newBalance;
1439     if(newBalance > currentBalance) {
1440       uint256 increaseAmount = newBalance.sub(currentBalance);
1441       _increase(account, increaseAmount);
1442       totalBalance += increaseAmount;
1443     } else if(newBalance < currentBalance) {
1444       uint256 reduceAmount = currentBalance.sub(newBalance);
1445       _reduce(account, reduceAmount);
1446       totalBalance -= reduceAmount;
1447     }
1448   }
1449 }
1450 
1451 contract DividendTracker is DividendPayingToken {
1452     using SafeMath for uint256;
1453     using SafeMathInt for int256;
1454     using IterableMapping for IterableMapping.Map;
1455 
1456     IterableMapping.Map private tokenHoldersMap;
1457     uint256 public lastProcessedIndex;
1458 
1459     mapping (address => bool) public excludedFromDividends;
1460 
1461     mapping (address => uint256) public lastClaimTimes;
1462 
1463     uint256 public claimWait = 3600;
1464     uint256 public constant minimumTokenBalanceForDividends = 1_000_000 * (10**18); //must hold 1000+ tokens;
1465 
1466     event ExcludeFromDividends(address indexed account);
1467     event IncludeInDividends(address indexed account);
1468     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1469 
1470     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1471 
1472     constructor() {}
1473 
1474     function excludeFromDividends(address account) external onlyOwner {
1475         excludedFromDividends[account] = true;
1476 
1477         _setBalance(account, 0);
1478         tokenHoldersMap.remove(account);
1479 
1480         emit ExcludeFromDividends(account);
1481     }
1482     
1483     function includeInDividends(address account) external onlyOwner {
1484         require(excludedFromDividends[account]);
1485         excludedFromDividends[account] = false;
1486 
1487         emit IncludeInDividends(account);
1488     }
1489 
1490     function updateClaimWait(uint256 newClaimWait) external onlyOwner {        
1491         emit ClaimWaitUpdated(newClaimWait, claimWait);
1492         claimWait = newClaimWait;
1493     }
1494 
1495     function getLastProcessedIndex() external view returns(uint256) {
1496         return lastProcessedIndex;
1497     }
1498 
1499     function getNumberOfTokenHolders() external view returns(uint256) {
1500         return tokenHoldersMap.keys.length;
1501     }
1502 
1503     function getAccount(address _account)
1504         public view returns (
1505             address account,
1506             int256 index,
1507             int256 iterationsUntilProcessed,
1508             uint256 withdrawableDividends,
1509             uint256 totalDividends,
1510             uint256 lastClaimTime,
1511             uint256 nextClaimTime,
1512             uint256 secondsUntilAutoClaimAvailable) {
1513         account = _account;
1514         index = tokenHoldersMap.getIndexOfKey(account);
1515         iterationsUntilProcessed = -1;
1516         if(index >= 0) {
1517             if(uint256(index) > lastProcessedIndex) {
1518                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1519             }
1520             else {
1521                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1522                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1523                                                         0;
1524 
1525 
1526                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1527             }
1528         }
1529         withdrawableDividends = withdrawableDividendOf(account);
1530         totalDividends = accumulativeDividendOf(account);
1531         lastClaimTime = lastClaimTimes[account];
1532         nextClaimTime = lastClaimTime > 0 ?
1533                                     lastClaimTime.add(claimWait) :
1534                                     0;
1535         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1536                                                     nextClaimTime.sub(block.timestamp) :
1537                                                     0;
1538     }
1539 
1540     function getAccountAtIndex(uint256 index)
1541         public view returns (
1542             address,
1543             int256,
1544             int256,
1545             uint256,
1546             uint256,
1547             uint256,
1548             uint256,
1549             uint256) {
1550         if(index >= tokenHoldersMap.size()) {
1551             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1552         }
1553         address account = tokenHoldersMap.getKeyAtIndex(index);
1554         return getAccount(account);
1555     }
1556 
1557     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1558         if(lastClaimTime > block.timestamp)  {
1559             return false;
1560         }
1561         return block.timestamp.sub(lastClaimTime) >= claimWait;
1562     }
1563 
1564     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1565         if(excludedFromDividends[account]) {
1566             return;
1567         }
1568         if(newBalance >= minimumTokenBalanceForDividends) {
1569             _setBalance(account, newBalance);
1570             tokenHoldersMap.set(account, newBalance);
1571             
1572             uint256 lastClaimTime = lastClaimTimes[account];
1573             if(lastClaimTime == 0){
1574                 lastClaimTimes[account] = block.timestamp;
1575             }
1576             else if(canAutoClaim(lastClaimTime)){
1577                 processAccount(account, false);
1578             }            
1579         }
1580         else {
1581             _setBalance(account, 0);
1582             tokenHoldersMap.remove(account);
1583         }
1584     }
1585     
1586     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1587         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1588 
1589         if(numberOfTokenHolders == 0) {
1590             return (0, 0, lastProcessedIndex);
1591         }
1592         uint256 _lastProcessedIndex = lastProcessedIndex;
1593         uint256 gasUsed = 0;
1594         uint256 gasLeft = gasleft();
1595         uint256 iterations = 0;
1596         uint256 claims = 0;
1597 
1598         while(gasUsed < gas && iterations < numberOfTokenHolders) {
1599             _lastProcessedIndex++;
1600 
1601             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1602                 _lastProcessedIndex = 0;
1603             }
1604             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1605             if(canAutoClaim(lastClaimTimes[account])) {
1606                 if(processAccount(payable(account), true)) {
1607                     claims++;
1608                 }
1609             }
1610             iterations++;
1611             uint256 newGasLeft = gasleft();
1612             if(gasLeft > newGasLeft) {
1613                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1614             }
1615             gasLeft = newGasLeft;
1616         }
1617         lastProcessedIndex = _lastProcessedIndex;
1618         return (iterations, claims, lastProcessedIndex);
1619     }
1620 
1621     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1622         uint256 amount = _withdrawDividendOfUser(account);
1623         if(amount > 0) {
1624             lastClaimTimes[account] = block.timestamp;
1625             emit Claim(account, amount, automatic);
1626             return true;
1627         }
1628         return false;
1629     }
1630 }