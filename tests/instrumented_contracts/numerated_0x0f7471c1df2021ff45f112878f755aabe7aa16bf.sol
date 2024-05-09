1 /**
2 * Commit sha: 057b118bce7af86318eb522112350f950e9b7834
3 * GitHub repository: https://github.com/aragon/aragon-court
4 * Tool used for the deploy: https://github.com/aragon/aragon-network-deploy
5 **/
6 
7 // File: contracts/lib/os/ERC20.sol
8 
9 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/token/ERC20.sol
10 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
11 
12 pragma solidity ^0.5.8;
13 
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 {
20     function totalSupply() public view returns (uint256);
21 
22     function balanceOf(address _who) public view returns (uint256);
23 
24     function allowance(address _owner, address _spender) public view returns (uint256);
25 
26     function transfer(address _to, uint256 _value) public returns (bool);
27 
28     function approve(address _spender, uint256 _value) public returns (bool);
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
31 
32     event Transfer(
33         address indexed from,
34         address indexed to,
35         uint256 value
36     );
37 
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 // File: contracts/lib/os/SafeERC20.sol
46 
47 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/SafeERC20.sol
48 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
49 
50 pragma solidity ^0.5.8;
51 
52 
53 
54 library SafeERC20 {
55     // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
56     // https://github.com/ethereum/solidity/issues/3544
57     bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;
58 
59     /**
60     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
61     *      Note that this makes an external call to the token.
62     */
63     function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
64         bytes memory transferCallData = abi.encodeWithSelector(
65             TRANSFER_SELECTOR,
66             _to,
67             _amount
68         );
69         return invokeAndCheckSuccess(address(_token), transferCallData);
70     }
71 
72     /**
73     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
74     *      Note that this makes an external call to the token.
75     */
76     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
77         bytes memory transferFromCallData = abi.encodeWithSelector(
78             _token.transferFrom.selector,
79             _from,
80             _to,
81             _amount
82         );
83         return invokeAndCheckSuccess(address(_token), transferFromCallData);
84     }
85 
86     /**
87     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
88     *      Note that this makes an external call to the token.
89     */
90     function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
91         bytes memory approveCallData = abi.encodeWithSelector(
92             _token.approve.selector,
93             _spender,
94             _amount
95         );
96         return invokeAndCheckSuccess(address(_token), approveCallData);
97     }
98 
99     function invokeAndCheckSuccess(address _addr, bytes memory _calldata) private returns (bool) {
100         bool ret;
101         assembly {
102             let ptr := mload(0x40)    // free memory pointer
103 
104             let success := call(
105                 gas,                  // forward all gas
106                 _addr,                // address
107                 0,                    // no value
108                 add(_calldata, 0x20), // calldata start
109                 mload(_calldata),     // calldata length
110                 ptr,                  // write output over free memory
111                 0x20                  // uint256 return
112             )
113 
114             if gt(success, 0) {
115             // Check number of bytes returned from last function call
116                 switch returndatasize
117 
118                 // No bytes returned: assume success
119                 case 0 {
120                     ret := 1
121                 }
122 
123                 // 32 bytes returned: check if non-zero
124                 case 0x20 {
125                 // Only return success if returned data was true
126                 // Already have output in ptr
127                     ret := eq(mload(ptr), 1)
128                 }
129 
130                 // Not sure what was returned: don't mark as success
131                 default { }
132             }
133         }
134         return ret;
135     }
136 }
137 
138 // File: contracts/lib/os/SafeMath.sol
139 
140 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath.sol
141 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
142 
143 pragma solidity >=0.4.24 <0.6.0;
144 
145 
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that revert on error
149  */
150 library SafeMath {
151     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
152     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
153     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
154     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
155 
156     /**
157     * @dev Multiplies two numbers, reverts on overflow.
158     */
159     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
163         if (_a == 0) {
164             return 0;
165         }
166 
167         uint256 c = _a * _b;
168         require(c / _a == _b, ERROR_MUL_OVERFLOW);
169 
170         return c;
171     }
172 
173     /**
174     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
175     */
176     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
177         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
178         uint256 c = _a / _b;
179         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
180 
181         return c;
182     }
183 
184     /**
185     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
186     */
187     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
188         require(_b <= _a, ERROR_SUB_UNDERFLOW);
189         uint256 c = _a - _b;
190 
191         return c;
192     }
193 
194     /**
195     * @dev Adds two numbers, reverts on overflow.
196     */
197     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
198         uint256 c = _a + _b;
199         require(c >= _a, ERROR_ADD_OVERFLOW);
200 
201         return c;
202     }
203 
204     /**
205     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
206     * reverts when dividing by zero.
207     */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b != 0, ERROR_DIV_ZERO);
210         return a % b;
211     }
212 }
213 
214 // File: contracts/registry/IJurorsRegistry.sol
215 
216 pragma solidity ^0.5.8;
217 
218 
219 
220 interface IJurorsRegistry {
221 
222     /**
223     * @dev Assign a requested amount of juror tokens to a juror
224     * @param _juror Juror to add an amount of tokens to
225     * @param _amount Amount of tokens to be added to the available balance of a juror
226     */
227     function assignTokens(address _juror, uint256 _amount) external;
228 
229     /**
230     * @dev Burn a requested amount of juror tokens
231     * @param _amount Amount of tokens to be burned
232     */
233     function burnTokens(uint256 _amount) external;
234 
235     /**
236     * @dev Draft a set of jurors based on given requirements for a term id
237     * @param _params Array containing draft requirements:
238     *        0. bytes32 Term randomness
239     *        1. uint256 Dispute id
240     *        2. uint64  Current term id
241     *        3. uint256 Number of seats already filled
242     *        4. uint256 Number of seats left to be filled
243     *        5. uint64  Number of jurors required for the draft
244     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
245     *
246     * @return jurors List of jurors selected for the draft
247     * @return length Size of the list of the draft result
248     */
249     function draft(uint256[7] calldata _params) external returns (address[] memory jurors, uint256 length);
250 
251     /**
252     * @dev Slash a set of jurors based on their votes compared to the winning ruling
253     * @param _termId Current term id
254     * @param _jurors List of juror addresses to be slashed
255     * @param _lockedAmounts List of amounts locked for each corresponding juror that will be either slashed or returned
256     * @param _rewardedJurors List of booleans to tell whether a juror's active balance has to be slashed or not
257     * @return Total amount of slashed tokens
258     */
259     function slashOrUnlock(uint64 _termId, address[] calldata _jurors, uint256[] calldata _lockedAmounts, bool[] calldata _rewardedJurors)
260         external
261         returns (uint256 collectedTokens);
262 
263     /**
264     * @dev Try to collect a certain amount of tokens from a juror for the next term
265     * @param _juror Juror to collect the tokens from
266     * @param _amount Amount of tokens to be collected from the given juror and for the requested term id
267     * @param _termId Current term id
268     * @return True if the juror has enough unlocked tokens to be collected for the requested term, false otherwise
269     */
270     function collectTokens(address _juror, uint256 _amount, uint64 _termId) external returns (bool);
271 
272     /**
273     * @dev Lock a juror's withdrawals until a certain term ID
274     * @param _juror Address of the juror to be locked
275     * @param _termId Term ID until which the juror's withdrawals will be locked
276     */
277     function lockWithdrawals(address _juror, uint64 _termId) external;
278 
279     /**
280     * @dev Tell the active balance of a juror for a given term id
281     * @param _juror Address of the juror querying the active balance of
282     * @param _termId Term ID querying the active balance for
283     * @return Amount of active tokens for juror in the requested past term id
284     */
285     function activeBalanceOfAt(address _juror, uint64 _termId) external view returns (uint256);
286 
287     /**
288     * @dev Tell the total amount of active juror tokens at the given term id
289     * @param _termId Term ID querying the total active balance for
290     * @return Total amount of active juror tokens at the given term id
291     */
292     function totalActiveBalanceAt(uint64 _termId) external view returns (uint256);
293 }
294 
295 // File: contracts/lib/BytesHelpers.sol
296 
297 pragma solidity ^0.5.8;
298 
299 
300 library BytesHelpers {
301     function toBytes4(bytes memory _self) internal pure returns (bytes4 result) {
302         if (_self.length < 4) {
303             return bytes4(0);
304         }
305 
306         assembly { result := mload(add(_self, 0x20)) }
307     }
308 }
309 
310 // File: contracts/lib/Checkpointing.sol
311 
312 pragma solidity ^0.5.8;
313 
314 
315 /**
316 * @title Checkpointing - Library to handle a historic set of numeric values
317 */
318 library Checkpointing {
319     uint256 private constant MAX_UINT192 = uint256(uint192(-1));
320 
321     string private constant ERROR_VALUE_TOO_BIG = "CHECKPOINT_VALUE_TOO_BIG";
322     string private constant ERROR_CANNOT_ADD_PAST_VALUE = "CHECKPOINT_CANNOT_ADD_PAST_VALUE";
323 
324     /**
325     * @dev To specify a value at a given point in time, we need to store two values:
326     *      - `time`: unit-time value to denote the first time when a value was registered
327     *      - `value`: a positive numeric value to registered at a given point in time
328     *
329     *      Note that `time` does not need to refer necessarily to a timestamp value, any time unit could be used
330     *      for it like block numbers, terms, etc.
331     */
332     struct Checkpoint {
333         uint64 time;
334         uint192 value;
335     }
336 
337     /**
338     * @dev A history simply denotes a list of checkpoints
339     */
340     struct History {
341         Checkpoint[] history;
342     }
343 
344     /**
345     * @dev Add a new value to a history for a given point in time. This function does not allow to add values previous
346     *      to the latest registered value, if the value willing to add corresponds to the latest registered value, it
347     *      will be updated.
348     * @param self Checkpoints history to be altered
349     * @param _time Point in time to register the given value
350     * @param _value Numeric value to be registered at the given point in time
351     */
352     function add(History storage self, uint64 _time, uint256 _value) internal {
353         require(_value <= MAX_UINT192, ERROR_VALUE_TOO_BIG);
354         _add192(self, _time, uint192(_value));
355     }
356 
357     /**
358     * @dev Fetch the latest registered value of history, it will return zero if there was no value registered
359     * @param self Checkpoints history to be queried
360     */
361     function getLast(History storage self) internal view returns (uint256) {
362         uint256 length = self.history.length;
363         if (length > 0) {
364             return uint256(self.history[length - 1].value);
365         }
366 
367         return 0;
368     }
369 
370     /**
371     * @dev Fetch the most recent registered past value of a history based on a given point in time that is not known
372     *      how recent it is beforehand. It will return zero if there is no registered value or if given time is
373     *      previous to the first registered value.
374     *      It uses a binary search.
375     * @param self Checkpoints history to be queried
376     * @param _time Point in time to query the most recent registered past value of
377     */
378     function get(History storage self, uint64 _time) internal view returns (uint256) {
379         return _binarySearch(self, _time);
380     }
381 
382     /**
383     * @dev Fetch the most recent registered past value of a history based on a given point in time. It will return zero
384     *      if there is no registered value or if given time is previous to the first registered value.
385     *      It uses a linear search starting from the end.
386     * @param self Checkpoints history to be queried
387     * @param _time Point in time to query the most recent registered past value of
388     */
389     function getRecent(History storage self, uint64 _time) internal view returns (uint256) {
390         return _backwardsLinearSearch(self, _time);
391     }
392 
393     /**
394     * @dev Private function to add a new value to a history for a given point in time. This function does not allow to
395     *      add values previous to the latest registered value, if the value willing to add corresponds to the latest
396     *      registered value, it will be updated.
397     * @param self Checkpoints history to be altered
398     * @param _time Point in time to register the given value
399     * @param _value Numeric value to be registered at the given point in time
400     */
401     function _add192(History storage self, uint64 _time, uint192 _value) private {
402         uint256 length = self.history.length;
403         if (length == 0 || self.history[self.history.length - 1].time < _time) {
404             // If there was no value registered or the given point in time is after the latest registered value,
405             // we can insert it to the history directly.
406             self.history.push(Checkpoint(_time, _value));
407         } else {
408             // If the point in time given for the new value is not after the latest registered value, we must ensure
409             // we are only trying to update the latest value, otherwise we would be changing past data.
410             Checkpoint storage currentCheckpoint = self.history[length - 1];
411             require(_time == currentCheckpoint.time, ERROR_CANNOT_ADD_PAST_VALUE);
412             currentCheckpoint.value = _value;
413         }
414     }
415 
416     /**
417     * @dev Private function to execute a backwards linear search to find the most recent registered past value of a
418     *      history based on a given point in time. It will return zero if there is no registered value or if given time
419     *      is previous to the first registered value. Note that this function will be more suitable when we already know
420     *      that the time used to index the search is recent in the given history.
421     * @param self Checkpoints history to be queried
422     * @param _time Point in time to query the most recent registered past value of
423     */
424     function _backwardsLinearSearch(History storage self, uint64 _time) private view returns (uint256) {
425         // If there was no value registered for the given history return simply zero
426         uint256 length = self.history.length;
427         if (length == 0) {
428             return 0;
429         }
430 
431         uint256 index = length - 1;
432         Checkpoint storage checkpoint = self.history[index];
433         while (index > 0 && checkpoint.time > _time) {
434             index--;
435             checkpoint = self.history[index];
436         }
437 
438         return checkpoint.time > _time ? 0 : uint256(checkpoint.value);
439     }
440 
441     /**
442     * @dev Private function execute a binary search to find the most recent registered past value of a history based on
443     *      a given point in time. It will return zero if there is no registered value or if given time is previous to
444     *      the first registered value. Note that this function will be more suitable when don't know how recent the
445     *      time used to index may be.
446     * @param self Checkpoints history to be queried
447     * @param _time Point in time to query the most recent registered past value of
448     */
449     function _binarySearch(History storage self, uint64 _time) private view returns (uint256) {
450         // If there was no value registered for the given history return simply zero
451         uint256 length = self.history.length;
452         if (length == 0) {
453             return 0;
454         }
455 
456         // If the requested time is equal to or after the time of the latest registered value, return latest value
457         uint256 lastIndex = length - 1;
458         if (_time >= self.history[lastIndex].time) {
459             return uint256(self.history[lastIndex].value);
460         }
461 
462         // If the requested time is previous to the first registered value, return zero to denote missing checkpoint
463         if (_time < self.history[0].time) {
464             return 0;
465         }
466 
467         // Execute a binary search between the checkpointed times of the history
468         uint256 low = 0;
469         uint256 high = lastIndex;
470 
471         while (high > low) {
472             // No need for SafeMath: for this to overflow array size should be ~2^255
473             uint256 mid = (high + low + 1) / 2;
474             Checkpoint storage checkpoint = self.history[mid];
475             uint64 midTime = checkpoint.time;
476 
477             if (_time > midTime) {
478                 low = mid;
479             } else if (_time < midTime) {
480                 // No need for SafeMath: high > low >= 0 => high >= 1 => mid >= 1
481                 high = mid - 1;
482             } else {
483                 return uint256(checkpoint.value);
484             }
485         }
486 
487         return uint256(self.history[low].value);
488     }
489 }
490 
491 // File: contracts/lib/HexSumTree.sol
492 
493 pragma solidity ^0.5.8;
494 
495 
496 
497 
498 /**
499 * @title HexSumTree - Library to operate checkpointed 16-ary (hex) sum trees.
500 * @dev A sum tree is a particular case of a tree where the value of a node is equal to the sum of the values of its
501 *      children. This library provides a set of functions to operate 16-ary sum trees, i.e. trees where every non-leaf
502 *      node has 16 children and its value is equivalent to the sum of the values of all of them. Additionally, a
503 *      checkpointed tree means that each time a value on a node is updated, its previous value will be saved to allow
504 *      accessing historic information.
505 *
506 *      Example of a checkpointed binary sum tree:
507 *
508 *                                          CURRENT                                      PREVIOUS
509 *
510 *             Level 2                        100  ---------------------------------------- 70
511 *                                       ______|_______                               ______|_______
512 *                                      /              \                             /              \
513 *             Level 1                 34              66 ------------------------- 23              47
514 *                                _____|_____      _____|_____                 _____|_____      _____|_____
515 *                               /           \    /           \               /           \    /           \
516 *             Level 0          22           12  53           13 ----------- 22            1  17           30
517 *
518 */
519 library HexSumTree {
520     using SafeMath for uint256;
521     using Checkpointing for Checkpointing.History;
522 
523     string private constant ERROR_UPDATE_OVERFLOW = "SUM_TREE_UPDATE_OVERFLOW";
524     string private constant ERROR_KEY_DOES_NOT_EXIST = "SUM_TREE_KEY_DOES_NOT_EXIST";
525     string private constant ERROR_SEARCH_OUT_OF_BOUNDS = "SUM_TREE_SEARCH_OUT_OF_BOUNDS";
526     string private constant ERROR_MISSING_SEARCH_VALUES = "SUM_TREE_MISSING_SEARCH_VALUES";
527 
528     // Constants used to perform tree computations
529     // To change any the following constants, the following relationship must be kept: 2^BITS_IN_NIBBLE = CHILDREN
530     // The max depth of the tree will be given by: BITS_IN_NIBBLE * MAX_DEPTH = 256 (so in this case it's 64)
531     uint256 private constant CHILDREN = 16;
532     uint256 private constant BITS_IN_NIBBLE = 4;
533 
534     // All items are leaves, inserted at height or level zero. The root height will be increasing as new levels are inserted in the tree.
535     uint256 private constant ITEMS_LEVEL = 0;
536 
537     // Tree nodes are identified with a 32-bytes length key. Leaves are identified with consecutive incremental keys
538     // starting with 0x0000000000000000000000000000000000000000000000000000000000000000, while non-leaf nodes' keys
539     // are computed based on their level and their children keys.
540     uint256 private constant BASE_KEY = 0;
541 
542     // Timestamp used to checkpoint the first value of the tree height during initialization
543     uint64 private constant INITIALIZATION_INITIAL_TIME = uint64(0);
544 
545     /**
546     * @dev The tree is stored using the following structure:
547     *      - nodes: A mapping indexed by a pair (level, key) with a history of the values for each node (level -> key -> value).
548     *      - height: A history of the heights of the tree. Minimum height is 1, a root with 16 children.
549     *      - nextKey: The next key to be used to identify the next new value that will be inserted into the tree.
550     */
551     struct Tree {
552         uint256 nextKey;
553         Checkpointing.History height;
554         mapping (uint256 => mapping (uint256 => Checkpointing.History)) nodes;
555     }
556 
557     /**
558     * @dev Search params to traverse the tree caching previous results:
559     *      - time: Point in time to query the values being searched, this value shouldn't change during a search
560     *      - level: Level being analyzed for the search, it starts at the level under the root and decrements till the leaves
561     *      - parentKey: Key of the parent of the nodes being analyzed at the given level for the search
562     *      - foundValues: Number of values in the list being searched that were already found, it will go from 0 until the size of the list
563     *      - visitedTotal: Total sum of values that were already visited during the search, it will go from 0 until the tree total
564     */
565     struct SearchParams {
566         uint64 time;
567         uint256 level;
568         uint256 parentKey;
569         uint256 foundValues;
570         uint256 visitedTotal;
571     }
572 
573     /**
574     * @dev Initialize tree setting the next key and first height checkpoint
575     */
576     function init(Tree storage self) internal {
577         self.height.add(INITIALIZATION_INITIAL_TIME, ITEMS_LEVEL + 1);
578         self.nextKey = BASE_KEY;
579     }
580 
581     /**
582     * @dev Insert a new item to the tree at given point in time
583     * @param _time Point in time to register the given value
584     * @param _value New numeric value to be added to the tree
585     * @return Unique key identifying the new value inserted
586     */
587     function insert(Tree storage self, uint64 _time, uint256 _value) internal returns (uint256) {
588         // As the values are always stored in the leaves of the tree (level 0), the key to index each of them will be
589         // always incrementing, starting from zero. Add a new level if necessary.
590         uint256 key = self.nextKey++;
591         _addLevelIfNecessary(self, key, _time);
592 
593         // If the new value is not zero, first set the value of the new leaf node, then add a new level at the top of
594         // the tree if necessary, and finally update sums cached in all the non-leaf nodes.
595         if (_value > 0) {
596             _add(self, ITEMS_LEVEL, key, _time, _value);
597             _updateSums(self, key, _time, _value, true);
598         }
599         return key;
600     }
601 
602     /**
603     * @dev Set the value of a leaf node indexed by its key at given point in time
604     * @param _time Point in time to set the given value
605     * @param _key Key of the leaf node to be set in the tree
606     * @param _value New numeric value to be set for the given key
607     */
608     function set(Tree storage self, uint256 _key, uint64 _time, uint256 _value) internal {
609         require(_key < self.nextKey, ERROR_KEY_DOES_NOT_EXIST);
610 
611         // Set the new value for the requested leaf node
612         uint256 lastValue = getItem(self, _key);
613         _add(self, ITEMS_LEVEL, _key, _time, _value);
614 
615         // Update sums cached in the non-leaf nodes. Note that overflows are being checked at the end of the whole update.
616         if (_value > lastValue) {
617             _updateSums(self, _key, _time, _value - lastValue, true);
618         } else if (_value < lastValue) {
619             _updateSums(self, _key, _time, lastValue - _value, false);
620         }
621     }
622 
623     /**
624     * @dev Update the value of a non-leaf node indexed by its key at given point in time based on a delta
625     * @param _key Key of the leaf node to be updated in the tree
626     * @param _time Point in time to update the given value
627     * @param _delta Numeric delta to update the value of the given key
628     * @param _positive Boolean to tell whether the given delta should be added to or subtracted from the current value
629     */
630     function update(Tree storage self, uint256 _key, uint64 _time, uint256 _delta, bool _positive) internal {
631         require(_key < self.nextKey, ERROR_KEY_DOES_NOT_EXIST);
632 
633         // Update the value of the requested leaf node based on the given delta
634         uint256 lastValue = getItem(self, _key);
635         uint256 newValue = _positive ? lastValue.add(_delta) : lastValue.sub(_delta);
636         _add(self, ITEMS_LEVEL, _key, _time, newValue);
637 
638         // Update sums cached in the non-leaf nodes. Note that overflows is being checked at the end of the whole update.
639         _updateSums(self, _key, _time, _delta, _positive);
640     }
641 
642     /**
643     * @dev Search a list of values in the tree at a given point in time. It will return a list with the nearest
644     *      high value in case a value cannot be found. This function assumes the given list of given values to be
645     *      searched is in ascending order. In case of searching a value out of bounds, it will return zeroed results.
646     * @param _values Ordered list of values to be searched in the tree
647     * @param _time Point in time to query the values being searched
648     * @return keys List of keys found for each requested value in the same order
649     * @return values List of node values found for each requested value in the same order
650     */
651     function search(Tree storage self, uint256[] memory _values, uint64 _time) internal view
652         returns (uint256[] memory keys, uint256[] memory values)
653     {
654         require(_values.length > 0, ERROR_MISSING_SEARCH_VALUES);
655 
656         // Throw out-of-bounds error if there are no items in the tree or the highest value being searched is greater than the total
657         uint256 total = getRecentTotalAt(self, _time);
658         // No need for SafeMath: positive length of array already checked
659         require(total > 0 && total > _values[_values.length - 1], ERROR_SEARCH_OUT_OF_BOUNDS);
660 
661         // Build search params for the first iteration
662         uint256 rootLevel = getRecentHeightAt(self, _time);
663         SearchParams memory searchParams = SearchParams(_time, rootLevel.sub(1), BASE_KEY, 0, 0);
664 
665         // These arrays will be used to fill in the results. We are passing them as parameters to avoid extra copies
666         uint256 length = _values.length;
667         keys = new uint256[](length);
668         values = new uint256[](length);
669         _search(self, _values, searchParams, keys, values);
670     }
671 
672     /**
673     * @dev Tell the sum of the all the items (leaves) stored in the tree, i.e. value of the root of the tree
674     */
675     function getTotal(Tree storage self) internal view returns (uint256) {
676         uint256 rootLevel = getHeight(self);
677         return getNode(self, rootLevel, BASE_KEY);
678     }
679 
680     /**
681     * @dev Tell the sum of the all the items (leaves) stored in the tree, i.e. value of the root of the tree, at a given point in time
682     *      It uses a binary search for the root node, a linear one for the height.
683     * @param _time Point in time to query the sum of all the items (leaves) stored in the tree
684     */
685     function getTotalAt(Tree storage self, uint64 _time) internal view returns (uint256) {
686         uint256 rootLevel = getRecentHeightAt(self, _time);
687         return getNodeAt(self, rootLevel, BASE_KEY, _time);
688     }
689 
690     /**
691     * @dev Tell the sum of the all the items (leaves) stored in the tree, i.e. value of the root of the tree, at a given point in time
692     *      It uses a linear search starting from the end.
693     * @param _time Point in time to query the sum of all the items (leaves) stored in the tree
694     */
695     function getRecentTotalAt(Tree storage self, uint64 _time) internal view returns (uint256) {
696         uint256 rootLevel = getRecentHeightAt(self, _time);
697         return getRecentNodeAt(self, rootLevel, BASE_KEY, _time);
698     }
699 
700     /**
701     * @dev Tell the value of a certain leaf indexed by a given key
702     * @param _key Key of the leaf node querying the value of
703     */
704     function getItem(Tree storage self, uint256 _key) internal view returns (uint256) {
705         return getNode(self, ITEMS_LEVEL, _key);
706     }
707 
708     /**
709     * @dev Tell the value of a certain leaf indexed by a given key at a given point in time
710     *      It uses a binary search.
711     * @param _key Key of the leaf node querying the value of
712     * @param _time Point in time to query the value of the requested leaf
713     */
714     function getItemAt(Tree storage self, uint256 _key, uint64 _time) internal view returns (uint256) {
715         return getNodeAt(self, ITEMS_LEVEL, _key, _time);
716     }
717 
718     /**
719     * @dev Tell the value of a certain node indexed by a given (level,key) pair
720     * @param _level Level of the node querying the value of
721     * @param _key Key of the node querying the value of
722     */
723     function getNode(Tree storage self, uint256 _level, uint256 _key) internal view returns (uint256) {
724         return self.nodes[_level][_key].getLast();
725     }
726 
727     /**
728     * @dev Tell the value of a certain node indexed by a given (level,key) pair at a given point in time
729     *      It uses a binary search.
730     * @param _level Level of the node querying the value of
731     * @param _key Key of the node querying the value of
732     * @param _time Point in time to query the value of the requested node
733     */
734     function getNodeAt(Tree storage self, uint256 _level, uint256 _key, uint64 _time) internal view returns (uint256) {
735         return self.nodes[_level][_key].get(_time);
736     }
737 
738     /**
739     * @dev Tell the value of a certain node indexed by a given (level,key) pair at a given point in time
740     *      It uses a linear search starting from the end.
741     * @param _level Level of the node querying the value of
742     * @param _key Key of the node querying the value of
743     * @param _time Point in time to query the value of the requested node
744     */
745     function getRecentNodeAt(Tree storage self, uint256 _level, uint256 _key, uint64 _time) internal view returns (uint256) {
746         return self.nodes[_level][_key].getRecent(_time);
747     }
748 
749     /**
750     * @dev Tell the height of the tree
751     */
752     function getHeight(Tree storage self) internal view returns (uint256) {
753         return self.height.getLast();
754     }
755 
756     /**
757     * @dev Tell the height of the tree at a given point in time
758     *      It uses a linear search starting from the end.
759     * @param _time Point in time to query the height of the tree
760     */
761     function getRecentHeightAt(Tree storage self, uint64 _time) internal view returns (uint256) {
762         return self.height.getRecent(_time);
763     }
764 
765     /**
766     * @dev Private function to update the values of all the ancestors of the given leaf node based on the delta updated
767     * @param _key Key of the leaf node to update the ancestors of
768     * @param _time Point in time to update the ancestors' values of the given leaf node
769     * @param _delta Numeric delta to update the ancestors' values of the given leaf node
770     * @param _positive Boolean to tell whether the given delta should be added to or subtracted from ancestors' values
771     */
772     function _updateSums(Tree storage self, uint256 _key, uint64 _time, uint256 _delta, bool _positive) private {
773         uint256 mask = uint256(-1);
774         uint256 ancestorKey = _key;
775         uint256 currentHeight = getHeight(self);
776         for (uint256 level = ITEMS_LEVEL + 1; level <= currentHeight; level++) {
777             // Build a mask to get the key of the ancestor at a certain level. For example:
778             // Level  0: leaves don't have children
779             // Level  1: 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0 (up to 16 leaves)
780             // Level  2: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 (up to 32 leaves)
781             // ...
782             // Level 63: 0x0000000000000000000000000000000000000000000000000000000000000000 (up to 16^64 leaves - tree max height)
783             mask = mask << BITS_IN_NIBBLE;
784 
785             // The key of the ancestor at that level "i" is equivalent to the "(64 - i)-th" most significant nibbles
786             // of the ancestor's key of the previous level "i - 1". Thus, we can compute the key of an ancestor at a
787             // certain level applying the mask to the ancestor's key of the previous level. Note that for the first
788             // iteration, the key of the ancestor of the previous level is simply the key of the leaf being updated.
789             ancestorKey = ancestorKey & mask;
790 
791             // Update value
792             uint256 lastValue = getNode(self, level, ancestorKey);
793             uint256 newValue = _positive ? lastValue.add(_delta) : lastValue.sub(_delta);
794             _add(self, level, ancestorKey, _time, newValue);
795         }
796 
797         // Check if there was an overflow. Note that we only need to check the value stored in the root since the
798         // sum only increases going up through the tree.
799         require(!_positive || getNode(self, currentHeight, ancestorKey) >= _delta, ERROR_UPDATE_OVERFLOW);
800     }
801 
802     /**
803     * @dev Private function to add a new level to the tree based on a new key that will be inserted
804     * @param _newKey New key willing to be inserted in the tree
805     * @param _time Point in time when the new key will be inserted
806     */
807     function _addLevelIfNecessary(Tree storage self, uint256 _newKey, uint64 _time) private {
808         uint256 currentHeight = getHeight(self);
809         if (_shouldAddLevel(currentHeight, _newKey)) {
810             // Max height allowed for the tree is 64 since we are using node keys of 32 bytes. However, note that we
811             // are not checking if said limit has been hit when inserting new leaves to the tree, for the purpose of
812             // this system having 2^256 items inserted is unrealistic.
813             uint256 newHeight = currentHeight + 1;
814             uint256 rootValue = getNode(self, currentHeight, BASE_KEY);
815             _add(self, newHeight, BASE_KEY, _time, rootValue);
816             self.height.add(_time, newHeight);
817         }
818     }
819 
820     /**
821     * @dev Private function to register a new value in the history of a node at a given point in time
822     * @param _level Level of the node to add a new value at a given point in time to
823     * @param _key Key of the node to add a new value at a given point in time to
824     * @param _time Point in time to register a value for the given node
825     * @param _value Numeric value to be registered for the given node at a given point in time
826     */
827     function _add(Tree storage self, uint256 _level, uint256 _key, uint64 _time, uint256 _value) private {
828         self.nodes[_level][_key].add(_time, _value);
829     }
830 
831     /**
832     * @dev Recursive pre-order traversal function
833     *      Every time it checks a node, it traverses the input array to find the initial subset of elements that are
834     *      below its accumulated value and passes that sub-array to the next iteration. Actually, the array is always
835     *      the same, to avoid making extra copies, it just passes the number of values already found , to avoid
836     *      checking values that went through a different branch. The same happens with the result lists of keys and
837     *      values, these are the same on every recursion step. The visited total is carried over each iteration to
838     *      avoid having to subtract all elements in the array.
839     * @param _values Ordered list of values to be searched in the tree
840     * @param _params Search parameters for the current recursive step
841     * @param _resultKeys List of keys found for each requested value in the same order
842     * @param _resultValues List of node values found for each requested value in the same order
843     */
844     function _search(
845         Tree storage self,
846         uint256[] memory _values,
847         SearchParams memory _params,
848         uint256[] memory _resultKeys,
849         uint256[] memory _resultValues
850     )
851         private
852         view
853     {
854         uint256 levelKeyLessSignificantNibble = _params.level.mul(BITS_IN_NIBBLE);
855 
856         for (uint256 childNumber = 0; childNumber < CHILDREN; childNumber++) {
857             // Return if we already found enough values
858             if (_params.foundValues >= _values.length) {
859                 break;
860             }
861 
862             // Build child node key shifting the child number to the position of the less significant nibble of
863             // the keys for the level being analyzed, and adding it to the key of the parent node. For example,
864             // for a tree with height 5, if we are checking the children of the second node of the level 3, whose
865             // key is    0x0000000000000000000000000000000000000000000000000000000000001000, its children keys are:
866             // Child  0: 0x0000000000000000000000000000000000000000000000000000000000001000
867             // Child  1: 0x0000000000000000000000000000000000000000000000000000000000001100
868             // Child  2: 0x0000000000000000000000000000000000000000000000000000000000001200
869             // ...
870             // Child 15: 0x0000000000000000000000000000000000000000000000000000000000001f00
871             uint256 childNodeKey = _params.parentKey.add(childNumber << levelKeyLessSignificantNibble);
872             uint256 childNodeValue = getRecentNodeAt(self, _params.level, childNodeKey, _params.time);
873 
874             // Check how many values belong to the subtree of this node. As they are ordered, it will be a contiguous
875             // subset starting from the beginning, so we only need to know the length of that subset.
876             uint256 newVisitedTotal = _params.visitedTotal.add(childNodeValue);
877             uint256 subtreeIncludedValues = _getValuesIncludedInSubtree(_values, _params.foundValues, newVisitedTotal);
878 
879             // If there are some values included in the subtree of the child node, visit them
880             if (subtreeIncludedValues > 0) {
881                 // If the child node being analyzed is a leaf, add it to the list of results a number of times equals
882                 // to the number of values that were included in it. Otherwise, descend one level.
883                 if (_params.level == ITEMS_LEVEL) {
884                     _copyFoundNode(_params.foundValues, subtreeIncludedValues, childNodeKey, _resultKeys, childNodeValue, _resultValues);
885                 } else {
886                     SearchParams memory nextLevelParams = SearchParams(
887                         _params.time,
888                         _params.level - 1, // No need for SafeMath: we already checked above that the level being checked is greater than zero
889                         childNodeKey,
890                         _params.foundValues,
891                         _params.visitedTotal
892                     );
893                     _search(self, _values, nextLevelParams, _resultKeys, _resultValues);
894                 }
895                 // Update the number of values that were already found
896                 _params.foundValues = _params.foundValues.add(subtreeIncludedValues);
897             }
898             // Update the visited total for the next node in this level
899             _params.visitedTotal = newVisitedTotal;
900         }
901     }
902 
903     /**
904     * @dev Private function to check if a new key can be added to the tree based on the current height of the tree
905     * @param _currentHeight Current height of the tree to check if it supports adding the given key
906     * @param _newKey Key willing to be added to the tree with the given current height
907     * @return True if the current height of the tree should be increased to add the new key, false otherwise.
908     */
909     function _shouldAddLevel(uint256 _currentHeight, uint256 _newKey) private pure returns (bool) {
910         // Build a mask that will match all the possible keys for the given height. For example:
911         // Height  1: 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0 (up to 16 keys)
912         // Height  2: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 (up to 32 keys)
913         // ...
914         // Height 64: 0x0000000000000000000000000000000000000000000000000000000000000000 (up to 16^64 keys - tree max height)
915         uint256 shift = _currentHeight.mul(BITS_IN_NIBBLE);
916         uint256 mask = uint256(-1) << shift;
917 
918         // Check if the given key can be represented in the tree with the current given height using the mask.
919         return (_newKey & mask) != 0;
920     }
921 
922     /**
923     * @dev Private function to tell how many values of a list can be found in a subtree
924     * @param _values List of values being searched in ascending order
925     * @param _foundValues Number of values that were already found and should be ignore
926     * @param _subtreeTotal Total sum of the given subtree to check the numbers that are included in it
927     * @return Number of values in the list that are included in the given subtree
928     */
929     function _getValuesIncludedInSubtree(uint256[] memory _values, uint256 _foundValues, uint256 _subtreeTotal) private pure returns (uint256) {
930         // Look for all the values that can be found in the given subtree
931         uint256 i = _foundValues;
932         while (i < _values.length && _values[i] < _subtreeTotal) {
933             i++;
934         }
935         return i - _foundValues;
936     }
937 
938     /**
939     * @dev Private function to copy a node a given number of times to a results list. This function assumes the given
940     *      results list have enough size to support the requested copy.
941     * @param _from Index of the results list to start copying the given node
942     * @param _times Number of times the given node will be copied
943     * @param _key Key of the node to be copied
944     * @param _resultKeys Lists of key results to copy the given node key to
945     * @param _value Value of the node to be copied
946     * @param _resultValues Lists of value results to copy the given node value to
947     */
948     function _copyFoundNode(
949         uint256 _from,
950         uint256 _times,
951         uint256 _key,
952         uint256[] memory _resultKeys,
953         uint256 _value,
954         uint256[] memory _resultValues
955     )
956         private
957         pure
958     {
959         for (uint256 i = 0; i < _times; i++) {
960             _resultKeys[_from + i] = _key;
961             _resultValues[_from + i] = _value;
962         }
963     }
964 }
965 
966 // File: contracts/lib/PctHelpers.sol
967 
968 pragma solidity ^0.5.8;
969 
970 
971 
972 library PctHelpers {
973     using SafeMath for uint256;
974 
975     uint256 internal constant PCT_BASE = 10000; // ‱ (1 / 10,000)
976 
977     function isValid(uint16 _pct) internal pure returns (bool) {
978         return _pct <= PCT_BASE;
979     }
980 
981     function pct(uint256 self, uint16 _pct) internal pure returns (uint256) {
982         return self.mul(uint256(_pct)) / PCT_BASE;
983     }
984 
985     function pct256(uint256 self, uint256 _pct) internal pure returns (uint256) {
986         return self.mul(_pct) / PCT_BASE;
987     }
988 
989     function pctIncrease(uint256 self, uint16 _pct) internal pure returns (uint256) {
990         // No need for SafeMath: for addition note that `PCT_BASE` is lower than (2^256 - 2^16)
991         return self.mul(PCT_BASE + uint256(_pct)) / PCT_BASE;
992     }
993 }
994 
995 // File: contracts/lib/JurorsTreeSortition.sol
996 
997 pragma solidity ^0.5.8;
998 
999 
1000 
1001 
1002 /**
1003 * @title JurorsTreeSortition - Library to perform jurors sortition over a `HexSumTree`
1004 */
1005 library JurorsTreeSortition {
1006     using SafeMath for uint256;
1007     using HexSumTree for HexSumTree.Tree;
1008 
1009     string private constant ERROR_INVALID_INTERVAL_SEARCH = "TREE_INVALID_INTERVAL_SEARCH";
1010     string private constant ERROR_SORTITION_LENGTHS_MISMATCH = "TREE_SORTITION_LENGTHS_MISMATCH";
1011 
1012     /**
1013     * @dev Search random items in the tree based on certain restrictions
1014     * @param _termRandomness Randomness to compute the seed for the draft
1015     * @param _disputeId Identification number of the dispute to draft jurors for
1016     * @param _termId Current term when the draft is being computed
1017     * @param _selectedJurors Number of jurors already selected for the draft
1018     * @param _batchRequestedJurors Number of jurors to be selected in the given batch of the draft
1019     * @param _roundRequestedJurors Total number of jurors requested to be drafted
1020     * @param _sortitionIteration Number of sortitions already performed for the given draft
1021     * @return jurorsIds List of juror ids obtained based on the requested search
1022     * @return jurorsBalances List of active balances for each juror obtained based on the requested search
1023     */
1024     function batchedRandomSearch(
1025         HexSumTree.Tree storage tree,
1026         bytes32 _termRandomness,
1027         uint256 _disputeId,
1028         uint64 _termId,
1029         uint256 _selectedJurors,
1030         uint256 _batchRequestedJurors,
1031         uint256 _roundRequestedJurors,
1032         uint256 _sortitionIteration
1033     )
1034         internal
1035         view
1036         returns (uint256[] memory jurorsIds, uint256[] memory jurorsBalances)
1037     {
1038         (uint256 low, uint256 high) = getSearchBatchBounds(tree, _termId, _selectedJurors, _batchRequestedJurors, _roundRequestedJurors);
1039         uint256[] memory balances = _computeSearchRandomBalances(
1040             _termRandomness,
1041             _disputeId,
1042             _sortitionIteration,
1043             _batchRequestedJurors,
1044             low,
1045             high
1046         );
1047 
1048         (jurorsIds, jurorsBalances) = tree.search(balances, _termId);
1049 
1050         require(jurorsIds.length == jurorsBalances.length, ERROR_SORTITION_LENGTHS_MISMATCH);
1051         require(jurorsIds.length == _batchRequestedJurors, ERROR_SORTITION_LENGTHS_MISMATCH);
1052     }
1053 
1054     /**
1055     * @dev Get the bounds for a draft batch based on the active balances of the jurors
1056     * @param _termId Term ID of the active balances that will be used to compute the boundaries
1057     * @param _selectedJurors Number of jurors already selected for the draft
1058     * @param _batchRequestedJurors Number of jurors to be selected in the given batch of the draft
1059     * @param _roundRequestedJurors Total number of jurors requested to be drafted
1060     * @return low Low bound to be used for the sortition to draft the requested number of jurors for the given batch
1061     * @return high High bound to be used for the sortition to draft the requested number of jurors for the given batch
1062     */
1063     function getSearchBatchBounds(
1064         HexSumTree.Tree storage tree,
1065         uint64 _termId,
1066         uint256 _selectedJurors,
1067         uint256 _batchRequestedJurors,
1068         uint256 _roundRequestedJurors
1069     )
1070         internal
1071         view
1072         returns (uint256 low, uint256 high)
1073     {
1074         uint256 totalActiveBalance = tree.getRecentTotalAt(_termId);
1075         low = _selectedJurors.mul(totalActiveBalance).div(_roundRequestedJurors);
1076 
1077         uint256 newSelectedJurors = _selectedJurors.add(_batchRequestedJurors);
1078         high = newSelectedJurors.mul(totalActiveBalance).div(_roundRequestedJurors);
1079     }
1080 
1081     /**
1082     * @dev Get a random list of active balances to be searched in the jurors tree for a given draft batch
1083     * @param _termRandomness Randomness to compute the seed for the draft
1084     * @param _disputeId Identification number of the dispute to draft jurors for (for randomness)
1085     * @param _sortitionIteration Number of sortitions already performed for the given draft (for randomness)
1086     * @param _batchRequestedJurors Number of jurors to be selected in the given batch of the draft
1087     * @param _lowBatchBound Low bound to be used for the sortition batch to draft the requested number of jurors
1088     * @param _highBatchBound High bound to be used for the sortition batch to draft the requested number of jurors
1089     * @return Random list of active balances to be searched in the jurors tree for the given draft batch
1090     */
1091     function _computeSearchRandomBalances(
1092         bytes32 _termRandomness,
1093         uint256 _disputeId,
1094         uint256 _sortitionIteration,
1095         uint256 _batchRequestedJurors,
1096         uint256 _lowBatchBound,
1097         uint256 _highBatchBound
1098     )
1099         internal
1100         pure
1101         returns (uint256[] memory)
1102     {
1103         // Calculate the interval to be used to search the balances in the tree. Since we are using a modulo function to compute the
1104         // random balances to be searched, intervals will be closed on the left and open on the right, for example [0,10).
1105         require(_highBatchBound > _lowBatchBound, ERROR_INVALID_INTERVAL_SEARCH);
1106         uint256 interval = _highBatchBound - _lowBatchBound;
1107 
1108         // Compute an ordered list of random active balance to be searched in the jurors tree
1109         uint256[] memory balances = new uint256[](_batchRequestedJurors);
1110         for (uint256 batchJurorNumber = 0; batchJurorNumber < _batchRequestedJurors; batchJurorNumber++) {
1111             // Compute a random seed using:
1112             // - The inherent randomness associated to the term from blockhash
1113             // - The disputeId, so 2 disputes in the same term will have different outcomes
1114             // - The sortition iteration, to avoid getting stuck if resulting jurors are dismissed due to locked balance
1115             // - The juror number in this batch
1116             bytes32 seed = keccak256(abi.encodePacked(_termRandomness, _disputeId, _sortitionIteration, batchJurorNumber));
1117 
1118             // Compute a random active balance to be searched in the jurors tree using the generated seed within the
1119             // boundaries computed for the current batch.
1120             balances[batchJurorNumber] = _lowBatchBound.add(uint256(seed) % interval);
1121 
1122             // Make sure it's ordered, flip values if necessary
1123             for (uint256 i = batchJurorNumber; i > 0 && balances[i] < balances[i - 1]; i--) {
1124                 uint256 tmp = balances[i - 1];
1125                 balances[i - 1] = balances[i];
1126                 balances[i] = tmp;
1127             }
1128         }
1129         return balances;
1130     }
1131 }
1132 
1133 // File: contracts/standards/ERC900.sol
1134 
1135 pragma solidity ^0.5.8;
1136 
1137 
1138 // Interface for ERC900: https://eips.ethereum.org/EIPS/eip-900
1139 interface ERC900 {
1140     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
1141     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
1142 
1143     /**
1144     * @dev Stake a certain amount of tokens
1145     * @param _amount Amount of tokens to be staked
1146     * @param _data Optional data that can be used to add signalling information in more complex staking applications
1147     */
1148     function stake(uint256 _amount, bytes calldata _data) external;
1149 
1150     /**
1151     * @dev Stake a certain amount of tokens in favor of someone
1152     * @param _user Address to stake an amount of tokens to
1153     * @param _amount Amount of tokens to be staked
1154     * @param _data Optional data that can be used to add signalling information in more complex staking applications
1155     */
1156     function stakeFor(address _user, uint256 _amount, bytes calldata _data) external;
1157 
1158     /**
1159     * @dev Unstake a certain amount of tokens
1160     * @param _amount Amount of tokens to be unstaked
1161     * @param _data Optional data that can be used to add signalling information in more complex staking applications
1162     */
1163     function unstake(uint256 _amount, bytes calldata _data) external;
1164 
1165     /**
1166     * @dev Tell the total amount of tokens staked for an address
1167     * @param _addr Address querying the total amount of tokens staked for
1168     * @return Total amount of tokens staked for an address
1169     */
1170     function totalStakedFor(address _addr) external view returns (uint256);
1171 
1172     /**
1173     * @dev Tell the total amount of tokens staked
1174     * @return Total amount of tokens staked
1175     */
1176     function totalStaked() external view returns (uint256);
1177 
1178     /**
1179     * @dev Tell the address of the token used for staking
1180     * @return Address of the token used for staking
1181     */
1182     function token() external view returns (address);
1183 
1184     /*
1185     * @dev Tell if the current registry supports historic information or not
1186     * @return True if the optional history functions are implemented, false otherwise
1187     */
1188     function supportsHistory() external pure returns (bool);
1189 }
1190 
1191 // File: contracts/standards/ApproveAndCall.sol
1192 
1193 pragma solidity ^0.5.8;
1194 
1195 
1196 interface ApproveAndCallFallBack {
1197     /**
1198     * @dev This allows users to use their tokens to interact with contracts in one function call instead of two
1199     * @param _from Address of the account transferring the tokens
1200     * @param _amount The amount of tokens approved for in the transfer
1201     * @param _token Address of the token contract calling this function
1202     * @param _data Optional data that can be used to add signalling information in more complex staking applications
1203     */
1204     function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata _data) external;
1205 }
1206 
1207 // File: contracts/lib/os/IsContract.sol
1208 
1209 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
1210 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
1211 
1212 pragma solidity ^0.5.8;
1213 
1214 
1215 contract IsContract {
1216     /*
1217     * NOTE: this should NEVER be used for authentication
1218     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
1219     *
1220     * This is only intended to be used as a sanity check that an address is actually a contract,
1221     * RATHER THAN an address not being a contract.
1222     */
1223     function isContract(address _target) internal view returns (bool) {
1224         if (_target == address(0)) {
1225             return false;
1226         }
1227 
1228         uint256 size;
1229         assembly { size := extcodesize(_target) }
1230         return size > 0;
1231     }
1232 }
1233 
1234 // File: contracts/lib/os/SafeMath64.sol
1235 
1236 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath64.sol
1237 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
1238 
1239 pragma solidity ^0.5.8;
1240 
1241 
1242 /**
1243  * @title SafeMath64
1244  * @dev Math operations for uint64 with safety checks that revert on error
1245  */
1246 library SafeMath64 {
1247     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
1248     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
1249     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
1250     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
1251 
1252     /**
1253     * @dev Multiplies two numbers, reverts on overflow.
1254     */
1255     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
1256         uint256 c = uint256(_a) * uint256(_b);
1257         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
1258 
1259         return uint64(c);
1260     }
1261 
1262     /**
1263     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1264     */
1265     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
1266         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
1267         uint64 c = _a / _b;
1268         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1269 
1270         return c;
1271     }
1272 
1273     /**
1274     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1275     */
1276     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
1277         require(_b <= _a, ERROR_SUB_UNDERFLOW);
1278         uint64 c = _a - _b;
1279 
1280         return c;
1281     }
1282 
1283     /**
1284     * @dev Adds two numbers, reverts on overflow.
1285     */
1286     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
1287         uint64 c = _a + _b;
1288         require(c >= _a, ERROR_ADD_OVERFLOW);
1289 
1290         return c;
1291     }
1292 
1293     /**
1294     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1295     * reverts when dividing by zero.
1296     */
1297     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
1298         require(b != 0, ERROR_DIV_ZERO);
1299         return a % b;
1300     }
1301 }
1302 
1303 // File: contracts/lib/os/Uint256Helpers.sol
1304 
1305 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/Uint256Helpers.sol
1306 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
1307 
1308 pragma solidity ^0.5.8;
1309 
1310 
1311 library Uint256Helpers {
1312     uint256 private constant MAX_UINT8 = uint8(-1);
1313     uint256 private constant MAX_UINT64 = uint64(-1);
1314 
1315     string private constant ERROR_UINT8_NUMBER_TOO_BIG = "UINT8_NUMBER_TOO_BIG";
1316     string private constant ERROR_UINT64_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
1317 
1318     function toUint8(uint256 a) internal pure returns (uint8) {
1319         require(a <= MAX_UINT8, ERROR_UINT8_NUMBER_TOO_BIG);
1320         return uint8(a);
1321     }
1322 
1323     function toUint64(uint256 a) internal pure returns (uint64) {
1324         require(a <= MAX_UINT64, ERROR_UINT64_NUMBER_TOO_BIG);
1325         return uint64(a);
1326     }
1327 }
1328 
1329 // File: contracts/lib/os/TimeHelpers.sol
1330 
1331 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/TimeHelpers.sol
1332 // Adapted to use pragma ^0.5.8 and satisfy our linter rules
1333 
1334 pragma solidity ^0.5.8;
1335 
1336 
1337 
1338 contract TimeHelpers {
1339     using Uint256Helpers for uint256;
1340 
1341     /**
1342     * @dev Returns the current block number.
1343     *      Using a function rather than `block.number` allows us to easily mock the block number in
1344     *      tests.
1345     */
1346     function getBlockNumber() internal view returns (uint256) {
1347         return block.number;
1348     }
1349 
1350     /**
1351     * @dev Returns the current block number, converted to uint64.
1352     *      Using a function rather than `block.number` allows us to easily mock the block number in
1353     *      tests.
1354     */
1355     function getBlockNumber64() internal view returns (uint64) {
1356         return getBlockNumber().toUint64();
1357     }
1358 
1359     /**
1360     * @dev Returns the current timestamp.
1361     *      Using a function rather than `block.timestamp` allows us to easily mock it in
1362     *      tests.
1363     */
1364     function getTimestamp() internal view returns (uint256) {
1365         return block.timestamp; // solium-disable-line security/no-block-members
1366     }
1367 
1368     /**
1369     * @dev Returns the current timestamp, converted to uint64.
1370     *      Using a function rather than `block.timestamp` allows us to easily mock it in
1371     *      tests.
1372     */
1373     function getTimestamp64() internal view returns (uint64) {
1374         return getTimestamp().toUint64();
1375     }
1376 }
1377 
1378 // File: contracts/court/clock/IClock.sol
1379 
1380 pragma solidity ^0.5.8;
1381 
1382 
1383 interface IClock {
1384     /**
1385     * @dev Ensure that the current term of the clock is up-to-date
1386     * @return Identification number of the current term
1387     */
1388     function ensureCurrentTerm() external returns (uint64);
1389 
1390     /**
1391     * @dev Transition up to a certain number of terms to leave the clock up-to-date
1392     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
1393     * @return Identification number of the term ID after executing the heartbeat transitions
1394     */
1395     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64);
1396 
1397     /**
1398     * @dev Ensure that a certain term has its randomness set
1399     * @return Randomness of the current term
1400     */
1401     function ensureCurrentTermRandomness() external returns (bytes32);
1402 
1403     /**
1404     * @dev Tell the last ensured term identification number
1405     * @return Identification number of the last ensured term
1406     */
1407     function getLastEnsuredTermId() external view returns (uint64);
1408 
1409     /**
1410     * @dev Tell the current term identification number. Note that there may be pending term transitions.
1411     * @return Identification number of the current term
1412     */
1413     function getCurrentTermId() external view returns (uint64);
1414 
1415     /**
1416     * @dev Tell the number of terms the clock should transition to be up-to-date
1417     * @return Number of terms the clock should transition to be up-to-date
1418     */
1419     function getNeededTermTransitions() external view returns (uint64);
1420 
1421     /**
1422     * @dev Tell the information related to a term based on its ID
1423     * @param _termId ID of the term being queried
1424     * @return startTime Term start time
1425     * @return randomnessBN Block number used for randomness in the requested term
1426     * @return randomness Randomness computed for the requested term
1427     */
1428     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness);
1429 
1430     /**
1431     * @dev Tell the randomness of a term even if it wasn't computed yet
1432     * @param _termId Identification number of the term being queried
1433     * @return Randomness of the requested term
1434     */
1435     function getTermRandomness(uint64 _termId) external view returns (bytes32);
1436 }
1437 
1438 // File: contracts/court/clock/CourtClock.sol
1439 
1440 pragma solidity ^0.5.8;
1441 
1442 
1443 
1444 
1445 
1446 contract CourtClock is IClock, TimeHelpers {
1447     using SafeMath64 for uint64;
1448 
1449     string private constant ERROR_TERM_DOES_NOT_EXIST = "CLK_TERM_DOES_NOT_EXIST";
1450     string private constant ERROR_TERM_DURATION_TOO_LONG = "CLK_TERM_DURATION_TOO_LONG";
1451     string private constant ERROR_TERM_RANDOMNESS_NOT_YET = "CLK_TERM_RANDOMNESS_NOT_YET";
1452     string private constant ERROR_TERM_RANDOMNESS_UNAVAILABLE = "CLK_TERM_RANDOMNESS_UNAVAILABLE";
1453     string private constant ERROR_BAD_FIRST_TERM_START_TIME = "CLK_BAD_FIRST_TERM_START_TIME";
1454     string private constant ERROR_TOO_MANY_TRANSITIONS = "CLK_TOO_MANY_TRANSITIONS";
1455     string private constant ERROR_INVALID_TRANSITION_TERMS = "CLK_INVALID_TRANSITION_TERMS";
1456     string private constant ERROR_CANNOT_DELAY_STARTED_COURT = "CLK_CANNOT_DELAY_STARTED_COURT";
1457     string private constant ERROR_CANNOT_DELAY_PAST_START_TIME = "CLK_CANNOT_DELAY_PAST_START_TIME";
1458 
1459     // Maximum number of term transitions a callee may have to assume in order to call certain functions that require the Court being up-to-date
1460     uint64 internal constant MAX_AUTO_TERM_TRANSITIONS_ALLOWED = 1;
1461 
1462     // Max duration in seconds that a term can last
1463     uint64 internal constant MAX_TERM_DURATION = 365 days;
1464 
1465     // Max time until first term starts since contract is deployed
1466     uint64 internal constant MAX_FIRST_TERM_DELAY_PERIOD = 2 * MAX_TERM_DURATION;
1467 
1468     struct Term {
1469         uint64 startTime;              // Timestamp when the term started
1470         uint64 randomnessBN;           // Block number for entropy
1471         bytes32 randomness;            // Entropy from randomnessBN block hash
1472     }
1473 
1474     // Duration in seconds for each term of the Court
1475     uint64 private termDuration;
1476 
1477     // Last ensured term id
1478     uint64 private termId;
1479 
1480     // List of Court terms indexed by id
1481     mapping (uint64 => Term) private terms;
1482 
1483     event Heartbeat(uint64 previousTermId, uint64 currentTermId);
1484     event StartTimeDelayed(uint64 previousStartTime, uint64 currentStartTime);
1485 
1486     /**
1487     * @dev Ensure a certain term has already been processed
1488     * @param _termId Identification number of the term to be checked
1489     */
1490     modifier termExists(uint64 _termId) {
1491         require(_termId <= termId, ERROR_TERM_DOES_NOT_EXIST);
1492         _;
1493     }
1494 
1495     /**
1496     * @dev Constructor function
1497     * @param _termParams Array containing:
1498     *        0. _termDuration Duration in seconds per term
1499     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
1500     */
1501     constructor(uint64[2] memory _termParams) public {
1502         uint64 _termDuration = _termParams[0];
1503         uint64 _firstTermStartTime = _termParams[1];
1504 
1505         require(_termDuration < MAX_TERM_DURATION, ERROR_TERM_DURATION_TOO_LONG);
1506         require(_firstTermStartTime >= getTimestamp64() + _termDuration, ERROR_BAD_FIRST_TERM_START_TIME);
1507         require(_firstTermStartTime <= getTimestamp64() + MAX_FIRST_TERM_DELAY_PERIOD, ERROR_BAD_FIRST_TERM_START_TIME);
1508 
1509         termDuration = _termDuration;
1510 
1511         // No need for SafeMath: we already checked values above
1512         terms[0].startTime = _firstTermStartTime - _termDuration;
1513     }
1514 
1515     /**
1516     * @notice Ensure that the current term of the Court is up-to-date. If the Court is outdated by more than `MAX_AUTO_TERM_TRANSITIONS_ALLOWED`
1517     *         terms, the heartbeat function must be called manually instead.
1518     * @return Identification number of the current term
1519     */
1520     function ensureCurrentTerm() external returns (uint64) {
1521         return _ensureCurrentTerm();
1522     }
1523 
1524     /**
1525     * @notice Transition up to `_maxRequestedTransitions` terms
1526     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
1527     * @return Identification number of the term ID after executing the heartbeat transitions
1528     */
1529     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64) {
1530         return _heartbeat(_maxRequestedTransitions);
1531     }
1532 
1533     /**
1534     * @notice Ensure that a certain term has its randomness set. As we allow to draft disputes requested for previous terms, if there
1535     *      were mined more than 256 blocks for the current term, the blockhash of its randomness BN is no longer available, given
1536     *      round will be able to be drafted in the following term.
1537     * @return Randomness of the current term
1538     */
1539     function ensureCurrentTermRandomness() external returns (bytes32) {
1540         // If the randomness for the given term was already computed, return
1541         uint64 currentTermId = termId;
1542         Term storage term = terms[currentTermId];
1543         bytes32 termRandomness = term.randomness;
1544         if (termRandomness != bytes32(0)) {
1545             return termRandomness;
1546         }
1547 
1548         // Compute term randomness
1549         bytes32 newRandomness = _computeTermRandomness(currentTermId);
1550         require(newRandomness != bytes32(0), ERROR_TERM_RANDOMNESS_UNAVAILABLE);
1551         term.randomness = newRandomness;
1552         return newRandomness;
1553     }
1554 
1555     /**
1556     * @dev Tell the term duration of the Court
1557     * @return Duration in seconds of the Court term
1558     */
1559     function getTermDuration() external view returns (uint64) {
1560         return termDuration;
1561     }
1562 
1563     /**
1564     * @dev Tell the last ensured term identification number
1565     * @return Identification number of the last ensured term
1566     */
1567     function getLastEnsuredTermId() external view returns (uint64) {
1568         return _lastEnsuredTermId();
1569     }
1570 
1571     /**
1572     * @dev Tell the current term identification number. Note that there may be pending term transitions.
1573     * @return Identification number of the current term
1574     */
1575     function getCurrentTermId() external view returns (uint64) {
1576         return _currentTermId();
1577     }
1578 
1579     /**
1580     * @dev Tell the number of terms the Court should transition to be up-to-date
1581     * @return Number of terms the Court should transition to be up-to-date
1582     */
1583     function getNeededTermTransitions() external view returns (uint64) {
1584         return _neededTermTransitions();
1585     }
1586 
1587     /**
1588     * @dev Tell the information related to a term based on its ID. Note that if the term has not been reached, the
1589     *      information returned won't be computed yet. This function allows querying future terms that were not computed yet.
1590     * @param _termId ID of the term being queried
1591     * @return startTime Term start time
1592     * @return randomnessBN Block number used for randomness in the requested term
1593     * @return randomness Randomness computed for the requested term
1594     */
1595     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness) {
1596         Term storage term = terms[_termId];
1597         return (term.startTime, term.randomnessBN, term.randomness);
1598     }
1599 
1600     /**
1601     * @dev Tell the randomness of a term even if it wasn't computed yet
1602     * @param _termId Identification number of the term being queried
1603     * @return Randomness of the requested term
1604     */
1605     function getTermRandomness(uint64 _termId) external view termExists(_termId) returns (bytes32) {
1606         return _computeTermRandomness(_termId);
1607     }
1608 
1609     /**
1610     * @dev Internal function to ensure that the current term of the Court is up-to-date. If the Court is outdated by more than
1611     *      `MAX_AUTO_TERM_TRANSITIONS_ALLOWED` terms, the heartbeat function must be called manually.
1612     * @return Identification number of the resultant term ID after executing the corresponding transitions
1613     */
1614     function _ensureCurrentTerm() internal returns (uint64) {
1615         // Check the required number of transitions does not exceeds the max allowed number to be processed automatically
1616         uint64 requiredTransitions = _neededTermTransitions();
1617         require(requiredTransitions <= MAX_AUTO_TERM_TRANSITIONS_ALLOWED, ERROR_TOO_MANY_TRANSITIONS);
1618 
1619         // If there are no transitions pending, return the last ensured term id
1620         if (uint256(requiredTransitions) == 0) {
1621             return termId;
1622         }
1623 
1624         // Process transition if there is at least one pending
1625         return _heartbeat(requiredTransitions);
1626     }
1627 
1628     /**
1629     * @dev Internal function to transition the Court terms up to a requested number of terms
1630     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
1631     * @return Identification number of the resultant term ID after executing the requested transitions
1632     */
1633     function _heartbeat(uint64 _maxRequestedTransitions) internal returns (uint64) {
1634         // Transition the minimum number of terms between the amount requested and the amount actually needed
1635         uint64 neededTransitions = _neededTermTransitions();
1636         uint256 transitions = uint256(_maxRequestedTransitions < neededTransitions ? _maxRequestedTransitions : neededTransitions);
1637         require(transitions > 0, ERROR_INVALID_TRANSITION_TERMS);
1638 
1639         uint64 blockNumber = getBlockNumber64();
1640         uint64 previousTermId = termId;
1641         uint64 currentTermId = previousTermId;
1642         for (uint256 transition = 1; transition <= transitions; transition++) {
1643             // Term IDs are incremented by one based on the number of time periods since the Court started. Since time is represented in uint64,
1644             // even if we chose the minimum duration possible for a term (1 second), we can ensure terms will never reach 2^64 since time is
1645             // already assumed to fit in uint64.
1646             Term storage previousTerm = terms[currentTermId++];
1647             Term storage currentTerm = terms[currentTermId];
1648             _onTermTransitioned(currentTermId);
1649 
1650             // Set the start time of the new term. Note that we are using a constant term duration value to guarantee
1651             // equally long terms, regardless of heartbeats.
1652             currentTerm.startTime = previousTerm.startTime.add(termDuration);
1653 
1654             // In order to draft a random number of jurors in a term, we use a randomness factor for each term based on a
1655             // block number that is set once the term has started. Note that this information could not be known beforehand.
1656             currentTerm.randomnessBN = blockNumber + 1;
1657         }
1658 
1659         termId = currentTermId;
1660         emit Heartbeat(previousTermId, currentTermId);
1661         return currentTermId;
1662     }
1663 
1664     /**
1665     * @dev Internal function to delay the first term start time only if it wasn't reached yet
1666     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
1667     */
1668     function _delayStartTime(uint64 _newFirstTermStartTime) internal {
1669         require(_currentTermId() == 0, ERROR_CANNOT_DELAY_STARTED_COURT);
1670 
1671         Term storage term = terms[0];
1672         uint64 currentFirstTermStartTime = term.startTime.add(termDuration);
1673         require(_newFirstTermStartTime > currentFirstTermStartTime, ERROR_CANNOT_DELAY_PAST_START_TIME);
1674 
1675         // No need for SafeMath: we already checked above that `_newFirstTermStartTime` > `currentFirstTermStartTime` >= `termDuration`
1676         term.startTime = _newFirstTermStartTime - termDuration;
1677         emit StartTimeDelayed(currentFirstTermStartTime, _newFirstTermStartTime);
1678     }
1679 
1680     /**
1681     * @dev Internal function to notify when a term has been transitioned. This function must be overridden to provide custom behavior.
1682     * @param _termId Identification number of the new current term that has been transitioned
1683     */
1684     function _onTermTransitioned(uint64 _termId) internal;
1685 
1686     /**
1687     * @dev Internal function to tell the last ensured term identification number
1688     * @return Identification number of the last ensured term
1689     */
1690     function _lastEnsuredTermId() internal view returns (uint64) {
1691         return termId;
1692     }
1693 
1694     /**
1695     * @dev Internal function to tell the current term identification number. Note that there may be pending term transitions.
1696     * @return Identification number of the current term
1697     */
1698     function _currentTermId() internal view returns (uint64) {
1699         return termId.add(_neededTermTransitions());
1700     }
1701 
1702     /**
1703     * @dev Internal function to tell the number of terms the Court should transition to be up-to-date
1704     * @return Number of terms the Court should transition to be up-to-date
1705     */
1706     function _neededTermTransitions() internal view returns (uint64) {
1707         // Note that the Court is always initialized providing a start time for the first-term in the future. If that's the case,
1708         // no term transitions are required.
1709         uint64 currentTermStartTime = terms[termId].startTime;
1710         if (getTimestamp64() < currentTermStartTime) {
1711             return uint64(0);
1712         }
1713 
1714         // No need for SafeMath: we already know that the start time of the current term is in the past
1715         return (getTimestamp64() - currentTermStartTime) / termDuration;
1716     }
1717 
1718     /**
1719     * @dev Internal function to compute the randomness that will be used to draft jurors for the given term. This
1720     *      function assumes the given term exists. To determine the randomness factor for a term we use the hash of a
1721     *      block number that is set once the term has started to ensure it cannot be known beforehand. Note that the
1722     *      hash function being used only works for the 256 most recent block numbers.
1723     * @param _termId Identification number of the term being queried
1724     * @return Randomness computed for the given term
1725     */
1726     function _computeTermRandomness(uint64 _termId) internal view returns (bytes32) {
1727         Term storage term = terms[_termId];
1728         require(getBlockNumber64() > term.randomnessBN, ERROR_TERM_RANDOMNESS_NOT_YET);
1729         return blockhash(term.randomnessBN);
1730     }
1731 }
1732 
1733 // File: contracts/court/config/IConfig.sol
1734 
1735 pragma solidity ^0.5.8;
1736 
1737 
1738 
1739 interface IConfig {
1740 
1741     /**
1742     * @dev Tell the full Court configuration parameters at a certain term
1743     * @param _termId Identification number of the term querying the Court config of
1744     * @return token Address of the token used to pay for fees
1745     * @return fees Array containing:
1746     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1747     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1748     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1749     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1750     *         0. evidenceTerms Max submitting evidence period duration in terms
1751     *         1. commitTerms Commit period duration in terms
1752     *         2. revealTerms Reveal period duration in terms
1753     *         3. appealTerms Appeal period duration in terms
1754     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1755     * @return pcts Array containing:
1756     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1757     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1758     * @return roundParams Array containing params for rounds:
1759     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1760     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1761     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1762     * @return appealCollateralParams Array containing params for appeal collateral:
1763     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1764     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1765     * @return minActiveBalance Minimum amount of tokens jurors have to activate to participate in the Court
1766     */
1767     function getConfig(uint64 _termId) external view
1768         returns (
1769             ERC20 feeToken,
1770             uint256[3] memory fees,
1771             uint64[5] memory roundStateDurations,
1772             uint16[2] memory pcts,
1773             uint64[4] memory roundParams,
1774             uint256[2] memory appealCollateralParams,
1775             uint256 minActiveBalance
1776         );
1777 
1778     /**
1779     * @dev Tell the draft config at a certain term
1780     * @param _termId Identification number of the term querying the draft config of
1781     * @return feeToken Address of the token used to pay for fees
1782     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1783     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1784     */
1785     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
1786 
1787     /**
1788     * @dev Tell the min active balance config at a certain term
1789     * @param _termId Term querying the min active balance config of
1790     * @return Minimum amount of tokens jurors have to activate to participate in the Court
1791     */
1792     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
1793 
1794     /**
1795     * @dev Tell whether a certain holder accepts automatic withdrawals of tokens or not
1796     * @return True if the given holder accepts automatic withdrawals of their tokens, false otherwise
1797     */
1798     function areWithdrawalsAllowedFor(address _holder) external view returns (bool);
1799 }
1800 
1801 // File: contracts/court/config/CourtConfigData.sol
1802 
1803 pragma solidity ^0.5.8;
1804 
1805 
1806 
1807 contract CourtConfigData {
1808     struct Config {
1809         FeesConfig fees;                        // Full fees-related config
1810         DisputesConfig disputes;                // Full disputes-related config
1811         uint256 minActiveBalance;               // Minimum amount of tokens jurors have to activate to participate in the Court
1812     }
1813 
1814     struct FeesConfig {
1815         ERC20 token;                            // ERC20 token to be used for the fees of the Court
1816         uint16 finalRoundReduction;             // Permyriad of fees reduction applied for final appeal round (‱ - 1/10,000)
1817         uint256 jurorFee;                       // Amount of tokens paid to draft a juror to adjudicate a dispute
1818         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting jurors
1819         uint256 settleFee;                      // Amount of tokens paid per round to cover the costs of slashing jurors
1820     }
1821 
1822     struct DisputesConfig {
1823         uint64 evidenceTerms;                   // Max submitting evidence period duration in terms
1824         uint64 commitTerms;                     // Committing period duration in terms
1825         uint64 revealTerms;                     // Revealing period duration in terms
1826         uint64 appealTerms;                     // Appealing period duration in terms
1827         uint64 appealConfirmTerms;              // Confirmation appeal period duration in terms
1828         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1829         uint64 firstRoundJurorsNumber;          // Number of jurors drafted on first round
1830         uint64 appealStepFactor;                // Factor in which the jurors number is increased on each appeal
1831         uint64 finalRoundLockTerms;             // Period a coherent juror in the final round will remain locked
1832         uint256 maxRegularAppealRounds;         // Before the final appeal
1833         uint256 appealCollateralFactor;         // Permyriad multiple of dispute fees required to appeal a preliminary ruling (‱ - 1/10,000)
1834         uint256 appealConfirmCollateralFactor;  // Permyriad multiple of dispute fees required to confirm appeal (‱ - 1/10,000)
1835     }
1836 
1837     struct DraftConfig {
1838         ERC20 feeToken;                         // ERC20 token to be used for the fees of the Court
1839         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1840         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting jurors
1841     }
1842 }
1843 
1844 // File: contracts/court/config/CourtConfig.sol
1845 
1846 pragma solidity ^0.5.8;
1847 
1848 
1849 
1850 
1851 
1852 
1853 
1854 contract CourtConfig is IConfig, CourtConfigData {
1855     using SafeMath64 for uint64;
1856     using PctHelpers for uint256;
1857 
1858     string private constant ERROR_TOO_OLD_TERM = "CONF_TOO_OLD_TERM";
1859     string private constant ERROR_INVALID_PENALTY_PCT = "CONF_INVALID_PENALTY_PCT";
1860     string private constant ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT = "CONF_INVALID_FINAL_ROUND_RED_PCT";
1861     string private constant ERROR_INVALID_MAX_APPEAL_ROUNDS = "CONF_INVALID_MAX_APPEAL_ROUNDS";
1862     string private constant ERROR_LARGE_ROUND_PHASE_DURATION = "CONF_LARGE_ROUND_PHASE_DURATION";
1863     string private constant ERROR_BAD_INITIAL_JURORS_NUMBER = "CONF_BAD_INITIAL_JURORS_NUMBER";
1864     string private constant ERROR_BAD_APPEAL_STEP_FACTOR = "CONF_BAD_APPEAL_STEP_FACTOR";
1865     string private constant ERROR_ZERO_COLLATERAL_FACTOR = "CONF_ZERO_COLLATERAL_FACTOR";
1866     string private constant ERROR_ZERO_MIN_ACTIVE_BALANCE = "CONF_ZERO_MIN_ACTIVE_BALANCE";
1867 
1868     // Max number of terms that each of the different adjudication states can last (if lasted 1h, this would be a year)
1869     uint64 internal constant MAX_ADJ_STATE_DURATION = 8670;
1870 
1871     // Cap the max number of regular appeal rounds
1872     uint256 internal constant MAX_REGULAR_APPEAL_ROUNDS_LIMIT = 10;
1873 
1874     // Future term ID in which a config change has been scheduled
1875     uint64 private configChangeTermId;
1876 
1877     // List of all the configs used in the Court
1878     Config[] private configs;
1879 
1880     // List of configs indexed by id
1881     mapping (uint64 => uint256) private configIdByTerm;
1882 
1883     // Holders opt-in config for automatic withdrawals
1884     mapping (address => bool) private withdrawalsAllowed;
1885 
1886     event NewConfig(uint64 fromTermId, uint64 courtConfigId);
1887     event AutomaticWithdrawalsAllowedChanged(address indexed holder, bool allowed);
1888 
1889     /**
1890     * @dev Constructor function
1891     * @param _feeToken Address of the token contract that is used to pay for fees
1892     * @param _fees Array containing:
1893     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
1894     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
1895     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
1896     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1897     *        0. evidenceTerms Max submitting evidence period duration in terms
1898     *        1. commitTerms Commit period duration in terms
1899     *        2. revealTerms Reveal period duration in terms
1900     *        3. appealTerms Appeal period duration in terms
1901     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1902     * @param _pcts Array containing:
1903     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1904     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1905     * @param _roundParams Array containing params for rounds:
1906     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1907     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1908     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1909     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
1910     * @param _appealCollateralParams Array containing params for appeal collateral:
1911     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1912     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1913     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
1914     */
1915     constructor(
1916         ERC20 _feeToken,
1917         uint256[3] memory _fees,
1918         uint64[5] memory _roundStateDurations,
1919         uint16[2] memory _pcts,
1920         uint64[4] memory _roundParams,
1921         uint256[2] memory _appealCollateralParams,
1922         uint256 _minActiveBalance
1923     )
1924         public
1925     {
1926         // Leave config at index 0 empty for non-scheduled config changes
1927         configs.length = 1;
1928         _setConfig(
1929             0,
1930             0,
1931             _feeToken,
1932             _fees,
1933             _roundStateDurations,
1934             _pcts,
1935             _roundParams,
1936             _appealCollateralParams,
1937             _minActiveBalance
1938         );
1939     }
1940 
1941     /**
1942     * @notice Set the automatic withdrawals config for the sender to `_allowed`
1943     * @param _allowed Whether or not the automatic withdrawals are allowed by the sender
1944     */
1945     function setAutomaticWithdrawals(bool _allowed) external {
1946         withdrawalsAllowed[msg.sender] = _allowed;
1947         emit AutomaticWithdrawalsAllowedChanged(msg.sender, _allowed);
1948     }
1949 
1950     /**
1951     * @dev Tell the full Court configuration parameters at a certain term
1952     * @param _termId Identification number of the term querying the Court config of
1953     * @return token Address of the token used to pay for fees
1954     * @return fees Array containing:
1955     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
1956     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
1957     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
1958     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1959     *         0. evidenceTerms Max submitting evidence period duration in terms
1960     *         1. commitTerms Commit period duration in terms
1961     *         2. revealTerms Reveal period duration in terms
1962     *         3. appealTerms Appeal period duration in terms
1963     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1964     * @return pcts Array containing:
1965     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1966     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1967     * @return roundParams Array containing params for rounds:
1968     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
1969     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
1970     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1971     * @return appealCollateralParams Array containing params for appeal collateral:
1972     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1973     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1974     * @return minActiveBalance Minimum amount of tokens jurors have to activate to participate in the Court
1975     */
1976     function getConfig(uint64 _termId) external view
1977         returns (
1978             ERC20 feeToken,
1979             uint256[3] memory fees,
1980             uint64[5] memory roundStateDurations,
1981             uint16[2] memory pcts,
1982             uint64[4] memory roundParams,
1983             uint256[2] memory appealCollateralParams,
1984             uint256 minActiveBalance
1985         );
1986 
1987     /**
1988     * @dev Tell the draft config at a certain term
1989     * @param _termId Identification number of the term querying the draft config of
1990     * @return feeToken Address of the token used to pay for fees
1991     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
1992     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
1993     */
1994     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
1995 
1996     /**
1997     * @dev Tell the min active balance config at a certain term
1998     * @param _termId Term querying the min active balance config of
1999     * @return Minimum amount of tokens jurors have to activate to participate in the Court
2000     */
2001     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
2002 
2003     /**
2004     * @dev Tell whether a certain holder accepts automatic withdrawals of tokens or not
2005     * @param _holder Address of the token holder querying if withdrawals are allowed for
2006     * @return True if the given holder accepts automatic withdrawals of their tokens, false otherwise
2007     */
2008     function areWithdrawalsAllowedFor(address _holder) external view returns (bool) {
2009         return withdrawalsAllowed[_holder];
2010     }
2011 
2012     /**
2013     * @dev Tell the term identification number of the next scheduled config change
2014     * @return Term identification number of the next scheduled config change
2015     */
2016     function getConfigChangeTermId() external view returns (uint64) {
2017         return configChangeTermId;
2018     }
2019 
2020     /**
2021     * @dev Internal to make sure to set a config for the new term, it will copy the previous term config if none
2022     * @param _termId Identification number of the new current term that has been transitioned
2023     */
2024     function _ensureTermConfig(uint64 _termId) internal {
2025         // If the term being transitioned had no config change scheduled, keep the previous one
2026         uint256 currentConfigId = configIdByTerm[_termId];
2027         if (currentConfigId == 0) {
2028             uint256 previousConfigId = configIdByTerm[_termId.sub(1)];
2029             configIdByTerm[_termId] = previousConfigId;
2030         }
2031     }
2032 
2033     /**
2034     * @dev Assumes that sender it's allowed (either it's from governor or it's on init)
2035     * @param _termId Identification number of the current Court term
2036     * @param _fromTermId Identification number of the term in which the config will be effective at
2037     * @param _feeToken Address of the token contract that is used to pay for fees.
2038     * @param _fees Array containing:
2039     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
2040     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
2041     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
2042     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2043     *        0. evidenceTerms Max submitting evidence period duration in terms
2044     *        1. commitTerms Commit period duration in terms
2045     *        2. revealTerms Reveal period duration in terms
2046     *        3. appealTerms Appeal period duration in terms
2047     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2048     * @param _pcts Array containing:
2049     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
2050     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2051     * @param _roundParams Array containing params for rounds:
2052     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
2053     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
2054     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2055     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
2056     * @param _appealCollateralParams Array containing params for appeal collateral:
2057     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
2058     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
2059     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
2060     */
2061     function _setConfig(
2062         uint64 _termId,
2063         uint64 _fromTermId,
2064         ERC20 _feeToken,
2065         uint256[3] memory _fees,
2066         uint64[5] memory _roundStateDurations,
2067         uint16[2] memory _pcts,
2068         uint64[4] memory _roundParams,
2069         uint256[2] memory _appealCollateralParams,
2070         uint256 _minActiveBalance
2071     )
2072         internal
2073     {
2074         // If the current term is not zero, changes must be scheduled at least after the current period.
2075         // No need to ensure delays for on-going disputes since these already use their creation term for that.
2076         require(_termId == 0 || _fromTermId > _termId, ERROR_TOO_OLD_TERM);
2077 
2078         // Make sure appeal collateral factors are greater than zero
2079         require(_appealCollateralParams[0] > 0 && _appealCollateralParams[1] > 0, ERROR_ZERO_COLLATERAL_FACTOR);
2080 
2081         // Make sure the given penalty and final round reduction pcts are not greater than 100%
2082         require(PctHelpers.isValid(_pcts[0]), ERROR_INVALID_PENALTY_PCT);
2083         require(PctHelpers.isValid(_pcts[1]), ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT);
2084 
2085         // Disputes must request at least one juror to be drafted initially
2086         require(_roundParams[0] > 0, ERROR_BAD_INITIAL_JURORS_NUMBER);
2087 
2088         // Prevent that further rounds have zero jurors
2089         require(_roundParams[1] > 0, ERROR_BAD_APPEAL_STEP_FACTOR);
2090 
2091         // Make sure the max number of appeals allowed does not reach the limit
2092         uint256 _maxRegularAppealRounds = _roundParams[2];
2093         bool isMaxAppealRoundsValid = _maxRegularAppealRounds > 0 && _maxRegularAppealRounds <= MAX_REGULAR_APPEAL_ROUNDS_LIMIT;
2094         require(isMaxAppealRoundsValid, ERROR_INVALID_MAX_APPEAL_ROUNDS);
2095 
2096         // Make sure each adjudication round phase duration is valid
2097         for (uint i = 0; i < _roundStateDurations.length; i++) {
2098             require(_roundStateDurations[i] > 0 && _roundStateDurations[i] < MAX_ADJ_STATE_DURATION, ERROR_LARGE_ROUND_PHASE_DURATION);
2099         }
2100 
2101         // Make sure min active balance is not zero
2102         require(_minActiveBalance > 0, ERROR_ZERO_MIN_ACTIVE_BALANCE);
2103 
2104         // If there was a config change already scheduled, reset it (in that case we will overwrite last array item).
2105         // Otherwise, schedule a new config.
2106         if (configChangeTermId > _termId) {
2107             configIdByTerm[configChangeTermId] = 0;
2108         } else {
2109             configs.length++;
2110         }
2111 
2112         uint64 courtConfigId = uint64(configs.length - 1);
2113         Config storage config = configs[courtConfigId];
2114 
2115         config.fees = FeesConfig({
2116             token: _feeToken,
2117             jurorFee: _fees[0],
2118             draftFee: _fees[1],
2119             settleFee: _fees[2],
2120             finalRoundReduction: _pcts[1]
2121         });
2122 
2123         config.disputes = DisputesConfig({
2124             evidenceTerms: _roundStateDurations[0],
2125             commitTerms: _roundStateDurations[1],
2126             revealTerms: _roundStateDurations[2],
2127             appealTerms: _roundStateDurations[3],
2128             appealConfirmTerms: _roundStateDurations[4],
2129             penaltyPct: _pcts[0],
2130             firstRoundJurorsNumber: _roundParams[0],
2131             appealStepFactor: _roundParams[1],
2132             maxRegularAppealRounds: _maxRegularAppealRounds,
2133             finalRoundLockTerms: _roundParams[3],
2134             appealCollateralFactor: _appealCollateralParams[0],
2135             appealConfirmCollateralFactor: _appealCollateralParams[1]
2136         });
2137 
2138         config.minActiveBalance = _minActiveBalance;
2139 
2140         configIdByTerm[_fromTermId] = courtConfigId;
2141         configChangeTermId = _fromTermId;
2142 
2143         emit NewConfig(_fromTermId, courtConfigId);
2144     }
2145 
2146     /**
2147     * @dev Internal function to get the Court config for a given term
2148     * @param _termId Identification number of the term querying the Court config of
2149     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2150     * @return token Address of the token used to pay for fees
2151     * @return fees Array containing:
2152     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
2153     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
2154     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
2155     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2156     *         0. evidenceTerms Max submitting evidence period duration in terms
2157     *         1. commitTerms Commit period duration in terms
2158     *         2. revealTerms Reveal period duration in terms
2159     *         3. appealTerms Appeal period duration in terms
2160     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
2161     * @return pcts Array containing:
2162     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
2163     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2164     * @return roundParams Array containing params for rounds:
2165     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
2166     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
2167     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2168     *         3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
2169     * @return appealCollateralParams Array containing params for appeal collateral:
2170     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
2171     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
2172     * @return minActiveBalance Minimum amount of juror tokens that can be activated
2173     */
2174     function _getConfigAt(uint64 _termId, uint64 _lastEnsuredTermId) internal view
2175         returns (
2176             ERC20 feeToken,
2177             uint256[3] memory fees,
2178             uint64[5] memory roundStateDurations,
2179             uint16[2] memory pcts,
2180             uint64[4] memory roundParams,
2181             uint256[2] memory appealCollateralParams,
2182             uint256 minActiveBalance
2183         )
2184     {
2185         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
2186 
2187         FeesConfig storage feesConfig = config.fees;
2188         feeToken = feesConfig.token;
2189         fees = [feesConfig.jurorFee, feesConfig.draftFee, feesConfig.settleFee];
2190 
2191         DisputesConfig storage disputesConfig = config.disputes;
2192         roundStateDurations = [
2193             disputesConfig.evidenceTerms,
2194             disputesConfig.commitTerms,
2195             disputesConfig.revealTerms,
2196             disputesConfig.appealTerms,
2197             disputesConfig.appealConfirmTerms
2198         ];
2199         pcts = [disputesConfig.penaltyPct, feesConfig.finalRoundReduction];
2200         roundParams = [
2201             disputesConfig.firstRoundJurorsNumber,
2202             disputesConfig.appealStepFactor,
2203             uint64(disputesConfig.maxRegularAppealRounds),
2204             disputesConfig.finalRoundLockTerms
2205         ];
2206         appealCollateralParams = [disputesConfig.appealCollateralFactor, disputesConfig.appealConfirmCollateralFactor];
2207 
2208         minActiveBalance = config.minActiveBalance;
2209     }
2210 
2211     /**
2212     * @dev Tell the draft config at a certain term
2213     * @param _termId Identification number of the term querying the draft config of
2214     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2215     * @return feeToken Address of the token used to pay for fees
2216     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
2217     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
2218     */
2219     function _getDraftConfig(uint64 _termId,  uint64 _lastEnsuredTermId) internal view
2220         returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct)
2221     {
2222         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
2223         return (config.fees.token, config.fees.draftFee, config.disputes.penaltyPct);
2224     }
2225 
2226     /**
2227     * @dev Internal function to get the min active balance config for a given term
2228     * @param _termId Identification number of the term querying the min active balance config of
2229     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2230     * @return Minimum amount of juror tokens that can be activated at the given term
2231     */
2232     function _getMinActiveBalance(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
2233         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
2234         return config.minActiveBalance;
2235     }
2236 
2237     /**
2238     * @dev Internal function to get the Court config for a given term
2239     * @param _termId Identification number of the term querying the min active balance config of
2240     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2241     * @return Court config for the given term
2242     */
2243     function _getConfigFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (Config storage) {
2244         uint256 id = _getConfigIdFor(_termId, _lastEnsuredTermId);
2245         return configs[id];
2246     }
2247 
2248     /**
2249     * @dev Internal function to get the Court config ID for a given term
2250     * @param _termId Identification number of the term querying the Court config of
2251     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2252     * @return Identification number of the config for the given terms
2253     */
2254     function _getConfigIdFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
2255         // If the given term is lower or equal to the last ensured Court term, it is safe to use a past Court config
2256         if (_termId <= _lastEnsuredTermId) {
2257             return configIdByTerm[_termId];
2258         }
2259 
2260         // If the given term is in the future but there is a config change scheduled before it, use the incoming config
2261         uint64 scheduledChangeTermId = configChangeTermId;
2262         if (scheduledChangeTermId <= _termId) {
2263             return configIdByTerm[scheduledChangeTermId];
2264         }
2265 
2266         // If no changes are scheduled, use the Court config of the last ensured term
2267         return configIdByTerm[_lastEnsuredTermId];
2268     }
2269 }
2270 
2271 // File: contracts/court/controller/Controller.sol
2272 
2273 pragma solidity ^0.5.8;
2274 
2275 
2276 
2277 
2278 
2279 contract Controller is IsContract, CourtClock, CourtConfig {
2280     string private constant ERROR_SENDER_NOT_GOVERNOR = "CTR_SENDER_NOT_GOVERNOR";
2281     string private constant ERROR_INVALID_GOVERNOR_ADDRESS = "CTR_INVALID_GOVERNOR_ADDRESS";
2282     string private constant ERROR_IMPLEMENTATION_NOT_CONTRACT = "CTR_IMPLEMENTATION_NOT_CONTRACT";
2283     string private constant ERROR_INVALID_IMPLS_INPUT_LENGTH = "CTR_INVALID_IMPLS_INPUT_LENGTH";
2284 
2285     address private constant ZERO_ADDRESS = address(0);
2286 
2287     // DisputeManager module ID - keccak256(abi.encodePacked("DISPUTE_MANAGER"))
2288     bytes32 internal constant DISPUTE_MANAGER = 0x14a6c70f0f6d449c014c7bbc9e68e31e79e8474fb03b7194df83109a2d888ae6;
2289 
2290     // Treasury module ID - keccak256(abi.encodePacked("TREASURY"))
2291     bytes32 internal constant TREASURY = 0x06aa03964db1f7257357ef09714a5f0ca3633723df419e97015e0c7a3e83edb7;
2292 
2293     // Voting module ID - keccak256(abi.encodePacked("VOTING"))
2294     bytes32 internal constant VOTING = 0x7cbb12e82a6d63ff16fe43977f43e3e2b247ecd4e62c0e340da8800a48c67346;
2295 
2296     // JurorsRegistry module ID - keccak256(abi.encodePacked("JURORS_REGISTRY"))
2297     bytes32 internal constant JURORS_REGISTRY = 0x3b21d36b36308c830e6c4053fb40a3b6d79dde78947fbf6b0accd30720ab5370;
2298 
2299     // Subscriptions module ID - keccak256(abi.encodePacked("SUBSCRIPTIONS"))
2300     bytes32 internal constant SUBSCRIPTIONS = 0x2bfa3327fe52344390da94c32a346eeb1b65a8b583e4335a419b9471e88c1365;
2301 
2302     /**
2303     * @dev Governor of the whole system. Set of three addresses to recover funds, change configuration settings and setup modules
2304     */
2305     struct Governor {
2306         address funds;      // This address can be unset at any time. It is allowed to recover funds from the ControlledRecoverable modules
2307         address config;     // This address is meant not to be unset. It is allowed to change the different configurations of the whole system
2308         address modules;    // This address can be unset at any time. It is allowed to plug/unplug modules from the system
2309     }
2310 
2311     // Governor addresses of the system
2312     Governor private governor;
2313 
2314     // List of modules registered for the system indexed by ID
2315     mapping (bytes32 => address) internal modules;
2316 
2317     event ModuleSet(bytes32 id, address addr);
2318     event FundsGovernorChanged(address previousGovernor, address currentGovernor);
2319     event ConfigGovernorChanged(address previousGovernor, address currentGovernor);
2320     event ModulesGovernorChanged(address previousGovernor, address currentGovernor);
2321 
2322     /**
2323     * @dev Ensure the msg.sender is the funds governor
2324     */
2325     modifier onlyFundsGovernor {
2326         require(msg.sender == governor.funds, ERROR_SENDER_NOT_GOVERNOR);
2327         _;
2328     }
2329 
2330     /**
2331     * @dev Ensure the msg.sender is the modules governor
2332     */
2333     modifier onlyConfigGovernor {
2334         require(msg.sender == governor.config, ERROR_SENDER_NOT_GOVERNOR);
2335         _;
2336     }
2337 
2338     /**
2339     * @dev Ensure the msg.sender is the modules governor
2340     */
2341     modifier onlyModulesGovernor {
2342         require(msg.sender == governor.modules, ERROR_SENDER_NOT_GOVERNOR);
2343         _;
2344     }
2345 
2346     /**
2347     * @dev Constructor function
2348     * @param _termParams Array containing:
2349     *        0. _termDuration Duration in seconds per term
2350     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for juror on-boarding)
2351     * @param _governors Array containing:
2352     *        0. _fundsGovernor Address of the funds governor
2353     *        1. _configGovernor Address of the config governor
2354     *        2. _modulesGovernor Address of the modules governor
2355     * @param _feeToken Address of the token contract that is used to pay for fees
2356     * @param _fees Array containing:
2357     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
2358     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
2359     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
2360     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2361     *        0. evidenceTerms Max submitting evidence period duration in terms
2362     *        1. commitTerms Commit period duration in terms
2363     *        2. revealTerms Reveal period duration in terms
2364     *        3. appealTerms Appeal period duration in terms
2365     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2366     * @param _pcts Array containing:
2367     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
2368     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2369     * @param _roundParams Array containing params for rounds:
2370     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
2371     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
2372     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2373     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
2374     * @param _appealCollateralParams Array containing params for appeal collateral:
2375     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
2376     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
2377     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
2378     */
2379     constructor(
2380         uint64[2] memory _termParams,
2381         address[3] memory _governors,
2382         ERC20 _feeToken,
2383         uint256[3] memory _fees,
2384         uint64[5] memory _roundStateDurations,
2385         uint16[2] memory _pcts,
2386         uint64[4] memory _roundParams,
2387         uint256[2] memory _appealCollateralParams,
2388         uint256 _minActiveBalance
2389     )
2390         public
2391         CourtClock(_termParams)
2392         CourtConfig(_feeToken, _fees, _roundStateDurations, _pcts, _roundParams, _appealCollateralParams, _minActiveBalance)
2393     {
2394         _setFundsGovernor(_governors[0]);
2395         _setConfigGovernor(_governors[1]);
2396         _setModulesGovernor(_governors[2]);
2397     }
2398 
2399     /**
2400     * @notice Change Court configuration params
2401     * @param _fromTermId Identification number of the term in which the config will be effective at
2402     * @param _feeToken Address of the token contract that is used to pay for fees
2403     * @param _fees Array containing:
2404     *        0. jurorFee Amount of fee tokens that is paid per juror per dispute
2405     *        1. draftFee Amount of fee tokens per juror to cover the drafting cost
2406     *        2. settleFee Amount of fee tokens per juror to cover round settlement cost
2407     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2408     *        0. evidenceTerms Max submitting evidence period duration in terms
2409     *        1. commitTerms Commit period duration in terms
2410     *        2. revealTerms Reveal period duration in terms
2411     *        3. appealTerms Appeal period duration in terms
2412     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2413     * @param _pcts Array containing:
2414     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted jurors (‱ - 1/10,000)
2415     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2416     * @param _roundParams Array containing params for rounds:
2417     *        0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
2418     *        1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
2419     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2420     *        3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
2421     * @param _appealCollateralParams Array containing params for appeal collateral:
2422     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
2423     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
2424     * @param _minActiveBalance Minimum amount of juror tokens that can be activated
2425     */
2426     function setConfig(
2427         uint64 _fromTermId,
2428         ERC20 _feeToken,
2429         uint256[3] calldata _fees,
2430         uint64[5] calldata _roundStateDurations,
2431         uint16[2] calldata _pcts,
2432         uint64[4] calldata _roundParams,
2433         uint256[2] calldata _appealCollateralParams,
2434         uint256 _minActiveBalance
2435     )
2436         external
2437         onlyConfigGovernor
2438     {
2439         uint64 currentTermId = _ensureCurrentTerm();
2440         _setConfig(
2441             currentTermId,
2442             _fromTermId,
2443             _feeToken,
2444             _fees,
2445             _roundStateDurations,
2446             _pcts,
2447             _roundParams,
2448             _appealCollateralParams,
2449             _minActiveBalance
2450         );
2451     }
2452 
2453     /**
2454     * @notice Delay the Court start time to `_newFirstTermStartTime`
2455     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
2456     */
2457     function delayStartTime(uint64 _newFirstTermStartTime) external onlyConfigGovernor {
2458         _delayStartTime(_newFirstTermStartTime);
2459     }
2460 
2461     /**
2462     * @notice Change funds governor address to `_newFundsGovernor`
2463     * @param _newFundsGovernor Address of the new funds governor to be set
2464     */
2465     function changeFundsGovernor(address _newFundsGovernor) external onlyFundsGovernor {
2466         require(_newFundsGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
2467         _setFundsGovernor(_newFundsGovernor);
2468     }
2469 
2470     /**
2471     * @notice Change config governor address to `_newConfigGovernor`
2472     * @param _newConfigGovernor Address of the new config governor to be set
2473     */
2474     function changeConfigGovernor(address _newConfigGovernor) external onlyConfigGovernor {
2475         require(_newConfigGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
2476         _setConfigGovernor(_newConfigGovernor);
2477     }
2478 
2479     /**
2480     * @notice Change modules governor address to `_newModulesGovernor`
2481     * @param _newModulesGovernor Address of the new governor to be set
2482     */
2483     function changeModulesGovernor(address _newModulesGovernor) external onlyModulesGovernor {
2484         require(_newModulesGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
2485         _setModulesGovernor(_newModulesGovernor);
2486     }
2487 
2488     /**
2489     * @notice Remove the funds governor. Set the funds governor to the zero address.
2490     * @dev This action cannot be rolled back, once the funds governor has been unset, funds cannot be recovered from recoverable modules anymore
2491     */
2492     function ejectFundsGovernor() external onlyFundsGovernor {
2493         _setFundsGovernor(ZERO_ADDRESS);
2494     }
2495 
2496     /**
2497     * @notice Remove the modules governor. Set the modules governor to the zero address.
2498     * @dev This action cannot be rolled back, once the modules governor has been unset, system modules cannot be changed anymore
2499     */
2500     function ejectModulesGovernor() external onlyModulesGovernor {
2501         _setModulesGovernor(ZERO_ADDRESS);
2502     }
2503 
2504     /**
2505     * @notice Set module `_id` to `_addr`
2506     * @param _id ID of the module to be set
2507     * @param _addr Address of the module to be set
2508     */
2509     function setModule(bytes32 _id, address _addr) external onlyModulesGovernor {
2510         _setModule(_id, _addr);
2511     }
2512 
2513     /**
2514     * @notice Set many modules at once
2515     * @param _ids List of ids of each module to be set
2516     * @param _addresses List of addressed of each the module to be set
2517     */
2518     function setModules(bytes32[] calldata _ids, address[] calldata _addresses) external onlyModulesGovernor {
2519         require(_ids.length == _addresses.length, ERROR_INVALID_IMPLS_INPUT_LENGTH);
2520 
2521         for (uint256 i = 0; i < _ids.length; i++) {
2522             _setModule(_ids[i], _addresses[i]);
2523         }
2524     }
2525 
2526     /**
2527     * @dev Tell the full Court configuration parameters at a certain term
2528     * @param _termId Identification number of the term querying the Court config of
2529     * @return token Address of the token used to pay for fees
2530     * @return fees Array containing:
2531     *         0. jurorFee Amount of fee tokens that is paid per juror per dispute
2532     *         1. draftFee Amount of fee tokens per juror to cover the drafting cost
2533     *         2. settleFee Amount of fee tokens per juror to cover round settlement cost
2534     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2535     *         0. evidenceTerms Max submitting evidence period duration in terms
2536     *         1. commitTerms Commit period duration in terms
2537     *         2. revealTerms Reveal period duration in terms
2538     *         3. appealTerms Appeal period duration in terms
2539     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
2540     * @return pcts Array containing:
2541     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
2542     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2543     * @return roundParams Array containing params for rounds:
2544     *         0. firstRoundJurorsNumber Number of jurors to be drafted for the first round of disputes
2545     *         1. appealStepFactor Increasing factor for the number of jurors of each round of a dispute
2546     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2547     *         3. finalRoundLockTerms Number of terms that a coherent juror in a final round is disallowed to withdraw (to prevent 51% attacks)
2548     * @return appealCollateralParams Array containing params for appeal collateral:
2549     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
2550     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
2551     */
2552     function getConfig(uint64 _termId) external view
2553         returns (
2554             ERC20 feeToken,
2555             uint256[3] memory fees,
2556             uint64[5] memory roundStateDurations,
2557             uint16[2] memory pcts,
2558             uint64[4] memory roundParams,
2559             uint256[2] memory appealCollateralParams,
2560             uint256 minActiveBalance
2561         )
2562     {
2563         uint64 lastEnsuredTermId = _lastEnsuredTermId();
2564         return _getConfigAt(_termId, lastEnsuredTermId);
2565     }
2566 
2567     /**
2568     * @dev Tell the draft config at a certain term
2569     * @param _termId Identification number of the term querying the draft config of
2570     * @return feeToken Address of the token used to pay for fees
2571     * @return draftFee Amount of fee tokens per juror to cover the drafting cost
2572     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted juror (‱ - 1/10,000)
2573     */
2574     function getDraftConfig(uint64 _termId) external view returns (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct) {
2575         uint64 lastEnsuredTermId = _lastEnsuredTermId();
2576         return _getDraftConfig(_termId, lastEnsuredTermId);
2577     }
2578 
2579     /**
2580     * @dev Tell the min active balance config at a certain term
2581     * @param _termId Identification number of the term querying the min active balance config of
2582     * @return Minimum amount of tokens jurors have to activate to participate in the Court
2583     */
2584     function getMinActiveBalance(uint64 _termId) external view returns (uint256) {
2585         uint64 lastEnsuredTermId = _lastEnsuredTermId();
2586         return _getMinActiveBalance(_termId, lastEnsuredTermId);
2587     }
2588 
2589     /**
2590     * @dev Tell the address of the funds governor
2591     * @return Address of the funds governor
2592     */
2593     function getFundsGovernor() external view returns (address) {
2594         return governor.funds;
2595     }
2596 
2597     /**
2598     * @dev Tell the address of the config governor
2599     * @return Address of the config governor
2600     */
2601     function getConfigGovernor() external view returns (address) {
2602         return governor.config;
2603     }
2604 
2605     /**
2606     * @dev Tell the address of the modules governor
2607     * @return Address of the modules governor
2608     */
2609     function getModulesGovernor() external view returns (address) {
2610         return governor.modules;
2611     }
2612 
2613     /**
2614     * @dev Tell address of a module based on a given ID
2615     * @param _id ID of the module being queried
2616     * @return Address of the requested module
2617     */
2618     function getModule(bytes32 _id) external view returns (address) {
2619         return _getModule(_id);
2620     }
2621 
2622     /**
2623     * @dev Tell the address of the DisputeManager module
2624     * @return Address of the DisputeManager module
2625     */
2626     function getDisputeManager() external view returns (address) {
2627         return _getDisputeManager();
2628     }
2629 
2630     /**
2631     * @dev Tell the address of the Treasury module
2632     * @return Address of the Treasury module
2633     */
2634     function getTreasury() external view returns (address) {
2635         return _getModule(TREASURY);
2636     }
2637 
2638     /**
2639     * @dev Tell the address of the Voting module
2640     * @return Address of the Voting module
2641     */
2642     function getVoting() external view returns (address) {
2643         return _getModule(VOTING);
2644     }
2645 
2646     /**
2647     * @dev Tell the address of the JurorsRegistry module
2648     * @return Address of the JurorsRegistry module
2649     */
2650     function getJurorsRegistry() external view returns (address) {
2651         return _getModule(JURORS_REGISTRY);
2652     }
2653 
2654     /**
2655     * @dev Tell the address of the Subscriptions module
2656     * @return Address of the Subscriptions module
2657     */
2658     function getSubscriptions() external view returns (address) {
2659         return _getSubscriptions();
2660     }
2661 
2662     /**
2663     * @dev Internal function to set the address of the funds governor
2664     * @param _newFundsGovernor Address of the new config governor to be set
2665     */
2666     function _setFundsGovernor(address _newFundsGovernor) internal {
2667         emit FundsGovernorChanged(governor.funds, _newFundsGovernor);
2668         governor.funds = _newFundsGovernor;
2669     }
2670 
2671     /**
2672     * @dev Internal function to set the address of the config governor
2673     * @param _newConfigGovernor Address of the new config governor to be set
2674     */
2675     function _setConfigGovernor(address _newConfigGovernor) internal {
2676         emit ConfigGovernorChanged(governor.config, _newConfigGovernor);
2677         governor.config = _newConfigGovernor;
2678     }
2679 
2680     /**
2681     * @dev Internal function to set the address of the modules governor
2682     * @param _newModulesGovernor Address of the new modules governor to be set
2683     */
2684     function _setModulesGovernor(address _newModulesGovernor) internal {
2685         emit ModulesGovernorChanged(governor.modules, _newModulesGovernor);
2686         governor.modules = _newModulesGovernor;
2687     }
2688 
2689     /**
2690     * @dev Internal function to set a module
2691     * @param _id Id of the module to be set
2692     * @param _addr Address of the module to be set
2693     */
2694     function _setModule(bytes32 _id, address _addr) internal {
2695         require(isContract(_addr), ERROR_IMPLEMENTATION_NOT_CONTRACT);
2696         modules[_id] = _addr;
2697         emit ModuleSet(_id, _addr);
2698     }
2699 
2700     /**
2701     * @dev Internal function to notify when a term has been transitioned
2702     * @param _termId Identification number of the new current term that has been transitioned
2703     */
2704     function _onTermTransitioned(uint64 _termId) internal {
2705         _ensureTermConfig(_termId);
2706     }
2707 
2708     /**
2709     * @dev Internal function to tell the address of the DisputeManager module
2710     * @return Address of the DisputeManager module
2711     */
2712     function _getDisputeManager() internal view returns (address) {
2713         return _getModule(DISPUTE_MANAGER);
2714     }
2715 
2716     /**
2717     * @dev Internal function to tell the address of the Subscriptions module
2718     * @return Address of the Subscriptions module
2719     */
2720     function _getSubscriptions() internal view returns (address) {
2721         return _getModule(SUBSCRIPTIONS);
2722     }
2723 
2724     /**
2725     * @dev Internal function to tell address of a module based on a given ID
2726     * @param _id ID of the module being queried
2727     * @return Address of the requested module
2728     */
2729     function _getModule(bytes32 _id) internal view returns (address) {
2730         return modules[_id];
2731     }
2732 }
2733 
2734 // File: contracts/court/config/ConfigConsumer.sol
2735 
2736 pragma solidity ^0.5.8;
2737 
2738 
2739 
2740 
2741 
2742 contract ConfigConsumer is CourtConfigData {
2743     /**
2744     * @dev Internal function to fetch the address of the Config module from the controller
2745     * @return Address of the Config module
2746     */
2747     function _courtConfig() internal view returns (IConfig);
2748 
2749     /**
2750     * @dev Internal function to get the Court config for a certain term
2751     * @param _termId Identification number of the term querying the Court config of
2752     * @return Court config for the given term
2753     */
2754     function _getConfigAt(uint64 _termId) internal view returns (Config memory) {
2755         (ERC20 _feeToken,
2756         uint256[3] memory _fees,
2757         uint64[5] memory _roundStateDurations,
2758         uint16[2] memory _pcts,
2759         uint64[4] memory _roundParams,
2760         uint256[2] memory _appealCollateralParams,
2761         uint256 _minActiveBalance) = _courtConfig().getConfig(_termId);
2762 
2763         Config memory config;
2764 
2765         config.fees = FeesConfig({
2766             token: _feeToken,
2767             jurorFee: _fees[0],
2768             draftFee: _fees[1],
2769             settleFee: _fees[2],
2770             finalRoundReduction: _pcts[1]
2771         });
2772 
2773         config.disputes = DisputesConfig({
2774             evidenceTerms: _roundStateDurations[0],
2775             commitTerms: _roundStateDurations[1],
2776             revealTerms: _roundStateDurations[2],
2777             appealTerms: _roundStateDurations[3],
2778             appealConfirmTerms: _roundStateDurations[4],
2779             penaltyPct: _pcts[0],
2780             firstRoundJurorsNumber: _roundParams[0],
2781             appealStepFactor: _roundParams[1],
2782             maxRegularAppealRounds: _roundParams[2],
2783             finalRoundLockTerms: _roundParams[3],
2784             appealCollateralFactor: _appealCollateralParams[0],
2785             appealConfirmCollateralFactor: _appealCollateralParams[1]
2786         });
2787 
2788         config.minActiveBalance = _minActiveBalance;
2789 
2790         return config;
2791     }
2792 
2793     /**
2794     * @dev Internal function to get the draft config for a given term
2795     * @param _termId Identification number of the term querying the draft config of
2796     * @return Draft config for the given term
2797     */
2798     function _getDraftConfig(uint64 _termId) internal view returns (DraftConfig memory) {
2799         (ERC20 feeToken, uint256 draftFee, uint16 penaltyPct) = _courtConfig().getDraftConfig(_termId);
2800         return DraftConfig({ feeToken: feeToken, draftFee: draftFee, penaltyPct: penaltyPct });
2801     }
2802 
2803     /**
2804     * @dev Internal function to get the min active balance config for a given term
2805     * @param _termId Identification number of the term querying the min active balance config of
2806     * @return Minimum amount of juror tokens that can be activated
2807     */
2808     function _getMinActiveBalance(uint64 _termId) internal view returns (uint256) {
2809         return _courtConfig().getMinActiveBalance(_termId);
2810     }
2811 }
2812 
2813 // File: contracts/voting/ICRVotingOwner.sol
2814 
2815 pragma solidity ^0.5.8;
2816 
2817 
2818 interface ICRVotingOwner {
2819     /**
2820     * @dev Ensure votes can be committed for a vote instance, revert otherwise
2821     * @param _voteId ID of the vote instance to request the weight of a voter for
2822     */
2823     function ensureCanCommit(uint256 _voteId) external;
2824 
2825     /**
2826     * @dev Ensure a certain voter can commit votes for a vote instance, revert otherwise
2827     * @param _voteId ID of the vote instance to request the weight of a voter for
2828     * @param _voter Address of the voter querying the weight of
2829     */
2830     function ensureCanCommit(uint256 _voteId, address _voter) external;
2831 
2832     /**
2833     * @dev Ensure a certain voter can reveal votes for vote instance, revert otherwise
2834     * @param _voteId ID of the vote instance to request the weight of a voter for
2835     * @param _voter Address of the voter querying the weight of
2836     * @return Weight of the requested juror for the requested vote instance
2837     */
2838     function ensureCanReveal(uint256 _voteId, address _voter) external returns (uint64);
2839 }
2840 
2841 // File: contracts/voting/ICRVoting.sol
2842 
2843 pragma solidity ^0.5.8;
2844 
2845 
2846 
2847 interface ICRVoting {
2848     /**
2849     * @dev Create a new vote instance
2850     * @dev This function can only be called by the CRVoting owner
2851     * @param _voteId ID of the new vote instance to be created
2852     * @param _possibleOutcomes Number of possible outcomes for the new vote instance to be created
2853     */
2854     function create(uint256 _voteId, uint8 _possibleOutcomes) external;
2855 
2856     /**
2857     * @dev Get the winning outcome of a vote instance
2858     * @param _voteId ID of the vote instance querying the winning outcome of
2859     * @return Winning outcome of the given vote instance or refused in case it's missing
2860     */
2861     function getWinningOutcome(uint256 _voteId) external view returns (uint8);
2862 
2863     /**
2864     * @dev Get the tally of an outcome for a certain vote instance
2865     * @param _voteId ID of the vote instance querying the tally of
2866     * @param _outcome Outcome querying the tally of
2867     * @return Tally of the outcome being queried for the given vote instance
2868     */
2869     function getOutcomeTally(uint256 _voteId, uint8 _outcome) external view returns (uint256);
2870 
2871     /**
2872     * @dev Tell whether an outcome is valid for a given vote instance or not
2873     * @param _voteId ID of the vote instance to check the outcome of
2874     * @param _outcome Outcome to check if valid or not
2875     * @return True if the given outcome is valid for the requested vote instance, false otherwise
2876     */
2877     function isValidOutcome(uint256 _voteId, uint8 _outcome) external view returns (bool);
2878 
2879     /**
2880     * @dev Get the outcome voted by a voter for a certain vote instance
2881     * @param _voteId ID of the vote instance querying the outcome of
2882     * @param _voter Address of the voter querying the outcome of
2883     * @return Outcome of the voter for the given vote instance
2884     */
2885     function getVoterOutcome(uint256 _voteId, address _voter) external view returns (uint8);
2886 
2887     /**
2888     * @dev Tell whether a voter voted in favor of a certain outcome in a vote instance or not
2889     * @param _voteId ID of the vote instance to query if a voter voted in favor of a certain outcome
2890     * @param _outcome Outcome to query if the given voter voted in favor of
2891     * @param _voter Address of the voter to query if voted in favor of the given outcome
2892     * @return True if the given voter voted in favor of the given outcome, false otherwise
2893     */
2894     function hasVotedInFavorOf(uint256 _voteId, uint8 _outcome, address _voter) external view returns (bool);
2895 
2896     /**
2897     * @dev Filter a list of voters based on whether they voted in favor of a certain outcome in a vote instance or not
2898     * @param _voteId ID of the vote instance to be checked
2899     * @param _outcome Outcome to filter the list of voters of
2900     * @param _voters List of addresses of the voters to be filtered
2901     * @return List of results to tell whether a voter voted in favor of the given outcome or not
2902     */
2903     function getVotersInFavorOf(uint256 _voteId, uint8 _outcome, address[] calldata _voters) external view returns (bool[] memory);
2904 }
2905 
2906 // File: contracts/treasury/ITreasury.sol
2907 
2908 pragma solidity ^0.5.8;
2909 
2910 
2911 
2912 interface ITreasury {
2913     /**
2914     * @dev Assign a certain amount of tokens to an account
2915     * @param _token ERC20 token to be assigned
2916     * @param _to Address of the recipient that will be assigned the tokens to
2917     * @param _amount Amount of tokens to be assigned to the recipient
2918     */
2919     function assign(ERC20 _token, address _to, uint256 _amount) external;
2920 
2921     /**
2922     * @dev Withdraw a certain amount of tokens
2923     * @param _token ERC20 token to be withdrawn
2924     * @param _to Address of the recipient that will receive the tokens
2925     * @param _amount Amount of tokens to be withdrawn from the sender
2926     */
2927     function withdraw(ERC20 _token, address _to, uint256 _amount) external;
2928 }
2929 
2930 // File: contracts/arbitration/IArbitrator.sol
2931 
2932 pragma solidity ^0.5.8;
2933 
2934 
2935 
2936 interface IArbitrator {
2937     /**
2938     * @dev Create a dispute over the Arbitrable sender with a number of possible rulings
2939     * @param _possibleRulings Number of possible rulings allowed for the dispute
2940     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2941     * @return Dispute identification number
2942     */
2943     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256);
2944 
2945     /**
2946     * @dev Close the evidence period of a dispute
2947     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2948     */
2949     function closeEvidencePeriod(uint256 _disputeId) external;
2950 
2951     /**
2952     * @dev Execute the Arbitrable associated to a dispute based on its final ruling
2953     * @param _disputeId Identification number of the dispute to be executed
2954     */
2955     function executeRuling(uint256 _disputeId) external;
2956 
2957     /**
2958     * @dev Tell the dispute fees information to create a dispute
2959     * @return recipient Address where the corresponding dispute fees must be transferred to
2960     * @return feeToken ERC20 token used for the fees
2961     * @return feeAmount Total amount of fees that must be allowed to the recipient
2962     */
2963     function getDisputeFees() external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);
2964 
2965     /**
2966     * @dev Tell the subscription fees information for a subscriber to be up-to-date
2967     * @param _subscriber Address of the account paying the subscription fees for
2968     * @return recipient Address where the corresponding subscriptions fees must be transferred to
2969     * @return feeToken ERC20 token used for the subscription fees
2970     * @return feeAmount Total amount of fees that must be allowed to the recipient
2971     */
2972     function getSubscriptionFees(address _subscriber) external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);
2973 }
2974 
2975 // File: contracts/standards/ERC165.sol
2976 
2977 pragma solidity ^0.5.8;
2978 
2979 
2980 interface ERC165 {
2981     /**
2982     * @dev Query if a contract implements a certain interface
2983     * @param _interfaceId The interface identifier being queried, as specified in ERC-165
2984     * @return True if the contract implements the requested interface and if its not 0xffffffff, false otherwise
2985     */
2986     function supportsInterface(bytes4 _interfaceId) external pure returns (bool);
2987 }
2988 
2989 // File: contracts/arbitration/IArbitrable.sol
2990 
2991 pragma solidity ^0.5.8;
2992 
2993 
2994 
2995 
2996 contract IArbitrable is ERC165 {
2997     bytes4 internal constant ERC165_INTERFACE_ID = bytes4(0x01ffc9a7);
2998     bytes4 internal constant ARBITRABLE_INTERFACE_ID = bytes4(0x88f3ee69);
2999 
3000     /**
3001     * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
3002     * @param arbitrator IArbitrator instance ruling the dispute
3003     * @param disputeId Identification number of the dispute being ruled by the arbitrator
3004     * @param ruling Ruling given by the arbitrator
3005     */
3006     event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);
3007 
3008     /**
3009     * @dev Emitted when new evidence is submitted for the IArbitrable instance's dispute
3010     * @param disputeId Identification number of the dispute receiving new evidence
3011     * @param submitter Address of the account submitting the evidence
3012     * @param evidence Data submitted for the evidence of the dispute
3013     * @param finished Whether or not the submitter has finished submitting evidence
3014     */
3015     event EvidenceSubmitted(uint256 indexed disputeId, address indexed submitter, bytes evidence, bool finished);
3016 
3017     /**
3018     * @dev Submit evidence for a dispute
3019     * @param _disputeId Id of the dispute in the Court
3020     * @param _evidence Data submitted for the evidence related to the dispute
3021     * @param _finished Whether or not the submitter has finished submitting evidence
3022     */
3023     function submitEvidence(uint256 _disputeId, bytes calldata _evidence, bool _finished) external;
3024 
3025     /**
3026     * @dev Give a ruling for a certain dispute, the account calling it must have rights to rule on the contract
3027     * @param _disputeId Identification number of the dispute to be ruled
3028     * @param _ruling Ruling given by the arbitrator, where 0 is reserved for "refused to make a decision"
3029     */
3030     function rule(uint256 _disputeId, uint256 _ruling) external;
3031 
3032     /**
3033     * @dev ERC165 - Query if a contract implements a certain interface
3034     * @param _interfaceId The interface identifier being queried, as specified in ERC-165
3035     * @return True if this contract supports the given interface, false otherwise
3036     */
3037     function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
3038         return _interfaceId == ARBITRABLE_INTERFACE_ID || _interfaceId == ERC165_INTERFACE_ID;
3039     }
3040 }
3041 
3042 // File: contracts/disputes/IDisputeManager.sol
3043 
3044 pragma solidity ^0.5.8;
3045 
3046 
3047 
3048 
3049 interface IDisputeManager {
3050     enum DisputeState {
3051         PreDraft,
3052         Adjudicating,
3053         Ruled
3054     }
3055 
3056     enum AdjudicationState {
3057         Invalid,
3058         Committing,
3059         Revealing,
3060         Appealing,
3061         ConfirmingAppeal,
3062         Ended
3063     }
3064 
3065     /**
3066     * @dev Create a dispute to be drafted in a future term
3067     * @param _subject Arbitrable instance creating the dispute
3068     * @param _possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
3069     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
3070     * @return Dispute identification number
3071     */
3072     function createDispute(IArbitrable _subject, uint8 _possibleRulings, bytes calldata _metadata) external returns (uint256);
3073 
3074     /**
3075     * @dev Close the evidence period of a dispute
3076     * @param _subject IArbitrable instance requesting to close the evidence submission period
3077     * @param _disputeId Identification number of the dispute to close its evidence submitting period
3078     */
3079     function closeEvidencePeriod(IArbitrable _subject, uint256 _disputeId) external;
3080 
3081     /**
3082     * @dev Draft jurors for the next round of a dispute
3083     * @param _disputeId Identification number of the dispute to be drafted
3084     */
3085     function draft(uint256 _disputeId) external;
3086 
3087     /**
3088     * @dev Appeal round of a dispute in favor of a certain ruling
3089     * @param _disputeId Identification number of the dispute being appealed
3090     * @param _roundId Identification number of the dispute round being appealed
3091     * @param _ruling Ruling appealing a dispute round in favor of
3092     */
3093     function createAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
3094 
3095     /**
3096     * @dev Confirm appeal for a round of a dispute in favor of a ruling
3097     * @param _disputeId Identification number of the dispute confirming an appeal of
3098     * @param _roundId Identification number of the dispute round confirming an appeal of
3099     * @param _ruling Ruling being confirmed against a dispute round appeal
3100     */
3101     function confirmAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
3102 
3103     /**
3104     * @dev Compute the final ruling for a dispute
3105     * @param _disputeId Identification number of the dispute to compute its final ruling
3106     * @return subject Arbitrable instance associated to the dispute
3107     * @return finalRuling Final ruling decided for the given dispute
3108     */
3109     function computeRuling(uint256 _disputeId) external returns (IArbitrable subject, uint8 finalRuling);
3110 
3111     /**
3112     * @dev Settle penalties for a round of a dispute
3113     * @param _disputeId Identification number of the dispute to settle penalties for
3114     * @param _roundId Identification number of the dispute round to settle penalties for
3115     * @param _jurorsToSettle Maximum number of jurors to be slashed in this call
3116     */
3117     function settlePenalties(uint256 _disputeId, uint256 _roundId, uint256 _jurorsToSettle) external;
3118 
3119     /**
3120     * @dev Claim rewards for a round of a dispute for juror
3121     * @dev For regular rounds, it will only reward winning jurors
3122     * @param _disputeId Identification number of the dispute to settle rewards for
3123     * @param _roundId Identification number of the dispute round to settle rewards for
3124     * @param _juror Address of the juror to settle their rewards
3125     */
3126     function settleReward(uint256 _disputeId, uint256 _roundId, address _juror) external;
3127 
3128     /**
3129     * @dev Settle appeal deposits for a round of a dispute
3130     * @param _disputeId Identification number of the dispute to settle appeal deposits for
3131     * @param _roundId Identification number of the dispute round to settle appeal deposits for
3132     */
3133     function settleAppealDeposit(uint256 _disputeId, uint256 _roundId) external;
3134 
3135     /**
3136     * @dev Tell the amount of token fees required to create a dispute
3137     * @return feeToken ERC20 token used for the fees
3138     * @return feeAmount Total amount of fees to be paid for a dispute at the given term
3139     */
3140     function getDisputeFees() external view returns (ERC20 feeToken, uint256 feeAmount);
3141 
3142     /**
3143     * @dev Tell information of a certain dispute
3144     * @param _disputeId Identification number of the dispute being queried
3145     * @return subject Arbitrable subject being disputed
3146     * @return possibleRulings Number of possible rulings allowed for the drafted jurors to vote on the dispute
3147     * @return state Current state of the dispute being queried: pre-draft, adjudicating, or ruled
3148     * @return finalRuling The winning ruling in case the dispute is finished
3149     * @return lastRoundId Identification number of the last round created for the dispute
3150     * @return createTermId Identification number of the term when the dispute was created
3151     */
3152     function getDispute(uint256 _disputeId) external view
3153         returns (IArbitrable subject, uint8 possibleRulings, DisputeState state, uint8 finalRuling, uint256 lastRoundId, uint64 createTermId);
3154 
3155     /**
3156     * @dev Tell information of a certain adjudication round
3157     * @param _disputeId Identification number of the dispute being queried
3158     * @param _roundId Identification number of the round being queried
3159     * @return draftTerm Term from which the requested round can be drafted
3160     * @return delayedTerms Number of terms the given round was delayed based on its requested draft term id
3161     * @return jurorsNumber Number of jurors requested for the round
3162     * @return selectedJurors Number of jurors already selected for the requested round
3163     * @return settledPenalties Whether or not penalties have been settled for the requested round
3164     * @return collectedTokens Amount of juror tokens that were collected from slashed jurors for the requested round
3165     * @return coherentJurors Number of jurors that voted in favor of the final ruling in the requested round
3166     * @return state Adjudication state of the requested round
3167     */
3168     function getRound(uint256 _disputeId, uint256 _roundId) external view
3169         returns (
3170             uint64 draftTerm,
3171             uint64 delayedTerms,
3172             uint64 jurorsNumber,
3173             uint64 selectedJurors,
3174             uint256 jurorFees,
3175             bool settledPenalties,
3176             uint256 collectedTokens,
3177             uint64 coherentJurors,
3178             AdjudicationState state
3179         );
3180 
3181     /**
3182     * @dev Tell appeal-related information of a certain adjudication round
3183     * @param _disputeId Identification number of the dispute being queried
3184     * @param _roundId Identification number of the round being queried
3185     * @return maker Address of the account appealing the given round
3186     * @return appealedRuling Ruling confirmed by the appealer of the given round
3187     * @return taker Address of the account confirming the appeal of the given round
3188     * @return opposedRuling Ruling confirmed by the appeal taker of the given round
3189     */
3190     function getAppeal(uint256 _disputeId, uint256 _roundId) external view
3191         returns (address maker, uint64 appealedRuling, address taker, uint64 opposedRuling);
3192 
3193     /**
3194     * @dev Tell information related to the next round due to an appeal of a certain round given.
3195     * @param _disputeId Identification number of the dispute being queried
3196     * @param _roundId Identification number of the round requesting the appeal details of
3197     * @return nextRoundStartTerm Term ID from which the next round will start
3198     * @return nextRoundJurorsNumber Jurors number for the next round
3199     * @return newDisputeState New state for the dispute associated to the given round after the appeal
3200     * @return feeToken ERC20 token used for the next round fees
3201     * @return jurorFees Total amount of fees to be distributed between the winning jurors of the next round
3202     * @return totalFees Total amount of fees for a regular round at the given term
3203     * @return appealDeposit Amount to be deposit of fees for a regular round at the given term
3204     * @return confirmAppealDeposit Total amount of fees for a regular round at the given term
3205     */
3206     function getNextRoundDetails(uint256 _disputeId, uint256 _roundId) external view
3207         returns (
3208             uint64 nextRoundStartTerm,
3209             uint64 nextRoundJurorsNumber,
3210             DisputeState newDisputeState,
3211             ERC20 feeToken,
3212             uint256 totalFees,
3213             uint256 jurorFees,
3214             uint256 appealDeposit,
3215             uint256 confirmAppealDeposit
3216         );
3217 
3218     /**
3219     * @dev Tell juror-related information of a certain adjudication round
3220     * @param _disputeId Identification number of the dispute being queried
3221     * @param _roundId Identification number of the round being queried
3222     * @param _juror Address of the juror being queried
3223     * @return weight Juror weight drafted for the requested round
3224     * @return rewarded Whether or not the given juror was rewarded based on the requested round
3225     */
3226     function getJuror(uint256 _disputeId, uint256 _roundId, address _juror) external view returns (uint64 weight, bool rewarded);
3227 }
3228 
3229 // File: contracts/subscriptions/ISubscriptions.sol
3230 
3231 pragma solidity ^0.5.8;
3232 
3233 
3234 
3235 interface ISubscriptions {
3236     /**
3237     * @dev Tell whether a certain subscriber has paid all the fees up to current period or not
3238     * @param _subscriber Address of subscriber being checked
3239     * @return True if subscriber has paid all the fees up to current period, false otherwise
3240     */
3241     function isUpToDate(address _subscriber) external view returns (bool);
3242 
3243     /**
3244     * @dev Tell the minimum amount of fees to pay and resulting last paid period for a given subscriber in order to be up-to-date
3245     * @param _subscriber Address of the subscriber willing to pay
3246     * @return feeToken ERC20 token used for the subscription fees
3247     * @return amountToPay Amount of subscription fee tokens to be paid
3248     * @return newLastPeriodId Identification number of the resulting last paid period
3249     */
3250     function getOwedFeesDetails(address _subscriber) external view returns (ERC20, uint256, uint256);
3251 }
3252 
3253 // File: contracts/court/controller/Controlled.sol
3254 
3255 pragma solidity ^0.5.8;
3256 
3257 
3258 
3259 
3260 
3261 
3262 
3263 
3264 
3265 
3266 
3267 contract Controlled is IsContract, ConfigConsumer {
3268     string private constant ERROR_CONTROLLER_NOT_CONTRACT = "CTD_CONTROLLER_NOT_CONTRACT";
3269     string private constant ERROR_SENDER_NOT_CONTROLLER = "CTD_SENDER_NOT_CONTROLLER";
3270     string private constant ERROR_SENDER_NOT_CONFIG_GOVERNOR = "CTD_SENDER_NOT_CONFIG_GOVERNOR";
3271     string private constant ERROR_SENDER_NOT_DISPUTES_MODULE = "CTD_SENDER_NOT_DISPUTES_MODULE";
3272 
3273     // Address of the controller
3274     Controller internal controller;
3275 
3276     /**
3277     * @dev Ensure the msg.sender is the controller's config governor
3278     */
3279     modifier onlyConfigGovernor {
3280         require(msg.sender == _configGovernor(), ERROR_SENDER_NOT_CONFIG_GOVERNOR);
3281         _;
3282     }
3283 
3284     /**
3285     * @dev Ensure the msg.sender is the controller
3286     */
3287     modifier onlyController() {
3288         require(msg.sender == address(controller), ERROR_SENDER_NOT_CONTROLLER);
3289         _;
3290     }
3291 
3292     /**
3293     * @dev Ensure the msg.sender is the DisputeManager module
3294     */
3295     modifier onlyDisputeManager() {
3296         require(msg.sender == address(_disputeManager()), ERROR_SENDER_NOT_DISPUTES_MODULE);
3297         _;
3298     }
3299 
3300     /**
3301     * @dev Constructor function
3302     * @param _controller Address of the controller
3303     */
3304     constructor(Controller _controller) public {
3305         require(isContract(address(_controller)), ERROR_CONTROLLER_NOT_CONTRACT);
3306         controller = _controller;
3307     }
3308 
3309     /**
3310     * @dev Tell the address of the controller
3311     * @return Address of the controller
3312     */
3313     function getController() external view returns (Controller) {
3314         return controller;
3315     }
3316 
3317     /**
3318     * @dev Internal function to ensure the Court term is up-to-date, it will try to update it if not
3319     * @return Identification number of the current Court term
3320     */
3321     function _ensureCurrentTerm() internal returns (uint64) {
3322         return _clock().ensureCurrentTerm();
3323     }
3324 
3325     /**
3326     * @dev Internal function to fetch the last ensured term ID of the Court
3327     * @return Identification number of the last ensured term
3328     */
3329     function _getLastEnsuredTermId() internal view returns (uint64) {
3330         return _clock().getLastEnsuredTermId();
3331     }
3332 
3333     /**
3334     * @dev Internal function to tell the current term identification number
3335     * @return Identification number of the current term
3336     */
3337     function _getCurrentTermId() internal view returns (uint64) {
3338         return _clock().getCurrentTermId();
3339     }
3340 
3341     /**
3342     * @dev Internal function to fetch the controller's config governor
3343     * @return Address of the controller's governor
3344     */
3345     function _configGovernor() internal view returns (address) {
3346         return controller.getConfigGovernor();
3347     }
3348 
3349     /**
3350     * @dev Internal function to fetch the address of the DisputeManager module from the controller
3351     * @return Address of the DisputeManager module
3352     */
3353     function _disputeManager() internal view returns (IDisputeManager) {
3354         return IDisputeManager(controller.getDisputeManager());
3355     }
3356 
3357     /**
3358     * @dev Internal function to fetch the address of the Treasury module implementation from the controller
3359     * @return Address of the Treasury module implementation
3360     */
3361     function _treasury() internal view returns (ITreasury) {
3362         return ITreasury(controller.getTreasury());
3363     }
3364 
3365     /**
3366     * @dev Internal function to fetch the address of the Voting module implementation from the controller
3367     * @return Address of the Voting module implementation
3368     */
3369     function _voting() internal view returns (ICRVoting) {
3370         return ICRVoting(controller.getVoting());
3371     }
3372 
3373     /**
3374     * @dev Internal function to fetch the address of the Voting module owner from the controller
3375     * @return Address of the Voting module owner
3376     */
3377     function _votingOwner() internal view returns (ICRVotingOwner) {
3378         return ICRVotingOwner(address(_disputeManager()));
3379     }
3380 
3381     /**
3382     * @dev Internal function to fetch the address of the JurorRegistry module implementation from the controller
3383     * @return Address of the JurorRegistry module implementation
3384     */
3385     function _jurorsRegistry() internal view returns (IJurorsRegistry) {
3386         return IJurorsRegistry(controller.getJurorsRegistry());
3387     }
3388 
3389     /**
3390     * @dev Internal function to fetch the address of the Subscriptions module implementation from the controller
3391     * @return Address of the Subscriptions module implementation
3392     */
3393     function _subscriptions() internal view returns (ISubscriptions) {
3394         return ISubscriptions(controller.getSubscriptions());
3395     }
3396 
3397     /**
3398     * @dev Internal function to fetch the address of the Clock module from the controller
3399     * @return Address of the Clock module
3400     */
3401     function _clock() internal view returns (IClock) {
3402         return IClock(controller);
3403     }
3404 
3405     /**
3406     * @dev Internal function to fetch the address of the Config module from the controller
3407     * @return Address of the Config module
3408     */
3409     function _courtConfig() internal view returns (IConfig) {
3410         return IConfig(controller);
3411     }
3412 }
3413 
3414 // File: contracts/court/controller/ControlledRecoverable.sol
3415 
3416 pragma solidity ^0.5.8;
3417 
3418 
3419 
3420 
3421 
3422 contract ControlledRecoverable is Controlled {
3423     using SafeERC20 for ERC20;
3424 
3425     string private constant ERROR_SENDER_NOT_FUNDS_GOVERNOR = "CTD_SENDER_NOT_FUNDS_GOVERNOR";
3426     string private constant ERROR_INSUFFICIENT_RECOVER_FUNDS = "CTD_INSUFFICIENT_RECOVER_FUNDS";
3427     string private constant ERROR_RECOVER_TOKEN_FUNDS_FAILED = "CTD_RECOVER_TOKEN_FUNDS_FAILED";
3428 
3429     event RecoverFunds(ERC20 token, address recipient, uint256 balance);
3430 
3431     /**
3432     * @dev Ensure the msg.sender is the controller's funds governor
3433     */
3434     modifier onlyFundsGovernor {
3435         require(msg.sender == controller.getFundsGovernor(), ERROR_SENDER_NOT_FUNDS_GOVERNOR);
3436         _;
3437     }
3438 
3439     /**
3440     * @dev Constructor function
3441     * @param _controller Address of the controller
3442     */
3443     constructor(Controller _controller) Controlled(_controller) public {
3444         // solium-disable-previous-line no-empty-blocks
3445     }
3446 
3447     /**
3448     * @notice Transfer all `_token` tokens to `_to`
3449     * @param _token ERC20 token to be recovered
3450     * @param _to Address of the recipient that will be receive all the funds of the requested token
3451     */
3452     function recoverFunds(ERC20 _token, address _to) external onlyFundsGovernor {
3453         uint256 balance = _token.balanceOf(address(this));
3454         require(balance > 0, ERROR_INSUFFICIENT_RECOVER_FUNDS);
3455         require(_token.safeTransfer(_to, balance), ERROR_RECOVER_TOKEN_FUNDS_FAILED);
3456         emit RecoverFunds(_token, _to, balance);
3457     }
3458 }
3459 
3460 // File: contracts/registry/JurorsRegistry.sol
3461 
3462 pragma solidity ^0.5.8;
3463 
3464 
3465 
3466 
3467 
3468 
3469 
3470 
3471 
3472 
3473 
3474 
3475 
3476 
3477 contract JurorsRegistry is ControlledRecoverable, IJurorsRegistry, ERC900, ApproveAndCallFallBack {
3478     using SafeERC20 for ERC20;
3479     using SafeMath for uint256;
3480     using PctHelpers for uint256;
3481     using BytesHelpers for bytes;
3482     using HexSumTree for HexSumTree.Tree;
3483     using JurorsTreeSortition for HexSumTree.Tree;
3484 
3485     string private constant ERROR_NOT_CONTRACT = "JR_NOT_CONTRACT";
3486     string private constant ERROR_INVALID_ZERO_AMOUNT = "JR_INVALID_ZERO_AMOUNT";
3487     string private constant ERROR_INVALID_ACTIVATION_AMOUNT = "JR_INVALID_ACTIVATION_AMOUNT";
3488     string private constant ERROR_INVALID_DEACTIVATION_AMOUNT = "JR_INVALID_DEACTIVATION_AMOUNT";
3489     string private constant ERROR_INVALID_LOCKED_AMOUNTS_LENGTH = "JR_INVALID_LOCKED_AMOUNTS_LEN";
3490     string private constant ERROR_INVALID_REWARDED_JURORS_LENGTH = "JR_INVALID_REWARDED_JURORS_LEN";
3491     string private constant ERROR_ACTIVE_BALANCE_BELOW_MIN = "JR_ACTIVE_BALANCE_BELOW_MIN";
3492     string private constant ERROR_NOT_ENOUGH_AVAILABLE_BALANCE = "JR_NOT_ENOUGH_AVAILABLE_BALANCE";
3493     string private constant ERROR_CANNOT_REDUCE_DEACTIVATION_REQUEST = "JR_CANT_REDUCE_DEACTIVATION_REQ";
3494     string private constant ERROR_TOKEN_TRANSFER_FAILED = "JR_TOKEN_TRANSFER_FAILED";
3495     string private constant ERROR_TOKEN_APPROVE_NOT_ALLOWED = "JR_TOKEN_APPROVE_NOT_ALLOWED";
3496     string private constant ERROR_BAD_TOTAL_ACTIVE_BALANCE_LIMIT = "JR_BAD_TOTAL_ACTIVE_BAL_LIMIT";
3497     string private constant ERROR_TOTAL_ACTIVE_BALANCE_EXCEEDED = "JR_TOTAL_ACTIVE_BALANCE_EXCEEDED";
3498     string private constant ERROR_WITHDRAWALS_LOCK = "JR_WITHDRAWALS_LOCK";
3499 
3500     // Address that will be used to burn juror tokens
3501     address internal constant BURN_ACCOUNT = address(0x000000000000000000000000000000000000dEaD);
3502 
3503     // Maximum number of sortition iterations allowed per draft call
3504     uint256 internal constant MAX_DRAFT_ITERATIONS = 10;
3505 
3506     /**
3507     * @dev Jurors have three kind of balances, these are:
3508     *      - active: tokens activated for the Court that can be locked in case the juror is drafted
3509     *      - locked: amount of active tokens that are locked for a draft
3510     *      - available: tokens that are not activated for the Court and can be withdrawn by the juror at any time
3511     *
3512     *      Due to a gas optimization for drafting, the "active" tokens are stored in a `HexSumTree`, while the others
3513     *      are stored in this contract as `lockedBalance` and `availableBalance` respectively. Given that the jurors'
3514     *      active balances cannot be affected during the current Court term, if jurors want to deactivate some of their
3515     *      active tokens, their balance will be updated for the following term, and they won't be allowed to
3516     *      withdraw them until the current term has ended.
3517     *
3518     *      Note that even though jurors balances are stored separately, all the balances are held by this contract.
3519     */
3520     struct Juror {
3521         uint256 id;                                 // Key in the jurors tree used for drafting
3522         uint256 lockedBalance;                      // Maximum amount of tokens that can be slashed based on the juror's drafts
3523         uint256 availableBalance;                   // Available tokens that can be withdrawn at any time
3524         uint64 withdrawalsLockTermId;               // Term ID until which the juror's withdrawals will be locked
3525         DeactivationRequest deactivationRequest;    // Juror's pending deactivation request
3526     }
3527 
3528     /**
3529     * @dev Given that the jurors balances cannot be affected during a Court term, if jurors want to deactivate some
3530     *      of their tokens, the tree will always be updated for the following term, and they won't be able to
3531     *      withdraw the requested amount until the current term has finished. Thus, we need to keep track the term
3532     *      when a token deactivation was requested and its corresponding amount.
3533     */
3534     struct DeactivationRequest {
3535         uint256 amount;                             // Amount requested for deactivation
3536         uint64 availableTermId;                     // Term ID when jurors can withdraw their requested deactivation tokens
3537     }
3538 
3539     /**
3540     * @dev Internal struct to wrap all the params required to perform jurors drafting
3541     */
3542     struct DraftParams {
3543         bytes32 termRandomness;                     // Randomness seed to be used for the draft
3544         uint256 disputeId;                          // ID of the dispute being drafted
3545         uint64 termId;                              // Term ID of the dispute's draft term
3546         uint256 selectedJurors;                     // Number of jurors already selected for the draft
3547         uint256 batchRequestedJurors;               // Number of jurors to be selected in the given batch of the draft
3548         uint256 roundRequestedJurors;               // Total number of jurors requested to be drafted
3549         uint256 draftLockAmount;                    // Amount of tokens to be locked to each drafted juror
3550         uint256 iteration;                          // Sortition iteration number
3551     }
3552 
3553     // Maximum amount of total active balance that can be held in the registry
3554     uint256 internal totalActiveBalanceLimit;
3555 
3556     // Juror ERC20 token
3557     ERC20 internal jurorsToken;
3558 
3559     // Mapping of juror data indexed by address
3560     mapping (address => Juror) internal jurorsByAddress;
3561 
3562     // Mapping of juror addresses indexed by id
3563     mapping (uint256 => address) internal jurorsAddressById;
3564 
3565     // Tree to store jurors active balance by term for the drafting process
3566     HexSumTree.Tree internal tree;
3567 
3568     event JurorActivated(address indexed juror, uint64 fromTermId, uint256 amount, address sender);
3569     event JurorDeactivationRequested(address indexed juror, uint64 availableTermId, uint256 amount);
3570     event JurorDeactivationProcessed(address indexed juror, uint64 availableTermId, uint256 amount, uint64 processedTermId);
3571     event JurorDeactivationUpdated(address indexed juror, uint64 availableTermId, uint256 amount, uint64 updateTermId);
3572     event JurorBalanceLocked(address indexed juror, uint256 amount);
3573     event JurorBalanceUnlocked(address indexed juror, uint256 amount);
3574     event JurorSlashed(address indexed juror, uint256 amount, uint64 effectiveTermId);
3575     event JurorTokensAssigned(address indexed juror, uint256 amount);
3576     event JurorTokensBurned(uint256 amount);
3577     event JurorTokensCollected(address indexed juror, uint256 amount, uint64 effectiveTermId);
3578     event TotalActiveBalanceLimitChanged(uint256 previousTotalActiveBalanceLimit, uint256 currentTotalActiveBalanceLimit);
3579 
3580     /**
3581     * @dev Constructor function
3582     * @param _controller Address of the controller
3583     * @param _jurorToken Address of the ERC20 token to be used as juror token for the registry
3584     * @param _totalActiveBalanceLimit Maximum amount of total active balance that can be held in the registry
3585     */
3586     constructor(Controller _controller, ERC20 _jurorToken, uint256 _totalActiveBalanceLimit)
3587         ControlledRecoverable(_controller)
3588         public
3589     {
3590         // No need to explicitly call `Controlled` constructor since `ControlledRecoverable` is already doing it
3591         require(isContract(address(_jurorToken)), ERROR_NOT_CONTRACT);
3592 
3593         jurorsToken = _jurorToken;
3594         _setTotalActiveBalanceLimit(_totalActiveBalanceLimit);
3595 
3596         tree.init();
3597         // First tree item is an empty juror
3598         assert(tree.insert(0, 0) == 0);
3599     }
3600 
3601     /**
3602     * @notice Activate `_amount == 0 ? 'all available tokens' : @tokenAmount(self.token(), _amount)` for the next term
3603     * @param _amount Amount of juror tokens to be activated for the next term
3604     */
3605     function activate(uint256 _amount) external {
3606         _activateTokens(msg.sender, _amount, msg.sender);
3607     }
3608 
3609     /**
3610     * @notice Deactivate `_amount == 0 ? 'all unlocked tokens' : @tokenAmount(self.token(), _amount)` for the next term
3611     * @param _amount Amount of juror tokens to be deactivated for the next term
3612     */
3613     function deactivate(uint256 _amount) external {
3614         uint64 termId = _ensureCurrentTerm();
3615         Juror storage juror = jurorsByAddress[msg.sender];
3616         uint256 unlockedActiveBalance = _lastUnlockedActiveBalanceOf(juror);
3617         uint256 amountToDeactivate = _amount == 0 ? unlockedActiveBalance : _amount;
3618         require(amountToDeactivate > 0, ERROR_INVALID_ZERO_AMOUNT);
3619         require(amountToDeactivate <= unlockedActiveBalance, ERROR_INVALID_DEACTIVATION_AMOUNT);
3620 
3621         // No need for SafeMath: we already checked values above
3622         uint256 futureActiveBalance = unlockedActiveBalance - amountToDeactivate;
3623         uint256 minActiveBalance = _getMinActiveBalance(termId);
3624         require(futureActiveBalance == 0 || futureActiveBalance >= minActiveBalance, ERROR_INVALID_DEACTIVATION_AMOUNT);
3625 
3626         _createDeactivationRequest(msg.sender, amountToDeactivate);
3627     }
3628 
3629     /**
3630     * @notice Stake `@tokenAmount(self.token(), _amount)` for the sender to the Court
3631     * @param _amount Amount of tokens to be staked
3632     * @param _data Optional data that can be used to request the activation of the transferred tokens
3633     */
3634     function stake(uint256 _amount, bytes calldata _data) external {
3635         _stake(msg.sender, msg.sender, _amount, _data);
3636     }
3637 
3638     /**
3639     * @notice Stake `@tokenAmount(self.token(), _amount)` for `_to` to the Court
3640     * @param _to Address to stake an amount of tokens to
3641     * @param _amount Amount of tokens to be staked
3642     * @param _data Optional data that can be used to request the activation of the transferred tokens
3643     */
3644     function stakeFor(address _to, uint256 _amount, bytes calldata _data) external {
3645         _stake(msg.sender, _to, _amount, _data);
3646     }
3647 
3648     /**
3649     * @notice Unstake `@tokenAmount(self.token(), _amount)` for `_to` from the Court
3650     * @param _amount Amount of tokens to be unstaked
3651     * @param _data Optional data is never used by this function, only logged
3652     */
3653     function unstake(uint256 _amount, bytes calldata _data) external {
3654         _unstake(msg.sender, _amount, _data);
3655     }
3656 
3657     /**
3658     * @dev Callback of approveAndCall, allows staking directly with a transaction to the token contract.
3659     * @param _from Address making the transfer
3660     * @param _amount Amount of tokens to transfer
3661     * @param _token Address of the token
3662     * @param _data Optional data that can be used to request the activation of the transferred tokens
3663     */
3664     function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata _data) external {
3665         require(msg.sender == _token && _token == address(jurorsToken), ERROR_TOKEN_APPROVE_NOT_ALLOWED);
3666         _stake(_from, _from, _amount, _data);
3667     }
3668 
3669     /**
3670     * @notice Process a token deactivation requested for `_juror` if there is any
3671     * @param _juror Address of the juror to process the deactivation request of
3672     */
3673     function processDeactivationRequest(address _juror) external {
3674         uint64 termId = _ensureCurrentTerm();
3675         _processDeactivationRequest(_juror, termId);
3676     }
3677 
3678     /**
3679     * @notice Assign `@tokenAmount(self.token(), _amount)` to the available balance of `_juror`
3680     * @param _juror Juror to add an amount of tokens to
3681     * @param _amount Amount of tokens to be added to the available balance of a juror
3682     */
3683     function assignTokens(address _juror, uint256 _amount) external onlyDisputeManager {
3684         if (_amount > 0) {
3685             _updateAvailableBalanceOf(_juror, _amount, true);
3686             emit JurorTokensAssigned(_juror, _amount);
3687         }
3688     }
3689 
3690     /**
3691     * @notice Burn `@tokenAmount(self.token(), _amount)`
3692     * @param _amount Amount of tokens to be burned
3693     */
3694     function burnTokens(uint256 _amount) external onlyDisputeManager {
3695         if (_amount > 0) {
3696             _updateAvailableBalanceOf(BURN_ACCOUNT, _amount, true);
3697             emit JurorTokensBurned(_amount);
3698         }
3699     }
3700 
3701     /**
3702     * @notice Draft a set of jurors based on given requirements for a term id
3703     * @param _params Array containing draft requirements:
3704     *        0. bytes32 Term randomness
3705     *        1. uint256 Dispute id
3706     *        2. uint64  Current term id
3707     *        3. uint256 Number of seats already filled
3708     *        4. uint256 Number of seats left to be filled
3709     *        5. uint64  Number of jurors required for the draft
3710     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
3711     *
3712     * @return jurors List of jurors selected for the draft
3713     * @return length Size of the list of the draft result
3714     */
3715     function draft(uint256[7] calldata _params) external onlyDisputeManager returns (address[] memory jurors, uint256 length) {
3716         DraftParams memory draftParams = _buildDraftParams(_params);
3717         jurors = new address[](draftParams.batchRequestedJurors);
3718 
3719         // Jurors returned by the tree multi-sortition may not have enough unlocked active balance to be drafted. Thus,
3720         // we compute several sortitions until all the requested jurors are selected. To guarantee a different set of
3721         // jurors on each sortition, the iteration number will be part of the random seed to be used in the sortition.
3722         // Note that we are capping the number of iterations to avoid an OOG error, which means that this function could
3723         // return less jurors than the requested number.
3724 
3725         for (draftParams.iteration = 0;
3726              length < draftParams.batchRequestedJurors && draftParams.iteration < MAX_DRAFT_ITERATIONS;
3727              draftParams.iteration++
3728         ) {
3729             (uint256[] memory jurorIds, uint256[] memory activeBalances) = _treeSearch(draftParams);
3730 
3731             for (uint256 i = 0; i < jurorIds.length && length < draftParams.batchRequestedJurors; i++) {
3732                 // We assume the selected jurors are registered in the registry, we are not checking their addresses exist
3733                 address jurorAddress = jurorsAddressById[jurorIds[i]];
3734                 Juror storage juror = jurorsByAddress[jurorAddress];
3735 
3736                 // Compute new locked balance for a juror based on the penalty applied when being drafted
3737                 uint256 newLockedBalance = juror.lockedBalance.add(draftParams.draftLockAmount);
3738 
3739                 // Check if there is any deactivation requests for the next term. Drafts are always computed for the current term
3740                 // but we have to make sure we are locking an amount that will exist in the next term.
3741                 uint256 nextTermDeactivationRequestAmount = _deactivationRequestedAmountForTerm(juror, draftParams.termId + 1);
3742 
3743                 // Check if juror has enough active tokens to lock the requested amount for the draft, skip it otherwise.
3744                 uint256 currentActiveBalance = activeBalances[i];
3745                 if (currentActiveBalance >= newLockedBalance) {
3746 
3747                     // Check if the amount of active tokens for the next term is enough to lock the required amount for
3748                     // the draft. Otherwise, reduce the requested deactivation amount of the next term.
3749                     // Next term deactivation amount should always be less than current active balance, but we make sure using SafeMath
3750                     uint256 nextTermActiveBalance = currentActiveBalance.sub(nextTermDeactivationRequestAmount);
3751                     if (nextTermActiveBalance < newLockedBalance) {
3752                         // No need for SafeMath: we already checked values above
3753                         _reduceDeactivationRequest(jurorAddress, newLockedBalance - nextTermActiveBalance, draftParams.termId);
3754                     }
3755 
3756                     // Update the current active locked balance of the juror
3757                     juror.lockedBalance = newLockedBalance;
3758                     jurors[length++] = jurorAddress;
3759                     emit JurorBalanceLocked(jurorAddress, draftParams.draftLockAmount);
3760                 }
3761             }
3762         }
3763     }
3764 
3765     /**
3766     * @notice Slash a set of jurors based on their votes compared to the winning ruling. This function will unlock the
3767     *         corresponding locked balances of those jurors that are set to be slashed.
3768     * @param _termId Current term id
3769     * @param _jurors List of juror addresses to be slashed
3770     * @param _lockedAmounts List of amounts locked for each corresponding juror that will be either slashed or returned
3771     * @param _rewardedJurors List of booleans to tell whether a juror's active balance has to be slashed or not
3772     * @return Total amount of slashed tokens
3773     */
3774     function slashOrUnlock(uint64 _termId, address[] calldata _jurors, uint256[] calldata _lockedAmounts, bool[] calldata _rewardedJurors)
3775         external
3776         onlyDisputeManager
3777         returns (uint256)
3778     {
3779         require(_jurors.length == _lockedAmounts.length, ERROR_INVALID_LOCKED_AMOUNTS_LENGTH);
3780         require(_jurors.length == _rewardedJurors.length, ERROR_INVALID_REWARDED_JURORS_LENGTH);
3781 
3782         uint64 nextTermId = _termId + 1;
3783         uint256 collectedTokens;
3784 
3785         for (uint256 i = 0; i < _jurors.length; i++) {
3786             uint256 lockedAmount = _lockedAmounts[i];
3787             address jurorAddress = _jurors[i];
3788             Juror storage juror = jurorsByAddress[jurorAddress];
3789             juror.lockedBalance = juror.lockedBalance.sub(lockedAmount);
3790 
3791             // Slash juror if requested. Note that there's no need to check if there was a deactivation
3792             // request since we're working with already locked balances.
3793             if (_rewardedJurors[i]) {
3794                 emit JurorBalanceUnlocked(jurorAddress, lockedAmount);
3795             } else {
3796                 collectedTokens = collectedTokens.add(lockedAmount);
3797                 tree.update(juror.id, nextTermId, lockedAmount, false);
3798                 emit JurorSlashed(jurorAddress, lockedAmount, nextTermId);
3799             }
3800         }
3801 
3802         return collectedTokens;
3803     }
3804 
3805     /**
3806     * @notice Try to collect `@tokenAmount(self.token(), _amount)` from `_juror` for the term #`_termId + 1`.
3807     * @dev This function tries to decrease the active balance of a juror for the next term based on the requested
3808     *      amount. It can be seen as a way to early-slash a juror's active balance.
3809     * @param _juror Juror to collect the tokens from
3810     * @param _amount Amount of tokens to be collected from the given juror and for the requested term id
3811     * @param _termId Current term id
3812     * @return True if the juror has enough unlocked tokens to be collected for the requested term, false otherwise
3813     */
3814     function collectTokens(address _juror, uint256 _amount, uint64 _termId) external onlyDisputeManager returns (bool) {
3815         if (_amount == 0) {
3816             return true;
3817         }
3818 
3819         uint64 nextTermId = _termId + 1;
3820         Juror storage juror = jurorsByAddress[_juror];
3821         uint256 unlockedActiveBalance = _lastUnlockedActiveBalanceOf(juror);
3822         uint256 nextTermDeactivationRequestAmount = _deactivationRequestedAmountForTerm(juror, nextTermId);
3823 
3824         // Check if the juror has enough unlocked tokens to collect the requested amount
3825         // Note that we're also considering the deactivation request if there is any
3826         uint256 totalUnlockedActiveBalance = unlockedActiveBalance.add(nextTermDeactivationRequestAmount);
3827         if (_amount > totalUnlockedActiveBalance) {
3828             return false;
3829         }
3830 
3831         // Check if the amount of active tokens is enough to collect the requested amount, otherwise reduce the requested deactivation amount of
3832         // the next term. Note that this behaviour is different to the one when drafting jurors since this function is called as a side effect
3833         // of a juror deliberately voting in a final round, while drafts occur randomly.
3834         if (_amount > unlockedActiveBalance) {
3835             // No need for SafeMath: amounts were already checked above
3836             uint256 amountToReduce = _amount - unlockedActiveBalance;
3837             _reduceDeactivationRequest(_juror, amountToReduce, _termId);
3838         }
3839         tree.update(juror.id, nextTermId, _amount, false);
3840 
3841         emit JurorTokensCollected(_juror, _amount, nextTermId);
3842         return true;
3843     }
3844 
3845     /**
3846     * @notice Lock `_juror`'s withdrawals until term #`_termId`
3847     * @dev This is intended for jurors who voted in a final round and were coherent with the final ruling to prevent 51% attacks
3848     * @param _juror Address of the juror to be locked
3849     * @param _termId Term ID until which the juror's withdrawals will be locked
3850     */
3851     function lockWithdrawals(address _juror, uint64 _termId) external onlyDisputeManager {
3852         Juror storage juror = jurorsByAddress[_juror];
3853         juror.withdrawalsLockTermId = _termId;
3854     }
3855 
3856     /**
3857     * @notice Set new limit of total active balance of juror tokens
3858     * @param _totalActiveBalanceLimit New limit of total active balance of juror tokens
3859     */
3860     function setTotalActiveBalanceLimit(uint256 _totalActiveBalanceLimit) external onlyConfigGovernor {
3861         _setTotalActiveBalanceLimit(_totalActiveBalanceLimit);
3862     }
3863 
3864     /**
3865     * @dev ERC900 - Tell the address of the token used for staking
3866     * @return Address of the token used for staking
3867     */
3868     function token() external view returns (address) {
3869         return address(jurorsToken);
3870     }
3871 
3872     /**
3873     * @dev ERC900 - Tell the total amount of juror tokens held by the registry contract
3874     * @return Amount of juror tokens held by the registry contract
3875     */
3876     function totalStaked() external view returns (uint256) {
3877         return jurorsToken.balanceOf(address(this));
3878     }
3879 
3880     /**
3881     * @dev Tell the total amount of active juror tokens
3882     * @return Total amount of active juror tokens
3883     */
3884     function totalActiveBalance() external view returns (uint256) {
3885         return tree.getTotal();
3886     }
3887 
3888     /**
3889     * @dev Tell the total amount of active juror tokens at the given term id
3890     * @param _termId Term ID querying the total active balance for
3891     * @return Total amount of active juror tokens at the given term id
3892     */
3893     function totalActiveBalanceAt(uint64 _termId) external view returns (uint256) {
3894         return _totalActiveBalanceAt(_termId);
3895     }
3896 
3897     /**
3898     * @dev ERC900 - Tell the total amount of tokens of juror. This includes the active balance, the available
3899     *      balances, and the pending balance for deactivation. Note that we don't have to include the locked
3900     *      balances since these represent the amount of active tokens that are locked for drafts, i.e. these
3901     *      are included in the active balance of the juror.
3902     * @param _juror Address of the juror querying the total amount of tokens staked of
3903     * @return Total amount of tokens of a juror
3904     */
3905     function totalStakedFor(address _juror) external view returns (uint256) {
3906         return _totalStakedFor(_juror);
3907     }
3908 
3909     /**
3910     * @dev Tell the balance information of a juror
3911     * @param _juror Address of the juror querying the balance information of
3912     * @return active Amount of active tokens of a juror
3913     * @return available Amount of available tokens of a juror
3914     * @return locked Amount of active tokens that are locked due to ongoing disputes
3915     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
3916     */
3917     function balanceOf(address _juror) external view returns (uint256 active, uint256 available, uint256 locked, uint256 pendingDeactivation) {
3918         return _balanceOf(_juror);
3919     }
3920 
3921     /**
3922     * @dev Tell the balance information of a juror, fecthing tree one at a given term
3923     * @param _juror Address of the juror querying the balance information of
3924     * @param _termId Term ID querying the active balance for
3925     * @return active Amount of active tokens of a juror
3926     * @return available Amount of available tokens of a juror
3927     * @return locked Amount of active tokens that are locked due to ongoing disputes
3928     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
3929     */
3930     function balanceOfAt(address _juror, uint64 _termId) external view
3931         returns (uint256 active, uint256 available, uint256 locked, uint256 pendingDeactivation)
3932     {
3933         Juror storage juror = jurorsByAddress[_juror];
3934 
3935         active = _existsJuror(juror) ? tree.getItemAt(juror.id, _termId) : 0;
3936         (available, locked, pendingDeactivation) = _getBalances(juror);
3937     }
3938 
3939     /**
3940     * @dev Tell the active balance of a juror for a given term id
3941     * @param _juror Address of the juror querying the active balance of
3942     * @param _termId Term ID querying the active balance for
3943     * @return Amount of active tokens for juror in the requested past term id
3944     */
3945     function activeBalanceOfAt(address _juror, uint64 _termId) external view returns (uint256) {
3946         return _activeBalanceOfAt(_juror, _termId);
3947     }
3948 
3949     /**
3950     * @dev Tell the amount of active tokens of a juror at the last ensured term that are not locked due to ongoing disputes
3951     * @param _juror Address of the juror querying the unlocked balance of
3952     * @return Amount of active tokens of a juror that are not locked due to ongoing disputes
3953     */
3954     function unlockedActiveBalanceOf(address _juror) external view returns (uint256) {
3955         Juror storage juror = jurorsByAddress[_juror];
3956         return _currentUnlockedActiveBalanceOf(juror);
3957     }
3958 
3959     /**
3960     * @dev Tell the pending deactivation details for a juror
3961     * @param _juror Address of the juror whose info is requested
3962     * @return amount Amount to be deactivated
3963     * @return availableTermId Term in which the deactivated amount will be available
3964     */
3965     function getDeactivationRequest(address _juror) external view returns (uint256 amount, uint64 availableTermId) {
3966         DeactivationRequest storage request = jurorsByAddress[_juror].deactivationRequest;
3967         return (request.amount, request.availableTermId);
3968     }
3969 
3970     /**
3971     * @dev Tell the withdrawals lock term ID for a juror
3972     * @param _juror Address of the juror whose info is requested
3973     * @return Term ID until which the juror's withdrawals will be locked
3974     */
3975     function getWithdrawalsLockTermId(address _juror) external view returns (uint64) {
3976         return jurorsByAddress[_juror].withdrawalsLockTermId;
3977     }
3978 
3979     /**
3980     * @dev Tell the identification number associated to a juror address
3981     * @param _juror Address of the juror querying the identification number of
3982     * @return Identification number associated to a juror address, zero in case it wasn't registered yet
3983     */
3984     function getJurorId(address _juror) external view returns (uint256) {
3985         return jurorsByAddress[_juror].id;
3986     }
3987 
3988     /**
3989     * @dev Tell the maximum amount of total active balance that can be held in the registry
3990     * @return Maximum amount of total active balance that can be held in the registry
3991     */
3992     function totalJurorsActiveBalanceLimit() external view returns (uint256) {
3993         return totalActiveBalanceLimit;
3994     }
3995 
3996     /**
3997     * @dev ERC900 - Tell if the current registry supports historic information or not
3998     * @return Always false
3999     */
4000     function supportsHistory() external pure returns (bool) {
4001         return false;
4002     }
4003 
4004     /**
4005     * @dev Internal function to activate a given amount of tokens for a juror.
4006     *      This function assumes that the given term is the current term and has already been ensured.
4007     * @param _juror Address of the juror to activate tokens
4008     * @param _amount Amount of juror tokens to be activated
4009     * @param _sender Address of the account requesting the activation
4010     */
4011     function _activateTokens(address _juror, uint256 _amount, address _sender) internal {
4012         uint64 termId = _ensureCurrentTerm();
4013 
4014         // Try to clean a previous deactivation request if any
4015         _processDeactivationRequest(_juror, termId);
4016 
4017         uint256 availableBalance = jurorsByAddress[_juror].availableBalance;
4018         uint256 amountToActivate = _amount == 0 ? availableBalance : _amount;
4019         require(amountToActivate > 0, ERROR_INVALID_ZERO_AMOUNT);
4020         require(amountToActivate <= availableBalance, ERROR_INVALID_ACTIVATION_AMOUNT);
4021 
4022         uint64 nextTermId = termId + 1;
4023         _checkTotalActiveBalance(nextTermId, amountToActivate);
4024         Juror storage juror = jurorsByAddress[_juror];
4025         uint256 minActiveBalance = _getMinActiveBalance(nextTermId);
4026 
4027         if (_existsJuror(juror)) {
4028             // Even though we are adding amounts, let's check the new active balance is greater than or equal to the
4029             // minimum active amount. Note that the juror might have been slashed.
4030             uint256 activeBalance = tree.getItem(juror.id);
4031             require(activeBalance.add(amountToActivate) >= minActiveBalance, ERROR_ACTIVE_BALANCE_BELOW_MIN);
4032             tree.update(juror.id, nextTermId, amountToActivate, true);
4033         } else {
4034             require(amountToActivate >= minActiveBalance, ERROR_ACTIVE_BALANCE_BELOW_MIN);
4035             juror.id = tree.insert(nextTermId, amountToActivate);
4036             jurorsAddressById[juror.id] = _juror;
4037         }
4038 
4039         _updateAvailableBalanceOf(_juror, amountToActivate, false);
4040         emit JurorActivated(_juror, nextTermId, amountToActivate, _sender);
4041     }
4042 
4043     /**
4044     * @dev Internal function to create a token deactivation request for a juror. Jurors will be allowed
4045     *      to process a deactivation request from the next term.
4046     * @param _juror Address of the juror to create a token deactivation request for
4047     * @param _amount Amount of juror tokens requested for deactivation
4048     */
4049     function _createDeactivationRequest(address _juror, uint256 _amount) internal {
4050         uint64 termId = _ensureCurrentTerm();
4051 
4052         // Try to clean a previous deactivation request if possible
4053         _processDeactivationRequest(_juror, termId);
4054 
4055         uint64 nextTermId = termId + 1;
4056         Juror storage juror = jurorsByAddress[_juror];
4057         DeactivationRequest storage request = juror.deactivationRequest;
4058         request.amount = request.amount.add(_amount);
4059         request.availableTermId = nextTermId;
4060         tree.update(juror.id, nextTermId, _amount, false);
4061 
4062         emit JurorDeactivationRequested(_juror, nextTermId, _amount);
4063     }
4064 
4065     /**
4066     * @dev Internal function to process a token deactivation requested by a juror. It will move the requested amount
4067     *      to the available balance of the juror if the term when the deactivation was requested has already finished.
4068     * @param _juror Address of the juror to process the deactivation request of
4069     * @param _termId Current term id
4070     */
4071     function _processDeactivationRequest(address _juror, uint64 _termId) internal {
4072         Juror storage juror = jurorsByAddress[_juror];
4073         DeactivationRequest storage request = juror.deactivationRequest;
4074         uint64 deactivationAvailableTermId = request.availableTermId;
4075 
4076         // If there is a deactivation request, ensure that the deactivation term has been reached
4077         if (deactivationAvailableTermId == uint64(0) || _termId < deactivationAvailableTermId) {
4078             return;
4079         }
4080 
4081         uint256 deactivationAmount = request.amount;
4082         // Note that we can use a zeroed term ID to denote void here since we are storing
4083         // the minimum allowed term to deactivate tokens which will always be at least 1.
4084         request.availableTermId = uint64(0);
4085         request.amount = 0;
4086         _updateAvailableBalanceOf(_juror, deactivationAmount, true);
4087 
4088         emit JurorDeactivationProcessed(_juror, deactivationAvailableTermId, deactivationAmount, _termId);
4089     }
4090 
4091     /**
4092     * @dev Internal function to reduce a token deactivation requested by a juror. It assumes the deactivation request
4093     *      cannot be processed for the given term yet.
4094     * @param _juror Address of the juror to reduce the deactivation request of
4095     * @param _amount Amount to be reduced from the current deactivation request
4096     * @param _termId Term ID in which the deactivation request is being reduced
4097     */
4098     function _reduceDeactivationRequest(address _juror, uint256 _amount, uint64 _termId) internal {
4099         Juror storage juror = jurorsByAddress[_juror];
4100         DeactivationRequest storage request = juror.deactivationRequest;
4101         uint256 currentRequestAmount = request.amount;
4102         require(currentRequestAmount >= _amount, ERROR_CANNOT_REDUCE_DEACTIVATION_REQUEST);
4103 
4104         // No need for SafeMath: we already checked values above
4105         uint256 newRequestAmount = currentRequestAmount - _amount;
4106         request.amount = newRequestAmount;
4107 
4108         // Move amount back to the tree
4109         tree.update(juror.id, _termId + 1, _amount, true);
4110 
4111         emit JurorDeactivationUpdated(_juror, request.availableTermId, newRequestAmount, _termId);
4112     }
4113 
4114     /**
4115     * @dev Internal function to stake an amount of tokens for a juror
4116     * @param _from Address sending the amount of tokens to be deposited
4117     * @param _juror Address of the juror to deposit the tokens to
4118     * @param _amount Amount of tokens to be deposited
4119     * @param _data Optional data that can be used to request the activation of the deposited tokens
4120     */
4121     function _stake(address _from, address _juror, uint256 _amount, bytes memory _data) internal {
4122         require(_amount > 0, ERROR_INVALID_ZERO_AMOUNT);
4123         _updateAvailableBalanceOf(_juror, _amount, true);
4124 
4125         // Activate tokens if it was requested by the sender. Note that there's no need to check
4126         // the activation amount since we have just added it to the available balance of the juror.
4127         if (_data.toBytes4() == JurorsRegistry(this).activate.selector) {
4128             _activateTokens(_juror, _amount, _from);
4129         }
4130 
4131         emit Staked(_juror, _amount, _totalStakedFor(_juror), _data);
4132         require(jurorsToken.safeTransferFrom(_from, address(this), _amount), ERROR_TOKEN_TRANSFER_FAILED);
4133     }
4134 
4135     /**
4136     * @dev Internal function to unstake an amount of tokens of a juror
4137     * @param _juror Address of the juror to to unstake the tokens of
4138     * @param _amount Amount of tokens to be unstaked
4139     * @param _data Optional data is never used by this function, only logged
4140     */
4141     function _unstake(address _juror, uint256 _amount, bytes memory _data) internal {
4142         require(_amount > 0, ERROR_INVALID_ZERO_AMOUNT);
4143 
4144         // Try to process a deactivation request for the current term if there is one. Note that we don't need to ensure
4145         // the current term this time since deactivation requests always work with future terms, which means that if
4146         // the current term is outdated, it will never match the deactivation term id. We avoid ensuring the term here
4147         // to avoid forcing jurors to do that in order to withdraw their available balance. Same applies to final round locks.
4148         uint64 lastEnsuredTermId = _getLastEnsuredTermId();
4149 
4150         // Check that juror's withdrawals are not locked
4151         uint64 withdrawalsLockTermId = jurorsByAddress[_juror].withdrawalsLockTermId;
4152         require(withdrawalsLockTermId == 0 || withdrawalsLockTermId < lastEnsuredTermId, ERROR_WITHDRAWALS_LOCK);
4153 
4154         _processDeactivationRequest(_juror, lastEnsuredTermId);
4155 
4156         _updateAvailableBalanceOf(_juror, _amount, false);
4157         emit Unstaked(_juror, _amount, _totalStakedFor(_juror), _data);
4158         require(jurorsToken.safeTransfer(_juror, _amount), ERROR_TOKEN_TRANSFER_FAILED);
4159     }
4160 
4161     /**
4162     * @dev Internal function to update the available balance of a juror
4163     * @param _juror Juror to update the available balance of
4164     * @param _amount Amount of tokens to be added to or removed from the available balance of a juror
4165     * @param _positive True if the given amount should be added, or false to remove it from the available balance
4166     */
4167     function _updateAvailableBalanceOf(address _juror, uint256 _amount, bool _positive) internal {
4168         // We are not using a require here to avoid reverting in case any of the treasury maths reaches this point
4169         // with a zeroed amount value. Instead, we are doing this validation in the external entry points such as
4170         // stake, unstake, activate, deactivate, among others.
4171         if (_amount == 0) {
4172             return;
4173         }
4174 
4175         Juror storage juror = jurorsByAddress[_juror];
4176         if (_positive) {
4177             juror.availableBalance = juror.availableBalance.add(_amount);
4178         } else {
4179             require(_amount <= juror.availableBalance, ERROR_NOT_ENOUGH_AVAILABLE_BALANCE);
4180             // No need for SafeMath: we already checked values right above
4181             juror.availableBalance -= _amount;
4182         }
4183     }
4184 
4185     /**
4186     * @dev Internal function to set new limit of total active balance of juror tokens
4187     * @param _totalActiveBalanceLimit New limit of total active balance of juror tokens
4188     */
4189     function _setTotalActiveBalanceLimit(uint256 _totalActiveBalanceLimit) internal {
4190         require(_totalActiveBalanceLimit > 0, ERROR_BAD_TOTAL_ACTIVE_BALANCE_LIMIT);
4191         emit TotalActiveBalanceLimitChanged(totalActiveBalanceLimit, _totalActiveBalanceLimit);
4192         totalActiveBalanceLimit = _totalActiveBalanceLimit;
4193     }
4194 
4195     /**
4196     * @dev Internal function to tell the total amount of tokens of juror
4197     * @param _juror Address of the juror querying the total amount of tokens staked of
4198     * @return Total amount of tokens of a juror
4199     */
4200     function _totalStakedFor(address _juror) internal view returns (uint256) {
4201         (uint256 active, uint256 available, , uint256 pendingDeactivation) = _balanceOf(_juror);
4202         return available.add(active).add(pendingDeactivation);
4203     }
4204 
4205     /**
4206     * @dev Internal function to tell the balance information of a juror
4207     * @param _juror Address of the juror querying the balance information of
4208     * @return active Amount of active tokens of a juror
4209     * @return available Amount of available tokens of a juror
4210     * @return locked Amount of active tokens that are locked due to ongoing disputes
4211     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
4212     */
4213     function _balanceOf(address _juror) internal view returns (uint256 active, uint256 available, uint256 locked, uint256 pendingDeactivation) {
4214         Juror storage juror = jurorsByAddress[_juror];
4215 
4216         active = _existsJuror(juror) ? tree.getItem(juror.id) : 0;
4217         (available, locked, pendingDeactivation) = _getBalances(juror);
4218     }
4219 
4220     /**
4221     * @dev Tell the active balance of a juror for a given term id
4222     * @param _juror Address of the juror querying the active balance of
4223     * @param _termId Term ID querying the active balance for
4224     * @return Amount of active tokens for juror in the requested past term id
4225     */
4226     function _activeBalanceOfAt(address _juror, uint64 _termId) internal view returns (uint256) {
4227         Juror storage juror = jurorsByAddress[_juror];
4228         return _existsJuror(juror) ? tree.getItemAt(juror.id, _termId) : 0;
4229     }
4230 
4231     /**
4232     * @dev Internal function to get the amount of active tokens of a juror that are not locked due to ongoing disputes
4233     *      It will use the last value, that might be in a future term
4234     * @param _juror Juror querying the unlocked active balance of
4235     * @return Amount of active tokens of a juror that are not locked due to ongoing disputes
4236     */
4237     function _lastUnlockedActiveBalanceOf(Juror storage _juror) internal view returns (uint256) {
4238         return _existsJuror(_juror) ? tree.getItem(_juror.id).sub(_juror.lockedBalance) : 0;
4239     }
4240 
4241     /**
4242     * @dev Internal function to get the amount of active tokens at the last ensured term of a juror that are not locked due to ongoing disputes
4243     * @param _juror Juror querying the unlocked active balance of
4244     * @return Amount of active tokens of a juror that are not locked due to ongoing disputes
4245     */
4246     function _currentUnlockedActiveBalanceOf(Juror storage _juror) internal view returns (uint256) {
4247         uint64 lastEnsuredTermId = _getLastEnsuredTermId();
4248         return _existsJuror(_juror) ? tree.getItemAt(_juror.id, lastEnsuredTermId).sub(_juror.lockedBalance) : 0;
4249     }
4250 
4251     /**
4252     * @dev Internal function to check if a juror was already registered
4253     * @param _juror Juror to be checked
4254     * @return True if the given juror was already registered, false otherwise
4255     */
4256     function _existsJuror(Juror storage _juror) internal view returns (bool) {
4257         return _juror.id != 0;
4258     }
4259 
4260     /**
4261     * @dev Internal function to get the amount of a deactivation request for a given term id
4262     * @param _juror Juror to query the deactivation request amount of
4263     * @param _termId Term ID of the deactivation request to be queried
4264     * @return Amount of the deactivation request for the given term, 0 otherwise
4265     */
4266     function _deactivationRequestedAmountForTerm(Juror storage _juror, uint64 _termId) internal view returns (uint256) {
4267         DeactivationRequest storage request = _juror.deactivationRequest;
4268         return request.availableTermId == _termId ? request.amount : 0;
4269     }
4270 
4271     /**
4272     * @dev Internal function to tell the total amount of active juror tokens at the given term id
4273     * @param _termId Term ID querying the total active balance for
4274     * @return Total amount of active juror tokens at the given term id
4275     */
4276     function _totalActiveBalanceAt(uint64 _termId) internal view returns (uint256) {
4277         // This function will return always the same values, the only difference remains on gas costs. In case we look for a
4278         // recent term, in this case current or future ones, we perform a backwards linear search from the last checkpoint.
4279         // Otherwise, a binary search is computed.
4280         bool recent = _termId >= _getLastEnsuredTermId();
4281         return recent ? tree.getRecentTotalAt(_termId) : tree.getTotalAt(_termId);
4282     }
4283 
4284     /**
4285     * @dev Internal function to check if its possible to add a given new amount to the registry or not
4286     * @param _termId Term ID when the new amount will be added
4287     * @param _amount Amount of tokens willing to be added to the registry
4288     */
4289     function _checkTotalActiveBalance(uint64 _termId, uint256 _amount) internal view {
4290         uint256 currentTotalActiveBalance = _totalActiveBalanceAt(_termId);
4291         uint256 newTotalActiveBalance = currentTotalActiveBalance.add(_amount);
4292         require(newTotalActiveBalance <= totalActiveBalanceLimit, ERROR_TOTAL_ACTIVE_BALANCE_EXCEEDED);
4293     }
4294 
4295     /**
4296     * @dev Tell the local balance information of a juror (that is not on the tree)
4297     * @param _juror Address of the juror querying the balance information of
4298     * @return available Amount of available tokens of a juror
4299     * @return locked Amount of active tokens that are locked due to ongoing disputes
4300     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
4301     */
4302     function _getBalances(Juror storage _juror) internal view returns (uint256 available, uint256 locked, uint256 pendingDeactivation) {
4303         available = _juror.availableBalance;
4304         locked = _juror.lockedBalance;
4305         pendingDeactivation = _juror.deactivationRequest.amount;
4306     }
4307 
4308     /**
4309     * @dev Internal function to search jurors in the tree based on certain search restrictions
4310     * @param _params Draft params to be used for the jurors search
4311     * @return ids List of juror ids obtained based on the requested search
4312     * @return activeBalances List of active balances for each juror obtained based on the requested search
4313     */
4314     function _treeSearch(DraftParams memory _params) internal view returns (uint256[] memory ids, uint256[] memory activeBalances) {
4315         (ids, activeBalances) = tree.batchedRandomSearch(
4316             _params.termRandomness,
4317             _params.disputeId,
4318             _params.termId,
4319             _params.selectedJurors,
4320             _params.batchRequestedJurors,
4321             _params.roundRequestedJurors,
4322             _params.iteration
4323         );
4324     }
4325 
4326     /**
4327     * @dev Private function to parse a certain set given of draft params
4328     * @param _params Array containing draft requirements:
4329     *        0. bytes32 Term randomness
4330     *        1. uint256 Dispute id
4331     *        2. uint64  Current term id
4332     *        3. uint256 Number of seats already filled
4333     *        4. uint256 Number of seats left to be filled
4334     *        5. uint64  Number of jurors required for the draft
4335     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
4336     *
4337     * @return Draft params object parsed
4338     */
4339     function _buildDraftParams(uint256[7] memory _params) private view returns (DraftParams memory) {
4340         uint64 termId = uint64(_params[2]);
4341         uint256 minActiveBalance = _getMinActiveBalance(termId);
4342 
4343         return DraftParams({
4344             termRandomness: bytes32(_params[0]),
4345             disputeId: _params[1],
4346             termId: termId,
4347             selectedJurors: _params[3],
4348             batchRequestedJurors: _params[4],
4349             roundRequestedJurors: _params[5],
4350             draftLockAmount: minActiveBalance.pct(uint16(_params[6])),
4351             iteration: 0
4352         });
4353     }
4354 }