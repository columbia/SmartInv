1 pragma solidity 0.4.18;
2 contract Token {
3     /* This is a slight change to the ERC20 base standard.
4     function totalSupply() constant returns (uint256 supply);
5     is replaced with:
6     uint256 public totalSupply;
7     This automatically creates a getter function for the totalSupply.
8     This is moved to the base contract since public getter functions are not
9     currently recognised as an implementation of the matching abstract
10     function by the compiler.
11     */
12     /// total amount of tokens
13     uint256 public totalSupply;
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success);
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31 
32     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of tokens to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         //Default assumes totalSupply can't be over max (2^256 - 1).
51         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
52         //Replace the if with this one instead.
53         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
54         if (balances[msg.sender] >= _value && _value > 0) {
55             balances[msg.sender] -= _value;
56             balances[_to] += _value;
57             Transfer(msg.sender, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             allowed[_from][msg.sender] -= _value;
69             Transfer(_from, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 }
91 
92 contract HumanStandardToken is StandardToken {
93 
94     /* Public variables of the token */
95 
96     /*
97     NOTE:
98     The following variables are OPTIONAL vanities. One does not have to include them.
99     They allow one to customise the token contract & in no way influences the core functionality.
100     Some wallets/interfaces might not even bother to look at this information.
101     */
102     string public name;                   //fancy name: eg Simon Bucks
103     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
104     string public symbol;                 //An identifier: eg SBX
105     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
106 
107     function HumanStandardToken(
108         uint256 _initialAmount,
109         string _tokenName,
110         uint8 _decimalUnits,
111         string _tokenSymbol
112         ) {
113         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
114         totalSupply = _initialAmount;                        // Update total supply
115         name = _tokenName;                                   // Set the name for display purposes
116         decimals = _decimalUnits;                            // Amount of decimals for display purposes
117         symbol = _tokenSymbol;                               // Set the symbol for display purposes
118     }
119 
120     /* Approves and then calls the receiving contract */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124 
125         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
126         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
127         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
128         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
129         return true;
130     }
131 }
132 
133 /// @title StandardBounties
134 /// @dev Used to pay out individuals or groups for task fulfillment through
135 /// stepwise work submission, acceptance, and payment
136 /// @author Mark Beylin <mark.beylin@consensys.net>, Gonçalo Sá <goncalo.sa@consensys.net>
137 contract StandardBounties {
138 
139   /*
140    * Events
141    */
142   event BountyIssued(uint bountyId);
143   event BountyActivated(uint bountyId, address issuer);
144   event BountyFulfilled(uint bountyId, address indexed fulfiller, uint256 indexed _fulfillmentId);
145   event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId);
146   event FulfillmentAccepted(uint bountyId, address indexed fulfiller, uint256 indexed _fulfillmentId);
147   event BountyKilled(uint bountyId, address indexed issuer);
148   event ContributionAdded(uint bountyId, address indexed contributor, uint256 value);
149   event DeadlineExtended(uint bountyId, uint newDeadline);
150   event BountyChanged(uint bountyId);
151   event IssuerTransferred(uint _bountyId, address indexed _newIssuer);
152   event PayoutIncreased(uint _bountyId, uint _newFulfillmentAmount);
153 
154 
155   /*
156    * Storage
157    */
158 
159   address public owner;
160 
161   Bounty[] public bounties;
162 
163   mapping(uint=>Fulfillment[]) fulfillments;
164   mapping(uint=>uint) numAccepted;
165   mapping(uint=>HumanStandardToken) tokenContracts;
166 
167   /*
168    * Enums
169    */
170 
171   enum BountyStages {
172       Draft,
173       Active,
174       Dead
175   }
176 
177   /*
178    * Structs
179    */
180 
181   struct Bounty {
182       address issuer;
183       uint deadline;
184       string data;
185       uint fulfillmentAmount;
186       address arbiter;
187       bool paysTokens;
188       BountyStages bountyStage;
189       uint balance;
190   }
191 
192   struct Fulfillment {
193       bool accepted;
194       address fulfiller;
195       string data;
196   }
197 
198   /*
199    * Modifiers
200    */
201 
202   modifier validateNotTooManyBounties(){
203     require((bounties.length + 1) > bounties.length);
204     _;
205   }
206 
207   modifier validateNotTooManyFulfillments(uint _bountyId){
208     require((fulfillments[_bountyId].length + 1) > fulfillments[_bountyId].length);
209     _;
210   }
211 
212   modifier validateBountyArrayIndex(uint _bountyId){
213     require(_bountyId < bounties.length);
214     _;
215   }
216 
217   modifier onlyIssuer(uint _bountyId) {
218       require(msg.sender == bounties[_bountyId].issuer);
219       _;
220   }
221 
222   modifier onlyFulfiller(uint _bountyId, uint _fulfillmentId) {
223       require(msg.sender == fulfillments[_bountyId][_fulfillmentId].fulfiller);
224       _;
225   }
226 
227   modifier amountIsNotZero(uint _amount) {
228       require(_amount != 0);
229       _;
230   }
231 
232   modifier transferredAmountEqualsValue(uint _bountyId, uint _amount) {
233       if (bounties[_bountyId].paysTokens){
234         require(msg.value == 0);
235         uint oldBalance = tokenContracts[_bountyId].balanceOf(this);
236         if (_amount != 0){
237           require(tokenContracts[_bountyId].transferFrom(msg.sender, this, _amount));
238         }
239         require((tokenContracts[_bountyId].balanceOf(this) - oldBalance) == _amount);
240 
241       } else {
242         require((_amount * 1 wei) == msg.value);
243       }
244       _;
245   }
246 
247   modifier isBeforeDeadline(uint _bountyId) {
248       require(now < bounties[_bountyId].deadline);
249       _;
250   }
251 
252   modifier validateDeadline(uint _newDeadline) {
253       require(_newDeadline > now);
254       _;
255   }
256 
257   modifier isAtStage(uint _bountyId, BountyStages _desiredStage) {
258       require(bounties[_bountyId].bountyStage == _desiredStage);
259       _;
260   }
261 
262   modifier validateFulfillmentArrayIndex(uint _bountyId, uint _index) {
263       require(_index < fulfillments[_bountyId].length);
264       _;
265   }
266 
267   modifier notYetAccepted(uint _bountyId, uint _fulfillmentId){
268       require(fulfillments[_bountyId][_fulfillmentId].accepted == false);
269       _;
270   }
271 
272   /*
273    * Public functions
274    */
275 
276 
277   /// @dev StandardBounties(): instantiates
278   /// @param _owner the issuer of the standardbounties contract, who has the
279   /// ability to remove bounties
280   function StandardBounties(address _owner)
281       public
282   {
283       owner = _owner;
284   }
285 
286   /// @dev issueBounty(): instantiates a new draft bounty
287   /// @param _issuer the address of the intended issuer of the bounty
288   /// @param _deadline the unix timestamp after which fulfillments will no longer be accepted
289   /// @param _data the requirements of the bounty
290   /// @param _fulfillmentAmount the amount of wei to be paid out for each successful fulfillment
291   /// @param _arbiter the address of the arbiter who can mediate claims
292   /// @param _paysTokens whether the bounty pays in tokens or in ETH
293   /// @param _tokenContract the address of the contract if _paysTokens is true
294   function issueBounty(
295       address _issuer,
296       uint _deadline,
297       string _data,
298       uint256 _fulfillmentAmount,
299       address _arbiter,
300       bool _paysTokens,
301       address _tokenContract
302   )
303       public
304       validateDeadline(_deadline)
305       amountIsNotZero(_fulfillmentAmount)
306       validateNotTooManyBounties
307       returns (uint)
308   {
309       bounties.push(Bounty(_issuer, _deadline, _data, _fulfillmentAmount, _arbiter, _paysTokens, BountyStages.Draft, 0));
310       if (_paysTokens){
311         tokenContracts[bounties.length - 1] = HumanStandardToken(_tokenContract);
312       }
313       BountyIssued(bounties.length - 1);
314       return (bounties.length - 1);
315   }
316 
317   /// @dev issueAndActivateBounty(): instantiates a new draft bounty
318   /// @param _issuer the address of the intended issuer of the bounty
319   /// @param _deadline the unix timestamp after which fulfillments will no longer be accepted
320   /// @param _data the requirements of the bounty
321   /// @param _fulfillmentAmount the amount of wei to be paid out for each successful fulfillment
322   /// @param _arbiter the address of the arbiter who can mediate claims
323   /// @param _paysTokens whether the bounty pays in tokens or in ETH
324   /// @param _tokenContract the address of the contract if _paysTokens is true
325   /// @param _value the total number of tokens being deposited upon activation
326   function issueAndActivateBounty(
327       address _issuer,
328       uint _deadline,
329       string _data,
330       uint256 _fulfillmentAmount,
331       address _arbiter,
332       bool _paysTokens,
333       address _tokenContract,
334       uint256 _value
335   )
336       public
337       payable
338       validateDeadline(_deadline)
339       amountIsNotZero(_fulfillmentAmount)
340       validateNotTooManyBounties
341       returns (uint)
342   {
343       require (_value >= _fulfillmentAmount);
344       if (_paysTokens){
345         require(msg.value == 0);
346         tokenContracts[bounties.length] = HumanStandardToken(_tokenContract);
347         require(tokenContracts[bounties.length].transferFrom(msg.sender, this, _value));
348       } else {
349         require((_value * 1 wei) == msg.value);
350       }
351       bounties.push(Bounty(_issuer,
352                             _deadline,
353                             _data,
354                             _fulfillmentAmount,
355                             _arbiter,
356                             _paysTokens,
357                             BountyStages.Active,
358                             _value));
359       BountyIssued(bounties.length - 1);
360       ContributionAdded(bounties.length - 1, msg.sender, _value);
361       BountyActivated(bounties.length - 1, msg.sender);
362       return (bounties.length - 1);
363   }
364 
365   modifier isNotDead(uint _bountyId) {
366       require(bounties[_bountyId].bountyStage != BountyStages.Dead);
367       _;
368   }
369 
370   /// @dev contribute(): a function allowing anyone to contribute tokens to a
371   /// bounty, as long as it is still before its deadline. Shouldn't keep
372   /// them by accident (hence 'value').
373   /// @param _bountyId the index of the bounty
374   /// @param _value the amount being contributed in ether to prevent accidental deposits
375   /// @notice Please note you funds will be at the mercy of the issuer
376   ///  and can be drained at any moment. Be careful!
377   function contribute (uint _bountyId, uint _value)
378       payable
379       public
380       validateBountyArrayIndex(_bountyId)
381       isBeforeDeadline(_bountyId)
382       isNotDead(_bountyId)
383       amountIsNotZero(_value)
384       transferredAmountEqualsValue(_bountyId, _value)
385   {
386       bounties[_bountyId].balance += _value;
387 
388       ContributionAdded(_bountyId, msg.sender, _value);
389   }
390 
391   /// @notice Send funds to activate the bug bounty
392   /// @dev activateBounty(): activate a bounty so it may pay out
393   /// @param _bountyId the index of the bounty
394   /// @param _value the amount being contributed in ether to prevent
395   /// accidental deposits
396   function activateBounty(uint _bountyId, uint _value)
397       payable
398       public
399       validateBountyArrayIndex(_bountyId)
400       isBeforeDeadline(_bountyId)
401       onlyIssuer(_bountyId)
402       transferredAmountEqualsValue(_bountyId, _value)
403   {
404       bounties[_bountyId].balance += _value;
405       require (bounties[_bountyId].balance >= bounties[_bountyId].fulfillmentAmount);
406       transitionToState(_bountyId, BountyStages.Active);
407 
408       ContributionAdded(_bountyId, msg.sender, _value);
409       BountyActivated(_bountyId, msg.sender);
410   }
411 
412   modifier notIssuerOrArbiter(uint _bountyId) {
413       require(msg.sender != bounties[_bountyId].issuer && msg.sender != bounties[_bountyId].arbiter);
414       _;
415   }
416 
417   /// @dev fulfillBounty(): submit a fulfillment for the given bounty
418   /// @param _bountyId the index of the bounty
419   /// @param _data the data artifacts representing the fulfillment of the bounty
420   function fulfillBounty(uint _bountyId, string _data)
421       public
422       validateBountyArrayIndex(_bountyId)
423       validateNotTooManyFulfillments(_bountyId)
424       isAtStage(_bountyId, BountyStages.Active)
425       isBeforeDeadline(_bountyId)
426       notIssuerOrArbiter(_bountyId)
427   {
428       fulfillments[_bountyId].push(Fulfillment(false, msg.sender, _data));
429 
430       BountyFulfilled(_bountyId, msg.sender, (fulfillments[_bountyId].length - 1));
431   }
432 
433   /// @dev updateFulfillment(): Submit updated data for a given fulfillment
434   /// @param _bountyId the index of the bounty
435   /// @param _fulfillmentId the index of the fulfillment
436   /// @param _data the new data being submitted
437   function updateFulfillment(uint _bountyId, uint _fulfillmentId, string _data)
438       public
439       validateBountyArrayIndex(_bountyId)
440       validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
441       onlyFulfiller(_bountyId, _fulfillmentId)
442       notYetAccepted(_bountyId, _fulfillmentId)
443   {
444       fulfillments[_bountyId][_fulfillmentId].data = _data;
445       FulfillmentUpdated(_bountyId, _fulfillmentId);
446   }
447 
448   modifier onlyIssuerOrArbiter(uint _bountyId) {
449       require(msg.sender == bounties[_bountyId].issuer ||
450          (msg.sender == bounties[_bountyId].arbiter && bounties[_bountyId].arbiter != address(0)));
451       _;
452   }
453 
454   modifier fulfillmentNotYetAccepted(uint _bountyId, uint _fulfillmentId) {
455       require(fulfillments[_bountyId][_fulfillmentId].accepted == false);
456       _;
457   }
458 
459   modifier enoughFundsToPay(uint _bountyId) {
460       require(bounties[_bountyId].balance >= bounties[_bountyId].fulfillmentAmount);
461       _;
462   }
463 
464   /// @dev acceptFulfillment(): accept a given fulfillment
465   /// @param _bountyId the index of the bounty
466   /// @param _fulfillmentId the index of the fulfillment being accepted
467   function acceptFulfillment(uint _bountyId, uint _fulfillmentId)
468       public
469       validateBountyArrayIndex(_bountyId)
470       validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
471       onlyIssuerOrArbiter(_bountyId)
472       isAtStage(_bountyId, BountyStages.Active)
473       fulfillmentNotYetAccepted(_bountyId, _fulfillmentId)
474       enoughFundsToPay(_bountyId)
475   {
476       fulfillments[_bountyId][_fulfillmentId].accepted = true;
477       numAccepted[_bountyId]++;
478       bounties[_bountyId].balance -= bounties[_bountyId].fulfillmentAmount;
479       if (bounties[_bountyId].paysTokens){
480         require(tokenContracts[_bountyId].transfer(fulfillments[_bountyId][_fulfillmentId].fulfiller, bounties[_bountyId].fulfillmentAmount));
481       } else {
482         fulfillments[_bountyId][_fulfillmentId].fulfiller.transfer(bounties[_bountyId].fulfillmentAmount);
483       }
484       FulfillmentAccepted(_bountyId, msg.sender, _fulfillmentId);
485   }
486 
487   /// @dev killBounty(): drains the contract of it's remaining
488   /// funds, and moves the bounty into stage 3 (dead) since it was
489   /// either killed in draft stage, or never accepted any fulfillments
490   /// @param _bountyId the index of the bounty
491   function killBounty(uint _bountyId)
492       public
493       validateBountyArrayIndex(_bountyId)
494       onlyIssuer(_bountyId)
495   {
496       transitionToState(_bountyId, BountyStages.Dead);
497       uint oldBalance = bounties[_bountyId].balance;
498       bounties[_bountyId].balance = 0;
499       if (oldBalance > 0){
500         if (bounties[_bountyId].paysTokens){
501           require(tokenContracts[_bountyId].transfer(bounties[_bountyId].issuer, oldBalance));
502         } else {
503           bounties[_bountyId].issuer.transfer(oldBalance);
504         }
505       }
506       BountyKilled(_bountyId, msg.sender);
507   }
508 
509   modifier newDeadlineIsValid(uint _bountyId, uint _newDeadline) {
510       require(_newDeadline > bounties[_bountyId].deadline);
511       _;
512   }
513 
514   /// @dev extendDeadline(): allows the issuer to add more time to the
515   /// bounty, allowing it to continue accepting fulfillments
516   /// @param _bountyId the index of the bounty
517   /// @param _newDeadline the new deadline in timestamp format
518   function extendDeadline(uint _bountyId, uint _newDeadline)
519       public
520       validateBountyArrayIndex(_bountyId)
521       onlyIssuer(_bountyId)
522       newDeadlineIsValid(_bountyId, _newDeadline)
523   {
524       bounties[_bountyId].deadline = _newDeadline;
525 
526       DeadlineExtended(_bountyId, _newDeadline);
527   }
528 
529   /// @dev transferIssuer(): allows the issuer to transfer ownership of the
530   /// bounty to some new address
531   /// @param _bountyId the index of the bounty
532   /// @param _newIssuer the address of the new issuer
533   function transferIssuer(uint _bountyId, address _newIssuer)
534       public
535       validateBountyArrayIndex(_bountyId)
536       onlyIssuer(_bountyId)
537   {
538       bounties[_bountyId].issuer = _newIssuer;
539       IssuerTransferred(_bountyId, _newIssuer);
540   }
541 
542 
543   /// @dev changeBountyDeadline(): allows the issuer to change a bounty's deadline
544   /// @param _bountyId the index of the bounty
545   /// @param _newDeadline the new deadline for the bounty
546   function changeBountyDeadline(uint _bountyId, uint _newDeadline)
547       public
548       validateBountyArrayIndex(_bountyId)
549       onlyIssuer(_bountyId)
550       validateDeadline(_newDeadline)
551       isAtStage(_bountyId, BountyStages.Draft)
552   {
553       bounties[_bountyId].deadline = _newDeadline;
554       BountyChanged(_bountyId);
555   }
556 
557   /// @dev changeData(): allows the issuer to change a bounty's data
558   /// @param _bountyId the index of the bounty
559   /// @param _newData the new requirements of the bounty
560   function changeBountyData(uint _bountyId, string _newData)
561       public
562       validateBountyArrayIndex(_bountyId)
563       onlyIssuer(_bountyId)
564       isAtStage(_bountyId, BountyStages.Draft)
565   {
566       bounties[_bountyId].data = _newData;
567       BountyChanged(_bountyId);
568   }
569 
570   /// @dev changeBountyfulfillmentAmount(): allows the issuer to change a bounty's fulfillment amount
571   /// @param _bountyId the index of the bounty
572   /// @param _newFulfillmentAmount the new fulfillment amount
573   function changeBountyFulfillmentAmount(uint _bountyId, uint _newFulfillmentAmount)
574       public
575       validateBountyArrayIndex(_bountyId)
576       onlyIssuer(_bountyId)
577       isAtStage(_bountyId, BountyStages.Draft)
578   {
579       bounties[_bountyId].fulfillmentAmount = _newFulfillmentAmount;
580       BountyChanged(_bountyId);
581   }
582 
583   /// @dev changeBountyArbiter(): allows the issuer to change a bounty's arbiter
584   /// @param _bountyId the index of the bounty
585   /// @param _newArbiter the new address of the arbiter
586   function changeBountyArbiter(uint _bountyId, address _newArbiter)
587       public
588       validateBountyArrayIndex(_bountyId)
589       onlyIssuer(_bountyId)
590       isAtStage(_bountyId, BountyStages.Draft)
591   {
592       bounties[_bountyId].arbiter = _newArbiter;
593       BountyChanged(_bountyId);
594   }
595 
596   /// @dev changeBountyPaysTokens(): allows the issuer to change a bounty's issuer
597   /// @param _bountyId the index of the bounty
598   /// @param _newPaysTokens the new bool for whether the contract pays tokens
599   /// @param _newTokenContract the new address of the token
600   function changeBountyPaysTokens(uint _bountyId, bool _newPaysTokens, address _newTokenContract)
601       public
602       validateBountyArrayIndex(_bountyId)
603       onlyIssuer(_bountyId)
604       isAtStage(_bountyId, BountyStages.Draft)
605   {
606       HumanStandardToken oldToken = tokenContracts[_bountyId];
607       bool oldPaysTokens = bounties[_bountyId].paysTokens;
608       bounties[_bountyId].paysTokens = _newPaysTokens;
609       tokenContracts[_bountyId] = HumanStandardToken(_newTokenContract);
610       if (bounties[_bountyId].balance > 0){
611         uint oldBalance = bounties[_bountyId].balance;
612         bounties[_bountyId].balance = 0;
613         if (oldPaysTokens){
614             require(oldToken.transfer(bounties[_bountyId].issuer, oldBalance));
615         } else {
616             bounties[_bountyId].issuer.transfer(oldBalance);
617         }
618       }
619       BountyChanged(_bountyId);
620   }
621 
622   modifier newFulfillmentAmountIsIncrease(uint _bountyId, uint _newFulfillmentAmount) {
623       require(bounties[_bountyId].fulfillmentAmount < _newFulfillmentAmount);
624       _;
625   }
626 
627   /// @dev increasePayout(): allows the issuer to increase a given fulfillment
628   /// amount in the active stage
629   /// @param _bountyId the index of the bounty
630   /// @param _newFulfillmentAmount the new fulfillment amount
631   /// @param _value the value of the additional deposit being added
632   function increasePayout(uint _bountyId, uint _newFulfillmentAmount, uint _value)
633       public
634       payable
635       validateBountyArrayIndex(_bountyId)
636       onlyIssuer(_bountyId)
637       newFulfillmentAmountIsIncrease(_bountyId, _newFulfillmentAmount)
638       transferredAmountEqualsValue(_bountyId, _value)
639   {
640       bounties[_bountyId].balance += _value;
641       require(bounties[_bountyId].balance >= _newFulfillmentAmount);
642       bounties[_bountyId].fulfillmentAmount = _newFulfillmentAmount;
643       PayoutIncreased(_bountyId, _newFulfillmentAmount);
644   }
645 
646   /// @dev getFulfillment(): Returns the fulfillment at a given index
647   /// @param _bountyId the index of the bounty
648   /// @param _fulfillmentId the index of the fulfillment to return
649   /// @return Returns a tuple for the fulfillment
650   function getFulfillment(uint _bountyId, uint _fulfillmentId)
651       public
652       constant
653       validateBountyArrayIndex(_bountyId)
654       validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
655       returns (bool, address, string)
656   {
657       return (fulfillments[_bountyId][_fulfillmentId].accepted,
658               fulfillments[_bountyId][_fulfillmentId].fulfiller,
659               fulfillments[_bountyId][_fulfillmentId].data);
660   }
661 
662   /// @dev getBounty(): Returns the details of the bounty
663   /// @param _bountyId the index of the bounty
664   /// @return Returns a tuple for the bounty
665   function getBounty(uint _bountyId)
666       public
667       constant
668       validateBountyArrayIndex(_bountyId)
669       returns (address, uint, uint, bool, uint, uint)
670   {
671       return (bounties[_bountyId].issuer,
672               bounties[_bountyId].deadline,
673               bounties[_bountyId].fulfillmentAmount,
674               bounties[_bountyId].paysTokens,
675               uint(bounties[_bountyId].bountyStage),
676               bounties[_bountyId].balance);
677   }
678 
679   /// @dev getBountyArbiter(): Returns the arbiter of the bounty
680   /// @param _bountyId the index of the bounty
681   /// @return Returns an address for the arbiter of the bounty
682   function getBountyArbiter(uint _bountyId)
683       public
684       constant
685       validateBountyArrayIndex(_bountyId)
686       returns (address)
687   {
688       return (bounties[_bountyId].arbiter);
689   }
690 
691   /// @dev getBountyData(): Returns the data of the bounty
692   /// @param _bountyId the index of the bounty
693   /// @return Returns a string for the bounty data
694   function getBountyData(uint _bountyId)
695       public
696       constant
697       validateBountyArrayIndex(_bountyId)
698       returns (string)
699   {
700       return (bounties[_bountyId].data);
701   }
702 
703   /// @dev getBountyToken(): Returns the token contract of the bounty
704   /// @param _bountyId the index of the bounty
705   /// @return Returns an address for the token that the bounty uses
706   function getBountyToken(uint _bountyId)
707       public
708       constant
709       validateBountyArrayIndex(_bountyId)
710       returns (address)
711   {
712       return (tokenContracts[_bountyId]);
713   }
714 
715   /// @dev getNumBounties() returns the number of bounties in the registry
716   /// @return Returns the number of bounties
717   function getNumBounties()
718       public
719       constant
720       returns (uint)
721   {
722       return bounties.length;
723   }
724 
725   /// @dev getNumFulfillments() returns the number of fulfillments for a given milestone
726   /// @param _bountyId the index of the bounty
727   /// @return Returns the number of fulfillments
728   function getNumFulfillments(uint _bountyId)
729       public
730       constant
731       validateBountyArrayIndex(_bountyId)
732       returns (uint)
733   {
734       return fulfillments[_bountyId].length;
735   }
736 
737   /*
738    * Internal functions
739    */
740 
741   /// @dev transitionToState(): transitions the contract to the
742   /// state passed in the parameter `_newStage` given the
743   /// conditions stated in the body of the function
744   /// @param _bountyId the index of the bounty
745   /// @param _newStage the new stage to transition to
746   function transitionToState(uint _bountyId, BountyStages _newStage)
747       internal
748   {
749       bounties[_bountyId].bountyStage = _newStage;
750   }
751 }