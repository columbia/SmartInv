1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) onlyOwner public {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @title Contracts that should not own Ether
47  * @author Remco Bloemen <remco@2π.com>
48  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
49  * in the contract, it will allow the owner to reclaim this ether.
50  * @notice Ether can still be send to this contract by:
51  * calling functions labeled `payable`
52  * `selfdestruct(contract_address)`
53  * mining directly to the contract address
54 */
55 contract HasNoEther is Ownable {
56 
57     /**
58     * @dev Constructor that rejects incoming Ether
59     * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
60     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
61     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
62     * we could use assembly to access msg.value.
63     */
64     function HasNoEther() payable {
65         require(msg.value == 0);
66     }
67 
68     /**
69      * @dev Disallows direct send by settings a default function without the `payable` flag.
70      */
71     function() external {
72     }
73 
74     /**
75      * @dev Transfer all Ether held by the contract to the owner.
76      */
77     function reclaimEther() external onlyOwner {
78         assert(owner.send(this.balance));
79     }
80 }
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that throw on error
85  */
86 library SafeMath {
87     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
88         uint256 c = a * b;
89         assert(a == 0 || c / a == b);
90         return c;
91     }
92 
93     function div(uint256 a, uint256 b) internal constant returns (uint256) {
94         // assert(b > 0); // Solidity automatically throws when dividing by 0
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
101         assert(b <= a);
102         return a - b;
103     }
104 
105     function add(uint256 a, uint256 b) internal constant returns (uint256) {
106         uint256 c = a + b;
107         assert(c >= a);
108         return c;
109     }
110 }
111 
112 /**
113  * Fixed crowdsale pricing - everybody gets the same price.
114  */
115 contract PricingStrategy is HasNoEther {
116     using SafeMath for uint;
117 
118     /* How many weis one token costs */
119     uint256 public oneTokenInWei;
120 
121     address public crowdsaleAddress;
122 
123     function PricingStrategy(address _crowdsale) {
124         crowdsaleAddress = _crowdsale;
125     }
126 
127     modifier onlyCrowdsale() {
128         require(msg.sender == crowdsaleAddress);
129         _;
130     }
131 
132     /**
133      * Calculate the current price for buy in amount.
134      *
135      */
136     function calculatePrice(uint256 _value, uint256 _decimals) public constant returns (uint) {
137         uint256 multiplier = 10 ** _decimals;
138         uint256 weiAmount = _value.mul(multiplier);
139         uint256 tokens = weiAmount.div(oneTokenInWei);
140         return tokens;
141     }
142 
143     function setTokenPriceInWei(uint _oneTokenInWei) onlyCrowdsale public returns (bool) {
144         oneTokenInWei = _oneTokenInWei;
145         return true;
146     }
147 }
148 
149 /**
150  * @title Pausable
151  * @dev Base contract which allows children to implement an emergency stop mechanism.
152  */
153 contract Pausable is Ownable {
154     event Pause();
155     event Unpause();
156 
157     bool public paused = false;
158 
159 
160     /**
161      * @dev Modifier to make a function callable only when the contract is not paused.
162      */
163     modifier whenNotPaused() {
164         require(!paused);
165         _;
166     }
167 
168     /**
169      * @dev Modifier to make a function callable only when the contract is paused.
170      */
171     modifier whenPaused() {
172         require(paused);
173         _;
174     }
175 
176     /**
177      * @dev called by the owner to pause, triggers stopped state
178      */
179     function pause() onlyOwner whenNotPaused public {
180         paused = true;
181         Pause();
182     }
183 
184     /**
185      * @dev called by the owner to unpause, returns to normal state
186      */
187     function unpause() onlyOwner whenPaused public {
188         paused = false;
189         Unpause();
190     }
191 }
192 
193 contract RNTMultiSigWallet {
194     /*
195      *  Events
196      */
197     event Confirmation(address indexed sender, uint indexed transactionId);
198 
199     event Revocation(address indexed sender, uint indexed transactionId);
200 
201     event Submission(uint indexed transactionId);
202 
203     event Execution(uint indexed transactionId);
204 
205     event ExecutionFailure(uint indexed transactionId);
206 
207     event Deposit(address indexed sender, uint value);
208 
209     event OwnerAddition(address indexed owner);
210 
211     event OwnerRemoval(address indexed owner);
212 
213     event RequirementChange(uint required);
214 
215     event Pause();
216 
217     event Unpause();
218 
219     /*
220      *  Constants
221      */
222     uint constant public MAX_OWNER_COUNT = 10;
223 
224     uint constant public ADMINS_COUNT = 2;
225 
226     /*
227      *  Storage
228      */
229     mapping(uint => WalletTransaction) public transactions;
230 
231     mapping(uint => mapping(address => bool)) public confirmations;
232 
233     mapping(address => bool) public isOwner;
234 
235     mapping(address => bool) public isAdmin;
236 
237     address[] public owners;
238 
239     address[] public admins;
240 
241     uint public required;
242 
243     uint public transactionCount;
244 
245     bool public paused = false;
246 
247     struct WalletTransaction {
248         address sender;
249         address destination;
250         uint value;
251         bytes data;
252         bool executed;
253     }
254 
255     /*
256      *  Modifiers
257      */
258 
259     /// @dev Modifier to make a function callable only when the contract is not paused.
260     modifier whenNotPaused() {
261         require(!paused);
262         _;
263     }
264 
265     /// @dev Modifier to make a function callable only when the contract is paused.
266     modifier whenPaused() {
267         require(paused);
268         _;
269     }
270 
271     modifier onlyWallet() {
272         require(msg.sender == address(this));
273         _;
274     }
275 
276     modifier ownerDoesNotExist(address owner) {
277         require(!isOwner[owner]);
278         _;
279     }
280 
281     modifier ownerExists(address owner) {
282         require(isOwner[owner]);
283         _;
284     }
285 
286     modifier adminExists(address admin) {
287         require(isAdmin[admin]);
288         _;
289     }
290 
291     modifier adminDoesNotExist(address admin) {
292         require(!isAdmin[admin]);
293         _;
294     }
295 
296     modifier transactionExists(uint transactionId) {
297         require(transactions[transactionId].destination != 0);
298         _;
299     }
300 
301     modifier confirmed(uint transactionId, address owner) {
302         require(confirmations[transactionId][owner]);
303         _;
304     }
305 
306     modifier notConfirmed(uint transactionId, address owner) {
307         require(!confirmations[transactionId][owner]);
308         _;
309     }
310 
311     modifier notExecuted(uint transactionId) {
312         if (transactions[transactionId].executed)
313             require(false);
314         _;
315     }
316 
317     modifier notNull(address _address) {
318         require(_address != 0);
319         _;
320     }
321 
322     modifier validRequirement(uint ownerCount, uint _required) {
323         if (ownerCount > MAX_OWNER_COUNT
324         || _required > ownerCount
325         || _required == 0
326         || ownerCount == 0) {
327             require(false);
328         }
329         _;
330     }
331 
332     modifier validAdminsCount(uint adminsCount) {
333         require(adminsCount == ADMINS_COUNT);
334         _;
335     }
336 
337     /// @dev Fallback function allows to deposit ether.
338     function()
339     whenNotPaused
340     payable
341     {
342         if (msg.value > 0)
343             Deposit(msg.sender, msg.value);
344     }
345 
346     /*
347      * Public functions
348      */
349     /// @dev Contract constructor sets initial admins and required number of confirmations.
350     /// @param _admins List of initial owners.
351     /// @param _required Number of required confirmations.
352     function RNTMultiSigWallet(address[] _admins, uint _required)
353     public
354         //    validAdminsCount(_admins.length)
355         //    validRequirement(_admins.length, _required)
356     {
357         for (uint i = 0; i < _admins.length; i++) {
358             require(_admins[i] != 0 && !isOwner[_admins[i]] && !isAdmin[_admins[i]]);
359             isAdmin[_admins[i]] = true;
360             isOwner[_admins[i]] = true;
361         }
362 
363         admins = _admins;
364         owners = _admins;
365         required = _required;
366     }
367 
368     /// @dev called by the owner to pause, triggers stopped state
369     function pause() adminExists(msg.sender) whenNotPaused public {
370         paused = true;
371         Pause();
372     }
373 
374     /// @dev called by the owner to unpause, returns to normal state
375     function unpause() adminExists(msg.sender) whenPaused public {
376         paused = false;
377         Unpause();
378     }
379 
380     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
381     /// @param owner Address of new owner.
382     function addOwner(address owner)
383     public
384     whenNotPaused
385     adminExists(msg.sender)
386     ownerDoesNotExist(owner)
387     notNull(owner)
388     validRequirement(owners.length + 1, required)
389     {
390         isOwner[owner] = true;
391         owners.push(owner);
392         OwnerAddition(owner);
393     }
394 
395     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
396     /// @param owner Address of owner.
397     function removeOwner(address owner)
398     public
399     whenNotPaused
400     adminExists(msg.sender)
401     adminDoesNotExist(owner)
402     ownerExists(owner)
403     {
404         isOwner[owner] = false;
405         for (uint i = 0; i < owners.length - 1; i++)
406             if (owners[i] == owner) {
407                 owners[i] = owners[owners.length - 1];
408                 break;
409             }
410         owners.length -= 1;
411         if (required > owners.length)
412             changeRequirement(owners.length);
413         OwnerRemoval(owner);
414     }
415 
416     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
417     /// @param owner Address of owner to be replaced.
418     /// @param newOwner Address of new owner.
419     function replaceOwner(address owner, address newOwner)
420     public
421     whenNotPaused
422     adminExists(msg.sender)
423     adminDoesNotExist(owner)
424     ownerExists(owner)
425     ownerDoesNotExist(newOwner)
426     {
427         for (uint i = 0; i < owners.length; i++)
428             if (owners[i] == owner) {
429                 owners[i] = newOwner;
430                 break;
431             }
432         isOwner[owner] = false;
433         isOwner[newOwner] = true;
434         OwnerRemoval(owner);
435         OwnerAddition(newOwner);
436     }
437 
438     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
439     /// @param _required Number of required confirmations.
440     function changeRequirement(uint _required)
441     public
442     whenNotPaused
443     adminExists(msg.sender)
444     validRequirement(owners.length, _required)
445     {
446         required = _required;
447         RequirementChange(_required);
448     }
449 
450     /// @dev Allows an owner to submit and confirm a transaction.
451     /// @param destination Transaction target address.
452     /// @param value Transaction ether value.
453     /// @param data Transaction data payload.
454     /// @return Returns transaction ID.
455     function submitTransaction(address destination, uint value, bytes data)
456     public
457     whenNotPaused
458     ownerExists(msg.sender)
459     returns (uint transactionId)
460     {
461         transactionId = addTransaction(destination, value, data);
462         confirmTransaction(transactionId);
463     }
464 
465     /// @dev Allows an owner to confirm a transaction.
466     /// @param transactionId Transaction ID.
467     function confirmTransaction(uint transactionId)
468     public
469     whenNotPaused
470     ownerExists(msg.sender)
471     transactionExists(transactionId)
472     notConfirmed(transactionId, msg.sender)
473     {
474         confirmations[transactionId][msg.sender] = true;
475         Confirmation(msg.sender, transactionId);
476         executeTransaction(transactionId);
477     }
478 
479     /// @dev Allows an owner to revoke a confirmation for a transaction.
480     /// @param transactionId Transaction ID.
481     function revokeConfirmation(uint transactionId)
482     public
483     whenNotPaused
484     ownerExists(msg.sender)
485     confirmed(transactionId, msg.sender)
486     notExecuted(transactionId)
487     {
488         confirmations[transactionId][msg.sender] = false;
489         Revocation(msg.sender, transactionId);
490     }
491 
492     /// @dev Allows anyone to execute a confirmed transaction.
493     /// @param transactionId Transaction ID.
494     function executeTransaction(uint transactionId)
495     public
496     whenNotPaused
497     ownerExists(msg.sender)
498     confirmed(transactionId, msg.sender)
499     notExecuted(transactionId)
500     {
501         if (isConfirmed(transactionId)) {
502             WalletTransaction storage walletTransaction = transactions[transactionId];
503             walletTransaction.executed = true;
504             if (walletTransaction.destination.call.value(walletTransaction.value)(walletTransaction.data))
505                 Execution(transactionId);
506             else {
507                 ExecutionFailure(transactionId);
508                 walletTransaction.executed = false;
509             }
510         }
511     }
512 
513     /// @dev Returns the confirmation status of a transaction.
514     /// @param transactionId Transaction ID.
515     /// @return Confirmation status.
516     function isConfirmed(uint transactionId)
517     public
518     constant
519     returns (bool)
520     {
521         uint count = 0;
522         for (uint i = 0; i < owners.length; i++) {
523             if (confirmations[transactionId][owners[i]])
524                 count += 1;
525             if (count == required)
526                 return true;
527         }
528     }
529 
530     /*
531      * Internal functions
532      */
533     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
534     /// @param destination Transaction target address.
535     /// @param value Transaction ether value.
536     /// @param data Transaction data payload.
537     /// @return Returns transaction ID.
538     function addTransaction(address destination, uint value, bytes data)
539     internal
540     notNull(destination)
541     returns (uint transactionId)
542     {
543         transactionId = transactionCount;
544         transactions[transactionId] = WalletTransaction({
545             sender : msg.sender,
546             destination : destination,
547             value : value,
548             data : data,
549             executed : false
550             });
551         transactionCount += 1;
552         Submission(transactionId);
553     }
554 
555     /*
556      * Web3 call functions
557      */
558     /// @dev Returns number of confirmations of a transaction.
559     /// @param transactionId Transaction ID.
560     /// @return Number of confirmations.
561     function getConfirmationCount(uint transactionId)
562     public
563     constant
564     returns (uint count)
565     {
566         for (uint i = 0; i < owners.length; i++)
567             if (confirmations[transactionId][owners[i]])
568                 count += 1;
569     }
570 
571     /// @dev Returns total number of transactions after filers are applied.
572     /// @param pending Include pending transactions.
573     /// @param executed Include executed transactions.
574     /// @return Total number of transactions after filters are applied.
575     function getTransactionCount(bool pending, bool executed)
576     public
577     constant
578     returns (uint count)
579     {
580         for (uint i = 0; i < transactionCount; i++)
581             if (pending && !transactions[i].executed
582             || executed && transactions[i].executed)
583                 count += 1;
584     }
585 
586     /// @dev Returns list of owners.
587     /// @return List of owner addresses.
588     function getOwners()
589     public
590     constant
591     returns (address[])
592     {
593         return owners;
594     }
595 
596     // @dev Returns list of admins.
597     // @return List of admin addresses
598     function getAdmins()
599     public
600     constant
601     returns (address[])
602     {
603         return admins;
604     }
605 
606     /// @dev Returns array with owner addresses, which confirmed transaction.
607     /// @param transactionId Transaction ID.
608     /// @return Returns array of owner addresses.
609     function getConfirmations(uint transactionId)
610     public
611     constant
612     returns (address[] _confirmations)
613     {
614         address[] memory confirmationsTemp = new address[](owners.length);
615         uint count = 0;
616         uint i;
617         for (i = 0; i < owners.length; i++)
618             if (confirmations[transactionId][owners[i]]) {
619                 confirmationsTemp[count] = owners[i];
620                 count += 1;
621             }
622         _confirmations = new address[](count);
623         for (i = 0; i < count; i++)
624             _confirmations[i] = confirmationsTemp[i];
625     }
626 
627     /// @dev Returns list of transaction IDs in defined range.
628     /// @param from Index start position of transaction array.
629     /// @param to Index end position of transaction array.
630     /// @param pending Include pending transactions.
631     /// @param executed Include executed transactions.
632     /// @return Returns array of transaction IDs.
633     function getTransactionIds(uint from, uint to, bool pending, bool executed)
634     public
635     constant
636     returns (uint[] _transactionIds)
637     {
638         uint[] memory transactionIdsTemp = new uint[](transactionCount);
639         uint count = 0;
640         uint i;
641         for (i = 0; i < transactionCount; i++)
642             if (pending && !transactions[i].executed
643             || executed && transactions[i].executed)
644             {
645                 transactionIdsTemp[count] = i;
646                 count += 1;
647             }
648         _transactionIds = new uint[](to - from);
649         for (i = from; i < to; i++)
650             _transactionIds[i - from] = transactionIdsTemp[i];
651     }
652 }
653 
654 contract RntPresaleEthereumDeposit is Pausable {
655     using SafeMath for uint256;
656 
657     uint256 public overallTakenEther = 0;
658 
659     mapping(address => uint256) public receivedEther;
660 
661     struct Donator {
662         address addr;
663         uint256 donated;
664     }
665 
666     Donator[] donators;
667 
668     RNTMultiSigWallet public wallet;
669 
670     function RntPresaleEthereumDeposit(address _walletAddress) {
671         wallet = RNTMultiSigWallet(_walletAddress);
672     }
673 
674     function updateDonator(address _address) internal {
675         bool isFound = false;
676         for (uint i = 0; i < donators.length; i++) {
677             if (donators[i].addr == _address) {
678                 donators[i].donated = receivedEther[_address];
679                 isFound = true;
680                 break;
681             }
682         }
683         if (!isFound) {
684             donators.push(Donator(_address, receivedEther[_address]));
685         }
686     }
687 
688     function getDonatorsNumber() external constant returns (uint256) {
689         return donators.length;
690     }
691 
692     function getDonator(uint pos) external constant returns (address, uint256) {
693         return (donators[pos].addr, donators[pos].donated);
694     }
695 
696     /*
697      * Fallback function for sending ether to wallet and update donators info
698      */
699     function() whenNotPaused payable {
700         wallet.transfer(msg.value);
701 
702         overallTakenEther = overallTakenEther.add(msg.value);
703         receivedEther[msg.sender] = receivedEther[msg.sender].add(msg.value);
704 
705         updateDonator(msg.sender);
706     }
707 
708     function receivedEtherFrom(address _from) whenNotPaused constant public returns (uint256) {
709         return receivedEther[_from];
710     }
711 
712     function myEther() whenNotPaused constant public returns (uint256) {
713         return receivedEther[msg.sender];
714     }
715 }
716 
717 contract PresaleFinalizeAgent is HasNoEther {
718     using SafeMath for uint256;
719 
720     RntPresaleEthereumDeposit public deposit;
721 
722     address public crowdsaleAddress;
723 
724     mapping(address => uint256) public tokensForAddress;
725 
726     uint256 public weiPerToken = 0;
727 
728     bool public sane = true;
729 
730     function PresaleFinalizeAgent(address _deposit, address _crowdsale){
731         deposit = RntPresaleEthereumDeposit(_deposit);
732         crowdsaleAddress = _crowdsale;
733     }
734 
735     modifier onlyCrowdsale() {
736         require(msg.sender == crowdsaleAddress);
737         _;
738     }
739 
740     function isSane() public constant returns (bool) {
741         return sane;
742     }
743 
744     function setCrowdsaleAddress(address _address) onlyOwner public {
745         crowdsaleAddress = _address;
746     }
747 
748     function finalizePresale(uint256 presaleTokens) onlyCrowdsale public {
749         require(sane);
750         uint256 overallEther = deposit.overallTakenEther();
751         uint256 multiplier = 10 ** 18;
752         overallEther = overallEther.mul(multiplier);
753         weiPerToken = overallEther.div(presaleTokens);
754         require(weiPerToken > 0);
755         sane = false;
756     }
757 }
758 
759 contract IRntToken {
760     uint256 public decimals = 18;
761 
762     uint256 public totalSupply = 1000000000 * (10 ** 18);
763 
764     string public name = "RNT Token";
765 
766     string public code = "RNT";
767 
768 
769     function balanceOf() public constant returns (uint256 balance);
770 
771     function transfer(address _to, uint _value) public returns (bool success);
772 
773     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
774 }
775 
776 contract RntCrowdsale is Pausable {
777     using SafeMath for uint256;
778 
779     enum Status {Unknown, Presale, ICO, Finalized} // Crowdsale status
780 
781     Status public currentStatus = Status.Unknown;
782 
783     bool public isPresaleStarted = false;
784 
785     bool public isPresaleFinalized = false;
786 
787     bool public isIcoStarted = false;
788 
789     bool public isIcoFinalized = false;
790 
791     uint256 public icoReceivedWei;
792 
793     uint256 public icoTokensSold;
794 
795     uint256 public icoInvestmentsCount = 0;
796 
797     mapping(address => uint256) public icoInvestments;
798 
799     mapping(address => uint256) public icoTokenTransfers;
800 
801     IRntToken public token;
802 
803     PricingStrategy public pricingStrategy;
804 
805     PresaleFinalizeAgent public presaleFinalizeAgent;
806 
807     RntPresaleEthereumDeposit public deposit;
808 
809     address public wallet;
810 
811     address public proxy;
812 
813     mapping(address => bool) public tokensAllocationAllowed;
814 
815     uint public presaleStartTime;
816 
817     uint public presaleEndTime;
818 
819     uint public icoStartTime;
820 
821     uint public icoEndTime;
822 
823     /**
824     @notice A new investment was made.
825     */
826     event Invested(address indexed investor, uint weiAmount, uint tokenAmount, bytes16 indexed customerId);
827 
828     event PresaleStarted(uint timestamp);
829 
830     event PresaleFinalized(uint timestamp);
831 
832     event IcoStarted(uint timestamp);
833 
834     event IcoFinalized(uint timestamp);
835 
836     /**
837     @notice Token price was calculated.
838     */
839     event TokensPerWeiReceived(uint tokenPrice);
840 
841     /**
842     @notice Presale tokens was claimed.
843     */
844     event PresaleTokensClaimed(uint count);
845 
846     function RntCrowdsale(address _tokenAddress) {
847         token = IRntToken(_tokenAddress);
848     }
849 
850     /**
851     @notice Allow call function only if crowdsale on specified status.
852     */
853     modifier inStatus(Status status) {
854         require(getCrowdsaleStatus() == status);
855         _;
856     }
857 
858     /**
859     @notice Check that address can allocate tokens.
860     */
861     modifier canAllocateTokens {
862         require(tokensAllocationAllowed[msg.sender] == true);
863         _;
864     }
865 
866     /**
867     @notice Allow address to call allocate function.
868     @param _addr Address for allowance
869     @param _allow Allowance
870     */
871     function allowAllocation(address _addr, bool _allow) onlyOwner external {
872         tokensAllocationAllowed[_addr] = _allow;
873     }
874 
875     /**
876     @notice Set PresaleFinalizeAgent address.
877     @dev Used to calculate price for one token.
878     */
879     function setPresaleFinalizeAgent(address _agentAddress) whenNotPaused onlyOwner external {
880         presaleFinalizeAgent = PresaleFinalizeAgent(_agentAddress);
881     }
882 
883     /**
884     @notice Set PricingStrategy address.
885     @dev Used to calculate tokens that will be received through investment.
886     */
887     function setPricingStartegy(address _pricingStrategyAddress) whenNotPaused onlyOwner external {
888         pricingStrategy = PricingStrategy(_pricingStrategyAddress);
889     }
890 
891     /**
892     @notice Set RNTMultiSigWallet address.
893     @dev Wallet for invested wei.
894     */
895     function setMultiSigWallet(address _walletAddress) whenNotPaused onlyOwner external {
896         wallet = _walletAddress;
897     }
898 
899 
900     /**
901     @notice Set RntTokenProxy address.
902     */
903     function setBackendProxyBuyer(address _proxyAddress) whenNotPaused onlyOwner external {
904         proxy = _proxyAddress;
905     }
906 
907     /**
908     @notice Set RntPresaleEhtereumDeposit address.
909     @dev Deposit used to calculate presale tokens.
910     */
911     function setPresaleEthereumDeposit(address _depositAddress) whenNotPaused onlyOwner external {
912         deposit = RntPresaleEthereumDeposit(_depositAddress);
913     }
914 
915     /**
916     @notice Get current crowdsale status.
917     @return { One of possible crowdsale statuses [Unknown, Presale, ICO, Finalized] }
918     */
919     function getCrowdsaleStatus() constant public returns (Status) {
920         return currentStatus;
921     }
922 
923     /**
924     @notice Start presale and track start time.
925     */
926     function startPresale() whenNotPaused onlyOwner external {
927         require(!isPresaleStarted);
928 
929         currentStatus = Status.Presale;
930         isPresaleStarted = true;
931 
932         presaleStartTime = now;
933         PresaleStarted(presaleStartTime);
934     }
935 
936     /**
937     @notice Finalize presale, calculate token price, track finalize time.
938     */
939     function finalizePresale() whenNotPaused onlyOwner external {
940         require(isPresaleStarted && !isPresaleFinalized);
941         require(presaleFinalizeAgent.isSane());
942 
943         uint256 presaleSupply = token.totalSupply();
944 
945         // Presale supply is 20% of total
946         presaleSupply = presaleSupply.div(5);
947 
948         presaleFinalizeAgent.finalizePresale(presaleSupply);
949         uint tokenWei = presaleFinalizeAgent.weiPerToken();
950         pricingStrategy.setTokenPriceInWei(tokenWei);
951         TokensPerWeiReceived(tokenWei);
952 
953         require(tokenWei > 0);
954 
955         currentStatus = Status.Unknown;
956         isPresaleFinalized = true;
957 
958         presaleEndTime = now;
959         PresaleFinalized(presaleEndTime);
960     }
961 
962     /**
963     @notice Start ICO and track start time.
964     */
965     function startIco() whenNotPaused onlyOwner external {
966         require(!isIcoStarted && isPresaleFinalized);
967 
968         currentStatus = Status.ICO;
969         isIcoStarted = true;
970 
971         icoStartTime = now;
972         IcoStarted(icoStartTime);
973     }
974 
975     /**
976     @notice Finalize ICO and track finalize time.
977     */
978     function finalizeIco() whenNotPaused onlyOwner external {
979         require(!isIcoFinalized && isIcoStarted);
980 
981         currentStatus = Status.Finalized;
982         isIcoFinalized = true;
983 
984         icoEndTime = now;
985         IcoFinalized(icoEndTime);
986     }
987 
988 
989     /**
990     @notice Handle invested wei.
991     @dev Send some amount of wei to wallet and get tokens that will be calculated according Pricing Strategy.
992          It will transfer ether to wallet only if investment did inside ethereum using payable method.
993     @param _receiver The Ethereum address who receives the tokens.
994     @param _customerUuid (optional) UUID v4 to track the successful payments on the server side.
995     */
996     function investInternal(address _receiver, bytes16 _customerUuid) private {
997         uint weiAmount = msg.value;
998 
999         uint256 tokenAmount = pricingStrategy.calculatePrice(weiAmount, 18);
1000 
1001         require(tokenAmount != 0);
1002 
1003         if (icoInvestments[_receiver] == 0) {
1004             // A new investor
1005             icoInvestmentsCount++;
1006         }
1007         icoInvestments[_receiver] = icoInvestments[_receiver].add(weiAmount);
1008         icoTokenTransfers[_receiver] = icoTokenTransfers[_receiver].add(tokenAmount);
1009         icoReceivedWei = icoReceivedWei.add(weiAmount);
1010         icoTokensSold = icoTokensSold.add(tokenAmount);
1011 
1012         assignTokens(owner, _receiver, tokenAmount);
1013 
1014         // Pocket the money
1015         wallet.transfer(weiAmount);
1016 
1017         // Tell us invest was success
1018         Invested(_receiver, weiAmount, tokenAmount, _customerUuid);
1019     }
1020 
1021     /**
1022     @notice Handle tokens allocating.
1023     @dev Uses when tokens was bought not in ethereum
1024     @param _receiver The Ethereum address who receives the tokens.
1025     @param _customerUuid (optional) UUID v4 to track the successful payments on the server side.
1026     @param _weiAmount Wei amount, that should be specified only if user was invested out
1027     */
1028     function allocateInternal(address _receiver, bytes16 _customerUuid, uint256 _weiAmount) private {
1029         uint256 tokenAmount = pricingStrategy.calculatePrice(_weiAmount, 18);
1030 
1031         require(tokenAmount != 0);
1032 
1033         if (icoInvestments[_receiver] == 0) {
1034             // A new investor
1035             icoInvestmentsCount++;
1036         }
1037         icoInvestments[_receiver] = icoInvestments[_receiver].add(_weiAmount);
1038         icoTokenTransfers[_receiver] = icoTokenTransfers[_receiver].add(tokenAmount);
1039         icoReceivedWei = icoReceivedWei.add(_weiAmount);
1040         icoTokensSold = icoTokensSold.add(tokenAmount);
1041 
1042         assignTokens(owner, _receiver, tokenAmount);
1043 
1044         // Tell us invest was success
1045         Invested(_receiver, _weiAmount, tokenAmount, _customerUuid);
1046     }
1047 
1048     /**
1049     @notice Allocate tokens to specified address.
1050     @dev Function that should be used only by proxy to handle payments outside ethereum.
1051     @param _receiver The Ethereum address who receives the tokens.
1052     @param _customerUuid (optional) UUID v4 to track the successful payments on the server side.
1053     @param _weiAmount User invested amount of money in wei.
1054     */
1055     function allocateTokens(address _receiver, bytes16 _customerUuid, uint256 _weiAmount) whenNotPaused canAllocateTokens public {
1056         allocateInternal(_receiver, _customerUuid, _weiAmount);
1057     }
1058 
1059     /**
1060     @notice Make an investment.
1061     @dev Can be called only at ICO status. Should have wei != 0.
1062     @param _customerUuid (optional) UUID v4 to track the successful payments on the server side
1063     */
1064     function invest(bytes16 _customerUuid) whenNotPaused inStatus(Status.ICO) public payable {
1065         investInternal(msg.sender, _customerUuid);
1066     }
1067 
1068     /**
1069     @notice Function for claiming tokens for presale investors.
1070     @dev Can be called only after presale ends. Tokens will be transfered to callers address.
1071     */
1072     function claimPresaleTokens() whenNotPaused external {
1073         require(isPresaleFinalized == true);
1074 
1075         uint256 senderEther = deposit.receivedEtherFrom(msg.sender);
1076         uint256 multiplier = 10 ** 18;
1077         senderEther = senderEther.mul(multiplier);
1078         uint256 tokenWei = pricingStrategy.oneTokenInWei();
1079         uint256 tokensAmount = senderEther.div(tokenWei);
1080 
1081         require(tokensAmount > 0);
1082         token.transferFrom(owner, msg.sender, tokensAmount);
1083         PresaleTokensClaimed(tokensAmount);
1084     }
1085 
1086     /**
1087     @notice Transfer issued tokens to the investor.
1088     */
1089     function assignTokens(address _from, address _receiver, uint _tokenAmount) private {
1090         token.transferFrom(_from, _receiver, _tokenAmount);
1091     }
1092 }