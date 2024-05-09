1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 /**
69  * @title Pausable
70  * @dev Base contract which allows children to implement an emergency stop mechanism.
71  */
72 contract Pausable is Ownable {
73     event Pause();
74     event Unpause();
75 
76     bool public paused = false;
77 
78 
79     /**
80      * @dev Modifier to make a function callable only when the contract is not paused.
81      */
82     modifier whenNotPaused() {
83         require(!paused);
84         _;
85     }
86 
87     /**
88      * @dev Modifier to make a function callable only when the contract is paused.
89      */
90     modifier whenPaused() {
91         require(paused);
92         _;
93     }
94 
95     /**
96      * @dev called by the owner to pause, triggers stopped state
97      */
98     function pause() onlyOwner whenNotPaused public {
99         paused = true;
100         Pause();
101     }
102 
103     /**
104      * @dev called by the owner to unpause, returns to normal state
105      */
106     function unpause() onlyOwner whenPaused public {
107         paused = false;
108         Unpause();
109     }
110 }
111 
112 /**
113  * @title Math
114  * @dev Assorted math operations
115  */
116 library Math {
117     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
118         return a >= b ? a : b;
119     }
120 
121     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
122         return a < b ? a : b;
123     }
124 
125     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a >= b ? a : b;
127     }
128 
129     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a < b ? a : b;
131     }
132 }
133 
134 /**
135  * @title SafeMath
136  * @dev Math operations with safety checks that throw on error
137  */
138 library SafeMath {
139   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140     if (a == 0) {
141       return 0;
142     }
143     uint256 c = a * b;
144     assert(c / a == b);
145     return c;
146   }
147 
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   function add(uint256 a, uint256 b) internal pure returns (uint256) {
161     uint256 c = a + b;
162     assert(c >= a);
163     return c;
164   }
165 }
166 
167 library MathUtils {
168     using SafeMath for uint256;
169 
170     // Divisor used for representing percentages
171     uint256 public constant PERC_DIVISOR = 1000000;
172 
173     /*
174      * @dev Returns whether an amount is a valid percentage out of PERC_DIVISOR
175      * @param _amount Amount that is supposed to be a percentage
176      */
177     function validPerc(uint256 _amount) internal pure returns (bool) {
178         return _amount <= PERC_DIVISOR;
179     }
180 
181     /*
182      * @dev Compute percentage of a value with the percentage represented by a fraction
183      * @param _amount Amount to take the percentage of
184      * @param _fracNum Numerator of fraction representing the percentage
185      * @param _fracDenom Denominator of fraction representing the percentage
186      */
187     function percOf(uint256 _amount, uint256 _fracNum, uint256 _fracDenom) internal pure returns (uint256) {
188         return _amount.mul(percPoints(_fracNum, _fracDenom)).div(PERC_DIVISOR);
189     }
190 
191     /*
192      * @dev Compute percentage of a value with the percentage represented by a fraction over PERC_DIVISOR
193      * @param _amount Amount to take the percentage of
194      * @param _fracNum Numerator of fraction representing the percentage with PERC_DIVISOR as the denominator
195      */
196     function percOf(uint256 _amount, uint256 _fracNum) internal pure returns (uint256) {
197         return _amount.mul(_fracNum).div(PERC_DIVISOR);
198     }
199 
200     /*
201      * @dev Compute percentage representation of a fraction
202      * @param _fracNum Numerator of fraction represeting the percentage
203      * @param _fracDenom Denominator of fraction represeting the percentage
204      */
205     function percPoints(uint256 _fracNum, uint256 _fracDenom) internal pure returns (uint256) {
206         return _fracNum.mul(PERC_DIVISOR).div(_fracDenom);
207     }
208 }
209 
210 contract IController is Pausable {
211     event SetContractInfo(bytes32 id, address contractAddress, bytes20 gitCommitHash);
212 
213     function setContractInfo(bytes32 _id, address _contractAddress, bytes20 _gitCommitHash) external;
214     function updateController(bytes32 _id, address _controller) external;
215     function getContract(bytes32 _id) public view returns (address);
216 }
217 
218 contract IManager {
219     event SetController(address controller);
220     event ParameterUpdate(string param);
221 
222     function setController(address _controller) external;
223 }
224 
225 contract Manager is IManager {
226     // Controller that contract is registered with
227     IController public controller;
228 
229     // Check if sender is controller
230     modifier onlyController() {
231         require(msg.sender == address(controller));
232         _;
233     }
234 
235     // Check if sender is controller owner
236     modifier onlyControllerOwner() {
237         require(msg.sender == controller.owner());
238         _;
239     }
240 
241     // Check if controller is not paused
242     modifier whenSystemNotPaused() {
243         require(!controller.paused());
244         _;
245     }
246 
247     // Check if controller is paused
248     modifier whenSystemPaused() {
249         require(controller.paused());
250         _;
251     }
252 
253     function Manager(address _controller) public {
254         controller = IController(_controller);
255     }
256 
257     /*
258      * @dev Set controller. Only callable by current controller
259      * @param _controller Controller contract address
260      */
261     function setController(address _controller) external onlyController {
262         controller = IController(_controller);
263 
264         SetController(_controller);
265     }
266 }
267 
268 /**
269  * @title ManagerProxyTarget
270  * @dev The base contract that target contracts used by a proxy contract should inherit from
271  * Note: Both the target contract and the proxy contract (implemented as ManagerProxy) MUST inherit from ManagerProxyTarget in order to guarantee
272  * that both contracts have the same storage layout. Differing storage layouts in a proxy contract and target contract can
273  * potentially break the delegate proxy upgradeability mechanism
274  */
275 contract ManagerProxyTarget is Manager {
276     // Used to look up target contract address in controller's registry
277     bytes32 public targetContractId;
278 }
279 
280 /*
281  * @title A sorted doubly linked list with nodes sorted in descending order. Optionally accepts insert position hints
282  *
283  * Given a new node with a `key`, a hint is of the form `(prevId, nextId)` s.t. `prevId` and `nextId` are adjacent in the list.
284  * `prevId` is a node with a key >= `key` and `nextId` is a node with a key <= `key`. If the sender provides a hint that is a valid insert position
285  * the insert operation is a constant time storage write. However, the provided hint in a given transaction might be a valid insert position, but if other transactions are included first, when
286  * the given transaction is executed the provided hint may no longer be a valid insert position. For example, one of the nodes referenced might be removed or their keys may
287  * be updated such that the the pair of nodes in the hint no longer represent a valid insert position. If one of the nodes in the hint becomes invalid, we still try to use the other
288  * valid node as a starting point for finding the appropriate insert position. If both nodes in the hint become invalid, we use the head of the list as a starting point
289  * to find the appropriate insert position.
290  */
291 library SortedDoublyLL {
292     using SafeMath for uint256;
293 
294     // Information for a node in the list
295     struct Node {
296         uint256 key;                     // Node's key used for sorting
297         address nextId;                  // Id of next node (smaller key) in the list
298         address prevId;                  // Id of previous node (larger key) in the list
299     }
300 
301     // Information for the list
302     struct Data {
303         address head;                        // Head of the list. Also the node in the list with the largest key
304         address tail;                        // Tail of the list. Also the node in the list with the smallest key
305         uint256 maxSize;                     // Maximum size of the list
306         uint256 size;                        // Current size of the list
307         mapping (address => Node) nodes;     // Track the corresponding ids for each node in the list
308     }
309 
310     /*
311      * @dev Set the maximum size of the list
312      * @param _size Maximum size
313      */
314     function setMaxSize(Data storage self, uint256 _size) public {
315         // New max size must be greater than old max size
316         require(_size > self.maxSize);
317 
318         self.maxSize = _size;
319     }
320 
321     /*
322      * @dev Add a node to the list
323      * @param _id Node's id
324      * @param _key Node's key
325      * @param _prevId Id of previous node for the insert position
326      * @param _nextId Id of next node for the insert position
327      */
328     function insert(Data storage self, address _id, uint256 _key, address _prevId, address _nextId) public {
329         // List must not be full
330         require(!isFull(self));
331         // List must not already contain node
332         require(!contains(self, _id));
333         // Node id must not be null
334         require(_id != address(0));
335         // Key must be non-zero
336         require(_key > 0);
337 
338         address prevId = _prevId;
339         address nextId = _nextId;
340 
341         if (!validInsertPosition(self, _key, prevId, nextId)) {
342             // Sender's hint was not a valid insert position
343             // Use sender's hint to find a valid insert position
344             (prevId, nextId) = findInsertPosition(self, _key, prevId, nextId);
345         }
346 
347         self.nodes[_id].key = _key;
348 
349         if (prevId == address(0) && nextId == address(0)) {
350             // Insert as head and tail
351             self.head = _id;
352             self.tail = _id;
353         } else if (prevId == address(0)) {
354             // Insert before `prevId` as the head
355             self.nodes[_id].nextId = self.head;
356             self.nodes[self.head].prevId = _id;
357             self.head = _id;
358         } else if (nextId == address(0)) {
359             // Insert after `nextId` as the tail
360             self.nodes[_id].prevId = self.tail;
361             self.nodes[self.tail].nextId = _id;
362             self.tail = _id;
363         } else {
364             // Insert at insert position between `prevId` and `nextId`
365             self.nodes[_id].nextId = nextId;
366             self.nodes[_id].prevId = prevId;
367             self.nodes[prevId].nextId = _id;
368             self.nodes[nextId].prevId = _id;
369         }
370 
371         self.size = self.size.add(1);
372     }
373 
374     /*
375      * @dev Remove a node from the list
376      * @param _id Node's id
377      */
378     function remove(Data storage self, address _id) public {
379         // List must contain the node
380         require(contains(self, _id));
381 
382         if (self.size > 1) {
383             // List contains more than a single node
384             if (_id == self.head) {
385                 // The removed node is the head
386                 // Set head to next node
387                 self.head = self.nodes[_id].nextId;
388                 // Set prev pointer of new head to null
389                 self.nodes[self.head].prevId = address(0);
390             } else if (_id == self.tail) {
391                 // The removed node is the tail
392                 // Set tail to previous node
393                 self.tail = self.nodes[_id].prevId;
394                 // Set next pointer of new tail to null
395                 self.nodes[self.tail].nextId = address(0);
396             } else {
397                 // The removed node is neither the head nor the tail
398                 // Set next pointer of previous node to the next node
399                 self.nodes[self.nodes[_id].prevId].nextId = self.nodes[_id].nextId;
400                 // Set prev pointer of next node to the previous node
401                 self.nodes[self.nodes[_id].nextId].prevId = self.nodes[_id].prevId;
402             }
403         } else {
404             // List contains a single node
405             // Set the head and tail to null
406             self.head = address(0);
407             self.tail = address(0);
408         }
409 
410         delete self.nodes[_id];
411         self.size = self.size.sub(1);
412     }
413 
414     /*
415      * @dev Update the key of a node in the list
416      * @param _id Node's id
417      * @param _newKey Node's new key
418      * @param _prevId Id of previous node for the new insert position
419      * @param _nextId Id of next node for the new insert position
420      */
421     function updateKey(Data storage self, address _id, uint256 _newKey, address _prevId, address _nextId) public {
422         // List must contain the node
423         require(contains(self, _id));
424 
425         // Remove node from the list
426         remove(self, _id);
427 
428         if (_newKey > 0) {
429             // Insert node if it has a non-zero key
430             insert(self, _id, _newKey, _prevId, _nextId);
431         }
432     }
433 
434     /*
435      * @dev Checks if the list contains a node
436      * @param _transcoder Address of transcoder
437      */
438     function contains(Data storage self, address _id) public view returns (bool) {
439         // List only contains non-zero keys, so if key is non-zero the node exists
440         return self.nodes[_id].key > 0;
441     }
442 
443     /*
444      * @dev Checks if the list is full
445      */
446     function isFull(Data storage self) public view returns (bool) {
447         return self.size == self.maxSize;
448     }
449 
450     /*
451      * @dev Checks if the list is empty
452      */
453     function isEmpty(Data storage self) public view returns (bool) {
454         return self.size == 0;
455     }
456 
457     /*
458      * @dev Returns the current size of the list
459      */
460     function getSize(Data storage self) public view returns (uint256) {
461         return self.size;
462     }
463 
464     /*
465      * @dev Returns the maximum size of the list
466      */
467     function getMaxSize(Data storage self) public view returns (uint256) {
468         return self.maxSize;
469     }
470 
471     /*
472      * @dev Returns the key of a node in the list
473      * @param _id Node's id
474      */
475     function getKey(Data storage self, address _id) public view returns (uint256) {
476         return self.nodes[_id].key;
477     }
478 
479     /*
480      * @dev Returns the first node in the list (node with the largest key)
481      */
482     function getFirst(Data storage self) public view returns (address) {
483         return self.head;
484     }
485 
486     /*
487      * @dev Returns the last node in the list (node with the smallest key)
488      */
489     function getLast(Data storage self) public view returns (address) {
490         return self.tail;
491     }
492 
493     /*
494      * @dev Returns the next node (with a smaller key) in the list for a given node
495      * @param _id Node's id
496      */
497     function getNext(Data storage self, address _id) public view returns (address) {
498         return self.nodes[_id].nextId;
499     }
500 
501     /*
502      * @dev Returns the previous node (with a larger key) in the list for a given node
503      * @param _id Node's id
504      */
505     function getPrev(Data storage self, address _id) public view returns (address) {
506         return self.nodes[_id].prevId;
507     }
508 
509     /*
510      * @dev Check if a pair of nodes is a valid insertion point for a new node with the given key
511      * @param _key Node's key
512      * @param _prevId Id of previous node for the insert position
513      * @param _nextId Id of next node for the insert position
514      */
515     function validInsertPosition(Data storage self, uint256 _key, address _prevId, address _nextId) public view returns (bool) {
516         if (_prevId == address(0) && _nextId == address(0)) {
517             // `(null, null)` is a valid insert position if the list is empty
518             return isEmpty(self);
519         } else if (_prevId == address(0)) {
520             // `(null, _nextId)` is a valid insert position if `_nextId` is the head of the list
521             return self.head == _nextId && _key >= self.nodes[_nextId].key;
522         } else if (_nextId == address(0)) {
523             // `(_prevId, null)` is a valid insert position if `_prevId` is the tail of the list
524             return self.tail == _prevId && _key <= self.nodes[_prevId].key;
525         } else {
526             // `(_prevId, _nextId)` is a valid insert position if they are adjacent nodes and `_key` falls between the two nodes' keys
527             return self.nodes[_prevId].nextId == _nextId && self.nodes[_prevId].key >= _key && _key >= self.nodes[_nextId].key;
528         }
529     }
530 
531     /*
532      * @dev Descend the list (larger keys to smaller keys) to find a valid insert position
533      * @param _key Node's key
534      * @param _startId Id of node to start ascending the list from
535      */
536     function descendList(Data storage self, uint256 _key, address _startId) private view returns (address, address) {
537         // If `_startId` is the head, check if the insert position is before the head
538         if (self.head == _startId && _key >= self.nodes[_startId].key) {
539             return (address(0), _startId);
540         }
541 
542         address prevId = _startId;
543         address nextId = self.nodes[prevId].nextId;
544 
545         // Descend the list until we reach the end or until we find a valid insert position
546         while (prevId != address(0) && !validInsertPosition(self, _key, prevId, nextId)) {
547             prevId = self.nodes[prevId].nextId;
548             nextId = self.nodes[prevId].nextId;
549         }
550 
551         return (prevId, nextId);
552     }
553 
554     /*
555      * @dev Ascend the list (smaller keys to larger keys) to find a valid insert position
556      * @param _key Node's key
557      * @param _startId Id of node to start descending the list from
558      */
559     function ascendList(Data storage self, uint256 _key, address _startId) private view returns (address, address) {
560         // If `_startId` is the tail, check if the insert position is after the tail
561         if (self.tail == _startId && _key <= self.nodes[_startId].key) {
562             return (_startId, address(0));
563         }
564 
565         address nextId = _startId;
566         address prevId = self.nodes[nextId].prevId;
567 
568         // Ascend the list until we reach the end or until we find a valid insertion point
569         while (nextId != address(0) && !validInsertPosition(self, _key, prevId, nextId)) {
570             nextId = self.nodes[nextId].prevId;
571             prevId = self.nodes[nextId].prevId;
572         }
573 
574         return (prevId, nextId);
575     }
576 
577     /*
578      * @dev Find the insert position for a new node with the given key
579      * @param _key Node's key
580      * @param _prevId Id of previous node for the insert position
581      * @param _nextId Id of next node for the insert position
582      */
583     function findInsertPosition(Data storage self, uint256 _key, address _prevId, address _nextId) private view returns (address, address) {
584         address prevId = _prevId;
585         address nextId = _nextId;
586 
587         if (prevId != address(0)) {
588             if (!contains(self, prevId) || _key > self.nodes[prevId].key) {
589                 // `prevId` does not exist anymore or now has a smaller key than the given key
590                 prevId = address(0);
591             }
592         }
593 
594         if (nextId != address(0)) {
595             if (!contains(self, nextId) || _key < self.nodes[nextId].key) {
596                 // `nextId` does not exist anymore or now has a larger key than the given key
597                 nextId = address(0);
598             }
599         }
600 
601         if (prevId == address(0) && nextId == address(0)) {
602             // No hint - descend list starting from head
603             return descendList(self, _key, self.head);
604         } else if (prevId == address(0)) {
605             // No `prevId` for hint - ascend list starting from `nextId`
606             return ascendList(self, _key, nextId);
607         } else if (nextId == address(0)) {
608             // No `nextId` for hint - descend list starting from `prevId`
609             return descendList(self, _key, prevId);
610         } else {
611             // Descend list starting from `prevId`
612             return descendList(self, _key, prevId);
613         }
614     }
615 }
616 
617 /**
618  * @title EarningsPool
619  * @dev Manages reward and fee pools for delegators and transcoders
620  */
621 library EarningsPool {
622     using SafeMath for uint256;
623 
624     // Represents rewards and fees to be distributed to delegators
625     // The `hasTranscoderRewardFeePool` flag was introduced so that EarningsPool.Data structs used by the BondingManager
626     // created with older versions of this library can be differentiated from EarningsPool.Data structs used by the BondingManager
627     // created with a newer version of this library. If the flag is true, then the struct was initialized using the `init` function
628     // using a newer version of this library meaning that it is using separate transcoder reward and fee pools
629     struct Data {
630         uint256 rewardPool;                // Delegator rewards. If `hasTranscoderRewardFeePool` is false, this will contain transcoder rewards as well
631         uint256 feePool;                   // Delegator fees. If `hasTranscoderRewardFeePool` is false, this will contain transcoder fees as well
632         uint256 totalStake;                // Transcoder's total stake during the earnings pool's round
633         uint256 claimableStake;            // Stake that can be used to claim portions of the fee and reward pools
634         uint256 transcoderRewardCut;       // Transcoder's reward cut during the earnings pool's round
635         uint256 transcoderFeeShare;        // Transcoder's fee share during the earnings pool's round
636         uint256 transcoderRewardPool;      // Transcoder rewards. If `hasTranscoderRewardFeePool` is false, this should always be 0
637         uint256 transcoderFeePool;         // Transcoder fees. If `hasTranscoderRewardFeePool` is false, this should always be 0
638         bool hasTranscoderRewardFeePool;   // Flag to indicate if the earnings pool has separate transcoder reward and fee pools
639     }
640 
641     /**
642      * @dev Initialize a EarningsPool struct
643      * @param earningsPool Storage pointer to EarningsPool struct
644      * @param _stake Total stake of the transcoder during the earnings pool's round
645      * @param _rewardCut Reward cut of transcoder during the earnings pool's round
646      * @param _feeShare Fee share of transcoder during the earnings pool's round
647      */
648     function init(EarningsPool.Data storage earningsPool, uint256 _stake, uint256 _rewardCut, uint256 _feeShare) internal {
649         earningsPool.totalStake = _stake;
650         earningsPool.claimableStake = _stake;
651         earningsPool.transcoderRewardCut = _rewardCut;
652         earningsPool.transcoderFeeShare = _feeShare;
653         // We set this flag to true here to differentiate between EarningsPool structs created using older versions of this library.
654         // When using a version of this library after the introduction of this flag to read an EarningsPool struct created using an older version
655         // of this library, this flag should be false in the returned struct because the default value for EVM storage is 0
656         earningsPool.hasTranscoderRewardFeePool = true;
657     }
658 
659     /**
660      * @dev Return whether this earnings pool has claimable shares i.e. is there unclaimed stake
661      * @param earningsPool Storage pointer to EarningsPool struct
662      */
663     function hasClaimableShares(EarningsPool.Data storage earningsPool) internal view returns (bool) {
664         return earningsPool.claimableStake > 0;
665     }
666 
667     /** 
668      * @dev Add fees to the earnings pool
669      * @param earningsPool Storage pointer to EarningsPools struct
670      * @param _fees Amount of fees to add
671      */
672     function addToFeePool(EarningsPool.Data storage earningsPool, uint256 _fees) internal {
673         if (earningsPool.hasTranscoderRewardFeePool) {
674             // If the earnings pool has a separate transcoder fee pool, calculate the portion of incoming fees
675             // to put into the delegator fee pool and the portion to put into the transcoder fee pool
676             uint256 delegatorFees = MathUtils.percOf(_fees, earningsPool.transcoderFeeShare);
677             earningsPool.feePool = earningsPool.feePool.add(delegatorFees);
678             earningsPool.transcoderFeePool = earningsPool.transcoderFeePool.add(_fees.sub(delegatorFees));
679         } else {
680             // If the earnings pool does not have a separate transcoder fee pool, put all the fees into the delegator fee pool
681             earningsPool.feePool = earningsPool.feePool.add(_fees);
682         }
683     }
684 
685     /** 
686      * @dev Add rewards to the earnings pool
687      * @param earningsPool Storage pointer to EarningsPool struct
688      * @param _rewards Amount of rewards to add
689      */
690     function addToRewardPool(EarningsPool.Data storage earningsPool, uint256 _rewards) internal {
691         if (earningsPool.hasTranscoderRewardFeePool) {
692             // If the earnings pool has a separate transcoder reward pool, calculate the portion of incoming rewards
693             // to put into the delegator reward pool and the portion to put into the transcoder reward pool
694             uint256 transcoderRewards = MathUtils.percOf(_rewards, earningsPool.transcoderRewardCut);
695             earningsPool.rewardPool = earningsPool.rewardPool.add(_rewards.sub(transcoderRewards));
696             earningsPool.transcoderRewardPool = earningsPool.transcoderRewardPool.add(transcoderRewards);
697         } else {
698             // If the earnings pool does not have a separate transcoder reward pool, put all the rewards into the delegator reward pool
699             earningsPool.rewardPool = earningsPool.rewardPool.add(_rewards);
700         }
701     }
702 
703     /**
704      * @dev Claim reward and fee shares which decreases the reward/fee pools and the remaining claimable stake
705      * @param earningsPool Storage pointer to EarningsPool struct
706      * @param _stake Stake of claimant
707      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
708      */
709     function claimShare(EarningsPool.Data storage earningsPool, uint256 _stake, bool _isTranscoder) internal returns (uint256, uint256) {
710         uint256 totalFees = 0;
711         uint256 totalRewards = 0;
712         uint256 delegatorFees = 0;
713         uint256 transcoderFees = 0;
714         uint256 delegatorRewards = 0;
715         uint256 transcoderRewards = 0;
716 
717         if (earningsPool.hasTranscoderRewardFeePool) {
718             // EarningsPool has transcoder reward and fee pools
719             // Compute fee share
720             (delegatorFees, transcoderFees) = feePoolShareWithTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
721             totalFees = delegatorFees.add(transcoderFees);
722             // Compute reward share
723             (delegatorRewards, transcoderRewards) = rewardPoolShareWithTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
724             totalRewards = delegatorRewards.add(transcoderRewards);
725 
726             // Fee pool only holds delegator fees when `hasTranscoderRewardFeePool` is true - deduct delegator fees
727             earningsPool.feePool = earningsPool.feePool.sub(delegatorFees);
728             // Reward pool only holds delegator rewards when `hasTranscoderRewardFeePool` is true - deduct delegator rewards
729             earningsPool.rewardPool = earningsPool.rewardPool.sub(delegatorRewards);
730 
731             if (_isTranscoder) {
732                 // Claiming as a transcoder
733                 // Clear transcoder fee pool
734                 earningsPool.transcoderFeePool = 0;
735                 // Clear transcoder reward pool
736                 earningsPool.transcoderRewardPool = 0;
737             }
738         } else {
739             // EarningsPool does not have transcoder reward and fee pools
740             // Compute fee share
741             (delegatorFees, transcoderFees) = feePoolShareNoTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
742             totalFees = delegatorFees.add(transcoderFees);
743             // Compute reward share
744             (delegatorRewards, transcoderRewards) = rewardPoolShareNoTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
745             totalRewards = delegatorRewards.add(transcoderRewards);
746 
747             // Fee pool holds delegator and transcoder fees when `hasTranscoderRewardFeePool` is false - deduct delegator and transcoder fees
748             earningsPool.feePool = earningsPool.feePool.sub(totalFees);
749             // Reward pool holds delegator and transcoder fees when `hasTranscoderRewardFeePool` is false - deduct delegator and transcoder fees
750             earningsPool.rewardPool = earningsPool.rewardPool.sub(totalRewards);
751         }
752 
753         // Update remaining claimable stake
754         earningsPool.claimableStake = earningsPool.claimableStake.sub(_stake);
755 
756         return (totalFees, totalRewards);
757     }
758 
759     /** 
760      * @dev Returns the fee pool share for a claimant. If the claimant is a transcoder, include transcoder fees as well.
761      * @param earningsPool Storage pointer to EarningsPool struct
762      * @param _stake Stake of claimant
763      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
764      */
765     function feePoolShare(EarningsPool.Data storage earningsPool, uint256 _stake, bool _isTranscoder) internal view returns (uint256) {
766         uint256 delegatorFees = 0;
767         uint256 transcoderFees = 0;
768 
769         if (earningsPool.hasTranscoderRewardFeePool) {
770             (delegatorFees, transcoderFees) = feePoolShareWithTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
771         } else {
772             (delegatorFees, transcoderFees) = feePoolShareNoTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
773         }
774 
775         return delegatorFees.add(transcoderFees);
776     }
777 
778     /** 
779      * @dev Returns the reward pool share for a claimant. If the claimant is a transcoder, include transcoder rewards as well.
780      * @param earningsPool Storage pointer to EarningsPool struct
781      * @param _stake Stake of claimant
782      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
783      */
784     function rewardPoolShare(EarningsPool.Data storage earningsPool, uint256 _stake, bool _isTranscoder) internal view returns (uint256) {
785         uint256 delegatorRewards = 0;
786         uint256 transcoderRewards = 0;
787 
788         if (earningsPool.hasTranscoderRewardFeePool) {
789             (delegatorRewards, transcoderRewards) = rewardPoolShareWithTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
790         } else {
791             (delegatorRewards, transcoderRewards) = rewardPoolShareNoTranscoderRewardFeePool(earningsPool, _stake, _isTranscoder);
792         }
793 
794         return delegatorRewards.add(transcoderRewards);
795     }
796 
797     /** 
798      * @dev Helper function to calculate fee pool share if the earnings pool has a separate transcoder fee pool
799      * @param earningsPool Storage pointer to EarningsPool struct
800      * @param _stake Stake of claimant
801      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
802      */
803     function feePoolShareWithTranscoderRewardFeePool(
804         EarningsPool.Data storage earningsPool,
805         uint256 _stake,
806         bool _isTranscoder
807     ) 
808         internal
809         view
810         returns (uint256, uint256)
811     {
812         // If there is no claimable stake, the fee pool share is 0
813         // If there is claimable stake, calculate fee pool share based on remaining amount in fee pool, remaining claimable stake and claimant's stake
814         uint256 delegatorFees = earningsPool.claimableStake > 0 ? MathUtils.percOf(earningsPool.feePool, _stake, earningsPool.claimableStake) : 0;
815 
816         // If claimant is a transcoder, include transcoder fee pool as well
817         return _isTranscoder ? (delegatorFees, earningsPool.transcoderFeePool) : (delegatorFees, 0);
818     }
819 
820     /** 
821      * @dev Helper function to calculate reward pool share if the earnings pool has a separate transcoder reward pool
822      * @param earningsPool Storage pointer to EarningsPool struct
823      * @param _stake Stake of claimant
824      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
825      */
826     function rewardPoolShareWithTranscoderRewardFeePool(
827         EarningsPool.Data storage earningsPool,
828         uint256 _stake,
829         bool _isTranscoder
830     )
831         internal
832         view
833         returns (uint256, uint256)
834     {
835         // If there is no claimable stake, the reward pool share is 0
836         // If there is claimable stake, calculate reward pool share based on remaining amount in reward pool, remaining claimable stake and claimant's stake
837         uint256 delegatorRewards = earningsPool.claimableStake > 0 ? MathUtils.percOf(earningsPool.rewardPool, _stake, earningsPool.claimableStake) : 0;
838 
839         // If claimant is a transcoder, include transcoder reward pool as well
840         return _isTranscoder ? (delegatorRewards, earningsPool.transcoderRewardPool) : (delegatorRewards, 0);
841     }
842    
843     /**
844      * @dev Helper function to calculate the fee pool share if the earnings pool does not have a separate transcoder fee pool
845      * This implements calculation logic from a previous version of this library
846      * @param earningsPool Storage pointer to EarningsPool struct
847      * @param _stake Stake of claimant
848      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
849      */
850     function feePoolShareNoTranscoderRewardFeePool(
851         EarningsPool.Data storage earningsPool,
852         uint256 _stake,
853         bool _isTranscoder
854     ) 
855         internal
856         view
857         returns (uint256, uint256)
858     {
859         uint256 transcoderFees = 0;
860         uint256 delegatorFees = 0;
861 
862         if (earningsPool.claimableStake > 0) {
863             uint256 delegatorsFees = MathUtils.percOf(earningsPool.feePool, earningsPool.transcoderFeeShare);
864             transcoderFees = earningsPool.feePool.sub(delegatorsFees);
865             delegatorFees = MathUtils.percOf(delegatorsFees, _stake, earningsPool.claimableStake);
866         }
867 
868         if (_isTranscoder) {
869             return (delegatorFees, transcoderFees);
870         } else {
871             return (delegatorFees, 0);
872         }
873     }
874 
875     /**
876      * @dev Helper function to calculate the reward pool share if the earnings pool does not have a separate transcoder reward pool
877      * This implements calculation logic from a previous version of this library
878      * @param earningsPool Storage pointer to EarningsPool struct
879      * @param _stake Stake of claimant
880      * @param _isTranscoder Flag indicating whether the claimant is a transcoder
881      */
882     function rewardPoolShareNoTranscoderRewardFeePool(
883         EarningsPool.Data storage earningsPool,
884         uint256 _stake,
885         bool _isTranscoder
886     )
887         internal
888         view
889         returns (uint256, uint256)
890     {
891         uint256 transcoderRewards = 0;
892         uint256 delegatorRewards = 0;
893 
894         if (earningsPool.claimableStake > 0) {
895             transcoderRewards = MathUtils.percOf(earningsPool.rewardPool, earningsPool.transcoderRewardCut);
896             delegatorRewards = MathUtils.percOf(earningsPool.rewardPool.sub(transcoderRewards), _stake, earningsPool.claimableStake);
897         }
898 
899         if (_isTranscoder) {
900             return (delegatorRewards, transcoderRewards);
901         } else {
902             return (delegatorRewards, 0);
903         }
904     }
905 }
906 
907 contract ILivepeerToken is ERC20, Ownable {
908     function mint(address _to, uint256 _amount) public returns (bool);
909     function burn(uint256 _amount) public;
910 }
911 
912 /**
913  * @title Minter interface
914  */
915 contract IMinter {
916     // Events
917     event SetCurrentRewardTokens(uint256 currentMintableTokens, uint256 currentInflation);
918 
919     // External functions
920     function createReward(uint256 _fracNum, uint256 _fracDenom) external returns (uint256);
921     function trustedTransferTokens(address _to, uint256 _amount) external;
922     function trustedBurnTokens(uint256 _amount) external;
923     function trustedWithdrawETH(address _to, uint256 _amount) external;
924     function depositETH() external payable returns (bool);
925     function setCurrentRewardTokens() external;
926 
927     // Public functions
928     function getController() public view returns (IController);
929 }
930 
931 /**
932  * @title RoundsManager interface
933  */
934 contract IRoundsManager {
935     // Events
936     event NewRound(uint256 round);
937 
938     // External functions
939     function initializeRound() external;
940 
941     // Public functions
942     function blockNum() public view returns (uint256);
943     function blockHash(uint256 _block) public view returns (bytes32);
944     function currentRound() public view returns (uint256);
945     function currentRoundStartBlock() public view returns (uint256);
946     function currentRoundInitialized() public view returns (bool);
947     function currentRoundLocked() public view returns (bool);
948 }
949 
950 /*
951  * @title Interface for BondingManager
952  * TODO: switch to interface type
953  */
954 contract IBondingManager {
955     event TranscoderUpdate(address indexed transcoder, uint256 pendingRewardCut, uint256 pendingFeeShare, uint256 pendingPricePerSegment, bool registered);
956     event TranscoderEvicted(address indexed transcoder);
957     event TranscoderResigned(address indexed transcoder);
958     event TranscoderSlashed(address indexed transcoder, address finder, uint256 penalty, uint256 finderReward);
959     event Reward(address indexed transcoder, uint256 amount);
960     event Bond(address indexed newDelegate, address indexed oldDelegate, address indexed delegator, uint256 additionalAmount, uint256 bondedAmount);
961     event Unbond(address indexed delegate, address indexed delegator, uint256 unbondingLockId, uint256 amount, uint256 withdrawRound);
962     event Rebond(address indexed delegate, address indexed delegator, uint256 unbondingLockId, uint256 amount);
963     event WithdrawStake(address indexed delegator, uint256 unbondingLockId, uint256 amount, uint256 withdrawRound);
964     event WithdrawFees(address indexed delegator);
965 
966     // External functions
967     function setActiveTranscoders() external;
968     function updateTranscoderWithFees(address _transcoder, uint256 _fees, uint256 _round) external;
969     function slashTranscoder(address _transcoder, address _finder, uint256 _slashAmount, uint256 _finderFee) external;
970     function electActiveTranscoder(uint256 _maxPricePerSegment, bytes32 _blockHash, uint256 _round) external view returns (address);
971 
972     // Public functions
973     function transcoderTotalStake(address _transcoder) public view returns (uint256);
974     function activeTranscoderTotalStake(address _transcoder, uint256 _round) public view returns (uint256);
975     function isRegisteredTranscoder(address _transcoder) public view returns (bool);
976     function getTotalBonded() public view returns (uint256);
977 }
978 
979 /**
980  * @title BondingManager
981  * @dev Manages bonding, transcoder and rewards/fee accounting related operations of the Livepeer protocol
982  */
983 contract BondingManager is ManagerProxyTarget, IBondingManager {
984     using SafeMath for uint256;
985     using SortedDoublyLL for SortedDoublyLL.Data;
986     using EarningsPool for EarningsPool.Data;
987 
988     // Time between unbonding and possible withdrawl in rounds
989     uint64 public unbondingPeriod;
990     // Number of active transcoders
991     uint256 public numActiveTranscoders;
992     // Max number of rounds that a caller can claim earnings for at once
993     uint256 public maxEarningsClaimsRounds;
994 
995     // Represents a transcoder's current state
996     struct Transcoder {
997         uint256 lastRewardRound;                             // Last round that the transcoder called reward
998         uint256 rewardCut;                                   // % of reward paid to transcoder by a delegator
999         uint256 feeShare;                                    // % of fees paid to delegators by transcoder
1000         uint256 pricePerSegment;                             // Price per segment (denominated in LPT units) for a stream
1001         uint256 pendingRewardCut;                            // Pending reward cut for next round if the transcoder is active
1002         uint256 pendingFeeShare;                             // Pending fee share for next round if the transcoder is active
1003         uint256 pendingPricePerSegment;                      // Pending price per segment for next round if the transcoder is active
1004         mapping (uint256 => EarningsPool.Data) earningsPoolPerRound;  // Mapping of round => earnings pool for the round
1005     }
1006 
1007     // The various states a transcoder can be in
1008     enum TranscoderStatus { NotRegistered, Registered }
1009 
1010     // Represents a delegator's current state
1011     struct Delegator {
1012         uint256 bondedAmount;                    // The amount of bonded tokens
1013         uint256 fees;                            // The amount of fees collected
1014         address delegateAddress;                 // The address delegated to
1015         uint256 delegatedAmount;                 // The amount of tokens delegated to the delegator
1016         uint256 startRound;                      // The round the delegator transitions to bonded phase and is delegated to someone
1017         uint256 withdrawRoundDEPRECATED;         // DEPRECATED - DO NOT USE
1018         uint256 lastClaimRound;                  // The last round during which the delegator claimed its earnings
1019         uint256 nextUnbondingLockId;             // ID for the next unbonding lock created
1020         mapping (uint256 => UnbondingLock) unbondingLocks; // Mapping of unbonding lock ID => unbonding lock
1021     }
1022 
1023     // The various states a delegator can be in
1024     enum DelegatorStatus { Pending, Bonded, Unbonded }
1025 
1026     // Represents an amount of tokens that are being unbonded
1027     struct UnbondingLock {
1028         uint256 amount;              // Amount of tokens being unbonded
1029         uint256 withdrawRound;       // Round at which unbonding period is over and tokens can be withdrawn
1030     }
1031 
1032     // Keep track of the known transcoders and delegators
1033     mapping (address => Delegator) private delegators;
1034     mapping (address => Transcoder) private transcoders;
1035 
1036     // DEPRECATED - DO NOT USE
1037     // The function getTotalBonded() no longer uses this variable
1038     // and instead calculates the total bonded value separately
1039     uint256 private totalBondedDEPRECATED;
1040 
1041     // Candidate and reserve transcoders
1042     SortedDoublyLL.Data private transcoderPool;
1043 
1044     // Represents the active transcoder set
1045     struct ActiveTranscoderSet {
1046         address[] transcoders;
1047         mapping (address => bool) isActive;
1048         uint256 totalStake;
1049     }
1050 
1051     // Keep track of active transcoder set for each round
1052     mapping (uint256 => ActiveTranscoderSet) public activeTranscoderSet;
1053 
1054     // Check if sender is JobsManager
1055     modifier onlyJobsManager() {
1056         require(msg.sender == controller.getContract(keccak256("JobsManager")));
1057         _;
1058     }
1059 
1060     // Check if sender is RoundsManager
1061     modifier onlyRoundsManager() {
1062         require(msg.sender == controller.getContract(keccak256("RoundsManager")));
1063         _;
1064     }
1065 
1066     // Check if current round is initialized
1067     modifier currentRoundInitialized() {
1068         require(roundsManager().currentRoundInitialized());
1069         _;
1070     }
1071 
1072     // Automatically claim earnings from lastClaimRound through the current round
1073     modifier autoClaimEarnings() {
1074         updateDelegatorWithEarnings(msg.sender, roundsManager().currentRound());
1075         _;
1076     }
1077 
1078     /**
1079      * @dev BondingManager constructor. Only invokes constructor of base Manager contract with provided Controller address
1080      * @param _controller Address of Controller that this contract will be registered with
1081      */
1082     function BondingManager(address _controller) public Manager(_controller) {}
1083 
1084     /**
1085      * @dev Set unbonding period. Only callable by Controller owner
1086      * @param _unbondingPeriod Rounds between unbonding and possible withdrawal
1087      */
1088     function setUnbondingPeriod(uint64 _unbondingPeriod) external onlyControllerOwner {
1089         unbondingPeriod = _unbondingPeriod;
1090 
1091         ParameterUpdate("unbondingPeriod");
1092     }
1093 
1094     /**
1095      * @dev Set max number of registered transcoders. Only callable by Controller owner
1096      * @param _numTranscoders Max number of registered transcoders
1097      */
1098     function setNumTranscoders(uint256 _numTranscoders) external onlyControllerOwner {
1099         // Max number of transcoders must be greater than or equal to number of active transcoders
1100         require(_numTranscoders >= numActiveTranscoders);
1101 
1102         transcoderPool.setMaxSize(_numTranscoders);
1103 
1104         ParameterUpdate("numTranscoders");
1105     }
1106 
1107     /**
1108      * @dev Set number of active transcoders. Only callable by Controller owner
1109      * @param _numActiveTranscoders Number of active transcoders
1110      */
1111     function setNumActiveTranscoders(uint256 _numActiveTranscoders) external onlyControllerOwner {
1112         // Number of active transcoders cannot exceed max number of transcoders
1113         require(_numActiveTranscoders <= transcoderPool.getMaxSize());
1114 
1115         numActiveTranscoders = _numActiveTranscoders;
1116 
1117         ParameterUpdate("numActiveTranscoders");
1118     }
1119 
1120     /**
1121      * @dev Set max number of rounds a caller can claim earnings for at once. Only callable by Controller owner
1122      * @param _maxEarningsClaimsRounds Max number of rounds a caller can claim earnings for at once
1123      */
1124     function setMaxEarningsClaimsRounds(uint256 _maxEarningsClaimsRounds) external onlyControllerOwner {
1125         maxEarningsClaimsRounds = _maxEarningsClaimsRounds;
1126 
1127         ParameterUpdate("maxEarningsClaimsRounds");
1128     }
1129 
1130     /**
1131      * @dev The sender is declaring themselves as a candidate for active transcoding.
1132      * @param _rewardCut % of reward paid to transcoder by a delegator
1133      * @param _feeShare % of fees paid to delegators by a transcoder
1134      * @param _pricePerSegment Price per segment (denominated in Wei) for a stream
1135      */
1136     function transcoder(uint256 _rewardCut, uint256 _feeShare, uint256 _pricePerSegment)
1137         external
1138         whenSystemNotPaused
1139         currentRoundInitialized
1140     {
1141         Transcoder storage t = transcoders[msg.sender];
1142         Delegator storage del = delegators[msg.sender];
1143 
1144         if (roundsManager().currentRoundLocked()) {
1145             // If it is the lock period of the current round
1146             // the lowest price previously set by any transcoder
1147             // becomes the price floor and the caller can lower its
1148             // own price to a point greater than or equal to the price floor
1149 
1150             // Caller must already be a registered transcoder
1151             require(transcoderStatus(msg.sender) == TranscoderStatus.Registered);
1152             // Provided rewardCut value must equal the current pendingRewardCut value
1153             // This value cannot change during the lock period
1154             require(_rewardCut == t.pendingRewardCut);
1155             // Provided feeShare value must equal the current pendingFeeShare value
1156             // This value cannot change during the lock period
1157             require(_feeShare == t.pendingFeeShare);
1158 
1159             // Iterate through the transcoder pool to find the price floor
1160             // Since the caller must be a registered transcoder, the transcoder pool size will always at least be 1
1161             // Thus, we can safely set the initial price floor to be the pendingPricePerSegment of the first
1162             // transcoder in the pool
1163             address currentTranscoder = transcoderPool.getFirst();
1164             uint256 priceFloor = transcoders[currentTranscoder].pendingPricePerSegment;
1165             for (uint256 i = 0; i < transcoderPool.getSize(); i++) {
1166                 if (transcoders[currentTranscoder].pendingPricePerSegment < priceFloor) {
1167                     priceFloor = transcoders[currentTranscoder].pendingPricePerSegment;
1168                 }
1169 
1170                 currentTranscoder = transcoderPool.getNext(currentTranscoder);
1171             }
1172 
1173             // Provided pricePerSegment must be greater than or equal to the price floor and
1174             // less than or equal to the previously set pricePerSegment by the caller
1175             require(_pricePerSegment >= priceFloor && _pricePerSegment <= t.pendingPricePerSegment);
1176 
1177             t.pendingPricePerSegment = _pricePerSegment;
1178 
1179             TranscoderUpdate(msg.sender, t.pendingRewardCut, t.pendingFeeShare, _pricePerSegment, true);
1180         } else {
1181             // It is not the lock period of the current round
1182             // Caller is free to change rewardCut, feeShare, pricePerSegment as it pleases
1183             // If caller is not a registered transcoder, it can also register and join the transcoder pool
1184             // if it has sufficient delegated stake
1185             // If caller is not a registered transcoder and does not have sufficient delegated stake
1186             // to join the transcoder pool, it can change rewardCut, feeShare, pricePerSegment
1187             // as information signals to delegators in an effort to camapaign and accumulate
1188             // more delegated stake
1189 
1190             // Reward cut must be a valid percentage
1191             require(MathUtils.validPerc(_rewardCut));
1192             // Fee share must be a valid percentage
1193             require(MathUtils.validPerc(_feeShare));
1194 
1195             // Must have a non-zero amount bonded to self
1196             require(del.delegateAddress == msg.sender && del.bondedAmount > 0);
1197 
1198             t.pendingRewardCut = _rewardCut;
1199             t.pendingFeeShare = _feeShare;
1200             t.pendingPricePerSegment = _pricePerSegment;
1201 
1202             uint256 delegatedAmount = del.delegatedAmount;
1203 
1204             // Check if transcoder is not already registered
1205             if (transcoderStatus(msg.sender) == TranscoderStatus.NotRegistered) {
1206                 if (!transcoderPool.isFull()) {
1207                     // If pool is not full add new transcoder
1208                     transcoderPool.insert(msg.sender, delegatedAmount, address(0), address(0));
1209                 } else {
1210                     address lastTranscoder = transcoderPool.getLast();
1211 
1212                     if (delegatedAmount > transcoderTotalStake(lastTranscoder)) {
1213                         // If pool is full and caller has more delegated stake than the transcoder in the pool with the least delegated stake:
1214                         // - Evict transcoder in pool with least delegated stake
1215                         // - Add caller to pool
1216                         transcoderPool.remove(lastTranscoder);
1217                         transcoderPool.insert(msg.sender, delegatedAmount, address(0), address(0));
1218 
1219                         TranscoderEvicted(lastTranscoder);
1220                     }
1221                 }
1222             }
1223 
1224             TranscoderUpdate(msg.sender, _rewardCut, _feeShare, _pricePerSegment, transcoderPool.contains(msg.sender));
1225         }
1226     }
1227 
1228     /**
1229      * @dev Delegate stake towards a specific address.
1230      * @param _amount The amount of LPT to stake.
1231      * @param _to The address of the transcoder to stake towards.
1232      */
1233     function bond(
1234         uint256 _amount,
1235         address _to
1236     )
1237         external
1238         whenSystemNotPaused
1239         currentRoundInitialized
1240         autoClaimEarnings
1241     {
1242         Delegator storage del = delegators[msg.sender];
1243 
1244         uint256 currentRound = roundsManager().currentRound();
1245         // Amount to delegate
1246         uint256 delegationAmount = _amount;
1247         // Current delegate
1248         address currentDelegate = del.delegateAddress;
1249 
1250         if (delegatorStatus(msg.sender) == DelegatorStatus.Unbonded) {
1251             // New delegate
1252             // Set start round
1253             // Don't set start round if delegator is in pending state because the start round would not change
1254             del.startRound = currentRound.add(1);
1255             // Unbonded state = no existing delegate and no bonded stake
1256             // Thus, delegation amount = provided amount
1257         } else if (del.delegateAddress != address(0) && _to != del.delegateAddress) {
1258             // A registered transcoder cannot delegate its bonded stake toward another address
1259             // because it can only be delegated toward itself
1260             // In the future, if delegation towards another registered transcoder as an already
1261             // registered transcoder becomes useful (i.e. for transitive delegation), this restriction
1262             // could be removed
1263             require(transcoderStatus(msg.sender) == TranscoderStatus.NotRegistered);
1264             // Changing delegate
1265             // Set start round
1266             del.startRound = currentRound.add(1);
1267             // Update amount to delegate with previous delegation amount
1268             delegationAmount = delegationAmount.add(del.bondedAmount);
1269             // Decrease old delegate's delegated amount
1270             delegators[currentDelegate].delegatedAmount = delegators[currentDelegate].delegatedAmount.sub(del.bondedAmount);
1271 
1272             if (transcoderStatus(currentDelegate) == TranscoderStatus.Registered) {
1273                 // Previously delegated to a transcoder
1274                 // Decrease old transcoder's total stake
1275                 transcoderPool.updateKey(currentDelegate, transcoderTotalStake(currentDelegate).sub(del.bondedAmount), address(0), address(0));
1276             }
1277         }
1278 
1279         // Delegation amount must be > 0 - cannot delegate to someone without having bonded stake
1280         require(delegationAmount > 0);
1281         // Update delegate
1282         del.delegateAddress = _to;
1283         // Update current delegate's delegated amount with delegation amount
1284         delegators[_to].delegatedAmount = delegators[_to].delegatedAmount.add(delegationAmount);
1285 
1286         if (transcoderStatus(_to) == TranscoderStatus.Registered) {
1287             // Delegated to a transcoder
1288             // Increase transcoder's total stake
1289             transcoderPool.updateKey(_to, transcoderTotalStake(del.delegateAddress).add(delegationAmount), address(0), address(0));
1290         }
1291 
1292         if (_amount > 0) {
1293             // Update bonded amount
1294             del.bondedAmount = del.bondedAmount.add(_amount);
1295             // Transfer the LPT to the Minter
1296             livepeerToken().transferFrom(msg.sender, minter(), _amount);
1297         }
1298 
1299         Bond(_to, currentDelegate, msg.sender, _amount, del.bondedAmount);
1300     }
1301 
1302     /**
1303      * @dev Unbond an amount of the delegator's bonded stake
1304      * @param _amount Amount of tokens to unbond
1305      */
1306     function unbond(uint256 _amount)
1307         external
1308         whenSystemNotPaused
1309         currentRoundInitialized
1310         autoClaimEarnings
1311     {
1312         // Caller must be in bonded state
1313         require(delegatorStatus(msg.sender) == DelegatorStatus.Bonded);
1314 
1315         Delegator storage del = delegators[msg.sender];
1316 
1317         // Amount must be greater than 0
1318         require(_amount > 0);
1319         // Amount to unbond must be less than or equal to current bonded amount 
1320         require(_amount <= del.bondedAmount);
1321 
1322         address currentDelegate = del.delegateAddress;
1323         uint256 currentRound = roundsManager().currentRound();
1324         uint256 withdrawRound = currentRound.add(unbondingPeriod);
1325         uint256 unbondingLockId = del.nextUnbondingLockId;
1326 
1327         // Create new unbonding lock
1328         del.unbondingLocks[unbondingLockId] = UnbondingLock({
1329             amount: _amount,
1330             withdrawRound: withdrawRound
1331         });
1332         // Increment ID for next unbonding lock
1333         del.nextUnbondingLockId = unbondingLockId.add(1);
1334         // Decrease delegator's bonded amount
1335         del.bondedAmount = del.bondedAmount.sub(_amount);
1336         // Decrease delegate's delegated amount
1337         delegators[del.delegateAddress].delegatedAmount = delegators[del.delegateAddress].delegatedAmount.sub(_amount);
1338 
1339         if (transcoderStatus(del.delegateAddress) == TranscoderStatus.Registered && (del.delegateAddress != msg.sender || del.bondedAmount > 0)) {
1340             // A transcoder's delegated stake within the registered pool needs to be decreased if:
1341             // - The caller's delegate is a registered transcoder
1342             // - Caller is not delegated to self OR caller is delegated to self and has a non-zero bonded amount
1343             // If the caller is delegated to self and has a zero bonded amount, it will be removed from the 
1344             // transcoder pool so its delegated stake within the pool does not need to be decreased
1345             transcoderPool.updateKey(del.delegateAddress, transcoderTotalStake(del.delegateAddress).sub(_amount), address(0), address(0));
1346         }
1347 
1348         // Check if delegator has a zero bonded amount
1349         // If so, update its delegation status
1350         if (del.bondedAmount == 0) {
1351             // Delegator no longer delegated to anyone if it does not have a bonded amount
1352             del.delegateAddress = address(0);
1353             // Delegator does not have a start round if it is no longer delegated to anyone
1354             del.startRound = 0;
1355 
1356             if (transcoderStatus(msg.sender) == TranscoderStatus.Registered) {
1357                 // If caller is a registered transcoder and is no longer bonded, resign
1358                 resignTranscoder(msg.sender);
1359             }
1360         } 
1361 
1362         Unbond(currentDelegate, msg.sender, unbondingLockId, _amount, withdrawRound);
1363     }
1364 
1365     /**
1366      * @dev Rebond tokens for an unbonding lock to a delegator's current delegate while a delegator
1367      * is in the Bonded or Pending states
1368      * @param _unbondingLockId ID of unbonding lock to rebond with
1369      */
1370     function rebond(
1371         uint256 _unbondingLockId
1372     ) 
1373         external
1374         whenSystemNotPaused
1375         currentRoundInitialized 
1376         autoClaimEarnings
1377     {
1378         // Caller must not be an unbonded delegator
1379         require(delegatorStatus(msg.sender) != DelegatorStatus.Unbonded);
1380 
1381         // Process rebond using unbonding lock
1382         processRebond(msg.sender, _unbondingLockId);
1383     }
1384 
1385     /**
1386      * @dev Rebond tokens for an unbonding lock to a delegate while a delegator
1387      * is in the Unbonded state
1388      * @param _to Address of delegate
1389      * @param _unbondingLockId ID of unbonding lock to rebond with
1390      */
1391     function rebondFromUnbonded(
1392         address _to,
1393         uint256 _unbondingLockId
1394     )
1395         external
1396         whenSystemNotPaused
1397         currentRoundInitialized
1398         autoClaimEarnings
1399     {
1400         // Caller must be an unbonded delegator
1401         require(delegatorStatus(msg.sender) == DelegatorStatus.Unbonded);
1402 
1403         // Set delegator's start round and transition into Pending state
1404         delegators[msg.sender].startRound = roundsManager().currentRound().add(1);
1405         // Set delegator's delegate
1406         delegators[msg.sender].delegateAddress = _to;
1407         // Process rebond using unbonding lock
1408         processRebond(msg.sender, _unbondingLockId);
1409     }
1410 
1411     /**
1412      * @dev Withdraws tokens for an unbonding lock that has existed through an unbonding period
1413      * @param _unbondingLockId ID of unbonding lock to withdraw with
1414      */
1415     function withdrawStake(uint256 _unbondingLockId)
1416         external
1417         whenSystemNotPaused
1418         currentRoundInitialized
1419     {
1420         Delegator storage del = delegators[msg.sender];
1421         UnbondingLock storage lock = del.unbondingLocks[_unbondingLockId];
1422 
1423         // Unbonding lock must be valid
1424         require(isValidUnbondingLock(msg.sender, _unbondingLockId));
1425         // Withdrawal must be valid for the unbonding lock i.e. the withdraw round is now or in the past
1426         require(lock.withdrawRound <= roundsManager().currentRound());
1427 
1428         uint256 amount = lock.amount;
1429         uint256 withdrawRound = lock.withdrawRound;
1430         // Delete unbonding lock
1431         delete del.unbondingLocks[_unbondingLockId];
1432 
1433         // Tell Minter to transfer stake (LPT) to the delegator
1434         minter().trustedTransferTokens(msg.sender, amount);
1435 
1436         WithdrawStake(msg.sender, _unbondingLockId, amount, withdrawRound);
1437     }
1438 
1439     /**
1440      * @dev Withdraws fees to the caller
1441      */
1442     function withdrawFees()
1443         external
1444         whenSystemNotPaused
1445         currentRoundInitialized
1446         autoClaimEarnings
1447     {
1448         // Delegator must have fees
1449         require(delegators[msg.sender].fees > 0);
1450 
1451         uint256 amount = delegators[msg.sender].fees;
1452         delegators[msg.sender].fees = 0;
1453 
1454         // Tell Minter to transfer fees (ETH) to the delegator
1455         minter().trustedWithdrawETH(msg.sender, amount);
1456 
1457         WithdrawFees(msg.sender);
1458     }
1459 
1460     /**
1461      * @dev Set active transcoder set for the current round
1462      */
1463     function setActiveTranscoders() external whenSystemNotPaused onlyRoundsManager {
1464         uint256 currentRound = roundsManager().currentRound();
1465         uint256 activeSetSize = Math.min256(numActiveTranscoders, transcoderPool.getSize());
1466 
1467         uint256 totalStake = 0;
1468         address currentTranscoder = transcoderPool.getFirst();
1469 
1470         for (uint256 i = 0; i < activeSetSize; i++) {
1471             activeTranscoderSet[currentRound].transcoders.push(currentTranscoder);
1472             activeTranscoderSet[currentRound].isActive[currentTranscoder] = true;
1473 
1474             uint256 stake = transcoderTotalStake(currentTranscoder);
1475             uint256 rewardCut = transcoders[currentTranscoder].pendingRewardCut;
1476             uint256 feeShare = transcoders[currentTranscoder].pendingFeeShare;
1477             uint256 pricePerSegment = transcoders[currentTranscoder].pendingPricePerSegment;
1478 
1479             Transcoder storage t = transcoders[currentTranscoder];
1480             // Set pending rates as current rates
1481             t.rewardCut = rewardCut;
1482             t.feeShare = feeShare;
1483             t.pricePerSegment = pricePerSegment;
1484             // Initialize token pool
1485             t.earningsPoolPerRound[currentRound].init(stake, rewardCut, feeShare);
1486 
1487             totalStake = totalStake.add(stake);
1488 
1489             // Get next transcoder in the pool
1490             currentTranscoder = transcoderPool.getNext(currentTranscoder);
1491         }
1492 
1493         // Update total stake of all active transcoders
1494         activeTranscoderSet[currentRound].totalStake = totalStake;
1495     }
1496 
1497     /**
1498      * @dev Distribute the token rewards to transcoder and delegates.
1499      * Active transcoders call this once per cycle when it is their turn.
1500      */
1501     function reward() external whenSystemNotPaused currentRoundInitialized {
1502         uint256 currentRound = roundsManager().currentRound();
1503 
1504         // Sender must be an active transcoder
1505         require(activeTranscoderSet[currentRound].isActive[msg.sender]);
1506 
1507         // Transcoder must not have called reward for this round already
1508         require(transcoders[msg.sender].lastRewardRound != currentRound);
1509         // Set last round that transcoder called reward
1510         transcoders[msg.sender].lastRewardRound = currentRound;
1511 
1512         // Create reward based on active transcoder's stake relative to the total active stake
1513         // rewardTokens = (current mintable tokens for the round * active transcoder stake) / total active stake
1514         uint256 rewardTokens = minter().createReward(activeTranscoderTotalStake(msg.sender, currentRound), activeTranscoderSet[currentRound].totalStake);
1515 
1516         updateTranscoderWithRewards(msg.sender, rewardTokens, currentRound);
1517 
1518         Reward(msg.sender, rewardTokens);
1519     }
1520 
1521     /**
1522      * @dev Update transcoder's fee pool
1523      * @param _transcoder Transcoder address
1524      * @param _fees Fees from verified job claims
1525      */
1526     function updateTranscoderWithFees(
1527         address _transcoder,
1528         uint256 _fees,
1529         uint256 _round
1530     )
1531         external
1532         whenSystemNotPaused
1533         onlyJobsManager
1534     {
1535         // Transcoder must be registered
1536         require(transcoderStatus(_transcoder) == TranscoderStatus.Registered);
1537 
1538         Transcoder storage t = transcoders[_transcoder];
1539 
1540         EarningsPool.Data storage earningsPool = t.earningsPoolPerRound[_round];
1541         // Add fees to fee pool
1542         earningsPool.addToFeePool(_fees);
1543     }
1544 
1545     /**
1546      * @dev Slash a transcoder. Slashing can be invoked by the protocol or a finder.
1547      * @param _transcoder Transcoder address
1548      * @param _finder Finder that proved a transcoder violated a slashing condition. Null address if there is no finder
1549      * @param _slashAmount Percentage of transcoder bond to be slashed
1550      * @param _finderFee Percentage of penalty awarded to finder. Zero if there is no finder
1551      */
1552     function slashTranscoder(
1553         address _transcoder,
1554         address _finder,
1555         uint256 _slashAmount,
1556         uint256 _finderFee
1557     )
1558         external
1559         whenSystemNotPaused
1560         onlyJobsManager
1561     {
1562         Delegator storage del = delegators[_transcoder];
1563 
1564         if (del.bondedAmount > 0) {
1565             uint256 penalty = MathUtils.percOf(delegators[_transcoder].bondedAmount, _slashAmount);
1566 
1567             // Decrease bonded stake
1568             del.bondedAmount = del.bondedAmount.sub(penalty);
1569 
1570             // If still bonded
1571             // - Decrease delegate's delegated amount
1572             // - Decrease total bonded tokens
1573             if (delegatorStatus(_transcoder) == DelegatorStatus.Bonded) {
1574                 delegators[del.delegateAddress].delegatedAmount = delegators[del.delegateAddress].delegatedAmount.sub(penalty);
1575             }
1576 
1577             // If registered transcoder, resign it
1578             if (transcoderStatus(_transcoder) == TranscoderStatus.Registered) {
1579                 resignTranscoder(_transcoder);
1580             }
1581 
1582             // Account for penalty
1583             uint256 burnAmount = penalty;
1584 
1585             // Award finder fee if there is a finder address
1586             if (_finder != address(0)) {
1587                 uint256 finderAmount = MathUtils.percOf(penalty, _finderFee);
1588                 minter().trustedTransferTokens(_finder, finderAmount);
1589 
1590                 // Minter burns the slashed funds - finder reward
1591                 minter().trustedBurnTokens(burnAmount.sub(finderAmount));
1592 
1593                 TranscoderSlashed(_transcoder, _finder, penalty, finderAmount);
1594             } else {
1595                 // Minter burns the slashed funds
1596                 minter().trustedBurnTokens(burnAmount);
1597 
1598                 TranscoderSlashed(_transcoder, address(0), penalty, 0);
1599             }
1600         } else {
1601             TranscoderSlashed(_transcoder, _finder, 0, 0);
1602         }
1603     }
1604 
1605     /**
1606      * @dev Pseudorandomly elect a currently active transcoder that charges a price per segment less than or equal to the max price per segment for a job
1607      * Returns address of elected active transcoder and its price per segment
1608      * @param _maxPricePerSegment Max price (in LPT base units) per segment of a stream
1609      * @param _blockHash Job creation block hash used as a pseudorandom seed for assigning an active transcoder
1610      * @param _round Job creation round
1611      */
1612     function electActiveTranscoder(uint256 _maxPricePerSegment, bytes32 _blockHash, uint256 _round) external view returns (address) {
1613         uint256 activeSetSize = activeTranscoderSet[_round].transcoders.length;
1614         // Create array to store available transcoders charging an acceptable price per segment
1615         address[] memory availableTranscoders = new address[](activeSetSize);
1616         // Keep track of the actual number of available transcoders
1617         uint256 numAvailableTranscoders = 0;
1618         // Keep track of total stake of available transcoders
1619         uint256 totalAvailableTranscoderStake = 0;
1620 
1621         for (uint256 i = 0; i < activeSetSize; i++) {
1622             address activeTranscoder = activeTranscoderSet[_round].transcoders[i];
1623             // If a transcoder is active and charges an acceptable price per segment add it to the array of available transcoders
1624             if (activeTranscoderSet[_round].isActive[activeTranscoder] && transcoders[activeTranscoder].pricePerSegment <= _maxPricePerSegment) {
1625                 availableTranscoders[numAvailableTranscoders] = activeTranscoder;
1626                 numAvailableTranscoders++;
1627                 totalAvailableTranscoderStake = totalAvailableTranscoderStake.add(activeTranscoderTotalStake(activeTranscoder, _round));
1628             }
1629         }
1630 
1631         if (numAvailableTranscoders == 0) {
1632             // There is no currently available transcoder that charges a price per segment less than or equal to the max price per segment for a job
1633             return address(0);
1634         } else {
1635             // Pseudorandomly pick an available transcoder weighted by its stake relative to the total stake of all available transcoders
1636             uint256 r = uint256(_blockHash) % totalAvailableTranscoderStake;
1637             uint256 s = 0;
1638             uint256 j = 0;
1639 
1640             while (s <= r && j < numAvailableTranscoders) {
1641                 s = s.add(activeTranscoderTotalStake(availableTranscoders[j], _round));
1642                 j++;
1643             }
1644 
1645             return availableTranscoders[j - 1];
1646         }
1647     }
1648 
1649     /**
1650      * @dev Claim token pools shares for a delegator from its lastClaimRound through the end round
1651      * @param _endRound The last round for which to claim token pools shares for a delegator
1652      */
1653     function claimEarnings(uint256 _endRound) external whenSystemNotPaused currentRoundInitialized {
1654         // End round must be after the last claim round
1655         require(delegators[msg.sender].lastClaimRound < _endRound);
1656         // End round must not be after the current round
1657         require(_endRound <= roundsManager().currentRound());
1658 
1659         updateDelegatorWithEarnings(msg.sender, _endRound);
1660     }
1661 
1662     /**
1663      * @dev Returns pending bonded stake for a delegator from its lastClaimRound through an end round
1664      * @param _delegator Address of delegator
1665      * @param _endRound The last round to compute pending stake from
1666      */
1667     function pendingStake(address _delegator, uint256 _endRound) public view returns (uint256) {
1668         uint256 currentRound = roundsManager().currentRound();
1669         Delegator storage del = delegators[_delegator];
1670         // End round must be before or equal to current round and after lastClaimRound
1671         require(_endRound <= currentRound && _endRound > del.lastClaimRound);
1672 
1673         uint256 currentBondedAmount = del.bondedAmount;
1674 
1675         for (uint256 i = del.lastClaimRound + 1; i <= _endRound; i++) {
1676             EarningsPool.Data storage earningsPool = transcoders[del.delegateAddress].earningsPoolPerRound[i];
1677 
1678             bool isTranscoder = _delegator == del.delegateAddress;
1679             if (earningsPool.hasClaimableShares()) {
1680                 // Calculate and add reward pool share from this round
1681                 currentBondedAmount = currentBondedAmount.add(earningsPool.rewardPoolShare(currentBondedAmount, isTranscoder));
1682             }
1683         }
1684 
1685         return currentBondedAmount;
1686     }
1687 
1688     /**
1689      * @dev Returns pending fees for a delegator from its lastClaimRound through an end round
1690      * @param _delegator Address of delegator
1691      * @param _endRound The last round to compute pending fees from
1692      */
1693     function pendingFees(address _delegator, uint256 _endRound) public view returns (uint256) {
1694         uint256 currentRound = roundsManager().currentRound();
1695         Delegator storage del = delegators[_delegator];
1696         // End round must be before or equal to current round and after lastClaimRound
1697         require(_endRound <= currentRound && _endRound > del.lastClaimRound);
1698 
1699         uint256 currentFees = del.fees;
1700         uint256 currentBondedAmount = del.bondedAmount;
1701 
1702         for (uint256 i = del.lastClaimRound + 1; i <= _endRound; i++) {
1703             EarningsPool.Data storage earningsPool = transcoders[del.delegateAddress].earningsPoolPerRound[i];
1704 
1705             if (earningsPool.hasClaimableShares()) {
1706                 bool isTranscoder = _delegator == del.delegateAddress;
1707                 // Calculate and add fee pool share from this round
1708                 currentFees = currentFees.add(earningsPool.feePoolShare(currentBondedAmount, isTranscoder));
1709                 // Calculate new bonded amount with rewards from this round. Updated bonded amount used
1710                 // to calculate fee pool share in next round
1711                 currentBondedAmount = currentBondedAmount.add(earningsPool.rewardPoolShare(currentBondedAmount, isTranscoder));
1712             }
1713         }
1714 
1715         return currentFees;
1716     }
1717 
1718     /**
1719      * @dev Returns total bonded stake for an active transcoder
1720      * @param _transcoder Address of a transcoder
1721      */
1722     function activeTranscoderTotalStake(address _transcoder, uint256 _round) public view returns (uint256) {
1723         // Must be active transcoder
1724         require(activeTranscoderSet[_round].isActive[_transcoder]);
1725 
1726         return transcoders[_transcoder].earningsPoolPerRound[_round].totalStake;
1727     }
1728 
1729     /**
1730      * @dev Returns total bonded stake for a transcoder
1731      * @param _transcoder Address of transcoder
1732      */
1733     function transcoderTotalStake(address _transcoder) public view returns (uint256) {
1734         return transcoderPool.getKey(_transcoder);
1735     }
1736 
1737     /*
1738      * @dev Computes transcoder status
1739      * @param _transcoder Address of transcoder
1740      */
1741     function transcoderStatus(address _transcoder) public view returns (TranscoderStatus) {
1742         if (transcoderPool.contains(_transcoder)) {
1743             return TranscoderStatus.Registered;
1744         } else {
1745             return TranscoderStatus.NotRegistered;
1746         }
1747     }
1748 
1749     /**
1750      * @dev Computes delegator status
1751      * @param _delegator Address of delegator
1752      */
1753     function delegatorStatus(address _delegator) public view returns (DelegatorStatus) {
1754         Delegator storage del = delegators[_delegator];
1755 
1756         if (del.bondedAmount == 0) {
1757             // Delegator unbonded all its tokens
1758             return DelegatorStatus.Unbonded;
1759         } else if (del.startRound > roundsManager().currentRound()) {
1760             // Delegator round start is in the future
1761             return DelegatorStatus.Pending;
1762         } else if (del.startRound > 0 && del.startRound <= roundsManager().currentRound()) {
1763             // Delegator round start is now or in the past
1764             return DelegatorStatus.Bonded;
1765         } else {
1766             // Default to unbonded
1767             return DelegatorStatus.Unbonded;
1768         }
1769     }
1770 
1771     /**
1772      * @dev Return transcoder information
1773      * @param _transcoder Address of transcoder
1774      */
1775     function getTranscoder(
1776         address _transcoder
1777     )
1778         public
1779         view
1780         returns (uint256 lastRewardRound, uint256 rewardCut, uint256 feeShare, uint256 pricePerSegment, uint256 pendingRewardCut, uint256 pendingFeeShare, uint256 pendingPricePerSegment)
1781     {
1782         Transcoder storage t = transcoders[_transcoder];
1783 
1784         lastRewardRound = t.lastRewardRound;
1785         rewardCut = t.rewardCut;
1786         feeShare = t.feeShare;
1787         pricePerSegment = t.pricePerSegment;
1788         pendingRewardCut = t.pendingRewardCut;
1789         pendingFeeShare = t.pendingFeeShare;
1790         pendingPricePerSegment = t.pendingPricePerSegment;
1791     }
1792 
1793     /**
1794      * @dev Return transcoder's token pools for a given round
1795      * @param _transcoder Address of transcoder
1796      * @param _round Round number
1797      */
1798     function getTranscoderEarningsPoolForRound(
1799         address _transcoder,
1800         uint256 _round
1801     )
1802         public
1803         view
1804         returns (uint256 rewardPool, uint256 feePool, uint256 totalStake, uint256 claimableStake, uint256 transcoderRewardCut, uint256 transcoderFeeShare, uint256 transcoderRewardPool, uint256 transcoderFeePool, bool hasTranscoderRewardFeePool)
1805     {
1806         EarningsPool.Data storage earningsPool = transcoders[_transcoder].earningsPoolPerRound[_round];
1807 
1808         rewardPool = earningsPool.rewardPool;
1809         feePool = earningsPool.feePool;
1810         totalStake = earningsPool.totalStake;
1811         claimableStake = earningsPool.claimableStake;
1812         transcoderRewardCut = earningsPool.transcoderRewardCut;
1813         transcoderFeeShare = earningsPool.transcoderFeeShare;
1814         transcoderRewardPool = earningsPool.transcoderRewardPool;
1815         transcoderFeePool = earningsPool.transcoderFeePool;
1816         hasTranscoderRewardFeePool = earningsPool.hasTranscoderRewardFeePool;
1817     }
1818 
1819     /**
1820      * @dev Return delegator info
1821      * @param _delegator Address of delegator
1822      */
1823     function getDelegator(
1824         address _delegator
1825     )
1826         public
1827         view
1828         returns (uint256 bondedAmount, uint256 fees, address delegateAddress, uint256 delegatedAmount, uint256 startRound, uint256 lastClaimRound, uint256 nextUnbondingLockId)
1829     {
1830         Delegator storage del = delegators[_delegator];
1831 
1832         bondedAmount = del.bondedAmount;
1833         fees = del.fees;
1834         delegateAddress = del.delegateAddress;
1835         delegatedAmount = del.delegatedAmount;
1836         startRound = del.startRound;
1837         lastClaimRound = del.lastClaimRound;
1838         nextUnbondingLockId = del.nextUnbondingLockId;
1839     }
1840 
1841     /**
1842      * @dev Return delegator's unbonding lock info
1843      * @param _delegator Address of delegator
1844      * @param _unbondingLockId ID of unbonding lock
1845      */
1846     function getDelegatorUnbondingLock(
1847         address _delegator,
1848         uint256 _unbondingLockId
1849     ) 
1850         public
1851         view
1852         returns (uint256 amount, uint256 withdrawRound) 
1853     {
1854         UnbondingLock storage lock = delegators[_delegator].unbondingLocks[_unbondingLockId];
1855 
1856         return (lock.amount, lock.withdrawRound);
1857     }
1858 
1859     /**
1860      * @dev Returns max size of transcoder pool
1861      */
1862     function getTranscoderPoolMaxSize() public view returns (uint256) {
1863         return transcoderPool.getMaxSize();
1864     }
1865 
1866     /**
1867      * @dev Returns size of transcoder pool
1868      */
1869     function getTranscoderPoolSize() public view returns (uint256) {
1870         return transcoderPool.getSize();
1871     }
1872 
1873     /**
1874      * @dev Returns transcoder with most stake in pool
1875      */
1876     function getFirstTranscoderInPool() public view returns (address) {
1877         return transcoderPool.getFirst();
1878     }
1879 
1880     /**
1881      * @dev Returns next transcoder in pool for a given transcoder
1882      * @param _transcoder Address of a transcoder in the pool
1883      */
1884     function getNextTranscoderInPool(address _transcoder) public view returns (address) {
1885         return transcoderPool.getNext(_transcoder);
1886     }
1887 
1888     /**
1889      * @dev Return total bonded tokens
1890      */
1891     function getTotalBonded() public view returns (uint256) {
1892         uint256 totalBonded = 0;
1893         uint256 totalTranscoders = transcoderPool.getSize();
1894         address currentTranscoder = transcoderPool.getFirst();
1895 
1896         for (uint256 i = 0; i < totalTranscoders; i++) {
1897             // Add current transcoder's total delegated stake to total bonded counter
1898             totalBonded = totalBonded.add(transcoderTotalStake(currentTranscoder));
1899             // Get next transcoder in the pool
1900             currentTranscoder = transcoderPool.getNext(currentTranscoder);
1901         }
1902 
1903         return totalBonded;
1904     }
1905 
1906     /**
1907      * @dev Return total active stake for a round
1908      * @param _round Round number
1909      */
1910     function getTotalActiveStake(uint256 _round) public view returns (uint256) {
1911         return activeTranscoderSet[_round].totalStake;
1912     }
1913 
1914     /**
1915      * @dev Return whether a transcoder was active during a round
1916      * @param _transcoder Transcoder address
1917      * @param _round Round number
1918      */
1919     function isActiveTranscoder(address _transcoder, uint256 _round) public view returns (bool) {
1920         return activeTranscoderSet[_round].isActive[_transcoder];
1921     }
1922 
1923     /**
1924      * @dev Return whether a transcoder is registered
1925      * @param _transcoder Transcoder address
1926      */
1927     function isRegisteredTranscoder(address _transcoder) public view returns (bool) {
1928         return transcoderStatus(_transcoder) == TranscoderStatus.Registered;
1929     }
1930 
1931     /**
1932      * @dev Return whether an unbonding lock for a delegator is valid
1933      * @param _delegator Address of delegator
1934      * @param _unbondingLockId ID of unbonding lock
1935      */
1936     function isValidUnbondingLock(address _delegator, uint256 _unbondingLockId) public view returns (bool) {
1937         // A unbonding lock is only valid if it has a non-zero withdraw round (the default value is zero)
1938         return delegators[_delegator].unbondingLocks[_unbondingLockId].withdrawRound > 0;
1939     }
1940 
1941     /**
1942      * @dev Remove transcoder
1943      */
1944     function resignTranscoder(address _transcoder) internal {
1945         uint256 currentRound = roundsManager().currentRound();
1946         if (activeTranscoderSet[currentRound].isActive[_transcoder]) {
1947             // Decrease total active stake for the round
1948             activeTranscoderSet[currentRound].totalStake = activeTranscoderSet[currentRound].totalStake.sub(activeTranscoderTotalStake(_transcoder, currentRound));
1949             // Set transcoder as inactive
1950             activeTranscoderSet[currentRound].isActive[_transcoder] = false;
1951         }
1952 
1953         // Remove transcoder from pools
1954         transcoderPool.remove(_transcoder);
1955 
1956         TranscoderResigned(_transcoder);
1957     }
1958 
1959     /**
1960      * @dev Update a transcoder with rewards
1961      * @param _transcoder Address of transcoder
1962      * @param _rewards Amount of rewards
1963      * @param _round Round that transcoder is updated
1964      */
1965     function updateTranscoderWithRewards(address _transcoder, uint256 _rewards, uint256 _round) internal {
1966         Transcoder storage t = transcoders[_transcoder];
1967         Delegator storage del = delegators[_transcoder];
1968 
1969         EarningsPool.Data storage earningsPool = t.earningsPoolPerRound[_round];
1970         // Add rewards to reward pool
1971         earningsPool.addToRewardPool(_rewards);
1972         // Update transcoder's delegated amount with rewards
1973         del.delegatedAmount = del.delegatedAmount.add(_rewards);
1974         // Update transcoder's total stake with rewards
1975         uint256 newStake = transcoderTotalStake(_transcoder).add(_rewards);
1976         transcoderPool.updateKey(_transcoder, newStake, address(0), address(0));
1977     }
1978 
1979     /**
1980      * @dev Update a delegator with token pools shares from its lastClaimRound through a given round
1981      * @param _delegator Delegator address
1982      * @param _endRound The last round for which to update a delegator's stake with token pools shares
1983      */
1984     function updateDelegatorWithEarnings(address _delegator, uint256 _endRound) internal {
1985         Delegator storage del = delegators[_delegator];
1986 
1987         // Only will have earnings to claim if you have a delegate
1988         // If not delegated, skip the earnings claim process
1989         if (del.delegateAddress != address(0)) {
1990             // Cannot claim earnings for more than maxEarningsClaimsRounds
1991             // This is a number to cause transactions to fail early if
1992             // we know they will require too much gas to loop through all the necessary rounds to claim earnings
1993             // The user should instead manually invoke `claimEarnings` to split up the claiming process
1994             // across multiple transactions
1995             require(_endRound.sub(del.lastClaimRound) <= maxEarningsClaimsRounds);
1996 
1997             uint256 currentBondedAmount = del.bondedAmount;
1998             uint256 currentFees = del.fees;
1999 
2000             for (uint256 i = del.lastClaimRound + 1; i <= _endRound; i++) {
2001                 EarningsPool.Data storage earningsPool = transcoders[del.delegateAddress].earningsPoolPerRound[i];
2002 
2003                 if (earningsPool.hasClaimableShares()) {
2004                     bool isTranscoder = _delegator == del.delegateAddress;
2005 
2006                     var (fees, rewards) = earningsPool.claimShare(currentBondedAmount, isTranscoder);
2007 
2008                     currentFees = currentFees.add(fees);
2009                     currentBondedAmount = currentBondedAmount.add(rewards);
2010                 }
2011             }
2012 
2013             // Rewards are bonded by default
2014             del.bondedAmount = currentBondedAmount;
2015             del.fees = currentFees;
2016         }
2017 
2018         del.lastClaimRound = _endRound;
2019     }
2020 
2021     /**
2022      * @dev Update the state of a delegator and its delegate by processing a rebond using an unbonding lock
2023      * @param _delegator Address of delegator
2024      * @param _unbondingLockId ID of unbonding lock to rebond with
2025      */
2026     function processRebond(address _delegator, uint256 _unbondingLockId) internal {
2027         Delegator storage del = delegators[_delegator];
2028         UnbondingLock storage lock = del.unbondingLocks[_unbondingLockId];
2029 
2030         // Unbonding lock must be valid
2031         require(isValidUnbondingLock(_delegator, _unbondingLockId));
2032 
2033         uint256 amount = lock.amount;
2034         // Increase delegator's bonded amount
2035         del.bondedAmount = del.bondedAmount.add(amount);
2036         // Increase delegate's delegated amount
2037         delegators[del.delegateAddress].delegatedAmount = delegators[del.delegateAddress].delegatedAmount.add(amount);
2038 
2039         if (transcoderStatus(del.delegateAddress) == TranscoderStatus.Registered) {
2040             // If delegate is a registered transcoder increase its delegated stake in registered pool
2041             transcoderPool.updateKey(del.delegateAddress, transcoderTotalStake(del.delegateAddress).add(amount), address(0), address(0));
2042         }
2043 
2044         // Delete lock
2045         delete del.unbondingLocks[_unbondingLockId];
2046 
2047         Rebond(del.delegateAddress, _delegator, _unbondingLockId, amount);
2048     }
2049 
2050     /**
2051      * @dev Return LivepeerToken interface
2052      */
2053     function livepeerToken() internal view returns (ILivepeerToken) {
2054         return ILivepeerToken(controller.getContract(keccak256("LivepeerToken")));
2055     }
2056 
2057     /**
2058      * @dev Return Minter interface
2059      */
2060     function minter() internal view returns (IMinter) {
2061         return IMinter(controller.getContract(keccak256("Minter")));
2062     }
2063 
2064     /**
2065      * @dev Return RoundsManager interface
2066      */
2067     function roundsManager() internal view returns (IRoundsManager) {
2068         return IRoundsManager(controller.getContract(keccak256("RoundsManager")));
2069     }
2070 }