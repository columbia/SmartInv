1 pragma solidity 0.4.25;
2 
3 // * Samurai Quest - Levelling game that pay ether. Version 1.
4 // 
5 // * Developer     - Studio California
6 //                   "You can check out any time you like, but you can never leave"
7 //
8 // * Uses Linked List to store player level
9 //
10 // * Refer to https://samurai-quest.hostedwiki.co/ for detailed description.
11 
12 contract SamuraiQuest {
13 
14     using SafeMath for uint256;
15     using LinkedListLib for LinkedListLib.LinkedList;
16 
17     // ***Event Section
18     event NewSamuraiIncoming(uint256 id, bytes32 name);
19     event TheLastSamuraiBorn(uint256 id, bytes32 name, uint256 winning);
20     event Retreat(uint256 id, bytes32 name, uint256 balance);
21 
22     address public owner;
23 
24     uint256 public currentSamuraiId;
25     uint256 public totalProcessingFee;
26     uint256 public theLastSamuraiPot;
27     uint256 public theLastSamuraiEndTime;
28 
29     // ***Constant Section
30     uint256 private constant MAX_LEVEL = 8;
31     uint256 private constant JOINING_FEE = 0.03 ether;
32     uint256 private constant PROCESSING_FEE = 0.001 ether;
33     uint256 private constant REFERRAL_FEE = 0.002 ether;
34     uint256 private constant THE_LAST_SAMURAI_FEE = 0.002 ether;
35     uint256 private constant THE_LAST_SAMURAI_COOLDOWN = 1 days;
36 
37     struct Samurai {
38         uint256 level;
39         uint256 supporterWallet;
40         uint256 referralWallet;
41         uint256 theLastSamuraiWallet;
42         bytes32 name;
43         address addr;
44         bool isRetreat;
45         bool autoLevelUp;
46     }
47 
48     mapping (address => uint256) public addressToId;
49     mapping (uint256 => Samurai) public idToSamurai;
50     mapping (uint256 => uint256) public idToSamuraiHeadId;
51     mapping (uint256 => uint256) public idToAffiliateId;
52     mapping (uint256 => uint256) public supporterCount;
53     mapping (uint256 => uint256) public referralCount;
54     
55     mapping (uint256 => LinkedListLib.LinkedList) private levelChain; // level up chain
56     uint256[9] public levelUpFee; // level up fees
57 
58     // Constructor. Deliberately does not take any parameters.
59     constructor() public {
60         // Set the contract owner
61         owner = msg.sender;
62 
63         totalProcessingFee = 0;
64         theLastSamuraiPot = 0;
65         currentSamuraiId = 1;
66         
67         // Level up fee
68         levelUpFee[1] = 0.02 ether; // 0 > 1
69         levelUpFee[2] = 0.04 ether; // 1 > 2
70         levelUpFee[3] = 0.08 ether; // 2 > 3
71         levelUpFee[4] = 0.16 ether; // 3 > 4
72         levelUpFee[5] = 0.32 ether; // 4 > 5
73         levelUpFee[6] = 0.64 ether; // 5 > 6
74         levelUpFee[7] = 1.28 ether; // 6 > 7
75         levelUpFee[8] = 2.56 ether; // 7 > 8
76     }
77 
78     modifier onlyOwner() {
79         require(msg.sender == owner, "OnlyOwner method called by non owner");
80         _;
81     }
82 
83     // Fund withdrawal to cover costs of operation
84     function withdrawProcessingFee() public onlyOwner {
85         require(totalProcessingFee <= address(this).balance, "not enough fund");
86     
87         uint256 amount = totalProcessingFee;
88 
89         totalProcessingFee = 0;
90 
91         owner.transfer(amount);
92     }
93 
94     // Fallback function deliberately left empty.
95     function () public payable { }
96 
97     /// *** join Logic
98 
99     // Set the samurai info and level to 0, then level up it
100     // _name        - Name of the samurai
101     // _affiliateId - Affiliate Id, affiliate will get 0.002ETH of each action
102     //                performed by it's referral
103     // _autoLevelUp - Let player control the level up type
104     function join(bytes32 _name, uint256 _affiliateId, bool _autoLevelUp) public payable {
105         require(msg.value == JOINING_FEE, "you have no enough courage");
106         require(addressToId[msg.sender] == 0, "you're already in");
107         require(_affiliateId >= 0 && _affiliateId < currentSamuraiId, "invalid affiliate");
108 
109         Samurai storage samurai = idToSamurai[currentSamuraiId];
110         
111         samurai.level = 0;
112         samurai.addr = msg.sender;
113         samurai.referralWallet = 0;
114         samurai.theLastSamuraiWallet = 0;
115         samurai.name = _name;
116         samurai.isRetreat = false;
117         samurai.autoLevelUp = _autoLevelUp;
118         samurai.supporterWallet = JOINING_FEE;
119 
120         addressToId[msg.sender] = currentSamuraiId;
121 
122         if (_affiliateId > 0) {
123             idToAffiliateId[currentSamuraiId] = _affiliateId;
124             referralCount[_affiliateId] = referralCount[_affiliateId].add(1);
125         }
126 
127         levelUp(currentSamuraiId);
128 
129         emit NewSamuraiIncoming(currentSamuraiId, samurai.name);
130 
131         // Increase the count for next samurai
132         currentSamuraiId = currentSamuraiId.add(1);
133         theLastSamuraiEndTime = now.add(THE_LAST_SAMURAI_COOLDOWN);
134     }
135 
136     /// *** levelUp Logic
137 
138     // Level up the samurai, push it to the next level chain
139     // Help checking the last samurai pot
140     // Distribute the fund to corresponding accounts
141     // Help levelling up the head of samurai 
142     // _samuraiId - Id of the samurai to be levelled up
143     function levelUp(uint256 _samuraiId) public {
144         bool exist;
145         uint256 samuraiHeadId;
146         Samurai storage samurai = idToSamurai[_samuraiId];
147         
148         require(canLevelUp(_samuraiId), "cannot level up");
149 
150         uint256 balance = samurai.supporterWallet.add(samurai.referralWallet).add(samurai.theLastSamuraiWallet);
151 
152         require(
153             balance >= levelUpFee[samurai.level.add(1)].add(PROCESSING_FEE).add(THE_LAST_SAMURAI_FEE).add(REFERRAL_FEE),
154             "not enough fund to level up"
155         );
156 
157         // level up
158         samurai.level = samurai.level.add(1);
159 
160         // help checking the last samurai pot
161         distributeTheLastSamuraiPot();
162 
163         // push the samurai Id to the corresponding level chain
164         push(levelChain[samurai.level], _samuraiId);
165         supporterCount[_samuraiId] = 0;
166 
167         // Check if head exist, and get it's Id
168         (exist, samuraiHeadId) = levelChain[samurai.level].getAdjacent(0, true);
169         
170         // Distribute 0.001 ETH to poor developer
171         samurai.supporterWallet = samurai.supporterWallet.sub(PROCESSING_FEE);
172         totalProcessingFee = totalProcessingFee.add(PROCESSING_FEE);
173 
174         // Distribute 0.002 ETH to the last samurai pot
175         samurai.supporterWallet = samurai.supporterWallet.sub(THE_LAST_SAMURAI_FEE);
176         theLastSamuraiPot = theLastSamuraiPot.add(THE_LAST_SAMURAI_FEE);
177         
178         // Distribute 0.002 ETH to affiliate/the last samurai pot
179         uint256 affiliateId = idToAffiliateId[_samuraiId];
180 
181         samurai.supporterWallet = samurai.supporterWallet.sub(REFERRAL_FEE);
182         if (affiliateId == 0) {
183             theLastSamuraiPot = theLastSamuraiPot.add(REFERRAL_FEE);
184         } else {
185             Samurai storage affiliate = idToSamurai[affiliateId];
186             affiliate.referralWallet = affiliate.referralWallet.add(REFERRAL_FEE);
187         }
188 
189         // check if samuraiHead exist and it should not be Samurai itself
190         if (exist && samuraiHeadId != _samuraiId) {
191             Samurai storage samuraiHead = idToSamurai[samuraiHeadId];
192 
193             // Distribute the level up fee to samuraiHead
194             samurai.supporterWallet = samurai.supporterWallet.sub(levelUpFee[samurai.level]);
195             samuraiHead.supporterWallet = samuraiHead.supporterWallet.add(levelUpFee[samurai.level]);
196 
197             // Map the samuraiId to samuraiHead struct
198             idToSamuraiHeadId[_samuraiId] = samuraiHeadId;
199 
200             // Add up the supporter count of samuraiHead
201             supporterCount[samuraiHeadId] = supporterCount[samuraiHeadId].add(1);
202 
203             // nested loop to level up samuraiHead
204             if(canLevelUp(samuraiHeadId)) {
205                 // pop the samurai headoff the leve chain
206                 pop(levelChain[samuraiHead.level]);
207                 
208                 if(samuraiHead.autoLevelUp) {
209                     levelUp(samuraiHeadId);
210                 } else {
211                     return;
212                 }
213             } else {
214                 return;
215             }
216         }
217     }
218     
219     /// *** retreat Logic
220     
221     // Retreat the samurai, pop it off the level chain
222     // Help checking the last samurai pot
223     // Distribute the fund to corresponding accounts
224     // _samuraiId - Id of the samurai to be retreat
225     function retreat(uint256 _samuraiId) public {
226         Samurai storage samurai = idToSamurai[_samuraiId];
227 
228         require(!samurai.isRetreat, "you've already quit!");
229         require(samurai.addr == msg.sender, "you must be a yokai spy!");
230 
231         uint256 balance = samurai.supporterWallet.add(samurai.referralWallet).add(samurai.theLastSamuraiWallet);
232 
233         require(balance >= 0.005 ether, "fee is required, even when retreating");
234 
235         // Clear the balance, prevent re-entrancy
236         samurai.supporterWallet = 0;
237         samurai.theLastSamuraiWallet = 0;
238         samurai.referralWallet = 0;
239 
240         // pop the player off the level chain and mark the retreat flag
241         remove(levelChain[samurai.level], _samuraiId);
242         samurai.isRetreat = true;
243         
244         // Transfer the processing fee to poor developer
245         balance = balance.sub(PROCESSING_FEE);
246         totalProcessingFee = totalProcessingFee.add(PROCESSING_FEE);
247 
248         balance = balance.sub(THE_LAST_SAMURAI_FEE);
249         theLastSamuraiPot = theLastSamuraiPot.add(THE_LAST_SAMURAI_FEE);
250 
251         balance = balance.sub(REFERRAL_FEE);
252 
253         uint256 affiliateId = idToAffiliateId[_samuraiId];
254 
255         // No affiliate, distribute the referral fee to the last samurai pot
256         if (affiliateId == 0) {
257             theLastSamuraiPot = theLastSamuraiPot.add(REFERRAL_FEE);
258         } else {
259             Samurai storage affiliate = idToSamurai[affiliateId];
260             affiliate.referralWallet = affiliate.referralWallet.add(REFERRAL_FEE);
261         }
262 
263         // transfer balance to account holder
264         samurai.addr.transfer(balance);
265 
266         // help checking the last samurai pot
267         distributeTheLastSamuraiPot();
268 
269         emit Retreat(_samuraiId, samurai.name, balance);
270     }
271 
272     /// *** withdraw Logic
273     
274     // Withdraw the left over fund in wallet after retreat
275     // _samuraiId - Id of the samurai
276     function withdraw(uint256 _samuraiId) public {
277         Samurai storage samurai = idToSamurai[_samuraiId];
278 
279         require(samurai.addr == msg.sender, "you must be a yokai spy!");
280 
281         uint256 balance = samurai.supporterWallet.add(samurai.referralWallet).add(samurai.theLastSamuraiWallet);
282 
283         require(balance <= address(this).balance, "not enough fund");
284 
285         // Prevent re-entrancy
286         samurai.supporterWallet = 0;
287         samurai.theLastSamuraiWallet = 0;
288         samurai.referralWallet = 0;
289 
290         // transfer balance to account holder
291         samurai.addr.transfer(balance);
292     }
293 
294     /// *** distributeTheLastSamuraiPot Logic
295     
296     // Distribute the last samurai pot to winner when no joining after 24 hours
297     // Distribute the fund to corresponding accounts
298     // _samuraiId - Id of the samurai to be retreat
299     function distributeTheLastSamuraiPot() public {
300         require(theLastSamuraiPot <= address(this).balance, "not enough fund");
301 
302         // When the remaining time is over
303         if (theLastSamuraiEndTime <= now) {
304             uint256 samuraiId = currentSamuraiId.sub(1);
305             Samurai storage samurai = idToSamurai[samuraiId];
306 
307             uint256 total = theLastSamuraiPot;
308             
309             // again, prevent re-entrancy
310             theLastSamuraiPot = 0;
311             samurai.theLastSamuraiWallet = samurai.theLastSamuraiWallet.add(total);
312 
313             emit TheLastSamuraiBorn(samuraiId, samurai.name, total);
314         }
315     }
316 
317     /// *** toggleAutoLevelUp Logic
318     
319     // Toggle auto level up, for those who don't intend to play longer,
320     // can set the auto level up to false
321     // _samuraiId - Id of the samurai
322     function toggleAutoLevelUp(uint256 _samuraiId) public {
323         Samurai storage samurai = idToSamurai[_samuraiId];
324 
325         require(!samurai.isRetreat, "you've already quit!");
326         require(msg.sender == samurai.addr, "you must be a yokai spy");
327 
328         samurai.autoLevelUp = !samurai.autoLevelUp;
329     }
330 
331     //*** For UI
332 
333     // Returns - Id
334     function getSamuraiId() public view returns(uint256) {
335         return addressToId[msg.sender];
336     }
337 
338     // Returns - 0: id, 1: level, 2: name, 3: isRetreat, 4: autoLevelUp, 5: isHead
339     function getSamuraiInfo(uint256 _samuraiId) public view
340         returns(uint256, uint256, bytes32, bool, bool, bool)
341     {
342         Samurai memory samurai = idToSamurai[_samuraiId];
343         bool isHead = isHeadOfSamurai(_samuraiId);
344         
345         return (_samuraiId, samurai.level, samurai.name, samurai.isRetreat, samurai.autoLevelUp, isHead);
346     }
347 
348     // Returns - 0: supperterWallet, 1: theLastSamuraiWallet, 2: referralWallet
349     function getSamuraiWallet(uint256 _samuraiId) public view
350         returns(uint256, uint256, uint256)
351     {
352         Samurai memory samurai = idToSamurai[_samuraiId];
353 
354         return (samurai.supporterWallet, samurai.theLastSamuraiWallet, samurai.referralWallet);
355     }
356     
357     // Returns - 0: affiliateId, 1: affiliateName
358     function getAffiliateInfo(uint256 _samuraiId) public view returns(uint256, bytes32) {
359         uint256 affiliateId = idToAffiliateId[_samuraiId];
360         Samurai memory affiliate = idToSamurai[affiliateId];
361 
362         return (affiliateId, affiliate.name);
363     }
364 
365     // Returns - 0: samuraiHeadId, 1: samuraiHeadName
366     function contributeTo(uint256 _samuraiId) public view returns(uint256, bytes32) {
367         uint256 samuraiHeadId = idToSamuraiHeadId[_samuraiId];
368         Samurai memory samuraiHead = idToSamurai[samuraiHeadId];
369 
370         return (samuraiHeadId, samuraiHead.name);
371     }
372 
373     // Returns - 0: theLastSamuraiEndTime, 1: theLastSamuraiPot, 2: lastSamuraiId, 3: lastSamuraiName
374     function getTheLastSamuraiInfo() public view returns(uint256, uint256, uint256, bytes32) {
375         uint256 lastSamuraiId = currentSamuraiId.sub(1);
376 
377         return (theLastSamuraiEndTime, theLastSamuraiPot, lastSamuraiId, idToSamurai[lastSamuraiId].name);
378     }
379     
380     // Returns - canLevelUp
381     function canLevelUp(uint256 _id) public view returns(bool) {
382         Samurai memory samurai = idToSamurai[_id];
383         
384         return !samurai.isRetreat && (samurai.level == 0 || (supporterCount[_id] == 2 ** samurai.level && samurai.level <= MAX_LEVEL));
385     }
386 
387     // Returns - canRetreat
388     function canRetreat(uint256 _id) public view returns(bool) {
389         Samurai memory samurai = idToSamurai[_id];
390         uint256 balance = samurai.supporterWallet.add(samurai.referralWallet).add(samurai.theLastSamuraiWallet);
391 
392         return !samurai.isRetreat && (balance >= 0.005 ether);
393     }
394 
395     // Returns - canWithdraw
396     function canWithdraw(uint256 _id) public view returns(bool) {
397         Samurai memory samurai = idToSamurai[_id];
398         uint256 balance = samurai.supporterWallet.add(samurai.referralWallet).add(samurai.theLastSamuraiWallet);
399 
400         return samurai.isRetreat && (balance > 0);
401     }
402 
403     // Returns - isHeadOfSamurai
404     function isHeadOfSamurai(uint256 _id) public view returns(bool) {
405         Samurai memory samurai = idToSamurai[_id];
406         bool exist;
407         uint256 samuraiHeadId;
408 
409         (exist, samuraiHeadId) = levelChain[samurai.level].getAdjacent(0, true);
410 
411         return (exist && samuraiHeadId == _id);
412     }
413     
414     // For linked list manipulation
415     function push(LinkedListLib.LinkedList storage _levelChain, uint256 _samuraiId) private {
416         _levelChain.push(_samuraiId, false);
417     }
418     
419     function pop(LinkedListLib.LinkedList storage _levelChain) private {
420         _levelChain.pop(true);
421     }
422     
423     function remove(LinkedListLib.LinkedList storage _levelChain, uint256 _samuraiId) private {
424         _levelChain.remove(_samuraiId);
425     }
426 }
427 
428 /**
429  * @title LinkedListLib
430  * @author Darryl Morris (o0ragman0o) and Modular.network
431  * 
432  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
433  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
434  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
435  * coding patterns.
436  *
437  * version 1.0.0
438  * Copyright (c) 2017 Modular Inc.
439  * The MIT License (MIT)
440  * https://github.com/Modular-Network/ethereum-libraries/blob/master/LICENSE
441  * 
442  * The LinkedListLib provides functionality for implementing data indexing using
443  * a circlular linked list.
444  *
445  * Modular provides smart contract services and security reviews for contract
446  * deployments in addition to working on open source projects in the Ethereum
447  * community. Our purpose is to test, document, and deploy reusable code onto the
448  * blockchain and improve both security and usability. We also educate non-profits,
449  * schools, and other community members about the application of blockchain
450  * technology. For further information: modular.network.
451  *
452  *
453  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
454  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
455  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
456  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
457  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
458  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
459  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
460 */
461 
462 library LinkedListLib {
463 
464 
465     uint256 private constant NULL = 0;
466     uint256 private constant HEAD = 0;
467     bool private constant PREV = false;
468     bool private constant NEXT = true;
469     
470     struct LinkedList {
471         mapping (uint256 => mapping (bool => uint256)) list;
472     }
473 
474   /// @dev returns true if the list exists
475   /// @param self stored linked list from contract
476     function listExists(LinkedList storage self)
477         internal
478         view returns (bool)
479     {
480         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
481         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
482             return true;
483         } else {
484             return false;
485         }
486     }
487 
488     /// @dev returns true if the node exists
489     /// @param self stored linked list from contract
490     /// @param _node a node to search for
491     function nodeExists(LinkedList storage self, uint256 _node) 
492         internal
493         view returns (bool)
494     {
495         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
496             if (self.list[HEAD][NEXT] == _node) {
497                 return true;
498             } else {
499                 return false;
500             }
501         } else {
502             return true;
503         }
504     }
505   
506     /// @dev Returns the number of elements in the list
507     /// @param self stored linked list from contract
508     function sizeOf(LinkedList storage self) internal view returns (uint256 numElements) {
509         bool exists;
510         uint256 i;
511         (exists, i) = getAdjacent(self, HEAD, NEXT);
512         while (i != HEAD) {
513             (exists, i) = getAdjacent(self, i, NEXT);
514             numElements++;
515         }
516         return;
517     }
518 
519     /// @dev Returns the links of a node as a tuple
520     /// @param self stored linked list from contract
521     /// @param _node id of the node to get
522     function getNode(LinkedList storage self, uint256 _node)
523         internal view returns (bool, uint256, uint256)
524     {
525         if (!nodeExists(self, _node)) {
526             return (false, 0, 0);
527         } else {
528             return (true, self.list[_node][PREV], self.list[_node][NEXT]);
529         }
530     }
531 
532     /// @dev Returns the link of a node `_node` in direction `_direction`.
533     /// @param self stored linked list from contract
534     /// @param _node id of the node to step from
535     /// @param _direction direction to step in
536     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
537         internal view returns (bool, uint256)
538     {
539         if (!nodeExists(self, _node)) {
540             return (false, 0);
541         } else {
542             return (true, self.list[_node][_direction]);
543         }
544     }
545   
546     /// @dev Can be used before `insert` to build an ordered list
547     /// @param self stored linked list from contract
548     /// @param _node an existing node to search from, e.g. HEAD.
549     /// @param _value value to seek
550     /// @param _direction direction to seek in
551     //  @return next first node beyond '_node' in direction `_direction`
552     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
553         internal view returns (uint256)
554     {
555         if (sizeOf(self) == 0) {
556             return 0;
557         }
558 
559         require((_node == 0) || nodeExists(self, _node));
560 
561         bool exists;
562         uint256 next;
563 
564         (exists, next) = getAdjacent(self, _node, _direction);
565 
566         while ((next != 0) && (_value != next) && ((_value < next) != _direction)) {
567             next = self.list[next][_direction];
568         }
569 
570         return next;
571     }
572 
573     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
574     /// @param self stored linked list from contract
575     /// @param _node first node for linking
576     /// @param _link  node to link to in the _direction
577     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction)
578         internal
579     {
580         self.list[_link][!_direction] = _node;
581         self.list[_node][_direction] = _link;
582     }
583 
584     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
585     /// @param self stored linked list from contract
586     /// @param _node existing node
587     /// @param _new  new node to insert
588     /// @param _direction direction to insert node in
589     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
590         if (!nodeExists(self, _new) && nodeExists(self, _node)) {
591             uint256 c = self.list[_node][_direction];
592             createLink(self, _node, _new, _direction);
593             createLink(self, _new, c, _direction);
594 
595             return true;
596         } else {
597             return false;
598         }
599     }
600     
601     /// @dev removes an entry from the linked list
602     /// @param self stored linked list from contract
603     /// @param _node node to remove from the list
604     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
605         if ((_node == NULL) || (!nodeExists(self, _node))) {
606             return 0;
607         }
608 
609         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
610         delete self.list[_node][PREV];
611         delete self.list[_node][NEXT];
612 
613         return _node;
614     }
615 
616     /// @dev pushes an entry to the head of the linked list
617     /// @param self stored linked list from contract
618     /// @param _node new entry to push to the head
619     /// @param _direction push to the head (NEXT) or tail (PREV)
620     function push(LinkedList storage self, uint256 _node, bool _direction)    
621         internal returns (bool)
622     {
623         return insert(self, HEAD, _node, _direction);
624     }
625     
626     /// @dev pops the first entry from the linked list
627     /// @param self stored linked list from contract
628     /// @param _direction pop from the head (NEXT) or the tail (PREV)
629     function pop(LinkedList storage self, bool _direction) 
630         internal returns (uint256)
631     {
632         bool exists;
633         uint256 adj;
634 
635         (exists, adj) = getAdjacent(self, HEAD, _direction);
636 
637         return remove(self, adj);
638     }
639 }
640 
641 /**
642  * @title SafeMath
643  * @dev Math operations with safety checks that revert on error
644  */
645 library SafeMath {
646 
647     /**
648     * @dev Multiplies two numbers, reverts on overflow.
649     */
650     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
651         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
652         // benefit is lost if 'b' is also tested.
653         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
654         if (a == 0) {
655             return 0;
656         }
657 
658         uint256 c = a * b;
659         require(c / a == b);
660 
661         return c;
662     }
663 
664     /**
665     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
666     */
667     function div(uint256 a, uint256 b) internal pure returns (uint256) {
668         require(b > 0); // Solidity only automatically asserts when dividing by 0
669         uint256 c = a / b;
670         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
671 
672         return c;
673     }
674 
675     /**
676     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
677     */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
679         require(b <= a);
680         uint256 c = a - b;
681 
682         return c;
683     }
684 
685     /**
686     * @dev Adds two numbers, reverts on overflow.
687     */
688     function add(uint256 a, uint256 b) internal pure returns (uint256) {
689         uint256 c = a + b;
690         require(c >= a);
691 
692         return c;
693     }
694 
695     /**
696     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
697     * reverts when dividing by zero.
698     */
699     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
700         require(b != 0);
701         
702         return a % b;
703     }
704 }