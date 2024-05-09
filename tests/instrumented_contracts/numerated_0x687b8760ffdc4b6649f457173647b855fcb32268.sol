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
63     // Unix date when shares and tokens can be transferred after cloning (for the Dao manager)
64     uint closingTimeForCloning;
65     // End date of the setup procedure
66     uint public smartContractStartDate;
67 
68     // Address of the creator of the smart contract
69     address public creator;
70     // Address of the Dao (for the Dao manager)
71     address client;
72     // Address of the recipient;
73     address public recipient;
74     // Address of the Dao manager (for contractor managers)
75     PassManager public daoManager;
76     
77     // The token name for display purpose
78     string public name;
79     // The token symbol for display purpose
80     string public symbol;
81     // The quantity of decimals for display purpose
82     uint8 public decimals;
83 
84     // True if the initial token supply is over
85     bool initialTokenSupplyDone;
86     
87     // Total amount of tokens
88     uint256 totalTokenSupply;
89 
90     // Array with all balances
91     mapping (address => uint256) balances;
92     // Array with all allowances
93     mapping (address => mapping (address => uint256)) allowed;
94 
95     // Map of the result (in wei) of fundings
96     mapping (uint => uint) fundedAmount;
97 
98     // Array of token or share holders
99     address[] holders;
100     // Map with the indexes of the holders
101     mapping (address => uint) public holderID;
102 
103     // If true, the shares or tokens can be transfered
104     bool public transferable;
105     // Map of blocked Dao share accounts. Points to the date when the share holder can transfer shares
106     mapping (address => uint) public blockedDeadLine; 
107 
108     // @return The client of this manager
109     function Client() constant returns (address);
110     
111     // @return The unix date when shares and tokens can be transferred after cloning
112     function ClosingTimeForCloning() constant returns (uint);
113     
114     /// @return The total supply of shares or tokens 
115     function totalSupply() constant external returns (uint256);
116 
117     /// @param _owner The address from which the balance will be retrieved
118     /// @return The balance
119      function balanceOf(address _owner) constant external returns (uint256 balance);
120 
121     /// @param _owner The address of the account owning tokens
122     /// @param _spender The address of the account able to transfer the tokens
123     /// @return Quantity of remaining tokens of _owner that _spender is allowed to spend
124     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
125 
126     /// @param _proposalID The index of the Dao proposal
127     /// @return The result (in wei) of the funding
128     function FundedAmount(uint _proposalID) constant external returns (uint);
129 
130     /// @param _saleDate in case of presale, the date of the presale
131     /// @return the share or token price divisor condidering the sale date and the inflation rate
132     function priceDivisor(uint _saleDate) constant internal returns (uint);
133     
134     /// @return the actual price divisor of a share or token
135     function actualPriceDivisor() constant external returns (uint);
136 
137     /// @return The maximal amount a main partner can fund at this moment
138     /// @param _mainPartner The address of the main parner
139     function fundingMaxAmount(address _mainPartner) constant external returns (uint);
140     
141     /// @return The number of share or token holders 
142     function numberOfHolders() constant returns (uint);
143 
144     /// @param _index The index of the holder
145     /// @return the address of the an holder
146     function HolderAddress(uint _index) constant returns (address);
147 
148     /// @return The number of Dao rules proposals     
149     function numberOfProposals() constant returns (uint);
150     
151     /// @dev The constructor function
152     /// @param _client The address of the Dao
153     /// @param _daoManager The address of the Dao manager (for contractor managers)
154     /// @param _recipient The address of the recipient. 0 for the Dao
155     /// @param _clonedFrom The address of the last Manager before cloning
156     /// @param _tokenName The token name for display purpose
157     /// @param _tokenSymbol The token symbol for display purpose
158     /// @param _tokenDecimals The quantity of decimals for display purpose
159     /// @param _transferable True if allows the transfer of tokens
160     //function PassManager(
161     //    address _client,
162     //    address _daoManager,
163     //    address _recipient,
164     //    address _clonedFrom,
165     //    string _tokenName,
166     //    string _tokenSymbol,
167     //    uint8 _tokenDecimals,
168     //    bool _transferable);
169     
170     /// @dev Function to create initial tokens    
171     /// @param _recipient The beneficiary of the created tokens
172     /// @param _quantity The quantity of tokens to create    
173     /// @param _last True if the initial token suppy is over
174     /// @return Whether the function was successful or not     
175     function initialTokenSupply(
176         address _recipient, 
177         uint _quantity,
178         bool _last) returns (bool success);
179         
180     /// @notice Function to clone a proposal from the last manager
181     /// @param _amount Amount (in wei) of the proposal
182     /// @param _description A description of the proposal
183     /// @param _hashOfTheDocument The hash of the proposal's document
184     /// @param _dateOfProposal A unix timestamp, denoting the date when the proposal was created
185     /// @param _lastClientProposalID The index of the last approved client proposal
186     /// @param _orderAmount The sum amount (in wei) ordered for this proposal 
187     /// @param _dateOfOrder A unix timestamp, denoting the date of the last order for the approved proposal
188     /// @return Whether the function was successful or not 
189     function cloneProposal(
190         uint _amount,
191         string _description,
192         bytes32 _hashOfTheDocument,
193         uint _dateOfProposal,
194         uint _lastClientProposalID,
195         uint _orderAmount,
196         uint _dateOfOrder) returns (bool success);
197     
198     /// @notice Function to clone tokens from a manager
199     /// @param _from The index of the first holder
200     /// @param _to The index of the last holder
201     /// @return Whether the function was successful or not 
202     function cloneTokens(
203         uint _from,
204         uint _to) returns (bool success);
205     
206     /// @notice Function to close the setup procedure of this contract
207     function closeSetup();
208 
209     /// @notice Function to update the recipent address
210     /// @param _newRecipient The adress of the recipient
211     function updateRecipient(address _newRecipient);
212 
213     /// @notice Function to receive payments or deposits
214     function () payable;
215     
216     /// @notice Function to allow contractors to withdraw ethers
217     /// @param _amount The amount (in wei) to withdraw
218     function withdraw(uint _amount);
219 
220     /// @notice Function to update the client address
221     function updateClient(address _newClient);
222     
223     /// @notice Function to make a proposal to work for the client
224     /// @param _amount The amount (in wei) of the proposal
225     /// @param _description String describing the proposal
226     /// @param _hashOfTheDocument The hash of the proposal document
227     /// @return The index of the contractor proposal
228     function newProposal(
229         uint _amount,
230         string _description, 
231         bytes32 _hashOfTheDocument
232     ) returns (uint);
233         
234     /// @notice Function used by the client to order according to the contractor proposal
235     /// @param _clientProposalID The index of the last approved client proposal
236     /// @param _proposalID The index of the contractor proposal
237     /// @param _amount The amount (in wei) of the order
238     /// @return Whether the order was made or not
239     function order(
240         uint _clientProposalID,
241         uint _proposalID,
242         uint _amount
243     ) external returns (bool) ;
244     
245     /// @notice Function used by the client to send ethers from the Dao manager
246     /// @param _recipient The address to send to
247     /// @param _amount The amount (in wei) to send
248     /// @return Whether the transfer was successful or not
249     function sendTo(
250         address _recipient, 
251         uint _amount
252     ) external returns (bool);
253     
254     /// @dev Internal function to add a new token or share holder
255     /// @param _holder The address of the token or share holder
256     function addHolder(address _holder) internal;
257     
258     /// @dev Internal function to create initial tokens    
259     /// @param _holder The beneficiary of the created tokens
260     /// @param _quantity The quantity of tokens to create
261     /// @return Whether the function was successful or not 
262     function createInitialTokens(address _holder, uint _quantity) internal returns (bool success) ;
263     
264     /// @notice Function that allow the contractor to propose a token price
265     /// @param _initialPriceMultiplier The initial price multiplier of contractor tokens
266     /// @param _inflationRate If 0, the contractor token price doesn't change during the funding
267     /// @param _closingTime The initial price and inflation rate can be changed after this date
268     function setTokenPriceProposal(        
269         uint _initialPriceMultiplier, 
270         uint _inflationRate,
271         uint _closingTime
272     );
273 
274     /// @notice Function to set a funding. Can be private or public
275     /// @param _mainPartner The address of the smart contract to manage a private funding
276     /// @param _publicCreation True if public funding
277     /// @param _initialPriceMultiplier Price multiplier without considering any inflation rate
278     /// @param _maxAmountToFund The maximum amount (in wei) of the funding
279     /// @param _minutesFundingPeriod Period in minutes of the funding
280     /// @param _inflationRate If 0, the token price doesn't change during the funding
281     /// @param _proposalID Index of the client proposal (not mandatory)
282     function setFundingRules(
283         address _mainPartner,
284         bool _publicCreation, 
285         uint _initialPriceMultiplier, 
286         uint _maxAmountToFund, 
287         uint _minutesFundingPeriod, 
288         uint _inflationRate,
289         uint _proposalID
290     ) external;
291     
292     /// @dev Internal function for the creation of shares or tokens
293     /// @param _recipient The recipient address of shares or tokens
294     /// @param _amount The funded amount (in wei)
295     /// @param _saleDate In case of presale, the date of the presale
296     /// @return Whether the creation was successful or not
297     function createToken(
298         address _recipient, 
299         uint _amount,
300         uint _saleDate
301     ) internal returns (bool success);
302 
303     /// @notice Function used by the main partner to set the start time of the funding
304     /// @param _startTime The unix start date of the funding 
305     function setFundingStartTime(uint _startTime) external;
306 
307     /// @notice Function used by the main partner to reward shares or tokens
308     /// @param _recipient The address of the recipient of shares or tokens
309     /// @param _amount The amount (in Wei) to calculate the quantity of shares or tokens to create
310     /// @param _date The unix date to consider for the share or token price calculation
311     /// @return Whether the transfer was successful or not
312     function rewardToken(
313         address _recipient, 
314         uint _amount,
315         uint _date
316         ) external;
317 
318     /// @dev Internal function to close the actual funding
319     function closeFunding() internal;
320     
321     /// @notice Function used by the main partner to set the funding fueled
322     function setFundingFueled() external;
323 
324     /// @notice Function to able the transfer of Dao shares or contractor tokens
325     function ableTransfer();
326 
327     /// @notice Function to disable the transfer of Dao shares
328     /// @param _closingTime Date when shares or tokens can be transferred
329     function disableTransfer(uint _closingTime);
330 
331     /// @notice Function used by the client to block the transfer of shares from and to a share holder
332     /// @param _shareHolder The address of the share holder
333     /// @param _deadLine When the account will be unblocked
334     function blockTransfer(address _shareHolder, uint _deadLine) external;
335 
336     /// @notice Function to buy Dao shares according to the funding rules 
337     /// with `msg.sender` as the beneficiary
338     function buyShares() payable;
339     
340     /// @notice Function to buy Dao shares according to the funding rules 
341     /// @param _recipient The beneficiary of the created shares
342     function buySharesFor(address _recipient) payable;
343     
344     /// @dev Internal function to send `_value` token to `_to` from `_From`
345     /// @param _from The address of the sender
346     /// @param _to The address of the recipient
347     /// @param _value The quantity of shares or tokens to be transferred
348     /// @return Whether the function was successful or not 
349     function transferFromTo(
350         address _from,
351         address _to, 
352         uint256 _value
353         ) internal returns (bool success);
354 
355     /// @notice send `_value` token to `_to` from `msg.sender`
356     /// @param _to The address of the recipient
357     /// @param _value The quantity of shares or tokens to be transferred
358     /// @return Whether the function was successful or not 
359     function transfer(address _to, uint256 _value) returns (bool success);
360 
361     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
362     /// @param _from The address of the sender
363     /// @param _to The address of the recipient
364     /// @param _value The quantity of shares or tokens to be transferred
365     function transferFrom(
366         address _from, 
367         address _to, 
368         uint256 _value
369         ) returns (bool success);
370 
371     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf
372     /// @param _spender The address of the account able to transfer the tokens
373     /// @param _value The amount of tokens to be approved for transfer
374     /// @return Whether the approval was successful or not
375     function approve(address _spender, uint256 _value) returns (bool success);
376 
377     event FeesReceived(address indexed From, uint Amount);
378     event AmountReceived(address indexed From, uint Amount);
379     event paymentReceived(address indexed daoManager, uint Amount);
380     event ProposalCloned(uint indexed LastClientProposalID, uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
381     event ClientUpdated(address LastClient, address NewClient);
382     event RecipientUpdated(address LastRecipient, address NewRecipient);
383     event ProposalAdded(uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
384     event Order(uint indexed clientProposalID, uint indexed ProposalID, uint Amount);
385     event Withdawal(address indexed Recipient, uint Amount);
386     event TokenPriceProposalSet(uint InitialPriceMultiplier, uint InflationRate, uint ClosingTime);
387     event holderAdded(uint Index, address Holder);
388     event TokensCreated(address indexed Sender, address indexed TokenHolder, uint Quantity);
389     event FundingRulesSet(address indexed MainPartner, uint indexed FundingProposalId, uint indexed StartTime, uint ClosingTime);
390     event FundingFueled(uint indexed FundingProposalID, uint FundedAmount);
391     event TransferAble();
392     event TransferDisable(uint closingTime);
393     event Transfer(address indexed _from, address indexed _to, uint256 _value);
394     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
395 
396 
397 }    
398 
399 contract PassManager is PassManagerInterface {
400 
401 // Constant functions
402 
403     function Client() constant returns (address) {
404         if (recipient == 0) return client;
405         else return daoManager.Client();
406     }
407     
408     function ClosingTimeForCloning() constant returns (uint) {
409         if (recipient == 0) return closingTimeForCloning;
410         else return daoManager.ClosingTimeForCloning();
411     }
412     
413     function totalSupply() constant external returns (uint256) {
414         return totalTokenSupply;
415     }
416 
417      function balanceOf(address _owner) constant external returns (uint256 balance) {
418         return balances[_owner];
419      }
420 
421     function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {
422         return allowed[_owner][_spender];
423     }
424 
425     function FundedAmount(uint _proposalID) constant external returns (uint) {
426         return fundedAmount[_proposalID];
427     }
428 
429     function priceDivisor(uint _saleDate) constant internal returns (uint) {
430         uint _date = _saleDate;
431         
432         if (_saleDate > FundingRules[0].closingTime) _date = FundingRules[0].closingTime;
433         if (_saleDate < FundingRules[0].startTime) _date = FundingRules[0].startTime;
434 
435         return 100 + 100*FundingRules[0].inflationRate*(_date - FundingRules[0].startTime)/(100*365 days);
436     }
437     
438     function actualPriceDivisor() constant external returns (uint) {
439         return priceDivisor(now);
440     }
441 
442     function fundingMaxAmount(address _mainPartner) constant external returns (uint) {
443         
444         if (now > FundingRules[0].closingTime
445             || now < FundingRules[0].startTime
446             || _mainPartner != FundingRules[0].mainPartner) {
447             return 0;   
448         } else {
449             return FundingRules[0].maxAmountToFund;
450         }
451         
452     }
453 
454     function numberOfHolders() constant returns (uint) {
455         return holders.length - 1;
456     }
457     
458     function HolderAddress(uint _index) constant returns (address) {
459         return holders[_index];
460     }
461 
462     function numberOfProposals() constant returns (uint) {
463         return proposals.length - 1;
464     }
465 
466 // Modifiers
467 
468     // Modifier that allows only the client to manage this account manager
469     modifier onlyClient {if (msg.sender != Client()) throw; _;}
470     
471     // Modifier that allows only the main partner to manage the actual funding
472     modifier onlyMainPartner {if (msg.sender !=  FundingRules[0].mainPartner) throw; _;}
473     
474     // Modifier that allows only the contractor propose set the token price or withdraw
475     modifier onlyContractor {if (recipient == 0 || (msg.sender != recipient && msg.sender != creator)) throw; _;}
476     
477     // Modifier for Dao functions
478     modifier onlyDao {if (recipient != 0) throw; _;}
479     
480 // Constructor function
481 
482     function PassManager(
483         address _client,
484         address _daoManager,
485         address _recipient,
486         address _clonedFrom,
487         string _tokenName,
488         string _tokenSymbol,
489         uint8 _tokenDecimals,
490         bool _transferable
491     ) {
492 
493         if ((_recipient == 0 && _client == 0)
494             || _client == _recipient) throw;
495 
496         creator = msg.sender; 
497         client = _client;
498         recipient = _recipient;
499         
500         if (_recipient !=0) daoManager = PassManager(_daoManager);
501 
502         clonedFrom = _clonedFrom;            
503         
504         name = _tokenName;
505         symbol = _tokenSymbol;
506         decimals = _tokenDecimals;
507           
508         if (_transferable) {
509             transferable = true;
510             TransferAble();
511         } else {
512             transferable = false;
513             TransferDisable(0);
514         }
515 
516         holders.length = 1;
517         proposals.length = 1;
518         
519     }
520 
521 // Setting functions
522 
523     function initialTokenSupply(
524         address _recipient, 
525         uint _quantity,
526         bool _last) returns (bool success) {
527 
528         if (smartContractStartDate != 0 || initialTokenSupplyDone) throw;
529         
530         if (_recipient != 0 && _quantity != 0) {
531             return (createInitialTokens(_recipient, _quantity));
532         }
533         
534         if (_last) initialTokenSupplyDone = true;
535             
536     }
537 
538     function cloneProposal(
539         uint _amount,
540         string _description,
541         bytes32 _hashOfTheDocument,
542         uint _dateOfProposal,
543         uint _lastClientProposalID,
544         uint _orderAmount,
545         uint _dateOfOrder
546     ) returns (bool success) {
547             
548         if (smartContractStartDate != 0 || recipient == 0
549         || msg.sender != creator) throw;
550         
551         uint _proposalID = proposals.length++;
552         proposal c = proposals[_proposalID];
553 
554         c.amount = _amount;
555         c.description = _description;
556         c.hashOfTheDocument = _hashOfTheDocument; 
557         c.dateOfProposal = _dateOfProposal;
558         c.lastClientProposalID = _lastClientProposalID;
559         c.orderAmount = _orderAmount;
560         c.dateOfOrder = _dateOfOrder;
561         
562         ProposalCloned(_lastClientProposalID, _proposalID, c.amount, c.description, c.hashOfTheDocument);
563         
564         return true;
565             
566     }
567 
568     function cloneTokens(
569         uint _from,
570         uint _to) returns (bool success) {
571         
572         if (smartContractStartDate != 0) throw;
573         
574         PassManager _clonedFrom = PassManager(clonedFrom);
575         
576         if (_from < 1 || _to > _clonedFrom.numberOfHolders()) throw;
577 
578         address _holder;
579 
580         for (uint i = _from; i <= _to; i++) {
581             _holder = _clonedFrom.HolderAddress(i);
582             if (balances[_holder] == 0) {
583                 createInitialTokens(_holder, _clonedFrom.balanceOf(_holder));
584             }
585         }
586 
587         return true;
588         
589     }
590 
591     function closeSetup() {
592         
593         if (smartContractStartDate != 0 || msg.sender != creator) throw;
594 
595         smartContractStartDate = now;
596 
597     }
598 
599 // Function to receive payments or deposits
600 
601     function () payable {
602         AmountReceived(msg.sender, msg.value);
603     }
604     
605 // Contractors Account Management
606 
607     function updateRecipient(address _newRecipient) onlyContractor {
608 
609         if (_newRecipient == 0 
610             || _newRecipient == client) throw;
611 
612         RecipientUpdated(recipient, _newRecipient);
613         recipient = _newRecipient;
614 
615     } 
616 
617     function withdraw(uint _amount) onlyContractor {
618         if (!recipient.send(_amount)) throw;
619         Withdawal(recipient, _amount);
620     }
621     
622 // DAO Proposals Management
623 
624     function updateClient(address _newClient) onlyClient {
625         
626         if (_newClient == 0 
627             || _newClient == recipient) throw;
628 
629         ClientUpdated(client, _newClient);
630         client = _newClient;        
631 
632     }
633 
634     function newProposal(
635         uint _amount,
636         string _description, 
637         bytes32 _hashOfTheDocument
638     ) onlyContractor returns (uint) {
639 
640         uint _proposalID = proposals.length++;
641         proposal c = proposals[_proposalID];
642 
643         c.amount = _amount;
644         c.description = _description;
645         c.hashOfTheDocument = _hashOfTheDocument; 
646         c.dateOfProposal = now;
647         
648         ProposalAdded(_proposalID, c.amount, c.description, c.hashOfTheDocument);
649         
650         return _proposalID;
651         
652     }
653     
654     function order(
655         uint _clientProposalID,
656         uint _proposalID,
657         uint _orderAmount
658     ) external onlyClient returns (bool) {
659     
660         proposal c = proposals[_proposalID];
661         
662         uint _sum = c.orderAmount + _orderAmount;
663         if (_sum > c.amount
664             || _sum < c.orderAmount
665             || _sum < _orderAmount) return; 
666 
667         c.lastClientProposalID =  _clientProposalID;
668         c.orderAmount = _sum;
669         c.dateOfOrder = now;
670         
671         Order(_clientProposalID, _proposalID, _orderAmount);
672         
673         return true;
674 
675     }
676 
677     function sendTo(
678         address _recipient,
679         uint _amount
680     ) external onlyClient onlyDao returns (bool) {
681 
682         if (_recipient.send(_amount)) return true;
683         else return false;
684 
685     }
686     
687 // Token Management
688     
689     function addHolder(address _holder) internal {
690         
691         if (holderID[_holder] == 0) {
692             
693             uint _holderID = holders.length++;
694             holders[_holderID] = _holder;
695             holderID[_holder] = _holderID;
696             holderAdded(_holderID, _holder);
697 
698         }
699         
700     }
701     
702     function createInitialTokens(
703         address _holder, 
704         uint _quantity
705     ) internal returns (bool success) {
706 
707         if (_quantity > 0 && balances[_holder] == 0) {
708             addHolder(_holder);
709             balances[_holder] = _quantity; 
710             totalTokenSupply += _quantity;
711             TokensCreated(msg.sender, _holder, _quantity);
712             return true;
713         }
714         
715     }
716     
717     function setTokenPriceProposal(        
718         uint _initialPriceMultiplier, 
719         uint _inflationRate,
720         uint _closingTime
721     ) onlyContractor {
722         
723         if (_closingTime < now 
724             || now < FundingRules[1].closingTime) throw;
725         
726         FundingRules[1].initialPriceMultiplier = _initialPriceMultiplier;
727         FundingRules[1].inflationRate = _inflationRate;
728         FundingRules[1].startTime = now;
729         FundingRules[1].closingTime = _closingTime;
730         
731         TokenPriceProposalSet(_initialPriceMultiplier, _inflationRate, _closingTime);
732     }
733     
734     function setFundingRules(
735         address _mainPartner,
736         bool _publicCreation, 
737         uint _initialPriceMultiplier,
738         uint _maxAmountToFund, 
739         uint _minutesFundingPeriod, 
740         uint _inflationRate,
741         uint _proposalID
742     ) external onlyClient {
743 
744         if (now < FundingRules[0].closingTime
745             || _mainPartner == address(this)
746             || _mainPartner == client
747             || (!_publicCreation && _mainPartner == 0)
748             || (_publicCreation && _mainPartner != 0)
749             || (recipient == 0 && _initialPriceMultiplier == 0)
750             || (recipient != 0 
751                 && (FundingRules[1].initialPriceMultiplier == 0
752                     || _inflationRate < FundingRules[1].inflationRate
753                     || now < FundingRules[1].startTime
754                     || FundingRules[1].closingTime < now + (_minutesFundingPeriod * 1 minutes)))
755             || _maxAmountToFund == 0
756             || _minutesFundingPeriod == 0
757             ) throw;
758 
759         FundingRules[0].startTime = now;
760         FundingRules[0].closingTime = now + _minutesFundingPeriod * 1 minutes;
761             
762         FundingRules[0].mainPartner = _mainPartner;
763         FundingRules[0].publicCreation = _publicCreation;
764         
765         if (recipient == 0) FundingRules[0].initialPriceMultiplier = _initialPriceMultiplier;
766         else FundingRules[0].initialPriceMultiplier = FundingRules[1].initialPriceMultiplier;
767         
768         if (recipient == 0) FundingRules[0].inflationRate = _inflationRate;
769         else FundingRules[0].inflationRate = FundingRules[1].inflationRate;
770         
771         FundingRules[0].fundedAmount = 0;
772         FundingRules[0].maxAmountToFund = _maxAmountToFund;
773 
774         FundingRules[0].proposalID = _proposalID;
775 
776         FundingRulesSet(_mainPartner, _proposalID, FundingRules[0].startTime, FundingRules[0].closingTime);
777             
778     } 
779     
780     function createToken(
781         address _recipient, 
782         uint _amount,
783         uint _saleDate
784     ) internal returns (bool success) {
785 
786         if (now > FundingRules[0].closingTime
787             || now < FundingRules[0].startTime
788             ||_saleDate > FundingRules[0].closingTime
789             || _saleDate < FundingRules[0].startTime
790             || FundingRules[0].fundedAmount + _amount > FundingRules[0].maxAmountToFund) return;
791 
792         uint _a = _amount*FundingRules[0].initialPriceMultiplier;
793         uint _multiplier = 100*_a;
794         uint _quantity = _multiplier/priceDivisor(_saleDate);
795         if (_a/_amount != FundingRules[0].initialPriceMultiplier
796             || _multiplier/100 != _a
797             || totalTokenSupply + _quantity <= totalTokenSupply 
798             || totalTokenSupply + _quantity <= _quantity) return;
799 
800         addHolder(_recipient);
801         balances[_recipient] += _quantity;
802         totalTokenSupply += _quantity;
803         FundingRules[0].fundedAmount += _amount;
804 
805         TokensCreated(msg.sender, _recipient, _quantity);
806         
807         if (FundingRules[0].fundedAmount == FundingRules[0].maxAmountToFund) closeFunding();
808         
809         return true;
810 
811     }
812 
813     function setFundingStartTime(uint _startTime) external onlyMainPartner {
814         if (now > FundingRules[0].closingTime) throw;
815         FundingRules[0].startTime = _startTime;
816     }
817     
818     function rewardToken(
819         address _recipient, 
820         uint _amount,
821         uint _date
822         ) external onlyMainPartner {
823 
824         uint _saleDate;
825         if (_date == 0) _saleDate = now; else _saleDate = _date;
826 
827         if (!createToken(_recipient, _amount, _saleDate)) throw;
828 
829     }
830 
831     function closeFunding() internal {
832         if (recipient == 0) fundedAmount[FundingRules[0].proposalID] = FundingRules[0].fundedAmount;
833         FundingRules[0].closingTime = now;
834     }
835     
836     function setFundingFueled() external onlyMainPartner {
837         if (now > FundingRules[0].closingTime) throw;
838         closeFunding();
839         if (recipient == 0) FundingFueled(FundingRules[0].proposalID, FundingRules[0].fundedAmount);
840     }
841     
842     function ableTransfer() onlyClient {
843         if (!transferable) {
844             transferable = true;
845             closingTimeForCloning = 0;
846             TransferAble();
847         }
848     }
849 
850     function disableTransfer(uint _closingTime) onlyClient {
851         if (transferable && _closingTime == 0) transferable = false;
852         else closingTimeForCloning = _closingTime;
853             
854         TransferDisable(_closingTime);
855     }
856     
857     function blockTransfer(address _shareHolder, uint _deadLine) external onlyClient onlyDao {
858         if (_deadLine > blockedDeadLine[_shareHolder]) {
859             blockedDeadLine[_shareHolder] = _deadLine;
860         }
861     }
862     
863     function buyShares() payable {
864         buySharesFor(msg.sender);
865     } 
866     
867     function buySharesFor(address _recipient) payable onlyDao {
868         
869         if (!FundingRules[0].publicCreation 
870             || !createToken(_recipient, msg.value, now)) throw;
871 
872     }
873     
874     function transferFromTo(
875         address _from,
876         address _to, 
877         uint256 _value
878         ) internal returns (bool success) {  
879 
880         if ((transferable && now > ClosingTimeForCloning())
881             && now > blockedDeadLine[_from]
882             && now > blockedDeadLine[_to]
883             && _to != address(this)
884             && balances[_from] >= _value
885             && balances[_to] + _value > balances[_to]
886             && balances[_to] + _value >= _value
887         ) {
888             balances[_from] -= _value;
889             balances[_to] += _value;
890             Transfer(_from, _to, _value);
891             addHolder(_to);
892             return true;
893         } else {
894             return false;
895         }
896         
897     }
898 
899     function transfer(address _to, uint256 _value) returns (bool success) {  
900         if (!transferFromTo(msg.sender, _to, _value)) throw;
901         return true;
902     }
903 
904     function transferFrom(
905         address _from, 
906         address _to, 
907         uint256 _value
908         ) returns (bool success) { 
909         
910         if (allowed[_from][msg.sender] < _value
911             || !transferFromTo(_from, _to, _value)) throw;
912             
913         allowed[_from][msg.sender] -= _value;
914         return true;
915     }
916 
917     function approve(address _spender, uint256 _value) returns (bool success) {
918         allowed[msg.sender][_spender] = _value;
919         return true;
920     }
921     
922 }