1 contract EIP20Interface {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) public view returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) public returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) public returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract EIP20 is EIP20Interface {
47 
48     uint256 constant MAX_UINT256 = 2**256 - 1;
49 
50     /*
51     NOTE:
52     The following variables are OPTIONAL vanities. One does not have to include them.
53     They allow one to customise the token contract & in no way influences the core functionality.
54     Some wallets/interfaces might not even bother to look at this information.
55     */
56     string public name;                   //fancy name: eg Simon Bucks
57     uint8 public decimals;                //How many decimals to show.
58     string public symbol;                 //An identifier: eg SBX
59 
60      function EIP20(
61         uint256 _initialAmount,
62         string _tokenName,
63         uint8 _decimalUnits,
64         string _tokenSymbol
65         ) public {
66         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
67         totalSupply = _initialAmount;                        // Update total supply
68         name = _tokenName;                                   // Set the name for display purposes
69         decimals = _decimalUnits;                            // Amount of decimals for display purposes
70         symbol = _tokenSymbol;                               // Set the symbol for display purposes
71     }
72 
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         //Default assumes totalSupply can't be over max (2^256 - 1).
75         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
76         //Replace the if with this one instead.
77         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
78         require(balances[msg.sender] >= _value);
79         balances[msg.sender] -= _value;
80         balances[_to] += _value;
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         //same as above. Replace this line with the following if you want to protect against wrapping uints.
87         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
88         uint256 allowance = allowed[_from][msg.sender];
89         require(balances[_from] >= _value && allowance >= _value);
90         balances[_to] += _value;
91         balances[_from] -= _value;
92         if (allowance < MAX_UINT256) {
93             allowed[_from][msg.sender] -= _value;
94         }
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function balanceOf(address _owner) view public returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender)
110     view public returns (uint256 remaining) {
111       return allowed[_owner][_spender];
112     }
113 
114     mapping (address => uint256) balances;
115     mapping (address => mapping (address => uint256)) allowed;
116 }
117 
118 library DLL {
119 
120   uint constant NULL_NODE_ID = 0;
121 
122   struct Node {
123     uint next;
124     uint prev;
125   }
126 
127   struct Data {
128     mapping(uint => Node) dll;
129   }
130 
131   function isEmpty(Data storage self) public view returns (bool) {
132     return getStart(self) == NULL_NODE_ID;
133   }
134 
135   function contains(Data storage self, uint _curr) public view returns (bool) {
136     if (isEmpty(self) || _curr == NULL_NODE_ID) {
137       return false;
138     } 
139 
140     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
141     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
142     return isSingleNode || !isNullNode;
143   }
144 
145   function getNext(Data storage self, uint _curr) public view returns (uint) {
146     return self.dll[_curr].next;
147   }
148 
149   function getPrev(Data storage self, uint _curr) public view returns (uint) {
150     return self.dll[_curr].prev;
151   }
152 
153   function getStart(Data storage self) public view returns (uint) {
154     return getNext(self, NULL_NODE_ID);
155   }
156 
157   function getEnd(Data storage self) public view returns (uint) {
158     return getPrev(self, NULL_NODE_ID);
159   }
160 
161   /**
162   @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
163   the list it will be automatically removed from the old position.
164   @param _prev the node which _new will be inserted after
165   @param _curr the id of the new node being inserted
166   @param _next the node which _new will be inserted before
167   */
168   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
169     require(_curr != NULL_NODE_ID);
170     require(_prev == NULL_NODE_ID || contains(self, _prev));
171 
172     remove(self, _curr);
173 
174     require(getNext(self, _prev) == _next);
175 
176     self.dll[_curr].prev = _prev;
177     self.dll[_curr].next = _next;
178 
179     self.dll[_prev].next = _curr;
180     self.dll[_next].prev = _curr;
181   }
182 
183   function remove(Data storage self, uint _curr) public {
184     if (!contains(self, _curr)) {
185       return;
186     }
187 
188     uint next = getNext(self, _curr);
189     uint prev = getPrev(self, _curr);
190 
191     self.dll[next].prev = prev;
192     self.dll[prev].next = next;
193 
194     delete self.dll[_curr];
195   }
196 }
197 
198 library AttributeStore {
199     struct Data {
200         mapping(bytes32 => uint) store;
201     }
202 
203     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
204     public view returns (uint) {
205         bytes32 key = keccak256(_UUID, _attrName);
206         return self.store[key];
207     }
208 
209     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
210     public {
211         bytes32 key = keccak256(_UUID, _attrName);
212         self.store[key] = _attrVal;
213     }
214 }
215 
216 contract PLCRVoting {
217 
218     // ============
219     // EVENTS:
220     // ============
221 
222     event VoteCommitted(address voter, uint pollID, uint numTokens);
223     event VoteRevealed(address voter, uint pollID, uint numTokens, uint choice);
224     event PollCreated(uint voteQuorum, uint commitDuration, uint revealDuration, uint pollID);
225     event VotingRightsGranted(address voter, uint numTokens);
226     event VotingRightsWithdrawn(address voter, uint numTokens);
227 
228     // ============
229     // DATA STRUCTURES:
230     // ============
231 
232     using AttributeStore for AttributeStore.Data;
233     using DLL for DLL.Data;
234 
235     struct Poll {
236         uint commitEndDate;     /// expiration date of commit period for poll
237         uint revealEndDate;     /// expiration date of reveal period for poll
238         uint voteQuorum;	    /// number of votes required for a proposal to pass
239         uint votesFor;		    /// tally of votes supporting proposal
240         uint votesAgainst;      /// tally of votes countering proposal
241     }
242     
243     // ============
244     // STATE VARIABLES:
245     // ============
246 
247     uint constant public INITIAL_POLL_NONCE = 0;
248     uint public pollNonce;
249 
250     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
251     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
252 
253     mapping(address => DLL.Data) dllMap;
254     AttributeStore.Data store;
255 
256     EIP20 public token;
257 
258     // ============
259     // CONSTRUCTOR:
260     // ============
261 
262     /**
263     @dev Initializes voteQuorum, commitDuration, revealDuration, and pollNonce in addition to token contract and trusted mapping
264     @param _tokenAddr The address where the ERC20 token contract is deployed
265     */
266     function PLCRVoting(address _tokenAddr) public {
267         token = EIP20(_tokenAddr);
268         pollNonce = INITIAL_POLL_NONCE;
269     }
270 
271     // ================
272     // TOKEN INTERFACE:
273     // ================
274 
275     /**    
276     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
277     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
278     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
279     */
280     function requestVotingRights(uint _numTokens) external {
281         require(token.balanceOf(msg.sender) >= _numTokens);
282         require(token.transferFrom(msg.sender, this, _numTokens));
283         voteTokenBalance[msg.sender] += _numTokens;
284         VotingRightsGranted(msg.sender, _numTokens);
285     }
286 
287     /**
288     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
289     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
290     */
291     function withdrawVotingRights(uint _numTokens) external {
292         uint availableTokens = voteTokenBalance[msg.sender] - getLockedTokens(msg.sender);
293         require(availableTokens >= _numTokens);
294         require(token.transfer(msg.sender, _numTokens));
295         voteTokenBalance[msg.sender] -= _numTokens;
296         VotingRightsWithdrawn(msg.sender, _numTokens);
297     }
298 
299     /**
300     @dev Unlocks tokens locked in unrevealed vote where poll has ended
301     @param _pollID Integer identifier associated with the target poll
302     */
303     function rescueTokens(uint _pollID) external {
304         require(pollEnded(_pollID));
305         require(!hasBeenRevealed(msg.sender, _pollID));
306 
307         dllMap[msg.sender].remove(_pollID);
308     }
309 
310     // =================
311     // VOTING INTERFACE:
312     // =================
313 
314     /**
315     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
316     @param _pollID Integer identifier associated with target poll
317     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
318     @param _numTokens The number of tokens to be committed towards the target poll
319     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens 
320     */
321     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) external {
322         require(commitPeriodActive(_pollID));
323         require(voteTokenBalance[msg.sender] >= _numTokens); // prevent user from overspending
324         require(_pollID != 0);                // prevent user from committing to zero node placeholder
325 
326         // TODO: Move all insert validation into the DLL lib
327         // Check if _prevPollID exists
328         require(_prevPollID == 0 || getCommitHash(msg.sender, _prevPollID) != 0);
329 
330         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
331 
332         // if nextPollID is equal to _pollID, _pollID is being updated,
333         nextPollID = (nextPollID == _pollID) ? dllMap[msg.sender].getNext(_pollID) : nextPollID;
334 
335         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
336         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
337 
338         bytes32 UUID = attrUUID(msg.sender, _pollID);
339 
340         store.setAttribute(UUID, "numTokens", _numTokens);
341         store.setAttribute(UUID, "commitHash", uint(_secretHash));
342 
343         VoteCommitted(msg.sender, _pollID, _numTokens);
344     }
345 
346     /**
347     @dev Compares previous and next poll's committed tokens for sorting purposes
348     @param _prevID Integer identifier associated with previous poll in sorted order
349     @param _nextID Integer identifier associated with next poll in sorted order
350     @param _voter Address of user to check DLL position for
351     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
352     @return valid Boolean indication of if the specified position maintains the sort
353     */
354     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
355         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
356         // if next is zero node, _numTokens does not need to be greater
357         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0); 
358         return prevValid && nextValid;
359     }
360 
361     /**
362     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
363     @param _pollID Integer identifier associated with target poll
364     @param _voteOption Vote choice used to generate commitHash for associated poll
365     @param _salt Secret number used to generate commitHash for associated poll
366     */
367     function revealVote(uint _pollID, uint _voteOption, uint _salt) external {
368         // Make sure the reveal period is active
369         require(revealPeriodActive(_pollID));
370         require(!hasBeenRevealed(msg.sender, _pollID));                        // prevent user from revealing multiple times
371         require(keccak256(_voteOption, _salt) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
372 
373         uint numTokens = getNumTokens(msg.sender, _pollID); 
374 
375         if (_voteOption == 1) // apply numTokens to appropriate poll choice
376             pollMap[_pollID].votesFor += numTokens;
377         else
378             pollMap[_pollID].votesAgainst += numTokens;
379         
380         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
381 
382         VoteRevealed(msg.sender, _pollID, numTokens, _voteOption);
383     }
384 
385     /**
386     @param _pollID Integer identifier associated with target poll
387     @param _salt Arbitrarily chosen integer used to generate secretHash
388     @return correctVotes Number of tokens voted for winning option
389     */
390     function getNumPassingTokens(address _voter, uint _pollID, uint _salt) public constant returns (uint correctVotes) {
391         require(pollEnded(_pollID));
392         require(hasBeenRevealed(_voter, _pollID));
393 
394         uint winningChoice = isPassed(_pollID) ? 1 : 0;
395         bytes32 winnerHash = keccak256(winningChoice, _salt);
396         bytes32 commitHash = getCommitHash(_voter, _pollID);
397 
398         require(winnerHash == commitHash);
399 
400         return getNumTokens(_voter, _pollID);
401     }
402 
403     // ==================
404     // POLLING INTERFACE:
405     // ================== 
406 
407     /**
408     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
409     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
410     @param _commitDuration Length of desired commit period in seconds
411     @param _revealDuration Length of desired reveal period in seconds
412     */
413     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
414         pollNonce = pollNonce + 1;
415 
416         pollMap[pollNonce] = Poll({
417             voteQuorum: _voteQuorum,
418             commitEndDate: block.timestamp + _commitDuration,
419             revealEndDate: block.timestamp + _commitDuration + _revealDuration,
420             votesFor: 0,
421             votesAgainst: 0
422         });
423 
424         PollCreated(_voteQuorum, _commitDuration, _revealDuration, pollNonce);
425         return pollNonce;
426     }
427  
428     /**
429     @notice Determines if proposal has passed
430     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
431     @param _pollID Integer identifier associated with target poll
432     */
433     function isPassed(uint _pollID) constant public returns (bool passed) {
434         require(pollEnded(_pollID));
435 
436         Poll memory poll = pollMap[_pollID];
437         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
438     }
439 
440     // ----------------
441     // POLLING HELPERS:
442     // ----------------
443 
444     /**
445     @dev Gets the total winning votes for reward distribution purposes
446     @param _pollID Integer identifier associated with target poll
447     @return Total number of votes committed to the winning option for specified poll
448     */
449     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
450         require(pollEnded(_pollID));
451 
452         if (isPassed(_pollID))
453             return pollMap[_pollID].votesFor;
454         else
455             return pollMap[_pollID].votesAgainst;
456     }
457 
458     /**
459     @notice Determines if poll is over
460     @dev Checks isExpired for specified poll's revealEndDate
461     @return Boolean indication of whether polling period is over
462     */
463     function pollEnded(uint _pollID) constant public returns (bool ended) {
464         require(pollExists(_pollID));
465 
466         return isExpired(pollMap[_pollID].revealEndDate);
467     }
468 
469     /**
470     @notice Checks if the commit period is still active for the specified poll
471     @dev Checks isExpired for the specified poll's commitEndDate
472     @param _pollID Integer identifier associated with target poll
473     @return Boolean indication of isCommitPeriodActive for target poll
474     */
475     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
476         require(pollExists(_pollID));
477 
478         return !isExpired(pollMap[_pollID].commitEndDate);
479     }
480 
481     /**
482     @notice Checks if the reveal period is still active for the specified poll
483     @dev Checks isExpired for the specified poll's revealEndDate
484     @param _pollID Integer identifier associated with target poll
485     */
486     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
487         require(pollExists(_pollID));
488 
489         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
490     }
491 
492     /**
493     @dev Checks if user has already revealed for specified poll
494     @param _voter Address of user to check against
495     @param _pollID Integer identifier associated with target poll
496     @return Boolean indication of whether user has already revealed
497     */
498     function hasBeenRevealed(address _voter, uint _pollID) constant public returns (bool revealed) {
499         require(pollExists(_pollID));
500 
501         return !dllMap[_voter].contains(_pollID);
502     }
503 
504     /**
505     @dev Checks if a poll exists, throws if the provided poll is in an impossible state
506     @param _pollID The pollID whose existance is to be evaluated.
507     @return Boolean Indicates whether a poll exists for the provided pollID
508     */
509     function pollExists(uint _pollID) constant public returns (bool exists) {
510         uint commitEndDate = pollMap[_pollID].commitEndDate;
511         uint revealEndDate = pollMap[_pollID].revealEndDate;
512 
513         assert(!(commitEndDate == 0 && revealEndDate != 0));
514         assert(!(commitEndDate != 0 && revealEndDate == 0));
515 
516         if(commitEndDate == 0 || revealEndDate == 0) { return false; }
517         return true;
518     }
519 
520     // ---------------------------
521     // DOUBLE-LINKED-LIST HELPERS:
522     // ---------------------------
523 
524     /**
525     @dev Gets the bytes32 commitHash property of target poll
526     @param _voter Address of user to check against
527     @param _pollID Integer identifier associated with target poll
528     @return Bytes32 hash property attached to target poll 
529     */
530     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) { 
531         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));    
532     } 
533 
534     /**
535     @dev Wrapper for getAttribute with attrName="numTokens"
536     @param _voter Address of user to check against
537     @param _pollID Integer identifier associated with target poll
538     @return Number of tokens committed to poll in sorted poll-linked-list
539     */
540     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
541         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
542     }
543 
544     /**
545     @dev Gets top element of sorted poll-linked-list
546     @param _voter Address of user to check against
547     @return Integer identifier to poll with maximum number of tokens committed to it
548     */
549     function getLastNode(address _voter) constant public returns (uint pollID) {
550         return dllMap[_voter].getPrev(0);
551     }
552 
553     /**
554     @dev Gets the numTokens property of getLastNode
555     @param _voter Address of user to check against
556     @return Maximum number of tokens committed in poll specified 
557     */
558     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
559         return getNumTokens(_voter, getLastNode(_voter));
560     }
561 
562     /**
563     @dev Gets the prevNode a new node should be inserted after given the sort factor
564     @param _voter The voter whose DLL will be searched
565     @param _numTokens The value for the numTokens attribute in the node to be inserted
566     @return the node which the propoded node should be inserted after
567     */
568     function getInsertPointForNumTokens(address _voter, uint _numTokens)
569     constant public returns (uint prevNode) {
570       uint nodeID = getLastNode(_voter);
571       uint tokensInNode = getNumTokens(_voter, nodeID);
572 
573       while(tokensInNode != 0) {
574         tokensInNode = getNumTokens(_voter, nodeID);
575         if(tokensInNode < _numTokens) {
576           return nodeID;
577         }
578         nodeID = dllMap[_voter].getPrev(nodeID);
579       }
580 
581       return nodeID;
582     }
583  
584     // ----------------
585     // GENERAL HELPERS:
586     // ----------------
587 
588     /**
589     @dev Checks if an expiration date has been reached
590     @param _terminationDate Integer timestamp of date to compare current timestamp with
591     @return expired Boolean indication of whether the terminationDate has passed
592     */
593     function isExpired(uint _terminationDate) constant public returns (bool expired) {
594         return (block.timestamp > _terminationDate);
595     }
596 
597     /**
598     @dev Generates an identifier which associates a user and a poll together
599     @param _pollID Integer identifier associated with target poll
600     @return UUID Hash which is deterministic from _user and _pollID
601     */
602     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
603         return keccak256(_user, _pollID);
604     }
605 }
606 
607 contract Parameterizer {
608 
609   // ------
610   // EVENTS
611   // ------
612 
613   event _ReparameterizationProposal(address proposer, string name, uint value, bytes32 propID);
614   event _NewChallenge(address challenger, bytes32 propID, uint pollID);
615 
616 
617   // ------
618   // DATA STRUCTURES
619   // ------
620 
621   struct ParamProposal {
622     uint appExpiry;
623     uint challengeID;
624     uint deposit;
625     string name;
626     address owner;
627     uint processBy;
628     uint value;
629   }
630 
631   struct Challenge {
632     uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
633     address challenger;     // owner of Challenge
634     bool resolved;          // indication of if challenge is resolved
635     uint stake;             // number of tokens at risk for either party during challenge
636     uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
637     mapping(address => bool) tokenClaims;
638   }
639 
640   // ------
641   // STATE
642   // ------
643 
644   mapping(bytes32 => uint) public params;
645 
646   // maps challengeIDs to associated challenge data
647   mapping(uint => Challenge) public challenges;
648  
649   // maps pollIDs to intended data change if poll passes
650   mapping(bytes32 => ParamProposal) public proposals; 
651 
652   // Global Variables
653   EIP20 public token;
654   PLCRVoting public voting;
655   uint public PROCESSBY = 604800; // 7 days
656 
657   // ------------
658   // CONSTRUCTOR
659   // ------------
660 
661   /**
662   @dev constructor
663   @param _tokenAddr        address of the token which parameterizes this system
664   @param _plcrAddr         address of a PLCR voting contract for the provided token
665   @param _minDeposit       minimum deposit for listing to be whitelisted  
666   @param _pMinDeposit      minimum deposit to propose a reparameterization
667   @param _applyStageLen    period over which applicants wait to be whitelisted
668   @param _pApplyStageLen   period over which reparmeterization proposals wait to be processed 
669   @param _dispensationPct  percentage of losing party's deposit distributed to winning party
670   @param _pDispensationPct percentage of losing party's deposit distributed to winning party in parameterizer
671   @param _commitStageLen  length of commit period for voting
672   @param _pCommitStageLen length of commit period for voting in parameterizer
673   @param _revealStageLen  length of reveal period for voting
674   @param _pRevealStageLen length of reveal period for voting in parameterizer
675   @param _voteQuorum       type of majority out of 100 necessary for vote success
676   @param _pVoteQuorum      type of majority out of 100 necessary for vote success in parameterizer
677   */
678   function Parameterizer( 
679     address _tokenAddr,
680     address _plcrAddr,
681     uint _minDeposit,
682     uint _pMinDeposit,
683     uint _applyStageLen,
684     uint _pApplyStageLen,
685     uint _commitStageLen,
686     uint _pCommitStageLen,
687     uint _revealStageLen,
688     uint _pRevealStageLen,
689     uint _dispensationPct,
690     uint _pDispensationPct,
691     uint _voteQuorum,
692     uint _pVoteQuorum
693     ) public {
694       token = EIP20(_tokenAddr);
695       voting = PLCRVoting(_plcrAddr);
696 
697       set("minDeposit", _minDeposit);
698       set("pMinDeposit", _pMinDeposit);
699       set("applyStageLen", _applyStageLen);
700       set("pApplyStageLen", _pApplyStageLen);
701       set("commitStageLen", _commitStageLen);
702       set("pCommitStageLen", _pCommitStageLen);
703       set("revealStageLen", _revealStageLen);
704       set("pRevealStageLen", _pRevealStageLen);
705       set("dispensationPct", _dispensationPct);
706       set("pDispensationPct", _pDispensationPct);
707       set("voteQuorum", _voteQuorum);
708       set("pVoteQuorum", _pVoteQuorum);
709   }
710 
711   // -----------------------
712   // TOKEN HOLDER INTERFACE
713   // -----------------------
714 
715   /**
716   @notice propose a reparamaterization of the key _name's value to _value.
717   @param _name the name of the proposed param to be set
718   @param _value the proposed value to set the param to be set
719   */
720   function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
721     uint deposit = get("pMinDeposit");
722     bytes32 propID = keccak256(_name, _value);
723 
724     require(!propExists(propID)); // Forbid duplicate proposals
725     require(get(_name) != _value); // Forbid NOOP reparameterizations
726     require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
727 
728     // attach name and value to pollID    
729     proposals[propID] = ParamProposal({
730       appExpiry: now + get("pApplyStageLen"),
731       challengeID: 0,
732       deposit: deposit,
733       name: _name,
734       owner: msg.sender,
735       processBy: now + get("pApplyStageLen") + get("pCommitStageLen") +
736         get("pRevealStageLen") + PROCESSBY,
737       value: _value
738     });
739 
740     _ReparameterizationProposal(msg.sender, _name, _value, propID);
741     return propID;
742   }
743 
744   /**
745   @notice challenge the provided proposal ID, and put tokens at stake to do so.
746   @param _propID the proposal ID to challenge
747   */
748   function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
749     ParamProposal memory prop = proposals[_propID];
750     uint deposit = get("pMinDeposit");
751 
752     require(propExists(_propID) && prop.challengeID == 0); 
753 
754     //take tokens from challenger
755     require(token.transferFrom(msg.sender, this, deposit));
756     //start poll
757     uint pollID = voting.startPoll(
758       get("pVoteQuorum"),
759       get("pCommitStageLen"),
760       get("pRevealStageLen")
761     );
762 
763     challenges[pollID] = Challenge({
764       challenger: msg.sender,
765       rewardPool: ((100 - get("pDispensationPct")) * deposit) / 100, 
766       stake: deposit,
767       resolved: false,
768       winningTokens: 0
769     });
770 
771     proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
772 
773     _NewChallenge(msg.sender, _propID, pollID);
774     return pollID;
775   }
776 
777   /**
778   @notice for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
779   @param _propID the proposal ID to make a determination and state transition for
780   */
781   function processProposal(bytes32 _propID) public {
782     ParamProposal storage prop = proposals[_propID];
783 
784     if (canBeSet(_propID)) {
785       set(prop.name, prop.value);
786     } else if (challengeCanBeResolved(_propID)) {
787       resolveChallenge(_propID);
788     } else if (now > prop.processBy) {
789       require(token.transfer(prop.owner, prop.deposit));
790     } else {
791       revert();
792     }
793 
794     delete proposals[_propID];
795   }
796 
797   /**
798   @notice claim the tokens owed for the msg.sender in the provided challenge
799   @param _challengeID the challenge ID to claim tokens for
800   @param _salt the salt used to vote in the challenge being withdrawn for
801   */
802   function claimReward(uint _challengeID, uint _salt) public {
803     // ensure voter has not already claimed tokens and challenge results have been processed
804     require(challenges[_challengeID].tokenClaims[msg.sender] == false);
805     require(challenges[_challengeID].resolved == true);
806 
807     uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
808     uint reward = voterReward(msg.sender, _challengeID, _salt);
809 
810     // subtract voter's information to preserve the participation ratios of other voters
811     // compared to the remaining pool of rewards
812     challenges[_challengeID].winningTokens -= voterTokens;
813     challenges[_challengeID].rewardPool -= reward;
814 
815     require(token.transfer(msg.sender, reward));
816     
817     // ensures a voter cannot claim tokens again
818     challenges[_challengeID].tokenClaims[msg.sender] = true;
819   }
820 
821   // --------
822   // GETTERS
823   // --------
824 
825   /**
826   @dev                Calculates the provided voter's token reward for the given poll.
827   @param _voter       The address of the voter whose reward balance is to be returned
828   @param _challengeID The ID of the challenge the voter's reward is being calculated for
829   @param _salt        The salt of the voter's commit hash in the given poll
830   @return             The uint indicating the voter's reward
831   */
832   function voterReward(address _voter, uint _challengeID, uint _salt)
833   public view returns (uint) {
834     uint winningTokens = challenges[_challengeID].winningTokens;
835     uint rewardPool = challenges[_challengeID].rewardPool;
836     uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
837     return (voterTokens * rewardPool) / winningTokens;
838   }
839 
840   /**
841   @notice Determines whether a proposal passed its application stage without a challenge
842   @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
843   */
844   function canBeSet(bytes32 _propID) view public returns (bool) {
845     ParamProposal memory prop = proposals[_propID];
846 
847     return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
848   }
849 
850   /**
851   @notice Determines whether a proposal exists for the provided proposal ID
852   @param _propID The proposal ID whose existance is to be determined
853   */
854   function propExists(bytes32 _propID) view public returns (bool) {
855     return proposals[_propID].processBy > 0;
856   }
857 
858   /**
859   @notice Determines whether the provided proposal ID has a challenge which can be resolved
860   @param _propID The proposal ID whose challenge to inspect
861   */
862   function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
863     ParamProposal memory prop = proposals[_propID];
864     Challenge memory challenge = challenges[prop.challengeID];
865 
866     return (prop.challengeID > 0 && challenge.resolved == false &&
867             voting.pollEnded(prop.challengeID));
868   }
869 
870   /**
871   @notice Determines the number of tokens to awarded to the winning party in a challenge
872   @param _challengeID The challengeID to determine a reward for
873   */
874   function challengeWinnerReward(uint _challengeID) public view returns (uint) {
875     if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
876       // Edge case, nobody voted, give all tokens to the winner.
877       return 2 * challenges[_challengeID].stake;
878     }
879     
880     return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
881   }
882 
883   /**
884   @notice gets the parameter keyed by the provided name value from the params mapping
885   @param _name the key whose value is to be determined
886   */
887   function get(string _name) public view returns (uint value) {
888     return params[keccak256(_name)];
889   }
890 
891   // ----------------
892   // PRIVATE FUNCTIONS
893   // ----------------
894 
895   /**
896   @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
897   @param _propID the proposal ID whose challenge is to be resolved.
898   */
899   function resolveChallenge(bytes32 _propID) private {
900     ParamProposal memory prop = proposals[_propID];
901     Challenge storage challenge = challenges[prop.challengeID];
902 
903     // winner gets back their full staked deposit, and dispensationPct*loser's stake
904     uint reward = challengeWinnerReward(prop.challengeID);
905 
906     if (voting.isPassed(prop.challengeID)) { // The challenge failed
907       if(prop.processBy > now) {
908         set(prop.name, prop.value);
909       }
910       require(token.transfer(prop.owner, reward));
911     } 
912     else { // The challenge succeeded
913       require(token.transfer(challenges[prop.challengeID].challenger, reward));
914     }
915 
916     challenge.winningTokens =
917       voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
918     challenge.resolved = true;
919   }
920 
921   /**
922   @dev sets the param keted by the provided name to the provided value
923   @param _name the name of the param to be set
924   @param _value the value to set the param to be set
925   */
926   function set(string _name, uint _value) private {
927     params[keccak256(_name)] = _value;
928   }
929 }
930 contract Registry {
931 
932     // ------
933     // EVENTS
934     // ------
935 
936     event _Application(bytes32 listingHash, uint deposit, string data);
937     event _Challenge(bytes32 listingHash, uint deposit, uint pollID, string data);
938     event _Deposit(bytes32 listingHash, uint added, uint newTotal);
939     event _Withdrawal(bytes32 listingHash, uint withdrew, uint newTotal);
940     event _NewListingWhitelisted(bytes32 listingHash);
941     event _ApplicationRemoved(bytes32 listingHash);
942     event _ListingRemoved(bytes32 listingHash);
943     event _ChallengeFailed(uint challengeID);
944     event _ChallengeSucceeded(uint challengeID);
945     event _RewardClaimed(address voter, uint challengeID, uint reward);
946 
947     struct Listing {
948         uint applicationExpiry; // Expiration date of apply stage
949         bool whitelisted;       // Indicates registry status
950         address owner;          // Owner of Listing
951         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
952         uint challengeID;       // Corresponds to a PollID in PLCRVoting
953     }
954 
955     struct Challenge {
956         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
957         address challenger;     // Owner of Challenge
958         bool resolved;          // Indication of if challenge is resolved
959         uint stake;             // Number of tokens at stake for either party during challenge
960         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
961         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
962     }
963 
964     // Maps challengeIDs to associated challenge data
965     mapping(uint => Challenge) public challenges;
966 
967     // Maps listingHashes to associated listingHash data
968     mapping(bytes32 => Listing) public listings;
969 
970     // Global Variables
971     EIP20 public token;
972     PLCRVoting public voting;
973     Parameterizer public parameterizer;
974     string public version = '1';
975 
976     // ------------
977     // CONSTRUCTOR:
978     // ------------
979 
980     /**
981     @dev Contructor         Sets the addresses for token, voting, and parameterizer
982     @param _tokenAddr       Address of the TCR's intrinsic ERC20 token
983     @param _plcrAddr        Address of a PLCR voting contract for the provided token
984     @param _paramsAddr      Address of a Parameterizer contract 
985     */
986     function Registry(
987         address _tokenAddr,
988         address _plcrAddr,
989         address _paramsAddr
990     ) public {
991         token = EIP20(_tokenAddr);
992         voting = PLCRVoting(_plcrAddr);
993         parameterizer = Parameterizer(_paramsAddr);
994     }
995 
996     // --------------------
997     // PUBLISHER INTERFACE:
998     // --------------------
999 
1000     /**
1001     @dev                Allows a user to start an application. Takes tokens from user and sets
1002                         apply stage end time.
1003     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1004     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1005     @param _data        Extra data relevant to the application. Think IPFS hashes.
1006     */
1007     function apply(bytes32 _listingHash, uint _amount, string _data) external {
1008         require(!isWhitelisted(_listingHash));
1009         require(!appWasMade(_listingHash));
1010         require(_amount >= parameterizer.get("minDeposit"));
1011 
1012         // Sets owner
1013         Listing storage listingHash = listings[_listingHash];
1014         listingHash.owner = msg.sender;
1015 
1016         // Transfers tokens from user to Registry contract
1017         require(token.transferFrom(listingHash.owner, this, _amount));
1018 
1019         // Sets apply stage end time
1020         listingHash.applicationExpiry = block.timestamp + parameterizer.get("applyStageLen");
1021         listingHash.unstakedDeposit = _amount;
1022 
1023         _Application(_listingHash, _amount, _data);
1024     }
1025 
1026     /**
1027     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1028     @param _listingHash A listingHash msg.sender is the owner of
1029     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1030     */
1031     function deposit(bytes32 _listingHash, uint _amount) external {
1032         Listing storage listingHash = listings[_listingHash];
1033 
1034         require(listingHash.owner == msg.sender);
1035         require(token.transferFrom(msg.sender, this, _amount));
1036 
1037         listingHash.unstakedDeposit += _amount;
1038 
1039         _Deposit(_listingHash, _amount, listingHash.unstakedDeposit);
1040     }
1041 
1042     /**
1043     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1044     @param _listingHash A listingHash msg.sender is the owner of.
1045     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1046     */
1047     function withdraw(bytes32 _listingHash, uint _amount) external {
1048         Listing storage listingHash = listings[_listingHash];
1049 
1050         require(listingHash.owner == msg.sender);
1051         require(_amount <= listingHash.unstakedDeposit);
1052         require(listingHash.unstakedDeposit - _amount >= parameterizer.get("minDeposit"));
1053 
1054         require(token.transfer(msg.sender, _amount));
1055 
1056         listingHash.unstakedDeposit -= _amount;
1057 
1058         _Withdrawal(_listingHash, _amount, listingHash.unstakedDeposit);
1059     }
1060 
1061     /**
1062     @dev                Allows the owner of a listingHash to remove the listingHash from the whitelist
1063                         Returns all tokens to the owner of the listingHash
1064     @param _listingHash A listingHash msg.sender is the owner of.
1065     */
1066     function exit(bytes32 _listingHash) external {
1067         Listing storage listingHash = listings[_listingHash];
1068 
1069         require(msg.sender == listingHash.owner);
1070         require(isWhitelisted(_listingHash));
1071 
1072         // Cannot exit during ongoing challenge
1073         require(listingHash.challengeID == 0 || challenges[listingHash.challengeID].resolved);
1074 
1075         // Remove listingHash & return tokens
1076         resetListing(_listingHash);
1077     }
1078 
1079     // -----------------------
1080     // TOKEN HOLDER INTERFACE:
1081     // -----------------------
1082 
1083     /**
1084     @dev                Starts a poll for a listingHash which is either in the apply stage or
1085                         already in the whitelist. Tokens are taken from the challenger and the
1086                         applicant's deposits are locked.
1087     @param _listingHash The listingHash being challenged, whether listed or in application
1088     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1089     */
1090     function challenge(bytes32 _listingHash, string _data) external returns (uint challengeID) {
1091         bytes32 listingHashHash = _listingHash;
1092         Listing storage listingHash = listings[listingHashHash];
1093         uint deposit = parameterizer.get("minDeposit");
1094 
1095         // Listing must be in apply stage or already on the whitelist
1096         require(appWasMade(_listingHash) || listingHash.whitelisted);
1097         // Prevent multiple challenges
1098         require(listingHash.challengeID == 0 || challenges[listingHash.challengeID].resolved);
1099 
1100         if (listingHash.unstakedDeposit < deposit) {
1101             // Not enough tokens, listingHash auto-delisted
1102             resetListing(_listingHash);
1103             return 0;
1104         }
1105 
1106         // Takes tokens from challenger
1107         require(token.transferFrom(msg.sender, this, deposit));
1108 
1109         // Starts poll
1110         uint pollID = voting.startPoll(
1111             parameterizer.get("voteQuorum"),
1112             parameterizer.get("commitStageLen"),
1113             parameterizer.get("revealStageLen")
1114         );
1115 
1116         challenges[pollID] = Challenge({
1117             challenger: msg.sender,
1118             rewardPool: ((100 - parameterizer.get("dispensationPct")) * deposit) / 100,
1119             stake: deposit,
1120             resolved: false,
1121             totalTokens: 0
1122         });
1123 
1124         // Updates listingHash to store most recent challenge
1125         listings[listingHashHash].challengeID = pollID;
1126 
1127         // Locks tokens for listingHash during challenge
1128         listings[listingHashHash].unstakedDeposit -= deposit;
1129 
1130         _Challenge(_listingHash, deposit, pollID, _data);
1131         return pollID;
1132     }
1133 
1134     /**
1135     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1136                         a challenge if one exists.
1137     @param _listingHash The listingHash whose status is being updated
1138     */
1139     function updateStatus(bytes32 _listingHash) public {
1140         if (canBeWhitelisted(_listingHash)) {
1141           whitelistApplication(_listingHash);
1142           _NewListingWhitelisted(_listingHash);
1143         } else if (challengeCanBeResolved(_listingHash)) {
1144           resolveChallenge(_listingHash);
1145         } else {
1146           revert();
1147         }
1148     }
1149 
1150     // ----------------
1151     // TOKEN FUNCTIONS:
1152     // ----------------
1153 
1154     /**
1155     @dev                Called by a voter to claim their reward for each completed vote. Someone
1156                         must call updateStatus() before this can be called.
1157     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1158     @param _salt        The salt of a voter's commit hash in the given poll
1159     */
1160     function claimReward(uint _challengeID, uint _salt) public {
1161         // Ensures the voter has not already claimed tokens and challenge results have been processed
1162         require(challenges[_challengeID].tokenClaims[msg.sender] == false);
1163         require(challenges[_challengeID].resolved == true);
1164 
1165         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID, _salt);
1166         uint reward = voterReward(msg.sender, _challengeID, _salt);
1167 
1168         // Subtracts the voter's information to preserve the participation ratios
1169         // of other voters compared to the remaining pool of rewards
1170         challenges[_challengeID].totalTokens -= voterTokens;
1171         challenges[_challengeID].rewardPool -= reward;
1172 
1173         require(token.transfer(msg.sender, reward));
1174 
1175         // Ensures a voter cannot claim tokens again
1176         challenges[_challengeID].tokenClaims[msg.sender] = true;
1177 
1178         _RewardClaimed(msg.sender, _challengeID, reward);
1179     }
1180 
1181     // --------
1182     // GETTERS:
1183     // --------
1184 
1185     /**
1186     @dev                Calculates the provided voter's token reward for the given poll.
1187     @param _voter       The address of the voter whose reward balance is to be returned
1188     @param _challengeID The pollID of the challenge a reward balance is being queried for
1189     @param _salt        The salt of the voter's commit hash in the given poll
1190     @return             The uint indicating the voter's reward
1191     */
1192     function voterReward(address _voter, uint _challengeID, uint _salt)
1193     public view returns (uint) {
1194         uint totalTokens = challenges[_challengeID].totalTokens;
1195         uint rewardPool = challenges[_challengeID].rewardPool;
1196         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID, _salt);
1197         return (voterTokens * rewardPool) / totalTokens;
1198     }
1199 
1200     /**
1201     @dev                Determines whether the given listingHash be whitelisted.
1202     @param _listingHash The listingHash whose status is to be examined
1203     */
1204     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1205         bytes32 listingHashHash = _listingHash;
1206         uint challengeID = listings[listingHashHash].challengeID;
1207 
1208         // Ensures that the application was made,
1209         // the application period has ended,
1210         // the listingHash can be whitelisted,
1211         // and either: the challengeID == 0, or the challenge has been resolved.
1212         if (
1213             appWasMade(_listingHash) &&
1214             listings[listingHashHash].applicationExpiry < now &&
1215             !isWhitelisted(_listingHash) &&
1216             (challengeID == 0 || challenges[challengeID].resolved == true)
1217         ) { return true; }
1218 
1219         return false;
1220     }
1221 
1222     /**
1223     @dev                Returns true if the provided listingHash is whitelisted
1224     @param _listingHash The listingHash whose status is to be examined
1225     */
1226     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1227         return listings[_listingHash].whitelisted;
1228     }
1229 
1230     /**
1231     @dev                Returns true if apply was called for this listingHash
1232     @param _listingHash The listingHash whose status is to be examined
1233     */
1234     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1235         return listings[_listingHash].applicationExpiry > 0;
1236     }
1237 
1238     /**
1239     @dev                Returns true if the application/listingHash has an unresolved challenge
1240     @param _listingHash The listingHash whose status is to be examined
1241     */
1242     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1243         bytes32 listingHashHash = _listingHash;
1244         uint challengeID = listings[listingHashHash].challengeID;
1245 
1246         return (listings[listingHashHash].challengeID > 0 && !challenges[challengeID].resolved);
1247     }
1248 
1249     /**
1250     @dev                Determines whether voting has concluded in a challenge for a given
1251                         listingHash. Throws if no challenge exists.
1252     @param _listingHash A listingHash with an unresolved challenge
1253     */
1254     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1255         bytes32 listingHashHash = _listingHash;
1256         uint challengeID = listings[listingHashHash].challengeID;
1257 
1258         require(challengeExists(_listingHash));
1259 
1260         return voting.pollEnded(challengeID);
1261     }
1262 
1263     /**
1264     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1265     @param _challengeID The challengeID to determine a reward for
1266     */
1267     function determineReward(uint _challengeID) public view returns (uint) {
1268         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1269 
1270         // Edge case, nobody voted, give all tokens to the challenger.
1271         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1272             return 2 * challenges[_challengeID].stake;
1273         }
1274 
1275         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1276     }
1277 
1278     /**
1279     @dev                Getter for Challenge tokenClaims mappings
1280     @param _challengeID The challengeID to query
1281     @param _voter       The voter whose claim status to query for the provided challengeID
1282     */
1283     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1284       return challenges[_challengeID].tokenClaims[_voter];
1285     }
1286 
1287     // ----------------
1288     // PRIVATE FUNCTIONS:
1289     // ----------------
1290 
1291     /**
1292     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1293                         either whitelists or de-whitelists the listingHash.
1294     @param _listingHash A listingHash with a challenge that is to be resolved
1295     */
1296     function resolveChallenge(bytes32 _listingHash) private {
1297         bytes32 listingHashHash = _listingHash;
1298         uint challengeID = listings[listingHashHash].challengeID;
1299 
1300         // Calculates the winner's reward,
1301         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1302         uint reward = determineReward(challengeID);
1303 
1304         // Records whether the listingHash is a listingHash or an application
1305         bool wasWhitelisted = isWhitelisted(_listingHash);
1306 
1307         // Case: challenge failed
1308         if (voting.isPassed(challengeID)) {
1309             whitelistApplication(_listingHash);
1310             // Unlock stake so that it can be retrieved by the applicant
1311             listings[listingHashHash].unstakedDeposit += reward;
1312 
1313             _ChallengeFailed(challengeID);
1314             if (!wasWhitelisted) { _NewListingWhitelisted(_listingHash); }
1315         }
1316         // Case: challenge succeeded
1317         else {
1318             resetListing(_listingHash);
1319             // Transfer the reward to the challenger
1320             require(token.transfer(challenges[challengeID].challenger, reward));
1321 
1322             _ChallengeSucceeded(challengeID);
1323             if (wasWhitelisted) { _ListingRemoved(_listingHash); }
1324             else { _ApplicationRemoved(_listingHash); }
1325         }
1326 
1327         // Sets flag on challenge being processed
1328         challenges[challengeID].resolved = true;
1329 
1330         // Stores the total tokens used for voting by the winning side for reward purposes
1331         challenges[challengeID].totalTokens =
1332             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1333     }
1334 
1335     /**
1336     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1337                         challenge being made. Called by resolveChallenge() if an
1338                         application/listing beat a challenge.
1339     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1340     */
1341     function whitelistApplication(bytes32 _listingHash) private {
1342         listings[_listingHash].whitelisted = true;
1343     }
1344 
1345     /**
1346     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
1347     @param _listingHash The listing hash to delete
1348     */
1349     function resetListing(bytes32 _listingHash) private {
1350         bytes32 listingHashHash = _listingHash;
1351         Listing storage listingHash = listings[listingHashHash];
1352 
1353         // Transfers any remaining balance back to the owner
1354         if (listingHash.unstakedDeposit > 0)
1355             require(token.transfer(listingHash.owner, listingHash.unstakedDeposit));
1356 
1357         delete listings[listingHashHash];
1358     }
1359 }