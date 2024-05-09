1 pragma solidity ^0.4.24;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     // solhint-disable-next-line no-simple-event-func-name
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*
51 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
52 .*/
53 
54 
55 contract EIP20 is EIP20Interface {
56 
57     uint256 constant private MAX_UINT256 = 2**256 - 1;
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60     /*
61     NOTE:
62     The following variables are OPTIONAL vanities. One does not have to include them.
63     They allow one to customise the token contract & in no way influences the core functionality.
64     Some wallets/interfaces might not even bother to look at this information.
65     */
66     string public name;                   //fancy name: eg Simon Bucks
67     uint8 public decimals;                //How many decimals to show.
68     string public symbol;                 //An identifier: eg SBX
69 
70     function EIP20(
71         uint256 _initialAmount,
72         string _tokenName,
73         uint8 _decimalUnits,
74         string _tokenSymbol
75     ) public {
76         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
77         totalSupply = _initialAmount;                        // Update total supply
78         name = _tokenName;                                   // Set the name for display purposes
79         decimals = _decimalUnits;                            // Amount of decimals for display purposes
80         symbol = _tokenSymbol;                               // Set the symbol for display purposes
81     }
82 
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         require(balances[msg.sender] >= _value);
85         balances[msg.sender] -= _value;
86         balances[_to] += _value;
87         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         uint256 allowance = allowed[_from][msg.sender];
93         require(balances[_from] >= _value && allowance >= _value);
94         balances[_to] += _value;
95         balances[_from] -= _value;
96         if (allowance < MAX_UINT256) {
97             allowed[_from][msg.sender] -= _value;
98         }
99         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
100         return true;
101     }
102 
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 }
117 
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that throw on error
122  */
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, throws on overflow.
127   */
128   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
129     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
130     // benefit is lost if 'b' is also tested.
131     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
132     if (a == 0) {
133       return 0;
134     }
135 
136     c = a * b;
137     assert(c / a == b);
138     return c;
139   }
140 
141   /**
142   * @dev Integer division of two numbers, truncating the quotient.
143   */
144   function div(uint256 a, uint256 b) internal pure returns (uint256) {
145     // assert(b > 0); // Solidity automatically throws when dividing by 0
146     // uint256 c = a / b;
147     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148     return a / b;
149   }
150 
151   /**
152   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
153   */
154   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155     assert(b <= a);
156     return a - b;
157   }
158 
159   /**
160   * @dev Adds two numbers, throws on overflow.
161   */
162   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
163     c = a + b;
164     assert(c >= a);
165     return c;
166   }
167 }
168 
169 /**
170  * @title Ownable
171  * @dev The Ownable contract has an owner address, and provides basic authorization control
172  * functions, this simplifies the implementation of "user permissions".
173  */
174 contract Ownable {
175   address public owner;
176 
177 
178   event OwnershipRenounced(address indexed previousOwner);
179   event OwnershipTransferred(
180     address indexed previousOwner,
181     address indexed newOwner
182   );
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   constructor() public {
190     owner = msg.sender;
191   }
192 
193   /**
194    * @dev Throws if called by any account other than the owner.
195    */
196   modifier onlyOwner() {
197     require(msg.sender == owner);
198     _;
199   }
200 
201   /**
202    * @dev Allows the current owner to relinquish control of the contract.
203    */
204   function renounceOwnership() public onlyOwner {
205     emit OwnershipRenounced(owner);
206     owner = address(0);
207   }
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param _newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address _newOwner) public onlyOwner {
214     _transferOwnership(_newOwner);
215   }
216 
217   /**
218    * @dev Transfers control of the contract to a newOwner.
219    * @param _newOwner The address to transfer ownership to.
220    */
221   function _transferOwnership(address _newOwner) internal {
222     require(_newOwner != address(0));
223     emit OwnershipTransferred(owner, _newOwner);
224     owner = _newOwner;
225   }
226 }
227 
228 
229 
230 /**
231  * @title ERC165
232  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
233  */
234 interface ERC165 {
235 
236   /**
237    * @notice Query if a contract implements an interface
238    * @param _interfaceId The interface identifier, as specified in ERC-165
239    * @dev Interface identification is specified in ERC-165. This function
240    * uses less than 30,000 gas.
241    */
242   function supportsInterface(bytes4 _interfaceId)
243     external
244     view
245     returns (bool);
246 }
247 
248 contract CanCheckERC165 {
249   bytes4 constant InvalidID = 0xffffffff;
250   bytes4 constant ERC165ID = 0x01ffc9a7;
251   function doesContractImplementInterface(address _contract, bytes4 _interfaceId) external view returns (bool) {
252       uint256 success;
253       uint256 result;
254 
255       (success, result) = noThrowCall(_contract, ERC165ID);
256       if ((success==0)||(result==0)) {
257           return false;
258       }
259 
260       (success, result) = noThrowCall(_contract, InvalidID);
261       if ((success==0)||(result!=0)) {
262           return false;
263       }
264 
265       (success, result) = noThrowCall(_contract, _interfaceId);
266       if ((success==1)&&(result==1)) {
267           return true;
268       }
269       return false;
270   }
271 
272   function noThrowCall(address _contract, bytes4 _interfaceId) internal view returns (uint256 success, uint256 result) {
273     bytes4 erc165ID = ERC165ID;
274 
275     assembly {
276             let x := mload(0x40)               // Find empty storage location using "free memory pointer"
277             mstore(x, erc165ID)                // Place signature at begining of empty storage
278             mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
279 
280             success := staticcall(
281                                 30000,         // 30k gas
282                                 _contract,     // To addr
283                                 x,             // Inputs are stored at location x
284                                 0x20,          // Inputs are 32 bytes long
285                                 x,             // Store output over input (saves space)
286                                 0x20)          // Outputs are 32 bytes long
287 
288             result := mload(x)                 // Load the result
289     }
290   }
291 }
292 
293 
294 library DLL {
295 
296   uint constant NULL_NODE_ID = 0;
297 
298   struct Node {
299     uint next;
300     uint prev;
301   }
302 
303   struct Data {
304     mapping(uint => Node) dll;
305   }
306 
307   function isEmpty(Data storage self) public view returns (bool) {
308     return getStart(self) == NULL_NODE_ID;
309   }
310 
311   function contains(Data storage self, uint _curr) public view returns (bool) {
312     if (isEmpty(self) || _curr == NULL_NODE_ID) {
313       return false;
314     } 
315 
316     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
317     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
318     return isSingleNode || !isNullNode;
319   }
320 
321   function getNext(Data storage self, uint _curr) public view returns (uint) {
322     return self.dll[_curr].next;
323   }
324 
325   function getPrev(Data storage self, uint _curr) public view returns (uint) {
326     return self.dll[_curr].prev;
327   }
328 
329   function getStart(Data storage self) public view returns (uint) {
330     return getNext(self, NULL_NODE_ID);
331   }
332 
333   function getEnd(Data storage self) public view returns (uint) {
334     return getPrev(self, NULL_NODE_ID);
335   }
336 
337   /**
338   @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
339   the list it will be automatically removed from the old position.
340   @param _prev the node which _new will be inserted after
341   @param _curr the id of the new node being inserted
342   @param _next the node which _new will be inserted before
343   */
344   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
345     require(_curr != NULL_NODE_ID);
346 
347     remove(self, _curr);
348 
349     require(_prev == NULL_NODE_ID || contains(self, _prev));
350     require(_next == NULL_NODE_ID || contains(self, _next));
351 
352     require(getNext(self, _prev) == _next);
353     require(getPrev(self, _next) == _prev);
354 
355     self.dll[_curr].prev = _prev;
356     self.dll[_curr].next = _next;
357 
358     self.dll[_prev].next = _curr;
359     self.dll[_next].prev = _curr;
360   }
361 
362   function remove(Data storage self, uint _curr) public {
363     if (!contains(self, _curr)) {
364       return;
365     }
366 
367     uint next = getNext(self, _curr);
368     uint prev = getPrev(self, _curr);
369 
370     self.dll[next].prev = prev;
371     self.dll[prev].next = next;
372 
373     delete self.dll[_curr];
374   }
375 }
376 
377 library AttributeStore {
378     struct Data {
379         mapping(bytes32 => uint) store;
380     }
381 
382     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
383     public view returns (uint) {
384         bytes32 key = keccak256(_UUID, _attrName);
385         return self.store[key];
386     }
387 
388     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
389     public {
390         bytes32 key = keccak256(_UUID, _attrName);
391         self.store[key] = _attrVal;
392     }
393 }
394 
395 
396 /**
397 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
398 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
399 */
400 contract PLCRVoting {
401 
402     // ============
403     // EVENTS:
404     // ============
405 
406     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
407     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter);
408     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
409     event _VotingRightsGranted(uint numTokens, address indexed voter);
410     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
411     event _TokensRescued(uint indexed pollID, address indexed voter);
412 
413     // ============
414     // DATA STRUCTURES:
415     // ============
416 
417     using AttributeStore for AttributeStore.Data;
418     using DLL for DLL.Data;
419     using SafeMath for uint;
420 
421     struct Poll {
422         uint commitEndDate;     /// expiration date of commit period for poll
423         uint revealEndDate;     /// expiration date of reveal period for poll
424         uint voteQuorum;	    /// number of votes required for a proposal to pass
425         uint votesFor;		    /// tally of votes supporting proposal
426         uint votesAgainst;      /// tally of votes countering proposal
427         mapping(address => bool) didCommit;  /// indicates whether an address committed a vote for this poll
428         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
429     }
430 
431     // ============
432     // STATE VARIABLES:
433     // ============
434 
435     uint constant public INITIAL_POLL_NONCE = 0;
436     uint public pollNonce;
437 
438     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
439     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
440 
441     mapping(address => DLL.Data) dllMap;
442     AttributeStore.Data store;
443 
444     EIP20Interface public token;
445 
446     /**
447     @dev Initializer. Can only be called once.
448     @param _token The address where the ERC20 token contract is deployed
449     */
450     constructor(address _token) public {
451         require(_token != 0 && address(token) == 0);
452 
453         token = EIP20Interface(_token);
454         pollNonce = INITIAL_POLL_NONCE;
455     }
456 
457     // ================
458     // TOKEN INTERFACE:
459     // ================
460 
461     /**
462     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
463     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
464     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
465     */
466     function requestVotingRights(uint _numTokens) public {
467         require(token.balanceOf(msg.sender) >= _numTokens);
468         voteTokenBalance[msg.sender] += _numTokens;
469         require(token.transferFrom(msg.sender, this, _numTokens));
470         emit _VotingRightsGranted(_numTokens, msg.sender);
471     }
472 
473     /**
474     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
475     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
476     */
477     function withdrawVotingRights(uint _numTokens) external {
478         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
479         require(availableTokens >= _numTokens);
480         voteTokenBalance[msg.sender] -= _numTokens;
481         require(token.transfer(msg.sender, _numTokens));
482         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
483     }
484 
485     /**
486     @dev Unlocks tokens locked in unrevealed vote where poll has ended
487     @param _pollID Integer identifier associated with the target poll
488     */
489     function rescueTokens(uint _pollID) public {
490         require(isExpired(pollMap[_pollID].revealEndDate));
491         require(dllMap[msg.sender].contains(_pollID));
492 
493         dllMap[msg.sender].remove(_pollID);
494         emit _TokensRescued(_pollID, msg.sender);
495     }
496 
497     /**
498     @dev Unlocks tokens locked in unrevealed votes where polls have ended
499     @param _pollIDs Array of integer identifiers associated with the target polls
500     */
501     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
502         // loop through arrays, rescuing tokens from all
503         for (uint i = 0; i < _pollIDs.length; i++) {
504             rescueTokens(_pollIDs[i]);
505         }
506     }
507 
508     // =================
509     // VOTING INTERFACE:
510     // =================
511 
512     /**
513     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
514     @param _pollID Integer identifier associated with target poll
515     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
516     @param _numTokens The number of tokens to be committed towards the target poll
517     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
518     */
519     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
520         require(commitPeriodActive(_pollID));
521 
522         // if msg.sender doesn't have enough voting rights,
523         // request for enough voting rights
524         if (voteTokenBalance[msg.sender] < _numTokens) {
525             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
526             requestVotingRights(remainder);
527         }
528 
529         // make sure msg.sender has enough voting rights
530         require(voteTokenBalance[msg.sender] >= _numTokens);
531         // prevent user from committing to zero node placeholder
532         require(_pollID != 0);
533         // prevent user from committing a secretHash of 0
534         require(_secretHash != 0);
535 
536         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
537         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
538 
539         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
540 
541         // edge case: in-place update
542         if (nextPollID == _pollID) {
543             nextPollID = dllMap[msg.sender].getNext(_pollID);
544         }
545 
546         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
547         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
548 
549         bytes32 UUID = attrUUID(msg.sender, _pollID);
550 
551         store.setAttribute(UUID, "numTokens", _numTokens);
552         store.setAttribute(UUID, "commitHash", uint(_secretHash));
553 
554         pollMap[_pollID].didCommit[msg.sender] = true;
555         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
556     }
557 
558     /**
559     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
560     @param _pollIDs         Array of integer identifiers associated with target polls
561     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
562     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
563     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
564     */
565     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
566         // make sure the array lengths are all the same
567         require(_pollIDs.length == _secretHashes.length);
568         require(_pollIDs.length == _numsTokens.length);
569         require(_pollIDs.length == _prevPollIDs.length);
570 
571         // loop through arrays, committing each individual vote values
572         for (uint i = 0; i < _pollIDs.length; i++) {
573             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
574         }
575     }
576 
577     /**
578     @dev Compares previous and next poll's committed tokens for sorting purposes
579     @param _prevID Integer identifier associated with previous poll in sorted order
580     @param _nextID Integer identifier associated with next poll in sorted order
581     @param _voter Address of user to check DLL position for
582     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
583     @return valid Boolean indication of if the specified position maintains the sort
584     */
585     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
586         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
587         // if next is zero node, _numTokens does not need to be greater
588         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
589         return prevValid && nextValid;
590     }
591 
592     /**
593     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
594     @param _pollID Integer identifier associated with target poll
595     @param _voteOption Vote choice used to generate commitHash for associated poll
596     @param _salt Secret number used to generate commitHash for associated poll
597     */
598     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
599         // Make sure the reveal period is active
600         require(revealPeriodActive(_pollID));
601         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
602         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
603         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
604 
605         uint numTokens = getNumTokens(msg.sender, _pollID);
606 
607         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
608             pollMap[_pollID].votesFor += numTokens;
609         } else {
610             pollMap[_pollID].votesAgainst += numTokens;
611         }
612 
613         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
614         pollMap[_pollID].didReveal[msg.sender] = true;
615 
616         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender);
617     }
618 
619     /**
620     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
621     @param _pollIDs     Array of integer identifiers associated with target polls
622     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
623     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
624     */
625     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
626         // make sure the array lengths are all the same
627         require(_pollIDs.length == _voteOptions.length);
628         require(_pollIDs.length == _salts.length);
629 
630         // loop through arrays, revealing each individual vote values
631         for (uint i = 0; i < _pollIDs.length; i++) {
632             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
633         }
634     }
635 
636     /**
637     @param _pollID Integer identifier associated with target poll
638     @param _salt Arbitrarily chosen integer used to generate secretHash
639     @return correctVotes Number of tokens voted for winning option
640     */
641     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
642         require(pollEnded(_pollID));
643         require(pollMap[_pollID].didReveal[_voter]);
644 
645         uint winningChoice = isPassed(_pollID) ? 1 : 0;
646         bytes32 winnerHash = keccak256(abi.encodePacked(winningChoice, _salt));
647         bytes32 commitHash = getCommitHash(_voter, _pollID);
648 
649         require(winnerHash == commitHash);
650 
651         return getNumTokens(_voter, _pollID);
652     }
653 
654     // ==================
655     // POLLING INTERFACE:
656     // ==================
657 
658     /**
659     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
660     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
661     @param _commitDuration Length of desired commit period in seconds
662     @param _revealDuration Length of desired reveal period in seconds
663     */
664     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
665         pollNonce = pollNonce + 1;
666 
667         uint commitEndDate = block.timestamp.add(_commitDuration);
668         uint revealEndDate = commitEndDate.add(_revealDuration);
669 
670         pollMap[pollNonce] = Poll({
671             voteQuorum: _voteQuorum,
672             commitEndDate: commitEndDate,
673             revealEndDate: revealEndDate,
674             votesFor: 0,
675             votesAgainst: 0
676         });
677 
678         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
679         return pollNonce;
680     }
681 
682     /**
683     @notice Determines if proposal has passed
684     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
685     @param _pollID Integer identifier associated with target poll
686     */
687     function isPassed(uint _pollID) constant public returns (bool passed) {
688         require(pollEnded(_pollID));
689 
690         Poll memory poll = pollMap[_pollID];
691         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
692     }
693 
694     // ----------------
695     // POLLING HELPERS:
696     // ----------------
697 
698     /**
699     @dev Gets the total winning votes for reward distribution purposes
700     @param _pollID Integer identifier associated with target poll
701     @return Total number of votes committed to the winning option for specified poll
702     */
703     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
704         require(pollEnded(_pollID));
705 
706         if (isPassed(_pollID))
707             return pollMap[_pollID].votesFor;
708         else
709             return pollMap[_pollID].votesAgainst;
710     }
711 
712     /**
713     @notice Determines if poll is over
714     @dev Checks isExpired for specified poll's revealEndDate
715     @return Boolean indication of whether polling period is over
716     */
717     function pollEnded(uint _pollID) constant public returns (bool ended) {
718         require(pollExists(_pollID));
719 
720         return isExpired(pollMap[_pollID].revealEndDate);
721     }
722 
723     /**
724     @notice Checks if the commit period is still active for the specified poll
725     @dev Checks isExpired for the specified poll's commitEndDate
726     @param _pollID Integer identifier associated with target poll
727     @return Boolean indication of isCommitPeriodActive for target poll
728     */
729     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
730         require(pollExists(_pollID));
731 
732         return !isExpired(pollMap[_pollID].commitEndDate);
733     }
734 
735     /**
736     @notice Checks if the reveal period is still active for the specified poll
737     @dev Checks isExpired for the specified poll's revealEndDate
738     @param _pollID Integer identifier associated with target poll
739     */
740     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
741         require(pollExists(_pollID));
742 
743         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
744     }
745 
746     /**
747     @dev Checks if user has committed for specified poll
748     @param _voter Address of user to check against
749     @param _pollID Integer identifier associated with target poll
750     @return Boolean indication of whether user has committed
751     */
752     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
753         require(pollExists(_pollID));
754 
755         return pollMap[_pollID].didCommit[_voter];
756     }
757 
758     /**
759     @dev Checks if user has revealed for specified poll
760     @param _voter Address of user to check against
761     @param _pollID Integer identifier associated with target poll
762     @return Boolean indication of whether user has revealed
763     */
764     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
765         require(pollExists(_pollID));
766 
767         return pollMap[_pollID].didReveal[_voter];
768     }
769 
770     /**
771     @dev Checks if a poll exists
772     @param _pollID The pollID whose existance is to be evaluated.
773     @return Boolean Indicates whether a poll exists for the provided pollID
774     */
775     function pollExists(uint _pollID) constant public returns (bool exists) {
776         return (_pollID != 0 && _pollID <= pollNonce);
777     }
778 
779     // ---------------------------
780     // DOUBLE-LINKED-LIST HELPERS:
781     // ---------------------------
782 
783     /**
784     @dev Gets the bytes32 commitHash property of target poll
785     @param _voter Address of user to check against
786     @param _pollID Integer identifier associated with target poll
787     @return Bytes32 hash property attached to target poll
788     */
789     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
790         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
791     }
792 
793     /**
794     @dev Wrapper for getAttribute with attrName="numTokens"
795     @param _voter Address of user to check against
796     @param _pollID Integer identifier associated with target poll
797     @return Number of tokens committed to poll in sorted poll-linked-list
798     */
799     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
800         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
801     }
802 
803     /**
804     @dev Gets top element of sorted poll-linked-list
805     @param _voter Address of user to check against
806     @return Integer identifier to poll with maximum number of tokens committed to it
807     */
808     function getLastNode(address _voter) constant public returns (uint pollID) {
809         return dllMap[_voter].getPrev(0);
810     }
811 
812     /**
813     @dev Gets the numTokens property of getLastNode
814     @param _voter Address of user to check against
815     @return Maximum number of tokens committed in poll specified
816     */
817     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
818         return getNumTokens(_voter, getLastNode(_voter));
819     }
820 
821     /*
822     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
823     for a node with a value less than or equal to the provided _numTokens value. When such a node
824     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
825     update. In that case, return the previous node of the node being updated. Otherwise return the
826     first node that was found with a value less than or equal to the provided _numTokens.
827     @param _voter The voter whose DLL will be searched
828     @param _numTokens The value for the numTokens attribute in the node to be inserted
829     @return the node which the propoded node should be inserted after
830     */
831     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
832     constant public returns (uint prevNode) {
833       // Get the last node in the list and the number of tokens in that node
834       uint nodeID = getLastNode(_voter);
835       uint tokensInNode = getNumTokens(_voter, nodeID);
836 
837       // Iterate backwards through the list until reaching the root node
838       while(nodeID != 0) {
839         // Get the number of tokens in the current node
840         tokensInNode = getNumTokens(_voter, nodeID);
841         if(tokensInNode <= _numTokens) { // We found the insert point!
842           if(nodeID == _pollID) {
843             // This is an in-place update. Return the prev node of the node being updated
844             nodeID = dllMap[_voter].getPrev(nodeID);
845           }
846           // Return the insert point
847           return nodeID;
848         }
849         // We did not find the insert point. Continue iterating backwards through the list
850         nodeID = dllMap[_voter].getPrev(nodeID);
851       }
852 
853       // The list is empty, or a smaller value than anything else in the list is being inserted
854       return nodeID;
855     }
856 
857     // ----------------
858     // GENERAL HELPERS:
859     // ----------------
860 
861     /**
862     @dev Checks if an expiration date has been reached
863     @param _terminationDate Integer timestamp of date to compare current timestamp with
864     @return expired Boolean indication of whether the terminationDate has passed
865     */
866     function isExpired(uint _terminationDate) constant public returns (bool expired) {
867         return (block.timestamp > _terminationDate);
868     }
869 
870     /**
871     @dev Generates an identifier which associates a user and a poll together
872     @param _pollID Integer identifier associated with target poll
873     @return UUID Hash which is deterministic from _user and _pollID
874     */
875     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
876         return keccak256(abi.encodePacked(_user, _pollID));
877     }
878 }
879 
880 
881 contract Parameterizer is Ownable, CanCheckERC165 {
882 
883   // ------
884   // EVENTS
885   // ------
886 
887   event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate);
888   event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate);
889   event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
890   event _ProposalExpired(bytes32 indexed propID);
891   event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
892   event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
893   event _RewardClaimed(uint indexed challengeID, uint reward);
894 
895 
896   // ------
897   // DATA STRUCTURES
898   // ------
899 
900   using SafeMath for uint;
901 
902   struct ParamProposal {
903     uint appExpiry;
904     uint challengeID;
905     uint deposit;
906     string name;
907     address owner;
908     uint processBy;
909     uint value;
910   }
911 
912   struct Challenge {
913     uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
914     address challenger;     // owner of Challenge
915     bool resolved;          // indication of if challenge is resolved
916     uint stake;             // number of tokens at risk for either party during challenge
917     uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
918     mapping(address => bool) tokenClaims;
919   }
920 
921   // ------
922   // STATE
923   // ------
924 
925   mapping(bytes32 => uint) public params;
926 
927   // maps challengeIDs to associated challenge data
928   mapping(uint => Challenge) public challenges;
929 
930   // maps pollIDs to intended data change if poll passes
931   mapping(bytes32 => ParamProposal) public proposals;
932 
933   // Global Variables
934   EIP20Interface public token;
935   PLCRVoting public voting;
936   uint public PROCESSBY = 604800; // 7 days
937 
938   string constant NEW_REGISTRY = "_newRegistry";
939   bytes32 constant NEW_REGISTRY_KEC = keccak256(abi.encodePacked(NEW_REGISTRY));
940   bytes32 constant DISPENSATION_PCT_KEC = keccak256(abi.encodePacked("dispensationPct"));
941   bytes32 constant P_DISPENSATION_PCT_KEC = keccak256(abi.encodePacked("pDispensationPct"));
942 
943   // todo: fill this in with the interface ID of the registry migration interface we will have
944   bytes4 public REGISTRY_INTERFACE_REQUIREMENT;
945 
946   // ------------
947   // CONSTRUCTOR
948   // ------------
949 
950   /**
951   @dev constructor
952   @param _tokenAddr        address of the token which parameterizes this system
953   @param _plcrAddr         address of a PLCR voting contract for the provided token
954   @param _minDeposit       minimum deposit for listing to be whitelisted
955   @param _pMinDeposit      minimum deposit to propose a reparameterization
956   @param _applyStageLen    period over which applicants wait to be whitelisted
957   @param _pApplyStageLen   period over which reparmeterization proposals wait to be processed
958   @param _dispensationPct  percentage of losing party's deposit distributed to winning party
959   @param _pDispensationPct percentage of losing party's deposit distributed to winning party in parameterizer
960   @param _commitStageLen  length of commit period for voting
961   @param _pCommitStageLen length of commit period for voting in parameterizer
962   @param _revealStageLen  length of reveal period for voting
963   @param _pRevealStageLen length of reveal period for voting in parameterizer
964   @param _voteQuorum       type of majority out of 100 necessary for vote success
965   @param _pVoteQuorum      type of majority out of 100 necessary for vote success in parameterizer
966   @param _newRegistryIface ERC165 interface ID requirement (not a votable parameter)
967   */
968   constructor(
969     address _tokenAddr,
970     address _plcrAddr,
971     uint _minDeposit,
972     uint _pMinDeposit,
973     uint _applyStageLen,
974     uint _pApplyStageLen,
975     uint _commitStageLen,
976     uint _pCommitStageLen,
977     uint _revealStageLen,
978     uint _pRevealStageLen,
979     uint _dispensationPct,
980     uint _pDispensationPct,
981     uint _voteQuorum,
982     uint _pVoteQuorum,
983     bytes4 _newRegistryIface
984     ) Ownable() public {
985       token = EIP20Interface(_tokenAddr);
986       voting = PLCRVoting(_plcrAddr);
987       REGISTRY_INTERFACE_REQUIREMENT = _newRegistryIface;
988 
989       set("minDeposit", _minDeposit);
990       set("pMinDeposit", _pMinDeposit);
991       set("applyStageLen", _applyStageLen);
992       set("pApplyStageLen", _pApplyStageLen);
993       set("commitStageLen", _commitStageLen);
994       set("pCommitStageLen", _pCommitStageLen);
995       set("revealStageLen", _revealStageLen);
996       set("pRevealStageLen", _pRevealStageLen);
997       set("dispensationPct", _dispensationPct);
998       set("pDispensationPct", _pDispensationPct);
999       set("voteQuorum", _voteQuorum);
1000       set("pVoteQuorum", _pVoteQuorum);
1001   }
1002 
1003   // -----------------------
1004   // TOKEN HOLDER INTERFACE
1005   // -----------------------
1006 
1007   /**
1008   @notice propose a reparamaterization of the key _name's value to _value.
1009   @param _name the name of the proposed param to be set
1010   @param _value the proposed value to set the param to be set
1011   */
1012   function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
1013     uint deposit = get("pMinDeposit");
1014     bytes32 propID = keccak256(abi.encodePacked(_name, _value));
1015     bytes32 _nameKec = keccak256(abi.encodePacked(_name));
1016 
1017     if (_nameKec == DISPENSATION_PCT_KEC ||
1018        _nameKec == P_DISPENSATION_PCT_KEC) {
1019         require(_value <= 100);
1020     }
1021 
1022     if(keccak256(abi.encodePacked(_name)) == NEW_REGISTRY_KEC) {
1023       require(getNewRegistry() == address(0));
1024       require(_value != 0);
1025       require(msg.sender == owner);
1026       require((_value & 0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff) == _value); // i.e., _value is zero-padded address
1027       require(this.doesContractImplementInterface(address(_value), REGISTRY_INTERFACE_REQUIREMENT));
1028     }
1029 
1030     require(!propExists(propID)); // Forbid duplicate proposals
1031     require(get(_name) != _value); // Forbid NOOP reparameterizations
1032 
1033     // attach name and value to pollID
1034     proposals[propID] = ParamProposal({
1035       appExpiry: now.add(get("pApplyStageLen")),
1036       challengeID: 0,
1037       deposit: deposit,
1038       name: _name,
1039       owner: msg.sender,
1040       processBy: now.add(get("pApplyStageLen"))
1041         .add(get("pCommitStageLen"))
1042         .add(get("pRevealStageLen"))
1043         .add(PROCESSBY),
1044       value: _value
1045     });
1046 
1047     require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
1048 
1049     emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry);
1050     return propID;
1051   }
1052 
1053   /**
1054   @notice gets the address of the new registry, if set.
1055   */
1056   function getNewRegistry() public view returns (address) {
1057     //return address(get(NEW_REGISTRY));
1058     return address(params[NEW_REGISTRY_KEC]); // bit of an optimization
1059   }
1060 
1061   /**
1062   @notice challenge the provided proposal ID, and put tokens at stake to do so.
1063   @param _propID the proposal ID to challenge
1064   */
1065   function challengeReparameterization(bytes32 _propID) public returns (uint) {
1066     ParamProposal memory prop = proposals[_propID];
1067     uint deposit = prop.deposit;
1068 
1069     require(propExists(_propID) && prop.challengeID == 0);
1070 
1071     //start poll
1072     uint pollID = voting.startPoll(
1073       get("pVoteQuorum"),
1074       get("pCommitStageLen"),
1075       get("pRevealStageLen")
1076     );
1077 
1078     challenges[pollID] = Challenge({
1079       challenger: msg.sender,
1080       rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
1081       stake: deposit,
1082       resolved: false,
1083       winningTokens: 0
1084     });
1085 
1086     proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
1087 
1088     //take tokens from challenger
1089     require(token.transferFrom(msg.sender, this, deposit));
1090 
1091     (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
1092 
1093     emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate);
1094     return pollID;
1095   }
1096 
1097   /**
1098   @notice for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
1099   @param _propID the proposal ID to make a determination and state transition for
1100   */
1101   function processProposal(bytes32 _propID) public {
1102     ParamProposal storage prop = proposals[_propID];
1103     address propOwner = prop.owner;
1104     uint propDeposit = prop.deposit;
1105 
1106 
1107     // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
1108     // prop.owner and prop.deposit will be 0, thereby preventing theft
1109    if (canBeSet(_propID)) {
1110       // There is no challenge against the proposal. The processBy date for the proposal has not
1111      // passed, but the proposal's appExpirty date has passed.
1112       set(prop.name, prop.value);
1113       emit _ProposalAccepted(_propID, prop.name, prop.value);
1114       delete proposals[_propID];
1115       require(token.transfer(propOwner, propDeposit));
1116     } else if (challengeCanBeResolved(_propID)) {
1117       // There is a challenge against the proposal.
1118       resolveChallenge(_propID);
1119     } else if (now > prop.processBy) {
1120       // There is no challenge against the proposal, but the processBy date has passed.
1121       emit _ProposalExpired(_propID);
1122       delete proposals[_propID];
1123       require(token.transfer(propOwner, propDeposit));
1124     } else {
1125       // There is no challenge against the proposal, and neither the appExpiry date nor the
1126       // processBy date has passed.
1127       revert();
1128     }
1129 
1130     assert(get("dispensationPct") <= 100);
1131     assert(get("pDispensationPct") <= 100);
1132 
1133     // verify that future proposal appExpiry and processBy times will not overflow
1134     now.add(get("pApplyStageLen"))
1135       .add(get("pCommitStageLen"))
1136       .add(get("pRevealStageLen"))
1137       .add(PROCESSBY);
1138 
1139     delete proposals[_propID];
1140   }
1141 
1142   /**
1143   @notice claim the tokens owed for the msg.sender in the provided challenge
1144   @param _challengeID the challenge ID to claim tokens for
1145   @param _salt the salt used to vote in the challenge being withdrawn for
1146   */
1147   function claimReward(uint _challengeID, uint _salt) public {
1148     // ensure voter has not already claimed tokens and challenge results have been processed
1149     require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1150     require(challenges[_challengeID].resolved == true);
1151 
1152     uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1153     uint reward = voterReward(msg.sender, _challengeID, _salt);
1154 
1155     // subtract voter's information to preserve the participation ratios of other voters
1156     // compared to the remaining pool of rewards
1157     challenges[_challengeID].winningTokens = challenges[_challengeID].winningTokens.sub(voterTokens);
1158     challenges[_challengeID].rewardPool = challenges[_challengeID].rewardPool.sub(reward);
1159 
1160     // ensures a voter cannot claim tokens again
1161     challenges[_challengeID].tokenClaims[msg.sender] = true;
1162 
1163     emit _RewardClaimed(_challengeID, reward);
1164     require(token.transfer(msg.sender, reward));
1165   }
1166 
1167   // --------
1168   // GETTERS
1169   // --------
1170 
1171   /**
1172   @dev                Calculates the provided voter's token reward for the given poll.
1173   @param _voter       The address of the voter whose reward balance is to be returned
1174   @param _challengeID The ID of the challenge the voter's reward is being calculated for
1175   @param _salt        The salt of the voter's commit hash in the given poll
1176   @return             The uint indicating the voter's reward
1177   */
1178   function voterReward(address _voter, uint _challengeID, uint _salt)
1179   public view returns (uint) {
1180     uint winningTokens = challenges[_challengeID].winningTokens;
1181     uint rewardPool = challenges[_challengeID].rewardPool;
1182     uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1183     return voterTokens.mul(rewardPool).div(winningTokens);
1184   }
1185 
1186   /**
1187   @notice Determines whether a proposal passed its application stage without a challenge
1188   @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
1189   */
1190   function canBeSet(bytes32 _propID) view public returns (bool) {
1191     ParamProposal memory prop = proposals[_propID];
1192 
1193     return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1194   }
1195 
1196   /**
1197   @notice Determines whether a proposal exists for the provided proposal ID
1198   @param _propID The proposal ID whose existance is to be determined
1199   */
1200   function propExists(bytes32 _propID) view public returns (bool) {
1201     return proposals[_propID].processBy > 0;
1202   }
1203 
1204   /**
1205   @notice Determines whether the provided proposal ID has a challenge which can be resolved
1206   @param _propID The proposal ID whose challenge to inspect
1207   */
1208   function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1209     ParamProposal memory prop = proposals[_propID];
1210     Challenge memory challenge = challenges[prop.challengeID];
1211 
1212     return (prop.challengeID > 0 && challenge.resolved == false &&
1213             voting.pollEnded(prop.challengeID));
1214   }
1215 
1216   /**
1217   @notice Determines the number of tokens to awarded to the winning party in a challenge
1218   @param _challengeID The challengeID to determine a reward for
1219   */
1220   function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1221     if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1222       // Edge case, nobody voted, give all tokens to the challenger.
1223       return challenges[_challengeID].stake.mul(2);
1224     }
1225 
1226     return challenges[_challengeID].stake.mul(2).sub(challenges[_challengeID].rewardPool);
1227   }
1228 
1229   /**
1230   @notice gets the parameter keyed by the provided name value from the params mapping
1231   @param _name the key whose value is to be determined
1232   */
1233   function get(string _name) public view returns (uint value) {
1234     return params[keccak256(abi.encodePacked(_name))];
1235   }
1236 
1237   /**
1238   @dev                Getter for Challenge tokenClaims mappings
1239   @param _challengeID The challengeID to query
1240   @param _voter       The voter whose claim status to query for the provided challengeID
1241   */
1242   function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1243     return challenges[_challengeID].tokenClaims[_voter];
1244   }
1245 
1246   // ----------------
1247   // PRIVATE FUNCTIONS
1248   // ----------------
1249 
1250   /**
1251   @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1252   @param _propID the proposal ID whose challenge is to be resolved.
1253   */
1254   function resolveChallenge(bytes32 _propID) private {
1255     ParamProposal memory prop = proposals[_propID];
1256     Challenge storage challenge = challenges[prop.challengeID];
1257 
1258     // winner gets back their full staked deposit, and dispensationPct*loser's stake
1259     uint reward = challengeWinnerReward(prop.challengeID);
1260 
1261     challenge.winningTokens =
1262       voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1263     challenge.resolved = true;
1264 
1265     if (voting.isPassed(prop.challengeID)) { // The challenge failed
1266       if(prop.processBy > now) {
1267         set(prop.name, prop.value);
1268       }
1269       emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1270       require(token.transfer(prop.owner, reward));
1271     }
1272     else { // The challenge succeeded or nobody voted
1273       emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1274       require(token.transfer(challenges[prop.challengeID].challenger, reward));
1275     }
1276   }
1277 
1278   /**
1279   @dev sets the param keted by the provided name to the provided value
1280   @param _name the name of the param to be set
1281   @param _value the value to set the param to be set
1282   */
1283   function set(string _name, uint _value) private {
1284     params[keccak256(abi.encodePacked(_name))] = _value;
1285   }
1286 }
1287 
1288 
1289 contract SupercedesRegistry is ERC165 {
1290   function canReceiveListing(bytes32 listingHash, uint applicationExpiry, bool whitelisted, address owner, uint unstakedDeposit, uint challengeID) external view returns (bool);
1291   function receiveListing(bytes32 listingHash, uint applicationExpiry, bool whitelisted, address owner, uint unstakedDeposit, uint challengeID) external;
1292   function getSupercedesRegistryInterfaceID() public pure returns (bytes4) {
1293     SupercedesRegistry i;
1294     return i.canReceiveListing.selector ^ i.receiveListing.selector;
1295   }
1296 }
1297 
1298 
1299 
1300 contract Registry {
1301 
1302     // ------
1303     // EVENTS
1304     // ------
1305 
1306     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data);
1307     event _Challenge(bytes32 indexed listingHash, uint challengeID, uint deposit, string data);
1308     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal);
1309     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal);
1310     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1311     event _ApplicationRemoved(bytes32 indexed listingHash);
1312     event _ListingRemoved(bytes32 indexed listingHash);
1313     event _ListingWithdrawn(bytes32 indexed listingHash);
1314     event _TouchAndRemoved(bytes32 indexed listingHash);
1315     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1316     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1317     event _RewardClaimed(uint indexed challengeID, uint reward, address voter);
1318     event _ListingMigrated(bytes32 indexed listingHash, address newRegistry);
1319 
1320     using SafeMath for uint;
1321 
1322     struct Listing {
1323         uint applicationExpiry; // Expiration date of apply stage
1324         bool whitelisted;       // Indicates registry status
1325         address owner;          // Owner of Listing
1326         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1327         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1328     }
1329 
1330     struct Challenge {
1331         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1332         address challenger;     // Owner of Challenge
1333         bool resolved;          // Indication of if challenge is resolved
1334         uint stake;             // Number of tokens at stake for either party during challenge
1335         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1336         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1337     }
1338 
1339     // Maps challengeIDs to associated challenge data
1340     mapping(uint => Challenge) public challenges;
1341 
1342     // Maps listingHashes to associated listingHash data
1343     mapping(bytes32 => Listing) public listings;
1344 
1345     // Maps number of applications per address
1346     mapping(address => uint) public numApplications;
1347 
1348     // Maps total amount staked per address
1349     mapping(address => uint) public totalStaked;
1350 
1351     // Global Variables
1352     EIP20Interface public token;
1353     PLCRVoting public voting;
1354     Parameterizer public parameterizer;
1355     string public constant version = "1";
1356 
1357     // ------------
1358     // CONSTRUCTOR:
1359     // ------------
1360 
1361     /**
1362     @dev Contructor         Sets the addresses for token, voting, and parameterizer
1363     @param _tokenAddr       Address of the TCR's intrinsic ERC20 token
1364     @param _plcrAddr        Address of a PLCR voting contract for the provided token
1365     @param _paramsAddr      Address of a Parameterizer contract
1366     */
1367     constructor(
1368         address _tokenAddr,
1369         address _plcrAddr,
1370         address _paramsAddr
1371     ) public {
1372         token = EIP20Interface(_tokenAddr);
1373         voting = PLCRVoting(_plcrAddr);
1374         parameterizer = Parameterizer(_paramsAddr);
1375     }
1376 
1377     // --------------------
1378     // PUBLISHER INTERFACE:
1379     // --------------------
1380 
1381     /**
1382     @dev                Allows a user to start an application. Takes tokens from user and sets
1383                         apply stage end time.
1384     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1385     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1386     @param _data        Extra data relevant to the application. Think IPFS hashes.
1387     */
1388     function apply(bytes32 _listingHash, uint _amount, string _data) onlyIfCurrentRegistry external {
1389         require(!isWhitelisted(_listingHash));
1390         require(!appWasMade(_listingHash));
1391         require(_amount >= parameterizer.get("minDeposit"));
1392 
1393         // Sets owner
1394         Listing storage listing = listings[_listingHash];
1395         listing.owner = msg.sender;
1396 
1397         // Sets apply stage end time
1398         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1399         listing.unstakedDeposit = _amount;
1400 
1401         // Tally application count per address
1402         numApplications[listing.owner] = numApplications[listing.owner].add(1);
1403 
1404         // Tally total staked amount
1405         totalStaked[listing.owner] = totalStaked[listing.owner].add(_amount);
1406 
1407         // Transfers tokens from user to Registry contract
1408         require(token.transferFrom(listing.owner, this, _amount));
1409         emit _Application(_listingHash, _amount, listing.applicationExpiry, _data);
1410     }
1411 
1412     /**
1413     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1414     @param _listingHash A listingHash msg.sender is the owner of
1415     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1416     */
1417     function deposit(bytes32 _listingHash, uint _amount) external {
1418         Listing storage listing = listings[_listingHash];
1419 
1420         require(listing.owner == msg.sender);
1421 
1422         listing.unstakedDeposit = listing.unstakedDeposit.add(_amount);
1423 
1424         // Update total stake
1425         totalStaked[listing.owner] = totalStaked[listing.owner].add(_amount);
1426 
1427         require(token.transferFrom(msg.sender, this, _amount));
1428 
1429         emit _Deposit(_listingHash, _amount, listing.unstakedDeposit);
1430     }
1431 
1432     /**
1433     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1434     @param _listingHash A listingHash msg.sender is the owner of.
1435     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1436     */
1437     function withdraw(bytes32 _listingHash, uint _amount) external {
1438         Listing storage listing = listings[_listingHash];
1439 
1440         require(listing.owner == msg.sender);
1441         require(_amount <= listing.unstakedDeposit);
1442         require(listing.unstakedDeposit.sub(_amount) >= parameterizer.get("minDeposit"));
1443 
1444         listing.unstakedDeposit = listing.unstakedDeposit.sub(_amount);
1445 
1446         require(token.transfer(msg.sender, _amount));
1447 
1448         emit _Withdrawal(_listingHash, _amount, listing.unstakedDeposit);
1449     }
1450 
1451     /**
1452     @dev                Allows the owner of a listingHash to remove the listingHash from the whitelist
1453                         Returns all tokens to the owner of the listingHash
1454     @param _listingHash A listingHash msg.sender is the owner of.
1455     */
1456     function exit(bytes32 _listingHash) external {
1457         Listing storage listing = listings[_listingHash];
1458 
1459         require(msg.sender == listing.owner);
1460         require(isWhitelisted(_listingHash));
1461 
1462         // Cannot exit during ongoing challenge
1463         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1464 
1465         // Remove listingHash & return tokens
1466         resetListing(_listingHash);
1467         emit _ListingWithdrawn(_listingHash);
1468     }
1469 
1470     // -----------------------
1471     // TOKEN HOLDER INTERFACE:
1472     // -----------------------
1473 
1474     /**
1475     @dev                Starts a poll for a listingHash which is either in the apply stage or
1476                         already in the whitelist. Tokens are taken from the challenger and the
1477                         applicant's deposits are locked.
1478     @param _listingHash The listingHash being challenged, whether listed or in application
1479     @param _deposit     The deposit with which the listing is challenge (used to be `minDeposit`)
1480     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1481     */
1482     function challenge(bytes32 _listingHash, uint _deposit, string _data) onlyIfCurrentRegistry external returns (uint challengeID) {
1483         Listing storage listing = listings[_listingHash];
1484         uint minDeposit = parameterizer.get("minDeposit");
1485 
1486         // Listing must be in apply stage or already on the whitelist
1487         require(appWasMade(_listingHash) || listing.whitelisted);
1488         // Prevent multiple challenges
1489         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1490 
1491         if (listing.unstakedDeposit < minDeposit) {
1492             // Not enough tokens, listingHash auto-delisted
1493             resetListing(_listingHash);
1494             emit _TouchAndRemoved(_listingHash);
1495             return 0;
1496         }
1497 
1498         // Starts poll
1499         uint pollID = voting.startPoll(
1500             parameterizer.get("voteQuorum"),
1501             parameterizer.get("commitStageLen"),
1502             parameterizer.get("revealStageLen")
1503         );
1504 
1505         challenges[pollID] = Challenge({
1506             challenger: msg.sender,
1507             rewardPool: ((100 - parameterizer.get("dispensationPct")) * _deposit) / 100,
1508             stake: _deposit,
1509             resolved: false,
1510             totalTokens: 0
1511         });
1512 
1513         // Updates listingHash to store most recent challenge
1514         listing.challengeID = pollID;
1515 
1516         // make sure _deposit is more than minDeposit and smaller than unstaked deposit
1517         require(_deposit >= minDeposit && _deposit <= listing.unstakedDeposit);
1518 
1519         // Locks tokens for listingHash during challenge
1520         listing.unstakedDeposit = listing.unstakedDeposit.sub(_deposit);
1521 
1522         // Takes tokens from challenger
1523         require(token.transferFrom(msg.sender, this, _deposit));
1524 
1525         emit _Challenge(_listingHash, pollID, _deposit, _data);
1526         return pollID;
1527     }
1528 
1529     /**
1530     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1531                         a challenge if one exists.
1532     @param _listingHash The listingHash whose status is being updated
1533     */
1534     function updateStatus(bytes32 _listingHash) public {
1535         if (canBeWhitelisted(_listingHash)) {
1536           whitelistApplication(_listingHash);
1537         } else if (challengeCanBeResolved(_listingHash)) {
1538           resolveChallenge(_listingHash);
1539         } else {
1540           revert();
1541         }
1542     }
1543 
1544     // ----------------
1545     // TOKEN FUNCTIONS:
1546     // ----------------
1547 
1548     /**
1549     @dev                Called by a voter to claim their reward for each completed vote. Someone
1550                         must call updateStatus() before this can be called.
1551     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1552     @param _salt        The salt of a voter's commit hash in the given poll
1553     */
1554     function claimReward(uint _challengeID, uint _salt) public {
1555         // Ensures the voter has not already claimed tokens and challenge results have been processed
1556         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1557         require(challenges[_challengeID].resolved == true);
1558 
1559         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1560         uint reward = voterReward(msg.sender, _challengeID, _salt);
1561 
1562         // Subtracts the voter's information to preserve the participation ratios
1563         // of other voters compared to the remaining pool of rewards
1564         challenges[_challengeID].totalTokens = challenges[_challengeID].totalTokens.sub(voterTokens);
1565         challenges[_challengeID].rewardPool = challenges[_challengeID].rewardPool.sub(reward);
1566 
1567         // Ensures a voter cannot claim tokens again
1568         challenges[_challengeID].tokenClaims[msg.sender] = true;
1569 
1570         require(token.transfer(msg.sender, reward));
1571 
1572         emit _RewardClaimed(_challengeID, reward, msg.sender);
1573     }
1574 
1575     // --------
1576     // GETTERS:
1577     // --------
1578 
1579     /**
1580     @dev                Calculates the provided voter's token reward for the given poll.
1581     @param _voter       The address of the voter whose reward balance is to be returned
1582     @param _challengeID The pollID of the challenge a reward balance is being queried for
1583     @param _salt        The salt of the voter's commit hash in the given poll
1584     @return             The uint indicating the voter's reward
1585     */
1586     function voterReward(address _voter, uint _challengeID, uint _salt)
1587     public view returns (uint) {
1588         uint totalTokens = challenges[_challengeID].totalTokens;
1589         uint rewardPool = challenges[_challengeID].rewardPool;
1590         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1591         return (voterTokens * rewardPool) / totalTokens;
1592     }
1593 
1594     /**
1595     @dev                Determines whether the given listingHash can be whitelisted.
1596     @param _listingHash The listingHash whose status is to be examined
1597     */
1598     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1599         uint challengeID = listings[_listingHash].challengeID;
1600 
1601         // Ensures that the application was made,
1602         // the application period has ended,
1603         // the listingHash can be whitelisted,
1604         // and either: the challengeID == 0, or the challenge has been resolved.
1605         if (
1606             appWasMade(_listingHash) &&
1607             listings[_listingHash].applicationExpiry < now &&
1608             !isWhitelisted(_listingHash) &&
1609             (challengeID == 0 || challenges[challengeID].resolved == true)
1610         ) {
1611           return true;
1612         }
1613 
1614         return false;
1615     }
1616 
1617     /**
1618     @dev                Returns true if the provided listingHash is whitelisted
1619     @param _listingHash The listingHash whose status is to be examined
1620     */
1621     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1622         return listings[_listingHash].whitelisted;
1623     }
1624 
1625     /**
1626     @dev                Returns true if apply was called for this listingHash
1627     @param _listingHash The listingHash whose status is to be examined
1628     */
1629     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1630         return listings[_listingHash].applicationExpiry > 0;
1631     }
1632 
1633     /**
1634     @dev                Returns true if the application/listingHash has an unresolved challenge
1635     @param _listingHash The listingHash whose status is to be examined
1636     */
1637     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1638         uint challengeID = listings[_listingHash].challengeID;
1639 
1640         return (challengeID > 0 && !challenges[challengeID].resolved);
1641     }
1642 
1643     /**
1644     @dev                Determines whether voting has concluded in a challenge for a given
1645                         listingHash. Throws if no challenge exists.
1646     @param _listingHash A listingHash with an unresolved challenge
1647     */
1648     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1649         uint challengeID = listings[_listingHash].challengeID;
1650 
1651         require(challengeExists(_listingHash));
1652 
1653         return voting.pollEnded(challengeID);
1654     }
1655 
1656     /**
1657     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1658     @param _challengeID The challengeID to determine a reward for
1659     */
1660     function determineReward(uint _challengeID) public view returns (uint) {
1661         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1662 
1663         // Edge case, nobody voted, give all tokens to the challenger.
1664         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1665             return challenges[_challengeID].stake.mul(2);
1666         }
1667 
1668         return (challenges[_challengeID].stake).mul(2).sub(challenges[_challengeID].rewardPool);
1669     }
1670 
1671     /**
1672     @dev                Getter for Challenge tokenClaims mappings
1673     @param _challengeID The challengeID to query
1674     @param _voter       The voter whose claim status to query for the provided challengeID
1675     */
1676     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1677       return challenges[_challengeID].tokenClaims[_voter];
1678     }
1679 
1680     // ----------------
1681     // PRIVATE FUNCTIONS:
1682     // ----------------
1683 
1684     /**
1685     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1686                         either whitelists or de-whitelists the listingHash.
1687     @param _listingHash A listingHash with a challenge that is to be resolved
1688     */
1689     function resolveChallenge(bytes32 _listingHash) private {
1690         uint challengeID = listings[_listingHash].challengeID;
1691 
1692         // Calculates the winner's reward,
1693         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1694         uint reward = determineReward(challengeID);
1695 
1696         // Sets flag on challenge being processed
1697         challenges[challengeID].resolved = true;
1698 
1699         // Stores the total tokens used for voting by the winning side for reward purposes
1700         challenges[challengeID].totalTokens =
1701             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1702 
1703         // Case: challenge failed
1704         if (voting.isPassed(challengeID)) {
1705             whitelistApplication(_listingHash);
1706             // Unlock stake so that it can be retrieved by the applicant
1707             listings[_listingHash].unstakedDeposit = listings[_listingHash].unstakedDeposit.add(reward);
1708 
1709             totalStaked[listings[_listingHash].owner] = totalStaked[listings[_listingHash].owner].add(reward);
1710 
1711             emit _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1712         }
1713         // Case: challenge succeeded or nobody voted
1714         else {
1715             resetListing(_listingHash);
1716             // Transfer the reward to the challenger
1717             require(token.transfer(challenges[challengeID].challenger, reward));
1718 
1719             emit _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1720         }
1721     }
1722 
1723     /**
1724     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1725                         challenge being made. Called by resolveChallenge() if an
1726                         application/listing beat a challenge.
1727     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1728     */
1729     function whitelistApplication(bytes32 _listingHash) private {
1730         if (!listings[_listingHash].whitelisted) {
1731           emit _ApplicationWhitelisted(_listingHash);
1732         }
1733         listings[_listingHash].whitelisted = true;
1734     }
1735 
1736     /**
1737     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1738     @param _listingHash The listing hash to delete
1739     */
1740     function resetListing(bytes32 _listingHash) private {
1741         Listing storage listing = listings[_listingHash];
1742 
1743         // Emit events before deleting listing to check whether is whitelisted
1744         if (listing.whitelisted) {
1745             emit _ListingRemoved(_listingHash);
1746         } else {
1747             emit _ApplicationRemoved(_listingHash);
1748         }
1749 
1750         // Deleting listing to prevent reentry
1751         address owner = listing.owner;
1752         uint unstakedDeposit = listing.unstakedDeposit;
1753         delete listings[_listingHash];
1754 
1755         // Transfers any remaining balance back to the owner
1756         if (unstakedDeposit > 0){
1757             require(token.transfer(owner, unstakedDeposit));
1758         }
1759     }
1760 
1761     /**
1762     @dev Modifier to specify that a function can only be called if this is the current registry.
1763     */
1764     modifier onlyIfCurrentRegistry() {
1765       require(parameterizer.getNewRegistry() == address(0));
1766       _;
1767     }
1768 
1769     /**
1770     @dev Modifier to specify that a function cannot be called if this is the current registry.
1771     */
1772     modifier onlyIfOutdatedRegistry() {
1773       require(parameterizer.getNewRegistry() != address(0));
1774       _;
1775     }
1776 
1777     /**
1778      @dev Check if a listing exists in the registry by checking that its owner is not zero
1779           Since all solidity mappings have every key set to zero, we check that the address of the creator isn't zero.
1780     */
1781     function listingExists(bytes32 listingHash) public view returns (bool) {
1782       return listings[listingHash].owner != address(0);
1783     }
1784 
1785     /**
1786     @dev migrates a listing
1787     */
1788     function migrateListing(bytes32 listingHash) onlyIfOutdatedRegistry public {
1789       require(listingExists(listingHash)); // duh
1790       require(!challengeExists(listingHash)); // can't migrate a listing that's challenged
1791 
1792       address newRegistryAddress = parameterizer.getNewRegistry();
1793       SupercedesRegistry newRegistry = SupercedesRegistry(newRegistryAddress);
1794       Listing storage listing = listings[listingHash];
1795 
1796       require(newRegistry.canReceiveListing(
1797         listingHash, listing.applicationExpiry,
1798         listing.whitelisted, listing.owner,
1799         listing.unstakedDeposit, listing.challengeID
1800       ));
1801 
1802       token.approve(newRegistry, listing.unstakedDeposit);
1803       newRegistry.receiveListing(
1804         listingHash, listing.applicationExpiry,
1805         listing.whitelisted, listing.owner,
1806         listing.unstakedDeposit, listing.challengeID
1807       );
1808       delete listings[listingHash];
1809       emit _ListingMigrated(listingHash, newRegistryAddress);
1810     }
1811 }