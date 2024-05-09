1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * Libraries
6 **/
7 
8 library ExtendedMath {
9     function limitLessThan(uint a, uint b) internal pure returns(uint c) {
10         if (a > b) return b;
11         return a;
12     }
13 }
14 
15 library SafeMath {
16 
17     /**
18      * @dev Multiplies two numbers, reverts on overflow.
19      */
20     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
21         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22         // benefit is lost if 'b' is also tested.
23         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24         if (_a == 0) {
25             return 0;
26         }
27 
28         uint256 c = _a * _b;
29         require(c / _a == _b);
30 
31         return c;
32     }
33 
34     /**
35      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36      */
37     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
38         require(_b > 0); // Solidity only automatically asserts when dividing by 0
39         uint256 c = _a / _b;
40         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
41 
42         return c;
43     }
44 
45     /**
46      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47      */
48     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
49         require(_b <= _a);
50         uint256 c = _a - _b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Adds two numbers, reverts on overflow.
57      */
58     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
59         uint256 c = _a + _b;
60         require(c >= _a);
61 
62         return c;
63     }
64 
65     /**
66      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67      * reverts when dividing by zero.
68      */
69     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
70         require(b != 0);
71         return a % b;
72     }
73 }
74 
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipRenounced(owner);
110     owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address _newOwner) public onlyOwner {
118     _transferOwnership(_newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address _newOwner) internal {
126     require(_newOwner != address(0));
127     emit OwnershipTransferred(owner, _newOwner);
128     owner = _newOwner;
129   }
130 }
131 
132 contract ERC20Basic {
133     function totalSupply() public view returns(uint256);
134 
135     function balanceOf(address _who) public view returns(uint256);
136 
137     function transfer(address _to, uint256 _value) public returns(bool);
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 contract ERC20 is ERC20Basic {
142     function allowance(address _owner, address _spender) public view returns(uint256);
143 
144     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
145 
146     function approve(address _spender, uint256 _value) public returns(bool);
147 
148     event Approval(
149         address indexed owner,
150         address indexed spender,
151         uint256 value
152     );
153 }
154 
155 contract BasicToken is ERC20Basic {
156     using SafeMath
157     for uint256;
158 
159     mapping(address => uint256) internal balances;
160 
161     uint256 internal totalSupply_;
162 
163     /**
164      * @dev Total number of tokens in existence
165      */
166     function totalSupply() public view returns(uint256) {
167         return totalSupply_;
168     }
169 
170     /**
171      * @dev Transfer token for a specified address
172      * @param _to The address to transfer to.
173      * @param _value The amount to be transferred.
174      */
175     function transfer(address _to, uint256 _value) public returns(bool) {
176         //require(_value <= balances[msg.sender]);
177         require(_to != address(0));
178 
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         emit Transfer(msg.sender, _to, _value);
182         return true;
183     }
184 
185     /**
186      * @dev Gets the balance of the specified address.
187      * @param _owner The address to query the the balance of.
188      * @return An uint256 representing the amount owned by the passed address.
189      */
190     function balanceOf(address _owner) public view returns(uint256) {
191         return balances[_owner];
192     }
193 
194 }
195 
196 contract StandardToken is ERC20, BasicToken {
197 
198     mapping(address => mapping(address => uint256)) internal allowed;
199 
200 
201     /**
202      * @dev Transfer tokens from one address to another
203      * @param _from address The address which you want to send tokens from
204      * @param _to address The address which you want to transfer to
205      * @param _value uint256 the amount of tokens to be transferred
206      */
207     function transferFrom(
208         address _from,
209         address _to,
210         uint256 _value
211     )
212     public
213     returns(bool) {
214         //require(_value <= balances[_from]);
215         //require(_value <= allowed[_from][msg.sender]);
216         require(_to != address(0));
217 
218         balances[_from] = balances[_from].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221         emit Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param _spender The address which will spend the funds.
232      * @param _value The amount of tokens to be spent.
233      */
234     function approve(address _spender, uint256 _value) public returns(bool) {
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     /**
241      * @dev Function to check the amount of tokens that an owner allowed to a spender.
242      * @param _owner address The address which owns the funds.
243      * @param _spender address The address which will spend the funds.
244      * @return A uint256 specifying the amount of tokens still available for the spender.
245      */
246     function allowance(
247         address _owner,
248         address _spender
249     )
250     public
251     view
252     returns(uint256) {
253         return allowed[_owner][_spender];
254     }
255 
256     /**
257      * @dev Increase the amount of tokens that an owner allowed to a spender.
258      * approve should be called when allowed[_spender] == 0. To increment
259      * allowed value is better to use this function to avoid 2 calls (and wait until
260      * the first transaction is mined)
261      * From MonolithDAO Token.sol
262      * @param _spender The address which will spend the funds.
263      * @param _addedValue The amount of tokens to increase the allowance by.
264      */
265     function increaseApproval(
266         address _spender,
267         uint256 _addedValue
268     )
269     public
270     returns(bool) {
271         allowed[msg.sender][_spender] = (
272             allowed[msg.sender][_spender].add(_addedValue));
273         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274         return true;
275     }
276 
277     /**
278      * @dev Decrease the amount of tokens that an owner allowed to a spender.
279      * approve should be called when allowed[_spender] == 0. To decrement
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * @param _spender The address which will spend the funds.
284      * @param _subtractedValue The amount of tokens to decrease the allowance by.
285      */
286     function decreaseApproval(
287         address _spender,
288         uint256 _subtractedValue
289     )
290     public
291     returns(bool) {
292         uint256 oldValue = allowed[msg.sender][_spender];
293         if (_subtractedValue >= oldValue) {
294             allowed[msg.sender][_spender] = 0;
295         } else {
296             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297         }
298         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299         return true;
300     }
301 
302 }
303 
304 interface IRemoteFunctions {
305   function _externalAddMasternode(address) external;
306   function _externalStopMasternode(address) external;
307 }
308 
309 interface IcaelumVoting {
310     function getTokenProposalDetails() external view returns(address, uint, uint, uint);
311     function getExpiry() external view returns (uint);
312     function getContractType () external view returns (uint);
313 }
314 
315 interface EIP918Interface  {
316 
317     /*
318      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
319      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
320      * a Mint event is emitted before returning a success indicator.
321      **/
322   	function mint(uint256 nonce, bytes32 challenge_digest) external returns (bool success);
323 
324 
325 	/*
326      * Returns the challenge number
327      **/
328     function getChallengeNumber() external constant returns (bytes32);
329 
330     /*
331      * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which
332      * typically auto adjusts during reward generation.
333      **/
334     function getMiningDifficulty() external constant returns (uint);
335 
336     /*
337      * Returns the mining target
338      **/
339     function getMiningTarget() external constant returns (uint);
340 
341     /*
342      * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era
343      * as tokens are mined to provide scarcity
344      **/
345     function getMiningReward() external constant returns (uint);
346 
347     /*
348      * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address,
349      * the reward amount, the epoch count and newest challenge number.
350      **/
351     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
352 
353 }
354 
355 contract NewMinerProposal is IcaelumVoting {
356 
357     enum VOTE_TYPE {MINER, MASTER, TOKEN}
358 
359     VOTE_TYPE public contractType = VOTE_TYPE.TOKEN;
360     address contractAddress;
361     uint validUntil;
362     uint votingDurationInDays;
363 
364     /**
365      * @dev Create a new vote proposal for an ERC20 token.
366      * @param _contract ERC20 contract
367      * @param _valid How long do we accept these tokens on the contract (UNIX timestamp)
368      * @param _voteDuration How many days is this vote available
369      */
370     constructor(address _contract, uint _valid, uint _voteDuration) public {
371         require(_voteDuration >= 14 && _voteDuration <= 50, "Proposed voting duration does not meet requirements");
372 
373         contractAddress = _contract;
374         validUntil = _valid;
375         votingDurationInDays = _voteDuration;
376     }
377 
378     /**
379      * @dev Returns all details about this proposal
380      */
381     function getTokenProposalDetails() public view returns(address, uint, uint, uint) {
382         return (contractAddress, 0, validUntil, uint(contractType));
383     }
384 
385     /**
386      * @dev Displays the expiry date of contract
387      * @return uint Days valid
388      */
389     function getExpiry() external view returns (uint) {
390         return votingDurationInDays;
391     }
392 
393     /**
394      * @dev Displays the type of contract
395      * @return uint Enum value {TOKEN, TEAM}
396      */
397     function getContractType () external view returns (uint){
398         return uint(contractType);
399     }
400 }
401 
402 contract CaelumVotings is Ownable {
403     using SafeMath for uint;
404 
405     enum VOTE_TYPE {MINER, MASTER, TOKEN}
406 
407     struct Proposals {
408         address tokenContract;
409         uint totalVotes;
410         uint proposedOn;
411         uint acceptedOn;
412         VOTE_TYPE proposalType;
413     }
414 
415     struct Voters {
416         bool isVoter;
417         address owner;
418         uint[] votedFor;
419     }
420 
421     uint MAJORITY_PERCENTAGE_NEEDED = 60;
422     uint MINIMUM_VOTERS_NEEDED = 1;
423     bool public proposalPending;
424 
425     mapping(uint => Proposals) public proposalList;
426     mapping (address => Voters) public voterMap;
427     mapping(uint => address) public voterProposals;
428     uint public proposalCounter;
429     uint public votersCount;
430     uint public votersCountTeam;
431 
432 
433     function setMasternodeContractFromVote(address _t) internal ;
434     function setTokenContractFromVote(address _t) internal;
435     function setMiningContractFromVote (address _t) internal;
436 
437     event NewProposal(uint ProposalID);
438     event ProposalAccepted(uint ProposalID);
439 
440     address _CaelumMasternodeContract;
441     CaelumMasternode public MasternodeContract;
442 
443     function setMasternodeContractForData(address _t) onlyOwner public {
444         MasternodeContract = CaelumMasternode(_t);
445         _CaelumMasternodeContract = (_t);
446     }
447 
448     function setVotingMinority(uint _total) onlyOwner public {
449         require(_total > MINIMUM_VOTERS_NEEDED);
450         MINIMUM_VOTERS_NEEDED = _total;
451     }
452 
453 
454     /**
455      * @dev Create a new proposal.
456      * @param _contract Proposal contract address
457      * @return uint ProposalID
458      */
459     function pushProposal(address _contract) onlyOwner public returns (uint) {
460         if(proposalCounter != 0)
461         require (pastProposalTimeRules (), "You need to wait 90 days before submitting a new proposal.");
462         require (!proposalPending, "Another proposal is pending.");
463 
464         uint _contractType = IcaelumVoting(_contract).getContractType();
465         proposalList[proposalCounter] = Proposals(_contract, 0, now, 0, VOTE_TYPE(_contractType));
466 
467         emit NewProposal(proposalCounter);
468 
469         proposalCounter++;
470         proposalPending = true;
471 
472         return proposalCounter.sub(1);
473     }
474 
475     /**
476      * @dev Internal function that handles the proposal after it got accepted.
477      * This function determines if the proposal is a token or team member proposal and executes the corresponding functions.
478      * @return uint Returns the proposal ID.
479      */
480     function handleLastProposal () internal returns (uint) {
481         uint _ID = proposalCounter.sub(1);
482 
483         proposalList[_ID].acceptedOn = now;
484         proposalPending = false;
485 
486         address _address;
487         uint _required;
488         uint _valid;
489         uint _type;
490         (_address, _required, _valid, _type) = getTokenProposalDetails(_ID);
491 
492         if(_type == uint(VOTE_TYPE.MINER)) {
493             setMiningContractFromVote(_address);
494         }
495 
496         if(_type == uint(VOTE_TYPE.MASTER)) {
497             setMasternodeContractFromVote(_address);
498         }
499 
500         if(_type == uint(VOTE_TYPE.TOKEN)) {
501             setTokenContractFromVote(_address);
502         }
503 
504         emit ProposalAccepted(_ID);
505 
506         return _ID;
507     }
508 
509     /**
510      * @dev Rejects the last proposal after the allowed voting time has expired and it's not accepted.
511      */
512     function discardRejectedProposal() onlyOwner public returns (bool) {
513         require(proposalPending);
514         require (LastProposalCanDiscard());
515         proposalPending = false;
516         return (true);
517     }
518 
519     /**
520      * @dev Checks if the last proposal allowed voting time has expired and it's not accepted.
521      * @return bool
522      */
523     function LastProposalCanDiscard () public view returns (bool) {
524 
525         uint daysBeforeDiscard = IcaelumVoting(proposalList[proposalCounter - 1].tokenContract).getExpiry();
526         uint entryDate = proposalList[proposalCounter - 1].proposedOn;
527         uint expiryDate = entryDate + (daysBeforeDiscard * 1 days);
528 
529         if (now >= expiryDate)
530         return true;
531     }
532 
533     /**
534      * @dev Returns all details about a proposal
535      */
536     function getTokenProposalDetails(uint proposalID) public view returns(address, uint, uint, uint) {
537         return IcaelumVoting(proposalList[proposalID].tokenContract).getTokenProposalDetails();
538     }
539 
540     /**
541      * @dev Returns if our 90 day cooldown has passed
542      * @return bool
543      */
544     function pastProposalTimeRules() public view returns (bool) {
545         uint lastProposal = proposalList[proposalCounter - 1].proposedOn;
546         if (now >= lastProposal + 90 days)
547         return true;
548     }
549 
550 
551     /**
552      * @dev Allow any masternode user to become a voter.
553      */
554     function becomeVoter() public  {
555         require (MasternodeContract.isMasternodeOwner(msg.sender), "User has no masternodes");
556         require (!voterMap[msg.sender].isVoter, "User Already voted for this proposal");
557 
558         voterMap[msg.sender].owner = msg.sender;
559         voterMap[msg.sender].isVoter = true;
560         votersCount = votersCount + 1;
561 
562         if (MasternodeContract.isTeamMember(msg.sender))
563         votersCountTeam = votersCountTeam + 1;
564     }
565 
566     /**
567      * @dev Allow voters to submit their vote on a proposal. Voters can only cast 1 vote per proposal.
568      * If the proposed vote is about adding Team members, only Team members are able to vote.
569      * A proposal can only be published if the total of votes is greater then MINIMUM_VOTERS_NEEDED.
570      * @param proposalID proposalID
571      */
572     function voteProposal(uint proposalID) public returns (bool success) {
573         require(voterMap[msg.sender].isVoter, "Sender not listed as voter");
574         require(proposalID >= 0, "No proposal was selected.");
575         require(proposalID <= proposalCounter, "Proposal out of limits.");
576         require(voterProposals[proposalID] != msg.sender, "Already voted.");
577 
578 
579         require(votersCount >= MINIMUM_VOTERS_NEEDED, "Not enough voters in existence to push a proposal");
580         voterProposals[proposalID] = msg.sender;
581         proposalList[proposalID].totalVotes++;
582 
583         if(reachedMajority(proposalID)) {
584             // This is the prefered way of handling vote results. It costs more gas but prevents tampering.
585             // If gas is an issue, you can comment handleLastProposal out and call it manually as onlyOwner.
586             handleLastProposal();
587             return true;
588 
589         }
590 
591     }
592 
593     /**
594      * @dev Check if a proposal has reached the majority vote
595      * @param proposalID Token ID
596      * @return bool
597      */
598     function reachedMajority (uint proposalID) public view returns (bool) {
599         uint getProposalVotes = proposalList[proposalID].totalVotes;
600         if (getProposalVotes >= majority())
601         return true;
602     }
603 
604     /**
605      * @dev Internal function that calculates the majority
606      * @return uint Total of votes needed for majority
607      */
608     function majority () internal view returns (uint) {
609         uint a = (votersCount * MAJORITY_PERCENTAGE_NEEDED );
610         return a / 100;
611     }
612 
613     /**
614      * @dev Check if a proposal has reached the majority vote for a team member
615      * @param proposalID Token ID
616      * @return bool
617      */
618     function reachedMajorityForTeam (uint proposalID) public view returns (bool) {
619         uint getProposalVotes = proposalList[proposalID].totalVotes;
620         if (getProposalVotes >= majorityForTeam())
621         return true;
622     }
623 
624     /**
625      * @dev Internal function that calculates the majority
626      * @return uint Total of votes needed for majority
627      */
628     function majorityForTeam () internal view returns (uint) {
629         uint a = (votersCountTeam * MAJORITY_PERCENTAGE_NEEDED );
630         return a / 100;
631     }
632 
633 }
634 
635 contract CaelumAcceptERC20 is Ownable  {
636     using SafeMath for uint;
637 
638     IRemoteFunctions public DataVault;
639 
640     address[] public tokensList;
641     bool setOwnContract = true;
642 
643     struct _whitelistTokens {
644         address tokenAddress;
645         bool active;
646         uint requiredAmount;
647         uint validUntil;
648         uint timestamp;
649     }
650 
651     mapping(address => mapping(address => uint)) public tokens;
652     mapping(address => _whitelistTokens) acceptedTokens;
653 
654     event Deposit(address token, address user, uint amount, uint balance);
655     event Withdraw(address token, address user, uint amount, uint balance);
656 
657     
658 
659 
660     /**
661      * @notice Allow the dev to set it's own token as accepted payment.
662      * @dev Can be hardcoded in the constructor. Given the contract size, we decided to separate it.
663      * @return bool
664      */
665     function addOwnToken() onlyOwner public returns (bool) {
666         require(setOwnContract);
667         addToWhitelist(this, 5000 * 1e8, 36500);
668         setOwnContract = false;
669         return true;
670     }
671 
672 
673     /**
674      * @notice Add a new token as accepted payment method.
675      * @param _token Token contract address.
676      * @param _amount Required amount of this Token as collateral
677      * @param daysAllowed How many days will we accept this token?
678      */
679     function addToWhitelist(address _token, uint _amount, uint daysAllowed) internal {
680         _whitelistTokens storage newToken = acceptedTokens[_token];
681         newToken.tokenAddress = _token;
682         newToken.requiredAmount = _amount;
683         newToken.timestamp = now;
684         newToken.validUntil = now + (daysAllowed * 1 days);
685         newToken.active = true;
686 
687         tokensList.push(_token);
688     }
689 
690     /**
691      * @dev internal function to determine if we accept this token.
692      * @param _ad Token contract address
693      * @return bool
694      */
695     function isAcceptedToken(address _ad) internal view returns(bool) {
696         return acceptedTokens[_ad].active;
697     }
698 
699     /**
700      * @dev internal function to determine the requiredAmount for a specific token.
701      * @param _ad Token contract address
702      * @return bool
703      */
704     function getAcceptedTokenAmount(address _ad) internal view returns(uint) {
705         return acceptedTokens[_ad].requiredAmount;
706     }
707 
708     /**
709      * @dev internal function to determine if the token is still accepted timewise.
710      * @param _ad Token contract address
711      * @return bool
712      */
713     function isValid(address _ad) internal view returns(bool) {
714         uint endTime = acceptedTokens[_ad].validUntil;
715         if (block.timestamp < endTime) return true;
716         return false;
717     }
718 
719     /**
720      * @notice Returns an array of all accepted token. You can get more details by calling getTokenDetails function with this address.
721      * @return array Address
722      */
723     function listAcceptedTokens() public view returns(address[]) {
724         return tokensList;
725     }
726 
727     /**
728      * @notice Returns a full list of the token details
729      * @param token Token contract address
730      */
731     function getTokenDetails(address token) public view returns(address ad,uint required, bool active, uint valid) {
732         return (acceptedTokens[token].tokenAddress, acceptedTokens[token].requiredAmount,acceptedTokens[token].active, acceptedTokens[token].validUntil);
733     }
734 
735     /**
736      * @notice Public function that allows any user to deposit accepted tokens as collateral to become a masternode.
737      * @param token Token contract address
738      * @param amount Amount to deposit
739      */
740     function depositCollateral(address token, uint amount) public {
741         require(isAcceptedToken(token), "ERC20 not authorised");  // Should be a token from our list
742         require(amount == getAcceptedTokenAmount(token));         // The amount needs to match our set amount
743         require(isValid(token));                                  // It should be called within the setup timeframe
744 
745         tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
746 
747         require(StandardToken(token).transferFrom(msg.sender, this, amount), "error with token");
748         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
749 
750         DataVault._externalAddMasternode(msg.sender);
751     }
752 
753 
754     /**
755      * @notice Public function that allows any user to withdraw deposited tokens and stop as masternode
756      * @param token Token contract address
757      * @param amount Amount to withdraw
758      */
759     function withdrawCollateral(address token, uint amount) public {
760         require(token != 0);                                        // token should be an actual address
761         require(isAcceptedToken(token), "ERC20 not authorised");    // Should be a token from our list
762         require(amount == getAcceptedTokenAmount(token));           // The amount needs to match our set amount, allow only one withdrawal at a time.
763         require(tokens[token][msg.sender] >= amount);               // The owner must own at least this amount of tokens.
764 
765         uint amountToWithdraw = tokens[token][msg.sender];
766         tokens[token][msg.sender] = 0;
767 
768         DataVault._externalStopMasternode(msg.sender);
769 
770         if (!StandardToken(token).transfer(msg.sender, amountToWithdraw)) revert();
771         emit Withdraw(token, msg.sender, amountToWithdraw, amountToWithdraw);
772     }
773 
774     function setDataStorage (address _masternodeContract) onlyOwner public {
775         DataVault = IRemoteFunctions(_masternodeContract);
776     }
777 }
778 
779 contract CaelumAbstractMasternode is Ownable{
780     using SafeMath for uint;
781 
782     bool onTestnet = false;
783     bool genesisAdded = false;
784 
785     uint public masternodeRound;
786     uint public masternodeCandidate;
787     uint public masternodeCounter;
788     uint public masternodeEpoch;
789     uint public miningEpoch;
790 
791     uint public rewardsProofOfWork;
792     uint public rewardsMasternode;
793     uint rewardsGlobal = 50 * 1e8;
794 
795     uint public MINING_PHASE_DURATION_BLOCKS = 4500;
796 
797     struct MasterNode {
798         address accountOwner;
799         bool isActive;
800         bool isTeamMember;
801         uint storedIndex;
802         uint startingRound;
803         uint[] indexcounter;
804     }
805 
806     uint[] userArray;
807     address[] userAddressArray;
808 
809     mapping(uint => MasterNode) userByIndex; // UINT masterMapping
810     mapping(address => MasterNode) userByAddress; //masterMapping
811     mapping(address => uint) userAddressIndex;
812 
813     event Deposit(address token, address user, uint amount, uint balance);
814     event Withdraw(address token, address user, uint amount, uint balance);
815 
816     event NewMasternode(address candidateAddress, uint timeStamp);
817     event RemovedMasternode(address candidateAddress, uint timeStamp);
818 
819     /**
820      * @dev Add the genesis accounts
821      */
822     function addGenesis(address _genesis, bool _team) onlyOwner public {
823         require(!genesisAdded);
824 
825         addMasternode(_genesis);
826 
827         if (_team) {
828             updateMasternodeAsTeamMember(msg.sender);
829         }
830 
831     }
832 
833     /**
834      * @dev Close the genesis accounts
835      */
836     function closeGenesis() onlyOwner public {
837         genesisAdded = true; // Forever lock this.
838     }
839 
840     /**
841      * @dev Add a user as masternode. Called as internal since we only add masternodes by depositing collateral or by voting.
842      * @param _candidate Candidate address
843      * @return uint Masternode index
844      */
845     function addMasternode(address _candidate) internal returns(uint) {
846         userByIndex[masternodeCounter].accountOwner = _candidate;
847         userByIndex[masternodeCounter].isActive = true;
848         userByIndex[masternodeCounter].startingRound = masternodeRound + 1;
849         userByIndex[masternodeCounter].storedIndex = masternodeCounter;
850 
851         userByAddress[_candidate].accountOwner = _candidate;
852         userByAddress[_candidate].indexcounter.push(masternodeCounter);
853 
854         userArray.push(userArray.length);
855         masternodeCounter++;
856 
857         emit NewMasternode(_candidate, now);
858         return masternodeCounter - 1; //
859     }
860 
861     /**
862      * @dev Allow us to update a masternode's round to keep progress
863      * @param _candidate ID of masternode
864      */
865     function updateMasternode(uint _candidate) internal returns(bool) {
866         userByIndex[_candidate].startingRound++;
867         return true;
868     }
869 
870     /**
871      * @dev Allow us to update a masternode to team member status
872      * @param _member address
873      */
874     function updateMasternodeAsTeamMember(address _member) internal returns (bool) {
875         userByAddress[_member].isTeamMember = true;
876         return (true);
877     }
878 
879     /**
880      * @dev Let us know if an address is part of the team.
881      * @param _member address
882      */
883     function isTeamMember (address _member) public view returns (bool) {
884         if (userByAddress[_member].isTeamMember)
885         return true;
886     }
887 
888     /**
889      * @dev Remove a specific masternode
890      * @param _masternodeID ID of the masternode to remove
891      */
892     function deleteMasternode(uint _masternodeID) internal returns(bool success) {
893 
894         uint rowToDelete = userByIndex[_masternodeID].storedIndex;
895         uint keyToMove = userArray[userArray.length - 1];
896 
897         userByIndex[_masternodeID].isActive = userByIndex[_masternodeID].isActive = (false);
898         userArray[rowToDelete] = keyToMove;
899         userByIndex[keyToMove].storedIndex = rowToDelete;
900         userArray.length = userArray.length - 1;
901 
902         removeFromUserCounter(_masternodeID);
903 
904         emit RemovedMasternode(userByIndex[_masternodeID].accountOwner, now);
905 
906         return true;
907     }
908 
909     /**
910      * @dev returns what account belongs to a masternode
911      */
912     function isPartOf(uint mnid) public view returns (address) {
913         return userByIndex[mnid].accountOwner;
914     }
915 
916     /**
917      * @dev Internal function to remove a masternode from a user address if this address holds multpile masternodes
918      * @param index MasternodeID
919      */
920     function removeFromUserCounter(uint index)  internal returns(uint[]) {
921         address belong = isPartOf(index);
922 
923         if (index >= userByAddress[belong].indexcounter.length) return;
924 
925         for (uint i = index; i<userByAddress[belong].indexcounter.length-1; i++){
926             userByAddress[belong].indexcounter[i] = userByAddress[belong].indexcounter[i+1];
927         }
928 
929         delete userByAddress[belong].indexcounter[userByAddress[belong].indexcounter.length-1];
930         userByAddress[belong].indexcounter.length--;
931         return userByAddress[belong].indexcounter;
932     }
933 
934     /**
935      * @dev Primary contract function to update the current user and prepare the next one.
936      * A number of steps have been token to ensure the contract can never run out of gas when looping over our masternodes.
937      */
938     function setMasternodeCandidate() internal returns(address) {
939 
940         uint hardlimitCounter = 0;
941 
942         while (getFollowingCandidate() == 0x0) {
943             // We must return a value not to break the contract. Require is a secondary killswitch now.
944             require(hardlimitCounter < 6, "Failsafe switched on");
945             // Choose if loop over revert/require to terminate the loop and return a 0 address.
946             if (hardlimitCounter == 5) return (0);
947             masternodeRound = masternodeRound + 1;
948             masternodeCandidate = 0;
949             hardlimitCounter++;
950         }
951 
952         if (masternodeCandidate == masternodeCounter - 1) {
953             masternodeRound = masternodeRound + 1;
954             masternodeCandidate = 0;
955         }
956 
957         for (uint i = masternodeCandidate; i < masternodeCounter; i++) {
958             if (userByIndex[i].isActive) {
959                 if (userByIndex[i].startingRound == masternodeRound) {
960                     updateMasternode(i);
961                     masternodeCandidate = i;
962                     return (userByIndex[i].accountOwner);
963                 }
964             }
965         }
966 
967         masternodeRound = masternodeRound + 1;
968         return (0);
969 
970     }
971 
972     /**
973      * @dev Helper function to loop through our masternodes at start and return the correct round
974      */
975     function getFollowingCandidate() internal view returns(address _address) {
976         uint tmpRound = masternodeRound;
977         uint tmpCandidate = masternodeCandidate;
978 
979         if (tmpCandidate == masternodeCounter - 1) {
980             tmpRound = tmpRound + 1;
981             tmpCandidate = 0;
982         }
983 
984         for (uint i = masternodeCandidate; i < masternodeCounter; i++) {
985             if (userByIndex[i].isActive) {
986                 if (userByIndex[i].startingRound == tmpRound) {
987                     tmpCandidate = i;
988                     return (userByIndex[i].accountOwner);
989                 }
990             }
991         }
992 
993         tmpRound = tmpRound + 1;
994         return (0);
995     }
996 
997     /**
998      * @dev Displays all masternodes belonging to a user address.
999      */
1000     function belongsToUser(address userAddress) public view returns(uint[]) {
1001         return (userByAddress[userAddress].indexcounter);
1002     }
1003 
1004     /**
1005      * @dev Helper function to know if an address owns masternodes
1006      */
1007     function isMasternodeOwner(address _candidate) public view returns(bool) {
1008         if(userByAddress[_candidate].indexcounter.length <= 0) return false;
1009         if (userByAddress[_candidate].accountOwner == _candidate)
1010         return true;
1011     }
1012 
1013     /**
1014      * @dev Helper function to get the last masternode belonging to a user
1015      */
1016     function getLastPerUser(address _candidate) public view returns (uint) {
1017         return userByAddress[_candidate].indexcounter[userByAddress[_candidate].indexcounter.length - 1];
1018     }
1019 
1020     /**
1021      * @dev Return the base rewards. This should be overrided by the miner contract.
1022      * Return a base value for standalone usage ONLY.
1023      */
1024     function getMiningReward() public view returns(uint) {
1025         return 50 * 1e8;
1026     }
1027 
1028     /**
1029      * @dev Calculate and set the reward schema for Caelum.
1030      * Each mining phase is decided by multiplying the MINING_PHASE_DURATION_BLOCKS with factor 10.
1031      * Depending on the outcome (solidity always rounds), we can detect the current stage of mining.
1032      * First stage we cut the rewards to 5% to prevent instamining.
1033      * Last stage we leave 2% for miners to incentivize keeping miners running.
1034      */
1035     function calculateRewardStructures() internal {
1036         //ToDo: Set
1037         uint _global_reward_amount = getMiningReward();
1038         uint getStageOfMining = miningEpoch / MINING_PHASE_DURATION_BLOCKS * 10;
1039 
1040         if (getStageOfMining < 10) {
1041             rewardsProofOfWork = _global_reward_amount / 100 * 5;
1042             rewardsMasternode = 0;
1043             return;
1044         }
1045 
1046         if (getStageOfMining > 90) {
1047             rewardsProofOfWork = _global_reward_amount / 100 * 2;
1048             rewardsMasternode = _global_reward_amount / 100 * 98;
1049             return;
1050         }
1051 
1052         uint _mnreward = (_global_reward_amount / 100) * getStageOfMining;
1053         uint _powreward = (_global_reward_amount - _mnreward);
1054 
1055         setBaseRewards(_powreward, _mnreward);
1056     }
1057 
1058     function setBaseRewards(uint _pow, uint _mn) internal {
1059         rewardsMasternode = _mn;
1060         rewardsProofOfWork = _pow;
1061     }
1062 
1063     /**
1064      * @dev Executes the masternode flow. Should be called after mining a block.
1065      */
1066     function _arrangeMasternodeFlow() internal {
1067         calculateRewardStructures();
1068         setMasternodeCandidate();
1069         miningEpoch++;
1070     }
1071 
1072     /**
1073      * @dev Executes the masternode flow. Should be called after mining a block.
1074      * This is an emergency manual loop method.
1075      */
1076     function _emergencyLoop() onlyOwner public {
1077         calculateRewardStructures();
1078         setMasternodeCandidate();
1079         miningEpoch++;
1080     }
1081 
1082     function masternodeInfo(uint index) public view returns
1083     (
1084         address,
1085         bool,
1086         uint,
1087         uint
1088     )
1089     {
1090         return (
1091             userByIndex[index].accountOwner,
1092             userByIndex[index].isActive,
1093             userByIndex[index].storedIndex,
1094             userByIndex[index].startingRound
1095         );
1096     }
1097 
1098     function contractProgress() public view returns
1099     (
1100         uint epoch,
1101         uint candidate,
1102         uint round,
1103         uint miningepoch,
1104         uint globalreward,
1105         uint powreward,
1106         uint masternodereward,
1107         uint usercounter
1108     )
1109     {
1110         return (
1111             masternodeEpoch,
1112             masternodeCandidate,
1113             masternodeRound,
1114             miningEpoch,
1115             getMiningReward(),
1116             rewardsProofOfWork,
1117             rewardsMasternode,
1118             masternodeCounter
1119         );
1120     }
1121 
1122 }
1123 
1124 contract CaelumMasternode is CaelumVotings, CaelumAbstractMasternode {
1125 
1126     /**
1127      * @dev Hardcoded token mining address. For trust and safety we do not allow changing this.
1128      * Should anything change, a new instance needs to be redeployed.
1129      */
1130     address public miningContract;
1131     address public tokenContract;
1132     
1133     bool minerSet = false;
1134     bool tokenSet = false;
1135 
1136     function setMiningContract(address _t) onlyOwner public {
1137         require(!minerSet);
1138         miningContract = _t;
1139         minerSet = true;
1140     }
1141 
1142     function setTokenContract(address _t) onlyOwner public {
1143         require(!tokenSet);
1144         tokenContract = _t;
1145         tokenSet = true;
1146     }
1147 
1148     function setMasternodeContractFromVote(address _t) internal {
1149     }
1150 
1151     function setTokenContractFromVote(address _t) internal{
1152         tokenContract = _t;
1153     }
1154 
1155     function setMiningContractFromVote (address _t) internal {
1156         miningContract = _t;
1157     }
1158 
1159     /**
1160      * @dev Only allow the token mining contract to call this function when used remotely.
1161      * Use the internal function when working within the same contract.
1162      */
1163     modifier onlyMiningContract() {
1164         require(msg.sender == miningContract);
1165         _;
1166     }
1167 
1168     /**
1169      * @dev Only allow the token contract to call this function when used remotely.
1170      * Use the internal function when working within the same contract.
1171      */
1172     modifier onlyTokenContract() {
1173         require(msg.sender == tokenContract);
1174         _;
1175     }
1176 
1177     /**
1178      * @dev Only allow the token contract to call this function when used remotely.
1179      * Use the internal function when working within the same contract.
1180      */
1181     modifier bothRemoteContracts() {
1182         require(msg.sender == tokenContract || msg.sender == miningContract);
1183         _;
1184     }
1185 
1186     /**
1187      * @dev Use this to externaly call the _arrangeMasternodeFlow function. ALWAYS set a modifier !
1188      */
1189     function _externalArrangeFlow() onlyMiningContract external {
1190         _arrangeMasternodeFlow();
1191     }
1192 
1193     /**
1194      * @dev Use this to externaly call the addMasternode function. ALWAYS set a modifier !
1195      */
1196     function _externalAddMasternode(address _received) onlyMiningContract external {
1197         addMasternode(_received);
1198     }
1199 
1200     /**
1201      * @dev Use this to externaly call the deleteMasternode function. ALWAYS set a modifier !
1202      */
1203     function _externalStopMasternode(address _received) onlyMiningContract external {
1204         deleteMasternode(getLastPerUser(_received));
1205     }
1206 
1207     function getMiningReward() public view returns(uint) {
1208         return CaelumMiner(miningContract).getMiningReward();
1209     }
1210     
1211     address cloneDataFrom = 0x7600bF5112945F9F006c216d5d6db0df2806eDc6;
1212     
1213     function getDataFromContract () onlyOwner public returns(uint) {
1214         
1215         CaelumMasternode prev = CaelumMasternode(cloneDataFrom);
1216         (uint epoch,
1217         uint candidate,
1218         uint round,
1219         uint miningepoch,
1220         uint globalreward,
1221         uint powreward,
1222         uint masternodereward,
1223         uint usercounter) = prev.contractProgress();
1224         
1225         masternodeEpoch = epoch;
1226         masternodeRound = round;
1227         miningEpoch = miningepoch;
1228         rewardsProofOfWork = powreward;
1229         rewardsMasternode = masternodereward;
1230 
1231     }
1232 
1233 }
1234 
1235 contract CaelumToken is Ownable, StandardToken, CaelumVotings, CaelumAcceptERC20 {
1236     using SafeMath for uint;
1237 
1238     ERC20 previousContract;
1239     
1240     bool contractSet = false;
1241     bool public swapClosed = false;
1242     uint public swapCounter;
1243 
1244     string public symbol = "CLM";
1245     string public name = "Caelum Token";
1246     uint8 public decimals = 8;
1247     uint256 public totalSupply = 2100000000000000;
1248     
1249     address public miningContract = 0x0;
1250 
1251     /**
1252      * @dev Only allow the token mining contract to call this function when used remotely.
1253      * Use the internal function when working within the same contract.
1254      */
1255     modifier onlyMiningContract() {
1256         require(msg.sender == miningContract);
1257         _;
1258     }
1259 
1260     constructor(address _previousContract) public {
1261         previousContract = ERC20(_previousContract);
1262         swapClosed = false;
1263         swapCounter = 0;
1264     }
1265 
1266     function setMiningContract (address _t) onlyOwner public {
1267         require(!contractSet);
1268         miningContract = _t;
1269         contractSet = true;
1270     }
1271 
1272     function setMasternodeContractFromVote(address _t) internal {
1273         return;
1274     }
1275 
1276     function setTokenContractFromVote(address _t) internal{
1277         return;
1278     }
1279 
1280     function setMiningContractFromVote (address _t) internal {
1281         miningContract = _t;
1282     }
1283     
1284     function changeSwapState (bool _state) onlyOwner public {
1285         require(swapCounter <= 9);
1286         swapClosed = _state;
1287         swapCounter++;
1288     }
1289 
1290     function rewardExternal(address _receiver, uint _amount) onlyMiningContract external {
1291         balances[_receiver] = balances[_receiver].add(_amount);
1292         emit Transfer(this, _receiver, _amount);
1293     }
1294 
1295 
1296     function upgradeTokens() public{
1297         require(!swapClosed);
1298         uint amountToUpgrade = previousContract.balanceOf(msg.sender);
1299         require(amountToUpgrade <= previousContract.allowance(msg.sender, this));
1300         
1301         if(previousContract.transferFrom(msg.sender, this, amountToUpgrade)){
1302             balances[msg.sender] = balances[msg.sender].add(amountToUpgrade); // 2% Premine as determined by the community meeting.
1303             emit Transfer(this, msg.sender, amountToUpgrade);
1304         }
1305         
1306         require(previousContract.balanceOf(msg.sender) == 0);
1307     }
1308 }
1309 
1310 
1311 
1312 contract AbstractERC918 is EIP918Interface {
1313 
1314     // generate a new challenge number after a new reward is minted
1315     bytes32 public challengeNumber;
1316 
1317     // the current mining difficulty
1318     uint public difficulty;
1319 
1320     // cumulative counter of the total minted tokens
1321     uint public tokensMinted;
1322 
1323     // track read only minting statistics
1324     struct Statistics {
1325         address lastRewardTo;
1326         uint lastRewardAmount;
1327         uint lastRewardEthBlockNumber;
1328         uint lastRewardTimestamp;
1329     }
1330 
1331     Statistics public statistics;
1332 
1333     /*
1334      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
1335      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
1336      * a Mint event is emitted before returning a success indicator.
1337      **/
1338     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
1339 
1340 
1341     /*
1342      * Internal interface function _hash. Overide in implementation to define hashing algorithm and
1343      * validation
1344      **/
1345     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns (bytes32 digest);
1346 
1347     /*
1348      * Internal interface function _reward. Overide in implementation to calculate and return reward
1349      * amount
1350      **/
1351     function _reward() internal returns (uint);
1352 
1353     /*
1354      * Internal interface function _newEpoch. Overide in implementation to define a cutpoint for mutating
1355      * mining variables in preparation for the next epoch
1356      **/
1357     function _newEpoch(uint256 nonce) internal returns (uint);
1358 
1359     /*
1360      * Internal interface function _adjustDifficulty. Overide in implementation to adjust the difficulty
1361      * of the mining as required
1362      **/
1363     function _adjustDifficulty() internal returns (uint);
1364 
1365 }
1366 
1367 contract CaelumAbstractMiner is AbstractERC918 {
1368     /**
1369      * CaelumMiner contract.
1370      *
1371      * We need to make sure the contract is 100% compatible when using the EIP918Interface.
1372      * This contract is an abstract Caelum miner contract.
1373      *
1374      * Function 'mint', and '_reward' are overriden in the CaelumMiner contract.
1375      * Function '_reward_masternode' is added and needs to be overriden in the CaelumMiner contract.
1376      */
1377 
1378     using SafeMath for uint;
1379     using ExtendedMath for uint;
1380 
1381     uint256 public totalSupply = 2100000000000000;
1382 
1383     uint public latestDifficultyPeriodStarted;
1384     uint public epochCount;
1385     uint public baseMiningReward = 50;
1386     uint public blocksPerReadjustment = 512;
1387     uint public _MINIMUM_TARGET = 2 ** 16;
1388     uint public _MAXIMUM_TARGET = 2 ** 234;
1389     uint public rewardEra = 0;
1390 
1391     uint public maxSupplyForEra;
1392     uint public MAX_REWARD_ERA = 39;
1393     uint public MINING_RATE_FACTOR = 60; //mint the token 60 times less often than ether
1394 
1395     uint public MAX_ADJUSTMENT_PERCENT = 100;
1396     uint public TARGET_DIVISOR = 2000;
1397     uint public QUOTIENT_LIMIT = TARGET_DIVISOR.div(2);
1398     mapping(bytes32 => bytes32) solutionForChallenge;
1399     mapping(address => mapping(address => uint)) allowed;
1400 
1401     bytes32 public challengeNumber;
1402     uint public difficulty;
1403     uint public tokensMinted;
1404 
1405 
1406     Statistics public statistics;
1407 
1408     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
1409     event RewardMasternode(address candidate, uint amount);
1410 
1411     constructor() public {
1412         tokensMinted = 0;
1413         maxSupplyForEra = totalSupply.div(2);
1414         difficulty = _MAXIMUM_TARGET;
1415         latestDifficultyPeriodStarted = block.number;
1416         _newEpoch(0);
1417     }
1418 
1419 
1420 
1421     function _newEpoch(uint256 nonce) internal returns(uint) {
1422 
1423         if (tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < MAX_REWARD_ERA) {
1424             rewardEra = rewardEra + 1;
1425         }
1426         maxSupplyForEra = totalSupply - totalSupply.div(2 ** (rewardEra + 1));
1427         epochCount = epochCount.add(1);
1428         challengeNumber = blockhash(block.number - 1);
1429         return (epochCount);
1430     }
1431 
1432     function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);
1433 
1434     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns(bytes32 digest) {
1435         digest = keccak256(challengeNumber, msg.sender, nonce);
1436         if (digest != challenge_digest) revert();
1437         if (uint256(digest) > difficulty) revert();
1438         bytes32 solution = solutionForChallenge[challengeNumber];
1439         solutionForChallenge[challengeNumber] = digest;
1440         if (solution != 0x0) revert(); //prevent the same answer from awarding twice
1441     }
1442 
1443     function _reward() internal returns(uint);
1444 
1445     function _reward_masternode() internal returns(uint);
1446 
1447     function _adjustDifficulty() internal returns(uint) {
1448         //every so often, readjust difficulty. Dont readjust when deploying
1449         if (epochCount % blocksPerReadjustment != 0) {
1450             return difficulty;
1451         }
1452 
1453         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
1454         //assume 360 ethereum blocks per hour
1455         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch
1456         uint epochsMined = blocksPerReadjustment;
1457         uint targetEthBlocksPerDiffPeriod = epochsMined * MINING_RATE_FACTOR;
1458         //if there were less eth blocks passed in time than expected
1459         if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
1460             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(ethBlocksSinceLastDifficultyPeriod);
1461             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT);
1462             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
1463             //make it harder
1464             difficulty = difficulty.sub(difficulty.div(TARGET_DIVISOR).mul(excess_block_pct_extra)); //by up to 50 %
1465         } else {
1466             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(targetEthBlocksPerDiffPeriod);
1467             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT); //always between 0 and 1000
1468             //make it easier
1469             difficulty = difficulty.add(difficulty.div(TARGET_DIVISOR).mul(shortage_block_pct_extra)); //by up to 50 %
1470         }
1471         latestDifficultyPeriodStarted = block.number;
1472         if (difficulty < _MINIMUM_TARGET) //very difficult
1473         {
1474             difficulty = _MINIMUM_TARGET;
1475         }
1476         if (difficulty > _MAXIMUM_TARGET) //very easy
1477         {
1478             difficulty = _MAXIMUM_TARGET;
1479         }
1480     }
1481 
1482     function getChallengeNumber() public view returns(bytes32) {
1483         return challengeNumber;
1484     }
1485 
1486     function getMiningDifficulty() public view returns(uint) {
1487         return _MAXIMUM_TARGET.div(difficulty);
1488     }
1489 
1490     function getMiningTarget() public view returns(uint) {
1491         return difficulty;
1492     }
1493 
1494     function getMiningReward() public view returns(uint) {
1495         return (baseMiningReward * 1e8).div(2 ** rewardEra);
1496     }
1497 
1498     function getMintDigest(
1499         uint256 nonce,
1500         bytes32 challenge_digest,
1501         bytes32 challenge_number
1502     )
1503     public view returns(bytes32 digesttest) {
1504         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
1505         return digest;
1506     }
1507 
1508     function checkMintSolution(
1509         uint256 nonce,
1510         bytes32 challenge_digest,
1511         bytes32 challenge_number,
1512         uint testTarget
1513     )
1514     public view returns(bool success) {
1515         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
1516         if (uint256(digest) > testTarget) revert();
1517         return (digest == challenge_digest);
1518     }
1519 }
1520 
1521 contract CaelumMiner is CaelumVotings, CaelumAbstractMiner {
1522 
1523     /**
1524      * CaelumMiner main contract
1525      *
1526      * Inherit from our abstract CaelumMiner contract and override some functions
1527      * of the AbstractERC918 contract to allow masternode rewardings.
1528      *
1529      * @dev use this contract to make all changes needed for your project.
1530      */
1531 
1532     address cloneDataFrom = 0x7600bF5112945F9F006c216d5d6db0df2806eDc6;
1533 
1534     bool ACTIVE_CONTRACT_STATE = true;
1535     bool MasternodeSet = false;
1536     bool TokenSet = false;
1537 
1538     address _CaelumMasternodeContract;
1539     address _CaelumTokenContract;
1540 
1541     CaelumMasternode public MasternodeContract;
1542     CaelumToken public tokenContract;
1543 
1544     function setMasternodeContract(address _t) onlyOwner public {
1545         require(!MasternodeSet);
1546         MasternodeContract = CaelumMasternode(_t);
1547         _CaelumMasternodeContract = (_t);
1548         MasternodeSet = true;
1549     }
1550 
1551     function setTokenContract(address _t) onlyOwner public {
1552         require(!TokenSet);
1553         tokenContract = CaelumToken(_t);
1554         _CaelumTokenContract = (_t);
1555         TokenSet = true;
1556     }
1557 
1558     function setMiningContract (address _t) onlyOwner public {
1559         return; 
1560     }
1561 
1562     function setMasternodeContractFromVote(address _t) internal {
1563         MasternodeContract = CaelumMasternode(_t);
1564         _CaelumMasternodeContract = (_t);
1565     }
1566 
1567     function setTokenContractFromVote(address _t) internal{
1568         tokenContract = CaelumToken(_t);
1569         _CaelumTokenContract = (_t);
1570     }
1571 
1572     function setMiningContractFromVote (address _t) internal {
1573         return;
1574     }
1575     
1576     function lockMiningContract () onlyOwner public {
1577         ACTIVE_CONTRACT_STATE = false;
1578     }
1579 
1580     function getDataFromContract () onlyOwner public {
1581 
1582         require(_CaelumTokenContract != 0);
1583         require(_CaelumMasternodeContract != 0);
1584 
1585         CaelumMiner prev = CaelumMiner(cloneDataFrom);
1586         difficulty = prev.difficulty();
1587         rewardEra = prev.rewardEra();
1588         MINING_RATE_FACTOR = prev.MINING_RATE_FACTOR();
1589         maxSupplyForEra = prev.maxSupplyForEra();
1590         tokensMinted = prev.tokensMinted();
1591         epochCount = prev.epochCount();
1592         latestDifficultyPeriodStarted = prev.latestDifficultyPeriodStarted();
1593 
1594         ACTIVE_CONTRACT_STATE = true;
1595     }
1596     
1597 
1598     /**
1599      * @dev override of the original function since we want to call the masternode contract remotely.
1600      */
1601     function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success) {
1602         // If contract is no longer active, stop accepting solutions.
1603         require(ACTIVE_CONTRACT_STATE);
1604 
1605         _hash(nonce, challenge_digest);
1606 
1607         MasternodeContract._externalArrangeFlow();
1608 
1609         uint rewardAmount =_reward();
1610         uint rewardMasternode = _reward_masternode();
1611 
1612         tokensMinted += rewardAmount.add(rewardMasternode);
1613 
1614         uint epochCounter = _newEpoch(nonce);
1615 
1616         _adjustDifficulty();
1617 
1618         statistics = Statistics(msg.sender, rewardAmount, block.number, now);
1619 
1620         emit Mint(msg.sender, rewardAmount, epochCounter, challengeNumber);
1621 
1622         return true;
1623     }
1624 
1625     /**
1626      * @dev override of the original function since we want to call the masternode contract remotely.
1627      */
1628     function _reward() internal returns(uint) {
1629 
1630         uint _pow = MasternodeContract.rewardsProofOfWork();
1631 
1632         tokenContract.rewardExternal(msg.sender, _pow);
1633 
1634         return _pow;
1635     }
1636 
1637     /**
1638      * @dev override of the original function since we want to call the masternode contract remotely.
1639      */
1640     function _reward_masternode() internal returns(uint) {
1641 
1642         uint _mnReward = MasternodeContract.rewardsMasternode();
1643         if (MasternodeContract.masternodeCounter() == 0) return 0;
1644 
1645         uint getCandidate = MasternodeContract.masternodeCandidate();
1646         address _mnCandidate = MasternodeContract.isPartOf(getCandidate);
1647         if (_mnCandidate == 0x0) return 0;
1648 
1649         tokenContract.rewardExternal(_mnCandidate, _mnReward);
1650 
1651         emit RewardMasternode(_mnCandidate, _mnReward);
1652 
1653         return _mnReward;
1654     }
1655     
1656     function getMiningReward() public view returns(uint) {
1657         return MasternodeContract.rewardsProofOfWork();
1658     }
1659 }
1660 
1661 
1662 /**
1663  * Burn some gas and create all contracts in a single call :-)
1664  */
1665 
1666 contract caelumFactory { 
1667 
1668     CaelumMiner public MINER;
1669     CaelumMasternode public MASTER;
1670     CaelumToken public TOKEN;
1671 
1672     function newCookie() public {
1673         MINER = new CaelumMiner();
1674         MASTER = new CaelumMasternode();
1675         TOKEN = new CaelumToken(0x0);
1676 
1677         MASTER.setMiningContract(MINER);
1678         MASTER.setTokenContract(TOKEN);
1679 
1680         MINER.setMasternodeContract(MASTER);
1681         MINER.setTokenContract(TOKEN);
1682 
1683         TOKEN.setMiningContract(MINER);
1684         TOKEN.setDataStorage(MASTER);
1685 
1686         MASTER.transferOwnership(msg.sender);
1687         TOKEN.transferOwnership(msg.sender);
1688         MINER.transferOwnership(msg.sender);
1689     }
1690 
1691 }