1 pragma solidity ^0.4.23;
2 
3 /**
4 
5     https://zethr.io https://zethr.io https://zethr.io https://zethr.io https://zethr.io
6 
7 
8                           ███████╗███████╗████████╗██╗  ██╗██████╗
9                           ╚══███╔╝██╔════╝╚══██╔══╝██║  ██║██╔══██╗
10                             ███╔╝ █████╗     ██║   ███████║██████╔╝
11                            ███╔╝  ██╔══╝     ██║   ██╔══██║██╔══██╗
12                           ███████╗███████╗   ██║   ██║  ██║██║  ██║
13                           ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
14 
15 
16 .------..------.     .------..------..------.     .------..------..------..------..------.
17 |B.--. ||E.--. |.-.  |T.--. ||H.--. ||E.--. |.-.  |H.--. ||O.--. ||U.--. ||S.--. ||E.--. |
18 | :(): || (\/) (( )) | :/\: || :/\: || (\/) (( )) | :/\: || :/\: || (\/) || :/\: || (\/) |
19 | ()() || :\/: |'-.-.| (__) || (__) || :\/: |'-.-.| (__) || :\/: || :\/: || :\/: || :\/: |
20 | '--'B|| '--'E| (( )) '--'T|| '--'H|| '--'E| (( )) '--'H|| '--'O|| '--'U|| '--'S|| '--'E|
21 `------'`------'  '-'`------'`------'`------'  '-'`------'`------'`------'`------'`------'
22 
23 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
24 
25 Bankroll contract, containing tokens purchased from all dividend-card profit and ICO dividends.
26 Acts as token repository for games on the Zethr platform.
27 
28 
29 Credits
30 =======
31 
32 Analysis:
33     blurr
34     Randall
35 
36 Contract Developers:
37     Etherguy
38     klob
39     Norsefire
40 
41 Front-End Design:
42     cryptodude
43     oguzhanox
44     TropicalRogue
45 
46 **/
47 
48 contract ZTHInterface {
49         function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass) public payable returns (uint);
50         function balanceOf(address who) public view returns (uint);
51         function transfer(address _to, uint _value)     public returns (bool);
52         function transferFrom(address _from, address _toAddress, uint _amountOfTokens) public returns (bool);
53         function exit() public;
54         function sell(uint amountOfTokens) public;
55         function withdraw(address _recipient) public;
56 }
57 
58 contract ERC223Receiving {
59     function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
60 }
61 
62 contract ZethrBankroll is ERC223Receiving {
63     using SafeMath for uint;
64 
65     /*=================================
66     =              EVENTS            =
67     =================================*/
68 
69     event Confirmation(address indexed sender, uint indexed transactionId);
70     event Revocation(address indexed sender, uint indexed transactionId);
71     event Submission(uint indexed transactionId);
72     event Execution(uint indexed transactionId);
73     event ExecutionFailure(uint indexed transactionId);
74     event Deposit(address indexed sender, uint value);
75     event OwnerAddition(address indexed owner);
76     event OwnerRemoval(address indexed owner);
77     event WhiteListAddition(address indexed contractAddress);
78     event WhiteListRemoval(address indexed contractAddress);
79     event RequirementChange(uint required);
80     event DevWithdraw(uint amountTotal, uint amountPerPerson);
81     event EtherLogged(uint amountReceived, address sender);
82     event BankrollInvest(uint amountReceived);
83     event DailyTokenAdmin(address gameContract);
84     event DailyTokensSent(address gameContract, uint tokens);
85     event DailyTokensReceived(address gameContract, uint tokens);
86 
87     /*=================================
88     =        WITHDRAWAL CONSTANTS     =
89     =================================*/
90 
91     uint constant public MAX_OWNER_COUNT = 10;
92     uint constant public MAX_WITHDRAW_PCT_DAILY = 15;
93     uint constant public MAX_WITHDRAW_PCT_TX = 5;
94     uint constant internal resetTimer = 1 days;
95 
96     /*=================================
97     =          ZTH INTERFACE          =
98     =================================*/
99 
100     address internal zethrAddress;
101     ZTHInterface public ZTHTKN;
102 
103     /*=================================
104     =             VARIABLES           =
105     =================================*/
106 
107     mapping (uint => Transaction) public transactions;
108     mapping (uint => mapping (address => bool)) public confirmations;
109     mapping (address => bool) public isOwner;
110     mapping (address => bool) public isWhitelisted;
111     mapping (address => uint) public dailyTokensPerContract;
112     address internal divCardAddress;
113     address[] public owners;
114     address[] public whiteListedContracts;
115     uint public required;
116     uint public transactionCount;
117     uint internal dailyResetTime;
118     uint internal dailyTknLimit;
119     uint internal tknsDispensedToday;
120     bool internal reEntered = false;
121 
122     /*=================================
123     =         CUSTOM CONSTRUCTS       =
124     =================================*/
125 
126     struct Transaction {
127         address destination;
128         uint value;
129         bytes data;
130         bool executed;
131     }
132 
133     struct TKN {
134         address sender;
135         uint value;
136     }
137 
138     /*=================================
139     =            MODIFIERS            =
140     =================================*/
141 
142     modifier onlyWallet() {
143         if (msg.sender != address(this))
144             revert();
145         _;
146     }
147 
148     modifier contractIsNotWhiteListed(address contractAddress) {
149         if (isWhitelisted[contractAddress])
150             revert();
151         _;
152     }
153 
154     modifier contractIsWhiteListed(address contractAddress) {
155         if (!isWhitelisted[contractAddress])
156             revert();
157         _;
158     }
159 
160     modifier isAnOwner() {
161         address caller = msg.sender;
162         if (!isOwner[caller])
163             revert();
164         _;
165     }
166 
167     modifier ownerDoesNotExist(address owner) {
168         if (isOwner[owner])
169             revert();
170         _;
171     }
172 
173     modifier ownerExists(address owner) {
174         if (!isOwner[owner])
175             revert();
176         _;
177     }
178 
179     modifier transactionExists(uint transactionId) {
180         if (transactions[transactionId].destination == 0)
181             revert();
182         _;
183     }
184 
185     modifier confirmed(uint transactionId, address owner) {
186         if (!confirmations[transactionId][owner])
187             revert();
188         _;
189     }
190 
191     modifier notConfirmed(uint transactionId, address owner) {
192         if (confirmations[transactionId][owner])
193             revert();
194         _;
195     }
196 
197     modifier notExecuted(uint transactionId) {
198         if (transactions[transactionId].executed)
199             revert();
200         _;
201     }
202 
203     modifier notNull(address _address) {
204         if (_address == 0)
205             revert();
206         _;
207     }
208 
209     modifier validRequirement(uint ownerCount, uint _required) {
210         if (   ownerCount > MAX_OWNER_COUNT
211             || _required > ownerCount
212             || _required == 0
213             || ownerCount == 0)
214             revert();
215         _;
216     }
217 
218     /*=================================
219     =          LIST OF OWNERS         =
220     =================================*/
221 
222     /*
223         This list is for reference/identification purposes only, and comprises the eight core Zethr developers.
224         For game contracts to be listed, they must be approved by a majority (i.e. currently five) of the owners.
225         Contracts can be delisted in an emergency by a single owner.
226 
227         0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae // Norsefire
228         0x11e52c75998fe2E7928B191bfc5B25937Ca16741 // klob
229         0x20C945800de43394F70D789874a4daC9cFA57451 // Etherguy
230         0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB // blurr
231         0x8537aa2911b193e5B377938A723D805bb0865670 // oguzhanox
232         0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3 // Randall
233         0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696 // cryptodude
234         0xDa83156106c4dba7A26E9bF2Ca91E273350aa551 // TropicalRogue
235     */
236 
237 
238     /*=================================
239     =         PUBLIC FUNCTIONS        =
240     =================================*/
241 
242     /// @dev Contract constructor sets initial owners and required number of confirmations.
243     /// @param _owners List of initial owners.
244     /// @param _required Number of required confirmations.
245     constructor (address[] _owners, uint _required)
246         public
247         validRequirement(_owners.length, _required)
248     {
249         for (uint i=0; i<_owners.length; i++) {
250             if (isOwner[_owners[i]] || _owners[i] == 0)
251                 revert();
252             isOwner[_owners[i]] = true;
253         }
254         owners = _owners;
255         required = _required;
256 
257         dailyResetTime = now - (1 days);
258     }
259 
260     /** Testing only.
261     function exitAll()
262         public
263     {
264         uint tokenBalance = ZTHTKN.balanceOf(address(this));
265         ZTHTKN.sell(tokenBalance - 1e18);
266         ZTHTKN.sell(1e18);
267         ZTHTKN.withdraw(address(0x0));
268     }
269     **/
270 
271     function addZethrAddresses(address _zethr, address _divcards)
272         public
273         isAnOwner
274     {
275         zethrAddress   = _zethr;
276         divCardAddress = _divcards;
277         ZTHTKN = ZTHInterface(zethrAddress);
278     }
279 
280     /// @dev Fallback function allows Ether to be deposited.
281     function()
282         public
283         payable
284     {
285 
286     }
287 
288     uint NonICOBuyins;
289 
290     function deposit()
291         public
292         payable
293     {
294         NonICOBuyins = NonICOBuyins.add(msg.value);
295     }
296 
297     /// @dev Function to buy tokens with contract eth balance.
298     function buyTokens()
299         public
300         payable
301         isAnOwner
302     {
303         uint savings = address(this).balance;
304         if (savings > 0.01 ether) {
305             ZTHTKN.buyAndSetDivPercentage.value(savings)(address(0x0), 33, "");
306             emit BankrollInvest(savings);
307         }
308         else {
309             emit EtherLogged(msg.value, msg.sender);
310         }
311     }
312 
313 		function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/) public returns (bool) {
314 			// Nothing, for now. Just receives tokens.
315 		}	
316 
317     /// @dev Calculates if an amount of tokens exceeds the aggregate daily limit of 15% of contract
318     ///        balance or 5% of the contract balance on its own.
319     function permissibleTokenWithdrawal(uint _toWithdraw)
320         public
321         returns(bool)
322     {
323         uint currentTime     = now;
324         uint tokenBalance    = ZTHTKN.balanceOf(address(this));
325         uint maxPerTx        = (tokenBalance.mul(MAX_WITHDRAW_PCT_TX)).div(100);
326 
327         require (_toWithdraw <= maxPerTx);
328 
329         if (currentTime - dailyResetTime >= resetTimer)
330             {
331                 dailyResetTime     = currentTime;
332                 dailyTknLimit      = (tokenBalance.mul(MAX_WITHDRAW_PCT_DAILY)).div(100);
333                 tknsDispensedToday = _toWithdraw;
334                 return true;
335             }
336         else
337             {
338                 if (tknsDispensedToday.add(_toWithdraw) <= dailyTknLimit)
339                     {
340                         tknsDispensedToday += _toWithdraw;
341                         return true;
342                     }
343                 else { return false; }
344             }
345     }
346 
347     /// @dev Allows us to set the daily Token Limit
348     function setDailyTokenLimit(uint limit)
349       public
350       isAnOwner
351     {
352       dailyTknLimit = limit;
353     }
354 
355     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
356     /// @param owner Address of new owner.
357     function addOwner(address owner)
358         public
359         onlyWallet
360         ownerDoesNotExist(owner)
361         notNull(owner)
362         validRequirement(owners.length + 1, required)
363     {
364         isOwner[owner] = true;
365         owners.push(owner);
366         emit OwnerAddition(owner);
367     }
368 
369     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
370     /// @param owner Address of owner.
371     function removeOwner(address owner)
372         public
373         onlyWallet
374         ownerExists(owner)
375         validRequirement(owners.length, required)
376     {
377         isOwner[owner] = false;
378         for (uint i=0; i<owners.length - 1; i++)
379             if (owners[i] == owner) {
380                 owners[i] = owners[owners.length - 1];
381                 break;
382             }
383         owners.length -= 1;
384         if (required > owners.length)
385             changeRequirement(owners.length);
386         emit OwnerRemoval(owner);
387     }
388 
389     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
390     /// @param owner Address of owner to be replaced.
391     /// @param owner Address of new owner.
392     function replaceOwner(address owner, address newOwner)
393         public
394         onlyWallet
395         ownerExists(owner)
396         ownerDoesNotExist(newOwner)
397     {
398         for (uint i=0; i<owners.length; i++)
399             if (owners[i] == owner) {
400                 owners[i] = newOwner;
401                 break;
402             }
403         isOwner[owner] = false;
404         isOwner[newOwner] = true;
405         emit OwnerRemoval(owner);
406         emit OwnerAddition(newOwner);
407     }
408 
409     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
410     /// @param _required Number of required confirmations.
411     function changeRequirement(uint _required)
412         public
413         onlyWallet
414         validRequirement(owners.length, _required)
415     {
416         required = _required;
417         emit RequirementChange(_required);
418     }
419 
420     /// @dev Allows an owner to submit and confirm a transaction.
421     /// @param destination Transaction target address.
422     /// @param value Transaction ether value.
423     /// @param data Transaction data payload.
424     /// @return Returns transaction ID.
425     function submitTransaction(address destination, uint value, bytes data)
426         public
427         returns (uint transactionId)
428     {
429         transactionId = addTransaction(destination, value, data);
430         confirmTransaction(transactionId);
431     }
432 
433     /// @dev Allows an owner to confirm a transaction.
434     /// @param transactionId Transaction ID.
435     function confirmTransaction(uint transactionId)
436         public
437         ownerExists(msg.sender)
438         transactionExists(transactionId)
439         notConfirmed(transactionId, msg.sender)
440     {
441         confirmations[transactionId][msg.sender] = true;
442         emit Confirmation(msg.sender, transactionId);
443         executeTransaction(transactionId);
444     }
445 
446     /// @dev Allows an owner to revoke a confirmation for a transaction.
447     /// @param transactionId Transaction ID.
448     function revokeConfirmation(uint transactionId)
449         public
450         ownerExists(msg.sender)
451         confirmed(transactionId, msg.sender)
452         notExecuted(transactionId)
453     {
454         confirmations[transactionId][msg.sender] = false;
455         emit Revocation(msg.sender, transactionId);
456     }
457 
458     /// @dev Allows anyone to execute a confirmed transaction.
459     /// @param transactionId Transaction ID.
460     function executeTransaction(uint transactionId)
461         public
462         notExecuted(transactionId)
463     {
464         if (isConfirmed(transactionId)) {
465             Transaction storage txToExecute = transactions[transactionId];
466             txToExecute.executed = true;
467             if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
468                 emit Execution(transactionId);
469             else {
470                 emit ExecutionFailure(transactionId);
471                 txToExecute.executed = false;
472             }
473         }
474     }
475 
476     /// @dev Returns the confirmation status of a transaction.
477     /// @param transactionId Transaction ID.
478     /// @return Confirmation status.
479     function isConfirmed(uint transactionId)
480         public
481         constant
482         returns (bool)
483     {
484         uint count = 0;
485         for (uint i=0; i<owners.length; i++) {
486             if (confirmations[transactionId][owners[i]])
487                 count += 1;
488             if (count == required)
489                 return true;
490         }
491     }
492 
493     /*=================================
494     =        OPERATOR FUNCTIONS       =
495     =================================*/
496 
497     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
498     /// @param destination Transaction target address.
499     /// @param value Transaction ether value.
500     /// @param data Transaction data payload.
501     /// @return Returns transaction ID.
502     function addTransaction(address destination, uint value, bytes data)
503         internal
504         notNull(destination)
505         returns (uint transactionId)
506     {
507         transactionId = transactionCount;
508         transactions[transactionId] = Transaction({
509             destination: destination,
510             value: value,
511             data: data,
512             executed: false
513         });
514         transactionCount += 1;
515         emit Submission(transactionId);
516     }
517 
518     /*
519      * Web3 call functions
520      */
521     /// @dev Returns number of confirmations of a transaction.
522     /// @param transactionId Transaction ID.
523     /// @return Number of confirmations.
524     function getConfirmationCount(uint transactionId)
525         public
526         constant
527         returns (uint count)
528     {
529         for (uint i=0; i<owners.length; i++)
530             if (confirmations[transactionId][owners[i]])
531                 count += 1;
532     }
533 
534     /// @dev Returns total number of transactions after filers are applied.
535     /// @param pending Include pending transactions.
536     /// @param executed Include executed transactions.
537     /// @return Total number of transactions after filters are applied.
538     function getTransactionCount(bool pending, bool executed)
539         public
540         constant
541         returns (uint count)
542     {
543         for (uint i=0; i<transactionCount; i++)
544             if (   pending && !transactions[i].executed
545                 || executed && transactions[i].executed)
546                 count += 1;
547     }
548 
549     /// @dev Returns list of owners.
550     /// @return List of owner addresses.
551     function getOwners()
552         public
553         constant
554         returns (address[])
555     {
556         return owners;
557     }
558 
559     /// @dev Returns array with owner addresses, which confirmed transaction.
560     /// @param transactionId Transaction ID.
561     /// @return Returns array of owner addresses.
562     function getConfirmations(uint transactionId)
563         public
564         constant
565         returns (address[] _confirmations)
566     {
567         address[] memory confirmationsTemp = new address[](owners.length);
568         uint count = 0;
569         uint i;
570         for (i=0; i<owners.length; i++)
571             if (confirmations[transactionId][owners[i]]) {
572                 confirmationsTemp[count] = owners[i];
573                 count += 1;
574             }
575         _confirmations = new address[](count);
576         for (i=0; i<count; i++)
577             _confirmations[i] = confirmationsTemp[i];
578     }
579 
580     /// @dev Returns list of transaction IDs in defined range.
581     /// @param from Index start position of transaction array.
582     /// @param to Index end position of transaction array.
583     /// @param pending Include pending transactions.
584     /// @param executed Include executed transactions.
585     /// @return Returns array of transaction IDs.
586     function getTransactionIds(uint from, uint to, bool pending, bool executed)
587         public
588         constant
589         returns (uint[] _transactionIds)
590     {
591         uint[] memory transactionIdsTemp = new uint[](transactionCount);
592         uint count = 0;
593         uint i;
594         for (i=0; i<transactionCount; i++)
595             if (   pending && !transactions[i].executed
596                 || executed && transactions[i].executed)
597             {
598                 transactionIdsTemp[count] = i;
599                 count += 1;
600             }
601         _transactionIds = new uint[](to - from);
602         for (i=from; i<to; i++)
603             _transactionIds[i - from] = transactionIdsTemp[i];
604     }
605 
606     // Additions for Bankroll
607     function whiteListContract(address contractAddress)
608         public
609         isAnOwner
610         contractIsNotWhiteListed(contractAddress)
611         notNull(contractAddress)
612     {
613         isWhitelisted[contractAddress] = true;
614         whiteListedContracts.push(contractAddress);
615         // We set the daily tokens for a particular contract in a separate call.
616         dailyTokensPerContract[contractAddress] = 0;
617         emit WhiteListAddition(contractAddress);
618     }
619 
620     // Remove a whitelisted contract. This is an exception to the norm in that
621     // it can be invoked directly by any owner, in the event that a game is found
622     // to be bugged or otherwise faulty, so it can be shut down as an emergency measure.
623     // Iterates through the whitelisted contracts to find contractAddress,
624     //  then swaps it with the last address in the list - then decrements length
625     function deWhiteListContract(address contractAddress)
626         public
627         isAnOwner
628         contractIsWhiteListed(contractAddress)
629     {
630         isWhitelisted[contractAddress] = false;
631         for (uint i=0; i < whiteListedContracts.length - 1; i++)
632             if (whiteListedContracts[i] == contractAddress) {
633                 whiteListedContracts[i] = owners[whiteListedContracts.length - 1];
634                 break;
635             }
636 
637         whiteListedContracts.length -= 1;
638 
639         emit WhiteListRemoval(contractAddress);
640     }
641 
642      function contractTokenWithdraw(uint amount, address target) public
643         contractIsWhiteListed(msg.sender)
644     {
645         require(isWhitelisted[msg.sender]);
646         require(ZTHTKN.transfer(target, amount));
647     }
648 
649     // Alters the amount of tokens allocated to a game contract on a daily basis.
650     function alterTokenGrant(address _contract, uint _newAmount)
651         public
652         isAnOwner
653         contractIsWhiteListed(_contract)
654     {
655         dailyTokensPerContract[_contract] = _newAmount;
656     }
657 
658     function queryTokenGrant(address _contract)
659         public
660         view
661         returns (uint)
662     {
663         return dailyTokensPerContract[_contract];
664     }
665 
666     // Function to be run by an owner (ideally on a cron job) which performs daily
667     // token collection and dispersal for all whitelisted contracts.
668     function dailyAccounting()
669         public
670         isAnOwner
671     {
672         for (uint i=0; i < whiteListedContracts.length; i++)
673             {
674                 address _contract = whiteListedContracts[i];
675                 if ( dailyTokensPerContract[_contract] > 0 )
676                     {
677                         allocateTokens(_contract);
678                         emit DailyTokenAdmin(_contract);
679                     }
680             }
681     }
682 
683     // In the event that we want to manually take tokens back from a whitelisted contract,
684     // we can do so.
685     function retrieveTokens(address _contract, uint _amount)
686         public
687         isAnOwner
688         contractIsWhiteListed(_contract)
689     {
690         require(ZTHTKN.transferFrom(_contract, address(this), _amount));
691     }
692 
693     // Dispenses daily amount of ZTH to whitelisted contract, or retrieves the excess.
694     // Block withdraws greater than MAX_WITHDRAW_PCT_TX of Zethr token balance.
695     // (May require occasional adjusting of the daily token allocation for contracts.)
696     function allocateTokens(address _contract)
697         public
698         isAnOwner
699         contractIsWhiteListed(_contract)
700     {
701         uint dailyAmount = dailyTokensPerContract[_contract];
702         uint zthPresent  = ZTHTKN.balanceOf(_contract);
703 
704         // Make sure that tokens aren't sent to a contract which is in the black.
705         if (zthPresent <= dailyAmount)
706         {
707             // We need to send tokens over, make sure it's a permitted amount, and then send.
708             uint toDispense  = dailyAmount.sub(zthPresent);
709 
710             // Make sure amount is <= tokenbalance*MAX_WITHDRAW_PCT_TX
711             require(permissibleTokenWithdrawal(toDispense));
712 
713             require(ZTHTKN.transfer(_contract, toDispense));
714             emit DailyTokensSent(_contract, toDispense);
715         } else
716         {
717             // The contract in question has made a profit: retrieve the excess tokens.
718             uint toRetrieve = zthPresent.sub(dailyAmount);
719             require(ZTHTKN.transferFrom(_contract, address(this), toRetrieve));
720             emit DailyTokensReceived(_contract, toRetrieve);
721 
722         }
723         emit DailyTokenAdmin(_contract);
724     }
725 
726     // Dev withdrawal of tokens - splits equally among all owners of contract
727     function devTokenWithdraw(uint amount) public
728         onlyWallet
729     {
730         require(permissibleTokenWithdrawal(amount));
731 
732         uint amountPerPerson = SafeMath.div(amount, owners.length);
733 
734         for (uint i=0; i<owners.length; i++) {
735             ZTHTKN.transfer(owners[i], amountPerPerson);
736         }
737 
738         emit DevWithdraw(amount, amountPerPerson);
739     }
740 
741     // Change the dividend card address. Can't see why this would ever need
742     // to be invoked, but better safe than sorry.
743     function changeDivCardAddress(address _newDivCardAddress)
744         public
745         isAnOwner
746     {
747         divCardAddress = _newDivCardAddress;
748     }
749 
750     // Receive Ether (from Zethr itself or any other source) and purchase tokens at the 33% dividend rate.
751     // If the amount is less than 0.01 Ether, the Ether is stored by the contract until the balance
752     // exceeds that limit and then purchases all it can.
753     function receiveDividends() public payable {
754       if (!reEntered) {
755         uint ActualBalance = (address(this).balance.sub(NonICOBuyins));
756         if (ActualBalance > 0.01 ether) {
757           reEntered = true;
758           ZTHTKN.buyAndSetDivPercentage.value(ActualBalance)(address(0x0), 33, "");
759           emit BankrollInvest(ActualBalance);
760           reEntered = false;
761         }
762       }
763     }
764 
765     // Use all available balance to buy in
766     function buyInWithAllBalanced() public payable isAnOwner {
767       if (!reEntered) {
768         uint balance = address(this).balance;
769         require (balance > 0.01 ether);
770         ZTHTKN.buyAndSetDivPercentage.value(balance)(address(0x0), 33, ""); 
771       }
772     }
773 
774     /*=================================
775     =            UTILITIES            =
776     =================================*/
777 
778     // Convert an hexadecimal character to their value
779     function fromHexChar(uint c) public pure returns (uint) {
780         if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
781             return c - uint(byte('0'));
782         }
783         if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
784             return 10 + c - uint(byte('a'));
785         }
786         if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
787             return 10 + c - uint(byte('A'));
788         }
789     }
790 
791     // Convert an hexadecimal string to raw bytes
792     function fromHex(string s) public pure returns (bytes) {
793         bytes memory ss = bytes(s);
794         require(ss.length%2 == 0); // length must be even
795         bytes memory r = new bytes(ss.length/2);
796         for (uint i=0; i<ss.length/2; ++i) {
797             r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +
798                     fromHexChar(uint(ss[2*i+1])));
799         }
800         return r;
801     }
802 }
803 
804 /**
805  * @title SafeMath
806  * @dev Math operations with safety checks that throw on error
807  */
808 library SafeMath {
809 
810     /**
811     * @dev Multiplies two numbers, throws on overflow.
812     */
813     function mul(uint a, uint b) internal pure returns (uint) {
814         if (a == 0) {
815             return 0;
816         }
817         uint c = a * b;
818         assert(c / a == b);
819         return c;
820     }
821 
822     /**
823     * @dev Integer division of two numbers, truncating the quotient.
824     */
825     function div(uint a, uint b) internal pure returns (uint) {
826         // assert(b > 0); // Solidity automatically throws when dividing by 0
827         uint c = a / b;
828         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
829         return c;
830     }
831 
832     /**
833     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
834     */
835     function sub(uint a, uint b) internal pure returns (uint) {
836         assert(b <= a);
837         return a - b;
838     }
839 
840     /**
841     * @dev Adds two numbers, throws on overflow.
842     */
843     function add(uint a, uint b) internal pure returns (uint) {
844         uint c = a + b;
845         assert(c >= a);
846         return c;
847     }
848 }