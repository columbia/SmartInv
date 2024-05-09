1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
55 
56 
57 
58 pragma solidity ^0.8.0;
59 
60 
61 /**
62  * @dev Implementation of the {IERC165} interface.
63  *
64  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
65  * for the additional interface id that will be supported. For example:
66  *
67  * ```solidity
68  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
69  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
70  * }
71  * ```
72  *
73  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
74  */
75 abstract contract ERC165 is IERC165 {
76     /**
77      * @dev See {IERC165-supportsInterface}.
78      */
79     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
80         return interfaceId == type(IERC165).interfaceId;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/introspection/ERC165Storage.sol
85 
86 
87 
88 pragma solidity ^0.8.0;
89 
90 
91 /**
92  * @dev Storage based implementation of the {IERC165} interface.
93  *
94  * Contracts may inherit from this and call {_registerInterface} to declare
95  * their support of an interface.
96  */
97 abstract contract ERC165Storage is ERC165 {
98     /**
99      * @dev Mapping of interface ids to whether or not it's supported.
100      */
101     mapping(bytes4 => bool) private _supportedInterfaces;
102 
103     /**
104      * @dev See {IERC165-supportsInterface}.
105      */
106     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
107         return super.supportsInterface(interfaceId) || _supportedInterfaces[interfaceId];
108     }
109 
110     /**
111      * @dev Registers the contract as an implementer of the interface defined by
112      * `interfaceId`. Support of the actual ERC165 interface is automatic and
113      * registering its interface id is not required.
114      *
115      * See {IERC165-supportsInterface}.
116      *
117      * Requirements:
118      *
119      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
120      */
121     function _registerInterface(bytes4 interfaceId) internal virtual {
122         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
123         _supportedInterfaces[interfaceId] = true;
124     }
125 }
126 
127 // File: @openzeppelin/contracts/proxy/Clones.sol
128 
129 
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
135  * deploying minimal proxy contracts, also known as "clones".
136  *
137  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
138  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
139  *
140  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
141  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
142  * deterministic method.
143  *
144  * _Available since v3.4._
145  */
146 library Clones {
147     /**
148      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
149      *
150      * This function uses the create opcode, which should never revert.
151      */
152     function clone(address implementation) internal returns (address instance) {
153         assembly {
154             let ptr := mload(0x40)
155             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
156             mstore(add(ptr, 0x14), shl(0x60, implementation))
157             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
158             instance := create(0, ptr, 0x37)
159         }
160         require(instance != address(0), "ERC1167: create failed");
161     }
162 
163     /**
164      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
165      *
166      * This function uses the create2 opcode and a `salt` to deterministically deploy
167      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
168      * the clones cannot be deployed twice at the same address.
169      */
170     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
171         assembly {
172             let ptr := mload(0x40)
173             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
174             mstore(add(ptr, 0x14), shl(0x60, implementation))
175             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
176             instance := create2(0, ptr, 0x37, salt)
177         }
178         require(instance != address(0), "ERC1167: create2 failed");
179     }
180 
181     /**
182      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
183      */
184     function predictDeterministicAddress(
185         address implementation,
186         bytes32 salt,
187         address deployer
188     ) internal pure returns (address predicted) {
189         assembly {
190             let ptr := mload(0x40)
191             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
192             mstore(add(ptr, 0x14), shl(0x60, implementation))
193             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
194             mstore(add(ptr, 0x38), shl(0x60, deployer))
195             mstore(add(ptr, 0x4c), salt)
196             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
197             predicted := keccak256(add(ptr, 0x37), 0x55)
198         }
199     }
200 
201     /**
202      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
203      */
204     function predictDeterministicAddress(address implementation, bytes32 salt)
205         internal
206         view
207         returns (address predicted)
208     {
209         return predictDeterministicAddress(implementation, salt, address(this));
210     }
211 }
212 
213 // File: @openzeppelin/contracts/utils/Address.sol
214 
215 
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Collection of functions related to the address type
221  */
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize, which returns 0 for contracts in
242         // construction, since the code is only stored at the end of the
243         // constructor execution.
244 
245         uint256 size;
246         assembly {
247             size := extcodesize(account)
248         }
249         return size > 0;
250     }
251 
252     /**
253      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
254      * `recipient`, forwarding all available gas and reverting on errors.
255      *
256      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
257      * of certain opcodes, possibly making contracts go over the 2300 gas limit
258      * imposed by `transfer`, making them unable to receive funds via
259      * `transfer`. {sendValue} removes this limitation.
260      *
261      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
262      *
263      * IMPORTANT: because control is transferred to `recipient`, care must be
264      * taken to not create reentrancy vulnerabilities. Consider using
265      * {ReentrancyGuard} or the
266      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
267      */
268     function sendValue(address payable recipient, uint256 amount) internal {
269         require(address(this).balance >= amount, "Address: insufficient balance");
270 
271         (bool success, ) = recipient.call{value: amount}("");
272         require(success, "Address: unable to send value, recipient may have reverted");
273     }
274 
275     /**
276      * @dev Performs a Solidity function call using a low level `call`. A
277      * plain `call` is an unsafe replacement for a function call: use this
278      * function instead.
279      *
280      * If `target` reverts with a revert reason, it is bubbled up by this
281      * function (like regular Solidity function calls).
282      *
283      * Returns the raw returned data. To convert to the expected return value,
284      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
285      *
286      * Requirements:
287      *
288      * - `target` must be a contract.
289      * - calling `target` with `data` must not revert.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionCall(target, data, "Address: low-level call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
299      * `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(address(this).balance >= value, "Address: insufficient balance for call");
343         require(isContract(target), "Address: call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.call{value: value}(data);
346         return _verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
356         return functionStaticCall(target, data, "Address: low-level static call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return _verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(isContract(target), "Address: delegate call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.delegatecall(data);
400         return _verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     function _verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) private pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/security/Pausable.sol
427 
428 
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Contract module which allows children to implement an emergency stop
435  * mechanism that can be triggered by an authorized account.
436  *
437  * This module is used through inheritance. It will make available the
438  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
439  * the functions of your contract. Note that they will not be pausable by
440  * simply including this module, only once the modifiers are put in place.
441  */
442 abstract contract Pausable is Context {
443     /**
444      * @dev Emitted when the pause is triggered by `account`.
445      */
446     event Paused(address account);
447 
448     /**
449      * @dev Emitted when the pause is lifted by `account`.
450      */
451     event Unpaused(address account);
452 
453     bool private _paused;
454 
455     /**
456      * @dev Initializes the contract in unpaused state.
457      */
458     constructor() {
459         _paused = false;
460     }
461 
462     /**
463      * @dev Returns true if the contract is paused, and false otherwise.
464      */
465     function paused() public view virtual returns (bool) {
466         return _paused;
467     }
468 
469     /**
470      * @dev Modifier to make a function callable only when the contract is not paused.
471      *
472      * Requirements:
473      *
474      * - The contract must not be paused.
475      */
476     modifier whenNotPaused() {
477         require(!paused(), "Pausable: paused");
478         _;
479     }
480 
481     /**
482      * @dev Modifier to make a function callable only when the contract is paused.
483      *
484      * Requirements:
485      *
486      * - The contract must be paused.
487      */
488     modifier whenPaused() {
489         require(paused(), "Pausable: not paused");
490         _;
491     }
492 
493     /**
494      * @dev Triggers stopped state.
495      *
496      * Requirements:
497      *
498      * - The contract must not be paused.
499      */
500     function _pause() internal virtual whenNotPaused {
501         _paused = true;
502         emit Paused(_msgSender());
503     }
504 
505     /**
506      * @dev Returns to normal state.
507      *
508      * Requirements:
509      *
510      * - The contract must be paused.
511      */
512     function _unpause() internal virtual whenPaused {
513         _paused = false;
514         emit Unpaused(_msgSender());
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
519 
520 
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Required interface of an ERC721 compliant contract.
527  */
528 interface IERC721 is IERC165 {
529     /**
530      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
531      */
532     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
536      */
537     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in ``owner``'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Transfers `tokenId` token from `from` to `to`.
580      *
581      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must be owned by `from`.
588      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
589      *
590      * Emits a {Transfer} event.
591      */
592     function transferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
600      * The approval is cleared when the token is transferred.
601      *
602      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
603      *
604      * Requirements:
605      *
606      * - The caller must own the token or be an approved operator.
607      * - `tokenId` must exist.
608      *
609      * Emits an {Approval} event.
610      */
611     function approve(address to, uint256 tokenId) external;
612 
613     /**
614      * @dev Returns the account approved for `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function getApproved(uint256 tokenId) external view returns (address operator);
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
625      *
626      * Requirements:
627      *
628      * - The `operator` cannot be the caller.
629      *
630      * Emits an {ApprovalForAll} event.
631      */
632     function setApprovalForAll(address operator, bool _approved) external;
633 
634     /**
635      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
636      *
637      * See {setApprovalForAll}
638      */
639     function isApprovedForAll(address owner, address operator) external view returns (bool);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes calldata data
659     ) external;
660 }
661 
662 // File: contracts/core/IERC2309.sol
663 
664 
665 
666 pragma solidity 0.8.4;
667 
668 /**
669   @title ERC-2309: ERC-721 Batch Mint Extension
670   @dev https://github.com/ethereum/EIPs/issues/2309
671  */
672 interface IERC2309 {
673     /**
674       @notice This event is emitted when ownership of a batch of tokens changes by any mechanism.
675       This includes minting, transferring, and burning.
676 
677       @dev The address executing the transaction MUST own all the tokens within the range of
678       fromTokenId and toTokenId, or MUST be an approved operator to act on the owners behalf.
679       The fromTokenId and toTokenId MUST be a sequential range of tokens IDs.
680       When minting/creating tokens, the `fromAddress` argument MUST be set to `0x0` (i.e. zero address).
681       When burning/destroying tokens, the `toAddress` argument MUST be set to `0x0` (i.e. zero address).
682 
683       @param fromTokenId The token ID that begins the batch of tokens being transferred
684       @param toTokenId The token ID that ends the batch of tokens being transferred
685       @param fromAddress The address transferring ownership of the specified range of tokens
686       @param toAddress The address receiving ownership of the specified range of tokens.
687     */
688     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
689 }
690 
691 // File: contracts/core/IERC2981.sol
692 
693 
694 
695 pragma solidity 0.8.4;
696 
697 
698 /// @notice This is purely an extension for the KO platform
699 /// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
700 interface IERC2981EditionExtension {
701 
702     /// @notice Does the edition have any royalties defined
703     function hasRoyalties(uint256 _editionId) external view returns (bool);
704 
705     /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
706     function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
707 }
708 
709 /**
710  * ERC2981 standards interface for royalties
711  */
712 interface IERC2981 is IERC165, IERC2981EditionExtension {
713     /// ERC165 bytes to add to interface array - set in parent contract
714     /// implementing this standard
715     ///
716     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
717     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
718     /// _registerInterface(_INTERFACE_ID_ERC2981);
719 
720     /// @notice Called with the sale price to determine how much royalty
721     //          is owed and to whom.
722     /// @param _tokenId - the NFT asset queried for royalty information
723     /// @param _value - the sale price of the NFT asset specified by _tokenId
724     /// @return _receiver - address of who should be sent the royalty payment
725     /// @return _royaltyAmount - the royalty payment amount for _value sale price
726     function royaltyInfo(
727         uint256 _tokenId,
728         uint256 _value
729     ) external view returns (
730         address _receiver,
731         uint256 _royaltyAmount
732     );
733 
734 }
735 
736 // File: contracts/core/IHasSecondarySaleFees.sol
737 
738 
739 
740 pragma solidity 0.8.4;
741 
742 
743 /// @title Royalties formats required for use on the Rarible platform
744 /// @dev https://docs.rarible.com/asset/royalties-schema
745 interface IHasSecondarySaleFees is IERC165 {
746 
747     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
748 
749     function getFeeRecipients(uint256 id) external returns (address payable[] memory);
750 
751     function getFeeBps(uint256 id) external returns (uint[] memory);
752 }
753 
754 // File: contracts/core/IKODAV3.sol
755 
756 
757 
758 pragma solidity 0.8.4;
759 
760 
761 
762 
763 
764 
765 /// @title Core KODA V3 functionality
766 interface IKODAV3 is
767 IERC165, // Contract introspection
768 IERC721, // Core NFTs
769 IERC2309, // Consecutive batch mint
770 IERC2981, // Royalties
771 IHasSecondarySaleFees // Rariable / Foundation royalties
772 {
773     // edition utils
774 
775     function getCreatorOfEdition(uint256 _editionId) external view returns (address _originalCreator);
776 
777     function getCreatorOfToken(uint256 _tokenId) external view returns (address _originalCreator);
778 
779     function getSizeOfEdition(uint256 _editionId) external view returns (uint256 _size);
780 
781     function getEditionSizeOfToken(uint256 _tokenId) external view returns (uint256 _size);
782 
783     function editionExists(uint256 _editionId) external view returns (bool);
784 
785     // Has the edition been disabled / soft burnt
786     function isEditionSalesDisabled(uint256 _editionId) external view returns (bool);
787 
788     // Has the edition been disabled / soft burnt OR sold out
789     function isSalesDisabledOrSoldOut(uint256 _editionId) external view returns (bool);
790 
791     // Work out the max token ID for an edition ID
792     function maxTokenIdOfEdition(uint256 _editionId) external view returns (uint256 _tokenId);
793 
794     // Helper method for getting the next primary sale token from an edition starting low to high token IDs
795     function getNextAvailablePrimarySaleToken(uint256 _editionId) external returns (uint256 _tokenId);
796 
797     // Helper method for getting the next primary sale token from an edition starting high to low token IDs
798     function getReverseAvailablePrimarySaleToken(uint256 _editionId) external view returns (uint256 _tokenId);
799 
800     // Utility method to get all data needed for the next primary sale, low token ID to high
801     function facilitateNextPrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
802 
803     // Utility method to get all data needed for the next primary sale, high token ID to low
804     function facilitateReversePrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
805 
806     // Expanded royalty method for the edition, not token
807     function royaltyAndCreatorInfo(uint256 _editionId, uint256 _value) external returns (address _receiver, address _creator, uint256 _amount);
808 
809     // Allows the creator to correct mistakes until the first token from an edition is sold
810     function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI) external;
811 
812     // Has any primary transfer happened from an edition
813     function hasMadePrimarySale(uint256 _editionId) external view returns (bool);
814 
815     // Has the edition sold out
816     function isEditionSoldOut(uint256 _editionId) external view returns (bool);
817 
818     // Toggle on/off the edition from being able to make sales
819     function toggleEditionSalesDisabled(uint256 _editionId) external;
820 
821     // token utils
822 
823     function exists(uint256 _tokenId) external view returns (bool);
824 
825     function getEditionIdOfToken(uint256 _tokenId) external pure returns (uint256 _editionId);
826 
827     function getEditionDetails(uint256 _tokenId) external view returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri);
828 
829     function hadPrimarySaleOfToken(uint256 _tokenId) external view returns (bool);
830 
831 }
832 
833 // File: contracts/core/Konstants.sol
834 
835 
836 
837 pragma solidity 0.8.4;
838 
839 contract Konstants {
840 
841     // Every edition always goes up in batches of 1000
842     uint16 public constant MAX_EDITION_SIZE = 1000;
843 
844     // magic method that defines the maximum range for an edition - this is fixed forever - tokens are minted in range
845     function _editionFromTokenId(uint256 _tokenId) internal pure returns (uint256) {
846         return (_tokenId / MAX_EDITION_SIZE) * MAX_EDITION_SIZE;
847     }
848 }
849 
850 // File: contracts/access/IKOAccessControlsLookup.sol
851 
852 
853 
854 pragma solidity 0.8.4;
855 
856 interface IKOAccessControlsLookup {
857     function hasAdminRole(address _address) external view returns (bool);
858 
859     function isVerifiedArtist(uint256 _index, address _account, bytes32[] calldata _merkleProof) external view returns (bool);
860 
861     function isVerifiedArtistProxy(address _artist, address _proxy) external view returns (bool);
862 
863     function hasLegacyMinterRole(address _address) external view returns (bool);
864 
865     function hasContractRole(address _address) external view returns (bool);
866 
867     function hasContractOrAdminRole(address _address) external view returns (bool);
868 }
869 
870 // File: contracts/collab/ICollabRoyaltiesRegistry.sol
871 
872 
873 pragma solidity 0.8.4;
874 
875 /// @notice Common interface to the edition royalties registry
876 interface ICollabRoyaltiesRegistry {
877 
878     /// @notice Creates & deploys a new royalties recipient, cloning _handle and setting it up with the provided _recipients and _splits
879     function createRoyaltiesRecipient(
880         address _handler,
881         address[] calldata _recipients,
882         uint256[] calldata _splits
883     ) external returns (address deployedHandler);
884 
885     /// @notice Sets up the provided edition to use the provided _recipient
886     function useRoyaltiesRecipient(uint256 _editionId, address _deployedHandler) external;
887 
888     /// @notice Setup a royalties handler but does not deploy it, uses predicable clone and sets this against the edition
889     function usePredeterminedRoyaltiesRecipient(
890         uint256 _editionId,
891         address _handler,
892         address[] calldata _recipients,
893         uint256[] calldata _splits
894     ) external;
895 
896     /// @notice Deploy and setup a royalties recipient for the given edition
897     function createAndUseRoyaltiesRecipient(
898         uint256 _editionId,
899         address _handler,
900         address[] calldata _recipients,
901         uint256[] calldata _splits
902     )
903     external returns (address deployedHandler);
904 
905     /// @notice Predict the deployed clone address with the given parameters
906     function predictedRoyaltiesHandler(
907         address _handler,
908         address[] calldata _recipients,
909         uint256[] calldata _splits
910     ) external view returns (address predictedHandler);
911 
912 }
913 
914 // File: contracts/collab/handlers/ICollabFundsHandler.sol
915 
916 
917 
918 pragma solidity 0.8.4;
919 
920 interface ICollabFundsHandler {
921 
922     function init(address[] calldata _recipients, uint256[] calldata _splits) external;
923 
924     function totalRecipients() external view returns (uint256);
925 
926     function shareAtIndex(uint256 index) external view returns (address _recipient, uint256 _split);
927 }
928 
929 // File: contracts/collab/CollabRoyaltiesRegistry.sol
930 
931 
932 pragma solidity 0.8.4;
933 
934 
935 
936 
937 
938 
939 
940 
941 
942 
943 
944 
945 contract CollabRoyaltiesRegistry is Pausable, Konstants, ERC165Storage, IERC2981, ICollabRoyaltiesRegistry {
946 
947     // Admin Events
948     event KODASet(address koda);
949     event AccessControlsSet(address accessControls);
950     event RoyaltyAmountSet(uint256 royaltyAmount);
951     event EmergencyClearRoyalty(uint256 editionId);
952     event HandlerAdded(address handler);
953     event HandlerRemoved(address handler);
954 
955     // Normal Events
956     event RoyaltyRecipientCreated(address creator, address handler, address deployedHandler, address[] recipients, uint256[] splits);
957     event RoyaltiesHandlerSetup(uint256 editionId, address deployedHandler);
958     event FutureRoyaltiesHandlerSetup(uint256 editionId, address deployedHandler);
959 
960     IKODAV3 public koda;
961 
962     IKOAccessControlsLookup public accessControls;
963 
964     // @notice A controlled list of proxies which can be used byt eh KO protocol
965     mapping(address => bool) public isHandlerWhitelisted;
966 
967     // @notice A list of initialised/deployed royalties recipients
968     mapping(address => bool) public deployedRoyaltiesHandlers;
969 
970     /// @notice Funds handler to edition ID mapping - once set all funds are sent here on every sale, including EIP-2981 invocations
971     mapping(uint256 => address) public editionRoyaltiesHandlers;
972 
973     /// @notice KO secondary sale royalty amount
974     uint256 public royaltyAmount = 12_50000; // 12.5% as represented in eip-2981
975 
976     /// @notice precision 100.00000%
977     uint256 public modulo = 100_00000;
978 
979     modifier onlyContractOrCreator(uint256 _editionId) {
980         require(
981             koda.getCreatorOfEdition(_editionId) == _msgSender() || accessControls.hasContractRole(_msgSender()),
982             "Caller not creator or contract"
983         );
984         _;
985     }
986 
987     modifier onlyContractOrAdmin() {
988         require(
989             accessControls.hasAdminRole(_msgSender()) || accessControls.hasContractRole(_msgSender()),
990             "Caller not admin or contract"
991         );
992         _;
993     }
994 
995     modifier onlyAdmin() {
996         require(accessControls.hasAdminRole(_msgSender()), "Caller not admin");
997         _;
998     }
999 
1000     constructor(IKOAccessControlsLookup _accessControls) {
1001         accessControls = _accessControls;
1002 
1003         // _INTERFACE_ID_ERC2981
1004         _registerInterface(0x2a55205a);
1005     }
1006 
1007     /// @notice Set the IKODAV3 dependency - can't be passed to constructor due to circular dependency
1008     function setKoda(IKODAV3 _koda)
1009     external
1010     onlyAdmin {
1011         koda = _koda;
1012         emit KODASet(address(koda));
1013     }
1014 
1015     /// @notice Set the IKOAccessControlsLookup dependency.
1016     function setAccessControls(IKOAccessControlsLookup _accessControls)
1017     external
1018     onlyAdmin {
1019         accessControls = _accessControls;
1020         emit AccessControlsSet(address(accessControls));
1021     }
1022 
1023     /// @notice Admin setter for changing the default royalty amount
1024     function setRoyaltyAmount(uint256 _amount)
1025     external
1026     onlyAdmin() {
1027         require(_amount > 1, "Amount to low");
1028         royaltyAmount = _amount;
1029         emit RoyaltyAmountSet(royaltyAmount);
1030     }
1031 
1032     /// @notice Add a new cloneable funds handler
1033     function addHandler(address _handler)
1034     external
1035     onlyAdmin() {
1036 
1037         // Revert if handler already whitelisted
1038         require(isHandlerWhitelisted[_handler] == false, "Handler already registered");
1039 
1040         // whitelist handler
1041         isHandlerWhitelisted[_handler] = true;
1042 
1043         // Emit event
1044         emit HandlerAdded(_handler);
1045     }
1046 
1047     /// @notice Remove a cloneable funds handler
1048     function removeHandler(address _handler)
1049     external
1050     onlyAdmin() {
1051         // remove handler from whitelist
1052         isHandlerWhitelisted[_handler] = false;
1053 
1054         // Emit event
1055         emit HandlerRemoved(_handler);
1056     }
1057 
1058     ////////////////////////////
1059     /// Royalties setup logic //
1060     ////////////////////////////
1061 
1062     /// @notice Sets up a royalties funds handler
1063     /// @dev Can only be called once with the same args as this creates a new contract and we dont want to
1064     ///      override any currently deployed instance
1065     /// @dev Can only be called by an approved artist
1066     function createRoyaltiesRecipient(
1067         address _handler,
1068         address[] calldata _recipients,
1069         uint256[] calldata _splits
1070     )
1071     external
1072     override
1073     whenNotPaused
1074     returns (address deployedHandler) {
1075         validateHandlerArgs(_handler, _recipients, _splits);
1076 
1077         // Clone funds handler as Minimal deployedHandler with a deterministic address
1078         deployedHandler = deployCloneableHandler(_handler, _recipients, _splits);
1079 
1080         // Emit event
1081         emit RoyaltyRecipientCreated(_msgSender(), _handler, deployedHandler, _recipients, _splits);
1082     }
1083 
1084     /// @notice Allows a deployed handler to be set against an edition
1085     /// @dev Can be called by edition creator or another approved contract
1086     /// @dev Can only be called once per edition
1087     /// @dev Provided handler account must already be deployed
1088     function useRoyaltiesRecipient(uint256 _editionId, address _deployedHandler)
1089     external
1090     override
1091     whenNotPaused
1092     onlyContractOrCreator(_editionId) {
1093         // Ensure not already defined i.e. dont overwrite deployed contact
1094         require(editionRoyaltiesHandlers[_editionId] == address(0), "Funds handler already registered");
1095 
1096         // Ensure there actually was a registration
1097         require(deployedRoyaltiesHandlers[_deployedHandler], "No deployed handler found");
1098 
1099         // Register the deployed handler for the edition ID
1100         editionRoyaltiesHandlers[_editionId] = _deployedHandler;
1101 
1102         // Emit event
1103         emit RoyaltiesHandlerSetup(_editionId, _deployedHandler);
1104     }
1105 
1106     /// @notice Allows an admin set a predetermined royalties recipient against an edition
1107     /// @dev assumes the called has provided the correct args and a valid edition
1108     function usePredeterminedRoyaltiesRecipient(
1109         uint256 _editionId,
1110         address _handler,
1111         address[] calldata _recipients,
1112         uint256[] calldata _splits
1113     )
1114     external
1115     override
1116     whenNotPaused
1117     onlyContractOrAdmin {
1118         // Ensure not already defined i.e. dont overwrite deployed contact
1119         require(editionRoyaltiesHandlers[_editionId] == address(0), "Funds handler already registered");
1120 
1121         // Determine salt
1122         bytes32 salt = keccak256(abi.encode(_recipients, _splits));
1123         address futureDeployedHandler = Clones.predictDeterministicAddress(_handler, salt);
1124 
1125         // Register the same proxy for the new edition id
1126         editionRoyaltiesHandlers[_editionId] = futureDeployedHandler;
1127 
1128         // Emit event
1129         emit FutureRoyaltiesHandlerSetup(_editionId, futureDeployedHandler);
1130     }
1131 
1132     function createAndUseRoyaltiesRecipient(
1133         uint256 _editionId,
1134         address _handler,
1135         address[] calldata _recipients,
1136         uint256[] calldata _splits
1137     )
1138     external
1139     override
1140     whenNotPaused
1141     onlyContractOrAdmin
1142     returns (address deployedHandler) {
1143         validateHandlerArgs(_handler, _recipients, _splits);
1144 
1145         // Confirm the handler has not already been created
1146         address expectedAddress = Clones.predictDeterministicAddress(_handler, keccak256(abi.encode(_recipients, _splits)));
1147         require(!deployedRoyaltiesHandlers[expectedAddress], "Already deployed the royalties handler");
1148 
1149         // Clone funds handler as Minimal deployedHandler with a deterministic address
1150         deployedHandler = deployCloneableHandler(_handler, _recipients, _splits);
1151 
1152         // Emit event
1153         emit RoyaltyRecipientCreated(_msgSender(), _handler, deployedHandler, _recipients, _splits);
1154 
1155         // Register the deployed handler for the edition ID
1156         editionRoyaltiesHandlers[_editionId] = deployedHandler;
1157 
1158         // Emit event
1159         emit RoyaltiesHandlerSetup(_editionId, deployedHandler);
1160     }
1161 
1162     function deployCloneableHandler(address _handler, address[] calldata _recipients, uint256[] calldata _splits)
1163     internal
1164     returns (address deployedHandler) {
1165         // Confirm the handler has not already been created
1166         address expectedAddress = Clones.predictDeterministicAddress(_handler, keccak256(abi.encode(_recipients, _splits)));
1167         require(!deployedRoyaltiesHandlers[expectedAddress], "Already deployed the royalties handler");
1168 
1169         // Clone funds handler as Minimal deployedHandler with a deterministic address
1170         deployedHandler = Clones.cloneDeterministic(
1171             _handler,
1172             keccak256(abi.encode(_recipients, _splits))
1173         );
1174 
1175         // Initialize handler
1176         ICollabFundsHandler(deployedHandler).init(_recipients, _splits);
1177 
1178         // Verify that it was initialized properly
1179         require(
1180             ICollabFundsHandler(deployedHandler).totalRecipients() == _recipients.length,
1181             "Funds handler created incorrectly"
1182         );
1183 
1184         // Record the deployed handler
1185         deployedRoyaltiesHandlers[deployedHandler] = true;
1186     }
1187 
1188     function validateHandlerArgs(address _handler, address[] calldata _recipients, uint256[] calldata _splits)
1189     internal view {
1190         // Require more than 1 recipient
1191         require(_recipients.length > 1, "Collab must have more than one funds recipient");
1192 
1193         // Recipient and splits array lengths must match
1194         require(_recipients.length == _splits.length, "Recipients and splits lengths must match");
1195 
1196         // Ensure the handler is know and approved
1197         require(isHandlerWhitelisted[_handler], "Handler is not whitelisted");
1198     }
1199 
1200     /// @notice Allows for the royalty creator to predetermine the recipient address for the funds to be sent to
1201     /// @dev It does not deploy it, only allows to predetermine the address
1202     function predictedRoyaltiesHandler(address _handler, address[] calldata _recipients, uint256[] calldata _splits)
1203     public
1204     override
1205     view
1206     returns (address) {
1207         bytes32 salt = keccak256(abi.encode(_recipients, _splits));
1208         return Clones.predictDeterministicAddress(_handler, salt);
1209     }
1210 
1211     /// @notice ability to clear royalty in an emergency situation - this would then default all royalties to the original creator
1212     /// @dev Only callable from admin
1213     function emergencyResetRoyaltiesHandler(uint256 _editionId) public onlyAdmin {
1214         editionRoyaltiesHandlers[_editionId] = address(0);
1215         emit EmergencyClearRoyalty(_editionId);
1216     }
1217 
1218     ////////////////////
1219     /// Query Methods //
1220     ////////////////////
1221 
1222     /// @notice Is the given token part of an edition that has a collab royalties contract setup?
1223     function hasRoyalties(uint256 _tokenId)
1224     external
1225     override
1226     view returns (bool) {
1227 
1228         // Get the associated edition id for the given token id
1229         uint256 editionId = _editionFromTokenId(_tokenId);
1230 
1231         // Get the proxy registered to the previous edition id
1232         address proxy = editionRoyaltiesHandlers[editionId];
1233 
1234         // Ensure there actually was a registration
1235         return proxy != address(0);
1236     }
1237 
1238     /// @notice Get the proxy for a given edition's funds handler
1239     function getRoyaltiesReceiver(uint256 _editionId)
1240     external
1241     override
1242     view returns (address _receiver) {
1243         _receiver = editionRoyaltiesHandlers[_editionId];
1244         require(_receiver != address(0), "Edition not setup");
1245     }
1246 
1247     /// @notice Gets the funds handler proxy address and royalty amount for given edition id
1248     function royaltyInfo(uint256 _editionId, uint256 _value)
1249     external
1250     override
1251     view returns (address _receiver, uint256 _royaltyAmount) {
1252         _receiver = editionRoyaltiesHandlers[_editionId];
1253         require(_receiver != address(0), "Edition not setup");
1254         _royaltyAmount = (_value / modulo) * royaltyAmount;
1255     }
1256 
1257 }