1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Gifto Token by Gifto Limited.
5 // An ERC20 standard
6 //
7 // author: Gifto Team
8 // Contact: datwhnguyen@gmail.com
9 
10 contract ERC20Interface {
11     // Get the total token supply
12     function totalSupply() public constant returns (uint256 _totalSupply);
13  
14     // Get the account balance of another account with address _owner
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16  
17     // Send _value amount of tokens to address _to
18     function transfer(address _to, uint256 _value) public returns (bool success);
19     
20     // transfer _value amount of token approved by address _from
21     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
22 
23     // approve an address with _value amount of tokens
24     function approve(address _spender, uint256 _value) public returns (bool success);
25 
26     // get remaining token approved by _owner to _spender
27     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
28   
29     // Triggered when tokens are transferred.
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31  
32     // Triggered whenever approve(address _spender, uint256 _value) is called.
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35  
36 contract Gifto is ERC20Interface {
37     uint256 public constant decimals = 5;
38 
39     string public constant symbol = "GTO";
40     string public constant name = "Gifto";
41 
42     bool public _selling = true;//initial selling
43     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 Gifto
44     uint256 public _originalBuyPrice = 43 * 10**7; // original buy 1ETH = 4300 Gifto = 43 * 10**7 unit
45 
46     // Owner of this contract
47     address public owner;
48  
49     // Balances Gifto for each account
50     mapping(address => uint256) private balances;
51     
52     // Owner of account approves the transfer of an amount to another account
53     mapping(address => mapping (address => uint256)) private allowed;
54 
55     // List of approved investors
56     mapping(address => bool) private approvedInvestorList;
57     
58     // deposit
59     mapping(address => uint256) private deposit;
60     
61     // icoPercent
62     uint256 public _icoPercent = 10;
63     
64     // _icoSupply is the avalable unit. Initially, it is _totalSupply
65     uint256 public _icoSupply = _totalSupply * _icoPercent / 100;
66     
67     // minimum buy 0.3 ETH
68     uint256 public _minimumBuy = 3 * 10 ** 17;
69     
70     // maximum buy 25 ETH
71     uint256 public _maximumBuy = 25 * 10 ** 18;
72 
73     // totalTokenSold
74     uint256 public totalTokenSold = 0;
75     
76     // tradable
77     bool public tradable = false;
78     
79     /**
80      * Functions with this modifier can only be executed by the owner
81      */
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     /**
88      * Functions with this modifier check on sale status
89      * Only allow sale if _selling is on
90      */
91     modifier onSale() {
92         require(_selling);
93         _;
94     }
95     
96     /**
97      * Functions with this modifier check the validity of address is investor
98      */
99     modifier validInvestor() {
100         require(approvedInvestorList[msg.sender]);
101         _;
102     }
103     
104     /**
105      * Functions with this modifier check the validity of msg value
106      * value must greater than equal minimumBuyPrice
107      * total deposit must less than equal maximumBuyPrice
108      */
109     modifier validValue(){
110         // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice
111         require ( (msg.value >= _minimumBuy) &&
112                 ( (deposit[msg.sender] + msg.value) <= _maximumBuy) );
113         _;
114     }
115     
116     /**
117      * 
118      */
119     modifier isTradable(){
120         require(tradable == true || msg.sender == owner);
121         _;
122     }
123 
124     /// @dev Fallback function allows to buy ether.
125     function()
126         public
127         payable {
128         buyGifto();
129     }
130     
131     /// @dev buy function allows to buy ether. for using optional data
132     function buyGifto()
133         public
134         payable
135         onSale
136         validValue
137         validInvestor {
138         uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;
139         require(balances[owner] >= requestedUnits);
140         // prepare transfer data
141         balances[owner] -= requestedUnits;
142         balances[msg.sender] += requestedUnits;
143         
144         // increase total deposit amount
145         deposit[msg.sender] += msg.value;
146         
147         // check total and auto turnOffSale
148         totalTokenSold += requestedUnits;
149         if (totalTokenSold >= _icoSupply){
150             _selling = false;
151         }
152         
153         // submit transfer
154         Transfer(owner, msg.sender, requestedUnits);
155         owner.transfer(msg.value);
156     }
157 
158     /// @dev Constructor
159     function Gifto() 
160         public {
161         owner = msg.sender;
162         setBuyPrice(_originalBuyPrice);
163         balances[owner] = _totalSupply;
164         Transfer(0x0, owner, _totalSupply);
165     }
166     
167     /// @dev Gets totalSupply
168     /// @return Total supply
169     function totalSupply()
170         public 
171         constant 
172         returns (uint256) {
173         return _totalSupply;
174     }
175     
176     /// @dev Enables sale 
177     function turnOnSale() onlyOwner 
178         public {
179         _selling = true;
180     }
181 
182     /// @dev Disables sale
183     function turnOffSale() onlyOwner 
184         public {
185         _selling = false;
186     }
187     
188     function turnOnTradable() 
189         public
190         onlyOwner{
191         tradable = true;
192     }
193     
194     /// @dev set new icoPercent
195     /// @param newIcoPercent new value of icoPercent
196     function setIcoPercent(uint256 newIcoPercent)
197         public 
198         onlyOwner {
199         _icoPercent = newIcoPercent;
200         _icoSupply = _totalSupply * _icoPercent / 100;
201     }
202     
203     /// @dev set new _maximumBuy
204     /// @param newMaximumBuy new value of _maximumBuy
205     function setMaximumBuy(uint256 newMaximumBuy)
206         public 
207         onlyOwner {
208         _maximumBuy = newMaximumBuy;
209     }
210 
211     /// @dev Updates buy price (owner ONLY)
212     /// @param newBuyPrice New buy price (in unit)
213     function setBuyPrice(uint256 newBuyPrice) 
214         onlyOwner 
215         public {
216         require(newBuyPrice>0);
217         _originalBuyPrice = newBuyPrice; // 3000 Gifto = 3000 00000 unit
218         // control _maximumBuy_USD = 10,000 USD, Gifto price is 0.1USD
219         // maximumBuy_Gifto = 100,000 Gifto = 100,000,00000 unit
220         // 3000 Gifto = 1ETH => maximumETH = 100,000,00000 / _originalBuyPrice
221         // 100,000,00000/3000 0000 ~ 33ETH => change to wei
222         _maximumBuy = 10**18 * 10000000000 /_originalBuyPrice;
223     }
224         
225     /// @dev Gets account's balance
226     /// @param _addr Address of the account
227     /// @return Account balance
228     function balanceOf(address _addr) 
229         public
230         constant 
231         returns (uint256) {
232         return balances[_addr];
233     }
234     
235     /// @dev check address is approved investor
236     /// @param _addr address
237     function isApprovedInvestor(address _addr)
238         public
239         constant
240         returns (bool) {
241         return approvedInvestorList[_addr];
242     }
243     
244     /// @dev get ETH deposit
245     /// @param _addr address get deposit
246     /// @return amount deposit of an buyer
247     function getDeposit(address _addr)
248         public
249         constant
250         returns(uint256){
251         return deposit[_addr];
252 }
253     
254     /// @dev Adds list of new investors to the investors list and approve all
255     /// @param newInvestorList Array of new investors addresses to be added
256     function addInvestorList(address[] newInvestorList)
257         onlyOwner
258         public {
259         for (uint256 i = 0; i < newInvestorList.length; i++){
260             approvedInvestorList[newInvestorList[i]] = true;
261         }
262     }
263 
264     /// @dev Removes list of investors from list
265     /// @param investorList Array of addresses of investors to be removed
266     function removeInvestorList(address[] investorList)
267         onlyOwner
268         public {
269         for (uint256 i = 0; i < investorList.length; i++){
270             approvedInvestorList[investorList[i]] = false;
271         }
272     }
273  
274     /// @dev Transfers the balance from msg.sender to an account
275     /// @param _to Recipient address
276     /// @param _amount Transfered amount in unit
277     /// @return Transfer status
278     function transfer(address _to, uint256 _amount)
279         public 
280         isTradable
281         returns (bool) {
282         // if sender's balance has enough unit and amount >= 0, 
283         //      and the sum is not overflow,
284         // then do transfer 
285         if ( (balances[msg.sender] >= _amount) &&
286              (_amount >= 0) && 
287              (balances[_to] + _amount > balances[_to]) ) {  
288 
289             balances[msg.sender] -= _amount;
290             balances[_to] += _amount;
291             Transfer(msg.sender, _to, _amount);
292             return true;
293         } else {
294             return false;
295         }
296     }
297      
298     // Send _value amount of tokens from address _from to address _to
299     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
300     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
301     // fees in sub-currencies; the command should fail unless the _from account has
302     // deliberately authorized the sender of the message via some mechanism; we propose
303     // these standardized APIs for approval:
304     function transferFrom(
305         address _from,
306         address _to,
307         uint256 _amount
308     )
309     public
310     isTradable
311     returns (bool success) {
312         if (balances[_from] >= _amount
313             && allowed[_from][msg.sender] >= _amount
314             && _amount > 0
315             && balances[_to] + _amount > balances[_to]) {
316             balances[_from] -= _amount;
317             allowed[_from][msg.sender] -= _amount;
318             balances[_to] += _amount;
319             Transfer(_from, _to, _amount);
320             return true;
321         } else {
322             return false;
323         }
324     }
325     
326     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
327     // If this function is called again it overwrites the current allowance with _value.
328     function approve(address _spender, uint256 _amount) 
329         public
330         isTradable
331         returns (bool success) {
332         allowed[msg.sender][_spender] = _amount;
333         Approval(msg.sender, _spender, _amount);
334         return true;
335     }
336     
337     // get allowance
338     function allowance(address _owner, address _spender) 
339         public
340         constant 
341         returns (uint256 remaining) {
342         return allowed[_owner][_spender];
343     }
344     
345     /// @dev Withdraws Ether in contract (Owner only)
346     /// @return Status of withdrawal
347     function withdraw() onlyOwner 
348         public 
349         returns (bool) {
350         return owner.send(this.balance);
351     }
352 }
353 
354 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
355 /// @author Stefan George - <stefan.george@consensys.net>
356 contract MultiSigWallet {
357 
358     uint constant public MAX_OWNER_COUNT = 50;
359 
360     event Confirmation(address indexed sender, uint indexed transactionId);
361     event Revocation(address indexed sender, uint indexed transactionId);
362     event Submission(uint indexed transactionId);
363     event Execution(uint indexed transactionId);
364     event ExecutionFailure(uint indexed transactionId);
365     event Deposit(address indexed sender, uint value);
366     event OwnerAddition(address indexed owner);
367     event OwnerRemoval(address indexed owner);
368     event RequirementChange(uint required);
369     event CoinCreation(address coin);
370 
371     mapping (uint => Transaction) public transactions;
372     mapping (uint => mapping (address => bool)) public confirmations;
373     mapping (address => bool) public isOwner;
374     address[] public owners;
375     uint public required;
376     uint public transactionCount;
377     bool flag = true;
378 
379     struct Transaction {
380         address destination;
381         uint value;
382         bytes data;
383         bool executed;
384     }
385 
386     modifier onlyWallet() {
387         if (msg.sender != address(this))
388             revert();
389         _;
390     }
391 
392     modifier ownerDoesNotExist(address owner) {
393         if (isOwner[owner])
394             revert();
395         _;
396     }
397 
398     modifier ownerExists(address owner) {
399         if (!isOwner[owner])
400             revert();
401         _;
402     }
403 
404     modifier transactionExists(uint transactionId) {
405         if (transactions[transactionId].destination == 0)
406             revert();
407         _;
408     }
409 
410     modifier confirmed(uint transactionId, address owner) {
411         if (!confirmations[transactionId][owner])
412             revert();
413         _;
414     }
415 
416     modifier notConfirmed(uint transactionId, address owner) {
417         if (confirmations[transactionId][owner])
418             revert();
419         _;
420     }
421 
422     modifier notExecuted(uint transactionId) {
423         if (transactions[transactionId].executed)
424             revert();
425         _;
426     }
427 
428     modifier notNull(address _address) {
429         if (_address == 0)
430             revert();
431         _;
432     }
433 
434     modifier validRequirement(uint ownerCount, uint _required) {
435         if (   ownerCount > MAX_OWNER_COUNT
436             || _required > ownerCount
437             || _required == 0
438             || ownerCount == 0)
439             revert();
440         _;
441     }
442 
443     /// @dev Fallback function allows to deposit ether.
444     function()
445         payable
446     {
447         if (msg.value > 0)
448             Deposit(msg.sender, msg.value);
449     }
450 
451     /*
452      * Public functions
453      */
454     /// @dev Contract constructor sets initial owners and required number of confirmations.
455     /// @param _owners List of initial owners.
456     /// @param _required Number of required confirmations.
457     function MultiSigWallet(address[] _owners, uint _required)
458         public
459         validRequirement(_owners.length, _required)
460     {
461         for (uint i=0; i<_owners.length; i++) {
462             if (isOwner[_owners[i]] || _owners[i] == 0)
463                 revert();
464             isOwner[_owners[i]] = true;
465         }
466         owners = _owners;
467         required = _required;
468     }
469 
470     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
471     /// @param owner Address of new owner.
472     function addOwner(address owner)
473         public
474         onlyWallet
475         ownerDoesNotExist(owner)
476         notNull(owner)
477         validRequirement(owners.length + 1, required)
478     {
479         isOwner[owner] = true;
480         owners.push(owner);
481         OwnerAddition(owner);
482     }
483 
484     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
485     /// @param owner Address of owner.
486     function removeOwner(address owner)
487         public
488         onlyWallet
489         ownerExists(owner)
490     {
491         isOwner[owner] = false;
492         for (uint i=0; i<owners.length - 1; i++)
493             if (owners[i] == owner) {
494                 owners[i] = owners[owners.length - 1];
495                 break;
496             }
497         owners.length -= 1;
498         if (required > owners.length)
499             changeRequirement(owners.length);
500         OwnerRemoval(owner);
501     }
502 
503     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
504     /// @param owner Address of owner to be replaced.
505     /// @param owner Address of new owner.
506     function replaceOwner(address owner, address newOwner)
507         public
508         onlyWallet
509         ownerExists(owner)
510         ownerDoesNotExist(newOwner)
511     {
512         for (uint i=0; i<owners.length; i++)
513             if (owners[i] == owner) {
514                 owners[i] = newOwner;
515                 break;
516             }
517         isOwner[owner] = false;
518         isOwner[newOwner] = true;
519         OwnerRemoval(owner);
520         OwnerAddition(newOwner);
521     }
522 
523     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
524     /// @param _required Number of required confirmations.
525     function changeRequirement(uint _required)
526         public
527         onlyWallet
528         validRequirement(owners.length, _required)
529     {
530         required = _required;
531         RequirementChange(_required);
532     }
533 
534     /// @dev Allows an owner to submit and confirm a transaction.
535     /// @param destination Transaction target address.
536     /// @param value Transaction ether value.
537     /// @param data Transaction data payload.
538     /// @return Returns transaction ID.
539     function submitTransaction(address destination, uint value, bytes data)
540         public
541         returns (uint transactionId)
542     {
543         transactionId = addTransaction(destination, value, data);
544         confirmTransaction(transactionId);
545     }
546 
547     /// @dev Allows an owner to confirm a transaction.
548     /// @param transactionId Transaction ID.
549     function confirmTransaction(uint transactionId)
550         public
551         ownerExists(msg.sender)
552         transactionExists(transactionId)
553         notConfirmed(transactionId, msg.sender)
554     {
555         confirmations[transactionId][msg.sender] = true;
556         Confirmation(msg.sender, transactionId);
557         executeTransaction(transactionId);
558     }
559 
560     /// @dev Allows an owner to revoke a confirmation for a transaction.
561     /// @param transactionId Transaction ID.
562     function revokeConfirmation(uint transactionId)
563         public
564         ownerExists(msg.sender)
565         confirmed(transactionId, msg.sender)
566         notExecuted(transactionId)
567     {
568         confirmations[transactionId][msg.sender] = false;
569         Revocation(msg.sender, transactionId);
570     }
571 
572     /// @dev Allows anyone to execute a confirmed transaction.
573     /// @param transactionId Transaction ID.
574     function executeTransaction(uint transactionId)
575         public
576         notExecuted(transactionId)
577     {
578         if (isConfirmed(transactionId)) {
579             Transaction tx = transactions[transactionId];
580             tx.executed = true;
581             if (tx.destination.call.value(tx.value)(tx.data))
582                 Execution(transactionId);
583             else {
584                 ExecutionFailure(transactionId);
585                 tx.executed = false;
586             }
587         }
588     }
589 
590     /// @dev Returns the confirmation status of a transaction.
591     /// @param transactionId Transaction ID.
592     /// @return Confirmation status.
593     function isConfirmed(uint transactionId)
594         public
595         constant
596         returns (bool)
597     {
598         uint count = 0;
599         for (uint i=0; i<owners.length; i++) {
600             if (confirmations[transactionId][owners[i]])
601                 count += 1;
602             if (count == required)
603                 return true;
604         }
605     }
606 
607     /*
608      * Internal functions
609      */
610     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
611     /// @param destination Transaction target address.
612     /// @param value Transaction ether value.
613     /// @param data Transaction data payload.
614     /// @return Returns transaction ID.
615     function addTransaction(address destination, uint value, bytes data)
616         internal
617         notNull(destination)
618         returns (uint transactionId)
619     {
620         transactionId = transactionCount;
621         transactions[transactionId] = Transaction({
622             destination: destination,
623             value: value,
624             data: data,
625             executed: false
626         });
627         transactionCount += 1;
628         Submission(transactionId);
629     }
630 
631     /*
632      * Web3 call functions
633      */
634     /// @dev Returns number of confirmations of a transaction.
635     /// @param transactionId Transaction ID.
636     /// @return Number of confirmations.
637     function getConfirmationCount(uint transactionId)
638         public
639         constant
640         returns (uint count)
641     {
642         for (uint i=0; i<owners.length; i++)
643             if (confirmations[transactionId][owners[i]])
644                 count += 1;
645     }
646 
647     /// @dev Returns total number of transactions after filers are applied.
648     /// @param pending Include pending transactions.
649     /// @param executed Include executed transactions.
650     /// @return Total number of transactions after filters are applied.
651     function getTransactionCount(bool pending, bool executed)
652         public
653         constant
654         returns (uint count)
655     {
656         for (uint i=0; i<transactionCount; i++)
657             if (   pending && !transactions[i].executed
658                 || executed && transactions[i].executed)
659                 count += 1;
660     }
661 
662     /// @dev Returns list of owners.
663     /// @return List of owner addresses.
664     function getOwners()
665         public
666         constant
667         returns (address[])
668     {
669         return owners;
670     }
671 
672     /// @dev Returns array with owner addresses, which confirmed transaction.
673     /// @param transactionId Transaction ID.
674     /// @return Returns array of owner addresses.
675     function getConfirmations(uint transactionId)
676         public
677         constant
678         returns (address[] _confirmations)
679     {
680         address[] memory confirmationsTemp = new address[](owners.length);
681         uint count = 0;
682         uint i;
683         for (i=0; i<owners.length; i++)
684             if (confirmations[transactionId][owners[i]]) {
685                 confirmationsTemp[count] = owners[i];
686                 count += 1;
687             }
688         _confirmations = new address[](count);
689         for (i=0; i<count; i++)
690             _confirmations[i] = confirmationsTemp[i];
691     }
692 
693     /// @dev Returns list of transaction IDs in defined range.
694     /// @param from Index start position of transaction array.
695     /// @param to Index end position of transaction array.
696     /// @param pending Include pending transactions.
697     /// @param executed Include executed transactions.
698     /// @return Returns array of transaction IDs.
699     function getTransactionIds(uint from, uint to, bool pending, bool executed)
700         public
701         constant
702         returns (uint[] _transactionIds)
703     {
704         uint[] memory transactionIdsTemp = new uint[](transactionCount);
705         uint count = 0;
706         uint i;
707         for (i=0; i<transactionCount; i++)
708             if (   pending && !transactions[i].executed
709                 || executed && transactions[i].executed)
710             {
711                 transactionIdsTemp[count] = i;
712                 count += 1;
713             }
714         _transactionIds = new uint[](to - from);
715         for (i=from; i<to; i++)
716             _transactionIds[i - from] = transactionIdsTemp[i];
717     }
718     
719     /// @dev Create new coin.
720     function createCoin()
721         external
722         onlyWallet
723     {
724         require(flag == true);
725         CoinCreation(new Gifto());
726         flag = false;
727     }
728 }