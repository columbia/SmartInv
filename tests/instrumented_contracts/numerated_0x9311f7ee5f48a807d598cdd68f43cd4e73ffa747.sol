1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // GTO Token by GTO Limited.
5 // An ERC20 standard
6 //
7 // author: GTO Team
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
36 contract GTO is ERC20Interface {
37     uint8 public constant decimals = 5;
38 
39     string public constant symbol = "GTO";
40     string public constant name = "GTO";
41 
42     bool public _selling = false;//initial not selling
43     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 GTO
44     uint256 public _originalBuyPrice = 45 * 10**7; // original buy 1ETH = 4500 GTO = 45 * 10**7 unit
45 
46     // Owner of this contract
47     address public owner;
48  
49     // Balances GTO for each account
50     mapping(address => uint256) private balances;
51     
52     // Owner of account approves the transfer of an amount to another account
53     mapping(address => mapping (address => uint256)) private allowed;
54 
55     // List of approved investors
56     mapping(address => bool) private approvedInvestorList;
57     
58     // mapping Deposit
59     mapping(address => uint256) private deposit;
60     
61     // buyers buy token deposit
62     address[] private buyers;
63     
64     // icoPercent
65     uint8 public _icoPercent = 10;
66     
67     // _icoSupply is the avalable unit. Initially, it is _totalSupply
68     uint256 public _icoSupply = _totalSupply * _icoPercent / 100;
69     
70     // minimum buy 0.3 ETH
71     uint256 public _minimumBuy = 3 * 10 ** 17;
72     
73     // maximum buy 30 ETH
74     uint256 public _maximumBuy = 30 * 10 ** 18;
75     
76     /**
77      * Functions with this modifier can only be executed by the owner
78      */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     /**
85      * Functions with this modifier check on sale status
86      * Only allow sale if _selling is on
87      */
88     modifier onSale() {
89         require(_selling && (_icoSupply > 0) );
90         _;
91     }
92     
93     /**
94      * Functions with this modifier check the validity of address is investor
95      */
96     modifier validInvestor() {
97         require(approvedInvestorList[msg.sender]);
98         _;
99     }
100     
101     /**
102      * Functions with this modifier check the validity of msg value
103      * value must greater than equal minimumBuyPrice
104      * total deposit must less than equal maximumBuyPrice
105      */
106     modifier validValue(){
107         // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice
108         require ( (msg.value >= _minimumBuy) &&
109                 ( (deposit[msg.sender] + msg.value) <= _maximumBuy) );
110         _;
111     }
112     
113     /**
114      * Functions with this modifier check the validity of range [a, b] <= [0, buyers.length-1]
115      */
116     modifier validRange(uint256 a, uint256 b){
117         require ( (a>=0 && a<=b) &&
118                   (b<buyers.length) );
119         _;
120     }
121 
122     /// @dev Fallback function allows to buy ether.
123     function()
124         public
125         payable {
126         buyGifto();
127     }
128     
129     /// @dev buy function allows to buy ether. for using optional data
130     function buyGifto()
131         public
132         payable
133         onSale
134         validValue
135         validInvestor {
136         // check the first buy => push to Array
137         if (deposit[msg.sender] == 0){
138             // add new buyer to List
139             buyers.push(msg.sender);
140         }
141         // increase amount deposit of buyer
142         deposit[msg.sender] += msg.value;
143         // transfer value directly for owner
144         owner.transfer(msg.value);
145     }
146 
147     /// @dev Constructor
148     function GTO() 
149         public {
150         owner = msg.sender;
151         // buyers = new address[](1);
152         balances[owner] = _totalSupply;
153         Transfer(0x0, owner, _totalSupply);
154     }
155     
156     /// @dev Gets totalSupply
157     /// @return Total supply
158     function totalSupply()
159         public 
160         constant 
161         returns (uint256) {
162         return _totalSupply;
163     }
164     
165     /// @dev Enables sale 
166     function turnOnSale() onlyOwner 
167         public {
168         _selling = true;
169     }
170 
171     /// @dev Disables sale
172     function turnOffSale() onlyOwner 
173         public {
174         _selling = false;
175     }
176     
177     /// @dev set new icoPercent
178     /// @param newIcoPercent new value of icoPercent
179     function setIcoPercent(uint8 newIcoPercent)
180         public 
181         onlyOwner {
182         _icoPercent = newIcoPercent;
183         _icoSupply = _totalSupply * _icoPercent / 100;
184     }
185     
186     /// @dev set new _maximumBuy
187     /// @param newMaximumBuy new value of _maximumBuy
188     function setMaximumBuy(uint256 newMaximumBuy)
189         public 
190         onlyOwner {
191         _maximumBuy = newMaximumBuy;
192     }
193 
194     /// @dev Updates buy price (owner ONLY)
195     /// @param newBuyPrice New buy price (in unit)
196     function setBuyPrice(uint256 newBuyPrice) 
197         onlyOwner 
198         public {
199         require(newBuyPrice>0);
200         _originalBuyPrice = newBuyPrice; // 3000 GTO = 3000 00000 unit
201         // control _maximumBuy_USD = 10,000 USD, GTO price is 0.1USD
202         // maximumBuy_Gifto = 100,000 GTO = 100,000,00000 unit
203         // 3000 GTO = 1ETH => maximumETH = 100,000,00000 / _originalBuyPrice
204         // 100,000,00000/3000 0000 ~ 33ETH => change to wei
205         _maximumBuy = 10**18 * 10000000000 /_originalBuyPrice;
206     }
207         
208     /// @dev Gets account's balance
209     /// @param _addr Address of the account
210     /// @return Account balance
211     function balanceOf(address _addr) 
212         public
213         constant 
214         returns (uint256) {
215         return balances[_addr];
216     }
217     
218     /// @dev check address is approved investor
219     /// @param _addr address
220     function isApprovedInvestor(address _addr)
221         public
222         constant
223         returns (bool) {
224         return approvedInvestorList[_addr];
225     }
226     
227     /// @dev get investors deposited
228     function getBuyers()
229     public
230     constant
231     returns(address[]){
232         return buyers;
233     }
234     
235     /// @dev get ETH deposit
236     /// @param _addr address get deposit
237     /// @return amount deposit of an buyer
238     function getDeposit(address _addr)
239         public
240         constant
241         returns(uint256){
242         return deposit[_addr];
243     }
244     
245     /// @dev Adds list of new investors to the investors list and approve all
246     /// @param newInvestorList Array of new investors addresses to be added
247     function addInvestorList(address[] newInvestorList)
248         onlyOwner
249         public {
250         for (uint256 i = 0; i < newInvestorList.length; i++){
251             approvedInvestorList[newInvestorList[i]] = true;
252         }
253     }
254 
255     /// @dev Removes list of investors from list
256     /// @param investorList Array of addresses of investors to be removed
257     function removeInvestorList(address[] investorList)
258         onlyOwner
259         public {
260         for (uint256 i = 0; i < investorList.length; i++){
261             approvedInvestorList[investorList[i]] = false;
262         }
263     }
264     
265     /// @dev delivery token for buyer
266     /// @param a start point
267     /// @param b end point
268     function deliveryToken(uint256 a, uint256 b)
269         public
270         onlyOwner
271         validRange(a, b) {
272         // make sure balances owner greater than _icoSupply
273         require(balances[owner] >= _icoSupply);
274         for (uint256 i = a; i <= b; i++){
275             if(approvedInvestorList[buyers[i]]){
276                 // compute amount token of each buyer
277                 uint256 requestedUnits = (deposit[buyers[i]] * _originalBuyPrice) / 10**18;
278                 
279                 //check requestedUnits > _icoSupply
280                 if(requestedUnits <= _icoSupply && requestedUnits > 0 ){
281                     // prepare transfer data
282                     balances[owner] -= requestedUnits;
283                     balances[buyers[i]] += requestedUnits;
284                     _icoSupply -= requestedUnits;
285                     
286                     // submit transfer
287                     Transfer(owner, buyers[i], requestedUnits);
288                     
289                     // reset deposit of buyer
290                     deposit[buyers[i]] = 0;
291                 }
292             }
293         }
294     }
295  
296     /// @dev Transfers the balance from Multisig wallet to an account
297     /// @param _to Recipient address
298     /// @param _amount Transfered amount in unit
299     /// @return Transfer status
300     function transfer(address _to, uint256 _amount)
301         public 
302         returns (bool) {
303         // if sender's balance has enough unit and amount >= 0, 
304         //      and the sum is not overflow,
305         // then do transfer 
306         if ( (balances[msg.sender] >= _amount) &&
307              (_amount >= 0) && 
308              (balances[_to] + _amount > balances[_to]) ) {  
309 
310             balances[msg.sender] -= _amount;
311             balances[_to] += _amount;
312             Transfer(msg.sender, _to, _amount);
313             return true;
314         } else {
315             return false;
316         }
317     }
318      
319     // Send _value amount of tokens from address _from to address _to
320     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
321     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
322     // fees in sub-currencies; the command should fail unless the _from account has
323     // deliberately authorized the sender of the message via some mechanism; we propose
324     // these standardized APIs for approval:
325     function transferFrom(
326         address _from,
327         address _to,
328         uint256 _amount
329     )
330     public
331     returns (bool success) {
332         if (balances[_from] >= _amount
333             && allowed[_from][msg.sender] >= _amount
334             && _amount > 0
335             && balances[_to] + _amount > balances[_to]) {
336             balances[_from] -= _amount;
337             allowed[_from][msg.sender] -= _amount;
338             balances[_to] += _amount;
339             Transfer(_from, _to, _amount);
340             return true;
341         } else {
342             return false;
343         }
344     }
345     
346     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
347     // If this function is called again it overwrites the current allowance with _value.
348     function approve(address _spender, uint256 _amount) 
349         public
350         returns (bool success) {
351         allowed[msg.sender][_spender] = _amount;
352         Approval(msg.sender, _spender, _amount);
353         return true;
354     }
355     
356     // get allowance
357     function allowance(address _owner, address _spender) 
358         public
359         constant 
360         returns (uint256 remaining) {
361         return allowed[_owner][_spender];
362     }
363     
364     /// @dev Withdraws Ether in contract (Owner only)
365     /// @return Status of withdrawal
366     function withdraw() onlyOwner 
367         public 
368         returns (bool) {
369         return owner.send(this.balance);
370     }
371 }
372 
373 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
374 /// @author Stefan George - <stefan.george@consensys.net>
375 contract MultiSigWallet {
376 
377     uint constant public MAX_OWNER_COUNT = 50;
378 
379     event Confirmation(address indexed sender, uint indexed transactionId);
380     event Revocation(address indexed sender, uint indexed transactionId);
381     event Submission(uint indexed transactionId);
382     event Execution(uint indexed transactionId);
383     event ExecutionFailure(uint indexed transactionId);
384     event Deposit(address indexed sender, uint value);
385     event OwnerAddition(address indexed owner);
386     event OwnerRemoval(address indexed owner);
387     event RequirementChange(uint required);
388     event CoinCreation(address coin);
389 
390     mapping (uint => Transaction) public transactions;
391     mapping (uint => mapping (address => bool)) public confirmations;
392     mapping (address => bool) public isOwner;
393     address[] public owners;
394     uint public required;
395     uint public transactionCount;
396     bool flag = true;
397 
398     struct Transaction {
399         address destination;
400         uint value;
401         bytes data;
402         bool executed;
403     }
404 
405     modifier onlyWallet() {
406         if (msg.sender != address(this))
407             revert();
408         _;
409     }
410 
411     modifier ownerDoesNotExist(address owner) {
412         if (isOwner[owner])
413             revert();
414         _;
415     }
416 
417     modifier ownerExists(address owner) {
418         if (!isOwner[owner])
419             revert();
420         _;
421     }
422 
423     modifier transactionExists(uint transactionId) {
424         if (transactions[transactionId].destination == 0)
425             revert();
426         _;
427     }
428 
429     modifier confirmed(uint transactionId, address owner) {
430         if (!confirmations[transactionId][owner])
431             revert();
432         _;
433     }
434 
435     modifier notConfirmed(uint transactionId, address owner) {
436         if (confirmations[transactionId][owner])
437             revert();
438         _;
439     }
440 
441     modifier notExecuted(uint transactionId) {
442         if (transactions[transactionId].executed)
443             revert();
444         _;
445     }
446 
447     modifier notNull(address _address) {
448         if (_address == 0)
449             revert();
450         _;
451     }
452 
453     modifier validRequirement(uint ownerCount, uint _required) {
454         if (   ownerCount > MAX_OWNER_COUNT
455             || _required > ownerCount
456             || _required == 0
457             || ownerCount == 0)
458             revert();
459         _;
460     }
461 
462     /// @dev Fallback function allows to deposit ether.
463     function()
464         payable
465     {
466         if (msg.value > 0)
467             Deposit(msg.sender, msg.value);
468     }
469 
470     /*
471      * Public functions
472      */
473     /// @dev Contract constructor sets initial owners and required number of confirmations.
474     /// @param _owners List of initial owners.
475     /// @param _required Number of required confirmations.
476     function MultiSigWallet(address[] _owners, uint _required)
477         public
478         validRequirement(_owners.length, _required)
479     {
480         for (uint i=0; i<_owners.length; i++) {
481             if (isOwner[_owners[i]] || _owners[i] == 0)
482                 revert();
483             isOwner[_owners[i]] = true;
484         }
485         owners = _owners;
486         required = _required;
487     }
488 
489     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
490     /// @param owner Address of new owner.
491     function addOwner(address owner)
492         public
493         onlyWallet
494         ownerDoesNotExist(owner)
495         notNull(owner)
496         validRequirement(owners.length + 1, required)
497     {
498         isOwner[owner] = true;
499         owners.push(owner);
500         OwnerAddition(owner);
501     }
502 
503     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
504     /// @param owner Address of owner.
505     function removeOwner(address owner)
506         public
507         onlyWallet
508         ownerExists(owner)
509     {
510         isOwner[owner] = false;
511         for (uint i=0; i<owners.length - 1; i++)
512             if (owners[i] == owner) {
513                 owners[i] = owners[owners.length - 1];
514                 break;
515             }
516         owners.length -= 1;
517         if (required > owners.length)
518             changeRequirement(owners.length);
519         OwnerRemoval(owner);
520     }
521 
522     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
523     /// @param owner Address of owner to be replaced.
524     /// @param owner Address of new owner.
525     function replaceOwner(address owner, address newOwner)
526         public
527         onlyWallet
528         ownerExists(owner)
529         ownerDoesNotExist(newOwner)
530     {
531         for (uint i=0; i<owners.length; i++)
532             if (owners[i] == owner) {
533                 owners[i] = newOwner;
534                 break;
535             }
536         isOwner[owner] = false;
537         isOwner[newOwner] = true;
538         OwnerRemoval(owner);
539         OwnerAddition(newOwner);
540     }
541 
542     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
543     /// @param _required Number of required confirmations.
544     function changeRequirement(uint _required)
545         public
546         onlyWallet
547         validRequirement(owners.length, _required)
548     {
549         required = _required;
550         RequirementChange(_required);
551     }
552 
553     /// @dev Allows an owner to submit and confirm a transaction.
554     /// @param destination Transaction target address.
555     /// @param value Transaction ether value.
556     /// @param data Transaction data payload.
557     /// @return Returns transaction ID.
558     function submitTransaction(address destination, uint value, bytes data)
559         public
560         returns (uint transactionId)
561     {
562         transactionId = addTransaction(destination, value, data);
563         confirmTransaction(transactionId);
564     }
565 
566     /// @dev Allows an owner to confirm a transaction.
567     /// @param transactionId Transaction ID.
568     function confirmTransaction(uint transactionId)
569         public
570         ownerExists(msg.sender)
571         transactionExists(transactionId)
572         notConfirmed(transactionId, msg.sender)
573     {
574         confirmations[transactionId][msg.sender] = true;
575         Confirmation(msg.sender, transactionId);
576         executeTransaction(transactionId);
577     }
578 
579     /// @dev Allows an owner to revoke a confirmation for a transaction.
580     /// @param transactionId Transaction ID.
581     function revokeConfirmation(uint transactionId)
582         public
583         ownerExists(msg.sender)
584         confirmed(transactionId, msg.sender)
585         notExecuted(transactionId)
586     {
587         confirmations[transactionId][msg.sender] = false;
588         Revocation(msg.sender, transactionId);
589     }
590 
591     /// @dev Allows anyone to execute a confirmed transaction.
592     /// @param transactionId Transaction ID.
593     function executeTransaction(uint transactionId)
594         public
595         notExecuted(transactionId)
596     {
597         if (isConfirmed(transactionId)) {
598             Transaction tx = transactions[transactionId];
599             tx.executed = true;
600             if (tx.destination.call.value(tx.value)(tx.data))
601                 Execution(transactionId);
602             else {
603                 ExecutionFailure(transactionId);
604                 tx.executed = false;
605             }
606         }
607     }
608 
609     /// @dev Returns the confirmation status of a transaction.
610     /// @param transactionId Transaction ID.
611     /// @return Confirmation status.
612     function isConfirmed(uint transactionId)
613         public
614         constant
615         returns (bool)
616     {
617         uint count = 0;
618         for (uint i=0; i<owners.length; i++) {
619             if (confirmations[transactionId][owners[i]])
620                 count += 1;
621             if (count == required)
622                 return true;
623         }
624     }
625 
626     /*
627      * Internal functions
628      */
629     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
630     /// @param destination Transaction target address.
631     /// @param value Transaction ether value.
632     /// @param data Transaction data payload.
633     /// @return Returns transaction ID.
634     function addTransaction(address destination, uint value, bytes data)
635         internal
636         notNull(destination)
637         returns (uint transactionId)
638     {
639         transactionId = transactionCount;
640         transactions[transactionId] = Transaction({
641             destination: destination,
642             value: value,
643             data: data,
644             executed: false
645         });
646         transactionCount += 1;
647         Submission(transactionId);
648     }
649 
650     /*
651      * Web3 call functions
652      */
653     /// @dev Returns number of confirmations of a transaction.
654     /// @param transactionId Transaction ID.
655     /// @return Number of confirmations.
656     function getConfirmationCount(uint transactionId)
657         public
658         constant
659         returns (uint count)
660     {
661         for (uint i=0; i<owners.length; i++)
662             if (confirmations[transactionId][owners[i]])
663                 count += 1;
664     }
665 
666     /// @dev Returns total number of transactions after filers are applied.
667     /// @param pending Include pending transactions.
668     /// @param executed Include executed transactions.
669     /// @return Total number of transactions after filters are applied.
670     function getTransactionCount(bool pending, bool executed)
671         public
672         constant
673         returns (uint count)
674     {
675         for (uint i=0; i<transactionCount; i++)
676             if (   pending && !transactions[i].executed
677                 || executed && transactions[i].executed)
678                 count += 1;
679     }
680 
681     /// @dev Returns list of owners.
682     /// @return List of owner addresses.
683     function getOwners()
684         public
685         constant
686         returns (address[])
687     {
688         return owners;
689     }
690 
691     /// @dev Returns array with owner addresses, which confirmed transaction.
692     /// @param transactionId Transaction ID.
693     /// @return Returns array of owner addresses.
694     function getConfirmations(uint transactionId)
695         public
696         constant
697         returns (address[] _confirmations)
698     {
699         address[] memory confirmationsTemp = new address[](owners.length);
700         uint count = 0;
701         uint i;
702         for (i=0; i<owners.length; i++)
703             if (confirmations[transactionId][owners[i]]) {
704                 confirmationsTemp[count] = owners[i];
705                 count += 1;
706             }
707         _confirmations = new address[](count);
708         for (i=0; i<count; i++)
709             _confirmations[i] = confirmationsTemp[i];
710     }
711 
712     /// @dev Returns list of transaction IDs in defined range.
713     /// @param from Index start position of transaction array.
714     /// @param to Index end position of transaction array.
715     /// @param pending Include pending transactions.
716     /// @param executed Include executed transactions.
717     /// @return Returns array of transaction IDs.
718     function getTransactionIds(uint from, uint to, bool pending, bool executed)
719         public
720         constant
721         returns (uint[] _transactionIds)
722     {
723         uint[] memory transactionIdsTemp = new uint[](transactionCount);
724         uint count = 0;
725         uint i;
726         for (i=0; i<transactionCount; i++)
727             if (   pending && !transactions[i].executed
728                 || executed && transactions[i].executed)
729             {
730                 transactionIdsTemp[count] = i;
731                 count += 1;
732             }
733         _transactionIds = new uint[](to - from);
734         for (i=from; i<to; i++)
735             _transactionIds[i - from] = transactionIdsTemp[i];
736     }
737     
738     /// @dev Create new coin.
739     function createCoin()
740         external
741         onlyWallet
742     {
743         require(flag == true);
744         CoinCreation(new GTO());
745         flag = false;
746     }
747 }