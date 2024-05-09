1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21 
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/math/Math.sol
103 
104 // SPDX-License-Identifier: MIT
105 
106 pragma solidity ^0.6.0;
107 
108 /**
109  * @dev Standard math utilities missing in the Solidity language.
110  */
111 library Math {
112     /**
113      * @dev Returns the largest of two numbers.
114      */
115     function max(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a >= b ? a : b;
117     }
118 
119     /**
120      * @dev Returns the smallest of two numbers.
121      */
122     function min(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a < b ? a : b;
124     }
125 
126     /**
127      * @dev Returns the average of two numbers. The result is rounded towards
128      * zero.
129      */
130     function average(uint256 a, uint256 b) internal pure returns (uint256) {
131         // (a + b) / 2 can overflow, so we distribute
132         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/math/SafeMath.sol
137 
138 // SPDX-License-Identifier: MIT
139 
140 pragma solidity ^0.6.0;
141 
142 /**
143  * @dev Wrappers over Solidity's arithmetic operations with added overflow
144  * checks.
145  *
146  * Arithmetic operations in Solidity wrap on overflow. This can easily result
147  * in bugs, because programmers usually assume that an overflow raises an
148  * error, which is the standard behavior in high level programming languages.
149  * `SafeMath` restores this intuition by reverting the transaction when an
150  * operation overflows.
151  *
152  * Using this library instead of the unchecked operations eliminates an entire
153  * class of bugs, so it's recommended to use it always.
154  */
155 library SafeMath {
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a, "SafeMath: addition overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return sub(a, b, "SafeMath: subtraction overflow");
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         uint256 c = a - b;
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212         // benefit is lost if 'b' is also tested.
213         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214         if (a == 0) {
215             return 0;
216         }
217 
218         uint256 c = a * b;
219         require(c / a == b, "SafeMath: multiplication overflow");
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         return div(a, b, "SafeMath: division by zero");
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         // Solidity only automatically asserts when dividing by 0
252         require(b > 0, errorMessage);
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      * - The divisor cannot be zero.
269      */
270     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271         return mod(a, b, "SafeMath: modulo by zero");
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * Reverts with custom message when dividing by zero.
277      *
278      * Counterpart to Solidity's `%` operator. This function uses a `revert`
279      * opcode (which leaves remaining gas untouched) while Solidity uses an
280      * invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b != 0, errorMessage);
287         return a % b;
288     }
289 }
290 
291 // File: contracts/interfaces/PriceOracleInterface.sol
292 
293 pragma solidity 0.6.6;
294 
295 /**
296  * @dev Interface of the price oracle.
297  */
298 interface PriceOracleInterface {
299     /**
300      * @dev Returns `true`if oracle is working.
301      */
302     function isWorking() external returns (bool);
303 
304     /**
305      * @dev Returns the latest id. The id start from 1 and increments by 1.
306      */
307     function latestId() external returns (uint256);
308 
309     /**
310      * @dev Returns the last updated price. Decimals is 8.
311      **/
312     function latestPrice() external returns (uint256);
313 
314     /**
315      * @dev Returns the timestamp of the last updated price.
316      */
317     function latestTimestamp() external returns (uint256);
318 
319     /**
320      * @dev Returns the historical price specified by `id`. Decimals is 8.
321      */
322     function getPrice(uint256 id) external returns (uint256);
323 
324     /**
325      * @dev Returns the timestamp of historical price specified by `id`.
326      */
327     function getTimestamp(uint256 id) external returns (uint256);
328 }
329 
330 // File: contracts/interfaces/VolatilityOracleInterface.sol
331 
332 pragma solidity 0.6.6;
333 
334 /**
335  * @dev Interface of the volatility oracle.
336  */
337 interface VolatilityOracleInterface {
338     /**
339      * @dev Returns the latest volatility.
340      * Decimals is 8.
341      * This is not a view function because in order for gas efficiency, we would sometimes need to store some values during the calculation of volatility value.
342      */
343     function getVolatility() external returns (uint256);
344 }
345 
346 // File: contracts/MarketOracle.sol
347 
348 pragma solidity 0.6.6;
349 
350 
351 
352 
353 
354 
355 /**
356  * @notice Market data oracle. It provides prices and historical volatility of the price.
357  * Without any problems, It continues to refer to one certain price oracle (main oracle).
358  * No one can reassign any other oracle to the main oracle as long as the main oracle is working correctly.
359  * When this contract recognizes that the main oracle is not working correctly (stop updating data, start giving wrong data, self truncated), MarketOracle automatically enters Recovery phase.
360  *
361  * [Recovery phase]
362  * When it turns into Recovery phase, it start to refer to a sub oracle in order to keep providing market data continuously.
363  * The sub oracle is referred to only in such a case.
364  * The sub oracle is not expected to be used for long.
365  * In the meanwhile the owner of MarketOracle finds another reliable oracle and assigns it to the new main oracle.
366  * If the new main oracle passes some checks, MarketOracle returns to the normal phase from the Recovery phase.
367  * Owner can reassign the sub oracle anytime.
368  *
369  * Volatility is calculated by some last prices provided by the oracle.
370  * Calculating volatility is an expensive task, So MarketOracle stores some intermediate values to storage.
371  */
372 contract MarketOracle is
373     Ownable,
374     PriceOracleInterface,
375     VolatilityOracleInterface
376 {
377     using SafeMath for uint256;
378     uint256 public constant VOLATILITY_DATA_NUM = 25;
379     uint256 private constant SECONDS_IN_YEAR = 31536000;
380 
381     /**
382      *@notice If true, this contract is in Recovery phase.
383      */
384     bool public isRecoveryPhase;
385     PriceOracleInterface public mainOracle;
386     PriceOracleInterface public subOracle;
387 
388     uint256 private exTo;
389     uint256 public lastCalculatedVolatility;
390     PriceOracleInterface private exVolatilityOracle;
391     uint256 private exSquareReturnSum;
392 
393     event EnterRecoveryPhase();
394     event ReturnFromRecoveryPhase(PriceOracleInterface newMainOracle);
395     event SetSubOracle(PriceOracleInterface newSubOracle);
396     event VolatilityCalculated(uint256 volatility);
397 
398     /**
399      * @dev Enters Recovery phase if the main oracle is not working.
400      */
401     modifier recoveryPhaseCheck() {
402         if (!mainOracle.isWorking() && !isRecoveryPhase) {
403             emit EnterRecoveryPhase();
404             isRecoveryPhase = true;
405         }
406         _;
407     }
408 
409     constructor(
410         PriceOracleInterface _mainOracle,
411         PriceOracleInterface _subOracle
412     ) public {
413         mainOracle = _mainOracle;
414         subOracle = _subOracle;
415     }
416 
417     /**
418      * @notice Assigns `oracle` to the new main oracle and returns to the normal phase from Recovery phase.
419      * Only owner can call this function only when the main oracle is not working correctly.
420      */
421     function setMainOracle(PriceOracleInterface oracle) external onlyOwner {
422         require(isRecoveryPhase, "Cannot change working main oracle");
423         require(oracle.isWorking(), "New oracle is not working");
424         mainOracle = oracle;
425         isRecoveryPhase = false;
426         emit ReturnFromRecoveryPhase(oracle);
427     }
428 
429     /**
430      * @notice Assigns `oracle` to the new sub oracle.
431      * Only owner can call this function anytime.
432      */
433     function setSubOracle(PriceOracleInterface oracle) external onlyOwner {
434         subOracle = oracle;
435         emit SetSubOracle(oracle);
436     }
437 
438     /**
439      * @notice Calculates the latest volatility.
440      * If any update to the price after the last calculation of volatility, recalculates and returns the new value.
441      */
442     function getVolatility()
443         external
444         override
445         recoveryPhaseCheck
446         returns (uint256)
447     {
448         uint256 to;
449         uint256 from;
450         uint256 _exTo;
451         uint256 exFrom;
452 
453         uint256 squareReturnSum;
454 
455         PriceOracleInterface oracle = _activeOracle();
456         to = oracle.latestId();
457         from = to.sub(VOLATILITY_DATA_NUM, "data is too few").add(1);
458         _exTo = exTo;
459 
460         bool needToRecalculateAll = oracle != exVolatilityOracle || // if oracle has been changed
461             (to.sub(_exTo)) >= VOLATILITY_DATA_NUM / 2; // if it is not efficient to reuse some intermediate values.
462 
463         if (needToRecalculateAll) {
464             // recalculate the whole of intermediate values
465             squareReturnSum = _sumOfSquareReturn(oracle, from, to);
466         } else if (_exTo == to) {
467             // no need to recalculate
468             return lastCalculatedVolatility;
469         } else {
470             // reuse some of intermediate values and recalculate others for gas cost reduce.
471             // `_exTo` is same as `to` on the last volatility updated.
472             // Whenever volatility is updated, `to` is equal to or more than 25, so `_exTo` never goes below 25.
473             exFrom = _exTo.add(1).sub(VOLATILITY_DATA_NUM);
474             squareReturnSum = exSquareReturnSum
475                 .add(_sumOfSquareReturn(oracle, _exTo, to))
476                 .sub(_sumOfSquareReturn(oracle, exFrom, from));
477         }
478 
479         uint256 time = oracle.getTimestamp(to).sub(oracle.getTimestamp(from));
480         uint256 s = squareReturnSum.mul(SECONDS_IN_YEAR).div(time);
481         uint256 v = _sqrt(s);
482         lastCalculatedVolatility = v;
483         exTo = to;
484         exVolatilityOracle = oracle;
485         exSquareReturnSum = squareReturnSum;
486         emit VolatilityCalculated(v);
487         return v;
488     }
489 
490     /**
491      * @notice Returns 'true' if either of the main oracle or the sub oracle is working.
492      * @dev See {PriceOracleInterface-isWorking}.
493      */
494     function isWorking() external override recoveryPhaseCheck returns (bool) {
495         return mainOracle.isWorking() || subOracle.isWorking();
496     }
497 
498     /**
499      * @dev See {PriceOracleInterface-latestId}.
500      */
501     function latestId()
502         external
503         override
504         recoveryPhaseCheck
505         returns (uint256)
506     {
507         return _activeOracle().latestId();
508     }
509 
510     /**
511      * @dev See {PriceOracleInterface-latestPrice}.
512      */
513     function latestPrice()
514         external
515         override
516         recoveryPhaseCheck
517         returns (uint256)
518     {
519         return _activeOracle().latestPrice();
520     }
521 
522     /**
523      * @dev See {PriceOracleInterface-latestTimestamp}.
524      */
525     function latestTimestamp()
526         external
527         override
528         recoveryPhaseCheck
529         returns (uint256)
530     {
531         return _activeOracle().latestTimestamp();
532     }
533 
534     /**
535      * @dev See {PriceOracleInterface-getPrice}.
536      */
537     function getPrice(uint256 id)
538         external
539         override
540         recoveryPhaseCheck
541         returns (uint256)
542     {
543         return _activeOracle().getPrice(id);
544     }
545 
546     /**
547      * @dev See {PriceOracleInterface-getTimestamp}.
548      */
549     function getTimestamp(uint256 id)
550         external
551         override
552         recoveryPhaseCheck
553         returns (uint256)
554     {
555         return _activeOracle().getTimestamp(id);
556     }
557 
558     /**
559      * @dev Returns the main oracle if this contract is in Recovery phase.
560      * Returns the sub oracle if the main oracle is not working.
561      * Reverts if neither is working.
562      * recoveryPhaseCheck modifier must be called before this function is called.
563      */
564     function _activeOracle() private returns (PriceOracleInterface) {
565         if (!isRecoveryPhase) {
566             return mainOracle;
567         }
568         require(subOracle.isWorking(), "both of the oracles are not working");
569         return subOracle;
570     }
571 
572     /**
573      * @dev Returns sum of the square of relative returns of prices given by `oracle`.
574      */
575     function _sumOfSquareReturn(
576         PriceOracleInterface oracle,
577         uint256 from,
578         uint256 to
579     ) private returns (uint256) {
580         uint256 a;
581         uint256 b;
582         uint256 sum;
583         b = oracle.getPrice(from);
584         for (uint256 id = from + 1; id <= to; id++) {
585             a = b;
586             b = oracle.getPrice(id);
587             sum = sum.add(_squareReturn(a, b));
588         }
589         return sum;
590     }
591 
592     /**
593      * @dev Returns squareReturn of two values.
594      * v = {abs(b-a)/a}^2 * 10^16
595      */
596     function _squareReturn(uint256 a, uint256 b)
597         private
598         pure
599         returns (uint256)
600     {
601         uint256 sub = _absDef(a, b);
602         return (sub.mul(10**8)**2).div(a**2);
603     }
604 
605     /**
606      * @dev Returns absolute difference of two numbers.
607      */
608     function _absDef(uint256 a, uint256 b) private pure returns (uint256) {
609         if (a > b) {
610             return a - b;
611         } else {
612             return b - a;
613         }
614     }
615 
616     /**
617      * @dev Returns square root of `x`.
618      * Babylonian method for square root.
619      */
620     function _sqrt(uint256 x) private pure returns (uint256 y) {
621         uint256 z = (x + 1) / 2;
622         y = x;
623         while (z < y) {
624             y = z;
625             z = (x / z + z) / 2;
626         }
627     }
628 }