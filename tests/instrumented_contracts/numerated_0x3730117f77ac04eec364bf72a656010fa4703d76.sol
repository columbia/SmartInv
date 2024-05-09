1 pragma solidity ^0.4.2;
2 
3 /*
4  *
5  * This file is part of Pass DAO.
6  *
7  * The Token Manager smart contract is used for the management of tokens
8  * by a client smart contract (the Dao). Defines the functions to set new funding rules,
9  * create or reward tokens, check token balances, send tokens and send
10  * tokens on behalf of a 3rd party and the corresponding approval process.
11  *
12 */
13 
14 /// @title Token Manager smart contract of the Pass Decentralized Autonomous Organisation
15 contract PassTokenManagerInterface {
16     
17     struct fundingData {
18         // True if public funding without a main partner
19         bool publicCreation; 
20         // The address which sets partners and manages the funding in case of private funding
21         address mainPartner;
22         // The maximum amount (in wei) of the funding
23         uint maxAmountToFund;
24         // The actual funded amount (in wei)
25         uint fundedAmount;
26         // A unix timestamp, denoting the start time of the funding
27         uint startTime; 
28         // A unix timestamp, denoting the closing time of the funding
29         uint closingTime;  
30         // The price multiplier for a share or a token without considering the inflation rate
31         uint initialPriceMultiplier;
32         // Rate per year in percentage applied to the share or token price 
33         uint inflationRate; 
34         // Index of the client proposal
35         uint proposalID;
36     } 
37 
38     // Address of the creator of the smart contract
39     address public creator;
40     // Address of the Dao    
41     address public client;
42     // Address of the recipient;
43     address public recipient;
44     
45     // The token name for display purpose
46     string public name;
47     // The token symbol for display purpose
48     string public symbol;
49     // The quantity of decimals for display purpose
50     uint8 public decimals;
51 
52     // Total amount of tokens
53     uint256 totalSupply;
54 
55     // Array with all balances
56     mapping (address => uint256) balances;
57     // Array with all allowances
58     mapping (address => mapping (address => uint256)) allowed;
59 
60     // Map of the result (in wei) of fundings
61     mapping (uint => uint) fundedAmount;
62     
63     // If true, the shares or tokens can be transfered
64     bool public transferable;
65     // Map of blocked Dao share accounts. Points to the date when the share holder can transfer shares
66     mapping (address => uint) public blockedDeadLine; 
67 
68     // Rules for the actual funding and the contractor token price
69     fundingData[2] public FundingRules;
70     
71     /// @return The total supply of shares or tokens 
72     function TotalSupply() constant external returns (uint256);
73 
74     /// @param _owner The address from which the balance will be retrieved
75     /// @return The balance
76      function balanceOf(address _owner) constant external returns (uint256 balance);
77 
78     /// @param _owner The address of the account owning tokens
79     /// @param _spender The address of the account able to transfer the tokens
80     /// @return Quantity of remaining tokens of _owner that _spender is allowed to spend
81     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
82 
83     /// @param _proposalID The index of the Dao proposal
84     /// @return The result (in wei) of the funding
85     function FundedAmount(uint _proposalID) constant external returns (uint);
86 
87     /// @param _saleDate in case of presale, the date of the presale
88     /// @return the share or token price divisor condidering the sale date and the inflation rate
89     function priceDivisor(uint _saleDate) constant internal returns (uint);
90     
91     /// @return the actual price divisor of a share or token
92     function actualPriceDivisor() constant external returns (uint);
93 
94     /// @return The maximal amount a main partner can fund at this moment
95     /// @param _mainPartner The address of the main parner
96     function fundingMaxAmount(address _mainPartner) constant external returns (uint);
97 
98     // Modifier that allows only the client to manage this account manager
99     modifier onlyClient {if (msg.sender != client) throw; _;}
100 
101     // Modifier that allows only the main partner to manage the actual funding
102     modifier onlyMainPartner {if (msg.sender !=  FundingRules[0].mainPartner) throw; _;}
103     
104     // Modifier that allows only the contractor propose set the token price or withdraw
105     modifier onlyContractor {if (recipient == 0 || (msg.sender != recipient && msg.sender != creator)) throw; _;}
106     
107     // Modifier for Dao functions
108     modifier onlyDao {if (recipient != 0) throw; _;}
109     
110     /// @dev The constructor function
111     /// @param _creator The address of the creator of the smart contract
112     /// @param _client The address of the client or Dao
113     /// @param _recipient The recipient of this manager
114     //function TokenManager(
115         //address _creator,
116         //address _client,
117         //address _recipient
118     //);
119 
120     /// @param _tokenName The token name for display purpose
121     /// @param _tokenSymbol The token symbol for display purpose
122     /// @param _tokenDecimals The quantity of decimals for display purpose
123     /// @param _initialSupplyRecipient The recipient of the initial supply (not mandatory)
124     /// @param _initialSupply The initial supply of tokens for the recipient (not mandatory)
125     /// @param _transferable True if allows the transfer of tokens
126     function initToken(
127         string _tokenName,
128         string _tokenSymbol,
129         uint8 _tokenDecimals,
130         address _initialSupplyRecipient,
131         uint256 _initialSupply,
132         bool _transferable
133        );
134 
135     /// @param _initialPriceMultiplier The initial price multiplier of contractor tokens
136     /// @param _inflationRate If 0, the contractor token price doesn't change during the funding
137     /// @param _closingTime The initial price and inflation rate can be changed after this date
138     function setTokenPriceProposal(        
139         uint _initialPriceMultiplier, 
140         uint _inflationRate,
141         uint _closingTime
142     );
143 
144     /// @notice Function to set a funding. Can be private or public
145     /// @param _mainPartner The address of the smart contract to manage a private funding
146     /// @param _publicCreation True if public funding
147     /// @param _initialPriceMultiplier Price multiplier without considering any inflation rate
148     /// @param _maxAmountToFund The maximum amount (in wei) of the funding
149     /// @param _minutesFundingPeriod Period in minutes of the funding
150     /// @param _inflationRate If 0, the token price doesn't change during the funding
151     /// @param _proposalID Index of the client proposal (not mandatory)
152     function setFundingRules(
153         address _mainPartner,
154         bool _publicCreation, 
155         uint _initialPriceMultiplier, 
156         uint _maxAmountToFund, 
157         uint _minutesFundingPeriod, 
158         uint _inflationRate,
159         uint _proposalID
160     ) external;
161     
162     /// @dev Internal function for the creation of shares or tokens
163     /// @param _recipient The recipient address of shares or tokens
164     /// @param _amount The funded amount (in wei)
165     /// @param _saleDate In case of presale, the date of the presale
166     /// @return Whether the creation was successful or not
167     function createToken(
168         address _recipient, 
169         uint _amount,
170         uint _saleDate
171     ) internal returns (bool success);
172 
173     /// @notice Function used by the main partner to set the start time of the funding
174     /// @param _startTime The unix start date of the funding 
175     function setFundingStartTime(uint _startTime) external;
176 
177     /// @notice Function used by the main partner to reward shares or tokens
178     /// @param _recipient The address of the recipient of shares or tokens
179     /// @param _amount The amount (in Wei) to calculate the quantity of shares or tokens to create
180     /// @param _date The unix date to consider for the share or token price calculation
181     /// @return Whether the transfer was successful or not
182     function rewardToken(
183         address _recipient, 
184         uint _amount,
185         uint _date
186         ) external;
187 
188     /// @dev Internal function to close the actual funding
189     function closeFunding() internal;
190     
191     /// @notice Function used by the main partner to set the funding fueled
192     function setFundingFueled() external;
193 
194     /// @notice Function to able the transfer of Dao shares or contractor tokens
195     function ableTransfer();
196 
197     /// @notice Function to disable the transfer of Dao shares
198     function disableTransfer();
199 
200     /// @notice Function used by the client to block the transfer of shares from and to a share holder
201     /// @param _shareHolder The address of the share holder
202     /// @param _deadLine When the account will be unblocked
203     function blockTransfer(address _shareHolder, uint _deadLine) external;
204 
205     /// @dev Internal function to send `_value` token to `_to` from `_From`
206     /// @param _from The address of the sender
207     /// @param _to The address of the recipient
208     /// @param _value The quantity of shares or tokens to be transferred
209     /// @return Whether the function was successful or not 
210     function transferFromTo(
211         address _from,
212         address _to, 
213         uint256 _value
214         ) internal returns (bool);
215 
216     /// @notice send `_value` token to `_to` from `msg.sender`
217     /// @param _to The address of the recipient
218     /// @param _value The quantity of shares or tokens to be transferred
219     function transfer(address _to, uint256 _value);
220 
221     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
222     /// @param _from The address of the sender
223     /// @param _to The address of the recipient
224     /// @param _value The quantity of shares or tokens to be transferred
225     function transferFrom(
226         address _from, 
227         address _to, 
228         uint256 _value
229         ) returns (bool success);
230 
231     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf
232     /// @param _spender The address of the account able to transfer the tokens
233     /// @param _value The amount of tokens to be approved for transfer
234     /// @return Whether the approval was successful or not
235     function approve(address _spender, uint256 _value) returns (bool success);
236 
237     event TokensCreated(address indexed Sender, address indexed TokenHolder, uint Quantity);
238     event FundingRulesSet(address indexed MainPartner, uint indexed FundingProposalId, uint indexed StartTime, uint ClosingTime);
239     event FundingFueled(uint indexed FundingProposalID, uint FundedAmount);
240     event TransferAble();
241     event TransferDisable();
242 
243 }    
244 
245 contract PassTokenManager is PassTokenManagerInterface {
246     
247     function TotalSupply() constant external returns (uint256) {
248         return totalSupply;
249     }
250 
251      function balanceOf(address _owner) constant external returns (uint256 balance) {
252         return balances[_owner];
253      }
254 
255     function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {
256         return allowed[_owner][_spender];
257     }
258 
259     function FundedAmount(uint _proposalID) constant external returns (uint) {
260         return fundedAmount[_proposalID];
261     }
262 
263     function priceDivisor(uint _saleDate) constant internal returns (uint) {
264         uint _date = _saleDate;
265         
266         if (_saleDate > FundingRules[0].closingTime) _date = FundingRules[0].closingTime;
267         if (_saleDate < FundingRules[0].startTime) _date = FundingRules[0].startTime;
268 
269         return 100 + 100*FundingRules[0].inflationRate*(_date - FundingRules[0].startTime)/(100*365 days);
270     }
271     
272     function actualPriceDivisor() constant external returns (uint) {
273         return priceDivisor(now);
274     }
275 
276     function fundingMaxAmount(address _mainPartner) constant external returns (uint) {
277         
278         if (now > FundingRules[0].closingTime
279             || now < FundingRules[0].startTime
280             || _mainPartner != FundingRules[0].mainPartner) {
281             return 0;   
282         } else {
283             return FundingRules[0].maxAmountToFund;
284         }
285         
286     }
287 
288     function PassTokenManager(
289         address _creator,
290         address _client,
291         address _recipient
292     ) {
293         
294         if (_creator == 0 
295             || _client == 0 
296             || _client == _recipient 
297             || _client == address(this) 
298             || _recipient == address(this)) throw;
299 
300         creator = _creator; 
301         client = _client;
302         recipient = _recipient;
303         
304     }
305    
306     function initToken(
307         string _tokenName,
308         string _tokenSymbol,
309         uint8 _tokenDecimals,
310         address _initialSupplyRecipient,
311         uint256 _initialSupply,
312         bool _transferable) {
313            
314         if (_initialSupplyRecipient == address(this)
315             || decimals != 0
316             || msg.sender != creator
317             || totalSupply != 0) throw;
318             
319         name = _tokenName;
320         symbol = _tokenSymbol;
321         decimals = _tokenDecimals;
322           
323         if (_transferable) {
324             transferable = true;
325             TransferAble();
326         } else {
327             transferable = false;
328             TransferDisable();
329         }
330         
331         balances[_initialSupplyRecipient] = _initialSupply; 
332         totalSupply = _initialSupply;
333         TokensCreated(msg.sender, _initialSupplyRecipient, _initialSupply);
334            
335     }
336     
337     function setTokenPriceProposal(        
338         uint _initialPriceMultiplier, 
339         uint _inflationRate,
340         uint _closingTime
341     ) onlyContractor {
342         
343         if (_closingTime < now 
344             || now < FundingRules[1].closingTime) throw;
345         
346         FundingRules[1].initialPriceMultiplier = _initialPriceMultiplier;
347         FundingRules[1].inflationRate = _inflationRate;
348         FundingRules[1].startTime = now;
349         FundingRules[1].closingTime = _closingTime;
350         
351     }
352     
353     function setFundingRules(
354         address _mainPartner,
355         bool _publicCreation, 
356         uint _initialPriceMultiplier,
357         uint _maxAmountToFund, 
358         uint _minutesFundingPeriod, 
359         uint _inflationRate,
360         uint _proposalID
361     ) external onlyClient {
362 
363         if (now < FundingRules[0].closingTime
364             || _mainPartner == address(this)
365             || _mainPartner == client
366             || (!_publicCreation && _mainPartner == 0)
367             || (_publicCreation && _mainPartner != 0)
368             || (recipient == 0 && _initialPriceMultiplier == 0)
369             || (recipient != 0 
370                 && (FundingRules[1].initialPriceMultiplier == 0
371                     || _inflationRate < FundingRules[1].inflationRate
372                     || now < FundingRules[1].startTime
373                     || FundingRules[1].closingTime < now + (_minutesFundingPeriod * 1 minutes)))
374             || _maxAmountToFund == 0
375             || _minutesFundingPeriod == 0
376             ) throw;
377 
378         FundingRules[0].startTime = now;
379         FundingRules[0].closingTime = now + _minutesFundingPeriod * 1 minutes;
380             
381         FundingRules[0].mainPartner = _mainPartner;
382         FundingRules[0].publicCreation = _publicCreation;
383         
384         if (recipient == 0) FundingRules[0].initialPriceMultiplier = _initialPriceMultiplier;
385         else FundingRules[0].initialPriceMultiplier = FundingRules[1].initialPriceMultiplier;
386         
387         if (recipient == 0) FundingRules[0].inflationRate = _inflationRate;
388         else FundingRules[0].inflationRate = FundingRules[1].inflationRate;
389         
390         FundingRules[0].fundedAmount = 0;
391         FundingRules[0].maxAmountToFund = _maxAmountToFund;
392 
393         FundingRules[0].proposalID = _proposalID;
394 
395         FundingRulesSet(_mainPartner, _proposalID, FundingRules[0].startTime, FundingRules[0].closingTime);
396             
397     } 
398     
399     function createToken(
400         address _recipient, 
401         uint _amount,
402         uint _saleDate
403     ) internal returns (bool success) {
404 
405         if (now > FundingRules[0].closingTime
406             || now < FundingRules[0].startTime
407             ||_saleDate > FundingRules[0].closingTime
408             || _saleDate < FundingRules[0].startTime
409             || FundingRules[0].fundedAmount + _amount > FundingRules[0].maxAmountToFund) return;
410 
411         uint _a = _amount*FundingRules[0].initialPriceMultiplier;
412         uint _multiplier = 100*_a;
413         uint _quantity = _multiplier/priceDivisor(_saleDate);
414         if (_a/_amount != FundingRules[0].initialPriceMultiplier
415             || _multiplier/100 != _a
416             || totalSupply + _quantity <= totalSupply 
417             || totalSupply + _quantity <= _quantity) return;
418 
419         balances[_recipient] += _quantity;
420         totalSupply += _quantity;
421         FundingRules[0].fundedAmount += _amount;
422 
423         TokensCreated(msg.sender, _recipient, _quantity);
424         
425         if (FundingRules[0].fundedAmount == FundingRules[0].maxAmountToFund) closeFunding();
426         
427         return true;
428 
429     }
430 
431     function setFundingStartTime(uint _startTime) external onlyMainPartner {
432         if (now > FundingRules[0].closingTime) throw;
433         FundingRules[0].startTime = _startTime;
434     }
435     
436     function rewardToken(
437         address _recipient, 
438         uint _amount,
439         uint _date
440         ) external onlyMainPartner {
441 
442         uint _saleDate;
443         if (_date == 0) _saleDate = now; else _saleDate = _date;
444 
445         if (!createToken(_recipient, _amount, _saleDate)) throw;
446 
447     }
448 
449     function closeFunding() internal {
450         if (recipient == 0) fundedAmount[FundingRules[0].proposalID] = FundingRules[0].fundedAmount;
451         FundingRules[0].closingTime = now;
452     }
453     
454     function setFundingFueled() external onlyMainPartner {
455         if (now > FundingRules[0].closingTime) throw;
456         closeFunding();
457         if (recipient == 0) FundingFueled(FundingRules[0].proposalID, FundingRules[0].fundedAmount);
458     }
459     
460     function ableTransfer() onlyClient {
461         if (!transferable) {
462             transferable = true;
463             TransferAble();
464         }
465     }
466 
467     function disableTransfer() onlyClient {
468         if (transferable) {
469             transferable = false;
470             TransferDisable();
471         }
472     }
473     
474     function blockTransfer(address _shareHolder, uint _deadLine) external onlyClient onlyDao {
475         if (_deadLine > blockedDeadLine[_shareHolder]) {
476             blockedDeadLine[_shareHolder] = _deadLine;
477         }
478     }
479     
480     function transferFromTo(
481         address _from,
482         address _to, 
483         uint256 _value
484         ) internal returns (bool) {  
485 
486         if (transferable
487             && now > blockedDeadLine[_from]
488             && now > blockedDeadLine[_to]
489             && _to != address(this)
490             && balances[_from] >= _value
491             && balances[_to] + _value > balances[_to]
492             && balances[_to] + _value >= _value
493         ) {
494             balances[_from] -= _value;
495             balances[_to] += _value;
496             return true;
497         } else {
498             return false;
499         }
500         
501     }
502 
503     function transfer(address _to, uint256 _value) {  
504         if (!transferFromTo(msg.sender, _to, _value)) throw;
505     }
506 
507     function transferFrom(
508         address _from, 
509         address _to, 
510         uint256 _value
511         ) returns (bool success) { 
512         
513         if (allowed[_from][msg.sender] < _value
514             || !transferFromTo(_from, _to, _value)) throw;
515             
516         allowed[_from][msg.sender] -= _value;
517 
518     }
519 
520     function approve(address _spender, uint256 _value) returns (bool success) {
521         allowed[msg.sender][_spender] = _value;
522         return true;
523     }
524 
525 }    
526   
527 
528 pragma solidity ^0.4.2;
529 
530 /*
531  *
532  * This file is part of Pass DAO.
533  *
534  * The Manager smart contract is used for the management of accounts and tokens.
535  * Allows to receive or withdraw ethers and to buy Dao shares.
536  * The contract derives to the Token Manager smart contract for the management of tokens.
537  *
538  * Recipient is 0 for the Dao account manager and the address of
539  * contractor's recipient for the contractors's mahagers.
540  *
541 */
542 
543 /// @title Manager smart contract of the Pass Decentralized Autonomous Organisation
544 contract PassManagerInterface is PassTokenManagerInterface {
545 
546     struct proposal {
547         // Amount (in wei) of the proposal
548         uint amount;
549         // A description of the proposal
550         string description;
551         // The hash of the proposal's document
552         bytes32 hashOfTheDocument;
553         // A unix timestamp, denoting the date when the proposal was created
554         uint dateOfProposal;
555         // The sum amount (in wei) ordered for this proposal 
556         uint orderAmount;
557         // A unix timestamp, denoting the date of the last order for the approved proposal
558         uint dateOfOrder;
559     }
560         
561     // Proposals to work for the client
562     proposal[] public proposals;
563     
564     /// @dev The constructor function
565     /// @param _creator The address of the creator
566     /// @param _client The address of the Dao
567     /// @param _recipient The address of the recipient. 0 for the Dao
568     //function PassManager(
569         //address _creator,
570         //address _client,
571         //address _recipient
572     //) PassTokenManager(
573         //_creator,
574         //_client,
575         //_recipient);
576 
577     /// @notice Fallback function to allow sending ethers to this smart contract
578     function () payable;
579     
580     /// @notice Function to update the recipent address
581     /// @param _newRecipient The adress of the recipient
582     function updateRecipient(address _newRecipient);
583 
584     /// @notice Function to buy Dao shares according to the funding rules 
585     /// with `msg.sender` as the beneficiary
586     function buyShares() payable;
587     
588     /// @notice Function to buy Dao shares according to the funding rules 
589     /// @param _recipient The beneficiary of the created shares
590     function buySharesFor(address _recipient) payable;
591 
592     /// @notice Function to make a proposal to work for the client
593     /// @param _amount The amount (in wei) of the proposal
594     /// @param _description String describing the proposal
595     /// @param _hashOfTheDocument The hash of the proposal document
596     /// @return The index of the contractor proposal
597     function newProposal(
598         uint _amount,
599         string _description, 
600         bytes32 _hashOfTheDocument
601     ) returns (uint);
602     
603     /// @notice Function used by the client to order according to the contractor proposal
604     /// @param _proposalID The index of the contractor proposal
605     /// @param _amount The amount (in wei) of the order
606     /// @return Whether the order was made or not
607     function order(
608         uint _proposalID,
609         uint _amount
610     ) external returns (bool) ;
611     
612     /// @notice Function used by the client to send ethers from the Dao manager
613     /// @param _recipient The address to send to
614     /// @param _amount The amount (in wei) to send
615     /// @return Whether the transfer was successful or not
616     function sendTo(
617         address _recipient, 
618         uint _amount
619     ) external returns (bool);
620 
621     /// @notice Function to allow contractors to withdraw ethers
622     /// @param _amount The amount (in wei) to withdraw
623     function withdraw(uint _amount);
624     
625     event ProposalAdded(uint indexed ProposalID, uint Amount, string Description);
626     event Order(uint indexed ProposalID, uint Amount);
627     event Withdawal(address indexed Recipient, uint Amount);
628 
629 }    
630 
631 contract PassManager is PassManagerInterface, PassTokenManager {
632 
633     function PassManager(
634         address _creator,
635         address _client,
636         address _recipient
637     ) PassTokenManager(
638         _creator,
639         _client,
640         _recipient
641         ) {
642         proposals.length = 1;
643     }
644 
645     function () payable {}
646 
647     function updateRecipient(address _newRecipient) onlyContractor {
648 
649         if (_newRecipient == 0 
650             || _newRecipient == client) throw;
651 
652         recipient = _newRecipient;
653     } 
654 
655     function buyShares() payable {
656         buySharesFor(msg.sender);
657     } 
658     
659     function buySharesFor(address _recipient) payable onlyDao {
660         
661         if (!FundingRules[0].publicCreation 
662             || !createToken(_recipient, msg.value, now)) throw;
663 
664     }
665    
666     function newProposal(
667         uint _amount,
668         string _description, 
669         bytes32 _hashOfTheDocument
670     ) onlyContractor returns (uint) {
671 
672         uint _proposalID = proposals.length++;
673         proposal c = proposals[_proposalID];
674 
675         c.amount = _amount;
676         c.description = _description;
677         c.hashOfTheDocument = _hashOfTheDocument; 
678         c.dateOfProposal = now;
679         
680         ProposalAdded(_proposalID, c.amount, c.description);
681         
682         return _proposalID;
683         
684     }
685     
686     function order(
687         uint _proposalID,
688         uint _orderAmount
689     ) external onlyClient returns (bool) {
690     
691         proposal c = proposals[_proposalID];
692         
693         uint _sum = c.orderAmount + _orderAmount;
694         if (_sum > c.amount
695             || _sum < c.orderAmount
696             || _sum < _orderAmount) return; 
697 
698         c.orderAmount = _sum;
699         c.dateOfOrder = now;
700         
701         Order(_proposalID, _orderAmount);
702         
703         return true;
704 
705     }
706 
707     function sendTo(
708         address _recipient,
709         uint _amount
710     ) external onlyClient onlyDao returns (bool) {
711     
712         if (_recipient.send(_amount)) return true;
713         else return false;
714 
715     }
716    
717     function withdraw(uint _amount) onlyContractor {
718         if (!recipient.send(_amount)) throw;
719         Withdawal(recipient, _amount);
720     }
721     
722 }    
723 
724 contract PassManagerCreator {
725     event NewPassManager(address Creator, address Client, address Recipient, address PassManager);
726     function createManager(
727         address _client,
728         address _recipient
729         ) returns (PassManager) {
730         PassManager _passManager = new PassManager(
731             msg.sender,
732             _client,
733             _recipient
734         );
735         NewPassManager(msg.sender, _client, _recipient, _passManager);
736         return _passManager;
737     }
738 }
739 
740 pragma solidity ^0.4.2;
741 
742 /*
743 This file is part of Pass DAO.
744 
745 Pass DAO is free software: you can redistribute it and/or modify
746 it under the terms of the GNU lesser General Public License as published by
747 the Free Software Foundation, either version 3 of the License, or
748 (at your option) any later version.
749 
750 Pass DAO is distributed in the hope that it will be useful,
751 but WITHOUT ANY WARRANTY; without even the implied warranty of
752 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
753 GNU lesser General Public License for more details.
754 
755 You should have received a copy of the GNU lesser General Public License
756 along with Pass DAO.  If not, see <http://www.gnu.org/licenses/>.
757 */
758 
759 /*
760 Smart contract for a Decentralized Autonomous Organization (DAO)
761 to automate organizational governance and decision-making.
762 */
763 
764 /// @title Pass Decentralized Autonomous Organisation
765 contract PassDaoInterface {
766 
767     struct BoardMeeting {        
768         // Address of the creator of the board meeting for a proposal
769         address creator;  
770         // Index to identify the proposal to pay a contractor or fund the Dao
771         uint proposalID;
772         // Index to identify the proposal to update the Dao rules 
773         uint daoRulesProposalID; 
774         // unix timestamp, denoting the end of the set period of a proposal before the board meeting 
775         uint setDeadline;
776         // Fees (in wei) paid by the creator of the board meeting
777         uint fees;
778         // Total of fees (in wei) rewarded to the voters or to the Dao account manager for the balance
779         uint totalRewardedAmount;
780         // A unix timestamp, denoting the end of the voting period
781         uint votingDeadline;
782         // True if the proposal's votes have yet to be counted, otherwise False
783         bool open; 
784         // A unix timestamp, denoting the date of the execution of the approved proposal
785         uint dateOfExecution;
786         // Number of shares in favor of the proposal
787         uint yea; 
788         // Number of shares opposed to the proposal
789         uint nay; 
790         // mapping to indicate if a shareholder has voted
791         mapping (address => bool) hasVoted;  
792     }
793 
794     struct Proposal {
795         // Index to identify the board meeting of the proposal
796         uint boardMeetingID;
797         // The contractor manager smart contract
798         PassManager contractorManager;
799         // The index of the contractor proposal
800         uint contractorProposalID;
801         // The amount (in wei) of the proposal
802         uint amount; 
803         // True if the proposal foresees a contractor token creation
804         bool tokenCreation;
805         // True if public funding without a main partner
806         bool publicShareCreation; 
807         // The address which sets partners and manages the funding in case of private funding
808         address mainPartner;
809         // The initial price multiplier of Dao shares at the beginning of the funding
810         uint initialSharePriceMultiplier; 
811         // The inflation rate to calculate the actual contractor share price
812         uint inflationRate;
813         // A unix timestamp, denoting the start time of the funding
814         uint minutesFundingPeriod;
815         // True if the proposal is closed
816         bool open; 
817     }
818 
819     struct Rules {
820         // Index to identify the board meeting that decides to apply or not the Dao rules
821         uint boardMeetingID;  
822         // The quorum needed for each proposal is calculated by totalSupply / minQuorumDivisor
823         uint minQuorumDivisor;  
824         // Minimum fees (in wei) to create a proposal
825         uint minBoardMeetingFees; 
826         // Period in minutes to consider or set a proposal before the voting procedure
827         uint minutesSetProposalPeriod; 
828         // The minimum debate period in minutes that a generic proposal can have
829         uint minMinutesDebatePeriod;
830         // The inflation rate to calculate the reward of fees to voters during a board meeting 
831         uint feesRewardInflationRate;
832         // True if the dao rules allow the transfer of shares
833         bool transferable;
834     } 
835 
836     // The creator of the Dao
837     address creator;
838     // The minimum periods in minutes 
839     uint public minMinutesPeriods;
840     // The maximum period in minutes for proposals (set+debate)
841     uint public maxMinutesProposalPeriod;
842     // The maximum funding period in minutes for funding proposals
843     uint public maxMinutesFundingPeriod;
844     // The maximum inflation rate for share price or rewards to voters
845     uint public maxInflationRate;
846 
847     // The Dao manager smart contract
848     PassManager public daoManager;
849     
850     // Map to allow the share holders to withdraw board meeting fees
851     mapping (address => uint) public pendingFeesWithdrawals;
852 
853     // Board meetings to vote for or against a proposal
854     BoardMeeting[] public BoardMeetings; 
855     // Proposals to pay a contractor or fund the Dao
856     Proposal[] public Proposals;
857     // Proposals to update the Dao rules
858     Rules[] public DaoRulesProposals;
859     // The current Dao rules
860     Rules public DaoRules; 
861     
862     /// @dev The constructor function
863     //function PassDao();
864 
865     /// @dev Function to initialize the Dao
866     /// @param _daoManager Address of the Dao manager smart contract
867     /// @param _maxInflationRate The maximum inflation rate for contractor and funding proposals
868     /// @param _minMinutesPeriods The minimum periods in minutes
869     /// @param _maxMinutesFundingPeriod The maximum funding period in minutes for funding proposals
870     /// @param _maxMinutesProposalPeriod The maximum period in minutes for proposals (set+debate)
871     /// @param _minQuorumDivisor The initial minimum quorum divisor for the proposals
872     /// @param _minBoardMeetingFees The amount (in wei) to make a proposal and ask for a board meeting
873     /// @param _minutesSetProposalPeriod The minimum period in minutes before a board meeting
874     /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
875     /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a board meeting
876     function initDao(
877         address _daoManager,
878         uint _maxInflationRate,
879         uint _minMinutesPeriods,
880         uint _maxMinutesFundingPeriod,
881         uint _maxMinutesProposalPeriod,
882         uint _minQuorumDivisor,
883         uint _minBoardMeetingFees,
884         uint _minutesSetProposalPeriod,
885         uint _minMinutesDebatePeriod,
886         uint _feesRewardInflationRate
887         );
888     
889     /// @dev Internal function to create a board meeting
890     /// @param _proposalID The index of the proposal if for a contractor or for a funding
891     /// @param _daoRulesProposalID The index of the proposal if Dao rules
892     /// @param _minutesDebatingPeriod The duration in minutes of the meeting
893     /// @return the index of the board meeting
894     function newBoardMeeting(
895         uint _proposalID, 
896         uint _daoRulesProposalID, 
897         uint _minutesDebatingPeriod
898     ) internal returns (uint);
899     
900     /// @notice Function to make a proposal to pay a contractor or fund the Dao
901     /// @param _contractorManager Address of the contractor manager smart contract
902     /// @param _contractorProposalID Index of the contractor proposal of the contractor manager
903     /// @param _amount The amount (in wei) of the proposal
904     /// @param _tokenCreation True if the proposal foresees a contractor token creation
905     /// @param _publicShareCreation True if public funding without a main partner
906     /// @param _mainPartner The address which sets partners and manage the funding 
907     /// in case of private funding (not mandatory)
908     /// @param _initialSharePriceMultiplier The initial price multiplier of shares
909     /// @param _inflationRate If 0, the share price doesn't change during the funding (not mandatory)
910     /// @param _minutesFundingPeriod Period in minutes of the funding
911     /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
912     /// @return The index of the proposal
913     function newProposal(
914         address _contractorManager,
915         uint _contractorProposalID,
916         uint _amount, 
917         bool _publicShareCreation,
918         bool _tokenCreation,
919         address _mainPartner,
920         uint _initialSharePriceMultiplier, 
921         uint _inflationRate,
922         uint _minutesFundingPeriod,
923         uint _minutesDebatingPeriod
924     ) payable returns (uint);
925 
926     /// @notice Function to make a proposal to change the Dao rules 
927     /// @param _minQuorumDivisor If 5, the minimum quorum is 20%
928     /// @param _minBoardMeetingFees The amount (in wei) to make a proposal and ask for a board meeting
929     /// @param _minutesSetProposalPeriod Minimum period in minutes before a board meeting
930     /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
931     /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a board meeting
932     /// @param _transferable True if the proposal foresees to allow the transfer of Dao shares
933     /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
934     function newDaoRulesProposal(
935         uint _minQuorumDivisor, 
936         uint _minBoardMeetingFees,
937         uint _minutesSetProposalPeriod,
938         uint _minMinutesDebatePeriod,
939         uint _feesRewardInflationRate,
940         bool _transferable,
941         uint _minutesDebatingPeriod
942     ) payable returns (uint);
943     
944     /// @notice Function to vote during a board meeting
945     /// @param _boardMeetingID The index of the board meeting
946     /// @param _supportsProposal True if the proposal is supported
947     function vote(
948         uint _boardMeetingID, 
949         bool _supportsProposal
950     );
951 
952     /// @notice Function to execute a board meeting decision and close the board meeting
953     /// @param _boardMeetingID The index of the board meeting
954     /// @return Whether the proposal was executed or not
955     function executeDecision(uint _boardMeetingID) returns (bool);
956     
957     /// @notice Function to order a contractor proposal
958     /// @param _proposalID The index of the proposal
959     /// @return Whether the proposal was ordered and the proposal amount sent or not
960     function orderContractorProposal(uint _proposalID) returns (bool);   
961 
962     /// @notice Function to withdraw the rewarded board meeting fees
963     /// @return Whether the withdraw was successful or not    
964     function withdrawBoardMeetingFees() returns (bool);
965 
966     /// @return The minimum quorum for proposals to pass 
967     function minQuorum() constant returns (uint);
968     
969     event ProposalAdded(uint indexed ProposalID, address indexed ContractorManager, uint ContractorProposalID, 
970             uint amount, address indexed MainPartner, uint InitialSharePriceMultiplier, uint MinutesFundingPeriod);
971     event DaoRulesProposalAdded(uint indexed DaoRulesProposalID, uint MinQuorumDivisor, uint MinBoardMeetingFees, 
972             uint MinutesSetProposalPeriod, uint MinMinutesDebatePeriod, uint FeesRewardInflationRate, bool Transferable);
973     event SentToContractor(uint indexed ContractorProposalID, address indexed ContractorManagerAddress, uint AmountSent);
974     event BoardMeetingClosed(uint indexed BoardMeetingID, uint FeesGivenBack, bool ProposalExecuted);
975     
976 }
977 
978 contract PassDao is PassDaoInterface {
979 
980     function PassDao() {}
981     
982     function initDao(
983         address _daoManager,
984         uint _maxInflationRate,
985         uint _minMinutesPeriods,
986         uint _maxMinutesFundingPeriod,
987         uint _maxMinutesProposalPeriod,
988         uint _minQuorumDivisor,
989         uint _minBoardMeetingFees,
990         uint _minutesSetProposalPeriod,
991         uint _minMinutesDebatePeriod,
992         uint _feesRewardInflationRate
993         ) {
994             
995         
996         if (DaoRules.minQuorumDivisor != 0) throw;
997 
998         daoManager = PassManager(_daoManager);
999 
1000         maxInflationRate = _maxInflationRate;
1001         minMinutesPeriods = _minMinutesPeriods;
1002         maxMinutesFundingPeriod = _maxMinutesFundingPeriod;
1003         maxMinutesProposalPeriod = _maxMinutesProposalPeriod;
1004         
1005         DaoRules.minQuorumDivisor = _minQuorumDivisor;
1006         DaoRules.minBoardMeetingFees = _minBoardMeetingFees;
1007         DaoRules.minutesSetProposalPeriod = _minutesSetProposalPeriod;
1008         DaoRules.minMinutesDebatePeriod = _minMinutesDebatePeriod;
1009         DaoRules.feesRewardInflationRate = _feesRewardInflationRate;
1010 
1011         BoardMeetings.length = 1; 
1012         Proposals.length = 1;
1013         DaoRulesProposals.length = 1;
1014         
1015     }
1016     
1017     function newBoardMeeting(
1018         uint _proposalID, 
1019         uint _daoRulesProposalID, 
1020         uint _minutesDebatingPeriod
1021     ) internal returns (uint) {
1022 
1023         if (msg.value < DaoRules.minBoardMeetingFees
1024             || DaoRules.minutesSetProposalPeriod + _minutesDebatingPeriod > maxMinutesProposalPeriod
1025             || now + ((DaoRules.minutesSetProposalPeriod + _minutesDebatingPeriod) * 1 minutes) < now
1026             || _minutesDebatingPeriod < DaoRules.minMinutesDebatePeriod
1027             || msg.sender == address(this)) throw;
1028 
1029         uint _boardMeetingID = BoardMeetings.length++;
1030         BoardMeeting b = BoardMeetings[_boardMeetingID];
1031 
1032         b.creator = msg.sender;
1033 
1034         b.proposalID = _proposalID;
1035         b.daoRulesProposalID = _daoRulesProposalID;
1036 
1037         b.fees = msg.value;
1038         
1039         b.setDeadline = now + (DaoRules.minutesSetProposalPeriod * 1 minutes);        
1040         b.votingDeadline = b.setDeadline + (_minutesDebatingPeriod * 1 minutes); 
1041 
1042         b.open = true; 
1043 
1044         return _boardMeetingID;
1045 
1046     }
1047 
1048     function newProposal(
1049         address _contractorManager,
1050         uint _contractorProposalID,
1051         uint _amount, 
1052         bool _tokenCreation,
1053         bool _publicShareCreation,
1054         address _mainPartner,
1055         uint _initialSharePriceMultiplier, 
1056         uint _inflationRate,
1057         uint _minutesFundingPeriod,
1058         uint _minutesDebatingPeriod
1059     ) payable returns (uint) {
1060 
1061         if ((_contractorManager != 0 && _contractorProposalID == 0)
1062             || (_contractorManager == 0 
1063                 && (_initialSharePriceMultiplier == 0
1064                     || _contractorProposalID != 0)
1065             || (_tokenCreation && _publicShareCreation)
1066             || (_initialSharePriceMultiplier != 0
1067                 && (_minutesFundingPeriod < minMinutesPeriods
1068                     || _inflationRate > maxInflationRate
1069                     || _minutesFundingPeriod > maxMinutesFundingPeriod)))) throw;
1070 
1071         uint _proposalID = Proposals.length++;
1072         Proposal p = Proposals[_proposalID];
1073 
1074         p.contractorManager = PassManager(_contractorManager);
1075         p.contractorProposalID = _contractorProposalID;
1076         
1077         p.amount = _amount;
1078         p.tokenCreation = _tokenCreation;
1079 
1080         p.publicShareCreation = _publicShareCreation;
1081         p.mainPartner = _mainPartner;
1082         p.initialSharePriceMultiplier = _initialSharePriceMultiplier;
1083         p.inflationRate = _inflationRate;
1084         p.minutesFundingPeriod = _minutesFundingPeriod;
1085 
1086         p.boardMeetingID = newBoardMeeting(_proposalID, 0, _minutesDebatingPeriod);   
1087 
1088         p.open = true;
1089         
1090         ProposalAdded(_proposalID, p.contractorManager, p.contractorProposalID, p.amount, p.mainPartner, 
1091             p.initialSharePriceMultiplier, _minutesFundingPeriod);
1092 
1093         return _proposalID;
1094         
1095     }
1096 
1097     function newDaoRulesProposal(
1098         uint _minQuorumDivisor, 
1099         uint _minBoardMeetingFees,
1100         uint _minutesSetProposalPeriod,
1101         uint _minMinutesDebatePeriod,
1102         uint _feesRewardInflationRate,
1103         bool _transferable,
1104         uint _minutesDebatingPeriod
1105     ) payable returns (uint) {
1106     
1107         if (_minQuorumDivisor <= 1
1108             || _minQuorumDivisor > 10
1109             || _minutesSetProposalPeriod < minMinutesPeriods
1110             || _minMinutesDebatePeriod < minMinutesPeriods
1111             || _minutesSetProposalPeriod + _minMinutesDebatePeriod > maxMinutesProposalPeriod
1112             || _feesRewardInflationRate > maxInflationRate
1113             ) throw; 
1114         
1115         uint _DaoRulesProposalID = DaoRulesProposals.length++;
1116         Rules r = DaoRulesProposals[_DaoRulesProposalID];
1117 
1118         r.minQuorumDivisor = _minQuorumDivisor;
1119         r.minBoardMeetingFees = _minBoardMeetingFees;
1120         r.minutesSetProposalPeriod = _minutesSetProposalPeriod;
1121         r.minMinutesDebatePeriod = _minMinutesDebatePeriod;
1122         r.feesRewardInflationRate = _feesRewardInflationRate;
1123         r.transferable = _transferable;
1124         
1125         r.boardMeetingID = newBoardMeeting(0, _DaoRulesProposalID, _minutesDebatingPeriod);     
1126 
1127         DaoRulesProposalAdded(_DaoRulesProposalID, _minQuorumDivisor, _minBoardMeetingFees, 
1128             _minutesSetProposalPeriod, _minMinutesDebatePeriod, _feesRewardInflationRate ,_transferable);
1129 
1130         return _DaoRulesProposalID;
1131         
1132     }
1133     
1134     function vote(
1135         uint _boardMeetingID, 
1136         bool _supportsProposal
1137     ) {
1138         
1139         BoardMeeting b = BoardMeetings[_boardMeetingID];
1140 
1141         if (b.hasVoted[msg.sender] 
1142             || now < b.setDeadline
1143             || now > b.votingDeadline) throw;
1144 
1145         uint _balance = uint(daoManager.balanceOf(msg.sender));
1146         if (_balance == 0) throw;
1147         
1148         b.hasVoted[msg.sender] = true;
1149 
1150         if (_supportsProposal) b.yea += _balance;
1151         else b.nay += _balance; 
1152 
1153         if (b.fees > 0 && b.proposalID != 0 && Proposals[b.proposalID].contractorProposalID != 0) {
1154 
1155             uint _a = 100*b.fees;
1156             if ((_a/100 != b.fees) || ((_a*_balance)/_a != _balance)) throw;
1157             uint _multiplier = (_a*_balance)/uint(daoManager.TotalSupply());
1158 
1159             uint _divisor = 100 + 100*DaoRules.feesRewardInflationRate*(now - b.setDeadline)/(100*365 days);
1160 
1161             uint _rewardedamount = _multiplier/_divisor;
1162             
1163             if (b.totalRewardedAmount + _rewardedamount > b.fees) _rewardedamount = b.fees - b.totalRewardedAmount;
1164             b.totalRewardedAmount += _rewardedamount;
1165             pendingFeesWithdrawals[msg.sender] += _rewardedamount;
1166         }
1167 
1168         daoManager.blockTransfer(msg.sender, b.votingDeadline);
1169 
1170     }
1171 
1172     function executeDecision(uint _boardMeetingID) returns (bool) {
1173 
1174         BoardMeeting b = BoardMeetings[_boardMeetingID];
1175         Proposal p = Proposals[b.proposalID];
1176         
1177         if (now < b.votingDeadline || !b.open) throw;
1178         
1179         b.open = false;
1180         if (p.contractorProposalID == 0) p.open = false;
1181 
1182         uint _fees;
1183         uint _minQuorum = minQuorum();
1184 
1185         if (b.fees > 0
1186             && (b.proposalID == 0 || p.contractorProposalID == 0)
1187             && b.yea + b.nay >= _minQuorum) {
1188                     _fees = b.fees;
1189                     b.fees = 0;
1190                     pendingFeesWithdrawals[b.creator] += _fees;
1191         }        
1192 
1193         if (b.fees - b.totalRewardedAmount > 0) {
1194             if (!daoManager.send(b.fees - b.totalRewardedAmount)) throw;
1195         }
1196         
1197         if (b.yea + b.nay < _minQuorum || b.yea <= b.nay) {
1198             p.open = false;
1199             BoardMeetingClosed(_boardMeetingID, _fees, false);
1200             return;
1201         }
1202 
1203         b.dateOfExecution = now;
1204 
1205         if (b.proposalID != 0) {
1206             
1207             if (p.initialSharePriceMultiplier != 0) {
1208 
1209                 daoManager.setFundingRules(p.mainPartner, p.publicShareCreation, p.initialSharePriceMultiplier, 
1210                     p.amount, p.minutesFundingPeriod, p.inflationRate, b.proposalID);
1211 
1212                 if (p.contractorProposalID != 0 && p.tokenCreation) {
1213                     p.contractorManager.setFundingRules(p.mainPartner, p.publicShareCreation, 0, 
1214                         p.amount, p.minutesFundingPeriod, maxInflationRate, b.proposalID);
1215                 }
1216 
1217             }
1218 
1219         } else {
1220 
1221             Rules r = DaoRulesProposals[b.daoRulesProposalID];
1222             DaoRules.boardMeetingID = r.boardMeetingID;
1223 
1224             DaoRules.minQuorumDivisor = r.minQuorumDivisor;
1225             DaoRules.minMinutesDebatePeriod = r.minMinutesDebatePeriod; 
1226             DaoRules.minBoardMeetingFees = r.minBoardMeetingFees;
1227             DaoRules.minutesSetProposalPeriod = r.minutesSetProposalPeriod;
1228             DaoRules.feesRewardInflationRate = r.feesRewardInflationRate;
1229 
1230             DaoRules.transferable = r.transferable;
1231             if (r.transferable) daoManager.ableTransfer();
1232             else daoManager.disableTransfer();
1233         }
1234             
1235         BoardMeetingClosed(_boardMeetingID, _fees, true);
1236 
1237         return true;
1238         
1239     }
1240     
1241     function orderContractorProposal(uint _proposalID) returns (bool) {
1242         
1243         Proposal p = Proposals[_proposalID];
1244         BoardMeeting b = BoardMeetings[p.boardMeetingID];
1245 
1246         if (b.open || !p.open) throw;
1247         
1248         uint _amount = p.amount;
1249 
1250         if (p.initialSharePriceMultiplier != 0) {
1251             _amount = daoManager.FundedAmount(_proposalID);
1252             if (_amount == 0 && now < b.dateOfExecution + (p.minutesFundingPeriod * 1 minutes)) return;
1253         }
1254         
1255         p.open = false;   
1256 
1257         if (_amount == 0 || !p.contractorManager.order(p.contractorProposalID, _amount)) return;
1258         
1259         if (!daoManager.sendTo(p.contractorManager, _amount)) throw;
1260         SentToContractor(p.contractorProposalID, address(p.contractorManager), _amount);
1261         
1262         return true;
1263 
1264     }
1265     
1266     function withdrawBoardMeetingFees() returns (bool) {
1267 
1268         uint _amount = pendingFeesWithdrawals[msg.sender];
1269 
1270         pendingFeesWithdrawals[msg.sender] = 0;
1271 
1272         if (msg.sender.send(_amount)) {
1273             return true;
1274         } else {
1275             pendingFeesWithdrawals[msg.sender] = _amount;
1276             return false;
1277         }
1278 
1279     }
1280 
1281     function minQuorum() constant returns (uint) {
1282         return (uint(daoManager.TotalSupply()) / DaoRules.minQuorumDivisor);
1283     }
1284     
1285 }