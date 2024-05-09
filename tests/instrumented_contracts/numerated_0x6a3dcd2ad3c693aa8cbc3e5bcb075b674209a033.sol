1 pragma solidity ^0.4.8;
2 
3 /*
4 This file is part of Pass DAO.
5 
6 Pass DAO is free software: you can redistribute it and/or modify
7 it under the terms of the GNU lesser General Public License as published by
8 the Free Software Foundation, either version 3 of the License, or
9 (at your option) any later version.
10 
11 Pass DAO is distributed in the hope that it will be useful,
12 but WITHOUT ANY WARRANTY; without even the implied warranty of
13 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 GNU lesser General Public License for more details.
15 
16 You should have received a copy of the GNU lesser General Public License
17 along with Pass DAO.  If not, see <http://www.gnu.org/licenses/>.
18 */
19 
20 /*
21 Smart contract for a Decentralized Autonomous Organization (DAO)
22 to automate organizational governance and decision-making.
23 */
24 
25 /// @title Pass Dao smart contract
26 contract PassDao {
27     
28     struct revision {
29         // Address of the Committee Room smart contract
30         address committeeRoom;
31         // Address of the share manager smart contract
32         address shareManager;
33         // Address of the token manager smart contract
34         address tokenManager;
35         // Address of the project creator smart contract
36         uint startDate;
37     }
38     // The revisions of the application until today
39     revision[] public revisions;
40 
41     struct project {
42         // The address of the smart contract
43         address contractAddress;
44         // The unix effective start date of the contract
45         uint startDate;
46     }
47     // The projects of the Dao
48     project[] public projects;
49 
50     // Map with the indexes of the projects
51     mapping (address => uint) projectID;
52     
53     // The address of the meta project
54     address metaProject;
55 
56     
57 // Events
58 
59     event Upgrade(uint indexed RevisionID, address CommitteeRoom, address ShareManager, address TokenManager);
60     event NewProject(address Project);
61 
62 // Constant functions  
63     
64     /// @return The effective committee room
65     function ActualCommitteeRoom() constant returns (address) {
66         return revisions[0].committeeRoom;
67     }
68     
69     /// @return The meta project
70     function MetaProject() constant returns (address) {
71         return metaProject;
72     }
73 
74     /// @return The effective share manager
75     function ActualShareManager() constant returns (address) {
76         return revisions[0].shareManager;
77     }
78 
79     /// @return The effective token manager
80     function ActualTokenManager() constant returns (address) {
81         return revisions[0].tokenManager;
82     }
83 
84 // modifiers
85 
86     modifier onlyPassCommitteeRoom {if (msg.sender != revisions[0].committeeRoom  
87         && revisions[0].committeeRoom != 0) throw; _;}
88     
89 // Constructor function
90 
91     function PassDao() {
92         projects.length = 1;
93         revisions.length = 1;
94     }
95     
96 // Register functions
97 
98     /// @dev Function to allow the actual Committee Room upgrading the application
99     /// @param _newCommitteeRoom The address of the new committee room
100     /// @param _newShareManager The address of the new share manager
101     /// @param _newTokenManager The address of the new token manager
102     /// @return The index of the revision
103     function upgrade(
104         address _newCommitteeRoom, 
105         address _newShareManager, 
106         address _newTokenManager) onlyPassCommitteeRoom returns (uint) {
107         
108         uint _revisionID = revisions.length++;
109         revision r = revisions[_revisionID];
110 
111         if (_newCommitteeRoom != 0) r.committeeRoom = _newCommitteeRoom; else r.committeeRoom = revisions[0].committeeRoom;
112         if (_newShareManager != 0) r.shareManager = _newShareManager; else r.shareManager = revisions[0].shareManager;
113         if (_newTokenManager != 0) r.tokenManager = _newTokenManager; else r.tokenManager = revisions[0].tokenManager;
114 
115         r.startDate = now;
116         
117         revisions[0] = r;
118         
119         Upgrade(_revisionID, _newCommitteeRoom, _newShareManager, _newTokenManager);
120             
121         return _revisionID;
122     }
123 
124     /// @dev Function to set the meta project
125     /// @param _projectAddress The address of the meta project
126     function addMetaProject(address _projectAddress) onlyPassCommitteeRoom {
127 
128         metaProject = _projectAddress;
129     }
130     
131     /// @dev Function to allow the committee room to add a project when ordering
132     /// @param _projectAddress The address of the project
133     function addProject(address _projectAddress) onlyPassCommitteeRoom {
134 
135         if (projectID[_projectAddress] == 0) {
136 
137             uint _projectID = projects.length++;
138             project p = projects[_projectID];
139         
140             projectID[_projectAddress] = _projectID;
141             p.contractAddress = _projectAddress; 
142             p.startDate = now;
143             
144             NewProject(_projectAddress);
145         }
146     }
147     
148 }
149 
150 pragma solidity ^0.4.8;
151 
152 /*
153  *
154  * This file is part of Pass DAO.
155  *
156  * The Manager smart contract is used for the management of shares and tokens.
157  *
158 */
159 
160 /// @title Token Manager smart contract of the Pass Decentralized Autonomous Organisation
161 contract PassTokenManagerInterface {
162 
163     // The Pass Dao smart contract
164     PassDao public passDao;
165     // The adress of the creator of this smart contract
166     address creator;
167     
168     // The token name for display purpose
169     string public name;
170     // The token symbol for display purpose
171     string public symbol;
172     // The quantity of decimals for display purpose
173     uint8 public decimals;
174     // Total amount of tokens
175     uint256 totalTokenSupply;
176 
177     // True if tokens, false if Dao shares
178     bool token;
179     // If true, the shares or tokens can be transferred
180     bool transferable;
181 
182     // The address of the last Manager before cloning
183     address public clonedFrom;
184     // True if the initial token supply is over
185     bool initialTokenSupplyDone;
186 
187     // Array of token or share holders (used for cloning)
188     address[] holders;
189     // Map with the indexes of the holders (used for cloning)
190     mapping (address => uint) holderID;
191     
192     // Array with all balances
193     mapping (address => uint256) balances;
194     // Array with all allowances
195     mapping (address => mapping (address => uint256)) allowed;
196 
197     struct funding {
198         // The address which sets partners and manages the funding (not mandatory)
199         address moderator;
200         // The amount (in wei) of the funding
201         uint amountToFund;
202         // The funded amount (in wei)
203         uint fundedAmount;
204         // A unix timestamp, denoting the start time of the funding
205         uint startTime; 
206         // A unix timestamp, denoting the closing time of the funding
207         uint closingTime;  
208         // The price multiplier for a share or a token without considering the inflation rate
209         uint initialPriceMultiplier;
210         // Rate per year in percentage applied to the share or token price 
211         uint inflationRate; 
212         // The total amount of wei given
213         uint totalWeiGiven;
214     } 
215     // Map with the fundings rules for each Dao proposal
216     mapping (uint => funding) public fundings;
217 
218     // The index of the last funding and proposal
219     uint lastProposalID;
220     // The index of the last fueled funding and proposal
221     uint public lastFueledFundingID;
222     
223     struct amountsGiven {
224         uint weiAmount;
225         uint tokenAmount;
226     }
227     // Map with the amounts given for each proposal 
228     mapping (uint => mapping (address => amountsGiven)) public Given;
229     
230     // Map of blocked Dao share accounts. Points to the date when the share holder can transfer shares
231     mapping (address => uint) public blockedDeadLine; 
232 
233     // @return The client of this manager
234     function Client() constant returns (address);
235     
236     /// @return The total supply of shares or tokens 
237     function totalSupply() constant external returns (uint256);
238 
239     /// @param _owner The address from which the balance will be retrieved
240     /// @return The balance
241      function balanceOf(address _owner) constant external returns (uint256 balance);
242 
243     /// @return True if tokens can be transferred
244     function Transferable() constant external returns (bool);
245     
246     /// @param _owner The address of the account owning tokens
247     /// @param _spender The address of the account able to transfer the tokens
248     /// @return Quantity of remaining tokens of _owner that _spender is allowed to spend
249     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
250     
251     /// @param _proposalID Index of the funding or proposal
252     /// @return The result (in wei) of the funding
253     function FundedAmount(uint _proposalID) constant external returns (uint);
254 
255     /// @param _proposalID Index of the funding or proposal
256     /// @return The amount to fund
257     function AmountToFund(uint _proposalID) constant external returns (uint);
258     
259     /// @param _proposalID Index of the funding or proposal
260     /// @return the token price multiplier
261     function priceMultiplier(uint _proposalID) constant internal returns (uint);
262     
263     /// @param _proposalID Index of the funding or proposal
264     /// @param _saleDate in case of presale, the date of the presale
265     /// @return the share or token price divisor condidering the sale date and the inflation rate
266     function priceDivisor(
267         uint _proposalID, 
268         uint _saleDate) constant internal returns (uint);
269     
270     /// @param _proposalID Index of the funding or proposal
271     /// @return the actual price divisor of a share or token
272     function actualPriceDivisor(uint _proposalID) constant internal returns (uint);
273 
274     /// @dev Internal function to calculate the amount in tokens according to a price    
275     /// @param _weiAmount The amount (in wei)
276     /// @param _priceMultiplier The price multiplier
277     /// @param _priceDivisor The price divisor
278     /// @return the amount in tokens 
279     function TokenAmount(
280         uint _weiAmount,
281         uint _priceMultiplier, 
282         uint _priceDivisor) constant internal returns (uint);
283 
284     /// @dev Internal function to calculate the amount in wei according to a price    
285     /// @param _tokenAmount The amount (in wei)
286     /// @param _priceMultiplier The price multiplier
287     /// @param _priceDivisor The price divisor
288     /// @return the amount in wei
289     function weiAmount(
290         uint _tokenAmount, 
291         uint _priceMultiplier, 
292         uint _priceDivisor) constant internal returns (uint);
293         
294     /// @param _tokenAmount The amount in tokens
295     /// @param _proposalID Index of the client proposal. 0 if not linked to a proposal.
296     /// @return the actual token price in wei
297     function TokenPriceInWei(uint _tokenAmount, uint _proposalID) constant returns (uint);
298     
299     /// @return The index of the last funding and client's proposal 
300     function LastProposalID() constant returns (uint);
301 
302     /// @return The number of share or token holders (used for cloning)
303     function numberOfHolders() constant returns (uint);
304 
305     /// @param _index The index of the holder
306     /// @return the address of the holder
307     function HolderAddress(uint _index) constant external returns (address);
308    
309     /// @dev The constructor function
310     /// @param _passDao Address of the pass Dao smart contract
311     /// @param _clonedFrom The address of the last Manager before cloning
312     /// @param _tokenName The token name for display purpose
313     /// @param _tokenSymbol The token symbol for display purpose
314     /// @param _tokenDecimals The quantity of decimals for display purpose
315     /// @param  _token True if tokens, false if shares
316     /// @param  _transferable True if tokens can be transferred
317     /// @param _initialPriceMultiplier Price multiplier without considering any inflation rate
318     /// @param _inflationRate If 0, the token price doesn't change during the funding
319     //function PassTokenManager(
320     //    address _passDao,
321     //    address _clonedFrom,
322     //    string _tokenName,
323     //    string _tokenSymbol,
324     //    uint8 _tokenDecimals,
325     //    bool _token,
326     //    bool _transferable,
327     //    uint _initialPriceMultiplier,
328     //    uint _inflationRate);
329     
330     /// @dev Function to create initial tokens    
331     /// @param _recipient The beneficiary of the created tokens
332     /// @param _quantity The quantity of tokens to create    
333     /// @param _last True if the initial token suppy is over
334     /// @return Whether the function was successful or not     
335     function initialTokenSupply(
336         address _recipient, 
337         uint _quantity,
338         bool _last) returns (bool success);
339         
340     /// @notice Function to clone tokens before upgrading
341     /// @param _from The index of the first holder
342     /// @param _to The index of the last holder
343     /// @return Whether the function was successful or not 
344     function cloneTokens(
345         uint _from,
346         uint _to) returns (bool success);
347 
348     /// @dev Internal function to add a new token or share holder
349     /// @param _holder The address of the token or share holder
350     function addHolder(address _holder) internal;
351     
352     /// @dev Internal function to create initial tokens    
353     /// @param _holder The beneficiary of the created tokens
354     /// @param _tokenAmount The amount in tokens to create
355     function createTokens(
356         address _holder, 
357         uint _tokenAmount) internal;
358         
359     /// @notice Function used by the client to pay with shares or tokens
360     /// @param _recipient The address of the recipient of shares or tokens
361     /// @param _amount The amount (in Wei) to calculate the quantity of shares or tokens to create
362     /// @return the rewarded amount in tokens or shares
363     function rewardTokensForClient(
364         address _recipient, 
365         uint _amount) external  returns (uint);
366         
367     /// @notice Function to set a funding
368     /// @param _moderator The address of the smart contract to manage a private funding
369     /// @param _initialPriceMultiplier Price multiplier without considering any inflation rate
370     /// @param _amountToFund The amount (in wei) of the funding
371     /// @param _minutesFundingPeriod Period in minutes of the funding
372     /// @param _inflationRate If 0, the token price doesn't change during the funding
373     /// @param _proposalID Index of the client proposal
374     function setFundingRules(
375         address _moderator,
376         uint _initialPriceMultiplier,
377         uint _amountToFund,
378         uint _minutesFundingPeriod, 
379         uint _inflationRate,
380         uint _proposalID) external;
381 
382     /// @dev Internal function for the sale of shares or tokens
383     /// @param _proposalID Index of the client proposal
384     /// @param _recipient The recipient address of shares or tokens
385     /// @param _amount The funded amount (in wei)
386     /// @param _saleDate In case of presale, the date of the presale
387     /// @param _presale True if presale
388     /// @return Whether the creation was successful or not
389     function sale(
390         uint _proposalID,
391         address _recipient, 
392         uint _amount,
393         uint _saleDate,
394         bool _presale
395     ) internal returns (bool success);
396     
397     /// @dev Internal function to close the actual funding
398     /// @param _proposalID Index of the client proposal
399     function closeFunding(uint _proposalID) internal;
400    
401     /// @notice Function to send tokens or refund after the closing time of the funding proposals
402     /// @param _from The first proposal. 0 if not linked to a proposal
403     /// @param _to The last proposal
404     /// @param _buyer The address of the buyer
405     /// @return Whether the function was successful or not 
406     function sendPendingAmounts(        
407         uint _from,
408         uint _to,
409         address _buyer) returns (bool);
410         
411     /// @notice Function to get fees, shares or refund after the closing time of the funding proposals
412     /// @return Whether the function was successful or not
413     function withdrawPendingAmounts() returns (bool);
414     
415     /// @notice Function used by the main partner to set the start time of the funding
416     /// @param _proposalID Index of the client proposal
417     /// @param _startTime The unix start date of the funding 
418     function setFundingStartTime(
419         uint _proposalID, 
420         uint _startTime) external;
421     
422     /// @notice Function used by the main partner to set the funding fueled
423     /// @param _proposalID Index of the client proposal
424     function setFundingFueled(uint _proposalID) external;
425 
426     /// @notice Function to able the transfer of Dao shares or contractor tokens
427     function ableTransfer();
428 
429     /// @notice Function to disable the transfer of Dao shares
430     function disableTransfer();
431 
432     /// @notice Function used by the client to block the transfer of shares from and to a share holder
433     /// @param _shareHolder The address of the share holder
434     /// @param _deadLine When the account will be unblocked
435     function blockTransfer(
436         address _shareHolder, 
437         uint _deadLine) external;
438     
439     /// @dev Internal function to send `_value` token to `_to` from `_From`
440     /// @param _from The address of the sender
441     /// @param _to The address of the recipient
442     /// @param _value The quantity of shares or tokens to be transferred
443     /// @return Whether the function was successful or not 
444     function transferFromTo(
445         address _from,
446         address _to, 
447         uint256 _value
448         ) internal returns (bool success);
449     
450     /// @notice send `_value` token to `_to` from `msg.sender`
451     /// @param _to The address of the recipient
452     /// @param _value The quantity of shares or tokens to be transferred
453     /// @return Whether the function was successful or not 
454     function transfer(address _to, uint256 _value) returns (bool success);
455 
456     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
457     /// @param _from The address of the sender
458     /// @param _to The address of the recipient
459     /// @param _value The quantity of shares or tokens to be transferred
460     function transferFrom(
461         address _from, 
462         address _to, 
463         uint256 _value
464         ) returns (bool success);
465 
466     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf
467     /// @param _spender The address of the account able to transfer the tokens
468     /// @param _value The amount of tokens to be approved for transfer
469     /// @return Whether the approval was successful or not
470     function approve(
471         address _spender, 
472         uint256 _value) returns (bool success);
473     
474     event TokensCreated(address indexed Sender, address indexed TokenHolder, uint TokenAmount);
475     event FundingRulesSet(address indexed Moderator, uint indexed ProposalId, uint AmountToFund, uint indexed StartTime, uint ClosingTime);
476     event FundingFueled(uint indexed ProposalID, uint FundedAmount);
477     event TransferAble();
478     event TransferDisable();
479     event Transfer(address indexed _from, address indexed _to, uint256 _value);
480     event Refund(address indexed Buyer, uint Amount);
481     
482 }    
483 
484 contract PassTokenManager is PassTokenManagerInterface {
485 
486 // Constant functions
487 
488     function Client() constant returns (address) {
489         return passDao.ActualCommitteeRoom();
490     }
491    
492     function totalSupply() constant external returns (uint256) {
493         return totalTokenSupply;
494     }
495     
496     function balanceOf(address _owner) constant external returns (uint256 balance) {
497         return balances[_owner];
498     }
499      
500     function Transferable() constant external returns (bool) {
501         return transferable;
502     }
503  
504     function allowance(
505         address _owner, 
506         address _spender) constant external returns (uint256 remaining) {
507         return allowed[_owner][_spender];
508     }
509 
510     function FundedAmount(uint _proposalID) constant external returns (uint) {
511         return fundings[_proposalID].fundedAmount;
512     }
513   
514     function AmountToFund(uint _proposalID) constant external returns (uint) {
515 
516         if (now > fundings[_proposalID].closingTime
517             || now < fundings[_proposalID].startTime) {
518             return 0;   
519             } else return fundings[_proposalID].amountToFund;
520     }
521     
522     function priceMultiplier(uint _proposalID) constant internal returns (uint) {
523         return fundings[_proposalID].initialPriceMultiplier;
524     }
525     
526     function priceDivisor(uint _proposalID, uint _saleDate) constant internal returns (uint) {
527         uint _date = _saleDate;
528         
529         if (_saleDate > fundings[_proposalID].closingTime) _date = fundings[_proposalID].closingTime;
530         if (_saleDate < fundings[_proposalID].startTime) _date = fundings[_proposalID].startTime;
531 
532         return 100 + 100*fundings[_proposalID].inflationRate*(_date - fundings[_proposalID].startTime)/(100*365 days);
533     }
534     
535     function actualPriceDivisor(uint _proposalID) constant internal returns (uint) {
536         return priceDivisor(_proposalID, now);
537     }
538     
539     function TokenAmount(
540         uint _weiAmount, 
541         uint _priceMultiplier, 
542         uint _priceDivisor) constant internal returns (uint) {
543         
544         uint _a = _weiAmount*_priceMultiplier;
545         uint _multiplier = 100*_a;
546         uint _amount = _multiplier/_priceDivisor;
547         if (_a/_weiAmount != _priceMultiplier
548             || _multiplier/100 != _a) return 0; 
549         
550         return _amount;
551     }
552     
553     function weiAmount(
554         uint _tokenAmount, 
555         uint _priceMultiplier, 
556         uint _priceDivisor) constant internal returns (uint) {
557         
558         uint _multiplier = _tokenAmount*_priceDivisor;
559         uint _divisor = 100*_priceMultiplier;
560         uint _amount = _multiplier/_divisor;
561         if (_multiplier/_tokenAmount != _priceDivisor
562             || _divisor/100 != _priceMultiplier) return 0; 
563 
564         return _amount;
565     }
566     
567     function TokenPriceInWei(uint _tokenAmount, uint _proposalID) constant returns (uint) {
568         return weiAmount(_tokenAmount, priceMultiplier(_proposalID), actualPriceDivisor(_proposalID));
569     }
570     
571     function LastProposalID() constant returns (uint) {
572         return lastProposalID;
573     }
574     
575     function numberOfHolders() constant returns (uint) {
576         return holders.length - 1;
577     }
578     
579     function HolderAddress(uint _index) constant external returns (address) {
580         return holders[_index];
581     }
582 
583 // Modifiers
584 
585     // Modifier that allows only the client ..
586     modifier onlyClient {if (msg.sender != Client()) throw; _;}
587       
588     // Modifier for share Manager functions
589     modifier onlyShareManager {if (token) throw; _;}
590 
591     // Modifier for token Manager functions
592     modifier onlyTokenManager {if (!token) throw; _;}
593   
594 // Constructor function
595 
596     function PassTokenManager(
597         PassDao _passDao,
598         address _clonedFrom,
599         string _tokenName,
600         string _tokenSymbol,
601         uint8 _tokenDecimals,
602         bool _token,
603         bool _transferable,
604         uint _initialPriceMultiplier,
605         uint _inflationRate) {
606 
607         passDao = _passDao;
608         creator = msg.sender;
609         
610         clonedFrom = _clonedFrom;            
611 
612         name = _tokenName;
613         symbol = _tokenSymbol;
614         decimals = _tokenDecimals;
615 
616         token = _token;
617         transferable = _transferable;
618 
619         fundings[0].initialPriceMultiplier = _initialPriceMultiplier;
620         fundings[0].inflationRate = _inflationRate;
621 
622         holders.length = 1;
623     }
624 
625 // Setting functions
626 
627     function initialTokenSupply(
628         address _recipient, 
629         uint _quantity,
630         bool _last) returns (bool success) {
631 
632         if (initialTokenSupplyDone) throw;
633         
634         addHolder(_recipient);
635         if (_recipient != 0 && _quantity != 0) createTokens(_recipient, _quantity);
636         
637         if (_last) initialTokenSupplyDone = true;
638         
639         return true;
640     }
641 
642     function cloneTokens(
643         uint _from,
644         uint _to) returns (bool success) {
645         
646         initialTokenSupplyDone = true;
647         if (_from == 0) _from = 1;
648         
649         PassTokenManager _clonedFrom = PassTokenManager(clonedFrom);
650         uint _numberOfHolders = _clonedFrom.numberOfHolders();
651         if (_to == 0 || _to > _numberOfHolders) _to = _numberOfHolders;
652         
653         address _holder;
654         uint _balance;
655 
656         for (uint i = _from; i <= _to; i++) {
657             _holder = _clonedFrom.HolderAddress(i);
658             _balance = _clonedFrom.balanceOf(_holder);
659             if (balances[_holder] == 0 && _balance != 0) {
660                 addHolder(_holder);
661                 createTokens(_holder, _balance);
662             }
663         }
664     }
665         
666 // Token creation
667 
668     function addHolder(address _holder) internal {
669         
670         if (holderID[_holder] == 0) {
671             
672             uint _holderID = holders.length++;
673             holders[_holderID] = _holder;
674             holderID[_holder] = _holderID;
675         }
676     }
677 
678     function createTokens(
679         address _holder, 
680         uint _tokenAmount) internal {
681 
682         balances[_holder] += _tokenAmount; 
683         totalTokenSupply += _tokenAmount;
684         TokensCreated(msg.sender, _holder, _tokenAmount);
685     }
686     
687     function rewardTokensForClient(
688         address _recipient, 
689         uint _amount
690         ) external onlyClient returns (uint) {
691 
692         uint _tokenAmount = TokenAmount(_amount, priceMultiplier(0), actualPriceDivisor(0));
693         if (_tokenAmount == 0) throw;
694 
695         addHolder(_recipient);
696         createTokens(_recipient, _tokenAmount);
697 
698         return _tokenAmount;
699     }
700     
701     function setFundingRules(
702         address _moderator,
703         uint _initialPriceMultiplier,
704         uint _amountToFund,
705         uint _minutesFundingPeriod, 
706         uint _inflationRate,
707         uint _proposalID
708     ) external onlyClient {
709 
710         if (_moderator == address(this)
711             || _moderator == Client()
712             || _amountToFund == 0
713             || _minutesFundingPeriod == 0
714             || fundings[_proposalID].totalWeiGiven != 0
715             ) throw;
716             
717         fundings[_proposalID].moderator = _moderator;
718 
719         fundings[_proposalID].amountToFund = _amountToFund;
720         fundings[_proposalID].fundedAmount = 0;
721 
722         if (_initialPriceMultiplier == 0) {
723             if (now < fundings[0].closingTime) {
724                 fundings[_proposalID].initialPriceMultiplier = 100*priceMultiplier(lastProposalID)/actualPriceDivisor(lastProposalID);
725             } else {
726                 fundings[_proposalID].initialPriceMultiplier = 100*priceMultiplier(lastFueledFundingID)/actualPriceDivisor(lastFueledFundingID);
727             }
728             fundings[0].initialPriceMultiplier = fundings[_proposalID].initialPriceMultiplier;
729         }
730         else {
731             fundings[_proposalID].initialPriceMultiplier = _initialPriceMultiplier;
732             fundings[0].initialPriceMultiplier = _initialPriceMultiplier;
733         }
734         
735         if (_inflationRate == 0) fundings[_proposalID].inflationRate = fundings[0].inflationRate;
736         else {
737             fundings[_proposalID].inflationRate = _inflationRate;
738             fundings[0].inflationRate = _inflationRate;
739         }
740         
741         fundings[_proposalID].startTime = now;
742         fundings[0].startTime = now;
743         
744         fundings[_proposalID].closingTime = now + _minutesFundingPeriod * 1 minutes;
745         fundings[0].closingTime = fundings[_proposalID].closingTime;
746         
747         fundings[_proposalID].totalWeiGiven = 0;
748         
749         lastProposalID = _proposalID;
750         
751         FundingRulesSet(_moderator, _proposalID,  _amountToFund, fundings[_proposalID].startTime, fundings[_proposalID].closingTime);
752     } 
753     
754     function sale(
755         uint _proposalID,
756         address _recipient, 
757         uint _amount,
758         uint _saleDate,
759         bool _presale) internal returns (bool success) {
760 
761         if (_saleDate == 0) _saleDate = now;
762 
763         if (_saleDate > fundings[_proposalID].closingTime
764             || _saleDate < fundings[_proposalID].startTime
765             || fundings[_proposalID].totalWeiGiven + _amount > fundings[_proposalID].amountToFund) return;
766 
767         uint _tokenAmount = TokenAmount(_amount, priceMultiplier(_proposalID), priceDivisor(_proposalID, _saleDate));
768         if (_tokenAmount == 0) return;
769         
770         addHolder(_recipient);
771         if (_presale) {
772             Given[_proposalID][_recipient].tokenAmount += _tokenAmount;
773         }
774         else createTokens(_recipient, _tokenAmount);
775 
776         return true;
777     }
778 
779     function closeFunding(uint _proposalID) internal {
780         fundings[_proposalID].fundedAmount = fundings[_proposalID].totalWeiGiven;
781         lastFueledFundingID = _proposalID;
782         fundings[_proposalID].closingTime = now;
783         FundingFueled(_proposalID, fundings[_proposalID].fundedAmount);
784     }
785 
786     function sendPendingAmounts(        
787         uint _from,
788         uint _to,
789         address _buyer) returns (bool) {
790         
791         if (_from == 0) _from = 1;
792         if (_to == 0) _to = lastProposalID;
793         if (_buyer == 0) _buyer = msg.sender;
794 
795         uint _amount;
796         uint _tokenAmount;
797         
798         for (uint i = _from; i <= _to; i++) {
799 
800             if (now > fundings[i].closingTime && Given[i][_buyer].weiAmount != 0) {
801                 
802                 if (fundings[i].fundedAmount == 0) _amount += Given[i][_buyer].weiAmount;
803                 else _tokenAmount += Given[i][_buyer].tokenAmount;
804 
805                 fundings[i].totalWeiGiven -= Given[i][_buyer].weiAmount;
806                 Given[i][_buyer].tokenAmount = 0;
807                 Given[i][_buyer].weiAmount = 0;
808             }
809         }
810 
811         if (_tokenAmount > 0) {
812             createTokens(_buyer, _tokenAmount);
813             return true;
814         }
815         
816         if (_amount > 0) {
817             if (!_buyer.send(_amount)) throw;
818             Refund(_buyer, _amount);
819         } else return true;
820     }
821     
822 
823     function withdrawPendingAmounts() returns (bool) {
824         
825         return sendPendingAmounts(0, 0, msg.sender);
826     }        
827 
828 // Funding Moderator functions
829 
830     function setFundingStartTime(uint _proposalID, uint _startTime) external {
831         if ((msg.sender !=  fundings[_proposalID].moderator) || now > fundings[_proposalID].closingTime) throw;
832         fundings[_proposalID].startTime = _startTime;
833     }
834 
835     function setFundingFueled(uint _proposalID) external {
836 
837         if ((msg.sender !=  fundings[_proposalID].moderator) || now > fundings[_proposalID].closingTime) throw;
838 
839         closeFunding(_proposalID);
840     }
841     
842 // Tokens transfer management    
843     
844     function ableTransfer() onlyClient {
845         if (!transferable) {
846             transferable = true;
847             TransferAble();
848         }
849     }
850 
851     function disableTransfer() onlyClient {
852         if (transferable) {
853             transferable = false;
854             TransferDisable();
855         }
856     }
857     
858     function blockTransfer(address _shareHolder, uint _deadLine) external onlyClient onlyShareManager {
859         if (_deadLine > blockedDeadLine[_shareHolder]) {
860             blockedDeadLine[_shareHolder] = _deadLine;
861         }
862     }
863     
864     function transferFromTo(
865         address _from,
866         address _to, 
867         uint256 _value
868         ) internal returns (bool success) {  
869 
870         if ((transferable)
871             && now > blockedDeadLine[_from]
872             && now > blockedDeadLine[_to]
873             && _to != address(this)
874             && balances[_from] >= _value
875             && balances[_to] + _value > balances[_to]) {
876 
877             addHolder(_to);
878             balances[_from] -= _value;
879             balances[_to] += _value;
880             Transfer(_from, _to, _value);
881             return true;
882 
883         } else return false;
884     }
885     
886     function transfer(address _to, uint256 _value) returns (bool success) {  
887         if (!transferFromTo(msg.sender, _to, _value)) throw;
888         return true;
889     }
890 
891     function transferFrom(
892         address _from, 
893         address _to, 
894         uint256 _value
895         ) returns (bool success) { 
896         
897         if (allowed[_from][msg.sender] < _value
898             || !transferFromTo(_from, _to, _value)) throw;
899             
900         allowed[_from][msg.sender] -= _value;
901         return true;
902     }
903 
904     function approve(address _spender, uint256 _value) returns (bool success) {
905         allowed[msg.sender][_spender] = _value;
906         return true;
907     }
908     
909 }
910     
911 
912 
913 pragma solidity ^0.4.8;
914 
915 /*
916  *
917  * This file is part of Pass DAO.
918  *
919  * The Manager smart contract is used for the management of the Dao account, shares and tokens.
920  *
921 */
922 
923 /// @title Manager smart contract of the Pass Decentralized Autonomous Organisation
924 contract PassManager is PassTokenManager {
925     
926     struct order {
927         address buyer;
928         uint weiGiven;
929     }
930     // Orders to buy tokens
931     order[] public orders;
932     // Number or orders to buy tokens
933     uint numberOfOrders;
934 
935     // Map to know if an order was cloned from the precedent manager after an upgrade
936     mapping (uint => bool) orderCloned;
937     
938     function PassManager(
939         PassDao _passDao,
940         address _clonedFrom,
941         string _tokenName,
942         string _tokenSymbol,
943         uint8 _tokenDecimals,
944         bool _token,
945         bool _transferable,
946         uint _initialPriceMultiplier,
947         uint _inflationRate) 
948         PassTokenManager( _passDao, _clonedFrom, _tokenName, _tokenSymbol, _tokenDecimals, 
949             _token, _transferable, _initialPriceMultiplier, _inflationRate) { }
950     
951     /// @notice Function to receive payments
952     function () payable onlyShareManager { }
953     
954     /// @notice Function used by the client to send ethers
955     /// @param _recipient The address to send to
956     /// @param _amount The amount (in wei) to send
957     /// @return Whether the transfer was successful or not
958     function sendTo(
959         address _recipient,
960         uint _amount
961     ) external onlyClient returns (bool) {
962 
963         if (_recipient.send(_amount)) return true;
964         else return false;
965     }
966 
967     /// @dev Internal function to buy tokens and promote a proposal 
968     /// @param _proposalID The index of the proposal
969     /// @param _buyer The address of the buyer
970     /// @param _date The unix date to consider for the share or token price calculation
971     /// @param _presale True if presale
972     /// @return Whether the function was successful or not 
973     function buyTokensFor(
974         uint _proposalID,
975         address _buyer, 
976         uint _date,
977         bool _presale) internal returns (bool) {
978 
979         if (_proposalID == 0 || !sale(_proposalID, _buyer, msg.value, _date, _presale)) throw;
980 
981         fundings[_proposalID].totalWeiGiven += msg.value;        
982         if (fundings[_proposalID].totalWeiGiven == fundings[_proposalID].amountToFund) closeFunding(_proposalID);
983 
984         Given[_proposalID][_buyer].weiAmount += msg.value;
985         
986         return true;
987     }
988     
989     /// @notice Function to buy tokens and promote a proposal 
990     /// @param _proposalID The index of the proposal
991     /// @param _buyer The address of the buyer (not mandatory, msg.sender if 0)
992     /// @return Whether the function was successful or not 
993     function buyTokensForProposal(
994         uint _proposalID, 
995         address _buyer) payable returns (bool) {
996 
997         if (_buyer == 0) _buyer = msg.sender;
998 
999         if (fundings[_proposalID].moderator != 0) throw;
1000 
1001         return buyTokensFor(_proposalID, _buyer, now, true);
1002     }
1003 
1004     /// @notice Function used by the moderator to buy shares or tokens
1005     /// @param _proposalID Index of the client proposal
1006     /// @param _buyer The address of the recipient of shares or tokens
1007     /// @param _date The unix date to consider for the share or token price calculation
1008     /// @param _presale True if presale
1009     /// @return Whether the function was successful or not 
1010     function buyTokenFromModerator(
1011         uint _proposalID,
1012         address _buyer, 
1013         uint _date,
1014         bool _presale) payable external returns (bool){
1015 
1016         if (msg.sender != fundings[_proposalID].moderator) throw;
1017 
1018         return buyTokensFor(_proposalID, _buyer, _date, _presale);
1019     }
1020 
1021     /// @dev Internal function to create a buy order
1022     /// @param _buyer The address of the buyer
1023     /// @param _weiGiven The amount in wei given by the buyer
1024     function addOrder(
1025         address _buyer, 
1026         uint _weiGiven) internal {
1027 
1028         uint i;
1029         numberOfOrders += 1;
1030 
1031         if (numberOfOrders > orders.length) i = orders.length++;
1032         else i = numberOfOrders - 1;
1033         
1034         orders[i].buyer = _buyer;
1035         orders[i].weiGiven = _weiGiven;
1036     }
1037 
1038     /// @dev Internal function to remove a buy order
1039     /// @param _order The index of the order to remove
1040     function removeOrder(uint _order) internal {
1041         
1042         if (numberOfOrders - 1 < _order) return;
1043 
1044         numberOfOrders -= 1;
1045         if (numberOfOrders > 0) {
1046             for (uint i = _order; i <= numberOfOrders - 1; i++) {
1047                 orders[i].buyer = orders[i+1].buyer;
1048                 orders[i].weiGiven = orders[i+1].weiGiven;
1049             }
1050         }
1051         orders[numberOfOrders].buyer = 0;
1052         orders[numberOfOrders].weiGiven = 0;
1053     }
1054     
1055     /// @notice Function to create orders to buy tokens
1056     /// @return Whether the function was successful or not
1057     function buyTokens() payable returns (bool) {
1058 
1059         if (!transferable || msg.value < 100 finney) throw;
1060         
1061         addOrder(msg.sender, msg.value);
1062         
1063         return true;
1064     }
1065     
1066     /// @notice Function to sell tokens
1067     /// @param _tokenAmount in tokens to sell
1068     /// @param _from Index of the first order
1069     /// @param _to Index of the last order
1070     /// @return the revenue in wei
1071     function sellTokens(
1072         uint _tokenAmount,
1073         uint _from,
1074         uint _to) returns (uint) {
1075 
1076         if (!transferable 
1077             || uint(balances[msg.sender]) < _amount 
1078             || numberOfOrders == 0) throw;
1079         
1080         if (_to == 0 || _to > numberOfOrders - 1) _to = numberOfOrders - 1;
1081         
1082         
1083         uint _tokenAmounto;
1084         uint _amount;
1085         uint _totalAmount;
1086         uint o = _from;
1087 
1088         for (uint i = _from; i <= _to; i++) {
1089 
1090             if (_tokenAmount > 0 && orders[o].buyer != msg.sender) {
1091 
1092                 _tokenAmounto = TokenAmount(orders[o].weiGiven, priceMultiplier(0), actualPriceDivisor(0));
1093 
1094                 if (_tokenAmount >= _tokenAmounto 
1095                     && transferFromTo(msg.sender, orders[o].buyer, _tokenAmounto)) {
1096                             
1097                     _tokenAmount -= _tokenAmounto;
1098                     _totalAmount += orders[o].weiGiven;
1099                     removeOrder(o);
1100                 }
1101                 else if (_tokenAmount < _tokenAmounto
1102                     && transferFromTo(msg.sender, orders[o].buyer, _tokenAmount)) {
1103                         
1104                     _amount = weiAmount(_tokenAmount, priceMultiplier(0), actualPriceDivisor(0));
1105                     orders[o].weiGiven -= _amount;
1106                     _totalAmount += _amount;
1107                     i = _to + 1;
1108                 }
1109                 else o += 1;
1110             } 
1111             else o += 1;
1112         }
1113         
1114         if (!msg.sender.send(_totalAmount)) throw;
1115         else return _totalAmount;
1116     }    
1117 
1118     /// @notice Function to remove your orders and refund
1119     /// @param _from Index of the first order
1120     /// @param _to Index of the last order
1121     /// @return Whether the function was successful or not
1122     function removeOrders(
1123         uint _from,
1124         uint _to) returns (bool) {
1125 
1126         if (_to == 0 || _to > numberOfOrders) _to = numberOfOrders -1;
1127         
1128         uint _totalAmount;
1129         uint o = _from;
1130 
1131         for (uint i = _from; i <= _to; i++) {
1132 
1133             if (orders[o].buyer == msg.sender) {
1134                 
1135                 _totalAmount += orders[o].weiGiven;
1136                 removeOrder(o);
1137 
1138             } else o += 1;
1139         }
1140 
1141         if (!msg.sender.send(_totalAmount)) throw;
1142         else return true;
1143     }
1144     
1145 }    
1146 
1147 
1148 pragma solidity ^0.4.8;
1149 
1150 /*
1151  *
1152  * This file is part of Pass DAO.
1153  *
1154  * The Project smart contract is used for the management of the Pass Dao projects.
1155  *
1156 */
1157 
1158 /// @title Project smart contract of the Pass Decentralized Autonomous Organisation
1159 contract PassProject {
1160 
1161     // The Pass Dao smart contract
1162     PassDao public passDao;
1163     
1164     // The project name
1165     string public name;
1166     // The project description
1167     string public description;
1168     // The Hash Of the project Document
1169     bytes32 public hashOfTheDocument;
1170     // The project manager smart contract
1171     address projectManager;
1172 
1173     struct order {
1174         // The address of the contractor smart contract
1175         address contractorAddress;
1176         // The index of the contractor proposal
1177         uint contractorProposalID;
1178         // The amount of the order
1179         uint amount;
1180         // The date of the order
1181         uint orderDate;
1182     }
1183     // The orders of the Dao for this project
1184     order[] public orders;
1185     
1186     // The total amount of orders in wei for this project
1187     uint public totalAmountOfOrders;
1188 
1189     struct resolution {
1190         // The name of the resolution
1191         string name;
1192         // A description of the resolution
1193         string description;
1194         // The date of the resolution
1195         uint creationDate;
1196     }
1197     // Resolutions of the Dao for this project
1198     resolution[] public resolutions;
1199     
1200 // Events
1201 
1202     event OrderAdded(address indexed Client, address indexed ContractorAddress, uint indexed ContractorProposalID, uint Amount, uint OrderDate);
1203     event ProjectDescriptionUpdated(address indexed By, string NewDescription, bytes32 NewHashOfTheDocument);
1204     event ResolutionAdded(address indexed Client, uint indexed ResolutionID, string Name, string Description);
1205 
1206 // Constant functions  
1207 
1208     /// @return the actual committee room of the Dao   
1209     function Client() constant returns (address) {
1210         return passDao.ActualCommitteeRoom();
1211     }
1212     
1213     /// @return The number of orders 
1214     function numberOfOrders() constant returns (uint) {
1215         return orders.length - 1;
1216     }
1217     
1218     /// @return The project Manager address
1219     function ProjectManager() constant returns (address) {
1220         return projectManager;
1221     }
1222 
1223     /// @return The number of resolutions 
1224     function numberOfResolutions() constant returns (uint) {
1225         return resolutions.length - 1;
1226     }
1227     
1228 // modifiers
1229 
1230     // Modifier for project manager functions 
1231     modifier onlyProjectManager {if (msg.sender != projectManager) throw; _;}
1232 
1233     // Modifier for the Dao functions 
1234     modifier onlyClient {if (msg.sender != Client()) throw; _;}
1235 
1236 // Constructor function
1237 
1238     function PassProject(
1239         PassDao _passDao, 
1240         string _name,
1241         string _description,
1242         bytes32 _hashOfTheDocument) {
1243 
1244         passDao = _passDao;
1245         name = _name;
1246         description = _description;
1247         hashOfTheDocument = _hashOfTheDocument;
1248         
1249         orders.length = 1;
1250         resolutions.length = 1;
1251     }
1252     
1253 // Internal functions
1254 
1255     /// @dev Internal function to register a new order
1256     /// @param _contractorAddress The address of the contractor smart contract
1257     /// @param _contractorProposalID The index of the contractor proposal
1258     /// @param _amount The amount in wei of the order
1259     /// @param _orderDate The date of the order 
1260     function addOrder(
1261 
1262         address _contractorAddress, 
1263         uint _contractorProposalID, 
1264         uint _amount, 
1265         uint _orderDate) internal {
1266 
1267         uint _orderID = orders.length++;
1268         order d = orders[_orderID];
1269         d.contractorAddress = _contractorAddress;
1270         d.contractorProposalID = _contractorProposalID;
1271         d.amount = _amount;
1272         d.orderDate = _orderDate;
1273         
1274         totalAmountOfOrders += _amount;
1275         
1276         OrderAdded(msg.sender, _contractorAddress, _contractorProposalID, _amount, _orderDate);
1277     }
1278     
1279 // Setting functions
1280 
1281     /// @notice Function to allow cloning orders in case of upgrade
1282     /// @param _contractorAddress The address of the contractor smart contract
1283     /// @param _contractorProposalID The index of the contractor proposal
1284     /// @param _orderAmount The amount in wei of the order
1285     /// @param _lastOrderDate The unix date of the last order 
1286     function cloneOrder(
1287         address _contractorAddress, 
1288         uint _contractorProposalID, 
1289         uint _orderAmount, 
1290         uint _lastOrderDate) {
1291         
1292         if (projectManager != 0) throw;
1293         
1294         addOrder(_contractorAddress, _contractorProposalID, _orderAmount, _lastOrderDate);
1295     }
1296     
1297     /// @notice Function to set the project manager
1298     /// @param _projectManager The address of the project manager smart contract
1299     /// @return True if successful
1300     function setProjectManager(address _projectManager) returns (bool) {
1301 
1302         if (_projectManager == 0 || projectManager != 0) return;
1303         
1304         projectManager = _projectManager;
1305         
1306         return true;
1307     }
1308 
1309 // Project manager functions
1310 
1311     /// @notice Function to allow the project manager updating the description of the project
1312     /// @param _projectDescription A description of the project
1313     /// @param _hashOfTheDocument The hash of the last document
1314     function updateDescription(string _projectDescription, bytes32 _hashOfTheDocument) onlyProjectManager {
1315         description = _projectDescription;
1316         hashOfTheDocument = _hashOfTheDocument;
1317         ProjectDescriptionUpdated(msg.sender, _projectDescription, _hashOfTheDocument);
1318     }
1319 
1320 // Client functions
1321 
1322     /// @dev Function to allow the Dao to register a new order
1323     /// @param _contractorAddress The address of the contractor smart contract
1324     /// @param _contractorProposalID The index of the contractor proposal
1325     /// @param _amount The amount in wei of the order
1326     function newOrder(
1327         address _contractorAddress, 
1328         uint _contractorProposalID, 
1329         uint _amount) onlyClient {
1330             
1331         addOrder(_contractorAddress, _contractorProposalID, _amount, now);
1332     }
1333     
1334     /// @dev Function to allow the Dao to register a new resolution
1335     /// @param _name The name of the resolution
1336     /// @param _description The description of the resolution
1337     function newResolution(
1338         string _name, 
1339         string _description) onlyClient {
1340 
1341         uint _resolutionID = resolutions.length++;
1342         resolution d = resolutions[_resolutionID];
1343         
1344         d.name = _name;
1345         d.description = _description;
1346         d.creationDate = now;
1347 
1348         ResolutionAdded(msg.sender, _resolutionID, d.name, d.description);
1349     }
1350 }
1351 
1352 contract PassProjectCreator {
1353     
1354     event NewPassProject(PassDao indexed Dao, PassProject indexed Project, string Name, string Description, bytes32 HashOfTheDocument);
1355 
1356     /// @notice Function to create a new Pass project
1357     /// @param _passDao The Pass Dao smart contract
1358     /// @param _name The project name
1359     /// @param _description The project description (not mandatory, can be updated after by the creator)
1360     /// @param _hashOfTheDocument The Hash Of the project Document (not mandatory, can be updated after by the creator)
1361     function createProject(
1362         PassDao _passDao,
1363         string _name, 
1364         string _description, 
1365         bytes32 _hashOfTheDocument
1366         ) returns (PassProject) {
1367 
1368         PassProject _passProject = new PassProject(_passDao, _name, _description, _hashOfTheDocument);
1369 
1370         NewPassProject(_passDao, _passProject, _name, _description, _hashOfTheDocument);
1371 
1372         return _passProject;
1373     }
1374 }
1375     
1376 
1377 pragma solidity ^0.4.8;
1378 
1379 /*
1380  *
1381  * This file is part of Pass DAO.
1382  *
1383  * The Project smart contract is used for the management of the Pass Dao projects.
1384  *
1385 */
1386 
1387 /// @title Contractor smart contract of the Pass Decentralized Autonomous Organisation
1388 contract PassContractor {
1389     
1390     // The project smart contract
1391     PassProject passProject;
1392     
1393     // The address of the creator of this smart contract
1394     address public creator;
1395     // Address of the recipient;
1396     address public recipient;
1397 
1398     // End date of the setup procedure
1399     uint public smartContractStartDate;
1400 
1401     struct proposal {
1402         // Amount (in wei) of the proposal
1403         uint amount;
1404         // A description of the proposal
1405         string description;
1406         // The hash of the proposal's document
1407         bytes32 hashOfTheDocument;
1408         // A unix timestamp, denoting the date when the proposal was created
1409         uint dateOfProposal;
1410         // The amount submitted to a vote
1411         uint submittedAmount;
1412         // The sum amount (in wei) ordered for this proposal 
1413         uint orderAmount;
1414         // A unix timestamp, denoting the date of the last order for the approved proposal
1415         uint dateOfLastOrder;
1416     }
1417     // Proposals to work for Pass Dao
1418     proposal[] public proposals;
1419 
1420 // Events
1421 
1422     event RecipientUpdated(address indexed By, address LastRecipient, address NewRecipient);
1423     event Withdrawal(address indexed By, address indexed Recipient, uint Amount);
1424     event ProposalAdded(address Creator, uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
1425     event ProposalSubmitted(address indexed Client, uint Amount);
1426     event Order(address indexed Client, uint indexed ProposalID, uint Amount);
1427 
1428 // Constant functions
1429 
1430     /// @return the actual committee room of the Dao
1431     function Client() constant returns (address) {
1432         return passProject.Client();
1433     }
1434 
1435     /// @return the project smart contract
1436     function Project() constant returns (PassProject) {
1437         return passProject;
1438     }
1439     
1440     /// @notice Function used by the client to check the proposal before submitting
1441     /// @param _sender The creator of the Dao proposal
1442     /// @param _proposalID The index of the proposal
1443     /// @param _amount The amount of the proposal
1444     /// @return true if the proposal can be submitted
1445     function proposalChecked(
1446         address _sender,
1447         uint _proposalID, 
1448         uint _amount) constant external onlyClient returns (bool) {
1449         if (_sender != recipient && _sender != creator) return;
1450         if (_amount <= proposals[_proposalID].amount - proposals[_proposalID].submittedAmount) return true;
1451     }
1452 
1453     /// @return The number of proposals     
1454     function numberOfProposals() constant returns (uint) {
1455         return proposals.length - 1;
1456     }
1457 
1458 
1459 // Modifiers
1460 
1461     // Modifier for contractor functions
1462     modifier onlyContractor {if (msg.sender != recipient) throw; _;}
1463     
1464     // Modifier for client functions
1465     modifier onlyClient {if (msg.sender != Client()) throw; _;}
1466 
1467 // Constructor function
1468 
1469     function PassContractor(
1470         address _creator, 
1471         PassProject _passProject, 
1472         address _recipient,
1473         bool _restore) { 
1474 
1475         if (address(_passProject) == 0) throw;
1476         
1477         creator = _creator;
1478         if (_recipient == 0) _recipient = _creator;
1479         recipient = _recipient;
1480         
1481         passProject = _passProject;
1482         
1483         if (!_restore) smartContractStartDate = now;
1484 
1485         proposals.length = 1;
1486     }
1487 
1488 // Setting functions
1489 
1490     /// @notice Function to clone a proposal from the last contractor
1491     /// @param _amount Amount (in wei) of the proposal
1492     /// @param _description A description of the proposal
1493     /// @param _hashOfTheDocument The hash of the proposal's document
1494     /// @param _dateOfProposal A unix timestamp, denoting the date when the proposal was created
1495     /// @param _orderAmount The sum amount (in wei) ordered for this proposal 
1496     /// @param _dateOfOrder A unix timestamp, denoting the date of the last order for the approved proposal
1497     /// @param _cloneOrder True if the order has to be cloned in the project smart contract
1498     /// @return Whether the function was successful or not 
1499     function cloneProposal(
1500         uint _amount,
1501         string _description,
1502         bytes32 _hashOfTheDocument,
1503         uint _dateOfProposal,
1504         uint _orderAmount,
1505         uint _dateOfOrder,
1506         bool _cloneOrder
1507     ) returns (bool success) {
1508             
1509         if (smartContractStartDate != 0 || recipient == 0
1510         || msg.sender != creator) throw;
1511         
1512         uint _proposalID = proposals.length++;
1513         proposal c = proposals[_proposalID];
1514 
1515         c.amount = _amount;
1516         c.description = _description;
1517         c.hashOfTheDocument = _hashOfTheDocument; 
1518         c.dateOfProposal = _dateOfProposal;
1519         c.orderAmount = _orderAmount;
1520         c.dateOfLastOrder = _dateOfOrder;
1521 
1522         ProposalAdded(msg.sender, _proposalID, _amount, _description, _hashOfTheDocument);
1523         
1524         if (_cloneOrder) passProject.cloneOrder(address(this), _proposalID, _orderAmount, _dateOfOrder);
1525         
1526         return true;
1527     }
1528 
1529     /// @notice Function to close the setting procedure and start to use this smart contract
1530     /// @return True if successful
1531     function closeSetup() returns (bool) {
1532         
1533         if (smartContractStartDate != 0 
1534             || (msg.sender != creator && msg.sender != Client())) return;
1535 
1536         smartContractStartDate = now;
1537 
1538         return true;
1539     }
1540     
1541 // Account Management
1542 
1543     /// @notice Function to update the recipent address
1544     /// @param _newRecipient The adress of the recipient
1545     function updateRecipient(address _newRecipient) onlyContractor {
1546 
1547         if (_newRecipient == 0) throw;
1548 
1549         RecipientUpdated(msg.sender, recipient, _newRecipient);
1550         recipient = _newRecipient;
1551     } 
1552 
1553     /// @notice Function to receive payments
1554     function () payable { }
1555     
1556     /// @notice Function to allow contractors to withdraw ethers
1557     /// @param _amount The amount (in wei) to withdraw
1558     function withdraw(uint _amount) onlyContractor {
1559         if (!recipient.send(_amount)) throw;
1560         Withdrawal(msg.sender, recipient, _amount);
1561     }
1562     
1563 // Project Manager Functions    
1564 
1565     /// @notice Function to allow the project manager updating the description of the project
1566     /// @param _projectDescription A description of the project
1567     /// @param _hashOfTheDocument The hash of the last document
1568     function updateProjectDescription(string _projectDescription, bytes32 _hashOfTheDocument) onlyContractor {
1569         passProject.updateDescription(_projectDescription, _hashOfTheDocument);
1570     }
1571     
1572 // Management of proposals
1573 
1574     /// @notice Function to make a proposal to work for the client
1575     /// @param _creator The address of the creator of the proposal
1576     /// @param _amount The amount (in wei) of the proposal
1577     /// @param _description String describing the proposal
1578     /// @param _hashOfTheDocument The hash of the proposal document
1579     /// @return The index of the contractor proposal
1580     function newProposal(
1581         address _creator,
1582         uint _amount,
1583         string _description, 
1584         bytes32 _hashOfTheDocument
1585     ) external returns (uint) {
1586         
1587         if (msg.sender == Client() && _creator != recipient && _creator != creator) throw;
1588         if (msg.sender != Client() && msg.sender != recipient && msg.sender != creator) throw;
1589 
1590         if (_amount == 0) throw;
1591         
1592         uint _proposalID = proposals.length++;
1593         proposal c = proposals[_proposalID];
1594 
1595         c.amount = _amount;
1596         c.description = _description;
1597         c.hashOfTheDocument = _hashOfTheDocument; 
1598         c.dateOfProposal = now;
1599         
1600         ProposalAdded(msg.sender, _proposalID, c.amount, c.description, c.hashOfTheDocument);
1601         
1602         return _proposalID;
1603     }
1604     
1605     /// @notice Function used by the client to infor about the submitted amount
1606     /// @param _sender The address of the sender who submits the proposal
1607     /// @param _proposalID The index of the contractor proposal
1608     /// @param _amount The amount (in wei) submitted
1609     function submitProposal(
1610         address _sender, 
1611         uint _proposalID, 
1612         uint _amount) onlyClient {
1613 
1614         if (_sender != recipient && _sender != creator) throw;    
1615         proposals[_proposalID].submittedAmount += _amount;
1616         ProposalSubmitted(msg.sender, _amount);
1617     }
1618 
1619     /// @notice Function used by the client to order according to the contractor proposal
1620     /// @param _proposalID The index of the contractor proposal
1621     /// @param _orderAmount The amount (in wei) of the order
1622     /// @return Whether the order was made or not
1623     function order(
1624         uint _proposalID,
1625         uint _orderAmount
1626     ) external onlyClient returns (bool) {
1627     
1628         proposal c = proposals[_proposalID];
1629         
1630         uint _sum = c.orderAmount + _orderAmount;
1631         if (_sum > c.amount
1632             || _sum < c.orderAmount
1633             || _sum < _orderAmount) return; 
1634 
1635         c.orderAmount = _sum;
1636         c.dateOfLastOrder = now;
1637         
1638         Order(msg.sender, _proposalID, _orderAmount);
1639         
1640         return true;
1641     }
1642     
1643 }
1644 
1645 contract PassContractorCreator {
1646     
1647     // Address of the pass Dao smart contract
1648     PassDao public passDao;
1649     // Address of the Pass Project creator
1650     PassProjectCreator public projectCreator;
1651     
1652     struct contractor {
1653         // The address of the creator of the contractor
1654         address creator;
1655         // The contractor smart contract
1656         PassContractor contractor;
1657         // The address of the recipient for withdrawals
1658         address recipient;
1659         // True if meta project
1660         bool metaProject;
1661         // The address of the existing project smart contract
1662         PassProject passProject;
1663         // The name of the project (if the project smart contract doesn't exist)
1664         string projectName;
1665         // A description of the project (can be updated after)
1666         string projectDescription;
1667         // The unix creation date of the contractor
1668         uint creationDate;
1669     }
1670     // contractors created to work for Pass Dao
1671     contractor[] public contractors;
1672     
1673     event NewPassContractor(address indexed Creator, address indexed Recipient, PassProject indexed Project, PassContractor Contractor);
1674 
1675     function PassContractorCreator(PassDao _passDao, PassProjectCreator _projectCreator) {
1676         passDao = _passDao;
1677         projectCreator = _projectCreator;
1678         contractors.length = 0;
1679     }
1680 
1681     /// @return The number of created contractors 
1682     function numberOfContractors() constant returns (uint) {
1683         return contractors.length;
1684     }
1685     
1686     /// @notice Function to create a contractor smart contract
1687     /// @param _creator The address of the creator of the contractor
1688     /// @param _recipient The address of the recipient for withdrawals
1689     /// @param _metaProject True if meta project
1690     /// @param _passProject The address of the existing project smart contract
1691     /// @param _projectName The name of the project (if the project smart contract doesn't exist)
1692     /// @param _projectDescription A description of the project (can be updated after)
1693     /// @param _restore True if orders or proposals are to be cloned from other contracts
1694     /// @return The address of the created contractor smart contract
1695     function createContractor(
1696         address _creator,
1697         address _recipient, 
1698         bool _metaProject,
1699         PassProject _passProject,
1700         string _projectName, 
1701         string _projectDescription,
1702         bool _restore) returns (PassContractor) {
1703  
1704         PassProject _project;
1705 
1706         if (_creator == 0) _creator = msg.sender;
1707         
1708         if (_metaProject) _project = PassProject(passDao.MetaProject());
1709         else if (address(_passProject) == 0) 
1710             _project = projectCreator.createProject(passDao, _projectName, _projectDescription, 0);
1711         else _project = _passProject;
1712 
1713         PassContractor _contractor = new PassContractor(_creator, _project, _recipient, _restore);
1714         if (!_metaProject && address(_passProject) == 0 && !_restore) _project.setProjectManager(address(_contractor));
1715         
1716         uint _contractorID = contractors.length++;
1717         contractor c = contractors[_contractorID];
1718         c.creator = _creator;
1719         c.contractor = _contractor;
1720         c.recipient = _recipient;
1721         c.metaProject = _metaProject;
1722         c.passProject = _passProject;
1723         c.projectName = _projectName;
1724         c.projectDescription = _projectDescription;
1725         c.creationDate = now;
1726 
1727         NewPassContractor(_creator, _recipient, _project, _contractor);
1728  
1729         return _contractor;
1730     }
1731     
1732 }
1733 
1734 
1735 pragma solidity ^0.4.8;
1736 
1737 /*
1738  *
1739  * This file is part of Pass DAO.
1740  *
1741 
1742 /*
1743 Smart contract for a Decentralized Autonomous Organization (DAO)
1744 to automate organizational governance and decision-making.
1745 */
1746 
1747 /// @title Pass Committee Room
1748 contract PassCommitteeRoomInterface {
1749 
1750     // The Pass Dao smart contract
1751     PassDao public passDao;
1752 
1753     enum ProposalTypes { contractor, resolution, rules, upgrade }
1754 
1755     struct Committee {        
1756         // Address of the creator of the committee
1757         address creator;  
1758         // The type of the proposal
1759         ProposalTypes proposalType;
1760         // Index to identify the proposal
1761         uint proposalID;
1762         // unix timestamp, denoting the end of the set period of a proposal before the committee 
1763         uint setDeadline;
1764         // Fees (in wei) paid by the creator of the proposal
1765         uint fees;
1766         // Total of fees (in wei) rewarded to the voters
1767         uint totalRewardedAmount;
1768         // A unix timestamp, denoting the end of the voting period
1769         uint votingDeadline;
1770         // True if the proposal's votes have yet to be counted, otherwise False
1771         bool open; 
1772         // A unix timestamp, denoting the date of the execution of the approved proposal
1773         uint dateOfExecution;
1774         // Number of shares in favor of the proposal
1775         uint yea; 
1776         // Number of shares opposed to the proposal
1777         uint nay; 
1778     }
1779     // Committees organized to vote for or against a proposal
1780     Committee[] public Committees; 
1781     // mapping to indicate if a shareholder has voted at a committee or not
1782     mapping (uint => mapping (address => bool)) hasVoted;
1783 
1784     struct Proposal {
1785         // Index to identify the committee
1786         uint committeeID;
1787         // The contractor smart contract (not mandatory if funding)
1788         PassContractor contractor;
1789         // The index of the contractor proposal in the contractor contract (not mandatory if funding)
1790         uint contractorProposalID;
1791         // The amount of the proposal from the share manager balance (for funding or contractor proposals)
1792         uint amount;
1793         // The address which sets partners and manages the funding (not mandatory)
1794         address moderator;
1795         // Amount from the sale of shares (for funding or contractor proposals)
1796         uint amountForShares;
1797         // The initial price multiplier of Dao shares at the beginning of the funding (not mandatory)
1798         uint initialSharePriceMultiplier; 
1799         // Amount from the sale of tokens (for project manager proposals)
1800         uint amountForTokens;
1801         // A unix timestamp, denoting the start time of the funding
1802         uint minutesFundingPeriod;
1803         // True if the proposal is closed
1804         bool open; 
1805     }
1806     // Proposals to pay a contractor or/and fund the Dao
1807     Proposal[] public Proposals;
1808 
1809     struct Question {
1810         // Index to identify a committee
1811         uint committeeID; 
1812         // The project smart contract
1813         PassProject project;
1814         // The name of the question for display purpose
1815         string name;
1816         // A description of the question
1817         string description;
1818     }
1819     // Questions submitted to a vote by the shareholders 
1820     Question[] public ResolutionProposals;
1821     
1822     struct Rules {
1823         // Index to identify a committee
1824         uint committeeID; 
1825         // The quorum needed for each proposal is calculated by totalSupply / minQuorumDivisor
1826         uint minQuorumDivisor;  
1827         // Minimum fees (in wei) to create a proposal
1828         uint minCommitteeFees; 
1829         // Minimum percentage of votes for a proposal to reward the creator
1830         uint minPercentageOfLikes;
1831         // Period in minutes to consider or set a proposal before the voting procedure
1832         uint minutesSetProposalPeriod; 
1833         // The minimum debate period in minutes that a generic proposal can have
1834         uint minMinutesDebatePeriod;
1835         // The inflation rate to calculate the reward of fees to voters
1836         uint feesRewardInflationRate;
1837         // The inflation rate to calculate the token price (for project manager proposals) 
1838         uint tokenPriceInflationRate;
1839         // The default minutes funding period
1840         uint defaultMinutesFundingPeriod;
1841     } 
1842     // Proposals to update the committee rules
1843     Rules[] public rulesProposals;
1844 
1845     struct Upgrade {
1846         // Index to identify a committee
1847         uint committeeID; 
1848         // Address of the proposed Committee Room smart contract
1849         address newCommitteeRoom;
1850         // Address of the proposed share manager smart contract
1851         address newShareManager;
1852         // Address of the proposed token manager smart contract
1853         address newTokenManager;
1854     }
1855     // Proposals to upgrade
1856     Upgrade[] public UpgradeProposals;
1857     
1858     // The minimum periods in minutes 
1859     uint minMinutesPeriods;
1860     // The maximum inflation rate for token price or rewards to voters
1861     uint maxInflationRate;
1862     
1863     /// @return the effective share manager
1864     function ShareManager() constant returns (PassManager);
1865 
1866     /// @return the effective token manager
1867     function TokenManager() constant returns (PassManager);
1868 
1869     /// return the balance of the DAO
1870     function Balance() constant returns (uint);
1871     
1872     /// @param _committeeID The index of the committee
1873     /// @param _shareHolder The shareholder (not mandatory, default : msg.sender)
1874     /// @return true if the shareholder has voted at the committee
1875     function HasVoted(
1876         uint _committeeID, 
1877         address _shareHolder) constant external returns (bool);
1878     
1879     /// @return The minimum quorum for proposals to pass 
1880     function minQuorum() constant returns (uint);
1881 
1882     /// @return The number of committees 
1883     function numberOfCommittees() constant returns (uint);
1884     
1885     /// @dev The constructor function
1886     /// @param _passDao Address of Pass Dao
1887     //function PassCommitteeRoom(address _passDao);
1888 
1889     /// @notice Function to init an set the committee rules
1890     /// @param _maxInflationRate The maximum inflation rate for contractor and funding proposals
1891     /// @param _minMinutesPeriods The minimum periods in minutes
1892     /// @param _minQuorumDivisor The initial minimum quorum divisor for the proposals
1893     /// @param _minCommitteeFees The minimum amount (in wei) to make a proposal
1894     /// @param _minPercentageOfLikes Minimum percentage of votes for a proposal to reward the creator
1895     /// @param _minutesSetProposalPeriod The minimum period in minutes before a committee
1896     /// @param _minMinutesDebatePeriod The minimum period in minutes of the board meetings
1897     /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a committee
1898     /// @param _tokenPriceInflationRate The inflation rate to calculate the token price for project manager proposals
1899     /// @param _defaultMinutesFundingPeriod Default period in minutes of the funding
1900     function init(
1901         uint _maxInflationRate,
1902         uint _minMinutesPeriods,
1903         uint _minQuorumDivisor,
1904         uint _minCommitteeFees,
1905         uint _minPercentageOfLikes,
1906         uint _minutesSetProposalPeriod,
1907         uint _minMinutesDebatePeriod,
1908         uint _feesRewardInflationRate,
1909         uint _tokenPriceInflationRate,
1910         uint _defaultMinutesFundingPeriod);
1911 
1912     /// @notice Function to create a contractor smart contract
1913     /// @param _contractorCreator The contractor creator smart contract
1914     /// @param _recipient The recipient of the contractor smart contract
1915     /// @param _metaProject True if meta project
1916     /// @param _passProject The project smart contract (not mandatory)
1917     /// @param _projectName The name of the project (if the project smart contract doesn't exist)
1918     /// @param _projectDescription A description of the project (not mandatory, can be updated after)
1919     /// @return The contractor smart contract
1920     function createContractor(
1921         PassContractorCreator _contractorCreator,
1922         address _recipient,
1923         bool _metaProject,
1924         PassProject _passProject,
1925         string _projectName, 
1926         string _projectDescription) returns (PassContractor);
1927     
1928     /// @notice Function to make a proposal to pay a contractor or/and fund the Dao
1929     /// @param _amount Amount of the proposal
1930     /// @param _contractor The contractor smart contract
1931     /// @param _contractorProposalID Index of the contractor proposal in the contractor smart contract (not mandatory)
1932     /// @param _proposalDescription String describing the proposal (if not existing proposal)
1933     /// @param _hashOfTheContractorProposalDocument The hash of the Contractor proposal document (if not existing proposal)
1934     /// @param _moderator The address which sets partners and manage the funding (not mandatory)
1935     /// @param _initialSharePriceMultiplier The initial price multiplier of shares (for funding or contractor proposals)
1936     /// @param _minutesFundingPeriod Period in minutes of the funding (not mandatory)
1937     /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal (not mandatory)
1938     /// @return The index of the proposal
1939     function contractorProposal(
1940         uint _amount,
1941         PassContractor _contractor,
1942         uint _contractorProposalID,
1943         string _proposalDescription, 
1944         bytes32 _hashOfTheContractorProposalDocument,
1945         address _moderator,
1946         uint _initialSharePriceMultiplier, 
1947         uint _minutesFundingPeriod,
1948         uint _minutesDebatingPeriod) payable returns (uint);
1949 
1950     /// @notice Function to submit a question
1951     /// @param _name Name of the question for display purpose
1952     /// @param _description A description of the question
1953     /// @param _project The project smart contract
1954     /// @param _minutesDebatingPeriod Period in minutes of the board meeting to vote on the proposal
1955     /// @return The index of the proposal
1956     function resolutionProposal(
1957         string _name,
1958         string _description,
1959         PassProject _project,
1960         uint _minutesDebatingPeriod) payable returns (uint);
1961         
1962     /// @notice Function to make a proposal to change the rules of the committee room 
1963     /// @param _minQuorumDivisor If 5, the minimum quorum is 20%
1964     /// @param _minCommitteeFees The minimum amount (in wei) to make a proposal
1965     /// @param _minPercentageOfLikes Minimum percentage of votes for a proposal to reward the creator
1966     /// @param _minutesSetProposalPeriod Minimum period in minutes before a committee
1967     /// @param _minMinutesDebatePeriod The minimum period in minutes of the committees
1968     /// @param _feesRewardInflationRate The inflation rate to calculate the reward of fees to voters during a committee
1969     /// @param _defaultMinutesFundingPeriod Period in minutes of the funding
1970     /// @param _tokenPriceInflationRate The inflation rate to calculate the token price for project manager proposals
1971     /// @return The index of the proposal
1972     function rulesProposal(
1973         uint _minQuorumDivisor, 
1974         uint _minCommitteeFees,
1975         uint _minPercentageOfLikes,
1976         uint _minutesSetProposalPeriod,
1977         uint _minMinutesDebatePeriod,
1978         uint _feesRewardInflationRate,
1979         uint _defaultMinutesFundingPeriod,
1980         uint _tokenPriceInflationRate) payable returns (uint);
1981     
1982     /// @notice Function to make a proposal to upgrade the application
1983     /// @param _newCommitteeRoom Address of a new Committee Room smart contract (not mandatory)   
1984     /// @param _newShareManager Address of a new share manager smart contract (not mandatory)
1985     /// @param _newTokenManager Address of a new token manager smart contract (not mandatory)
1986     /// @param _minutesDebatingPeriod Period in minutes of the committee to vote on the proposal (not mandatory)
1987     /// @return The index of the proposal
1988     function upgradeProposal(
1989         address _newCommitteeRoom,
1990         address _newShareManager,
1991         address _newTokenManager,
1992         uint _minutesDebatingPeriod) payable returns (uint);
1993 
1994     /// @dev Internal function to create a committee
1995     /// @param _proposalType The type of the proposal
1996     /// @param _proposalID The index of the proposal
1997     /// @param _minutesDebatingPeriod The duration in minutes of the committee
1998     /// @return the index of the board meeting
1999     function newCommittee(
2000         ProposalTypes _proposalType,
2001         uint _proposalID, 
2002         uint _minutesDebatingPeriod) internal returns (uint);
2003         
2004     /// @notice Function to vote for or against a proposal during a committee
2005     /// @param _committeeID The index of the committee
2006     /// @param _supportsProposal True if the proposal is supported
2007     function vote(
2008         uint _committeeID, 
2009         bool _supportsProposal);
2010     
2011     /// @notice Function to execute a decision and close the committee
2012     /// @param _committeeID The index of the committee
2013     /// @return Whether the proposal was executed or not
2014     function executeDecision(uint _committeeID) returns (bool);
2015     
2016     /// @notice Function to order to a contractor and close a contractor proposal
2017     /// @param _proposalID The index of the proposal
2018     /// @return Whether the proposal was ordered and the proposal amount sent or not
2019     function orderToContractor(uint _proposalID) returns (bool);   
2020 
2021     /// @notice Function to buy shares and or/and promote a contractor proposal 
2022     /// @param _proposalID The index of the proposal
2023     /// @return Whether the function was successful or not
2024     function buySharesForProposal(uint _proposalID) payable returns (bool);
2025     
2026     /// @notice Function to send tokens or refund after the closing time of the funding proposals
2027     /// @param _from The first proposal. 0 if not linked to a proposal
2028     /// @param _to The last proposal
2029     /// @param _buyer The address of the buyer
2030     /// @return Whether the function was successful or not 
2031     function sendPendingAmounts(        
2032         uint _from,
2033         uint _to,
2034         address _buyer) returns (bool);
2035         
2036     /// @notice Function to receive tokens or refund after the closing time of the funding proposals
2037     /// @return Whether the function was successful or not
2038     function withdrawPendingAmounts() returns (bool);
2039 
2040     event CommitteeLimits(uint maxInflationRate, uint minMinutesPeriods);
2041     
2042     event ContractorCreated(PassContractorCreator Creator, address indexed Sender, PassContractor Contractor, address Recipient);
2043 
2044     event ProposalSubmitted(uint indexed ProposalID, uint CommitteeID, PassContractor indexed Contractor, uint indexed ContractorProposalID, 
2045         uint Amount, string Description, address Moderator, uint SharePriceMultiplier, uint MinutesFundingPeriod);
2046     event ResolutionProposalSubmitted(uint indexed QuestionID, uint indexed CommitteeID, PassProject indexed Project, string Name, string Description);
2047     event RulesProposalSubmitted(uint indexed rulesProposalID, uint CommitteeID, uint MinQuorumDivisor, uint MinCommitteeFees, uint MinPercentageOfLikes, 
2048         uint MinutesSetProposalPeriod, uint MinMinutesDebatePeriod, uint FeesRewardInflationRate, uint DefaultMinutesFundingPeriod, uint TokenPriceInflationRate);
2049     event UpgradeProposalSubmitted(uint indexed UpgradeProposalID, uint indexed CommitteeID, address NewCommitteeRoom, 
2050         address NewShareManager, address NewTokenManager);
2051 
2052     event Voted(uint indexed CommitteeID, bool Position, address indexed Voter, uint RewardedAmount);
2053 
2054     event ProposalClosed(uint indexed ProposalID, ProposalTypes indexed ProposalType, uint CommitteeID, 
2055         uint TotalRewardedAmount, bool ProposalExecuted, uint RewardedSharesAmount, uint SentToManager);
2056     event ContractorProposalClosed(uint indexed ProposalID, uint indexed ContractorProposalID, PassContractor indexed Contractor, uint AmountSent);
2057     event DappUpgraded(address NewCommitteeRoom, address NewShareManager, address NewTokenManager);
2058 
2059 }
2060 
2061 contract PassCommitteeRoom is PassCommitteeRoomInterface {
2062 
2063 // Constant functions
2064 
2065     function ShareManager() constant returns (PassManager) {
2066         return PassManager(passDao.ActualShareManager());
2067     }
2068     
2069     function TokenManager() constant returns (PassManager) {
2070         return PassManager(passDao.ActualTokenManager());
2071     }
2072     
2073     function Balance() constant returns (uint) {
2074         return passDao.ActualShareManager().balance;
2075     }
2076 
2077     function HasVoted(
2078         uint _committeeID, 
2079         address _shareHolder) constant external returns (bool) {
2080 
2081         if (_shareHolder == 0) return hasVoted[_committeeID][msg.sender];
2082         else return hasVoted[_committeeID][_shareHolder];
2083     }
2084     
2085     function minQuorum() constant returns (uint) {
2086         return (uint(ShareManager().totalSupply()) / rulesProposals[0].minQuorumDivisor);
2087     }
2088 
2089     function numberOfCommittees() constant returns (uint) {
2090         return Committees.length - 1;
2091     }
2092     
2093 // Constructor and init functions
2094 
2095     function PassCommitteeRoom(address _passDao) {
2096 
2097         passDao = PassDao(_passDao);
2098         rulesProposals.length = 1; 
2099         Committees.length = 1;
2100         Proposals.length = 1;
2101         ResolutionProposals.length = 1;
2102         UpgradeProposals.length = 1;
2103     }
2104     
2105     function init(
2106         uint _maxInflationRate,
2107         uint _minMinutesPeriods,
2108         uint _minQuorumDivisor,
2109         uint _minCommitteeFees,
2110         uint _minPercentageOfLikes,
2111         uint _minutesSetProposalPeriod,
2112         uint _minMinutesDebatePeriod,
2113         uint _feesRewardInflationRate,
2114         uint _tokenPriceInflationRate,
2115         uint _defaultMinutesFundingPeriod) {
2116 
2117         maxInflationRate = _maxInflationRate;
2118         minMinutesPeriods = _minMinutesPeriods;
2119         CommitteeLimits(maxInflationRate, minMinutesPeriods);
2120         
2121         if (rulesProposals[0].minQuorumDivisor != 0) throw;
2122         rulesProposals[0].minQuorumDivisor = _minQuorumDivisor;
2123         rulesProposals[0].minCommitteeFees = _minCommitteeFees;
2124         rulesProposals[0].minPercentageOfLikes = _minPercentageOfLikes;
2125         rulesProposals[0].minutesSetProposalPeriod = _minutesSetProposalPeriod;
2126         rulesProposals[0].minMinutesDebatePeriod = _minMinutesDebatePeriod;
2127         rulesProposals[0].feesRewardInflationRate = _feesRewardInflationRate;
2128         rulesProposals[0].tokenPriceInflationRate = _tokenPriceInflationRate;
2129         rulesProposals[0].defaultMinutesFundingPeriod = _defaultMinutesFundingPeriod;
2130 
2131     }
2132 
2133 // Project manager and contractor management
2134 
2135     function createContractor(
2136         PassContractorCreator _contractorCreator,
2137         address _recipient,
2138         bool _metaProject,
2139         PassProject _passProject,
2140         string _projectName, 
2141         string _projectDescription) returns (PassContractor) {
2142 
2143         PassContractor _contractor = _contractorCreator.createContractor(msg.sender, _recipient, 
2144             _metaProject, _passProject, _projectName, _projectDescription, false);
2145         ContractorCreated(_contractorCreator, msg.sender, _contractor, _recipient);
2146         return _contractor;
2147     }   
2148 
2149 // Proposals Management
2150 
2151     function contractorProposal(
2152         uint _amount,
2153         PassContractor _contractor,
2154         uint _contractorProposalID,
2155         string _proposalDescription, 
2156         bytes32 _hashOfTheContractorProposalDocument,        
2157         address _moderator,
2158         uint _initialSharePriceMultiplier, 
2159         uint _minutesFundingPeriod,
2160         uint _minutesDebatingPeriod
2161     ) payable returns (uint) {
2162 
2163         if (_minutesFundingPeriod == 0) _minutesFundingPeriod = rulesProposals[0].defaultMinutesFundingPeriod;
2164 
2165         if (address(_contractor) != 0 && _contractorProposalID != 0) {
2166             if (_hashOfTheContractorProposalDocument != 0 
2167                 ||!_contractor.proposalChecked(msg.sender, _contractorProposalID, _amount)) throw;
2168             else _proposalDescription = "Proposal checked";
2169         }
2170 
2171         if ((address(_contractor) != 0 && _contractorProposalID == 0 && _hashOfTheContractorProposalDocument == 0)
2172             || _amount == 0
2173             || _minutesFundingPeriod < minMinutesPeriods) throw;
2174 
2175         uint _proposalID = Proposals.length++;
2176         Proposal p = Proposals[_proposalID];
2177 
2178         p.contractor = _contractor;
2179         
2180         if (_contractorProposalID == 0 && _hashOfTheContractorProposalDocument != 0) {
2181             _contractorProposalID = _contractor.newProposal(msg.sender, _amount, _proposalDescription, _hashOfTheContractorProposalDocument);
2182         }
2183         p.contractorProposalID = _contractorProposalID;
2184 
2185         if (address(_contractor) == 0) p.amountForShares = _amount;
2186         else {
2187             _contractor.submitProposal(msg.sender, _contractorProposalID, _amount);
2188             if (_contractor.Project().ProjectManager() == address(_contractor)) p.amountForTokens = _amount;
2189             else {
2190                 p.amount = Balance();
2191                 if (_amount > p.amount) p.amountForShares = _amount - p.amount;
2192                 else p.amount = _amount;
2193             }
2194         }
2195         
2196         p.moderator = _moderator;
2197 
2198         p.initialSharePriceMultiplier = _initialSharePriceMultiplier;
2199 
2200         p.minutesFundingPeriod = _minutesFundingPeriod;
2201 
2202         p.committeeID = newCommittee(ProposalTypes.contractor, _proposalID, _minutesDebatingPeriod);   
2203 
2204         p.open = true;
2205         
2206         ProposalSubmitted(_proposalID, p.committeeID, p.contractor, p.contractorProposalID, p.amount+p.amountForShares+p.amountForTokens, 
2207             _proposalDescription, p.moderator, p.initialSharePriceMultiplier, p.minutesFundingPeriod);
2208 
2209         return _proposalID;
2210     }
2211 
2212     function resolutionProposal(
2213         string _name,
2214         string _description,
2215         PassProject _project,
2216         uint _minutesDebatingPeriod) payable returns (uint) {
2217         
2218         if (address(_project) == 0) _project = PassProject(passDao.MetaProject());
2219         
2220         uint _questionID = ResolutionProposals.length++;
2221         Question q = ResolutionProposals[_questionID];
2222         
2223         q.project = _project;
2224         q.name = _name;
2225         q.description = _description;
2226         
2227         q.committeeID = newCommittee(ProposalTypes.resolution, _questionID, _minutesDebatingPeriod);
2228         
2229         ResolutionProposalSubmitted(_questionID, q.committeeID, q.project, q.name, q.description);
2230         
2231         return _questionID;
2232     }
2233 
2234     function rulesProposal(
2235         uint _minQuorumDivisor, 
2236         uint _minCommitteeFees,
2237         uint _minPercentageOfLikes,
2238         uint _minutesSetProposalPeriod,
2239         uint _minMinutesDebatePeriod,
2240         uint _feesRewardInflationRate,
2241         uint _defaultMinutesFundingPeriod,
2242         uint _tokenPriceInflationRate) payable returns (uint) {
2243 
2244     
2245         if (_minQuorumDivisor <= 1
2246             || _minQuorumDivisor > 10
2247             || _minutesSetProposalPeriod < minMinutesPeriods
2248             || _minMinutesDebatePeriod < minMinutesPeriods
2249             || _feesRewardInflationRate > maxInflationRate
2250             || _tokenPriceInflationRate > maxInflationRate
2251             || _defaultMinutesFundingPeriod < minMinutesPeriods) throw; 
2252         
2253         uint _rulesProposalID = rulesProposals.length++;
2254         Rules r = rulesProposals[_rulesProposalID];
2255 
2256         r.minQuorumDivisor = _minQuorumDivisor;
2257         r.minCommitteeFees = _minCommitteeFees;
2258         r.minPercentageOfLikes = _minPercentageOfLikes;
2259         r.minutesSetProposalPeriod = _minutesSetProposalPeriod;
2260         r.minMinutesDebatePeriod = _minMinutesDebatePeriod;
2261         r.feesRewardInflationRate = _feesRewardInflationRate;
2262         r.defaultMinutesFundingPeriod = _defaultMinutesFundingPeriod;
2263         r.tokenPriceInflationRate = _tokenPriceInflationRate;
2264 
2265         r.committeeID = newCommittee(ProposalTypes.rules, _rulesProposalID, 0);
2266 
2267         RulesProposalSubmitted(_rulesProposalID, r.committeeID, _minQuorumDivisor, _minCommitteeFees, 
2268             _minPercentageOfLikes, _minutesSetProposalPeriod, _minMinutesDebatePeriod, 
2269             _feesRewardInflationRate, _defaultMinutesFundingPeriod, _tokenPriceInflationRate);
2270 
2271         return _rulesProposalID;
2272     }
2273     
2274     function upgradeProposal(
2275         address _newCommitteeRoom,
2276         address _newShareManager,
2277         address _newTokenManager,
2278         uint _minutesDebatingPeriod
2279     ) payable returns (uint) {
2280         
2281         uint _upgradeProposalID = UpgradeProposals.length++;
2282         Upgrade u = UpgradeProposals[_upgradeProposalID];
2283         
2284         u.newCommitteeRoom = _newCommitteeRoom;
2285         u.newShareManager = _newShareManager;
2286         u.newTokenManager = _newTokenManager;
2287 
2288         u.committeeID = newCommittee(ProposalTypes.upgrade, _upgradeProposalID, _minutesDebatingPeriod);
2289         
2290         UpgradeProposalSubmitted(_upgradeProposalID, u.committeeID, u.newCommitteeRoom, u.newShareManager, u.newTokenManager);
2291         
2292         return _upgradeProposalID;
2293     }
2294     
2295 // Committees management
2296 
2297     function newCommittee(
2298         ProposalTypes _proposalType,
2299         uint _proposalID, 
2300         uint _minutesDebatingPeriod
2301     ) internal returns (uint) {
2302 
2303         if (_minutesDebatingPeriod == 0) _minutesDebatingPeriod = rulesProposals[0].minMinutesDebatePeriod;
2304         
2305         if (passDao.ActualCommitteeRoom() != address(this)
2306             || msg.value < rulesProposals[0].minCommitteeFees
2307             || now + ((rulesProposals[0].minutesSetProposalPeriod + _minutesDebatingPeriod) * 1 minutes) < now
2308             || _minutesDebatingPeriod < rulesProposals[0].minMinutesDebatePeriod
2309             || msg.sender == address(this)) throw;
2310 
2311         uint _committeeID = Committees.length++;
2312         Committee b = Committees[_committeeID];
2313 
2314         b.creator = msg.sender;
2315 
2316         b.proposalType = _proposalType;
2317         b.proposalID = _proposalID;
2318 
2319         b.fees = msg.value;
2320         
2321         b.setDeadline = now + (rulesProposals[0].minutesSetProposalPeriod * 1 minutes);        
2322         b.votingDeadline = b.setDeadline + (_minutesDebatingPeriod * 1 minutes); 
2323 
2324         b.open = true; 
2325 
2326         return _committeeID;
2327     }
2328     
2329     function vote(
2330         uint _committeeID, 
2331         bool _supportsProposal) {
2332         
2333         Committee b = Committees[_committeeID];
2334 
2335         if (hasVoted[_committeeID][msg.sender] 
2336             || now < b.setDeadline
2337             || now > b.votingDeadline) throw;
2338             
2339         PassManager _shareManager = ShareManager();
2340 
2341         uint _balance = uint(_shareManager.balanceOf(msg.sender));
2342         if (_balance == 0) throw;
2343         
2344         hasVoted[_committeeID][msg.sender] = true;
2345 
2346         _shareManager.blockTransfer(msg.sender, b.votingDeadline);
2347 
2348         if (_supportsProposal) b.yea += _balance;
2349         else b.nay += _balance; 
2350 
2351         uint _a = 100*b.fees;
2352         if ((_a/100 != b.fees) || ((_a*_balance)/_a != _balance)) throw;
2353         uint _multiplier = (_a*_balance)/uint(_shareManager.totalSupply());
2354         uint _divisor = 100 + 100*rulesProposals[0].feesRewardInflationRate*(now - b.setDeadline)/(100*365 days);
2355         uint _rewardedamount = _multiplier/_divisor;
2356         if (b.totalRewardedAmount + _rewardedamount > b.fees) _rewardedamount = b.fees - b.totalRewardedAmount;
2357         b.totalRewardedAmount += _rewardedamount;
2358         if (!msg.sender.send(_rewardedamount)) throw;
2359 
2360         Voted(_committeeID, _supportsProposal, msg.sender, _rewardedamount);    
2361 }
2362 
2363 // Decisions management
2364 
2365     function executeDecision(uint _committeeID) returns (bool) {
2366 
2367         Committee b = Committees[_committeeID];
2368         
2369         if (now < b.votingDeadline || !b.open) return;
2370         
2371         b.open = false;
2372 
2373         PassManager _shareManager = ShareManager();
2374         uint _quantityOfShares;
2375         PassManager _tokenManager = TokenManager();
2376 
2377         if (100*b.yea > rulesProposals[0].minPercentageOfLikes * uint(_shareManager.totalSupply())) {       
2378             _quantityOfShares = _shareManager.rewardTokensForClient(b.creator, rulesProposals[0].minCommitteeFees);
2379         }        
2380 
2381         uint _sentToDaoManager = b.fees - b.totalRewardedAmount;
2382         if (_sentToDaoManager > 0) {
2383             if (!address(_shareManager).send(_sentToDaoManager)) throw;
2384         }
2385         
2386         if (b.yea + b.nay < minQuorum() || b.yea <= b.nay) {
2387             if (b.proposalType == ProposalTypes.contractor) Proposals[b.proposalID].open = false;
2388             ProposalClosed(b.proposalID, b.proposalType, _committeeID, b.totalRewardedAmount, false, _quantityOfShares, _sentToDaoManager);
2389             return;
2390         }
2391 
2392         b.dateOfExecution = now;
2393 
2394         if (b.proposalType == ProposalTypes.contractor) {
2395 
2396             Proposal p = Proposals[b.proposalID];
2397     
2398             if (p.contractorProposalID == 0) p.open = false;
2399             
2400             if (p.amountForShares == 0 && p.amountForTokens == 0) orderToContractor(b.proposalID);
2401             else {
2402                 if (p.amountForShares != 0) {
2403                     _shareManager.setFundingRules(p.moderator, p.initialSharePriceMultiplier, p.amountForShares, p.minutesFundingPeriod, 0, b.proposalID);
2404                 }
2405 
2406                 if (p.amountForTokens != 0) {
2407                     _tokenManager.setFundingRules(p.moderator, 0, p.amountForTokens, p.minutesFundingPeriod, rulesProposals[0].tokenPriceInflationRate, b.proposalID);
2408                 }
2409             }
2410 
2411         } else if (b.proposalType == ProposalTypes.resolution) {
2412             
2413             Question q = ResolutionProposals[b.proposalID];
2414             
2415             q.project.newResolution(q.name, q.description);
2416             
2417         } else if (b.proposalType == ProposalTypes.rules) {
2418 
2419             Rules r = rulesProposals[b.proposalID];
2420             
2421             rulesProposals[0].committeeID = r.committeeID;
2422             rulesProposals[0].minQuorumDivisor = r.minQuorumDivisor;
2423             rulesProposals[0].minMinutesDebatePeriod = r.minMinutesDebatePeriod; 
2424             rulesProposals[0].minCommitteeFees = r.minCommitteeFees;
2425             rulesProposals[0].minPercentageOfLikes = r.minPercentageOfLikes;
2426             rulesProposals[0].minutesSetProposalPeriod = r.minutesSetProposalPeriod;
2427             rulesProposals[0].feesRewardInflationRate = r.feesRewardInflationRate;
2428             rulesProposals[0].tokenPriceInflationRate = r.tokenPriceInflationRate;
2429             rulesProposals[0].defaultMinutesFundingPeriod = r.defaultMinutesFundingPeriod;
2430 
2431         } else if (b.proposalType == ProposalTypes.upgrade) {
2432 
2433             Upgrade u = UpgradeProposals[b.proposalID];
2434 
2435             if ((u.newShareManager != 0) && (u.newShareManager != address(_shareManager))) {
2436                 _shareManager.disableTransfer();
2437                 if (_shareManager.balance > 0) {
2438                     if (!_shareManager.sendTo(u.newShareManager, _shareManager.balance)) throw;
2439                 }
2440             }
2441 
2442             if ((u.newTokenManager != 0) && (u.newTokenManager != address(_tokenManager))) {
2443                 _tokenManager.disableTransfer();
2444             }
2445 
2446             passDao.upgrade(u.newCommitteeRoom, u.newShareManager, u.newTokenManager);
2447                 
2448             DappUpgraded(u.newCommitteeRoom, u.newShareManager, u.newTokenManager);
2449             
2450         }
2451 
2452         ProposalClosed(b.proposalID, b.proposalType, _committeeID , b.totalRewardedAmount, true, _quantityOfShares, _sentToDaoManager);
2453             
2454         return true;
2455     }
2456     
2457     function orderToContractor(uint _proposalID) returns (bool) {
2458         
2459         Proposal p = Proposals[_proposalID];
2460         Committee b = Committees[p.committeeID];
2461 
2462         if (b.open || !p.open) return;
2463         
2464         uint _amountForShares;
2465         uint _amountForTokens;
2466 
2467         if (p.amountForShares != 0) {
2468             _amountForShares = ShareManager().FundedAmount(_proposalID);
2469             if (_amountForShares == 0 && now <= b.dateOfExecution + (p.minutesFundingPeriod * 1 minutes)) return;
2470         }
2471 
2472         if (p.amountForTokens != 0) {
2473             _amountForTokens = TokenManager().FundedAmount(_proposalID);
2474             if (_amountForTokens == 0 && now <= b.dateOfExecution + (p.minutesFundingPeriod * 1 minutes)) return;
2475         }
2476         
2477         p.open = false;   
2478 
2479         uint _amount = p.amount + _amountForShares + _amountForTokens;
2480 
2481         PassProject _project = PassProject(p.contractor.Project());
2482 
2483         if (_amount == 0) {
2484             ContractorProposalClosed(_proposalID, p.contractorProposalID, p.contractor, 0);
2485             return;
2486         }    
2487 
2488         if (!p.contractor.order(p.contractorProposalID, _amount)) throw;
2489         
2490         if (p.amount + _amountForShares > 0) {
2491             if (!ShareManager().sendTo(p.contractor, p.amount + _amountForShares)) throw;
2492         }
2493         if (_amountForTokens > 0) {
2494             if (!TokenManager().sendTo(p.contractor, _amountForTokens)) throw;
2495         }
2496 
2497         ContractorProposalClosed(_proposalID, p.contractorProposalID, p.contractor, _amount);
2498         
2499         passDao.addProject(_project);
2500         _project.newOrder(p.contractor, p.contractorProposalID, _amount);
2501         
2502         return true;
2503     }
2504 
2505 // Holder Account management
2506 
2507     function buySharesForProposal(uint _proposalID) payable returns (bool) {
2508         
2509         return ShareManager().buyTokensForProposal.value(msg.value)(_proposalID, msg.sender);
2510     }   
2511 
2512     function sendPendingAmounts(
2513         uint _from,
2514         uint _to,
2515         address _buyer) returns (bool) {
2516         
2517         return ShareManager().sendPendingAmounts(_from, _to, _buyer);
2518     }        
2519     
2520     function withdrawPendingAmounts() returns (bool) {
2521         
2522         if (!ShareManager().sendPendingAmounts(0, 0, msg.sender)) throw;
2523     }        
2524             
2525 }