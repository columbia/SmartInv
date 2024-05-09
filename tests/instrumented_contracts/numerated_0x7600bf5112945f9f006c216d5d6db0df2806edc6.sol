1 //solium-disable linebreak-style
2 pragma solidity ^0.4.24;
3 
4 library ExtendedMath {
5     function limitLessThan(uint a, uint b) internal pure returns(uint c) {
6         if (a > b) return b;
7         return a;
8     }
9 }
10 
11 library SafeMath {
12 
13     /**
14      * @dev Multiplies two numbers, reverts on overflow.
15      */
16     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (_a == 0) {
21             return 0;
22         }
23 
24         uint256 c = _a * _b;
25         require(c / _a == _b);
26 
27         return c;
28     }
29 
30     /**
31      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
32      */
33     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
34         require(_b > 0); // Solidity only automatically asserts when dividing by 0
35         uint256 c = _a / _b;
36         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
45         require(_b <= _a);
46         uint256 c = _a - _b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Adds two numbers, reverts on overflow.
53      */
54     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
55         uint256 c = _a + _b;
56         require(c >= _a);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63      * reverts when dividing by zero.
64      */
65     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipRenounced(address indexed previousOwner);
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   constructor() public {
87     owner = msg.sender;
88   }
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   /**
99    * @dev Allows the current owner to relinquish control of the contract.
100    * @notice Renouncing to ownership will leave the contract without an owner.
101    * It will not be possible to call the functions with the `onlyOwner`
102    * modifier anymore.
103    */
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address _newOwner) public onlyOwner {
114     _transferOwnership(_newOwner);
115   }
116 
117   /**
118    * @dev Transfers control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121   function _transferOwnership(address _newOwner) internal {
122     require(_newOwner != address(0));
123     emit OwnershipTransferred(owner, _newOwner);
124     owner = _newOwner;
125   }
126 }
127 
128 contract ERC20Basic {
129     function totalSupply() public view returns(uint256);
130 
131     function balanceOf(address _who) public view returns(uint256);
132 
133     function transfer(address _to, uint256 _value) public returns(bool);
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 contract ERC20 is ERC20Basic {
138     function allowance(address _owner, address _spender) public view returns(uint256);
139 
140     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
141 
142     function approve(address _spender, uint256 _value) public returns(bool);
143 
144     event Approval(
145         address indexed owner,
146         address indexed spender,
147         uint256 value
148     );
149 }
150 
151 contract BasicToken is ERC20Basic {
152     using SafeMath
153     for uint256;
154 
155     mapping(address => uint256) internal balances;
156 
157     uint256 internal totalSupply_;
158 
159     /**
160      * @dev Total number of tokens in existence
161      */
162     function totalSupply() public view returns(uint256) {
163         return totalSupply_;
164     }
165 
166     /**
167      * @dev Transfer token for a specified address
168      * @param _to The address to transfer to.
169      * @param _value The amount to be transferred.
170      */
171     function transfer(address _to, uint256 _value) public returns(bool) {
172         require(_value <= balances[msg.sender]);
173         require(_to != address(0));
174 
175         balances[msg.sender] = balances[msg.sender].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         emit Transfer(msg.sender, _to, _value);
178         return true;
179     }
180 
181     /**
182      * @dev Gets the balance of the specified address.
183      * @param _owner The address to query the the balance of.
184      * @return An uint256 representing the amount owned by the passed address.
185      */
186     function balanceOf(address _owner) public view returns(uint256) {
187         return balances[_owner];
188     }
189 
190 }
191 
192 contract StandardToken is ERC20, BasicToken {
193 
194     mapping(address => mapping(address => uint256)) internal allowed;
195 
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(
204         address _from,
205         address _to,
206         uint256 _value
207     )
208     public
209     returns(bool) {
210         require(_value <= balances[_from]);
211         require(_value <= allowed[_from][msg.sender]);
212         require(_to != address(0));
213 
214         balances[_from] = balances[_from].sub(_value);
215         balances[_to] = balances[_to].add(_value);
216         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217         emit Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     /**
222      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223      * Beware that changing an allowance with this method brings the risk that someone may use both the old
224      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      * @param _spender The address which will spend the funds.
228      * @param _value The amount of tokens to be spent.
229      */
230     function approve(address _spender, uint256 _value) public returns(bool) {
231         allowed[msg.sender][_spender] = _value;
232         emit Approval(msg.sender, _spender, _value);
233         return true;
234     }
235 
236     /**
237      * @dev Function to check the amount of tokens that an owner allowed to a spender.
238      * @param _owner address The address which owns the funds.
239      * @param _spender address The address which will spend the funds.
240      * @return A uint256 specifying the amount of tokens still available for the spender.
241      */
242     function allowance(
243         address _owner,
244         address _spender
245     )
246     public
247     view
248     returns(uint256) {
249         return allowed[_owner][_spender];
250     }
251 
252     /**
253      * @dev Increase the amount of tokens that an owner allowed to a spender.
254      * approve should be called when allowed[_spender] == 0. To increment
255      * allowed value is better to use this function to avoid 2 calls (and wait until
256      * the first transaction is mined)
257      * From MonolithDAO Token.sol
258      * @param _spender The address which will spend the funds.
259      * @param _addedValue The amount of tokens to increase the allowance by.
260      */
261     function increaseApproval(
262         address _spender,
263         uint256 _addedValue
264     )
265     public
266     returns(bool) {
267         allowed[msg.sender][_spender] = (
268             allowed[msg.sender][_spender].add(_addedValue));
269         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270         return true;
271     }
272 
273     /**
274      * @dev Decrease the amount of tokens that an owner allowed to a spender.
275      * approve should be called when allowed[_spender] == 0. To decrement
276      * allowed value is better to use this function to avoid 2 calls (and wait until
277      * the first transaction is mined)
278      * From MonolithDAO Token.sol
279      * @param _spender The address which will spend the funds.
280      * @param _subtractedValue The amount of tokens to decrease the allowance by.
281      */
282     function decreaseApproval(
283         address _spender,
284         uint256 _subtractedValue
285     )
286     public
287     returns(bool) {
288         uint256 oldValue = allowed[msg.sender][_spender];
289         if (_subtractedValue >= oldValue) {
290             allowed[msg.sender][_spender] = 0;
291         } else {
292             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293         }
294         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295         return true;
296     }
297 
298 }
299 
300 interface IcaelumVoting {
301     function getTokenProposalDetails() external view returns(address, uint, uint, uint);
302     function getExpiry() external view returns (uint);
303     function getContractType () external view returns (uint);
304 }
305 
306 contract abstractCaelum {
307     function isMasternodeOwner(address _candidate) public view returns(bool);
308     function addToWhitelist(address _ad, uint _amount, uint daysAllowed) internal;
309     function addMasternode(address _candidate) internal returns(uint);
310     function deleteMasternode(uint entityAddress) internal returns(bool success);
311     function getLastPerUser(address _candidate) public view returns (uint);
312     function getMiningReward() public view returns(uint);
313 }
314 
315 contract NewTokenProposal is IcaelumVoting {
316 
317     enum VOTE_TYPE {TOKEN, TEAM}
318 
319     VOTE_TYPE public contractType = VOTE_TYPE.TOKEN;
320     address contractAddress;
321     uint requiredAmount;
322     uint validUntil;
323     uint votingDurationInDays;
324 
325     /**
326      * @dev Create a new vote proposal for an ERC20 token.
327      * @param _contract ERC20 contract
328      * @param _amount How many tokens are required as collateral
329      * @param _valid How long do we accept these tokens on the contract (UNIX timestamp)
330      * @param _voteDuration How many days is this vote available
331      */
332     constructor(address _contract, uint _amount, uint _valid, uint _voteDuration) public {
333         require(_voteDuration >= 14 && _voteDuration <= 50, "Proposed voting duration does not meet requirements");
334 
335         contractAddress = _contract;
336         requiredAmount = _amount;
337         validUntil = _valid;
338         votingDurationInDays = _voteDuration;
339     }
340 
341     /**
342      * @dev Returns all details about this proposal
343      */
344     function getTokenProposalDetails() public view returns(address, uint, uint, uint) {
345         return (contractAddress, requiredAmount, validUntil, uint(contractType));
346     }
347 
348     /**
349      * @dev Displays the expiry date of contract
350      * @return uint Days valid
351      */
352     function getExpiry() external view returns (uint) {
353         return votingDurationInDays;
354     }
355 
356     /**
357      * @dev Displays the type of contract
358      * @return uint Enum value {TOKEN, TEAM}
359      */
360     function getContractType () external view returns (uint){
361         return uint(contractType);
362     }
363 }
364 
365 contract NewMemberProposal is IcaelumVoting {
366 
367     enum VOTE_TYPE {TOKEN, TEAM}
368     VOTE_TYPE public contractType = VOTE_TYPE.TEAM;
369 
370     address memberAddress;
371     uint totalMasternodes;
372     uint votingDurationInDays;
373 
374     /**
375      * @dev Create a new vote proposal for a team member.
376      * @param _contract Future team member's address
377      * @param _total How many masternodes do we want to give
378      * @param _voteDuration How many days is this vote available
379      */
380     constructor(address _contract, uint _total, uint _voteDuration) public {
381         require(_voteDuration >= 14 && _voteDuration <= 50, "Proposed voting duration does not meet requirements");
382         memberAddress = _contract;
383         totalMasternodes = _total;
384         votingDurationInDays = _voteDuration;
385     }
386 
387     /**
388      * @dev Returns all details about this proposal
389      */
390     function getTokenProposalDetails() public view returns(address, uint, uint, uint) {
391         return (memberAddress, totalMasternodes, 0, uint(contractType));
392     }
393 
394     /**
395      * @dev Displays the expiry date of contract
396      * @return uint Days valid
397      */
398     function getExpiry() external view returns (uint) {
399         return votingDurationInDays;
400     }
401 
402     /**
403      * @dev Displays the type of contract
404      * @return uint Enum value {TOKEN, TEAM}
405      */
406     function getContractType () external view returns (uint){
407         return uint(contractType);
408     }
409 }
410 
411 contract CaelumVotings is Ownable {
412     using SafeMath for uint;
413 
414     enum VOTE_TYPE {TOKEN, TEAM}
415 
416     struct Proposals {
417         address tokenContract;
418         uint totalVotes;
419         uint proposedOn;
420         uint acceptedOn;
421         VOTE_TYPE proposalType;
422     }
423 
424     struct Voters {
425         bool isVoter;
426         address owner;
427         uint[] votedFor;
428     }
429 
430     uint MAJORITY_PERCENTAGE_NEEDED = 60;
431     uint MINIMUM_VOTERS_NEEDED = 10;
432     bool public proposalPending;
433 
434     mapping(uint => Proposals) public proposalList;
435     mapping (address => Voters) public voterMap;
436     mapping(uint => address) public voterProposals;
437     uint public proposalCounter;
438     uint public votersCount;
439     uint public votersCountTeam;
440 
441     /**
442      * @notice Define abstract functions for later user
443      */
444     function isMasternodeOwner(address _candidate) public view returns(bool);
445     function addToWhitelist(address _ad, uint _amount, uint daysAllowed) internal;
446     function addMasternode(address _candidate) internal returns(uint);
447     function updateMasternodeAsTeamMember(address _member) internal returns (bool);
448     function isTeamMember (address _candidate) public view returns (bool);
449     
450     event NewProposal(uint ProposalID);
451     event ProposalAccepted(uint ProposalID);
452 
453     /**
454      * @dev Create a new proposal.
455      * @param _contract Proposal contract address
456      * @return uint ProposalID
457      */
458     function pushProposal(address _contract) onlyOwner public returns (uint) {
459         if(proposalCounter != 0)
460         require (pastProposalTimeRules (), "You need to wait 90 days before submitting a new proposal.");
461         require (!proposalPending, "Another proposal is pending.");
462 
463         uint _contractType = IcaelumVoting(_contract).getContractType();
464         proposalList[proposalCounter] = Proposals(_contract, 0, now, 0, VOTE_TYPE(_contractType));
465 
466         emit NewProposal(proposalCounter);
467         
468         proposalCounter++;
469         proposalPending = true;
470 
471         return proposalCounter.sub(1);
472     }
473 
474     /**
475      * @dev Internal function that handles the proposal after it got accepted.
476      * This function determines if the proposal is a token or team member proposal and executes the corresponding functions.
477      * @return uint Returns the proposal ID.
478      */
479     function handleLastProposal () internal returns (uint) {
480         uint _ID = proposalCounter.sub(1);
481 
482         proposalList[_ID].acceptedOn = now;
483         proposalPending = false;
484 
485         address _address;
486         uint _required;
487         uint _valid;
488         uint _type;
489         (_address, _required, _valid, _type) = getTokenProposalDetails(_ID);
490 
491         if(_type == uint(VOTE_TYPE.TOKEN)) {
492             addToWhitelist(_address,_required,_valid);
493         }
494 
495         if(_type == uint(VOTE_TYPE.TEAM)) {
496             if(_required != 0) {
497                 for (uint i = 0; i < _required; i++) {
498                     addMasternode(_address);
499                 }
500             } else {
501                 addMasternode(_address);
502             }
503             updateMasternodeAsTeamMember(_address);
504         }
505         
506         emit ProposalAccepted(_ID);
507         
508         return _ID;
509     }
510 
511     /**
512      * @dev Rejects the last proposal after the allowed voting time has expired and it's not accepted.
513      */
514     function discardRejectedProposal() onlyOwner public returns (bool) {
515         require(proposalPending);
516         require (LastProposalCanDiscard());
517         proposalPending = false;
518         return (true);
519     }
520 
521     /**
522      * @dev Checks if the last proposal allowed voting time has expired and it's not accepted.
523      * @return bool
524      */
525     function LastProposalCanDiscard () public view returns (bool) {
526         
527         uint daysBeforeDiscard = IcaelumVoting(proposalList[proposalCounter - 1].tokenContract).getExpiry();
528         uint entryDate = proposalList[proposalCounter - 1].proposedOn;
529         uint expiryDate = entryDate + (daysBeforeDiscard * 1 days);
530 
531         if (now >= expiryDate)
532         return true;
533     }
534 
535     /**
536      * @dev Returns all details about a proposal
537      */
538     function getTokenProposalDetails(uint proposalID) public view returns(address, uint, uint, uint) {
539         return IcaelumVoting(proposalList[proposalID].tokenContract).getTokenProposalDetails();
540     }
541 
542     /**
543      * @dev Returns if our 90 day cooldown has passed
544      * @return bool
545      */
546     function pastProposalTimeRules() public view returns (bool) {
547         uint lastProposal = proposalList[proposalCounter - 1].proposedOn;
548         if (now >= lastProposal + 90 days)
549         return true;
550     }
551 
552 
553     /**
554      * @dev Allow any masternode user to become a voter.
555      */
556     function becomeVoter() public  {
557         require (isMasternodeOwner(msg.sender), "User has no masternodes");
558         require (!voterMap[msg.sender].isVoter, "User Already voted for this proposal");
559 
560         voterMap[msg.sender].owner = msg.sender;
561         voterMap[msg.sender].isVoter = true;
562         votersCount = votersCount + 1;
563 
564         if (isTeamMember(msg.sender))
565         votersCountTeam = votersCountTeam + 1;
566     }
567 
568     /**
569      * @dev Allow voters to submit their vote on a proposal. Voters can only cast 1 vote per proposal.
570      * If the proposed vote is about adding Team members, only Team members are able to vote.
571      * A proposal can only be published if the total of votes is greater then MINIMUM_VOTERS_NEEDED.
572      * @param proposalID proposalID
573      */
574     function voteProposal(uint proposalID) public returns (bool success) {
575         require(voterMap[msg.sender].isVoter, "Sender not listed as voter");
576         require(proposalID >= 0, "No proposal was selected.");
577         require(proposalID <= proposalCounter, "Proposal out of limits.");
578         require(voterProposals[proposalID] != msg.sender, "Already voted.");
579 
580 
581         if(proposalList[proposalID].proposalType == VOTE_TYPE.TEAM) {
582             require (isTeamMember(msg.sender), "Restricted for team members");
583             voterProposals[proposalID] = msg.sender;
584             proposalList[proposalID].totalVotes++;
585 
586             if(reachedMajorityForTeam(proposalID)) {
587                 // This is the prefered way of handling vote results. It costs more gas but prevents tampering.
588                 // If gas is an issue, you can comment handleLastProposal out and call it manually as onlyOwner.
589                 handleLastProposal();
590                 return true;
591             }
592         } else {
593             require(votersCount >= MINIMUM_VOTERS_NEEDED, "Not enough voters in existence to push a proposal");
594             voterProposals[proposalID] = msg.sender;
595             proposalList[proposalID].totalVotes++;
596 
597             if(reachedMajority(proposalID)) {
598                 // This is the prefered way of handling vote results. It costs more gas but prevents tampering.
599                 // If gas is an issue, you can comment handleLastProposal out and call it manually as onlyOwner.
600                 handleLastProposal();
601                 return true;
602             }
603         }
604 
605 
606     }
607 
608     /**
609      * @dev Check if a proposal has reached the majority vote
610      * @param proposalID Token ID
611      * @return bool
612      */
613     function reachedMajority (uint proposalID) public view returns (bool) {
614         uint getProposalVotes = proposalList[proposalID].totalVotes;
615         if (getProposalVotes >= majority())
616         return true;
617     }
618 
619     /**
620      * @dev Internal function that calculates the majority
621      * @return uint Total of votes needed for majority
622      */
623     function majority () internal view returns (uint) {
624         uint a = (votersCount * MAJORITY_PERCENTAGE_NEEDED );
625         return a / 100;
626     }
627 
628     /**
629      * @dev Check if a proposal has reached the majority vote for a team member
630      * @param proposalID Token ID
631      * @return bool
632      */
633     function reachedMajorityForTeam (uint proposalID) public view returns (bool) {
634         uint getProposalVotes = proposalList[proposalID].totalVotes;
635         if (getProposalVotes >= majorityForTeam())
636         return true;
637     }
638 
639     /**
640      * @dev Internal function that calculates the majority
641      * @return uint Total of votes needed for majority
642      */
643     function majorityForTeam () internal view returns (uint) {
644         uint a = (votersCountTeam * MAJORITY_PERCENTAGE_NEEDED );
645         return a / 100;
646     }
647 
648 }
649 
650 contract CaelumFundraise is Ownable, BasicToken, abstractCaelum {
651 
652     /**
653      * In no way is Caelum intended to raise funds. We leave this code to demonstrate the potential and functionality.
654      * Should you decide to buy a masternode instead of mining, you can by using this function. Feel free to consider this a tipping jar for our dev team.
655      * We strongly advice to use the `buyMasternode`function, but simply sending Ether to the contract should work as well.
656      */
657 
658     uint AMOUNT_FOR_MASTERNODE = 50 ether;
659     uint SPOTS_RESERVED = 10;
660     uint COUNTER;
661     bool fundraiseClosed = false;
662 
663     /**
664      * @dev Not recommended way to accept Ether. Can be safely used if no storage operations are called
665      * The contract may revert all the gas because of the gas limitions on the fallback operator.
666      * We leave it in as template for other projects, however, for Caelum the function deposit should be adviced.
667      */
668     function() payable public {
669         require(msg.value == AMOUNT_FOR_MASTERNODE && msg.value != 0);
670         receivedFunds();
671     }
672 
673     /** @dev This is the recommended way for users to deposit Ether in return of a masternode.
674      * Users should be encouraged to use this approach as there is not gas risk involved.
675      */
676     function buyMasternode () payable public {
677         require(msg.value == AMOUNT_FOR_MASTERNODE && msg.value != 0);
678         receivedFunds();
679     }
680 
681     /**
682      * @dev Forward funds to owner before making any action. owner.transfer will revert if fail.
683      */
684     function receivedFunds() internal {
685         require(!fundraiseClosed);
686         require (COUNTER <= SPOTS_RESERVED);
687         owner.transfer(msg.value);
688         addMasternode(msg.sender);
689     }
690 
691 }
692 
693 contract CaelumAcceptERC20 is Ownable, CaelumVotings, abstractCaelum { 
694     using SafeMath for uint;
695 
696     address[] public tokensList;
697     bool setOwnContract = true;
698 
699     struct _whitelistTokens {
700         address tokenAddress;
701         bool active;
702         uint requiredAmount;
703         uint validUntil;
704         uint timestamp;
705     }
706 
707     mapping(address => mapping(address => uint)) public tokens;
708     mapping(address => _whitelistTokens) acceptedTokens;
709 
710     event Deposit(address token, address user, uint amount, uint balance);
711     event Withdraw(address token, address user, uint amount, uint balance);
712 
713     /**
714      * @dev Return the base rewards. This should be overrided by the miner contract.
715      * Return a base value for standalone usage ONLY.
716      */
717     function getMiningReward() public view returns(uint) {
718         return 50 * 1e8;
719     }
720 
721 
722     /**
723      * @notice Allow the dev to set it's own token as accepted payment.
724      * @dev Can be hardcoded in the constructor. Given the contract size, we decided to separate it.
725      * @return bool
726      */
727     function addOwnToken() onlyOwner public returns (bool) {
728         require(setOwnContract);
729         addToWhitelist(this, 5000 * 1e8, 36500);
730         setOwnContract = false;
731         return true;
732     }
733 
734     // TODO: Set visibility
735     /**
736      * @notice Add a new token as accepted payment method.
737      * @param _token Token contract address.
738      * @param _amount Required amount of this Token as collateral
739      * @param daysAllowed How many days will we accept this token?
740      */
741     function addToWhitelist(address _token, uint _amount, uint daysAllowed) internal {
742         _whitelistTokens storage newToken = acceptedTokens[_token];
743         newToken.tokenAddress = _token;
744         newToken.requiredAmount = _amount;
745         newToken.timestamp = now;
746         newToken.validUntil = now + (daysAllowed * 1 days);
747         newToken.active = true;
748 
749         tokensList.push(_token);
750     }
751 
752     /**
753      * @dev internal function to determine if we accept this token.
754      * @param _ad Token contract address
755      * @return bool
756      */
757     function isAcceptedToken(address _ad) internal view returns(bool) {
758         return acceptedTokens[_ad].active;
759     }
760 
761     /**
762      * @dev internal function to determine the requiredAmount for a specific token.
763      * @param _ad Token contract address
764      * @return bool
765      */
766     function getAcceptedTokenAmount(address _ad) internal view returns(uint) {
767         return acceptedTokens[_ad].requiredAmount;
768     }
769 
770     /**
771      * @dev internal function to determine if the token is still accepted timewise.
772      * @param _ad Token contract address
773      * @return bool
774      */
775     function isValid(address _ad) internal view returns(bool) {
776         uint endTime = acceptedTokens[_ad].validUntil;
777         if (block.timestamp < endTime) return true;
778         return false;
779     }
780 
781     /**
782      * @notice Returns an array of all accepted token. You can get more details by calling getTokenDetails function with this address.
783      * @return array Address
784      */
785     function listAcceptedTokens() public view returns(address[]) {
786         return tokensList;
787     }
788 
789     /**
790      * @notice Returns a full list of the token details
791      * @param token Token contract address
792      */
793     function getTokenDetails(address token) public view returns(address ad,uint required, bool active, uint valid) {
794         return (acceptedTokens[token].tokenAddress, acceptedTokens[token].requiredAmount,acceptedTokens[token].active, acceptedTokens[token].validUntil);
795     }
796 
797     /**
798      * @notice Public function that allows any user to deposit accepted tokens as collateral to become a masternode.
799      * @param token Token contract address
800      * @param amount Amount to deposit
801      */
802     function depositCollateral(address token, uint amount) public {
803         require(isAcceptedToken(token), "ERC20 not authorised");  // Should be a token from our list
804         require(amount == getAcceptedTokenAmount(token));         // The amount needs to match our set amount
805         require(isValid(token));                                  // It should be called within the setup timeframe
806 
807         tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
808 
809         require(StandardToken(token).transferFrom(msg.sender, this, amount), "error with token");
810         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
811 
812         addMasternode(msg.sender);
813     }
814 
815     /**
816      * @notice Public function that allows any user to withdraw deposited tokens and stop as masternode
817      * @param token Token contract address
818      * @param amount Amount to withdraw
819      */
820     function withdrawCollateral(address token, uint amount) public {
821         require(token != 0); // token should be an actual address
822         require(isAcceptedToken(token), "ERC20 not authorised"); // Should be a token from our list
823         require(isMasternodeOwner(msg.sender)); // The sender must be a masternode prior to withdraw
824         require(tokens[token][msg.sender] == amount); // The amount must be exactly whatever is deposited
825 
826         uint amountToWithdraw = tokens[token][msg.sender];
827         tokens[token][msg.sender] = 0;
828 
829         deleteMasternode(getLastPerUser(msg.sender));
830 
831         if (!StandardToken(token).transfer(msg.sender, amountToWithdraw)) revert();
832         emit Withdraw(token, msg.sender, amountToWithdraw, amountToWithdraw);
833     }
834 
835 }
836 
837 contract CaelumMasternode is CaelumFundraise, CaelumAcceptERC20{
838     using SafeMath for uint;
839 
840     bool onTestnet = false;
841     bool genesisAdded = false;
842 
843     uint  masternodeRound;
844     uint  masternodeCandidate;
845     uint  masternodeCounter;
846     uint  masternodeEpoch;
847     uint  miningEpoch;
848 
849     uint rewardsProofOfWork;
850     uint rewardsMasternode;
851     uint rewardsGlobal = 50 * 1e8;
852 
853     uint MINING_PHASE_DURATION_BLOCKS = 4500;
854 
855     struct MasterNode {
856         address accountOwner;
857         bool isActive;
858         bool isTeamMember;
859         uint storedIndex;
860         uint startingRound;
861         uint[] indexcounter;
862     }
863 
864     uint[] userArray;
865     address[] userAddressArray;
866 
867     mapping(uint => MasterNode) userByIndex; // UINT masterMapping
868     mapping(address => MasterNode) userByAddress; //masterMapping
869     mapping(address => uint) userAddressIndex;
870 
871     event Deposit(address token, address user, uint amount, uint balance);
872     event Withdraw(address token, address user, uint amount, uint balance);
873 
874     event NewMasternode(address candidateAddress, uint timeStamp);
875     event RemovedMasternode(address candidateAddress, uint timeStamp);
876 
877     /**
878      * @dev Add the genesis accounts
879      */
880     function addGenesis(address _genesis, bool _team) onlyOwner public {
881         require(!genesisAdded);
882 
883         addMasternode(_genesis);
884 
885         if (_team) {
886             updateMasternodeAsTeamMember(msg.sender);
887         }
888 
889     }
890 
891     /**
892      * @dev Close the genesis accounts
893      */
894     function closeGenesis() onlyOwner public {
895         genesisAdded = true; // Forever lock this.
896     }
897 
898     /**
899      * @dev Add a user as masternode. Called as internal since we only add masternodes by depositing collateral or by voting.
900      * @param _candidate Candidate address
901      * @return uint Masternode index
902      */
903     function addMasternode(address _candidate) internal returns(uint) {
904         userByIndex[masternodeCounter].accountOwner = _candidate;
905         userByIndex[masternodeCounter].isActive = true;
906         userByIndex[masternodeCounter].startingRound = masternodeRound + 1;
907         userByIndex[masternodeCounter].storedIndex = masternodeCounter;
908 
909         userByAddress[_candidate].accountOwner = _candidate;
910         userByAddress[_candidate].indexcounter.push(masternodeCounter);
911 
912         userArray.push(userArray.length);
913         masternodeCounter++;
914 
915         emit NewMasternode(_candidate, now);
916         return masternodeCounter - 1; //
917     }
918 
919     /**
920      * @dev Allow us to update a masternode's round to keep progress
921      * @param _candidate ID of masternode
922      */
923     function updateMasternode(uint _candidate) internal returns(bool) {
924         userByIndex[_candidate].startingRound++;
925         return true;
926     }
927 
928     /**
929      * @dev Allow us to update a masternode to team member status
930      * @param _member address
931      */
932     function updateMasternodeAsTeamMember(address _member) internal returns (bool) {
933         userByAddress[_member].isTeamMember = true;
934         return (true);
935     }
936 
937     /**
938      * @dev Let us know if an address is part of the team.
939      * @param _member address
940      */
941     function isTeamMember (address _member) public view returns (bool) {
942         if (userByAddress[_member].isTeamMember)
943         return true;
944     }
945 
946     /**
947      * @dev Remove a specific masternode
948      * @param _masternodeID ID of the masternode to remove
949      */
950     function deleteMasternode(uint _masternodeID) internal returns(bool success) {
951 
952         uint rowToDelete = userByIndex[_masternodeID].storedIndex;
953         uint keyToMove = userArray[userArray.length - 1];
954 
955         userByIndex[_masternodeID].isActive = userByIndex[_masternodeID].isActive = (false);
956         userArray[rowToDelete] = keyToMove;
957         userByIndex[keyToMove].storedIndex = rowToDelete;
958         userArray.length = userArray.length - 1;
959 
960         removeFromUserCounter(_masternodeID);
961 
962         emit RemovedMasternode(userByIndex[_masternodeID].accountOwner, now);
963 
964         return true;
965     }
966 
967     /**
968      * @dev returns what account belongs to a masternode
969      */
970     function isPartOf(uint mnid) public view returns (address) {
971         return userByIndex[mnid].accountOwner;
972     }
973 
974     /**
975      * @dev Internal function to remove a masternode from a user address if this address holds multpile masternodes
976      * @param index MasternodeID
977      */
978     function removeFromUserCounter(uint index)  internal returns(uint[]) {
979         address belong = isPartOf(index);
980 
981         if (index >= userByAddress[belong].indexcounter.length) return;
982 
983         for (uint i = index; i<userByAddress[belong].indexcounter.length-1; i++){
984             userByAddress[belong].indexcounter[i] = userByAddress[belong].indexcounter[i+1];
985         }
986 
987         delete userByAddress[belong].indexcounter[userByAddress[belong].indexcounter.length-1];
988         userByAddress[belong].indexcounter.length--;
989         return userByAddress[belong].indexcounter;
990     }
991 
992     /**
993      * @dev Primary contract function to update the current user and prepare the next one.
994      * A number of steps have been token to ensure the contract can never run out of gas when looping over our masternodes.
995      */
996     function setMasternodeCandidate() internal returns(address) {
997 
998         uint hardlimitCounter = 0;
999 
1000         while (getFollowingCandidate() == 0x0) {
1001             // We must return a value not to break the contract. Require is a secondary killswitch now.
1002             require(hardlimitCounter < 6, "Failsafe switched on");
1003             // Choose if loop over revert/require to terminate the loop and return a 0 address.
1004             if (hardlimitCounter == 5) return (0);
1005             masternodeRound = masternodeRound + 1;
1006             masternodeCandidate = 0;
1007             hardlimitCounter++;
1008         }
1009 
1010         if (masternodeCandidate == masternodeCounter - 1) {
1011             masternodeRound = masternodeRound + 1;
1012             masternodeCandidate = 0;
1013         }
1014 
1015         for (uint i = masternodeCandidate; i < masternodeCounter; i++) {
1016             if (userByIndex[i].isActive) {
1017                 if (userByIndex[i].startingRound == masternodeRound) {
1018                     updateMasternode(i);
1019                     masternodeCandidate = i;
1020                     return (userByIndex[i].accountOwner);
1021                 }
1022             }
1023         }
1024 
1025         masternodeRound = masternodeRound + 1;
1026         return (0);
1027 
1028     }
1029 
1030     /**
1031      * @dev Helper function to loop through our masternodes at start and return the correct round
1032      */
1033     function getFollowingCandidate() internal view returns(address _address) {
1034         uint tmpRound = masternodeRound;
1035         uint tmpCandidate = masternodeCandidate;
1036 
1037         if (tmpCandidate == masternodeCounter - 1) {
1038             tmpRound = tmpRound + 1;
1039             tmpCandidate = 0;
1040         }
1041 
1042         for (uint i = masternodeCandidate; i < masternodeCounter; i++) {
1043             if (userByIndex[i].isActive) {
1044                 if (userByIndex[i].startingRound == tmpRound) {
1045                     tmpCandidate = i;
1046                     return (userByIndex[i].accountOwner);
1047                 }
1048             }
1049         }
1050 
1051         tmpRound = tmpRound + 1;
1052         return (0);
1053     }
1054 
1055     /**
1056      * @dev Displays all masternodes belonging to a user address.
1057      */
1058     function belongsToUser(address userAddress) public view returns(uint[]) {
1059         return (userByAddress[userAddress].indexcounter);
1060     }
1061 
1062     /**
1063      * @dev Helper function to know if an address owns masternodes
1064      */
1065     function isMasternodeOwner(address _candidate) public view returns(bool) {
1066         if(userByAddress[_candidate].indexcounter.length <= 0) return false;
1067         if (userByAddress[_candidate].accountOwner == _candidate)
1068         return true;
1069     }
1070 
1071     /**
1072      * @dev Helper function to get the last masternode belonging to a user
1073      */
1074     function getLastPerUser(address _candidate) public view returns (uint) {
1075         return userByAddress[_candidate].indexcounter[userByAddress[_candidate].indexcounter.length - 1];
1076     }
1077 
1078 
1079     /**
1080      * @dev Calculate and set the reward schema for Caelum.
1081      * Each mining phase is decided by multiplying the MINING_PHASE_DURATION_BLOCKS with factor 10.
1082      * Depending on the outcome (solidity always rounds), we can detect the current stage of mining.
1083      * First stage we cut the rewards to 5% to prevent instamining.
1084      * Last stage we leave 2% for miners to incentivize keeping miners running.
1085      */
1086     function calculateRewardStructures() internal {
1087         //ToDo: Set
1088         uint _global_reward_amount = getMiningReward();
1089         uint getStageOfMining = miningEpoch / MINING_PHASE_DURATION_BLOCKS * 10;
1090 
1091         if (getStageOfMining < 10) {
1092             rewardsProofOfWork = _global_reward_amount / 100 * 5;
1093             rewardsMasternode = 0;
1094             return;
1095         }
1096 
1097         if (getStageOfMining > 90) {
1098             rewardsProofOfWork = _global_reward_amount / 100 * 2;
1099             rewardsMasternode = _global_reward_amount / 100 * 98;
1100             return;
1101         }
1102 
1103         uint _mnreward = (_global_reward_amount / 100) * getStageOfMining;
1104         uint _powreward = (_global_reward_amount - _mnreward);
1105 
1106         setBaseRewards(_powreward, _mnreward);
1107     }
1108 
1109     function setBaseRewards(uint _pow, uint _mn) internal {
1110         rewardsMasternode = _mn;
1111         rewardsProofOfWork = _pow;
1112     }
1113 
1114     /**
1115      * @dev Executes the masternode flow. Should be called after mining a block.
1116      */
1117     function _arrangeMasternodeFlow() internal {
1118         calculateRewardStructures();
1119         setMasternodeCandidate();
1120         miningEpoch++;
1121     }
1122 
1123     /**
1124      * @dev Executes the masternode flow. Should be called after mining a block.
1125      * This is an emergency manual loop method.
1126      */
1127     function _emergencyLoop() onlyOwner public {
1128         calculateRewardStructures();
1129         setMasternodeCandidate();
1130         miningEpoch++;
1131     }
1132 
1133     function masternodeInfo(uint index) public view returns
1134     (
1135         address,
1136         bool,
1137         uint,
1138         uint
1139     )
1140     {
1141         return (
1142             userByIndex[index].accountOwner,
1143             userByIndex[index].isActive,
1144             userByIndex[index].storedIndex,
1145             userByIndex[index].startingRound
1146         );
1147     }
1148 
1149     function contractProgress() public view returns
1150     (
1151         uint epoch,
1152         uint candidate,
1153         uint round,
1154         uint miningepoch,
1155         uint globalreward,
1156         uint powreward,
1157         uint masternodereward,
1158         uint usercounter
1159     )
1160     {
1161         return (
1162             masternodeEpoch,
1163             masternodeCandidate,
1164             masternodeRound,
1165             miningEpoch,
1166             getMiningReward(),
1167             rewardsProofOfWork,
1168             rewardsMasternode,
1169             masternodeCounter
1170         );
1171     }
1172 
1173 }
1174 
1175 contract CaelumMiner is StandardToken, CaelumMasternode {
1176     using SafeMath for uint;
1177     using ExtendedMath for uint;
1178 
1179     string public symbol = "CLM";
1180     string public name = "Caelum Token";
1181     uint8 public decimals = 8;
1182     uint256 public totalSupply = 2100000000000000;
1183 
1184     uint public latestDifficultyPeriodStarted;
1185     uint public epochCount;
1186     uint public baseMiningReward = 50;
1187     uint public blocksPerReadjustment = 512;
1188     uint public _MINIMUM_TARGET = 2 ** 16;
1189     uint public _MAXIMUM_TARGET = 2 ** 234;
1190     uint public rewardEra = 0;
1191 
1192     uint public maxSupplyForEra;
1193     uint public MAX_REWARD_ERA = 39;
1194     uint public MINING_RATE_FACTOR = 60; //mint the token 60 times less often than ether
1195     //difficulty adjustment parameters- be careful modifying these
1196     uint public MAX_ADJUSTMENT_PERCENT = 100;
1197     uint public TARGET_DIVISOR = 2000;
1198     uint public QUOTIENT_LIMIT = TARGET_DIVISOR.div(2);
1199     mapping(bytes32 => bytes32) solutionForChallenge;
1200     mapping(address => mapping(address => uint)) allowed;
1201 
1202     bytes32 public challengeNumber;
1203     uint public difficulty;
1204     uint public tokensMinted;
1205 
1206 
1207     struct Statistics {
1208         address lastRewardTo;
1209         uint lastRewardAmount;
1210         uint lastRewardEthBlockNumber;
1211         uint lastRewardTimestamp;
1212     }
1213 
1214     Statistics public statistics;
1215     
1216     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
1217     event RewardMasternode(address candidate, uint amount);
1218 
1219     constructor() public {
1220         tokensMinted = 0;
1221         maxSupplyForEra = totalSupply.div(2);
1222         difficulty = _MAXIMUM_TARGET;
1223         latestDifficultyPeriodStarted = block.number;
1224         _newEpoch(0);
1225 
1226         balances[msg.sender] = balances[msg.sender].add(420000 * 1e8); // 2% Premine as determined by the community meeting.
1227         emit Transfer(this, msg.sender, 420000 * 1e8);
1228     }
1229 
1230     function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success) {
1231         // perform the hash function validation
1232         _hash(nonce, challenge_digest);
1233 
1234         _arrangeMasternodeFlow();
1235 
1236         uint rewardAmount = _reward();
1237         uint rewardMasternode = _reward_masternode();
1238 
1239         tokensMinted += rewardAmount.add(rewardMasternode);
1240 
1241         uint epochCounter = _newEpoch(nonce);
1242 
1243         _adjustDifficulty();
1244 
1245         statistics = Statistics(msg.sender, rewardAmount, block.number, now);
1246 
1247         emit Mint(msg.sender, rewardAmount, epochCounter, challengeNumber);
1248 
1249         return true;
1250     }
1251 
1252     function _newEpoch(uint256 nonce) internal returns(uint) {
1253 
1254         if (tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < MAX_REWARD_ERA) {
1255             rewardEra = rewardEra + 1;
1256         }
1257         maxSupplyForEra = totalSupply - totalSupply.div(2 ** (rewardEra + 1));
1258         epochCount = epochCount.add(1);
1259         challengeNumber = blockhash(block.number - 1);
1260         return (epochCount);
1261     }
1262 
1263     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns(bytes32 digest) {
1264         digest = keccak256(challengeNumber, msg.sender, nonce);
1265         if (digest != challenge_digest) revert();
1266         if (uint256(digest) > difficulty) revert();
1267         bytes32 solution = solutionForChallenge[challengeNumber];
1268         solutionForChallenge[challengeNumber] = digest;
1269         if (solution != 0x0) revert(); //prevent the same answer from awarding twice
1270     }
1271 
1272     function _reward() internal returns(uint) {
1273 
1274         uint _pow = rewardsProofOfWork;
1275 
1276         balances[msg.sender] = balances[msg.sender].add(_pow);
1277         emit Transfer(this, msg.sender, _pow);
1278 
1279         return _pow;
1280     }
1281 
1282     function _reward_masternode() internal returns(uint) {
1283 
1284         uint _mnReward = rewardsMasternode;
1285         if (masternodeCounter == 0) return 0;
1286 
1287         address _mnCandidate = userByIndex[masternodeCandidate].accountOwner;
1288         if (_mnCandidate == 0x0) return 0;
1289 
1290         balances[_mnCandidate] = balances[_mnCandidate].add(_mnReward);
1291         emit Transfer(this, _mnCandidate, _mnReward);
1292 
1293         emit RewardMasternode(_mnCandidate, _mnReward);
1294 
1295         return _mnReward;
1296     }
1297 
1298 
1299     //DO NOT manually edit this method unless you know EXACTLY what you are doing
1300     function _adjustDifficulty() internal returns(uint) {
1301         //every so often, readjust difficulty. Dont readjust when deploying
1302         if (epochCount % blocksPerReadjustment != 0) {
1303             return difficulty;
1304         }
1305 
1306         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
1307         //assume 360 ethereum blocks per hour
1308         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch
1309         uint epochsMined = blocksPerReadjustment;
1310         uint targetEthBlocksPerDiffPeriod = epochsMined * MINING_RATE_FACTOR;
1311         //if there were less eth blocks passed in time than expected
1312         if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
1313             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(ethBlocksSinceLastDifficultyPeriod);
1314             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT);
1315             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
1316             //make it harder
1317             difficulty = difficulty.sub(difficulty.div(TARGET_DIVISOR).mul(excess_block_pct_extra)); //by up to 50 %
1318         } else {
1319             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(targetEthBlocksPerDiffPeriod);
1320             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT); //always between 0 and 1000
1321             //make it easier
1322             difficulty = difficulty.add(difficulty.div(TARGET_DIVISOR).mul(shortage_block_pct_extra)); //by up to 50 %
1323         }
1324         latestDifficultyPeriodStarted = block.number;
1325         if (difficulty < _MINIMUM_TARGET) //very difficult
1326         {
1327             difficulty = _MINIMUM_TARGET;
1328         }
1329         if (difficulty > _MAXIMUM_TARGET) //very easy
1330         {
1331             difficulty = _MAXIMUM_TARGET;
1332         }
1333     }
1334     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
1335     function getChallengeNumber() public view returns(bytes32) {
1336         return challengeNumber;
1337     }
1338     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
1339     function getMiningDifficulty() public view returns(uint) {
1340         return _MAXIMUM_TARGET.div(difficulty);
1341     }
1342 
1343     function getMiningTarget() public view returns(uint) {
1344         return difficulty;
1345     }
1346 
1347     function getMiningReward() public view returns(uint) {
1348         return (baseMiningReward * 1e8).div(2 ** rewardEra);
1349     }
1350 
1351     //help debug mining software
1352     function getMintDigest(
1353         uint256 nonce,
1354         bytes32 challenge_digest,
1355         bytes32 challenge_number
1356     )
1357     public view returns(bytes32 digesttest) {
1358         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
1359         return digest;
1360     }
1361     //help debug mining software
1362     function checkMintSolution(
1363         uint256 nonce,
1364         bytes32 challenge_digest,
1365         bytes32 challenge_number,
1366         uint testTarget
1367     )
1368     public view returns(bool success) {
1369         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
1370         if (uint256(digest) > testTarget) revert();
1371         return (digest == challenge_digest);
1372     }
1373 }