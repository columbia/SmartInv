1 pragma solidity ^0.5.17;
2 
3 
4 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath.sol
5 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that revert on error
9  */
10 library SafeMath {
11     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
12     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
13     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
14     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
15 
16     /**
17     * @dev Multiplies two numbers, reverts on overflow.
18     */
19     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (_a == 0) {
24             return 0;
25         }
26 
27         uint256 c = _a * _b;
28         require(c / _a == _b, ERROR_MUL_OVERFLOW);
29 
30         return c;
31     }
32 
33     /**
34     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
35     */
36     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
37         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
38         uint256 c = _a / _b;
39         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
40 
41         return c;
42     }
43 
44     /**
45     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         require(_b <= _a, ERROR_SUB_UNDERFLOW);
49         uint256 c = _a - _b;
50 
51         return c;
52     }
53 
54     /**
55     * @dev Adds two numbers, reverts on overflow.
56     */
57     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
58         uint256 c = _a + _b;
59         require(c >= _a, ERROR_ADD_OVERFLOW);
60 
61         return c;
62     }
63 
64     /**
65     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
66     * reverts when dividing by zero.
67     */
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0, ERROR_DIV_ZERO);
70         return a % b;
71     }
72 }
73 
74 /*
75  * SPDX-License-Identifier:    MIT
76  */
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract IERC20 {
82     event Transfer(address indexed from, address indexed to, uint256 value);
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 
85     function totalSupply() external view returns (uint256);
86 
87     function balanceOf(address _who) external view returns (uint256);
88 
89     function allowance(address _owner, address _spender) external view returns (uint256);
90 
91     function transfer(address _to, uint256 _value) external returns (bool);
92 
93     function approve(address _spender, uint256 _value) external returns (bool);
94 
95     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
96 }
97 
98 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/SafeERC20.sol
99 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
100 library SafeERC20 {
101     /**
102     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
103     *      Note that this makes an external call to the provided token and expects it to be already
104     *      verified as a contract.
105     */
106     function safeTransfer(IERC20 _token, address _to, uint256 _amount) internal returns (bool) {
107         bytes memory transferCallData = abi.encodeWithSelector(
108             _token.transfer.selector,
109             _to,
110             _amount
111         );
112         return invokeAndCheckSuccess(address(_token), transferCallData);
113     }
114 
115     /**
116     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
117     *      Note that this makes an external call to the provided token and expects it to be already
118     *      verified as a contract.
119     */
120     function safeTransferFrom(IERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
121         bytes memory transferFromCallData = abi.encodeWithSelector(
122             _token.transferFrom.selector,
123             _from,
124             _to,
125             _amount
126         );
127         return invokeAndCheckSuccess(address(_token), transferFromCallData);
128     }
129 
130     /**
131     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
132     *      Note that this makes an external call to the provided token and expects it to be already
133     *      verified as a contract.
134     */
135     function safeApprove(IERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
136         bytes memory approveCallData = abi.encodeWithSelector(
137             _token.approve.selector,
138             _spender,
139             _amount
140         );
141         return invokeAndCheckSuccess(address(_token), approveCallData);
142     }
143 
144     function invokeAndCheckSuccess(address _addr, bytes memory _calldata) private returns (bool) {
145         bool ret;
146         assembly {
147             let ptr := mload(0x40)    // free memory pointer
148 
149             let success := call(
150                 gas,                  // forward all gas
151                 _addr,                // address
152                 0,                    // no value
153                 add(_calldata, 0x20), // calldata start
154                 mload(_calldata),     // calldata length
155                 ptr,                  // write output over free memory
156                 0x20                  // uint256 return
157             )
158 
159             if gt(success, 0) {
160             // Check number of bytes returned from last function call
161                 switch returndatasize
162 
163                 // No bytes returned: assume success
164                 case 0 {
165                     ret := 1
166                 }
167 
168                 // 32 bytes returned: check if non-zero
169                 case 0x20 {
170                 // Only return success if returned data was true
171                 // Already have output in ptr
172                     ret := eq(mload(ptr), 1)
173                 }
174 
175                 // Not sure what was returned: don't mark as success
176                 default { }
177             }
178         }
179         return ret;
180     }
181 }
182 
183 library PctHelpers {
184     using SafeMath for uint256;
185 
186     uint256 internal constant PCT_BASE = 10000; // ‱ (1 / 10,000)
187 
188     function isValid(uint16 _pct) internal pure returns (bool) {
189         return _pct <= PCT_BASE;
190     }
191 
192     function pct(uint256 self, uint16 _pct) internal pure returns (uint256) {
193         return self.mul(uint256(_pct)) / PCT_BASE;
194     }
195 
196     function pct256(uint256 self, uint256 _pct) internal pure returns (uint256) {
197         return self.mul(_pct) / PCT_BASE;
198     }
199 
200     function pctIncrease(uint256 self, uint16 _pct) internal pure returns (uint256) {
201         // No need for SafeMath: for addition note that `PCT_BASE` is lower than (2^256 - 2^16)
202         return self.mul(PCT_BASE + uint256(_pct)) / PCT_BASE;
203     }
204 }
205 
206 /**
207 * @title Checkpointing - Library to handle a historic set of numeric values
208 */
209 library Checkpointing {
210     uint256 private constant MAX_UINT192 = uint256(uint192(-1));
211 
212     string private constant ERROR_VALUE_TOO_BIG = "CHECKPOINT_VALUE_TOO_BIG";
213     string private constant ERROR_CANNOT_ADD_PAST_VALUE = "CHECKPOINT_CANNOT_ADD_PAST_VALUE";
214 
215     /**
216     * @dev To specify a value at a given point in time, we need to store two values:
217     *      - `time`: unit-time value to denote the first time when a value was registered
218     *      - `value`: a positive numeric value to registered at a given point in time
219     *
220     *      Note that `time` does not need to refer necessarily to a timestamp value, any time unit could be used
221     *      for it like block numbers, terms, etc.
222     */
223     struct Checkpoint {
224         uint64 time;
225         uint192 value;
226     }
227 
228     /**
229     * @dev A history simply denotes a list of checkpoints
230     */
231     struct History {
232         Checkpoint[] history;
233     }
234 
235     /**
236     * @dev Add a new value to a history for a given point in time. This function does not allow to add values previous
237     *      to the latest registered value, if the value willing to add corresponds to the latest registered value, it
238     *      will be updated.
239     * @param self Checkpoints history to be altered
240     * @param _time Point in time to register the given value
241     * @param _value Numeric value to be registered at the given point in time
242     */
243     function add(History storage self, uint64 _time, uint256 _value) internal {
244         require(_value <= MAX_UINT192, ERROR_VALUE_TOO_BIG);
245         _add192(self, _time, uint192(_value));
246     }
247 
248     /**
249     * @dev Fetch the latest registered value of history, it will return zero if there was no value registered
250     * @param self Checkpoints history to be queried
251     */
252     function getLast(History storage self) internal view returns (uint256) {
253         uint256 length = self.history.length;
254         if (length > 0) {
255             return uint256(self.history[length - 1].value);
256         }
257 
258         return 0;
259     }
260 
261     /**
262     * @dev Fetch the most recent registered past value of a history based on a given point in time that is not known
263     *      how recent it is beforehand. It will return zero if there is no registered value or if given time is
264     *      previous to the first registered value.
265     *      It uses a binary search.
266     * @param self Checkpoints history to be queried
267     * @param _time Point in time to query the most recent registered past value of
268     */
269     function get(History storage self, uint64 _time) internal view returns (uint256) {
270         return _binarySearch(self, _time);
271     }
272 
273     /**
274     * @dev Fetch the most recent registered past value of a history based on a given point in time. It will return zero
275     *      if there is no registered value or if given time is previous to the first registered value.
276     *      It uses a linear search starting from the end.
277     * @param self Checkpoints history to be queried
278     * @param _time Point in time to query the most recent registered past value of
279     */
280     function getRecent(History storage self, uint64 _time) internal view returns (uint256) {
281         return _backwardsLinearSearch(self, _time);
282     }
283 
284     /**
285     * @dev Private function to add a new value to a history for a given point in time. This function does not allow to
286     *      add values previous to the latest registered value, if the value willing to add corresponds to the latest
287     *      registered value, it will be updated.
288     * @param self Checkpoints history to be altered
289     * @param _time Point in time to register the given value
290     * @param _value Numeric value to be registered at the given point in time
291     */
292     function _add192(History storage self, uint64 _time, uint192 _value) private {
293         uint256 length = self.history.length;
294         if (length == 0 || self.history[self.history.length - 1].time < _time) {
295             // If there was no value registered or the given point in time is after the latest registered value,
296             // we can insert it to the history directly.
297             self.history.push(Checkpoint(_time, _value));
298         } else {
299             // If the point in time given for the new value is not after the latest registered value, we must ensure
300             // we are only trying to update the latest value, otherwise we would be changing past data.
301             Checkpoint storage currentCheckpoint = self.history[length - 1];
302             require(_time == currentCheckpoint.time, ERROR_CANNOT_ADD_PAST_VALUE);
303             currentCheckpoint.value = _value;
304         }
305     }
306 
307     /**
308     * @dev Private function to execute a backwards linear search to find the most recent registered past value of a
309     *      history based on a given point in time. It will return zero if there is no registered value or if given time
310     *      is previous to the first registered value. Note that this function will be more suitable when we already know
311     *      that the time used to index the search is recent in the given history.
312     * @param self Checkpoints history to be queried
313     * @param _time Point in time to query the most recent registered past value of
314     */
315     function _backwardsLinearSearch(History storage self, uint64 _time) private view returns (uint256) {
316         // If there was no value registered for the given history return simply zero
317         uint256 length = self.history.length;
318         if (length == 0) {
319             return 0;
320         }
321 
322         uint256 index = length - 1;
323         Checkpoint storage checkpoint = self.history[index];
324         while (index > 0 && checkpoint.time > _time) {
325             index--;
326             checkpoint = self.history[index];
327         }
328 
329         return checkpoint.time > _time ? 0 : uint256(checkpoint.value);
330     }
331 
332     /**
333     * @dev Private function execute a binary search to find the most recent registered past value of a history based on
334     *      a given point in time. It will return zero if there is no registered value or if given time is previous to
335     *      the first registered value. Note that this function will be more suitable when don't know how recent the
336     *      time used to index may be.
337     * @param self Checkpoints history to be queried
338     * @param _time Point in time to query the most recent registered past value of
339     */
340     function _binarySearch(History storage self, uint64 _time) private view returns (uint256) {
341         // If there was no value registered for the given history return simply zero
342         uint256 length = self.history.length;
343         if (length == 0) {
344             return 0;
345         }
346 
347         // If the requested time is equal to or after the time of the latest registered value, return latest value
348         uint256 lastIndex = length - 1;
349         if (_time >= self.history[lastIndex].time) {
350             return uint256(self.history[lastIndex].value);
351         }
352 
353         // If the requested time is previous to the first registered value, return zero to denote missing checkpoint
354         if (_time < self.history[0].time) {
355             return 0;
356         }
357 
358         // Execute a binary search between the checkpointed times of the history
359         uint256 low = 0;
360         uint256 high = lastIndex;
361 
362         while (high > low) {
363             // No need for SafeMath: for this to overflow array size should be ~2^255
364             uint256 mid = (high + low + 1) / 2;
365             Checkpoint storage checkpoint = self.history[mid];
366             uint64 midTime = checkpoint.time;
367 
368             if (_time > midTime) {
369                 low = mid;
370             } else if (_time < midTime) {
371                 // No need for SafeMath: high > low >= 0 => high >= 1 => mid >= 1
372                 high = mid - 1;
373             } else {
374                 return uint256(checkpoint.value);
375             }
376         }
377 
378         return uint256(self.history[low].value);
379     }
380 }
381 
382 /**
383 * @title HexSumTree - Library to operate checkpointed 16-ary (hex) sum trees.
384 * @dev A sum tree is a particular case of a tree where the value of a node is equal to the sum of the values of its
385 *      children. This library provides a set of functions to operate 16-ary sum trees, i.e. trees where every non-leaf
386 *      node has 16 children and its value is equivalent to the sum of the values of all of them. Additionally, a
387 *      checkpointed tree means that each time a value on a node is updated, its previous value will be saved to allow
388 *      accessing historic information.
389 *
390 *      Example of a checkpointed binary sum tree:
391 *
392 *                                          CURRENT                                      PREVIOUS
393 *
394 *             Level 2                        100  ---------------------------------------- 70
395 *                                       ______|_______                               ______|_______
396 *                                      /              \                             /              \
397 *             Level 1                 34              66 ------------------------- 23              47
398 *                                _____|_____      _____|_____                 _____|_____      _____|_____
399 *                               /           \    /           \               /           \    /           \
400 *             Level 0          22           12  53           13 ----------- 22            1  17           30
401 *
402 */
403 library HexSumTree {
404     using SafeMath for uint256;
405     using Checkpointing for Checkpointing.History;
406 
407     string private constant ERROR_UPDATE_OVERFLOW = "SUM_TREE_UPDATE_OVERFLOW";
408     string private constant ERROR_KEY_DOES_NOT_EXIST = "SUM_TREE_KEY_DOES_NOT_EXIST";
409     string private constant ERROR_SEARCH_OUT_OF_BOUNDS = "SUM_TREE_SEARCH_OUT_OF_BOUNDS";
410     string private constant ERROR_MISSING_SEARCH_VALUES = "SUM_TREE_MISSING_SEARCH_VALUES";
411 
412     // Constants used to perform tree computations
413     // To change any the following constants, the following relationship must be kept: 2^BITS_IN_NIBBLE = CHILDREN
414     // The max depth of the tree will be given by: BITS_IN_NIBBLE * MAX_DEPTH = 256 (so in this case it's 64)
415     uint256 private constant CHILDREN = 16;
416     uint256 private constant BITS_IN_NIBBLE = 4;
417 
418     // All items are leaves, inserted at height or level zero. The root height will be increasing as new levels are inserted in the tree.
419     uint256 private constant ITEMS_LEVEL = 0;
420 
421     // Tree nodes are identified with a 32-bytes length key. Leaves are identified with consecutive incremental keys
422     // starting with 0x0000000000000000000000000000000000000000000000000000000000000000, while non-leaf nodes' keys
423     // are computed based on their level and their children keys.
424     uint256 private constant BASE_KEY = 0;
425 
426     // Timestamp used to checkpoint the first value of the tree height during initialization
427     uint64 private constant INITIALIZATION_INITIAL_TIME = uint64(0);
428 
429     /**
430     * @dev The tree is stored using the following structure:
431     *      - nodes: A mapping indexed by a pair (level, key) with a history of the values for each node (level -> key -> value).
432     *      - height: A history of the heights of the tree. Minimum height is 1, a root with 16 children.
433     *      - nextKey: The next key to be used to identify the next new value that will be inserted into the tree.
434     */
435     struct Tree {
436         uint256 nextKey;
437         Checkpointing.History height;
438         mapping (uint256 => mapping (uint256 => Checkpointing.History)) nodes;
439     }
440 
441     /**
442     * @dev Search params to traverse the tree caching previous results:
443     *      - time: Point in time to query the values being searched, this value shouldn't change during a search
444     *      - level: Level being analyzed for the search, it starts at the level under the root and decrements till the leaves
445     *      - parentKey: Key of the parent of the nodes being analyzed at the given level for the search
446     *      - foundValues: Number of values in the list being searched that were already found, it will go from 0 until the size of the list
447     *      - visitedTotal: Total sum of values that were already visited during the search, it will go from 0 until the tree total
448     */
449     struct SearchParams {
450         uint64 time;
451         uint256 level;
452         uint256 parentKey;
453         uint256 foundValues;
454         uint256 visitedTotal;
455     }
456 
457     /**
458     * @dev Initialize tree setting the next key and first height checkpoint
459     */
460     function init(Tree storage self) internal {
461         self.height.add(INITIALIZATION_INITIAL_TIME, ITEMS_LEVEL + 1);
462         self.nextKey = BASE_KEY;
463     }
464 
465     /**
466     * @dev Insert a new item to the tree at given point in time
467     * @param _time Point in time to register the given value
468     * @param _value New numeric value to be added to the tree
469     * @return Unique key identifying the new value inserted
470     */
471     function insert(Tree storage self, uint64 _time, uint256 _value) internal returns (uint256) {
472         // As the values are always stored in the leaves of the tree (level 0), the key to index each of them will be
473         // always incrementing, starting from zero. Add a new level if necessary.
474         uint256 key = self.nextKey++;
475         _addLevelIfNecessary(self, key, _time);
476 
477         // If the new value is not zero, first set the value of the new leaf node, then add a new level at the top of
478         // the tree if necessary, and finally update sums cached in all the non-leaf nodes.
479         if (_value > 0) {
480             _add(self, ITEMS_LEVEL, key, _time, _value);
481             _updateSums(self, key, _time, _value, true);
482         }
483         return key;
484     }
485 
486     /**
487     * @dev Set the value of a leaf node indexed by its key at given point in time
488     * @param _time Point in time to set the given value
489     * @param _key Key of the leaf node to be set in the tree
490     * @param _value New numeric value to be set for the given key
491     */
492     function set(Tree storage self, uint256 _key, uint64 _time, uint256 _value) internal {
493         require(_key < self.nextKey, ERROR_KEY_DOES_NOT_EXIST);
494 
495         // Set the new value for the requested leaf node
496         uint256 lastValue = getItem(self, _key);
497         _add(self, ITEMS_LEVEL, _key, _time, _value);
498 
499         // Update sums cached in the non-leaf nodes. Note that overflows are being checked at the end of the whole update.
500         if (_value > lastValue) {
501             _updateSums(self, _key, _time, _value - lastValue, true);
502         } else if (_value < lastValue) {
503             _updateSums(self, _key, _time, lastValue - _value, false);
504         }
505     }
506 
507     /**
508     * @dev Update the value of a non-leaf node indexed by its key at given point in time based on a delta
509     * @param _key Key of the leaf node to be updated in the tree
510     * @param _time Point in time to update the given value
511     * @param _delta Numeric delta to update the value of the given key
512     * @param _positive Boolean to tell whether the given delta should be added to or subtracted from the current value
513     */
514     function update(Tree storage self, uint256 _key, uint64 _time, uint256 _delta, bool _positive) internal {
515         require(_key < self.nextKey, ERROR_KEY_DOES_NOT_EXIST);
516 
517         // Update the value of the requested leaf node based on the given delta
518         uint256 lastValue = getItem(self, _key);
519         uint256 newValue = _positive ? lastValue.add(_delta) : lastValue.sub(_delta);
520         _add(self, ITEMS_LEVEL, _key, _time, newValue);
521 
522         // Update sums cached in the non-leaf nodes. Note that overflows is being checked at the end of the whole update.
523         _updateSums(self, _key, _time, _delta, _positive);
524     }
525 
526     /**
527     * @dev Search a list of values in the tree at a given point in time. It will return a list with the nearest
528     *      high value in case a value cannot be found. This function assumes the given list of given values to be
529     *      searched is in ascending order. In case of searching a value out of bounds, it will return zeroed results.
530     * @param _values Ordered list of values to be searched in the tree
531     * @param _time Point in time to query the values being searched
532     * @return keys List of keys found for each requested value in the same order
533     * @return values List of node values found for each requested value in the same order
534     */
535     function search(Tree storage self, uint256[] memory _values, uint64 _time) internal view
536         returns (uint256[] memory keys, uint256[] memory values)
537     {
538         require(_values.length > 0, ERROR_MISSING_SEARCH_VALUES);
539 
540         // Throw out-of-bounds error if there are no items in the tree or the highest value being searched is greater than the total
541         uint256 total = getRecentTotalAt(self, _time);
542         // No need for SafeMath: positive length of array already checked
543         require(total > 0 && total > _values[_values.length - 1], ERROR_SEARCH_OUT_OF_BOUNDS);
544 
545         // Build search params for the first iteration
546         uint256 rootLevel = getRecentHeightAt(self, _time);
547         SearchParams memory searchParams = SearchParams(_time, rootLevel.sub(1), BASE_KEY, 0, 0);
548 
549         // These arrays will be used to fill in the results. We are passing them as parameters to avoid extra copies
550         uint256 length = _values.length;
551         keys = new uint256[](length);
552         values = new uint256[](length);
553         _search(self, _values, searchParams, keys, values);
554     }
555 
556     /**
557     * @dev Tell the sum of the all the items (leaves) stored in the tree, i.e. value of the root of the tree
558     */
559     function getTotal(Tree storage self) internal view returns (uint256) {
560         uint256 rootLevel = getHeight(self);
561         return getNode(self, rootLevel, BASE_KEY);
562     }
563 
564     /**
565     * @dev Tell the sum of the all the items (leaves) stored in the tree, i.e. value of the root of the tree, at a given point in time
566     *      It uses a binary search for the root node, a linear one for the height.
567     * @param _time Point in time to query the sum of all the items (leaves) stored in the tree
568     */
569     function getTotalAt(Tree storage self, uint64 _time) internal view returns (uint256) {
570         uint256 rootLevel = getRecentHeightAt(self, _time);
571         return getNodeAt(self, rootLevel, BASE_KEY, _time);
572     }
573 
574     /**
575     * @dev Tell the sum of the all the items (leaves) stored in the tree, i.e. value of the root of the tree, at a given point in time
576     *      It uses a linear search starting from the end.
577     * @param _time Point in time to query the sum of all the items (leaves) stored in the tree
578     */
579     function getRecentTotalAt(Tree storage self, uint64 _time) internal view returns (uint256) {
580         uint256 rootLevel = getRecentHeightAt(self, _time);
581         return getRecentNodeAt(self, rootLevel, BASE_KEY, _time);
582     }
583 
584     /**
585     * @dev Tell the value of a certain leaf indexed by a given key
586     * @param _key Key of the leaf node querying the value of
587     */
588     function getItem(Tree storage self, uint256 _key) internal view returns (uint256) {
589         return getNode(self, ITEMS_LEVEL, _key);
590     }
591 
592     /**
593     * @dev Tell the value of a certain leaf indexed by a given key at a given point in time
594     *      It uses a binary search.
595     * @param _key Key of the leaf node querying the value of
596     * @param _time Point in time to query the value of the requested leaf
597     */
598     function getItemAt(Tree storage self, uint256 _key, uint64 _time) internal view returns (uint256) {
599         return getNodeAt(self, ITEMS_LEVEL, _key, _time);
600     }
601 
602     /**
603     * @dev Tell the value of a certain node indexed by a given (level,key) pair
604     * @param _level Level of the node querying the value of
605     * @param _key Key of the node querying the value of
606     */
607     function getNode(Tree storage self, uint256 _level, uint256 _key) internal view returns (uint256) {
608         return self.nodes[_level][_key].getLast();
609     }
610 
611     /**
612     * @dev Tell the value of a certain node indexed by a given (level,key) pair at a given point in time
613     *      It uses a binary search.
614     * @param _level Level of the node querying the value of
615     * @param _key Key of the node querying the value of
616     * @param _time Point in time to query the value of the requested node
617     */
618     function getNodeAt(Tree storage self, uint256 _level, uint256 _key, uint64 _time) internal view returns (uint256) {
619         return self.nodes[_level][_key].get(_time);
620     }
621 
622     /**
623     * @dev Tell the value of a certain node indexed by a given (level,key) pair at a given point in time
624     *      It uses a linear search starting from the end.
625     * @param _level Level of the node querying the value of
626     * @param _key Key of the node querying the value of
627     * @param _time Point in time to query the value of the requested node
628     */
629     function getRecentNodeAt(Tree storage self, uint256 _level, uint256 _key, uint64 _time) internal view returns (uint256) {
630         return self.nodes[_level][_key].getRecent(_time);
631     }
632 
633     /**
634     * @dev Tell the height of the tree
635     */
636     function getHeight(Tree storage self) internal view returns (uint256) {
637         return self.height.getLast();
638     }
639 
640     /**
641     * @dev Tell the height of the tree at a given point in time
642     *      It uses a linear search starting from the end.
643     * @param _time Point in time to query the height of the tree
644     */
645     function getRecentHeightAt(Tree storage self, uint64 _time) internal view returns (uint256) {
646         return self.height.getRecent(_time);
647     }
648 
649     /**
650     * @dev Private function to update the values of all the ancestors of the given leaf node based on the delta updated
651     * @param _key Key of the leaf node to update the ancestors of
652     * @param _time Point in time to update the ancestors' values of the given leaf node
653     * @param _delta Numeric delta to update the ancestors' values of the given leaf node
654     * @param _positive Boolean to tell whether the given delta should be added to or subtracted from ancestors' values
655     */
656     function _updateSums(Tree storage self, uint256 _key, uint64 _time, uint256 _delta, bool _positive) private {
657         uint256 mask = uint256(-1);
658         uint256 ancestorKey = _key;
659         uint256 currentHeight = getHeight(self);
660         for (uint256 level = ITEMS_LEVEL + 1; level <= currentHeight; level++) {
661             // Build a mask to get the key of the ancestor at a certain level. For example:
662             // Level  0: leaves don't have children
663             // Level  1: 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0 (up to 16 leaves)
664             // Level  2: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 (up to 32 leaves)
665             // ...
666             // Level 63: 0x0000000000000000000000000000000000000000000000000000000000000000 (up to 16^64 leaves - tree max height)
667             mask = mask << BITS_IN_NIBBLE;
668 
669             // The key of the ancestor at that level "i" is equivalent to the "(64 - i)-th" most significant nibbles
670             // of the ancestor's key of the previous level "i - 1". Thus, we can compute the key of an ancestor at a
671             // certain level applying the mask to the ancestor's key of the previous level. Note that for the first
672             // iteration, the key of the ancestor of the previous level is simply the key of the leaf being updated.
673             ancestorKey = ancestorKey & mask;
674 
675             // Update value
676             uint256 lastValue = getNode(self, level, ancestorKey);
677             uint256 newValue = _positive ? lastValue.add(_delta) : lastValue.sub(_delta);
678             _add(self, level, ancestorKey, _time, newValue);
679         }
680 
681         // Check if there was an overflow. Note that we only need to check the value stored in the root since the
682         // sum only increases going up through the tree.
683         require(!_positive || getNode(self, currentHeight, ancestorKey) >= _delta, ERROR_UPDATE_OVERFLOW);
684     }
685 
686     /**
687     * @dev Private function to add a new level to the tree based on a new key that will be inserted
688     * @param _newKey New key willing to be inserted in the tree
689     * @param _time Point in time when the new key will be inserted
690     */
691     function _addLevelIfNecessary(Tree storage self, uint256 _newKey, uint64 _time) private {
692         uint256 currentHeight = getHeight(self);
693         if (_shouldAddLevel(currentHeight, _newKey)) {
694             // Max height allowed for the tree is 64 since we are using node keys of 32 bytes. However, note that we
695             // are not checking if said limit has been hit when inserting new leaves to the tree, for the purpose of
696             // this system having 2^256 items inserted is unrealistic.
697             uint256 newHeight = currentHeight + 1;
698             uint256 rootValue = getNode(self, currentHeight, BASE_KEY);
699             _add(self, newHeight, BASE_KEY, _time, rootValue);
700             self.height.add(_time, newHeight);
701         }
702     }
703 
704     /**
705     * @dev Private function to register a new value in the history of a node at a given point in time
706     * @param _level Level of the node to add a new value at a given point in time to
707     * @param _key Key of the node to add a new value at a given point in time to
708     * @param _time Point in time to register a value for the given node
709     * @param _value Numeric value to be registered for the given node at a given point in time
710     */
711     function _add(Tree storage self, uint256 _level, uint256 _key, uint64 _time, uint256 _value) private {
712         self.nodes[_level][_key].add(_time, _value);
713     }
714 
715     /**
716     * @dev Recursive pre-order traversal function
717     *      Every time it checks a node, it traverses the input array to find the initial subset of elements that are
718     *      below its accumulated value and passes that sub-array to the next iteration. Actually, the array is always
719     *      the same, to avoid making extra copies, it just passes the number of values already found , to avoid
720     *      checking values that went through a different branch. The same happens with the result lists of keys and
721     *      values, these are the same on every recursion step. The visited total is carried over each iteration to
722     *      avoid having to subtract all elements in the array.
723     * @param _values Ordered list of values to be searched in the tree
724     * @param _params Search parameters for the current recursive step
725     * @param _resultKeys List of keys found for each requested value in the same order
726     * @param _resultValues List of node values found for each requested value in the same order
727     */
728     function _search(
729         Tree storage self,
730         uint256[] memory _values,
731         SearchParams memory _params,
732         uint256[] memory _resultKeys,
733         uint256[] memory _resultValues
734     )
735         private
736         view
737     {
738         uint256 levelKeyLessSignificantNibble = _params.level.mul(BITS_IN_NIBBLE);
739 
740         for (uint256 childNumber = 0; childNumber < CHILDREN; childNumber++) {
741             // Return if we already found enough values
742             if (_params.foundValues >= _values.length) {
743                 break;
744             }
745 
746             // Build child node key shifting the child number to the position of the less significant nibble of
747             // the keys for the level being analyzed, and adding it to the key of the parent node. For example,
748             // for a tree with height 5, if we are checking the children of the second node of the level 3, whose
749             // key is    0x0000000000000000000000000000000000000000000000000000000000001000, its children keys are:
750             // Child  0: 0x0000000000000000000000000000000000000000000000000000000000001000
751             // Child  1: 0x0000000000000000000000000000000000000000000000000000000000001100
752             // Child  2: 0x0000000000000000000000000000000000000000000000000000000000001200
753             // ...
754             // Child 15: 0x0000000000000000000000000000000000000000000000000000000000001f00
755             uint256 childNodeKey = _params.parentKey.add(childNumber << levelKeyLessSignificantNibble);
756             uint256 childNodeValue = getRecentNodeAt(self, _params.level, childNodeKey, _params.time);
757 
758             // Check how many values belong to the subtree of this node. As they are ordered, it will be a contiguous
759             // subset starting from the beginning, so we only need to know the length of that subset.
760             uint256 newVisitedTotal = _params.visitedTotal.add(childNodeValue);
761             uint256 subtreeIncludedValues = _getValuesIncludedInSubtree(_values, _params.foundValues, newVisitedTotal);
762 
763             // If there are some values included in the subtree of the child node, visit them
764             if (subtreeIncludedValues > 0) {
765                 // If the child node being analyzed is a leaf, add it to the list of results a number of times equals
766                 // to the number of values that were included in it. Otherwise, descend one level.
767                 if (_params.level == ITEMS_LEVEL) {
768                     _copyFoundNode(_params.foundValues, subtreeIncludedValues, childNodeKey, _resultKeys, childNodeValue, _resultValues);
769                 } else {
770                     SearchParams memory nextLevelParams = SearchParams(
771                         _params.time,
772                         _params.level - 1, // No need for SafeMath: we already checked above that the level being checked is greater than zero
773                         childNodeKey,
774                         _params.foundValues,
775                         _params.visitedTotal
776                     );
777                     _search(self, _values, nextLevelParams, _resultKeys, _resultValues);
778                 }
779                 // Update the number of values that were already found
780                 _params.foundValues = _params.foundValues.add(subtreeIncludedValues);
781             }
782             // Update the visited total for the next node in this level
783             _params.visitedTotal = newVisitedTotal;
784         }
785     }
786 
787     /**
788     * @dev Private function to check if a new key can be added to the tree based on the current height of the tree
789     * @param _currentHeight Current height of the tree to check if it supports adding the given key
790     * @param _newKey Key willing to be added to the tree with the given current height
791     * @return True if the current height of the tree should be increased to add the new key, false otherwise.
792     */
793     function _shouldAddLevel(uint256 _currentHeight, uint256 _newKey) private pure returns (bool) {
794         // Build a mask that will match all the possible keys for the given height. For example:
795         // Height  1: 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0 (up to 16 keys)
796         // Height  2: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 (up to 32 keys)
797         // ...
798         // Height 64: 0x0000000000000000000000000000000000000000000000000000000000000000 (up to 16^64 keys - tree max height)
799         uint256 shift = _currentHeight.mul(BITS_IN_NIBBLE);
800         uint256 mask = uint256(-1) << shift;
801 
802         // Check if the given key can be represented in the tree with the current given height using the mask.
803         return (_newKey & mask) != 0;
804     }
805 
806     /**
807     * @dev Private function to tell how many values of a list can be found in a subtree
808     * @param _values List of values being searched in ascending order
809     * @param _foundValues Number of values that were already found and should be ignore
810     * @param _subtreeTotal Total sum of the given subtree to check the numbers that are included in it
811     * @return Number of values in the list that are included in the given subtree
812     */
813     function _getValuesIncludedInSubtree(uint256[] memory _values, uint256 _foundValues, uint256 _subtreeTotal) private pure returns (uint256) {
814         // Look for all the values that can be found in the given subtree
815         uint256 i = _foundValues;
816         while (i < _values.length && _values[i] < _subtreeTotal) {
817             i++;
818         }
819         return i - _foundValues;
820     }
821 
822     /**
823     * @dev Private function to copy a node a given number of times to a results list. This function assumes the given
824     *      results list have enough size to support the requested copy.
825     * @param _from Index of the results list to start copying the given node
826     * @param _times Number of times the given node will be copied
827     * @param _key Key of the node to be copied
828     * @param _resultKeys Lists of key results to copy the given node key to
829     * @param _value Value of the node to be copied
830     * @param _resultValues Lists of value results to copy the given node value to
831     */
832     function _copyFoundNode(
833         uint256 _from,
834         uint256 _times,
835         uint256 _key,
836         uint256[] memory _resultKeys,
837         uint256 _value,
838         uint256[] memory _resultValues
839     )
840         private
841         pure
842     {
843         for (uint256 i = 0; i < _times; i++) {
844             _resultKeys[_from + i] = _key;
845             _resultValues[_from + i] = _value;
846         }
847     }
848 }
849 
850 /**
851 * @title GuardiansTreeSortition - Library to perform guardians sortition over a `HexSumTree`
852 */
853 library GuardiansTreeSortition {
854     using SafeMath for uint256;
855     using HexSumTree for HexSumTree.Tree;
856 
857     string private constant ERROR_INVALID_INTERVAL_SEARCH = "TREE_INVALID_INTERVAL_SEARCH";
858     string private constant ERROR_SORTITION_LENGTHS_MISMATCH = "TREE_SORTITION_LENGTHS_MISMATCH";
859 
860     /**
861     * @dev Search random items in the tree based on certain restrictions
862     * @param _termRandomness Randomness to compute the seed for the draft
863     * @param _disputeId Identification number of the dispute to draft guardians for
864     * @param _termId Current term when the draft is being computed
865     * @param _selectedGuardians Number of guardians already selected for the draft
866     * @param _batchRequestedGuardians Number of guardians to be selected in the given batch of the draft
867     * @param _roundRequestedGuardians Total number of guardians requested to be drafted
868     * @param _sortitionIteration Number of sortitions already performed for the given draft
869     * @return guardiansIds List of guardian ids obtained based on the requested search
870     * @return guardiansBalances List of active balances for each guardian obtained based on the requested search
871     */
872     function batchedRandomSearch(
873         HexSumTree.Tree storage tree,
874         bytes32 _termRandomness,
875         uint256 _disputeId,
876         uint64 _termId,
877         uint256 _selectedGuardians,
878         uint256 _batchRequestedGuardians,
879         uint256 _roundRequestedGuardians,
880         uint256 _sortitionIteration
881     )
882         internal
883         view
884         returns (uint256[] memory guardiansIds, uint256[] memory guardiansBalances)
885     {
886         (uint256 low, uint256 high) = getSearchBatchBounds(
887             tree,
888             _termId,
889             _selectedGuardians,
890             _batchRequestedGuardians,
891             _roundRequestedGuardians
892         );
893 
894         uint256[] memory balances = _computeSearchRandomBalances(
895             _termRandomness,
896             _disputeId,
897             _sortitionIteration,
898             _batchRequestedGuardians,
899             low,
900             high
901         );
902 
903         (guardiansIds, guardiansBalances) = tree.search(balances, _termId);
904 
905         require(guardiansIds.length == guardiansBalances.length, ERROR_SORTITION_LENGTHS_MISMATCH);
906         require(guardiansIds.length == _batchRequestedGuardians, ERROR_SORTITION_LENGTHS_MISMATCH);
907     }
908 
909     /**
910     * @dev Get the bounds for a draft batch based on the active balances of the guardians
911     * @param _termId Term ID of the active balances that will be used to compute the boundaries
912     * @param _selectedGuardians Number of guardians already selected for the draft
913     * @param _batchRequestedGuardians Number of guardians to be selected in the given batch of the draft
914     * @param _roundRequestedGuardians Total number of guardians requested to be drafted
915     * @return low Low bound to be used for the sortition to draft the requested number of guardians for the given batch
916     * @return high High bound to be used for the sortition to draft the requested number of guardians for the given batch
917     */
918     function getSearchBatchBounds(
919         HexSumTree.Tree storage tree,
920         uint64 _termId,
921         uint256 _selectedGuardians,
922         uint256 _batchRequestedGuardians,
923         uint256 _roundRequestedGuardians
924     )
925         internal
926         view
927         returns (uint256 low, uint256 high)
928     {
929         uint256 totalActiveBalance = tree.getRecentTotalAt(_termId);
930         low = _selectedGuardians.mul(totalActiveBalance).div(_roundRequestedGuardians);
931 
932         uint256 newSelectedGuardians = _selectedGuardians.add(_batchRequestedGuardians);
933         high = newSelectedGuardians.mul(totalActiveBalance).div(_roundRequestedGuardians);
934     }
935 
936     /**
937     * @dev Get a random list of active balances to be searched in the guardians tree for a given draft batch
938     * @param _termRandomness Randomness to compute the seed for the draft
939     * @param _disputeId Identification number of the dispute to draft guardians for (for randomness)
940     * @param _sortitionIteration Number of sortitions already performed for the given draft (for randomness)
941     * @param _batchRequestedGuardians Number of guardians to be selected in the given batch of the draft
942     * @param _lowBatchBound Low bound to be used for the sortition batch to draft the requested number of guardians
943     * @param _highBatchBound High bound to be used for the sortition batch to draft the requested number of guardians
944     * @return Random list of active balances to be searched in the guardians tree for the given draft batch
945     */
946     function _computeSearchRandomBalances(
947         bytes32 _termRandomness,
948         uint256 _disputeId,
949         uint256 _sortitionIteration,
950         uint256 _batchRequestedGuardians,
951         uint256 _lowBatchBound,
952         uint256 _highBatchBound
953     )
954         internal
955         pure
956         returns (uint256[] memory)
957     {
958         // Calculate the interval to be used to search the balances in the tree. Since we are using a modulo function to compute the
959         // random balances to be searched, intervals will be closed on the left and open on the right, for example [0,10).
960         require(_highBatchBound > _lowBatchBound, ERROR_INVALID_INTERVAL_SEARCH);
961         uint256 interval = _highBatchBound - _lowBatchBound;
962 
963         // Compute an ordered list of random active balance to be searched in the guardians tree
964         uint256[] memory balances = new uint256[](_batchRequestedGuardians);
965         for (uint256 batchGuardianNumber = 0; batchGuardianNumber < _batchRequestedGuardians; batchGuardianNumber++) {
966             // Compute a random seed using:
967             // - The inherent randomness associated to the term from blockhash
968             // - The disputeId, so 2 disputes in the same term will have different outcomes
969             // - The sortition iteration, to avoid getting stuck if resulting guardians are dismissed due to locked balance
970             // - The guardian number in this batch
971             bytes32 seed = keccak256(abi.encodePacked(_termRandomness, _disputeId, _sortitionIteration, batchGuardianNumber));
972 
973             // Compute a random active balance to be searched in the guardians tree using the generated seed within the
974             // boundaries computed for the current batch.
975             balances[batchGuardianNumber] = _lowBatchBound.add(uint256(seed) % interval);
976 
977             // Make sure it's ordered, flip values if necessary
978             for (uint256 i = batchGuardianNumber; i > 0 && balances[i] < balances[i - 1]; i--) {
979                 uint256 tmp = balances[i - 1];
980                 balances[i - 1] = balances[i];
981                 balances[i] = tmp;
982             }
983         }
984         return balances;
985     }
986 }
987 
988 /*
989  * SPDX-License-Identifier:    MIT
990  */
991 interface ILockManager {
992     /**
993     * @dev Tell whether a user can unlock a certain amount of tokens
994     */
995     function canUnlock(address user, uint256 amount) external view returns (bool);
996 }
997 
998 /*
999  * SPDX-License-Identifier:    MIT
1000  */
1001 interface IGuardiansRegistry {
1002 
1003     /**
1004     * @dev Assign a requested amount of guardian tokens to a guardian
1005     * @param _guardian Guardian to add an amount of tokens to
1006     * @param _amount Amount of tokens to be added to the available balance of a guardian
1007     */
1008     function assignTokens(address _guardian, uint256 _amount) external;
1009 
1010     /**
1011     * @dev Burn a requested amount of guardian tokens
1012     * @param _amount Amount of tokens to be burned
1013     */
1014     function burnTokens(uint256 _amount) external;
1015 
1016     /**
1017     * @dev Draft a set of guardians based on given requirements for a term id
1018     * @param _params Array containing draft requirements:
1019     *        0. bytes32 Term randomness
1020     *        1. uint256 Dispute id
1021     *        2. uint64  Current term id
1022     *        3. uint256 Number of seats already filled
1023     *        4. uint256 Number of seats left to be filled
1024     *        5. uint64  Number of guardians required for the draft
1025     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
1026     *
1027     * @return guardians List of guardians selected for the draft
1028     * @return length Size of the list of the draft result
1029     */
1030     function draft(uint256[7] calldata _params) external returns (address[] memory guardians, uint256 length);
1031 
1032     /**
1033     * @dev Slash a set of guardians based on their votes compared to the winning ruling
1034     * @param _termId Current term id
1035     * @param _guardians List of guardian addresses to be slashed
1036     * @param _lockedAmounts List of amounts locked for each corresponding guardian that will be either slashed or returned
1037     * @param _rewardedGuardians List of booleans to tell whether a guardian's active balance has to be slashed or not
1038     * @return Total amount of slashed tokens
1039     */
1040     function slashOrUnlock(uint64 _termId, address[] calldata _guardians, uint256[] calldata _lockedAmounts, bool[] calldata _rewardedGuardians)
1041         external
1042         returns (uint256 collectedTokens);
1043 
1044     /**
1045     * @dev Try to collect a certain amount of tokens from a guardian for the next term
1046     * @param _guardian Guardian to collect the tokens from
1047     * @param _amount Amount of tokens to be collected from the given guardian and for the requested term id
1048     * @param _termId Current term id
1049     * @return True if the guardian has enough unlocked tokens to be collected for the requested term, false otherwise
1050     */
1051     function collectTokens(address _guardian, uint256 _amount, uint64 _termId) external returns (bool);
1052 
1053     /**
1054     * @dev Lock a guardian's withdrawals until a certain term ID
1055     * @param _guardian Address of the guardian to be locked
1056     * @param _termId Term ID until which the guardian's withdrawals will be locked
1057     */
1058     function lockWithdrawals(address _guardian, uint64 _termId) external;
1059 
1060     /**
1061     * @dev Tell the active balance of a guardian for a given term id
1062     * @param _guardian Address of the guardian querying the active balance of
1063     * @param _termId Term ID querying the active balance for
1064     * @return Amount of active tokens for guardian in the requested past term id
1065     */
1066     function activeBalanceOfAt(address _guardian, uint64 _termId) external view returns (uint256);
1067 
1068     /**
1069     * @dev Tell the total amount of active guardian tokens at the given term id
1070     * @param _termId Term ID querying the total active balance for
1071     * @return Total amount of active guardian tokens at the given term id
1072     */
1073     function totalActiveBalanceAt(uint64 _termId) external view returns (uint256);
1074 }
1075 
1076 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
1077 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
1078 contract IsContract {
1079     /*
1080     * NOTE: this should NEVER be used for authentication
1081     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
1082     *
1083     * This is only intended to be used as a sanity check that an address is actually a contract,
1084     * RATHER THAN an address not being a contract.
1085     */
1086     function isContract(address _target) internal view returns (bool) {
1087         if (_target == address(0)) {
1088             return false;
1089         }
1090 
1091         uint256 size;
1092         assembly { size := extcodesize(_target) }
1093         return size > 0;
1094     }
1095 }
1096 
1097 contract ACL {
1098     string private constant ERROR_BAD_FREEZE = "ACL_BAD_FREEZE";
1099     string private constant ERROR_ROLE_ALREADY_FROZEN = "ACL_ROLE_ALREADY_FROZEN";
1100     string private constant ERROR_INVALID_BULK_INPUT = "ACL_INVALID_BULK_INPUT";
1101 
1102     enum BulkOp { Grant, Revoke, Freeze }
1103 
1104     address internal constant FREEZE_FLAG = address(1);
1105     address internal constant ANY_ADDR = address(-1);
1106 
1107     // List of all roles assigned to different addresses
1108     mapping (bytes32 => mapping (address => bool)) public roles;
1109 
1110     event Granted(bytes32 indexed id, address indexed who);
1111     event Revoked(bytes32 indexed id, address indexed who);
1112     event Frozen(bytes32 indexed id);
1113 
1114     /**
1115     * @dev Tell whether an address has a role assigned
1116     * @param _who Address being queried
1117     * @param _id ID of the role being checked
1118     * @return True if the requested address has assigned the given role, false otherwise
1119     */
1120     function hasRole(address _who, bytes32 _id) public view returns (bool) {
1121         return roles[_id][_who] || roles[_id][ANY_ADDR];
1122     }
1123 
1124     /**
1125     * @dev Tell whether a role is frozen
1126     * @param _id ID of the role being checked
1127     * @return True if the given role is frozen, false otherwise
1128     */
1129     function isRoleFrozen(bytes32 _id) public view returns (bool) {
1130         return roles[_id][FREEZE_FLAG];
1131     }
1132 
1133     /**
1134     * @dev Internal function to grant a role to a given address
1135     * @param _id ID of the role to be granted
1136     * @param _who Address to grant the role to
1137     */
1138     function _grant(bytes32 _id, address _who) internal {
1139         require(!isRoleFrozen(_id), ERROR_ROLE_ALREADY_FROZEN);
1140         require(_who != FREEZE_FLAG, ERROR_BAD_FREEZE);
1141 
1142         if (!hasRole(_who, _id)) {
1143             roles[_id][_who] = true;
1144             emit Granted(_id, _who);
1145         }
1146     }
1147 
1148     /**
1149     * @dev Internal function to revoke a role from a given address
1150     * @param _id ID of the role to be revoked
1151     * @param _who Address to revoke the role from
1152     */
1153     function _revoke(bytes32 _id, address _who) internal {
1154         require(!isRoleFrozen(_id), ERROR_ROLE_ALREADY_FROZEN);
1155 
1156         if (hasRole(_who, _id)) {
1157             roles[_id][_who] = false;
1158             emit Revoked(_id, _who);
1159         }
1160     }
1161 
1162     /**
1163     * @dev Internal function to freeze a role
1164     * @param _id ID of the role to be frozen
1165     */
1166     function _freeze(bytes32 _id) internal {
1167         require(!isRoleFrozen(_id), ERROR_ROLE_ALREADY_FROZEN);
1168         roles[_id][FREEZE_FLAG] = true;
1169         emit Frozen(_id);
1170     }
1171 
1172     /**
1173     * @dev Internal function to enact a bulk list of ACL operations
1174     */
1175     function _bulk(BulkOp[] memory _op, bytes32[] memory _id, address[] memory _who) internal {
1176         require(_op.length == _id.length && _op.length == _who.length, ERROR_INVALID_BULK_INPUT);
1177 
1178         for (uint256 i = 0; i < _op.length; i++) {
1179             BulkOp op = _op[i];
1180             if (op == BulkOp.Grant) {
1181                 _grant(_id[i], _who[i]);
1182             } else if (op == BulkOp.Revoke) {
1183                 _revoke(_id[i], _who[i]);
1184             } else if (op == BulkOp.Freeze) {
1185                 _freeze(_id[i]);
1186             }
1187         }
1188     }
1189 }
1190 
1191 contract ModuleIds {
1192     // DisputeManager module ID - keccak256(abi.encodePacked("DISPUTE_MANAGER"))
1193     bytes32 internal constant MODULE_ID_DISPUTE_MANAGER = 0x14a6c70f0f6d449c014c7bbc9e68e31e79e8474fb03b7194df83109a2d888ae6;
1194 
1195     // GuardiansRegistry module ID - keccak256(abi.encodePacked("GUARDIANS_REGISTRY"))
1196     bytes32 internal constant MODULE_ID_GUARDIANS_REGISTRY = 0x8af7b7118de65da3b974a3fd4b0c702b66442f74b9dff6eaed1037254c0b79fe;
1197 
1198     // Voting module ID - keccak256(abi.encodePacked("VOTING"))
1199     bytes32 internal constant MODULE_ID_VOTING = 0x7cbb12e82a6d63ff16fe43977f43e3e2b247ecd4e62c0e340da8800a48c67346;
1200 
1201     // PaymentsBook module ID - keccak256(abi.encodePacked("PAYMENTS_BOOK"))
1202     bytes32 internal constant MODULE_ID_PAYMENTS_BOOK = 0xfa275b1417437a2a2ea8e91e9fe73c28eaf0a28532a250541da5ac0d1892b418;
1203 
1204     // Treasury module ID - keccak256(abi.encodePacked("TREASURY"))
1205     bytes32 internal constant MODULE_ID_TREASURY = 0x06aa03964db1f7257357ef09714a5f0ca3633723df419e97015e0c7a3e83edb7;
1206 }
1207 
1208 interface IModulesLinker {
1209     /**
1210     * @notice Update the implementations of a list of modules
1211     * @param _ids List of IDs of the modules to be updated
1212     * @param _addresses List of module addresses to be updated
1213     */
1214     function linkModules(bytes32[] calldata _ids, address[] calldata _addresses) external;
1215 }
1216 
1217 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/math/SafeMath64.sol
1218 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
1219 /**
1220  * @title SafeMath64
1221  * @dev Math operations for uint64 with safety checks that revert on error
1222  */
1223 library SafeMath64 {
1224     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
1225     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
1226     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
1227     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
1228 
1229     /**
1230     * @dev Multiplies two numbers, reverts on overflow.
1231     */
1232     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
1233         uint256 c = uint256(_a) * uint256(_b);
1234         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
1235 
1236         return uint64(c);
1237     }
1238 
1239     /**
1240     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1241     */
1242     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
1243         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
1244         uint64 c = _a / _b;
1245         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1246 
1247         return c;
1248     }
1249 
1250     /**
1251     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1252     */
1253     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
1254         require(_b <= _a, ERROR_SUB_UNDERFLOW);
1255         uint64 c = _a - _b;
1256 
1257         return c;
1258     }
1259 
1260     /**
1261     * @dev Adds two numbers, reverts on overflow.
1262     */
1263     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
1264         uint64 c = _a + _b;
1265         require(c >= _a, ERROR_ADD_OVERFLOW);
1266 
1267         return c;
1268     }
1269 
1270     /**
1271     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1272     * reverts when dividing by zero.
1273     */
1274     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
1275         require(b != 0, ERROR_DIV_ZERO);
1276         return a % b;
1277     }
1278 }
1279 
1280 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/Uint256Helpers.sol
1281 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
1282 library Uint256Helpers {
1283     uint256 private constant MAX_UINT8 = uint8(-1);
1284     uint256 private constant MAX_UINT64 = uint64(-1);
1285 
1286     string private constant ERROR_UINT8_NUMBER_TOO_BIG = "UINT8_NUMBER_TOO_BIG";
1287     string private constant ERROR_UINT64_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
1288 
1289     function toUint8(uint256 a) internal pure returns (uint8) {
1290         require(a <= MAX_UINT8, ERROR_UINT8_NUMBER_TOO_BIG);
1291         return uint8(a);
1292     }
1293 
1294     function toUint64(uint256 a) internal pure returns (uint64) {
1295         require(a <= MAX_UINT64, ERROR_UINT64_NUMBER_TOO_BIG);
1296         return uint64(a);
1297     }
1298 }
1299 
1300 // Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/TimeHelpers.sol
1301 // Adapted to use pragma ^0.5.17 and satisfy our linter rules
1302 contract TimeHelpers {
1303     using Uint256Helpers for uint256;
1304 
1305     /**
1306     * @dev Returns the current block number.
1307     *      Using a function rather than `block.number` allows us to easily mock the block number in
1308     *      tests.
1309     */
1310     function getBlockNumber() internal view returns (uint256) {
1311         return block.number;
1312     }
1313 
1314     /**
1315     * @dev Returns the current block number, converted to uint64.
1316     *      Using a function rather than `block.number` allows us to easily mock the block number in
1317     *      tests.
1318     */
1319     function getBlockNumber64() internal view returns (uint64) {
1320         return getBlockNumber().toUint64();
1321     }
1322 
1323     /**
1324     * @dev Returns the current timestamp.
1325     *      Using a function rather than `block.timestamp` allows us to easily mock it in
1326     *      tests.
1327     */
1328     function getTimestamp() internal view returns (uint256) {
1329         return block.timestamp; // solium-disable-line security/no-block-members
1330     }
1331 
1332     /**
1333     * @dev Returns the current timestamp, converted to uint64.
1334     *      Using a function rather than `block.timestamp` allows us to easily mock it in
1335     *      tests.
1336     */
1337     function getTimestamp64() internal view returns (uint64) {
1338         return getTimestamp().toUint64();
1339     }
1340 }
1341 
1342 interface IClock {
1343     /**
1344     * @dev Ensure that the current term of the clock is up-to-date
1345     * @return Identification number of the current term
1346     */
1347     function ensureCurrentTerm() external returns (uint64);
1348 
1349     /**
1350     * @dev Transition up to a certain number of terms to leave the clock up-to-date
1351     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
1352     * @return Identification number of the term ID after executing the heartbeat transitions
1353     */
1354     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64);
1355 
1356     /**
1357     * @dev Ensure that a certain term has its randomness set
1358     * @return Randomness of the current term
1359     */
1360     function ensureCurrentTermRandomness() external returns (bytes32);
1361 
1362     /**
1363     * @dev Tell the last ensured term identification number
1364     * @return Identification number of the last ensured term
1365     */
1366     function getLastEnsuredTermId() external view returns (uint64);
1367 
1368     /**
1369     * @dev Tell the current term identification number. Note that there may be pending term transitions.
1370     * @return Identification number of the current term
1371     */
1372     function getCurrentTermId() external view returns (uint64);
1373 
1374     /**
1375     * @dev Tell the number of terms the clock should transition to be up-to-date
1376     * @return Number of terms the clock should transition to be up-to-date
1377     */
1378     function getNeededTermTransitions() external view returns (uint64);
1379 
1380     /**
1381     * @dev Tell the information related to a term based on its ID
1382     * @param _termId ID of the term being queried
1383     * @return startTime Term start time
1384     * @return randomnessBN Block number used for randomness in the requested term
1385     * @return randomness Randomness computed for the requested term
1386     */
1387     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness);
1388 
1389     /**
1390     * @dev Tell the randomness of a term even if it wasn't computed yet
1391     * @param _termId Identification number of the term being queried
1392     * @return Randomness of the requested term
1393     */
1394     function getTermRandomness(uint64 _termId) external view returns (bytes32);
1395 }
1396 
1397 contract CourtClock is IClock, TimeHelpers {
1398     using SafeMath64 for uint64;
1399 
1400     string private constant ERROR_TERM_DOES_NOT_EXIST = "CLK_TERM_DOES_NOT_EXIST";
1401     string private constant ERROR_TERM_DURATION_TOO_LONG = "CLK_TERM_DURATION_TOO_LONG";
1402     string private constant ERROR_TERM_RANDOMNESS_NOT_YET = "CLK_TERM_RANDOMNESS_NOT_YET";
1403     string private constant ERROR_TERM_RANDOMNESS_UNAVAILABLE = "CLK_TERM_RANDOMNESS_UNAVAILABLE";
1404     string private constant ERROR_BAD_FIRST_TERM_START_TIME = "CLK_BAD_FIRST_TERM_START_TIME";
1405     string private constant ERROR_TOO_MANY_TRANSITIONS = "CLK_TOO_MANY_TRANSITIONS";
1406     string private constant ERROR_INVALID_TRANSITION_TERMS = "CLK_INVALID_TRANSITION_TERMS";
1407     string private constant ERROR_CANNOT_DELAY_STARTED_COURT = "CLK_CANNOT_DELAY_STARTED_PROT";
1408     string private constant ERROR_CANNOT_DELAY_PAST_START_TIME = "CLK_CANNOT_DELAY_PAST_START_TIME";
1409 
1410     // Maximum number of term transitions a callee may have to assume in order to call certain functions that require the Court being up-to-date
1411     uint64 internal constant MAX_AUTO_TERM_TRANSITIONS_ALLOWED = 1;
1412 
1413     // Max duration in seconds that a term can last
1414     uint64 internal constant MAX_TERM_DURATION = 365 days;
1415 
1416     // Max time until first term starts since contract is deployed
1417     uint64 internal constant MAX_FIRST_TERM_DELAY_PERIOD = 2 * MAX_TERM_DURATION;
1418 
1419     struct Term {
1420         uint64 startTime;              // Timestamp when the term started
1421         uint64 randomnessBN;           // Block number for entropy
1422         bytes32 randomness;            // Entropy from randomnessBN block hash
1423     }
1424 
1425     // Duration in seconds for each term of the Court
1426     uint64 private termDuration;
1427 
1428     // Last ensured term id
1429     uint64 private termId;
1430 
1431     // List of Court terms indexed by id
1432     mapping (uint64 => Term) private terms;
1433 
1434     event Heartbeat(uint64 previousTermId, uint64 currentTermId);
1435     event StartTimeDelayed(uint64 previousStartTime, uint64 currentStartTime);
1436 
1437     /**
1438     * @dev Ensure a certain term has already been processed
1439     * @param _termId Identification number of the term to be checked
1440     */
1441     modifier termExists(uint64 _termId) {
1442         require(_termId <= termId, ERROR_TERM_DOES_NOT_EXIST);
1443         _;
1444     }
1445 
1446     /**
1447     * @dev Constructor function
1448     * @param _termParams Array containing:
1449     *        0. _termDuration Duration in seconds per term
1450     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for guardian on-boarding)
1451     */
1452     constructor(uint64[2] memory _termParams) public {
1453         uint64 _termDuration = _termParams[0];
1454         uint64 _firstTermStartTime = _termParams[1];
1455 
1456         require(_termDuration < MAX_TERM_DURATION, ERROR_TERM_DURATION_TOO_LONG);
1457         require(_firstTermStartTime >= getTimestamp64() + _termDuration, ERROR_BAD_FIRST_TERM_START_TIME);
1458         require(_firstTermStartTime <= getTimestamp64() + MAX_FIRST_TERM_DELAY_PERIOD, ERROR_BAD_FIRST_TERM_START_TIME);
1459 
1460         termDuration = _termDuration;
1461 
1462         // No need for SafeMath: we already checked values above
1463         terms[0].startTime = _firstTermStartTime - _termDuration;
1464     }
1465 
1466     /**
1467     * @notice Ensure that the current term of the Court is up-to-date. If the Court is outdated by more than `MAX_AUTO_TERM_TRANSITIONS_ALLOWED`
1468     *         terms, the heartbeat function must be called manually instead.
1469     * @return Identification number of the current term
1470     */
1471     function ensureCurrentTerm() external returns (uint64) {
1472         return _ensureCurrentTerm();
1473     }
1474 
1475     /**
1476     * @notice Transition up to `_maxRequestedTransitions` terms
1477     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
1478     * @return Identification number of the term ID after executing the heartbeat transitions
1479     */
1480     function heartbeat(uint64 _maxRequestedTransitions) external returns (uint64) {
1481         return _heartbeat(_maxRequestedTransitions);
1482     }
1483 
1484     /**
1485     * @notice Ensure that a certain term has its randomness set. As we allow to draft disputes requested for previous terms, if there
1486     *      were mined more than 256 blocks for the current term, the blockhash of its randomness BN is no longer available, given
1487     *      round will be able to be drafted in the following term.
1488     * @return Randomness of the current term
1489     */
1490     function ensureCurrentTermRandomness() external returns (bytes32) {
1491         // If the randomness for the given term was already computed, return
1492         uint64 currentTermId = termId;
1493         Term storage term = terms[currentTermId];
1494         bytes32 termRandomness = term.randomness;
1495         if (termRandomness != bytes32(0)) {
1496             return termRandomness;
1497         }
1498 
1499         // Compute term randomness
1500         bytes32 newRandomness = _computeTermRandomness(currentTermId);
1501         require(newRandomness != bytes32(0), ERROR_TERM_RANDOMNESS_UNAVAILABLE);
1502         term.randomness = newRandomness;
1503         return newRandomness;
1504     }
1505 
1506     /**
1507     * @dev Tell the term duration of the Court
1508     * @return Duration in seconds of the Court term
1509     */
1510     function getTermDuration() external view returns (uint64) {
1511         return termDuration;
1512     }
1513 
1514     /**
1515     * @dev Tell the last ensured term identification number
1516     * @return Identification number of the last ensured term
1517     */
1518     function getLastEnsuredTermId() external view returns (uint64) {
1519         return _lastEnsuredTermId();
1520     }
1521 
1522     /**
1523     * @dev Tell the current term identification number. Note that there may be pending term transitions.
1524     * @return Identification number of the current term
1525     */
1526     function getCurrentTermId() external view returns (uint64) {
1527         return _currentTermId();
1528     }
1529 
1530     /**
1531     * @dev Tell the number of terms the Court should transition to be up-to-date
1532     * @return Number of terms the Court should transition to be up-to-date
1533     */
1534     function getNeededTermTransitions() external view returns (uint64) {
1535         return _neededTermTransitions();
1536     }
1537 
1538     /**
1539     * @dev Tell the information related to a term based on its ID. Note that if the term has not been reached, the
1540     *      information returned won't be computed yet. This function allows querying future terms that were not computed yet.
1541     * @param _termId ID of the term being queried
1542     * @return startTime Term start time
1543     * @return randomnessBN Block number used for randomness in the requested term
1544     * @return randomness Randomness computed for the requested term
1545     */
1546     function getTerm(uint64 _termId) external view returns (uint64 startTime, uint64 randomnessBN, bytes32 randomness) {
1547         Term storage term = terms[_termId];
1548         return (term.startTime, term.randomnessBN, term.randomness);
1549     }
1550 
1551     /**
1552     * @dev Tell the randomness of a term even if it wasn't computed yet
1553     * @param _termId Identification number of the term being queried
1554     * @return Randomness of the requested term
1555     */
1556     function getTermRandomness(uint64 _termId) external view termExists(_termId) returns (bytes32) {
1557         return _computeTermRandomness(_termId);
1558     }
1559 
1560     /**
1561     * @dev Internal function to ensure that the current term of the Court is up-to-date. If the Court is outdated by more than
1562     *      `MAX_AUTO_TERM_TRANSITIONS_ALLOWED` terms, the heartbeat function must be called manually.
1563     * @return Identification number of the resultant term ID after executing the corresponding transitions
1564     */
1565     function _ensureCurrentTerm() internal returns (uint64) {
1566         // Check the required number of transitions does not exceeds the max allowed number to be processed automatically
1567         uint64 requiredTransitions = _neededTermTransitions();
1568         require(requiredTransitions <= MAX_AUTO_TERM_TRANSITIONS_ALLOWED, ERROR_TOO_MANY_TRANSITIONS);
1569 
1570         // If there are no transitions pending, return the last ensured term id
1571         if (uint256(requiredTransitions) == 0) {
1572             return termId;
1573         }
1574 
1575         // Process transition if there is at least one pending
1576         return _heartbeat(requiredTransitions);
1577     }
1578 
1579     /**
1580     * @dev Internal function to transition the Court terms up to a requested number of terms
1581     * @param _maxRequestedTransitions Max number of term transitions allowed by the sender
1582     * @return Identification number of the resultant term ID after executing the requested transitions
1583     */
1584     function _heartbeat(uint64 _maxRequestedTransitions) internal returns (uint64) {
1585         // Transition the minimum number of terms between the amount requested and the amount actually needed
1586         uint64 neededTransitions = _neededTermTransitions();
1587         uint256 transitions = uint256(_maxRequestedTransitions < neededTransitions ? _maxRequestedTransitions : neededTransitions);
1588         require(transitions > 0, ERROR_INVALID_TRANSITION_TERMS);
1589 
1590         uint64 blockNumber = getBlockNumber64();
1591         uint64 previousTermId = termId;
1592         uint64 currentTermId = previousTermId;
1593         for (uint256 transition = 1; transition <= transitions; transition++) {
1594             // Term IDs are incremented by one based on the number of time periods since the Court started. Since time is represented in uint64,
1595             // even if we chose the minimum duration possible for a term (1 second), we can ensure terms will never reach 2^64 since time is
1596             // already assumed to fit in uint64.
1597             Term storage previousTerm = terms[currentTermId++];
1598             Term storage currentTerm = terms[currentTermId];
1599             _onTermTransitioned(currentTermId);
1600 
1601             // Set the start time of the new term. Note that we are using a constant term duration value to guarantee
1602             // equally long terms, regardless of heartbeats.
1603             currentTerm.startTime = previousTerm.startTime.add(termDuration);
1604 
1605             // In order to draft a random number of guardians in a term, we use a randomness factor for each term based on a
1606             // block number that is set once the term has started. Note that this information could not be known beforehand.
1607             currentTerm.randomnessBN = blockNumber + 1;
1608         }
1609 
1610         termId = currentTermId;
1611         emit Heartbeat(previousTermId, currentTermId);
1612         return currentTermId;
1613     }
1614 
1615     /**
1616     * @dev Internal function to delay the first term start time only if it wasn't reached yet
1617     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
1618     */
1619     function _delayStartTime(uint64 _newFirstTermStartTime) internal {
1620         require(_currentTermId() == 0, ERROR_CANNOT_DELAY_STARTED_COURT);
1621 
1622         Term storage term = terms[0];
1623         uint64 currentFirstTermStartTime = term.startTime.add(termDuration);
1624         require(_newFirstTermStartTime > currentFirstTermStartTime, ERROR_CANNOT_DELAY_PAST_START_TIME);
1625 
1626         // No need for SafeMath: we already checked above that `_newFirstTermStartTime` > `currentFirstTermStartTime` >= `termDuration`
1627         term.startTime = _newFirstTermStartTime - termDuration;
1628         emit StartTimeDelayed(currentFirstTermStartTime, _newFirstTermStartTime);
1629     }
1630 
1631     /**
1632     * @dev Internal function to notify when a term has been transitioned. This function must be overridden to provide custom behavior.
1633     * @param _termId Identification number of the new current term that has been transitioned
1634     */
1635     function _onTermTransitioned(uint64 _termId) internal;
1636 
1637     /**
1638     * @dev Internal function to tell the last ensured term identification number
1639     * @return Identification number of the last ensured term
1640     */
1641     function _lastEnsuredTermId() internal view returns (uint64) {
1642         return termId;
1643     }
1644 
1645     /**
1646     * @dev Internal function to tell the current term identification number. Note that there may be pending term transitions.
1647     * @return Identification number of the current term
1648     */
1649     function _currentTermId() internal view returns (uint64) {
1650         return termId.add(_neededTermTransitions());
1651     }
1652 
1653     /**
1654     * @dev Internal function to tell the number of terms the Court should transition to be up-to-date
1655     * @return Number of terms the Court should transition to be up-to-date
1656     */
1657     function _neededTermTransitions() internal view returns (uint64) {
1658         // Note that the Court is always initialized providing a start time for the first-term in the future. If that's the case,
1659         // no term transitions are required.
1660         uint64 currentTermStartTime = terms[termId].startTime;
1661         if (getTimestamp64() < currentTermStartTime) {
1662             return uint64(0);
1663         }
1664 
1665         // No need for SafeMath: we already know that the start time of the current term is in the past
1666         return (getTimestamp64() - currentTermStartTime) / termDuration;
1667     }
1668 
1669     /**
1670     * @dev Internal function to compute the randomness that will be used to draft guardians for the given term. This
1671     *      function assumes the given term exists. To determine the randomness factor for a term we use the hash of a
1672     *      block number that is set once the term has started to ensure it cannot be known beforehand. Note that the
1673     *      hash function being used only works for the 256 most recent block numbers.
1674     * @param _termId Identification number of the term being queried
1675     * @return Randomness computed for the given term
1676     */
1677     function _computeTermRandomness(uint64 _termId) internal view returns (bytes32) {
1678         Term storage term = terms[_termId];
1679         require(getBlockNumber64() > term.randomnessBN, ERROR_TERM_RANDOMNESS_NOT_YET);
1680         return blockhash(term.randomnessBN);
1681     }
1682 }
1683 
1684 interface IConfig {
1685 
1686     /**
1687     * @dev Tell the full Court configuration parameters at a certain term
1688     * @param _termId Identification number of the term querying the Court config of
1689     * @return token Address of the token used to pay for fees
1690     * @return fees Array containing:
1691     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1692     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1693     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1694     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1695     *         0. evidenceTerms Max submitting evidence period duration in terms
1696     *         1. commitTerms Commit period duration in terms
1697     *         2. revealTerms Reveal period duration in terms
1698     *         3. appealTerms Appeal period duration in terms
1699     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1700     * @return pcts Array containing:
1701     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1702     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1703     * @return roundParams Array containing params for rounds:
1704     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1705     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1706     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1707     * @return appealCollateralParams Array containing params for appeal collateral:
1708     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1709     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1710     * @return minActiveBalance Minimum amount of tokens guardians have to activate to participate in the Court
1711     */
1712     function getConfig(uint64 _termId) external view
1713         returns (
1714             IERC20 feeToken,
1715             uint256[3] memory fees,
1716             uint64[5] memory roundStateDurations,
1717             uint16[2] memory pcts,
1718             uint64[4] memory roundParams,
1719             uint256[2] memory appealCollateralParams,
1720             uint256 minActiveBalance
1721         );
1722 
1723     /**
1724     * @dev Tell the draft config at a certain term
1725     * @param _termId Identification number of the term querying the draft config of
1726     * @return feeToken Address of the token used to pay for fees
1727     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
1728     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1729     */
1730     function getDraftConfig(uint64 _termId) external view returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
1731 
1732     /**
1733     * @dev Tell the min active balance config at a certain term
1734     * @param _termId Term querying the min active balance config of
1735     * @return Minimum amount of tokens guardians have to activate to participate in the Court
1736     */
1737     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
1738 }
1739 
1740 contract CourtConfigData {
1741     struct Config {
1742         FeesConfig fees;                        // Full fees-related config
1743         DisputesConfig disputes;                // Full disputes-related config
1744         uint256 minActiveBalance;               // Minimum amount of tokens guardians have to activate to participate in the Court
1745     }
1746 
1747     struct FeesConfig {
1748         IERC20 token;                           // ERC20 token to be used for the fees of the Court
1749         uint16 finalRoundReduction;             // Permyriad of fees reduction applied for final appeal round (‱ - 1/10,000)
1750         uint256 guardianFee;                    // Amount of tokens paid to draft a guardian to adjudicate a dispute
1751         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting guardians
1752         uint256 settleFee;                      // Amount of tokens paid per round to cover the costs of slashing guardians
1753     }
1754 
1755     struct DisputesConfig {
1756         uint64 evidenceTerms;                   // Max submitting evidence period duration in terms
1757         uint64 commitTerms;                     // Committing period duration in terms
1758         uint64 revealTerms;                     // Revealing period duration in terms
1759         uint64 appealTerms;                     // Appealing period duration in terms
1760         uint64 appealConfirmTerms;              // Confirmation appeal period duration in terms
1761         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1762         uint64 firstRoundGuardiansNumber;       // Number of guardians drafted on first round
1763         uint64 appealStepFactor;                // Factor in which the guardians number is increased on each appeal
1764         uint64 finalRoundLockTerms;             // Period a coherent guardian in the final round will remain locked
1765         uint256 maxRegularAppealRounds;         // Before the final appeal
1766         uint256 appealCollateralFactor;         // Permyriad multiple of dispute fees required to appeal a preliminary ruling (‱ - 1/10,000)
1767         uint256 appealConfirmCollateralFactor;  // Permyriad multiple of dispute fees required to confirm appeal (‱ - 1/10,000)
1768     }
1769 
1770     struct DraftConfig {
1771         IERC20 feeToken;                         // ERC20 token to be used for the fees of the Court
1772         uint16 penaltyPct;                      // Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1773         uint256 draftFee;                       // Amount of tokens paid per round to cover the costs of drafting guardians
1774     }
1775 }
1776 
1777 contract CourtConfig is IConfig, CourtConfigData {
1778     using SafeMath64 for uint64;
1779     using PctHelpers for uint256;
1780 
1781     string private constant ERROR_TOO_OLD_TERM = "CONF_TOO_OLD_TERM";
1782     string private constant ERROR_INVALID_PENALTY_PCT = "CONF_INVALID_PENALTY_PCT";
1783     string private constant ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT = "CONF_INVALID_FINAL_ROUND_RED_PCT";
1784     string private constant ERROR_INVALID_MAX_APPEAL_ROUNDS = "CONF_INVALID_MAX_APPEAL_ROUNDS";
1785     string private constant ERROR_LARGE_ROUND_PHASE_DURATION = "CONF_LARGE_ROUND_PHASE_DURATION";
1786     string private constant ERROR_BAD_INITIAL_GUARDIANS_NUMBER = "CONF_BAD_INITIAL_GUARDIAN_NUMBER";
1787     string private constant ERROR_BAD_APPEAL_STEP_FACTOR = "CONF_BAD_APPEAL_STEP_FACTOR";
1788     string private constant ERROR_ZERO_COLLATERAL_FACTOR = "CONF_ZERO_COLLATERAL_FACTOR";
1789     string private constant ERROR_ZERO_MIN_ACTIVE_BALANCE = "CONF_ZERO_MIN_ACTIVE_BALANCE";
1790 
1791     // Max number of terms that each of the different adjudication states can last (if lasted 1h, this would be a year)
1792     uint64 internal constant MAX_ADJ_STATE_DURATION = 8670;
1793 
1794     // Cap the max number of regular appeal rounds
1795     uint256 internal constant MAX_REGULAR_APPEAL_ROUNDS_LIMIT = 10;
1796 
1797     // Future term ID in which a config change has been scheduled
1798     uint64 private configChangeTermId;
1799 
1800     // List of all the configs used in the Court
1801     Config[] private configs;
1802 
1803     // List of configs indexed by id
1804     mapping (uint64 => uint256) private configIdByTerm;
1805 
1806     event NewConfig(uint64 fromTermId, uint64 courtConfigId);
1807 
1808     /**
1809     * @dev Constructor function
1810     * @param _feeToken Address of the token contract that is used to pay for fees
1811     * @param _fees Array containing:
1812     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1813     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1814     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1815     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1816     *        0. evidenceTerms Max submitting evidence period duration in terms
1817     *        1. commitTerms Commit period duration in terms
1818     *        2. revealTerms Reveal period duration in terms
1819     *        3. appealTerms Appeal period duration in terms
1820     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1821     * @param _pcts Array containing:
1822     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1823     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1824     * @param _roundParams Array containing params for rounds:
1825     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1826     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1827     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1828     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1829     * @param _appealCollateralParams Array containing params for appeal collateral:
1830     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1831     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1832     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
1833     */
1834     constructor(
1835         IERC20 _feeToken,
1836         uint256[3] memory _fees,
1837         uint64[5] memory _roundStateDurations,
1838         uint16[2] memory _pcts,
1839         uint64[4] memory _roundParams,
1840         uint256[2] memory _appealCollateralParams,
1841         uint256 _minActiveBalance
1842     )
1843         public
1844     {
1845         // Leave config at index 0 empty for non-scheduled config changes
1846         configs.length = 1;
1847         _setConfig(
1848             0,
1849             0,
1850             _feeToken,
1851             _fees,
1852             _roundStateDurations,
1853             _pcts,
1854             _roundParams,
1855             _appealCollateralParams,
1856             _minActiveBalance
1857         );
1858     }
1859 
1860     /**
1861     * @dev Tell the full Court configuration parameters at a certain term
1862     * @param _termId Identification number of the term querying the Court config of
1863     * @return token Address of the token used to pay for fees
1864     * @return fees Array containing:
1865     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1866     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1867     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1868     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1869     *         0. evidenceTerms Max submitting evidence period duration in terms
1870     *         1. commitTerms Commit period duration in terms
1871     *         2. revealTerms Reveal period duration in terms
1872     *         3. appealTerms Appeal period duration in terms
1873     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
1874     * @return pcts Array containing:
1875     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1876     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1877     * @return roundParams Array containing params for rounds:
1878     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1879     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1880     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1881     * @return appealCollateralParams Array containing params for appeal collateral:
1882     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1883     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1884     * @return minActiveBalance Minimum amount of tokens guardians have to activate to participate in the Court
1885     */
1886     function getConfig(uint64 _termId) external view
1887         returns (
1888             IERC20 feeToken,
1889             uint256[3] memory fees,
1890             uint64[5] memory roundStateDurations,
1891             uint16[2] memory pcts,
1892             uint64[4] memory roundParams,
1893             uint256[2] memory appealCollateralParams,
1894             uint256 minActiveBalance
1895         );
1896 
1897     /**
1898     * @dev Tell the draft config at a certain term
1899     * @param _termId Identification number of the term querying the draft config of
1900     * @return feeToken Address of the token used to pay for fees
1901     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
1902     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1903     */
1904     function getDraftConfig(uint64 _termId) external view returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct);
1905 
1906     /**
1907     * @dev Tell the min active balance config at a certain term
1908     * @param _termId Term querying the min active balance config of
1909     * @return Minimum amount of tokens guardians have to activate to participate in the Court
1910     */
1911     function getMinActiveBalance(uint64 _termId) external view returns (uint256);
1912 
1913     /**
1914     * @dev Tell the term identification number of the next scheduled config change
1915     * @return Term identification number of the next scheduled config change
1916     */
1917     function getConfigChangeTermId() external view returns (uint64) {
1918         return configChangeTermId;
1919     }
1920 
1921     /**
1922     * @dev Internal to make sure to set a config for the new term, it will copy the previous term config if none
1923     * @param _termId Identification number of the new current term that has been transitioned
1924     */
1925     function _ensureTermConfig(uint64 _termId) internal {
1926         // If the term being transitioned had no config change scheduled, keep the previous one
1927         uint256 currentConfigId = configIdByTerm[_termId];
1928         if (currentConfigId == 0) {
1929             uint256 previousConfigId = configIdByTerm[_termId.sub(1)];
1930             configIdByTerm[_termId] = previousConfigId;
1931         }
1932     }
1933 
1934     /**
1935     * @dev Assumes that sender it's allowed (either it's from governor or it's on init)
1936     * @param _termId Identification number of the current Court term
1937     * @param _fromTermId Identification number of the term in which the config will be effective at
1938     * @param _feeToken Address of the token contract that is used to pay for fees.
1939     * @param _fees Array containing:
1940     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
1941     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
1942     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
1943     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
1944     *        0. evidenceTerms Max submitting evidence period duration in terms
1945     *        1. commitTerms Commit period duration in terms
1946     *        2. revealTerms Reveal period duration in terms
1947     *        3. appealTerms Appeal period duration in terms
1948     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
1949     * @param _pcts Array containing:
1950     *        0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
1951     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
1952     * @param _roundParams Array containing params for rounds:
1953     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
1954     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
1955     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
1956     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
1957     * @param _appealCollateralParams Array containing params for appeal collateral:
1958     *        0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
1959     *        1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
1960     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
1961     */
1962     function _setConfig(
1963         uint64 _termId,
1964         uint64 _fromTermId,
1965         IERC20 _feeToken,
1966         uint256[3] memory _fees,
1967         uint64[5] memory _roundStateDurations,
1968         uint16[2] memory _pcts,
1969         uint64[4] memory _roundParams,
1970         uint256[2] memory _appealCollateralParams,
1971         uint256 _minActiveBalance
1972     )
1973         internal
1974     {
1975         // If the current term is not zero, changes must be scheduled at least after the current period.
1976         // No need to ensure delays for on-going disputes since these already use their creation term for that.
1977         require(_termId == 0 || _fromTermId > _termId, ERROR_TOO_OLD_TERM);
1978 
1979         // Make sure appeal collateral factors are greater than zero
1980         require(_appealCollateralParams[0] > 0 && _appealCollateralParams[1] > 0, ERROR_ZERO_COLLATERAL_FACTOR);
1981 
1982         // Make sure the given penalty and final round reduction pcts are not greater than 100%
1983         require(PctHelpers.isValid(_pcts[0]), ERROR_INVALID_PENALTY_PCT);
1984         require(PctHelpers.isValid(_pcts[1]), ERROR_INVALID_FINAL_ROUND_REDUCTION_PCT);
1985 
1986         // Disputes must request at least one guardian to be drafted initially
1987         require(_roundParams[0] > 0, ERROR_BAD_INITIAL_GUARDIANS_NUMBER);
1988 
1989         // Prevent that further rounds have zero guardians
1990         require(_roundParams[1] > 0, ERROR_BAD_APPEAL_STEP_FACTOR);
1991 
1992         // Make sure the max number of appeals allowed does not reach the limit
1993         uint256 _maxRegularAppealRounds = _roundParams[2];
1994         bool isMaxAppealRoundsValid = _maxRegularAppealRounds > 0 && _maxRegularAppealRounds <= MAX_REGULAR_APPEAL_ROUNDS_LIMIT;
1995         require(isMaxAppealRoundsValid, ERROR_INVALID_MAX_APPEAL_ROUNDS);
1996 
1997         // Make sure each adjudication round phase duration is valid
1998         for (uint i = 0; i < _roundStateDurations.length; i++) {
1999             require(_roundStateDurations[i] > 0 && _roundStateDurations[i] < MAX_ADJ_STATE_DURATION, ERROR_LARGE_ROUND_PHASE_DURATION);
2000         }
2001 
2002         // Make sure min active balance is not zero
2003         require(_minActiveBalance > 0, ERROR_ZERO_MIN_ACTIVE_BALANCE);
2004 
2005         // If there was a config change already scheduled, reset it (in that case we will overwrite last array item).
2006         // Otherwise, schedule a new config.
2007         if (configChangeTermId > _termId) {
2008             configIdByTerm[configChangeTermId] = 0;
2009         } else {
2010             configs.length++;
2011         }
2012 
2013         uint64 courtConfigId = uint64(configs.length - 1);
2014         Config storage config = configs[courtConfigId];
2015 
2016         config.fees = FeesConfig({
2017             token: _feeToken,
2018             guardianFee: _fees[0],
2019             draftFee: _fees[1],
2020             settleFee: _fees[2],
2021             finalRoundReduction: _pcts[1]
2022         });
2023 
2024         config.disputes = DisputesConfig({
2025             evidenceTerms: _roundStateDurations[0],
2026             commitTerms: _roundStateDurations[1],
2027             revealTerms: _roundStateDurations[2],
2028             appealTerms: _roundStateDurations[3],
2029             appealConfirmTerms: _roundStateDurations[4],
2030             penaltyPct: _pcts[0],
2031             firstRoundGuardiansNumber: _roundParams[0],
2032             appealStepFactor: _roundParams[1],
2033             maxRegularAppealRounds: _maxRegularAppealRounds,
2034             finalRoundLockTerms: _roundParams[3],
2035             appealCollateralFactor: _appealCollateralParams[0],
2036             appealConfirmCollateralFactor: _appealCollateralParams[1]
2037         });
2038 
2039         config.minActiveBalance = _minActiveBalance;
2040 
2041         configIdByTerm[_fromTermId] = courtConfigId;
2042         configChangeTermId = _fromTermId;
2043 
2044         emit NewConfig(_fromTermId, courtConfigId);
2045     }
2046 
2047     /**
2048     * @dev Internal function to get the Court config for a given term
2049     * @param _termId Identification number of the term querying the Court config of
2050     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2051     * @return token Address of the token used to pay for fees
2052     * @return fees Array containing:
2053     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
2054     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
2055     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
2056     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2057     *         0. evidenceTerms Max submitting evidence period duration in terms
2058     *         1. commitTerms Commit period duration in terms
2059     *         2. revealTerms Reveal period duration in terms
2060     *         3. appealTerms Appeal period duration in terms
2061     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
2062     * @return pcts Array containing:
2063     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
2064     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2065     * @return roundParams Array containing params for rounds:
2066     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
2067     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
2068     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2069     *         3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
2070     * @return appealCollateralParams Array containing params for appeal collateral:
2071     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
2072     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
2073     * @return minActiveBalance Minimum amount of guardian tokens that can be activated
2074     */
2075     function _getConfigAt(uint64 _termId, uint64 _lastEnsuredTermId) internal view
2076         returns (
2077             IERC20 feeToken,
2078             uint256[3] memory fees,
2079             uint64[5] memory roundStateDurations,
2080             uint16[2] memory pcts,
2081             uint64[4] memory roundParams,
2082             uint256[2] memory appealCollateralParams,
2083             uint256 minActiveBalance
2084         )
2085     {
2086         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
2087 
2088         FeesConfig storage feesConfig = config.fees;
2089         feeToken = feesConfig.token;
2090         fees = [feesConfig.guardianFee, feesConfig.draftFee, feesConfig.settleFee];
2091 
2092         DisputesConfig storage disputesConfig = config.disputes;
2093         roundStateDurations = [
2094             disputesConfig.evidenceTerms,
2095             disputesConfig.commitTerms,
2096             disputesConfig.revealTerms,
2097             disputesConfig.appealTerms,
2098             disputesConfig.appealConfirmTerms
2099         ];
2100         pcts = [disputesConfig.penaltyPct, feesConfig.finalRoundReduction];
2101         roundParams = [
2102             disputesConfig.firstRoundGuardiansNumber,
2103             disputesConfig.appealStepFactor,
2104             uint64(disputesConfig.maxRegularAppealRounds),
2105             disputesConfig.finalRoundLockTerms
2106         ];
2107         appealCollateralParams = [disputesConfig.appealCollateralFactor, disputesConfig.appealConfirmCollateralFactor];
2108 
2109         minActiveBalance = config.minActiveBalance;
2110     }
2111 
2112     /**
2113     * @dev Tell the draft config at a certain term
2114     * @param _termId Identification number of the term querying the draft config of
2115     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2116     * @return feeToken Address of the token used to pay for fees
2117     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
2118     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
2119     */
2120     function _getDraftConfig(uint64 _termId,  uint64 _lastEnsuredTermId) internal view
2121         returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct)
2122     {
2123         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
2124         return (config.fees.token, config.fees.draftFee, config.disputes.penaltyPct);
2125     }
2126 
2127     /**
2128     * @dev Internal function to get the min active balance config for a given term
2129     * @param _termId Identification number of the term querying the min active balance config of
2130     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2131     * @return Minimum amount of guardian tokens that can be activated at the given term
2132     */
2133     function _getMinActiveBalance(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
2134         Config storage config = _getConfigFor(_termId, _lastEnsuredTermId);
2135         return config.minActiveBalance;
2136     }
2137 
2138     /**
2139     * @dev Internal function to get the Court config for a given term
2140     * @param _termId Identification number of the term querying the min active balance config of
2141     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2142     * @return Court config for the given term
2143     */
2144     function _getConfigFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (Config storage) {
2145         uint256 id = _getConfigIdFor(_termId, _lastEnsuredTermId);
2146         return configs[id];
2147     }
2148 
2149     /**
2150     * @dev Internal function to get the Court config ID for a given term
2151     * @param _termId Identification number of the term querying the Court config of
2152     * @param _lastEnsuredTermId Identification number of the last ensured term of the Court
2153     * @return Identification number of the config for the given terms
2154     */
2155     function _getConfigIdFor(uint64 _termId, uint64 _lastEnsuredTermId) internal view returns (uint256) {
2156         // If the given term is lower or equal to the last ensured Court term, it is safe to use a past Court config
2157         if (_termId <= _lastEnsuredTermId) {
2158             return configIdByTerm[_termId];
2159         }
2160 
2161         // If the given term is in the future but there is a config change scheduled before it, use the incoming config
2162         uint64 scheduledChangeTermId = configChangeTermId;
2163         if (scheduledChangeTermId <= _termId) {
2164             return configIdByTerm[scheduledChangeTermId];
2165         }
2166 
2167         // If no changes are scheduled, use the Court config of the last ensured term
2168         return configIdByTerm[_lastEnsuredTermId];
2169     }
2170 }
2171 
2172 /*
2173  * SPDX-License-Identifier:    MIT
2174  */
2175 interface IArbitrator {
2176     /**
2177     * @dev Create a dispute over the Arbitrable sender with a number of possible rulings
2178     * @param _possibleRulings Number of possible rulings allowed for the dispute
2179     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2180     * @return Dispute identification number
2181     */
2182     function createDispute(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256);
2183 
2184     /**
2185     * @dev Submit evidence for a dispute
2186     * @param _disputeId Id of the dispute in the Court
2187     * @param _submitter Address of the account submitting the evidence
2188     * @param _evidence Data submitted for the evidence related to the dispute
2189     */
2190     function submitEvidence(uint256 _disputeId, address _submitter, bytes calldata _evidence) external;
2191 
2192     /**
2193     * @dev Close the evidence period of a dispute
2194     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2195     */
2196     function closeEvidencePeriod(uint256 _disputeId) external;
2197 
2198     /**
2199     * @notice Rule dispute #`_disputeId` if ready
2200     * @param _disputeId Identification number of the dispute to be ruled
2201     * @return subject Subject associated to the dispute
2202     * @return ruling Ruling number computed for the given dispute
2203     */
2204     function rule(uint256 _disputeId) external returns (address subject, uint256 ruling);
2205 
2206     /**
2207     * @dev Tell the dispute fees information to create a dispute
2208     * @return recipient Address where the corresponding dispute fees must be transferred to
2209     * @return feeToken ERC20 token used for the fees
2210     * @return feeAmount Total amount of fees that must be allowed to the recipient
2211     */
2212     function getDisputeFees() external view returns (address recipient, IERC20 feeToken, uint256 feeAmount);
2213 
2214     /**
2215     * @dev Tell the payments recipient address
2216     * @return Address of the payments recipient module
2217     */
2218     function getPaymentsRecipient() external view returns (address);
2219 }
2220 
2221 /*
2222  * SPDX-License-Identifier:    MIT
2223  */
2224 /**
2225 * @dev The Arbitrable instances actually don't require to follow any specific interface.
2226 *      Note that this is actually optional, although it does allow the Court to at least have a way to identify a specific set of instances.
2227 */
2228 contract IArbitrable {
2229     /**
2230     * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
2231     * @param arbitrator IArbitrator instance ruling the dispute
2232     * @param disputeId Identification number of the dispute being ruled by the arbitrator
2233     * @param ruling Ruling given by the arbitrator
2234     */
2235     event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);
2236 }
2237 
2238 interface IDisputeManager {
2239     enum DisputeState {
2240         PreDraft,
2241         Adjudicating,
2242         Ruled
2243     }
2244 
2245     enum AdjudicationState {
2246         Invalid,
2247         Committing,
2248         Revealing,
2249         Appealing,
2250         ConfirmingAppeal,
2251         Ended
2252     }
2253 
2254     /**
2255     * @dev Create a dispute to be drafted in a future term
2256     * @param _subject Arbitrable instance creating the dispute
2257     * @param _possibleRulings Number of possible rulings allowed for the drafted guardians to vote on the dispute
2258     * @param _metadata Optional metadata that can be used to provide additional information on the dispute to be created
2259     * @return Dispute identification number
2260     */
2261     function createDispute(IArbitrable _subject, uint8 _possibleRulings, bytes calldata _metadata) external returns (uint256);
2262 
2263     /**
2264     * @dev Submit evidence for a dispute
2265     * @param _subject Arbitrable instance submitting the dispute
2266     * @param _disputeId Identification number of the dispute receiving new evidence
2267     * @param _submitter Address of the account submitting the evidence
2268     * @param _evidence Data submitted for the evidence of the dispute
2269     */
2270     function submitEvidence(IArbitrable _subject, uint256 _disputeId, address _submitter, bytes calldata _evidence) external;
2271 
2272     /**
2273     * @dev Close the evidence period of a dispute
2274     * @param _subject IArbitrable instance requesting to close the evidence submission period
2275     * @param _disputeId Identification number of the dispute to close its evidence submitting period
2276     */
2277     function closeEvidencePeriod(IArbitrable _subject, uint256 _disputeId) external;
2278 
2279     /**
2280     * @dev Draft guardians for the next round of a dispute
2281     * @param _disputeId Identification number of the dispute to be drafted
2282     */
2283     function draft(uint256 _disputeId) external;
2284 
2285     /**
2286     * @dev Appeal round of a dispute in favor of a certain ruling
2287     * @param _disputeId Identification number of the dispute being appealed
2288     * @param _roundId Identification number of the dispute round being appealed
2289     * @param _ruling Ruling appealing a dispute round in favor of
2290     */
2291     function createAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
2292 
2293     /**
2294     * @dev Confirm appeal for a round of a dispute in favor of a ruling
2295     * @param _disputeId Identification number of the dispute confirming an appeal of
2296     * @param _roundId Identification number of the dispute round confirming an appeal of
2297     * @param _ruling Ruling being confirmed against a dispute round appeal
2298     */
2299     function confirmAppeal(uint256 _disputeId, uint256 _roundId, uint8 _ruling) external;
2300 
2301     /**
2302     * @dev Compute the final ruling for a dispute
2303     * @param _disputeId Identification number of the dispute to compute its final ruling
2304     * @return subject Arbitrable instance associated to the dispute
2305     * @return finalRuling Final ruling decided for the given dispute
2306     */
2307     function computeRuling(uint256 _disputeId) external returns (IArbitrable subject, uint8 finalRuling);
2308 
2309     /**
2310     * @dev Settle penalties for a round of a dispute
2311     * @param _disputeId Identification number of the dispute to settle penalties for
2312     * @param _roundId Identification number of the dispute round to settle penalties for
2313     * @param _guardiansToSettle Maximum number of guardians to be slashed in this call
2314     */
2315     function settlePenalties(uint256 _disputeId, uint256 _roundId, uint256 _guardiansToSettle) external;
2316 
2317     /**
2318     * @dev Claim rewards for a round of a dispute for guardian
2319     * @dev For regular rounds, it will only reward winning guardians
2320     * @param _disputeId Identification number of the dispute to settle rewards for
2321     * @param _roundId Identification number of the dispute round to settle rewards for
2322     * @param _guardian Address of the guardian to settle their rewards
2323     */
2324     function settleReward(uint256 _disputeId, uint256 _roundId, address _guardian) external;
2325 
2326     /**
2327     * @dev Settle appeal deposits for a round of a dispute
2328     * @param _disputeId Identification number of the dispute to settle appeal deposits for
2329     * @param _roundId Identification number of the dispute round to settle appeal deposits for
2330     */
2331     function settleAppealDeposit(uint256 _disputeId, uint256 _roundId) external;
2332 
2333     /**
2334     * @dev Tell the amount of token fees required to create a dispute
2335     * @return feeToken ERC20 token used for the fees
2336     * @return feeAmount Total amount of fees to be paid for a dispute at the given term
2337     */
2338     function getDisputeFees() external view returns (IERC20 feeToken, uint256 feeAmount);
2339 
2340     /**
2341     * @dev Tell information of a certain dispute
2342     * @param _disputeId Identification number of the dispute being queried
2343     * @return subject Arbitrable subject being disputed
2344     * @return possibleRulings Number of possible rulings allowed for the drafted guardians to vote on the dispute
2345     * @return state Current state of the dispute being queried: pre-draft, adjudicating, or ruled
2346     * @return finalRuling The winning ruling in case the dispute is finished
2347     * @return lastRoundId Identification number of the last round created for the dispute
2348     * @return createTermId Identification number of the term when the dispute was created
2349     */
2350     function getDispute(uint256 _disputeId) external view
2351         returns (IArbitrable subject, uint8 possibleRulings, DisputeState state, uint8 finalRuling, uint256 lastRoundId, uint64 createTermId);
2352 
2353     /**
2354     * @dev Tell information of a certain adjudication round
2355     * @param _disputeId Identification number of the dispute being queried
2356     * @param _roundId Identification number of the round being queried
2357     * @return draftTerm Term from which the requested round can be drafted
2358     * @return delayedTerms Number of terms the given round was delayed based on its requested draft term id
2359     * @return guardiansNumber Number of guardians requested for the round
2360     * @return selectedGuardians Number of guardians already selected for the requested round
2361     * @return settledPenalties Whether or not penalties have been settled for the requested round
2362     * @return collectedTokens Amount of guardian tokens that were collected from slashed guardians for the requested round
2363     * @return coherentGuardians Number of guardians that voted in favor of the final ruling in the requested round
2364     * @return state Adjudication state of the requested round
2365     */
2366     function getRound(uint256 _disputeId, uint256 _roundId) external view
2367         returns (
2368             uint64 draftTerm,
2369             uint64 delayedTerms,
2370             uint64 guardiansNumber,
2371             uint64 selectedGuardians,
2372             uint256 guardianFees,
2373             bool settledPenalties,
2374             uint256 collectedTokens,
2375             uint64 coherentGuardians,
2376             AdjudicationState state
2377         );
2378 
2379     /**
2380     * @dev Tell appeal-related information of a certain adjudication round
2381     * @param _disputeId Identification number of the dispute being queried
2382     * @param _roundId Identification number of the round being queried
2383     * @return maker Address of the account appealing the given round
2384     * @return appealedRuling Ruling confirmed by the appealer of the given round
2385     * @return taker Address of the account confirming the appeal of the given round
2386     * @return opposedRuling Ruling confirmed by the appeal taker of the given round
2387     */
2388     function getAppeal(uint256 _disputeId, uint256 _roundId) external view
2389         returns (address maker, uint64 appealedRuling, address taker, uint64 opposedRuling);
2390 
2391     /**
2392     * @dev Tell information related to the next round due to an appeal of a certain round given.
2393     * @param _disputeId Identification number of the dispute being queried
2394     * @param _roundId Identification number of the round requesting the appeal details of
2395     * @return nextRoundStartTerm Term ID from which the next round will start
2396     * @return nextRoundGuardiansNumber Guardians number for the next round
2397     * @return newDisputeState New state for the dispute associated to the given round after the appeal
2398     * @return feeToken ERC20 token used for the next round fees
2399     * @return guardianFees Total amount of fees to be distributed between the winning guardians of the next round
2400     * @return totalFees Total amount of fees for a regular round at the given term
2401     * @return appealDeposit Amount to be deposit of fees for a regular round at the given term
2402     * @return confirmAppealDeposit Total amount of fees for a regular round at the given term
2403     */
2404     function getNextRoundDetails(uint256 _disputeId, uint256 _roundId) external view
2405         returns (
2406             uint64 nextRoundStartTerm,
2407             uint64 nextRoundGuardiansNumber,
2408             DisputeState newDisputeState,
2409             IERC20 feeToken,
2410             uint256 totalFees,
2411             uint256 guardianFees,
2412             uint256 appealDeposit,
2413             uint256 confirmAppealDeposit
2414         );
2415 
2416     /**
2417     * @dev Tell guardian-related information of a certain adjudication round
2418     * @param _disputeId Identification number of the dispute being queried
2419     * @param _roundId Identification number of the round being queried
2420     * @param _guardian Address of the guardian being queried
2421     * @return weight Guardian weight drafted for the requested round
2422     * @return rewarded Whether or not the given guardian was rewarded based on the requested round
2423     */
2424     function getGuardian(uint256 _disputeId, uint256 _roundId, address _guardian) external view returns (uint64 weight, bool rewarded);
2425 }
2426 
2427 contract Controller is IsContract, ModuleIds, CourtClock, CourtConfig, ACL {
2428     string private constant ERROR_SENDER_NOT_GOVERNOR = "CTR_SENDER_NOT_GOVERNOR";
2429     string private constant ERROR_INVALID_GOVERNOR_ADDRESS = "CTR_INVALID_GOVERNOR_ADDRESS";
2430     string private constant ERROR_MODULE_NOT_SET = "CTR_MODULE_NOT_SET";
2431     string private constant ERROR_MODULE_ALREADY_ENABLED = "CTR_MODULE_ALREADY_ENABLED";
2432     string private constant ERROR_MODULE_ALREADY_DISABLED = "CTR_MODULE_ALREADY_DISABLED";
2433     string private constant ERROR_DISPUTE_MANAGER_NOT_ACTIVE = "CTR_DISPUTE_MANAGER_NOT_ACTIVE";
2434     string private constant ERROR_CUSTOM_FUNCTION_NOT_SET = "CTR_CUSTOM_FUNCTION_NOT_SET";
2435     string private constant ERROR_IMPLEMENTATION_NOT_CONTRACT = "CTR_IMPLEMENTATION_NOT_CONTRACT";
2436     string private constant ERROR_INVALID_IMPLS_INPUT_LENGTH = "CTR_INVALID_IMPLS_INPUT_LENGTH";
2437 
2438     address private constant ZERO_ADDRESS = address(0);
2439 
2440     /**
2441     * @dev Governor of the whole system. Set of three addresses to recover funds, change configuration settings and setup modules
2442     */
2443     struct Governor {
2444         address funds;      // This address can be unset at any time. It is allowed to recover funds from the ControlledRecoverable modules
2445         address config;     // This address is meant not to be unset. It is allowed to change the different configurations of the whole system
2446         address modules;    // This address can be unset at any time. It is allowed to plug/unplug modules from the system
2447     }
2448 
2449     /**
2450     * @dev Module information
2451     */
2452     struct Module {
2453         bytes32 id;         // ID associated to a module
2454         bool disabled;      // Whether the module is disabled
2455     }
2456 
2457     // Governor addresses of the system
2458     Governor private governor;
2459 
2460     // List of current modules registered for the system indexed by ID
2461     mapping (bytes32 => address) internal currentModules;
2462 
2463     // List of all historical modules registered for the system indexed by address
2464     mapping (address => Module) internal allModules;
2465 
2466     // List of custom function targets indexed by signature
2467     mapping (bytes4 => address) internal customFunctions;
2468 
2469     event ModuleSet(bytes32 id, address addr);
2470     event ModuleEnabled(bytes32 id, address addr);
2471     event ModuleDisabled(bytes32 id, address addr);
2472     event CustomFunctionSet(bytes4 signature, address target);
2473     event FundsGovernorChanged(address previousGovernor, address currentGovernor);
2474     event ConfigGovernorChanged(address previousGovernor, address currentGovernor);
2475     event ModulesGovernorChanged(address previousGovernor, address currentGovernor);
2476 
2477     /**
2478     * @dev Ensure the msg.sender is the funds governor
2479     */
2480     modifier onlyFundsGovernor {
2481         require(msg.sender == governor.funds, ERROR_SENDER_NOT_GOVERNOR);
2482         _;
2483     }
2484 
2485     /**
2486     * @dev Ensure the msg.sender is the modules governor
2487     */
2488     modifier onlyConfigGovernor {
2489         require(msg.sender == governor.config, ERROR_SENDER_NOT_GOVERNOR);
2490         _;
2491     }
2492 
2493     /**
2494     * @dev Ensure the msg.sender is the modules governor
2495     */
2496     modifier onlyModulesGovernor {
2497         require(msg.sender == governor.modules, ERROR_SENDER_NOT_GOVERNOR);
2498         _;
2499     }
2500 
2501     /**
2502     * @dev Ensure the given dispute manager is active
2503     */
2504     modifier onlyActiveDisputeManager(IDisputeManager _disputeManager) {
2505         require(!_isModuleDisabled(address(_disputeManager)), ERROR_DISPUTE_MANAGER_NOT_ACTIVE);
2506         _;
2507     }
2508 
2509     /**
2510     * @dev Constructor function
2511     * @param _termParams Array containing:
2512     *        0. _termDuration Duration in seconds per term
2513     *        1. _firstTermStartTime Timestamp in seconds when the court will open (to give time for guardian on-boarding)
2514     * @param _governors Array containing:
2515     *        0. _fundsGovernor Address of the funds governor
2516     *        1. _configGovernor Address of the config governor
2517     *        2. _modulesGovernor Address of the modules governor
2518     * @param _feeToken Address of the token contract that is used to pay for fees
2519     * @param _fees Array containing:
2520     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
2521     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
2522     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
2523     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2524     *        0. evidenceTerms Max submitting evidence period duration in terms
2525     *        1. commitTerms Commit period duration in terms
2526     *        2. revealTerms Reveal period duration in terms
2527     *        3. appealTerms Appeal period duration in terms
2528     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2529     * @param _pcts Array containing:
2530     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted guardians (‱ - 1/10,000)
2531     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2532     * @param _roundParams Array containing params for rounds:
2533     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
2534     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
2535     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2536     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
2537     * @param _appealCollateralParams Array containing params for appeal collateral:
2538     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
2539     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
2540     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
2541     */
2542     constructor(
2543         uint64[2] memory _termParams,
2544         address[3] memory _governors,
2545         IERC20 _feeToken,
2546         uint256[3] memory _fees,
2547         uint64[5] memory _roundStateDurations,
2548         uint16[2] memory _pcts,
2549         uint64[4] memory _roundParams,
2550         uint256[2] memory _appealCollateralParams,
2551         uint256 _minActiveBalance
2552     )
2553         public
2554         CourtClock(_termParams)
2555         CourtConfig(_feeToken, _fees, _roundStateDurations, _pcts, _roundParams, _appealCollateralParams, _minActiveBalance)
2556     {
2557         _setFundsGovernor(_governors[0]);
2558         _setConfigGovernor(_governors[1]);
2559         _setModulesGovernor(_governors[2]);
2560     }
2561 
2562     /**
2563     * @dev Fallback function allows to forward calls to a specific address in case it was previously registered
2564     *      Note the sender will be always the controller in case it is forwarded
2565     */
2566     function () external payable {
2567         address target = customFunctions[msg.sig];
2568         require(target != address(0), ERROR_CUSTOM_FUNCTION_NOT_SET);
2569 
2570         // solium-disable-next-line security/no-call-value
2571         (bool success,) = address(target).call.value(msg.value)(msg.data);
2572         assembly {
2573             let size := returndatasize
2574             let ptr := mload(0x40)
2575             returndatacopy(ptr, 0, size)
2576 
2577             let result := success
2578             switch result case 0 { revert(ptr, size) }
2579             default { return(ptr, size) }
2580         }
2581     }
2582 
2583     /**
2584     * @notice Change Court configuration params
2585     * @param _fromTermId Identification number of the term in which the config will be effective at
2586     * @param _feeToken Address of the token contract that is used to pay for fees
2587     * @param _fees Array containing:
2588     *        0. guardianFee Amount of fee tokens that is paid per guardian per dispute
2589     *        1. draftFee Amount of fee tokens per guardian to cover the drafting cost
2590     *        2. settleFee Amount of fee tokens per guardian to cover round settlement cost
2591     * @param _roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2592     *        0. evidenceTerms Max submitting evidence period duration in terms
2593     *        1. commitTerms Commit period duration in terms
2594     *        2. revealTerms Reveal period duration in terms
2595     *        3. appealTerms Appeal period duration in terms
2596     *        4. appealConfirmationTerms Appeal confirmation period duration in terms
2597     * @param _pcts Array containing:
2598     *        0. penaltyPct Permyriad of min active tokens balance to be locked to each drafted guardians (‱ - 1/10,000)
2599     *        1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2600     * @param _roundParams Array containing params for rounds:
2601     *        0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
2602     *        1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
2603     *        2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2604     *        3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
2605     * @param _appealCollateralParams Array containing params for appeal collateral:
2606     *        1. appealCollateralFactor Permyriad multiple of dispute fees required to appeal a preliminary ruling
2607     *        2. appealConfirmCollateralFactor Permyriad multiple of dispute fees required to confirm appeal
2608     * @param _minActiveBalance Minimum amount of guardian tokens that can be activated
2609     */
2610     function setConfig(
2611         uint64 _fromTermId,
2612         IERC20 _feeToken,
2613         uint256[3] calldata _fees,
2614         uint64[5] calldata _roundStateDurations,
2615         uint16[2] calldata _pcts,
2616         uint64[4] calldata _roundParams,
2617         uint256[2] calldata _appealCollateralParams,
2618         uint256 _minActiveBalance
2619     )
2620         external
2621         onlyConfigGovernor
2622     {
2623         uint64 currentTermId = _ensureCurrentTerm();
2624         _setConfig(
2625             currentTermId,
2626             _fromTermId,
2627             _feeToken,
2628             _fees,
2629             _roundStateDurations,
2630             _pcts,
2631             _roundParams,
2632             _appealCollateralParams,
2633             _minActiveBalance
2634         );
2635     }
2636 
2637     /**
2638     * @notice Delay the Court start time to `_newFirstTermStartTime`
2639     * @param _newFirstTermStartTime New timestamp in seconds when the court will open
2640     */
2641     function delayStartTime(uint64 _newFirstTermStartTime) external onlyConfigGovernor {
2642         _delayStartTime(_newFirstTermStartTime);
2643     }
2644 
2645     /**
2646     * @notice Change funds governor address to `_newFundsGovernor`
2647     * @param _newFundsGovernor Address of the new funds governor to be set
2648     */
2649     function changeFundsGovernor(address _newFundsGovernor) external onlyFundsGovernor {
2650         require(_newFundsGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
2651         _setFundsGovernor(_newFundsGovernor);
2652     }
2653 
2654     /**
2655     * @notice Change config governor address to `_newConfigGovernor`
2656     * @param _newConfigGovernor Address of the new config governor to be set
2657     */
2658     function changeConfigGovernor(address _newConfigGovernor) external onlyConfigGovernor {
2659         require(_newConfigGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
2660         _setConfigGovernor(_newConfigGovernor);
2661     }
2662 
2663     /**
2664     * @notice Change modules governor address to `_newModulesGovernor`
2665     * @param _newModulesGovernor Address of the new governor to be set
2666     */
2667     function changeModulesGovernor(address _newModulesGovernor) external onlyModulesGovernor {
2668         require(_newModulesGovernor != ZERO_ADDRESS, ERROR_INVALID_GOVERNOR_ADDRESS);
2669         _setModulesGovernor(_newModulesGovernor);
2670     }
2671 
2672     /**
2673     * @notice Remove the funds governor. Set the funds governor to the zero address.
2674     * @dev This action cannot be rolled back, once the funds governor has been unset, funds cannot be recovered from recoverable modules anymore
2675     */
2676     function ejectFundsGovernor() external onlyFundsGovernor {
2677         _setFundsGovernor(ZERO_ADDRESS);
2678     }
2679 
2680     /**
2681     * @notice Remove the modules governor. Set the modules governor to the zero address.
2682     * @dev This action cannot be rolled back, once the modules governor has been unset, system modules cannot be changed anymore
2683     */
2684     function ejectModulesGovernor() external onlyModulesGovernor {
2685         _setModulesGovernor(ZERO_ADDRESS);
2686     }
2687 
2688     /**
2689     * @notice Grant `_id` role to `_who`
2690     * @param _id ID of the role to be granted
2691     * @param _who Address to grant the role to
2692     */
2693     function grant(bytes32 _id, address _who) external onlyConfigGovernor {
2694         _grant(_id, _who);
2695     }
2696 
2697     /**
2698     * @notice Revoke `_id` role from `_who`
2699     * @param _id ID of the role to be revoked
2700     * @param _who Address to revoke the role from
2701     */
2702     function revoke(bytes32 _id, address _who) external onlyConfigGovernor {
2703         _revoke(_id, _who);
2704     }
2705 
2706     /**
2707     * @notice Freeze `_id` role
2708     * @param _id ID of the role to be frozen
2709     */
2710     function freeze(bytes32 _id) external onlyConfigGovernor {
2711         _freeze(_id);
2712     }
2713 
2714     /**
2715     * @notice Enact a bulk list of ACL operations
2716     */
2717     function bulk(BulkOp[] calldata _op, bytes32[] calldata _id, address[] calldata _who) external onlyConfigGovernor {
2718         _bulk(_op, _id, _who);
2719     }
2720 
2721     /**
2722     * @notice Set module `_id` to `_addr`
2723     * @param _id ID of the module to be set
2724     * @param _addr Address of the module to be set
2725     */
2726     function setModule(bytes32 _id, address _addr) external onlyModulesGovernor {
2727         _setModule(_id, _addr);
2728     }
2729 
2730     /**
2731     * @notice Set and link many modules at once
2732     * @param _newModuleIds List of IDs of the new modules to be set
2733     * @param _newModuleAddresses List of addresses of the new modules to be set
2734     * @param _newModuleLinks List of IDs of the modules that will be linked in the new modules being set
2735     * @param _currentModulesToBeSynced List of addresses of current modules to be re-linked to the new modules being set
2736     */
2737     function setModules(
2738         bytes32[] calldata _newModuleIds,
2739         address[] calldata _newModuleAddresses,
2740         bytes32[] calldata _newModuleLinks,
2741         address[] calldata _currentModulesToBeSynced
2742     )
2743         external
2744         onlyModulesGovernor
2745     {
2746         // We only care about the modules being set, links are optional
2747         require(_newModuleIds.length == _newModuleAddresses.length, ERROR_INVALID_IMPLS_INPUT_LENGTH);
2748 
2749         // First set the addresses of the new modules or the modules to be updated
2750         for (uint256 i = 0; i < _newModuleIds.length; i++) {
2751             _setModule(_newModuleIds[i], _newModuleAddresses[i]);
2752         }
2753 
2754         // Then sync the links of the new modules based on the list of IDs specified (ideally the IDs of their dependencies)
2755         _syncModuleLinks(_newModuleAddresses, _newModuleLinks);
2756 
2757         // Finally sync the links of the existing modules to be synced to the new modules being set
2758         _syncModuleLinks(_currentModulesToBeSynced, _newModuleIds);
2759     }
2760 
2761     /**
2762     * @notice Sync modules for a list of modules IDs based on their current implementation address
2763     * @param _modulesToBeSynced List of addresses of connected modules to be synced
2764     * @param _idsToBeSet List of IDs of the modules included in the sync
2765     */
2766     function syncModuleLinks(address[] calldata _modulesToBeSynced, bytes32[] calldata _idsToBeSet)
2767         external
2768         onlyModulesGovernor
2769     {
2770         require(_idsToBeSet.length > 0 && _modulesToBeSynced.length > 0, ERROR_INVALID_IMPLS_INPUT_LENGTH);
2771         _syncModuleLinks(_modulesToBeSynced, _idsToBeSet);
2772     }
2773 
2774     /**
2775     * @notice Disable module `_addr`
2776     * @dev Current modules can be disabled to allow pausing the court. However, these can be enabled back again, see `enableModule`
2777     * @param _addr Address of the module to be disabled
2778     */
2779     function disableModule(address _addr) external onlyModulesGovernor {
2780         Module storage module = allModules[_addr];
2781         _ensureModuleExists(module);
2782         require(!module.disabled, ERROR_MODULE_ALREADY_DISABLED);
2783 
2784         module.disabled = true;
2785         emit ModuleDisabled(module.id, _addr);
2786     }
2787 
2788     /**
2789     * @notice Enable module `_addr`
2790     * @param _addr Address of the module to be enabled
2791     */
2792     function enableModule(address _addr) external onlyModulesGovernor {
2793         Module storage module = allModules[_addr];
2794         _ensureModuleExists(module);
2795         require(module.disabled, ERROR_MODULE_ALREADY_ENABLED);
2796 
2797         module.disabled = false;
2798         emit ModuleEnabled(module.id, _addr);
2799     }
2800 
2801     /**
2802     * @notice Set custom function `_sig` for `_target`
2803     * @param _sig Signature of the function to be set
2804     * @param _target Address of the target implementation to be registered for the given signature
2805     */
2806     function setCustomFunction(bytes4 _sig, address _target) external onlyModulesGovernor {
2807         customFunctions[_sig] = _target;
2808         emit CustomFunctionSet(_sig, _target);
2809     }
2810 
2811     /**
2812     * @dev Tell the full Court configuration parameters at a certain term
2813     * @param _termId Identification number of the term querying the Court config of
2814     * @return token Address of the token used to pay for fees
2815     * @return fees Array containing:
2816     *         0. guardianFee Amount of fee tokens that is paid per guardian per dispute
2817     *         1. draftFee Amount of fee tokens per guardian to cover the drafting cost
2818     *         2. settleFee Amount of fee tokens per guardian to cover round settlement cost
2819     * @return roundStateDurations Array containing the durations in terms of the different phases of a dispute:
2820     *         0. evidenceTerms Max submitting evidence period duration in terms
2821     *         1. commitTerms Commit period duration in terms
2822     *         2. revealTerms Reveal period duration in terms
2823     *         3. appealTerms Appeal period duration in terms
2824     *         4. appealConfirmationTerms Appeal confirmation period duration in terms
2825     * @return pcts Array containing:
2826     *         0. penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
2827     *         1. finalRoundReduction Permyriad of fee reduction for the last appeal round (‱ - 1/10,000)
2828     * @return roundParams Array containing params for rounds:
2829     *         0. firstRoundGuardiansNumber Number of guardians to be drafted for the first round of disputes
2830     *         1. appealStepFactor Increasing factor for the number of guardians of each round of a dispute
2831     *         2. maxRegularAppealRounds Number of regular appeal rounds before the final round is triggered
2832     *         3. finalRoundLockTerms Number of terms that a coherent guardian in a final round is disallowed to withdraw (to prevent 51% attacks)
2833     * @return appealCollateralParams Array containing params for appeal collateral:
2834     *         0. appealCollateralFactor Multiple of dispute fees required to appeal a preliminary ruling
2835     *         1. appealConfirmCollateralFactor Multiple of dispute fees required to confirm appeal
2836     */
2837     function getConfig(uint64 _termId) external view
2838         returns (
2839             IERC20 feeToken,
2840             uint256[3] memory fees,
2841             uint64[5] memory roundStateDurations,
2842             uint16[2] memory pcts,
2843             uint64[4] memory roundParams,
2844             uint256[2] memory appealCollateralParams,
2845             uint256 minActiveBalance
2846         )
2847     {
2848         uint64 lastEnsuredTermId = _lastEnsuredTermId();
2849         return _getConfigAt(_termId, lastEnsuredTermId);
2850     }
2851 
2852     /**
2853     * @dev Tell the draft config at a certain term
2854     * @param _termId Identification number of the term querying the draft config of
2855     * @return feeToken Address of the token used to pay for fees
2856     * @return draftFee Amount of fee tokens per guardian to cover the drafting cost
2857     * @return penaltyPct Permyriad of min active tokens balance to be locked for each drafted guardian (‱ - 1/10,000)
2858     */
2859     function getDraftConfig(uint64 _termId) external view returns (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct) {
2860         uint64 lastEnsuredTermId = _lastEnsuredTermId();
2861         return _getDraftConfig(_termId, lastEnsuredTermId);
2862     }
2863 
2864     /**
2865     * @dev Tell the min active balance config at a certain term
2866     * @param _termId Identification number of the term querying the min active balance config of
2867     * @return Minimum amount of tokens guardians have to activate to participate in the Court
2868     */
2869     function getMinActiveBalance(uint64 _termId) external view returns (uint256) {
2870         uint64 lastEnsuredTermId = _lastEnsuredTermId();
2871         return _getMinActiveBalance(_termId, lastEnsuredTermId);
2872     }
2873 
2874     /**
2875     * @dev Tell the address of the funds governor
2876     * @return Address of the funds governor
2877     */
2878     function getFundsGovernor() external view returns (address) {
2879         return governor.funds;
2880     }
2881 
2882     /**
2883     * @dev Tell the address of the config governor
2884     * @return Address of the config governor
2885     */
2886     function getConfigGovernor() external view returns (address) {
2887         return governor.config;
2888     }
2889 
2890     /**
2891     * @dev Tell the address of the modules governor
2892     * @return Address of the modules governor
2893     */
2894     function getModulesGovernor() external view returns (address) {
2895         return governor.modules;
2896     }
2897 
2898     /**
2899     * @dev Tell if a given module is active
2900     * @param _id ID of the module to be checked
2901     * @param _addr Address of the module to be checked
2902     * @return True if the given module address has the requested ID and is enabled
2903     */
2904     function isActive(bytes32 _id, address _addr) external view returns (bool) {
2905         Module storage module = allModules[_addr];
2906         return module.id == _id && !module.disabled;
2907     }
2908 
2909     /**
2910     * @dev Tell the current ID and disable status of a module based on a given address
2911     * @param _addr Address of the requested module
2912     * @return id ID of the module being queried
2913     * @return disabled Whether the module has been disabled
2914     */
2915     function getModuleByAddress(address _addr) external view returns (bytes32 id, bool disabled) {
2916         Module storage module = allModules[_addr];
2917         id = module.id;
2918         disabled = module.disabled;
2919     }
2920 
2921     /**
2922     * @dev Tell the current address and disable status of a module based on a given ID
2923     * @param _id ID of the module being queried
2924     * @return addr Current address of the requested module
2925     * @return disabled Whether the module has been disabled
2926     */
2927     function getModule(bytes32 _id) external view returns (address addr, bool disabled) {
2928         return _getModule(_id);
2929     }
2930 
2931     /**
2932     * @dev Tell the information for the current DisputeManager module
2933     * @return addr Current address of the DisputeManager module
2934     * @return disabled Whether the module has been disabled
2935     */
2936     function getDisputeManager() external view returns (address addr, bool disabled) {
2937         return _getModule(MODULE_ID_DISPUTE_MANAGER);
2938     }
2939 
2940     /**
2941     * @dev Tell the information for  the current GuardiansRegistry module
2942     * @return addr Current address of the GuardiansRegistry module
2943     * @return disabled Whether the module has been disabled
2944     */
2945     function getGuardiansRegistry() external view returns (address addr, bool disabled) {
2946         return _getModule(MODULE_ID_GUARDIANS_REGISTRY);
2947     }
2948 
2949     /**
2950     * @dev Tell the information for the current Voting module
2951     * @return addr Current address of the Voting module
2952     * @return disabled Whether the module has been disabled
2953     */
2954     function getVoting() external view returns (address addr, bool disabled) {
2955         return _getModule(MODULE_ID_VOTING);
2956     }
2957 
2958     /**
2959     * @dev Tell the information for the current PaymentsBook module
2960     * @return addr Current address of the PaymentsBook module
2961     * @return disabled Whether the module has been disabled
2962     */
2963     function getPaymentsBook() external view returns (address addr, bool disabled) {
2964         return _getModule(MODULE_ID_PAYMENTS_BOOK);
2965     }
2966 
2967     /**
2968     * @dev Tell the information for the current Treasury module
2969     * @return addr Current address of the Treasury module
2970     * @return disabled Whether the module has been disabled
2971     */
2972     function getTreasury() external view returns (address addr, bool disabled) {
2973         return _getModule(MODULE_ID_TREASURY);
2974     }
2975 
2976     /**
2977     * @dev Tell the target registered for a custom function
2978     * @param _sig Signature of the function being queried
2979     * @return Address of the target where the function call will be forwarded
2980     */
2981     function getCustomFunction(bytes4 _sig) external view returns (address) {
2982         return customFunctions[_sig];
2983     }
2984 
2985     /**
2986     * @dev Internal function to set the address of the funds governor
2987     * @param _newFundsGovernor Address of the new config governor to be set
2988     */
2989     function _setFundsGovernor(address _newFundsGovernor) internal {
2990         emit FundsGovernorChanged(governor.funds, _newFundsGovernor);
2991         governor.funds = _newFundsGovernor;
2992     }
2993 
2994     /**
2995     * @dev Internal function to set the address of the config governor
2996     * @param _newConfigGovernor Address of the new config governor to be set
2997     */
2998     function _setConfigGovernor(address _newConfigGovernor) internal {
2999         emit ConfigGovernorChanged(governor.config, _newConfigGovernor);
3000         governor.config = _newConfigGovernor;
3001     }
3002 
3003     /**
3004     * @dev Internal function to set the address of the modules governor
3005     * @param _newModulesGovernor Address of the new modules governor to be set
3006     */
3007     function _setModulesGovernor(address _newModulesGovernor) internal {
3008         emit ModulesGovernorChanged(governor.modules, _newModulesGovernor);
3009         governor.modules = _newModulesGovernor;
3010     }
3011 
3012     /**
3013     * @dev Internal function to set an address as the current implementation for a module
3014     *      Note that the disabled condition is not affected, if the module was not set before it will be enabled by default
3015     * @param _id Id of the module to be set
3016     * @param _addr Address of the module to be set
3017     */
3018     function _setModule(bytes32 _id, address _addr) internal {
3019         require(isContract(_addr), ERROR_IMPLEMENTATION_NOT_CONTRACT);
3020 
3021         currentModules[_id] = _addr;
3022         allModules[_addr].id = _id;
3023         emit ModuleSet(_id, _addr);
3024     }
3025 
3026     /**
3027     * @dev Internal function to sync the modules for a list of modules IDs based on their current implementation address
3028     * @param _modulesToBeSynced List of addresses of connected modules to be synced
3029     * @param _idsToBeSet List of IDs of the modules to be linked
3030     */
3031     function _syncModuleLinks(address[] memory _modulesToBeSynced, bytes32[] memory _idsToBeSet) internal {
3032         address[] memory addressesToBeSet = new address[](_idsToBeSet.length);
3033 
3034         // Load the addresses associated with the requested module ids
3035         for (uint256 i = 0; i < _idsToBeSet.length; i++) {
3036             address moduleAddress = _getModuleAddress(_idsToBeSet[i]);
3037             Module storage module = allModules[moduleAddress];
3038             _ensureModuleExists(module);
3039             addressesToBeSet[i] = moduleAddress;
3040         }
3041 
3042         // Update the links of all the requested modules
3043         for (uint256 j = 0; j < _modulesToBeSynced.length; j++) {
3044             IModulesLinker(_modulesToBeSynced[j]).linkModules(_idsToBeSet, addressesToBeSet);
3045         }
3046     }
3047 
3048     /**
3049     * @dev Internal function to notify when a term has been transitioned
3050     * @param _termId Identification number of the new current term that has been transitioned
3051     */
3052     function _onTermTransitioned(uint64 _termId) internal {
3053         _ensureTermConfig(_termId);
3054     }
3055 
3056     /**
3057     * @dev Internal function to check if a module was set
3058     * @param _module Module to be checked
3059     */
3060     function _ensureModuleExists(Module storage _module) internal view {
3061         require(_module.id != bytes32(0), ERROR_MODULE_NOT_SET);
3062     }
3063 
3064     /**
3065     * @dev Internal function to tell the information for a module based on a given ID
3066     * @param _id ID of the module being queried
3067     * @return addr Current address of the requested module
3068     * @return disabled Whether the module has been disabled
3069     */
3070     function _getModule(bytes32 _id) internal view returns (address addr, bool disabled) {
3071         addr = _getModuleAddress(_id);
3072         disabled = _isModuleDisabled(addr);
3073     }
3074 
3075     /**
3076     * @dev Tell the current address for a module by ID
3077     * @param _id ID of the module being queried
3078     * @return Current address of the requested module
3079     */
3080     function _getModuleAddress(bytes32 _id) internal view returns (address) {
3081         return currentModules[_id];
3082     }
3083 
3084     /**
3085     * @dev Tell whether a module is disabled
3086     * @param _addr Address of the module being queried
3087     * @return True if the module is disabled, false otherwise
3088     */
3089     function _isModuleDisabled(address _addr) internal view returns (bool) {
3090         return allModules[_addr].disabled;
3091     }
3092 }
3093 
3094 contract ConfigConsumer is CourtConfigData {
3095     /**
3096     * @dev Internal function to fetch the address of the Config module from the controller
3097     * @return Address of the Config module
3098     */
3099     function _courtConfig() internal view returns (IConfig);
3100 
3101     /**
3102     * @dev Internal function to get the Court config for a certain term
3103     * @param _termId Identification number of the term querying the Court config of
3104     * @return Court config for the given term
3105     */
3106     function _getConfigAt(uint64 _termId) internal view returns (Config memory) {
3107         (IERC20 _feeToken,
3108         uint256[3] memory _fees,
3109         uint64[5] memory _roundStateDurations,
3110         uint16[2] memory _pcts,
3111         uint64[4] memory _roundParams,
3112         uint256[2] memory _appealCollateralParams,
3113         uint256 _minActiveBalance) = _courtConfig().getConfig(_termId);
3114 
3115         Config memory config;
3116 
3117         config.fees = FeesConfig({
3118             token: _feeToken,
3119             guardianFee: _fees[0],
3120             draftFee: _fees[1],
3121             settleFee: _fees[2],
3122             finalRoundReduction: _pcts[1]
3123         });
3124 
3125         config.disputes = DisputesConfig({
3126             evidenceTerms: _roundStateDurations[0],
3127             commitTerms: _roundStateDurations[1],
3128             revealTerms: _roundStateDurations[2],
3129             appealTerms: _roundStateDurations[3],
3130             appealConfirmTerms: _roundStateDurations[4],
3131             penaltyPct: _pcts[0],
3132             firstRoundGuardiansNumber: _roundParams[0],
3133             appealStepFactor: _roundParams[1],
3134             maxRegularAppealRounds: _roundParams[2],
3135             finalRoundLockTerms: _roundParams[3],
3136             appealCollateralFactor: _appealCollateralParams[0],
3137             appealConfirmCollateralFactor: _appealCollateralParams[1]
3138         });
3139 
3140         config.minActiveBalance = _minActiveBalance;
3141 
3142         return config;
3143     }
3144 
3145     /**
3146     * @dev Internal function to get the draft config for a given term
3147     * @param _termId Identification number of the term querying the draft config of
3148     * @return Draft config for the given term
3149     */
3150     function _getDraftConfig(uint64 _termId) internal view returns (DraftConfig memory) {
3151         (IERC20 feeToken, uint256 draftFee, uint16 penaltyPct) = _courtConfig().getDraftConfig(_termId);
3152         return DraftConfig({ feeToken: feeToken, draftFee: draftFee, penaltyPct: penaltyPct });
3153     }
3154 
3155     /**
3156     * @dev Internal function to get the min active balance config for a given term
3157     * @param _termId Identification number of the term querying the min active balance config of
3158     * @return Minimum amount of guardian tokens that can be activated
3159     */
3160     function _getMinActiveBalance(uint64 _termId) internal view returns (uint256) {
3161         return _courtConfig().getMinActiveBalance(_termId);
3162     }
3163 }
3164 
3165 /*
3166  * SPDX-License-Identifier:    MIT
3167  */
3168 interface ICRVotingOwner {
3169     /**
3170     * @dev Ensure votes can be committed for a vote instance, revert otherwise
3171     * @param _voteId ID of the vote instance to request the weight of a voter for
3172     */
3173     function ensureCanCommit(uint256 _voteId) external;
3174 
3175     /**
3176     * @dev Ensure a certain voter can commit votes for a vote instance, revert otherwise
3177     * @param _voteId ID of the vote instance to request the weight of a voter for
3178     * @param _voter Address of the voter querying the weight of
3179     */
3180     function ensureCanCommit(uint256 _voteId, address _voter) external;
3181 
3182     /**
3183     * @dev Ensure a certain voter can reveal votes for vote instance, revert otherwise
3184     * @param _voteId ID of the vote instance to request the weight of a voter for
3185     * @param _voter Address of the voter querying the weight of
3186     * @return Weight of the requested guardian for the requested vote instance
3187     */
3188     function ensureCanReveal(uint256 _voteId, address _voter) external returns (uint64);
3189 }
3190 
3191 /*
3192  * SPDX-License-Identifier:    MIT
3193  */
3194 interface ICRVoting {
3195     /**
3196     * @dev Create a new vote instance
3197     * @dev This function can only be called by the CRVoting owner
3198     * @param _voteId ID of the new vote instance to be created
3199     * @param _possibleOutcomes Number of possible outcomes for the new vote instance to be created
3200     */
3201     function createVote(uint256 _voteId, uint8 _possibleOutcomes) external;
3202 
3203     /**
3204     * @dev Get the winning outcome of a vote instance
3205     * @param _voteId ID of the vote instance querying the winning outcome of
3206     * @return Winning outcome of the given vote instance or refused in case it's missing
3207     */
3208     function getWinningOutcome(uint256 _voteId) external view returns (uint8);
3209 
3210     /**
3211     * @dev Get the tally of an outcome for a certain vote instance
3212     * @param _voteId ID of the vote instance querying the tally of
3213     * @param _outcome Outcome querying the tally of
3214     * @return Tally of the outcome being queried for the given vote instance
3215     */
3216     function getOutcomeTally(uint256 _voteId, uint8 _outcome) external view returns (uint256);
3217 
3218     /**
3219     * @dev Tell whether an outcome is valid for a given vote instance or not
3220     * @param _voteId ID of the vote instance to check the outcome of
3221     * @param _outcome Outcome to check if valid or not
3222     * @return True if the given outcome is valid for the requested vote instance, false otherwise
3223     */
3224     function isValidOutcome(uint256 _voteId, uint8 _outcome) external view returns (bool);
3225 
3226     /**
3227     * @dev Get the outcome voted by a voter for a certain vote instance
3228     * @param _voteId ID of the vote instance querying the outcome of
3229     * @param _voter Address of the voter querying the outcome of
3230     * @return Outcome of the voter for the given vote instance
3231     */
3232     function getVoterOutcome(uint256 _voteId, address _voter) external view returns (uint8);
3233 
3234     /**
3235     * @dev Tell whether a voter voted in favor of a certain outcome in a vote instance or not
3236     * @param _voteId ID of the vote instance to query if a voter voted in favor of a certain outcome
3237     * @param _outcome Outcome to query if the given voter voted in favor of
3238     * @param _voter Address of the voter to query if voted in favor of the given outcome
3239     * @return True if the given voter voted in favor of the given outcome, false otherwise
3240     */
3241     function hasVotedInFavorOf(uint256 _voteId, uint8 _outcome, address _voter) external view returns (bool);
3242 
3243     /**
3244     * @dev Filter a list of voters based on whether they voted in favor of a certain outcome in a vote instance or not
3245     * @param _voteId ID of the vote instance to be checked
3246     * @param _outcome Outcome to filter the list of voters of
3247     * @param _voters List of addresses of the voters to be filtered
3248     * @return List of results to tell whether a voter voted in favor of the given outcome or not
3249     */
3250     function getVotersInFavorOf(uint256 _voteId, uint8 _outcome, address[] calldata _voters) external view returns (bool[] memory);
3251 }
3252 
3253 /*
3254  * SPDX-License-Identifier:    MIT
3255  */
3256 interface ITreasury {
3257     /**
3258     * @dev Assign a certain amount of tokens to an account
3259     * @param _token ERC20 token to be assigned
3260     * @param _to Address of the recipient that will be assigned the tokens to
3261     * @param _amount Amount of tokens to be assigned to the recipient
3262     */
3263     function assign(IERC20 _token, address _to, uint256 _amount) external;
3264 
3265     /**
3266     * @dev Withdraw a certain amount of tokens
3267     * @param _token ERC20 token to be withdrawn
3268     * @param _from Address withdrawing the tokens from
3269     * @param _to Address of the recipient that will receive the tokens
3270     * @param _amount Amount of tokens to be withdrawn from the sender
3271     */
3272     function withdraw(IERC20 _token, address _from, address _to, uint256 _amount) external;
3273 }
3274 
3275 /*
3276  * SPDX-License-Identifier:    MIT
3277  */
3278 interface IPaymentsBook {
3279     /**
3280     * @dev Pay an amount of tokens
3281     * @param _token Address of the token being paid
3282     * @param _amount Amount of tokens being paid
3283     * @param _payer Address paying on behalf of
3284     * @param _data Optional data
3285     */
3286     function pay(address _token, uint256 _amount, address _payer, bytes calldata _data) external payable;
3287 }
3288 
3289 contract Controlled is IModulesLinker, IsContract, ModuleIds, ConfigConsumer {
3290     string private constant ERROR_MODULE_NOT_SET = "CTD_MODULE_NOT_SET";
3291     string private constant ERROR_INVALID_MODULES_LINK_INPUT = "CTD_INVALID_MODULES_LINK_INPUT";
3292     string private constant ERROR_CONTROLLER_NOT_CONTRACT = "CTD_CONTROLLER_NOT_CONTRACT";
3293     string private constant ERROR_SENDER_NOT_ALLOWED = "CTD_SENDER_NOT_ALLOWED";
3294     string private constant ERROR_SENDER_NOT_CONTROLLER = "CTD_SENDER_NOT_CONTROLLER";
3295     string private constant ERROR_SENDER_NOT_CONFIG_GOVERNOR = "CTD_SENDER_NOT_CONFIG_GOVERNOR";
3296     string private constant ERROR_SENDER_NOT_ACTIVE_VOTING = "CTD_SENDER_NOT_ACTIVE_VOTING";
3297     string private constant ERROR_SENDER_NOT_ACTIVE_DISPUTE_MANAGER = "CTD_SEND_NOT_ACTIVE_DISPUTE_MGR";
3298     string private constant ERROR_SENDER_NOT_CURRENT_DISPUTE_MANAGER = "CTD_SEND_NOT_CURRENT_DISPUTE_MGR";
3299 
3300     // Address of the controller
3301     Controller public controller;
3302 
3303     // List of modules linked indexed by ID
3304     mapping (bytes32 => address) public linkedModules;
3305 
3306     event ModuleLinked(bytes32 id, address addr);
3307 
3308     /**
3309     * @dev Ensure the msg.sender is the controller's config governor
3310     */
3311     modifier onlyConfigGovernor {
3312         require(msg.sender == _configGovernor(), ERROR_SENDER_NOT_CONFIG_GOVERNOR);
3313         _;
3314     }
3315 
3316     /**
3317     * @dev Ensure the msg.sender is the controller
3318     */
3319     modifier onlyController() {
3320         require(msg.sender == address(controller), ERROR_SENDER_NOT_CONTROLLER);
3321         _;
3322     }
3323 
3324     /**
3325     * @dev Ensure the msg.sender is an active DisputeManager module
3326     */
3327     modifier onlyActiveDisputeManager() {
3328         require(controller.isActive(MODULE_ID_DISPUTE_MANAGER, msg.sender), ERROR_SENDER_NOT_ACTIVE_DISPUTE_MANAGER);
3329         _;
3330     }
3331 
3332     /**
3333     * @dev Ensure the msg.sender is the current DisputeManager module
3334     */
3335     modifier onlyCurrentDisputeManager() {
3336         (address addr, bool disabled) = controller.getDisputeManager();
3337         require(msg.sender == addr, ERROR_SENDER_NOT_CURRENT_DISPUTE_MANAGER);
3338         require(!disabled, ERROR_SENDER_NOT_ACTIVE_DISPUTE_MANAGER);
3339         _;
3340     }
3341 
3342     /**
3343     * @dev Ensure the msg.sender is an active Voting module
3344     */
3345     modifier onlyActiveVoting() {
3346         require(controller.isActive(MODULE_ID_VOTING, msg.sender), ERROR_SENDER_NOT_ACTIVE_VOTING);
3347         _;
3348     }
3349 
3350     /**
3351     * @dev This modifier will check that the sender is the user to act on behalf of or someone with the required permission
3352     * @param _user Address of the user to act on behalf of
3353     */
3354     modifier authenticateSender(address _user) {
3355         _authenticateSender(_user);
3356         _;
3357     }
3358 
3359     /**
3360     * @dev Constructor function
3361     * @param _controller Address of the controller
3362     */
3363     constructor(Controller _controller) public {
3364         require(isContract(address(_controller)), ERROR_CONTROLLER_NOT_CONTRACT);
3365         controller = _controller;
3366     }
3367 
3368     /**
3369     * @notice Update the implementation links of a list of modules
3370     * @dev The controller is expected to ensure the given addresses are correct modules
3371     * @param _ids List of IDs of the modules to be updated
3372     * @param _addresses List of module addresses to be updated
3373     */
3374     function linkModules(bytes32[] calldata _ids, address[] calldata _addresses) external onlyController {
3375         require(_ids.length == _addresses.length, ERROR_INVALID_MODULES_LINK_INPUT);
3376 
3377         for (uint256 i = 0; i < _ids.length; i++) {
3378             linkedModules[_ids[i]] = _addresses[i];
3379             emit ModuleLinked(_ids[i], _addresses[i]);
3380         }
3381     }
3382 
3383     /**
3384     * @dev Internal function to ensure the Court term is up-to-date, it will try to update it if not
3385     * @return Identification number of the current Court term
3386     */
3387     function _ensureCurrentTerm() internal returns (uint64) {
3388         return _clock().ensureCurrentTerm();
3389     }
3390 
3391     /**
3392     * @dev Internal function to fetch the last ensured term ID of the Court
3393     * @return Identification number of the last ensured term
3394     */
3395     function _getLastEnsuredTermId() internal view returns (uint64) {
3396         return _clock().getLastEnsuredTermId();
3397     }
3398 
3399     /**
3400     * @dev Internal function to tell the current term identification number
3401     * @return Identification number of the current term
3402     */
3403     function _getCurrentTermId() internal view returns (uint64) {
3404         return _clock().getCurrentTermId();
3405     }
3406 
3407     /**
3408     * @dev Internal function to fetch the controller's config governor
3409     * @return Address of the controller's config governor
3410     */
3411     function _configGovernor() internal view returns (address) {
3412         return controller.getConfigGovernor();
3413     }
3414 
3415     /**
3416     * @dev Internal function to fetch the address of the DisputeManager module
3417     * @return Address of the DisputeManager module
3418     */
3419     function _disputeManager() internal view returns (IDisputeManager) {
3420         return IDisputeManager(_getLinkedModule(MODULE_ID_DISPUTE_MANAGER));
3421     }
3422 
3423     /**
3424     * @dev Internal function to fetch the address of the GuardianRegistry module implementation
3425     * @return Address of the GuardianRegistry module implementation
3426     */
3427     function _guardiansRegistry() internal view returns (IGuardiansRegistry) {
3428         return IGuardiansRegistry(_getLinkedModule(MODULE_ID_GUARDIANS_REGISTRY));
3429     }
3430 
3431     /**
3432     * @dev Internal function to fetch the address of the Voting module implementation
3433     * @return Address of the Voting module implementation
3434     */
3435     function _voting() internal view returns (ICRVoting) {
3436         return ICRVoting(_getLinkedModule(MODULE_ID_VOTING));
3437     }
3438 
3439     /**
3440     * @dev Internal function to fetch the address of the PaymentsBook module implementation
3441     * @return Address of the PaymentsBook module implementation
3442     */
3443     function _paymentsBook() internal view returns (IPaymentsBook) {
3444         return IPaymentsBook(_getLinkedModule(MODULE_ID_PAYMENTS_BOOK));
3445     }
3446 
3447     /**
3448     * @dev Internal function to fetch the address of the Treasury module implementation
3449     * @return Address of the Treasury module implementation
3450     */
3451     function _treasury() internal view returns (ITreasury) {
3452         return ITreasury(_getLinkedModule(MODULE_ID_TREASURY));
3453     }
3454 
3455     /**
3456     * @dev Internal function to tell the address linked for a module based on a given ID
3457     * @param _id ID of the module being queried
3458     * @return Linked address of the requested module
3459     */
3460     function _getLinkedModule(bytes32 _id) internal view returns (address) {
3461         address module = linkedModules[_id];
3462         require(module != address(0), ERROR_MODULE_NOT_SET);
3463         return module;
3464     }
3465 
3466     /**
3467     * @dev Internal function to fetch the address of the Clock module from the controller
3468     * @return Address of the Clock module
3469     */
3470     function _clock() internal view returns (IClock) {
3471         return IClock(controller);
3472     }
3473 
3474     /**
3475     * @dev Internal function to fetch the address of the Config module from the controller
3476     * @return Address of the Config module
3477     */
3478     function _courtConfig() internal view returns (IConfig) {
3479         return IConfig(controller);
3480     }
3481 
3482     /**
3483     * @dev Ensure that the sender is the user to act on behalf of or someone with the required permission
3484     * @param _user Address of the user to act on behalf of
3485     */
3486     function _authenticateSender(address _user) internal view {
3487         require(_isSenderAllowed(_user), ERROR_SENDER_NOT_ALLOWED);
3488     }
3489 
3490     /**
3491     * @dev Tell whether the sender is the user to act on behalf of or someone with the required permission
3492     * @param _user Address of the user to act on behalf of
3493     * @return True if the sender is the user to act on behalf of or someone with the required permission, false otherwise
3494     */
3495     function _isSenderAllowed(address _user) internal view returns (bool) {
3496         return msg.sender == _user || _hasRole(msg.sender);
3497     }
3498 
3499     /**
3500     * @dev Tell whether an address holds the required permission to access the requested functionality
3501     * @param _addr Address being checked
3502     * @return True if the given address has the required permission to access the requested functionality, false otherwise
3503     */
3504     function _hasRole(address _addr) internal view returns (bool) {
3505         bytes32 roleId = keccak256(abi.encodePacked(address(this), msg.sig));
3506         return controller.hasRole(_addr, roleId);
3507     }
3508 }
3509 
3510 contract ControlledRecoverable is Controlled {
3511     using SafeERC20 for IERC20;
3512 
3513     string private constant ERROR_SENDER_NOT_FUNDS_GOVERNOR = "CTD_SENDER_NOT_FUNDS_GOVERNOR";
3514     string private constant ERROR_INSUFFICIENT_RECOVER_FUNDS = "CTD_INSUFFICIENT_RECOVER_FUNDS";
3515     string private constant ERROR_RECOVER_TOKEN_FUNDS_FAILED = "CTD_RECOVER_TOKEN_FUNDS_FAILED";
3516 
3517     event RecoverFunds(address token, address recipient, uint256 balance);
3518 
3519     /**
3520     * @dev Ensure the msg.sender is the controller's funds governor
3521     */
3522     modifier onlyFundsGovernor {
3523         require(msg.sender == controller.getFundsGovernor(), ERROR_SENDER_NOT_FUNDS_GOVERNOR);
3524         _;
3525     }
3526 
3527     /**
3528     * @notice Transfer all `_token` tokens to `_to`
3529     * @param _token Address of the token to be recovered
3530     * @param _to Address of the recipient that will be receive all the funds of the requested token
3531     */
3532     function recoverFunds(address _token, address payable _to) external payable onlyFundsGovernor {
3533         uint256 balance;
3534 
3535         if (_token == address(0)) {
3536             balance = address(this).balance;
3537             require(_to.send(balance), ERROR_RECOVER_TOKEN_FUNDS_FAILED);
3538         } else {
3539             balance = IERC20(_token).balanceOf(address(this));
3540             require(balance > 0, ERROR_INSUFFICIENT_RECOVER_FUNDS);
3541             // No need to verify _token to be a contract as we have already checked the balance
3542             require(IERC20(_token).safeTransfer(_to, balance), ERROR_RECOVER_TOKEN_FUNDS_FAILED);
3543         }
3544 
3545         emit RecoverFunds(_token, _to, balance);
3546     }
3547 }
3548 
3549 contract GuardiansRegistry is IGuardiansRegistry, ControlledRecoverable {
3550     using SafeERC20 for IERC20;
3551     using SafeMath for uint256;
3552     using PctHelpers for uint256;
3553     using HexSumTree for HexSumTree.Tree;
3554     using GuardiansTreeSortition for HexSumTree.Tree;
3555 
3556     string private constant ERROR_NOT_CONTRACT = "GR_NOT_CONTRACT";
3557     string private constant ERROR_INVALID_ZERO_AMOUNT = "GR_INVALID_ZERO_AMOUNT";
3558     string private constant ERROR_INVALID_ACTIVATION_AMOUNT = "GR_INVALID_ACTIVATION_AMOUNT";
3559     string private constant ERROR_INVALID_DEACTIVATION_AMOUNT = "GR_INVALID_DEACTIVATION_AMOUNT";
3560     string private constant ERROR_INVALID_LOCKED_AMOUNTS_LENGTH = "GR_INVALID_LOCKED_AMOUNTS_LEN";
3561     string private constant ERROR_INVALID_REWARDED_GUARDIANS_LENGTH = "GR_INVALID_REWARD_GUARDIANS_LEN";
3562     string private constant ERROR_ACTIVE_BALANCE_BELOW_MIN = "GR_ACTIVE_BALANCE_BELOW_MIN";
3563     string private constant ERROR_NOT_ENOUGH_AVAILABLE_BALANCE = "GR_NOT_ENOUGH_AVAILABLE_BALANCE";
3564     string private constant ERROR_CANNOT_REDUCE_DEACTIVATION_REQUEST = "GR_CANT_REDUCE_DEACTIVATION_REQ";
3565     string private constant ERROR_TOKEN_TRANSFER_FAILED = "GR_TOKEN_TRANSFER_FAILED";
3566     string private constant ERROR_TOKEN_APPROVE_NOT_ALLOWED = "GR_TOKEN_APPROVE_NOT_ALLOWED";
3567     string private constant ERROR_BAD_TOTAL_ACTIVE_BALANCE_LIMIT = "GR_BAD_TOTAL_ACTIVE_BAL_LIMIT";
3568     string private constant ERROR_TOTAL_ACTIVE_BALANCE_EXCEEDED = "GR_TOTAL_ACTIVE_BALANCE_EXCEEDED";
3569     string private constant ERROR_DEACTIVATION_AMOUNT_EXCEEDS_LOCK = "GR_DEACTIV_AMOUNT_EXCEEDS_LOCK";
3570     string private constant ERROR_CANNOT_UNLOCK_ACTIVATION = "GR_CANNOT_UNLOCK_ACTIVATION";
3571     string private constant ERROR_ZERO_LOCK_ACTIVATION = "GR_ZERO_LOCK_ACTIVATION";
3572     string private constant ERROR_INVALID_UNLOCK_ACTIVATION_AMOUNT = "GR_INVALID_UNLOCK_ACTIVAT_AMOUNT";
3573     string private constant ERROR_LOCK_MANAGER_NOT_ALLOWED = "GR_LOCK_MANAGER_NOT_ALLOWED";
3574     string private constant ERROR_WITHDRAWALS_LOCK = "GR_WITHDRAWALS_LOCK";
3575 
3576     // Address that will be used to burn guardian tokens
3577     address internal constant BURN_ACCOUNT = address(0x000000000000000000000000000000000000dEaD);
3578 
3579     // Maximum number of sortition iterations allowed per draft call
3580     uint256 internal constant MAX_DRAFT_ITERATIONS = 10;
3581 
3582     // "ERC20-lite" interface to provide help for tooling
3583     string public constant name = "Court Staked Aragon Network Token";
3584     string public constant symbol = "sANT";
3585     uint8 public constant decimals = 18;
3586 
3587     /**
3588     * @dev Guardians have three kind of balances, these are:
3589     *      - active: tokens activated for the Court that can be locked in case the guardian is drafted
3590     *      - locked: amount of active tokens that are locked for a draft
3591     *      - available: tokens that are not activated for the Court and can be withdrawn by the guardian at any time
3592     *
3593     *      Due to a gas optimization for drafting, the "active" tokens are stored in a `HexSumTree`, while the others
3594     *      are stored in this contract as `lockedBalance` and `availableBalance` respectively. Given that the guardians'
3595     *      active balances cannot be affected during the current Court term, if guardians want to deactivate some of
3596     *      their active tokens, their balance will be updated for the following term, and they won't be allowed to
3597     *      withdraw them until the current term has ended.
3598     *
3599     *      Note that even though guardians balances are stored separately, all the balances are held by this contract.
3600     */
3601     struct Guardian {
3602         uint256 id;                                 // Key in the guardians tree used for drafting
3603         uint256 lockedBalance;                      // Maximum amount of tokens that can be slashed based on the guardian's drafts
3604         uint256 availableBalance;                   // Available tokens that can be withdrawn at any time
3605         uint64 withdrawalsLockTermId;               // Term ID until which the guardian's withdrawals will be locked
3606         ActivationLocks activationLocks;            // Guardian's activation locks
3607         DeactivationRequest deactivationRequest;    // Guardian's pending deactivation request
3608     }
3609 
3610     /**
3611     * @dev Guardians can define lock managers to control their minimum active balance in the registry
3612     */
3613     struct ActivationLocks {
3614         uint256 total;                               // Total amount of active balance locked
3615         mapping (address => uint256) lockedBy;       // List of locked amounts indexed by lock manager
3616     }
3617 
3618     /**
3619     * @dev Given that the guardians balances cannot be affected during a Court term, if guardians want to deactivate some
3620     *      of their tokens, the tree will always be updated for the following term, and they won't be able to
3621     *      withdraw the requested amount until the current term has finished. Thus, we need to keep track the term
3622     *      when a token deactivation was requested and its corresponding amount.
3623     */
3624     struct DeactivationRequest {
3625         uint256 amount;                             // Amount requested for deactivation
3626         uint64 availableTermId;                     // Term ID when guardians can withdraw their requested deactivation tokens
3627     }
3628 
3629     /**
3630     * @dev Internal struct to wrap all the params required to perform guardians drafting
3631     */
3632     struct DraftParams {
3633         bytes32 termRandomness;                     // Randomness seed to be used for the draft
3634         uint256 disputeId;                          // ID of the dispute being drafted
3635         uint64 termId;                              // Term ID of the dispute's draft term
3636         uint256 selectedGuardians;                  // Number of guardians already selected for the draft
3637         uint256 batchRequestedGuardians;            // Number of guardians to be selected in the given batch of the draft
3638         uint256 roundRequestedGuardians;            // Total number of guardians requested to be drafted
3639         uint256 draftLockAmount;                    // Amount of tokens to be locked to each drafted guardian
3640         uint256 iteration;                          // Sortition iteration number
3641     }
3642 
3643     // Maximum amount of total active balance that can be held in the registry
3644     uint256 public totalActiveBalanceLimit;
3645 
3646     // Guardian ERC20 token
3647     IERC20 public guardiansToken;
3648 
3649     // Mapping of guardian data indexed by address
3650     mapping (address => Guardian) internal guardiansByAddress;
3651 
3652     // Mapping of guardian addresses indexed by id
3653     mapping (uint256 => address) internal guardiansAddressById;
3654 
3655     // Tree to store guardians active balance by term for the drafting process
3656     HexSumTree.Tree internal tree;
3657 
3658     event Staked(address indexed guardian, uint256 amount, uint256 total);
3659     event Unstaked(address indexed guardian, uint256 amount, uint256 total);
3660     event GuardianActivated(address indexed guardian, uint64 fromTermId, uint256 amount);
3661     event GuardianDeactivationRequested(address indexed guardian, uint64 availableTermId, uint256 amount);
3662     event GuardianDeactivationProcessed(address indexed guardian, uint64 availableTermId, uint256 amount, uint64 processedTermId);
3663     event GuardianDeactivationUpdated(address indexed guardian, uint64 availableTermId, uint256 amount, uint64 updateTermId);
3664     event GuardianActivationLockChanged(address indexed guardian, address indexed lockManager, uint256 amount, uint256 total);
3665     event GuardianBalanceLocked(address indexed guardian, uint256 amount);
3666     event GuardianBalanceUnlocked(address indexed guardian, uint256 amount);
3667     event GuardianSlashed(address indexed guardian, uint256 amount, uint64 effectiveTermId);
3668     event GuardianTokensAssigned(address indexed guardian, uint256 amount);
3669     event GuardianTokensBurned(uint256 amount);
3670     event GuardianTokensCollected(address indexed guardian, uint256 amount, uint64 effectiveTermId);
3671     event TotalActiveBalanceLimitChanged(uint256 previousTotalActiveBalanceLimit, uint256 currentTotalActiveBalanceLimit);
3672 
3673     /**
3674     * @dev Constructor function
3675     * @param _controller Address of the controller
3676     * @param _guardiansToken Address of the ERC20 token to be used as guardian token for the registry
3677     * @param _totalActiveBalanceLimit Maximum amount of total active balance that can be held in the registry
3678     */
3679     constructor(Controller _controller, IERC20 _guardiansToken, uint256 _totalActiveBalanceLimit) Controlled(_controller) public {
3680         require(isContract(address(_guardiansToken)), ERROR_NOT_CONTRACT);
3681 
3682         guardiansToken = _guardiansToken;
3683         _setTotalActiveBalanceLimit(_totalActiveBalanceLimit);
3684 
3685         tree.init();
3686         // First tree item is an empty guardian
3687         assert(tree.insert(0, 0) == 0);
3688     }
3689 
3690     /**
3691     * @notice Stake `@tokenAmount(self.token(), _amount)` for `_guardian`
3692     * @param _guardian Address of the guardian to stake tokens to
3693     * @param _amount Amount of tokens to be staked
3694     */
3695     function stake(address _guardian, uint256 _amount) external {
3696         _stake(_guardian, _amount);
3697     }
3698 
3699     /**
3700     * @notice Unstake `@tokenAmount(self.token(), _amount)` from `_guardian`
3701     * @param _guardian Address of the guardian to unstake tokens from
3702     * @param _amount Amount of tokens to be unstaked
3703     */
3704     function unstake(address _guardian, uint256 _amount) external authenticateSender(_guardian) {
3705         _unstake(_guardian, _amount);
3706     }
3707 
3708     /**
3709     * @notice Activate `@tokenAmount(self.token(), _amount)` for `_guardian`
3710     * @param _guardian Address of the guardian activating the tokens for
3711     * @param _amount Amount of guardian tokens to be activated for the next term
3712     */
3713     function activate(address _guardian, uint256 _amount) external authenticateSender(_guardian) {
3714         _activate(_guardian, _amount);
3715     }
3716 
3717     /**
3718     * @notice Deactivate `_amount == 0 ? 'all unlocked tokens' : @tokenAmount(self.token(), _amount)` for `_guardian`
3719     * @param _guardian Address of the guardian deactivating the tokens for
3720     * @param _amount Amount of guardian tokens to be deactivated for the next term
3721     */
3722     function deactivate(address _guardian, uint256 _amount) external authenticateSender(_guardian) {
3723         _deactivate(_guardian, _amount);
3724     }
3725 
3726     /**
3727     * @notice Stake and activate `@tokenAmount(self.token(), _amount)` for `_guardian`
3728     * @param _guardian Address of the guardian staking and activating tokens for
3729     * @param _amount Amount of tokens to be staked and activated
3730     */
3731     function stakeAndActivate(address _guardian, uint256 _amount) external authenticateSender(_guardian) {
3732         _stake(_guardian, _amount);
3733         _activate(_guardian, _amount);
3734     }
3735 
3736     /**
3737     * @notice Lock `@tokenAmount(self.token(), _amount)` of `_guardian`'s active balance
3738     * @param _guardian Address of the guardian locking the activation for
3739     * @param _lockManager Address of the lock manager that will control the lock
3740     * @param _amount Amount of active tokens to be locked
3741     */
3742     function lockActivation(address _guardian, address _lockManager, uint256 _amount) external {
3743         // Make sure the sender is the guardian, someone allowed by the guardian, or the lock manager itself
3744         bool isLockManagerAllowed = msg.sender == _lockManager || _isSenderAllowed(_guardian);
3745         // Make sure that the given lock manager is allowed
3746         require(isLockManagerAllowed && _hasRole(_lockManager), ERROR_LOCK_MANAGER_NOT_ALLOWED);
3747 
3748         _lockActivation(_guardian, _lockManager, _amount);
3749     }
3750 
3751     /**
3752     * @notice Unlock  `_amount == 0 ? 'all unlocked tokens' : @tokenAmount(self.token(), _amount)` of `_guardian`'s active balance
3753     * @param _guardian Address of the guardian unlocking the active balance of
3754     * @param _lockManager Address of the lock manager controlling the lock
3755     * @param _amount Amount of active tokens to be unlocked
3756     * @param _requestDeactivation Whether the unlocked amount must be requested for deactivation immediately
3757     */
3758     function unlockActivation(address _guardian, address _lockManager, uint256 _amount, bool _requestDeactivation) external {
3759         ActivationLocks storage activationLocks = guardiansByAddress[_guardian].activationLocks;
3760         uint256 lockedAmount = activationLocks.lockedBy[_lockManager];
3761         require(lockedAmount > 0, ERROR_ZERO_LOCK_ACTIVATION);
3762 
3763         uint256 amountToUnlock = _amount == 0 ? lockedAmount : _amount;
3764         require(amountToUnlock <= lockedAmount, ERROR_INVALID_UNLOCK_ACTIVATION_AMOUNT);
3765 
3766         // Always allow the lock manager to unlock
3767         bool canUnlock = _lockManager == msg.sender || ILockManager(_lockManager).canUnlock(_guardian, amountToUnlock);
3768         require(canUnlock, ERROR_CANNOT_UNLOCK_ACTIVATION);
3769 
3770         uint256 newLockedAmount = lockedAmount.sub(amountToUnlock);
3771         uint256 newTotalLocked = activationLocks.total.sub(amountToUnlock);
3772 
3773         activationLocks.total = newTotalLocked;
3774         activationLocks.lockedBy[_lockManager] = newLockedAmount;
3775         emit GuardianActivationLockChanged(_guardian, _lockManager, newLockedAmount, newTotalLocked);
3776 
3777         // In order to request a deactivation, the request must have been originally authorized from the guardian or someone authorized to do it
3778         if (_requestDeactivation) {
3779             _authenticateSender(_guardian);
3780             _deactivate(_guardian, _amount);
3781         }
3782     }
3783 
3784     /**
3785     * @notice Process a token deactivation requested for `_guardian` if there is any
3786     * @param _guardian Address of the guardian to process the deactivation request of
3787     */
3788     function processDeactivationRequest(address _guardian) external {
3789         uint64 termId = _ensureCurrentTerm();
3790         _processDeactivationRequest(_guardian, termId);
3791     }
3792 
3793     /**
3794     * @notice Assign `@tokenAmount(self.token(), _amount)` to the available balance of `_guardian`
3795     * @param _guardian Guardian to add an amount of tokens to
3796     * @param _amount Amount of tokens to be added to the available balance of a guardian
3797     */
3798     function assignTokens(address _guardian, uint256 _amount) external onlyActiveDisputeManager {
3799         if (_amount > 0) {
3800             _updateAvailableBalanceOf(_guardian, _amount, true);
3801             emit GuardianTokensAssigned(_guardian, _amount);
3802         }
3803     }
3804 
3805     /**
3806     * @notice Burn `@tokenAmount(self.token(), _amount)`
3807     * @param _amount Amount of tokens to be burned
3808     */
3809     function burnTokens(uint256 _amount) external onlyActiveDisputeManager {
3810         if (_amount > 0) {
3811             _updateAvailableBalanceOf(BURN_ACCOUNT, _amount, true);
3812             emit GuardianTokensBurned(_amount);
3813         }
3814     }
3815 
3816     /**
3817     * @notice Draft a set of guardians based on given requirements for a term id
3818     * @param _params Array containing draft requirements:
3819     *        0. bytes32 Term randomness
3820     *        1. uint256 Dispute id
3821     *        2. uint64  Current term id
3822     *        3. uint256 Number of seats already filled
3823     *        4. uint256 Number of seats left to be filled
3824     *        5. uint64  Number of guardians required for the draft
3825     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
3826     *
3827     * @return guardians List of guardians selected for the draft
3828     * @return length Size of the list of the draft result
3829     */
3830     function draft(uint256[7] calldata _params) external onlyActiveDisputeManager returns (address[] memory guardians, uint256 length) {
3831         DraftParams memory draftParams = _buildDraftParams(_params);
3832         guardians = new address[](draftParams.batchRequestedGuardians);
3833 
3834         // Guardians returned by the tree multi-sortition may not have enough unlocked active balance to be drafted. Thus,
3835         // we compute several sortitions until all the requested guardians are selected. To guarantee a different set of
3836         // guardians on each sortition, the iteration number will be part of the random seed to be used in the sortition.
3837         // Note that we are capping the number of iterations to avoid an OOG error, which means that this function could
3838         // return less guardians than the requested number.
3839 
3840         for (draftParams.iteration = 0;
3841              length < draftParams.batchRequestedGuardians && draftParams.iteration < MAX_DRAFT_ITERATIONS;
3842              draftParams.iteration++
3843         ) {
3844             (uint256[] memory guardianIds, uint256[] memory activeBalances) = _treeSearch(draftParams);
3845 
3846             for (uint256 i = 0; i < guardianIds.length && length < draftParams.batchRequestedGuardians; i++) {
3847                 // We assume the selected guardians are registered in the registry, we are not checking their addresses exist
3848                 address guardianAddress = guardiansAddressById[guardianIds[i]];
3849                 Guardian storage guardian = guardiansByAddress[guardianAddress];
3850 
3851                 // Compute new locked balance for a guardian based on the penalty applied when being drafted
3852                 uint256 newLockedBalance = guardian.lockedBalance.add(draftParams.draftLockAmount);
3853 
3854                 // Check if there is any deactivation requests for the next term. Drafts are always computed for the current term
3855                 // but we have to make sure we are locking an amount that will exist in the next term.
3856                 uint256 nextTermDeactivationRequestAmount = _deactivationRequestedAmountForTerm(guardian, draftParams.termId + 1);
3857 
3858                 // Check if guardian has enough active tokens to lock the requested amount for the draft, skip it otherwise.
3859                 uint256 currentActiveBalance = activeBalances[i];
3860                 if (currentActiveBalance >= newLockedBalance) {
3861 
3862                     // Check if the amount of active tokens for the next term is enough to lock the required amount for
3863                     // the draft. Otherwise, reduce the requested deactivation amount of the next term.
3864                     // Next term deactivation amount should always be less than current active balance, but we make sure using SafeMath
3865                     uint256 nextTermActiveBalance = currentActiveBalance.sub(nextTermDeactivationRequestAmount);
3866                     if (nextTermActiveBalance < newLockedBalance) {
3867                         // No need for SafeMath: we already checked values above
3868                         _reduceDeactivationRequest(guardianAddress, newLockedBalance - nextTermActiveBalance, draftParams.termId);
3869                     }
3870 
3871                     // Update the current active locked balance of the guardian
3872                     guardian.lockedBalance = newLockedBalance;
3873                     guardians[length++] = guardianAddress;
3874                     emit GuardianBalanceLocked(guardianAddress, draftParams.draftLockAmount);
3875                 }
3876             }
3877         }
3878     }
3879 
3880     /**
3881     * @notice Slash a set of guardians based on their votes compared to the winning ruling. This function will unlock the
3882     *         corresponding locked balances of those guardians that are set to be slashed.
3883     * @param _termId Current term id
3884     * @param _guardians List of guardian addresses to be slashed
3885     * @param _lockedAmounts List of amounts locked for each corresponding guardian that will be either slashed or returned
3886     * @param _rewardedGuardians List of booleans to tell whether a guardian's active balance has to be slashed or not
3887     * @return Total amount of slashed tokens
3888     */
3889     function slashOrUnlock(uint64 _termId, address[] calldata _guardians, uint256[] calldata _lockedAmounts, bool[] calldata _rewardedGuardians)
3890         external
3891         onlyActiveDisputeManager
3892         returns (uint256)
3893     {
3894         require(_guardians.length == _lockedAmounts.length, ERROR_INVALID_LOCKED_AMOUNTS_LENGTH);
3895         require(_guardians.length == _rewardedGuardians.length, ERROR_INVALID_REWARDED_GUARDIANS_LENGTH);
3896 
3897         uint64 nextTermId = _termId + 1;
3898         uint256 collectedTokens;
3899 
3900         for (uint256 i = 0; i < _guardians.length; i++) {
3901             uint256 lockedAmount = _lockedAmounts[i];
3902             address guardianAddress = _guardians[i];
3903             Guardian storage guardian = guardiansByAddress[guardianAddress];
3904             guardian.lockedBalance = guardian.lockedBalance.sub(lockedAmount);
3905 
3906             // Slash guardian if requested. Note that there's no need to check if there was a deactivation
3907             // request since we're working with already locked balances.
3908             if (_rewardedGuardians[i]) {
3909                 emit GuardianBalanceUnlocked(guardianAddress, lockedAmount);
3910             } else {
3911                 collectedTokens = collectedTokens.add(lockedAmount);
3912                 tree.update(guardian.id, nextTermId, lockedAmount, false);
3913                 emit GuardianSlashed(guardianAddress, lockedAmount, nextTermId);
3914             }
3915         }
3916 
3917         return collectedTokens;
3918     }
3919 
3920     /**
3921     * @notice Try to collect `@tokenAmount(self.token(), _amount)` from `_guardian` for the term #`_termId + 1`.
3922     * @dev This function tries to decrease the active balance of a guardian for the next term based on the requested
3923     *      amount. It can be seen as a way to early-slash a guardian's active balance.
3924     * @param _guardian Guardian to collect the tokens from
3925     * @param _amount Amount of tokens to be collected from the given guardian and for the requested term id
3926     * @param _termId Current term id
3927     * @return True if the guardian has enough unlocked tokens to be collected for the requested term, false otherwise
3928     */
3929     function collectTokens(address _guardian, uint256 _amount, uint64 _termId) external onlyActiveDisputeManager returns (bool) {
3930         if (_amount == 0) {
3931             return true;
3932         }
3933 
3934         uint64 nextTermId = _termId + 1;
3935         Guardian storage guardian = guardiansByAddress[_guardian];
3936         uint256 unlockedActiveBalance = _lastUnlockedActiveBalanceOf(guardian);
3937         uint256 nextTermDeactivationRequestAmount = _deactivationRequestedAmountForTerm(guardian, nextTermId);
3938 
3939         // Check if the guardian has enough unlocked tokens to collect the requested amount
3940         // Note that we're also considering the deactivation request if there is any
3941         uint256 totalUnlockedActiveBalance = unlockedActiveBalance.add(nextTermDeactivationRequestAmount);
3942         if (_amount > totalUnlockedActiveBalance) {
3943             return false;
3944         }
3945 
3946         // Check if the amount of active tokens is enough to collect the requested amount, otherwise reduce the requested deactivation amount of
3947         // the next term. Note that this behaviour is different to the one when drafting guardians since this function is called as a side effect
3948         // of a guardian deliberately voting in a final round, while drafts occur randomly.
3949         if (_amount > unlockedActiveBalance) {
3950             // No need for SafeMath: amounts were already checked above
3951             uint256 amountToReduce = _amount - unlockedActiveBalance;
3952             _reduceDeactivationRequest(_guardian, amountToReduce, _termId);
3953         }
3954         tree.update(guardian.id, nextTermId, _amount, false);
3955 
3956         emit GuardianTokensCollected(_guardian, _amount, nextTermId);
3957         return true;
3958     }
3959 
3960     /**
3961     * @notice Lock `_guardian`'s withdrawals until term #`_termId`
3962     * @dev This is intended for guardians who voted in a final round and were coherent with the final ruling to prevent 51% attacks
3963     * @param _guardian Address of the guardian to be locked
3964     * @param _termId Term ID until which the guardian's withdrawals will be locked
3965     */
3966     function lockWithdrawals(address _guardian, uint64 _termId) external onlyActiveDisputeManager {
3967         Guardian storage guardian = guardiansByAddress[_guardian];
3968         guardian.withdrawalsLockTermId = _termId;
3969     }
3970 
3971     /**
3972     * @notice Set new limit of total active balance of guardian tokens
3973     * @param _totalActiveBalanceLimit New limit of total active balance of guardian tokens
3974     */
3975     function setTotalActiveBalanceLimit(uint256 _totalActiveBalanceLimit) external onlyConfigGovernor {
3976         _setTotalActiveBalanceLimit(_totalActiveBalanceLimit);
3977     }
3978 
3979     /**
3980     * @dev Tell the total supply of guardian tokens staked
3981     * @return Supply of guardian tokens staked
3982     */
3983     function totalSupply() external view returns (uint256) {
3984         return guardiansToken.balanceOf(address(this));
3985     }
3986 
3987     /**
3988     * @dev Tell the total amount of active guardian tokens
3989     * @return Total amount of active guardian tokens
3990     */
3991     function totalActiveBalance() external view returns (uint256) {
3992         return tree.getTotal();
3993     }
3994 
3995     /**
3996     * @dev Tell the total amount of active guardian tokens for a given term id
3997     * @param _termId Term ID to query on
3998     * @return Total amount of active guardian tokens at the given term id
3999     */
4000     function totalActiveBalanceAt(uint64 _termId) external view returns (uint256) {
4001         return _totalActiveBalanceAt(_termId);
4002     }
4003 
4004     /**
4005     * @dev Tell the total balance of tokens held by a guardian
4006     *      This includes the active balance, the available balances, and the pending balance for deactivation.
4007     *      Note that we don't have to include the locked balances since these represent the amount of active tokens
4008     *      that are locked for drafts, i.e. these are already included in the active balance of the guardian.
4009     * @param _guardian Address of the guardian querying the balance of
4010     * @return Total amount of tokens of a guardian
4011     */
4012     function balanceOf(address _guardian) external view returns (uint256) {
4013         return _balanceOf(_guardian);
4014     }
4015 
4016     /**
4017     * @dev Tell the detailed balance information of a guardian
4018     * @param _guardian Address of the guardian querying the detailed balance information of
4019     * @return active Amount of active tokens of a guardian
4020     * @return available Amount of available tokens of a guardian
4021     * @return locked Amount of active tokens that are locked due to ongoing disputes
4022     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
4023     */
4024     function detailedBalanceOf(address _guardian) external view
4025         returns (uint256 active, uint256 available, uint256 locked, uint256 pendingDeactivation)
4026     {
4027         return _detailedBalanceOf(_guardian);
4028     }
4029 
4030     /**
4031     * @dev Tell the active balance of a guardian for a given term id
4032     * @param _guardian Address of the guardian querying the active balance of
4033     * @param _termId Term ID to query on
4034     * @return Amount of active tokens for guardian in the requested past term id
4035     */
4036     function activeBalanceOfAt(address _guardian, uint64 _termId) external view returns (uint256) {
4037         return _activeBalanceOfAt(_guardian, _termId);
4038     }
4039 
4040     /**
4041     * @dev Tell the amount of active tokens of a guardian at the last ensured term that are not locked due to ongoing disputes
4042     * @param _guardian Address of the guardian querying the unlocked balance of
4043     * @return Amount of active tokens of a guardian that are not locked due to ongoing disputes
4044     */
4045     function unlockedActiveBalanceOf(address _guardian) external view returns (uint256) {
4046         Guardian storage guardian = guardiansByAddress[_guardian];
4047         return _currentUnlockedActiveBalanceOf(guardian);
4048     }
4049 
4050     /**
4051     * @dev Tell the pending deactivation details for a guardian
4052     * @param _guardian Address of the guardian whose info is requested
4053     * @return amount Amount to be deactivated
4054     * @return availableTermId Term in which the deactivated amount will be available
4055     */
4056     function getDeactivationRequest(address _guardian) external view returns (uint256 amount, uint64 availableTermId) {
4057         DeactivationRequest storage request = guardiansByAddress[_guardian].deactivationRequest;
4058         return (request.amount, request.availableTermId);
4059     }
4060 
4061     /**
4062     * @dev Tell the activation amount locked for a guardian by a lock manager
4063     * @param _guardian Address of the guardian whose info is requested
4064     * @param _lockManager Address of the lock manager querying the lock of
4065     * @return amount Activation amount locked by the lock manager
4066     * @return total Total activation amount locked for the guardian
4067     */
4068     function getActivationLock(address _guardian, address _lockManager) external view returns (uint256 amount, uint256 total) {
4069         ActivationLocks storage activationLocks = guardiansByAddress[_guardian].activationLocks;
4070         total = activationLocks.total;
4071         amount = activationLocks.lockedBy[_lockManager];
4072     }
4073 
4074     /**
4075     * @dev Tell the withdrawals lock term ID for a guardian
4076     * @param _guardian Address of the guardian whose info is requested
4077     * @return Term ID until which the guardian's withdrawals will be locked
4078     */
4079     function getWithdrawalsLockTermId(address _guardian) external view returns (uint64) {
4080         return guardiansByAddress[_guardian].withdrawalsLockTermId;
4081     }
4082 
4083     /**
4084     * @dev Tell the identification number associated to a guardian address
4085     * @param _guardian Address of the guardian querying the identification number of
4086     * @return Identification number associated to a guardian address, zero in case it wasn't registered yet
4087     */
4088     function getGuardianId(address _guardian) external view returns (uint256) {
4089         return guardiansByAddress[_guardian].id;
4090     }
4091 
4092     /**
4093     * @dev Internal function to activate a given amount of tokens for a guardian.
4094     *      This function assumes that the given term is the current term and has already been ensured.
4095     * @param _guardian Address of the guardian to activate tokens
4096     * @param _amount Amount of guardian tokens to be activated
4097     */
4098     function _activate(address _guardian, uint256 _amount) internal {
4099         uint64 termId = _ensureCurrentTerm();
4100 
4101         // Try to clean a previous deactivation request if any
4102         _processDeactivationRequest(_guardian, termId);
4103 
4104         uint256 availableBalance = guardiansByAddress[_guardian].availableBalance;
4105         uint256 amountToActivate = _amount == 0 ? availableBalance : _amount;
4106         require(amountToActivate > 0, ERROR_INVALID_ZERO_AMOUNT);
4107         require(amountToActivate <= availableBalance, ERROR_INVALID_ACTIVATION_AMOUNT);
4108 
4109         uint64 nextTermId = termId + 1;
4110         _checkTotalActiveBalance(nextTermId, amountToActivate);
4111         Guardian storage guardian = guardiansByAddress[_guardian];
4112         uint256 minActiveBalance = _getMinActiveBalance(nextTermId);
4113 
4114         if (_existsGuardian(guardian)) {
4115             // Even though we are adding amounts, let's check the new active balance is greater than or equal to the
4116             // minimum active amount. Note that the guardian might have been slashed.
4117             uint256 activeBalance = tree.getItem(guardian.id);
4118             require(activeBalance.add(amountToActivate) >= minActiveBalance, ERROR_ACTIVE_BALANCE_BELOW_MIN);
4119             tree.update(guardian.id, nextTermId, amountToActivate, true);
4120         } else {
4121             require(amountToActivate >= minActiveBalance, ERROR_ACTIVE_BALANCE_BELOW_MIN);
4122             guardian.id = tree.insert(nextTermId, amountToActivate);
4123             guardiansAddressById[guardian.id] = _guardian;
4124         }
4125 
4126         _updateAvailableBalanceOf(_guardian, amountToActivate, false);
4127         emit GuardianActivated(_guardian, nextTermId, amountToActivate);
4128     }
4129 
4130     /**
4131     * @dev Internal function to deactivate a given amount of tokens for a guardian.
4132     * @param _guardian Address of the guardian to deactivate tokens
4133     * @param _amount Amount of guardian tokens to be deactivated for the next term
4134     */
4135     function _deactivate(address _guardian, uint256 _amount) internal {
4136         uint64 termId = _ensureCurrentTerm();
4137         Guardian storage guardian = guardiansByAddress[_guardian];
4138         uint256 unlockedActiveBalance = _lastUnlockedActiveBalanceOf(guardian);
4139         uint256 amountToDeactivate = _amount == 0 ? unlockedActiveBalance : _amount;
4140         require(amountToDeactivate > 0, ERROR_INVALID_ZERO_AMOUNT);
4141         require(amountToDeactivate <= unlockedActiveBalance, ERROR_INVALID_DEACTIVATION_AMOUNT);
4142 
4143         // Check future balance is not below the total activation lock of the guardian
4144         // No need for SafeMath: we already checked values above
4145         uint256 futureActiveBalance = unlockedActiveBalance - amountToDeactivate;
4146         uint256 totalActivationLock = guardian.activationLocks.total;
4147         require(futureActiveBalance >= totalActivationLock, ERROR_DEACTIVATION_AMOUNT_EXCEEDS_LOCK);
4148 
4149         // Check that the guardian is leaving or that the minimum active balance is met
4150         uint256 minActiveBalance = _getMinActiveBalance(termId);
4151         require(futureActiveBalance == 0 || futureActiveBalance >= minActiveBalance, ERROR_INVALID_DEACTIVATION_AMOUNT);
4152 
4153         _createDeactivationRequest(_guardian, amountToDeactivate);
4154     }
4155 
4156     /**
4157     * @dev Internal function to create a token deactivation request for a guardian. Guardians will be allowed
4158     *      to process a deactivation request from the next term.
4159     * @param _guardian Address of the guardian to create a token deactivation request for
4160     * @param _amount Amount of guardian tokens requested for deactivation
4161     */
4162     function _createDeactivationRequest(address _guardian, uint256 _amount) internal {
4163         uint64 termId = _ensureCurrentTerm();
4164 
4165         // Try to clean a previous deactivation request if possible
4166         _processDeactivationRequest(_guardian, termId);
4167 
4168         uint64 nextTermId = termId + 1;
4169         Guardian storage guardian = guardiansByAddress[_guardian];
4170         DeactivationRequest storage request = guardian.deactivationRequest;
4171         request.amount = request.amount.add(_amount);
4172         request.availableTermId = nextTermId;
4173         tree.update(guardian.id, nextTermId, _amount, false);
4174 
4175         emit GuardianDeactivationRequested(_guardian, nextTermId, _amount);
4176     }
4177 
4178     /**
4179     * @dev Internal function to process a token deactivation requested by a guardian. It will move the requested amount
4180     *      to the available balance of the guardian if the term when the deactivation was requested has already finished.
4181     * @param _guardian Address of the guardian to process the deactivation request of
4182     * @param _termId Current term id
4183     */
4184     function _processDeactivationRequest(address _guardian, uint64 _termId) internal {
4185         Guardian storage guardian = guardiansByAddress[_guardian];
4186         DeactivationRequest storage request = guardian.deactivationRequest;
4187         uint64 deactivationAvailableTermId = request.availableTermId;
4188 
4189         // If there is a deactivation request, ensure that the deactivation term has been reached
4190         if (deactivationAvailableTermId == uint64(0) || _termId < deactivationAvailableTermId) {
4191             return;
4192         }
4193 
4194         uint256 deactivationAmount = request.amount;
4195         // Note that we can use a zeroed term ID to denote void here since we are storing
4196         // the minimum allowed term to deactivate tokens which will always be at least 1.
4197         request.availableTermId = uint64(0);
4198         request.amount = 0;
4199         _updateAvailableBalanceOf(_guardian, deactivationAmount, true);
4200 
4201         emit GuardianDeactivationProcessed(_guardian, deactivationAvailableTermId, deactivationAmount, _termId);
4202     }
4203 
4204     /**
4205     * @dev Internal function to reduce a token deactivation requested by a guardian. It assumes the deactivation request
4206     *      cannot be processed for the given term yet.
4207     * @param _guardian Address of the guardian to reduce the deactivation request of
4208     * @param _amount Amount to be reduced from the current deactivation request
4209     * @param _termId Term ID in which the deactivation request is being reduced
4210     */
4211     function _reduceDeactivationRequest(address _guardian, uint256 _amount, uint64 _termId) internal {
4212         Guardian storage guardian = guardiansByAddress[_guardian];
4213         DeactivationRequest storage request = guardian.deactivationRequest;
4214         uint256 currentRequestAmount = request.amount;
4215         require(currentRequestAmount >= _amount, ERROR_CANNOT_REDUCE_DEACTIVATION_REQUEST);
4216 
4217         // No need for SafeMath: we already checked values above
4218         uint256 newRequestAmount = currentRequestAmount - _amount;
4219         request.amount = newRequestAmount;
4220 
4221         // Move amount back to the tree
4222         tree.update(guardian.id, _termId + 1, _amount, true);
4223 
4224         emit GuardianDeactivationUpdated(_guardian, request.availableTermId, newRequestAmount, _termId);
4225     }
4226 
4227     /**
4228     * @dev Internal function to update the activation locked amount of a guardian
4229     * @param _guardian Guardian to update the activation locked amount of
4230     * @param _lockManager Address of the lock manager controlling the lock
4231     * @param _amount Amount of tokens to be added to the activation locked amount of the guardian
4232     */
4233     function _lockActivation(address _guardian, address _lockManager, uint256 _amount) internal {
4234         ActivationLocks storage activationLocks = guardiansByAddress[_guardian].activationLocks;
4235         uint256 newTotalLocked = activationLocks.total.add(_amount);
4236         uint256 newLockedAmount = activationLocks.lockedBy[_lockManager].add(_amount);
4237 
4238         activationLocks.total = newTotalLocked;
4239         activationLocks.lockedBy[_lockManager] = newLockedAmount;
4240         emit GuardianActivationLockChanged(_guardian, _lockManager, newLockedAmount, newTotalLocked);
4241     }
4242 
4243     /**
4244     * @dev Internal function to stake an amount of tokens for a guardian
4245     * @param _guardian Address of the guardian to deposit the tokens to
4246     * @param _amount Amount of tokens to be deposited
4247     */
4248     function _stake(address _guardian, uint256 _amount) internal {
4249         require(_amount > 0, ERROR_INVALID_ZERO_AMOUNT);
4250         _updateAvailableBalanceOf(_guardian, _amount, true);
4251 
4252         emit Staked(_guardian, _amount, _balanceOf(_guardian));
4253         require(guardiansToken.safeTransferFrom(msg.sender, address(this), _amount), ERROR_TOKEN_TRANSFER_FAILED);
4254     }
4255 
4256     /**
4257     * @dev Internal function to unstake an amount of tokens of a guardian
4258     * @param _guardian Address of the guardian to to unstake the tokens of
4259     * @param _amount Amount of tokens to be unstaked
4260     */
4261     function _unstake(address _guardian, uint256 _amount) internal {
4262         require(_amount > 0, ERROR_INVALID_ZERO_AMOUNT);
4263 
4264         // Try to process a deactivation request for the current term if there is one. Note that we don't need to ensure
4265         // the current term this time since deactivation requests always work with future terms, which means that if
4266         // the current term is outdated, it will never match the deactivation term id. We avoid ensuring the term here
4267         // to avoid forcing guardians to do that in order to withdraw their available balance. Same applies to final round locks.
4268         uint64 lastEnsuredTermId = _getLastEnsuredTermId();
4269 
4270         // Check that guardian's withdrawals are not locked
4271         uint64 withdrawalsLockTermId = guardiansByAddress[_guardian].withdrawalsLockTermId;
4272         require(withdrawalsLockTermId == 0 || withdrawalsLockTermId < lastEnsuredTermId, ERROR_WITHDRAWALS_LOCK);
4273 
4274         _processDeactivationRequest(_guardian, lastEnsuredTermId);
4275 
4276         _updateAvailableBalanceOf(_guardian, _amount, false);
4277         emit Unstaked(_guardian, _amount, _balanceOf(_guardian));
4278         require(guardiansToken.safeTransfer(_guardian, _amount), ERROR_TOKEN_TRANSFER_FAILED);
4279     }
4280 
4281     /**
4282     * @dev Internal function to update the available balance of a guardian
4283     * @param _guardian Guardian to update the available balance of
4284     * @param _amount Amount of tokens to be added to or removed from the available balance of a guardian
4285     * @param _positive True if the given amount should be added, or false to remove it from the available balance
4286     */
4287     function _updateAvailableBalanceOf(address _guardian, uint256 _amount, bool _positive) internal {
4288         // We are not using a require here to avoid reverting in case any of the treasury maths reaches this point
4289         // with a zeroed amount value. Instead, we are doing this validation in the external entry points such as
4290         // stake, unstake, activate, deactivate, among others.
4291         if (_amount == 0) {
4292             return;
4293         }
4294 
4295         Guardian storage guardian = guardiansByAddress[_guardian];
4296         if (_positive) {
4297             guardian.availableBalance = guardian.availableBalance.add(_amount);
4298         } else {
4299             require(_amount <= guardian.availableBalance, ERROR_NOT_ENOUGH_AVAILABLE_BALANCE);
4300             // No need for SafeMath: we already checked values right above
4301             guardian.availableBalance -= _amount;
4302         }
4303     }
4304 
4305     /**
4306     * @dev Internal function to set new limit of total active balance of guardian tokens
4307     * @param _totalActiveBalanceLimit New limit of total active balance of guardian tokens
4308     */
4309     function _setTotalActiveBalanceLimit(uint256 _totalActiveBalanceLimit) internal {
4310         require(_totalActiveBalanceLimit > 0, ERROR_BAD_TOTAL_ACTIVE_BALANCE_LIMIT);
4311         emit TotalActiveBalanceLimitChanged(totalActiveBalanceLimit, _totalActiveBalanceLimit);
4312         totalActiveBalanceLimit = _totalActiveBalanceLimit;
4313     }
4314 
4315     /**
4316     * @dev Internal function to tell the total balance of tokens held by a guardian
4317     * @param _guardian Address of the guardian querying the total balance of
4318     * @return Total amount of tokens of a guardian
4319     */
4320     function _balanceOf(address _guardian) internal view returns (uint256) {
4321         (uint256 active, uint256 available, , uint256 pendingDeactivation) = _detailedBalanceOf(_guardian);
4322         return available.add(active).add(pendingDeactivation);
4323     }
4324 
4325     /**
4326     * @dev Internal function to tell the detailed balance information of a guardian
4327     * @param _guardian Address of the guardian querying the balance information of
4328     * @return active Amount of active tokens of a guardian
4329     * @return available Amount of available tokens of a guardian
4330     * @return locked Amount of active tokens that are locked due to ongoing disputes
4331     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
4332     */
4333     function _detailedBalanceOf(address _guardian) internal view
4334         returns (uint256 active, uint256 available, uint256 locked, uint256 pendingDeactivation)
4335     {
4336         Guardian storage guardian = guardiansByAddress[_guardian];
4337 
4338         active = _existsGuardian(guardian) ? tree.getItem(guardian.id) : 0;
4339         (available, locked, pendingDeactivation) = _getBalances(guardian);
4340     }
4341 
4342     /**
4343     * @dev Tell the active balance of a guardian for a given term id
4344     * @param _guardian Address of the guardian querying the active balance of
4345     * @param _termId Term ID querying the active balance for
4346     * @return Amount of active tokens for guardian in the requested past term id
4347     */
4348     function _activeBalanceOfAt(address _guardian, uint64 _termId) internal view returns (uint256) {
4349         Guardian storage guardian = guardiansByAddress[_guardian];
4350         return _existsGuardian(guardian) ? tree.getItemAt(guardian.id, _termId) : 0;
4351     }
4352 
4353     /**
4354     * @dev Internal function to get the amount of active tokens of a guardian that are not locked due to ongoing disputes
4355     *      It will use the last value, that might be in a future term
4356     * @param _guardian Guardian querying the unlocked active balance of
4357     * @return Amount of active tokens of a guardian that are not locked due to ongoing disputes
4358     */
4359     function _lastUnlockedActiveBalanceOf(Guardian storage _guardian) internal view returns (uint256) {
4360         return _existsGuardian(_guardian) ? tree.getItem(_guardian.id).sub(_guardian.lockedBalance) : 0;
4361     }
4362 
4363     /**
4364     * @dev Internal function to get the amount of active tokens at the last ensured term of a guardian that are not locked due to ongoing disputes
4365     * @param _guardian Guardian querying the unlocked active balance of
4366     * @return Amount of active tokens of a guardian that are not locked due to ongoing disputes
4367     */
4368     function _currentUnlockedActiveBalanceOf(Guardian storage _guardian) internal view returns (uint256) {
4369         uint64 lastEnsuredTermId = _getLastEnsuredTermId();
4370         return _existsGuardian(_guardian) ? tree.getItemAt(_guardian.id, lastEnsuredTermId).sub(_guardian.lockedBalance) : 0;
4371     }
4372 
4373     /**
4374     * @dev Internal function to check if a guardian was already registered
4375     * @param _guardian Guardian to be checked
4376     * @return True if the given guardian was already registered, false otherwise
4377     */
4378     function _existsGuardian(Guardian storage _guardian) internal view returns (bool) {
4379         return _guardian.id != 0;
4380     }
4381 
4382     /**
4383     * @dev Internal function to get the amount of a deactivation request for a given term id
4384     * @param _guardian Guardian to query the deactivation request amount of
4385     * @param _termId Term ID of the deactivation request to be queried
4386     * @return Amount of the deactivation request for the given term, 0 otherwise
4387     */
4388     function _deactivationRequestedAmountForTerm(Guardian storage _guardian, uint64 _termId) internal view returns (uint256) {
4389         DeactivationRequest storage request = _guardian.deactivationRequest;
4390         return request.availableTermId == _termId ? request.amount : 0;
4391     }
4392 
4393     /**
4394     * @dev Internal function to tell the total amount of active guardian tokens at the given term id
4395     * @param _termId Term ID querying the total active balance for
4396     * @return Total amount of active guardian tokens at the given term id
4397     */
4398     function _totalActiveBalanceAt(uint64 _termId) internal view returns (uint256) {
4399         // This function will return always the same values, the only difference remains on gas costs. In case we look for a
4400         // recent term, in this case current or future ones, we perform a backwards linear search from the last checkpoint.
4401         // Otherwise, a binary search is computed.
4402         bool recent = _termId >= _getLastEnsuredTermId();
4403         return recent ? tree.getRecentTotalAt(_termId) : tree.getTotalAt(_termId);
4404     }
4405 
4406     /**
4407     * @dev Internal function to check if its possible to add a given new amount to the registry or not
4408     * @param _termId Term ID when the new amount will be added
4409     * @param _amount Amount of tokens willing to be added to the registry
4410     */
4411     function _checkTotalActiveBalance(uint64 _termId, uint256 _amount) internal view {
4412         uint256 currentTotalActiveBalance = _totalActiveBalanceAt(_termId);
4413         uint256 newTotalActiveBalance = currentTotalActiveBalance.add(_amount);
4414         require(newTotalActiveBalance <= totalActiveBalanceLimit, ERROR_TOTAL_ACTIVE_BALANCE_EXCEEDED);
4415     }
4416 
4417     /**
4418     * @dev Tell the local balance information of a guardian (that is not on the tree)
4419     * @param _guardian Address of the guardian querying the balance information of
4420     * @return available Amount of available tokens of a guardian
4421     * @return locked Amount of active tokens that are locked due to ongoing disputes
4422     * @return pendingDeactivation Amount of active tokens that were requested for deactivation
4423     */
4424     function _getBalances(Guardian storage _guardian) internal view returns (uint256 available, uint256 locked, uint256 pendingDeactivation) {
4425         available = _guardian.availableBalance;
4426         locked = _guardian.lockedBalance;
4427         pendingDeactivation = _guardian.deactivationRequest.amount;
4428     }
4429 
4430     /**
4431     * @dev Internal function to search guardians in the tree based on certain search restrictions
4432     * @param _params Draft params to be used for the guardians search
4433     * @return ids List of guardian ids obtained based on the requested search
4434     * @return activeBalances List of active balances for each guardian obtained based on the requested search
4435     */
4436     function _treeSearch(DraftParams memory _params) internal view returns (uint256[] memory ids, uint256[] memory activeBalances) {
4437         (ids, activeBalances) = tree.batchedRandomSearch(
4438             _params.termRandomness,
4439             _params.disputeId,
4440             _params.termId,
4441             _params.selectedGuardians,
4442             _params.batchRequestedGuardians,
4443             _params.roundRequestedGuardians,
4444             _params.iteration
4445         );
4446     }
4447 
4448     /**
4449     * @dev Private function to parse a certain set given of draft params
4450     * @param _params Array containing draft requirements:
4451     *        0. bytes32 Term randomness
4452     *        1. uint256 Dispute id
4453     *        2. uint64  Current term id
4454     *        3. uint256 Number of seats already filled
4455     *        4. uint256 Number of seats left to be filled
4456     *        5. uint64  Number of guardians required for the draft
4457     *        6. uint16  Permyriad of the minimum active balance to be locked for the draft
4458     *
4459     * @return Draft params object parsed
4460     */
4461     function _buildDraftParams(uint256[7] memory _params) private view returns (DraftParams memory) {
4462         uint64 termId = uint64(_params[2]);
4463         uint256 minActiveBalance = _getMinActiveBalance(termId);
4464 
4465         return DraftParams({
4466             termRandomness: bytes32(_params[0]),
4467             disputeId: _params[1],
4468             termId: termId,
4469             selectedGuardians: _params[3],
4470             batchRequestedGuardians: _params[4],
4471             roundRequestedGuardians: _params[5],
4472             draftLockAmount: minActiveBalance.pct(uint16(_params[6])),
4473             iteration: 0
4474         });
4475     }
4476 }