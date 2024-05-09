1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-03
3 */
4 
5 pragma solidity >=0.6.8;
6 
7 
8 // 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 // 
166 /**
167  * @dev Library for managing
168  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
169  * types.
170  *
171  * Sets have the following properties:
172  *
173  * - Elements are added, removed, and checked for existence in constant time
174  * (O(1)).
175  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
176  *
177  * ```
178  * contract Example {
179  *     // Add the library methods
180  *     using EnumerableSet for EnumerableSet.AddressSet;
181  *
182  *     // Declare a set state variable
183  *     EnumerableSet.AddressSet private mySet;
184  * }
185  * ```
186  *
187  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
188  * (`UintSet`) are supported.
189  */
190 library EnumerableSet {
191     // To implement this library for multiple types with as little code
192     // repetition as possible, we write it in terms of a generic Set type with
193     // bytes32 values.
194     // The Set implementation uses private functions, and user-facing
195     // implementations (such as AddressSet) are just wrappers around the
196     // underlying Set.
197     // This means that we can only create new EnumerableSets for types that fit
198     // in bytes32.
199 
200     struct Set {
201         // Storage of set values
202         bytes32[] _values;
203 
204         // Position of the value in the `values` array, plus 1 because index 0
205         // means a value is not in the set.
206         mapping (bytes32 => uint256) _indexes;
207     }
208 
209     /**
210      * @dev Add a value to a set. O(1).
211      *
212      * Returns true if the value was added to the set, that is if it was not
213      * already present.
214      */
215     function _add(Set storage set, bytes32 value) private returns (bool) {
216         if (!_contains(set, value)) {
217             set._values.push(value);
218             // The value is stored at length-1, but we add 1 to all indexes
219             // and use 0 as a sentinel value
220             set._indexes[value] = set._values.length;
221             return true;
222         } else {
223             return false;
224         }
225     }
226 
227     /**
228      * @dev Removes a value from a set. O(1).
229      *
230      * Returns true if the value was removed from the set, that is if it was
231      * present.
232      */
233     function _remove(Set storage set, bytes32 value) private returns (bool) {
234         // We read and store the value's index to prevent multiple reads from the same storage slot
235         uint256 valueIndex = set._indexes[value];
236 
237         if (valueIndex != 0) { // Equivalent to contains(set, value)
238             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
239             // the array, and then remove the last element (sometimes called as 'swap and pop').
240             // This modifies the order of the array, as noted in {at}.
241 
242             uint256 toDeleteIndex = valueIndex - 1;
243             uint256 lastIndex = set._values.length - 1;
244 
245             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
246             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
247 
248             bytes32 lastvalue = set._values[lastIndex];
249 
250             // Move the last value to the index where the value to delete is
251             set._values[toDeleteIndex] = lastvalue;
252             // Update the index for the moved value
253             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
254 
255             // Delete the slot where the moved value was stored
256             set._values.pop();
257 
258             // Delete the index for the deleted slot
259             delete set._indexes[value];
260 
261             return true;
262         } else {
263             return false;
264         }
265     }
266 
267     /**
268      * @dev Returns true if the value is in the set. O(1).
269      */
270     function _contains(Set storage set, bytes32 value) private view returns (bool) {
271         return set._indexes[value] != 0;
272     }
273 
274     /**
275      * @dev Returns the number of values on the set. O(1).
276      */
277     function _length(Set storage set) private view returns (uint256) {
278         return set._values.length;
279     }
280 
281    /**
282     * @dev Returns the value stored at position `index` in the set. O(1).
283     *
284     * Note that there are no guarantees on the ordering of values inside the
285     * array, and it may change when more values are added or removed.
286     *
287     * Requirements:
288     *
289     * - `index` must be strictly less than {length}.
290     */
291     function _at(Set storage set, uint256 index) private view returns (bytes32) {
292         require(set._values.length > index, "EnumerableSet: index out of bounds");
293         return set._values[index];
294     }
295 
296     // AddressSet
297 
298     struct AddressSet {
299         Set _inner;
300     }
301 
302     /**
303      * @dev Add a value to a set. O(1).
304      *
305      * Returns true if the value was added to the set, that is if it was not
306      * already present.
307      */
308     function add(AddressSet storage set, address value) internal returns (bool) {
309         return _add(set._inner, bytes32(uint256(value)));
310     }
311 
312     /**
313      * @dev Removes a value from a set. O(1).
314      *
315      * Returns true if the value was removed from the set, that is if it was
316      * present.
317      */
318     function remove(AddressSet storage set, address value) internal returns (bool) {
319         return _remove(set._inner, bytes32(uint256(value)));
320     }
321 
322     /**
323      * @dev Returns true if the value is in the set. O(1).
324      */
325     function contains(AddressSet storage set, address value) internal view returns (bool) {
326         return _contains(set._inner, bytes32(uint256(value)));
327     }
328 
329     /**
330      * @dev Returns the number of values in the set. O(1).
331      */
332     function length(AddressSet storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336    /**
337     * @dev Returns the value stored at position `index` in the set. O(1).
338     *
339     * Note that there are no guarantees on the ordering of values inside the
340     * array, and it may change when more values are added or removed.
341     *
342     * Requirements:
343     *
344     * - `index` must be strictly less than {length}.
345     */
346     function at(AddressSet storage set, uint256 index) internal view returns (address) {
347         return address(uint256(_at(set._inner, index)));
348     }
349 
350 
351     // UintSet
352 
353     struct UintSet {
354         Set _inner;
355     }
356 
357     /**
358      * @dev Add a value to a set. O(1).
359      *
360      * Returns true if the value was added to the set, that is if it was not
361      * already present.
362      */
363     function add(UintSet storage set, uint256 value) internal returns (bool) {
364         return _add(set._inner, bytes32(value));
365     }
366 
367     /**
368      * @dev Removes a value from a set. O(1).
369      *
370      * Returns true if the value was removed from the set, that is if it was
371      * present.
372      */
373     function remove(UintSet storage set, uint256 value) internal returns (bool) {
374         return _remove(set._inner, bytes32(value));
375     }
376 
377     /**
378      * @dev Returns true if the value is in the set. O(1).
379      */
380     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
381         return _contains(set._inner, bytes32(value));
382     }
383 
384     /**
385      * @dev Returns the number of values on the set. O(1).
386      */
387     function length(UintSet storage set) internal view returns (uint256) {
388         return _length(set._inner);
389     }
390 
391    /**
392     * @dev Returns the value stored at position `index` in the set. O(1).
393     *
394     * Note that there are no guarantees on the ordering of values inside the
395     * array, and it may change when more values are added or removed.
396     *
397     * Requirements:
398     *
399     * - `index` must be strictly less than {length}.
400     */
401     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
402         return uint256(_at(set._inner, index));
403     }
404 }
405 
406 // 
407 interface IMMStrategyHarvestKp3r {
408     event Keep3rSet(address keep3r);
409     event Keep3rHelperSet(address keep3rHelper);
410     event SlidingOracleSet(address slidingOracle);
411 
412     // Actions by Keeper
413     event HarvestedByKeeper(address _strategy);
414 	
415     // Harvestable check
416     event HarvestableCheck(address _strategy, uint256 profitTokenAmount, uint256 profitFactor, uint256 profitInEther, uint256 ethCallCost);
417 
418     // Setters
419     function setKeep3r(address _keep3r) external;
420 
421     function setKeep3rHelper(address _keep3rHelper) external;
422 
423     function setSlidingOracle(address _slidingOracle) external;
424 
425     function setSushiSlidingOracle(address _sushiSlidingOracle) external;
426 	
427     function setMinHarvestInterval(uint256 _interval) external;
428 	
429     function setProfitFactor(uint256 _profitFactor) external;
430 
431     // Getters
432     function getStrategies() external view returns (address[] memory);
433     function getCollateralizedStrategies() external view returns (address[] memory);
434     function getVaults() external view returns (address[] memory);
435 
436     // psuedo view method, please use something similar to below tool to query
437     // https://docs.ethers.io/v5/api/contract/contract/#contract-callStatic 
438     function harvestable(address _strategy) external returns (bool);
439 
440     // harvest actions for Keep3r
441     function harvest(address _strategy) external;
442     
443     // earn() actions for Keep3r
444     function earnable(address _strategy) external view returns (bool);
445     function earn(address _strategy) external;
446     
447     // keepMinRatio() actions for Keep3r
448     function keepMinRatioMayday(address _strategy) external view returns (bool);
449     function keepMinRatio(address _strategy) external;
450 
451     // Name of the Keep3r
452     function name() external pure returns (string memory);
453 
454     event HarvestStrategyAdded(address _vault, address _strategy, uint256 _requiredHarvest, bool _requiredKeepMinRatio, bool _requiredLeverageToMax, address yieldToken, uint256 yieldTokenOracle);
455 
456     event EarnVaultAdded(address _vault, uint256 _requiredEarnBalance);
457 
458     event HarvestStrategyModified(address _strategy, uint256 _requiredHarvest);
459 
460     event EarnVaultModified(address _vault, uint256 _requiredEarnBalance);
461 
462     event HarvestStrategyRemoved(address _strategy);
463 
464     event EarnVaultRemoved(address _vault);
465 
466     // Modifiers
467     function addStrategy(address _vault, address _strategy, uint256 _requiredHarvest, bool _requiredKeepMinRatio, bool _requiredLeverageToMax, address yieldToken, uint256 yieldTokenOracle) external;
468     
469     function addVault(address _vault, uint256 _requiredEarnBalance) external;
470 
471     function updateRequiredHarvestAmount(address _strategy, uint256 _requiredHarvest) external;
472     
473     function updateYieldTokenOracle(address _strategy, uint256 _yieldTokenOracle) external;
474     
475     function updateRequiredEarn(address _vault, uint256 _requiredEarnBalance) external;
476 
477     function removeHarvestStrategy(address _strategy) external;
478 
479     function removeEarnVault(address _vault) external;
480 
481 }
482 
483 // 
484 interface IKeep3rV1 {
485     function KPRH() external returns (address);
486 
487     function name() external returns (string memory);
488 
489     function isKeeper(address) external returns (bool);
490 
491     function worked(address keeper) external;
492 
493     function addKPRCredit(address job, uint256 amount) external;
494 
495     function addJob(address job) external;
496 }
497 
498 // 
499 abstract contract Keep3r {
500     IKeep3rV1 public keep3r;
501 
502     constructor(address _keep3r) public {
503         _setKeep3r(_keep3r);
504     }
505 
506     function _setKeep3r(address _keep3r) internal {
507         keep3r = IKeep3rV1(_keep3r);
508     }
509 
510     function _isKeeper() internal {
511         require(tx.origin == msg.sender, "keep3r::isKeeper:keeper-is-a-smart-contract");
512         require(keep3r.isKeeper(msg.sender), "keep3r::isKeeper:keeper-is-not-registered");
513     }
514 
515     // Only checks if caller is a valid keeper, payment should be handled manually
516     modifier onlyKeeper() {
517         _isKeeper();
518         _;
519     }
520 
521     // Checks if caller is a valid keeper, handles default payment after execution
522     modifier paysKeeper() {
523         _isKeeper();
524         _;
525         keep3r.worked(msg.sender);
526     }
527 }
528 
529 // 
530 interface IKeep3rV1Helper {
531     function getQuoteLimit(uint256 gasUsed) external view returns (uint256);
532 }
533 
534 // 
535 interface IUniswapV2SlidingOracle {
536     function current(
537         address tokenIn,
538         uint256 amountIn,
539         address tokenOut
540     ) external view returns (uint256);
541     
542     function pairs() external view returns (address[] memory);
543 }
544 
545 // 
546 interface IStrategy {
547     function rewards() external view returns (address);
548 
549     function gauge() external view returns (address);
550 
551     function want() external view returns (address);
552 
553     function timelock() external view returns (address);
554 
555     function deposit() external;
556 
557     function withdraw(address) external;
558 
559     function withdraw(uint256) external;
560 
561     function skim() external;
562 
563     function withdrawAll() external returns (uint256);
564 
565     function balanceOf() external view returns (uint256);
566 
567     function harvest() external;
568 
569     function setTimelock(address) external;
570 
571     function setController(address _controller) external;
572 
573     function execute(address _target, bytes calldata _data)
574         external
575         payable
576         returns (bytes memory response);
577 
578     function execute(bytes calldata _data)
579         external
580         payable
581         returns (bytes memory response);
582 }
583 
584 // 
585 interface ICrvStrategy is IStrategy {
586     function getHarvestable() external returns (uint256);
587 }
588 
589 // 
590 interface ICompStrategy is IStrategy {
591     function getCompAccrued() external returns (uint256);
592 }
593 
594 interface ICollateralizedStrategy is IStrategy {
595     function keepMinRatio() external;
596     function currentRatio() external view returns (uint256);
597     function minRatio() external view returns (uint256);
598     function setMinRatio(uint256 _minRatio) external;
599 }
600 
601 interface ILeveragedStrategy is IStrategy {
602     function leverageToMax() external;
603 }
604 
605 interface IVault {
606     function earn() external;
607     function token() external view returns (address);
608 }
609 
610 interface IERC20 {
611     function balanceOf(address account) external view returns (uint256);
612 }
613 
614 interface MMController {
615     function vaults(address _wantToken) external view returns (address);
616     function strategies(address _wantToken) external view returns (address);
617 }
618 
619 // 
620 // inspired by & thanks to https://macarse.medium.com/the-keep3r-network-experiment-bb1c5182bda3
621 // 
622 contract GenericKeep3rV2 is Keep3r, IMMStrategyHarvestKp3r {
623     using SafeMath for uint256;
624     using EnumerableSet for EnumerableSet.AddressSet;
625 
626     EnumerableSet.AddressSet internal availableStrategies;
627     EnumerableSet.AddressSet internal leveragedStrategies;
628     EnumerableSet.AddressSet internal collateralizedStrategies;
629     EnumerableSet.AddressSet internal availableVaults;
630     
631     // one-to-one mapping from vault to strategy
632     mapping(address => address) public vaultStrategies;
633     // required gas cost on strategy harvest()
634     mapping(address => uint256) public requiredHarvest;
635     // last harvest timestamp for strategy
636     mapping(address => uint256) public strategyLastHarvest;
637     // profit token yield by strategy harvest()
638     mapping(address => address) public stratagyYieldTokens;
639     // oracles used in harvest() for strategy: 
640     //    0 : slidingOracle 
641     //    1 : sushiSlidingOracle 
642     //    anything > 1 : simply use token number instead price oracle
643     mapping(address => uint256) public stratagyYieldTokenOracles;
644     // required minimum token available for vault earn(), may subject to change to make this job reasonable
645     mapping(address => uint256) public requiredEarnBalance;
646     
647     address public keep3rHelper;
648     address public slidingOracle;
649     address public sushiSlidingOracle;
650     address public mmController;
651 
652     address public constant KP3R = address(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
653     address public constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
654     address public constant CRV = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
655     address public constant COMP = address(0xc00e94Cb662C3520282E6f5717214004A7f26888);
656     address public constant MIR = address(0x09a3EcAFa817268f77BE1283176B946C4ff2E608);
657     address public constant THREECRV = address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
658     address public constant CRVRENWBTC = address(0x49849C98ae39Fff122806C06791Fa73784FB3675);
659     address public constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F );
660     address public constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 );
661     address public constant MIRUSTLP = address(0x87dA823B6fC8EB8575a235A824690fda94674c88 );
662     address public constant WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
663     address public constant LINK = address(0x514910771AF9Ca656af840dff83E8264EcF986CA);
664     address public constant ZRX = address(0xE41d2489571d322189246DaFA5ebDe1F4699F498);
665     uint256 public constant UNISWAP_ORACLE = 0;
666     uint256 public constant SUSHISWAP_ORACLE = 1;
667 
668     // The minimum number of seconds between harvest calls, once half a day
669     uint256 public minHarvestInterval = 43200;
670 
671     // The minimum multiple that `callCost` must be above the profit to be "justifiable"
672     uint256 public profitFactor = 1;
673 
674     address public governor;
675 
676     constructor(
677         address _keep3r,
678         address _keep3rHelper,
679         address _slidingOracle,
680         address _sushiSlidingOracle,
681         address _mmController
682     ) public Keep3r(_keep3r) {
683         
684         keep3rHelper = _keep3rHelper;
685         slidingOracle = _slidingOracle;
686         sushiSlidingOracle = _sushiSlidingOracle;
687         governor = msg.sender;
688 		mmController = _mmController;
689     
690         // add exisitng vaults         
691         addVault(MMController(_mmController).vaults(THREECRV), 10000 * 1e18);    // Matsutake Field   3CRV
692         addVault(MMController(_mmController).vaults(CRVRENWBTC), 1 * 1e18);      // Boletus Field     crvRENWBTC
693         addVault(MMController(_mmController).vaults(DAI), 10000 * 1e18);         // Kikurage Field    DAI
694         addVault(MMController(_mmController).vaults(USDC), 10000 * 1e6);         // Lentinula Field   USDC
695         addVault(MMController(_mmController).vaults(MIRUSTLP), 1000 * 1e18);     // Agaricus Field    MIR-UST LP
696         addVault(MMController(_mmController).vaults(WETH), 10 * 1e18);           // Russula Field     WETH
697         addVault(MMController(_mmController).vaults(WBTC), 1 * 1e18);            // Pleurotus Field   WBTC
698         addVault(MMController(_mmController).vaults(LINK), 400 * 1e18);          // Calvatia Field    LINK
699         addVault(MMController(_mmController).vaults(ZRX), 10000 * 1e18);         // Helvella Field    ZRX
700         
701         // add exisitng strategies
702         addStrategy(MMController(_mmController).vaults(THREECRV), MMController(_mmController).strategies(THREECRV), 1000000, false, false, CRV, SUSHISWAP_ORACLE);      // 3CRV              Yield $CRV
703         addStrategy(MMController(_mmController).vaults(CRVRENWBTC), MMController(_mmController).strategies(CRVRENWBTC), 1000000, false, false, CRV, SUSHISWAP_ORACLE);  // crvRENWBTC        Yield $CRV
704         addStrategy(MMController(_mmController).vaults(DAI), MMController(_mmController).strategies(DAI), 700000, false, true, COMP, SUSHISWAP_ORACLE);                 // DAI               Leveraged Yield $COMP
705         addStrategy(MMController(_mmController).vaults(USDC), MMController(_mmController).strategies(USDC), 700000, false, true, COMP, SUSHISWAP_ORACLE);               // USDC              Leveraged Yield $COMP
706         addStrategy(MMController(_mmController).vaults(MIRUSTLP), MMController(_mmController).strategies(MIRUSTLP), 850000, false, false, MIR, 1000 * 1e18);            // MIR-UST LP        Yield $MIR
707         addStrategy(MMController(_mmController).vaults(WETH), MMController(_mmController).strategies(WETH), 1100000, true, true, COMP, SUSHISWAP_ORACLE);               // WETH              Collateralized & Leveraged Yield $COMP
708         addStrategy(MMController(_mmController).vaults(WBTC), MMController(_mmController).strategies(WBTC), 700000, false, true, COMP, SUSHISWAP_ORACLE);               // WBTC              Leveraged Yield $COMP
709         addStrategy(MMController(_mmController).vaults(LINK), MMController(_mmController).strategies(LINK), 1100000, true, true, COMP, SUSHISWAP_ORACLE);               // LINK              Collateralized & Leveraged Yield $COMP
710         addStrategy(MMController(_mmController).vaults(ZRX), MMController(_mmController).strategies(ZRX), 1100000, true, true, COMP, SUSHISWAP_ORACLE);                 // ZRX               Collateralized & Leveraged Yield $COMP
711     }
712 
713     modifier onlyGovernor {
714         require(msg.sender == governor, "governable::only-governor");
715         _;
716     }
717 
718     function _setGovernor(address _governor) external onlyGovernor {
719         require(_governor != address(0), "governable::governor-should-not-be-zero-addres");
720         governor = _governor;
721     }
722 
723     // Unique method to add a strategy with specified parameters to the system
724     function addStrategy(address _vault, address _strategy, uint256 _requiredHarvest, bool _requiredKeepMinRatio, bool _requiredLeverageToMax, address yieldToken, uint256 yieldTokenOracle) public override onlyGovernor {
725         _addHarvestStrategy(_vault, _strategy, _requiredHarvest);
726         availableStrategies.add(_strategy);
727         stratagyYieldTokens[_strategy] = yieldToken;
728         stratagyYieldTokenOracles[_strategy] = yieldTokenOracle;
729         if (_requiredKeepMinRatio){
730             collateralizedStrategies.add(_strategy);
731         }
732         if (_requiredLeverageToMax){
733             leveragedStrategies.add(_strategy);
734         }
735         emit HarvestStrategyAdded(_vault, _strategy, _requiredHarvest, _requiredKeepMinRatio, _requiredLeverageToMax, yieldToken, yieldTokenOracle);
736     }
737 
738     function _addHarvestStrategy(address _vault, address _strategy, uint256 _requiredHarvest) internal {
739         require(availableVaults.contains(_vault), "generic-keep3r-v2:!availableVaults");
740         require(requiredHarvest[_strategy] == 0 && !availableStrategies.contains(_strategy), "generic-keep3r-v2:!requiredHarvest:strategy-already-added");
741         _setRequiredHarvest(_strategy, _requiredHarvest);
742         vaultStrategies[_vault] = _strategy;
743     }
744     
745     // Unique method to add a vault with specified parameters to the system
746     function addVault(address _vault, uint256 _requiredEarnBalance) public override onlyGovernor {
747         require(!availableVaults.contains(_vault), "generic-keep3r-v2:!requiredEarn:vault-already-added");
748         availableVaults.add(_vault);
749         _setRequiredEarn(_vault, _requiredEarnBalance);
750         emit EarnVaultAdded(_vault, _requiredEarnBalance);
751     }
752 
753     // Unique method to update a strategy with specified gas cost
754     function updateRequiredHarvestAmount(address _strategy, uint256 _requiredHarvest) external override onlyGovernor {
755         require(requiredHarvest[_strategy] > 0 && availableStrategies.contains(_strategy), "generic-keep3r-v2::update-required-harvest:strategy-not-added");
756         _setRequiredHarvest(_strategy, _requiredHarvest);
757         emit HarvestStrategyModified(_strategy, _requiredHarvest);
758     }
759 
760     // Unique method to update a strategy with specified yield token oracle type
761     function updateYieldTokenOracle(address _strategy, uint256 _yieldTokenOracle) external override onlyGovernor {
762         require(requiredHarvest[_strategy] > 0 && availableStrategies.contains(_strategy), "generic-keep3r-v2::update-yield-token-oracle:strategy-not-added");
763         stratagyYieldTokenOracles[_strategy] = _yieldTokenOracle;
764     }
765 
766     // Unique method to update a vault with specified required want token number for earn()
767     function updateRequiredEarn(address _vault, uint256 _requiredEarnBalance) external override onlyGovernor {
768         require(availableVaults.contains(_vault), "generic-keep3r-v2::update-required-earn:vault-not-added");
769         _setRequiredEarn(_vault, _requiredEarnBalance);
770         emit EarnVaultModified(_vault, _requiredEarnBalance);
771     }
772 
773     function removeHarvestStrategy(address _strategy) public override onlyGovernor {
774         require(requiredHarvest[_strategy] > 0 && availableStrategies.contains(_strategy), "generic-keep3r-v2::remove-harvest-strategy:strategy-not-added");
775         
776         delete requiredHarvest[_strategy];
777         availableStrategies.remove(_strategy);
778         
779         if (collateralizedStrategies.contains(_strategy)){
780             collateralizedStrategies.remove(_strategy);
781         }
782         
783         if (leveragedStrategies.contains(_strategy)){
784             leveragedStrategies.remove(_strategy);
785         }
786         
787         emit HarvestStrategyRemoved(_strategy);
788     }
789 
790     function removeEarnVault(address _vault) external override onlyGovernor {
791         require(availableVaults.contains(_vault), "generic-keep3r-v2::remove-earn-vault:vault-not-added");
792         
793         address _strategy = vaultStrategies[_vault];
794         if (_strategy != address(0) && requiredHarvest[_strategy] > 0 && availableStrategies.contains(_strategy)){
795             removeHarvestStrategy(_strategy);
796             delete vaultStrategies[_vault];
797         }
798         
799         delete requiredEarnBalance[_vault];
800         availableVaults.remove(_vault);
801         
802         emit EarnVaultRemoved(_vault);
803     }
804 
805     function setMinHarvestInterval(uint256 _interval) external override onlyGovernor {
806         require(_interval > 0, "!_interval");
807         minHarvestInterval = _interval;
808     }
809 
810     function setProfitFactor(uint256 _profitFactor) external override onlyGovernor {
811         require(_profitFactor > 0, "!_profitFactor");
812         profitFactor = _profitFactor;
813     }
814 
815     function setKeep3r(address _keep3r) external override onlyGovernor {
816         _setKeep3r(_keep3r);
817         emit Keep3rSet(_keep3r);
818     }
819 
820     function setKeep3rHelper(address _keep3rHelper) external override onlyGovernor {
821         keep3rHelper = _keep3rHelper;
822         emit Keep3rHelperSet(_keep3rHelper);
823     }
824 
825     function setSlidingOracle(address _slidingOracle) external override onlyGovernor {
826         slidingOracle = _slidingOracle;
827         emit SlidingOracleSet(_slidingOracle);
828     }
829 
830     function setSushiSlidingOracle(address _sushiSlidingOracle) external override onlyGovernor {
831         sushiSlidingOracle = _sushiSlidingOracle;
832     }
833 
834     function _setRequiredEarn(address _vault, uint256 _requiredEarnBalance) internal {
835         if (_requiredEarnBalance > 0){
836             requiredEarnBalance[_vault] = _requiredEarnBalance;
837         }
838     }
839 
840     function _setRequiredHarvest(address _strategy, uint256 _requiredHarvest) internal {
841         if (_requiredHarvest > 0){
842             requiredHarvest[_strategy] = _requiredHarvest;
843         }
844     }
845 
846     // Getters
847     function name() external pure override returns (string memory) {
848         return "Generic Keep3r for Mushrooms Finance";
849     }
850 
851     function getStrategies() public view override returns (address[] memory _strategies) {
852         _strategies = new address[](availableStrategies.length());
853         for (uint256 i; i < availableStrategies.length(); i++) {
854             _strategies[i] = availableStrategies.at(i);
855         }
856     }
857 
858     function getCollateralizedStrategies() public view override returns (address[] memory _strategies) {
859         _strategies = new address[](collateralizedStrategies.length());
860         for (uint256 i; i < collateralizedStrategies.length(); i++) {
861             _strategies[i] = collateralizedStrategies.at(i);
862         }
863     }
864 
865     function getVaults() public view override returns (address[] memory _vaults) {
866         _vaults = new address[](availableVaults.length());
867         for (uint256 i; i < availableVaults.length(); i++) {
868             _vaults[i] = availableVaults.at(i);
869         }
870     }
871 
872     // this method is not specified as view since some strategy maybe not able to return accurate underlying profit in snapshot,
873 	// please use something similar to below tool to query
874 	// https://docs.ethers.io/v5/api/contract/contract/#contract-callStatic
875     function harvestable(address _strategy) public override returns (bool) {
876         require(requiredHarvest[_strategy] > 0, "generic-keep3r-v2::harvestable:strategy-not-added");
877 
878         // Should not trigger if had been called recently
879         if (strategyLastHarvest[_strategy] > 0 && block.timestamp.sub(strategyLastHarvest[_strategy]) <= minHarvestInterval){
880             return false;
881         }
882 
883         // quote from keep3r network for specified workload
884         uint256 kp3rCallCost = IKeep3rV1Helper(keep3rHelper).getQuoteLimit(requiredHarvest[_strategy]);
885         // get ETH gas cost by querying uniswap sliding oracle
886         uint256 ethCallCost = IUniswapV2SlidingOracle(sushiSlidingOracle).current(KP3R, kp3rCallCost, WETH);
887         
888         // estimate yield profit to harvest
889         uint256 profitTokenAmount = 0;
890         address yieldToken = stratagyYieldTokens[_strategy];
891         uint256 yieldTokenOracle = stratagyYieldTokenOracles[_strategy];
892         if (yieldToken == COMP){
893             profitTokenAmount = ICompStrategy(_strategy).getCompAccrued();
894         } else{
895             profitTokenAmount = ICrvStrategy(_strategy).getHarvestable();
896         }
897             
898         if (yieldTokenOracle > SUSHISWAP_ORACLE){ // no oracle to use, just use token number
899             emit HarvestableCheck(_strategy, profitTokenAmount, profitFactor, 0, ethCallCost);
900             return (profitTokenAmount >= yieldTokenOracle);
901         } else{
902             address oracle = yieldTokenOracle == UNISWAP_ORACLE? slidingOracle : sushiSlidingOracle;
903             uint256 profitInEther = IUniswapV2SlidingOracle(oracle).current(yieldToken, profitTokenAmount, WETH);
904             emit HarvestableCheck(_strategy, profitTokenAmount, profitFactor, profitInEther, ethCallCost);
905             return (profitInEther >= profitFactor.mul(ethCallCost));
906         }
907     }
908     
909     function earnable(address _vault) public view override returns (bool) {
910         require(availableVaults.contains(_vault), "generic-keep3r-v2::earnable:vault-not-added");
911         return (IERC20(IVault(_vault).token()).balanceOf(_vault) >= requiredEarnBalance[_vault]);
912     }
913     
914     function keepMinRatioMayday(address _strategy) public view override returns (bool) {
915         require(collateralizedStrategies.contains(_strategy), "generic-keep3r-v2::keepMinRatioMayday:strategy-not-added");
916         return ICollateralizedStrategy(_strategy).currentRatio() <= (ICollateralizedStrategy(_strategy).minRatio() * 9000 / 10000);
917     }
918 
919     // harvest() actions for Keep3r
920     function harvest(address _strategy) external override paysKeeper {
921         require(harvestable(_strategy), "generic-keep3r-v2::harvest:not-workable");
922         IStrategy(_strategy).harvest();
923         strategyLastHarvest[_strategy] = block.timestamp;
924         emit HarvestedByKeeper(_strategy);
925     }
926 
927     // earn() actions for Keep3r
928     function earn(address _vault) external override paysKeeper {
929         require(earnable(_vault), "generic-keep3r-v2::earn:not-workable");
930         IVault(_vault).earn();
931         address _strategy = vaultStrategies[_vault];
932         if (_strategy != address(0) && requiredHarvest[_strategy] > 0 && leveragedStrategies.contains(_strategy)){
933             ILeveragedStrategy(_strategy).leverageToMax();
934         }
935     }
936 
937     // keepMinRatio() actions for Keep3r
938     function keepMinRatio(address _strategy) external override paysKeeper {
939         require(keepMinRatioMayday(_strategy), "generic-keep3r-v2::keepMinRatio:not-workable");
940         ICollateralizedStrategy(_strategy).keepMinRatio();
941     }
942 }