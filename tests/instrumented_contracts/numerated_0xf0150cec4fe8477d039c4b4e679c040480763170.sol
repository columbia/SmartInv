1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: contracts/Interface/EIP20Interface.sol
120 
121 contract EIP20Interface {
122     /* This is a slight change to the ERC20 base standard.
123     function totalSupply() constant returns (uint256 supply);
124     is replaced with:
125     uint256 public totalSupply;
126     This automatically creates a getter function for the totalSupply.
127     This is moved to the base contract since public getter functions are not
128     currently recognised as an implementation of the matching abstract
129     function by the compiler.
130     */
131     /// total amount of tokens
132     function totalSupply() public view returns (uint256 supply);
133 
134     /// @param _owner The address from which the balance will be retrieved
135     /// @return The balanceπ
136     function balanceOf(address _owner) public view returns (uint256 balance);
137 
138     /// @notice send `_value` token to `_to` from `msg.sender`
139     /// @param _to The address of the recipient
140     /// @param _value The amount of token to be transferred
141     /// @return Whether the transfer was successful or not
142     function transfer(address _to, uint256 _value) public returns (bool success);
143 
144     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
145     /// @param _from The address of the sender
146     /// @param _to The address of the recipient
147     /// @param _value The amount of token to be transferred
148     /// @return Whether the transfer was successful or not
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
150 
151     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
152     /// @param _spender The address of the account able to transfer the tokens
153     /// @param _value The amount of tokens to be approved for transfer
154     /// @return Whether the approval was successful or not
155     function approve(address _spender, uint256 _value) public returns (bool success);
156 
157     /// @param _owner The address of the account owning tokens
158     /// @param _spender The address of the account able to transfer the tokens
159     /// @return Amount of remaining tokens allowed to spent
160     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
161 
162     // solhint-disable-next-line no-simple-event-func-name
163     event Transfer(address indexed _from, address indexed _to, uint256 _value);
164     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
165 }
166 
167 // File: contracts/CanCheckERC165.sol
168 
169 contract CanCheckERC165 {
170     bytes4 constant InvalidID = 0xffffffff;
171     bytes4 constant ERC165ID = 0x01ffc9a7;
172     function doesContractImplementInterface(address _contract, bytes4 _interfaceId) external view returns (bool) {
173         uint256 success;
174         uint256 result;
175 
176         (success, result) = noThrowCall(_contract, ERC165ID);
177         if ((success==0)||(result==0)) {
178             return false;
179         }
180 
181         (success, result) = noThrowCall(_contract, InvalidID);
182         if ((success==0)||(result!=0)) {
183             return false;
184         }
185 
186         (success, result) = noThrowCall(_contract, _interfaceId);
187         if ((success==1)&&(result==1)) {
188             return true;
189         }
190         return false;
191     }
192 
193     function noThrowCall(address _contract, bytes4 _interfaceId) internal view returns (uint256 success, uint256 result) {
194         bytes4 erc165ID = ERC165ID;
195 
196         assembly {
197                 let x := mload(0x40)               // Find empty storage location using "free memory pointer"
198                 mstore(x, erc165ID)                // Place signature at begining of empty storage
199                 mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
200 
201                 success := staticcall(
202                                     30000,         // 30k gas
203                                     _contract,     // To addr
204                                     x,             // Inputs are stored at location x
205                                     0x20,          // Inputs are 32 bytes long
206                                     x,             // Store output over input (saves space)
207                                     0x20)          // Outputs are 32 bytes long
208 
209                 result := mload(x)                 // Load the result
210         }
211     }
212 }
213 
214 // File: contracts/PLCRVoting.sol
215 
216 library DLL {
217     uint constant NULL_NODE_ID = 0;
218 
219     struct Node {
220         uint next;
221         uint prev;
222     }
223 
224     struct Data {
225         mapping(uint => Node) dll;
226     }
227 
228     function isEmpty(Data storage self) public view returns (bool) {
229         return getStart(self) == NULL_NODE_ID;
230     }
231 
232     function contains(Data storage self, uint _curr) public view returns (bool) {
233         if (isEmpty(self) || _curr == NULL_NODE_ID) {
234             return false;
235         } 
236 
237         bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
238         bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
239         return isSingleNode || !isNullNode;
240     }
241 
242     function getNext(Data storage self, uint _curr) public view returns (uint) {
243         return self.dll[_curr].next;
244     }
245 
246     function getPrev(Data storage self, uint _curr) public view returns (uint) {
247         return self.dll[_curr].prev;
248     }
249 
250     function getStart(Data storage self) public view returns (uint) {
251         return getNext(self, NULL_NODE_ID);
252     }
253 
254     function getEnd(Data storage self) public view returns (uint) {
255         return getPrev(self, NULL_NODE_ID);
256     }
257 
258     /**
259     @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
260     the list it will be automatically removed from the old position.
261     @param _prev the node which _new will be inserted after
262     @param _curr the id of the new node being inserted
263     @param _next the node which _new will be inserted before
264     */
265     function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
266         require(_curr != NULL_NODE_ID);
267 
268         remove(self, _curr);
269 
270         require(_prev == NULL_NODE_ID || contains(self, _prev));
271         require(_next == NULL_NODE_ID || contains(self, _next));
272 
273         require(getNext(self, _prev) == _next);
274         require(getPrev(self, _next) == _prev);
275 
276         self.dll[_curr].prev = _prev;
277         self.dll[_curr].next = _next;
278 
279         self.dll[_prev].next = _curr;
280         self.dll[_next].prev = _curr;
281     }
282 
283     function remove(Data storage self, uint _curr) public {
284         if (!contains(self, _curr)) {
285             return;
286         }
287 
288         uint next = getNext(self, _curr);
289         uint prev = getPrev(self, _curr);
290 
291         self.dll[next].prev = prev;
292         self.dll[prev].next = next;
293 
294         delete self.dll[_curr];
295     }
296 }
297 
298 library AttributeStore {
299     struct Data {
300         mapping(bytes32 => uint) store;
301     }
302 
303     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
304     public view returns (uint) {
305         bytes32 key = keccak256(_UUID, _attrName);
306         return self.store[key];
307     }
308 
309     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
310     public {
311         bytes32 key = keccak256(_UUID, _attrName);
312         self.store[key] = _attrVal;
313     }
314 }
315 
316 
317 /**
318 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
319 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
320 */
321 contract PLCRVoting {
322 
323     // ============
324     // EVENTS:
325     // ============
326 
327     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
328     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter);
329     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
330     event _VotingRightsGranted(uint numTokens, address indexed voter);
331     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
332     event _TokensRescued(uint indexed pollID, address indexed voter);
333 
334     // ============
335     // DATA STRUCTURES:
336     // ============
337 
338     using AttributeStore for AttributeStore.Data;
339     using DLL for DLL.Data;
340     using SafeMath for uint;
341 
342     struct Poll {
343         uint commitEndDate;     /// expiration date of commit period for poll
344         uint revealEndDate;     /// expiration date of reveal period for poll
345         uint voteQuorum;	    /// number of votes required for a proposal to pass
346         uint votesFor;		    /// tally of votes supporting proposal
347         uint votesAgainst;      /// tally of votes countering proposal
348         mapping(address => bool) didCommit;  /// indicates whether an address committed a vote for this poll
349         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
350     }
351 
352     // ============
353     // STATE VARIABLES:
354     // ============
355 
356     uint constant public INITIAL_POLL_NONCE = 0;
357     uint public pollNonce;
358 
359     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
360     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
361 
362     mapping(address => DLL.Data) dllMap;
363     AttributeStore.Data store;
364 
365     EIP20Interface public token;
366 
367     /**
368     @dev Initializer. Can only be called once.
369     @param _token The address where the ERC20 token contract is deployed
370     */
371     constructor(address _token) public {
372         require(_token != 0);
373 
374         token = EIP20Interface(_token);
375         pollNonce = INITIAL_POLL_NONCE;
376     }
377 
378     // ================
379     // TOKEN INTERFACE:
380     // ================
381 
382     /**
383     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
384     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
385     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
386     */
387     function requestVotingRights(uint _numTokens) public {
388         require(token.balanceOf(msg.sender) >= _numTokens);
389         voteTokenBalance[msg.sender] += _numTokens;
390         require(token.transferFrom(msg.sender, this, _numTokens));
391         emit _VotingRightsGranted(_numTokens, msg.sender);
392     }
393 
394     /**
395     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
396     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
397     */
398     function withdrawVotingRights(uint _numTokens) external {
399         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
400         require(availableTokens >= _numTokens);
401         voteTokenBalance[msg.sender] -= _numTokens;
402         require(token.transfer(msg.sender, _numTokens));
403         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
404     }
405 
406     /**
407     @dev Unlocks tokens locked in unrevealed vote where poll has ended
408     @param _pollID Integer identifier associated with the target poll
409     */
410     function rescueTokens(uint _pollID) public {
411         require(isExpired(pollMap[_pollID].revealEndDate));
412         require(dllMap[msg.sender].contains(_pollID));
413 
414         dllMap[msg.sender].remove(_pollID);
415         emit _TokensRescued(_pollID, msg.sender);
416     }
417 
418     /**
419     @dev Unlocks tokens locked in unrevealed votes where polls have ended
420     @param _pollIDs Array of integer identifiers associated with the target polls
421     */
422     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
423         // loop through arrays, rescuing tokens from all
424         for (uint i = 0; i < _pollIDs.length; i++) {
425             rescueTokens(_pollIDs[i]);
426         }
427     }
428 
429     // =================
430     // VOTING INTERFACE:
431     // =================
432 
433     /**
434     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
435     @param _pollID Integer identifier associated with target poll
436     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
437     @param _numTokens The number of tokens to be committed towards the target poll
438     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
439     */
440     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
441         require(commitPeriodActive(_pollID));
442 
443         // if msg.sender doesn't have enough voting rights,
444         // request for enough voting rights
445         if (voteTokenBalance[msg.sender] < _numTokens) {
446             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
447             requestVotingRights(remainder);
448         }
449 
450         // make sure msg.sender has enough voting rights
451         require(voteTokenBalance[msg.sender] >= _numTokens);
452         // prevent user from committing to zero node placeholder
453         require(_pollID != 0);
454         // prevent user from committing a secretHash of 0
455         require(_secretHash != 0);
456 
457         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
458         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
459 
460         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
461 
462         // edge case: in-place update
463         if (nextPollID == _pollID) {
464             nextPollID = dllMap[msg.sender].getNext(_pollID);
465         }
466 
467         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
468         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
469 
470         bytes32 UUID = attrUUID(msg.sender, _pollID);
471 
472         store.setAttribute(UUID, "numTokens", _numTokens);
473         store.setAttribute(UUID, "commitHash", uint(_secretHash));
474 
475         pollMap[_pollID].didCommit[msg.sender] = true;
476         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
477     }
478 
479     /**
480     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
481     @param _pollIDs         Array of integer identifiers associated with target polls
482     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
483     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
484     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
485     */
486     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
487         // make sure the array lengths are all the same
488         require(_pollIDs.length == _secretHashes.length);
489         require(_pollIDs.length == _numsTokens.length);
490         require(_pollIDs.length == _prevPollIDs.length);
491 
492         // loop through arrays, committing each individual vote values
493         for (uint i = 0; i < _pollIDs.length; i++) {
494             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
495         }
496     }
497 
498     /**
499     @dev Compares previous and next poll's committed tokens for sorting purposes
500     @param _prevID Integer identifier associated with previous poll in sorted order
501     @param _nextID Integer identifier associated with next poll in sorted order
502     @param _voter Address of user to check DLL position for
503     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
504     @return valid Boolean indication of if the specified position maintains the sort
505     */
506     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
507         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
508         // if next is zero node, _numTokens does not need to be greater
509         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
510         return prevValid && nextValid;
511     }
512 
513     /**
514     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
515     @param _pollID Integer identifier associated with target poll
516     @param _voteOption Vote choice used to generate commitHash for associated poll
517     @param _salt Secret number used to generate commitHash for associated poll
518     */
519     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
520         // Make sure the reveal period is active
521         require(revealPeriodActive(_pollID));
522         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
523         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
524         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
525 
526         uint numTokens = getNumTokens(msg.sender, _pollID);
527 
528         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
529             pollMap[_pollID].votesFor += numTokens;
530         } else {
531             pollMap[_pollID].votesAgainst += numTokens;
532         }
533 
534         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
535         pollMap[_pollID].didReveal[msg.sender] = true;
536 
537         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender);
538     }
539 
540     /**
541     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
542     @param _pollIDs     Array of integer identifiers associated with target polls
543     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
544     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
545     */
546     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
547         // make sure the array lengths are all the same
548         require(_pollIDs.length == _voteOptions.length);
549         require(_pollIDs.length == _salts.length);
550 
551         // loop through arrays, revealing each individual vote values
552         for (uint i = 0; i < _pollIDs.length; i++) {
553             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
554         }
555     }
556 
557     /**
558     @param _pollID Integer identifier associated with target poll
559     @param _salt Arbitrarily chosen integer used to generate secretHash
560     @return correctVotes Number of tokens voted for winning option
561     */
562     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
563         require(pollEnded(_pollID));
564         require(pollMap[_pollID].didReveal[_voter]);
565 
566         uint winningChoice = isPassed(_pollID) ? 1 : 0;
567         bytes32 winnerHash = keccak256(abi.encodePacked(winningChoice, _salt));
568         bytes32 commitHash = getCommitHash(_voter, _pollID);
569 
570         require(winnerHash == commitHash);
571 
572         return getNumTokens(_voter, _pollID);
573     }
574 
575     // ==================
576     // POLLING INTERFACE:
577     // ==================
578 
579     /**
580     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
581     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
582     @param _commitDuration Length of desired commit period in seconds
583     @param _revealDuration Length of desired reveal period in seconds
584     */
585     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
586         pollNonce = pollNonce + 1;
587 
588         uint commitEndDate = block.timestamp.add(_commitDuration);
589         uint revealEndDate = commitEndDate.add(_revealDuration);
590 
591         pollMap[pollNonce] = Poll({
592             voteQuorum: _voteQuorum,
593             commitEndDate: commitEndDate,
594             revealEndDate: revealEndDate,
595             votesFor: 0,
596             votesAgainst: 0
597         });
598 
599         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
600         return pollNonce;
601     }
602 
603     /**
604     @notice Determines if proposal has passed
605     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
606     @param _pollID Integer identifier associated with target poll
607     */
608     function isPassed(uint _pollID) constant public returns (bool passed) {
609         require(pollEnded(_pollID));
610 
611         Poll memory poll = pollMap[_pollID];
612         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
613     }
614 
615     // ----------------
616     // POLLING HELPERS:
617     // ----------------
618 
619     /**
620     @dev Gets the total winning votes for reward distribution purposes
621     @param _pollID Integer identifier associated with target poll
622     @return Total number of votes committed to the winning option for specified poll
623     */
624     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
625         require(pollEnded(_pollID));
626 
627         if (isPassed(_pollID))
628             return pollMap[_pollID].votesFor;
629         else
630             return pollMap[_pollID].votesAgainst;
631     }
632 
633     /**
634     @notice Determines if poll is over
635     @dev Checks isExpired for specified poll's revealEndDate
636     @return Boolean indication of whether polling period is over
637     */
638     function pollEnded(uint _pollID) constant public returns (bool ended) {
639         require(pollExists(_pollID));
640 
641         return isExpired(pollMap[_pollID].revealEndDate);
642     }
643 
644     /**
645     @notice Checks if the commit period is still active for the specified poll
646     @dev Checks isExpired for the specified poll's commitEndDate
647     @param _pollID Integer identifier associated with target poll
648     @return Boolean indication of isCommitPeriodActive for target poll
649     */
650     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
651         require(pollExists(_pollID));
652 
653         return !isExpired(pollMap[_pollID].commitEndDate);
654     }
655 
656     /**
657     @notice Checks if the reveal period is still active for the specified poll
658     @dev Checks isExpired for the specified poll's revealEndDate
659     @param _pollID Integer identifier associated with target poll
660     */
661     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
662         require(pollExists(_pollID));
663 
664         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
665     }
666 
667     /**
668     @dev Checks if user has committed for specified poll
669     @param _voter Address of user to check against
670     @param _pollID Integer identifier associated with target poll
671     @return Boolean indication of whether user has committed
672     */
673     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
674         require(pollExists(_pollID));
675 
676         return pollMap[_pollID].didCommit[_voter];
677     }
678 
679     /**
680     @dev Checks if user has revealed for specified poll
681     @param _voter Address of user to check against
682     @param _pollID Integer identifier associated with target poll
683     @return Boolean indication of whether user has revealed
684     */
685     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
686         require(pollExists(_pollID));
687 
688         return pollMap[_pollID].didReveal[_voter];
689     }
690 
691     /**
692     @dev Checks if a poll exists
693     @param _pollID The pollID whose existance is to be evaluated.
694     @return Boolean Indicates whether a poll exists for the provided pollID
695     */
696     function pollExists(uint _pollID) constant public returns (bool exists) {
697         return (_pollID != 0 && _pollID <= pollNonce);
698     }
699 
700     // ---------------------------
701     // DOUBLE-LINKED-LIST HELPERS:
702     // ---------------------------
703 
704     /**
705     @dev Gets the bytes32 commitHash property of target poll
706     @param _voter Address of user to check against
707     @param _pollID Integer identifier associated with target poll
708     @return Bytes32 hash property attached to target poll
709     */
710     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
711         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
712     }
713 
714     /**
715     @dev Wrapper for getAttribute with attrName="numTokens"
716     @param _voter Address of user to check against
717     @param _pollID Integer identifier associated with target poll
718     @return Number of tokens committed to poll in sorted poll-linked-list
719     */
720     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
721         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
722     }
723 
724     /**
725     @dev Gets top element of sorted poll-linked-list
726     @param _voter Address of user to check against
727     @return Integer identifier to poll with maximum number of tokens committed to it
728     */
729     function getLastNode(address _voter) constant public returns (uint pollID) {
730         return dllMap[_voter].getPrev(0);
731     }
732 
733     /**
734     @dev Gets the numTokens property of getLastNode
735     @param _voter Address of user to check against
736     @return Maximum number of tokens committed in poll specified
737     */
738     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
739         return getNumTokens(_voter, getLastNode(_voter));
740     }
741 
742     /*
743     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
744     for a node with a value less than or equal to the provided _numTokens value. When such a node
745     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
746     update. In that case, return the previous node of the node being updated. Otherwise return the
747     first node that was found with a value less than or equal to the provided _numTokens.
748     @param _voter The voter whose DLL will be searched
749     @param _numTokens The value for the numTokens attribute in the node to be inserted
750     @return the node which the propoded node should be inserted after
751     */
752     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
753     constant public returns (uint prevNode) {
754       // Get the last node in the list and the number of tokens in that node
755         uint nodeID = getLastNode(_voter);
756         uint tokensInNode = getNumTokens(_voter, nodeID);
757 
758       // Iterate backwards through the list until reaching the root node
759         while(nodeID != 0) {
760             // Get the number of tokens in the current node
761             tokensInNode = getNumTokens(_voter, nodeID);
762             if (tokensInNode <= _numTokens) { // We found the insert point!
763                 if (nodeID == _pollID) {
764                     // This is an in-place update. Return the prev node of the node being updated
765                     nodeID = dllMap[_voter].getPrev(nodeID);
766                 }
767             // Return the insert point
768                 return nodeID;
769             }
770             // We did not find the insert point. Continue iterating backwards through the list
771             nodeID = dllMap[_voter].getPrev(nodeID);
772         }
773 
774         // The list is empty, or a smaller value than anything else in the list is being inserted
775         return nodeID;
776     }
777 
778     // ----------------
779     // GENERAL HELPERS:
780     // ----------------
781 
782     /**
783     @dev Checks if an expiration date has been reached
784     @param _terminationDate Integer timestamp of date to compare current timestamp with
785     @return expired Boolean indication of whether the terminationDate has passed
786     */
787     function isExpired(uint _terminationDate) constant public returns (bool expired) {
788         return (block.timestamp > _terminationDate);
789     }
790 
791     /**
792     @dev Generates an identifier which associates a user and a poll together
793     @param _pollID Integer identifier associated with target poll
794     @return UUID Hash which is deterministic from _user and _pollID
795     */
796     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
797         return keccak256(abi.encodePacked(_user, _pollID));
798     }
799 }
800 
801 // File: contracts/Parameterizer.sol
802 
803 contract Parameterizer is Ownable, CanCheckERC165 {
804 
805   // ------
806   // EVENTS
807   // ------
808 
809   event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate);
810   event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate);
811   event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
812   event _ProposalExpired(bytes32 indexed propID);
813   event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
814   event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
815   event _RewardClaimed(uint indexed challengeID, uint reward);
816 
817 
818   // ------
819   // DATA STRUCTURES
820   // ------
821 
822   using SafeMath for uint;
823 
824   struct ParamProposal {
825     uint appExpiry;
826     uint challengeID;
827     uint deposit;
828     string name;
829     address owner;
830     uint processBy;
831     uint value;
832   }
833 
834   struct Challenge {
835     uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
836     address challenger;     // owner of Challenge
837     bool resolved;          // indication of if challenge is resolved
838     uint stake;             // number of tokens at risk for either party during challenge
839     uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
840     mapping(address => bool) tokenClaims;
841   }
842 
843   // ------
844   // STATE
845   // ------
846 
847   mapping(bytes32 => uint) public params;
848 
849   // maps challengeIDs to associated challenge data
850   mapping(uint => Challenge) public challenges;
851 
852   // maps pollIDs to intended data change if poll passes
853   mapping(bytes32 => ParamProposal) public proposals;
854 
855   // Global Variables
856   EIP20Interface public token;
857   PLCRVoting public voting;
858   uint public PROCESSBY = 604800; // 7 days
859 
860   string constant NEW_REGISTRY = "_newRegistry";
861   bytes32 constant NEW_REGISTRY_KEC = keccak256(abi.encodePacked(NEW_REGISTRY));
862   bytes32 constant DISPENSATION_PCT_KEC = keccak256(abi.encodePacked("dispensationPct"));
863   bytes32 constant P_DISPENSATION_PCT_KEC = keccak256(abi.encodePacked("pDispensationPct"));
864 
865   // todo: fill this in with the interface ID of the registry migration interface we will have
866   bytes4 public REGISTRY_INTERFACE_REQUIREMENT;
867 
868   // ------------
869   // CONSTRUCTOR
870   // ------------
871 
872   /**
873   @dev constructor
874   @param _tokenAddr        address of the token which parameterizes this system
875   @param _plcrAddr         address of a PLCR voting contract for the provided token
876   @param _minDeposit       minimum deposit for listing to be whitelisted
877   @param _pMinDeposit      minimum deposit to propose a reparameterization
878   @param _applyStageLen    period over which applicants wait to be whitelisted
879   @param _pApplyStageLen   period over which reparameterization proposals wait to be processed
880   @param _dispensationPct  percentage of losing party's deposit distributed to winning party
881   @param _pDispensationPct percentage of losing party's deposit distributed to winning party in parameterizer
882   @param _commitStageLen  length of commit period for voting
883   @param _pCommitStageLen length of commit period for voting in parameterizer
884   @param _revealStageLen  length of reveal period for voting
885   @param _pRevealStageLen length of reveal period for voting in parameterizer
886   @param _voteQuorum       type of majority out of 100 necessary for vote success
887   @param _pVoteQuorum      type of majority out of 100 necessary for vote success in parameterizer
888   @param _newRegistryIface ERC165 interface ID requirement (not a votable parameter)
889   */
890   constructor(
891     address _tokenAddr,
892     address _plcrAddr,
893     uint _minDeposit,
894     uint _pMinDeposit,
895     uint _applyStageLen,
896     uint _pApplyStageLen,
897     uint _commitStageLen,
898     uint _pCommitStageLen,
899     uint _revealStageLen,
900     uint _pRevealStageLen,
901     uint _dispensationPct,
902     uint _pDispensationPct,
903     uint _voteQuorum,
904     uint _pVoteQuorum,
905     bytes4 _newRegistryIface
906     ) Ownable() public {
907       token = EIP20Interface(_tokenAddr);
908       voting = PLCRVoting(_plcrAddr);
909       REGISTRY_INTERFACE_REQUIREMENT = _newRegistryIface;
910 
911       set("minDeposit", _minDeposit);
912       set("pMinDeposit", _pMinDeposit);
913       set("applyStageLen", _applyStageLen);
914       set("pApplyStageLen", _pApplyStageLen);
915       set("commitStageLen", _commitStageLen);
916       set("pCommitStageLen", _pCommitStageLen);
917       set("revealStageLen", _revealStageLen);
918       set("pRevealStageLen", _pRevealStageLen);
919       set("dispensationPct", _dispensationPct);
920       set("pDispensationPct", _pDispensationPct);
921       set("voteQuorum", _voteQuorum);
922       set("pVoteQuorum", _pVoteQuorum);
923   }
924 
925   // -----------------------
926   // TOKEN HOLDER INTERFACE
927   // -----------------------
928 
929   /**
930   @notice propose a reparamaterization of the key _name's value to _value.
931   @param _name the name of the proposed param to be set
932   @param _value the proposed value to set the param to be set
933   */
934   function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
935     uint deposit = get("pMinDeposit");
936     bytes32 propID = keccak256(abi.encodePacked(_name, _value));
937     bytes32 _nameKec = keccak256(abi.encodePacked(_name));
938 
939     if (_nameKec == DISPENSATION_PCT_KEC ||
940        _nameKec == P_DISPENSATION_PCT_KEC) {
941         require(_value <= 100);
942     }
943 
944     if(keccak256(abi.encodePacked(_name)) == NEW_REGISTRY_KEC) {
945       require(getNewRegistry() == address(0));
946       require(_value != 0);
947       require(msg.sender == owner);
948       require((_value & 0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff) == _value); // i.e., _value is zero-padded address
949       require(this.doesContractImplementInterface(address(_value), REGISTRY_INTERFACE_REQUIREMENT));
950     }
951 
952     require(!propExists(propID)); // Forbid duplicate proposals
953     require(get(_name) != _value); // Forbid NOOP reparameterizations
954 
955     // attach name and value to pollID
956     proposals[propID] = ParamProposal({
957       appExpiry: now.add(get("pApplyStageLen")),
958       challengeID: 0,
959       deposit: deposit,
960       name: _name,
961       owner: msg.sender,
962       processBy: now.add(get("pApplyStageLen"))
963         .add(get("pCommitStageLen"))
964         .add(get("pRevealStageLen"))
965         .add(PROCESSBY),
966       value: _value
967     });
968 
969     require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
970 
971     emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry);
972     return propID;
973   }
974 
975   /**
976   @notice gets the address of the new registry, if set.
977   */
978   function getNewRegistry() public view returns (address) {
979     //return address(get(NEW_REGISTRY));
980     return address(params[NEW_REGISTRY_KEC]); // bit of an optimization
981   }
982 
983   /**
984   @notice challenge the provided proposal ID, and put tokens at stake to do so.
985   @param _propID the proposal ID to challenge
986   */
987   function challengeReparameterization(bytes32 _propID) public returns (uint) {
988     ParamProposal memory prop = proposals[_propID];
989     uint deposit = prop.deposit;
990 
991     require(propExists(_propID) && prop.challengeID == 0);
992 
993     //start poll
994     uint pollID = voting.startPoll(
995       get("pVoteQuorum"),
996       get("pCommitStageLen"),
997       get("pRevealStageLen")
998     );
999 
1000     challenges[pollID] = Challenge({
1001       challenger: msg.sender,
1002       rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
1003       stake: deposit,
1004       resolved: false,
1005       winningTokens: 0
1006     });
1007 
1008     proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
1009 
1010     //take tokens from challenger
1011     require(token.transferFrom(msg.sender, this, deposit));
1012 
1013     (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
1014 
1015     emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate);
1016     return pollID;
1017   }
1018 
1019   /**
1020   @notice for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
1021   @param _propID the proposal ID to make a determination and state transition for
1022   */
1023   function processProposal(bytes32 _propID) public {
1024     ParamProposal storage prop = proposals[_propID];
1025     address propOwner = prop.owner;
1026     uint propDeposit = prop.deposit;
1027 
1028 
1029     // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
1030     // prop.owner and prop.deposit will be 0, thereby preventing theft
1031    if (canBeSet(_propID)) {
1032       // There is no challenge against the proposal. The processBy date for the proposal has not
1033      // passed, but the proposal's appExpirty date has passed.
1034       set(prop.name, prop.value);
1035       emit _ProposalAccepted(_propID, prop.name, prop.value);
1036       delete proposals[_propID];
1037       require(token.transfer(propOwner, propDeposit));
1038     } else if (challengeCanBeResolved(_propID)) {
1039       // There is a challenge against the proposal.
1040       resolveChallenge(_propID);
1041     } else if (now > prop.processBy) {
1042       // There is no challenge against the proposal, but the processBy date has passed.
1043       emit _ProposalExpired(_propID);
1044       delete proposals[_propID];
1045       require(token.transfer(propOwner, propDeposit));
1046     } else {
1047       // There is no challenge against the proposal, and neither the appExpiry date nor the
1048       // processBy date has passed.
1049       revert();
1050     }
1051 
1052     assert(get("dispensationPct") <= 100);
1053     assert(get("pDispensationPct") <= 100);
1054 
1055     // verify that future proposal appExpiry and processBy times will not overflow
1056     now.add(get("pApplyStageLen"))
1057       .add(get("pCommitStageLen"))
1058       .add(get("pRevealStageLen"))
1059       .add(PROCESSBY);
1060 
1061     delete proposals[_propID];
1062   }
1063 
1064   /**
1065   @notice claim the tokens owed for the msg.sender in the provided challenge
1066   @param _challengeID the challenge ID to claim tokens for
1067   @param _salt the salt used to vote in the challenge being withdrawn for
1068   */
1069   function claimReward(uint _challengeID, uint _salt) public {
1070     // ensure voter has not already claimed tokens and challenge results have been processed
1071     require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1072     require(challenges[_challengeID].resolved == true);
1073 
1074     uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1075     uint reward = voterReward(msg.sender, _challengeID, _salt);
1076 
1077     // subtract voter's information to preserve the participation ratios of other voters
1078     // compared to the remaining pool of rewards
1079     challenges[_challengeID].winningTokens = challenges[_challengeID].winningTokens.sub(voterTokens);
1080     challenges[_challengeID].rewardPool = challenges[_challengeID].rewardPool.sub(reward);
1081 
1082     // ensures a voter cannot claim tokens again
1083     challenges[_challengeID].tokenClaims[msg.sender] = true;
1084 
1085     emit _RewardClaimed(_challengeID, reward);
1086     require(token.transfer(msg.sender, reward));
1087   }
1088 
1089   // --------
1090   // GETTERS
1091   // --------
1092 
1093   /**
1094   @dev                Calculates the provided voter's token reward for the given poll.
1095   @param _voter       The address of the voter whose reward balance is to be returned
1096   @param _challengeID The ID of the challenge the voter's reward is being calculated for
1097   @param _salt        The salt of the voter's commit hash in the given poll
1098   @return             The uint indicating the voter's reward
1099   */
1100   function voterReward(address _voter, uint _challengeID, uint _salt)
1101   public view returns (uint) {
1102     uint winningTokens = challenges[_challengeID].winningTokens;
1103     uint rewardPool = challenges[_challengeID].rewardPool;
1104     uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1105     return voterTokens.mul(rewardPool).div(winningTokens);
1106   }
1107 
1108   /**
1109   @notice Determines whether a proposal passed its application stage without a challenge
1110   @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
1111   */
1112   function canBeSet(bytes32 _propID) view public returns (bool) {
1113     ParamProposal memory prop = proposals[_propID];
1114 
1115     return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1116   }
1117 
1118   /**
1119   @notice Determines whether a proposal exists for the provided proposal ID
1120   @param _propID The proposal ID whose existance is to be determined
1121   */
1122   function propExists(bytes32 _propID) view public returns (bool) {
1123     return proposals[_propID].processBy > 0;
1124   }
1125 
1126   /**
1127   @notice Determines whether the provided proposal ID has a challenge which can be resolved
1128   @param _propID The proposal ID whose challenge to inspect
1129   */
1130   function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1131     ParamProposal memory prop = proposals[_propID];
1132     Challenge memory challenge = challenges[prop.challengeID];
1133 
1134     return (prop.challengeID > 0 && challenge.resolved == false &&
1135             voting.pollEnded(prop.challengeID));
1136   }
1137 
1138   /**
1139   @notice Determines the number of tokens to awarded to the winning party in a challenge
1140   @param _challengeID The challengeID to determine a reward for
1141   */
1142   function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1143     if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1144       // Edge case, nobody voted, give all tokens to the challenger.
1145       return challenges[_challengeID].stake.mul(2);
1146     }
1147 
1148     return challenges[_challengeID].stake.mul(2).sub(challenges[_challengeID].rewardPool);
1149   }
1150 
1151   /**
1152   @notice gets the parameter keyed by the provided name value from the params mapping
1153   @param _name the key whose value is to be determined
1154   */
1155   function get(string _name) public view returns (uint value) {
1156     return params[keccak256(abi.encodePacked(_name))];
1157   }
1158 
1159   /**
1160   @dev                Getter for Challenge tokenClaims mappings
1161   @param _challengeID The challengeID to query
1162   @param _voter       The voter whose claim status to query for the provided challengeID
1163   */
1164   function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1165     return challenges[_challengeID].tokenClaims[_voter];
1166   }
1167 
1168   // ----------------
1169   // PRIVATE FUNCTIONS
1170   // ----------------
1171 
1172   /**
1173   @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1174   @param _propID the proposal ID whose challenge is to be resolved.
1175   */
1176   function resolveChallenge(bytes32 _propID) private {
1177     ParamProposal memory prop = proposals[_propID];
1178     Challenge storage challenge = challenges[prop.challengeID];
1179 
1180     // winner gets back their full staked deposit, and dispensationPct*loser's stake
1181     uint reward = challengeWinnerReward(prop.challengeID);
1182 
1183     challenge.winningTokens =
1184       voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1185     challenge.resolved = true;
1186 
1187     if (voting.isPassed(prop.challengeID)) { // The challenge failed
1188       if(prop.processBy > now) {
1189         set(prop.name, prop.value);
1190       }
1191       emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1192       require(token.transfer(prop.owner, reward));
1193     }
1194     else { // The challenge succeeded or nobody voted
1195       emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1196       require(token.transfer(challenges[prop.challengeID].challenger, reward));
1197     }
1198   }
1199 
1200   /**
1201   @dev sets the param keted by the provided name to the provided value
1202   @param _name the name of the param to be set
1203   @param _value the value to set the param to be set
1204   */
1205   function set(string _name, uint _value) private {
1206     params[keccak256(abi.encodePacked(_name))] = _value;
1207   }
1208 }
1209 
1210 // File: contracts/Interface/ERC165.sol
1211 
1212 /**
1213  * @title ERC165
1214  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
1215  */
1216 interface ERC165 {
1217 
1218   /**
1219    * @notice Query if a contract implements an interface
1220    * @param _interfaceId The interface identifier, as specified in ERC-165
1221    * @dev Interface identification is specified in ERC-165. This function
1222    * uses less than 30,000 gas.
1223    */
1224   function supportsInterface(bytes4 _interfaceId)
1225     external
1226     view
1227     returns (bool);
1228 }
1229 
1230 // File: contracts/HumanRegistry.sol
1231 
1232 contract SupercedesRegistry is ERC165 {
1233     function canReceiveListing(bytes32 listingHash, uint applicationExpiry, bool whitelisted, address owner, uint unstakedDeposit, uint challengeID) external view returns (bool);
1234     function receiveListing(bytes32 listingHash, uint applicationExpiry, bool whitelisted, address owner, uint unstakedDeposit, uint challengeID) external;
1235     function getSupercedesRegistryInterfaceID() public pure returns (bytes4) {
1236         SupercedesRegistry i;
1237         return i.canReceiveListing.selector ^ i.receiveListing.selector;
1238     }
1239 }
1240 
1241 contract HumanRegistry {
1242 
1243     // ------
1244     // EVENTS
1245     // ------
1246 
1247     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data);
1248     event _Challenge(bytes32 indexed listingHash, uint challengeID, uint deposit, string data);
1249     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal);
1250     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal);
1251     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1252     event _ApplicationRemoved(bytes32 indexed listingHash);
1253     event _ListingRemoved(bytes32 indexed listingHash);
1254     event _ListingWithdrawn(bytes32 indexed listingHash);
1255     event _TouchAndRemoved(bytes32 indexed listingHash);
1256     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1257     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1258     event _RewardClaimed(uint indexed challengeID, uint reward, address voter);
1259     event _ListingMigrated(bytes32 indexed listingHash, address newRegistry);
1260 
1261     using SafeMath for uint;
1262 
1263     struct Listing {
1264         uint applicationExpiry; // Expiration date of apply stage
1265         bool whitelisted;       // Indicates registry status
1266         address owner;          // Owner of Listing
1267         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1268         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1269     }
1270 
1271     struct Challenge {
1272         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1273         address challenger;     // Owner of Challenge
1274         bool resolved;          // Indication of if challenge is resolved
1275         uint stake;             // Number of tokens at stake for either party during challenge
1276         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1277         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1278     }
1279 
1280     // Maps owners to whitelisted status
1281     mapping (address => bool) public humans;
1282 
1283     // Maps challengeIDs to associated challenge data
1284     mapping(uint => Challenge) public challenges;
1285 
1286     // Maps listingHashes to associated listingHash data
1287     mapping(bytes32 => Listing) public listings;
1288 
1289     // Maps number of applications per address
1290     mapping(address => uint) public numApplications;
1291 
1292     // Maps total amount staked per address
1293     mapping(address => uint) public totalStaked;
1294 
1295     // Global Variables
1296     EIP20Interface public token;
1297     PLCRVoting public voting;
1298     Parameterizer public parameterizer;
1299     string public constant version = "1";
1300 
1301     // ------------
1302     // CONSTRUCTOR:
1303     // ------------
1304 
1305     /**
1306     @dev Contructor         Sets the addresses for token, voting, and parameterizer
1307     @param _tokenAddr       Address of the TCR's intrinsic ERC20 token
1308     @param _plcrAddr        Address of a PLCR voting contract for the provided token
1309     @param _paramsAddr      Address of a Parameterizer contract
1310     */
1311     constructor(
1312         address _tokenAddr,
1313         address _plcrAddr,
1314         address _paramsAddr
1315     ) public {
1316         token = EIP20Interface(_tokenAddr);
1317         voting = PLCRVoting(_plcrAddr);
1318         parameterizer = Parameterizer(_paramsAddr);
1319     }
1320 
1321     // --------------------
1322     // PUBLISHER INTERFACE:
1323     // --------------------
1324 
1325     /**
1326     @dev                Allows a user to start an application. Takes tokens from user and sets
1327                         apply stage end time.
1328     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1329     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1330     @param _data        Extra data relevant to the application. Think IPFS hashes.
1331     */
1332     function apply(bytes32 _listingHash, uint _amount, string _data) onlyIfCurrentRegistry external {
1333         require(!isWhitelisted(_listingHash));
1334         require(!appWasMade(_listingHash));
1335         require(_amount >= parameterizer.get("minDeposit"));
1336 
1337         // Sets owner
1338         Listing storage listing = listings[_listingHash];
1339         listing.owner = msg.sender;
1340 
1341         // Sets apply stage end time
1342         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1343         listing.unstakedDeposit = _amount;
1344 
1345         // Tally application count per address
1346         numApplications[listing.owner] = numApplications[listing.owner].add(1);
1347 
1348         // Tally total staked amount
1349         totalStaked[listing.owner] = totalStaked[listing.owner].add(_amount);
1350 
1351         // Transfers tokens from user to Registry contract
1352         require(token.transferFrom(listing.owner, this, _amount));
1353         emit _Application(_listingHash, _amount, listing.applicationExpiry, _data);
1354     }
1355 
1356     /**
1357     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1358     @param _listingHash A listingHash msg.sender is the owner of
1359     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1360     */
1361     function deposit(bytes32 _listingHash, uint _amount) external {
1362         Listing storage listing = listings[_listingHash];
1363 
1364         require(listing.owner == msg.sender);
1365 
1366         listing.unstakedDeposit = listing.unstakedDeposit.add(_amount);
1367 
1368         // Update total stake
1369         totalStaked[listing.owner] = totalStaked[listing.owner].add(_amount);
1370 
1371         require(token.transferFrom(msg.sender, this, _amount));
1372 
1373         emit _Deposit(_listingHash, _amount, listing.unstakedDeposit);
1374     }
1375 
1376     /**
1377     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1378     @param _listingHash A listingHash msg.sender is the owner of.
1379     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1380     */
1381     function withdraw(bytes32 _listingHash, uint _amount) external {
1382         Listing storage listing = listings[_listingHash];
1383 
1384         require(listing.owner == msg.sender);
1385         require(_amount <= listing.unstakedDeposit);
1386         require(listing.unstakedDeposit.sub(_amount) >= parameterizer.get("minDeposit"));
1387 
1388         listing.unstakedDeposit = listing.unstakedDeposit.sub(_amount);
1389 
1390         require(token.transfer(msg.sender, _amount));
1391 
1392         emit _Withdrawal(_listingHash, _amount, listing.unstakedDeposit);
1393     }
1394 
1395     /**
1396     @dev                Allows the owner of a listingHash to remove the listingHash from the whitelist
1397                         Returns all tokens to the owner of the listingHash
1398     @param _listingHash A listingHash msg.sender is the owner of.
1399     */
1400     function exit(bytes32 _listingHash) external {
1401         Listing storage listing = listings[_listingHash];
1402 
1403         require(msg.sender == listing.owner);
1404         require(isWhitelisted(_listingHash));
1405 
1406         // Cannot exit during ongoing challenge
1407         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1408 
1409         // Remove listingHash & return tokens
1410         resetListing(_listingHash);
1411         emit _ListingWithdrawn(_listingHash);
1412     }
1413 
1414     // -----------------------
1415     // TOKEN HOLDER INTERFACE:
1416     // -----------------------
1417 
1418     /**
1419     @dev                Starts a poll for a listingHash which is either in the apply stage or
1420                         already in the whitelist. Tokens are taken from the challenger and the
1421                         applicant's deposits are locked.
1422     @param _listingHash The listingHash being challenged, whether listed or in application
1423     @param _deposit     The deposit with which the listing is challenge (used to be `minDeposit`)
1424     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1425     */
1426     function challenge(bytes32 _listingHash, uint _deposit, string _data) onlyIfCurrentRegistry external returns (uint challengeID) {
1427         Listing storage listing = listings[_listingHash];
1428         uint minDeposit = parameterizer.get("minDeposit");
1429 
1430         // Listing must be in apply stage or already on the whitelist
1431         require(appWasMade(_listingHash) || listing.whitelisted);
1432         // Prevent multiple challenges
1433         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1434 
1435         if (listing.unstakedDeposit < minDeposit) {
1436             // Not enough tokens, listingHash auto-delisted
1437             resetListing(_listingHash);
1438             emit _TouchAndRemoved(_listingHash);
1439             return 0;
1440         }
1441 
1442         // Starts poll
1443         uint pollID = voting.startPoll(
1444             parameterizer.get("voteQuorum"),
1445             parameterizer.get("commitStageLen"),
1446             parameterizer.get("revealStageLen")
1447         );
1448 
1449         challenges[pollID] = Challenge({
1450             challenger: msg.sender,
1451             rewardPool: ((100 - parameterizer.get("dispensationPct")) * _deposit) / 100,
1452             stake: _deposit,
1453             resolved: false,
1454             totalTokens: 0
1455         });
1456 
1457         // Updates listingHash to store most recent challenge
1458         listing.challengeID = pollID;
1459 
1460         // make sure _deposit is more than minDeposit and smaller than unstaked deposit
1461         require(_deposit >= minDeposit && _deposit <= listing.unstakedDeposit);
1462 
1463         // Locks tokens for listingHash during challenge
1464         listing.unstakedDeposit = listing.unstakedDeposit.sub(_deposit);
1465 
1466         // Takes tokens from challenger
1467         require(token.transferFrom(msg.sender, this, _deposit));
1468 
1469         emit _Challenge(_listingHash, pollID, _deposit, _data);
1470         return pollID;
1471     }
1472 
1473     /**
1474     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1475                         a challenge if one exists.
1476     @param _listingHash The listingHash whose status is being updated
1477     */
1478     function updateStatus(bytes32 _listingHash) public {
1479         if (canBeWhitelisted(_listingHash)) {
1480           whitelistApplication(_listingHash);
1481         } else if (challengeCanBeResolved(_listingHash)) {
1482           resolveChallenge(_listingHash);
1483         } else {
1484           revert();
1485         }
1486     }
1487 
1488     // ----------------
1489     // TOKEN FUNCTIONS:
1490     // ----------------
1491 
1492     /**
1493     @dev                Called by a voter to claim their reward for each completed vote. Someone
1494                         must call updateStatus() before this can be called.
1495     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1496     @param _salt        The salt of a voter's commit hash in the given poll
1497     */
1498     function claimReward(uint _challengeID, uint _salt) public {
1499         // Ensures the voter has not already claimed tokens and challenge results have been processed
1500         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1501         require(challenges[_challengeID].resolved == true);
1502 
1503         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1504         uint reward = voterReward(msg.sender, _challengeID, _salt);
1505 
1506         // Subtracts the voter's information to preserve the participation ratios
1507         // of other voters compared to the remaining pool of rewards
1508         challenges[_challengeID].totalTokens = challenges[_challengeID].totalTokens.sub(voterTokens);
1509         challenges[_challengeID].rewardPool = challenges[_challengeID].rewardPool.sub(reward);
1510 
1511         // Ensures a voter cannot claim tokens again
1512         challenges[_challengeID].tokenClaims[msg.sender] = true;
1513 
1514         require(token.transfer(msg.sender, reward));
1515 
1516         emit _RewardClaimed(_challengeID, reward, msg.sender);
1517     }
1518 
1519     // --------
1520     // GETTERS:
1521     // --------
1522 
1523     /**
1524     @dev                Calculates the provided voter's token reward for the given poll.
1525     @param _voter       The address of the voter whose reward balance is to be returned
1526     @param _challengeID The pollID of the challenge a reward balance is being queried for
1527     @param _salt        The salt of the voter's commit hash in the given poll
1528     @return             The uint indicating the voter's reward
1529     */
1530     function voterReward(address _voter, uint _challengeID, uint _salt)
1531     public view returns (uint) {
1532         uint totalTokens = challenges[_challengeID].totalTokens;
1533         uint rewardPool = challenges[_challengeID].rewardPool;
1534         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1535         return (voterTokens * rewardPool) / totalTokens;
1536     }
1537 
1538     /**
1539     @dev                Determines whether the given listingHash can be whitelisted.
1540     @param _listingHash The listingHash whose status is to be examined
1541     */
1542     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1543         uint challengeID = listings[_listingHash].challengeID;
1544 
1545         // Ensures that the application was made,
1546         // the application period has ended,
1547         // the listingHash can be whitelisted,
1548         // and either: the challengeID == 0, or the challenge has been resolved.
1549         if (
1550             appWasMade(_listingHash) &&
1551             listings[_listingHash].applicationExpiry < now &&
1552             !isWhitelisted(_listingHash) &&
1553             (challengeID == 0 || challenges[challengeID].resolved == true)
1554         ) {
1555           return true;
1556         }
1557 
1558         return false;
1559     }
1560 
1561     /**
1562     @dev                Returns true if the provided address is whitelisted
1563     @param _who The address whose status is to be examined
1564     */
1565     function isHuman(address _who) view public returns (bool human) {
1566         return humans[_who];
1567     }
1568 
1569     /**
1570     @dev                Returns true if the provided listingHash is whitelisted
1571     @param _listingHash The listingHash whose status is to be examined
1572     */
1573     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1574         return listings[_listingHash].whitelisted;
1575     }
1576 
1577     /**
1578     @dev                Returns true if apply was called for this listingHash
1579     @param _listingHash The listingHash whose status is to be examined
1580     */
1581     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1582         return listings[_listingHash].applicationExpiry > 0;
1583     }
1584 
1585     /**
1586     @dev                Returns true if the application/listingHash has an unresolved challenge
1587     @param _listingHash The listingHash whose status is to be examined
1588     */
1589     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1590         uint challengeID = listings[_listingHash].challengeID;
1591 
1592         return (challengeID > 0 && !challenges[challengeID].resolved);
1593     }
1594 
1595     /**
1596     @dev                Determines whether voting has concluded in a challenge for a given
1597                         listingHash. Throws if no challenge exists.
1598     @param _listingHash A listingHash with an unresolved challenge
1599     */
1600     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1601         uint challengeID = listings[_listingHash].challengeID;
1602 
1603         require(challengeExists(_listingHash));
1604 
1605         return voting.pollEnded(challengeID);
1606     }
1607 
1608     /**
1609     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1610     @param _challengeID The challengeID to determine a reward for
1611     */
1612     function determineReward(uint _challengeID) public view returns (uint) {
1613         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1614 
1615         // Edge case, nobody voted, give all tokens to the challenger.
1616         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1617             return challenges[_challengeID].stake.mul(2);
1618         }
1619 
1620         return (challenges[_challengeID].stake).mul(2).sub(challenges[_challengeID].rewardPool);
1621     }
1622 
1623     /**
1624     @dev                Getter for Challenge tokenClaims mappings
1625     @param _challengeID The challengeID to query
1626     @param _voter       The voter whose claim status to query for the provided challengeID
1627     */
1628     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1629       return challenges[_challengeID].tokenClaims[_voter];
1630     }
1631 
1632     // ----------------
1633     // PRIVATE FUNCTIONS:
1634     // ----------------
1635 
1636     /**
1637     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1638                         either whitelists or de-whitelists the listingHash.
1639     @param _listingHash A listingHash with a challenge that is to be resolved
1640     */
1641     function resolveChallenge(bytes32 _listingHash) private {
1642         uint challengeID = listings[_listingHash].challengeID;
1643 
1644         // Calculates the winner's reward,
1645         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1646         uint reward = determineReward(challengeID);
1647 
1648         // Sets flag on challenge being processed
1649         challenges[challengeID].resolved = true;
1650 
1651         // Stores the total tokens used for voting by the winning side for reward purposes
1652         challenges[challengeID].totalTokens =
1653             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1654 
1655         // Case: challenge failed
1656         if (voting.isPassed(challengeID)) {
1657             whitelistApplication(_listingHash);
1658             // Unlock stake so that it can be retrieved by the applicant
1659             listings[_listingHash].unstakedDeposit = listings[_listingHash].unstakedDeposit.add(reward);
1660 
1661             totalStaked[listings[_listingHash].owner] = totalStaked[listings[_listingHash].owner].add(reward);
1662 
1663             emit _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1664         }
1665         // Case: challenge succeeded or nobody voted
1666         else {
1667             resetListing(_listingHash);
1668             // Transfer the reward to the challenger
1669             require(token.transfer(challenges[challengeID].challenger, reward));
1670 
1671             emit _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1672         }
1673     }
1674 
1675     /**
1676     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1677                         challenge being made. Called by resolveChallenge() if an
1678                         application/listing beat a challenge.
1679     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1680     */
1681     function whitelistApplication(bytes32 _listingHash) private {
1682         Listing storage listing = listings[_listingHash];
1683 
1684         if (!listing.whitelisted) {
1685             emit _ApplicationWhitelisted(_listingHash);
1686         }
1687         listing.whitelisted = true;
1688 
1689         // Add the owner to the human whitelist
1690         humans[listing.owner] = true;
1691     }
1692 
1693     /**
1694     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1695     @param _listingHash The listing hash to delete
1696     */
1697     function resetListing(bytes32 _listingHash) private {
1698         Listing storage listing = listings[_listingHash];
1699 
1700         // Emit events before deleting listing to check whether is whitelisted
1701         if (listing.whitelisted) {
1702             emit _ListingRemoved(_listingHash);
1703         } else {
1704             emit _ApplicationRemoved(_listingHash);
1705         }
1706 
1707         // Deleting listing to prevent reentry
1708         address owner = listing.owner;
1709         uint unstakedDeposit = listing.unstakedDeposit;
1710         delete listings[_listingHash];
1711 
1712         // Remove owner from human whitelist
1713         delete humans[owner];
1714 
1715         // Transfers any remaining balance back to the owner
1716         if (unstakedDeposit > 0){
1717             require(token.transfer(owner, unstakedDeposit));
1718         }
1719     }
1720 
1721     /**
1722     @dev Modifier to specify that a function can only be called if this is the current registry.
1723     */
1724     modifier onlyIfCurrentRegistry() {
1725         require(parameterizer.getNewRegistry() == address(0));
1726         _;
1727     }
1728 
1729     /**
1730     @dev Modifier to specify that a function cannot be called if this is the current registry.
1731     */
1732     modifier onlyIfOutdatedRegistry() {
1733         require(parameterizer.getNewRegistry() != address(0));
1734         _;
1735     }
1736 
1737     /**
1738      @dev Check if a listing exists in the registry by checking that its owner is not zero
1739           Since all solidity mappings have every key set to zero, we check that the address of the creator isn't zero.
1740     */
1741     function listingExists(bytes32 listingHash) public view returns (bool) {
1742         return listings[listingHash].owner != address(0);
1743     }
1744 
1745     /**
1746     @dev migrates a listing
1747     */
1748     function migrateListing(bytes32 listingHash) onlyIfOutdatedRegistry public {
1749       require(listingExists(listingHash)); // duh
1750       require(!challengeExists(listingHash)); // can't migrate a listing that's challenged
1751 
1752       address newRegistryAddress = parameterizer.getNewRegistry();
1753       SupercedesRegistry newRegistry = SupercedesRegistry(newRegistryAddress);
1754       Listing storage listing = listings[listingHash];
1755 
1756       require(newRegistry.canReceiveListing(
1757         listingHash, listing.applicationExpiry,
1758         listing.whitelisted, listing.owner,
1759         listing.unstakedDeposit, listing.challengeID
1760       ));
1761 
1762       token.approve(newRegistry, listing.unstakedDeposit);
1763       newRegistry.receiveListing(
1764         listingHash, listing.applicationExpiry,
1765         listing.whitelisted, listing.owner,
1766         listing.unstakedDeposit, listing.challengeID
1767       );
1768       delete listings[listingHash];
1769       emit _ListingMigrated(listingHash, newRegistryAddress);
1770     }
1771 }