1 pragma solidity ^0.4.18;
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
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 contract HumanStandardToken is StandardToken {
91 
92     /* Public variables of the token */
93 
94     /*
95     NOTE:
96     The following variables are OPTIONAL vanities. One does not have to include them.
97     They allow one to customise the token contract & in no way influences the core functionality.
98     Some wallets/interfaces might not even bother to look at this information.
99     */
100     string public name;                   //fancy name: eg Simon Bucks
101     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
102     string public symbol;                 //An identifier: eg SBX
103     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
104 
105     function HumanStandardToken(
106         uint256 _initialAmount,
107         string _tokenName,
108         uint8 _decimalUnits,
109         string _tokenSymbol
110         ) {
111         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
112         totalSupply = _initialAmount;                        // Update total supply
113         name = _tokenName;                                   // Set the name for display purposes
114         decimals = _decimalUnits;                            // Amount of decimals for display purposes
115         symbol = _tokenSymbol;                               // Set the symbol for display purposes
116     }
117 
118     /* Approves and then calls the receiving contract */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122 
123         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
124         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
125         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
126         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
127         return true;
128     }
129 }
130 
131 contract StandardBounties {
132 
133   /*
134    * Events
135    */
136   event BountyIssued(uint bountyId);
137   event BountyActivated(uint bountyId, address issuer);
138   event BountyFulfilled(uint bountyId, address indexed fulfiller, uint256 indexed _fulfillmentId);
139   event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId);
140   event FulfillmentAccepted(uint bountyId, address indexed fulfiller, uint256 indexed _fulfillmentId);
141   event BountyKilled(uint bountyId, address indexed issuer);
142   event ContributionAdded(uint bountyId, address indexed contributor, uint256 value);
143   event DeadlineExtended(uint bountyId, uint newDeadline);
144   event BountyChanged(uint bountyId);
145   event IssuerTransferred(uint _bountyId, address indexed _newIssuer);
146   event PayoutIncreased(uint _bountyId, uint _newFulfillmentAmount);
147 
148 
149   /*
150    * Storage
151    */
152 
153   address public owner;
154 
155   Bounty[] public bounties;
156 
157   mapping(uint=>Fulfillment[]) fulfillments;
158   mapping(uint=>uint) numAccepted;
159   mapping(uint=>HumanStandardToken) tokenContracts;
160 
161   /*
162    * Enums
163    */
164 
165   enum BountyStages {
166       Draft,
167       Active,
168       Dead
169   }
170 
171   /*
172    * Structs
173    */
174 
175   struct Bounty {
176       address issuer;
177       uint deadline;
178       string data;
179       uint fulfillmentAmount;
180       address arbiter;
181       bool paysTokens;
182       BountyStages bountyStage;
183       uint balance;
184   }
185 
186   struct Fulfillment {
187       bool accepted;
188       address fulfiller;
189       string data;
190   }
191 
192   /*
193    * Modifiers
194    */
195 
196   modifier validateNotTooManyBounties(){
197     require((bounties.length + 1) > bounties.length);
198     _;
199   }
200 
201   modifier validateNotTooManyFulfillments(uint _bountyId){
202     require((fulfillments[_bountyId].length + 1) > fulfillments[_bountyId].length);
203     _;
204   }
205 
206   modifier validateBountyArrayIndex(uint _bountyId){
207     require(_bountyId < bounties.length);
208     _;
209   }
210 
211   modifier onlyIssuer(uint _bountyId) {
212       require(msg.sender == bounties[_bountyId].issuer);
213       _;
214   }
215 
216   modifier onlyFulfiller(uint _bountyId, uint _fulfillmentId) {
217       require(msg.sender == fulfillments[_bountyId][_fulfillmentId].fulfiller);
218       _;
219   }
220 
221   modifier amountIsNotZero(uint _amount) {
222       require(_amount != 0);
223       _;
224   }
225 
226   modifier transferredAmountEqualsValue(uint _bountyId, uint _amount) {
227       if (bounties[_bountyId].paysTokens){
228         require(msg.value == 0);
229         uint oldBalance = tokenContracts[_bountyId].balanceOf(this);
230         if (_amount != 0){
231           require(tokenContracts[_bountyId].transferFrom(msg.sender, this, _amount));
232         }
233         require((tokenContracts[_bountyId].balanceOf(this) - oldBalance) == _amount);
234 
235       } else {
236         require((_amount * 1 wei) == msg.value);
237       }
238       _;
239   }
240 
241   modifier isBeforeDeadline(uint _bountyId) {
242       require(now < bounties[_bountyId].deadline);
243       _;
244   }
245 
246   modifier validateDeadline(uint _newDeadline) {
247       require(_newDeadline > now);
248       _;
249   }
250 
251   modifier isAtStage(uint _bountyId, BountyStages _desiredStage) {
252       require(bounties[_bountyId].bountyStage == _desiredStage);
253       _;
254   }
255 
256   modifier validateFulfillmentArrayIndex(uint _bountyId, uint _index) {
257       require(_index < fulfillments[_bountyId].length);
258       _;
259   }
260 
261   modifier notYetAccepted(uint _bountyId, uint _fulfillmentId){
262       require(fulfillments[_bountyId][_fulfillmentId].accepted == false);
263       _;
264   }
265 
266   /*
267    * Public functions
268    */
269 
270 
271   /// @dev StandardBounties(): instantiates
272   /// @param _owner the issuer of the standardbounties contract, who has the
273   /// ability to remove bounties
274   function StandardBounties(address _owner)
275       public
276   {
277       owner = _owner;
278   }
279 
280   /// @dev issueBounty(): instantiates a new draft bounty
281   /// @param _issuer the address of the intended issuer of the bounty
282   /// @param _deadline the unix timestamp after which fulfillments will no longer be accepted
283   /// @param _data the requirements of the bounty
284   /// @param _fulfillmentAmount the amount of wei to be paid out for each successful fulfillment
285   /// @param _arbiter the address of the arbiter who can mediate claims
286   /// @param _paysTokens whether the bounty pays in tokens or in ETH
287   /// @param _tokenContract the address of the contract if _paysTokens is true
288   function issueBounty(
289       address _issuer,
290       uint _deadline,
291       string _data,
292       uint256 _fulfillmentAmount,
293       address _arbiter,
294       bool _paysTokens,
295       address _tokenContract
296   )
297       public
298       validateDeadline(_deadline)
299       amountIsNotZero(_fulfillmentAmount)
300       validateNotTooManyBounties
301       returns (uint)
302   {
303       bounties.push(Bounty(_issuer, _deadline, _data, _fulfillmentAmount, _arbiter, _paysTokens, BountyStages.Draft, 0));
304       if (_paysTokens){
305         tokenContracts[bounties.length - 1] = HumanStandardToken(_tokenContract);
306       }
307       BountyIssued(bounties.length - 1);
308       return (bounties.length - 1);
309   }
310 
311   /// @dev issueAndActivateBounty(): instantiates a new draft bounty
312   /// @param _issuer the address of the intended issuer of the bounty
313   /// @param _deadline the unix timestamp after which fulfillments will no longer be accepted
314   /// @param _data the requirements of the bounty
315   /// @param _fulfillmentAmount the amount of wei to be paid out for each successful fulfillment
316   /// @param _arbiter the address of the arbiter who can mediate claims
317   /// @param _paysTokens whether the bounty pays in tokens or in ETH
318   /// @param _tokenContract the address of the contract if _paysTokens is true
319   /// @param _value the total number of tokens being deposited upon activation
320   function issueAndActivateBounty(
321       address _issuer,
322       uint _deadline,
323       string _data,
324       uint256 _fulfillmentAmount,
325       address _arbiter,
326       bool _paysTokens,
327       address _tokenContract,
328       uint256 _value
329   )
330       public
331       payable
332       validateDeadline(_deadline)
333       amountIsNotZero(_fulfillmentAmount)
334       validateNotTooManyBounties
335       returns (uint)
336   {
337       require (_value >= _fulfillmentAmount);
338       if (_paysTokens){
339         require(msg.value == 0);
340         tokenContracts[bounties.length] = HumanStandardToken(_tokenContract);
341         require(tokenContracts[bounties.length].transferFrom(msg.sender, this, _value));
342       } else {
343         require((_value * 1 wei) == msg.value);
344       }
345       bounties.push(Bounty(_issuer,
346                             _deadline,
347                             _data,
348                             _fulfillmentAmount,
349                             _arbiter,
350                             _paysTokens,
351                             BountyStages.Active,
352                             _value));
353       BountyIssued(bounties.length - 1);
354       ContributionAdded(bounties.length - 1, msg.sender, _value);
355       BountyActivated(bounties.length - 1, msg.sender);
356       return (bounties.length - 1);
357   }
358 
359   modifier isNotDead(uint _bountyId) {
360       require(bounties[_bountyId].bountyStage != BountyStages.Dead);
361       _;
362   }
363 
364   /// @dev contribute(): a function allowing anyone to contribute tokens to a
365   /// bounty, as long as it is still before its deadline. Shouldn't keep
366   /// them by accident (hence 'value').
367   /// @param _bountyId the index of the bounty
368   /// @param _value the amount being contributed in ether to prevent accidental deposits
369   /// @notice Please note you funds will be at the mercy of the issuer
370   ///  and can be drained at any moment. Be careful!
371   function contribute (uint _bountyId, uint _value)
372       payable
373       public
374       validateBountyArrayIndex(_bountyId)
375       isBeforeDeadline(_bountyId)
376       isNotDead(_bountyId)
377       amountIsNotZero(_value)
378       transferredAmountEqualsValue(_bountyId, _value)
379   {
380       bounties[_bountyId].balance += _value;
381 
382       ContributionAdded(_bountyId, msg.sender, _value);
383   }
384 
385   /// @notice Send funds to activate the bug bounty
386   /// @dev activateBounty(): activate a bounty so it may pay out
387   /// @param _bountyId the index of the bounty
388   /// @param _value the amount being contributed in ether to prevent
389   /// accidental deposits
390   function activateBounty(uint _bountyId, uint _value)
391       payable
392       public
393       validateBountyArrayIndex(_bountyId)
394       isBeforeDeadline(_bountyId)
395       onlyIssuer(_bountyId)
396       transferredAmountEqualsValue(_bountyId, _value)
397   {
398       bounties[_bountyId].balance += _value;
399       require (bounties[_bountyId].balance >= bounties[_bountyId].fulfillmentAmount);
400       transitionToState(_bountyId, BountyStages.Active);
401 
402       ContributionAdded(_bountyId, msg.sender, _value);
403       BountyActivated(_bountyId, msg.sender);
404   }
405 
406   modifier notIssuerOrArbiter(uint _bountyId) {
407       require(msg.sender != bounties[_bountyId].issuer && msg.sender != bounties[_bountyId].arbiter);
408       _;
409   }
410 
411   /// @dev fulfillBounty(): submit a fulfillment for the given bounty
412   /// @param _bountyId the index of the bounty
413   /// @param _data the data artifacts representing the fulfillment of the bounty
414   function fulfillBounty(uint _bountyId, string _data)
415       public
416       validateBountyArrayIndex(_bountyId)
417       validateNotTooManyFulfillments(_bountyId)
418       isAtStage(_bountyId, BountyStages.Active)
419       isBeforeDeadline(_bountyId)
420       notIssuerOrArbiter(_bountyId)
421   {
422       fulfillments[_bountyId].push(Fulfillment(false, msg.sender, _data));
423 
424       BountyFulfilled(_bountyId, msg.sender, (fulfillments[_bountyId].length - 1));
425   }
426 
427   /// @dev updateFulfillment(): Submit updated data for a given fulfillment
428   /// @param _bountyId the index of the bounty
429   /// @param _fulfillmentId the index of the fulfillment
430   /// @param _data the new data being submitted
431   function updateFulfillment(uint _bountyId, uint _fulfillmentId, string _data)
432       public
433       validateBountyArrayIndex(_bountyId)
434       validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
435       onlyFulfiller(_bountyId, _fulfillmentId)
436       notYetAccepted(_bountyId, _fulfillmentId)
437   {
438       fulfillments[_bountyId][_fulfillmentId].data = _data;
439       FulfillmentUpdated(_bountyId, _fulfillmentId);
440   }
441 
442   modifier onlyIssuerOrArbiter(uint _bountyId) {
443       require(msg.sender == bounties[_bountyId].issuer ||
444          (msg.sender == bounties[_bountyId].arbiter && bounties[_bountyId].arbiter != address(0)));
445       _;
446   }
447 
448   modifier fulfillmentNotYetAccepted(uint _bountyId, uint _fulfillmentId) {
449       require(fulfillments[_bountyId][_fulfillmentId].accepted == false);
450       _;
451   }
452 
453   modifier enoughFundsToPay(uint _bountyId) {
454       require(bounties[_bountyId].balance >= bounties[_bountyId].fulfillmentAmount);
455       _;
456   }
457 
458   /// @dev acceptFulfillment(): accept a given fulfillment
459   /// @param _bountyId the index of the bounty
460   /// @param _fulfillmentId the index of the fulfillment being accepted
461   function acceptFulfillment(uint _bountyId, uint _fulfillmentId)
462       public
463       validateBountyArrayIndex(_bountyId)
464       validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
465       onlyIssuerOrArbiter(_bountyId)
466       isAtStage(_bountyId, BountyStages.Active)
467       fulfillmentNotYetAccepted(_bountyId, _fulfillmentId)
468       enoughFundsToPay(_bountyId)
469   {
470       fulfillments[_bountyId][_fulfillmentId].accepted = true;
471       numAccepted[_bountyId]++;
472       bounties[_bountyId].balance -= bounties[_bountyId].fulfillmentAmount;
473       if (bounties[_bountyId].paysTokens){
474         require(tokenContracts[_bountyId].transfer(fulfillments[_bountyId][_fulfillmentId].fulfiller, bounties[_bountyId].fulfillmentAmount));
475       } else {
476         fulfillments[_bountyId][_fulfillmentId].fulfiller.transfer(bounties[_bountyId].fulfillmentAmount);
477       }
478       FulfillmentAccepted(_bountyId, msg.sender, _fulfillmentId);
479   }
480 
481   /// @dev killBounty(): drains the contract of it's remaining
482   /// funds, and moves the bounty into stage 3 (dead) since it was
483   /// either killed in draft stage, or never accepted any fulfillments
484   /// @param _bountyId the index of the bounty
485   function killBounty(uint _bountyId)
486       public
487       validateBountyArrayIndex(_bountyId)
488       onlyIssuer(_bountyId)
489   {
490       transitionToState(_bountyId, BountyStages.Dead);
491       uint oldBalance = bounties[_bountyId].balance;
492       bounties[_bountyId].balance = 0;
493       if (oldBalance > 0){
494         if (bounties[_bountyId].paysTokens){
495           require(tokenContracts[_bountyId].transfer(bounties[_bountyId].issuer, oldBalance));
496         } else {
497           bounties[_bountyId].issuer.transfer(oldBalance);
498         }
499       }
500       BountyKilled(_bountyId, msg.sender);
501   }
502 
503   modifier newDeadlineIsValid(uint _bountyId, uint _newDeadline) {
504       require(_newDeadline > bounties[_bountyId].deadline);
505       _;
506   }
507 
508   /// @dev extendDeadline(): allows the issuer to add more time to the
509   /// bounty, allowing it to continue accepting fulfillments
510   /// @param _bountyId the index of the bounty
511   /// @param _newDeadline the new deadline in timestamp format
512   function extendDeadline(uint _bountyId, uint _newDeadline)
513       public
514       validateBountyArrayIndex(_bountyId)
515       onlyIssuer(_bountyId)
516       newDeadlineIsValid(_bountyId, _newDeadline)
517   {
518       bounties[_bountyId].deadline = _newDeadline;
519 
520       DeadlineExtended(_bountyId, _newDeadline);
521   }
522 
523   /// @dev transferIssuer(): allows the issuer to transfer ownership of the
524   /// bounty to some new address
525   /// @param _bountyId the index of the bounty
526   /// @param _newIssuer the address of the new issuer
527   function transferIssuer(uint _bountyId, address _newIssuer)
528       public
529       validateBountyArrayIndex(_bountyId)
530       onlyIssuer(_bountyId)
531   {
532       bounties[_bountyId].issuer = _newIssuer;
533       IssuerTransferred(_bountyId, _newIssuer);
534   }
535 
536 
537   /// @dev changeBountyDeadline(): allows the issuer to change a bounty's deadline
538   /// @param _bountyId the index of the bounty
539   /// @param _newDeadline the new deadline for the bounty
540   function changeBountyDeadline(uint _bountyId, uint _newDeadline)
541       public
542       validateBountyArrayIndex(_bountyId)
543       onlyIssuer(_bountyId)
544       validateDeadline(_newDeadline)
545       isAtStage(_bountyId, BountyStages.Draft)
546   {
547       bounties[_bountyId].deadline = _newDeadline;
548       BountyChanged(_bountyId);
549   }
550 
551   /// @dev changeData(): allows the issuer to change a bounty's data
552   /// @param _bountyId the index of the bounty
553   /// @param _newData the new requirements of the bounty
554   function changeBountyData(uint _bountyId, string _newData)
555       public
556       validateBountyArrayIndex(_bountyId)
557       onlyIssuer(_bountyId)
558       isAtStage(_bountyId, BountyStages.Draft)
559   {
560       bounties[_bountyId].data = _newData;
561       BountyChanged(_bountyId);
562   }
563 
564   /// @dev changeBountyfulfillmentAmount(): allows the issuer to change a bounty's fulfillment amount
565   /// @param _bountyId the index of the bounty
566   /// @param _newFulfillmentAmount the new fulfillment amount
567   function changeBountyFulfillmentAmount(uint _bountyId, uint _newFulfillmentAmount)
568       public
569       validateBountyArrayIndex(_bountyId)
570       onlyIssuer(_bountyId)
571       isAtStage(_bountyId, BountyStages.Draft)
572   {
573       bounties[_bountyId].fulfillmentAmount = _newFulfillmentAmount;
574       BountyChanged(_bountyId);
575   }
576 
577   /// @dev changeBountyArbiter(): allows the issuer to change a bounty's arbiter
578   /// @param _bountyId the index of the bounty
579   /// @param _newArbiter the new address of the arbiter
580   function changeBountyArbiter(uint _bountyId, address _newArbiter)
581       public
582       validateBountyArrayIndex(_bountyId)
583       onlyIssuer(_bountyId)
584       isAtStage(_bountyId, BountyStages.Draft)
585   {
586       bounties[_bountyId].arbiter = _newArbiter;
587       BountyChanged(_bountyId);
588   }
589 
590   modifier newFulfillmentAmountIsIncrease(uint _bountyId, uint _newFulfillmentAmount) {
591       require(bounties[_bountyId].fulfillmentAmount < _newFulfillmentAmount);
592       _;
593   }
594 
595   /// @dev increasePayout(): allows the issuer to increase a given fulfillment
596   /// amount in the active stage
597   /// @param _bountyId the index of the bounty
598   /// @param _newFulfillmentAmount the new fulfillment amount
599   /// @param _value the value of the additional deposit being added
600   function increasePayout(uint _bountyId, uint _newFulfillmentAmount, uint _value)
601       public
602       payable
603       validateBountyArrayIndex(_bountyId)
604       onlyIssuer(_bountyId)
605       newFulfillmentAmountIsIncrease(_bountyId, _newFulfillmentAmount)
606       transferredAmountEqualsValue(_bountyId, _value)
607   {
608       bounties[_bountyId].balance += _value;
609       require(bounties[_bountyId].balance >= _newFulfillmentAmount);
610       bounties[_bountyId].fulfillmentAmount = _newFulfillmentAmount;
611       PayoutIncreased(_bountyId, _newFulfillmentAmount);
612   }
613 
614   /// @dev getFulfillment(): Returns the fulfillment at a given index
615   /// @param _bountyId the index of the bounty
616   /// @param _fulfillmentId the index of the fulfillment to return
617   /// @return Returns a tuple for the fulfillment
618   function getFulfillment(uint _bountyId, uint _fulfillmentId)
619       public
620       constant
621       validateBountyArrayIndex(_bountyId)
622       validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)
623       returns (bool, address, string)
624   {
625       return (fulfillments[_bountyId][_fulfillmentId].accepted,
626               fulfillments[_bountyId][_fulfillmentId].fulfiller,
627               fulfillments[_bountyId][_fulfillmentId].data);
628   }
629 
630   /// @dev getBounty(): Returns the details of the bounty
631   /// @param _bountyId the index of the bounty
632   /// @return Returns a tuple for the bounty
633   function getBounty(uint _bountyId)
634       public
635       constant
636       validateBountyArrayIndex(_bountyId)
637       returns (address, uint, uint, bool, uint, uint)
638   {
639       return (bounties[_bountyId].issuer,
640               bounties[_bountyId].deadline,
641               bounties[_bountyId].fulfillmentAmount,
642               bounties[_bountyId].paysTokens,
643               uint(bounties[_bountyId].bountyStage),
644               bounties[_bountyId].balance);
645   }
646 
647   /// @dev getBountyArbiter(): Returns the arbiter of the bounty
648   /// @param _bountyId the index of the bounty
649   /// @return Returns an address for the arbiter of the bounty
650   function getBountyArbiter(uint _bountyId)
651       public
652       constant
653       validateBountyArrayIndex(_bountyId)
654       returns (address)
655   {
656       return (bounties[_bountyId].arbiter);
657   }
658 
659   /// @dev getBountyData(): Returns the data of the bounty
660   /// @param _bountyId the index of the bounty
661   /// @return Returns a string for the bounty data
662   function getBountyData(uint _bountyId)
663       public
664       constant
665       validateBountyArrayIndex(_bountyId)
666       returns (string)
667   {
668       return (bounties[_bountyId].data);
669   }
670 
671   /// @dev getBountyToken(): Returns the token contract of the bounty
672   /// @param _bountyId the index of the bounty
673   /// @return Returns an address for the token that the bounty uses
674   function getBountyToken(uint _bountyId)
675       public
676       constant
677       validateBountyArrayIndex(_bountyId)
678       returns (address)
679   {
680       return (tokenContracts[_bountyId]);
681   }
682 
683   /// @dev getNumBounties() returns the number of bounties in the registry
684   /// @return Returns the number of bounties
685   function getNumBounties()
686       public
687       constant
688       returns (uint)
689   {
690       return bounties.length;
691   }
692 
693   /// @dev getNumFulfillments() returns the number of fulfillments for a given milestone
694   /// @param _bountyId the index of the bounty
695   /// @return Returns the number of fulfillments
696   function getNumFulfillments(uint _bountyId)
697       public
698       constant
699       validateBountyArrayIndex(_bountyId)
700       returns (uint)
701   {
702       return fulfillments[_bountyId].length;
703   }
704 
705   /*
706    * Internal functions
707    */
708 
709   /// @dev transitionToState(): transitions the contract to the
710   /// state passed in the parameter `_newStage` given the
711   /// conditions stated in the body of the function
712   /// @param _bountyId the index of the bounty
713   /// @param _newStage the new stage to transition to
714   function transitionToState(uint _bountyId, BountyStages _newStage)
715       internal
716   {
717       bounties[_bountyId].bountyStage = _newStage;
718   }
719 }