1 /*
2 * 
3 * Verse is the utility and governance token for Aidicraft, the bespoke and proprietory NFT marketplace of Aidi Finance. 
4 * 
5 * Features
6 * • AIDI Price Stability by in-built automatic buyback & burn
7 * • AidiCraft Operations Cost and Marketing
8 * • Rewards for the AidiCraft Platform users and Verse holders
9 * • Whale protection
10 * • Bot prevention 
11 * 
12 * Transaction Tax
13 * Total fee for buy/sell transactions = 10%, broken down as follows: 
14 * 
15 * 1) Automatic buyback and burn of AIDI — 3% 
16 * 2) ETH rewards for holders — 4% 
17 * 3) Marketing, Team, Charity fee — 3% 
18 * 
19 * P.S: If the daily sell amount goes above ‘maxDailySellAmount’, the total fee for sell transactions for that day = 20%
20 * 
21 * Telegram: t.me/versetoken
22 * Twitter: https://twitter.com/AidiVerse
23 * Website: https://aidiverse.com
24 * 
25 */
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity ^0.8.4;
30 
31 /*
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 /**
53  * @dev Interface of the ERC20 standard as defined in the EIP.
54  */
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) external returns (bool);
114 
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 /**
131  * @dev Interface for the optional metadata functions from the ERC20 standard.
132  *
133  * _Available since v4.1._
134  */
135 interface IERC20Metadata is IERC20 {
136     /**
137      * @dev Returns the name of the token.
138      */
139     function name() external view returns (string memory);
140 
141     /**
142      * @dev Returns the symbol of the token.
143      */
144     function symbol() external view returns (string memory);
145 
146     /**
147      * @dev Returns the decimals places of the token.
148      */
149     function decimals() external view returns (uint8);
150 }
151 
152 
153 /// @title Dividend-Paying Token Optional Interface
154 /// @author Roger Wu (https://github.com/roger-wu)
155 /// @dev OPTIONAL functions for a dividend-paying token contract.
156 interface DividendPayingTokenOptionalInterface {
157   /// @notice View the amount of dividend in wei that an address can withdraw.
158     /// @param _owner The address of a token holder.
159     /// @return The amount of dividend in wei that `_owner` can withdraw.
160     function withdrawableDividendOf(address _owner) external view returns(uint256);
161 
162     /// @notice View the amount of dividend in wei that an address has withdrawn.
163     /// @param _owner The address of a token holder.
164     /// @return The amount of dividend in wei that `_owner` has withdrawn.
165     function withdrawnDividendOf(address _owner) external view returns(uint256);
166 
167     /// @notice View the amount of dividend in wei that an address has earned in total.
168     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
169     /// @param _owner The address of a token holder.
170     /// @return The amount of dividend in wei that `_owner` has earned in total.
171     function accumulativeDividendOf(address _owner) external view returns(uint256);
172 }
173 
174 /// @title Dividend-Paying Token Interface
175 /// @author Roger Wu (https://github.com/roger-wu)
176 /// @dev An interface for a dividend-paying token contract.
177 interface DividendPayingTokenInterface {
178   /// @notice View the amount of dividend in wei that an address can withdraw.
179     /// @param _owner The address of a token holder.
180     /// @return The amount of dividend in wei that `_owner` can withdraw.
181     function dividendOf(address _owner) external view returns(uint256);
182 
183     /// @notice Distributes ether to token holders as dividends.
184     /// @dev SHOULD distribute the paid ether to token holders as dividends.
185     ///  SHOULD NOT directly transfer ether to token holders in this function.
186     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
187     function distributeDividends() external payable;
188 
189     /// @notice Withdraws the ether distributed to the sender.
190     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
191     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
192     function withdrawDividend() external;
193 
194     /// @dev This event MUST emit when ether is distributed to token holders.
195     /// @param from The address which sends ether to this contract.
196     /// @param weiAmount The amount of distributed ether in wei.
197     event DividendsDistributed(
198         address indexed from,
199         uint256 weiAmount
200     );
201 
202     /// @dev This event MUST emit when an address withdraws their dividend.
203     /// @param to The address which withdraws ether from this contract.
204     /// @param weiAmount The amount of withdrawn ether in wei.
205     event DividendWithdrawn(
206         address indexed to,
207         uint256 weiAmount
208     );
209 }
210 
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      *
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         return sub(a, b, "SafeMath: subtraction overflow");
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      *
268      * - Multiplication cannot overflow.
269      */
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272         // benefit is lost if 'b' is also tested.
273         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274         if (a == 0) {
275             return 0;
276         }
277 
278         uint256 c = a * b;
279         require(c / a == b, "SafeMath: multiplication overflow");
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         return div(a, b, "SafeMath: division by zero");
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         return mod(a, b, "SafeMath: modulo by zero");
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts with custom message when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 /*
355 MIT License
356 
357 Copyright (c) 2018 requestnetwork
358 Copyright (c) 2018 Fragments, Inc.
359 
360 Permission is hereby granted, free of charge, to any person obtaining a copy
361 of this software and associated documentation files (the "Software"), to deal
362 in the Software without restriction, including without limitation the rights
363 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
364 copies of the Software, and to permit persons to whom the Software is
365 furnished to do so, subject to the following conditions:
366 
367 The above copyright notice and this permission notice shall be included in all
368 copies or substantial portions of the Software.
369 
370 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
371 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
372 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
373 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
374 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
375 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
376 SOFTWARE.
377 */
378 /**
379  * @title SafeMathInt
380  * @dev Math operations for int256 with overflow safety checks.
381  */
382 library SafeMathInt {
383     int256 private constant MIN_INT256 = int256(1) << 255;
384     int256 private constant MAX_INT256 = ~(int256(1) << 255);
385 
386     /**
387      * @dev Multiplies two int256 variables and fails on overflow.
388      */
389     function mul(int256 a, int256 b) internal pure returns (int256) {
390         int256 c = a * b;
391 
392         // Detect overflow when multiplying MIN_INT256 with -1
393         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
394         require((b == 0) || (c / b == a));
395         return c;
396     }
397 
398     /**
399      * @dev Division of two int256 variables and fails on overflow.
400      */
401     function div(int256 a, int256 b) internal pure returns (int256) {
402         // Prevent overflow when dividing MIN_INT256 by -1
403         require(b != -1 || a != MIN_INT256);
404 
405         // Solidity already throws when dividing by 0.
406         return a / b;
407     }
408 
409     /**
410      * @dev Subtracts two int256 variables and fails on overflow.
411      */
412     function sub(int256 a, int256 b) internal pure returns (int256) {
413         int256 c = a - b;
414         require((b >= 0 && c <= a) || (b < 0 && c > a));
415         return c;
416     }
417 
418     /**
419      * @dev Adds two int256 variables and fails on overflow.
420      */
421     function add(int256 a, int256 b) internal pure returns (int256) {
422         int256 c = a + b;
423         require((b >= 0 && c >= a) || (b < 0 && c < a));
424         return c;
425     }
426 
427     /**
428      * @dev Converts to absolute value, and fails on overflow.
429      */
430     function abs(int256 a) internal pure returns (int256) {
431         require(a != MIN_INT256);
432         return a < 0 ? -a : a;
433     }
434 
435 
436     function toUint256Safe(int256 a) internal pure returns (uint256) {
437         require(a >= 0);
438         return uint256(a);
439     }
440 }
441 
442 /**
443  * @title SafeMathUint
444  * @dev Math operations with safety checks that revert on error
445  */
446 library SafeMathUint {
447   function toInt256Safe(uint256 a) internal pure returns (int256) {
448     int256 b = int256(a);
449     require(b >= 0);
450     return b;
451   }
452 }
453 
454 contract Ownable is Context {
455     address private _owner;
456 
457     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
458 
459     /**
460      * @dev Initializes the contract setting the deployer as the initial owner.
461      */
462     constructor () {
463         address msgSender = _msgSender();
464         _owner = msgSender;
465         emit OwnershipTransferred(address(0), msgSender);
466     }
467 
468     /**
469      * @dev Returns the address of the current owner.
470      */
471     function owner() public view returns (address) {
472         return _owner;
473     }
474 
475     /**
476      * @dev Throws if called by any account other than the owner.
477      */
478     modifier onlyOwner() {
479         require(_owner == _msgSender(), "Ownable: caller is not the owner");
480         _;
481     }
482 
483     /**
484      * @dev Leaves the contract without owner. It will not be possible to call
485      * `onlyOwner` functions anymore. Can only be called by the current owner.
486      *
487      * NOTE: Renouncing ownership will leave the contract without an owner,
488      * thereby removing any functionality that is only available to the owner.
489      */
490     function renounceOwnership() public virtual onlyOwner {
491         emit OwnershipTransferred(_owner, address(0));
492         _owner = address(0);
493     }
494 
495     /**
496      * @dev Transfers ownership of the contract to a new account (`newOwner`).
497      * Can only be called by the current owner.
498      */
499     function transferOwnership(address newOwner) public virtual onlyOwner {
500         require(newOwner != address(0), "Ownable: new owner is the zero address");
501         emit OwnershipTransferred(_owner, newOwner);
502         _owner = newOwner;
503     }
504 }
505 
506 library IterableMapping {
507     // Iterable mapping from address to uint;
508     struct Map {
509         address[] keys;
510         mapping(address => uint) values;
511         mapping(address => uint) indexOf;
512         mapping(address => bool) inserted;
513     }
514 
515     function get(Map storage map, address key) public view returns (uint) {
516         return map.values[key];
517     }
518 
519     function getIndexOfKey(Map storage map, address key) public view returns (int) {
520         if(!map.inserted[key]) {
521             return -1;
522         }
523         return int(map.indexOf[key]);
524     }
525 
526     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
527         return map.keys[index];
528     }
529 
530 
531 
532     function size(Map storage map) public view returns (uint) {
533         return map.keys.length;
534     }
535 
536     function set(Map storage map, address key, uint val) public {
537         if (map.inserted[key]) {
538             map.values[key] = val;
539         } else {
540             map.inserted[key] = true;
541             map.values[key] = val;
542             map.indexOf[key] = map.keys.length;
543             map.keys.push(key);
544         }
545     }
546 
547     function remove(Map storage map, address key) public {
548         if (!map.inserted[key]) {
549             return;
550         }
551 
552         delete map.inserted[key];
553         delete map.values[key];
554 
555         uint index = map.indexOf[key];
556         uint lastIndex = map.keys.length - 1;
557         address lastKey = map.keys[lastIndex];
558 
559         map.indexOf[lastKey] = index;
560         delete map.indexOf[key];
561 
562         map.keys[index] = lastKey;
563         map.keys.pop();
564     }
565 }
566 
567 interface IUniswapV2Pair {
568     event Approval(address indexed owner, address indexed spender, uint value);
569     event Transfer(address indexed from, address indexed to, uint value);
570 
571     function name() external pure returns (string memory);
572     function symbol() external pure returns (string memory);
573     function decimals() external pure returns (uint8);
574     function totalSupply() external view returns (uint);
575     function balanceOf(address owner) external view returns (uint);
576     function allowance(address owner, address spender) external view returns (uint);
577 
578     function approve(address spender, uint value) external returns (bool);
579     function transfer(address to, uint value) external returns (bool);
580     function transferFrom(address from, address to, uint value) external returns (bool);
581 
582     function DOMAIN_SEPARATOR() external view returns (bytes32);
583     function PERMIT_TYPEHASH() external pure returns (bytes32);
584     function nonces(address owner) external view returns (uint);
585 
586     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
587 
588     event Mint(address indexed sender, uint amount0, uint amount1);
589     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
590     event Swap(
591         address indexed sender,
592         uint amount0In,
593         uint amount1In,
594         uint amount0Out,
595         uint amount1Out,
596         address indexed to
597     );
598     event Sync(uint112 reserve0, uint112 reserve1);
599 
600     function MINIMUM_LIQUIDITY() external pure returns (uint);
601     function factory() external view returns (address);
602     function token0() external view returns (address);
603     function token1() external view returns (address);
604     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
605     function price0CumulativeLast() external view returns (uint);
606     function price1CumulativeLast() external view returns (uint);
607     function kLast() external view returns (uint);
608 
609     function mint(address to) external returns (uint liquidity);
610     function burn(address to) external returns (uint amount0, uint amount1);
611     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
612     function skim(address to) external;
613     function sync() external;
614 
615     function initialize(address, address) external;
616 }
617 
618 interface IUniswapV2Factory {
619     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
620 
621     function feeTo() external view returns (address);
622     function feeToSetter() external view returns (address);
623 
624     function getPair(address tokenA, address tokenB) external view returns (address pair);
625     function allPairs(uint) external view returns (address pair);
626     function allPairsLength() external view returns (uint);
627 
628     function createPair(address tokenA, address tokenB) external returns (address pair);
629 
630     function setFeeTo(address) external;
631     function setFeeToSetter(address) external;
632 }
633 
634 interface IUniswapV2Router01 {
635     function factory() external pure returns (address);
636     function WETH() external pure returns (address);
637 
638     function addLiquidity(
639         address tokenA,
640         address tokenB,
641         uint amountADesired,
642         uint amountBDesired,
643         uint amountAMin,
644         uint amountBMin,
645         address to,
646         uint deadline
647     ) external returns (uint amountA, uint amountB, uint liquidity);
648     function addLiquidityETH(
649         address token,
650         uint amountTokenDesired,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline
655     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
656     function removeLiquidity(
657         address tokenA,
658         address tokenB,
659         uint liquidity,
660         uint amountAMin,
661         uint amountBMin,
662         address to,
663         uint deadline
664     ) external returns (uint amountA, uint amountB);
665     function removeLiquidityETH(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline
672     ) external returns (uint amountToken, uint amountETH);
673     function removeLiquidityWithPermit(
674         address tokenA,
675         address tokenB,
676         uint liquidity,
677         uint amountAMin,
678         uint amountBMin,
679         address to,
680         uint deadline,
681         bool approveMax, uint8 v, bytes32 r, bytes32 s
682     ) external returns (uint amountA, uint amountB);
683     function removeLiquidityETHWithPermit(
684         address token,
685         uint liquidity,
686         uint amountTokenMin,
687         uint amountETHMin,
688         address to,
689         uint deadline,
690         bool approveMax, uint8 v, bytes32 r, bytes32 s
691     ) external returns (uint amountToken, uint amountETH);
692     function swapExactTokensForTokens(
693         uint amountIn,
694         uint amountOutMin,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external returns (uint[] memory amounts);
699     function swapTokensForExactTokens(
700         uint amountOut,
701         uint amountInMax,
702         address[] calldata path,
703         address to,
704         uint deadline
705     ) external returns (uint[] memory amounts);
706     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
707         external
708         payable
709         returns (uint[] memory amounts);
710     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
711         external
712         returns (uint[] memory amounts);
713     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
714         external
715         returns (uint[] memory amounts);
716     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
717         external
718         payable
719         returns (uint[] memory amounts);
720 
721     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
722     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
723     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
724     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
725     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
726 }
727 
728 
729 interface IUniswapV2Router02 is IUniswapV2Router01 {
730     function removeLiquidityETHSupportingFeeOnTransferTokens(
731         address token,
732         uint liquidity,
733         uint amountTokenMin,
734         uint amountETHMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountETH);
738     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
739         address token,
740         uint liquidity,
741         uint amountTokenMin,
742         uint amountETHMin,
743         address to,
744         uint deadline,
745         bool approveMax, uint8 v, bytes32 r, bytes32 s
746     ) external returns (uint amountETH);
747 
748     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
749         uint amountIn,
750         uint amountOutMin,
751         address[] calldata path,
752         address to,
753         uint deadline
754     ) external;
755     function swapExactETHForTokensSupportingFeeOnTransferTokens(
756         uint amountOutMin,
757         address[] calldata path,
758         address to,
759         uint deadline
760     ) external payable;
761     function swapExactTokensForETHSupportingFeeOnTransferTokens(
762         uint amountIn,
763         uint amountOutMin,
764         address[] calldata path,
765         address to,
766         uint deadline
767     ) external;
768 }
769 
770 /**
771  * @dev Implementation of the {IERC20} interface.
772  *
773  * This implementation is agnostic to the way tokens are created. This means
774  * that a supply mechanism has to be added in a derived contract using {_mint}.
775  * For a generic mechanism see {ERC20PresetMinterPauser}.
776  *
777  * TIP: For a detailed writeup see our guide
778  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
779  * to implement supply mechanisms].
780  *
781  * We have followed general OpenZeppelin guidelines: functions revert instead
782  * of returning `false` on failure. This behavior is nonetheless conventional
783  * and does not conflict with the expectations of ERC20 applications.
784  *
785  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
786  * This allows applications to reconstruct the allowance for all accounts just
787  * by listening to said events. Other implementations of the EIP may not emit
788  * these events, as it isn't required by the specification.
789  *
790  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
791  * functions have been added to mitigate the well-known issues around setting
792  * allowances. See {IERC20-approve}.
793  */
794 contract ERC20 is Context, IERC20, IERC20Metadata {
795     using SafeMath for uint256;
796 
797     mapping(address => uint256) private _balances;
798 
799     mapping(address => mapping(address => uint256)) private _allowances;
800 
801     uint256 private _totalSupply;
802 
803     string private _name;
804     string private _symbol;
805 
806     /**
807      * @dev Sets the values for {name} and {symbol}.
808      *
809      * The default value of {decimals} is 18. To select a different value for
810      * {decimals} you should overload it.
811      *
812      * All two of these values are immutable: they can only be set once during
813      * construction.
814      */
815     constructor(string memory name_, string memory symbol_) {
816         _name = name_;
817         _symbol = symbol_;
818     }
819 
820     /**
821      * @dev Returns the name of the token.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev Returns the symbol of the token, usually a shorter version of the
829      * name.
830      */
831     function symbol() public view virtual override returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev Returns the number of decimals used to get its user representation.
837      * For example, if `decimals` equals `2`, a balance of `505` tokens should
838      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
839      *
840      * Tokens usually opt for a value of 18, imitating the relationship between
841      * Ether and Wei. This is the value {ERC20} uses, unless this function is
842      * overridden;
843      *
844      * NOTE: This information is only used for _display_ purposes: it in
845      * no way affects any of the arithmetic of the contract, including
846      * {IERC20-balanceOf} and {IERC20-transfer}.
847      */
848     function decimals() public view virtual override returns (uint8) {
849         return 18;
850     }
851 
852     /**
853      * @dev See {IERC20-totalSupply}.
854      */
855     function totalSupply() public view virtual override returns (uint256) {
856         return _totalSupply;
857     }
858 
859     /**
860      * @dev See {IERC20-balanceOf}.
861      */
862     function balanceOf(address account) public view virtual override returns (uint256) {
863         return _balances[account];
864     }
865 
866     /**
867      * @dev See {IERC20-transfer}.
868      *
869      * Requirements:
870      *
871      * - `recipient` cannot be the zero address.
872      * - the caller must have a balance of at least `amount`.
873      */
874     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
875         _transfer(_msgSender(), recipient, amount);
876         return true;
877     }
878 
879     /**
880      * @dev See {IERC20-allowance}.
881      */
882     function allowance(address owner, address spender) public view virtual override returns (uint256) {
883         return _allowances[owner][spender];
884     }
885 
886     /**
887      * @dev See {IERC20-approve}.
888      *
889      * Requirements:
890      *
891      * - `spender` cannot be the zero address.
892      */
893     function approve(address spender, uint256 amount) public virtual override returns (bool) {
894         _approve(_msgSender(), spender, amount);
895         return true;
896     }
897 
898     /**
899      * @dev See {IERC20-transferFrom}.
900      *
901      * Emits an {Approval} event indicating the updated allowance. This is not
902      * required by the EIP. See the note at the beginning of {ERC20}.
903      *
904      * Requirements:
905      *
906      * - `sender` and `recipient` cannot be the zero address.
907      * - `sender` must have a balance of at least `amount`.
908      * - the caller must have allowance for ``sender``'s tokens of at least
909      * `amount`.
910      */
911     function transferFrom(
912         address sender,
913         address recipient,
914         uint256 amount
915     ) public virtual override returns (bool) {
916         _transfer(sender, recipient, amount);
917         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
918         return true;
919     }
920 
921     /**
922      * @dev Atomically increases the allowance granted to `spender` by the caller.
923      *
924      * This is an alternative to {approve} that can be used as a mitigation for
925      * problems described in {IERC20-approve}.
926      *
927      * Emits an {Approval} event indicating the updated allowance.
928      *
929      * Requirements:
930      *
931      * - `spender` cannot be the zero address.
932      */
933     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
934         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
935         return true;
936     }
937 
938     /**
939      * @dev Atomically decreases the allowance granted to `spender` by the caller.
940      *
941      * This is an alternative to {approve} that can be used as a mitigation for
942      * problems described in {IERC20-approve}.
943      *
944      * Emits an {Approval} event indicating the updated allowance.
945      *
946      * Requirements:
947      *
948      * - `spender` cannot be the zero address.
949      * - `spender` must have allowance for the caller of at least
950      * `subtractedValue`.
951      */
952     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
953         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
954         return true;
955     }
956 
957     /**
958      * @dev Moves tokens `amount` from `sender` to `recipient`.
959      *
960      * This is internal function is equivalent to {transfer}, and can be used to
961      * e.g. implement automatic token fees, slashing mechanisms, etc.
962      *
963      * Emits a {Transfer} event.
964      *
965      * Requirements:
966      *
967      * - `sender` cannot be the zero address.
968      * - `recipient` cannot be the zero address.
969      * - `sender` must have a balance of at least `amount`.
970      */
971     function _transfer(
972         address sender,
973         address recipient,
974         uint256 amount
975     ) internal virtual {
976         require(sender != address(0), "ERC20: transfer from the zero address");
977         require(recipient != address(0), "ERC20: transfer to the zero address");
978 
979         _beforeTokenTransfer(sender, recipient, amount);
980 
981         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
982         _balances[recipient] = _balances[recipient].add(amount);
983         emit Transfer(sender, recipient, amount);
984     }
985 
986     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
987      * the total supply.
988      *
989      * Emits a {Transfer} event with `from` set to the zero address.
990      *
991      * Requirements:
992      *
993      * - `account` cannot be the zero address.
994      */
995     function _mint(address account, uint256 amount) internal virtual {
996         require(account != address(0), "ERC20: mint to the zero address");
997 
998         _beforeTokenTransfer(address(0), account, amount);
999 
1000         _totalSupply = _totalSupply.add(amount);
1001         _balances[account] = _balances[account].add(amount);
1002         emit Transfer(address(0), account, amount);
1003     }
1004 
1005     /**
1006      * @dev Destroys `amount` tokens from `account`, reducing the
1007      * total supply.
1008      *
1009      * Emits a {Transfer} event with `to` set to the zero address.
1010      *
1011      * Requirements:
1012      *
1013      * - `account` cannot be the zero address.
1014      * - `account` must have at least `amount` tokens.
1015      */
1016     function _burn(address account, uint256 amount) internal virtual {
1017         require(account != address(0), "ERC20: burn from the zero address");
1018 
1019         _beforeTokenTransfer(account, address(0), amount);
1020 
1021         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1022         _totalSupply = _totalSupply.sub(amount);
1023         emit Transfer(account, address(0), amount);
1024     }
1025 
1026     /**
1027      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1028      *
1029      * This internal function is equivalent to `approve`, and can be used to
1030      * e.g. set automatic allowances for certain subsystems, etc.
1031      *
1032      * Emits an {Approval} event.
1033      *
1034      * Requirements:
1035      *
1036      * - `owner` cannot be the zero address.
1037      * - `spender` cannot be the zero address.
1038      */
1039     function _approve(
1040         address owner,
1041         address spender,
1042         uint256 amount
1043     ) internal virtual {
1044         require(owner != address(0), "ERC20: approve from the zero address");
1045         require(spender != address(0), "ERC20: approve to the zero address");
1046 
1047         _allowances[owner][spender] = amount;
1048         emit Approval(owner, spender, amount);
1049     }
1050 
1051     /**
1052      * @dev Hook that is called before any transfer of tokens. This includes
1053      * minting and burning.
1054      *
1055      * Calling conditions:
1056      *
1057      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1058      * will be to transferred to `to`.
1059      * - when `from` is zero, `amount` tokens will be minted for `to`.
1060      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1061      * - `from` and `to` are never both zero.
1062      *
1063      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1064      */
1065     function _beforeTokenTransfer(
1066         address from,
1067         address to,
1068         uint256 amount
1069     ) internal virtual {}
1070 }
1071 
1072 /// @title Dividend-Paying Token
1073 /// @author Roger Wu (https://github.com/roger-wu)
1074 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1075 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1076 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1077 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1078   using SafeMath for uint256;
1079     using SafeMathUint for uint256;
1080     using SafeMathInt for int256;
1081 
1082     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1083     // For more discussion about choosing the value of `magnitude`,
1084     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1085     uint256 constant internal magnitude = 2**128;
1086 
1087     uint256 internal magnifiedDividendPerShare;
1088 
1089     // About dividendCorrection:
1090     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1091     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1092     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1093     //   `dividendOf(_user)` should not be changed,
1094     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1095     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1096     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1097     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1098     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1099     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1100     mapping(address => int256) internal magnifiedDividendCorrections;
1101     mapping(address => uint256) internal withdrawnDividends;
1102 
1103     // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1104     uint256 public gasForTransfer;
1105 
1106     uint256 public totalDividendsDistributed;
1107 
1108     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1109         gasForTransfer = 3000;
1110     }
1111 
1112     /// @dev Distributes dividends whenever ether is paid to this contract.
1113     receive() external payable {
1114         distributeDividends();
1115     }
1116 
1117     /// @notice Distributes ether to token holders as dividends.
1118     /// @dev It reverts if the total supply of tokens is 0.
1119     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1120     /// About undistributed ether:
1121     ///   In each distribution, there is a small amount of ether not distributed,
1122     ///     the magnified amount of which is
1123     ///     `(msg.value * magnitude) % totalSupply()`.
1124     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1125     ///     (de-magnified) in a distribution can be less than 1 wei.
1126     ///   We can actually keep track of the undistributed ether in a distribution
1127     ///     and try to distribute it in the next distribution,
1128     ///     but keeping track of such data on-chain costs much more than
1129     ///     the saved ether, so we don't do that.
1130     function distributeDividends() public override payable {
1131         require(totalSupply() > 0);
1132 
1133         if (msg.value > 0) {
1134             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1135                 (msg.value).mul(magnitude) / totalSupply()
1136             );
1137             emit DividendsDistributed(msg.sender, msg.value);
1138 
1139             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1140         }
1141     }
1142 
1143     /// @notice Withdraws the ether distributed to the sender.
1144     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1145     function withdrawDividend() public virtual override {
1146         _withdrawDividendOfUser(payable(msg.sender));
1147     }
1148 
1149     /// @notice Withdraws the ether distributed to the sender.
1150     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1151     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1152         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1153         if (_withdrawableDividend > 0) {
1154             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1155             emit DividendWithdrawn(user, _withdrawableDividend);
1156             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
1157 
1158             if(!success) {
1159                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1160                 return 0;
1161             }
1162 
1163             return _withdrawableDividend;
1164         }
1165 
1166         return 0;
1167     }
1168 
1169 
1170     /// @notice View the amount of dividend in wei that an address can withdraw.
1171     /// @param _owner The address of a token holder.
1172     /// @return The amount of dividend in wei that `_owner` can withdraw.
1173     function dividendOf(address _owner) public view override returns(uint256) {
1174         return withdrawableDividendOf(_owner);
1175     }
1176 
1177     /// @notice View the amount of dividend in wei that an address can withdraw.
1178     /// @param _owner The address of a token holder.
1179     /// @return The amount of dividend in wei that `_owner` can withdraw.
1180     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1181         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1182     }
1183 
1184     /// @notice View the amount of dividend in wei that an address has withdrawn.
1185     /// @param _owner The address of a token holder.
1186     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1187     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1188         return withdrawnDividends[_owner];
1189     }
1190 
1191 
1192     /// @notice View the amount of dividend in wei that an address has earned in total.
1193     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1194     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1195     /// @param _owner The address of a token holder.
1196     /// @return The amount of dividend in wei that `_owner` has earned in total.
1197     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1198         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1199         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1200     }
1201 
1202     /// @dev Internal function that transfer tokens from one address to another.
1203     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1204     /// @param from The address to transfer from.
1205     /// @param to The address to transfer to.
1206     /// @param value The amount to be transferred.
1207     function _transfer(address from, address to, uint256 value) internal virtual override {
1208         require(false);
1209 
1210         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1211         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1212         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1213     }
1214 
1215     /// @dev Internal function that mints tokens to an account.
1216     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1217     /// @param account The account that will receive the created tokens.
1218     /// @param value The amount that will be created.
1219     function _mint(address account, uint256 value) internal override {
1220         super._mint(account, value);
1221 
1222         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1223         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1224     }
1225 
1226     /// @dev Internal function that burns an amount of the token of a given account.
1227     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1228     /// @param account The account whose tokens will be burnt.
1229     /// @param value The amount that will be burnt.
1230     function _burn(address account, uint256 value) internal override {
1231         super._burn(account, value);
1232 
1233         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1234         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1235     }
1236 
1237     function _setBalance(address account, uint256 newBalance) internal {
1238         uint256 currentBalance = balanceOf(account);
1239 
1240         if(newBalance > currentBalance) {
1241             uint256 mintAmount = newBalance.sub(currentBalance);
1242             _mint(account, mintAmount);
1243         } else if(newBalance < currentBalance) {
1244             uint256 burnAmount = currentBalance.sub(newBalance);
1245             _burn(account, burnAmount);
1246         }
1247     }
1248 }
1249 
1250 contract Verse is ERC20, Ownable {
1251     using SafeMath for uint256;
1252 
1253     IUniswapV2Router02 public uniswapV2Router;
1254     address public uniswapV2Pair;
1255 
1256     bool private swapping;
1257     bool public maxTransactionLimitEnabled = true;
1258     
1259     VerseDividendTracker public dividendTracker;
1260 
1261     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
1262     address payable public devMarketingAndCharityAddress = payable(0x761E70C4317dD1a16592aB5c44D95aF03F4abFca);
1263 
1264     //maximum purchase amount for initial launch
1265     uint256 maxTransactionAmount = 3250 * (10**18);
1266     uint256 public maxDailySellAmount = 3250 * (10**18);
1267     uint256 public swapTokensAtAmount = 1000 * (10**18);
1268 
1269     mapping(address => bool) private _isBot;
1270     address[] private _confirmedBots;
1271 
1272     bool public mechanismsEnabled = true;
1273     bool public aidiBuybackEnabled = true;
1274     bool public ethRedistributionEnabled = true;
1275     bool public devMarketingAndCharityEnabled = true;
1276 
1277     uint256 public buybackFee = 3;
1278     uint256 public ethRedistributeFee = 4;
1279     uint256 public devMarketingAndCharityFee = 3;
1280     uint256 public totalFee = 10;
1281     // use by default 150,000 gas to process auto-claiming dividends
1282     uint256 public gasForProcessing = 50000;
1283 
1284     // once set to true can never be set false again
1285     bool public tradingOpen = false;
1286     uint256 public launchTime;
1287 
1288     uint256 minimumTokenBalanceForDividends = 500 * (10**18);
1289 
1290 
1291     // exlcude from fees and max transaction amount
1292     mapping (address => bool) private _isExcludedFromFees;
1293 
1294     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1295     // could be subject to a maximum transfer amount
1296     mapping (address => bool) public automatedMarketMakerPairs;
1297 
1298     // store the amount sold for each account every day
1299     // to add extra tax
1300     mapping (uint256 => mapping(address => uint256)) public dailySell;
1301 
1302     // the last time an address transferred
1303     // used to detect if an account can be reinvest inactive funds to the vault
1304     mapping (address => uint256) public lastTransfer;
1305 
1306     mapping (address => bool) public isExcludedFromDailyLimit;
1307 
1308     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1309     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1310     event ExcludeFromFees(address indexed account, bool isExcluded);
1311     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1312     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1313     event SendDividends(uint256 amount);
1314     event DividendClaimed(uint256 ethAmount, uint256 tokenAmount, address account);
1315     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic, uint256 gas, address indexed processor);
1316     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1317 
1318     constructor() ERC20("Verse", "VERSE") {
1319 
1320     	dividendTracker = new VerseDividendTracker();
1321 
1322     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1323          // Create a uniswap pair for this new token
1324         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1325             .createPair(address(this), _uniswapV2Router.WETH());
1326 
1327         uniswapV2Router = _uniswapV2Router;
1328         uniswapV2Pair = _uniswapV2Pair;
1329 
1330         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1331 
1332         // exclude from receiving dividends
1333         dividendTracker.excludeFromDividends(address(dividendTracker));
1334         dividendTracker.excludeFromDividends(address(this));
1335         dividendTracker.excludeFromDividends(owner());
1336         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1337         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1338 
1339         // exclude from paying fees or having max transaction amount
1340         excludeFromFees(address(this), true);
1341         excludeFromFees(owner(), true);
1342 
1343         isExcludedFromDailyLimit[address(this)] = true;
1344         isExcludedFromDailyLimit[owner()] = true;
1345 
1346         _mint(owner(), 5000000 * (10**18));
1347     }
1348 
1349     receive() external payable {
1350 
1351   	}
1352 
1353     function updateDividendTracker(address newAddress) public onlyOwner {
1354         require(newAddress != address(dividendTracker), "Verse: The dividend tracker already has that address");
1355 
1356         VerseDividendTracker newDividendTracker = VerseDividendTracker(payable(newAddress));
1357 
1358         require(newDividendTracker.owner() == address(this), "Verse: The new dividend tracker must be owned by the Verse token contract");
1359 
1360         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1361 
1362         dividendTracker = newDividendTracker;
1363 
1364         dividendTracker.excludeFromDividends(address(newDividendTracker));
1365         dividendTracker.excludeFromDividends(address(this));
1366         dividendTracker.excludeFromDividends(owner());
1367         dividendTracker.excludeFromDividends(address(uniswapV2Router));
1368         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1369     }
1370 
1371     function updateUniswapV2Router(address newAddress) public onlyOwner {
1372         require(newAddress != address(uniswapV2Router), "Verse: The router already has that address");
1373         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1374         uniswapV2Router = IUniswapV2Router02(newAddress);
1375         dividendTracker.excludeFromDividends(address(uniswapV2Router));
1376     }
1377 
1378     function excludeFromFees(address account, bool excluded) public onlyOwner {
1379         require(_isExcludedFromFees[account] != excluded, "Verse: Account is already the value of 'excluded'");
1380         _isExcludedFromFees[account] = excluded;
1381 
1382         emit ExcludeFromFees(account, excluded);
1383     }
1384 
1385     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1386         for(uint256 i = 0; i < accounts.length; i++) {
1387             _isExcludedFromFees[accounts[i]] = excluded;
1388         }
1389 
1390         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1391     }
1392 
1393     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1394         require(pair != uniswapV2Pair, "Verse: The UniSwap pair cannot be removed from automatedMarketMakerPairs");
1395 
1396         _setAutomatedMarketMakerPair(pair, value);
1397     }
1398 
1399     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1400         require(automatedMarketMakerPairs[pair] != value, "Verse: Automated market maker pair is already set to that value");
1401         automatedMarketMakerPairs[pair] = value;
1402 
1403         if(value) {
1404             dividendTracker.excludeFromDividends(pair);
1405         }
1406 
1407         emit SetAutomatedMarketMakerPair(pair, value);
1408     }
1409 
1410     function excludeFromDailyLimit(address account, bool excluded) public onlyOwner {
1411         require(isExcludedFromDailyLimit[account] != excluded, "Verse: Daily limit exclusion is already the value of 'excluded'");
1412         isExcludedFromDailyLimit[account] = excluded;
1413     }
1414 
1415     function setMaxTransactionLimitEnabled(bool enabled) public onlyOwner {
1416         require(maxTransactionLimitEnabled != enabled, "Verse: Max transaction limit enabled is already the value of 'enabled'");
1417         maxTransactionLimitEnabled = enabled;
1418     }
1419     
1420     
1421     function setMechanismsEnabled(bool enabled) public onlyOwner {
1422         mechanismsEnabled = enabled;
1423     }
1424 
1425     function setAidiBuybackEnabled(bool enabled) public onlyOwner {
1426         aidiBuybackEnabled = enabled;
1427     }
1428 
1429     function setETHRedistributionEnabled(bool enabled) public onlyOwner {
1430         ethRedistributionEnabled = enabled;
1431     }
1432 
1433     function setDevMarketingAndCharityFeeEnabled(bool enabled) public onlyOwner {
1434         devMarketingAndCharityEnabled = enabled;
1435     }
1436 
1437     function setMaxTransactionAmount(uint256 newAmount) public onlyOwner {
1438         maxTransactionAmount = newAmount;
1439     }
1440     
1441     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
1442         swapTokensAtAmount = newAmount;
1443     }
1444 
1445     function setMaxDailySellAmount(uint256 newAmount) public onlyOwner {
1446         maxDailySellAmount = newAmount;
1447     }
1448 
1449     function updateDevMarketingAndCharityAddress(address payable newAddress) public onlyOwner {
1450         devMarketingAndCharityAddress = newAddress;
1451     }
1452 
1453 
1454     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1455         dividendTracker.updateGasForTransfer(gasForTransfer);
1456     }
1457 
1458     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1459         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1460         require(newValue != gasForProcessing, "Verse: Cannot update gasForProcessing to same value");
1461         emit GasForProcessingUpdated(newValue, gasForProcessing);
1462         gasForProcessing = newValue;
1463     }
1464 
1465     function updateClaimWait(uint256 claimWait) external onlyOwner {
1466         dividendTracker.updateClaimWait(claimWait);
1467     }
1468 
1469     function getGasForTransfer() external view returns(uint256) {
1470         return dividendTracker.gasForTransfer();
1471     }
1472 
1473 
1474     function getClaimWait() external view returns(uint256) {
1475         return dividendTracker.claimWait();
1476     }
1477 
1478     function getTotalDividendsDistributed() external view returns (uint256) {
1479         return dividendTracker.totalDividendsDistributed();
1480     }
1481 
1482     function isExcludedFromFees(address account) public view returns(bool) {
1483         return _isExcludedFromFees[account];
1484     }
1485 
1486     function withdrawableDividendOf(address account) public view returns(uint256) {
1487         return dividendTracker.withdrawableDividendOf(account);
1488     }
1489 
1490     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1491         return dividendTracker.balanceOf(account);
1492     }
1493 
1494     function getAccountDividendsInfo(address account)
1495     external view returns (
1496         address,
1497         int256,
1498         int256,
1499         uint256,
1500         uint256,
1501         uint256,
1502         uint256,
1503         uint256) {
1504         return dividendTracker.getAccount(account);
1505     }
1506 
1507     function getAccountDividendsInfoAtIndex(uint256 index)
1508     external view returns (
1509         address,
1510         int256,
1511         int256,
1512         uint256,
1513         uint256,
1514         uint256,
1515         uint256,
1516         uint256) {
1517         return dividendTracker.getAccountAtIndex(index);
1518     }
1519 
1520     function processDividendTracker(uint256 gas) external {
1521         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1522         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1523     }
1524 
1525     function claim() external {
1526         dividendTracker.processAccount(payable(msg.sender), false);
1527     }
1528 
1529     function getLastProcessedIndex() external view returns(uint256) {
1530         return dividendTracker.getLastProcessedIndex();
1531     }
1532 
1533     function getLastProcessedAccount()
1534     external view returns (
1535         address,
1536         int256,
1537         int256,
1538         uint256,
1539         uint256,
1540         uint256,
1541         uint256,
1542         uint256) {
1543         return dividendTracker.getLastProcessedAccount();
1544     }
1545 
1546     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1547         return dividendTracker.getNumberOfTokenHolders();
1548     }
1549 
1550     function reinvestInactive(address payable account) public onlyOwner {
1551         uint256 tokenBalance = dividendTracker.balanceOf(account);
1552         require(tokenBalance <= minimumTokenBalanceForDividends, "Verse: Account balance must be less then minimum token balance for dividends");
1553 
1554         uint256 _lastTransfer = lastTransfer[account];
1555         require(block.timestamp.sub(_lastTransfer) > 12 weeks, "Verse: Account must have been inactive for at least 12 weeks");
1556 
1557         dividendTracker.processAccount(account, false);
1558         uint256 dividends = address(this).balance;
1559         (bool success,) = address(dividendTracker).call{value: dividends}("");
1560 
1561         if(success) {
1562    	 		emit SendDividends(dividends);
1563             try dividendTracker.setBalance(account, 0) {} catch {}
1564         }
1565     }
1566 
1567 
1568     function _transfer(
1569         address from,
1570         address to,
1571         uint256 amount
1572     ) internal override {
1573         require(from != address(0), "ERC20: transfer from the zero address");
1574         require(to != address(0), "ERC20: transfer to the zero address");
1575         require(amount > 0, "Transfer amount must be greater than zero");
1576         
1577         if(from != owner() && to != owner()) {
1578             if(maxTransactionLimitEnabled)
1579             {
1580                 require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");
1581             }
1582             require(!_isBot[from], 'Bots not allowed here! Play fair.');//antibot
1583             require(!_isBot[to], 'Bots not allowed here! Play fair.');//antibot
1584         }
1585 
1586         // buy
1587         if (from == uniswapV2Pair &&
1588             to != address(uniswapV2Router) &&
1589             !_isExcludedFromFees[to]) {
1590             require(tradingOpen, 'Trading not yet enabled.');
1591 
1592             //antibot: block zero bots will be added to bot blacklist
1593             if (block.timestamp == launchTime) {
1594                 _isBot[to] = true;
1595                 _confirmedBots.push(to);
1596             }
1597         }
1598         
1599         if(mechanismsEnabled && !swapping)
1600         {
1601 
1602     		uint256 contractTokenBalance = balanceOf(address(this));
1603     
1604             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1605     
1606             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFees[to]) { //a buy
1607                 if(aidiBuybackEnabled)
1608                 {
1609                     buybackFee = 3;
1610                 }else{
1611                     buybackFee = 0;
1612                 }
1613                 if(ethRedistributionEnabled)
1614                 {
1615                     ethRedistributeFee = 4;
1616                 }else{
1617                     ethRedistributeFee = 0;
1618                 }
1619     
1620                 if(devMarketingAndCharityEnabled)
1621                 {
1622                     devMarketingAndCharityFee = 3;
1623                 }else{
1624                     devMarketingAndCharityFee = 0;
1625                 }
1626     
1627                 totalFee = buybackFee + ethRedistributeFee + devMarketingAndCharityFee;
1628             }else if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFees[to]) { //a sell
1629     
1630                 if(dailySell[getDay()][from].add(amount) > maxDailySellAmount)
1631                 {
1632     
1633                     if(aidiBuybackEnabled)
1634                     {
1635                         buybackFee = 6;
1636                     }else{
1637                         buybackFee = 0;
1638                     }
1639                     if(ethRedistributionEnabled)
1640                     {
1641                         ethRedistributeFee = 8;
1642                     }else{
1643                         ethRedistributeFee = 0;
1644                     }
1645     
1646                     if(devMarketingAndCharityEnabled)
1647                     {
1648                         devMarketingAndCharityFee = 6;
1649                     }else{
1650                         devMarketingAndCharityFee = 0;
1651                     }
1652     
1653                     totalFee = buybackFee + ethRedistributeFee + devMarketingAndCharityFee;
1654                 }else{
1655                     if(aidiBuybackEnabled)
1656                     {
1657                         buybackFee = 3;
1658                     }else{
1659                         buybackFee = 0;
1660                     }
1661                     if(ethRedistributionEnabled)
1662                     {
1663                         ethRedistributeFee = 4;
1664                     }else{
1665                         ethRedistributeFee = 0;
1666                     }
1667                     if(devMarketingAndCharityEnabled)
1668                     {
1669                         devMarketingAndCharityFee = 3;
1670                     }else{
1671                         devMarketingAndCharityFee = 0;
1672                     }
1673     
1674                     totalFee = buybackFee + ethRedistributeFee + devMarketingAndCharityFee;
1675                 }
1676                 dailySell[getDay()][from] = dailySell[getDay()][from].add(amount);
1677             }
1678     
1679     
1680             if( canSwap &&
1681             !automatedMarketMakerPairs[from] &&
1682             !_isExcludedFromFees[from] &&
1683             !_isExcludedFromFees[to] &&
1684             (totalFee > 0))
1685             {
1686                 swapping = true;
1687                 swapAndDistribute();
1688                 swapping = false;
1689             }
1690     
1691     
1692             bool takeFee = true;
1693     
1694             // if any account belongs to _isExcludedFromFee account then remove the fee
1695             // don't take a fee unless it's a buy / sell
1696             if((_isExcludedFromFees[from] || _isExcludedFromFees[to]) || (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to])) {
1697                 takeFee = false;
1698             }
1699     
1700             if(takeFee && (totalFee >0)) {
1701     
1702             	uint256 fees = amount.mul(totalFee).div(100);
1703             	amount = amount.sub(fees);
1704     
1705                 super._transfer(from, address(this), fees);
1706             }
1707         
1708             super._transfer(from, to, amount);
1709     
1710             try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1711             try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1712     
1713             lastTransfer[from] = block.timestamp;
1714             lastTransfer[to] = block.timestamp;
1715     
1716             if (ethRedistributionEnabled) {
1717                 uint256 gas = gasForProcessing;
1718     
1719                 try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1720                     emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1721                 } catch {
1722     
1723                 }
1724             }
1725         }else{
1726             super._transfer(from, to, amount);
1727         }
1728     }
1729 
1730     function swapTokensForEth(uint256 tokenAmount) private {
1731         // generate the uniswap pair path of token -> weth
1732         address[] memory path = new address[](2);
1733         path[0] = address(this);
1734         path[1] = uniswapV2Router.WETH();
1735 
1736         _approve(address(this), address(uniswapV2Router), tokenAmount);
1737 
1738         // make the swap
1739         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1740             tokenAmount,
1741             0, // accept any amount of ETH
1742             path,
1743             address(this),
1744             block.timestamp
1745         );
1746     }
1747 
1748     function swapEthForTokens(uint256 ethAmount, uint256 minTokens, address account) internal returns(uint256) {
1749         address[] memory path = new address[](2);
1750         path[0] = uniswapV2Router.WETH();
1751         path[1] = address(this);
1752 
1753         uint256 balanceBefore = balanceOf(account);
1754 
1755         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
1756             minTokens,
1757             path,
1758             account,
1759             block.timestamp
1760         );
1761 
1762         uint256 tokenAmount = balanceOf(account).sub(balanceBefore);
1763         return tokenAmount;
1764     }
1765 
1766     function swapAndDistribute() private {
1767         uint256 tokenBalance = balanceOf(address(this));
1768         swapTokensForEth(tokenBalance);
1769 
1770         uint256 ethBalance = address(this).balance;
1771         uint256 devMarketingAndCharityPortion = ethBalance.mul(devMarketingAndCharityFee).div(totalFee);
1772         uint256 buybackAndBurnPortion = ethBalance.mul(buybackFee).div(totalFee);
1773 
1774         if(devMarketingAndCharityEnabled && devMarketingAndCharityPortion > 0)
1775         {
1776             devMarketingAndCharityAddress.transfer(devMarketingAndCharityPortion);
1777         }
1778         if(aidiBuybackEnabled && buybackAndBurnPortion > 0)
1779         {
1780             buybackAndBurnAidiTokens(buybackAndBurnPortion);
1781         }
1782 
1783         uint256 dividends = address(this).balance;
1784         if(ethRedistributionEnabled && dividends > 0)
1785         {
1786             (bool success,) = address(dividendTracker).call{value: dividends}("");
1787 
1788             if(success) {
1789        	 		emit SendDividends(dividends);
1790             }
1791         }
1792     }
1793 
1794     function buybackAndBurnAidiTokens(uint256 amount) private {
1795         // generate the uniswap pair path of weth -> token
1796         address[] memory path = new address[](2);
1797         path[0] = uniswapV2Router.WETH();
1798         path[1] = address(0xdA1E53E088023Fe4D1DC5a418581748f52CBd1b8);
1799 
1800         // make the swap
1801         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1802             0, // accept any amount of Tokens
1803             path,
1804             deadAddress, // Burn address
1805             block.timestamp.add(300)
1806         );
1807     }
1808 
1809     function getDay() internal view returns(uint256){
1810         return block.timestamp.div(1 days);
1811     }
1812 
1813     function openTrading() external onlyOwner {
1814         tradingOpen = true;
1815         launchTime = block.timestamp;
1816     }
1817 
1818     function isBot(address account) public view returns (bool) {
1819         return _isBot[account];
1820     }
1821     //manual antibot, play fair!
1822     function _blacklistBot(address account) external onlyOwner() {
1823         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist Uniswap');
1824         require(!_isBot[account], "Account is already blacklisted");
1825         _isBot[account] = true;
1826         _confirmedBots.push(account);
1827     }
1828 
1829     function _amnestyBot(address account) external onlyOwner() {
1830         require(_isBot[account], "Account is not blacklisted");
1831         for (uint256 i = 0; i < _confirmedBots.length; i++) {
1832             if (_confirmedBots[i] == account) {
1833                 _confirmedBots[i] = _confirmedBots[_confirmedBots.length - 1];
1834                 _isBot[account] = false;
1835                 _confirmedBots.pop();
1836                 break;
1837             }
1838         }
1839     }
1840 }
1841 
1842 contract VerseDividendTracker is DividendPayingToken, Ownable {
1843     using SafeMath for uint256;
1844     using SafeMathInt for int256;
1845     using IterableMapping for IterableMapping.Map;
1846 
1847     IterableMapping.Map private tokenHoldersMap;
1848     uint256 public lastProcessedIndex;
1849 
1850     mapping (address => bool) public excludedFromDividends;
1851 
1852     mapping (address => uint256) public lastClaimTimes;
1853 
1854     uint256 public claimWait;
1855     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 500 * (10**18); // Must hold 500+ tokens.
1856 
1857     event ExcludedFromDividends(address indexed account);
1858     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1859     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1860 
1861     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1862 
1863     constructor() DividendPayingToken("Verse_Dividend_Tracker", "Verse_Dividend_Tracker") {
1864         claimWait = 3600;
1865     }
1866 
1867     function _transfer(address, address, uint256) internal pure override {
1868         require(false, "Verse_Dividend_Tracker: No transfers allowed");
1869     }
1870 
1871     function withdrawDividend() public pure override {
1872         require(false, "Verse_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main Verse contract.");
1873     }
1874 
1875     function excludeFromDividends(address account) external onlyOwner {
1876         require(!excludedFromDividends[account]);
1877         excludedFromDividends[account] = true;
1878 
1879         _setBalance(account, 0);
1880         tokenHoldersMap.remove(account);
1881 
1882         emit ExcludedFromDividends(account);
1883     }
1884 
1885     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1886         require(newGasForTransfer != gasForTransfer, "Verse_Dividend_Tracker: Cannot update gasForTransfer to same value");
1887         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1888         gasForTransfer = newGasForTransfer;
1889     }
1890 
1891 
1892     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1893         require(newClaimWait >= 3600 && newClaimWait <= 86400, "Verse_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1894         require(newClaimWait != claimWait, "Verse_Dividend_Tracker: Cannot update claimWait to same value");
1895         emit ClaimWaitUpdated(newClaimWait, claimWait);
1896         claimWait = newClaimWait;
1897     }
1898 
1899     function getLastProcessedIndex() external view returns(uint256) {
1900         return lastProcessedIndex;
1901     }
1902 
1903     function getNumberOfTokenHolders() external view returns(uint256) {
1904         return tokenHoldersMap.keys.length;
1905     }
1906 
1907     function getAccount(address _account)
1908     public view returns (
1909         address account,
1910         int256 index,
1911         int256 iterationsUntilProcessed,
1912         uint256 withdrawableDividends,
1913         uint256 totalDividends,
1914         uint256 lastClaimTime,
1915         uint256 nextClaimTime,
1916         uint256 secondsUntilAutoClaimAvailable) {
1917         account = _account;
1918 
1919         index = tokenHoldersMap.getIndexOfKey(account);
1920 
1921         iterationsUntilProcessed = -1;
1922 
1923         if (index >= 0) {
1924             if (uint256(index) > lastProcessedIndex) {
1925                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1926             } else {
1927                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1928                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1929             }
1930         }
1931 
1932         withdrawableDividends = withdrawableDividendOf(account);
1933         totalDividends = accumulativeDividendOf(account);
1934 
1935         lastClaimTime = lastClaimTimes[account];
1936         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1937         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1938     }
1939 
1940     function getAccountAtIndex(uint256 index)
1941     public view returns (
1942         address,
1943         int256,
1944         int256,
1945         uint256,
1946         uint256,
1947         uint256,
1948         uint256,
1949         uint256) {
1950         if (index >= tokenHoldersMap.size()) {
1951             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1952         }
1953 
1954         address account = tokenHoldersMap.getKeyAtIndex(index);
1955         return getAccount(account);
1956     }
1957 
1958     function getLastProcessedAccount()
1959     public view returns (
1960         address,
1961         int256,
1962         int256,
1963         uint256,
1964         uint256,
1965         uint256,
1966         uint256,
1967         uint256) {
1968         if (lastProcessedIndex >= tokenHoldersMap.size()) {
1969             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1970         }
1971 
1972         address account = tokenHoldersMap.getKeyAtIndex(lastProcessedIndex);
1973         return getAccount(account);
1974     }
1975 
1976     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1977         if (lastClaimTime > block.timestamp)  {
1978             return false;
1979         }
1980         return block.timestamp.sub(lastClaimTime) >= claimWait;
1981     }
1982 
1983     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1984         if (excludedFromDividends[account]) {
1985             return;
1986         }
1987 
1988         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1989             _setBalance(account, newBalance);
1990             tokenHoldersMap.set(account, newBalance);
1991         } else {
1992             _setBalance(account, 0);
1993             tokenHoldersMap.remove(account);
1994         }
1995 
1996         processAccount(account, true);
1997     }
1998 
1999     function process(uint256 gas) public returns (uint256, uint256, uint256) {
2000         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
2001 
2002         if (numberOfTokenHolders == 0) {
2003             return (0, 0, lastProcessedIndex);
2004         }
2005 
2006         uint256 _lastProcessedIndex = lastProcessedIndex;
2007 
2008         uint256 gasUsed = 0;
2009         uint256 gasLeft = gasleft();
2010 
2011         uint256 iterations = 0;
2012         uint256 claims = 0;
2013 
2014         while (gasUsed < gas && iterations < numberOfTokenHolders) {
2015             _lastProcessedIndex++;
2016 
2017             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
2018                 _lastProcessedIndex = 0;
2019             }
2020 
2021             address account = tokenHoldersMap.keys[_lastProcessedIndex];
2022 
2023             if (canAutoClaim(lastClaimTimes[account])) {
2024                 if (processAccount(payable(account), true)) {
2025                     claims++;
2026                 }
2027             }
2028 
2029             iterations++;
2030 
2031             uint256 newGasLeft = gasleft();
2032 
2033             if (gasLeft > newGasLeft) {
2034                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
2035             }
2036 
2037             gasLeft = newGasLeft;
2038         }
2039 
2040         lastProcessedIndex = _lastProcessedIndex;
2041 
2042         return (iterations, claims, lastProcessedIndex);
2043     }
2044 
2045     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
2046         uint256 amount = _withdrawDividendOfUser(account);
2047 
2048         if (amount > 0) {
2049             lastClaimTimes[account] = block.timestamp;
2050             emit Claim(account, amount, automatic);
2051             return true;
2052         }
2053 
2054         return false;
2055     }
2056 }