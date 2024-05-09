1 pragma solidity ^0.4.20;
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
195 // File: contracts/PLCRVoting.sol
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
247     /**
248     @dev Initializer. Can only be called once.
249     @param _token The address where the ERC20 token contract is deployed
250     */
251     function init(address _token) public {
252         require(_token != 0 && address(token) == 0);
253 
254         token = EIP20Interface(_token);
255         pollNonce = INITIAL_POLL_NONCE;
256     }
257 
258     // ================
259     // TOKEN INTERFACE:
260     // ================
261 
262     /**
263     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
264     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
265     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
266     */
267     function requestVotingRights(uint _numTokens) public {
268         require(token.balanceOf(msg.sender) >= _numTokens);
269         voteTokenBalance[msg.sender] += _numTokens;
270         require(token.transferFrom(msg.sender, this, _numTokens));
271         emit _VotingRightsGranted(_numTokens, msg.sender);
272     }
273 
274     /**
275     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
276     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
277     */
278     function withdrawVotingRights(uint _numTokens) external {
279         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
280         require(availableTokens >= _numTokens);
281         voteTokenBalance[msg.sender] -= _numTokens;
282         require(token.transfer(msg.sender, _numTokens));
283         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
284     }
285 
286     /**
287     @dev Unlocks tokens locked in unrevealed vote where poll has ended
288     @param _pollID Integer identifier associated with the target poll
289     */
290     function rescueTokens(uint _pollID) public {
291         require(isExpired(pollMap[_pollID].revealEndDate));
292         require(dllMap[msg.sender].contains(_pollID));
293 
294         dllMap[msg.sender].remove(_pollID);
295         emit _TokensRescued(_pollID, msg.sender);
296     }
297 
298     /**
299     @dev Unlocks tokens locked in unrevealed votes where polls have ended
300     @param _pollIDs Array of integer identifiers associated with the target polls
301     */
302     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
303         // loop through arrays, rescuing tokens from all
304         for (uint i = 0; i < _pollIDs.length; i++) {
305             rescueTokens(_pollIDs[i]);
306         }
307     }
308 
309     // =================
310     // VOTING INTERFACE:
311     // =================
312 
313     /**
314     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
315     @param _pollID Integer identifier associated with target poll
316     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
317     @param _numTokens The number of tokens to be committed towards the target poll
318     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
319     */
320     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
321         require(commitPeriodActive(_pollID));
322 
323         // if msg.sender doesn't have enough voting rights,
324         // request for enough voting rights
325         if (voteTokenBalance[msg.sender] < _numTokens) {
326             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
327             requestVotingRights(remainder);
328         }
329 
330         // make sure msg.sender has enough voting rights
331         require(voteTokenBalance[msg.sender] >= _numTokens);
332         // prevent user from committing to zero node placeholder
333         require(_pollID != 0);
334         // prevent user from committing a secretHash of 0
335         require(_secretHash != 0);
336 
337         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
338         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
339 
340         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
341 
342         // edge case: in-place update
343         if (nextPollID == _pollID) {
344             nextPollID = dllMap[msg.sender].getNext(_pollID);
345         }
346 
347         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
348         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
349 
350         bytes32 UUID = attrUUID(msg.sender, _pollID);
351 
352         store.setAttribute(UUID, "numTokens", _numTokens);
353         store.setAttribute(UUID, "commitHash", uint(_secretHash));
354 
355         pollMap[_pollID].didCommit[msg.sender] = true;
356         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
357     }
358 
359     /**
360     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
361     @param _pollIDs         Array of integer identifiers associated with target polls
362     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
363     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
364     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
365     */
366     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
367         // make sure the array lengths are all the same
368         require(_pollIDs.length == _secretHashes.length);
369         require(_pollIDs.length == _numsTokens.length);
370         require(_pollIDs.length == _prevPollIDs.length);
371 
372         // loop through arrays, committing each individual vote values
373         for (uint i = 0; i < _pollIDs.length; i++) {
374             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
375         }
376     }
377 
378     /**
379     @dev Compares previous and next poll's committed tokens for sorting purposes
380     @param _prevID Integer identifier associated with previous poll in sorted order
381     @param _nextID Integer identifier associated with next poll in sorted order
382     @param _voter Address of user to check DLL position for
383     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
384     @return valid Boolean indication of if the specified position maintains the sort
385     */
386     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
387         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
388         // if next is zero node, _numTokens does not need to be greater
389         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
390         return prevValid && nextValid;
391     }
392 
393     /**
394     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
395     @param _pollID Integer identifier associated with target poll
396     @param _voteOption Vote choice used to generate commitHash for associated poll
397     @param _salt Secret number used to generate commitHash for associated poll
398     */
399     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
400         // Make sure the reveal period is active
401         require(revealPeriodActive(_pollID));
402         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
403         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
404         require(keccak256(_voteOption, _salt) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
405 
406         uint numTokens = getNumTokens(msg.sender, _pollID);
407 
408         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
409             pollMap[_pollID].votesFor += numTokens;
410         } else {
411             pollMap[_pollID].votesAgainst += numTokens;
412         }
413 
414         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
415         pollMap[_pollID].didReveal[msg.sender] = true;
416 
417         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender);
418     }
419 
420     /**
421     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
422     @param _pollIDs     Array of integer identifiers associated with target polls
423     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
424     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
425     */
426     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
427         // make sure the array lengths are all the same
428         require(_pollIDs.length == _voteOptions.length);
429         require(_pollIDs.length == _salts.length);
430 
431         // loop through arrays, revealing each individual vote values
432         for (uint i = 0; i < _pollIDs.length; i++) {
433             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
434         }
435     }
436 
437     /**
438     @param _pollID Integer identifier associated with target poll
439     @param _salt Arbitrarily chosen integer used to generate secretHash
440     @return correctVotes Number of tokens voted for winning option
441     */
442     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
443         require(pollEnded(_pollID));
444         require(pollMap[_pollID].didReveal[_voter]);
445 
446         uint winningChoice = isPassed(_pollID) ? 1 : 0;
447         bytes32 winnerHash = keccak256(winningChoice, _salt);
448         bytes32 commitHash = getCommitHash(_voter, _pollID);
449 
450         require(winnerHash == commitHash);
451 
452         return getNumTokens(_voter, _pollID);
453     }
454 
455     // ==================
456     // POLLING INTERFACE:
457     // ==================
458 
459     /**
460     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
461     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
462     @param _commitDuration Length of desired commit period in seconds
463     @param _revealDuration Length of desired reveal period in seconds
464     */
465     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
466         pollNonce = pollNonce + 1;
467 
468         uint commitEndDate = block.timestamp.add(_commitDuration);
469         uint revealEndDate = commitEndDate.add(_revealDuration);
470 
471         pollMap[pollNonce] = Poll({
472             voteQuorum: _voteQuorum,
473             commitEndDate: commitEndDate,
474             revealEndDate: revealEndDate,
475             votesFor: 0,
476             votesAgainst: 0
477         });
478 
479         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
480         return pollNonce;
481     }
482 
483     /**
484     @notice Determines if proposal has passed
485     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
486     @param _pollID Integer identifier associated with target poll
487     */
488     function isPassed(uint _pollID) constant public returns (bool passed) {
489         require(pollEnded(_pollID));
490 
491         Poll memory poll = pollMap[_pollID];
492         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
493     }
494 
495     // ----------------
496     // POLLING HELPERS:
497     // ----------------
498 
499     /**
500     @dev Gets the total winning votes for reward distribution purposes
501     @param _pollID Integer identifier associated with target poll
502     @return Total number of votes committed to the winning option for specified poll
503     */
504     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
505         require(pollEnded(_pollID));
506 
507         if (isPassed(_pollID))
508             return pollMap[_pollID].votesFor;
509         else
510             return pollMap[_pollID].votesAgainst;
511     }
512 
513     /**
514     @notice Determines if poll is over
515     @dev Checks isExpired for specified poll's revealEndDate
516     @return Boolean indication of whether polling period is over
517     */
518     function pollEnded(uint _pollID) constant public returns (bool ended) {
519         require(pollExists(_pollID));
520 
521         return isExpired(pollMap[_pollID].revealEndDate);
522     }
523 
524     /**
525     @notice Checks if the commit period is still active for the specified poll
526     @dev Checks isExpired for the specified poll's commitEndDate
527     @param _pollID Integer identifier associated with target poll
528     @return Boolean indication of isCommitPeriodActive for target poll
529     */
530     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
531         require(pollExists(_pollID));
532 
533         return !isExpired(pollMap[_pollID].commitEndDate);
534     }
535 
536     /**
537     @notice Checks if the reveal period is still active for the specified poll
538     @dev Checks isExpired for the specified poll's revealEndDate
539     @param _pollID Integer identifier associated with target poll
540     */
541     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
542         require(pollExists(_pollID));
543 
544         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
545     }
546 
547     /**
548     @dev Checks if user has committed for specified poll
549     @param _voter Address of user to check against
550     @param _pollID Integer identifier associated with target poll
551     @return Boolean indication of whether user has committed
552     */
553     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
554         require(pollExists(_pollID));
555 
556         return pollMap[_pollID].didCommit[_voter];
557     }
558 
559     /**
560     @dev Checks if user has revealed for specified poll
561     @param _voter Address of user to check against
562     @param _pollID Integer identifier associated with target poll
563     @return Boolean indication of whether user has revealed
564     */
565     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
566         require(pollExists(_pollID));
567 
568         return pollMap[_pollID].didReveal[_voter];
569     }
570 
571     /**
572     @dev Checks if a poll exists
573     @param _pollID The pollID whose existance is to be evaluated.
574     @return Boolean Indicates whether a poll exists for the provided pollID
575     */
576     function pollExists(uint _pollID) constant public returns (bool exists) {
577         return (_pollID != 0 && _pollID <= pollNonce);
578     }
579 
580     // ---------------------------
581     // DOUBLE-LINKED-LIST HELPERS:
582     // ---------------------------
583 
584     /**
585     @dev Gets the bytes32 commitHash property of target poll
586     @param _voter Address of user to check against
587     @param _pollID Integer identifier associated with target poll
588     @return Bytes32 hash property attached to target poll
589     */
590     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
591         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
592     }
593 
594     /**
595     @dev Wrapper for getAttribute with attrName="numTokens"
596     @param _voter Address of user to check against
597     @param _pollID Integer identifier associated with target poll
598     @return Number of tokens committed to poll in sorted poll-linked-list
599     */
600     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
601         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
602     }
603 
604     /**
605     @dev Gets top element of sorted poll-linked-list
606     @param _voter Address of user to check against
607     @return Integer identifier to poll with maximum number of tokens committed to it
608     */
609     function getLastNode(address _voter) constant public returns (uint pollID) {
610         return dllMap[_voter].getPrev(0);
611     }
612 
613     /**
614     @dev Gets the numTokens property of getLastNode
615     @param _voter Address of user to check against
616     @return Maximum number of tokens committed in poll specified
617     */
618     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
619         return getNumTokens(_voter, getLastNode(_voter));
620     }
621 
622     /*
623     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
624     for a node with a value less than or equal to the provided _numTokens value. When such a node
625     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
626     update. In that case, return the previous node of the node being updated. Otherwise return the
627     first node that was found with a value less than or equal to the provided _numTokens.
628     @param _voter The voter whose DLL will be searched
629     @param _numTokens The value for the numTokens attribute in the node to be inserted
630     @return the node which the propoded node should be inserted after
631     */
632     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
633     constant public returns (uint prevNode) {
634       // Get the last node in the list and the number of tokens in that node
635       uint nodeID = getLastNode(_voter);
636       uint tokensInNode = getNumTokens(_voter, nodeID);
637 
638       // Iterate backwards through the list until reaching the root node
639       while(nodeID != 0) {
640         // Get the number of tokens in the current node
641         tokensInNode = getNumTokens(_voter, nodeID);
642         if(tokensInNode <= _numTokens) { // We found the insert point!
643           if(nodeID == _pollID) {
644             // This is an in-place update. Return the prev node of the node being updated
645             nodeID = dllMap[_voter].getPrev(nodeID);
646           }
647           // Return the insert point
648           return nodeID; 
649         }
650         // We did not find the insert point. Continue iterating backwards through the list
651         nodeID = dllMap[_voter].getPrev(nodeID);
652       }
653 
654       // The list is empty, or a smaller value than anything else in the list is being inserted
655       return nodeID;
656     }
657 
658     // ----------------
659     // GENERAL HELPERS:
660     // ----------------
661 
662     /**
663     @dev Checks if an expiration date has been reached
664     @param _terminationDate Integer timestamp of date to compare current timestamp with
665     @return expired Boolean indication of whether the terminationDate has passed
666     */
667     function isExpired(uint _terminationDate) constant public returns (bool expired) {
668         return (block.timestamp > _terminationDate);
669     }
670 
671     /**
672     @dev Generates an identifier which associates a user and a poll together
673     @param _pollID Integer identifier associated with target poll
674     @return UUID Hash which is deterministic from _user and _pollID
675     */
676     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
677         return keccak256(_user, _pollID);
678     }
679 }
680 
681 // File: contracts/ProxyFactory.sol
682 
683 /***
684 * Shoutouts:
685 * 
686 * Bytecode origin https://www.reddit.com/r/ethereum/comments/6ic49q/any_assembly_programmers_willing_to_write_a/dj5ceuw/
687 * Modified version of Vitalik's https://www.reddit.com/r/ethereum/comments/6c1jui/delegatecall_forwarders_how_to_save_5098_on/
688 * Credits to Jorge Izquierdo (@izqui) for coming up with this design here: https://gist.github.com/izqui/7f904443e6d19c1ab52ec7f5ad46b3a8
689 * Credits to Stefan George (@Georgi87) for inspiration for many of the improvements from Gnosis Safe: https://github.com/gnosis/gnosis-safe-contracts
690 * 
691 * This version has many improvements over the original @izqui's library like using REVERT instead of THROWing on failed calls.
692 * It also implements the awesome design pattern for initializing code as seen in Gnosis Safe Factory: https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/ProxyFactory.sol
693 * but unlike this last one it doesn't require that you waste storage on both the proxy and the proxied contracts (v. https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/Proxy.sol#L8 & https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/GnosisSafe.sol#L14)
694 * 
695 * 
696 * v0.0.2
697 * The proxy is now only 60 bytes long in total. Constructor included.
698 * No functionalities were added. The change was just to make the proxy leaner.
699 * 
700 * v0.0.3
701 * Thanks @dacarley for noticing the incorrect check for the subsequent call to the proxy. ?
702 * Note: I'm creating a new version of this that doesn't need that one call.
703 *       Will add tests and put this in its own repository soon™. 
704 * 
705 * v0.0.4
706 * All the merit in this fix + update of the factory is @dacarley 's. ?
707 * Thank you! ?
708 *
709 * Potential updates can be found at https://gist.github.com/GNSPS/ba7b88565c947cfd781d44cf469c2ddb
710 * 
711 ***/
712 
713 pragma solidity ^0.4.19;
714 
715 /* solhint-disable no-inline-assembly, indent, state-visibility, avoid-low-level-calls */
716 
717 contract ProxyFactory {
718     event ProxyDeployed(address proxyAddress, address targetAddress);
719     event ProxiesDeployed(address[] proxyAddresses, address targetAddress);
720 
721     function createManyProxies(uint256 _count, address _target, bytes _data)
722         public
723     {
724         address[] memory proxyAddresses = new address[](_count);
725 
726         for (uint256 i = 0; i < _count; ++i) {
727             proxyAddresses[i] = createProxyImpl(_target, _data);
728         }
729 
730         ProxiesDeployed(proxyAddresses, _target);
731     }
732 
733     function createProxy(address _target, bytes _data)
734         public
735         returns (address proxyContract)
736     {
737         proxyContract = createProxyImpl(_target, _data);
738 
739         ProxyDeployed(proxyContract, _target);
740     }
741     
742     function createProxyImpl(address _target, bytes _data)
743         internal
744         returns (address proxyContract)
745     {
746         assembly {
747             let contractCode := mload(0x40) // Find empty storage location using "free memory pointer"
748            
749             mstore(add(contractCode, 0x0b), _target) // Add target address, with a 11 bytes [i.e. 23 - (32 - 20)] offset to later accomodate first part of the bytecode
750             mstore(sub(contractCode, 0x09), 0x000000000000000000603160008181600b9039f3600080808080368092803773) // First part of the bytecode, shifted left by 9 bytes, overwrites left padding of target address
751             mstore(add(contractCode, 0x2b), 0x5af43d828181803e808314602f57f35bfd000000000000000000000000000000) // Final part of bytecode, offset by 43 bytes
752 
753             proxyContract := create(0, contractCode, 60) // total length 60 bytes
754             if iszero(extcodesize(proxyContract)) {
755                 revert(0, 0)
756             }
757            
758             // check if the _data.length > 0 and if it is forward it to the newly created contract
759             let dataLength := mload(_data) 
760             if iszero(iszero(dataLength)) {
761                 if iszero(call(gas, proxyContract, 0, add(_data, 0x20), dataLength, 0, 0)) {
762                     revert(0, 0)
763                 }
764             }
765         }
766     }
767 }
768 
769 // File: tokens/eip20/EIP20.sol
770 
771 /*
772 Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
773 .*/
774 pragma solidity ^0.4.8;
775 
776 
777 contract EIP20 is EIP20Interface {
778 
779     uint256 constant MAX_UINT256 = 2**256 - 1;
780 
781     /*
782     NOTE:
783     The following variables are OPTIONAL vanities. One does not have to include them.
784     They allow one to customise the token contract & in no way influences the core functionality.
785     Some wallets/interfaces might not even bother to look at this information.
786     */
787     string public name;                   //fancy name: eg Simon Bucks
788     uint8 public decimals;                //How many decimals to show.
789     string public symbol;                 //An identifier: eg SBX
790 
791      function EIP20(
792         uint256 _initialAmount,
793         string _tokenName,
794         uint8 _decimalUnits,
795         string _tokenSymbol
796         ) public {
797         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
798         totalSupply = _initialAmount;                        // Update total supply
799         name = _tokenName;                                   // Set the name for display purposes
800         decimals = _decimalUnits;                            // Amount of decimals for display purposes
801         symbol = _tokenSymbol;                               // Set the symbol for display purposes
802     }
803 
804     function transfer(address _to, uint256 _value) public returns (bool success) {
805         //Default assumes totalSupply can't be over max (2^256 - 1).
806         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
807         //Replace the if with this one instead.
808         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
809         require(balances[msg.sender] >= _value);
810         balances[msg.sender] -= _value;
811         balances[_to] += _value;
812         Transfer(msg.sender, _to, _value);
813         return true;
814     }
815 
816     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
817         //same as above. Replace this line with the following if you want to protect against wrapping uints.
818         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
819         uint256 allowance = allowed[_from][msg.sender];
820         require(balances[_from] >= _value && allowance >= _value);
821         balances[_to] += _value;
822         balances[_from] -= _value;
823         if (allowance < MAX_UINT256) {
824             allowed[_from][msg.sender] -= _value;
825         }
826         Transfer(_from, _to, _value);
827         return true;
828     }
829 
830     function balanceOf(address _owner) view public returns (uint256 balance) {
831         return balances[_owner];
832     }
833 
834     function approve(address _spender, uint256 _value) public returns (bool success) {
835         allowed[msg.sender][_spender] = _value;
836         Approval(msg.sender, _spender, _value);
837         return true;
838     }
839 
840     function allowance(address _owner, address _spender)
841     view public returns (uint256 remaining) {
842       return allowed[_owner][_spender];
843     }
844 
845     mapping (address => uint256) balances;
846     mapping (address => mapping (address => uint256)) allowed;
847 }
848 
849 // File: contracts/PLCRFactory.sol
850 
851 contract PLCRFactory {
852 
853   event newPLCR(address creator, EIP20 token, PLCRVoting plcr);
854 
855   ProxyFactory public proxyFactory;
856   PLCRVoting public canonizedPLCR;
857 
858   /// @dev constructor deploys a new canonical PLCRVoting contract and a proxyFactory.
859   constructor() {
860     canonizedPLCR = new PLCRVoting();
861     proxyFactory = new ProxyFactory();
862   }
863 
864   /*
865   @dev deploys and initializes a new PLCRVoting contract that consumes a token at an address
866   supplied by the user.
867   @param _token an EIP20 token to be consumed by the new PLCR contract
868   */
869   function newPLCRBYOToken(EIP20 _token) public returns (PLCRVoting) {
870     PLCRVoting plcr = PLCRVoting(proxyFactory.createProxy(canonizedPLCR, ""));
871     plcr.init(_token);
872 
873     emit newPLCR(msg.sender, _token, plcr);
874 
875     return plcr;
876   }
877   
878   /*
879   @dev deploys and initializes a new PLCRVoting contract and an EIP20 to be consumed by the PLCR's
880   initializer.
881   @param _supply the total number of tokens to mint in the EIP20 contract
882   @param _name the name of the new EIP20 token
883   @param _decimals the decimal precision to be used in rendering balances in the EIP20 token
884   @param _symbol the symbol of the new EIP20 token
885   */
886   function newPLCRWithToken(
887     uint _supply,
888     string _name,
889     uint8 _decimals,
890     string _symbol
891   ) public returns (PLCRVoting) {
892     // Create a new token and give all the tokens to the PLCR creator
893     EIP20 token = new EIP20(_supply, _name, _decimals, _symbol);
894     token.transfer(msg.sender, _supply);
895 
896     // Create and initialize a new PLCR contract
897     PLCRVoting plcr = PLCRVoting(proxyFactory.createProxy(canonizedPLCR, ""));
898     plcr.init(token);
899 
900     emit newPLCR(msg.sender, token, plcr);
901 
902     return plcr;
903   }
904 }