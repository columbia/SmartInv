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
379 
380 /**
381  * @title ERC20 interface
382  * @dev see https://eips.ethereum.org/EIPS/eip-20
383  */
384 contract IERC20 {
385     function transfer(address to, uint256 value) external returns (bool);
386 
387     function approve(address spender, uint256 value) external returns (bool);
388 
389     function transferFrom(address from, address to, uint256 value) external returns (bool);
390 
391     function totalSupply() external view returns (uint256);
392 
393     function balanceOf(address who) external view returns (uint256);
394 
395     function allowance(address owner, address spender) external view returns (uint256);
396 
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     event Approval(address indexed owner, address indexed spender, uint256 value);
400 }
401 
402 /**
403  * @title IERC1410 partially fungible token standard
404  * @dev ERC1410 interface
405  */
406 interface IERC1410 {
407 
408     // Token Information
409     function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256); // 1/10
410     function partitionsOf(address tokenHolder) external view returns (bytes32[] memory); // 2/10
411 
412     // Token Transfers
413     function transferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external returns (bytes32); // 3/10
414     function operatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external returns (bytes32); // 4/10
415 
416     // Default Partition Management
417     function getDefaultPartitions(address tokenHolder) external view returns (bytes32[] memory); // 5/10
418     function setDefaultPartitions(bytes32[] calldata partitions) external; // 6/10
419 
420     // Operators
421     function controllersByPartition(bytes32 partition) external view returns (address[] memory); // 7/10
422     function authorizeOperatorByPartition(bytes32 partition, address operator) external; // 8/10
423     function revokeOperatorByPartition(bytes32 partition, address operator) external; // 9/10
424     function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool); // 10/10
425 
426     // Transfer Events
427     event TransferByPartition(
428         bytes32 indexed fromPartition,
429         address operator,
430         address indexed from,
431         address indexed to,
432         uint256 value,
433         bytes data,
434         bytes operatorData
435     );
436 
437     event ChangedPartition(
438         bytes32 indexed fromPartition,
439         bytes32 indexed toPartition,
440         uint256 value
441     );
442 
443     // Operator Events
444     event AuthorizedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
445     event RevokedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
446 
447 }
448 
449 
450 /**
451  * @title IERC777 token standard
452  * @dev ERC777 interface
453  */
454 interface IERC777 {
455 
456   function name() external view returns (string memory); // 1/13
457   function symbol() external view returns (string memory); // 2/13
458   function totalSupply() external view returns (uint256); // 3/13
459   function balanceOf(address owner) external view returns (uint256); // 4/13
460   function granularity() external view returns (uint256); // 5/13
461 
462   function controllers() external view returns (address[] memory); // 6/13
463   function authorizeOperator(address operator) external; // 7/13
464   function revokeOperator(address operator) external; // 8/13
465   function isOperatorFor(address operator, address tokenHolder) external view returns (bool); // 9/13
466 
467   function transferWithData(address to, uint256 value, bytes calldata data) external; // 10/13
468   function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external; // 11/13
469 
470   function redeem(uint256 value, bytes calldata data) external; // 12/13
471   function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData) external; // 13/13
472 
473   event TransferWithData(
474     address indexed operator,
475     address indexed from,
476     address indexed to,
477     uint256 value,
478     bytes data,
479     bytes operatorData
480   );
481   event Issued(address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
482   event Redeemed(address indexed operator, address indexed from, uint256 value, bytes data, bytes operatorData);
483   event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
484   event RevokedOperator(address indexed operator, address indexed tokenHolder);
485 
486 }
487 
488 
489 /**
490  * @title ERC1400 security token standard
491  * @dev ERC1400 logic
492  */
493 interface IERC1400  {
494 
495     // Document Management
496     function getDocument(bytes32 name) external view returns (string memory, bytes32); // 1/9
497     function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external; // 2/9
498     event Document(bytes32 indexed name, string uri, bytes32 documentHash);
499 
500     // Controller Operation
501     function isControllable() external view returns (bool); // 3/9
502 
503     // Token Issuance
504     function isIssuable() external view returns (bool); // 4/9
505     function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data) external; // 5/9
506     event IssuedByPartition(bytes32 indexed partition, address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
507 
508     // Token Redemption
509     function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data) external; // 6/9
510     function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData) external; // 7/9
511     event RedeemedByPartition(bytes32 indexed partition, address indexed operator, address indexed from, uint256 value, bytes data, bytes operatorData);
512 
513     // Transfer Validity
514     function canTransferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external view returns (byte, bytes32, bytes32); // 8/9
515     function canOperatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external view returns (byte, bytes32, bytes32); // 9/9
516 
517 }
518 
519 /**
520  * Reason codes - ERC1066
521  *
522  * To improve the token holder experience, canTransfer MUST return a reason byte code
523  * on success or failure based on the EIP-1066 application-specific status codes specified below.
524  * An implementation can also return arbitrary data as a bytes32 to provide additional
525  * information not captured by the reason code.
526  *
527  * Code Reason
528  * 0xA0 Transfer Verified - Unrestricted
529  * 0xA1 Transfer Verified - On-Chain approval for restricted token
530  * 0xA2 Transfer Verified - Off-Chain approval for restricted token
531  * 0xA3 Transfer Blocked - Sender lockup period not ended
532  * 0xA4 Transfer Blocked - Sender balance insufficient
533  * 0xA5 Transfer Blocked - Sender not eligible
534  * 0xA6 Transfer Blocked - Receiver not eligible
535  * 0xA7 Transfer Blocked - Identity restriction
536  * 0xA8 Transfer Blocked - Token restriction
537  * 0xA9 Transfer Blocked - Token granularity
538  */
539 
540 
541 contract ERC820Registry {
542     function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
543     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
544     function setManager(address _addr, address _newManager) external;
545     function getManager(address _addr) public view returns(address);
546 }
547 
548 
549 /// Base client to interact with the registry.
550 contract ERC820Client {
551     ERC820Registry constant ERC820REGISTRY = ERC820Registry(0x820b586C8C28125366C998641B09DCbE7d4cBF06);
552 
553     function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
554         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
555         ERC820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
556     }
557 
558     function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
559         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
560         return ERC820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
561     }
562 
563     function delegateManagement(address _newManager) internal {
564         ERC820REGISTRY.setManager(address(this), _newManager);
565     }
566 }
567 
568 /**
569  * @title ERC777
570  * @dev ERC777 logic
571  */
572 contract ERC777 is IERC777, Ownable, ERC820Client, CertificateController, ReentrancyGuard {
573   using SafeMath for uint256;
574 
575   string internal _name;
576   string internal _symbol;
577   uint256 internal _granularity;
578   uint256 internal _totalSupply;
579 
580   // Indicate whether the token can still be controlled by operators or not anymore.
581   bool internal _isControllable;
582 
583   // Mapping from tokenHolder to balance.
584   mapping(address => uint256) internal _balances;
585 
586   /******************** Mappings related to operator **************************/
587   // Mapping from (operator, tokenHolder) to authorized status. [TOKEN-HOLDER-SPECIFIC]
588   mapping(address => mapping(address => bool)) internal _authorizedOperator;
589 
590   // Array of controllers. [GLOBAL - NOT TOKEN-HOLDER-SPECIFIC]
591   address[] internal _controllers;
592 
593   // Mapping from operator to controller status. [GLOBAL - NOT TOKEN-HOLDER-SPECIFIC]
594   mapping(address => bool) internal _isController;
595   /****************************************************************************/
596 
597   /**
598    * [ERC777 CONSTRUCTOR]
599    * @dev Initialize ERC777 and CertificateController parameters + register
600    * the contract implementation in ERC820Registry.
601    * @param name Name of the token.
602    * @param symbol Symbol of the token.
603    * @param granularity Granularity of the token.
604    * @param controllers Array of initial controllers.
605    * @param certificateSigner Address of the off-chain service which signs the
606    * conditional ownership certificates required for token transfers, issuance,
607    * redemption (Cf. CertificateController.sol).
608    */
609   constructor(
610     string memory name,
611     string memory symbol,
612     uint256 granularity,
613     address[] memory controllers,
614     address certificateSigner
615   )
616     public
617     CertificateController(certificateSigner)
618   {
619     _name = name;
620     _symbol = symbol;
621     _totalSupply = 0;
622     require(granularity >= 1, "Constructor Blocked - Token granularity can not be lower than 1");
623     _granularity = granularity;
624 
625     _setControllers(controllers);
626 
627     setInterfaceImplementation("ERC777Token", address(this));
628   }
629 
630   /********************** ERC777 EXTERNAL FUNCTIONS ***************************/
631 
632   /**
633    * [ERC777 INTERFACE (1/13)]
634    * @dev Get the name of the token, e.g., "MyToken".
635    * @return Name of the token.
636    */
637   function name() external view returns(string memory) {
638     return _name;
639   }
640 
641   /**
642    * [ERC777 INTERFACE (2/13)]
643    * @dev Get the symbol of the token, e.g., "MYT".
644    * @return Symbol of the token.
645    */
646   function symbol() external view returns(string memory) {
647     return _symbol;
648   }
649 
650   /**
651    * [ERC777 INTERFACE (3/13)]
652    * @dev Get the total number of issued tokens.
653    * @return Total supply of tokens currently in circulation.
654    */
655   function totalSupply() external view returns (uint256) {
656     return _totalSupply;
657   }
658 
659   /**
660    * [ERC777 INTERFACE (4/13)]
661    * @dev Get the balance of the account with address 'tokenHolder'.
662    * @param tokenHolder Address for which the balance is returned.
663    * @return Amount of token held by 'tokenHolder' in the token contract.
664    */
665   function balanceOf(address tokenHolder) external view returns (uint256) {
666     return _balances[tokenHolder];
667   }
668 
669   /**
670    * [ERC777 INTERFACE (5/13)]
671    * @dev Get the smallest part of the token that’s not divisible.
672    * @return The smallest non-divisible part of the token.
673    */
674   function granularity() external view returns(uint256) {
675     return _granularity;
676   }
677 
678   /**
679    * [ERC777 INTERFACE (6/13)]
680    * @dev Get the list of controllers as defined by the token contract.
681    * @return List of addresses of all the controllers.
682    */
683   function controllers() external view returns (address[] memory) {
684     return _controllers;
685   }
686 
687   /**
688    * [ERC777 INTERFACE (7/13)]
689    * @dev Set a third party operator address as an operator of 'msg.sender' to transfer
690    * and redeem tokens on its behalf.
691    * @param operator Address to set as an operator for 'msg.sender'.
692    */
693   function authorizeOperator(address operator) external {
694     _authorizedOperator[operator][msg.sender] = true;
695     emit AuthorizedOperator(operator, msg.sender);
696   }
697 
698   /**
699    * [ERC777 INTERFACE (8/13)]
700    * @dev Remove the right of the operator address to be an operator for 'msg.sender'
701    * and to transfer and redeem tokens on its behalf.
702    * @param operator Address to rescind as an operator for 'msg.sender'.
703    */
704   function revokeOperator(address operator) external {
705     _authorizedOperator[operator][msg.sender] = false;
706     emit RevokedOperator(operator, msg.sender);
707   }
708 
709   /**
710    * [ERC777 INTERFACE (9/13)]
711    * @dev Indicate whether the operator address is an operator of the tokenHolder address.
712    * @param operator Address which may be an operator of tokenHolder.
713    * @param tokenHolder Address of a token holder which may have the operator address as an operator.
714    * @return 'true' if operator is an operator of 'tokenHolder' and 'false' otherwise.
715    */
716   function isOperatorFor(address operator, address tokenHolder) external view returns (bool) {
717     return _isOperatorFor(operator, tokenHolder);
718   }
719 
720   /**
721    * [ERC777 INTERFACE (10/13)]
722    * @dev Transfer the amount of tokens from the address 'msg.sender' to the address 'to'.
723    * @param to Token recipient.
724    * @param value Number of tokens to transfer.
725    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
726    */
727   function transferWithData(address to, uint256 value, bytes calldata data)
728     external
729     isValidCertificate(data)
730   {
731     _transferWithData("", msg.sender, msg.sender, to, value, data, "", true);
732   }
733 
734   /**
735    * [ERC777 INTERFACE (11/13)]
736    * @dev Transfer the amount of tokens on behalf of the address 'from' to the address 'to'.
737    * @param from Token holder (or 'address(0)' to set from to 'msg.sender').
738    * @param to Token recipient.
739    * @param value Number of tokens to transfer.
740    * @param data Information attached to the transfer, and intended for the token holder ('from').
741    * @param operatorData Information attached to the transfer by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
742    */
743   function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
744     external
745     isValidCertificate(operatorData)
746   {
747     address _from = (from == address(0)) ? msg.sender : from;
748 
749     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
750 
751     _transferWithData("", msg.sender, _from, to, value, data, operatorData, true);
752   }
753 
754   /**
755    * [ERC777 INTERFACE (12/13)]
756    * @dev Redeem the amount of tokens from the address 'msg.sender'.
757    * @param value Number of tokens to redeem.
758    * @param data Information attached to the redemption, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
759    */
760   function redeem(uint256 value, bytes calldata data)
761     external
762     isValidCertificate(data)
763   {
764     _redeem("", msg.sender, msg.sender, value, data, "");
765   }
766 
767   /**
768    * [ERC777 INTERFACE (13/13)]
769    * @dev Redeem the amount of tokens on behalf of the address from.
770    * @param from Token holder whose tokens will be redeemed (or address(0) to set from to msg.sender).
771    * @param value Number of tokens to redeem.
772    * @param data Information attached to the redemption.
773    * @param operatorData Information attached to the redemption, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
774    */
775   function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData)
776     external
777     isValidCertificate(operatorData)
778   {
779     address _from = (from == address(0)) ? msg.sender : from;
780 
781     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
782 
783     _redeem("", msg.sender, _from, value, data, operatorData);
784   }
785 
786   /********************** ERC777 INTERNAL FUNCTIONS ***************************/
787 
788   /**
789    * [INTERNAL]
790    * @dev Check if 'value' is multiple of the granularity.
791    * @param value The quantity that want's to be checked.
792    * @return 'true' if 'value' is a multiple of the granularity.
793    */
794   function _isMultiple(uint256 value) internal view returns(bool) {
795     return(value.div(_granularity).mul(_granularity) == value);
796   }
797 
798   /**
799    * [INTERNAL]
800    * @dev Check whether an address is a regular address or not.
801    * @param addr Address of the contract that has to be checked.
802    * @return 'true' if 'addr' is a regular address (not a contract).
803    */
804   function _isRegularAddress(address addr) internal view returns(bool) {
805     if (addr == address(0)) { return false; }
806     uint size;
807     assembly { size := extcodesize(addr) } // solhint-disable-line no-inline-assembly
808     return size == 0;
809   }
810 
811   /**
812    * [INTERNAL]
813    * @dev Indicate whether the operator address is an operator of the tokenHolder address.
814    * @param operator Address which may be an operator of 'tokenHolder'.
815    * @param tokenHolder Address of a token holder which may have the 'operator' address as an operator.
816    * @return 'true' if 'operator' is an operator of 'tokenHolder' and 'false' otherwise.
817    */
818   function _isOperatorFor(address operator, address tokenHolder) internal view returns (bool) {
819     return (operator == tokenHolder
820       || _authorizedOperator[operator][tokenHolder]
821       || (_isControllable && _isController[operator])
822     );
823   }
824 
825    /**
826     * [INTERNAL]
827     * @dev Perform the transfer of tokens.
828     * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
829     * @param operator The address performing the transfer.
830     * @param from Token holder.
831     * @param to Token recipient.
832     * @param value Number of tokens to transfer.
833     * @param data Information attached to the transfer.
834     * @param operatorData Information attached to the transfer by the operator (if any)..
835     * @param preventLocking 'true' if you want this function to throw when tokens are sent to a contract not
836     * implementing 'erc777tokenHolder'.
837     * ERC777 native transfer functions MUST set this parameter to 'true', and backwards compatible ERC20 transfer
838     * functions SHOULD set this parameter to 'false'.
839     */
840   function _transferWithData(
841     bytes32 partition,
842     address operator,
843     address from,
844     address to,
845     uint256 value,
846     bytes memory data,
847     bytes memory operatorData,
848     bool preventLocking
849   )
850     internal
851     nonReentrant
852   {
853     require(_isMultiple(value), "A9: Transfer Blocked - Token granularity");
854     require(to != address(0), "A6: Transfer Blocked - Receiver not eligible");
855     require(_balances[from] >= value, "A4: Transfer Blocked - Sender balance insufficient");
856 
857     _callSender(partition, operator, from, to, value, data, operatorData);
858 
859     _balances[from] = _balances[from].sub(value);
860     _balances[to] = _balances[to].add(value);
861 
862     _callRecipient(partition, operator, from, to, value, data, operatorData, preventLocking);
863 
864     emit TransferWithData(operator, from, to, value, data, operatorData);
865   }
866 
867   /**
868    * [INTERNAL]
869    * @dev Perform the token redemption.
870    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
871    * @param operator The address performing the redemption.
872    * @param from Token holder whose tokens will be redeemed.
873    * @param value Number of tokens to redeem.
874    * @param data Information attached to the redemption.
875    * @param operatorData Information attached to the redemption, by the operator (if any).
876    */
877   function _redeem(bytes32 partition, address operator, address from, uint256 value, bytes memory data, bytes memory operatorData)
878     internal
879     nonReentrant
880   {
881     require(_isMultiple(value), "A9: Transfer Blocked - Token granularity");
882     require(from != address(0), "A5: Transfer Blocked - Sender not eligible");
883     require(_balances[from] >= value, "A4: Transfer Blocked - Sender balance insufficient");
884 
885     _callSender(partition, operator, from, address(0), value, data, operatorData);
886 
887     _balances[from] = _balances[from].sub(value);
888     _totalSupply = _totalSupply.sub(value);
889 
890     emit Redeemed(operator, from, value, data, operatorData);
891   }
892 
893   /**
894    * [INTERNAL]
895    * @dev Check for 'ERC777TokensSender' hook on the sender and call it.
896    * May throw according to 'preventLocking'.
897    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
898    * @param operator Address which triggered the balance decrease (through transfer or redemption).
899    * @param from Token holder.
900    * @param to Token recipient for a transfer and 0x for a redemption.
901    * @param value Number of tokens the token holder balance is decreased by.
902    * @param data Extra information.
903    * @param operatorData Extra information, attached by the operator (if any).
904    */
905   function _callSender(
906     bytes32 partition,
907     address operator,
908     address from,
909     address to,
910     uint256 value,
911     bytes memory data,
912     bytes memory operatorData
913   )
914     internal
915   {
916     address senderImplementation;
917     senderImplementation = interfaceAddr(from, "ERC777TokensSender");
918 
919     if (senderImplementation != address(0)) {
920       IERC777TokensSender(senderImplementation).tokensToTransfer(partition, operator, from, to, value, data, operatorData);
921     }
922   }
923 
924   /**
925    * [INTERNAL]
926    * @dev Check for 'ERC777TokensRecipient' hook on the recipient and call it.
927    * May throw according to 'preventLocking'.
928    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
929    * @param operator Address which triggered the balance increase (through transfer or issuance).
930    * @param from Token holder for a transfer and 0x for an issuance.
931    * @param to Token recipient.
932    * @param value Number of tokens the recipient balance is increased by.
933    * @param data Extra information, intended for the token holder ('from').
934    * @param operatorData Extra information attached by the operator (if any).
935    * @param preventLocking 'true' if you want this function to throw when tokens are sent to a contract not
936    * implementing 'ERC777TokensRecipient'.
937    * ERC777 native transfer functions MUST set this parameter to 'true', and backwards compatible ERC20 transfer
938    * functions SHOULD set this parameter to 'false'.
939    */
940   function _callRecipient(
941     bytes32 partition,
942     address operator,
943     address from,
944     address to,
945     uint256 value,
946     bytes memory data,
947     bytes memory operatorData,
948     bool preventLocking
949   )
950     internal
951   {
952     address recipientImplementation;
953     recipientImplementation = interfaceAddr(to, "ERC777TokensRecipient");
954 
955     if (recipientImplementation != address(0)) {
956       IERC777TokensRecipient(recipientImplementation).tokensReceived(partition, operator, from, to, value, data, operatorData);
957     } else if (preventLocking) {
958       require(_isRegularAddress(to), "A6: Transfer Blocked - Receiver not eligible");
959     }
960   }
961 
962   /**
963    * [INTERNAL]
964    * @dev Perform the issuance of tokens.
965    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
966    * @param operator Address which triggered the issuance.
967    * @param to Token recipient.
968    * @param value Number of tokens issued.
969    * @param data Information attached to the issuance, and intended for the recipient (to).
970    * @param operatorData Information attached to the issuance by the operator (if any).
971    */
972   function _issue(bytes32 partition, address operator, address to, uint256 value, bytes memory data, bytes memory operatorData) internal nonReentrant {
973     require(_isMultiple(value), "A9: Transfer Blocked - Token granularity");
974     require(to != address(0), "A6: Transfer Blocked - Receiver not eligible");
975 
976     _totalSupply = _totalSupply.add(value);
977     _balances[to] = _balances[to].add(value);
978 
979     _callRecipient(partition, operator, address(0), to, value, data, operatorData, true);
980 
981     emit Issued(operator, to, value, data, operatorData);
982   }
983 
984   /********************** ERC777 OPTIONAL FUNCTIONS ***************************/
985 
986   /**
987    * [NOT MANDATORY FOR ERC777 STANDARD]
988    * @dev Set list of token controllers.
989    * @param operators Controller addresses.
990    */
991   function _setControllers(address[] memory operators) internal {
992     for (uint i = 0; i<_controllers.length; i++){
993       _isController[_controllers[i]] = false;
994     }
995     for (uint j = 0; j<operators.length; j++){
996       _isController[operators[j]] = true;
997     }
998     _controllers = operators;
999   }
1000 
1001 }
1002 
1003 /**
1004  * @title ERC1410
1005  * @dev ERC1410 logic
1006  */
1007 contract ERC1410 is IERC1410, ERC777{
1008 
1009   /******************** Mappings to find partition ******************************/
1010   // List of partitions.
1011   bytes32[] internal _totalPartitions;
1012 
1013   // Mapping from partition to global balance of corresponding partition.
1014   mapping (bytes32 => uint256) internal _totalSupplyByPartition;
1015 
1016   // Mapping from tokenHolder to their partitions.
1017   mapping (address => bytes32[]) internal _partitionsOf;
1018 
1019   // Mapping from (tokenHolder, partition) to balance of corresponding partition.
1020   mapping (address => mapping (bytes32 => uint256)) internal _balanceOfByPartition;
1021 
1022   // Mapping from tokenHolder to their default partitions (for ERC777 and ERC20 compatibility).
1023   mapping (address => bytes32[]) internal _defaultPartitionsOf;
1024 
1025   // List of token default partitions (for ERC20 compatibility).
1026   bytes32[] internal _tokenDefaultPartitions;
1027   /****************************************************************************/
1028 
1029   /**************** Mappings to find partition operators ************************/
1030   // Mapping from (tokenHolder, partition, operator) to 'approved for partition' status. [TOKEN-HOLDER-SPECIFIC]
1031   mapping (address => mapping (bytes32 => mapping (address => bool))) internal _authorizedOperatorByPartition;
1032 
1033   // Mapping from partition to controllers for the partition. [NOT TOKEN-HOLDER-SPECIFIC]
1034   mapping (bytes32 => address[]) internal _controllersByPartition;
1035 
1036   // Mapping from (partition, operator) to PartitionController status. [NOT TOKEN-HOLDER-SPECIFIC]
1037   mapping (bytes32 => mapping (address => bool)) internal _isControllerByPartition;
1038   /****************************************************************************/
1039 
1040   /**
1041    * [ERC1410 CONSTRUCTOR]
1042    * @dev Initialize ERC1410 parameters + register
1043    * the contract implementation in ERC820Registry.
1044    * @param name Name of the token.
1045    * @param symbol Symbol of the token.
1046    * @param granularity Granularity of the token.
1047    * @param controllers Array of initial controllers.
1048    * @param certificateSigner Address of the off-chain service which signs the
1049    * conditional ownership certificates required for token transfers, issuance,
1050    * redemption (Cf. CertificateController.sol).
1051    */
1052   constructor(
1053     string memory name,
1054     string memory symbol,
1055     uint256 granularity,
1056     address[] memory controllers,
1057     address certificateSigner,
1058     bytes32[] memory tokenDefaultPartitions
1059   )
1060     public
1061     ERC777(name, symbol, granularity, controllers, certificateSigner)
1062   {
1063     _tokenDefaultPartitions = tokenDefaultPartitions;
1064   }
1065 
1066   /********************** ERC1410 EXTERNAL FUNCTIONS **************************/
1067 
1068   /**
1069    * [ERC1410 INTERFACE (1/10)]
1070    * @dev Get balance of a tokenholder for a specific partition.
1071    * @param partition Name of the partition.
1072    * @param tokenHolder Address for which the balance is returned.
1073    * @return Amount of token of partition 'partition' held by 'tokenHolder' in the token contract.
1074    */
1075   function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256) {
1076     return _balanceOfByPartition[tokenHolder][partition];
1077   }
1078 
1079   /**
1080    * [ERC1410 INTERFACE (2/10)]
1081    * @dev Get partitions index of a tokenholder.
1082    * @param tokenHolder Address for which the partitions index are returned.
1083    * @return Array of partitions index of 'tokenHolder'.
1084    */
1085   function partitionsOf(address tokenHolder) external view returns (bytes32[] memory) {
1086     return _partitionsOf[tokenHolder];
1087   }
1088 
1089   /**
1090    * [ERC1410 INTERFACE (3/10)]
1091    * @dev Transfer tokens from a specific partition.
1092    * @param partition Name of the partition.
1093    * @param to Token recipient.
1094    * @param value Number of tokens to transfer.
1095    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1096    * @return Destination partition.
1097    */
1098   function transferByPartition(
1099     bytes32 partition,
1100     address to,
1101     uint256 value,
1102     bytes calldata data
1103   )
1104     external
1105     isValidCertificate(data)
1106     returns (bytes32)
1107   {
1108     return _transferByPartition(partition, msg.sender, msg.sender, to, value, data, "");
1109   }
1110 
1111   /**
1112    * [ERC1410 INTERFACE (4/10)]
1113    * @dev Transfer tokens from a specific partition through an operator.
1114    * @param partition Name of the partition.
1115    * @param from Token holder.
1116    * @param to Token recipient.
1117    * @param value Number of tokens to transfer.
1118    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1119    * @param operatorData Information attached to the transfer, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1120    * @return Destination partition.
1121    */
1122   function operatorTransferByPartition(
1123     bytes32 partition,
1124     address from,
1125     address to,
1126     uint256 value,
1127     bytes calldata data,
1128     bytes calldata operatorData
1129   )
1130     external
1131     isValidCertificate(operatorData)
1132     returns (bytes32)
1133   {
1134     address _from = (from == address(0)) ? msg.sender : from;
1135     require(_isOperatorForPartition(partition, msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1136 
1137     return _transferByPartition(partition, msg.sender, _from, to, value, data, operatorData);
1138   }
1139 
1140   /**
1141    * [ERC1410 INTERFACE (5/10)]
1142    * @dev Get default partitions to transfer from.
1143    * Function used for ERC777 and ERC20 backwards compatibility.
1144    * For example, a security token may return the bytes32("unrestricted").
1145    * @param tokenHolder Address for which we want to know the default partitions.
1146    * @return Array of default partitions.
1147    */
1148   function getDefaultPartitions(address tokenHolder) external view returns (bytes32[] memory) {
1149     return _defaultPartitionsOf[tokenHolder];
1150   }
1151 
1152   /**
1153    * [ERC1410 INTERFACE (6/10)]
1154    * @dev Set default partitions to transfer from.
1155    * Function used for ERC777 and ERC20 backwards compatibility.
1156    * @param partitions partitions to use by default when not specified.
1157    */
1158   function setDefaultPartitions(bytes32[] calldata partitions) external {
1159     _defaultPartitionsOf[msg.sender] = partitions;
1160   }
1161 
1162   /**
1163    * [ERC1410 INTERFACE (7/10)]
1164    * @dev Get controllers for a given partition.
1165    * Function used for ERC777 and ERC20 backwards compatibility.
1166    * @param partition Name of the partition.
1167    * @return Array of controllers for partition.
1168    */
1169   function controllersByPartition(bytes32 partition) external view returns (address[] memory) {
1170     return _controllersByPartition[partition];
1171   }
1172 
1173   /**
1174    * [ERC1410 INTERFACE (8/10)]
1175    * @dev Set 'operator' as an operator for 'msg.sender' for a given partition.
1176    * @param partition Name of the partition.
1177    * @param operator Address to set as an operator for 'msg.sender'.
1178    */
1179   function authorizeOperatorByPartition(bytes32 partition, address operator) external {
1180     _authorizedOperatorByPartition[msg.sender][partition][operator] = true;
1181     emit AuthorizedOperatorByPartition(partition, operator, msg.sender);
1182   }
1183 
1184   /**
1185    * [ERC1410 INTERFACE (9/10)]
1186    * @dev Remove the right of the operator address to be an operator on a given
1187    * partition for 'msg.sender' and to transfer and redeem tokens on its behalf.
1188    * @param partition Name of the partition.
1189    * @param operator Address to rescind as an operator on given partition for 'msg.sender'.
1190    */
1191   function revokeOperatorByPartition(bytes32 partition, address operator) external {
1192     _authorizedOperatorByPartition[msg.sender][partition][operator] = false;
1193     emit RevokedOperatorByPartition(partition, operator, msg.sender);
1194   }
1195 
1196   /**
1197    * [ERC1410 INTERFACE (10/10)]
1198    * @dev Indicate whether the operator address is an operator of the tokenHolder
1199    * address for the given partition.
1200    * @param partition Name of the partition.
1201    * @param operator Address which may be an operator of tokenHolder for the given partition.
1202    * @param tokenHolder Address of a token holder which may have the operator address as an operator for the given partition.
1203    * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition 'partition' and 'false' otherwise.
1204    */
1205   function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool) {
1206     return _isOperatorForPartition(partition, operator, tokenHolder);
1207   }
1208 
1209   /********************** ERC1410 INTERNAL FUNCTIONS **************************/
1210 
1211   /**
1212    * [INTERNAL]
1213    * @dev Indicate whether the operator address is an operator of the tokenHolder
1214    * address for the given partition.
1215    * @param partition Name of the partition.
1216    * @param operator Address which may be an operator of tokenHolder for the given partition.
1217    * @param tokenHolder Address of a token holder which may have the operator address as an operator for the given partition.
1218    * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition 'partition' and 'false' otherwise.
1219    */
1220    function _isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) internal view returns (bool) {
1221      return (_isOperatorFor(operator, tokenHolder)
1222        || _authorizedOperatorByPartition[tokenHolder][partition][operator]
1223        || (_isControllable && _isControllerByPartition[partition][operator])
1224      );
1225    }
1226 
1227   /**
1228    * [INTERNAL]
1229    * @dev Transfer tokens from a specific partition.
1230    * @param fromPartition Partition of the tokens to transfer.
1231    * @param operator The address performing the transfer.
1232    * @param from Token holder.
1233    * @param to Token recipient.
1234    * @param value Number of tokens to transfer.
1235    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1236    * @param operatorData Information attached to the transfer, by the operator (if any).
1237    * @return Destination partition.
1238    */
1239   function _transferByPartition(
1240     bytes32 fromPartition,
1241     address operator,
1242     address from,
1243     address to,
1244     uint256 value,
1245     bytes memory data,
1246     bytes memory operatorData
1247   )
1248     internal
1249     returns (bytes32)
1250   {
1251     require(_balanceOfByPartition[from][fromPartition] >= value, "A4: Transfer Blocked - Sender balance insufficient"); // ensure enough funds
1252 
1253     bytes32 toPartition = fromPartition;
1254 
1255     if(operatorData.length != 0 && data.length != 0) {
1256       toPartition = _getDestinationPartition(fromPartition, data);
1257     }
1258 
1259     _removeTokenFromPartition(from, fromPartition, value);
1260     _transferWithData(fromPartition, operator, from, to, value, data, operatorData, true);
1261     _addTokenToPartition(to, toPartition, value);
1262 
1263     emit TransferByPartition(fromPartition, operator, from, to, value, data, operatorData);
1264 
1265     if(toPartition != fromPartition) {
1266       emit ChangedPartition(fromPartition, toPartition, value);
1267     }
1268 
1269     return toPartition;
1270   }
1271 
1272   /**
1273    * [INTERNAL]
1274    * @dev Remove a token from a specific partition.
1275    * @param from Token holder.
1276    * @param partition Name of the partition.
1277    * @param value Number of tokens to transfer.
1278    */
1279   function _removeTokenFromPartition(address from, bytes32 partition, uint256 value) internal {
1280     _balanceOfByPartition[from][partition] = _balanceOfByPartition[from][partition].sub(value);
1281     _totalSupplyByPartition[partition] = _totalSupplyByPartition[partition].sub(value);
1282 
1283     // If the balance of the TokenHolder's partition is zero, finds and deletes the partition.
1284     if(_balanceOfByPartition[from][partition] == 0) {
1285       for (uint i = 0; i < _partitionsOf[from].length; i++) {
1286         if(_partitionsOf[from][i] == partition) {
1287           _partitionsOf[from][i] = _partitionsOf[from][_partitionsOf[from].length - 1];
1288           delete _partitionsOf[from][_partitionsOf[from].length - 1];
1289           _partitionsOf[from].length--;
1290           break;
1291         }
1292       }
1293     }
1294 
1295     // If the total supply is zero, finds and deletes the partition.
1296     if(_totalSupplyByPartition[partition] == 0) {
1297       for (uint i = 0; i < _totalPartitions.length; i++) {
1298         if(_totalPartitions[i] == partition) {
1299           _totalPartitions[i] = _totalPartitions[_totalPartitions.length - 1];
1300           delete _totalPartitions[_totalPartitions.length - 1];
1301           _totalPartitions.length--;
1302           break;
1303         }
1304       }
1305     }
1306   }
1307 
1308   /**
1309    * [INTERNAL]
1310    * @dev Add a token to a specific partition.
1311    * @param to Token recipient.
1312    * @param partition Name of the partition.
1313    * @param value Number of tokens to transfer.
1314    */
1315   function _addTokenToPartition(address to, bytes32 partition, uint256 value) internal {
1316     if(value != 0) {
1317       if(_balanceOfByPartition[to][partition] == 0) {
1318         _partitionsOf[to].push(partition);
1319       }
1320       _balanceOfByPartition[to][partition] = _balanceOfByPartition[to][partition].add(value);
1321 
1322       if(_totalSupplyByPartition[partition] == 0) {
1323         _totalPartitions.push(partition);
1324       }
1325       _totalSupplyByPartition[partition] = _totalSupplyByPartition[partition].add(value);
1326     }
1327   }
1328 
1329   /**
1330    * [INTERNAL]
1331    * @dev Retrieve the destination partition from the 'data' field.
1332    * By convention, a partition change is requested ONLY when 'data' starts
1333    * with the flag: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1334    * When the flag is detected, the destination tranche is extracted from the
1335    * 32 bytes following the flag.
1336    * @param fromPartition Partition of the tokens to transfer.
1337    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1338    * @return Destination partition.
1339    */
1340   function _getDestinationPartition(bytes32 fromPartition, bytes memory data) internal pure returns(bytes32 toPartition) {
1341     bytes32 changePartitionFlag = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1342     bytes32 flag;
1343     assembly {
1344       flag := mload(add(data, 32))
1345     }
1346     if(flag == changePartitionFlag) {
1347       assembly {
1348         toPartition := mload(add(data, 64))
1349       }
1350     } else {
1351       toPartition = fromPartition;
1352     }
1353   }
1354 
1355   /**
1356    * [INTERNAL]
1357    * @dev Get the sender's default partition if setup, or the global default partition if not.
1358    * @param tokenHolder Address for which the default partition is returned.
1359    * @return Default partition.
1360    */
1361   function _getDefaultPartitions(address tokenHolder) internal view returns(bytes32[] memory) {
1362     if(_defaultPartitionsOf[tokenHolder].length != 0) {
1363       return _defaultPartitionsOf[tokenHolder];
1364     } else {
1365       return _tokenDefaultPartitions;
1366     }
1367   }
1368 
1369 
1370   /********************* ERC1410 OPTIONAL FUNCTIONS ***************************/
1371 
1372   /**
1373    * [NOT MANDATORY FOR ERC1410 STANDARD]
1374    * @dev Get list of existing partitions.
1375    * @return Array of all exisiting partitions.
1376    */
1377   function totalPartitions() external view returns (bytes32[] memory) {
1378     return _totalPartitions;
1379   }
1380 
1381   /**
1382    * [NOT MANDATORY FOR ERC1410 STANDARD][SHALL BE CALLED ONLY FROM ERC1400]
1383    * @dev Set list of token partition controllers.
1384    * @param partition Name of the partition.
1385    * @param operators Controller addresses.
1386    */
1387    function _setPartitionControllers(bytes32 partition, address[] memory operators) internal {
1388      for (uint i = 0; i<_controllersByPartition[partition].length; i++){
1389        _isControllerByPartition[partition][_controllersByPartition[partition][i]] = false;
1390      }
1391      for (uint j = 0; j<operators.length; j++){
1392        _isControllerByPartition[partition][operators[j]] = true;
1393      }
1394      _controllersByPartition[partition] = operators;
1395    }
1396 
1397   /************** ERC777 BACKWARDS RETROCOMPATIBILITY *************************/
1398 
1399   /**
1400    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1401    * @dev Transfer the value of tokens from the address 'msg.sender' to the address 'to'.
1402    * @param to Token recipient.
1403    * @param value Number of tokens to transfer.
1404    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1405    */
1406   function transferWithData(address to, uint256 value, bytes calldata data)
1407     external
1408     isValidCertificate(data)
1409   {
1410     _transferByDefaultPartitions(msg.sender, msg.sender, to, value, data, "");
1411   }
1412 
1413   /**
1414    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1415    * @dev Transfer the value of tokens on behalf of the address from to the address to.
1416    * @param from Token holder (or 'address(0)'' to set from to 'msg.sender').
1417    * @param to Token recipient.
1418    * @param value Number of tokens to transfer.
1419    * @param data Information attached to the transfer, and intended for the token holder ('from'). [CAN CONTAIN THE DESTINATION PARTITION]
1420    * @param operatorData Information attached to the transfer by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1421    */
1422   function transferFromWithData(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
1423     external
1424     isValidCertificate(operatorData)
1425   {
1426     address _from = (from == address(0)) ? msg.sender : from;
1427 
1428     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1429 
1430     _transferByDefaultPartitions(msg.sender, _from, to, value, data, operatorData);
1431   }
1432 
1433   /**
1434    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1435    * @dev Empty function to erase ERC777 redeem() function since it doesn't handle partitions.
1436    */
1437   function redeem(uint256 /*value*/, bytes calldata /*data*/) external { // Comments to avoid compilation warnings for unused variables.
1438   }
1439 
1440   /**
1441    * [NOT MANDATORY FOR ERC1410 STANDARD][OVERRIDES ERC777 METHOD]
1442    * @dev Empty function to erase ERC777 redeemFrom() function since it doesn't handle partitions.
1443    */
1444   function redeemFrom(address /*from*/, uint256 /*value*/, bytes calldata /*data*/, bytes calldata /*operatorData*/) external { // Comments to avoid compilation warnings for unused variables.
1445   }
1446 
1447   /**
1448    * [NOT MANDATORY FOR ERC1410 STANDARD]
1449    * @dev Transfer tokens from default partitions.
1450    * @param operator The address performing the transfer.
1451    * @param from Token holder.
1452    * @param to Token recipient.
1453    * @param value Number of tokens to transfer.
1454    * @param data Information attached to the transfer, and intended for the token holder ('from') [CAN CONTAIN THE DESTINATION PARTITION].
1455    * @param operatorData Information attached to the transfer by the operator (if any).
1456    */
1457   function _transferByDefaultPartitions(
1458     address operator,
1459     address from,
1460     address to,
1461     uint256 value,
1462     bytes memory data,
1463     bytes memory operatorData
1464   )
1465     internal
1466   {
1467     bytes32[] memory _partitions = _getDefaultPartitions(from);
1468     require(_partitions.length != 0, "A8: Transfer Blocked - Token restriction");
1469 
1470     uint256 _remainingValue = value;
1471     uint256 _localBalance;
1472 
1473     for (uint i = 0; i < _partitions.length; i++) {
1474       _localBalance = _balanceOfByPartition[from][_partitions[i]];
1475       if(_remainingValue <= _localBalance) {
1476         _transferByPartition(_partitions[i], operator, from, to, _remainingValue, data, operatorData);
1477         _remainingValue = 0;
1478         break;
1479       } else {
1480         _transferByPartition(_partitions[i], operator, from, to, _localBalance, data, operatorData);
1481         _remainingValue = _remainingValue - _localBalance;
1482       }
1483     }
1484 
1485     require(_remainingValue == 0, "A8: Transfer Blocked - Token restriction");
1486   }
1487 }
1488 
1489 
1490 /**
1491  * @title ERC1400
1492  * @dev ERC1400 logic
1493  */
1494 contract ERC1400 is IERC1400, ERC1410, MinterRole {
1495 
1496   struct Doc {
1497     string docURI;
1498     bytes32 docHash;
1499   }
1500 
1501   // Mapping for token URIs.
1502   mapping(bytes32 => Doc) internal _documents;
1503 
1504   // Indicate whether the token can still be issued by the issuer or not anymore.
1505   bool internal _isIssuable;
1506 
1507   /**
1508    * @dev Modifier to verify if token is issuable.
1509    */
1510   modifier issuableToken() {
1511     require(_isIssuable, "A8, Transfer Blocked - Token restriction");
1512     _;
1513   }
1514 
1515   /**
1516    * [ERC1400 CONSTRUCTOR]
1517    * @dev Initialize ERC1400 + register
1518    * the contract implementation in ERC820Registry.
1519    * @param name Name of the token.
1520    * @param symbol Symbol of the token.
1521    * @param granularity Granularity of the token.
1522    * @param controllers Array of initial controllers.
1523    * @param certificateSigner Address of the off-chain service which signs the
1524    * conditional ownership certificates required for token transfers, issuance,
1525    * redemption (Cf. CertificateController.sol).
1526    */
1527   constructor(
1528     string memory name,
1529     string memory symbol,
1530     uint256 granularity,
1531     address[] memory controllers,
1532     address certificateSigner,
1533     bytes32[] memory tokenDefaultPartitions
1534   )
1535     public
1536     ERC1410(name, symbol, granularity, controllers, certificateSigner, tokenDefaultPartitions)
1537   {
1538     setInterfaceImplementation("ERC1400Token", address(this));
1539     _isControllable = true;
1540     _isIssuable = true;
1541   }
1542 
1543   /********************** ERC1400 EXTERNAL FUNCTIONS **************************/
1544 
1545   /**
1546    * [ERC1400 INTERFACE (1/9)]
1547    * @dev Access a document associated with the token.
1548    * @param name Short name (represented as a bytes32) associated to the document.
1549    * @return Requested document + document hash.
1550    */
1551   function getDocument(bytes32 name) external view returns (string memory, bytes32) {
1552     require(bytes(_documents[name].docURI).length != 0, "Action Blocked - Empty document");
1553     return (
1554       _documents[name].docURI,
1555       _documents[name].docHash
1556     );
1557   }
1558 
1559   /**
1560    * [ERC1400 INTERFACE (2/9)]
1561    * @dev Associate a document with the token.
1562    * @param name Short name (represented as a bytes32) associated to the document.
1563    * @param uri Document content.
1564    * @param documentHash Hash of the document [optional parameter].
1565    */
1566   function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external onlyOwner {
1567     _documents[name] = Doc({
1568       docURI: uri,
1569       docHash: documentHash
1570     });
1571     emit Document(name, uri, documentHash);
1572   }
1573 
1574   /**
1575    * [ERC1400 INTERFACE (3/9)]
1576    * @dev Know if the token can be controlled by operators.
1577    * If a token returns 'false' for 'isControllable()'' then it MUST always return 'false' in the future.
1578    * @return bool 'true' if the token can still be controlled by operators, 'false' if it can't anymore.
1579    */
1580   function isControllable() external view returns (bool) {
1581     return _isControllable;
1582   }
1583 
1584   /**
1585    * [ERC1400 INTERFACE (4/9)]
1586    * @dev Know if new tokens can be issued in the future.
1587    * @return bool 'true' if tokens can still be issued by the issuer, 'false' if they can't anymore.
1588    */
1589   function isIssuable() external view returns (bool) {
1590     return _isIssuable;
1591   }
1592 
1593   /**
1594    * [ERC1400 INTERFACE (5/9)]
1595    * @dev Issue tokens from a specific partition.
1596    * @param partition Name of the partition.
1597    * @param tokenHolder Address for which we want to issue tokens.
1598    * @param value Number of tokens issued.
1599    * @param data Information attached to the issuance, by the issuer. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1600    */
1601   function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data)
1602     external
1603     onlyMinter
1604     issuableToken
1605     isValidCertificate(data)
1606   {
1607     _issueByPartition(partition, msg.sender, tokenHolder, value, data, "");
1608   }
1609 
1610   /**
1611    * [ERC1400 INTERFACE (6/9)]
1612    * @dev Redeem tokens of a specific partition.
1613    * @param partition Name of the partition.
1614    * @param value Number of tokens redeemed.
1615    * @param data Information attached to the redemption, by the redeemer. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1616    */
1617   function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data)
1618     external
1619     isValidCertificate(data)
1620   {
1621     _redeemByPartition(partition, msg.sender, msg.sender, value, data, "");
1622   }
1623 
1624   /**
1625    * [ERC1400 INTERFACE (7/9)]
1626    * @dev Redeem tokens of a specific partition.
1627    * @param partition Name of the partition.
1628    * @param tokenHolder Address for which we want to redeem tokens.
1629    * @param value Number of tokens redeemed.
1630    * @param data Information attached to the redemption.
1631    * @param operatorData Information attached to the redemption, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1632    */
1633   function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData)
1634     external
1635     isValidCertificate(operatorData)
1636   {
1637     address _from = (tokenHolder == address(0)) ? msg.sender : tokenHolder;
1638     require(_isOperatorForPartition(partition, msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1639 
1640     _redeemByPartition(partition, msg.sender, _from, value, data, operatorData);
1641   }
1642 
1643   /**
1644    * [ERC1400 INTERFACE (8/9)]
1645    * @dev Know the reason on success or failure based on the EIP-1066 application-specific status codes.
1646    * @param partition Name of the partition.
1647    * @param to Token recipient.
1648    * @param value Number of tokens to transfer.
1649    * @param data Information attached to the transfer, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1650    * @return ESC (Ethereum Status Code) following the EIP-1066 standard.
1651    * @return Additional bytes32 parameter that can be used to define
1652    * application specific reason codes with additional details (for example the
1653    * transfer restriction rule responsible for making the transfer operation invalid).
1654    * @return Destination partition.
1655    */
1656   function canTransferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data)
1657     external
1658     view
1659     returns (byte, bytes32, bytes32)
1660   {
1661     if(!_checkCertificate(data, 0, 0xf3d490db)) { // 4 first bytes of keccak256(transferByPartition(bytes32,address,uint256,bytes))
1662       return(hex"A3", "", partition); // Transfer Blocked - Sender lockup period not ended
1663     } else {
1664       return _canTransfer(partition, msg.sender, msg.sender, to, value, data, "");
1665     }
1666   }
1667 
1668   /**
1669    * [ERC1400 INTERFACE (9/9)]
1670    * @dev Know the reason on success or failure based on the EIP-1066 application-specific status codes.
1671    * @param partition Name of the partition.
1672    * @param from Token holder.
1673    * @param to Token recipient.
1674    * @param value Number of tokens to transfer.
1675    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1676    * @param operatorData Information attached to the transfer, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1677    * @return ESC (Ethereum Status Code) following the EIP-1066 standard.
1678    * @return Additional bytes32 parameter that can be used to define
1679    * application specific reason codes with additional details (for example the
1680    * transfer restriction rule responsible for making the transfer operation invalid).
1681    * @return Destination partition.
1682    */
1683   function canOperatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData)
1684     external
1685     view
1686     returns (byte, bytes32, bytes32)
1687   {
1688     if(!_checkCertificate(operatorData, 0, 0x8c0dee9c)) { // 4 first bytes of keccak256(operatorTransferByPartition(bytes32,address,address,uint256,bytes,bytes))
1689       return(hex"A3", "", partition); // Transfer Blocked - Sender lockup period not ended
1690     } else {
1691       address _from = (from == address(0)) ? msg.sender : from;
1692       return _canTransfer(partition, msg.sender, _from, to, value, data, operatorData);
1693     }
1694   }
1695 
1696   /********************** ERC1400 INTERNAL FUNCTIONS **************************/
1697 
1698   /**
1699    * [INTERNAL]
1700    * @dev Know the reason on success or failure based on the EIP-1066 application-specific status codes.
1701    * @param partition Name of the partition.
1702    * @param operator The address performing the transfer.
1703    * @param from Token holder.
1704    * @param to Token recipient.
1705    * @param value Number of tokens to transfer.
1706    * @param data Information attached to the transfer. [CAN CONTAIN THE DESTINATION PARTITION]
1707    * @param operatorData Information attached to the transfer, by the operator (if any).
1708    * @return ESC (Ethereum Status Code) following the EIP-1066 standard.
1709    * @return Additional bytes32 parameter that can be used to define
1710    * application specific reason codes with additional details (for example the
1711    * transfer restriction rule responsible for making the transfer operation invalid).
1712    * @return Destination partition.
1713    */
1714    function _canTransfer(bytes32 partition, address operator, address from, address to, uint256 value, bytes memory data, bytes memory operatorData)
1715      internal
1716      view
1717      returns (byte, bytes32, bytes32)
1718    {
1719      if(!_isOperatorForPartition(partition, operator, from))
1720        return(hex"A7", "", partition); // "Transfer Blocked - Identity restriction"
1721 
1722      if((_balances[from] < value) || (_balanceOfByPartition[from][partition] < value))
1723        return(hex"A4", "", partition); // Transfer Blocked - Sender balance insufficient
1724 
1725      if(to == address(0))
1726        return(hex"A6", "", partition); // Transfer Blocked - Receiver not eligible
1727 
1728      address senderImplementation;
1729      address recipientImplementation;
1730      senderImplementation = interfaceAddr(from, "ERC777TokensSender");
1731      recipientImplementation = interfaceAddr(to, "ERC777TokensRecipient");
1732 
1733      if((senderImplementation != address(0))
1734        && !IERC777TokensSender(senderImplementation).canTransfer(partition, from, to, value, data, operatorData))
1735        return(hex"A5", "", partition); // Transfer Blocked - Sender not eligible
1736 
1737      if((recipientImplementation != address(0))
1738        && !IERC777TokensRecipient(recipientImplementation).canReceive(partition, from, to, value, data, operatorData))
1739        return(hex"A6", "", partition); // Transfer Blocked - Receiver not eligible
1740 
1741      if(!_isMultiple(value))
1742        return(hex"A9", "", partition); // Transfer Blocked - Token granularity
1743 
1744      return(hex"A2", "", partition);  // Transfer Verified - Off-Chain approval for restricted token
1745    }
1746 
1747   /**
1748    * [INTERNAL]
1749    * @dev Issue tokens from a specific partition.
1750    * @param toPartition Name of the partition.
1751    * @param operator The address performing the issuance.
1752    * @param to Token recipient.
1753    * @param value Number of tokens to issue.
1754    * @param data Information attached to the issuance.
1755    * @param operatorData Information attached to the issuance, by the operator (if any).
1756    */
1757   function _issueByPartition(
1758     bytes32 toPartition,
1759     address operator,
1760     address to,
1761     uint256 value,
1762     bytes memory data,
1763     bytes memory operatorData
1764   )
1765     internal
1766   {
1767     _issue(toPartition, operator, to, value, data, operatorData);
1768     _addTokenToPartition(to, toPartition, value);
1769 
1770     emit IssuedByPartition(toPartition, operator, to, value, data, operatorData);
1771   }
1772 
1773   /**
1774    * [INTERNAL]
1775    * @dev Redeem tokens of a specific partition.
1776    * @param fromPartition Name of the partition.
1777    * @param operator The address performing the redemption.
1778    * @param from Token holder whose tokens will be redeemed.
1779    * @param value Number of tokens to redeem.
1780    * @param data Information attached to the redemption.
1781    * @param operatorData Information attached to the redemption, by the operator (if any).
1782    */
1783   function _redeemByPartition(
1784     bytes32 fromPartition,
1785     address operator,
1786     address from,
1787     uint256 value,
1788     bytes memory data,
1789     bytes memory operatorData
1790   )
1791     internal
1792   {
1793     require(_balanceOfByPartition[from][fromPartition] >= value, "A4: Transfer Blocked - Sender balance insufficient");
1794 
1795     _removeTokenFromPartition(from, fromPartition, value);
1796     _redeem(fromPartition, operator, from, value, data, operatorData);
1797 
1798     emit RedeemedByPartition(fromPartition, operator, from, value, data, operatorData);
1799   }
1800 
1801   /********************** ERC1400 OPTIONAL FUNCTIONS **************************/
1802 
1803   /**
1804    * [NOT MANDATORY FOR ERC1400 STANDARD]
1805    * @dev Definitely renounce the possibility to control tokens on behalf of tokenHolders.
1806    * Once set to false, '_isControllable' can never be set to 'true' again.
1807    */
1808   function renounceControl() external onlyOwner {
1809     _isControllable = false;
1810   }
1811 
1812   /**
1813    * [NOT MANDATORY FOR ERC1400 STANDARD]
1814    * @dev Definitely renounce the possibility to issue new tokens.
1815    * Once set to false, '_isIssuable' can never be set to 'true' again.
1816    */
1817   function renounceIssuance() external onlyOwner {
1818     _isIssuable = false;
1819   }
1820 
1821   /**
1822    * [NOT MANDATORY FOR ERC1400 STANDARD]
1823    * @dev Set list of token controllers.
1824    * @param operators Controller addresses.
1825    */
1826   function setControllers(address[] calldata operators) external onlyOwner {
1827     _setControllers(operators);
1828   }
1829 
1830   /**
1831    * [NOT MANDATORY FOR ERC1400 STANDARD]
1832    * @dev Set list of token partition controllers.
1833    * @param partition Name of the partition.
1834    * @param operators Controller addresses.
1835    */
1836    function setPartitionControllers(bytes32 partition, address[] calldata operators) external onlyOwner {
1837      _setPartitionControllers(partition, operators);
1838    }
1839 
1840    /**
1841    * @dev Add a certificate signer for the token.
1842    * @param operator Address to set as a certificate signer.
1843    * @param authorized 'true' if operator shall be accepted as certificate signer, 'false' if not.
1844    */
1845   function setCertificateSigner(address operator, bool authorized) external onlyOwner {
1846     _setCertificateSigner(operator, authorized);
1847   }
1848 
1849   /************* ERC1410/ERC777 BACKWARDS RETROCOMPATIBILITY ******************/
1850 
1851   /**
1852    * [NOT MANDATORY FOR ERC1400 STANDARD]
1853    * @dev Get token default partitions to send from.
1854    * Function used for ERC777 and ERC20 backwards compatibility.
1855    * For example, a security token may return the bytes32("unrestricted").
1856    * @return Default partitions.
1857    */
1858   function getTokenDefaultPartitions() external view returns (bytes32[] memory) {
1859     return _tokenDefaultPartitions;
1860   }
1861 
1862   /**
1863    * [NOT MANDATORY FOR ERC1400 STANDARD]
1864    * @dev Set token default partitions to send from.
1865    * Function used for ERC777 and ERC20 backwards compatibility.
1866    * @param defaultPartitions Partitions to use by default when not specified.
1867    */
1868   function setTokenDefaultPartitions(bytes32[] calldata defaultPartitions) external onlyOwner {
1869     _tokenDefaultPartitions = defaultPartitions;
1870   }
1871 
1872 
1873   /**
1874    * [NOT MANDATORY FOR ERC1400 STANDARD][OVERRIDES ERC1410 METHOD]
1875    * @dev Redeem the value of tokens from the address 'msg.sender'.
1876    * @param value Number of tokens to redeem.
1877    * @param data Information attached to the redemption, by the token holder. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1878    */
1879   function redeem(uint256 value, bytes calldata data)
1880     external
1881     isValidCertificate(data)
1882   {
1883     _redeemByDefaultPartitions(msg.sender, msg.sender, value, data, "");
1884   }
1885 
1886   /**
1887    * [NOT MANDATORY FOR ERC1400 STANDARD][OVERRIDES ERC1410 METHOD]
1888    * @dev Redeem the value of tokens on behalf of the address 'from'.
1889    * @param from Token holder whose tokens will be redeemed (or 'address(0)' to set from to 'msg.sender').
1890    * @param value Number of tokens to redeem.
1891    * @param data Information attached to the redemption.
1892    * @param operatorData Information attached to the redemption, by the operator. [CONTAINS THE CONDITIONAL OWNERSHIP CERTIFICATE]
1893    */
1894   function redeemFrom(address from, uint256 value, bytes calldata data, bytes calldata operatorData)
1895     external
1896     isValidCertificate(operatorData)
1897   {
1898     address _from = (from == address(0)) ? msg.sender : from;
1899 
1900     require(_isOperatorFor(msg.sender, _from), "A7: Transfer Blocked - Identity restriction");
1901 
1902     _redeemByDefaultPartitions(msg.sender, _from, value, data, operatorData);
1903   }
1904 
1905   /**
1906   * [NOT MANDATORY FOR ERC1410 STANDARD]
1907    * @dev Redeem tokens from a default partitions.
1908    * @param operator The address performing the redeem.
1909    * @param from Token holder.
1910    * @param value Number of tokens to redeem.
1911    * @param data Information attached to the redemption.
1912    * @param operatorData Information attached to the redemption, by the operator (if any).
1913    */
1914   function _redeemByDefaultPartitions(
1915     address operator,
1916     address from,
1917     uint256 value,
1918     bytes memory data,
1919     bytes memory operatorData
1920   )
1921     internal
1922   {
1923     bytes32[] memory _partitions = _getDefaultPartitions(from);
1924     require(_partitions.length != 0, "A8: Transfer Blocked - Token restriction");
1925 
1926     uint256 _remainingValue = value;
1927     uint256 _localBalance;
1928 
1929     for (uint i = 0; i < _partitions.length; i++) {
1930       _localBalance = _balanceOfByPartition[from][_partitions[i]];
1931       if(_remainingValue <= _localBalance) {
1932         _redeemByPartition(_partitions[i], operator, from, _remainingValue, data, operatorData);
1933         _remainingValue = 0;
1934         break;
1935       } else {
1936         _redeemByPartition(_partitions[i], operator, from, _localBalance, data, operatorData);
1937         _remainingValue = _remainingValue - _localBalance;
1938       }
1939     }
1940 
1941     require(_remainingValue == 0, "A8: Transfer Blocked - Token restriction");
1942   }
1943 
1944 }
1945 
1946 /**
1947  * @title ERC1400ERC20
1948  * @dev ERC1400 with ERC20 retrocompatibility
1949  */
1950 contract ERC1400ERC20 is IERC20, ERC1400 {
1951 
1952   // Mapping from (tokenHolder, spender) to allowed value.
1953   mapping (address => mapping (address => uint256)) internal _allowed;
1954 
1955   // Mapping from (tokenHolder) to whitelisted status.
1956   mapping (address => bool) internal _whitelisted;
1957 
1958   /**
1959    * @dev Modifier to verify if sender and recipient are whitelisted.
1960    */
1961   modifier isWhitelisted(address recipient) {
1962     require(_whitelisted[recipient], "A3: Transfer Blocked - Sender lockup period not ended");
1963     _;
1964   }
1965 
1966   /**
1967    * [ERC1400ERC20 CONSTRUCTOR]
1968    * @dev Initialize ERC71400ERC20 and CertificateController parameters + register
1969    * the contract implementation in ERC820Registry.
1970    * @param name Name of the token.
1971    * @param symbol Symbol of the token.
1972    * @param granularity Granularity of the token.
1973    * @param controllers Array of initial controllers.
1974    * @param certificateSigner Address of the off-chain service which signs the
1975    * conditional ownership certificates required for token transfers, issuance,
1976    * redemption (Cf. CertificateController.sol).
1977    */
1978   constructor(
1979     string memory name,
1980     string memory symbol,
1981     uint256 granularity,
1982     address[] memory controllers,
1983     address certificateSigner,
1984     bytes32[] memory tokenDefaultPartitions
1985   )
1986     public
1987     ERC1400(name, symbol, granularity, controllers, certificateSigner, tokenDefaultPartitions)
1988   {
1989     setInterfaceImplementation("ERC20Token", address(this));
1990   }
1991 
1992   /**
1993    * [OVERRIDES ERC1400 METHOD]
1994    * @dev Perform the transfer of tokens.
1995    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
1996    * @param operator The address performing the transfer.
1997    * @param from Token holder.
1998    * @param to Token recipient.
1999    * @param value Number of tokens to transfer.
2000    * @param data Information attached to the transfer.
2001    * @param operatorData Information attached to the transfer by the operator (if any).
2002    * @param preventLocking 'true' if you want this function to throw when tokens are sent to a contract not
2003    * implementing 'erc777tokenHolder'.
2004    * ERC777 native transfer functions MUST set this parameter to 'true', and backwards compatible ERC20 transfer
2005    * functions SHOULD set this parameter to 'false'.
2006    */
2007   function _transferWithData(
2008     bytes32 partition,
2009     address operator,
2010     address from,
2011     address to,
2012     uint256 value,
2013     bytes memory data,
2014     bytes memory operatorData,
2015     bool preventLocking
2016   )
2017     internal
2018   {
2019     ERC777._transferWithData(partition, operator, from, to, value, data, operatorData, preventLocking);
2020 
2021     emit Transfer(from, to, value);
2022   }
2023 
2024   /**
2025    * [OVERRIDES ERC1400 METHOD]
2026    * @dev Perform the token redemption.
2027    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
2028    * @param operator The address performing the redemption.
2029    * @param from Token holder whose tokens will be redeemed.
2030    * @param value Number of tokens to redeem.
2031    * @param data Information attached to the redemption.
2032    * @param operatorData Information attached to the redemption by the operator (if any).
2033    */
2034   function _redeem(bytes32 partition, address operator, address from, uint256 value, bytes memory data, bytes memory operatorData) internal {
2035     ERC777._redeem(partition, operator, from, value, data, operatorData);
2036 
2037     emit Transfer(from, address(0), value);  //  ERC20 backwards compatibility
2038   }
2039 
2040   /**
2041    * [OVERRIDES ERC1400 METHOD]
2042    * @dev Perform the issuance of tokens.
2043    * @param partition Name of the partition (bytes32 to be left empty for ERC777 transfer).
2044    * @param operator Address which triggered the issuance.
2045    * @param to Token recipient.
2046    * @param value Number of tokens issued.
2047    * @param data Information attached to the issuance.
2048    * @param operatorData Information attached to the issuance by the operator (if any).
2049    */
2050   function _issue(bytes32 partition, address operator, address to, uint256 value, bytes memory data, bytes memory operatorData) internal {
2051     ERC777._issue(partition, operator, to, value, data, operatorData);
2052 
2053     emit Transfer(address(0), to, value); // ERC20 backwards compatibility
2054   }
2055 
2056   /**
2057    * [OVERRIDES ERC1400 METHOD]
2058    * @dev Get the number of decimals of the token.
2059    * @return The number of decimals of the token. For Backwards compatibility, decimals are forced to 18 in ERC777.
2060    */
2061   function decimals() external pure returns(uint8) {
2062     return uint8(18);
2063   }
2064 
2065   /**
2066    * [NOT MANDATORY FOR ERC1400 STANDARD]
2067    * @dev Check the value of tokens that an owner allowed to a spender.
2068    * @param owner address The address which owns the funds.
2069    * @param spender address The address which will spend the funds.
2070    * @return A uint256 specifying the value of tokens still available for the spender.
2071    */
2072   function allowance(address owner, address spender) external view returns (uint256) {
2073     return _allowed[owner][spender];
2074   }
2075 
2076   /**
2077    * [NOT MANDATORY FOR ERC1400 STANDARD]
2078    * @dev Approve the passed address to spend the specified amount of tokens on behalf of 'msg.sender'.
2079    * Beware that changing an allowance with this method brings the risk that someone may use both the old
2080    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
2081    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
2082    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2083    * @param spender The address which will spend the funds.
2084    * @param value The amount of tokens to be spent.
2085    * @return A boolean that indicates if the operation was successful.
2086    */
2087   function approve(address spender, uint256 value) external returns (bool) {
2088     require(spender != address(0), "A5: Transfer Blocked - Sender not eligible");
2089     _allowed[msg.sender][spender] = value;
2090     emit Approval(msg.sender, spender, value);
2091     return true;
2092   }
2093 
2094   /**
2095    * [NOT MANDATORY FOR ERC1400 STANDARD]
2096    * @dev Transfer token for a specified address.
2097    * @param to The address to transfer to.
2098    * @param value The value to be transferred.
2099    * @return A boolean that indicates if the operation was successful.
2100    */
2101   function transfer(address to, uint256 value) external isWhitelisted(to) returns (bool) {
2102     _transferByDefaultPartitions(msg.sender, msg.sender, to, value, "", "");
2103     return true;
2104   }
2105 
2106   /**
2107    * [NOT MANDATORY FOR ERC1400 STANDARD]
2108    * @dev Transfer tokens from one address to another.
2109    * @param from The address which you want to transfer tokens from.
2110    * @param to The address which you want to transfer to.
2111    * @param value The amount of tokens to be transferred.
2112    * @return A boolean that indicates if the operation was successful.
2113    */
2114   function transferFrom(address from, address to, uint256 value) external isWhitelisted(to) returns (bool) {
2115     address _from = (from == address(0)) ? msg.sender : from;
2116     require( _isOperatorFor(msg.sender, _from)
2117       || (value <= _allowed[_from][msg.sender]), "A7: Transfer Blocked - Identity restriction");
2118 
2119     if(_allowed[_from][msg.sender] >= value) {
2120       _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(value);
2121     } else {
2122       _allowed[_from][msg.sender] = 0;
2123     }
2124 
2125     _transferByDefaultPartitions(msg.sender, _from, to, value, "", "");
2126     return true;
2127   }
2128 
2129   /***************** ERC1400ERC20 OPTIONAL FUNCTIONS ***************************/
2130 
2131   /**
2132    * [NOT MANDATORY FOR ERC1400ERC20 STANDARD]
2133    * @dev Get whitelisted status for a tokenHolder.
2134    * @param tokenHolder Address whom to check the whitelisted status for.
2135    * @return bool 'true' if tokenHolder is whitelisted, 'false' if not.
2136    */
2137   function whitelisted(address tokenHolder) external view returns (bool) {
2138     return _whitelisted[tokenHolder];
2139   }
2140 
2141   /**
2142    * [NOT MANDATORY FOR ERC1400ERC20 STANDARD]
2143    * @dev Set whitelisted status for a tokenHolder.
2144    * @param tokenHolder Address to add/remove from whitelist.
2145    * @param authorized 'true' if tokenHolder shall be added to whitelist, 'false' if not.
2146    */
2147   function setWhitelisted(address tokenHolder, bool authorized) external onlyOwner {
2148     _setWhitelisted(tokenHolder, authorized);
2149   }
2150 
2151   /**
2152    * [NOT MANDATORY FOR ERC1400ERC20 STANDARD]
2153    * @dev Set whitelisted status for a tokenHolder.
2154    * @param tokenHolder Address to add/remove from whitelist.
2155    * @param authorized 'true' if tokenHolder shall be added to whitelist, 'false' if not.
2156    */
2157   function _setWhitelisted(address tokenHolder, bool authorized) internal {
2158     require(tokenHolder != address(0), "Action Blocked - Not a valid address");
2159     _whitelisted[tokenHolder] = authorized;
2160   }
2161 }