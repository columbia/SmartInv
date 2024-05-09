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