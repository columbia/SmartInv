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
743  *
744  * This file is part of the DAO.
745  *
746  * Smart contract used for the funding of Pass Dao.
747  *
748 */
749 
750 /// @title Funding smart contract for the Pass Decentralized Autonomous Organisation
751 contract PassFundingInterface {
752 
753     struct Partner {
754         // The address of the partner
755         address partnerAddress; 
756         // The amount (in wei) that the partner wish to fund
757         uint presaleAmount;
758         // The unix timestamp denoting the average date of the presale of the partner 
759         uint presaleDate;
760         // The funding amount (in wei) according to the set limits
761         uint fundingAmountLimit;
762         // The amount (in wei) that the partner funded to the Dao
763         uint fundedAmount;
764         // True if the partner can fund the dao
765         bool valid;
766     }
767 
768     // Address of the creator of this contract
769     address public creator;
770     // The manager smart contract to fund
771     PassManager public DaoManager;
772     // True if contractor token creation
773     bool tokenCreation;            
774     // The manager smart contract for the reward of contractor tokens
775     PassManager public contractorManager;
776     // Minimum amount (in wei) to fund
777     uint public minFundingAmount;
778     // Minimum amount (in wei) that partners can send to this smart contract
779     uint public minPresaleAmount;
780     // Maximum amount (in wei) that partners can send to this smart contract
781     uint public maxPresaleAmount;
782     // The unix start time of the presale
783     uint public startTime;
784     // The unix closing time of the funding
785     uint public closingTime;
786     /// The amount (in wei) below this limit can fund the dao
787     uint minAmountLimit;
788     /// Maximum amount (in wei) a partner can fund
789     uint maxAmountLimit; 
790     /// The partner can fund below the minimum amount limit or a set percentage of his ether balance 
791     uint divisorBalanceLimit;
792     /// The partner can fund below the minimum amount limit or a set percentage of his shares balance in the Dao
793     uint multiplierSharesLimit;
794     /// The partner can fund below the minimum amount limit or a set percentage of his shares balance in the Dao 
795     uint divisorSharesLimit;
796     // True if the amount and divisor balance limits for the funding are set
797     bool public limitSet;
798     // True if all the partners are set by the creator and the funding can be completed 
799     bool public allSet;
800     // Array of partners who wish to fund the dao
801     Partner[] public partners;
802     // Map with the indexes of the partners
803     mapping (address => uint) public partnerID; 
804     // The total funded amount (in wei)
805     uint public totalFunded; 
806     // The calculated sum of funding amout limits (in wei) according to the set limits
807     uint sumOfFundingAmountLimits;
808     
809     // To allow the creator to pause during the presale
810     uint public pauseClosingTime;
811     // To allow the creator to abort the funding before the closing time
812     bool IsfundingAborted;
813     
814     // To allow the set of partners in several times
815     uint setFromPartner;
816     // To allow the refund for partners in several times
817     uint refundFromPartner;
818 
819     // The manager of this funding is the creator of this contract
820     modifier onlyCreator {if (msg.sender != creator) throw; _ ;}
821 
822     /// @dev Constructor function
823     /// @param _creator The creator of the smart contract
824     /// @param _DaoManager The Dao manager smart contract
825     /// for the reward of tokens (not mandatory)
826     /// @param _minAmount Minimum amount (in wei) of the funding to be fueled 
827     /// @param _startTime The unix start time of the presale
828     /// @param _closingTime The unix closing time of the funding
829     //function PassFunding (
830         //address _creator,
831         //address _DaoManager,
832         //uint _minAmount,
833         //uint _startTime,
834         //uint _closingTime
835     //);
836 
837     /// @notice Function used by the creator to set the contractor manager smart contract
838     /// @param _contractorManager The address of the contractor manager smart contract
839     function SetContractorManager(address _contractorManager);
840     
841     /// @notice Function used by the creator to set the presale limits
842     /// @param _minPresaleAmount Minimum amount (in wei) that partners can send
843     /// @param _maxPresaleAmount Maximum amount (in wei) that partners can send
844     function SetPresaleAmountLimits(
845         uint _minPresaleAmount,
846         uint _maxPresaleAmount
847         );
848 
849     /// @dev Fallback function
850     function () payable;
851 
852     /// @notice Function to participate in the presale of the funding
853     /// @return Whether the presale was successful or not
854     function presale() payable returns (bool);
855     
856     /// @notice Function used by the creator to set addresses that can fund the dao
857     /// @param _valid True if the address can fund the Dao
858     /// @param _from The index of the first partner to set
859     /// @param _to The index of the last partner to set
860     function setPartners(
861             bool _valid,
862             uint _from,
863             uint _to
864         );
865 
866     /// @notice Function used by the creator to set the addresses of Dao share holders
867     /// @param _valid True if the address can fund the Dao
868     /// @param _from The index of the first partner to set
869     /// @param _to The index of the last partner to set
870     function setShareHolders(
871             bool _valid,
872             uint _from,
873             uint _to
874         );
875     
876     /// @notice Function to allow the creator to abort the funding before the closing time
877     function abortFunding();
878     
879     /// @notice Function To allow the creator to pause during the presale
880     function pause(uint _pauseClosingTime) {
881         pauseClosingTime = _pauseClosingTime;
882     }
883 
884     /// @notice Function used by the creator to set the funding limits for the funding
885     /// @param _minAmountLimit The amount below this limit (in wei) can fund the dao
886     /// @param _maxAmountLimit Maximum amount (in wei) a partner can fund
887     /// @param _divisorBalanceLimit The creator can set a limit in percentage of Eth balance (not mandatory)
888     /// @param _multiplierSharesLimit The creator can set a limit in percentage of shares balance in the Dao (not mandatory)
889     /// @param _divisorSharesLimit The creator can set a limit in percentage of shares balance in the Dao (not mandatory) 
890     function setLimits(
891             uint _minAmountLimit,
892             uint _maxAmountLimit, 
893             uint _divisorBalanceLimit,
894             uint _multiplierSharesLimit,
895             uint _divisorSharesLimit
896     );
897 
898     /// @notice Function used to set the funding limits for partners
899     /// @param _to The index of the last partner to set
900     /// @return Whether the set was successful or not
901     function setFunding(uint _to) returns (bool _success);
902 
903     /// @notice Function for the funding of the Dao by a group of partners
904     /// @param _from The index of the first partner
905     /// @param _to The index of the last partner
906     /// @return Whether the Dao was funded or not
907     function fundDaoFor(
908             uint _from,
909             uint _to
910         ) returns (bool);
911     
912     /// @notice Function to fund the Dao with 'msg.sender' as 'beneficiary'
913     /// @return Whether the Dao was funded or not 
914     function fundDao() returns (bool);
915     
916     /// @notice Function to refund for a partner
917     /// @param _partnerID The index of the partner
918     /// @return Whether the refund was successful or not 
919     function refundFor(uint _partnerID) internal returns (bool);
920 
921     /// @notice Function to refund for valid partners before the closing time
922     /// @param _to The index of the last partner
923     function refundForValidPartners(uint _to);
924 
925     /// @notice Function to refund for a group of partners after the closing time
926     /// @param _from The index of the first partner
927     /// @param _to The index of the last partner
928     function refundForAll(
929         uint _from,
930         uint _to);
931 
932     /// @notice Function to refund after the closing time with 'msg.sender' as 'beneficiary'
933     function refund();
934 
935     /// @param _minAmountLimit The amount (in wei) below this limit can fund the dao
936     /// @param _maxAmountLimit Maximum amount (in wei) a partner can fund
937     /// @param _divisorBalanceLimit The partner can fund 
938     /// only under a defined percentage of his ether balance
939     /// @param _multiplierSharesLimit The partner can fund 
940     /// only under a defined percentage of his shares balance in the Dao 
941     /// @param _divisorSharesLimit The partner can fund 
942     /// only under a defined percentage of his shares balance in the Dao 
943     /// @param _from The index of the first partner
944     /// @param _to The index of the last partner
945     /// @return The result of the funding procedure (in wei) at present time
946     function estimatedFundingAmount(
947         uint _minAmountLimit,
948         uint _maxAmountLimit, 
949         uint _divisorBalanceLimit,
950         uint _multiplierSharesLimit,
951         uint _divisorSharesLimit,
952         uint _from,
953         uint _to
954         ) constant external returns (uint);
955 
956     /// @param _index The index of the partner
957     /// @param _minAmountLimit The amount (in wei) below this limit can fund the dao
958     /// @param _maxAmountLimit Maximum amount (in wei) a partner can fund
959     /// @param _divisorBalanceLimit The partner can fund 
960     /// only under a defined percentage of his ether balance 
961     /// @param _multiplierSharesLimit The partner can fund 
962     /// only under a defined percentage of his shares balance in the Dao 
963     /// @param _divisorSharesLimit The partner can fund 
964     /// only under a defined percentage of his shares balance in the Dao 
965     /// @return The maximum amount (in wei) a partner can fund
966     function partnerFundingLimit(
967         uint _index, 
968         uint _minAmountLimit,
969         uint _maxAmountLimit, 
970         uint _divisorBalanceLimit,
971         uint _multiplierSharesLimit,
972         uint _divisorSharesLimit
973         ) internal returns (uint);
974         
975     /// @return the number of partners
976     function numberOfPartners() constant external returns (uint);
977     
978     /// @param _from The index of the first partner
979     /// @param _to The index of the last partner
980     /// @return The number of valid partners
981     function numberOfValidPartners(
982         uint _from,
983         uint _to
984         ) constant external returns (uint);
985 
986     event ContractorManagerSet(address ContractorManagerAddress);
987     event IntentionToFund(address indexed partner, uint amount);
988     event Fund(address indexed partner, uint amount);
989     event Refund(address indexed partner, uint amount);
990     event LimitSet(uint minAmountLimit, uint maxAmountLimit, uint divisorBalanceLimit, 
991         uint _multiplierSharesLimit, uint divisorSharesLimit);
992     event PartnersNotSet(uint sumOfFundingAmountLimits);
993     event AllPartnersSet(uint fundingAmount);
994     event Fueled();
995     event FundingClosed();
996     
997 }
998 
999 contract PassFunding is PassFundingInterface {
1000 
1001     function PassFunding (
1002         address _creator,
1003         address _DaoManager,
1004         uint _minFundingAmount,
1005         uint _startTime,
1006         uint _closingTime
1007         ) {
1008 
1009         if (_creator == _DaoManager
1010             || _creator == 0
1011             || _DaoManager == 0
1012             || (_startTime < now && _startTime != 0)) throw;
1013             
1014         creator = _creator;
1015         DaoManager = PassManager(_DaoManager);
1016 
1017         minFundingAmount = _minFundingAmount;
1018 
1019         if (_startTime == 0) {startTime = now;} else {startTime = _startTime;}
1020 
1021         if (_closingTime <= startTime) throw;
1022         closingTime = _closingTime;
1023         
1024         setFromPartner = 1;
1025         refundFromPartner = 1;
1026 
1027         partners.length = 1; 
1028         
1029     }
1030     
1031     function SetContractorManager(address _contractorManager) onlyCreator {
1032         
1033         if (_contractorManager == 0
1034             || limitSet
1035             || address(contractorManager) != 0
1036             || creator == _contractorManager
1037             || _contractorManager == address(DaoManager)) throw;
1038             
1039         tokenCreation = true;            
1040         contractorManager = PassManager(_contractorManager);
1041         ContractorManagerSet(_contractorManager);
1042         
1043     }
1044 
1045     function SetPresaleAmountLimits(
1046         uint _minPresaleAmount,
1047         uint _maxPresaleAmount
1048         ) onlyCreator {
1049 
1050         if (limitSet) throw;
1051         
1052         minPresaleAmount = _minPresaleAmount;
1053         maxPresaleAmount = _maxPresaleAmount;
1054 
1055     }
1056 
1057     function () payable {
1058         if (!presale()) throw;
1059     }
1060 
1061     function presale() payable returns (bool) {
1062 
1063         if (msg.value <= 0
1064             || now < startTime
1065             || now > closingTime
1066             || now < pauseClosingTime
1067             || limitSet
1068             || msg.value < minPresaleAmount
1069             || msg.value > maxPresaleAmount
1070             || msg.sender == creator
1071         ) throw;
1072         
1073         if (partnerID[msg.sender] == 0) {
1074 
1075             uint _partnerID = partners.length++;
1076             Partner t = partners[_partnerID];
1077              
1078             partnerID[msg.sender] = _partnerID;
1079             t.partnerAddress = msg.sender;
1080             
1081             t.presaleAmount += msg.value;
1082             t.presaleDate = now;
1083 
1084         } else {
1085 
1086             Partner p = partners[partnerID[msg.sender]];
1087             if (p.presaleAmount + msg.value > maxPresaleAmount) throw;
1088 
1089             p.presaleDate = (p.presaleDate*p.presaleAmount + now*msg.value)/(p.presaleAmount + msg.value);
1090             p.presaleAmount += msg.value;
1091 
1092         }    
1093         
1094         IntentionToFund(msg.sender, msg.value);
1095         
1096         return true;
1097         
1098     }
1099     
1100     function setPartners(
1101             bool _valid,
1102             uint _from,
1103             uint _to
1104         ) onlyCreator {
1105 
1106         if (limitSet
1107             ||_from < 1 
1108             || _to > partners.length - 1) throw;
1109         
1110         for (uint i = _from; i <= _to; i++) {
1111             Partner t = partners[i];
1112             t.valid = _valid;
1113         }
1114         
1115     }
1116 
1117     function setShareHolders(
1118             bool _valid,
1119             uint _from,
1120             uint _to
1121         ) onlyCreator {
1122 
1123         if (limitSet
1124             ||_from < 1 
1125             || _to > partners.length - 1) throw;
1126         
1127         for (uint i = _from; i <= _to; i++) {
1128             Partner t = partners[i];
1129             if (DaoManager.balanceOf(t.partnerAddress) != 0) t.valid = _valid;
1130         }
1131         
1132     }
1133     
1134     function abortFunding() onlyCreator {
1135         limitSet = true;
1136         maxPresaleAmount = 0;
1137         IsfundingAborted = true; 
1138     }
1139     
1140     function pause(uint _pauseClosingTime) onlyCreator {
1141         pauseClosingTime = _pauseClosingTime;
1142     }
1143     
1144     function setLimits(
1145             uint _minAmountLimit,
1146             uint _maxAmountLimit, 
1147             uint _divisorBalanceLimit,
1148             uint _multiplierSharesLimit,
1149             uint _divisorSharesLimit
1150     ) onlyCreator {
1151         
1152         if (limitSet) throw;
1153         
1154         minAmountLimit = _minAmountLimit;
1155         maxAmountLimit = _maxAmountLimit;
1156         divisorBalanceLimit = _divisorBalanceLimit;
1157         multiplierSharesLimit = _multiplierSharesLimit;
1158         divisorSharesLimit = _divisorSharesLimit;
1159 
1160         limitSet = true;
1161         
1162         LimitSet(_minAmountLimit, _maxAmountLimit, _divisorBalanceLimit, _multiplierSharesLimit, _divisorSharesLimit);
1163     
1164     }
1165 
1166     function setFunding(uint _to) onlyCreator returns (bool _success) {
1167 
1168         uint _fundingMaxAmount = DaoManager.fundingMaxAmount(address(this));
1169 
1170         if (!limitSet 
1171             || _fundingMaxAmount < minFundingAmount
1172             || setFromPartner > _to 
1173             || _to > partners.length - 1) throw;
1174 
1175         DaoManager.setFundingStartTime(startTime);
1176         if (tokenCreation) contractorManager.setFundingStartTime(startTime);
1177 
1178         if (setFromPartner == 1) sumOfFundingAmountLimits = 0;
1179         
1180         for (uint i = setFromPartner; i <= _to; i++) {
1181 
1182             partners[i].fundingAmountLimit = partnerFundingLimit(i, minAmountLimit, maxAmountLimit, 
1183                 divisorBalanceLimit, multiplierSharesLimit, divisorSharesLimit);
1184 
1185             sumOfFundingAmountLimits += partners[i].fundingAmountLimit;
1186 
1187         }
1188         
1189         setFromPartner = _to + 1;
1190         
1191         if (setFromPartner >= partners.length) {
1192 
1193             setFromPartner = 1;
1194 
1195             if (sumOfFundingAmountLimits < minFundingAmount 
1196                 || sumOfFundingAmountLimits > _fundingMaxAmount) {
1197 
1198                 maxPresaleAmount = 0;
1199                 IsfundingAborted = true; 
1200                 PartnersNotSet(sumOfFundingAmountLimits);
1201                 return;
1202 
1203             }
1204             else {
1205                 allSet = true;
1206                 AllPartnersSet(sumOfFundingAmountLimits);
1207                 return true;
1208             }
1209 
1210         }
1211 
1212     }
1213 
1214     function fundDaoFor(
1215             uint _from,
1216             uint _to
1217         ) returns (bool) {
1218 
1219         if (!allSet) throw;
1220         
1221         if (_from < 1 || _to > partners.length - 1) throw;
1222         
1223         address _partner;
1224         uint _amountToFund;
1225         uint _sumAmountToFund = 0;
1226 
1227         for (uint i = _from; i <= _to; i++) {
1228             
1229             _partner = partners[i].partnerAddress;
1230             _amountToFund = partners[i].fundingAmountLimit - partners[i].fundedAmount;
1231         
1232             if (_amountToFund > 0) {
1233 
1234                 partners[i].fundedAmount += _amountToFund;
1235                 _sumAmountToFund += _amountToFund;
1236 
1237                 DaoManager.rewardToken(_partner, _amountToFund, partners[i].presaleDate);
1238 
1239                 if (tokenCreation) {
1240                     contractorManager.rewardToken(_partner, _amountToFund, partners[i].presaleDate);
1241                 }
1242 
1243             }
1244 
1245         }
1246 
1247         if (_sumAmountToFund == 0) return;
1248         
1249         if (!DaoManager.send(_sumAmountToFund)) throw;
1250 
1251         totalFunded += _sumAmountToFund;
1252 
1253         if (totalFunded == sumOfFundingAmountLimits) {
1254             DaoManager.setFundingFueled(); 
1255             if (tokenCreation) contractorManager.setFundingFueled(); 
1256             Fueled();
1257         }
1258         
1259         return true;
1260 
1261     }
1262     
1263     function fundDao() returns (bool) {
1264         return fundDaoFor(partnerID[msg.sender], partnerID[msg.sender]);
1265     }
1266 
1267     function refundFor(uint _partnerID) internal returns (bool) {
1268 
1269         Partner t = partners[_partnerID];
1270         uint _amountnotToRefund = t.presaleAmount;
1271         uint _amountToRefund;
1272         
1273         if (t.presaleAmount > maxPresaleAmount && t.valid) {
1274             _amountnotToRefund = maxPresaleAmount;
1275         }
1276         
1277         if (t.fundedAmount > 0 || now > closingTime) {
1278             _amountnotToRefund = t.fundedAmount;
1279         }
1280 
1281         _amountToRefund = t.presaleAmount - _amountnotToRefund;
1282         if (_amountToRefund <= 0) return true;
1283 
1284         t.presaleAmount = _amountnotToRefund;
1285         if (t.partnerAddress.send(_amountToRefund)) {
1286             Refund(t.partnerAddress, _amountToRefund);
1287             return true;
1288         } else {
1289             t.presaleAmount = _amountnotToRefund + _amountToRefund;
1290             return false;
1291         }
1292 
1293     }
1294 
1295     function refundForValidPartners(uint _to) {
1296 
1297         if (refundFromPartner > _to || _to > partners.length - 1) throw;
1298         
1299         for (uint i = refundFromPartner; i <= _to; i++) {
1300             if (partners[i].valid) {
1301                 if (!refundFor(i)) throw;
1302             }
1303         }
1304 
1305         refundFromPartner = _to + 1;
1306         
1307         if (refundFromPartner >= partners.length) {
1308             refundFromPartner = 1;
1309 
1310             if ((totalFunded >= sumOfFundingAmountLimits && allSet && closingTime > now)
1311                 || IsfundingAborted) {
1312 
1313                 closingTime = now; 
1314                 FundingClosed(); 
1315 
1316             }
1317         }
1318         
1319     }
1320 
1321     function refundForAll(
1322         uint _from,
1323         uint _to) {
1324 
1325         if (_from < 1 || _to > partners.length - 1) throw;
1326         
1327         for (uint i = _from; i <= _to; i++) {
1328             if (!refundFor(i)) throw;
1329         }
1330 
1331     }
1332 
1333     function refund() {
1334         refundForAll(partnerID[msg.sender], partnerID[msg.sender]);
1335     }
1336 
1337     function estimatedFundingAmount(
1338         uint _minAmountLimit,
1339         uint _maxAmountLimit, 
1340         uint _divisorBalanceLimit,
1341         uint _multiplierSharesLimit,
1342         uint _divisorSharesLimit,
1343         uint _from,
1344         uint _to
1345         ) constant external returns (uint) {
1346 
1347         if (_from < 1 || _to > partners.length - 1) throw;
1348 
1349         uint _total = 0;
1350         
1351         for (uint i = _from; i <= _to; i++) {
1352             _total += partnerFundingLimit(i, _minAmountLimit, _maxAmountLimit, 
1353                 _divisorBalanceLimit, _multiplierSharesLimit, _divisorSharesLimit);
1354         }
1355 
1356         return _total;
1357 
1358     }
1359 
1360     function partnerFundingLimit(
1361         uint _index, 
1362         uint _minAmountLimit,
1363         uint _maxAmountLimit, 
1364         uint _divisorBalanceLimit,
1365         uint _multiplierSharesLimit,
1366         uint _divisorSharesLimit
1367         ) internal returns (uint) {
1368 
1369         uint _amount;
1370         uint _amount1;
1371 
1372         Partner t = partners[_index];
1373             
1374         if (t.valid) {
1375 
1376             _amount = t.presaleAmount;
1377             
1378             if (_divisorBalanceLimit > 0) {
1379                 _amount1 = uint(t.partnerAddress.balance)/uint(_divisorBalanceLimit);
1380                 if (_amount > _amount1) _amount = _amount1; 
1381                 }
1382 
1383             if (_multiplierSharesLimit > 0 && _divisorSharesLimit > 0) {
1384 
1385                 uint _balance = uint(DaoManager.balanceOf(t.partnerAddress));
1386 
1387                 uint _multiplier = _balance*_multiplierSharesLimit;
1388                 if (_multiplier/_balance != _multiplierSharesLimit) throw;
1389 
1390                 _amount1 = _multiplier/_divisorSharesLimit;
1391                 if (_amount > _amount1) _amount = _amount1; 
1392 
1393                 }
1394 
1395             if (_amount > _maxAmountLimit) _amount = _maxAmountLimit;
1396             
1397             if (_amount < _minAmountLimit) _amount = _minAmountLimit;
1398 
1399             if (_amount > t.presaleAmount) _amount = t.presaleAmount;
1400             
1401         }
1402         
1403         return _amount;
1404         
1405     }
1406 
1407     function numberOfPartners() constant external returns (uint) {
1408         return partners.length - 1;
1409     }
1410     
1411     function numberOfValidPartners(
1412         uint _from,
1413         uint _to
1414         ) constant external returns (uint) {
1415         
1416         if (_from < 1 || _to > partners.length-1) throw;
1417 
1418         uint _total = 0;
1419         
1420         for (uint i = _from; i <= _to; i++) {
1421             if (partners[i].valid) _total += 1;
1422         }
1423 
1424         return _total;
1425         
1426     }
1427 
1428 }
1429 
1430 contract PassFundingCreator {
1431     event NewFunding(address creator, address DaoManager, 
1432         uint MinFundingAmount, uint StartTime, uint ClosingTime, address FundingContractAddress);
1433     function createFunding(
1434         address _DaoManager,
1435         uint _minFundingAmount,
1436         uint _startTime,
1437         uint _closingTime
1438         ) returns (PassFunding) {
1439         PassFunding _newFunding = new PassFunding(
1440             msg.sender,
1441             _DaoManager,        
1442             _minFundingAmount,
1443             _startTime,
1444             _closingTime
1445         );
1446         NewFunding(msg.sender, _DaoManager,  
1447             _minFundingAmount, _startTime, _closingTime, address(_newFunding));
1448         return _newFunding;
1449     }
1450 }