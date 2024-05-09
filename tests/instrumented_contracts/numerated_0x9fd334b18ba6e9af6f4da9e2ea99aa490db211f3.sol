1 pragma solidity^0.4.11;
2 
3 library AttributeStore {
4     struct Data {
5         mapping(bytes32 => uint) store;
6     }
7 
8     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
9     public view returns (uint) {
10         bytes32 key = keccak256(_UUID, _attrName);
11         return self.store[key];
12     }
13 
14     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
15     public {
16         bytes32 key = keccak256(_UUID, _attrName);
17         self.store[key] = _attrVal;
18     }
19 }
20 
21 
22 library DLL {
23 
24   uint constant NULL_NODE_ID = 0;
25 
26   struct Node {
27     uint next;
28     uint prev;
29   }
30 
31   struct Data {
32     mapping(uint => Node) dll;
33   }
34 
35   function isEmpty(Data storage self) public view returns (bool) {
36     return getStart(self) == NULL_NODE_ID;
37   }
38 
39   function contains(Data storage self, uint _curr) public view returns (bool) {
40     if (isEmpty(self) || _curr == NULL_NODE_ID) {
41       return false;
42     } 
43 
44     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
45     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
46     return isSingleNode || !isNullNode;
47   }
48 
49   function getNext(Data storage self, uint _curr) public view returns (uint) {
50     return self.dll[_curr].next;
51   }
52 
53   function getPrev(Data storage self, uint _curr) public view returns (uint) {
54     return self.dll[_curr].prev;
55   }
56 
57   function getStart(Data storage self) public view returns (uint) {
58     return getNext(self, NULL_NODE_ID);
59   }
60 
61   function getEnd(Data storage self) public view returns (uint) {
62     return getPrev(self, NULL_NODE_ID);
63   }
64 
65   /**
66   @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
67   the list it will be automatically removed from the old position.
68   @param _prev the node which _new will be inserted after
69   @param _curr the id of the new node being inserted
70   @param _next the node which _new will be inserted before
71   */
72   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
73     require(_curr != NULL_NODE_ID);
74 
75     remove(self, _curr);
76 
77     require(_prev == NULL_NODE_ID || contains(self, _prev));
78     require(_next == NULL_NODE_ID || contains(self, _next));
79 
80     require(getNext(self, _prev) == _next);
81     require(getPrev(self, _next) == _prev);
82 
83     self.dll[_curr].prev = _prev;
84     self.dll[_curr].next = _next;
85 
86     self.dll[_prev].next = _curr;
87     self.dll[_next].prev = _curr;
88   }
89 
90   function remove(Data storage self, uint _curr) public {
91     if (!contains(self, _curr)) {
92       return;
93     }
94 
95     uint next = getNext(self, _curr);
96     uint prev = getPrev(self, _curr);
97 
98     self.dll[next].prev = prev;
99     self.dll[prev].next = next;
100 
101     delete self.dll[_curr];
102   }
103 }
104 // Abstract contract for the full ERC 20 Token standard
105 // https://github.com/ethereum/EIPs/issues/20
106 
107 
108 contract EIP20Interface {
109     /* This is a slight change to the ERC20 base standard.
110     function totalSupply() constant returns (uint256 supply);
111     is replaced with:
112     uint256 public totalSupply;
113     This automatically creates a getter function for the totalSupply.
114     This is moved to the base contract since public getter functions are not
115     currently recognised as an implementation of the matching abstract
116     function by the compiler.
117     */
118     /// total amount of tokens
119     uint256 public totalSupply;
120 
121     /// @param _owner The address from which the balance will be retrieved
122     /// @return The balance
123     function balanceOf(address _owner) public view returns (uint256 balance);
124 
125     /// @notice send `_value` token to `_to` from `msg.sender`
126     /// @param _to The address of the recipient
127     /// @param _value The amount of token to be transferred
128     /// @return Whether the transfer was successful or not
129     function transfer(address _to, uint256 _value) public returns (bool success);
130 
131     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
132     /// @param _from The address of the sender
133     /// @param _to The address of the recipient
134     /// @param _value The amount of token to be transferred
135     /// @return Whether the transfer was successful or not
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
137 
138     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
139     /// @param _spender The address of the account able to transfer the tokens
140     /// @param _value The amount of tokens to be approved for transfer
141     /// @return Whether the approval was successful or not
142     function approve(address _spender, uint256 _value) public returns (bool success);
143 
144     /// @param _owner The address of the account owning tokens
145     /// @param _spender The address of the account able to transfer the tokens
146     /// @return Amount of remaining tokens allowed to spent
147     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
148 
149     event Transfer(address indexed _from, address indexed _to, uint256 _value);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 }
152 
153 
154 
155 
156 
157 
158 
159 
160 
161 
162 /**
163  * @title SafeMath
164  * @dev Math operations with safety checks that throw on error
165  */
166 library SafeMath {
167 
168   /**
169   * @dev Multiplies two numbers, throws on overflow.
170   */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
172     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
173     // benefit is lost if 'b' is also tested.
174     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
175     if (a == 0) {
176       return 0;
177     }
178 
179     c = a * b;
180     assert(c / a == b);
181     return c;
182   }
183 
184   /**
185   * @dev Integer division of two numbers, truncating the quotient.
186   */
187   function div(uint256 a, uint256 b) internal pure returns (uint256) {
188     // assert(b > 0); // Solidity automatically throws when dividing by 0
189     // uint256 c = a / b;
190     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191     return a / b;
192   }
193 
194   /**
195   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
196   */
197   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198     assert(b <= a);
199     return a - b;
200   }
201 
202   /**
203   * @dev Adds two numbers, throws on overflow.
204   */
205   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
206     c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }
211 
212 
213 /**
214 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
215 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
216 */
217 contract PLCRVoting {
218 
219     // ============
220     // EVENTS:
221     // ============
222 
223     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
224     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
225     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
226     event _VotingRightsGranted(uint numTokens, address indexed voter);
227     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
228     event _TokensRescued(uint indexed pollID, address indexed voter);
229 
230     // ============
231     // DATA STRUCTURES:
232     // ============
233 
234     using AttributeStore for AttributeStore.Data;
235     using DLL for DLL.Data;
236     using SafeMath for uint;
237 
238     struct Poll {
239         uint commitEndDate;     /// expiration date of commit period for poll
240         uint revealEndDate;     /// expiration date of reveal period for poll
241         uint voteQuorum;	    /// number of votes required for a proposal to pass
242         uint votesFor;		    /// tally of votes supporting proposal
243         uint votesAgainst;      /// tally of votes countering proposal
244         mapping(address => bool) didCommit;   /// indicates whether an address committed a vote for this poll
245         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
246         mapping(address => uint) voteOptions; /// stores the voteOption of an address that revealed
247     }
248 
249     // ============
250     // STATE VARIABLES:
251     // ============
252 
253     uint constant public INITIAL_POLL_NONCE = 0;
254     uint public pollNonce;
255 
256     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
257     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
258 
259     mapping(address => DLL.Data) dllMap;
260     AttributeStore.Data store;
261 
262     EIP20Interface public token;
263 
264     /**
265     @dev Initializer. Can only be called once.
266     @param _token The address where the ERC20 token contract is deployed
267     */
268     function init(address _token) public {
269         require(_token != address(0) && address(token) == address(0));
270 
271         token = EIP20Interface(_token);
272         pollNonce = INITIAL_POLL_NONCE;
273     }
274 
275     // ================
276     // TOKEN INTERFACE:
277     // ================
278 
279     /**
280     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
281     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
282     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
283     */
284     function requestVotingRights(uint _numTokens) public {
285         require(token.balanceOf(msg.sender) >= _numTokens);
286         voteTokenBalance[msg.sender] += _numTokens;
287         require(token.transferFrom(msg.sender, this, _numTokens));
288         emit _VotingRightsGranted(_numTokens, msg.sender);
289     }
290 
291     /**
292     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
293     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
294     */
295     function withdrawVotingRights(uint _numTokens) external {
296         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
297         require(availableTokens >= _numTokens);
298         voteTokenBalance[msg.sender] -= _numTokens;
299         require(token.transfer(msg.sender, _numTokens));
300         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
301     }
302 
303     /**
304     @dev Unlocks tokens locked in unrevealed vote where poll has ended
305     @param _pollID Integer identifier associated with the target poll
306     */
307     function rescueTokens(uint _pollID) public {
308         require(isExpired(pollMap[_pollID].revealEndDate));
309         require(dllMap[msg.sender].contains(_pollID));
310 
311         dllMap[msg.sender].remove(_pollID);
312         emit _TokensRescued(_pollID, msg.sender);
313     }
314 
315     /**
316     @dev Unlocks tokens locked in unrevealed votes where polls have ended
317     @param _pollIDs Array of integer identifiers associated with the target polls
318     */
319     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
320         // loop through arrays, rescuing tokens from all
321         for (uint i = 0; i < _pollIDs.length; i++) {
322             rescueTokens(_pollIDs[i]);
323         }
324     }
325 
326     // =================
327     // VOTING INTERFACE:
328     // =================
329 
330     /**
331     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
332     @param _pollID Integer identifier associated with target poll
333     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
334     @param _numTokens The number of tokens to be committed towards the target poll
335     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
336     */
337     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
338         require(commitPeriodActive(_pollID));
339 
340         // if msg.sender doesn't have enough voting rights,
341         // request for enough voting rights
342         if (voteTokenBalance[msg.sender] < _numTokens) {
343             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
344             requestVotingRights(remainder);
345         }
346 
347         // make sure msg.sender has enough voting rights
348         require(voteTokenBalance[msg.sender] >= _numTokens);
349         // prevent user from committing to zero node placeholder
350         require(_pollID != 0);
351         // prevent user from committing a secretHash of 0
352         require(_secretHash != 0);
353 
354         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
355         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
356 
357         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
358 
359         // edge case: in-place update
360         if (nextPollID == _pollID) {
361             nextPollID = dllMap[msg.sender].getNext(_pollID);
362         }
363 
364         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
365         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
366 
367         bytes32 UUID = attrUUID(msg.sender, _pollID);
368 
369         store.setAttribute(UUID, "numTokens", _numTokens);
370         store.setAttribute(UUID, "commitHash", uint(_secretHash));
371 
372         pollMap[_pollID].didCommit[msg.sender] = true;
373         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
374     }
375 
376     /**
377     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
378     @param _pollIDs         Array of integer identifiers associated with target polls
379     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
380     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
381     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
382     */
383     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
384         // make sure the array lengths are all the same
385         require(_pollIDs.length == _secretHashes.length);
386         require(_pollIDs.length == _numsTokens.length);
387         require(_pollIDs.length == _prevPollIDs.length);
388 
389         // loop through arrays, committing each individual vote values
390         for (uint i = 0; i < _pollIDs.length; i++) {
391             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
392         }
393     }
394 
395     /**
396     @dev Compares previous and next poll's committed tokens for sorting purposes
397     @param _prevID Integer identifier associated with previous poll in sorted order
398     @param _nextID Integer identifier associated with next poll in sorted order
399     @param _voter Address of user to check DLL position for
400     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
401     @return valid Boolean indication of if the specified position maintains the sort
402     */
403     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
404         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
405         // if next is zero node, _numTokens does not need to be greater
406         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
407         return prevValid && nextValid;
408     }
409 
410     /**
411     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
412     @param _pollID Integer identifier associated with target poll
413     @param _voteOption Vote choice used to generate commitHash for associated poll
414     @param _salt Secret number used to generate commitHash for associated poll
415     */
416     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
417         // Make sure the reveal period is active
418         require(revealPeriodActive(_pollID));
419         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
420         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
421         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
422 
423         uint numTokens = getNumTokens(msg.sender, _pollID);
424 
425         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
426             pollMap[_pollID].votesFor += numTokens;
427         } else {
428             pollMap[_pollID].votesAgainst += numTokens;
429         }
430 
431         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
432         pollMap[_pollID].didReveal[msg.sender] = true;
433         pollMap[_pollID].voteOptions[msg.sender] = _voteOption;
434 
435         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
436     }
437 
438     /**
439     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
440     @param _pollIDs     Array of integer identifiers associated with target polls
441     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
442     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
443     */
444     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
445         // make sure the array lengths are all the same
446         require(_pollIDs.length == _voteOptions.length);
447         require(_pollIDs.length == _salts.length);
448 
449         // loop through arrays, revealing each individual vote values
450         for (uint i = 0; i < _pollIDs.length; i++) {
451             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
452         }
453     }
454 
455     /**
456     @param _voter           Address of voter who voted in the majority bloc
457     @param _pollID          Integer identifier associated with target poll
458     @return correctVotes    Number of tokens voted for winning option
459     */
460     function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint correctVotes) {
461         require(pollEnded(_pollID));
462         require(pollMap[_pollID].didReveal[_voter]);
463 
464         uint winningChoice = isPassed(_pollID) ? 1 : 0;
465         uint voterVoteOption = pollMap[_pollID].voteOptions[_voter];
466 
467         require(voterVoteOption == winningChoice, "Voter revealed, but not in the majority");
468 
469         return getNumTokens(_voter, _pollID);
470     }
471 
472     // ==================
473     // POLLING INTERFACE:
474     // ==================
475 
476     /**
477     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
478     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
479     @param _commitDuration Length of desired commit period in seconds
480     @param _revealDuration Length of desired reveal period in seconds
481     */
482     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
483         pollNonce = pollNonce + 1;
484 
485         uint commitEndDate = block.timestamp.add(_commitDuration);
486         uint revealEndDate = commitEndDate.add(_revealDuration);
487 
488         pollMap[pollNonce] = Poll({
489             voteQuorum: _voteQuorum,
490             commitEndDate: commitEndDate,
491             revealEndDate: revealEndDate,
492             votesFor: 0,
493             votesAgainst: 0
494         });
495 
496         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
497         return pollNonce;
498     }
499 
500     /**
501     @notice Determines if proposal has passed
502     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
503     @param _pollID Integer identifier associated with target poll
504     */
505     function isPassed(uint _pollID) constant public returns (bool passed) {
506         require(pollEnded(_pollID));
507 
508         Poll memory poll = pollMap[_pollID];
509         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
510     }
511 
512     // ----------------
513     // POLLING HELPERS:
514     // ----------------
515 
516     /**
517     @dev Gets the total winning votes for reward distribution purposes
518     @param _pollID Integer identifier associated with target poll
519     @return Total number of votes committed to the winning option for specified poll
520     */
521     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
522         require(pollEnded(_pollID));
523 
524         if (isPassed(_pollID))
525             return pollMap[_pollID].votesFor;
526         else
527             return pollMap[_pollID].votesAgainst;
528     }
529 
530     /**
531     @notice Determines if poll is over
532     @dev Checks isExpired for specified poll's revealEndDate
533     @return Boolean indication of whether polling period is over
534     */
535     function pollEnded(uint _pollID) constant public returns (bool ended) {
536         require(pollExists(_pollID));
537 
538         return isExpired(pollMap[_pollID].revealEndDate);
539     }
540 
541     /**
542     @notice Checks if the commit period is still active for the specified poll
543     @dev Checks isExpired for the specified poll's commitEndDate
544     @param _pollID Integer identifier associated with target poll
545     @return Boolean indication of isCommitPeriodActive for target poll
546     */
547     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
548         require(pollExists(_pollID));
549 
550         return !isExpired(pollMap[_pollID].commitEndDate);
551     }
552 
553     /**
554     @notice Checks if the reveal period is still active for the specified poll
555     @dev Checks isExpired for the specified poll's revealEndDate
556     @param _pollID Integer identifier associated with target poll
557     */
558     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
559         require(pollExists(_pollID));
560 
561         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
562     }
563 
564     /**
565     @dev Checks if user has committed for specified poll
566     @param _voter Address of user to check against
567     @param _pollID Integer identifier associated with target poll
568     @return Boolean indication of whether user has committed
569     */
570     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
571         require(pollExists(_pollID));
572 
573         return pollMap[_pollID].didCommit[_voter];
574     }
575 
576     /**
577     @dev Checks if user has revealed for specified poll
578     @param _voter Address of user to check against
579     @param _pollID Integer identifier associated with target poll
580     @return Boolean indication of whether user has revealed
581     */
582     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
583         require(pollExists(_pollID));
584 
585         return pollMap[_pollID].didReveal[_voter];
586     }
587 
588     /**
589     @dev Checks if a poll exists
590     @param _pollID The pollID whose existance is to be evaluated.
591     @return Boolean Indicates whether a poll exists for the provided pollID
592     */
593     function pollExists(uint _pollID) constant public returns (bool exists) {
594         return (_pollID != 0 && _pollID <= pollNonce);
595     }
596 
597     // ---------------------------
598     // DOUBLE-LINKED-LIST HELPERS:
599     // ---------------------------
600 
601     /**
602     @dev Gets the bytes32 commitHash property of target poll
603     @param _voter Address of user to check against
604     @param _pollID Integer identifier associated with target poll
605     @return Bytes32 hash property attached to target poll
606     */
607     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
608         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
609     }
610 
611     /**
612     @dev Wrapper for getAttribute with attrName="numTokens"
613     @param _voter Address of user to check against
614     @param _pollID Integer identifier associated with target poll
615     @return Number of tokens committed to poll in sorted poll-linked-list
616     */
617     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
618         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
619     }
620 
621     /**
622     @dev Gets top element of sorted poll-linked-list
623     @param _voter Address of user to check against
624     @return Integer identifier to poll with maximum number of tokens committed to it
625     */
626     function getLastNode(address _voter) constant public returns (uint pollID) {
627         return dllMap[_voter].getPrev(0);
628     }
629 
630     /**
631     @dev Gets the numTokens property of getLastNode
632     @param _voter Address of user to check against
633     @return Maximum number of tokens committed in poll specified
634     */
635     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
636         return getNumTokens(_voter, getLastNode(_voter));
637     }
638 
639     /*
640     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
641     for a node with a value less than or equal to the provided _numTokens value. When such a node
642     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
643     update. In that case, return the previous node of the node being updated. Otherwise return the
644     first node that was found with a value less than or equal to the provided _numTokens.
645     @param _voter The voter whose DLL will be searched
646     @param _numTokens The value for the numTokens attribute in the node to be inserted
647     @return the node which the propoded node should be inserted after
648     */
649     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
650     constant public returns (uint prevNode) {
651         // Get the last node in the list and the number of tokens in that node
652         uint nodeID = getLastNode(_voter);
653         uint tokensInNode = getNumTokens(_voter, nodeID);
654 
655         // Iterate backwards through the list until reaching the root node
656         while(nodeID != 0) {
657             // Get the number of tokens in the current node
658             tokensInNode = getNumTokens(_voter, nodeID);
659             if(tokensInNode <= _numTokens) { // We found the insert point!
660                 if(nodeID == _pollID) {
661                     // This is an in-place update. Return the prev node of the node being updated
662                     nodeID = dllMap[_voter].getPrev(nodeID);
663                 }
664                 // Return the insert point
665                 return nodeID;
666             }
667             // We did not find the insert point. Continue iterating backwards through the list
668             nodeID = dllMap[_voter].getPrev(nodeID);
669         }
670 
671         // The list is empty, or a smaller value than anything else in the list is being inserted
672         return nodeID;
673     }
674 
675     // ----------------
676     // GENERAL HELPERS:
677     // ----------------
678 
679     /**
680     @dev Checks if an expiration date has been reached
681     @param _terminationDate Integer timestamp of date to compare current timestamp with
682     @return expired Boolean indication of whether the terminationDate has passed
683     */
684     function isExpired(uint _terminationDate) constant public returns (bool expired) {
685         return (block.timestamp > _terminationDate);
686     }
687 
688     /**
689     @dev Generates an identifier which associates a user and a poll together
690     @param _pollID Integer identifier associated with target poll
691     @return UUID Hash which is deterministic from _user and _pollID
692     */
693     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
694         return keccak256(abi.encodePacked(_user, _pollID));
695     }
696 }
697 
698 
699 
700 contract Parameterizer {
701 
702     // ------
703     // EVENTS
704     // ------
705 
706     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
707     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
708     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
709     event _ProposalExpired(bytes32 indexed propID);
710     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
711     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
712     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
713 
714 
715     // ------
716     // DATA STRUCTURES
717     // ------
718 
719     using SafeMath for uint;
720 
721     struct ParamProposal {
722         uint appExpiry;
723         uint challengeID;
724         uint deposit;
725         string name;
726         address owner;
727         uint processBy;
728         uint value;
729     }
730 
731     struct Challenge {
732         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
733         address challenger;     // owner of Challenge
734         bool resolved;          // indication of if challenge is resolved
735         uint stake;             // number of tokens at risk for either party during challenge
736         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
737         mapping(address => bool) tokenClaims;
738     }
739 
740     // ------
741     // STATE
742     // ------
743 
744     mapping(bytes32 => uint) public params;
745 
746     // maps challengeIDs to associated challenge data
747     mapping(uint => Challenge) public challenges;
748 
749     // maps pollIDs to intended data change if poll passes
750     mapping(bytes32 => ParamProposal) public proposals;
751 
752     // Global Variables
753     EIP20Interface public token;
754     PLCRVoting public voting;
755     uint public PROCESSBY = 604800; // 7 days
756 
757     /**
758     @dev Initializer        Can only be called once
759     @param _token           The address where the ERC20 token contract is deployed
760     @param _plcr            address of a PLCR voting contract for the provided token
761     @notice _parameters     array of canonical parameters
762     */
763     function init(
764         address _token,
765         address _plcr,
766         uint[] _parameters
767     ) public {
768         require(_token != 0 && address(token) == 0);
769         require(_plcr != 0 && address(voting) == 0);
770 
771         token = EIP20Interface(_token);
772         voting = PLCRVoting(_plcr);
773 
774         // minimum deposit for listing to be whitelisted
775         set("minDeposit", _parameters[0]);
776 
777         // minimum deposit to propose a reparameterization
778         set("pMinDeposit", _parameters[1]);
779 
780         // period over which applicants wait to be whitelisted
781         set("applyStageLen", _parameters[2]);
782 
783         // period over which reparmeterization proposals wait to be processed
784         set("pApplyStageLen", _parameters[3]);
785 
786         // length of commit period for voting
787         set("commitStageLen", _parameters[4]);
788 
789         // length of commit period for voting in parameterizer
790         set("pCommitStageLen", _parameters[5]);
791 
792         // length of reveal period for voting
793         set("revealStageLen", _parameters[6]);
794 
795         // length of reveal period for voting in parameterizer
796         set("pRevealStageLen", _parameters[7]);
797 
798         // percentage of losing party's deposit distributed to winning party
799         set("dispensationPct", _parameters[8]);
800 
801         // percentage of losing party's deposit distributed to winning party in parameterizer
802         set("pDispensationPct", _parameters[9]);
803 
804         // type of majority out of 100 necessary for candidate success
805         set("voteQuorum", _parameters[10]);
806 
807         // type of majority out of 100 necessary for proposal success in parameterizer
808         set("pVoteQuorum", _parameters[11]);
809 
810         // minimum length of time user has to wait to exit the registry
811         set("exitTimeDelay", _parameters[12]);
812 
813         // maximum length of time user can wait to exit the registry
814         set("exitPeriodLen", _parameters[13]);
815     }
816 
817     // -----------------------
818     // TOKEN HOLDER INTERFACE
819     // -----------------------
820 
821     /**
822     @notice propose a reparamaterization of the key _name's value to _value.
823     @param _name the name of the proposed param to be set
824     @param _value the proposed value to set the param to be set
825     */
826     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
827         uint deposit = get("pMinDeposit");
828         bytes32 propID = keccak256(abi.encodePacked(_name, _value));
829 
830         if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("dispensationPct")) ||
831             keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("pDispensationPct"))) {
832             require(_value <= 100);
833         }
834 
835         require(!propExists(propID)); // Forbid duplicate proposals
836         require(get(_name) != _value); // Forbid NOOP reparameterizations
837 
838         // attach name and value to pollID
839         proposals[propID] = ParamProposal({
840             appExpiry: now.add(get("pApplyStageLen")),
841             challengeID: 0,
842             deposit: deposit,
843             name: _name,
844             owner: msg.sender,
845             processBy: now.add(get("pApplyStageLen"))
846                 .add(get("pCommitStageLen"))
847                 .add(get("pRevealStageLen"))
848                 .add(PROCESSBY),
849             value: _value
850         });
851 
852         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
853 
854         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
855         return propID;
856     }
857 
858     /**
859     @notice challenge the provided proposal ID, and put tokens at stake to do so.
860     @param _propID the proposal ID to challenge
861     */
862     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
863         ParamProposal memory prop = proposals[_propID];
864         uint deposit = prop.deposit;
865 
866         require(propExists(_propID) && prop.challengeID == 0);
867 
868         //start poll
869         uint pollID = voting.startPoll(
870             get("pVoteQuorum"),
871             get("pCommitStageLen"),
872             get("pRevealStageLen")
873         );
874 
875         challenges[pollID] = Challenge({
876             challenger: msg.sender,
877             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
878             stake: deposit,
879             resolved: false,
880             winningTokens: 0
881         });
882 
883         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
884 
885         //take tokens from challenger
886         require(token.transferFrom(msg.sender, this, deposit));
887 
888         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
889 
890         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
891         return pollID;
892     }
893 
894     /**
895     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
896     @param _propID      the proposal ID to make a determination and state transition for
897     */
898     function processProposal(bytes32 _propID) public {
899         ParamProposal storage prop = proposals[_propID];
900         address propOwner = prop.owner;
901         uint propDeposit = prop.deposit;
902 
903 
904         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
905         // prop.owner and prop.deposit will be 0, thereby preventing theft
906         if (canBeSet(_propID)) {
907             // There is no challenge against the proposal. The processBy date for the proposal has not
908             // passed, but the proposal's appExpirty date has passed.
909             set(prop.name, prop.value);
910             emit _ProposalAccepted(_propID, prop.name, prop.value);
911             delete proposals[_propID];
912             require(token.transfer(propOwner, propDeposit));
913         } else if (challengeCanBeResolved(_propID)) {
914             // There is a challenge against the proposal.
915             resolveChallenge(_propID);
916         } else if (now > prop.processBy) {
917             // There is no challenge against the proposal, but the processBy date has passed.
918             emit _ProposalExpired(_propID);
919             delete proposals[_propID];
920             require(token.transfer(propOwner, propDeposit));
921         } else {
922             // There is no challenge against the proposal, and neither the appExpiry date nor the
923             // processBy date has passed.
924             revert();
925         }
926 
927         assert(get("dispensationPct") <= 100);
928         assert(get("pDispensationPct") <= 100);
929 
930         // verify that future proposal appExpiry and processBy times will not overflow
931         now.add(get("pApplyStageLen"))
932             .add(get("pCommitStageLen"))
933             .add(get("pRevealStageLen"))
934             .add(PROCESSBY);
935 
936         delete proposals[_propID];
937     }
938 
939     /**
940     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
941     @param _challengeID     the challenge ID to claim tokens for
942     */
943     function claimReward(uint _challengeID) public {
944         Challenge storage challenge = challenges[_challengeID];
945         // ensure voter has not already claimed tokens and challenge results have been processed
946         require(challenge.tokenClaims[msg.sender] == false);
947         require(challenge.resolved == true);
948 
949         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
950         uint reward = voterReward(msg.sender, _challengeID);
951 
952         // subtract voter's information to preserve the participation ratios of other voters
953         // compared to the remaining pool of rewards
954         challenge.winningTokens -= voterTokens;
955         challenge.rewardPool -= reward;
956 
957         // ensures a voter cannot claim tokens again
958         challenge.tokenClaims[msg.sender] = true;
959 
960         emit _RewardClaimed(_challengeID, reward, msg.sender);
961         require(token.transfer(msg.sender, reward));
962     }
963 
964     /**
965     @dev                    Called by a voter to claim their rewards for each completed vote.
966                             Someone must call updateStatus() before this can be called.
967     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
968     */
969     function claimRewards(uint[] _challengeIDs) public {
970         // loop through arrays, claiming each individual vote reward
971         for (uint i = 0; i < _challengeIDs.length; i++) {
972             claimReward(_challengeIDs[i]);
973         }
974     }
975 
976     // --------
977     // GETTERS
978     // --------
979 
980     /**
981     @dev                Calculates the provided voter's token reward for the given poll.
982     @param _voter       The address of the voter whose reward balance is to be returned
983     @param _challengeID The ID of the challenge the voter's reward is being calculated for
984     @return             The uint indicating the voter's reward
985     */
986     function voterReward(address _voter, uint _challengeID)
987     public view returns (uint) {
988         uint winningTokens = challenges[_challengeID].winningTokens;
989         uint rewardPool = challenges[_challengeID].rewardPool;
990         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
991         return (voterTokens * rewardPool) / winningTokens;
992     }
993 
994     /**
995     @notice Determines whether a proposal passed its application stage without a challenge
996     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
997     */
998     function canBeSet(bytes32 _propID) view public returns (bool) {
999         ParamProposal memory prop = proposals[_propID];
1000 
1001         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1002     }
1003 
1004     /**
1005     @notice Determines whether a proposal exists for the provided proposal ID
1006     @param _propID The proposal ID whose existance is to be determined
1007     */
1008     function propExists(bytes32 _propID) view public returns (bool) {
1009         return proposals[_propID].processBy > 0;
1010     }
1011 
1012     /**
1013     @notice Determines whether the provided proposal ID has a challenge which can be resolved
1014     @param _propID The proposal ID whose challenge to inspect
1015     */
1016     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1017         ParamProposal memory prop = proposals[_propID];
1018         Challenge memory challenge = challenges[prop.challengeID];
1019 
1020         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1021     }
1022 
1023     /**
1024     @notice Determines the number of tokens to awarded to the winning party in a challenge
1025     @param _challengeID The challengeID to determine a reward for
1026     */
1027     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1028         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1029             // Edge case, nobody voted, give all tokens to the challenger.
1030             return 2 * challenges[_challengeID].stake;
1031         }
1032 
1033         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1034     }
1035 
1036     /**
1037     @notice gets the parameter keyed by the provided name value from the params mapping
1038     @param _name the key whose value is to be determined
1039     */
1040     function get(string _name) public view returns (uint value) {
1041         return params[keccak256(abi.encodePacked(_name))];
1042     }
1043 
1044     /**
1045     @dev                Getter for Challenge tokenClaims mappings
1046     @param _challengeID The challengeID to query
1047     @param _voter       The voter whose claim status to query for the provided challengeID
1048     */
1049     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1050         return challenges[_challengeID].tokenClaims[_voter];
1051     }
1052 
1053     // ----------------
1054     // PRIVATE FUNCTIONS
1055     // ----------------
1056 
1057     /**
1058     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1059     @param _propID the proposal ID whose challenge is to be resolved.
1060     */
1061     function resolveChallenge(bytes32 _propID) private {
1062         ParamProposal memory prop = proposals[_propID];
1063         Challenge storage challenge = challenges[prop.challengeID];
1064 
1065         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1066         uint reward = challengeWinnerReward(prop.challengeID);
1067 
1068         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1069         challenge.resolved = true;
1070 
1071         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1072             if(prop.processBy > now) {
1073                 set(prop.name, prop.value);
1074             }
1075             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1076             require(token.transfer(prop.owner, reward));
1077         }
1078         else { // The challenge succeeded or nobody voted
1079             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1080             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1081         }
1082     }
1083 
1084     /**
1085     @dev sets the param keted by the provided name to the provided value
1086     @param _name the name of the param to be set
1087     @param _value the value to set the param to be set
1088     */
1089     function set(string _name, uint _value) private {
1090         params[keccak256(abi.encodePacked(_name))] = _value;
1091     }
1092 }