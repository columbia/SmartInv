1 pragma solidity ^0.4.11;
2 
3 // File: attrstore/AttributeStore.sol
4 
5 pragma solidity^0.4.11;
6 
7 library AttributeStore {
8     struct Data {
9         mapping(bytes32 => uint) store;
10     }
11 
12     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
13     public view returns (uint) {
14         bytes32 key = keccak256(_UUID, _attrName);
15         return self.store[key];
16     }
17 
18     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
19     public {
20         bytes32 key = keccak256(_UUID, _attrName);
21         self.store[key] = _attrVal;
22     }
23 }
24 
25 // File: dll/DLL.sol
26 
27 pragma solidity^0.4.11;
28 
29 library DLL {
30 
31   uint constant NULL_NODE_ID = 0;
32 
33   struct Node {
34     uint next;
35     uint prev;
36   }
37 
38   struct Data {
39     mapping(uint => Node) dll;
40   }
41 
42   function isEmpty(Data storage self) public view returns (bool) {
43     return getStart(self) == NULL_NODE_ID;
44   }
45 
46   function contains(Data storage self, uint _curr) public view returns (bool) {
47     if (isEmpty(self) || _curr == NULL_NODE_ID) {
48       return false;
49     } 
50 
51     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
52     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
53     return isSingleNode || !isNullNode;
54   }
55 
56   function getNext(Data storage self, uint _curr) public view returns (uint) {
57     return self.dll[_curr].next;
58   }
59 
60   function getPrev(Data storage self, uint _curr) public view returns (uint) {
61     return self.dll[_curr].prev;
62   }
63 
64   function getStart(Data storage self) public view returns (uint) {
65     return getNext(self, NULL_NODE_ID);
66   }
67 
68   function getEnd(Data storage self) public view returns (uint) {
69     return getPrev(self, NULL_NODE_ID);
70   }
71 
72   /**
73   @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
74   the list it will be automatically removed from the old position.
75   @param _prev the node which _new will be inserted after
76   @param _curr the id of the new node being inserted
77   @param _next the node which _new will be inserted before
78   */
79   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
80     require(_curr != NULL_NODE_ID);
81 
82     remove(self, _curr);
83 
84     require(_prev == NULL_NODE_ID || contains(self, _prev));
85     require(_next == NULL_NODE_ID || contains(self, _next));
86 
87     require(getNext(self, _prev) == _next);
88     require(getPrev(self, _next) == _prev);
89 
90     self.dll[_curr].prev = _prev;
91     self.dll[_curr].next = _next;
92 
93     self.dll[_prev].next = _curr;
94     self.dll[_next].prev = _curr;
95   }
96 
97   function remove(Data storage self, uint _curr) public {
98     if (!contains(self, _curr)) {
99       return;
100     }
101 
102     uint next = getNext(self, _curr);
103     uint prev = getPrev(self, _curr);
104 
105     self.dll[next].prev = prev;
106     self.dll[prev].next = next;
107 
108     delete self.dll[_curr];
109   }
110 }
111 
112 // File: tokens/eip20/EIP20Interface.sol
113 
114 // Abstract contract for the full ERC 20 Token standard
115 // https://github.com/ethereum/EIPs/issues/20
116 pragma solidity ^0.4.8;
117 
118 contract EIP20Interface {
119     /* This is a slight change to the ERC20 base standard.
120     function totalSupply() constant returns (uint256 supply);
121     is replaced with:
122     uint256 public totalSupply;
123     This automatically creates a getter function for the totalSupply.
124     This is moved to the base contract since public getter functions are not
125     currently recognised as an implementation of the matching abstract
126     function by the compiler.
127     */
128     /// total amount of tokens
129     uint256 public totalSupply;
130 
131     /// @param _owner The address from which the balance will be retrieved
132     /// @return The balance
133     function balanceOf(address _owner) public view returns (uint256 balance);
134 
135     /// @notice send `_value` token to `_to` from `msg.sender`
136     /// @param _to The address of the recipient
137     /// @param _value The amount of token to be transferred
138     /// @return Whether the transfer was successful or not
139     function transfer(address _to, uint256 _value) public returns (bool success);
140 
141     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
142     /// @param _from The address of the sender
143     /// @param _to The address of the recipient
144     /// @param _value The amount of token to be transferred
145     /// @return Whether the transfer was successful or not
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
147 
148     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
149     /// @param _spender The address of the account able to transfer the tokens
150     /// @param _value The amount of tokens to be approved for transfer
151     /// @return Whether the approval was successful or not
152     function approve(address _spender, uint256 _value) public returns (bool success);
153 
154     /// @param _owner The address of the account owning tokens
155     /// @param _spender The address of the account able to transfer the tokens
156     /// @return Amount of remaining tokens allowed to spent
157     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
158 
159     event Transfer(address indexed _from, address indexed _to, uint256 _value);
160     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
161 }
162 
163 // File: zeppelin/math/SafeMath.sol
164 
165 /**
166  * @title SafeMath
167  * @dev Math operations with safety checks that throw on error
168  */
169 library SafeMath {
170   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
171     uint256 c = a * b;
172     assert(a == 0 || c / a == b);
173     return c;
174   }
175 
176   function div(uint256 a, uint256 b) internal constant returns (uint256) {
177     // assert(b > 0); // Solidity automatically throws when dividing by 0
178     uint256 c = a / b;
179     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
180     return c;
181   }
182 
183   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
184     assert(b <= a);
185     return a - b;
186   }
187 
188   function add(uint256 a, uint256 b) internal constant returns (uint256) {
189     uint256 c = a + b;
190     assert(c >= a);
191     return c;
192   }
193 }
194 
195 // File: plcrvoting/PLCRVoting.sol
196 
197 /**
198 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
199 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
200 */
201 contract PLCRVoting {
202 
203     // ============
204     // EVENTS:
205     // ============
206 
207     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
208     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter);
209     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
210     event _VotingRightsGranted(uint numTokens, address indexed voter);
211     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
212     event _TokensRescued(uint indexed pollID, address indexed voter);
213 
214     // ============
215     // DATA STRUCTURES:
216     // ============
217 
218     using AttributeStore for AttributeStore.Data;
219     using DLL for DLL.Data;
220     using SafeMath for uint;
221 
222     struct Poll {
223         uint commitEndDate;     /// expiration date of commit period for poll
224         uint revealEndDate;     /// expiration date of reveal period for poll
225         uint voteQuorum;	    /// number of votes required for a proposal to pass
226         uint votesFor;		    /// tally of votes supporting proposal
227         uint votesAgainst;      /// tally of votes countering proposal
228         mapping(address => bool) didCommit;  /// indicates whether an address committed a vote for this poll
229         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
230     }
231 
232     // ============
233     // STATE VARIABLES:
234     // ============
235 
236     uint constant public INITIAL_POLL_NONCE = 0;
237     uint public pollNonce;
238 
239     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
240     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
241 
242     mapping(address => DLL.Data) dllMap;
243     AttributeStore.Data store;
244 
245     EIP20Interface public token;
246 
247     // ============
248     // CONSTRUCTOR:
249     // ============
250 
251     /**
252     @dev Initializes voteQuorum, commitDuration, revealDuration, and pollNonce in addition to token contract and trusted mapping
253     @param _tokenAddr The address where the ERC20 token contract is deployed
254     */
255     function PLCRVoting(address _tokenAddr) public {
256         token = EIP20Interface(_tokenAddr);
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
269     function requestVotingRights(uint _numTokens) external {
270         require(token.balanceOf(msg.sender) >= _numTokens);
271         voteTokenBalance[msg.sender] += _numTokens;
272         require(token.transferFrom(msg.sender, this, _numTokens));
273         _VotingRightsGranted(_numTokens, msg.sender);
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
285         _VotingRightsWithdrawn(_numTokens, msg.sender);
286     }
287 
288     /**
289     @dev Unlocks tokens locked in unrevealed vote where poll has ended
290     @param _pollID Integer identifier associated with the target poll
291     */
292     function rescueTokens(uint _pollID) external {
293         require(isExpired(pollMap[_pollID].revealEndDate));
294         require(dllMap[msg.sender].contains(_pollID));
295 
296         dllMap[msg.sender].remove(_pollID);
297         _TokensRescued(_pollID, msg.sender);
298     }
299 
300     // =================
301     // VOTING INTERFACE:
302     // =================
303 
304     /**
305     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
306     @param _pollID Integer identifier associated with target poll
307     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
308     @param _numTokens The number of tokens to be committed towards the target poll
309     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
310     */
311     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) external {
312         require(commitPeriodActive(_pollID));
313         require(voteTokenBalance[msg.sender] >= _numTokens); // prevent user from overspending
314         require(_pollID != 0);                // prevent user from committing to zero node placeholder
315 
316         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
317         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
318 
319         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
320 
321         // if nextPollID is equal to _pollID, _pollID is being updated,
322         nextPollID = (nextPollID == _pollID) ? dllMap[msg.sender].getNext(_pollID) : nextPollID;
323 
324         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
325         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
326 
327         bytes32 UUID = attrUUID(msg.sender, _pollID);
328 
329         store.setAttribute(UUID, "numTokens", _numTokens);
330         store.setAttribute(UUID, "commitHash", uint(_secretHash));
331 
332         pollMap[_pollID].didCommit[msg.sender] = true;
333         _VoteCommitted(_pollID, _numTokens, msg.sender);
334     }
335 
336     /**
337     @dev Compares previous and next poll's committed tokens for sorting purposes
338     @param _prevID Integer identifier associated with previous poll in sorted order
339     @param _nextID Integer identifier associated with next poll in sorted order
340     @param _voter Address of user to check DLL position for
341     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
342     @return valid Boolean indication of if the specified position maintains the sort
343     */
344     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
345         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
346         // if next is zero node, _numTokens does not need to be greater
347         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
348         return prevValid && nextValid;
349     }
350 
351     /**
352     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
353     @param _pollID Integer identifier associated with target poll
354     @param _voteOption Vote choice used to generate commitHash for associated poll
355     @param _salt Secret number used to generate commitHash for associated poll
356     */
357     function revealVote(uint _pollID, uint _voteOption, uint _salt) external {
358         // Make sure the reveal period is active
359         require(revealPeriodActive(_pollID));
360         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
361         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
362         require(keccak256(_voteOption, _salt) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
363 
364         uint numTokens = getNumTokens(msg.sender, _pollID);
365 
366         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
367             pollMap[_pollID].votesFor += numTokens;
368         } else {
369             pollMap[_pollID].votesAgainst += numTokens;
370         }
371 
372         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
373         pollMap[_pollID].didReveal[msg.sender] = true;
374 
375         _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender);
376     }
377 
378     /**
379     @param _pollID Integer identifier associated with target poll
380     @param _salt Arbitrarily chosen integer used to generate secretHash
381     @return correctVotes Number of tokens voted for winning option
382     */
383     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
384         require(pollEnded(_pollID));
385         require(pollMap[_pollID].didReveal[_voter]);
386 
387         uint winningChoice = isPassed(_pollID) ? 1 : 0;
388         bytes32 winnerHash = keccak256(winningChoice, _salt);
389         bytes32 commitHash = getCommitHash(_voter, _pollID);
390 
391         require(winnerHash == commitHash);
392 
393         return getNumTokens(_voter, _pollID);
394     }
395 
396     // ==================
397     // POLLING INTERFACE:
398     // ==================
399 
400     /**
401     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
402     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
403     @param _commitDuration Length of desired commit period in seconds
404     @param _revealDuration Length of desired reveal period in seconds
405     */
406     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
407         pollNonce = pollNonce + 1;
408 
409         uint commitEndDate = block.timestamp.add(_commitDuration);
410         uint revealEndDate = commitEndDate.add(_revealDuration);
411 
412         pollMap[pollNonce] = Poll({
413             voteQuorum: _voteQuorum,
414             commitEndDate: commitEndDate,
415             revealEndDate: revealEndDate,
416             votesFor: 0,
417             votesAgainst: 0
418         });
419 
420         _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
421         return pollNonce;
422     }
423 
424     /**
425     @notice Determines if proposal has passed
426     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
427     @param _pollID Integer identifier associated with target poll
428     */
429     function isPassed(uint _pollID) constant public returns (bool passed) {
430         require(pollEnded(_pollID));
431 
432         Poll memory poll = pollMap[_pollID];
433         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
434     }
435 
436     // ----------------
437     // POLLING HELPERS:
438     // ----------------
439 
440     /**
441     @dev Gets the total winning votes for reward distribution purposes
442     @param _pollID Integer identifier associated with target poll
443     @return Total number of votes committed to the winning option for specified poll
444     */
445     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
446         require(pollEnded(_pollID));
447 
448         if (isPassed(_pollID))
449             return pollMap[_pollID].votesFor;
450         else
451             return pollMap[_pollID].votesAgainst;
452     }
453 
454     /**
455     @notice Determines if poll is over
456     @dev Checks isExpired for specified poll's revealEndDate
457     @return Boolean indication of whether polling period is over
458     */
459     function pollEnded(uint _pollID) constant public returns (bool ended) {
460         require(pollExists(_pollID));
461 
462         return isExpired(pollMap[_pollID].revealEndDate);
463     }
464 
465     /**
466     @notice Checks if the commit period is still active for the specified poll
467     @dev Checks isExpired for the specified poll's commitEndDate
468     @param _pollID Integer identifier associated with target poll
469     @return Boolean indication of isCommitPeriodActive for target poll
470     */
471     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
472         require(pollExists(_pollID));
473 
474         return !isExpired(pollMap[_pollID].commitEndDate);
475     }
476 
477     /**
478     @notice Checks if the reveal period is still active for the specified poll
479     @dev Checks isExpired for the specified poll's revealEndDate
480     @param _pollID Integer identifier associated with target poll
481     */
482     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
483         require(pollExists(_pollID));
484 
485         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
486     }
487 
488     /**
489     @dev Checks if user has committed for specified poll
490     @param _voter Address of user to check against
491     @param _pollID Integer identifier associated with target poll
492     @return Boolean indication of whether user has committed
493     */
494     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
495         require(pollExists(_pollID));
496 
497         return pollMap[_pollID].didCommit[_voter];
498     }
499 
500     /**
501     @dev Checks if user has revealed for specified poll
502     @param _voter Address of user to check against
503     @param _pollID Integer identifier associated with target poll
504     @return Boolean indication of whether user has revealed
505     */
506     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
507         require(pollExists(_pollID));
508 
509         return pollMap[_pollID].didReveal[_voter];
510     }
511 
512     /**
513     @dev Checks if a poll exists
514     @param _pollID The pollID whose existance is to be evaluated.
515     @return Boolean Indicates whether a poll exists for the provided pollID
516     */
517     function pollExists(uint _pollID) constant public returns (bool exists) {
518         return (_pollID != 0 && _pollID <= pollNonce);
519     }
520 
521     // ---------------------------
522     // DOUBLE-LINKED-LIST HELPERS:
523     // ---------------------------
524 
525     /**
526     @dev Gets the bytes32 commitHash property of target poll
527     @param _voter Address of user to check against
528     @param _pollID Integer identifier associated with target poll
529     @return Bytes32 hash property attached to target poll
530     */
531     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
532         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
533     }
534 
535     /**
536     @dev Wrapper for getAttribute with attrName="numTokens"
537     @param _voter Address of user to check against
538     @param _pollID Integer identifier associated with target poll
539     @return Number of tokens committed to poll in sorted poll-linked-list
540     */
541     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
542         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
543     }
544 
545     /**
546     @dev Gets top element of sorted poll-linked-list
547     @param _voter Address of user to check against
548     @return Integer identifier to poll with maximum number of tokens committed to it
549     */
550     function getLastNode(address _voter) constant public returns (uint pollID) {
551         return dllMap[_voter].getPrev(0);
552     }
553 
554     /**
555     @dev Gets the numTokens property of getLastNode
556     @param _voter Address of user to check against
557     @return Maximum number of tokens committed in poll specified
558     */
559     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
560         return getNumTokens(_voter, getLastNode(_voter));
561     }
562 
563     /*
564     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
565     for a node with a value less than or equal to the provided _numTokens value. When such a node
566     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
567     update. In that case, return the previous node of the node being updated. Otherwise return the
568     first node that was found with a value less than or equal to the provided _numTokens.
569     @param _voter The voter whose DLL will be searched
570     @param _numTokens The value for the numTokens attribute in the node to be inserted
571     @return the node which the propoded node should be inserted after
572     */
573     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
574     constant public returns (uint prevNode) {
575       // Get the last node in the list and the number of tokens in that node
576       uint nodeID = getLastNode(_voter);
577       uint tokensInNode = getNumTokens(_voter, nodeID);
578 
579       // Iterate backwards through the list until reaching the root node
580       while(nodeID != 0) {
581         // Get the number of tokens in the current node
582         tokensInNode = getNumTokens(_voter, nodeID);
583         if(tokensInNode <= _numTokens) { // We found the insert point!
584           if(nodeID == _pollID) {
585             // This is an in-place update. Return the prev node of the node being updated
586             nodeID = dllMap[_voter].getPrev(nodeID);
587           }
588           // Return the insert point
589           return nodeID; 
590         }
591         // We did not find the insert point. Continue iterating backwards through the list
592         nodeID = dllMap[_voter].getPrev(nodeID);
593       }
594 
595       // The list is empty, or a smaller value than anything else in the list is being inserted
596       return nodeID;
597     }
598 
599     // ----------------
600     // GENERAL HELPERS:
601     // ----------------
602 
603     /**
604     @dev Checks if an expiration date has been reached
605     @param _terminationDate Integer timestamp of date to compare current timestamp with
606     @return expired Boolean indication of whether the terminationDate has passed
607     */
608     function isExpired(uint _terminationDate) constant public returns (bool expired) {
609         return (block.timestamp > _terminationDate);
610     }
611 
612     /**
613     @dev Generates an identifier which associates a user and a poll together
614     @param _pollID Integer identifier associated with target poll
615     @return UUID Hash which is deterministic from _user and _pollID
616     */
617     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
618         return keccak256(_user, _pollID);
619     }
620 }
621 
622 // File: contracts/Parameterizer.sol
623 
624 pragma solidity^0.4.11;
625 
626 
627 
628 
629 contract Parameterizer {
630 
631   // ------
632   // EVENTS
633   // ------
634 
635   event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
636   event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
637   event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
638   event _ProposalExpired(bytes32 indexed propID);
639   event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
640   event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
641   event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
642 
643 
644   // ------
645   // DATA STRUCTURES
646   // ------
647 
648   using SafeMath for uint;
649 
650   struct ParamProposal {
651     uint appExpiry;
652     uint challengeID;
653     uint deposit;
654     string name;
655     address owner;
656     uint processBy;
657     uint value;
658   }
659 
660   struct Challenge {
661     uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
662     address challenger;     // owner of Challenge
663     bool resolved;          // indication of if challenge is resolved
664     uint stake;             // number of tokens at risk for either party during challenge
665     uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
666     mapping(address => bool) tokenClaims;
667   }
668 
669   // ------
670   // STATE
671   // ------
672 
673   mapping(bytes32 => uint) public params;
674 
675   // maps challengeIDs to associated challenge data
676   mapping(uint => Challenge) public challenges;
677 
678   // maps pollIDs to intended data change if poll passes
679   mapping(bytes32 => ParamProposal) public proposals;
680 
681   // Global Variables
682   EIP20Interface public token;
683   PLCRVoting public voting;
684   uint public PROCESSBY = 604800; // 7 days
685 
686   // ------------
687   // CONSTRUCTOR
688   // ------------
689 
690   /**
691   @dev constructor
692   @param _tokenAddr        address of the token which parameterizes this system
693   @param _plcrAddr         address of a PLCR voting contract for the provided token
694   @param _minDeposit       minimum deposit for listing to be whitelisted
695   @param _pMinDeposit      minimum deposit to propose a reparameterization
696   @param _applyStageLen    period over which applicants wait to be whitelisted
697   @param _pApplyStageLen   period over which reparmeterization proposals wait to be processed
698   @param _dispensationPct  percentage of losing party's deposit distributed to winning party
699   @param _pDispensationPct percentage of losing party's deposit distributed to winning party in parameterizer
700   @param _commitStageLen  length of commit period for voting
701   @param _pCommitStageLen length of commit period for voting in parameterizer
702   @param _revealStageLen  length of reveal period for voting
703   @param _pRevealStageLen length of reveal period for voting in parameterizer
704   @param _voteQuorum       type of majority out of 100 necessary for vote success
705   @param _pVoteQuorum      type of majority out of 100 necessary for vote success in parameterizer
706   */
707   function Parameterizer(
708     address _tokenAddr,
709     address _plcrAddr,
710     uint _minDeposit,
711     uint _pMinDeposit,
712     uint _applyStageLen,
713     uint _pApplyStageLen,
714     uint _commitStageLen,
715     uint _pCommitStageLen,
716     uint _revealStageLen,
717     uint _pRevealStageLen,
718     uint _dispensationPct,
719     uint _pDispensationPct,
720     uint _voteQuorum,
721     uint _pVoteQuorum
722     ) public {
723       token = EIP20Interface(_tokenAddr);
724       voting = PLCRVoting(_plcrAddr);
725 
726       set("minDeposit", _minDeposit);
727       set("pMinDeposit", _pMinDeposit);
728       set("applyStageLen", _applyStageLen);
729       set("pApplyStageLen", _pApplyStageLen);
730       set("commitStageLen", _commitStageLen);
731       set("pCommitStageLen", _pCommitStageLen);
732       set("revealStageLen", _revealStageLen);
733       set("pRevealStageLen", _pRevealStageLen);
734       set("dispensationPct", _dispensationPct);
735       set("pDispensationPct", _pDispensationPct);
736       set("voteQuorum", _voteQuorum);
737       set("pVoteQuorum", _pVoteQuorum);
738   }
739 
740   // -----------------------
741   // TOKEN HOLDER INTERFACE
742   // -----------------------
743 
744   /**
745   @notice propose a reparamaterization of the key _name's value to _value.
746   @param _name the name of the proposed param to be set
747   @param _value the proposed value to set the param to be set
748   */
749   function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
750     uint deposit = get("pMinDeposit");
751     bytes32 propID = keccak256(_name, _value);
752 
753     if (keccak256(_name) == keccak256('dispensationPct') ||
754        keccak256(_name) == keccak256('pDispensationPct')) {
755         require(_value <= 100);
756     }
757 
758     require(!propExists(propID)); // Forbid duplicate proposals
759     require(get(_name) != _value); // Forbid NOOP reparameterizations
760 
761     // attach name and value to pollID
762     proposals[propID] = ParamProposal({
763       appExpiry: now.add(get("pApplyStageLen")),
764       challengeID: 0,
765       deposit: deposit,
766       name: _name,
767       owner: msg.sender,
768       processBy: now.add(get("pApplyStageLen"))
769         .add(get("pCommitStageLen"))
770         .add(get("pRevealStageLen"))
771         .add(PROCESSBY),
772       value: _value
773     });
774 
775     require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
776 
777     _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
778     return propID;
779   }
780 
781   /**
782   @notice challenge the provided proposal ID, and put tokens at stake to do so.
783   @param _propID the proposal ID to challenge
784   */
785   function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
786     ParamProposal memory prop = proposals[_propID];
787     uint deposit = prop.deposit;
788 
789     require(propExists(_propID) && prop.challengeID == 0);
790 
791     //start poll
792     uint pollID = voting.startPoll(
793       get("pVoteQuorum"),
794       get("pCommitStageLen"),
795       get("pRevealStageLen")
796     );
797 
798     challenges[pollID] = Challenge({
799       challenger: msg.sender,
800       rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
801       stake: deposit,
802       resolved: false,
803       winningTokens: 0
804     });
805 
806     proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
807 
808     //take tokens from challenger
809     require(token.transferFrom(msg.sender, this, deposit));
810 
811     var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
812 
813     _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
814     return pollID;
815   }
816 
817   /**
818   @notice for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
819   @param _propID the proposal ID to make a determination and state transition for
820   */
821   function processProposal(bytes32 _propID) public {
822     ParamProposal storage prop = proposals[_propID];
823     address propOwner = prop.owner;
824     uint propDeposit = prop.deposit;
825 
826     
827     // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
828     // prop.owner and prop.deposit will be 0, thereby preventing theft
829    if (canBeSet(_propID)) {
830       // There is no challenge against the proposal. The processBy date for the proposal has not
831      // passed, but the proposal's appExpirty date has passed.
832       set(prop.name, prop.value);
833       _ProposalAccepted(_propID, prop.name, prop.value);
834       delete proposals[_propID];
835       require(token.transfer(propOwner, propDeposit));
836     } else if (challengeCanBeResolved(_propID)) {
837       // There is a challenge against the proposal.
838       resolveChallenge(_propID);
839     } else if (now > prop.processBy) {
840       // There is no challenge against the proposal, but the processBy date has passed.
841       _ProposalExpired(_propID);
842       delete proposals[_propID];
843       require(token.transfer(propOwner, propDeposit));
844     } else {
845       // There is no challenge against the proposal, and neither the appExpiry date nor the
846       // processBy date has passed.
847       revert();
848     }
849 
850     assert(get("dispensationPct") <= 100);
851     assert(get("pDispensationPct") <= 100);
852 
853     // verify that future proposal appExpiry and processBy times will not overflow
854     now.add(get("pApplyStageLen"))
855       .add(get("pCommitStageLen"))
856       .add(get("pRevealStageLen"))
857       .add(PROCESSBY);
858 
859     delete proposals[_propID];
860   }
861 
862   /**
863   @notice claim the tokens owed for the msg.sender in the provided challenge
864   @param _challengeID the challenge ID to claim tokens for
865   @param _salt the salt used to vote in the challenge being withdrawn for
866   */
867   function claimReward(uint _challengeID, uint _salt) public {
868     // ensure voter has not already claimed tokens and challenge results have been processed
869     require(challenges[_challengeID].tokenClaims[msg.sender] == false);
870     require(challenges[_challengeID].resolved == true);
871 
872     uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
873     uint reward = voterReward(msg.sender, _challengeID, _salt);
874 
875     // subtract voter's information to preserve the participation ratios of other voters
876     // compared to the remaining pool of rewards
877     challenges[_challengeID].winningTokens -= voterTokens;
878     challenges[_challengeID].rewardPool -= reward;
879 
880     // ensures a voter cannot claim tokens again
881     challenges[_challengeID].tokenClaims[msg.sender] = true;
882 
883     _RewardClaimed(_challengeID, reward, msg.sender);
884     require(token.transfer(msg.sender, reward));
885   }
886 
887   // --------
888   // GETTERS
889   // --------
890 
891   /**
892   @dev                Calculates the provided voter's token reward for the given poll.
893   @param _voter       The address of the voter whose reward balance is to be returned
894   @param _challengeID The ID of the challenge the voter's reward is being calculated for
895   @param _salt        The salt of the voter's commit hash in the given poll
896   @return             The uint indicating the voter's reward
897   */
898   function voterReward(address _voter, uint _challengeID, uint _salt)
899   public view returns (uint) {
900     uint winningTokens = challenges[_challengeID].winningTokens;
901     uint rewardPool = challenges[_challengeID].rewardPool;
902     uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
903     return (voterTokens * rewardPool) / winningTokens;
904   }
905 
906   /**
907   @notice Determines whether a proposal passed its application stage without a challenge
908   @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
909   */
910   function canBeSet(bytes32 _propID) view public returns (bool) {
911     ParamProposal memory prop = proposals[_propID];
912 
913     return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
914   }
915 
916   /**
917   @notice Determines whether a proposal exists for the provided proposal ID
918   @param _propID The proposal ID whose existance is to be determined
919   */
920   function propExists(bytes32 _propID) view public returns (bool) {
921     return proposals[_propID].processBy > 0;
922   }
923 
924   /**
925   @notice Determines whether the provided proposal ID has a challenge which can be resolved
926   @param _propID The proposal ID whose challenge to inspect
927   */
928   function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
929     ParamProposal memory prop = proposals[_propID];
930     Challenge memory challenge = challenges[prop.challengeID];
931 
932     return (prop.challengeID > 0 && challenge.resolved == false &&
933             voting.pollEnded(prop.challengeID));
934   }
935 
936   /**
937   @notice Determines the number of tokens to awarded to the winning party in a challenge
938   @param _challengeID The challengeID to determine a reward for
939   */
940   function challengeWinnerReward(uint _challengeID) public view returns (uint) {
941     if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
942       // Edge case, nobody voted, give all tokens to the challenger.
943       return 2 * challenges[_challengeID].stake;
944     }
945 
946     return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
947   }
948 
949   /**
950   @notice gets the parameter keyed by the provided name value from the params mapping
951   @param _name the key whose value is to be determined
952   */
953   function get(string _name) public view returns (uint value) {
954     return params[keccak256(_name)];
955   }
956 
957   /**
958   @dev                Getter for Challenge tokenClaims mappings
959   @param _challengeID The challengeID to query
960   @param _voter       The voter whose claim status to query for the provided challengeID
961   */
962   function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
963     return challenges[_challengeID].tokenClaims[_voter];
964   }
965 
966   // ----------------
967   // PRIVATE FUNCTIONS
968   // ----------------
969 
970   /**
971   @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
972   @param _propID the proposal ID whose challenge is to be resolved.
973   */
974   function resolveChallenge(bytes32 _propID) private {
975     ParamProposal memory prop = proposals[_propID];
976     Challenge storage challenge = challenges[prop.challengeID];
977 
978     // winner gets back their full staked deposit, and dispensationPct*loser's stake
979     uint reward = challengeWinnerReward(prop.challengeID);
980 
981     challenge.winningTokens =
982       voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
983     challenge.resolved = true;
984 
985     if (voting.isPassed(prop.challengeID)) { // The challenge failed
986       if(prop.processBy > now) {
987         set(prop.name, prop.value);
988       }
989       _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
990       require(token.transfer(prop.owner, reward));
991     }
992     else { // The challenge succeeded or nobody voted
993       _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
994       require(token.transfer(challenges[prop.challengeID].challenger, reward));
995     }
996   }
997 
998   /**
999   @dev sets the param keted by the provided name to the provided value
1000   @param _name the name of the param to be set
1001   @param _value the value to set the param to be set
1002   */
1003   function set(string _name, uint _value) private {
1004     params[keccak256(_name)] = _value;
1005   }
1006 }
1007 
1008 // File: contracts/Registry.sol
1009 
1010 contract Registry {
1011 
1012     // ------
1013     // EVENTS
1014     // ------
1015 
1016     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data, address indexed applicant);
1017     event _Challenge(bytes32 indexed listingHash, uint challengeID, string data, uint commitEndDate, uint revealEndDate, address indexed challenger);
1018     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal, address indexed owner);
1019     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal, address indexed owner);
1020     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1021     event _ApplicationRemoved(bytes32 indexed listingHash);
1022     event _ListingRemoved(bytes32 indexed listingHash);
1023     event _ListingWithdrawn(bytes32 indexed listingHash);
1024     event _TouchAndRemoved(bytes32 indexed listingHash);
1025     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1026     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1027     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1028 
1029     using SafeMath for uint;
1030 
1031     struct Listing {
1032         uint applicationExpiry; // Expiration date of apply stage
1033         bool whitelisted;       // Indicates registry status
1034         address owner;          // Owner of Listing
1035         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1036         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1037     }
1038 
1039     struct Challenge {
1040         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1041         address challenger;     // Owner of Challenge
1042         bool resolved;          // Indication of if challenge is resolved
1043         uint stake;             // Number of tokens at stake for either party during challenge
1044         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1045         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1046     }
1047 
1048     // Maps challengeIDs to associated challenge data
1049     mapping(uint => Challenge) public challenges;
1050 
1051     // Maps listingHashes to associated listingHash data
1052     mapping(bytes32 => Listing) public listings;
1053 
1054     // Global Variables
1055     EIP20Interface public token;
1056     PLCRVoting public voting;
1057     Parameterizer public parameterizer;
1058     string public name;
1059 
1060     // ------------
1061     // CONSTRUCTOR:
1062     // ------------
1063 
1064     /**
1065     @dev Contructor         Sets the addresses for token, voting, and parameterizer
1066     @param _tokenAddr       Address of the TCR's intrinsic ERC20 token
1067     @param _plcrAddr        Address of a PLCR voting contract for the provided token
1068     @param _paramsAddr      Address of a Parameterizer contract 
1069     */
1070     function Registry(
1071         address _tokenAddr,
1072         address _plcrAddr,
1073         address _paramsAddr,
1074         string _name
1075     ) public {
1076         token = EIP20Interface(_tokenAddr);
1077         voting = PLCRVoting(_plcrAddr);
1078         parameterizer = Parameterizer(_paramsAddr);
1079         name = _name;
1080     }
1081 
1082     // --------------------
1083     // PUBLISHER INTERFACE:
1084     // --------------------
1085 
1086     /**
1087     @dev                Allows a user to start an application. Takes tokens from user and sets
1088                         apply stage end time.
1089     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1090     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1091     @param _data        Extra data relevant to the application. Think IPFS hashes.
1092     */
1093     function apply(bytes32 _listingHash, uint _amount, string _data) external {
1094         require(!isWhitelisted(_listingHash));
1095         require(!appWasMade(_listingHash));
1096         require(_amount >= parameterizer.get("minDeposit"));
1097 
1098         // Sets owner
1099         Listing storage listing = listings[_listingHash];
1100         listing.owner = msg.sender;
1101 
1102         // Sets apply stage end time
1103         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1104         listing.unstakedDeposit = _amount;
1105 
1106         // Transfers tokens from user to Registry contract
1107         require(token.transferFrom(listing.owner, this, _amount));
1108 
1109         _Application(_listingHash, _amount, listing.applicationExpiry, _data, msg.sender);
1110     }
1111 
1112     /**
1113     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1114     @param _listingHash A listingHash msg.sender is the owner of
1115     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1116     */
1117     function deposit(bytes32 _listingHash, uint _amount) external {
1118         Listing storage listing = listings[_listingHash];
1119 
1120         require(listing.owner == msg.sender);
1121 
1122         listing.unstakedDeposit += _amount;
1123         require(token.transferFrom(msg.sender, this, _amount));
1124 
1125         _Deposit(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1126     }
1127 
1128     /**
1129     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1130     @param _listingHash A listingHash msg.sender is the owner of.
1131     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1132     */
1133     function withdraw(bytes32 _listingHash, uint _amount) external {
1134         Listing storage listing = listings[_listingHash];
1135 
1136         require(listing.owner == msg.sender);
1137         require(_amount <= listing.unstakedDeposit);
1138         require(listing.unstakedDeposit - _amount >= parameterizer.get("minDeposit"));
1139 
1140         listing.unstakedDeposit -= _amount;
1141         require(token.transfer(msg.sender, _amount));
1142 
1143         _Withdrawal(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1144     }
1145 
1146     /**
1147     @dev                Allows the owner of a listingHash to remove the listingHash from the whitelist
1148                         Returns all tokens to the owner of the listingHash
1149     @param _listingHash A listingHash msg.sender is the owner of.
1150     */
1151     function exit(bytes32 _listingHash) external {
1152         Listing storage listing = listings[_listingHash];
1153 
1154         require(msg.sender == listing.owner);
1155         require(isWhitelisted(_listingHash));
1156 
1157         // Cannot exit during ongoing challenge
1158         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1159 
1160         // Remove listingHash & return tokens
1161         resetListing(_listingHash);
1162         _ListingWithdrawn(_listingHash);
1163     }
1164 
1165     // -----------------------
1166     // TOKEN HOLDER INTERFACE:
1167     // -----------------------
1168 
1169     /**
1170     @dev                Starts a poll for a listingHash which is either in the apply stage or
1171                         already in the whitelist. Tokens are taken from the challenger and the
1172                         applicant's deposits are locked.
1173     @param _listingHash The listingHash being challenged, whether listed or in application
1174     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1175     */
1176     function challenge(bytes32 _listingHash, string _data) external returns (uint challengeID) {
1177         Listing storage listing = listings[_listingHash];
1178         uint deposit = parameterizer.get("minDeposit");
1179 
1180         // Listing must be in apply stage or already on the whitelist
1181         require(appWasMade(_listingHash) || listing.whitelisted);
1182         // Prevent multiple challenges
1183         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1184 
1185         if (listing.unstakedDeposit < deposit) {
1186             // Not enough tokens, listingHash auto-delisted
1187             resetListing(_listingHash);
1188             _TouchAndRemoved(_listingHash);
1189             return 0;
1190         }
1191 
1192         // Starts poll
1193         uint pollID = voting.startPoll(
1194             parameterizer.get("voteQuorum"),
1195             parameterizer.get("commitStageLen"),
1196             parameterizer.get("revealStageLen")
1197         );
1198 
1199         challenges[pollID] = Challenge({
1200             challenger: msg.sender,
1201             rewardPool: ((100 - parameterizer.get("dispensationPct")) * deposit) / 100,
1202             stake: deposit,
1203             resolved: false,
1204             totalTokens: 0
1205         });
1206 
1207         // Updates listingHash to store most recent challenge
1208         listing.challengeID = pollID;
1209 
1210         // Locks tokens for listingHash during challenge
1211         listing.unstakedDeposit -= deposit;
1212 
1213         // Takes tokens from challenger
1214         require(token.transferFrom(msg.sender, this, deposit));
1215 
1216         var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
1217 
1218         _Challenge(_listingHash, pollID, _data, commitEndDate, revealEndDate, msg.sender);
1219         return pollID;
1220     }
1221 
1222     /**
1223     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1224                         a challenge if one exists.
1225     @param _listingHash The listingHash whose status is being updated
1226     */
1227     function updateStatus(bytes32 _listingHash) public {
1228         if (canBeWhitelisted(_listingHash)) {
1229           whitelistApplication(_listingHash);
1230         } else if (challengeCanBeResolved(_listingHash)) {
1231           resolveChallenge(_listingHash);
1232         } else {
1233           revert();
1234         }
1235     }
1236 
1237     // ----------------
1238     // TOKEN FUNCTIONS:
1239     // ----------------
1240 
1241     /**
1242     @dev                Called by a voter to claim their reward for each completed vote. Someone
1243                         must call updateStatus() before this can be called.
1244     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1245     @param _salt        The salt of a voter's commit hash in the given poll
1246     */
1247     function claimReward(uint _challengeID, uint _salt) public {
1248         // Ensures the voter has not already claimed tokens and challenge results have been processed
1249         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1250         require(challenges[_challengeID].resolved == true);
1251 
1252         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1253         uint reward = voterReward(msg.sender, _challengeID, _salt);
1254 
1255         // Subtracts the voter's information to preserve the participation ratios
1256         // of other voters compared to the remaining pool of rewards
1257         challenges[_challengeID].totalTokens -= voterTokens;
1258         challenges[_challengeID].rewardPool -= reward;
1259 
1260         // Ensures a voter cannot claim tokens again
1261         challenges[_challengeID].tokenClaims[msg.sender] = true;
1262 
1263         require(token.transfer(msg.sender, reward));
1264 
1265         _RewardClaimed(_challengeID, reward, msg.sender);
1266     }
1267 
1268     // --------
1269     // GETTERS:
1270     // --------
1271 
1272     /**
1273     @dev                Calculates the provided voter's token reward for the given poll.
1274     @param _voter       The address of the voter whose reward balance is to be returned
1275     @param _challengeID The pollID of the challenge a reward balance is being queried for
1276     @param _salt        The salt of the voter's commit hash in the given poll
1277     @return             The uint indicating the voter's reward
1278     */
1279     function voterReward(address _voter, uint _challengeID, uint _salt)
1280     public view returns (uint) {
1281         uint totalTokens = challenges[_challengeID].totalTokens;
1282         uint rewardPool = challenges[_challengeID].rewardPool;
1283         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1284         return (voterTokens * rewardPool) / totalTokens;
1285     }
1286 
1287     /**
1288     @dev                Determines whether the given listingHash be whitelisted.
1289     @param _listingHash The listingHash whose status is to be examined
1290     */
1291     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1292         uint challengeID = listings[_listingHash].challengeID;
1293 
1294         // Ensures that the application was made,
1295         // the application period has ended,
1296         // the listingHash can be whitelisted,
1297         // and either: the challengeID == 0, or the challenge has been resolved.
1298         if (
1299             appWasMade(_listingHash) &&
1300             listings[_listingHash].applicationExpiry < now &&
1301             !isWhitelisted(_listingHash) &&
1302             (challengeID == 0 || challenges[challengeID].resolved == true)
1303         ) { return true; }
1304 
1305         return false;
1306     }
1307 
1308     /**
1309     @dev                Returns true if the provided listingHash is whitelisted
1310     @param _listingHash The listingHash whose status is to be examined
1311     */
1312     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1313         return listings[_listingHash].whitelisted;
1314     }
1315 
1316     /**
1317     @dev                Returns true if apply was called for this listingHash
1318     @param _listingHash The listingHash whose status is to be examined
1319     */
1320     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1321         return listings[_listingHash].applicationExpiry > 0;
1322     }
1323 
1324     /**
1325     @dev                Returns true if the application/listingHash has an unresolved challenge
1326     @param _listingHash The listingHash whose status is to be examined
1327     */
1328     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1329         uint challengeID = listings[_listingHash].challengeID;
1330 
1331         return (listings[_listingHash].challengeID > 0 && !challenges[challengeID].resolved);
1332     }
1333 
1334     /**
1335     @dev                Determines whether voting has concluded in a challenge for a given
1336                         listingHash. Throws if no challenge exists.
1337     @param _listingHash A listingHash with an unresolved challenge
1338     */
1339     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1340         uint challengeID = listings[_listingHash].challengeID;
1341 
1342         require(challengeExists(_listingHash));
1343 
1344         return voting.pollEnded(challengeID);
1345     }
1346 
1347     /**
1348     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1349     @param _challengeID The challengeID to determine a reward for
1350     */
1351     function determineReward(uint _challengeID) public view returns (uint) {
1352         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1353 
1354         // Edge case, nobody voted, give all tokens to the challenger.
1355         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1356             return 2 * challenges[_challengeID].stake;
1357         }
1358 
1359         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1360     }
1361 
1362     /**
1363     @dev                Getter for Challenge tokenClaims mappings
1364     @param _challengeID The challengeID to query
1365     @param _voter       The voter whose claim status to query for the provided challengeID
1366     */
1367     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1368       return challenges[_challengeID].tokenClaims[_voter];
1369     }
1370 
1371     // ----------------
1372     // PRIVATE FUNCTIONS:
1373     // ----------------
1374 
1375     /**
1376     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1377                         either whitelists or de-whitelists the listingHash.
1378     @param _listingHash A listingHash with a challenge that is to be resolved
1379     */
1380     function resolveChallenge(bytes32 _listingHash) private {
1381         uint challengeID = listings[_listingHash].challengeID;
1382 
1383         // Calculates the winner's reward,
1384         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1385         uint reward = determineReward(challengeID);
1386 
1387         // Sets flag on challenge being processed
1388         challenges[challengeID].resolved = true;
1389 
1390         // Stores the total tokens used for voting by the winning side for reward purposes
1391         challenges[challengeID].totalTokens =
1392             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1393 
1394         // Case: challenge failed
1395         if (voting.isPassed(challengeID)) {
1396             whitelistApplication(_listingHash);
1397             // Unlock stake so that it can be retrieved by the applicant
1398             listings[_listingHash].unstakedDeposit += reward;
1399 
1400             _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1401         }
1402         // Case: challenge succeeded or nobody voted
1403         else {
1404             resetListing(_listingHash);
1405             // Transfer the reward to the challenger
1406             require(token.transfer(challenges[challengeID].challenger, reward));
1407 
1408             _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1409         }
1410     }
1411 
1412     /**
1413     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1414                         challenge being made. Called by resolveChallenge() if an
1415                         application/listing beat a challenge.
1416     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1417     */
1418     function whitelistApplication(bytes32 _listingHash) private {
1419         if (!listings[_listingHash].whitelisted) { _ApplicationWhitelisted(_listingHash); }
1420         listings[_listingHash].whitelisted = true;
1421     }
1422 
1423     /**
1424     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1425     @param _listingHash The listing hash to delete
1426     */
1427     function resetListing(bytes32 _listingHash) private {
1428         Listing storage listing = listings[_listingHash];
1429 
1430         // Emit events before deleting listing to check whether is whitelisted
1431         if (listing.whitelisted) {
1432             _ListingRemoved(_listingHash);
1433         } else {
1434             _ApplicationRemoved(_listingHash);
1435         }
1436 
1437         // Deleting listing to prevent reentry
1438         address owner = listing.owner;
1439         uint unstakedDeposit = listing.unstakedDeposit;
1440         delete listings[_listingHash];
1441         
1442         // Transfers any remaining balance back to the owner
1443         if (unstakedDeposit > 0){
1444             require(token.transfer(owner, unstakedDeposit));
1445         }
1446     }
1447 }