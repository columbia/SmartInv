1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 library SafeMathUint {
5     function toInt256Safe(uint256 a) internal pure returns (int256) {
6         int256 b = int256(a);
7         require(b >= 0);
8         return b;
9     }
10 }
11 
12 library SafeMathInt {
13     int256 private constant MIN_INT256 = int256(1) << 255;
14     int256 private constant MAX_INT256 = ~(int256(1) << 255);
15 
16     /**
17      * @dev Multiplies two int256 variables and fails on overflow.
18      */
19     function mul(int256 a, int256 b) internal pure returns (int256) {
20         int256 c = a * b;
21 
22         // Detect overflow when multiplying MIN_INT256 with -1
23         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
24         require((b == 0) || (c / b == a));
25         return c;
26     }
27 
28     /**
29      * @dev Division of two int256 variables and fails on overflow.
30      */
31     function div(int256 a, int256 b) internal pure returns (int256) {
32         // Prevent overflow when dividing MIN_INT256 by -1
33         require(b != -1 || a != MIN_INT256);
34 
35         // Solidity already throws when dividing by 0.
36         return a / b;
37     }
38 
39     /**
40      * @dev Subtracts two int256 variables and fails on overflow.
41      */
42     function sub(int256 a, int256 b) internal pure returns (int256) {
43         int256 c = a - b;
44         require((b >= 0 && c <= a) || (b < 0 && c > a));
45         return c;
46     }
47 
48     /**
49      * @dev Adds two int256 variables and fails on overflow.
50      */
51     function add(int256 a, int256 b) internal pure returns (int256) {
52         int256 c = a + b;
53         require((b >= 0 && c >= a) || (b < 0 && c < a));
54         return c;
55     }
56 
57     /**
58      * @dev Converts to absolute value, and fails on overflow.
59      */
60     function abs(int256 a) internal pure returns (int256) {
61         require(a != MIN_INT256);
62         return a < 0 ? -a : a;
63     }
64 
65     function toUint256Safe(int256 a) internal pure returns (uint256) {
66         require(a >= 0);
67         return uint256(a);
68     }
69 }
70 
71 library SafeMath {
72     /**
73      * @dev Returns the addition of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `+` operator.
77      *
78      * Requirements:
79      *
80      * - Addition cannot overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the subtraction of two unsigned integers, reverting on
91      * overflow (when the result is negative).
92      *
93      * Counterpart to Solidity's `-` operator.
94      *
95      * Requirements:
96      *
97      * - Subtraction cannot overflow.
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         return sub(a, b, "SafeMath: subtraction overflow");
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      *
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         return div(a, b, "SafeMath: division by zero");
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         require(b > 0, errorMessage);
182         uint256 c = a / b;
183         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
190      * Reverts when dividing by zero.
191      *
192      * Counterpart to Solidity's `%` operator. This function uses a `revert`
193      * opcode (which leaves remaining gas untouched) while Solidity uses an
194      * invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
201         return mod(a, b, "SafeMath: modulo by zero");
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts with custom message when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         require(b != 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 library IterableMapping {
227     // Iterable mapping from address to uint;
228     struct Map {
229         address[] keys;
230         mapping(address => uint256) values;
231         mapping(address => uint256) indexOf;
232         mapping(address => bool) inserted;
233     }
234 
235     function get(Map storage map, address key) public view returns (uint256) {
236         return map.values[key];
237     }
238 
239     function getIndexOfKey(Map storage map, address key)
240         public
241         view
242         returns (int256)
243     {
244         if (!map.inserted[key]) {
245             return -1;
246         }
247         return int256(map.indexOf[key]);
248     }
249 
250     function getKeyAtIndex(Map storage map, uint256 index)
251         public
252         view
253         returns (address)
254     {
255         return map.keys[index];
256     }
257 
258     function size(Map storage map) public view returns (uint256) {
259         return map.keys.length;
260     }
261 
262     function set(
263         Map storage map,
264         address key,
265         uint256 val
266     ) public {
267         if (map.inserted[key]) {
268             map.values[key] = val;
269         } else {
270             map.inserted[key] = true;
271             map.values[key] = val;
272             map.indexOf[key] = map.keys.length;
273             map.keys.push(key);
274         }
275     }
276 
277     function remove(Map storage map, address key) public {
278         if (!map.inserted[key]) {
279             return;
280         }
281 
282         delete map.inserted[key];
283         delete map.values[key];
284 
285         uint256 index = map.indexOf[key];
286         uint256 lastIndex = map.keys.length - 1;
287         address lastKey = map.keys[lastIndex];
288 
289         map.indexOf[lastKey] = index;
290         delete map.indexOf[key];
291 
292         map.keys[index] = lastKey;
293         map.keys.pop();
294     }
295 }
296 
297 interface IFTPAntiBot {
298     // Here we create the interface to interact with AntiBot
299     function scanAddress(
300         address _address,
301         address _safeAddress,
302         address _origin
303     ) external returns (bool);
304 
305     function registerBlock(address _recipient, address _sender) external;
306 }
307 
308 interface IUniswapV2Router01 {
309     function factory() external pure returns (address);
310 
311     function WETH() external pure returns (address);
312 
313     function addLiquidity(
314         address tokenA,
315         address tokenB,
316         uint256 amountADesired,
317         uint256 amountBDesired,
318         uint256 amountAMin,
319         uint256 amountBMin,
320         address to,
321         uint256 deadline
322     )
323         external
324         returns (
325             uint256 amountA,
326             uint256 amountB,
327             uint256 liquidity
328         );
329 
330     function addLiquidityETH(
331         address token,
332         uint256 amountTokenDesired,
333         uint256 amountTokenMin,
334         uint256 amountETHMin,
335         address to,
336         uint256 deadline
337     )
338         external
339         payable
340         returns (
341             uint256 amountToken,
342             uint256 amountETH,
343             uint256 liquidity
344         );
345 
346     function removeLiquidity(
347         address tokenA,
348         address tokenB,
349         uint256 liquidity,
350         uint256 amountAMin,
351         uint256 amountBMin,
352         address to,
353         uint256 deadline
354     ) external returns (uint256 amountA, uint256 amountB);
355 
356     function removeLiquidityETH(
357         address token,
358         uint256 liquidity,
359         uint256 amountTokenMin,
360         uint256 amountETHMin,
361         address to,
362         uint256 deadline
363     ) external returns (uint256 amountToken, uint256 amountETH);
364 
365     function removeLiquidityWithPermit(
366         address tokenA,
367         address tokenB,
368         uint256 liquidity,
369         uint256 amountAMin,
370         uint256 amountBMin,
371         address to,
372         uint256 deadline,
373         bool approveMax,
374         uint8 v,
375         bytes32 r,
376         bytes32 s
377     ) external returns (uint256 amountA, uint256 amountB);
378 
379     function removeLiquidityETHWithPermit(
380         address token,
381         uint256 liquidity,
382         uint256 amountTokenMin,
383         uint256 amountETHMin,
384         address to,
385         uint256 deadline,
386         bool approveMax,
387         uint8 v,
388         bytes32 r,
389         bytes32 s
390     ) external returns (uint256 amountToken, uint256 amountETH);
391 
392     function swapExactTokensForTokens(
393         uint256 amountIn,
394         uint256 amountOutMin,
395         address[] calldata path,
396         address to,
397         uint256 deadline
398     ) external returns (uint256[] memory amounts);
399 
400     function swapTokensForExactTokens(
401         uint256 amountOut,
402         uint256 amountInMax,
403         address[] calldata path,
404         address to,
405         uint256 deadline
406     ) external returns (uint256[] memory amounts);
407 
408     function swapExactETHForTokens(
409         uint256 amountOutMin,
410         address[] calldata path,
411         address to,
412         uint256 deadline
413     ) external payable returns (uint256[] memory amounts);
414 
415     function swapTokensForExactETH(
416         uint256 amountOut,
417         uint256 amountInMax,
418         address[] calldata path,
419         address to,
420         uint256 deadline
421     ) external returns (uint256[] memory amounts);
422 
423     function swapExactTokensForETH(
424         uint256 amountIn,
425         uint256 amountOutMin,
426         address[] calldata path,
427         address to,
428         uint256 deadline
429     ) external returns (uint256[] memory amounts);
430 
431     function swapETHForExactTokens(
432         uint256 amountOut,
433         address[] calldata path,
434         address to,
435         uint256 deadline
436     ) external payable returns (uint256[] memory amounts);
437 
438     function quote(
439         uint256 amountA,
440         uint256 reserveA,
441         uint256 reserveB
442     ) external pure returns (uint256 amountB);
443 
444     function getAmountOut(
445         uint256 amountIn,
446         uint256 reserveIn,
447         uint256 reserveOut
448     ) external pure returns (uint256 amountOut);
449 
450     function getAmountIn(
451         uint256 amountOut,
452         uint256 reserveIn,
453         uint256 reserveOut
454     ) external pure returns (uint256 amountIn);
455 
456     function getAmountsOut(uint256 amountIn, address[] calldata path)
457         external
458         view
459         returns (uint256[] memory amounts);
460 
461     function getAmountsIn(uint256 amountOut, address[] calldata path)
462         external
463         view
464         returns (uint256[] memory amounts);
465 }
466 
467 interface IUniswapV2Router02 is IUniswapV2Router01 {
468     function removeLiquidityETHSupportingFeeOnTransferTokens(
469         address token,
470         uint256 liquidity,
471         uint256 amountTokenMin,
472         uint256 amountETHMin,
473         address to,
474         uint256 deadline
475     ) external returns (uint256 amountETH);
476 
477     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
478         address token,
479         uint256 liquidity,
480         uint256 amountTokenMin,
481         uint256 amountETHMin,
482         address to,
483         uint256 deadline,
484         bool approveMax,
485         uint8 v,
486         bytes32 r,
487         bytes32 s
488     ) external returns (uint256 amountETH);
489 
490     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
491         uint256 amountIn,
492         uint256 amountOutMin,
493         address[] calldata path,
494         address to,
495         uint256 deadline
496     ) external;
497 
498     function swapExactETHForTokensSupportingFeeOnTransferTokens(
499         uint256 amountOutMin,
500         address[] calldata path,
501         address to,
502         uint256 deadline
503     ) external payable;
504 
505     function swapExactTokensForETHSupportingFeeOnTransferTokens(
506         uint256 amountIn,
507         uint256 amountOutMin,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external;
512 }
513 
514 interface IUniswapV2Factory {
515     event PairCreated(
516         address indexed token0,
517         address indexed token1,
518         address pair,
519         uint256
520     );
521 
522     function feeTo() external view returns (address);
523 
524     function feeToSetter() external view returns (address);
525 
526     function getPair(address tokenA, address tokenB)
527         external
528         view
529         returns (address pair);
530 
531     function allPairs(uint256) external view returns (address pair);
532 
533     function allPairsLength() external view returns (uint256);
534 
535     function createPair(address tokenA, address tokenB)
536         external
537         returns (address pair);
538 
539     function setFeeTo(address) external;
540 
541     function setFeeToSetter(address) external;
542 }
543 
544 interface IUniswapV2Pair {
545     event Approval(
546         address indexed owner,
547         address indexed spender,
548         uint256 value
549     );
550     event Transfer(address indexed from, address indexed to, uint256 value);
551 
552     function name() external pure returns (string memory);
553 
554     function symbol() external pure returns (string memory);
555 
556     function decimals() external pure returns (uint8);
557 
558     function totalSupply() external view returns (uint256);
559 
560     function balanceOf(address owner) external view returns (uint256);
561 
562     function allowance(address owner, address spender)
563         external
564         view
565         returns (uint256);
566 
567     function approve(address spender, uint256 value) external returns (bool);
568 
569     function transfer(address to, uint256 value) external returns (bool);
570 
571     function transferFrom(
572         address from,
573         address to,
574         uint256 value
575     ) external returns (bool);
576 
577     function DOMAIN_SEPARATOR() external view returns (bytes32);
578 
579     function PERMIT_TYPEHASH() external pure returns (bytes32);
580 
581     function nonces(address owner) external view returns (uint256);
582 
583     function permit(
584         address owner,
585         address spender,
586         uint256 value,
587         uint256 deadline,
588         uint8 v,
589         bytes32 r,
590         bytes32 s
591     ) external;
592 
593     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
594     event Burn(
595         address indexed sender,
596         uint256 amount0,
597         uint256 amount1,
598         address indexed to
599     );
600     event Swap(
601         address indexed sender,
602         uint256 amount0In,
603         uint256 amount1In,
604         uint256 amount0Out,
605         uint256 amount1Out,
606         address indexed to
607     );
608     event Sync(uint112 reserve0, uint112 reserve1);
609 
610     function MINIMUM_LIQUIDITY() external pure returns (uint256);
611 
612     function factory() external view returns (address);
613 
614     function token0() external view returns (address);
615 
616     function token1() external view returns (address);
617 
618     function getReserves()
619         external
620         view
621         returns (
622             uint112 reserve0,
623             uint112 reserve1,
624             uint32 blockTimestampLast
625         );
626 
627     function price0CumulativeLast() external view returns (uint256);
628 
629     function price1CumulativeLast() external view returns (uint256);
630 
631     function kLast() external view returns (uint256);
632 
633     function mint(address to) external returns (uint256 liquidity);
634 
635     function burn(address to)
636         external
637         returns (uint256 amount0, uint256 amount1);
638 
639     function swap(
640         uint256 amount0Out,
641         uint256 amount1Out,
642         address to,
643         bytes calldata data
644     ) external;
645 
646     function skim(address to) external;
647 
648     function sync() external;
649 
650     function initialize(address, address) external;
651 }
652 
653 interface DividendPayingTokenInterface {
654     /// @notice View the amount of dividend in wei that an address can withdraw.
655     /// @param _owner The address of a token holder.
656     /// @return The amount of dividend in wei that `_owner` can withdraw.
657     function dividendOf(address _owner) external view returns (uint256);
658 
659     /// @notice Distributes ether to token holders as dividends.
660     /// @dev SHOULD distribute the paid ether to token holders as dividends.
661     ///  SHOULD NOT directly transfer ether to token holders in this function.
662     ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
663     function distributeDividends() external payable;
664 
665     /// @notice Withdraws the ether distributed to the sender.
666     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
667     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
668     function withdrawDividend() external;
669 
670     /// @dev This event MUST emit when ether is distributed to token holders.
671     /// @param from The address which sends ether to this contract.
672     /// @param weiAmount The amount of distributed ether in wei.
673     event DividendsDistributed(address indexed from, uint256 weiAmount);
674 
675     /// @dev This event MUST emit when an address withdraws their dividend.
676     /// @param to The address which withdraws ether from this contract.
677     /// @param weiAmount The amount of withdrawn ether in wei.
678     event DividendWithdrawn(
679         address indexed to,
680         uint256 weiAmount,
681         address received
682     );
683 }
684 
685 interface DividendPayingTokenOptionalInterface {
686     /// @notice View the amount of dividend in wei that an address can withdraw.
687     /// @param _owner The address of a token holder.
688     /// @return The amount of dividend in wei that `_owner` can withdraw.
689     function withdrawableDividendOf(address _owner)
690         external
691         view
692         returns (uint256);
693 
694     /// @notice View the amount of dividend in wei that an address has withdrawn.
695     /// @param _owner The address of a token holder.
696     /// @return The amount of dividend in wei that `_owner` has withdrawn.
697     function withdrawnDividendOf(address _owner)
698         external
699         view
700         returns (uint256);
701 
702     /// @notice View the amount of dividend in wei that an address has earned in total.
703     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
704     /// @param _owner The address of a token holder.
705     /// @return The amount of dividend in wei that `_owner` has earned in total.
706     function accumulativeDividendOf(address _owner)
707         external
708         view
709         returns (uint256);
710 }
711 
712 interface IERC20 {
713     /**
714      * @dev Returns the amount of tokens in existence.
715      */
716     function totalSupply() external view returns (uint256);
717 
718     /**
719      * @dev Returns the amount of tokens owned by `account`.
720      */
721     function balanceOf(address account) external view returns (uint256);
722 
723     /**
724      * @dev Moves `amount` tokens from the caller's account to `recipient`.
725      *
726      * Returns a boolean value indicating whether the operation succeeded.
727      *
728      * Emits a {Transfer} event.
729      */
730     function transfer(address recipient, uint256 amount)
731         external
732         returns (bool);
733 
734     /**
735      * @dev Returns the remaining number of tokens that `spender` will be
736      * allowed to spend on behalf of `owner` through {transferFrom}. This is
737      * zero by default.
738      *
739      * This value changes when {approve} or {transferFrom} are called.
740      */
741     function allowance(address owner, address spender)
742         external
743         view
744         returns (uint256);
745 
746     /**
747      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
748      *
749      * Returns a boolean value indicating whether the operation succeeded.
750      *
751      * IMPORTANT: Beware that changing an allowance with this method brings the risk
752      * that someone may use both the old and the new allowance by unfortunate
753      * transaction ordering. One possible solution to mitigate this race
754      * condition is to first reduce the spender's allowance to 0 and set the
755      * desired value afterwards:
756      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
757      *
758      * Emits an {Approval} event.
759      */
760     function approve(address spender, uint256 amount) external returns (bool);
761 
762     /**
763      * @dev Moves `amount` tokens from `sender` to `recipient` using the
764      * allowance mechanism. `amount` is then deducted from the caller's
765      * allowance.
766      *
767      * Returns a boolean value indicating whether the operation succeeded.
768      *
769      * Emits a {Transfer} event.
770      */
771     function transferFrom(
772         address sender,
773         address recipient,
774         uint256 amount
775     ) external returns (bool);
776 
777     /**
778      * @dev Emitted when `value` tokens are moved from one account (`from`) to
779      * another (`to`).
780      *
781      * Note that `value` may be zero.
782      */
783     event Transfer(address indexed from, address indexed to, uint256 value);
784 
785     /**
786      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
787      * a call to {approve}. `value` is the new allowance.
788      */
789     event Approval(
790         address indexed owner,
791         address indexed spender,
792         uint256 value
793     );
794 }
795 
796 interface IERC20Metadata is IERC20 {
797     /**
798      * @dev Returns the name of the token.
799      */
800     function name() external view returns (string memory);
801 
802     /**
803      * @dev Returns the symbol of the token.
804      */
805     function symbol() external view returns (string memory);
806 
807     /**
808      * @dev Returns the decimals places of the token.
809      */
810     function decimals() external view returns (uint8);
811 }
812 
813 abstract contract Context {
814     function _msgSender() internal view virtual returns (address) {
815         return msg.sender;
816     }
817 }
818 
819 contract Ownable is Context {
820     address private _owner;
821 
822     event OwnershipTransferred(
823         address indexed previousOwner,
824         address indexed newOwner
825     );
826 
827     /**
828      * @dev Initializes the contract setting the deployer as the initial owner.
829      */
830     constructor() public {
831         address msgSender = _msgSender();
832         _owner = msgSender;
833         emit OwnershipTransferred(address(0), msgSender);
834     }
835 
836     /**
837      * @dev Returns the address of the current owner.
838      */
839     function owner() public view returns (address) {
840         return _owner;
841     }
842 
843     /**
844      * @dev Throws if called by any account other than the owner.
845      */
846     modifier onlyOwner() {
847         require(_owner == _msgSender(), "Ownable: caller is not the owner");
848         _;
849     }
850 
851     /**
852      * @dev Leaves the contract without owner. It will not be possible to call
853      * `onlyOwner` functions anymore. Can only be called by the current owner.
854      *
855      * NOTE: Renouncing ownership will leave the contract without an owner,
856      * thereby removing any functionality that is only available to the owner.
857      */
858     function renounceOwnership() public virtual onlyOwner {
859         emit OwnershipTransferred(_owner, address(0));
860         _owner = address(0);
861     }
862 
863     /**
864      * @dev Transfers ownership of the contract to a new account (`newOwner`).
865      * Can only be called by the current owner.
866      */
867     function transferOwnership(address newOwner) public virtual onlyOwner {
868         require(
869             newOwner != address(0),
870             "Ownable: new owner is the zero address"
871         );
872         emit OwnershipTransferred(_owner, newOwner);
873         _owner = newOwner;
874     }
875 }
876 
877 contract ERC20 is Context, IERC20, IERC20Metadata {
878     using SafeMath for uint256;
879 
880     mapping(address => uint256) private _balances;
881 
882     mapping(address => mapping(address => uint256)) private _allowances;
883 
884     uint256 private _totalSupply;
885 
886     string private _name;
887     string private _symbol;
888 
889     /**
890      * @dev Sets the values for {name} and {symbol}.
891      *
892      * The default value of {decimals} is 18. To select a different value for
893      * {decimals} you should overload it.
894      *
895      * All two of these values are immutable: they can only be set once during
896      * construction.
897      */
898     constructor(string memory name_, string memory symbol_) public {
899         _name = name_;
900         _symbol = symbol_;
901     }
902 
903     /**
904      * @dev Returns the name of the token.
905      */
906     function name() public view virtual override returns (string memory) {
907         return _name;
908     }
909 
910     /**
911      * @dev Returns the symbol of the token, usually a shorter version of the
912      * name.
913      */
914     function symbol() public view virtual override returns (string memory) {
915         return _symbol;
916     }
917 
918     /**
919      * @dev Returns the number of decimals used to get its user representation.
920      * For example, if `decimals` equals `2`, a balance of `505` tokens should
921      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
922      *
923      * Tokens usually opt for a value of 18, imitating the relationship between
924      * Ether and Wei. This is the value {ERC20} uses, unless this function is
925      * overridden;
926      *
927      * NOTE: This information is only used for _display_ purposes: it in
928      * no way affects any of the arithmetic of the contract, including
929      * {IERC20-balanceOf} and {IERC20-transfer}.
930      */
931     function decimals() public view virtual override returns (uint8) {
932         return 18;
933     }
934 
935     /**
936      * @dev See {IERC20-totalSupply}.
937      */
938     function totalSupply() public view virtual override returns (uint256) {
939         return _totalSupply;
940     }
941 
942     /**
943      * @dev See {IERC20-balanceOf}.
944      */
945     function balanceOf(address account)
946         public
947         view
948         virtual
949         override
950         returns (uint256)
951     {
952         return _balances[account];
953     }
954 
955     /**
956      * @dev See {IERC20-transfer}.
957      *
958      * Requirements:
959      *
960      * - `recipient` cannot be the zero address.
961      * - the caller must have a balance of at least `amount`.
962      */
963     function transfer(address recipient, uint256 amount)
964         public
965         virtual
966         override
967         returns (bool)
968     {
969         _transfer(_msgSender(), recipient, amount);
970         return true;
971     }
972 
973     /**
974      * @dev See {IERC20-allowance}.
975      */
976     function allowance(address owner, address spender)
977         public
978         view
979         virtual
980         override
981         returns (uint256)
982     {
983         return _allowances[owner][spender];
984     }
985 
986     /**
987      * @dev See {IERC20-approve}.
988      *
989      * Requirements:
990      *
991      * - `spender` cannot be the zero address.
992      */
993     function approve(address spender, uint256 amount)
994         public
995         virtual
996         override
997         returns (bool)
998     {
999         _approve(_msgSender(), spender, amount);
1000         return true;
1001     }
1002 
1003     /**
1004      * @dev See {IERC20-transferFrom}.
1005      *
1006      * Emits an {Approval} event indicating the updated allowance. This is not
1007      * required by the EIP. See the note at the beginning of {ERC20}.
1008      *
1009      * Requirements:
1010      *
1011      * - `sender` and `recipient` cannot be the zero address.
1012      * - `sender` must have a balance of at least `amount`.
1013      * - the caller must have allowance for ``sender``'s tokens of at least
1014      * `amount`.
1015      */
1016     function transferFrom(
1017         address sender,
1018         address recipient,
1019         uint256 amount
1020     ) public virtual override returns (bool) {
1021         _transfer(sender, recipient, amount);
1022         _approve(
1023             sender,
1024             _msgSender(),
1025             _allowances[sender][_msgSender()].sub(
1026                 amount,
1027                 "ERC20: transfer amount exceeds allowance"
1028             )
1029         );
1030         return true;
1031     }
1032 
1033     /**
1034      * @dev Atomically increases the allowance granted to `spender` by the caller.
1035      *
1036      * This is an alternative to {approve} that can be used as a mitigation for
1037      * problems described in {IERC20-approve}.
1038      *
1039      * Emits an {Approval} event indicating the updated allowance.
1040      *
1041      * Requirements:
1042      *
1043      * - `spender` cannot be the zero address.
1044      */
1045     function increaseAllowance(address spender, uint256 addedValue)
1046         public
1047         virtual
1048         returns (bool)
1049     {
1050         _approve(
1051             _msgSender(),
1052             spender,
1053             _allowances[_msgSender()][spender].add(addedValue)
1054         );
1055         return true;
1056     }
1057 
1058     /**
1059      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1060      *
1061      * This is an alternative to {approve} that can be used as a mitigation for
1062      * problems described in {IERC20-approve}.
1063      *
1064      * Emits an {Approval} event indicating the updated allowance.
1065      *
1066      * Requirements:
1067      *
1068      * - `spender` cannot be the zero address.
1069      * - `spender` must have allowance for the caller of at least
1070      * `subtractedValue`.
1071      */
1072     function decreaseAllowance(address spender, uint256 subtractedValue)
1073         public
1074         virtual
1075         returns (bool)
1076     {
1077         _approve(
1078             _msgSender(),
1079             spender,
1080             _allowances[_msgSender()][spender].sub(
1081                 subtractedValue,
1082                 "ERC20: decreased allowance below zero"
1083             )
1084         );
1085         return true;
1086     }
1087 
1088     /**
1089      * @dev Moves tokens `amount` from `sender` to `recipient`.
1090      *
1091      * This is internal function is equivalent to {transfer}, and can be used to
1092      * e.g. implement automatic token fees, slashing mechanisms, etc.
1093      *
1094      * Emits a {Transfer} event.
1095      *
1096      * Requirements:
1097      *
1098      * - `sender` cannot be the zero address.
1099      * - `recipient` cannot be the zero address.
1100      * - `sender` must have a balance of at least `amount`.
1101      */
1102     function _transfer(
1103         address sender,
1104         address recipient,
1105         uint256 amount
1106     ) internal virtual {
1107         require(sender != address(0), "ERC20: transfer from the zero address");
1108         require(recipient != address(0), "ERC20: transfer to the zero address");
1109 
1110         _beforeTokenTransfer(sender, recipient, amount);
1111 
1112         _balances[sender] = _balances[sender].sub(
1113             amount,
1114             "ERC20: transfer amount exceeds balance"
1115         );
1116         _balances[recipient] = _balances[recipient].add(amount);
1117         emit Transfer(sender, recipient, amount);
1118     }
1119 
1120     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1121      * the total supply.
1122      *
1123      * Emits a {Transfer} event with `from` set to the zero address.
1124      *
1125      * Requirements:
1126      *
1127      * - `account` cannot be the zero address.
1128      */
1129     function _mint(address account, uint256 amount) internal virtual {
1130         require(account != address(0), "ERC20: mint to the zero address");
1131 
1132         _beforeTokenTransfer(address(0), account, amount);
1133 
1134         _totalSupply = _totalSupply.add(amount);
1135         _balances[account] = _balances[account].add(amount);
1136         emit Transfer(address(0), account, amount);
1137     }
1138 
1139     /**
1140      * @dev Destroys `amount` tokens from `account`, reducing the
1141      * total supply.
1142      *
1143      * Emits a {Transfer} event with `to` set to the zero address.
1144      *
1145      * Requirements:
1146      *
1147      * - `account` cannot be the zero address.
1148      * - `account` must have at least `amount` tokens.
1149      */
1150     function _burn(address account, uint256 amount) internal virtual {
1151         require(account != address(0), "ERC20: burn from the zero address");
1152 
1153         _beforeTokenTransfer(account, address(0), amount);
1154 
1155         _balances[account] = _balances[account].sub(
1156             amount,
1157             "ERC20: burn amount exceeds balance"
1158         );
1159         _totalSupply = _totalSupply.sub(amount);
1160         emit Transfer(account, address(0), amount);
1161     }
1162 
1163     /**
1164      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1165      *
1166      * This internal function is equivalent to `approve`, and can be used to
1167      * e.g. set automatic allowances for certain subsystems, etc.
1168      *
1169      * Emits an {Approval} event.
1170      *
1171      * Requirements:
1172      *
1173      * - `owner` cannot be the zero address.
1174      * - `spender` cannot be the zero address.
1175      */
1176     function _approve(
1177         address owner,
1178         address spender,
1179         uint256 amount
1180     ) internal virtual {
1181         require(owner != address(0), "ERC20: approve from the zero address");
1182         require(spender != address(0), "ERC20: approve to the zero address");
1183 
1184         _allowances[owner][spender] = amount;
1185         emit Approval(owner, spender, amount);
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before any transfer of tokens. This includes
1190      * minting and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1195      * will be to transferred to `to`.
1196      * - when `from` is zero, `amount` tokens will be minted for `to`.
1197      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1198      * - `from` and `to` are never both zero.
1199      *
1200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1201      */
1202     function _beforeTokenTransfer(
1203         address from,
1204         address to,
1205         uint256 amount
1206     ) internal virtual {}
1207 }
1208 
1209 contract DividendPayingToken is
1210     ERC20,
1211     DividendPayingTokenInterface,
1212     DividendPayingTokenOptionalInterface
1213 {
1214     using SafeMath for uint256;
1215     using SafeMathUint for uint256;
1216     using SafeMathInt for int256;
1217 
1218     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1219     // For more discussion about choosing the value of `magnitude`,
1220     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1221     uint256 internal constant magnitude = 2**128;
1222 
1223     uint256 internal magnifiedDividendPerShare;
1224 
1225     // About dividendCorrection:
1226     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1227     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1228     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1229     //   `dividendOf(_user)` should not be changed,
1230     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1231     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1232     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1233     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1234     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1235     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1236     mapping(address => int256) internal magnifiedDividendCorrections;
1237     mapping(address => uint256) internal withdrawnDividends;
1238 
1239     uint256 public totalDividendsDistributed;
1240 
1241     constructor(string memory _name, string memory _symbol)
1242         public
1243         ERC20(_name, _symbol)
1244     {}
1245 
1246     /// @dev Distributes dividends whenever ether is paid to this contract.
1247     receive() external payable {
1248         distributeDividends();
1249     }
1250 
1251     /// @notice Distributes ether to token holders as dividends.
1252     /// @dev It reverts if the total supply of tokens is 0.
1253     /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1254     /// About undistributed ether:
1255     ///   In each distribution, there is a small amount of ether not distributed,
1256     ///     the magnified amount of which is
1257     ///     `(msg.value * magnitude) % totalSupply()`.
1258     ///   With a well-chosen `magnitude`, the amount of undistributed ether
1259     ///     (de-magnified) in a distribution can be less than 1 wei.
1260     ///   We can actually keep track of the undistributed ether in a distribution
1261     ///     and try to distribute it in the next distribution,
1262     ///     but keeping track of such data on-chain costs much more than
1263     ///     the saved ether, so we don't do that.
1264     function distributeDividends() public payable override {
1265         require(totalSupply() > 0);
1266 
1267         if (msg.value > 0) {
1268             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1269                 (msg.value).mul(magnitude) / totalSupply()
1270             );
1271             emit DividendsDistributed(msg.sender, msg.value);
1272 
1273             totalDividendsDistributed = totalDividendsDistributed.add(
1274                 msg.value
1275             );
1276         }
1277     }
1278 
1279     /// @notice Withdraws the ether distributed to the sender.
1280     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1281     function withdrawDividend() public virtual override {
1282         _withdrawDividendOfUser(msg.sender, msg.sender);
1283     }
1284 
1285     /// @notice Withdraws the ether distributed to the sender.
1286     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1287     function _withdrawDividendOfUser(address payable user, address payable to)
1288         internal
1289         returns (uint256)
1290     {
1291         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1292         if (_withdrawableDividend > 0) {
1293             withdrawnDividends[user] = withdrawnDividends[user].add(
1294                 _withdrawableDividend
1295             );
1296             emit DividendWithdrawn(user, _withdrawableDividend, to);
1297             (bool success, ) = to.call{value: _withdrawableDividend}("");
1298 
1299             if (!success) {
1300                 withdrawnDividends[user] = withdrawnDividends[user].sub(
1301                     _withdrawableDividend
1302                 );
1303                 return 0;
1304             }
1305 
1306             return _withdrawableDividend;
1307         }
1308 
1309         return 0;
1310     }
1311 
1312     /// @notice View the amount of dividend in wei that an address can withdraw.
1313     /// @param _owner The address of a token holder.
1314     /// @return The amount of dividend in wei that `_owner` can withdraw.
1315     function dividendOf(address _owner) public view override returns (uint256) {
1316         return withdrawableDividendOf(_owner);
1317     }
1318 
1319     /// @notice View the amount of dividend in wei that an address can withdraw.
1320     /// @param _owner The address of a token holder.
1321     /// @return The amount of dividend in wei that `_owner` can withdraw.
1322     function withdrawableDividendOf(address _owner)
1323         public
1324         view
1325         override
1326         returns (uint256)
1327     {
1328         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1329     }
1330 
1331     /// @notice View the amount of dividend in wei that an address has withdrawn.
1332     /// @param _owner The address of a token holder.
1333     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1334     function withdrawnDividendOf(address _owner)
1335         public
1336         view
1337         override
1338         returns (uint256)
1339     {
1340         return withdrawnDividends[_owner];
1341     }
1342 
1343     /// @notice View the amount of dividend in wei that an address has earned in total.
1344     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1345     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1346     /// @param _owner The address of a token holder.
1347     /// @return The amount of dividend in wei that `_owner` has earned in total.
1348     function accumulativeDividendOf(address _owner)
1349         public
1350         view
1351         override
1352         returns (uint256)
1353     {
1354         return
1355             magnifiedDividendPerShare
1356                 .mul(balanceOf(_owner))
1357                 .toInt256Safe()
1358                 .add(magnifiedDividendCorrections[_owner])
1359                 .toUint256Safe() / magnitude;
1360     }
1361 
1362     /// @dev Internal function that mints tokens to an account.
1363     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1364     /// @param account The account that will receive the created tokens.
1365     /// @param value The amount that will be created.
1366     function _mint(address account, uint256 value) internal override {
1367         super._mint(account, value);
1368 
1369         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
1370             account
1371         ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
1372     }
1373 
1374     /// @dev Internal function that burns an amount of the token of a given account.
1375     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1376     /// @param account The account whose tokens will be burnt.
1377     /// @param value The amount that will be burnt.
1378     function _burn(address account, uint256 value) internal override {
1379         super._burn(account, value);
1380         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
1381             account
1382         ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
1383     }
1384 
1385     function _setBalance(address account, uint256 newBalance) internal {
1386         uint256 currentBalance = balanceOf(account);
1387 
1388         if (newBalance > currentBalance) {
1389             uint256 mintAmount = newBalance.sub(currentBalance);
1390             _mint(account, mintAmount);
1391         } else if (newBalance < currentBalance) {
1392             uint256 burnAmount = currentBalance.sub(newBalance);
1393             _burn(account, burnAmount);
1394         }
1395     }
1396 
1397     function getAccount(address _account)
1398         public
1399         view
1400         returns (uint256 _withdrawableDividends, uint256 _withdrawnDividends)
1401     {
1402         _withdrawableDividends = withdrawableDividendOf(_account);
1403         _withdrawnDividends = withdrawnDividends[_account];
1404     }
1405 }
1406 
1407 contract JPOPDOGEDividendTracker is DividendPayingToken, Ownable {
1408     using SafeMath for uint256;
1409     using SafeMathInt for int256;
1410     using IterableMapping for IterableMapping.Map;
1411 
1412     IterableMapping.Map private tokenHoldersMap;
1413 
1414     mapping(address => bool) public excludedFromDividends;
1415 
1416     uint256 public minimumTokenBalanceForDividends;
1417 
1418     event ExcludeFromDividends(address indexed account);
1419 
1420     constructor()
1421         public
1422         DividendPayingToken(
1423             "JPOPDOGE_Dividend_Tracker",
1424             "JPOPDOGE_Dividend_Tracker"
1425         )
1426     {
1427         minimumTokenBalanceForDividends = 10000 * (10**18); //must hold 10000+ tokens
1428     }
1429 
1430     function _approve(
1431         address,
1432         address,
1433         uint256
1434     ) internal override {
1435         require(false, "JPOPDOGE_Dividend_Tracker: No approvals allowed");
1436     }
1437 
1438     function _transfer(
1439         address,
1440         address,
1441         uint256
1442     ) internal override {
1443         require(false, "JPOPDOGE_Dividend_Tracker: No transfers allowed");
1444     }
1445 
1446     function withdrawDividend() public override {
1447         require(
1448             false,
1449             "JPOPDOGE_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main JPOPDOGE contract."
1450         );
1451     }
1452 
1453     function excludeFromDividends(address account) external onlyOwner {
1454         require(!excludedFromDividends[account]);
1455         excludedFromDividends[account] = true;
1456 
1457         _setBalance(account, 0);
1458         tokenHoldersMap.remove(account);
1459 
1460         emit ExcludeFromDividends(account);
1461     }
1462 
1463     function getNumberOfTokenHolders() external view returns (uint256) {
1464         return tokenHoldersMap.keys.length;
1465     }
1466 
1467     function setBalance(address payable account, uint256 newBalance)
1468         external
1469         onlyOwner
1470     {
1471         if (excludedFromDividends[account]) {
1472             return;
1473         }
1474 
1475         if (newBalance >= minimumTokenBalanceForDividends) {
1476             _setBalance(account, newBalance);
1477             tokenHoldersMap.set(account, newBalance);
1478         } else {
1479             _setBalance(account, 0);
1480             tokenHoldersMap.remove(account);
1481         }
1482     }
1483 
1484     function processAccount(address payable account, address payable toAccount)
1485         public
1486         onlyOwner
1487         returns (uint256)
1488     {
1489         uint256 amount = _withdrawDividendOfUser(account, toAccount);
1490         return amount;
1491     }
1492 }
1493 
1494 contract JPOPDOGE is ERC20, Ownable {
1495     using SafeMath for uint256;
1496 
1497     IFTPAntiBot private antiBot;
1498     IUniswapV2Router02 public uniswapV2Router;
1499     address public uniswapV2Pair;
1500 
1501     bool private swapping;
1502     bool private reinvesting;
1503     bool public antibotEnabled = false;
1504     bool public maxPurchaseEnabled = true;
1505 
1506     JPOPDOGEDividendTracker public dividendTracker;
1507 
1508     address payable public devAddress =
1509         0x6E106C8f3618D5abC69660B4d86A912c699Ad35b;
1510 
1511     uint256 public ethFee = 8;
1512     uint256 public devFee = 6;
1513     uint256 public totalFee = 14;
1514 
1515     uint256 public tradingStartTime = 1628091030;
1516 
1517     uint256 minimumTokenBalanceForDividends = 10000 * (10**18);
1518 
1519     //maximum purchase amount for initial launch
1520     uint256 maxPurchaseAmount = 5000000 * (10**18);
1521 
1522     // exlcude from fees and max transaction amount
1523     mapping(address => bool) private _isExcludedFromFees;
1524 
1525     // addresses that can make transfers before presale is over
1526     mapping(address => bool) public canTransferBeforeTradingIsEnabled;
1527 
1528     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1529     // could be subject to a maximum transfer amount
1530     mapping(address => bool) public automatedMarketMakerPairs;
1531 
1532     // the last time an address transferred
1533     // used to detect if an account can be reinvest inactive funds to the vault
1534     mapping(address => uint256) public lastTransfer;
1535 
1536     event UpdateDividendTracker(
1537         address indexed newAddress,
1538         address indexed oldAddress
1539     );
1540     event UpdateUniswapV2Router(
1541         address indexed newAddress,
1542         address indexed oldAddress
1543     );
1544     event ExcludeFromFees(address indexed account, bool isExcluded);
1545     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1546     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1547     event SendDividends(uint256 amount);
1548     event DividendClaimed(
1549         uint256 ethAmount,
1550         uint256 tokenAmount,
1551         address account
1552     );
1553 
1554     constructor() public ERC20("JPOPDOGE", "JPOPDOGE") {
1555         IFTPAntiBot _antiBot = IFTPAntiBot(
1556             0x590C2B20f7920A2D21eD32A21B616906b4209A43
1557         );
1558         antiBot = _antiBot;
1559 
1560         dividendTracker = new JPOPDOGEDividendTracker();
1561 
1562         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1563             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1564         );
1565         // Create a uniswap pair for this new token
1566         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1567             .createPair(address(this), _uniswapV2Router.WETH());
1568 
1569         uniswapV2Router = _uniswapV2Router;
1570         uniswapV2Pair = _uniswapV2Pair;
1571 
1572         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1573 
1574         // exclude from receiving dividends
1575         dividendTracker.excludeFromDividends(address(dividendTracker));
1576         dividendTracker.excludeFromDividends(address(this));
1577         dividendTracker.excludeFromDividends(owner());
1578         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1579 
1580         // exclude from paying fees or having max transaction amount
1581         excludeFromFees(address(this), true);
1582         excludeFromFees(owner(), true);
1583 
1584         // enable owner and fixed-sale wallet to send tokens before presales are over
1585         canTransferBeforeTradingIsEnabled[owner()] = true;
1586 
1587         _mint(owner(), 1000000000 * (10**18));
1588     }
1589 
1590     receive() external payable {}
1591 
1592     function setTradingStartTime(uint256 newStartTime) public onlyOwner {
1593         require(
1594             tradingStartTime > block.timestamp,
1595             "Trading has already started"
1596         );
1597         require(
1598             newStartTime > block.timestamp,
1599             "Start time must be in the future"
1600         );
1601 
1602         tradingStartTime = newStartTime;
1603     }
1604 
1605     function updateDividendTracker(address newAddress) public onlyOwner {
1606         require(
1607             newAddress != address(dividendTracker),
1608             "JPOPDOGE: The dividend tracker already has that address"
1609         );
1610 
1611         JPOPDOGEDividendTracker newDividendTracker = JPOPDOGEDividendTracker(
1612             payable(newAddress)
1613         );
1614 
1615         require(
1616             newDividendTracker.owner() == address(this),
1617             "JPOPDOGE: The new dividend tracker must be owned by the JPOPDOGE token contract"
1618         );
1619 
1620         newDividendTracker.excludeFromDividends(address(newDividendTracker));
1621         newDividendTracker.excludeFromDividends(address(this));
1622         newDividendTracker.excludeFromDividends(owner());
1623         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
1624 
1625         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1626 
1627         dividendTracker = newDividendTracker;
1628     }
1629 
1630     function updateUniswapV2Router(address newAddress) public onlyOwner {
1631         require(
1632             newAddress != address(uniswapV2Router),
1633             "JPOPDOGE: The router already has that address"
1634         );
1635         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1636         uniswapV2Router = IUniswapV2Router02(newAddress);
1637     }
1638 
1639     function excludeFromFees(address account, bool excluded) public onlyOwner {
1640         require(
1641             _isExcludedFromFees[account] != excluded,
1642             "JPOPDOGE: Account is already the value of 'excluded'"
1643         );
1644         _isExcludedFromFees[account] = excluded;
1645 
1646         emit ExcludeFromFees(account, excluded);
1647     }
1648 
1649     function excludeMultipleAccountsFromFees(
1650         address[] memory accounts,
1651         bool excluded
1652     ) public onlyOwner {
1653         for (uint256 i = 0; i < accounts.length; i++) {
1654             _isExcludedFromFees[accounts[i]] = excluded;
1655         }
1656 
1657         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1658     }
1659 
1660     function setAutomatedMarketMakerPair(address pair, bool value)
1661         public
1662         onlyOwner
1663     {
1664         require(
1665             pair != uniswapV2Pair,
1666             "JPOPDOGE: The UniSwap pair cannot be removed from automatedMarketMakerPairs"
1667         );
1668 
1669         _setAutomatedMarketMakerPair(pair, value);
1670     }
1671 
1672     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1673         require(
1674             automatedMarketMakerPairs[pair] != value,
1675             "JPOPDOGE: Automated market maker pair is already set to that value"
1676         );
1677         automatedMarketMakerPairs[pair] = value;
1678 
1679         if (value) {
1680             dividendTracker.excludeFromDividends(pair);
1681         }
1682 
1683         emit SetAutomatedMarketMakerPair(pair, value);
1684     }
1685 
1686     function allowPreTrading(address account, bool allowed) public onlyOwner {
1687         // used for owner and pre sale addresses
1688         require(
1689             canTransferBeforeTradingIsEnabled[account] != allowed,
1690             "JPOPDOGE: Pre trading is already the value of 'excluded'"
1691         );
1692         canTransferBeforeTradingIsEnabled[account] = allowed;
1693     }
1694 
1695     function setMaxPurchaseEnabled(bool enabled) public onlyOwner {
1696         require(
1697             maxPurchaseEnabled != enabled,
1698             "JPOPDOGE: Max purchase enabled is already the value of 'enabled'"
1699         );
1700         maxPurchaseEnabled = enabled;
1701     }
1702 
1703     function setMaxPurchaseAmount(uint256 newAmount) public onlyOwner {
1704         maxPurchaseAmount = newAmount;
1705     }
1706 
1707     function updateDevAddress(address payable newAddress) public onlyOwner {
1708         devAddress = newAddress;
1709     }
1710 
1711     function getTotalDividendsDistributed() external view returns (uint256) {
1712         return dividendTracker.totalDividendsDistributed();
1713     }
1714 
1715     function isExcludedFromFees(address account) public view returns (bool) {
1716         return _isExcludedFromFees[account];
1717     }
1718 
1719     function withdrawableDividendOf(address account)
1720         public
1721         view
1722         returns (uint256)
1723     {
1724         return dividendTracker.withdrawableDividendOf(account);
1725     }
1726 
1727     function dividendTokenBalanceOf(address account)
1728         public
1729         view
1730         returns (uint256)
1731     {
1732         return dividendTracker.balanceOf(account);
1733     }
1734 
1735     function reinvestInactive(address payable account) public onlyOwner {
1736         uint256 tokenBalance = dividendTracker.balanceOf(account);
1737         require(
1738             tokenBalance <= minimumTokenBalanceForDividends,
1739             "JPOPDOGE: Account balance must be less then minimum token balance for dividends"
1740         );
1741 
1742         uint256 _lastTransfer = lastTransfer[account];
1743         require(
1744             block.timestamp.sub(_lastTransfer) > 12 weeks,
1745             "JPOPDOGE: Account must have been inactive for at least 12 weeks"
1746         );
1747 
1748         dividendTracker.processAccount(account, address(this));
1749         uint256 dividends = address(this).balance;
1750         (bool success, ) = address(dividendTracker).call{value: dividends}("");
1751 
1752         if (success) {
1753             emit SendDividends(dividends);
1754             try dividendTracker.setBalance(account, 0) {} catch {}
1755         }
1756     }
1757 
1758     function claim(bool reinvest, uint256 minTokens) external {
1759         _claim(msg.sender, reinvest, minTokens);
1760     }
1761 
1762     function _claim(
1763         address payable account,
1764         bool reinvest,
1765         uint256 minTokens
1766     ) private {
1767         uint256 withdrawableAmount = dividendTracker.withdrawableDividendOf(
1768             account
1769         );
1770         require(
1771             withdrawableAmount > 0,
1772             "JPOPDOGE: Claimer has no withdrawable dividend"
1773         );
1774 
1775         if (!reinvest) {
1776             uint256 ethAmount = dividendTracker.processAccount(
1777                 account,
1778                 account
1779             );
1780             if (ethAmount > 0) {
1781                 emit DividendClaimed(ethAmount, 0, account);
1782             }
1783             return;
1784         }
1785 
1786         uint256 ethAmount = dividendTracker.processAccount(
1787             account,
1788             address(this)
1789         );
1790 
1791         if (ethAmount > 0) {
1792             reinvesting = true;
1793             uint256 tokenAmount = swapEthForTokens(
1794                 ethAmount,
1795                 minTokens,
1796                 account
1797             );
1798             reinvesting = false;
1799             emit DividendClaimed(ethAmount, tokenAmount, account);
1800         }
1801     }
1802 
1803     function getNumberOfDividendTokenHolders() external view returns (uint256) {
1804         return dividendTracker.getNumberOfTokenHolders();
1805     }
1806 
1807     function getAccount(address _account)
1808         public
1809         view
1810         returns (
1811             uint256 withdrawableDividends,
1812             uint256 withdrawnDividends,
1813             uint256 balance
1814         )
1815     {
1816         (withdrawableDividends, withdrawnDividends) = dividendTracker
1817             .getAccount(_account);
1818         return (withdrawableDividends, withdrawnDividends, balanceOf(_account));
1819     }
1820 
1821     function _transfer(
1822         address from,
1823         address to,
1824         uint256 amount
1825     ) internal override {
1826         require(from != address(0), "ERC20: transfer from the zero address");
1827         require(to != address(0), "ERC20: transfer to the zero address");
1828 
1829         // address must be permitted to transfer before tradingStartTime
1830         if (tradingStartTime > block.timestamp) {
1831             require(
1832                 canTransferBeforeTradingIsEnabled[from],
1833                 "JPOPDOGE: This account cannot send tokens until trading is enabled"
1834             );
1835         }
1836 
1837         if (amount == 0) {
1838             super._transfer(from, to, 0);
1839             return;
1840         }
1841 
1842         if (antibotEnabled) {
1843             if (automatedMarketMakerPairs[from]) {
1844                 require(
1845                     !antiBot.scanAddress(to, from, tx.origin),
1846                     "Beep Beep Boop, You're a piece of poop"
1847                 );
1848             }
1849             if (automatedMarketMakerPairs[to]) {
1850                 require(
1851                     !antiBot.scanAddress(from, to, tx.origin),
1852                     "Beep Beep Boop, You're a piece of poop"
1853                 );
1854             }
1855         }
1856 
1857         // make sure amount does not exceed max on a purchase
1858         if (maxPurchaseEnabled && automatedMarketMakerPairs[from]) {
1859             require(
1860                 amount <= maxPurchaseAmount,
1861                 "JPOPDOGE: Exceeds max purchase amount"
1862             );
1863         }
1864 
1865         if (
1866             !swapping &&
1867             !reinvesting &&
1868             !automatedMarketMakerPairs[from] &&
1869             !_isExcludedFromFees[from] &&
1870             !_isExcludedFromFees[to]
1871         ) {
1872             swapping = true;
1873             swapAndDistribute();
1874             swapping = false;
1875         }
1876 
1877         bool takeFee = !swapping && !reinvesting;
1878 
1879         // if any account belongs to _isExcludedFromFee account then remove the fee
1880         // don't take a fee unless it's a buy / sell
1881         if (
1882             (_isExcludedFromFees[from] || _isExcludedFromFees[to]) ||
1883             (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to])
1884         ) {
1885             takeFee = false;
1886         }
1887 
1888         if (takeFee) {
1889             uint256 fees = amount.mul(totalFee).div(100);
1890             amount = amount.sub(fees);
1891 
1892             super._transfer(from, address(this), fees);
1893         }
1894 
1895         super._transfer(from, to, amount);
1896 
1897         try
1898             dividendTracker.setBalance(payable(from), balanceOf(from))
1899         {} catch {}
1900         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1901 
1902         if (antibotEnabled) {
1903             try antiBot.registerBlock(from, to) {} catch {}
1904         }
1905 
1906         lastTransfer[from] = block.timestamp;
1907         lastTransfer[to] = block.timestamp;
1908     }
1909 
1910     function swapTokensForEth(uint256 tokenAmount) private {
1911         // generate the uniswap pair path of token -> weth
1912         address[] memory path = new address[](2);
1913         path[0] = address(this);
1914         path[1] = uniswapV2Router.WETH();
1915 
1916         _approve(address(this), address(uniswapV2Router), tokenAmount);
1917 
1918         // make the swap
1919         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1920             tokenAmount,
1921             0, // accept any amount of ETH
1922             path,
1923             address(this),
1924             block.timestamp
1925         );
1926     }
1927 
1928     function swapEthForTokens(
1929         uint256 ethAmount,
1930         uint256 minTokens,
1931         address account
1932     ) internal returns (uint256) {
1933         address[] memory path = new address[](2);
1934         path[0] = uniswapV2Router.WETH();
1935         path[1] = address(this);
1936 
1937         uint256 balanceBefore = balanceOf(account);
1938 
1939         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1940             value: ethAmount
1941         }(minTokens, path, account, block.timestamp);
1942 
1943         uint256 tokenAmount = balanceOf(account).sub(balanceBefore);
1944         return tokenAmount;
1945     }
1946 
1947     function swapAndDistribute() private {
1948         uint256 tokenBalance = balanceOf(address(this));
1949         swapTokensForEth(tokenBalance);
1950 
1951         uint256 ethBalance = address(this).balance;
1952         uint256 devPortion = ethBalance.mul(devFee).div(totalFee);
1953         devAddress.transfer(devPortion);
1954 
1955         uint256 dividends = address(this).balance;
1956         (bool success, ) = address(dividendTracker).call{value: dividends}("");
1957 
1958         if (success) {
1959             emit SendDividends(dividends);
1960         }
1961     }
1962 
1963     function assignAntiBot(address _address) external onlyOwner {
1964         IFTPAntiBot _antiBot = IFTPAntiBot(_address);
1965         antiBot = _antiBot;
1966     }
1967 
1968     function toggleAntiBot() external onlyOwner {
1969         if (antibotEnabled) {
1970             antibotEnabled = false;
1971         } else {
1972             antibotEnabled = true;
1973         }
1974     }
1975 
1976     function getDay() internal view returns (uint256) {
1977         return block.timestamp.div(1 days);
1978     }
1979 }