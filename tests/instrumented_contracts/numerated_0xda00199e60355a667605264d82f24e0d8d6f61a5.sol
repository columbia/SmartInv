1 pragma solidity 0.5.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 contract Context {
171     // Empty internal constructor, to prevent people from mistakenly deploying
172     // an instance of this contract, which should be used via inheritance.
173     constructor () internal { }
174     // solhint-disable-previous-line no-empty-blocks
175 
176     function _msgSender() internal view returns (address _payable) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view returns (bytes memory) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 /**
187  * @dev Contract module which provides a basic access control mechanism, where
188  * there is an account (an owner) that can be granted exclusive access to
189  * specific functions.
190  *
191  * This module is used through inheritance. It will make available the modifier
192  * `onlyOwner`, which can be applied to your functions to restrict their use to
193  * the owner.
194  */
195 contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     /**
201      * @dev Initializes the contract setting the deployer as the initial owner.
202      */
203     constructor () internal {
204         address msgSender = _msgSender();
205         _owner = msgSender;
206         emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(isOwner(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     /**
225      * @dev Returns true if the caller is the current owner.
226      */
227     function isOwner() public view returns (bool) {
228         return _msgSender() == _owner;
229     }
230 
231     /**
232      * @dev Leaves the contract without owner. It will not be possible to call
233      * `onlyOwner` functions anymore. Can only be called by the current owner.
234      *
235      * NOTE: Renouncing ownership will leave the contract without an owner,
236      * thereby removing any functionality that is only available to the owner.
237      */
238     function renounceOwnership() public onlyOwner {
239         emit OwnershipTransferred(_owner, address(0));
240         _owner = address(0);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Can only be called by the current owner.
246      */
247     function transferOwnership(address newOwner) public onlyOwner {
248         _transferOwnership(newOwner);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      */
254     function _transferOwnership(address newOwner) internal {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         emit OwnershipTransferred(_owner, newOwner);
257         _owner = newOwner;
258     }
259 }
260 
261 interface PoolInterface {
262     function swapExactAmountIn(address, address, uint, address, uint, uint) external returns (uint, uint);
263     function swapExactAmountOut(address, address, uint, address, uint, uint) external returns (uint, uint);
264     function calcInGivenOut(uint, uint, uint, uint, uint, uint) external pure returns (uint);
265     function calcOutGivenIn(uint, uint, uint, uint, uint, uint) external pure returns (uint);
266     function getDenormalizedWeight(address) external view returns (uint);
267     function getBalance(address) external view returns (uint);
268     function getSwapFee() external view returns (uint);
269     function gulp(address) external;
270 }
271 
272 interface TokenInterface {
273     function balanceOf(address) external view returns (uint);
274     function allowance(address, address) external view returns (uint);
275     function approve(address, uint) external returns (bool);
276     function transfer(address, uint) external returns (bool);
277     function transferFrom(address, address, uint) external returns (bool);
278     function deposit() external payable;
279     function withdraw(uint) external;
280 }
281 
282 interface RegistryInterface {
283     function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
284 }
285 
286 contract ExchangeProxy is Ownable {
287 
288     using SafeMath for uint256;
289 
290     struct Pool {
291         address pool;
292         uint    tokenBalanceIn;
293         uint    tokenWeightIn;
294         uint    tokenBalanceOut;
295         uint    tokenWeightOut;
296         uint    swapFee;
297         uint    effectiveLiquidity;
298     }
299 
300     struct Swap {
301         address pool;
302         address tokenIn;
303         address tokenOut;
304         uint    swapAmount; // tokenInAmount / tokenOutAmount
305         uint    limitReturnAmount; // minAmountOut / maxAmountIn
306         uint    maxPrice;
307     }
308 
309     TokenInterface weth;
310     RegistryInterface registry;
311     address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
312     uint private constant BONE = 10**18;
313 
314     constructor(address _weth) public {
315         weth = TokenInterface(_weth);
316     }
317 
318     function setRegistry(address _registry) external onlyOwner {
319         registry = RegistryInterface(_registry);
320     }
321 
322     function batchSwapExactIn(
323         Swap[] memory swaps,
324         TokenInterface tokenIn,
325         TokenInterface tokenOut,
326         uint totalAmountIn,
327         uint minTotalAmountOut
328     )
329     public payable
330     returns (uint totalAmountOut)
331     {
332         transferFromAll(tokenIn, totalAmountIn);
333 
334         for (uint i = 0; i < swaps.length; i++) {
335             Swap memory swap = swaps[i];
336             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
337             PoolInterface pool = PoolInterface(swap.pool);
338 
339             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
340                 safeApprove(SwapTokenIn, swap.pool, 0);
341             }
342             safeApprove(SwapTokenIn, swap.pool, swap.swapAmount);
343 
344             (uint tokenAmountOut,) = pool.swapExactAmountIn(
345                 msg.sender,
346                 swap.tokenIn,
347                 swap.swapAmount,
348                 swap.tokenOut,
349                 swap.limitReturnAmount,
350                 swap.maxPrice
351             );
352             totalAmountOut = tokenAmountOut.add(totalAmountOut);
353         }
354 
355         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
356 
357         transferAll(tokenOut, totalAmountOut);
358         transferAll(tokenIn, getBalance(tokenIn));
359     }
360 
361     function batchSwapExactOut(
362         Swap[] memory swaps,
363         TokenInterface tokenIn,
364         TokenInterface tokenOut,
365         uint maxTotalAmountIn
366     )
367     public payable
368     returns (uint totalAmountIn)
369     {
370         transferFromAll(tokenIn, maxTotalAmountIn);
371 
372         for (uint i = 0; i < swaps.length; i++) {
373             Swap memory swap = swaps[i];
374             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
375             PoolInterface pool = PoolInterface(swap.pool);
376 
377             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
378                 safeApprove(SwapTokenIn, swap.pool, 0);
379             }
380             safeApprove(SwapTokenIn, swap.pool, swap.limitReturnAmount);
381 
382             (uint tokenAmountIn,) = pool.swapExactAmountOut(
383                 msg.sender,
384                 swap.tokenIn,
385                 swap.limitReturnAmount,
386                 swap.tokenOut,
387                 swap.swapAmount,
388                 swap.maxPrice
389             );
390             totalAmountIn = tokenAmountIn.add(totalAmountIn);
391             pool.gulp(swap.tokenIn);
392         }
393         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
394 
395         transferAll(tokenOut, getBalance(tokenOut));
396         transferAll(tokenIn, getBalance(tokenIn));
397 
398     }
399 
400     function multihopBatchSwapExactIn(
401         Swap[][] memory swapSequences,
402         TokenInterface tokenIn,
403         TokenInterface tokenOut,
404         uint totalAmountIn,
405         uint minTotalAmountOut
406     )
407     public payable
408     returns (uint totalAmountOut)
409     {
410 
411         transferFromAll(tokenIn, totalAmountIn);
412 
413         for (uint i = 0; i < swapSequences.length; i++) {
414             uint tokenAmountOut;
415             for (uint k = 0; k < swapSequences[i].length; k++) {
416                 Swap memory swap = swapSequences[i][k];
417                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
418                 if (k == 1) {
419                     // Makes sure that on the second swap the output of the first was used
420                     // so there is not intermediate token leftover
421                     swap.swapAmount = tokenAmountOut;
422                 }
423 
424                 PoolInterface pool = PoolInterface(swap.pool);
425                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
426                     safeApprove(SwapTokenIn, swap.pool, 0);
427                 }
428                 safeApprove(SwapTokenIn, swap.pool, swap.swapAmount);
429 
430                 (tokenAmountOut,) = pool.swapExactAmountIn(
431                     msg.sender,
432                     swap.tokenIn,
433                     swap.swapAmount,
434                     swap.tokenOut,
435                     swap.limitReturnAmount,
436                     swap.maxPrice
437                 );
438             }
439             // This takes the amountOut of the last swap
440             totalAmountOut = tokenAmountOut.add(totalAmountOut);
441         }
442 
443         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
444 
445         transferAll(tokenOut, totalAmountOut);
446         transferAll(tokenIn, getBalance(tokenIn));
447 
448     }
449 
450     function multihopBatchSwapExactOut(
451         Swap[][] memory swapSequences,
452         TokenInterface tokenIn,
453         TokenInterface tokenOut,
454         uint maxTotalAmountIn
455     )
456     public payable
457     returns (uint totalAmountIn)
458     {
459 
460         transferFromAll(tokenIn, maxTotalAmountIn);
461 
462         for (uint i = 0; i < swapSequences.length; i++) {
463             uint tokenAmountInFirstSwap;
464             // Specific code for a simple swap and a multihop (2 swaps in sequence)
465             if (swapSequences[i].length == 1) {
466                 Swap memory swap = swapSequences[i][0];
467                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
468 
469                 PoolInterface pool = PoolInterface(swap.pool);
470                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
471                     safeApprove(SwapTokenIn, swap.pool, 0);
472                 }
473                 safeApprove(SwapTokenIn, swap.pool, swap.limitReturnAmount);
474 
475                 (tokenAmountInFirstSwap,) = pool.swapExactAmountOut(
476                     msg.sender,
477                     swap.tokenIn,
478                     swap.limitReturnAmount,
479                     swap.tokenOut,
480                     swap.swapAmount,
481                     swap.maxPrice
482                 );
483                 pool.gulp(swap.tokenIn);
484             } else {
485                 // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
486                 // of token C. But first we need to buy B with A so we can then buy C with B
487                 // To get the exact amount of C we then first need to calculate how much B we'll need:
488                 uint intermediateTokenAmount; // This would be token B as described above
489                 Swap memory secondSwap = swapSequences[i][1];
490                 PoolInterface poolSecondSwap = PoolInterface(secondSwap.pool);
491                 intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
492                     poolSecondSwap.getBalance(secondSwap.tokenIn),
493                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
494                     poolSecondSwap.getBalance(secondSwap.tokenOut),
495                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
496                     secondSwap.swapAmount,
497                     poolSecondSwap.getSwapFee()
498                 );
499 
500                 //// Buy intermediateTokenAmount of token B with A in the first pool
501                 Swap memory firstSwap = swapSequences[i][0];
502                 TokenInterface FirstSwapTokenIn = TokenInterface(firstSwap.tokenIn);
503                 PoolInterface poolFirstSwap = PoolInterface(firstSwap.pool);
504                 if (FirstSwapTokenIn.allowance(address(this), firstSwap.pool) < uint(-1)) {
505                     safeApprove(FirstSwapTokenIn, firstSwap.pool, uint(-1));
506                 }
507 
508                 (tokenAmountInFirstSwap,) = poolFirstSwap.swapExactAmountOut(
509                     msg.sender,
510                     firstSwap.tokenIn,
511                     firstSwap.limitReturnAmount,
512                     firstSwap.tokenOut,
513                     intermediateTokenAmount, // This is the amount of token B we need
514                     firstSwap.maxPrice
515                 );
516                 poolFirstSwap.gulp(firstSwap.tokenIn);
517 
518                 //// Buy the final amount of token C desired
519                 TokenInterface SecondSwapTokenIn = TokenInterface(secondSwap.tokenIn);
520                 if (SecondSwapTokenIn.allowance(address(this), secondSwap.pool) < uint(-1)) {
521                     safeApprove(SecondSwapTokenIn, secondSwap.pool, uint(-1));
522                 }
523 
524                 poolSecondSwap.swapExactAmountOut(
525                     msg.sender,
526                     secondSwap.tokenIn,
527                     secondSwap.limitReturnAmount,
528                     secondSwap.tokenOut,
529                     secondSwap.swapAmount,
530                     secondSwap.maxPrice
531                 );
532                 poolSecondSwap.gulp(secondSwap.tokenIn);
533             }
534             totalAmountIn = tokenAmountInFirstSwap.add(totalAmountIn);
535         }
536 
537         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
538 
539         transferAll(tokenOut, getBalance(tokenOut));
540         transferAll(tokenIn, getBalance(tokenIn));
541 
542     }
543 
544 
545     function transferFromAll(TokenInterface token, uint amount) internal returns(bool) {
546         if (isETH(token)) {
547             weth.deposit.value(msg.value)();
548         } else {
549             //            require(token.transferFrom(msg.sender, address(this), amount), "ERR_TRANSFER_FAILED");
550             safeTransferFrom(token, msg.sender, address(this), amount);
551         }
552     }
553 
554     function getBalance(TokenInterface token) internal view returns (uint) {
555         if (isETH(token)) {
556             return weth.balanceOf(address(this));
557         } else {
558             return token.balanceOf(address(this));
559         }
560     }
561 
562     function transferAll(TokenInterface token, uint amount) internal returns(bool) {
563         if (amount == 0) {
564             return true;
565         }
566 
567         if (isETH(token)) {
568             weth.withdraw(amount);
569             (bool xfer,) = msg.sender.call.value(amount)("");
570             require(xfer, "ERR_ETH_FAILED");
571         } else {
572             //            require(token.transfer(msg.sender, amount), "ERR_TRANSFER_FAILED");
573             safeTransfer(token, msg.sender, amount);
574         }
575     }
576 
577     function isETH(TokenInterface token) internal pure returns(bool) {
578         return (address(token) == ETH_ADDRESS);
579     }
580 
581     function safeTransfer(TokenInterface token, address to , uint256 amount) internal {
582         bytes memory data = abi.encodeWithSelector(token.transfer.selector, to, amount);
583         bytes memory returndata = functionCall(address(token), data, "low-level call failed");
584         if (returndata.length > 0) {
585             require(abi.decode(returndata, (bool)), "not succeed");
586         }
587     }
588 
589     function safeTransferFrom(TokenInterface token, address from, address to , uint256 amount) internal {
590         bytes memory data = abi.encodeWithSelector(token.transferFrom.selector, from, to, amount);
591         bytes memory returndata = functionCall(address(token), data, "low-level call failed");
592         if (returndata.length > 0) {
593             require(abi.decode(returndata, (bool)), "not succeed");
594         }
595     }
596 
597     function safeApprove(TokenInterface token, address to , uint256 amount) internal {
598         bytes memory data = abi.encodeWithSelector(token.approve.selector, to, amount);
599         bytes memory returndata = functionCall(address(token), data, "low-level call failed");
600         if (returndata.length > 0) {
601             require(abi.decode(returndata, (bool)), "not succeed");
602         }
603     }
604 
605     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
606         return _functionCallWithValue(target, data, errorMessage);
607     }
608 
609     function _functionCallWithValue(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
610         (bool success, bytes memory returndata) = target.call(data);// value: weiValue }(data);
611         if (success) {
612             return returndata;
613         } else {
614             // Look for revert reason and bubble it up if present
615             if (returndata.length > 0) {
616                 // The easiest way to bubble the revert reason is using memory via assembly
617 
618                 // solhint-disable-next-line no-inline-assembly
619                 assembly {
620                     let returndata_size := mload(returndata)
621                     revert(add(32, returndata), returndata_size)
622                 }
623             } else {
624                 revert(errorMessage);
625             }
626         }
627     }
628 
629     function() external payable {}
630 }