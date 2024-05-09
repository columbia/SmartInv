1 // File: contracts/zeppelin-solidity/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: contracts/installed_contracts/DLL.sol
69 
70 pragma solidity^0.4.11;
71 
72 library DLL {
73 
74   uint constant NULL_NODE_ID = 0;
75 
76   struct Node {
77     uint next;
78     uint prev;
79   }
80 
81   struct Data {
82     mapping(uint => Node) dll;
83   }
84 
85   function isEmpty(Data storage self) public view returns (bool) {
86     return getStart(self) == NULL_NODE_ID;
87   }
88 
89   function contains(Data storage self, uint _curr) public view returns (bool) {
90     if (isEmpty(self) || _curr == NULL_NODE_ID) {
91       return false;
92     }
93 
94     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
95     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
96     return isSingleNode || !isNullNode;
97   }
98 
99   function getNext(Data storage self, uint _curr) public view returns (uint) {
100     return self.dll[_curr].next;
101   }
102 
103   function getPrev(Data storage self, uint _curr) public view returns (uint) {
104     return self.dll[_curr].prev;
105   }
106 
107   function getStart(Data storage self) public view returns (uint) {
108     return getNext(self, NULL_NODE_ID);
109   }
110 
111   function getEnd(Data storage self) public view returns (uint) {
112     return getPrev(self, NULL_NODE_ID);
113   }
114 
115   /**
116   @dev Inserts a new node between _prev and _next. When inserting a node already existing in
117   the list it will be automatically removed from the old position.
118   @param _prev the node which _new will be inserted after
119   @param _curr the id of the new node being inserted
120   @param _next the node which _new will be inserted before
121   */
122   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
123     require(_curr != NULL_NODE_ID);
124 
125     remove(self, _curr);
126 
127     require(_prev == NULL_NODE_ID || contains(self, _prev));
128     require(_next == NULL_NODE_ID || contains(self, _next));
129 
130     require(getNext(self, _prev) == _next);
131     require(getPrev(self, _next) == _prev);
132 
133     self.dll[_curr].prev = _prev;
134     self.dll[_curr].next = _next;
135 
136     self.dll[_prev].next = _curr;
137     self.dll[_next].prev = _curr;
138   }
139 
140   function remove(Data storage self, uint _curr) public {
141     if (!contains(self, _curr)) {
142       return;
143     }
144 
145     uint next = getNext(self, _curr);
146     uint prev = getPrev(self, _curr);
147 
148     self.dll[next].prev = prev;
149     self.dll[prev].next = next;
150 
151     delete self.dll[_curr];
152   }
153 }
154 
155 // File: contracts/installed_contracts/AttributeStore.sol
156 
157 /* solium-disable */
158 pragma solidity^0.4.11;
159 
160 library AttributeStore {
161     struct Data {
162         mapping(bytes32 => uint) store;
163     }
164 
165     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
166     public view returns (uint) {
167         bytes32 key = keccak256(_UUID, _attrName);
168         return self.store[key];
169     }
170 
171     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
172     public {
173         bytes32 key = keccak256(_UUID, _attrName);
174         self.store[key] = _attrVal;
175     }
176 }
177 
178 // File: contracts/zeppelin-solidity/token/ERC20/IERC20.sol
179 
180 pragma solidity ^0.4.24;
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 interface IERC20 {
187     function totalSupply() external view returns (uint256);
188 
189     function balanceOf(address who) external view returns (uint256);
190 
191     function allowance(address owner, address spender) external view returns (uint256);
192 
193     function transfer(address to, uint256 value) external returns (bool);
194 
195     function approve(address spender, uint256 value) external returns (bool);
196 
197     function transferFrom(address from, address to, uint256 value) external returns (bool);
198 
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 // File: contracts/zeppelin-solidity/math/SafeMath.sol
205 
206 pragma solidity ^0.4.24;
207 
208 
209 /**
210  * @title SafeMath
211  * @dev Math operations with safety checks that throw on error
212  */
213 library SafeMath {
214 
215   /**
216   * @dev Multiplies two numbers, throws on overflow.
217   */
218   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
219     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
220     // benefit is lost if 'b' is also tested.
221     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
222     if (_a == 0) {
223       return 0;
224     }
225 
226     c = _a * _b;
227     assert(c / _a == _b);
228     return c;
229   }
230 
231   /**
232   * @dev Integer division of two numbers, truncating the quotient.
233   */
234   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
235     // assert(_b > 0); // Solidity automatically throws when dividing by 0
236     // uint256 c = _a / _b;
237     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
238     return _a / _b;
239   }
240 
241   /**
242   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
243   */
244   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
245     assert(_b <= _a);
246     return _a - _b;
247   }
248 
249   /**
250   * @dev Adds two numbers, throws on overflow.
251   */
252   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
253     c = _a + _b;
254     assert(c >= _a);
255     return c;
256   }
257 }
258 
259 // File: contracts/installed_contracts/PLCRVoting.sol
260 
261 pragma solidity ^0.4.8;
262 
263 
264 
265 
266 
267 /**
268 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
269 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
270 */
271 contract PLCRVoting {
272 
273     // ============
274     // EVENTS:
275     // ============
276 
277     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
278     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
279     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
280     event _VotingRightsGranted(uint numTokens, address indexed voter);
281     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
282     event _TokensRescued(uint indexed pollID, address indexed voter);
283 
284     // ============
285     // DATA STRUCTURES:
286     // ============
287 
288     using AttributeStore for AttributeStore.Data;
289     using DLL for DLL.Data;
290     using SafeMath for uint;
291 
292     struct Poll {
293         uint commitEndDate;     /// expiration date of commit period for poll
294         uint revealEndDate;     /// expiration date of reveal period for poll
295         uint voteQuorum;	    /// number of votes required for a proposal to pass
296         uint votesFor;		    /// tally of votes supporting proposal
297         uint votesAgainst;      /// tally of votes countering proposal
298         mapping(address => bool) didCommit;  /// indicates whether an address committed a vote for this poll
299         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
300     }
301 
302     // ============
303     // STATE VARIABLES:
304     // ============
305 
306     uint constant public INITIAL_POLL_NONCE = 0;
307     uint public pollNonce;
308 
309     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
310     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
311 
312     mapping(address => DLL.Data) dllMap;
313     AttributeStore.Data store;
314 
315     IERC20 public token;
316 
317     /**
318     @param _token The address where the ERC20 token contract is deployed
319     */
320     constructor(address _token) public {
321         require(_token != 0);
322 
323         token = IERC20(_token);
324         pollNonce = INITIAL_POLL_NONCE;
325     }
326 
327     // ================
328     // TOKEN INTERFACE:
329     // ================
330 
331     /**
332     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
333     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
334     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
335     */
336     function requestVotingRights(uint _numTokens) public {
337         require(token.balanceOf(msg.sender) >= _numTokens);
338         voteTokenBalance[msg.sender] += _numTokens;
339         require(token.transferFrom(msg.sender, this, _numTokens));
340         emit _VotingRightsGranted(_numTokens, msg.sender);
341     }
342 
343     /**
344     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
345     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
346     */
347     function withdrawVotingRights(uint _numTokens) external {
348         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
349         require(availableTokens >= _numTokens);
350         voteTokenBalance[msg.sender] -= _numTokens;
351         require(token.transfer(msg.sender, _numTokens));
352         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
353     }
354 
355     /**
356     @dev Unlocks tokens locked in unrevealed vote where poll has ended
357     @param _pollID Integer identifier associated with the target poll
358     */
359     function rescueTokens(uint _pollID) public {
360         require(isExpired(pollMap[_pollID].revealEndDate));
361         require(dllMap[msg.sender].contains(_pollID));
362 
363         dllMap[msg.sender].remove(_pollID);
364         emit _TokensRescued(_pollID, msg.sender);
365     }
366 
367     /**
368     @dev Unlocks tokens locked in unrevealed votes where polls have ended
369     @param _pollIDs Array of integer identifiers associated with the target polls
370     */
371     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
372         // loop through arrays, rescuing tokens from all
373         for (uint i = 0; i < _pollIDs.length; i++) {
374             rescueTokens(_pollIDs[i]);
375         }
376     }
377 
378     // =================
379     // VOTING INTERFACE:
380     // =================
381 
382     /**
383     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
384     @param _pollID Integer identifier associated with target poll
385     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
386     @param _numTokens The number of tokens to be committed towards the target poll
387     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
388     */
389     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
390         require(commitPeriodActive(_pollID));
391 
392         // if msg.sender doesn't have enough voting rights,
393         // request for enough voting rights
394         if (voteTokenBalance[msg.sender] < _numTokens) {
395             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
396             requestVotingRights(remainder);
397         }
398 
399         // make sure msg.sender has enough voting rights
400         require(voteTokenBalance[msg.sender] >= _numTokens);
401         // prevent user from committing to zero node placeholder
402         require(_pollID != 0);
403         // prevent user from committing a secretHash of 0
404         require(_secretHash != 0);
405 
406         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
407         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
408 
409         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
410 
411         // edge case: in-place update
412         if (nextPollID == _pollID) {
413             nextPollID = dllMap[msg.sender].getNext(_pollID);
414         }
415 
416         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
417         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
418 
419         bytes32 UUID = attrUUID(msg.sender, _pollID);
420 
421         store.setAttribute(UUID, "numTokens", _numTokens);
422         store.setAttribute(UUID, "commitHash", uint(_secretHash));
423 
424         pollMap[_pollID].didCommit[msg.sender] = true;
425         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
426     }
427 
428     /**
429     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
430     @param _pollIDs         Array of integer identifiers associated with target polls
431     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
432     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
433     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
434     */
435     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
436         // make sure the array lengths are all the same
437         require(_pollIDs.length == _secretHashes.length);
438         require(_pollIDs.length == _numsTokens.length);
439         require(_pollIDs.length == _prevPollIDs.length);
440 
441         // loop through arrays, committing each individual vote values
442         for (uint i = 0; i < _pollIDs.length; i++) {
443             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
444         }
445     }
446 
447     /**
448     @dev Compares previous and next poll's committed tokens for sorting purposes
449     @param _prevID Integer identifier associated with previous poll in sorted order
450     @param _nextID Integer identifier associated with next poll in sorted order
451     @param _voter Address of user to check DLL position for
452     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
453     @return valid Boolean indication of if the specified position maintains the sort
454     */
455     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
456         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
457         // if next is zero node, _numTokens does not need to be greater
458         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
459         return prevValid && nextValid;
460     }
461 
462     /**
463     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
464     @param _pollID Integer identifier associated with target poll
465     @param _voteOption Vote choice used to generate commitHash for associated poll
466     @param _salt Secret number used to generate commitHash for associated poll
467     */
468     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
469         // Make sure the reveal period is active
470         require(revealPeriodActive(_pollID));
471         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
472         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
473         require(keccak256(_voteOption, _salt) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
474 
475         uint numTokens = getNumTokens(msg.sender, _pollID);
476 
477         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
478             pollMap[_pollID].votesFor += numTokens;
479         } else {
480             pollMap[_pollID].votesAgainst += numTokens;
481         }
482 
483         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
484         pollMap[_pollID].didReveal[msg.sender] = true;
485 
486         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
487     }
488 
489     /**
490     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
491     @param _pollIDs     Array of integer identifiers associated with target polls
492     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
493     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
494     */
495     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
496         // make sure the array lengths are all the same
497         require(_pollIDs.length == _voteOptions.length);
498         require(_pollIDs.length == _salts.length);
499 
500         // loop through arrays, revealing each individual vote values
501         for (uint i = 0; i < _pollIDs.length; i++) {
502             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
503         }
504     }
505 
506     /**
507     @param _pollID Integer identifier associated with target poll
508     @param _salt Arbitrarily chosen integer used to generate secretHash
509     @return correctVotes Number of tokens voted for winning option
510     */
511     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
512         require(pollEnded(_pollID));
513         require(pollMap[_pollID].didReveal[_voter]);
514 
515         uint winningChoice = isPassed(_pollID) ? 1 : 0;
516         bytes32 winnerHash = keccak256(winningChoice, _salt);
517         bytes32 commitHash = getCommitHash(_voter, _pollID);
518 
519         require(winnerHash == commitHash);
520 
521         return getNumTokens(_voter, _pollID);
522     }
523 
524     // ==================
525     // POLLING INTERFACE:
526     // ==================
527 
528     /**
529     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
530     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
531     @param _commitDuration Length of desired commit period in seconds
532     @param _revealDuration Length of desired reveal period in seconds
533     */
534     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
535         pollNonce = pollNonce + 1;
536 
537         uint commitEndDate = block.timestamp.add(_commitDuration);
538         uint revealEndDate = commitEndDate.add(_revealDuration);
539 
540         pollMap[pollNonce] = Poll({
541             voteQuorum: _voteQuorum,
542             commitEndDate: commitEndDate,
543             revealEndDate: revealEndDate,
544             votesFor: 0,
545             votesAgainst: 0
546         });
547 
548         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
549         return pollNonce;
550     }
551 
552     /**
553     @notice Determines if proposal has passed
554     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
555     @param _pollID Integer identifier associated with target poll
556     */
557     function isPassed(uint _pollID) constant public returns (bool passed) {
558         require(pollEnded(_pollID));
559 
560         Poll memory poll = pollMap[_pollID];
561         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
562     }
563 
564     // ----------------
565     // POLLING HELPERS:
566     // ----------------
567 
568     /**
569     @dev Gets the total winning votes for reward distribution purposes
570     @param _pollID Integer identifier associated with target poll
571     @return Total number of votes committed to the winning option for specified poll
572     */
573     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
574         require(pollEnded(_pollID));
575 
576         if (isPassed(_pollID))
577             return pollMap[_pollID].votesFor;
578         else
579             return pollMap[_pollID].votesAgainst;
580     }
581 
582     /**
583     @notice Determines if poll is over
584     @dev Checks isExpired for specified poll's revealEndDate
585     @return Boolean indication of whether polling period is over
586     */
587     function pollEnded(uint _pollID) constant public returns (bool ended) {
588         require(pollExists(_pollID));
589 
590         return isExpired(pollMap[_pollID].revealEndDate);
591     }
592 
593     /**
594     @notice Checks if the commit period is still active for the specified poll
595     @dev Checks isExpired for the specified poll's commitEndDate
596     @param _pollID Integer identifier associated with target poll
597     @return Boolean indication of isCommitPeriodActive for target poll
598     */
599     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
600         require(pollExists(_pollID));
601 
602         return !isExpired(pollMap[_pollID].commitEndDate);
603     }
604 
605     /**
606     @notice Checks if the reveal period is still active for the specified poll
607     @dev Checks isExpired for the specified poll's revealEndDate
608     @param _pollID Integer identifier associated with target poll
609     */
610     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
611         require(pollExists(_pollID));
612 
613         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
614     }
615 
616     /**
617     @dev Checks if user has committed for specified poll
618     @param _voter Address of user to check against
619     @param _pollID Integer identifier associated with target poll
620     @return Boolean indication of whether user has committed
621     */
622     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
623         require(pollExists(_pollID));
624 
625         return pollMap[_pollID].didCommit[_voter];
626     }
627 
628     /**
629     @dev Checks if user has revealed for specified poll
630     @param _voter Address of user to check against
631     @param _pollID Integer identifier associated with target poll
632     @return Boolean indication of whether user has revealed
633     */
634     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
635         require(pollExists(_pollID));
636 
637         return pollMap[_pollID].didReveal[_voter];
638     }
639 
640     /**
641     @dev Checks if a poll exists
642     @param _pollID The pollID whose existance is to be evaluated.
643     @return Boolean Indicates whether a poll exists for the provided pollID
644     */
645     function pollExists(uint _pollID) constant public returns (bool exists) {
646         return (_pollID != 0 && _pollID <= pollNonce);
647     }
648 
649     // ---------------------------
650     // DOUBLE-LINKED-LIST HELPERS:
651     // ---------------------------
652 
653     /**
654     @dev Gets the bytes32 commitHash property of target poll
655     @param _voter Address of user to check against
656     @param _pollID Integer identifier associated with target poll
657     @return Bytes32 hash property attached to target poll
658     */
659     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
660         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
661     }
662 
663     /**
664     @dev Wrapper for getAttribute with attrName="numTokens"
665     @param _voter Address of user to check against
666     @param _pollID Integer identifier associated with target poll
667     @return Number of tokens committed to poll in sorted poll-linked-list
668     */
669     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
670         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
671     }
672 
673     /**
674     @dev Gets top element of sorted poll-linked-list
675     @param _voter Address of user to check against
676     @return Integer identifier to poll with maximum number of tokens committed to it
677     */
678     function getLastNode(address _voter) constant public returns (uint pollID) {
679         return dllMap[_voter].getPrev(0);
680     }
681 
682     /**
683     @dev Gets the numTokens property of getLastNode
684     @param _voter Address of user to check against
685     @return Maximum number of tokens committed in poll specified
686     */
687     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
688         return getNumTokens(_voter, getLastNode(_voter));
689     }
690 
691     /*
692     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
693     for a node with a value less than or equal to the provided _numTokens value. When such a node
694     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
695     update. In that case, return the previous node of the node being updated. Otherwise return the
696     first node that was found with a value less than or equal to the provided _numTokens.
697     @param _voter The voter whose DLL will be searched
698     @param _numTokens The value for the numTokens attribute in the node to be inserted
699     @return the node which the propoded node should be inserted after
700     */
701     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
702     constant public returns (uint prevNode) {
703       // Get the last node in the list and the number of tokens in that node
704       uint nodeID = getLastNode(_voter);
705       uint tokensInNode = getNumTokens(_voter, nodeID);
706 
707       // Iterate backwards through the list until reaching the root node
708       while(nodeID != 0) {
709         // Get the number of tokens in the current node
710         tokensInNode = getNumTokens(_voter, nodeID);
711         if(tokensInNode <= _numTokens) { // We found the insert point!
712           if(nodeID == _pollID) {
713             // This is an in-place update. Return the prev node of the node being updated
714             nodeID = dllMap[_voter].getPrev(nodeID);
715           }
716           // Return the insert point
717           return nodeID;
718         }
719         // We did not find the insert point. Continue iterating backwards through the list
720         nodeID = dllMap[_voter].getPrev(nodeID);
721       }
722 
723       // The list is empty, or a smaller value than anything else in the list is being inserted
724       return nodeID;
725     }
726 
727     // ----------------
728     // GENERAL HELPERS:
729     // ----------------
730 
731     /**
732     @dev Checks if an expiration date has been reached
733     @param _terminationDate Integer timestamp of date to compare current timestamp with
734     @return expired Boolean indication of whether the terminationDate has passed
735     */
736     function isExpired(uint _terminationDate) constant public returns (bool expired) {
737         return (block.timestamp > _terminationDate);
738     }
739 
740     /**
741     @dev Generates an identifier which associates a user and a poll together
742     @param _pollID Integer identifier associated with target poll
743     @return UUID Hash which is deterministic from _user and _pollID
744     */
745     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
746         return keccak256(_user, _pollID);
747     }
748 }
749 
750 // File: contracts/installed_contracts/Parameterizer.sol
751 
752 pragma solidity^0.4.11;
753 
754 
755 
756 
757 contract Parameterizer {
758 
759     // ------
760     // EVENTS
761     // ------
762 
763     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
764     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
765     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
766     event _ProposalExpired(bytes32 indexed propID);
767     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
768     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
769     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
770 
771 
772     // ------
773     // DATA STRUCTURES
774     // ------
775 
776     using SafeMath for uint;
777 
778     struct ParamProposal {
779         uint appExpiry;
780         uint challengeID;
781         uint deposit;
782         string name;
783         address owner;
784         uint processBy;
785         uint value;
786     }
787 
788     struct Challenge {
789         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
790         address challenger;     // owner of Challenge
791         bool resolved;          // indication of if challenge is resolved
792         uint stake;             // number of tokens at risk for either party during challenge
793         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
794         mapping(address => bool) tokenClaims;
795     }
796 
797     // ------
798     // STATE
799     // ------
800 
801     mapping(bytes32 => uint) public params;
802 
803     // maps challengeIDs to associated challenge data
804     mapping(uint => Challenge) public challenges;
805 
806     // maps pollIDs to intended data change if poll passes
807     mapping(bytes32 => ParamProposal) public proposals;
808 
809     // Global Variables
810     IERC20 public token;
811     PLCRVoting public voting;
812     uint public PROCESSBY = 604800; // 7 days
813 
814     /**
815     @param _token           The address where the ERC20 token contract is deployed
816     @param _plcr            address of a PLCR voting contract for the provided token
817     @notice _parameters     array of canonical parameters
818     */
819     constructor(
820         address _token,
821         address _plcr,
822         uint[] _parameters
823     ) public {
824         token = IERC20(_token);
825         voting = PLCRVoting(_plcr);
826 
827         // minimum deposit for listing to be whitelisted
828         set("minDeposit", _parameters[0]);
829 
830         // minimum deposit to propose a reparameterization
831         set("pMinDeposit", _parameters[1]);
832 
833         // period over which applicants wait to be whitelisted
834         set("applyStageLen", _parameters[2]);
835 
836         // period over which reparmeterization proposals wait to be processed
837         set("pApplyStageLen", _parameters[3]);
838 
839         // length of commit period for voting
840         set("commitStageLen", _parameters[4]);
841 
842         // length of commit period for voting in parameterizer
843         set("pCommitStageLen", _parameters[5]);
844 
845         // length of reveal period for voting
846         set("revealStageLen", _parameters[6]);
847 
848         // length of reveal period for voting in parameterizer
849         set("pRevealStageLen", _parameters[7]);
850 
851         // percentage of losing party's deposit distributed to winning party
852         set("dispensationPct", _parameters[8]);
853 
854         // percentage of losing party's deposit distributed to winning party in parameterizer
855         set("pDispensationPct", _parameters[9]);
856 
857         // type of majority out of 100 necessary for candidate success
858         set("voteQuorum", _parameters[10]);
859 
860         // type of majority out of 100 necessary for proposal success in parameterizer
861         set("pVoteQuorum", _parameters[11]);
862     }
863 
864     // -----------------------
865     // TOKEN HOLDER INTERFACE
866     // -----------------------
867 
868     /**
869     @notice propose a reparamaterization of the key _name's value to _value.
870     @param _name the name of the proposed param to be set
871     @param _value the proposed value to set the param to be set
872     */
873     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
874         uint deposit = get("pMinDeposit");
875         bytes32 propID = keccak256(_name, _value);
876 
877         if (keccak256(_name) == keccak256("dispensationPct") ||
878             keccak256(_name) == keccak256("pDispensationPct")) {
879             require(_value <= 100);
880         }
881 
882         require(!propExists(propID)); // Forbid duplicate proposals
883         require(get(_name) != _value); // Forbid NOOP reparameterizations
884 
885         // attach name and value to pollID
886         proposals[propID] = ParamProposal({
887             appExpiry: now.add(get("pApplyStageLen")),
888             challengeID: 0,
889             deposit: deposit,
890             name: _name,
891             owner: msg.sender,
892             processBy: now.add(get("pApplyStageLen"))
893                 .add(get("pCommitStageLen"))
894                 .add(get("pRevealStageLen"))
895                 .add(PROCESSBY),
896             value: _value
897         });
898 
899         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
900 
901         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
902         return propID;
903     }
904 
905     /**
906     @notice challenge the provided proposal ID, and put tokens at stake to do so.
907     @param _propID the proposal ID to challenge
908     */
909     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
910         ParamProposal memory prop = proposals[_propID];
911         uint deposit = prop.deposit;
912 
913         require(propExists(_propID) && prop.challengeID == 0);
914 
915         //start poll
916         uint pollID = voting.startPoll(
917             get("pVoteQuorum"),
918             get("pCommitStageLen"),
919             get("pRevealStageLen")
920         );
921 
922         challenges[pollID] = Challenge({
923             challenger: msg.sender,
924             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
925             stake: deposit,
926             resolved: false,
927             winningTokens: 0
928         });
929 
930         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
931 
932         //take tokens from challenger
933         require(token.transferFrom(msg.sender, this, deposit));
934 
935         var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
936 
937         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
938         return pollID;
939     }
940 
941     /**
942     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
943     @param _propID      the proposal ID to make a determination and state transition for
944     */
945     function processProposal(bytes32 _propID) public {
946         ParamProposal storage prop = proposals[_propID];
947         address propOwner = prop.owner;
948         uint propDeposit = prop.deposit;
949 
950 
951         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
952         // prop.owner and prop.deposit will be 0, thereby preventing theft
953         if (canBeSet(_propID)) {
954             // There is no challenge against the proposal. The processBy date for the proposal has not
955             // passed, but the proposal's appExpirty date has passed.
956             set(prop.name, prop.value);
957             emit _ProposalAccepted(_propID, prop.name, prop.value);
958             delete proposals[_propID];
959             require(token.transfer(propOwner, propDeposit));
960         } else if (challengeCanBeResolved(_propID)) {
961             // There is a challenge against the proposal.
962             resolveChallenge(_propID);
963         } else if (now > prop.processBy) {
964             // There is no challenge against the proposal, but the processBy date has passed.
965             emit _ProposalExpired(_propID);
966             delete proposals[_propID];
967             require(token.transfer(propOwner, propDeposit));
968         } else {
969             // There is no challenge against the proposal, and neither the appExpiry date nor the
970             // processBy date has passed.
971             revert();
972         }
973 
974         assert(get("dispensationPct") <= 100);
975         assert(get("pDispensationPct") <= 100);
976 
977         // verify that future proposal appExpiry and processBy times will not overflow
978         now.add(get("pApplyStageLen"))
979             .add(get("pCommitStageLen"))
980             .add(get("pRevealStageLen"))
981             .add(PROCESSBY);
982 
983         delete proposals[_propID];
984     }
985 
986     /**
987     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
988     @param _challengeID     the challenge ID to claim tokens for
989     @param _salt            the salt used to vote in the challenge being withdrawn for
990     */
991     function claimReward(uint _challengeID, uint _salt) public {
992         // ensure voter has not already claimed tokens and challenge results have been processed
993         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
994         require(challenges[_challengeID].resolved == true);
995 
996         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
997         uint reward = voterReward(msg.sender, _challengeID, _salt);
998 
999         // subtract voter's information to preserve the participation ratios of other voters
1000         // compared to the remaining pool of rewards
1001         challenges[_challengeID].winningTokens -= voterTokens;
1002         challenges[_challengeID].rewardPool -= reward;
1003 
1004         // ensures a voter cannot claim tokens again
1005         challenges[_challengeID].tokenClaims[msg.sender] = true;
1006 
1007         emit _RewardClaimed(_challengeID, reward, msg.sender);
1008         require(token.transfer(msg.sender, reward));
1009     }
1010 
1011     /**
1012     @dev                    Called by a voter to claim their rewards for each completed vote.
1013                             Someone must call updateStatus() before this can be called.
1014     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
1015     @param _salts           The salts of a voter's commit hashes in the given polls
1016     */
1017     function claimRewards(uint[] _challengeIDs, uint[] _salts) public {
1018         // make sure the array lengths are the same
1019         require(_challengeIDs.length == _salts.length);
1020 
1021         // loop through arrays, claiming each individual vote reward
1022         for (uint i = 0; i < _challengeIDs.length; i++) {
1023             claimReward(_challengeIDs[i], _salts[i]);
1024         }
1025     }
1026 
1027     // --------
1028     // GETTERS
1029     // --------
1030 
1031     /**
1032     @dev                Calculates the provided voter's token reward for the given poll.
1033     @param _voter       The address of the voter whose reward balance is to be returned
1034     @param _challengeID The ID of the challenge the voter's reward is being calculated for
1035     @param _salt        The salt of the voter's commit hash in the given poll
1036     @return             The uint indicating the voter's reward
1037     */
1038     function voterReward(address _voter, uint _challengeID, uint _salt)
1039     public view returns (uint) {
1040         uint winningTokens = challenges[_challengeID].winningTokens;
1041         uint rewardPool = challenges[_challengeID].rewardPool;
1042         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1043         return (voterTokens * rewardPool) / winningTokens;
1044     }
1045 
1046     /**
1047     @notice Determines whether a proposal passed its application stage without a challenge
1048     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
1049     */
1050     function canBeSet(bytes32 _propID) view public returns (bool) {
1051         ParamProposal memory prop = proposals[_propID];
1052 
1053         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1054     }
1055 
1056     /**
1057     @notice Determines whether a proposal exists for the provided proposal ID
1058     @param _propID The proposal ID whose existance is to be determined
1059     */
1060     function propExists(bytes32 _propID) view public returns (bool) {
1061         return proposals[_propID].processBy > 0;
1062     }
1063 
1064     /**
1065     @notice Determines whether the provided proposal ID has a challenge which can be resolved
1066     @param _propID The proposal ID whose challenge to inspect
1067     */
1068     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1069         ParamProposal memory prop = proposals[_propID];
1070         Challenge memory challenge = challenges[prop.challengeID];
1071 
1072         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1073     }
1074 
1075     /**
1076     @notice Determines the number of tokens to awarded to the winning party in a challenge
1077     @param _challengeID The challengeID to determine a reward for
1078     */
1079     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1080         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1081             // Edge case, nobody voted, give all tokens to the challenger.
1082             return 2 * challenges[_challengeID].stake;
1083         }
1084 
1085         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1086     }
1087 
1088     /**
1089     @notice gets the parameter keyed by the provided name value from the params mapping
1090     @param _name the key whose value is to be determined
1091     */
1092     function get(string _name) public view returns (uint value) {
1093         return params[keccak256(_name)];
1094     }
1095 
1096     /**
1097     @dev                Getter for Challenge tokenClaims mappings
1098     @param _challengeID The challengeID to query
1099     @param _voter       The voter whose claim status to query for the provided challengeID
1100     */
1101     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1102         return challenges[_challengeID].tokenClaims[_voter];
1103     }
1104 
1105     // ----------------
1106     // PRIVATE FUNCTIONS
1107     // ----------------
1108 
1109     /**
1110     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1111     @param _propID the proposal ID whose challenge is to be resolved.
1112     */
1113     function resolveChallenge(bytes32 _propID) private {
1114         ParamProposal memory prop = proposals[_propID];
1115         Challenge storage challenge = challenges[prop.challengeID];
1116 
1117         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1118         uint reward = challengeWinnerReward(prop.challengeID);
1119 
1120         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1121         challenge.resolved = true;
1122 
1123         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1124             if(prop.processBy > now) {
1125                 set(prop.name, prop.value);
1126             }
1127             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1128             require(token.transfer(prop.owner, reward));
1129         }
1130         else { // The challenge succeeded or nobody voted
1131             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1132             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1133         }
1134     }
1135 
1136     /**
1137     @dev sets the param keted by the provided name to the provided value
1138     @param _name the name of the param to be set
1139     @param _value the value to set the param to be set
1140     */
1141     function set(string _name, uint _value) internal {
1142         params[keccak256(_name)] = _value;
1143     }
1144 }
1145 
1146 // File: contracts/tcr/AddressRegistry.sol
1147 
1148 // solium-disable
1149 pragma solidity ^0.4.24;
1150 
1151 
1152 
1153 
1154 
1155 contract AddressRegistry {
1156 
1157     // ------
1158     // EVENTS
1159     // ------
1160 
1161     event _Application(address indexed listingAddress, uint deposit, uint appEndDate, string data, address indexed applicant);
1162     event _Challenge(address indexed listingAddress, uint indexed challengeID, string data, uint commitEndDate, uint revealEndDate, address indexed challenger);
1163     event _Deposit(address indexed listingAddress, uint added, uint newTotal, address indexed owner);
1164     event _Withdrawal(address indexed listingAddress, uint withdrew, uint newTotal, address indexed owner);
1165     event _ApplicationWhitelisted(address indexed listingAddress);
1166     event _ApplicationRemoved(address indexed listingAddress);
1167     event _ListingRemoved(address indexed listingAddress);
1168     event _ListingWithdrawn(address indexed listingAddress);
1169     event _TouchAndRemoved(address indexed listingAddress);
1170     event _ChallengeFailed(address indexed listingAddress, uint indexed challengeID, uint rewardPool, uint totalTokens);
1171     event _ChallengeSucceeded(address indexed listingAddress, uint indexed challengeID, uint rewardPool, uint totalTokens);
1172     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1173 
1174     using SafeMath for uint;
1175 
1176     struct Listing {
1177         uint applicationExpiry; // Expiration date of apply stage
1178         bool whitelisted;       // Indicates registry status
1179         address owner;          // Owner of Listing
1180         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1181         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1182     }
1183 
1184     struct Challenge {
1185         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1186         address challenger;     // Owner of Challenge
1187         bool resolved;          // Indication of if challenge is resolved
1188         uint stake;             // Number of tokens at stake for either party during challenge
1189         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1190         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1191     }
1192 
1193     // Maps challengeIDs to associated challenge data
1194     mapping(uint => Challenge) public challenges;
1195 
1196     // Maps listingHashes to associated listingHash data
1197     mapping(address => Listing) public listings;
1198 
1199     // Global Variables
1200     IERC20 public token;
1201     PLCRVoting public voting;
1202     Parameterizer public parameterizer;
1203     string public name;
1204 
1205     /**
1206     @dev Initializer. Can only be called once.
1207     @param _token The address where the ERC20 token contract is deployed
1208     */
1209     constructor(address _token, address _voting, address _parameterizer, string _name) public {
1210         require(_token != 0, "_token address is 0");
1211         require(_voting != 0, "_voting address is 0");
1212         require(_parameterizer != 0, "_parameterizer address is 0");
1213 
1214         token = IERC20(_token);
1215         voting = PLCRVoting(_voting);
1216         parameterizer = Parameterizer(_parameterizer);
1217         name = _name;
1218     }
1219 
1220     // --------------------
1221     // PUBLISHER INTERFACE:
1222     // --------------------
1223 
1224     /**
1225     @dev                Allows a user to start an application. Takes tokens from user and sets
1226                         apply stage end time.
1227     @param listingAddress The hash of a potential listing a user is applying to add to the registry
1228     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1229     @param _data        Extra data relevant to the application. Think IPFS hashes.
1230     */
1231     function apply(address listingAddress, uint _amount, string _data) public {
1232         require(!isWhitelisted(listingAddress), "Listing already whitelisted");
1233         require(!appWasMade(listingAddress), "Application already made for this address");
1234         require(_amount >= parameterizer.get("minDeposit"), "Deposit amount not above minDeposit");
1235 
1236         // Sets owner
1237         Listing storage listing = listings[listingAddress];
1238         listing.owner = msg.sender;
1239 
1240         // Sets apply stage end time
1241         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1242         listing.unstakedDeposit = _amount;
1243 
1244         // Transfers tokens from user to Registry contract
1245         require(token.transferFrom(listing.owner, this, _amount), "Token transfer failed");
1246 
1247         emit _Application(listingAddress, _amount, listing.applicationExpiry, _data, msg.sender);
1248     }
1249 
1250     /**
1251     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1252     @param listingAddress A listingHash msg.sender is the owner of
1253     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1254     */
1255     function deposit(address listingAddress, uint _amount) external {
1256         Listing storage listing = listings[listingAddress];
1257 
1258         require(listing.owner == msg.sender, "Sender is not owner of Listing");
1259 
1260         listing.unstakedDeposit += _amount;
1261         require(token.transferFrom(msg.sender, this, _amount), "Token transfer failed");
1262 
1263         emit _Deposit(listingAddress, _amount, listing.unstakedDeposit, msg.sender);
1264     }
1265 
1266     /**
1267     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1268     @param listingAddress A listingHash msg.sender is the owner of.
1269     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1270     */
1271     function withdraw(address listingAddress, uint _amount) external {
1272         Listing storage listing = listings[listingAddress];
1273 
1274         require(listing.owner == msg.sender, "Sender is not owner of listing");
1275         require(_amount <= listing.unstakedDeposit, "Cannot withdraw more than current unstaked deposit");
1276         if (listing.challengeID == 0 || challenges[listing.challengeID].resolved) { // ok to withdraw entire unstakedDeposit when challenge active as described here: https://github.com/skmgoldin/tcr/issues/55
1277           require(listing.unstakedDeposit - _amount >= parameterizer.get("minDeposit"), "Withdrawal prohibitied as it would put Listing unstaked deposit below minDeposit");
1278         }
1279 
1280         listing.unstakedDeposit -= _amount;
1281         require(token.transfer(msg.sender, _amount), "Token transfer failed");
1282 
1283         emit _Withdrawal(listingAddress, _amount, listing.unstakedDeposit, msg.sender);
1284     }
1285 
1286     /**
1287     @dev                Allows the owner of a listingHash to remove the listingHash from the whitelist
1288                         Returns all tokens to the owner of the listingHash
1289     @param listingAddress A listingHash msg.sender is the owner of.
1290     */
1291     function exit(address listingAddress) external {
1292         Listing storage listing = listings[listingAddress];
1293 
1294         require(msg.sender == listing.owner, "Sender is not owner of listing");
1295         require(isWhitelisted(listingAddress), "Listing must be whitelisted to be exited");
1296 
1297         // Cannot exit during ongoing challenge
1298         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved, "Listing must not have an active challenge to be exited");
1299 
1300         // Remove listingHash & return tokens
1301         resetListing(listingAddress);
1302         emit _ListingWithdrawn(listingAddress);
1303     }
1304 
1305     // -----------------------
1306     // TOKEN HOLDER INTERFACE:
1307     // -----------------------
1308 
1309     /**
1310     @dev                Starts a poll for a listingHash which is either in the apply stage or
1311                         already in the whitelist. Tokens are taken from the challenger and the
1312                         applicant's deposits are locked.
1313     @param listingAddress The listingHash being challenged, whether listed or in application
1314     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1315     */
1316     function challenge(address listingAddress, string _data) public returns (uint challengeID) {
1317         Listing storage listing = listings[listingAddress];
1318         uint minDeposit = parameterizer.get("minDeposit");
1319 
1320         // Listing must be in apply stage or already on the whitelist
1321         require(appWasMade(listingAddress) || listing.whitelisted, "Listing must be in application phase or already whitelisted to be challenged");
1322         // Prevent multiple challenges
1323         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved, "Listing must not have active challenge to be challenged");
1324 
1325         if (listing.unstakedDeposit < minDeposit) {
1326             // Not enough tokens, listingHash auto-delisted
1327             resetListing(listingAddress);
1328             emit _TouchAndRemoved(listingAddress);
1329             return 0;
1330         }
1331 
1332         // Starts poll
1333         uint pollID = voting.startPoll(
1334             parameterizer.get("voteQuorum"),
1335             parameterizer.get("commitStageLen"),
1336             parameterizer.get("revealStageLen")
1337         );
1338 
1339         uint oneHundred = 100; // Kludge that we need to use SafeMath
1340         challenges[pollID] = Challenge({
1341             challenger: msg.sender,
1342             rewardPool: ((oneHundred.sub(parameterizer.get("dispensationPct"))).mul(minDeposit)).div(100),
1343             stake: minDeposit,
1344             resolved: false,
1345             totalTokens: 0
1346         });
1347 
1348         // Updates listingHash to store most recent challenge
1349         listing.challengeID = pollID;
1350 
1351         // Locks tokens for listingHash during challenge
1352         listing.unstakedDeposit -= minDeposit;
1353 
1354         // Takes tokens from challenger
1355         require(token.transferFrom(msg.sender, this, minDeposit), "Token transfer failed");
1356 
1357         var (commitEndDate, revealEndDate,) = voting.pollMap(pollID);
1358 
1359         emit _Challenge(listingAddress, pollID, _data, commitEndDate, revealEndDate, msg.sender);
1360         return pollID;
1361     }
1362 
1363     /**
1364     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1365                         a challenge if one exists.
1366     @param listingAddress The listingHash whose status is being updated
1367     */
1368     function updateStatus(address listingAddress) public {
1369         if (canBeWhitelisted(listingAddress)) {
1370             whitelistApplication(listingAddress);
1371         } else if (challengeCanBeResolved(listingAddress)) {
1372             resolveChallenge(listingAddress);
1373         } else {
1374             revert();
1375         }
1376     }
1377 
1378     /**
1379     @dev                  Updates an array of listingHashes' status from 'application' to 'listing' or resolves
1380                           a challenge if one exists.
1381     @param listingAddresses The listingHashes whose status are being updated
1382     */
1383     function updateStatuses(address[] listingAddresses) public {
1384         // loop through arrays, revealing each individual vote values
1385         for (uint i = 0; i < listingAddresses.length; i++) {
1386             updateStatus(listingAddresses[i]);
1387         }
1388     }
1389 
1390     // ----------------
1391     // TOKEN FUNCTIONS:
1392     // ----------------
1393 
1394     /**
1395     @dev                Called by a voter to claim their reward for each completed vote. Someone
1396                         must call updateStatus() before this can be called.
1397     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1398     @param _salt        The salt of a voter's commit hash in the given poll
1399     */
1400     function claimReward(uint _challengeID, uint _salt) public {
1401         // Ensures the voter has not already claimed tokens and challenge results have been processed
1402         require(challenges[_challengeID].tokenClaims[msg.sender] == false, "Reward already claimed");
1403         require(challenges[_challengeID].resolved == true, "Challenge not yet resolved");
1404 
1405         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1406         uint reward = voterReward(msg.sender, _challengeID, _salt);
1407 
1408         // Subtracts the voter's information to preserve the participation ratios
1409         // of other voters compared to the remaining pool of rewards
1410         challenges[_challengeID].totalTokens -= voterTokens;
1411         challenges[_challengeID].rewardPool -= reward;
1412 
1413         // Ensures a voter cannot claim tokens again
1414         challenges[_challengeID].tokenClaims[msg.sender] = true;
1415 
1416         require(token.transfer(msg.sender, reward), "Token transfer failed");
1417 
1418         emit _RewardClaimed(_challengeID, reward, msg.sender);
1419     }
1420 
1421     /**
1422     @dev                 Called by a voter to claim their rewards for each completed vote. Someone
1423                          must call updateStatus() before this can be called.
1424     @param _challengeIDs The PLCR pollIDs of the challenges rewards are being claimed for
1425     @param _salts        The salts of a voter's commit hashes in the given polls
1426     */
1427     function claimRewards(uint[] _challengeIDs, uint[] _salts) public {
1428         // make sure the array lengths are the same
1429         require(_challengeIDs.length == _salts.length, "Mismatch in length of _challengeIDs and _salts parameters");
1430 
1431         // loop through arrays, claiming each individual vote reward
1432         for (uint i = 0; i < _challengeIDs.length; i++) {
1433             claimReward(_challengeIDs[i], _salts[i]);
1434         }
1435     }
1436 
1437     // --------
1438     // GETTERS:
1439     // --------
1440 
1441     /**
1442     @dev                Calculates the provided voter's token reward for the given poll.
1443     @param _voter       The address of the voter whose reward balance is to be returned
1444     @param _challengeID The pollID of the challenge a reward balance is being queried for
1445     @param _salt        The salt of the voter's commit hash in the given poll
1446     @return             The uint indicating the voter's reward
1447     */
1448     function voterReward(address _voter, uint _challengeID, uint _salt)
1449     public view returns (uint) {
1450         uint totalTokens = challenges[_challengeID].totalTokens;
1451         uint rewardPool = challenges[_challengeID].rewardPool;
1452         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1453         return (voterTokens * rewardPool) / totalTokens;
1454     }
1455 
1456     /**
1457     @dev                Determines whether the given listingHash be whitelisted.
1458     @param listingAddress The listingHash whose status is to be examined
1459     */
1460     function canBeWhitelisted(address listingAddress) view public returns (bool) {
1461         uint challengeID = listings[listingAddress].challengeID;
1462 
1463         // Ensures that the application was made,
1464         // the application period has ended,
1465         // the listingHash can be whitelisted,
1466         // and either: the challengeID == 0, or the challenge has been resolved.
1467         if (
1468             appWasMade(listingAddress) &&
1469             listings[listingAddress].applicationExpiry < now &&
1470             !isWhitelisted(listingAddress) &&
1471             (challengeID == 0 || challenges[challengeID].resolved == true)
1472         ) { return true; }
1473 
1474         return false;
1475     }
1476 
1477     /**
1478     @dev                Returns true if the provided listingHash is whitelisted
1479     @param listingAddress The listingHash whose status is to be examined
1480     */
1481     function isWhitelisted(address listingAddress) view public returns (bool whitelisted) {
1482         return listings[listingAddress].whitelisted;
1483     }
1484 
1485     /**
1486     @dev                Returns true if apply was called for this listingHash
1487     @param listingAddress The listingHash whose status is to be examined
1488     */
1489     function appWasMade(address listingAddress) view public returns (bool exists) {
1490         return listings[listingAddress].applicationExpiry > 0;
1491     }
1492 
1493     /**
1494     @dev                Returns true if the application/listingHash has an unresolved challenge
1495     @param listingAddress The listingHash whose status is to be examined
1496     */
1497     function challengeExists(address listingAddress) view public returns (bool) {
1498         uint challengeID = listings[listingAddress].challengeID;
1499 
1500         return (listings[listingAddress].challengeID > 0 && !challenges[challengeID].resolved);
1501     }
1502 
1503     /**
1504     @dev                Determines whether voting has concluded in a challenge for a given
1505                         listingHash. Throws if no challenge exists.
1506     @param listingAddress A listingHash with an unresolved challenge
1507     */
1508     function challengeCanBeResolved(address listingAddress) view public returns (bool) {
1509         uint challengeID = listings[listingAddress].challengeID;
1510 
1511         require(challengeExists(listingAddress), "Challenge does not exist for Listing");
1512 
1513         return voting.pollEnded(challengeID);
1514     }
1515 
1516     /**
1517     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1518     @param _challengeID The challengeID to determine a reward for
1519     */
1520     function determineReward(uint _challengeID) public view returns (uint) {
1521         require(!challenges[_challengeID].resolved, "Challenge already resolved");
1522         require(voting.pollEnded(_challengeID), "Poll for challenge has not ended");
1523 
1524         // Edge case, nobody voted, give all tokens to the challenger.
1525         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1526             return 2 * challenges[_challengeID].stake;
1527         }
1528 
1529         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1530     }
1531 
1532     /**
1533     @dev                Getter for Challenge tokenClaims mappings
1534     @param _challengeID The challengeID to query
1535     @param _voter       The voter whose claim status to query for the provided challengeID
1536     */
1537     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1538         return challenges[_challengeID].tokenClaims[_voter];
1539     }
1540 
1541     // ----------------
1542     // PRIVATE FUNCTIONS:
1543     // ----------------
1544 
1545     /**
1546     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1547                         either whitelists or de-whitelists the listingHash.
1548     @param listingAddress A listingHash with a challenge that is to be resolved
1549     */
1550     function resolveChallenge(address listingAddress) internal {
1551         uint challengeID = listings[listingAddress].challengeID;
1552 
1553         // Calculates the winner's reward,
1554         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1555         uint reward = determineReward(challengeID);
1556 
1557         // Sets flag on challenge being processed
1558         challenges[challengeID].resolved = true;
1559 
1560         // Stores the total tokens used for voting by the winning side for reward purposes
1561         challenges[challengeID].totalTokens =
1562             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1563 
1564         // Case: challenge failed
1565         if (voting.isPassed(challengeID)) {
1566             whitelistApplication(listingAddress);
1567             // Unlock stake so that it can be retrieved by the applicant
1568             listings[listingAddress].unstakedDeposit += reward;
1569 
1570             emit _ChallengeFailed(listingAddress, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1571         }
1572         // Case: challenge succeeded or nobody voted
1573         else {
1574             resetListing(listingAddress);
1575             // Transfer the reward to the challenger
1576             require(token.transfer(challenges[challengeID].challenger, reward), "Token transfer failure");
1577 
1578             emit _ChallengeSucceeded(listingAddress, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1579         }
1580     }
1581 
1582     /**
1583     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1584                         challenge being made. Called by resolveChallenge() if an
1585                         application/listing beat a challenge.
1586     @param listingAddress The listingHash of an application/listingHash to be whitelisted
1587     */
1588     function whitelistApplication(address listingAddress) internal {
1589         if (!listings[listingAddress].whitelisted) { emit _ApplicationWhitelisted(listingAddress); }
1590         listings[listingAddress].whitelisted = true;
1591     }
1592 
1593     /**
1594     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1595     @param listingAddress The listing hash to delete
1596     */
1597     function resetListing(address listingAddress) internal {
1598         Listing storage listing = listings[listingAddress];
1599 
1600         // Emit events before deleting listing to check whether is whitelisted
1601         if (listing.whitelisted) {
1602             emit _ListingRemoved(listingAddress);
1603         } else {
1604             emit _ApplicationRemoved(listingAddress);
1605         }
1606 
1607         // Deleting listing to prevent reentry
1608         address owner = listing.owner;
1609         uint unstakedDeposit = listing.unstakedDeposit;
1610         delete listings[listingAddress];
1611 
1612         // Transfers any remaining balance back to the owner
1613         if (unstakedDeposit > 0){
1614             require(token.transfer(owner, unstakedDeposit), "Token transfer failure");
1615         }
1616     }
1617 }
1618 
1619 // File: contracts/tcr/ContractAddressRegistry.sol
1620 
1621 pragma solidity ^0.4.24;
1622 
1623 
1624 contract ContractAddressRegistry is AddressRegistry {
1625 
1626   modifier onlyContract(address contractAddress) {
1627     uint size;
1628     assembly { size := extcodesize(contractAddress) }
1629     require(size > 0, "Address is not a contract");
1630     _;
1631   }
1632 
1633   constructor(address _token, address _voting, address _parameterizer, string _name) public AddressRegistry(_token, _voting, _parameterizer, _name) {
1634   }
1635 
1636   // --------------------
1637   // PUBLISHER INTERFACE:
1638   // --------------------
1639 
1640   /**
1641   @notice Allows a user to start an application. Takes tokens from user and sets apply stage end time.
1642   --------
1643   In order to apply:
1644   1) Listing must not currently be whitelisted
1645   2) Listing must not currently be in application pahse
1646   3) Tokens deposited must be greater than or equal to the minDeposit value from the parameterizer
1647   4) Listing Address must point to contract
1648   --------
1649   Emits `_Application` event if successful
1650   @param amount The number of ERC20 tokens a user is willing to potentially stake
1651   @param data Extra data relevant to the application. Think IPFS hashes.
1652   */
1653   function apply(address listingAddress, uint amount, string data) onlyContract(listingAddress) public {
1654     super.apply(listingAddress, amount, data);
1655   }
1656 }
1657 
1658 // File: contracts/tcr/RestrictedAddressRegistry.sol
1659 
1660 pragma solidity ^0.4.24;
1661 
1662 
1663 
1664 contract RestrictedAddressRegistry is ContractAddressRegistry {
1665 
1666   modifier onlyContractOwner(address _contractAddress) {
1667     Ownable ownedContract = Ownable(_contractAddress);
1668     require(ownedContract.owner() == msg.sender, "Sender is not owner of contract");
1669     _;
1670   }
1671 
1672   constructor(address _token, address _voting, address _parameterizer, string _name) public ContractAddressRegistry(_token, _voting, _parameterizer, _name) {
1673   }
1674 
1675   // --------------------
1676   // PUBLISHER INTERFACE:
1677   // --------------------
1678 
1679   /**
1680   @notice Allows a user to start an application. Takes tokens from user and sets apply stage end time.
1681   --------
1682   In order to apply:
1683   1) Listing must not currently be whitelisted
1684   2) Listing must not currently be in application pahse
1685   3) Tokens deposited must be greater than or equal to the minDeposit value from the parameterizer
1686   4) Listing Address must point to owned contract
1687   5) Sender of message must be owner of contract at Listing Address
1688   --------
1689   Emits `_Application` event if successful
1690   @param amount The number of ERC20 tokens a user is willing to potentially stake
1691   @param data Extra data relevant to the application. Think IPFS hashes.
1692   */
1693   function apply(address listingAddress, uint amount, string data) onlyContractOwner(listingAddress) public {
1694     super.apply(listingAddress, amount, data);
1695   }
1696 }
1697 
1698 // File: contracts/interfaces/IGovernment.sol
1699 
1700 pragma solidity ^0.4.19;
1701 
1702 /**
1703 @title IGovernment
1704 @notice This is an interface that defines the functionality required by a Government
1705 The functions herein are accessed by the CivilTCR contract as part of the appeals process.
1706 @author Nick Reynolds - nick@joincivil.com
1707 */
1708 interface IGovernment {
1709   function getAppellate() public view returns (address);
1710   function getGovernmentController() public view returns (address);
1711   function get(string name) public view returns (uint);
1712 }
1713 
1714 // File: contracts/proof-of-use/telemetry/TokenTelemetryI.sol
1715 
1716 pragma solidity ^0.4.23;
1717 
1718 interface TokenTelemetryI {
1719   function onRequestVotingRights(address user, uint tokenAmount) external;
1720 }
1721 
1722 // File: contracts/tcr/CivilPLCRVoting.sol
1723 
1724 pragma solidity ^0.4.23;
1725 
1726 
1727 
1728 /**
1729 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
1730 */
1731 contract CivilPLCRVoting is PLCRVoting {
1732 
1733   TokenTelemetryI public telemetry;
1734 
1735   /**
1736   @dev Initializer. Can only be called once.
1737   @param tokenAddr The address where the ERC20 token contract is deployed
1738   @param telemetryAddr The address where the TokenTelemetry contract is deployed
1739   */
1740   constructor(address tokenAddr, address telemetryAddr) public PLCRVoting(tokenAddr) {
1741     require(telemetryAddr != 0);
1742     telemetry = TokenTelemetryI(telemetryAddr);
1743   }
1744 
1745   /**
1746     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
1747     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
1748     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
1749     @dev Differs from base implementation in that it records use of token in mapping for "proof of use"
1750   */
1751   function requestVotingRights(uint _numTokens) public {
1752     super.requestVotingRights(_numTokens);
1753     telemetry.onRequestVotingRights(msg.sender, voteTokenBalance[msg.sender]);
1754   }
1755 
1756   /**
1757   @param _pollID Integer identifier associated with target poll
1758   @param _salt Arbitrarily chosen integer used to generate secretHash
1759   @return correctVotes Number of tokens voted for losing option
1760   */
1761   function getNumLosingTokens(address _voter, uint _pollID, uint _salt) public view returns (uint correctVotes) {
1762     require(pollEnded(_pollID));
1763     require(pollMap[_pollID].didReveal[_voter]);
1764 
1765     uint losingChoice = isPassed(_pollID) ? 0 : 1;
1766     bytes32 loserHash = keccak256(losingChoice, _salt);
1767     bytes32 commitHash = getCommitHash(_voter, _pollID);
1768 
1769     require(loserHash == commitHash);
1770 
1771     return getNumTokens(_voter, _pollID);
1772   }
1773 
1774   /**
1775   @dev Gets the total losing votes for reward distribution purposes
1776   @param _pollID Integer identifier associated with target poll
1777   @return Total number of votes committed to the losing option for specified poll
1778   */
1779   function getTotalNumberOfTokensForLosingOption(uint _pollID) public view returns (uint numTokens) {
1780     require(pollEnded(_pollID));
1781 
1782     if (isPassed(_pollID))
1783       return pollMap[_pollID].votesAgainst;
1784     else
1785       return pollMap[_pollID].votesFor;
1786   }
1787 
1788 }
1789 
1790 // File: contracts/tcr/CivilParameterizer.sol
1791 
1792 pragma solidity ^0.4.19;
1793 
1794 
1795 contract CivilParameterizer is Parameterizer {
1796 
1797   /**
1798   @param tokenAddr           The address where the ERC20 token contract is deployed
1799   @param plcrAddr            address of a PLCR voting contract for the provided token
1800   @notice parameters     array of canonical parameters
1801   */
1802   constructor(
1803     address tokenAddr,
1804     address plcrAddr,
1805     uint[] parameters
1806   ) public Parameterizer(tokenAddr, plcrAddr, parameters)
1807   {
1808     set("challengeAppealLen", parameters[12]);
1809     set("challengeAppealCommitLen", parameters[13]);
1810     set("challengeAppealRevealLen", parameters[14]);
1811   }
1812 }
1813 
1814 // File: contracts/tcr/CivilTCR.sol
1815 
1816 pragma solidity ^0.4.24;
1817 
1818 
1819 
1820 
1821 
1822 
1823 /**
1824 @title CivilTCR - Token Curated Registry with Appeallate Functionality and Restrictions on Application
1825 @author Nick Reynolds - nick@civil.co / engineering@civil.co
1826 @notice The CivilTCR is a TCR with restrictions (address applied for must be a contract with Owned
1827 implementated, and only the owner of a contract can apply on behalf of that contract), an appeallate entity that can
1828 overturn challenges if someone requests an appeal, and a process by which granted appeals can be vetoed by a supermajority vote.
1829 A Granted Appeal reverses the result of the challenge vote (including which parties are considered the winners & receive rewards).
1830 A successful Appeal Challenge reverses the result of the Granted Appeal (again, including the winners).
1831 */
1832 contract CivilTCR is RestrictedAddressRegistry {
1833 
1834   event _AppealRequested(address indexed listingAddress, uint indexed challengeID, uint appealFeePaid, address requester, string data);
1835   event _AppealGranted(address indexed listingAddress, uint indexed challengeID, string data);
1836   event _FailedChallengeOverturned(address indexed listingAddress, uint indexed challengeID, uint rewardPool, uint totalTokens);
1837   event _SuccessfulChallengeOverturned(address indexed listingAddress, uint indexed challengeID, uint rewardPool, uint totalTokens);
1838   event _GrantedAppealChallenged(address indexed listingAddress, uint indexed challengeID, uint indexed appealChallengeID, string data);
1839   event _GrantedAppealOverturned(address indexed listingAddress, uint indexed challengeID, uint indexed appealChallengeID, uint rewardPool, uint totalTokens);
1840   event _GrantedAppealConfirmed(address indexed listingAddress, uint indexed challengeID, uint indexed appealChallengeID, uint rewardPool, uint totalTokens);
1841   event _GovernmentTransfered(address newGovernment);
1842 
1843   modifier onlyGovernmentController {
1844     require(msg.sender == government.getGovernmentController(), "sender was not the Government Controller");
1845     _;
1846   }
1847 
1848   /**
1849   @notice modifier that checks that the sender of a message is the Appellate entity set by the Government
1850   */
1851   modifier onlyAppellate {
1852     require(msg.sender == government.getAppellate(), "sender was not the Appellate");
1853     _;
1854   }
1855 
1856   CivilPLCRVoting public civilVoting;
1857   IGovernment public government;
1858 
1859   /*
1860   @notice this struct handles the state of an appeal. It is first initialized
1861   when an appeal is requested
1862   */
1863   struct Appeal {
1864     address requester;
1865     uint appealFeePaid;
1866     uint appealPhaseExpiry;
1867     bool appealGranted;
1868     uint appealOpenToChallengeExpiry;
1869     uint appealChallengeID;
1870     bool overturned;
1871   }
1872 
1873   mapping(uint => uint) public challengeRequestAppealExpiries;
1874   mapping(uint => Appeal) public appeals; // map challengeID to appeal
1875 
1876   /**
1877   @notice Init function calls AddressRegistry init then sets IGovernment
1878   @dev passes tokenAddr, plcrAddr, paramsAddr up to RestrictedAddressRegistry constructor
1879   @param token TCR's intrinsic ERC20 token
1880   @param plcr CivilPLCR voting contract for the provided token
1881   @param param CivilParameterizer contract
1882   @param govt IGovernment contract
1883   */
1884   constructor(
1885     IERC20 token,
1886     CivilPLCRVoting plcr,
1887     CivilParameterizer param,
1888     IGovernment govt
1889   ) public RestrictedAddressRegistry(token, address(plcr), address(param), "CivilTCR")
1890   {
1891     require(address(govt) != 0, "govt address was zero");
1892     require(govt.getGovernmentController() != 0, "govt.getGovernmentController address was 0");
1893     civilVoting = plcr;
1894     government = govt;
1895   }
1896 
1897   // --------------------
1898   // LISTING OWNER INTERFACE:
1899   // --------------------
1900 
1901   /**
1902   @dev Allows a user to start an application. Takes tokens from user and sets apply stage end time.
1903   @param listingAddress The hash of a potential listing a user is applying to add to the registry
1904   @param amount The number of ERC20 tokens a user is willing to potentially stake
1905   @param data Extra data relevant to the application. Think IPFS hashes.
1906   */
1907   function apply(address listingAddress, uint amount, string data) public {
1908     super.apply(listingAddress, amount, data);
1909   }
1910 
1911   /**
1912   @notice Requests an appeal for a listing that has been challenged and completed its voting
1913   phase, but has not passed its challengeRequestAppealExpiries time.
1914   --------
1915   In order to request appeal, the following conditions must be met:
1916   1) voting for challenge has ended
1917   2) request appeal expiry has not passed
1918   3) appeal not already requested
1919   4) appeal requester transfers appealFee to TCR
1920   --------
1921   Initializes `Appeal` struct in `appeals` mapping for active challenge on listing at given address.
1922   --------
1923   Emits `_AppealRequested` if successful
1924   @param listingAddress address of listing that has challenged result that the user wants to appeal
1925   @param data Extra data relevant to the spprsl. Think IPFS hashes.
1926   */
1927   function requestAppeal(address listingAddress, string data) external {
1928     Listing storage listing = listings[listingAddress];
1929     require(voting.pollEnded(listing.challengeID), "Poll for listing challenge has not ended");
1930     require(challengeRequestAppealExpiries[listing.challengeID] > now, "Request Appeal phase is over"); // "Request Appeal Phase" active
1931     require(appeals[listing.challengeID].requester == address(0), "Appeal for this challenge has already been made");
1932 
1933     uint appealFee = government.get("appealFee");
1934     Appeal storage appeal = appeals[listing.challengeID];
1935     appeal.requester = msg.sender;
1936     appeal.appealFeePaid = appealFee;
1937     appeal.appealPhaseExpiry = now.add(government.get("judgeAppealLen"));
1938     require(token.transferFrom(msg.sender, this, appealFee), "Token transfer failed");
1939     emit _AppealRequested(listingAddress, listing.challengeID, appealFee, msg.sender, data);
1940   }
1941 
1942   // --------
1943   // APPELLATE INTERFACE:
1944   // --------
1945 
1946   /**
1947   @notice Grants a requested appeal.
1948   --------
1949   In order to grant an appeal:
1950   1) Message sender must be appellate entity as set by IGovernment contract
1951   2) An appeal has been requested
1952   3) The appeal phase expiry has not passed
1953   4) An appeal has not yet been granted
1954   --------
1955   Updates `Appeal` struct for appeal of active challenge for listing at given address by setting `appealGranted` to true and
1956   setting the `appealOpenToChallengeExpiry` value to a future time based on current value of `challengeAppealLen` in the Parameterizer.
1957   --------
1958   Emits `_AppealGranted` if successful
1959   @param listingAddress The address of the listing associated with the appeal
1960   @param data Extra data relevant to the appeal. Think IPFS hashes.
1961   */
1962   function grantAppeal(address listingAddress, string data) external onlyAppellate {
1963     Listing storage listing = listings[listingAddress];
1964     Appeal storage appeal = appeals[listing.challengeID];
1965     require(appeal.appealPhaseExpiry > now, "Judge Appeal phase not active"); // "Judge Appeal Phase" active
1966     require(!appeal.appealGranted, "Appeal has already been granted"); // don't grant twice
1967 
1968     appeal.appealGranted = true;
1969     appeal.appealOpenToChallengeExpiry = now.add(parameterizer.get("challengeAppealLen"));
1970     emit _AppealGranted(listingAddress, listing.challengeID, data);
1971   }
1972 
1973   /**
1974   @notice Updates IGovernment instance.
1975   --------
1976   Can only be called by Government Controller.
1977   --------
1978   Emits `_GovernmentTransfered` if successful.
1979   */
1980   function transferGovernment(IGovernment newGovernment) external onlyGovernmentController {
1981     require(address(newGovernment) != address(0), "New Government address is 0");
1982     government = newGovernment;
1983     emit _GovernmentTransfered(newGovernment);
1984   }
1985 
1986   // --------
1987   // ANY USER INTERFACE
1988   // ANYONE CAN CALL THESE FUNCTIONS FOR A LISTING
1989   // --------
1990 
1991   /**
1992   @notice Updates a listing's status from 'application' to 'listing', or resolves a challenge or appeal
1993   or appeal challenge if one exists. Reverts if none of `canBeWhitelisted`, `challengeCanBeResolved`, or
1994   `appealCanBeResolved` is true for given `listingAddress`.
1995   @param listingAddress Address of the listing of which the status is being updated
1996   */
1997   function updateStatus(address listingAddress) public {
1998     if (canBeWhitelisted(listingAddress)) {
1999       whitelistApplication(listingAddress);
2000     } else if (challengeCanBeResolved(listingAddress)) {
2001       resolveChallenge(listingAddress);
2002     } else if (appealCanBeResolved(listingAddress)) {
2003       resolveAppeal(listingAddress);
2004     } else if (appealChallengeCanBeResolved(listingAddress)) {
2005       resolveAppealChallenge(listingAddress);
2006     } else {
2007       revert();
2008     }
2009   }
2010 
2011   /**
2012   @notice Update state of listing after "Judge Appeal Phase" has ended. Reverts if cannot be processed yet.
2013   @param listingAddress Address of listing associated with appeal
2014   */
2015   function resolveAppeal(address listingAddress) internal {
2016     Listing listing = listings[listingAddress];
2017     Appeal appeal = appeals[listing.challengeID];
2018     if (appeal.appealGranted) {
2019       // appeal granted. override decision of voters.
2020       resolveOverturnedChallenge(listingAddress);
2021       // return appeal fee to appeal requester
2022       require(token.transfer(appeal.requester, appeal.appealFeePaid), "Token transfer failed");
2023     } else {
2024       // appeal fee is split between original winning voters and challenger
2025       Challenge storage challenge = challenges[listing.challengeID];
2026       uint extraReward = appeal.appealFeePaid.div(2);
2027       challenge.rewardPool = challenge.rewardPool.add(extraReward);
2028       challenge.stake = challenge.stake.add(appeal.appealFeePaid.sub(extraReward));
2029       // appeal not granted, confirm original decision of voters.
2030       super.resolveChallenge(listingAddress);
2031     }
2032   }
2033 
2034   // --------------------
2035   // TOKEN OWNER INTERFACE:
2036   // --------------------
2037 
2038   /**
2039   @notice Starts a poll for a listingAddress which is either in the apply stage or already in the whitelist.
2040   Tokens are taken from the challenger and the applicant's deposits are locked.
2041   Delists listing and returns 0 if listing's unstakedDeposit is less than current minDeposit
2042   @dev  Differs from base implementation in that it stores a timestamp in a mapping
2043   corresponding to the end of the request appeal phase, at which point a challenge
2044   can be resolved, if no appeal was requested
2045   @param listingAddress The listingAddress being challenged, whether listed or in application
2046   @param data Extra data relevant to the challenge. Think IPFS hashes.
2047   */
2048   function challenge(address listingAddress, string data) public returns (uint challengeID) {
2049     uint id = super.challenge(listingAddress, data);
2050     if (id > 0) {
2051       uint challengeLength = parameterizer.get("commitStageLen").add(parameterizer.get("revealStageLen")).add(government.get("requestAppealLen"));
2052       challengeRequestAppealExpiries[id] = now.add(challengeLength);
2053     }
2054     return id;
2055   }
2056 
2057   /**
2058   @notice Starts a poll for a listingAddress which has recently been granted an appeal. If
2059   the poll passes, the granted appeal will be overturned.
2060   --------
2061   In order to start a challenge:
2062   1) There is an active appeal on the listing
2063   2) This appeal was granted
2064   3) This appeal has not yet been challenged
2065   4) The expiry time of the appeal challenge is greater than the current time
2066   5) The challenger transfers tokens to the TCR equal to appeal fee paid by appeal requester
2067   --------
2068   Initializes `Challenge` struct in `challenges` mapping
2069   --------
2070   Emits `_GrantedAppealChallenged` if successful, and sets value of `appealChallengeID` on appeal being challenged.
2071   @return challengeID associated with the appeal challenge
2072   @dev challengeID is a nonce created by the PLCRVoting contract, regular challenges and appeal challenges share the same nonce variable
2073   @param listingAddress The listingAddress associated with the appeal
2074   @param data Extra data relevant to the appeal challenge. Think URLs.
2075   */
2076   function challengeGrantedAppeal(address listingAddress, string data) public returns (uint challengeID) {
2077     Listing storage listing = listings[listingAddress];
2078     Appeal storage appeal = appeals[listing.challengeID];
2079     require(appeal.appealGranted, "Appeal not granted");
2080     require(appeal.appealChallengeID == 0, "Appeal already challenged");
2081     require(appeal.appealOpenToChallengeExpiry > now, "Appeal no longer open to challenge");
2082 
2083     uint pollID = voting.startPoll(
2084       government.get("appealVotePercentage"),
2085       parameterizer.get("challengeAppealCommitLen"),
2086       parameterizer.get("challengeAppealRevealLen")
2087     );
2088 
2089     uint oneHundred = 100;
2090     uint reward = (oneHundred.sub(government.get("appealChallengeVoteDispensationPct"))).mul(appeal.appealFeePaid).div(oneHundred);
2091     challenges[pollID] = Challenge({
2092       challenger: msg.sender,
2093       rewardPool: reward,
2094       stake: appeal.appealFeePaid,
2095       resolved: false,
2096       totalTokens: 0
2097     });
2098 
2099     appeal.appealChallengeID = pollID;
2100 
2101     require(token.transferFrom(msg.sender, this, appeal.appealFeePaid), "Token transfer failed");
2102     emit _GrantedAppealChallenged(listingAddress, listing.challengeID, pollID, data);
2103     return pollID;
2104   }
2105 
2106 
2107   /**
2108   @notice Determines the winner in an appeal challenge. Rewards the winner tokens and
2109   either whitelists or delists the listing at the given address. Also resolves the underlying
2110   challenge that was originally appealed.
2111   Emits `_GrantedAppealConfirmed` if appeal challenge unsuccessful (vote not passed).
2112   Emits `_GrantedAppealOverturned` if appeal challenge successful (vote passed).
2113   @param listingAddress The address of a listing with an appeal challenge that is to be resolved
2114   */
2115   function resolveAppealChallenge(address listingAddress) internal {
2116     Listing storage listing = listings[listingAddress];
2117     uint challengeID = listings[listingAddress].challengeID;
2118     Appeal storage appeal = appeals[listing.challengeID];
2119     uint appealChallengeID = appeal.appealChallengeID;
2120     Challenge storage appealChallenge = challenges[appeal.appealChallengeID];
2121 
2122     // Calculates the winner's reward,
2123     // which is: (winner's full stake) + (dispensationPct * loser's stake)
2124     uint reward = determineReward(appealChallengeID);
2125 
2126     // Sets flag on challenge being processed
2127     appealChallenge.resolved = true;
2128 
2129     // Stores the total tokens used for voting by the winning side for reward purposes
2130     appealChallenge.totalTokens = voting.getTotalNumberOfTokensForWinningOption(appealChallengeID);
2131 
2132     if (voting.isPassed(appealChallengeID)) { // Case: vote passed, appeal challenge succeeded, overturn appeal
2133       appeal.overturned = true;
2134       super.resolveChallenge(listingAddress);
2135       require(token.transfer(appealChallenge.challenger, reward), "Token transfer failed");
2136       emit _GrantedAppealOverturned(listingAddress, challengeID, appealChallengeID, appealChallenge.rewardPool, appealChallenge.totalTokens);
2137     } else { // Case: vote not passed, appeal challenge failed, confirm appeal
2138       resolveOverturnedChallenge(listingAddress);
2139       require(token.transfer(appeal.requester, reward), "Token transfer failed");
2140       emit _GrantedAppealConfirmed(listingAddress, challengeID, appealChallengeID, appealChallenge.rewardPool, appealChallenge.totalTokens);
2141     }
2142   }
2143 
2144   /**
2145   @dev Called by a voter to claim their reward for each completed vote. Someone must call
2146   updateStatus() before this can be called.
2147   @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
2148   @param _salt        The salt of a voter's commit hash in the given poll
2149   */
2150   function claimReward(uint _challengeID, uint _salt) public {
2151     // Ensures the voter has not already claimed tokens and challenge results have been processed
2152     require(challenges[_challengeID].tokenClaims[msg.sender] == false, "Reward already claimed");
2153     require(challenges[_challengeID].resolved == true, "Challenge not yet resolved");
2154 
2155     uint voterTokens = getNumChallengeTokens(msg.sender, _challengeID, _salt);
2156     uint reward = voterReward(msg.sender, _challengeID, _salt);
2157 
2158     // Subtracts the voter's information to preserve the participation ratios
2159     // of other voters compared to the remaining pool of rewards
2160     challenges[_challengeID].totalTokens = challenges[_challengeID].totalTokens.sub(voterTokens);
2161     challenges[_challengeID].rewardPool = challenges[_challengeID].rewardPool.sub(reward);
2162 
2163     // Ensures a voter cannot claim tokens again
2164     challenges[_challengeID].tokenClaims[msg.sender] = true;
2165 
2166     require(token.transfer(msg.sender, reward), "Token transfer failed");
2167 
2168     emit _RewardClaimed(_challengeID, reward, msg.sender);
2169   }
2170 
2171   /**
2172   @notice gets the number of tokens the voter staked on the winning side of the challenge,
2173   or the losing side if the challenge has been overturned
2174   @param voter The Voter to check
2175   @param challengeID The PLCR pollID of the challenge to check
2176   @param salt The salt of a voter's commit hash in the given poll
2177   */
2178   function getNumChallengeTokens(address voter, uint challengeID, uint salt) internal view returns (uint) {
2179     // a challenge is overturned if an appeal for it was granted, but the appeal itself was not overturned
2180     bool challengeOverturned = appeals[challengeID].appealGranted && !appeals[challengeID].overturned;
2181     if (challengeOverturned) {
2182       return civilVoting.getNumLosingTokens(voter, challengeID, salt);
2183     } else {
2184       return voting.getNumPassingTokens(voter, challengeID, salt);
2185     }
2186   }
2187 
2188   /**
2189   @dev Determines the number of tokens awarded to the winning party in a challenge.
2190   @param challengeID The challengeID to determine a reward for
2191   */
2192   function determineReward(uint challengeID) public view returns (uint) {
2193     // a challenge is overturned if an appeal for it was granted, but the appeal itself was not overturned
2194     require(!challenges[challengeID].resolved, "Challenge already resolved");
2195     require(voting.pollEnded(challengeID), "Poll for challenge has not ended");
2196     bool challengeOverturned = appeals[challengeID].appealGranted && !appeals[challengeID].overturned;
2197     // Edge case, nobody voted, give all tokens to the challenger.
2198     if (challengeOverturned) {
2199       if (civilVoting.getTotalNumberOfTokensForLosingOption(challengeID) == 0) {
2200         return 2 * challenges[challengeID].stake;
2201       }
2202     } else {
2203       if (voting.getTotalNumberOfTokensForWinningOption(challengeID) == 0) {
2204         return 2 * challenges[challengeID].stake;
2205       }
2206     }
2207 
2208     return (2 * challenges[challengeID].stake) - challenges[challengeID].rewardPool;
2209   }
2210 
2211   /**
2212   @notice Calculates the provided voter's token reward for the given poll.
2213   @dev differs from implementation in `AddressRegistry` in that it takes into consideration whether an
2214   appeal was granted and possible overturned via appeal challenge.
2215   @param voter The address of the voter whose reward balance is to be returned
2216   @param challengeID The pollID of the challenge a reward balance is being queried for
2217   @param salt The salt of the voter's commit hash in the given poll
2218   @return The uint indicating the voter's reward
2219   */
2220   function voterReward(
2221     address voter,
2222     uint challengeID,
2223     uint salt
2224   ) public view returns (uint)
2225   {
2226     Challenge challenge = challenges[challengeID];
2227     uint totalTokens = challenge.totalTokens;
2228     uint rewardPool = challenge.rewardPool;
2229     uint voterTokens = getNumChallengeTokens(voter, challengeID, salt);
2230     return (voterTokens.mul(rewardPool)).div(totalTokens);
2231   }
2232 
2233   /**
2234   @dev Called by updateStatus() if the applicationExpiry date passed without a challenge being made.
2235   Called by resolveChallenge() if an application/listing beat a challenge. Differs from base
2236   implementation in thatit also clears out challengeID
2237   @param listingAddress The listingHash of an application/listingHash to be whitelisted
2238   */
2239   function whitelistApplication(address listingAddress) internal {
2240     super.whitelistApplication(listingAddress);
2241     listings[listingAddress].challengeID = 0;
2242   }
2243 
2244   /**
2245   @notice Updates the state of a listing after a challenge was overtuned via appeal (and no appeal
2246   challenge was initiated). If challenge previously failed, transfer reward to original challenger.
2247   Otherwise, add reward to listing's unstaked deposit
2248   --------
2249   Emits `_FailedChallengeOverturned` if original challenge failed.
2250   Emits `_SuccessfulChallengeOverturned` if original challenge succeeded.
2251   Emits `_ListingRemoved` if original challenge failed and listing was previous whitelisted.
2252   Emits `_ApplicationRemoved` if original challenge failed and listing was not previously whitelisted.
2253   Emits `_ApplicationWhitelisted` if original challenge succeeded and listing was not previously whitelisted.
2254   @param listingAddress Address of listing with a challenge that is to be resolved
2255   */
2256   function resolveOverturnedChallenge(address listingAddress) private {
2257     Listing storage listing = listings[listingAddress];
2258     uint challengeID = listing.challengeID;
2259     Challenge storage challenge = challenges[challengeID];
2260     // Calculates the winner's reward,
2261     uint reward = determineReward(challengeID);
2262 
2263     challenge.resolved = true;
2264     // Stores the total tokens used for voting by the losing side for reward purposes
2265     challenge.totalTokens = civilVoting.getTotalNumberOfTokensForLosingOption(challengeID);
2266 
2267     // challenge is overturned, behavior here is opposite resolveChallenge
2268     if (!voting.isPassed(challengeID)) { // original vote failed (challenge succeded), this should whitelist listing
2269       whitelistApplication(listingAddress);
2270       // Unlock stake so that it can be retrieved by the applicant
2271       listing.unstakedDeposit = listing.unstakedDeposit.add(reward);
2272 
2273       emit _SuccessfulChallengeOverturned(listingAddress, challengeID, challenge.rewardPool, challenge.totalTokens);
2274     } else { // original vote succeded (challenge failed), this should de-list listing
2275       resetListing(listingAddress);
2276       // Transfer the reward to the challenger
2277       require(token.transfer(challenge.challenger, reward), "Token transfer failed");
2278 
2279       emit _FailedChallengeOverturned(listingAddress, challengeID, challenge.rewardPool, challenge.totalTokens);
2280     }
2281   }
2282 
2283   /**
2284   @notice Determines whether a challenge can be resolved for a listing at given address. Throws if no challenge exists.
2285   @param listingAddress An address for a listing to check
2286   @return True if challenge exists, has not already been resolved, has not had appeal requested, and has passed the request
2287   appeal expiry time. False otherwise.
2288   */
2289   function challengeCanBeResolved(address listingAddress) view public returns (bool canBeResolved) {
2290     uint challengeID = listings[listingAddress].challengeID;
2291     require(challengeExists(listingAddress), "Challenge does not exist for listing");
2292     if (challengeRequestAppealExpiries[challengeID] > now) {
2293       return false;
2294     }
2295     return (appeals[challengeID].appealPhaseExpiry == 0);
2296   }
2297 
2298   /**
2299   @notice Determines whether an appeal can be resolved for a listing at given address. Throws if no challenge exists.
2300   @param listingAddress An address for a listing to check
2301   @return True if challenge exists, has not already been resolved, has had appeal requested, and has either
2302   (1) had an appeal granted and passed the appeal opten to challenge expiry OR (2) has not had an appeal granted and
2303   has passed the appeal phase expiry. False otherwise.
2304   */
2305   function appealCanBeResolved(address listingAddress) view public returns (bool canBeResolved) {
2306     uint challengeID = listings[listingAddress].challengeID;
2307     Appeal appeal = appeals[challengeID];
2308     require(challengeExists(listingAddress), "Challenge does not exist for listing");
2309     if (appeal.appealPhaseExpiry == 0) {
2310       return false;
2311     }
2312     if (!appeal.appealGranted) {
2313       return appeal.appealPhaseExpiry < now;
2314     } else {
2315       return appeal.appealOpenToChallengeExpiry < now && appeal.appealChallengeID == 0;
2316     }
2317   }
2318 
2319   /**
2320   @notice Determines whether an appeal challenge can be resolved for a listing at given address. Throws if no challenge exists.
2321   @param listingAddress An address for a listing to check
2322   @return True if appeal challenge exists, has not already been resolved, and the voting phase for the appeal challenge is ended. False otherwise.
2323   */
2324   function appealChallengeCanBeResolved(address listingAddress) view public returns (bool canBeResolved) {
2325     uint challengeID = listings[listingAddress].challengeID;
2326     Appeal appeal = appeals[challengeID];
2327     require(challengeExists(listingAddress), "Challenge does not exist for listing");
2328     if (appeal.appealChallengeID == 0) {
2329       return false;
2330     }
2331     return voting.pollEnded(appeal.appealChallengeID);
2332   }
2333 }