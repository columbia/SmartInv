1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
10         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (_a == 0) {
14             return 0;
15         }
16 
17         c = _a * _b;
18         assert(c / _a == _b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         // assert(_b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = _a / _b;
28         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29         return _a / _b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
36         assert(_b <= _a);
37         return _a - _b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
44         c = _a + _b;
45         assert(c >= _a);
46         return c;
47     }
48 }
49 
50 contract Ownable {
51     address public owner;
52 
53 
54     event OwnershipRenounced(address indexed previousOwner);
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     constructor() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to relinquish control of the contract.
79      * @notice Renouncing to ownership will leave the contract without an owner.
80      * It will not be possible to call the functions with the `onlyOwner`
81      * modifier anymore.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipRenounced(owner);
85         owner = address(0);
86     }
87 
88     /**
89      * @dev Allows the current owner to transfer control of the contract to a newOwner.
90      * @param _newOwner The address to transfer ownership to.
91      */
92     function transferOwnership(address _newOwner) public onlyOwner {
93         _transferOwnership(_newOwner);
94     }
95 
96     /**
97      * @dev Transfers control of the contract to a newOwner.
98      * @param _newOwner The address to transfer ownership to.
99      */
100     function _transferOwnership(address _newOwner) internal {
101         require(_newOwner != address(0));
102         emit OwnershipTransferred(owner, _newOwner);
103         owner = _newOwner;
104     }
105 }
106 
107 contract Pausable is Ownable {
108     event Pause();
109     event Unpause();
110 
111     bool public paused = false;
112 
113 
114     /**
115      * @dev Modifier to make a function callable only when the contract is not paused.
116      */
117     modifier whenNotPaused() {
118         require(!paused);
119         _;
120     }
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is paused.
124      */
125     modifier whenPaused() {
126         require(paused);
127         _;
128     }
129 
130     /**
131      * @dev called by the owner to pause, triggers stopped state
132      */
133     function pause() public onlyOwner whenNotPaused {
134         paused = true;
135         emit Pause();
136     }
137 
138     /**
139      * @dev called by the owner to unpause, returns to normal state
140      */
141     function unpause() public onlyOwner whenPaused {
142         paused = false;
143         emit Unpause();
144     }
145 }
146 
147 contract ERC20Basic {
148     function totalSupply() public view returns (uint256);
149 
150     function balanceOf(address _who) public view returns (uint256);
151 
152     function transfer(address _to, uint256 _value) public returns (bool);
153 
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 }
156 
157 contract ERC20 is ERC20Basic {
158     function allowance(address _owner, address _spender)
159     public view returns (uint256);
160 
161     function transferFrom(address _from, address _to, uint256 _value)
162     public returns (bool);
163 
164     function approve(address _spender, uint256 _value) public returns (bool);
165 
166     event Approval(
167         address indexed owner,
168         address indexed spender,
169         uint256 value
170     );
171 }
172 
173 library SafeERC20 {
174     function safeTransfer(
175         ERC20Basic _token,
176         address _to,
177         uint256 _value
178     )
179     internal
180     {
181         require(_token.transfer(_to, _value));
182     }
183 
184     function safeTransferFrom(
185         ERC20 _token,
186         address _from,
187         address _to,
188         uint256 _value
189     )
190     internal
191     {
192         require(_token.transferFrom(_from, _to, _value));
193     }
194 
195     function safeApprove(
196         ERC20 _token,
197         address _spender,
198         uint256 _value
199     )
200     internal
201     {
202         require(_token.approve(_spender, _value));
203     }
204 }
205 
206 contract BasicToken is ERC20Basic {
207     using SafeMath for uint256;
208 
209     mapping(address => uint256) internal balances;
210 
211     uint256 internal totalSupply_;
212 
213     /**
214     * @dev Total number of tokens in existence
215     */
216     function totalSupply() public view returns (uint256) {
217         return totalSupply_;
218     }
219 
220     /**
221     * @dev Transfer token for a specified address
222     * @param _to The address to transfer to.
223     * @param _value The amount to be transferred.
224     */
225     function transfer(address _to, uint256 _value) public returns (bool) {
226         require(_value <= balances[msg.sender]);
227         require(_to != address(0));
228 
229         balances[msg.sender] = balances[msg.sender].sub(_value);
230         balances[_to] = balances[_to].add(_value);
231         emit Transfer(msg.sender, _to, _value);
232         return true;
233     }
234 
235     /**
236     * @dev Gets the balance of the specified address.
237     * @param _owner The address to query the the balance of.
238     * @return An uint256 representing the amount owned by the passed address.
239     */
240     function balanceOf(address _owner) public view returns (uint256) {
241         return balances[_owner];
242     }
243 
244 }
245 
246 contract StandardToken is ERC20, BasicToken {
247 
248     mapping(address => mapping(address => uint256)) internal allowed;
249 
250 
251     /**
252      * @dev Transfer tokens from one address to another
253      * @param _from address The address which you want to send tokens from
254      * @param _to address The address which you want to transfer to
255      * @param _value uint256 the amount of tokens to be transferred
256      */
257     function transferFrom(
258         address _from,
259         address _to,
260         uint256 _value
261     )
262     public
263     returns (bool)
264     {
265         require(_value <= balances[_from]);
266         require(_value <= allowed[_from][msg.sender]);
267         require(_to != address(0));
268 
269         balances[_from] = balances[_from].sub(_value);
270         balances[_to] = balances[_to].add(_value);
271         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
272         emit Transfer(_from, _to, _value);
273         return true;
274     }
275 
276     /**
277      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278      * Beware that changing an allowance with this method brings the risk that someone may use both the old
279      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282      * @param _spender The address which will spend the funds.
283      * @param _value The amount of tokens to be spent.
284      */
285     function approve(address _spender, uint256 _value) public returns (bool) {
286         allowed[msg.sender][_spender] = _value;
287         emit Approval(msg.sender, _spender, _value);
288         return true;
289     }
290 
291     /**
292      * @dev Function to check the amount of tokens that an owner allowed to a spender.
293      * @param _owner address The address which owns the funds.
294      * @param _spender address The address which will spend the funds.
295      * @return A uint256 specifying the amount of tokens still available for the spender.
296      */
297     function allowance(
298         address _owner,
299         address _spender
300     )
301     public
302     view
303     returns (uint256)
304     {
305         return allowed[_owner][_spender];
306     }
307 
308     /**
309      * @dev Increase the amount of tokens that an owner allowed to a spender.
310      * approve should be called when allowed[_spender] == 0. To increment
311      * allowed value is better to use this function to avoid 2 calls (and wait until
312      * the first transaction is mined)
313      * From MonolithDAO Token.sol
314      * @param _spender The address which will spend the funds.
315      * @param _addedValue The amount of tokens to increase the allowance by.
316      */
317     function increaseApproval(
318         address _spender,
319         uint256 _addedValue
320     )
321     public
322     returns (bool)
323     {
324         allowed[msg.sender][_spender] = (
325         allowed[msg.sender][_spender].add(_addedValue));
326         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327         return true;
328     }
329 
330     /**
331      * @dev Decrease the amount of tokens that an owner allowed to a spender.
332      * approve should be called when allowed[_spender] == 0. To decrement
333      * allowed value is better to use this function to avoid 2 calls (and wait until
334      * the first transaction is mined)
335      * From MonolithDAO Token.sol
336      * @param _spender The address which will spend the funds.
337      * @param _subtractedValue The amount of tokens to decrease the allowance by.
338      */
339     function decreaseApproval(
340         address _spender,
341         uint256 _subtractedValue
342     )
343     public
344     returns (bool)
345     {
346         uint256 oldValue = allowed[msg.sender][_spender];
347         if (_subtractedValue >= oldValue) {
348             allowed[msg.sender][_spender] = 0;
349         } else {
350             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
351         }
352         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353         return true;
354     }
355 
356 }
357 
358 contract DetailedERC20 is ERC20 {
359     string public name;
360     string public symbol;
361     uint8 public decimals;
362 
363     constructor(string _name, string _symbol, uint8 _decimals) public {
364         name = _name;
365         symbol = _symbol;
366         decimals = _decimals;
367     }
368 }
369 
370 contract MultiSigWallet {
371     uint constant public MAX_OWNER_COUNT = 50;
372 
373     event Confirmation(address indexed sender, uint indexed transactionId);
374     event Revocation(address indexed sender, uint indexed transactionId);
375     event Submission(uint indexed transactionId);
376     event Execution(uint indexed transactionId);
377     event ExecutionFailure(uint indexed transactionId);
378     event Deposit(address indexed sender, uint value);
379     event OwnerAddition(address indexed owner);
380     event OwnerRemoval(address indexed owner);
381     event RequirementChange(uint required);
382 
383     mapping(uint => Transaction) public transactions;
384     mapping(uint => mapping(address => bool)) public confirmations;
385     mapping(address => bool) public isOwner;
386 
387     address[] public owners;
388     uint public required;
389     uint public transactionCount;
390 
391     struct Transaction {
392         address destination;
393         uint value;
394         bytes data;
395         bool executed;
396     }
397 
398     modifier onlyWallet() {
399         require(msg.sender == address(this));
400         _;
401     }
402 
403     modifier ownerDoesNotExist(address owner) {
404         require(!isOwner[owner]);
405         _;
406     }
407 
408     modifier ownerExists(address owner) {
409         require(isOwner[owner]);
410         _;
411     }
412 
413     modifier transactionExists(uint transactionId) {
414         require(transactions[transactionId].destination != 0);
415         _;
416     }
417 
418     modifier confirmed(uint transactionId, address owner) {
419         require(confirmations[transactionId][owner]);
420         _;
421     }
422 
423     modifier notConfirmed(uint transactionId, address owner) {
424         require(!confirmations[transactionId][owner]);
425         _;
426     }
427 
428     modifier notExecuted(uint transactionId) {
429         require(!transactions[transactionId].executed);
430         _;
431     }
432 
433     modifier notNull(address _address) {
434         require(_address != address(0));
435         _;
436     }
437 
438     modifier validRequirement(uint ownerCount, uint _required) {
439         bool ownerValid = ownerCount <= MAX_OWNER_COUNT;
440         bool ownerNotZero = ownerCount != 0;
441         bool requiredValid = _required <= ownerCount;
442         bool requiredNotZero = _required != 0;
443         require(ownerValid && ownerNotZero && requiredValid && requiredNotZero);
444         _;
445     }
446 
447     /// @dev Fallback function allows to deposit ether.
448     function() payable public {
449         fallback();
450     }
451 
452     function fallback() payable public {
453         if (msg.value > 0) {
454             emit Deposit(msg.sender, msg.value);
455         }
456     }
457 
458     /*
459      * Public functions
460      */
461     /// @dev Contract constructor sets initial owners and required number of confirmations.
462     /// @param _owners List of initial owners.
463     /// @param _required Number of required confirmations.
464     constructor(
465         address[] _owners,
466         uint _required
467     ) public validRequirement(_owners.length, _required)
468     {
469         for (uint i = 0; i < _owners.length; i++) {
470             require(!isOwner[_owners[i]] && _owners[i] != 0);
471             isOwner[_owners[i]] = true;
472         }
473         owners = _owners;
474         required = _required;
475     }
476 
477     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
478     /// @param owner Address of new owner.
479     function addOwner(address owner)
480     public
481     onlyWallet
482     ownerDoesNotExist(owner)
483     notNull(owner)
484     validRequirement(owners.length + 1, required)
485     {
486         isOwner[owner] = true;
487         owners.push(owner);
488         emit OwnerAddition(owner);
489     }
490 
491     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
492     /// @param owner Address of owner.
493     function removeOwner(address owner)
494     public
495     onlyWallet
496     ownerExists(owner)
497     {
498         isOwner[owner] = false;
499         for (uint i = 0; i < owners.length - 1; i++)
500             if (owners[i] == owner) {
501                 owners[i] = owners[owners.length - 1];
502                 break;
503             }
504         owners.length -= 1;
505         if (required > owners.length)
506             changeRequirement(owners.length);
507         emit OwnerRemoval(owner);
508     }
509 
510     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
511     /// @param owner Address of owner to be replaced.
512     /// @param newOwner Address of new owner.
513     function replaceOwner(address owner, address newOwner)
514     public
515     onlyWallet
516     ownerExists(owner)
517     ownerDoesNotExist(newOwner)
518     {
519         for (uint i = 0; i < owners.length; i++)
520             if (owners[i] == owner) {
521                 owners[i] = newOwner;
522                 break;
523             }
524         isOwner[owner] = false;
525         isOwner[newOwner] = true;
526         emit OwnerRemoval(owner);
527         emit OwnerAddition(newOwner);
528     }
529 
530     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
531     /// @param _required Number of required confirmations.
532     function changeRequirement(uint _required)
533     public
534     onlyWallet
535     validRequirement(owners.length, _required)
536     {
537         required = _required;
538         emit RequirementChange(_required);
539     }
540 
541     /// @dev Allows an owner to submit and confirm a transaction.
542     /// @param destination Transaction target address.
543     /// @param value Transaction ether value.
544     /// @param data Transaction data payload.
545     /// @return Returns transaction ID.
546     function submitTransaction(address destination, uint value, bytes data)
547     public
548     returns (uint transactionId)
549     {
550         transactionId = addTransaction(destination, value, data);
551         confirmTransaction(transactionId);
552     }
553 
554     /// @dev Allows an owner to confirm a transaction.
555     /// @param transactionId Transaction ID.
556     function confirmTransaction(uint transactionId)
557     public
558     ownerExists(msg.sender)
559     transactionExists(transactionId)
560     notConfirmed(transactionId, msg.sender)
561     {
562         confirmations[transactionId][msg.sender] = true;
563         emit Confirmation(msg.sender, transactionId);
564         executeTransaction(transactionId);
565     }
566 
567     /// @dev Allows an owner to revoke a confirmation for a transaction.
568     /// @param transactionId Transaction ID.
569     function revokeConfirmation(uint transactionId)
570     public
571     ownerExists(msg.sender)
572     confirmed(transactionId, msg.sender)
573     notExecuted(transactionId)
574     {
575         confirmations[transactionId][msg.sender] = false;
576         emit Revocation(msg.sender, transactionId);
577     }
578 
579     /// @dev Allows anyone to execute a confirmed transaction.
580     /// @param transactionId Transaction ID.
581     function executeTransaction(uint transactionId)
582     public
583     ownerExists(msg.sender)
584     confirmed(transactionId, msg.sender)
585     notExecuted(transactionId)
586     {
587         if (isConfirmed(transactionId)) {
588             Transaction storage txn = transactions[transactionId];
589             txn.executed = true;
590             if (txn.destination.call.value(txn.value)(txn.data))
591                 emit Execution(transactionId);
592             else {
593                 emit ExecutionFailure(transactionId);
594                 txn.executed = false;
595             }
596         }
597     }
598 
599     /// @dev Returns the confirmation status of a transaction.
600     /// @param transactionId Transaction ID.
601     /// @return Confirmation status.
602     function isConfirmed(uint transactionId) public view returns (bool) {
603         uint count = 0;
604         for (uint i = 0; i < owners.length; i++) {
605             if (confirmations[transactionId][owners[i]])
606                 count += 1;
607             if (count == required)
608                 return true;
609         }
610     }
611 
612     /*
613      * Internal functions
614      */
615     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
616     /// @param destination Transaction target address.
617     /// @param value Transaction ether value.
618     /// @param data Transaction data payload.
619     /// @return Returns transaction ID.
620     function addTransaction(address destination, uint value, bytes data)
621     internal
622     notNull(destination)
623     returns (uint transactionId)
624     {
625         transactionId = transactionCount;
626         transactions[transactionId] = Transaction({
627             destination : destination,
628             value : value,
629             data : data,
630             executed : false
631             });
632         transactionCount += 1;
633         emit Submission(transactionId);
634     }
635 
636     /*
637      * Web3 call functions
638      */
639     /// @dev Returns number of confirmations of a transaction.
640     /// @param transactionId Transaction ID.
641     /// @return Number of confirmations.
642     function getConfirmationCount(uint transactionId) public view returns (uint count) {
643         for (uint i = 0; i < owners.length; i++) {
644             if (confirmations[transactionId][owners[i]]) {
645                 count += 1;
646             }
647         }
648     }
649 
650     /// @dev Returns total number of transactions after filers are applied.
651     /// @param pending Include pending transactions.
652     /// @param executed Include executed transactions.
653     /// @return Total number of transactions after filters are applied.
654     function getTransactionCount(
655         bool pending,
656         bool executed
657     ) public view returns (uint count) {
658         for (uint i = 0; i < transactionCount; i++) {
659             if (pending &&
660                 !transactions[i].executed ||
661                 executed &&
662                 transactions[i].executed
663             ) {
664                 count += 1;
665             }
666         }
667     }
668 
669     /// @dev Returns list of owners.
670     /// @return List of owner addresses.
671     function getOwners() public view returns (address[]) {
672         return owners;
673     }
674 
675     /// @dev Returns array with owner addresses, which confirmed transaction.
676     /// @param transactionId Transaction ID.
677     /// @return Returns array of owner addresses.
678     function getConfirmations(
679         uint transactionId
680     ) public view returns (address[] _confirmations) {
681         address[] memory confirmationsTemp = new address[](owners.length);
682         uint count = 0;
683         uint i;
684         for (i = 0; i < owners.length; i++)
685             if (confirmations[transactionId][owners[i]]) {
686                 confirmationsTemp[count] = owners[i];
687                 count += 1;
688             }
689         _confirmations = new address[](count);
690         for (i = 0; i < count; i++)
691             _confirmations[i] = confirmationsTemp[i];
692     }
693 
694     /// @dev Returns list of transaction IDs in defined range.
695     /// @param from Index start position of transaction array.
696     /// @param to Index end position of transaction array.
697     /// @param pending Include pending transactions.
698     /// @param executed Include executed transactions.
699     /// @return Returns array of transaction IDs.
700     function getTransactionIds(
701         uint from,
702         uint to,
703         bool pending,
704         bool executed
705     ) public view returns (uint[] _transactionIds) {
706         uint[] memory transactionIdsTemp = new uint[](transactionCount);
707         uint count = 0;
708         uint i;
709         for (i = 0; i < transactionCount; i++)
710             if (pending &&
711                 !transactions[i].executed ||
712                 executed &&
713                 transactions[i].executed
714             ) {
715                 transactionIdsTemp[count] = i;
716                 count += 1;
717             }
718         _transactionIds = new uint[](to - from);
719         for (i = from; i < to; i++)
720             _transactionIds[i - from] = transactionIdsTemp[i];
721     }
722 }
723 
724 contract JavvyMultiSig is MultiSigWallet {
725     constructor(
726         address[] _owners,
727         uint _required
728     )
729     MultiSigWallet(_owners, _required)
730     public {}
731 }
732 
733 contract Config {
734     uint256 public constant jvySupply = 333333333333333;
735     uint256 public constant bonusSupply = 83333333333333;
736     uint256 public constant saleSupply = 250000000000000;
737     uint256 public constant hardCapUSD = 8000000;
738 
739     uint256 public constant preIcoBonus = 25;
740     uint256 public constant minimalContributionAmount = 0.4 ether;
741 
742     function getStartPreIco() public view returns (uint256) {
743         // solium-disable-next-line security/no-block-members
744         uint256 _preIcoStartTime = block.timestamp + 1 minutes;
745         return _preIcoStartTime;
746     }
747 
748     function getStartIco() public view returns (uint256) {
749         // uint256 _icoStartTime = 1543554000;
750         // solium-disable-next-line security/no-block-members
751         uint256 _icoStartTime = block.timestamp + 2 minutes;
752         return _icoStartTime;
753     }
754 
755     function getEndIco() public view returns (uint256) {
756         // solium-disable-next-line security/no-block-members
757         // uint256 _icoEndTime = block.timestamp + 50 days;
758         // uint256 _icoEndTime = 1551416400;
759         uint256 _icoEndTime = 1567209600;
760         return _icoEndTime;
761     }
762 }
763 
764 
765 contract JavvyToken is DetailedERC20, StandardToken, Ownable, Config {
766     address public crowdsaleAddress;
767     address public bonusAddress;
768     address public multiSigAddress;
769 
770     constructor(
771         string _name,
772         string _symbol,
773         uint8 _decimals
774     ) public
775     DetailedERC20(_name, _symbol, _decimals) {
776         require(
777             jvySupply == saleSupply + bonusSupply,
778             "Sum of provided supplies is not equal to declared total Javvy supply. Check config!"
779         );
780         totalSupply_ = tokenToDecimals(jvySupply);
781     }
782 
783     function initializeBalances(
784         address _crowdsaleAddress,
785         address _bonusAddress,
786         address _multiSigAddress
787     ) public
788     onlyOwner() {
789         crowdsaleAddress = _crowdsaleAddress;
790         bonusAddress = _bonusAddress;
791         multiSigAddress = _multiSigAddress;
792 
793         _initializeBalance(_crowdsaleAddress, saleSupply);
794         _initializeBalance(_bonusAddress, bonusSupply);
795     }
796 
797     function _initializeBalance(address _address, uint256 _supply) private {
798         require(_address != address(0), "Address cannot be equal to 0x0!");
799         require(_supply != 0, "Supply cannot be equal to 0!");
800         balances[_address] = tokenToDecimals(_supply);
801         emit Transfer(address(0), _address, _supply);
802     }
803 
804     function tokenToDecimals(uint256 _amount) private pure returns (uint256){
805         // NOTE for additional accuracy, we're using 6 decimal places in supply
806         return _amount * (10 ** 12);
807     }
808 
809     function getRemainingSaleTokens() external view returns (uint256) {
810         return balanceOf(crowdsaleAddress);
811     }
812 
813 }
814 
815 contract Escrow is Ownable {
816     using SafeMath for uint256;
817 
818     event Deposited(address indexed payee, uint256 weiAmount);
819     event Withdrawn(address indexed payee, uint256 weiAmount);
820 
821     mapping(address => uint256) private deposits;
822 
823     function depositsOf(address _payee) public view returns (uint256) {
824         return deposits[_payee];
825     }
826 
827     /**
828     * @dev Stores the sent amount as credit to be withdrawn.
829     * @param _payee The destination address of the funds.
830     */
831     function deposit(address _payee) public onlyOwner payable {
832         uint256 amount = msg.value;
833         deposits[_payee] = deposits[_payee].add(amount);
834 
835         emit Deposited(_payee, amount);
836     }
837 
838     /**
839     * @dev Withdraw accumulated balance for a payee.
840     * @param _payee The address whose funds will be withdrawn and transferred to.
841     */
842     function withdraw(address _payee) public onlyOwner {
843         uint256 payment = deposits[_payee];
844         assert(address(this).balance >= payment);
845 
846         deposits[_payee] = 0;
847 
848         _payee.transfer(payment);
849 
850         emit Withdrawn(_payee, payment);
851     }
852 }
853 
854 contract ConditionalEscrow is Escrow {
855     /**
856     * @dev Returns whether an address is allowed to withdraw their funds. To be
857     * implemented by derived contracts.
858     * @param _payee The destination address of the funds.
859     */
860     function withdrawalAllowed(address _payee) public view returns (bool);
861 
862     function withdraw(address _payee) public {
863         require(withdrawalAllowed(_payee));
864         super.withdraw(_payee);
865     }
866 }
867 
868 contract RefundEscrow is Ownable, ConditionalEscrow {
869     enum State {Active, Refunding, Closed}
870 
871     event Closed();
872     event RefundsEnabled();
873 
874     State public state;
875     address public beneficiary;
876 
877     /**
878      * @dev Constructor.
879      * @param _beneficiary The beneficiary of the deposits.
880      */
881     constructor(address _beneficiary) public {
882         require(_beneficiary != address(0));
883         beneficiary = _beneficiary;
884         state = State.Active;
885     }
886 
887     /**
888      * @dev Stores funds that may later be refunded.
889      * @param _refundee The address funds will be sent to if a refund occurs.
890      */
891     function deposit(address _refundee) public payable {
892         require(state == State.Active);
893         super.deposit(_refundee);
894     }
895 
896     /**
897      * @dev Allows for the beneficiary to withdraw their funds, rejecting
898      * further deposits.
899      */
900     function close() public onlyOwner {
901         require(state == State.Active);
902         state = State.Closed;
903         emit Closed();
904     }
905 
906     /**
907      * @dev Allows for refunds to take place, rejecting further deposits.
908      */
909     function enableRefunds() public onlyOwner {
910         require(state == State.Active);
911         state = State.Refunding;
912         emit RefundsEnabled();
913     }
914 
915     /**
916      * @dev Withdraws the beneficiary's funds.
917      */
918     function beneficiaryWithdraw() public {
919         require(state == State.Closed);
920         beneficiary.transfer(address(this).balance);
921     }
922 
923     /**
924      * @dev Returns whether refundees can withdraw their deposits (be refunded).
925      */
926     function withdrawalAllowed(address _payee) public view returns (bool) {
927         return state == State.Refunding;
928     }
929 }
930 
931 contract Crowdsale {
932     using SafeMath for uint256;
933     using SafeERC20 for ERC20;
934 
935     // The token being sold
936     ERC20 public token;
937 
938     // Address where funds are collected
939     address public wallet;
940 
941     // How many token units a buyer gets per wei.
942     // The rate is the conversion between wei and the smallest and indivisible token unit.
943     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
944     // 1 wei will give you 1 unit, or 0.001 TOK.
945     uint256 public rate;
946 
947     // Amount of wei raised
948     uint256 public weiRaised;
949 
950     /**
951      * Event for token purchase logging
952      * @param purchaser who paid for the tokens
953      * @param beneficiary who got the tokens
954      * @param value weis paid for purchase
955      * @param amount amount of tokens purchased
956      */
957     event TokenPurchase(
958         address indexed purchaser,
959         address indexed beneficiary,
960         uint256 value,
961         uint256 amount
962     );
963 
964     /**
965      * @param _rate Number of token units a buyer gets per wei
966      * @param _wallet Address where collected funds will be forwarded to
967      * @param _token Address of the token being sold
968      */
969     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
970         require(_rate > 0);
971         require(_wallet != address(0));
972         require(_token != address(0));
973 
974         rate = _rate;
975         wallet = _wallet;
976         token = _token;
977     }
978 
979     // -----------------------------------------
980     // Crowdsale external interface
981     // -----------------------------------------
982 
983     /**
984      * @dev fallback function ***DO NOT OVERRIDE***
985      */
986     function() external payable {
987         buyTokens(msg.sender);
988     }
989 
990     /**
991      * @dev low level token purchase ***DO NOT OVERRIDE***
992      * @param _beneficiary Address performing the token purchase
993      */
994     function buyTokens(address _beneficiary) public payable {
995 
996         uint256 weiAmount = msg.value;
997         _preValidatePurchase(_beneficiary, weiAmount);
998 
999         // calculate token amount to be created
1000         uint256 tokens = _getTokenAmount(weiAmount);
1001 
1002         // update state
1003         weiRaised = weiRaised.add(weiAmount);
1004 
1005         _processPurchase(_beneficiary, tokens);
1006         emit TokenPurchase(
1007             msg.sender,
1008             _beneficiary,
1009             weiAmount,
1010             tokens
1011         );
1012 
1013         _updatePurchasingState(_beneficiary, weiAmount);
1014 
1015         _forwardFunds();
1016         _postValidatePurchase(_beneficiary, weiAmount);
1017     }
1018 
1019     // -----------------------------------------
1020     // Internal interface (extensible)
1021     // -----------------------------------------
1022 
1023     /**
1024      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
1025      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
1026      *   super._preValidatePurchase(_beneficiary, _weiAmount);
1027      *   require(weiRaised.add(_weiAmount) <= cap);
1028      * @param _beneficiary Address performing the token purchase
1029      * @param _weiAmount Value in wei involved in the purchase
1030      */
1031     function _preValidatePurchase(
1032         address _beneficiary,
1033         uint256 _weiAmount
1034     )
1035     internal
1036     {
1037         require(_beneficiary != address(0));
1038         require(_weiAmount != 0);
1039     }
1040 
1041     /**
1042      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
1043      * @param _beneficiary Address performing the token purchase
1044      * @param _weiAmount Value in wei involved in the purchase
1045      */
1046     function _postValidatePurchase(
1047         address _beneficiary,
1048         uint256 _weiAmount
1049     )
1050     internal
1051     {
1052         // optional override
1053     }
1054 
1055     /**
1056      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
1057      * @param _beneficiary Address performing the token purchase
1058      * @param _tokenAmount Number of tokens to be emitted
1059      */
1060     function _deliverTokens(
1061         address _beneficiary,
1062         uint256 _tokenAmount
1063     )
1064     internal
1065     {
1066         token.safeTransfer(_beneficiary, _tokenAmount);
1067     }
1068 
1069     /**
1070      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1071      * @param _beneficiary Address receiving the tokens
1072      * @param _tokenAmount Number of tokens to be purchased
1073      */
1074     function _processPurchase(
1075         address _beneficiary,
1076         uint256 _tokenAmount
1077     )
1078     internal
1079     {
1080         _deliverTokens(_beneficiary, _tokenAmount);
1081     }
1082 
1083     /**
1084      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
1085      * @param _beneficiary Address receiving the tokens
1086      * @param _weiAmount Value in wei involved in the purchase
1087      */
1088     function _updatePurchasingState(
1089         address _beneficiary,
1090         uint256 _weiAmount
1091     )
1092     internal
1093     {
1094         // optional override
1095     }
1096 
1097     /**
1098      * @dev Override to extend the way in which ether is converted to tokens.
1099      * @param _weiAmount Value in wei to be converted into tokens
1100      * @return Number of tokens that can be purchased with the specified _weiAmount
1101      */
1102     function _getTokenAmount(uint256 _weiAmount)
1103     internal view returns (uint256)
1104     {
1105         return _weiAmount.mul(rate);
1106     }
1107 
1108     /**
1109      * @dev Determines how ETH is stored/forwarded on purchases.
1110      */
1111     function _forwardFunds() internal {
1112         wallet.transfer(msg.value);
1113     }
1114 }
1115 
1116 contract CappedCrowdsale is Crowdsale {
1117     using SafeMath for uint256;
1118 
1119     uint256 public cap;
1120 
1121     /**
1122      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1123      * @param _cap Max amount of wei to be contributed
1124      */
1125     constructor(uint256 _cap) public {
1126         require(_cap > 0);
1127         cap = _cap;
1128     }
1129 
1130     /**
1131      * @dev Checks whether the cap has been reached.
1132      * @return Whether the cap was reached
1133      */
1134     function capReached() public view returns (bool) {
1135         return weiRaised >= cap;
1136     }
1137 
1138     /**
1139      * @dev Extend parent behavior requiring purchase to respect the funding cap.
1140      * @param _beneficiary Token purchaser
1141      * @param _weiAmount Amount of wei contributed
1142      */
1143     function _preValidatePurchase(
1144         address _beneficiary,
1145         uint256 _weiAmount
1146     )
1147     internal
1148     {
1149         super._preValidatePurchase(_beneficiary, _weiAmount);
1150         require(weiRaised.add(_weiAmount) <= cap);
1151     }
1152 
1153 }
1154 
1155 contract TimedCrowdsale is Crowdsale {
1156     using SafeMath for uint256;
1157 
1158     uint256 public openingTime;
1159     uint256 public closingTime;
1160 
1161     /**
1162      * @dev Reverts if not in crowdsale time range.
1163      */
1164     modifier onlyWhileOpen {
1165         // solium-disable-next-line security/no-block-members
1166         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1167         _;
1168     }
1169 
1170     /**
1171      * @dev Constructor, takes crowdsale opening and closing times.
1172      * @param _openingTime Crowdsale opening time
1173      * @param _closingTime Crowdsale closing time
1174      */
1175     constructor(uint256 _openingTime, uint256 _closingTime) public {
1176         // solium-disable-next-line security/no-block-members
1177         require(_openingTime >= block.timestamp);
1178         require(_closingTime >= _openingTime);
1179 
1180         openingTime = _openingTime;
1181         closingTime = _closingTime;
1182     }
1183 
1184     /**
1185      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1186      * @return Whether crowdsale period has elapsed
1187      */
1188     function hasClosed() public view returns (bool) {
1189         // solium-disable-next-line security/no-block-members
1190         return block.timestamp > closingTime;
1191     }
1192 
1193     /**
1194      * @dev Extend parent behavior requiring to be within contributing period
1195      * @param _beneficiary Token purchaser
1196      * @param _weiAmount Amount of wei contributed
1197      */
1198     function _preValidatePurchase(
1199         address _beneficiary,
1200         uint256 _weiAmount
1201     )
1202     internal
1203     onlyWhileOpen
1204     {
1205         super._preValidatePurchase(_beneficiary, _weiAmount);
1206     }
1207 
1208 }
1209 
1210 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
1211     using SafeMath for uint256;
1212 
1213     bool public isFinalized = false;
1214 
1215     event Finalized();
1216 
1217     /**
1218      * @dev Must be called after crowdsale ends, to do some extra finalization
1219      * work. Calls the contract's finalization function.
1220      */
1221     function finalize() public onlyOwner {
1222         require(!isFinalized);
1223         require(hasClosed());
1224 
1225         finalization();
1226         emit Finalized();
1227 
1228         isFinalized = true;
1229     }
1230 
1231     /**
1232      * @dev Can be overridden to add finalization logic. The overriding function
1233      * should call super.finalization() to ensure the chain of finalization is
1234      * executed entirely.
1235      */
1236     function finalization() internal {
1237     }
1238 
1239 }
1240 
1241 contract RefundableCrowdsale is FinalizableCrowdsale {
1242     using SafeMath for uint256;
1243 
1244     // minimum amount of funds to be raised in weis
1245     uint256 public goal;
1246 
1247     // refund escrow used to hold funds while crowdsale is running
1248     RefundEscrow private escrow;
1249 
1250     /**
1251      * @dev Constructor, creates RefundEscrow.
1252      * @param _goal Funding goal
1253      */
1254     constructor(uint256 _goal) public {
1255         require(_goal > 0);
1256         escrow = new RefundEscrow(wallet);
1257         goal = _goal;
1258     }
1259 
1260     /**
1261      * @dev Investors can claim refunds here if crowdsale is unsuccessful
1262      */
1263     function claimRefund() public {
1264         require(isFinalized);
1265         require(!goalReached());
1266 
1267         escrow.withdraw(msg.sender);
1268     }
1269 
1270     /**
1271      * @dev Checks whether funding goal was reached.
1272      * @return Whether funding goal was reached
1273      */
1274     function goalReached() public view returns (bool) {
1275         return weiRaised >= goal;
1276     }
1277 
1278     /**
1279      * @dev escrow finalization task, called when owner calls finalize()
1280      */
1281     function finalization() internal {
1282         if (goalReached()) {
1283             escrow.close();
1284             escrow.beneficiaryWithdraw();
1285         } else {
1286             escrow.enableRefunds();
1287         }
1288 
1289         super.finalization();
1290     }
1291 
1292     /**
1293      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1294      */
1295     function _forwardFunds() internal {
1296         escrow.deposit.value(msg.value)(msg.sender);
1297     }
1298 
1299 }
1300 
1301 contract JavvyCrowdsale is RefundableCrowdsale, CappedCrowdsale, Pausable, Config {
1302     uint256 public icoStartTime;
1303     address public transminingAddress;
1304     address public bonusAddress;
1305     uint256 private USDETHRate;
1306 
1307     mapping(address => bool) public blacklisted;
1308 
1309     JavvyToken token;
1310 
1311     enum Stage {
1312         NotStarted,
1313         PreICO,
1314         ICO,
1315         AfterICO
1316     }
1317 
1318     function getStage() public view returns (Stage) {
1319         // solium-disable-next-line security/no-block-members
1320         uint256 blockTime = block.timestamp;
1321         if (blockTime < openingTime) return Stage.NotStarted;
1322         if (blockTime < icoStartTime) return Stage.PreICO;
1323         if (blockTime < closingTime) return Stage.ICO;
1324         else return Stage.AfterICO;
1325     }
1326 
1327     constructor(
1328         uint256 _rate,
1329         JavvyMultiSig _wallet,
1330         JavvyToken _token,
1331     // Should be equal to cap = hardCapUSD * USDETHInitialRate;
1332     // 8000000 * 7692307692307692 = 61538461538461536000000
1333         uint256 _cap,
1334         uint256 _goal,
1335         address _bonusAddress,
1336         address[] _blacklistAddresses,
1337         uint256 _USDETHRate
1338     )
1339     Crowdsale(_rate, _wallet, _token)
1340     CappedCrowdsale(_cap)
1341     TimedCrowdsale(getStartPreIco(), getEndIco())
1342     RefundableCrowdsale(_goal)
1343     public {
1344         // require(_cap == _USDETHRate.mul(hardCapUSD), "Hard cap is not equal to formula");
1345         require(getStartIco() > block.timestamp, "ICO has to begin in the future");
1346         require(getEndIco() > block.timestamp, "ICO has to end in the future");
1347         require(_goal <= _cap, "Soft cap should be equal or smaller than hard cap");
1348         icoStartTime = getStartIco();
1349         bonusAddress = _bonusAddress;
1350         token = _token;
1351         for (uint256 i = 0; i < _blacklistAddresses.length; i++) {
1352             blacklisted[_blacklistAddresses[i]] = true;
1353         }
1354         setUSDETHRate(_USDETHRate);
1355         // TODO: Don't forgot about this when deploying
1356         // TODO: It's set to continue old ICO
1357         weiRaised = 46461161522138564065713;
1358     }
1359 
1360     function buyTokens(address _beneficiary) public payable {
1361         require(!blacklisted[msg.sender], "Sender is blacklisted");
1362         bool preallocated = false;
1363         uint256 preallocatedTokens = 0;
1364 
1365         _buyTokens(
1366             _beneficiary,
1367             msg.sender,
1368             msg.value,
1369             preallocated,
1370             preallocatedTokens
1371         );
1372     }
1373 
1374     function bulkPreallocate(address[] _owners, uint256[] _tokens, uint256[] _paid)
1375     public
1376     onlyOwner() {
1377         require(
1378             _owners.length == _tokens.length,
1379             "Lengths of parameter lists have to be equal"
1380         );
1381         require(
1382             _owners.length == _paid.length,
1383             "Lengths of parameter lists have to be equal"
1384         );
1385         for (uint256 i = 0; i < _owners.length; i++) {
1386             preallocate(_owners[i], _tokens[i], _paid[i]);
1387         }
1388     }
1389 
1390     function preallocate(address _owner, uint256 _tokens, uint256 _paid)
1391     public
1392     onlyOwner() {
1393         require(!blacklisted[_owner], "Address where tokens will be sent is blacklisted");
1394         bool preallocated = true;
1395         uint256 preallocatedTokens = _tokens;
1396 
1397         _buyTokens(
1398             _owner,
1399             _owner,
1400             _paid,
1401             preallocated,
1402             preallocatedTokens
1403         );
1404     }
1405 
1406     function setTransminingAddress(address _transminingAddress) public
1407     onlyOwner() {
1408         transminingAddress = _transminingAddress;
1409     }
1410 
1411     // Created for moving funds later to transmining address
1412     function moveTokensToTransmining(uint256 _amount) public
1413     onlyOwner() {
1414         uint256 remainingTokens = token.getRemainingSaleTokens();
1415         require(
1416             transminingAddress != address(0),
1417             "Transmining address must be set!"
1418         );
1419         require(
1420             remainingTokens >= _amount,
1421             "Balance of remaining tokens for sale is smaller than requested amount for trans-mining"
1422         );
1423         uint256 weiNeeded = cap - weiRaised;
1424         uint256 tokensNeeded = weiNeeded * rate;
1425 
1426         if (getStage() != Stage.AfterICO) {
1427             require(remainingTokens - _amount > tokensNeeded, "You need to leave enough tokens to reach hard cap");
1428         }
1429         _deliverTokens(transminingAddress, _amount, this);
1430     }
1431 
1432     function _buyTokens(
1433         address _beneficiary,
1434         address _sender,
1435         uint256 _value,
1436         bool _preallocated,
1437         uint256 _tokens
1438     ) internal
1439     whenNotPaused() {
1440         uint256 tokens;
1441 
1442         if (!_preallocated) {
1443             // pre validate params
1444             require(
1445                 _value >= minimalContributionAmount,
1446                 "Amount contributed should be greater than required minimal contribution"
1447             );
1448             require(_tokens == 0, "Not preallocated tokens should be zero");
1449             _preValidatePurchase(_beneficiary, _value);
1450         } else {
1451             require(_tokens != 0, "Preallocated tokens should be greater than zero");
1452             require(weiRaised.add(_value) <= cap, "Raised tokens should not exceed hard cap");
1453         }
1454 
1455         // calculate tokens
1456         if (!_preallocated) {
1457             tokens = _getTokenAmount(_value);
1458         } else {
1459             tokens = _tokens;
1460         }
1461 
1462         // increase wei
1463         weiRaised = weiRaised.add(_value);
1464 
1465         _processPurchase(_beneficiary, tokens, this);
1466 
1467         emit TokenPurchase(
1468             _sender,
1469             _beneficiary,
1470             _value,
1471             tokens
1472         );
1473 
1474         // transfer payment
1475         _updatePurchasingState(_beneficiary, _value);
1476         _forwardFunds();
1477 
1478         // post validate
1479         if (!_preallocated) {
1480             _postValidatePurchase(_beneficiary, _value);
1481         }
1482     }
1483 
1484     function _getBaseTokens(uint256 _value) internal view returns (uint256) {
1485         return _value.mul(rate);
1486     }
1487 
1488     function _getTokenAmount(uint256 _weiAmount)
1489     internal view returns (uint256) {
1490         uint256 baseTokens = _getBaseTokens(_weiAmount);
1491         if (getStage() == Stage.PreICO) {
1492             return baseTokens.mul(100 + preIcoBonus).div(100);
1493         } else {
1494             return baseTokens;
1495         }
1496     }
1497 
1498     function _processPurchase(
1499         address _beneficiary,
1500         uint256 _tokenAmount,
1501         address _sourceAddress
1502     ) internal {
1503         _deliverTokens(_beneficiary, _tokenAmount, _sourceAddress);
1504     }
1505 
1506     function _deliverTokens(
1507         address _beneficiary,
1508         uint256 _tokenAmount,
1509         address _sourceAddress
1510     ) internal {
1511         if (_sourceAddress == address(this)) {
1512             token.transfer(_beneficiary, _tokenAmount);
1513         } else {
1514             token.transferFrom(_sourceAddress, _beneficiary, _tokenAmount);
1515         }
1516     }
1517 
1518     function finalization() internal {
1519         require(
1520             transminingAddress != address(0),
1521             "Transmining address must be set!"
1522         );
1523         super.finalization();
1524 
1525         _deliverTokens(transminingAddress, token.getRemainingSaleTokens(), this);
1526     }
1527 
1528     function setUSDETHRate(uint256 _USDETHRate) public
1529     onlyOwner() {
1530         require(_USDETHRate > 0, "USDETH rate should not be zero");
1531         USDETHRate = _USDETHRate;
1532         cap = hardCapUSD.mul(USDETHRate);
1533     }
1534 }