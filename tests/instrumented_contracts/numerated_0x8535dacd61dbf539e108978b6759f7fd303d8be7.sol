1 
2 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
3 
4 pragma solidity ^0.5.2;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      * @notice Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 // File: contracts/Reputation.sol
79 
80 pragma solidity ^0.5.4;
81 
82 
83 
84 /**
85  * @title Reputation system
86  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
87  * A reputation is use to assign influence measure to a DAO'S peers.
88  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
89  * The Reputation contract maintain a map of address to reputation value.
90  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
91  */
92 
93 contract Reputation is Ownable {
94 
95     uint8 public decimals = 18;             //Number of decimals of the smallest unit
96     // Event indicating minting of reputation to an address.
97     event Mint(address indexed _to, uint256 _amount);
98     // Event indicating burning of reputation for an address.
99     event Burn(address indexed _from, uint256 _amount);
100 
101       /// @dev `Checkpoint` is the structure that attaches a block number to a
102       ///  given value, the block number attached is the one that last changed the
103       ///  value
104     struct Checkpoint {
105 
106     // `fromBlock` is the block number that the value was generated from
107         uint128 fromBlock;
108 
109           // `value` is the amount of reputation at a specific block number
110         uint128 value;
111     }
112 
113       // `balances` is the map that tracks the balance of each address, in this
114       //  contract when the balance changes the block number that the change
115       //  occurred is also included in the map
116     mapping (address => Checkpoint[]) balances;
117 
118       // Tracks the history of the `totalSupply` of the reputation
119     Checkpoint[] totalSupplyHistory;
120 
121     /// @notice Constructor to create a Reputation
122     constructor(
123     ) public
124     {
125     }
126 
127     /// @dev This function makes it easy to get the total number of reputation
128     /// @return The total number of reputation
129     function totalSupply() public view returns (uint256) {
130         return totalSupplyAt(block.number);
131     }
132 
133   ////////////////
134   // Query balance and totalSupply in History
135   ////////////////
136     /**
137     * @dev return the reputation amount of a given owner
138     * @param _owner an address of the owner which we want to get his reputation
139     */
140     function balanceOf(address _owner) public view returns (uint256 balance) {
141         return balanceOfAt(_owner, block.number);
142     }
143 
144       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
145       /// @param _owner The address from which the balance will be retrieved
146       /// @param _blockNumber The block number when the balance is queried
147       /// @return The balance at `_blockNumber`
148     function balanceOfAt(address _owner, uint256 _blockNumber)
149     public view returns (uint256)
150     {
151         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
152             return 0;
153           // This will return the expected balance during normal situations
154         } else {
155             return getValueAt(balances[_owner], _blockNumber);
156         }
157     }
158 
159       /// @notice Total amount of reputation at a specific `_blockNumber`.
160       /// @param _blockNumber The block number when the totalSupply is queried
161       /// @return The total amount of reputation at `_blockNumber`
162     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
163         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
164             return 0;
165           // This will return the expected totalSupply during normal situations
166         } else {
167             return getValueAt(totalSupplyHistory, _blockNumber);
168         }
169     }
170 
171       /// @notice Generates `_amount` reputation that are assigned to `_owner`
172       /// @param _user The address that will be assigned the new reputation
173       /// @param _amount The quantity of reputation generated
174       /// @return True if the reputation are generated correctly
175     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
176         uint256 curTotalSupply = totalSupply();
177         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
178         uint256 previousBalanceTo = balanceOf(_user);
179         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
180         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
181         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
182         emit Mint(_user, _amount);
183         return true;
184     }
185 
186       /// @notice Burns `_amount` reputation from `_owner`
187       /// @param _user The address that will lose the reputation
188       /// @param _amount The quantity of reputation to burn
189       /// @return True if the reputation are burned correctly
190     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
191         uint256 curTotalSupply = totalSupply();
192         uint256 amountBurned = _amount;
193         uint256 previousBalanceFrom = balanceOf(_user);
194         if (previousBalanceFrom < amountBurned) {
195             amountBurned = previousBalanceFrom;
196         }
197         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
198         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
199         emit Burn(_user, amountBurned);
200         return true;
201     }
202 
203   ////////////////
204   // Internal helper functions to query and set a value in a snapshot array
205   ////////////////
206 
207       /// @dev `getValueAt` retrieves the number of reputation at a given block number
208       /// @param checkpoints The history of values being queried
209       /// @param _block The block number to retrieve the value at
210       /// @return The number of reputation being queried
211     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
212         if (checkpoints.length == 0) {
213             return 0;
214         }
215 
216           // Shortcut for the actual value
217         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
218             return checkpoints[checkpoints.length-1].value;
219         }
220         if (_block < checkpoints[0].fromBlock) {
221             return 0;
222         }
223 
224           // Binary search of the value in the array
225         uint256 min = 0;
226         uint256 max = checkpoints.length-1;
227         while (max > min) {
228             uint256 mid = (max + min + 1) / 2;
229             if (checkpoints[mid].fromBlock<=_block) {
230                 min = mid;
231             } else {
232                 max = mid-1;
233             }
234         }
235         return checkpoints[min].value;
236     }
237 
238       /// @dev `updateValueAtNow` used to update the `balances` map and the
239       ///  `totalSupplyHistory`
240       /// @param checkpoints The history of data being updated
241       /// @param _value The new number of reputation
242     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
243         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
244         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
245             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
246             newCheckPoint.fromBlock = uint128(block.number);
247             newCheckPoint.value = uint128(_value);
248         } else {
249             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
250             oldCheckPoint.value = uint128(_value);
251         }
252     }
253 }
254 
255 // File: contracts/votingMachines/IntVoteInterface.sol
256 
257 pragma solidity ^0.5.4;
258 
259 interface IntVoteInterface {
260     //When implementing this interface please do not only override function and modifier,
261     //but also to keep the modifiers on the overridden functions.
262     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
263     modifier votable(bytes32 _proposalId) {revert(); _;}
264 
265     event NewProposal(
266         bytes32 indexed _proposalId,
267         address indexed _organization,
268         uint256 _numOfChoices,
269         address _proposer,
270         bytes32 _paramsHash
271     );
272 
273     event ExecuteProposal(bytes32 indexed _proposalId,
274         address indexed _organization,
275         uint256 _decision,
276         uint256 _totalReputation
277     );
278 
279     event VoteProposal(
280         bytes32 indexed _proposalId,
281         address indexed _organization,
282         address indexed _voter,
283         uint256 _vote,
284         uint256 _reputation
285     );
286 
287     event CancelProposal(bytes32 indexed _proposalId, address indexed _organization );
288     event CancelVoting(bytes32 indexed _proposalId, address indexed _organization, address indexed _voter);
289 
290     /**
291      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
292      * generated by calculating keccak256 of a incremented counter.
293      * @param _numOfChoices number of voting choices
294      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
295      * @param _proposer address
296      * @param _organization address - if this address is zero the msg.sender will be used as the organization address.
297      * @return proposal's id.
298      */
299     function propose(
300         uint256 _numOfChoices,
301         bytes32 _proposalParameters,
302         address _proposer,
303         address _organization
304         ) external returns(bytes32);
305 
306     function vote(
307         bytes32 _proposalId,
308         uint256 _vote,
309         uint256 _rep,
310         address _voter
311     )
312     external
313     returns(bool);
314 
315     function cancelVote(bytes32 _proposalId) external;
316 
317     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint256);
318 
319     function isVotable(bytes32 _proposalId) external view returns(bool);
320 
321     /**
322      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
323      * @param _proposalId the ID of the proposal
324      * @param _choice the index in the
325      * @return voted reputation for the given choice
326      */
327     function voteStatus(bytes32 _proposalId, uint256 _choice) external view returns(uint256);
328 
329     /**
330      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
331      * @return bool true or false
332      */
333     function isAbstainAllow() external pure returns(bool);
334 
335     /**
336      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
337      * @return min - minimum number of choices
338                max - maximum number of choices
339      */
340     function getAllowedRangeOfChoices() external pure returns(uint256 min, uint256 max);
341 }
342 
343 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
344 
345 pragma solidity ^0.5.2;
346 
347 /**
348  * @title SafeMath
349  * @dev Unsigned math operations with safety checks that revert on error
350  */
351 library SafeMath {
352     /**
353      * @dev Multiplies two unsigned integers, reverts on overflow.
354      */
355     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
356         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
357         // benefit is lost if 'b' is also tested.
358         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
359         if (a == 0) {
360             return 0;
361         }
362 
363         uint256 c = a * b;
364         require(c / a == b);
365 
366         return c;
367     }
368 
369     /**
370      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
371      */
372     function div(uint256 a, uint256 b) internal pure returns (uint256) {
373         // Solidity only automatically asserts when dividing by 0
374         require(b > 0);
375         uint256 c = a / b;
376         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
377 
378         return c;
379     }
380 
381     /**
382      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
383      */
384     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
385         require(b <= a);
386         uint256 c = a - b;
387 
388         return c;
389     }
390 
391     /**
392      * @dev Adds two unsigned integers, reverts on overflow.
393      */
394     function add(uint256 a, uint256 b) internal pure returns (uint256) {
395         uint256 c = a + b;
396         require(c >= a);
397 
398         return c;
399     }
400 
401     /**
402      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
403      * reverts when dividing by zero.
404      */
405     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
406         require(b != 0);
407         return a % b;
408     }
409 }
410 
411 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
412 
413 pragma solidity ^0.5.2;
414 
415 /**
416  * @title ERC20 interface
417  * @dev see https://eips.ethereum.org/EIPS/eip-20
418  */
419 interface IERC20 {
420     function transfer(address to, uint256 value) external returns (bool);
421 
422     function approve(address spender, uint256 value) external returns (bool);
423 
424     function transferFrom(address from, address to, uint256 value) external returns (bool);
425 
426     function totalSupply() external view returns (uint256);
427 
428     function balanceOf(address who) external view returns (uint256);
429 
430     function allowance(address owner, address spender) external view returns (uint256);
431 
432     event Transfer(address indexed from, address indexed to, uint256 value);
433 
434     event Approval(address indexed owner, address indexed spender, uint256 value);
435 }
436 
437 // File: contracts/votingMachines/VotingMachineCallbacksInterface.sol
438 
439 pragma solidity ^0.5.4;
440 
441 
442 interface VotingMachineCallbacksInterface {
443     function mintReputation(uint256 _amount, address _beneficiary, bytes32 _proposalId) external returns(bool);
444     function burnReputation(uint256 _amount, address _owner, bytes32 _proposalId) external returns(bool);
445 
446     function stakingTokenTransfer(IERC20 _stakingToken, address _beneficiary, uint256 _amount, bytes32 _proposalId)
447     external
448     returns(bool);
449 
450     function getTotalReputationSupply(bytes32 _proposalId) external view returns(uint256);
451     function reputationOf(address _owner, bytes32 _proposalId) external view returns(uint256);
452     function balanceOfStakingToken(IERC20 _stakingToken, bytes32 _proposalId) external view returns(uint256);
453 }
454 
455 // File: contracts/votingMachines/ProposalExecuteInterface.sol
456 
457 pragma solidity ^0.5.4;
458 
459 interface ProposalExecuteInterface {
460     function executeProposal(bytes32 _proposalId, int _decision) external returns(bool);
461 }
462 
463 // File: contracts/votingMachines/AbsoluteVote.sol
464 
465 pragma solidity ^0.5.4;
466 
467 
468 
469 
470 
471 
472 
473 contract AbsoluteVote is IntVoteInterface {
474     using SafeMath for uint;
475 
476     struct Parameters {
477         uint256 precReq; // how many percentages required for the proposal to be passed
478         address voteOnBehalf; //if this address is set so only this address is allowed
479                               // to vote of behalf of someone else.
480     }
481 
482     struct Voter {
483         uint256 vote; // 0 - 'abstain'
484         uint256 reputation; // amount of voter's reputation
485     }
486 
487     struct Proposal {
488         bytes32 organizationId; // the organization Id
489         bool open; // voting open flag
490         address callbacks;
491         uint256 numOfChoices;
492         bytes32 paramsHash; // the hash of the parameters of the proposal
493         uint256 totalVotes;
494         mapping(uint=>uint) votes;
495         mapping(address=>Voter) voters;
496     }
497 
498     event AVVoteProposal(bytes32 indexed _proposalId, bool _isProxyVote);
499 
500     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
501     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
502     mapping(bytes32=>address) public organizations;
503 
504     uint256 public constant MAX_NUM_OF_CHOICES = 10;
505     uint256 public proposalsCnt; // Total amount of proposals
506 
507   /**
508    * @dev Check that the proposal is votable (open and not executed yet)
509    */
510     modifier votable(bytes32 _proposalId) {
511         require(proposals[_proposalId].open);
512         _;
513     }
514 
515     /**
516      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
517      * generated by calculating keccak256 of a incremented counter.
518      * @param _numOfChoices number of voting choices
519      * @param _paramsHash defined the parameters of the voting machine used for this proposal
520      * @param _organization address
521      * @return proposal's id.
522      */
523     function propose(uint256 _numOfChoices, bytes32 _paramsHash, address, address _organization)
524         external
525         returns(bytes32)
526     {
527         // Check valid params and number of choices:
528         require(parameters[_paramsHash].precReq > 0);
529         require(_numOfChoices > 0 && _numOfChoices <= MAX_NUM_OF_CHOICES);
530         // Generate a unique ID:
531         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
532         proposalsCnt = proposalsCnt.add(1);
533         // Open proposal:
534         Proposal memory proposal;
535         proposal.numOfChoices = _numOfChoices;
536         proposal.paramsHash = _paramsHash;
537         proposal.callbacks = msg.sender;
538         proposal.organizationId = keccak256(abi.encodePacked(msg.sender, _organization));
539         proposal.open = true;
540         proposals[proposalId] = proposal;
541         if (organizations[proposal.organizationId] == address(0)) {
542             if (_organization == address(0)) {
543                 organizations[proposal.organizationId] = msg.sender;
544             } else {
545                 organizations[proposal.organizationId] = _organization;
546             }
547         }
548         emit NewProposal(proposalId, organizations[proposal.organizationId], _numOfChoices, msg.sender, _paramsHash);
549         return proposalId;
550     }
551 
552     /**
553      * @dev voting function
554      * @param _proposalId id of the proposal
555      * @param _vote a value between 0 to and the proposal number of choices.
556      * @param _amount the reputation amount to vote with . if _amount == 0 it will use all voter reputation.
557      * @param _voter voter address
558      * @return bool true - the proposal has been executed
559      *              false - otherwise.
560      */
561     function vote(
562         bytes32 _proposalId,
563         uint256 _vote,
564         uint256 _amount,
565         address _voter)
566         external
567         votable(_proposalId)
568         returns(bool)
569         {
570 
571         Proposal storage proposal = proposals[_proposalId];
572         Parameters memory params = parameters[proposal.paramsHash];
573         address voter;
574         if (params.voteOnBehalf != address(0)) {
575             require(msg.sender == params.voteOnBehalf);
576             voter = _voter;
577         } else {
578             voter = msg.sender;
579         }
580         return internalVote(_proposalId, voter, _vote, _amount);
581     }
582 
583   /**
584    * @dev Cancel the vote of the msg.sender: subtract the reputation amount from the votes
585    * and delete the voter from the proposal struct
586    * @param _proposalId id of the proposal
587    */
588     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
589         cancelVoteInternal(_proposalId, msg.sender);
590     }
591 
592     /**
593       * @dev execute check if the proposal has been decided, and if so, execute the proposal
594       * @param _proposalId the id of the proposal
595       * @return bool true - the proposal has been executed
596       *              false - otherwise.
597      */
598     function execute(bytes32 _proposalId) external votable(_proposalId) returns(bool) {
599         return _execute(_proposalId);
600     }
601 
602   /**
603    * @dev getNumberOfChoices returns the number of choices possible in this proposal
604    * excluding the abstain vote (0)
605    * @param _proposalId the ID of the proposal
606    * @return uint256 that contains number of choices
607    */
608     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint256) {
609         return proposals[_proposalId].numOfChoices;
610     }
611 
612   /**
613    * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
614    * @param _proposalId the ID of the proposal
615    * @param _voter the address of the voter
616    * @return uint256 vote - the voters vote
617    *        uint256 reputation - amount of reputation committed by _voter to _proposalId
618    */
619     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
620         Voter memory voter = proposals[_proposalId].voters[_voter];
621         return (voter.vote, voter.reputation);
622     }
623 
624     /**
625      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
626      * @param _proposalId the ID of the proposal
627      * @param _choice the index in the
628      * @return voted reputation for the given choice
629      */
630     function voteStatus(bytes32 _proposalId, uint256 _choice) external view returns(uint256) {
631         return proposals[_proposalId].votes[_choice];
632     }
633 
634     /**
635       * @dev isVotable check if the proposal is votable
636       * @param _proposalId the ID of the proposal
637       * @return bool true or false
638     */
639     function isVotable(bytes32 _proposalId) external view returns(bool) {
640         return  proposals[_proposalId].open;
641     }
642 
643     /**
644      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
645      * @return bool true or false
646      */
647     function isAbstainAllow() external pure returns(bool) {
648         return true;
649     }
650 
651     /**
652      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
653      * @return min - minimum number of choices
654                max - maximum number of choices
655      */
656     function getAllowedRangeOfChoices() external pure returns(uint256 min, uint256 max) {
657         return (0, MAX_NUM_OF_CHOICES);
658     }
659 
660     /**
661      * @dev hash the parameters, save them if necessary, and return the hash value
662     */
663     function setParameters(uint256 _precReq, address _voteOnBehalf) public returns(bytes32) {
664         require(_precReq <= 100 && _precReq > 0);
665         bytes32 hashedParameters = getParametersHash(_precReq, _voteOnBehalf);
666         parameters[hashedParameters] = Parameters({
667             precReq: _precReq,
668             voteOnBehalf: _voteOnBehalf
669         });
670         return hashedParameters;
671     }
672 
673     /**
674      * @dev hashParameters returns a hash of the given parameters
675      */
676     function getParametersHash(uint256 _precReq, address _voteOnBehalf) public pure returns(bytes32) {
677         return keccak256(abi.encodePacked(_precReq, _voteOnBehalf));
678     }
679 
680     function cancelVoteInternal(bytes32 _proposalId, address _voter) internal {
681         Proposal storage proposal = proposals[_proposalId];
682         Voter memory voter = proposal.voters[_voter];
683         proposal.votes[voter.vote] = (proposal.votes[voter.vote]).sub(voter.reputation);
684         proposal.totalVotes = (proposal.totalVotes).sub(voter.reputation);
685         delete proposal.voters[_voter];
686         emit CancelVoting(_proposalId, organizations[proposal.organizationId], _voter);
687     }
688 
689     function deleteProposal(bytes32 _proposalId) internal {
690         Proposal storage proposal = proposals[_proposalId];
691         for (uint256 cnt = 0; cnt <= proposal.numOfChoices; cnt++) {
692             delete proposal.votes[cnt];
693         }
694         delete proposals[_proposalId];
695     }
696 
697     /**
698       * @dev execute check if the proposal has been decided, and if so, execute the proposal
699       * @param _proposalId the id of the proposal
700       * @return bool true - the proposal has been executed
701       *              false - otherwise.
702      */
703     function _execute(bytes32 _proposalId) internal votable(_proposalId) returns(bool) {
704         Proposal storage proposal = proposals[_proposalId];
705         uint256 totalReputation =
706         VotingMachineCallbacksInterface(proposal.callbacks).getTotalReputationSupply(_proposalId);
707         uint256 precReq = parameters[proposal.paramsHash].precReq;
708         // Check if someone crossed the bar:
709         for (uint256 cnt = 0; cnt <= proposal.numOfChoices; cnt++) {
710             if (proposal.votes[cnt] > (totalReputation/100)*precReq) {
711                 Proposal memory tmpProposal = proposal;
712                 deleteProposal(_proposalId);
713                 emit ExecuteProposal(_proposalId, organizations[tmpProposal.organizationId], cnt, totalReputation);
714                 return ProposalExecuteInterface(tmpProposal.callbacks).executeProposal(_proposalId, int(cnt));
715             }
716         }
717         return false;
718     }
719 
720     /**
721      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
722      * @param _proposalId id of the proposal
723      * @param _voter used in case the vote is cast for someone else
724      * @param _vote a value between 0 to and the proposal's number of choices.
725      * @return true in case of proposal execution otherwise false
726      * throws if proposal is not open or if it has been executed
727      * NB: executes the proposal if a decision has been reached
728      */
729     function internalVote(bytes32 _proposalId, address _voter, uint256 _vote, uint256 _rep) internal returns(bool) {
730         Proposal storage proposal = proposals[_proposalId];
731         // Check valid vote:
732         require(_vote <= proposal.numOfChoices);
733         // Check voter has enough reputation:
734         uint256 reputation = VotingMachineCallbacksInterface(proposal.callbacks).reputationOf(_voter, _proposalId);
735         require(reputation > 0, "_voter must have reputation");
736         require(reputation >= _rep);
737         uint256 rep = _rep;
738         if (rep == 0) {
739             rep = reputation;
740         }
741         // If this voter has already voted, first cancel the vote:
742         if (proposal.voters[_voter].reputation != 0) {
743             cancelVoteInternal(_proposalId, _voter);
744         }
745         // The voting itself:
746         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
747         proposal.totalVotes = rep.add(proposal.totalVotes);
748         proposal.voters[_voter] = Voter({
749             reputation: rep,
750             vote: _vote
751         });
752         // Event:
753         emit VoteProposal(_proposalId, organizations[proposal.organizationId], _voter, _vote, rep);
754         emit AVVoteProposal(_proposalId, (_voter != msg.sender));
755         // execute the proposal if this vote was decisive:
756         return _execute(_proposalId);
757     }
758 }
