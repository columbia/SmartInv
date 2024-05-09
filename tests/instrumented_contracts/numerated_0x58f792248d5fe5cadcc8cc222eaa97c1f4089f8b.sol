1 pragma solidity ^0.4.6;
2 
3 /*
4  *
5  * This file is part of Pass DAO.
6  *
7  * The Manager smart contract is used for the management of accounts and tokens.
8  *
9  * Recipient is 0 for the Dao account manager and the address of
10  * contractor's recipient for the contractors's mahagers.
11  *
12 */
13 
14 /// @title Manager smart contract of the Pass Decentralized Autonomous Organisation
15 contract PassManagerInterface {
16 
17     struct proposal {
18         // Amount (in wei) of the proposal
19         uint amount;
20         // A description of the proposal
21         string description;
22         // The hash of the proposal's document
23         bytes32 hashOfTheDocument;
24         // A unix timestamp, denoting the date when the proposal was created
25         uint dateOfProposal;
26         // The index of the last approved client proposal
27         uint lastClientProposalID;
28         // The sum amount (in wei) ordered for this proposal 
29         uint orderAmount;
30         // A unix timestamp, denoting the date of the last order for the approved proposal
31         uint dateOfOrder;
32     }
33         
34     // Proposals to work for the client
35     proposal[] public proposals;
36 
37     struct fundingData {
38         // True if public funding without a main partner
39         bool publicCreation; 
40         // The address which sets partners and manages the funding in case of private funding
41         address mainPartner;
42         // The maximum amount (in wei) of the funding
43         uint maxAmountToFund;
44         // The actual funded amount (in wei)
45         uint fundedAmount;
46         // A unix timestamp, denoting the start time of the funding
47         uint startTime; 
48         // A unix timestamp, denoting the closing time of the funding
49         uint closingTime;  
50         // The price multiplier for a share or a token without considering the inflation rate
51         uint initialPriceMultiplier;
52         // Rate per year in percentage applied to the share or token price 
53         uint inflationRate; 
54         // Index of the client proposal
55         uint proposalID;
56     } 
57     
58     // Rules for the actual funding and the contractor token price
59     fundingData[2] public FundingRules;
60 
61     // The address of the last Manager before cloning
62     address public clonedFrom;
63 
64     // Address of the creator of the smart contract
65     address public creator;
66     // Address of the Dao (for the Dao manager)
67     address client;
68     // Address of the recipient;
69     address public recipient;
70     // Address of the Dao manager (for contractor managers)
71     PassManager public daoManager;
72     
73     // The token name for display purpose
74     string public name;
75     // The token symbol for display purpose
76     string public symbol;
77     // The quantity of decimals for display purpose
78     uint8 public decimals;
79 
80     // End date of the setup procedure
81     uint public smartContractStartDate;
82     // Unix date when shares and tokens can be transferred after cloning (for the Dao manager)
83     uint closingTimeForCloning;
84     
85     // Total amount of tokens
86     uint256 totalTokenSupply;
87 
88     // Array with all balances
89     mapping (address => uint256) balances;
90     // Array with all allowances
91     mapping (address => mapping (address => uint256)) allowed;
92 
93     // Map of the result (in wei) of fundings
94     mapping (uint => uint) fundedAmount;
95 
96     // Array of token or share holders
97     address[] holders;
98     // Map with the indexes of the holders
99     mapping (address => uint) public holderID;
100 
101     // If true, the shares or tokens can be transfered
102     bool public transferable;
103     // Map of blocked Dao share accounts. Points to the date when the share holder can transfer shares
104     mapping (address => uint) public blockedDeadLine; 
105 
106     // @return The client of this manager
107     function Client() constant returns (address);
108     
109     // @return The unix date when shares and tokens can be transferred after cloning
110     function ClosingTimeForCloning() constant returns (uint);
111     
112     /// @return The total supply of shares or tokens 
113     function totalSupply() constant external returns (uint256);
114 
115     /// @param _owner The address from which the balance will be retrieved
116     /// @return The balance
117      function balanceOf(address _owner) constant external returns (uint256 balance);
118 
119     /// @param _owner The address of the account owning tokens
120     /// @param _spender The address of the account able to transfer the tokens
121     /// @return Quantity of remaining tokens of _owner that _spender is allowed to spend
122     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
123 
124     /// @param _proposalID The index of the Dao proposal
125     /// @return The result (in wei) of the funding
126     function FundedAmount(uint _proposalID) constant external returns (uint);
127 
128     /// @param _saleDate in case of presale, the date of the presale
129     /// @return the share or token price divisor condidering the sale date and the inflation rate
130     function priceDivisor(uint _saleDate) constant internal returns (uint);
131     
132     /// @return the actual price divisor of a share or token
133     function actualPriceDivisor() constant external returns (uint);
134 
135     /// @return The maximal amount a main partner can fund at this moment
136     /// @param _mainPartner The address of the main parner
137     function fundingMaxAmount(address _mainPartner) constant external returns (uint);
138     
139     /// @return The number of share or token holders 
140     function numberOfHolders() constant returns (uint);
141 
142     /// @param _index The index of the holder
143     /// @return the address of the an holder
144     function HolderAddress(uint _index) constant returns (address);
145 
146     /// @return The number of Dao rules proposals     
147     function numberOfProposals() constant returns (uint);
148     
149     /// @dev The constructor function
150     /// @param _client The address of the Dao
151     /// @param _daoManager The address of the Dao manager (for contractor managers)
152     /// @param _recipient The address of the recipient. 0 for the Dao
153     /// @param _clonedFrom The address of the last Manager before cloning
154     /// @param _tokenName The token name for display purpose
155     /// @param _tokenSymbol The token symbol for display purpose
156     /// @param _tokenDecimals The quantity of decimals for display purpose
157     /// @param _transferable True if allows the transfer of tokens
158     //function PassManager(
159     //    address _client,
160     //    address _daoManager,
161     //    address _recipient,
162     //    address _clonedFrom,
163     //    string _tokenName,
164     //    string _tokenSymbol,
165     //    uint8 _tokenDecimals,
166     //    bool _transferable);
167     
168     /// @notice Function to clone a proposal from another manager contract
169     /// @param _amount Amount (in wei) of the proposal
170     /// @param _description A description of the proposal
171     /// @param _hashOfTheDocument The hash of the proposal's document
172     /// @param _dateOfProposal A unix timestamp, denoting the date when the proposal was created
173     /// @param _lastClientProposalID The index of the last approved client proposal
174     /// @param _orderAmount The sum amount (in wei) ordered for this proposal 
175     /// @param _dateOfOrder A unix timestamp, denoting the date of the last order for the approved proposal
176     /// @return Whether the function was successful or not 
177     function cloneProposal(
178         uint _amount,
179         string _description,
180         bytes32 _hashOfTheDocument,
181         uint _dateOfProposal,
182         uint _lastClientProposalID,
183         uint _orderAmount,
184         uint _dateOfOrder) returns (bool success);
185     
186     /// @dev Function to create initial tokens    
187     /// @param _recipient The beneficiary of the created tokens
188     /// @param _quantity The quantity of tokens to create    
189     /// @return Whether the function was successful or not     
190     function initialTokenSupply(
191         address _recipient, 
192         uint _quantity) returns (bool success);
193         
194     /// @notice Function to clone tokens from a manager
195     /// @param _from The index of the first holder
196     /// @param _to The index of the last holder
197     /// @return Whether the function was successful or not 
198     function cloneTokens(
199         uint _from,
200         uint _to) returns (bool success);
201     
202     /// @notice Function to close the setup procedure of this contract
203     function closeSetup();
204 
205     /// @notice Function to update the recipent address
206     /// @param _newRecipient The adress of the recipient
207     function updateRecipient(address _newRecipient);
208 
209     /// @notice Function to receive payments or deposits
210     function () payable;
211     
212     /// @notice Function to allow contractors to withdraw ethers
213     /// @param _amount The amount (in wei) to withdraw
214     function withdraw(uint _amount);
215 
216     /// @notice Function to update the client address
217     function updateClient(address _newClient);
218     
219     /// @notice Function to make a proposal to work for the client
220     /// @param _amount The amount (in wei) of the proposal
221     /// @param _description String describing the proposal
222     /// @param _hashOfTheDocument The hash of the proposal document
223     /// @return The index of the contractor proposal
224     function newProposal(
225         uint _amount,
226         string _description, 
227         bytes32 _hashOfTheDocument
228     ) returns (uint);
229         
230     /// @notice Function used by the client to order according to the contractor proposal
231     /// @param _clientProposalID The index of the last approved client proposal
232     /// @param _proposalID The index of the contractor proposal
233     /// @param _amount The amount (in wei) of the order
234     /// @return Whether the order was made or not
235     function order(
236         uint _clientProposalID,
237         uint _proposalID,
238         uint _amount
239     ) external returns (bool) ;
240     
241     /// @notice Function used by the client to send ethers from the Dao manager
242     /// @param _recipient The address to send to
243     /// @param _amount The amount (in wei) to send
244     /// @return Whether the transfer was successful or not
245     function sendTo(
246         address _recipient, 
247         uint _amount
248     ) external returns (bool);
249     
250     /// @dev Internal function to add a new token or share holder
251     /// @param _holder The address of the token or share holder
252     function addHolder(address _holder) internal;
253     
254     /// @dev Internal function to create initial tokens    
255     /// @param _holder The beneficiary of the created tokens
256     /// @param _quantity The quantity of tokens to create
257     /// @return Whether the function was successful or not 
258     function createInitialTokens(address _holder, uint _quantity) internal returns (bool success) ;
259     
260     /// @notice Function that allow the contractor to propose a token price
261     /// @param _initialPriceMultiplier The initial price multiplier of contractor tokens
262     /// @param _inflationRate If 0, the contractor token price doesn't change during the funding
263     /// @param _closingTime The initial price and inflation rate can be changed after this date
264     function setTokenPriceProposal(        
265         uint _initialPriceMultiplier, 
266         uint _inflationRate,
267         uint _closingTime
268     );
269 
270     /// @notice Function to set a funding. Can be private or public
271     /// @param _mainPartner The address of the smart contract to manage a private funding
272     /// @param _publicCreation True if public funding
273     /// @param _initialPriceMultiplier Price multiplier without considering any inflation rate
274     /// @param _maxAmountToFund The maximum amount (in wei) of the funding
275     /// @param _minutesFundingPeriod Period in minutes of the funding
276     /// @param _inflationRate If 0, the token price doesn't change during the funding
277     /// @param _proposalID Index of the client proposal (not mandatory)
278     function setFundingRules(
279         address _mainPartner,
280         bool _publicCreation, 
281         uint _initialPriceMultiplier, 
282         uint _maxAmountToFund, 
283         uint _minutesFundingPeriod, 
284         uint _inflationRate,
285         uint _proposalID
286     ) external;
287     
288     /// @dev Internal function for the creation of shares or tokens
289     /// @param _recipient The recipient address of shares or tokens
290     /// @param _amount The funded amount (in wei)
291     /// @param _saleDate In case of presale, the date of the presale
292     /// @return Whether the creation was successful or not
293     function createToken(
294         address _recipient, 
295         uint _amount,
296         uint _saleDate
297     ) internal returns (bool success);
298 
299     /// @notice Function used by the main partner to set the start time of the funding
300     /// @param _startTime The unix start date of the funding 
301     function setFundingStartTime(uint _startTime) external;
302 
303     /// @notice Function used by the main partner to reward shares or tokens
304     /// @param _recipient The address of the recipient of shares or tokens
305     /// @param _amount The amount (in Wei) to calculate the quantity of shares or tokens to create
306     /// @param _date The unix date to consider for the share or token price calculation
307     /// @return Whether the transfer was successful or not
308     function rewardToken(
309         address _recipient, 
310         uint _amount,
311         uint _date
312         ) external;
313 
314     /// @dev Internal function to close the actual funding
315     function closeFunding() internal;
316     
317     /// @notice Function used by the main partner to set the funding fueled
318     function setFundingFueled() external;
319 
320     /// @notice Function to able the transfer of Dao shares or contractor tokens
321     function ableTransfer();
322 
323     /// @notice Function to disable the transfer of Dao shares
324     /// @param _closingTime Date when shares or tokens can be transferred
325     function disableTransfer(uint _closingTime);
326 
327     /// @notice Function used by the client to block the transfer of shares from and to a share holder
328     /// @param _shareHolder The address of the share holder
329     /// @param _deadLine When the account will be unblocked
330     function blockTransfer(address _shareHolder, uint _deadLine) external;
331 
332     /// @notice Function to buy Dao shares according to the funding rules 
333     /// with `msg.sender` as the beneficiary
334     function buyShares() payable;
335     
336     /// @notice Function to buy Dao shares according to the funding rules 
337     /// @param _recipient The beneficiary of the created shares
338     function buySharesFor(address _recipient) payable;
339     
340     /// @dev Internal function to send `_value` token to `_to` from `_From`
341     /// @param _from The address of the sender
342     /// @param _to The address of the recipient
343     /// @param _value The quantity of shares or tokens to be transferred
344     /// @return Whether the function was successful or not 
345     function transferFromTo(
346         address _from,
347         address _to, 
348         uint256 _value
349         ) internal returns (bool success);
350 
351     /// @notice send `_value` token to `_to` from `msg.sender`
352     /// @param _to The address of the recipient
353     /// @param _value The quantity of shares or tokens to be transferred
354     /// @return Whether the function was successful or not 
355     function transfer(address _to, uint256 _value) returns (bool success);
356 
357     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
358     /// @param _from The address of the sender
359     /// @param _to The address of the recipient
360     /// @param _value The quantity of shares or tokens to be transferred
361     function transferFrom(
362         address _from, 
363         address _to, 
364         uint256 _value
365         ) returns (bool success);
366 
367     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf
368     /// @param _spender The address of the account able to transfer the tokens
369     /// @param _value The amount of tokens to be approved for transfer
370     /// @return Whether the approval was successful or not
371     function approve(address _spender, uint256 _value) returns (bool success);
372 
373     event FeesReceived(address indexed From, uint Amount);
374     event AmountReceived(address indexed From, uint Amount);
375     event paymentReceived(address indexed daoManager, uint Amount);
376     event ProposalCloned(uint indexed LastClientProposalID, uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
377     event ClientUpdated(address LastClient, address NewClient);
378     event RecipientUpdated(address LastRecipient, address NewRecipient);
379     event ProposalAdded(uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
380     event Order(uint indexed clientProposalID, uint indexed ProposalID, uint Amount);
381     event Withdawal(address indexed Recipient, uint Amount);
382     event TokenPriceProposalSet(uint InitialPriceMultiplier, uint InflationRate, uint ClosingTime);
383     event holderAdded(uint Index, address Holder);
384     event TokensCreated(address indexed Sender, address indexed TokenHolder, uint Quantity);
385     event FundingRulesSet(address indexed MainPartner, uint indexed FundingProposalId, uint indexed StartTime, uint ClosingTime);
386     event FundingFueled(uint indexed FundingProposalID, uint FundedAmount);
387     event TransferAble();
388     event TransferDisable(uint closingTime);
389     event Transfer(address indexed _from, address indexed _to, uint256 _value);
390     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
391 
392 
393 }    
394 
395 contract PassManager is PassManagerInterface {
396 
397 // Constant functions
398 
399     function Client() constant returns (address) {
400         if (recipient == 0) return client;
401         else return daoManager.Client();
402     }
403     
404     function ClosingTimeForCloning() constant returns (uint) {
405         if (recipient == 0) return closingTimeForCloning;
406         else return daoManager.ClosingTimeForCloning();
407     }
408     
409     function totalSupply() constant external returns (uint256) {
410         return totalTokenSupply;
411     }
412 
413      function balanceOf(address _owner) constant external returns (uint256 balance) {
414         return balances[_owner];
415      }
416 
417     function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {
418         return allowed[_owner][_spender];
419     }
420 
421     function FundedAmount(uint _proposalID) constant external returns (uint) {
422         return fundedAmount[_proposalID];
423     }
424 
425     function priceDivisor(uint _saleDate) constant internal returns (uint) {
426         uint _date = _saleDate;
427         
428         if (_saleDate > FundingRules[0].closingTime) _date = FundingRules[0].closingTime;
429         if (_saleDate < FundingRules[0].startTime) _date = FundingRules[0].startTime;
430 
431         return 100 + 100*FundingRules[0].inflationRate*(_date - FundingRules[0].startTime)/(100*365 days);
432     }
433     
434     function actualPriceDivisor() constant external returns (uint) {
435         return priceDivisor(now);
436     }
437 
438     function fundingMaxAmount(address _mainPartner) constant external returns (uint) {
439         
440         if (now > FundingRules[0].closingTime
441             || now < FundingRules[0].startTime
442             || _mainPartner != FundingRules[0].mainPartner) {
443             return 0;   
444         } else {
445             return FundingRules[0].maxAmountToFund;
446         }
447         
448     }
449 
450     function numberOfHolders() constant returns (uint) {
451         return holders.length - 1;
452     }
453     
454     function HolderAddress(uint _index) constant returns (address) {
455         return holders[_index];
456     }
457 
458     function numberOfProposals() constant returns (uint) {
459         return proposals.length - 1;
460     }
461 
462 // Modifiers
463 
464     // Modifier that allows only the client to manage this account manager
465     modifier onlyClient {if (msg.sender != Client()) throw; _;}
466     
467     // Modifier that allows only the main partner to manage the actual funding
468     modifier onlyMainPartner {if (msg.sender !=  FundingRules[0].mainPartner) throw; _;}
469     
470     // Modifier that allows only the contractor propose set the token price or withdraw
471     modifier onlyContractor {if (recipient == 0 || (msg.sender != recipient && msg.sender != creator)) throw; _;}
472     
473     // Modifier for Dao functions
474     modifier onlyDao {if (recipient != 0) throw; _;}
475     
476 // Constructor function
477 
478     function PassManager(
479         address _client,
480         address _daoManager,
481         address _recipient,
482         address _clonedFrom,
483         string _tokenName,
484         string _tokenSymbol,
485         uint8 _tokenDecimals,
486         bool _transferable
487     ) {
488 
489         if ((_recipient == 0 && _client == 0)
490             || _client == _recipient) throw;
491 
492         creator = msg.sender; 
493         client = _client;
494         recipient = _recipient;
495         
496         if (_recipient !=0) daoManager = PassManager(_daoManager);
497 
498         clonedFrom = _clonedFrom;            
499         
500         name = _tokenName;
501         symbol = _tokenSymbol;
502         decimals = _tokenDecimals;
503           
504         if (_transferable) {
505             transferable = true;
506             TransferAble();
507         } else {
508             transferable = false;
509             TransferDisable(0);
510         }
511 
512         holders.length = 1;
513         proposals.length = 1;
514         
515     }
516 
517 // Setting functions
518 
519     function cloneProposal(
520         uint _amount,
521         string _description,
522         bytes32 _hashOfTheDocument,
523         uint _dateOfProposal,
524         uint _lastClientProposalID,
525         uint _orderAmount,
526         uint _dateOfOrder
527     ) returns (bool success) {
528             
529         if (smartContractStartDate != 0 || recipient == 0
530         || msg.sender != creator) throw;
531         
532         uint _proposalID = proposals.length++;
533         proposal c = proposals[_proposalID];
534 
535         c.amount = _amount;
536         c.description = _description;
537         c.hashOfTheDocument = _hashOfTheDocument; 
538         c.dateOfProposal = _dateOfProposal;
539         c.lastClientProposalID = _lastClientProposalID;
540         c.orderAmount = _orderAmount;
541         c.dateOfOrder = _dateOfOrder;
542         
543         ProposalCloned(_lastClientProposalID, _proposalID, c.amount, c.description, c.hashOfTheDocument);
544         
545         return true;
546             
547     }
548 
549     function initialTokenSupply(
550         address _recipient, 
551         uint _quantity) returns (bool success) {
552 
553         if (smartContractStartDate != 0 || msg.sender != creator) throw;
554         
555         if (_recipient != 0 && _quantity != 0) {
556             return (createInitialTokens(_recipient, _quantity));
557         }
558             
559     }
560 
561     function cloneTokens(
562         uint _from,
563         uint _to) returns (bool success) {
564         
565         if (smartContractStartDate != 0) throw;
566         
567         PassManager _clonedFrom = PassManager(clonedFrom);
568         
569         if (_from < 1 || _to > _clonedFrom.numberOfHolders()) throw;
570 
571         address _holder;
572 
573         for (uint i = _from; i <= _to; i++) {
574             _holder = _clonedFrom.HolderAddress(i);
575             if (balances[_holder] == 0) {
576                 createInitialTokens(_holder, _clonedFrom.balanceOf(_holder));
577             }
578         }
579 
580         return true;
581         
582     }
583 
584     function closeSetup() {
585         
586         if (smartContractStartDate != 0 || msg.sender != creator) throw;
587 
588         smartContractStartDate = now;
589 
590     }
591 
592 // Function to receive payments or deposits
593 
594     function () payable {
595         AmountReceived(msg.sender, msg.value);
596     }
597     
598 // Contractors Account Management
599 
600     function updateRecipient(address _newRecipient) onlyContractor {
601 
602         if (_newRecipient == 0 
603             || _newRecipient == client) throw;
604 
605         RecipientUpdated(recipient, _newRecipient);
606         recipient = _newRecipient;
607 
608     } 
609 
610     function withdraw(uint _amount) onlyContractor {
611         if (!recipient.send(_amount)) throw;
612         Withdawal(recipient, _amount);
613     }
614     
615 // DAO Proposals Management
616 
617     function updateClient(address _newClient) onlyClient {
618         
619         if (_newClient == 0 
620             || _newClient == recipient) throw;
621 
622         ClientUpdated(client, _newClient);
623         client = _newClient;        
624 
625     }
626 
627     function newProposal(
628         uint _amount,
629         string _description, 
630         bytes32 _hashOfTheDocument
631     ) onlyContractor returns (uint) {
632 
633         uint _proposalID = proposals.length++;
634         proposal c = proposals[_proposalID];
635 
636         c.amount = _amount;
637         c.description = _description;
638         c.hashOfTheDocument = _hashOfTheDocument; 
639         c.dateOfProposal = now;
640         
641         ProposalAdded(_proposalID, c.amount, c.description, c.hashOfTheDocument);
642         
643         return _proposalID;
644         
645     }
646     
647     function order(
648         uint _clientProposalID,
649         uint _proposalID,
650         uint _orderAmount
651     ) external onlyClient returns (bool) {
652     
653         proposal c = proposals[_proposalID];
654         
655         uint _sum = c.orderAmount + _orderAmount;
656         if (_sum > c.amount
657             || _sum < c.orderAmount
658             || _sum < _orderAmount) return; 
659 
660         c.lastClientProposalID =  _clientProposalID;
661         c.orderAmount = _sum;
662         c.dateOfOrder = now;
663         
664         Order(_clientProposalID, _proposalID, _orderAmount);
665         
666         return true;
667 
668     }
669 
670     function sendTo(
671         address _recipient,
672         uint _amount
673     ) external onlyClient onlyDao returns (bool) {
674 
675         if (_recipient.send(_amount)) return true;
676         else return false;
677 
678     }
679     
680 // Token Management
681     
682     function addHolder(address _holder) internal {
683         
684         if (holderID[_holder] == 0) {
685             
686             uint _holderID = holders.length++;
687             holders[_holderID] = _holder;
688             holderID[_holder] = _holderID;
689             holderAdded(_holderID, _holder);
690 
691         }
692         
693     }
694     
695     function createInitialTokens(
696         address _holder, 
697         uint _quantity
698     ) internal returns (bool success) {
699 
700         if (_quantity > 0 && balances[_holder] == 0) {
701             addHolder(_holder);
702             balances[_holder] = _quantity; 
703             totalTokenSupply += _quantity;
704             TokensCreated(msg.sender, _holder, _quantity);
705             return true;
706         }
707         
708     }
709     
710     function setTokenPriceProposal(        
711         uint _initialPriceMultiplier, 
712         uint _inflationRate,
713         uint _closingTime
714     ) onlyContractor {
715         
716         if (_closingTime < now 
717             || now < FundingRules[1].closingTime) throw;
718         
719         FundingRules[1].initialPriceMultiplier = _initialPriceMultiplier;
720         FundingRules[1].inflationRate = _inflationRate;
721         FundingRules[1].startTime = now;
722         FundingRules[1].closingTime = _closingTime;
723         
724         TokenPriceProposalSet(_initialPriceMultiplier, _inflationRate, _closingTime);
725     }
726     
727     function setFundingRules(
728         address _mainPartner,
729         bool _publicCreation, 
730         uint _initialPriceMultiplier,
731         uint _maxAmountToFund, 
732         uint _minutesFundingPeriod, 
733         uint _inflationRate,
734         uint _proposalID
735     ) external onlyClient {
736 
737         if (now < FundingRules[0].closingTime
738             || _mainPartner == address(this)
739             || _mainPartner == client
740             || (!_publicCreation && _mainPartner == 0)
741             || (_publicCreation && _mainPartner != 0)
742             || (recipient == 0 && _initialPriceMultiplier == 0)
743             || (recipient != 0 
744                 && (FundingRules[1].initialPriceMultiplier == 0
745                     || _inflationRate < FundingRules[1].inflationRate
746                     || now < FundingRules[1].startTime
747                     || FundingRules[1].closingTime < now + (_minutesFundingPeriod * 1 minutes)))
748             || _maxAmountToFund == 0
749             || _minutesFundingPeriod == 0
750             ) throw;
751 
752         FundingRules[0].startTime = now;
753         FundingRules[0].closingTime = now + _minutesFundingPeriod * 1 minutes;
754             
755         FundingRules[0].mainPartner = _mainPartner;
756         FundingRules[0].publicCreation = _publicCreation;
757         
758         if (recipient == 0) FundingRules[0].initialPriceMultiplier = _initialPriceMultiplier;
759         else FundingRules[0].initialPriceMultiplier = FundingRules[1].initialPriceMultiplier;
760         
761         if (recipient == 0) FundingRules[0].inflationRate = _inflationRate;
762         else FundingRules[0].inflationRate = FundingRules[1].inflationRate;
763         
764         FundingRules[0].fundedAmount = 0;
765         FundingRules[0].maxAmountToFund = _maxAmountToFund;
766 
767         FundingRules[0].proposalID = _proposalID;
768 
769         FundingRulesSet(_mainPartner, _proposalID, FundingRules[0].startTime, FundingRules[0].closingTime);
770             
771     } 
772     
773     function createToken(
774         address _recipient, 
775         uint _amount,
776         uint _saleDate
777     ) internal returns (bool success) {
778 
779         if (now > FundingRules[0].closingTime
780             || now < FundingRules[0].startTime
781             ||_saleDate > FundingRules[0].closingTime
782             || _saleDate < FundingRules[0].startTime
783             || FundingRules[0].fundedAmount + _amount > FundingRules[0].maxAmountToFund) return;
784 
785         uint _a = _amount*FundingRules[0].initialPriceMultiplier;
786         uint _multiplier = 100*_a;
787         uint _quantity = _multiplier/priceDivisor(_saleDate);
788         if (_a/_amount != FundingRules[0].initialPriceMultiplier
789             || _multiplier/100 != _a
790             || totalTokenSupply + _quantity <= totalTokenSupply 
791             || totalTokenSupply + _quantity <= _quantity) return;
792 
793         addHolder(_recipient);
794         balances[_recipient] += _quantity;
795         totalTokenSupply += _quantity;
796         FundingRules[0].fundedAmount += _amount;
797 
798         TokensCreated(msg.sender, _recipient, _quantity);
799         
800         if (FundingRules[0].fundedAmount == FundingRules[0].maxAmountToFund) closeFunding();
801         
802         return true;
803 
804     }
805 
806     function setFundingStartTime(uint _startTime) external onlyMainPartner {
807         if (now > FundingRules[0].closingTime) throw;
808         FundingRules[0].startTime = _startTime;
809     }
810     
811     function rewardToken(
812         address _recipient, 
813         uint _amount,
814         uint _date
815         ) external onlyMainPartner {
816 
817         uint _saleDate;
818         if (_date == 0) _saleDate = now; else _saleDate = _date;
819 
820         if (!createToken(_recipient, _amount, _saleDate)) throw;
821 
822     }
823 
824     function closeFunding() internal {
825         if (recipient == 0) fundedAmount[FundingRules[0].proposalID] = FundingRules[0].fundedAmount;
826         FundingRules[0].closingTime = now;
827     }
828     
829     function setFundingFueled() external onlyMainPartner {
830         if (now > FundingRules[0].closingTime) throw;
831         closeFunding();
832         if (recipient == 0) FundingFueled(FundingRules[0].proposalID, FundingRules[0].fundedAmount);
833     }
834     
835     function ableTransfer() onlyClient {
836         if (!transferable) {
837             transferable = true;
838             closingTimeForCloning = 0;
839             TransferAble();
840         }
841     }
842 
843     function disableTransfer(uint _closingTime) onlyClient {
844         if (transferable && _closingTime == 0) transferable = false;
845         else closingTimeForCloning = _closingTime;
846             
847         TransferDisable(_closingTime);
848     }
849     
850     function blockTransfer(address _shareHolder, uint _deadLine) external onlyClient onlyDao {
851         if (_deadLine > blockedDeadLine[_shareHolder]) {
852             blockedDeadLine[_shareHolder] = _deadLine;
853         }
854     }
855     
856     function buyShares() payable {
857         buySharesFor(msg.sender);
858     } 
859     
860     function buySharesFor(address _recipient) payable onlyDao {
861         
862         if (!FundingRules[0].publicCreation 
863             || !createToken(_recipient, msg.value, now)) throw;
864 
865     }
866     
867     function transferFromTo(
868         address _from,
869         address _to, 
870         uint256 _value
871         ) internal returns (bool success) {  
872 
873         if ((transferable && now > ClosingTimeForCloning())
874             && now > blockedDeadLine[_from]
875             && now > blockedDeadLine[_to]
876             && _to != address(this)
877             && balances[_from] >= _value
878             && balances[_to] + _value > balances[_to]
879             && balances[_to] + _value >= _value
880         ) {
881             balances[_from] -= _value;
882             balances[_to] += _value;
883             Transfer(_from, _to, _value);
884             addHolder(_to);
885             return true;
886         } else {
887             return false;
888         }
889         
890     }
891 
892     function transfer(address _to, uint256 _value) returns (bool success) {  
893         if (!transferFromTo(msg.sender, _to, _value)) throw;
894         return true;
895     }
896 
897     function transferFrom(
898         address _from, 
899         address _to, 
900         uint256 _value
901         ) returns (bool success) { 
902         
903         if (allowed[_from][msg.sender] < _value
904             || !transferFromTo(_from, _to, _value)) throw;
905             
906         allowed[_from][msg.sender] -= _value;
907         return true;
908     }
909 
910     function approve(address _spender, uint256 _value) returns (bool success) {
911         allowed[msg.sender][_spender] = _value;
912         return true;
913     }
914     
915 }    
916 
917 pragma solidity ^0.4.6;
918 
919 /*
920 This file is part of Pass DAO.
921 
922 Pass DAO is free software: you can redistribute it and/or modify
923 it under the terms of the GNU lesser General Public License as published by
924 the Free Software Foundation, either version 3 of the License, or
925 (at your option) any later version.
926 
927 Pass DAO is distributed in the hope that it will be useful,
928 but WITHOUT ANY WARRANTY; without even the implied warranty of
929 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
930 GNU lesser General Public License for more details.
931 
932 You should have received a copy of the GNU lesser General Public License
933 along with Pass DAO.  If not, see <http://www.gnu.org/licenses/>.
934 */
935 
936 /*
937 Smart contract for a Decentralized Autonomous Organization (DAO)
938 to automate organizational governance and decision-making.
939 */
940 
941 /// @title Pass Decentralized Autonomous Organisation
942 contract PassDaoInterface {
943 
944     struct BoardMeeting {        
945         // Address of the creator of the board meeting for a proposal
946         address creator;  
947         // Index to identify the proposal to pay a contractor or fund the Dao
948         uint proposalID;
949         // Index to identify the proposal to update the Dao rules 
950         uint daoRulesProposalID; 
951         // unix timestamp, denoting the end of the set period of a proposal before the board meeting 
952         uint setDeadline;
953         // Fees (in wei) paid by the creator of the board meeting
954         uint fees;
955         // Total of fees (in wei) rewarded to the voters or to the Dao account manager for the balance
956         uint totalRewardedAmount;
957         // A unix timestamp, denoting the end of the voting period
958         uint votingDeadline;
959         // True if the proposal's votes have yet to be counted, otherwise False
960         bool open; 
961         // A unix timestamp, denoting the date of the execution of the approved proposal
962         uint dateOfExecution;
963         // Number of shares in favor of the proposal
964         uint yea; 
965         // Number of shares opposed to the proposal
966         uint nay; 
967         // mapping to indicate if a shareholder has voted
968         mapping (address => bool) hasVoted;  
969     }
970 
971     struct Contractor {
972         // The address of the contractor manager smart contract
973         address contractorManager;
974         // The date of the first order for the contractor
975         uint creationDate;
976     }
977         
978     struct Proposal {
979         // Index to identify the board meeting of the proposal
980         uint boardMeetingID;
981         // The contractor manager smart contract
982         PassManager contractorManager;
983         // The index of the contractor proposal
984         uint contractorProposalID;
985         // The amount (in wei) of the proposal
986         uint amount; 
987         // True if the proposal foresees a contractor token creation
988         bool tokenCreation;
989         // True if public funding without a main partner
990         bool publicShareCreation; 
991         // The address which sets partners and manages the funding in case of private funding
992         address mainPartner;
993         // The initial price multiplier of Dao shares at the beginning of the funding
994         uint initialSharePriceMultiplier; 
995         // The inflation rate to calculate the actual contractor share price
996         uint inflationRate;
997         // A unix timestamp, denoting the start time of the funding
998         uint minutesFundingPeriod;
999         // True if the proposal is closed
1000         bool open; 
1001     }
1002 
1003     struct Rules {
1004         // Index to identify the board meeting that decides to apply or not the Dao rules
1005         uint boardMeetingID;  
1006         // The quorum needed for each proposal is calculated by totalSupply / minQuorumDivisor
1007         uint minQuorumDivisor;  
1008         // Minimum fees (in wei) to create a proposal
1009         uint minBoardMeetingFees; 
1010         // Period in minutes to consider or set a proposal before the voting procedure
1011         uint minutesSetProposalPeriod; 
1012         // The minimum debate period in minutes that a generic proposal can have
1013         uint minMinutesDebatePeriod;
1014         // The inflation rate to calculate the reward of fees to voters during a board meeting 
1015         uint feesRewardInflationRate;
1016         // True if the dao rules allow the transfer of shares
1017         bool transferable;
1018         // Address of the new Dao smart contract after an upgrade
1019         address newdao;
1020         // The period in minutes for the cloning procedure of shares and tokens
1021         uint minutesForTokensCloning;
1022     } 
1023     
1024     // The creator of the Dao
1025     address public creator;
1026     // The name of the project
1027     string public projectName;
1028     // The address of the last Dao before upgrade (not mandatory)
1029     address public lastDao;
1030     // End date of the setup procedure
1031     uint public smartContractStartDate;
1032     // The Dao manager smart contract
1033     PassManager public daoManager;
1034     // The minimum periods in minutes 
1035     uint public minMinutesPeriods;
1036     // The maximum period in minutes for proposals (set+debate)
1037     uint public maxMinutesProposalPeriod;
1038     // The maximum funding period in minutes for funding proposals
1039     uint public maxMinutesFundingPeriod;
1040     // The maximum inflation rate for share price or rewards to voters
1041     uint public maxInflationRate;
1042     
1043     // Map to allow the share holders to withdraw board meeting fees
1044     mapping (address => uint) pendingFees;
1045 
1046     // Board meetings to vote for or against a proposal
1047     BoardMeeting[] public BoardMeetings; 
1048     // Contractors of the Dao
1049     Contractor[] public Contractors;
1050     // Map with the indexes of the contractors
1051     mapping (address => uint) contractorID;
1052     // Proposals to pay a contractor or fund the Dao
1053     Proposal[] public Proposals;
1054     // Proposals to update the Dao rules
1055     Rules[] public DaoRulesProposals;
1056     // The current Dao rules
1057     Rules public DaoRules; 
1058     
1059     // Date when shares and tokens can be transferred after cloning
1060     uint public closingTimeForCloning;
1061     
1062     /// @dev The constructor function
1063     /// @param _projectName The name of the Dao
1064     /// @param _lastDao The address of the last Dao before upgrade (not mandatory)
1065     //function PassDao(
1066     //    string _projectName,
1067     //    address _lastDao);
1068     
1069     /// @dev Internal function to add a new contractor
1070     /// @param _contractorManager The address of the contractor manager
1071     /// @param _creationDate The date of the first order
1072     function addContractor(address _contractorManager, uint _creationDate) internal;
1073 
1074     /// @dev Function to clone a contractor from the last Dao in case of upgrade 
1075     /// @param _contractorManager The address of the contractor manager
1076     /// @param _creationDate The date of the first order
1077     function cloneContractor(address _contractorManager, uint _creationDate);
1078     
1079     /// @dev Function to initialize the Dao
1080     /// @param _daoManager Address of the Dao manager smart contract
1081     /// @param _maxInflationRate The maximum inflation rate for contractor and funding proposals
1082     /// @param _minMinutesPeriods The minimum periods in minutes
1083     /// @param _maxMinutesFundingPeriod The maximum funding period in minutes for funding proposals
1084     /// @param _maxMinutesProposalPeriod The maximum period in minutes for proposals (set+debate)
1085     /// @param _minQuorumDivisor The initial minimum quorum divisor for the proposals
1086     /// @param _minBoardMeetingFees The amount (in wei) to make a proposal and ask for a board meeting
1087     /// @param _minutesSetProposalPeriod The minimum period in minutes before a board meeting
1088     /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
1089     /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a board meeting
1090     function initDao(
1091         address _daoManager,
1092         uint _maxInflationRate,
1093         uint _minMinutesPeriods,
1094         uint _maxMinutesFundingPeriod,
1095         uint _maxMinutesProposalPeriod,
1096         uint _minQuorumDivisor,
1097         uint _minBoardMeetingFees,
1098         uint _minutesSetProposalPeriod,
1099         uint _minMinutesDebatePeriod,
1100         uint _feesRewardInflationRate
1101         );
1102         
1103     /// @dev Internal function to create a board meeting
1104     /// @param _proposalID The index of the proposal if for a contractor or for a funding
1105     /// @param _daoRulesProposalID The index of the proposal if Dao rules
1106     /// @param _minutesDebatingPeriod The duration in minutes of the meeting
1107     /// @return the index of the board meeting
1108     function newBoardMeeting(
1109         uint _proposalID, 
1110         uint _daoRulesProposalID, 
1111         uint _minutesDebatingPeriod
1112     ) internal returns (uint);
1113     
1114     /// @notice Function to make a proposal to pay a contractor or fund the Dao
1115     /// @param _contractorManager Address of the contractor manager smart contract
1116     /// @param _contractorProposalID Index of the contractor proposal of the contractor manager
1117     /// @param _amount The amount (in wei) of the proposal
1118     /// @param _tokenCreation True if the proposal foresees a contractor token creation
1119     /// @param _publicShareCreation True if public funding without a main partner
1120     /// @param _mainPartner The address which sets partners and manage the funding 
1121     /// in case of private funding (not mandatory)
1122     /// @param _initialSharePriceMultiplier The initial price multiplier of shares
1123     /// @param _inflationRate If 0, the share price doesn't change during the funding (not mandatory)
1124     /// @param _minutesFundingPeriod Period in minutes of the funding
1125     /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
1126     /// @return The index of the proposal
1127     function newProposal(
1128         address _contractorManager,
1129         uint _contractorProposalID,
1130         uint _amount, 
1131         bool _publicShareCreation,
1132         bool _tokenCreation,
1133         address _mainPartner,
1134         uint _initialSharePriceMultiplier, 
1135         uint _inflationRate,
1136         uint _minutesFundingPeriod,
1137         uint _minutesDebatingPeriod
1138     ) payable returns (uint);
1139 
1140     /// @notice Function to make a proposal to change the Dao rules 
1141     /// @param _minQuorumDivisor If 5, the minimum quorum is 20%
1142     /// @param _minBoardMeetingFees The amount (in wei) to make a proposal and ask for a board meeting
1143     /// @param _minutesSetProposalPeriod Minimum period in minutes before a board meeting
1144     /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
1145     /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a board meeting
1146     /// @param _transferable True if the proposal foresees to allow the transfer of Dao shares
1147     /// @param _newdao Address of a new Dao smart contract in case of upgrade (not mandatory)   
1148     /// @param _minutesForTokensCloning The period in minutes for the cloning procedure of shares and tokens
1149     /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
1150     function newDaoRulesProposal(
1151         uint _minQuorumDivisor, 
1152         uint _minBoardMeetingFees,
1153         uint _minutesSetProposalPeriod,
1154         uint _minMinutesDebatePeriod,
1155         uint _feesRewardInflationRate,
1156         bool _transferable,
1157         address _newdao,
1158         uint _minutesForTokensCloning,
1159         uint _minutesDebatingPeriod
1160     ) payable returns (uint);
1161     
1162     /// @notice Function to vote during a board meeting
1163     /// @param _boardMeetingID The index of the board meeting
1164     /// @param _supportsProposal True if the proposal is supported
1165     function vote(
1166         uint _boardMeetingID, 
1167         bool _supportsProposal
1168     );
1169 
1170     /// @notice Function to execute a board meeting decision and close the board meeting
1171     /// @param _boardMeetingID The index of the board meeting
1172     /// @return Whether the proposal was executed or not
1173     function executeDecision(uint _boardMeetingID) returns (bool);
1174     
1175     /// @notice Function to order a contractor proposal
1176     /// @param _proposalID The index of the proposal
1177     /// @return Whether the proposal was ordered and the proposal amount sent or not
1178     function orderContractorProposal(uint _proposalID) returns (bool);   
1179 
1180     /// @notice Function to withdraw the rewarded board meeting fees
1181     /// @return Whether the withdraw was successful or not    
1182     function withdrawBoardMeetingFees() returns (bool);
1183 
1184     /// @param _shareHolder Address of the shareholder
1185     /// @return The amount in wei the shareholder can withdraw    
1186     function PendingFees(address _shareHolder) constant returns (uint);
1187     
1188     /// @return The minimum quorum for proposals to pass 
1189     function minQuorum() constant returns (uint);
1190 
1191     /// @return The number of contractors 
1192    function numberOfContractors() constant returns (uint);
1193 
1194     /// @return The number of board meetings (or proposals) 
1195     function numberOfBoardMeetings() constant returns (uint);
1196 
1197     event ContractorAdded(uint indexed ContractorID, address ContractorManager, uint CreationDate);
1198     event ContractorProposalAdded(uint indexed ProposalID, uint boardMeetingID, address indexed ContractorManager, 
1199         uint indexed ContractorProposalID, uint amount);
1200     event FundingProposalAdded(uint indexed ProposalID, uint boardMeetingID, bool indexed LinkedToContractorProposal, 
1201         uint amount, address MainPartner, uint InitialSharePriceMultiplier, uint InflationRate, uint MinutesFundingPeriod);
1202     event DaoRulesProposalAdded(uint indexed DaoRulesProposalID, uint boardMeetingID, uint MinQuorumDivisor, 
1203         uint MinBoardMeetingFees, uint MinutesSetProposalPeriod, uint MinMinutesDebatePeriod, uint FeesRewardInflationRate, 
1204         bool Transferable, address NewDao, uint MinutesForTokensCloning);
1205     event Voted(uint indexed boardMeetingID, uint ProposalID, uint DaoRulesProposalID, bool position, address indexed voter);
1206     event ProposalClosed(uint indexed ProposalID, uint indexed DaoRulesProposalID, uint boardMeetingID, 
1207         uint FeesGivenBack, bool ProposalExecuted, uint BalanceSentToDaoManager);
1208     event SentToContractor(uint indexed ProposalID, uint indexed ContractorProposalID, address indexed ContractorManagerAddress, uint AmountSent);
1209     event Withdrawal(address indexed Recipient, uint Amount);
1210     event DaoUpgraded(address NewDao);
1211     
1212 }
1213 
1214 contract PassDao is PassDaoInterface {
1215 
1216     function PassDao(
1217         string _projectName,
1218         address _lastDao) {
1219 
1220         lastDao = _lastDao;
1221         creator = msg.sender;
1222         projectName =_projectName;
1223 
1224         Contractors.length = 1;
1225         BoardMeetings.length = 1;
1226         Proposals.length = 1;
1227         DaoRulesProposals.length = 1; 
1228         
1229     }
1230     
1231     function addContractor(address _contractorManager, uint _creationDate) internal {
1232         
1233         if (contractorID[_contractorManager] == 0) {
1234 
1235             uint _contractorID = Contractors.length++;
1236             Contractor c = Contractors[_contractorID];
1237             
1238             contractorID[_contractorManager] = _contractorID;
1239             c.contractorManager = _contractorManager;
1240             c.creationDate = _creationDate;
1241             
1242             ContractorAdded(_contractorID, c.contractorManager, c.creationDate);
1243         }
1244         
1245     }
1246     
1247     function cloneContractor(address _contractorManager, uint _creationDate) {
1248         
1249         if (DaoRules.minQuorumDivisor != 0 || msg.sender != creator) throw;
1250 
1251         addContractor(_contractorManager, _creationDate);
1252         
1253     }
1254     
1255     function initDao(
1256         address _daoManager,
1257         uint _maxInflationRate,
1258         uint _minMinutesPeriods,
1259         uint _maxMinutesFundingPeriod,
1260         uint _maxMinutesProposalPeriod,
1261         uint _minQuorumDivisor,
1262         uint _minBoardMeetingFees,
1263         uint _minutesSetProposalPeriod,
1264         uint _minMinutesDebatePeriod,
1265         uint _feesRewardInflationRate
1266         ) {
1267             
1268         
1269         if (smartContractStartDate != 0) throw;
1270 
1271         maxInflationRate = _maxInflationRate;
1272         minMinutesPeriods = _minMinutesPeriods;
1273         maxMinutesFundingPeriod = _maxMinutesFundingPeriod;
1274         maxMinutesProposalPeriod = _maxMinutesProposalPeriod;
1275         
1276         DaoRules.minQuorumDivisor = _minQuorumDivisor;
1277         DaoRules.minBoardMeetingFees = _minBoardMeetingFees;
1278         DaoRules.minutesSetProposalPeriod = _minutesSetProposalPeriod;
1279         DaoRules.minMinutesDebatePeriod = _minMinutesDebatePeriod;
1280         DaoRules.feesRewardInflationRate = _feesRewardInflationRate;
1281         daoManager = PassManager(_daoManager);
1282         
1283         smartContractStartDate = now;
1284         
1285     }
1286     
1287     function newBoardMeeting(
1288         uint _proposalID, 
1289         uint _daoRulesProposalID, 
1290         uint _minutesDebatingPeriod
1291     ) internal returns (uint) {
1292 
1293         if (msg.value < DaoRules.minBoardMeetingFees
1294             || DaoRules.minutesSetProposalPeriod + _minutesDebatingPeriod > maxMinutesProposalPeriod
1295             || now + ((DaoRules.minutesSetProposalPeriod + _minutesDebatingPeriod) * 1 minutes) < now
1296             || _minutesDebatingPeriod < DaoRules.minMinutesDebatePeriod
1297             || msg.sender == address(this)) throw;
1298 
1299         uint _boardMeetingID = BoardMeetings.length++;
1300         BoardMeeting b = BoardMeetings[_boardMeetingID];
1301 
1302         b.creator = msg.sender;
1303 
1304         b.proposalID = _proposalID;
1305         b.daoRulesProposalID = _daoRulesProposalID;
1306 
1307         b.fees = msg.value;
1308         
1309         b.setDeadline = now + (DaoRules.minutesSetProposalPeriod * 1 minutes);        
1310         b.votingDeadline = b.setDeadline + (_minutesDebatingPeriod * 1 minutes); 
1311 
1312         b.open = true; 
1313 
1314         return _boardMeetingID;
1315 
1316     }
1317 
1318     function newProposal(
1319         address _contractorManager,
1320         uint _contractorProposalID,
1321         uint _amount, 
1322         bool _tokenCreation,
1323         bool _publicShareCreation,
1324         address _mainPartner,
1325         uint _initialSharePriceMultiplier, 
1326         uint _inflationRate,
1327         uint _minutesFundingPeriod,
1328         uint _minutesDebatingPeriod
1329     ) payable returns (uint) {
1330 
1331         if ((_contractorManager != 0 && _contractorProposalID == 0)
1332             || (_contractorManager == 0 
1333                 && (_initialSharePriceMultiplier == 0
1334                     || _contractorProposalID != 0)
1335             || (_tokenCreation && _publicShareCreation)
1336             || (_initialSharePriceMultiplier != 0
1337                 && (_minutesFundingPeriod < minMinutesPeriods
1338                     || _inflationRate > maxInflationRate
1339                     || _minutesFundingPeriod > maxMinutesFundingPeriod)))) throw;
1340 
1341         uint _proposalID = Proposals.length++;
1342         Proposal p = Proposals[_proposalID];
1343 
1344         p.contractorManager = PassManager(_contractorManager);
1345         p.contractorProposalID = _contractorProposalID;
1346         
1347         p.amount = _amount;
1348         p.tokenCreation = _tokenCreation;
1349 
1350         p.publicShareCreation = _publicShareCreation;
1351         p.mainPartner = _mainPartner;
1352         p.initialSharePriceMultiplier = _initialSharePriceMultiplier;
1353         p.inflationRate = _inflationRate;
1354         p.minutesFundingPeriod = _minutesFundingPeriod;
1355 
1356         p.boardMeetingID = newBoardMeeting(_proposalID, 0, _minutesDebatingPeriod);   
1357 
1358         p.open = true;
1359         
1360         if (_contractorProposalID != 0) {
1361             ContractorProposalAdded(_proposalID, p.boardMeetingID, p.contractorManager, p.contractorProposalID, p.amount);
1362             if (_initialSharePriceMultiplier != 0) {
1363                 FundingProposalAdded(_proposalID, p.boardMeetingID, true, p.amount, p.mainPartner, 
1364                     p.initialSharePriceMultiplier, _inflationRate, _minutesFundingPeriod);
1365             }
1366         }
1367         else if (_initialSharePriceMultiplier != 0) {
1368                 FundingProposalAdded(_proposalID, p.boardMeetingID, false, p.amount, p.mainPartner, 
1369                     p.initialSharePriceMultiplier, _inflationRate, _minutesFundingPeriod);
1370         }
1371 
1372         return _proposalID;
1373         
1374     }
1375 
1376     function newDaoRulesProposal(
1377         uint _minQuorumDivisor, 
1378         uint _minBoardMeetingFees,
1379         uint _minutesSetProposalPeriod,
1380         uint _minMinutesDebatePeriod,
1381         uint _feesRewardInflationRate,
1382         bool _transferable,
1383         address _newDao,
1384         uint _minutesForTokensCloning,
1385         uint _minutesDebatingPeriod
1386     ) payable returns (uint) {
1387     
1388         if (_minQuorumDivisor <= 1
1389             || _minQuorumDivisor > 10
1390             || _minutesSetProposalPeriod < minMinutesPeriods
1391             || _minMinutesDebatePeriod < minMinutesPeriods
1392             || _minutesSetProposalPeriod + _minMinutesDebatePeriod > maxMinutesProposalPeriod
1393             || _feesRewardInflationRate > maxInflationRate
1394             ) throw; 
1395         
1396         uint _DaoRulesProposalID = DaoRulesProposals.length++;
1397         Rules r = DaoRulesProposals[_DaoRulesProposalID];
1398 
1399         r.minQuorumDivisor = _minQuorumDivisor;
1400         r.minBoardMeetingFees = _minBoardMeetingFees;
1401         r.minutesSetProposalPeriod = _minutesSetProposalPeriod;
1402         r.minMinutesDebatePeriod = _minMinutesDebatePeriod;
1403         r.feesRewardInflationRate = _feesRewardInflationRate;
1404         r.transferable = _transferable;
1405         r.newdao = _newDao;
1406         r.minutesForTokensCloning = _minutesForTokensCloning;
1407 
1408         r.boardMeetingID = newBoardMeeting(0, _DaoRulesProposalID, _minutesDebatingPeriod);     
1409 
1410         DaoRulesProposalAdded(_DaoRulesProposalID, r.boardMeetingID, _minQuorumDivisor, _minBoardMeetingFees, 
1411             _minutesSetProposalPeriod, _minMinutesDebatePeriod, _feesRewardInflationRate ,_transferable, _newDao ,_minutesForTokensCloning);
1412 
1413         return _DaoRulesProposalID;
1414         
1415     }
1416     
1417     function vote(
1418         uint _boardMeetingID, 
1419         bool _supportsProposal
1420     ) {
1421         
1422         BoardMeeting b = BoardMeetings[_boardMeetingID];
1423 
1424         if (b.hasVoted[msg.sender] 
1425             || now < b.setDeadline
1426             || now > b.votingDeadline) throw;
1427 
1428         uint _balance = uint(daoManager.balanceOf(msg.sender));
1429         if (_balance == 0) throw;
1430         
1431         b.hasVoted[msg.sender] = true;
1432 
1433         if (_supportsProposal) b.yea += _balance;
1434         else b.nay += _balance; 
1435 
1436         if (b.fees > 0 && b.proposalID != 0 && Proposals[b.proposalID].contractorProposalID != 0) {
1437 
1438             uint _a = 100*b.fees;
1439             if ((_a/100 != b.fees) || ((_a*_balance)/_a != _balance)) throw;
1440             uint _multiplier = (_a*_balance)/uint(daoManager.totalSupply());
1441 
1442             uint _divisor = 100 + 100*DaoRules.feesRewardInflationRate*(now - b.setDeadline)/(100*365 days);
1443 
1444             uint _rewardedamount = _multiplier/_divisor;
1445             
1446             if (b.totalRewardedAmount + _rewardedamount > b.fees) _rewardedamount = b.fees - b.totalRewardedAmount;
1447             b.totalRewardedAmount += _rewardedamount;
1448             pendingFees[msg.sender] += _rewardedamount;
1449         }
1450 
1451         Voted(_boardMeetingID, b.proposalID, b.daoRulesProposalID, _supportsProposal, msg.sender);
1452         
1453         daoManager.blockTransfer(msg.sender, b.votingDeadline);
1454 
1455     }
1456 
1457     function executeDecision(uint _boardMeetingID) returns (bool) {
1458 
1459         BoardMeeting b = BoardMeetings[_boardMeetingID];
1460         Proposal p = Proposals[b.proposalID];
1461         
1462         if (now < b.votingDeadline || !b.open) throw;
1463         
1464         b.open = false;
1465         if (p.contractorProposalID == 0) p.open = false;
1466 
1467         uint _fees;
1468         uint _minQuorum = minQuorum();
1469 
1470         if (b.fees > 0
1471             && (b.proposalID == 0 || p.contractorProposalID == 0)
1472             && b.yea + b.nay >= _minQuorum) {
1473                     _fees = b.fees;
1474                     b.fees = 0;
1475                     pendingFees[b.creator] += _fees;
1476         }        
1477 
1478         uint _balance = b.fees - b.totalRewardedAmount;
1479         if (_balance > 0) {
1480             if (!daoManager.send(_balance)) throw;
1481         }
1482         
1483         if (b.yea + b.nay < _minQuorum || b.yea <= b.nay) {
1484             p.open = false;
1485             ProposalClosed(b.proposalID, b.daoRulesProposalID, _boardMeetingID, _fees, false, _balance);
1486             return;
1487         }
1488 
1489         b.dateOfExecution = now;
1490 
1491         if (b.proposalID != 0) {
1492             
1493             if (p.initialSharePriceMultiplier != 0) {
1494 
1495                 daoManager.setFundingRules(p.mainPartner, p.publicShareCreation, p.initialSharePriceMultiplier, 
1496                     p.amount, p.minutesFundingPeriod, p.inflationRate, b.proposalID);
1497 
1498                 if (p.contractorProposalID != 0 && p.tokenCreation) {
1499                     p.contractorManager.setFundingRules(p.mainPartner, p.publicShareCreation, 0, 
1500                         p.amount, p.minutesFundingPeriod, maxInflationRate, b.proposalID);
1501                 }
1502 
1503             }
1504             
1505         } else {
1506 
1507             Rules r = DaoRulesProposals[b.daoRulesProposalID];
1508             DaoRules.boardMeetingID = r.boardMeetingID;
1509 
1510             DaoRules.minQuorumDivisor = r.minQuorumDivisor;
1511             DaoRules.minMinutesDebatePeriod = r.minMinutesDebatePeriod; 
1512             DaoRules.minBoardMeetingFees = r.minBoardMeetingFees;
1513             DaoRules.minutesSetProposalPeriod = r.minutesSetProposalPeriod;
1514             DaoRules.feesRewardInflationRate = r.feesRewardInflationRate;
1515 
1516             DaoRules.transferable = r.transferable;
1517             if (r.transferable) daoManager.ableTransfer();
1518             else daoManager.disableTransfer(0);
1519             
1520             if (r.minutesForTokensCloning != 0) {
1521                 closingTimeForCloning = now + (r.minutesForTokensCloning * 1 minutes);
1522                 daoManager.disableTransfer(closingTimeForCloning);
1523             }
1524 
1525             if ((r.newdao != 0) && (r.newdao != address(this))) {
1526                 DaoRules.newdao = r.newdao;
1527                 daoManager.updateClient(r.newdao);
1528                 DaoUpgraded(r.newdao);
1529             }
1530             
1531         }
1532 
1533         ProposalClosed(b.proposalID, b.daoRulesProposalID, _boardMeetingID ,_fees, true, _balance);
1534             
1535         return true;
1536         
1537     }
1538     
1539     function orderContractorProposal(uint _proposalID) returns (bool) {
1540         
1541         Proposal p = Proposals[_proposalID];
1542         BoardMeeting b = BoardMeetings[p.boardMeetingID];
1543 
1544         if (b.open || !p.open) throw;
1545         
1546         uint _amount = p.amount;
1547 
1548         if (p.initialSharePriceMultiplier != 0) {
1549             _amount = daoManager.FundedAmount(_proposalID);
1550             if (_amount == 0 && now < b.dateOfExecution + (p.minutesFundingPeriod * 1 minutes)) return;
1551         }
1552         
1553         p.open = false;   
1554 
1555         if (_amount == 0 || !p.contractorManager.order(_proposalID, p.contractorProposalID, _amount)) return;
1556         
1557         if (!daoManager.sendTo(p.contractorManager, _amount)) throw;
1558         SentToContractor(_proposalID, p.contractorProposalID, address(p.contractorManager), _amount);
1559         
1560         addContractor(address(p.contractorManager), now);
1561         
1562         return true;
1563 
1564     }
1565     
1566     function withdrawBoardMeetingFees() returns (bool) {
1567 
1568         uint _amount = pendingFees[msg.sender];
1569 
1570         pendingFees[msg.sender] = 0;
1571 
1572         if (msg.sender.send(_amount)) {
1573             Withdrawal(msg.sender, _amount);
1574             return true;
1575         } else {
1576             pendingFees[msg.sender] = _amount;
1577             return false;
1578         }
1579 
1580     }
1581 
1582     function PendingFees(address _shareHolder) constant returns (uint) {
1583         return (pendingFees[_shareHolder]);
1584     }
1585     
1586     function minQuorum() constant returns (uint) {
1587         return (uint(daoManager.totalSupply()) / DaoRules.minQuorumDivisor);
1588     }
1589 
1590     function numberOfContractors() constant returns (uint) {
1591         return Contractors.length - 1;
1592     }
1593     
1594     function numberOfBoardMeetings() constant returns (uint) {
1595         return BoardMeetings.length - 1;
1596     }
1597     
1598 }