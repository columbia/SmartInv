1 //SPDX-License-Identifier: MIT
2 
3 // File: contracts/MarshelleErrors.sol
4 
5 
6 pragma solidity ^0.8.17;
7 
8 error InvalidSwapTokenAmount(
9     string errorMsg
10 );
11 error InvalidMaxTradeAmount(
12     string errorMsg
13 );
14 error InvalidMaxWalletAmount(
15     string errorMsg
16 );
17 error InvalidTotalFees(
18     string errorMsg
19 );
20 error InvalidAutomatedMarketMakerPair(
21     address pair,
22     string errorMsg
23 );
24 error TransferFromZeroAddress(
25     address from,
26     address to
27 );
28 error TransferError(string errorMsg);
29 error InvalidAntibot(string errorMsg);
30 error InvalidMultiBuy(string errorMsg);
31 error TradingNotActive(string errorMsg);
32 error MaxWalletExceeded(string errorMsg);
33 error MaxTransactionExceeded(string errorMsg);
34 
35 // File: contracts/IterableMapping.sol
36 
37 pragma solidity ^0.8.17;
38 library IterableMapping {
39     // Iterable mapping from address to uint;
40     struct Map {
41         address[] keys;
42         mapping(address => uint) values;
43         mapping(address => uint) indexOf;
44         mapping(address => bool) inserted;
45     }
46  
47     function get(Map storage map, address key) internal view returns (uint) {
48         return map.values[key];
49     }
50  
51     function getIndexOfKey(Map storage map, address key) internal view returns (int) {
52         if(!map.inserted[key]) {
53             return -1;
54         }
55         return int(map.indexOf[key]);
56     }
57  
58     function getKeyAtIndex(Map storage map, uint index) internal view returns (address) {
59         return map.keys[index];
60     }
61  
62  
63  
64     function size(Map storage map) internal view returns (uint) {
65         return map.keys.length;
66     }
67  
68     function set(Map storage map, address key, uint val) internal {
69         if (map.inserted[key]) {
70             map.values[key] = val;
71         } else {
72             map.inserted[key] = true;
73             map.values[key] = val;
74             map.indexOf[key] = map.keys.length;
75             map.keys.push(key);
76         }
77     }
78  
79     function remove(Map storage map, address key) internal {
80         if (!map.inserted[key]) {
81             return;
82         }
83  
84         delete map.inserted[key];
85         delete map.values[key];
86  
87         uint index = map.indexOf[key];
88         uint lastIndex = map.keys.length - 1;
89         address lastKey = map.keys[lastIndex];
90  
91         map.indexOf[lastKey] = index;
92         delete map.indexOf[key];
93  
94         map.keys[index] = lastKey;
95         map.keys.pop();
96     }
97 }
98 // File: contracts/IUniswapV2Factory.sol
99 
100 
101 pragma solidity ^0.8.17;
102 
103 interface IUniswapV2Factory {
104     
105     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
106  
107     function feeTo() external view returns (address);
108 
109     function feeToSetter() external view returns (address);
110  
111     function getPair(address tokenA, address tokenB) external view returns (address pair);
112 
113     function allPairs(uint) external view returns (address pair);
114     
115     function allPairsLength() external view returns (uint);
116  
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118  
119     function setFeeTo(address) external;
120  
121     function setFeeToSetter(address) external;
122 }
123  
124 
125 
126 
127 // File: contracts/IUniswapV2Pair.sol
128 
129 pragma solidity ^0.8.17;
130 
131 
132 interface IUniswapV2Pair {
133     event Approval(
134         address indexed owner,
135         address indexed spender,
136         uint256 value
137     );
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     function name() external pure returns (string memory);
141 
142     function symbol() external pure returns (string memory);
143 
144     function decimals() external pure returns (uint8);
145 
146     function totalSupply() external view returns (uint256);
147 
148     function balanceOf(address owner) external view returns (uint256);
149 
150     function allowance(address owner, address spender)
151         external
152         view
153         returns (uint256);
154 
155     function approve(address spender, uint256 value) external returns (bool);
156 
157     function transfer(address to, uint256 value) external returns (bool);
158 
159     function transferFrom(
160         address from,
161         address to,
162         uint256 value
163     ) external returns (bool);
164 
165     function DOMAIN_SEPARATOR() external view returns (bytes32);
166 
167     function PERMIT_TYPEHASH() external pure returns (bytes32);
168 
169     function nonces(address owner) external view returns (uint256);
170 
171     function permit(
172         address owner,
173         address spender,
174         uint256 value,
175         uint256 deadline,
176         uint8 v,
177         bytes32 r,
178         bytes32 s
179     ) external;
180 
181     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
182     event Burn(
183         address indexed sender,
184         uint256 amount0,
185         uint256 amount1,
186         address indexed to
187     );
188     event Swap(
189         address indexed sender,
190         uint256 amount0In,
191         uint256 amount1In,
192         uint256 amount0Out,
193         uint256 amount1Out,
194         address indexed to
195     );
196     event Sync(uint112 reserve0, uint112 reserve1);
197 
198     function MINIMUM_LIQUIDITY() external pure returns (uint256);
199 
200     function factory() external view returns (address);
201 
202     function token0() external view returns (address);
203 
204     function token1() external view returns (address);
205 
206     function getReserves()
207         external
208         view
209         returns (
210             uint112 reserve0,
211             uint112 reserve1,
212             uint32 blockTimestampLast
213         );
214 
215     function price0CumulativeLast() external view returns (uint256);
216 
217     function price1CumulativeLast() external view returns (uint256);
218 
219     function kLast() external view returns (uint256);
220 
221     function mint(address to) external returns (uint256 liquidity);
222 
223     function burn(address to)
224         external
225         returns (uint256 amount0, uint256 amount1);
226 
227     function swap(
228         uint256 amount0Out,
229         uint256 amount1Out,
230         address to,
231         bytes calldata data
232     ) external;
233 
234     function skim(address to) external;
235 
236     function sync() external;
237 
238     function initialize(address, address) external;
239 }
240 
241 ////// src/IUniswapV2Router02.sol
242 /* pragma solidity 0.8.10; */
243 /* pragma experimental ABIEncoderV2; */
244 
245 interface IUniswapV2Router02 {
246     function factory() external pure returns (address);
247 
248     function WETH() external pure returns (address);
249 
250     function addLiquidity(
251         address tokenA,
252         address tokenB,
253         uint256 amountADesired,
254         uint256 amountBDesired,
255         uint256 amountAMin,
256         uint256 amountBMin,
257         address to,
258         uint256 deadline
259     )
260         external
261         returns (
262             uint256 amountA,
263             uint256 amountB,
264             uint256 liquidity
265         );
266 
267     function addLiquidityETH(
268         address token,
269         uint256 amountTokenDesired,
270         uint256 amountTokenMin,
271         uint256 amountETHMin,
272         address to,
273         uint256 deadline
274     )
275         external
276         payable
277         returns (
278             uint256 amountToken,
279             uint256 amountETH,
280             uint256 liquidity
281         );
282 
283     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
284         uint256 amountIn,
285         uint256 amountOutMin,
286         address[] calldata path,
287         address to,
288         uint256 deadline
289     ) external;
290 
291     function swapExactETHForTokensSupportingFeeOnTransferTokens(
292         uint256 amountOutMin,
293         address[] calldata path,
294         address to,
295         uint256 deadline
296     ) external payable;
297 
298     function swapExactTokensForETHSupportingFeeOnTransferTokens(
299         uint256 amountIn,
300         uint256 amountOutMin,
301         address[] calldata path,
302         address to,
303         uint256 deadline
304     ) external;
305 }
306 // File: contracts/IDividendPayingTokenOptional.sol
307 
308 
309 
310 pragma solidity ^0.8.7;
311 
312 
313 /// @title Dividend-Paying Token Optional Interface
314 /// @author Roger Wu (https://github.com/roger-wu)
315 /// @dev OPTIONAL functions for a dividend-paying token contract.
316 interface IDividendPayingTokenOptional {
317   /// @notice View the amount of dividend in wei that an address can withdraw.
318   /// @param _owner The address of a token holder.
319   /// @return The amount of dividend in wei that `_owner` can withdraw.
320   function withdrawableDividendOf(address _owner) external view returns(uint256);
321 
322   /// @notice View the amount of dividend in wei that an address has withdrawn.
323   /// @param _owner The address of a token holder.
324   /// @return The amount of dividend in wei that `_owner` has withdrawn.
325   function withdrawnDividendOf(address _owner) external view returns(uint256);
326 
327   /// @notice View the amount of dividend in wei that an address has earned in total.
328   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
329   /// @param _owner The address of a token holder.
330   /// @return The amount of dividend in wei that `_owner` has earned in total.
331   function accumulativeDividendOf(address _owner) external view returns(uint256);
332 }
333 // File: contracts/IDividendPayingToken.sol
334 
335 
336 
337 pragma solidity ^0.8.7;
338 
339 
340 /// @title Dividend-Paying Token Interface
341 /// @dev An interface for a dividend-paying token contract.
342 interface IDividendPayingToken {
343   /// @notice View the amount of dividend in wei that an address can withdraw.
344   /// @param _owner The address of a token holder.
345   /// @return The amount of dividend in wei that `_owner` can withdraw.
346   function dividendOf(address _owner) external view returns(uint256);
347 
348   /// @notice Distributes ether to token holders as dividends.
349   /// @dev SHOULD distribute the paid ether to token holders as dividends.
350   ///  SHOULD NOT directly transfer ether to token holders in this function.
351   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
352   function distributeDividends() external payable;
353 
354   /// @notice Withdraws the ether distributed to the sender.
355   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
356   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
357   function withdrawDividend() external;
358 
359   /// @dev This event MUST emit when ether is distributed to token holders.
360   /// @param from The address which sends ether to this contract.
361   /// @param weiAmount The amount of distributed ether in wei.
362   event DividendsDistributed(
363     address indexed from,
364     uint256 weiAmount
365   );
366 
367   /// @dev This event MUST emit when an address withdraws their dividend.
368   /// @param to The address which withdraws ether from this contract.
369   /// @param weiAmount The amount of withdrawn ether in wei.
370   event DividendWithdrawn(
371     address indexed to,
372     uint256 weiAmount
373   );
374 }
375 // File: contracts/SafeMathInt.sol
376 
377 pragma solidity ^0.8.17;
378 
379 library SafeMathInt {
380   function mul(int256 a, int256 b) internal pure returns (int256) {
381     // Prevent overflow when multiplying INT256_MIN with -1
382     // https://github.com/RequestNetwork/requestNetwork/issues/43
383     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
384  
385     int256 c = a * b;
386     require((b == 0) || (c / b == a));
387     return c;
388   }
389  
390   function div(int256 a, int256 b) internal pure returns (int256) {
391     // Prevent overflow when dividing INT256_MIN by -1
392     // https://github.com/RequestNetwork/requestNetwork/issues/43
393     require(!(a == - 2**255 && b == -1) && (b > 0));
394  
395     return a / b;
396   }
397  
398   function sub(int256 a, int256 b) internal pure returns (int256) {
399     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
400  
401     return a - b;
402   }
403  
404   function add(int256 a, int256 b) internal pure returns (int256) {
405     int256 c = a + b;
406     require((b >= 0 && c >= a) || (b < 0 && c < a));
407     return c;
408   }
409  
410   function toUint256Safe(int256 a) internal pure returns (uint256) {
411     require(a >= 0);
412     return uint256(a);
413   }
414 }
415 // File: contracts/SafeMathUint.sol
416 
417 pragma solidity ^0.8.17;
418 
419 /**
420  * @title SafeMathUint
421  * @dev Math operations with safety checks that revert on error
422  */
423 library SafeMathUint {
424   function toInt256Safe(uint256 a) internal pure returns (int256) {
425     int256 b = int256(a);
426     require(b >= 0);
427     return b;
428   }
429 }
430 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
431 
432 
433 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 // CAUTION
438 // This version of SafeMath should only be used with Solidity 0.8 or later,
439 // because it relies on the compiler's built in overflow checks.
440 
441 /**
442  * @dev Wrappers over Solidity's arithmetic operations.
443  *
444  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
445  * now has built in overflow checking.
446  */
447 library SafeMath {
448     /**
449      * @dev Returns the addition of two unsigned integers, with an overflow flag.
450      *
451      * _Available since v3.4._
452      */
453     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
454         unchecked {
455             uint256 c = a + b;
456             if (c < a) return (false, 0);
457             return (true, c);
458         }
459     }
460 
461     /**
462      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
463      *
464      * _Available since v3.4._
465      */
466     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
467         unchecked {
468             if (b > a) return (false, 0);
469             return (true, a - b);
470         }
471     }
472 
473     /**
474      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
475      *
476      * _Available since v3.4._
477      */
478     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
479         unchecked {
480             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
481             // benefit is lost if 'b' is also tested.
482             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
483             if (a == 0) return (true, 0);
484             uint256 c = a * b;
485             if (c / a != b) return (false, 0);
486             return (true, c);
487         }
488     }
489 
490     /**
491      * @dev Returns the division of two unsigned integers, with a division by zero flag.
492      *
493      * _Available since v3.4._
494      */
495     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
496         unchecked {
497             if (b == 0) return (false, 0);
498             return (true, a / b);
499         }
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
504      *
505      * _Available since v3.4._
506      */
507     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
508         unchecked {
509             if (b == 0) return (false, 0);
510             return (true, a % b);
511         }
512     }
513 
514     /**
515      * @dev Returns the addition of two unsigned integers, reverting on
516      * overflow.
517      *
518      * Counterpart to Solidity's `+` operator.
519      *
520      * Requirements:
521      *
522      * - Addition cannot overflow.
523      */
524     function add(uint256 a, uint256 b) internal pure returns (uint256) {
525         return a + b;
526     }
527 
528     /**
529      * @dev Returns the subtraction of two unsigned integers, reverting on
530      * overflow (when the result is negative).
531      *
532      * Counterpart to Solidity's `-` operator.
533      *
534      * Requirements:
535      *
536      * - Subtraction cannot overflow.
537      */
538     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
539         return a - b;
540     }
541 
542     /**
543      * @dev Returns the multiplication of two unsigned integers, reverting on
544      * overflow.
545      *
546      * Counterpart to Solidity's `*` operator.
547      *
548      * Requirements:
549      *
550      * - Multiplication cannot overflow.
551      */
552     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
553         return a * b;
554     }
555 
556     /**
557      * @dev Returns the integer division of two unsigned integers, reverting on
558      * division by zero. The result is rounded towards zero.
559      *
560      * Counterpart to Solidity's `/` operator.
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function div(uint256 a, uint256 b) internal pure returns (uint256) {
567         return a / b;
568     }
569 
570     /**
571      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
572      * reverting when dividing by zero.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
583         return a % b;
584     }
585 
586     /**
587      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
588      * overflow (when the result is negative).
589      *
590      * CAUTION: This function is deprecated because it requires allocating memory for the error
591      * message unnecessarily. For custom revert reasons use {trySub}.
592      *
593      * Counterpart to Solidity's `-` operator.
594      *
595      * Requirements:
596      *
597      * - Subtraction cannot overflow.
598      */
599     function sub(
600         uint256 a,
601         uint256 b,
602         string memory errorMessage
603     ) internal pure returns (uint256) {
604         unchecked {
605             require(b <= a, errorMessage);
606             return a - b;
607         }
608     }
609 
610     /**
611      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
612      * division by zero. The result is rounded towards zero.
613      *
614      * Counterpart to Solidity's `/` operator. Note: this function uses a
615      * `revert` opcode (which leaves remaining gas untouched) while Solidity
616      * uses an invalid opcode to revert (consuming all remaining gas).
617      *
618      * Requirements:
619      *
620      * - The divisor cannot be zero.
621      */
622     function div(
623         uint256 a,
624         uint256 b,
625         string memory errorMessage
626     ) internal pure returns (uint256) {
627         unchecked {
628             require(b > 0, errorMessage);
629             return a / b;
630         }
631     }
632 
633     /**
634      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
635      * reverting with custom message when dividing by zero.
636      *
637      * CAUTION: This function is deprecated because it requires allocating memory for the error
638      * message unnecessarily. For custom revert reasons use {tryMod}.
639      *
640      * Counterpart to Solidity's `%` operator. This function uses a `revert`
641      * opcode (which leaves remaining gas untouched) while Solidity uses an
642      * invalid opcode to revert (consuming all remaining gas).
643      *
644      * Requirements:
645      *
646      * - The divisor cannot be zero.
647      */
648     function mod(
649         uint256 a,
650         uint256 b,
651         string memory errorMessage
652     ) internal pure returns (uint256) {
653         unchecked {
654             require(b > 0, errorMessage);
655             return a % b;
656         }
657     }
658 }
659 
660 // File: contracts/IUniswapV2Router.sol
661 
662 
663 pragma solidity ^0.8.17;
664 
665 interface IUniswapV2Router {
666     function factory() external pure returns (address);
667 
668     function WETH() external pure returns (address);
669 
670     function addLiquidity(
671         address tokenA,
672         address tokenB,
673         uint256 amountADesired,
674         uint256 amountBDesired,
675         uint256 amountAMin,
676         uint256 amountBMin,
677         address to,
678         uint256 deadline
679     )
680         external
681         returns (
682             uint256 amountA,
683             uint256 amountB,
684             uint256 liquidity
685         );
686 
687     function addLiquidityETH(
688         address token,
689         uint256 amountTokenDesired,
690         uint256 amountTokenMin,
691         uint256 amountETHMin,
692         address to,
693         uint256 deadline
694     )
695         external
696         payable
697         returns (
698             uint256 amountToken,
699             uint256 amountETH,
700             uint256 liquidity
701         );
702 
703     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
704         uint256 amountIn,
705         uint256 amountOutMin,
706         address[] calldata path,
707         address to,
708         uint256 deadline
709     ) external;
710 
711     function swapExactETHForTokensSupportingFeeOnTransferTokens(
712         uint256 amountOutMin,
713         address[] calldata path,
714         address to,
715         uint256 deadline
716     ) external payable;
717 
718     function swapExactTokensForETHSupportingFeeOnTransferTokens(
719         uint256 amountIn,
720         uint256 amountOutMin,
721         address[] calldata path,
722         address to,
723         uint256 deadline
724     ) external;
725 }
726 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev Interface of the ERC20 standard as defined in the EIP.
735  */
736 interface IERC20 {
737     /**
738      * @dev Emitted when `value` tokens are moved from one account (`from`) to
739      * another (`to`).
740      *
741      * Note that `value` may be zero.
742      */
743     event Transfer(address indexed from, address indexed to, uint256 value);
744 
745     /**
746      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
747      * a call to {approve}. `value` is the new allowance.
748      */
749     event Approval(address indexed owner, address indexed spender, uint256 value);
750 
751     /**
752      * @dev Returns the amount of tokens in existence.
753      */
754     function totalSupply() external view returns (uint256);
755 
756     /**
757      * @dev Returns the amount of tokens owned by `account`.
758      */
759     function balanceOf(address account) external view returns (uint256);
760 
761     /**
762      * @dev Moves `amount` tokens from the caller's account to `to`.
763      *
764      * Returns a boolean value indicating whether the operation succeeded.
765      *
766      * Emits a {Transfer} event.
767      */
768     function transfer(address to, uint256 amount) external returns (bool);
769 
770     /**
771      * @dev Returns the remaining number of tokens that `spender` will be
772      * allowed to spend on behalf of `owner` through {transferFrom}. This is
773      * zero by default.
774      *
775      * This value changes when {approve} or {transferFrom} are called.
776      */
777     function allowance(address owner, address spender) external view returns (uint256);
778 
779     /**
780      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
781      *
782      * Returns a boolean value indicating whether the operation succeeded.
783      *
784      * IMPORTANT: Beware that changing an allowance with this method brings the risk
785      * that someone may use both the old and the new allowance by unfortunate
786      * transaction ordering. One possible solution to mitigate this race
787      * condition is to first reduce the spender's allowance to 0 and set the
788      * desired value afterwards:
789      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
790      *
791      * Emits an {Approval} event.
792      */
793     function approve(address spender, uint256 amount) external returns (bool);
794 
795     /**
796      * @dev Moves `amount` tokens from `from` to `to` using the
797      * allowance mechanism. `amount` is then deducted from the caller's
798      * allowance.
799      *
800      * Returns a boolean value indicating whether the operation succeeded.
801      *
802      * Emits a {Transfer} event.
803      */
804     function transferFrom(
805         address from,
806         address to,
807         uint256 amount
808     ) external returns (bool);
809 }
810 
811 // File: @openzeppelin/contracts/interfaces/IERC20.sol
812 
813 
814 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
815 
816 pragma solidity ^0.8.0;
817 
818 
819 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
820 
821 
822 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
823 
824 pragma solidity ^0.8.0;
825 
826 
827 /**
828  * @dev Interface for the optional metadata functions from the ERC20 standard.
829  *
830  * _Available since v4.1._
831  */
832 interface IERC20Metadata is IERC20 {
833     /**
834      * @dev Returns the name of the token.
835      */
836     function name() external view returns (string memory);
837 
838     /**
839      * @dev Returns the symbol of the token.
840      */
841     function symbol() external view returns (string memory);
842 
843     /**
844      * @dev Returns the decimals places of the token.
845      */
846     function decimals() external view returns (uint8);
847 }
848 
849 // File: @openzeppelin/contracts/utils/Context.sol
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 /**
857  * @dev Provides information about the current execution context, including the
858  * sender of the transaction and its data. While these are generally available
859  * via msg.sender and msg.data, they should not be accessed in such a direct
860  * manner, since when dealing with meta-transactions the account sending and
861  * paying for execution may not be the actual sender (as far as an application
862  * is concerned).
863  *
864  * This contract is only required for intermediate, library-like contracts.
865  */
866 abstract contract Context {
867     function _msgSender() internal view virtual returns (address) {
868         return msg.sender;
869     }
870 
871     function _msgData() internal view virtual returns (bytes calldata) {
872         return msg.data;
873     }
874 }
875 
876 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
877 
878 
879 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 
884 
885 
886 /**
887  * @dev Implementation of the {IERC20} interface.
888  *
889  * This implementation is agnostic to the way tokens are created. This means
890  * that a supply mechanism has to be added in a derived contract using {_mint}.
891  * For a generic mechanism see {ERC20PresetMinterPauser}.
892  *
893  * TIP: For a detailed writeup see our guide
894  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
895  * to implement supply mechanisms].
896  *
897  * We have followed general OpenZeppelin Contracts guidelines: functions revert
898  * instead returning `false` on failure. This behavior is nonetheless
899  * conventional and does not conflict with the expectations of ERC20
900  * applications.
901  *
902  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
903  * This allows applications to reconstruct the allowance for all accounts just
904  * by listening to said events. Other implementations of the EIP may not emit
905  * these events, as it isn't required by the specification.
906  *
907  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
908  * functions have been added to mitigate the well-known issues around setting
909  * allowances. See {IERC20-approve}.
910  */
911 contract ERC20 is Context, IERC20, IERC20Metadata {
912     mapping(address => uint256) private _balances;
913 
914     mapping(address => mapping(address => uint256)) private _allowances;
915 
916     uint256 private _totalSupply;
917 
918     string private _name;
919     string private _symbol;
920 
921     /**
922      * @dev Sets the values for {name} and {symbol}.
923      *
924      * The default value of {decimals} is 18. To select a different value for
925      * {decimals} you should overload it.
926      *
927      * All two of these values are immutable: they can only be set once during
928      * construction.
929      */
930     constructor(string memory name_, string memory symbol_) {
931         _name = name_;
932         _symbol = symbol_;
933     }
934 
935     /**
936      * @dev Returns the name of the token.
937      */
938     function name() public view virtual override returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev Returns the symbol of the token, usually a shorter version of the
944      * name.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev Returns the number of decimals used to get its user representation.
952      * For example, if `decimals` equals `2`, a balance of `505` tokens should
953      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
954      *
955      * Tokens usually opt for a value of 18, imitating the relationship between
956      * Ether and Wei. This is the value {ERC20} uses, unless this function is
957      * overridden;
958      *
959      * NOTE: This information is only used for _display_ purposes: it in
960      * no way affects any of the arithmetic of the contract, including
961      * {IERC20-balanceOf} and {IERC20-transfer}.
962      */
963     function decimals() public view virtual override returns (uint8) {
964         return 18;
965     }
966 
967     /**
968      * @dev See {IERC20-totalSupply}.
969      */
970     function totalSupply() public view virtual override returns (uint256) {
971         return _totalSupply;
972     }
973 
974     /**
975      * @dev See {IERC20-balanceOf}.
976      */
977     function balanceOf(address account) public view virtual override returns (uint256) {
978         return _balances[account];
979     }
980 
981     /**
982      * @dev See {IERC20-transfer}.
983      *
984      * Requirements:
985      *
986      * - `to` cannot be the zero address.
987      * - the caller must have a balance of at least `amount`.
988      */
989     function transfer(address to, uint256 amount) public virtual override returns (bool) {
990         address owner = _msgSender();
991         _transfer(owner, to, amount);
992         return true;
993     }
994 
995     /**
996      * @dev See {IERC20-allowance}.
997      */
998     function allowance(address owner, address spender) public view virtual override returns (uint256) {
999         return _allowances[owner][spender];
1000     }
1001 
1002     /**
1003      * @dev See {IERC20-approve}.
1004      *
1005      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1006      * `transferFrom`. This is semantically equivalent to an infinite approval.
1007      *
1008      * Requirements:
1009      *
1010      * - `spender` cannot be the zero address.
1011      */
1012     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1013         address owner = _msgSender();
1014         _approve(owner, spender, amount);
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev See {IERC20-transferFrom}.
1020      *
1021      * Emits an {Approval} event indicating the updated allowance. This is not
1022      * required by the EIP. See the note at the beginning of {ERC20}.
1023      *
1024      * NOTE: Does not update the allowance if the current allowance
1025      * is the maximum `uint256`.
1026      *
1027      * Requirements:
1028      *
1029      * - `from` and `to` cannot be the zero address.
1030      * - `from` must have a balance of at least `amount`.
1031      * - the caller must have allowance for ``from``'s tokens of at least
1032      * `amount`.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 amount
1038     ) public virtual override returns (bool) {
1039         address spender = _msgSender();
1040         _spendAllowance(from, spender, amount);
1041         _transfer(from, to, amount);
1042         return true;
1043     }
1044 
1045     /**
1046      * @dev Atomically increases the allowance granted to `spender` by the caller.
1047      *
1048      * This is an alternative to {approve} that can be used as a mitigation for
1049      * problems described in {IERC20-approve}.
1050      *
1051      * Emits an {Approval} event indicating the updated allowance.
1052      *
1053      * Requirements:
1054      *
1055      * - `spender` cannot be the zero address.
1056      */
1057     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1058         address owner = _msgSender();
1059         _approve(owner, spender, allowance(owner, spender) + addedValue);
1060         return true;
1061     }
1062 
1063     /**
1064      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1065      *
1066      * This is an alternative to {approve} that can be used as a mitigation for
1067      * problems described in {IERC20-approve}.
1068      *
1069      * Emits an {Approval} event indicating the updated allowance.
1070      *
1071      * Requirements:
1072      *
1073      * - `spender` cannot be the zero address.
1074      * - `spender` must have allowance for the caller of at least
1075      * `subtractedValue`.
1076      */
1077     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1078         address owner = _msgSender();
1079         uint256 currentAllowance = allowance(owner, spender);
1080         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1081         unchecked {
1082             _approve(owner, spender, currentAllowance - subtractedValue);
1083         }
1084 
1085         return true;
1086     }
1087 
1088     /**
1089      * @dev Moves `amount` of tokens from `from` to `to`.
1090      *
1091      * This internal function is equivalent to {transfer}, and can be used to
1092      * e.g. implement automatic token fees, slashing mechanisms, etc.
1093      *
1094      * Emits a {Transfer} event.
1095      *
1096      * Requirements:
1097      *
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      * - `from` must have a balance of at least `amount`.
1101      */
1102     function _transfer(
1103         address from,
1104         address to,
1105         uint256 amount
1106     ) internal virtual {
1107         require(from != address(0), "ERC20: transfer from the zero address");
1108         require(to != address(0), "ERC20: transfer to the zero address");
1109 
1110         _beforeTokenTransfer(from, to, amount);
1111 
1112         uint256 fromBalance = _balances[from];
1113         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1114         unchecked {
1115             _balances[from] = fromBalance - amount;
1116         }
1117         _balances[to] += amount;
1118 
1119         emit Transfer(from, to, amount);
1120 
1121         _afterTokenTransfer(from, to, amount);
1122     }
1123 
1124     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1125      * the total supply.
1126      *
1127      * Emits a {Transfer} event with `from` set to the zero address.
1128      *
1129      * Requirements:
1130      *
1131      * - `account` cannot be the zero address.
1132      */
1133     function _mint(address account, uint256 amount) internal virtual {
1134         require(account != address(0), "ERC20: mint to the zero address");
1135 
1136         _beforeTokenTransfer(address(0), account, amount);
1137 
1138         _totalSupply += amount;
1139         _balances[account] += amount;
1140         emit Transfer(address(0), account, amount);
1141 
1142         _afterTokenTransfer(address(0), account, amount);
1143     }
1144 
1145     /**
1146      * @dev Destroys `amount` tokens from `account`, reducing the
1147      * total supply.
1148      *
1149      * Emits a {Transfer} event with `to` set to the zero address.
1150      *
1151      * Requirements:
1152      *
1153      * - `account` cannot be the zero address.
1154      * - `account` must have at least `amount` tokens.
1155      */
1156     function _burn(address account, uint256 amount) internal virtual {
1157         require(account != address(0), "ERC20: burn from the zero address");
1158 
1159         _beforeTokenTransfer(account, address(0), amount);
1160 
1161         uint256 accountBalance = _balances[account];
1162         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1163         unchecked {
1164             _balances[account] = accountBalance - amount;
1165         }
1166         _totalSupply -= amount;
1167 
1168         emit Transfer(account, address(0), amount);
1169 
1170         _afterTokenTransfer(account, address(0), amount);
1171     }
1172 
1173     /**
1174      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1175      *
1176      * This internal function is equivalent to `approve`, and can be used to
1177      * e.g. set automatic allowances for certain subsystems, etc.
1178      *
1179      * Emits an {Approval} event.
1180      *
1181      * Requirements:
1182      *
1183      * - `owner` cannot be the zero address.
1184      * - `spender` cannot be the zero address.
1185      */
1186     function _approve(
1187         address owner,
1188         address spender,
1189         uint256 amount
1190     ) internal virtual {
1191         require(owner != address(0), "ERC20: approve from the zero address");
1192         require(spender != address(0), "ERC20: approve to the zero address");
1193 
1194         _allowances[owner][spender] = amount;
1195         emit Approval(owner, spender, amount);
1196     }
1197 
1198     /**
1199      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1200      *
1201      * Does not update the allowance amount in case of infinite allowance.
1202      * Revert if not enough allowance is available.
1203      *
1204      * Might emit an {Approval} event.
1205      */
1206     function _spendAllowance(
1207         address owner,
1208         address spender,
1209         uint256 amount
1210     ) internal virtual {
1211         uint256 currentAllowance = allowance(owner, spender);
1212         if (currentAllowance != type(uint256).max) {
1213             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1214             unchecked {
1215                 _approve(owner, spender, currentAllowance - amount);
1216             }
1217         }
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before any transfer of tokens. This includes
1222      * minting and burning.
1223      *
1224      * Calling conditions:
1225      *
1226      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1227      * will be transferred to `to`.
1228      * - when `from` is zero, `amount` tokens will be minted for `to`.
1229      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1230      * - `from` and `to` are never both zero.
1231      *
1232      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1233      */
1234     function _beforeTokenTransfer(
1235         address from,
1236         address to,
1237         uint256 amount
1238     ) internal virtual {}
1239 
1240     /**
1241      * @dev Hook that is called after any transfer of tokens. This includes
1242      * minting and burning.
1243      *
1244      * Calling conditions:
1245      *
1246      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1247      * has been transferred to `to`.
1248      * - when `from` is zero, `amount` tokens have been minted for `to`.
1249      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1250      * - `from` and `to` are never both zero.
1251      *
1252      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1253      */
1254     function _afterTokenTransfer(
1255         address from,
1256         address to,
1257         uint256 amount
1258     ) internal virtual {}
1259 }
1260 
1261 // File: @openzeppelin/contracts/access/Ownable.sol
1262 
1263 
1264 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 
1269 /**
1270  * @dev Contract module which provides a basic access control mechanism, where
1271  * there is an account (an owner) that can be granted exclusive access to
1272  * specific functions.
1273  *
1274  * By default, the owner account will be the one that deploys the contract. This
1275  * can later be changed with {transferOwnership}.
1276  *
1277  * This module is used through inheritance. It will make available the modifier
1278  * `onlyOwner`, which can be applied to your functions to restrict their use to
1279  * the owner.
1280  */
1281 abstract contract Ownable is Context {
1282     address private _owner;
1283 
1284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1285 
1286     /**
1287      * @dev Initializes the contract setting the deployer as the initial owner.
1288      */
1289     constructor() {
1290         _transferOwnership(_msgSender());
1291     }
1292 
1293     /**
1294      * @dev Throws if called by any account other than the owner.
1295      */
1296     modifier onlyOwner() {
1297         _checkOwner();
1298         _;
1299     }
1300 
1301     /**
1302      * @dev Returns the address of the current owner.
1303      */
1304     function owner() public view virtual returns (address) {
1305         return _owner;
1306     }
1307 
1308     /**
1309      * @dev Throws if the sender is not the owner.
1310      */
1311     function _checkOwner() internal view virtual {
1312         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1313     }
1314 
1315     /**
1316      * @dev Leaves the contract without owner. It will not be possible to call
1317      * `onlyOwner` functions anymore. Can only be called by the current owner.
1318      *
1319      * NOTE: Renouncing ownership will leave the contract without an owner,
1320      * thereby removing any functionality that is only available to the owner.
1321      */
1322     function renounceOwnership() public virtual onlyOwner {
1323         _transferOwnership(address(0));
1324     }
1325 
1326     /**
1327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1328      * Can only be called by the current owner.
1329      */
1330     function transferOwnership(address newOwner) public virtual onlyOwner {
1331         require(newOwner != address(0), "Ownable: new owner is the zero address");
1332         _transferOwnership(newOwner);
1333     }
1334 
1335     /**
1336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1337      * Internal function without access restriction.
1338      */
1339     function _transferOwnership(address newOwner) internal virtual {
1340         address oldOwner = _owner;
1341         _owner = newOwner;
1342         emit OwnershipTransferred(oldOwner, newOwner);
1343     }
1344 }
1345 
1346 // File: contracts/DividendPayingToken.sol
1347 
1348 
1349 
1350 pragma solidity ^0.8.17;
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 /// @title Dividend-Paying Token
1360 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1361 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1362 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1363 contract DividendPayingToken is ERC20, IDividendPayingToken, IDividendPayingTokenOptional, Ownable {
1364   using SafeMath for uint256;
1365   using SafeMathUint for uint256;
1366   using SafeMathInt for int256;
1367 
1368   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1369   // For more discussion about choosing the value of `magnitude`,
1370   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1371   uint256 constant internal magnitude = 2**128;
1372 
1373   uint256 internal magnifiedDividendPerShare;
1374 
1375   // About dividendCorrection:
1376   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1377   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1378   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1379   //   `dividendOf(_user)` should not be changed,
1380   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1381   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1382   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1383   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1384   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1385   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1386   mapping(address => int256) internal magnifiedDividendCorrections;
1387   mapping(address => uint256) internal withdrawnDividends;
1388   mapping(address => bool) internal _isAuth;
1389 
1390   address public dividendToken;
1391 
1392   uint256 public totalDividendsDistributed;
1393 
1394   constructor(string memory _name, string memory _symbol, address _dividendToken) ERC20(_name, _symbol) {
1395     dividendToken = _dividendToken;
1396     _isAuth[msg.sender] = true;
1397   }
1398 
1399   /// @dev Distributes dividends whenever ether is paid to this contract.
1400   receive() external payable {
1401     distributeDividends();
1402   }
1403 
1404   /// @notice Distributes ether to token holders as dividends.
1405   /// @dev It reverts if the total supply of tokens is 0.
1406   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1407   /// About undistributed ether:
1408   ///   In each distribution, there is a small amount of ether not distributed,
1409   ///     the magnified amount of which is
1410   ///     `(msg.value * magnitude) % totalSupply()`.
1411   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1412   ///     (de-magnified) in a distribution can be less than 1 wei.
1413   ///   We can actually keep track of the undistributed ether in a distribution
1414   ///     and try to distribute it in the next distribution,
1415   ///     but keeping track of such data on-chain costs much more than
1416   ///     the saved ether, so we don't do that.
1417   function distributeDividends() public override payable {
1418     require(totalSupply() > 0);
1419 
1420     if (msg.value > 0) {
1421       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1422         (msg.value).mul(magnitude) / totalSupply()
1423       );
1424       emit DividendsDistributed(msg.sender, msg.value);
1425 
1426       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1427     }
1428   }
1429 
1430 
1431   
1432   function distributeTokenDividends(uint256 amount) public onlyOwner {
1433     require(totalSupply() > 0);
1434 
1435     if (amount > 0) {
1436       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1437         (amount).mul(magnitude) / totalSupply()
1438       );
1439       emit DividendsDistributed(msg.sender, amount);
1440 
1441       totalDividendsDistributed = totalDividendsDistributed.add(amount);
1442     }
1443   }
1444 
1445 
1446   /// @notice Withdraws the ether distributed to the sender.
1447   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1448   function withdrawDividend() public virtual override {
1449     _withdrawDividendOfUser(payable(msg.sender));
1450   }
1451 
1452   /// @notice Withdraws the ether distributed to the sender.
1453   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1454   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1455     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1456     if (_withdrawableDividend > 0) {
1457       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1458       emit DividendWithdrawn(user, _withdrawableDividend);
1459       (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
1460 
1461       if(!success) {
1462         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1463         return 0;
1464       }
1465 
1466       return _withdrawableDividend;
1467     }
1468 
1469     return 0;
1470   }
1471 
1472 
1473   /// @notice View the amount of dividend in wei that an address can withdraw.
1474   /// @param _owner The address of a token holder.
1475   /// @return The amount of dividend in wei that `_owner` can withdraw.
1476   function dividendOf(address _owner) public view override returns(uint256) {
1477     return withdrawableDividendOf(_owner);
1478   }
1479 
1480   /// @notice View the amount of dividend in wei that an address can withdraw.
1481   /// @param _owner The address of a token holder.
1482   /// @return The amount of dividend in wei that `_owner` can withdraw.
1483   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1484     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1485   }
1486 
1487   /// @notice View the amount of dividend in wei that an address has withdrawn.
1488   /// @param _owner The address of a token holder.
1489   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1490   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1491     return withdrawnDividends[_owner];
1492   }
1493 
1494 
1495   /// @notice View the amount of dividend in wei that an address has earned in total.
1496   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1497   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1498   /// @param _owner The address of a token holder.
1499   /// @return The amount of dividend in wei that `_owner` has earned in total.
1500   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1501     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1502       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1503   }
1504 
1505 
1506   /// @dev Set the address of the dividend token
1507   /// @param _dividendToken address of the dividend token being set
1508   function setDividendTokenAddress(address _dividendToken) external virtual onlyOwner{
1509       dividendToken = _dividendToken;
1510   }
1511 
1512     
1513   /// @dev Set Authorized accounts for calling external functionts
1514   /// @param account address of the account being authorized
1515   function setAuth(address account, bool status) external onlyOwner{
1516       _isAuth[account] = status;
1517   }
1518 
1519   /// @dev Internal function that transfer tokens from one address to another.
1520   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1521   /// @param from The address to transfer from.
1522   /// @param to The address to transfer to.
1523   /// @param value The amount to be transferred.
1524   function _transfer(address from, address to, uint256 value) internal virtual override {
1525     require(false);
1526 
1527     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1528     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1529     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1530   }
1531 
1532   /// @dev Internal function that mints tokens to an account.
1533   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1534   /// @param account The account that will receive the created tokens.
1535   /// @param value The amount that will be created.
1536   function _mint(address account, uint256 value) internal override {
1537     super._mint(account, value);
1538 
1539     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1540       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1541   }
1542 
1543   /// @dev Internal function that burns an amount of the token of a given account.
1544   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1545   /// @param account The account whose tokens will be burnt.
1546   /// @param value The amount that will be burnt.
1547   function _burn(address account, uint256 value) internal override {
1548     super._burn(account, value);
1549 
1550     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1551       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1552   }
1553 
1554   function _setBalance(address account, uint256 newBalance) internal {
1555     uint256 currentBalance = balanceOf(account);
1556 
1557     if(newBalance > currentBalance) {
1558       uint256 mintAmount = newBalance.sub(currentBalance);
1559       _mint(account, mintAmount);
1560     } else if(newBalance < currentBalance) {
1561       uint256 burnAmount = currentBalance.sub(newBalance);
1562       _burn(account, burnAmount);
1563     }
1564   }
1565 }
1566 // File: contracts/MarshelleInuDividendTracker.sol
1567 
1568 pragma solidity ^0.8.17;
1569 
1570 
1571 
1572 
1573 
1574 
1575 contract MarshelleInuDividendTracker is DividendPayingToken {
1576     using SafeMath for uint256;
1577     using SafeMathInt for int256;
1578     using IterableMapping for IterableMapping.Map;
1579  
1580     IterableMapping.Map private tokenHoldersMap;
1581     uint256 public lastProcessedIndex;
1582  
1583     mapping (address => bool) public excludedFromDividends;
1584  
1585     mapping (address => uint256) public lastClaimTimes;
1586  
1587     uint256 public claimWait;
1588     uint256 public minimumTokenBalanceForDividends;
1589 
1590     
1591 
1592     event ExcludeFromDividends(address indexed account);
1593     event ClaimWaitUpdated(
1594         uint256 indexed newValue, 
1595         uint256 indexed oldValue
1596     );
1597  
1598     event Claim(
1599         address indexed account, 
1600         uint256 amount, 
1601         bool indexed automatic
1602     );
1603  
1604     constructor(address _dividentToken) DividendPayingToken("MarshelleInu_Tracker", "MarshelleInu_Tracker",_dividentToken) {
1605     	claimWait = 60;
1606         minimumTokenBalanceForDividends = 1_000_0 * (10**18);
1607     }
1608  
1609     function _transfer(address, address, uint256) pure internal override {
1610         require(false, "MarshelleInu_Tracker: No transfers allowed");
1611     }
1612  
1613     function withdrawDividend() pure public override {
1614         require(false, "MarshelleInu_Tracker: withdrawDividend disabled. Use the 'claim' function on the main MarshelleInu contract.");
1615     }
1616  
1617     function setDividendTokenAddress(address newToken) external override onlyOwner {
1618       dividendToken = newToken;
1619     }
1620 
1621 
1622     function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
1623         require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
1624         minimumTokenBalanceForDividends = _newMinimumBalance * (10**9);
1625     }
1626 
1627 
1628  
1629     function excludeFromDividends(address account) external onlyOwner {
1630     	require(!excludedFromDividends[account],"Address already excluded from dividends");
1631     	excludedFromDividends[account] = true;
1632  
1633     	_setBalance(account, 0);
1634     	tokenHoldersMap.remove(account);
1635  
1636     	emit ExcludeFromDividends(account);
1637     }
1638     function includeInDividends(address account) external onlyOwner {
1639         excludedFromDividends[account] = false;
1640     }
1641  
1642     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1643         require(newClaimWait >= 3600 && newClaimWait <= 86400, "MarshelleInu_Tracker: claimWait must be updated to between 1 and 24 hours");
1644         require(newClaimWait != claimWait, "MarshelleInu_Tracker: Cannot update claimWait to same value");
1645         emit ClaimWaitUpdated(newClaimWait, claimWait);
1646         claimWait = newClaimWait;
1647     }
1648  
1649     function getLastProcessedIndex() external view returns(uint256) {
1650     	return lastProcessedIndex;
1651     }
1652  
1653     function getNumberOfTokenHolders() external view returns(uint256) {
1654         return tokenHoldersMap.keys.length;
1655     }
1656  
1657  
1658     function getAccount(address _account)
1659         public view returns (
1660             address account,
1661             int256 index,
1662             int256 iterationsUntilProcessed,
1663             uint256 withdrawableDividends,
1664             uint256 totalDividends,
1665             uint256 lastClaimTime,
1666             uint256 nextClaimTime,
1667             uint256 secondsUntilAutoClaimAvailable) {
1668         account = _account;
1669  
1670         index = tokenHoldersMap.getIndexOfKey(account);
1671  
1672         iterationsUntilProcessed = -1;
1673  
1674         if(index >= 0) {
1675             if(uint256(index) > lastProcessedIndex) {
1676                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1677             }
1678             else {
1679                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1680                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1681                                                         0;
1682  
1683  
1684                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1685             }
1686         }
1687  
1688  
1689         withdrawableDividends = withdrawableDividendOf(account);
1690         totalDividends = accumulativeDividendOf(account);
1691  
1692         lastClaimTime = lastClaimTimes[account];
1693  
1694         nextClaimTime = lastClaimTime > 0 ?
1695                                     lastClaimTime.add(claimWait) :
1696                                     0;
1697  
1698         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1699                                                     nextClaimTime.sub(block.timestamp) :
1700                                                     0;
1701     }
1702  
1703     function getAccountAtIndex(uint256 index)
1704         public view returns (
1705             address,
1706             int256,
1707             int256,
1708             uint256,
1709             uint256,
1710             uint256,
1711             uint256,
1712             uint256) {
1713     	if(index >= tokenHoldersMap.size()) {
1714             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1715         }
1716  
1717         address account = tokenHoldersMap.getKeyAtIndex(index);
1718  
1719         return getAccount(account);
1720     }
1721  
1722     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1723     	if(lastClaimTime > block.timestamp)  {
1724     		return false;
1725     	}
1726  
1727     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1728     }
1729  
1730     function setBalance(
1731         address payable account, 
1732         uint256 newBalance
1733     ) external onlyOwner {
1734     	if(excludedFromDividends[account]) {
1735     		return;
1736     	}
1737  
1738     	if(newBalance >= minimumTokenBalanceForDividends) {
1739             _setBalance(account, newBalance);
1740     		tokenHoldersMap.set(account, newBalance);
1741     	}
1742     	else {
1743             _setBalance(account, 0);
1744     		tokenHoldersMap.remove(account);
1745     	}
1746  
1747     	processAccount(account, true);
1748     }
1749  
1750     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1751     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1752  
1753     	if(numberOfTokenHolders == 0) {
1754     		return (0, 0, lastProcessedIndex);
1755     	}
1756  
1757     	uint256 _lastProcessedIndex = lastProcessedIndex;
1758  
1759     	uint256 gasUsed = 0;
1760  
1761     	uint256 gasLeft = gasleft();
1762  
1763     	uint256 iterations = 0;
1764     	uint256 claims = 0;
1765  
1766     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1767     		_lastProcessedIndex++;
1768  
1769     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1770     			_lastProcessedIndex = 0;
1771     		}
1772  
1773     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1774  
1775     		if(canAutoClaim(lastClaimTimes[account])) {
1776     			if(processAccount(payable(account), true)) {
1777     				claims++;
1778     			}
1779     		}
1780  
1781     		iterations++;
1782  
1783     		uint256 newGasLeft = gasleft();
1784  
1785     		if(gasLeft > newGasLeft) {
1786     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1787     		}
1788  
1789     		gasLeft = newGasLeft;
1790     	}
1791  
1792     	lastProcessedIndex = _lastProcessedIndex;
1793  
1794     	return (iterations, claims, lastProcessedIndex);
1795     }
1796  
1797     function processAccount(
1798         address payable account, 
1799         bool automatic
1800     ) public onlyOwner returns (bool) {
1801 
1802         uint256 amount = _withdrawDividendOfUser(account);
1803  
1804     	if(amount > 0) {
1805     		lastClaimTimes[account] = block.timestamp;
1806             emit Claim(account, amount, automatic);
1807     		return true;
1808     	}
1809  
1810     	return false;
1811     }
1812 }
1813 
1814 // File: contracts/MarshelleInu.sol
1815 
1816 
1817 pragma solidity ^0.8.17;
1818 
1819 /*****
1820  *   ,---.    ,---.   ____    .-------.       .-'''-. .---.  .---.     .-''-.    .---.     .---.       .-''-.          .-./`) ,---.   .--.  ___    _
1821  *   |    \  /    | .'  __ `. |  _ _   \     / _     \|   |  |_ _|   .'_ _   \   | ,_|     | ,_|     .'_ _   \         \ .-.')|    \  |  |.'   |  | |
1822  *   |  ,  \/  ,  |/   '  \  \| ( ' )  |    (`' )/`--'|   |  ( ' )  / ( ` )   ',-./  )   ,-./  )    / ( ` )   '        / `-' \|  ,  \ |  ||   .'  | |
1823  *   |  |\_   /|  ||___|  /  ||(_ o _) /   (_ o _).   |   '-(_{;}_). (_ o _)  |\  '_ '`) \  '_ '`) . (_ o _)  |         `-'`"`|  |\_ \|  |.'  '_  | |
1824  *   |  _( )_/ |  |   _.-`   || (_,_).' __  (_,_). '. |      (_,_) |  (_,_)___| > (_)  )  > (_)  ) |  (_,_)___|         .---. |  _( )_\  |'   ( \.-.|
1825  *   | (_ o _) |  |.'   _    ||  |\ \  |  |.---.  \  :| _ _--.   | '  \   .---.(  .  .-' (  .  .-' '  \   .---.         |   | | (_ o _)  |' (`. _` /|
1826  *   |  (_,_)  |  ||  _( )_  ||  | \ `'   /\    `-'  ||( ' ) |   |  \  `-'    / `-'`-'|___`-'`-'|___\  `-'    /         |   | |  (_,_)\  || (_ (_) _)
1827  *   |  |      |  |\ (_ o _) /|  |  \    /  \       / (_{;}_)|   |   \       /   |        \|        \\       /          |   | |  |    |  | \ /  . \ /
1828  *   '--'      '--' '.(_,_).' ''-'   `'-'    `-...-'  '(_,_) '---'    `'-..-'    `--------``--------` `'-..-'           '---' '--'    '--'  ``-'`-''
1829  *****/
1830 
1831 
1832 
1833 
1834 
1835 
1836 
1837 
1838 
1839 
1840 contract MarshelleInu  is ERC20, Ownable {
1841     using SafeMath for uint256;
1842 
1843     IUniswapV2Router private uniswapV2Router;
1844     MarshelleInuDividendTracker public marshelleInuDividendTracker;
1845     
1846     address private uniswapV2Pair;
1847     address public constant deadAddress = address(0xdead);
1848     address public MRI = address(0x0913dDAE242839f8995c0375493f9a1A3Bddc977);
1849     address public marketingWallet = address(0x4EB85dA43eb3587E21294d4d5a6922892CF12658);
1850     address public devWallet = address(0x721a025a1dA21C22Cc811E3117053939D31047Ce);
1851 
1852     // boolean
1853     bool private isSwapping;
1854     bool swapAndLiquifyEnabled;
1855     bool public ProcessDividendStatus;
1856     // uint
1857     uint256 public _totalSupply;
1858     uint256 public maxBuyTxAmount;
1859     uint256 public maxSellTxAmount;
1860     uint256 public maxWalletAmount;
1861     uint256 public swapAndLiquifyThreshold;
1862     uint256 public tradingEnabledAt;
1863 
1864     uint256 private buyTotalFees;
1865     uint256 private buyMarketingFee;
1866     uint256 private buyDevFee;
1867     uint256 private buyLiquidityFee;
1868     uint256 private buyReflectionsFee;
1869 
1870     uint256 private sellTotalFees;
1871     uint256 private sellMarketingFee;
1872     uint256 private sellDevFee;
1873     uint256 private sellLiquidityFee;
1874     uint256 private sellReflectionsFee;
1875 
1876 
1877     uint256 private tokensForMarketing;
1878     uint256 private tokensForDev;
1879     uint256 private tokensForLiquidity;
1880     uint256 private tokensForReflections;
1881 
1882     uint256 public gasForProcessing = 300000;
1883 
1884     // mappings
1885     mapping(address => bool) public _isExcludedFromFees;
1886     mapping(address => bool) public _isExcludedFromMaxTrade;
1887     mapping(address => bool) public _isExcludedFromMaxWallet;
1888     mapping(address => bool) public automatedMarketMakerPairs;
1889   //  mapping(address => bool) public presaleAcc;
1890 
1891 
1892     event UpdateBuyFees(
1893         uint256 buyTotalFees,
1894         uint256 buyMarketingFee,
1895         uint256 buyDevFee,
1896         uint256 buyLiquidityFee,
1897         uint256 buyReflectionsFee
1898     );
1899     event UpdateSellFees(
1900         uint256 sellTotalFees,
1901         uint256 sellMarketingFee,
1902         uint256 sellDevFee,
1903         uint256 sellLiquidityFee,
1904         uint256 sellReflectionsFee
1905     );
1906     event UpdateUniswapV2Router(
1907         address indexed newRouter,
1908         address indexed oldRouter
1909     );
1910     event ExcludeFromFees(address indexed account, bool isExcluded);
1911     event ExcludeFromMaxTrade(address indexed account, bool isExcluded);
1912     event ExcludeFromMaxWallet(address indexed account, bool isExcluded);
1913     event SetAutomatedMarketMakerPair(
1914         address indexed pair,
1915         bool indexed status
1916     );
1917     event UpdateDevWallet(address indexed newWallet, address indexed oldWallet);
1918     event UpdateMarketingWallet(
1919         address indexed newWallet,
1920         address indexed oldWallet
1921     );
1922     event UpdateDividendToken(address indexed oldDividendToken, address indexed newDividendToken);
1923     event IncludeInDividends(address indexed wallet);
1924     event ExcludeFromDividends(address indexed wallet);
1925     event UpdateDividendTracker(
1926         address oldDividendTracker,
1927         address newDividendTracker
1928     );
1929     event UpdateDividendAddress(
1930         address oldDividendAddress,
1931         address newDividendAddress
1932     );
1933     event UpdateSwapAndLiquify(bool enabled);
1934     event UpadateDividendEnabled(bool enabled);
1935     event SwapAndLiquify(
1936         uint256 tokensSwapped,
1937         uint256 ethReceived,
1938         uint256 tokensIntoLiquidity
1939     );
1940     event SendDividends(uint256 tokensSwapped, uint256 amount);
1941     event ProcessedDividendTracker(
1942         uint256 iterations,
1943         uint256 claims,
1944         uint256 lastProcessedIndex,
1945         bool indexed automatic,
1946         uint256 gas,
1947         address indexed processor
1948     );
1949 
1950     constructor() ERC20("MarshelleInu", "ELLE") {
1951         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(
1952             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D  
1953         );
1954 
1955         uniswapV2Router = _uniswapV2Router;
1956 
1957         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1958             .createPair(address(this), _uniswapV2Router.WETH());
1959 
1960         _initializeVariables();
1961 
1962         /*
1963             _mint is an internal function in ERC20.sol that is only called here,
1964             and CANNOT be called ever again
1965         */
1966         _mint(msg.sender, _totalSupply);
1967     }
1968 
1969     receive() external payable {}
1970 
1971     // initialize state variables at deploy
1972     function _initializeVariables() private {
1973         _isExcludedFromFees[uniswapV2Pair] = true;
1974 
1975         _isExcludedFromMaxTrade[uniswapV2Pair] = true;
1976         _isExcludedFromMaxWallet[uniswapV2Pair] = true;
1977         automatedMarketMakerPairs[uniswapV2Pair] = true;
1978 
1979         // exclude from paying fees or having max transaction amount
1980         _isExcludedFromFees[owner()] = true;
1981         _isExcludedFromFees[address(this)] = true;
1982         _isExcludedFromFees[deadAddress] = true;
1983 
1984         _isExcludedFromMaxTrade[owner()] = true;
1985         _isExcludedFromMaxTrade[address(this)] = true;
1986         _isExcludedFromMaxTrade[deadAddress] = true;
1987         _isExcludedFromMaxWallet[owner()] = true;
1988      //   _isExcludedFromMaxWallet[address(Oxdead)] = true;
1989         _isExcludedFromMaxWallet[address(this)] = true;
1990         marshelleInuDividendTracker = new MarshelleInuDividendTracker(MRI);
1991         marshelleInuDividendTracker.setAuth(owner(), true);
1992 //        _allowances[address(this)][address(uniswapV2Router)] = uint256(-1);
1993     //    _allowances[address(this)][address(router)] = uint256(-1);
1994 
1995         marshelleInuDividendTracker.excludeFromDividends(address(marshelleInuDividendTracker));
1996         marshelleInuDividendTracker.excludedFromDividends(address(this));
1997         marshelleInuDividendTracker.excludedFromDividends(address(uniswapV2Router));        
1998         marshelleInuDividendTracker.excludedFromDividends(deadAddress);
1999         marshelleInuDividendTracker.excludedFromDividends(owner());
2000 
2001  //       presaleAcc[owner()] = true;
2002         _totalSupply = 1_000_000_000 * 1e18;
2003         maxBuyTxAmount = 20_000_000 * 1e18; // 2% of total supply
2004         maxSellTxAmount = 10_000_000 * 1e18; // 1% of total supply
2005         maxWalletAmount = 20_000_000 * 1e18; // 2% of total supply
2006         swapAndLiquifyThreshold = (_totalSupply * 2) / 10000; // 0.02% contarct swap
2007 
2008         buyMarketingFee = 3;
2009         buyDevFee = 1;
2010         buyLiquidityFee = 2;
2011         buyReflectionsFee = 2;
2012         buyTotalFees =
2013             buyMarketingFee +
2014             buyDevFee +
2015             buyLiquidityFee +
2016             buyReflectionsFee;
2017 
2018         sellMarketingFee = 7;
2019         sellDevFee = 1;
2020         sellLiquidityFee = 2;
2021         sellReflectionsFee = 2;
2022         sellTotalFees =
2023             sellMarketingFee +
2024             sellDevFee +
2025             sellLiquidityFee +
2026             sellReflectionsFee;
2027 
2028         ProcessDividendStatus = true;
2029         marketingWallet = deadAddress;
2030         devWallet = deadAddress;
2031     }
2032 
2033     function _transfer(
2034         address from,
2035         address to,
2036         uint256 amount
2037     ) internal override {
2038         //tx utility vars
2039         //        uint256 trade_type = 0;
2040 
2041         bool overSwapThreshold = balanceOf(address(this)) >=
2042             swapAndLiquifyThreshold;
2043 
2044 
2045         if (!isSwapping) {
2046             // not a contract swap
2047 
2048             if (automatedMarketMakerPairs[from]) {
2049                 //buy transaction
2050 
2051                 if (!_isExcludedFromMaxTrade[to]) {
2052                     // tx limit
2053                     if (amount > maxBuyTxAmount)
2054                         revert TransferError("Exceeded max buy TxAmount");
2055                 }
2056 
2057                 if (!_isExcludedFromMaxWallet[to]) {
2058                     // wallet limit
2059                     if (balanceOf(to) + amount > maxWalletAmount)
2060                         revert TransferError("Exceeded max buy TxAmount");
2061                 }
2062 
2063                 // takeFees - buy
2064                 if (buyTotalFees > 0 && !_isExcludedFromFees[to]) {
2065                     uint256 txFees = (amount * buyTotalFees) / 100;
2066                     amount -= txFees;
2067                     tokensForMarketing +=
2068                         (txFees * buyMarketingFee) /
2069                         buyTotalFees;
2070                     tokensForDev += (txFees * buyDevFee) / buyTotalFees;
2071                     tokensForLiquidity +=
2072                         (txFees * buyLiquidityFee) /
2073                         buyTotalFees;
2074                     tokensForReflections +=
2075                         (txFees * buyReflectionsFee) /
2076                         buyTotalFees;
2077                     super._transfer(from, address(this), txFees);
2078                 }
2079             } else if (automatedMarketMakerPairs[to]) {
2080                 //sell transaction
2081                 if (
2082                     swapAndLiquifyEnabled &&
2083                     sellTotalFees > 0 &&
2084                     overSwapThreshold
2085                 ) swapBack();   
2086 
2087                 if (!_isExcludedFromMaxTrade[from]) {
2088                     if (amount > maxSellTxAmount)
2089                         revert TransferError("Exceeded max sell TxAmount");
2090                 }
2091                 // check whether to sell from the contract
2092                 
2093             // takefees - sell
2094             if (sellTotalFees > 0 && !_isExcludedFromFees[from]) {
2095                 uint256 txFees = (amount * sellTotalFees) / 100;
2096                 amount -= txFees;
2097                 tokensForMarketing +=
2098                     (txFees * sellMarketingFee) /
2099                     sellTotalFees;
2100                 tokensForDev += (txFees * sellDevFee) / sellTotalFees;
2101                 tokensForLiquidity +=
2102                     (txFees * sellLiquidityFee) /
2103                     sellTotalFees;
2104                 tokensForReflections +=
2105                     (txFees * sellReflectionsFee) /
2106                     sellTotalFees;
2107 
2108                 super._transfer(from, address(this), txFees);
2109             }
2110         }
2111         }
2112 
2113         // transfer tokens erc20 standard
2114         super._transfer(from, to, amount);
2115 
2116         //set dividends
2117         try
2118             marshelleInuDividendTracker.setBalance(payable(from), balanceOf(from))
2119         {} catch {}
2120         try
2121             marshelleInuDividendTracker.setBalance(payable(to), balanceOf(to))
2122         {} catch {}
2123         // auto-claims one time per transaction
2124         if (!isSwapping && ProcessDividendStatus) {
2125             uint256 gas = gasForProcessing;
2126 
2127             try marshelleInuDividendTracker.process(gas) returns (
2128                 uint256 iterations,
2129                 uint256 claims,
2130                 uint256 lastProcessedIndex
2131             ) {
2132                 emit ProcessedDividendTracker(
2133                     iterations,
2134                     claims,
2135                     lastProcessedIndex,
2136                     true,
2137                     gas,
2138                     tx.origin
2139                 );
2140             } catch {}
2141         }
2142     }
2143 
2144 
2145     function swapTokensForETH(uint256 tokenAmount) private {
2146         // generate the uniswap pair path of token -> weth
2147         address[] memory path = new address[](2);
2148         path[0] = address(this);
2149         path[1] = uniswapV2Router.WETH();
2150 
2151         _approve(address(this), address(uniswapV2Router), tokenAmount);
2152 
2153         // make the swap
2154         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2155             tokenAmount,
2156             0, // accept any amount of ETH
2157             path,
2158             address(this),
2159             block.timestamp
2160         );
2161     }
2162 
2163     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2164         // approve token transfer to cover all possible scenarios
2165         _approve(address(this), address(uniswapV2Router), tokenAmount);
2166 
2167         // add the liquidity
2168         uniswapV2Router.addLiquidityETH{value: ethAmount}(
2169             address(this),
2170             tokenAmount,
2171             0, // slippage is unavoidable
2172             0, // slippage is unavoidable
2173             deadAddress,
2174             block.timestamp
2175         );
2176     }
2177 
2178     function swapETHForMRI(uint256 ethAmount) private {
2179 
2180         if(ethAmount > 0){
2181             address[] memory path = new address[](2);
2182             path[0] = uniswapV2Router.WETH();
2183             path[1] = MRI;
2184             
2185             uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
2186                 0,
2187                 path,
2188                 address(this),
2189                 block.timestamp
2190             );
2191         }
2192     }
2193 
2194     function swapBack() private {
2195         isSwapping = true; 
2196         uint256 contractBalance = balanceOf(address(this));
2197 
2198         uint256 totalTokens = tokensForDev +
2199             tokensForMarketing +
2200             tokensForLiquidity +
2201             tokensForReflections;
2202             
2203         bool success;
2204         uint256 swapBalance;
2205         if (contractBalance == 0 || totalTokens == 0) {
2206             return;
2207         }
2208 
2209         if(totalTokens > swapAndLiquifyThreshold){
2210             // never swap more than the threshold
2211             swapBalance = swapAndLiquifyThreshold;
2212         } else{
2213             swapBalance = totalTokens;
2214         }
2215         
2216         // Halve the amount of liquidity tokens
2217 
2218         uint256 liquidityTokens = (swapBalance * tokensForLiquidity) /
2219             totalTokens /
2220             2;
2221         uint256 amountToSwapForETH = swapBalance - liquidityTokens;
2222 
2223         uint256 initialETHBalance = address(this).balance;
2224 
2225         swapTokensForETH(amountToSwapForETH);
2226 
2227         uint256 ethBalance = address(this).balance - initialETHBalance;
2228 
2229         uint256 ethForDev = (ethBalance * tokensForDev) / totalTokens;
2230 
2231         uint256 ethForLiquidity = (ethBalance * tokensForLiquidity) /
2232             totalTokens;
2233 
2234         uint256 ethForReflections = (ethBalance * tokensForReflections) /
2235             totalTokens;
2236 
2237         (success, ) = address(devWallet).call{value: ethForDev}("");
2238 
2239         if (liquidityTokens > 0 && ethForLiquidity > 0) {
2240             addLiquidity(liquidityTokens, ethForLiquidity);
2241             emit SwapAndLiquify(
2242                 amountToSwapForETH,
2243                 ethForLiquidity,
2244                 tokensForLiquidity
2245             );
2246         }
2247 
2248         swapETHForMRI(ethForReflections);
2249 
2250         uint256 tokenBalance = IERC20(MRI).balanceOf(address(this));
2251         success = IERC20(MRI).transfer(
2252             address(marshelleInuDividendTracker),
2253             tokenBalance
2254         );
2255 
2256         if (success) {
2257             marshelleInuDividendTracker.distributeTokenDividends(tokenBalance);
2258             emit SendDividends(tokenBalance, ethForReflections);
2259         }
2260 
2261         (success, ) = address(marketingWallet).call{
2262             value: address(this).balance
2263         }("");
2264 
2265         contractBalance = balanceOf(address(this));
2266 
2267         tokensForLiquidity =
2268             (contractBalance * sellLiquidityFee) /
2269             sellTotalFees;
2270         tokensForMarketing =
2271             (contractBalance * sellMarketingFee) /
2272             sellTotalFees;
2273         tokensForDev = (contractBalance * sellDevFee) / sellTotalFees;
2274         tokensForReflections =
2275             (contractBalance * sellReflectionsFee) /
2276             sellTotalFees;
2277 
2278         isSwapping = false;
2279     }    
2280 
2281     function manualSwapBack() external onlyOwner{
2282         if(balanceOf(address(this)) > 0 )
2283             swapBack();       
2284     }
2285     
2286 
2287     function claim() external {
2288         marshelleInuDividendTracker.processAccount(payable(msg.sender), false);
2289     }
2290 
2291     /////////////////////////////////////////////////////////////////////////////////////
2292     ///// Setter functions
2293     /////////////////////////////////////////////////////////////////////////////////////
2294 
2295 
2296 
2297     /**
2298      * @dev Change the threshold for making the contract sell and adding liquidity
2299      * @param newThreshold : new
2300      */
2301     function updateSwapTokensAtAmount(uint256 newThreshold)
2302         external
2303         onlyOwner
2304         returns (bool)
2305     {
2306         if (newThreshold < (totalSupply() * 1) / 100000)
2307             revert InvalidSwapTokenAmount(
2308                 "Swap amount cannot be lower than 0.001% total supply."
2309             );
2310     if (newThreshold > (totalSupply() * 1) / 1000)
2311             revert InvalidSwapTokenAmount(
2312                 "Swap amount cannot be higher than 0.1% total supply."
2313             );
2314         swapAndLiquifyThreshold = newThreshold;
2315         return true;
2316     }
2317 
2318     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell)
2319         external
2320         onlyOwner
2321     {
2322         if (newMaxBuy < ((totalSupply() * 5) / 1000) / 1e18)
2323             revert InvalidMaxTradeAmount(
2324                 "Cannot set max buy lower than 0.5%"
2325             );
2326         if (newMaxSell < ((totalSupply() * 5) / 1000) / 1e18)
2327             revert InvalidMaxTradeAmount(
2328                 "Cannot set max sell lower than 0.5%"
2329             );
2330 
2331         maxBuyTxAmount = newMaxBuy * (10**18);
2332         maxSellTxAmount = newMaxSell * (10**18);
2333     }
2334 
2335     function updateMaxWalletAmount(uint256 newMaxWallet) external onlyOwner {
2336         if (newMaxWallet < ((totalSupply() * 5) / 1000) / 1e18)
2337             revert InvalidMaxWalletAmount(
2338                 "Cannot set maxWallet lower than 0.5%"
2339             );
2340         maxWalletAmount = newMaxWallet * (10**18);
2341     }
2342 
2343     function excludeFromMaxWallet(address account, bool isExcluded)
2344         external
2345         onlyOwner
2346     {
2347         _isExcludedFromMaxWallet[account] = isExcluded;
2348         emit ExcludeFromMaxWallet(account, isExcluded);
2349     }
2350 
2351     function excludeFromMaxTrade(address account, bool isExcluded)
2352         external
2353         onlyOwner
2354     {
2355         _isExcludedFromMaxTrade[account] = isExcluded;
2356         emit ExcludeFromMaxTrade(account, isExcluded);
2357     }
2358 
2359     function excludeFromFees(address account, bool isExcluded)
2360         external
2361         onlyOwner
2362     {
2363         _isExcludedFromFees[account] = isExcluded;
2364         emit ExcludeFromFees(account, isExcluded);
2365     }
2366 
2367     function setAutomatedMarketMakerPair(address pair, bool status)
2368         external
2369         onlyOwner
2370     {
2371         automatedMarketMakerPairs[pair] = status;
2372         emit SetAutomatedMarketMakerPair(pair, status);
2373     }
2374 
2375     function updateBuyFees(
2376         uint256 _buyMarketingFee,
2377         uint256 _buyDevFee,
2378         uint256 _buyLiquidityFee,
2379         uint256 _buyReflectionsFee
2380     ) external onlyOwner {
2381         buyMarketingFee = _buyMarketingFee;
2382         buyDevFee = _buyDevFee;
2383         buyLiquidityFee = _buyLiquidityFee;
2384         buyReflectionsFee = _buyReflectionsFee;
2385         buyTotalFees = 
2386             buyMarketingFee +
2387             buyDevFee +
2388             buyLiquidityFee +
2389             buyReflectionsFee;
2390         if (sellTotalFees + buyTotalFees > 25)
2391             revert InvalidTotalFees("Total Fees must be less than 25%");
2392         emit UpdateBuyFees(
2393             buyTotalFees,
2394             buyMarketingFee,
2395             buyDevFee,
2396             buyLiquidityFee,
2397             buyReflectionsFee
2398         );
2399     }
2400 
2401     function updateSellFees(
2402         uint256 _sellMarketingFee,
2403         uint256 _sellDevFee,
2404         uint256 _sellLiquidityFee,
2405         uint256 _sellReflectionsFee
2406     ) external onlyOwner {
2407         sellMarketingFee = _sellMarketingFee;
2408         sellDevFee = _sellDevFee;
2409         sellLiquidityFee = _sellLiquidityFee;
2410         sellReflectionsFee = _sellReflectionsFee;
2411         sellTotalFees =
2412             sellMarketingFee +
2413             sellDevFee +
2414             sellLiquidityFee +
2415             sellReflectionsFee;
2416         if (sellTotalFees + buyTotalFees > 25)
2417             revert InvalidTotalFees("Total Fees must be less than 25%");
2418         emit UpdateSellFees(
2419             sellTotalFees,
2420             sellMarketingFee,
2421             sellDevFee,
2422             sellLiquidityFee,
2423             sellReflectionsFee
2424         );
2425     }
2426 
2427     function setDevWallet (address payable _devWallet) external onlyOwner{
2428         address oldAddress = devWallet;
2429         devWallet = _devWallet;
2430         emit UpdateDevWallet(oldAddress, _devWallet);
2431     }
2432 
2433     function setMarketingWallet(address payable _marketingWallet) external onlyOwner{
2434         address oldAddress = marketingWallet;
2435         marketingWallet = _marketingWallet;
2436         emit UpdateMarketingWallet(oldAddress, _marketingWallet);
2437     }
2438 
2439 
2440     function setSwapAndLiquifyEnabled(
2441         bool _status
2442         ) external onlyOwner {
2443         
2444         swapAndLiquifyEnabled = _status;
2445     }
2446 
2447     /////////////////////////////////////////////////////////////////////////////////////
2448     //// dividend setters
2449     /////////////////////////////////////////////////////////////////////////////////////
2450 
2451     function processDividendTracker(uint256 gas) external {
2452         (
2453             uint256 iterations,
2454             uint256 claims,
2455             uint256 lastProcessedIndex
2456         ) = marshelleInuDividendTracker.process(gas);
2457         emit ProcessedDividendTracker(
2458             iterations,
2459             claims,
2460             lastProcessedIndex,
2461             false,
2462             gas,
2463             tx.origin
2464         );
2465     }
2466 
2467     function updateDividendAddress(address newDividendAddress)
2468         external
2469         onlyOwner
2470     {
2471         address oldAddress = MRI;
2472         MRI = newDividendAddress;
2473         marshelleInuDividendTracker.setDividendTokenAddress(newDividendAddress);
2474         emit UpdateDividendToken(oldAddress, MRI);
2475     }
2476 
2477     function updateDividendInclusion(address account, bool isIncluded) external onlyOwner {
2478         if(isIncluded){
2479             marshelleInuDividendTracker.includeInDividends(account);
2480             emit IncludeInDividends(account);
2481         } else{
2482             marshelleInuDividendTracker.excludeFromDividends(account);
2483             emit ExcludeFromDividends(account);
2484         }
2485     }
2486 
2487     /////////////////////////////////////////////////////////////////////////////////////
2488     ///// Getter functions
2489     /////////////////////////////////////////////////////////////////////////////////////
2490 
2491     function getLastProcessedIndex() external view returns (uint256) {
2492         return marshelleInuDividendTracker.getLastProcessedIndex();
2493     }
2494 
2495     function getNumberOfMarshelleDividendTokenHolders()
2496         external
2497         view
2498         returns (uint256)
2499     {
2500         return marshelleInuDividendTracker.getNumberOfTokenHolders();
2501     }
2502 
2503     function getNumberOfMarshelleDividends() external view returns (uint256) {
2504         return marshelleInuDividendTracker.totalSupply();
2505     }
2506 
2507     function getClaimWait() external view returns (uint256) {
2508         return marshelleInuDividendTracker.claimWait();
2509     }
2510 
2511     function getTotalMarshelleDividendsDistributed()
2512         external
2513         view
2514         returns (uint256)
2515     {
2516         return marshelleInuDividendTracker.totalDividendsDistributed();
2517     }
2518 
2519     function withdrawableMarshelleDividendOf(address account)
2520         public
2521         view
2522         returns (uint256)
2523     {
2524         return marshelleInuDividendTracker.withdrawableDividendOf(account);
2525     }
2526 
2527     function marshelleInuDividendTokenBalanceOf(address account)
2528         public
2529         view
2530         returns (uint256)
2531     {
2532         return marshelleInuDividendTracker.balanceOf(account);
2533     }
2534 
2535     function getAccountMarshelleDividendsInfo(address account)
2536         external
2537         view
2538         returns (
2539             address,
2540             int256,
2541             int256,
2542             uint256,
2543             uint256,
2544             uint256,
2545             uint256,
2546             uint256
2547         )
2548     {
2549         return marshelleInuDividendTracker.getAccount(account);
2550     }
2551 
2552     function getAccountMarshelleDividendsInfoAtIndex(uint256 index)
2553         external
2554         view
2555         returns (
2556             address,
2557             int256,
2558             int256,
2559             uint256,
2560             uint256,
2561             uint256,
2562             uint256,
2563             uint256
2564         )
2565     {
2566         return marshelleInuDividendTracker.getAccountAtIndex(index);
2567     }
2568 
2569     function getBuyFees()
2570         external
2571         view
2572         returns (
2573             uint256 _buyMarketingFee,
2574             uint256 _buyDevFee,
2575             uint256 _buyLiquidityFee,
2576             uint256 _buyReflectionsFee
2577         )
2578     {
2579         return (buyMarketingFee, 
2580                 buyDevFee, 
2581                 buyLiquidityFee, 
2582                 buyReflectionsFee);
2583     }
2584 
2585     function getSellFees()
2586         external
2587         view
2588         returns (
2589             uint256 _sellMarketingFee,
2590             uint256 _sellDevFee,
2591             uint256 _sellLiquidityFee,
2592             uint256 _sellReflectionFee
2593         )
2594     {
2595         return (
2596             sellMarketingFee,
2597             sellDevFee,
2598             sellLiquidityFee,
2599             sellReflectionsFee
2600         );
2601     }
2602 }