1 pragma solidity 0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         _owner = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84     }
85 
86     /**
87      * @return the address of the owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner());
98         _;
99     }
100 
101     /**
102      * @return true if `msg.sender` is the owner of the contract.
103      */
104     function isOwner() public view returns (bool) {
105         return msg.sender == _owner;
106     }
107 
108     /**
109      * @dev Allows the current owner to relinquish control of the contract.
110      * It will not be possible to call the functions with the `onlyOwner`
111      * modifier anymore.
112      * @notice Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function transferOwnership(address newOwner) public onlyOwner {
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers control of the contract to a newOwner.
130      * @param newOwner The address to transfer ownership to.
131      */
132     function _transferOwnership(address newOwner) internal {
133         require(newOwner != address(0));
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 /**
140  * @title Roles
141  * @dev Library for managing addresses assigned to a Role.
142  */
143 library Roles {
144     struct Role {
145         mapping (address => bool) bearer;
146     }
147 
148     /**
149      * @dev give an account access to this role
150      */
151     function add(Role storage role, address account) internal {
152         require(account != address(0));
153         require(!has(role, account));
154 
155         role.bearer[account] = true;
156     }
157 
158     /**
159      * @dev remove an account's access to this role
160      */
161     function remove(Role storage role, address account) internal {
162         require(account != address(0));
163         require(has(role, account));
164 
165         role.bearer[account] = false;
166     }
167 
168     /**
169      * @dev check if an account has this role
170      * @return bool
171      */
172     function has(Role storage role, address account) internal view returns (bool) {
173         require(account != address(0));
174         return role.bearer[account];
175     }
176 }
177 
178 contract MinterRole {
179     using Roles for Roles.Role;
180 
181     event MinterAdded(address indexed account);
182     event MinterRemoved(address indexed account);
183 
184     Roles.Role private _minters;
185 
186     constructor () internal {
187         _addMinter(msg.sender);
188     }
189 
190     modifier onlyMinter() {
191         require(isMinter(msg.sender));
192         _;
193     }
194 
195     function isMinter(address account) public view returns (bool) {
196         return _minters.has(account);
197     }
198 
199     function addMinter(address account) public onlyMinter {
200         _addMinter(account);
201     }
202 
203     function renounceMinter() public {
204         _removeMinter(msg.sender);
205     }
206 
207     function _addMinter(address account) internal {
208         _minters.add(account);
209         emit MinterAdded(account);
210     }
211 
212     function _removeMinter(address account) internal {
213         _minters.remove(account);
214         emit MinterRemoved(account);
215     }
216 }
217 
218 /**
219  * @title Helps contracts guard against reentrancy attacks.
220  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
221  * @dev If you mark a function `nonReentrant`, you should also
222  * mark it `external`.
223  */
224 contract ReentrancyGuard {
225     /// @dev counter to allow mutex lock with only one SSTORE operation
226     uint256 private _guardCounter;
227 
228     constructor () internal {
229         // The counter starts at one to prevent changing it from zero to a non-zero
230         // value, which is a more expensive operation.
231         _guardCounter = 1;
232     }
233 
234     /**
235      * @dev Prevents a contract from calling itself, directly or indirectly.
236      * Calling a `nonReentrant` function from another `nonReentrant`
237      * function is not supported. It is possible to prevent this from happening
238      * by making the `nonReentrant` function external, and make it call a
239      * `private` function that does the actual work.
240      */
241     modifier nonReentrant() {
242         _guardCounter += 1;
243         uint256 localCounter = _guardCounter;
244         _;
245         require(localCounter == _guardCounter);
246     }
247 }
248 
249 contract CertificateControllerMock {
250 
251   // Address used by off-chain controller service to sign certificate
252   mapping(address => bool) internal _certificateSigners;
253 
254   // A nonce used to ensure a certificate can be used only once
255   mapping(address => uint256) internal _checkCount;
256 
257   event Checked(address sender);
258 
259   constructor(address _certificateSigner) public {
260     _setCertificateSigner(_certificateSigner, true);
261   }
262 
263   /**
264    * @dev Modifier to protect methods with certificate control
265    */
266   modifier isValidCertificate(bytes memory data) {
267 
268     require(_certificateSigners[msg.sender] || _checkCertificate(data, 0, 0x00000000), "A3: Transfer Blocked - Sender lockup period not ended");
269 
270     _checkCount[msg.sender] += 1; // Increment sender check count
271 
272     emit Checked(msg.sender);
273     _;
274   }
275 
276   /**
277    * @dev Get number of transations already sent to this contract by the sender
278    * @param sender Address whom to check the counter of.
279    * @return uint256 Number of transaction already sent to this contract.
280    */
281   function checkCount(address sender) external view returns (uint256) {
282     return _checkCount[sender];
283   }
284 
285   /**
286    * @dev Get certificate signer authorization for an operator.
287    * @param operator Address whom to check the certificate signer authorization for.
288    * @return bool 'true' if operator is authorized as certificate signer, 'false' if not.
289    */
290   function certificateSigners(address operator) external view returns (bool) {
291     return _certificateSigners[operator];
292   }
293 
294   /**
295    * @dev Set signer authorization for operator.
296    * @param operator Address to add/remove as a certificate signer.
297    * @param authorized 'true' if operator shall be accepted as certificate signer, 'false' if not.
298    */
299   function _setCertificateSigner(address operator, bool authorized) internal {
300     require(operator != address(0), "Action Blocked - Not a valid address");
301     _certificateSigners[operator] = authorized;
302   }
303 
304   /**
305    * @dev Checks if a certificate is correct
306    * @param data Certificate to control
307    */
308    function _checkCertificate(bytes memory data, uint256 /*value*/, bytes4 /*functionID*/) internal pure returns(bool) { 
309      // Comments to avoid compilation warnings for unused variables.
310      if(data.length > 0 && (data[0] == hex"10" || data[0] == hex"11" || data[0] == hex"22")) {
311        return true;
312      } else {
313        return false;
314      }
315    }
316 }
317 
318 contract CertificateController is CertificateControllerMock {
319 
320   constructor(address _certificateSigner) public CertificateControllerMock(_certificateSigner) {}
321 
322 }
323 
324 
325 /**
326  * @title IERC777TokensRecipient
327  * @dev ERC777TokensRecipient interface
328  */
329 interface IERC777TokensRecipient {
330 
331   function canReceive(
332     bytes32 partition,
333     address from,
334     address to,
335     uint value,
336     bytes calldata data,
337     bytes calldata operatorData
338   ) external view returns(bool);
339 
340   function tokensReceived(
341     bytes32 partition,
342     address operator,
343     address from,
344     address to,
345     uint value,
346     bytes calldata data,
347     bytes calldata operatorData
348   ) external;
349 
350 }
351 
352 /**
353  * @title IERC777TokensSender
354  * @dev ERC777TokensSender interface
355  */
356 interface IERC777TokensSender {
357 
358   function canTransfer(
359     bytes32 partition,
360     address from,
361     address to,
362     uint value,
363     bytes calldata data,
364     bytes calldata operatorData
365   ) external view returns(bool);
366 
367   function tokensToTransfer(
368     bytes32 partition,
369     address operator,
370     address from,
371     address to,
372     uint value,
373     bytes calldata data,
374     bytes calldata operatorData
375   ) external;
376 
377 }
378 
379 /**
380  * @title IERC1410 partially fungible token standard
381  * @dev ERC1410 interface
382  */
383 interface IERC1410 {
384 
385     // Token Information
386     function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256); // 1/10
387     function partitionsOf(address tokenHolder) external view returns (bytes32[] memory); // 2/10
388 
389     // Token Transfers
390     function transferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external returns (bytes32); // 3/10
391     function operatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external returns (bytes32); // 4/10
392 
393     // Default Partition Management
394     function getDefaultPartitions(address tokenHolder) external view returns (bytes32[] memory); // 5/10
395     function setDefaultPartitions(bytes32[] calldata partitions) external; // 6/10
396 
397     // Operators
398     function controllersByPartition(bytes32 partition) external view returns (address[] memory); // 7/10
399     function authorizeOperatorByPartition(bytes32 partition, address operator) external; // 8/10
400     function revokeOperatorByPartition(bytes32 partition, address operator) external; // 9/10
401     function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool); // 10/10
402 
403     // Transfer Events
404     event TransferByPartition(
405         bytes32 indexed fromPartition,
406         address operator,
407         address indexed from,
408         address indexed to,
409         uint256 value,
410         bytes data,
411         bytes operatorData
412     );
413 
414     event ChangedPartition(
415         bytes32 indexed fromPartition,
416         bytes32 indexed toPartition,
417         uint256 value
418     );
419 
420     // Operator Events
421     event AuthorizedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
422     event RevokedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
423 
424 }
425 
426 
427 /**
428  * @title IERC777 token standard
429  * @dev ERC777 interface
430  */
431 interface IERC777 {
432 
433   function name() external view returns (string memory); // 1/13
434   function symbol() external view returns (string memory); // 2/13
435   function totalSupply() external view returns (uint256); // 3/13
436   function balanceOf(address owner) external view returns (uint256); // 4/13
437   function granularity() external view returns (uint256); // 5/13
438 
439   function controllers() external view returns (address[] memory); // 6/13
440   function authorizeOperator(address operator) external; // 7/13
441   function revokeOperator(address operator) external; // 8/13
442   function isOperatorFor(address operator, address tokenHolder) external view returns (bool); // 9/13
443 
444   function transferWithData(address to, uint256 value, bytes calldata data) external; // 10/13
445   function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external; // 11/13
446 
447   function redeem(uint256 value, bytes calldata data) external; // 12/13
448   function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData) external; // 13/13
449 
450   event TransferWithData(
451     address indexed operator,
452     address indexed from,
453     address indexed to,
454     uint256 value,
455     bytes data,
456     bytes operatorData
457   );
458   event Issued(address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
459   event Redeemed(address indexed operator, address indexed from, uint256 value, bytes data, bytes operatorData);
460   event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
461   event RevokedOperator(address indexed operator, address indexed tokenHolder);
462 
463 }
464 
465 
466 /**
467  * @title ERC1400 security token standard
468  * @dev ERC1400 logic
469  */
470 interface IERC1400  {
471 
472     // Document Management
473     function getDocument(bytes32 name) external view returns (string memory, bytes32); // 1/9
474     function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external; // 2/9
475     event Document(bytes32 indexed name, string uri, bytes32 documentHash);
476 
477     // Controller Operation
478     function isControllable() external view returns (bool); // 3/9
479 
480     // Token Issuance
481     function isIssuable() external view returns (bool); // 4/9
482     function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data) external; // 5/9
483     event IssuedByPartition(bytes32 indexed partition, address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
484 
485     // Token Redemption
486     function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data) external; // 6/9
487     function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData) external; // 7/9
488     event RedeemedByPartition(bytes32 indexed partition, address indexed operator, address indexed from, uint256 value, bytes data, bytes operatorData);
489 
490     // Transfer Validity
491     function canTransferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external view returns (byte, bytes32, bytes32); // 8/9
492     function canOperatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external view returns (byte, bytes32, bytes32); // 9/9
493 
494 }
495 
496 /**
497  * Reason codes - ERC1066
498  *
499  * To improve the token holder experience, canTransfer MUST return a reason byte code
500  * on success or failure based on the EIP-1066 application-specific status codes specified below.
501  * An implementation can also return arbitrary data as a bytes32 to provide additional
502  * information not captured by the reason code.
503  *
504  * Code Reason
505  * 0xA0 Transfer Verified - Unrestricted
506  * 0xA1 Transfer Verified - On-Chain approval for restricted token
507  * 0xA2 Transfer Verified - Off-Chain approval for restricted token
508  * 0xA3 Transfer Blocked - Sender lockup period not ended
509  * 0xA4 Transfer Blocked - Sender balance insufficient
510  * 0xA5 Transfer Blocked - Sender not eligible
511  * 0xA6 Transfer Blocked - Receiver not eligible
512  * 0xA7 Transfer Blocked - Identity restriction
513  * 0xA8 Transfer Blocked - Token restriction
514  * 0xA9 Transfer Blocked - Token granularity
515  */
516 
517 
518 contract ERC820Registry {
519     function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
520     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
521     function setManager(address _addr, address _newManager) external;
522     function getManager(address _addr) public view returns(address);
523 }
524 
525 
526 /// Base client to interact with the registry.
527 contract ERC820Client {
528     ERC820Registry constant ERC820REGISTRY = ERC820Registry(0x820b586C8C28125366C998641B09DCbE7d4cBF06);
529 
530     function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
531         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
532         ERC820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
533     }
534 
535     function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
536         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
537         return ERC820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
538     }
539 
540     function delegateManagement(address _newManager) internal {
541         ERC820REGISTRY.setManager(address(this), _newManager);
542     }
543 }
544 
545 /**
546  * @title ERC777
547  * @dev ERC777 logic
548  */
549 contract ERC777 is IERC777, Ownable, ERC820Client, CertificateController, ReentrancyGuard {
550   using SafeMath for uint256;
551 
552   string internal _name;
553   string internal _symbol;
554   uint256 internal _granularity;
555   uint256 internal _totalSupply;
556 
557   // Indicate whether the token can still be controlled by operators or not anymore.
558   bool internal _isControllable;
559 
560   // Mapping from tokenHolder to balance.
561   mapping(address => uint256) internal _balances;
562 
563   /******************** Mappings related to operator **************************/
564   // Mapping from (operator, tokenHolder) to authorized status. [TOKEN-HOLDER-SPECIFIC]
565   mapping(address => mapping(address => bool)) internal _authorizedOperator;
566 
567   // Array of controllers. [GLOBAL - NOT TOKEN-HOLDER-SPECIFIC]
568   address[] internal _controllers;
569 
570   // Mapping from operator to controller status. [GLOBAL - NOT TOKEN-HOLDER-SPECIFIC]
571   mapping(address => bool) internal _isController;
572   /****************************************************************************/
573 
574   /**
575    * [ERC777 CONSTRUCTOR]
576    * @dev Initialize ERC777 and CertificateController parameters + register
577    * the contract implementation in ERC820Registry.
578    * @param name Name of the token.
579    * @param symbol Symbol of the token.
580    * @param granularity Granularity of the token.
581    * @param controllers Array of initial controllers.
582    * @param certificateSigner Address of the off-chain service which signs the
583    * conditional ownership certificates required for token transfers, issuance,
584    * redemption (Cf. CertificateController.sol).
585    */
586   constructor(
587     string memory name,
588     string memory symbol,
589     uint256 granularity,
590     address[] memory controllers,
591     address certificateSigner
592   )
593     public
594     CertificateController(certificateSigner)
595   {
596     _name = name;
597     _symbol = symbol;
598     _totalSupply = 0;
599     require(granularity >= 1, "Constructor Blocked - Token granularity can not be lower than 1");
600     _granularity = granularity;
601 
602     _setControllers(controllers);
603 
604     setInterfaceImplementation("ERC777Token", address(this));
605   }
606 
607   /********************** ERC777 EXTERNAL FUNCTIONS ***************************/
608 
609   /**
610    * [ERC777 INTERFACE (1/13)]
611    * @dev Get the name of the token, e.g., "MyToken".
612    * @return Name of the token.
613    */
614   function name() external view returns(string memory) {
615     return _name;
616   }
617 
618   /**
619    * [ERC777 INTERFACE (2/13)]
620    * @dev Get the symbol of the token, e.g., "MYT".
621    * @return Symbol of the token.
622    */
623   function symbol() external view returns(string memory) {
624     return _symbol;
625   }
626 
627   /**
628    * [ERC777 INTERFACE (3/13)]
629    * @dev Get the total number of issued tokens.
630    * @return Total supply of tokens currently in circulation.
631    */
632   function totalSupply() external view returns (uint256) {
633     return _totalSupply;
634   }
635 
636   /**
637    * [ERC777 INTERFACE (4/13)]
638    * @dev Get the balance of the account with address 'tokenHolder'.
639    * @param tokenHolder Address for which the balance is returned.
640    * @return Amount of token held by 'tokenHolder' in the token contract.
641    */
642   function balanceOf(address tokenHolder) external view returns (uint256) {
643     return _balances[tokenHolder];
644   }
645 
646   /**
647    * [ERC777 INTERFACE (5/13)]
648    * @dev Get the smallest part of the token that’s not divisible.
649    * @return The smallest non-divisible part of the token.
650    */
651   function granularity() external view returns(uint256) {
652     return _granularity;
653   }
654 
655   /**
656    * [ERC777 INTERFACE (6/13)]
657    * @dev Get the list of controllers as defined by the token contract.
658    * @return List of addresses of all the controllers.
659    */
660   function controllers() external view returns (address[] memory) {
661     return _controllers;
662   }
663 
664   /**
665    * [ERC777 INTERFACE (7/13)]
666    * @dev Set a third party operator address as an operator of 'msg.sender' to transfer
667    * and redeem tokens on its behalf.
668    * @param operator Address to set as an operator for 'msg.sender'.
669    */
670   function authorizeOperator(address operator) external {
671     _authorizedOperator[operator][msg.sender] = true;
672     emit AuthorizedOperator(operator, msg.sender);
673   }
674 
675   /**
676    * [ERC777 INTERFACE (8/13)]
677    * @dev Remove the right of the operator address to be an operator for 'msg.sender'
678    * and to transfer and redeem tokens on its behalf.
679    * @param operator Address to rescind as an operator for 'msg.sender'.
680    */
681   function revokeOperator(address operator) external {
682     _authorizedOperator[operator][msg.sender] = false;
683     emit RevokedOperator(operator, msg.sender);
684   }
685 
686   /**
687    * [ERC777 INTERFACE (9/13)]
688    * @dev Indicate whether the operator address is an operator of the tokenHolder address.
689    * @param operator Address which may be an operator of tokenHolder.
690    * @param tokenHolder Address of a token holder which may have the operator address as an operator.
691    * @return 'true' if operator is an operator of 'tokenHolder' and 'false' otherwise.
692    */
693   function isOperatorFor(address operator, address tokenHolder) external view returns (bool) {
694     return _isOperatorFor(operator, tokenHolder);
695   }
696 
697   /**
698    * [ERC777 INTERFACE (10/13)]
699    * @dev Transfer the amount of tokens from the address 'msg.sender' to the address 'to'.
700    * @param to Token recipient.
701    * @param value Number of tokens to transfer.
702    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
703    */
704   function transferWithData(address to, uint256 value, bytes calldata data)
705     external
706     isValidCertificate(data)
707   {
708     _transferWithData("", msg.sender, msg.sender, to, value, data, "", true);
709   }
710 
711   /**
712    * [ERC777 INTERFACE (11/13)]
713    * @dev Transfer the amount of tokens on behalf of the address 'from' to the address 'to'.
714    * @param from Token holder (or 'address(0)' to set from to 'msg.sender').
715    * @param to Token recipient.
716    * @param value Number of tokens to transfer.
717    * @param data Information attached to the transfer, and intended for the token holder ('from').
718    * @param operatorData Information attached to the transfer by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
719    */
720   function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
721     external
722     isValidCertificate(operatorData)
723   {
724     address _from = (from == address(0)) ? msg.sender : from;
725 
726     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
727 
728     _transferWithData("", msg.sender, _from, to, value, data, operatorData, true);
729   }
730 
731   /**
732    * [ERC777 INTERFACE (12/13)]
733    * @dev Redeem the amount of tokens from the address 'msg.sender'.
734    * @param value Number of tokens to redeem.
735    * @param data Information attached to the redemption, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
736    */
737   function redeem(uint256 value, bytes calldata data)
738     external
739     isValidCertificate(data)
740   {
741     _redeem("", msg.sender, msg.sender, value, data, "");
742   }
743 
744   /**
745    * [ERC777 INTERFACE (13/13)]
746    * @dev Redeem the amount of tokens on behalf of the address from.
747    * @param from Token holder whose tokens will be redeemed (or address(0) to set from to msg.sender).
748    * @param value Number of tokens to redeem.
749    * @param data Information attached to the redemption.
750    * @param operatorData Information attached to the redemption, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
751    */
752   function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData)
753     external
754     isValidCertificate(operatorData)
755   {
756     address _from = (from == address(0)) ? msg.sender : from;
757 
758     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
759 
760     _redeem("", msg.sender, _from, value, data, operatorData);
761   }
762 
763   /********************** ERC777 INTERNAL FUNCTIONS ***************************/
764 
765   /**
766    * [INTERNAL]
767    * @dev Check if 'value' is multiple of the granularity.
768    * @param value The quantity that want's to be checked.
769    * @return 'true' if 'value' is a multiple of the granularity.
770    */
771   function _isMultiple(uint256 value) internal view returns(bool) {
772     return(value.div(_granularity).mul(_granularity) == value);
773   }
774 
775   /**
776    * [INTERNAL]
777    * @dev Check whether an address is a regular address or not.
778    * @param addr Address of the contract that has to be checked.
779    * @return 'true' if 'addr' is a regular address (not a contract).
780    */
781   function _isRegularAddress(address addr) internal view returns(bool) {
782     if (addr == address(0)) { return false; }
783     uint size;
784     assembly { size := extcodesize(addr) } // solhint-disable-line no-inline-assembly
785     return size == 0;
786   }
787 
788   /**
789    * [INTERNAL]
790    * @dev Indicate whether the operator address is an operator of the tokenHolder address.
791    * @param operator Address which may be an operator of 'tokenHolder'.
792    * @param tokenHolder Address of a token holder which may have the 'operator' address as an operator.
793    * @return 'true' if 'operator' is an operator of 'tokenHolder' and 'false' otherwise.
794    */
795   function _isOperatorFor(address operator, address tokenHolder) internal view returns (bool) {
796     return (operator == tokenHolder
797       || _authorizedOperator[operator][tokenHolder]
798       || (_isControllable && _isController[operator])
799     );
800   }
801 
802    /**
803     * [INTERNAL]
804     * @dev Perform the transfer of tokens.
805     * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
806     * @param operator The address performing the transfer.
807     * @param from Token holder.
808     * @param to Token recipient.
809     * @param value Number of tokens to transfer.
810     * @param data Information attached to the transfer.
811     * @param operatorData Information attached to the transfer by the operator (if any)..
812     * @param preventLocking 'true' if you want this function to throw when tokens are sent to a contract not
813     * implementing 'erc777tokenHolder'.
814     * ERC777 native transfer functions MUST set this parameter to 'true', and backwards compatible ERC20 transfer
815     * functions SHOULD set this parameter to 'false'.
816     */
817   function _transferWithData(
818     bytes32 partition,
819     address operator,
820     address from,
821     address to,
822     uint256 value,
823     bytes memory data,
824     bytes memory operatorData,
825     bool preventLocking
826   )
827     internal
828     nonReentrant
829   {
830     require(_isMultiple(value), "A9: Transfer Blocked - Token granularity");
831     require(to != address(0), "A6: Transfer Blocked - Receiver not eligible");
832     require(_balances[from] >= value, "A4: Transfer Blocked - Sender balance insufficient");
833 
834     _callSender(partition, operator, from, to, value, data, operatorData);
835 
836     _balances[from] = _balances[from].sub(value);
837     _balances[to] = _balances[to].add(value);
838 
839     _callRecipient(partition, operator, from, to, value, data, operatorData, preventLocking);
840 
841     emit TransferWithData(operator, from, to, value, data, operatorData);
842   }
843 
844   /**
845    * [INTERNAL]
846    * @dev Perform the token redemption.
847    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
848    * @param operator The address performing the redemption.
849    * @param from Token holder whose tokens will be redeemed.
850    * @param value Number of tokens to redeem.
851    * @param data Information attached to the redemption.
852    * @param operatorData Information attached to the redemption, by the operator (if any).
853    */
854   function _redeem(bytes32 partition, address operator, address from, uint256 value, bytes memory data, bytes memory operatorData)
855     internal
856     nonReentrant
857   {
858     require(_isMultiple(value), "A9: Transfer Blocked - Token granularity");
859     require(from != address(0), "A5: Transfer Blocked - Sender not eligible");
860     require(_balances[from] >= value, "A4: Transfer Blocked - Sender balance insufficient");
861 
862     _callSender(partition, operator, from, address(0), value, data, operatorData);
863 
864     _balances[from] = _balances[from].sub(value);
865     _totalSupply = _totalSupply.sub(value);
866 
867     emit Redeemed(operator, from, value, data, operatorData);
868   }
869 
870   /**
871    * [INTERNAL]
872    * @dev Check for 'ERC777TokensSender' hook on the sender and call it.
873    * May throw according to 'preventLocking'.
874    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
875    * @param operator Address which triggered the balance decrease (through transfer or redemption).
876    * @param from Token holder.
877    * @param to Token recipient for a transfer and 0x for a redemption.
878    * @param value Number of tokens the token holder balance is decreased by.
879    * @param data Extra information.
880    * @param operatorData Extra information, attached by the operator (if any).
881    */
882   function _callSender(
883     bytes32 partition,
884     address operator,
885     address from,
886     address to,
887     uint256 value,
888     bytes memory data,
889     bytes memory operatorData
890   )
891     internal
892   {
893     address senderImplementation;
894     senderImplementation = interfaceAddr(from, "ERC777TokensSender");
895 
896     if (senderImplementation != address(0)) {
897       IERC777TokensSender(senderImplementation).tokensToTransfer(partition, operator, from, to, value, data, operatorData);
898     }
899   }
900 
901   /**
902    * [INTERNAL]
903    * @dev Check for 'ERC777TokensRecipient' hook on the recipient and call it.
904    * May throw according to 'preventLocking'.
905    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
906    * @param operator Address which triggered the balance increase (through transfer or issuance).
907    * @param from Token holder for a transfer and 0x for an issuance.
908    * @param to Token recipient.
909    * @param value Number of tokens the recipient balance is increased by.
910    * @param data Extra information, intended for the token holder ('from').
911    * @param operatorData Extra information attached by the operator (if any).
912    * @param preventLocking 'true' if you want this function to throw when tokens are sent to a contract not
913    * implementing 'ERC777TokensRecipient'.
914    * ERC777 native transfer functions MUST set this parameter to 'true', and backwards compatible ERC20 transfer
915    * functions SHOULD set this parameter to 'false'.
916    */
917   function _callRecipient(
918     bytes32 partition,
919     address operator,
920     address from,
921     address to,
922     uint256 value,
923     bytes memory data,
924     bytes memory operatorData,
925     bool preventLocking
926   )
927     internal
928   {
929     address recipientImplementation;
930     recipientImplementation = interfaceAddr(to, "ERC777TokensRecipient");
931 
932     if (recipientImplementation != address(0)) {
933       IERC777TokensRecipient(recipientImplementation).tokensReceived(partition, operator, from, to, value, data, operatorData);
934     } else if (preventLocking) {
935       require(_isRegularAddress(to), "A6: Transfer Blocked - Receiver not eligible");
936     }
937   }
938 
939   /**
940    * [INTERNAL]
941    * @dev Perform the issuance of tokens.
942    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
943    * @param operator Address which triggered the issuance.
944    * @param to Token recipient.
945    * @param value Number of tokens issued.
946    * @param data Information attached to the issuance, and intended for the recipient (to).
947    * @param operatorData Information attached to the issuance by the operator (if any).
948    */
949   function _issue(bytes32 partition, address operator, address to, uint256 value, bytes memory data, bytes memory operatorData) internal nonReentrant {
950     require(_isMultiple(value), "A9: Transfer Blocked - Token granularity");
951     require(to != address(0), "A6: Transfer Blocked - Receiver not eligible");
952 
953     _totalSupply = _totalSupply.add(value);
954     _balances[to] = _balances[to].add(value);
955 
956     _callRecipient(partition, operator, address(0), to, value, data, operatorData, true);
957 
958     emit Issued(operator, to, value, data, operatorData);
959   }
960 
961   /********************** ERC777 OPTIONAL FUNCTIONS ***************************/
962 
963   /**
964    * [NOT MANDATORY FOR ERC777 STANDARD]
965    * @dev Set list of token controllers.
966    * @param operators Controller addresses.
967    */
968   function _setControllers(address[] memory operators) internal {
969     for (uint i = 0; i<_controllers.length; i++){
970       _isController[_controllers[i]] = false;
971     }
972     for (uint j = 0; j<operators.length; j++){
973       _isController[operators[j]] = true;
974     }
975     _controllers = operators;
976   }
977 
978 }
979 
980 /**
981  * @title ERC1410
982  * @dev ERC1410 logic
983  */
984 contract ERC1410 is IERC1410, ERC777{
985 
986   /******************** Mappings to find partition ******************************/
987   // List of partitions.
988   bytes32[] internal _totalPartitions;
989 
990   // Mapping from partition to global balance of corresponding partition.
991   mapping (bytes32 => uint256) internal _totalSupplyByPartition;
992 
993   // Mapping from tokenHolder to their partitions.
994   mapping (address => bytes32[]) internal _partitionsOf;
995 
996   // Mapping from (tokenHolder, partition) to balance of corresponding partition.
997   mapping (address => mapping (bytes32 => uint256)) internal _balanceOfByPartition;
998 
999   // Mapping from tokenHolder to their default partitions (for ERC777 and ERC20 compatibility).
1000   mapping (address => bytes32[]) internal _defaultPartitionsOf;
1001 
1002   // List of token default partitions (for ERC20 compatibility).
1003   bytes32[] internal _tokenDefaultPartitions;
1004   /****************************************************************************/
1005 
1006   /**************** Mappings to find partition operators ************************/
1007   // Mapping from (tokenHolder, partition, operator) to 'approved for partition' status. [TOKEN-HOLDER-SPECIFIC]
1008   mapping (address => mapping (bytes32 => mapping (address => bool))) internal _authorizedOperatorByPartition;
1009 
1010   // Mapping from partition to controllers for the partition. [NOT TOKEN-HOLDER-SPECIFIC]
1011   mapping (bytes32 => address[]) internal _controllersByPartition;
1012 
1013   // Mapping from (partition, operator) to PartitionController status. [NOT TOKEN-HOLDER-SPECIFIC]
1014   mapping (bytes32 => mapping (address => bool)) internal _isControllerByPartition;
1015   /****************************************************************************/
1016 
1017   /**
1018    * [ERC1410 CONSTRUCTOR]
1019    * @dev Initialize ERC1410 parameters + register
1020    * the contract implementation in ERC820Registry.
1021    * @param name Name of the token.
1022    * @param symbol Symbol of the token.
1023    * @param granularity Granularity of the token.
1024    * @param controllers Array of initial controllers.
1025    * @param certificateSigner Address of the off-chain service which signs the
1026    * conditional ownership certificates required for token transfers, issuance,
1027    * redemption (Cf. CertificateController.sol).
1028    */
1029   constructor(
1030     string memory name,
1031     string memory symbol,
1032     uint256 granularity,
1033     address[] memory controllers,
1034     address certificateSigner,
1035     bytes32[] memory tokenDefaultPartitions
1036   )
1037     public
1038     ERC777(name, symbol, granularity, controllers, certificateSigner)
1039   {
1040     _tokenDefaultPartitions = tokenDefaultPartitions;
1041   }
1042 
1043   /********************** ERC1410 EXTERNAL FUNCTIONS **************************/
1044 
1045   /**
1046    * [ERC1410 INTERFACE (1/10)]
1047    * @dev Get balance of a tokenholder for a specific partition.
1048    * @param partition Name of the partition.
1049    * @param tokenHolder Address for which the balance is returned.
1050    * @return Amount of token of partition 'partition' held by 'tokenHolder' in the token contract.
1051    */
1052   function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256) {
1053     return _balanceOfByPartition[tokenHolder][partition];
1054   }
1055 
1056   /**
1057    * [ERC1410 INTERFACE (2/10)]
1058    * @dev Get partitions index of a tokenholder.
1059    * @param tokenHolder Address for which the partitions index are returned.
1060    * @return Array of partitions index of 'tokenHolder'.
1061    */
1062   function partitionsOf(address tokenHolder) external view returns (bytes32[] memory) {
1063     return _partitionsOf[tokenHolder];
1064   }
1065 
1066   /**
1067    * [ERC1410 INTERFACE (3/10)]
1068    * @dev Transfer tokens from a specific partition.
1069    * @param partition Name of the partition.
1070    * @param to Token recipient.
1071    * @param value Number of tokens to transfer.
1072    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1073    * @return Destination partition.
1074    */
1075   function transferByPartition(
1076     bytes32 partition,
1077     address to,
1078     uint256 value,
1079     bytes calldata data
1080   )
1081     external
1082     isValidCertificate(data)
1083     returns (bytes32)
1084   {
1085     return _transferByPartition(partition, msg.sender, msg.sender, to, value, data, "");
1086   }
1087 
1088   /**
1089    * [ERC1410 INTERFACE (4/10)]
1090    * @dev Transfer tokens from a specific partition through an operator.
1091    * @param partition Name of the partition.
1092    * @param from Token holder.
1093    * @param to Token recipient.
1094    * @param value Number of tokens to transfer.
1095    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1096    * @param operatorData Information attached to the transfer, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1097    * @return Destination partition.
1098    */
1099   function operatorTransferByPartition(
1100     bytes32 partition,
1101     address from,
1102     address to,
1103     uint256 value,
1104     bytes calldata data,
1105     bytes calldata operatorData
1106   )
1107     external
1108     isValidCertificate(operatorData)
1109     returns (bytes32)
1110   {
1111     address _from = (from == address(0)) ? msg.sender : from;
1112     require(_isOperatorForPartition(partition, msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1113 
1114     return _transferByPartition(partition, msg.sender, _from, to, value, data, operatorData);
1115   }
1116 
1117   /**
1118    * [ERC1410 INTERFACE (5/10)]
1119    * @dev Get default partitions to transfer from.
1120    * Function used for ERC777 and ERC20 backwards compatibility.
1121    * For example, a security token may return the bytes32("unrestricted").
1122    * @param tokenHolder Address for which we want to know the default partitions.
1123    * @return Array of default partitions.
1124    */
1125   function getDefaultPartitions(address tokenHolder) external view returns (bytes32[] memory) {
1126     return _defaultPartitionsOf[tokenHolder];
1127   }
1128 
1129   /**
1130    * [ERC1410 INTERFACE (6/10)]
1131    * @dev Set default partitions to transfer from.
1132    * Function used for ERC777 and ERC20 backwards compatibility.
1133    * @param partitions partitions to use by default when not specified.
1134    */
1135   function setDefaultPartitions(bytes32[] calldata partitions) external {
1136     _defaultPartitionsOf[msg.sender] = partitions;
1137   }
1138 
1139   /**
1140    * [ERC1410 INTERFACE (7/10)]
1141    * @dev Get controllers for a given partition.
1142    * Function used for ERC777 and ERC20 backwards compatibility.
1143    * @param partition Name of the partition.
1144    * @return Array of controllers for partition.
1145    */
1146   function controllersByPartition(bytes32 partition) external view returns (address[] memory) {
1147     return _controllersByPartition[partition];
1148   }
1149 
1150   /**
1151    * [ERC1410 INTERFACE (8/10)]
1152    * @dev Set 'operator' as an operator for 'msg.sender' for a given partition.
1153    * @param partition Name of the partition.
1154    * @param operator Address to set as an operator for 'msg.sender'.
1155    */
1156   function authorizeOperatorByPartition(bytes32 partition, address operator) external {
1157     _authorizedOperatorByPartition[msg.sender][partition][operator] = true;
1158     emit AuthorizedOperatorByPartition(partition, operator, msg.sender);
1159   }
1160 
1161   /**
1162    * [ERC1410 INTERFACE (9/10)]
1163    * @dev Remove the right of the operator address to be an operator on a given
1164    * partition for 'msg.sender' and to transfer and redeem tokens on its behalf.
1165    * @param partition Name of the partition.
1166    * @param operator Address to rescind as an operator on given partition for 'msg.sender'.
1167    */
1168   function revokeOperatorByPartition(bytes32 partition, address operator) external {
1169     _authorizedOperatorByPartition[msg.sender][partition][operator] = false;
1170     emit RevokedOperatorByPartition(partition, operator, msg.sender);
1171   }
1172 
1173   /**
1174    * [ERC1410 INTERFACE (10/10)]
1175    * @dev Indicate whether the operator address is an operator of the tokenHolder
1176    * address for the given partition.
1177    * @param partition Name of the partition.
1178    * @param operator Address which may be an operator of tokenHolder for the given partition.
1179    * @param tokenHolder Address of a token holder which may have the operator address as an operator for the given partition.
1180    * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition 'partition' and 'false' otherwise.
1181    */
1182   function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool) {
1183     return _isOperatorForPartition(partition, operator, tokenHolder);
1184   }
1185 
1186   /********************** ERC1410 INTERNAL FUNCTIONS **************************/
1187 
1188   /**
1189    * [INTERNAL]
1190    * @dev Indicate whether the operator address is an operator of the tokenHolder
1191    * address for the given partition.
1192    * @param partition Name of the partition.
1193    * @param operator Address which may be an operator of tokenHolder for the given partition.
1194    * @param tokenHolder Address of a token holder which may have the operator address as an operator for the given partition.
1195    * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition 'partition' and 'false' otherwise.
1196    */
1197    function _isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) internal view returns (bool) {
1198      return (_isOperatorFor(operator, tokenHolder)
1199        || _authorizedOperatorByPartition[tokenHolder][partition][operator]
1200        || (_isControllable && _isControllerByPartition[partition][operator])
1201      );
1202    }
1203 
1204   /**
1205    * [INTERNAL]
1206    * @dev Transfer tokens from a specific partition.
1207    * @param fromPartition Partition of the tokens to transfer.
1208    * @param operator The address performing the transfer.
1209    * @param from Token holder.
1210    * @param to Token recipient.
1211    * @param value Number of tokens to transfer.
1212    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1213    * @param operatorData Information attached to the transfer, by the operator (if any).
1214    * @return Destination partition.
1215    */
1216   function _transferByPartition(
1217     bytes32 fromPartition,
1218     address operator,
1219     address from,
1220     address to,
1221     uint256 value,
1222     bytes memory data,
1223     bytes memory operatorData
1224   )
1225     internal
1226     returns (bytes32)
1227   {
1228     require(_balanceOfByPartition[from][fromPartition] >= value, "A4: Transfer Blocked - Sender balance insufficient"); // ensure enough funds
1229 
1230     bytes32 toPartition = fromPartition;
1231 
1232     if(operatorData.length != 0 && data.length != 0) {
1233       toPartition = _getDestinationPartition(fromPartition, data);
1234     }
1235 
1236     _removeTokenFromPartition(from, fromPartition, value);
1237     _transferWithData(fromPartition, operator, from, to, value, data, operatorData, true);
1238     _addTokenToPartition(to, toPartition, value);
1239 
1240     emit TransferByPartition(fromPartition, operator, from, to, value, data, operatorData);
1241 
1242     if(toPartition != fromPartition) {
1243       emit ChangedPartition(fromPartition, toPartition, value);
1244     }
1245 
1246     return toPartition;
1247   }
1248 
1249   /**
1250    * [INTERNAL]
1251    * @dev Remove a token from a specific partition.
1252    * @param from Token holder.
1253    * @param partition Name of the partition.
1254    * @param value Number of tokens to transfer.
1255    */
1256   function _removeTokenFromPartition(address from, bytes32 partition, uint256 value) internal {
1257     _balanceOfByPartition[from][partition] = _balanceOfByPartition[from][partition].sub(value);
1258     _totalSupplyByPartition[partition] = _totalSupplyByPartition[partition].sub(value);
1259 
1260     // If the balance of the TokenHolder's partition is zero, finds and deletes the partition.
1261     if(_balanceOfByPartition[from][partition] == 0) {
1262       for (uint i = 0; i < _partitionsOf[from].length; i++) {
1263         if(_partitionsOf[from][i] == partition) {
1264           _partitionsOf[from][i] = _partitionsOf[from][_partitionsOf[from].length - 1];
1265           delete _partitionsOf[from][_partitionsOf[from].length - 1];
1266           _partitionsOf[from].length--;
1267           break;
1268         }
1269       }
1270     }
1271 
1272     // If the total supply is zero, finds and deletes the partition.
1273     if(_totalSupplyByPartition[partition] == 0) {
1274       for (uint i = 0; i < _totalPartitions.length; i++) {
1275         if(_totalPartitions[i] == partition) {
1276           _totalPartitions[i] = _totalPartitions[_totalPartitions.length - 1];
1277           delete _totalPartitions[_totalPartitions.length - 1];
1278           _totalPartitions.length--;
1279           break;
1280         }
1281       }
1282     }
1283   }
1284 
1285   /**
1286    * [INTERNAL]
1287    * @dev Add a token to a specific partition.
1288    * @param to Token recipient.
1289    * @param partition Name of the partition.
1290    * @param value Number of tokens to transfer.
1291    */
1292   function _addTokenToPartition(address to, bytes32 partition, uint256 value) internal {
1293     if(value != 0) {
1294       if(_balanceOfByPartition[to][partition] == 0) {
1295         _partitionsOf[to].push(partition);
1296       }
1297       _balanceOfByPartition[to][partition] = _balanceOfByPartition[to][partition].add(value);
1298 
1299       if(_totalSupplyByPartition[partition] == 0) {
1300         _totalPartitions.push(partition);
1301       }
1302       _totalSupplyByPartition[partition] = _totalSupplyByPartition[partition].add(value);
1303     }
1304   }
1305 
1306   /**
1307    * [INTERNAL]
1308    * @dev Retrieve the destination partition from the 'data' field.
1309    * By convention, a partition change is requested ONLY when 'data' starts
1310    * with the flag: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1311    * When the flag is detected, the destination tranche is extracted from the
1312    * 32 bytes following the flag.
1313    * @param fromPartition Partition of the tokens to transfer.
1314    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1315    * @return Destination partition.
1316    */
1317   function _getDestinationPartition(bytes32 fromPartition, bytes memory data) internal pure returns(bytes32 toPartition) {
1318     bytes32 changePartitionFlag = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1319     bytes32 flag;
1320     assembly {
1321       flag := mload(add(data, 32))
1322     }
1323     if(flag == changePartitionFlag) {
1324       assembly {
1325         toPartition := mload(add(data, 64))
1326       }
1327     } else {
1328       toPartition = fromPartition;
1329     }
1330   }
1331 
1332   /**
1333    * [INTERNAL]
1334    * @dev Get the sender's default partition if setup, or the global default partition if not.
1335    * @param tokenHolder Address for which the default partition is returned.
1336    * @return Default partition.
1337    */
1338   function _getDefaultPartitions(address tokenHolder) internal view returns(bytes32[] memory) {
1339     if(_defaultPartitionsOf[tokenHolder].length != 0) {
1340       return _defaultPartitionsOf[tokenHolder];
1341     } else {
1342       return _tokenDefaultPartitions;
1343     }
1344   }
1345 
1346 
1347   /********************* ERC1410 OPTIONAL FUNCTIONS ***************************/
1348 
1349   /**
1350    * [NOT MANDATORY FOR ERC1410 STANDARD]
1351    * @dev Get list of existing partitions.
1352    * @return Array of all exisiting partitions.
1353    */
1354   function totalPartitions() external view returns (bytes32[] memory) {
1355     return _totalPartitions;
1356   }
1357 
1358   /**
1359    * [NOT MANDATORY FOR ERC1410 STANDARD][SHALL BE CALLED ONLY FROM ERC1400]
1360    * @dev Set list of token partition controllers.
1361    * @param partition Name of the partition.
1362    * @param operators Controller addresses.
1363    */
1364    function _setPartitionControllers(bytes32 partition, address[] memory operators) internal {
1365      for (uint i = 0; i<_controllersByPartition[partition].length; i++){
1366        _isControllerByPartition[partition][_controllersByPartition[partition][i]] = false;
1367      }
1368      for (uint j = 0; j<operators.length; j++){
1369        _isControllerByPartition[partition][operators[j]] = true;
1370      }
1371      _controllersByPartition[partition] = operators;
1372    }
1373 
1374   /************** ERC777 BACKWARDS RETROCOMPATIBILITY *************************/
1375 
1376   /**
1377    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1378    * @dev Transfer the value of tokens from the address 'msg.sender' to the address 'to'.
1379    * @param to Token recipient.
1380    * @param value Number of tokens to transfer.
1381    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1382    */
1383   function transferWithData(address to, uint256 value, bytes calldata data)
1384     external
1385     isValidCertificate(data)
1386   {
1387     _transferByDefaultPartitions(msg.sender, msg.sender, to, value, data, "");
1388   }
1389 
1390   /**
1391    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1392    * @dev Transfer the value of tokens on behalf of the address from to the address to.
1393    * @param from Token holder (or 'address(0)'' to set from to 'msg.sender').
1394    * @param to Token recipient.
1395    * @param value Number of tokens to transfer.
1396    * @param data Information attached to the transfer, and intended for the token holder ('from'). [CAN CONTAIN THE DESTINATION PARTITION]
1397    * @param operatorData Information attached to the transfer by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1398    */
1399   function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
1400     external
1401     isValidCertificate(operatorData)
1402   {
1403     address _from = (from == address(0)) ? msg.sender : from;
1404 
1405     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1406 
1407     _transferByDefaultPartitions(msg.sender, _from, to, value, data, operatorData);
1408   }
1409 
1410   /**
1411    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1412    * @dev Empty function to erase ERC777 redeem() function since it doesn't handle partitions.
1413    */
1414   function redeem(uint256 /*value*/, bytes calldata /*data*/) external { // Comments to avoid compilation warnings for unused variables.
1415   }
1416 
1417   /**
1418    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1419    * @dev Empty function to erase ERC777 redeemFrom() function since it doesn't handle partitions.
1420    */
1421   function redeemFrom(address /*from*/, uint256 /*value*/, bytes calldata /*data*/, bytes calldata /*operatorData*/) external { // Comments to avoid compilation warnings for unused variables.
1422   }
1423 
1424   /**
1425    * [NOT MANDATORY FOR ERC1410 STANDARD]
1426    * @dev Transfer tokens from default partitions.
1427    * @param operator The address performing the transfer.
1428    * @param from Token holder.
1429    * @param to Token recipient.
1430    * @param value Number of tokens to transfer.
1431    * @param data Information attached to the transfer, and intended for the token holder ('from') [CAN CONTAIN THE DESTINATION PARTITION].
1432    * @param operatorData Information attached to the transfer by the operator (if any).
1433    */
1434   function _transferByDefaultPartitions(
1435     address operator,
1436     address from,
1437     address to,
1438     uint256 value,
1439     bytes memory data,
1440     bytes memory operatorData
1441   )
1442     internal
1443   {
1444     bytes32[] memory _partitions = _getDefaultPartitions(from);
1445     require(_partitions.length != 0, "A8: Transfer Blocked - Token restriction");
1446 
1447     uint256 _remainingValue = value;
1448     uint256 _localBalance;
1449 
1450     for (uint i = 0; i < _partitions.length; i++) {
1451       _localBalance = _balanceOfByPartition[from][_partitions[i]];
1452       if(_remainingValue <= _localBalance) {
1453         _transferByPartition(_partitions[i], operator, from, to, _remainingValue, data, operatorData);
1454         _remainingValue = 0;
1455         break;
1456       } else {
1457         _transferByPartition(_partitions[i], operator, from, to, _localBalance, data, operatorData);
1458         _remainingValue = _remainingValue - _localBalance;
1459       }
1460     }
1461 
1462     require(_remainingValue == 0, "A8: Transfer Blocked - Token restriction");
1463   }
1464 }
1465 
1466 
1467 /**
1468  * @title ERC1400
1469  * @dev ERC1400 logic
1470  */
1471 contract ERC1400 is IERC1400, ERC1410, MinterRole {
1472 
1473   struct Doc {
1474     string docURI;
1475     bytes32 docHash;
1476   }
1477 
1478   // Mapping for token URIs.
1479   mapping(bytes32 => Doc) internal _documents;
1480 
1481   // Indicate whether the token can still be issued by the issuer or not anymore.
1482   bool internal _isIssuable;
1483 
1484   /**
1485    * @dev Modifier to verify if token is issuable.
1486    */
1487   modifier issuableToken() {
1488     require(_isIssuable, "A8, Transfer Blocked - Token restriction");
1489     _;
1490   }
1491 
1492   /**
1493    * [ERC1400 CONSTRUCTOR]
1494    * @dev Initialize ERC1400 + register
1495    * the contract implementation in ERC820Registry.
1496    * @param name Name of the token.
1497    * @param symbol Symbol of the token.
1498    * @param granularity Granularity of the token.
1499    * @param controllers Array of initial controllers.
1500    * @param certificateSigner Address of the off-chain service which signs the
1501    * conditional ownership certificates required for token transfers, issuance,
1502    * redemption (Cf. CertificateController.sol).
1503    */
1504   constructor(
1505     string memory name,
1506     string memory symbol,
1507     uint256 granularity,
1508     address[] memory controllers,
1509     address certificateSigner,
1510     bytes32[] memory tokenDefaultPartitions
1511   )
1512     public
1513     ERC1410(name, symbol, granularity, controllers, certificateSigner, tokenDefaultPartitions)
1514   {
1515     setInterfaceImplementation("ERC1400Token", address(this));
1516     _isControllable = true;
1517     _isIssuable = true;
1518   }
1519 
1520   /********************** ERC1400 EXTERNAL FUNCTIONS **************************/
1521 
1522   /**
1523    * [ERC1400 INTERFACE (1/9)]
1524    * @dev Access a document associated with the token.
1525    * @param name Short name (represented as a bytes32) associated to the document.
1526    * @return Requested document + document hash.
1527    */
1528   function getDocument(bytes32 name) external view returns (string memory, bytes32) {
1529     require(bytes(_documents[name].docURI).length != 0, "Action Blocked - Empty document");
1530     return (
1531       _documents[name].docURI,
1532       _documents[name].docHash
1533     );
1534   }
1535 
1536   /**
1537    * [ERC1400 INTERFACE (2/9)]
1538    * @dev Associate a document with the token.
1539    * @param name Short name (represented as a bytes32) associated to the document.
1540    * @param uri Document content.
1541    * @param documentHash Hash of the document [optional parameter].
1542    */
1543   function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external onlyOwner {
1544     _documents[name] = Doc({
1545       docURI: uri,
1546       docHash: documentHash
1547     });
1548     emit Document(name, uri, documentHash);
1549   }
1550 
1551   /**
1552    * [ERC1400 INTERFACE (3/9)]
1553    * @dev Know if the token can be controlled by operators.
1554    * If a token returns 'false' for 'isControllable()'' then it MUST always return 'false' in the future.
1555    * @return bool 'true' if the token can still be controlled by operators, 'false' if it can't anymore.
1556    */
1557   function isControllable() external view returns (bool) {
1558     return _isControllable;
1559   }
1560 
1561   /**
1562    * [ERC1400 INTERFACE (4/9)]
1563    * @dev Know if new tokens can be issued in the future.
1564    * @return bool 'true' if tokens can still be issued by the issuer, 'false' if they can't anymore.
1565    */
1566   function isIssuable() external view returns (bool) {
1567     return _isIssuable;
1568   }
1569 
1570   /**
1571    * [ERC1400 INTERFACE (5/9)]
1572    * @dev Issue tokens from a specific partition.
1573    * @param partition Name of the partition.
1574    * @param tokenHolder Address for which we want to issue tokens.
1575    * @param value Number of tokens issued.
1576    * @param data Information attached to the issuance, by the issuer. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1577    */
1578   function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data)
1579     external
1580     onlyMinter
1581     issuableToken
1582     isValidCertificate(data)
1583   {
1584     _issueByPartition(partition, msg.sender, tokenHolder, value, data, "");
1585   }
1586 
1587   /**
1588    * [ERC1400 INTERFACE (6/9)]
1589    * @dev Redeem tokens of a specific partition.
1590    * @param partition Name of the partition.
1591    * @param value Number of tokens redeemed.
1592    * @param data Information attached to the redemption, by the redeemer. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1593    */
1594   function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data)
1595     external
1596     isValidCertificate(data)
1597   {
1598     _redeemByPartition(partition, msg.sender, msg.sender, value, data, "");
1599   }
1600 
1601   /**
1602    * [ERC1400 INTERFACE (7/9)]
1603    * @dev Redeem tokens of a specific partition.
1604    * @param partition Name of the partition.
1605    * @param tokenHolder Address for which we want to redeem tokens.
1606    * @param value Number of tokens redeemed.
1607    * @param data Information attached to the redemption.
1608    * @param operatorData Information attached to the redemption, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1609    */
1610   function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData)
1611     external
1612     isValidCertificate(operatorData)
1613   {
1614     address _from = (tokenHolder == address(0)) ? msg.sender : tokenHolder;
1615     require(_isOperatorForPartition(partition, msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1616 
1617     _redeemByPartition(partition, msg.sender, _from, value, data, operatorData);
1618   }
1619 
1620   /**
1621    * [ERC1400 INTERFACE (8/9)]
1622    * @dev Know the reason on success or failure based on the EIP-1066 application-specific status codes.
1623    * @param partition Name of the partition.
1624    * @param to Token recipient.
1625    * @param value Number of tokens to transfer.
1626    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1627    * @return ESC (Ethereum Status Code) following the EIP-1066 standard.
1628    * @return Additional bytes32 parameter that can be used to define
1629    * application specific reason codes with additional details (for example the
1630    * transfer restriction rule responsible for making the transfer operation invalid).
1631    * @return Destination partition.
1632    */
1633   function canTransferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data)
1634     external
1635     view
1636     returns (byte, bytes32, bytes32)
1637   {
1638     if(!_checkCertificate(data, 0, 0xf3d490db)) { // 4 first bytes of keccak256(transferByPartition(bytes32,address,uint256,bytes))
1639       return(hex"A3", "", partition); // Transfer Blocked - Sender lockup period not ended
1640     } else {
1641       return _canTransfer(partition, msg.sender, msg.sender, to, value, data, "");
1642     }
1643   }
1644 
1645   /**
1646    * [ERC1400 INTERFACE (9/9)]
1647    * @dev Know the reason on success or failure based on the EIP-1066 application-specific status codes.
1648    * @param partition Name of the partition.
1649    * @param from Token holder.
1650    * @param to Token recipient.
1651    * @param value Number of tokens to transfer.
1652    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1653    * @param operatorData Information attached to the transfer, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1654    * @return ESC (Ethereum Status Code) following the EIP-1066 standard.
1655    * @return Additional bytes32 parameter that can be used to define
1656    * application specific reason codes with additional details (for example the
1657    * transfer restriction rule responsible for making the transfer operation invalid).
1658    * @return Destination partition.
1659    */
1660   function canOperatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
1661     external
1662     view
1663     returns (byte, bytes32, bytes32)
1664   {
1665     if(!_checkCertificate(operatorData, 0, 0x8c0dee9c)) { // 4 first bytes of keccak256(operatorTransferByPartition(bytes32,address,address,uint256,bytes,bytes))
1666       return(hex"A3", "", partition); // Transfer Blocked - Sender lockup period not ended
1667     } else {
1668       address _from = (from == address(0)) ? msg.sender : from;
1669       return _canTransfer(partition, msg.sender, _from, to, value, data, operatorData);
1670     }
1671   }
1672 
1673   /********************** ERC1400 INTERNAL FUNCTIONS **************************/
1674 
1675   /**
1676    * [INTERNAL]
1677    * @dev Know the reason on success or failure based on the EIP-1066 application-specific status codes.
1678    * @param partition Name of the partition.
1679    * @param operator The address performing the transfer.
1680    * @param from Token holder.
1681    * @param to Token recipient.
1682    * @param value Number of tokens to transfer.
1683    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1684    * @param operatorData Information attached to the transfer, by the operator (if any).
1685    * @return ESC (Ethereum Status Code) following the EIP-1066 standard.
1686    * @return Additional bytes32 parameter that can be used to define
1687    * application specific reason codes with additional details (for example the
1688    * transfer restriction rule responsible for making the transfer operation invalid).
1689    * @return Destination partition.
1690    */
1691    function _canTransfer(bytes32 partition, address operator, address from, address to, uint256 value, bytes memory data, bytes memory operatorData)
1692      internal
1693      view
1694      returns (byte, bytes32, bytes32)
1695    {
1696      if(!_isOperatorForPartition(partition, operator, from))
1697        return(hex"A7", "", partition); // "Transfer Blocked - Identity restriction"
1698 
1699      if((_balances[from] < value) || (_balanceOfByPartition[from][partition] < value))
1700        return(hex"A4", "", partition); // Transfer Blocked - Sender balance insufficient
1701 
1702      if(to == address(0))
1703        return(hex"A6", "", partition); // Transfer Blocked - Receiver not eligible
1704 
1705      address senderImplementation;
1706      address recipientImplementation;
1707      senderImplementation = interfaceAddr(from, "ERC777TokensSender");
1708      recipientImplementation = interfaceAddr(to, "ERC777TokensRecipient");
1709 
1710      if((senderImplementation != address(0))
1711        && !IERC777TokensSender(senderImplementation).canTransfer(partition, from, to, value, data, operatorData))
1712        return(hex"A5", "", partition); // Transfer Blocked - Sender not eligible
1713 
1714      if((recipientImplementation != address(0))
1715        && !IERC777TokensRecipient(recipientImplementation).canReceive(partition, from, to, value, data, operatorData))
1716        return(hex"A6", "", partition); // Transfer Blocked - Receiver not eligible
1717 
1718      if(!_isMultiple(value))
1719        return(hex"A9", "", partition); // Transfer Blocked - Token granularity
1720 
1721      return(hex"A2", "", partition);  // Transfer Verified - Off-Chain approval for restricted token
1722    }
1723 
1724   /**
1725    * [INTERNAL]
1726    * @dev Issue tokens from a specific partition.
1727    * @param toPartition Name of the partition.
1728    * @param operator The address performing the issuance.
1729    * @param to Token recipient.
1730    * @param value Number of tokens to issue.
1731    * @param data Information attached to the issuance.
1732    * @param operatorData Information attached to the issuance, by the operator (if any).
1733    */
1734   function _issueByPartition(
1735     bytes32 toPartition,
1736     address operator,
1737     address to,
1738     uint256 value,
1739     bytes memory data,
1740     bytes memory operatorData
1741   )
1742     internal
1743   {
1744     _issue(toPartition, operator, to, value, data, operatorData);
1745     _addTokenToPartition(to, toPartition, value);
1746 
1747     emit IssuedByPartition(toPartition, operator, to, value, data, operatorData);
1748   }
1749 
1750   /**
1751    * [INTERNAL]
1752    * @dev Redeem tokens of a specific partition.
1753    * @param fromPartition Name of the partition.
1754    * @param operator The address performing the redemption.
1755    * @param from Token holder whose tokens will be redeemed.
1756    * @param value Number of tokens to redeem.
1757    * @param data Information attached to the redemption.
1758    * @param operatorData Information attached to the redemption, by the operator (if any).
1759    */
1760   function _redeemByPartition(
1761     bytes32 fromPartition,
1762     address operator,
1763     address from,
1764     uint256 value,
1765     bytes memory data,
1766     bytes memory operatorData
1767   )
1768     internal
1769   {
1770     require(_balanceOfByPartition[from][fromPartition] >= value, "A4: Transfer Blocked - Sender balance insufficient");
1771 
1772     _removeTokenFromPartition(from, fromPartition, value);
1773     _redeem(fromPartition, operator, from, value, data, operatorData);
1774 
1775     emit RedeemedByPartition(fromPartition, operator, from, value, data, operatorData);
1776   }
1777 
1778   /********************** ERC1400 OPTIONAL FUNCTIONS **************************/
1779 
1780   /**
1781    * [NOT MANDATORY FOR ERC1400 STANDARD]
1782    * @dev Definitely renounce the possibility to control tokens on behalf of tokenHolders.
1783    * Once set to false, '_isControllable' can never be set to 'true' again.
1784    */
1785   function renounceControl() external onlyOwner {
1786     _isControllable = false;
1787   }
1788 
1789   /**
1790    * [NOT MANDATORY FOR ERC1400 STANDARD]
1791    * @dev Definitely renounce the possibility to issue new tokens.
1792    * Once set to false, '_isIssuable' can never be set to 'true' again.
1793    */
1794   function renounceIssuance() external onlyOwner {
1795     _isIssuable = false;
1796   }
1797 
1798   /**
1799    * [NOT MANDATORY FOR ERC1400 STANDARD]
1800    * @dev Set list of token controllers.
1801    * @param operators Controller addresses.
1802    */
1803   function setControllers(address[] calldata operators) external onlyOwner {
1804     _setControllers(operators);
1805   }
1806 
1807   /**
1808    * [NOT MANDATORY FOR ERC1400 STANDARD]
1809    * @dev Set list of token partition controllers.
1810    * @param partition Name of the partition.
1811    * @param operators Controller addresses.
1812    */
1813    function setPartitionControllers(bytes32 partition, address[] calldata operators) external onlyOwner {
1814      _setPartitionControllers(partition, operators);
1815    }
1816 
1817    /**
1818    * @dev Add a certificate signer for the token.
1819    * @param operator Address to set as a certificate signer.
1820    * @param authorized 'true' if operator shall be accepted as certificate signer, 'false' if not.
1821    */
1822   function setCertificateSigner(address operator, bool authorized) external onlyOwner {
1823     _setCertificateSigner(operator, authorized);
1824   }
1825 
1826   /************* ERC1410/ERC777 BACKWARDS RETROCOMPATIBILITY ******************/
1827 
1828   /**
1829    * [NOT MANDATORY FOR ERC1400 STANDARD]
1830    * @dev Get token default partitions to send from.
1831    * Function used for ERC777 and ERC20 backwards compatibility.
1832    * For example, a security token may return the bytes32("unrestricted").
1833    * @return Default partitions.
1834    */
1835   function getTokenDefaultPartitions() external view returns (bytes32[] memory) {
1836     return _tokenDefaultPartitions;
1837   }
1838 
1839   /**
1840    * [NOT MANDATORY FOR ERC1400 STANDARD]
1841    * @dev Set token default partitions to send from.
1842    * Function used for ERC777 and ERC20 backwards compatibility.
1843    * @param defaultPartitions Partitions to use by default when not specified.
1844    */
1845   function setTokenDefaultPartitions(bytes32[] calldata defaultPartitions) external onlyOwner {
1846     _tokenDefaultPartitions = defaultPartitions;
1847   }
1848 
1849 
1850   /**
1851    * [NOT MANDATORY FOR ERC1400 STANDARD][OVERRIDES ERC1410 METHOD]
1852    * @dev Redeem the value of tokens from the address 'msg.sender'.
1853    * @param value Number of tokens to redeem.
1854    * @param data Information attached to the redemption, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1855    */
1856   function redeem(uint256 value, bytes calldata data)
1857     external
1858     isValidCertificate(data)
1859   {
1860     _redeemByDefaultPartitions(msg.sender, msg.sender, value, data, "");
1861   }
1862 
1863   /**
1864    * [NOT MANDATORY FOR ERC1400 STANDARD][OVERRIDES ERC1410 METHOD]
1865    * @dev Redeem the value of tokens on behalf of the address 'from'.
1866    * @param from Token holder whose tokens will be redeemed (or 'address(0)' to set from to 'msg.sender').
1867    * @param value Number of tokens to redeem.
1868    * @param data Information attached to the redemption.
1869    * @param operatorData Information attached to the redemption, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1870    */
1871   function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData)
1872     external
1873     isValidCertificate(operatorData)
1874   {
1875     address _from = (from == address(0)) ? msg.sender : from;
1876 
1877     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1878 
1879     _redeemByDefaultPartitions(msg.sender, _from, value, data, operatorData);
1880   }
1881 
1882   /**
1883   * [NOT MANDATORY FOR ERC1410 STANDARD]
1884    * @dev Redeem tokens from a default partitions.
1885    * @param operator The address performing the redeem.
1886    * @param from Token holder.
1887    * @param value Number of tokens to redeem.
1888    * @param data Information attached to the redemption.
1889    * @param operatorData Information attached to the redemption, by the operator (if any).
1890    */
1891   function _redeemByDefaultPartitions(
1892     address operator,
1893     address from,
1894     uint256 value,
1895     bytes memory data,
1896     bytes memory operatorData
1897   )
1898     internal
1899   {
1900     bytes32[] memory _partitions = _getDefaultPartitions(from);
1901     require(_partitions.length != 0, "A8: Transfer Blocked - Token restriction");
1902 
1903     uint256 _remainingValue = value;
1904     uint256 _localBalance;
1905 
1906     for (uint i = 0; i < _partitions.length; i++) {
1907       _localBalance = _balanceOfByPartition[from][_partitions[i]];
1908       if(_remainingValue <= _localBalance) {
1909         _redeemByPartition(_partitions[i], operator, from, _remainingValue, data, operatorData);
1910         _remainingValue = 0;
1911         break;
1912       } else {
1913         _redeemByPartition(_partitions[i], operator, from, _localBalance, data, operatorData);
1914         _remainingValue = _remainingValue - _localBalance;
1915       }
1916     }
1917 
1918     require(_remainingValue == 0, "A8: Transfer Blocked - Token restriction");
1919   }
1920 
1921 }