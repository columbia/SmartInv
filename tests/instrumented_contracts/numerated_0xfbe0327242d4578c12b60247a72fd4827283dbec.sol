1 pragma solidity ^0.4.20;
2 // ----------------------------------------------------------------------------------------------
3 // CGRID Token by CGRID Limited.
4 // An ERC223 standard
5 //
6 // author: CGRID Team
7 // Contact: contact@carbongrid.io
8 
9 library SafeMath {
10 
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15 
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20 
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25 
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 
31 }
32 
33 contract ERC20 {
34     // Get the total token supply
35     function totalSupply() public constant returns (uint256 _totalSupply);
36  
37     // Get the account balance of another account with address _owner
38     function balanceOf(address _owner) public constant returns (uint256 balance);
39  
40     // Send _value amount of tokens to address _to
41     function transfer(address _to, uint256 _value) public returns (bool success);
42     
43     // transfer _value amount of token approved by address _from
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
45     
46     // approve an address with _value amount of tokens
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     // get remaining token approved by _owner to _spender
50     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
51   
52     // Triggered when tokens are transferred.
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54  
55     // Triggered whenever approve(address _spender, uint256 _value) is called.
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 contract ERC223 is ERC20{
60     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
61     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
62     event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);
63 }
64 
65 /// contract receiver interface
66 contract ContractReceiver {  
67     function tokenFallback(address _from, uint _value, bytes _data) external;
68 }
69 
70 contract BasicCGRID is ERC223 {
71     using SafeMath for uint256;
72     
73     uint256 public constant decimals = 8;
74     string public constant symbol = "CGRID";
75     string public constant name = "Carbon Grid Token";
76     uint256 public _totalSupply = 10**17; // total supply is 10^17 unit, equivalent to 1 Billion CGRID
77 
78     // Owner of this contract
79     address public owner;
80     address public airdrop;
81 
82     // tradable
83     bool public tradable = false;
84 
85     // Balances CGRID for each account
86     mapping(address => uint256) balances;
87     
88     // Owner of account approves the transfer of an amount to another account
89     mapping(address => mapping (address => uint256)) allowed;
90             
91     /**
92      * Functions with this modifier can only be executed by the owner
93      */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     modifier isTradable(){
100         require(tradable == true || msg.sender == airdrop || msg.sender == owner);
101         _;
102     }
103 
104     /// @dev Constructor
105     function BasicCGRID() 
106     public {
107         owner = msg.sender;
108         balances[owner] = _totalSupply;
109         Transfer(0x0, owner, _totalSupply);
110         airdrop = 0x00227086ab72678903091d315b04a8dacade39647a;
111     }
112     
113     /// @dev Gets totalSupply
114     /// @return Total supply
115     function totalSupply()
116     public 
117     constant 
118     returns (uint256) {
119         return _totalSupply;
120     }
121         
122     /// @dev Gets account's balance
123     /// @param _addr Address of the account
124     /// @return Account balance
125     function balanceOf(address _addr) 
126     public
127     constant 
128     returns (uint256) {
129         return balances[_addr];
130     }
131     
132     
133     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
134     function isContract(address _addr) 
135     private 
136     view 
137     returns (bool is_contract) {
138         uint length;
139         assembly {
140             //retrieve the size of the code on target address, this needs assembly
141             length := extcodesize(_addr)
142         }
143         return (length>0);
144     }
145  
146     /// @dev Transfers the balance from msg.sender to an account
147     /// @param _to Recipient address
148     /// @param _value Transfered amount in unit
149     /// @return Transfer status
150     // Standard function transfer similar to ERC20 transfer with no _data .
151     // Added due to backwards compatibility reasons .
152     function transfer(address _to, uint _value) 
153     public 
154     isTradable
155     returns (bool success) {
156         require(_to != 0x0);
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159 
160         Transfer(msg.sender, _to, _value);
161         return true;
162     }
163     
164     /// @dev Function that is called when a user or another contract wants to transfer funds .
165     /// @param _to Recipient address
166     /// @param _value Transfer amount in unit
167     /// @param _data the data pass to contract reveiver
168     function transfer(
169         address _to, 
170         uint _value, 
171         bytes _data) 
172     public
173     isTradable 
174     returns (bool success) {
175         require(_to != 0x0);
176         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
177         balances[_to] = balanceOf(_to).add(_value);
178         Transfer(msg.sender, _to, _value);
179         if(isContract(_to)) {
180             ContractReceiver receiver = ContractReceiver(_to);
181             receiver.tokenFallback(msg.sender, _value, _data);
182             Transfer(msg.sender, _to, _value, _data);
183         }
184         
185         return true;
186     }
187     
188     /// @dev Function that is called when a user or another contract wants to transfer funds .
189     /// @param _to Recipient address
190     /// @param _value Transfer amount in unit
191     /// @param _data the data pass to contract reveiver
192     /// @param _custom_fallback custom name of fallback function
193     function transfer(
194         address _to, 
195         uint _value, 
196         bytes _data, 
197         string _custom_fallback) 
198     public 
199     isTradable
200     returns (bool success) {
201         require(_to != 0x0);
202         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
203         balances[_to] = balanceOf(_to).add(_value);
204         Transfer(msg.sender, _to, _value);
205 
206         if(isContract(_to)) {
207             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
208             Transfer(msg.sender, _to, _value, _data);
209         }
210         return true;
211     }
212          
213     // Send _value amount of tokens from address _from to address _to
214     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
215     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
216     // fees in sub-currencies; the command should fail unless the _from account has
217     // deliberately authorized the sender of the message via some mechanism; we propose
218     // these standardized APIs for approval:
219     function transferFrom(
220         address _from,
221         address _to,
222         uint256 _value)
223     public
224     isTradable
225     returns (bool success) {
226         require(_to != 0x0);
227         balances[_from] = balances[_from].sub(_value);
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229         balances[_to] = balances[_to].add(_value);
230 
231         Transfer(_from, _to, _value);
232         return true;
233     }
234     
235     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
236     // If this function is called again it overwrites the current allowance with _value.
237     function approve(address _spender, uint256 _amount) 
238     public
239     returns (bool success) {
240         allowed[msg.sender][_spender] = _amount;
241         Approval(msg.sender, _spender, _amount);
242         return true;
243     }
244     
245     // get allowance
246     function allowance(address _owner, address _spender) 
247     public
248     constant 
249     returns (uint256 remaining) {
250         return allowed[_owner][_spender];
251     }
252 
253     // withdraw any ERC20 token in this contract to owner
254     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
255         return ERC223(tokenAddress).transfer(owner, tokens);
256     }
257     
258     // allow people can transfer their token
259     // NOTE: can not turn off
260     function turnOnTradable() 
261     public
262     onlyOwner{
263         tradable = true;
264     }
265 
266     // @dev allow owner to update airdrop admin
267     function updateAirdrop(address newAirdropAdmin) 
268     public 
269     onlyOwner{
270         airdrop = newAirdropAdmin;
271     }
272 }
273 
274 contract CGRID is BasicCGRID {
275 
276     bool public _selling = true;//initial selling
277     
278     uint256 public _originalBuyPrice = 36500 * 10 ** decimals; // original buy 1ETH = 36500 CGRID = 36500 * 10**8 unit
279 
280     // List of approved investors
281     mapping(address => bool) private approvedInvestorList;
282     
283     // deposit
284     mapping(address => uint256) private deposit;
285     
286     // icoPercent
287     uint256 public _icoPercent = 30;
288     
289     // _icoSupply is the avalable unit. Initially, it is _totalSupply
290     uint256 public _icoSupply = (_totalSupply * _icoPercent) / 100;
291     
292     // minimum buy 0.3 ETH
293     uint256 public _minimumBuy = 3 * 10 ** 17;
294     
295     // maximum buy 25 ETH
296     uint256 public _maximumBuy = 25 * 10 ** 18;
297 
298     // totalTokenSold
299     uint256 public totalTokenSold = 0;
300 
301     /**
302      * Functions with this modifier check on sale status
303      * Only allow sale if _selling is on
304      */
305     modifier onSale() {
306         require(_selling);
307         _;
308     }
309     
310     /**
311      * Functions with this modifier check the validity of address is investor
312      */
313     modifier validInvestor() {
314         require(approvedInvestorList[msg.sender]);
315         _;
316     }
317     
318     /**
319      * Functions with this modifier check the validity of msg value
320      * value must greater than equal minimumBuyPrice
321      * total deposit must less than equal maximumBuyPrice
322      */
323     modifier validValue(){
324         // require value >= _minimumBuy AND total deposit of msg.sender <= maximumBuyPrice
325         require ( (msg.value >= _minimumBuy) &&
326                 ( (deposit[msg.sender].add(msg.value)) <= _maximumBuy) );
327         _;
328     }
329 
330     /// @dev Fallback function allows to buy by ether.
331     function()
332     public
333     payable {
334         buyCGRID();
335     }
336     
337     /// @dev buy function allows to buy ether. for using optional data
338     function buyCGRID()
339     public
340     payable
341     onSale
342     validValue
343     validInvestor {
344         uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;
345         require(balances[owner] >= requestedUnits);
346         // prepare transfer data
347         balances[owner] = balances[owner].sub(requestedUnits);
348         balances[msg.sender] = balances[msg.sender].add(requestedUnits);
349         
350         // increase total deposit amount
351         deposit[msg.sender] = deposit[msg.sender].add(msg.value);
352         
353         // check total and auto turnOffSale
354         totalTokenSold = totalTokenSold.add(requestedUnits);
355         if (totalTokenSold >= _icoSupply){
356             _selling = false;
357         }
358         
359         // submit transfer
360         Transfer(owner, msg.sender, requestedUnits);
361         owner.transfer(msg.value);
362     }
363 
364     /// @dev Constructor
365     function CGRID() BasicCGRID()
366     public {
367         setBuyPrice(_originalBuyPrice);
368     }
369     
370     /// @dev Disables sale
371     function turnOffSale() onlyOwner 
372     public {
373         _selling = false;
374     }
375     
376     /// @dev set new icoPercent
377     /// @param newIcoPercent new value of icoPercent
378     function setIcoPercent(uint256 newIcoPercent)
379     public 
380     onlyOwner {
381         _icoPercent = newIcoPercent;
382         _icoSupply = (_totalSupply * _icoPercent) / 100;
383     }
384     
385     /// @dev set new _maximumBuy
386     /// @param newMaximumBuy new value of _maximumBuy
387     function setMaximumBuy(uint256 newMaximumBuy)
388     public 
389     onlyOwner {
390         _maximumBuy = newMaximumBuy;
391     }
392 
393     /// @dev Updates buy price (owner ONLY)
394     /// @param newBuyPrice New buy price (in UNIT)
395     function setBuyPrice(uint256 newBuyPrice) 
396     onlyOwner 
397     public {
398         require(newBuyPrice>0);
399         _originalBuyPrice = newBuyPrice; // unit
400         // control _maximumBuy_USD = 10,000 USD, CGRID price is 0.0365USD
401         _maximumBuy = (10**18 * 10**14) /_originalBuyPrice;
402     }
403     
404     /// @dev check address is approved investor
405     /// @param _addr address
406     function isApprovedInvestor(address _addr)
407     public
408     constant
409     returns (bool) {
410         return approvedInvestorList[_addr];
411     }
412     
413     /// @dev get ETH deposit
414     /// @param _addr address get deposit
415     /// @return amount deposit of an buyer
416     function getDeposit(address _addr)
417     public
418     constant
419     returns(uint256){
420         return deposit[_addr];
421 }
422     
423     /// @dev Adds list of new investors to the investors list and approve all
424     /// @param newInvestorList Array of new investors addresses to be added
425     function addInvestorList(address[] newInvestorList)
426     onlyOwner
427     public {
428         for (uint256 i = 0; i < newInvestorList.length; i++){
429             approvedInvestorList[newInvestorList[i]] = true;
430         }
431     }
432 
433     /// @dev Removes list of investors from list
434     /// @param investorList Array of addresses of investors to be removed
435     function removeInvestorList(address[] investorList)
436     onlyOwner
437     public {
438         for (uint256 i = 0; i < investorList.length; i++){
439             approvedInvestorList[investorList[i]] = false;
440         }
441     }
442     
443     /// @dev Withdraws Ether in contract (Owner only)
444     /// @return Status of withdrawal
445     function withdraw() onlyOwner 
446     public 
447     returns (bool) {
448         return owner.send(this.balance);
449     }
450 }
451 
452 contract MultiSigWallet {
453 
454     uint constant public MAX_OWNER_COUNT = 50;
455 
456     event Confirmation(address indexed sender, uint indexed transactionId);
457     event Revocation(address indexed sender, uint indexed transactionId);
458     event Submission(uint indexed transactionId);
459     event Execution(uint indexed transactionId);
460     event ExecutionFailure(uint indexed transactionId);
461     event Deposit(address indexed sender, uint value);
462     event OwnerAddition(address indexed owner);
463     event OwnerRemoval(address indexed owner);
464     event RequirementChange(uint required);
465     event CoinCreation(address coin);
466 
467     mapping (uint => Transaction) public transactions;
468     mapping (uint => mapping (address => bool)) public confirmations;
469     mapping (address => bool) public isOwner;
470     address[] public owners;
471     uint public required;
472     uint public transactionCount;
473     bool flag = true;
474 
475     struct Transaction {
476         address destination;
477         uint value;
478         bytes data;
479         bool executed;
480     }
481 
482     modifier onlyWallet() {
483         if (msg.sender != address(this))
484             revert();
485         _;
486     }
487 
488     modifier ownerDoesNotExist(address owner) {
489         if (isOwner[owner])
490             revert();
491         _;
492     }
493 
494     modifier ownerExists(address owner) {
495         if (!isOwner[owner])
496             revert();
497         _;
498     }
499 
500     modifier transactionExists(uint transactionId) {
501         if (transactions[transactionId].destination == 0)
502             revert();
503         _;
504     }
505 
506     modifier confirmed(uint transactionId, address owner) {
507         if (!confirmations[transactionId][owner])
508             revert();
509         _;
510     }
511 
512     modifier notConfirmed(uint transactionId, address owner) {
513         if (confirmations[transactionId][owner])
514             revert();
515         _;
516     }
517 
518     modifier notExecuted(uint transactionId) {
519         if (transactions[transactionId].executed)
520             revert();
521         _;
522     }
523 
524     modifier notNull(address _address) {
525         if (_address == 0)
526             revert();
527         _;
528     }
529 
530     modifier validRequirement(uint ownerCount, uint _required) {
531         if (   ownerCount > MAX_OWNER_COUNT
532             || _required > ownerCount
533             || _required == 0
534             || ownerCount == 0)
535             revert();
536         _;
537     }
538 
539     /// @dev Fallback function allows to deposit ether.
540     function()
541         payable
542     {
543         if (msg.value > 0)
544             Deposit(msg.sender, msg.value);
545     }
546 
547     /*
548      * Public functions
549      */
550     /// @dev Contract constructor sets initial owners and required number of confirmations.
551     /// @param _owners List of initial owners.
552     /// @param _required Number of required confirmations.
553     function MultiSigWallet(address[] _owners, uint _required)
554         public
555         validRequirement(_owners.length, _required)
556     {
557         for (uint i=0; i<_owners.length; i++) {
558             if (isOwner[_owners[i]] || _owners[i] == 0)
559                 revert();
560             isOwner[_owners[i]] = true;
561         }
562         owners = _owners;
563         required = _required;
564     }
565 
566     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
567     /// @param owner Address of new owner.
568     function addOwner(address owner)
569         public
570         onlyWallet
571         ownerDoesNotExist(owner)
572         notNull(owner)
573         validRequirement(owners.length + 1, required)
574     {
575         isOwner[owner] = true;
576         owners.push(owner);
577         OwnerAddition(owner);
578     }
579 
580     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
581     /// @param owner Address of owner.
582     function removeOwner(address owner)
583         public
584         onlyWallet
585         ownerExists(owner)
586     {
587         isOwner[owner] = false;
588         for (uint i=0; i<owners.length - 1; i++)
589             if (owners[i] == owner) {
590                 owners[i] = owners[owners.length - 1];
591                 break;
592             }
593         owners.length -= 1;
594         if (required > owners.length)
595             changeRequirement(owners.length);
596         OwnerRemoval(owner);
597     }
598 
599     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
600     /// @param owner Address of owner to be replaced.
601     /// @param owner Address of new owner.
602     function replaceOwner(address owner, address newOwner)
603         public
604         onlyWallet
605         ownerExists(owner)
606         ownerDoesNotExist(newOwner)
607     {
608         for (uint i=0; i<owners.length; i++)
609             if (owners[i] == owner) {
610                 owners[i] = newOwner;
611                 break;
612             }
613         isOwner[owner] = false;
614         isOwner[newOwner] = true;
615         OwnerRemoval(owner);
616         OwnerAddition(newOwner);
617     }
618 
619     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
620     /// @param _required Number of required confirmations.
621     function changeRequirement(uint _required)
622         public
623         onlyWallet
624         validRequirement(owners.length, _required)
625     {
626         required = _required;
627         RequirementChange(_required);
628     }
629 
630     /// @dev Allows an owner to submit and confirm a transaction.
631     /// @param destination Transaction target address.
632     /// @param value Transaction ether value.
633     /// @param data Transaction data payload.
634     /// @return Returns transaction ID.
635     function submitTransaction(address destination, uint value, bytes data)
636         public
637         returns (uint transactionId)
638     {
639         transactionId = addTransaction(destination, value, data);
640         confirmTransaction(transactionId);
641     }
642 
643     /// @dev Allows an owner to confirm a transaction.
644     /// @param transactionId Transaction ID.
645     function confirmTransaction(uint transactionId)
646         public
647         ownerExists(msg.sender)
648         transactionExists(transactionId)
649         notConfirmed(transactionId, msg.sender)
650     {
651         confirmations[transactionId][msg.sender] = true;
652         Confirmation(msg.sender, transactionId);
653         executeTransaction(transactionId);
654     }
655 
656     /// @dev Allows an owner to revoke a confirmation for a transaction.
657     /// @param transactionId Transaction ID.
658     function revokeConfirmation(uint transactionId)
659         public
660         ownerExists(msg.sender)
661         confirmed(transactionId, msg.sender)
662         notExecuted(transactionId)
663     {
664         confirmations[transactionId][msg.sender] = false;
665         Revocation(msg.sender, transactionId);
666     }
667 
668     /// @dev Allows anyone to execute a confirmed transaction.
669     /// @param transactionId Transaction ID.
670     function executeTransaction(uint transactionId)
671         public
672         notExecuted(transactionId)
673     {
674         if (isConfirmed(transactionId)) {
675             Transaction tx = transactions[transactionId];
676             tx.executed = true;
677             if (tx.destination.call.value(tx.value)(tx.data))
678                 Execution(transactionId);
679             else {
680                 ExecutionFailure(transactionId);
681                 tx.executed = false;
682             }
683         }
684     }
685 
686     /// @dev Returns the confirmation status of a transaction.
687     /// @param transactionId Transaction ID.
688     /// @return Confirmation status.
689     function isConfirmed(uint transactionId)
690         public
691         constant
692         returns (bool)
693     {
694         uint count = 0;
695         for (uint i=0; i<owners.length; i++) {
696             if (confirmations[transactionId][owners[i]])
697                 count += 1;
698             if (count == required)
699                 return true;
700         }
701     }
702 
703     /*
704      * Internal functions
705      */
706     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
707     /// @param destination Transaction target address.
708     /// @param value Transaction ether value.
709     /// @param data Transaction data payload.
710     /// @return Returns transaction ID.
711     function addTransaction(address destination, uint value, bytes data)
712         internal
713         notNull(destination)
714         returns (uint transactionId)
715     {
716         transactionId = transactionCount;
717         transactions[transactionId] = Transaction({
718             destination: destination,
719             value: value,
720             data: data,
721             executed: false
722         });
723         transactionCount += 1;
724         Submission(transactionId);
725     }
726 
727     /*
728      * Web3 call functions
729      */
730     /// @dev Returns number of confirmations of a transaction.
731     /// @param transactionId Transaction ID.
732     /// @return Number of confirmations.
733     function getConfirmationCount(uint transactionId)
734         public
735         constant
736         returns (uint count)
737     {
738         for (uint i=0; i<owners.length; i++)
739             if (confirmations[transactionId][owners[i]])
740                 count += 1;
741     }
742 
743     /// @dev Returns total number of transactions after filers are applied.
744     /// @param pending Include pending transactions.
745     /// @param executed Include executed transactions.
746     /// @return Total number of transactions after filters are applied.
747     function getTransactionCount(bool pending, bool executed)
748         public
749         constant
750         returns (uint count)
751     {
752         for (uint i=0; i<transactionCount; i++)
753             if (   pending && !transactions[i].executed
754                 || executed && transactions[i].executed)
755                 count += 1;
756     }
757 
758     /// @dev Returns list of owners.
759     /// @return List of owner addresses.
760     function getOwners()
761         public
762         constant
763         returns (address[])
764     {
765         return owners;
766     }
767 
768     /// @dev Returns array with owner addresses, which confirmed transaction.
769     /// @param transactionId Transaction ID.
770     /// @return Returns array of owner addresses.
771     function getConfirmations(uint transactionId)
772         public
773         constant
774         returns (address[] _confirmations)
775     {
776         address[] memory confirmationsTemp = new address[](owners.length);
777         uint count = 0;
778         uint i;
779         for (i=0; i<owners.length; i++)
780             if (confirmations[transactionId][owners[i]]) {
781                 confirmationsTemp[count] = owners[i];
782                 count += 1;
783             }
784         _confirmations = new address[](count);
785         for (i=0; i<count; i++)
786             _confirmations[i] = confirmationsTemp[i];
787     }
788 
789     /// @dev Returns list of transaction IDs in defined range.
790     /// @param from Index start position of transaction array.
791     /// @param to Index end position of transaction array.
792     /// @param pending Include pending transactions.
793     /// @param executed Include executed transactions.
794     /// @return Returns array of transaction IDs.
795     function getTransactionIds(uint from, uint to, bool pending, bool executed)
796         public
797         constant
798         returns (uint[] _transactionIds)
799     {
800         uint[] memory transactionIdsTemp = new uint[](transactionCount);
801         uint count = 0;
802         uint i;
803         for (i=0; i<transactionCount; i++)
804             if (   pending && !transactions[i].executed
805                 || executed && transactions[i].executed)
806             {
807                 transactionIdsTemp[count] = i;
808                 count += 1;
809             }
810         _transactionIds = new uint[](to - from);
811         for (i=from; i<to; i++)
812             _transactionIds[i - from] = transactionIdsTemp[i];
813     }
814     
815     /// @dev Create new coin.
816     function createCoin()
817         external
818         onlyWallet
819     {
820         require(flag == true);
821         CoinCreation(new CGRID());
822         flag = false;
823     }
824 }