1 // File: contracts/installed_contracts/DLL.sol
2 
3 pragma solidity^0.4.11;
4 
5 library DLL {
6 
7   uint constant NULL_NODE_ID = 0;
8 
9   struct Node {
10     uint next;
11     uint prev;
12   }
13 
14   struct Data {
15     mapping(uint => Node) dll;
16   }
17 
18   function isEmpty(Data storage self) public view returns (bool) {
19     return getStart(self) == NULL_NODE_ID;
20   }
21 
22   function contains(Data storage self, uint _curr) public view returns (bool) {
23     if (isEmpty(self) || _curr == NULL_NODE_ID) {
24       return false;
25     }
26 
27     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
28     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
29     return isSingleNode || !isNullNode;
30   }
31 
32   function getNext(Data storage self, uint _curr) public view returns (uint) {
33     return self.dll[_curr].next;
34   }
35 
36   function getPrev(Data storage self, uint _curr) public view returns (uint) {
37     return self.dll[_curr].prev;
38   }
39 
40   function getStart(Data storage self) public view returns (uint) {
41     return getNext(self, NULL_NODE_ID);
42   }
43 
44   function getEnd(Data storage self) public view returns (uint) {
45     return getPrev(self, NULL_NODE_ID);
46   }
47 
48   /**
49   @dev Inserts a new node between _prev and _next. When inserting a node already existing in
50   the list it will be automatically removed from the old position.
51   @param _prev the node which _new will be inserted after
52   @param _curr the id of the new node being inserted
53   @param _next the node which _new will be inserted before
54   */
55   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
56     require(_curr != NULL_NODE_ID);
57 
58     remove(self, _curr);
59 
60     require(_prev == NULL_NODE_ID || contains(self, _prev));
61     require(_next == NULL_NODE_ID || contains(self, _next));
62 
63     require(getNext(self, _prev) == _next);
64     require(getPrev(self, _next) == _prev);
65 
66     self.dll[_curr].prev = _prev;
67     self.dll[_curr].next = _next;
68 
69     self.dll[_prev].next = _curr;
70     self.dll[_next].prev = _curr;
71   }
72 
73   function remove(Data storage self, uint _curr) public {
74     if (!contains(self, _curr)) {
75       return;
76     }
77 
78     uint next = getNext(self, _curr);
79     uint prev = getPrev(self, _curr);
80 
81     self.dll[next].prev = prev;
82     self.dll[prev].next = next;
83 
84     delete self.dll[_curr];
85   }
86 }
87 
88 // File: contracts/installed_contracts/AttributeStore.sol
89 
90 /* solium-disable */
91 pragma solidity^0.4.11;
92 
93 library AttributeStore {
94     struct Data {
95         mapping(bytes32 => uint) store;
96     }
97 
98     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
99     public view returns (uint) {
100         bytes32 key = keccak256(_UUID, _attrName);
101         return self.store[key];
102     }
103 
104     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
105     public {
106         bytes32 key = keccak256(_UUID, _attrName);
107         self.store[key] = _attrVal;
108     }
109 }
110 
111 // File: contracts/zeppelin-solidity/token/ERC20/IERC20.sol
112 
113 pragma solidity ^0.4.24;
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 interface IERC20 {
120     function totalSupply() external view returns (uint256);
121 
122     function balanceOf(address who) external view returns (uint256);
123 
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     function transfer(address to, uint256 value) external returns (bool);
127 
128     function approve(address spender, uint256 value) external returns (bool);
129 
130     function transferFrom(address from, address to, uint256 value) external returns (bool);
131 
132     event Transfer(address indexed from, address indexed to, uint256 value);
133 
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 // File: contracts/zeppelin-solidity/math/SafeMath.sol
138 
139 pragma solidity ^0.4.24;
140 
141 
142 /**
143  * @title SafeMath
144  * @dev Math operations with safety checks that throw on error
145  */
146 library SafeMath {
147 
148   /**
149   * @dev Multiplies two numbers, throws on overflow.
150   */
151   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
152     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
153     // benefit is lost if 'b' is also tested.
154     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
155     if (_a == 0) {
156       return 0;
157     }
158 
159     c = _a * _b;
160     assert(c / _a == _b);
161     return c;
162   }
163 
164   /**
165   * @dev Integer division of two numbers, truncating the quotient.
166   */
167   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
168     // assert(_b > 0); // Solidity automatically throws when dividing by 0
169     // uint256 c = _a / _b;
170     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
171     return _a / _b;
172   }
173 
174   /**
175   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
176   */
177   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
178     assert(_b <= _a);
179     return _a - _b;
180   }
181 
182   /**
183   * @dev Adds two numbers, throws on overflow.
184   */
185   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
186     c = _a + _b;
187     assert(c >= _a);
188     return c;
189   }
190 }
191 
192 // File: contracts/installed_contracts/PLCRVoting.sol
193 
194 pragma solidity ^0.4.8;
195 
196 
197 
198 
199 
200 /**
201 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
202 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
203 */
204 contract PLCRVoting {
205 
206     // ============
207     // EVENTS:
208     // ============
209 
210     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
211     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
212     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
213     event _VotingRightsGranted(uint numTokens, address indexed voter);
214     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
215     event _TokensRescued(uint indexed pollID, address indexed voter);
216 
217     // ============
218     // DATA STRUCTURES:
219     // ============
220 
221     using AttributeStore for AttributeStore.Data;
222     using DLL for DLL.Data;
223     using SafeMath for uint;
224 
225     struct Poll {
226         uint commitEndDate;     /// expiration date of commit period for poll
227         uint revealEndDate;     /// expiration date of reveal period for poll
228         uint voteQuorum;	    /// number of votes required for a proposal to pass
229         uint votesFor;		    /// tally of votes supporting proposal
230         uint votesAgainst;      /// tally of votes countering proposal
231         mapping(address => bool) didCommit;  /// indicates whether an address committed a vote for this poll
232         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
233     }
234 
235     // ============
236     // STATE VARIABLES:
237     // ============
238 
239     uint constant public INITIAL_POLL_NONCE = 0;
240     uint public pollNonce;
241 
242     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
243     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
244 
245     mapping(address => DLL.Data) dllMap;
246     AttributeStore.Data store;
247 
248     IERC20 public token;
249 
250     /**
251     @param _token The address where the ERC20 token contract is deployed
252     */
253     constructor(address _token) public {
254         require(_token != 0);
255 
256         token = IERC20(_token);
257         pollNonce = INITIAL_POLL_NONCE;
258     }
259 
260     // ================
261     // TOKEN INTERFACE:
262     // ================
263 
264     /**
265     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
266     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
267     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
268     */
269     function requestVotingRights(uint _numTokens) public {
270         require(token.balanceOf(msg.sender) >= _numTokens);
271         voteTokenBalance[msg.sender] += _numTokens;
272         require(token.transferFrom(msg.sender, this, _numTokens));
273         emit _VotingRightsGranted(_numTokens, msg.sender);
274     }
275 
276     /**
277     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
278     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
279     */
280     function withdrawVotingRights(uint _numTokens) external {
281         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
282         require(availableTokens >= _numTokens);
283         voteTokenBalance[msg.sender] -= _numTokens;
284         require(token.transfer(msg.sender, _numTokens));
285         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
286     }
287 
288     /**
289     @dev Unlocks tokens locked in unrevealed vote where poll has ended
290     @param _pollID Integer identifier associated with the target poll
291     */
292     function rescueTokens(uint _pollID) public {
293         require(isExpired(pollMap[_pollID].revealEndDate));
294         require(dllMap[msg.sender].contains(_pollID));
295 
296         dllMap[msg.sender].remove(_pollID);
297         emit _TokensRescued(_pollID, msg.sender);
298     }
299 
300     /**
301     @dev Unlocks tokens locked in unrevealed votes where polls have ended
302     @param _pollIDs Array of integer identifiers associated with the target polls
303     */
304     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
305         // loop through arrays, rescuing tokens from all
306         for (uint i = 0; i < _pollIDs.length; i++) {
307             rescueTokens(_pollIDs[i]);
308         }
309     }
310 
311     // =================
312     // VOTING INTERFACE:
313     // =================
314 
315     /**
316     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
317     @param _pollID Integer identifier associated with target poll
318     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
319     @param _numTokens The number of tokens to be committed towards the target poll
320     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
321     */
322     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
323         require(commitPeriodActive(_pollID));
324 
325         // if msg.sender doesn't have enough voting rights,
326         // request for enough voting rights
327         if (voteTokenBalance[msg.sender] < _numTokens) {
328             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
329             requestVotingRights(remainder);
330         }
331 
332         // make sure msg.sender has enough voting rights
333         require(voteTokenBalance[msg.sender] >= _numTokens);
334         // prevent user from committing to zero node placeholder
335         require(_pollID != 0);
336         // prevent user from committing a secretHash of 0
337         require(_secretHash != 0);
338 
339         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
340         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
341 
342         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
343 
344         // edge case: in-place update
345         if (nextPollID == _pollID) {
346             nextPollID = dllMap[msg.sender].getNext(_pollID);
347         }
348 
349         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
350         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
351 
352         bytes32 UUID = attrUUID(msg.sender, _pollID);
353 
354         store.setAttribute(UUID, "numTokens", _numTokens);
355         store.setAttribute(UUID, "commitHash", uint(_secretHash));
356 
357         pollMap[_pollID].didCommit[msg.sender] = true;
358         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
359     }
360 
361     /**
362     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
363     @param _pollIDs         Array of integer identifiers associated with target polls
364     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
365     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
366     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
367     */
368     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
369         // make sure the array lengths are all the same
370         require(_pollIDs.length == _secretHashes.length);
371         require(_pollIDs.length == _numsTokens.length);
372         require(_pollIDs.length == _prevPollIDs.length);
373 
374         // loop through arrays, committing each individual vote values
375         for (uint i = 0; i < _pollIDs.length; i++) {
376             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
377         }
378     }
379 
380     /**
381     @dev Compares previous and next poll's committed tokens for sorting purposes
382     @param _prevID Integer identifier associated with previous poll in sorted order
383     @param _nextID Integer identifier associated with next poll in sorted order
384     @param _voter Address of user to check DLL position for
385     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
386     @return valid Boolean indication of if the specified position maintains the sort
387     */
388     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
389         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
390         // if next is zero node, _numTokens does not need to be greater
391         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
392         return prevValid && nextValid;
393     }
394 
395     /**
396     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
397     @param _pollID Integer identifier associated with target poll
398     @param _voteOption Vote choice used to generate commitHash for associated poll
399     @param _salt Secret number used to generate commitHash for associated poll
400     */
401     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
402         // Make sure the reveal period is active
403         require(revealPeriodActive(_pollID));
404         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
405         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
406         require(keccak256(_voteOption, _salt) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
407 
408         uint numTokens = getNumTokens(msg.sender, _pollID);
409 
410         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
411             pollMap[_pollID].votesFor += numTokens;
412         } else {
413             pollMap[_pollID].votesAgainst += numTokens;
414         }
415 
416         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
417         pollMap[_pollID].didReveal[msg.sender] = true;
418 
419         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
420     }
421 
422     /**
423     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
424     @param _pollIDs     Array of integer identifiers associated with target polls
425     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
426     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
427     */
428     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
429         // make sure the array lengths are all the same
430         require(_pollIDs.length == _voteOptions.length);
431         require(_pollIDs.length == _salts.length);
432 
433         // loop through arrays, revealing each individual vote values
434         for (uint i = 0; i < _pollIDs.length; i++) {
435             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
436         }
437     }
438 
439     /**
440     @param _pollID Integer identifier associated with target poll
441     @param _salt Arbitrarily chosen integer used to generate secretHash
442     @return correctVotes Number of tokens voted for winning option
443     */
444     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
445         require(pollEnded(_pollID));
446         require(pollMap[_pollID].didReveal[_voter]);
447 
448         uint winningChoice = isPassed(_pollID) ? 1 : 0;
449         bytes32 winnerHash = keccak256(winningChoice, _salt);
450         bytes32 commitHash = getCommitHash(_voter, _pollID);
451 
452         require(winnerHash == commitHash);
453 
454         return getNumTokens(_voter, _pollID);
455     }
456 
457     // ==================
458     // POLLING INTERFACE:
459     // ==================
460 
461     /**
462     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
463     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
464     @param _commitDuration Length of desired commit period in seconds
465     @param _revealDuration Length of desired reveal period in seconds
466     */
467     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
468         pollNonce = pollNonce + 1;
469 
470         uint commitEndDate = block.timestamp.add(_commitDuration);
471         uint revealEndDate = commitEndDate.add(_revealDuration);
472 
473         pollMap[pollNonce] = Poll({
474             voteQuorum: _voteQuorum,
475             commitEndDate: commitEndDate,
476             revealEndDate: revealEndDate,
477             votesFor: 0,
478             votesAgainst: 0
479         });
480 
481         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
482         return pollNonce;
483     }
484 
485     /**
486     @notice Determines if proposal has passed
487     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
488     @param _pollID Integer identifier associated with target poll
489     */
490     function isPassed(uint _pollID) constant public returns (bool passed) {
491         require(pollEnded(_pollID));
492 
493         Poll memory poll = pollMap[_pollID];
494         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
495     }
496 
497     // ----------------
498     // POLLING HELPERS:
499     // ----------------
500 
501     /**
502     @dev Gets the total winning votes for reward distribution purposes
503     @param _pollID Integer identifier associated with target poll
504     @return Total number of votes committed to the winning option for specified poll
505     */
506     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
507         require(pollEnded(_pollID));
508 
509         if (isPassed(_pollID))
510             return pollMap[_pollID].votesFor;
511         else
512             return pollMap[_pollID].votesAgainst;
513     }
514 
515     /**
516     @notice Determines if poll is over
517     @dev Checks isExpired for specified poll's revealEndDate
518     @return Boolean indication of whether polling period is over
519     */
520     function pollEnded(uint _pollID) constant public returns (bool ended) {
521         require(pollExists(_pollID));
522 
523         return isExpired(pollMap[_pollID].revealEndDate);
524     }
525 
526     /**
527     @notice Checks if the commit period is still active for the specified poll
528     @dev Checks isExpired for the specified poll's commitEndDate
529     @param _pollID Integer identifier associated with target poll
530     @return Boolean indication of isCommitPeriodActive for target poll
531     */
532     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
533         require(pollExists(_pollID));
534 
535         return !isExpired(pollMap[_pollID].commitEndDate);
536     }
537 
538     /**
539     @notice Checks if the reveal period is still active for the specified poll
540     @dev Checks isExpired for the specified poll's revealEndDate
541     @param _pollID Integer identifier associated with target poll
542     */
543     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
544         require(pollExists(_pollID));
545 
546         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
547     }
548 
549     /**
550     @dev Checks if user has committed for specified poll
551     @param _voter Address of user to check against
552     @param _pollID Integer identifier associated with target poll
553     @return Boolean indication of whether user has committed
554     */
555     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
556         require(pollExists(_pollID));
557 
558         return pollMap[_pollID].didCommit[_voter];
559     }
560 
561     /**
562     @dev Checks if user has revealed for specified poll
563     @param _voter Address of user to check against
564     @param _pollID Integer identifier associated with target poll
565     @return Boolean indication of whether user has revealed
566     */
567     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
568         require(pollExists(_pollID));
569 
570         return pollMap[_pollID].didReveal[_voter];
571     }
572 
573     /**
574     @dev Checks if a poll exists
575     @param _pollID The pollID whose existance is to be evaluated.
576     @return Boolean Indicates whether a poll exists for the provided pollID
577     */
578     function pollExists(uint _pollID) constant public returns (bool exists) {
579         return (_pollID != 0 && _pollID <= pollNonce);
580     }
581 
582     // ---------------------------
583     // DOUBLE-LINKED-LIST HELPERS:
584     // ---------------------------
585 
586     /**
587     @dev Gets the bytes32 commitHash property of target poll
588     @param _voter Address of user to check against
589     @param _pollID Integer identifier associated with target poll
590     @return Bytes32 hash property attached to target poll
591     */
592     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
593         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
594     }
595 
596     /**
597     @dev Wrapper for getAttribute with attrName="numTokens"
598     @param _voter Address of user to check against
599     @param _pollID Integer identifier associated with target poll
600     @return Number of tokens committed to poll in sorted poll-linked-list
601     */
602     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
603         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
604     }
605 
606     /**
607     @dev Gets top element of sorted poll-linked-list
608     @param _voter Address of user to check against
609     @return Integer identifier to poll with maximum number of tokens committed to it
610     */
611     function getLastNode(address _voter) constant public returns (uint pollID) {
612         return dllMap[_voter].getPrev(0);
613     }
614 
615     /**
616     @dev Gets the numTokens property of getLastNode
617     @param _voter Address of user to check against
618     @return Maximum number of tokens committed in poll specified
619     */
620     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
621         return getNumTokens(_voter, getLastNode(_voter));
622     }
623 
624     /*
625     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
626     for a node with a value less than or equal to the provided _numTokens value. When such a node
627     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
628     update. In that case, return the previous node of the node being updated. Otherwise return the
629     first node that was found with a value less than or equal to the provided _numTokens.
630     @param _voter The voter whose DLL will be searched
631     @param _numTokens The value for the numTokens attribute in the node to be inserted
632     @return the node which the propoded node should be inserted after
633     */
634     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
635     constant public returns (uint prevNode) {
636       // Get the last node in the list and the number of tokens in that node
637       uint nodeID = getLastNode(_voter);
638       uint tokensInNode = getNumTokens(_voter, nodeID);
639 
640       // Iterate backwards through the list until reaching the root node
641       while(nodeID != 0) {
642         // Get the number of tokens in the current node
643         tokensInNode = getNumTokens(_voter, nodeID);
644         if(tokensInNode <= _numTokens) { // We found the insert point!
645           if(nodeID == _pollID) {
646             // This is an in-place update. Return the prev node of the node being updated
647             nodeID = dllMap[_voter].getPrev(nodeID);
648           }
649           // Return the insert point
650           return nodeID;
651         }
652         // We did not find the insert point. Continue iterating backwards through the list
653         nodeID = dllMap[_voter].getPrev(nodeID);
654       }
655 
656       // The list is empty, or a smaller value than anything else in the list is being inserted
657       return nodeID;
658     }
659 
660     // ----------------
661     // GENERAL HELPERS:
662     // ----------------
663 
664     /**
665     @dev Checks if an expiration date has been reached
666     @param _terminationDate Integer timestamp of date to compare current timestamp with
667     @return expired Boolean indication of whether the terminationDate has passed
668     */
669     function isExpired(uint _terminationDate) constant public returns (bool expired) {
670         return (block.timestamp > _terminationDate);
671     }
672 
673     /**
674     @dev Generates an identifier which associates a user and a poll together
675     @param _pollID Integer identifier associated with target poll
676     @return UUID Hash which is deterministic from _user and _pollID
677     */
678     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
679         return keccak256(_user, _pollID);
680     }
681 }
682 
683 // File: contracts/installed_contracts/Parameterizer.sol
684 
685 pragma solidity^0.4.11;
686 
687 
688 
689 
690 contract Parameterizer {
691 
692     // ------
693     // EVENTS
694     // ------
695 
696     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
697     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
698     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
699     event _ProposalExpired(bytes32 indexed propID);
700     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
701     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
702     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
703 
704 
705     // ------
706     // DATA STRUCTURES
707     // ------
708 
709     using SafeMath for uint;
710 
711     struct ParamProposal {
712         uint appExpiry;
713         uint challengeID;
714         uint deposit;
715         string name;
716         address owner;
717         uint processBy;
718         uint value;
719     }
720 
721     struct Challenge {
722         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
723         address challenger;     // owner of Challenge
724         bool resolved;          // indication of if challenge is resolved
725         uint stake;             // number of tokens at risk for either party during challenge
726         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
727         mapping(address => bool) tokenClaims;
728     }
729 
730     // ------
731     // STATE
732     // ------
733 
734     mapping(bytes32 => uint) public params;
735 
736     // maps challengeIDs to associated challenge data
737     mapping(uint => Challenge) public challenges;
738 
739     // maps pollIDs to intended data change if poll passes
740     mapping(bytes32 => ParamProposal) public proposals;
741 
742     // Global Variables
743     IERC20 public token;
744     PLCRVoting public voting;
745     uint public PROCESSBY = 604800; // 7 days
746 
747     /**
748     @param _token           The address where the ERC20 token contract is deployed
749     @param _plcr            address of a PLCR voting contract for the provided token
750     @notice _parameters     array of canonical parameters
751     */
752     constructor(
753         address _token,
754         address _plcr,
755         uint[] _parameters
756     ) public {
757         token = IERC20(_token);
758         voting = PLCRVoting(_plcr);
759 
760         // minimum deposit for listing to be whitelisted
761         set("minDeposit", _parameters[0]);
762 
763         // minimum deposit to propose a reparameterization
764         set("pMinDeposit", _parameters[1]);
765 
766         // period over which applicants wait to be whitelisted
767         set("applyStageLen", _parameters[2]);
768 
769         // period over which reparmeterization proposals wait to be processed
770         set("pApplyStageLen", _parameters[3]);
771 
772         // length of commit period for voting
773         set("commitStageLen", _parameters[4]);
774 
775         // length of commit period for voting in parameterizer
776         set("pCommitStageLen", _parameters[5]);
777 
778         // length of reveal period for voting
779         set("revealStageLen", _parameters[6]);
780 
781         // length of reveal period for voting in parameterizer
782         set("pRevealStageLen", _parameters[7]);
783 
784         // percentage of losing party's deposit distributed to winning party
785         set("dispensationPct", _parameters[8]);
786 
787         // percentage of losing party's deposit distributed to winning party in parameterizer
788         set("pDispensationPct", _parameters[9]);
789 
790         // type of majority out of 100 necessary for candidate success
791         set("voteQuorum", _parameters[10]);
792 
793         // type of majority out of 100 necessary for proposal success in parameterizer
794         set("pVoteQuorum", _parameters[11]);
795     }
796 
797     // -----------------------
798     // TOKEN HOLDER INTERFACE
799     // -----------------------
800 
801     /**
802     @notice propose a reparamaterization of the key _name's value to _value.
803     @param _name the name of the proposed param to be set
804     @param _value the proposed value to set the param to be set
805     */
806     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
807         uint deposit = get("pMinDeposit");
808         bytes32 propID = keccak256(_name, _value);
809 
810         if (keccak256(_name) == keccak256("dispensationPct") ||
811             keccak256(_name) == keccak256("pDispensationPct")) {
812             require(_value <= 100);
813         }
814 
815         require(!propExists(propID)); // Forbid duplicate proposals
816         require(get(_name) != _value); // Forbid NOOP reparameterizations
817 
818         // attach name and value to pollID
819         proposals[propID] = ParamProposal({
820             appExpiry: now.add(get("pApplyStageLen")),
821             challengeID: 0,
822             deposit: deposit,
823             name: _name,
824             owner: msg.sender,
825             processBy: now.add(get("pApplyStageLen"))
826                 .add(get("pCommitStageLen"))
827                 .add(get("pRevealStageLen"))
828                 .add(PROCESSBY),
829             value: _value
830         });
831 
832         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
833 
834         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
835         return propID;
836     }
837 
838     /**
839     @notice challenge the provided proposal ID, and put tokens at stake to do so.
840     @param _propID the proposal ID to challenge
841     */
842     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
843         ParamProposal memory prop = proposals[_propID];
844         uint deposit = prop.deposit;
845 
846         require(propExists(_propID) && prop.challengeID == 0);
847 
848         //start poll
849         uint pollID = voting.startPoll(
850             get("pVoteQuorum"),
851             get("pCommitStageLen"),
852             get("pRevealStageLen")
853         );
854 
855         challenges[pollID] = Challenge({
856             challenger: msg.sender,
857             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
858             stake: deposit,
859             resolved: false,
860             winningTokens: 0
861         });
862 
863         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
864 
865         //take tokens from challenger
866         require(token.transferFrom(msg.sender, this, deposit));
867 
868         var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
869 
870         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
871         return pollID;
872     }
873 
874     /**
875     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
876     @param _propID      the proposal ID to make a determination and state transition for
877     */
878     function processProposal(bytes32 _propID) public {
879         ParamProposal storage prop = proposals[_propID];
880         address propOwner = prop.owner;
881         uint propDeposit = prop.deposit;
882 
883 
884         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
885         // prop.owner and prop.deposit will be 0, thereby preventing theft
886         if (canBeSet(_propID)) {
887             // There is no challenge against the proposal. The processBy date for the proposal has not
888             // passed, but the proposal's appExpirty date has passed.
889             set(prop.name, prop.value);
890             emit _ProposalAccepted(_propID, prop.name, prop.value);
891             delete proposals[_propID];
892             require(token.transfer(propOwner, propDeposit));
893         } else if (challengeCanBeResolved(_propID)) {
894             // There is a challenge against the proposal.
895             resolveChallenge(_propID);
896         } else if (now > prop.processBy) {
897             // There is no challenge against the proposal, but the processBy date has passed.
898             emit _ProposalExpired(_propID);
899             delete proposals[_propID];
900             require(token.transfer(propOwner, propDeposit));
901         } else {
902             // There is no challenge against the proposal, and neither the appExpiry date nor the
903             // processBy date has passed.
904             revert();
905         }
906 
907         assert(get("dispensationPct") <= 100);
908         assert(get("pDispensationPct") <= 100);
909 
910         // verify that future proposal appExpiry and processBy times will not overflow
911         now.add(get("pApplyStageLen"))
912             .add(get("pCommitStageLen"))
913             .add(get("pRevealStageLen"))
914             .add(PROCESSBY);
915 
916         delete proposals[_propID];
917     }
918 
919     /**
920     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
921     @param _challengeID     the challenge ID to claim tokens for
922     @param _salt            the salt used to vote in the challenge being withdrawn for
923     */
924     function claimReward(uint _challengeID, uint _salt) public {
925         // ensure voter has not already claimed tokens and challenge results have been processed
926         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
927         require(challenges[_challengeID].resolved == true);
928 
929         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
930         uint reward = voterReward(msg.sender, _challengeID, _salt);
931 
932         // subtract voter's information to preserve the participation ratios of other voters
933         // compared to the remaining pool of rewards
934         challenges[_challengeID].winningTokens -= voterTokens;
935         challenges[_challengeID].rewardPool -= reward;
936 
937         // ensures a voter cannot claim tokens again
938         challenges[_challengeID].tokenClaims[msg.sender] = true;
939 
940         emit _RewardClaimed(_challengeID, reward, msg.sender);
941         require(token.transfer(msg.sender, reward));
942     }
943 
944     /**
945     @dev                    Called by a voter to claim their rewards for each completed vote.
946                             Someone must call updateStatus() before this can be called.
947     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
948     @param _salts           The salts of a voter's commit hashes in the given polls
949     */
950     function claimRewards(uint[] _challengeIDs, uint[] _salts) public {
951         // make sure the array lengths are the same
952         require(_challengeIDs.length == _salts.length);
953 
954         // loop through arrays, claiming each individual vote reward
955         for (uint i = 0; i < _challengeIDs.length; i++) {
956             claimReward(_challengeIDs[i], _salts[i]);
957         }
958     }
959 
960     // --------
961     // GETTERS
962     // --------
963 
964     /**
965     @dev                Calculates the provided voter's token reward for the given poll.
966     @param _voter       The address of the voter whose reward balance is to be returned
967     @param _challengeID The ID of the challenge the voter's reward is being calculated for
968     @param _salt        The salt of the voter's commit hash in the given poll
969     @return             The uint indicating the voter's reward
970     */
971     function voterReward(address _voter, uint _challengeID, uint _salt)
972     public view returns (uint) {
973         uint winningTokens = challenges[_challengeID].winningTokens;
974         uint rewardPool = challenges[_challengeID].rewardPool;
975         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
976         return (voterTokens * rewardPool) / winningTokens;
977     }
978 
979     /**
980     @notice Determines whether a proposal passed its application stage without a challenge
981     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
982     */
983     function canBeSet(bytes32 _propID) view public returns (bool) {
984         ParamProposal memory prop = proposals[_propID];
985 
986         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
987     }
988 
989     /**
990     @notice Determines whether a proposal exists for the provided proposal ID
991     @param _propID The proposal ID whose existance is to be determined
992     */
993     function propExists(bytes32 _propID) view public returns (bool) {
994         return proposals[_propID].processBy > 0;
995     }
996 
997     /**
998     @notice Determines whether the provided proposal ID has a challenge which can be resolved
999     @param _propID The proposal ID whose challenge to inspect
1000     */
1001     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1002         ParamProposal memory prop = proposals[_propID];
1003         Challenge memory challenge = challenges[prop.challengeID];
1004 
1005         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1006     }
1007 
1008     /**
1009     @notice Determines the number of tokens to awarded to the winning party in a challenge
1010     @param _challengeID The challengeID to determine a reward for
1011     */
1012     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1013         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1014             // Edge case, nobody voted, give all tokens to the challenger.
1015             return 2 * challenges[_challengeID].stake;
1016         }
1017 
1018         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1019     }
1020 
1021     /**
1022     @notice gets the parameter keyed by the provided name value from the params mapping
1023     @param _name the key whose value is to be determined
1024     */
1025     function get(string _name) public view returns (uint value) {
1026         return params[keccak256(_name)];
1027     }
1028 
1029     /**
1030     @dev                Getter for Challenge tokenClaims mappings
1031     @param _challengeID The challengeID to query
1032     @param _voter       The voter whose claim status to query for the provided challengeID
1033     */
1034     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1035         return challenges[_challengeID].tokenClaims[_voter];
1036     }
1037 
1038     // ----------------
1039     // PRIVATE FUNCTIONS
1040     // ----------------
1041 
1042     /**
1043     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1044     @param _propID the proposal ID whose challenge is to be resolved.
1045     */
1046     function resolveChallenge(bytes32 _propID) private {
1047         ParamProposal memory prop = proposals[_propID];
1048         Challenge storage challenge = challenges[prop.challengeID];
1049 
1050         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1051         uint reward = challengeWinnerReward(prop.challengeID);
1052 
1053         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1054         challenge.resolved = true;
1055 
1056         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1057             if(prop.processBy > now) {
1058                 set(prop.name, prop.value);
1059             }
1060             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1061             require(token.transfer(prop.owner, reward));
1062         }
1063         else { // The challenge succeeded or nobody voted
1064             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1065             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1066         }
1067     }
1068 
1069     /**
1070     @dev sets the param keted by the provided name to the provided value
1071     @param _name the name of the param to be set
1072     @param _value the value to set the param to be set
1073     */
1074     function set(string _name, uint _value) internal {
1075         params[keccak256(_name)] = _value;
1076     }
1077 }
1078 
1079 // File: contracts/tcr/CivilParameterizer.sol
1080 
1081 pragma solidity ^0.4.19;
1082 
1083 
1084 contract CivilParameterizer is Parameterizer {
1085 
1086   /**
1087   @param tokenAddr           The address where the ERC20 token contract is deployed
1088   @param plcrAddr            address of a PLCR voting contract for the provided token
1089   @notice parameters     array of canonical parameters
1090   */
1091   constructor(
1092     address tokenAddr,
1093     address plcrAddr,
1094     uint[] parameters
1095   ) public Parameterizer(tokenAddr, plcrAddr, parameters)
1096   {
1097     set("challengeAppealLen", parameters[12]);
1098     set("challengeAppealCommitLen", parameters[13]);
1099     set("challengeAppealRevealLen", parameters[14]);
1100   }
1101 }