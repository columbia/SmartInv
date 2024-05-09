1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 contract DetailedERC20 is ERC20 {
212   string public name;
213   string public symbol;
214   uint8 public decimals;
215 
216   constructor (string _name, string _symbol, uint8 _decimals) public {
217     name = _name;
218     symbol = _symbol;
219     decimals = _decimals;
220   }
221 }
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   constructor() public {
240     owner = msg.sender;
241   }
242 
243   /**
244    * @dev Throws if called by any account other than the owner.
245    */
246   modifier onlyOwner() {
247     require(msg.sender == owner);
248     _;
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address newOwner) public onlyOwner {
256     require(newOwner != address(0));
257     emit OwnershipTransferred(owner, newOwner);
258     owner = newOwner;
259   }
260 
261 }
262 
263 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
264 /// @author Stefan George - <stefan.george@consensys.net>
265 contract MultiSigWallet {
266 
267     /*
268      *  Events
269      */
270     event Confirmation(address indexed sender, uint indexed transactionId);
271     event Revocation(address indexed sender, uint indexed transactionId);
272     event Submission(uint indexed transactionId);
273     event Execution(uint indexed transactionId);
274     event ExecutionFailure(uint indexed transactionId);
275     event Deposit(address indexed sender, uint value);
276     event OwnerAddition(address indexed owner);
277     event OwnerRemoval(address indexed owner);
278     event RequirementChange(uint required);
279 
280     /*
281      *  Constants
282      */
283     uint constant public MAX_OWNER_COUNT = 50;
284 
285     /*
286      *  Storage
287      */
288     mapping (uint => Transaction) public transactions;
289     mapping (uint => mapping (address => bool)) public confirmations;
290     mapping (address => bool) public isOwner;
291     address[] public owners;
292     uint public required;
293     uint public transactionCount;
294 
295     struct Transaction {
296         address destination;
297         uint value;
298         bytes data;
299         bool executed;
300     }
301 
302     /*
303      *  Modifiers
304      */
305     modifier onlyWallet() {
306         require(msg.sender == address(this));
307         _;
308     }
309 
310     modifier ownerDoesNotExist(address owner) {
311         require(!isOwner[owner]);
312         _;
313     }
314 
315     modifier ownerExists(address owner) {
316         require(isOwner[owner]);
317         _;
318     }
319 
320     modifier transactionExists(uint transactionId) {
321         require(transactions[transactionId].destination != 0);
322         _;
323     }
324 
325     modifier confirmed(uint transactionId, address owner) {
326         require(confirmations[transactionId][owner]);
327         _;
328     }
329 
330     modifier notConfirmed(uint transactionId, address owner) {
331         require(!confirmations[transactionId][owner]);
332         _;
333     }
334 
335     modifier notExecuted(uint transactionId) {
336         require(!transactions[transactionId].executed);
337         _;
338     }
339 
340     modifier notNull(address _address) {
341         require(_address != 0);
342         _;
343     }
344 
345     modifier validRequirement(uint ownerCount, uint _required) {
346         require(ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0);
347         _;
348     }
349 
350     /// @dev Fallback function allows to deposit ether.
351     function() public payable
352     {
353         if (msg.value > 0) emit Deposit(msg.sender, msg.value);
354     }
355 
356     /*
357      * Public functions
358      */
359     constructor () public
360     {
361         isOwner[msg.sender] = true;
362         owners.push(msg.sender);
363         emit OwnerAddition(msg.sender);
364         required = 1;
365     }
366 
367     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
368     /// @param owner Address of new owner.
369     function addOwner(address owner)
370         public
371         onlyWallet
372         ownerDoesNotExist(owner)
373         notNull(owner)
374         validRequirement(owners.length + 1, required)
375     {
376         isOwner[owner] = true;
377         owners.push(owner);
378         emit OwnerAddition(owner);
379     }
380 
381     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
382     /// @param owner Address of owner.
383     function removeOwner(address owner)
384         public
385         onlyWallet
386         ownerExists(owner)
387     {
388         isOwner[owner] = false;
389         for (uint i=0; i<owners.length - 1; i++)
390             if (owners[i] == owner) {
391                 owners[i] = owners[owners.length - 1];
392                 break;
393             }
394         owners.length -= 1;
395         if (required > owners.length)
396             changeRequirement(owners.length);
397         emit OwnerRemoval(owner);
398     }
399 
400     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
401     /// @param owner Address of owner to be replaced.
402     /// @param newOwner Address of new owner.
403     function replaceOwner(address owner, address newOwner)
404         public
405         onlyWallet
406         ownerExists(owner)
407         ownerDoesNotExist(newOwner)
408     {
409         for (uint i=0; i<owners.length; i++)
410             if (owners[i] == owner) {
411                 owners[i] = newOwner;
412                 break;
413             }
414         isOwner[owner] = false;
415         isOwner[newOwner] = true;
416         emit OwnerRemoval(owner);
417         emit OwnerAddition(newOwner);
418     }
419 
420     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
421     /// @param _required Number of required confirmations.
422     function changeRequirement(uint _required)
423         public
424         onlyWallet
425         validRequirement(owners.length, _required)
426     {
427         required = _required;
428         emit RequirementChange(_required);
429     }
430 
431     /// @dev Allows an owner to submit and confirm a transaction.
432     /// @param destination Transaction target address.
433     /// @param value Transaction ether value.
434     /// @param data Transaction data payload.
435     /// @return Returns transaction ID.
436     function submitTransaction(address destination, uint value, bytes data)
437         public
438         returns (uint transactionId)
439     {
440         transactionId = addTransaction(destination, value, data);
441         confirmTransaction(transactionId);
442     }
443 
444     /// @dev Allows an owner to confirm a transaction.
445     /// @param transactionId Transaction ID.
446     function confirmTransaction(uint transactionId)
447         public
448         ownerExists(msg.sender)
449         transactionExists(transactionId)
450         notConfirmed(transactionId, msg.sender)
451     {
452         confirmations[transactionId][msg.sender] = true;
453         emit Confirmation(msg.sender, transactionId);
454         executeTransaction(transactionId);
455     }
456 
457     /// @dev Allows an owner to revoke a confirmation for a transaction.
458     /// @param transactionId Transaction ID.
459     function revokeConfirmation(uint transactionId)
460         public
461         ownerExists(msg.sender)
462         confirmed(transactionId, msg.sender)
463         notExecuted(transactionId)
464     {
465         confirmations[transactionId][msg.sender] = false;
466         emit Revocation(msg.sender, transactionId);
467     }
468 
469     /// @dev Allows anyone to execute a confirmed transaction.
470     /// @param transactionId Transaction ID.
471     function executeTransaction(uint transactionId)
472         public
473         ownerExists(msg.sender)
474         confirmed(transactionId, msg.sender)
475         notExecuted(transactionId)
476     {
477         if (isConfirmed(transactionId)) {
478             Transaction storage txn = transactions[transactionId];
479             txn.executed = true;
480             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
481                 emit Execution(transactionId);
482             else {
483                 emit ExecutionFailure(transactionId);
484                 txn.executed = false;
485             }
486         }
487     }
488 
489     // call has been separated into its own function in order to take advantage
490     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
491     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
492         bool result;
493         assembly {
494             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
495             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
496             result := call(
497                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
498                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
499                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
500                 destination,
501                 value,
502                 d,
503                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
504                 x,
505                 0                  // Output is ignored, therefore the output size is zero
506             )
507         }
508         return result;
509     }
510 
511     /// @dev Returns the confirmation status of a transaction.
512     /// @param transactionId Transaction ID.
513     /// @return Confirmation status.
514     function isConfirmed(uint transactionId)
515         public
516         constant
517         returns (bool)
518     {
519         uint count = 0;
520         for (uint i=0; i<owners.length; i++) {
521             if (confirmations[transactionId][owners[i]])
522                 count += 1;
523             if (count == required)
524                 return true;
525         }
526     }
527 
528     /*
529      * Internal functions
530      */
531     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
532     /// @param destination Transaction target address.
533     /// @param value Transaction ether value.
534     /// @param data Transaction data payload.
535     /// @return Returns transaction ID.
536     function addTransaction(address destination, uint value, bytes data)
537         internal
538         notNull(destination)
539         returns (uint transactionId)
540     {
541         transactionId = transactionCount;
542         transactions[transactionId] = Transaction({
543             destination: destination,
544             value: value,
545             data: data,
546             executed: false
547         });
548         transactionCount += 1;
549         emit Submission(transactionId);
550     }
551 
552     /*
553      * Web3 call functions
554      */
555     /// @dev Returns number of confirmations of a transaction.
556     /// @param transactionId Transaction ID.
557     /// @return Number of confirmations.
558     function getConfirmationCount(uint transactionId)
559         public
560         constant
561         returns (uint count)
562     {
563         for (uint i=0; i<owners.length; i++) {
564             if (confirmations[transactionId][owners[i]]) count += 1;
565         }
566     }
567 
568     /// @dev Returns total number of transactions after filers are applied.
569     /// @param pending Include pending transactions.
570     /// @param executed Include executed transactions.
571     /// @return Total number of transactions after filters are applied.
572     function getTransactionCount(bool pending, bool executed)
573         public
574         constant
575         returns (uint count)
576     {
577       for ( uint i=0; i<transactionCount; i++ ) {
578         if ( pending && !transactions[i].executed || executed && transactions[i].executed )
579            count += 1;
580       }
581     }
582 
583     /// @dev Returns list of owners.
584     /// @return List of owner addresses.
585     function getOwners()
586         public
587         constant
588         returns (address[])
589     {
590         return owners;
591     }
592 
593     /// @dev Returns array with owner addresses, which confirmed transaction.
594     /// @param transactionId Transaction ID.
595     /// @return Returns array of owner addresses.
596     function getConfirmations(uint transactionId)
597         public
598         constant
599         returns (address[] _confirmations)
600     {
601         address[] memory confirmationsTemp = new address[](owners.length);
602         uint count = 0;
603         uint i;
604         for (i=0; i<owners.length; i++)
605             if (confirmations[transactionId][owners[i]]) {
606                 confirmationsTemp[count] = owners[i];
607                 count += 1;
608             }
609         _confirmations = new address[](count);
610         for (i=0; i<count; i++)
611             _confirmations[i] = confirmationsTemp[i];
612     }
613 
614     /// @dev Returns list of transaction IDs in defined range.
615     /// @param from Index start position of transaction array.
616     /// @param to Index end position of transaction array.
617     /// @param pending Include pending transactions.
618     /// @param executed Include executed transactions.
619     /// @return Returns array of transaction IDs.
620     function getTransactionIds(uint from, uint to, bool pending, bool executed)
621         public
622         constant
623         returns (uint[] _transactionIds)
624     {
625         uint[] memory transactionIdsTemp = new uint[](transactionCount);
626         uint count = 0;
627         uint i;
628         for (i=0; i<transactionCount; i++)
629             if (   pending && !transactions[i].executed
630                 || executed && transactions[i].executed)
631             {
632                 transactionIdsTemp[count] = i;
633                 count += 1;
634             }
635         _transactionIds = new uint[](to - from);
636         for (i=from; i<to; i++)
637             _transactionIds[i - from] = transactionIdsTemp[i];
638     }
639 }
640 
641 contract NomadPreICO is
642     StandardToken, 
643     Ownable, 
644     DetailedERC20("preNSP", "NOMAD SPACE NETWORK preICO TOKEN", 18)
645     , MultiSigWallet
646 {
647     using SafeMath for uint256;
648 
649     //TODO проверить, что не смогу записывать в данные переменные
650     uint256 public StartDate     = 1527811200;       // 01 June 2018 00:00:00 UTC
651     uint256 public EndDate       = 1538351999;       // 30 September 2018 г., 23:59:59
652     uint256 public ExchangeRate  = 762000000000000000000; // 762*10*10^18
653     uint256 public hardCap       = 5000000*ExchangeRate; // $5M
654     uint256 public softCap       = 1000000*ExchangeRate; // $1M
655 
656     //TODO Check test comment
657     //uint256 public onlyTestTimestamp = 0;
658     //function onlyTestSetTimestamp(uint256 newTimestamp) public {
659       //  onlyTestTimestamp = newTimestamp;
660     //}
661 
662     //TODO Check test comment
663     function getTimestamp() public view returns (uint256) {
664         return block.timestamp;
665     //    if (onlyTestTimestamp!=0) {return onlyTestTimestamp; } else {return block.timestamp;}
666     }
667 
668     function setExchangeRate(uint256 newExchangeRate) 
669         onlyOwner 
670         public
671     {
672         require(getTimestamp() < StartDate);
673         ExchangeRate = newExchangeRate;
674         hardCap      = 5000000*ExchangeRate;
675         softCap      = 1000000*ExchangeRate;
676     }
677 
678     address[] senders;
679     mapping(address => uint256) sendersCalcTokens;
680     mapping(address => uint256) sendersEth;
681 
682     function getSenders          (               ) public view returns (address[]) {return senders                   ;}
683     function getSendersCalcTokens(address _sender) public view returns (uint256 )  {return sendersCalcTokens[_sender];}
684     function getSendersEth       (address _sender) public view returns (uint256)   {return sendersEth       [_sender];}
685 
686     function () payable public {
687         require(msg.value > 0); 
688         require(getTimestamp() >= StartDate);
689         require(getTimestamp() <= EndDate);
690         require(Eth2USD(address(this).balance) <= hardCap);
691         
692         sendersEth[msg.sender] = sendersEth[msg.sender].add(msg.value);
693         sendersCalcTokens[msg.sender] = sendersCalcTokens[msg.sender].add( Eth2preNSP(msg.value) );
694 
695         for (uint i=0; i<senders.length; i++) 
696             if (senders[i] == msg.sender) return;
697         senders.push(msg.sender);        
698     }
699 
700     bool public mvpExists = false;
701     bool public softCapOk = false;
702 
703     function setMvpExists(bool _mvpExists) 
704         public 
705         onlyWallet 
706     { mvpExists = _mvpExists; }
707     
708     function checkSoftCapOk() public { 
709         require(!softCapOk);
710         if( softCap <= Eth2USD(address(this).balance) ) softCapOk = true;
711     }
712 
713     address withdrawalAddress;
714     function setWithdrawalAddress (address _withdrawalAddress) public onlyWallet { 
715         withdrawalAddress = _withdrawalAddress;
716     }
717     
718     function release() public onlyWallet {
719         releaseETH();
720         releaseTokens();
721     }
722 
723     function releaseETH() public onlyWallet {
724         if(address(this).balance > 0 && softCapOk && mvpExists)
725             address(withdrawalAddress).transfer(address(this).balance);
726     }
727 
728     function releaseTokens() public onlyWallet {
729         if(softCapOk && mvpExists)
730             for (uint i=0; i<senders.length; i++)
731                 releaseTokens4Sender(i);
732     }
733 
734     function releaseTokens4Sender(uint senderNum) public onlyWallet {
735         address sender = senders[senderNum];
736         uint256 tokens = sendersCalcTokens[sender];
737         if (tokens>0) {
738             sendersCalcTokens[sender] = 0;
739             mint(sender, tokens);
740         }
741     }
742 
743     function mint(address _to, uint256 _amount) internal {
744         totalSupply_ = totalSupply_.add(_amount);
745         balances[_to] = balances[_to].add(_amount);
746         emit Transfer(address(0), _to, _amount);
747     }
748 
749     function returnEth() public onlyWallet {
750         require(getTimestamp() > EndDate);
751         require(!softCapOk || !mvpExists);
752         
753         for (uint i=0; i<senders.length; i++)
754             returnEth4Sender(i);
755     }
756 
757     function returnEth4Sender(uint senderNum) public onlyWallet {
758         require(getTimestamp() > EndDate);
759         require(!softCapOk || !mvpExists);
760         
761         address sender = senders[senderNum];
762         sendersEth[sender] = 0;
763         address(sender).transfer(sendersEth[sender]);
764     }
765 
766     function GetTokenPriceCents() public view returns (uint256) {
767         require(getTimestamp() >= StartDate);
768         require(getTimestamp() <= EndDate);
769         if( (getTimestamp() >= 1527811200)&&(getTimestamp() < 1530403200) ) return 4; // June 
770         else                   
771         if( (getTimestamp() >= 1530403200)&&(getTimestamp() < 1533081600) ) return 5; // July
772         else
773         if( (getTimestamp() >= 1533081600)&&(getTimestamp() < 1535760000) ) return 6; // August 
774         else
775         if( (getTimestamp() >= 1535760000)&&(getTimestamp() < 1538352000) ) return 8; // September
776         else revert();
777     }
778 
779     function Eth2USD(uint256 _wei) public view returns (uint256) {
780         return _wei*ExchangeRate;
781     }
782 
783     function Eth2preNSP(uint256 _wei) public view returns (uint256) {
784         return Eth2USD(_wei)*100/GetTokenPriceCents();
785     }
786 }