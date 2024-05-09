1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
78 
79 pragma solidity ^0.5.2;
80 
81 /**
82  * @title SafeMath
83  * @dev Unsigned math operations with safety checks that revert on error
84  */
85 library SafeMath {
86     /**
87      * @dev Multiplies two unsigned integers, reverts on overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b);
99 
100         return c;
101     }
102 
103     /**
104      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Solidity only automatically asserts when dividing by 0
108         require(b > 0);
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Adds two unsigned integers, reverts on overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a);
131 
132         return c;
133     }
134 
135     /**
136      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
137      * reverts when dividing by zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b != 0);
141         return a % b;
142     }
143 }
144 
145 // File: contracts/external/DappHub/interfaces/IMedian.sol
146 
147 /*
148     Copyright 2019 Set Labs Inc.
149 
150     Licensed under the Apache License, Version 2.0 (the "License");
151     you may not use this file except in compliance with the License.
152     You may obtain a copy of the License at
153 
154     http://www.apache.org/licenses/LICENSE-2.0
155 
156     Unless required by applicable law or agreed to in writing, software
157     distributed under the License is distributed on an "AS IS" BASIS,
158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
159     See the License for the specific language governing permissions and
160     limitations under the License.
161 */
162 
163 pragma solidity 0.5.7;
164 
165 
166 /**
167  * @title IMedian
168  * @author Set Protocol
169  *
170  * Interface for operating with a price feed Medianizer contract
171  */
172 interface IMedian {
173 
174     /**
175      * Returns the current price set on the medianizer. Throws if the price is set to 0 (initialization)
176      *
177      * @return  Current price of asset represented in hex as bytes32
178      */
179     function read()
180         external
181         view
182         returns (bytes32);
183 
184     /**
185      * Returns the current price set on the medianizer and whether the value has been initialized
186      *
187      * @return  Current price of asset represented in hex as bytes32, and whether value is non-zero
188      */
189     function peek()
190         external
191         view
192         returns (bytes32, bool);
193 }
194 
195 // File: contracts/meta-oracles/lib/LinkedListLibrary.sol
196 
197 /*
198     Copyright 2019 Set Labs Inc.
199 
200     Licensed under the Apache License, Version 2.0 (the "License");
201     you may not use this file except in compliance with the License.
202     You may obtain a copy of the License at
203 
204     http://www.apache.org/licenses/LICENSE-2.0
205 
206     Unless required by applicable law or agreed to in writing, software
207     distributed under the License is distributed on an "AS IS" BASIS,
208     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
209     See the License for the specific language governing permissions and
210     limitations under the License.
211 */
212 
213 pragma solidity 0.5.7;
214 pragma experimental "ABIEncoderV2";
215 
216 
217 
218 /**
219  * @title LinkedListLibrary
220  * @author Set Protocol
221  *
222  * Library for creating and altering uni-directional circularly linked lists, optimized for sequential updating
223  */
224 contract LinkedListLibrary {
225 
226     using SafeMath for uint256;
227 
228     /* ============ Structs ============ */
229 
230     struct LinkedList{
231         uint256 dataSizeLimit;
232         uint256 lastUpdatedIndex;
233         uint256[] dataArray;
234     }
235 
236     /*
237      * Initialize LinkedList by setting limit on amount of nodes and inital value of node 0
238      *
239      * @param  _self                        LinkedList to operate on
240      * @param  _dataSizeLimit               Max amount of nodes allowed in LinkedList
241      * @param  _initialValue                Initial value of node 0 in LinkedList
242      */
243     function initialize(
244         LinkedList storage _self,
245         uint256 _dataSizeLimit,
246         uint256 _initialValue
247     )
248         internal
249     {
250         require(
251             _self.dataArray.length == 0,
252             "LinkedListLibrary: Initialized LinkedList must be empty"
253         );
254 
255         // Initialize Linked list by defining upper limit of data points in the list and setting
256         // initial value
257         _self.dataSizeLimit = _dataSizeLimit;
258         _self.dataArray.push(_initialValue);
259         _self.lastUpdatedIndex = 0;
260     }
261 
262     /*
263      * Add new value to list by either creating new node if node limit not reached or updating
264      * existing node value
265      *
266      * @param  _self                        LinkedList to operate on
267      * @param  _addedValue                  Value to add to list
268      */
269     function editList(
270         LinkedList storage _self,
271         uint256 _addedValue
272     )
273         internal
274     {
275         // Add node if data hasn't reached size limit, otherwise update next node
276         _self.dataArray.length < _self.dataSizeLimit ? addNode(_self, _addedValue)
277             : updateNode(_self, _addedValue);
278 
279     }
280 
281     /*
282      * Add new value to list by either creating new node. Node limit must not be reached.
283      *
284      * @param  _self                        LinkedList to operate on
285      * @param  _addedValue                  Value to add to list
286      */
287     function addNode(
288         LinkedList storage _self,
289         uint256 _addedValue
290     )
291         internal
292     {
293         uint256 newNodeIndex = _self.lastUpdatedIndex.add(1);
294 
295         require(
296             newNodeIndex == _self.dataArray.length,
297             "LinkedListLibrary: Node must be added at next expected index in list"
298         );
299 
300         require(
301             newNodeIndex < _self.dataSizeLimit,
302             "LinkedListLibrary: Attempting to add node that exceeds data size limit"
303         );
304 
305         // Add node value
306         _self.dataArray.push(_addedValue);
307 
308         // Update lastUpdatedIndex value
309         _self.lastUpdatedIndex = newNodeIndex;
310     }
311 
312     /*
313      * Add new value to list by updating existing node. Updates only happen if node limit has been
314      * reached.
315      *
316      * @param  _self                        LinkedList to operate on
317      * @param  _addedValue                  Value to add to list
318      */
319     function updateNode(
320         LinkedList storage _self,
321         uint256 _addedValue
322     )
323         internal
324     {
325         // Determine the next node in list to be updated
326         uint256 updateNodeIndex = _self.lastUpdatedIndex.add(1) % _self.dataSizeLimit;
327 
328         // Require that updated node has been previously added
329         require(
330             updateNodeIndex < _self.dataArray.length,
331             "LinkedListLibrary: Attempting to update non-existent node"
332         );
333 
334         // Update node value and last updated index
335         _self.dataArray[updateNodeIndex] = _addedValue;
336         _self.lastUpdatedIndex = updateNodeIndex;
337     }
338 
339     /*
340      * Read list from the lastUpdatedIndex back the passed amount of data points.
341      *
342      * @param  _self                        LinkedList to operate on
343      * @param  _dataPoints                  Number of data points to return
344      */
345     function readList(
346         LinkedList storage _self,
347         uint256 _dataPoints
348     )
349         internal
350         view
351         returns (uint256[] memory)
352     {
353         // Make sure query isn't for more data than collected
354         require(
355             _dataPoints <= _self.dataArray.length,
356             "LinkedListLibrary: Querying more data than available"
357         );
358 
359         // Instantiate output array in memory
360         uint256[] memory outputArray = new uint256[](_dataPoints);
361 
362         // Find head of list
363         uint256 linkedListIndex = _self.lastUpdatedIndex;
364         for (uint256 i = 0; i < _dataPoints; i++) {
365             // Get value at index in linkedList
366             outputArray[i] = _self.dataArray[linkedListIndex];
367 
368             // Find next linked index
369             linkedListIndex = linkedListIndex == 0 ? _self.dataSizeLimit.sub(1) : linkedListIndex.sub(1);
370         }
371 
372         return outputArray;
373     }
374 }
375 
376 // File: contracts/meta-oracles/HistoricalPriceFeed.sol
377 
378 /*
379     Copyright 2019 Set Labs Inc.
380 
381     Licensed under the Apache License, Version 2.0 (the "License");
382     you may not use this file except in compliance with the License.
383     You may obtain a copy of the License at
384 
385     http://www.apache.org/licenses/LICENSE-2.0
386 
387     Unless required by applicable law or agreed to in writing, software
388     distributed under the License is distributed on an "AS IS" BASIS,
389     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
390     See the License for the specific language governing permissions and
391     limitations under the License.
392 */
393 
394 pragma solidity 0.5.7;
395 
396 
397 
398 
399 
400 
401 /**
402  * @title HistoricalPriceFeed
403  * @author Set Protocol
404  *
405  * Contract used to store Historical price data from an off-chain oracle
406  */
407 contract HistoricalPriceFeed is
408     Ownable,
409     LinkedListLibrary
410 {
411     using SafeMath for uint256;
412 
413     /* ============ Constants ============ */
414     uint256 constant DAYS_IN_DATASET = 200;
415 
416     /* ============ State Variables ============ */
417     uint256 public updateFrequency;
418     uint256 public lastUpdatedAt;
419     string public dataDescription;
420     IMedian public medianizerInstance;
421 
422     LinkedList public historicalPriceData;
423 
424     /* ============ Constructor ============ */
425 
426     /*
427      * Historical Price Feed constructor.
428      * Stores Historical prices according to passed in oracle address. Updates must be
429      * triggered off chain to be stored in this smart contract.
430      *
431      * @param  _updateFrequency           How often new data can be logged, passe=d in seconds
432      * @param  _medianizerAddress         The oracle address to read historical data from
433      * @param  _dataDescription           Description of data in Data Bank
434      * @param  _seededValues              Array of previous days' Historical price values to seed
435      *                                    initial values in list. Should NOT contain the current
436      *                                    days price.
437      */
438     constructor(
439         uint256 _updateFrequency,
440         address _medianizerAddress,
441         string memory _dataDescription,
442         uint256[] memory _seededValues
443     )
444         public
445     {
446         // Set medianizer address, data description, and instantiate medianizer
447         updateFrequency = _updateFrequency;
448         dataDescription = _dataDescription;
449         medianizerInstance = IMedian(_medianizerAddress);
450 
451         // Create initial values array from _seededValues and current price
452         uint256[] memory initialValues = createInitialValues(_seededValues);
453 
454         // Define upper data size limit for linked list and input initial value
455         initialize(
456             historicalPriceData,
457             DAYS_IN_DATASET,
458             initialValues[0]
459         );
460 
461         // Cycle through input values array (skipping first value used to initialize LinkedList)
462         // and add to historicalPriceData
463         for (uint256 i = 1; i < initialValues.length; i++) {
464             editList(
465                 historicalPriceData,
466                 initialValues[i]
467             );
468         }
469 
470         // Set last updated timestamp
471         lastUpdatedAt = block.timestamp;
472     }
473 
474     /* ============ External ============ */
475 
476     /*
477      * Updates linked list with newest data point by querying medianizer. Is eligible to be
478      * called every 24 hours.
479      */
480     function poke()
481         external
482     {
483         // Make sure 24 hours have passed since last update
484         require(
485             block.timestamp >= lastUpdatedAt.add(updateFrequency),
486             "HistoricalPriceFeed: Not enough time passed between updates"
487         );
488 
489         // Update the timestamp to current block timestamp; Prevents re-entrancy
490         lastUpdatedAt = block.timestamp;
491 
492         // Get current price
493         uint256 newValue = uint256(medianizerInstance.read());
494 
495         // Update linkedList with new price
496         editList(
497             historicalPriceData,
498             newValue
499         );
500     }
501 
502     /*
503      * Query linked list for specified days of data. Will revert if number of days
504      * passed exceeds amount of days collected. Will revert if not enough days of
505      * data logged.
506      *
507      * @param  _dataDays       Number of days of data being queried
508      * @returns                Array of historical price data of length _dataDays
509      */
510     function read(
511         uint256 _dataDays
512     )
513         external
514         view
515         returns (uint256[] memory)
516     {
517         return readList(
518             historicalPriceData,
519             _dataDays
520         );
521     }
522 
523     /*
524      * Change medianizer in case current one fails or is deprecated. Only contract
525      * owner is allowed to change.
526      *
527      * @param  _newMedianizerAddress       Address of new medianizer to pull data from
528      */
529     function changeMedianizer(
530         address _newMedianizerAddress
531     )
532         external
533         onlyOwner
534     {
535         medianizerInstance = IMedian(_newMedianizerAddress);
536     }
537 
538 
539     /* ============ Private ============ */
540 
541     /*
542      * Create initialValues array from _seededValues and the current medianizer price.
543      * Added to historicalPriceData in constructor.
544      *
545      * @param  _seededValues        Array of previous days' historical price values to seed
546      * @returns                     Array of initial values to add to historicalPriceData
547      */
548     function createInitialValues(
549         uint256[] memory _seededValues
550     )
551         private
552         returns (uint256[] memory)
553     {
554         // Get current value from medianizer
555         uint256 currentValue = uint256(medianizerInstance.read());
556 
557         // Instantiate outputArray
558         uint256 seededValuesLength = _seededValues.length;
559         uint256[] memory outputArray = new uint256[](seededValuesLength.add(1));
560 
561         // Take values from _seededValues array and add to outputArray
562         for (uint256 i = 0; i < _seededValues.length; i++) {
563             outputArray[i] = _seededValues[i];
564         }
565 
566         // Add currentValue to outputArray
567         outputArray[seededValuesLength] = currentValue;
568 
569         return outputArray;
570     }
571 }