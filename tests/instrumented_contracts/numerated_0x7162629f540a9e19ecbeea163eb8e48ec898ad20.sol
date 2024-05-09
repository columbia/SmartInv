1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0 <0.9.0;
4 
5 /**
6     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
7 */
8 interface IERC1155TokenReceiver {
9     /**
10         @notice Handle the receipt of a single ERC1155 token type.
11         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
12         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
13         This function MUST revert if it rejects the transfer.
14         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
15         @param _operator  The address which initiated the transfer (i.e. msg.sender)
16         @param _from      The address which previously owned the token
17         @param _id        The ID of the token being transferred
18         @param _value     The amount of tokens being transferred
19         @param _data      Additional data with no specified format
20         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
21     */
22     function onERC1155Received(
23         address _operator,
24         address _from,
25         uint256 _id,
26         uint256 _value,
27         bytes calldata _data
28     ) external returns (bytes4);
29 
30     /**
31         @notice Handle the receipt of multiple ERC1155 token types.
32         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
33         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
34         This function MUST revert if it rejects the transfer(s).
35         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
36         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
37         @param _from      The address which previously owned the token
38         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
39         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
40         @param _data      Additional data with no specified format
41         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
42     */
43     function onERC1155BatchReceived(
44         address _operator,
45         address _from,
46         uint256[] calldata _ids,
47         uint256[] calldata _values,
48         bytes calldata _data
49     ) external returns (bytes4);
50 }
51 
52 /**
53  * @dev Interface of the ERC165 standard, as defined in the
54  * https://eips.ethereum.org/EIPS/eip-165[EIP].
55  *
56  * Implementers can declare support of contract interfaces, which can then be
57  * queried by others ({ERC165Checker}).
58  *
59  * For an implementation, see {ERC165}.
60  */
61 interface IERC165 {
62     /**
63      * @dev Returns true if this contract implements the interface defined by
64      * `interfaceId`. See the corresponding
65      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
66      * to learn more about how these ids are created.
67      *
68      * This function call must use less than 30 000 gas.
69      */
70     function supportsInterface(bytes4 interfaceId) external view returns (bool);
71 }
72 
73 /// @author Stefan George - <stefan.george@consensys.net> - adjusted by the Calystral Team
74 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
75 interface IMultiSigEthAdmin is IERC1155TokenReceiver, IERC165 {
76     /*==============================
77     =           EVENTS             =
78     ==============================*/
79     event Confirmation(address indexed sender, uint256 indexed transactionId);
80     event Revocation(address indexed sender, uint256 indexed transactionId);
81     event Submission(uint256 indexed transactionId);
82     event Execution(uint256 indexed transactionId);
83     event ExecutionFailure(uint256 indexed transactionId);
84     event Deposit(address indexed sender, uint256 value);
85     event OwnerAddition(address indexed owner);
86     event OwnerRemoval(address indexed owner);
87     event RequirementChange(uint256 required);
88 
89     /*==============================
90     =          FUNCTIONS           =
91     ==============================*/
92     /// @dev Fallback function allows to deposit ether.
93     receive() external payable;
94 
95     /// @dev Allows an owner to submit and confirm a transaction.
96     /// @param destination Transaction target address.
97     /// @param value Transaction ether value.
98     /// @param data Transaction data payload.
99     /// @return transactionId transactionId Returns transaction ID.
100     function submitTransaction(
101         address destination,
102         uint256 value,
103         bytes memory data
104     ) external returns (uint256 transactionId);
105 
106     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
107     /// @param owner Address of new owner.
108     function addOwner(address owner) external;
109 
110     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
111     /// @param owner Address of owner.
112     function removeOwner(address owner) external;
113 
114     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
115     /// @param owner Address of owner to be replaced.
116     /// @param newOwner Address of new owner.
117     function replaceOwner(address owner, address newOwner) external;
118 
119     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
120     /// @param _required Number of required confirmations.
121     function changeRequirement(uint256 _required) external;
122 
123     /// @dev Allows an owner to confirm a transaction.
124     /// @param transactionId Transaction ID.
125     function confirmTransaction(uint256 transactionId) external;
126 
127     /// @dev Allows an owner to revoke a confirmation for a transaction.
128     /// @param transactionId Transaction ID.
129     function revokeConfirmation(uint256 transactionId) external;
130 
131     /// @dev Allows anyone to execute a confirmed transaction.
132     /// @param transactionId Transaction ID.
133     function executeTransaction(uint256 transactionId) external;
134 
135     /*==============================
136     =          VIEW & PURE         =
137     ==============================*/
138     /// @dev Returns the confirmation status of a transaction.
139     /// @param transactionId Transaction ID.
140     /// @return isConfirmed Confirmation status.
141     function isConfirmed(uint256 transactionId) external view returns (bool);
142 
143     /// @dev Returns number of confirmations of a transaction.
144     /// @param transactionId Transaction ID.
145     /// @return count Number of confirmations.
146     function getConfirmationCount(uint256 transactionId)
147         external
148         view
149         returns (uint256 count);
150 
151     /// @dev Returns total number of transactions after filers are applied.
152     /// @param pending Include pending transactions.
153     /// @param executed Include executed transactions.
154     /// @return count Total number of transactions after filters are applied.
155     function getTransactionCount(bool pending, bool executed)
156         external
157         view
158         returns (uint256 count);
159 
160     /// @dev Returns list of owners.
161     /// @return owners List of owner addresses.
162     function getOwners() external view returns (address[] memory);
163 
164     /// @dev Returns the amount of required confirmations.
165     /// @return required Amount of required confirmations.
166     function getRequired() external view returns (uint256);
167 
168     /// @dev Returns array with owner addresses, which confirmed transaction.
169     /// @param transactionId Transaction ID.
170     /// @return _confirmations Returns array of owner addresses.
171     function getConfirmations(uint256 transactionId)
172         external
173         view
174         returns (address[] memory _confirmations);
175 
176     /// @dev Returns list of transaction IDs in defined range.
177     /// @param from Index start position of transaction array.
178     /// @param to Index end position of transaction array.
179     /// @param pending Include pending transactions.
180     /// @param executed Include executed transactions.
181     /// @return _transactionIds Returns array of transaction IDs.
182     function getTransactionIds(
183         uint256 from,
184         uint256 to,
185         bool pending,
186         bool executed
187     ) external view returns (uint256[] memory _transactionIds);
188 }
189 
190 /// @title Multisignature Payments wallet for Ethereum
191 /// @author The Calystral Team
192 interface IMultiSigEthPayments is IMultiSigEthAdmin {
193     /*==============================
194     =            EVENTS            =
195     ==============================*/
196     /**
197         @dev MUST emit when a token allowance changes.
198         The `tokenAddress` argument MUST be the token address.
199         The `allowed` argument MUST be the allowance.
200     */
201     event OnTokenUpdate(address indexed tokenAddress, bool allowed);
202     /**
203         @dev MUST emit when the withdraw address changes.
204         The `withdrawAddress` argument MUST be the withdraw address.
205     */
206     event OnWithdrawAddressUpdate(address withdrawAddress);
207     /**
208         @dev MUST emit when an is payed with ETH.
209         The `orderId` argument MUST be the orderId.
210         The `amount` argument MUST be the amount payed in WEI.
211     */
212     event OnPayedEthOrder(uint256 indexed orderId, uint256 amount);
213     /**
214         @dev MUST emit when an is payed with a token.
215         The `orderId` argument MUST be the orderId.
216         The `tokenAddress` argument MUST be the token's contract address.
217         The `amount` argument MUST be the amount payed in full DECIMALS of the token.
218     */
219     event OnPayedTokenOrder(
220         uint256 indexed orderId,
221         address indexed tokenAddress,
222         uint256 amount
223     );
224     /**
225         @dev MUST emit when ETH is withdrawn through withdraw function.
226         The `receiver` argument MUST be the receiving address.
227         The `amount` argument MUST be the amount payed in WEI.
228     */
229     event OnEthWithdraw(address indexed receiver, uint256 amount);
230     /**
231         @dev MUST emit when a token is withdrawn through withdrawToken function.
232         The `receiver` argument MUST be the receiving address.
233         The `tokenAddress` argument MUST be the token's contract address.
234         The `amount` argument MUST be the amount payed in full DECIMALS of the token.
235     */
236     event OnTokenWithdraw(
237         address indexed receiver,
238         address indexed tokenAddress,
239         uint256 amount
240     );
241 
242     /*==============================
243     =          FUNCTIONS           =
244     ==============================*/
245     /**
246         @notice Used to pay an open order with ETH.
247         @dev Payable function used to pay a created order in ETH. 
248         @param orderId The orderId
249     */
250     function payEthOrder(uint256 orderId) external payable;
251 
252     /**
253         @notice Used to pay an open order with an allowed ERC20 token.
254         @dev Used to pay a created order with an allowed ERC20 token.
255         @param orderId      The orderId
256         @param tokenAddress The smart contract address of the ERC20 token
257         @param amount       The amount of tokens payed
258     */
259     function payTokenOrder(
260         uint256 orderId,
261         address tokenAddress,
262         uint256 amount
263     ) external;
264 
265     /**
266         @notice Adds or removes a specific ERC20 token for payments.
267         @dev Adds or removes the address of an ERC20 contract for valid payment options.
268         @param tokenAddress The smart contract address of the ERC20 token
269         @param allowed      True or False as the allowence
270     */
271     function updateAllowedToken(address tokenAddress, bool allowed) external;
272 
273     /**
274         @notice Withdraws ETH to the specified withdraw address.
275         @dev Withdraws ETH to the specified `_withdrawAddress`.
276     */
277     function withdraw() external;
278 
279     /**
280         @notice Withdraws a token to the specified withdraw address.
281         @dev Withdraws a token to the specified `_withdrawAddress`.
282         @param tokenAddress The smart contract address of the ERC20 token
283     */
284     function withdrawToken(address tokenAddress) external;
285 
286     /**
287         @notice Updated the withdraw address.
288         @dev Updates `_withdrawAddress`.
289         @param withdrawAddress The withdraw address
290     */
291     function updateWithdrawAddress(address payable withdrawAddress) external;
292 
293     /**
294         @notice Used to check if a specific token is allowed providing the token's contract address.
295         @dev Used to check if a specific token is allowed providing the token's contract address.
296         @param tokenAddress The smart contract address of the ERC20 token
297         @return             Returns True or False
298     */
299     function isTokenAllowed(address tokenAddress) external view returns (bool);
300 
301     /**
302         @notice Used to check if a specific order is payed already by orderId.
303         @dev Used to check if a specific order is payed already by orderId.
304         @param orderId  The orderId
305         @return         Returns True or False
306     */
307     function isOrderIdExecuted(uint256 orderId) external view returns (bool);
308 
309     /**
310         @notice Gets the withdraw address.
311         @dev Gets the `_withdrawAddress`.
312         @return Returns the withdraw address
313     */
314     function getWithdrawAddress() external view returns (address);
315 }
316 
317 /**
318     Note: Simple contract to use as base for const vals
319 */
320 contract CommonConstants {
321     bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
322     bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
323 }
324 
325 /**
326  * @dev Implementation of the {IERC165} interface.
327  *
328  * Contracts may inherit from this and call {_registerInterface} to declare
329  * their support of an interface.
330  */
331 abstract contract ERC165 is IERC165 {
332     /*
333      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
334      */
335     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
336 
337     /**
338      * @dev Mapping of interface ids to whether or not it's supported.
339      */
340     mapping(bytes4 => bool) private _supportedInterfaces;
341 
342     constructor() {
343         // Derived contracts need only register support for their own interfaces,
344         // we register support for ERC165 itself here
345         _registerInterface(_INTERFACE_ID_ERC165);
346     }
347 
348     /**
349      * @dev See {IERC165-supportsInterface}.
350      *
351      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId)
354         public
355         view
356         override
357         returns (bool)
358     {
359         return _supportedInterfaces[interfaceId];
360     }
361 
362     /**
363      * @dev Registers the contract as an implementer of the interface defined by
364      * `interfaceId`. Support of the actual ERC165 interface is automatic and
365      * registering its interface id is not required.
366      *
367      * See {IERC165-supportsInterface}.
368      *
369      * Requirements:
370      *
371      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
372      */
373     function _registerInterface(bytes4 interfaceId) internal virtual {
374         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
375         _supportedInterfaces[interfaceId] = true;
376     }
377 }
378 
379 /// @author Stefan George - <stefan.george@consensys.net> - adjusted by the Calystral Team
380 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
381 contract MultiSigEthAdmin is IMultiSigEthAdmin, ERC165, CommonConstants {
382     /*==============================
383     =          CONSTANTS           =
384     ==============================*/
385     uint256 public constant MAX_OWNER_COUNT = 50;
386 
387     /*==============================
388     =            STORAGE           =
389     ==============================*/
390     mapping(uint256 => Transaction) public transactions;
391     mapping(uint256 => mapping(address => bool)) public confirmations;
392     mapping(address => bool) public isOwner;
393     address[] public owners;
394     uint256 public required;
395     uint256 public transactionCount;
396 
397     struct Transaction {
398         address destination;
399         uint256 value;
400         bytes data;
401         bool executed;
402     }
403 
404     /*==============================
405     =          MODIFIERS           =
406     ==============================*/
407     modifier isAuthorizedWallet() {
408         require(
409             msg.sender == address(this),
410             "Can only be executed by the wallet contract itself."
411         );
412         _;
413     }
414 
415     modifier isAuthorizedOwner(address owner) {
416         require(isOwner[owner], "This address is not an owner.");
417         _;
418     }
419 
420     modifier ownerDoesNotExist(address owner) {
421         require(!isOwner[owner], "This address is an owner.");
422         _;
423     }
424 
425     modifier transactionExists(uint256 transactionId) {
426         require(
427             transactions[transactionId].destination != address(0x0),
428             "The transaction destination does not exist."
429         );
430         _;
431     }
432 
433     modifier confirmed(uint256 transactionId, address owner) {
434         require(
435             confirmations[transactionId][owner],
436             "The owner did not confirm this transactionId yet."
437         );
438         _;
439     }
440 
441     modifier notConfirmed(uint256 transactionId, address owner) {
442         require(
443             !confirmations[transactionId][owner],
444             "This owner did confirm this transactionId already."
445         );
446         _;
447     }
448 
449     modifier notExecuted(uint256 transactionId) {
450         require(
451             !transactions[transactionId].executed,
452             "This transactionId is executed already."
453         );
454         _;
455     }
456 
457     modifier notNull(address _address) {
458         require(_address != address(0x0), "The zero-address is not allowed.");
459         _;
460     }
461 
462     modifier validRequirement(uint256 ownerCount, uint256 _required) {
463         require(
464             ownerCount <= MAX_OWNER_COUNT &&
465                 _required <= ownerCount &&
466                 _required != 0 &&
467                 ownerCount != 0,
468             "This change in requirement is not allowed."
469         );
470         _;
471     }
472 
473     /*==============================
474     =          CONSTRUCTOR         =
475     ==============================*/
476     /// @dev Contract constructor sets initial owners and required number of confirmations.
477     /// @param _owners List of initial owners.
478     /// @param _required Number of required confirmations.
479     constructor(address[] memory _owners, uint256 _required)
480         validRequirement(_owners.length, _required)
481     {
482         for (uint256 i = 0; i < _owners.length; i++) {
483             require(
484                 !isOwner[_owners[i]] && _owners[i] != address(0x0),
485                 "An owner address is included multiple times or as the zero-address."
486             );
487             isOwner[_owners[i]] = true;
488         }
489         owners = _owners;
490         required = _required;
491 
492         _registerInterface(type(IERC1155TokenReceiver).interfaceId); // 0x4e2312e0
493         _registerInterface(type(IMultiSigEthAdmin).interfaceId);
494     }
495 
496     /*==============================
497     =      PUBLIC & EXTERNAL       =
498     ==============================*/
499     receive() external payable override {
500         if (msg.value > 0) {
501             emit Deposit(msg.sender, msg.value);
502         }
503     }
504 
505     function submitTransaction(
506         address destination,
507         uint256 value,
508         bytes memory data
509     ) public override returns (uint256 transactionId) {
510         transactionId = addTransaction(destination, value, data);
511         confirmTransaction(transactionId);
512     }
513 
514     /*==============================
515     =          RESTRICTED          =
516     ==============================*/
517     function addOwner(address owner)
518         public
519         override
520         isAuthorizedWallet()
521         ownerDoesNotExist(owner)
522         notNull(owner)
523         validRequirement(owners.length + 1, required)
524     {
525         isOwner[owner] = true;
526         owners.push(owner);
527         emit OwnerAddition(owner);
528     }
529 
530     function removeOwner(address owner)
531         public
532         override
533         isAuthorizedWallet()
534         isAuthorizedOwner(owner)
535     {
536         isOwner[owner] = false;
537         for (uint256 i = 0; i < owners.length - 1; i++)
538             if (owners[i] == owner) {
539                 owners[i] = owners[owners.length - 1];
540                 break;
541             }
542         owners.pop(); //owners.length -= 1;
543         if (required > owners.length) changeRequirement(owners.length);
544         emit OwnerRemoval(owner);
545     }
546 
547     function replaceOwner(address owner, address newOwner)
548         public
549         override
550         isAuthorizedWallet()
551         isAuthorizedOwner(owner)
552         ownerDoesNotExist(newOwner)
553     {
554         for (uint256 i = 0; i < owners.length; i++)
555             if (owners[i] == owner) {
556                 owners[i] = newOwner;
557                 break;
558             }
559         isOwner[owner] = false;
560         isOwner[newOwner] = true;
561         emit OwnerRemoval(owner);
562         emit OwnerAddition(newOwner);
563     }
564 
565     function changeRequirement(uint256 _required)
566         public
567         override
568         isAuthorizedWallet()
569         validRequirement(owners.length, _required)
570     {
571         required = _required;
572         emit RequirementChange(_required);
573     }
574 
575     function confirmTransaction(uint256 transactionId)
576         public
577         override
578         isAuthorizedOwner(msg.sender)
579         transactionExists(transactionId)
580         notConfirmed(transactionId, msg.sender)
581     {
582         confirmations[transactionId][msg.sender] = true;
583         emit Confirmation(msg.sender, transactionId);
584         executeTransaction(transactionId);
585     }
586 
587     function revokeConfirmation(uint256 transactionId)
588         public
589         override
590         isAuthorizedOwner(msg.sender)
591         confirmed(transactionId, msg.sender)
592         notExecuted(transactionId)
593     {
594         confirmations[transactionId][msg.sender] = false;
595         emit Revocation(msg.sender, transactionId);
596     }
597 
598     function executeTransaction(uint256 transactionId)
599         public
600         override
601         isAuthorizedOwner(msg.sender)
602         confirmed(transactionId, msg.sender)
603         notExecuted(transactionId)
604     {
605         if (isConfirmed(transactionId)) {
606             Transaction storage txn = transactions[transactionId];
607             txn.executed = true;
608             if (
609                 external_call(
610                     txn.destination,
611                     txn.value,
612                     txn.data.length,
613                     txn.data
614                 )
615             ) {
616                 emit Execution(transactionId);
617             } else {
618                 emit ExecutionFailure(transactionId);
619                 txn.executed = false;
620             }
621         }
622     }
623 
624     /*==============================
625     =          VIEW & PURE         =
626     ==============================*/
627     function isConfirmed(uint256 transactionId)
628         public
629         view
630         override
631         returns (bool)
632     {
633         uint256 count = 0;
634         for (uint256 i = 0; i < owners.length; i++) {
635             if (confirmations[transactionId][owners[i]]) count += 1;
636             if (count == required) return true;
637         }
638         return false;
639     }
640 
641     function getConfirmationCount(uint256 transactionId)
642         public
643         view
644         override
645         returns (uint256 count)
646     {
647         for (uint256 i = 0; i < owners.length; i++)
648             if (confirmations[transactionId][owners[i]]) count += 1;
649     }
650 
651     function getTransactionCount(bool pending, bool executed)
652         public
653         view
654         override
655         returns (uint256 count)
656     {
657         for (uint256 i = 0; i < transactionCount; i++)
658             if (
659                 (pending && !transactions[i].executed) ||
660                 (executed && transactions[i].executed)
661             ) count += 1;
662     }
663 
664     function getOwners() public view override returns (address[] memory) {
665         return owners;
666     }
667 
668     function getRequired() public view override returns (uint256) {
669         return required;
670     }
671 
672     function getConfirmations(uint256 transactionId)
673         public
674         view
675         override
676         returns (address[] memory _confirmations)
677     {
678         address[] memory confirmationsTemp = new address[](owners.length);
679         uint256 count = 0;
680         uint256 i;
681         for (i = 0; i < owners.length; i++)
682             if (confirmations[transactionId][owners[i]]) {
683                 confirmationsTemp[count] = owners[i];
684                 count += 1;
685             }
686         _confirmations = new address[](count);
687         for (i = 0; i < count; i++) _confirmations[i] = confirmationsTemp[i];
688     }
689 
690     function getTransactionIds(
691         uint256 from,
692         uint256 to,
693         bool pending,
694         bool executed
695     ) public view override returns (uint256[] memory _transactionIds) {
696         uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
697         uint256 count = 0;
698         uint256 i;
699         for (i = 0; i < transactionCount; i++)
700             if (
701                 (pending && !transactions[i].executed) ||
702                 (executed && transactions[i].executed)
703             ) {
704                 transactionIdsTemp[count] = i;
705                 count += 1;
706             }
707         _transactionIds = new uint256[](to - from);
708         for (i = from; i < to; i++)
709             _transactionIds[i - from] = transactionIdsTemp[i];
710     }
711 
712     function onERC1155Received(
713         address,
714         address,
715         uint256,
716         uint256,
717         bytes calldata
718     ) external pure override returns (bytes4) {
719         return ERC1155_ACCEPTED;
720     }
721 
722     function onERC1155BatchReceived(
723         address,
724         address,
725         uint256[] calldata,
726         uint256[] calldata,
727         bytes calldata
728     ) external pure override returns (bytes4) {
729         return ERC1155_BATCH_ACCEPTED;
730     }
731 
732     /*==============================
733     =      INTERNAL & PRIVATE      =
734     ==============================*/
735     // call has been separated into its own function in order to take advantage
736     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
737     function external_call(
738         address destination,
739         uint256 value,
740         uint256 dataLength,
741         bytes memory data
742     ) internal returns (bool) {
743         bool result;
744         assembly {
745             let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
746             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
747             result := call(
748                 sub(gas(), 34710), // 34710 is the value that solidity is currently emitting
749                 // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
750                 // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
751                 destination,
752                 value,
753                 d,
754                 dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
755                 x,
756                 0 // Output is ignored, therefore the output size is zero
757             )
758         }
759         return result;
760     }
761 
762     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
763     /// @param destination Transaction target address.
764     /// @param value Transaction ether value.
765     /// @param data Transaction data payload.
766     /// @return transactionId Returns transaction ID.
767     function addTransaction(
768         address destination,
769         uint256 value,
770         bytes memory data
771     ) internal notNull(destination) returns (uint256 transactionId) {
772         transactionId = transactionCount;
773         transactions[transactionId] = Transaction({
774             destination: destination,
775             value: value,
776             data: data,
777             executed: false
778         });
779         transactionCount += 1;
780         emit Submission(transactionId);
781     }
782 }
783 
784 /**
785  * @dev Interface of the ERC20 standard as defined in the EIP.
786  */
787 interface IERC20 {
788     /**
789      * @dev Returns the amount of tokens in existence.
790      */
791     function totalSupply() external view returns (uint256);
792 
793     /**
794      * @dev Returns the amount of tokens owned by `account`.
795      */
796     function balanceOf(address account) external view returns (uint256);
797 
798     /**
799      * @dev Moves `amount` tokens from the caller's account to `recipient`.
800      *
801      * Returns a boolean value indicating whether the operation succeeded.
802      *
803      * Emits a {Transfer} event.
804      */
805     function transfer(address recipient, uint256 amount)
806         external
807         returns (bool);
808 
809     /**
810      * @dev Returns the remaining number of tokens that `spender` will be
811      * allowed to spend on behalf of `owner` through {transferFrom}. This is
812      * zero by default.
813      *
814      * This value changes when {approve} or {transferFrom} are called.
815      */
816     function allowance(address owner, address spender)
817         external
818         view
819         returns (uint256);
820 
821     /**
822      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
823      *
824      * Returns a boolean value indicating whether the operation succeeded.
825      *
826      * IMPORTANT: Beware that changing an allowance with this method brings the risk
827      * that someone may use both the old and the new allowance by unfortunate
828      * transaction ordering. One possible solution to mitigate this race
829      * condition is to first reduce the spender's allowance to 0 and set the
830      * desired value afterwards:
831      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
832      *
833      * Emits an {Approval} event.
834      */
835     function approve(address spender, uint256 amount) external returns (bool);
836 
837     /**
838      * @dev Moves `amount` tokens from `sender` to `recipient` using the
839      * allowance mechanism. `amount` is then deducted from the caller's
840      * allowance.
841      *
842      * Returns a boolean value indicating whether the operation succeeded.
843      *
844      * Emits a {Transfer} event.
845      */
846     function transferFrom(
847         address sender,
848         address recipient,
849         uint256 amount
850     ) external returns (bool);
851 
852     /**
853      * @dev Emitted when `value` tokens are moved from one account (`from`) to
854      * another (`to`).
855      *
856      * Note that `value` may be zero.
857      */
858     event Transfer(address indexed from, address indexed to, uint256 value);
859 
860     /**
861      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
862      * a call to {approve}. `value` is the new allowance.
863      */
864     event Approval(
865         address indexed owner,
866         address indexed spender,
867         uint256 value
868     );
869 }
870 
871 /// @title Multisignature Payments wallet for Ethereum
872 /// @author The Calystral Team
873 contract MultiSigEthPayments is IMultiSigEthPayments, MultiSigEthAdmin {
874     /*==============================
875     =          CONSTANTS           =
876     ==============================*/
877 
878     /*==============================
879     =            STORAGE           =
880     ==============================*/
881     /// @dev token address => allowance
882     mapping(address => bool) private _tokenAddressIsAllowed;
883     /// @dev orderId => execution
884     mapping(uint256 => bool) private _orderIdIsExecuted;
885     /// @dev The address where any withdraw value is send to
886     address payable private _withdrawAddress;
887 
888     /*==============================
889     =          MODIFIERS           =
890     ==============================*/
891 
892     /*==============================
893     =          CONSTRUCTOR         =
894     ==============================*/
895     /// @dev Contract constructor sets initial owners and required number of confirmations.
896     /// @param _owners List of initial owners.
897     /// @param allowedTokens List of allowed tokens.
898     /// @param _required Number of required confirmations.
899     /// @param withdrawAddress The withdraw address.
900     constructor(
901         address[] memory _owners,
902         address[] memory allowedTokens,
903         uint256 _required,
904         address payable withdrawAddress
905     ) MultiSigEthAdmin(_owners, _required) {
906         require(
907             withdrawAddress != address(0),
908             "A withdraw address is required"
909         );
910 
911         for (uint256 index = 0; index < allowedTokens.length; index++) {
912             _updateAllowedToken(allowedTokens[index], true);
913         }
914 
915         _updateWithdrawAddress(withdrawAddress);
916 
917         _registerInterface(type(IMultiSigEthPayments).interfaceId);
918     }
919 
920     /*==============================
921     =      PUBLIC & EXTERNAL       =
922     ==============================*/
923     function payEthOrder(uint256 orderId) external payable override {
924         require(
925             !_orderIdIsExecuted[orderId],
926             "This order is executed already."
927         );
928         _orderIdIsExecuted[orderId] = true;
929         OnPayedEthOrder(orderId, msg.value);
930     }
931 
932     function payTokenOrder(
933         uint256 orderId,
934         address tokenAddress,
935         uint256 amount
936     ) external override {
937         require(
938             _tokenAddressIsAllowed[tokenAddress],
939             "This token is not allowed."
940         );
941         require(
942             !_orderIdIsExecuted[orderId],
943             "This order is executed already."
944         );
945         IERC20 tokenContract = IERC20(tokenAddress);
946 
947         bool success =
948             tokenContract.transferFrom(msg.sender, address(this), amount);
949         require(success, "Paying the order with tokens failed.");
950 
951         _orderIdIsExecuted[orderId] = true;
952         OnPayedTokenOrder(orderId, tokenAddress, amount);
953     }
954 
955     /*==============================
956     =          RESTRICTED          =
957     ==============================*/
958     function updateAllowedToken(address tokenAddress, bool allowed)
959         public
960         override
961         isAuthorizedWallet()
962     {
963         _updateAllowedToken(tokenAddress, allowed);
964     }
965 
966     function updateWithdrawAddress(address payable withdrawAddress)
967         public
968         override
969         isAuthorizedWallet()
970     {
971         _updateWithdrawAddress(withdrawAddress);
972     }
973 
974     function withdraw() external override isAuthorizedOwner(msg.sender) {
975         uint256 amount = address(this).balance;
976         _withdrawAddress.transfer(amount);
977 
978         emit OnEthWithdraw(_withdrawAddress, amount);
979     }
980 
981     function withdrawToken(address tokenAddress)
982         external
983         override
984         isAuthorizedOwner(msg.sender)
985     {
986         IERC20 erc20Contract = IERC20(tokenAddress);
987         uint256 amount = erc20Contract.balanceOf(address(this));
988         erc20Contract.transfer(_withdrawAddress, amount);
989 
990         emit OnTokenWithdraw(_withdrawAddress, tokenAddress, amount);
991     }
992 
993     /*==============================
994     =          VIEW & PURE         =
995     ==============================*/
996     function isTokenAllowed(address tokenAddress)
997         public
998         view
999         override
1000         returns (bool)
1001     {
1002         return _tokenAddressIsAllowed[tokenAddress];
1003     }
1004 
1005     function isOrderIdExecuted(uint256 orderId)
1006         public
1007         view
1008         override
1009         returns (bool)
1010     {
1011         return _orderIdIsExecuted[orderId];
1012     }
1013 
1014     function getWithdrawAddress() public view override returns (address) {
1015         return _withdrawAddress;
1016     }
1017 
1018     /*==============================
1019     =      INTERNAL & PRIVATE      =
1020     ==============================*/
1021     function _updateWithdrawAddress(address payable withdrawAddress) private {
1022         _withdrawAddress = withdrawAddress;
1023         OnWithdrawAddressUpdate(withdrawAddress);
1024     }
1025 
1026     function _updateAllowedToken(address tokenAddress, bool allowed) private {
1027         _tokenAddressIsAllowed[tokenAddress] = allowed;
1028         OnTokenUpdate(tokenAddress, allowed);
1029     }
1030 }