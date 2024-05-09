1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File: contracts/abstract/OwnableDelegateProxy.sol
4 
5 
6 pragma solidity 0.8.9;
7 
8 contract OwnableDelegateProxy {}
9 // File: contracts/abstract/ProxyRegistry.sol
10 
11 
12 pragma solidity 0.8.9;
13 
14 
15 // Part: ProxyRegistry
16 
17 contract ProxyRegistry {
18     mapping(address => OwnableDelegateProxy) public proxies;
19 }
20 
21 // File: contracts/abstract/Roles.sol
22 
23 
24 pragma solidity 0.8.9;
25 
26 /**
27  * @title Roles
28  * @dev Library for managing addresses assigned to a Role.
29  */
30 library Roles {
31 
32     struct Role {
33         mapping(address => bool) bearer;
34     }
35 
36     /**
37      * @dev Give an account access to this role.
38      */
39     function add(Role storage role, address account) internal {
40         require(!has(role, account), "Roles: account already has role");
41         role.bearer[account] = true;
42     }
43 
44     /**
45      * @dev Remove an account's access to this role.
46      */
47     function remove(Role storage role, address account) internal {
48         require(has(role, account), "Roles: account does not have role");
49         role.bearer[account] = false;
50     }
51 
52     /**
53      * @dev Check if an account has this role.
54      * @return bool
55      */
56     function has(Role storage role, address account) internal view
57         returns (bool) {
58         require(account != address(0), "Roles: account is the zero address");
59         return role.bearer[account];
60     }
61 }
62 
63 
64 
65 // File: contracts/abstract/IERC1155TokenReceiver.sol
66 
67 
68 pragma solidity 0.8.9;
69 
70 /**
71  * @dev ERC-1155 interface for accepting safe transfers.
72  */
73 interface IERC1155TokenReceiver {
74 
75     /**
76      * @notice Handle the receipt of a single ERC1155 token type
77      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
78      * This function MAY throw to revert and reject the transfer
79      * Return of other amount than the magic value MUST result in the transaction being reverted
80      * Note: The token contract address is always the message sender
81      * @param _operator  The address which called the `safeTransferFrom` function
82      * @param _from      The address which previously owned the token
83      * @param _id        The id of the token being transferred
84      * @param _amount    The amount of tokens being transferred
85      * @param _data      Additional data with no specified format
86      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
87      */
88     function onERC1155Received(
89         address _operator,
90         address _from,
91         uint256 _id,
92         uint256 _amount,
93         bytes calldata _data
94     )
95         external returns (
96             bytes4
97         )
98     ;
99 
100     /**
101      * @notice Handle the receipt of multiple ERC1155 token types
102      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
103      * This function MAY throw to revert and reject the transfer
104      * Return of other amount than the magic value WILL result in the transaction being reverted
105      * Note: The token contract address is always the message sender
106      * @param _operator  The address which called the `safeBatchTransferFrom` function
107      * @param _from      The address which previously owned the token
108      * @param _ids       An array containing ids of each token being transferred
109      * @param _amounts   An array containing amounts of each token being transferred
110      * @param _data      Additional data with no specified format
111      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
112      */
113     function onERC1155BatchReceived(
114         address _operator,
115         address _from,
116         uint256[] calldata _ids,
117         uint256[] calldata _amounts,
118         bytes calldata _data
119     )
120         external returns (
121             bytes4
122         )
123     ;
124 
125     /**
126      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
127      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
128      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
129      *      This function MUST NOT consume more than 5,000 gas.
130      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
131      */
132     function supportsInterface(bytes4 interfaceID) external view returns (bool);
133 }
134 // File: contracts/abstract/ERC1155Metadata.sol
135 
136 
137 pragma solidity 0.8.9;
138 
139 /**
140  * @notice Contract that handles metadata related methods.
141  * @dev Methods assume a deterministic generation of URI based on token IDs.
142  *      Methods also assume that URI uses hex representation of token IDs.
143  */
144 abstract contract ERC1155Metadata {
145 
146     /***********************************|
147      *   |     Metadata Public Function s    |
148      |__________________________________*/
149     /**
150      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
151      * @dev URIs are defined in RFC 3986.
152      *      URIs are assumed to be deterministically generated based on token ID
153      *      Token IDs are assumed to be represented in their hex format in URIs
154      * @return URI string
155      */
156     function uri(uint256 _id) external view virtual returns (string memory);
157 }
158 
159 
160 
161 // File: contracts/abstract/IERC1155.sol
162 
163 
164 pragma solidity 0.8.9;
165 
166 interface IERC1155 {
167     // Events
168     /**
169      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
170      *   Operator MUST be msg.sender
171      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
172      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
173      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
174      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
175      */
176     event TransferSingle(address indexed _operator,
177         address indexed _from,
178         address indexed _to,
179         uint256 _id,
180         uint256 _amount);
181 
182     /**
183      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
184      *   Operator MUST be msg.sender
185      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
186      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
187      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
188      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
189      */
190     event TransferBatch(address indexed _operator,
191         address indexed _from,
192         address indexed _to,
193         uint256[] _ids,
194         uint256[] _amounts);
195 
196     /**
197      * @dev MUST emit when an approval is updated
198      */
199     event ApprovalForAll(address indexed _owner,
200         address indexed _operator,
201         bool _approved);
202 
203     /**
204      * @dev MUST emit when the URI is updated for a token ID
205      *   URIs are defined in RFC 3986
206      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
207      */
208     event URI(string _uri, uint256 indexed _id);
209 
210     /**
211      * @notice Transfers amount of an _id from the _from address to the _to address specified
212      * @dev MUST emit TransferSingle event on success
213      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
214      * MUST throw if `_to` is the zero address
215      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
216      * MUST throw on any other error
217      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
218      * @param _from    Source address
219      * @param _to      Target address
220      * @param _id      ID of the token type
221      * @param _amount  Transfered amount
222      * @param _data    Additional data with no specified format, sent in call to `_to`
223      */
224     function safeTransferFrom(
225         address _from,
226         address _to,
227         uint256 _id,
228         uint256 _amount,
229         bytes calldata _data
230     )
231         external;
232 
233     /**
234      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
235      * @dev MUST emit TransferBatch event on success
236      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
237      * MUST throw if `_to` is the zero address
238      * MUST throw if length of `_ids` is not the same as length of `_amounts`
239      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
240      * MUST throw on any other error
241      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
242      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
243      * @param _from     Source addresses
244      * @param _to       Target addresses
245      * @param _ids      IDs of each token type
246      * @param _amounts  Transfer amounts per token type
247      * @param _data     Additional data with no specified format, sent in call to `_to`
248      */
249     function safeBatchTransferFrom(
250         address _from,
251         address _to,
252         uint256[] calldata _ids,
253         uint256[] calldata _amounts,
254         bytes calldata _data
255     )
256         external;
257 
258     /**
259      * @notice Get the balance of an account's Tokens
260      * @param _owner  The address of the token holder
261      * @param _id     ID of the Token
262      * @return        The _owner's balance of the Token type requested
263      */
264     function balanceOf(address _owner, uint256 _id) external view
265         returns (uint256);
266 
267     /**
268      * @notice Get the balance of multiple account/token pairs
269      * @param _owners The addresses of the token holders
270      * @param _ids    ID of the Tokens
271      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
272      */
273     function balanceOfBatch(
274         address[] calldata _owners,
275         uint256[] calldata _ids
276     )
277         external
278         view
279         returns (
280             uint256[] memory
281         )
282     ;
283 
284     /**
285      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
286      * @dev MUST emit the ApprovalForAll event on success
287      * @param _operator  Address to add to the set of authorized operators
288      * @param _approved  True if the operator is approved, false to revoke approval
289      */
290     function setApprovalForAll(address _operator, bool _approved) external;
291 
292     /**
293      * @notice Queries the approval status of an operator for a given owner
294      * @param _owner      The owner of the Tokens
295      * @param _operator   Address of authorized operator
296      * @return isOperator True if the operator is approved, false if not
297      */
298     function isApprovedForAll(
299         address _owner,
300         address _operator
301     )
302         external
303         view
304         returns (
305             bool isOperator
306         )
307     ;
308 }
309 
310 // File: contracts/abstract/IERC165.sol
311 
312 
313 pragma solidity 0.8.9;
314 
315 /**
316  * @title ERC165
317  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
318  */
319 interface IERC165 {
320 
321     /**
322      * @notice Query if a contract implements an interface
323      * @dev Interface identification is specified in ERC-165. This function
324      * uses less than 30,000 gas
325      * @param _interfaceId The interface identifier, as specified in ERC-165
326      */
327     function supportsInterface(bytes4 _interfaceId) external view
328         returns (bool);
329 }
330 // File: contracts/abstract/FundDistribution.sol
331 
332 
333 pragma solidity 0.8.9;
334 
335 /**
336  * @title Fund Distribution interface that could be used by other contracts to reference
337  * TokenFactory/MasterChef in order to enable minting/rewarding to a designated fund address.
338  */
339 interface FundDistribution {
340     /**
341      * @dev an operation that triggers reward distribution by minting to the designated address
342      * from TokenFactory. The fund address must be already configured in TokenFactory to receive
343      * funds, else no funds will be retrieved.
344      */
345     function sendReward(address _fundAddress) external returns (bool);
346 }
347 
348 // File: contracts/abstract/Address.sol
349 
350 
351 pragma solidity 0.8.9;
352 
353 /**
354  * @dev Collection of functions related to the address type
355  */
356 library Address {
357     /**
358      * @dev Returns true if `account` is a contract.
359      *
360      * [IMPORTANT]
361      * ====
362      * It is unsafe to assume that an address for which this function returns
363      * false is an externally-owned account (EOA) and not a contract.
364      *
365      * Among others, `isContract` will return false for the following
366      * types of addresses:
367      *
368      *  - an externally-owned account
369      *  - a contract in construction
370      *  - an address where a contract will be created
371      *  - an address where a contract lived, but was destroyed
372      * ====
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies on extcodesize, which returns 0 for contracts in
376         // construction, since the code is only stored at the end of the
377         // constructor execution.
378 
379         uint256 size;
380         // solhint-disable-next-line no-inline-assembly
381         assembly {
382             size := extcodesize(account)
383         }
384         return size > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(
405             address(this).balance >= amount,
406             "Address: insufficient balance"
407         );
408 
409         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
410         (bool success, ) = recipient.call{value: amount}("");
411         require(
412             success,
413             "Address: unable to send value, recipient may have reverted"
414         );
415     }
416 
417     /**
418      * @dev Performs a Solidity function call using a low level `call`. A
419      * plain`call` is an unsafe replacement for a function call: use this
420      * function instead.
421      *
422      * If `target` reverts with a revert reason, it is bubbled up by this
423      * function (like regular Solidity function calls).
424      *
425      * Returns the raw returned data. To convert to the expected return value,
426      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
427      *
428      * Requirements:
429      *
430      * - `target` must be a contract.
431      * - calling `target` with `data` must not revert.
432      *
433      * _Available since v3.1._
434      */
435     function functionCall(address target, bytes memory data)
436         internal
437         returns (bytes memory)
438     {
439         return functionCall(target, data, "Address: low-level call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
444      * `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, 0, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but also transferring `value` wei to `target`.
459      *
460      * Requirements:
461      *
462      * - the calling contract must have an ETH balance of at least `value`.
463      * - the called Solidity function must be `payable`.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value
471     ) internal returns (bytes memory) {
472         return
473             functionCallWithValue(
474                 target,
475                 data,
476                 value,
477                 "Address: low-level call with value failed"
478             );
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
483      * with `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(
494             address(this).balance >= value,
495             "Address: insufficient balance for call"
496         );
497         require(isContract(target), "Address: call to non-contract");
498 
499         // solhint-disable-next-line avoid-low-level-calls
500         (bool success, bytes memory returndata) = target.call{value: value}(
501             data
502         );
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a static call.
509      *
510      * _Available since v3.3._
511      */
512     function functionStaticCall(address target, bytes memory data)
513         internal
514         view
515         returns (bytes memory)
516     {
517         return
518             functionStaticCall(
519                 target,
520                 data,
521                 "Address: low-level static call failed"
522             );
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         // solhint-disable-next-line avoid-low-level-calls
539         (bool success, bytes memory returndata) = target.staticcall(data);
540         return _verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.3._
548      */
549     function functionDelegateCall(address target, bytes memory data)
550         internal
551         returns (bytes memory)
552     {
553         return
554             functionDelegateCall(
555                 target,
556                 data,
557                 "Address: low-level delegate call failed"
558             );
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.3._
566      */
567     function functionDelegateCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         require(isContract(target), "Address: delegate call to non-contract");
573 
574         // solhint-disable-next-line avoid-low-level-calls
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return _verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     function _verifyCallResult(
580         bool success,
581         bytes memory returndata,
582         string memory errorMessage
583     ) private pure returns (bytes memory) {
584         if (success) {
585             return returndata;
586         } else {
587             // Look for revert reason and bubble it up if present
588             if (returndata.length > 0) {
589                 // The easiest way to bubble the revert reason is using memory via assembly
590 
591                 // solhint-disable-next-line no-inline-assembly
592                 assembly {
593                     let returndata_size := mload(returndata)
594                     revert(add(32, returndata), returndata_size)
595                 }
596             } else {
597                 revert(errorMessage);
598             }
599         }
600     }
601 }
602 
603 
604 
605 // File: contracts/abstract/Context.sol
606 
607 
608 pragma solidity 0.8.9;
609 
610 /*
611  * @dev Provides information about the current execution context, including the
612  * sender of the transaction and its data. While these are generally available
613  * via msg.sender and msg.data, they should not be accessed in such a direct
614  * manner, since when dealing with GSN meta-transactions the account sending and
615  * paying for execution may not be the actual sender (as far as an application
616  * is concerned).
617  * 
618  * This contract is only required for intermediate, library-like contracts.
619  */
620 abstract contract Context {
621     function _msgSender() internal view virtual returns (address) {
622         return msg.sender;
623     }
624 
625     function _msgData() internal view virtual returns (bytes calldata) {
626         return msg.data;
627     }
628 }
629 
630 
631 
632 // File: contracts/abstract/Ownable.sol
633 
634 
635 pragma solidity 0.8.9;
636 
637 
638 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Ownable
639 
640 /**
641  * @dev Contract module which provides a basic access control mechanism, where
642  * there is an account (an owner) that can be granted exclusive access to
643  * specific functions.
644  *
645  * This module is used through inheritance. It will make available the modifier
646  * `onlyOwner`, which can be applied to your functions to restrict their use to
647  * the owner.
648  */
649 abstract contract Ownable is Context {
650     address private _owner;
651 
652     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
653 
654     /**
655      * @dev Initializes the contract setting the deployer as the initial owner.
656      */
657     constructor () {
658         _transferOwnership(_msgSender());
659     }
660 
661     /**
662      * @dev Returns the address of the current owner.
663      */
664     function owner() public view returns (address) {
665         return _owner;
666     }
667 
668     /**
669      * @dev Throws if called by any account other than the owner.
670      */
671     modifier onlyOwner() {
672         require(isOwner(), "Ownable: caller is not the owner");
673         _;
674     }
675 
676     /**
677      * @dev Returns true if the caller is the current owner.
678      */
679     function isOwner() public view returns (bool) {
680         return _msgSender() == _owner;
681     }
682 
683     /**
684      * @dev Leaves the contract without owner. It will not be possible to call
685      * `onlyOwner` functions anymore. Can only be called by the current owner.
686      *
687      * NOTE: Renouncing ownership will leave the contract without an owner,
688      * thereby removing any functionality that is only available to the owner.
689      */
690     function renounceOwnership() public onlyOwner {
691         emit OwnershipTransferred(_owner, address(0));
692         _owner = address(0);
693     }
694 
695     /**
696      * @dev Transfers ownership of the contract to a new account (`newOwner`).
697      * Can only be called by the current owner.
698      */
699     function transferOwnership(address newOwner) public onlyOwner {
700         _transferOwnership(newOwner);
701     }
702 
703     /**
704      * @dev Transfers ownership of the contract to a new account (`newOwner`).
705      */
706     function _transferOwnership(address newOwner) internal {
707         require(newOwner != address(0), "Ownable: new owner is the zero address");
708         emit OwnershipTransferred(_owner, newOwner);
709         _owner = newOwner;
710     }
711 }
712 
713 // File: contracts/abstract/MinterRole.sol
714 
715 
716 pragma solidity 0.8.9;
717 
718 
719 
720 
721 /**
722  * @title MinterRole
723  * @dev Owner is responsible to add/remove minter
724  */
725 contract MinterRole is Context, Ownable {
726 
727     using Roles for Roles.Role;
728 
729     event MinterAdded(address indexed account);
730 
731     event MinterRemoved(address indexed account);
732 
733     Roles.Role private _minters;
734 
735     modifier onlyMinter() {
736         require(
737             isMinter(_msgSender()),
738             "MinterRole: caller does not have the Minter role"
739         );
740         _;
741     }
742 
743     function isMinter(address account) public view returns (bool) {
744         return _minters.has(account);
745     }
746 
747     function addMinter(address account) public onlyOwner {
748         _addMinter(account);
749     }
750 
751     function renounceMinter() public {
752         _removeMinter(_msgSender());
753     }
754 
755     function _addMinter(address account) internal {
756         _minters.add(account);
757         emit MinterAdded(account);
758     }
759 
760     function _removeMinter(address account) internal {
761         _minters.remove(account);
762         emit MinterRemoved(account);
763     }
764 }
765 
766 // File: contracts/abstract/SafeMath.sol
767 
768 
769 pragma solidity 0.8.9;
770 
771 /**
772  * @dev Wrappers over Solidity's arithmetic operations with added overflow
773  * checks.
774  * 
775  * Arithmetic operations in Solidity wrap on overflow. This can easily result
776  * in bugs, because programmers usually assume that an overflow raises an
777  * error, which is the standard behavior in high level programming languages.
778  * `SafeMath` restores this intuition by reverting the transaction when an
779  * operation overflows.
780  * 
781  * Using this library instead of the unchecked operations eliminates an entire
782  * class of bugs, so it's recommended to use it always.
783  */
784 library SafeMath {
785 
786     /**
787      * @dev Returns the addition of two unsigned integers, reverting on
788      * overflow.
789      * 
790      * Counterpart to Solidity's `+` operator.
791      * 
792      * Requirements:
793      * - Addition cannot overflow.
794      */
795     function add(uint256 a, uint256 b) internal pure returns (uint256) {
796         uint256 c = a + b;
797         require(c >= a, "SafeMath: addition overflow");
798 
799         return c;
800     }
801 
802     /**
803      * @dev Returns the subtraction of two unsigned integers, reverting on
804      * overflow (when the result is negative).
805      * 
806      * Counterpart to Solidity's `-` operator.
807      * 
808      * Requirements:
809      * - Subtraction cannot overflow.
810      */
811     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
812         return sub(a, b, "SafeMath: subtraction overflow");
813     }
814 
815     /**
816      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
817      * overflow (when the result is negative).
818      * 
819      * Counterpart to Solidity's `-` operator.
820      * 
821      * Requirements:
822      * - Subtraction cannot overflow.
823      * 
824      * _Available since v2.4.0._
825      */
826     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
827         require(b <= a, errorMessage);
828         uint256 c = a - b;
829 
830         return c;
831     }
832 
833     /**
834      * @dev Returns the multiplication of two unsigned integers, reverting on
835      * overflow.
836      * 
837      * Counterpart to Solidity's `*` operator.
838      * 
839      * Requirements:
840      * - Multiplication cannot overflow.
841      */
842     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
843         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
844         // benefit is lost if 'b' is also tested.
845         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
846         if (a == 0) {
847             return 0;
848         }
849 
850         uint256 c = a * b;
851         require(c / a == b, "SafeMath: multiplication overflow");
852 
853         return c;
854     }
855 
856     /**
857      * @dev Returns the integer division of two unsigned integers. Reverts on
858      * division by zero. The result is rounded towards zero.
859      * 
860      * Counterpart to Solidity's `/` operator. Note: this function uses a
861      * `revert` opcode (which leaves remaining gas untouched) while Solidity
862      * uses an invalid opcode to revert (consuming all remaining gas).
863      * 
864      * Requirements:
865      * - The divisor cannot be zero.
866      */
867     function div(uint256 a, uint256 b) internal pure returns (uint256) {
868         return div(a, b, "SafeMath: division by zero");
869     }
870 
871     /**
872      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
873      * division by zero. The result is rounded towards zero.
874      * 
875      * Counterpart to Solidity's `/` operator. Note: this function uses a
876      * `revert` opcode (which leaves remaining gas untouched) while Solidity
877      * uses an invalid opcode to revert (consuming all remaining gas).
878      * 
879      * Requirements:
880      * - The divisor cannot be zero.
881      * 
882      * _Available since v2.4.0._
883      */
884     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
885         // Solidity only automatically asserts when dividing by 0
886         require(b > 0, errorMessage);
887         uint256 c = a / b;
888         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
889         return c;
890     }
891 
892     /**
893      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
894      * Reverts when dividing by zero.
895      * 
896      * Counterpart to Solidity's `%` operator. This function uses a `revert`
897      * opcode (which leaves remaining gas untouched) while Solidity uses an
898      * invalid opcode to revert (consuming all remaining gas).
899      * 
900      * Requirements:
901      * - The divisor cannot be zero.
902      */
903     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
904         return mod(a, b, "SafeMath: modulo by zero");
905     }
906 
907     /**
908      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
909      * Reverts with custom message when dividing by zero.
910      * 
911      * Counterpart to Solidity's `%` operator. This function uses a `revert`
912      * opcode (which leaves remaining gas untouched) while Solidity uses an
913      * invalid opcode to revert (consuming all remaining gas).
914      * 
915      * Requirements:
916      * - The divisor cannot be zero.
917      * 
918      * _Available since v2.4.0._
919      */
920     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
921         require(b != 0, errorMessage);
922         return a % b;
923     }
924 }
925 
926 
927 
928 // File: contracts/abstract/ERC1155.sol
929 
930 
931 pragma solidity 0.8.9;
932 
933 
934 
935 
936 
937 
938 
939 /**
940  * @dev Implementation of Multi-Token Standard contract
941  */
942 abstract contract ERC1155 is IERC1155, IERC165, ERC1155Metadata {
943     using SafeMath for uint256;
944     using Address for address;
945 
946     /***********************************|
947      *   |        Variables and Events       |
948      |__________________________________*/
949     // onReceive function signatures
950     bytes4 internal constant ERC1155_RECEIVED_VALUE = 0xf23a6e61;
951     bytes4 internal constant ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
952 
953     // Objects balances
954     mapping(address => mapping(uint256 => uint256)) internal balances;
955 
956     // Operator Functions
957     mapping(address => mapping(address => bool)) internal operators;
958 
959     /***********************************|
960      *   |     Public Transfer Functions     |
961      |__________________________________*/
962     /**
963      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
964      * @param _from    Source address
965      * @param _to      Target address
966      * @param _id      ID of the token type
967      * @param _amount  Transfered amount
968      * @param _data    Additional data with no specified format, sent in call to `_to`
969      */
970     function safeTransferFrom(
971         address _from,
972         address _to,
973         uint256 _id,
974         uint256 _amount,
975         bytes memory _data
976     )
977         public override virtual {
978         require((
979                 msg.sender == _from
980                 )
981             || _isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
982         require(_to != address(0), "ERC1155#safeTransferFrom: INVALID_RECIPIENT");
983         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
984         _safeTransferFrom(_from, _to, _id, _amount);
985         _callonERC1155Received(_from, _to, _id, _amount, _data);
986     }
987 
988     /**
989      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
990      * @param _from     Source addresses
991      * @param _to       Target addresses
992      * @param _ids      IDs of each token type
993      * @param _amounts  Transfer amounts per token type
994      * @param _data     Additional data with no specified format, sent in call to `_to`
995      */
996     function safeBatchTransferFrom(
997         address _from,
998         address _to,
999         uint256[] memory _ids,
1000         uint256[] memory _amounts,
1001         bytes memory _data
1002     )
1003         public override virtual {
1004         // Requirements
1005         require((
1006                 msg.sender == _from
1007                 )
1008             || _isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
1009         require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
1010 
1011         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
1012         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
1013     }
1014 
1015     /***********************************|
1016      *   |    Internal Transfer Functions    |
1017      |__________________________________*/
1018     /**
1019      * @dev Transfers amount amount of an _id from the _from address to the _to address specified
1020      * @param _from    Source address
1021      * @param _to      Target address
1022      * @param _id      ID of the token type
1023      * @param _amount  Transfered amount
1024      */
1025     function _safeTransferFrom(
1026         address _from,
1027         address _to,
1028         uint256 _id,
1029         uint256 _amount
1030     )
1031         internal {
1032         // Update balances
1033         balances[_from][_id] = balances[_from][_id].sub (
1034             _amount
1035             )
1036         ; // Subtract amount
1037         balances[_to][_id] = balances[_to][_id].add(_amount); // Add amount
1038         // Emit event
1039         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
1040     }
1041 
1042     /**
1043      * @dev Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
1044      */
1045     function _callonERC1155Received(
1046         address _from,
1047         address _to,
1048         uint256 _id,
1049         uint256 _amount,
1050         bytes memory _data
1051     )
1052         internal {
1053         if (_to.isContract()) {
1054             try IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data) returns (bytes4 response) {
1055                 if (response != ERC1155_RECEIVED_VALUE) {
1056                     revert("ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
1057                 }
1058             } catch Error(string memory reason) {
1059                 revert(reason);
1060             } catch {
1061                 revert("ERC1155#_callonERC1155Received: transfer to non ERC1155Receiver implementer");
1062             }
1063         }
1064     }
1065 
1066     /**
1067      * @dev Send multiple types of Tokens from the _from address to the _to address (with safety call)
1068      * @param _from     Source addresses
1069      * @param _to       Target addresses
1070      * @param _ids      IDs of each token type
1071      * @param _amounts  Transfer amounts per token type
1072      */
1073     function _safeBatchTransferFrom(
1074         address _from,
1075         address _to,
1076         uint256[] memory _ids,
1077         uint256[] memory _amounts
1078     )
1079         internal {
1080         require (
1081             _ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH"
1082             )
1083         ;
1084 
1085         // Number of transfer to execute
1086         uint256 nTransfer = _ids.length;
1087 
1088         // Executing all transfers
1089         for (uint256 i = 0; i < nTransfer;i++) {
1090             // Update storage balance of previous bin
1091             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1092             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1093         }
1094 
1095         // Emit event
1096         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
1097     }
1098 
1099     /**
1100      * @dev Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
1101      */
1102     function _callonERC1155BatchReceived(
1103         address _from,
1104         address _to,
1105         uint256[] memory _ids,
1106         uint256[] memory _amounts,
1107         bytes memory _data
1108     )
1109         internal {
1110         // Check if recipient is contract
1111         if (_to.isContract()
1112         ) {
1113             try IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data) returns (bytes4 response) {
1114                 if (response != ERC1155_BATCH_RECEIVED_VALUE) {
1115                     revert("ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
1116                 }
1117             } catch Error(string memory reason) {
1118                 revert(reason);
1119             } catch {
1120                 revert("ERC1155#_callonERC1155BatchReceived: transfer to non ERC1155Receiver implementer");
1121             }
1122         }
1123     }
1124 
1125     /**
1126      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
1127      * @param _operator  Address to add to the set of authorized operators
1128      * @param _approved  True if the operator is approved, false to revoke approval
1129      */
1130     function setApprovalForAll(address _operator, bool _approved) external override {
1131         // Update operator status
1132         operators[msg.sender][_operator] = _approved;
1133         emit ApprovalForAll(msg.sender, _operator, _approved);
1134     }
1135 
1136     /**
1137      * @dev Queries the approval status of an operator for a given owner
1138      * @param _owner      The owner of the Tokens
1139      * @param _operator   Address of authorized operator
1140      * @return isOperator true if the operator is approved, false if not
1141      */
1142     function _isApprovedForAll(
1143         address _owner,
1144         address _operator
1145     )
1146         internal
1147         view
1148         returns (bool isOperator) {
1149         return operators[_owner][_operator];
1150     }
1151 
1152     /**
1153      * @notice Get the balance of an account's Tokens
1154      * @param _owner  The address of the token holder
1155      * @param _id     ID of the Token
1156      * @return The _owner's balance of the Token type requested
1157      */
1158     function balanceOf(address _owner, uint256 _id) override public view returns (uint256) {
1159         return balances[_owner][_id];
1160     }
1161 
1162     /**
1163      * @notice Get the balance of multiple account/token pairs
1164      * @param _owners The addresses of the token holders
1165      * @param _ids    ID of the Tokens
1166      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1167      */
1168     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
1169         override
1170         public
1171         view
1172         returns (uint256[] memory) {
1173         require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
1174 
1175         // Variables
1176         uint256[] memory batchBalances = new uint256[](_owners.length);
1177 
1178         // Iterate over each owner and token ID
1179         for (uint256 i = 0; i < _owners.length;i++) {
1180             batchBalances[i] = balances[_owners[i]][_ids[i]];
1181         }
1182 
1183         return batchBalances;
1184     }
1185 
1186     /*
1187      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
1188      */
1189     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
1190 
1191     /*
1192      * INTERFACE_SIGNATURE_ERC1155 =
1193      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
1194      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
1195      * bytes4(keccak256("balanceOf(address,uint256)")) ^
1196      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
1197      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
1198      * bytes4(keccak256("isApprovedForAll(address,address)"));
1199      */
1200     bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
1201 
1202     /**
1203      * @notice Query if a contract implements an interface
1204      * @param _interfaceID  The interface identifier, as specified in ERC-165
1205      * @return `true` if the contract implements `_interfaceID` and
1206      */
1207     function supportsInterface(bytes4 _interfaceID) override external pure returns (bool) {
1208         if (_interfaceID == INTERFACE_SIGNATURE_ERC165 || _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
1209             return true;
1210         }
1211         return false;
1212     }
1213 }
1214 
1215 
1216 
1217 // File: contracts/abstract/ERC1155MintBurn.sol
1218 
1219 
1220 pragma solidity 0.8.9;
1221 
1222 
1223 
1224 /**
1225  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1226  *      a parent contract to be executed as they are `internal` functions
1227  */
1228 abstract contract ERC1155MintBurn is ERC1155 {
1229     using SafeMath for uint256;
1230 
1231     /****************************************|
1232      *   |            Minting Functions           |
1233      |_______________________________________*/
1234     /**
1235      * @dev Mint _amount of tokens of a given id
1236      * @param _to      The address to mint tokens to
1237      * @param _id      Token id to mint
1238      * @param _amount  The amount to be minted
1239      * @param _data    Data to pass if receiver is contract
1240      */
1241     function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data) internal {
1242         // Add _amount
1243         balances[_to][_id] = balances[_to][_id].add(_amount);
1244 
1245         // Emit event
1246         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1247 
1248         // Calling onReceive method if recipient is contract
1249         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1250     }
1251 
1252     /**
1253      * @dev Mint tokens for each ids in _ids
1254      * @param _to       The address to mint tokens to
1255      * @param _ids      Array of ids to mint
1256      * @param _amounts  Array of amount of tokens to mint per id
1257      * @param _data    Data to pass if receiver is contract
1258      */
1259     function _batchMint(
1260         address _to,
1261         uint256[] memory _ids,
1262         uint256[] memory _amounts,
1263         bytes memory _data
1264     )
1265         internal {
1266         require (
1267             _ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH"
1268             )
1269         ;
1270 
1271         // Number of mints to execute
1272         uint256 nMint = _ids.length;
1273 
1274         // Executing all minting
1275         for (uint256 i = 0; i < nMint;i++) {
1276             // Update storage balance
1277             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1278         }
1279 
1280         // Emit batch mint event
1281         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1282 
1283         // Calling onReceive method if recipient is contract
1284         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1285     }
1286 
1287     /****************************************|
1288      *   |            Burning Functions           |
1289      |_______________________________________*/
1290     /**
1291      * @dev Burn _amount of tokens of a given token id
1292      * @param _from    The address to burn tokens from
1293      * @param _id      Token id to burn
1294      * @param _amount  The amount to be burned
1295      */
1296     function _burn(address _from, uint256 _id,
1297         uint256 _amount) internal {
1298         // Substract _amount
1299         balances[_from][_id] = balances[_from][_id].sub(_amount);
1300 
1301         // Emit event
1302         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1303     }
1304 
1305     /**
1306      * @dev Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1307      * @param _from     The address to burn tokens from
1308      * @param _ids      Array of token ids to burn
1309      * @param _amounts  Array of the amount to be burned
1310      */
1311     function _batchBurn(
1312         address _from,
1313         uint256[] memory _ids,
1314         uint256[] memory _amounts
1315     )
1316         internal {
1317         require (
1318             _ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH"
1319             )
1320         ;
1321 
1322         // Number of mints to execute
1323         uint256 nBurn = _ids.length;
1324 
1325         // Executing all minting
1326         for (uint256 i = 0; i < nBurn;i++) {
1327             // Update storage balance
1328             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1329         }
1330 
1331         // Emit batch mint event
1332         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1333     }
1334 }
1335 
1336 
1337 
1338 // File: contracts/abstract/ERC1155Tradable.sol
1339 
1340 
1341 pragma solidity 0.8.9;
1342 
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 /**
1351  * @title ERC1155Tradable
1352  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1353  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1354  *   like _exists(), name(), symbol(), and totalSupply()
1355  */
1356 abstract contract ERC1155Tradable is ERC1155MintBurn, Ownable, MinterRole {
1357     using SafeMath for uint256;
1358     using Address for address;
1359 
1360     // OpenSea proxy registry to ease selling NFTs on OpenSea
1361     address public proxyRegistryAddress;
1362 
1363     mapping(uint256 => address) public creators;
1364     mapping(uint256 => uint256) public tokenSupply;
1365     mapping(uint256 => uint256) public tokenMaxSupply;
1366     mapping(uint256 => uint8) public tokenCityIndex;
1367     mapping(uint256 => uint8) public tokenType;
1368 
1369     // Contract name
1370     string public name;
1371 
1372     // Contract symbol
1373     string public symbol;
1374 
1375     // URI's default URI prefix
1376     string internal baseMetadataURI;
1377 
1378     uint256 internal _currentTokenID = 0;
1379 
1380     constructor (string memory _name, string memory _symbol, address _proxyRegistryAddress, string memory _baseMetadataURI) {
1381         name = _name;
1382         symbol = _symbol;
1383         proxyRegistryAddress = _proxyRegistryAddress;
1384         baseMetadataURI = _baseMetadataURI;
1385     }
1386 
1387     function contractURI() public view returns (string memory) {
1388         return string(abi.encodePacked(baseMetadataURI));
1389     }
1390 
1391     /**
1392      * @dev Returns URIs are defined in RFC 3986.
1393      *      URIs are assumed to be deterministically generated based on token ID
1394      *      Token IDs are assumed to be represented in their hex format in URIs
1395      * @return URI string
1396      */
1397     function uri(uint256 _id) override external view returns (string memory) {
1398         require(_exists(_id), "Deed NFT doesn't exists");
1399         return string(abi.encodePacked(baseMetadataURI, _uint2str(_id)));
1400     }
1401 
1402     /**
1403      * @dev Returns the total quantity for a token ID
1404      * @param _id uint256 ID of the token to query
1405      * @return amount of token in existence
1406      */
1407     function totalSupply(uint256 _id) public view returns (uint256) {
1408         return tokenSupply[_id];
1409     }
1410 
1411     /**
1412      * @dev Returns the max quantity for a token ID
1413      * @param _id uint256 ID of the token to query
1414      * @return amount of token in existence
1415      */
1416     function maxSupply(uint256 _id) public view returns (uint256) {
1417         return tokenMaxSupply[_id];
1418     }
1419 
1420     /**
1421      * @dev return city index of designated NFT with its identifier
1422      */
1423     function cityIndex(uint256 _id) public view returns (uint256) {
1424         require(_exists(_id), "Deed NFT doesn't exists");
1425         return tokenCityIndex[_id];
1426     }
1427 
1428     /**
1429      * @dev return card type of designated NFT with its identifier
1430      */
1431     function cardType(uint256 _id) public view returns (uint256) {
1432         require(_exists(_id), "Deed NFT doesn't exists");
1433         return tokenType[_id];
1434     }
1435 
1436     /**
1437      * @dev Creates a new token type and assigns _initialSupply to an address
1438      * @param _initialOwner the first owner of the Token
1439      * @param _initialSupply Optional amount to supply the first owner (1 for NFT)
1440      * @param _maxSupply max supply allowed (1 for NFT)
1441      * @param _cityIndex city index of NFT
1442      *    (0 = Tanit, 1 = Reshef, 2 = Ashtarte, 3 = Melqart, 4 = Eshmun, 5 = Kushor, 6 = Hammon)
1443      * @param _type card type of NFT
1444      *    (0 = Common, 1 = Uncommon, 2 = Rare, 3 = Legendary)
1445      * @param _data Optional data to pass if receiver is contract
1446      * @return The newly created token ID
1447      */
1448     function create(
1449         address _initialOwner,
1450         uint256 _initialSupply,
1451         uint256 _maxSupply,
1452         uint8 _cityIndex,
1453         uint8 _type,
1454         bytes memory _data
1455     ) public onlyMinter returns (uint256) {
1456         require(_initialSupply <= _maxSupply, "_initialSupply > _maxSupply");
1457         uint256 _id = _getNextTokenID();
1458         _incrementTokenTypeId();
1459         creators[_id] = _initialOwner;
1460 
1461         if (_initialSupply != 0) {
1462             _mint(_initialOwner, _id, _initialSupply, _data);
1463         }
1464         tokenSupply[_id] = _initialSupply;
1465         tokenMaxSupply[_id] = _maxSupply;
1466         tokenCityIndex[_id] = _cityIndex;
1467         tokenType[_id] = _type;
1468         return _id;
1469     }
1470 
1471     /**
1472      * @dev Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1473      * @param _owner      The owner of the Tokens
1474      * @param _operator   Address of authorized operator
1475      * @return isOperator true if the operator is approved, false if not
1476      */
1477     function isApprovedForAll(address _owner, address _operator) override public view returns (bool isOperator) {
1478         // Whitelist OpenSea proxy contract for easy trading.
1479         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1480         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1481             return true;
1482         }
1483 
1484         return _isApprovedForAll(_owner, _operator);
1485     }
1486 
1487     /**
1488      * @dev Returns whether the specified token exists by checking to see if it has a creator
1489      * @param _id uint256 ID of the token to query the existence of
1490      * @return bool whether the token exists
1491      */
1492     function _exists(uint256 _id) internal view returns (bool) {
1493         return creators[_id] != address(0);
1494     }
1495 
1496     /**
1497      * @dev calculates the next token ID based on value of _currentTokenID
1498      * @return uint256 for the next token ID
1499      */
1500     function _getNextTokenID() private view returns (uint256) {
1501         return _currentTokenID.add(1);
1502     }
1503 
1504     /**
1505      * @dev increments the value of _currentTokenID
1506      */
1507     function _incrementTokenTypeId() private {
1508         _currentTokenID++;
1509     }
1510 
1511     /**
1512      * @dev Convert uint256 to string
1513      * @param _i Unsigned integer to convert to string
1514      */
1515     function _uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1516         if (_i == 0) {
1517             return "0";
1518         }
1519         uint j = _i;
1520         uint len;
1521         while (j != 0) {
1522             len++;
1523             j /= 10;
1524         }
1525         bytes memory bstr = new bytes(len);
1526         uint k = len - 1;
1527         while (_i != 0) {
1528             bstr[k] = bytes1(uint8(48 + _i % 10));
1529             _i /= 10;
1530             if (k > 0) {
1531                 k--;
1532             }
1533         }
1534         return string(bstr);
1535     }
1536 
1537 }
1538 // File: contracts/abstract/IERC20.sol
1539 
1540 
1541 pragma solidity 0.8.9;
1542 
1543 /**
1544  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1545  * the optional functions; to access them see {ERC20Detailed}.
1546  */
1547 interface IERC20 {
1548 
1549     /**
1550      * @dev Returns the amount of tokens in existence.
1551      */
1552     function totalSupply() external view returns (uint256);
1553 
1554     /**
1555      * @dev Returns the amount of tokens owned by `account`.
1556      */
1557     function balanceOf(address account) external view returns (uint256);
1558 
1559     /**
1560      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1561      * 
1562      * Returns a boolean value indicating whether the operation succeeded.
1563      * 
1564      * Emits a {Transfer} event.
1565      */
1566     function transfer(address recipient, uint256 amount) external returns (bool);
1567 
1568     /**
1569      * @dev Returns the remaining number of tokens that `spender` will be
1570      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1571      * zero by default.
1572      * 
1573      * This value changes when {approve} or {transferFrom} are called.
1574      */
1575     function allowance(address owner, address spender) external view returns (uint256);
1576 
1577     /**
1578      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1579      * 
1580      * Returns a boolean value indicating whether the operation succeeded.
1581      * 
1582      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1583      * that someone may use both the old and the new allowance by unfortunate
1584      * transaction ordering. One possible solution to mitigate this race
1585      * condition is to first reduce the spender's allowance to 0 and set the
1586      * desired value afterwards:
1587      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1588      * 
1589      * Emits an {Approval} event.
1590      */
1591     function approve(address spender, uint256 amount) external returns (bool);
1592 
1593     /**
1594      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1595      * allowance mechanism. `amount` is then deducted from the caller's
1596      * allowance.
1597      * 
1598      * Returns a boolean value indicating whether the operation succeeded.
1599      * 
1600      * Emits a {Transfer} event.
1601      */
1602     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1603 
1604     /**
1605      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1606      * another (`to`).
1607      * 
1608      * Note that `value` may be zero.
1609      */
1610     event Transfer(address indexed from, address indexed to, uint256 value);
1611 
1612     /**
1613      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1614      * a call to {approve}. `value` is the new allowance.
1615      */
1616     event Approval(address indexed owner, address indexed spender, uint256 value);
1617 }
1618 
1619 
1620 
1621 // File: contracts/abstract/ERC20.sol
1622 
1623 
1624 pragma solidity 0.8.9;
1625 
1626 
1627 
1628 
1629 
1630 /**
1631  * @dev Implementation of the {IERC20} interface.
1632  *
1633  * This implementation is agnostic to the way tokens are created. This means
1634  * that a supply mechanism has to be added in a derived contract using {_mint}.
1635  * For a generic mechanism see {ERC20PresetMinterPauser}.
1636  *
1637  * TIP: For a detailed writeup see our guide
1638  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1639  * to implement supply mechanisms].
1640  *
1641  * We have followed general OpenZeppelin guidelines: functions revert instead
1642  * of returning `false` on failure. This behavior is nonetheless conventional
1643  * and does not conflict with the expectations of ERC20 applications.
1644  *
1645  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1646  * This allows applications to reconstruct the allowance for all accounts just
1647  * by listening to said events. Other implementations of the EIP may not emit
1648  * these events, as it isn't required by the specification.
1649  *
1650  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1651  * functions have been added to mitigate the well-known issues around setting
1652  * allowances. See {IERC20-approve}.
1653  */
1654 abstract contract ERC20 is Context, IERC20 {
1655 
1656     using SafeMath for uint256;
1657     using Address for address;
1658 
1659     mapping(address => uint256) private _balances;
1660 
1661     mapping(address => mapping(address => uint256)) private _allowances;
1662 
1663     uint256 private _totalSupply;
1664 
1665     string private _name;
1666     string private _symbol;
1667     uint8 private _decimals;
1668 
1669     /**
1670      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1671      * a default value of 18.
1672      *
1673      * To select a different value for {decimals}, use {_setupDecimals}.
1674      *
1675      * All three of these values are immutable: they can only be set once during
1676      * construction.
1677      */
1678     constructor(string memory tokenName, string memory tokenSymbol) {
1679         _name = tokenName;
1680         _symbol = tokenSymbol;
1681         _decimals = 18;
1682     }
1683 
1684     /**
1685      * @dev Returns the name of the token.
1686      */
1687     function name() public view returns (string memory) {
1688         return _name;
1689     }
1690 
1691     /**
1692      * @dev Returns the symbol of the token, usually a shorter version of the
1693      * name.
1694      */
1695     function symbol() public view returns (string memory) {
1696         return _symbol;
1697     }
1698 
1699     /**
1700      * @dev Returns the number of decimals used to get its user representation.
1701      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1702      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1703      *
1704      * Tokens usually opt for a value of 18, imitating the relationship between
1705      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1706      * called.
1707      *
1708      * NOTE: This information is only used for _display_ purposes: it in
1709      * no way affects any of the arithmetic of the contract, including
1710      * {IERC20-balanceOf} and {IERC20-transfer}.
1711      */
1712     function decimals() public view returns (uint8) {
1713         return _decimals;
1714     }
1715 
1716     /**
1717      * @dev See {IERC20-totalSupply}.
1718      */
1719     function totalSupply() public override view returns (uint256) {
1720         return _totalSupply;
1721     }
1722 
1723     /**
1724      * @dev See {IERC20-balanceOf}.
1725      */
1726     function balanceOf(address account) public override view returns (uint256) {
1727         return _balances[account];
1728     }
1729 
1730     /**
1731      * @dev See {IERC20-transfer}.
1732      *
1733      * Requirements:
1734      *
1735      * - `recipient` cannot be the zero address.
1736      * - the caller must have a balance of at least `amount`.
1737      */
1738     function transfer(address recipient, uint256 amount)
1739         public
1740         virtual
1741         override
1742         returns (bool)
1743     {
1744         _transfer(_msgSender(), recipient, amount);
1745         return true;
1746     }
1747 
1748     /**
1749      * @dev See {IERC20-allowance}.
1750      */
1751     function allowance(address owner, address spender)
1752         public
1753         virtual
1754         override
1755         view
1756         returns (uint256)
1757     {
1758         return _allowances[owner][spender];
1759     }
1760 
1761     /**
1762      * @dev See {IERC20-approve}.
1763      *
1764      * Requirements:
1765      *
1766      * - `spender` cannot be the zero address.
1767      */
1768     function approve(address spender, uint256 amount)
1769         public
1770         virtual
1771         override
1772         returns (bool)
1773     {
1774         _approve(_msgSender(), spender, amount);
1775         return true;
1776     }
1777 
1778     /**
1779      * @dev See {IERC20-transferFrom}.
1780      *
1781      * Emits an {Approval} event indicating the updated allowance. This is not
1782      * required by the EIP. See the note at the beginning of {ERC20};
1783      *
1784      * Requirements:
1785      * - `sender` and `recipient` cannot be the zero address.
1786      * - `sender` must have a balance of at least `amount`.
1787      * - the caller must have allowance for ``sender``'s tokens of at least
1788      * `amount`.
1789      */
1790     function transferFrom(
1791         address sender,
1792         address recipient,
1793         uint256 amount
1794     ) public virtual override returns (bool) {
1795         _transfer(sender, recipient, amount);
1796         _approve(
1797             sender,
1798             _msgSender(),
1799             _allowances[sender][_msgSender()].sub(
1800                 amount,
1801                 "ERC20: transfer amount exceeds allowance"
1802             )
1803         );
1804         return true;
1805     }
1806 
1807     /**
1808      * @dev Atomically increases the allowance granted to `spender` by the caller.
1809      *
1810      * This is an alternative to {approve} that can be used as a mitigation for
1811      * problems described in {IERC20-approve}.
1812      *
1813      * Emits an {Approval} event indicating the updated allowance.
1814      *
1815      * Requirements:
1816      *
1817      * - `spender` cannot be the zero address.
1818      */
1819     function increaseAllowance(address spender, uint256 addedValue)
1820         public
1821         virtual
1822         returns (bool)
1823     {
1824         _approve(
1825             _msgSender(),
1826             spender,
1827             _allowances[_msgSender()][spender].add(addedValue)
1828         );
1829         return true;
1830     }
1831 
1832     /**
1833      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1834      *
1835      * This is an alternative to {approve} that can be used as a mitigation for
1836      * problems described in {IERC20-approve}.
1837      *
1838      * Emits an {Approval} event indicating the updated allowance.
1839      *
1840      * Requirements:
1841      *
1842      * - `spender` cannot be the zero address.
1843      * - `spender` must have allowance for the caller of at least
1844      * `subtractedValue`.
1845      */
1846     function decreaseAllowance(address spender, uint256 subtractedValue)
1847         public
1848         virtual
1849         returns (bool)
1850     {
1851         _approve(
1852             _msgSender(),
1853             spender,
1854             _allowances[_msgSender()][spender].sub(
1855                 subtractedValue,
1856                 "ERC20: decreased allowance below zero"
1857             )
1858         );
1859         return true;
1860     }
1861 
1862     /**
1863      * @dev Moves tokens `amount` from `sender` to `recipient`.
1864      *
1865      * This is internal function is equivalent to {transfer}, and can be used to
1866      * e.g. implement automatic token fees, slashing mechanisms, etc.
1867      *
1868      * Emits a {Transfer} event.
1869      *
1870      * Requirements:
1871      *
1872      * - `sender` cannot be the zero address.
1873      * - `recipient` cannot be the zero address.
1874      * - `sender` must have a balance of at least `amount`.
1875      */
1876     function _transfer(
1877         address sender,
1878         address recipient,
1879         uint256 amount
1880     ) internal virtual {
1881         require(sender != address(0), "ERC20: transfer from the zero address");
1882         require(recipient != address(0), "ERC20: transfer to the zero address");
1883 
1884         _beforeTokenTransfer(sender, recipient, amount);
1885 
1886         _balances[sender] = _balances[sender].sub(
1887             amount,
1888             "ERC20: transfer amount exceeds balance"
1889         );
1890         _balances[recipient] = _balances[recipient].add(amount);
1891         emit Transfer(sender, recipient, amount);
1892     }
1893 
1894     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1895      * the total supply.
1896      *
1897      * Emits a {Transfer} event with `from` set to the zero address.
1898      *
1899      * Requirements
1900      *
1901      * - `to` cannot be the zero address.
1902      */
1903     function _mint(address account, uint256 amount) internal virtual {
1904         require(account != address(0), "ERC20: mint to the zero address");
1905 
1906         _beforeTokenTransfer(address(0), account, amount);
1907 
1908         _totalSupply = _totalSupply.add(amount);
1909         _balances[account] = _balances[account].add(amount);
1910         emit Transfer(address(0), account, amount);
1911     }
1912 
1913     /**
1914      * @dev Destroys `amount` tokens from `account`, reducing the
1915      * total supply.
1916      *
1917      * Emits a {Transfer} event with `to` set to the zero address.
1918      *
1919      * Requirements
1920      *
1921      * - `account` cannot be the zero address.
1922      * - `account` must have at least `amount` tokens.
1923      */
1924     function _burn(address account, uint256 amount) internal virtual {
1925         require(account != address(0), "ERC20: burn from the zero address");
1926 
1927         _beforeTokenTransfer(account, address(0), amount);
1928 
1929         _balances[account] = _balances[account].sub(
1930             amount,
1931             "ERC20: burn amount exceeds balance"
1932         );
1933         _totalSupply = _totalSupply.sub(amount);
1934         emit Transfer(account, address(0), amount);
1935     }
1936 
1937     /**
1938      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1939      *
1940      * This internal function is equivalent to `approve`, and can be used to
1941      * e.g. set automatic allowances for certain subsystems, etc.
1942      *
1943      * Emits an {Approval} event.
1944      *
1945      * Requirements:
1946      *
1947      * - `owner` cannot be the zero address.
1948      * - `spender` cannot be the zero address.
1949      */
1950     function _approve(
1951         address owner,
1952         address spender,
1953         uint256 amount
1954     ) internal virtual {
1955         require(owner != address(0), "ERC20: approve from the zero address");
1956         require(spender != address(0), "ERC20: approve to the zero address");
1957 
1958         _allowances[owner][spender] = amount;
1959         emit Approval(owner, spender, amount);
1960     }
1961 
1962     /**
1963      * @dev Sets {decimals} to a value other than the default one of 18.
1964      *
1965      * WARNING: This function should only be called from the constructor. Most
1966      * applications that interact with token contracts will not expect
1967      * {decimals} to ever change, and may work incorrectly if it does.
1968      */
1969     function _setupDecimals(uint8 decimals_) internal {
1970         _decimals = decimals_;
1971     }
1972 
1973     /**
1974      * @dev Hook that is called before any transfer of tokens. This includes
1975      * minting and burning.
1976      *
1977      * Calling conditions:
1978      *
1979      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1980      * will be to transferred to `to`.
1981      * - when `from` is zero, `amount` tokens will be minted for `to`.
1982      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1983      * - `from` and `to` are never both zero.
1984      *
1985      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1986      */
1987     function _beforeTokenTransfer(
1988         address from,
1989         address to,
1990         uint256 amount
1991     ) internal virtual {}
1992 }
1993 
1994 // File: contracts/abstract/XMeedsToken.sol
1995 
1996 
1997 pragma solidity 0.8.9;
1998 
1999 
2000 
2001 
2002 
2003 
2004 
2005 
2006 abstract contract XMeedsToken is ERC20("Staked MEED", "xMEED"), Ownable {
2007     using SafeMath for uint256;
2008     IERC20 public meed;
2009     FundDistribution public rewardDistribution;
2010 
2011     constructor(IERC20 _meed, FundDistribution _rewardDistribution) {
2012         meed = _meed;
2013         rewardDistribution = _rewardDistribution;
2014     }
2015 
2016     /**
2017      * @dev This method will:
2018      * 1/ retrieve staked amount of MEEDs that should already been approved on ERC20 MEED Token
2019      * 2/ Send back some xMEED ERC20 Token for staker
2020      */
2021     function _stake(uint256 _amount) internal {
2022         // Retrieve MEEDs from Reserve Fund (TokenFactory)
2023         require(rewardDistribution.sendReward(address(this)) == true, "Error retrieving funds from reserve");
2024 
2025         uint256 totalMeed = meed.balanceOf(address(this));
2026         uint256 totalShares = totalSupply();
2027         if (totalShares == 0 || totalMeed == 0) {
2028             _mint(_msgSender(), _amount);
2029         } else {
2030             uint256 what = _amount.mul(totalShares).div(totalMeed);
2031             _mint(_msgSender(), what);
2032         }
2033         meed.transferFrom(_msgSender(), address(this), _amount);
2034     }
2035 
2036     /**
2037      * @dev This method will:
2038      * 1/ Withdraw staked amount of MEEDs that wallet has already staked in this contract
2039      *  plus a proportion of Rewarded MEEDs sent from TokenFactory/MasterChef
2040      * 2/ Burn equivalent amount of xMEED from caller account
2041      */
2042     function _withdraw(uint256 _amount) internal {
2043         // Retrieve MEEDs from Reserve Fund (TokenFactory)
2044         require(rewardDistribution.sendReward(address(this)) == true, "Error retrieving funds from reserve");
2045 
2046         uint256 totalMeed = meed.balanceOf(address(this));
2047         uint256 totalShares = totalSupply();
2048         uint256 what = _amount.mul(totalMeed).div(totalShares);
2049         _burn(_msgSender(), _amount);
2050         meed.transfer(_msgSender(), what);
2051     }
2052 }
2053 // File: contracts/abstract/MeedsPointsRewarding.sol
2054 
2055 
2056 pragma solidity 0.8.9;
2057 
2058 
2059 
2060 contract MeedsPointsRewarding is XMeedsToken {
2061     using SafeMath for uint256;
2062 
2063     // The block time when Points rewarding will starts
2064     uint256 public startRewardsTime;
2065 
2066     mapping(address => uint256) internal points;
2067     mapping(address => uint256) internal pointsLastUpdateTime;
2068 
2069     event Staked(address indexed user, uint256 amount);
2070     event Withdrawn(address indexed user, uint256 amount);
2071 
2072     /**
2073      * @dev a modifier to store earned points for a designated address until
2074      * current block after having staked some MEEDs. if the Points rewarding didn't started yet
2075      * the address will not receive points yet.
2076      */
2077     modifier updateReward(address account) {
2078         if (account != address(0)) {
2079           if (block.timestamp < startRewardsTime) {
2080             points[account] = 0;
2081             pointsLastUpdateTime[account] = startRewardsTime;
2082           } else {
2083             points[account] = earned(account);
2084             pointsLastUpdateTime[account] = block.timestamp;
2085           }
2086         }
2087         _;
2088     }
2089 
2090     constructor (IERC20 _meed, FundDistribution _rewardDistribution, uint256 _startRewardsTime) XMeedsToken(_meed, _rewardDistribution) {
2091         startRewardsTime = _startRewardsTime;
2092     }
2093 
2094     /**
2095      * @dev returns the earned points for the designated address after having staked some MEEDs
2096      * token. If the Points rewarding distribution didn't started yet, 0 will be returned instead.
2097      */
2098     function earned(address account) public view returns (uint256) {
2099         if (block.timestamp < startRewardsTime) {
2100           return 0;
2101         } else {
2102           uint256 timeDifference = block.timestamp.sub(pointsLastUpdateTime[account]);
2103           uint256 balance = balanceOf(account);
2104           uint256 decimals = 1e18;
2105           uint256 x = balance / decimals;
2106           uint256 ratePerSecond = decimals.mul(x).div(x.add(12000)).div(240);
2107           return points[account].add(ratePerSecond.mul(timeDifference));
2108         }
2109     }
2110 
2111     /**
2112      * @dev This method will:
2113      * 1/ Update Rewarding Points for address of caller (using modifier)
2114      * 2/ retrieve staked amount of MEEDs that should already been approved on ERC20 MEED Token
2115      * 3/ Send back some xMEED ERC20 Token for staker
2116      */
2117     function stake(uint256 amount) public updateReward(msg.sender) {
2118         require(amount > 0, "Invalid amount");
2119 
2120         _stake(amount);
2121         emit Staked(msg.sender, amount);
2122     }
2123 
2124     /**
2125      * @dev This method will:
2126      * 1/ Update Rewarding Points for address of caller (using modifier)
2127      * 2/ Withdraw staked amount of MEEDs that wallet has already staked in this contract
2128      *  plus a proportion of Rewarded MEEDs sent from TokenFactory/MasterChef
2129      * 3/ Burn equivalent amount of xMEED from caller account
2130      */
2131     function withdraw(uint256 amount) public updateReward(msg.sender) {
2132         require(amount > 0, "Cannot withdraw 0");
2133 
2134         _withdraw(amount);
2135         emit Withdrawn(msg.sender, amount);
2136     }
2137 
2138     /**
2139      * @dev This method will:
2140      * 1/ Update Rewarding Points for address of caller (using modifier)
2141      * 2/ Withdraw all staked MEEDs that are wallet has staked in this contract
2142      *  plus a proportion of Rewarded MEEDs sent from TokenFactory/MasterChef
2143      * 3/ Burn equivalent amount of xMEED from caller account
2144      */
2145     function exit() external {
2146         withdraw(balanceOf(msg.sender));
2147     }
2148 
2149     /**
2150      * @dev ERC-20 transfer method in addition to updating earned points
2151      * of spender and recipient (using modifiers)
2152      */
2153     function transfer(address recipient, uint256 amount)
2154         public
2155         virtual
2156         override
2157         updateReward(msg.sender)
2158         updateReward(recipient)
2159         returns (bool) {
2160         return super.transfer(recipient, amount);
2161     }
2162 
2163     /**
2164      * @dev ERC-20 transferFrom method in addition to updating earned points
2165      * of spender and recipient (using modifiers)
2166      */
2167     function transferFrom(address sender, address recipient, uint256 amount)
2168         public
2169         virtual
2170         override
2171         updateReward(sender)
2172         updateReward(recipient)
2173         returns (bool) {
2174         return super.transferFrom(sender, recipient, amount);
2175     }
2176 
2177 }
2178 
2179 
2180 
2181 // File: contracts/XMeedsNFTRewarding.sol
2182 
2183 
2184 pragma solidity 0.8.9;
2185 
2186 
2187 
2188 
2189 contract XMeedsNFTRewarding is MeedsPointsRewarding {
2190     using SafeMath for uint256;
2191 
2192     // Info of each Card Type
2193     struct CardTypeDetail {
2194         string name;
2195         uint8 cityIndex;
2196         uint8 cardType;
2197         uint32 supply;
2198         uint32 maxSupply;
2199         uint256 amount;
2200     }
2201 
2202     // Info of each City
2203     struct CityDetail {
2204         string name;
2205         uint32 population;
2206         uint32 maxPopulation;
2207         uint256 availability;
2208     }
2209 
2210     ERC1155Tradable public nft;
2211 
2212     CardTypeDetail[] public cardTypeInfo;
2213     CityDetail[] public cityInfo;
2214     uint8 public currentCityIndex = 0;
2215     uint256 public lastCityMintingCompleteDate = 0;
2216 
2217     event Redeemed(address indexed user, string city, string cardType, uint256 id);
2218     event NFTSet(ERC1155Tradable indexed newNFT);
2219 
2220     constructor (
2221         IERC20 _meed,
2222         FundDistribution _rewardDistribution,
2223         ERC1155Tradable _nftAddress,
2224         uint256 _startRewardsTime,
2225         string[] memory _cityNames,
2226         string[] memory _cardNames,
2227         uint256[] memory _cardPrices,
2228         uint32[] memory _cardSupply
2229     ) MeedsPointsRewarding(_meed, _rewardDistribution, _startRewardsTime) {
2230         nft = _nftAddress;
2231         lastCityMintingCompleteDate = block.timestamp;
2232 
2233         uint256 citiesLength = _cityNames.length;
2234         uint256 cardsLength = _cardNames.length;
2235         uint32 citiesCardsLength = uint32(citiesLength * cardsLength);
2236         require(uint32(_cardSupply.length) == citiesCardsLength, "Provided Supply list per card per city must equal to Card Type length");
2237 
2238         uint256 _month = 30 days;
2239         uint256 _index = 0;
2240         for (uint8 i = 0; i < citiesLength; i++) {
2241             uint32 _maxPopulation = 0;
2242             for (uint8 j = 0; j < cardsLength; j++) {
2243                 string memory _cardName = _cardNames[j];
2244                 uint256 _cardPrice = _cardPrices[j];
2245                 uint32 _maxSupply = _cardSupply[_index];
2246                 cardTypeInfo.push(CardTypeDetail({
2247                     name: _cardName,
2248                     cityIndex: i,
2249                     cardType: j,
2250                     amount: _cardPrice,
2251                     supply: 0,
2252                     maxSupply: _maxSupply
2253                 }));
2254                 _maxPopulation += _maxSupply;
2255                 _index++;
2256             }
2257 
2258             uint256 _availability = i > 0 ? ((2 ** (i + 1)) * _month) : 0;
2259             string memory _cityName = _cityNames[i];
2260             cityInfo.push(CityDetail({
2261                 name: _cityName,
2262                 population: 0,
2263                 maxPopulation: _maxPopulation,
2264                 availability: _availability
2265             }));
2266         }
2267     }
2268 
2269     /**
2270      * @dev Set MEED NFT address
2271      */
2272     function setNFT(ERC1155Tradable _nftAddress) public onlyOwner {
2273         nft = _nftAddress;
2274         emit NFTSet(_nftAddress);
2275     }
2276 
2277     /**
2278      * @dev Checks if current city is mintable
2279      */
2280     function isCurrentCityMintable() public view returns (bool) {
2281         return block.timestamp > cityMintingStartDate();
2282     }
2283 
2284     /**
2285      * @dev returns current city minting start date
2286      */
2287     function cityMintingStartDate() public view returns (uint256) {
2288         CityDetail memory city = cityInfo[currentCityIndex];
2289         return city.availability.add(lastCityMintingCompleteDate);
2290     }
2291 
2292     /**
2293      * @dev Redeem an NFT by minting it and substracting the amount af Points (Card Type price)
2294      * from caller balance of points.
2295      */
2296     function redeem(uint8 cardTypeId) public updateReward(msg.sender) returns (uint256 tokenId) {
2297         require(cardTypeId < cardTypeInfo.length, "Card Type doesn't exist");
2298 
2299         CardTypeDetail storage cardType = cardTypeInfo[cardTypeId];
2300         require(cardType.maxSupply > 0, "Card Type not available for minting");
2301         require(points[msg.sender] >= cardType.amount, "Not enough points to redeem for card");
2302         require(cardType.supply < cardType.maxSupply, "Max cards supply reached");
2303         require(cardType.cityIndex == currentCityIndex, "Designated city isn't available for minting yet");
2304 
2305         CityDetail storage city = cityInfo[cardType.cityIndex];
2306         require(block.timestamp > city.availability.add(lastCityMintingCompleteDate), "Designated city isn't available for minting yet");
2307 
2308         city.population = city.population + 1;
2309         cardType.supply = cardType.supply + 1;
2310         if (city.population >= city.maxPopulation) {
2311             currentCityIndex++;
2312             lastCityMintingCompleteDate = block.timestamp;
2313         }
2314 
2315         points[msg.sender] = points[msg.sender].sub(cardType.amount);
2316         uint256 _tokenId = nft.create(msg.sender, 1, 1, cardType.cityIndex, cardType.cardType, "");
2317         emit Redeemed(msg.sender, city.name, cardType.name, _tokenId);
2318         return _tokenId;
2319     }
2320 
2321 }