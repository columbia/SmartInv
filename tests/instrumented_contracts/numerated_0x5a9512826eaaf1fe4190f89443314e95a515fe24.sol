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
617 library EarningsPool {
618     using SafeMath for uint256;
619 
620     // Represents rewards and fees to be distributed to delegators
621     struct Data {
622         uint256 rewardPool;                // Rewards in the pool
623         uint256 feePool;                   // Fees in the pool
624         uint256 totalStake;                // Transcoder's total stake during the pool's round
625         uint256 claimableStake;            // Stake that can be used to claim portions of the fee and reward pool
626         uint256 transcoderRewardCut;       // Reward cut for the reward pool
627         uint256 transcoderFeeShare;        // Fee share for the fee pool
628     }
629 
630     function init(EarningsPool.Data storage earningsPool, uint256 _stake, uint256 _rewardCut, uint256 _feeShare) internal {
631         earningsPool.totalStake = _stake;
632         earningsPool.claimableStake = _stake;
633         earningsPool.transcoderRewardCut = _rewardCut;
634         earningsPool.transcoderFeeShare = _feeShare;
635     }
636 
637     function hasClaimableShares(EarningsPool.Data storage earningsPool) internal view returns (bool) {
638         return earningsPool.claimableStake > 0;
639     }
640 
641     function claimShare(EarningsPool.Data storage earningsPool, uint256 _stake, bool _isTranscoder) internal returns (uint256, uint256) {
642         uint256 fees = 0;
643         uint256 rewards = 0;
644 
645         if (earningsPool.feePool > 0) {
646             // Compute fee share
647             fees = feePoolShare(earningsPool, _stake, _isTranscoder);
648             earningsPool.feePool = earningsPool.feePool.sub(fees);
649         }
650 
651         if (earningsPool.rewardPool > 0) {
652             // Compute reward share
653             rewards = rewardPoolShare(earningsPool, _stake, _isTranscoder);
654             earningsPool.rewardPool = earningsPool.rewardPool.sub(rewards);
655         }
656 
657         // Update remaning claimable stake for token pools
658         earningsPool.claimableStake = earningsPool.claimableStake.sub(_stake);
659 
660         return (fees, rewards);
661     }
662 
663     function feePoolShare(EarningsPool.Data storage earningsPool, uint256 _stake, bool _isTranscoder) internal view returns (uint256) {
664         uint256 transcoderFees = 0;
665         uint256 delegatorFees = 0;
666 
667         if (earningsPool.claimableStake > 0) {
668             uint256 delegatorsFees = MathUtils.percOf(earningsPool.feePool, earningsPool.transcoderFeeShare);
669             transcoderFees = earningsPool.feePool.sub(delegatorsFees);
670             delegatorFees = MathUtils.percOf(delegatorsFees, _stake, earningsPool.claimableStake);
671         }
672 
673         if (_isTranscoder) {
674             return delegatorFees.add(transcoderFees);
675         } else {
676             return delegatorFees;
677         }
678     }
679 
680     function rewardPoolShare(EarningsPool.Data storage earningsPool, uint256 _stake, bool _isTranscoder) internal view returns (uint256) {
681         uint256 transcoderRewards = 0;
682         uint256 delegatorRewards = 0;
683 
684         if (earningsPool.claimableStake > 0) {
685             transcoderRewards = MathUtils.percOf(earningsPool.rewardPool, earningsPool.transcoderRewardCut);
686             delegatorRewards = MathUtils.percOf(earningsPool.rewardPool.sub(transcoderRewards), _stake, earningsPool.claimableStake);
687         }
688 
689         if (_isTranscoder) {
690             return delegatorRewards.add(transcoderRewards);
691         } else {
692             return delegatorRewards;
693         }
694     }
695 }
696 
697 contract ILivepeerToken is ERC20, Ownable {
698     function mint(address _to, uint256 _amount) public returns (bool);
699     function burn(uint256 _amount) public;
700 }
701 
702 /**
703  * @title Minter interface
704  */
705 contract IMinter {
706     // Events
707     event SetCurrentRewardTokens(uint256 currentMintableTokens, uint256 currentInflation);
708 
709     // External functions
710     function createReward(uint256 _fracNum, uint256 _fracDenom) external returns (uint256);
711     function trustedTransferTokens(address _to, uint256 _amount) external;
712     function trustedBurnTokens(uint256 _amount) external;
713     function trustedWithdrawETH(address _to, uint256 _amount) external;
714     function depositETH() external payable returns (bool);
715     function setCurrentRewardTokens() external;
716 
717     // Public functions
718     function getController() public view returns (IController);
719 }
720 
721 /**
722  * @title RoundsManager interface
723  */
724 contract IRoundsManager {
725     // Events
726     event NewRound(uint256 round);
727 
728     // External functions
729     function initializeRound() external;
730 
731     // Public functions
732     function blockNum() public view returns (uint256);
733     function blockHash(uint256 _block) public view returns (bytes32);
734     function currentRound() public view returns (uint256);
735     function currentRoundStartBlock() public view returns (uint256);
736     function currentRoundInitialized() public view returns (bool);
737     function currentRoundLocked() public view returns (bool);
738 }
739 
740 /*
741  * @title Interface for BondingManager
742  */
743 contract IBondingManager {
744     event TranscoderUpdate(address indexed transcoder, uint256 pendingRewardCut, uint256 pendingFeeShare, uint256 pendingPricePerSegment, bool registered);
745     event TranscoderEvicted(address indexed transcoder);
746     event TranscoderResigned(address indexed transcoder);
747     event TranscoderSlashed(address indexed transcoder, address finder, uint256 penalty, uint256 finderReward);
748     event Reward(address indexed transcoder, uint256 amount);
749     event Bond(address indexed delegate, address indexed delegator);
750     event Unbond(address indexed delegate, address indexed delegator);
751     event WithdrawStake(address indexed delegator);
752     event WithdrawFees(address indexed delegator);
753 
754     // External functions
755     function setActiveTranscoders() external;
756     function updateTranscoderWithFees(address _transcoder, uint256 _fees, uint256 _round) external;
757     function slashTranscoder(address _transcoder, address _finder, uint256 _slashAmount, uint256 _finderFee) external;
758     function electActiveTranscoder(uint256 _maxPricePerSegment, bytes32 _blockHash, uint256 _round) external view returns (address);
759 
760     // Public functions
761     function transcoderTotalStake(address _transcoder) public view returns (uint256);
762     function activeTranscoderTotalStake(address _transcoder, uint256 _round) public view returns (uint256);
763     function isRegisteredTranscoder(address _transcoder) public view returns (bool);
764     function getTotalBonded() public view returns (uint256);
765 }
766 
767 /**
768  * @title BondingManager
769  * @dev Manages bonding, transcoder and rewards/fee accounting related operations of the Livepeer protocol
770  */
771 contract BondingManager is ManagerProxyTarget, IBondingManager {
772     using SafeMath for uint256;
773     using SortedDoublyLL for SortedDoublyLL.Data;
774     using EarningsPool for EarningsPool.Data;
775 
776     // Time between unbonding and possible withdrawl in rounds
777     uint64 public unbondingPeriod;
778     // Number of active transcoders
779     uint256 public numActiveTranscoders;
780     // Max number of rounds that a caller can claim earnings for at once
781     uint256 public maxEarningsClaimsRounds;
782 
783     // Represents a transcoder's current state
784     struct Transcoder {
785         uint256 lastRewardRound;                             // Last round that the transcoder called reward
786         uint256 rewardCut;                                   // % of reward paid to transcoder by a delegator
787         uint256 feeShare;                                    // % of fees paid to delegators by transcoder
788         uint256 pricePerSegment;                             // Price per segment (denominated in LPT units) for a stream
789         uint256 pendingRewardCut;                            // Pending reward cut for next round if the transcoder is active
790         uint256 pendingFeeShare;                             // Pending fee share for next round if the transcoder is active
791         uint256 pendingPricePerSegment;                      // Pending price per segment for next round if the transcoder is active
792         mapping (uint256 => EarningsPool.Data) earningsPoolPerRound;  // Mapping of round => earnings pool for the round
793     }
794 
795     // The various states a transcoder can be in
796     enum TranscoderStatus { NotRegistered, Registered }
797 
798     // Represents a delegator's current state
799     struct Delegator {
800         uint256 bondedAmount;                    // The amount of bonded tokens
801         uint256 fees;                            // The amount of fees collected
802         address delegateAddress;                 // The address delegated to
803         uint256 delegatedAmount;                 // The amount of tokens delegated to the delegator
804         uint256 startRound;                      // The round the delegator transitions to bonded phase and is delegated to someone
805         uint256 withdrawRound;                   // The round at which a delegator can withdraw
806         uint256 lastClaimRound;                  // The last round during which the delegator claimed its earnings
807     }
808 
809     // The various states a delegator can be in
810     enum DelegatorStatus { Pending, Bonded, Unbonding, Unbonded }
811 
812     // Keep track of the known transcoders and delegators
813     mapping (address => Delegator) private delegators;
814     mapping (address => Transcoder) private transcoders;
815 
816     // Keep track of total bonded tokens
817     uint256 private totalBonded;
818 
819     // Candidate and reserve transcoders
820     SortedDoublyLL.Data private transcoderPool;
821 
822     // Represents the active transcoder set
823     struct ActiveTranscoderSet {
824         address[] transcoders;
825         mapping (address => bool) isActive;
826         uint256 totalStake;
827     }
828 
829     // Keep track of active transcoder set for each round
830     mapping (uint256 => ActiveTranscoderSet) public activeTranscoderSet;
831 
832     // Check if sender is JobsManager
833     modifier onlyJobsManager() {
834         require(msg.sender == controller.getContract(keccak256("JobsManager")));
835         _;
836     }
837 
838     // Check if sender is RoundsManager
839     modifier onlyRoundsManager() {
840         require(msg.sender == controller.getContract(keccak256("RoundsManager")));
841         _;
842     }
843 
844     // Check if current round is initialized
845     modifier currentRoundInitialized() {
846         require(roundsManager().currentRoundInitialized());
847         _;
848     }
849 
850     // Automatically claim earnings from lastClaimRound through the current round
851     modifier autoClaimEarnings() {
852         updateDelegatorWithEarnings(msg.sender, roundsManager().currentRound());
853         _;
854     }
855 
856     /**
857      * @dev BondingManager constructor. Only invokes constructor of base Manager contract with provided Controller address
858      * @param _controller Address of Controller that this contract will be registered with
859      */
860     function BondingManager(address _controller) public Manager(_controller) {}
861 
862     /**
863      * @dev Set unbonding period. Only callable by Controller owner
864      * @param _unbondingPeriod Rounds between unbonding and possible withdrawal
865      */
866     function setUnbondingPeriod(uint64 _unbondingPeriod) external onlyControllerOwner {
867         unbondingPeriod = _unbondingPeriod;
868 
869         ParameterUpdate("unbondingPeriod");
870     }
871 
872     /**
873      * @dev Set max number of registered transcoders. Only callable by Controller owner
874      * @param _numTranscoders Max number of registered transcoders
875      */
876     function setNumTranscoders(uint256 _numTranscoders) external onlyControllerOwner {
877         // Max number of transcoders must be greater than or equal to number of active transcoders
878         require(_numTranscoders >= numActiveTranscoders);
879 
880         transcoderPool.setMaxSize(_numTranscoders);
881 
882         ParameterUpdate("numTranscoders");
883     }
884 
885     /**
886      * @dev Set number of active transcoders. Only callable by Controller owner
887      * @param _numActiveTranscoders Number of active transcoders
888      */
889     function setNumActiveTranscoders(uint256 _numActiveTranscoders) external onlyControllerOwner {
890         // Number of active transcoders cannot exceed max number of transcoders
891         require(_numActiveTranscoders <= transcoderPool.getMaxSize());
892 
893         numActiveTranscoders = _numActiveTranscoders;
894 
895         ParameterUpdate("numActiveTranscoders");
896     }
897 
898     /**
899      * @dev Set max number of rounds a caller can claim earnings for at once. Only callable by Controller owner
900      * @param _maxEarningsClaimsRounds Max number of rounds a caller can claim earnings for at once
901      */
902     function setMaxEarningsClaimsRounds(uint256 _maxEarningsClaimsRounds) external onlyControllerOwner {
903         maxEarningsClaimsRounds = _maxEarningsClaimsRounds;
904 
905         ParameterUpdate("maxEarningsClaimsRounds");
906     }
907 
908     /**
909      * @dev The sender is declaring themselves as a candidate for active transcoding.
910      * @param _rewardCut % of reward paid to transcoder by a delegator
911      * @param _feeShare % of fees paid to delegators by a transcoder
912      * @param _pricePerSegment Price per segment (denominated in Wei) for a stream
913      */
914     function transcoder(uint256 _rewardCut, uint256 _feeShare, uint256 _pricePerSegment)
915         external
916         whenSystemNotPaused
917         currentRoundInitialized
918     {
919         Transcoder storage t = transcoders[msg.sender];
920         Delegator storage del = delegators[msg.sender];
921 
922         if (roundsManager().currentRoundLocked()) {
923             // If it is the lock period of the current round
924             // the lowest price previously set by any transcoder
925             // becomes the price floor and the caller can lower its
926             // own price to a point greater than or equal to the price floor
927 
928             // Caller must already be a registered transcoder
929             require(transcoderStatus(msg.sender) == TranscoderStatus.Registered);
930             // Provided rewardCut value must equal the current pendingRewardCut value
931             // This value cannot change during the lock period
932             require(_rewardCut == t.pendingRewardCut);
933             // Provided feeShare value must equal the current pendingFeeShare value
934             // This value cannot change during the lock period
935             require(_feeShare == t.pendingFeeShare);
936 
937             // Iterate through the transcoder pool to find the price floor
938             // Since the caller must be a registered transcoder, the transcoder pool size will always at least be 1
939             // Thus, we can safely set the initial price floor to be the pendingPricePerSegment of the first
940             // transcoder in the pool
941             address currentTranscoder = transcoderPool.getFirst();
942             uint256 priceFloor = transcoders[currentTranscoder].pendingPricePerSegment;
943             for (uint256 i = 0; i < transcoderPool.getSize(); i++) {
944                 if (transcoders[currentTranscoder].pendingPricePerSegment < priceFloor) {
945                     priceFloor = transcoders[currentTranscoder].pendingPricePerSegment;
946                 }
947 
948                 currentTranscoder = transcoderPool.getNext(currentTranscoder);
949             }
950 
951             // Provided pricePerSegment must be greater than or equal to the price floor and
952             // less than or equal to the previously set pricePerSegment by the caller
953             require(_pricePerSegment >= priceFloor && _pricePerSegment <= t.pendingPricePerSegment);
954 
955             t.pendingPricePerSegment = _pricePerSegment;
956 
957             TranscoderUpdate(msg.sender, t.pendingRewardCut, t.pendingFeeShare, _pricePerSegment, true);
958         } else {
959             // It is not the lock period of the current round
960             // Caller is free to change rewardCut, feeShare, pricePerSegment as it pleases
961             // If caller is not a registered transcoder, it can also register and join the transcoder pool
962             // if it has sufficient delegated stake
963             // If caller is not a registered transcoder and does not have sufficient delegated stake
964             // to join the transcoder pool, it can change rewardCut, feeShare, pricePerSegment
965             // as information signals to delegators in an effort to camapaign and accumulate
966             // more delegated stake
967 
968             // Reward cut must be a valid percentage
969             require(MathUtils.validPerc(_rewardCut));
970             // Fee share must be a valid percentage
971             require(MathUtils.validPerc(_feeShare));
972 
973             // Must have a non-zero amount bonded to self
974             require(del.delegateAddress == msg.sender && del.bondedAmount > 0);
975 
976             t.pendingRewardCut = _rewardCut;
977             t.pendingFeeShare = _feeShare;
978             t.pendingPricePerSegment = _pricePerSegment;
979 
980             uint256 delegatedAmount = del.delegatedAmount;
981 
982             // Check if transcoder is not already registered
983             if (transcoderStatus(msg.sender) == TranscoderStatus.NotRegistered) {
984                 if (!transcoderPool.isFull()) {
985                     // If pool is not full add new transcoder
986                     transcoderPool.insert(msg.sender, delegatedAmount, address(0), address(0));
987                 } else {
988                     address lastTranscoder = transcoderPool.getLast();
989 
990                     if (delegatedAmount > transcoderPool.getKey(lastTranscoder)) {
991                         // If pool is full and caller has more delegated stake than the transcoder in the pool with the least delegated stake:
992                         // - Evict transcoder in pool with least delegated stake
993                         // - Add caller to pool
994                         transcoderPool.remove(lastTranscoder);
995                         transcoderPool.insert(msg.sender, delegatedAmount, address(0), address(0));
996 
997                         TranscoderEvicted(lastTranscoder);
998                     }
999                 }
1000             }
1001 
1002             TranscoderUpdate(msg.sender, _rewardCut, _feeShare, _pricePerSegment, transcoderPool.contains(msg.sender));
1003         }
1004     }
1005 
1006     /**
1007      * @dev Delegate stake towards a specific address.
1008      * @param _amount The amount of LPT to stake.
1009      * @param _to The address of the transcoder to stake towards.
1010      */
1011     function bond(
1012         uint256 _amount,
1013         address _to
1014     )
1015         external
1016         whenSystemNotPaused
1017         currentRoundInitialized
1018         autoClaimEarnings
1019     {
1020         Delegator storage del = delegators[msg.sender];
1021 
1022         uint256 currentRound = roundsManager().currentRound();
1023         // Amount to delegate
1024         uint256 delegationAmount = _amount;
1025 
1026         if (delegatorStatus(msg.sender) == DelegatorStatus.Unbonded || delegatorStatus(msg.sender) == DelegatorStatus.Unbonding) {
1027             // New delegate
1028             // Set start round
1029             // Don't set start round if delegator is in pending state because the start round would not change
1030             del.startRound = currentRound.add(1);
1031             // If transitioning from unbonding or unbonded state
1032             // make sure to zero out withdraw round
1033             del.withdrawRound = 0;
1034             // Unbonded or unbonding state = no existing delegate
1035             // Thus, delegation amount = bonded stake + provided amount
1036             // If caller is bonding for the first time or withdrew previously bonded stake, delegation amount = provided amount
1037             delegationAmount = delegationAmount.add(del.bondedAmount);
1038         } else if (del.delegateAddress != address(0) && _to != del.delegateAddress) {
1039             // A registered transcoder cannot delegate its bonded stake toward another address
1040             // because it can only be delegated toward itself
1041             // In the future, if delegation towards another registered transcoder as an already
1042             // registered transcoder becomes useful (i.e. for transitive delegation), this restriction
1043             // could be removed
1044             require(transcoderStatus(msg.sender) == TranscoderStatus.NotRegistered);
1045             // Changing delegate
1046             // Set start round
1047             del.startRound = currentRound.add(1);
1048             // Update amount to delegate with previous delegation amount
1049             delegationAmount = delegationAmount.add(del.bondedAmount);
1050             // Decrease old delegate's delegated amount
1051             delegators[del.delegateAddress].delegatedAmount = delegators[del.delegateAddress].delegatedAmount.sub(del.bondedAmount);
1052 
1053             if (transcoderStatus(del.delegateAddress) == TranscoderStatus.Registered) {
1054                 // Previously delegated to a transcoder
1055                 // Decrease old transcoder's total stake
1056                 transcoderPool.updateKey(del.delegateAddress, transcoderPool.getKey(del.delegateAddress).sub(del.bondedAmount), address(0), address(0));
1057             }
1058         }
1059 
1060         // Delegation amount must be > 0 - cannot delegate to someone without having bonded stake
1061         require(delegationAmount > 0);
1062         // Update delegate
1063         del.delegateAddress = _to;
1064         // Update current delegate's delegated amount with delegation amount
1065         delegators[_to].delegatedAmount = delegators[_to].delegatedAmount.add(delegationAmount);
1066 
1067         if (transcoderStatus(_to) == TranscoderStatus.Registered) {
1068             // Delegated to a transcoder
1069             // Increase transcoder's total stake
1070             transcoderPool.updateKey(_to, transcoderPool.getKey(del.delegateAddress).add(delegationAmount), address(0), address(0));
1071         }
1072 
1073         if (_amount > 0) {
1074             // Update bonded amount
1075             del.bondedAmount = del.bondedAmount.add(_amount);
1076             // Update total bonded tokens
1077             totalBonded = totalBonded.add(_amount);
1078             // Transfer the LPT to the Minter
1079             livepeerToken().transferFrom(msg.sender, minter(), _amount);
1080         }
1081 
1082         Bond(_to, msg.sender);
1083     }
1084 
1085     /**
1086      * @dev Unbond delegator's current stake. Delegator enters unbonding state
1087      */
1088     function unbond()
1089         external
1090         whenSystemNotPaused
1091         currentRoundInitialized
1092         autoClaimEarnings
1093     {
1094         // Sender must be in bonded state
1095         require(delegatorStatus(msg.sender) == DelegatorStatus.Bonded);
1096 
1097         Delegator storage del = delegators[msg.sender];
1098 
1099         uint256 currentRound = roundsManager().currentRound();
1100 
1101         // Transition to unbonding phase
1102         del.withdrawRound = currentRound.add(unbondingPeriod);
1103         // Decrease delegate's delegated amount
1104         delegators[del.delegateAddress].delegatedAmount = delegators[del.delegateAddress].delegatedAmount.sub(del.bondedAmount);
1105         // Update total bonded tokens
1106         totalBonded = totalBonded.sub(del.bondedAmount);
1107 
1108         if (transcoderStatus(msg.sender) == TranscoderStatus.Registered) {
1109             // If caller is a registered transcoder, resign
1110             // In the future, with partial unbonding there would be a check for 0 bonded stake as well
1111             resignTranscoder(msg.sender);
1112         }
1113 
1114         if (del.delegateAddress != msg.sender && transcoderStatus(del.delegateAddress) == TranscoderStatus.Registered) {
1115             // If delegate is not self and is a registered transcoder, decrease its delegated stake
1116             // We do not need to decrease delegated stake if delegate is self because we would have already removed self
1117             // from the transcoder pool
1118             transcoderPool.updateKey(del.delegateAddress, transcoderPool.getKey(del.delegateAddress).sub(del.bondedAmount), address(0), address(0));
1119         }
1120 
1121         // Delegator no longer bonded to anyone
1122         del.delegateAddress = address(0);
1123         // Unbonding delegator does not have a start round
1124         del.startRound = 0;
1125 
1126         Unbond(del.delegateAddress, msg.sender);
1127     }
1128 
1129     /**
1130      * @dev Withdraws bonded stake to the caller after unbonding period.
1131      */
1132     function withdrawStake()
1133         external
1134         whenSystemNotPaused
1135         currentRoundInitialized
1136     {
1137         // Delegator must be in the unbonded state
1138         require(delegatorStatus(msg.sender) == DelegatorStatus.Unbonded);
1139 
1140         uint256 amount = delegators[msg.sender].bondedAmount;
1141         delegators[msg.sender].bondedAmount = 0;
1142         delegators[msg.sender].withdrawRound = 0;
1143 
1144         // Tell Minter to transfer stake (LPT) to the delegator
1145         minter().trustedTransferTokens(msg.sender, amount);
1146 
1147         WithdrawStake(msg.sender);
1148     }
1149 
1150     /**
1151      * @dev Withdraws fees to the caller
1152      */
1153     function withdrawFees()
1154         external
1155         whenSystemNotPaused
1156         currentRoundInitialized
1157         autoClaimEarnings
1158     {
1159         // Delegator must have fees
1160         require(delegators[msg.sender].fees > 0);
1161 
1162         uint256 amount = delegators[msg.sender].fees;
1163         delegators[msg.sender].fees = 0;
1164 
1165         // Tell Minter to transfer fees (ETH) to the delegator
1166         minter().trustedWithdrawETH(msg.sender, amount);
1167 
1168         WithdrawFees(msg.sender);
1169     }
1170 
1171     /**
1172      * @dev Set active transcoder set for the current round
1173      */
1174     function setActiveTranscoders() external whenSystemNotPaused onlyRoundsManager {
1175         uint256 currentRound = roundsManager().currentRound();
1176         uint256 activeSetSize = Math.min256(numActiveTranscoders, transcoderPool.getSize());
1177 
1178         uint256 totalStake = 0;
1179         address currentTranscoder = transcoderPool.getFirst();
1180 
1181         for (uint256 i = 0; i < activeSetSize; i++) {
1182             activeTranscoderSet[currentRound].transcoders.push(currentTranscoder);
1183             activeTranscoderSet[currentRound].isActive[currentTranscoder] = true;
1184 
1185             uint256 stake = transcoderPool.getKey(currentTranscoder);
1186             uint256 rewardCut = transcoders[currentTranscoder].pendingRewardCut;
1187             uint256 feeShare = transcoders[currentTranscoder].pendingFeeShare;
1188             uint256 pricePerSegment = transcoders[currentTranscoder].pendingPricePerSegment;
1189 
1190             Transcoder storage t = transcoders[currentTranscoder];
1191             // Set pending rates as current rates
1192             t.rewardCut = rewardCut;
1193             t.feeShare = feeShare;
1194             t.pricePerSegment = pricePerSegment;
1195             // Initialize token pool
1196             t.earningsPoolPerRound[currentRound].init(stake, rewardCut, feeShare);
1197 
1198             totalStake = totalStake.add(stake);
1199 
1200             // Get next transcoder in the pool
1201             currentTranscoder = transcoderPool.getNext(currentTranscoder);
1202         }
1203 
1204         // Update total stake of all active transcoders
1205         activeTranscoderSet[currentRound].totalStake = totalStake;
1206     }
1207 
1208     /**
1209      * @dev Distribute the token rewards to transcoder and delegates.
1210      * Active transcoders call this once per cycle when it is their turn.
1211      */
1212     function reward() external whenSystemNotPaused currentRoundInitialized {
1213         uint256 currentRound = roundsManager().currentRound();
1214 
1215         // Sender must be an active transcoder
1216         require(activeTranscoderSet[currentRound].isActive[msg.sender]);
1217 
1218         // Transcoder must not have called reward for this round already
1219         require(transcoders[msg.sender].lastRewardRound != currentRound);
1220         // Set last round that transcoder called reward
1221         transcoders[msg.sender].lastRewardRound = currentRound;
1222 
1223         // Create reward based on active transcoder's stake relative to the total active stake
1224         // rewardTokens = (current mintable tokens for the round * active transcoder stake) / total active stake
1225         uint256 rewardTokens = minter().createReward(activeTranscoderTotalStake(msg.sender, currentRound), activeTranscoderSet[currentRound].totalStake);
1226 
1227         updateTranscoderWithRewards(msg.sender, rewardTokens, currentRound);
1228 
1229         Reward(msg.sender, rewardTokens);
1230     }
1231 
1232     /**
1233      * @dev Update transcoder's fee pool
1234      * @param _transcoder Transcoder address
1235      * @param _fees Fees from verified job claims
1236      */
1237     function updateTranscoderWithFees(
1238         address _transcoder,
1239         uint256 _fees,
1240         uint256 _round
1241     )
1242         external
1243         whenSystemNotPaused
1244         onlyJobsManager
1245     {
1246         // Transcoder must be registered
1247         require(transcoderStatus(_transcoder) == TranscoderStatus.Registered);
1248 
1249         Transcoder storage t = transcoders[_transcoder];
1250 
1251         EarningsPool.Data storage earningsPool = t.earningsPoolPerRound[_round];
1252         // Add fees to fee pool
1253         earningsPool.feePool = earningsPool.feePool.add(_fees);
1254     }
1255 
1256     /**
1257      * @dev Slash a transcoder. Slashing can be invoked by the protocol or a finder.
1258      * @param _transcoder Transcoder address
1259      * @param _finder Finder that proved a transcoder violated a slashing condition. Null address if there is no finder
1260      * @param _slashAmount Percentage of transcoder bond to be slashed
1261      * @param _finderFee Percentage of penalty awarded to finder. Zero if there is no finder
1262      */
1263     function slashTranscoder(
1264         address _transcoder,
1265         address _finder,
1266         uint256 _slashAmount,
1267         uint256 _finderFee
1268     )
1269         external
1270         whenSystemNotPaused
1271         onlyJobsManager
1272     {
1273         Delegator storage del = delegators[_transcoder];
1274 
1275         if (del.bondedAmount > 0) {
1276             uint256 penalty = MathUtils.percOf(delegators[_transcoder].bondedAmount, _slashAmount);
1277 
1278             // Decrease bonded stake
1279             del.bondedAmount = del.bondedAmount.sub(penalty);
1280 
1281             // If still bonded
1282             // - Decrease delegate's delegated amount
1283             // - Decrease total bonded tokens
1284             if (delegatorStatus(_transcoder) == DelegatorStatus.Bonded) {
1285                 delegators[del.delegateAddress].delegatedAmount = delegators[del.delegateAddress].delegatedAmount.sub(penalty);
1286                 totalBonded = totalBonded.sub(penalty);
1287             }
1288 
1289             // If registered transcoder, resign it
1290             if (transcoderStatus(_transcoder) == TranscoderStatus.Registered) {
1291                 resignTranscoder(_transcoder);
1292             }
1293 
1294             // Account for penalty
1295             uint256 burnAmount = penalty;
1296 
1297             // Award finder fee if there is a finder address
1298             if (_finder != address(0)) {
1299                 uint256 finderAmount = MathUtils.percOf(penalty, _finderFee);
1300                 minter().trustedTransferTokens(_finder, finderAmount);
1301 
1302                 // Minter burns the slashed funds - finder reward
1303                 minter().trustedBurnTokens(burnAmount.sub(finderAmount));
1304 
1305                 TranscoderSlashed(_transcoder, _finder, penalty, finderAmount);
1306             } else {
1307                 // Minter burns the slashed funds
1308                 minter().trustedBurnTokens(burnAmount);
1309 
1310                 TranscoderSlashed(_transcoder, address(0), penalty, 0);
1311             }
1312         } else {
1313             TranscoderSlashed(_transcoder, _finder, 0, 0);
1314         }
1315     }
1316 
1317     /**
1318      * @dev Pseudorandomly elect a currently active transcoder that charges a price per segment less than or equal to the max price per segment for a job
1319      * Returns address of elected active transcoder and its price per segment
1320      * @param _maxPricePerSegment Max price (in LPT base units) per segment of a stream
1321      * @param _blockHash Job creation block hash used as a pseudorandom seed for assigning an active transcoder
1322      * @param _round Job creation round
1323      */
1324     function electActiveTranscoder(uint256 _maxPricePerSegment, bytes32 _blockHash, uint256 _round) external view returns (address) {
1325         uint256 activeSetSize = activeTranscoderSet[_round].transcoders.length;
1326         // Create array to store available transcoders charging an acceptable price per segment
1327         address[] memory availableTranscoders = new address[](activeSetSize);
1328         // Keep track of the actual number of available transcoders
1329         uint256 numAvailableTranscoders = 0;
1330         // Keep track of total stake of available transcoders
1331         uint256 totalAvailableTranscoderStake = 0;
1332 
1333         for (uint256 i = 0; i < activeSetSize; i++) {
1334             address activeTranscoder = activeTranscoderSet[_round].transcoders[i];
1335             // If a transcoder is active and charges an acceptable price per segment add it to the array of available transcoders
1336             if (activeTranscoderSet[_round].isActive[activeTranscoder] && transcoders[activeTranscoder].pricePerSegment <= _maxPricePerSegment) {
1337                 availableTranscoders[numAvailableTranscoders] = activeTranscoder;
1338                 numAvailableTranscoders++;
1339                 totalAvailableTranscoderStake = totalAvailableTranscoderStake.add(activeTranscoderTotalStake(activeTranscoder, _round));
1340             }
1341         }
1342 
1343         if (numAvailableTranscoders == 0) {
1344             // There is no currently available transcoder that charges a price per segment less than or equal to the max price per segment for a job
1345             return address(0);
1346         } else {
1347             // Pseudorandomly pick an available transcoder weighted by its stake relative to the total stake of all available transcoders
1348             uint256 r = uint256(_blockHash) % totalAvailableTranscoderStake;
1349             uint256 s = 0;
1350             uint256 j = 0;
1351 
1352             while (s <= r && j < numAvailableTranscoders) {
1353                 s = s.add(activeTranscoderTotalStake(availableTranscoders[j], _round));
1354                 j++;
1355             }
1356 
1357             return availableTranscoders[j - 1];
1358         }
1359     }
1360 
1361     /**
1362      * @dev Claim token pools shares for a delegator from its lastClaimRound through the end round
1363      * @param _endRound The last round for which to claim token pools shares for a delegator
1364      */
1365     function claimEarnings(uint256 _endRound) external whenSystemNotPaused currentRoundInitialized {
1366         // End round must be after the last claim round
1367         require(delegators[msg.sender].lastClaimRound < _endRound);
1368         // End round must not be after the current round
1369         require(_endRound <= roundsManager().currentRound());
1370 
1371         updateDelegatorWithEarnings(msg.sender, _endRound);
1372     }
1373 
1374     /**
1375      * @dev Returns pending bonded stake for a delegator from its lastClaimRound through an end round
1376      * @param _delegator Address of delegator
1377      * @param _endRound The last round to compute pending stake from
1378      */
1379     function pendingStake(address _delegator, uint256 _endRound) public view returns (uint256) {
1380         uint256 currentRound = roundsManager().currentRound();
1381         Delegator storage del = delegators[_delegator];
1382         // End round must be before or equal to current round and after lastClaimRound
1383         require(_endRound <= currentRound && _endRound > del.lastClaimRound);
1384 
1385         uint256 currentBondedAmount = del.bondedAmount;
1386 
1387         for (uint256 i = del.lastClaimRound + 1; i <= _endRound; i++) {
1388             EarningsPool.Data storage earningsPool = transcoders[del.delegateAddress].earningsPoolPerRound[i];
1389 
1390             bool isTranscoder = _delegator == del.delegateAddress;
1391             if (earningsPool.hasClaimableShares()) {
1392                 // Calculate and add reward pool share from this round
1393                 currentBondedAmount = currentBondedAmount.add(earningsPool.rewardPoolShare(currentBondedAmount, isTranscoder));
1394             }
1395         }
1396 
1397         return currentBondedAmount;
1398     }
1399 
1400     /**
1401      * @dev Returns pending fees for a delegator from its lastClaimRound through an end round
1402      * @param _delegator Address of delegator
1403      * @param _endRound The last round to compute pending fees from
1404      */
1405     function pendingFees(address _delegator, uint256 _endRound) public view returns (uint256) {
1406         uint256 currentRound = roundsManager().currentRound();
1407         Delegator storage del = delegators[_delegator];
1408         // End round must be before or equal to current round and after lastClaimRound
1409         require(_endRound <= currentRound && _endRound > del.lastClaimRound);
1410 
1411         uint256 currentFees = del.fees;
1412         uint256 currentBondedAmount = del.bondedAmount;
1413 
1414         for (uint256 i = del.lastClaimRound + 1; i <= _endRound; i++) {
1415             EarningsPool.Data storage earningsPool = transcoders[del.delegateAddress].earningsPoolPerRound[i];
1416 
1417             if (earningsPool.hasClaimableShares()) {
1418                 bool isTranscoder = _delegator == del.delegateAddress;
1419                 // Calculate and add fee pool share from this round
1420                 currentFees = currentFees.add(earningsPool.feePoolShare(currentBondedAmount, isTranscoder));
1421                 // Calculate new bonded amount with rewards from this round. Updated bonded amount used
1422                 // to calculate fee pool share in next round
1423                 currentBondedAmount = currentBondedAmount.add(earningsPool.rewardPoolShare(currentBondedAmount, isTranscoder));
1424             }
1425         }
1426 
1427         return currentFees;
1428     }
1429 
1430     /**
1431      * @dev Returns total bonded stake for an active transcoder
1432      * @param _transcoder Address of a transcoder
1433      */
1434     function activeTranscoderTotalStake(address _transcoder, uint256 _round) public view returns (uint256) {
1435         // Must be active transcoder
1436         require(activeTranscoderSet[_round].isActive[_transcoder]);
1437 
1438         return transcoders[_transcoder].earningsPoolPerRound[_round].totalStake;
1439     }
1440 
1441     /**
1442      * @dev Returns total bonded stake for a transcoder
1443      * @param _transcoder Address of transcoder
1444      */
1445     function transcoderTotalStake(address _transcoder) public view returns (uint256) {
1446         return transcoderPool.getKey(_transcoder);
1447     }
1448 
1449     /*
1450      * @dev Computes transcoder status
1451      * @param _transcoder Address of transcoder
1452      */
1453     function transcoderStatus(address _transcoder) public view returns (TranscoderStatus) {
1454         if (transcoderPool.contains(_transcoder)) {
1455             return TranscoderStatus.Registered;
1456         } else {
1457             return TranscoderStatus.NotRegistered;
1458         }
1459     }
1460 
1461     /**
1462      * @dev Computes delegator status
1463      * @param _delegator Address of delegator
1464      */
1465     function delegatorStatus(address _delegator) public view returns (DelegatorStatus) {
1466         Delegator storage del = delegators[_delegator];
1467 
1468         if (del.withdrawRound > 0) {
1469             // Delegator called unbond
1470             if (roundsManager().currentRound() >= del.withdrawRound) {
1471                 return DelegatorStatus.Unbonded;
1472             } else {
1473                 return DelegatorStatus.Unbonding;
1474             }
1475         } else if (del.startRound > roundsManager().currentRound()) {
1476             // Delegator round start is in the future
1477             return DelegatorStatus.Pending;
1478         } else if (del.startRound > 0 && del.startRound <= roundsManager().currentRound()) {
1479             // Delegator round start is now or in the past
1480             return DelegatorStatus.Bonded;
1481         } else {
1482             // Default to unbonded
1483             return DelegatorStatus.Unbonded;
1484         }
1485     }
1486 
1487     /**
1488      * @dev Return transcoder information
1489      * @param _transcoder Address of transcoder
1490      */
1491     function getTranscoder(
1492         address _transcoder
1493     )
1494         public
1495         view
1496         returns (uint256 lastRewardRound, uint256 rewardCut, uint256 feeShare, uint256 pricePerSegment, uint256 pendingRewardCut, uint256 pendingFeeShare, uint256 pendingPricePerSegment)
1497     {
1498         Transcoder storage t = transcoders[_transcoder];
1499 
1500         lastRewardRound = t.lastRewardRound;
1501         rewardCut = t.rewardCut;
1502         feeShare = t.feeShare;
1503         pricePerSegment = t.pricePerSegment;
1504         pendingRewardCut = t.pendingRewardCut;
1505         pendingFeeShare = t.pendingFeeShare;
1506         pendingPricePerSegment = t.pendingPricePerSegment;
1507     }
1508 
1509     /**
1510      * @dev Return transcoder's token pools for a given round
1511      * @param _transcoder Address of transcoder
1512      * @param _round Round number
1513      */
1514     function getTranscoderEarningsPoolForRound(
1515         address _transcoder,
1516         uint256 _round
1517     )
1518         public
1519         view
1520         returns (uint256 rewardPool, uint256 feePool, uint256 totalStake, uint256 claimableStake)
1521     {
1522         EarningsPool.Data storage earningsPool = transcoders[_transcoder].earningsPoolPerRound[_round];
1523 
1524         rewardPool = earningsPool.rewardPool;
1525         feePool = earningsPool.feePool;
1526         totalStake = earningsPool.totalStake;
1527         claimableStake = earningsPool.claimableStake;
1528     }
1529 
1530     /**
1531      * @dev Return delegator info
1532      * @param _delegator Address of delegator
1533      */
1534     function getDelegator(
1535         address _delegator
1536     )
1537         public
1538         view
1539         returns (uint256 bondedAmount, uint256 fees, address delegateAddress, uint256 delegatedAmount, uint256 startRound, uint256 withdrawRound, uint256 lastClaimRound)
1540     {
1541         Delegator storage del = delegators[_delegator];
1542 
1543         bondedAmount = del.bondedAmount;
1544         fees = del.fees;
1545         delegateAddress = del.delegateAddress;
1546         delegatedAmount = del.delegatedAmount;
1547         startRound = del.startRound;
1548         withdrawRound = del.withdrawRound;
1549         lastClaimRound = del.lastClaimRound;
1550     }
1551 
1552     /**
1553      * @dev Returns max size of transcoder pool
1554      */
1555     function getTranscoderPoolMaxSize() public view returns (uint256) {
1556         return transcoderPool.getMaxSize();
1557     }
1558 
1559     /**
1560      * @dev Returns size of transcoder pool
1561      */
1562     function getTranscoderPoolSize() public view returns (uint256) {
1563         return transcoderPool.getSize();
1564     }
1565 
1566     /**
1567      * @dev Returns transcoder with most stake in pool
1568      */
1569     function getFirstTranscoderInPool() public view returns (address) {
1570         return transcoderPool.getFirst();
1571     }
1572 
1573     /**
1574      * @dev Returns next transcoder in pool for a given transcoder
1575      * @param _transcoder Address of a transcoder in the pool
1576      */
1577     function getNextTranscoderInPool(address _transcoder) public view returns (address) {
1578         return transcoderPool.getNext(_transcoder);
1579     }
1580 
1581     /**
1582      * @dev Return total bonded tokens
1583      */
1584     function getTotalBonded() public view returns (uint256) {
1585         return totalBonded;
1586     }
1587 
1588     /**
1589      * @dev Return total active stake for a round
1590      * @param _round Round number
1591      */
1592     function getTotalActiveStake(uint256 _round) public view returns (uint256) {
1593         return activeTranscoderSet[_round].totalStake;
1594     }
1595 
1596     /**
1597      * @dev Return whether a transcoder was active during a round
1598      * @param _transcoder Transcoder address
1599      * @param _round Round number
1600      */
1601     function isActiveTranscoder(address _transcoder, uint256 _round) public view returns (bool) {
1602         return activeTranscoderSet[_round].isActive[_transcoder];
1603     }
1604 
1605     /**
1606      * @dev Return whether a transcoder is registered
1607      * @param _transcoder Transcoder address
1608      */
1609     function isRegisteredTranscoder(address _transcoder) public view returns (bool) {
1610         return transcoderStatus(_transcoder) == TranscoderStatus.Registered;
1611     }
1612 
1613     /**
1614      * @dev Remove transcoder
1615      */
1616     function resignTranscoder(address _transcoder) internal {
1617         uint256 currentRound = roundsManager().currentRound();
1618         if (activeTranscoderSet[currentRound].isActive[_transcoder]) {
1619             // Decrease total active stake for the round
1620             activeTranscoderSet[currentRound].totalStake = activeTranscoderSet[currentRound].totalStake.sub(activeTranscoderTotalStake(_transcoder, currentRound));
1621             // Set transcoder as inactive
1622             activeTranscoderSet[currentRound].isActive[_transcoder] = false;
1623         }
1624 
1625         // Remove transcoder from pools
1626         transcoderPool.remove(_transcoder);
1627 
1628         TranscoderResigned(_transcoder);
1629     }
1630 
1631     /**
1632      * @dev Update a transcoder with rewards
1633      * @param _transcoder Address of transcoder
1634      * @param _rewards Amount of rewards
1635      * @param _round Round that transcoder is updated
1636      */
1637     function updateTranscoderWithRewards(address _transcoder, uint256 _rewards, uint256 _round) internal {
1638         Transcoder storage t = transcoders[_transcoder];
1639         Delegator storage del = delegators[_transcoder];
1640 
1641         EarningsPool.Data storage earningsPool = t.earningsPoolPerRound[_round];
1642         // Add rewards to reward pool
1643         earningsPool.rewardPool = earningsPool.rewardPool.add(_rewards);
1644         // Update transcoder's delegated amount with rewards
1645         del.delegatedAmount = del.delegatedAmount.add(_rewards);
1646         // Update transcoder's total stake with rewards
1647         uint256 newStake = transcoderPool.getKey(_transcoder).add(_rewards);
1648         transcoderPool.updateKey(_transcoder, newStake, address(0), address(0));
1649         // Update total bonded tokens with claimable rewards
1650         totalBonded = totalBonded.add(_rewards);
1651     }
1652 
1653     /**
1654      * @dev Update a delegator with token pools shares from its lastClaimRound through a given round
1655      * @param _delegator Delegator address
1656      * @param _endRound The last round for which to update a delegator's stake with token pools shares
1657      */
1658     function updateDelegatorWithEarnings(address _delegator, uint256 _endRound) internal {
1659         Delegator storage del = delegators[_delegator];
1660 
1661         // Only will have earnings to claim if you have a delegate
1662         // If not delegated, skip the earnings claim process
1663         if (del.delegateAddress != address(0)) {
1664             // Cannot claim earnings for more than maxEarningsClaimsRounds
1665             // This is a number to cause transactions to fail early if
1666             // we know they will require too much gas to loop through all the necessary rounds to claim earnings
1667             // The user should instead manually invoke `claimEarnings` to split up the claiming process
1668             // across multiple transactions
1669             require(_endRound.sub(del.lastClaimRound) <= maxEarningsClaimsRounds);
1670 
1671             uint256 currentBondedAmount = del.bondedAmount;
1672             uint256 currentFees = del.fees;
1673 
1674             for (uint256 i = del.lastClaimRound + 1; i <= _endRound; i++) {
1675                 EarningsPool.Data storage earningsPool = transcoders[del.delegateAddress].earningsPoolPerRound[i];
1676 
1677                 if (earningsPool.hasClaimableShares()) {
1678                     bool isTranscoder = _delegator == del.delegateAddress;
1679 
1680                     var (fees, rewards) = earningsPool.claimShare(currentBondedAmount, isTranscoder);
1681 
1682                     currentFees = currentFees.add(fees);
1683                     currentBondedAmount = currentBondedAmount.add(rewards);
1684                 }
1685             }
1686 
1687             // Rewards are bonded by default
1688             del.bondedAmount = currentBondedAmount;
1689             del.fees = currentFees;
1690         }
1691 
1692         del.lastClaimRound = _endRound;
1693     }
1694 
1695     /**
1696      * @dev Return LivepeerToken interface
1697      */
1698     function livepeerToken() internal view returns (ILivepeerToken) {
1699         return ILivepeerToken(controller.getContract(keccak256("LivepeerToken")));
1700     }
1701 
1702     /**
1703      * @dev Return Minter interface
1704      */
1705     function minter() internal view returns (IMinter) {
1706         return IMinter(controller.getContract(keccak256("Minter")));
1707     }
1708 
1709     /**
1710      * @dev Return RoundsManager interface
1711      */
1712     function roundsManager() internal view returns (IRoundsManager) {
1713         return IRoundsManager(controller.getContract(keccak256("RoundsManager")));
1714     }
1715 }