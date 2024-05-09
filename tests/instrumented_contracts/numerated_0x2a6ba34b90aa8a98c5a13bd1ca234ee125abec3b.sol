1 // SPDX-License-Identifier: BUSL-1.1
2 // File: contracts/nft/IPFSConvert.sol
3 // contracts/IPFSConvert.sol
4 
5 pragma solidity ^0.8.4;
6 
7 /// @title Hightable IPFSConvert Library
8 /// @author Teahouse Finance
9 library IPFSConvert {
10 
11     bytes constant private CODE_STRING = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
12     bytes constant private CIDV0HEAD = "\x00\x04\x28\x0b\x12\x17\x09\x28\x31\x00\x12\x04\x28\x20\x25\x25\x22\x31\x1b\x1d\x39\x29\x09\x26\x1b\x29\x0b\x02\x0a\x18\x25\x22\x24\x1b\x39\x2c\x1d\x39\x07\x06\x29\x25\x13\x15\x2c\x17";
13 
14     /**
15      * @dev This function converts an 256 bits hash value into IPFS CIDv0 hash string.
16      * @param _cidv0 256 bits hash value (not including the 0x12 0x20 signature)
17      * @return IPFS CIDv0 hash string (Qm...)
18      */
19     function cidv0FromBytes32(bytes32 _cidv0) public pure returns (string memory) {
20         unchecked {
21             // convert to base58
22             bytes memory result = new bytes(46);        // 46 is the longest possible base58 result from CIDv0
23             uint256 resultLen = 45;
24             uint256 number = uint256(_cidv0);
25             while(number > 0) {
26                 uint256 rem = number % 58;
27                 result[resultLen] = bytes1(uint8(rem));
28                 resultLen--;
29                 number = number / 58;
30             }
31 
32             // add 0x1220 in front of _cidv0
33             uint256 i;
34             for (i = 0; i < 46; i++) {
35                 uint8 r = uint8(result[45 - i]) + uint8(CIDV0HEAD[i]);
36                 if (r >= 58) {
37                     result[45 - i] = bytes1(r - 58);
38                     result[45 - i - 1] = bytes1(uint8(result[45 - i - 1]) + 1);
39                 }
40                 else {
41                     result[45 - i] = bytes1(r);
42                 }
43             }
44 
45             // convert to characters
46             for (i = 0; i < 46; i++) {
47                 result[i] = CODE_STRING[uint8(result[i])];
48             }
49 
50             return string(result);
51         }
52     }
53 }
54 
55 // File: @openzeppelin/contracts/utils/Address.sol
56 
57 
58 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
59 
60 pragma solidity ^0.8.1;
61 
62 /**
63  * @dev Collection of functions related to the address type
64  */
65 library Address {
66     /**
67      * @dev Returns true if `account` is a contract.
68      *
69      * [IMPORTANT]
70      * ====
71      * It is unsafe to assume that an address for which this function returns
72      * false is an externally-owned account (EOA) and not a contract.
73      *
74      * Among others, `isContract` will return false for the following
75      * types of addresses:
76      *
77      *  - an externally-owned account
78      *  - a contract in construction
79      *  - an address where a contract will be created
80      *  - an address where a contract lived, but was destroyed
81      * ====
82      *
83      * [IMPORTANT]
84      * ====
85      * You shouldn't rely on `isContract` to protect against flash loan attacks!
86      *
87      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
88      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
89      * constructor.
90      * ====
91      */
92     function isContract(address account) internal view returns (bool) {
93         // This method relies on extcodesize/address.code.length, which returns 0
94         // for contracts in construction, since the code is only stored at the end
95         // of the constructor execution.
96 
97         return account.code.length > 0;
98     }
99 
100     /**
101      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
102      * `recipient`, forwarding all available gas and reverting on errors.
103      *
104      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
105      * of certain opcodes, possibly making contracts go over the 2300 gas limit
106      * imposed by `transfer`, making them unable to receive funds via
107      * `transfer`. {sendValue} removes this limitation.
108      *
109      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
110      *
111      * IMPORTANT: because control is transferred to `recipient`, care must be
112      * taken to not create reentrancy vulnerabilities. Consider using
113      * {ReentrancyGuard} or the
114      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
115      */
116     function sendValue(address payable recipient, uint256 amount) internal {
117         require(address(this).balance >= amount, "Address: insufficient balance");
118 
119         (bool success, ) = recipient.call{value: amount}("");
120         require(success, "Address: unable to send value, recipient may have reverted");
121     }
122 
123     /**
124      * @dev Performs a Solidity function call using a low level `call`. A
125      * plain `call` is an unsafe replacement for a function call: use this
126      * function instead.
127      *
128      * If `target` reverts with a revert reason, it is bubbled up by this
129      * function (like regular Solidity function calls).
130      *
131      * Returns the raw returned data. To convert to the expected return value,
132      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
133      *
134      * Requirements:
135      *
136      * - `target` must be a contract.
137      * - calling `target` with `data` must not revert.
138      *
139      * _Available since v3.1._
140      */
141     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
147      * `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but also transferring `value` wei to `target`.
162      *
163      * Requirements:
164      *
165      * - the calling contract must have an ETH balance of at least `value`.
166      * - the called Solidity function must be `payable`.
167      *
168      * _Available since v3.1._
169      */
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
180      * with `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a static call.
200      *
201      * _Available since v3.3._
202      */
203     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
204         return functionStaticCall(target, data, "Address: low-level static call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         require(isContract(target), "Address: delegate call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
253      * revert reason using the provided one.
254      *
255      * _Available since v4.3._
256      */
257     function verifyCallResult(
258         bool success,
259         bytes memory returndata,
260         string memory errorMessage
261     ) internal pure returns (bytes memory) {
262         if (success) {
263             return returndata;
264         } else {
265             // Look for revert reason and bubble it up if present
266             if (returndata.length > 0) {
267                 // The easiest way to bubble the revert reason is using memory via assembly
268 
269                 assembly {
270                     let returndata_size := mload(returndata)
271                     revert(add(32, returndata), returndata_size)
272                 }
273             } else {
274                 revert(errorMessage);
275             }
276         }
277     }
278 }
279 
280 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
281 
282 
283 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @title ERC721 token receiver interface
289  * @dev Interface for any contract that wants to support safeTransfers
290  * from ERC721 asset contracts.
291  */
292 interface IERC721Receiver {
293     /**
294      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
295      * by `operator` from `from`, this function is called.
296      *
297      * It must return its Solidity selector to confirm the token transfer.
298      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
299      *
300      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
301      */
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Interface of the ERC165 standard, as defined in the
319  * https://eips.ethereum.org/EIPS/eip-165[EIP].
320  *
321  * Implementers can declare support of contract interfaces, which can then be
322  * queried by others ({ERC165Checker}).
323  *
324  * For an implementation, see {ERC165}.
325  */
326 interface IERC165 {
327     /**
328      * @dev Returns true if this contract implements the interface defined by
329      * `interfaceId`. See the corresponding
330      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
331      * to learn more about how these ids are created.
332      *
333      * This function call must use less than 30 000 gas.
334      */
335     function supportsInterface(bytes4 interfaceId) external view returns (bool);
336 }
337 
338 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 
346 /**
347  * @dev Implementation of the {IERC165} interface.
348  *
349  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
350  * for the additional interface id that will be supported. For example:
351  *
352  * ```solidity
353  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
354  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
355  * }
356  * ```
357  *
358  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
359  */
360 abstract contract ERC165 is IERC165 {
361     /**
362      * @dev See {IERC165-supportsInterface}.
363      */
364     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365         return interfaceId == type(IERC165).interfaceId;
366     }
367 }
368 
369 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
370 
371 
372 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Required interface of an ERC721 compliant contract.
379  */
380 interface IERC721 is IERC165 {
381     /**
382      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
388      */
389     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
393      */
394     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
395 
396     /**
397      * @dev Returns the number of tokens in ``owner``'s account.
398      */
399     function balanceOf(address owner) external view returns (uint256 balance);
400 
401     /**
402      * @dev Returns the owner of the `tokenId` token.
403      *
404      * Requirements:
405      *
406      * - `tokenId` must exist.
407      */
408     function ownerOf(uint256 tokenId) external view returns (address owner);
409 
410     /**
411      * @dev Safely transfers `tokenId` token from `from` to `to`.
412      *
413      * Requirements:
414      *
415      * - `from` cannot be the zero address.
416      * - `to` cannot be the zero address.
417      * - `tokenId` token must exist and be owned by `from`.
418      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
419      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
420      *
421      * Emits a {Transfer} event.
422      */
423     function safeTransferFrom(
424         address from,
425         address to,
426         uint256 tokenId,
427         bytes calldata data
428     ) external;
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
432      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
440      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Transfers `tokenId` token from `from` to `to`.
452      *
453      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      *
462      * Emits a {Transfer} event.
463      */
464     function transferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
472      * The approval is cleared when the token is transferred.
473      *
474      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
475      *
476      * Requirements:
477      *
478      * - The caller must own the token or be an approved operator.
479      * - `tokenId` must exist.
480      *
481      * Emits an {Approval} event.
482      */
483     function approve(address to, uint256 tokenId) external;
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns the account approved for `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function getApproved(uint256 tokenId) external view returns (address operator);
505 
506     /**
507      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
508      *
509      * See {setApprovalForAll}
510      */
511     function isApprovedForAll(address owner, address operator) external view returns (bool);
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
524  * @dev See https://eips.ethereum.org/EIPS/eip-721
525  */
526 interface IERC721Metadata is IERC721 {
527     /**
528      * @dev Returns the token collection name.
529      */
530     function name() external view returns (string memory);
531 
532     /**
533      * @dev Returns the token collection symbol.
534      */
535     function symbol() external view returns (string memory);
536 
537     /**
538      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
539      */
540     function tokenURI(uint256 tokenId) external view returns (string memory);
541 }
542 
543 // File: erc721a/contracts/IERC721A.sol
544 
545 
546 // ERC721A Contracts v3.3.0
547 // Creator: Chiru Labs
548 
549 pragma solidity ^0.8.4;
550 
551 
552 
553 /**
554  * @dev Interface of an ERC721A compliant contract.
555  */
556 interface IERC721A is IERC721, IERC721Metadata {
557     /**
558      * The caller must own the token or be an approved operator.
559      */
560     error ApprovalCallerNotOwnerNorApproved();
561 
562     /**
563      * The token does not exist.
564      */
565     error ApprovalQueryForNonexistentToken();
566 
567     /**
568      * The caller cannot approve to their own address.
569      */
570     error ApproveToCaller();
571 
572     /**
573      * The caller cannot approve to the current owner.
574      */
575     error ApprovalToCurrentOwner();
576 
577     /**
578      * Cannot query the balance for the zero address.
579      */
580     error BalanceQueryForZeroAddress();
581 
582     /**
583      * Cannot mint to the zero address.
584      */
585     error MintToZeroAddress();
586 
587     /**
588      * The quantity of tokens minted must be more than zero.
589      */
590     error MintZeroQuantity();
591 
592     /**
593      * The token does not exist.
594      */
595     error OwnerQueryForNonexistentToken();
596 
597     /**
598      * The caller must own the token or be an approved operator.
599      */
600     error TransferCallerNotOwnerNorApproved();
601 
602     /**
603      * The token must be owned by `from`.
604      */
605     error TransferFromIncorrectOwner();
606 
607     /**
608      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
609      */
610     error TransferToNonERC721ReceiverImplementer();
611 
612     /**
613      * Cannot transfer to the zero address.
614      */
615     error TransferToZeroAddress();
616 
617     /**
618      * The token does not exist.
619      */
620     error URIQueryForNonexistentToken();
621 
622     // Compiler will pack this into a single 256bit word.
623     struct TokenOwnership {
624         // The address of the owner.
625         address addr;
626         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
627         uint64 startTimestamp;
628         // Whether the token has been burned.
629         bool burned;
630     }
631 
632     // Compiler will pack this into a single 256bit word.
633     struct AddressData {
634         // Realistically, 2**64-1 is more than enough.
635         uint64 balance;
636         // Keeps track of mint count with minimal overhead for tokenomics.
637         uint64 numberMinted;
638         // Keeps track of burn count with minimal overhead for tokenomics.
639         uint64 numberBurned;
640         // For miscellaneous variable(s) pertaining to the address
641         // (e.g. number of whitelist mint slots used).
642         // If there are multiple variables, please pack them into a uint64.
643         uint64 aux;
644     }
645 
646     /**
647      * @dev Returns the total amount of tokens stored by the contract.
648      * 
649      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
650      */
651     function totalSupply() external view returns (uint256);
652 }
653 
654 // File: @chainlink/contracts/src/v0.8/VRFRequestIDBase.sol
655 
656 
657 pragma solidity ^0.8.0;
658 
659 contract VRFRequestIDBase {
660   /**
661    * @notice returns the seed which is actually input to the VRF coordinator
662    *
663    * @dev To prevent repetition of VRF output due to repetition of the
664    * @dev user-supplied seed, that seed is combined in a hash with the
665    * @dev user-specific nonce, and the address of the consuming contract. The
666    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
667    * @dev the final seed, but the nonce does protect against repetition in
668    * @dev requests which are included in a single block.
669    *
670    * @param _userSeed VRF seed input provided by user
671    * @param _requester Address of the requesting contract
672    * @param _nonce User-specific nonce at the time of the request
673    */
674   function makeVRFInputSeed(
675     bytes32 _keyHash,
676     uint256 _userSeed,
677     address _requester,
678     uint256 _nonce
679   ) internal pure returns (uint256) {
680     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
681   }
682 
683   /**
684    * @notice Returns the id for this request
685    * @param _keyHash The serviceAgreement ID to be used for this request
686    * @param _vRFInputSeed The seed to be passed directly to the VRF
687    * @return The id for this request
688    *
689    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
690    * @dev contract, but the one generated by makeVRFInputSeed
691    */
692   function makeRequestId(bytes32 _keyHash, uint256 _vRFInputSeed) internal pure returns (bytes32) {
693     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
694   }
695 }
696 
697 // File: @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol
698 
699 
700 pragma solidity ^0.8.0;
701 
702 interface LinkTokenInterface {
703   function allowance(address owner, address spender) external view returns (uint256 remaining);
704 
705   function approve(address spender, uint256 value) external returns (bool success);
706 
707   function balanceOf(address owner) external view returns (uint256 balance);
708 
709   function decimals() external view returns (uint8 decimalPlaces);
710 
711   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
712 
713   function increaseApproval(address spender, uint256 subtractedValue) external;
714 
715   function name() external view returns (string memory tokenName);
716 
717   function symbol() external view returns (string memory tokenSymbol);
718 
719   function totalSupply() external view returns (uint256 totalTokensIssued);
720 
721   function transfer(address to, uint256 value) external returns (bool success);
722 
723   function transferAndCall(
724     address to,
725     uint256 value,
726     bytes calldata data
727   ) external returns (bool success);
728 
729   function transferFrom(
730     address from,
731     address to,
732     uint256 value
733   ) external returns (bool success);
734 }
735 
736 // File: @chainlink/contracts/src/v0.8/VRFConsumerBase.sol
737 
738 
739 pragma solidity ^0.8.0;
740 
741 
742 
743 /** ****************************************************************************
744  * @notice Interface for contracts using VRF randomness
745  * *****************************************************************************
746  * @dev PURPOSE
747  *
748  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
749  * @dev to Vera the verifier in such a way that Vera can be sure he's not
750  * @dev making his output up to suit himself. Reggie provides Vera a public key
751  * @dev to which he knows the secret key. Each time Vera provides a seed to
752  * @dev Reggie, he gives back a value which is computed completely
753  * @dev deterministically from the seed and the secret key.
754  *
755  * @dev Reggie provides a proof by which Vera can verify that the output was
756  * @dev correctly computed once Reggie tells it to her, but without that proof,
757  * @dev the output is indistinguishable to her from a uniform random sample
758  * @dev from the output space.
759  *
760  * @dev The purpose of this contract is to make it easy for unrelated contracts
761  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
762  * @dev simple access to a verifiable source of randomness.
763  * *****************************************************************************
764  * @dev USAGE
765  *
766  * @dev Calling contracts must inherit from VRFConsumerBase, and can
767  * @dev initialize VRFConsumerBase's attributes in their constructor as
768  * @dev shown:
769  *
770  * @dev   contract VRFConsumer {
771  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
772  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
773  * @dev         <initialization with other arguments goes here>
774  * @dev       }
775  * @dev   }
776  *
777  * @dev The oracle will have given you an ID for the VRF keypair they have
778  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
779  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
780  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
781  * @dev want to generate randomness from.
782  *
783  * @dev Once the VRFCoordinator has received and validated the oracle's response
784  * @dev to your request, it will call your contract's fulfillRandomness method.
785  *
786  * @dev The randomness argument to fulfillRandomness is the actual random value
787  * @dev generated from your seed.
788  *
789  * @dev The requestId argument is generated from the keyHash and the seed by
790  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
791  * @dev requests open, you can use the requestId to track which seed is
792  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
793  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
794  * @dev if your contract could have multiple requests in flight simultaneously.)
795  *
796  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
797  * @dev differ. (Which is critical to making unpredictable randomness! See the
798  * @dev next section.)
799  *
800  * *****************************************************************************
801  * @dev SECURITY CONSIDERATIONS
802  *
803  * @dev A method with the ability to call your fulfillRandomness method directly
804  * @dev could spoof a VRF response with any random value, so it's critical that
805  * @dev it cannot be directly called by anything other than this base contract
806  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
807  *
808  * @dev For your users to trust that your contract's random behavior is free
809  * @dev from malicious interference, it's best if you can write it so that all
810  * @dev behaviors implied by a VRF response are executed *during* your
811  * @dev fulfillRandomness method. If your contract must store the response (or
812  * @dev anything derived from it) and use it later, you must ensure that any
813  * @dev user-significant behavior which depends on that stored value cannot be
814  * @dev manipulated by a subsequent VRF request.
815  *
816  * @dev Similarly, both miners and the VRF oracle itself have some influence
817  * @dev over the order in which VRF responses appear on the blockchain, so if
818  * @dev your contract could have multiple VRF requests in flight simultaneously,
819  * @dev you must ensure that the order in which the VRF responses arrive cannot
820  * @dev be used to manipulate your contract's user-significant behavior.
821  *
822  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
823  * @dev block in which the request is made, user-provided seeds have no impact
824  * @dev on its economic security properties. They are only included for API
825  * @dev compatability with previous versions of this contract.
826  *
827  * @dev Since the block hash of the block which contains the requestRandomness
828  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
829  * @dev miner could, in principle, fork the blockchain to evict the block
830  * @dev containing the request, forcing the request to be included in a
831  * @dev different block with a different hash, and therefore a different input
832  * @dev to the VRF. However, such an attack would incur a substantial economic
833  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
834  * @dev until it calls responds to a request.
835  */
836 abstract contract VRFConsumerBase is VRFRequestIDBase {
837   /**
838    * @notice fulfillRandomness handles the VRF response. Your contract must
839    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
840    * @notice principles to keep in mind when implementing your fulfillRandomness
841    * @notice method.
842    *
843    * @dev VRFConsumerBase expects its subcontracts to have a method with this
844    * @dev signature, and will call it once it has verified the proof
845    * @dev associated with the randomness. (It is triggered via a call to
846    * @dev rawFulfillRandomness, below.)
847    *
848    * @param requestId The Id initially returned by requestRandomness
849    * @param randomness the VRF output
850    */
851   function fulfillRandomness(bytes32 requestId, uint256 randomness) internal virtual;
852 
853   /**
854    * @dev In order to keep backwards compatibility we have kept the user
855    * seed field around. We remove the use of it because given that the blockhash
856    * enters later, it overrides whatever randomness the used seed provides.
857    * Given that it adds no security, and can easily lead to misunderstandings,
858    * we have removed it from usage and can now provide a simpler API.
859    */
860   uint256 private constant USER_SEED_PLACEHOLDER = 0;
861 
862   /**
863    * @notice requestRandomness initiates a request for VRF output given _seed
864    *
865    * @dev The fulfillRandomness method receives the output, once it's provided
866    * @dev by the Oracle, and verified by the vrfCoordinator.
867    *
868    * @dev The _keyHash must already be registered with the VRFCoordinator, and
869    * @dev the _fee must exceed the fee specified during registration of the
870    * @dev _keyHash.
871    *
872    * @dev The _seed parameter is vestigial, and is kept only for API
873    * @dev compatibility with older versions. It can't *hurt* to mix in some of
874    * @dev your own randomness, here, but it's not necessary because the VRF
875    * @dev oracle will mix the hash of the block containing your request into the
876    * @dev VRF seed it ultimately uses.
877    *
878    * @param _keyHash ID of public key against which randomness is generated
879    * @param _fee The amount of LINK to send with the request
880    *
881    * @return requestId unique ID for this request
882    *
883    * @dev The returned requestId can be used to distinguish responses to
884    * @dev concurrent requests. It is passed as the first argument to
885    * @dev fulfillRandomness.
886    */
887   function requestRandomness(bytes32 _keyHash, uint256 _fee) internal returns (bytes32 requestId) {
888     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
889     // This is the seed passed to VRFCoordinator. The oracle will mix this with
890     // the hash of the block containing this request to obtain the seed/input
891     // which is finally passed to the VRF cryptographic machinery.
892     uint256 vRFSeed = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
893     // nonces[_keyHash] must stay in sync with
894     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
895     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
896     // This provides protection against the user repeating their input seed,
897     // which would result in a predictable/duplicate output, if multiple such
898     // requests appeared in the same block.
899     nonces[_keyHash] = nonces[_keyHash] + 1;
900     return makeRequestId(_keyHash, vRFSeed);
901   }
902 
903   LinkTokenInterface internal immutable LINK;
904   address private immutable vrfCoordinator;
905 
906   // Nonces for each VRF key from which randomness has been requested.
907   //
908   // Must stay in sync with VRFCoordinator[_keyHash][this]
909   mapping(bytes32 => uint256) /* keyHash */ /* nonce */
910     private nonces;
911 
912   /**
913    * @param _vrfCoordinator address of VRFCoordinator contract
914    * @param _link address of LINK token contract
915    *
916    * @dev https://docs.chain.link/docs/link-token-contracts
917    */
918   constructor(address _vrfCoordinator, address _link) {
919     vrfCoordinator = _vrfCoordinator;
920     LINK = LinkTokenInterface(_link);
921   }
922 
923   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
924   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
925   // the origin of the call
926   function rawFulfillRandomness(bytes32 requestId, uint256 randomness) external {
927     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
928     fulfillRandomness(requestId, randomness);
929   }
930 }
931 
932 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
933 
934 
935 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 /**
940  * @dev These functions deal with verification of Merkle Trees proofs.
941  *
942  * The proofs can be generated using the JavaScript library
943  * https://github.com/miguelmota/merkletreejs[merkletreejs].
944  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
945  *
946  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
947  *
948  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
949  * hashing, or use a hash function other than keccak256 for hashing leaves.
950  * This is because the concatenation of a sorted pair of internal nodes in
951  * the merkle tree could be reinterpreted as a leaf value.
952  */
953 library MerkleProof {
954     /**
955      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
956      * defined by `root`. For this, a `proof` must be provided, containing
957      * sibling hashes on the branch from the leaf to the root of the tree. Each
958      * pair of leaves and each pair of pre-images are assumed to be sorted.
959      */
960     function verify(
961         bytes32[] memory proof,
962         bytes32 root,
963         bytes32 leaf
964     ) internal pure returns (bool) {
965         return processProof(proof, leaf) == root;
966     }
967 
968     /**
969      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
970      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
971      * hash matches the root of the tree. When processing the proof, the pairs
972      * of leafs & pre-images are assumed to be sorted.
973      *
974      * _Available since v4.4._
975      */
976     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
977         bytes32 computedHash = leaf;
978         for (uint256 i = 0; i < proof.length; i++) {
979             bytes32 proofElement = proof[i];
980             if (computedHash <= proofElement) {
981                 // Hash(current computed hash + current element of the proof)
982                 computedHash = _efficientHash(computedHash, proofElement);
983             } else {
984                 // Hash(current element of the proof + current computed hash)
985                 computedHash = _efficientHash(proofElement, computedHash);
986             }
987         }
988         return computedHash;
989     }
990 
991     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
992         assembly {
993             mstore(0x00, a)
994             mstore(0x20, b)
995             value := keccak256(0x00, 0x40)
996         }
997     }
998 }
999 
1000 // File: @openzeppelin/contracts/utils/Strings.sol
1001 
1002 
1003 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 /**
1008  * @dev String operations.
1009  */
1010 library Strings {
1011     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1012 
1013     /**
1014      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1015      */
1016     function toString(uint256 value) internal pure returns (string memory) {
1017         // Inspired by OraclizeAPI's implementation - MIT licence
1018         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1019 
1020         if (value == 0) {
1021             return "0";
1022         }
1023         uint256 temp = value;
1024         uint256 digits;
1025         while (temp != 0) {
1026             digits++;
1027             temp /= 10;
1028         }
1029         bytes memory buffer = new bytes(digits);
1030         while (value != 0) {
1031             digits -= 1;
1032             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1033             value /= 10;
1034         }
1035         return string(buffer);
1036     }
1037 
1038     /**
1039      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1040      */
1041     function toHexString(uint256 value) internal pure returns (string memory) {
1042         if (value == 0) {
1043             return "0x00";
1044         }
1045         uint256 temp = value;
1046         uint256 length = 0;
1047         while (temp != 0) {
1048             length++;
1049             temp >>= 8;
1050         }
1051         return toHexString(value, length);
1052     }
1053 
1054     /**
1055      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1056      */
1057     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1058         bytes memory buffer = new bytes(2 * length + 2);
1059         buffer[0] = "0";
1060         buffer[1] = "x";
1061         for (uint256 i = 2 * length + 1; i > 1; --i) {
1062             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1063             value >>= 4;
1064         }
1065         require(value == 0, "Strings: hex length insufficient");
1066         return string(buffer);
1067     }
1068 }
1069 
1070 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1071 
1072 
1073 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 
1078 /**
1079  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1080  *
1081  * These functions can be used to verify that a message was signed by the holder
1082  * of the private keys of a given address.
1083  */
1084 library ECDSA {
1085     enum RecoverError {
1086         NoError,
1087         InvalidSignature,
1088         InvalidSignatureLength,
1089         InvalidSignatureS,
1090         InvalidSignatureV
1091     }
1092 
1093     function _throwError(RecoverError error) private pure {
1094         if (error == RecoverError.NoError) {
1095             return; // no error: do nothing
1096         } else if (error == RecoverError.InvalidSignature) {
1097             revert("ECDSA: invalid signature");
1098         } else if (error == RecoverError.InvalidSignatureLength) {
1099             revert("ECDSA: invalid signature length");
1100         } else if (error == RecoverError.InvalidSignatureS) {
1101             revert("ECDSA: invalid signature 's' value");
1102         } else if (error == RecoverError.InvalidSignatureV) {
1103             revert("ECDSA: invalid signature 'v' value");
1104         }
1105     }
1106 
1107     /**
1108      * @dev Returns the address that signed a hashed message (`hash`) with
1109      * `signature` or error string. This address can then be used for verification purposes.
1110      *
1111      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1112      * this function rejects them by requiring the `s` value to be in the lower
1113      * half order, and the `v` value to be either 27 or 28.
1114      *
1115      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1116      * verification to be secure: it is possible to craft signatures that
1117      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1118      * this is by receiving a hash of the original message (which may otherwise
1119      * be too long), and then calling {toEthSignedMessageHash} on it.
1120      *
1121      * Documentation for signature generation:
1122      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1123      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1124      *
1125      * _Available since v4.3._
1126      */
1127     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1128         // Check the signature length
1129         // - case 65: r,s,v signature (standard)
1130         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1131         if (signature.length == 65) {
1132             bytes32 r;
1133             bytes32 s;
1134             uint8 v;
1135             // ecrecover takes the signature parameters, and the only way to get them
1136             // currently is to use assembly.
1137             assembly {
1138                 r := mload(add(signature, 0x20))
1139                 s := mload(add(signature, 0x40))
1140                 v := byte(0, mload(add(signature, 0x60)))
1141             }
1142             return tryRecover(hash, v, r, s);
1143         } else if (signature.length == 64) {
1144             bytes32 r;
1145             bytes32 vs;
1146             // ecrecover takes the signature parameters, and the only way to get them
1147             // currently is to use assembly.
1148             assembly {
1149                 r := mload(add(signature, 0x20))
1150                 vs := mload(add(signature, 0x40))
1151             }
1152             return tryRecover(hash, r, vs);
1153         } else {
1154             return (address(0), RecoverError.InvalidSignatureLength);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns the address that signed a hashed message (`hash`) with
1160      * `signature`. This address can then be used for verification purposes.
1161      *
1162      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1163      * this function rejects them by requiring the `s` value to be in the lower
1164      * half order, and the `v` value to be either 27 or 28.
1165      *
1166      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1167      * verification to be secure: it is possible to craft signatures that
1168      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1169      * this is by receiving a hash of the original message (which may otherwise
1170      * be too long), and then calling {toEthSignedMessageHash} on it.
1171      */
1172     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1173         (address recovered, RecoverError error) = tryRecover(hash, signature);
1174         _throwError(error);
1175         return recovered;
1176     }
1177 
1178     /**
1179      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1180      *
1181      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1182      *
1183      * _Available since v4.3._
1184      */
1185     function tryRecover(
1186         bytes32 hash,
1187         bytes32 r,
1188         bytes32 vs
1189     ) internal pure returns (address, RecoverError) {
1190         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1191         uint8 v = uint8((uint256(vs) >> 255) + 27);
1192         return tryRecover(hash, v, r, s);
1193     }
1194 
1195     /**
1196      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1197      *
1198      * _Available since v4.2._
1199      */
1200     function recover(
1201         bytes32 hash,
1202         bytes32 r,
1203         bytes32 vs
1204     ) internal pure returns (address) {
1205         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1206         _throwError(error);
1207         return recovered;
1208     }
1209 
1210     /**
1211      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1212      * `r` and `s` signature fields separately.
1213      *
1214      * _Available since v4.3._
1215      */
1216     function tryRecover(
1217         bytes32 hash,
1218         uint8 v,
1219         bytes32 r,
1220         bytes32 s
1221     ) internal pure returns (address, RecoverError) {
1222         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1223         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1224         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1225         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1226         //
1227         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1228         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1229         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1230         // these malleable signatures as well.
1231         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1232             return (address(0), RecoverError.InvalidSignatureS);
1233         }
1234         if (v != 27 && v != 28) {
1235             return (address(0), RecoverError.InvalidSignatureV);
1236         }
1237 
1238         // If the signature is valid (and not malleable), return the signer address
1239         address signer = ecrecover(hash, v, r, s);
1240         if (signer == address(0)) {
1241             return (address(0), RecoverError.InvalidSignature);
1242         }
1243 
1244         return (signer, RecoverError.NoError);
1245     }
1246 
1247     /**
1248      * @dev Overload of {ECDSA-recover} that receives the `v`,
1249      * `r` and `s` signature fields separately.
1250      */
1251     function recover(
1252         bytes32 hash,
1253         uint8 v,
1254         bytes32 r,
1255         bytes32 s
1256     ) internal pure returns (address) {
1257         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1258         _throwError(error);
1259         return recovered;
1260     }
1261 
1262     /**
1263      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1264      * produces hash corresponding to the one signed with the
1265      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1266      * JSON-RPC method as part of EIP-191.
1267      *
1268      * See {recover}.
1269      */
1270     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1271         // 32 is the length in bytes of hash,
1272         // enforced by the type signature above
1273         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1274     }
1275 
1276     /**
1277      * @dev Returns an Ethereum Signed Message, created from `s`. This
1278      * produces hash corresponding to the one signed with the
1279      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1280      * JSON-RPC method as part of EIP-191.
1281      *
1282      * See {recover}.
1283      */
1284     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1285         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1286     }
1287 
1288     /**
1289      * @dev Returns an Ethereum Signed Typed Data, created from a
1290      * `domainSeparator` and a `structHash`. This produces hash corresponding
1291      * to the one signed with the
1292      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1293      * JSON-RPC method as part of EIP-712.
1294      *
1295      * See {recover}.
1296      */
1297     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1298         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1299     }
1300 }
1301 
1302 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1303 
1304 
1305 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1306 
1307 pragma solidity ^0.8.0;
1308 
1309 /**
1310  * @dev Contract module that helps prevent reentrant calls to a function.
1311  *
1312  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1313  * available, which can be applied to functions to make sure there are no nested
1314  * (reentrant) calls to them.
1315  *
1316  * Note that because there is a single `nonReentrant` guard, functions marked as
1317  * `nonReentrant` may not call one another. This can be worked around by making
1318  * those functions `private`, and then adding `external` `nonReentrant` entry
1319  * points to them.
1320  *
1321  * TIP: If you would like to learn more about reentrancy and alternative ways
1322  * to protect against it, check out our blog post
1323  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1324  */
1325 abstract contract ReentrancyGuard {
1326     // Booleans are more expensive than uint256 or any type that takes up a full
1327     // word because each write operation emits an extra SLOAD to first read the
1328     // slot's contents, replace the bits taken up by the boolean, and then write
1329     // back. This is the compiler's defense against contract upgrades and
1330     // pointer aliasing, and it cannot be disabled.
1331 
1332     // The values being non-zero value makes deployment a bit more expensive,
1333     // but in exchange the refund on every call to nonReentrant will be lower in
1334     // amount. Since refunds are capped to a percentage of the total
1335     // transaction's gas, it is best to keep them low in cases like this one, to
1336     // increase the likelihood of the full refund coming into effect.
1337     uint256 private constant _NOT_ENTERED = 1;
1338     uint256 private constant _ENTERED = 2;
1339 
1340     uint256 private _status;
1341 
1342     constructor() {
1343         _status = _NOT_ENTERED;
1344     }
1345 
1346     /**
1347      * @dev Prevents a contract from calling itself, directly or indirectly.
1348      * Calling a `nonReentrant` function from another `nonReentrant`
1349      * function is not supported. It is possible to prevent this from happening
1350      * by making the `nonReentrant` function external, and making it call a
1351      * `private` function that does the actual work.
1352      */
1353     modifier nonReentrant() {
1354         // On the first call to nonReentrant, _notEntered will be true
1355         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1356 
1357         // Any calls to nonReentrant after this point will fail
1358         _status = _ENTERED;
1359 
1360         _;
1361 
1362         // By storing the original value once again, a refund is triggered (see
1363         // https://eips.ethereum.org/EIPS/eip-2200)
1364         _status = _NOT_ENTERED;
1365     }
1366 }
1367 
1368 // File: @openzeppelin/contracts/utils/Context.sol
1369 
1370 
1371 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 /**
1376  * @dev Provides information about the current execution context, including the
1377  * sender of the transaction and its data. While these are generally available
1378  * via msg.sender and msg.data, they should not be accessed in such a direct
1379  * manner, since when dealing with meta-transactions the account sending and
1380  * paying for execution may not be the actual sender (as far as an application
1381  * is concerned).
1382  *
1383  * This contract is only required for intermediate, library-like contracts.
1384  */
1385 abstract contract Context {
1386     function _msgSender() internal view virtual returns (address) {
1387         return msg.sender;
1388     }
1389 
1390     function _msgData() internal view virtual returns (bytes calldata) {
1391         return msg.data;
1392     }
1393 }
1394 
1395 // File: erc721a/contracts/ERC721A.sol
1396 
1397 
1398 // ERC721A Contracts v3.3.0
1399 // Creator: Chiru Labs
1400 
1401 pragma solidity ^0.8.4;
1402 
1403 
1404 
1405 
1406 
1407 
1408 
1409 /**
1410  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1411  * the Metadata extension. Built to optimize for lower gas during batch mints.
1412  *
1413  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1414  *
1415  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1416  *
1417  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1418  */
1419 contract ERC721A is Context, ERC165, IERC721A {
1420     using Address for address;
1421     using Strings for uint256;
1422 
1423     // The tokenId of the next token to be minted.
1424     uint256 internal _currentIndex;
1425 
1426     // The number of tokens burned.
1427     uint256 internal _burnCounter;
1428 
1429     // Token name
1430     string private _name;
1431 
1432     // Token symbol
1433     string private _symbol;
1434 
1435     // Mapping from token ID to ownership details
1436     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1437     mapping(uint256 => TokenOwnership) internal _ownerships;
1438 
1439     // Mapping owner address to address data
1440     mapping(address => AddressData) private _addressData;
1441 
1442     // Mapping from token ID to approved address
1443     mapping(uint256 => address) private _tokenApprovals;
1444 
1445     // Mapping from owner to operator approvals
1446     mapping(address => mapping(address => bool)) private _operatorApprovals;
1447 
1448     constructor(string memory name_, string memory symbol_) {
1449         _name = name_;
1450         _symbol = symbol_;
1451         _currentIndex = _startTokenId();
1452     }
1453 
1454     /**
1455      * To change the starting tokenId, please override this function.
1456      */
1457     function _startTokenId() internal view virtual returns (uint256) {
1458         return 0;
1459     }
1460 
1461     /**
1462      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1463      */
1464     function totalSupply() public view override returns (uint256) {
1465         // Counter underflow is impossible as _burnCounter cannot be incremented
1466         // more than _currentIndex - _startTokenId() times
1467         unchecked {
1468             return _currentIndex - _burnCounter - _startTokenId();
1469         }
1470     }
1471 
1472     /**
1473      * Returns the total amount of tokens minted in the contract.
1474      */
1475     function _totalMinted() internal view returns (uint256) {
1476         // Counter underflow is impossible as _currentIndex does not decrement,
1477         // and it is initialized to _startTokenId()
1478         unchecked {
1479             return _currentIndex - _startTokenId();
1480         }
1481     }
1482 
1483     /**
1484      * @dev See {IERC165-supportsInterface}.
1485      */
1486     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1487         return
1488             interfaceId == type(IERC721).interfaceId ||
1489             interfaceId == type(IERC721Metadata).interfaceId ||
1490             super.supportsInterface(interfaceId);
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-balanceOf}.
1495      */
1496     function balanceOf(address owner) public view override returns (uint256) {
1497         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1498         return uint256(_addressData[owner].balance);
1499     }
1500 
1501     /**
1502      * Returns the number of tokens minted by `owner`.
1503      */
1504     function _numberMinted(address owner) internal view returns (uint256) {
1505         return uint256(_addressData[owner].numberMinted);
1506     }
1507 
1508     /**
1509      * Returns the number of tokens burned by or on behalf of `owner`.
1510      */
1511     function _numberBurned(address owner) internal view returns (uint256) {
1512         return uint256(_addressData[owner].numberBurned);
1513     }
1514 
1515     /**
1516      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1517      */
1518     function _getAux(address owner) internal view returns (uint64) {
1519         return _addressData[owner].aux;
1520     }
1521 
1522     /**
1523      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1524      * If there are multiple variables, please pack them into a uint64.
1525      */
1526     function _setAux(address owner, uint64 aux) internal {
1527         _addressData[owner].aux = aux;
1528     }
1529 
1530     /**
1531      * Gas spent here starts off proportional to the maximum mint batch size.
1532      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1533      */
1534     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1535         uint256 curr = tokenId;
1536 
1537         unchecked {
1538             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1539                 TokenOwnership memory ownership = _ownerships[curr];
1540                 if (!ownership.burned) {
1541                     if (ownership.addr != address(0)) {
1542                         return ownership;
1543                     }
1544                     // Invariant:
1545                     // There will always be an ownership that has an address and is not burned
1546                     // before an ownership that does not have an address and is not burned.
1547                     // Hence, curr will not underflow.
1548                     while (true) {
1549                         curr--;
1550                         ownership = _ownerships[curr];
1551                         if (ownership.addr != address(0)) {
1552                             return ownership;
1553                         }
1554                     }
1555                 }
1556             }
1557         }
1558         revert OwnerQueryForNonexistentToken();
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-ownerOf}.
1563      */
1564     function ownerOf(uint256 tokenId) public view override returns (address) {
1565         return _ownershipOf(tokenId).addr;
1566     }
1567 
1568     /**
1569      * @dev See {IERC721Metadata-name}.
1570      */
1571     function name() public view virtual override returns (string memory) {
1572         return _name;
1573     }
1574 
1575     /**
1576      * @dev See {IERC721Metadata-symbol}.
1577      */
1578     function symbol() public view virtual override returns (string memory) {
1579         return _symbol;
1580     }
1581 
1582     /**
1583      * @dev See {IERC721Metadata-tokenURI}.
1584      */
1585     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1586         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1587 
1588         string memory baseURI = _baseURI();
1589         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1590     }
1591 
1592     /**
1593      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1594      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1595      * by default, can be overriden in child contracts.
1596      */
1597     function _baseURI() internal view virtual returns (string memory) {
1598         return '';
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-approve}.
1603      */
1604     function approve(address to, uint256 tokenId) public override {
1605         address owner = ERC721A.ownerOf(tokenId);
1606         if (to == owner) revert ApprovalToCurrentOwner();
1607 
1608         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1609             revert ApprovalCallerNotOwnerNorApproved();
1610         }
1611 
1612         _approve(to, tokenId, owner);
1613     }
1614 
1615     /**
1616      * @dev See {IERC721-getApproved}.
1617      */
1618     function getApproved(uint256 tokenId) public view override returns (address) {
1619         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1620 
1621         return _tokenApprovals[tokenId];
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-setApprovalForAll}.
1626      */
1627     function setApprovalForAll(address operator, bool approved) public virtual override {
1628         if (operator == _msgSender()) revert ApproveToCaller();
1629 
1630         _operatorApprovals[_msgSender()][operator] = approved;
1631         emit ApprovalForAll(_msgSender(), operator, approved);
1632     }
1633 
1634     /**
1635      * @dev See {IERC721-isApprovedForAll}.
1636      */
1637     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1638         return _operatorApprovals[owner][operator];
1639     }
1640 
1641     /**
1642      * @dev See {IERC721-transferFrom}.
1643      */
1644     function transferFrom(
1645         address from,
1646         address to,
1647         uint256 tokenId
1648     ) public virtual override {
1649         _transfer(from, to, tokenId);
1650     }
1651 
1652     /**
1653      * @dev See {IERC721-safeTransferFrom}.
1654      */
1655     function safeTransferFrom(
1656         address from,
1657         address to,
1658         uint256 tokenId
1659     ) public virtual override {
1660         safeTransferFrom(from, to, tokenId, '');
1661     }
1662 
1663     /**
1664      * @dev See {IERC721-safeTransferFrom}.
1665      */
1666     function safeTransferFrom(
1667         address from,
1668         address to,
1669         uint256 tokenId,
1670         bytes memory _data
1671     ) public virtual override {
1672         _transfer(from, to, tokenId);
1673         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1674             revert TransferToNonERC721ReceiverImplementer();
1675         }
1676     }
1677 
1678     /**
1679      * @dev Returns whether `tokenId` exists.
1680      *
1681      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1682      *
1683      * Tokens start existing when they are minted (`_mint`),
1684      */
1685     function _exists(uint256 tokenId) internal view returns (bool) {
1686         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1687     }
1688 
1689     /**
1690      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1691      */
1692     function _safeMint(address to, uint256 quantity) internal {
1693         _safeMint(to, quantity, '');
1694     }
1695 
1696     /**
1697      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1698      *
1699      * Requirements:
1700      *
1701      * - If `to` refers to a smart contract, it must implement
1702      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1703      * - `quantity` must be greater than 0.
1704      *
1705      * Emits a {Transfer} event.
1706      */
1707     function _safeMint(
1708         address to,
1709         uint256 quantity,
1710         bytes memory _data
1711     ) internal {
1712         uint256 startTokenId = _currentIndex;
1713         if (to == address(0)) revert MintToZeroAddress();
1714         if (quantity == 0) revert MintZeroQuantity();
1715 
1716         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1717 
1718         // Overflows are incredibly unrealistic.
1719         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1720         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1721         unchecked {
1722             _addressData[to].balance += uint64(quantity);
1723             _addressData[to].numberMinted += uint64(quantity);
1724 
1725             _ownerships[startTokenId].addr = to;
1726             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1727 
1728             uint256 updatedIndex = startTokenId;
1729             uint256 end = updatedIndex + quantity;
1730 
1731             if (to.isContract()) {
1732                 do {
1733                     emit Transfer(address(0), to, updatedIndex);
1734                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1735                         revert TransferToNonERC721ReceiverImplementer();
1736                     }
1737                 } while (updatedIndex < end);
1738                 // Reentrancy protection
1739                 if (_currentIndex != startTokenId) revert();
1740             } else {
1741                 do {
1742                     emit Transfer(address(0), to, updatedIndex++);
1743                 } while (updatedIndex < end);
1744             }
1745             _currentIndex = updatedIndex;
1746         }
1747         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1748     }
1749 
1750     /**
1751      * @dev Mints `quantity` tokens and transfers them to `to`.
1752      *
1753      * Requirements:
1754      *
1755      * - `to` cannot be the zero address.
1756      * - `quantity` must be greater than 0.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function _mint(address to, uint256 quantity) internal {
1761         uint256 startTokenId = _currentIndex;
1762         if (to == address(0)) revert MintToZeroAddress();
1763         if (quantity == 0) revert MintZeroQuantity();
1764 
1765         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1766 
1767         // Overflows are incredibly unrealistic.
1768         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1769         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1770         unchecked {
1771             _addressData[to].balance += uint64(quantity);
1772             _addressData[to].numberMinted += uint64(quantity);
1773 
1774             _ownerships[startTokenId].addr = to;
1775             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1776 
1777             uint256 updatedIndex = startTokenId;
1778             uint256 end = updatedIndex + quantity;
1779 
1780             do {
1781                 emit Transfer(address(0), to, updatedIndex++);
1782             } while (updatedIndex < end);
1783 
1784             _currentIndex = updatedIndex;
1785         }
1786         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1787     }
1788 
1789     /**
1790      * @dev Transfers `tokenId` from `from` to `to`.
1791      *
1792      * Requirements:
1793      *
1794      * - `to` cannot be the zero address.
1795      * - `tokenId` token must be owned by `from`.
1796      *
1797      * Emits a {Transfer} event.
1798      */
1799     function _transfer(
1800         address from,
1801         address to,
1802         uint256 tokenId
1803     ) private {
1804         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1805 
1806         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1807 
1808         bool isApprovedOrOwner = (_msgSender() == from ||
1809             isApprovedForAll(from, _msgSender()) ||
1810             getApproved(tokenId) == _msgSender());
1811 
1812         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1813         if (to == address(0)) revert TransferToZeroAddress();
1814 
1815         _beforeTokenTransfers(from, to, tokenId, 1);
1816 
1817         // Clear approvals from the previous owner
1818         _approve(address(0), tokenId, from);
1819 
1820         // Underflow of the sender's balance is impossible because we check for
1821         // ownership above and the recipient's balance can't realistically overflow.
1822         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1823         unchecked {
1824             _addressData[from].balance -= 1;
1825             _addressData[to].balance += 1;
1826 
1827             TokenOwnership storage currSlot = _ownerships[tokenId];
1828             currSlot.addr = to;
1829             currSlot.startTimestamp = uint64(block.timestamp);
1830 
1831             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1832             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1833             uint256 nextTokenId = tokenId + 1;
1834             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1835             if (nextSlot.addr == address(0)) {
1836                 // This will suffice for checking _exists(nextTokenId),
1837                 // as a burned slot cannot contain the zero address.
1838                 if (nextTokenId != _currentIndex) {
1839                     nextSlot.addr = from;
1840                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1841                 }
1842             }
1843         }
1844 
1845         emit Transfer(from, to, tokenId);
1846         _afterTokenTransfers(from, to, tokenId, 1);
1847     }
1848 
1849     /**
1850      * @dev Equivalent to `_burn(tokenId, false)`.
1851      */
1852     function _burn(uint256 tokenId) internal virtual {
1853         _burn(tokenId, false);
1854     }
1855 
1856     /**
1857      * @dev Destroys `tokenId`.
1858      * The approval is cleared when the token is burned.
1859      *
1860      * Requirements:
1861      *
1862      * - `tokenId` must exist.
1863      *
1864      * Emits a {Transfer} event.
1865      */
1866     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1867         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1868 
1869         address from = prevOwnership.addr;
1870 
1871         if (approvalCheck) {
1872             bool isApprovedOrOwner = (_msgSender() == from ||
1873                 isApprovedForAll(from, _msgSender()) ||
1874                 getApproved(tokenId) == _msgSender());
1875 
1876             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1877         }
1878 
1879         _beforeTokenTransfers(from, address(0), tokenId, 1);
1880 
1881         // Clear approvals from the previous owner
1882         _approve(address(0), tokenId, from);
1883 
1884         // Underflow of the sender's balance is impossible because we check for
1885         // ownership above and the recipient's balance can't realistically overflow.
1886         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1887         unchecked {
1888             AddressData storage addressData = _addressData[from];
1889             addressData.balance -= 1;
1890             addressData.numberBurned += 1;
1891 
1892             // Keep track of who burned the token, and the timestamp of burning.
1893             TokenOwnership storage currSlot = _ownerships[tokenId];
1894             currSlot.addr = from;
1895             currSlot.startTimestamp = uint64(block.timestamp);
1896             currSlot.burned = true;
1897 
1898             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1899             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1900             uint256 nextTokenId = tokenId + 1;
1901             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1902             if (nextSlot.addr == address(0)) {
1903                 // This will suffice for checking _exists(nextTokenId),
1904                 // as a burned slot cannot contain the zero address.
1905                 if (nextTokenId != _currentIndex) {
1906                     nextSlot.addr = from;
1907                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1908                 }
1909             }
1910         }
1911 
1912         emit Transfer(from, address(0), tokenId);
1913         _afterTokenTransfers(from, address(0), tokenId, 1);
1914 
1915         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1916         unchecked {
1917             _burnCounter++;
1918         }
1919     }
1920 
1921     /**
1922      * @dev Approve `to` to operate on `tokenId`
1923      *
1924      * Emits a {Approval} event.
1925      */
1926     function _approve(
1927         address to,
1928         uint256 tokenId,
1929         address owner
1930     ) private {
1931         _tokenApprovals[tokenId] = to;
1932         emit Approval(owner, to, tokenId);
1933     }
1934 
1935     /**
1936      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1937      *
1938      * @param from address representing the previous owner of the given token ID
1939      * @param to target address that will receive the tokens
1940      * @param tokenId uint256 ID of the token to be transferred
1941      * @param _data bytes optional data to send along with the call
1942      * @return bool whether the call correctly returned the expected magic value
1943      */
1944     function _checkContractOnERC721Received(
1945         address from,
1946         address to,
1947         uint256 tokenId,
1948         bytes memory _data
1949     ) private returns (bool) {
1950         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1951             return retval == IERC721Receiver(to).onERC721Received.selector;
1952         } catch (bytes memory reason) {
1953             if (reason.length == 0) {
1954                 revert TransferToNonERC721ReceiverImplementer();
1955             } else {
1956                 assembly {
1957                     revert(add(32, reason), mload(reason))
1958                 }
1959             }
1960         }
1961     }
1962 
1963     /**
1964      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1965      * And also called before burning one token.
1966      *
1967      * startTokenId - the first token id to be transferred
1968      * quantity - the amount to be transferred
1969      *
1970      * Calling conditions:
1971      *
1972      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1973      * transferred to `to`.
1974      * - When `from` is zero, `tokenId` will be minted for `to`.
1975      * - When `to` is zero, `tokenId` will be burned by `from`.
1976      * - `from` and `to` are never both zero.
1977      */
1978     function _beforeTokenTransfers(
1979         address from,
1980         address to,
1981         uint256 startTokenId,
1982         uint256 quantity
1983     ) internal virtual {}
1984 
1985     /**
1986      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1987      * minting.
1988      * And also called after one token has been burned.
1989      *
1990      * startTokenId - the first token id to be transferred
1991      * quantity - the amount to be transferred
1992      *
1993      * Calling conditions:
1994      *
1995      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1996      * transferred to `to`.
1997      * - When `from` is zero, `tokenId` has been minted for `to`.
1998      * - When `to` is zero, `tokenId` has been burned by `from`.
1999      * - `from` and `to` are never both zero.
2000      */
2001     function _afterTokenTransfers(
2002         address from,
2003         address to,
2004         uint256 startTokenId,
2005         uint256 quantity
2006     ) internal virtual {}
2007 }
2008 
2009 // File: @openzeppelin/contracts/access/Ownable.sol
2010 
2011 
2012 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2013 
2014 pragma solidity ^0.8.0;
2015 
2016 
2017 /**
2018  * @dev Contract module which provides a basic access control mechanism, where
2019  * there is an account (an owner) that can be granted exclusive access to
2020  * specific functions.
2021  *
2022  * By default, the owner account will be the one that deploys the contract. This
2023  * can later be changed with {transferOwnership}.
2024  *
2025  * This module is used through inheritance. It will make available the modifier
2026  * `onlyOwner`, which can be applied to your functions to restrict their use to
2027  * the owner.
2028  */
2029 abstract contract Ownable is Context {
2030     address private _owner;
2031 
2032     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2033 
2034     /**
2035      * @dev Initializes the contract setting the deployer as the initial owner.
2036      */
2037     constructor() {
2038         _transferOwnership(_msgSender());
2039     }
2040 
2041     /**
2042      * @dev Returns the address of the current owner.
2043      */
2044     function owner() public view virtual returns (address) {
2045         return _owner;
2046     }
2047 
2048     /**
2049      * @dev Throws if called by any account other than the owner.
2050      */
2051     modifier onlyOwner() {
2052         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2053         _;
2054     }
2055 
2056     /**
2057      * @dev Leaves the contract without owner. It will not be possible to call
2058      * `onlyOwner` functions anymore. Can only be called by the current owner.
2059      *
2060      * NOTE: Renouncing ownership will leave the contract without an owner,
2061      * thereby removing any functionality that is only available to the owner.
2062      */
2063     function renounceOwnership() public virtual onlyOwner {
2064         _transferOwnership(address(0));
2065     }
2066 
2067     /**
2068      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2069      * Can only be called by the current owner.
2070      */
2071     function transferOwnership(address newOwner) public virtual onlyOwner {
2072         require(newOwner != address(0), "Ownable: new owner is the zero address");
2073         _transferOwnership(newOwner);
2074     }
2075 
2076     /**
2077      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2078      * Internal function without access restriction.
2079      */
2080     function _transferOwnership(address newOwner) internal virtual {
2081         address oldOwner = _owner;
2082         _owner = newOwner;
2083         emit OwnershipTransferred(oldOwner, newOwner);
2084     }
2085 }
2086 
2087 // File: contracts/nft/HightableVIP.sol
2088 
2089 // contracts/HightableVIP.sol
2090 
2091 
2092 pragma solidity ^0.8.0;
2093 
2094 
2095 
2096 
2097 
2098 
2099 
2100 
2101 error TokenSalePhaseBoundaryAlreadySet();
2102 error ReachedMaxSupply();
2103 error TransactionExpired();
2104 error ExceedMaxAllowedMintAmount();
2105 error SignatureAlreadyUsed();
2106 error IncorrectSignature();
2107 error InsufficientPayments();
2108 error NotRevealer();
2109 error TokenIndexOutOfBounds();
2110 error RequestRaffleRandomnessNotAllowed();
2111 error RaffleRandomnessAlreadyRequested();
2112 error InvalidRaffleRegisterTime();
2113 error AlreadyRegistered();
2114 error InvalidPublicMintTime();
2115 error NotRegistered();
2116 error RefundNotAllowed();
2117 error NoRefundQuota();
2118 error UnableToRefundRafflePayment();
2119 error UnableToWithdrawFund();
2120 error RevealNotAllowed();
2121 error RequestRevealNotTokenOwner();
2122 error RevealAlreadyRequested();
2123 error MerkleTreeRootAlreadySet();
2124 error RandomizerAlreadySet();
2125 error MerkleTreeRootNotSet();
2126 error IncorrectRevealIndex();
2127 error TokenAlreadyRevealed();
2128 error MerkleTreeProofFailed();
2129 error IncorrectRevealManyLength();
2130 error CharacterLengthMismatch();
2131 error InvalidCharacterSlice();
2132 error WhitelistMintNotStarted();
2133 error WhitelistMintEnded();
2134 
2135 
2136 /// @title Hightable VIP NFT
2137 /// @author Teahouse Finance
2138 contract HightableVIP is ERC721A, Ownable, ReentrancyGuard, VRFConsumerBase {
2139     using ECDSA for bytes32;
2140 
2141     struct GlobalInfo {
2142         address whitelistSigner;
2143         address randomizer;
2144         address revealer;
2145         uint64 whitelistMintStartTime;
2146         uint64 whitelistMintEndTime;
2147         bool allowReveal;
2148     }
2149 
2150     struct RaffleInfo {
2151         uint64 registerStartTime;
2152         uint64 registerEndTime;
2153         uint32 numberOfBatch;
2154         uint32 numberOfRegistered;
2155         uint32 numberOfRefunded;
2156     }
2157 
2158     struct PublicMintInfo {
2159         uint64 publicMintStartTime;
2160         uint64 publicMintStepTime;
2161         uint64 unlimitMintStartTime;
2162         uint32 numberOfRaffleMinted;
2163     }
2164 
2165     struct AddressPublicMintInfo {
2166         bool raffleRegistered;
2167         bool raffleRefunded;
2168         bool raffleMinted;
2169     }
2170 
2171     struct TokenRevealInfo {
2172         bytes32 tokenBaseURIHash;
2173         uint64 index;
2174         bool revealRequested;
2175     }
2176 
2177     // Chainlink doc: https://docs.chain.link/docs/vrf-contracts/v1/ 
2178     bytes32 public vrfKeyHash;
2179     uint256 public vrfFee;
2180 
2181     GlobalInfo public globalInfo;
2182     uint256 public maxCollection;
2183     uint256 public price = 0.5566 ether;
2184     uint256 public tokenSalePhaseBoundary;
2185     bytes32 public hashMerkleRoot;
2186     string public unrevealURI;
2187     uint256[] public characterSlice;
2188 
2189     uint256 public raffleRandomness;
2190     uint256 public rafflePrice = 0.05566 ether;
2191     RaffleInfo public raffleInfo;
2192     PublicMintInfo public publicMintInfo;
2193     
2194     //mapping(bytes32 => bool) public signatureUsed;
2195     mapping(address => AddressPublicMintInfo) public addressPublicMintInfo;
2196     mapping(uint256 => TokenRevealInfo) public tokenRevealInfo; 
2197 
2198     event RaffleRegistered(address registeredAddress);
2199     event RaffleRandomnessRequested(bytes32 requestId);
2200     event RaffleRandomnessReceived(uint256 randomness);
2201     event RaffleRefunded(address refundedAddress);
2202     event RevealRequested(uint256 indexed tokenId);
2203     event Revealed(uint256 indexed tokenId);
2204 
2205 
2206     /// @param _name Name of the NFT
2207     /// @param _symbol Symbol of the NFT
2208     /// @param _maxCollection Maximum allowed number of tokens
2209     constructor(
2210         string memory _name,
2211         string memory _symbol,
2212         uint256 _maxCollection,          // total supply
2213         address _vrfCoordinator,
2214         address _linkToken,
2215         bytes32 _vrfKeyHash,
2216         uint256 _vrfFee
2217     ) ERC721A(_name, _symbol) VRFConsumerBase(_vrfCoordinator, _linkToken)
2218     {
2219         maxCollection = _maxCollection;
2220 
2221         vrfKeyHash = _vrfKeyHash;
2222         vrfFee = _vrfFee;
2223     }
2224 
2225 
2226     /// @notice Set VRF parameters
2227     /// @param _vrfKeyHash VRF Key hash
2228     /// @param _vrfFee VRF fee in Link
2229     function setVRFParameters(bytes32 _vrfKeyHash, uint256 _vrfFee) external onlyOwner {
2230         vrfKeyHash = _vrfKeyHash;
2231         vrfFee = _vrfFee;
2232     }
2233 
2234 
2235     /// @notice Set token minting price
2236     /// @param _newPrice New price in wei
2237     /// @dev Only owner can do this
2238     function setPrice(uint256 _newPrice) external onlyOwner {
2239         price = _newPrice;
2240     }
2241 
2242 
2243     /// @notice Set whitelist minting signer address
2244     /// @param _newWhitelistSigner New signer address
2245     /// @dev Only owner can do this
2246     function setWhitelistSigner(address _newWhitelistSigner) external onlyOwner {
2247         globalInfo.whitelistSigner = _newWhitelistSigner;
2248     }
2249 
2250 
2251     /// @notice set whitelist mint start and end time
2252     /// @param _whitelistMintStartTime whitelist mint start time
2253     /// @param _whitelistMintEndTime whitelist mint end time
2254     /// @dev Only owner can do this
2255     function setWhitelistMintTime(uint64 _whitelistMintStartTime, uint64 _whitelistMintEndTime) external onlyOwner {
2256         globalInfo.whitelistMintStartTime = _whitelistMintStartTime;
2257         globalInfo.whitelistMintEndTime = _whitelistMintEndTime;
2258     }
2259 
2260 
2261     /// @notice set token sale boundary
2262     /// @param _tokenId boundary tokenId
2263     /// @dev Only owner can do this
2264     function setTokenSalePhaseBoundary(uint256 _tokenId) external onlyOwner {
2265         if (tokenSalePhaseBoundary != 0) revert TokenSalePhaseBoundaryAlreadySet();
2266 
2267         tokenSalePhaseBoundary = _tokenId;
2268     }
2269 
2270 
2271     /// @notice Returns token's sale phase
2272     /// @param _tokenId TokenId to reveal
2273     /// @return sale phase
2274     function getTokenSalePhase(uint256 _tokenId) public view returns (uint256) {
2275         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
2276 
2277         if (_tokenId <= tokenSalePhaseBoundary) {
2278             return 1;
2279         }
2280 
2281         return 2;
2282     }
2283 
2284 
2285     /// @notice Set revealer address
2286     /// @param _newRevealer New revealer address
2287     /// @dev Only owner can do this
2288     function setRevealer(address _newRevealer) external onlyOwner {
2289         globalInfo.revealer = _newRevealer;
2290     }
2291 
2292 
2293     /// @notice Set token URI for unrevealed tokens
2294     /// @param _newURI New token URI
2295     /// @dev Only owner can do this
2296     function setUnrevealURI(string calldata _newURI) external onlyOwner {
2297         unrevealURI = _newURI;
2298     }
2299 
2300 
2301     /// @notice set Merkle tree root for reveal verfication
2302     /// @param _hashMerkleRoot Merkle tree root
2303     /// @dev Only owner can do this
2304     function setMerkleRoot(bytes32 _hashMerkleRoot) external onlyOwner {
2305         if (hashMerkleRoot != bytes32(0)) revert MerkleTreeRootAlreadySet();
2306 
2307         hashMerkleRoot = _hashMerkleRoot;
2308     }
2309 
2310 
2311     /// @notice set randomizer address in Polygon before allow reveal
2312     /// @param _randomizer randomizer address in Polygon
2313     /// @dev randomizer can be only set once
2314     /// @dev Only owner can do this
2315     function setRandomizer(address _randomizer) external onlyOwner {
2316         if (globalInfo.randomizer != address(0)) revert RandomizerAlreadySet();
2317 
2318         globalInfo.randomizer = _randomizer;
2319     }
2320 
2321 
2322     /// @notice Set whether to allow reveal requests
2323     /// @param _allowReveal true to allow reveal requests, false to disallow
2324     /// @dev Only owner can do this
2325     function setAllowReveal(bool _allowReveal) external onlyOwner {
2326         globalInfo.allowReveal = _allowReveal;
2327     }
2328 
2329 
2330     /// @notice set raffle parameters
2331     /// @param _raffleRegisterStartTime raffle register start time
2332     /// @param _raffleRegisterEndTime raffle register end time
2333     /// @param _numberOfRaffleBatch number of batch in public minting
2334     /// @dev Only owner can do this
2335     function setRaffle(uint64 _raffleRegisterStartTime, uint64 _raffleRegisterEndTime, uint32 _numberOfRaffleBatch) external onlyOwner {
2336         RaffleInfo storage raffleParameters = raffleInfo;
2337 
2338         raffleParameters.registerStartTime = _raffleRegisterStartTime; 
2339         raffleParameters.registerEndTime = _raffleRegisterEndTime;
2340         raffleParameters.numberOfBatch = _numberOfRaffleBatch;
2341     }
2342 
2343 
2344     /// @notice set public mint pramameters
2345     /// @param _publicMintStartTime public mint start time
2346     /// @param _publicMintStepTime public mint batch step time
2347     /// @param _unlimitMintStartTime unlimited public mint start time
2348     /// @dev Only owner can do this
2349     function setPublicMintTimeSetting(uint64 _publicMintStartTime, uint64 _publicMintStepTime, uint64 _unlimitMintStartTime) external onlyOwner {
2350         PublicMintInfo storage publicMintParameters = publicMintInfo;
2351 
2352         publicMintParameters.publicMintStartTime = _publicMintStartTime;
2353         publicMintParameters.publicMintStepTime = _publicMintStepTime;
2354         publicMintParameters.unlimitMintStartTime = _unlimitMintStartTime;
2355     }
2356 
2357 
2358     function isAuthorized(address _sender, uint32 _allowAmount, uint64 _expireTime, bytes memory _signature) private view returns (bool) {
2359         bytes32 hashMsg = keccak256(abi.encodePacked(_sender, _allowAmount, _expireTime));
2360         bytes32 ethHashMessage = hashMsg.toEthSignedMessageHash();
2361 
2362         return ethHashMessage.recover(_signature) == globalInfo.whitelistSigner;
2363     }
2364 
2365 
2366     /// @notice Whitelist minting
2367     /// @param _amount Number of tokens to whitelistMint
2368     /// @param _allowAmount Allowed amount of tokens
2369     /// @param _expireTime Expiry time
2370     /// @param _signature The signature signed by the signer address
2371     /// @dev The caller must obtain a valid signature signed by the signer address from the server
2372     /// @dev and pays for the correct price to whitelistMint
2373     /// @dev The resulting token is sent to the caller's address
2374     function whitelistMint(uint32 _amount, uint32 _allowAmount, uint64 _expireTime, bytes calldata _signature) external payable {
2375         if (totalSupply() + _amount > maxCollection) revert ReachedMaxSupply();
2376         if (block.timestamp < globalInfo.whitelistMintStartTime) revert WhitelistMintNotStarted();
2377         if (block.timestamp > globalInfo.whitelistMintEndTime) revert WhitelistMintEnded();
2378         if (block.timestamp > _expireTime) revert TransactionExpired();
2379         if (_numberMinted(msg.sender) + _amount > _allowAmount) revert ExceedMaxAllowedMintAmount();
2380 
2381         // bytes32 sigHash = keccak256(abi.encodePacked(_signature));
2382         // if (signatureUsed[sigHash]) revert SignatureAlreadyUsed();
2383         // signatureUsed[sigHash] = true;
2384 
2385         if (!isAuthorized(msg.sender, _allowAmount, _expireTime, _signature)) revert IncorrectSignature();
2386 
2387         uint256 finalPrice = price * _amount;
2388         if (msg.value < finalPrice) revert InsufficientPayments();
2389         
2390         _safeMint(msg.sender, _amount);
2391     }
2392 
2393 
2394     /// @notice Developer minting
2395     /// @param _amount Number of tokens to mint
2396     /// @param _to Address to send the tokens to
2397     /// @dev Only owner can do this
2398     function devMint(uint256 _amount, address _to) external onlyOwner {
2399         if (totalSupply() + _amount > maxCollection) revert ReachedMaxSupply();
2400 
2401         _safeMint(_to, _amount);
2402     }
2403 
2404 
2405     /// @notice Public minting
2406     /// @dev The caller must pay for the correct price to publicMint
2407     /// @dev After unlimitMintStartTime, anyone can mint without any constraints
2408     /// @dev and pays for the correct price to publicMint
2409     /// @dev The resulting token is sent to the caller's address
2410     function publicMint() external payable {
2411         if (totalSupply() == maxCollection) revert ReachedMaxSupply();
2412         if (msg.value < price) revert InsufficientPayments();
2413 
2414         PublicMintInfo storage publicMintParameters = publicMintInfo;
2415         if (publicMintParameters.unlimitMintStartTime > 0 && block.timestamp >= publicMintParameters.unlimitMintStartTime) {
2416             _safeMint(msg.sender, 1);
2417 
2418             return;
2419         }
2420 
2421         AddressPublicMintInfo storage accountInfo = addressPublicMintInfo[msg.sender];
2422         if (!accountInfo.raffleRegistered) revert NotRegistered();
2423         if (accountInfo.raffleMinted) revert ExceedMaxAllowedMintAmount();
2424 
2425         uint256 startTime;
2426         (, startTime) = getAddressBatchInfo(msg.sender);
2427         
2428         if (block.timestamp < startTime) revert InvalidPublicMintTime();
2429 
2430         _safeMint(msg.sender, 1);
2431         publicMintParameters.numberOfRaffleMinted++;
2432         accountInfo.raffleMinted = true;
2433     }
2434 
2435 
2436     /// @notice pay raffle price to register the raffle
2437     /// @dev only allow to register in time internal raffleRegisterStartTime to raffleRegisterEndTime
2438     /// @dev must pay enough ether to register the raffle
2439     /// @dev cannot register for more than twice
2440     function registerRaffle() external payable {
2441         RaffleInfo storage raffleParameters = raffleInfo;
2442         if (block.timestamp < raffleParameters.registerStartTime || raffleParameters.registerEndTime < block.timestamp) revert InvalidRaffleRegisterTime();
2443         if (msg.value < rafflePrice) revert InsufficientPayments();
2444 
2445         AddressPublicMintInfo storage accountInfo = addressPublicMintInfo[msg.sender];
2446         if (accountInfo.raffleRegistered) revert AlreadyRegistered();
2447 
2448         accountInfo.raffleRegistered = true;
2449         raffleParameters.numberOfRegistered++;
2450 
2451         emit RaffleRegistered(msg.sender);
2452     }
2453 
2454 
2455     /// @notice request for raffle randomness
2456     /// @dev can only request after raffle register end
2457     /// @dev Only owner can do this
2458     function requestRaffleRandomness() external onlyOwner nonReentrant {
2459         RaffleInfo storage raffleParameters = raffleInfo;
2460         if (block.timestamp < raffleParameters.registerEndTime) revert RequestRaffleRandomnessNotAllowed();
2461         if (raffleRandomness != 0) revert RaffleRandomnessAlreadyRequested();
2462 
2463         bytes32 requestId = requestRandomness(vrfKeyHash, vrfFee);
2464 
2465         emit RaffleRandomnessRequested(requestId);
2466     }
2467 
2468 
2469     function fulfillRandomness(bytes32 /*requestId*/, uint256 randomness) internal override {
2470         raffleRandomness = randomness;
2471 
2472         emit RaffleRandomnessReceived(randomness);
2473     }
2474 
2475 
2476     /// @notice Returns nth batch and start time in public sale of the address
2477     /// @param _address The query address
2478     /// @return nth batch of the address
2479     /// @return public mint start time of the address
2480     function getAddressBatchInfo(address _address) public view returns (uint256, uint256) {
2481         RaffleInfo storage raffleParameters = raffleInfo;
2482         PublicMintInfo storage publicMintParameters = publicMintInfo;
2483 
2484         uint256 order = uint256(bytes32(raffleRandomness) ^ bytes32(uint256(uint160(_address)))) % raffleParameters.numberOfBatch;
2485         uint256 time = publicMintParameters.publicMintStartTime + publicMintParameters.publicMintStepTime * order;
2486 
2487         return (order + 1, time);
2488     }
2489 
2490 
2491     /// @notice Refund raffle payment
2492     /// @dev Refund is allowed after sold out
2493     /// @dev If an address have minted, it cannot refund
2494     /// @dev If the batch of an address is smaller than the last batch, it cannot refund
2495     /// @dev Only payer can do this
2496     function refundRafflePayment() external nonReentrant {
2497         if (totalSupply() != maxCollection) revert RefundNotAllowed();
2498         
2499         AddressPublicMintInfo storage accountInfo = addressPublicMintInfo[msg.sender];
2500         if (!accountInfo.raffleRegistered || accountInfo.raffleMinted || accountInfo.raffleRefunded) revert NoRefundQuota();
2501 
2502         accountInfo.raffleRefunded = true;
2503         raffleInfo.numberOfRefunded++;
2504         (bool success, ) = payable(msg.sender).call{value: rafflePrice}("");
2505         if (!success) revert UnableToRefundRafflePayment();
2506 
2507         emit RaffleRefunded(msg.sender);
2508     }
2509 
2510 
2511     /// @notice Request to reveal token
2512     /// @param _tokenId TokenId to reveal
2513     /// @dev Only token owner can do this
2514     /// @dev The backend server will scan for tokens requested to be revealed and call "reveal" function to reveal the token
2515     function requestReveal(uint256 _tokenId) external {
2516         if (!globalInfo.allowReveal) revert RevealNotAllowed();
2517         if (ownerOf(_tokenId) != msg.sender) revert RequestRevealNotTokenOwner();
2518         if (tokenRevealInfo[_tokenId].revealRequested) revert RevealAlreadyRequested();
2519         if (hashMerkleRoot == bytes32(0)) revert MerkleTreeRootNotSet();
2520 
2521         tokenRevealInfo[_tokenId].revealRequested = true;
2522         
2523         emit RevealRequested(_tokenId);
2524     }
2525 
2526 
2527     /// @notice Reveal the token
2528     /// @param _tokenId TokenId to reveal
2529     /// @param _tokenBaseURIHash IPFS hash of the metadata for this token
2530     /// @param _index index of metadata for this token
2531     /// @param _salt salt of tokenBaseURIHash for this token
2532     /// @dev Only revealer can do this
2533     function reveal(uint256 _tokenId, bytes32 _tokenBaseURIHash, uint64 _index, bytes32 _salt, bytes32[] memory _proof) public onlyRevealer {
2534         if (hashMerkleRoot == bytes32(0)) revert MerkleTreeRootNotSet();
2535         if (!tokenRevealInfo[_tokenId].revealRequested) revert IncorrectRevealIndex();
2536 
2537         TokenRevealInfo storage tokenInfo = tokenRevealInfo[_tokenId];
2538         if (tokenInfo.tokenBaseURIHash != 0) revert TokenAlreadyRevealed();
2539 
2540         bytes32 hash = keccak256(abi.encodePacked(_tokenBaseURIHash, uint256(_index), _salt));
2541         if (!MerkleProof.verify(_proof, hashMerkleRoot, hash)) revert MerkleTreeProofFailed();
2542 
2543         tokenInfo.tokenBaseURIHash = _tokenBaseURIHash;
2544         tokenInfo.index = _index;
2545 
2546         emit Revealed(_tokenId);
2547     }
2548 
2549 
2550     /// @notice Reveal batch tokens
2551     /// @param _tokenIds TokenIds to reveal
2552     /// @param _tokenBaseURIHashes IPFS hashes of the metadata for the tokens
2553     /// @param _indexes indexes of metadata for the tokens
2554     /// @param _salts salts of tokenBaseURIHash for the tokens
2555     function revealMany(uint256[] memory _tokenIds, bytes32[] memory _tokenBaseURIHashes, uint64[] memory _indexes, bytes32[] memory _salts, bytes32[][] memory _prooves) external {
2556         if (hashMerkleRoot == bytes32(0)) revert MerkleTreeRootNotSet();
2557         if (_tokenIds.length != _tokenBaseURIHashes.length) revert IncorrectRevealManyLength();
2558         if (_tokenIds.length != _indexes.length) revert IncorrectRevealManyLength();
2559         if (_tokenIds.length != _salts.length) revert IncorrectRevealManyLength();
2560         if (_tokenIds.length != _prooves.length) revert IncorrectRevealManyLength();
2561 
2562         uint256 i;
2563         uint256 length = _tokenIds.length;
2564         for (i = 0; i < length; i++) {
2565             TokenRevealInfo storage tokenInfo = tokenRevealInfo[_tokenIds[i]];
2566             if (tokenInfo.tokenBaseURIHash == 0) {
2567                 // only calls reveal for those not revealed yet
2568                 // this is to prevent the case where one revealed token will cause the entire batch to revert
2569                 // we only check for "revealed" but not for other situation as the entire batch is supposed to have
2570                 // correct parameters
2571                 reveal(_tokenIds[i], _tokenBaseURIHashes[i], _indexes[i], _salts[i], _prooves[i]);
2572             }
2573         }
2574     }
2575 
2576 
2577     /// @notice Returns token URI of a token
2578     /// @param _tokenId Token Id
2579     /// @return uri Token URI
2580     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory uri) {
2581 	    if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
2582         
2583         TokenRevealInfo storage tokenInfo = tokenRevealInfo[_tokenId];
2584         if (tokenInfo.tokenBaseURIHash == 0) {
2585             return unrevealURI;
2586         }
2587         else {
2588             bytes32 hash = tokenInfo.tokenBaseURIHash;
2589             return string(abi.encodePacked("ipfs://", IPFSConvert.cidv0FromBytes32(hash)));
2590         }
2591 	}
2592 
2593 
2594     /// @notice Returns the number of all minted tokens
2595     /// @return minted Number of all minted tokens
2596     function totalMinted() external view returns (uint256 minted) {
2597         return _totalMinted();
2598     }
2599 
2600 
2601     /// @notice Returns the number of all minted tokens from an address
2602     /// @param _minter Minter address
2603     /// @return minted Number of all minted tokens from the minter
2604     function numberMinted(address _minter) external view returns (uint256 minted) {
2605         return _numberMinted(_minter);
2606     }
2607 
2608 
2609     /// @notice Sets character slice
2610     /// @param _numberOfCharacter Number of character
2611     /// @param _characterSlice character slice
2612     /// @dev Only revealer can do this 
2613     function setCharacter(uint256 _numberOfCharacter, uint256[] memory _characterSlice) external onlyOwner {
2614         if (_numberOfCharacter != _characterSlice.length) revert CharacterLengthMismatch();
2615         if (_characterSlice[_characterSlice.length - 1] != maxCollection) revert InvalidCharacterSlice();
2616 
2617         characterSlice = _characterSlice;
2618     }
2619 
2620 
2621     /// @notice Returns character of a token
2622     /// @param _tokenId Token Id
2623     /// @return character Character of a token, starting from 1. Returns 0 if a token is not revealed yet.
2624     function tokenCharacter(uint256 _tokenId) public view returns (uint256) {
2625         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
2626 
2627         TokenRevealInfo storage tokenInfo = tokenRevealInfo[_tokenId];
2628         uint256 index = tokenInfo.index;
2629 
2630         if (index == 0) {
2631             return 0;
2632         }
2633 
2634         for (uint256 i = 0; i < characterSlice.length; i++) {
2635             if (characterSlice[i] >= index) {
2636                 return i + 1;
2637             }
2638         }
2639         
2640         // should not go here
2641         return 0;
2642     }
2643 
2644 
2645     /// @notice Returns all tokenIds owned by an address
2646     /// @param _addr The address
2647     /// @param _startId starting tokenId
2648     /// @param _endId ending tokenId (inclusive)
2649     /// @return tokenIds Array of all tokenIds owned by the address
2650     /// @return endTokenId ending tokenId
2651     function ownedTokens(address _addr, uint256 _startId, uint256 _endId) external view returns (uint256[] memory tokenIds, uint256 endTokenId) {
2652         if (_endId == 0) {
2653             _endId = _currentIndex - 1;
2654         }
2655 
2656         if (_startId < _startTokenId() || _endId >= _currentIndex) revert TokenIndexOutOfBounds();
2657 
2658         uint256 i;
2659         uint256 balance = balanceOf(_addr);
2660         if (balance == 0) {
2661             return (new uint256[](0), _endId + 1);
2662         }
2663 
2664         if (balance > 256) {
2665             balance = 256;
2666         }
2667 
2668         uint256[] memory results = new uint256[](balance);
2669         uint256 idx = 0;
2670         
2671         address owner = ownerOf(_startId);
2672         for (i = _startId; i <= _endId; i++) {
2673             if (_ownerships[i].addr != address(0)) {
2674                 owner = _ownerships[i].addr;
2675             }
2676 
2677             if (!_ownerships[i].burned && owner == _addr) {
2678                 results[idx] = i;
2679                 idx++;
2680 
2681                 if (idx == balance) {
2682                     if (balance == balanceOf(_addr)) {
2683                         return (results, _endId + 1);
2684                     }
2685                     else {
2686                         return (results, i + 1);
2687                     }
2688                 }
2689             }
2690         }
2691 
2692         uint256[] memory partialResults = new uint256[](idx);
2693         for (i = 0; i < idx; i++) {
2694             partialResults[i] = results[i];
2695         }        
2696 
2697         return (partialResults, _endId + 1);
2698     }
2699 
2700 
2701     /// @notice Returns all tokenIds that are requested to be revealed but not revealed
2702     /// @param _startId starting tokenId
2703     /// @param _endId ending tokenId (inclusive)
2704     /// @return tokenIds Array of tokenIds that are requested to be revealed but not revealed
2705     /// @return endTokenId ending tokenId
2706     function unrevealedTokens(uint256 _startId, uint256 _endId) external view returns (uint256[] memory, uint256) {
2707         if (_endId == 0) {
2708             _endId = _currentIndex - 1;
2709         }
2710 
2711         if (_startId < _startTokenId() || _endId >= _currentIndex) revert TokenIndexOutOfBounds();
2712 
2713         uint256 i;
2714         uint256[] memory results = new uint256[](256);
2715         uint256 idx = 0;
2716         
2717         for (i = _startId; i <= _endId; i++) {
2718             TokenRevealInfo storage tokenInfo = tokenRevealInfo[i];
2719             if (tokenInfo.revealRequested && tokenInfo.tokenBaseURIHash == 0) {
2720                 // reveal requested but not revealed
2721                 results[idx] = i;
2722                 idx++;
2723 
2724                 if (idx == 256) {
2725                     return (results, i + 1);
2726                 }
2727             }
2728         }
2729 
2730         uint256[] memory partialResults = new uint256[](idx);
2731         for (i = 0; i < idx; i++) {
2732             partialResults[i] = results[i];
2733         }
2734 
2735         return (partialResults, _endId + 1);
2736     }
2737 
2738 
2739     /// @notice Withdraw funds in the contract
2740     /// @param _to The address to send the funds to
2741     /// @dev value will be balance of contract - refund reserved value
2742     /// @dev Only owner can do this
2743     function withdraw(address payable _to) external payable onlyOwner nonReentrant {
2744         PublicMintInfo storage publicMintParameters = publicMintInfo;
2745         RaffleInfo storage raffleParameters = raffleInfo;
2746 
2747         uint256 value = address(this).balance - rafflePrice * (raffleParameters.numberOfRegistered - publicMintParameters.numberOfRaffleMinted - raffleParameters.numberOfRefunded);
2748         (bool success, ) = _to.call{value: value}("");
2749         if (!success) revert UnableToWithdrawFund();
2750 	}
2751 
2752 
2753     function _startTokenId() override internal view virtual returns (uint256) {
2754         // the starting token Id
2755         return 1;
2756     }
2757 
2758 
2759     modifier onlyRevealer {
2760         if(msg.sender != globalInfo.revealer) revert NotRevealer();
2761         _;
2762     }
2763 }