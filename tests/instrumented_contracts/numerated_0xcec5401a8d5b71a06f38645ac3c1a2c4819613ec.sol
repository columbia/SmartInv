1 pragma solidity ^0.6.12;
2 
3 // SPDX-License-Identifier: MIT
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 pragma solidity ^0.6.2;
26 
27 
28 /**
29  * @title SafeMathUint
30  * @dev Math operations with safety checks that revert on error
31  */
32 library SafeMathUint {
33   function toInt256Safe(uint256 a) internal pure returns (int256) {
34     int256 b = int256(a);
35     require(b >= 0);
36     return b;
37   }
38 }
39 
40 
41 
42 
43 
44 
45 /*
46 MIT License
47 
48 Copyright (c) 2018 requestnetwork
49 Copyright (c) 2018 Fragments, Inc.
50 
51 Permission is hereby granted, free of charge, to any person obtaining a copy
52 of this software and associated documentation files (the "Software"), to deal
53 in the Software without restriction, including without limitation the rights
54 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
55 copies of the Software, and to permit persons to whom the Software is
56 furnished to do so, subject to the following conditions:
57 
58 The above copyright notice and this permission notice shall be included in all
59 copies or substantial portions of the Software.
60 
61 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
62 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
63 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
64 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
65 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
66 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
67 SOFTWARE.
68 */
69 
70 pragma solidity ^0.6.2;
71 
72 /**
73  * @title SafeMathInt
74  * @dev Math operations for int256 with overflow safety checks.
75  */
76 library SafeMathInt {
77     int256 private constant MIN_INT256 = int256(1) << 255;
78     int256 private constant MAX_INT256 = ~(int256(1) << 255);
79 
80     /**
81      * @dev Multiplies two int256 variables and fails on overflow.
82      */
83     function mul(int256 a, int256 b) internal pure returns (int256) {
84         int256 c = a * b;
85 
86         // Detect overflow when multiplying MIN_INT256 with -1
87         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
88         require((b == 0) || (c / b == a));
89         return c;
90     }
91 
92     /**
93      * @dev Division of two int256 variables and fails on overflow.
94      */
95     function div(int256 a, int256 b) internal pure returns (int256) {
96         // Prevent overflow when dividing MIN_INT256 by -1
97         require(b != -1 || a != MIN_INT256);
98 
99         // Solidity already throws when dividing by 0.
100         return a / b;
101     }
102 
103     /**
104      * @dev Subtracts two int256 variables and fails on overflow.
105      */
106     function sub(int256 a, int256 b) internal pure returns (int256) {
107         int256 c = a - b;
108         require((b >= 0 && c <= a) || (b < 0 && c > a));
109         return c;
110     }
111 
112     /**
113      * @dev Adds two int256 variables and fails on overflow.
114      */
115     function add(int256 a, int256 b) internal pure returns (int256) {
116         int256 c = a + b;
117         require((b >= 0 && c >= a) || (b < 0 && c < a));
118         return c;
119     }
120 
121     /**
122      * @dev Converts to absolute value, and fails on overflow.
123      */
124     function abs(int256 a) internal pure returns (int256) {
125         require(a != MIN_INT256);
126         return a < 0 ? -a : a;
127     }
128 
129 
130     function toUint256Safe(int256 a) internal pure returns (uint256) {
131         require(a >= 0);
132         return uint256(a);
133     }
134 }
135 
136 
137 
138 pragma solidity ^0.6.2;
139 
140 library SafeMath {
141     /**
142      * @dev Returns the addition of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `+` operator.
146      *
147      * Requirements:
148      *
149      * - Addition cannot overflow.
150      */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         return sub(a, b, "SafeMath: subtraction overflow");
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b <= a, errorMessage);
184         uint256 c = a - b;
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
201         // benefit is lost if 'b' is also tested.
202         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
203         if (a == 0) {
204             return 0;
205         }
206 
207         uint256 c = a * b;
208         require(c / a == b, "SafeMath: multiplication overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         return div(a, b, "SafeMath: division by zero");
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b > 0, errorMessage);
243         uint256 c = a / b;
244         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return mod(a, b, "SafeMath: modulo by zero");
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts with custom message when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b != 0, errorMessage);
279         return a % b;
280     }
281 }
282 
283 pragma solidity ^0.6.2;
284 
285 
286 
287 
288 contract Ownable is Context {
289     address private _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev Initializes the contract setting the deployer as the initial owner.
295      */
296     constructor () public {
297         address msgSender = _msgSender();
298         _owner = msgSender;
299         emit OwnershipTransferred(address(0), msgSender);
300     }
301 
302     /**
303      * @dev Returns the address of the current owner.
304      */
305     function owner() public view returns (address) {
306         return _owner;
307     }
308 
309     /**
310      * @dev Throws if called by any account other than the owner.
311      */
312     modifier onlyOwner() {
313         require(_owner == _msgSender(), "Ownable: caller is not the owner");
314         _;
315     }
316 
317     /**
318      * @dev Leaves the contract without owner. It will not be possible to call
319      * `onlyOwner` functions anymore. Can only be called by the current owner.
320      *
321      * NOTE: Renouncing ownership will leave the contract without an owner,
322      * thereby removing any functionality that is only available to the owner.
323      */
324     function renounceOwnership() public virtual onlyOwner {
325         emit OwnershipTransferred(_owner, address(0));
326         _owner = address(0);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         emit OwnershipTransferred(_owner, newOwner);
336         _owner = newOwner;
337     }
338 }
339 
340 
341 
342 
343 pragma solidity ^0.6.2;
344 
345 interface IUniswapV2Router01 {
346     function factory() external pure returns (address);
347     function WETH() external pure returns (address);
348 
349     function addLiquidity(
350         address tokenA,
351         address tokenB,
352         uint amountADesired,
353         uint amountBDesired,
354         uint amountAMin,
355         uint amountBMin,
356         address to,
357         uint deadline
358     ) external returns (uint amountA, uint amountB, uint liquidity);
359     function addLiquidityETH(
360         address token,
361         uint amountTokenDesired,
362         uint amountTokenMin,
363         uint amountETHMin,
364         address to,
365         uint deadline
366     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
367     function removeLiquidity(
368         address tokenA,
369         address tokenB,
370         uint liquidity,
371         uint amountAMin,
372         uint amountBMin,
373         address to,
374         uint deadline
375     ) external returns (uint amountA, uint amountB);
376     function removeLiquidityETH(
377         address token,
378         uint liquidity,
379         uint amountTokenMin,
380         uint amountETHMin,
381         address to,
382         uint deadline
383     ) external returns (uint amountToken, uint amountETH);
384     function removeLiquidityWithPermit(
385         address tokenA,
386         address tokenB,
387         uint liquidity,
388         uint amountAMin,
389         uint amountBMin,
390         address to,
391         uint deadline,
392         bool approveMax, uint8 v, bytes32 r, bytes32 s
393     ) external returns (uint amountA, uint amountB);
394     function removeLiquidityETHWithPermit(
395         address token,
396         uint liquidity,
397         uint amountTokenMin,
398         uint amountETHMin,
399         address to,
400         uint deadline,
401         bool approveMax, uint8 v, bytes32 r, bytes32 s
402     ) external returns (uint amountToken, uint amountETH);
403     function swapExactTokensForTokens(
404         uint amountIn,
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline
409     ) external returns (uint[] memory amounts);
410     function swapTokensForExactTokens(
411         uint amountOut,
412         uint amountInMax,
413         address[] calldata path,
414         address to,
415         uint deadline
416     ) external returns (uint[] memory amounts);
417     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
418         external
419         payable
420         returns (uint[] memory amounts);
421     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
422         external
423         returns (uint[] memory amounts);
424     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
425         external
426         returns (uint[] memory amounts);
427     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
428         external
429         payable
430         returns (uint[] memory amounts);
431 
432     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
433     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
434     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
435     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
436     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
437 }
438 
439 
440 
441 // pragma solidity >=0.6.2;
442 
443 interface IUniswapV2Router02 is IUniswapV2Router01 {
444     function removeLiquidityETHSupportingFeeOnTransferTokens(
445         address token,
446         uint liquidity,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline
451     ) external returns (uint amountETH);
452     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
453         address token,
454         uint liquidity,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline,
459         bool approveMax, uint8 v, bytes32 r, bytes32 s
460     ) external returns (uint amountETH);
461 
462     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
463         uint amountIn,
464         uint amountOutMin,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external;
469     function swapExactETHForTokensSupportingFeeOnTransferTokens(
470         uint amountOutMin,
471         address[] calldata path,
472         address to,
473         uint deadline
474     ) external payable;
475     function swapExactTokensForETHSupportingFeeOnTransferTokens(
476         uint amountIn,
477         uint amountOutMin,
478         address[] calldata path,
479         address to,
480         uint deadline
481     ) external;
482 }
483 
484 
485 
486 pragma solidity ^0.6.2;
487 
488 interface IUniswapV2Pair {
489     event Approval(address indexed owner, address indexed spender, uint value);
490     event Transfer(address indexed from, address indexed to, uint value);
491 
492     function name() external pure returns (string memory);
493     function symbol() external pure returns (string memory);
494     function decimals() external pure returns (uint8);
495     function totalSupply() external view returns (uint);
496     function balanceOf(address owner) external view returns (uint);
497     function allowance(address owner, address spender) external view returns (uint);
498 
499     function approve(address spender, uint value) external returns (bool);
500     function transfer(address to, uint value) external returns (bool);
501     function transferFrom(address from, address to, uint value) external returns (bool);
502 
503     function DOMAIN_SEPARATOR() external view returns (bytes32);
504     function PERMIT_TYPEHASH() external pure returns (bytes32);
505     function nonces(address owner) external view returns (uint);
506 
507     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
508 
509     event Mint(address indexed sender, uint amount0, uint amount1);
510     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
511     event Swap(
512         address indexed sender,
513         uint amount0In,
514         uint amount1In,
515         uint amount0Out,
516         uint amount1Out,
517         address indexed to
518     );
519     event Sync(uint112 reserve0, uint112 reserve1);
520 
521     function MINIMUM_LIQUIDITY() external pure returns (uint);
522     function factory() external view returns (address);
523     function token0() external view returns (address);
524     function token1() external view returns (address);
525     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
526     function price0CumulativeLast() external view returns (uint);
527     function price1CumulativeLast() external view returns (uint);
528     function kLast() external view returns (uint);
529 
530     function mint(address to) external returns (uint liquidity);
531     function burn(address to) external returns (uint amount0, uint amount1);
532     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
533     function skim(address to) external;
534     function sync() external;
535 
536     function initialize(address, address) external;
537 }
538 
539 
540 
541 pragma solidity ^0.6.2;
542 
543 interface IUniswapV2Factory {
544     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
545 
546     function feeTo() external view returns (address);
547     function feeToSetter() external view returns (address);
548 
549     function getPair(address tokenA, address tokenB) external view returns (address pair);
550     function allPairs(uint) external view returns (address pair);
551     function allPairsLength() external view returns (uint);
552 
553     function createPair(address tokenA, address tokenB) external returns (address pair);
554 
555     function setFeeTo(address) external;
556     function setFeeToSetter(address) external;
557 }
558 
559 
560 pragma solidity ^0.6.2;
561 
562 library IterableMapping {
563     // Iterable mapping from address to uint;
564     struct Map {
565         address[] keys;
566         mapping(address => uint) values;
567         mapping(address => uint) indexOf;
568         mapping(address => bool) inserted;
569     }
570 
571     function get(Map storage map, address key) public view returns (uint) {
572         return map.values[key];
573     }
574 
575     function getIndexOfKey(Map storage map, address key) public view returns (int) {
576         if(!map.inserted[key]) {
577             return -1;
578         }
579         return int(map.indexOf[key]);
580     }
581 
582     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
583         return map.keys[index];
584     }
585 
586 
587 
588     function size(Map storage map) public view returns (uint) {
589         return map.keys.length;
590     }
591 
592     function set(Map storage map, address key, uint val) public {
593         if (map.inserted[key]) {
594             map.values[key] = val;
595         } else {
596             map.inserted[key] = true;
597             map.values[key] = val;
598             map.indexOf[key] = map.keys.length;
599             map.keys.push(key);
600         }
601     }
602 
603     function remove(Map storage map, address key) public {
604         if (!map.inserted[key]) {
605             return;
606         }
607 
608         delete map.inserted[key];
609         delete map.values[key];
610 
611         uint index = map.indexOf[key];
612         uint lastIndex = map.keys.length - 1;
613         address lastKey = map.keys[lastIndex];
614 
615         map.indexOf[lastKey] = index;
616         delete map.indexOf[key];
617 
618         map.keys[index] = lastKey;
619         map.keys.pop();
620     }
621 }
622 
623 
624 pragma solidity ^0.6.2;
625 
626 /**
627  * @dev Interface of the ERC20 standard as defined in the EIP.
628  */
629 interface IERC20 {
630     /**
631      * @dev Returns the amount of tokens in existence.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     /**
636      * @dev Returns the amount of tokens owned by `account`.
637      */
638     function balanceOf(address account) external view returns (uint256);
639 
640     /**
641      * @dev Moves `amount` tokens from the caller's account to `recipient`.
642      *
643      * Returns a boolean value indicating whether the operation succeeded.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transfer(address recipient, uint256 amount) external returns (bool);
648 
649     /**
650      * @dev Returns the remaining number of tokens that `spender` will be
651      * allowed to spend on behalf of `owner` through {transferFrom}. This is
652      * zero by default.
653      *
654      * This value changes when {approve} or {transferFrom} are called.
655      */
656     function allowance(address owner, address spender) external view returns (uint256);
657 
658     /**
659      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
660      *
661      * Returns a boolean value indicating whether the operation succeeded.
662      *
663      * IMPORTANT: Beware that changing an allowance with this method brings the risk
664      * that someone may use both the old and the new allowance by unfortunate
665      * transaction ordering. One possible solution to mitigate this race
666      * condition is to first reduce the spender's allowance to 0 and set the
667      * desired value afterwards:
668      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address spender, uint256 amount) external returns (bool);
673 
674     /**
675      * @dev Moves `amount` tokens from `sender` to `recipient` using the
676      * allowance mechanism. `amount` is then deducted from the caller's
677      * allowance.
678      *
679      * Returns a boolean value indicating whether the operation succeeded.
680      *
681      * Emits a {Transfer} event.
682      */
683     function transferFrom(
684         address sender,
685         address recipient,
686         uint256 amount
687     ) external returns (bool);
688 
689     /**
690      * @dev Emitted when `value` tokens are moved from one account (`from`) to
691      * another (`to`).
692      *
693      * Note that `value` may be zero.
694      */
695     event Transfer(address indexed from, address indexed to, uint256 value);
696 
697 
698 
699     /**
700      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
701      * a call to {approve}. `value` is the new allowance.
702      */
703     event Approval(address indexed owner, address indexed spender, uint256 value);
704 }
705 
706 
707 
708 pragma solidity ^0.6.2;
709 
710 
711 
712 /**
713  * @dev Interface for the optional metadata functions from the ERC20 standard.
714  *
715  * _Available since v4.1._
716  */
717 interface IERC20Metadata is IERC20 {
718     /**
719      * @dev Returns the name of the token.
720      */
721     function name() external view returns (string memory);
722 
723     /**
724      * @dev Returns the symbol of the token.
725      */
726     function symbol() external view returns (string memory);
727 
728     /**
729      * @dev Returns the decimals places of the token.
730      */
731     function decimals() external view returns (uint8);
732 }
733 
734 
735 
736 
737 
738 
739 pragma solidity ^0.6.2;
740 /**
741  * @dev Implementation of the {IERC20} interface.
742  *
743  * This implementation is agnostic to the way tokens are created. This means
744  * that a supply mechanism has to be added in a derived contract using {_mint}.
745  * For a generic mechanism see {ERC20PresetMinterPauser}.
746  *
747  * TIP: For a detailed writeup see our guide
748  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
749  * to implement supply mechanisms].
750  *
751  * We have followed general OpenZeppelin guidelines: functions revert instead
752  * of returning `false` on failure. This behavior is nonetheless conventional
753  * and does not conflict with the expectations of ERC20 applications.
754  *
755  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
756  * This allows applications to reconstruct the allowance for all accounts just
757  * by listening to said events. Other implementations of the EIP may not emit
758  * these events, as it isn't required by the specification.
759  *
760  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
761  * functions have been added to mitigate the well-known issues around setting
762  * allowances. See {IERC20-approve}.
763  */
764 contract ERC20 is Context, IERC20, IERC20Metadata {
765     using SafeMath for uint256;
766 
767     mapping(address => uint256) private _balances;
768 
769     mapping(address => mapping(address => uint256)) private _allowances;
770 
771     uint256 private _totalSupply;
772 
773     string private _name;
774     string private _symbol;
775 
776     /**
777      * @dev Sets the values for {name} and {symbol}.
778      *
779      * The default value of {decimals} is 18. To select a different value for
780      * {decimals} you should overload it.
781      *
782      * All two of these values are immutable: they can only be set once during
783      * construction.
784      */
785     constructor(string memory name_, string memory symbol_) public {
786         _name = name_;
787         _symbol = symbol_;
788     }
789 
790     /**
791      * @dev Returns the name of the token.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev Returns the symbol of the token, usually a shorter version of the
799      * name.
800      */
801     function symbol() public view virtual override returns (string memory) {
802         return _symbol;
803     }
804 
805     /**
806      * @dev Returns the number of decimals used to get its user representation.
807      * For example, if `decimals` equals `2`, a balance of `505` tokens should
808      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
809      *
810      * Tokens usually opt for a value of 18, imitating the relationship between
811      * Ether and Wei. This is the value {ERC20} uses, unless this function is
812      * overridden;
813      *
814      * NOTE: This information is only used for _display_ purposes: it in
815      * no way affects any of the arithmetic of the contract, including
816      * {IERC20-balanceOf} and {IERC20-transfer}.
817      */
818     function decimals() public view virtual override returns (uint8) {
819         return 18;
820     }
821 
822     /**
823      * @dev See {IERC20-totalSupply}.
824      */
825     function totalSupply() public view virtual override returns (uint256) {
826         return _totalSupply;
827     }
828 
829     /**
830      * @dev See {IERC20-balanceOf}.
831      */
832     function balanceOf(address account) public view virtual override returns (uint256) {
833         return _balances[account];
834     }
835 
836     /**
837      * @dev See {IERC20-transfer}.
838      *
839      * Requirements:
840      *
841      * - `recipient` cannot be the zero address.
842      * - the caller must have a balance of at least `amount`.
843      */
844     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
845         _transfer(_msgSender(), recipient, amount);
846         return true;
847     }
848 
849     /**
850      * @dev See {IERC20-allowance}.
851      */
852     function allowance(address owner, address spender) public view virtual override returns (uint256) {
853         return _allowances[owner][spender];
854     }
855 
856     /**
857      * @dev See {IERC20-approve}.
858      *
859      * Requirements:
860      *
861      * - `spender` cannot be the zero address.
862      */
863     function approve(address spender, uint256 amount) public virtual override returns (bool) {
864         _approve(_msgSender(), spender, amount);
865         return true;
866     }
867 
868     /**
869      * @dev See {IERC20-transferFrom}.
870      *
871      * Emits an {Approval} event indicating the updated allowance. This is not
872      * required by the EIP. See the note at the beginning of {ERC20}.
873      *
874      * Requirements:
875      *
876      * - `sender` and `recipient` cannot be the zero address.
877      * - `sender` must have a balance of at least `amount`.
878      * - the caller must have allowance for ``sender``'s tokens of at least
879      * `amount`.
880      */
881     function transferFrom(
882         address sender,
883         address recipient,
884         uint256 amount
885     ) public virtual override returns (bool) {
886         _transfer(sender, recipient, amount);
887         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
888         return true;
889     }
890 
891     /**
892      * @dev Atomically increases the allowance granted to `spender` by the caller.
893      *
894      * This is an alternative to {approve} that can be used as a mitigation for
895      * problems described in {IERC20-approve}.
896      *
897      * Emits an {Approval} event indicating the updated allowance.
898      *
899      * Requirements:
900      *
901      * - `spender` cannot be the zero address.
902      */
903     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
904         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
905         return true;
906     }
907 
908     /**
909      * @dev Atomically decreases the allowance granted to `spender` by the caller.
910      *
911      * This is an alternative to {approve} that can be used as a mitigation for
912      * problems described in {IERC20-approve}.
913      *
914      * Emits an {Approval} event indicating the updated allowance.
915      *
916      * Requirements:
917      *
918      * - `spender` cannot be the zero address.
919      * - `spender` must have allowance for the caller of at least
920      * `subtractedValue`.
921      */
922     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
923         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
924         return true;
925     }
926 
927     /**
928      * @dev Moves tokens `amount` from `sender` to `recipient`.
929      *
930      * This is internal function is equivalent to {transfer}, and can be used to
931      * e.g. implement automatic token fees, slashing mechanisms, etc.
932      *
933      * Emits a {Transfer} event.
934      *
935      * Requirements:
936      *
937      * - `sender` cannot be the zero address.
938      * - `recipient` cannot be the zero address.
939      * - `sender` must have a balance of at least `amount`.
940      */
941     function _transfer(
942         address sender,
943         address recipient,
944         uint256 amount
945     ) internal virtual {
946         require(sender != address(0), "ERC20: transfer from the zero address");
947         require(recipient != address(0), "ERC20: transfer to the zero address");
948 
949         _beforeTokenTransfer(sender, recipient, amount);
950 
951         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
952         _balances[recipient] = _balances[recipient].add(amount);
953         emit Transfer(sender, recipient, amount);
954     }
955 
956     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
957      * the total supply.
958      *
959      * Emits a {Transfer} event with `from` set to the zero address.
960      *
961      * Requirements:
962      *
963      * - `account` cannot be the zero address.
964      */
965     function _mint(address account, uint256 amount) internal virtual {
966         require(account != address(0), "ERC20: mint to the zero address");
967 
968         _beforeTokenTransfer(address(0), account, amount);
969 
970         _totalSupply = _totalSupply.add(amount);
971         _balances[account] = _balances[account].add(amount);
972         emit Transfer(address(0), account, amount);
973     }
974 
975     /**
976      * @dev Destroys `amount` tokens from `account`, reducing the
977      * total supply.
978      *
979      * Emits a {Transfer} event with `to` set to the zero address.
980      *
981      * Requirements:
982      *
983      * - `account` cannot be the zero address.
984      * - `account` must have at least `amount` tokens.
985      */
986     function _burn(address account, uint256 amount) internal virtual {
987         require(account != address(0), "ERC20: burn from the zero address");
988 
989         _beforeTokenTransfer(account, address(0), amount);
990 
991         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
992         _totalSupply = _totalSupply.sub(amount);
993         emit Transfer(account, address(0), amount);
994     }
995 
996     /**
997      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
998      *
999      * This internal function is equivalent to `approve`, and can be used to
1000      * e.g. set automatic allowances for certain subsystems, etc.
1001      *
1002      * Emits an {Approval} event.
1003      *
1004      * Requirements:
1005      *
1006      * - `owner` cannot be the zero address.
1007      * - `spender` cannot be the zero address.
1008      */
1009     function _approve(
1010         address owner,
1011         address spender,
1012         uint256 amount
1013     ) internal virtual {
1014         require(owner != address(0), "ERC20: approve from the zero address");
1015         require(spender != address(0), "ERC20: approve to the zero address");
1016 
1017         _allowances[owner][spender] = amount;
1018         emit Approval(owner, spender, amount);
1019     }
1020 
1021     /**
1022      * @dev Hook that is called before any transfer of tokens. This includes
1023      * minting and burning.
1024      *
1025      * Calling conditions:
1026      *
1027      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1028      * will be to transferred to `to`.
1029      * - when `from` is zero, `amount` tokens will be minted for `to`.
1030      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1031      * - `from` and `to` are never both zero.
1032      *
1033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1034      */
1035     function _beforeTokenTransfer(
1036         address from,
1037         address to,
1038         uint256 amount
1039     ) internal virtual {}
1040 }
1041 
1042 
1043 
1044 pragma solidity ^0.6.2;
1045 
1046 
1047 /// @title Dividend-Paying Token Optional Interface
1048 /// @author Roger Wu (https://github.com/roger-wu)
1049 /// @dev OPTIONAL functions for a dividend-paying token contract.
1050 interface DividendPayingTokenOptionalInterface {
1051   /// @notice View the amount of dividend in wei that an address can withdraw.
1052   /// @param _owner The address of a token holder.
1053   /// @return The amount of dividend in wei that `_owner` can withdraw.
1054   function withdrawableDividendOf(address _owner) external view returns(uint256);
1055 
1056   /// @notice View the amount of dividend in wei that an address has withdrawn.
1057   /// @param _owner The address of a token holder.
1058   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1059   function withdrawnDividendOf(address _owner) external view returns(uint256);
1060 
1061   /// @notice View the amount of dividend in wei that an address has earned in total.
1062   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1063   /// @param _owner The address of a token holder.
1064   /// @return The amount of dividend in wei that `_owner` has earned in total.
1065   function accumulativeDividendOf(address _owner) external view returns(uint256);
1066 }
1067 
1068 
1069 
1070 pragma solidity ^0.6.2;
1071 
1072 
1073 /// @title Dividend-Paying Token Interface
1074 /// @author Roger Wu (https://github.com/roger-wu)
1075 /// @dev An interface for a dividend-paying token contract.
1076 interface DividendPayingTokenInterface {
1077   /// @notice View the amount of dividend in wei that an address can withdraw.
1078   /// @param _owner The address of a token holder.
1079   /// @return The amount of dividend in wei that `_owner` can withdraw.
1080   function dividendOf(address _owner) external view returns(uint256);
1081 
1082 
1083   /// @notice Withdraws the ether distributed to the sender.
1084   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
1085   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
1086   function withdrawDividend() external;
1087 
1088   /// @dev This event MUST emit when ether is distributed to token holders.
1089   /// @param from The address which sends ether to this contract.
1090   /// @param weiAmount The amount of distributed ether in wei.
1091   event DividendsDistributed(
1092     address indexed from,
1093     uint256 weiAmount
1094   );
1095 
1096   /// @dev This event MUST emit when an address withdraws their dividend.
1097   /// @param to The address which withdraws ether from this contract.
1098   /// @param weiAmount The amount of withdrawn ether in wei.
1099   event DividendWithdrawn(
1100     address indexed to,
1101     uint256 weiAmount
1102   );
1103 }
1104 
1105 
1106 
1107 pragma solidity ^0.6.2;
1108 
1109 
1110 /// @title Dividend-Paying Token
1111 /// @author Roger Wu (https://github.com/roger-wu)
1112 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1113 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1114 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1115 contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
1116   using SafeMath for uint256;
1117   using SafeMathUint for uint256;
1118   using SafeMathInt for int256;
1119 
1120   address public immutable USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7); // USDT
1121 
1122 
1123   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1124   // For more discussion about choosing the value of `magnitude`,
1125   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1126   uint256 constant internal magnitude = 2**128;
1127 
1128   uint256 internal magnifiedDividendPerShare;
1129 
1130   // About dividendCorrection:
1131   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1132   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1133   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1134   //   `dividendOf(_user)` should not be changed,
1135   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1136   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1137   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1138   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1139   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1140   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1141   mapping(address => int256) internal magnifiedDividendCorrections;
1142   mapping(address => uint256) internal withdrawnDividends;
1143 
1144   uint256 public totalDividendsDistributed;
1145 
1146   constructor(string memory _name, string memory _symbol) public ERC20(_name, _symbol) {
1147 
1148   }
1149 
1150 
1151   function distributeUSDTDividends(uint256 amount) public onlyOwner{
1152     require(totalSupply() > 0);
1153 
1154     if (amount > 0) {
1155       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1156         (amount).mul(magnitude) / totalSupply()
1157       );
1158       emit DividendsDistributed(msg.sender, amount);
1159 
1160       totalDividendsDistributed = totalDividendsDistributed.add(amount);
1161     }
1162   }
1163 
1164   /// @notice Withdraws the ether distributed to the sender.
1165   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1166   function withdrawDividend() public virtual override {
1167     _withdrawDividendOfUser(msg.sender);
1168   }
1169 
1170   /// @notice Withdraws the ether distributed to the sender.
1171   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1172  function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1173     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1174     if (_withdrawableDividend > 0) {
1175       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1176       emit DividendWithdrawn(user, _withdrawableDividend);
1177       bool success = IERC20(USDT).transfer(user, _withdrawableDividend);
1178 
1179       if(!success) {
1180         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1181         return 0;
1182       }
1183 
1184       return _withdrawableDividend;
1185     }
1186 
1187     return 0;
1188   }
1189 
1190 
1191   /// @notice View the amount of dividend in wei that an address can withdraw.
1192   /// @param _owner The address of a token holder.
1193   /// @return The amount of dividend in wei that `_owner` can withdraw.
1194   function dividendOf(address _owner) public view override returns(uint256) {
1195     return withdrawableDividendOf(_owner);
1196   }
1197 
1198   /// @notice View the amount of dividend in wei that an address can withdraw.
1199   /// @param _owner The address of a token holder.
1200   /// @return The amount of dividend in wei that `_owner` can withdraw.
1201   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1202     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1203   }
1204 
1205   /// @notice View the amount of dividend in wei that an address has withdrawn.
1206   /// @param _owner The address of a token holder.
1207   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1208   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1209     return withdrawnDividends[_owner];
1210   }
1211 
1212 
1213   /// @notice View the amount of dividend in wei that an address has earned in total.
1214   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1215   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1216   /// @param _owner The address of a token holder.
1217   /// @return The amount of dividend in wei that `_owner` has earned in total.
1218   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1219     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1220       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1221   }
1222 
1223   /// @dev Internal function that transfer tokens from one address to another.
1224   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1225   /// @param from The address to transfer from.
1226   /// @param to The address to transfer to.
1227   /// @param value The amount to be transferred.
1228   function _transfer(address from, address to, uint256 value) internal virtual override {
1229     require(false);
1230 
1231     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1232     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1233     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1234   }
1235 
1236   /// @dev Internal function that mints tokens to an account.
1237   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1238   /// @param account The account that will receive the created tokens.
1239   /// @param value The amount that will be created.
1240   function _mint(address account, uint256 value) internal override {
1241     super._mint(account, value);
1242 
1243     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1244       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1245   }
1246 
1247   /// @dev Internal function that burns an amount of the token of a given account.
1248   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1249   /// @param account The account whose tokens will be burnt.
1250   /// @param value The amount that will be burnt.
1251   function _burn(address account, uint256 value) internal override {
1252     super._burn(account, value);
1253 
1254     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1255       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1256   }
1257 
1258   function _setBalance(address account, uint256 newBalance) internal {
1259     uint256 currentBalance = balanceOf(account);
1260 
1261     if(newBalance > currentBalance) {
1262       uint256 mintAmount = newBalance.sub(currentBalance);
1263       _mint(account, mintAmount);
1264     } else if(newBalance < currentBalance) {
1265       uint256 burnAmount = currentBalance.sub(newBalance);
1266       _burn(account, burnAmount);
1267     }
1268   }
1269 }
1270 
1271 
1272 pragma solidity ^0.6.2;
1273 
1274 
1275 
1276 contract HyperShiba is ERC20, Ownable {
1277     using SafeMath for uint256;
1278 
1279     IUniswapV2Router02 public uniswapV2Router;
1280     address public  uniswapV2Pair;
1281 
1282     bool private swapping;
1283 
1284     HshibDividendTracker public dividendTracker;
1285 
1286     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1287    
1288 
1289     address public immutable USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7); // USDT
1290 
1291     uint256 public swapTokensAtAmount = 4000000 * (10**18);
1292     
1293     mapping(address => bool) public _isBlacklisted;
1294     
1295   
1296 
1297     uint256 public USDTRewardsFee = 4;
1298     uint256 public marketingFee = 4;
1299     uint256 public buybackFee = 4;
1300     uint256 public totalFees = USDTRewardsFee.add(buybackFee).add(marketingFee);
1301 
1302     address public _marketingWalletAddress = 0x6b752ABF5a28dA2A81EcA05e7EC3E4DbD3E1466F;
1303     address public _buybackWalletAddress = 0x23bd72dbEEA5bAd872Aa1E10Aef2042fB319B7c9;
1304 
1305 
1306     // use by default 300,000 gas to process auto-claiming dividends
1307     uint256 public gasForProcessing = 300000;
1308 
1309      // exlcude from fees and max transaction amount
1310     mapping (address => bool) private _isExcludedFromFees;
1311 
1312     mapping(address => bool) private _isExcludedFromAntiWhale;
1313 
1314     uint256 public maxTransferAmountRate = 1000;
1315     
1316     bool private enableAntiwhale = false;
1317 
1318 
1319     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1320     // could be subject to a maximum transfer amount
1321     mapping (address => bool) public automatedMarketMakerPairs;
1322 
1323     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1324 
1325     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1326 
1327     event ExcludeFromFees(address indexed account, bool isExcluded);
1328     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1329 
1330     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1331 
1332     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1333 
1334     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1335 
1336     event SwapAndLiquify(
1337         uint256 tokensSwapped,
1338         uint256 ethReceived,
1339         uint256 tokensIntoLiqudity
1340     );
1341 
1342     event SendDividends(
1343     	uint256 tokensSwapped,
1344     	uint256 amount
1345     );
1346 
1347     event ProcessedDividendTracker(
1348     	uint256 iterations,
1349     	uint256 claims,
1350         uint256 lastProcessedIndex,
1351     	bool indexed automatic,
1352     	uint256 gas,
1353     	address indexed processor
1354     );
1355 
1356     constructor() public ERC20("Hyper Shiba Inu", "HSHIB") {
1357 
1358         address _newOwner = 0x24BEfE13C8A4CaB0F1Fe4Be51D9fF6dbF97aBF59;
1359     	dividendTracker = new HshibDividendTracker();
1360 
1361     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1362          // Create a uniswap pair for this new token
1363         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1364             .createPair(address(this), _uniswapV2Router.WETH());
1365 
1366         uniswapV2Router = _uniswapV2Router;
1367         uniswapV2Pair = _uniswapV2Pair;
1368 
1369         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1370 
1371         // exclude from receiving dividends
1372         dividendTracker.excludeFromDividends(address(dividendTracker));
1373         dividendTracker.excludeFromDividends(address(this));
1374         dividendTracker.excludeFromDividends(_newOwner);
1375         dividendTracker.excludeFromDividends(deadWallet);
1376         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1377 
1378         // exclude from paying fees or having max transaction amount
1379         excludeFromFees(_newOwner, true);
1380         excludeFromFees(_marketingWalletAddress, true);
1381         excludeFromFees(_buybackWalletAddress, true);
1382         excludeFromFees(address(this), true);
1383 
1384         _isExcludedFromAntiWhale[_newOwner]                 = true;
1385         _isExcludedFromAntiWhale[deadWallet]              = true;
1386         _isExcludedFromAntiWhale[address(this)]           = true;
1387 
1388         /*
1389             _mint is an internal function in ERC20.sol that is only called here,
1390             and CANNOT be called ever again
1391         */
1392         _mint(_newOwner, 1000000000000000 * (10**18));
1393     }
1394 
1395     modifier antiWhale(address sender, address recipient, uint256 amount) {
1396         if (enableAntiwhale && maxTransferAmount() > 0 && !automatedMarketMakerPairs[sender]) {
1397             if (
1398                 _isExcludedFromAntiWhale[sender] == false
1399                 && _isExcludedFromAntiWhale[recipient] == false
1400             ) {
1401                 require(amount <= maxTransferAmount(), "AntiWhale: Transfer amount exceeds the maxTransferAmount");
1402             }
1403         }
1404         _;
1405     }
1406 
1407     receive() external payable {
1408 
1409   	}
1410 
1411     function setExcludedFromAntiWhale(address account, bool exclude) public onlyOwner {
1412           _isExcludedFromAntiWhale[account] = exclude;
1413     }
1414 
1415     function isExcludedFromAntiWhale(address account) public view returns(bool) {
1416         return _isExcludedFromAntiWhale[account];
1417     }
1418 
1419     function updateDividendTracker(address newAddress) public onlyOwner {
1420         require(newAddress != address(dividendTracker), "HSHIB Token: The dividend tracker already has that address");
1421 
1422         HshibDividendTracker newDividendTracker = HshibDividendTracker(payable(newAddress));
1423 
1424         require(newDividendTracker.owner() == address(this), "HSHIB Token: The new dividend tracker must be owned by the HSHIB Token contract");
1425 
1426         newDividendTracker.excludeFromDividends(address(newDividendTracker));
1427         newDividendTracker.excludeFromDividends(address(this));
1428         newDividendTracker.excludeFromDividends(owner());
1429         newDividendTracker.excludeFromDividends(deadWallet);
1430         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
1431 
1432         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1433 
1434         dividendTracker = newDividendTracker;
1435     }
1436 
1437     function updateUniswapV2Router(address newAddress) public onlyOwner {
1438         require(newAddress != address(uniswapV2Router), "HSHIB Token: The router already has that address");
1439         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1440         uniswapV2Router = IUniswapV2Router02(newAddress);
1441         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1442             .createPair(address(this), uniswapV2Router.WETH());
1443         uniswapV2Pair = _uniswapV2Pair;
1444     }
1445 
1446     function excludeFromFees(address account, bool excluded) public onlyOwner {
1447         require(_isExcludedFromFees[account] != excluded, "HSHIB Token: Account is already the value of 'excluded'");
1448         _isExcludedFromFees[account] = excluded;
1449 
1450         emit ExcludeFromFees(account, excluded);
1451     }
1452 
1453     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1454         for(uint256 i = 0; i < accounts.length; i++) {
1455             _isExcludedFromFees[accounts[i]] = excluded;
1456         }
1457 
1458         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1459     }
1460 
1461     function setSwapTokensAtAmount(uint256 amount) external onlyOwner{
1462         swapTokensAtAmount = amount;
1463     }
1464 
1465     function setMarketingWallet(address payable wallet) external onlyOwner{
1466         _marketingWalletAddress = wallet;
1467     }
1468 
1469 
1470     function setUSDTRewardsFee(uint256 value) external onlyOwner{
1471         USDTRewardsFee = value;
1472         totalFees = USDTRewardsFee.add(marketingFee).add(buybackFee);
1473         require(totalFees < 20, "Total Fees should be < 20 !");
1474     }
1475 
1476     function setBuyBackFee(uint256 value) external onlyOwner{
1477         buybackFee = value;
1478         totalFees = USDTRewardsFee.add(marketingFee).add(buybackFee);
1479         require(totalFees < 20, "Total Fees should be < 20 !");
1480     }
1481 
1482     function setMarketingFee(uint256 value) external onlyOwner{
1483         marketingFee = value;
1484         totalFees = USDTRewardsFee.add(marketingFee).add(buybackFee);
1485         require(totalFees < 20, "Total Fees should be < 20 !");
1486     }
1487 
1488 
1489     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1490         require(pair != uniswapV2Pair, "HSHIB Token: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1491 
1492         _setAutomatedMarketMakerPair(pair, value);
1493     }
1494     
1495     function blacklistAddress(address account, bool value) external onlyOwner{
1496         _isBlacklisted[account] = value;
1497     }
1498 
1499     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1500         require(automatedMarketMakerPairs[pair] != value, "HSHIB Token: Automated market maker pair is already set to that value");
1501         automatedMarketMakerPairs[pair] = value;
1502 
1503         if(value) {
1504             dividendTracker.excludeFromDividends(pair);
1505         }
1506 
1507         emit SetAutomatedMarketMakerPair(pair, value);
1508     }
1509 
1510     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1511         require(newValue >= 200000 && newValue <= 500000, "HSHIB Token: gasForProcessing must be between 200,000 and 500,000");
1512         require(newValue != gasForProcessing, "HSHIB Token: Cannot update gasForProcessing to same value");
1513         emit GasForProcessingUpdated(newValue, gasForProcessing);
1514         gasForProcessing = newValue;
1515     }
1516 
1517     function updateClaimWait(uint256 claimWait) external onlyOwner {
1518         dividendTracker.updateClaimWait(claimWait);
1519     }
1520 
1521   
1522 
1523     function getClaimWait() external view returns(uint256) {
1524         return dividendTracker.claimWait();
1525     }
1526 
1527     function getTotalDividendsDistributed() external view returns (uint256) {
1528         return dividendTracker.totalDividendsDistributed();
1529     }
1530 
1531     function isExcludedFromFees(address account) public view returns(bool) {
1532         return _isExcludedFromFees[account];
1533     }
1534 
1535     function withdrawableDividendOf(address account) public view returns(uint256) {
1536     	return dividendTracker.withdrawableDividendOf(account);
1537   	}
1538 
1539 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
1540 		return dividendTracker.balanceOf(account);
1541 	}
1542 
1543 	function excludeFromDividends(address account) external onlyOwner{
1544 	    dividendTracker.excludeFromDividends(account);
1545 	}
1546 
1547     function getAccountDividendsInfo(address account)
1548         external view returns (
1549             address,
1550             int256,
1551             int256,
1552             uint256,
1553             uint256,
1554             uint256,
1555             uint256,
1556             uint256) {
1557         return dividendTracker.getAccount(account);
1558     }
1559 
1560 	function getAccountDividendsInfoAtIndex(uint256 index)
1561         external view returns (
1562             address,
1563             int256,
1564             int256,
1565             uint256,
1566             uint256,
1567             uint256,
1568             uint256,
1569             uint256) {
1570     	return dividendTracker.getAccountAtIndex(index);
1571     }
1572 
1573 	function processDividendTracker(uint256 gas) external {
1574 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1575 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, msg.sender);
1576     }
1577 
1578     function claim() external {
1579 		dividendTracker.processAccount(msg.sender, false);
1580     }
1581 
1582     function claimAddress(address claimee) external onlyOwner {
1583 		dividendTracker.processAccount(payable(claimee), false);
1584     }
1585 
1586     function getLastProcessedIndex() external view returns(uint256) {
1587     	return dividendTracker.getLastProcessedIndex();
1588     }
1589 
1590     function setLastProcessedIndex(uint256 index) external onlyOwner {
1591     	dividendTracker.setLastProcessedIndex(index);
1592     }
1593 
1594     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1595         return dividendTracker.getNumberOfTokenHolders();
1596     }
1597 
1598     function _transfer(
1599         address from,
1600         address to,
1601         uint256 amount
1602     ) internal override antiWhale(from,to,amount)  {
1603         require(from != address(0), "ERC20: transfer from the zero address");
1604         require(to != address(0), "ERC20: transfer to the zero address");
1605         require(!_isBlacklisted[from] && !_isBlacklisted[to], 'Blacklisted address');
1606 
1607         if(amount == 0) {
1608             super._transfer(from, to, 0);
1609             return;
1610         }
1611 
1612 		uint256 contractTokenBalance = balanceOf(address(this));
1613 
1614         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1615 
1616         if( canSwap &&
1617             !swapping &&
1618             !automatedMarketMakerPairs[from] &&
1619             from != owner() &&
1620             to != owner()
1621         ) {
1622             swapping = true;
1623 
1624             uint256 marketingTokens = contractTokenBalance.mul(marketingFee).div(totalFees);
1625             uint256 buybackTokens = contractTokenBalance.mul(buybackFee).div(totalFees);
1626             swapAndSendToMarketing(marketingTokens);
1627             swapAndSendToBuyBack(buybackTokens);
1628 
1629             uint256 sellTokens = balanceOf(address(this));
1630             swapAndSendDividends(sellTokens);
1631 
1632             swapping = false;
1633         }
1634 
1635         bool takeFee = !swapping;
1636 
1637         // if any account belongs to _isExcludedFromFee account then remove the fee
1638         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1639             takeFee = false;
1640         }
1641 
1642         if(takeFee) {
1643         	uint256 fees = amount.mul(totalFees).div(100);
1644         	amount = amount.sub(fees);
1645             super._transfer(from, address(this), fees);
1646         }
1647 
1648         super._transfer(from, to, amount);
1649 
1650         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1651         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1652 
1653         if(!swapping) {
1654 	    	uint256 gas = gasForProcessing;
1655 
1656 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1657 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, msg.sender);
1658 	    	}
1659 	    	catch {
1660 
1661 	    	}
1662         }
1663     }
1664     function setEnableAntiwhale(bool _val) public onlyOwner {
1665         enableAntiwhale = _val;
1666     }
1667 
1668       /**
1669     * @dev Returns the max transfer amount.
1670     */
1671     function maxTransferAmount() public view returns (uint256) {
1672         // we can either use a percentage of supply
1673         if(maxTransferAmountRate > 0){
1674             return totalSupply().mul(maxTransferAmountRate).div(1000000);
1675         }
1676         // or we can just set an actual number
1677         return totalSupply().mul(100).div(1000000);
1678     }
1679 
1680     function setMaxTransferAmountRate(uint256 _val) public onlyOwner {
1681         require(_val >= 100, "min 100");
1682         maxTransferAmountRate= _val;
1683     }
1684  
1685     function swapAndSendToMarketing(uint256 tokens) private  {
1686         uint256 initialBalance = IERC20(USDT).balanceOf(address(this));
1687         // swap tokens for USDT
1688         swapTokensForUSDT(tokens); 
1689         uint256 newBalance = IERC20(USDT).balanceOf(address(this)).sub(initialBalance);
1690         IERC20(USDT).transfer(_marketingWalletAddress, newBalance);
1691     }
1692 
1693     function swapAndSendToBuyBack(uint256 tokens) private  {
1694         uint256 initialBalance = IERC20(USDT).balanceOf(address(this));
1695         // swap tokens for USDT
1696         swapTokensForUSDT(tokens); 
1697         uint256 newBalance = IERC20(USDT).balanceOf(address(this)).sub(initialBalance);
1698         IERC20(USDT).transfer(_buybackWalletAddress, newBalance);
1699     }
1700 
1701     function swapTokensForUSDT(uint256 tokenAmount) private {
1702 
1703         address[] memory path = new address[](3);
1704         path[0] = address(this);
1705         path[1] = uniswapV2Router.WETH();
1706         path[2] = USDT;
1707 
1708         _approve(address(this), address(uniswapV2Router), tokenAmount);
1709 
1710         // make the swap
1711         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1712             tokenAmount,
1713             0,
1714             path,
1715             address(this),
1716             block.timestamp
1717         );
1718     }
1719 
1720 
1721 
1722 
1723     function swapAndSendDividends(uint256 tokens) private{
1724         swapTokensForUSDT(tokens);
1725         uint256 dividends = IERC20(USDT).balanceOf(address(this));
1726         bool success = IERC20(USDT).transfer(address(dividendTracker), dividends);
1727 
1728         if (success) {
1729             dividendTracker.distributeUSDTDividends(dividends);
1730             emit SendDividends(tokens, dividends);
1731         }
1732     }
1733 }
1734 
1735 contract HshibDividendTracker is Ownable, DividendPayingToken {
1736     using SafeMath for uint256;
1737     using SafeMathInt for int256;
1738     using IterableMapping for IterableMapping.Map;
1739 
1740     IterableMapping.Map private tokenHoldersMap;
1741     uint256 public lastProcessedIndex;
1742 
1743     mapping (address => bool) public excludedFromDividends;
1744 
1745     mapping (address => uint256) public lastClaimTimes;
1746 
1747     uint256 public claimWait;
1748     uint256 public immutable minimumTokenBalanceForDividends;
1749 
1750     event ExcludeFromDividends(address indexed account);
1751     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1752 
1753     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1754 
1755     constructor() public DividendPayingToken("Hshib Reward Tracker", "HSHIBDividendTracker") {
1756     	claimWait = 3600;
1757         minimumTokenBalanceForDividends = 200000 * (10**18); //must hold 200000+ tokens
1758     }
1759 
1760     function _transfer(address, address, uint256) internal override {
1761         require(false, "HSHIB_Reward_Tracker: No transfers allowed");
1762     }
1763 
1764     function withdrawDividend() public override {
1765         require(false, "HSHIB_Reward_Tracker: withdrawDividend disabled. Use the 'claim' function on the main HSHIB contract.");
1766     }
1767 
1768     function excludeFromDividends(address account) external onlyOwner {
1769     	require(!excludedFromDividends[account]);
1770     	excludedFromDividends[account] = true;
1771 
1772     	_setBalance(account, 0);
1773     	tokenHoldersMap.remove(account);
1774 
1775     	emit ExcludeFromDividends(account);
1776     }
1777 
1778     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1779         require(newClaimWait >= 3600 && newClaimWait <= 86400, "Hshib_Reward_Tracker: claimWait must be updated to between 1 and 24 hours");
1780         require(newClaimWait != claimWait, "Hshib_Reward_Tracker: Cannot update claimWait to same value");
1781         emit ClaimWaitUpdated(newClaimWait, claimWait);
1782         claimWait = newClaimWait;
1783     }
1784 
1785     function setLastProcessedIndex(uint256 index) external onlyOwner {
1786     	lastProcessedIndex = index;
1787     }
1788 
1789     function getLastProcessedIndex() external view returns(uint256) {
1790     	return lastProcessedIndex;
1791     }
1792 
1793     function getNumberOfTokenHolders() external view returns(uint256) {
1794         return tokenHoldersMap.keys.length;
1795     }
1796 
1797 
1798 
1799     function getAccount(address _account)
1800         public view returns (
1801             address account,
1802             int256 index,
1803             int256 iterationsUntilProcessed,
1804             uint256 withdrawableDividends,
1805             uint256 totalDividends,
1806             uint256 lastClaimTime,
1807             uint256 nextClaimTime,
1808             uint256 secondsUntilAutoClaimAvailable) {
1809         account = _account;
1810 
1811         index = tokenHoldersMap.getIndexOfKey(account);
1812 
1813         iterationsUntilProcessed = -1;
1814 
1815         if(index >= 0) {
1816             if(uint256(index) > lastProcessedIndex) {
1817                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1818             }
1819             else {
1820                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1821                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1822                                                         0;
1823 
1824 
1825                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1826             }
1827         }
1828 
1829 
1830         withdrawableDividends = withdrawableDividendOf(account);
1831         totalDividends = accumulativeDividendOf(account);
1832 
1833         lastClaimTime = lastClaimTimes[account];
1834 
1835         nextClaimTime = lastClaimTime > 0 ?
1836                                     lastClaimTime.add(claimWait) :
1837                                     0;
1838 
1839         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1840                                                     nextClaimTime.sub(block.timestamp) :
1841                                                     0;
1842     }
1843 
1844     function getAccountAtIndex(uint256 index)
1845         public view returns (
1846             address,
1847             int256,
1848             int256,
1849             uint256,
1850             uint256,
1851             uint256,
1852             uint256,
1853             uint256) {
1854     	if(index >= tokenHoldersMap.size()) {
1855             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1856         }
1857 
1858         address account = tokenHoldersMap.getKeyAtIndex(index);
1859 
1860         return getAccount(account);
1861     }
1862 
1863     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1864     	if(lastClaimTime > block.timestamp)  {
1865     		return false;
1866     	}
1867 
1868     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1869     }
1870 
1871     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1872     	if(excludedFromDividends[account]) {
1873     		return;
1874     	}
1875 
1876     	if(newBalance >= minimumTokenBalanceForDividends) {
1877             _setBalance(account, newBalance);
1878     		tokenHoldersMap.set(account, newBalance);
1879     	}
1880     	else {
1881             _setBalance(account, 0);
1882     		tokenHoldersMap.remove(account);
1883     	}
1884 
1885     	processAccount(account, true);
1886     }
1887 
1888     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1889     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1890 
1891     	if(numberOfTokenHolders == 0) {
1892     		return (0, 0, lastProcessedIndex);
1893     	}
1894 
1895     	uint256 _lastProcessedIndex = lastProcessedIndex;
1896 
1897     	uint256 gasUsed = 0;
1898 
1899     	uint256 gasLeft = gasleft();
1900 
1901     	uint256 iterations = 0;
1902     	uint256 claims = 0;
1903 
1904     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1905     		_lastProcessedIndex++;
1906 
1907     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1908     			_lastProcessedIndex = 0;
1909     		}
1910 
1911     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1912 
1913     		if(canAutoClaim(lastClaimTimes[account])) {
1914     			if(processAccount(payable(account), true)) {
1915     				claims++;
1916     			}
1917     		}
1918 
1919     		iterations++;
1920 
1921     		uint256 newGasLeft = gasleft();
1922 
1923     		if(gasLeft > newGasLeft) {
1924     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1925     		}
1926 
1927     		gasLeft = newGasLeft;
1928     	}
1929 
1930     	lastProcessedIndex = _lastProcessedIndex;
1931 
1932     	return (iterations, claims, lastProcessedIndex);
1933     }
1934 
1935     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1936         uint256 amount = _withdrawDividendOfUser(account);
1937 
1938     	if(amount > 0) {
1939     		lastClaimTimes[account] = block.timestamp;
1940             emit Claim(account, amount, automatic);
1941     		return true;
1942     	}
1943 
1944     	return false;
1945     }
1946 }