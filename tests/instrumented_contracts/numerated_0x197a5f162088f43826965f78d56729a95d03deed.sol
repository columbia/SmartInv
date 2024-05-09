1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity 0.5.12;
15 pragma experimental ABIEncoderV2;
16 
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations with added overflow
20  * checks.
21  *
22  * Arithmetic operations in Solidity wrap on overflow. This can easily result
23  * in bugs, because programmers usually assume that an overflow raises an
24  * error, which is the standard behavior in high level programming languages.
25  * `SafeMath` restores this intuition by reverting the transaction when an
26  * operation overflows.
27  *
28  * Using this library instead of the unchecked operations eliminates an entire
29  * class of bugs, so it's recommended to use it always.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, reverting on
34      * overflow.
35      *
36      * Counterpart to Solidity's `+` operator.
37      *
38      * Requirements:
39      * - Addition cannot overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      *
70      * _Available since v2.4.0._
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      *
128      * _Available since v2.4.0._
129      */
130     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         // Solidity only automatically asserts when dividing by 0
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return mod(a, b, "SafeMath: modulo by zero");
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts with custom message when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      *
165      * _Available since v2.4.0._
166      */
167     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b != 0, errorMessage);
169         return a % b;
170     }
171 }
172 
173 /*
174  * @dev Provides information about the current execution context, including the
175  * sender of the transaction and its data. While these are generally available
176  * via msg.sender and msg.data, they should not be accessed in such a direct
177  * manner, since when dealing with GSN meta-transactions the account sending and
178  * paying for execution may not be the actual sender (as far as an application
179  * is concerned).
180  *
181  * This contract is only required for intermediate, library-like contracts.
182  */
183 contract Context {
184     // Empty internal constructor, to prevent people from mistakenly deploying
185     // an instance of this contract, which should be used via inheritance.
186     constructor () internal {}
187     // solhint-disable-previous-line no-empty-blocks
188 
189     function _msgSender() internal view returns (address _payable) {
190         return msg.sender;
191     }
192 
193     function _msgData() internal view returns (bytes memory) {
194         this;
195         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
196         return msg.data;
197     }
198 }
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor () internal {
218         address msgSender = _msgSender();
219         _owner = msgSender;
220         emit OwnershipTransferred(address(0), msgSender);
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if called by any account other than the owner.
232      */
233     modifier onlyOwner() {
234         require(isOwner(), "Ownable: caller is not the owner");
235         _;
236     }
237 
238     /**
239      * @dev Returns true if the caller is the current owner.
240      */
241     function isOwner() public view returns (bool) {
242         return _msgSender() == _owner;
243     }
244 
245     /**
246      * @dev Leaves the contract without owner. It will not be possible to call
247      * `onlyOwner` functions anymore. Can only be called by the current owner.
248      *
249      * NOTE: Renouncing ownership will leave the contract without an owner,
250      * thereby removing any functionality that is only available to the owner.
251      */
252     function renounceOwnership() public onlyOwner {
253         emit OwnershipTransferred(_owner, address(0));
254         _owner = address(0);
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public onlyOwner {
262         _transferOwnership(newOwner);
263     }
264 
265     /**
266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
267      */
268     function _transferOwnership(address newOwner) internal {
269         require(newOwner != address(0), "Ownable: new owner is the zero address");
270         emit OwnershipTransferred(_owner, newOwner);
271         _owner = newOwner;
272     }
273 }
274 
275 interface PoolInterface {
276     function swapExactAmountIn(address, address, address, uint, address, uint) external returns (uint, uint);
277 
278     function swapExactAmountOut(address, address, uint, address, uint, address, uint) external returns (uint, uint);
279 
280     function calcInGivenOut(uint, uint, uint, uint, uint, uint) external pure returns (uint);
281 
282     function calcOutGivenIn(uint, uint, uint, uint, uint, uint) external pure returns (uint);
283 
284     function getDenormalizedWeight(address) external view returns (uint);
285 
286     function getBalance(address) external view returns (uint);
287 
288     function getSwapFee() external view returns (uint);
289 
290     function gulp(address) external;
291 
292     function calcDesireByGivenAmount(address, address, uint256, uint256) view external returns (uint);
293 
294     function calcPoolSpotPrice(address, address, uint256, uint256) external view returns (uint256);
295 }
296 
297 interface TokenInterface {
298     function balanceOf(address) external view returns (uint);
299 
300     function allowance(address, address) external view returns (uint);
301 
302     function approve(address, uint) external returns (bool);
303 
304     function transfer(address, uint) external returns (bool);
305 
306     function transferFrom(address, address, uint) external returns (bool);
307 
308     function deposit() external payable;
309 
310     function withdraw(uint) external;
311 }
312 
313 interface RegistryInterface {
314     function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
315 }
316 
317 contract ExchangeProxy is Ownable {
318 
319     using SafeMath for uint256;
320 
321     struct Pool {
322         address pool;
323         uint tokenBalanceIn;
324         uint tokenWeightIn;
325         uint tokenBalanceOut;
326         uint tokenWeightOut;
327         uint swapFee;
328         uint effectiveLiquidity;
329     }
330 
331     struct Swap {
332         address pool;
333         address tokenIn;
334         address tokenOut;
335         uint swapAmount; // tokenInAmount / tokenOutAmount
336         uint limitReturnAmount; // minAmountOut / maxAmountIn
337         uint maxPrice;
338     }
339 
340     TokenInterface weth;
341     RegistryInterface registry;
342     address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
343     uint private constant BONE = 10 ** 18;
344 
345     constructor(address _weth) public {
346         weth = TokenInterface(_weth);
347     }
348 
349     function setRegistry(address _registry) external onlyOwner {
350         registry = RegistryInterface(_registry);
351     }
352 
353     function batchSwapExactIn(
354         Swap[] memory swaps,
355         TokenInterface tokenIn,
356         TokenInterface tokenOut,
357         uint totalAmountIn,
358         uint minTotalAmountOut
359     )
360     public payable
361     returns (uint totalAmountOut)
362     {
363         address from = msg.sender;
364         if (isETH(tokenIn)) {
365             require(msg.value >= totalAmountIn, "ERROR_ETH_IN");
366             weth.deposit.value(totalAmountIn)();
367             from = address(this);
368         }
369         uint _totalSwapIn = 0;
370         for (uint i = 0; i < swaps.length; i++) {
371             Swap memory swap = swaps[i];
372             require(swap.tokenIn == address(tokenIn) || (swap.tokenIn == address(weth) && isETH(tokenIn)), "ERR_TOKENIN_NOT_MATCH");
373             safeTransferFrom(swap.tokenIn, from, swap.pool, swap.swapAmount);
374             address _to = (swap.tokenOut == address(weth) && isETH(tokenOut)) ? address(this) : msg.sender;
375             PoolInterface pool = PoolInterface(swap.pool);
376             (uint tokenAmountOut,) = pool.swapExactAmountIn(
377                 msg.sender,
378                 swap.tokenIn,
379                 swap.tokenOut,
380                 swap.limitReturnAmount,
381                 _to,
382                 swap.maxPrice
383             );
384             if (_to != msg.sender) {
385                 transferAll(tokenOut, tokenAmountOut);
386             }
387             totalAmountOut = tokenAmountOut.add(totalAmountOut);
388             _totalSwapIn = _totalSwapIn.add(swap.swapAmount);
389         }
390         require(_totalSwapIn == totalAmountIn, "ERR_TOTAL_AMOUNT_IN");
391         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
392         if (isETH(tokenIn) && msg.value > _totalSwapIn) {
393             (bool xfer,) = msg.sender.call.value(msg.value.sub(_totalSwapIn))("");
394             require(xfer, "ERR_ETH_FAILED");
395         }
396     }
397 
398     function batchSwapExactOut(
399         Swap[] memory swaps,
400         TokenInterface tokenIn,
401         TokenInterface tokenOut,
402         uint maxTotalAmountIn
403     )
404     public payable
405     returns (uint totalAmountIn)
406     {
407         address from = msg.sender;
408         if (isETH(tokenIn)) {
409             weth.deposit.value(msg.value)();
410             from = address(this);
411         }
412         for (uint i = 0; i < swaps.length; i++) {
413             Swap memory swap = swaps[i];
414             uint tokenAmountIn = getAmountIn(swap);
415             swap.tokenIn = isETH(tokenIn) ? address(weth) : swap.tokenIn;
416             safeTransferFrom(swap.tokenIn, from, swap.pool, tokenAmountIn);
417             address _to = (swap.tokenOut == address(weth) && isETH(tokenOut)) ? address(this) : msg.sender;
418             PoolInterface pool = PoolInterface(swap.pool);
419             pool.swapExactAmountOut(
420                 msg.sender,
421                 swap.tokenIn,
422                 swap.limitReturnAmount,
423                 swap.tokenOut,
424                 swap.swapAmount,
425                 _to,
426                 swap.maxPrice
427             );
428             if (_to != msg.sender) {
429                 transferAll(tokenOut, swap.swapAmount);
430             }
431             totalAmountIn = tokenAmountIn.add(totalAmountIn);
432         }
433         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
434         if (isETH(tokenIn) && msg.value > totalAmountIn) {
435             transferAll(tokenIn, msg.value.sub(totalAmountIn));
436         }
437     }
438 
439     function multihopBatchSwapExactIn(
440         Swap[][] memory swapSequences,
441         TokenInterface tokenIn,
442         TokenInterface tokenOut,
443         uint totalAmountIn,
444         uint minTotalAmountOut
445     )
446     public payable
447     returns (uint totalAmountOut)
448     {
449         uint totalSwapAmount = 0;
450         address from = msg.sender;
451         if (isETH(tokenIn)) {
452             require(msg.value >= totalAmountIn, "ERROR_ETH_IN");
453             weth.deposit.value(totalAmountIn)();
454             from = address(this);
455         }
456         for (uint i = 0; i < swapSequences.length; i++) {
457             totalSwapAmount = totalSwapAmount.add(swapSequences[i][0].swapAmount);
458             require(swapSequences[i][0].tokenIn == address(tokenIn) || (isETH(tokenIn) && swapSequences[i][0].tokenIn == address(weth)), "ERR_TOKENIN_NOT_MATCH");
459             safeTransferFrom(swapSequences[i][0].tokenIn, from, swapSequences[i][0].pool, swapSequences[i][0].swapAmount);
460 
461             uint tokenAmountOut;
462             for (uint k = 0; k < swapSequences[i].length; k++) {
463                 Swap memory swap = swapSequences[i][k];
464                 PoolInterface pool = PoolInterface(swap.pool);
465                 address _to;
466                 if (k < swapSequences[i].length - 1) {
467                     _to = swapSequences[i][k + 1].pool;
468                 } else {
469                     require(swap.tokenOut == address(tokenOut) || (swap.tokenOut == address(weth) && isETH(tokenOut)), "ERR_OUTCOIN_NOT_MATCH");
470                     _to = (swap.tokenOut == address(weth) && isETH(tokenOut)) ? address(this) : msg.sender;
471                 }
472                 (tokenAmountOut,) = pool.swapExactAmountIn(
473                     msg.sender,
474                     swap.tokenIn,
475                     swap.tokenOut,
476                     swap.limitReturnAmount,
477                     _to,
478                     swap.maxPrice
479                 );
480                 if (k == swapSequences[i].length - 1 && _to != msg.sender) {
481                     transferAll(tokenOut, tokenAmountOut);
482                 }
483             }
484             // This takes the amountOut of the last swap
485             totalAmountOut = tokenAmountOut.add(totalAmountOut);
486         }
487         require(totalSwapAmount == totalAmountIn, "ERR_TOTAL_AMOUNT_IN");
488         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
489         if (isETH(tokenIn) && msg.value > totalSwapAmount) {
490             (bool xfer,) = msg.sender.call.value(msg.value.sub(totalAmountIn))("");
491             require(xfer, "ERR_ETH_FAILED");
492         }
493     }
494 
495     function multihopBatchSwapExactOut(
496         Swap[][] memory swapSequences,
497         TokenInterface tokenIn,
498         TokenInterface tokenOut,
499         uint maxTotalAmountIn
500     )
501     public payable
502     returns (uint totalAmountIn)
503     {
504         address from = msg.sender;
505         if (isETH(tokenIn)) {
506             require(msg.value >= maxTotalAmountIn, "ERROR_ETH_IN");
507             weth.deposit.value(msg.value)();
508             from = address(this);
509         }
510 
511         for (uint i = 0; i < swapSequences.length; i++) {
512             uint[] memory amountIns = getAmountsIn(swapSequences[i]);
513             swapSequences[i][0].tokenIn = isETH(tokenIn) ? address(weth) : swapSequences[i][0].tokenIn;
514             safeTransferFrom(swapSequences[i][0].tokenIn, from, swapSequences[i][0].pool, amountIns[0]);
515 
516             for (uint j = 0; j < swapSequences[i].length; j++) {
517                 Swap memory swap = swapSequences[i][j];
518                 PoolInterface pool = PoolInterface(swap.pool);
519                 address _to;
520                 if (j < swapSequences[i].length - 1) {
521                     _to = swapSequences[i][j + 1].pool;
522                 } else {
523                     require(swap.tokenOut == address(tokenOut) || (swap.tokenOut == address(weth) && isETH(tokenOut)), "ERR_OUTCOIN_NOT_MATCH");
524                     _to = (swap.tokenOut == address(weth) && isETH(tokenOut)) ? address(this) : msg.sender;
525                 }
526                 uint _tokenOut = j < swapSequences[i].length - 1 ? amountIns[j + 1] : swap.swapAmount;
527                 pool.swapExactAmountOut(
528                     msg.sender,
529                     swap.tokenIn,
530                     amountIns[j],
531                     swap.tokenOut,
532                     _tokenOut,
533                     _to,
534                     swap.maxPrice
535                 );
536                 if (j == swapSequences[i].length - 1 && _to != msg.sender) {
537                     transferAll(tokenOut, _tokenOut);
538                 }
539             }
540             totalAmountIn = totalAmountIn.add(amountIns[0]);
541         }
542         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
543         if (isETH(tokenIn) && msg.value > totalAmountIn) {
544             transferAll(tokenIn, msg.value.sub(totalAmountIn));
545         }
546     }
547 
548     function getBalance(TokenInterface token) internal view returns (uint) {
549         if (isETH(token)) {
550             return weth.balanceOf(address(this));
551         } else {
552             return token.balanceOf(address(this));
553         }
554     }
555 
556     function transferAll(TokenInterface token, uint amount) internal{
557         if (amount == 0) {
558             return;
559         }
560 
561         if (isETH(token)) {
562             weth.withdraw(amount);
563             (bool xfer,) = msg.sender.call.value(amount)("");
564             require(xfer, "ERR_ETH_FAILED");
565         } else {
566             safeTransfer(address(token), msg.sender, amount);
567         }
568     }
569 
570     function isETH(TokenInterface token) internal pure returns (bool) {
571         return (address(token) == ETH_ADDRESS);
572     }
573 
574     function safeApprove(
575         address token,
576         address to,
577         uint256 value
578     ) internal {
579         // bytes4(keccak256(bytes('approve(address,uint256)')));
580         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
581         require(
582             success && (data.length == 0 || abi.decode(data, (bool))),
583             'TransferHelper::safeApprove: approve failed'
584         );
585     }
586 
587     function safeTransfer(
588         address token,
589         address to,
590         uint256 value
591     ) internal {
592         // bytes4(keccak256(bytes('transfer(address,uint256)')));
593         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
594         require(
595             success && (data.length == 0 || abi.decode(data, (bool))),
596             'TransferHelper::safeTransfer: transfer failed'
597         );
598     }
599 
600     function safeTransferFrom(
601         address token,
602         address from,
603         address to,
604         uint256 value
605     ) internal {
606         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
607         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
608         require(
609             success && (data.length == 0 || abi.decode(data, (bool))),
610             'TransferHelper::transferFrom: transferFrom failed'
611         );
612     }
613 
614     // given an output amount of an asset and pool, returns a required input amount of the other asset
615     function getAmountIn(Swap memory swap) internal view returns (uint amountIn) {
616         require(swap.swapAmount > 0, 'ExchangeProxy: INSUFFICIENT_OUTPUT_AMOUNT');
617         PoolInterface pool = PoolInterface(swap.pool);
618         amountIn = pool.calcDesireByGivenAmount(
619             swap.tokenIn,
620             swap.tokenOut,
621             0,
622             swap.swapAmount
623         );
624         uint256 spotPrice = pool.calcPoolSpotPrice(
625             swap.tokenIn,
626             swap.tokenOut,
627             0,
628             0
629         );
630         require(spotPrice <= swap.maxPrice, "ERR_LIMIT_PRICE");
631     }
632 
633     // performs chained getAmountIn calculations on any number of pools
634     function getAmountsIn(Swap[] memory swaps) internal view returns (uint[] memory amounts) {
635         require(swaps.length >= 1, 'ExchangeProxy: INVALID_PATH');
636         amounts = new uint[](swaps.length);
637         uint i = swaps.length - 1;
638         while (i > 0) {
639             Swap memory swap = swaps[i];
640             amounts[i] = getAmountIn(swap);
641             require(swaps[i].tokenIn == swaps[i - 1].tokenOut, "ExchangeProxy: INVALID_PATH");
642             swaps[i - 1].swapAmount = amounts[i];
643             i--;
644         }
645         amounts[0] = getAmountIn(swaps[0]);
646     }
647 
648     function() external payable {}
649 
650 }