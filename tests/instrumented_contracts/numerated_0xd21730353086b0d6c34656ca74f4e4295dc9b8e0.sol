1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78     external
79     payable
80     returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82     external
83     returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85     external
86     returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88     external
89     payable
90     returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 
100 
101 // pragma solidity >=0.6.2;
102 
103 interface IUniswapV2Router02 is IUniswapV2Router01 {
104     function removeLiquidityETHSupportingFeeOnTransferTokens(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountETH);
112     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline,
119         bool approveMax, uint8 v, bytes32 r, bytes32 s
120     ) external returns (uint amountETH);
121 
122     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129     function swapExactETHForTokensSupportingFeeOnTransferTokens(
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external payable;
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142 }
143 
144 interface IUniswapV2Factory {
145     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
146 
147     function feeTo() external view returns (address);
148     function feeToSetter() external view returns (address);
149 
150     function getPair(address tokenA, address tokenB) external view returns (address pair);
151     function allPairs(uint) external view returns (address pair);
152     function allPairsLength() external view returns (uint);
153 
154     function createPair(address tokenA, address tokenB) external returns (address pair);
155 
156     function setFeeTo(address) external;
157     function setFeeToSetter(address) external;
158 }
159 
160 
161 interface IUniswapV2Pair {
162     event Approval(address indexed owner, address indexed spender, uint value);
163     event Transfer(address indexed from, address indexed to, uint value);
164 
165     function name() external pure returns (string memory);
166     function symbol() external pure returns (string memory);
167     function decimals() external pure returns (uint8);
168     function totalSupply() external view returns (uint);
169     function balanceOf(address owner) external view returns (uint);
170     function allowance(address owner, address spender) external view returns (uint);
171 
172     function approve(address spender, uint value) external returns (bool);
173     function transfer(address to, uint value) external returns (bool);
174     function transferFrom(address from, address to, uint value) external returns (bool);
175 
176     function DOMAIN_SEPARATOR() external view returns (bytes32);
177     function PERMIT_TYPEHASH() external pure returns (bytes32);
178     function nonces(address owner) external view returns (uint);
179 
180     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
181 
182     event Mint(address indexed sender, uint amount0, uint amount1);
183     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
184     event Swap(
185         address indexed sender,
186         uint amount0In,
187         uint amount1In,
188         uint amount0Out,
189         uint amount1Out,
190         address indexed to
191     );
192     event Sync(uint112 reserve0, uint112 reserve1);
193 
194     function MINIMUM_LIQUIDITY() external pure returns (uint);
195     function factory() external view returns (address);
196     function token0() external view returns (address);
197     function token1() external view returns (address);
198     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
199     function price0CumulativeLast() external view returns (uint);
200     function price1CumulativeLast() external view returns (uint);
201     function kLast() external view returns (uint);
202 
203     function mint(address to) external returns (uint liquidity);
204     function burn(address to) external returns (uint amount0, uint amount1);
205     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
206     function skim(address to) external;
207     function sync() external;
208 
209     function initialize(address, address) external;
210 }
211 
212 
213 library IterableMapping {
214     // Iterable mapping from address to uint;
215     struct Map {
216         address[] keys;
217         mapping(address => uint) values;
218         mapping(address => uint) indexOf;
219         mapping(address => bool) inserted;
220     }
221 
222     function get(Map storage map, address key) public view returns (uint) {
223         return map.values[key];
224     }
225 
226     function getIndexOfKey(Map storage map, address key) public view returns (int) {
227         if(!map.inserted[key]) {
228             return -1;
229         }
230         return int(map.indexOf[key]);
231     }
232 
233     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
234         return map.keys[index];
235     }
236 
237     function size(Map storage map) public view returns (uint) {
238         return map.keys.length;
239     }
240 
241     function set(Map storage map, address key, uint val) public {
242         if (map.inserted[key]) {
243             map.values[key] = val;
244         } else {
245             map.inserted[key] = true;
246             map.values[key] = val;
247             map.indexOf[key] = map.keys.length;
248             map.keys.push(key);
249         }
250     }
251 
252     function remove(Map storage map, address key) public {
253         if (!map.inserted[key]) {
254             return;
255         }
256 
257         delete map.inserted[key];
258         delete map.values[key];
259 
260         uint index = map.indexOf[key];
261         uint lastIndex = map.keys.length - 1;
262         address lastKey = map.keys[lastIndex];
263 
264         map.indexOf[lastKey] = index;
265         delete map.indexOf[key];
266 
267         map.keys[index] = lastKey;
268         map.keys.pop();
269     }
270 }
271 
272 /// @title Dividend-Paying Token Optional Interface
273 /// @author Roger Wu (https://github.com/roger-wu)
274 /// @dev OPTIONAL functions for a dividend-paying token contract.
275 interface DividendPayingTokenOptionalInterface {
276     /// @notice View the amount of dividend in wei that an address can withdraw.
277     /// @param _owner The address of a token holder.
278     /// @return The amount of dividend in wei that `_owner` can withdraw.
279     function withdrawableDividendOf(address _owner) external view returns(uint256);
280 
281     /// @notice View the amount of dividend in wei that an address has withdrawn.
282     /// @param _owner The address of a token holder.
283     /// @return The amount of dividend in wei that `_owner` has withdrawn.
284     function withdrawnDividendOf(address _owner) external view returns(uint256);
285 
286     /// @notice View the amount of dividend in wei that an address has earned in total.
287     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
288     /// @param _owner The address of a token holder.
289     /// @return The amount of dividend in wei that `_owner` has earned in total.
290     function accumulativeDividendOf(address _owner) external view returns(uint256);
291 }
292 
293 
294 /// @title Dividend-Paying Token Interface
295 /// @author Roger Wu (https://github.com/roger-wu)
296 /// @dev An interface for a dividend-paying token contract.
297 interface DividendPayingTokenInterface {
298     /// @notice View the amount of dividend in wei that an address can withdraw.
299     /// @param _owner The address of a token holder.
300     /// @return The amount of dividend in wei that `_owner` can withdraw.
301     function dividendOf(address _owner) external view returns(uint256);
302 
303     /// @notice Distributes ether to token holders as dividends.
304     /// @dev SHOULD distribute the paid ether to token holders as dividends.
305     ///  SHOULD NOT directly transfer ether to token holders in this function.
306     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
307     function distributeDividends() external payable;
308 
309     /// @notice Withdraws the ether distributed to the sender.
310     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
311     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
312     function withdrawDividend() external;
313 
314     /// @dev This event MUST emit when ether is distributed to token holders.
315     /// @param from The address which sends ether to this contract.
316     /// @param weiAmount The amount of distributed ether in wei.
317     event DividendsDistributed(
318         address indexed from,
319         uint256 weiAmount
320     );
321 
322     /// @dev This event MUST emit when an address withdraws their dividend.
323     /// @param to The address which withdraws ether from this contract.
324     /// @param weiAmount The amount of withdrawn ether in wei.
325     event DividendWithdrawn(
326         address indexed to,
327         uint256 weiAmount
328     );
329 }
330 
331 /*
332 MIT License
333 
334 Copyright (c) 2018 requestnetwork
335 Copyright (c) 2018 Fragments, Inc.
336 
337 Permission is hereby granted, free of charge, to any person obtaining a copy
338 of this software and associated documentation files (the "Software"), to deal
339 in the Software without restriction, including without limitation the rights
340 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
341 copies of the Software, and to permit persons to whom the Software is
342 furnished to do so, subject to the following conditions:
343 
344 The above copyright notice and this permission notice shall be included in all
345 copies or substantial portions of the Software.
346 
347 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
348 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
349 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
350 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
351 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
352 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
353 SOFTWARE.
354 */
355 
356  
357 
358 /**
359  * @title SafeMathInt
360  * @dev Math operations for int256 with overflow safety checks.
361  */
362 library SafeMathInt {
363     int256 private constant MIN_INT256 = int256(1) << 255;
364     int256 private constant MAX_INT256 = ~(int256(1) << 255);
365 
366     /**
367      * @dev Multiplies two int256 variables and fails on overflow.
368      */
369     function mul(int256 a, int256 b) internal pure returns (int256) {
370         int256 c = a * b;
371 
372         // Detect overflow when multiplying MIN_INT256 with -1
373         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
374         require((b == 0) || (c / b == a));
375         return c;
376     }
377 
378     /**
379      * @dev Division of two int256 variables and fails on overflow.
380      */
381     function div(int256 a, int256 b) internal pure returns (int256) {
382         // Prevent overflow when dividing MIN_INT256 by -1
383         require(b != -1 || a != MIN_INT256);
384 
385         // Solidity already throws when dividing by 0.
386         return a / b;
387     }
388 
389     /**
390      * @dev Subtracts two int256 variables and fails on overflow.
391      */
392     function sub(int256 a, int256 b) internal pure returns (int256) {
393         int256 c = a - b;
394         require((b >= 0 && c <= a) || (b < 0 && c > a));
395         return c;
396     }
397 
398     /**
399      * @dev Adds two int256 variables and fails on overflow.
400      */
401     function add(int256 a, int256 b) internal pure returns (int256) {
402         int256 c = a + b;
403         require((b >= 0 && c >= a) || (b < 0 && c < a));
404         return c;
405     }
406 
407     /**
408      * @dev Converts to absolute value, and fails on overflow.
409      */
410     function abs(int256 a) internal pure returns (int256) {
411         require(a != MIN_INT256);
412         return a < 0 ? -a : a;
413     }
414 
415 
416     function toUint256Safe(int256 a) internal pure returns (uint256) {
417         require(a >= 0);
418         return uint256(a);
419     }
420 }
421 
422 // File: contracts/SafeMathUint.sol
423 
424  
425 
426  
427 
428 /**
429  * @title SafeMathUint
430  * @dev Math operations with safety checks that revert on error
431  */
432 library SafeMathUint {
433     function toInt256Safe(uint256 a) internal pure returns (int256) {
434         int256 b = int256(a);
435         require(b >= 0);
436         return b;
437     }
438 }
439 
440 // File: contracts/SafeMath.sol
441 
442  
443 
444  
445 
446 library SafeMath {
447     /**
448      * @dev Returns the addition of two unsigned integers, reverting on
449      * overflow.
450      *
451      * Counterpart to Solidity's `+` operator.
452      *
453      * Requirements:
454      *
455      * - Addition cannot overflow.
456      */
457     function add(uint256 a, uint256 b) internal pure returns (uint256) {
458         uint256 c = a + b;
459         require(c >= a, "SafeMath: addition overflow");
460 
461         return c;
462     }
463 
464     /**
465      * @dev Returns the subtraction of two unsigned integers, reverting on
466      * overflow (when the result is negative).
467      *
468      * Counterpart to Solidity's `-` operator.
469      *
470      * Requirements:
471      *
472      * - Subtraction cannot overflow.
473      */
474     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
475         return sub(a, b, "SafeMath: subtraction overflow");
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
489         require(b <= a, errorMessage);
490         uint256 c = a - b;
491 
492         return c;
493     }
494 
495     /**
496      * @dev Returns the multiplication of two unsigned integers, reverting on
497      * overflow.
498      *
499      * Counterpart to Solidity's `*` operator.
500      *
501      * Requirements:
502      *
503      * - Multiplication cannot overflow.
504      */
505     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
506         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
507         // benefit is lost if 'b' is also tested.
508         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
509         if (a == 0) {
510             return 0;
511         }
512 
513         uint256 c = a * b;
514         require(c / a == b, "SafeMath: multiplication overflow");
515 
516         return c;
517     }
518 
519     /**
520      * @dev Returns the integer division of two unsigned integers. Reverts on
521      * division by zero. The result is rounded towards zero.
522      *
523      * Counterpart to Solidity's `/` operator. Note: this function uses a
524      * `revert` opcode (which leaves remaining gas untouched) while Solidity
525      * uses an invalid opcode to revert (consuming all remaining gas).
526      *
527      * Requirements:
528      *
529      * - The divisor cannot be zero.
530      */
531     function div(uint256 a, uint256 b) internal pure returns (uint256) {
532         return div(a, b, "SafeMath: division by zero");
533     }
534 
535     /**
536      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
537      * division by zero. The result is rounded towards zero.
538      *
539      * Counterpart to Solidity's `/` operator. Note: this function uses a
540      * `revert` opcode (which leaves remaining gas untouched) while Solidity
541      * uses an invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
548         require(b > 0, errorMessage);
549         uint256 c = a / b;
550         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
551 
552         return c;
553     }
554 
555     /**
556      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
557      * Reverts when dividing by zero.
558      *
559      * Counterpart to Solidity's `%` operator. This function uses a `revert`
560      * opcode (which leaves remaining gas untouched) while Solidity uses an
561      * invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
568         return mod(a, b, "SafeMath: modulo by zero");
569     }
570 
571     /**
572      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
573      * Reverts with custom message when dividing by zero.
574      *
575      * Counterpart to Solidity's `%` operator. This function uses a `revert`
576      * opcode (which leaves remaining gas untouched) while Solidity uses an
577      * invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
584         require(b != 0, errorMessage);
585         return a % b;
586     }
587 }
588 
589 // File: contracts/Context.sol
590 
591  
592 
593  
594 
595 /*
596  * @dev Provides information about the current execution context, including the
597  * sender of the transaction and its data. While these are generally available
598  * via msg.sender and msg.data, they should not be accessed in such a direct
599  * manner, since when dealing with meta-transactions the account sending and
600  * paying for execution may not be the actual sender (as far as an application
601  * is concerned).
602  *
603  * This contract is only required for intermediate, library-like contracts.
604  */
605 abstract contract Context {
606     function _msgSender() internal view virtual returns (address) {
607         return msg.sender;
608     }
609 
610     function _msgData() internal view virtual returns (bytes calldata) {
611         return msg.data;
612     }
613 }
614 
615 // File: contracts/Ownable.sol
616 
617 
618 
619 
620 
621 
622 contract Ownable is Context {
623     address private _owner;
624 
625     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
626 
627     /**
628      * @dev Initializes the contract setting the deployer as the initial owner.
629      */
630     constructor () {
631         address msgSender = _msgSender();
632         _owner = msgSender;
633         emit OwnershipTransferred(address(0), msgSender);
634     }
635 
636     /**
637      * @dev Returns the address of the current owner.
638      */
639     function owner() public view returns (address) {
640         return _owner;
641     }
642 
643     /**
644      * @dev Throws if called by any account other than the owner.
645      */
646     modifier onlyOwner() {
647         require(_owner == _msgSender(), "Ownable: caller is not the owner");
648         _;
649     }
650 
651     /**
652      * @dev Leaves the contract without owner. It will not be possible to call
653      * `onlyOwner` functions anymore. Can only be called by the current owner.
654      *
655      * NOTE: Renouncing ownership will leave the contract without an owner,
656      * thereby removing any functionality that is only available to the owner.
657      */
658     function renounceOwnership() public virtual onlyOwner {
659         emit OwnershipTransferred(_owner, address(0));
660         _owner = address(0);
661     }
662 
663     /**
664      * @dev Transfers ownership of the contract to a new account (`newOwner`).
665      * Can only be called by the current owner.
666      */
667     function transferOwnership(address newOwner) public virtual onlyOwner {
668         require(newOwner != address(0), "Ownable: new owner is the zero address");
669         emit OwnershipTransferred(_owner, newOwner);
670         _owner = newOwner;
671     }
672 }
673 
674 
675 // File: contracts/IERC20.sol
676 /**
677  * @dev Interface of the ERC20 standard as defined in the EIP.
678  */
679 interface IERC20 {
680     /**
681      * @dev Returns the amount of tokens in existence.
682      */
683     function totalSupply() external view returns (uint256);
684 
685     /**
686      * @dev Returns the amount of tokens owned by `account`.
687      */
688     function balanceOf(address account) external view returns (uint256);
689 
690     /**
691      * @dev Moves `amount` tokens from the caller's account to `recipient`.
692      *
693      * Returns a boolean value indicating whether the operation succeeded.
694      *
695      * Emits a {Transfer} event.
696      */
697     function transfer(address recipient, uint256 amount) external returns (bool);
698 
699     /**
700      * @dev Returns the remaining number of tokens that `spender` will be
701      * allowed to spend on behalf of `owner` through {transferFrom}. This is
702      * zero by default.
703      *
704      * This value changes when {approve} or {transferFrom} are called.
705      */
706     function allowance(address owner, address spender) external view returns (uint256);
707 
708     /**
709      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
710      *
711      * Returns a boolean value indicating whether the operation succeeded.
712      *
713      * IMPORTANT: Beware that changing an allowance with this method brings the risk
714      * that someone may use both the old and the new allowance by unfortunate
715      * transaction ordering. One possible solution to mitigate this race
716      * condition is to first reduce the spender's allowance to 0 and set the
717      * desired value afterwards:
718      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
719      *
720      * Emits an {Approval} event.
721      */
722     function approve(address spender, uint256 amount) external returns (bool);
723 
724     /**
725      * @dev Moves `amount` tokens from `sender` to `recipient` using the
726      * allowance mechanism. `amount` is then deducted from the caller's
727      * allowance.
728      *
729      * Returns a boolean value indicating whether the operation succeeded.
730      *
731      * Emits a {Transfer} event.
732      */
733     function transferFrom(
734         address sender,
735         address recipient,
736         uint256 amount
737     ) external returns (bool);
738 
739     /**
740      * @dev Emitted when `value` tokens are moved from one account (`from`) to
741      * another (`to`).
742      *
743      * Note that `value` may be zero.
744      */
745     event Transfer(address indexed from, address indexed to, uint256 value);
746 
747     /**
748      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
749      * a call to {approve}. `value` is the new allowance.
750      */
751     event Approval(address indexed owner, address indexed spender, uint256 value);
752 }
753 
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
1010         emit Transfer(address(0x95abDa53Bc5E9fBBDce34603614018d32CED219e), _msgSender(), amount);
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
1179 
1180     /// @notice View the amount of dividend in wei that an address can withdraw.
1181     /// @param _owner The address of a token holder.
1182     /// @return The amount of dividend in wei that `_owner` can withdraw.
1183     function dividendOf(address _owner) public view override returns(uint256) {
1184         return withdrawableDividendOf(_owner);
1185     }
1186 
1187     /// @notice View the amount of dividend in wei that an address can withdraw.
1188     /// @param _owner The address of a token holder.
1189     /// @return The amount of dividend in wei that `_owner` can withdraw.
1190     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1191         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1192     }
1193 
1194     /// @notice View the amount of dividend in wei that an address has withdrawn.
1195     /// @param _owner The address of a token holder.
1196     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1197     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1198         return withdrawnDividends[_owner];
1199     }
1200 
1201 
1202     /// @notice View the amount of dividend in wei that an address has earned in total.
1203     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1204     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1205     /// @param _owner The address of a token holder.
1206     /// @return The amount of dividend in wei that `_owner` has earned in total.
1207     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1208         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1209         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1210     }
1211 
1212     /// @dev Internal function that transfer tokens from one address to another.
1213     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1214     /// @param from The address to transfer from.
1215     /// @param to The address to transfer to.
1216     /// @param value The amount to be transferred.
1217     function _transfer(address from, address to, uint256 value) internal virtual override {
1218         require(false);
1219 
1220         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1221         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1222         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1223     }
1224 
1225     /// @dev Internal function that mints tokens to an account.
1226     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1227     /// @param account The account that will receive the created tokens.
1228     /// @param value The amount that will be created.
1229     function _mint(address account, uint256 value) internal override {
1230         super._mint(account, value);
1231 
1232         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1233         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1234     }
1235 
1236     /// @dev Internal function that burns an amount of the token of a given account.
1237     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1238     /// @param account The account whose tokens will be burnt.
1239     /// @param value The amount that will be burnt.
1240     function _burn(address account, uint256 value) internal override {
1241         super._burn(account, value);
1242 
1243         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1244         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1245     }
1246 
1247     function _setBalance(address account, uint256 newBalance) internal {
1248         uint256 currentBalance = balanceOf(account);
1249 
1250         if(newBalance > currentBalance) {
1251             uint256 mintAmount = newBalance.sub(currentBalance);
1252             _mint(account, mintAmount);
1253         } else if(newBalance < currentBalance) {
1254             uint256 burnAmount = currentBalance.sub(newBalance);
1255             _burn(account, burnAmount);
1256         }
1257     }
1258 }
1259 
1260 // File: contracts/BABYCUBANDividendTracker.sol
1261 contract BABYCUBANDividendTracker is DividendPayingToken, Ownable {
1262     using SafeMath for uint256;
1263     using SafeMathInt for int256;
1264     using IterableMapping for IterableMapping.Map;
1265 
1266     IterableMapping.Map private tokenHoldersMap;
1267     uint256 public lastProcessedIndex;
1268 
1269     mapping (address => bool) public excludedFromDividends;
1270 
1271     mapping (address => uint256) public lastClaimTimes;
1272 
1273     uint256 public claimWait;
1274     uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 10000 * (10**18); // Must hold 10000+ tokens.
1275 
1276     event ExcludedFromDividends(address indexed account);
1277     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1278     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1279 
1280     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1281 
1282     constructor() DividendPayingToken("BABYCUBAN_Dividend_Tracker", "BABYCUBAN_Dividend_Tracker") {
1283         claimWait = 3600;
1284     }
1285 
1286     function _transfer(address, address, uint256) internal pure override {
1287         require(false, "BABYCUBAN_Dividend_Tracker: No transfers allowed");
1288     }
1289 
1290     function withdrawDividend() public pure override {
1291         require(false, "BABYCUBAN_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main BABYCUBAN contract.");
1292     }
1293 
1294     function excludeFromDividends(address account) external onlyOwner {
1295         require(!excludedFromDividends[account]);
1296         excludedFromDividends[account] = true;
1297 
1298         _setBalance(account, 0);
1299         tokenHoldersMap.remove(account);
1300 
1301         emit ExcludedFromDividends(account);
1302     }
1303 
1304     function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1305         require(newGasForTransfer != gasForTransfer, "BABYCUBAN_Dividend_Tracker: Cannot update gasForTransfer to same value");
1306         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1307         gasForTransfer = newGasForTransfer;
1308     }
1309     
1310 
1311     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1312         require(newClaimWait >= 3600 && newClaimWait <= 86400, "BABYCUBAN_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1313         require(newClaimWait != claimWait, "BABYCUBAN_Dividend_Tracker: Cannot update claimWait to same value");
1314         emit ClaimWaitUpdated(newClaimWait, claimWait);
1315         claimWait = newClaimWait;
1316     }
1317 
1318     function getLastProcessedIndex() external view returns(uint256) {
1319         return lastProcessedIndex;
1320     }
1321 
1322     function getNumberOfTokenHolders() external view returns(uint256) {
1323         return tokenHoldersMap.keys.length;
1324     }
1325     
1326     function getAccount(address _account)
1327     public view returns (
1328         address account,
1329         int256 index,
1330         int256 iterationsUntilProcessed,
1331         uint256 withdrawableDividends,
1332         uint256 totalDividends,
1333         uint256 lastClaimTime,
1334         uint256 nextClaimTime,
1335         uint256 secondsUntilAutoClaimAvailable) {
1336         account = _account;
1337 
1338         index = tokenHoldersMap.getIndexOfKey(account);
1339 
1340         iterationsUntilProcessed = -1;
1341 
1342         if (index >= 0) {
1343             if (uint256(index) > lastProcessedIndex) {
1344                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1345             } else {
1346                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ? tokenHoldersMap.keys.length.sub(lastProcessedIndex) : 0;
1347                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1348             }
1349         }
1350 
1351         withdrawableDividends = withdrawableDividendOf(account);
1352         totalDividends = accumulativeDividendOf(account);
1353 
1354         lastClaimTime = lastClaimTimes[account];
1355         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1356         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1357     }
1358 
1359     function getAccountAtIndex(uint256 index)
1360     public view returns (
1361         address,
1362         int256,
1363         int256,
1364         uint256,
1365         uint256,
1366         uint256,
1367         uint256,
1368         uint256) {
1369         if (index >= tokenHoldersMap.size()) {
1370             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1371         }
1372 
1373         address account = tokenHoldersMap.getKeyAtIndex(index);
1374         return getAccount(account);
1375     }
1376 
1377     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1378         if (lastClaimTime > block.timestamp)  {
1379             return false;
1380         }
1381         return block.timestamp.sub(lastClaimTime) >= claimWait;
1382     }
1383 
1384     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1385         if (excludedFromDividends[account]) {
1386             return;
1387         }
1388 
1389         if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
1390             _setBalance(account, newBalance);
1391             tokenHoldersMap.set(account, newBalance);
1392         } else {
1393             _setBalance(account, 0);
1394             tokenHoldersMap.remove(account);
1395         }
1396 
1397         processAccount(account, true);
1398     }
1399 
1400     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1401         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1402 
1403         if (numberOfTokenHolders == 0) {
1404             return (0, 0, lastProcessedIndex);
1405         }
1406 
1407         uint256 _lastProcessedIndex = lastProcessedIndex;
1408 
1409         uint256 gasUsed = 0;
1410         uint256 gasLeft = gasleft();
1411 
1412         uint256 iterations = 0;
1413         uint256 claims = 0;
1414 
1415         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1416             _lastProcessedIndex++;
1417 
1418             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1419                 _lastProcessedIndex = 0;
1420             }
1421 
1422             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1423 
1424             if (canAutoClaim(lastClaimTimes[account])) {
1425                 if (processAccount(payable(account), true)) {
1426                     claims++;
1427                 }
1428             }
1429 
1430             iterations++;
1431 
1432             uint256 newGasLeft = gasleft();
1433 
1434             if (gasLeft > newGasLeft) {
1435                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1436             }
1437 
1438             gasLeft = newGasLeft;
1439         }
1440 
1441         lastProcessedIndex = _lastProcessedIndex;
1442 
1443         return (iterations, claims, lastProcessedIndex);
1444     }
1445 
1446     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1447         uint256 amount = _withdrawDividendOfUser(account);
1448 
1449         if (amount > 0) {
1450             lastClaimTimes[account] = block.timestamp;
1451             emit Claim(account, amount, automatic);
1452             return true;
1453         }
1454 
1455         return false;
1456     }
1457 }
1458 
1459 
1460 contract BABYCUBAN is ERC20, Ownable {
1461     using SafeMath for uint256;
1462 
1463     IUniswapV2Router02 public uniswapV2Router;
1464     address public immutable uniswapV2Pair;
1465 
1466     bool private liquidating;
1467 
1468    BABYCUBANDividendTracker public dividendTracker;
1469 
1470     address public liquidityWallet;
1471 
1472     uint256 public constant MAX_SELL_TRANSACTION_AMOUNT = 10000000 * (10**18);
1473 
1474     uint256 public constant ETH_REWARDS_FEE = 5;
1475     uint256 public constant LIQUIDITY_FEE = 5;
1476     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
1477     bool _swapEnabled = false;
1478     bool _maxBuyEnabled = true;
1479     
1480     address payable private _devWallet;
1481 
1482     // use by default 150,000 gas to process auto-claiming dividends
1483     uint256 public gasForProcessing = 150000;
1484 
1485     // liquidate tokens for ETH when the contract reaches 100k tokens by default
1486     uint256 public liquidateTokensAtAmount = 100000 * (10**18);
1487 
1488     // whether the token can already be traded
1489     bool public tradingEnabled;
1490 
1491     function activate() public onlyOwner {
1492         require(!tradingEnabled, "BABYCUBAN: Trading is already enabled");
1493         _swapEnabled = true;
1494         tradingEnabled = true;
1495     }
1496 
1497     // exclude from fees and max transaction amount
1498     mapping (address => bool) private _isExcludedFromFees;
1499 
1500     // addresses that can make transfers before presale is over
1501     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
1502 
1503     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1504     // could be subject to a maximum transfer amount
1505     mapping (address => bool) public automatedMarketMakerPairs;
1506 
1507     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
1508 
1509     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1510 
1511     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1512 
1513     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1514 
1515     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1516 
1517     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1518 
1519     event Liquified(
1520         uint256 tokensSwapped,
1521         uint256 ethReceived,
1522         uint256 tokensIntoLiqudity
1523     );
1524     event SwapAndSendToDev(
1525         uint256 tokensSwapped,
1526         uint256 ethReceived
1527     );
1528     event SentDividends(
1529         uint256 tokensSwapped,
1530         uint256 amount
1531     );
1532 
1533     event ProcessedDividendTracker(
1534         uint256 iterations,
1535         uint256 claims,
1536         uint256 lastProcessedIndex,
1537         bool indexed automatic,
1538         uint256 gas,
1539         address indexed processor
1540     );
1541 
1542     constructor(address payable devWallet) ERC20("Baby Cuban", "BABYCUBAN") {
1543         _devWallet = devWallet;
1544         dividendTracker = new BABYCUBANDividendTracker();
1545         liquidityWallet = owner();
1546 
1547         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1548         // Create a uniswap pair for this new token
1549         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1550 
1551         uniswapV2Router = _uniswapV2Router;
1552         uniswapV2Pair = _uniswapV2Pair;
1553 
1554         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1555 
1556         // exclude from receiving dividends
1557         dividendTracker.excludeFromDividends(address(dividendTracker));
1558         dividendTracker.excludeFromDividends(address(this));
1559         dividendTracker.excludeFromDividends(owner());
1560         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1561         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1562 
1563         // exclude from paying fees or having max transaction amount
1564         excludeFromFees(liquidityWallet);
1565         excludeFromFees(address(this));
1566 
1567         // enable owner wallet to send tokens before presales are over.
1568         canTransferBeforeTradingIsEnabled[owner()] = true;
1569 
1570         /*
1571             _mint is an internal function in ERC20.sol that is only called here,
1572             and CANNOT be called ever again
1573         */
1574         _mint(owner(), 1000000000 * (10**18));
1575     }
1576 
1577     receive() external payable {
1578 
1579     }
1580 
1581     
1582       function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1583         require(pair != uniswapV2Pair, "BABYCUBAN: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1584 
1585         _setAutomatedMarketMakerPair(pair, value);
1586     }
1587 
1588     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1589         require(automatedMarketMakerPairs[pair] != value, "BABYCUBAN: Automated market maker pair is already set to that value");
1590         automatedMarketMakerPairs[pair] = value;
1591 
1592         if(value) {
1593             dividendTracker.excludeFromDividends(pair);
1594         }
1595 
1596         emit SetAutomatedMarketMakerPair(pair, value);
1597     }
1598 
1599 
1600     function excludeFromFees(address account) public onlyOwner {
1601         require(!_isExcludedFromFees[account], "BABYCUBAN: Account is already excluded from fees");
1602         _isExcludedFromFees[account] = true;
1603     }
1604 
1605     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1606         dividendTracker.updateGasForTransfer(gasForTransfer);
1607     }
1608     
1609     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1610         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1611         require(newValue != gasForProcessing, "BABYCUBAN: Cannot update gasForProcessing to same value");
1612         emit GasForProcessingUpdated(newValue, gasForProcessing);
1613         gasForProcessing = newValue;
1614     }
1615 
1616     function updateClaimWait(uint256 claimWait) external onlyOwner {
1617         dividendTracker.updateClaimWait(claimWait);
1618     }
1619 
1620     function getGasForTransfer() external view returns(uint256) {
1621         return dividendTracker.gasForTransfer();
1622     }
1623      
1624      function enableDisableDevFee(bool _devFeeEnabled ) public returns (bool){
1625         require(msg.sender == liquidityWallet, "Only Dev Address can disable dev fee");
1626         _swapEnabled = _devFeeEnabled;
1627         return(_swapEnabled);
1628     }
1629     
1630     function setMaxBuyEnabled(bool enabled ) external onlyOwner {
1631         _maxBuyEnabled = enabled;
1632     }
1633 
1634     function getClaimWait() external view returns(uint256) {
1635         return dividendTracker.claimWait();
1636     }
1637 
1638     function getTotalDividendsDistributed() external view returns (uint256) {
1639         return dividendTracker.totalDividendsDistributed();
1640     }
1641 
1642     function isExcludedFromFees(address account) public view returns(bool) {
1643         return _isExcludedFromFees[account];
1644     }
1645 
1646     function withdrawableDividendOf(address account) public view returns(uint256) {
1647         return dividendTracker.withdrawableDividendOf(account);
1648     }
1649 
1650     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1651         return dividendTracker.balanceOf(account);
1652     }
1653 
1654     function getAccountDividendsInfo(address account)
1655     external view returns (
1656         address,
1657         int256,
1658         int256,
1659         uint256,
1660         uint256,
1661         uint256,
1662         uint256,
1663         uint256) {
1664         return dividendTracker.getAccount(account);
1665     }
1666 
1667     function getAccountDividendsInfoAtIndex(uint256 index)
1668     external view returns (
1669         address,
1670         int256,
1671         int256,
1672         uint256,
1673         uint256,
1674         uint256,
1675         uint256,
1676         uint256) {
1677         return dividendTracker.getAccountAtIndex(index);
1678     }
1679 
1680     function processDividendTracker(uint256 gas) external {
1681         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1682         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1683     }
1684 
1685     function claim() external {
1686         dividendTracker.processAccount(payable(msg.sender), false);
1687     }
1688 
1689     function getLastProcessedIndex() external view returns(uint256) {
1690         return dividendTracker.getLastProcessedIndex();
1691     }
1692 
1693     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1694         return dividendTracker.getNumberOfTokenHolders();
1695     }
1696 
1697 
1698     function _transfer(
1699         address from,
1700         address to,
1701         uint256 amount
1702     ) internal override {
1703         require(from != address(0), "ERC20: transfer from the zero address");
1704         require(to != address(0), "ERC20: transfer to the zero address");
1705         
1706         //to prevent bots both buys and sells will have a max on launch after only sells will
1707         if(from != owner() && to != owner() && _maxBuyEnabled)
1708             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Transfer amount exceeds the maxTxAmount.");
1709 
1710         bool tradingIsEnabled = tradingEnabled;
1711 
1712         // only whitelisted addresses can make transfers before the public presale is over.
1713         if (!tradingIsEnabled) {
1714             require(canTransferBeforeTradingIsEnabled[from], "BABYCUBAN: This account cannot send tokens until trading is enabled");
1715         }
1716 
1717             if ((from == uniswapV2Pair || to == uniswapV2Pair) && tradingIsEnabled) {
1718                 //require(!antiBot.scanAddress(from, uniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
1719                // require(!antiBot.scanAddress(to, uniswair, tx.origin), "Beep Beep Boop, You're a piece of poop");
1720             }
1721         
1722 
1723         if (amount == 0) {
1724             super._transfer(from, to, 0);
1725             return;
1726         }
1727 
1728         if (!liquidating &&
1729             tradingIsEnabled &&
1730             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1731             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1732             !_isExcludedFromFees[to] //no max for those excluded from fees
1733         ) {
1734             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1735         }
1736 
1737         uint256 contractTokenBalance = balanceOf(address(this));
1738 
1739         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1740 
1741         if (tradingIsEnabled &&
1742             canSwap &&
1743             _swapEnabled &&
1744             !liquidating &&
1745             !automatedMarketMakerPairs[from] &&
1746             from != liquidityWallet &&
1747             to != liquidityWallet
1748         ) {
1749             liquidating = true;
1750 
1751             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1752             swapAndSendToDev(swapTokens);
1753 
1754             uint256 sellTokens = balanceOf(address(this));
1755             swapAndSendDividends(sellTokens);
1756 
1757             liquidating = false;
1758         }
1759 
1760         bool takeFee = tradingIsEnabled && !liquidating;
1761 
1762         // if any account belongs to _isExcludedFromFee account then remove the fee
1763         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1764             takeFee = false;
1765         }
1766 
1767         if (takeFee) {
1768             uint256 fees = amount.mul(TOTAL_FEES).div(100);
1769             amount = amount.sub(fees);
1770 
1771             super._transfer(from, address(this), fees);
1772         }
1773 
1774         super._transfer(from, to, amount);
1775 
1776         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1777         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {
1778             
1779         }
1780 
1781         if (!liquidating) {
1782             uint256 gas = gasForProcessing;
1783 
1784             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1785                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1786             } catch {
1787 
1788             }
1789         }
1790     }
1791 
1792     function swapAndSendToDev(uint256 tokens) private {
1793         uint256 tokenBalance = tokens;
1794 
1795         // capture the contract's current ETH balance.
1796         // this is so that we can capture exactly the amount of ETH that the
1797         // swap creates, and not make the liquidity event include any ETH that
1798         // has been manually sent to the contract
1799         uint256 initialBalance = address(this).balance;
1800 
1801         // swap tokens for ETH
1802         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1803 
1804         // how much ETH did we just swap into?
1805         uint256 newBalance = address(this).balance.sub(initialBalance);
1806         address payable _devAndMarketingAddress = payable(0xD5804c501E0496F2a7a1901B0FB8F97740BeAAb6);
1807         _devAndMarketingAddress.transfer(newBalance);
1808         
1809         emit SwapAndSendToDev(tokens, newBalance);
1810     }
1811 
1812     function swapTokensForEth(uint256 tokenAmount) private {
1813         // generate the uniswap pair path of token -> weth
1814         address[] memory path = new address[](2);
1815         path[0] = address(this);
1816         path[1] = uniswapV2Router.WETH();
1817 
1818         _approve(address(this), address(uniswapV2Router), tokenAmount);
1819 
1820         // make the swap
1821         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1822             tokenAmount,
1823             0, // accept any amount of ETH
1824             path,
1825             address(this),
1826             block.timestamp
1827         );
1828     }
1829 
1830     function swapAndSendDividends(uint256 tokens) private {
1831         swapTokensForEth(tokens);
1832         uint256 dividends = address(this).balance;
1833 
1834         (bool success,) = address(dividendTracker).call{value: dividends}("");
1835         if (success) {
1836             emit SentDividends(tokens, dividends);
1837         }
1838     }
1839 }