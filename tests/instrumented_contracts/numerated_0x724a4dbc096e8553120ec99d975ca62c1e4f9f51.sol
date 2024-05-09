1 // File: contracts/IERC20.sol
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: contracts/Context.sol
82 
83 pragma solidity >=0.6.0 <0.8.0;
84 
85 /*
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with GSN meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address payable) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes memory) {
101         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
105 
106 // File: contracts/IUniswapV2Router01.sol
107 
108 pragma solidity >=0.6.2;
109 
110 interface IUniswapV2Router01 {
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113 
114     function addLiquidity(
115         address tokenA,
116         address tokenB,
117         uint amountADesired,
118         uint amountBDesired,
119         uint amountAMin,
120         uint amountBMin,
121         address to,
122         uint deadline
123     ) external returns (uint amountA, uint amountB, uint liquidity);
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132     function removeLiquidity(
133         address tokenA,
134         address tokenB,
135         uint liquidity,
136         uint amountAMin,
137         uint amountBMin,
138         address to,
139         uint deadline
140     ) external returns (uint amountA, uint amountB);
141     function removeLiquidityETH(
142         address token,
143         uint liquidity,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external returns (uint amountToken, uint amountETH);
149     function removeLiquidityWithPermit(
150         address tokenA,
151         address tokenB,
152         uint liquidity,
153         uint amountAMin,
154         uint amountBMin,
155         address to,
156         uint deadline,
157         bool approveMax, uint8 v, bytes32 r, bytes32 s
158     ) external returns (uint amountA, uint amountB);
159     function removeLiquidityETHWithPermit(
160         address token,
161         uint liquidity,
162         uint amountTokenMin,
163         uint amountETHMin,
164         address to,
165         uint deadline,
166         bool approveMax, uint8 v, bytes32 r, bytes32 s
167     ) external returns (uint amountToken, uint amountETH);
168     function swapExactTokensForTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external returns (uint[] memory amounts);
175     function swapTokensForExactTokens(
176         uint amountOut,
177         uint amountInMax,
178         address[] calldata path,
179         address to,
180         uint deadline
181     ) external returns (uint[] memory amounts);
182     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
183         external
184         payable
185         returns (uint[] memory amounts);
186     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
187         external
188         returns (uint[] memory amounts);
189     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
190         external
191         returns (uint[] memory amounts);
192     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
193         external
194         payable
195         returns (uint[] memory amounts);
196 
197     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
198     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
199     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
200     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
201     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
202 }
203 
204 // File: contracts/IUniswapV2Router02.sol
205 
206 pragma solidity >=0.6.2;
207 
208 
209 interface IUniswapV2Router02 is IUniswapV2Router01 {
210     function removeLiquidityETHSupportingFeeOnTransferTokens(
211         address token,
212         uint liquidity,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline
217     ) external returns (uint amountETH);
218     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
219         address token,
220         uint liquidity,
221         uint amountTokenMin,
222         uint amountETHMin,
223         address to,
224         uint deadline,
225         bool approveMax, uint8 v, bytes32 r, bytes32 s
226     ) external returns (uint amountETH);
227 
228     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
229         uint amountIn,
230         uint amountOutMin,
231         address[] calldata path,
232         address to,
233         uint deadline
234     ) external;
235     function swapExactETHForTokensSupportingFeeOnTransferTokens(
236         uint amountOutMin,
237         address[] calldata path,
238         address to,
239         uint deadline
240     ) external payable;
241     function swapExactTokensForETHSupportingFeeOnTransferTokens(
242         uint amountIn,
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline
247     ) external;
248 }
249 
250 // File: contracts/IUniswapV2Factory.sol
251 
252 pragma solidity >=0.5.0;
253 
254 interface IUniswapV2Factory {
255     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
256 
257     function feeTo() external view returns (address);
258     function feeToSetter() external view returns (address);
259 
260     function getPair(address tokenA, address tokenB) external view returns (address pair);
261     function allPairs(uint) external view returns (address pair);
262     function allPairsLength() external view returns (uint);
263 
264     function createPair(address tokenA, address tokenB) external returns (address pair);
265 
266     function setFeeTo(address) external;
267     function setFeeToSetter(address) external;
268 }
269 
270 // File: contracts/IUniswapV2Pair.sol
271 
272 pragma solidity >=0.5.0;
273 
274 interface IUniswapV2Pair {
275     event Approval(address indexed owner, address indexed spender, uint value);
276     event Transfer(address indexed from, address indexed to, uint value);
277 
278     function name() external pure returns (string memory);
279     function symbol() external pure returns (string memory);
280     function decimals() external pure returns (uint8);
281     function totalSupply() external view returns (uint);
282     function balanceOf(address owner) external view returns (uint);
283     function allowance(address owner, address spender) external view returns (uint);
284 
285     function approve(address spender, uint value) external returns (bool);
286     function transfer(address to, uint value) external returns (bool);
287     function transferFrom(address from, address to, uint value) external returns (bool);
288 
289     function DOMAIN_SEPARATOR() external view returns (bytes32);
290     function PERMIT_TYPEHASH() external pure returns (bytes32);
291     function nonces(address owner) external view returns (uint);
292 
293     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
294 
295     event Mint(address indexed sender, uint amount0, uint amount1);
296     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
297     event Swap(
298         address indexed sender,
299         uint amount0In,
300         uint amount1In,
301         uint amount0Out,
302         uint amount1Out,
303         address indexed to
304     );
305     event Sync(uint112 reserve0, uint112 reserve1);
306 
307     function MINIMUM_LIQUIDITY() external pure returns (uint);
308     function factory() external view returns (address);
309     function token0() external view returns (address);
310     function token1() external view returns (address);
311     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
312     function price0CumulativeLast() external view returns (uint);
313     function price1CumulativeLast() external view returns (uint);
314     function kLast() external view returns (uint);
315 
316     function mint(address to) external returns (uint liquidity);
317     function burn(address to) external returns (uint amount0, uint amount1);
318     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
319     function skim(address to) external;
320     function sync() external;
321 
322     function initialize(address, address) external;
323 }
324 
325 // File: contracts/IterableMapping.sol
326 
327 pragma solidity ^0.6.6;
328 
329 library IterableMapping {
330     // Iterable mapping from address to uint;
331     struct Map {
332         address[] keys;
333         mapping(address => uint) values;
334         mapping(address => uint) indexOf;
335         mapping(address => bool) inserted;
336     }
337 
338     function get(Map storage map, address key) public view returns (uint) {
339         return map.values[key];
340     }
341 
342     function getIndexOfKey(Map storage map, address key) public view returns (int) {
343         if(!map.inserted[key]) {
344             return -1;
345         }
346         return int(map.indexOf[key]);
347     }
348 
349     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
350         return map.keys[index];
351     }
352 
353 
354 
355     function size(Map storage map) public view returns (uint) {
356         return map.keys.length;
357     }
358 
359     function set(Map storage map, address key, uint val) public {
360         if (map.inserted[key]) {
361             map.values[key] = val;
362         } else {
363             map.inserted[key] = true;
364             map.values[key] = val;
365             map.indexOf[key] = map.keys.length;
366             map.keys.push(key);
367         }
368     }
369 
370     function remove(Map storage map, address key) public {
371         if (!map.inserted[key]) {
372             return;
373         }
374 
375         delete map.inserted[key];
376         delete map.values[key];
377 
378         uint index = map.indexOf[key];
379         uint lastIndex = map.keys.length - 1;
380         address lastKey = map.keys[lastIndex];
381 
382         map.indexOf[lastKey] = index;
383         delete map.indexOf[key];
384 
385         map.keys[index] = lastKey;
386         map.keys.pop();
387     }
388 }
389 
390 // File: contracts/Ownable.sol
391 
392 pragma solidity ^0.6.0;
393 
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor () public {
416         address msgSender = _msgSender();
417         _owner = msgSender;
418         emit OwnershipTransferred(address(0), msgSender);
419     }
420 
421     /**
422      * @dev Returns the address of the current owner.
423      */
424     function owner() public view virtual returns (address) {
425         return _owner;
426     }
427 
428     /**
429      * @dev Throws if called by any account other than the owner.
430      */
431     modifier onlyOwner() {
432         require(owner() == _msgSender(), "Ownable: caller is not the owner");
433         _;
434     }
435 
436     /**
437      * @dev Leaves the contract without owner. It will not be possible to call
438      * `onlyOwner` functions anymore. Can only be called by the current owner.
439      *
440      * NOTE: Renouncing ownership will leave the contract without an owner,
441      * thereby removing any functionality that is only available to the owner.
442      */
443     function renounceOwnership() public virtual onlyOwner {
444         emit OwnershipTransferred(_owner, address(0));
445         _owner = address(0);
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Can only be called by the current owner.
451      */
452     function transferOwnership(address newOwner) public virtual onlyOwner {
453         require(newOwner != address(0), "Ownable: new owner is the zero address");
454         emit OwnershipTransferred(_owner, newOwner);
455         _owner = newOwner;
456     }
457 }
458 
459 // File: contracts/IDividendPayingTokenOptional.sol
460 
461 pragma solidity ^0.6.0;
462 
463 /// @title Dividend-Paying Token Optional Interface
464 /// @author Roger Wu (https://github.com/roger-wu)
465 /// @dev OPTIONAL functions for a dividend-paying token contract.
466 interface IDividendPayingTokenOptional {
467   /// @notice View the amount of dividend in wei that an address can withdraw.
468   /// @param _owner The address of a token holder.
469   /// @return The amount of dividend in wei that `_owner` can withdraw.
470   function withdrawableDividendOf(address _owner) external view returns(uint256);
471 
472   /// @notice View the amount of dividend in wei that an address has withdrawn.
473   /// @param _owner The address of a token holder.
474   /// @return The amount of dividend in wei that `_owner` has withdrawn.
475   function withdrawnDividendOf(address _owner) external view returns(uint256);
476 
477   /// @notice View the amount of dividend in wei that an address has earned in total.
478   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
479   /// @param _owner The address of a token holder.
480   /// @return The amount of dividend in wei that `_owner` has earned in total.
481   function accumulativeDividendOf(address _owner) external view returns(uint256);
482 }
483 
484 // File: contracts/IDividendPayingToken.sol
485 
486 pragma solidity ^0.6.0;
487 
488 /// @title Dividend-Paying Token Interface
489 /// @author Roger Wu (https://github.com/roger-wu)
490 /// @dev An interface for a dividend-paying token contract.
491 interface IDividendPayingToken {
492   /// @notice View the amount of dividend in wei that an address can withdraw.
493   /// @param _owner The address of a token holder.
494   /// @return The amount of dividend in wei that `_owner` can withdraw.
495   function dividendOf(address _owner) external view returns(uint256);
496 
497   /// @notice Distributes ether to token holders as dividends.
498   /// @dev SHOULD distribute the paid ether to token holders as dividends.
499   ///  SHOULD NOT directly transfer ether to token holders in this function.
500   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
501   function distributeDividends() external payable;
502 
503   /// @notice Withdraws the ether distributed to the sender.
504   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
505   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
506   function withdrawDividend() external;
507 
508   /// @dev This event MUST emit when ether is distributed to token holders.
509   /// @param from The address which sends ether to this contract.
510   /// @param weiAmount The amount of distributed ether in wei.
511   event DividendsDistributed(
512     address indexed from,
513     uint256 weiAmount
514   );
515 
516   /// @dev This event MUST emit when an address withdraws their dividend.
517   /// @param to The address which withdraws ether from this contract.
518   /// @param weiAmount The amount of withdrawn ether in wei.
519   event DividendWithdrawn(
520     address indexed to,
521     uint256 weiAmount
522   );
523 }
524 
525 // File: contracts/SafeMathInt.sol
526 
527 pragma solidity ^0.6.6;
528 
529 /**
530  * @title SafeMathInt
531  * @dev Math operations with safety checks that revert on error
532  * @dev SafeMath adapted for int256
533  * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
534  */
535 library SafeMathInt {
536   function mul(int256 a, int256 b) internal pure returns (int256) {
537     // Prevent overflow when multiplying INT256_MIN with -1
538     // https://github.com/RequestNetwork/requestNetwork/issues/43
539     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
540 
541     int256 c = a * b;
542     require((b == 0) || (c / b == a));
543     return c;
544   }
545 
546   function div(int256 a, int256 b) internal pure returns (int256) {
547     // Prevent overflow when dividing INT256_MIN by -1
548     // https://github.com/RequestNetwork/requestNetwork/issues/43
549     require(!(a == - 2**255 && b == -1) && (b > 0));
550 
551     return a / b;
552   }
553 
554   function sub(int256 a, int256 b) internal pure returns (int256) {
555     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
556 
557     return a - b;
558   }
559 
560   function add(int256 a, int256 b) internal pure returns (int256) {
561     int256 c = a + b;
562     require((b >= 0 && c >= a) || (b < 0 && c < a));
563     return c;
564   }
565 
566   function toUint256Safe(int256 a) internal pure returns (uint256) {
567     require(a >= 0);
568     return uint256(a);
569   }
570 }
571 
572 // File: contracts/SafeMathUint.sol
573 
574 pragma solidity ^0.6.6;
575 
576 /**
577  * @title SafeMathUint
578  * @dev Math operations with safety checks that revert on error
579  */
580 library SafeMathUint {
581   function toInt256Safe(uint256 a) internal pure returns (int256) {
582     int256 b = int256(a);
583     require(b >= 0);
584     return b;
585   }
586 }
587 
588 // File: contracts/SafeMath.sol
589 
590 pragma solidity ^0.6.0;
591 
592 /**
593  * @dev Wrappers over Solidity's arithmetic operations with added overflow
594  * checks.
595  *
596  * Arithmetic operations in Solidity wrap on overflow. This can easily result
597  * in bugs, because programmers usually assume that an overflow raises an
598  * error, which is the standard behavior in high level programming languages.
599  * `SafeMath` restores this intuition by reverting the transaction when an
600  * operation overflows.
601  *
602  * Using this library instead of the unchecked operations eliminates an entire
603  * class of bugs, so it's recommended to use it always.
604  */
605 library SafeMath {
606     /**
607      * @dev Returns the addition of two unsigned integers, with an overflow flag.
608      *
609      * _Available since v3.4._
610      */
611     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         uint256 c = a + b;
613         if (c < a) return (false, 0);
614         return (true, c);
615     }
616 
617     /**
618      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
619      *
620      * _Available since v3.4._
621      */
622     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
623         if (b > a) return (false, 0);
624         return (true, a - b);
625     }
626 
627     /**
628      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
634         // benefit is lost if 'b' is also tested.
635         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
636         if (a == 0) return (true, 0);
637         uint256 c = a * b;
638         if (c / a != b) return (false, 0);
639         return (true, c);
640     }
641 
642     /**
643      * @dev Returns the division of two unsigned integers, with a division by zero flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         if (b == 0) return (false, 0);
649         return (true, a / b);
650     }
651 
652     /**
653      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         if (b == 0) return (false, 0);
659         return (true, a % b);
660     }
661 
662     /**
663      * @dev Returns the addition of two unsigned integers, reverting on
664      * overflow.
665      *
666      * Counterpart to Solidity's `+` operator.
667      *
668      * Requirements:
669      *
670      * - Addition cannot overflow.
671      */
672     function add(uint256 a, uint256 b) internal pure returns (uint256) {
673         uint256 c = a + b;
674         require(c >= a, "SafeMath: addition overflow");
675         return c;
676     }
677 
678     /**
679      * @dev Returns the subtraction of two unsigned integers, reverting on
680      * overflow (when the result is negative).
681      *
682      * Counterpart to Solidity's `-` operator.
683      *
684      * Requirements:
685      *
686      * - Subtraction cannot overflow.
687      */
688     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
689         require(b <= a, "SafeMath: subtraction overflow");
690         return a - b;
691     }
692 
693     /**
694      * @dev Returns the multiplication of two unsigned integers, reverting on
695      * overflow.
696      *
697      * Counterpart to Solidity's `*` operator.
698      *
699      * Requirements:
700      *
701      * - Multiplication cannot overflow.
702      */
703     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
704         if (a == 0) return 0;
705         uint256 c = a * b;
706         require(c / a == b, "SafeMath: multiplication overflow");
707         return c;
708     }
709 
710     /**
711      * @dev Returns the integer division of two unsigned integers, reverting on
712      * division by zero. The result is rounded towards zero.
713      *
714      * Counterpart to Solidity's `/` operator. Note: this function uses a
715      * `revert` opcode (which leaves remaining gas untouched) while Solidity
716      * uses an invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function div(uint256 a, uint256 b) internal pure returns (uint256) {
723         require(b > 0, "SafeMath: division by zero");
724         return a / b;
725     }
726 
727     /**
728      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
729      * reverting when dividing by zero.
730      *
731      * Counterpart to Solidity's `%` operator. This function uses a `revert`
732      * opcode (which leaves remaining gas untouched) while Solidity uses an
733      * invalid opcode to revert (consuming all remaining gas).
734      *
735      * Requirements:
736      *
737      * - The divisor cannot be zero.
738      */
739     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
740         require(b > 0, "SafeMath: modulo by zero");
741         return a % b;
742     }
743 
744     /**
745      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
746      * overflow (when the result is negative).
747      *
748      * CAUTION: This function is deprecated because it requires allocating memory for the error
749      * message unnecessarily. For custom revert reasons use {trySub}.
750      *
751      * Counterpart to Solidity's `-` operator.
752      *
753      * Requirements:
754      *
755      * - Subtraction cannot overflow.
756      */
757     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
758         require(b <= a, errorMessage);
759         return a - b;
760     }
761 
762     /**
763      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
764      * division by zero. The result is rounded towards zero.
765      *
766      * CAUTION: This function is deprecated because it requires allocating memory for the error
767      * message unnecessarily. For custom revert reasons use {tryDiv}.
768      *
769      * Counterpart to Solidity's `/` operator. Note: this function uses a
770      * `revert` opcode (which leaves remaining gas untouched) while Solidity
771      * uses an invalid opcode to revert (consuming all remaining gas).
772      *
773      * Requirements:
774      *
775      * - The divisor cannot be zero.
776      */
777     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
778         require(b > 0, errorMessage);
779         return a / b;
780     }
781 
782     /**
783      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
784      * reverting with custom message when dividing by zero.
785      *
786      * CAUTION: This function is deprecated because it requires allocating memory for the error
787      * message unnecessarily. For custom revert reasons use {tryMod}.
788      *
789      * Counterpart to Solidity's `%` operator. This function uses a `revert`
790      * opcode (which leaves remaining gas untouched) while Solidity uses an
791      * invalid opcode to revert (consuming all remaining gas).
792      *
793      * Requirements:
794      *
795      * - The divisor cannot be zero.
796      */
797     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
798         require(b > 0, errorMessage);
799         return a % b;
800     }
801 }
802 
803 // File: contracts/ERC20.sol
804 
805 pragma solidity ^0.6.0;
806 
807 
808 
809 
810 /**
811  * @dev Implementation of the {IERC20} interface.
812  *
813  * This implementation is agnostic to the way tokens are created. This means
814  * that a supply mechanism has to be added in a derived contract using {_mint}.
815  * For a generic mechanism see {ERC20PresetMinterPauser}.
816  *
817  * TIP: For a detailed writeup see our guide
818  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
819  * to implement supply mechanisms].
820  *
821  * We have followed general OpenZeppelin guidelines: functions revert instead
822  * of returning `false` on failure. This behavior is nonetheless conventional
823  * and does not conflict with the expectations of ERC20 applications.
824  *
825  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
826  * This allows applications to reconstruct the allowance for all accounts just
827  * by listening to said events. Other implementations of the EIP may not emit
828  * these events, as it isn't required by the specification.
829  *
830  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
831  * functions have been added to mitigate the well-known issues around setting
832  * allowances. See {IERC20-approve}.
833  */
834 contract ERC20 is Context, IERC20 {
835     using SafeMath for uint256;
836 
837     mapping (address => uint256) private _balances;
838 
839     mapping (address => mapping (address => uint256)) private _allowances;
840 
841     uint256 private _totalSupply;
842 
843     string private _name;
844     string private _symbol;
845     uint8 private _decimals;
846 
847     /**
848      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
849      * a default value of 18.
850      *
851      * To select a different value for {decimals}, use {_setupDecimals}.
852      *
853      * All three of these values are immutable: they can only be set once during
854      * construction.
855      */
856     constructor (string memory name_, string memory symbol_) public {
857         _name = name_;
858         _symbol = symbol_;
859         _decimals = 9;
860     }
861 
862     /**
863      * @dev Returns the name of the token.
864      */
865     function name() public view virtual returns (string memory) {
866         return _name;
867     }
868 
869     /**
870      * @dev Returns the symbol of the token, usually a shorter version of the
871      * name.
872      */
873     function symbol() public view virtual returns (string memory) {
874         return _symbol;
875     }
876 
877     /**
878      * @dev Returns the number of decimals used to get its user representation.
879      * For example, if `decimals` equals `2`, a balance of `505` tokens should
880      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
881      *
882      * Tokens usually opt for a value of 18, imitating the relationship between
883      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
884      * called.
885      *
886      * NOTE: This information is only used for _display_ purposes: it in
887      * no way affects any of the arithmetic of the contract, including
888      * {IERC20-balanceOf} and {IERC20-transfer}.
889      */
890     function decimals() public view virtual returns (uint8) {
891         return _decimals;
892     }
893 
894     /**
895      * @dev See {IERC20-totalSupply}.
896      */
897     function totalSupply() public view virtual override returns (uint256) {
898         return _totalSupply;
899     }
900 
901     /**
902      * @dev See {IERC20-balanceOf}.
903      */
904     function balanceOf(address account) public view virtual override returns (uint256) {
905         return _balances[account];
906     }
907 
908     /**
909      * @dev See {IERC20-transfer}.
910      *
911      * Requirements:
912      *
913      * - `recipient` cannot be the zero address.
914      * - the caller must have a balance of at least `amount`.
915      */
916     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
917         _transfer(_msgSender(), recipient, amount);
918         return true;
919     }
920 
921     /**
922      * @dev See {IERC20-allowance}.
923      */
924     function allowance(address owner, address spender) public view virtual override returns (uint256) {
925         return _allowances[owner][spender];
926     }
927 
928     /**
929      * @dev See {IERC20-approve}.
930      *
931      * Requirements:
932      *
933      * - `spender` cannot be the zero address.
934      */
935     function approve(address spender, uint256 amount) public virtual override returns (bool) {
936         _approve(_msgSender(), spender, amount);
937         return true;
938     }
939 
940     /**
941      * @dev See {IERC20-transferFrom}.
942      *
943      * Emits an {Approval} event indicating the updated allowance. This is not
944      * required by the EIP. See the note at the beginning of {ERC20}.
945      *
946      * Requirements:
947      *
948      * - `sender` and `recipient` cannot be the zero address.
949      * - `sender` must have a balance of at least `amount`.
950      * - the caller must have allowance for ``sender``'s tokens of at least
951      * `amount`.
952      */
953     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
954         _transfer(sender, recipient, amount);
955         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
956         return true;
957     }
958 
959     /**
960      * @dev Atomically increases the allowance granted to `spender` by the caller.
961      *
962      * This is an alternative to {approve} that can be used as a mitigation for
963      * problems described in {IERC20-approve}.
964      *
965      * Emits an {Approval} event indicating the updated allowance.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      */
971     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
972         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
973         return true;
974     }
975 
976     /**
977      * @dev Atomically decreases the allowance granted to `spender` by the caller.
978      *
979      * This is an alternative to {approve} that can be used as a mitigation for
980      * problems described in {IERC20-approve}.
981      *
982      * Emits an {Approval} event indicating the updated allowance.
983      *
984      * Requirements:
985      *
986      * - `spender` cannot be the zero address.
987      * - `spender` must have allowance for the caller of at least
988      * `subtractedValue`.
989      */
990     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
991         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
992         return true;
993     }
994 
995     /**
996      * @dev Moves tokens `amount` from `sender` to `recipient`.
997      *
998      * This is internal function is equivalent to {transfer}, and can be used to
999      * e.g. implement automatic token fees, slashing mechanisms, etc.
1000      *
1001      * Emits a {Transfer} event.
1002      *
1003      * Requirements:
1004      *
1005      * - `sender` cannot be the zero address.
1006      * - `recipient` cannot be the zero address.
1007      * - `sender` must have a balance of at least `amount`.
1008      */
1009     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1010         require(sender != address(0), "ERC20: transfer from the zero address");
1011         require(recipient != address(0), "ERC20: transfer to the zero address");
1012 
1013         _beforeTokenTransfer(sender, recipient, amount);
1014 
1015         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1016         _balances[recipient] = _balances[recipient].add(amount);
1017         emit Transfer(sender, recipient, amount);
1018     }
1019 
1020     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1021      * the total supply.
1022      *
1023      * Emits a {Transfer} event with `from` set to the zero address.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      */
1029     function _mint(address account, uint256 amount) internal virtual {
1030         require(account != address(0), "ERC20: mint to the zero address");
1031 
1032         _beforeTokenTransfer(address(0), account, amount);
1033 
1034         _totalSupply = _totalSupply.add(amount);
1035         _balances[account] = _balances[account].add(amount);
1036         emit Transfer(address(0), account, amount);
1037     }
1038 
1039     /**
1040      * @dev Destroys `amount` tokens from `account`, reducing the
1041      * total supply.
1042      *
1043      * Emits a {Transfer} event with `to` set to the zero address.
1044      *
1045      * Requirements:
1046      *
1047      * - `account` cannot be the zero address.
1048      * - `account` must have at least `amount` tokens.
1049      */
1050     function _burn(address account, uint256 amount) internal virtual {
1051         require(account != address(0), "ERC20: burn from the zero address");
1052 
1053         _beforeTokenTransfer(account, address(0), amount);
1054 
1055         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1056         _totalSupply = _totalSupply.sub(amount);
1057         emit Transfer(account, address(0), amount);
1058     }
1059 
1060     /**
1061      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1062      *
1063      * This internal function is equivalent to `approve`, and can be used to
1064      * e.g. set automatic allowances for certain subsystems, etc.
1065      *
1066      * Emits an {Approval} event.
1067      *
1068      * Requirements:
1069      *
1070      * - `owner` cannot be the zero address.
1071      * - `spender` cannot be the zero address.
1072      */
1073     function _approve(address owner, address spender, uint256 amount) internal virtual {
1074         require(owner != address(0), "ERC20: approve from the zero address");
1075         require(spender != address(0), "ERC20: approve to the zero address");
1076 
1077         _allowances[owner][spender] = amount;
1078         emit Approval(owner, spender, amount);
1079     }
1080 
1081     /**
1082      * @dev Sets {decimals} to a value other than the default one of 18.
1083      *
1084      * WARNING: This function should only be called from the constructor. Most
1085      * applications that interact with token contracts will not expect
1086      * {decimals} to ever change, and may work incorrectly if it does.
1087      */
1088     function _setupDecimals(uint8 decimals_) internal virtual {
1089         _decimals = decimals_;
1090     }
1091 
1092     /**
1093      * @dev Hook that is called before any transfer of tokens. This includes
1094      * minting and burning.
1095      *
1096      * Calling conditions:
1097      *
1098      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1099      * will be to transferred to `to`.
1100      * - when `from` is zero, `amount` tokens will be minted for `to`.
1101      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1102      * - `from` and `to` are never both zero.
1103      *
1104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1105      */
1106     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1107 }
1108 
1109 // File: contracts/DividendPayingToken.sol
1110 
1111 pragma solidity ^0.6.6;
1112 
1113 
1114 
1115 
1116 
1117 
1118 
1119 /// @title Dividend-Paying Token
1120 /// @author Roger Wu (https://github.com/roger-wu)
1121 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1122 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1123 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1124 contract DividendPayingToken is ERC20, IDividendPayingToken, IDividendPayingTokenOptional {
1125   using SafeMath for uint256;
1126   using SafeMathUint for uint256;
1127   using SafeMathInt for int256;
1128 
1129   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1130   // For more discussion about choosing the value of `magnitude`,
1131   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1132   uint256 constant internal magnitude = 2**128;
1133 
1134   uint256 internal magnifiedDividendPerShare;
1135   uint256 internal lastAmount;
1136   
1137   address public RVPToken = address(0x17EF75AA22dD5f6C2763b8304Ab24f40eE54D48a);
1138 
1139   // About dividendCorrection:
1140   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1141   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1142   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1143   //   `dividendOf(_user)` should not be changed,
1144   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1145   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1146   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1147   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1148   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1149   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1150   mapping(address => int256) internal magnifiedDividendCorrections;
1151   mapping(address => uint256) internal withdrawnDividends;
1152 
1153   uint256 public totalDividendsDistributed;
1154 
1155   constructor(string memory _name, string memory _symbol) public ERC20(_name, _symbol)  {
1156 
1157   }
1158   
1159   /// @dev Distributes dividends whenever ether is paid to this contract.
1160   receive() external payable {
1161     distributeDividends();
1162   }
1163 
1164   /// @notice Distributes ether to token holders as dividends.
1165   /// @dev It reverts if the total supply of tokens is 0.
1166   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1167   /// About undistributed ether:
1168   ///   In each distribution, there is a small amount of ether not distributed,
1169   ///     the magnified amount of which is
1170   ///     `(msg.value * magnitude) % totalSupply()`.
1171   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1172   ///     (de-magnified) in a distribution can be less than 1 wei.
1173   ///   We can actually keep track of the undistributed ether in a distribution
1174   ///     and try to distribute it in the next distribution,
1175   ///     but keeping track of such data on-chain costs much more than
1176   ///     the saved ether, so we don't do that.
1177   function distributeDividends() public override payable {
1178     require(totalSupply() > 0);
1179 
1180     if (msg.value > 0) {
1181       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1182         (msg.value).mul(magnitude) / totalSupply()
1183       );
1184       emit DividendsDistributed(msg.sender, msg.value);
1185 
1186       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1187     }
1188   }
1189   
1190 
1191   function distributeRVPDividends(uint256 amount) public {
1192     require(totalSupply() > 0);
1193 
1194     if (amount > 0) {
1195       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1196         (amount).mul(magnitude) / totalSupply()
1197       );
1198       emit DividendsDistributed(msg.sender, amount);
1199 
1200       totalDividendsDistributed = totalDividendsDistributed.add(amount);
1201     }
1202   }
1203 
1204   /// @notice Withdraws the ether distributed to the sender.
1205   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1206   function withdrawDividend() public virtual override {
1207     _withdrawDividendOfUser(msg.sender);
1208   }
1209 
1210   /// @notice Withdraws the ether distributed to the sender.
1211   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1212   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1213     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1214     if (_withdrawableDividend > 0) {
1215       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1216       emit DividendWithdrawn(user, _withdrawableDividend);
1217       bool success = IERC20(RVPToken).transfer(user, _withdrawableDividend);
1218 
1219       if(!success) {
1220         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1221         return 0;
1222       }
1223 
1224       return _withdrawableDividend;
1225     }
1226 
1227     return 0;
1228   }
1229 
1230 
1231   /// @notice View the amount of dividend in wei that an address can withdraw.
1232   /// @param _owner The address of a token holder.
1233   /// @return The amount of dividend in wei that `_owner` can withdraw.
1234   function dividendOf(address _owner) public view override returns(uint256) {
1235     return withdrawableDividendOf(_owner);
1236   }
1237 
1238   /// @notice View the amount of dividend in wei that an address can withdraw.
1239   /// @param _owner The address of a token holder.
1240   /// @return The amount of dividend in wei that `_owner` can withdraw.
1241   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1242     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1243   }
1244 
1245   /// @notice View the amount of dividend in wei that an address has withdrawn.
1246   /// @param _owner The address of a token holder.
1247   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1248   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1249     return withdrawnDividends[_owner];
1250   }
1251 
1252 
1253   /// @notice View the amount of dividend in wei that an address has earned in total.
1254   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1255   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1256   /// @param _owner The address of a token holder.
1257   /// @return The amount of dividend in wei that `_owner` has earned in total.
1258   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1259     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1260       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1261   }
1262 
1263   /// @dev Internal function that transfer tokens from one address to another.
1264   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1265   /// @param from The address to transfer from.
1266   /// @param to The address to transfer to.
1267   /// @param value The amount to be transferred.
1268   function _transfer(address from, address to, uint256 value) internal virtual override {
1269     require(false);
1270 
1271     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1272     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1273     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1274   }
1275 
1276   /// @dev Internal function that mints tokens to an account.
1277   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1278   /// @param account The account that will receive the created tokens.
1279   /// @param value The amount that will be created.
1280   function _mint(address account, uint256 value) internal override {
1281     super._mint(account, value);
1282 
1283     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1284       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1285   }
1286 
1287   /// @dev Internal function that burns an amount of the token of a given account.
1288   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1289   /// @param account The account whose tokens will be burnt.
1290   /// @param value The amount that will be burnt.
1291   function _burn(address account, uint256 value) internal override {
1292     super._burn(account, value);
1293 
1294     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1295       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1296   }
1297 
1298   function _setBalance(address account, uint256 newBalance) internal {
1299     uint256 currentBalance = balanceOf(account);
1300 
1301     if(newBalance > currentBalance) {
1302       uint256 mintAmount = newBalance.sub(currentBalance);
1303       _mint(account, mintAmount);
1304     } else if(newBalance < currentBalance) {
1305       uint256 burnAmount = currentBalance.sub(newBalance);
1306       _burn(account, burnAmount);
1307     }
1308   }
1309 }
1310 
1311 // File: contracts/YukonToken.sol
1312 
1313 pragma solidity ^0.6.6;
1314 
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 
1323 contract YUKON is ERC20, Ownable {
1324     using SafeMath for uint256;
1325 
1326     IUniswapV2Router02 public uniswapV2Router;
1327     address public uniswapV2Pair;
1328 
1329     address public RVPToken = address(0x17EF75AA22dD5f6C2763b8304Ab24f40eE54D48a);
1330 
1331     bool private swapping;
1332 
1333     YUKONDividendTracker public dividendTracker;
1334 
1335     address public liquidityWallet;
1336 
1337     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1338 
1339     uint256 public swapTokensAtAmount = 1000000000 * (10**9);
1340     uint256 public maxBuyTranscationAmount = 10000000000 * (10**9); // 1% of total supply
1341     uint256 public maxWalletToken = 20000000000 * (10**9); // 2% of total supply
1342 
1343     mapping(address => bool) public _isBlacklisted;
1344 
1345     uint256 public RVPRewardsFee = 6;
1346     uint256 public liquidityFee = 3;
1347     uint256 public marketingFee = 6;
1348     uint256 public totalFees = RVPRewardsFee.add(liquidityFee).add(marketingFee);
1349 
1350     address payable public marketingWallet = 0xFa8FDBE40829a77b87c81dB514F7E79EFA6CB4A2;
1351 
1352     // use by default 300,000 gas to process auto-claiming dividends
1353     uint256 public gasForProcessing = 300000;
1354 
1355     // exlcude from fees and max transaction amount
1356     mapping (address => bool) private _isExcludedFromFees;
1357    
1358     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1359     // could be subject to a maximum transfer amount
1360     mapping (address => bool) public automatedMarketMakerPairs;
1361 
1362     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1363 
1364     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1365 
1366     event ExcludeFromFees(address indexed account, bool isExcluded);
1367     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1368 
1369     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1370 
1371     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1372 
1373     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1374 
1375     event SwapAndLiquify(
1376         uint256 tokensSwapped,
1377         uint256 ethReceived,
1378         uint256 tokensIntoLiqudity
1379     );
1380 
1381     event SendDividends(
1382         uint256 tokensSwapped,
1383         uint256 amount
1384     );
1385 
1386     event ProcessedDividendTracker(
1387         uint256 iterations,
1388         uint256 claims,
1389         uint256 lastProcessedIndex,
1390         bool indexed automatic,
1391         uint256 gas,
1392         address indexed processor
1393     );
1394 
1395     constructor() public ERC20("YUKON", "YUKON") {
1396         dividendTracker = new YUKONDividendTracker();
1397 
1398         liquidityWallet = owner();
1399         
1400         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1401          // Create a uniswap pair for this new token
1402         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1403             .createPair(address(this), _uniswapV2Router.WETH());
1404 
1405         uniswapV2Router = _uniswapV2Router;
1406         uniswapV2Pair = _uniswapV2Pair;
1407 
1408         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1409 
1410         // exclude from receiving dividends
1411         dividendTracker.excludeFromDividends(address(dividendTracker));
1412         dividendTracker.excludeFromDividends(address(this));
1413         dividendTracker.excludeFromDividends(owner());
1414         dividendTracker.excludeFromDividends(deadWallet);
1415         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1416         
1417 
1418         // exclude from paying fees or having max transaction amount
1419         excludeFromFees(liquidityWallet, true);
1420         excludeFromFees(marketingWallet, true);
1421         excludeFromFees(address(this), true);
1422 
1423         /*
1424             _mint is an internal function in ERC20.sol that is only called here,
1425             and CANNOT be called ever again
1426         */
1427         _mint(owner(), 1000000000000 * (10**9));
1428     }
1429 
1430     receive() external payable {
1431 
1432     }
1433     
1434     function setMinTokenBalForDividends(uint256 newTokenBalForDividends) external onlyOwner {
1435         dividendTracker.setMinimumTokenBalanceForDividends(newTokenBalForDividends);
1436     }
1437     
1438     function excludeFromRewards(address account) external onlyOwner {
1439         dividendTracker.excludeFromDividends(account);
1440     }
1441     
1442     function setRVPRewardsFee(uint256 newRVPRewardsFee) external onlyOwner {
1443         RVPRewardsFee = newRVPRewardsFee;
1444     }
1445     
1446     function setLiquidityFee(uint256 newLiquidityFee) external onlyOwner {
1447         liquidityFee = newLiquidityFee;
1448     }
1449 
1450     function setMarketingFee(uint256 newMarketingFee) external onlyOwner {
1451         marketingFee = newMarketingFee;
1452     }
1453     
1454     function changeMarketingWallet(address payable newAddress) external onlyOwner {
1455         marketingWallet = newAddress;
1456     }
1457 
1458     function changeSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1459         swapTokensAtAmount = newAmount * (10**9);
1460     }
1461 
1462     function updateDividendTracker(address newAddress) public onlyOwner {
1463         require(newAddress != address(dividendTracker), "YUKON: The dividend tracker already has that address");
1464 
1465         YUKONDividendTracker newDividendTracker = YUKONDividendTracker(payable(newAddress));
1466 
1467         require(newDividendTracker.owner() == address(this), "YUKON: The new dividend tracker must be owned by the YUKON token contract");
1468 
1469         newDividendTracker.excludeFromDividends(address(newDividendTracker));
1470         newDividendTracker.excludeFromDividends(address(this));
1471         newDividendTracker.excludeFromDividends(owner());
1472         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
1473 
1474         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1475 
1476         dividendTracker = newDividendTracker;
1477     }
1478 
1479     function setMaxBuyTransaction(uint256 maxTxn) external onlyOwner {
1480   	    maxBuyTranscationAmount = maxTxn * (10**9);
1481   	}
1482   	
1483   	function setMaxWalletToken(uint256 maxToken) external onlyOwner {
1484   	    maxWalletToken = maxToken * (10**9);
1485   	}
1486 
1487     function updateUniswapV2Router(address newAddress) public onlyOwner {
1488         require(newAddress != address(uniswapV2Router), "YUKON: The router already has that address");
1489         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1490         uniswapV2Router = IUniswapV2Router02(newAddress);
1491         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1492             .createPair(address(this), uniswapV2Router.WETH());
1493         uniswapV2Pair = _uniswapV2Pair;
1494     }
1495 
1496     function excludeFromFees(address account, bool excluded) public onlyOwner {
1497         require(_isExcludedFromFees[account] != excluded, "YUKON: Account is already the value of 'excluded'");
1498         _isExcludedFromFees[account] = excluded;
1499 
1500         emit ExcludeFromFees(account, excluded);
1501     }
1502 
1503     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1504         for(uint256 i = 0; i < accounts.length; i++) {
1505             _isExcludedFromFees[accounts[i]] = excluded;
1506         }
1507 
1508         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1509     }
1510 
1511     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1512         require(pair != uniswapV2Pair, "YUKON: The UNISWAP pair cannot be removed from automatedMarketMakerPairs");
1513 
1514         _setAutomatedMarketMakerPair(pair, value);
1515     }
1516 
1517     function blacklistAddress(address account, bool value) external onlyOwner {
1518          _isBlacklisted[account] = value;
1519     }
1520 
1521     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1522         require(automatedMarketMakerPairs[pair] != value, "YUKON: Automated market maker pair is already set to that value");
1523         automatedMarketMakerPairs[pair] = value;
1524 
1525         if(value) {
1526             dividendTracker.excludeFromDividends(pair);
1527         }
1528 
1529         emit SetAutomatedMarketMakerPair(pair, value);
1530     }
1531 
1532     function updateLiquidityWallet(address newLiquidityWallet) public onlyOwner {
1533         require(newLiquidityWallet != liquidityWallet, "YUKON: The liquidity wallet is already this address");
1534         excludeFromFees(newLiquidityWallet, true);
1535         emit LiquidityWalletUpdated(newLiquidityWallet, liquidityWallet);
1536         liquidityWallet = newLiquidityWallet;
1537     }
1538 
1539     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1540         require(newValue >= 200000 && newValue <= 500000, "YUKON: gasForProcessing must be between 200,000 and 500,000");
1541         require(newValue != gasForProcessing, "YUKON: Cannot update gasForProcessing to same value");
1542         emit GasForProcessingUpdated(newValue, gasForProcessing);
1543         gasForProcessing = newValue;
1544     }
1545 
1546     function updateClaimWait(uint256 claimWait) external onlyOwner {
1547         dividendTracker.updateClaimWait(claimWait);
1548     }
1549 
1550     function getClaimWait() external view returns(uint256) {
1551         return dividendTracker.claimWait();
1552     }
1553     
1554     function isExcludedFromRewards(address account) public view returns(bool) {
1555         return dividendTracker.excludedFromDividends(account);
1556     }
1557 
1558     function getTotalDividendsDistributed() external view returns (uint256) {
1559         return dividendTracker.totalDividendsDistributed();
1560     }
1561 
1562     function isExcludedFromFees(address account) public view returns(bool) {
1563         return _isExcludedFromFees[account];
1564     }
1565     
1566     function withdrawableDividendOf(address account) public view returns(uint256) {
1567         return dividendTracker.withdrawableDividendOf(account);
1568     }
1569 
1570     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1571         return dividendTracker.balanceOf(account);
1572     }
1573 
1574     function getAccountDividendsInfo(address account)
1575         external view returns (
1576             address,
1577             int256,
1578             int256,
1579             uint256,
1580             uint256,
1581             uint256,
1582             uint256,
1583             uint256) {
1584         return dividendTracker.getAccount(account);
1585     }
1586 
1587     function getAccountDividendsInfoAtIndex(uint256 index)
1588         external view returns (
1589             address,
1590             int256,
1591             int256,
1592             uint256,
1593             uint256,
1594             uint256,
1595             uint256,
1596             uint256) {
1597         return dividendTracker.getAccountAtIndex(index);
1598     }
1599 
1600     function processDividendTracker(uint256 gas) external {
1601         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1602         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1603     }
1604 
1605     function claim() external {
1606         dividendTracker.processAccount(msg.sender, false);
1607     }
1608 
1609     function getLastProcessedIndex() external view returns(uint256) {
1610         return dividendTracker.getLastProcessedIndex();
1611     }
1612 
1613     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1614         return dividendTracker.getNumberOfTokenHolders();
1615     }
1616     
1617     function sendETHToMarketing(uint256 amount) private {
1618         uint256 initialBalance = address(this).balance;
1619     
1620         swapTokensForEth(amount);
1621         uint256 newBalance = address(this).balance.sub(initialBalance);
1622         marketingWallet.transfer(newBalance);
1623     }
1624 
1625     function _transfer(
1626         address from,
1627         address to,
1628         uint256 amount
1629     ) internal override {
1630         require(from != address(0), "ERC20: transfer from the zero address");
1631         require(to != address(0), "ERC20: transfer to the zero address");
1632         require(!_isBlacklisted[from] && !_isBlacklisted[to], 'Blacklisted address');
1633 
1634         if(amount == 0) {
1635             super._transfer(from, to, 0);
1636             return;
1637         }
1638 
1639         if (automatedMarketMakerPairs[from]) {
1640             require(
1641                 amount <= maxBuyTranscationAmount,
1642                 "Transfer amount exceeds the maxTxAmount."
1643             );
1644             
1645             uint256 contractBalanceRecepient = balanceOf(to);
1646             require(
1647                 contractBalanceRecepient + amount <= maxWalletToken,
1648                 "Exceeds maximum wallet token amount."
1649             );
1650         }
1651 
1652         uint256 contractTokenBalance = balanceOf(address(this));
1653         
1654         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1655 
1656         if(
1657             canSwap &&
1658             !swapping &&
1659             !automatedMarketMakerPairs[from] &&
1660             from != liquidityWallet &&
1661             to != liquidityWallet
1662         ) {
1663             swapping = true;
1664 
1665             uint256 marketingTokens = contractTokenBalance.mul(marketingFee).div(totalFees);
1666             sendETHToMarketing(marketingTokens);
1667 
1668             uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(totalFees);
1669             swapAndLiquify(swapTokens);
1670 
1671             uint256 sellTokens = balanceOf(address(this));
1672             swapAndSendDividends(sellTokens);
1673 
1674             swapping = false;
1675         }
1676 
1677         bool takeFee = !swapping;
1678 
1679         // if any account belongs to _isExcludedFromFee account then remove the fee
1680         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1681             takeFee = false;
1682         }
1683 
1684         if(takeFee) {
1685             uint256 fees = amount.mul(totalFees).div(100);
1686 
1687             if(automatedMarketMakerPairs[to]) {
1688                 fees += amount.mul(1).div(100);
1689             }
1690 
1691             amount = amount.sub(fees);
1692 
1693             super._transfer(from, address(this), fees);
1694         }
1695 
1696         super._transfer(from, to, amount);
1697 
1698         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1699         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1700 
1701         if(!swapping) {
1702             uint256 gas = gasForProcessing;
1703 
1704             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1705                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1706             }
1707             catch {
1708 
1709             }
1710         }
1711     }
1712 
1713     function swapAndLiquify(uint256 tokens) private {
1714         // split the contract balance into halves
1715         uint256 half = tokens.div(2);
1716         uint256 otherHalf = tokens.sub(half);
1717 
1718         // capture the contract's current ETH balance.
1719         // this is so that we can capture exactly the amount of ETH that the
1720         // swap creates, and not make the liquidity event include any ETH that
1721         // has been manually sent to the contract
1722         uint256 initialBalance = address(this).balance;
1723 
1724         // swap tokens for ETH
1725         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1726 
1727         // how much ETH did we just swap into?
1728         uint256 newBalance = address(this).balance.sub(initialBalance);
1729 
1730         // add liquidity to uniswap
1731         addLiquidity(otherHalf, newBalance);
1732         
1733         emit SwapAndLiquify(half, newBalance, otherHalf);
1734     }
1735 
1736     function swapTokensForEth(uint256 tokenAmount) private {
1737         // generate the uniswap pair path of token -> weth
1738         address[] memory path = new address[](2);
1739         path[0] = address(this);
1740         path[1] = uniswapV2Router.WETH();
1741 
1742         _approve(address(this), address(uniswapV2Router), tokenAmount);
1743 
1744         // make the swap
1745         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1746             tokenAmount,
1747             0, // accept any amount of ETH
1748             path,
1749             address(this),
1750             block.timestamp
1751         );
1752     }
1753 
1754     function swapTokensForRVP(uint256 tokenAmount, address recipient) private {
1755         // generate the uniswap pair path of weth -> busd
1756         address[] memory path = new address[](3);
1757         path[0] = address(this);
1758         path[1] = uniswapV2Router.WETH();
1759         path[2] = RVPToken;
1760 
1761         _approve(address(this), address(uniswapV2Router), tokenAmount);
1762 
1763         // make the swap
1764         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1765             tokenAmount,
1766             0, // accept any amount of BUSD
1767             path,
1768             recipient,
1769             block.timestamp
1770         );
1771     }
1772 
1773     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1774         // approve token transfer to cover all possible scenarios
1775         _approve(address(this), address(uniswapV2Router), tokenAmount);
1776 
1777         // add the liquidity
1778        uniswapV2Router.addLiquidityETH{value: ethAmount}(
1779             address(this),
1780             tokenAmount,
1781             0, // slippage is unavoidable
1782             0, // slippage is unavoidable
1783             liquidityWallet,
1784             block.timestamp
1785         );
1786     }
1787 
1788     function swapAndSendDividends(uint256 tokens) private {
1789         swapTokensForRVP(tokens, address(this));
1790         uint256 dividends = IERC20(RVPToken).balanceOf(address(this));
1791         bool success = IERC20(RVPToken).transfer(address(dividendTracker), dividends);
1792         
1793         if (success) {
1794             dividendTracker.distributeRVPDividends(dividends);
1795             emit SendDividends(tokens, dividends);
1796         }
1797     }
1798 
1799     function bulksendToken(address[] calldata _to, uint256[] calldata _values) public onlyOwner {
1800         require(_to.length == _values.length);
1801         for (uint256 i = 0; i < _to.length; i++) {
1802             _transfer(msg.sender, _to[i], _values[i]);
1803         }
1804     }
1805 
1806     // Withdraw ETH that gets stuck in contract by accident
1807     function emergencyWithdraw() external onlyOwner {
1808         payable(owner()).transfer(address(this).balance);
1809     }
1810 }
1811 
1812 contract YUKONDividendTracker is DividendPayingToken, Ownable {
1813     using SafeMath for uint256;
1814     using SafeMathInt for int256;
1815     using IterableMapping for IterableMapping.Map;
1816 
1817     IterableMapping.Map private tokenHoldersMap;
1818     uint256 public lastProcessedIndex;
1819 
1820     mapping (address => bool) public excludedFromDividends;
1821 
1822     mapping (address => uint256) public lastClaimTimes;
1823 
1824     uint256 public claimWait;
1825     uint256 public minimumTokenBalanceForDividends;
1826 
1827     event ExcludeFromDividends(address indexed account);
1828     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1829 
1830     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1831 
1832     constructor() public  DividendPayingToken("YUKON_Dividend_Tracker", "YUKON_Dividend_Tracker") {
1833         claimWait = 3600;
1834         minimumTokenBalanceForDividends = 1000000 * (10**9); // must hold 1000000 token atleast to get dividends
1835     }
1836     
1837     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
1838         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10**9);
1839     }
1840 
1841     function _transfer(address, address, uint256) internal override {
1842         require(false, "YUKON_Dividend_Tracker: No transfers allowed");
1843     }
1844 
1845     function withdrawDividend() public override {
1846         require(false, "YUKON_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main YUKON contract.");
1847     }
1848 
1849     function excludeFromDividends(address account) external onlyOwner {
1850         require(!excludedFromDividends[account]);
1851         excludedFromDividends[account] = true;
1852 
1853         _setBalance(account, 0);
1854         tokenHoldersMap.remove(account);
1855 
1856         emit ExcludeFromDividends(account);
1857     }
1858 
1859     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1860         require(newClaimWait >= 3600 && newClaimWait <= 86400, "YUKON_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1861         require(newClaimWait != claimWait, "YUKON_Dividend_Tracker: Cannot update claimWait to same value");
1862         emit ClaimWaitUpdated(newClaimWait, claimWait);
1863         claimWait = newClaimWait;
1864     }
1865 
1866     function getLastProcessedIndex() external view returns(uint256) {
1867         return lastProcessedIndex;
1868     }
1869 
1870     function getNumberOfTokenHolders() external view returns(uint256) {
1871         return tokenHoldersMap.keys.length;
1872     }
1873 
1874     function getAccount(address _account)
1875         public view returns (
1876             address account,
1877             int256 index,
1878             int256 iterationsUntilProcessed,
1879             uint256 withdrawableDividends,
1880             uint256 totalDividends,
1881             uint256 lastClaimTime,
1882             uint256 nextClaimTime,
1883             uint256 secondsUntilAutoClaimAvailable) {
1884         account = _account;
1885 
1886         index = tokenHoldersMap.getIndexOfKey(account);
1887 
1888         iterationsUntilProcessed = -1;
1889 
1890         if(index >= 0) {
1891             if(uint256(index) > lastProcessedIndex) {
1892                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1893             }
1894             else {
1895                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1896                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1897                                                         0;
1898 
1899 
1900                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1901             }
1902         }
1903 
1904         withdrawableDividends = withdrawableDividendOf(account);
1905         totalDividends = accumulativeDividendOf(account);
1906 
1907         lastClaimTime = lastClaimTimes[account];
1908 
1909         nextClaimTime = lastClaimTime > 0 ?
1910                                     lastClaimTime.add(claimWait) :
1911                                     0;
1912 
1913         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1914                                                     nextClaimTime.sub(block.timestamp) :
1915                                                     0;
1916     }
1917 
1918     function getAccountAtIndex(uint256 index)
1919         public view returns (
1920             address,
1921             int256,
1922             int256,
1923             uint256,
1924             uint256,
1925             uint256,
1926             uint256,
1927             uint256) {
1928         if(index >= tokenHoldersMap.size()) {
1929             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1930         }
1931 
1932         address account = tokenHoldersMap.getKeyAtIndex(index);
1933 
1934         return getAccount(account);
1935     }
1936 
1937     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1938         if(lastClaimTime > block.timestamp)  {
1939             return false;
1940         }
1941 
1942         return block.timestamp.sub(lastClaimTime) >= claimWait;
1943     }
1944 
1945     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1946         if(excludedFromDividends[account]) {
1947             return;
1948         }
1949 
1950         if(newBalance >= minimumTokenBalanceForDividends) {
1951             _setBalance(account, newBalance);
1952             tokenHoldersMap.set(account, newBalance);
1953         }
1954         else {
1955             _setBalance(account, 0);
1956             tokenHoldersMap.remove(account);
1957         }
1958 
1959         processAccount(account, true);
1960     }
1961 
1962     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1963         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1964 
1965         if(numberOfTokenHolders == 0) {
1966             return (0, 0, lastProcessedIndex);
1967         }
1968 
1969         uint256 _lastProcessedIndex = lastProcessedIndex;
1970 
1971         uint256 gasUsed = 0;
1972 
1973         uint256 gasLeft = gasleft();
1974 
1975         uint256 iterations = 0;
1976         uint256 claims = 0;
1977 
1978         while(gasUsed < gas && iterations < numberOfTokenHolders) {
1979             _lastProcessedIndex++;
1980 
1981             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1982                 _lastProcessedIndex = 0;
1983             }
1984 
1985             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1986 
1987             if(canAutoClaim(lastClaimTimes[account])) {
1988                 if(processAccount(payable(account), true)) {
1989                     claims++;
1990                 }
1991             }
1992 
1993             iterations++;
1994 
1995             uint256 newGasLeft = gasleft();
1996 
1997             if(gasLeft > newGasLeft) {
1998                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1999             }
2000 
2001             gasLeft = newGasLeft;
2002         }
2003 
2004         lastProcessedIndex = _lastProcessedIndex;
2005 
2006         return (iterations, claims, lastProcessedIndex);
2007     }
2008 
2009     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
2010         uint256 amount = _withdrawDividendOfUser(account);
2011 
2012         if(amount > 0) {
2013             lastClaimTimes[account] = block.timestamp;
2014             emit Claim(account, amount, automatic);
2015             return true;
2016         }
2017 
2018         return false;
2019     }
2020 }