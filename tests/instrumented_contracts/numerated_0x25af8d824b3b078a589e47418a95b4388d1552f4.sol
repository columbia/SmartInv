1 /*
2 This file is part of the DAO.
3 
4 The DAO is free software: you can redistribute it and/or modify
5 it under the terms of the GNU lesser General Public License as published by
6 the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The DAO is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
16 */
17 
18 
19 /*
20 Standard smart contract for a Decentralized Autonomous Organization (DAO)
21 to automate organizational governance and decision-making.
22 */
23 
24 /*
25 This file is part of the DAO.
26 
27 The DAO is free software: you can redistribute it and/or modify
28 it under the terms of the GNU lesser General Public License as published by
29 the Free Software Foundation, either version 3 of the License, or
30 (at your option) any later version.
31 
32 The DAO is distributed in the hope that it will be useful,
33 but WITHOUT ANY WARRANTY; without even the implied warranty of
34 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
35 GNU lesser General Public License for more details.
36 
37 You should have received a copy of the GNU lesser General Public License
38 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
39 */
40 
41 
42 /*
43 Basic account, used by the DAO contract to separately manage both the rewards 
44 and the extraBalance accounts. 
45 */
46 
47 contract ManagedAccountInterface {
48     // The only address with permission to withdraw from this account
49     address public owner;
50     // If true, only the owner of the account can receive ether from it
51     bool public payOwnerOnly;
52     // The sum of ether (in wei) which has been sent to this contract
53     uint public accumulatedInput;
54 
55     /// @notice Sends `_amount` of wei to _recipient
56     /// @param _amount The amount of wei to send to `_recipient`
57     /// @param _recipient The address to receive `_amount` of wei
58     /// @return True if the send completed
59     function payOut(address _recipient, uint _amount) returns (bool);
60 
61     event PayOut(address indexed _recipient, uint _amount);
62 }
63 
64 
65 contract ManagedAccount is ManagedAccountInterface{
66 
67     // The constructor sets the owner of the account
68     function ManagedAccount(address _owner, bool _payOwnerOnly) {
69         owner = _owner;
70         payOwnerOnly = _payOwnerOnly;
71     }
72 
73     // When the contract receives a transaction without data this is called. 
74     // It counts the amount of ether it receives and stores it in 
75     // accumulatedInput.
76     function() {
77         accumulatedInput += msg.value;
78     }
79 
80     function payOut(address _recipient, uint _amount) returns (bool) {
81         if (msg.sender != owner || msg.value > 0 || (payOwnerOnly && _recipient != owner))
82             throw;
83         if (_recipient.call.value(_amount)()) {
84             PayOut(_recipient, _amount);
85             return true;
86         } else {
87             return false;
88         }
89     }
90 }
91 
92 /*
93 This file is part of the DAO.
94 
95 The DAO is free software: you can redistribute it and/or modify
96 it under the terms of the GNU lesser General Public License as published by
97 the Free Software Foundation, either version 3 of the License, or
98 (at your option) any later version.
99 
100 The DAO is distributed in the hope that it will be useful,
101 but WITHOUT ANY WARRANTY; without even the implied warranty of
102 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
103 GNU lesser General Public License for more details.
104 
105 You should have received a copy of the GNU lesser General Public License
106 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
107 */
108 
109 
110 /*
111  * Token Creation contract, used by the DAO to create its tokens and initialize
112  * its ether. Feel free to modify the divisor method to implement different
113  * Token Creation parameters
114 */
115 
116 /*
117 This file is part of the DAO.
118 
119 The DAO is free software: you can redistribute it and/or modify
120 it under the terms of the GNU lesser General Public License as published by
121 the Free Software Foundation, either version 3 of the License, or
122 (at your option) any later version.
123 
124 The DAO is distributed in the hope that it will be useful,
125 but WITHOUT ANY WARRANTY; without even the implied warranty of
126 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
127 GNU lesser General Public License for more details.
128 
129 You should have received a copy of the GNU lesser General Public License
130 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
131 */
132 
133 
134 /*
135 Basic, standardized Token contract with no "premine". Defines the functions to
136 check token balances, send tokens, send tokens on behalf of a 3rd party and the
137 corresponding approval process. Tokens need to be created by a derived
138 contract (e.g. TokenCreation.sol).
139 
140 Thank you ConsenSys, this contract originated from:
141 https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Standard_Token.sol
142 Which is itself based on the Ethereum standardized contract APIs:
143 https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
144 */
145 
146 /// @title Standard Token Contract.
147 
148 contract TokenInterface {
149     mapping (address => uint256) balances;
150     mapping (address => mapping (address => uint256)) allowed;
151 
152     /// Total amount of tokens
153     uint256 public totalSupply;
154 
155     /// @param _owner The address from which the balance will be retrieved
156     /// @return The balance
157     function balanceOf(address _owner) constant returns (uint256 balance);
158 
159     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
160     /// @param _to The address of the recipient
161     /// @param _amount The amount of tokens to be transferred
162     /// @return Whether the transfer was successful or not
163     function transfer(address _to, uint256 _amount) returns (bool success);
164 
165     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
166     /// is approved by `_from`
167     /// @param _from The address of the origin of the transfer
168     /// @param _to The address of the recipient
169     /// @param _amount The amount of tokens to be transferred
170     /// @return Whether the transfer was successful or not
171     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
172 
173     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
174     /// its behalf
175     /// @param _spender The address of the account able to transfer the tokens
176     /// @param _amount The amount of tokens to be approved for transfer
177     /// @return Whether the approval was successful or not
178     function approve(address _spender, uint256 _amount) returns (bool success);
179 
180     /// @param _owner The address of the account owning tokens
181     /// @param _spender The address of the account able to transfer the tokens
182     /// @return Amount of remaining tokens of _owner that _spender is allowed
183     /// to spend
184     function allowance(
185         address _owner,
186         address _spender
187     ) constant returns (uint256 remaining);
188 
189     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
190     event Approval(
191         address indexed _owner,
192         address indexed _spender,
193         uint256 _amount
194     );
195 }
196 
197 
198 contract Token is TokenInterface {
199     // Protects users by preventing the execution of method calls that
200     // inadvertently also transferred ether
201     modifier noEther() {if (msg.value > 0) throw; _}
202 
203     function balanceOf(address _owner) constant returns (uint256 balance) {
204         return balances[_owner];
205     }
206 
207     function transfer(address _to, uint256 _amount) noEther returns (bool success) {
208         if (balances[msg.sender] >= _amount && _amount > 0) {
209             balances[msg.sender] -= _amount;
210             balances[_to] += _amount;
211             Transfer(msg.sender, _to, _amount);
212             return true;
213         } else {
214            return false;
215         }
216     }
217 
218     function transferFrom(
219         address _from,
220         address _to,
221         uint256 _amount
222     ) noEther returns (bool success) {
223 
224         if (balances[_from] >= _amount
225             && allowed[_from][msg.sender] >= _amount
226             && _amount > 0) {
227 
228             balances[_to] += _amount;
229             balances[_from] -= _amount;
230             allowed[_from][msg.sender] -= _amount;
231             Transfer(_from, _to, _amount);
232             return true;
233         } else {
234             return false;
235         }
236     }
237 
238     function approve(address _spender, uint256 _amount) returns (bool success) {
239         allowed[msg.sender][_spender] = _amount;
240         Approval(msg.sender, _spender, _amount);
241         return true;
242     }
243 
244     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
245         return allowed[_owner][_spender];
246     }
247 }
248 
249 contract TokenCreationInterface {
250 
251     // End of token creation, in Unix time
252     uint public closingTime;
253     // Minimum fueling goal of the token creation, denominated in tokens to
254     // be created
255     uint public minTokensToCreate;
256     // True if the DAO reached its minimum fueling goal, false otherwise
257     bool public isFueled;
258     // For DAO splits - if privateCreation is 0, then it is a public token
259     // creation, otherwise only the address stored in privateCreation is
260     // allowed to create tokens
261     address public privateCreation;
262     // hold extra ether which has been sent after the DAO token
263     // creation rate has increased
264     ManagedAccount public extraBalance;
265     // tracks the amount of wei given from each contributor (used for refund)
266     mapping (address => uint256) weiGiven;
267 
268     /// @dev Constructor setting the minimum fueling goal and the
269     /// end of the Token Creation
270     /// @param _minTokensToCreate Minimum fueling goal in number of
271     ///        Tokens to be created
272     /// @param _closingTime Date (in Unix time) of the end of the Token Creation
273     /// @param _privateCreation Zero means that the creation is public.  A
274     /// non-zero address represents the only address that can create Tokens
275     /// (the address can also create Tokens on behalf of other accounts)
276     // This is the constructor: it can not be overloaded so it is commented out
277     //  function TokenCreation(
278         //  uint _minTokensTocreate,
279         //  uint _closingTime,
280         //  address _privateCreation
281     //  );
282 
283     /// @notice Create Token with `_tokenHolder` as the initial owner of the Token
284     /// @param _tokenHolder The address of the Tokens's recipient
285     /// @return Whether the token creation was successful
286     function createTokenProxy(address _tokenHolder) returns (bool success);
287 
288     /// @notice Refund `msg.sender` in the case the Token Creation did
289     /// not reach its minimum fueling goal
290     function refund();
291 
292     /// @return The divisor used to calculate the token creation rate during
293     /// the creation phase
294     function divisor() constant returns (uint divisor);
295 
296     event FuelingToDate(uint value);
297     event CreatedToken(address indexed to, uint amount);
298     event Refund(address indexed to, uint value);
299 }
300 
301 
302 contract TokenCreation is TokenCreationInterface, Token {
303     function TokenCreation(
304         uint _minTokensToCreate,
305         uint _closingTime,
306         address _privateCreation) {
307 
308         closingTime = _closingTime;
309         minTokensToCreate = _minTokensToCreate;
310         privateCreation = _privateCreation;
311         extraBalance = new ManagedAccount(address(this), true);
312     }
313 
314     function createTokenProxy(address _tokenHolder) returns (bool success) {
315         if (now < closingTime && msg.value > 0
316             && (privateCreation == 0 || privateCreation == msg.sender)) {
317 
318             uint token = (msg.value * 20) / divisor();
319             extraBalance.call.value(msg.value - token)();
320             balances[_tokenHolder] += token;
321             totalSupply += token;
322             weiGiven[_tokenHolder] += msg.value;
323             CreatedToken(_tokenHolder, token);
324             if (totalSupply >= minTokensToCreate && !isFueled) {
325                 isFueled = true;
326                 FuelingToDate(totalSupply);
327             }
328             return true;
329         }
330         throw;
331     }
332 
333     function refund() noEther {
334         if (now > closingTime && !isFueled) {
335             // Get extraBalance - will only succeed when called for the first time
336             if (extraBalance.balance >= extraBalance.accumulatedInput())
337                 extraBalance.payOut(address(this), extraBalance.accumulatedInput());
338 
339             // Execute refund
340             if (msg.sender.call.value(weiGiven[msg.sender])()) {
341                 Refund(msg.sender, weiGiven[msg.sender]);
342                 totalSupply -= balances[msg.sender];
343                 balances[msg.sender] = 0;
344                 weiGiven[msg.sender] = 0;
345             }
346         }
347     }
348 
349     function divisor() constant returns (uint divisor) {
350             return 20;
351     }
352 }
353 
354 
355 contract DAOInterface {
356 
357     // The amount of days for which people who try to participate in the
358     // creation by calling the fallback function will still get their ether back
359     uint constant creationGracePeriod = 40 days;
360     // The minimum debate period that a generic proposal can have
361     uint constant minProposalDebatePeriod = 3 days;
362     // The minimum debate period that a split proposal can have
363     uint constant minSplitDebatePeriod = 0 days;
364     // Period of days inside which it's possible to execute a DAO split
365     uint constant splitExecutionPeriod = 1 days;
366     // Period of time after which the minimum Quorum is halved
367     uint constant quorumHalvingPeriod = 2 weeks;
368     // Period after which a proposal is closed
369     // (used in the case `executeProposal` fails because it throws)
370     uint constant executeProposalPeriod = 2 days;
371     // Denotes the maximum proposal deposit that can be given. It is given as
372     // a fraction of total Ether spent plus balance of the DAO
373     uint constant maxDepositDivisor = 100;
374 
375     // Proposals to spend the DAO's ether or to choose a new Curator
376     Proposal[] public proposals;
377     // The quorum needed for each proposal is partially calculated by
378     // totalSupply / minQuorumDivisor
379     uint public minQuorumDivisor;
380     // The unix time of the last time quorum was reached on a proposal
381     uint public lastTimeMinQuorumMet;
382 
383     // Address of the curator
384     address public curator;
385     // The whitelist: List of addresses the DAO is allowed to send ether to
386     mapping (address => bool) public allowedRecipients;
387 
388     // Tracks the addresses that own Reward Tokens. Those addresses can only be
389     // DAOs that have split from the original DAO. Conceptually, Reward Tokens
390     // represent the proportion of the rewards that the DAO has the right to
391     // receive. These Reward Tokens are generated when the DAO spends ether.
392     mapping (address => uint) public rewardToken;
393     // Total supply of rewardToken
394     uint public totalRewardToken;
395 
396     // The account used to manage the rewards which are to be distributed to the
397     // DAO Token Holders of this DAO
398     ManagedAccount public rewardAccount;
399 
400     // The account used to manage the rewards which are to be distributed to
401     // any DAO that holds Reward Tokens
402     ManagedAccount public DAOrewardAccount;
403 
404     // Amount of rewards (in wei) already paid out to a certain DAO
405     mapping (address => uint) public DAOpaidOut;
406 
407     // Amount of rewards (in wei) already paid out to a certain address
408     mapping (address => uint) public paidOut;
409     // Map of addresses blocked during a vote (not allowed to transfer DAO
410     // tokens). The address points to the proposal ID.
411     mapping (address => uint) public blocked;
412 
413     // The minimum deposit (in wei) required to submit any proposal that is not
414     // requesting a new Curator (no deposit is required for splits)
415     uint public proposalDeposit;
416 
417     // the accumulated sum of all current proposal deposits
418     uint sumOfProposalDeposits;
419 
420     // Contract that is able to create a new DAO (with the same code as
421     // this one), used for splits
422     DAO_Creator public daoCreator;
423 
424     // A proposal with `newCurator == false` represents a transaction
425     // to be issued by this DAO
426     // A proposal with `newCurator == true` represents a DAO split
427     struct Proposal {
428         // The address where the `amount` will go to if the proposal is accepted
429         // or if `newCurator` is true, the proposed Curator of
430         // the new DAO).
431         address recipient;
432         // The amount to transfer to `recipient` if the proposal is accepted.
433         uint amount;
434         // A plain text description of the proposal
435         string description;
436         // A unix timestamp, denoting the end of the voting period
437         uint votingDeadline;
438         // True if the proposal's votes have yet to be counted, otherwise False
439         bool open;
440         // True if quorum has been reached, the votes have been counted, and
441         // the majority said yes
442         bool proposalPassed;
443         // A hash to check validity of a proposal
444         bytes32 proposalHash;
445         // Deposit in wei the creator added when submitting their proposal. It
446         // is taken from the msg.value of a newProposal call.
447         uint proposalDeposit;
448         // True if this proposal is to assign a new Curator
449         bool newCurator;
450         // Data needed for splitting the DAO
451         SplitData[] splitData;
452         // Number of Tokens in favor of the proposal
453         uint yea;
454         // Number of Tokens opposed to the proposal
455         uint nay;
456         // Simple mapping to check if a shareholder has voted for it
457         mapping (address => bool) votedYes;
458         // Simple mapping to check if a shareholder has voted against it
459         mapping (address => bool) votedNo;
460         // Address of the shareholder who created the proposal
461         address creator;
462     }
463 
464     // Used only in the case of a newCurator proposal.
465     struct SplitData {
466         // The balance of the current DAO minus the deposit at the time of split
467         uint splitBalance;
468         // The total amount of DAO Tokens in existence at the time of split.
469         uint totalSupply;
470         // Amount of Reward Tokens owned by the DAO at the time of split.
471         uint rewardToken;
472         // The new DAO contract created at the time of split.
473         MICRODAO newDAO;
474     }
475 
476     // Used to restrict access to certain functions to only DAO Token Holders
477     modifier onlyTokenholders {}
478 
479     /// @dev Constructor setting the Curator and the address
480     /// for the contract able to create another DAO as well as the parameters
481     /// for the DAO Token Creation
482     /// @param _curator The Curator
483     /// @param _daoCreator The contract able to (re)create this DAO
484     /// @param _proposalDeposit The deposit to be paid for a regular proposal
485     /// @param _minTokensToCreate Minimum required wei-equivalent tokens
486     ///        to be created for a successful DAO Token Creation
487     /// @param _closingTime Date (in Unix time) of the end of the DAO Token Creation
488     /// @param _privateCreation If zero the DAO Token Creation is open to public, a
489     /// non-zero address means that the DAO Token Creation is only for the address
490     // This is the constructor: it can not be overloaded so it is commented out
491     //  function DAO(
492         //  address _curator,
493         //  DAO_Creator _daoCreator,
494         //  uint _proposalDeposit,
495         //  uint _minTokensToCreate,
496         //  uint _closingTime,
497         //  addresses _privateCreation
498     //  );
499 
500     /// @notice Create Token with `msg.sender` as the beneficiary
501     /// @return Whether the token creation was successful
502     function () returns (bool success);
503 
504 
505     /// @dev This function is used to send ether back
506     /// to the DAO, it can also be used to receive payments that should not be
507     /// counted as rewards (donations, grants, etc.)
508     /// @return Whether the DAO received the ether successfully
509     function receiveEther() returns(bool);
510 
511     /// @notice `msg.sender` creates a proposal to send `_amount` Wei to
512     /// `_recipient` with the transaction data `_transactionData`. If
513     /// `_newCurator` is true, then this is a proposal that splits the
514     /// DAO and sets `_recipient` as the new DAO's Curator.
515     /// @param _recipient Address of the recipient of the proposed transaction
516     /// @param _amount Amount of wei to be sent with the proposed transaction
517     /// @param _description String describing the proposal
518     /// @param _transactionData Data of the proposed transaction
519     /// @param _debatingPeriod Time used for debating a proposal, at least 2
520     /// weeks for a regular proposal, 10 days for new Curator proposal
521     /// @param _newCurator Bool defining whether this proposal is about
522     /// a new Curator or not
523     /// @return The proposal ID. Needed for voting on the proposal
524     function newProposal(
525         address _recipient,
526         uint _amount,
527         string _description,
528         bytes _transactionData,
529         uint _debatingPeriod,
530         bool _newCurator
531     ) onlyTokenholders returns (uint _proposalID);
532 
533     /// @notice Check that the proposal with the ID `_proposalID` matches the
534     /// transaction which sends `_amount` with data `_transactionData`
535     /// to `_recipient`
536     /// @param _proposalID The proposal ID
537     /// @param _recipient The recipient of the proposed transaction
538     /// @param _amount The amount of wei to be sent in the proposed transaction
539     /// @param _transactionData The data of the proposed transaction
540     /// @return Whether the proposal ID matches the transaction data or not
541     function checkProposalCode(
542         uint _proposalID,
543         address _recipient,
544         uint _amount,
545         bytes _transactionData
546     ) constant returns (bool _codeChecksOut);
547 
548     /// @notice Vote on proposal `_proposalID` with `_supportsProposal`
549     /// @param _proposalID The proposal ID
550     /// @param _supportsProposal Yes/No - support of the proposal
551     /// @return The vote ID.
552     function vote(
553         uint _proposalID,
554         bool _supportsProposal
555     ) onlyTokenholders returns (uint _voteID);
556 
557     /// @notice Checks whether proposal `_proposalID` with transaction data
558     /// `_transactionData` has been voted for or rejected, and executes the
559     /// transaction in the case it has been voted for.
560     /// @param _proposalID The proposal ID
561     /// @param _transactionData The data of the proposed transaction
562     /// @return Whether the proposed transaction has been executed or not
563     function executeProposal(
564         uint _proposalID,
565         bytes _transactionData
566     ) returns (bool _success);
567 
568     /// @notice ATTENTION! I confirm to move my remaining ether to a new DAO
569     /// with `_newCurator` as the new Curator, as has been
570     /// proposed in proposal `_proposalID`. This will burn my tokens. This can
571     /// not be undone and will split the DAO into two DAO's, with two
572     /// different underlying tokens.
573     /// @param _proposalID The proposal ID
574     /// @param _newCurator The new Curator of the new DAO
575     /// @dev This function, when called for the first time for this proposal,
576     /// will create a new DAO and send the sender's portion of the remaining
577     /// ether and Reward Tokens to the new DAO. It will also burn the DAO Tokens
578     /// of the sender.
579     function splitDAO(
580         uint _proposalID,
581         address _newCurator
582     ) returns (bool _success);
583 
584     /// @dev can only be called by the DAO itself through a proposal
585     /// updates the contract of the DAO by sending all ether and rewardTokens
586     /// to the new DAO. The new DAO needs to be approved by the Curator
587     /// @param _newContract the address of the new contract
588     function newContract(address _newContract);
589 
590 
591     /// @notice Add a new possible recipient `_recipient` to the whitelist so
592     /// that the DAO can send transactions to them (using proposals)
593     /// @param _recipient New recipient address
594     /// @dev Can only be called by the current Curator
595     /// @return Whether successful or not
596     function changeAllowedRecipients(address _recipient, bool _allowed) external returns (bool _success);
597 
598 
599     /// @notice Change the minimum deposit required to submit a proposal
600     /// @param _proposalDeposit The new proposal deposit
601     /// @dev Can only be called by this DAO (through proposals with the
602     /// recipient being this DAO itself)
603     function changeProposalDeposit(uint _proposalDeposit) external;
604 
605     /// @notice Move rewards from the DAORewards managed account
606     /// @param _toMembers If true rewards are moved to the actual reward account
607     ///                   for the DAO. If not then it's moved to the DAO itself
608     /// @return Whether the call was successful
609     function retrieveDAOReward(bool _toMembers) external returns (bool _success);
610 
611     /// @notice Get my portion of the reward that was sent to `rewardAccount`
612     /// @return Whether the call was successful
613     function getMyReward() returns(bool _success);
614 
615     /// @notice Withdraw `_account`'s portion of the reward from `rewardAccount`
616     /// to `_account`'s balance
617     /// @return Whether the call was successful
618     function withdrawRewardFor(address _account) internal returns (bool _success);
619 
620     /// @notice Send `_amount` tokens to `_to` from `msg.sender`. Prior to this
621     /// getMyReward() is called.
622     /// @param _to The address of the recipient
623     /// @param _amount The amount of tokens to be transfered
624     /// @return Whether the transfer was successful or not
625     function transferWithoutReward(address _to, uint256 _amount) returns (bool success);
626 
627     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
628     /// is approved by `_from`. Prior to this getMyReward() is called.
629     /// @param _from The address of the sender
630     /// @param _to The address of the recipient
631     /// @param _amount The amount of tokens to be transfered
632     /// @return Whether the transfer was successful or not
633     function transferFromWithoutReward(
634         address _from,
635         address _to,
636         uint256 _amount
637     ) returns (bool success);
638 
639     /// @notice Doubles the 'minQuorumDivisor' in the case quorum has not been
640     /// achieved in 52 weeks
641     /// @return Whether the change was successful or not
642     function halveMinQuorum() returns (bool _success);
643 
644     /// @return total number of proposals ever created
645     function numberOfProposals() constant returns (uint _numberOfProposals);
646 
647     /// @param _proposalID Id of the new curator proposal
648     /// @return Address of the new DAO
649     function getNewDAOAddress(uint _proposalID) constant returns (address _newDAO);
650 
651     /// @param _account The address of the account which is checked.
652     /// @return Whether the account is blocked (not allowed to transfer tokens) or not.
653     function isBlocked(address _account) internal returns (bool);
654 
655     /// @notice If the caller is blocked by a proposal whose voting deadline
656     /// has exprired then unblock him.
657     /// @return Whether the account is blocked (not allowed to transfer tokens) or not.
658     function unblockMe() returns (bool);
659 
660     event ProposalAdded(
661         uint indexed proposalID,
662         address recipient,
663         uint amount,
664         bool newCurator,
665         string description
666     );
667     event Voted(uint indexed proposalID, bool position, address indexed voter);
668     event ProposalTallied(uint indexed proposalID, bool result, uint quorum);
669     event NewCurator(address indexed _newCurator);
670     event AllowedRecipientChanged(address indexed _recipient, bool _allowed);
671 }
672 
673 // The DAO contract itself
674 contract MICRODAO is DAOInterface, Token, TokenCreation {
675 
676     // Modifier that allows only shareholders to vote and create new proposals
677     modifier onlyTokenholders {
678         if (balanceOf(msg.sender) == 0) throw;
679             _
680     }
681 
682     function MICRODAO(
683         address _curator,
684         DAO_Creator _daoCreator,
685         uint _proposalDeposit,
686         uint _minTokensToCreate,
687         uint _closingTime,
688         address _privateCreation
689     ) TokenCreation(_minTokensToCreate, _closingTime, _privateCreation) {
690 
691         curator = _curator;
692         daoCreator = _daoCreator;
693         proposalDeposit = _proposalDeposit;
694         rewardAccount = new ManagedAccount(address(this), false);
695         DAOrewardAccount = new ManagedAccount(address(this), false);
696         if (address(rewardAccount) == 0)
697             throw;
698         if (address(DAOrewardAccount) == 0)
699             throw;
700         lastTimeMinQuorumMet = now;
701         minQuorumDivisor = 5; // sets the minimal quorum to 20%
702         proposals.length = 1; // avoids a proposal with ID 0 because it is used
703 
704         allowedRecipients[address(this)] = true;
705         allowedRecipients[curator] = true;
706     }
707 
708     function () returns (bool success) {
709         if (now < closingTime + creationGracePeriod && msg.sender != address(extraBalance))
710             return createTokenProxy(msg.sender);
711         else
712             return receiveEther();
713     }
714 
715 
716     function receiveEther() returns (bool) {
717         return true;
718     }
719 
720 
721     function newProposal(
722         address _recipient,
723         uint _amount,
724         string _description,
725         bytes _transactionData,
726         uint _debatingPeriod,
727         bool _newCurator
728     ) onlyTokenholders returns (uint _proposalID) {
729 
730         // Sanity check
731         if (_newCurator && (
732             _amount != 0
733             || _transactionData.length != 0
734             || _recipient == curator
735             || msg.value > 0)) {
736             throw;
737         } else if (
738             !_newCurator
739             && (!isRecipientAllowed(_recipient) || (_debatingPeriod <  minProposalDebatePeriod))
740         ) {
741             throw;
742         }
743 
744         if (_debatingPeriod > 8 weeks)
745             throw;
746 
747         if (!isFueled
748             || now < closingTime
749             || (msg.value < proposalDeposit && !_newCurator)) {
750 
751             throw;
752         }
753 
754         if (now + _debatingPeriod < now) // prevents overflow
755             throw;
756 
757         // to prevent a 51% attacker to convert the ether into deposit
758         if (msg.sender == address(this))
759             throw;
760 
761         // to prevent curator from halving quorum before first proposal
762         if (proposals.length == 1) // initial length is 1 (see constructor)
763             lastTimeMinQuorumMet = now;
764 
765         _proposalID = proposals.length++;
766         Proposal p = proposals[_proposalID];
767         p.recipient = _recipient;
768         p.amount = _amount;
769         p.description = _description;
770         p.proposalHash = sha3(_recipient, _amount, _transactionData);
771         p.votingDeadline = now + _debatingPeriod;
772         p.open = true;
773         //p.proposalPassed = False; // that's default
774         p.newCurator = _newCurator;
775         if (_newCurator)
776             p.splitData.length++;
777         p.creator = msg.sender;
778         p.proposalDeposit = msg.value;
779 
780         sumOfProposalDeposits += msg.value;
781 
782         ProposalAdded(
783             _proposalID,
784             _recipient,
785             _amount,
786             _newCurator,
787             _description
788         );
789     }
790 
791 
792     function checkProposalCode(
793         uint _proposalID,
794         address _recipient,
795         uint _amount,
796         bytes _transactionData
797     ) noEther constant returns (bool _codeChecksOut) {
798         Proposal p = proposals[_proposalID];
799         return p.proposalHash == sha3(_recipient, _amount, _transactionData);
800     }
801 
802 
803     function vote(
804         uint _proposalID,
805         bool _supportsProposal
806     ) onlyTokenholders noEther returns (uint _voteID) {
807 
808         Proposal p = proposals[_proposalID];
809         if (p.votedYes[msg.sender]
810             || p.votedNo[msg.sender]
811             || now >= p.votingDeadline) {
812 
813             throw;
814         }
815 
816         if (_supportsProposal) {
817             p.yea += balances[msg.sender];
818             p.votedYes[msg.sender] = true;
819         } else {
820             p.nay += balances[msg.sender];
821             p.votedNo[msg.sender] = true;
822         }
823 
824         if (blocked[msg.sender] == 0) {
825             blocked[msg.sender] = _proposalID;
826         } else if (p.votingDeadline > proposals[blocked[msg.sender]].votingDeadline) {
827             // this proposal's voting deadline is further into the future than
828             // the proposal that blocks the sender so make it the blocker
829             blocked[msg.sender] = _proposalID;
830         }
831 
832         Voted(_proposalID, _supportsProposal, msg.sender);
833     }
834 
835 
836     function executeProposal(
837         uint _proposalID,
838         bytes _transactionData
839     ) noEther returns (bool _success) {
840 
841         Proposal p = proposals[_proposalID];
842 
843         uint waitPeriod = p.newCurator
844             ? splitExecutionPeriod
845             : executeProposalPeriod;
846         // If we are over deadline and waiting period, assert proposal is closed
847         if (p.open && now > p.votingDeadline + waitPeriod) {
848             closeProposal(_proposalID);
849             return;
850         }
851 
852         // Check if the proposal can be executed
853         if (now < p.votingDeadline  // has the voting deadline arrived?
854             // Have the votes been counted?
855             || !p.open
856             // Does the transaction code match the proposal?
857             || p.proposalHash != sha3(p.recipient, p.amount, _transactionData)) {
858 
859             throw;
860         }
861 
862         // If the curator removed the recipient from the whitelist, close the proposal
863         // in order to free the deposit and allow unblocking of voters
864         if (!isRecipientAllowed(p.recipient)) {
865             closeProposal(_proposalID);
866             p.creator.send(p.proposalDeposit);
867             return;
868         }
869 
870         bool proposalCheck = true;
871 
872         if (p.amount > actualBalance())
873             proposalCheck = false;
874 
875         uint quorum = p.yea + p.nay;
876 
877         // require 53% for calling newContract()
878         if (_transactionData.length >= 4 && _transactionData[0] == 0x68
879             && _transactionData[1] == 0x37 && _transactionData[2] == 0xff
880             && _transactionData[3] == 0x1e
881             && quorum < minQuorum(actualBalance() + rewardToken[address(this)])) {
882 
883                 proposalCheck = false;
884         }
885 
886         if (quorum >= minQuorum(p.amount)) {
887             if (!p.creator.send(p.proposalDeposit))
888                 throw;
889 
890             lastTimeMinQuorumMet = now;
891             // set the minQuorum to 20% again, in the case it has been reached
892             if (quorum > totalSupply / 5)
893                 minQuorumDivisor = 5;
894         }
895 
896         // Execute result
897         if (quorum >= minQuorum(p.amount) && p.yea > p.nay && proposalCheck) {
898             if (!p.recipient.call.value(p.amount)(_transactionData))
899                 throw;
900 
901             p.proposalPassed = true;
902             _success = true;
903 
904             // only create reward tokens when ether is not sent to the DAO itself and
905             // related addresses. Proxy addresses should be forbidden by the curator.
906             if (p.recipient != address(this) && p.recipient != address(rewardAccount)
907                 && p.recipient != address(DAOrewardAccount)
908                 && p.recipient != address(extraBalance)
909                 && p.recipient != address(curator)) {
910 
911                 rewardToken[address(this)] += p.amount;
912                 totalRewardToken += p.amount;
913             }
914         }
915 
916         closeProposal(_proposalID);
917 
918         // Initiate event
919         ProposalTallied(_proposalID, _success, quorum);
920     }
921 
922 
923     function closeProposal(uint _proposalID) internal {
924         Proposal p = proposals[_proposalID];
925         if (p.open)
926             sumOfProposalDeposits -= p.proposalDeposit;
927         p.open = false;
928     }
929 
930     function splitDAO(
931         uint _proposalID,
932         address _newCurator
933     ) noEther onlyTokenholders returns (bool _success) {
934 
935         Proposal p = proposals[_proposalID];
936 
937         // Sanity check
938 
939         if (now < p.votingDeadline  // has the voting deadline arrived?
940             //The request for a split expires XX days after the voting deadline
941             || now > p.votingDeadline + splitExecutionPeriod
942             // Does the new Curator address match?
943             || p.recipient != _newCurator
944             // Is it a new curator proposal?
945             || !p.newCurator
946             // Have you voted for this split?
947             || !p.votedYes[msg.sender]
948             // Did you already vote on another proposal?
949             || (blocked[msg.sender] != _proposalID && blocked[msg.sender] != 0) )  {
950 
951             throw;
952         }
953 
954         // If the new DAO doesn't exist yet, create the new DAO and store the
955         // current split data
956         if (address(p.splitData[0].newDAO) == 0) {
957             p.splitData[0].newDAO = createNewDAO(_newCurator);
958             // Call depth limit reached, etc.
959             if (address(p.splitData[0].newDAO) == 0)
960                 throw;
961             // should never happen
962             if (this.balance < sumOfProposalDeposits)
963                 throw;
964             p.splitData[0].splitBalance = actualBalance();
965             p.splitData[0].rewardToken = rewardToken[address(this)];
966             p.splitData[0].totalSupply = totalSupply;
967             p.proposalPassed = true;
968         }
969 
970         // Move ether and assign new Tokens
971         uint fundsToBeMoved =
972             (balances[msg.sender] * p.splitData[0].splitBalance) /
973             p.splitData[0].totalSupply;
974         if (p.splitData[0].newDAO.createTokenProxy.value(fundsToBeMoved)(msg.sender) == false)
975             throw;
976 
977 
978         // Assign reward rights to new DAO
979         uint rewardTokenToBeMoved =
980             (balances[msg.sender] * p.splitData[0].rewardToken) /
981             p.splitData[0].totalSupply;
982 
983         uint paidOutToBeMoved = DAOpaidOut[address(this)] * rewardTokenToBeMoved /
984             rewardToken[address(this)];
985 
986         rewardToken[address(p.splitData[0].newDAO)] += rewardTokenToBeMoved;
987         if (rewardToken[address(this)] < rewardTokenToBeMoved)
988             throw;
989         rewardToken[address(this)] -= rewardTokenToBeMoved;
990 
991         DAOpaidOut[address(p.splitData[0].newDAO)] += paidOutToBeMoved;
992         if (DAOpaidOut[address(this)] < paidOutToBeMoved)
993             throw;
994         DAOpaidOut[address(this)] -= paidOutToBeMoved;
995 
996         // Burn DAO Tokens
997         Transfer(msg.sender, 0, balances[msg.sender]);
998         withdrawRewardFor(msg.sender); // be nice, and get his rewards
999         totalSupply -= balances[msg.sender];
1000         balances[msg.sender] = 0;
1001         paidOut[msg.sender] = 0;
1002         return true;
1003     }
1004 
1005     function newContract(address _newContract){
1006         if (msg.sender != address(this) || !allowedRecipients[_newContract]) return;
1007         // move all ether
1008         if (!_newContract.call.value(address(this).balance)()) {
1009             throw;
1010         }
1011 
1012         //move all reward tokens
1013         rewardToken[_newContract] += rewardToken[address(this)];
1014         rewardToken[address(this)] = 0;
1015         DAOpaidOut[_newContract] += DAOpaidOut[address(this)];
1016         DAOpaidOut[address(this)] = 0;
1017     }
1018 
1019 
1020     function retrieveDAOReward(bool _toMembers) external noEther returns (bool _success) {
1021         MICRODAO dao = MICRODAO(msg.sender);
1022 
1023         if ((rewardToken[msg.sender] * DAOrewardAccount.accumulatedInput()) /
1024             totalRewardToken < DAOpaidOut[msg.sender])
1025             throw;
1026 
1027         uint reward =
1028             (rewardToken[msg.sender] * DAOrewardAccount.accumulatedInput()) /
1029             totalRewardToken - DAOpaidOut[msg.sender];
1030 
1031         reward = DAOrewardAccount.balance < reward ? DAOrewardAccount.balance : reward;
1032 
1033         if(_toMembers) {
1034             if (!DAOrewardAccount.payOut(dao.rewardAccount(), reward))
1035                 throw;
1036             }
1037         else {
1038             if (!DAOrewardAccount.payOut(dao, reward))
1039                 throw;
1040         }
1041         DAOpaidOut[msg.sender] += reward;
1042         return true;
1043     }
1044 
1045     function getMyReward() noEther returns (bool _success) {
1046         return withdrawRewardFor(msg.sender);
1047     }
1048 
1049 
1050     function withdrawRewardFor(address _account) noEther internal returns (bool _success) {
1051         if ((balanceOf(_account) * rewardAccount.accumulatedInput()) / totalSupply < paidOut[_account])
1052             throw;
1053 
1054         uint reward =
1055             (balanceOf(_account) * rewardAccount.accumulatedInput()) / totalSupply - paidOut[_account];
1056 
1057         reward = rewardAccount.balance < reward ? rewardAccount.balance : reward;
1058 
1059         if (!rewardAccount.payOut(_account, reward))
1060             throw;
1061         paidOut[_account] += reward;
1062         return true;
1063     }
1064 
1065 
1066     function transfer(address _to, uint256 _value) returns (bool success) {
1067         if (isFueled
1068             && now > closingTime
1069             && !isBlocked(msg.sender)
1070             && transferPaidOut(msg.sender, _to, _value)
1071             && super.transfer(_to, _value)) {
1072 
1073             return true;
1074         } else {
1075             throw;
1076         }
1077     }
1078 
1079 
1080     function transferWithoutReward(address _to, uint256 _value) returns (bool success) {
1081         if (!getMyReward())
1082             throw;
1083         return transfer(_to, _value);
1084     }
1085 
1086 
1087     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
1088         if (isFueled
1089             && now > closingTime
1090             && !isBlocked(_from)
1091             && transferPaidOut(_from, _to, _value)
1092             && super.transferFrom(_from, _to, _value)) {
1093 
1094             return true;
1095         } else {
1096             throw;
1097         }
1098     }
1099 
1100 
1101     function transferFromWithoutReward(
1102         address _from,
1103         address _to,
1104         uint256 _value
1105     ) returns (bool success) {
1106 
1107         if (!withdrawRewardFor(_from))
1108             throw;
1109         return transferFrom(_from, _to, _value);
1110     }
1111 
1112 
1113     function transferPaidOut(
1114         address _from,
1115         address _to,
1116         uint256 _value
1117     ) internal returns (bool success) {
1118 
1119         uint transferPaidOut = paidOut[_from] * _value / balanceOf(_from);
1120         if (transferPaidOut > paidOut[_from])
1121             throw;
1122         paidOut[_from] -= transferPaidOut;
1123         paidOut[_to] += transferPaidOut;
1124         return true;
1125     }
1126 
1127 
1128     function changeProposalDeposit(uint _proposalDeposit) noEther external {
1129         if (msg.sender != address(this) || _proposalDeposit > (actualBalance() + rewardToken[address(this)])
1130             / maxDepositDivisor) {
1131 
1132             throw;
1133         }
1134         proposalDeposit = _proposalDeposit;
1135     }
1136 
1137 
1138     function changeAllowedRecipients(address _recipient, bool _allowed) noEther external returns (bool _success) {
1139         if (msg.sender != curator)
1140             throw;
1141         allowedRecipients[_recipient] = _allowed;
1142         AllowedRecipientChanged(_recipient, _allowed);
1143         return true;
1144     }
1145 
1146 
1147     function isRecipientAllowed(address _recipient) internal returns (bool _isAllowed) {
1148         if (allowedRecipients[_recipient]
1149             || (_recipient == address(extraBalance)
1150                 // only allowed when at least the amount held in the
1151                 // extraBalance account has been spent from the DAO
1152                 && totalRewardToken > extraBalance.accumulatedInput()))
1153             return true;
1154         else
1155             return false;
1156     }
1157 
1158     function actualBalance() constant returns (uint _actualBalance) {
1159         return this.balance - sumOfProposalDeposits;
1160     }
1161 
1162 
1163     function minQuorum(uint _value) internal constant returns (uint _minQuorum) {
1164         // minimum of 20% and maximum of 53.33%
1165         return totalSupply / minQuorumDivisor +
1166             (_value * totalSupply) / (3 * (actualBalance() + rewardToken[address(this)]));
1167     }
1168 
1169 
1170     function halveMinQuorum() returns (bool _success) {
1171         // this can only be called after `quorumHalvingPeriod` has passed or at anytime after
1172         // fueling by the curator with a delay of at least `minProposalDebatePeriod`
1173         // between the calls
1174         if ((lastTimeMinQuorumMet < (now - quorumHalvingPeriod) || msg.sender == curator)
1175             && lastTimeMinQuorumMet < (now - minProposalDebatePeriod)
1176             && now >= closingTime
1177             && proposals.length > 1) {
1178             lastTimeMinQuorumMet = now;
1179             minQuorumDivisor *= 2;
1180             return true;
1181         } else {
1182             return false;
1183         }
1184     }
1185 
1186     function createNewDAO(address _newCurator) internal returns (MICRODAO _newDAO) {
1187         NewCurator(_newCurator);
1188         return daoCreator.createDAO(_newCurator, 0, 0, now + splitExecutionPeriod);
1189     }
1190 
1191     function numberOfProposals() constant returns (uint _numberOfProposals) {
1192         // Don't count index 0. It's used by isBlocked() and exists from start
1193         return proposals.length - 1;
1194     }
1195 
1196     function getNewDAOAddress(uint _proposalID) constant returns (address _newDAO) {
1197         return proposals[_proposalID].splitData[0].newDAO;
1198     }
1199 
1200     function isBlocked(address _account) internal returns (bool) {
1201         if (blocked[_account] == 0)
1202             return false;
1203         Proposal p = proposals[blocked[_account]];
1204         if (now > p.votingDeadline) {
1205             blocked[_account] = 0;
1206             return false;
1207         } else {
1208             return true;
1209         }
1210     }
1211 
1212     function unblockMe() returns (bool) {
1213         return isBlocked(msg.sender);
1214     }
1215 }
1216 
1217 contract DAO_Creator {
1218     function createDAO(
1219         address _curator,
1220         uint _proposalDeposit,
1221         uint _minTokensToCreate,
1222         uint _closingTime
1223     ) returns (MICRODAO _newDAO) {
1224 
1225         return new MICRODAO(
1226             _curator,
1227             DAO_Creator(this),
1228             _proposalDeposit,
1229             _minTokensToCreate,
1230             _closingTime,
1231             msg.sender
1232         );
1233     }
1234 }