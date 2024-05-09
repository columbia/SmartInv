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
269 }
270 
271 interface TokenInterface {
272     function balanceOf(address) external view returns (uint);
273     function allowance(address, address) external view returns (uint);
274     function approve(address, uint) external returns (bool);
275     function transfer(address, uint) external returns (bool);
276     function transferFrom(address, address, uint) external returns (bool);
277     function deposit() external payable;
278     function withdraw(uint) external;
279 }
280 
281 interface RegistryInterface {
282     function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
283 }
284 
285 contract ExchangeProxy is Ownable {
286 
287     using SafeMath for uint256;
288 
289     struct Pool {
290         address pool;
291         uint    tokenBalanceIn;
292         uint    tokenWeightIn;
293         uint    tokenBalanceOut;
294         uint    tokenWeightOut;
295         uint    swapFee;
296         uint    effectiveLiquidity;
297     }
298 
299     struct Swap {
300         address pool;
301         address tokenIn;
302         address tokenOut;
303         uint    swapAmount; // tokenInAmount / tokenOutAmount
304         uint    limitReturnAmount; // minAmountOut / maxAmountIn
305         uint    maxPrice;
306     }
307 
308     TokenInterface weth;
309     RegistryInterface registry;
310     address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
311     uint private constant BONE = 10**18;
312 
313     constructor(address _weth) public {
314         weth = TokenInterface(_weth);
315     }
316 
317     function setRegistry(address _registry) external onlyOwner {
318         registry = RegistryInterface(_registry);
319     }
320 
321     function batchSwapExactIn(
322         Swap[] memory swaps,
323         TokenInterface tokenIn,
324         TokenInterface tokenOut,
325         uint totalAmountIn,
326         uint minTotalAmountOut
327     )
328     public payable
329     returns (uint totalAmountOut)
330     {
331         transferFromAll(tokenIn, totalAmountIn);
332 
333         for (uint i = 0; i < swaps.length; i++) {
334             Swap memory swap = swaps[i];
335             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
336             PoolInterface pool = PoolInterface(swap.pool);
337 
338             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
339                 safeApprove(SwapTokenIn, swap.pool, 0);
340             }
341             safeApprove(SwapTokenIn, swap.pool, swap.swapAmount);
342 
343             (uint tokenAmountOut,) = pool.swapExactAmountIn(
344                 msg.sender,
345                 swap.tokenIn,
346                 swap.swapAmount,
347                 swap.tokenOut,
348                 swap.limitReturnAmount,
349                 swap.maxPrice
350             );
351             totalAmountOut = tokenAmountOut.add(totalAmountOut);
352         }
353 
354         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
355 
356         transferAll(tokenOut, totalAmountOut);
357         transferAll(tokenIn, getBalance(tokenIn));
358     }
359 
360     function batchSwapExactOut(
361         Swap[] memory swaps,
362         TokenInterface tokenIn,
363         TokenInterface tokenOut,
364         uint maxTotalAmountIn
365     )
366     public payable
367     returns (uint totalAmountIn)
368     {
369         transferFromAll(tokenIn, maxTotalAmountIn);
370 
371         for (uint i = 0; i < swaps.length; i++) {
372             Swap memory swap = swaps[i];
373             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
374             PoolInterface pool = PoolInterface(swap.pool);
375 
376             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
377                 safeApprove(SwapTokenIn, swap.pool, 0);
378             }
379             safeApprove(SwapTokenIn, swap.pool, swap.limitReturnAmount);
380 
381             (uint tokenAmountIn,) = pool.swapExactAmountOut(
382                 msg.sender,
383                 swap.tokenIn,
384                 swap.limitReturnAmount,
385                 swap.tokenOut,
386                 swap.swapAmount,
387                 swap.maxPrice
388             );
389             totalAmountIn = tokenAmountIn.add(totalAmountIn);
390         }
391         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
392 
393         transferAll(tokenOut, getBalance(tokenOut));
394         transferAll(tokenIn, getBalance(tokenIn));
395 
396     }
397 
398     function multihopBatchSwapExactIn(
399         Swap[][] memory swapSequences,
400         TokenInterface tokenIn,
401         TokenInterface tokenOut,
402         uint totalAmountIn,
403         uint minTotalAmountOut
404     )
405     public payable
406     returns (uint totalAmountOut)
407     {
408 
409         transferFromAll(tokenIn, totalAmountIn);
410 
411         for (uint i = 0; i < swapSequences.length; i++) {
412             uint tokenAmountOut;
413             for (uint k = 0; k < swapSequences[i].length; k++) {
414                 Swap memory swap = swapSequences[i][k];
415                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
416                 if (k == 1) {
417                     // Makes sure that on the second swap the output of the first was used
418                     // so there is not intermediate token leftover
419                     swap.swapAmount = tokenAmountOut;
420                 }
421 
422                 PoolInterface pool = PoolInterface(swap.pool);
423                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
424                     safeApprove(SwapTokenIn, swap.pool, 0);
425                 }
426                 safeApprove(SwapTokenIn, swap.pool, swap.swapAmount);
427 
428                 (tokenAmountOut,) = pool.swapExactAmountIn(
429                     msg.sender,
430                     swap.tokenIn,
431                     swap.swapAmount,
432                     swap.tokenOut,
433                     swap.limitReturnAmount,
434                     swap.maxPrice
435                 );
436             }
437             // This takes the amountOut of the last swap
438             totalAmountOut = tokenAmountOut.add(totalAmountOut);
439         }
440 
441         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
442 
443         transferAll(tokenOut, totalAmountOut);
444         transferAll(tokenIn, getBalance(tokenIn));
445 
446     }
447 
448     function multihopBatchSwapExactOut(
449         Swap[][] memory swapSequences,
450         TokenInterface tokenIn,
451         TokenInterface tokenOut,
452         uint maxTotalAmountIn
453     )
454     public payable
455     returns (uint totalAmountIn)
456     {
457 
458         transferFromAll(tokenIn, maxTotalAmountIn);
459 
460         for (uint i = 0; i < swapSequences.length; i++) {
461             uint tokenAmountInFirstSwap;
462             // Specific code for a simple swap and a multihop (2 swaps in sequence)
463             if (swapSequences[i].length == 1) {
464                 Swap memory swap = swapSequences[i][0];
465                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
466 
467                 PoolInterface pool = PoolInterface(swap.pool);
468                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
469                     safeApprove(SwapTokenIn, swap.pool, 0);
470                 }
471                 safeApprove(SwapTokenIn, swap.pool, swap.limitReturnAmount);
472 
473                 (tokenAmountInFirstSwap,) = pool.swapExactAmountOut(
474                     msg.sender,
475                     swap.tokenIn,
476                     swap.limitReturnAmount,
477                     swap.tokenOut,
478                     swap.swapAmount,
479                     swap.maxPrice
480                 );
481             } else {
482                 // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
483                 // of token C. But first we need to buy B with A so we can then buy C with B
484                 // To get the exact amount of C we then first need to calculate how much B we'll need:
485                 uint intermediateTokenAmount; // This would be token B as described above
486                 Swap memory secondSwap = swapSequences[i][1];
487                 PoolInterface poolSecondSwap = PoolInterface(secondSwap.pool);
488                 intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
489                     poolSecondSwap.getBalance(secondSwap.tokenIn),
490                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
491                     poolSecondSwap.getBalance(secondSwap.tokenOut),
492                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
493                     secondSwap.swapAmount,
494                     poolSecondSwap.getSwapFee()
495                 );
496 
497                 //// Buy intermediateTokenAmount of token B with A in the first pool
498                 Swap memory firstSwap = swapSequences[i][0];
499                 TokenInterface FirstSwapTokenIn = TokenInterface(firstSwap.tokenIn);
500                 PoolInterface poolFirstSwap = PoolInterface(firstSwap.pool);
501                 if (FirstSwapTokenIn.allowance(address(this), firstSwap.pool) < uint(-1)) {
502                     safeApprove(FirstSwapTokenIn, firstSwap.pool, uint(-1));
503                 }
504 
505                 (tokenAmountInFirstSwap,) = poolFirstSwap.swapExactAmountOut(
506                     msg.sender,
507                     firstSwap.tokenIn,
508                     firstSwap.limitReturnAmount,
509                     firstSwap.tokenOut,
510                     intermediateTokenAmount, // This is the amount of token B we need
511                     firstSwap.maxPrice
512                 );
513 
514                 //// Buy the final amount of token C desired
515                 TokenInterface SecondSwapTokenIn = TokenInterface(secondSwap.tokenIn);
516                 if (SecondSwapTokenIn.allowance(address(this), secondSwap.pool) < uint(-1)) {
517                     safeApprove(SecondSwapTokenIn, secondSwap.pool, uint(-1));
518                 }
519 
520                 poolSecondSwap.swapExactAmountOut(
521                     msg.sender,
522                     secondSwap.tokenIn,
523                     secondSwap.limitReturnAmount,
524                     secondSwap.tokenOut,
525                     secondSwap.swapAmount,
526                     secondSwap.maxPrice
527                 );
528             }
529             totalAmountIn = tokenAmountInFirstSwap.add(totalAmountIn);
530         }
531 
532         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
533 
534         transferAll(tokenOut, getBalance(tokenOut));
535         transferAll(tokenIn, getBalance(tokenIn));
536 
537     }
538 
539 
540     function transferFromAll(TokenInterface token, uint amount) internal returns(bool) {
541         if (isETH(token)) {
542             weth.deposit.value(msg.value)();
543         } else {
544 //            require(token.transferFrom(msg.sender, address(this), amount), "ERR_TRANSFER_FAILED");
545             safeTransferFrom(token, msg.sender, address(this), amount);
546         }
547     }
548 
549     function getBalance(TokenInterface token) internal view returns (uint) {
550         if (isETH(token)) {
551             return weth.balanceOf(address(this));
552         } else {
553             return token.balanceOf(address(this));
554         }
555     }
556 
557     function transferAll(TokenInterface token, uint amount) internal returns(bool) {
558         if (amount == 0) {
559             return true;
560         }
561 
562         if (isETH(token)) {
563             weth.withdraw(amount);
564             (bool xfer,) = msg.sender.call.value(amount)("");
565             require(xfer, "ERR_ETH_FAILED");
566         } else {
567 //            require(token.transfer(msg.sender, amount), "ERR_TRANSFER_FAILED");
568             safeTransfer(token, msg.sender, amount);
569         }
570     }
571 
572     function isETH(TokenInterface token) internal pure returns(bool) {
573         return (address(token) == ETH_ADDRESS);
574     }
575 
576     function safeTransfer(TokenInterface token, address to , uint256 amount) internal {
577         bytes memory data = abi.encodeWithSelector(token.transfer.selector, to, amount);
578         bytes memory returndata = functionCall(address(token), data, "low-level call failed");
579         if (returndata.length > 0) {
580             require(abi.decode(returndata, (bool)), "not succeed");
581         }
582     }
583 
584     function safeTransferFrom(TokenInterface token, address from, address to , uint256 amount) internal {
585         bytes memory data = abi.encodeWithSelector(token.transferFrom.selector, from, to, amount);
586         bytes memory returndata = functionCall(address(token), data, "low-level call failed");
587         if (returndata.length > 0) {
588             require(abi.decode(returndata, (bool)), "not succeed");
589         }
590     }
591 
592     function safeApprove(TokenInterface token, address to , uint256 amount) internal {
593         bytes memory data = abi.encodeWithSelector(token.approve.selector, to, amount);
594         bytes memory returndata = functionCall(address(token), data, "low-level call failed");
595         if (returndata.length > 0) {
596             require(abi.decode(returndata, (bool)), "not succeed");
597         }
598     }
599 
600     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
601         return _functionCallWithValue(target, data, errorMessage);
602     }
603 
604     function _functionCallWithValue(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
605         (bool success, bytes memory returndata) = target.call(data);// value: weiValue }(data);
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 // solhint-disable-next-line no-inline-assembly
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 
624     function() external payable {}
625 }