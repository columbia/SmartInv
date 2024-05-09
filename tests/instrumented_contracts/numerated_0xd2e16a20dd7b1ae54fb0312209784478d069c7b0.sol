1 /*
2 
3 - Bytecode Verification performed was compared on second iteration -
4 
5 This file is part of the DAO.
6 
7 The DAO is free software: you can redistribute it and/or modify
8 it under the terms of the GNU lesser General Public License as published by
9 the Free Software Foundation, either version 3 of the License, or
10 (at your option) any later version.
11 
12 The DAO is distributed in the hope that it will be useful,
13 but WITHOUT ANY WARRANTY; without even the implied warranty of
14 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 GNU lesser General Public License for more details.
16 
17 You should have received a copy of the GNU lesser General Public License
18 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
19 */
20 
21 
22 /*
23 Basic, standardized Token contract with no "premine". Defines the functions to
24 check token balances, send tokens, send tokens on behalf of a 3rd party and the
25 corresponding approval process. Tokens need to be created by a derived
26 contract (e.g. TokenCreation.sol).
27 
28 Thank you ConsenSys, this contract originated from:
29 https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Standard_Token.sol
30 Which is itself based on the Ethereum standardized contract APIs:
31 https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
32 */
33 
34 /// @title Standard Token Contract.
35 
36 contract TokenInterface {
37     mapping (address => uint256) balances;
38     mapping (address => mapping (address => uint256)) allowed;
39 
40     /// Total amount of tokens
41     uint256 public totalSupply;
42 
43     /// @param _owner The address from which the balance will be retrieved
44     /// @return The balance
45     function balanceOf(address _owner) constant returns (uint256 balance);
46 
47     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
48     /// @param _to The address of the recipient
49     /// @param _amount The amount of tokens to be transferred
50     /// @return Whether the transfer was successful or not
51     function transfer(address _to, uint256 _amount) returns (bool success);
52 
53     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
54     /// is approved by `_from`
55     /// @param _from The address of the origin of the transfer
56     /// @param _to The address of the recipient
57     /// @param _amount The amount of tokens to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
62     /// its behalf
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @param _amount The amount of tokens to be approved for transfer
65     /// @return Whether the approval was successful or not
66     function approve(address _spender, uint256 _amount) returns (bool success);
67 
68     /// @param _owner The address of the account owning tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @return Amount of remaining tokens of _owner that _spender is allowed
71     /// to spend
72     function allowance(
73         address _owner,
74         address _spender
75     ) constant returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
78     event Approval(
79         address indexed _owner,
80         address indexed _spender,
81         uint256 _amount
82     );
83 }
84 
85 
86 contract Token is TokenInterface {
87     // Protects users by preventing the execution of method calls that
88     // inadvertently also transferred ether
89     modifier noEther() {if (msg.value > 0) throw; _}
90 
91     function balanceOf(address _owner) constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function transfer(address _to, uint256 _amount) noEther returns (bool success) {
96         if (balances[msg.sender] >= _amount && _amount > 0) {
97             balances[msg.sender] -= _amount;
98             balances[_to] += _amount;
99             Transfer(msg.sender, _to, _amount);
100             return true;
101         } else {
102            return false;
103         }
104     }
105 
106     function transferFrom(
107         address _from,
108         address _to,
109         uint256 _amount
110     ) noEther returns (bool success) {
111 
112         if (balances[_from] >= _amount
113             && allowed[_from][msg.sender] >= _amount
114             && _amount > 0) {
115 
116             balances[_to] += _amount;
117             balances[_from] -= _amount;
118             allowed[_from][msg.sender] -= _amount;
119             Transfer(_from, _to, _amount);
120             return true;
121         } else {
122             return false;
123         }
124     }
125 
126     function approve(address _spender, uint256 _amount) returns (bool success) {
127         allowed[msg.sender][_spender] = _amount;
128         Approval(msg.sender, _spender, _amount);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
133         return allowed[_owner][_spender];
134     }
135 }
136 
137 
138 /*
139 This file is part of the DAO.
140 
141 The DAO is free software: you can redistribute it and/or modify
142 it under the terms of the GNU lesser General Public License as published by
143 the Free Software Foundation, either version 3 of the License, or
144 (at your option) any later version.
145 
146 The DAO is distributed in the hope that it will be useful,
147 but WITHOUT ANY WARRANTY; without even the implied warranty of
148 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
149 GNU lesser General Public License for more details.
150 
151 You should have received a copy of the GNU lesser General Public License
152 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
153 */
154 
155 
156 /*
157 Basic account, used by the DAO contract to separately manage both the rewards 
158 and the extraBalance accounts. 
159 */
160 
161 contract ManagedAccountInterface {
162     // The only address with permission to withdraw from this account
163     address public owner;
164     // If true, only the owner of the account can receive ether from it
165     bool public payOwnerOnly;
166     // The sum of ether (in wei) which has been sent to this contract
167     uint public accumulatedInput;
168 
169     /// @notice Sends `_amount` of wei to _recipient
170     /// @param _amount The amount of wei to send to `_recipient`
171     /// @param _recipient The address to receive `_amount` of wei
172     /// @return True if the send completed
173     function payOut(address _recipient, uint _amount) returns (bool);
174 
175     event PayOut(address indexed _recipient, uint _amount);
176 }
177 
178 
179 contract ManagedAccount is ManagedAccountInterface{
180 
181     // The constructor sets the owner of the account
182     function ManagedAccount(address _owner, bool _payOwnerOnly) {
183         owner = _owner;
184         payOwnerOnly = _payOwnerOnly;
185     }
186 
187     // When the contract receives a transaction without data this is called. 
188     // It counts the amount of ether it receives and stores it in 
189     // accumulatedInput.
190     function() {
191         accumulatedInput += msg.value;
192     }
193 
194     function payOut(address _recipient, uint _amount) returns (bool) {
195         if (msg.sender != owner || msg.value > 0 || (payOwnerOnly && _recipient != owner))
196             throw;
197         if (_recipient.call.value(_amount)()) {
198             PayOut(_recipient, _amount);
199             return true;
200         } else {
201             return false;
202         }
203     }
204 }
205 /*
206 This file is part of the DAO.
207 
208 The DAO is free software: you can redistribute it and/or modify
209 it under the terms of the GNU lesser General Public License as published by
210 the Free Software Foundation, either version 3 of the License, or
211 (at your option) any later version.
212 
213 The DAO is distributed in the hope that it will be useful,
214 but WITHOUT ANY WARRANTY; without even the implied warranty of
215 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
216 GNU lesser General Public License for more details.
217 
218 You should have received a copy of the GNU lesser General Public License
219 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
220 */
221 
222 
223 /*
224  * Token Creation contract, used by the DAO to create its tokens and initialize
225  * its ether. Feel free to modify the divisor method to implement different
226  * Token Creation parameters
227 */
228 
229 
230 contract TokenCreationInterface {
231 
232     // End of token creation, in Unix time
233     uint public closingTime;
234     // Minimum fueling goal of the token creation, denominated in tokens to
235     // be created
236     uint public minTokensToCreate;
237     // True if the DAO reached its minimum fueling goal, false otherwise
238     bool public isFueled;
239     // For DAO splits - if privateCreation is 0, then it is a public token
240     // creation, otherwise only the address stored in privateCreation is
241     // allowed to create tokens
242     address public privateCreation;
243     // hold extra ether which has been sent after the DAO token
244     // creation rate has increased
245     ManagedAccount public extraBalance;
246     // tracks the amount of wei given from each contributor (used for refund)
247     mapping (address => uint256) weiGiven;
248 
249     /// @dev Constructor setting the minimum fueling goal and the
250     /// end of the Token Creation
251     /// @param _minTokensToCreate Minimum fueling goal in number of
252     ///        Tokens to be created
253     /// @param _closingTime Date (in Unix time) of the end of the Token Creation
254     /// @param _privateCreation Zero means that the creation is public.  A
255     /// non-zero address represents the only address that can create Tokens
256     /// (the address can also create Tokens on behalf of other accounts)
257     // This is the constructor: it can not be overloaded so it is commented out
258     //  function TokenCreation(
259         //  uint _minTokensTocreate,
260         //  uint _closingTime,
261         //  address _privateCreation
262     //  );
263 
264     /// @notice Create Token with `_tokenHolder` as the initial owner of the Token
265     /// @param _tokenHolder The address of the Tokens's recipient
266     /// @return Whether the token creation was successful
267     function createTokenProxy(address _tokenHolder) returns (bool success);
268 
269     /// @notice Refund `msg.sender` in the case the Token Creation did
270     /// not reach its minimum fueling goal
271     function refund();
272 
273     /// @return The divisor used to calculate the token creation rate during
274     /// the creation phase
275     function divisor() constant returns (uint divisor);
276 
277     event FuelingToDate(uint value);
278     event CreatedToken(address indexed to, uint amount);
279     event Refund(address indexed to, uint value);
280 }
281 
282 
283 contract TokenCreation is TokenCreationInterface, Token {
284     function TokenCreation(
285         uint _minTokensToCreate,
286         uint _closingTime,
287         address _privateCreation) {
288 
289         closingTime = _closingTime;
290         minTokensToCreate = _minTokensToCreate;
291         privateCreation = _privateCreation;
292         extraBalance = new ManagedAccount(address(this), true);
293     }
294 
295     function createTokenProxy(address _tokenHolder) returns (bool success) {
296         if (now < closingTime && msg.value > 0
297             && (privateCreation == 0 || privateCreation == msg.sender)) {
298 
299             uint token = (msg.value * 20) / divisor();
300             extraBalance.call.value(msg.value - token)();
301             balances[_tokenHolder] += token;
302             totalSupply += token;
303             weiGiven[_tokenHolder] += msg.value;
304             CreatedToken(_tokenHolder, token);
305             if (totalSupply >= minTokensToCreate && !isFueled) {
306                 isFueled = true;
307                 FuelingToDate(totalSupply);
308             }
309             return true;
310         }
311         throw;
312     }
313 
314     function refund() noEther {
315         if (now > closingTime && !isFueled) {
316             // Get extraBalance - will only succeed when called for the first time
317             if (extraBalance.balance >= extraBalance.accumulatedInput())
318                 extraBalance.payOut(address(this), extraBalance.accumulatedInput());
319 
320             // Execute refund
321             if (msg.sender.call.value(weiGiven[msg.sender])()) {
322                 Refund(msg.sender, weiGiven[msg.sender]);
323                 totalSupply -= balances[msg.sender];
324                 balances[msg.sender] = 0;
325                 weiGiven[msg.sender] = 0;
326             }
327         }
328     }
329 
330     function divisor() constant returns (uint divisor) {
331         // The number of (base unit) tokens per wei is calculated
332         // as `msg.value` * 20 / `divisor`
333         // The fueling period starts with a 1:1 ratio
334         if (closingTime - 2 weeks > now) {
335             return 20;
336         // Followed by 10 days with a daily creation rate increase of 5%
337         } else if (closingTime - 4 days > now) {
338             return (20 + (now - (closingTime - 2 weeks)) / (1 days));
339         // The last 4 days there is a constant creation rate ratio of 1:1.5
340         } else {
341             return 30;
342         }
343     }
344 }
345 /*
346 This file is part of the DAO.
347 
348 The DAO is free software: you can redistribute it and/or modify
349 it under the terms of the GNU lesser General Public License as published by
350 the Free Software Foundation, either version 3 of the License, or
351 (at your option) any later version.
352 
353 The DAO is distributed in the hope that it will be useful,
354 but WITHOUT ANY WARRANTY; without even the implied warranty of
355 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
356 GNU lesser General Public License for more details.
357 
358 You should have received a copy of the GNU lesser General Public License
359 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
360 */
361 
362 
363 /*
364 Standard smart contract for a Decentralized Autonomous Organization (DAO)
365 to automate organizational governance and decision-making.
366 */
367 
368 
369 contract DAOInterface {
370 
371     // The amount of days for which people who try to participate in the
372     // creation by calling the fallback function will still get their ether back
373     uint constant creationGracePeriod = 40 days;
374     // The minimum debate period that a generic proposal can have
375     uint constant minProposalDebatePeriod = 2 weeks;
376     // The minimum debate period that a split proposal can have
377     uint constant minSplitDebatePeriod = 1 weeks;
378     // Period of days inside which it's possible to execute a DAO split
379     uint constant splitExecutionPeriod = 27 days;
380     // Period of time after which the minimum Quorum is halved
381     uint constant quorumHalvingPeriod = 25 weeks;
382     // Period after which a proposal is closed
383     // (used in the case `executeProposal` fails because it throws)
384     uint constant executeProposalPeriod = 10 days;
385     // Denotes the maximum proposal deposit that can be given. It is given as
386     // a fraction of total Ether spent plus balance of the DAO
387     uint constant maxDepositDivisor = 100;
388 
389     // Proposals to spend the DAO's ether or to choose a new Curator
390     Proposal[] public proposals;
391     // The quorum needed for each proposal is partially calculated by
392     // totalSupply / minQuorumDivisor
393     uint public minQuorumDivisor;
394     // The unix time of the last time quorum was reached on a proposal
395     uint  public lastTimeMinQuorumMet;
396 
397     // Address of the curator
398     address public curator;
399     // The whitelist: List of addresses the DAO is allowed to send ether to
400     mapping (address => bool) public allowedRecipients;
401 
402     // Tracks the addresses that own Reward Tokens. Those addresses can only be
403     // DAOs that have split from the original DAO. Conceptually, Reward Tokens
404     // represent the proportion of the rewards that the DAO has the right to
405     // receive. These Reward Tokens are generated when the DAO spends ether.
406     mapping (address => uint) public rewardToken;
407     // Total supply of rewardToken
408     uint public totalRewardToken;
409 
410     // The account used to manage the rewards which are to be distributed to the
411     // DAO Token Holders of this DAO
412     ManagedAccount public rewardAccount;
413 
414     // The account used to manage the rewards which are to be distributed to
415     // any DAO that holds Reward Tokens
416     ManagedAccount public DAOrewardAccount;
417 
418     // Amount of rewards (in wei) already paid out to a certain DAO
419     mapping (address => uint) public DAOpaidOut;
420 
421     // Amount of rewards (in wei) already paid out to a certain address
422     mapping (address => uint) public paidOut;
423     // Map of addresses blocked during a vote (not allowed to transfer DAO
424     // tokens). The address points to the proposal ID.
425     mapping (address => uint) public blocked;
426 
427     // The minimum deposit (in wei) required to submit any proposal that is not
428     // requesting a new Curator (no deposit is required for splits)
429     uint public proposalDeposit;
430 
431     // the accumulated sum of all current proposal deposits
432     uint sumOfProposalDeposits;
433 
434     // Contract that is able to create a new DAO (with the same code as
435     // this one), used for splits
436     DAO_Creator public daoCreator;
437 
438     // A proposal with `newCurator == false` represents a transaction
439     // to be issued by this DAO
440     // A proposal with `newCurator == true` represents a DAO split
441     struct Proposal {
442         // The address where the `amount` will go to if the proposal is accepted
443         // or if `newCurator` is true, the proposed Curator of
444         // the new DAO).
445         address recipient;
446         // The amount to transfer to `recipient` if the proposal is accepted.
447         uint amount;
448         // A plain text description of the proposal
449         string description;
450         // A unix timestamp, denoting the end of the voting period
451         uint votingDeadline;
452         // True if the proposal's votes have yet to be counted, otherwise False
453         bool open;
454         // True if quorum has been reached, the votes have been counted, and
455         // the majority said yes
456         bool proposalPassed;
457         // A hash to check validity of a proposal
458         bytes32 proposalHash;
459         // Deposit in wei the creator added when submitting their proposal. It
460         // is taken from the msg.value of a newProposal call.
461         uint proposalDeposit;
462         // True if this proposal is to assign a new Curator
463         bool newCurator;
464         // Data needed for splitting the DAO
465         SplitData[] splitData;
466         // Number of Tokens in favor of the proposal
467         uint yea;
468         // Number of Tokens opposed to the proposal
469         uint nay;
470         // Simple mapping to check if a shareholder has voted for it
471         mapping (address => bool) votedYes;
472         // Simple mapping to check if a shareholder has voted against it
473         mapping (address => bool) votedNo;
474         // Address of the shareholder who created the proposal
475         address creator;
476     }
477 
478     // Used only in the case of a newCurator proposal.
479     struct SplitData {
480         // The balance of the current DAO minus the deposit at the time of split
481         uint splitBalance;
482         // The total amount of DAO Tokens in existence at the time of split.
483         uint totalSupply;
484         // Amount of Reward Tokens owned by the DAO at the time of split.
485         uint rewardToken;
486         // The new DAO contract created at the time of split.
487         DAO newDAO;
488     }
489 
490     // Used to restrict access to certain functions to only DAO Token Holders
491     modifier onlyTokenholders {}
492 
493     /// @dev Constructor setting the Curator and the address
494     /// for the contract able to create another DAO as well as the parameters
495     /// for the DAO Token Creation
496     /// @param _curator The Curator
497     /// @param _daoCreator The contract able to (re)create this DAO
498     /// @param _proposalDeposit The deposit to be paid for a regular proposal
499     /// @param _minTokensToCreate Minimum required wei-equivalent tokens
500     ///        to be created for a successful DAO Token Creation
501     /// @param _closingTime Date (in Unix time) of the end of the DAO Token Creation
502     /// @param _privateCreation If zero the DAO Token Creation is open to public, a
503     /// non-zero address means that the DAO Token Creation is only for the address
504     // This is the constructor: it can not be overloaded so it is commented out
505     //  function DAO(
506         //  address _curator,
507         //  DAO_Creator _daoCreator,
508         //  uint _proposalDeposit,
509         //  uint _minTokensToCreate,
510         //  uint _closingTime,
511         //  address _privateCreation
512     //  );
513 
514     /// @notice Create Token with `msg.sender` as the beneficiary
515     /// @return Whether the token creation was successful
516     function () returns (bool success);
517 
518 
519     /// @dev This function is used to send ether back
520     /// to the DAO, it can also be used to receive payments that should not be
521     /// counted as rewards (donations, grants, etc.)
522     /// @return Whether the DAO received the ether successfully
523     function receiveEther() returns(bool);
524 
525     /// @notice `msg.sender` creates a proposal to send `_amount` Wei to
526     /// `_recipient` with the transaction data `_transactionData`. If
527     /// `_newCurator` is true, then this is a proposal that splits the
528     /// DAO and sets `_recipient` as the new DAO's Curator.
529     /// @param _recipient Address of the recipient of the proposed transaction
530     /// @param _amount Amount of wei to be sent with the proposed transaction
531     /// @param _description String describing the proposal
532     /// @param _transactionData Data of the proposed transaction
533     /// @param _debatingPeriod Time used for debating a proposal, at least 2
534     /// weeks for a regular proposal, 10 days for new Curator proposal
535     /// @param _newCurator Bool defining whether this proposal is about
536     /// a new Curator or not
537     /// @return The proposal ID. Needed for voting on the proposal
538     function newProposal(
539         address _recipient,
540         uint _amount,
541         string _description,
542         bytes _transactionData,
543         uint _debatingPeriod,
544         bool _newCurator
545     ) onlyTokenholders returns (uint _proposalID);
546 
547     /// @notice Check that the proposal with the ID `_proposalID` matches the
548     /// transaction which sends `_amount` with data `_transactionData`
549     /// to `_recipient`
550     /// @param _proposalID The proposal ID
551     /// @param _recipient The recipient of the proposed transaction
552     /// @param _amount The amount of wei to be sent in the proposed transaction
553     /// @param _transactionData The data of the proposed transaction
554     /// @return Whether the proposal ID matches the transaction data or not
555     function checkProposalCode(
556         uint _proposalID,
557         address _recipient,
558         uint _amount,
559         bytes _transactionData
560     ) constant returns (bool _codeChecksOut);
561 
562     /// @notice Vote on proposal `_proposalID` with `_supportsProposal`
563     /// @param _proposalID The proposal ID
564     /// @param _supportsProposal Yes/No - support of the proposal
565     /// @return The vote ID.
566     function vote(
567         uint _proposalID,
568         bool _supportsProposal
569     ) onlyTokenholders returns (uint _voteID);
570 
571     /// @notice Checks whether proposal `_proposalID` with transaction data
572     /// `_transactionData` has been voted for or rejected, and executes the
573     /// transaction in the case it has been voted for.
574     /// @param _proposalID The proposal ID
575     /// @param _transactionData The data of the proposed transaction
576     /// @return Whether the proposed transaction has been executed or not
577     function executeProposal(
578         uint _proposalID,
579         bytes _transactionData
580     ) returns (bool _success);
581 
582     /// @notice ATTENTION! I confirm to move my remaining ether to a new DAO
583     /// with `_newCurator` as the new Curator, as has been
584     /// proposed in proposal `_proposalID`. This will burn my tokens. This can
585     /// not be undone and will split the DAO into two DAO's, with two
586     /// different underlying tokens.
587     /// @param _proposalID The proposal ID
588     /// @param _newCurator The new Curator of the new DAO
589     /// @dev This function, when called for the first time for this proposal,
590     /// will create a new DAO and send the sender's portion of the remaining
591     /// ether and Reward Tokens to the new DAO. It will also burn the DAO Tokens
592     /// of the sender.
593     function splitDAO(
594         uint _proposalID,
595         address _newCurator
596     ) returns (bool _success);
597 
598     /// @dev can only be called by the DAO itself through a proposal
599     /// updates the contract of the DAO by sending all ether and rewardTokens
600     /// to the new DAO. The new DAO needs to be approved by the Curator
601     /// @param _newContract the address of the new contract
602     function newContract(address _newContract);
603 
604 
605     /// @notice Add a new possible recipient `_recipient` to the whitelist so
606     /// that the DAO can send transactions to them (using proposals)
607     /// @param _recipient New recipient address
608     /// @dev Can only be called by the current Curator
609     /// @return Whether successful or not
610     function changeAllowedRecipients(address _recipient, bool _allowed) external returns (bool _success);
611 
612 
613     /// @notice Change the minimum deposit required to submit a proposal
614     /// @param _proposalDeposit The new proposal deposit
615     /// @dev Can only be called by this DAO (through proposals with the
616     /// recipient being this DAO itself)
617     function changeProposalDeposit(uint _proposalDeposit) external;
618 
619     /// @notice Move rewards from the DAORewards managed account
620     /// @param _toMembers If true rewards are moved to the actual reward account
621     ///                   for the DAO. If not then it's moved to the DAO itself
622     /// @return Whether the call was successful
623     function retrieveDAOReward(bool _toMembers) external returns (bool _success);
624 
625     /// @notice Get my portion of the reward that was sent to `rewardAccount`
626     /// @return Whether the call was successful
627     function getMyReward() returns(bool _success);
628 
629     /// @notice Withdraw `_account`'s portion of the reward from `rewardAccount`
630     /// to `_account`'s balance
631     /// @return Whether the call was successful
632     function withdrawRewardFor(address _account) internal returns (bool _success);
633 
634     /// @notice Send `_amount` tokens to `_to` from `msg.sender`. Prior to this
635     /// getMyReward() is called.
636     /// @param _to The address of the recipient
637     /// @param _amount The amount of tokens to be transfered
638     /// @return Whether the transfer was successful or not
639     function transferWithoutReward(address _to, uint256 _amount) returns (bool success);
640 
641     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
642     /// is approved by `_from`. Prior to this getMyReward() is called.
643     /// @param _from The address of the sender
644     /// @param _to The address of the recipient
645     /// @param _amount The amount of tokens to be transfered
646     /// @return Whether the transfer was successful or not
647     function transferFromWithoutReward(
648         address _from,
649         address _to,
650         uint256 _amount
651     ) returns (bool success);
652 
653     /// @notice Doubles the 'minQuorumDivisor' in the case quorum has not been
654     /// achieved in 52 weeks
655     /// @return Whether the change was successful or not
656     function halveMinQuorum() returns (bool _success);
657 
658     /// @return total number of proposals ever created
659     function numberOfProposals() constant returns (uint _numberOfProposals);
660 
661     /// @param _proposalID Id of the new curator proposal
662     /// @return Address of the new DAO
663     function getNewDAOAddress(uint _proposalID) constant returns (address _newDAO);
664 
665     /// @param _account The address of the account which is checked.
666     /// @return Whether the account is blocked (not allowed to transfer tokens) or not.
667     function isBlocked(address _account) internal returns (bool);
668 
669     /// @notice If the caller is blocked by a proposal whose voting deadline
670     /// has exprired then unblock him.
671     /// @return Whether the account is blocked (not allowed to transfer tokens) or not.
672     function unblockMe() returns (bool);
673 
674     event ProposalAdded(
675         uint indexed proposalID,
676         address recipient,
677         uint amount,
678         bool newCurator,
679         string description
680     );
681     event Voted(uint indexed proposalID, bool position, address indexed voter);
682     event ProposalTallied(uint indexed proposalID, bool result, uint quorum);
683     event NewCurator(address indexed _newCurator);
684     event AllowedRecipientChanged(address indexed _recipient, bool _allowed);
685 }
686 
687 // The DAO contract itself
688 contract DAO is DAOInterface, Token, TokenCreation {
689 
690     // Modifier that allows only shareholders to vote and create new proposals
691     modifier onlyTokenholders {
692         if (balanceOf(msg.sender) == 0) throw;
693             _
694     }
695 
696     function DAO(
697         address _curator,
698         DAO_Creator _daoCreator,
699         uint _proposalDeposit,
700         uint _minTokensToCreate,
701         uint _closingTime,
702         address _privateCreation
703     ) TokenCreation(_minTokensToCreate, _closingTime, _privateCreation) {
704 
705         curator = _curator;
706         daoCreator = _daoCreator;
707         proposalDeposit = _proposalDeposit;
708         rewardAccount = new ManagedAccount(address(this), false);
709         DAOrewardAccount = new ManagedAccount(address(this), false);
710         if (address(rewardAccount) == 0)
711             throw;
712         if (address(DAOrewardAccount) == 0)
713             throw;
714         lastTimeMinQuorumMet = now;
715         minQuorumDivisor = 5; // sets the minimal quorum to 20%
716         proposals.length = 1; // avoids a proposal with ID 0 because it is used
717 
718         allowedRecipients[address(this)] = true;
719         allowedRecipients[curator] = true;
720     }
721 
722     function () returns (bool success) {
723         if (now < closingTime + creationGracePeriod && msg.sender != address(extraBalance))
724             return createTokenProxy(msg.sender);
725         else
726             return receiveEther();
727     }
728 
729 
730     function receiveEther() returns (bool) {
731         return true;
732     }
733 
734 
735     function newProposal(
736         address _recipient,
737         uint _amount,
738         string _description,
739         bytes _transactionData,
740         uint _debatingPeriod,
741         bool _newCurator
742     ) onlyTokenholders returns (uint _proposalID) {
743 
744         // Sanity check
745         if (_newCurator && (
746             _amount != 0
747             || _transactionData.length != 0
748             || _recipient == curator
749             || msg.value > 0
750             || _debatingPeriod < minSplitDebatePeriod)) {
751             throw;
752         } else if (
753             !_newCurator
754             && (!isRecipientAllowed(_recipient) || (_debatingPeriod <  minProposalDebatePeriod))
755         ) {
756             throw;
757         }
758 
759         if (_debatingPeriod > 8 weeks)
760             throw;
761 
762         if (!isFueled
763             || now < closingTime
764             || (msg.value < proposalDeposit && !_newCurator)) {
765 
766             throw;
767         }
768 
769         if (now + _debatingPeriod < now) // prevents overflow
770             throw;
771 
772         // to prevent a 51% attacker to convert the ether into deposit
773         if (msg.sender == address(this))
774             throw;
775 
776         _proposalID = proposals.length++;
777         Proposal p = proposals[_proposalID];
778         p.recipient = _recipient;
779         p.amount = _amount;
780         p.description = _description;
781         p.proposalHash = sha3(_recipient, _amount, _transactionData);
782         p.votingDeadline = now + _debatingPeriod;
783         p.open = true;
784         //p.proposalPassed = False; // that's default
785         p.newCurator = _newCurator;
786         if (_newCurator)
787             p.splitData.length++;
788         p.creator = msg.sender;
789         p.proposalDeposit = msg.value;
790 
791         sumOfProposalDeposits += msg.value;
792 
793         ProposalAdded(
794             _proposalID,
795             _recipient,
796             _amount,
797             _newCurator,
798             _description
799         );
800     }
801 
802 
803     function checkProposalCode(
804         uint _proposalID,
805         address _recipient,
806         uint _amount,
807         bytes _transactionData
808     ) noEther constant returns (bool _codeChecksOut) {
809         Proposal p = proposals[_proposalID];
810         return p.proposalHash == sha3(_recipient, _amount, _transactionData);
811     }
812 
813 
814     function vote(
815         uint _proposalID,
816         bool _supportsProposal
817     ) onlyTokenholders noEther returns (uint _voteID) {
818 
819         Proposal p = proposals[_proposalID];
820         if (p.votedYes[msg.sender]
821             || p.votedNo[msg.sender]
822             || now >= p.votingDeadline) {
823 
824             throw;
825         }
826 
827         if (_supportsProposal) {
828             p.yea += balances[msg.sender];
829             p.votedYes[msg.sender] = true;
830         } else {
831             p.nay += balances[msg.sender];
832             p.votedNo[msg.sender] = true;
833         }
834 
835         if (blocked[msg.sender] == 0) {
836             blocked[msg.sender] = _proposalID;
837         } else if (p.votingDeadline > proposals[blocked[msg.sender]].votingDeadline) {
838             // this proposal's voting deadline is further into the future than
839             // the proposal that blocks the sender so make it the blocker
840             blocked[msg.sender] = _proposalID;
841         }
842 
843         Voted(_proposalID, _supportsProposal, msg.sender);
844     }
845 
846 
847     function executeProposal(
848         uint _proposalID,
849         bytes _transactionData
850     ) noEther returns (bool _success) {
851 
852         Proposal p = proposals[_proposalID];
853 
854         uint waitPeriod = p.newCurator
855             ? splitExecutionPeriod
856             : executeProposalPeriod;
857         // If we are over deadline and waiting period, assert proposal is closed
858         if (p.open && now > p.votingDeadline + waitPeriod) {
859             closeProposal(_proposalID);
860             return;
861         }
862 
863         // Check if the proposal can be executed
864         if (now < p.votingDeadline  // has the voting deadline arrived?
865             // Have the votes been counted?
866             || !p.open
867             // Does the transaction code match the proposal?
868             || p.proposalHash != sha3(p.recipient, p.amount, _transactionData)) {
869 
870             throw;
871         }
872 
873         // If the curator removed the recipient from the whitelist, close the proposal
874         // in order to free the deposit and allow unblocking of voters
875         if (!isRecipientAllowed(p.recipient)) {
876             closeProposal(_proposalID);
877             p.creator.send(p.proposalDeposit);
878             return;
879         }
880 
881         bool proposalCheck = true;
882 
883         if (p.amount > actualBalance())
884             proposalCheck = false;
885 
886         uint quorum = p.yea + p.nay;
887 
888         // require 53% for calling newContract()
889         if (_transactionData.length >= 4 && _transactionData[0] == 0x68
890             && _transactionData[1] == 0x37 && _transactionData[2] == 0xff
891             && _transactionData[3] == 0x1e
892             && quorum < minQuorum(actualBalance() + rewardToken[address(this)])) {
893 
894                 proposalCheck = false;
895         }
896 
897         if (quorum >= minQuorum(p.amount)) {
898             if (!p.creator.send(p.proposalDeposit))
899                 throw;
900 
901             lastTimeMinQuorumMet = now;
902             // set the minQuorum to 20% again, in the case it has been reached
903             if (quorum > totalSupply / 5)
904                 minQuorumDivisor = 5;
905         }
906 
907         // Execute result
908         if (quorum >= minQuorum(p.amount) && p.yea > p.nay && proposalCheck) {
909             if (!p.recipient.call.value(p.amount)(_transactionData))
910                 throw;
911 
912             p.proposalPassed = true;
913             _success = true;
914 
915             // only create reward tokens when ether is not sent to the DAO itself and
916             // related addresses. Proxy addresses should be forbidden by the curator.
917             if (p.recipient != address(this) && p.recipient != address(rewardAccount)
918                 && p.recipient != address(DAOrewardAccount)
919                 && p.recipient != address(extraBalance)
920                 && p.recipient != address(curator)) {
921 
922                 rewardToken[address(this)] += p.amount;
923                 totalRewardToken += p.amount;
924             }
925         }
926 
927         closeProposal(_proposalID);
928 
929         // Initiate event
930         ProposalTallied(_proposalID, _success, quorum);
931     }
932 
933 
934     function closeProposal(uint _proposalID) internal {
935         Proposal p = proposals[_proposalID];
936         if (p.open)
937             sumOfProposalDeposits -= p.proposalDeposit;
938         p.open = false;
939     }
940 
941     function splitDAO(
942         uint _proposalID,
943         address _newCurator
944     ) noEther onlyTokenholders returns (bool _success) {
945 
946         Proposal p = proposals[_proposalID];
947 
948         // Sanity check
949 
950         if (now < p.votingDeadline  // has the voting deadline arrived?
951             //The request for a split expires XX days after the voting deadline
952             || now > p.votingDeadline + splitExecutionPeriod
953             // Does the new Curator address match?
954             || p.recipient != _newCurator
955             // Is it a new curator proposal?
956             || !p.newCurator
957             // Have you voted for this split?
958             || !p.votedYes[msg.sender]
959             // Did you already vote on another proposal?
960             || (blocked[msg.sender] != _proposalID && blocked[msg.sender] != 0) )  {
961 
962             throw;
963         }
964 
965         // If the new DAO doesn't exist yet, create the new DAO and store the
966         // current split data
967         if (address(p.splitData[0].newDAO) == 0) {
968             p.splitData[0].newDAO = createNewDAO(_newCurator);
969             // Call depth limit reached, etc.
970             if (address(p.splitData[0].newDAO) == 0)
971                 throw;
972             // should never happen
973             if (this.balance < sumOfProposalDeposits)
974                 throw;
975             p.splitData[0].splitBalance = actualBalance();
976             p.splitData[0].rewardToken = rewardToken[address(this)];
977             p.splitData[0].totalSupply = totalSupply;
978             p.proposalPassed = true;
979         }
980 
981         // Move ether and assign new Tokens
982         uint fundsToBeMoved =
983             (balances[msg.sender] * p.splitData[0].splitBalance) /
984             p.splitData[0].totalSupply;
985         if (p.splitData[0].newDAO.createTokenProxy.value(fundsToBeMoved)(msg.sender) == false)
986             throw;
987 
988 
989         // Assign reward rights to new DAO
990         uint rewardTokenToBeMoved =
991             (balances[msg.sender] * p.splitData[0].rewardToken) /
992             p.splitData[0].totalSupply;
993 
994         uint paidOutToBeMoved = DAOpaidOut[address(this)] * rewardTokenToBeMoved /
995             rewardToken[address(this)];
996 
997         rewardToken[address(p.splitData[0].newDAO)] += rewardTokenToBeMoved;
998         if (rewardToken[address(this)] < rewardTokenToBeMoved)
999             throw;
1000         rewardToken[address(this)] -= rewardTokenToBeMoved;
1001 
1002         DAOpaidOut[address(p.splitData[0].newDAO)] += paidOutToBeMoved;
1003         if (DAOpaidOut[address(this)] < paidOutToBeMoved)
1004             throw;
1005         DAOpaidOut[address(this)] -= paidOutToBeMoved;
1006 
1007         // Burn DAO Tokens
1008         Transfer(msg.sender, 0, balances[msg.sender]);
1009         withdrawRewardFor(msg.sender); // be nice, and get his rewards
1010         totalSupply -= balances[msg.sender];
1011         balances[msg.sender] = 0;
1012         paidOut[msg.sender] = 0;
1013         return true;
1014     }
1015 
1016     function newContract(address _newContract){
1017         if (msg.sender != address(this) || !allowedRecipients[_newContract]) return;
1018         // move all ether
1019         if (!_newContract.call.value(address(this).balance)()) {
1020             throw;
1021         }
1022 
1023         //move all reward tokens
1024         rewardToken[_newContract] += rewardToken[address(this)];
1025         rewardToken[address(this)] = 0;
1026         DAOpaidOut[_newContract] += DAOpaidOut[address(this)];
1027         DAOpaidOut[address(this)] = 0;
1028     }
1029 
1030 
1031     function retrieveDAOReward(bool _toMembers) external noEther returns (bool _success) {
1032         DAO dao = DAO(msg.sender);
1033 
1034         if ((rewardToken[msg.sender] * DAOrewardAccount.accumulatedInput()) /
1035             totalRewardToken < DAOpaidOut[msg.sender])
1036             throw;
1037 
1038         uint reward =
1039             (rewardToken[msg.sender] * DAOrewardAccount.accumulatedInput()) /
1040             totalRewardToken - DAOpaidOut[msg.sender];
1041         if(_toMembers) {
1042             if (!DAOrewardAccount.payOut(dao.rewardAccount(), reward))
1043                 throw;
1044             }
1045         else {
1046             if (!DAOrewardAccount.payOut(dao, reward))
1047                 throw;
1048         }
1049         DAOpaidOut[msg.sender] += reward;
1050         return true;
1051     }
1052 
1053     function getMyReward() noEther returns (bool _success) {
1054         return withdrawRewardFor(msg.sender);
1055     }
1056 
1057 
1058     function withdrawRewardFor(address _account) noEther internal returns (bool _success) {
1059         if ((balanceOf(_account) * rewardAccount.accumulatedInput()) / totalSupply < paidOut[_account])
1060             throw;
1061 
1062         uint reward =
1063             (balanceOf(_account) * rewardAccount.accumulatedInput()) / totalSupply - paidOut[_account];
1064         if (!rewardAccount.payOut(_account, reward))
1065             throw;
1066         paidOut[_account] += reward;
1067         return true;
1068     }
1069 
1070 
1071     function transfer(address _to, uint256 _value) returns (bool success) {
1072         if (isFueled
1073             && now > closingTime
1074             && !isBlocked(msg.sender)
1075             && transferPaidOut(msg.sender, _to, _value)
1076             && super.transfer(_to, _value)) {
1077 
1078             return true;
1079         } else {
1080             throw;
1081         }
1082     }
1083 
1084 
1085     function transferWithoutReward(address _to, uint256 _value) returns (bool success) {
1086         if (!getMyReward())
1087             throw;
1088         return transfer(_to, _value);
1089     }
1090 
1091 
1092     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
1093         if (isFueled
1094             && now > closingTime
1095             && !isBlocked(_from)
1096             && transferPaidOut(_from, _to, _value)
1097             && super.transferFrom(_from, _to, _value)) {
1098 
1099             return true;
1100         } else {
1101             throw;
1102         }
1103     }
1104 
1105 
1106     function transferFromWithoutReward(
1107         address _from,
1108         address _to,
1109         uint256 _value
1110     ) returns (bool success) {
1111 
1112         if (!withdrawRewardFor(_from))
1113             throw;
1114         return transferFrom(_from, _to, _value);
1115     }
1116 
1117 
1118     function transferPaidOut(
1119         address _from,
1120         address _to,
1121         uint256 _value
1122     ) internal returns (bool success) {
1123 
1124         uint transferPaidOut = paidOut[_from] * _value / balanceOf(_from);
1125         if (transferPaidOut > paidOut[_from])
1126             throw;
1127         paidOut[_from] -= transferPaidOut;
1128         paidOut[_to] += transferPaidOut;
1129         return true;
1130     }
1131 
1132 
1133     function changeProposalDeposit(uint _proposalDeposit) noEther external {
1134         if (msg.sender != address(this) || _proposalDeposit > (actualBalance() + rewardToken[address(this)])
1135             / maxDepositDivisor) {
1136 
1137             throw;
1138         }
1139         proposalDeposit = _proposalDeposit;
1140     }
1141 
1142 
1143     function changeAllowedRecipients(address _recipient, bool _allowed) noEther external returns (bool _success) {
1144         if (msg.sender != curator)
1145             throw;
1146         allowedRecipients[_recipient] = _allowed;
1147         AllowedRecipientChanged(_recipient, _allowed);
1148         return true;
1149     }
1150 
1151 
1152     function isRecipientAllowed(address _recipient) internal returns (bool _isAllowed) {
1153         if (allowedRecipients[_recipient]
1154             || (_recipient == address(extraBalance)
1155                 // only allowed when at least the amount held in the
1156                 // extraBalance account has been spent from the DAO
1157                 && totalRewardToken > extraBalance.accumulatedInput()))
1158             return true;
1159         else
1160             return false;
1161     }
1162 
1163     function actualBalance() constant returns (uint _actualBalance) {
1164         return this.balance - sumOfProposalDeposits;
1165     }
1166 
1167 
1168     function minQuorum(uint _value) internal constant returns (uint _minQuorum) {
1169         // minimum of 20% and maximum of 53.33%
1170         return totalSupply / minQuorumDivisor +
1171             (_value * totalSupply) / (3 * (actualBalance() + rewardToken[address(this)]));
1172     }
1173 
1174 
1175     function halveMinQuorum() returns (bool _success) {
1176         // this can only be called after `quorumHalvingPeriod` has passed or at anytime
1177         // by the curator with a delay of at least `minProposalDebatePeriod` between the calls
1178         if ((lastTimeMinQuorumMet < (now - quorumHalvingPeriod) || msg.sender == curator)
1179             && lastTimeMinQuorumMet < (now - minProposalDebatePeriod)) {
1180             lastTimeMinQuorumMet = now;
1181             minQuorumDivisor *= 2;
1182             return true;
1183         } else {
1184             return false;
1185         }
1186     }
1187 
1188     function createNewDAO(address _newCurator) internal returns (DAO _newDAO) {
1189         NewCurator(_newCurator);
1190         return daoCreator.createDAO(_newCurator, 0, 0, now + splitExecutionPeriod);
1191     }
1192 
1193     function numberOfProposals() constant returns (uint _numberOfProposals) {
1194         // Don't count index 0. It's used by isBlocked() and exists from start
1195         return proposals.length - 1;
1196     }
1197 
1198     function getNewDAOAddress(uint _proposalID) constant returns (address _newDAO) {
1199         return proposals[_proposalID].splitData[0].newDAO;
1200     }
1201 
1202     function isBlocked(address _account) internal returns (bool) {
1203         if (blocked[_account] == 0)
1204             return false;
1205         Proposal p = proposals[blocked[_account]];
1206         if (now > p.votingDeadline) {
1207             blocked[_account] = 0;
1208             return false;
1209         } else {
1210             return true;
1211         }
1212     }
1213 
1214     function unblockMe() returns (bool) {
1215         return isBlocked(msg.sender);
1216     }
1217 }
1218 
1219 contract DAO_Creator {
1220     function createDAO(
1221         address _curator,
1222         uint _proposalDeposit,
1223         uint _minTokensToCreate,
1224         uint _closingTime
1225     ) returns (DAO _newDAO) {
1226 
1227         return new DAO(
1228             _curator,
1229             DAO_Creator(this),
1230             _proposalDeposit,
1231             _minTokensToCreate,
1232             _closingTime,
1233             msg.sender
1234         );
1235     }
1236 }