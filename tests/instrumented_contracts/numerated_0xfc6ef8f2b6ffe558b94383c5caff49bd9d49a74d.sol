1 pragma solidity 0.4.24;
2 
3 // File: contracts/EventRegistry.sol
4 
5 contract EventRegistry {
6     address[] verityEvents;
7     mapping(address => bool) verityEventsMap;
8 
9     mapping(address => address[]) userEvents;
10 
11     event NewVerityEvent(address eventAddress);
12 
13     function registerEvent() public {
14         verityEvents.push(msg.sender);
15         verityEventsMap[msg.sender] = true;
16         emit NewVerityEvent(msg.sender);
17     }
18 
19     function getUserEvents() public view returns(address[]) {
20         return userEvents[msg.sender];
21     }
22 
23     function addEventToUser(address _user) external {
24         require(verityEventsMap[msg.sender]);
25 
26         userEvents[_user].push(msg.sender);
27     }
28 
29     function getEventsLength() public view returns(uint) {
30         return verityEvents.length;
31     }
32 
33     function getEventsByIds(uint[] _ids) public view returns(uint[], address[]) {
34         address[] memory _events = new address[](_ids.length);
35 
36         for(uint i = 0; i < _ids.length; ++i) {
37             _events[i] = verityEvents[_ids[i]];
38         }
39 
40         return (_ids, _events);
41     }
42 
43     function getUserEventsLength(address _user)
44         public
45         view
46         returns(uint)
47     {
48         return userEvents[_user].length;
49     }
50 
51     function getUserEventsByIds(address _user, uint[] _ids)
52         public
53         view
54         returns(uint[], address[])
55     {
56         address[] memory _events = new address[](_ids.length);
57 
58         for(uint i = 0; i < _ids.length; ++i) {
59             _events[i] = userEvents[_user][_ids[i]];
60         }
61 
62         return (_ids, _events);
63     }
64 }
65 
66 // File: contracts/VerityToken.sol
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (a == 0) {
82       return 0;
83     }
84 
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * See https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev Total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev Transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender)
180     public view returns (uint256);
181 
182   function transferFrom(address from, address to, uint256 value)
183     public returns (bool);
184 
185   function approve(address spender, uint256 value) public returns (bool);
186   event Approval(
187     address indexed owner,
188     address indexed spender,
189     uint256 value
190   );
191 }
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/issues/20
198  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(
212     address _from,
213     address _to,
214     uint256 _value
215   )
216     public
217     returns (bool)
218   {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address _owner,
253     address _spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(
272     address _spender,
273     uint256 _addedValue
274   )
275     public
276     returns (bool)
277   {
278     allowed[msg.sender][_spender] = (
279       allowed[msg.sender][_spender].add(_addedValue));
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(
294     address _spender,
295     uint256 _subtractedValue
296   )
297     public
298     returns (bool)
299   {
300     uint256 oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue > oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310 }
311 
312 contract VerityToken is StandardToken {
313   string public name = "VerityToken";
314   string public symbol = "VTY";
315   uint8 public decimals = 18;
316   uint public INITIAL_SUPPLY = 500000000 * 10 ** uint(decimals);
317 
318   constructor() public {
319     totalSupply_ = INITIAL_SUPPLY;
320     balances[msg.sender] = INITIAL_SUPPLY;
321   }
322 }
323 
324 // File: contracts/VerityEvent.sol
325 
326 contract VerityEvent {
327     /// Contract's owner, used for permission management
328     address public owner;
329 
330     /// Token contract address, used for tokend distribution
331     address public tokenAddress;
332 
333     /// Event registry contract address
334     address public eventRegistryAddress;
335 
336     /// Designated validation nodes that will decide rewards.
337     address[] eventResolvers;
338 
339     /// - WaitingForRewards: Waiting for current master to set rewards.
340     /// - Validating: Master has set rewards. Vaiting for node validation.
341     /// - Finished: Either successfully validated or failed.
342     enum ValidationState {
343         WaitingForRewards,
344         Validating,
345         Finished
346     }
347     ValidationState validationState = ValidationState.WaitingForRewards;
348 
349     struct RewardsValidation {
350         address currentMasterNode;
351         string rewardsHash;
352         uint approvalCount;
353         uint rejectionCount;
354         string[] altHashes;
355         mapping(address => uint) votersRound;
356         mapping(string => address[]) altHashVotes;
357         mapping(string => bool) rejectedHashes;
358     }
359     RewardsValidation rewardsValidation;
360 
361     /// Round of validation. Increases by each failed validation
362     uint public rewardsValidationRound;
363 
364     /// A list of all the participating wallet addresses, implemented as a mapping
365     /// to provide constant lookup times.
366     mapping(address => bool) participants;
367     address[] participantsIndex;
368 
369     enum RewardType {
370         Ether,
371         Token
372     }
373     RewardType rewardType;
374 
375     /// A mapping of addresses to their assigned rewards
376     mapping(address => mapping(uint => uint)) rewards;
377     address[] rewardsIndex;
378 
379     /// Event application start time, users cannot apply to participate before it
380     uint applicationStartTime;
381 
382     /// Event application end time, users cannot apply after this time
383     uint applicationEndTime;
384 
385     /// Event actual start time, votes before this should not be accepted
386     uint eventStartTime;
387 
388     /// Event end time, it is calculated in the constructor
389     uint eventEndTime;
390 
391     /// Ipfs event data hash
392     string ipfsEventHash;
393 
394     /// Event name, here for informational use - not used otherwise
395     /// owner can recover tokens and ether after this time
396     uint leftoversRecoverableAfter;
397 
398     /// Amount of tokens that each user must stake before voting.
399     uint public stakingAmount;
400 
401     struct Dispute {
402         uint amount;
403         uint timeout;
404         uint round;
405         uint expiresAt;
406         uint multiplier;
407         mapping(address => bool) disputers;
408         address currentDisputer;
409     }
410     Dispute dispute;
411 
412     uint defaultDisputeTimeExtension = 1800; // 30 minutes
413 
414     string public eventName;
415 
416     /// Data feed hash, used for verification
417     string public dataFeedHash;
418 
419     bytes32[] results;
420 
421     enum RewardsDistribution {
422         Linear, // 0
423         Exponential // 1
424     }
425 
426     struct ConsensusRules {
427         uint minTotalVotes;
428         uint minConsensusVotes;
429         uint minConsensusRatio;
430         uint minParticipantRatio;
431         uint maxParticipants;
432         RewardsDistribution rewardsDistribution;
433     }
434     ConsensusRules consensusRules;
435 
436     /// Event's states
437     /// Events advance in the order defined here. Once the event reaches "Reward"
438     /// state, it cannot advance further.
439     /// Event states:
440     ///   - Waiting         -- Contract has been created, nothing is happening yet
441     ///   - Application     -- After applicationStartTime, the event advances here
442     ///                        new wallets can be added to the participats list during this state.
443     ///   - Running         -- Event is running, no new participants can be added
444     ///   - DisputeTimeout  -- Dispute possible
445     ///   - Reward          -- Participants can claim their payouts here - final state; can't be modified.
446     ///   - Failed          -- Event failed (no consensus, not enough users, timeout, ...) - final state; can't be modified
447     enum EventStates {
448         Waiting,
449         Application,
450         Running,
451         DisputeTimeout,
452         Reward,
453         Failed
454     }
455     EventStates eventState = EventStates.Waiting;
456 
457     event StateTransition(EventStates newState);
458     event JoinEvent(address wallet);
459     event ClaimReward(address recipient);
460     event Error(string description);
461     event EventFailed(string description);
462     event ValidationStarted(uint validationRound);
463     event ValidationRestart(uint validationRound);
464     event DisputeTriggered(address byAddress);
465     event ClaimStake(address recipient);
466 
467     constructor(
468         string _eventName,
469         uint _applicationStartTime,
470         uint _applicationEndTime,
471         uint _eventStartTime,
472         uint _eventRunTime, // in seconds
473         address _tokenAddress,
474         address _registry,
475         address[] _eventResolvers,
476         uint _leftoversRecoverableAfter, // with timestamp (in seconds)
477         uint[6] _consensusRules, // [minTotalVotes, minConsensusVotes, minConsensusRatio, minParticipantRatio, maxParticipants, distribution]
478         uint _stakingAmount,
479         uint[3] _disputeRules, // [dispute amount, dispute timeout, dispute multiplier]
480         string _ipfsEventHash
481     )
482         public
483         payable
484     {
485         require(_applicationStartTime < _applicationEndTime);
486         require(_eventStartTime > _applicationEndTime, "Event can't start before applications close.");
487 
488         applicationStartTime = _applicationStartTime;
489         applicationEndTime = _applicationEndTime;
490         tokenAddress = _tokenAddress;
491 
492         eventName = _eventName;
493         eventStartTime = _eventStartTime;
494         eventEndTime = _eventStartTime + _eventRunTime;
495 
496         eventResolvers = _eventResolvers;
497 
498         owner = msg.sender;
499         leftoversRecoverableAfter = _leftoversRecoverableAfter;
500 
501         rewardsValidationRound = 1;
502         rewardsValidation.currentMasterNode = eventResolvers[0];
503 
504         stakingAmount = _stakingAmount;
505 
506         ipfsEventHash = _ipfsEventHash;
507 
508         setConsensusRules(_consensusRules);
509         setDisputeData(_disputeRules);
510 
511         eventRegistryAddress = _registry;
512 
513         EventRegistry(eventRegistryAddress).registerEvent();
514     }
515 
516     /// A modifier signifiying that a certain method can only be used by the creator
517     /// of the contract.
518     /// Rollbacks the transaction on failure.
519     modifier onlyOwner() {
520         require(msg.sender == owner);
521         _;
522     }
523 
524     /// A modifier signifiying that rewards can be set only by the designated master node.
525     /// Rollbacks the transaction on failure.
526     modifier onlyCurrentMaster() {
527         require(
528             msg.sender == rewardsValidation.currentMasterNode,
529             "Not a designated master node."
530         );
531         _;
532     }
533 
534     ///	A modifier signifying that a certain method can only be used by a wallet
535     ///	marked as a participant.
536     ///	Rollbacks the transaction or failure.
537     modifier onlyParticipating() {
538         require(
539             isParticipating(msg.sender),
540             "Not participating."
541         );
542         _;
543     }
544 
545     /// A modifier signifying that a certain method can only be used when the event
546     /// is in a certain state.
547     /// @param _state The event's required state
548     /// Example:
549     /// 	function claimReward() onlyParticipanting onlyState(EventStates.Reward) {
550     /// 		// ... content
551     /// 	}
552     modifier onlyState(EventStates _state) {
553         require(
554             _state == eventState,
555             "Not possible in current event state."
556         );
557         _;
558     }
559 
560     /// A modifier taking care of all the timed state transitions.
561     /// Should always be used before all other modifiers, especially `onlyState`,
562     /// since it can change state.
563     /// Should probably be used in ALL non-constant (transaction) methods of
564     /// the contract.
565     modifier timedStateTransition() {
566         if (eventState == EventStates.Waiting && now >= applicationStartTime) {
567             advanceState();
568         }
569 
570         if (eventState == EventStates.Application && now >= applicationEndTime) {
571             if (participantsIndex.length < consensusRules.minTotalVotes) {
572                 markAsFailed("Not enough users joined for required minimum votes.");
573             } else {
574                 advanceState();
575             }
576         }
577 
578         if (eventState == EventStates.DisputeTimeout && now >= dispute.expiresAt) {
579             advanceState();
580         }
581         _;
582     }
583 
584     modifier onlyChangeableState() {
585         require(
586             uint(eventState) < uint(EventStates.Reward),
587             "Event state can't be modified anymore."
588         );
589         _;
590     }
591 
592     modifier onlyAfterLefroversCanBeRecovered() {
593         require(now >= leftoversRecoverableAfter);
594         _;
595     }
596 
597     modifier canValidateRewards(uint forRound) {
598         require(
599             isNode(msg.sender) && !isMasterNode(),
600             "Not a valid sender address."
601         );
602 
603         require(
604             validationState == ValidationState.Validating,
605             "Not validating rewards."
606         );
607 
608         require(
609             forRound == rewardsValidationRound,
610             "Validation round mismatch."
611         );
612 
613         require(
614             rewardsValidation.votersRound[msg.sender] < rewardsValidationRound,
615             "Already voted for this round."
616         );
617         _;
618     }
619 
620     /// Ensure we can receive money at any time.
621     /// Not used, but we might want to extend the reward fund while event is running.
622     function() public payable {}
623 
624     /// Apply for participation in this event.
625     /// Available only during the Application state.
626     /// A transaction to this function has to be done by the users themselves,
627     /// registering their wallet address as a participent.
628     /// The transaction does not have to include any funds.
629     function joinEvent()
630         public
631         timedStateTransition
632     {
633         if (isParticipating(msg.sender)) {
634             emit Error("You are already participating.");
635             return;
636         }
637 
638         if (eventState != EventStates.Application) {
639             emit Error("You can only join in the Application state.");
640             return;
641         }
642 
643         if (
644             stakingAmount > 0 &&
645             VerityToken(tokenAddress).allowance(msg.sender, address(this)) < stakingAmount
646         ) {
647             emit Error("Not enough tokens staked.");
648             return;
649         }
650 
651         if (stakingAmount > 0) {
652             VerityToken(tokenAddress).transferFrom(msg.sender, address(this), stakingAmount);
653         }
654         participants[msg.sender] = true;
655         participantsIndex.push(msg.sender);
656         EventRegistry(eventRegistryAddress).addEventToUser(msg.sender);
657         emit JoinEvent(msg.sender);
658     }
659 
660     /// Checks whether an address is participating in this event.
661     /// @param _user The addres to check for participation
662     /// @return {bool} Whether the given address is a participant of this event
663     function isParticipating(address _user) public view returns(bool) {
664         return participants[_user];
665     }
666 
667     function getParticipants() public view returns(address[]) {
668         return participantsIndex;
669     }
670 
671     function getEventTimes() public view returns(uint[5]) {
672         return [
673             applicationStartTime,
674             applicationEndTime,
675             eventStartTime,
676             eventEndTime,
677             leftoversRecoverableAfter
678         ];
679     }
680 
681     /// Assign the actual rewards.
682     /// Receives a list of addresses and a list rewards. Mapping between the two
683     /// is done by the addresses' and reward's numerical index in the list, so
684     /// order is important.
685     /// @param _addresses A list of addresses
686     /// @param _etherRewards A list of ether rewards, must be the exact same length as addresses
687     /// @param _tokenRewards A list of token rewards, must be the exact same length as addresses
688     function setRewards(
689         address[] _addresses,
690         uint[] _etherRewards,
691         uint[] _tokenRewards
692     )
693         public
694         onlyCurrentMaster
695         timedStateTransition
696         onlyState(EventStates.Running)
697     {
698         require(
699             _addresses.length == _etherRewards.length &&
700             _addresses.length == _tokenRewards.length
701         );
702 
703         require(
704             validationState == ValidationState.WaitingForRewards,
705             "Not possible in this validation state."
706         );
707 
708         for (uint i = 0; i < _addresses.length; ++i) {
709             rewards[_addresses[i]][uint(RewardType.Ether)] = _etherRewards[i];
710             rewards[_addresses[i]][uint(RewardType.Token)] = _tokenRewards[i];
711             rewardsIndex.push(_addresses[i]);
712         }
713     }
714 
715     /// Triggered by the master node once rewards are set and ready to validate
716     function markRewardsSet(string rewardsHash)
717         public
718         onlyCurrentMaster
719         timedStateTransition
720         onlyState(EventStates.Running)
721     {
722         require(
723             validationState == ValidationState.WaitingForRewards,
724             "Not possible in this validation state."
725         );
726 
727         rewardsValidation.rewardsHash = rewardsHash;
728         rewardsValidation.approvalCount = 1;
729         validationState = ValidationState.Validating;
730         emit ValidationStarted(rewardsValidationRound);
731     }
732 
733     /// Called by event resolver nodes if they agree with rewards
734     function approveRewards(uint validationRound)
735         public
736         onlyState(EventStates.Running)
737         canValidateRewards(validationRound)
738     {
739         ++rewardsValidation.approvalCount;
740         rewardsValidation.votersRound[msg.sender] = rewardsValidationRound;
741         checkApprovalRatio();
742     }
743 
744     /// Called by event resolvers if they don't agree with rewards
745     function rejectRewards(uint validationRound, string altHash)
746         public
747         onlyState(EventStates.Running)
748         canValidateRewards(validationRound)
749     {
750         ++rewardsValidation.rejectionCount;
751         rewardsValidation.votersRound[msg.sender] = rewardsValidationRound;
752 
753         if (!rewardsValidation.rejectedHashes[altHash]) {
754             rewardsValidation.altHashes.push(altHash);
755             rewardsValidation.altHashVotes[altHash].push(msg.sender);
756         }
757 
758         checkRejectionRatio();
759     }
760 
761     /// Trigger a dispute.
762     function triggerDispute()
763         public
764         timedStateTransition
765         onlyParticipating
766         onlyState(EventStates.DisputeTimeout)
767     {
768         require(
769             VerityToken(tokenAddress).allowance(msg.sender, address(this)) >=
770             dispute.amount * dispute.multiplier**dispute.round,
771             "Not enough tokens staked for dispute."
772         );
773 
774         require(
775             dispute.disputers[msg.sender] == false,
776             "Already triggered a dispute."
777         );
778 
779         /// Increase dispute amount for next dispute and store disputer
780         dispute.amount = dispute.amount * dispute.multiplier**dispute.round;
781         ++dispute.round;
782         dispute.disputers[msg.sender] = true;
783         dispute.currentDisputer = msg.sender;
784 
785         /// Transfer staked amount
786         VerityToken(tokenAddress).transferFrom(msg.sender, address(this), dispute.amount);
787 
788         /// Restart event
789         deleteValidationData();
790         deleteRewards();
791         eventState = EventStates.Application;
792         applicationEndTime = eventStartTime = now + defaultDisputeTimeExtension;
793         eventEndTime = eventStartTime + defaultDisputeTimeExtension;
794 
795         /// Make consensus rules stricter
796         /// Increases by ~10% of consensus diff
797         consensusRules.minConsensusRatio += (100 - consensusRules.minConsensusRatio) * 100 / 1000;
798         /// Increase total votes required my ~10% and consensus votes by consensus ratio
799         uint votesIncrease = consensusRules.minTotalVotes * 100 / 1000;
800         consensusRules.minTotalVotes += votesIncrease;
801         consensusRules.minConsensusVotes += votesIncrease * consensusRules.minConsensusRatio / 100;
802 
803         emit DisputeTriggered(msg.sender);
804     }
805 
806     /// Checks current approvals for threshold
807     function checkApprovalRatio() private {
808         if (approvalRatio() >= consensusRules.minConsensusRatio) {
809             validationState = ValidationState.Finished;
810             dispute.expiresAt = now + dispute.timeout;
811             advanceState();
812         }
813     }
814 
815     /// Checks current rejections for threshold
816     function checkRejectionRatio() private {
817         if (rejectionRatio() >= (100 - consensusRules.minConsensusRatio)) {
818             rejectCurrentValidation();
819         }
820     }
821 
822     /// Handle the rejection of current rewards
823     function rejectCurrentValidation() private {
824         rewardsValidation.rejectedHashes[rewardsValidation.rewardsHash] = true;
825 
826         // If approved votes are over the threshold all other hashes will also fail
827         if (
828             rewardsValidation.approvalCount + rewardsValidationRound - 1 >
829             rewardsValidation.rejectionCount - rewardsValidation.altHashes.length + 1
830         ) {
831             markAsFailed("Consensus can't be reached");
832         } else {
833             restartValidation();
834         }
835     }
836 
837     function restartValidation() private {
838         ++rewardsValidationRound;
839         rewardsValidation.currentMasterNode = rewardsValidation.altHashVotes[rewardsValidation.altHashes[0]][0];
840 
841         deleteValidationData();
842         deleteRewards();
843 
844         emit ValidationRestart(rewardsValidationRound);
845     }
846 
847     /// Delete rewards.
848     function deleteRewards() private {
849         for (uint j = 0; j < rewardsIndex.length; ++j) {
850             rewards[rewardsIndex[j]][uint(RewardType.Ether)] = 0;
851             rewards[rewardsIndex[j]][uint(RewardType.Token)] = 0;
852         }
853         delete rewardsIndex;
854     }
855 
856     /// Delete validation data
857     function deleteValidationData() private {
858         rewardsValidation.approvalCount = 0;
859         rewardsValidation.rejectionCount = 0;
860         for (uint i = 0; i < rewardsValidation.altHashes.length; ++i) {
861             delete rewardsValidation.altHashVotes[rewardsValidation.altHashes[i]];
862         }
863         delete rewardsValidation.altHashes;
864         validationState = ValidationState.WaitingForRewards;
865     }
866 
867     /// Ratio of nodes that approved of current hash
868     function approvalRatio() private view returns(uint) {
869         return rewardsValidation.approvalCount * 100 / eventResolvers.length;
870     }
871 
872     /// Ratio of nodes that rejected the current hash
873     function rejectionRatio() private view returns(uint) {
874         return rewardsValidation.rejectionCount * 100 / eventResolvers.length;
875     }
876 
877     /// Returns the whole array of event resolvers.
878     function getEventResolvers() public view returns(address[]) {
879         return eventResolvers;
880     }
881 
882     /// Checks if the address is current master node.
883     function isMasterNode() public view returns(bool) {
884         return rewardsValidation.currentMasterNode == msg.sender;
885     }
886 
887     function isNode(address node) private view returns(bool) {
888         for(uint i = 0; i < eventResolvers.length; ++i) {
889             if(eventResolvers[i] == node) {
890                 return true;
891             }
892         }
893         return false;
894     }
895 
896     /// Returns the calling user's assigned rewards. Can be 0.
897     /// Only available to participating users in the Reward state, since rewards
898     /// are not assigned before that.
899     function getReward()
900         public
901         view
902         returns(uint[2])
903     {
904         return [
905             rewards[msg.sender][uint(RewardType.Ether)],
906             rewards[msg.sender][uint(RewardType.Token)]
907         ];
908     }
909 
910     /// Returns all the addresses that have rewards set.
911     function getRewardsIndex() public view returns(address[]) {
912         return rewardsIndex;
913     }
914 
915     /// Returns rewards for specified addresses.
916     /// [[ethRewards, tokenRewards], [ethRewards, tokenRewards], ...]
917     function getRewards(address[] _addresses)
918         public
919         view
920         returns(uint[], uint[])
921     {
922         uint[] memory ethRewards = new uint[](_addresses.length);
923         uint[] memory tokenRewards = new uint[](_addresses.length);
924 
925         for(uint i = 0; i < _addresses.length; ++i) {
926             ethRewards[i] = rewards[_addresses[i]][uint(RewardType.Ether)];
927             tokenRewards[i] = rewards[_addresses[i]][uint(RewardType.Token)];
928         }
929 
930         return (ethRewards, tokenRewards);
931     }
932 
933     /// Claim a reward.
934     /// Needs to be called by the users themselves.
935     /// Only available in the Reward state, after rewards have been received from
936     /// the validation nodes.
937     function claimReward()
938         public
939         onlyParticipating
940         timedStateTransition
941         onlyState(EventStates.Reward)
942     {
943         uint etherReward = rewards[msg.sender][uint(RewardType.Ether)];
944         uint tokenReward = rewards[msg.sender][uint(RewardType.Token)];
945 
946         if (etherReward == 0 && tokenReward == 0) {
947             emit Error("You do not have any rewards to claim.");
948             return;
949         }
950 
951         if (
952             address(this).balance < rewards[msg.sender][uint(RewardType.Ether)] ||
953             VerityToken(tokenAddress).balanceOf(address(this)) < rewards[msg.sender][uint(RewardType.Token)]
954         ) {
955             emit Error("Critical error: not enough balance to pay out reward. Contact Verity.");
956             return;
957         }
958 
959         rewards[msg.sender][uint(RewardType.Ether)] = 0;
960         rewards[msg.sender][uint(RewardType.Token)] = 0;
961 
962         msg.sender.transfer(etherReward);
963         if (tokenReward > 0) {
964             VerityToken(tokenAddress).transfer(msg.sender, tokenReward);
965         }
966 
967         emit ClaimReward(msg.sender);
968     }
969 
970     function claimFailed()
971         public
972         onlyParticipating
973         timedStateTransition
974         onlyState(EventStates.Failed)
975     {
976         require(
977             stakingAmount > 0,
978             "No stake to claim"
979         );
980 
981         VerityToken(tokenAddress).transfer(msg.sender, stakingAmount);
982         participants[msg.sender] = false;
983         emit ClaimStake(msg.sender);
984     }
985 
986     function setDataFeedHash(string _hash) public onlyOwner {
987         dataFeedHash = _hash;
988     }
989 
990     function setResults(bytes32[] _results)
991         public
992         onlyCurrentMaster
993         timedStateTransition
994         onlyState(EventStates.Running)
995     {
996         results = _results;
997     }
998 
999     function getResults() public view returns(bytes32[]) {
1000         return results;
1001     }
1002 
1003     function getState() public view returns(uint) {
1004         return uint(eventState);
1005     }
1006 
1007     function getBalance() public view returns(uint[2]) {
1008         return [
1009             address(this).balance,
1010             VerityToken(tokenAddress).balanceOf(address(this))
1011         ];
1012     }
1013 
1014     /// Returns an array of consensus rules.
1015     /// [minTotalVotes, minConsensusVotes, minConsensusRatio, minParticipantRatio, maxParticipants]
1016     function getConsensusRules() public view returns(uint[6]) {
1017         return [
1018             consensusRules.minTotalVotes,
1019             consensusRules.minConsensusVotes,
1020             consensusRules.minConsensusRatio,
1021             consensusRules.minParticipantRatio,
1022             consensusRules.maxParticipants,
1023             uint(consensusRules.rewardsDistribution)
1024         ];
1025     }
1026 
1027     /// Returns an array of dispute rules.
1028     /// [dispute amount, dispute timeout, dispute round]
1029     function getDisputeData() public view returns(uint[4], address) {
1030         return ([
1031             dispute.amount,
1032             dispute.timeout,
1033             dispute.multiplier,
1034             dispute.round
1035         ], dispute.currentDisputer);
1036     }
1037 
1038     function recoverLeftovers()
1039         public
1040         onlyOwner
1041         onlyAfterLefroversCanBeRecovered
1042     {
1043         owner.transfer(address(this).balance);
1044         uint tokenBalance = VerityToken(tokenAddress).balanceOf(address(this));
1045         VerityToken(tokenAddress).transfer(owner, tokenBalance);
1046     }
1047 
1048     /// Advances the event's state to the next one. Only for internal use.
1049     function advanceState() private onlyChangeableState {
1050         eventState = EventStates(uint(eventState) + 1);
1051         emit StateTransition(eventState);
1052     }
1053 
1054     /// Sets consensus rules. For internal use only.
1055     function setConsensusRules(uint[6] rules) private {
1056         consensusRules.minTotalVotes = rules[0];
1057         consensusRules.minConsensusVotes = rules[1];
1058         consensusRules.minConsensusRatio = rules[2];
1059         consensusRules.minParticipantRatio = rules[3];
1060         consensusRules.maxParticipants = rules[4];
1061         consensusRules.rewardsDistribution = RewardsDistribution(rules[5]);
1062     }
1063 
1064     function markAsFailed(string description) private onlyChangeableState {
1065         eventState = EventStates.Failed;
1066         emit EventFailed(description);
1067     }
1068 
1069     function setDisputeData(uint[3] rules) private {
1070         uint _multiplier = rules[2];
1071         if (_multiplier <= 1) {
1072             _multiplier = 1;
1073         }
1074 
1075         dispute.amount = rules[0];
1076         dispute.timeout = rules[1];
1077         dispute.multiplier = _multiplier;
1078         dispute.round = 0;
1079     }
1080 }