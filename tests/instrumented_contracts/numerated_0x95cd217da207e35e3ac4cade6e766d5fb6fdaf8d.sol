1 pragma solidity ^0.4.23;
2 
3 /**
4 
5                           ███████╗███████╗████████╗██╗  ██╗██████╗
6                           ╚══███╔╝██╔════╝╚══██╔══╝██║  ██║██╔══██╗
7                             ███╔╝ █████╗     ██║   ███████║██████╔╝
8                            ███╔╝  ██╔══╝     ██║   ██╔══██║██╔══██╗
9                           ███████╗███████╗   ██║   ██║  ██║██║  ██║
10                           ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
11 
12 
13 .------..------.     .------..------..------.     .------..------..------..------..------.
14 |B.--. ||E.--. |.-.  |T.--. ||H.--. ||E.--. |.-.  |H.--. ||O.--. ||U.--. ||S.--. ||E.--. |
15 | :(): || (\/) (( )) | :/\: || :/\: || (\/) (( )) | :/\: || :/\: || (\/) || :/\: || (\/) |
16 | ()() || :\/: |'-.-.| (__) || (__) || :\/: |'-.-.| (__) || :\/: || :\/: || :\/: || :\/: |
17 | '--'B|| '--'E| (( )) '--'T|| '--'H|| '--'E| (( )) '--'H|| '--'O|| '--'U|| '--'S|| '--'E|
18 `------'`------'  '-'`------'`------'`------'  '-'`------'`------'`------'`------'`------'
19 
20 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
21 
22 Bankroll contract, containing tokens purchased from all dividend-card profit and ICO dividends.
23 Acts as token repository for games on the Zethr platform.
24 
25 Launched at 00:00 GMT on 12th May 2018.
26 
27 Credits
28 =======
29 
30 Analysis:
31     blurr
32     Randall
33 
34 Contract Developers:
35     Etherguy
36     klob
37     Norsefire
38 
39 Front-End Design:
40     cryptodude
41     oguzhanox
42     TropicalRogue
43 
44 **/
45 
46 contract ZTHInterface {
47         function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass) public payable returns (uint);
48         function balanceOf(address who) public view returns (uint);
49         function transfer(address _to, uint _value)     public returns (bool);
50         function transferFrom(address _from, address _toAddress, uint _amountOfTokens) public returns (bool);
51         function exit() public;
52         function sell(uint amountOfTokens) public;
53         function withdraw(address _recipient) public;
54 }
55 
56 contract ERC223Receiving {
57     function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
58 }
59 
60 contract ZethrBankroll is ERC223Receiving {
61     using SafeMath for uint;
62 
63     /*=================================
64     =              EVENTS            =
65     =================================*/
66 
67     event Confirmation(address indexed sender, uint indexed transactionId);
68     event Revocation(address indexed sender, uint indexed transactionId);
69     event Submission(uint indexed transactionId);
70     event Execution(uint indexed transactionId);
71     event ExecutionFailure(uint indexed transactionId);
72     event Deposit(address indexed sender, uint value);
73     event OwnerAddition(address indexed owner);
74     event OwnerRemoval(address indexed owner);
75     event WhiteListAddition(address indexed contractAddress);
76     event WhiteListRemoval(address indexed contractAddress);
77     event RequirementChange(uint required);
78     event DevWithdraw(uint amountTotal, uint amountPerPerson);
79     event EtherLogged(uint amountReceived, address sender);
80     event BankrollInvest(uint amountReceived);
81     event DailyTokenAdmin(address gameContract);
82     event DailyTokensSent(address gameContract, uint tokens);
83     event DailyTokensReceived(address gameContract, uint tokens);
84 
85     /*=================================
86     =        WITHDRAWAL CONSTANTS     =
87     =================================*/
88 
89     uint constant public MAX_OWNER_COUNT = 10;
90     uint constant public MAX_WITHDRAW_PCT_DAILY = 15;
91     uint constant public MAX_WITHDRAW_PCT_TX = 5;
92     uint constant internal resetTimer = 1 days;
93 
94     /*=================================
95     =          ZTH INTERFACE          =
96     =================================*/
97 
98     address internal zethrAddress;
99     ZTHInterface public ZTHTKN;
100 
101     /*=================================
102     =             VARIABLES           =
103     =================================*/
104 
105     mapping (uint => Transaction) public transactions;
106     mapping (uint => mapping (address => bool)) public confirmations;
107     mapping (address => bool) public isOwner;
108     mapping (address => bool) public isWhitelisted;
109     mapping (address => uint) public dailyTokensPerContract;
110     address internal divCardAddress;
111     address[] public owners;
112     address[] public whiteListedContracts;
113     uint public required;
114     uint public transactionCount;
115     uint internal dailyResetTime;
116     uint internal dailyTknLimit;
117     uint internal tknsDispensedToday;
118     bool internal reEntered = false;
119 
120     /*=================================
121     =         CUSTOM CONSTRUCTS       =
122     =================================*/
123 
124     struct Transaction {
125         address destination;
126         uint value;
127         bytes data;
128         bool executed;
129     }
130 
131     struct TKN {
132         address sender;
133         uint value;
134     }
135 
136     /*=================================
137     =            MODIFIERS            =
138     =================================*/
139 
140     modifier onlyWallet() {
141         if (msg.sender != address(this))
142             revert();
143         _;
144     }
145 
146     modifier contractIsNotWhiteListed(address contractAddress) {
147         if (isWhitelisted[contractAddress])
148             revert();
149         _;
150     }
151 
152     modifier contractIsWhiteListed(address contractAddress) {
153         if (!isWhitelisted[contractAddress])
154             revert();
155         _;
156     }
157 
158     modifier isAnOwner() {
159         address caller = msg.sender;
160         if (!isOwner[caller])
161             revert();
162         _;
163     }
164 
165     modifier ownerDoesNotExist(address owner) {
166         if (isOwner[owner])
167             revert();
168         _;
169     }
170 
171     modifier ownerExists(address owner) {
172         if (!isOwner[owner])
173             revert();
174         _;
175     }
176 
177     modifier transactionExists(uint transactionId) {
178         if (transactions[transactionId].destination == 0)
179             revert();
180         _;
181     }
182 
183     modifier confirmed(uint transactionId, address owner) {
184         if (!confirmations[transactionId][owner])
185             revert();
186         _;
187     }
188 
189     modifier notConfirmed(uint transactionId, address owner) {
190         if (confirmations[transactionId][owner])
191             revert();
192         _;
193     }
194 
195     modifier notExecuted(uint transactionId) {
196         if (transactions[transactionId].executed)
197             revert();
198         _;
199     }
200 
201     modifier notNull(address _address) {
202         if (_address == 0)
203             revert();
204         _;
205     }
206 
207     modifier validRequirement(uint ownerCount, uint _required) {
208         if (   ownerCount > MAX_OWNER_COUNT
209             || _required > ownerCount
210             || _required == 0
211             || ownerCount == 0)
212             revert();
213         _;
214     }
215 
216     /*=================================
217     =          LIST OF OWNERS         =
218     =================================*/
219 
220     /*
221         This list is for reference/identification purposes only, and comprises the eight core Zethr developers.
222         For game contracts to be listed, they must be approved by a majority (i.e. currently five) of the owners.
223         Contracts can be delisted in an emergency by a single owner.
224 
225         0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae // Norsefire
226         0x11e52c75998fe2E7928B191bfc5B25937Ca16741 // klob
227         0x20C945800de43394F70D789874a4daC9cFA57451 // Etherguy
228         0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB // blurr
229         0x8537aa2911b193e5B377938A723D805bb0865670 // oguzhanox
230         0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3 // Randall
231         0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696 // cryptodude
232         0xDa83156106c4dba7A26E9bF2Ca91E273350aa551 // TropicalRogue
233     */
234 
235 
236     /*=================================
237     =         PUBLIC FUNCTIONS        =
238     =================================*/
239 
240     /// @dev Contract constructor sets initial owners and required number of confirmations.
241     /// @param _owners List of initial owners.
242     /// @param _required Number of required confirmations.
243     constructor (address[] _owners, uint _required)
244         public
245         validRequirement(_owners.length, _required)
246     {
247         for (uint i=0; i<_owners.length; i++) {
248             if (isOwner[_owners[i]] || _owners[i] == 0)
249                 revert();
250             isOwner[_owners[i]] = true;
251         }
252         owners = _owners;
253         required = _required;
254 
255         dailyResetTime = now - (1 days);
256     }
257 
258     /** Testing only.
259     function exitAll()
260         public
261     {
262         uint tokenBalance = ZTHTKN.balanceOf(address(this));
263         ZTHTKN.sell(tokenBalance - 1e18);
264         ZTHTKN.sell(1e18);
265         ZTHTKN.withdraw(address(0x0));
266     }
267     **/
268 
269     function addZethrAddresses(address _zethr, address _divcards)
270         public
271         isAnOwner
272     {
273         zethrAddress   = _zethr;
274         divCardAddress = _divcards;
275         ZTHTKN = ZTHInterface(zethrAddress);
276     }
277 
278     /// @dev Fallback function allows Ether to be deposited.
279     function()
280         public
281         payable
282     {
283 
284     }
285 
286     uint NonICOBuyins;
287 
288     function deposit()
289         public
290         payable
291     {
292         NonICOBuyins = NonICOBuyins.add(msg.value);
293     }
294 
295     mapping(address => uint) playerRoundSendMSG;
296     mapping(address => uint) playerRoundSendTime;
297 
298     uint playerTotalRounds = 100; // init to prevent underflows 
299 
300     function DumpDivs() public {
301         require(tx.origin == msg.sender);
302         require((now - 1 hours) >= playerRoundSendTime[msg.sender]);
303         require((playerRoundSendMSG[msg.sender]+100) >= playerTotalRounds);
304         playerRoundSendMSG[msg.sender] = playerTotalRounds;
305         playerRoundSendTime[msg.sender] = now;
306         playerTotalRounds = playerTotalRounds + 1;
307         ZTHTKN.buyAndSetDivPercentage.value(NonICOBuyins)(msg.sender, 33, "");
308     }
309 
310     /// @dev Function to buy tokens with contract eth balance.
311     function buyTokens()
312         public
313         payable
314         isAnOwner
315     {
316         uint savings = address(this).balance;
317         if (savings > 0.01 ether) {
318             ZTHTKN.buyAndSetDivPercentage.value(savings)(address(0x0), 33, "");
319             emit BankrollInvest(savings);
320         }
321         else {
322             emit EtherLogged(msg.value, msg.sender);
323         }
324     }
325 
326 		function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/) public returns (bool) {
327 			// Nothing, for now. Just receives tokens.
328 		}	
329 
330     /// @dev Calculates if an amount of tokens exceeds the aggregate daily limit of 15% of contract
331     ///        balance or 5% of the contract balance on its own.
332     function permissibleTokenWithdrawal(uint _toWithdraw)
333         public
334         returns(bool)
335     {
336         uint currentTime     = now;
337         uint tokenBalance    = ZTHTKN.balanceOf(address(this));
338         uint maxPerTx        = (tokenBalance.mul(MAX_WITHDRAW_PCT_TX)).div(100);
339 
340         require (_toWithdraw <= maxPerTx);
341 
342         if (currentTime - dailyResetTime >= resetTimer)
343             {
344                 dailyResetTime     = currentTime;
345                 dailyTknLimit      = (tokenBalance.mul(MAX_WITHDRAW_PCT_DAILY)).div(100);
346                 tknsDispensedToday = _toWithdraw;
347                 return true;
348             }
349         else
350             {
351                 if (tknsDispensedToday.add(_toWithdraw) <= dailyTknLimit)
352                     {
353                         tknsDispensedToday += _toWithdraw;
354                         return true;
355                     }
356                 else { return false; }
357             }
358     }
359 
360     /// @dev Allows us to set the daily Token Limit
361     function setDailyTokenLimit(uint limit)
362       public
363       isAnOwner
364     {
365       dailyTknLimit = limit;
366     }
367 
368     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
369     /// @param owner Address of new owner.
370     function addOwner(address owner)
371         public
372         onlyWallet
373         ownerDoesNotExist(owner)
374         notNull(owner)
375         validRequirement(owners.length + 1, required)
376     {
377         isOwner[owner] = true;
378         owners.push(owner);
379         emit OwnerAddition(owner);
380     }
381 
382     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
383     /// @param owner Address of owner.
384     function removeOwner(address owner)
385         public
386         onlyWallet
387         ownerExists(owner)
388         validRequirement(owners.length, required)
389     {
390         isOwner[owner] = false;
391         for (uint i=0; i<owners.length - 1; i++)
392             if (owners[i] == owner) {
393                 owners[i] = owners[owners.length - 1];
394                 break;
395             }
396         owners.length -= 1;
397         if (required > owners.length)
398             changeRequirement(owners.length);
399         emit OwnerRemoval(owner);
400     }
401 
402     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
403     /// @param owner Address of owner to be replaced.
404     /// @param owner Address of new owner.
405     function replaceOwner(address owner, address newOwner)
406         public
407         onlyWallet
408         ownerExists(owner)
409         ownerDoesNotExist(newOwner)
410     {
411         for (uint i=0; i<owners.length; i++)
412             if (owners[i] == owner) {
413                 owners[i] = newOwner;
414                 break;
415             }
416         isOwner[owner] = false;
417         isOwner[newOwner] = true;
418         emit OwnerRemoval(owner);
419         emit OwnerAddition(newOwner);
420     }
421 
422     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
423     /// @param _required Number of required confirmations.
424     function changeRequirement(uint _required)
425         public
426         onlyWallet
427         validRequirement(owners.length, _required)
428     {
429         required = _required;
430         emit RequirementChange(_required);
431     }
432 
433     /// @dev Allows an owner to submit and confirm a transaction.
434     /// @param destination Transaction target address.
435     /// @param value Transaction ether value.
436     /// @param data Transaction data payload.
437     /// @return Returns transaction ID.
438     function submitTransaction(address destination, uint value, bytes data)
439         public
440         returns (uint transactionId)
441     {
442         transactionId = addTransaction(destination, value, data);
443         confirmTransaction(transactionId);
444     }
445 
446     /// @dev Allows an owner to confirm a transaction.
447     /// @param transactionId Transaction ID.
448     function confirmTransaction(uint transactionId)
449         public
450         ownerExists(msg.sender)
451         transactionExists(transactionId)
452         notConfirmed(transactionId, msg.sender)
453     {
454         confirmations[transactionId][msg.sender] = true;
455         emit Confirmation(msg.sender, transactionId);
456         executeTransaction(transactionId);
457     }
458 
459     /// @dev Allows an owner to revoke a confirmation for a transaction.
460     /// @param transactionId Transaction ID.
461     function revokeConfirmation(uint transactionId)
462         public
463         ownerExists(msg.sender)
464         confirmed(transactionId, msg.sender)
465         notExecuted(transactionId)
466     {
467         confirmations[transactionId][msg.sender] = false;
468         emit Revocation(msg.sender, transactionId);
469     }
470 
471     /// @dev Allows anyone to execute a confirmed transaction.
472     /// @param transactionId Transaction ID.
473     function executeTransaction(uint transactionId)
474         public
475         notExecuted(transactionId)
476     {
477         if (isConfirmed(transactionId)) {
478             Transaction storage txToExecute = transactions[transactionId];
479             txToExecute.executed = true;
480             if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
481                 emit Execution(transactionId);
482             else {
483                 emit ExecutionFailure(transactionId);
484                 txToExecute.executed = false;
485             }
486         }
487     }
488 
489     /// @dev Returns the confirmation status of a transaction.
490     /// @param transactionId Transaction ID.
491     /// @return Confirmation status.
492     function isConfirmed(uint transactionId)
493         public
494         constant
495         returns (bool)
496     {
497         uint count = 0;
498         for (uint i=0; i<owners.length; i++) {
499             if (confirmations[transactionId][owners[i]])
500                 count += 1;
501             if (count == required)
502                 return true;
503         }
504     }
505 
506     /*=================================
507     =        OPERATOR FUNCTIONS       =
508     =================================*/
509 
510     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
511     /// @param destination Transaction target address.
512     /// @param value Transaction ether value.
513     /// @param data Transaction data payload.
514     /// @return Returns transaction ID.
515     function addTransaction(address destination, uint value, bytes data)
516         internal
517         notNull(destination)
518         returns (uint transactionId)
519     {
520         transactionId = transactionCount;
521         transactions[transactionId] = Transaction({
522             destination: destination,
523             value: value,
524             data: data,
525             executed: false
526         });
527         transactionCount += 1;
528         emit Submission(transactionId);
529     }
530 
531     /*
532      * Web3 call functions
533      */
534     /// @dev Returns number of confirmations of a transaction.
535     /// @param transactionId Transaction ID.
536     /// @return Number of confirmations.
537     function getConfirmationCount(uint transactionId)
538         public
539         constant
540         returns (uint count)
541     {
542         for (uint i=0; i<owners.length; i++)
543             if (confirmations[transactionId][owners[i]])
544                 count += 1;
545     }
546 
547     /// @dev Returns total number of transactions after filers are applied.
548     /// @param pending Include pending transactions.
549     /// @param executed Include executed transactions.
550     /// @return Total number of transactions after filters are applied.
551     function getTransactionCount(bool pending, bool executed)
552         public
553         constant
554         returns (uint count)
555     {
556         for (uint i=0; i<transactionCount; i++)
557             if (   pending && !transactions[i].executed
558                 || executed && transactions[i].executed)
559                 count += 1;
560     }
561 
562     /// @dev Returns list of owners.
563     /// @return List of owner addresses.
564     function getOwners()
565         public
566         constant
567         returns (address[])
568     {
569         return owners;
570     }
571 
572     /// @dev Returns array with owner addresses, which confirmed transaction.
573     /// @param transactionId Transaction ID.
574     /// @return Returns array of owner addresses.
575     function getConfirmations(uint transactionId)
576         public
577         constant
578         returns (address[] _confirmations)
579     {
580         address[] memory confirmationsTemp = new address[](owners.length);
581         uint count = 0;
582         uint i;
583         for (i=0; i<owners.length; i++)
584             if (confirmations[transactionId][owners[i]]) {
585                 confirmationsTemp[count] = owners[i];
586                 count += 1;
587             }
588         _confirmations = new address[](count);
589         for (i=0; i<count; i++)
590             _confirmations[i] = confirmationsTemp[i];
591     }
592 
593     /// @dev Returns list of transaction IDs in defined range.
594     /// @param from Index start position of transaction array.
595     /// @param to Index end position of transaction array.
596     /// @param pending Include pending transactions.
597     /// @param executed Include executed transactions.
598     /// @return Returns array of transaction IDs.
599     function getTransactionIds(uint from, uint to, bool pending, bool executed)
600         public
601         constant
602         returns (uint[] _transactionIds)
603     {
604         uint[] memory transactionIdsTemp = new uint[](transactionCount);
605         uint count = 0;
606         uint i;
607         for (i=0; i<transactionCount; i++)
608             if (   pending && !transactions[i].executed
609                 || executed && transactions[i].executed)
610             {
611                 transactionIdsTemp[count] = i;
612                 count += 1;
613             }
614         _transactionIds = new uint[](to - from);
615         for (i=from; i<to; i++)
616             _transactionIds[i - from] = transactionIdsTemp[i];
617     }
618 
619     // Additions for Bankroll
620     function whiteListContract(address contractAddress)
621         public
622         isAnOwner
623         contractIsNotWhiteListed(contractAddress)
624         notNull(contractAddress)
625     {
626         isWhitelisted[contractAddress] = true;
627         whiteListedContracts.push(contractAddress);
628         // We set the daily tokens for a particular contract in a separate call.
629         dailyTokensPerContract[contractAddress] = 0;
630         emit WhiteListAddition(contractAddress);
631     }
632 
633     // Remove a whitelisted contract. This is an exception to the norm in that
634     // it can be invoked directly by any owner, in the event that a game is found
635     // to be bugged or otherwise faulty, so it can be shut down as an emergency measure.
636     // Iterates through the whitelisted contracts to find contractAddress,
637     //  then swaps it with the last address in the list - then decrements length
638     function deWhiteListContract(address contractAddress)
639         public
640         isAnOwner
641         contractIsWhiteListed(contractAddress)
642     {
643         isWhitelisted[contractAddress] = false;
644         for (uint i=0; i < whiteListedContracts.length - 1; i++)
645             if (whiteListedContracts[i] == contractAddress) {
646                 whiteListedContracts[i] = owners[whiteListedContracts.length - 1];
647                 break;
648             }
649 
650         whiteListedContracts.length -= 1;
651 
652         emit WhiteListRemoval(contractAddress);
653     }
654 
655      function contractTokenWithdraw(uint amount, address target) public
656         contractIsWhiteListed(msg.sender)
657     {
658         require(isWhitelisted[msg.sender]);
659         require(ZTHTKN.transfer(target, amount));
660     }
661 
662     // Alters the amount of tokens allocated to a game contract on a daily basis.
663     function alterTokenGrant(address _contract, uint _newAmount)
664         public
665         isAnOwner
666         contractIsWhiteListed(_contract)
667     {
668         dailyTokensPerContract[_contract] = _newAmount;
669     }
670 
671     function queryTokenGrant(address _contract)
672         public
673         view
674         returns (uint)
675     {
676         return dailyTokensPerContract[_contract];
677     }
678 
679     // Function to be run by an owner (ideally on a cron job) which performs daily
680     // token collection and dispersal for all whitelisted contracts.
681     function dailyAccounting()
682         public
683         isAnOwner
684     {
685         for (uint i=0; i < whiteListedContracts.length; i++)
686             {
687                 address _contract = whiteListedContracts[i];
688                 if ( dailyTokensPerContract[_contract] > 0 )
689                     {
690                         allocateTokens(_contract);
691                         emit DailyTokenAdmin(_contract);
692                     }
693             }
694     }
695 
696     // In the event that we want to manually take tokens back from a whitelisted contract,
697     // we can do so.
698     function retrieveTokens(address _contract, uint _amount)
699         public
700         isAnOwner
701         contractIsWhiteListed(_contract)
702     {
703         require(ZTHTKN.transferFrom(_contract, address(this), _amount));
704     }
705 
706     // Dispenses daily amount of ZTH to whitelisted contract, or retrieves the excess.
707     // Block withdraws greater than MAX_WITHDRAW_PCT_TX of Zethr token balance.
708     // (May require occasional adjusting of the daily token allocation for contracts.)
709     function allocateTokens(address _contract)
710         public
711         isAnOwner
712         contractIsWhiteListed(_contract)
713     {
714         uint dailyAmount = dailyTokensPerContract[_contract];
715         uint zthPresent  = ZTHTKN.balanceOf(_contract);
716 
717         // Make sure that tokens aren't sent to a contract which is in the black.
718         if (zthPresent <= dailyAmount)
719         {
720             // We need to send tokens over, make sure it's a permitted amount, and then send.
721             uint toDispense  = dailyAmount.sub(zthPresent);
722 
723             // Make sure amount is <= tokenbalance*MAX_WITHDRAW_PCT_TX
724             require(permissibleTokenWithdrawal(toDispense));
725 
726             require(ZTHTKN.transfer(_contract, toDispense));
727             emit DailyTokensSent(_contract, toDispense);
728         } else
729         {
730             // The contract in question has made a profit: retrieve the excess tokens.
731             uint toRetrieve = zthPresent.sub(dailyAmount);
732             require(ZTHTKN.transferFrom(_contract, address(this), toRetrieve));
733             emit DailyTokensReceived(_contract, toRetrieve);
734 
735         }
736         emit DailyTokenAdmin(_contract);
737     }
738 
739     // Dev withdrawal of tokens - splits equally among all owners of contract
740     function devTokenWithdraw(uint amount) public
741         onlyWallet
742     {
743         require(permissibleTokenWithdrawal(amount));
744 
745         uint amountPerPerson = SafeMath.div(amount, owners.length);
746 
747         for (uint i=0; i<owners.length; i++) {
748             ZTHTKN.transfer(owners[i], amountPerPerson);
749         }
750 
751         emit DevWithdraw(amount, amountPerPerson);
752     }
753 
754     // Change the dividend card address. Can't see why this would ever need
755     // to be invoked, but better safe than sorry.
756     function changeDivCardAddress(address _newDivCardAddress)
757         public
758         isAnOwner
759     {
760         divCardAddress = _newDivCardAddress;
761     }
762 
763     // Receive Ether (from Zethr itself or any other source) and purchase tokens at the 33% dividend rate.
764     // If the amount is less than 0.01 Ether, the Ether is stored by the contract until the balance
765     // exceeds that limit and then purchases all it can.
766     function receiveDividends() public payable {
767       if (!reEntered) {
768         uint ActualBalance = (address(this).balance.sub(NonICOBuyins));
769         if (ActualBalance > 0.01 ether) {
770           reEntered = true;
771           ZTHTKN.buyAndSetDivPercentage.value(ActualBalance)(address(0x0), 33, "");
772           emit BankrollInvest(ActualBalance);
773           reEntered = false;
774         }
775       }
776     }
777 
778     /*=================================
779     =            UTILITIES            =
780     =================================*/
781 
782     // Convert an hexadecimal character to their value
783     function fromHexChar(uint c) public pure returns (uint) {
784         if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
785             return c - uint(byte('0'));
786         }
787         if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
788             return 10 + c - uint(byte('a'));
789         }
790         if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
791             return 10 + c - uint(byte('A'));
792         }
793     }
794 
795     // Convert an hexadecimal string to raw bytes
796     function fromHex(string s) public pure returns (bytes) {
797         bytes memory ss = bytes(s);
798         require(ss.length%2 == 0); // length must be even
799         bytes memory r = new bytes(ss.length/2);
800         for (uint i=0; i<ss.length/2; ++i) {
801             r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +
802                     fromHexChar(uint(ss[2*i+1])));
803         }
804         return r;
805     }
806 }
807 
808 /**
809  * @title SafeMath
810  * @dev Math operations with safety checks that throw on error
811  */
812 library SafeMath {
813 
814     /**
815     * @dev Multiplies two numbers, throws on overflow.
816     */
817     function mul(uint a, uint b) internal pure returns (uint) {
818         if (a == 0) {
819             return 0;
820         }
821         uint c = a * b;
822         assert(c / a == b);
823         return c;
824     }
825 
826     /**
827     * @dev Integer division of two numbers, truncating the quotient.
828     */
829     function div(uint a, uint b) internal pure returns (uint) {
830         // assert(b > 0); // Solidity automatically throws when dividing by 0
831         uint c = a / b;
832         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
833         return c;
834     }
835 
836     /**
837     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
838     */
839     function sub(uint a, uint b) internal pure returns (uint) {
840         assert(b <= a);
841         return a - b;
842     }
843 
844     /**
845     * @dev Adds two numbers, throws on overflow.
846     */
847     function add(uint a, uint b) internal pure returns (uint) {
848         uint c = a + b;
849         assert(c >= a);
850         return c;
851     }
852 }