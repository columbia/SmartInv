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
346 // File: contracts/LightMarketOracle.sol
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
372 contract LightMarketOracle is
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
398     constructor(
399         PriceOracleInterface _mainOracle,
400         PriceOracleInterface _subOracle
401     ) public {
402         mainOracle = _mainOracle;
403         subOracle = _subOracle;
404     }
405 
406     /**
407      * @dev Enters Recovery phase if the main oracle is not working.
408      */
409     function recoveryPhaseCheck() external {
410         if (!mainOracle.isWorking() && !isRecoveryPhase) {
411             emit EnterRecoveryPhase();
412             isRecoveryPhase = true;
413         }
414     }
415 
416     /**
417      * @notice Assigns `oracle` to the new main oracle and returns to the normal phase from Recovery phase.
418      * Only owner can call this function only when the main oracle is not working correctly.
419      */
420     function setMainOracle(PriceOracleInterface oracle) external onlyOwner {
421         require(isRecoveryPhase, "Cannot change working main oracle");
422         require(oracle.isWorking(), "New oracle is not working");
423         mainOracle = oracle;
424         isRecoveryPhase = false;
425         emit ReturnFromRecoveryPhase(oracle);
426     }
427 
428     /**
429      * @notice Assigns `oracle` to the new sub oracle.
430      * Only owner can call this function anytime.
431      */
432     function setSubOracle(PriceOracleInterface oracle) external onlyOwner {
433         subOracle = oracle;
434         emit SetSubOracle(oracle);
435     }
436 
437     /**
438      * @notice Calculates the latest volatility.
439      * If any update to the price after the last calculation of volatility, recalculates and returns the new value.
440      */
441     function getVolatility() external override returns (uint256) {
442         uint256 to;
443         uint256 from;
444         uint256 _exTo;
445         uint256 exFrom;
446 
447         uint256 squareReturnSum;
448 
449         PriceOracleInterface oracle = _activeOracle();
450         to = oracle.latestId();
451         from = to.sub(VOLATILITY_DATA_NUM, "data is too few").add(1);
452         _exTo = exTo;
453 
454         bool needToRecalculateAll = oracle != exVolatilityOracle || // if oracle has been changed
455             (to.sub(_exTo)) >= VOLATILITY_DATA_NUM / 2; // if it is not efficient to reuse some intermediate values.
456 
457         if (needToRecalculateAll) {
458             // recalculate the whole of intermediate values
459             squareReturnSum = _sumOfSquareReturn(oracle, from, to);
460         } else if (_exTo == to) {
461             // no need to recalculate
462             return lastCalculatedVolatility;
463         } else {
464             // reuse some of intermediate values and recalculate others for gas cost reduce.
465             // `_exTo` is same as `to` on the last volatility updated.
466             // Whenever volatility is updated, `to` is equal to or more than 25, so `_exTo` never goes below 25.
467             exFrom = _exTo.add(1).sub(VOLATILITY_DATA_NUM);
468             squareReturnSum = exSquareReturnSum
469                 .add(_sumOfSquareReturn(oracle, _exTo, to))
470                 .sub(_sumOfSquareReturn(oracle, exFrom, from));
471         }
472 
473         uint256 time = oracle.getTimestamp(to).sub(oracle.getTimestamp(from));
474         uint256 s = squareReturnSum.mul(SECONDS_IN_YEAR).div(time);
475         uint256 v = _sqrt(s);
476         lastCalculatedVolatility = v;
477         exTo = to;
478         exVolatilityOracle = oracle;
479         exSquareReturnSum = squareReturnSum;
480         emit VolatilityCalculated(v);
481         return v;
482     }
483 
484     /**
485      * @notice Returns 'true' if either of the main oracle or the sub oracle is working.
486      * @dev See {PriceOracleInterface-isWorking}.
487      */
488     function isWorking() external override returns (bool) {
489         return mainOracle.isWorking() || subOracle.isWorking();
490     }
491 
492     /**
493      * @dev See {PriceOracleInterface-latestId}.
494      */
495     function latestId() external override returns (uint256) {
496         return _activeOracle().latestId();
497     }
498 
499     /**
500      * @dev See {PriceOracleInterface-latestPrice}.
501      */
502     function latestPrice() external override returns (uint256) {
503         return _activeOracle().latestPrice();
504     }
505 
506     /**
507      * @dev See {PriceOracleInterface-latestTimestamp}.
508      */
509     function latestTimestamp() external override returns (uint256) {
510         return _activeOracle().latestTimestamp();
511     }
512 
513     /**
514      * @dev See {PriceOracleInterface-getPrice}.
515      */
516     function getPrice(uint256 id) external override returns (uint256) {
517         return _activeOracle().getPrice(id);
518     }
519 
520     /**
521      * @dev See {PriceOracleInterface-getTimestamp}.
522      */
523     function getTimestamp(uint256 id) external override returns (uint256) {
524         return _activeOracle().getTimestamp(id);
525     }
526 
527     /**
528      * @dev Returns the main oracle if this contract is in Recovery phase.
529      * Returns the sub oracle if the main oracle is not working.
530      * Reverts if neither is working.
531      * recoveryPhaseCheck modifier must be called before this function is called.
532      */
533     function _activeOracle() private returns (PriceOracleInterface) {
534         if (!isRecoveryPhase) {
535             return mainOracle;
536         }
537         require(subOracle.isWorking(), "both of the oracles are not working");
538         return subOracle;
539     }
540 
541     /**
542      * @dev Returns sum of the square of relative returns of prices given by `oracle`.
543      */
544     function _sumOfSquareReturn(
545         PriceOracleInterface oracle,
546         uint256 from,
547         uint256 to
548     ) private returns (uint256) {
549         uint256 a;
550         uint256 b;
551         uint256 sum;
552         b = oracle.getPrice(from);
553         for (uint256 id = from + 1; id <= to; id++) {
554             a = b;
555             b = oracle.getPrice(id);
556             sum = sum.add(_squareReturn(a, b));
557         }
558         return sum;
559     }
560 
561     /**
562      * @dev Returns squareReturn of two values.
563      * v = {abs(b-a)/a}^2 * 10^16
564      */
565     function _squareReturn(uint256 a, uint256 b)
566         private
567         pure
568         returns (uint256)
569     {
570         uint256 sub = _absDef(a, b);
571         return (sub.mul(10**8)**2).div(a**2);
572     }
573 
574     /**
575      * @dev Returns absolute difference of two numbers.
576      */
577     function _absDef(uint256 a, uint256 b) private pure returns (uint256) {
578         if (a > b) {
579             return a - b;
580         } else {
581             return b - a;
582         }
583     }
584 
585     /**
586      * @dev Returns square root of `x`.
587      * Babylonian method for square root.
588      */
589     function _sqrt(uint256 x) private pure returns (uint256 y) {
590         uint256 z = (x + 1) / 2;
591         y = x;
592         while (z < y) {
593             y = z;
594             z = (x / z + z) / 2;
595         }
596     }
597 }