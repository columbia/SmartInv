1 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.2;
4 pragma experimental "ABIEncoderV2";
5 
6 /**
7  * @title Helps contracts guard against reentrancy attacks.
8  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
9  * @dev If you mark a function `nonReentrant`, you should also
10  * mark it `external`.
11  */
12 contract ReentrancyGuard {
13     /// @dev counter to allow mutex lock with only one SSTORE operation
14     uint256 private _guardCounter;
15 
16     constructor () internal {
17         // The counter starts at one to prevent changing it from zero to a non-zero
18         // value, which is a more expensive operation.
19         _guardCounter = 1;
20     }
21 
22     /**
23      * @dev Prevents a contract from calling itself, directly or indirectly.
24      * Calling a `nonReentrant` function from another `nonReentrant`
25      * function is not supported. It is possible to prevent this from happening
26      * by making the `nonReentrant` function external, and make it call a
27      * `private` function that does the actual work.
28      */
29     modifier nonReentrant() {
30         _guardCounter += 1;
31         uint256 localCounter = _guardCounter;
32         _;
33         require(localCounter == _guardCounter);
34     }
35 }
36 
37 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
38 
39 pragma solidity ^0.5.2;
40 
41 /**
42  * @title SafeMath
43  * @dev Unsigned math operations with safety checks that revert on error
44  */
45 library SafeMath {
46     /**
47      * @dev Multiplies two unsigned integers, reverts on overflow.
48      */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b);
59 
60         return c;
61     }
62 
63     /**
64      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
65      */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Solidity only automatically asserts when dividing by 0
68         require(b > 0);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     /**
76      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77      */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b <= a);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Adds two unsigned integers, reverts on overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a);
91 
92         return c;
93     }
94 
95     /**
96      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
97      * reverts when dividing by zero.
98      */
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0);
101         return a % b;
102     }
103 }
104 
105 // File: contracts/meta-oracles/lib/LinkedListLibraryV2.sol
106 
107 /*
108     Copyright 2019 Set Labs Inc.
109 
110     Licensed under the Apache License, Version 2.0 (the "License");
111     you may not use this file except in compliance with the License.
112     You may obtain a copy of the License at
113 
114     http://www.apache.org/licenses/LICENSE-2.0
115 
116     Unless required by applicable law or agreed to in writing, software
117     distributed under the License is distributed on an "AS IS" BASIS,
118     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
119     See the License for the specific language governing permissions and
120     limitations under the License.
121 */
122 
123 pragma solidity 0.5.7;
124 
125 
126 
127 
128 /**
129  * @title LinkedListLibraryV2
130  * @author Set Protocol
131  *
132  * Library for creating and altering uni-directional circularly linked lists, optimized for sequential updating
133  * Version two of this contract is a library vs. a contract.
134  *
135  *
136  * CHANGELOG
137  * - LinkedListLibraryV2 is declared as library vs. contract
138  */
139 library LinkedListLibraryV2 {
140 
141     using SafeMath for uint256;
142 
143     /* ============ Structs ============ */
144 
145     struct LinkedList{
146         uint256 dataSizeLimit;
147         uint256 lastUpdatedIndex;
148         uint256[] dataArray;
149     }
150 
151     /*
152      * Initialize LinkedList by setting limit on amount of nodes and inital value of node 0
153      *
154      * @param  _self                        LinkedList to operate on
155      * @param  _dataSizeLimit               Max amount of nodes allowed in LinkedList
156      * @param  _initialValue                Initial value of node 0 in LinkedList
157      */
158     function initialize(
159         LinkedList storage _self,
160         uint256 _dataSizeLimit,
161         uint256 _initialValue
162     )
163         internal
164     {
165         require(
166             _self.dataArray.length == 0,
167             "LinkedListLibrary: Initialized LinkedList must be empty"
168         );
169 
170         // Initialize Linked list by defining upper limit of data points in the list and setting
171         // initial value
172         _self.dataSizeLimit = _dataSizeLimit;
173         _self.dataArray.push(_initialValue);
174         _self.lastUpdatedIndex = 0;
175     }
176 
177     /*
178      * Add new value to list by either creating new node if node limit not reached or updating
179      * existing node value
180      *
181      * @param  _self                        LinkedList to operate on
182      * @param  _addedValue                  Value to add to list
183      */
184     function editList(
185         LinkedList storage _self,
186         uint256 _addedValue
187     )
188         internal
189     {
190         // Add node if data hasn't reached size limit, otherwise update next node
191         _self.dataArray.length < _self.dataSizeLimit ? addNode(_self, _addedValue)
192             : updateNode(_self, _addedValue);
193     }
194 
195     /*
196      * Add new value to list by either creating new node. Node limit must not be reached.
197      *
198      * @param  _self                        LinkedList to operate on
199      * @param  _addedValue                  Value to add to list
200      */
201     function addNode(
202         LinkedList storage _self,
203         uint256 _addedValue
204     )
205         internal
206     {
207         uint256 newNodeIndex = _self.lastUpdatedIndex.add(1);
208 
209         require(
210             newNodeIndex == _self.dataArray.length,
211             "LinkedListLibrary: Node must be added at next expected index in list"
212         );
213 
214         require(
215             newNodeIndex < _self.dataSizeLimit,
216             "LinkedListLibrary: Attempting to add node that exceeds data size limit"
217         );
218 
219         // Add node value
220         _self.dataArray.push(_addedValue);
221 
222         // Update lastUpdatedIndex value
223         _self.lastUpdatedIndex = newNodeIndex;
224     }
225 
226     /*
227      * Add new value to list by updating existing node. Updates only happen if node limit has been
228      * reached.
229      *
230      * @param  _self                        LinkedList to operate on
231      * @param  _addedValue                  Value to add to list
232      */
233     function updateNode(
234         LinkedList storage _self,
235         uint256 _addedValue
236     )
237         internal
238     {
239         // Determine the next node in list to be updated
240         uint256 updateNodeIndex = _self.lastUpdatedIndex.add(1) % _self.dataSizeLimit;
241 
242         // Require that updated node has been previously added
243         require(
244             updateNodeIndex < _self.dataArray.length,
245             "LinkedListLibrary: Attempting to update non-existent node"
246         );
247 
248         // Update node value and last updated index
249         _self.dataArray[updateNodeIndex] = _addedValue;
250         _self.lastUpdatedIndex = updateNodeIndex;
251     }
252 
253     /*
254      * Read list from the lastUpdatedIndex back the passed amount of data points.
255      *
256      * @param  _self                        LinkedList to operate on
257      * @param  _dataPoints                  Number of data points to return
258      */
259     function readList(
260         LinkedList storage _self,
261         uint256 _dataPoints
262     )
263         internal
264         view
265         returns (uint256[] memory)
266     {
267         LinkedList memory linkedListMemory = _self;
268 
269         return readListMemory(
270             linkedListMemory,
271             _dataPoints
272         );
273     }
274 
275     function readListMemory(
276         LinkedList memory _self,
277         uint256 _dataPoints
278     )
279         internal
280         view
281         returns (uint256[] memory)
282     {
283         // Make sure query isn't for more data than collected
284         require(
285             _dataPoints <= _self.dataArray.length,
286             "LinkedListLibrary: Querying more data than available"
287         );
288 
289         // Instantiate output array in memory
290         uint256[] memory outputArray = new uint256[](_dataPoints);
291 
292         // Find head of list
293         uint256 linkedListIndex = _self.lastUpdatedIndex;
294         for (uint256 i = 0; i < _dataPoints; i++) {
295             // Get value at index in linkedList
296             outputArray[i] = _self.dataArray[linkedListIndex];
297 
298             // Find next linked index
299             linkedListIndex = linkedListIndex == 0 ? _self.dataSizeLimit.sub(1) : linkedListIndex.sub(1);
300         }
301 
302         return outputArray;
303     }
304 
305 }
306 
307 // File: contracts/meta-oracles/lib/TimeSeriesStateLibrary.sol
308 
309 /*
310     Copyright 2019 Set Labs Inc.
311 
312     Licensed under the Apache License, Version 2.0 (the "License");
313     you may not use this file except in compliance with the License.
314     You may obtain a copy of the License at
315 
316     http://www.apache.org/licenses/LICENSE-2.0
317 
318     Unless required by applicable law or agreed to in writing, software
319     distributed under the License is distributed on an "AS IS" BASIS,
320     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
321     See the License for the specific language governing permissions and
322     limitations under the License.
323 */
324 
325 pragma solidity 0.5.7;
326 
327 
328 
329 /**
330  * @title TimeSeriesStateLibrary
331  * @author Set Protocol
332  *
333  * Library defining TimeSeries state struct
334  */
335 library TimeSeriesStateLibrary {
336     struct State {
337         uint256 nextEarliestUpdate;
338         uint256 updateInterval;
339         LinkedListLibraryV2.LinkedList timeSeriesData;
340     }
341 }
342 
343 // File: contracts/meta-oracles/interfaces/IDataSource.sol
344 
345 /*
346     Copyright 2019 Set Labs Inc.
347 
348     Licensed under the Apache License, Version 2.0 (the "License");
349     you may not use this file except in compliance with the License.
350     You may obtain a copy of the License at
351 
352     http://www.apache.org/licenses/LICENSE-2.0
353 
354     Unless required by applicable law or agreed to in writing, software
355     distributed under the License is distributed on an "AS IS" BASIS,
356     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
357     See the License for the specific language governing permissions and
358     limitations under the License.
359 */
360 
361 pragma solidity 0.5.7;
362 
363 
364 /**
365  * @title IDataSource
366  * @author Set Protocol
367  *
368  * Interface for interacting with DataSource contracts
369  */
370 interface IDataSource {
371 
372     function read(
373         TimeSeriesStateLibrary.State calldata _timeSeriesState
374     )
375         external
376         view
377         returns (uint256);
378 
379 }
380 
381 // File: contracts/meta-oracles/TimeSeriesFeed.sol
382 
383 /*
384     Copyright 2019 Set Labs Inc.
385 
386     Licensed under the Apache License, Version 2.0 (the "License");
387     you may not use this file except in compliance with the License.
388     You may obtain a copy of the License at
389 
390     http://www.apache.org/licenses/LICENSE-2.0
391 
392     Unless required by applicable law or agreed to in writing, software
393     distributed under the License is distributed on an "AS IS" BASIS,
394     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
395     See the License for the specific language governing permissions and
396     limitations under the License.
397 */
398 
399 pragma solidity 0.5.7;
400 
401 
402 
403 
404 
405 
406 
407 /**
408  * @title TimeSeriesFeed
409  * @author Set Protocol
410  *
411  * Contract used to store time-series data from a specified DataSource. Intended time-series data
412  * is stored in a circular Linked List data structure with a maximum number of data points. Its
413  * enforces a minimum duration between each update. New data is appended by calling the poke function,
414  * which reads data from a specified data source.
415  */
416 contract TimeSeriesFeed is
417     ReentrancyGuard
418 {
419     using SafeMath for uint256;
420     using LinkedListLibraryV2 for LinkedListLibraryV2.LinkedList;
421 
422     /* ============ State Variables ============ */
423     uint256 public updateInterval;
424     uint256 public maxDataPoints;
425     // Unix Timestamp in seconds of next earliest update time
426     uint256 public nextEarliestUpdate;
427     string public dataDescription;
428     IDataSource public dataSourceInstance;
429 
430     LinkedListLibraryV2.LinkedList private timeSeriesData;
431 
432     /* ============ Constructor ============ */
433 
434     /*
435      * Stores time-series values in a LinkedList and updated using data from a specific data source.
436      * Updates must be triggered off chain to be stored in this smart contract.
437      *
438      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
439                                           off deployment timestamp. A certain data point can't be logged before
440                                           it's expected timestamp but can be logged after.
441      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold
442      * @param  _dataSourceAddress         The address to read current data from
443      * @param  _dataDescription           Description of time-series data for Etherscan / other applications
444      * @param  _seededValues              Array of previous timeseries values to seed
445      *                                    initial values in list. The last value should contain
446      *                                    the most current piece of data
447      */
448     constructor(
449         uint256 _updateInterval,
450         uint256 _maxDataPoints,
451         IDataSource _dataSourceAddress,
452         string memory _dataDescription,
453         uint256[] memory _seededValues
454     )
455         public
456     {
457         // Set updateInterval, maxDataPoints, data description, dataSourceInstance
458         updateInterval = _updateInterval;
459         maxDataPoints = _maxDataPoints;
460         dataDescription = _dataDescription;
461         dataSourceInstance = _dataSourceAddress;
462 
463         require(
464             _seededValues.length > 0,
465             "TimeSeriesFeed.constructor: Must include at least one seeded value."
466         );
467 
468         // Define upper data size limit for linked list and input initial value
469         timeSeriesData.initialize(_maxDataPoints, _seededValues[0]);
470 
471         // Cycle through input values array (skipping first value used to initialize LinkedList)
472         // and add to timeSeriesData
473         for (uint256 i = 1; i < _seededValues.length; i++) {
474             timeSeriesData.editList(_seededValues[i]);
475         }
476 
477         // Set nextEarliestUpdate
478         nextEarliestUpdate = block.timestamp.add(updateInterval);
479     }
480 
481     /* ============ External ============ */
482 
483     /*
484      * Updates linked list with newest data point by querying the dataSource.
485      */
486     function poke()
487         external
488         nonReentrant
489     {
490         // Make sure block timestamp exceeds nextEarliestUpdate
491         require(
492             block.timestamp >= nextEarliestUpdate,
493             "TimeSeriesFeed.poke: Not enough time elapsed since last update"
494         );
495 
496         TimeSeriesStateLibrary.State memory timeSeriesState = getTimeSeriesFeedState();
497 
498         // Get the most current data point
499         uint256 newValue = dataSourceInstance.read(timeSeriesState);
500 
501         // Update the nextEarliestUpdate to previous nextEarliestUpdate plus updateInterval
502         nextEarliestUpdate = nextEarliestUpdate.add(updateInterval);
503 
504         // Update linkedList with new price
505         timeSeriesData.editList(newValue);
506     }
507 
508     /*
509      * Query linked list for specified days of data. Will revert if number of days
510      * passed exceeds amount of days collected. Will revert if not enough days of
511      * data logged.
512      *
513      * @param  _numDataPoints  Number of datapoints to query
514      * @returns                Array of datapoints of length _numDataPoints from most recent to oldest
515      */
516     function read(
517         uint256 _numDataPoints
518     )
519         external
520         view
521         returns (uint256[] memory)
522     {
523         return timeSeriesData.readList(_numDataPoints);
524     }
525 
526     /* ============ Public ============ */
527 
528     /*
529      * Generate struct that holds TimeSeriesFeed's current nextAvailableUpdate, updateInterval,
530      * and the LinkedList struct
531      *
532      * @returns                Struct containing the above params
533      */
534     function getTimeSeriesFeedState()
535         public
536         view
537         returns (TimeSeriesStateLibrary.State memory)
538     {
539         return TimeSeriesStateLibrary.State({
540             nextEarliestUpdate: nextEarliestUpdate,
541             updateInterval: updateInterval,
542             timeSeriesData: timeSeriesData
543         });
544     }
545 }