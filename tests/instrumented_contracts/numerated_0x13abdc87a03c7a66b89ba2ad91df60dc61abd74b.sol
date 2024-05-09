1 /*
2 This file is part of WeiFund.
3 */
4 
5 /*
6 The core campaign contract interface. Used across all WeiFund standard campaign
7 contracts.
8 */
9 
10 pragma solidity ^0.4.4;
11 
12 
13 /// @title Campaign contract interface for WeiFund standard campaigns
14 /// @author Nick Dodson <nick.dodson@consensys.net>
15 contract Campaign {
16   /// @notice the creater and operator of the campaign
17   /// @return the Ethereum standard account address of the owner specified
18   function owner() public constant returns(address) {}
19 
20   /// @notice the campaign interface version
21   /// @return the version metadata
22   function version() public constant returns(string) {}
23 
24   /// @notice the campaign name
25   /// @return contractual metadata which specifies the campaign name as a string
26   function name() public constant returns(string) {}
27 
28   /// @notice use to determine the contribution method abi/structure
29   /// @return will return a string that is the exact contributeMethodABI
30   function contributeMethodABI() public constant returns(string) {}
31 
32   /// @notice use to determine the contribution method abi
33   /// @return will return a string that is the exact contributeMethodABI
34   function refundMethodABI() public constant returns(string) {}
35 
36   /// @notice use to determine the contribution method abi
37   /// @return will return a string that is the exact contributeMethodABI
38   function payoutMethodABI() public constant returns(string) {}
39 
40   /// @notice use to determine the beneficiary destination for the campaign
41   /// @return the beneficiary address that will receive the campaign payout
42   function beneficiary() public constant returns(address) {}
43 
44   /// @notice the block number at which the campaign fails or succeeds
45   /// @return the uint block number at which time the campaign expires
46   function expiry() public constant returns(uint256 blockNumber) {}
47 
48   /// @notice the goal the campaign must reach in order for it to succeed
49   /// @return the campaign funding goal specified in wei as a uint256
50   function fundingGoal() public constant returns(uint256 amount) {}
51 
52   /// @notice the maximum funding amount for this campaign
53   /// @return the campaign funding cap specified in wei as a uint256
54   function fundingCap() public constant returns(uint256 amount) {}
55 
56   /// @notice the goal the campaign must reach in order for it to succeed
57   /// @return the campaign funding goal specified in wei as a uint256
58   function amountRaised() public constant returns(uint256 amount) {}
59 
60   /// @notice the block number that the campaign was created
61   /// @return the campaign start block specified as a block number, uint256
62   function created() public constant returns(uint256 timestamp) {}
63 
64   /// @notice the current stage the campaign is in
65   /// @return the campaign stage the campaign is in with uint256
66   function stage() public constant returns(uint256);
67 
68   /// @notice if it supports it, return the contribution by ID
69   /// @return returns the contribution tx sender, value and time sent
70   function contributions(uint256 _contributionID) public constant returns(address _sender, uint256 _value, uint256 _time) {}
71 
72   // Campaign events
73   event ContributionMade (address _contributor);
74   event RefundPayoutClaimed(address _payoutDestination, uint256 _payoutAmount);
75   event BeneficiaryPayoutClaimed (address _payoutDestination);
76 }
77 
78 /*
79 This file is part of WeiFund.
80 */
81 
82 /*
83 The enhancer interface for the CampaignEnhancer contract.
84 */
85 
86 pragma solidity ^0.4.4;
87 
88 
89 /// @title The campaign enhancer interface contract for build enhancer contracts.
90 /// @author Nick Dodson <nick.dodson@consensys.net>
91 contract Enhancer {
92   /// @notice enables the setting of the campaign, if any
93   /// @dev allow the owner to set the campaign
94   function setCampaign(address _campaign) public {}
95 
96   /// @notice notate contribution
97   /// @param _sender The address of the contribution sender
98   /// @param _value The value of the contribution
99   /// @param _blockNumber The block number of the contribution
100   /// @param _amounts The specified contribution product amounts, if any
101   /// @return Whether or not the campaign is an early success after this contribution
102   /// @dev enables the notation of contribution data, and triggering of early success, if need be
103   function notate(address _sender, uint256 _value, uint256 _blockNumber, uint256[] _amounts) public returns (bool earlySuccess) {}
104 }
105 
106 /*
107 This file is part of WeiFund.
108 */
109 
110 /*
111 A common Owned contract that contains properties for contract ownership.
112 */
113 
114 pragma solidity ^0.4.4;
115 
116 
117 /// @title A single owned campaign contract for instantiating ownership properties.
118 /// @author Nick Dodson <nick.dodson@consensys.net>
119 contract Owned {
120   // only the owner can use this method
121   modifier onlyowner() {
122     if (msg.sender != owner) {
123       throw;
124     }
125 
126     _;
127   }
128 
129   // the owner property
130   address public owner;
131 }
132 /*
133 This file is part of WeiFund.
134 */
135 
136 /*
137 This is the standard claim contract interface. This used accross all claim
138 contracts. Claim contracts are used for the pickup of digital assets, such as tokens.
139 Note, a campaign enhancer could be a claim as well. This is our general
140 claim interface.
141 */
142 
143 pragma solidity ^0.4.4;
144 
145 
146 /// @title Claim contract interface.
147 /// @author Nick Dodson <nick.dodson@consensys.net>
148 contract Claim {
149   /// @return returns the claim ABI solidity method for this claim
150   function claimMethodABI() constant public returns (string) {}
151 
152   // the claim success event, used for whent he claim has successfully be used
153   event ClaimSuccess(address _sender);
154 }
155 /*
156 This file is part of WeiFund.
157 */
158 
159 /*
160 The balance claim is used for dispersing balances of refunds for standard
161 camaign contracts. Instead of the contract sending a balance directly to the
162 contributor, it will send the balance to a balancelciam contract.
163 */
164 
165 pragma solidity ^0.4.4;
166 
167 
168 /// @title The balance claim interface contract, used for defining balance claims.
169 /// @author Nick Dodson <nick.dodson@consensys.net>
170 contract BalanceClaimInterface {
171   /// @dev used to claim balance of the balance claim
172   function claimBalance() public {}
173 }
174 
175 
176 /// @title The balance claim, used for sending balances owed to a claim contract.
177 /// @author Nick Dodson <nick.dodson@consensys.net>
178 contract BalanceClaim is Owned, Claim, BalanceClaimInterface {
179   /// @notice receive funds
180   function () payable public {}
181 
182   /// @dev the claim balance method, claim the balance then suicide the contract
183   function claimBalance() onlyowner public {
184     // self destruct and send all funds to the balance claim owner
185     selfdestruct(owner);
186   }
187 
188   /// @notice The BalanceClaim constructor method
189   /// @param _owner the address of the balance claim owner
190   function BalanceClaim(address _owner) {
191     // specify the balance claim owner
192     owner = _owner;
193   }
194 
195   // the claim method ABI metadata for user interfaces, written in standard
196   // solidity ABI method format
197   string constant public claimMethodABI = "claimBalance()";
198 }
199 
200 /*
201 This file is part of WeiFund.
202 */
203 
204 /*
205 The private service registry is used in WeiFund factory contracts to register
206 generated service contracts, such as our WeiFund standard campaign and enhanced
207 standard campaign contracts. It is usually only inherited by other contracts.
208 */
209 
210 pragma solidity ^0.4.4;
211 
212 
213 /// @title Private Service Registry - used to register generated service contracts.
214 /// @author Nick Dodson <nick.dodson@consensys.net>
215 contract PrivateServiceRegistryInterface {
216   /// @notice register the service '_service' with the private service registry
217   /// @param _service the service contract to be registered
218   /// @return the service ID 'serviceId'
219   function register(address _service) internal returns (uint256 serviceId) {}
220 
221   /// @notice is the service in question '_service' a registered service with this registry
222   /// @param _service the service contract address
223   /// @return either yes (true) the service is registered or no (false) the service is not
224   function isService(address _service) public constant returns (bool) {}
225 
226   /// @notice helps to get service address
227   /// @param _serviceId the service ID
228   /// @return returns the service address of service ID
229   function services(uint256 _serviceId) public constant returns (address _service) {}
230 
231   /// @notice returns the id of a service address, if any
232   /// @param _service the service contract address
233   /// @return the service id of a service
234   function ids(address _service) public constant returns (uint256 serviceId) {}
235 
236   event ServiceRegistered(address _sender, address _service);
237 }
238 
239 contract PrivateServiceRegistry is PrivateServiceRegistryInterface {
240 
241   modifier isRegisteredService(address _service) {
242     // does the service exist in the registry, is the service address not empty
243     if (services.length > 0) {
244       if (services[ids[_service]] == _service && _service != address(0)) {
245         _;
246       }
247     }
248   }
249 
250   modifier isNotRegisteredService(address _service) {
251     // if the service '_service' is not a registered service
252     if (!isService(_service)) {
253       _;
254     }
255   }
256 
257   function register(address _service)
258     internal
259     isNotRegisteredService(_service)
260     returns (uint serviceId) {
261     // create service ID by increasing services length
262     serviceId = services.length++;
263 
264     // set the new service ID to the '_service' address
265     services[serviceId] = _service;
266 
267     // set the ids store to link to the 'serviceId' created
268     ids[_service] = serviceId;
269 
270     // fire the 'ServiceRegistered' event
271     ServiceRegistered(msg.sender, _service);
272   }
273 
274   function isService(address _service)
275     public
276     constant
277     isRegisteredService(_service)
278     returns (bool) {
279     return true;
280   }
281 
282   address[] public services;
283   mapping(address => uint256) public ids;
284 }
285 
286 
287 /*
288 This file is part of WeiFund.
289 */
290 
291 /*
292 This file is part of WeiFund.
293 */
294 
295 /*
296 Standard enhanced campaign for WeiFund. A generic crowdsale mechanism for
297 issuing and dispersing digital assets on Ethereum.
298 */
299 
300 pragma solidity ^0.4.4;
301 
302 /*
303 Interfaces
304 */
305 
306 /*
307 Specified Contracts
308 */
309 
310 
311 /// @title Standard Campaign -- enables generic crowdsales that disperse digital assets
312 /// @author Nick Dodson <nick.dodson@consensys.net>
313 contract StandardCampaign is Owned, Campaign {
314   // the three possible states
315   enum Stages {
316     CrowdfundOperational,
317     CrowdfundFailure,
318     CrowdfundSuccess
319   }
320 
321   // the campaign state machine enforcement
322   modifier atStage(Stages _expectedStage) {
323     // if the current state does not equal the expected one, throw
324     if (stage() != uint256(_expectedStage)) {
325       throw;
326     } else {
327       // continue with state changing operations
328       _;
329     }
330   }
331 
332   // if the contribution is valid, then carry on with state changing operations
333   // notate the contribution with the enhancer, if the notation method
334   // returns true, then trigger an early success (e.g. token cap reached)
335   modifier validContribution() {
336     // if the msg value is zero or amount raised plus the curent message value
337     // is greater than the funding cap, then throw error
338     if (msg.value == 0
339       || amountRaised + msg.value > fundingCap
340       || amountRaised + msg.value < amountRaised) {
341       throw;
342     } else {
343       // carry on with state changing operations
344       _;
345     }
346   }
347 
348   // if the contribution is a valid refund claim, then carry on with state
349   // changing operations
350   modifier validRefundClaim(uint256 _contributionID) {
351     // get the contribution data for the refund
352     Contribution refundContribution = contributions[_contributionID];
353 
354     // if the refund has already been claimed or the refund sender is not the
355     // current message sender, throw error
356     if(refundsClaimed[_contributionID] == true // the refund for this contribution is not claimed
357       || refundContribution.sender != msg.sender){ // the contribution sender is the msg.sender
358       throw;
359     } else {
360       // all is good, carry on with state changing operations
361       _;
362     }
363   }
364 
365   // only the beneficiary can use the method with this modifier
366   modifier onlybeneficiary() {
367     if (msg.sender != beneficiary) {
368       throw;
369     } else {
370       _;
371     }
372   }
373 
374   // allow for fallback function to be used to make contributions
375   function () public payable {
376     contributeMsgValue(defaultAmounts);
377   }
378 
379   // the current campaign stage
380   function stage() public constant returns (uint256) {
381     // if current time is less than the expiry, the crowdfund is operational
382     if (block.number < expiry
383       && earlySuccess == false
384       && amountRaised < fundingCap) {
385       return uint256(Stages.CrowdfundOperational);
386 
387     // if n >= e and aR < fG then the crowdfund is a failure
388     } else if(block.number >= expiry
389       && earlySuccess == false
390       && amountRaised < fundingGoal) {
391       return uint256(Stages.CrowdfundFailure);
392 
393     // if n >= e and aR >= fG or aR >= fC or early success triggered
394     // then the crowdfund is a success (enhancers can trigger early success)
395     // early success is generally used for TokenCap enforcement
396     } else if((block.number >= expiry && amountRaised >= fundingGoal)
397       || earlySuccess == true
398       || amountRaised >= fundingCap) {
399       return uint256(Stages.CrowdfundSuccess);
400     }
401   }
402 
403   // contribute message value if the contribution is valid and the campaign
404   // is in stage operational, allow for complex amounts to be transacted
405   function contributeMsgValue(uint256[] _amounts)
406     public // anyone can attempt to use this method
407     payable // the method is payable and can accept ether
408     atStage(Stages.CrowdfundOperational) // must be at stage operational, done before validContribution
409     validContribution() // contribution must be valid, stage check done first
410     returns (uint256 contributionID) {
411     // increase contributions array length by 1, set as contribution ID
412     contributionID = contributions.length++;
413 
414     // store contribution data in the contributions array
415     contributions[contributionID] = Contribution({
416         sender: msg.sender,
417         value: msg.value,
418         created: block.number
419     });
420 
421     // add the contribution ID to that senders address
422     contributionsBySender[msg.sender].push(contributionID);
423 
424     // increase the amount raised by the message value
425     amountRaised += msg.value;
426 
427     // fire the contribution made event
428     ContributionMade(msg.sender);
429 
430     // notate the contribution with the campaign enhancer, if the notation
431     // method returns true, then trigger an early success
432     // the enahncer is treated as malicious here, and is thus wrapped in a
433     // conditional for saftey, note the enhancer may throw as well
434     if (enhancer.notate(msg.sender, msg.value, block.number, _amounts)) {
435       // set early success to true, note, it cannot be reversed once set to true
436       // also validContribution must be after atStage modifier
437       // so that early success is triggered after stage check, not before
438       // early success is used to trigger an early campaign success before the funding
439       // cap is reached. This is generally used for things like hitting the token cap
440       earlySuccess = true;
441     }
442   }
443 
444   // payout the current balance to the beneficiary, if the crowdfund is in
445   // stage success
446   function payoutToBeneficiary() public onlybeneficiary() {
447     // additionally trigger early success, this will force the Success state
448     // forcing the success state keeps the contract state machine rigid
449     // and ensures other third-party contracts that look to this state
450     // that this contract is in state success
451     earlySuccess = true;
452 
453     // send funds to the benerifiary
454     if (!beneficiary.send(this.balance)) {
455       throw;
456     } else {
457       // fire the BeneficiaryPayoutClaimed event
458       BeneficiaryPayoutClaimed(beneficiary);
459     }
460   }
461 
462   // claim refund owed if you are a contributor and the campaign is in stage
463   // failure. Only valid claims will be fulfilled.
464   // will return the balance claim address where funds can be picked up by
465   // contributor. A BalanceClaim is used to further prevent re-entrancy.
466   function claimRefundOwed(uint256 _contributionID)
467     public
468     atStage(Stages.CrowdfundFailure) // in stage failure
469     validRefundClaim(_contributionID) // the claim is a valid refund claim
470     returns (address balanceClaim) { // return the balance claim address
471     // set claimed to true right away
472     refundsClaimed[_contributionID] = true;
473 
474     // get the contribution data for that contribution ID
475     Contribution refundContribution = contributions[_contributionID];
476 
477     // send funds to the newly created balance claim contract
478     balanceClaim = address(new BalanceClaim(refundContribution.sender));
479 
480     // set refunds claim address
481     refundClaimAddress[_contributionID] = balanceClaim;
482 
483     // send funds to the newly created balance claim contract
484     if (!balanceClaim.send(refundContribution.value)) {
485       throw;
486     }
487 
488     // fire the refund payed out event
489     RefundPayoutClaimed(balanceClaim, refundContribution.value);
490   }
491 
492   // the total number of valid contributions made to this campaign
493   function totalContributions() public constant returns (uint256 amount) {
494     return uint256(contributions.length);
495   }
496 
497   // get the total number of contributions made a sender
498   function totalContributionsBySender(address _sender)
499     public
500     constant
501     returns (uint256 amount) {
502     return uint256(contributionsBySender[_sender].length);
503   }
504 
505   // the contract constructor
506   function StandardCampaign(string _name,
507     uint256 _expiry,
508     uint256 _fundingGoal,
509     uint256 _fundingCap,
510     address _beneficiary,
511     address _owner,
512     address _enhancer) public {
513     // set the campaign name
514     name = _name;
515 
516     // the campaign expiry in blocks
517     expiry = _expiry;
518 
519     // the fundign goal in wei
520     fundingGoal = _fundingGoal;
521 
522     // the campaign funding cap in wei
523     fundingCap = _fundingCap;
524 
525     // the benerifiary address
526     beneficiary = _beneficiary;
527 
528     // the owner or operator of the campaign
529     owner = _owner;
530 
531     // the time the campaign was created
532     created = block.number;
533 
534     // the campaign enhancer contract
535     enhancer = Enhancer(_enhancer);
536   }
537 
538   // the Contribution data structure
539   struct Contribution {
540     // the contribution sender
541     address sender;
542 
543     // the value of the contribution
544     uint256 value;
545 
546     // the time the contribution was created
547     uint256 created;
548   }
549 
550   // default amounts used
551   uint256[] defaultAmounts;
552 
553   // campaign enhancer, usually for token notation
554   Enhancer public enhancer;
555 
556   // the early success bool, used for triggering early success
557   bool public earlySuccess;
558 
559   // the operator of the campaign
560   address public owner;
561 
562   // the minimum amount of funds needed to be a success after expiry (in wei)
563   uint256 public fundingGoal;
564 
565   // the maximum amount of funds that can be raised (in wei)
566   uint256 public fundingCap;
567 
568   // the total amount raised by this campaign (in wei)
569   uint256 public amountRaised;
570 
571   // the current campaign expiry (future block number)
572   uint256 public expiry;
573 
574   // the time at which the campaign was created (in UNIX timestamp)
575   uint256 public created;
576 
577   // the beneficiary of the funds raised, if the campaign is a success
578   address public beneficiary;
579 
580   // the contributions data store, where all contributions are notated
581   Contribution[] public contributions;
582 
583   // all contribution ID's of a specific sender
584   mapping(address => uint256[]) public contributionsBySender;
585 
586   // the refund BalanceClaim address of a specific refund claim
587   // maps the (contribution ID => refund claim address)
588   mapping(uint256 => address) public refundClaimAddress;
589 
590   // maps the contribution ID to a bool (has the refund been claimed for this
591   // contribution)
592   mapping(uint256 => bool) public refundsClaimed;
593 
594   // the human readable name of the Campaign, for metadata
595   string public name;
596 
597   // the contract version number, if any
598   string constant public version = "0.1.0";
599 
600   // the contribution method ABI as a string, written in standard solidity
601   // ABI format, this is generally used so that UI's can understand the campaign
602   string constant public contributeMethodABI = "contributeMsgValue(uint256[]):(uint256)";
603 
604   // the payout to beneficiary ABI, written in standard solidity ABI format
605   string constant public payoutMethodABI = "payoutToBeneficiary()";
606 
607   // the refund method ABI, written in standard solidity ABI format
608   string constant public refundMethodABI = "claimRefundOwed(uint256):(address)";
609 }
610 
611 /*
612 This file is part of WeiFund.
613 */
614 
615 /*
616 An empty campaign enhancer, used to fulfill an enhancer of a WeiFund enhanced
617 standard campaign.
618 */
619 
620 pragma solidity ^0.4.4;
621 
622 
623 /// @title Empty Enhancer - used to test enhanced standard campaign contracts
624 /// @author Nick Dodson <nick.dodson@consensys.net>
625 contract EmptyEnhancer is Enhancer {
626   /// @dev notate contribution data, and trigger early success if need be
627   function notate(address _sender, uint256 _value, uint256 _blockNumber, uint256[] _amounts)
628   public
629   returns (bool earlySuccess) {
630     return false;
631   }
632 }
633 
634 
635 /*
636 A factory contract used for the generation and registration of WeiFund enhanced
637 standard campaign contracts.
638 */
639 
640 pragma solidity ^0.4.4;
641 
642 
643 /// @title Enhanced Standard Campaign Factory - used to generate and register standard campaigns
644 /// @author Nick Dodson <nick.dodson@consensys.net>
645 contract StandardCampaignFactory is PrivateServiceRegistry {
646   function createStandardCampaign(string _name,
647     uint256 _expiry,
648     uint256 _fundingGoal,
649     uint256 _fundingCap,
650     address _beneficiary,
651     address _enhancer) public returns (address campaignAddress) {
652     // create the new enhanced standard campaign
653     campaignAddress = address(new StandardCampaign(_name,
654       _expiry,
655       _fundingGoal,
656       _fundingCap,
657       _beneficiary,
658       msg.sender,
659       _enhancer));
660 
661     // register the campaign address
662     register(campaignAddress);
663   }
664 }