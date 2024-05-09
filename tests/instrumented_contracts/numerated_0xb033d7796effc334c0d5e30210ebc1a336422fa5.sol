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