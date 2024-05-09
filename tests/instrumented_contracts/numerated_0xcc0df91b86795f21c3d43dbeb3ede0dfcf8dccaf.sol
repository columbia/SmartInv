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
195 // File: plcr-revival/PLCRVoting.sol
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
681 // File: contracts/Parameterizer.sol
682 
683 pragma solidity^0.4.11;
684 
685 
686 
687 
688 contract Parameterizer {
689 
690     // ------
691     // EVENTS
692     // ------
693 
694     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
695     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
696     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
697     event _ProposalExpired(bytes32 indexed propID);
698     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
699     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
700     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
701 
702 
703     // ------
704     // DATA STRUCTURES
705     // ------
706 
707     using SafeMath for uint;
708 
709     struct ParamProposal {
710         uint appExpiry;
711         uint challengeID;
712         uint deposit;
713         string name;
714         address owner;
715         uint processBy;
716         uint value;
717     }
718 
719     struct Challenge {
720         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
721         address challenger;     // owner of Challenge
722         bool resolved;          // indication of if challenge is resolved
723         uint stake;             // number of tokens at risk for either party during challenge
724         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
725         mapping(address => bool) tokenClaims;
726     }
727 
728     // ------
729     // STATE
730     // ------
731 
732     mapping(bytes32 => uint) public params;
733 
734     // maps challengeIDs to associated challenge data
735     mapping(uint => Challenge) public challenges;
736 
737     // maps pollIDs to intended data change if poll passes
738     mapping(bytes32 => ParamProposal) public proposals;
739 
740     // Global Variables
741     EIP20Interface public token;
742     PLCRVoting public voting;
743     uint public PROCESSBY = 604800; // 7 days
744 
745     /**
746     @dev Initializer        Can only be called once
747     @param _token           The address where the ERC20 token contract is deployed
748     @param _plcr            address of a PLCR voting contract for the provided token
749     @notice _parameters     array of canonical parameters
750     */
751     function init(
752         address _token,
753         address _plcr,
754         uint[] _parameters
755     ) public {
756         require(_token != 0 && address(token) == 0);
757         require(_plcr != 0 && address(voting) == 0);
758 
759         token = EIP20Interface(_token);
760         voting = PLCRVoting(_plcr);
761 
762         // minimum deposit for listing to be whitelisted
763         set("minDeposit", _parameters[0]);
764         
765         // minimum deposit to propose a reparameterization
766         set("pMinDeposit", _parameters[1]);
767 
768         // period over which applicants wait to be whitelisted
769         set("applyStageLen", _parameters[2]);
770 
771         // period over which reparmeterization proposals wait to be processed
772         set("pApplyStageLen", _parameters[3]);
773 
774         // length of commit period for voting
775         set("commitStageLen", _parameters[4]);
776         
777         // length of commit period for voting in parameterizer
778         set("pCommitStageLen", _parameters[5]);
779         
780         // length of reveal period for voting
781         set("revealStageLen", _parameters[6]);
782 
783         // length of reveal period for voting in parameterizer
784         set("pRevealStageLen", _parameters[7]);
785 
786         // percentage of losing party's deposit distributed to winning party
787         set("dispensationPct", _parameters[8]);
788 
789         // percentage of losing party's deposit distributed to winning party in parameterizer
790         set("pDispensationPct", _parameters[9]);
791 
792         // type of majority out of 100 necessary for candidate success
793         set("voteQuorum", _parameters[10]);
794 
795         // type of majority out of 100 necessary for proposal success in parameterizer
796         set("pVoteQuorum", _parameters[11]);
797     }
798 
799     // -----------------------
800     // TOKEN HOLDER INTERFACE
801     // -----------------------
802 
803     /**
804     @notice propose a reparamaterization of the key _name's value to _value.
805     @param _name the name of the proposed param to be set
806     @param _value the proposed value to set the param to be set
807     */
808     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
809         uint deposit = get("pMinDeposit");
810         bytes32 propID = keccak256(_name, _value);
811 
812         if (keccak256(_name) == keccak256("dispensationPct") ||
813             keccak256(_name) == keccak256("pDispensationPct")) {
814             require(_value <= 100);
815         }
816 
817         require(!propExists(propID)); // Forbid duplicate proposals
818         require(get(_name) != _value); // Forbid NOOP reparameterizations
819 
820         // attach name and value to pollID
821         proposals[propID] = ParamProposal({
822             appExpiry: now.add(get("pApplyStageLen")),
823             challengeID: 0,
824             deposit: deposit,
825             name: _name,
826             owner: msg.sender,
827             processBy: now.add(get("pApplyStageLen"))
828                 .add(get("pCommitStageLen"))
829                 .add(get("pRevealStageLen"))
830                 .add(PROCESSBY),
831             value: _value
832         });
833 
834         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
835 
836         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
837         return propID;
838     }
839 
840     /**
841     @notice challenge the provided proposal ID, and put tokens at stake to do so.
842     @param _propID the proposal ID to challenge
843     */
844     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
845         ParamProposal memory prop = proposals[_propID];
846         uint deposit = prop.deposit;
847 
848         require(propExists(_propID) && prop.challengeID == 0);
849 
850         //start poll
851         uint pollID = voting.startPoll(
852             get("pVoteQuorum"),
853             get("pCommitStageLen"),
854             get("pRevealStageLen")
855         );
856 
857         challenges[pollID] = Challenge({
858             challenger: msg.sender,
859             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
860             stake: deposit,
861             resolved: false,
862             winningTokens: 0
863         });
864 
865         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
866 
867         //take tokens from challenger
868         require(token.transferFrom(msg.sender, this, deposit));
869 
870         var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
871 
872         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
873         return pollID;
874     }
875 
876     /**
877     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
878     @param _propID      the proposal ID to make a determination and state transition for
879     */
880     function processProposal(bytes32 _propID) public {
881         ParamProposal storage prop = proposals[_propID];
882         address propOwner = prop.owner;
883         uint propDeposit = prop.deposit;
884 
885         
886         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
887         // prop.owner and prop.deposit will be 0, thereby preventing theft
888         if (canBeSet(_propID)) {
889             // There is no challenge against the proposal. The processBy date for the proposal has not
890             // passed, but the proposal's appExpirty date has passed.
891             set(prop.name, prop.value);
892             emit _ProposalAccepted(_propID, prop.name, prop.value);
893             delete proposals[_propID];
894             require(token.transfer(propOwner, propDeposit));
895         } else if (challengeCanBeResolved(_propID)) {
896             // There is a challenge against the proposal.
897             resolveChallenge(_propID);
898         } else if (now > prop.processBy) {
899             // There is no challenge against the proposal, but the processBy date has passed.
900             emit _ProposalExpired(_propID);
901             delete proposals[_propID];
902             require(token.transfer(propOwner, propDeposit));
903         } else {
904             // There is no challenge against the proposal, and neither the appExpiry date nor the
905             // processBy date has passed.
906             revert();
907         }
908 
909         assert(get("dispensationPct") <= 100);
910         assert(get("pDispensationPct") <= 100);
911 
912         // verify that future proposal appExpiry and processBy times will not overflow
913         now.add(get("pApplyStageLen"))
914             .add(get("pCommitStageLen"))
915             .add(get("pRevealStageLen"))
916             .add(PROCESSBY);
917 
918         delete proposals[_propID];
919     }
920 
921     /**
922     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
923     @param _challengeID     the challenge ID to claim tokens for
924     @param _salt            the salt used to vote in the challenge being withdrawn for
925     */
926     function claimReward(uint _challengeID, uint _salt) public {
927         // ensure voter has not already claimed tokens and challenge results have been processed
928         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
929         require(challenges[_challengeID].resolved == true);
930 
931         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
932         uint reward = voterReward(msg.sender, _challengeID, _salt);
933 
934         // subtract voter's information to preserve the participation ratios of other voters
935         // compared to the remaining pool of rewards
936         challenges[_challengeID].winningTokens -= voterTokens;
937         challenges[_challengeID].rewardPool -= reward;
938 
939         // ensures a voter cannot claim tokens again
940         challenges[_challengeID].tokenClaims[msg.sender] = true;
941 
942         emit _RewardClaimed(_challengeID, reward, msg.sender);
943         require(token.transfer(msg.sender, reward));
944     }
945 
946     /**
947     @dev                    Called by a voter to claim their rewards for each completed vote.
948                             Someone must call updateStatus() before this can be called.
949     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
950     @param _salts           The salts of a voter's commit hashes in the given polls
951     */
952     function claimRewards(uint[] _challengeIDs, uint[] _salts) public {
953         // make sure the array lengths are the same
954         require(_challengeIDs.length == _salts.length);
955 
956         // loop through arrays, claiming each individual vote reward
957         for (uint i = 0; i < _challengeIDs.length; i++) {
958             claimReward(_challengeIDs[i], _salts[i]);
959         }
960     }
961 
962     // --------
963     // GETTERS
964     // --------
965 
966     /**
967     @dev                Calculates the provided voter's token reward for the given poll.
968     @param _voter       The address of the voter whose reward balance is to be returned
969     @param _challengeID The ID of the challenge the voter's reward is being calculated for
970     @param _salt        The salt of the voter's commit hash in the given poll
971     @return             The uint indicating the voter's reward
972     */
973     function voterReward(address _voter, uint _challengeID, uint _salt)
974     public view returns (uint) {
975         uint winningTokens = challenges[_challengeID].winningTokens;
976         uint rewardPool = challenges[_challengeID].rewardPool;
977         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
978         return (voterTokens * rewardPool) / winningTokens;
979     }
980 
981     /**
982     @notice Determines whether a proposal passed its application stage without a challenge
983     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
984     */
985     function canBeSet(bytes32 _propID) view public returns (bool) {
986         ParamProposal memory prop = proposals[_propID];
987 
988         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
989     }
990 
991     /**
992     @notice Determines whether a proposal exists for the provided proposal ID
993     @param _propID The proposal ID whose existance is to be determined
994     */
995     function propExists(bytes32 _propID) view public returns (bool) {
996         return proposals[_propID].processBy > 0;
997     }
998 
999     /**
1000     @notice Determines whether the provided proposal ID has a challenge which can be resolved
1001     @param _propID The proposal ID whose challenge to inspect
1002     */
1003     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1004         ParamProposal memory prop = proposals[_propID];
1005         Challenge memory challenge = challenges[prop.challengeID];
1006 
1007         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1008     }
1009 
1010     /**
1011     @notice Determines the number of tokens to awarded to the winning party in a challenge
1012     @param _challengeID The challengeID to determine a reward for
1013     */
1014     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1015         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1016             // Edge case, nobody voted, give all tokens to the challenger.
1017             return 2 * challenges[_challengeID].stake;
1018         }
1019 
1020         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1021     }
1022 
1023     /**
1024     @notice gets the parameter keyed by the provided name value from the params mapping
1025     @param _name the key whose value is to be determined
1026     */
1027     function get(string _name) public view returns (uint value) {
1028         return params[keccak256(_name)];
1029     }
1030 
1031     /**
1032     @dev                Getter for Challenge tokenClaims mappings
1033     @param _challengeID The challengeID to query
1034     @param _voter       The voter whose claim status to query for the provided challengeID
1035     */
1036     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1037         return challenges[_challengeID].tokenClaims[_voter];
1038     }
1039 
1040     // ----------------
1041     // PRIVATE FUNCTIONS
1042     // ----------------
1043 
1044     /**
1045     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1046     @param _propID the proposal ID whose challenge is to be resolved.
1047     */
1048     function resolveChallenge(bytes32 _propID) private {
1049         ParamProposal memory prop = proposals[_propID];
1050         Challenge storage challenge = challenges[prop.challengeID];
1051 
1052         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1053         uint reward = challengeWinnerReward(prop.challengeID);
1054 
1055         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1056         challenge.resolved = true;
1057 
1058         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1059             if(prop.processBy > now) {
1060                 set(prop.name, prop.value);
1061             }
1062             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1063             require(token.transfer(prop.owner, reward));
1064         }
1065         else { // The challenge succeeded or nobody voted
1066             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1067             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1068         }
1069     }
1070 
1071     /**
1072     @dev sets the param keted by the provided name to the provided value
1073     @param _name the name of the param to be set
1074     @param _value the value to set the param to be set
1075     */
1076     function set(string _name, uint _value) private {
1077         params[keccak256(_name)] = _value;
1078     }
1079 }
1080 
1081 // File: plcr-revival/ProxyFactory.sol
1082 
1083 /***
1084 * Shoutouts:
1085 * 
1086 * Bytecode origin https://www.reddit.com/r/ethereum/comments/6ic49q/any_assembly_programmers_willing_to_write_a/dj5ceuw/
1087 * Modified version of Vitalik's https://www.reddit.com/r/ethereum/comments/6c1jui/delegatecall_forwarders_how_to_save_5098_on/
1088 * Credits to Jorge Izquierdo (@izqui) for coming up with this design here: https://gist.github.com/izqui/7f904443e6d19c1ab52ec7f5ad46b3a8
1089 * Credits to Stefan George (@Georgi87) for inspiration for many of the improvements from Gnosis Safe: https://github.com/gnosis/gnosis-safe-contracts
1090 * 
1091 * This version has many improvements over the original @izqui's library like using REVERT instead of THROWing on failed calls.
1092 * It also implements the awesome design pattern for initializing code as seen in Gnosis Safe Factory: https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/ProxyFactory.sol
1093 * but unlike this last one it doesn't require that you waste storage on both the proxy and the proxied contracts (v. https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/Proxy.sol#L8 & https://github.com/gnosis/gnosis-safe-contracts/blob/master/contracts/GnosisSafe.sol#L14)
1094 * 
1095 * 
1096 * v0.0.2
1097 * The proxy is now only 60 bytes long in total. Constructor included.
1098 * No functionalities were added. The change was just to make the proxy leaner.
1099 * 
1100 * v0.0.3
1101 * Thanks @dacarley for noticing the incorrect check for the subsequent call to the proxy. ?
1102 * Note: I'm creating a new version of this that doesn't need that one call.
1103 *       Will add tests and put this in its own repository soon™. 
1104 * 
1105 * v0.0.4
1106 * All the merit in this fix + update of the factory is @dacarley 's. ?
1107 * Thank you! ?
1108 *
1109 * Potential updates can be found at https://gist.github.com/GNSPS/ba7b88565c947cfd781d44cf469c2ddb
1110 * 
1111 ***/
1112 
1113 pragma solidity ^0.4.19;
1114 
1115 /* solhint-disable no-inline-assembly, indent, state-visibility, avoid-low-level-calls */
1116 
1117 contract ProxyFactory {
1118     event ProxyDeployed(address proxyAddress, address targetAddress);
1119     event ProxiesDeployed(address[] proxyAddresses, address targetAddress);
1120 
1121     function createManyProxies(uint256 _count, address _target, bytes _data)
1122         public
1123     {
1124         address[] memory proxyAddresses = new address[](_count);
1125 
1126         for (uint256 i = 0; i < _count; ++i) {
1127             proxyAddresses[i] = createProxyImpl(_target, _data);
1128         }
1129 
1130         ProxiesDeployed(proxyAddresses, _target);
1131     }
1132 
1133     function createProxy(address _target, bytes _data)
1134         public
1135         returns (address proxyContract)
1136     {
1137         proxyContract = createProxyImpl(_target, _data);
1138 
1139         ProxyDeployed(proxyContract, _target);
1140     }
1141     
1142     function createProxyImpl(address _target, bytes _data)
1143         internal
1144         returns (address proxyContract)
1145     {
1146         assembly {
1147             let contractCode := mload(0x40) // Find empty storage location using "free memory pointer"
1148            
1149             mstore(add(contractCode, 0x0b), _target) // Add target address, with a 11 bytes [i.e. 23 - (32 - 20)] offset to later accomodate first part of the bytecode
1150             mstore(sub(contractCode, 0x09), 0x000000000000000000603160008181600b9039f3600080808080368092803773) // First part of the bytecode, shifted left by 9 bytes, overwrites left padding of target address
1151             mstore(add(contractCode, 0x2b), 0x5af43d828181803e808314602f57f35bfd000000000000000000000000000000) // Final part of bytecode, offset by 43 bytes
1152 
1153             proxyContract := create(0, contractCode, 60) // total length 60 bytes
1154             if iszero(extcodesize(proxyContract)) {
1155                 revert(0, 0)
1156             }
1157            
1158             // check if the _data.length > 0 and if it is forward it to the newly created contract
1159             let dataLength := mload(_data) 
1160             if iszero(iszero(dataLength)) {
1161                 if iszero(call(gas, proxyContract, 0, add(_data, 0x20), dataLength, 0, 0)) {
1162                     revert(0, 0)
1163                 }
1164             }
1165         }
1166     }
1167 }
1168 
1169 // File: tokens/eip20/EIP20.sol
1170 
1171 /*
1172 Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
1173 .*/
1174 pragma solidity ^0.4.8;
1175 
1176 
1177 contract EIP20 is EIP20Interface {
1178 
1179     uint256 constant MAX_UINT256 = 2**256 - 1;
1180 
1181     /*
1182     NOTE:
1183     The following variables are OPTIONAL vanities. One does not have to include them.
1184     They allow one to customise the token contract & in no way influences the core functionality.
1185     Some wallets/interfaces might not even bother to look at this information.
1186     */
1187     string public name;                   //fancy name: eg Simon Bucks
1188     uint8 public decimals;                //How many decimals to show.
1189     string public symbol;                 //An identifier: eg SBX
1190 
1191      function EIP20(
1192         uint256 _initialAmount,
1193         string _tokenName,
1194         uint8 _decimalUnits,
1195         string _tokenSymbol
1196         ) public {
1197         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
1198         totalSupply = _initialAmount;                        // Update total supply
1199         name = _tokenName;                                   // Set the name for display purposes
1200         decimals = _decimalUnits;                            // Amount of decimals for display purposes
1201         symbol = _tokenSymbol;                               // Set the symbol for display purposes
1202     }
1203 
1204     function transfer(address _to, uint256 _value) public returns (bool success) {
1205         //Default assumes totalSupply can't be over max (2^256 - 1).
1206         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
1207         //Replace the if with this one instead.
1208         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
1209         require(balances[msg.sender] >= _value);
1210         balances[msg.sender] -= _value;
1211         balances[_to] += _value;
1212         Transfer(msg.sender, _to, _value);
1213         return true;
1214     }
1215 
1216     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1217         //same as above. Replace this line with the following if you want to protect against wrapping uints.
1218         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
1219         uint256 allowance = allowed[_from][msg.sender];
1220         require(balances[_from] >= _value && allowance >= _value);
1221         balances[_to] += _value;
1222         balances[_from] -= _value;
1223         if (allowance < MAX_UINT256) {
1224             allowed[_from][msg.sender] -= _value;
1225         }
1226         Transfer(_from, _to, _value);
1227         return true;
1228     }
1229 
1230     function balanceOf(address _owner) view public returns (uint256 balance) {
1231         return balances[_owner];
1232     }
1233 
1234     function approve(address _spender, uint256 _value) public returns (bool success) {
1235         allowed[msg.sender][_spender] = _value;
1236         Approval(msg.sender, _spender, _value);
1237         return true;
1238     }
1239 
1240     function allowance(address _owner, address _spender)
1241     view public returns (uint256 remaining) {
1242       return allowed[_owner][_spender];
1243     }
1244 
1245     mapping (address => uint256) balances;
1246     mapping (address => mapping (address => uint256)) allowed;
1247 }
1248 
1249 // File: plcr-revival/PLCRFactory.sol
1250 
1251 contract PLCRFactory {
1252 
1253   event newPLCR(address creator, EIP20 token, PLCRVoting plcr);
1254 
1255   ProxyFactory public proxyFactory;
1256   PLCRVoting public canonizedPLCR;
1257 
1258   /// @dev constructor deploys a new canonical PLCRVoting contract and a proxyFactory.
1259   constructor() {
1260     canonizedPLCR = new PLCRVoting();
1261     proxyFactory = new ProxyFactory();
1262   }
1263 
1264   /*
1265   @dev deploys and initializes a new PLCRVoting contract that consumes a token at an address
1266   supplied by the user.
1267   @param _token an EIP20 token to be consumed by the new PLCR contract
1268   */
1269   function newPLCRBYOToken(EIP20 _token) public returns (PLCRVoting) {
1270     PLCRVoting plcr = PLCRVoting(proxyFactory.createProxy(canonizedPLCR, ""));
1271     plcr.init(_token);
1272 
1273     emit newPLCR(msg.sender, _token, plcr);
1274 
1275     return plcr;
1276   }
1277   
1278   /*
1279   @dev deploys and initializes a new PLCRVoting contract and an EIP20 to be consumed by the PLCR's
1280   initializer.
1281   @param _supply the total number of tokens to mint in the EIP20 contract
1282   @param _name the name of the new EIP20 token
1283   @param _decimals the decimal precision to be used in rendering balances in the EIP20 token
1284   @param _symbol the symbol of the new EIP20 token
1285   */
1286   function newPLCRWithToken(
1287     uint _supply,
1288     string _name,
1289     uint8 _decimals,
1290     string _symbol
1291   ) public returns (PLCRVoting) {
1292     // Create a new token and give all the tokens to the PLCR creator
1293     EIP20 token = new EIP20(_supply, _name, _decimals, _symbol);
1294     token.transfer(msg.sender, _supply);
1295 
1296     // Create and initialize a new PLCR contract
1297     PLCRVoting plcr = PLCRVoting(proxyFactory.createProxy(canonizedPLCR, ""));
1298     plcr.init(token);
1299 
1300     emit newPLCR(msg.sender, token, plcr);
1301 
1302     return plcr;
1303   }
1304 }
1305 
1306 // File: contracts/ParameterizerFactory.sol
1307 
1308 contract ParameterizerFactory {
1309 
1310     event NewParameterizer(address creator, address token, address plcr, Parameterizer parameterizer);
1311 
1312     PLCRFactory public plcrFactory;
1313     ProxyFactory public proxyFactory;
1314     Parameterizer public canonizedParameterizer;
1315 
1316     /// @dev constructor deploys a new canonical Parameterizer contract and a proxyFactory.
1317     constructor(PLCRFactory _plcrFactory) public {
1318         plcrFactory = _plcrFactory;
1319         proxyFactory = plcrFactory.proxyFactory();
1320         canonizedParameterizer = new Parameterizer();
1321     }
1322 
1323     /*
1324     @dev deploys and initializes a new Parameterizer contract that consumes a token at an address
1325     supplied by the user.
1326     @param _token             an EIP20 token to be consumed by the new Parameterizer contract
1327     @param _plcr              a PLCR voting contract to be consumed by the new Parameterizer contract
1328     @param _parameters        array of canonical parameters
1329     */
1330     function newParameterizerBYOToken(
1331         EIP20 _token,
1332         uint[] _parameters
1333     ) public returns (Parameterizer) {
1334         PLCRVoting plcr = plcrFactory.newPLCRBYOToken(_token);
1335         Parameterizer parameterizer = Parameterizer(proxyFactory.createProxy(canonizedParameterizer, ""));
1336 
1337         parameterizer.init(
1338             _token,
1339             plcr,
1340             _parameters
1341         );
1342         emit NewParameterizer(msg.sender, _token, plcr, parameterizer);
1343         return parameterizer;
1344     }
1345 
1346     /*
1347     @dev deploys and initializes new EIP20, PLCRVoting, and Parameterizer contracts
1348     @param _supply            the total number of tokens to mint in the EIP20 contract
1349     @param _name              the name of the new EIP20 token
1350     @param _decimals          the decimal precision to be used in rendering balances in the EIP20 token
1351     @param _symbol            the symbol of the new EIP20 token
1352     @param _parameters        array of canonical parameters
1353     */
1354     function newParameterizerWithToken(
1355         uint _supply,
1356         string _name,
1357         uint8 _decimals,
1358         string _symbol,
1359         uint[] _parameters
1360     ) public returns (Parameterizer) {
1361         // Creates a new EIP20 token & transfers the supply to creator (msg.sender)
1362         // Deploys & initializes a new PLCRVoting contract
1363         PLCRVoting plcr = plcrFactory.newPLCRWithToken(_supply, _name, _decimals, _symbol);
1364         EIP20 token = EIP20(plcr.token());
1365         token.transfer(msg.sender, _supply);
1366 
1367         // Create & initialize a new Parameterizer contract
1368         Parameterizer parameterizer = Parameterizer(proxyFactory.createProxy(canonizedParameterizer, ""));
1369         parameterizer.init(
1370             token,
1371             plcr,
1372             _parameters
1373         );
1374 
1375         emit NewParameterizer(msg.sender, token, plcr, parameterizer);
1376         return parameterizer;
1377     }
1378 }
1379 
1380 // File: contracts/Registry.sol
1381 
1382 contract Registry {
1383 
1384     // ------
1385     // EVENTS
1386     // ------
1387 
1388     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data, address indexed applicant);
1389     event _Challenge(bytes32 indexed listingHash, uint challengeID, string data, uint commitEndDate, uint revealEndDate, address indexed challenger);
1390     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal, address indexed owner);
1391     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal, address indexed owner);
1392     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1393     event _ApplicationRemoved(bytes32 indexed listingHash);
1394     event _ListingRemoved(bytes32 indexed listingHash);
1395     event _ListingWithdrawn(bytes32 indexed listingHash);
1396     event _TouchAndRemoved(bytes32 indexed listingHash);
1397     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1398     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1399     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1400 
1401     using SafeMath for uint;
1402 
1403     struct Listing {
1404         uint applicationExpiry; // Expiration date of apply stage
1405         bool whitelisted;       // Indicates registry status
1406         address owner;          // Owner of Listing
1407         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1408         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1409     }
1410 
1411     struct Challenge {
1412         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1413         address challenger;     // Owner of Challenge
1414         bool resolved;          // Indication of if challenge is resolved
1415         uint stake;             // Number of tokens at stake for either party during challenge
1416         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1417         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1418     }
1419 
1420     // Maps challengeIDs to associated challenge data
1421     mapping(uint => Challenge) public challenges;
1422 
1423     // Maps listingHashes to associated listingHash data
1424     mapping(bytes32 => Listing) public listings;
1425 
1426     // Global Variables
1427     EIP20Interface public token;
1428     PLCRVoting public voting;
1429     Parameterizer public parameterizer;
1430     string public name;
1431 
1432     /**
1433     @dev Initializer. Can only be called once.
1434     @param _token The address where the ERC20 token contract is deployed
1435     */
1436     function init(address _token, address _voting, address _parameterizer, string _name) public {
1437         require(_token != 0 && address(token) == 0);
1438         require(_voting != 0 && address(voting) == 0);
1439         require(_parameterizer != 0 && address(parameterizer) == 0);
1440 
1441         token = EIP20Interface(_token);
1442         voting = PLCRVoting(_voting);
1443         parameterizer = Parameterizer(_parameterizer);
1444         name = _name;
1445     }
1446 
1447     // --------------------
1448     // PUBLISHER INTERFACE:
1449     // --------------------
1450 
1451     /**
1452     @dev                Allows a user to start an application. Takes tokens from user and sets
1453                         apply stage end time.
1454     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1455     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1456     @param _data        Extra data relevant to the application. Think IPFS hashes.
1457     */
1458     function apply(bytes32 _listingHash, uint _amount, string _data) external {
1459         require(!isWhitelisted(_listingHash));
1460         require(!appWasMade(_listingHash));
1461         require(_amount >= parameterizer.get("minDeposit"));
1462 
1463         // Sets owner
1464         Listing storage listing = listings[_listingHash];
1465         listing.owner = msg.sender;
1466 
1467         // Sets apply stage end time
1468         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1469         listing.unstakedDeposit = _amount;
1470 
1471         // Transfers tokens from user to Registry contract
1472         require(token.transferFrom(listing.owner, this, _amount));
1473 
1474         emit _Application(_listingHash, _amount, listing.applicationExpiry, _data, msg.sender);
1475     }
1476 
1477     /**
1478     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1479     @param _listingHash A listingHash msg.sender is the owner of
1480     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1481     */
1482     function deposit(bytes32 _listingHash, uint _amount) external {
1483         Listing storage listing = listings[_listingHash];
1484 
1485         require(listing.owner == msg.sender);
1486 
1487         listing.unstakedDeposit += _amount;
1488         require(token.transferFrom(msg.sender, this, _amount));
1489 
1490         emit _Deposit(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1491     }
1492 
1493     /**
1494     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1495     @param _listingHash A listingHash msg.sender is the owner of.
1496     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1497     */
1498     function withdraw(bytes32 _listingHash, uint _amount) external {
1499         Listing storage listing = listings[_listingHash];
1500 
1501         require(listing.owner == msg.sender);
1502         require(_amount <= listing.unstakedDeposit);
1503         require(listing.unstakedDeposit - _amount >= parameterizer.get("minDeposit"));
1504 
1505         listing.unstakedDeposit -= _amount;
1506         require(token.transfer(msg.sender, _amount));
1507 
1508         emit _Withdrawal(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1509     }
1510 
1511     /**
1512     @dev                Allows the owner of a listingHash to remove the listingHash from the whitelist
1513                         Returns all tokens to the owner of the listingHash
1514     @param _listingHash A listingHash msg.sender is the owner of.
1515     */
1516     function exit(bytes32 _listingHash) external {
1517         Listing storage listing = listings[_listingHash];
1518 
1519         require(msg.sender == listing.owner);
1520         require(isWhitelisted(_listingHash));
1521 
1522         // Cannot exit during ongoing challenge
1523         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1524 
1525         // Remove listingHash & return tokens
1526         resetListing(_listingHash);
1527         emit _ListingWithdrawn(_listingHash);
1528     }
1529 
1530     // -----------------------
1531     // TOKEN HOLDER INTERFACE:
1532     // -----------------------
1533 
1534     /**
1535     @dev                Starts a poll for a listingHash which is either in the apply stage or
1536                         already in the whitelist. Tokens are taken from the challenger and the
1537                         applicant's deposits are locked.
1538     @param _listingHash The listingHash being challenged, whether listed or in application
1539     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1540     */
1541     function challenge(bytes32 _listingHash, string _data) external returns (uint challengeID) {
1542         Listing storage listing = listings[_listingHash];
1543         uint minDeposit = parameterizer.get("minDeposit");
1544 
1545         // Listing must be in apply stage or already on the whitelist
1546         require(appWasMade(_listingHash) || listing.whitelisted);
1547         // Prevent multiple challenges
1548         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1549 
1550         if (listing.unstakedDeposit < minDeposit) {
1551             // Not enough tokens, listingHash auto-delisted
1552             resetListing(_listingHash);
1553             emit _TouchAndRemoved(_listingHash);
1554             return 0;
1555         }
1556 
1557         // Starts poll
1558         uint pollID = voting.startPoll(
1559             parameterizer.get("voteQuorum"),
1560             parameterizer.get("commitStageLen"),
1561             parameterizer.get("revealStageLen")
1562         );
1563 
1564         uint oneHundred = 100; // Kludge that we need to use SafeMath
1565         challenges[pollID] = Challenge({
1566             challenger: msg.sender,
1567             rewardPool: ((oneHundred.sub(parameterizer.get("dispensationPct"))).mul(minDeposit)).div(100),
1568             stake: minDeposit,
1569             resolved: false,
1570             totalTokens: 0
1571         });
1572 
1573         // Updates listingHash to store most recent challenge
1574         listing.challengeID = pollID;
1575 
1576         // Locks tokens for listingHash during challenge
1577         listing.unstakedDeposit -= minDeposit;
1578 
1579         // Takes tokens from challenger
1580         require(token.transferFrom(msg.sender, this, minDeposit));
1581 
1582         var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
1583 
1584         emit _Challenge(_listingHash, pollID, _data, commitEndDate, revealEndDate, msg.sender);
1585         return pollID;
1586     }
1587 
1588     /**
1589     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1590                         a challenge if one exists.
1591     @param _listingHash The listingHash whose status is being updated
1592     */
1593     function updateStatus(bytes32 _listingHash) public {
1594         if (canBeWhitelisted(_listingHash)) {
1595             whitelistApplication(_listingHash);
1596         } else if (challengeCanBeResolved(_listingHash)) {
1597             resolveChallenge(_listingHash);
1598         } else {
1599             revert();
1600         }
1601     }
1602 
1603     /**
1604     @dev                  Updates an array of listingHashes' status from 'application' to 'listing' or resolves
1605                           a challenge if one exists.
1606     @param _listingHashes The listingHashes whose status are being updated
1607     */
1608     function updateStatuses(bytes32[] _listingHashes) public {
1609         // loop through arrays, revealing each individual vote values
1610         for (uint i = 0; i < _listingHashes.length; i++) {
1611             updateStatus(_listingHashes[i]);
1612         }
1613     }
1614 
1615     // ----------------
1616     // TOKEN FUNCTIONS:
1617     // ----------------
1618 
1619     /**
1620     @dev                Called by a voter to claim their reward for each completed vote. Someone
1621                         must call updateStatus() before this can be called.
1622     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1623     @param _salt        The salt of a voter's commit hash in the given poll
1624     */
1625     function claimReward(uint _challengeID, uint _salt) public {
1626         // Ensures the voter has not already claimed tokens and challenge results have been processed
1627         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1628         require(challenges[_challengeID].resolved == true);
1629 
1630         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1631         uint reward = voterReward(msg.sender, _challengeID, _salt);
1632 
1633         // Subtracts the voter's information to preserve the participation ratios
1634         // of other voters compared to the remaining pool of rewards
1635         challenges[_challengeID].totalTokens -= voterTokens;
1636         challenges[_challengeID].rewardPool -= reward;
1637 
1638         // Ensures a voter cannot claim tokens again
1639         challenges[_challengeID].tokenClaims[msg.sender] = true;
1640 
1641         require(token.transfer(msg.sender, reward));
1642 
1643         emit _RewardClaimed(_challengeID, reward, msg.sender);
1644     }
1645 
1646     /**
1647     @dev                 Called by a voter to claim their rewards for each completed vote. Someone
1648                          must call updateStatus() before this can be called.
1649     @param _challengeIDs The PLCR pollIDs of the challenges rewards are being claimed for
1650     @param _salts        The salts of a voter's commit hashes in the given polls
1651     */
1652     function claimRewards(uint[] _challengeIDs, uint[] _salts) public {
1653         // make sure the array lengths are the same
1654         require(_challengeIDs.length == _salts.length);
1655 
1656         // loop through arrays, claiming each individual vote reward
1657         for (uint i = 0; i < _challengeIDs.length; i++) {
1658             claimReward(_challengeIDs[i], _salts[i]);
1659         }
1660     }
1661 
1662     // --------
1663     // GETTERS:
1664     // --------
1665 
1666     /**
1667     @dev                Calculates the provided voter's token reward for the given poll.
1668     @param _voter       The address of the voter whose reward balance is to be returned
1669     @param _challengeID The pollID of the challenge a reward balance is being queried for
1670     @param _salt        The salt of the voter's commit hash in the given poll
1671     @return             The uint indicating the voter's reward
1672     */
1673     function voterReward(address _voter, uint _challengeID, uint _salt)
1674     public view returns (uint) {
1675         uint totalTokens = challenges[_challengeID].totalTokens;
1676         uint rewardPool = challenges[_challengeID].rewardPool;
1677         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1678         return (voterTokens * rewardPool) / totalTokens;
1679     }
1680 
1681     /**
1682     @dev                Determines whether the given listingHash be whitelisted.
1683     @param _listingHash The listingHash whose status is to be examined
1684     */
1685     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1686         uint challengeID = listings[_listingHash].challengeID;
1687 
1688         // Ensures that the application was made,
1689         // the application period has ended,
1690         // the listingHash can be whitelisted,
1691         // and either: the challengeID == 0, or the challenge has been resolved.
1692         if (
1693             appWasMade(_listingHash) &&
1694             listings[_listingHash].applicationExpiry < now &&
1695             !isWhitelisted(_listingHash) &&
1696             (challengeID == 0 || challenges[challengeID].resolved == true)
1697         ) { return true; }
1698 
1699         return false;
1700     }
1701 
1702     /**
1703     @dev                Returns true if the provided listingHash is whitelisted
1704     @param _listingHash The listingHash whose status is to be examined
1705     */
1706     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1707         return listings[_listingHash].whitelisted;
1708     }
1709 
1710     /**
1711     @dev                Returns true if apply was called for this listingHash
1712     @param _listingHash The listingHash whose status is to be examined
1713     */
1714     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1715         return listings[_listingHash].applicationExpiry > 0;
1716     }
1717 
1718     /**
1719     @dev                Returns true if the application/listingHash has an unresolved challenge
1720     @param _listingHash The listingHash whose status is to be examined
1721     */
1722     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1723         uint challengeID = listings[_listingHash].challengeID;
1724 
1725         return (listings[_listingHash].challengeID > 0 && !challenges[challengeID].resolved);
1726     }
1727 
1728     /**
1729     @dev                Determines whether voting has concluded in a challenge for a given
1730                         listingHash. Throws if no challenge exists.
1731     @param _listingHash A listingHash with an unresolved challenge
1732     */
1733     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1734         uint challengeID = listings[_listingHash].challengeID;
1735 
1736         require(challengeExists(_listingHash));
1737 
1738         return voting.pollEnded(challengeID);
1739     }
1740 
1741     /**
1742     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1743     @param _challengeID The challengeID to determine a reward for
1744     */
1745     function determineReward(uint _challengeID) public view returns (uint) {
1746         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1747 
1748         // Edge case, nobody voted, give all tokens to the challenger.
1749         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1750             return 2 * challenges[_challengeID].stake;
1751         }
1752 
1753         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1754     }
1755 
1756     /**
1757     @dev                Getter for Challenge tokenClaims mappings
1758     @param _challengeID The challengeID to query
1759     @param _voter       The voter whose claim status to query for the provided challengeID
1760     */
1761     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1762         return challenges[_challengeID].tokenClaims[_voter];
1763     }
1764 
1765     // ----------------
1766     // PRIVATE FUNCTIONS:
1767     // ----------------
1768 
1769     /**
1770     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1771                         either whitelists or de-whitelists the listingHash.
1772     @param _listingHash A listingHash with a challenge that is to be resolved
1773     */
1774     function resolveChallenge(bytes32 _listingHash) private {
1775         uint challengeID = listings[_listingHash].challengeID;
1776 
1777         // Calculates the winner's reward,
1778         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1779         uint reward = determineReward(challengeID);
1780 
1781         // Sets flag on challenge being processed
1782         challenges[challengeID].resolved = true;
1783 
1784         // Stores the total tokens used for voting by the winning side for reward purposes
1785         challenges[challengeID].totalTokens =
1786             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1787 
1788         // Case: challenge failed
1789         if (voting.isPassed(challengeID)) {
1790             whitelistApplication(_listingHash);
1791             // Unlock stake so that it can be retrieved by the applicant
1792             listings[_listingHash].unstakedDeposit += reward;
1793 
1794             emit _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1795         }
1796         // Case: challenge succeeded or nobody voted
1797         else {
1798             resetListing(_listingHash);
1799             // Transfer the reward to the challenger
1800             require(token.transfer(challenges[challengeID].challenger, reward));
1801 
1802             emit _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1803         }
1804     }
1805 
1806     /**
1807     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1808                         challenge being made. Called by resolveChallenge() if an
1809                         application/listing beat a challenge.
1810     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1811     */
1812     function whitelistApplication(bytes32 _listingHash) private {
1813         if (!listings[_listingHash].whitelisted) { emit _ApplicationWhitelisted(_listingHash); }
1814         listings[_listingHash].whitelisted = true;
1815     }
1816 
1817     /**
1818     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1819     @param _listingHash The listing hash to delete
1820     */
1821     function resetListing(bytes32 _listingHash) private {
1822         Listing storage listing = listings[_listingHash];
1823 
1824         // Emit events before deleting listing to check whether is whitelisted
1825         if (listing.whitelisted) {
1826             emit _ListingRemoved(_listingHash);
1827         } else {
1828             emit _ApplicationRemoved(_listingHash);
1829         }
1830 
1831         // Deleting listing to prevent reentry
1832         address owner = listing.owner;
1833         uint unstakedDeposit = listing.unstakedDeposit;
1834         delete listings[_listingHash];
1835         
1836         // Transfers any remaining balance back to the owner
1837         if (unstakedDeposit > 0){
1838             require(token.transfer(owner, unstakedDeposit));
1839         }
1840     }
1841 }
1842 
1843 // File: contracts/RegistryFactory.sol
1844 
1845 contract RegistryFactory {
1846 
1847     event NewRegistry(address creator, EIP20 token, PLCRVoting plcr, Parameterizer parameterizer, Registry registry);
1848 
1849     ParameterizerFactory public parameterizerFactory;
1850     ProxyFactory public proxyFactory;
1851     Registry public canonizedRegistry;
1852 
1853     /// @dev constructor deploys a new proxyFactory.
1854     constructor(ParameterizerFactory _parameterizerFactory) public {
1855         parameterizerFactory = _parameterizerFactory;
1856         proxyFactory = parameterizerFactory.proxyFactory();
1857         canonizedRegistry = new Registry();
1858     }
1859 
1860     /*
1861     @dev deploys and initializes a new Registry contract that consumes a token at an address
1862         supplied by the user.
1863     @param _token           an EIP20 token to be consumed by the new Registry contract
1864     */
1865     function newRegistryBYOToken(
1866         EIP20 _token,
1867         uint[] _parameters,
1868         string _name
1869     ) public returns (Registry) {
1870         Parameterizer parameterizer = parameterizerFactory.newParameterizerBYOToken(_token, _parameters);
1871         PLCRVoting plcr = parameterizer.voting();
1872 
1873         Registry registry = Registry(proxyFactory.createProxy(canonizedRegistry, ""));
1874         registry.init(_token, plcr, parameterizer, _name);
1875 
1876         emit NewRegistry(msg.sender, _token, plcr, parameterizer, registry);
1877         return registry;
1878     }
1879 
1880     /*
1881     @dev deploys and initializes a new Registry contract, an EIP20, a PLCRVoting, and Parameterizer
1882         to be consumed by the Registry's initializer.
1883     @param _supply          the total number of tokens to mint in the EIP20 contract
1884     @param _name            the name of the new EIP20 token
1885     @param _decimals        the decimal precision to be used in rendering balances in the EIP20 token
1886     @param _symbol          the symbol of the new EIP20 token
1887     */
1888     function newRegistryWithToken(
1889         uint _supply,
1890         string _tokenName,
1891         uint8 _decimals,
1892         string _symbol,
1893         uint[] _parameters,
1894         string _registryName
1895     ) public returns (Registry) {
1896         // Creates a new EIP20 token & transfers the supply to creator (msg.sender)
1897         // Deploys & initializes (1) PLCRVoting contract & (2) Parameterizer contract
1898         Parameterizer parameterizer = parameterizerFactory.newParameterizerWithToken(_supply, _tokenName, _decimals, _symbol, _parameters);
1899         EIP20 token = EIP20(parameterizer.token());
1900         token.transfer(msg.sender, _supply);
1901         PLCRVoting plcr = parameterizer.voting();
1902 
1903         // Create & initialize a new Registry contract
1904         Registry registry = Registry(proxyFactory.createProxy(canonizedRegistry, ""));
1905         registry.init(token, plcr, parameterizer, _registryName);
1906 
1907         emit NewRegistry(msg.sender, token, plcr, parameterizer, registry);
1908         return registry;
1909     }
1910 }