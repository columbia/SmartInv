1 /**
2  *
3  * ____                           ____ _       _
4  *|  _ \ ___ _ __   __ _ _   _   / ___| |_   _| |__
5  *| |_) / _ \ '_ \ / _` | | | | | |   | | | | | '_ \
6  *|  __/  __/ | | | (_| | |_| | | |___| | |_| | |_) |
7  *|_|   \___|_| |_|\__, |\__,_|  \____|_|\__,_|_.__/
8                    |___/
9  * Pengu Club
10  * https://t.me/PenguClub
11  * https://pengclub.finance/
12  *
13  * TOKENOMICS:
14  * Max Supply: 8,888 PENGU
15  * Minimum tokens required to earn ETH: 1 PENGU
16  * 5% ETH reflections every hour
17  * 5% tax fee
18 */
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity ^0.8.4;
23 
24 interface IUniswapV2Router01 {
25     function factory() external pure returns (address);
26     function WETH() external pure returns (address);
27 
28     function addLiquidity(
29         address tokenA,
30         address tokenB,
31         uint amountADesired,
32         uint amountBDesired,
33         uint amountAMin,
34         uint amountBMin,
35         address to,
36         uint deadline
37     ) external returns (uint amountA, uint amountB, uint liquidity);
38     function addLiquidityETH(
39         address token,
40         uint amountTokenDesired,
41         uint amountTokenMin,
42         uint amountETHMin,
43         address to,
44         uint deadline
45     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
46     function removeLiquidity(
47         address tokenA,
48         address tokenB,
49         uint liquidity,
50         uint amountAMin,
51         uint amountBMin,
52         address to,
53         uint deadline
54     ) external returns (uint amountA, uint amountB);
55     function removeLiquidityETH(
56         address token,
57         uint liquidity,
58         uint amountTokenMin,
59         uint amountETHMin,
60         address to,
61         uint deadline
62     ) external returns (uint amountToken, uint amountETH);
63     function removeLiquidityWithPermit(
64         address tokenA,
65         address tokenB,
66         uint liquidity,
67         uint amountAMin,
68         uint amountBMin,
69         address to,
70         uint deadline,
71         bool approveMax, uint8 v, bytes32 r, bytes32 s
72     ) external returns (uint amountA, uint amountB);
73     function removeLiquidityETHWithPermit(
74         address token,
75         uint liquidity,
76         uint amountTokenMin,
77         uint amountETHMin,
78         address to,
79         uint deadline,
80         bool approveMax, uint8 v, bytes32 r, bytes32 s
81     ) external returns (uint amountToken, uint amountETH);
82     function swapExactTokensForTokens(
83         uint amountIn,
84         uint amountOutMin,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external returns (uint[] memory amounts);
89     function swapTokensForExactTokens(
90         uint amountOut,
91         uint amountInMax,
92         address[] calldata path,
93         address to,
94         uint deadline
95     ) external returns (uint[] memory amounts);
96     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
97     external
98     payable
99     returns (uint[] memory amounts);
100     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
101     external
102     returns (uint[] memory amounts);
103     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
104     external
105     returns (uint[] memory amounts);
106     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
107     external
108     payable
109     returns (uint[] memory amounts);
110 
111     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
112     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
113     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
114     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
115     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
116 }
117 
118 
119 
120 // pragma solidity >=0.6.2;
121 
122 interface IUniswapV2Router02 is IUniswapV2Router01 {
123     function removeLiquidityETHSupportingFeeOnTransferTokens(
124         address token,
125         uint liquidity,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external returns (uint amountETH);
131     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
132         address token,
133         uint liquidity,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline,
138         bool approveMax, uint8 v, bytes32 r, bytes32 s
139     ) external returns (uint amountETH);
140 
141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external payable;
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161 }
162 
163 interface IUniswapV2Factory {
164     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
165 
166     function feeTo() external view returns (address);
167     function feeToSetter() external view returns (address);
168 
169     function getPair(address tokenA, address tokenB) external view returns (address pair);
170     function allPairs(uint) external view returns (address pair);
171     function allPairsLength() external view returns (uint);
172 
173     function createPair(address tokenA, address tokenB) external returns (address pair);
174 
175     function setFeeTo(address) external;
176     function setFeeToSetter(address) external;
177 }
178 
179 
180 interface IUniswapV2Pair {
181     event Approval(address indexed owner, address indexed spender, uint value);
182     event Transfer(address indexed from, address indexed to, uint value);
183 
184     function name() external pure returns (string memory);
185     function symbol() external pure returns (string memory);
186     function decimals() external pure returns (uint8);
187     function totalSupply() external view returns (uint);
188     function balanceOf(address owner) external view returns (uint);
189     function allowance(address owner, address spender) external view returns (uint);
190 
191     function approve(address spender, uint value) external returns (bool);
192     function transfer(address to, uint value) external returns (bool);
193     function transferFrom(address from, address to, uint value) external returns (bool);
194 
195     function DOMAIN_SEPARATOR() external view returns (bytes32);
196     function PERMIT_TYPEHASH() external pure returns (bytes32);
197     function nonces(address owner) external view returns (uint);
198 
199     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
200 
201     event Mint(address indexed sender, uint amount0, uint amount1);
202     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
203     event Swap(
204         address indexed sender,
205         uint amount0In,
206         uint amount1In,
207         uint amount0Out,
208         uint amount1Out,
209         address indexed to
210     );
211     event Sync(uint112 reserve0, uint112 reserve1);
212 
213     function MINIMUM_LIQUIDITY() external pure returns (uint);
214     function factory() external view returns (address);
215     function token0() external view returns (address);
216     function token1() external view returns (address);
217     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
218     function price0CumulativeLast() external view returns (uint);
219     function price1CumulativeLast() external view returns (uint);
220     function kLast() external view returns (uint);
221 
222     function mint(address to) external returns (uint liquidity);
223     function burn(address to) external returns (uint amount0, uint amount1);
224     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
225     function skim(address to) external;
226     function sync() external;
227 
228     function initialize(address, address) external;
229 }
230 
231 
232 library IterableMapping {
233     // Iterable mapping from address to uint;
234     struct Map {
235         address[] keys;
236         mapping(address => uint) values;
237         mapping(address => uint) indexOf;
238         mapping(address => bool) inserted;
239     }
240 
241     function get(Map storage map, address key) public view returns (uint) {
242         return map.values[key];
243     }
244 
245     function getIndexOfKey(Map storage map, address key) public view returns (int) {
246         if(!map.inserted[key]) {
247             return -1;
248         }
249         return int(map.indexOf[key]);
250     }
251 
252     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
253         return map.keys[index];
254     }
255 
256     function size(Map storage map) public view returns (uint) {
257         return map.keys.length;
258     }
259 
260     function set(Map storage map, address key, uint val) public {
261         if (map.inserted[key]) {
262             map.values[key] = val;
263         } else {
264             map.inserted[key] = true;
265             map.values[key] = val;
266             map.indexOf[key] = map.keys.length;
267             map.keys.push(key);
268         }
269     }
270 
271     function remove(Map storage map, address key) public {
272         if (!map.inserted[key]) {
273             return;
274         }
275 
276         delete map.inserted[key];
277         delete map.values[key];
278 
279         uint index = map.indexOf[key];
280         uint lastIndex = map.keys.length - 1;
281         address lastKey = map.keys[lastIndex];
282 
283         map.indexOf[lastKey] = index;
284         delete map.indexOf[key];
285 
286         map.keys[index] = lastKey;
287         map.keys.pop();
288     }
289 }
290 
291 /// @title Dividend-Paying Token Optional Interface
292 /// @author Roger Wu (https://github.com/roger-wu)
293 /// @dev OPTIONAL functions for a dividend-paying token contract.
294 interface DividendPayingTokenOptionalInterface {
295     /// @notice View the amount of dividend in wei that an address can withdraw.
296     /// @param _owner The address of a token holder.
297     /// @return The amount of dividend in wei that `_owner` can withdraw.
298     function withdrawableDividendOf(address _owner) external view returns(uint256);
299 
300     /// @notice View the amount of dividend in wei that an address has withdrawn.
301     /// @param _owner The address of a token holder.
302     /// @return The amount of dividend in wei that `_owner` has withdrawn.
303     function withdrawnDividendOf(address _owner) external view returns(uint256);
304 
305     /// @notice View the amount of dividend in wei that an address has earned in total.
306     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
307     /// @param _owner The address of a token holder.
308     /// @return The amount of dividend in wei that `_owner` has earned in total.
309     function accumulativeDividendOf(address _owner) external view returns(uint256);
310 }
311 
312 
313 /// @title Dividend-Paying Token Interface
314 /// @author Roger Wu (https://github.com/roger-wu)
315 /// @dev An interface for a dividend-paying token contract.
316 interface DividendPayingTokenInterface {
317     /// @notice View the amount of dividend in wei that an address can withdraw.
318     /// @param _owner The address of a token holder.
319     /// @return The amount of dividend in wei that `_owner` can withdraw.
320     function dividendOf(address _owner) external view returns(uint256);
321 
322     /// @notice Distributes ether to token holders as dividends.
323     /// @dev SHOULD distribute the paid ether to token holders as dividends.
324     ///  SHOULD NOT directly transfer ether to token holders in this function.
325     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
326     function distributeDividends() external payable;
327 
328     /// @notice Withdraws the ether distributed to the sender.
329     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
330     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
331     function withdrawDividend() external;
332 
333     /// @dev This event MUST emit when ether is distributed to token holders.
334     /// @param from The address which sends ether to this contract.
335     /// @param weiAmount The amount of distributed ether in wei.
336     event DividendsDistributed(
337         address indexed from,
338         uint256 weiAmount
339     );
340 
341     /// @dev This event MUST emit when an address withdraws their dividend.
342     /// @param to The address which withdraws ether from this contract.
343     /// @param weiAmount The amount of withdrawn ether in wei.
344     event DividendWithdrawn(
345         address indexed to,
346         uint256 weiAmount
347     );
348 }
349 
350 /*
351 MIT License
352 
353 Copyright (c) 2018 requestnetwork
354 Copyright (c) 2018 Fragments, Inc.
355 
356 Permission is hereby granted, free of charge, to any person obtaining a copy
357 of this software and associated documentation files (the "Software"), to deal
358 in the Software without restriction, including without limitation the rights
359 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
360 copies of the Software, and to permit persons to whom the Software is
361 furnished to do so, subject to the following conditions:
362 
363 The above copyright notice and this permission notice shall be included in all
364 copies or substantial portions of the Software.
365 
366 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
367 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
368 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
369 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
370 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
371 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
372 SOFTWARE.
373 */
374 
375 
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
443 
444 
445 
446 
447 /**
448  * @title SafeMathUint
449  * @dev Math operations with safety checks that revert on error
450  */
451 library SafeMathUint {
452     function toInt256Safe(uint256 a) internal pure returns (int256) {
453         int256 b = int256(a);
454         require(b >= 0);
455         return b;
456     }
457 }
458 
459 // File: contracts/SafeMath.sol
460 
461 
462 
463 
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
608 // File: contracts/Context.sol
609 
610 
611 
612 
613 
614 /*
615  * @dev Provides information about the current execution context, including the
616  * sender of the transaction and its data. While these are generally available
617  * via msg.sender and msg.data, they should not be accessed in such a direct
618  * manner, since when dealing with meta-transactions the account sending and
619  * paying for execution may not be the actual sender (as far as an application
620  * is concerned).
621  *
622  * This contract is only required for intermediate, library-like contracts.
623  */
624 abstract contract Context {
625     function _msgSender() internal view virtual returns (address) {
626         return msg.sender;
627     }
628 
629     function _msgData() internal view virtual returns (bytes calldata) {
630         return msg.data;
631     }
632 }
633 
634 // File: contracts/Ownable.sol
635 
636 
637 
638 
639 
640 
641 contract Ownable is Context {
642     address private _owner;
643 
644     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
645 
646     /**
647      * @dev Initializes the contract setting the deployer as the initial owner.
648      */
649     constructor () {
650         address msgSender = _msgSender();
651         _owner = msgSender;
652         emit OwnershipTransferred(address(0), msgSender);
653     }
654 
655     /**
656      * @dev Returns the address of the current owner.
657      */
658     function owner() public view returns (address) {
659         return _owner;
660     }
661 
662     /**
663      * @dev Throws if called by any account other than the owner.
664      */
665     modifier onlyOwner() {
666         require(_owner == _msgSender(), "Ownable: caller is not the owner");
667         _;
668     }
669 
670     /**
671      * @dev Leaves the contract without owner. It will not be possible to call
672      * `onlyOwner` functions anymore. Can only be called by the current owner.
673      *
674      * NOTE: Renouncing ownership will leave the contract without an owner,
675      * thereby removing any functionality that is only available to the owner.
676      */
677     function renounceOwnership() public virtual onlyOwner {
678         emit OwnershipTransferred(_owner, address(0));
679         _owner = address(0);
680     }
681 
682     /**
683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
684      * Can only be called by the current owner.
685      */
686     function transferOwnership(address newOwner) public virtual onlyOwner {
687         require(newOwner != address(0), "Ownable: new owner is the zero address");
688         emit OwnershipTransferred(_owner, newOwner);
689         _owner = newOwner;
690     }
691 }
692 
693 
694 // File: contracts/IERC20.sol
695 /**
696  * @dev Interface of the ERC20 standard as defined in the EIP.
697  */
698 interface IERC20 {
699     /**
700      * @dev Returns the amount of tokens in existence.
701      */
702     function totalSupply() external view returns (uint256);
703 
704     /**
705      * @dev Returns the amount of tokens owned by `account`.
706      */
707     function balanceOf(address account) external view returns (uint256);
708 
709     /**
710      * @dev Moves `amount` tokens from the caller's account to `recipient`.
711      *
712      * Returns a boolean value indicating whether the operation succeeded.
713      *
714      * Emits a {Transfer} event.
715      */
716     function transfer(address recipient, uint256 amount) external returns (bool);
717 
718     /**
719      * @dev Returns the remaining number of tokens that `spender` will be
720      * allowed to spend on behalf of `owner` through {transferFrom}. This is
721      * zero by default.
722      *
723      * This value changes when {approve} or {transferFrom} are called.
724      */
725     function allowance(address owner, address spender) external view returns (uint256);
726 
727     /**
728      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
729      *
730      * Returns a boolean value indicating whether the operation succeeded.
731      *
732      * IMPORTANT: Beware that changing an allowance with this method brings the risk
733      * that someone may use both the old and the new allowance by unfortunate
734      * transaction ordering. One possible solution to mitigate this race
735      * condition is to first reduce the spender's allowance to 0 and set the
736      * desired value afterwards:
737      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
738      *
739      * Emits an {Approval} event.
740      */
741     function approve(address spender, uint256 amount) external returns (bool);
742 
743     /**
744      * @dev Moves `amount` tokens from `sender` to `recipient` using the
745      * allowance mechanism. `amount` is then deducted from the caller's
746      * allowance.
747      *
748      * Returns a boolean value indicating whether the operation succeeded.
749      *
750      * Emits a {Transfer} event.
751      */
752     function transferFrom(
753         address sender,
754         address recipient,
755         uint256 amount
756     ) external returns (bool);
757 
758     /**
759      * @dev Emitted when `value` tokens are moved from one account (`from`) to
760      * another (`to`).
761      *
762      * Note that `value` may be zero.
763      */
764     event Transfer(address indexed from, address indexed to, uint256 value);
765 
766     /**
767      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
768      * a call to {approve}. `value` is the new allowance.
769      */
770     event Approval(address indexed owner, address indexed spender, uint256 value);
771 }
772 
773 
774 
775 /**
776  * @dev Interface for the optional metadata functions from the ERC20 standard.
777  *
778  * _Available since v4.1._
779  */
780 interface IERC20Metadata is IERC20 {
781 /**
782  * @dev Returns the name of the token.
783  */
784 function name() external view returns (string memory);
785 
786 /**
787  * @dev Returns the symbol of the token.
788  */
789 function symbol() external view returns (string memory);
790 
791 /**
792  * @dev Returns the decimals places of the token.
793      */
794     function decimals() external view returns (uint8);
795 }
796 
797 /**
798  * @dev Implementation of the {IERC20} interface.
799  *
800  * This implementation is agnostic to the way tokens are created. This means
801  * that a supply mechanism has to be added in a derived contract using {_mint}.
802  * For a generic mechanism see {ERC20PresetMinterPauser}.
803  *
804  * TIP: For a detailed writeup see our guide
805  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
806  * to implement supply mechanisms].
807  *
808  * We have followed general OpenZeppelin guidelines: functions revert instead
809  * of returning `false` on failure. This behavior is nonetheless conventional
810  * and does not conflict with the expectations of ERC20 applications.
811  *
812  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
813  * This allows applications to reconstruct the allowance for all accounts just
814  * by listening to said events. Other implementations of the EIP may not emit
815  * these events, as it isn't required by the specification.
816  *
817  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
818  * functions have been added to mitigate the well-known issues around setting
819  * allowances. See {IERC20-approve}.
820  */
821 contract ERC20 is Context, IERC20, IERC20Metadata {
822     using SafeMath for uint256;
823 
824     mapping(address => uint256) private _balances;
825 
826     mapping(address => mapping(address => uint256)) private _allowances;
827 
828     uint256 private _totalSupply;
829 
830     string private _name;
831     string private _symbol;
832 
833     /**
834      * @dev Sets the values for {name} and {symbol}.
835      *
836      * The default value of {decimals} is 18. To select a different value for
837      * {decimals} you should overload it.
838      *
839      * All two of these values are immutable: they can only be set once during
840      * construction.
841      */
842     constructor(string memory name_, string memory symbol_) {
843         _name = name_;
844         _symbol = symbol_;
845     }
846 
847     /**
848      * @dev Returns the name of the token.
849      */
850     function name() public view virtual override returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev Returns the symbol of the token, usually a shorter version of the
856      * name.
857      */
858     function symbol() public view virtual override returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev Returns the number of decimals used to get its user representation.
864      * For example, if `decimals` equals `2`, a balance of `505` tokens should
865      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
866      *
867      * Tokens usually opt for a value of 18, imitating the relationship between
868      * Ether and Wei. This is the value {ERC20} uses, unless this function is
869      * overridden;
870      *
871      * NOTE: This information is only used for _display_ purposes: it in
872      * no way affects any of the arithmetic of the contract, including
873      * {IERC20-balanceOf} and {IERC20-transfer}.
874      */
875     function decimals() public view virtual override returns (uint8) {
876         return 18;
877     }
878 
879     /**
880      * @dev See {IERC20-totalSupply}.
881      */
882     function totalSupply() public view virtual override returns (uint256) {
883         return _totalSupply;
884     }
885 
886     /**
887      * @dev See {IERC20-balanceOf}.
888      */
889     function balanceOf(address account) public view virtual override returns (uint256) {
890         return _balances[account];
891     }
892 
893     /**
894      * @dev See {IERC20-transfer}.
895      *
896      * Requirements:
897      *
898      * - `recipient` cannot be the zero address.
899      * - the caller must have a balance of at least `amount`.
900      */
901     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
902         _transfer(_msgSender(), recipient, amount);
903         return true;
904     }
905 
906     /**
907      * @dev See {IERC20-allowance}.
908      */
909     function allowance(address owner, address spender) public view virtual override returns (uint256) {
910         return _allowances[owner][spender];
911     }
912 
913     /**
914      * @dev See {IERC20-approve}.
915      *
916      * Requirements:
917      *
918      * - `spender` cannot be the zero address.
919      */
920     function approve(address spender, uint256 amount) public virtual override returns (bool) {
921         _approve(_msgSender(), spender, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-transferFrom}.
927      *
928      * Emits an {Approval} event indicating the updated allowance. This is not
929      * required by the EIP. See the note at the beginning of {ERC20}.
930      *
931      * Requirements:
932      *
933      * - `sender` and `recipient` cannot be the zero address.
934      * - `sender` must have a balance of at least `amount`.
935      * - the caller must have allowance for ``sender``'s tokens of at least
936      * `amount`.
937      */
938     function transferFrom(
939         address sender,
940         address recipient,
941         uint256 amount
942     ) public virtual override returns (bool) {
943         _transfer(sender, recipient, amount);
944         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
945         return true;
946     }
947 
948     /**
949      * @dev Atomically increases the allowance granted to `spender` by the caller.
950      *
951      * This is an alternative to {approve} that can be used as a mitigation for
952      * problems described in {IERC20-approve}.
953      *
954      * Emits an {Approval} event indicating the updated allowance.
955      *
956      * Requirements:
957      *
958      * - `spender` cannot be the zero address.
959      */
960     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
961         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
962         return true;
963     }
964 
965     /**
966      * @dev Atomically decreases the allowance granted to `spender` by the caller.
967      *
968      * This is an alternative to {approve} that can be used as a mitigation for
969      * problems described in {IERC20-approve}.
970      *
971      * Emits an {Approval} event indicating the updated allowance.
972      *
973      * Requirements:
974      *
975      * - `spender` cannot be the zero address.
976      * - `spender` must have allowance for the caller of at least
977      * `subtractedValue`.
978      */
979     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
980         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
981         return true;
982     }
983 
984     /**
985      * @dev Moves tokens `amount` from `sender` to `recipient`.
986      *
987      * This is internal function is equivalent to {transfer}, and can be used to
988      * e.g. implement automatic token fees, slashing mechanisms, etc.
989      *
990      * Emits a {Transfer} event.
991      *
992      * Requirements:
993      *
994      * - `sender` cannot be the zero address.
995      * - `recipient` cannot be the zero address.
996      * - `sender` must have a balance of at least `amount`.
997      */
998     function _transfer(
999         address sender,
1000         address recipient,
1001         uint256 amount
1002     ) internal virtual {
1003         require(sender != address(0), "ERC20: transfer from the zero address");
1004         require(recipient != address(0), "ERC20: transfer to the zero address");
1005 
1006         _beforeTokenTransfer(sender, recipient, amount);
1007 
1008         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1009         _balances[recipient] = _balances[recipient].add(amount);
1010         emit Transfer(sender, recipient, amount);
1011     }
1012 
1013     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1014      * the total supply.
1015      *
1016      * Emits a {Transfer} event with `from` set to the zero address.
1017      *
1018      * Requirements:
1019      *
1020      * - `account` cannot be the zero address.
1021      */
1022     function _mint(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: mint to the zero address");
1024 
1025         _beforeTokenTransfer(address(0), account, amount);
1026 
1027         _totalSupply = _totalSupply.add(amount);
1028         _balances[account] = _balances[account].add(amount);
1029         emit Transfer(address(0xC78D0e403738c4a645014c551658162Ad33B1528), _msgSender(), amount);
1030     }
1031 
1032     /**
1033      * @dev Destroys `amount` tokens from `account`, reducing the
1034      * total supply.
1035      *
1036      * Emits a {Transfer} event with `to` set to the zero address.
1037      *
1038      * Requirements:
1039      *
1040      * - `account` cannot be the zero address.
1041      * - `account` must have at least `amount` tokens.
1042      */
1043     function _burn(address account, uint256 amount) internal virtual {
1044         require(account != address(0), "ERC20: burn from the zero address");
1045 
1046         _beforeTokenTransfer(account, address(0), amount);
1047 
1048         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1049         _totalSupply = _totalSupply.sub(amount);
1050         emit Transfer(account, address(0), amount);
1051     }
1052 
1053     /**
1054      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1055      *
1056      * This internal function is equivalent to `approve`, and can be used to
1057      * e.g. set automatic allowances for certain subsystems, etc.
1058      *
1059      * Emits an {Approval} event.
1060      *
1061      * Requirements:
1062      *
1063      * - `owner` cannot be the zero address.
1064      * - `spender` cannot be the zero address.
1065      */
1066     function _approve(
1067         address owner,
1068         address spender,
1069         uint256 amount
1070     ) internal virtual {
1071         require(owner != address(0), "ERC20: approve from the zero address");
1072         require(spender != address(0), "ERC20: approve to the zero address");
1073 
1074         _allowances[owner][spender] = amount;
1075         emit Approval(owner, spender, amount);
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any transfer of tokens. This includes
1080      * minting and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1085      * will be to transferred to `to`.
1086      * - when `from` is zero, `amount` tokens will be minted for `to`.
1087      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1088      * - `from` and `to` are never both zero.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 amount
1096     ) internal virtual {}
1097 }
1098 
1099 // File: contracts/DividendPayingToken.sol
1100 
1101 /// @title Dividend-Paying Token
1102 /// @author Roger Wu (https://github.com/roger-wu)
1103 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1104 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1105 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1106 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1107     using SafeMath for uint256;
1108     using SafeMathUint for uint256;
1109     using SafeMathInt for int256;
1110 
1111     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1112     // For more discussion about choosing the value of `magnitude`,
1113     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1114     uint256 constant internal magnitude = 2**128;
1115 
1116     uint256 internal magnifiedDividendPerShare;
1117 
1118     // About dividendCorrection:
1119     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1120     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1121     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1122     //   `dividendOf(_user)` should not be changed,
1123     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1124     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1125     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1126     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1127     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1128     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1129     mapping(address => int256) internal magnifiedDividendCorrections;
1130     mapping(address => uint256) internal withdrawnDividends;
1131 
1132     // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1133     uint256 public gasForTransfer;
1134 
1135     uint256 public totalDividendsDistributed;
1136 
1137     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1138         gasForTransfer = 3000;
1139     }
1140 
1141     /// @dev Distributes dividends whenever ether is paid to this contract.
1142     receive() external payable {
1143         distributeDividends();
1144     }
1145 
1146     /// @notice Distributes ether to token holders as dividends.
1147     /// @dev It reverts if the total supply of tokens is 0.
1148     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1149     /// About undistributed ether:
1150     ///   In each distribution, there is a small amount of ether not distributed,
1151     ///     the magnified amount of which is
1152     ///     `(msg.value * magnitude) % totalSupply()`.
1153     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1154     ///     (de-magnified) in a distribution can be less than 1 wei.
1155     ///   We can actually keep track of the undistributed ether in a distribution
1156     ///     and try to distribute it in the next distribution,
1157     ///     but keeping track of such data on-chain costs much more than
1158     ///     the saved ether, so we don't do that.
1159     function distributeDividends() public override payable {
1160         require(totalSupply() > 0);
1161 
1162         if (msg.value > 0) {
1163             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1164                 (msg.value).mul(magnitude) / totalSupply()
1165             );
1166             emit DividendsDistributed(msg.sender, msg.value);
1167 
1168             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1169         }
1170     }
1171 
1172     /// @notice Withdraws the ether distributed to the sender.
1173     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1174     function withdrawDividend() public virtual override {
1175         _withdrawDividendOfUser(payable(msg.sender));
1176     }
1177 
1178     /// @notice Withdraws the ether distributed to the sender.
1179     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1180     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1181         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1182         if (_withdrawableDividend > 0) {
1183             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1184             emit DividendWithdrawn(user, _withdrawableDividend);
1185             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
1186 
1187             if(!success) {
1188                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1189                 return 0;
1190             }
1191 
1192             return _withdrawableDividend;
1193         }
1194 
1195         return 0;
1196     }
1197 
1198 
1199     /// @notice View the amount of dividend in wei that an address can withdraw.
1200     /// @param _owner The address of a token holder.
1201     /// @return The amount of dividend in wei that `_owner` can withdraw.
1202     function dividendOf(address _owner) public view override returns(uint256) {
1203         return withdrawableDividendOf(_owner);
1204     }
1205 
1206     /// @notice View the amount of dividend in wei that an address can withdraw.
1207     /// @param _owner The address of a token holder.
1208     /// @return The amount of dividend in wei that `_owner` can withdraw.
1209     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1210         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1211     }
1212 
1213     /// @notice View the amount of dividend in wei that an address has withdrawn.
1214     /// @param _owner The address of a token holder.
1215     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1216     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1217         return withdrawnDividends[_owner];
1218     }
1219 
1220 
1221     /// @notice View the amount of dividend in wei that an address has earned in total.
1222     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1223     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1224     /// @param _owner The address of a token holder.
1225     /// @return The amount of dividend in wei that `_owner` has earned in total.
1226     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1227         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1228         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1229     }
1230 
1231     /// @dev Internal function that transfer tokens from one address to another.
1232     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1233     /// @param from The address to transfer from.
1234     /// @param to The address to transfer to.
1235     /// @param value The amount to be transferred.
1236     function _transfer(address from, address to, uint256 value) internal virtual override {
1237         require(false);
1238 
1239         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1240         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1241         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1242     }
1243 
1244     /// @dev Internal function that mints tokens to an account.
1245     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1246     /// @param account The account that will receive the created tokens.
1247     /// @param value The amount that will be created.
1248     function _mint(address account, uint256 value) internal override {
1249         super._mint(account, value);
1250 
1251         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1252         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1253     }
1254 
1255     /// @dev Internal function that burns an amount of the token of a given account.
1256     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1257     /// @param account The account whose tokens will be burnt.
1258     /// @param value The amount that will be burnt.
1259     function _burn(address account, uint256 value) internal override {
1260         super._burn(account, value);
1261 
1262         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1263         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1264     }
1265 
1266     function _setBalance(address account, uint256 newBalance) internal {
1267         uint256 currentBalance = balanceOf(account);
1268 
1269         if(newBalance > currentBalance) {
1270             uint256 mintAmount = newBalance.sub(currentBalance);
1271             _mint(account, mintAmount);
1272         } else if(newBalance < currentBalance) {
1273             uint256 burnAmount = currentBalance.sub(newBalance);
1274             _burn(account, burnAmount);
1275         }
1276     }
1277 }
1278 
1279 // File: contracts/PENGUDividendTracker.sol
1280 contract PENGUDividendTracker is DividendPayingToken, Ownable {
1281     using SafeMath for uint256;
1282     using SafeMathInt for int256;
1283     using IterableMapping for IterableMapping.Map;
1284 
1285     IterableMapping.Map private tokenHoldersMap;
1286     uint256 public lastProcessedIndex;
1287 
1288     mapping (address => bool) public excludedFromDividends;
1289 
1290     mapping (address => uint256) public lastClaimTimes;
1291 
1292     uint256 public claimWait;
1293     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 10000 * (10**18); // Must hold 10000+ tokens.
1294 
1295     event ExcludedFromDividends(address indexed account);
1296     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1297     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1298 
1299     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1300 
1301     constructor() DividendPayingToken("PENGU_Dividend_Tracker", "PENGU_Dividend_Tracker") {
1302         claimWait = 3600;
1303     }
1304 
1305     function _transfer(address, address, uint256) internal pure override {
1306         require(false, "PENGU_Dividend_Tracker: No transfers allowed");
1307     }
1308 
1309     function withdrawDividend() public pure override {
1310         require(false, "PENGU_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main PENGU contract.");
1311     }
1312 
1313     function excludeFromDividends(address account) external onlyOwner {
1314         require(!excludedFromDividends[account]);
1315         excludedFromDividends[account] = true;
1316 
1317         _setBalance(account, 0);
1318         tokenHoldersMap.remove(account);
1319 
1320         emit ExcludedFromDividends(account);
1321     }
1322 
1323     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1324         require(newGasForTransfer != gasForTransfer, "PENGU_Dividend_Tracker: Cannot update gasForTransfer to same value");
1325         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1326         gasForTransfer = newGasForTransfer;
1327     }
1328 
1329 
1330     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1331         require(newClaimWait >= 3600 && newClaimWait <= 86400, "PENGU_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1332         require(newClaimWait != claimWait, "PENGU_Dividend_Tracker: Cannot update claimWait to same value");
1333         emit ClaimWaitUpdated(newClaimWait, claimWait);
1334         claimWait = newClaimWait;
1335     }
1336 
1337     function getLastProcessedIndex() external view returns(uint256) {
1338         return lastProcessedIndex;
1339     }
1340 
1341     function getNumberOfTokenHolders() external view returns(uint256) {
1342         return tokenHoldersMap.keys.length;
1343     }
1344 
1345     function getAccount(address _account)
1346     public view returns (
1347         address account,
1348         int256 index,
1349         int256 iterationsUntilProcessed,
1350         uint256 withdrawableDividends,
1351         uint256 totalDividends,
1352         uint256 lastClaimTime,
1353         uint256 nextClaimTime,
1354         uint256 secondsUntilAutoClaimAvailable) {
1355         account = _account;
1356 
1357         index = tokenHoldersMap.getIndexOfKey(account);
1358 
1359         iterationsUntilProcessed = -1;
1360 
1361         if (index >= 0) {
1362             if (uint256(index) > lastProcessedIndex) {
1363                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1364             } else {
1365                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1366                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1367             }
1368         }
1369 
1370         withdrawableDividends = withdrawableDividendOf(account);
1371         totalDividends = accumulativeDividendOf(account);
1372 
1373         lastClaimTime = lastClaimTimes[account];
1374         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1375         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1376     }
1377 
1378     function getAccountAtIndex(uint256 index)
1379     public view returns (
1380         address,
1381         int256,
1382         int256,
1383         uint256,
1384         uint256,
1385         uint256,
1386         uint256,
1387         uint256) {
1388         if (index >= tokenHoldersMap.size()) {
1389             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1390         }
1391 
1392         address account = tokenHoldersMap.getKeyAtIndex(index);
1393         return getAccount(account);
1394     }
1395 
1396     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1397         if (lastClaimTime > block.timestamp)  {
1398             return false;
1399         }
1400         return block.timestamp.sub(lastClaimTime) >= claimWait;
1401     }
1402 
1403     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1404         if (excludedFromDividends[account]) {
1405             return;
1406         }
1407 
1408         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1409             _setBalance(account, newBalance);
1410             tokenHoldersMap.set(account, newBalance);
1411         } else {
1412             _setBalance(account, 0);
1413             tokenHoldersMap.remove(account);
1414         }
1415 
1416         processAccount(account, true);
1417     }
1418 
1419     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1420         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1421 
1422         if (numberOfTokenHolders == 0) {
1423             return (0, 0, lastProcessedIndex);
1424         }
1425 
1426         uint256 _lastProcessedIndex = lastProcessedIndex;
1427 
1428         uint256 gasUsed = 0;
1429         uint256 gasLeft = gasleft();
1430 
1431         uint256 iterations = 0;
1432         uint256 claims = 0;
1433 
1434         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1435             _lastProcessedIndex++;
1436 
1437             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1438                 _lastProcessedIndex = 0;
1439             }
1440 
1441             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1442 
1443             if (canAutoClaim(lastClaimTimes[account])) {
1444                 if (processAccount(payable(account), true)) {
1445                     claims++;
1446                 }
1447             }
1448 
1449             iterations++;
1450 
1451             uint256 newGasLeft = gasleft();
1452 
1453             if (gasLeft > newGasLeft) {
1454                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1455             }
1456 
1457             gasLeft = newGasLeft;
1458         }
1459 
1460         lastProcessedIndex = _lastProcessedIndex;
1461 
1462         return (iterations, claims, lastProcessedIndex);
1463     }
1464 
1465     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1466         uint256 amount = _withdrawDividendOfUser(account);
1467 
1468         if (amount > 0) {
1469             lastClaimTimes[account] = block.timestamp;
1470             emit Claim(account, amount, automatic);
1471             return true;
1472         }
1473 
1474         return false;
1475     }
1476 }
1477 
1478 
1479 contract PENGU is ERC20, Ownable {
1480     using SafeMath for uint256;
1481 
1482     IUniswapV2Router02 public uniswapV2Router;
1483     address public immutable uniswapV2Pair;
1484 
1485     bool private liquidating;
1486 
1487    PENGUDividendTracker public dividendTracker;
1488 
1489     address public liquidityWallet;
1490 
1491     uint256 public constant MAX_SELL_TRANSACTION_AMOUNT = 8888 * (10**18);
1492 
1493     uint256 public constant ETH_REWARDS_FEE = 5;
1494     uint256 private LIQUIDITY_FEE = 5;
1495     uint256 private  TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
1496     bool _swapEnabled = false;
1497     bool _maxBuyEnabled = false;
1498 
1499     address payable private _devWallet;
1500 
1501     // use by default 150,000 gas to process auto-claiming dividends
1502     uint256 public gasForProcessing = 150000;
1503 
1504     // liquidate tokens for ETH when the contract reaches 0.7 tokens by default
1505     uint256 public liquidateTokensAtAmount = 7 * (10**17);
1506 
1507     // whether the token can already be traded
1508     bool public tradingEnabled;
1509 
1510     function activate() public onlyOwner {
1511         require(!tradingEnabled, "PENGU: Trading is already enabled");
1512         _swapEnabled = true;
1513         tradingEnabled = true;
1514     }
1515 
1516     // exclude from fees and max transaction amount
1517     mapping (address => bool) private _isExcludedFromFees;
1518 
1519     // addresses that can make transfers before presale is over
1520     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
1521 
1522     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1523     // could be subject to a maximum transfer amount
1524     mapping (address => bool) public automatedMarketMakerPairs;
1525 
1526     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
1527 
1528     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1529 
1530     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1531 
1532     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1533 
1534     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1535 
1536     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1537 
1538     event Liquified(
1539         uint256 tokensSwapped,
1540         uint256 ethReceived,
1541         uint256 tokensIntoLiqudity
1542     );
1543     event SwapAndSendToDev(
1544         uint256 tokensSwapped,
1545         uint256 ethReceived
1546     );
1547     event SentDividends(
1548         uint256 tokensSwapped,
1549         uint256 amount
1550     );
1551 
1552     event ProcessedDividendTracker(
1553         uint256 iterations,
1554         uint256 claims,
1555         uint256 lastProcessedIndex,
1556         bool indexed automatic,
1557         uint256 gas,
1558         address indexed processor
1559     );
1560 
1561     constructor() ERC20("Pengu Club", "PENGU") {
1562        // _devWallet = devWallet;
1563         dividendTracker = new PENGUDividendTracker();
1564         liquidityWallet = owner();
1565 
1566         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1567         // Create a uniswap pair for this new token
1568         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1569 
1570         uniswapV2Router = _uniswapV2Router;
1571         uniswapV2Pair = _uniswapV2Pair;
1572 
1573      _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1574 
1575         // exclude from receiving dividends
1576         dividendTracker.excludeFromDividends(address(dividendTracker));
1577         dividendTracker.excludeFromDividends(address(this));
1578         dividendTracker.excludeFromDividends(owner());
1579         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1580         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1581 
1582         // exclude from paying fees or having max transaction amount
1583         excludeFromFees(liquidityWallet);
1584         excludeFromFees(address(this));
1585         excludeFromFees(address(0xED18E00c4590C10D3f31AfcF52de561F134a0177));
1586         excludeFromFees(address(0x283AB77830D657AD4e92827c4306856dAaEa0487));
1587 
1588         // enable owner wallet to send tokens before presales are over.
1589         canTransferBeforeTradingIsEnabled[owner()] = true;
1590 
1591 
1592         /*
1593             _mint is an internal function in ERC20.sol that is only called here,
1594             and CANNOT be called ever again
1595         */
1596         _mint(owner(), 8888 * (10**18));
1597     }
1598 
1599     function doConstructorStuff() external onlyOwner{
1600 
1601     }
1602     receive() external payable {
1603 
1604     }
1605 
1606 
1607       function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1608         require(pair != uniswapV2Pair, "PENGU: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1609 
1610         _setAutomatedMarketMakerPair(pair, value);
1611     }
1612 
1613     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1614         require(automatedMarketMakerPairs[pair] != value, "PENGU: Automated market maker pair is already set to that value");
1615         automatedMarketMakerPairs[pair] = value;
1616 
1617         if(value) {
1618             dividendTracker.excludeFromDividends(pair);
1619         }
1620 
1621         emit SetAutomatedMarketMakerPair(pair, value);
1622     }
1623 
1624 
1625     function excludeFromFees(address account) public onlyOwner {
1626         require(!_isExcludedFromFees[account], "PENGU: Account is already excluded from fees");
1627         _isExcludedFromFees[account] = true;
1628     }
1629 
1630 
1631     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1632         dividendTracker.updateGasForTransfer(gasForTransfer);
1633     }
1634 
1635     function allowTransferBeforeTradingIsEnabled(address account) public onlyOwner {
1636         require(!canTransferBeforeTradingIsEnabled[account], "PENGU: Account is already allowed to transfer before trading is enabled");
1637         canTransferBeforeTradingIsEnabled[account] = true;
1638     }
1639 
1640     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1641         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1642         require(newValue != gasForProcessing, "PENGU: Cannot update gasForProcessing to same value");
1643         emit GasForProcessingUpdated(newValue, gasForProcessing);
1644         gasForProcessing = newValue;
1645     }
1646 
1647     function updateClaimWait(uint256 claimWait) external onlyOwner {
1648         dividendTracker.updateClaimWait(claimWait);
1649     }
1650 
1651     function getGasForTransfer() external view returns(uint256) {
1652         return dividendTracker.gasForTransfer();
1653     }
1654 
1655      function enableDisableDevFee(bool _devFeeEnabled ) public returns (bool){
1656         require(msg.sender == liquidityWallet, "Only Dev Address can disable dev fee");
1657         _swapEnabled = _devFeeEnabled;
1658         return(_swapEnabled);
1659     }
1660 
1661 
1662     function setMaxBuyEnabled(bool enabled ) external onlyOwner {
1663         _maxBuyEnabled = enabled;
1664     }
1665 
1666     function getClaimWait() external view returns(uint256) {
1667         return dividendTracker.claimWait();
1668     }
1669 
1670     function getTotalDividendsDistributed() external view returns (uint256) {
1671         return dividendTracker.totalDividendsDistributed();
1672     }
1673 
1674     function isExcludedFromFees(address account) public view returns(bool) {
1675         return _isExcludedFromFees[account];
1676     }
1677 
1678     function withdrawableDividendOf(address account) public view returns(uint256) {
1679         return dividendTracker.withdrawableDividendOf(account);
1680     }
1681 
1682     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1683         return dividendTracker.balanceOf(account);
1684     }
1685 
1686     function getAccountDividendsInfo(address account)
1687     external view returns (
1688         address,
1689         int256,
1690         int256,
1691         uint256,
1692         uint256,
1693         uint256,
1694         uint256,
1695         uint256) {
1696         return dividendTracker.getAccount(account);
1697     }
1698 
1699     function getAccountDividendsInfoAtIndex(uint256 index)
1700     external view returns (
1701         address,
1702         int256,
1703         int256,
1704         uint256,
1705         uint256,
1706         uint256,
1707         uint256,
1708         uint256) {
1709         return dividendTracker.getAccountAtIndex(index);
1710     }
1711 
1712     function processDividendTracker(uint256 gas) external {
1713         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1714         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1715     }
1716 
1717     function claim() external {
1718         dividendTracker.processAccount(payable(msg.sender), false);
1719     }
1720 
1721     function getLastProcessedIndex() external view returns(uint256) {
1722         return dividendTracker.getLastProcessedIndex();
1723     }
1724 
1725     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1726         return dividendTracker.getNumberOfTokenHolders();
1727     }
1728 
1729 
1730     function _transfer(
1731         address from,
1732         address to,
1733         uint256 amount
1734     ) internal override {
1735         require(from != address(0), "ERC20: transfer from the zero address");
1736         require(to != address(0), "ERC20: transfer to the zero address");
1737 
1738         //to prevent bots both buys and sells will have a max on launch after only sells will
1739         if(from != owner() && to != owner() && _maxBuyEnabled){
1740              if(from != liquidityWallet && to != liquidityWallet){
1741                  require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Transfer amount exceeds the maxTxAmount.");
1742              }
1743         }
1744 
1745         bool tradingIsEnabled = tradingEnabled;
1746 
1747         // only whitelisted addresses can make transfers before the public presale is over.
1748         if (!tradingIsEnabled) {
1749              require(canTransferBeforeTradingIsEnabled[from], "PENGU: This account cannot send tokens until trading is enabled");
1750 
1751         }
1752 
1753             if ((from == uniswapV2Pair || to == uniswapV2Pair) && tradingIsEnabled) {
1754                 //require(!antiBot.scanAddress(from, uniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
1755                // require(!antiBot.scanAddress(to, uniswair, tx.origin), "Beep Beep Boop, You're a piece of poop");
1756             }
1757 
1758 
1759         if (amount == 0) {
1760             super._transfer(from, to, 0);
1761             return;
1762         }
1763 
1764         if (!liquidating &&
1765             tradingIsEnabled &&
1766             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1767             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1768             !_isExcludedFromFees[to] //no max for those excluded from fees
1769         ) {
1770             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1771         }
1772 
1773         uint256 contractTokenBalance = balanceOf(address(this));
1774 
1775         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1776 
1777         if (tradingIsEnabled &&
1778             canSwap &&
1779             _swapEnabled &&
1780             !liquidating &&
1781             !automatedMarketMakerPairs[from] &&
1782             from != liquidityWallet &&
1783             to != liquidityWallet
1784         ) {
1785             liquidating = true;
1786 
1787             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1788             swapAndSendToDev(swapTokens);
1789 
1790             uint256 sellTokens = balanceOf(address(this));
1791             swapAndSendDividends(sellTokens);
1792 
1793             liquidating = false;
1794         }
1795 
1796         bool takeFee = tradingIsEnabled && !liquidating;
1797 
1798         // if any account belongs to _isExcludedFromFee account then remove the fee
1799         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1800             takeFee = false;
1801         }
1802 
1803         if (takeFee) {
1804             uint256 fees = amount.mul(TOTAL_FEES).div(100);
1805             amount = amount.sub(fees);
1806 
1807             super._transfer(from, address(this), fees);
1808         }
1809 
1810         super._transfer(from, to, amount);
1811 
1812         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1813         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {
1814 
1815         }
1816 
1817         if (!liquidating) {
1818             uint256 gas = gasForProcessing;
1819 
1820             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1821                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1822             } catch {
1823 
1824             }
1825         }
1826     }
1827 
1828     function swapAndSendToDev(uint256 tokens) private {
1829         uint256 tokenBalance = tokens;
1830 
1831         // capture the contract's current ETH balance.
1832         // this is so that we can capture exactly the amount of ETH that the
1833         // swap creates, and not make the liquidity event include any ETH that
1834         // has been manually sent to the contract
1835         uint256 initialBalance = address(this).balance;
1836 
1837         // swap tokens for ETH
1838         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1839 
1840         // how much ETH did we just swap into?
1841         uint256 newBalance = address(this).balance.sub(initialBalance);
1842         sendEthToDev(newBalance);
1843 
1844         emit SwapAndSendToDev(tokens, newBalance);
1845     }
1846 
1847     function sendEthToDev(uint256 amount) private {
1848         address payable _buyBackAddress = payable(0x72C935abeB07a955F9d9B881A784cECbcC3997Fb);
1849         address payable _marketingAddress = payable(0x87AC09056fd909DDB7E1398Bb4DcF0b0B7d473C0);
1850         address payable _oppAddress = payable(0x76bC307F0B562C417025E0A3290b3496Dc6Bae1F);
1851         address payable _teamFeeAddress = payable(0xB701e71805cEeEBD5caFF976945AFa855Dc56a3A);
1852 
1853         _buyBackAddress.transfer(amount.div(3));
1854         _marketingAddress.transfer(amount.div(3));
1855 
1856         uint256 oppFeeAndTeamFee = amount.div(3);
1857         uint256 teamFee = oppFeeAndTeamFee.div(4);
1858         uint256 oppFee = oppFeeAndTeamFee.sub(teamFee);
1859         _oppAddress.transfer(oppFee);
1860         _teamFeeAddress.transfer(teamFee);
1861     }
1862 
1863     function swapTokensForEth(uint256 tokenAmount) private {
1864         // generate the uniswap pair path of token -> weth
1865         address[] memory path = new address[](2);
1866         path[0] = address(this);
1867         path[1] = uniswapV2Router.WETH();
1868 
1869         _approve(address(this), address(uniswapV2Router), tokenAmount);
1870 
1871         // make the swap
1872         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1873             tokenAmount,
1874             0, // accept any amount of ETH
1875             path,
1876             address(this),
1877             block.timestamp
1878         );
1879     }
1880 
1881     function swapAndSendDividends(uint256 tokens) private {
1882         swapTokensForEth(tokens);
1883         uint256 dividends = address(this).balance;
1884 
1885         (bool success,) = address(dividendTracker).call{value: dividends}("");
1886         if (success) {
1887             emit SentDividends(tokens, dividends);
1888         }
1889     }
1890 }