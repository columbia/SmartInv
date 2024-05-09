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
20     // Triggered when tokens are transferred.
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22  
23     // Triggered whenever approve(address _spender, uint256 _value) is called.
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26  
27 contract Gifto is ERC20Interface {
28     uint public constant decimals = 5;
29 
30     string public constant symbol = "Gifto";
31     string public constant name = "Gifto";
32 
33     bool public _selling = false;//initial not selling
34     uint public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 Gifto
35     uint public _originalBuyPrice = 10 ** 10; // original buy in wei of one unit. Ajustable.
36 
37     // Owner of this contract
38     address public owner;
39  
40     // Balances Gifto for each account
41     mapping(address => uint256) balances;
42 
43     // List of approved investors
44     mapping(address => bool) approvedInvestorList;
45     
46     // mapping Deposit
47     mapping(address => uint256) deposit;
48     
49     // buyers buy token deposit
50     address[] buyers;
51     
52     // icoPercent
53     uint _icoPercent = 10;
54     
55     // _icoSupply is the avalable unit. Initially, it is _totalSupply
56     uint public _icoSupply = _totalSupply * _icoPercent / 100;
57     
58     // minimum buy 0.1 ETH
59     uint public _minimumBuy = 10 ** 17;
60     
61     // maximum buy 30 ETH
62     uint public _maximumBuy = 30 * 10 ** 18;
63     
64     /**
65      * Functions with this modifier can only be executed by the owner
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73      * Functions with this modifier can only be executed by users except owners
74      */
75     modifier onlyNotOwner() {
76         require(msg.sender != owner);
77         _;
78     }
79 
80     /**
81      * Functions with this modifier check on sale status
82      * Only allow sale if _selling is on
83      */
84     modifier onSale() {
85         require(_selling && (_icoSupply > 0) );
86         _;
87     }
88 
89     /**
90      * Functions with this modifier check the validity of original buy price
91      */
92     modifier validOriginalBuyPrice() {
93         require(_originalBuyPrice > 0);
94         _;
95     }
96     
97     /**
98      * Functions with this modifier check the validity of address is investor
99      */
100     modifier validInvestor() {
101         require(approvedInvestorList[msg.sender]);
102         _;
103     }
104     
105     /**
106      * Functions with this modifier check the validity of msg value
107      * value must greater than equal minimumBuyPrice
108      * total deposit must less than equal maximumBuyPrice
109      */
110     modifier validValue(){
111         // if value < _minimumBuy OR total deposit of msg.sender > maximumBuyPrice
112         require ( (msg.value >= _minimumBuy) &&
113                 ( (deposit[msg.sender] + msg.value) <= _maximumBuy) );
114         _;
115     }
116 
117     /// @dev Fallback function allows to buy ether.
118     function()
119         public
120         payable
121         validValue {
122         // check the first buy => push to Array
123         if (deposit[msg.sender] == 0 && msg.value != 0){
124             // add new buyer to List
125             buyers.push(msg.sender);
126         }
127         // increase amount deposit of buyer
128         deposit[msg.sender] += msg.value;
129     }
130 
131     /// @dev Constructor
132     function Gifto() 
133         public {
134         owner = msg.sender;
135         balances[owner] = _totalSupply;
136         Transfer(0x0, owner, _totalSupply);
137     }
138     
139     /// @dev Gets totalSupply
140     /// @return Total supply
141     function totalSupply()
142         public 
143         constant 
144         returns (uint256) {
145         return _totalSupply;
146     }
147     
148     /// @dev set new icoPercent
149     /// @param newIcoPercent new value of icoPercent
150     function setIcoPercent(uint256 newIcoPercent)
151         public 
152         onlyOwner
153         returns (bool){
154         _icoPercent = newIcoPercent;
155         _icoSupply = _totalSupply * _icoPercent / 100;
156     }
157     
158     /// @dev set new _minimumBuy
159     /// @param newMinimumBuy new value of _minimumBuy
160     function setMinimumBuy(uint256 newMinimumBuy)
161         public 
162         onlyOwner
163         returns (bool){
164         _minimumBuy = newMinimumBuy;
165     }
166     
167     /// @dev set new _maximumBuy
168     /// @param newMaximumBuy new value of _maximumBuy
169     function setMaximumBuy(uint256 newMaximumBuy)
170         public 
171         onlyOwner
172         returns (bool){
173         _maximumBuy = newMaximumBuy;
174     }
175  
176     /// @dev Gets account's balance
177     /// @param _addr Address of the account
178     /// @return Account balance
179     function balanceOf(address _addr) 
180         public
181         constant 
182         returns (uint256) {
183         return balances[_addr];
184     }
185     
186     /// @dev check address is approved investor
187     /// @param _addr address
188     function isApprovedInvestor(address _addr)
189         public
190         constant
191         returns (bool) {
192         return approvedInvestorList[_addr];
193     }
194     
195     /// @dev filter buyers in list buyers
196     /// @param isInvestor type buyers, is investor or not
197     function filterBuyers(bool isInvestor)
198         private
199         constant
200         returns(address[] filterList){
201         address[] memory filterTmp = new address[](buyers.length);
202         uint count = 0;
203         for (uint i = 0; i < buyers.length; i++){
204             if(approvedInvestorList[buyers[i]] == isInvestor){
205                 filterTmp[count] = buyers[i];
206                 count++;
207             }
208         }
209         
210         filterList = new address[](count);
211         for (i = 0; i < count; i++){
212             if(filterTmp[i] != 0x0){
213                 filterList[i] = filterTmp[i];
214             }
215         }
216     }
217     
218     /// @dev filter buyers are investor in list deposited
219     function getInvestorBuyers()
220         public
221         constant
222         returns(address[]){
223         return filterBuyers(true);
224     }
225     
226     /// @dev filter normal Buyers in list buyer deposited
227     function getNormalBuyers()
228         public
229         constant
230         returns(address[]){
231         return filterBuyers(false);
232     }
233     
234     /// @dev get ETH deposit
235     /// @param _addr address get deposit
236     /// @return amount deposit of an buyer
237     function getDeposit(address _addr)
238         public
239         constant
240         returns(uint256){
241         return deposit[_addr];
242     }
243     
244     /// @dev get total deposit of buyers
245     /// @return amount ETH deposit
246     function getTotalDeposit()
247         public
248         constant
249         returns(uint256 totalDeposit){
250         totalDeposit = 0;
251         for (uint i = 0; i < buyers.length; i++){
252             totalDeposit += deposit[buyers[i]];
253         }
254     }
255     
256     /// @dev delivery token for buyer
257     /// @param isInvestor transfer token for investor or not
258     ///         true: investors
259     ///         false: not investors
260     function deliveryToken(bool isInvestor)
261         public
262         onlyOwner
263         validOriginalBuyPrice {
264         //sumary deposit of investors
265         uint256 sum = 0;
266         
267         for (uint i = 0; i < buyers.length; i++){
268             if(approvedInvestorList[buyers[i]] == isInvestor) {
269                 
270                 // compute amount token of each buyer
271                 uint256 requestedUnits = deposit[buyers[i]] / _originalBuyPrice;
272                 
273                 //check requestedUnits > _icoSupply
274                 if(requestedUnits <= _icoSupply && requestedUnits > 0 ){
275                     // prepare transfer data
276                     // NOTE: make sure balances owner greater than _icoSupply
277                     balances[owner] -= requestedUnits;
278                     balances[buyers[i]] += requestedUnits;
279                     _icoSupply -= requestedUnits;
280                     
281                     // submit transfer
282                     Transfer(owner, buyers[i], requestedUnits);
283                     
284                     // reset deposit of buyer
285                     sum += deposit[buyers[i]];
286                     deposit[buyers[i]] = 0;
287                 }
288             }
289         }
290         //transfer total ETH of investors to owner
291         owner.transfer(sum);
292     }
293     
294     /// @dev return ETH for normal buyers
295     function returnETHforNormalBuyers()
296         public
297         onlyOwner{
298         for(uint i = 0; i < buyers.length; i++){
299             // buyer not approve investor
300             if (!approvedInvestorList[buyers[i]]) {
301                 // get deposit of buyer
302                 uint256 buyerDeposit = deposit[buyers[i]];
303                 // reset deposit of buyer
304                 deposit[buyers[i]] = 0;
305                 // return deposit amount for buyer
306                 buyers[i].transfer(buyerDeposit);
307             }
308         }
309     }
310  
311     /// @dev Transfers the balance from Multisig wallet to an account
312     /// @param _to Recipient address
313     /// @param _amount Transfered amount in unit
314     /// @return Transfer status
315     function transfer(address _to, uint256 _amount)
316         public 
317         returns (bool) {
318         // if sender's balance has enough unit and amount >= 0, 
319         //      and the sum is not overflow,
320         // then do transfer 
321         if ( (balances[msg.sender] >= _amount) &&
322              (_amount >= 0) && 
323              (balances[_to] + _amount > balances[_to]) ) {  
324 
325             balances[msg.sender] -= _amount;
326             balances[_to] += _amount;
327             Transfer(msg.sender, _to, _amount);
328             
329             return true;
330 
331         } else {
332             revert();
333         }
334     }
335 
336     /// @dev Enables sale 
337     function turnOnSale() onlyOwner 
338         public {
339         _selling = true;
340     }
341 
342     /// @dev Disables sale
343     function turnOffSale() onlyOwner 
344         public {
345         _selling = false;
346     }
347 
348     /// @dev Gets selling status
349     function isSellingNow() 
350         public 
351         constant
352         returns (bool) {
353         return _selling;
354     }
355 
356     /// @dev Updates buy price (owner ONLY)
357     /// @param newBuyPrice New buy price (in unit)
358     function setBuyPrice(uint newBuyPrice) 
359         onlyOwner 
360         public {
361         _originalBuyPrice = newBuyPrice;
362     }
363 
364     /// @dev Adds list of new investors to the investors list and approve all
365     /// @param newInvestorList Array of new investors addresses to be added
366     function addInvestorList(address[] newInvestorList)
367         onlyOwner
368         public {
369         for (uint i = 0; i < newInvestorList.length; i++){
370             approvedInvestorList[newInvestorList[i]] = true;
371         }
372     }
373 
374     /// @dev Removes list of investors from list
375     /// @param investorList Array of addresses of investors to be removed
376     function removeInvestorList(address[] investorList)
377         onlyOwner
378         public {
379         for (uint i = 0; i < investorList.length; i++){
380             approvedInvestorList[investorList[i]] = false;
381         }
382     }
383 
384     /// @dev Buys Gifto
385     /// @return Amount of requested units 
386     function buy() payable
387         onlyNotOwner 
388         validOriginalBuyPrice
389         validInvestor
390         onSale 
391         public
392         returns (uint256 amount) {
393         // convert buy amount in wei to number of unit want to buy
394         uint requestedUnits = msg.value / _originalBuyPrice ;
395         
396         //check requestedUnits <= _icoSupply
397         require(requestedUnits <= _icoSupply);
398 
399         // prepare transfer data
400         balances[owner] -= requestedUnits;
401         balances[msg.sender] += requestedUnits;
402         
403         // decrease _icoSupply
404         _icoSupply -= requestedUnits;
405 
406         // submit transfer
407         Transfer(owner, msg.sender, requestedUnits);
408 
409         //transfer ETH to owner
410         owner.transfer(msg.value);
411         
412         return requestedUnits;
413     }
414     
415     /// @dev Withdraws Ether in contract (Owner only)
416     /// @return Status of withdrawal
417     function withdraw() onlyOwner 
418         public 
419         returns (bool) {
420         return owner.send(this.balance);
421     }
422 }
423 
424 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
425 contract MultiSigWallet {
426 
427     event Confirmation(address sender, bytes32 transactionId);
428     event Revocation(address sender, bytes32 transactionId);
429     event Submission(bytes32 transactionId);
430     event Execution(bytes32 transactionId);
431     event Deposit(address sender, uint value);
432     event OwnerAddition(address owner);
433     event OwnerRemoval(address owner);
434     event RequirementChange(uint required);
435     event CoinCreation(address coin);
436 
437     mapping (bytes32 => Transaction) public transactions;
438     mapping (bytes32 => mapping (address => bool)) public confirmations;
439     mapping (address => bool) public isOwner;
440     address[] owners;
441     bytes32[] transactionList;
442     uint public required;
443 
444     struct Transaction {
445         address destination;
446         uint value;
447         bytes data;
448         uint nonce;
449         bool executed;
450     }
451 
452     modifier onlyWallet() {
453         require(msg.sender == address(this));
454         _;
455     }
456 
457     modifier ownerDoesNotExist(address owner) {
458         require(!isOwner[owner]);
459         _;
460     }
461 
462     modifier ownerExists(address owner) {
463         require(isOwner[owner]);
464         _;
465     }
466 
467     modifier confirmed(bytes32 transactionId, address owner) {
468         require(confirmations[transactionId][owner]);
469         _;
470     }
471 
472     modifier notConfirmed(bytes32 transactionId, address owner) {
473         require(!confirmations[transactionId][owner]);
474         _;
475     }
476 
477     modifier notExecuted(bytes32 transactionId) {
478         require(!transactions[transactionId].executed);
479         _;
480     }
481 
482     modifier notNull(address destination) {
483         require(destination != 0);
484         _;
485     }
486 
487     modifier validRequirement(uint _ownerCount, uint _required) {
488         require(   _required <= _ownerCount
489                 && _required > 0 );
490         _;
491     }
492     
493     /// @dev Contract constructor sets initial owners and required number of confirmations.
494     /// @param _owners List of initial owners.
495     /// @param _required Number of required confirmations.
496     function MultiSigWallet(address[] _owners, uint _required)
497         validRequirement(_owners.length, _required)
498         public {
499         for (uint i=0; i<_owners.length; i++) {
500             // check duplicate owner and invalid address
501             if (isOwner[_owners[i]] || _owners[i] == 0){
502                 revert();
503             }
504             // assign new owner
505             isOwner[_owners[i]] = true;
506         }
507         owners = _owners;
508         required = _required;
509     }
510 
511     ///  Fallback function allows to deposit ether.
512     function()
513         public
514         payable {
515         if (msg.value > 0)
516             Deposit(msg.sender, msg.value);
517     }
518 
519     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
520     /// @param owner Address of new owner.
521     function addOwner(address owner)
522         public
523         onlyWallet
524         ownerDoesNotExist(owner) {
525         isOwner[owner] = true;
526         owners.push(owner);
527         OwnerAddition(owner);
528     }
529 
530     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
531     /// @param owner Address of owner.
532     function removeOwner(address owner)
533         public
534         onlyWallet
535         ownerExists(owner) {
536         // DO NOT remove last owner
537         require(owners.length > 1);
538         
539         isOwner[owner] = false;
540         for (uint i=0; i<owners.length - 1; i++)
541             if (owners[i] == owner) {
542                 owners[i] = owners[owners.length - 1];
543                 break;
544             }
545         owners.length -= 1;
546         if (required > owners.length)
547             changeRequirement(owners.length);
548         OwnerRemoval(owner);
549     }
550 
551     /// @dev Update the minimum required owner for transaction validation
552     /// @param _required number of owners
553     function changeRequirement(uint _required)
554         public
555         onlyWallet
556         validRequirement(owners.length, _required) {
557         required = _required;
558         RequirementChange(_required);
559     }
560 
561     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
562     /// @param destination Transaction target address.
563     /// @param value Transaction ether value.
564     /// @param data Transaction data payload.
565     /// @param nonce 
566     /// @return transactionId.
567     function addTransaction(address destination, uint value, bytes data, uint nonce)
568         private
569         notNull(destination)
570         returns (bytes32 transactionId) {
571         // transactionId = sha3(destination, value, data, nonce);
572         transactionId = keccak256(destination, value, data, nonce);
573         if (transactions[transactionId].destination == 0) {
574             transactions[transactionId] = Transaction({
575                 destination: destination,
576                 value: value,
577                 data: data,
578                 nonce: nonce,
579                 executed: false
580             });
581             transactionList.push(transactionId);
582             Submission(transactionId);
583         }
584     }
585 
586     /// @dev Allows an owner to submit and confirm a transaction.
587     /// @param destination Transaction target address.
588     /// @param value Transaction ether value.
589     /// @param data Transaction data payload.
590     /// @param nonce 
591     /// @return transactionId.
592     function submitTransaction(address destination, uint value, bytes data, uint nonce)
593         external
594         ownerExists(msg.sender)
595         returns (bytes32 transactionId) {
596         transactionId = addTransaction(destination, value, data, nonce);
597         confirmTransaction(transactionId);
598     }
599 
600     /// @dev Allows an owner to confirm a transaction.
601     /// @param transactionId transaction Id.
602     function confirmTransaction(bytes32 transactionId)
603         public
604         ownerExists(msg.sender)
605         notConfirmed(transactionId, msg.sender) {
606         confirmations[transactionId][msg.sender] = true;
607         Confirmation(msg.sender, transactionId);
608         executeTransaction(transactionId);
609     }
610 
611     
612     /// @dev Allows anyone to execute a confirmed transaction.
613     /// @param transactionId transaction Id.
614     function executeTransaction(bytes32 transactionId)
615         public
616         notExecuted(transactionId) {
617         if (isConfirmed(transactionId)) {
618             Transaction storage txn = transactions[transactionId]; 
619             txn.executed = true;
620             if (!txn.destination.call.value(txn.value)(txn.data))
621                 revert();
622             Execution(transactionId);
623         }
624     }
625 
626     /// @dev Allows an owner to revoke a confirmation for a transaction.
627     /// @param transactionId transaction Id.
628     function revokeConfirmation(bytes32 transactionId)
629         external
630         ownerExists(msg.sender)
631         confirmed(transactionId, msg.sender)
632         notExecuted(transactionId) {
633         confirmations[transactionId][msg.sender] = false;
634         Revocation(msg.sender, transactionId);
635     }
636 
637     /// @dev Returns the confirmation status of a transaction.
638     /// @param transactionId transaction Id.
639     /// @return Confirmation status.
640     function isConfirmed(bytes32 transactionId)
641         public
642         constant
643         returns (bool) {
644         uint count = 0;
645         for (uint i=0; i<owners.length; i++)
646             if (confirmations[transactionId][owners[i]])
647                 count += 1;
648             if (count == required)
649                 return true;
650     }
651 
652     /*
653      * Web3 call functions
654      */
655     /// @dev Returns number of confirmations of a transaction.
656     /// @param transactionId transaction Id.
657     /// @return Number of confirmations.
658     function confirmationCount(bytes32 transactionId)
659         external
660         constant
661         returns (uint count) {
662         for (uint i=0; i<owners.length; i++)
663             if (confirmations[transactionId][owners[i]])
664                 count += 1;
665     }
666 
667     ///  @dev Return list of transactions after filters are applied
668     ///  @param isPending pending status
669     ///  @return List of transactions
670     function filterTransactions(bool isPending)
671         private
672         constant
673         returns (bytes32[] _transactionList) {
674         bytes32[] memory _transactionListTemp = new bytes32[](transactionList.length);
675         uint count = 0;
676         for (uint i=0; i<transactionList.length; i++)
677             if (transactions[transactionList[i]].executed != isPending)
678             {
679                 _transactionListTemp[count] = transactionList[i];
680                 count += 1;
681             }
682         _transactionList = new bytes32[](count);
683         for (i=0; i<count; i++)
684             if (_transactionListTemp[i] > 0)
685                 _transactionList[i] = _transactionListTemp[i];
686     }
687 
688     /// @dev Returns list of pending transactions
689     function getPendingTransactions()
690         external
691         constant
692         returns (bytes32[]) {
693         return filterTransactions(true);
694     }
695 
696     /// @dev Returns list of executed transactions
697     function getExecutedTransactions()
698         external
699         constant
700         returns (bytes32[]) {
701         return filterTransactions(false);
702     }
703     
704     /// @dev Create new coin.
705     function createCoin()
706         external
707         onlyWallet
708     {
709         CoinCreation(new Gifto());
710     }
711 }