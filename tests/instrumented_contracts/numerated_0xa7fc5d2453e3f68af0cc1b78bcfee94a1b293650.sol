1 pragma solidity ^0.4.20;
2 // ----------------------------------------------------------------------------------------------
3 // SPIKE Token by SPIKING Limited.
4 // An ERC223 standard
5 //
6 // author: SPIKE Team
7 // Contact: clemen@spiking.io
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
70 contract BasicSPIKE is ERC223 {
71     using SafeMath for uint256;
72     
73     uint256 public constant decimals = 10;
74     string public constant symbol = "SPIKE";
75     string public constant name = "Spiking";
76     uint256 public _totalSupply = 5 * 10 ** 19; // total supply is 5*10^19 unit, equivalent to 5 Billion SPIKE
77 
78     // Owner of this contract
79     address public owner;
80     address public airdrop;
81 
82     // tradable
83     bool public tradable = false;
84 
85     // Balances SPIKE for each account
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
105     function BasicSPIKE() 
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
274 contract SPIKE is BasicSPIKE {
275 
276     bool public _selling = true;//initial selling
277     
278     uint256 public _originalBuyPrice = 80000 * 10**10; // original buy 1ETH = 80000 SPIKE = 80000 * 10**10 unit
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
334         buySPIKE();
335     }
336     
337     /// @dev buy function allows to buy ether. for using optional data
338     function buySPIKE()
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
365     function SPIKE() BasicSPIKE()
366     public {
367         setBuyPrice(_originalBuyPrice);
368     }
369     
370     /// @dev Enables sale 
371     function turnOnSale() onlyOwner 
372     public {
373         _selling = true;
374     }
375 
376     /// @dev Disables sale
377     function turnOffSale() onlyOwner 
378     public {
379         _selling = false;
380     }
381     
382     /// @dev set new icoPercent
383     /// @param newIcoPercent new value of icoPercent
384     function setIcoPercent(uint256 newIcoPercent)
385     public 
386     onlyOwner {
387         _icoPercent = newIcoPercent;
388         _icoSupply = (_totalSupply * _icoPercent) / 100;
389     }
390     
391     /// @dev set new _maximumBuy
392     /// @param newMaximumBuy new value of _maximumBuy
393     function setMaximumBuy(uint256 newMaximumBuy)
394     public 
395     onlyOwner {
396         _maximumBuy = newMaximumBuy;
397     }
398 
399     /// @dev Updates buy price (owner ONLY)
400     /// @param newBuyPrice New buy price (in UNIT) 1ETH <=> 80,000 SPKIE = 100,000.0000000000 unit
401     function setBuyPrice(uint256 newBuyPrice) 
402     onlyOwner 
403     public {
404         require(newBuyPrice>0);
405         _originalBuyPrice = newBuyPrice; // unit
406         // control _maximumBuy_USD = 10,000 USD, SPIKE price is 0.01USD
407         // maximumBuy_SPIKE = 1000,000 SPIKE = 1000,000,0000000000 unit = 10^16
408         _maximumBuy = (10**18 * 10**16) /_originalBuyPrice;
409     }
410     
411     /// @dev check address is approved investor
412     /// @param _addr address
413     function isApprovedInvestor(address _addr)
414     public
415     constant
416     returns (bool) {
417         return approvedInvestorList[_addr];
418     }
419     
420     /// @dev get ETH deposit
421     /// @param _addr address get deposit
422     /// @return amount deposit of an buyer
423     function getDeposit(address _addr)
424     public
425     constant
426     returns(uint256){
427         return deposit[_addr];
428 }
429     
430     /// @dev Adds list of new investors to the investors list and approve all
431     /// @param newInvestorList Array of new investors addresses to be added
432     function addInvestorList(address[] newInvestorList)
433     onlyOwner
434     public {
435         for (uint256 i = 0; i < newInvestorList.length; i++){
436             approvedInvestorList[newInvestorList[i]] = true;
437         }
438     }
439 
440     /// @dev Removes list of investors from list
441     /// @param investorList Array of addresses of investors to be removed
442     function removeInvestorList(address[] investorList)
443     onlyOwner
444     public {
445         for (uint256 i = 0; i < investorList.length; i++){
446             approvedInvestorList[investorList[i]] = false;
447         }
448     }
449     
450     /// @dev Withdraws Ether in contract (Owner only)
451     /// @return Status of withdrawal
452     function withdraw() onlyOwner 
453     public 
454     returns (bool) {
455         return owner.send(this.balance);
456     }
457 }
458 
459 contract MultiSigWallet {
460 
461     uint constant public MAX_OWNER_COUNT = 50;
462 
463     event Confirmation(address indexed sender, uint indexed transactionId);
464     event Revocation(address indexed sender, uint indexed transactionId);
465     event Submission(uint indexed transactionId);
466     event Execution(uint indexed transactionId);
467     event ExecutionFailure(uint indexed transactionId);
468     event Deposit(address indexed sender, uint value);
469     event OwnerAddition(address indexed owner);
470     event OwnerRemoval(address indexed owner);
471     event RequirementChange(uint required);
472     event CoinCreation(address coin);
473 
474     mapping (uint => Transaction) public transactions;
475     mapping (uint => mapping (address => bool)) public confirmations;
476     mapping (address => bool) public isOwner;
477     address[] public owners;
478     uint public required;
479     uint public transactionCount;
480     bool flag = true;
481 
482     struct Transaction {
483         address destination;
484         uint value;
485         bytes data;
486         bool executed;
487     }
488 
489     modifier onlyWallet() {
490         if (msg.sender != address(this))
491             revert();
492         _;
493     }
494 
495     modifier ownerDoesNotExist(address owner) {
496         if (isOwner[owner])
497             revert();
498         _;
499     }
500 
501     modifier ownerExists(address owner) {
502         if (!isOwner[owner])
503             revert();
504         _;
505     }
506 
507     modifier transactionExists(uint transactionId) {
508         if (transactions[transactionId].destination == 0)
509             revert();
510         _;
511     }
512 
513     modifier confirmed(uint transactionId, address owner) {
514         if (!confirmations[transactionId][owner])
515             revert();
516         _;
517     }
518 
519     modifier notConfirmed(uint transactionId, address owner) {
520         if (confirmations[transactionId][owner])
521             revert();
522         _;
523     }
524 
525     modifier notExecuted(uint transactionId) {
526         if (transactions[transactionId].executed)
527             revert();
528         _;
529     }
530 
531     modifier notNull(address _address) {
532         if (_address == 0)
533             revert();
534         _;
535     }
536 
537     modifier validRequirement(uint ownerCount, uint _required) {
538         if (   ownerCount > MAX_OWNER_COUNT
539             || _required > ownerCount
540             || _required == 0
541             || ownerCount == 0)
542             revert();
543         _;
544     }
545 
546     /// @dev Fallback function allows to deposit ether.
547     function()
548         payable
549     {
550         if (msg.value > 0)
551             Deposit(msg.sender, msg.value);
552     }
553 
554     /*
555      * Public functions
556      */
557     /// @dev Contract constructor sets initial owners and required number of confirmations.
558     /// @param _owners List of initial owners.
559     /// @param _required Number of required confirmations.
560     function MultiSigWallet(address[] _owners, uint _required)
561         public
562         validRequirement(_owners.length, _required)
563     {
564         for (uint i=0; i<_owners.length; i++) {
565             if (isOwner[_owners[i]] || _owners[i] == 0)
566                 revert();
567             isOwner[_owners[i]] = true;
568         }
569         owners = _owners;
570         required = _required;
571     }
572 
573     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
574     /// @param owner Address of new owner.
575     function addOwner(address owner)
576         public
577         onlyWallet
578         ownerDoesNotExist(owner)
579         notNull(owner)
580         validRequirement(owners.length + 1, required)
581     {
582         isOwner[owner] = true;
583         owners.push(owner);
584         OwnerAddition(owner);
585     }
586 
587     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
588     /// @param owner Address of owner.
589     function removeOwner(address owner)
590         public
591         onlyWallet
592         ownerExists(owner)
593     {
594         isOwner[owner] = false;
595         for (uint i=0; i<owners.length - 1; i++)
596             if (owners[i] == owner) {
597                 owners[i] = owners[owners.length - 1];
598                 break;
599             }
600         owners.length -= 1;
601         if (required > owners.length)
602             changeRequirement(owners.length);
603         OwnerRemoval(owner);
604     }
605 
606     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
607     /// @param owner Address of owner to be replaced.
608     /// @param owner Address of new owner.
609     function replaceOwner(address owner, address newOwner)
610         public
611         onlyWallet
612         ownerExists(owner)
613         ownerDoesNotExist(newOwner)
614     {
615         for (uint i=0; i<owners.length; i++)
616             if (owners[i] == owner) {
617                 owners[i] = newOwner;
618                 break;
619             }
620         isOwner[owner] = false;
621         isOwner[newOwner] = true;
622         OwnerRemoval(owner);
623         OwnerAddition(newOwner);
624     }
625 
626     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
627     /// @param _required Number of required confirmations.
628     function changeRequirement(uint _required)
629         public
630         onlyWallet
631         validRequirement(owners.length, _required)
632     {
633         required = _required;
634         RequirementChange(_required);
635     }
636 
637     /// @dev Allows an owner to submit and confirm a transaction.
638     /// @param destination Transaction target address.
639     /// @param value Transaction ether value.
640     /// @param data Transaction data payload.
641     /// @return Returns transaction ID.
642     function submitTransaction(address destination, uint value, bytes data)
643         public
644         returns (uint transactionId)
645     {
646         transactionId = addTransaction(destination, value, data);
647         confirmTransaction(transactionId);
648     }
649 
650     /// @dev Allows an owner to confirm a transaction.
651     /// @param transactionId Transaction ID.
652     function confirmTransaction(uint transactionId)
653         public
654         ownerExists(msg.sender)
655         transactionExists(transactionId)
656         notConfirmed(transactionId, msg.sender)
657     {
658         confirmations[transactionId][msg.sender] = true;
659         Confirmation(msg.sender, transactionId);
660         executeTransaction(transactionId);
661     }
662 
663     /// @dev Allows an owner to revoke a confirmation for a transaction.
664     /// @param transactionId Transaction ID.
665     function revokeConfirmation(uint transactionId)
666         public
667         ownerExists(msg.sender)
668         confirmed(transactionId, msg.sender)
669         notExecuted(transactionId)
670     {
671         confirmations[transactionId][msg.sender] = false;
672         Revocation(msg.sender, transactionId);
673     }
674 
675     /// @dev Allows anyone to execute a confirmed transaction.
676     /// @param transactionId Transaction ID.
677     function executeTransaction(uint transactionId)
678         public
679         notExecuted(transactionId)
680     {
681         if (isConfirmed(transactionId)) {
682             Transaction tx = transactions[transactionId];
683             tx.executed = true;
684             if (tx.destination.call.value(tx.value)(tx.data))
685                 Execution(transactionId);
686             else {
687                 ExecutionFailure(transactionId);
688                 tx.executed = false;
689             }
690         }
691     }
692 
693     /// @dev Returns the confirmation status of a transaction.
694     /// @param transactionId Transaction ID.
695     /// @return Confirmation status.
696     function isConfirmed(uint transactionId)
697         public
698         constant
699         returns (bool)
700     {
701         uint count = 0;
702         for (uint i=0; i<owners.length; i++) {
703             if (confirmations[transactionId][owners[i]])
704                 count += 1;
705             if (count == required)
706                 return true;
707         }
708     }
709 
710     /*
711      * Internal functions
712      */
713     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
714     /// @param destination Transaction target address.
715     /// @param value Transaction ether value.
716     /// @param data Transaction data payload.
717     /// @return Returns transaction ID.
718     function addTransaction(address destination, uint value, bytes data)
719         internal
720         notNull(destination)
721         returns (uint transactionId)
722     {
723         transactionId = transactionCount;
724         transactions[transactionId] = Transaction({
725             destination: destination,
726             value: value,
727             data: data,
728             executed: false
729         });
730         transactionCount += 1;
731         Submission(transactionId);
732     }
733 
734     /*
735      * Web3 call functions
736      */
737     /// @dev Returns number of confirmations of a transaction.
738     /// @param transactionId Transaction ID.
739     /// @return Number of confirmations.
740     function getConfirmationCount(uint transactionId)
741         public
742         constant
743         returns (uint count)
744     {
745         for (uint i=0; i<owners.length; i++)
746             if (confirmations[transactionId][owners[i]])
747                 count += 1;
748     }
749 
750     /// @dev Returns total number of transactions after filers are applied.
751     /// @param pending Include pending transactions.
752     /// @param executed Include executed transactions.
753     /// @return Total number of transactions after filters are applied.
754     function getTransactionCount(bool pending, bool executed)
755         public
756         constant
757         returns (uint count)
758     {
759         for (uint i=0; i<transactionCount; i++)
760             if (   pending && !transactions[i].executed
761                 || executed && transactions[i].executed)
762                 count += 1;
763     }
764 
765     /// @dev Returns list of owners.
766     /// @return List of owner addresses.
767     function getOwners()
768         public
769         constant
770         returns (address[])
771     {
772         return owners;
773     }
774 
775     /// @dev Returns array with owner addresses, which confirmed transaction.
776     /// @param transactionId Transaction ID.
777     /// @return Returns array of owner addresses.
778     function getConfirmations(uint transactionId)
779         public
780         constant
781         returns (address[] _confirmations)
782     {
783         address[] memory confirmationsTemp = new address[](owners.length);
784         uint count = 0;
785         uint i;
786         for (i=0; i<owners.length; i++)
787             if (confirmations[transactionId][owners[i]]) {
788                 confirmationsTemp[count] = owners[i];
789                 count += 1;
790             }
791         _confirmations = new address[](count);
792         for (i=0; i<count; i++)
793             _confirmations[i] = confirmationsTemp[i];
794     }
795 
796     /// @dev Returns list of transaction IDs in defined range.
797     /// @param from Index start position of transaction array.
798     /// @param to Index end position of transaction array.
799     /// @param pending Include pending transactions.
800     /// @param executed Include executed transactions.
801     /// @return Returns array of transaction IDs.
802     function getTransactionIds(uint from, uint to, bool pending, bool executed)
803         public
804         constant
805         returns (uint[] _transactionIds)
806     {
807         uint[] memory transactionIdsTemp = new uint[](transactionCount);
808         uint count = 0;
809         uint i;
810         for (i=0; i<transactionCount; i++)
811             if (   pending && !transactions[i].executed
812                 || executed && transactions[i].executed)
813             {
814                 transactionIdsTemp[count] = i;
815                 count += 1;
816             }
817         _transactionIds = new uint[](to - from);
818         for (i=from; i<to; i++)
819             _transactionIds[i - from] = transactionIdsTemp[i];
820     }
821     
822     /// @dev Create new coin.
823     function createCoin()
824         external
825         onlyWallet
826     {
827         require(flag == true);
828         CoinCreation(new SPIKE());
829         flag = false;
830     }
831 }