1 pragma solidity ^ 0.4 .6;
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
12  */
13 
14 /// @title Token Manager smart contract of the Pass Decentralized Autonomous Organisation
15 contract PassTokenManagerInterface {
16 
17         struct fundingData {
18                 // True if public funding without a main partner
19                 bool publicCreation;
20                 // The address which sets partners and manages the funding in case of private funding
21                 address mainPartner;
22                 // The maximum amount (in wei) of the funding
23                 uint maxAmountToFund;
24                 // The actual funded amount (in wei)
25                 uint fundedAmount;
26                 // A unix timestamp, denoting the start time of the funding
27                 uint startTime;
28                 // A unix timestamp, denoting the closing time of the funding
29                 uint closingTime;
30                 // The price multiplier for a share or a token without considering the inflation rate
31                 uint initialPriceMultiplier;
32                 // Rate per year in percentage applied to the share or token price 
33                 uint inflationRate;
34                 // Index of the client proposal
35                 uint proposalID;
36         }
37 
38         // Address of the creator of the smart contract
39         address public creator;
40         // Address of the Dao    
41         address public client;
42         // Address of the recipient;
43         address public recipient;
44 
45         // The token name for display purpose
46         string public name;
47         // The token symbol for display purpose
48         string public symbol;
49         // The quantity of decimals for display purpose
50         uint8 public decimals;
51 
52         // End date of the setup procedure
53         uint public smartContractStartDate;
54 
55         // Total amount of tokens
56         uint256 totalTokenSupply;
57 
58         // Array with all balances
59         mapping(address => uint256) balances;
60         // Array with all allowances
61         mapping(address => mapping(address => uint256)) allowed;
62 
63         // Map of the result (in wei) of fundings
64         mapping(uint => uint) fundedAmount;
65 
66         // Array of token or share holders
67         address[] holders;
68         // Map with the indexes of the holders
69         mapping(address => uint) public holderID;
70 
71         // If true, the shares or tokens can be transfered
72         bool public transferable;
73         // Map of blocked Dao share accounts. Points to the date when the share holder can transfer shares
74         mapping(address => uint) public blockedDeadLine;
75 
76         // Rules for the actual funding and the contractor token price
77         fundingData[2] public FundingRules;
78 
79         /// @return The total supply of shares or tokens 
80         function totalSupply() constant external returns(uint256);
81 
82         /// @param _owner The address from which the balance will be retrieved
83         /// @return The balance
84         function balanceOf(address _owner) constant external returns(uint256 balance);
85 
86         /// @param _owner The address of the account owning tokens
87         /// @param _spender The address of the account able to transfer the tokens
88         /// @return Quantity of remaining tokens of _owner that _spender is allowed to spend
89         function allowance(address _owner, address _spender) constant external returns(uint256 remaining);
90 
91         /// @param _proposalID The index of the Dao proposal
92         /// @return The result (in wei) of the funding
93         function FundedAmount(uint _proposalID) constant external returns(uint);
94 
95         /// @param _saleDate in case of presale, the date of the presale
96         /// @return the share or token price divisor condidering the sale date and the inflation rate
97         function priceDivisor(uint _saleDate) constant internal returns(uint);
98 
99         /// @return the actual price divisor of a share or token
100         function actualPriceDivisor() constant external returns(uint);
101 
102         /// @return The maximal amount a main partner can fund at this moment
103         /// @param _mainPartner The address of the main parner
104         function fundingMaxAmount(address _mainPartner) constant external returns(uint);
105 
106         /// @return The number of share or token holders 
107         function numberOfHolders() constant returns(uint);
108 
109         /// @param _index The index of the holder
110         /// @return the address of the an holder
111         function HolderAddress(uint _index) constant returns(address);
112 
113         // Modifier that allows only the client to manage this account manager
114         modifier onlyClient {
115                 if (msg.sender != client) throw;
116                 _;
117         }
118 
119         // Modifier that allows only the main partner to manage the actual funding
120         modifier onlyMainPartner {
121                 if (msg.sender != FundingRules[0].mainPartner) throw;
122                 _;
123         }
124 
125         // Modifier that allows only the contractor propose set the token price or withdraw
126         modifier onlyContractor {
127                 if (recipient == 0 || (msg.sender != recipient && msg.sender != creator)) throw;
128                 _;
129         }
130 
131         // Modifier for Dao functions
132         modifier onlyDao {
133                 if (recipient != 0) throw;
134                 _;
135         }
136 
137         /// @dev The constructor function
138         /// @param _creator The address of the creator of the smart contract
139         /// @param _client The address of the client or Dao
140         /// @param _recipient The recipient of this manager
141         /// @param _tokenName The token name for display purpose
142         /// @param _tokenSymbol The token symbol for display purpose
143         /// @param _tokenDecimals The quantity of decimals for display purpose
144         /// @param _transferable True if allows the transfer of tokens
145         //function PassTokenManager(
146         //    address _creator,
147         //    address _client,
148         //    address _recipient,
149         //    string _tokenName,
150         //    string _tokenSymbol,
151         //    uint8 _tokenDecimals,
152         //    bool _transferable);
153 
154         /// @notice Function to create initial tokens    
155         /// @param _holder The beneficiary of the created tokens
156         /// @param _quantity The quantity of tokens to create
157         function createInitialTokens(address _holder, uint _quantity);
158 
159         /// @notice Function to close the setup procedure of this contract
160         function closeSetup();
161 
162         /// @notice Function that allow the contractor to propose a token price
163         /// @param _initialPriceMultiplier The initial price multiplier of contractor tokens
164         /// @param _inflationRate If 0, the contractor token price doesn't change during the funding
165         /// @param _closingTime The initial price and inflation rate can be changed after this date
166         function setTokenPriceProposal(
167                 uint _initialPriceMultiplier,
168                 uint _inflationRate,
169                 uint _closingTime
170         );
171 
172         /// @notice Function to set a funding. Can be private or public
173         /// @param _mainPartner The address of the smart contract to manage a private funding
174         /// @param _publicCreation True if public funding
175         /// @param _initialPriceMultiplier Price multiplier without considering any inflation rate
176         /// @param _maxAmountToFund The maximum amount (in wei) of the funding
177         /// @param _minutesFundingPeriod Period in minutes of the funding
178         /// @param _inflationRate If 0, the token price doesn't change during the funding
179         /// @param _proposalID Index of the client proposal (not mandatory)
180         function setFundingRules(
181                 address _mainPartner,
182                 bool _publicCreation,
183                 uint _initialPriceMultiplier,
184                 uint _maxAmountToFund,
185                 uint _minutesFundingPeriod,
186                 uint _inflationRate,
187                 uint _proposalID
188         ) external;
189 
190         /// @dev Internal function to add a new token or share holder
191         /// @param _holder The address of the token or share holder
192         function addHolder(address _holder) internal;
193 
194         /// @dev Internal function for the creation of shares or tokens
195         /// @param _recipient The recipient address of shares or tokens
196         /// @param _amount The funded amount (in wei)
197         /// @param _saleDate In case of presale, the date of the presale
198         /// @return Whether the creation was successful or not
199         function createToken(
200                 address _recipient,
201                 uint _amount,
202                 uint _saleDate
203         ) internal returns(bool success);
204 
205         /// @notice Function used by the main partner to set the start time of the funding
206         /// @param _startTime The unix start date of the funding 
207         function setFundingStartTime(uint _startTime) external;
208 
209         /// @notice Function used by the main partner to reward shares or tokens
210         /// @param _recipient The address of the recipient of shares or tokens
211         /// @param _amount The amount (in Wei) to calculate the quantity of shares or tokens to create
212         /// @param _date The unix date to consider for the share or token price calculation
213         /// @return Whether the transfer was successful or not
214         function rewardToken(
215                 address _recipient,
216                 uint _amount,
217                 uint _date
218         ) external;
219 
220         /// @dev Internal function to close the actual funding
221         function closeFunding() internal;
222 
223         /// @notice Function used by the main partner to set the funding fueled
224         function setFundingFueled() external;
225 
226         /// @notice Function to able the transfer of Dao shares or contractor tokens
227         function ableTransfer();
228 
229         /// @notice Function to disable the transfer of Dao shares
230         function disableTransfer();
231 
232         /// @notice Function used by the client to block the transfer of shares from and to a share holder
233         /// @param _shareHolder The address of the share holder
234         /// @param _deadLine When the account will be unblocked
235         function blockTransfer(address _shareHolder, uint _deadLine) external;
236 
237         /// @dev Internal function to send `_value` token to `_to` from `_From`
238         /// @param _from The address of the sender
239         /// @param _to The address of the recipient
240         /// @param _value The quantity of shares or tokens to be transferred
241         /// @return Whether the function was successful or not 
242         function transferFromTo(
243                 address _from,
244                 address _to,
245                 uint256 _value
246         ) internal returns(bool success);
247 
248         /// @notice send `_value` token to `_to` from `msg.sender`
249         /// @param _to The address of the recipient
250         /// @param _value The quantity of shares or tokens to be transferred
251         /// @return Whether the function was successful or not 
252         function transfer(address _to, uint256 _value) returns(bool success);
253 
254         /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
255         /// @param _from The address of the sender
256         /// @param _to The address of the recipient
257         /// @param _value The quantity of shares or tokens to be transferred
258         function transferFrom(
259                 address _from,
260                 address _to,
261                 uint256 _value
262         ) returns(bool success);
263 
264         /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf
265         /// @param _spender The address of the account able to transfer the tokens
266         /// @param _value The amount of tokens to be approved for transfer
267         /// @return Whether the approval was successful or not
268         function approve(address _spender, uint256 _value) returns(bool success);
269 
270         event TokenPriceProposalSet(uint InitialPriceMultiplier, uint InflationRate, uint ClosingTime);
271         event holderAdded(uint Index, address Holder);
272         event TokensCreated(address indexed Sender, address indexed TokenHolder, uint Quantity);
273         event FundingRulesSet(address indexed MainPartner, uint indexed FundingProposalId, uint indexed StartTime, uint ClosingTime);
274         event FundingFueled(uint indexed FundingProposalID, uint FundedAmount);
275         event TransferAble();
276         event TransferDisable();
277         event Transfer(address indexed _from, address indexed _to, uint256 _value);
278         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
279 
280 }
281 
282 contract PassTokenManager is PassTokenManagerInterface {
283 
284         function totalSupply() constant external returns(uint256) {
285                 return totalTokenSupply;
286         }
287 
288         function balanceOf(address _owner) constant external returns(uint256 balance) {
289                 return balances[_owner];
290         }
291 
292         function allowance(address _owner, address _spender) constant external returns(uint256 remaining) {
293                 return allowed[_owner][_spender];
294         }
295 
296         function FundedAmount(uint _proposalID) constant external returns(uint) {
297                 return fundedAmount[_proposalID];
298         }
299 
300         function priceDivisor(uint _saleDate) constant internal returns(uint) {
301                 uint _date = _saleDate;
302 
303                 if (_saleDate > FundingRules[0].closingTime) _date = FundingRules[0].closingTime;
304                 if (_saleDate < FundingRules[0].startTime) _date = FundingRules[0].startTime;
305 
306                 return 100 + 100 * FundingRules[0].inflationRate * (_date - FundingRules[0].startTime) / (100 * 365 days);
307         }
308 
309         function actualPriceDivisor() constant external returns(uint) {
310                 return priceDivisor(now);
311         }
312 
313         function fundingMaxAmount(address _mainPartner) constant external returns(uint) {
314 
315                 if (now > FundingRules[0].closingTime || now < FundingRules[0].startTime || _mainPartner != FundingRules[0].mainPartner) {
316                         return 0;
317                 } else {
318                         return FundingRules[0].maxAmountToFund;
319                 }
320 
321         }
322 
323         function numberOfHolders() constant returns(uint) {
324                 return holders.length - 1;
325         }
326 
327         function HolderAddress(uint _index) constant returns(address) {
328                 return holders[_index];
329         }
330 
331         function PassTokenManager(
332                 address _creator,
333                 address _client,
334                 address _recipient,
335                 string _tokenName,
336                 string _tokenSymbol,
337                 uint8 _tokenDecimals,
338                 bool _transferable) {
339 
340                 if (_creator == 0 || _client == 0 || _client == _recipient || _client == address(this) || _recipient == address(this)) throw;
341 
342                 creator = _creator;
343                 client = _client;
344                 recipient = _recipient;
345 
346                 holders.length = 1;
347 
348                 name = _tokenName;
349                 symbol = _tokenSymbol;
350                 decimals = _tokenDecimals;
351 
352                 if (_transferable) {
353                         transferable = true;
354                         TransferAble();
355                 } else {
356                         transferable = false;
357                         TransferDisable();
358                 }
359 
360         }
361 
362         function createInitialTokens(
363                 address _holder,
364                 uint _quantity
365         ) {
366 
367                 if (smartContractStartDate != 0) throw;
368 
369                 if (_quantity > 0 && balances[_holder] == 0) {
370                         addHolder(_holder);
371                         balances[_holder] = _quantity;
372                         totalTokenSupply += _quantity;
373                         TokensCreated(msg.sender, _holder, _quantity);
374                 }
375 
376         }
377 
378         function closeSetup() {
379                 smartContractStartDate = now;
380         }
381 
382         function setTokenPriceProposal(
383                 uint _initialPriceMultiplier,
384                 uint _inflationRate,
385                 uint _closingTime
386         ) onlyContractor {
387 
388                 if (_closingTime < now || now < FundingRules[1].closingTime) throw;
389 
390                 FundingRules[1].initialPriceMultiplier = _initialPriceMultiplier;
391                 FundingRules[1].inflationRate = _inflationRate;
392                 FundingRules[1].startTime = now;
393                 FundingRules[1].closingTime = _closingTime;
394 
395                 TokenPriceProposalSet(_initialPriceMultiplier, _inflationRate, _closingTime);
396         }
397 
398         function setFundingRules(
399                 address _mainPartner,
400                 bool _publicCreation,
401                 uint _initialPriceMultiplier,
402                 uint _maxAmountToFund,
403                 uint _minutesFundingPeriod,
404                 uint _inflationRate,
405                 uint _proposalID
406         ) external onlyClient {
407 
408                 if (now < FundingRules[0].closingTime || _mainPartner == address(this) || _mainPartner == client || (!_publicCreation && _mainPartner == 0) || (_publicCreation && _mainPartner != 0) || (recipient == 0 && _initialPriceMultiplier == 0) || (recipient != 0 && (FundingRules[1].initialPriceMultiplier == 0 || _inflationRate < FundingRules[1].inflationRate || now < FundingRules[1].startTime || FundingRules[1].closingTime < now + (_minutesFundingPeriod * 1 minutes))) || _maxAmountToFund == 0 || _minutesFundingPeriod == 0) throw;
409 
410                 FundingRules[0].startTime = now;
411                 FundingRules[0].closingTime = now + _minutesFundingPeriod * 1 minutes;
412 
413                 FundingRules[0].mainPartner = _mainPartner;
414                 FundingRules[0].publicCreation = _publicCreation;
415 
416                 if (recipient == 0) FundingRules[0].initialPriceMultiplier = _initialPriceMultiplier;
417                 else FundingRules[0].initialPriceMultiplier = FundingRules[1].initialPriceMultiplier;
418 
419                 if (recipient == 0) FundingRules[0].inflationRate = _inflationRate;
420                 else FundingRules[0].inflationRate = FundingRules[1].inflationRate;
421 
422                 FundingRules[0].fundedAmount = 0;
423                 FundingRules[0].maxAmountToFund = _maxAmountToFund;
424 
425                 FundingRules[0].proposalID = _proposalID;
426 
427                 FundingRulesSet(_mainPartner, _proposalID, FundingRules[0].startTime, FundingRules[0].closingTime);
428 
429         }
430 
431         function addHolder(address _holder) internal {
432 
433                 if (holderID[_holder] == 0) {
434 
435                         uint _holderID = holders.length++;
436                         holders[_holderID] = _holder;
437                         holderID[_holder] = _holderID;
438                         holderAdded(_holderID, _holder);
439 
440                 }
441 
442         }
443 
444         function createToken(
445                 address _recipient,
446                 uint _amount,
447                 uint _saleDate
448         ) internal returns(bool success) {
449 
450                 if (now > FundingRules[0].closingTime || now < FundingRules[0].startTime || _saleDate > FundingRules[0].closingTime || _saleDate < FundingRules[0].startTime || FundingRules[0].fundedAmount + _amount > FundingRules[0].maxAmountToFund) return;
451 
452                 uint _a = _amount * FundingRules[0].initialPriceMultiplier;
453                 uint _multiplier = 100 * _a;
454                 uint _quantity = _multiplier / priceDivisor(_saleDate);
455                 if (_a / _amount != FundingRules[0].initialPriceMultiplier || _multiplier / 100 != _a || totalTokenSupply + _quantity <= totalTokenSupply || totalTokenSupply + _quantity <= _quantity) return;
456 
457                 addHolder(_recipient);
458                 balances[_recipient] += _quantity;
459                 totalTokenSupply += _quantity;
460                 FundingRules[0].fundedAmount += _amount;
461 
462                 TokensCreated(msg.sender, _recipient, _quantity);
463 
464                 if (FundingRules[0].fundedAmount == FundingRules[0].maxAmountToFund) closeFunding();
465 
466                 return true;
467 
468         }
469 
470         function setFundingStartTime(uint _startTime) external onlyMainPartner {
471                 if (now > FundingRules[0].closingTime) throw;
472                 FundingRules[0].startTime = _startTime;
473         }
474 
475         function rewardToken(
476                 address _recipient,
477                 uint _amount,
478                 uint _date
479         ) external onlyMainPartner {
480 
481                 uint _saleDate;
482                 if (_date == 0) _saleDate = now;
483                 else _saleDate = _date;
484 
485                 if (!createToken(_recipient, _amount, _saleDate)) throw;
486 
487         }
488 
489         function closeFunding() internal {
490                 if (recipient == 0) fundedAmount[FundingRules[0].proposalID] = FundingRules[0].fundedAmount;
491                 FundingRules[0].closingTime = now;
492         }
493 
494         function setFundingFueled() external onlyMainPartner {
495                 if (now > FundingRules[0].closingTime) throw;
496                 closeFunding();
497                 if (recipient == 0) FundingFueled(FundingRules[0].proposalID, FundingRules[0].fundedAmount);
498         }
499 
500         function ableTransfer() onlyClient {
501                 if (!transferable) {
502                         transferable = true;
503                         TransferAble();
504                 }
505         }
506 
507         function disableTransfer() onlyClient {
508                 if (transferable) {
509                         transferable = false;
510                         TransferDisable();
511                 }
512         }
513 
514         function blockTransfer(address _shareHolder, uint _deadLine) external onlyClient onlyDao {
515                 if (_deadLine > blockedDeadLine[_shareHolder]) {
516                         blockedDeadLine[_shareHolder] = _deadLine;
517                 }
518         }
519 
520         function transferFromTo(
521                 address _from,
522                 address _to,
523                 uint256 _value
524         ) internal returns(bool success) {
525 
526                 if (transferable && now > blockedDeadLine[_from] && now > blockedDeadLine[_to] && _to != address(this) && balances[_from] >= _value && balances[_to] + _value > balances[_to] && balances[_to] + _value >= _value) {
527                         balances[_from] -= _value;
528                         balances[_to] += _value;
529                         Transfer(_from, _to, _value);
530                         addHolder(_to);
531                         return true;
532                 } else {
533                         return false;
534                 }
535 
536         }
537 
538         function transfer(address _to, uint256 _value) returns(bool success) {
539                 if (!transferFromTo(msg.sender, _to, _value)) throw;
540                 return true;
541         }
542 
543         function transferFrom(
544                 address _from,
545                 address _to,
546                 uint256 _value
547         ) returns(bool success) {
548 
549                 if (allowed[_from][msg.sender] < _value || !transferFromTo(_from, _to, _value)) throw;
550 
551                 allowed[_from][msg.sender] -= _value;
552                 return true;
553         }
554 
555         function approve(address _spender, uint256 _value) returns(bool success) {
556                 allowed[msg.sender][_spender] = _value;
557                 return true;
558         }
559 
560 }
561 
562 
563 pragma solidity ^ 0.4 .6;
564 
565 /*
566  *
567  * This file is part of Pass DAO.
568  *
569  * The Manager smart contract is used for the management of accounts and tokens.
570  * Allows to receive or withdraw ethers and to buy Dao shares.
571  * The contract derives to the Token Manager smart contract for the management of tokens.
572  *
573  * Recipient is 0 for the Dao account manager and the address of
574  * contractor's recipient for the contractors's mahagers.
575  *
576  */
577 
578 /// @title Manager smart contract of the Pass Decentralized Autonomous Organisation
579 contract PassManagerInterface is PassTokenManagerInterface {
580 
581         struct proposal {
582                 // Amount (in wei) of the proposal
583                 uint amount;
584                 // A description of the proposal
585                 string description;
586                 // The hash of the proposal's document
587                 bytes32 hashOfTheDocument;
588                 // A unix timestamp, denoting the date when the proposal was created
589                 uint dateOfProposal;
590                 // The index of the last approved client proposal
591                 uint lastClientProposalID;
592                 // The sum amount (in wei) ordered for this proposal 
593                 uint orderAmount;
594                 // A unix timestamp, denoting the date of the last order for the approved proposal
595                 uint dateOfOrder;
596         }
597 
598         // Proposals to work for the client
599         proposal[] public proposals;
600 
601         // The address of the last Manager before cloning
602         address public clonedFrom;
603 
604         /// @dev The constructor function
605         /// @param _client The address of the Dao
606         /// @param _recipient The address of the recipient. 0 for the Dao
607         /// @param _clonedFrom The address of the last Manager before cloning
608         /// @param _tokenName The token name for display purpose
609         /// @param _tokenSymbol The token symbol for display purpose
610         /// @param _tokenDecimals The quantity of decimals for display purpose
611         /// @param _transferable True if allows the transfer of tokens
612         //function PassManager(
613         //    address _client,
614         //    address _recipient,
615         //    address _clonedFrom,
616         //    string _tokenName,
617         //    string _tokenSymbol,
618         //    uint8 _tokenDecimals,
619         //    bool _transferable
620         //) PassTokenManager(
621         //    msg.sender,
622         //    _client,
623         //    _recipient,
624         //    _tokenName,
625         //    _tokenSymbol,
626         //    _tokenDecimals,
627         //    _transferable);
628 
629         /// @notice Function to allow sending fees in wei to the Dao
630         function receiveFees() payable;
631         /// @notice Function to allow the contractor making a deposit in wei
632         function receiveDeposit() payable;
633 
634         /// @notice Function to clone a proposal from another manager contract
635         /// @param _amount Amount (in wei) of the proposal
636         /// @param _description A description of the proposal
637         /// @param _hashOfTheDocument The hash of the proposal's document
638         /// @param _dateOfProposal A unix timestamp, denoting the date when the proposal was created
639         /// @param _lastClientProposalID The index of the last approved client proposal
640         /// @param _orderAmount The sum amount (in wei) ordered for this proposal 
641         /// @param _dateOfOrder A unix timestamp, denoting the date of the last order for the approved proposal
642         function cloneProposal(
643                 uint _amount,
644                 string _description,
645                 bytes32 _hashOfTheDocument,
646                 uint _dateOfProposal,
647                 uint _lastClientProposalID,
648                 uint _orderAmount,
649                 uint _dateOfOrder);
650 
651         /// @notice Function to clone tokens from a manager
652         /// @param _from The index of the first holder
653         /// @param _to The index of the last holder
654         function cloneTokens(
655                 uint _from,
656                 uint _to);
657 
658         /// @notice Function to update the client address
659         function updateClient(address _newClient);
660 
661         /// @notice Function to update the recipent address
662         /// @param _newRecipient The adress of the recipient
663         function updateRecipient(address _newRecipient);
664 
665         /// @notice Function to buy Dao shares according to the funding rules 
666         /// with `msg.sender` as the beneficiary
667         function buyShares() payable;
668 
669         /// @notice Function to buy Dao shares according to the funding rules 
670         /// @param _recipient The beneficiary of the created shares
671         function buySharesFor(address _recipient) payable;
672 
673         /// @notice Function to make a proposal to work for the client
674         /// @param _amount The amount (in wei) of the proposal
675         /// @param _description String describing the proposal
676         /// @param _hashOfTheDocument The hash of the proposal document
677         /// @return The index of the contractor proposal
678         function newProposal(
679                 uint _amount,
680                 string _description,
681                 bytes32 _hashOfTheDocument
682         ) returns(uint);
683 
684         /// @notice Function used by the client to order according to the contractor proposal
685         /// @param _clientProposalID The index of the last approved client proposal
686         /// @param _proposalID The index of the contractor proposal
687         /// @param _amount The amount (in wei) of the order
688         /// @return Whether the order was made or not
689         function order(
690                 uint _clientProposalID,
691                 uint _proposalID,
692                 uint _amount
693         ) external returns(bool);
694 
695         /// @notice Function used by the client to send ethers from the Dao manager
696         /// @param _recipient The address to send to
697         /// @param _amount The amount (in wei) to send
698         /// @return Whether the transfer was successful or not
699         function sendTo(
700                 address _recipient,
701                 uint _amount
702         ) external returns(bool);
703 
704         /// @notice Function to allow contractors to withdraw ethers
705         /// @param _amount The amount (in wei) to withdraw
706         function withdraw(uint _amount);
707 
708         /// @return The number of Dao rules proposals     
709         function numberOfProposals() constant returns(uint);
710 
711         event FeesReceived(address indexed From, uint Amount);
712         event DepositReceived(address indexed From, uint Amount);
713         event ProposalCloned(uint indexed LastClientProposalID, uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
714         event ClientUpdated(address LastClient, address NewClient);
715         event RecipientUpdated(address LastRecipient, address NewRecipient);
716         event ProposalAdded(uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
717         event Order(uint indexed clientProposalID, uint indexed ProposalID, uint Amount);
718         event Withdawal(address indexed Recipient, uint Amount);
719 
720 }
721 
722 contract PassManager is PassManagerInterface, PassTokenManager {
723 
724         function PassManager(
725                 address _client,
726                 address _recipient,
727                 address _clonedFrom,
728                 string _tokenName,
729                 string _tokenSymbol,
730                 uint8 _tokenDecimals,
731                 bool _transferable
732         ) PassTokenManager(
733                 msg.sender,
734                 _client,
735                 _recipient,
736                 _tokenName,
737                 _tokenSymbol,
738                 _tokenDecimals,
739                 _transferable
740         ) {
741 
742                 clonedFrom = _clonedFrom;
743                 proposals.length = 1;
744 
745         }
746 
747         function receiveFees() payable onlyDao {
748                 FeesReceived(msg.sender, msg.value);
749         }
750 
751         function receiveDeposit() payable onlyContractor {
752                 DepositReceived(msg.sender, msg.value);
753         }
754 
755         function cloneProposal(
756                 uint _amount,
757                 string _description,
758                 bytes32 _hashOfTheDocument,
759                 uint _dateOfProposal,
760                 uint _lastClientProposalID,
761                 uint _orderAmount,
762                 uint _dateOfOrder
763         ) {
764 
765                 if (smartContractStartDate != 0 || recipient == 0) throw;
766 
767                 uint _proposalID = proposals.length++;
768                 proposal c = proposals[_proposalID];
769 
770                 c.amount = _amount;
771                 c.description = _description;
772                 c.hashOfTheDocument = _hashOfTheDocument;
773                 c.dateOfProposal = _dateOfProposal;
774                 c.lastClientProposalID = _lastClientProposalID;
775                 c.orderAmount = _orderAmount;
776                 c.dateOfOrder = _dateOfOrder;
777 
778                 ProposalCloned(_lastClientProposalID, _proposalID, c.amount, c.description, c.hashOfTheDocument);
779 
780         }
781 
782         function cloneTokens(
783                 uint _from,
784                 uint _to) {
785 
786                 if (smartContractStartDate != 0) throw;
787 
788                 PassManager _clonedFrom = PassManager(_clonedFrom);
789 
790                 if (_from < 1 || _to > _clonedFrom.numberOfHolders()) throw;
791 
792                 address _holder;
793 
794                 for (uint i = _from; i <= _to; i++) {
795                         _holder = _clonedFrom.HolderAddress(i);
796                         if (balances[_holder] == 0) {
797                                 createInitialTokens(_holder, _clonedFrom.balanceOf(_holder));
798                         }
799                 }
800 
801         }
802 
803 
804         function updateClient(address _newClient) onlyClient {
805 
806                 if (_newClient == 0 || _newClient == recipient) throw;
807 
808                 ClientUpdated(client, _newClient);
809                 client = _newClient;
810 
811         }
812 
813         function updateRecipient(address _newRecipient) onlyContractor {
814 
815                 if (_newRecipient == 0 || _newRecipient == client) throw;
816 
817                 RecipientUpdated(recipient, _newRecipient);
818                 recipient = _newRecipient;
819 
820         }
821 
822         function buyShares() payable {
823                 buySharesFor(msg.sender);
824         }
825 
826         function buySharesFor(address _recipient) payable onlyDao {
827 
828                 if (!FundingRules[0].publicCreation || !createToken(_recipient, msg.value, now)) throw;
829 
830         }
831 
832         function newProposal(
833                 uint _amount,
834                 string _description,
835                 bytes32 _hashOfTheDocument
836         ) onlyContractor returns(uint) {
837 
838                 uint _proposalID = proposals.length++;
839                 proposal c = proposals[_proposalID];
840 
841                 c.amount = _amount;
842                 c.description = _description;
843                 c.hashOfTheDocument = _hashOfTheDocument;
844                 c.dateOfProposal = now;
845 
846                 ProposalAdded(_proposalID, c.amount, c.description, c.hashOfTheDocument);
847 
848                 return _proposalID;
849 
850         }
851 
852         function order(
853                 uint _clientProposalID,
854                 uint _proposalID,
855                 uint _orderAmount
856         ) external onlyClient returns(bool) {
857 
858                 proposal c = proposals[_proposalID];
859 
860                 uint _sum = c.orderAmount + _orderAmount;
861                 if (_sum > c.amount || _sum < c.orderAmount || _sum < _orderAmount) return;
862 
863                 c.lastClientProposalID = _clientProposalID;
864                 c.orderAmount = _sum;
865                 c.dateOfOrder = now;
866 
867                 Order(_clientProposalID, _proposalID, _orderAmount);
868 
869                 return true;
870 
871         }
872 
873         function sendTo(
874                 address _recipient,
875                 uint _amount
876         ) external onlyClient onlyDao returns(bool) {
877 
878                 if (_recipient.send(_amount)) return true;
879                 else return false;
880 
881         }
882 
883         function withdraw(uint _amount) onlyContractor {
884                 if (!recipient.send(_amount)) throw;
885                 Withdawal(recipient, _amount);
886         }
887 
888         function numberOfProposals() constant returns(uint) {
889                 return proposals.length - 1;
890         }
891 
892 }
893 
894 
895 pragma solidity ^ 0.4 .6;
896 
897 /*
898 This file is part of Pass DAO.
899 
900 Pass DAO is free software: you can redistribute it and/or modify
901 it under the terms of the GNU lesser General Public License as published by
902 the Free Software Foundation, either version 3 of the License, or
903 (at your option) any later version.
904 
905 Pass DAO is distributed in the hope that it will be useful,
906 but WITHOUT ANY WARRANTY; without even the implied warranty of
907 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
908 GNU lesser General Public License for more details.
909 
910 You should have received a copy of the GNU lesser General Public License
911 along with Pass DAO.  If not, see <http://www.gnu.org/licenses></http:>.
912 */
913 
914 /*
915 Smart contract for a Decentralized Autonomous Organization (DAO)
916 to automate organizational governance and decision-making.
917 */
918 
919 /// @title Pass Decentralized Autonomous Organisation
920 contract PassDaoInterface {
921 
922         struct BoardMeeting {
923                 // Address of the creator of the board meeting for a proposal
924                 address creator;
925                 // Index to identify the proposal to pay a contractor or fund the Dao
926                 uint proposalID;
927                 // Index to identify the proposal to update the Dao rules 
928                 uint daoRulesProposalID;
929                 // unix timestamp, denoting the end of the set period of a proposal before the board meeting 
930                 uint setDeadline;
931                 // Fees (in wei) paid by the creator of the board meeting
932                 uint fees;
933                 // Total of fees (in wei) rewarded to the voters or to the Dao account manager for the balance
934                 uint totalRewardedAmount;
935                 // A unix timestamp, denoting the end of the voting period
936                 uint votingDeadline;
937                 // True if the proposal's votes have yet to be counted, otherwise False
938                 bool open;
939                 // A unix timestamp, denoting the date of the execution of the approved proposal
940                 uint dateOfExecution;
941                 // Number of shares in favor of the proposal
942                 uint yea;
943                 // Number of shares opposed to the proposal
944                 uint nay;
945                 // mapping to indicate if a shareholder has voted
946                 mapping(address => bool) hasVoted;
947         }
948 
949         struct Contractor {
950                 // The address of the contractor manager smart contract
951                 address contractorManager;
952                 // The date of the first order for the contractor
953                 uint creationDate;
954         }
955 
956         struct Proposal {
957                 // Index to identify the board meeting of the proposal
958                 uint boardMeetingID;
959                 // The contractor manager smart contract
960                 PassManager contractorManager;
961                 // The index of the contractor proposal
962                 uint contractorProposalID;
963                 // The amount (in wei) of the proposal
964                 uint amount;
965                 // True if the proposal foresees a contractor token creation
966                 bool tokenCreation;
967                 // True if public funding without a main partner
968                 bool publicShareCreation;
969                 // The address which sets partners and manages the funding in case of private funding
970                 address mainPartner;
971                 // The initial price multiplier of Dao shares at the beginning of the funding
972                 uint initialSharePriceMultiplier;
973                 // The inflation rate to calculate the actual contractor share price
974                 uint inflationRate;
975                 // A unix timestamp, denoting the start time of the funding
976                 uint minutesFundingPeriod;
977                 // True if the proposal is closed
978                 bool open;
979         }
980 
981         struct Rules {
982                 // Index to identify the board meeting that decides to apply or not the Dao rules
983                 uint boardMeetingID;
984                 // The quorum needed for each proposal is calculated by totalSupply / minQuorumDivisor
985                 uint minQuorumDivisor;
986                 // Minimum fees (in wei) to create a proposal
987                 uint minBoardMeetingFees;
988                 // Period in minutes to consider or set a proposal before the voting procedure
989                 uint minutesSetProposalPeriod;
990                 // The minimum debate period in minutes that a generic proposal can have
991                 uint minMinutesDebatePeriod;
992                 // The inflation rate to calculate the reward of fees to voters during a board meeting 
993                 uint feesRewardInflationRate;
994                 // True if the dao rules allow the transfer of shares
995                 bool transferable;
996                 // Address of the effective Dao smart contract (can be different of this Dao in case of upgrade)
997                 address dao;
998         }
999 
1000         // The creator of the Dao
1001         address public creator;
1002         // The name of the project
1003         string public projectName;
1004         // The address of the last Dao before upgrade (not mandatory)
1005         address public lastDao;
1006         // End date of the setup procedure
1007         uint public smartContractStartDate;
1008         // The Dao manager smart contract
1009         PassManager public daoManager;
1010         // The minimum periods in minutes 
1011         uint public minMinutesPeriods;
1012         // The maximum period in minutes for proposals (set+debate)
1013         uint public maxMinutesProposalPeriod;
1014         // The maximum funding period in minutes for funding proposals
1015         uint public maxMinutesFundingPeriod;
1016         // The maximum inflation rate for share price or rewards to voters
1017         uint public maxInflationRate;
1018 
1019         // Map to allow the share holders to withdraw board meeting fees
1020         mapping(address => uint) pendingFees;
1021 
1022         // Board meetings to vote for or against a proposal
1023         BoardMeeting[] public BoardMeetings;
1024         // Contractors of the Dao
1025         Contractor[] public Contractors;
1026         // Map with the indexes of the contractors
1027         mapping(address => uint) contractorID;
1028         // Proposals to pay a contractor or fund the Dao
1029         Proposal[] public Proposals;
1030         // Proposals to update the Dao rules
1031         Rules[] public DaoRulesProposals;
1032         // The current Dao rules
1033         Rules public DaoRules;
1034 
1035         /// @dev The constructor function
1036         /// @param _projectName The name of the Dao
1037         /// @param _lastDao The address of the last Dao before upgrade (not mandatory)
1038         //function PassDao(
1039         //    string _projectName,
1040         //    address _lastDao);
1041 
1042         /// @dev Internal function to add a new contractor
1043         /// @param _contractorManager The address of the contractor manager
1044         /// @param _creationDate The date of the first order
1045         function addContractor(address _contractorManager, uint _creationDate) internal;
1046 
1047         /// @dev Function to clone a contractor from the last Dao in case of upgrade 
1048         /// @param _contractorManager The address of the contractor manager
1049         /// @param _creationDate The date of the first order
1050         function cloneContractor(address _contractorManager, uint _creationDate);
1051 
1052         /// @notice Function to update the client of the contractor managers in case of upgrade
1053         /// @param _from The index of the first contractor manager to update
1054         /// @param _to The index of the last contractor manager to update
1055         function updateClientOfContractorManagers(
1056                 uint _from,
1057                 uint _to);
1058 
1059         /// @dev Function to initialize the Dao
1060         /// @param _daoManager Address of the Dao manager smart contract
1061         /// @param _maxInflationRate The maximum inflation rate for contractor and funding proposals
1062         /// @param _minMinutesPeriods The minimum periods in minutes
1063         /// @param _maxMinutesFundingPeriod The maximum funding period in minutes for funding proposals
1064         /// @param _maxMinutesProposalPeriod The maximum period in minutes for proposals (set+debate)
1065         /// @param _minQuorumDivisor The initial minimum quorum divisor for the proposals
1066         /// @param _minBoardMeetingFees The amount (in wei) to make a proposal and ask for a board meeting
1067         /// @param _minutesSetProposalPeriod The minimum period in minutes before a board meeting
1068         /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
1069         /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a board meeting
1070         function initDao(
1071                 address _daoManager,
1072                 uint _maxInflationRate,
1073                 uint _minMinutesPeriods,
1074                 uint _maxMinutesFundingPeriod,
1075                 uint _maxMinutesProposalPeriod,
1076                 uint _minQuorumDivisor,
1077                 uint _minBoardMeetingFees,
1078                 uint _minutesSetProposalPeriod,
1079                 uint _minMinutesDebatePeriod,
1080                 uint _feesRewardInflationRate
1081         );
1082 
1083         /// @dev Internal function to create a board meeting
1084         /// @param _proposalID The index of the proposal if for a contractor or for a funding
1085         /// @param _daoRulesProposalID The index of the proposal if Dao rules
1086         /// @param _minutesDebatingPeriod The duration in minutes of the meeting
1087         /// @return the index of the board meeting
1088         function newBoardMeeting(
1089                 uint _proposalID,
1090                 uint _daoRulesProposalID,
1091                 uint _minutesDebatingPeriod
1092         ) internal returns(uint);
1093 
1094         /// @notice Function to make a proposal to pay a contractor or fund the Dao
1095         /// @param _contractorManager Address of the contractor manager smart contract
1096         /// @param _contractorProposalID Index of the contractor proposal of the contractor manager
1097         /// @param _amount The amount (in wei) of the proposal
1098         /// @param _tokenCreation True if the proposal foresees a contractor token creation
1099         /// @param _publicShareCreation True if public funding without a main partner
1100         /// @param _mainPartner The address which sets partners and manage the funding 
1101         /// in case of private funding (not mandatory)
1102         /// @param _initialSharePriceMultiplier The initial price multiplier of shares
1103         /// @param _inflationRate If 0, the share price doesn't change during the funding (not mandatory)
1104         /// @param _minutesFundingPeriod Period in minutes of the funding
1105         /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
1106         /// @return The index of the proposal
1107         function newProposal(
1108                 address _contractorManager,
1109                 uint _contractorProposalID,
1110                 uint _amount,
1111                 bool _publicShareCreation,
1112                 bool _tokenCreation,
1113                 address _mainPartner,
1114                 uint _initialSharePriceMultiplier,
1115                 uint _inflationRate,
1116                 uint _minutesFundingPeriod,
1117                 uint _minutesDebatingPeriod
1118         ) payable returns(uint);
1119 
1120         /// @notice Function to make a proposal to change the Dao rules 
1121         /// @param _minQuorumDivisor If 5, the minimum quorum is 20%
1122         /// @param _minBoardMeetingFees The amount (in wei) to make a proposal and ask for a board meeting
1123         /// @param _minutesSetProposalPeriod Minimum period in minutes before a board meeting
1124         /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
1125         /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a board meeting
1126         /// @param _transferable True if the proposal foresees to allow the transfer of Dao shares
1127         /// @param _dao Address of a new Dao smart contract in case of upgrade (not mandatory)    
1128         /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
1129         function newDaoRulesProposal(
1130                 uint _minQuorumDivisor,
1131                 uint _minBoardMeetingFees,
1132                 uint _minutesSetProposalPeriod,
1133                 uint _minMinutesDebatePeriod,
1134                 uint _feesRewardInflationRate,
1135                 bool _transferable,
1136                 address _dao,
1137                 uint _minutesDebatingPeriod
1138         ) payable returns(uint);
1139 
1140         /// @notice Function to vote during a board meeting
1141         /// @param _boardMeetingID The index of the board meeting
1142         /// @param _supportsProposal True if the proposal is supported
1143         function vote(
1144                 uint _boardMeetingID,
1145                 bool _supportsProposal
1146         );
1147 
1148         /// @notice Function to execute a board meeting decision and close the board meeting
1149         /// @param _boardMeetingID The index of the board meeting
1150         /// @return Whether the proposal was executed or not
1151         function executeDecision(uint _boardMeetingID) returns(bool);
1152 
1153         /// @notice Function to order a contractor proposal
1154         /// @param _proposalID The index of the proposal
1155         /// @return Whether the proposal was ordered and the proposal amount sent or not
1156         function orderContractorProposal(uint _proposalID) returns(bool);
1157 
1158         /// @notice Function to withdraw the rewarded board meeting fees
1159         /// @return Whether the withdraw was successful or not    
1160         function withdrawBoardMeetingFees() returns(bool);
1161 
1162         /// @param _shareHolder Address of the shareholder
1163         /// @return The amount in wei the shareholder can withdraw    
1164         function PendingFees(address _shareHolder) constant returns(uint);
1165 
1166         /// @return The minimum quorum for proposals to pass 
1167         function minQuorum() constant returns(uint);
1168 
1169         /// @return The number of contractors 
1170         function numberOfContractors() constant returns(uint);
1171 
1172         /// @return The number of board meetings (or proposals) 
1173         function numberOfBoardMeetings() constant returns(uint);
1174 
1175         event ContractorProposalAdded(uint indexed ProposalID, uint boardMeetingID, address indexed ContractorManager,
1176                 uint indexed ContractorProposalID, uint amount);
1177         event FundingProposalAdded(uint indexed ProposalID, uint boardMeetingID, bool indexed LinkedToContractorProposal,
1178                 uint amount, address MainPartner, uint InitialSharePriceMultiplier, uint InflationRate, uint MinutesFundingPeriod);
1179         event DaoRulesProposalAdded(uint indexed DaoRulesProposalID, uint boardMeetingID, uint MinQuorumDivisor,
1180                 uint MinBoardMeetingFees, uint MinutesSetProposalPeriod, uint MinMinutesDebatePeriod, uint FeesRewardInflationRate,
1181                 bool Transferable, address NewDao);
1182         event Voted(uint indexed boardMeetingID, uint ProposalID, uint DaoRulesProposalID, bool position, address indexed voter);
1183         event ProposalClosed(uint indexed ProposalID, uint indexed DaoRulesProposalID, uint boardMeetingID,
1184                 uint FeesGivenBack, bool ProposalExecuted, uint BalanceSentToDaoManager);
1185         event SentToContractor(uint indexed ProposalID, uint indexed ContractorProposalID, address indexed ContractorManagerAddress, uint AmountSent);
1186         event Withdrawal(address indexed Recipient, uint Amount);
1187         event DaoUpgraded(address NewDao);
1188 
1189 }
1190 
1191 contract PassDao is PassDaoInterface {
1192 
1193         function PassDao(
1194                 string _projectName,
1195                 address _lastDao) {
1196 
1197                 lastDao = _lastDao;
1198                 creator = msg.sender;
1199                 projectName = _projectName;
1200 
1201                 Contractors.length = 1;
1202                 BoardMeetings.length = 1;
1203                 Proposals.length = 1;
1204                 DaoRulesProposals.length = 1;
1205 
1206         }
1207 
1208         function addContractor(address _contractorManager, uint _creationDate) internal {
1209 
1210                 if (contractorID[_contractorManager] == 0) {
1211 
1212                         uint _contractorID = Contractors.length++;
1213                         Contractor c = Contractors[_contractorID];
1214 
1215                         contractorID[_contractorManager] = _contractorID;
1216                         c.contractorManager = _contractorManager;
1217                         c.creationDate = _creationDate;
1218                 }
1219 
1220         }
1221 
1222         function cloneContractor(address _contractorManager, uint _creationDate) {
1223 
1224                 if (DaoRules.minQuorumDivisor != 0) throw;
1225 
1226                 addContractor(_contractorManager, _creationDate);
1227 
1228         }
1229 
1230         function initDao(
1231                 address _daoManager,
1232                 uint _maxInflationRate,
1233                 uint _minMinutesPeriods,
1234                 uint _maxMinutesFundingPeriod,
1235                 uint _maxMinutesProposalPeriod,
1236                 uint _minQuorumDivisor,
1237                 uint _minBoardMeetingFees,
1238                 uint _minutesSetProposalPeriod,
1239                 uint _minMinutesDebatePeriod,
1240                 uint _feesRewardInflationRate
1241         ) {
1242 
1243 
1244                 if (smartContractStartDate != 0) throw;
1245 
1246                 maxInflationRate = _maxInflationRate;
1247                 minMinutesPeriods = _minMinutesPeriods;
1248                 maxMinutesFundingPeriod = _maxMinutesFundingPeriod;
1249                 maxMinutesProposalPeriod = _maxMinutesProposalPeriod;
1250 
1251                 DaoRules.minQuorumDivisor = _minQuorumDivisor;
1252                 DaoRules.minBoardMeetingFees = _minBoardMeetingFees;
1253                 DaoRules.minutesSetProposalPeriod = _minutesSetProposalPeriod;
1254                 DaoRules.minMinutesDebatePeriod = _minMinutesDebatePeriod;
1255                 DaoRules.feesRewardInflationRate = _feesRewardInflationRate;
1256                 daoManager = PassManager(_daoManager);
1257 
1258                 smartContractStartDate = now;
1259 
1260         }
1261 
1262         function updateClientOfContractorManagers(
1263                 uint _from,
1264                 uint _to) {
1265 
1266                 if (_from < 1 || _to > Contractors.length - 1) throw;
1267 
1268                 for (uint i = _from; i <= _to; i++) {
1269                         PassManager(Contractors[i].contractorManager).updateClient(DaoRules.dao);
1270                 }
1271 
1272         }
1273 
1274         function newBoardMeeting(
1275                 uint _proposalID,
1276                 uint _daoRulesProposalID,
1277                 uint _minutesDebatingPeriod
1278         ) internal returns(uint) {
1279 
1280                 if (msg.value < DaoRules.minBoardMeetingFees || DaoRules.minutesSetProposalPeriod + _minutesDebatingPeriod > maxMinutesProposalPeriod || now + ((DaoRules.minutesSetProposalPeriod + _minutesDebatingPeriod) * 1 minutes) < now || _minutesDebatingPeriod < DaoRules.minMinutesDebatePeriod || msg.sender == address(this)) throw;
1281 
1282                 uint _boardMeetingID = BoardMeetings.length++;
1283                 BoardMeeting b = BoardMeetings[_boardMeetingID];
1284 
1285                 b.creator = msg.sender;
1286 
1287                 b.proposalID = _proposalID;
1288                 b.daoRulesProposalID = _daoRulesProposalID;
1289 
1290                 b.fees = msg.value;
1291 
1292                 b.setDeadline = now + (DaoRules.minutesSetProposalPeriod * 1 minutes);
1293                 b.votingDeadline = b.setDeadline + (_minutesDebatingPeriod * 1 minutes);
1294 
1295                 b.open = true;
1296 
1297                 return _boardMeetingID;
1298 
1299         }
1300 
1301         function newProposal(
1302                 address _contractorManager,
1303                 uint _contractorProposalID,
1304                 uint _amount,
1305                 bool _tokenCreation,
1306                 bool _publicShareCreation,
1307                 address _mainPartner,
1308                 uint _initialSharePriceMultiplier,
1309                 uint _inflationRate,
1310                 uint _minutesFundingPeriod,
1311                 uint _minutesDebatingPeriod
1312         ) payable returns(uint) {
1313 
1314                 if ((_contractorManager != 0 && _contractorProposalID == 0) || (_contractorManager == 0 && (_initialSharePriceMultiplier == 0 || _contractorProposalID != 0) || (_tokenCreation && _publicShareCreation) || (_initialSharePriceMultiplier != 0 && (_minutesFundingPeriod < minMinutesPeriods || _inflationRate > maxInflationRate || _minutesFundingPeriod > maxMinutesFundingPeriod)))) throw;
1315 
1316                 uint _proposalID = Proposals.length++;
1317                 Proposal p = Proposals[_proposalID];
1318 
1319                 p.contractorManager = PassManager(_contractorManager);
1320                 p.contractorProposalID = _contractorProposalID;
1321 
1322                 p.amount = _amount;
1323                 p.tokenCreation = _tokenCreation;
1324 
1325                 p.publicShareCreation = _publicShareCreation;
1326                 p.mainPartner = _mainPartner;
1327                 p.initialSharePriceMultiplier = _initialSharePriceMultiplier;
1328                 p.inflationRate = _inflationRate;
1329                 p.minutesFundingPeriod = _minutesFundingPeriod;
1330 
1331                 p.boardMeetingID = newBoardMeeting(_proposalID, 0, _minutesDebatingPeriod);
1332 
1333                 p.open = true;
1334 
1335                 if (_contractorProposalID != 0) {
1336                         ContractorProposalAdded(_proposalID, p.boardMeetingID, p.contractorManager, p.contractorProposalID, p.amount);
1337                         if (_initialSharePriceMultiplier != 0) {
1338                                 FundingProposalAdded(_proposalID, p.boardMeetingID, true, p.amount, p.mainPartner,
1339                                         p.initialSharePriceMultiplier, _inflationRate, _minutesFundingPeriod);
1340                         }
1341                 } else if (_initialSharePriceMultiplier != 0) {
1342                         FundingProposalAdded(_proposalID, p.boardMeetingID, false, p.amount, p.mainPartner,
1343                                 p.initialSharePriceMultiplier, _inflationRate, _minutesFundingPeriod);
1344                 }
1345 
1346                 return _proposalID;
1347 
1348         }
1349 
1350         function newDaoRulesProposal(
1351                 uint _minQuorumDivisor,
1352                 uint _minBoardMeetingFees,
1353                 uint _minutesSetProposalPeriod,
1354                 uint _minMinutesDebatePeriod,
1355                 uint _feesRewardInflationRate,
1356                 bool _transferable,
1357                 address _newDao,
1358                 uint _minutesDebatingPeriod
1359         ) payable returns(uint) {
1360 
1361                 if (_minQuorumDivisor <= 1 || _minQuorumDivisor > 10 || _minutesSetProposalPeriod < minMinutesPeriods || _minMinutesDebatePeriod < minMinutesPeriods || _minutesSetProposalPeriod + _minMinutesDebatePeriod > maxMinutesProposalPeriod || _feesRewardInflationRate > maxInflationRate) throw;
1362 
1363                 uint _DaoRulesProposalID = DaoRulesProposals.length++;
1364                 Rules r = DaoRulesProposals[_DaoRulesProposalID];
1365 
1366                 r.minQuorumDivisor = _minQuorumDivisor;
1367                 r.minBoardMeetingFees = _minBoardMeetingFees;
1368                 r.minutesSetProposalPeriod = _minutesSetProposalPeriod;
1369                 r.minMinutesDebatePeriod = _minMinutesDebatePeriod;
1370                 r.feesRewardInflationRate = _feesRewardInflationRate;
1371                 r.transferable = _transferable;
1372                 r.dao = _newDao;
1373 
1374                 r.boardMeetingID = newBoardMeeting(0, _DaoRulesProposalID, _minutesDebatingPeriod);
1375 
1376                 DaoRulesProposalAdded(_DaoRulesProposalID, r.boardMeetingID, _minQuorumDivisor, _minBoardMeetingFees,
1377                         _minutesSetProposalPeriod, _minMinutesDebatePeriod, _feesRewardInflationRate, _transferable, _newDao);
1378 
1379                 return _DaoRulesProposalID;
1380 
1381         }
1382 
1383         function vote(
1384                 uint _boardMeetingID,
1385                 bool _supportsProposal
1386         ) {
1387 
1388                 BoardMeeting b = BoardMeetings[_boardMeetingID];
1389 
1390                 if (b.hasVoted[msg.sender] || now < b.setDeadline || now > b.votingDeadline) throw;
1391 
1392                 uint _balance = uint(daoManager.balanceOf(msg.sender));
1393                 if (_balance == 0) throw;
1394 
1395                 b.hasVoted[msg.sender] = true;
1396 
1397                 if (_supportsProposal) b.yea += _balance;
1398                 else b.nay += _balance;
1399 
1400                 if (b.fees > 0 && b.proposalID != 0 && Proposals[b.proposalID].contractorProposalID != 0) {
1401 
1402                         uint _a = 100 * b.fees;
1403                         if ((_a / 100 != b.fees) || ((_a * _balance) / _a != _balance)) throw;
1404                         uint _multiplier = (_a * _balance) / uint(daoManager.totalSupply());
1405 
1406                         uint _divisor = 100 + 100 * DaoRules.feesRewardInflationRate * (now - b.setDeadline) / (100 * 365 days);
1407 
1408                         uint _rewardedamount = _multiplier / _divisor;
1409 
1410                         if (b.totalRewardedAmount + _rewardedamount > b.fees) _rewardedamount = b.fees - b.totalRewardedAmount;
1411                         b.totalRewardedAmount += _rewardedamount;
1412                         pendingFees[msg.sender] += _rewardedamount;
1413                 }
1414 
1415                 Voted(_boardMeetingID, b.proposalID, b.daoRulesProposalID, _supportsProposal, msg.sender);
1416 
1417                 daoManager.blockTransfer(msg.sender, b.votingDeadline);
1418 
1419         }
1420 
1421         function executeDecision(uint _boardMeetingID) returns(bool) {
1422 
1423                 BoardMeeting b = BoardMeetings[_boardMeetingID];
1424                 Proposal p = Proposals[b.proposalID];
1425 
1426                 if (now < b.votingDeadline || !b.open) throw;
1427 
1428                 b.open = false;
1429                 if (p.contractorProposalID == 0) p.open = false;
1430 
1431                 uint _fees;
1432                 uint _minQuorum = minQuorum();
1433 
1434                 if (b.fees > 0 && (b.proposalID == 0 || p.contractorProposalID == 0) && b.yea + b.nay >= _minQuorum) {
1435                         _fees = b.fees;
1436                         b.fees = 0;
1437                         pendingFees[b.creator] += _fees;
1438                 }
1439 
1440                 uint _balance = b.fees - b.totalRewardedAmount;
1441                 if (_balance > 0) {
1442                         if (!daoManager.send(_balance)) throw;
1443                 }
1444 
1445                 if (b.yea + b.nay < _minQuorum || b.yea <= b.nay) {
1446                         p.open = false;
1447                         ProposalClosed(b.proposalID, b.daoRulesProposalID, _boardMeetingID, _fees, false, _balance);
1448                         return;
1449                 }
1450 
1451                 b.dateOfExecution = now;
1452 
1453                 if (b.proposalID != 0) {
1454 
1455                         if (p.initialSharePriceMultiplier != 0) {
1456 
1457                                 daoManager.setFundingRules(p.mainPartner, p.publicShareCreation, p.initialSharePriceMultiplier,
1458                                         p.amount, p.minutesFundingPeriod, p.inflationRate, b.proposalID);
1459 
1460                                 if (p.contractorProposalID != 0 && p.tokenCreation) {
1461                                         p.contractorManager.setFundingRules(p.mainPartner, p.publicShareCreation, 0,
1462                                                 p.amount, p.minutesFundingPeriod, maxInflationRate, b.proposalID);
1463                                 }
1464 
1465                         }
1466 
1467                 } else {
1468 
1469                         Rules r = DaoRulesProposals[b.daoRulesProposalID];
1470                         DaoRules.boardMeetingID = r.boardMeetingID;
1471 
1472                         DaoRules.minQuorumDivisor = r.minQuorumDivisor;
1473                         DaoRules.minMinutesDebatePeriod = r.minMinutesDebatePeriod;
1474                         DaoRules.minBoardMeetingFees = r.minBoardMeetingFees;
1475                         DaoRules.minutesSetProposalPeriod = r.minutesSetProposalPeriod;
1476                         DaoRules.feesRewardInflationRate = r.feesRewardInflationRate;
1477 
1478                         DaoRules.transferable = r.transferable;
1479                         if (r.transferable) daoManager.ableTransfer();
1480                         else daoManager.disableTransfer();
1481 
1482                         if ((r.dao != 0) && (r.dao != address(this))) {
1483                                 DaoRules.dao = r.dao;
1484                                 daoManager.updateClient(r.dao);
1485                                 DaoUpgraded(r.dao);
1486                         }
1487 
1488                 }
1489 
1490                 ProposalClosed(b.proposalID, b.daoRulesProposalID, _boardMeetingID, _fees, true, _balance);
1491 
1492                 return true;
1493 
1494         }
1495 
1496         function orderContractorProposal(uint _proposalID) returns(bool) {
1497 
1498                 Proposal p = Proposals[_proposalID];
1499                 BoardMeeting b = BoardMeetings[p.boardMeetingID];
1500 
1501                 if (b.open || !p.open) throw;
1502 
1503                 uint _amount = p.amount;
1504 
1505                 if (p.initialSharePriceMultiplier != 0) {
1506                         _amount = daoManager.FundedAmount(_proposalID);
1507                         if (_amount == 0 && now < b.dateOfExecution + (p.minutesFundingPeriod * 1 minutes)) return;
1508                 }
1509 
1510                 p.open = false;
1511 
1512                 if (_amount == 0 || !p.contractorManager.order(_proposalID, p.contractorProposalID, _amount)) return;
1513 
1514                 if (!daoManager.sendTo(p.contractorManager, _amount)) throw;
1515                 SentToContractor(_proposalID, p.contractorProposalID, address(p.contractorManager), _amount);
1516 
1517                 addContractor(address(p.contractorManager), now);
1518 
1519                 return true;
1520 
1521         }
1522 
1523         function withdrawBoardMeetingFees() returns(bool) {
1524 
1525                 uint _amount = pendingFees[msg.sender];
1526 
1527                 pendingFees[msg.sender] = 0;
1528 
1529                 if (msg.sender.send(_amount)) {
1530                         Withdrawal(msg.sender, _amount);
1531                         return true;
1532                 } else {
1533                         pendingFees[msg.sender] = _amount;
1534                         return false;
1535                 }
1536 
1537         }
1538 
1539         function PendingFees(address _shareHolder) constant returns(uint) {
1540                 return (pendingFees[_shareHolder]);
1541         }
1542 
1543         function minQuorum() constant returns(uint) {
1544                 return (uint(daoManager.totalSupply()) / DaoRules.minQuorumDivisor);
1545         }
1546 
1547         function numberOfContractors() constant returns(uint) {
1548                 return Contractors.length - 1;
1549         }
1550 
1551         function numberOfBoardMeetings() constant returns(uint) {
1552                 return BoardMeetings.length - 1;
1553         }
1554 
1555 }