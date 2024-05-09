1 pragma solidity ^0.4.24;
2 
3 /**
4 
5     https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com
6                                                                                                    
7                                                                                                         
8 FFFFFFFFFFFFFFFFFFFFFF                                           tttt            iiii                   
9 F::::::::::::::::::::F                                        ttt:::t           i::::i                  
10 F::::::::::::::::::::F                                        t:::::t            iiii                   
11 FF::::::FFFFFFFFF::::F                                        t:::::t                                   
12   F:::::F       FFFFFFooooooooooo   rrrrr   rrrrrrrrr   ttttttt:::::ttttttt    iiiiiii     ssssssssss   
13   F:::::F           oo:::::::::::oo r::::rrr:::::::::r  t:::::::::::::::::t    i:::::i   ss::::::::::s  
14   F::::::FFFFFFFFFFo:::::::::::::::or:::::::::::::::::r t:::::::::::::::::t     i::::i ss:::::::::::::s 
15   F:::::::::::::::Fo:::::ooooo:::::orr::::::rrrrr::::::rtttttt:::::::tttttt     i::::i s::::::ssss:::::s
16   F:::::::::::::::Fo::::o     o::::o r:::::r     r:::::r      t:::::t           i::::i  s:::::s  ssssss 
17   F::::::FFFFFFFFFFo::::o     o::::o r:::::r     rrrrrrr      t:::::t           i::::i    s::::::s      
18   F:::::F          o::::o     o::::o r:::::r                  t:::::t           i::::i       s::::::s   
19   F:::::F          o::::o     o::::o r:::::r                  t:::::t    tttttt i::::i ssssss   s:::::s 
20 FF:::::::FF        o:::::ooooo:::::o r:::::r                  t::::::tttt:::::ti::::::is:::::ssss::::::s
21 F::::::::FF        o:::::::::::::::o r:::::r                  tt::::::::::::::ti::::::is::::::::::::::s 
22 F::::::::FF         oo:::::::::::oo  r:::::r                    tt:::::::::::tti::::::i s:::::::::::ss  
23 FFFFFFFFFFF           ooooooooooo    rrrrrrr                      ttttttttttt  iiiiiiii  sssssssssss    
24                                                                                                         
25 Discord:   https://discord.gg/gDtTX62 
26 
27 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
28 
29 Bankroll contract, containing tokens purchased from all dividend-card profit and ICO dividends.
30 Acts as token repository for games on the Zethr platform.
31 
32 **/
33 
34 contract ZTHInterface {
35         function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass) public payable returns (uint);
36         function balanceOf(address who) public view returns (uint);
37         function transfer(address _to, uint _value)     public returns (bool);
38         function transferFrom(address _from, address _toAddress, uint _amountOfTokens) public returns (bool);
39         function exit() public;
40         function sell(uint amountOfTokens) public;
41         function withdraw(address _recipient) public;
42 }
43 
44 contract ERC223Receiving {
45     function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
46 }
47 
48 contract ZethrBankroll is ERC223Receiving {
49     using SafeMath for uint;
50 
51     /*=================================
52     =              EVENTS            =
53     =================================*/
54 
55     event Confirmation(address indexed sender, uint indexed transactionId);
56     event Revocation(address indexed sender, uint indexed transactionId);
57     event Submission(uint indexed transactionId);
58     event Execution(uint indexed transactionId);
59     event ExecutionFailure(uint indexed transactionId);
60     event Deposit(address indexed sender, uint value);
61     event OwnerAddition(address indexed owner);
62     event OwnerRemoval(address indexed owner);
63     event WhiteListAddition(address indexed contractAddress);
64     event WhiteListRemoval(address indexed contractAddress);
65     event RequirementChange(uint required);
66     event DevWithdraw(uint amountTotal, uint amountPerPerson);
67     event EtherLogged(uint amountReceived, address sender);
68     event BankrollInvest(uint amountReceived);
69     event DailyTokenAdmin(address gameContract);
70     event DailyTokensSent(address gameContract, uint tokens);
71     event DailyTokensReceived(address gameContract, uint tokens);
72 
73     /*=================================
74     =        WITHDRAWAL CONSTANTS     =
75     =================================*/
76 
77     uint constant public MAX_OWNER_COUNT = 10;
78     uint constant public MAX_WITHDRAW_PCT_DAILY = 15;
79     uint constant public MAX_WITHDRAW_PCT_TX = 5;
80     uint constant internal resetTimer = 1 days;
81 
82     /*=================================
83     =          ZTH INTERFACE          =
84     =================================*/
85 
86     address internal zethrAddress;
87     ZTHInterface public ZTHTKN;
88 
89     /*=================================
90     =             VARIABLES           =
91     =================================*/
92 
93     mapping (uint => Transaction) public transactions;
94     mapping (uint => mapping (address => bool)) public confirmations;
95     mapping (address => bool) public isOwner;
96     mapping (address => bool) public isWhitelisted;
97     mapping (address => uint) public dailyTokensPerContract;
98     address internal divCardAddress;
99     address[] public owners;
100     address[] public whiteListedContracts;
101     uint public required;
102     uint public transactionCount;
103     uint internal dailyResetTime;
104     uint internal dailyTknLimit;
105     uint internal tknsDispensedToday;
106     bool internal reEntered = false;
107 
108     /*=================================
109     =         CUSTOM CONSTRUCTS       =
110     =================================*/
111 
112     struct Transaction {
113         address destination;
114         uint value;
115         bytes data;
116         bool executed;
117     }
118 
119     struct TKN {
120         address sender;
121         uint value;
122     }
123 
124     /*=================================
125     =            MODIFIERS            =
126     =================================*/
127 
128     modifier onlyWallet() {
129         if (msg.sender != address(this))
130             revert();
131         _;
132     }
133 
134     modifier contractIsNotWhiteListed(address contractAddress) {
135         if (isWhitelisted[contractAddress])
136             revert();
137         _;
138     }
139 
140     modifier contractIsWhiteListed(address contractAddress) {
141         if (!isWhitelisted[contractAddress])
142             revert();
143         _;
144     }
145 
146     modifier isAnOwner() {
147         address caller = msg.sender;
148         if (!isOwner[caller])
149             revert();
150         _;
151     }
152 
153     modifier ownerDoesNotExist(address owner) {
154         if (isOwner[owner])
155             revert();
156         _;
157     }
158 
159     modifier ownerExists(address owner) {
160         if (!isOwner[owner])
161             revert();
162         _;
163     }
164 
165     modifier transactionExists(uint transactionId) {
166         if (transactions[transactionId].destination == 0)
167             revert();
168         _;
169     }
170 
171     modifier confirmed(uint transactionId, address owner) {
172         if (!confirmations[transactionId][owner])
173             revert();
174         _;
175     }
176 
177     modifier notConfirmed(uint transactionId, address owner) {
178         if (confirmations[transactionId][owner])
179             revert();
180         _;
181     }
182 
183     modifier notExecuted(uint transactionId) {
184         if (transactions[transactionId].executed)
185             revert();
186         _;
187     }
188 
189     modifier notNull(address _address) {
190         if (_address == 0)
191             revert();
192         _;
193     }
194 
195     modifier validRequirement(uint ownerCount, uint _required) {
196         if (   ownerCount > MAX_OWNER_COUNT
197             || _required > ownerCount
198             || _required == 0
199             || ownerCount == 0)
200             revert();
201         _;
202     }
203 
204     /*=================================
205     =          LIST OF OWNERS         =
206     =================================*/
207 
208     /*
209         This list is for reference/identification purposes only, and comprises the eight core Zethr developers.
210         For game contracts to be listed, they must be approved by a majority (i.e. currently five) of the owners.
211         Contracts can be delisted in an emergency by a single owner.
212 
213         0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae // Norsefire
214         0x11e52c75998fe2E7928B191bfc5B25937Ca16741 // klob
215         0x20C945800de43394F70D789874a4daC9cFA57451 // Etherguy
216         0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB // blurr
217         0x8537aa2911b193e5B377938A723D805bb0865670 // oguzhanox
218         0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3 // Randall
219         0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696 // cryptodude
220         0xDa83156106c4dba7A26E9bF2Ca91E273350aa551 // TropicalRogue
221     */
222 
223 
224     /*=================================
225     =         PUBLIC FUNCTIONS        =
226     =================================*/
227 
228     /// @dev Contract constructor sets initial owners and required number of confirmations.
229     /// @param _owners List of initial owners.
230     /// @param _required Number of required confirmations.
231     constructor (address[] _owners, uint _required)
232         public
233         validRequirement(_owners.length, _required)
234     {
235         for (uint i=0; i<_owners.length; i++) {
236             if (isOwner[_owners[i]] || _owners[i] == 0)
237                 revert();
238             isOwner[_owners[i]] = true;
239         }
240         owners = _owners;
241         required = _required;
242 
243         dailyResetTime = now - (1 days);
244     }
245 
246     /** Testing only.
247     function exitAll()
248         public
249     {
250         uint tokenBalance = ZTHTKN.balanceOf(address(this));
251         ZTHTKN.sell(tokenBalance - 1e18);
252         ZTHTKN.sell(1e18);
253         ZTHTKN.withdraw(address(0x0));
254     }
255     **/
256 
257     function addZethrAddresses(address _zethr, address _divcards)
258         public
259         isAnOwner
260     {
261         zethrAddress   = _zethr;
262         divCardAddress = _divcards;
263         ZTHTKN = ZTHInterface(zethrAddress);
264     }
265 
266     /// @dev Fallback function allows Ether to be deposited.
267     function()
268         public
269         payable
270     {
271 
272     }
273 
274     uint NonICOBuyins;
275 
276     function deposit()
277         public
278         payable
279     {
280         NonICOBuyins = NonICOBuyins.add(msg.value);
281     }
282 
283     /// @dev Function to buy tokens with contract eth balance.
284     function buyTokens()
285         public
286         payable
287         isAnOwner
288     {
289         uint savings = address(this).balance;
290         if (savings > 0.01 ether) {
291             ZTHTKN.buyAndSetDivPercentage.value(savings)(address(0x0), 33, "");
292             emit BankrollInvest(savings);
293         }
294         else {
295             emit EtherLogged(msg.value, msg.sender);
296         }
297     }
298 
299 		function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/) public returns (bool) {
300 			// Nothing, for now. Just receives tokens.
301 		}	
302 
303     /// @dev Calculates if an amount of tokens exceeds the aggregate daily limit of 15% of contract
304     ///        balance or 5% of the contract balance on its own.
305     function permissibleTokenWithdrawal(uint _toWithdraw)
306         public
307         returns(bool)
308     {
309         uint currentTime     = now;
310         uint tokenBalance    = ZTHTKN.balanceOf(address(this));
311         uint maxPerTx        = (tokenBalance.mul(MAX_WITHDRAW_PCT_TX)).div(100);
312 
313         require (_toWithdraw <= maxPerTx);
314 
315         if (currentTime - dailyResetTime >= resetTimer)
316             {
317                 dailyResetTime     = currentTime;
318                 dailyTknLimit      = (tokenBalance.mul(MAX_WITHDRAW_PCT_DAILY)).div(100);
319                 tknsDispensedToday = _toWithdraw;
320                 return true;
321             }
322         else
323             {
324                 if (tknsDispensedToday.add(_toWithdraw) <= dailyTknLimit)
325                     {
326                         tknsDispensedToday += _toWithdraw;
327                         return true;
328                     }
329                 else { return false; }
330             }
331     }
332 
333     /// @dev Allows us to set the daily Token Limit
334     function setDailyTokenLimit(uint limit)
335       public
336       isAnOwner
337     {
338       dailyTknLimit = limit;
339     }
340 
341     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
342     /// @param owner Address of new owner.
343     function addOwner(address owner)
344         public
345         onlyWallet
346         ownerDoesNotExist(owner)
347         notNull(owner)
348         validRequirement(owners.length + 1, required)
349     {
350         isOwner[owner] = true;
351         owners.push(owner);
352         emit OwnerAddition(owner);
353     }
354 
355     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
356     /// @param owner Address of owner.
357     function removeOwner(address owner)
358         public
359         onlyWallet
360         ownerExists(owner)
361         validRequirement(owners.length, required)
362     {
363         isOwner[owner] = false;
364         for (uint i=0; i<owners.length - 1; i++)
365             if (owners[i] == owner) {
366                 owners[i] = owners[owners.length - 1];
367                 break;
368             }
369         owners.length -= 1;
370         if (required > owners.length)
371             changeRequirement(owners.length);
372         emit OwnerRemoval(owner);
373     }
374 
375     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
376     /// @param owner Address of owner to be replaced.
377     /// @param owner Address of new owner.
378     function replaceOwner(address owner, address newOwner)
379         public
380         onlyWallet
381         ownerExists(owner)
382         ownerDoesNotExist(newOwner)
383     {
384         for (uint i=0; i<owners.length; i++)
385             if (owners[i] == owner) {
386                 owners[i] = newOwner;
387                 break;
388             }
389         isOwner[owner] = false;
390         isOwner[newOwner] = true;
391         emit OwnerRemoval(owner);
392         emit OwnerAddition(newOwner);
393     }
394 
395     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
396     /// @param _required Number of required confirmations.
397     function changeRequirement(uint _required)
398         public
399         onlyWallet
400         validRequirement(owners.length, _required)
401     {
402         required = _required;
403         emit RequirementChange(_required);
404     }
405 
406     /// @dev Allows an owner to submit and confirm a transaction.
407     /// @param destination Transaction target address.
408     /// @param value Transaction ether value.
409     /// @param data Transaction data payload.
410     /// @return Returns transaction ID.
411     function submitTransaction(address destination, uint value, bytes data)
412         public
413         returns (uint transactionId)
414     {
415         transactionId = addTransaction(destination, value, data);
416         confirmTransaction(transactionId);
417     }
418 
419     /// @dev Allows an owner to confirm a transaction.
420     /// @param transactionId Transaction ID.
421     function confirmTransaction(uint transactionId)
422         public
423         ownerExists(msg.sender)
424         transactionExists(transactionId)
425         notConfirmed(transactionId, msg.sender)
426     {
427         confirmations[transactionId][msg.sender] = true;
428         emit Confirmation(msg.sender, transactionId);
429         executeTransaction(transactionId);
430     }
431 
432     /// @dev Allows an owner to revoke a confirmation for a transaction.
433     /// @param transactionId Transaction ID.
434     function revokeConfirmation(uint transactionId)
435         public
436         ownerExists(msg.sender)
437         confirmed(transactionId, msg.sender)
438         notExecuted(transactionId)
439     {
440         confirmations[transactionId][msg.sender] = false;
441         emit Revocation(msg.sender, transactionId);
442     }
443 
444     /// @dev Allows anyone to execute a confirmed transaction.
445     /// @param transactionId Transaction ID.
446     function executeTransaction(uint transactionId)
447         public
448         notExecuted(transactionId)
449     {
450         if (isConfirmed(transactionId)) {
451             Transaction storage txToExecute = transactions[transactionId];
452             txToExecute.executed = true;
453             if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
454                 emit Execution(transactionId);
455             else {
456                 emit ExecutionFailure(transactionId);
457                 txToExecute.executed = false;
458             }
459         }
460     }
461 
462     /// @dev Returns the confirmation status of a transaction.
463     /// @param transactionId Transaction ID.
464     /// @return Confirmation status.
465     function isConfirmed(uint transactionId)
466         public
467         constant
468         returns (bool)
469     {
470         uint count = 0;
471         for (uint i=0; i<owners.length; i++) {
472             if (confirmations[transactionId][owners[i]])
473                 count += 1;
474             if (count == required)
475                 return true;
476         }
477     }
478 
479     /*=================================
480     =        OPERATOR FUNCTIONS       =
481     =================================*/
482 
483     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
484     /// @param destination Transaction target address.
485     /// @param value Transaction ether value.
486     /// @param data Transaction data payload.
487     /// @return Returns transaction ID.
488     function addTransaction(address destination, uint value, bytes data)
489         internal
490         notNull(destination)
491         returns (uint transactionId)
492     {
493         transactionId = transactionCount;
494         transactions[transactionId] = Transaction({
495             destination: destination,
496             value: value,
497             data: data,
498             executed: false
499         });
500         transactionCount += 1;
501         emit Submission(transactionId);
502     }
503 
504     /*
505      * Web3 call functions
506      */
507     /// @dev Returns number of confirmations of a transaction.
508     /// @param transactionId Transaction ID.
509     /// @return Number of confirmations.
510     function getConfirmationCount(uint transactionId)
511         public
512         constant
513         returns (uint count)
514     {
515         for (uint i=0; i<owners.length; i++)
516             if (confirmations[transactionId][owners[i]])
517                 count += 1;
518     }
519 
520     /// @dev Returns total number of transactions after filers are applied.
521     /// @param pending Include pending transactions.
522     /// @param executed Include executed transactions.
523     /// @return Total number of transactions after filters are applied.
524     function getTransactionCount(bool pending, bool executed)
525         public
526         constant
527         returns (uint count)
528     {
529         for (uint i=0; i<transactionCount; i++)
530             if (   pending && !transactions[i].executed
531                 || executed && transactions[i].executed)
532                 count += 1;
533     }
534 
535     /// @dev Returns list of owners.
536     /// @return List of owner addresses.
537     function getOwners()
538         public
539         constant
540         returns (address[])
541     {
542         return owners;
543     }
544 
545     /// @dev Returns array with owner addresses, which confirmed transaction.
546     /// @param transactionId Transaction ID.
547     /// @return Returns array of owner addresses.
548     function getConfirmations(uint transactionId)
549         public
550         constant
551         returns (address[] _confirmations)
552     {
553         address[] memory confirmationsTemp = new address[](owners.length);
554         uint count = 0;
555         uint i;
556         for (i=0; i<owners.length; i++)
557             if (confirmations[transactionId][owners[i]]) {
558                 confirmationsTemp[count] = owners[i];
559                 count += 1;
560             }
561         _confirmations = new address[](count);
562         for (i=0; i<count; i++)
563             _confirmations[i] = confirmationsTemp[i];
564     }
565 
566     /// @dev Returns list of transaction IDs in defined range.
567     /// @param from Index start position of transaction array.
568     /// @param to Index end position of transaction array.
569     /// @param pending Include pending transactions.
570     /// @param executed Include executed transactions.
571     /// @return Returns array of transaction IDs.
572     function getTransactionIds(uint from, uint to, bool pending, bool executed)
573         public
574         constant
575         returns (uint[] _transactionIds)
576     {
577         uint[] memory transactionIdsTemp = new uint[](transactionCount);
578         uint count = 0;
579         uint i;
580         for (i=0; i<transactionCount; i++)
581             if (   pending && !transactions[i].executed
582                 || executed && transactions[i].executed)
583             {
584                 transactionIdsTemp[count] = i;
585                 count += 1;
586             }
587         _transactionIds = new uint[](to - from);
588         for (i=from; i<to; i++)
589             _transactionIds[i - from] = transactionIdsTemp[i];
590     }
591 
592     // Additions for Bankroll
593     function whiteListContract(address contractAddress)
594         public
595         isAnOwner
596         contractIsNotWhiteListed(contractAddress)
597         notNull(contractAddress)
598     {
599         isWhitelisted[contractAddress] = true;
600         whiteListedContracts.push(contractAddress);
601         // We set the daily tokens for a particular contract in a separate call.
602         dailyTokensPerContract[contractAddress] = 0;
603         emit WhiteListAddition(contractAddress);
604     }
605 
606     // Remove a whitelisted contract. This is an exception to the norm in that
607     // it can be invoked directly by any owner, in the event that a game is found
608     // to be bugged or otherwise faulty, so it can be shut down as an emergency measure.
609     // Iterates through the whitelisted contracts to find contractAddress,
610     //  then swaps it with the last address in the list - then decrements length
611     function deWhiteListContract(address contractAddress)
612         public
613         isAnOwner
614         contractIsWhiteListed(contractAddress)
615     {
616         isWhitelisted[contractAddress] = false;
617         for (uint i=0; i < whiteListedContracts.length - 1; i++)
618             if (whiteListedContracts[i] == contractAddress) {
619                 whiteListedContracts[i] = owners[whiteListedContracts.length - 1];
620                 break;
621             }
622 
623         whiteListedContracts.length -= 1;
624 
625         emit WhiteListRemoval(contractAddress);
626     }
627 
628      function contractTokenWithdraw(uint amount, address target) public
629         contractIsWhiteListed(msg.sender)
630     {
631         require(isWhitelisted[msg.sender]);
632         require(ZTHTKN.transfer(target, amount));
633     }
634 
635     // Alters the amount of tokens allocated to a game contract on a daily basis.
636     function alterTokenGrant(address _contract, uint _newAmount)
637         public
638         isAnOwner
639         contractIsWhiteListed(_contract)
640     {
641         dailyTokensPerContract[_contract] = _newAmount;
642     }
643 
644     function queryTokenGrant(address _contract)
645         public
646         view
647         returns (uint)
648     {
649         return dailyTokensPerContract[_contract];
650     }
651 
652     // Function to be run by an owner (ideally on a cron job) which performs daily
653     // token collection and dispersal for all whitelisted contracts.
654     function dailyAccounting()
655         public
656         isAnOwner
657     {
658         for (uint i=0; i < whiteListedContracts.length; i++)
659             {
660                 address _contract = whiteListedContracts[i];
661                 if ( dailyTokensPerContract[_contract] > 0 )
662                     {
663                         allocateTokens(_contract);
664                         emit DailyTokenAdmin(_contract);
665                     }
666             }
667     }
668 
669     // In the event that we want to manually take tokens back from a whitelisted contract,
670     // we can do so.
671     function retrieveTokens(address _contract, uint _amount)
672         public
673         isAnOwner
674         contractIsWhiteListed(_contract)
675     {
676         require(ZTHTKN.transferFrom(_contract, address(this), _amount));
677     }
678 
679     // Dispenses daily amount of ZTH to whitelisted contract, or retrieves the excess.
680     // Block withdraws greater than MAX_WITHDRAW_PCT_TX of Zethr token balance.
681     // (May require occasional adjusting of the daily token allocation for contracts.)
682     function allocateTokens(address _contract)
683         public
684         isAnOwner
685         contractIsWhiteListed(_contract)
686     {
687         uint dailyAmount = dailyTokensPerContract[_contract];
688         uint zthPresent  = ZTHTKN.balanceOf(_contract);
689 
690         // Make sure that tokens aren't sent to a contract which is in the black.
691         if (zthPresent <= dailyAmount)
692         {
693             // We need to send tokens over, make sure it's a permitted amount, and then send.
694             uint toDispense  = dailyAmount.sub(zthPresent);
695 
696             // Make sure amount is <= tokenbalance*MAX_WITHDRAW_PCT_TX
697             require(permissibleTokenWithdrawal(toDispense));
698 
699             require(ZTHTKN.transfer(_contract, toDispense));
700             emit DailyTokensSent(_contract, toDispense);
701         } else
702         {
703             // The contract in question has made a profit: retrieve the excess tokens.
704             uint toRetrieve = zthPresent.sub(dailyAmount);
705             require(ZTHTKN.transferFrom(_contract, address(this), toRetrieve));
706             emit DailyTokensReceived(_contract, toRetrieve);
707 
708         }
709         emit DailyTokenAdmin(_contract);
710     }
711 
712     // Dev withdrawal of tokens - splits equally among all owners of contract
713     function devTokenWithdraw(uint amount) public
714         onlyWallet
715     {
716         require(permissibleTokenWithdrawal(amount));
717 
718         uint amountPerPerson = SafeMath.div(amount, owners.length);
719 
720         for (uint i=0; i<owners.length; i++) {
721             ZTHTKN.transfer(owners[i], amountPerPerson);
722         }
723 
724         emit DevWithdraw(amount, amountPerPerson);
725     }
726 
727     // Change the dividend card address. Can't see why this would ever need
728     // to be invoked, but better safe than sorry.
729     function changeDivCardAddress(address _newDivCardAddress)
730         public
731         isAnOwner
732     {
733         divCardAddress = _newDivCardAddress;
734     }
735 
736     // Receive Ether (from Zethr itself or any other source) and purchase tokens at the 33% dividend rate.
737     // If the amount is less than 0.01 Ether, the Ether is stored by the contract until the balance
738     // exceeds that limit and then purchases all it can.
739     function receiveDividends() public payable {
740       if (!reEntered) {
741         uint ActualBalance = (address(this).balance.sub(NonICOBuyins));
742         if (ActualBalance > 0.01 ether) {
743           reEntered = true;
744           ZTHTKN.buyAndSetDivPercentage.value(ActualBalance)(address(0x0), 33, "");
745           emit BankrollInvest(ActualBalance);
746           reEntered = false;
747         }
748       }
749     }
750 
751     // Use all available balance to buy in
752     function buyInWithAllBalanced() public payable isAnOwner {
753       if (!reEntered) {
754         uint balance = address(this).balance;
755         require (balance > 0.01 ether);
756         ZTHTKN.buyAndSetDivPercentage.value(balance)(address(0x0), 33, ""); 
757       }
758     }
759 
760     /*=================================
761     =            UTILITIES            =
762     =================================*/
763 
764     // Convert an hexadecimal character to their value
765     function fromHexChar(uint c) public pure returns (uint) {
766         if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
767             return c - uint(byte('0'));
768         }
769         if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
770             return 10 + c - uint(byte('a'));
771         }
772         if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
773             return 10 + c - uint(byte('A'));
774         }
775     }
776 
777     // Convert an hexadecimal string to raw bytes
778     function fromHex(string s) public pure returns (bytes) {
779         bytes memory ss = bytes(s);
780         require(ss.length%2 == 0); // length must be even
781         bytes memory r = new bytes(ss.length/2);
782         for (uint i=0; i<ss.length/2; ++i) {
783             r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +
784                     fromHexChar(uint(ss[2*i+1])));
785         }
786         return r;
787     }
788 }
789 
790 /**
791  * @title SafeMath
792  * @dev Math operations with safety checks that throw on error
793  */
794 library SafeMath {
795 
796     /**
797     * @dev Multiplies two numbers, throws on overflow.
798     */
799     function mul(uint a, uint b) internal pure returns (uint) {
800         if (a == 0) {
801             return 0;
802         }
803         uint c = a * b;
804         assert(c / a == b);
805         return c;
806     }
807 
808     /**
809     * @dev Integer division of two numbers, truncating the quotient.
810     */
811     function div(uint a, uint b) internal pure returns (uint) {
812         // assert(b > 0); // Solidity automatically throws when dividing by 0
813         uint c = a / b;
814         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
815         return c;
816     }
817 
818     /**
819     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
820     */
821     function sub(uint a, uint b) internal pure returns (uint) {
822         assert(b <= a);
823         return a - b;
824     }
825 
826     /**
827     * @dev Adds two numbers, throws on overflow.
828     */
829     function add(uint a, uint b) internal pure returns (uint) {
830         uint c = a + b;
831         assert(c >= a);
832         return c;
833     }
834 }