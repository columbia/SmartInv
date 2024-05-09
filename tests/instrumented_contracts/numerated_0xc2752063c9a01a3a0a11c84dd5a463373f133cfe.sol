1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 pragma solidity ^0.4.11;
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control 
40  * functions, this simplifies the implementation of "user permissions". 
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   /** 
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner. 
57    */
58   modifier onlyOwner() {
59     if (msg.sender != owner) {
60       throw;
61     }
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to. 
69    */
70   function transferOwnership(address newOwner) onlyOwner {
71     if (newOwner != address(0)) {
72       owner = newOwner;
73     }
74   }
75 
76 }
77 
78 pragma solidity ^0.4.11;
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) constant returns (uint256);
89   function transfer(address to, uint256 value);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 pragma solidity ^0.4.11;
94 
95 
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value);
105   function approve(address spender, uint256 value);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 pragma solidity ^0.4.11;
110 
111 
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances. 
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) {
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of. 
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) constant returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 pragma solidity ^0.4.11;
146 
147 
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amout of tokens to be transfered
167    */
168   function transferFrom(address _from, address _to, uint256 _value) {
169     var _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // if (_value > _allowance) throw;
173 
174     balances[_to] = balances[_to].add(_value);
175     balances[_from] = balances[_from].sub(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     Transfer(_from, _to, _value);
178   }
179 
180   /**
181    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) {
186 
187     // To change the approve amount you first have to reduce the addresses`
188     //  allowance to zero by calling `approve(_spender, 0)` if it is not
189     //  already 0 to mitigate the race condition described here:
190     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
192 
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifing the amount of tokens still avaible for the spender.
202    */
203   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 pragma solidity ^0.4.11;
210 
211 
212 
213 
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 
222 contract MintableToken is StandardToken, Ownable {
223   event Mint(address indexed to, uint256 amount);
224   event MintFinished();
225 
226   bool public mintingFinished = false;
227 
228 
229   modifier canMint() {
230     if(mintingFinished) throw;
231     _;
232   }
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will recieve the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner returns (bool) {
252     mintingFinished = true;
253     MintFinished();
254     return true;
255   }
256 }
257 
258 pragma solidity ^0.4.11;
259 
260 
261 /*
262     Copyright 2017, Giovanni Zorzato (Boulé Foundation)
263 */
264 
265 contract BouleToken is MintableToken {
266     // BouleToken is an OpenZeppelin Mintable Token
267     string public name = "Boule Token";
268     string public symbol = "BOU";
269     uint public decimals = 18;
270 
271     // do no allow to send ether to this token
272     function () public payable {
273         throw;
274     }
275 
276 }
277 
278 
279 
280 pragma solidity ^0.4.4;
281 
282 
283 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
284 /// @author Stefan George - <stefan.george@consensys.net>
285 contract MultiSigWallet {
286 
287     uint constant public MAX_OWNER_COUNT = 50;
288 
289     event Confirmation(address indexed sender, uint indexed transactionId);
290     event Revocation(address indexed sender, uint indexed transactionId);
291     event Submission(uint indexed transactionId);
292     event Execution(uint indexed transactionId);
293     event ExecutionFailure(uint indexed transactionId);
294     event Deposit(address indexed sender, uint value);
295     event OwnerAddition(address indexed owner);
296     event OwnerRemoval(address indexed owner);
297     event RequirementChange(uint required);
298 
299     mapping (uint => Transaction) public transactions;
300     mapping (uint => mapping (address => bool)) public confirmations;
301     mapping (address => bool) public isOwner;
302     address[] public owners;
303     uint public required;
304     uint public transactionCount;
305 
306     struct Transaction {
307         address destination;
308         uint value;
309         bytes data;
310         bool executed;
311     }
312 
313     modifier onlyWallet() {
314         if (msg.sender != address(this))
315             throw;
316         _;
317     }
318 
319     modifier ownerDoesNotExist(address owner) {
320         if (isOwner[owner])
321             throw;
322         _;
323     }
324 
325     modifier ownerExists(address owner) {
326         if (!isOwner[owner])
327             throw;
328         _;
329     }
330 
331     modifier transactionExists(uint transactionId) {
332         if (transactions[transactionId].destination == 0)
333             throw;
334         _;
335     }
336 
337     modifier confirmed(uint transactionId, address owner) {
338         if (!confirmations[transactionId][owner])
339             throw;
340         _;
341     }
342 
343     modifier notConfirmed(uint transactionId, address owner) {
344         if (confirmations[transactionId][owner])
345             throw;
346         _;
347     }
348 
349     modifier notExecuted(uint transactionId) {
350         if (transactions[transactionId].executed)
351             throw;
352         _;
353     }
354 
355     modifier notNull(address _address) {
356         if (_address == 0)
357             throw;
358         _;
359     }
360 
361     modifier validRequirement(uint ownerCount, uint _required) {
362         if (   ownerCount > MAX_OWNER_COUNT
363             || _required > ownerCount
364             || _required == 0
365             || ownerCount == 0)
366             throw;
367         _;
368     }
369 
370     /// @dev Fallback function allows to deposit ether.
371     function()
372         payable
373     {
374         if (msg.value > 0)
375             Deposit(msg.sender, msg.value);
376     }
377 
378     /*
379      * Public functions
380      */
381     /// @dev Contract constructor sets initial owners and required number of confirmations.
382     /// @param _owners List of initial owners.
383     /// @param _required Number of required confirmations.
384     function MultiSigWallet(address[] _owners, uint _required)
385         public
386         validRequirement(_owners.length, _required)
387     {
388         for (uint i=0; i<_owners.length; i++) {
389             if (isOwner[_owners[i]] || _owners[i] == 0)
390                 throw;
391             isOwner[_owners[i]] = true;
392         }
393         owners = _owners;
394         required = _required;
395     }
396 
397     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
398     /// @param owner Address of new owner.
399     function addOwner(address owner)
400         public
401         onlyWallet
402         ownerDoesNotExist(owner)
403         notNull(owner)
404         validRequirement(owners.length + 1, required)
405     {
406         isOwner[owner] = true;
407         owners.push(owner);
408         OwnerAddition(owner);
409     }
410 
411     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
412     /// @param owner Address of owner.
413     function removeOwner(address owner)
414         public
415         onlyWallet
416         ownerExists(owner)
417     {
418         isOwner[owner] = false;
419         for (uint i=0; i<owners.length - 1; i++)
420             if (owners[i] == owner) {
421                 owners[i] = owners[owners.length - 1];
422                 break;
423             }
424         owners.length -= 1;
425         if (required > owners.length)
426             changeRequirement(owners.length);
427         OwnerRemoval(owner);
428     }
429 
430     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
431     /// @param owner Address of owner to be replaced.
432     /// @param owner Address of new owner.
433     function replaceOwner(address owner, address newOwner)
434         public
435         onlyWallet
436         ownerExists(owner)
437         ownerDoesNotExist(newOwner)
438     {
439         for (uint i=0; i<owners.length; i++)
440             if (owners[i] == owner) {
441                 owners[i] = newOwner;
442                 break;
443             }
444         isOwner[owner] = false;
445         isOwner[newOwner] = true;
446         OwnerRemoval(owner);
447         OwnerAddition(newOwner);
448     }
449 
450     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
451     /// @param _required Number of required confirmations.
452     function changeRequirement(uint _required)
453         public
454         onlyWallet
455         validRequirement(owners.length, _required)
456     {
457         required = _required;
458         RequirementChange(_required);
459     }
460 
461     /// @dev Allows an owner to submit and confirm a transaction.
462     /// @param destination Transaction target address.
463     /// @param value Transaction ether value.
464     /// @param data Transaction data payload.
465     /// @return Returns transaction ID.
466     function submitTransaction(address destination, uint value, bytes data)
467         public
468         returns (uint transactionId)
469     {
470         transactionId = addTransaction(destination, value, data);
471         confirmTransaction(transactionId);
472     }
473 
474     /// @dev Allows an owner to confirm a transaction.
475     /// @param transactionId Transaction ID.
476     function confirmTransaction(uint transactionId)
477         public
478         ownerExists(msg.sender)
479         transactionExists(transactionId)
480         notConfirmed(transactionId, msg.sender)
481     {
482         confirmations[transactionId][msg.sender] = true;
483         Confirmation(msg.sender, transactionId);
484         executeTransaction(transactionId);
485     }
486 
487     /// @dev Allows an owner to revoke a confirmation for a transaction.
488     /// @param transactionId Transaction ID.
489     function revokeConfirmation(uint transactionId)
490         public
491         ownerExists(msg.sender)
492         confirmed(transactionId, msg.sender)
493         notExecuted(transactionId)
494     {
495         confirmations[transactionId][msg.sender] = false;
496         Revocation(msg.sender, transactionId);
497     }
498 
499     /// @dev Allows anyone to execute a confirmed transaction.
500     /// @param transactionId Transaction ID.
501     function executeTransaction(uint transactionId)
502         public
503         notExecuted(transactionId)
504     {
505         if (isConfirmed(transactionId)) {
506             Transaction tx = transactions[transactionId];
507             tx.executed = true;
508             if (tx.destination.call.value(tx.value)(tx.data))
509                 Execution(transactionId);
510             else {
511                 ExecutionFailure(transactionId);
512                 tx.executed = false;
513             }
514         }
515     }
516 
517     /// @dev Returns the confirmation status of a transaction.
518     /// @param transactionId Transaction ID.
519     /// @return Confirmation status.
520     function isConfirmed(uint transactionId)
521         public
522         constant
523         returns (bool)
524     {
525         uint count = 0;
526         for (uint i=0; i<owners.length; i++) {
527             if (confirmations[transactionId][owners[i]])
528                 count += 1;
529             if (count == required)
530                 return true;
531         }
532     }
533 
534     /*
535      * Internal functions
536      */
537     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
538     /// @param destination Transaction target address.
539     /// @param value Transaction ether value.
540     /// @param data Transaction data payload.
541     /// @return Returns transaction ID.
542     function addTransaction(address destination, uint value, bytes data)
543         internal
544         notNull(destination)
545         returns (uint transactionId)
546     {
547         transactionId = transactionCount;
548         transactions[transactionId] = Transaction({
549             destination: destination,
550             value: value,
551             data: data,
552             executed: false
553         });
554         transactionCount += 1;
555         Submission(transactionId);
556     }
557 
558     /*
559      * Web3 call functions
560      */
561     /// @dev Returns number of confirmations of a transaction.
562     /// @param transactionId Transaction ID.
563     /// @return Number of confirmations.
564     function getConfirmationCount(uint transactionId)
565         public
566         constant
567         returns (uint count)
568     {
569         for (uint i=0; i<owners.length; i++)
570             if (confirmations[transactionId][owners[i]])
571                 count += 1;
572     }
573 
574     /// @dev Returns total number of transactions after filers are applied.
575     /// @param pending Include pending transactions.
576     /// @param executed Include executed transactions.
577     /// @return Total number of transactions after filters are applied.
578     function getTransactionCount(bool pending, bool executed)
579         public
580         constant
581         returns (uint count)
582     {
583         for (uint i=0; i<transactionCount; i++)
584             if (   pending && !transactions[i].executed
585                 || executed && transactions[i].executed)
586                 count += 1;
587     }
588 
589     /// @dev Returns list of owners.
590     /// @return List of owner addresses.
591     function getOwners()
592         public
593         constant
594         returns (address[])
595     {
596         return owners;
597     }
598 
599     /// @dev Returns array with owner addresses, which confirmed transaction.
600     /// @param transactionId Transaction ID.
601     /// @return Returns array of owner addresses.
602     function getConfirmations(uint transactionId)
603         public
604         constant
605         returns (address[] _confirmations)
606     {
607         address[] memory confirmationsTemp = new address[](owners.length);
608         uint count = 0;
609         uint i;
610         for (i=0; i<owners.length; i++)
611             if (confirmations[transactionId][owners[i]]) {
612                 confirmationsTemp[count] = owners[i];
613                 count += 1;
614             }
615         _confirmations = new address[](count);
616         for (i=0; i<count; i++)
617             _confirmations[i] = confirmationsTemp[i];
618     }
619 
620     /// @dev Returns list of transaction IDs in defined range.
621     /// @param from Index start position of transaction array.
622     /// @param to Index end position of transaction array.
623     /// @param pending Include pending transactions.
624     /// @param executed Include executed transactions.
625     /// @return Returns array of transaction IDs.
626     function getTransactionIds(uint from, uint to, bool pending, bool executed)
627         public
628         constant
629         returns (uint[] _transactionIds)
630     {
631         uint[] memory transactionIdsTemp = new uint[](transactionCount);
632         uint count = 0;
633         uint i;
634         for (i=0; i<transactionCount; i++)
635             if (   pending && !transactions[i].executed
636                 || executed && transactions[i].executed)
637             {
638                 transactionIdsTemp[count] = i;
639                 count += 1;
640             }
641         _transactionIds = new uint[](to - from);
642         for (i=from; i<to; i++)
643             _transactionIds[i - from] = transactionIdsTemp[i];
644     }
645 }
646 
647 pragma solidity ^0.4.11;
648 
649 
650 /*
651     Copyright 2017, Giovanni Zorzato (Boulé Foundation)
652  */
653 
654 contract BoulePreSale is Ownable{
655 
656     uint public initialBlock;             // Block number in which the sale starts.
657     uint public discountBlock;            // Block number in which the priority discount end.
658     uint public finalBlock;               // Block number in which the sale end.
659 
660     address public bouleDevMultisig;      // The address to hold the funds donated
661 
662 
663     uint public totalCollected = 0;               // In wei
664     bool public saleStopped = false;              // Has Boulé Dev stopped the sale?
665     bool public saleFinalized = false;            // Has Boulé Dev finalized the sale?
666 
667     BouleToken public token;              // The token
668 
669     MultiSigWallet wallet;
670 
671     uint constant public minInvestment = 1 finney;    // Minimum investment  0,001 ETH
672     uint public hardCap = 10000 ether;               // Pre-sale Cap
673     uint public minFundingGoal = 300 ether;          // Minimum funding goal for sale success
674 
675 
676     /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
677     mapping (address => bool) public whitelist;
678 
679     /** How much they have invested */
680     mapping(address => uint) public balances;
681 
682     event NewBuyer(address indexed holder, uint256 bouAmount, uint256 amount);
683     // Address early participation whitelist status changed
684     event Whitelisted(address addr, bool status);
685     // Investor has been refunded because the ico did not reach the min funding goal
686     event Refunded(address investor, uint value);
687 
688     function BoulePreSale (
689     address _token,
690     uint _initialBlock,
691     uint _discountBlock,
692     uint _finalBlock,
693     address _bouleDevMultisig
694     )
695     {
696         if (_initialBlock >= _finalBlock) throw;
697 
698         // Save constructor arguments as global variables
699         token = BouleToken(_token);
700 
701         initialBlock = _initialBlock;
702         discountBlock = _discountBlock;
703         finalBlock = _finalBlock;
704         bouleDevMultisig = _bouleDevMultisig;
705         // create wallet object
706         wallet = MultiSigWallet(bouleDevMultisig);
707 
708     }
709 
710     // change whitelist status for a specific address
711     function setWhitelistStatus(address addr, bool status)
712     onlyOwner {
713         whitelist[addr] = status;
714         Whitelisted(addr, status);
715     }
716 
717     // @notice Get the price for a BOU token at any given block number
718     // @param _blockNumber the block for which the price is requested
719     // @return price of boule
720     // If sale isn't ongoing for that block, returns 0.
721     function getPrice(uint _blockNumber) constant public returns (uint256) {
722         if (_blockNumber >= finalBlock) return 0;
723         if(_blockNumber <= discountBlock){
724             return 2000; // 2000 BOU for 1 ETH first 24 hours (approx in blocks)
725         }
726         return 1400; // 1400 BOU for 1 ETH after 24 hours (approx in blocks)
727     }
728 
729 
730     /// @dev The fallback function is called when ether is sent to the contract, it
731     /// simply calls `doPayment()` with the address that sent the ether as the
732     /// `_owner`. Payable is a required solidity modifier for functions to receive
733     /// ether, without this modifier functions will throw if ether is sent to them
734 
735     function () public payable {
736         doPayment(msg.sender);
737     }
738 
739 
740 
741     /// @dev `doPayment()` is an internal function that sends the ether that this
742     ///  contract receives to the bouleDevMultisig and creates tokens in the address of the
743     /// @param _owner The address that will hold the newly created tokens
744 
745     function doPayment(address _owner)
746     only_during_sale_period_or_whitelisted(_owner)
747     only_sale_not_stopped
748     non_zero_address(_owner)
749     minimum_value(minInvestment)
750     internal {
751         // do not allow to go past hard cap
752         if ((totalCollected + msg.value) > hardCap) throw; // If past hard cap, throw
753 
754         if ((totalCollected + msg.value) < minFundingGoal){ // if under min funding goal
755             // record the investment for possible refund in case the ICO does not finalize
756             balances[_owner] = SafeMath.add(balances[_owner], msg.value);
757             // keep funds here
758         }
759         else{
760             if (!wallet.send(msg.value)) throw; // Send funds to multisig wallet
761         }
762 
763         uint256 boughtTokens = SafeMath.mul(msg.value, getPrice(getBlockNumber())); // Calculate how many tokens bought
764 
765         if (!token.mint(_owner, boughtTokens)) throw; // Allocate tokens.
766 
767         totalCollected = SafeMath.add(totalCollected, msg.value); // Save total collected amount
768 
769         NewBuyer(_owner, boughtTokens, msg.value);
770     }
771 
772     // allow investors to be refunded if the sale does not reach min investment target (minFundingGoal)
773     // refund can be asked only after sale period
774     function refund()
775     only_sale_refundable {
776         address investor = msg.sender;
777         if(balances[investor] == 0) throw; // nothing to refund
778         uint amount = balances[investor];
779         // remove balance
780         delete balances[investor];
781         // send back eth
782         if(!investor.send(amount)) throw;
783 
784         Refunded(investor, amount);
785     }
786 
787     // @notice Function to stop sale for an emergency.
788     // @dev Only Boulé Dev can do it after it has been activated.
789     function emergencyStopSale()
790     only_sale_not_stopped
791     onlyOwner
792     public {
793 
794         saleStopped = true;
795     }
796 
797     // @notice Function to restart stopped sale.
798     // @dev Only Boulé Dev can do it after it has been disabled and sale is ongoing.
799     function restartSale()
800     only_during_sale_period
801     only_sale_stopped
802     onlyOwner
803     public {
804 
805         saleStopped = false;
806     }
807 
808     // @notice Function to change sale block intervals.
809     // @dev Only Boulé Dev can do it while the sale is ongoing to fix block time variations.
810     function changeSaleBlocks(uint _initialBlock, uint _discountBlock, uint _finalBlock)
811     onlyOwner
812     only_sale_not_stopped
813     public {
814         if (_initialBlock >= _finalBlock) throw;
815         if (_initialBlock >= _discountBlock) throw;
816         if (saleFinalized) throw; // only if sale is still active
817         initialBlock = _initialBlock;
818         discountBlock = _discountBlock;
819         finalBlock = _finalBlock;
820     }
821 
822 
823     // @notice Moves funds in sale contract to Boulé MultiSigWallet.
824     // @dev  Moves funds in sale contract to Boulé MultiSigWallet.
825     function moveFunds()
826     onlyOwner
827     public {
828         if (totalCollected < minFundingGoal) throw;
829         // move funds
830         if (!wallet.send(this.balance)) throw;
831     }
832 
833 
834     // @notice Finalizes sale generating the tokens for Boulé Dev.
835     // @dev Transfers the token controller power to the ANPlaceholder.
836     function finalizeSale()
837     only_after_sale
838     onlyOwner
839     public {
840 
841         doFinalizeSale();
842     }
843 
844     function doFinalizeSale()
845     internal {
846         // Doesn't check if saleStopped is false, because sale could end in a emergency stop.
847         // This function cannot be successfully called twice, because it will top being the controller,
848         // and the generateTokens call will fail if called again.
849 
850         // Boulé owns 50% of the total number of emitted tokens at the end of the pre-sale.
851 
852         if (totalCollected >= minFundingGoal){ // if min funding goal reached
853             // move all remaining eth in the sale contract into multisig wallet (no refund is possible anymore)
854             if (!wallet.send(this.balance)) throw;
855 
856             uint256 bouleTokenSupply = token.totalSupply();
857 
858             if (!token.mint(bouleDevMultisig, bouleTokenSupply)) throw; // Allocate tokens for Boulé.
859         }
860         // token will be owned by Boulé multisig wallet, this contract cannot mint anymore
861         token.transferOwnership(bouleDevMultisig);
862 
863         saleFinalized = true;
864         saleStopped = true;
865     }
866 
867 
868     function getBlockNumber() constant internal returns (uint) {
869         return block.number;
870     }
871 
872 
873     modifier only(address x) {
874         if (msg.sender != x) throw;
875         _;
876     }
877 
878     modifier only_before_sale {
879         if (getBlockNumber() >= initialBlock) throw;
880         _;
881     }
882 
883     modifier only_during_sale_period {
884         if (getBlockNumber() < initialBlock) throw;
885         if (getBlockNumber() >= finalBlock) throw;
886         _;
887     }
888 
889     // valid only during sale or before sale if the sender is whitelisted
890     modifier only_during_sale_period_or_whitelisted(address x) {
891         if (getBlockNumber() < initialBlock && !whitelist[x]) throw;
892         if (getBlockNumber() >= finalBlock) throw;
893         _;
894     }
895 
896     modifier only_after_sale {
897         if (getBlockNumber() < finalBlock) throw;
898         _;
899     }
900 
901     modifier only_sale_stopped {
902         if (!saleStopped) throw;
903         _;
904     }
905 
906     modifier only_sale_not_stopped {
907         if (saleStopped) throw;
908         _;
909     }
910 
911     modifier only_finalized_sale {
912         if (getBlockNumber() < finalBlock) throw;
913         if (!saleFinalized) throw;
914         _;
915     }
916 
917     modifier non_zero_address(address x) {
918         if (x == 0) throw;
919         _;
920     }
921 
922     modifier only_sale_refundable {
923         if (getBlockNumber() < finalBlock) throw; // sale must have ended
924         if (totalCollected >= minFundingGoal) throw; // sale must be under min funding goal
925         _;
926     }
927 
928     modifier minimum_value(uint256 x) {
929         if (msg.value < x) throw;
930         _;
931     }
932 }