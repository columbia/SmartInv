1 pragma solidity 0.4.25;
2 
3 contract _0xbccInterface {
4     function buyAndSetDivPercentage(uint _0xbtcAmount, address _referredBy, uint8 _divChoice, string providedUnhashedPass) public returns(uint);
5 
6     function balanceOf(address who) public view returns(uint);
7 
8     function transfer(address _to, uint _value) public returns(bool);
9 
10     function transferFrom(address _from, address _toAddress, uint _amountOfTokens) public returns(bool);
11 
12     function exit() public;
13 
14     function sell(uint amountOfTokens) public;
15 
16     function withdraw(address _recipient) public;
17 }
18 
19 contract ERC20Interface {
20 
21     function totalSupply() public constant returns(uint);
22 
23     function balanceOf(address tokenOwner) public constant returns(uint balance);
24 
25     function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
26 
27     function transfer(address to, uint tokens) public returns(bool success);
28 
29     function approve(address spender, uint tokens) public returns(bool success);
30 
31     function transferFrom(address from, address to, uint tokens) public returns(bool success);
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 
35 }
36 
37 contract ERC223Receiving {
38     function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns(bool);
39 }
40 
41 contract _0xbtcBankroll is ERC223Receiving {
42     using SafeMath
43     for uint;
44 
45     /*=================================
46     =              EVENTS            =
47     =================================*/
48 
49     event Confirmation(address indexed sender, uint indexed transactionId);
50     event Revocation(address indexed sender, uint indexed transactionId);
51     event Submission(uint indexed transactionId);
52     event Execution(uint indexed transactionId);
53     event ExecutionFailure(uint indexed transactionId);
54     event Deposit(address indexed sender, uint value);
55     event OwnerAddition(address indexed owner);
56     event OwnerRemoval(address indexed owner);
57     event WhiteListAddition(address indexed contractAddress);
58     event WhiteListRemoval(address indexed contractAddress);
59     event RequirementChange(uint required);
60     event DevWithdraw(uint amountTotal, uint amountPerPerson);
61     event _0xBTCLogged(uint amountReceived, address sender);
62     event BankrollInvest(uint amountReceived);
63     event DailyTokenAdmin(address gameContract);
64     event DailyTokensSent(address gameContract, uint tokens);
65     event DailyTokensReceived(address gameContract, uint tokens);
66 
67     /*=================================
68     =        WITHDRAWAL CONSTANTS     =
69     =================================*/
70 
71     uint constant public MAX_OWNER_COUNT = 10;
72     uint constant public MAX_WITHDRAW_PCT_DAILY = 100;
73     uint constant public MAX_WITHDRAW_PCT_TX = 100;
74     uint constant internal resetTimer = 1 days;
75 
76     /*=================================
77     =          0xBTC INTERFACE          =
78     =================================*/
79 
80     ERC20Interface internal _0xBTC;
81 
82     /*=================================
83     =          0xbcc INTERFACE          =
84     =================================*/
85 
86     address internal _0xbccAddress;
87     _0xbccInterface public _0xbcc;
88 
89     /*=================================
90     =             VARIABLES           =
91     =================================*/
92 
93     mapping(uint => Transaction) public transactions;
94     mapping(uint => mapping(address => bool)) public confirmations;
95     mapping(address => bool) public isOwner;
96     mapping(address => bool) public isWhitelisted;
97     mapping(address => uint) public dailyTokensPerContract;
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
196         if (ownerCount > MAX_OWNER_COUNT ||
197             _required > ownerCount ||
198             _required == 0 ||
199             ownerCount == 0)
200             revert();
201         _;
202     }
203 
204     /*=================================
205     =         PUBLIC FUNCTIONS        =
206     =================================*/
207 
208     /// @dev Contract constructor sets initial owners and required number of confirmations.
209     /// @param _owners List of initial owners.
210     /// @param _required Number of required confirmations.
211     constructor(address[] _owners, uint _required, address _btcAddress)
212     public
213     validRequirement(_owners.length, _required) {
214         for (uint i = 0; i < _owners.length; i++) {
215             if (isOwner[_owners[i]] || _owners[i] == 0)
216                 revert();
217             isOwner[_owners[i]] = true;
218         }
219         owners = _owners;
220         required = _required;
221         _0xBTC = ERC20Interface(_btcAddress);
222 
223         dailyResetTime = now - (1 days);
224     }
225 
226     function add0xbccAddresses(address _0xbtc, address _divcards)
227     public
228     isAnOwner {
229         _0xbccAddress = _0xbtc;
230         divCardAddress = _divcards;
231         _0xbcc = _0xbccInterface(_0xbccAddress);
232     }
233 
234     /// @dev Fallback function accept eth.
235     function ()
236     payable
237     public {
238 
239     }
240 
241     uint NonICOBuyins;
242 
243     function deposit(uint value)
244     public {
245         _0xBTC.transferFrom(msg.sender, address(this), value);
246         NonICOBuyins = NonICOBuyins.add(value);
247     }
248 
249     /// @dev Function to buy tokens with contract _0xbtc balance.
250     function buyTokens()
251     public
252     isAnOwner {
253         uint savings = _0xBTC.balanceOf(address(this));
254         if (savings.mul(1e10) > 0.01 ether) { //ether used as 18 decimals factor
255             _0xBTC.approve(_0xbcc, savings);
256             _0xbcc.buyAndSetDivPercentage(savings, address(0x0), 30, "");
257             emit BankrollInvest(savings);
258         } else {
259             emit _0xBTCLogged(savings, msg.sender);
260         }
261     }
262 
263     function tokenFallback(address /*_from*/ , uint /*_amountOfTokens*/ , bytes /*_data*/ ) public returns(bool) {
264         // Nothing, for now. Just receives tokens.
265     }
266 
267     /// @dev Calculates if an amount of tokens exceeds the aggregate daily limit of 15% of contract
268     ///        balance or 5% of the contract balance on its own.
269     function permissibleTokenWithdrawal(uint _toWithdraw)
270     public
271     returns(bool) {
272         uint currentTime = now;
273         uint tokenBalance = _0xbcc.balanceOf(address(this));
274         uint maxPerTx = (tokenBalance.mul(MAX_WITHDRAW_PCT_TX)).div(100);
275 
276         require(_toWithdraw <= maxPerTx);
277 
278         if (currentTime - dailyResetTime >= resetTimer) {
279             dailyResetTime = currentTime;
280             dailyTknLimit = (tokenBalance.mul(MAX_WITHDRAW_PCT_DAILY)).div(100);
281             tknsDispensedToday = _toWithdraw;
282             return true;
283         } else {
284             if (tknsDispensedToday.add(_toWithdraw) <= dailyTknLimit) {
285                 tknsDispensedToday += _toWithdraw;
286                 return true;
287             } else {
288                 return false;
289             }
290         }
291     }
292 
293     /// @dev Allows us to set the daily Token Limit
294     function setDailyTokenLimit(uint limit)
295     public
296     isAnOwner {
297         dailyTknLimit = limit;
298     }
299 
300     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
301     /// @param owner Address of new owner.
302     function addOwner(address owner)
303     public
304     onlyWallet
305     ownerDoesNotExist(owner)
306     notNull(owner)
307     validRequirement(owners.length + 1, required) {
308         isOwner[owner] = true;
309         owners.push(owner);
310         emit OwnerAddition(owner);
311     }
312 
313     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
314     /// @param owner Address of owner.
315     function removeOwner(address owner)
316     public
317     onlyWallet
318     ownerExists(owner)
319     validRequirement(owners.length, required) {
320         isOwner[owner] = false;
321         for (uint i = 0; i < owners.length - 1; i++)
322             if (owners[i] == owner) {
323                 owners[i] = owners[owners.length - 1];
324                 break;
325             }
326         owners.length -= 1;
327         if (required > owners.length)
328             changeRequirement(owners.length);
329         emit OwnerRemoval(owner);
330     }
331 
332     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
333     /// @param owner Address of owner to be replaced.
334     /// @param owner Address of new owner.
335     function replaceOwner(address owner, address newOwner)
336     public
337     onlyWallet
338     ownerExists(owner)
339     ownerDoesNotExist(newOwner) {
340         for (uint i = 0; i < owners.length; i++)
341             if (owners[i] == owner) {
342                 owners[i] = newOwner;
343                 break;
344             }
345         isOwner[owner] = false;
346         isOwner[newOwner] = true;
347         emit OwnerRemoval(owner);
348         emit OwnerAddition(newOwner);
349     }
350 
351     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
352     /// @param _required Number of required confirmations.
353     function changeRequirement(uint _required)
354     public
355     onlyWallet
356     validRequirement(owners.length, _required) {
357         required = _required;
358         emit RequirementChange(_required);
359     }
360 
361     /// @dev Allows an owner to submit and confirm a transaction.
362     /// @param destination Transaction target address.
363     /// @param value Transaction ether value.
364     /// @param data Transaction data payload.
365     /// @return Returns transaction ID.
366     function submitTransaction(address destination, uint value, bytes data)
367     public
368     returns(uint transactionId) {
369         transactionId = addTransaction(destination, value, data);
370         confirmTransaction(transactionId);
371     }
372 
373     /// @dev Allows an owner to confirm a transaction.
374     /// @param transactionId Transaction ID.
375     function confirmTransaction(uint transactionId)
376     public
377     ownerExists(msg.sender)
378     transactionExists(transactionId)
379     notConfirmed(transactionId, msg.sender) {
380         confirmations[transactionId][msg.sender] = true;
381         emit Confirmation(msg.sender, transactionId);
382         executeTransaction(transactionId);
383     }
384 
385     /// @dev Allows an owner to revoke a confirmation for a transaction.
386     /// @param transactionId Transaction ID.
387     function revokeConfirmation(uint transactionId)
388     public
389     ownerExists(msg.sender)
390     confirmed(transactionId, msg.sender)
391     notExecuted(transactionId) {
392         confirmations[transactionId][msg.sender] = false;
393         emit Revocation(msg.sender, transactionId);
394     }
395 
396     /// @dev Allows anyone to execute a confirmed transaction.
397     /// @param transactionId Transaction ID.
398     function executeTransaction(uint transactionId)
399     public
400     notExecuted(transactionId) {
401         if (isConfirmed(transactionId)) {
402             Transaction storage txToExecute = transactions[transactionId];
403             txToExecute.executed = true;
404             if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
405                 emit Execution(transactionId);
406             else {
407                 emit ExecutionFailure(transactionId);
408                 txToExecute.executed = false;
409             }
410         }
411     }
412 
413     /// @dev Returns the confirmation status of a transaction.
414     /// @param transactionId Transaction ID.
415     /// @return Confirmation status.
416     function isConfirmed(uint transactionId)
417     public
418     constant
419     returns(bool) {
420         uint count = 0;
421         for (uint i = 0; i < owners.length; i++) {
422             if (confirmations[transactionId][owners[i]])
423                 count += 1;
424             if (count == required)
425                 return true;
426         }
427     }
428 
429     /*=================================
430     =        OPERATOR FUNCTIONS       =
431     =================================*/
432 
433     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
434     /// @param destination Transaction target address.
435     /// @param value Transaction ether value.
436     /// @param data Transaction data payload.
437     /// @return Returns transaction ID.
438     function addTransaction(address destination, uint value, bytes data)
439     internal
440     notNull(destination)
441     returns(uint transactionId) {
442         transactionId = transactionCount;
443         transactions[transactionId] = Transaction({
444             destination: destination,
445             value: value,
446             data: data,
447             executed: false
448         });
449         transactionCount += 1;
450         emit Submission(transactionId);
451     }
452 
453     /*
454      * Web3 call functions
455      */
456     /// @dev Returns number of confirmations of a transaction.
457     /// @param transactionId Transaction ID.
458     /// @return Number of confirmations.
459     function getConfirmationCount(uint transactionId)
460     public
461     constant
462     returns(uint count) {
463         for (uint i = 0; i < owners.length; i++)
464             if (confirmations[transactionId][owners[i]])
465                 count += 1;
466     }
467 
468     /// @dev Returns total number of transactions after filers are applied.
469     /// @param pending Include pending transactions.
470     /// @param executed Include executed transactions.
471     /// @return Total number of transactions after filters are applied.
472     function getTransactionCount(bool pending, bool executed)
473     public
474     constant
475     returns(uint count) {
476         for (uint i = 0; i < transactionCount; i++)
477             if (pending && !transactions[i].executed ||
478                 executed && transactions[i].executed)
479                 count += 1;
480     }
481 
482     /// @dev Returns list of owners.
483     /// @return List of owner addresses.
484     function getOwners()
485     public
486     constant
487     returns(address[]) {
488         return owners;
489     }
490 
491     /// @dev Returns array with owner addresses, which confirmed transaction.
492     /// @param transactionId Transaction ID.
493     /// @return Returns array of owner addresses.
494     function getConfirmations(uint transactionId)
495     public
496     constant
497     returns(address[] _confirmations) {
498         address[] memory confirmationsTemp = new address[](owners.length);
499         uint count = 0;
500         uint i;
501         for (i = 0; i < owners.length; i++)
502             if (confirmations[transactionId][owners[i]]) {
503                 confirmationsTemp[count] = owners[i];
504                 count += 1;
505             }
506         _confirmations = new address[](count);
507         for (i = 0; i < count; i++)
508             _confirmations[i] = confirmationsTemp[i];
509     }
510 
511     /// @dev Returns list of transaction IDs in defined range.
512     /// @param from Index start position of transaction array.
513     /// @param to Index end position of transaction array.
514     /// @param pending Include pending transactions.
515     /// @param executed Include executed transactions.
516     /// @return Returns array of transaction IDs.
517     function getTransactionIds(uint from, uint to, bool pending, bool executed)
518     public
519     constant
520     returns(uint[] _transactionIds) {
521         uint[] memory transactionIdsTemp = new uint[](transactionCount);
522         uint count = 0;
523         uint i;
524         for (i = 0; i < transactionCount; i++)
525             if (pending && !transactions[i].executed ||
526                 executed && transactions[i].executed) {
527                 transactionIdsTemp[count] = i;
528                 count += 1;
529             }
530         _transactionIds = new uint[](to - from);
531         for (i = from; i < to; i++)
532             _transactionIds[i - from] = transactionIdsTemp[i];
533     }
534 
535     // Additions for Bankroll
536     function whiteListContract(address contractAddress)
537     public
538     isAnOwner
539     contractIsNotWhiteListed(contractAddress)
540     notNull(contractAddress) {
541         isWhitelisted[contractAddress] = true;
542         whiteListedContracts.push(contractAddress);
543         // We set the daily tokens for a particular contract in a separate call.
544         dailyTokensPerContract[contractAddress] = 0;
545         emit WhiteListAddition(contractAddress);
546     }
547 
548     // Remove a whitelisted contract. This is an exception to the norm in that
549     // it can be invoked directly by any owner, in the event that a game is found
550     // to be bugged or otherwise faulty, so it can be shut down as an emergency measure.
551     // Iterates through the whitelisted contracts to find contractAddress,
552     //  then swaps it with the last address in the list - then decrements length
553     function deWhiteListContract(address contractAddress)
554     public
555     isAnOwner
556     contractIsWhiteListed(contractAddress) {
557         isWhitelisted[contractAddress] = false;
558         for (uint i = 0; i < whiteListedContracts.length - 1; i++)
559             if (whiteListedContracts[i] == contractAddress) {
560                 whiteListedContracts[i] = owners[whiteListedContracts.length - 1];
561                 break;
562             }
563 
564         whiteListedContracts.length -= 1;
565 
566         emit WhiteListRemoval(contractAddress);
567     }
568 
569     function contractTokenWithdraw(uint amount, address target) public
570     contractIsWhiteListed(msg.sender) {
571         require(isWhitelisted[msg.sender]);
572         require(_0xbcc.transfer(target, amount));
573     }
574 
575     // Alters the amount of tokens allocated to a game contract on a daily basis.
576     function alterTokenGrant(address _contract, uint _newAmount)
577     public
578     isAnOwner
579     contractIsWhiteListed(_contract) {
580         dailyTokensPerContract[_contract] = _newAmount;
581     }
582 
583     function queryTokenGrant(address _contract)
584     public
585     view
586     returns(uint) {
587         return dailyTokensPerContract[_contract];
588     }
589 
590     // Function to be run by an owner (ideally on a cron job) which performs daily
591     // token collection and dispersal for all whitelisted contracts.
592     function dailyAccounting()
593     public
594     isAnOwner {
595         for (uint i = 0; i < whiteListedContracts.length; i++) {
596             address _contract = whiteListedContracts[i];
597             if (dailyTokensPerContract[_contract] > 0) {
598                 allocateTokens(_contract);
599                 emit DailyTokenAdmin(_contract);
600             }
601         }
602     }
603 
604     // In the event that we want to manually take tokens back from a whitelisted contract,
605     // we can do so.
606     function retrieveTokens(address _contract, uint _amount)
607     public
608     isAnOwner
609     contractIsWhiteListed(_contract) {
610         require(_0xbcc.transferFrom(_contract, address(this), _amount));
611     }
612 
613     // Dispenses daily amount of 0xbcc to whitelisted contract, or retrieves the excess.
614     // Block withdraws greater than MAX_WITHDRAW_PCT_TX of 0xbtc token balance.
615     // (May require occasional adjusting of the daily token allocation for contracts.)
616     function allocateTokens(address _contract)
617     public
618     isAnOwner
619     contractIsWhiteListed(_contract) {
620         uint dailyAmount = dailyTokensPerContract[_contract];
621         uint bccPresent = _0xbcc.balanceOf(_contract);
622 
623         // Make sure that tokens aren't sent to a contract which is in the black.
624         if (bccPresent <= dailyAmount) {
625             // We need to send tokens over, make sure it's a permitted amount, and then send.
626             uint toDispense = dailyAmount.sub(bccPresent);
627 
628             // Make sure amount is <= tokenbalance*MAX_WITHDRAW_PCT_TX
629             require(permissibleTokenWithdrawal(toDispense));
630 
631             require(_0xbcc.transfer(_contract, toDispense));
632             emit DailyTokensSent(_contract, toDispense);
633         } else {
634             // The contract in question has made a profit: retrieve the excess tokens.
635             uint toRetrieve = bccPresent.sub(dailyAmount);
636             require(_0xbcc.transferFrom(_contract, address(this), toRetrieve));
637             emit DailyTokensReceived(_contract, toRetrieve);
638 
639         }
640         emit DailyTokenAdmin(_contract);
641     }
642 
643     // Dev withdrawal of tokens - splits equally among all owners of contract
644     function devTokenWithdraw(uint amount) public
645     onlyWallet {
646         require(permissibleTokenWithdrawal(amount));
647 
648         uint amountPerPerson = SafeMath.div(amount, owners.length);
649 
650         for (uint i = 0; i < owners.length; i++) {
651             _0xbcc.transfer(owners[i], amountPerPerson);
652         }
653 
654         emit DevWithdraw(amount, amountPerPerson);
655     }
656 
657     // Change the dividend card address. Can't see why this would ever need
658     // to be invoked, but better safe than sorry.
659     function changeDivCardAddress(address _newDivCardAddress)
660     public
661     isAnOwner {
662         divCardAddress = _newDivCardAddress;
663     }
664 
665     // Receive 0xbtc (from 0xbtc itself or any other source) and purchase tokens at the 30% dividend rate.
666     // If the amount is less than 0.01 Ether, the Ether is stored by the contract until the balance
667     // exceeds that limit and then purchases all it can.
668     function receiveDividends(uint amount) public {
669 
670         _0xBTC.transferFrom(msg.sender, address(this), amount);
671 
672         if (!reEntered) {
673             uint ActualBalance = (_0xBTC.balanceOf(address(this)).sub(NonICOBuyins));
674             if (ActualBalance.mul(1e10) > 0.01 ether) {
675                 reEntered = true;
676                 _0xBTC.approve(_0xbcc, ActualBalance);
677                 _0xbcc.buyAndSetDivPercentage(ActualBalance, address(0x0), 30, "");
678                 emit BankrollInvest(ActualBalance);
679                 reEntered = false;
680             }
681         }
682     }
683 
684     // Use all available balance to buy in
685     function buyInWithAllBalance() public isAnOwner {
686         if (!reEntered) {
687             uint balance = _0xBTC.balanceOf(address(this));
688             require(balance.mul(1e10) > 0.01 ether);
689             _0xBTC.approve(_0xbcc, balance);
690             _0xbcc.buyAndSetDivPercentage(balance, address(0x0), 30, "");
691         }
692     }
693 
694     /*=================================
695     =            UTILITIES            =
696     =================================*/
697 
698     // Convert an hexadecimal character to their value
699     function fromHexChar(uint c) public pure returns(uint) {
700         if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
701             return c - uint(byte('0'));
702         }
703         if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
704             return 10 + c - uint(byte('a'));
705         }
706         if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
707             return 10 + c - uint(byte('A'));
708         }
709     }
710 
711     // Convert an hexadecimal string to raw bytes
712     function fromHex(string s) public pure returns(bytes) {
713         bytes memory ss = bytes(s);
714         require(ss.length % 2 == 0); // length must be even
715         bytes memory r = new bytes(ss.length / 2);
716         for (uint i = 0; i < ss.length / 2; ++i) {
717             r[i] = byte(fromHexChar(uint(ss[2 * i])) * 16 +
718                 fromHexChar(uint(ss[2 * i + 1])));
719         }
720         return r;
721     }
722 }
723 
724 /**
725  * @title SafeMath
726  * @dev Math operations with safety checks that throw on error
727  */
728 library SafeMath {
729 
730     /**
731      * @dev Multiplies two numbers, throws on overflow.
732      */
733     function mul(uint a, uint b) internal pure returns(uint) {
734         if (a == 0) {
735             return 0;
736         }
737         uint c = a * b;
738         assert(c / a == b);
739         return c;
740     }
741 
742     /**
743      * @dev Integer division of two numbers, truncating the quotient.
744      */
745     function div(uint a, uint b) internal pure returns(uint) {
746         // assert(b > 0); // Solidity automatically throws when dividing by 0
747         uint c = a / b;
748         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
749         return c;
750     }
751 
752     /**
753      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
754      */
755     function sub(uint a, uint b) internal pure returns(uint) {
756         assert(b <= a);
757         return a - b;
758     }
759 
760     /**
761      * @dev Adds two numbers, throws on overflow.
762      */
763     function add(uint a, uint b) internal pure returns(uint) {
764         uint c = a + b;
765         assert(c >= a);
766         return c;
767     }
768 }