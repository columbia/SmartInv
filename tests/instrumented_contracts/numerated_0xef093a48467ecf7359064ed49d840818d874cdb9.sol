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
160 /**
161  * @title SafeMath
162  * @dev Math operations with safety checks that throw on error
163  */
164 library SafeMath {
165 
166   /**
167   * @dev Multiplies two numbers, throws on overflow.
168   */
169   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
170     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
171     // benefit is lost if 'b' is also tested.
172     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
173     if (a == 0) {
174       return 0;
175     }
176 
177     c = a * b;
178     assert(c / a == b);
179     return c;
180   }
181 
182   /**
183   * @dev Integer division of two numbers, truncating the quotient.
184   */
185   function div(uint256 a, uint256 b) internal pure returns (uint256) {
186     // assert(b > 0); // Solidity automatically throws when dividing by 0
187     // uint256 c = a / b;
188     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189     return a / b;
190   }
191 
192   /**
193   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
194   */
195   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196     assert(b <= a);
197     return a - b;
198   }
199 
200   /**
201   * @dev Adds two numbers, throws on overflow.
202   */
203   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
204     c = a + b;
205     assert(c >= a);
206     return c;
207   }
208 }
209 
210 
211 /**
212 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
213 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
214 */
215 contract PLCRVoting {
216 
217     // ============
218     // EVENTS:
219     // ============
220 
221     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
222     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
223     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
224     event _VotingRightsGranted(uint numTokens, address indexed voter);
225     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
226     event _TokensRescued(uint indexed pollID, address indexed voter);
227 
228     // ============
229     // DATA STRUCTURES:
230     // ============
231 
232     using AttributeStore for AttributeStore.Data;
233     using DLL for DLL.Data;
234     using SafeMath for uint;
235 
236     struct Poll {
237         uint commitEndDate;     /// expiration date of commit period for poll
238         uint revealEndDate;     /// expiration date of reveal period for poll
239         uint voteQuorum;	    /// number of votes required for a proposal to pass
240         uint votesFor;		    /// tally of votes supporting proposal
241         uint votesAgainst;      /// tally of votes countering proposal
242         mapping(address => bool) didCommit;   /// indicates whether an address committed a vote for this poll
243         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
244         mapping(address => uint) voteOptions; /// stores the voteOption of an address that revealed
245     }
246 
247     // ============
248     // STATE VARIABLES:
249     // ============
250 
251     uint constant public INITIAL_POLL_NONCE = 0;
252     uint public pollNonce;
253 
254     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
255     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
256 
257     mapping(address => DLL.Data) dllMap;
258     AttributeStore.Data store;
259 
260     EIP20Interface public token;
261 
262     /**
263     @dev Initializer. Can only be called once.
264     @param _token The address where the ERC20 token contract is deployed
265     */
266     function init(address _token) public {
267         require(_token != address(0) && address(token) == address(0));
268 
269         token = EIP20Interface(_token);
270         pollNonce = INITIAL_POLL_NONCE;
271     }
272 
273     // ================
274     // TOKEN INTERFACE:
275     // ================
276 
277     /**
278     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
279     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
280     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
281     */
282     function requestVotingRights(uint _numTokens) public {
283         require(token.balanceOf(msg.sender) >= _numTokens);
284         voteTokenBalance[msg.sender] += _numTokens;
285         require(token.transferFrom(msg.sender, this, _numTokens));
286         emit _VotingRightsGranted(_numTokens, msg.sender);
287     }
288 
289     /**
290     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
291     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
292     */
293     function withdrawVotingRights(uint _numTokens) external {
294         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
295         require(availableTokens >= _numTokens);
296         voteTokenBalance[msg.sender] -= _numTokens;
297         require(token.transfer(msg.sender, _numTokens));
298         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
299     }
300 
301     /**
302     @dev Unlocks tokens locked in unrevealed vote where poll has ended
303     @param _pollID Integer identifier associated with the target poll
304     */
305     function rescueTokens(uint _pollID) public {
306         require(isExpired(pollMap[_pollID].revealEndDate));
307         require(dllMap[msg.sender].contains(_pollID));
308 
309         dllMap[msg.sender].remove(_pollID);
310         emit _TokensRescued(_pollID, msg.sender);
311     }
312 
313     /**
314     @dev Unlocks tokens locked in unrevealed votes where polls have ended
315     @param _pollIDs Array of integer identifiers associated with the target polls
316     */
317     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
318         // loop through arrays, rescuing tokens from all
319         for (uint i = 0; i < _pollIDs.length; i++) {
320             rescueTokens(_pollIDs[i]);
321         }
322     }
323 
324     // =================
325     // VOTING INTERFACE:
326     // =================
327 
328     /**
329     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
330     @param _pollID Integer identifier associated with target poll
331     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
332     @param _numTokens The number of tokens to be committed towards the target poll
333     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
334     */
335     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
336         require(commitPeriodActive(_pollID));
337 
338         // if msg.sender doesn't have enough voting rights,
339         // request for enough voting rights
340         if (voteTokenBalance[msg.sender] < _numTokens) {
341             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
342             requestVotingRights(remainder);
343         }
344 
345         // make sure msg.sender has enough voting rights
346         require(voteTokenBalance[msg.sender] >= _numTokens);
347         // prevent user from committing to zero node placeholder
348         require(_pollID != 0);
349         // prevent user from committing a secretHash of 0
350         require(_secretHash != 0);
351 
352         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
353         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
354 
355         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
356 
357         // edge case: in-place update
358         if (nextPollID == _pollID) {
359             nextPollID = dllMap[msg.sender].getNext(_pollID);
360         }
361 
362         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
363         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
364 
365         bytes32 UUID = attrUUID(msg.sender, _pollID);
366 
367         store.setAttribute(UUID, "numTokens", _numTokens);
368         store.setAttribute(UUID, "commitHash", uint(_secretHash));
369 
370         pollMap[_pollID].didCommit[msg.sender] = true;
371         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
372     }
373 
374     /**
375     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
376     @param _pollIDs         Array of integer identifiers associated with target polls
377     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
378     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
379     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
380     */
381     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
382         // make sure the array lengths are all the same
383         require(_pollIDs.length == _secretHashes.length);
384         require(_pollIDs.length == _numsTokens.length);
385         require(_pollIDs.length == _prevPollIDs.length);
386 
387         // loop through arrays, committing each individual vote values
388         for (uint i = 0; i < _pollIDs.length; i++) {
389             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
390         }
391     }
392 
393     /**
394     @dev Compares previous and next poll's committed tokens for sorting purposes
395     @param _prevID Integer identifier associated with previous poll in sorted order
396     @param _nextID Integer identifier associated with next poll in sorted order
397     @param _voter Address of user to check DLL position for
398     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
399     @return valid Boolean indication of if the specified position maintains the sort
400     */
401     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
402         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
403         // if next is zero node, _numTokens does not need to be greater
404         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
405         return prevValid && nextValid;
406     }
407 
408     /**
409     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
410     @param _pollID Integer identifier associated with target poll
411     @param _voteOption Vote choice used to generate commitHash for associated poll
412     @param _salt Secret number used to generate commitHash for associated poll
413     */
414     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
415         // Make sure the reveal period is active
416         require(revealPeriodActive(_pollID));
417         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
418         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
419         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
420 
421         uint numTokens = getNumTokens(msg.sender, _pollID);
422 
423         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
424             pollMap[_pollID].votesFor += numTokens;
425         } else {
426             pollMap[_pollID].votesAgainst += numTokens;
427         }
428 
429         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
430         pollMap[_pollID].didReveal[msg.sender] = true;
431         pollMap[_pollID].voteOptions[msg.sender] = _voteOption;
432 
433         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
434     }
435 
436     /**
437     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
438     @param _pollIDs     Array of integer identifiers associated with target polls
439     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
440     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
441     */
442     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
443         // make sure the array lengths are all the same
444         require(_pollIDs.length == _voteOptions.length);
445         require(_pollIDs.length == _salts.length);
446 
447         // loop through arrays, revealing each individual vote values
448         for (uint i = 0; i < _pollIDs.length; i++) {
449             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
450         }
451     }
452 
453     /**
454     @param _voter           Address of voter who voted in the majority bloc
455     @param _pollID          Integer identifier associated with target poll
456     @return correctVotes    Number of tokens voted for winning option
457     */
458     function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint correctVotes) {
459         require(pollEnded(_pollID));
460         require(pollMap[_pollID].didReveal[_voter]);
461 
462         uint winningChoice = isPassed(_pollID) ? 1 : 0;
463         uint voterVoteOption = pollMap[_pollID].voteOptions[_voter];
464 
465         require(voterVoteOption == winningChoice, "Voter revealed, but not in the majority");
466 
467         return getNumTokens(_voter, _pollID);
468     }
469 
470     // ==================
471     // POLLING INTERFACE:
472     // ==================
473 
474     /**
475     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
476     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
477     @param _commitDuration Length of desired commit period in seconds
478     @param _revealDuration Length of desired reveal period in seconds
479     */
480     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
481         pollNonce = pollNonce + 1;
482 
483         uint commitEndDate = block.timestamp.add(_commitDuration);
484         uint revealEndDate = commitEndDate.add(_revealDuration);
485 
486         pollMap[pollNonce] = Poll({
487             voteQuorum: _voteQuorum,
488             commitEndDate: commitEndDate,
489             revealEndDate: revealEndDate,
490             votesFor: 0,
491             votesAgainst: 0
492         });
493 
494         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
495         return pollNonce;
496     }
497 
498     /**
499     @notice Determines if proposal has passed
500     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
501     @param _pollID Integer identifier associated with target poll
502     */
503     function isPassed(uint _pollID) constant public returns (bool passed) {
504         require(pollEnded(_pollID));
505 
506         Poll memory poll = pollMap[_pollID];
507         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
508     }
509 
510     // ----------------
511     // POLLING HELPERS:
512     // ----------------
513 
514     /**
515     @dev Gets the total winning votes for reward distribution purposes
516     @param _pollID Integer identifier associated with target poll
517     @return Total number of votes committed to the winning option for specified poll
518     */
519     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
520         require(pollEnded(_pollID));
521 
522         if (isPassed(_pollID))
523             return pollMap[_pollID].votesFor;
524         else
525             return pollMap[_pollID].votesAgainst;
526     }
527 
528     /**
529     @notice Determines if poll is over
530     @dev Checks isExpired for specified poll's revealEndDate
531     @return Boolean indication of whether polling period is over
532     */
533     function pollEnded(uint _pollID) constant public returns (bool ended) {
534         require(pollExists(_pollID));
535 
536         return isExpired(pollMap[_pollID].revealEndDate);
537     }
538 
539     /**
540     @notice Checks if the commit period is still active for the specified poll
541     @dev Checks isExpired for the specified poll's commitEndDate
542     @param _pollID Integer identifier associated with target poll
543     @return Boolean indication of isCommitPeriodActive for target poll
544     */
545     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
546         require(pollExists(_pollID));
547 
548         return !isExpired(pollMap[_pollID].commitEndDate);
549     }
550 
551     /**
552     @notice Checks if the reveal period is still active for the specified poll
553     @dev Checks isExpired for the specified poll's revealEndDate
554     @param _pollID Integer identifier associated with target poll
555     */
556     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
557         require(pollExists(_pollID));
558 
559         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
560     }
561 
562     /**
563     @dev Checks if user has committed for specified poll
564     @param _voter Address of user to check against
565     @param _pollID Integer identifier associated with target poll
566     @return Boolean indication of whether user has committed
567     */
568     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
569         require(pollExists(_pollID));
570 
571         return pollMap[_pollID].didCommit[_voter];
572     }
573 
574     /**
575     @dev Checks if user has revealed for specified poll
576     @param _voter Address of user to check against
577     @param _pollID Integer identifier associated with target poll
578     @return Boolean indication of whether user has revealed
579     */
580     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
581         require(pollExists(_pollID));
582 
583         return pollMap[_pollID].didReveal[_voter];
584     }
585 
586     /**
587     @dev Checks if a poll exists
588     @param _pollID The pollID whose existance is to be evaluated.
589     @return Boolean Indicates whether a poll exists for the provided pollID
590     */
591     function pollExists(uint _pollID) constant public returns (bool exists) {
592         return (_pollID != 0 && _pollID <= pollNonce);
593     }
594 
595     // ---------------------------
596     // DOUBLE-LINKED-LIST HELPERS:
597     // ---------------------------
598 
599     /**
600     @dev Gets the bytes32 commitHash property of target poll
601     @param _voter Address of user to check against
602     @param _pollID Integer identifier associated with target poll
603     @return Bytes32 hash property attached to target poll
604     */
605     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
606         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
607     }
608 
609     /**
610     @dev Wrapper for getAttribute with attrName="numTokens"
611     @param _voter Address of user to check against
612     @param _pollID Integer identifier associated with target poll
613     @return Number of tokens committed to poll in sorted poll-linked-list
614     */
615     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
616         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
617     }
618 
619     /**
620     @dev Gets top element of sorted poll-linked-list
621     @param _voter Address of user to check against
622     @return Integer identifier to poll with maximum number of tokens committed to it
623     */
624     function getLastNode(address _voter) constant public returns (uint pollID) {
625         return dllMap[_voter].getPrev(0);
626     }
627 
628     /**
629     @dev Gets the numTokens property of getLastNode
630     @param _voter Address of user to check against
631     @return Maximum number of tokens committed in poll specified
632     */
633     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
634         return getNumTokens(_voter, getLastNode(_voter));
635     }
636 
637     /*
638     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
639     for a node with a value less than or equal to the provided _numTokens value. When such a node
640     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
641     update. In that case, return the previous node of the node being updated. Otherwise return the
642     first node that was found with a value less than or equal to the provided _numTokens.
643     @param _voter The voter whose DLL will be searched
644     @param _numTokens The value for the numTokens attribute in the node to be inserted
645     @return the node which the propoded node should be inserted after
646     */
647     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
648     constant public returns (uint prevNode) {
649         // Get the last node in the list and the number of tokens in that node
650         uint nodeID = getLastNode(_voter);
651         uint tokensInNode = getNumTokens(_voter, nodeID);
652 
653         // Iterate backwards through the list until reaching the root node
654         while(nodeID != 0) {
655             // Get the number of tokens in the current node
656             tokensInNode = getNumTokens(_voter, nodeID);
657             if(tokensInNode <= _numTokens) { // We found the insert point!
658                 if(nodeID == _pollID) {
659                     // This is an in-place update. Return the prev node of the node being updated
660                     nodeID = dllMap[_voter].getPrev(nodeID);
661                 }
662                 // Return the insert point
663                 return nodeID;
664             }
665             // We did not find the insert point. Continue iterating backwards through the list
666             nodeID = dllMap[_voter].getPrev(nodeID);
667         }
668 
669         // The list is empty, or a smaller value than anything else in the list is being inserted
670         return nodeID;
671     }
672 
673     // ----------------
674     // GENERAL HELPERS:
675     // ----------------
676 
677     /**
678     @dev Checks if an expiration date has been reached
679     @param _terminationDate Integer timestamp of date to compare current timestamp with
680     @return expired Boolean indication of whether the terminationDate has passed
681     */
682     function isExpired(uint _terminationDate) constant public returns (bool expired) {
683         return (block.timestamp > _terminationDate);
684     }
685 
686     /**
687     @dev Generates an identifier which associates a user and a poll together
688     @param _pollID Integer identifier associated with target poll
689     @return UUID Hash which is deterministic from _user and _pollID
690     */
691     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
692         return keccak256(abi.encodePacked(_user, _pollID));
693     }
694 }
695 
696 
697 
698 
699 
700 
701 
702 contract Parameterizer {
703 
704     // ------
705     // EVENTS
706     // ------
707 
708     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
709     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
710     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
711     event _ProposalExpired(bytes32 indexed propID);
712     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
713     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
714     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
715 
716 
717     // ------
718     // DATA STRUCTURES
719     // ------
720 
721     using SafeMath for uint;
722 
723     struct ParamProposal {
724         uint appExpiry;
725         uint challengeID;
726         uint deposit;
727         string name;
728         address owner;
729         uint processBy;
730         uint value;
731     }
732 
733     struct Challenge {
734         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
735         address challenger;     // owner of Challenge
736         bool resolved;          // indication of if challenge is resolved
737         uint stake;             // number of tokens at risk for either party during challenge
738         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
739         mapping(address => bool) tokenClaims;
740     }
741 
742     // ------
743     // STATE
744     // ------
745 
746     mapping(bytes32 => uint) public params;
747 
748     // maps challengeIDs to associated challenge data
749     mapping(uint => Challenge) public challenges;
750 
751     // maps pollIDs to intended data change if poll passes
752     mapping(bytes32 => ParamProposal) public proposals;
753 
754     // Global Variables
755     EIP20Interface public token;
756     PLCRVoting public voting;
757     uint public PROCESSBY = 604800; // 7 days
758 
759     /**
760     @dev Initializer        Can only be called once
761     @param _token           The address where the ERC20 token contract is deployed
762     @param _plcr            address of a PLCR voting contract for the provided token
763     @notice _parameters     array of canonical parameters
764     */
765     function init(
766         address _token,
767         address _plcr,
768         uint[] _parameters
769     ) public {
770         require(_token != 0 && address(token) == 0);
771         require(_plcr != 0 && address(voting) == 0);
772 
773         token = EIP20Interface(_token);
774         voting = PLCRVoting(_plcr);
775 
776         // minimum deposit for listing to be whitelisted
777         set("minDeposit", _parameters[0]);
778 
779         // minimum deposit to propose a reparameterization
780         set("pMinDeposit", _parameters[1]);
781 
782         // period over which applicants wait to be whitelisted
783         set("applyStageLen", _parameters[2]);
784 
785         // period over which reparmeterization proposals wait to be processed
786         set("pApplyStageLen", _parameters[3]);
787 
788         // length of commit period for voting
789         set("commitStageLen", _parameters[4]);
790 
791         // length of commit period for voting in parameterizer
792         set("pCommitStageLen", _parameters[5]);
793 
794         // length of reveal period for voting
795         set("revealStageLen", _parameters[6]);
796 
797         // length of reveal period for voting in parameterizer
798         set("pRevealStageLen", _parameters[7]);
799 
800         // percentage of losing party's deposit distributed to winning party
801         set("dispensationPct", _parameters[8]);
802 
803         // percentage of losing party's deposit distributed to winning party in parameterizer
804         set("pDispensationPct", _parameters[9]);
805 
806         // type of majority out of 100 necessary for candidate success
807         set("voteQuorum", _parameters[10]);
808 
809         // type of majority out of 100 necessary for proposal success in parameterizer
810         set("pVoteQuorum", _parameters[11]);
811 
812         // minimum length of time user has to wait to exit the registry
813         set("exitTimeDelay", _parameters[12]);
814 
815         // maximum length of time user can wait to exit the registry
816         set("exitPeriodLen", _parameters[13]);
817     }
818 
819     // -----------------------
820     // TOKEN HOLDER INTERFACE
821     // -----------------------
822 
823     /**
824     @notice propose a reparamaterization of the key _name's value to _value.
825     @param _name the name of the proposed param to be set
826     @param _value the proposed value to set the param to be set
827     */
828     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
829         uint deposit = get("pMinDeposit");
830         bytes32 propID = keccak256(abi.encodePacked(_name, _value));
831 
832         if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("dispensationPct")) ||
833             keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("pDispensationPct"))) {
834             require(_value <= 100);
835         }
836 
837         require(!propExists(propID)); // Forbid duplicate proposals
838         require(get(_name) != _value); // Forbid NOOP reparameterizations
839 
840         // attach name and value to pollID
841         proposals[propID] = ParamProposal({
842             appExpiry: now.add(get("pApplyStageLen")),
843             challengeID: 0,
844             deposit: deposit,
845             name: _name,
846             owner: msg.sender,
847             processBy: now.add(get("pApplyStageLen"))
848                 .add(get("pCommitStageLen"))
849                 .add(get("pRevealStageLen"))
850                 .add(PROCESSBY),
851             value: _value
852         });
853 
854         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
855 
856         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
857         return propID;
858     }
859 
860     /**
861     @notice challenge the provided proposal ID, and put tokens at stake to do so.
862     @param _propID the proposal ID to challenge
863     */
864     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
865         ParamProposal memory prop = proposals[_propID];
866         uint deposit = prop.deposit;
867 
868         require(propExists(_propID) && prop.challengeID == 0);
869 
870         //start poll
871         uint pollID = voting.startPoll(
872             get("pVoteQuorum"),
873             get("pCommitStageLen"),
874             get("pRevealStageLen")
875         );
876 
877         challenges[pollID] = Challenge({
878             challenger: msg.sender,
879             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
880             stake: deposit,
881             resolved: false,
882             winningTokens: 0
883         });
884 
885         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
886 
887         //take tokens from challenger
888         require(token.transferFrom(msg.sender, this, deposit));
889 
890         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
891 
892         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
893         return pollID;
894     }
895 
896     /**
897     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
898     @param _propID      the proposal ID to make a determination and state transition for
899     */
900     function processProposal(bytes32 _propID) public {
901         ParamProposal storage prop = proposals[_propID];
902         address propOwner = prop.owner;
903         uint propDeposit = prop.deposit;
904 
905 
906         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
907         // prop.owner and prop.deposit will be 0, thereby preventing theft
908         if (canBeSet(_propID)) {
909             // There is no challenge against the proposal. The processBy date for the proposal has not
910             // passed, but the proposal's appExpirty date has passed.
911             set(prop.name, prop.value);
912             emit _ProposalAccepted(_propID, prop.name, prop.value);
913             delete proposals[_propID];
914             require(token.transfer(propOwner, propDeposit));
915         } else if (challengeCanBeResolved(_propID)) {
916             // There is a challenge against the proposal.
917             resolveChallenge(_propID);
918         } else if (now > prop.processBy) {
919             // There is no challenge against the proposal, but the processBy date has passed.
920             emit _ProposalExpired(_propID);
921             delete proposals[_propID];
922             require(token.transfer(propOwner, propDeposit));
923         } else {
924             // There is no challenge against the proposal, and neither the appExpiry date nor the
925             // processBy date has passed.
926             revert();
927         }
928 
929         assert(get("dispensationPct") <= 100);
930         assert(get("pDispensationPct") <= 100);
931 
932         // verify that future proposal appExpiry and processBy times will not overflow
933         now.add(get("pApplyStageLen"))
934             .add(get("pCommitStageLen"))
935             .add(get("pRevealStageLen"))
936             .add(PROCESSBY);
937 
938         delete proposals[_propID];
939     }
940 
941     /**
942     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
943     @param _challengeID     the challenge ID to claim tokens for
944     */
945     function claimReward(uint _challengeID) public {
946         Challenge storage challenge = challenges[_challengeID];
947         // ensure voter has not already claimed tokens and challenge results have been processed
948         require(challenge.tokenClaims[msg.sender] == false);
949         require(challenge.resolved == true);
950 
951         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
952         uint reward = voterReward(msg.sender, _challengeID);
953 
954         // subtract voter's information to preserve the participation ratios of other voters
955         // compared to the remaining pool of rewards
956         challenge.winningTokens -= voterTokens;
957         challenge.rewardPool -= reward;
958 
959         // ensures a voter cannot claim tokens again
960         challenge.tokenClaims[msg.sender] = true;
961 
962         emit _RewardClaimed(_challengeID, reward, msg.sender);
963         require(token.transfer(msg.sender, reward));
964     }
965 
966     /**
967     @dev                    Called by a voter to claim their rewards for each completed vote.
968                             Someone must call updateStatus() before this can be called.
969     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
970     */
971     function claimRewards(uint[] _challengeIDs) public {
972         // loop through arrays, claiming each individual vote reward
973         for (uint i = 0; i < _challengeIDs.length; i++) {
974             claimReward(_challengeIDs[i]);
975         }
976     }
977 
978     // --------
979     // GETTERS
980     // --------
981 
982     /**
983     @dev                Calculates the provided voter's token reward for the given poll.
984     @param _voter       The address of the voter whose reward balance is to be returned
985     @param _challengeID The ID of the challenge the voter's reward is being calculated for
986     @return             The uint indicating the voter's reward
987     */
988     function voterReward(address _voter, uint _challengeID)
989     public view returns (uint) {
990         uint winningTokens = challenges[_challengeID].winningTokens;
991         uint rewardPool = challenges[_challengeID].rewardPool;
992         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
993         return (voterTokens * rewardPool) / winningTokens;
994     }
995 
996     /**
997     @notice Determines whether a proposal passed its application stage without a challenge
998     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
999     */
1000     function canBeSet(bytes32 _propID) view public returns (bool) {
1001         ParamProposal memory prop = proposals[_propID];
1002 
1003         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1004     }
1005 
1006     /**
1007     @notice Determines whether a proposal exists for the provided proposal ID
1008     @param _propID The proposal ID whose existance is to be determined
1009     */
1010     function propExists(bytes32 _propID) view public returns (bool) {
1011         return proposals[_propID].processBy > 0;
1012     }
1013 
1014     /**
1015     @notice Determines whether the provided proposal ID has a challenge which can be resolved
1016     @param _propID The proposal ID whose challenge to inspect
1017     */
1018     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1019         ParamProposal memory prop = proposals[_propID];
1020         Challenge memory challenge = challenges[prop.challengeID];
1021 
1022         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1023     }
1024 
1025     /**
1026     @notice Determines the number of tokens to awarded to the winning party in a challenge
1027     @param _challengeID The challengeID to determine a reward for
1028     */
1029     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1030         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1031             // Edge case, nobody voted, give all tokens to the challenger.
1032             return 2 * challenges[_challengeID].stake;
1033         }
1034 
1035         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1036     }
1037 
1038     /**
1039     @notice gets the parameter keyed by the provided name value from the params mapping
1040     @param _name the key whose value is to be determined
1041     */
1042     function get(string _name) public view returns (uint value) {
1043         return params[keccak256(abi.encodePacked(_name))];
1044     }
1045 
1046     /**
1047     @dev                Getter for Challenge tokenClaims mappings
1048     @param _challengeID The challengeID to query
1049     @param _voter       The voter whose claim status to query for the provided challengeID
1050     */
1051     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1052         return challenges[_challengeID].tokenClaims[_voter];
1053     }
1054 
1055     // ----------------
1056     // PRIVATE FUNCTIONS
1057     // ----------------
1058 
1059     /**
1060     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1061     @param _propID the proposal ID whose challenge is to be resolved.
1062     */
1063     function resolveChallenge(bytes32 _propID) private {
1064         ParamProposal memory prop = proposals[_propID];
1065         Challenge storage challenge = challenges[prop.challengeID];
1066 
1067         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1068         uint reward = challengeWinnerReward(prop.challengeID);
1069 
1070         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1071         challenge.resolved = true;
1072 
1073         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1074             if(prop.processBy > now) {
1075                 set(prop.name, prop.value);
1076             }
1077             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1078             require(token.transfer(prop.owner, reward));
1079         }
1080         else { // The challenge succeeded or nobody voted
1081             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1082             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1083         }
1084     }
1085 
1086     /**
1087     @dev sets the param keted by the provided name to the provided value
1088     @param _name the name of the param to be set
1089     @param _value the value to set the param to be set
1090     */
1091     function set(string _name, uint _value) private {
1092         params[keccak256(abi.encodePacked(_name))] = _value;
1093     }
1094 }
1095 
1096 
1097 
1098 
1099 contract Registry {
1100 
1101     // ------
1102     // EVENTS
1103     // ------
1104 
1105     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data, address indexed applicant);
1106     event _Challenge(bytes32 indexed listingHash, uint challengeID, string data, uint commitEndDate, uint revealEndDate, address indexed challenger);
1107     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal, address indexed owner);
1108     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal, address indexed owner);
1109     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1110     event _ApplicationRemoved(bytes32 indexed listingHash);
1111     event _ListingRemoved(bytes32 indexed listingHash);
1112     event _ListingWithdrawn(bytes32 indexed listingHash, address indexed owner);
1113     event _TouchAndRemoved(bytes32 indexed listingHash);
1114     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1115     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1116     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1117     event _ExitInitialized(bytes32 indexed listingHash, uint exitTime, uint exitDelayEndDate, address indexed owner);
1118 
1119     using SafeMath for uint;
1120 
1121     struct Listing {
1122         uint applicationExpiry; // Expiration date of apply stage
1123         bool whitelisted;       // Indicates registry status
1124         address owner;          // Owner of Listing
1125         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1126         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1127 	uint exitTime;		// Time the listing may leave the registry
1128         uint exitTimeExpiry;    // Expiration date of exit period
1129     }
1130 
1131     struct Challenge {
1132         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1133         address challenger;     // Owner of Challenge
1134         bool resolved;          // Indication of if challenge is resolved
1135         uint stake;             // Number of tokens at stake for either party during challenge
1136         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1137         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1138     }
1139 
1140     // Maps challengeIDs to associated challenge data
1141     mapping(uint => Challenge) public challenges;
1142 
1143     // Maps listingHashes to associated listingHash data
1144     mapping(bytes32 => Listing) public listings;
1145 
1146     // Global Variables
1147     EIP20Interface public token;
1148     PLCRVoting public voting;
1149     Parameterizer public parameterizer;
1150     string public name;
1151 
1152     /**
1153     @dev Initializer. Can only be called once.
1154     @param _token The address where the ERC20 token contract is deployed
1155     */
1156     function init(address _token, address _voting, address _parameterizer, string _name) public {
1157         require(_token != 0 && address(token) == 0);
1158         require(_voting != 0 && address(voting) == 0);
1159         require(_parameterizer != 0 && address(parameterizer) == 0);
1160 
1161         token = EIP20Interface(_token);
1162         voting = PLCRVoting(_voting);
1163         parameterizer = Parameterizer(_parameterizer);
1164         name = _name;
1165     }
1166 
1167     // --------------------
1168     // PUBLISHER INTERFACE:
1169     // --------------------
1170 
1171     /**
1172     @dev                Allows a user to start an application. Takes tokens from user and sets
1173                         apply stage end time.
1174     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1175     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1176     @param _data        Extra data relevant to the application. Think IPFS hashes.
1177     */
1178     function apply(bytes32 _listingHash, uint _amount, string _data) external {
1179         require(!isWhitelisted(_listingHash));
1180         require(!appWasMade(_listingHash));
1181         require(_amount >= parameterizer.get("minDeposit"));
1182 
1183         // Sets owner
1184         Listing storage listing = listings[_listingHash];
1185         listing.owner = msg.sender;
1186 
1187         // Sets apply stage end time
1188         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1189         listing.unstakedDeposit = _amount;
1190 
1191         // Transfers tokens from user to Registry contract
1192         require(token.transferFrom(listing.owner, this, _amount));
1193 
1194         emit _Application(_listingHash, _amount, listing.applicationExpiry, _data, msg.sender);
1195     }
1196 
1197     /**
1198     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1199     @param _listingHash A listingHash msg.sender is the owner of
1200     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1201     */
1202     function deposit(bytes32 _listingHash, uint _amount) external {
1203         Listing storage listing = listings[_listingHash];
1204 
1205         require(listing.owner == msg.sender);
1206 
1207         listing.unstakedDeposit += _amount;
1208         require(token.transferFrom(msg.sender, this, _amount));
1209 
1210         emit _Deposit(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1211     }
1212 
1213     /**
1214     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1215     @param _listingHash A listingHash msg.sender is the owner of.
1216     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1217     */
1218     function withdraw(bytes32 _listingHash, uint _amount) external {
1219         Listing storage listing = listings[_listingHash];
1220 
1221         require(listing.owner == msg.sender);
1222         require(_amount <= listing.unstakedDeposit);
1223         require(listing.unstakedDeposit - _amount >= parameterizer.get("minDeposit"));
1224 
1225         listing.unstakedDeposit -= _amount;
1226         require(token.transfer(msg.sender, _amount));
1227 
1228         emit _Withdrawal(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1229     }
1230 
1231     /**
1232     @dev		Initialize an exit timer for a listing to leave the whitelist
1233     @param _listingHash	A listing hash msg.sender is the owner of
1234     */
1235     function initExit(bytes32 _listingHash) external {
1236         Listing storage listing = listings[_listingHash];
1237 
1238         require(msg.sender == listing.owner);
1239         require(isWhitelisted(_listingHash));
1240         // Cannot exit during ongoing challenge
1241         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1242 
1243         // Ensure user never initializedExit or exitPeriodLen passed
1244         require(listing.exitTime == 0 || now > listing.exitTimeExpiry);
1245 
1246         // Set when the listing may be removed from the whitelist
1247         listing.exitTime = now.add(parameterizer.get("exitTimeDelay"));
1248 	// Set exit period end time
1249 	listing.exitTimeExpiry = listing.exitTime.add(parameterizer.get("exitPeriodLen"));
1250         emit _ExitInitialized(_listingHash, listing.exitTime,
1251             listing.exitTimeExpiry, msg.sender);
1252     }
1253 
1254     /**
1255     @dev		Allow a listing to leave the whitelist
1256     @param _listingHash A listing hash msg.sender is the owner of
1257     */
1258     function finalizeExit(bytes32 _listingHash) external {
1259         Listing storage listing = listings[_listingHash];
1260 
1261         require(msg.sender == listing.owner);
1262         require(isWhitelisted(_listingHash));
1263         // Cannot exit during ongoing challenge
1264         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1265 
1266         // Make sure the exit was initialized
1267         require(listing.exitTime > 0);
1268         // Time to exit has to be after exit delay but before the exitPeriodLen is over
1269 	require(listing.exitTime < now && now < listing.exitTimeExpiry);
1270 
1271         resetListing(_listingHash);
1272         emit _ListingWithdrawn(_listingHash, msg.sender);
1273     }
1274 
1275     // -----------------------
1276     // TOKEN HOLDER INTERFACE:
1277     // -----------------------
1278 
1279     /**
1280     @dev                Starts a poll for a listingHash which is either in the apply stage or
1281                         already in the whitelist. Tokens are taken from the challenger and the
1282                         applicant's deposits are locked.
1283     @param _listingHash The listingHash being challenged, whether listed or in application
1284     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1285     */
1286     function challenge(bytes32 _listingHash, string _data) external returns (uint challengeID) {
1287         Listing storage listing = listings[_listingHash];
1288         uint minDeposit = parameterizer.get("minDeposit");
1289 
1290         // Listing must be in apply stage or already on the whitelist
1291         require(appWasMade(_listingHash) || listing.whitelisted);
1292         // Prevent multiple challenges
1293         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1294 
1295         if (listing.unstakedDeposit < minDeposit) {
1296             // Not enough tokens, listingHash auto-delisted
1297             resetListing(_listingHash);
1298             emit _TouchAndRemoved(_listingHash);
1299             return 0;
1300         }
1301 
1302         // Starts poll
1303         uint pollID = voting.startPoll(
1304             parameterizer.get("voteQuorum"),
1305             parameterizer.get("commitStageLen"),
1306             parameterizer.get("revealStageLen")
1307         );
1308 
1309         uint oneHundred = 100; // Kludge that we need to use SafeMath
1310         challenges[pollID] = Challenge({
1311             challenger: msg.sender,
1312             rewardPool: ((oneHundred.sub(parameterizer.get("dispensationPct"))).mul(minDeposit)).div(100),
1313             stake: minDeposit,
1314             resolved: false,
1315             totalTokens: 0
1316         });
1317 
1318         // Updates listingHash to store most recent challenge
1319         listing.challengeID = pollID;
1320 
1321         // Locks tokens for listingHash during challenge
1322         listing.unstakedDeposit -= minDeposit;
1323 
1324         // Takes tokens from challenger
1325         require(token.transferFrom(msg.sender, this, minDeposit));
1326 
1327         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
1328 
1329         emit _Challenge(_listingHash, pollID, _data, commitEndDate, revealEndDate, msg.sender);
1330         return pollID;
1331     }
1332 
1333     /**
1334     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1335                         a challenge if one exists.
1336     @param _listingHash The listingHash whose status is being updated
1337     */
1338     function updateStatus(bytes32 _listingHash) public {
1339         if (canBeWhitelisted(_listingHash)) {
1340             whitelistApplication(_listingHash);
1341         } else if (challengeCanBeResolved(_listingHash)) {
1342             resolveChallenge(_listingHash);
1343         } else {
1344             revert();
1345         }
1346     }
1347 
1348     /**
1349     @dev                  Updates an array of listingHashes' status from 'application' to 'listing' or resolves
1350                           a challenge if one exists.
1351     @param _listingHashes The listingHashes whose status are being updated
1352     */
1353     function updateStatuses(bytes32[] _listingHashes) public {
1354         // loop through arrays, revealing each individual vote values
1355         for (uint i = 0; i < _listingHashes.length; i++) {
1356             updateStatus(_listingHashes[i]);
1357         }
1358     }
1359 
1360     // ----------------
1361     // TOKEN FUNCTIONS:
1362     // ----------------
1363 
1364     /**
1365     @dev                Called by a voter to claim their reward for each completed vote. Someone
1366                         must call updateStatus() before this can be called.
1367     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1368     */
1369     function claimReward(uint _challengeID) public {
1370         Challenge storage challengeInstance = challenges[_challengeID];
1371         // Ensures the voter has not already claimed tokens and challengeInstance results have
1372         // been processed
1373         require(challengeInstance.tokenClaims[msg.sender] == false);
1374         require(challengeInstance.resolved == true);
1375 
1376         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
1377         uint reward = voterTokens.mul(challengeInstance.rewardPool)
1378                       .div(challengeInstance.totalTokens);
1379 
1380         // Subtracts the voter's information to preserve the participation ratios
1381         // of other voters compared to the remaining pool of rewards
1382         challengeInstance.totalTokens -= voterTokens;
1383         challengeInstance.rewardPool -= reward;
1384 
1385         // Ensures a voter cannot claim tokens again
1386         challengeInstance.tokenClaims[msg.sender] = true;
1387 
1388         require(token.transfer(msg.sender, reward));
1389 
1390         emit _RewardClaimed(_challengeID, reward, msg.sender);
1391     }
1392 
1393     /**
1394     @dev                 Called by a voter to claim their rewards for each completed vote. Someone
1395                          must call updateStatus() before this can be called.
1396     @param _challengeIDs The PLCR pollIDs of the challenges rewards are being claimed for
1397     */
1398     function claimRewards(uint[] _challengeIDs) public {
1399         // loop through arrays, claiming each individual vote reward
1400         for (uint i = 0; i < _challengeIDs.length; i++) {
1401             claimReward(_challengeIDs[i]);
1402         }
1403     }
1404 
1405     // --------
1406     // GETTERS:
1407     // --------
1408 
1409     /**
1410     @dev                Calculates the provided voter's token reward for the given poll.
1411     @param _voter       The address of the voter whose reward balance is to be returned
1412     @param _challengeID The pollID of the challenge a reward balance is being queried for
1413     @return             The uint indicating the voter's reward
1414     */
1415     function voterReward(address _voter, uint _challengeID)
1416     public view returns (uint) {
1417         uint totalTokens = challenges[_challengeID].totalTokens;
1418         uint rewardPool = challenges[_challengeID].rewardPool;
1419         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
1420         return voterTokens.mul(rewardPool).div(totalTokens);
1421     }
1422 
1423     /**
1424     @dev                Determines whether the given listingHash be whitelisted.
1425     @param _listingHash The listingHash whose status is to be examined
1426     */
1427     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1428         uint challengeID = listings[_listingHash].challengeID;
1429 
1430         // Ensures that the application was made,
1431         // the application period has ended,
1432         // the listingHash can be whitelisted,
1433         // and either: the challengeID == 0, or the challenge has been resolved.
1434         if (
1435             appWasMade(_listingHash) &&
1436             listings[_listingHash].applicationExpiry < now &&
1437             !isWhitelisted(_listingHash) &&
1438             (challengeID == 0 || challenges[challengeID].resolved == true)
1439         ) { return true; }
1440 
1441         return false;
1442     }
1443 
1444     /**
1445     @dev                Returns true if the provided listingHash is whitelisted
1446     @param _listingHash The listingHash whose status is to be examined
1447     */
1448     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1449         return listings[_listingHash].whitelisted;
1450     }
1451 
1452     /**
1453     @dev                Returns true if apply was called for this listingHash
1454     @param _listingHash The listingHash whose status is to be examined
1455     */
1456     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1457         return listings[_listingHash].applicationExpiry > 0;
1458     }
1459 
1460     /**
1461     @dev                Returns true if the application/listingHash has an unresolved challenge
1462     @param _listingHash The listingHash whose status is to be examined
1463     */
1464     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1465         uint challengeID = listings[_listingHash].challengeID;
1466 
1467         return (listings[_listingHash].challengeID > 0 && !challenges[challengeID].resolved);
1468     }
1469 
1470     /**
1471     @dev                Determines whether voting has concluded in a challenge for a given
1472                         listingHash. Throws if no challenge exists.
1473     @param _listingHash A listingHash with an unresolved challenge
1474     */
1475     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1476         uint challengeID = listings[_listingHash].challengeID;
1477 
1478         require(challengeExists(_listingHash));
1479 
1480         return voting.pollEnded(challengeID);
1481     }
1482 
1483     /**
1484     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1485     @param _challengeID The challengeID to determine a reward for
1486     */
1487     function determineReward(uint _challengeID) public view returns (uint) {
1488         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1489 
1490         // Edge case, nobody voted, give all tokens to the challenger.
1491         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1492             return 2 * challenges[_challengeID].stake;
1493         }
1494 
1495         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1496     }
1497 
1498     /**
1499     @dev                Getter for Challenge tokenClaims mappings
1500     @param _challengeID The challengeID to query
1501     @param _voter       The voter whose claim status to query for the provided challengeID
1502     */
1503     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1504         return challenges[_challengeID].tokenClaims[_voter];
1505     }
1506 
1507     // ----------------
1508     // PRIVATE FUNCTIONS:
1509     // ----------------
1510 
1511     /**
1512     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1513                         either whitelists or de-whitelists the listingHash.
1514     @param _listingHash A listingHash with a challenge that is to be resolved
1515     */
1516     function resolveChallenge(bytes32 _listingHash) private {
1517         uint challengeID = listings[_listingHash].challengeID;
1518 
1519         // Calculates the winner's reward,
1520         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1521         uint reward = determineReward(challengeID);
1522 
1523         // Sets flag on challenge being processed
1524         challenges[challengeID].resolved = true;
1525 
1526         // Stores the total tokens used for voting by the winning side for reward purposes
1527         challenges[challengeID].totalTokens =
1528             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1529 
1530         // Case: challenge failed
1531         if (voting.isPassed(challengeID)) {
1532             whitelistApplication(_listingHash);
1533             // Unlock stake so that it can be retrieved by the applicant
1534             listings[_listingHash].unstakedDeposit += reward;
1535 
1536             emit _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1537         }
1538         // Case: challenge succeeded or nobody voted
1539         else {
1540             resetListing(_listingHash);
1541             // Transfer the reward to the challenger
1542             require(token.transfer(challenges[challengeID].challenger, reward));
1543 
1544             emit _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1545         }
1546     }
1547 
1548     /**
1549     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1550                         challenge being made. Called by resolveChallenge() if an
1551                         application/listing beat a challenge.
1552     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1553     */
1554     function whitelistApplication(bytes32 _listingHash) private {
1555         if (!listings[_listingHash].whitelisted) { emit _ApplicationWhitelisted(_listingHash); }
1556         listings[_listingHash].whitelisted = true;
1557     }
1558 
1559     /**
1560     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1561     @param _listingHash The listing hash to delete
1562     */
1563     function resetListing(bytes32 _listingHash) private {
1564         Listing storage listing = listings[_listingHash];
1565 
1566         // Emit events before deleting listing to check whether is whitelisted
1567         if (listing.whitelisted) {
1568             emit _ListingRemoved(_listingHash);
1569         } else {
1570             emit _ApplicationRemoved(_listingHash);
1571         }
1572 
1573         // Deleting listing to prevent reentry
1574         address owner = listing.owner;
1575         uint unstakedDeposit = listing.unstakedDeposit;
1576         delete listings[_listingHash];
1577 
1578         // Transfers any remaining balance back to the owner
1579         if (unstakedDeposit > 0){
1580             require(token.transfer(owner, unstakedDeposit));
1581         }
1582     }
1583 }