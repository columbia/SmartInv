1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /**
4 Author: Sik Jean Soon
5 **/
6 
7 /**
8  * @title SafeMath for uint256
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMathUint256 {
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         require(c / a == b, "Multiplier exception");
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a / b; // Solidity automatically throws when dividing by 0
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a, "Subtraction exception");
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         require(c >= a, "Addition exception");
45         return c;
46     }
47 
48     /**
49     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
50     * reverts when dividing by zero.
51     */
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0, "Modulo exception");
54         return a % b;
55     }
56 
57 }
58 
59 /**
60  * @title SafeMath for uint8
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMathUint8 {
64     /**
65     * @dev Multiplies two numbers, throws on overflow.
66     */
67     function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
68         if (a == 0) {
69             return 0;
70         }
71         c = a * b;
72         require(c / a == b, "Multiplier exception");
73         return c;
74     }
75 
76     /**
77     * @dev Integer division of two numbers, truncating the quotient.
78     */
79     function div(uint8 a, uint8 b) internal pure returns (uint8) {
80         return a / b; // Solidity automatically throws when dividing by 0
81     }
82 
83     /**
84     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85     */
86     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
87         require(b <= a, "Subtraction exception");
88         return a - b;
89     }
90 
91     /**
92     * @dev Adds two numbers, throws on overflow.
93     */
94     function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
95         c = a + b;
96         require(c >= a, "Addition exception");
97         return c;
98     }
99 
100     /**
101     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
102     * reverts when dividing by zero.
103     */
104     function mod(uint8 a, uint8 b) internal pure returns (uint8) {
105         require(b != 0, "Modulo exception");
106         return a % b;
107     }
108 
109 }
110 
111 contract Common {
112     bytes32 internal LABEL_CODE_STAKER;
113     bytes32 internal LABEL_CODE_STAKER_CONTROLLER;
114     bytes32 internal LABEL_CODE_SIGNER_CONTROLLER;
115     bytes32 internal LABEL_CODE_SIGNER;
116     bytes32 internal LABEL_CODE_BACKSYS;
117     bytes32 internal LABEL_CODE_OPS;
118 
119     uint8 constant internal MAX_WALLET = 64;
120     uint256 constant internal WALLET_FLAG_ALL = (2 ** (uint256(MAX_WALLET))) - 1;
121 
122     constructor() public
123     {
124         LABEL_CODE_STAKER = encodePacked("STAKER");
125         LABEL_CODE_STAKER_CONTROLLER = encodePacked("STAKER_CONTROLLER");
126         LABEL_CODE_SIGNER_CONTROLLER = encodePacked("SIGNER_CONTROLLER");
127         LABEL_CODE_SIGNER = encodePacked("SIGNER");
128         LABEL_CODE_BACKSYS = encodePacked("BACKSYS");
129         LABEL_CODE_OPS = encodePacked("OPS");
130     }
131 
132     function encodePacked(string memory s) internal pure
133         returns (bytes32)
134     {
135         return keccak256(abi.encodePacked(s));
136     }
137 
138     function convertBytesToBytes4(bytes memory _in) internal pure
139         returns (bytes4 out)
140     {
141         if (0 == _in.length)
142             return 0x0;
143 
144         assembly {
145             out := mload(add(_in, 32))
146         }
147     }
148 
149     function isContract(address _address) internal view
150         returns (bool)
151     {
152         uint32 size;
153         assembly {
154             size := extcodesize(_address)
155         }
156         return (0 < size);
157     }
158 
159 }
160 
161 contract Label is Common {
162     string public class;
163     string public label;
164     string public description;
165 
166     bytes32 public classCode;
167     bytes32 public labelCode;
168 
169     constructor(string memory _class, string memory _label, string memory _description) public
170     {
171         class = _class;        
172         label = _label;
173         description = _description;
174 
175         classCode = encodePacked(_class);
176         labelCode = encodePacked(_label);
177     }
178 
179 }
180 
181 
182 contract MultiSigNode is Label {
183     using SafeMathUint8 for uint8;
184 
185     address payable public root;
186     address public parent;
187 
188     // wallet index => wallet address
189     mapping(uint8 => address) public wallets;
190     // wallet address => wallet bit position
191     mapping(address => uint8) public walletsIndex;
192 
193     // Normal wallet
194     uint8 public walletCount;
195     // Total wallet = normal wallet + contract wallet
196     uint8 public totalWallet;
197 
198     modifier onlyRoot() {
199         require(msg.sender == root, "Node.onlyRoot: Access denied");
200         _;
201     }
202 
203     constructor(address payable _root, address[] memory _wallets, string memory _label, string memory _description) public
204         Label("NODE", _label, _description)
205     {
206         require(address(0) != _root, "Node: Root address is empty");
207         require(MAX_WALLET >= _wallets.length, "Node: Wallet list exceeded limit");
208 
209         root = _root;
210 
211         for (uint8 i = 1; _wallets.length >= i; i = i.add(1)) {
212             address wallet = _wallets[i.sub(1)];
213 
214             require(address(0) != wallet, "Node: Wallet address is empty");
215             require(0 == walletsIndex[wallet], "Node: Duplicated wallet address");
216 
217             wallets[i] = wallet;
218             walletsIndex[wallet] = i;
219 
220             if (!isContract(wallet))
221                 walletCount = walletCount.add(1);
222         }
223 
224         totalWallet = uint8(_wallets.length);
225     }
226 
227     function init(address _parent) external
228         onlyRoot
229     {
230         parent = _parent;
231 
232         if (0 < totalWallet) {
233             uint8 count = 0;
234 
235             for (uint8 i = 1; i <= MAX_WALLET && count <= totalWallet; i = i.add(1)) {
236                 address wallet = wallets[i];
237 
238                 if (address(0) != wallet) {
239                     count = count.add(1);
240 
241                     // Notify root this attached wallet, root will set parent address (if this is node)
242                     MultiSigRoot(root).attachWalletOrNode(wallet);
243                 }
244             }
245         }
246     }
247 
248     function term() external
249         onlyRoot
250     {
251         if (0 < totalWallet) {
252             uint8 count = 0;
253 
254             for (uint8 i = 1; i <= MAX_WALLET && count <= totalWallet; i = i.add(1)) {
255                 address wallet = wallets[i];
256 
257                 if (address(0) != wallet) {
258                     count = count.add(1);
259 
260                     // Notify root to remove this wallet from list
261                     MultiSigRoot(root).detachWalletOrNode(wallet);
262                 }
263             }
264         }
265     }
266 
267     function attach(uint8 _index, address _wallet) external
268         onlyRoot
269         returns (bool)
270     {
271         require(0 < _index && MAX_WALLET >= _index, "Node.attach: Index out of range");
272         require(address(0) != _wallet, "Node.attach: Wallet address is empty");
273         require(0 == walletsIndex[_wallet], "Node.attach: Duplicated wallet address");
274 
275         if (address(0) != wallets[_index])
276             detach(wallets[_index]);
277 
278         walletsIndex[_wallet] = _index;
279         wallets[_index] = _wallet;
280 
281         if (!isContract(_wallet))
282             walletCount = walletCount.add(1);
283 
284         totalWallet = totalWallet.add(1);
285 
286         // Notify root this attached wallet, root will trigger attach operation (if this wallet is a contract)
287         MultiSigRoot(root).attachWalletOrNode(_wallet);
288 
289         return true;
290     }
291 
292     function detach(address _wallet) public
293         onlyRoot
294         returns (bool)
295     {
296         require(address(0) != _wallet, "Node.detach: Wallet address is empty");
297 
298         uint8 index = walletsIndex[_wallet];
299         require(0 < index && MAX_WALLET >= index, "Node.detach: Wallet address is not registered");
300 
301         if (!isContract(_wallet))
302             walletCount = walletCount.sub(1);
303 
304         totalWallet = totalWallet.sub(1);
305 
306         delete wallets[index];
307         delete walletsIndex[_wallet];
308 
309         // Notify root to remove this wallet from list
310         MultiSigRoot(root).detachWalletOrNode(_wallet);
311 
312         return true;
313     }
314 
315     function getRootNode() external view
316         returns (address)
317     {
318         if (address(0) == parent)
319             return address(this);
320 
321         return MultiSigNode(parent).getRootNode();
322     }
323 
324 }
325 
326 
327 /**
328  * NOTE: Regulator is meant for changable rules for multi-sig
329  */
330 contract MultiSigRegulator is Label {
331     using SafeMathUint8 for uint8;
332     using SafeMathUint256 for uint256;
333 
334     event TransactionLimitChanged(string requirementType, uint256 limit);
335 
336     address payable public root;
337 
338     address private creator;
339 
340     // Cached parameters
341     address private argTo;
342     uint256 private argValue;
343 
344     bool public isSealed;
345 
346     // Daily transaction limit (mapped: requirement type => TransactionLimit)
347     mapping(bytes32 => TransactionLimit) public transactionLimits;
348 
349     struct TransactionLimit {
350         uint256 datetime;
351         uint256 volume;
352         uint256 upperLimit;
353     }
354 
355     modifier onlySealed() {
356         require(isSealed, "Regulator.onlySealed: Not sealed");
357         _;
358     }
359 
360     modifier onlyMe() {
361         require(msg.sender == address(this), "Regulator.onlyMe: Access denied");
362         _;
363     }
364 
365     modifier onlyRoot() {
366         require(msg.sender == root, "Regulator.onlyRoot: Access denied");
367         _;
368     }
369 
370     modifier onlyCreator() {
371         require(msg.sender == creator, "Regulator.onlyCreator: Access denied");
372         _;
373     }
374 
375     /**
376      * Supported non-payable default function
377      */
378     function () external
379         onlyMe
380         onlySealed
381     {
382         revert("Regulator: Not supported");
383     }
384 
385     constructor(address payable _root, string memory _label, string memory _description) public
386         Label("REGULATOR", _label, _description)
387     {
388         require(address(0) != _root, "Regulator: Root address is empty");
389         root = _root;
390         creator = msg.sender;
391     }
392 
393     /**
394      * Supported non-payable function: ERC_ER_SHI.increaseSupply
395      * Only can be called by this contract itself to resolve calldata
396      */
397     function increaseSupply(uint256 _value, address /* _to */) external
398         onlyMe
399         onlySealed
400     {
401         defaultRequirement("increaseSupply", _value);
402     }
403 
404     /**
405      * Supported non-payable function: ERC_ER_SHI.decreaseSupply
406      * Only can be called by this contract itself to resolve calldata
407      */
408     function decreaseSupply(uint256 _value, address /* _from */) external
409         onlyMe
410         onlySealed
411     {
412         defaultRequirement("decreaseSupply", _value);
413     }
414 
415     /**
416      * Supported non-payable function: ERC_ER_SHI.freeze
417      * Only can be called by this contract itself to resolve calldata
418      */
419     function freeze(address /* _from */, uint256 /* _value */) external
420         onlyMe
421         onlySealed
422     {
423         requirement1Backsys();
424     }
425 
426     /**
427      * Supported non-payable function: ERC_ER_SHI.unfreeze
428      * Only can be called by this contract itself to resolve calldata
429      */
430     function unfreeze(address /* _from */, uint256 /* _value */) external
431         onlyMe
432         onlySealed
433     {
434         requirement1Backsys();
435     }
436 
437     /**
438      * Supported non-payable function: ERC_ER_SHI.freezeAddress
439      * Only can be called by this contract itself to resolve calldata
440      */
441     function freezeAddress(address /* _addressOf */) external
442         onlyMe
443         onlySealed
444     {
445         requirement1Backsys();
446     }
447 
448     /**
449      * Supported non-payable function: ERC_ER_SHI.unfreezeAddress
450      * Only can be called by this contract itself to resolve calldata
451      */
452     function unfreezeAddress(address /* _addressOf */) external
453         onlyMe
454         onlySealed
455     {
456         requirement1Backsys();
457     }
458 
459     /**
460      * Supported non-payable function: Ownership.acceptOwnership
461      * Only can be called by this contract itself to resolve calldata
462      */
463     function acceptOwnership () external
464         onlyMe
465         onlySealed
466     {
467         requirement(LABEL_CODE_OPS, 2, 1); // INDEX 2: ONE SIGNABLE
468         requirement(LABEL_CODE_SIGNER_CONTROLLER, 1, 1); // INDEX 1: ONE SIGNABLE
469     }
470 
471     /**
472      * Supported non-payable function: Ownership.transferOwnership
473      * Only can be called by this contract itself to resolve calldata
474      */
475     function transferOwnership (address payable /* _newOwner */) external
476         onlyMe
477         onlySealed
478     {
479         requirement(LABEL_CODE_STAKER, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
480         requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL SIGNABLE
481         requirement(LABEL_CODE_SIGNER_CONTROLLER, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
482     }
483 
484     /**
485      * Supported non-payable function: Controllable.pause
486      * Only can be called by this contract itself to resolve calldata
487      */
488     function pause () external
489         onlyMe
490         onlySealed
491     {
492         requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
493     }
494 
495     /**
496      * Supported non-payable function: Controllable.resume
497      * Only can be called by this contract itself to resolve calldata
498      */
499     function resume () external
500         onlyMe
501         onlySealed
502     {
503         requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, 2); // ANY TWO SIGNABLE
504     }
505 
506     /**
507      * Supported non-payable function: MultiSigRegulator.setTransactionLimit
508      */
509     function setTransactionLimit(string calldata _requirementType, uint256 _limit) external
510     {
511         if (msg.sender == root || !isSealed) {
512             // Set transaction limit
513             transactionLimits[encodePacked(_requirementType)].upperLimit = _limit;
514             emit TransactionLimitChanged(_requirementType, _limit);
515         }
516         else {
517             require(msg.sender == address(this), "Regulator.setTransactionLimit: Access denied");
518 
519             // Create requirements for this transaction
520             requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, 2); // ANY TWO SIGNABLE
521         }
522     }
523 
524     function seal() external
525         onlyCreator
526     {
527         require(!isSealed, "Regulator.seal: Access denied");
528         isSealed = true;
529     }
530 
531     function createRequirement(uint256 /* _transactionCode */, address /* _from */, address _to, uint256 _value, bytes calldata _data) external
532         onlyRoot
533     {
534         // Cache parameters
535         argTo = _to;
536         argValue = _value;
537 
538         // Perform self call to determine function details for requirement setup
539         (bool success, bytes memory returnData) = address(this).call.value(_value)(_data);
540 
541         if (!success) {
542             // Check the error string is available or not
543             if (0 == returnData.length || bytes4(0x08c379a0) != convertBytesToBytes4(returnData))
544                 revert("Regulator.createRequirement: Function call failed");
545             else {
546                 bytes memory bytesArray = new bytes(returnData.length);
547                 for (uint256 i = 0; i < returnData.length.sub(4); i = i.add(1)) {
548                     bytesArray[i] = returnData[i.add(4)];
549                 }
550 
551                 (string memory reason) = abi.decode(bytesArray, (string));
552                 revert(reason);
553             }
554         }
555     }
556 
557     function requirement(bytes32 _labelCode, uint256 _flag, uint8 _required) private
558     {
559         MultiSigRoot(root).createRequirement(_labelCode, _flag, _required);
560     }
561 
562     function defaultRequirement(string memory _requirementType, uint256 _value) private
563     {
564         bytes32 t = encodePacked(_requirementType);
565 
566         // Check transaction volume limit
567         TransactionLimit storage limit = transactionLimits[t];
568 
569         // Check transaction volume limit
570         if (0 < limit.upperLimit) {
571             // Truncate timestamp (YYYYMMDD) to daily (UTC time)
572             uint256 dt = now - (now % 86400);
573 
574             if (dt == limit.datetime)
575                 limit.volume = limit.volume.add(_value);
576             else {
577                 // Reset volume on new day
578                 limit.datetime = dt;
579                 limit.volume = _value;
580             }
581 
582             require(limit.upperLimit >= limit.volume, "Regulator.defaultRequirement: Exceeded limit");
583         }
584 
585         // Create requirement for this transaction
586         requirement(LABEL_CODE_OPS, WALLET_FLAG_ALL, 4); // ANY FOUR SIGNABLE
587     }
588 
589     function requirement1Backsys() private
590     {
591         requirement(LABEL_CODE_BACKSYS, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
592     }
593 
594 }
595 
596 
597 contract MultiSigRoot is Label {
598     using SafeMathUint8 for uint8;
599     using SafeMathUint256 for uint256;
600 
601     uint8 constant private WALLET_TYPE_WALLET = 1;
602     uint8 constant private WALLET_TYPE_NODE = 2;
603 
604     uint8 constant private TRANSACTION_STATUS_EMPTY = 0;
605     uint8 constant private TRANSACTION_STATUS_PENDING = 1;
606     uint8 constant private TRANSACTION_STATUS_EXECUTED = 2;
607     uint8 constant private TRANSACTION_STATUS_FAILURE = 3;
608     uint8 constant private TRANSACTION_STATUS_REVOKED = 4;
609 
610     event Confirmation(address indexed sender, uint256 indexed transactionCode);
611     event Revocation(address indexed sender, uint256 indexed transactionCode);
612     event Submission(uint256 indexed transactionCode);
613     event Requirement(uint256 indexed transactionCode, bytes32 labelCode, uint256 flag, uint8 required);
614     event Execution(uint256 indexed transactionCode);
615     event ExecutionFailure(uint256 indexed transactionCode);
616     event Deposit(address indexed sender, uint256 value);
617 
618     event StakersChanged(address indexed stakers);
619     event SignersChanged(address indexed signers);
620     event RegulatorChanged(address indexed regulator);
621     event StakersControllerChanged(address indexed stakersController);
622     event SignersControllerChanged(address indexed signersController);
623     
624     event WalletOrNodeAttached(address indexed wallet);
625     event WalletOrNodeDetached(address indexed wallet);
626     
627     address public stakers;
628     address public signers;
629 
630     address public stakersController;
631     address public signersController;
632 
633     address public regulator;
634 
635     // Transaction (mapped: transactionCode => Transaction)
636     mapping(uint256 => Transaction) public transactions;
637     uint256 public transactionCode;
638 
639     // Requirement (mapped: transactionCode + label code => requirement)
640     mapping(uint256 => mapping(bytes32 => TransactionRequirement)) public requirements;
641     // Prevent duplicated confirmation (mapped: transactionCode + wallet address => bool)
642     mapping(uint256 => mapping(address => bool)) public confirmations;
643 
644     // Registered wallets or nodes (mapped: address => type)
645     mapping(address => uint8) public registered;
646 
647     // Search node address by wallet address (mapped: wallet address => node address)
648     mapping(address => address) public walletToNodes;
649 
650     // Search wallet index by wallet address (mapped: wallet address => wallet index)
651     mapping(address => uint8) private walletToIndexes;
652 
653     // Search label code by wallet address (mapped: wallet address => label code)
654     mapping(address => bytes32) private walletToLabelCodes;
655 
656     // Search node address by label code (mapped: label code => node address)
657     mapping(bytes32 => address) private labelCodeToNodes;
658 
659     struct Transaction {
660         uint8 status;
661         uint8 totalRequired;
662 
663         address to;
664         uint256 value;
665         bytes data;
666         string reason;
667     }
668 
669     struct TransactionRequirement {
670         uint8 required;
671         uint256 flag;
672     }
673 
674     modifier onlyEligible(uint256 _transactionCode) {
675         require(isEligible(_transactionCode, msg.sender), "Root.onlyEligible: Not eligible");
676         _;
677     }
678 
679     modifier onlySignable(uint256 _transactionCode) {
680         require(isSignable(_transactionCode, msg.sender), "Root.onlySignable: Not signable");
681         _;
682     }
683 
684     modifier onlyNode() {
685         require(WALLET_TYPE_NODE == registered[msg.sender], "Root.onlyNode: Access denied");
686         _;
687     }
688 
689     modifier onlyWallet() {
690         require(WALLET_TYPE_WALLET == registered[msg.sender], "Root.onlyWallet: Access denied");
691         require(!isContract(msg.sender), "Root.onlyWallet: Is not node");
692         _;
693     }
694 
695     modifier onlyRegulator() {
696         require(msg.sender == regulator, "Root.onlyRegulator: Access denied");
697         _;
698     }
699 
700     constructor(string memory _label, string memory _description) public
701         Label("ROOT", _label, _description)
702     {
703     }
704 
705     function () external payable
706     {
707         if (0 < msg.value)
708             emit Deposit(msg.sender, msg.value);
709     }
710 
711     function isEligible(uint256 _transactionCode, address _sender) public view
712         returns (bool)
713     {
714         uint256 flag = requirements[_transactionCode][walletToLabelCodes[_sender]].flag;
715 
716         if (0 != flag) {
717             uint8 index = walletToIndexes[_sender];
718 
719             if (0 != index) {
720                 index = index.sub(1);
721 
722                 // Check the bit is on for wallet index
723                 return (0 != ((flag >> index) & 1));
724             }
725         }
726         return false;
727     }
728 
729     function isSignable(uint256 _transactionCode, address _sender) public view
730         returns (bool)
731     {
732         if (TRANSACTION_STATUS_PENDING == transactions[_transactionCode].status) {
733             if (!confirmations[_transactionCode][_sender]) {
734                 if (0 != requirements[_transactionCode][walletToLabelCodes[_sender]].required)
735                     return true;
736             }
737         }
738         return false;
739     }
740 
741     function createRequirement(bytes32 _labelCode, uint256 _flag, uint8 _required) external
742         onlyRegulator
743     {
744         setRequirement(_labelCode, _flag, _required);
745     }
746 
747     function setRequirement(bytes32 _labelCode, uint256 _flag, uint8 _required) private
748     {
749         require(0 < _flag, "Root.setRequirement: Confirmation flag is empty");
750 
751         uint8 totalRequired;
752 
753         // Required all wallet in the node
754         if (uint8(-1) == _required) {
755             address node = labelCodeToNodes[_labelCode];
756             require(address(0) != node, "Root.setRequirement: Node is not found");
757 
758             totalRequired = MultiSigNode(node).walletCount();
759 
760             if (node != signers) {
761                 // Stakers and controllers must have at least 1 wallet attached
762                 require(0 < totalRequired, "Root.setRequirement: No wallet");
763             }
764             else {
765                 // Signer node allowed to be empty
766                 if (0 == totalRequired)
767                     return;
768             }
769 
770             require(0 < totalRequired, "Root.setRequirement: Confirmation required is empty");
771         }
772         else {
773             // allowed 0 requirement, in order to support eligible user but not signable (view transaction only)
774             totalRequired = _required;
775         }
776 
777         require(0 == requirements[transactionCode][_labelCode].flag, "Root.setRequirement: Duplicated requirement");
778 
779         requirements[transactionCode][_labelCode] = TransactionRequirement({
780             required: totalRequired,
781             flag: _flag
782         });
783 
784         // Increase total required in transaction
785         transactions[transactionCode].totalRequired = transactions[transactionCode].totalRequired.add(totalRequired);
786 
787         emit Requirement(transactionCode, _labelCode, _flag, totalRequired);
788     }
789 
790     function submit(address _to, uint256 _value, bytes calldata _data) external
791         onlyWallet
792         returns (uint256 /* transactionCode */) 
793     {
794         require(address(0) != _to, "Root.submit: Target address is empty");
795 
796         // Generate transaction id
797         transactionCode = transactionCode.add(1);
798 
799         bytes4 functionId = convertBytesToBytes4(_data);
800 
801         // Create requirement that based on destination address
802         if (address(this) != _to) {
803             // Check this is node address or not
804             if (WALLET_TYPE_NODE == registered[_to]) {
805                 // Calling node function
806                 // - 0x80882800: node.attach
807                 // - 0xceb6c343: node.detach
808                 if (bytes4(0x80882800) == functionId || bytes4(0xceb6c343) == functionId) { // node.attach or node.detach
809                     address rootNode = MultiSigNode(_to).getRootNode();
810 
811                     if (rootNode == signers) {
812                         // Change SIGNER need ALL SIGNER_CONTROLLER
813                         setRequirement(LABEL_CODE_SIGNER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
814                     }
815                     else if (rootNode == signersController || rootNode == stakersController) {
816                         // Change SIGNERS_CONTROLLER or STAKER_CONTROLLER need ALL STAKER
817                         setRequirement(LABEL_CODE_STAKER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
818                     }
819                     else if (rootNode == stakers) {
820                         // Change STAKER need ALL STAKER_CONTROLLER
821                         setRequirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
822                     }
823                     else {
824                         revert("Root.submit: Unknown node");
825                     }
826                 }
827                 else
828                     revert("Root.submit: Not supported");
829             }
830             else {
831                 // Regulator create requirement
832                 MultiSigRegulator(regulator).createRequirement(transactionCode, msg.sender, _to, _value, _data);
833             }
834         }
835         else {
836             // Calling self functions
837             // - 0xcde0a4f8: root.setRegulator
838             // - 0xb47876ea: root.setSigners
839             // - 0xc27dbe63: root.setStakers
840             // - 0x26bc178c: root.setStakersController
841             // - 0x51d996bf: root.setSignersController
842             if (bytes4(0xcde0a4f8) == functionId || bytes4(0xc27dbe63) == functionId) // setRegulator or setStakers
843                 setRequirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
844             else if (bytes4(0x26bc178c) == functionId || bytes4(0x51d996bf) == functionId) // setStakersController or setSignersController
845                 setRequirement(LABEL_CODE_STAKER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
846             else if (bytes4(0xb47876ea) == functionId) // setSigners
847                 setRequirement(LABEL_CODE_SIGNER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
848             else
849                 revert("Root.submit: Not supported");
850         }
851 
852         require(0 < transactions[transactionCode].totalRequired, "Root.submit: Requirement is empty");
853 
854         // Create transaction structure
855         transactions[transactionCode] = Transaction({
856             status: TRANSACTION_STATUS_PENDING,
857             totalRequired: transactions[transactionCode].totalRequired,
858             to: _to,
859             value: _value,
860             data: _data,
861             reason: ""
862         });
863 
864         emit Submission(transactionCode);
865 
866         // Confirm transaction if eligible and signable
867         if (isEligible(transactionCode, msg.sender) && isSignable(transactionCode, msg.sender))
868             confirmTransaction(transactionCode, transactions[transactionCode]);
869 
870         return transactionCode;
871     }
872 
873     function confirm(uint256 _transactionCode) external
874         onlyWallet
875         onlyEligible(_transactionCode)
876         onlySignable(_transactionCode)
877         returns (bool)
878     {
879         Transaction storage transaction = transactions[_transactionCode];
880 
881         return confirmTransaction(_transactionCode, transaction);
882     }
883 
884     function revoke(uint256 _transactionCode) external
885         onlyWallet
886         onlyEligible(_transactionCode)
887         returns (bool)
888     {
889         require(TRANSACTION_STATUS_PENDING == transactions[_transactionCode].status, "Root.revoke: Transaction has been completed");
890         transactions[_transactionCode].status = TRANSACTION_STATUS_REVOKED;
891 
892         emit Revocation(msg.sender, _transactionCode);
893         return true;
894     }
895 
896     function confirmTransaction(uint256 _transactionCode, Transaction storage _transaction) private
897         returns (bool)
898     {
899         TransactionRequirement storage requirement = requirements[_transactionCode][walletToLabelCodes[msg.sender]];
900         require(0 != requirement.flag && 0 != requirement.required, "Root.confirmTransaction: Requirement is empty");
901 
902         // Prevent duplicated confirmation
903         require(!confirmations[_transactionCode][msg.sender], "root.confirmTransaction: Duplicated confirmation");
904         confirmations[_transactionCode][msg.sender] = true;
905 
906         requirement.required = requirement.required.sub(1);
907         _transaction.totalRequired = _transaction.totalRequired.sub(1);
908 
909         emit Confirmation(msg.sender, _transactionCode);
910 
911         return executeTransaction(_transactionCode, _transaction);
912     }
913 
914     function executeTransaction(uint256 _transactionCode, Transaction storage _transaction) private
915         returns (bool)
916     {
917         require(TRANSACTION_STATUS_PENDING == _transaction.status, "Root.executeTransaction: Status not active");
918 
919         if (0 == _transaction.totalRequired) {
920             _transaction.status = TRANSACTION_STATUS_EXECUTED;
921 
922             // Perform remote call
923             (bool success, bytes memory returnData) = _transaction.to.call.value(_transaction.value)(_transaction.data);
924 
925             if (success)
926                 emit Execution(_transactionCode);
927             else {
928                 // Check the error string is available or not
929                 if (0 == returnData.length || bytes4(0x08c379a0) != convertBytesToBytes4(returnData))
930                     _transaction.reason = "Root.executeTransaction: Function call failed";
931                 else {
932                     bytes memory bytesArray = new bytes(returnData.length);
933                     for (uint256 i = 0; i < returnData.length.sub(4); i = i.add(1)) {
934                         bytesArray[i] = returnData[i.add(4)];
935                     }
936 
937                     (string memory reason) = abi.decode(bytesArray, (string));
938                     _transaction.reason = reason;
939                 }
940 
941                 _transaction.status = TRANSACTION_STATUS_FAILURE;
942                 emit ExecutionFailure(_transactionCode);
943             }
944 
945             return success;
946         }
947 
948         return true;
949     }
950 
951     function setRegulator(address _addressOf) external
952     {
953         if (address(0) != regulator)
954             require(msg.sender == address(this), "Root.setRegulator: Access denied");
955         
956         require(MultiSigRegulator(_addressOf).isSealed(), "Root.setRegulator: Regulator is not sealed");
957 
958         regulator = setNode(regulator, _addressOf, false);
959         emit RegulatorChanged(regulator);
960     }
961 
962     function setStakers(address _addressOf) external
963     {
964         if (address(0) != stakers)
965             require(msg.sender == address(this), "Root.setStakers: Access denied");
966 
967         if (isContract(_addressOf))
968             require(0 < MultiSigNode(_addressOf).walletCount(), "Root.setStakers: No wallet");
969 
970         stakers = setNode(stakers, _addressOf, true);
971         emit StakersChanged(stakers);
972     }
973 
974     function setSigners(address _addressOf) external
975         returns (bool)
976     {
977         if (address(0) != signers)
978             require(msg.sender == address(this), "Root.setSigners: Access denied");
979 
980         // Signer node allowed to be empty
981 
982         signers = setNode(signers, _addressOf, true);
983         emit SignersChanged(signers);
984         return true;
985     }
986 
987     function setStakersController(address _addressOf) external
988     {
989         if (address(0) != stakersController)
990             require(msg.sender == address(this), "Root.setStakersController: Access denied");
991 
992         if (isContract(_addressOf))
993             require(0 < MultiSigNode(_addressOf).walletCount(), "Root.setStakersController: No wallet");
994 
995         stakersController = setNode(stakersController, _addressOf, true);
996         emit StakersControllerChanged(stakersController);
997     }
998 
999     function setSignersController(address _addressOf) external
1000     {
1001         if (address(0) != signersController)
1002             require(msg.sender == address(this), "Root.setSignersController: Access denied");
1003 
1004         if (isContract(_addressOf))
1005             require(0 < MultiSigNode(_addressOf).walletCount(), "Root.setSignersController: No wallet");
1006 
1007         signersController = setNode(signersController, _addressOf, true);
1008         emit SignersControllerChanged(signersController);
1009     }
1010 
1011     function setNode(address _from, address _to, bool needAttachment) private
1012         returns (address)
1013     {
1014         require(address(0) != _to, "Root.setNode: Address is empty");
1015 
1016         if (needAttachment) {
1017             require(0 == registered[_to], "Root.setNode: Duplicated node");
1018 
1019             // Remove node from list
1020             if (address(0) != _from) {
1021                 if (isContract(_from)) {
1022                     // detach node
1023                     MultiSigNode(_from).term();
1024                 }
1025 
1026                 delete registered[_from];
1027             }
1028 
1029             if (isContract(_to)) {
1030                 // Mark address as registered node
1031                 registered[_to] = WALLET_TYPE_NODE;
1032 
1033                 if (needAttachment) {
1034                     // Attach node (parrent address = 0x0)
1035                     MultiSigNode(_to).init(address(0));
1036                 }
1037             }
1038             else {
1039                 // Mark address as registered wallet
1040                 registered[_to] = WALLET_TYPE_WALLET;
1041             }
1042         }
1043 
1044         return _to;
1045     }
1046 
1047     function attachWalletOrNode(address _wallet) external
1048         onlyNode
1049         returns (bool)
1050     {
1051         require(address(0) != _wallet, "Root.attachWalletOrNode: Wallet address is empty");
1052         require(0 == registered[_wallet], "Root.attachWalletOrNode: Duplicated wallet address");
1053 
1054         bytes32 labelCode = MultiSigNode(msg.sender).labelCode();
1055 
1056         walletToNodes[_wallet] = msg.sender;
1057         walletToIndexes[_wallet] = MultiSigNode(msg.sender).walletsIndex(_wallet);
1058         walletToLabelCodes[_wallet] = labelCode;
1059 
1060         labelCodeToNodes[labelCode] = msg.sender;
1061 
1062         if (isContract(_wallet)) {
1063             // Mark address as registered node
1064             registered[_wallet] = WALLET_TYPE_NODE;
1065 
1066             // Attach node with their parent address
1067             MultiSigNode(_wallet).init(msg.sender);
1068         }
1069         else {
1070             // Mark address as registered wallet
1071             registered[_wallet] = WALLET_TYPE_WALLET;
1072         }
1073 
1074         emit WalletOrNodeAttached(_wallet);
1075 
1076         return true;
1077     }
1078 
1079     function detachWalletOrNode(address _wallet) external
1080         onlyNode
1081         returns (bool)
1082     {
1083         require(address(0) != _wallet, "Root.detachWalletOrNode: Wallet address is empty");
1084         require(0 != registered[_wallet], "Root.detachWalletOrNode: Wallet address is not registered");
1085 
1086         if (isContract(_wallet)) {
1087             // Detach node with their parent
1088             MultiSigNode(_wallet).term();
1089 
1090             bytes32 labelCode = MultiSigNode(msg.sender).labelCode();
1091 
1092             delete labelCodeToNodes[labelCode];
1093         }
1094 
1095         delete registered[_wallet];
1096         delete walletToNodes[_wallet];
1097         delete walletToIndexes[_wallet];
1098         delete walletToLabelCodes[_wallet];
1099 
1100         emit WalletOrNodeDetached(_wallet);
1101 
1102         return true;
1103     }
1104 
1105 }