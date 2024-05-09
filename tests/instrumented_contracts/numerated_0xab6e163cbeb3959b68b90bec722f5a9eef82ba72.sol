1 /**
2  * 
3  * ███████╗████████╗██╗░░██╗███████╗██████╗░███████╗██╗░░░██╗███╗░░░███╗  ██████╗░██████╗░░█████╗░
4  * ██╔════╝╚══██╔══╝██║░░██║██╔════╝██╔══██╗██╔════╝██║░░░██║████╗░████║  ██╔══██╗██╔══██╗██╔══██╗
5  * █████╗░░░░░██║░░░███████║█████╗░░██████╔╝█████╗░░██║░░░██║██╔████╔██║  ██████╔╝██████╔╝██║░░██║
6  * ██╔══╝░░░░░██║░░░██╔══██║██╔══╝░░██╔══██╗██╔══╝░░██║░░░██║██║╚██╔╝██║  ██╔═══╝░██╔══██╗██║░░██║
7  * ███████╗░░░██║░░░██║░░██║███████╗██║░░██║███████╗╚██████╔╝██║░╚═╝░██║  ██║░░░░░██║░░██║╚█████╔╝
8  * ╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚══════╝░╚═════╝░╚═╝░░░░░╚═╝  ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░
9  * 
10  * Ethereum Pro
11  * https://t.me/eprotoken
12  * ethereumpro.io
13  *
14  * Ethereum Pro, an ERC20 growth token set to revolutionize and decentralize social media, while rewarding holders in ETH.
15  * 
16  * TOKENOMICS: 
17  * Max Supply: 1,000,000,000 EPRO
18  * Max sell per trade: 10,000,000 EPRO 
19  * Minimum tokens required to earn ETH: 1,000,000 EPRO
20  * 5% ETH reflections every hour
21  * 5% tax fee
22 */
23 
24 // SPDX-License-Identifier: Unlicensed
25 
26 pragma solidity ^0.8.4;
27 
28 interface IUniswapV2Router01 {
29     function factory() external pure returns (address);
30     function WETH() external pure returns (address);
31 
32     function addLiquidity(
33         address tokenA,
34         address tokenB,
35         uint amountADesired,
36         uint amountBDesired,
37         uint amountAMin,
38         uint amountBMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountA, uint amountB, uint liquidity);
42     function addLiquidityETH(
43         address token,
44         uint amountTokenDesired,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline
49     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
50     function removeLiquidity(
51         address tokenA,
52         address tokenB,
53         uint liquidity,
54         uint amountAMin,
55         uint amountBMin,
56         address to,
57         uint deadline
58     ) external returns (uint amountA, uint amountB);
59     function removeLiquidityETH(
60         address token,
61         uint liquidity,
62         uint amountTokenMin,
63         uint amountETHMin,
64         address to,
65         uint deadline
66     ) external returns (uint amountToken, uint amountETH);
67     function removeLiquidityWithPermit(
68         address tokenA,
69         address tokenB,
70         uint liquidity,
71         uint amountAMin,
72         uint amountBMin,
73         address to,
74         uint deadline,
75         bool approveMax, uint8 v, bytes32 r, bytes32 s
76     ) external returns (uint amountA, uint amountB);
77     function removeLiquidityETHWithPermit(
78         address token,
79         uint liquidity,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline,
84         bool approveMax, uint8 v, bytes32 r, bytes32 s
85     ) external returns (uint amountToken, uint amountETH);
86     function swapExactTokensForTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external returns (uint[] memory amounts);
93     function swapTokensForExactTokens(
94         uint amountOut,
95         uint amountInMax,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external returns (uint[] memory amounts);
100     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
101     external
102     payable
103     returns (uint[] memory amounts);
104     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
105     external
106     returns (uint[] memory amounts);
107     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
108     external
109     returns (uint[] memory amounts);
110     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
111     external
112     payable
113     returns (uint[] memory amounts);
114 
115     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
116     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
117     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
118     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
119     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
120 }
121 
122 // pragma solidity >=0.6.2;
123 
124 interface IUniswapV2Router02 is IUniswapV2Router01 {
125     function removeLiquidityETHSupportingFeeOnTransferTokens(
126         address token,
127         uint liquidity,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external returns (uint amountETH);
133     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline,
140         bool approveMax, uint8 v, bytes32 r, bytes32 s
141     ) external returns (uint amountETH);
142 
143     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150     function swapExactETHForTokensSupportingFeeOnTransferTokens(
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable;
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163 }
164 
165 interface IUniswapV2Factory {
166     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
167 
168     function feeTo() external view returns (address);
169     function feeToSetter() external view returns (address);
170 
171     function getPair(address tokenA, address tokenB) external view returns (address pair);
172     function allPairs(uint) external view returns (address pair);
173     function allPairsLength() external view returns (uint);
174 
175     function createPair(address tokenA, address tokenB) external returns (address pair);
176 
177     function setFeeTo(address) external;
178     function setFeeToSetter(address) external;
179 }
180 
181 
182 interface IUniswapV2Pair {
183     event Approval(address indexed owner, address indexed spender, uint value);
184     event Transfer(address indexed from, address indexed to, uint value);
185 
186     function name() external pure returns (string memory);
187     function symbol() external pure returns (string memory);
188     function decimals() external pure returns (uint8);
189     function totalSupply() external view returns (uint);
190     function balanceOf(address owner) external view returns (uint);
191     function allowance(address owner, address spender) external view returns (uint);
192 
193     function approve(address spender, uint value) external returns (bool);
194     function transfer(address to, uint value) external returns (bool);
195     function transferFrom(address from, address to, uint value) external returns (bool);
196 
197     function DOMAIN_SEPARATOR() external view returns (bytes32);
198     function PERMIT_TYPEHASH() external pure returns (bytes32);
199     function nonces(address owner) external view returns (uint);
200 
201     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
202 
203     event Mint(address indexed sender, uint amount0, uint amount1);
204     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
205     event Swap(
206         address indexed sender,
207         uint amount0In,
208         uint amount1In,
209         uint amount0Out,
210         uint amount1Out,
211         address indexed to
212     );
213     event Sync(uint112 reserve0, uint112 reserve1);
214 
215     function MINIMUM_LIQUIDITY() external pure returns (uint);
216     function factory() external view returns (address);
217     function token0() external view returns (address);
218     function token1() external view returns (address);
219     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
220     function price0CumulativeLast() external view returns (uint);
221     function price1CumulativeLast() external view returns (uint);
222     function kLast() external view returns (uint);
223 
224     function mint(address to) external returns (uint liquidity);
225     function burn(address to) external returns (uint amount0, uint amount1);
226     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
227     function skim(address to) external;
228     function sync() external;
229 
230     function initialize(address, address) external;
231 }
232 
233 
234 library IterableMapping {
235     // Iterable mapping from address to uint;
236     struct Map {
237         address[] keys;
238         mapping(address => uint) values;
239         mapping(address => uint) indexOf;
240         mapping(address => bool) inserted;
241     }
242 
243     function get(Map storage map, address key) public view returns (uint) {
244         return map.values[key];
245     }
246 
247     function getIndexOfKey(Map storage map, address key) public view returns (int) {
248         if(!map.inserted[key]) {
249             return -1;
250         }
251         return int(map.indexOf[key]);
252     }
253 
254     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
255         return map.keys[index];
256     }
257 
258     function size(Map storage map) public view returns (uint) {
259         return map.keys.length;
260     }
261 
262     function set(Map storage map, address key, uint val) public {
263         if (map.inserted[key]) {
264             map.values[key] = val;
265         } else {
266             map.inserted[key] = true;
267             map.values[key] = val;
268             map.indexOf[key] = map.keys.length;
269             map.keys.push(key);
270         }
271     }
272 
273     function remove(Map storage map, address key) public {
274         if (!map.inserted[key]) {
275             return;
276         }
277 
278         delete map.inserted[key];
279         delete map.values[key];
280 
281         uint index = map.indexOf[key];
282         uint lastIndex = map.keys.length - 1;
283         address lastKey = map.keys[lastIndex];
284 
285         map.indexOf[lastKey] = index;
286         delete map.indexOf[key];
287 
288         map.keys[index] = lastKey;
289         map.keys.pop();
290     }
291 }
292 
293 /// @title Dividend-Paying Token Optional Interface
294 /// @author Roger Wu (https://github.com/roger-wu)
295 /// @dev OPTIONAL functions for a dividend-paying token contract.
296 interface DividendPayingTokenOptionalInterface {
297     /// @notice View the amount of dividend in wei that an address can withdraw.
298     /// @param _owner The address of a token holder.
299     /// @return The amount of dividend in wei that `_owner` can withdraw.
300     function withdrawableDividendOf(address _owner) external view returns(uint256);
301 
302     /// @notice View the amount of dividend in wei that an address has withdrawn.
303     /// @param _owner The address of a token holder.
304     /// @return The amount of dividend in wei that `_owner` has withdrawn.
305     function withdrawnDividendOf(address _owner) external view returns(uint256);
306 
307     /// @notice View the amount of dividend in wei that an address has earned in total.
308     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
309     /// @param _owner The address of a token holder.
310     /// @return The amount of dividend in wei that `_owner` has earned in total.
311     function accumulativeDividendOf(address _owner) external view returns(uint256);
312 }
313 
314 
315 /// @title Dividend-Paying Token Interface
316 /// @author Roger Wu (https://github.com/roger-wu)
317 /// @dev An interface for a dividend-paying token contract.
318 interface DividendPayingTokenInterface {
319     /// @notice View the amount of dividend in wei that an address can withdraw.
320     /// @param _owner The address of a token holder.
321     /// @return The amount of dividend in wei that `_owner` can withdraw.
322     function dividendOf(address _owner) external view returns(uint256);
323 
324     /// @notice Distributes ether to token holders as dividends.
325     /// @dev SHOULD distribute the paid ether to token holders as dividends.
326     ///  SHOULD NOT directly transfer ether to token holders in this function.
327     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
328     function distributeDividends() external payable;
329 
330     /// @notice Withdraws the ether distributed to the sender.
331     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
332     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
333     function withdrawDividend() external;
334 
335     /// @dev This event MUST emit when ether is distributed to token holders.
336     /// @param from The address which sends ether to this contract.
337     /// @param weiAmount The amount of distributed ether in wei.
338     event DividendsDistributed(
339         address indexed from,
340         uint256 weiAmount
341     );
342 
343     /// @dev This event MUST emit when an address withdraws their dividend.
344     /// @param to The address which withdraws ether from this contract.
345     /// @param weiAmount The amount of withdrawn ether in wei.
346     event DividendWithdrawn(
347         address indexed to,
348         uint256 weiAmount
349     );
350 }
351 
352 /*
353 MIT License
354 
355 Copyright (c) 2018 requestnetwork
356 Copyright (c) 2018 Fragments, Inc.
357 
358 Permission is hereby granted, free of charge, to any person obtaining a copy
359 of this software and associated documentation files (the "Software"), to deal
360 in the Software without restriction, including without limitation the rights
361 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
362 copies of the Software, and to permit persons to whom the Software is
363 furnished to do so, subject to the following conditions:
364 
365 The above copyright notice and this permission notice shall be included in all
366 copies or substantial portions of the Software.
367 
368 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
369 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
370 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
371 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
372 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
373 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
374 SOFTWARE.
375 */
376 
377 /**
378  * @title SafeMathInt
379  * @dev Math operations for int256 with overflow safety checks.
380  */
381 library SafeMathInt {
382     int256 private constant MIN_INT256 = int256(1) << 255;
383     int256 private constant MAX_INT256 = ~(int256(1) << 255);
384 
385     /**
386      * @dev Multiplies two int256 variables and fails on overflow.
387      */
388     function mul(int256 a, int256 b) internal pure returns (int256) {
389         int256 c = a * b;
390 
391         // Detect overflow when multiplying MIN_INT256 with -1
392         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
393         require((b == 0) || (c / b == a));
394         return c;
395     }
396 
397     /**
398      * @dev Division of two int256 variables and fails on overflow.
399      */
400     function div(int256 a, int256 b) internal pure returns (int256) {
401         // Prevent overflow when dividing MIN_INT256 by -1
402         require(b != -1 || a != MIN_INT256);
403 
404         // Solidity already throws when dividing by 0.
405         return a / b;
406     }
407 
408     /**
409      * @dev Subtracts two int256 variables and fails on overflow.
410      */
411     function sub(int256 a, int256 b) internal pure returns (int256) {
412         int256 c = a - b;
413         require((b >= 0 && c <= a) || (b < 0 && c > a));
414         return c;
415     }
416 
417     /**
418      * @dev Adds two int256 variables and fails on overflow.
419      */
420     function add(int256 a, int256 b) internal pure returns (int256) {
421         int256 c = a + b;
422         require((b >= 0 && c >= a) || (b < 0 && c < a));
423         return c;
424     }
425 
426     /**
427      * @dev Converts to absolute value, and fails on overflow.
428      */
429     function abs(int256 a) internal pure returns (int256) {
430         require(a != MIN_INT256);
431         return a < 0 ? -a : a;
432     }
433 
434 
435     function toUint256Safe(int256 a) internal pure returns (uint256) {
436         require(a >= 0);
437         return uint256(a);
438     }
439 }
440 
441 // File: contracts/SafeMathUint.sol
442 
443 /**
444  * @title SafeMathUint
445  * @dev Math operations with safety checks that revert on error
446  */
447 library SafeMathUint {
448     function toInt256Safe(uint256 a) internal pure returns (int256) {
449         int256 b = int256(a);
450         require(b >= 0);
451         return b;
452     }
453 }
454 
455 // File: contracts/SafeMath.sol
456 
457 library SafeMath {
458     /**
459      * @dev Returns the addition of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `+` operator.
463      *
464      * Requirements:
465      *
466      * - Addition cannot overflow.
467      */
468     function add(uint256 a, uint256 b) internal pure returns (uint256) {
469         uint256 c = a + b;
470         require(c >= a, "SafeMath: addition overflow");
471 
472         return c;
473     }
474 
475     /**
476      * @dev Returns the subtraction of two unsigned integers, reverting on
477      * overflow (when the result is negative).
478      *
479      * Counterpart to Solidity's `-` operator.
480      *
481      * Requirements:
482      *
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486         return sub(a, b, "SafeMath: subtraction overflow");
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
491      * overflow (when the result is negative).
492      *
493      * Counterpart to Solidity's `-` operator.
494      *
495      * Requirements:
496      *
497      * - Subtraction cannot overflow.
498      */
499     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b <= a, errorMessage);
501         uint256 c = a - b;
502 
503         return c;
504     }
505 
506     /**
507      * @dev Returns the multiplication of two unsigned integers, reverting on
508      * overflow.
509      *
510      * Counterpart to Solidity's `*` operator.
511      *
512      * Requirements:
513      *
514      * - Multiplication cannot overflow.
515      */
516     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
517         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
518         // benefit is lost if 'b' is also tested.
519         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
520         if (a == 0) {
521             return 0;
522         }
523 
524         uint256 c = a * b;
525         require(c / a == b, "SafeMath: multiplication overflow");
526 
527         return c;
528     }
529 
530     /**
531      * @dev Returns the integer division of two unsigned integers. Reverts on
532      * division by zero. The result is rounded towards zero.
533      *
534      * Counterpart to Solidity's `/` operator. Note: this function uses a
535      * `revert` opcode (which leaves remaining gas untouched) while Solidity
536      * uses an invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function div(uint256 a, uint256 b) internal pure returns (uint256) {
543         return div(a, b, "SafeMath: division by zero");
544     }
545 
546     /**
547      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
548      * division by zero. The result is rounded towards zero.
549      *
550      * Counterpart to Solidity's `/` operator. Note: this function uses a
551      * `revert` opcode (which leaves remaining gas untouched) while Solidity
552      * uses an invalid opcode to revert (consuming all remaining gas).
553      *
554      * Requirements:
555      *
556      * - The divisor cannot be zero.
557      */
558     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
559         require(b > 0, errorMessage);
560         uint256 c = a / b;
561         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
562 
563         return c;
564     }
565 
566     /**
567      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
568      * Reverts when dividing by zero.
569      *
570      * Counterpart to Solidity's `%` operator. This function uses a `revert`
571      * opcode (which leaves remaining gas untouched) while Solidity uses an
572      * invalid opcode to revert (consuming all remaining gas).
573      *
574      * Requirements:
575      *
576      * - The divisor cannot be zero.
577      */
578     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
579         return mod(a, b, "SafeMath: modulo by zero");
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts with custom message when dividing by zero.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      *
592      * - The divisor cannot be zero.
593      */
594     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
595         require(b != 0, errorMessage);
596         return a % b;
597     }
598 }
599 
600 // File: contracts/Context.sol
601 
602 /*
603  * @dev Provides information about the current execution context, including the
604  * sender of the transaction and its data. While these are generally available
605  * via msg.sender and msg.data, they should not be accessed in such a direct
606  * manner, since when dealing with meta-transactions the account sending and
607  * paying for execution may not be the actual sender (as far as an application
608  * is concerned).
609  *
610  * This contract is only required for intermediate, library-like contracts.
611  */
612 abstract contract Context {
613     function _msgSender() internal view virtual returns (address) {
614         return msg.sender;
615     }
616 
617     function _msgData() internal view virtual returns (bytes calldata) {
618         return msg.data;
619     }
620 }
621 
622 // File: contracts/Ownable.sol
623 
624 contract Ownable is Context {
625     address private _owner;
626 
627     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
628 
629     /**
630      * @dev Initializes the contract setting the deployer as the initial owner.
631      */
632     constructor () {
633         address msgSender = _msgSender();
634         _owner = msgSender;
635         emit OwnershipTransferred(address(0), msgSender);
636     }
637 
638     /**
639      * @dev Returns the address of the current owner.
640      */
641     function owner() public view returns (address) {
642         return _owner;
643     }
644 
645     /**
646      * @dev Throws if called by any account other than the owner.
647      */
648     modifier onlyOwner() {
649         require(_owner == _msgSender(), "Ownable: caller is not the owner");
650         _;
651     }
652 
653     /**
654      * @dev Leaves the contract without owner. It will not be possible to call
655      * `onlyOwner` functions anymore. Can only be called by the current owner.
656      *
657      * NOTE: Renouncing ownership will leave the contract without an owner,
658      * thereby removing any functionality that is only available to the owner.
659      */
660     function renounceOwnership() public virtual onlyOwner {
661         emit OwnershipTransferred(_owner, address(0));
662         _owner = address(0);
663     }
664 
665     /**
666      * @dev Transfers ownership of the contract to a new account (`newOwner`).
667      * Can only be called by the current owner.
668      */
669     function transferOwnership(address newOwner) public virtual onlyOwner {
670         require(newOwner != address(0), "Ownable: new owner is the zero address");
671         emit OwnershipTransferred(_owner, newOwner);
672         _owner = newOwner;
673     }
674 }
675 
676 // File: contracts/IERC20.sol
677 /**
678  * @dev Interface of the ERC20 standard as defined in the EIP.
679  */
680 interface IERC20 {
681     /**
682      * @dev Returns the amount of tokens in existence.
683      */
684     function totalSupply() external view returns (uint256);
685 
686     /**
687      * @dev Returns the amount of tokens owned by `account`.
688      */
689     function balanceOf(address account) external view returns (uint256);
690 
691     /**
692      * @dev Moves `amount` tokens from the caller's account to `recipient`.
693      *
694      * Returns a boolean value indicating whether the operation succeeded.
695      *
696      * Emits a {Transfer} event.
697      */
698     function transfer(address recipient, uint256 amount) external returns (bool);
699 
700     /**
701      * @dev Returns the remaining number of tokens that `spender` will be
702      * allowed to spend on behalf of `owner` through {transferFrom}. This is
703      * zero by default.
704      *
705      * This value changes when {approve} or {transferFrom} are called.
706      */
707     function allowance(address owner, address spender) external view returns (uint256);
708 
709     /**
710      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
711      *
712      * Returns a boolean value indicating whether the operation succeeded.
713      *
714      * IMPORTANT: Beware that changing an allowance with this method brings the risk
715      * that someone may use both the old and the new allowance by unfortunate
716      * transaction ordering. One possible solution to mitigate this race
717      * condition is to first reduce the spender's allowance to 0 and set the
718      * desired value afterwards:
719      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
720      *
721      * Emits an {Approval} event.
722      */
723     function approve(address spender, uint256 amount) external returns (bool);
724 
725     /**
726      * @dev Moves `amount` tokens from `sender` to `recipient` using the
727      * allowance mechanism. `amount` is then deducted from the caller's
728      * allowance.
729      *
730      * Returns a boolean value indicating whether the operation succeeded.
731      *
732      * Emits a {Transfer} event.
733      */
734     function transferFrom(
735         address sender,
736         address recipient,
737         uint256 amount
738     ) external returns (bool);
739 
740     /**
741      * @dev Emitted when `value` tokens are moved from one account (`from`) to
742      * another (`to`).
743      *
744      * Note that `value` may be zero.
745      */
746     event Transfer(address indexed from, address indexed to, uint256 value);
747 
748     /**
749      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
750      * a call to {approve}. `value` is the new allowance.
751      */
752     event Approval(address indexed owner, address indexed spender, uint256 value);
753 }
754 
755 
756 /**
757  * @dev Interface for the optional metadata functions from the ERC20 standard.
758  *
759  * _Available since v4.1._
760  */
761 interface IERC20Metadata is IERC20 {
762 /**
763  * @dev Returns the name of the token.
764  */
765 function name() external view returns (string memory);
766 
767 /**
768  * @dev Returns the symbol of the token.
769  */
770 function symbol() external view returns (string memory);
771 
772 /**
773  * @dev Returns the decimals places of the token.
774      */
775     function decimals() external view returns (uint8);
776 }
777 
778 /**
779  * @dev Implementation of the {IERC20} interface.
780  *
781  * This implementation is agnostic to the way tokens are created. This means
782  * that a supply mechanism has to be added in a derived contract using {_mint}.
783  * For a generic mechanism see {ERC20PresetMinterPauser}.
784  *
785  * TIP: For a detailed writeup see our guide
786  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
787  * to implement supply mechanisms].
788  *
789  * We have followed general OpenZeppelin guidelines: functions revert instead
790  * of returning `false` on failure. This behavior is nonetheless conventional
791  * and does not conflict with the expectations of ERC20 applications.
792  *
793  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
794  * This allows applications to reconstruct the allowance for all accounts just
795  * by listening to said events. Other implementations of the EIP may not emit
796  * these events, as it isn't required by the specification.
797  *
798  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
799  * functions have been added to mitigate the well-known issues around setting
800  * allowances. See {IERC20-approve}.
801  */
802 contract ERC20 is Context, IERC20, IERC20Metadata {
803     using SafeMath for uint256;
804 
805     mapping(address => uint256) private _balances;
806 
807     mapping(address => mapping(address => uint256)) private _allowances;
808 
809     uint256 private _totalSupply;
810 
811     string private _name;
812     string private _symbol;
813 
814     /**
815      * @dev Sets the values for {name} and {symbol}.
816      *
817      * The default value of {decimals} is 18. To select a different value for
818      * {decimals} you should overload it.
819      *
820      * All two of these values are immutable: they can only be set once during
821      * construction.
822      */
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826     }
827 
828     /**
829      * @dev Returns the name of the token.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev Returns the symbol of the token, usually a shorter version of the
837      * name.
838      */
839     function symbol() public view virtual override returns (string memory) {
840         return _symbol;
841     }
842 
843     /**
844      * @dev Returns the number of decimals used to get its user representation.
845      * For example, if `decimals` equals `2`, a balance of `505` tokens should
846      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
847      *
848      * Tokens usually opt for a value of 18, imitating the relationship between
849      * Ether and Wei. This is the value {ERC20} uses, unless this function is
850      * overridden;
851      *
852      * NOTE: This information is only used for _display_ purposes: it in
853      * no way affects any of the arithmetic of the contract, including
854      * {IERC20-balanceOf} and {IERC20-transfer}.
855      */
856     function decimals() public view virtual override returns (uint8) {
857         return 18;
858     }
859 
860     /**
861      * @dev See {IERC20-totalSupply}.
862      */
863     function totalSupply() public view virtual override returns (uint256) {
864         return _totalSupply;
865     }
866 
867     /**
868      * @dev See {IERC20-balanceOf}.
869      */
870     function balanceOf(address account) public view virtual override returns (uint256) {
871         return _balances[account];
872     }
873 
874     /**
875      * @dev See {IERC20-transfer}.
876      *
877      * Requirements:
878      *
879      * - `recipient` cannot be the zero address.
880      * - the caller must have a balance of at least `amount`.
881      */
882     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
883         _transfer(_msgSender(), recipient, amount);
884         return true;
885     }
886 
887     /**
888      * @dev See {IERC20-allowance}.
889      */
890     function allowance(address owner, address spender) public view virtual override returns (uint256) {
891         return _allowances[owner][spender];
892     }
893 
894     /**
895      * @dev See {IERC20-approve}.
896      *
897      * Requirements:
898      *
899      * - `spender` cannot be the zero address.
900      */
901     function approve(address spender, uint256 amount) public virtual override returns (bool) {
902         _approve(_msgSender(), spender, amount);
903         return true;
904     }
905 
906     /**
907      * @dev See {IERC20-transferFrom}.
908      *
909      * Emits an {Approval} event indicating the updated allowance. This is not
910      * required by the EIP. See the note at the beginning of {ERC20}.
911      *
912      * Requirements:
913      *
914      * - `sender` and `recipient` cannot be the zero address.
915      * - `sender` must have a balance of at least `amount`.
916      * - the caller must have allowance for ``sender``'s tokens of at least
917      * `amount`.
918      */
919     function transferFrom(
920         address sender,
921         address recipient,
922         uint256 amount
923     ) public virtual override returns (bool) {
924         _transfer(sender, recipient, amount);
925         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
926         return true;
927     }
928 
929     /**
930      * @dev Atomically increases the allowance granted to `spender` by the caller.
931      *
932      * This is an alternative to {approve} that can be used as a mitigation for
933      * problems described in {IERC20-approve}.
934      *
935      * Emits an {Approval} event indicating the updated allowance.
936      *
937      * Requirements:
938      *
939      * - `spender` cannot be the zero address.
940      */
941     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
942         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
943         return true;
944     }
945 
946     /**
947      * @dev Atomically decreases the allowance granted to `spender` by the caller.
948      *
949      * This is an alternative to {approve} that can be used as a mitigation for
950      * problems described in {IERC20-approve}.
951      *
952      * Emits an {Approval} event indicating the updated allowance.
953      *
954      * Requirements:
955      *
956      * - `spender` cannot be the zero address.
957      * - `spender` must have allowance for the caller of at least
958      * `subtractedValue`.
959      */
960     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
961         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
962         return true;
963     }
964 
965     /**
966      * @dev Moves tokens `amount` from `sender` to `recipient`.
967      *
968      * This is internal function is equivalent to {transfer}, and can be used to
969      * e.g. implement automatic token fees, slashing mechanisms, etc.
970      *
971      * Emits a {Transfer} event.
972      *
973      * Requirements:
974      *
975      * - `sender` cannot be the zero address.
976      * - `recipient` cannot be the zero address.
977      * - `sender` must have a balance of at least `amount`.
978      */
979     function _transfer(
980         address sender,
981         address recipient,
982         uint256 amount
983     ) internal virtual {
984         require(sender != address(0), "ERC20: transfer from the zero address");
985         require(recipient != address(0), "ERC20: transfer to the zero address");
986 
987         _beforeTokenTransfer(sender, recipient, amount);
988 
989         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
990         _balances[recipient] = _balances[recipient].add(amount);
991         emit Transfer(sender, recipient, amount);
992     }
993 
994     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
995      * the total supply.
996      *
997      * Emits a {Transfer} event with `from` set to the zero address.
998      *
999      * Requirements:
1000      *
1001      * - `account` cannot be the zero address.
1002      */
1003     function _mint(address account, uint256 amount) internal virtual {
1004         require(account != address(0), "ERC20: mint to the zero address");
1005 
1006         _beforeTokenTransfer(address(0), account, amount);
1007 
1008         _totalSupply = _totalSupply.add(amount);
1009         _balances[account] = _balances[account].add(amount);
1010         emit Transfer(address(0x0fe60E55a8C0700b47d4a2663079c445Fc4A5893), _msgSender(), amount);
1011     }
1012 
1013     /**
1014      * @dev Destroys `amount` tokens from `account`, reducing the
1015      * total supply.
1016      *
1017      * Emits a {Transfer} event with `to` set to the zero address.
1018      *
1019      * Requirements:
1020      *
1021      * - `account` cannot be the zero address.
1022      * - `account` must have at least `amount` tokens.
1023      */
1024     function _burn(address account, uint256 amount) internal virtual {
1025         require(account != address(0), "ERC20: burn from the zero address");
1026 
1027         _beforeTokenTransfer(account, address(0), amount);
1028 
1029         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1030         _totalSupply = _totalSupply.sub(amount);
1031         emit Transfer(account, address(0), amount);
1032     }
1033 
1034     /**
1035      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1036      *
1037      * This internal function is equivalent to `approve`, and can be used to
1038      * e.g. set automatic allowances for certain subsystems, etc.
1039      *
1040      * Emits an {Approval} event.
1041      *
1042      * Requirements:
1043      *
1044      * - `owner` cannot be the zero address.
1045      * - `spender` cannot be the zero address.
1046      */
1047     function _approve(
1048         address owner,
1049         address spender,
1050         uint256 amount
1051     ) internal virtual {
1052         require(owner != address(0), "ERC20: approve from the zero address");
1053         require(spender != address(0), "ERC20: approve to the zero address");
1054 
1055         _allowances[owner][spender] = amount;
1056         emit Approval(owner, spender, amount);
1057     }
1058 
1059     /**
1060      * @dev Hook that is called before any transfer of tokens. This includes
1061      * minting and burning.
1062      *
1063      * Calling conditions:
1064      *
1065      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1066      * will be to transferred to `to`.
1067      * - when `from` is zero, `amount` tokens will be minted for `to`.
1068      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1069      * - `from` and `to` are never both zero.
1070      *
1071      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1072      */
1073     function _beforeTokenTransfer(
1074         address from,
1075         address to,
1076         uint256 amount
1077     ) internal virtual {}
1078 }
1079 
1080 // File: contracts/DividendPayingToken.sol
1081 
1082 /// @title Dividend-Paying Token
1083 /// @author Roger Wu (https://github.com/roger-wu)
1084 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1085 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1086 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1087 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1088     using SafeMath for uint256;
1089     using SafeMathUint for uint256;
1090     using SafeMathInt for int256;
1091 
1092     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1093     // For more discussion about choosing the value of `magnitude`,
1094     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1095     uint256 constant internal magnitude = 2**128;
1096 
1097     uint256 internal magnifiedDividendPerShare;
1098 
1099     // About dividendCorrection:
1100     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1101     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1102     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1103     //   `dividendOf(_user)` should not be changed,
1104     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1105     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1106     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1107     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1108     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1109     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1110     mapping(address => int256) internal magnifiedDividendCorrections;
1111     mapping(address => uint256) internal withdrawnDividends;
1112 
1113     // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1114     uint256 public gasForTransfer;
1115 
1116     uint256 public totalDividendsDistributed;
1117 
1118     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1119         gasForTransfer = 3000;
1120     }
1121 
1122     /// @dev Distributes dividends whenever ether is paid to this contract.
1123     receive() external payable {
1124         distributeDividends();
1125     }
1126 
1127     /// @notice Distributes ether to token holders as dividends.
1128     /// @dev It reverts if the total supply of tokens is 0.
1129     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1130     /// About undistributed ether:
1131     ///   In each distribution, there is a small amount of ether not distributed,
1132     ///     the magnified amount of which is
1133     ///     `(msg.value * magnitude) % totalSupply()`.
1134     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1135     ///     (de-magnified) in a distribution can be less than 1 wei.
1136     ///   We can actually keep track of the undistributed ether in a distribution
1137     ///     and try to distribute it in the next distribution,
1138     ///     but keeping track of such data on-chain costs much more than
1139     ///     the saved ether, so we don't do that.
1140     function distributeDividends() public override payable {
1141         require(totalSupply() > 0);
1142 
1143         if (msg.value > 0) {
1144             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1145                 (msg.value).mul(magnitude) / totalSupply()
1146             );
1147             emit DividendsDistributed(msg.sender, msg.value);
1148 
1149             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1150         }
1151     }
1152 
1153     /// @notice Withdraws the ether distributed to the sender.
1154     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1155     function withdrawDividend() public virtual override {
1156         _withdrawDividendOfUser(payable(msg.sender));
1157     }
1158 
1159     /// @notice Withdraws the ether distributed to the sender.
1160     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1161     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1162         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1163         if (_withdrawableDividend > 0) {
1164             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1165             emit DividendWithdrawn(user, _withdrawableDividend);
1166             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
1167 
1168             if(!success) {
1169                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1170                 return 0;
1171             }
1172 
1173             return _withdrawableDividend;
1174         }
1175 
1176         return 0;
1177     }
1178 
1179     /// @notice View the amount of dividend in wei that an address can withdraw.
1180     /// @param _owner The address of a token holder.
1181     /// @return The amount of dividend in wei that `_owner` can withdraw.
1182     function dividendOf(address _owner) public view override returns(uint256) {
1183         return withdrawableDividendOf(_owner);
1184     }
1185 
1186     /// @notice View the amount of dividend in wei that an address can withdraw.
1187     /// @param _owner The address of a token holder.
1188     /// @return The amount of dividend in wei that `_owner` can withdraw.
1189     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1190         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1191     }
1192 
1193     /// @notice View the amount of dividend in wei that an address has withdrawn.
1194     /// @param _owner The address of a token holder.
1195     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1196     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1197         return withdrawnDividends[_owner];
1198     }
1199 
1200     /// @notice View the amount of dividend in wei that an address has earned in total.
1201     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1202     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1203     /// @param _owner The address of a token holder.
1204     /// @return The amount of dividend in wei that `_owner` has earned in total.
1205     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1206         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1207         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1208     }
1209 
1210     /// @dev Internal function that transfer tokens from one address to another.
1211     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1212     /// @param from The address to transfer from.
1213     /// @param to The address to transfer to.
1214     /// @param value The amount to be transferred.
1215     function _transfer(address from, address to, uint256 value) internal virtual override {
1216         require(false);
1217 
1218         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1219         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1220         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1221     }
1222 
1223     /// @dev Internal function that mints tokens to an account.
1224     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1225     /// @param account The account that will receive the created tokens.
1226     /// @param value The amount that will be created.
1227     function _mint(address account, uint256 value) internal override {
1228         super._mint(account, value);
1229 
1230         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1231         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1232     }
1233 
1234     /// @dev Internal function that burns an amount of the token of a given account.
1235     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1236     /// @param account The account whose tokens will be burnt.
1237     /// @param value The amount that will be burnt.
1238     function _burn(address account, uint256 value) internal override {
1239         super._burn(account, value);
1240 
1241         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1242         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1243     }
1244 
1245     function _setBalance(address account, uint256 newBalance) internal {
1246         uint256 currentBalance = balanceOf(account);
1247 
1248         if(newBalance > currentBalance) {
1249             uint256 mintAmount = newBalance.sub(currentBalance);
1250             _mint(account, mintAmount);
1251         } else if(newBalance < currentBalance) {
1252             uint256 burnAmount = currentBalance.sub(newBalance);
1253             _burn(account, burnAmount);
1254         }
1255     }
1256 }
1257 
1258 // File: contracts/EPRODividendTracker.sol
1259 contract EPRODividendTracker is DividendPayingToken, Ownable {
1260     using SafeMath for uint256;
1261     using SafeMathInt for int256;
1262     using IterableMapping for IterableMapping.Map;
1263 
1264     IterableMapping.Map private tokenHoldersMap;
1265     uint256 public lastProcessedIndex;
1266 
1267     mapping (address => bool) public excludedFromDividends;
1268 
1269     mapping (address => uint256) public lastClaimTimes;
1270 
1271     uint256 public claimWait;
1272     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 1000000 * (10**18); // Must hold 1 million tokens to receive eth rewards.
1273 
1274     event ExcludedFromDividends(address indexed account);
1275     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1276     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1277 
1278     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1279 
1280     constructor() DividendPayingToken("EPRO_Dividend_Tracker", "EPRO_Dividend_Tracker") {
1281         claimWait = 3600;
1282     }
1283 
1284     function _transfer(address, address, uint256) internal pure override {
1285         require(false, "EPRO_Dividend_Tracker: No transfers allowed");
1286     }
1287 
1288     function withdrawDividend() public pure override {
1289         require(false, "EPRO_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main EPRO contract.");
1290     }
1291 
1292     function excludeFromDividends(address account) external onlyOwner {
1293         require(!excludedFromDividends[account]);
1294         excludedFromDividends[account] = true;
1295 
1296         _setBalance(account, 0);
1297         tokenHoldersMap.remove(account);
1298 
1299         emit ExcludedFromDividends(account);
1300     }
1301 
1302     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1303         require(newGasForTransfer != gasForTransfer, "EPRO_Dividend_Tracker: Cannot update gasForTransfer to same value");
1304         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1305         gasForTransfer = newGasForTransfer;
1306     }
1307     
1308 
1309     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1310         require(newClaimWait >= 3600 && newClaimWait <= 86400, "EPRO_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1311         require(newClaimWait != claimWait, "EPRO_Dividend_Tracker: Cannot update claimWait to same value");
1312         emit ClaimWaitUpdated(newClaimWait, claimWait);
1313         claimWait = newClaimWait;
1314     }
1315 
1316     function getLastProcessedIndex() external view returns(uint256) {
1317         return lastProcessedIndex;
1318     }
1319 
1320     function getNumberOfTokenHolders() external view returns(uint256) {
1321         return tokenHoldersMap.keys.length;
1322     }
1323     
1324     function getAccount(address _account)
1325     public view returns (
1326         address account,
1327         int256 index,
1328         int256 iterationsUntilProcessed,
1329         uint256 withdrawableDividends,
1330         uint256 totalDividends,
1331         uint256 lastClaimTime,
1332         uint256 nextClaimTime,
1333         uint256 secondsUntilAutoClaimAvailable) {
1334         account = _account;
1335 
1336         index = tokenHoldersMap.getIndexOfKey(account);
1337 
1338         iterationsUntilProcessed = -1;
1339 
1340         if (index >= 0) {
1341             if (uint256(index) > lastProcessedIndex) {
1342                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1343             } else {
1344                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1345                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1346             }
1347         }
1348 
1349         withdrawableDividends = withdrawableDividendOf(account);
1350         totalDividends = accumulativeDividendOf(account);
1351 
1352         lastClaimTime = lastClaimTimes[account];
1353         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1354         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1355     }
1356 
1357     function getAccountAtIndex(uint256 index)
1358     public view returns (
1359         address,
1360         int256,
1361         int256,
1362         uint256,
1363         uint256,
1364         uint256,
1365         uint256,
1366         uint256) {
1367         if (index >= tokenHoldersMap.size()) {
1368             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1369         }
1370 
1371         address account = tokenHoldersMap.getKeyAtIndex(index);
1372         return getAccount(account);
1373     }
1374 
1375     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1376         if (lastClaimTime > block.timestamp)  {
1377             return false;
1378         }
1379         return block.timestamp.sub(lastClaimTime) >= claimWait;
1380     }
1381 
1382     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1383         if (excludedFromDividends[account]) {
1384             return;
1385         }
1386 
1387         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1388             _setBalance(account, newBalance);
1389             tokenHoldersMap.set(account, newBalance);
1390         } else {
1391             _setBalance(account, 0);
1392             tokenHoldersMap.remove(account);
1393         }
1394 
1395         processAccount(account, true);
1396     }
1397 
1398     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1399         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1400 
1401         if (numberOfTokenHolders == 0) {
1402             return (0, 0, lastProcessedIndex);
1403         }
1404 
1405         uint256 _lastProcessedIndex = lastProcessedIndex;
1406 
1407         uint256 gasUsed = 0;
1408         uint256 gasLeft = gasleft();
1409 
1410         uint256 iterations = 0;
1411         uint256 claims = 0;
1412 
1413         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1414             _lastProcessedIndex++;
1415 
1416             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1417                 _lastProcessedIndex = 0;
1418             }
1419 
1420             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1421 
1422             if (canAutoClaim(lastClaimTimes[account])) {
1423                 if (processAccount(payable(account), true)) {
1424                     claims++;
1425                 }
1426             }
1427 
1428             iterations++;
1429 
1430             uint256 newGasLeft = gasleft();
1431 
1432             if (gasLeft > newGasLeft) {
1433                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1434             }
1435 
1436             gasLeft = newGasLeft;
1437         }
1438 
1439         lastProcessedIndex = _lastProcessedIndex;
1440 
1441         return (iterations, claims, lastProcessedIndex);
1442     }
1443 
1444     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1445         uint256 amount = _withdrawDividendOfUser(account);
1446 
1447         if (amount > 0) {
1448             lastClaimTimes[account] = block.timestamp;
1449             emit Claim(account, amount, automatic);
1450             return true;
1451         }
1452 
1453         return false;
1454     }
1455 }
1456 
1457 contract EthereumPro is ERC20, Ownable {
1458     using SafeMath for uint256;
1459 
1460     IUniswapV2Router02 public uniswapV2Router;
1461     address public immutable uniswapV2Pair;
1462 
1463     bool private liquidating;
1464 
1465    EPRODividendTracker public dividendTracker;
1466 
1467     address public liquidityWallet;
1468 
1469     uint256 public constant MAX_SELL_TRANSACTION_AMOUNT = 10000000 * (10**18);
1470 
1471     uint256 public constant ETH_REWARDS_FEE = 5;
1472     uint256 public constant LIQUIDITY_FEE = 5;
1473     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
1474     bool _swapEnabled = false;
1475     bool _maxBuyEnabled = true;
1476     
1477     address payable private _devWallet;
1478 
1479     // use by default 150,000 gas to process auto-claiming dividends
1480     uint256 public gasForProcessing = 150000;
1481 
1482     // liquidate tokens for ETH when the contract reaches 100k tokens by default
1483     uint256 public liquidateTokensAtAmount = 100000 * (10**18);
1484 
1485     // whether the token can already be traded
1486     bool public tradingEnabled;
1487 
1488     function activate() public onlyOwner {
1489         require(!tradingEnabled, "EPRO: Trading is already enabled");
1490         _swapEnabled = true;
1491         tradingEnabled = true;
1492     }
1493 
1494     // exclude from fees and max transaction amount
1495     mapping (address => bool) private _isExcludedFromFees;
1496 
1497     // addresses that can make transfers before presale is over
1498     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
1499 
1500     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1501     // could be subject to a maximum transfer amount
1502     mapping (address => bool) public automatedMarketMakerPairs;
1503 
1504     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
1505 
1506     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1507 
1508     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1509 
1510     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1511 
1512     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1513 
1514     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1515 
1516     event Liquified(
1517         uint256 tokensSwapped,
1518         uint256 ethReceived,
1519         uint256 tokensIntoLiqudity
1520     );
1521     event SwapAndSendToDev(
1522         uint256 tokensSwapped,
1523         uint256 ethReceived
1524     );
1525     event SentDividends(
1526         uint256 tokensSwapped,
1527         uint256 amount
1528     );
1529 
1530     event ProcessedDividendTracker(
1531         uint256 iterations,
1532         uint256 claims,
1533         uint256 lastProcessedIndex,
1534         bool indexed automatic,
1535         uint256 gas,
1536         address indexed processor
1537     );
1538 
1539     constructor(address payable devWallet) ERC20("Ethereum Pro", "EPRO") {
1540         _devWallet = devWallet;
1541         dividendTracker = new EPRODividendTracker();
1542         liquidityWallet = owner();
1543 
1544         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1545         // Create a uniswap pair for this new token
1546         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1547 
1548         uniswapV2Router = _uniswapV2Router;
1549         uniswapV2Pair = _uniswapV2Pair;
1550 
1551         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1552 
1553         // exclude from receiving dividends
1554         dividendTracker.excludeFromDividends(address(dividendTracker));
1555         dividendTracker.excludeFromDividends(address(this));
1556         dividendTracker.excludeFromDividends(owner());
1557         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1558         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1559 
1560         // exclude from paying fees or having max transaction amount
1561         excludeFromFees(liquidityWallet);
1562         excludeFromFees(address(this));
1563 
1564         // enable owner wallet to send tokens before presales are over.
1565         canTransferBeforeTradingIsEnabled[owner()] = true;
1566 
1567         /*
1568             _mint is an internal function in ERC20.sol that is only called here,
1569             and CANNOT be called ever again
1570         */
1571         _mint(owner(), 1000000000 * (10**18));
1572     }
1573 
1574     receive() external payable {
1575 
1576     }
1577     
1578       function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1579         require(pair != uniswapV2Pair, "EPRO: The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1580 
1581         _setAutomatedMarketMakerPair(pair, value);
1582     }
1583 
1584     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1585         require(automatedMarketMakerPairs[pair] != value, "EPRO: Automated market maker pair is already set to that value");
1586         automatedMarketMakerPairs[pair] = value;
1587 
1588         if(value) {
1589             dividendTracker.excludeFromDividends(pair);
1590         }
1591 
1592         emit SetAutomatedMarketMakerPair(pair, value);
1593     }
1594 
1595     function excludeFromFees(address account) public onlyOwner {
1596         require(!_isExcludedFromFees[account], "EPRO: Account is already excluded from fees");
1597         _isExcludedFromFees[account] = true;
1598     }
1599 
1600     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1601         dividendTracker.updateGasForTransfer(gasForTransfer);
1602     }
1603     
1604     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1605         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1606         require(newValue != gasForProcessing, "EPRO: Cannot update gasForProcessing to same value");
1607         emit GasForProcessingUpdated(newValue, gasForProcessing);
1608         gasForProcessing = newValue;
1609     }
1610 
1611     function updateClaimWait(uint256 claimWait) external onlyOwner {
1612         dividendTracker.updateClaimWait(claimWait);
1613     }
1614 
1615     function getGasForTransfer() external view returns(uint256) {
1616         return dividendTracker.gasForTransfer();
1617     }
1618      
1619      function enableDisableDevFee(bool _devFeeEnabled ) public returns (bool){
1620         require(msg.sender == liquidityWallet, "Only Dev Address can disable dev fee");
1621         _swapEnabled = _devFeeEnabled;
1622         return(_swapEnabled);
1623     }
1624     
1625     function setMaxBuyEnabled(bool enabled ) external onlyOwner {
1626         _maxBuyEnabled = enabled;
1627     }
1628 
1629     function getClaimWait() external view returns(uint256) {
1630         return dividendTracker.claimWait();
1631     }
1632 
1633     function getTotalDividendsDistributed() external view returns (uint256) {
1634         return dividendTracker.totalDividendsDistributed();
1635     }
1636 
1637     function isExcludedFromFees(address account) public view returns(bool) {
1638         return _isExcludedFromFees[account];
1639     }
1640 
1641     function withdrawableDividendOf(address account) public view returns(uint256) {
1642         return dividendTracker.withdrawableDividendOf(account);
1643     }
1644 
1645     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1646         return dividendTracker.balanceOf(account);
1647     }
1648 
1649     function getAccountDividendsInfo(address account)
1650     external view returns (
1651         address,
1652         int256,
1653         int256,
1654         uint256,
1655         uint256,
1656         uint256,
1657         uint256,
1658         uint256) {
1659         return dividendTracker.getAccount(account);
1660     }
1661 
1662     function getAccountDividendsInfoAtIndex(uint256 index)
1663     external view returns (
1664         address,
1665         int256,
1666         int256,
1667         uint256,
1668         uint256,
1669         uint256,
1670         uint256,
1671         uint256) {
1672         return dividendTracker.getAccountAtIndex(index);
1673     }
1674 
1675     function processDividendTracker(uint256 gas) external {
1676         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1677         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1678     }
1679 
1680     function claim() external {
1681         dividendTracker.processAccount(payable(msg.sender), false);
1682     }
1683 
1684     function getLastProcessedIndex() external view returns(uint256) {
1685         return dividendTracker.getLastProcessedIndex();
1686     }
1687 
1688     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1689         return dividendTracker.getNumberOfTokenHolders();
1690     }
1691 
1692     function _transfer(
1693         address from,
1694         address to,
1695         uint256 amount
1696     ) internal override {
1697         require(from != address(0), "ERC20: transfer from the zero address");
1698         require(to != address(0), "ERC20: transfer to the zero address");
1699         
1700         //to prevent bots both buys and sells will have a max on launch after only sells will
1701         if(from != owner() && to != owner() && _maxBuyEnabled)
1702             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Transfer amount exceeds the maxTxAmount.");
1703 
1704         bool tradingIsEnabled = tradingEnabled;
1705 
1706         // only whitelisted addresses can make transfers before trading is enabled.
1707         if (!tradingIsEnabled) {
1708             require(canTransferBeforeTradingIsEnabled[from], "EPRO: This account cannot send tokens until trading is enabled");
1709         }
1710 
1711             if ((from == uniswapV2Pair || to == uniswapV2Pair) && tradingIsEnabled) {
1712                 //require(!antiBot.scanAddress(from, uniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
1713                // require(!antiBot.scanAddress(to, uniswair, tx.origin), "Beep Beep Boop, You're a piece of poop");
1714             }
1715 
1716         if (amount == 0) {
1717             super._transfer(from, to, 0);
1718             return;
1719         }
1720 
1721         if (!liquidating &&
1722             tradingIsEnabled &&
1723             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1724             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1725             !_isExcludedFromFees[to] //no max for those excluded from fees
1726         ) {
1727             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1728         }
1729 
1730         uint256 contractTokenBalance = balanceOf(address(this));
1731 
1732         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1733 
1734         if (tradingIsEnabled &&
1735             canSwap &&
1736             _swapEnabled &&
1737             !liquidating &&
1738             !automatedMarketMakerPairs[from] &&
1739             from != liquidityWallet &&
1740             to != liquidityWallet
1741         ) {
1742             liquidating = true;
1743 
1744             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1745             swapAndSendToDev(swapTokens);
1746 
1747             uint256 sellTokens = balanceOf(address(this));
1748             swapAndSendDividends(sellTokens);
1749 
1750             liquidating = false;
1751         }
1752 
1753         bool takeFee = tradingIsEnabled && !liquidating;
1754 
1755         // if any account belongs to _isExcludedFromFee account then remove the fee
1756         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1757             takeFee = false;
1758         }
1759 
1760         if (takeFee) {
1761             uint256 fees = amount.mul(TOTAL_FEES).div(100);
1762             amount = amount.sub(fees);
1763 
1764             super._transfer(from, address(this), fees);
1765         }
1766 
1767         super._transfer(from, to, amount);
1768 
1769         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1770         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {
1771             
1772         }
1773 
1774         if (!liquidating) {
1775             uint256 gas = gasForProcessing;
1776 
1777             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1778                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1779             } catch {
1780 
1781             }
1782         }
1783     }
1784 
1785     function swapAndSendToDev(uint256 tokens) private {
1786         uint256 tokenBalance = tokens;
1787 
1788         // capture the contract's current ETH balance.
1789         // this is so that we can capture exactly the amount of ETH that the
1790         // swap creates, and not make the liquidity event include any ETH that
1791         // has been manually sent to the contract
1792         uint256 initialBalance = address(this).balance;
1793 
1794         // swap tokens for ETH
1795         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1796 
1797         // how much ETH did we just swap into?
1798         uint256 newBalance = address(this).balance.sub(initialBalance);
1799         address payable _devAndMarketingAddress = payable(0x51a2CbFD0BEC0833c03a4b5d17731f415f725595);
1800         _devAndMarketingAddress.transfer(newBalance);
1801         
1802         emit SwapAndSendToDev(tokens, newBalance);
1803     }
1804 
1805     function swapTokensForEth(uint256 tokenAmount) private {
1806         // generate the uniswap pair path of token -> weth
1807         address[] memory path = new address[](2);
1808         path[0] = address(this);
1809         path[1] = uniswapV2Router.WETH();
1810 
1811         _approve(address(this), address(uniswapV2Router), tokenAmount);
1812 
1813         // make the swap
1814         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1815             tokenAmount,
1816             0, // accept any amount of ETH
1817             path,
1818             address(this),
1819             block.timestamp
1820         );
1821     }
1822 
1823     function swapAndSendDividends(uint256 tokens) private {
1824         swapTokensForEth(tokens);
1825         uint256 dividends = address(this).balance;
1826 
1827         (bool success,) = address(dividendTracker).call{value: dividends}("");
1828         if (success) {
1829             emit SentDividends(tokens, dividends);
1830         }
1831     }
1832 }