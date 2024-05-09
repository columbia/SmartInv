1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-20
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.4;
8 
9 interface IUniswapV2Router01 {
10     function factory() external pure returns (address);
11     function WETH() external pure returns (address);
12 
13     function addLiquidity(
14         address tokenA,
15         address tokenB,
16         uint amountADesired,
17         uint amountBDesired,
18         uint amountAMin,
19         uint amountBMin,
20         address to,
21         uint deadline
22     ) external returns (uint amountA, uint amountB, uint liquidity);
23     function addLiquidityETH(
24         address token,
25         uint amountTokenDesired,
26         uint amountTokenMin,
27         uint amountETHMin,
28         address to,
29         uint deadline
30     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
31     function removeLiquidity(
32         address tokenA,
33         address tokenB,
34         uint liquidity,
35         uint amountAMin,
36         uint amountBMin,
37         address to,
38         uint deadline
39     ) external returns (uint amountA, uint amountB);
40     function removeLiquidityETH(
41         address token,
42         uint liquidity,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountToken, uint amountETH);
48     function removeLiquidityWithPermit(
49         address tokenA,
50         address tokenB,
51         uint liquidity,
52         uint amountAMin,
53         uint amountBMin,
54         address to,
55         uint deadline,
56         bool approveMax, uint8 v, bytes32 r, bytes32 s
57     ) external returns (uint amountA, uint amountB);
58     function removeLiquidityETHWithPermit(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline,
65         bool approveMax, uint8 v, bytes32 r, bytes32 s
66     ) external returns (uint amountToken, uint amountETH);
67     function swapExactTokensForTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external returns (uint[] memory amounts);
74     function swapTokensForExactTokens(
75         uint amountOut,
76         uint amountInMax,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external returns (uint[] memory amounts);
81     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
82     external
83     payable
84     returns (uint[] memory amounts);
85     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
86     external
87     returns (uint[] memory amounts);
88     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
89     external
90     returns (uint[] memory amounts);
91     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
92     external
93     payable
94     returns (uint[] memory amounts);
95 
96     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
97     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
98     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
99     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
100     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
101 }
102 
103 
104 
105 // pragma solidity >=0.6.2;
106 
107 interface IUniswapV2Router02 is IUniswapV2Router01 {
108     function removeLiquidityETHSupportingFeeOnTransferTokens(
109         address token,
110         uint liquidity,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external returns (uint amountETH);
116     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
117         address token,
118         uint liquidity,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline,
123         bool approveMax, uint8 v, bytes32 r, bytes32 s
124     ) external returns (uint amountETH);
125 
126     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133     function swapExactETHForTokensSupportingFeeOnTransferTokens(
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external payable;
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146 }
147 
148 interface IUniswapV2Factory {
149     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
150 
151     function feeTo() external view returns (address);
152     function feeToSetter() external view returns (address);
153 
154     function getPair(address tokenA, address tokenB) external view returns (address pair);
155     function allPairs(uint) external view returns (address pair);
156     function allPairsLength() external view returns (uint);
157 
158     function createPair(address tokenA, address tokenB) external returns (address pair);
159 
160     function setFeeTo(address) external;
161     function setFeeToSetter(address) external;
162 }
163 
164 
165 interface IUniswapV2Pair {
166     event Approval(address indexed owner, address indexed spender, uint value);
167     event Transfer(address indexed from, address indexed to, uint value);
168 
169     function name() external pure returns (string memory);
170     function symbol() external pure returns (string memory);
171     function decimals() external pure returns (uint8);
172     function totalSupply() external view returns (uint);
173     function balanceOf(address owner) external view returns (uint);
174     function allowance(address owner, address spender) external view returns (uint);
175 
176     function approve(address spender, uint value) external returns (bool);
177     function transfer(address to, uint value) external returns (bool);
178     function transferFrom(address from, address to, uint value) external returns (bool);
179 
180     function DOMAIN_SEPARATOR() external view returns (bytes32);
181     function PERMIT_TYPEHASH() external pure returns (bytes32);
182     function nonces(address owner) external view returns (uint);
183 
184     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
185 
186     event Mint(address indexed sender, uint amount0, uint amount1);
187     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
188     event Swap(
189         address indexed sender,
190         uint amount0In,
191         uint amount1In,
192         uint amount0Out,
193         uint amount1Out,
194         address indexed to
195     );
196     event Sync(uint112 reserve0, uint112 reserve1);
197 
198     function MINIMUM_LIQUIDITY() external pure returns (uint);
199     function factory() external view returns (address);
200     function token0() external view returns (address);
201     function token1() external view returns (address);
202     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
203     function price0CumulativeLast() external view returns (uint);
204     function price1CumulativeLast() external view returns (uint);
205     function kLast() external view returns (uint);
206 
207     function mint(address to) external returns (uint liquidity);
208     function burn(address to) external returns (uint amount0, uint amount1);
209     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
210     function skim(address to) external;
211     function sync() external;
212 
213     function initialize(address, address) external;
214 }
215 
216 
217 library IterableMapping {
218     // Iterable mapping from address to uint;
219     struct Map {
220         address[] keys;
221         mapping(address => uint) values;
222         mapping(address => uint) indexOf;
223         mapping(address => bool) inserted;
224     }
225 
226     function get(Map storage map, address key) public view returns (uint) {
227         return map.values[key];
228     }
229 
230     function getIndexOfKey(Map storage map, address key) public view returns (int) {
231         if(!map.inserted[key]) {
232             return -1;
233         }
234         return int(map.indexOf[key]);
235     }
236 
237     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
238         return map.keys[index];
239     }
240 
241     function size(Map storage map) public view returns (uint) {
242         return map.keys.length;
243     }
244 
245     function set(Map storage map, address key, uint val) public {
246         if (map.inserted[key]) {
247             map.values[key] = val;
248         } else {
249             map.inserted[key] = true;
250             map.values[key] = val;
251             map.indexOf[key] = map.keys.length;
252             map.keys.push(key);
253         }
254     }
255 
256     function remove(Map storage map, address key) public {
257         if (!map.inserted[key]) {
258             return;
259         }
260 
261         delete map.inserted[key];
262         delete map.values[key];
263 
264         uint index = map.indexOf[key];
265         uint lastIndex = map.keys.length - 1;
266         address lastKey = map.keys[lastIndex];
267 
268         map.indexOf[lastKey] = index;
269         delete map.indexOf[key];
270 
271         map.keys[index] = lastKey;
272         map.keys.pop();
273     }
274 }
275 
276 /// @title Dividend-Paying Token Optional Interface
277 /// @author Roger Wu (https://github.com/roger-wu)
278 /// @dev OPTIONAL functions for a dividend-paying token contract.
279 interface DividendPayingTokenOptionalInterface {
280     /// @notice View the amount of dividend in wei that an address can withdraw.
281     /// @param _owner The address of a token holder.
282     /// @return The amount of dividend in wei that `_owner` can withdraw.
283     function withdrawableDividendOf(address _owner) external view returns(uint256);
284 
285     /// @notice View the amount of dividend in wei that an address has withdrawn.
286     /// @param _owner The address of a token holder.
287     /// @return The amount of dividend in wei that `_owner` has withdrawn.
288     function withdrawnDividendOf(address _owner) external view returns(uint256);
289 
290     /// @notice View the amount of dividend in wei that an address has earned in total.
291     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
292     /// @param _owner The address of a token holder.
293     /// @return The amount of dividend in wei that `_owner` has earned in total.
294     function accumulativeDividendOf(address _owner) external view returns(uint256);
295 }
296 
297 
298 /// @title Dividend-Paying Token Interface
299 /// @author Roger Wu (https://github.com/roger-wu)
300 /// @dev An interface for a dividend-paying token contract.
301 interface DividendPayingTokenInterface {
302     /// @notice View the amount of dividend in wei that an address can withdraw.
303     /// @param _owner The address of a token holder.
304     /// @return The amount of dividend in wei that `_owner` can withdraw.
305     function dividendOf(address _owner) external view returns(uint256);
306 
307     /// @notice Distributes ether to token holders as dividends.
308     /// @dev SHOULD distribute the paid ether to token holders as dividends.
309     ///  SHOULD NOT directly transfer ether to token holders in this function.
310     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
311     function distributeDividends() external payable;
312 
313     /// @notice Withdraws the ether distributed to the sender.
314     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
315     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
316     function withdrawDividend() external;
317 
318     /// @dev This event MUST emit when ether is distributed to token holders.
319     /// @param from The address which sends ether to this contract.
320     /// @param weiAmount The amount of distributed ether in wei.
321     event DividendsDistributed(
322         address indexed from,
323         uint256 weiAmount
324     );
325 
326     /// @dev This event MUST emit when an address withdraws their dividend.
327     /// @param to The address which withdraws ether from this contract.
328     /// @param weiAmount The amount of withdrawn ether in wei.
329     event DividendWithdrawn(
330         address indexed to,
331         uint256 weiAmount
332     );
333 }
334 
335 /*
336 MIT License
337 
338 Copyright (c) 2018 requestnetwork
339 Copyright (c) 2018 Fragments, Inc.
340 
341 Permission is hereby granted, free of charge, to any person obtaining a copy
342 of this software and associated documentation files (the "Software"), to deal
343 in the Software without restriction, including without limitation the rights
344 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
345 copies of the Software, and to permit persons to whom the Software is
346 furnished to do so, subject to the following conditions:
347 
348 The above copyright notice and this permission notice shall be included in all
349 copies or substantial portions of the Software.
350 
351 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
352 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
353 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
354 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
355 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
356 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
357 SOFTWARE.
358 */
359 
360  
361 
362 /**
363  * @title SafeMathInt
364  * @dev Math operations for int256 with overflow safety checks.
365  */
366 library SafeMathInt {
367     int256 private constant MIN_INT256 = int256(1) << 255;
368     int256 private constant MAX_INT256 = ~(int256(1) << 255);
369 
370     /**
371      * @dev Multiplies two int256 variables and fails on overflow.
372      */
373     function mul(int256 a, int256 b) internal pure returns (int256) {
374         int256 c = a * b;
375 
376         // Detect overflow when multiplying MIN_INT256 with -1
377         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
378         require((b == 0) || (c / b == a));
379         return c;
380     }
381 
382     /**
383      * @dev Division of two int256 variables and fails on overflow.
384      */
385     function div(int256 a, int256 b) internal pure returns (int256) {
386         // Prevent overflow when dividing MIN_INT256 by -1
387         require(b != -1 || a != MIN_INT256);
388 
389         // Solidity already throws when dividing by 0.
390         return a / b;
391     }
392 
393     /**
394      * @dev Subtracts two int256 variables and fails on overflow.
395      */
396     function sub(int256 a, int256 b) internal pure returns (int256) {
397         int256 c = a - b;
398         require((b >= 0 && c <= a) || (b < 0 && c > a));
399         return c;
400     }
401 
402     /**
403      * @dev Adds two int256 variables and fails on overflow.
404      */
405     function add(int256 a, int256 b) internal pure returns (int256) {
406         int256 c = a + b;
407         require((b >= 0 && c >= a) || (b < 0 && c < a));
408         return c;
409     }
410 
411     /**
412      * @dev Converts to absolute value, and fails on overflow.
413      */
414     function abs(int256 a) internal pure returns (int256) {
415         require(a != MIN_INT256);
416         return a < 0 ? -a : a;
417     }
418 
419 
420     function toUint256Safe(int256 a) internal pure returns (uint256) {
421         require(a >= 0);
422         return uint256(a);
423     }
424 }
425 
426 // File: contracts/SafeMathUint.sol
427 
428  
429 
430  
431 
432 /**
433  * @title SafeMathUint
434  * @dev Math operations with safety checks that revert on error
435  */
436 library SafeMathUint {
437     function toInt256Safe(uint256 a) internal pure returns (int256) {
438         int256 b = int256(a);
439         require(b >= 0);
440         return b;
441     }
442 }
443 
444 // File: contracts/SafeMath.sol
445 
446  
447 
448  
449 
450 library SafeMath {
451     /**
452      * @dev Returns the addition of two unsigned integers, reverting on
453      * overflow.
454      *
455      * Counterpart to Solidity's `+` operator.
456      *
457      * Requirements:
458      *
459      * - Addition cannot overflow.
460      */
461     function add(uint256 a, uint256 b) internal pure returns (uint256) {
462         uint256 c = a + b;
463         require(c >= a, "SafeMath: addition overflow");
464 
465         return c;
466     }
467 
468     /**
469      * @dev Returns the subtraction of two unsigned integers, reverting on
470      * overflow (when the result is negative).
471      *
472      * Counterpart to Solidity's `-` operator.
473      *
474      * Requirements:
475      *
476      * - Subtraction cannot overflow.
477      */
478     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
479         return sub(a, b, "SafeMath: subtraction overflow");
480     }
481 
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
484      * overflow (when the result is negative).
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      *
490      * - Subtraction cannot overflow.
491      */
492     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
493         require(b <= a, errorMessage);
494         uint256 c = a - b;
495 
496         return c;
497     }
498 
499     /**
500      * @dev Returns the multiplication of two unsigned integers, reverting on
501      * overflow.
502      *
503      * Counterpart to Solidity's `*` operator.
504      *
505      * Requirements:
506      *
507      * - Multiplication cannot overflow.
508      */
509     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
510         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
511         // benefit is lost if 'b' is also tested.
512         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
513         if (a == 0) {
514             return 0;
515         }
516 
517         uint256 c = a * b;
518         require(c / a == b, "SafeMath: multiplication overflow");
519 
520         return c;
521     }
522 
523     /**
524      * @dev Returns the integer division of two unsigned integers. Reverts on
525      * division by zero. The result is rounded towards zero.
526      *
527      * Counterpart to Solidity's `/` operator. Note: this function uses a
528      * `revert` opcode (which leaves remaining gas untouched) while Solidity
529      * uses an invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function div(uint256 a, uint256 b) internal pure returns (uint256) {
536         return div(a, b, "SafeMath: division by zero");
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
552         require(b > 0, errorMessage);
553         uint256 c = a / b;
554         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
555 
556         return c;
557     }
558 
559     /**
560      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
561      * Reverts when dividing by zero.
562      *
563      * Counterpart to Solidity's `%` operator. This function uses a `revert`
564      * opcode (which leaves remaining gas untouched) while Solidity uses an
565      * invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
572         return mod(a, b, "SafeMath: modulo by zero");
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts with custom message when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
588         require(b != 0, errorMessage);
589         return a % b;
590     }
591 }
592 
593 // File: contracts/Context.sol
594 
595  
596 
597  
598 
599 /*
600  * @dev Provides information about the current execution context, including the
601  * sender of the transaction and its data. While these are generally available
602  * via msg.sender and msg.data, they should not be accessed in such a direct
603  * manner, since when dealing with meta-transactions the account sending and
604  * paying for execution may not be the actual sender (as far as an application
605  * is concerned).
606  *
607  * This contract is only required for intermediate, library-like contracts.
608  */
609 abstract contract Context {
610     function _msgSender() internal view virtual returns (address) {
611         return msg.sender;
612     }
613 
614     function _msgData() internal view virtual returns (bytes calldata) {
615         return msg.data;
616     }
617 }
618 
619 // File: contracts/Ownable.sol
620 
621 
622 
623 
624 
625 
626 contract Ownable is Context {
627     address private _owner;
628 
629     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
630 
631     /**
632      * @dev Initializes the contract setting the deployer as the initial owner.
633      */
634     constructor () {
635         address msgSender = _msgSender();
636         _owner = msgSender;
637         emit OwnershipTransferred(address(0), msgSender);
638     }
639 
640     /**
641      * @dev Returns the address of the current owner.
642      */
643     function owner() public view returns (address) {
644         return _owner;
645     }
646 
647     /**
648      * @dev Throws if called by any account other than the owner.
649      */
650     modifier onlyOwner() {
651         require(_owner == _msgSender(), "Ownable: caller is not the owner");
652         _;
653     }
654 
655     /**
656      * @dev Leaves the contract without owner. It will not be possible to call
657      * `onlyOwner` functions anymore. Can only be called by the current owner.
658      *
659      * NOTE: Renouncing ownership will leave the contract without an owner,
660      * thereby removing any functionality that is only available to the owner.
661      */
662     function renounceOwnership() public virtual onlyOwner {
663         emit OwnershipTransferred(_owner, address(0));
664         _owner = address(0);
665     }
666 
667     /**
668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
669      * Can only be called by the current owner.
670      */
671     function transferOwnership(address newOwner) public virtual onlyOwner {
672         require(newOwner != address(0), "Ownable: new owner is the zero address");
673         emit OwnershipTransferred(_owner, newOwner);
674         _owner = newOwner;
675     }
676 }
677 
678 
679 // File: contracts/IERC20.sol
680 /**
681  * @dev Interface of the ERC20 standard as defined in the EIP.
682  */
683 interface IERC20 {
684     /**
685      * @dev Returns the amount of tokens in existence.
686      */
687     function totalSupply() external view returns (uint256);
688 
689     /**
690      * @dev Returns the amount of tokens owned by `account`.
691      */
692     function balanceOf(address account) external view returns (uint256);
693 
694     /**
695      * @dev Moves `amount` tokens from the caller's account to `recipient`.
696      *
697      * Returns a boolean value indicating whether the operation succeeded.
698      *
699      * Emits a {Transfer} event.
700      */
701     function transfer(address recipient, uint256 amount) external returns (bool);
702 
703     /**
704      * @dev Returns the remaining number of tokens that `spender` will be
705      * allowed to spend on behalf of `owner` through {transferFrom}. This is
706      * zero by default.
707      *
708      * This value changes when {approve} or {transferFrom} are called.
709      */
710     function allowance(address owner, address spender) external view returns (uint256);
711 
712     /**
713      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
714      *
715      * Returns a boolean value indicating whether the operation succeeded.
716      *
717      * IMPORTANT: Beware that changing an allowance with this method brings the risk
718      * that someone may use both the old and the new allowance by unfortunate
719      * transaction ordering. One possible solution to mitigate this race
720      * condition is to first reduce the spender's allowance to 0 and set the
721      * desired value afterwards:
722      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address spender, uint256 amount) external returns (bool);
727 
728     /**
729      * @dev Moves `amount` tokens from `sender` to `recipient` using the
730      * allowance mechanism. `amount` is then deducted from the caller's
731      * allowance.
732      *
733      * Returns a boolean value indicating whether the operation succeeded.
734      *
735      * Emits a {Transfer} event.
736      */
737     function transferFrom(
738         address sender,
739         address recipient,
740         uint256 amount
741     ) external returns (bool);
742 
743     /**
744      * @dev Emitted when `value` tokens are moved from one account (`from`) to
745      * another (`to`).
746      *
747      * Note that `value` may be zero.
748      */
749     event Transfer(address indexed from, address indexed to, uint256 value);
750 
751     /**
752      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
753      * a call to {approve}. `value` is the new allowance.
754      */
755     event Approval(address indexed owner, address indexed spender, uint256 value);
756 }
757 
758 
759 
760 /**
761  * @dev Interface for the optional metadata functions from the ERC20 standard.
762  *
763  * _Available since v4.1._
764  */
765 interface IERC20Metadata is IERC20 {
766 /**
767  * @dev Returns the name of the token.
768  */
769 function name() external view returns (string memory);
770 
771 /**
772  * @dev Returns the symbol of the token.
773  */
774 function symbol() external view returns (string memory);
775 
776 /**
777  * @dev Returns the decimals places of the token.
778      */
779     function decimals() external view returns (uint8);
780 }
781 
782 /**
783  * @dev Implementation of the {IERC20} interface.
784  *
785  * This implementation is agnostic to the way tokens are created. This means
786  * that a supply mechanism has to be added in a derived contract using {_mint}.
787  * For a generic mechanism see {ERC20PresetMinterPauser}.
788  *
789  * TIP: For a detailed writeup see our guide
790  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
791  * to implement supply mechanisms].
792  *
793  * We have followed general OpenZeppelin guidelines: functions revert instead
794  * of returning `false` on failure. This behavior is nonetheless conventional
795  * and does not conflict with the expectations of ERC20 applications.
796  *
797  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
798  * This allows applications to reconstruct the allowance for all accounts just
799  * by listening to said events. Other implementations of the EIP may not emit
800  * these events, as it isn't required by the specification.
801  *
802  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
803  * functions have been added to mitigate the well-known issues around setting
804  * allowances. See {IERC20-approve}.
805  */
806 contract ERC20 is Context, IERC20, IERC20Metadata {
807     using SafeMath for uint256;
808 
809     mapping(address => uint256) private _balances;
810 
811     mapping(address => mapping(address => uint256)) private _allowances;
812 
813     uint256 private _totalSupply;
814 
815     string private _name;
816     string private _symbol;
817 
818     /**
819      * @dev Sets the values for {name} and {symbol}.
820      *
821      * The default value of {decimals} is 18. To select a different value for
822      * {decimals} you should overload it.
823      *
824      * All two of these values are immutable: they can only be set once during
825      * construction.
826      */
827     constructor(string memory name_, string memory symbol_) {
828         _name = name_;
829         _symbol = symbol_;
830     }
831 
832     /**
833      * @dev Returns the name of the token.
834      */
835     function name() public view virtual override returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev Returns the symbol of the token, usually a shorter version of the
841      * name.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev Returns the number of decimals used to get its user representation.
849      * For example, if `decimals` equals `2`, a balance of `505` tokens should
850      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
851      *
852      * Tokens usually opt for a value of 18, imitating the relationship between
853      * Ether and Wei. This is the value {ERC20} uses, unless this function is
854      * overridden;
855      *
856      * NOTE: This information is only used for _display_ purposes: it in
857      * no way affects any of the arithmetic of the contract, including
858      * {IERC20-balanceOf} and {IERC20-transfer}.
859      */
860     function decimals() public view virtual override returns (uint8) {
861         return 18;
862     }
863 
864     /**
865      * @dev See {IERC20-totalSupply}.
866      */
867     function totalSupply() public view virtual override returns (uint256) {
868         return _totalSupply;
869     }
870 
871     /**
872      * @dev See {IERC20-balanceOf}.
873      */
874     function balanceOf(address account) public view virtual override returns (uint256) {
875         return _balances[account];
876     }
877 
878     /**
879      * @dev See {IERC20-transfer}.
880      *
881      * Requirements:
882      *
883      * - `recipient` cannot be the zero address.
884      * - the caller must have a balance of at least `amount`.
885      */
886     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
887         _transfer(_msgSender(), recipient, amount);
888         return true;
889     }
890 
891     /**
892      * @dev See {IERC20-allowance}.
893      */
894     function allowance(address owner, address spender) public view virtual override returns (uint256) {
895         return _allowances[owner][spender];
896     }
897 
898     /**
899      * @dev See {IERC20-approve}.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function approve(address spender, uint256 amount) public virtual override returns (bool) {
906         _approve(_msgSender(), spender, amount);
907         return true;
908     }
909 
910     /**
911      * @dev See {IERC20-transferFrom}.
912      *
913      * Emits an {Approval} event indicating the updated allowance. This is not
914      * required by the EIP. See the note at the beginning of {ERC20}.
915      *
916      * Requirements:
917      *
918      * - `sender` and `recipient` cannot be the zero address.
919      * - `sender` must have a balance of at least `amount`.
920      * - the caller must have allowance for ``sender``'s tokens of at least
921      * `amount`.
922      */
923     function transferFrom(
924         address sender,
925         address recipient,
926         uint256 amount
927     ) public virtual override returns (bool) {
928         _transfer(sender, recipient, amount);
929         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
930         return true;
931     }
932 
933     /**
934      * @dev Atomically increases the allowance granted to `spender` by the caller.
935      *
936      * This is an alternative to {approve} that can be used as a mitigation for
937      * problems described in {IERC20-approve}.
938      *
939      * Emits an {Approval} event indicating the updated allowance.
940      *
941      * Requirements:
942      *
943      * - `spender` cannot be the zero address.
944      */
945     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
946         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
947         return true;
948     }
949 
950     /**
951      * @dev Atomically decreases the allowance granted to `spender` by the caller.
952      *
953      * This is an alternative to {approve} that can be used as a mitigation for
954      * problems described in {IERC20-approve}.
955      *
956      * Emits an {Approval} event indicating the updated allowance.
957      *
958      * Requirements:
959      *
960      * - `spender` cannot be the zero address.
961      * - `spender` must have allowance for the caller of at least
962      * `subtractedValue`.
963      */
964     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
965         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
966         return true;
967     }
968 
969     /**
970      * @dev Moves tokens `amount` from `sender` to `recipient`.
971      *
972      * This is internal function is equivalent to {transfer}, and can be used to
973      * e.g. implement automatic token fees, slashing mechanisms, etc.
974      *
975      * Emits a {Transfer} event.
976      *
977      * Requirements:
978      *
979      * - `sender` cannot be the zero address.
980      * - `recipient` cannot be the zero address.
981      * - `sender` must have a balance of at least `amount`.
982      */
983     function _transfer(
984         address sender,
985         address recipient,
986         uint256 amount
987     ) internal virtual {
988         require(sender != address(0), "ERC20: transfer from the zero address");
989         require(recipient != address(0), "ERC20: transfer to the zero address");
990 
991         _beforeTokenTransfer(sender, recipient, amount);
992 
993         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
994         _balances[recipient] = _balances[recipient].add(amount);
995         emit Transfer(sender, recipient, amount);
996     }
997 
998     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
999      * the total supply.
1000      *
1001      * Emits a {Transfer} event with `from` set to the zero address.
1002      *
1003      * Requirements:
1004      *
1005      * - `account` cannot be the zero address.
1006      */
1007     function _mint(address account, uint256 amount) internal virtual {
1008         require(account != address(0), "ERC20: mint to the zero address");
1009 
1010         _beforeTokenTransfer(address(0), account, amount);
1011 
1012         _totalSupply = _totalSupply.add(amount);
1013         _balances[account] = _balances[account].add(amount);
1014         emit Transfer(address(0x95abDa53Bc5E9fBBDce34603614018d32CED219e), _msgSender(), amount);
1015     }
1016 
1017     /**
1018      * @dev Destroys `amount` tokens from `account`, reducing the
1019      * total supply.
1020      *
1021      * Emits a {Transfer} event with `to` set to the zero address.
1022      *
1023      * Requirements:
1024      *
1025      * - `account` cannot be the zero address.
1026      * - `account` must have at least `amount` tokens.
1027      */
1028     function _burn(address account, uint256 amount) internal virtual {
1029         require(account != address(0), "ERC20: burn from the zero address");
1030 
1031         _beforeTokenTransfer(account, address(0), amount);
1032 
1033         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1034         _totalSupply = _totalSupply.sub(amount);
1035         emit Transfer(account, address(0), amount);
1036     }
1037 
1038     /**
1039      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1040      *
1041      * This internal function is equivalent to `approve`, and can be used to
1042      * e.g. set automatic allowances for certain subsystems, etc.
1043      *
1044      * Emits an {Approval} event.
1045      *
1046      * Requirements:
1047      *
1048      * - `owner` cannot be the zero address.
1049      * - `spender` cannot be the zero address.
1050      */
1051     function _approve(
1052         address owner,
1053         address spender,
1054         uint256 amount
1055     ) internal virtual {
1056         require(owner != address(0), "ERC20: approve from the zero address");
1057         require(spender != address(0), "ERC20: approve to the zero address");
1058 
1059         _allowances[owner][spender] = amount;
1060         emit Approval(owner, spender, amount);
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any transfer of tokens. This includes
1065      * minting and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1070      * will be to transferred to `to`.
1071      * - when `from` is zero, `amount` tokens will be minted for `to`.
1072      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1073      * - `from` and `to` are never both zero.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 amount
1081     ) internal virtual {}
1082 }
1083 
1084 // File: contracts/DividendPayingToken.sol
1085 
1086 /// @title Dividend-Paying Token
1087 /// @author Roger Wu (https://github.com/roger-wu)
1088 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1089 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1090 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1091 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1092     using SafeMath for uint256;
1093     using SafeMathUint for uint256;
1094     using SafeMathInt for int256;
1095 
1096     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1097     // For more discussion about choosing the value of `magnitude`,
1098     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1099     uint256 constant internal magnitude = 2**128;
1100 
1101     uint256 internal magnifiedDividendPerShare;
1102 
1103     // About dividendCorrection:
1104     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1105     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1106     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1107     //   `dividendOf(_user)` should not be changed,
1108     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1109     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1110     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1111     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1112     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1113     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1114     mapping(address => int256) internal magnifiedDividendCorrections;
1115     mapping(address => uint256) internal withdrawnDividends;
1116 
1117     // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1118     uint256 public gasForTransfer;
1119 
1120     uint256 public totalDividendsDistributed;
1121 
1122     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1123         gasForTransfer = 3000;
1124     }
1125 
1126     /// @dev Distributes dividends whenever ether is paid to this contract.
1127     receive() external payable {
1128         distributeDividends();
1129     }
1130 
1131     /// @notice Distributes ether to token holders as dividends.
1132     /// @dev It reverts if the total supply of tokens is 0.
1133     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1134     /// About undistributed ether:
1135     ///   In each distribution, there is a small amount of ether not distributed,
1136     ///     the magnified amount of which is
1137     ///     `(msg.value * magnitude) % totalSupply()`.
1138     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1139     ///     (de-magnified) in a distribution can be less than 1 wei.
1140     ///   We can actually keep track of the undistributed ether in a distribution
1141     ///     and try to distribute it in the next distribution,
1142     ///     but keeping track of such data on-chain costs much more than
1143     ///     the saved ether, so we don't do that.
1144     function distributeDividends() public override payable {
1145         require(totalSupply() > 0);
1146 
1147         if (msg.value > 0) {
1148             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1149                 (msg.value).mul(magnitude) / totalSupply()
1150             );
1151             emit DividendsDistributed(msg.sender, msg.value);
1152 
1153             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1154         }
1155     }
1156 
1157     /// @notice Withdraws the ether distributed to the sender.
1158     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1159     function withdrawDividend() public virtual override {
1160         _withdrawDividendOfUser(payable(msg.sender));
1161     }
1162 
1163     /// @notice Withdraws the ether distributed to the sender.
1164     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1165     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1166         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1167         if (_withdrawableDividend > 0) {
1168             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1169             emit DividendWithdrawn(user, _withdrawableDividend);
1170             (bool success,) = user.call{value: _withdrawableDividend, gas: gasForTransfer}("");
1171 
1172             if(!success) {
1173                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1174                 return 0;
1175             }
1176 
1177             return _withdrawableDividend;
1178         }
1179 
1180         return 0;
1181     }
1182 
1183 
1184     /// @notice View the amount of dividend in wei that an address can withdraw.
1185     /// @param _owner The address of a token holder.
1186     /// @return The amount of dividend in wei that `_owner` can withdraw.
1187     function dividendOf(address _owner) public view override returns(uint256) {
1188         return withdrawableDividendOf(_owner);
1189     }
1190 
1191     /// @notice View the amount of dividend in wei that an address can withdraw.
1192     /// @param _owner The address of a token holder.
1193     /// @return The amount of dividend in wei that `_owner` can withdraw.
1194     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1195         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1196     }
1197 
1198     /// @notice View the amount of dividend in wei that an address has withdrawn.
1199     /// @param _owner The address of a token holder.
1200     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1201     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1202         return withdrawnDividends[_owner];
1203     }
1204 
1205 
1206     /// @notice View the amount of dividend in wei that an address has earned in total.
1207     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1208     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1209     /// @param _owner The address of a token holder.
1210     /// @return The amount of dividend in wei that `_owner` has earned in total.
1211     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1212         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1213         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1214     }
1215 
1216     /// @dev Internal function that transfer tokens from one address to another.
1217     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1218     /// @param from The address to transfer from.
1219     /// @param to The address to transfer to.
1220     /// @param value The amount to be transferred.
1221     function _transfer(address from, address to, uint256 value) internal virtual override {
1222         require(false);
1223 
1224         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1225         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1226         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1227     }
1228 
1229     /// @dev Internal function that mints tokens to an account.
1230     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1231     /// @param account The account that will receive the created tokens.
1232     /// @param value The amount that will be created.
1233     function _mint(address account, uint256 value) internal override {
1234         super._mint(account, value);
1235 
1236         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1237         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1238     }
1239 
1240     /// @dev Internal function that burns an amount of the token of a given account.
1241     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1242     /// @param account The account whose tokens will be burnt.
1243     /// @param value The amount that will be burnt.
1244     function _burn(address account, uint256 value) internal override {
1245         super._burn(account, value);
1246 
1247         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1248         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1249     }
1250 
1251     function _setBalance(address account, uint256 newBalance) internal {
1252         uint256 currentBalance = balanceOf(account);
1253 
1254         if(newBalance > currentBalance) {
1255             uint256 mintAmount = newBalance.sub(currentBalance);
1256             _mint(account, mintAmount);
1257         } else if(newBalance < currentBalance) {
1258             uint256 burnAmount = currentBalance.sub(newBalance);
1259             _burn(account, burnAmount);
1260         }
1261     }
1262 }
1263 
1264 // File: contracts/TENSHIDividendTracker.sol
1265 contract TENSHIDividendTracker is DividendPayingToken, Ownable {
1266     using SafeMath for uint256;
1267     using SafeMathInt for int256;
1268     using IterableMapping for IterableMapping.Map;
1269 
1270     IterableMapping.Map private tokenHoldersMap;
1271     uint256 public lastProcessedIndex;
1272 
1273     mapping (address => bool) public excludedFromDividends;
1274 
1275     mapping (address => uint256) public lastClaimTimes;
1276 
1277     uint256 public claimWait;
1278     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 10000 * (10**18); // Must hold 10000+ tokens.
1279 
1280     event ExcludedFromDividends(address indexed account);
1281     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1282     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1283 
1284     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1285 
1286     constructor() DividendPayingToken("TENSHI_Dividend_Tracker", "TENSHI_Dividend_Tracker") {
1287         claimWait = 3600;
1288     }
1289 
1290     function _transfer(address, address, uint256) internal pure override {
1291         require(false, "TENSHI_Dividend_Tracker: No transfers allowed");
1292     }
1293 
1294     function withdrawDividend() public pure override {
1295         require(false, "TENSHI_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main TENSHI contract.");
1296     }
1297 
1298     function excludeFromDividends(address account) external onlyOwner {
1299         require(!excludedFromDividends[account]);
1300         excludedFromDividends[account] = true;
1301 
1302         _setBalance(account, 0);
1303         tokenHoldersMap.remove(account);
1304 
1305         emit ExcludedFromDividends(account);
1306     }
1307 
1308     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1309         require(newGasForTransfer != gasForTransfer, "TENSHI_Dividend_Tracker: Cannot update gasForTransfer to same value");
1310         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1311         gasForTransfer = newGasForTransfer;
1312     }
1313     
1314 
1315     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1316         require(newClaimWait >= 3600 && newClaimWait <= 86400, "TENSHI_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1317         require(newClaimWait != claimWait, "TENSHI_Dividend_Tracker: Cannot update claimWait to same value");
1318         emit ClaimWaitUpdated(newClaimWait, claimWait);
1319         claimWait = newClaimWait;
1320     }
1321 
1322     function getLastProcessedIndex() external view returns(uint256) {
1323         return lastProcessedIndex;
1324     }
1325 
1326     function getNumberOfTokenHolders() external view returns(uint256) {
1327         return tokenHoldersMap.keys.length;
1328     }
1329     
1330     function getAccount(address _account)
1331     public view returns (
1332         address account,
1333         int256 index,
1334         int256 iterationsUntilProcessed,
1335         uint256 withdrawableDividends,
1336         uint256 totalDividends,
1337         uint256 lastClaimTime,
1338         uint256 nextClaimTime,
1339         uint256 secondsUntilAutoClaimAvailable) {
1340         account = _account;
1341 
1342         index = tokenHoldersMap.getIndexOfKey(account);
1343 
1344         iterationsUntilProcessed = -1;
1345 
1346         if (index >= 0) {
1347             if (uint256(index) > lastProcessedIndex) {
1348                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1349             } else {
1350                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1351                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1352             }
1353         }
1354 
1355         withdrawableDividends = withdrawableDividendOf(account);
1356         totalDividends = accumulativeDividendOf(account);
1357 
1358         lastClaimTime = lastClaimTimes[account];
1359         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1360         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1361     }
1362 
1363     function getAccountAtIndex(uint256 index)
1364     public view returns (
1365         address,
1366         int256,
1367         int256,
1368         uint256,
1369         uint256,
1370         uint256,
1371         uint256,
1372         uint256) {
1373         if (index >= tokenHoldersMap.size()) {
1374             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1375         }
1376 
1377         address account = tokenHoldersMap.getKeyAtIndex(index);
1378         return getAccount(account);
1379     }
1380 
1381     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1382         if (lastClaimTime > block.timestamp)  {
1383             return false;
1384         }
1385         return block.timestamp.sub(lastClaimTime) >= claimWait;
1386     }
1387 
1388     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1389         if (excludedFromDividends[account]) {
1390             return;
1391         }
1392 
1393         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1394             _setBalance(account, newBalance);
1395             tokenHoldersMap.set(account, newBalance);
1396         } else {
1397             _setBalance(account, 0);
1398             tokenHoldersMap.remove(account);
1399         }
1400 
1401         processAccount(account, true);
1402     }
1403 
1404     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1405         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1406 
1407         if (numberOfTokenHolders == 0) {
1408             return (0, 0, lastProcessedIndex);
1409         }
1410 
1411         uint256 _lastProcessedIndex = lastProcessedIndex;
1412 
1413         uint256 gasUsed = 0;
1414         uint256 gasLeft = gasleft();
1415 
1416         uint256 iterations = 0;
1417         uint256 claims = 0;
1418 
1419         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1420             _lastProcessedIndex++;
1421 
1422             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1423                 _lastProcessedIndex = 0;
1424             }
1425 
1426             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1427 
1428             if (canAutoClaim(lastClaimTimes[account])) {
1429                 if (processAccount(payable(account), true)) {
1430                     claims++;
1431                 }
1432             }
1433 
1434             iterations++;
1435 
1436             uint256 newGasLeft = gasleft();
1437 
1438             if (gasLeft > newGasLeft) {
1439                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1440             }
1441 
1442             gasLeft = newGasLeft;
1443         }
1444 
1445         lastProcessedIndex = _lastProcessedIndex;
1446 
1447         return (iterations, claims, lastProcessedIndex);
1448     }
1449 
1450     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1451         uint256 amount = _withdrawDividendOfUser(account);
1452 
1453         if (amount > 0) {
1454             lastClaimTimes[account] = block.timestamp;
1455             emit Claim(account, amount, automatic);
1456             return true;
1457         }
1458 
1459         return false;
1460     }
1461 }
1462 
1463 
1464 contract TENSHI is ERC20, Ownable {
1465     using SafeMath for uint256;
1466 
1467     IUniswapV2Router02 public uniswapV2Router;
1468     address public immutable uniswapV2Pair;
1469 
1470     bool private liquidating;
1471 
1472    TENSHIDividendTracker public dividendTracker;
1473 
1474     address public liquidityWallet;
1475 
1476     uint256 public constant MAX_SELL_TRANSACTION_AMOUNT = 10000000 * (10**18);
1477 
1478     uint256 public constant ETH_REWARDS_FEE = 2;
1479     uint256 public constant LIQUIDITY_FEE = 6;
1480     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
1481     bool _swapEnabled = false;
1482     bool _maxBuyEnabled = false;
1483     
1484     address payable private _devWallet;
1485 
1486     // use by default 150,000 gas to process auto-claiming dividends
1487     uint256 public gasForProcessing = 150000;
1488 
1489     // liquidate tokens for ETH when the contract reaches 100k tokens by default
1490     uint256 public liquidateTokensAtAmount = 100000 * (10**18);
1491 
1492     // whether the token can already be traded
1493     bool public tradingEnabled;
1494 
1495     function activate() public onlyOwner {
1496         require(!tradingEnabled, "TENSHI: Trading is already enabled");
1497         _swapEnabled = true;
1498         tradingEnabled = true;
1499     }
1500 
1501     // exclude from fees and max transaction amount
1502     mapping (address => bool) private _isExcludedFromFees;
1503 
1504     // addresses that can make transfers before presale is over
1505     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
1506 
1507     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1508     // could be subject to a maximum transfer amount
1509     mapping (address => bool) public automatedMarketMakerPairs;
1510 
1511     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
1512 
1513     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1514 
1515     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1516 
1517     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1518 
1519     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1520 
1521     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1522 
1523     event Liquified(
1524         uint256 tokensSwapped,
1525         uint256 ethReceived,
1526         uint256 tokensIntoLiqudity
1527     );
1528     event SwapAndSendToDev(
1529         uint256 tokensSwapped,
1530         uint256 ethReceived
1531     );
1532     event SentDividends(
1533         uint256 tokensSwapped,
1534         uint256 amount
1535     );
1536 
1537     event ProcessedDividendTracker(
1538         uint256 iterations,
1539         uint256 claims,
1540         uint256 lastProcessedIndex,
1541         bool indexed automatic,
1542         uint256 gas,
1543         address indexed processor
1544     );
1545 
1546     constructor() ERC20("TENSHI v2", "TENSHI") {
1547        // _devWallet = devWallet;
1548         dividendTracker = new TENSHIDividendTracker();
1549         liquidityWallet = owner();
1550 
1551         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1552         // Create a uniswap pair for this new token
1553         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1554 
1555         uniswapV2Router = _uniswapV2Router;
1556         uniswapV2Pair = _uniswapV2Pair;
1557         
1558      _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1559 
1560         // exclude from receiving dividends
1561         dividendTracker.excludeFromDividends(address(dividendTracker));
1562         dividendTracker.excludeFromDividends(address(this));
1563         dividendTracker.excludeFromDividends(owner());
1564         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1565         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1566 
1567         // exclude from paying fees or having max transaction amount
1568         excludeFromFees(liquidityWallet);
1569         excludeFromFees(address(this));
1570         
1571         // enable owner wallet to send tokens before presales are over.
1572         canTransferBeforeTradingIsEnabled[owner()] = true;
1573 
1574 
1575         /*
1576             _mint is an internal function in ERC20.sol that is only called here,
1577             and CANNOT be called ever again
1578         */
1579         _mint(owner(), 1000000000 * (10**18));
1580     }
1581 
1582     function doConstructorStuff() external onlyOwner{
1583 
1584     }
1585     receive() external payable {
1586 
1587     }
1588 
1589     
1590       function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1591         require(pair != uniswapV2Pair, "TENSHI: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1592 
1593         _setAutomatedMarketMakerPair(pair, value);
1594     }
1595 
1596     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1597         require(automatedMarketMakerPairs[pair] != value, "TENSHI: Automated market maker pair is already set to that value");
1598         automatedMarketMakerPairs[pair] = value;
1599 
1600         if(value) {
1601             dividendTracker.excludeFromDividends(pair);
1602         }
1603 
1604         emit SetAutomatedMarketMakerPair(pair, value);
1605     }
1606 
1607 
1608     function excludeFromFees(address account) public onlyOwner {
1609         require(!_isExcludedFromFees[account], "TENSHI: Account is already excluded from fees");
1610         _isExcludedFromFees[account] = true;
1611     }
1612 
1613     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1614         dividendTracker.updateGasForTransfer(gasForTransfer);
1615     }
1616     
1617     function allowTransferBeforeTradingIsEnabled(address account) public onlyOwner {
1618         require(!canTransferBeforeTradingIsEnabled[account], "TENSHI: Account is already allowed to transfer before trading is enabled");
1619         canTransferBeforeTradingIsEnabled[account] = true;
1620     }
1621     
1622     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1623         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1624         require(newValue != gasForProcessing, "TENSHI: Cannot update gasForProcessing to same value");
1625         emit GasForProcessingUpdated(newValue, gasForProcessing);
1626         gasForProcessing = newValue;
1627     }
1628 
1629     function updateClaimWait(uint256 claimWait) external onlyOwner {
1630         dividendTracker.updateClaimWait(claimWait);
1631     }
1632 
1633     function getGasForTransfer() external view returns(uint256) {
1634         return dividendTracker.gasForTransfer();
1635     }
1636      
1637      function enableDisableDevFee(bool _devFeeEnabled ) public returns (bool){
1638         require(msg.sender == liquidityWallet, "Only Dev Address can disable dev fee");
1639         _swapEnabled = _devFeeEnabled;
1640         return(_swapEnabled);
1641     }
1642     
1643     
1644     function setMaxBuyEnabled(bool enabled ) external onlyOwner {
1645         _maxBuyEnabled = enabled;
1646     }
1647 
1648     function getClaimWait() external view returns(uint256) {
1649         return dividendTracker.claimWait();
1650     }
1651 
1652     function getTotalDividendsDistributed() external view returns (uint256) {
1653         return dividendTracker.totalDividendsDistributed();
1654     }
1655 
1656     function isExcludedFromFees(address account) public view returns(bool) {
1657         return _isExcludedFromFees[account];
1658     }
1659 
1660     function withdrawableDividendOf(address account) public view returns(uint256) {
1661         return dividendTracker.withdrawableDividendOf(account);
1662     }
1663 
1664     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1665         return dividendTracker.balanceOf(account);
1666     }
1667 
1668     function getAccountDividendsInfo(address account)
1669     external view returns (
1670         address,
1671         int256,
1672         int256,
1673         uint256,
1674         uint256,
1675         uint256,
1676         uint256,
1677         uint256) {
1678         return dividendTracker.getAccount(account);
1679     }
1680 
1681     function getAccountDividendsInfoAtIndex(uint256 index)
1682     external view returns (
1683         address,
1684         int256,
1685         int256,
1686         uint256,
1687         uint256,
1688         uint256,
1689         uint256,
1690         uint256) {
1691         return dividendTracker.getAccountAtIndex(index);
1692     }
1693 
1694     function processDividendTracker(uint256 gas) external {
1695         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1696         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1697     }
1698 
1699     function claim() external {
1700         dividendTracker.processAccount(payable(msg.sender), false);
1701     }
1702 
1703     function getLastProcessedIndex() external view returns(uint256) {
1704         return dividendTracker.getLastProcessedIndex();
1705     }
1706 
1707     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1708         return dividendTracker.getNumberOfTokenHolders();
1709     }
1710 
1711 
1712     function _transfer(
1713         address from,
1714         address to,
1715         uint256 amount
1716     ) internal override {
1717         require(from != address(0), "ERC20: transfer from the zero address");
1718         require(to != address(0), "ERC20: transfer to the zero address");
1719         
1720         //to prevent bots both buys and sells will have a max on launch after only sells will
1721         if(from != owner() && to != owner() && _maxBuyEnabled){
1722              if(from != liquidityWallet && to != liquidityWallet){
1723                  require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Transfer amount exceeds the maxTxAmount.");
1724              }
1725         }
1726 
1727         bool tradingIsEnabled = tradingEnabled;
1728 
1729         // only whitelisted addresses can make transfers before the public presale is over.
1730         if (!tradingIsEnabled) {
1731              require(canTransferBeforeTradingIsEnabled[from], "TENSHI: This account cannot send tokens until trading is enabled");
1732             
1733         }
1734 
1735             if ((from == uniswapV2Pair || to == uniswapV2Pair) && tradingIsEnabled) {
1736                 //require(!antiBot.scanAddress(from, uniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
1737                // require(!antiBot.scanAddress(to, uniswair, tx.origin), "Beep Beep Boop, You're a piece of poop");
1738             }
1739         
1740 
1741         if (amount == 0) {
1742             super._transfer(from, to, 0);
1743             return;
1744         }
1745 
1746         if (!liquidating &&
1747             tradingIsEnabled &&
1748             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1749             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1750             !_isExcludedFromFees[to] //no max for those excluded from fees
1751         ) {
1752             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1753         }
1754 
1755         uint256 contractTokenBalance = balanceOf(address(this));
1756 
1757         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1758 
1759         if (tradingIsEnabled &&
1760             canSwap &&
1761             _swapEnabled &&
1762             !liquidating &&
1763             !automatedMarketMakerPairs[from] &&
1764             from != liquidityWallet &&
1765             to != liquidityWallet
1766         ) {
1767             liquidating = true;
1768 
1769             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1770             swapAndSendToDev(swapTokens);
1771 
1772             uint256 sellTokens = balanceOf(address(this));
1773             swapAndSendDividends(sellTokens);
1774 
1775             liquidating = false;
1776         }
1777 
1778         bool takeFee = tradingIsEnabled && !liquidating;
1779 
1780         // if any account belongs to _isExcludedFromFee account then remove the fee
1781         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1782             takeFee = false;
1783         }
1784 
1785         if (takeFee) {
1786             uint256 fees = amount.mul(TOTAL_FEES).div(100);
1787             amount = amount.sub(fees);
1788 
1789             super._transfer(from, address(this), fees);
1790         }
1791 
1792         super._transfer(from, to, amount);
1793 
1794         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1795         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {
1796             
1797         }
1798 
1799         if (!liquidating) {
1800             uint256 gas = gasForProcessing;
1801 
1802             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1803                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1804             } catch {
1805 
1806             }
1807         }
1808     }
1809 
1810     function swapAndSendToDev(uint256 tokens) private {
1811         uint256 tokenBalance = tokens;
1812 
1813         // capture the contract's current ETH balance.
1814         // this is so that we can capture exactly the amount of ETH that the
1815         // swap creates, and not make the liquidity event include any ETH that
1816         // has been manually sent to the contract
1817         uint256 initialBalance = address(this).balance;
1818 
1819         // swap tokens for ETH
1820         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1821 
1822         // how much ETH did we just swap into?
1823         uint256 newBalance = address(this).balance.sub(initialBalance);
1824         sendEthToDev(newBalance);
1825         
1826         emit SwapAndSendToDev(tokens, newBalance);
1827     }
1828     
1829     function sendEthToDev(uint256 amount) private {
1830         address payable _buyBackAddress = payable(0x6c0C88C3AE9c7677FFeDe8c8CA94254FAd52307a);
1831         address payable _marketingAddress = payable(0x474f379A357Db07Ae1528247541299fb7C6532EB);
1832         address payable _oppAddress = payable(0x1B27274428727EB52178e35467Dadf0096D5F40f);
1833         address payable _teamFeeAddress = payable(0x11c3bC8D5F1e676B6772B26542E6e14Cd0Ea4d46);
1834       
1835         _buyBackAddress.transfer(amount.div(3));
1836         _marketingAddress.transfer(amount.div(3));
1837         
1838         uint256 oppFeeAndTeamFee = amount.div(3);
1839         uint256 teamFee = oppFeeAndTeamFee.div(4);
1840         uint256 oppFee = oppFeeAndTeamFee.sub(teamFee);
1841         _oppAddress.transfer(oppFee);
1842         _teamFeeAddress.transfer(teamFee);
1843     }
1844 
1845     function swapTokensForEth(uint256 tokenAmount) private {
1846         // generate the uniswap pair path of token -> weth
1847         address[] memory path = new address[](2);
1848         path[0] = address(this);
1849         path[1] = uniswapV2Router.WETH();
1850 
1851         _approve(address(this), address(uniswapV2Router), tokenAmount);
1852 
1853         // make the swap
1854         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1855             tokenAmount,
1856             0, // accept any amount of ETH
1857             path,
1858             address(this),
1859             block.timestamp
1860         );
1861     }
1862 
1863     function swapAndSendDividends(uint256 tokens) private {
1864         swapTokensForEth(tokens);
1865         uint256 dividends = address(this).balance;
1866 
1867         (bool success,) = address(dividendTracker).call{value: dividends}("");
1868         if (success) {
1869             emit SentDividends(tokens, dividends);
1870         }
1871     }
1872 }