1 // SPDX-License-Identifier: BUSL-1.1
2 // File: contracts/IPFSConvert.sol
3 
4 // contracts/IPFSConvert.sol
5 
6 pragma solidity ^0.8.0;
7 
8 /// @title IPFSConvert
9 /// @author Teahouse Finance
10 library IPFSConvert {
11 
12     bytes constant private CODE_STRING = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
13     bytes constant private CIDV0HEAD = "\x00\x04\x28\x0b\x12\x17\x09\x28\x31\x00\x12\x04\x28\x20\x25\x25\x22\x31\x1b\x1d\x39\x29\x09\x26\x1b\x29\x0b\x02\x0a\x18\x25\x22\x24\x1b\x39\x2c\x1d\x39\x07\x06\x29\x25\x13\x15\x2c\x17";
14 
15     /**
16      * @dev This function converts an 256 bits hash value into IPFS CIDv0 hash string.
17      * @param _cidv0 256 bits hash value (not including the 0x12 0x20 signature)
18      * @return IPFS CIDv0 hash string (Qm...)
19      */
20     function cidv0FromBytes32(bytes32 _cidv0) public pure returns (string memory) {
21         unchecked {
22             // convert to base58
23             bytes memory result = new bytes(46);        // 46 is the longest possible base58 result from CIDv0
24             uint256 resultLen = 45;
25             uint256 number = uint256(_cidv0);
26             while(number > 0) {
27                 uint256 rem = number % 58;
28                 result[resultLen] = bytes1(uint8(rem));
29                 resultLen--;
30                 number = number / 58;
31             }
32 
33             // add 0x1220 in front of _cidv0
34             uint256 i;
35             for (i = 0; i < 46; i++) {
36                 uint8 r = uint8(result[45 - i]) + uint8(CIDV0HEAD[i]);
37                 if (r >= 58) {
38                     result[45 - i] = bytes1(r - 58);
39                     result[45 - i - 1] = bytes1(uint8(result[45 - i - 1]) + 1);
40                 }
41                 else {
42                     result[45 - i] = bytes1(r);
43                 }
44             }
45 
46             // convert to characters
47             for (i = 0; i < 46; i++) {
48                 result[i] = CODE_STRING[uint8(result[i])];
49             }
50 
51             return string(result);
52         }
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Address.sol
57 
58 
59 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
60 
61 pragma solidity ^0.8.1;
62 
63 /**
64  * @dev Collection of functions related to the address type
65  */
66 library Address {
67     /**
68      * @dev Returns true if `account` is a contract.
69      *
70      * [IMPORTANT]
71      * ====
72      * It is unsafe to assume that an address for which this function returns
73      * false is an externally-owned account (EOA) and not a contract.
74      *
75      * Among others, `isContract` will return false for the following
76      * types of addresses:
77      *
78      *  - an externally-owned account
79      *  - a contract in construction
80      *  - an address where a contract will be created
81      *  - an address where a contract lived, but was destroyed
82      * ====
83      *
84      * [IMPORTANT]
85      * ====
86      * You shouldn't rely on `isContract` to protect against flash loan attacks!
87      *
88      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
89      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
90      * constructor.
91      * ====
92      */
93     function isContract(address account) internal view returns (bool) {
94         // This method relies on extcodesize/address.code.length, which returns 0
95         // for contracts in construction, since the code is only stored at the end
96         // of the constructor execution.
97 
98         return account.code.length > 0;
99     }
100 
101     /**
102      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
103      * `recipient`, forwarding all available gas and reverting on errors.
104      *
105      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
106      * of certain opcodes, possibly making contracts go over the 2300 gas limit
107      * imposed by `transfer`, making them unable to receive funds via
108      * `transfer`. {sendValue} removes this limitation.
109      *
110      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
111      *
112      * IMPORTANT: because control is transferred to `recipient`, care must be
113      * taken to not create reentrancy vulnerabilities. Consider using
114      * {ReentrancyGuard} or the
115      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
116      */
117     function sendValue(address payable recipient, uint256 amount) internal {
118         require(address(this).balance >= amount, "Address: insufficient balance");
119 
120         (bool success, ) = recipient.call{value: amount}("");
121         require(success, "Address: unable to send value, recipient may have reverted");
122     }
123 
124     /**
125      * @dev Performs a Solidity function call using a low level `call`. A
126      * plain `call` is an unsafe replacement for a function call: use this
127      * function instead.
128      *
129      * If `target` reverts with a revert reason, it is bubbled up by this
130      * function (like regular Solidity function calls).
131      *
132      * Returns the raw returned data. To convert to the expected return value,
133      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
134      *
135      * Requirements:
136      *
137      * - `target` must be a contract.
138      * - calling `target` with `data` must not revert.
139      *
140      * _Available since v3.1._
141      */
142     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
143         return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
148      * `errorMessage` as a fallback revert reason when `target` reverts.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal returns (bytes memory) {
157         return functionCallWithValue(target, data, 0, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
162      * but also transferring `value` wei to `target`.
163      *
164      * Requirements:
165      *
166      * - the calling contract must have an ETH balance of at least `value`.
167      * - the called Solidity function must be `payable`.
168      *
169      * _Available since v3.1._
170      */
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
181      * with `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(address(this).balance >= value, "Address: insufficient balance for call");
192         require(isContract(target), "Address: call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.call{value: value}(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but performing a static call.
201      *
202      * _Available since v3.3._
203      */
204     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
205         return functionStaticCall(target, data, "Address: low-level static call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal view returns (bytes memory) {
219         require(isContract(target), "Address: static call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.staticcall(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a delegate call.
228      *
229      * _Available since v3.4._
230      */
231     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(isContract(target), "Address: delegate call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.delegatecall(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
254      * revert reason using the provided one.
255      *
256      * _Available since v4.3._
257      */
258     function verifyCallResult(
259         bool success,
260         bytes memory returndata,
261         string memory errorMessage
262     ) internal pure returns (bytes memory) {
263         if (success) {
264             return returndata;
265         } else {
266             // Look for revert reason and bubble it up if present
267             if (returndata.length > 0) {
268                 // The easiest way to bubble the revert reason is using memory via assembly
269 
270                 assembly {
271                     let returndata_size := mload(returndata)
272                     revert(add(32, returndata), returndata_size)
273                 }
274             } else {
275                 revert(errorMessage);
276             }
277         }
278     }
279 }
280 
281 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
282 
283 
284 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @title ERC721 token receiver interface
290  * @dev Interface for any contract that wants to support safeTransfers
291  * from ERC721 asset contracts.
292  */
293 interface IERC721Receiver {
294     /**
295      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
296      * by `operator` from `from`, this function is called.
297      *
298      * It must return its Solidity selector to confirm the token transfer.
299      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
300      *
301      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
302      */
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
312 
313 
314 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Interface of the ERC165 standard, as defined in the
320  * https://eips.ethereum.org/EIPS/eip-165[EIP].
321  *
322  * Implementers can declare support of contract interfaces, which can then be
323  * queried by others ({ERC165Checker}).
324  *
325  * For an implementation, see {ERC165}.
326  */
327 interface IERC165 {
328     /**
329      * @dev Returns true if this contract implements the interface defined by
330      * `interfaceId`. See the corresponding
331      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
332      * to learn more about how these ids are created.
333      *
334      * This function call must use less than 30 000 gas.
335      */
336     function supportsInterface(bytes4 interfaceId) external view returns (bool);
337 }
338 
339 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 
347 /**
348  * @dev Implementation of the {IERC165} interface.
349  *
350  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
351  * for the additional interface id that will be supported. For example:
352  *
353  * ```solidity
354  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
355  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
356  * }
357  * ```
358  *
359  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
360  */
361 abstract contract ERC165 is IERC165 {
362     /**
363      * @dev See {IERC165-supportsInterface}.
364      */
365     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366         return interfaceId == type(IERC165).interfaceId;
367     }
368 }
369 
370 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
371 
372 
373 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Required interface of an ERC721 compliant contract.
380  */
381 interface IERC721 is IERC165 {
382     /**
383      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
389      */
390     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
394      */
395     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
396 
397     /**
398      * @dev Returns the number of tokens in ``owner``'s account.
399      */
400     function balanceOf(address owner) external view returns (uint256 balance);
401 
402     /**
403      * @dev Returns the owner of the `tokenId` token.
404      *
405      * Requirements:
406      *
407      * - `tokenId` must exist.
408      */
409     function ownerOf(uint256 tokenId) external view returns (address owner);
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId,
428         bytes calldata data
429     ) external;
430 
431     /**
432      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
433      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must exist and be owned by `from`.
440      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
442      *
443      * Emits a {Transfer} event.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) external;
450 
451     /**
452      * @dev Transfers `tokenId` token from `from` to `to`.
453      *
454      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
473      * The approval is cleared when the token is transferred.
474      *
475      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
476      *
477      * Requirements:
478      *
479      * - The caller must own the token or be an approved operator.
480      * - `tokenId` must exist.
481      *
482      * Emits an {Approval} event.
483      */
484     function approve(address to, uint256 tokenId) external;
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns the account approved for `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function getApproved(uint256 tokenId) external view returns (address operator);
506 
507     /**
508      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
509      *
510      * See {setApprovalForAll}
511      */
512     function isApprovedForAll(address owner, address operator) external view returns (bool);
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
525  * @dev See https://eips.ethereum.org/EIPS/eip-721
526  */
527 interface IERC721Enumerable is IERC721 {
528     /**
529      * @dev Returns the total amount of tokens stored by the contract.
530      */
531     function totalSupply() external view returns (uint256);
532 
533     /**
534      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
535      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
536      */
537     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
538 
539     /**
540      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
541      * Use along with {totalSupply} to enumerate all tokens.
542      */
543     function tokenByIndex(uint256 index) external view returns (uint256);
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
556  * @dev See https://eips.ethereum.org/EIPS/eip-721
557  */
558 interface IERC721Metadata is IERC721 {
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() external view returns (string memory);
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() external view returns (string memory);
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) external view returns (string memory);
573 }
574 
575 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @dev These functions deal with verification of Merkle Trees proofs.
584  *
585  * The proofs can be generated using the JavaScript library
586  * https://github.com/miguelmota/merkletreejs[merkletreejs].
587  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
588  *
589  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
590  *
591  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
592  * hashing, or use a hash function other than keccak256 for hashing leaves.
593  * This is because the concatenation of a sorted pair of internal nodes in
594  * the merkle tree could be reinterpreted as a leaf value.
595  */
596 library MerkleProof {
597     /**
598      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
599      * defined by `root`. For this, a `proof` must be provided, containing
600      * sibling hashes on the branch from the leaf to the root of the tree. Each
601      * pair of leaves and each pair of pre-images are assumed to be sorted.
602      */
603     function verify(
604         bytes32[] memory proof,
605         bytes32 root,
606         bytes32 leaf
607     ) internal pure returns (bool) {
608         return processProof(proof, leaf) == root;
609     }
610 
611     /**
612      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
613      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
614      * hash matches the root of the tree. When processing the proof, the pairs
615      * of leafs & pre-images are assumed to be sorted.
616      *
617      * _Available since v4.4._
618      */
619     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
620         bytes32 computedHash = leaf;
621         for (uint256 i = 0; i < proof.length; i++) {
622             bytes32 proofElement = proof[i];
623             if (computedHash <= proofElement) {
624                 // Hash(current computed hash + current element of the proof)
625                 computedHash = _efficientHash(computedHash, proofElement);
626             } else {
627                 // Hash(current element of the proof + current computed hash)
628                 computedHash = _efficientHash(proofElement, computedHash);
629             }
630         }
631         return computedHash;
632     }
633 
634     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
635         assembly {
636             mstore(0x00, a)
637             mstore(0x20, b)
638             value := keccak256(0x00, 0x40)
639         }
640     }
641 }
642 
643 // File: @chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol
644 
645 
646 pragma solidity ^0.8.0;
647 
648 /** ****************************************************************************
649  * @notice Interface for contracts using VRF randomness
650  * *****************************************************************************
651  * @dev PURPOSE
652  *
653  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
654  * @dev to Vera the verifier in such a way that Vera can be sure he's not
655  * @dev making his output up to suit himself. Reggie provides Vera a public key
656  * @dev to which he knows the secret key. Each time Vera provides a seed to
657  * @dev Reggie, he gives back a value which is computed completely
658  * @dev deterministically from the seed and the secret key.
659  *
660  * @dev Reggie provides a proof by which Vera can verify that the output was
661  * @dev correctly computed once Reggie tells it to her, but without that proof,
662  * @dev the output is indistinguishable to her from a uniform random sample
663  * @dev from the output space.
664  *
665  * @dev The purpose of this contract is to make it easy for unrelated contracts
666  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
667  * @dev simple access to a verifiable source of randomness. It ensures 2 things:
668  * @dev 1. The fulfillment came from the VRFCoordinator
669  * @dev 2. The consumer contract implements fulfillRandomWords.
670  * *****************************************************************************
671  * @dev USAGE
672  *
673  * @dev Calling contracts must inherit from VRFConsumerBase, and can
674  * @dev initialize VRFConsumerBase's attributes in their constructor as
675  * @dev shown:
676  *
677  * @dev   contract VRFConsumer {
678  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
679  * @dev       VRFConsumerBase(_vrfCoordinator) public {
680  * @dev         <initialization with other arguments goes here>
681  * @dev       }
682  * @dev   }
683  *
684  * @dev The oracle will have given you an ID for the VRF keypair they have
685  * @dev committed to (let's call it keyHash). Create subscription, fund it
686  * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
687  * @dev subscription management functions).
688  * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
689  * @dev callbackGasLimit, numWords),
690  * @dev see (VRFCoordinatorInterface for a description of the arguments).
691  *
692  * @dev Once the VRFCoordinator has received and validated the oracle's response
693  * @dev to your request, it will call your contract's fulfillRandomWords method.
694  *
695  * @dev The randomness argument to fulfillRandomWords is a set of random words
696  * @dev generated from your requestId and the blockHash of the request.
697  *
698  * @dev If your contract could have concurrent requests open, you can use the
699  * @dev requestId returned from requestRandomWords to track which response is associated
700  * @dev with which randomness request.
701  * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
702  * @dev if your contract could have multiple requests in flight simultaneously.
703  *
704  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
705  * @dev differ.
706  *
707  * *****************************************************************************
708  * @dev SECURITY CONSIDERATIONS
709  *
710  * @dev A method with the ability to call your fulfillRandomness method directly
711  * @dev could spoof a VRF response with any random value, so it's critical that
712  * @dev it cannot be directly called by anything other than this base contract
713  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
714  *
715  * @dev For your users to trust that your contract's random behavior is free
716  * @dev from malicious interference, it's best if you can write it so that all
717  * @dev behaviors implied by a VRF response are executed *during* your
718  * @dev fulfillRandomness method. If your contract must store the response (or
719  * @dev anything derived from it) and use it later, you must ensure that any
720  * @dev user-significant behavior which depends on that stored value cannot be
721  * @dev manipulated by a subsequent VRF request.
722  *
723  * @dev Similarly, both miners and the VRF oracle itself have some influence
724  * @dev over the order in which VRF responses appear on the blockchain, so if
725  * @dev your contract could have multiple VRF requests in flight simultaneously,
726  * @dev you must ensure that the order in which the VRF responses arrive cannot
727  * @dev be used to manipulate your contract's user-significant behavior.
728  *
729  * @dev Since the block hash of the block which contains the requestRandomness
730  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
731  * @dev miner could, in principle, fork the blockchain to evict the block
732  * @dev containing the request, forcing the request to be included in a
733  * @dev different block with a different hash, and therefore a different input
734  * @dev to the VRF. However, such an attack would incur a substantial economic
735  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
736  * @dev until it calls responds to a request. It is for this reason that
737  * @dev that you can signal to an oracle you'd like them to wait longer before
738  * @dev responding to the request (however this is not enforced in the contract
739  * @dev and so remains effective only in the case of unmodified oracle software).
740  */
741 abstract contract VRFConsumerBaseV2 {
742   error OnlyCoordinatorCanFulfill(address have, address want);
743   address private immutable vrfCoordinator;
744 
745   /**
746    * @param _vrfCoordinator address of VRFCoordinator contract
747    */
748   constructor(address _vrfCoordinator) {
749     vrfCoordinator = _vrfCoordinator;
750   }
751 
752   /**
753    * @notice fulfillRandomness handles the VRF response. Your contract must
754    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
755    * @notice principles to keep in mind when implementing your fulfillRandomness
756    * @notice method.
757    *
758    * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
759    * @dev signature, and will call it once it has verified the proof
760    * @dev associated with the randomness. (It is triggered via a call to
761    * @dev rawFulfillRandomness, below.)
762    *
763    * @param requestId The Id initially returned by requestRandomness
764    * @param randomWords the VRF output expanded to the requested number of words
765    */
766   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
767 
768   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
769   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
770   // the origin of the call
771   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
772     if (msg.sender != vrfCoordinator) {
773       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
774     }
775     fulfillRandomWords(requestId, randomWords);
776   }
777 }
778 
779 // File: @chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol
780 
781 
782 pragma solidity ^0.8.0;
783 
784 interface VRFCoordinatorV2Interface {
785   /**
786    * @notice Get configuration relevant for making requests
787    * @return minimumRequestConfirmations global min for request confirmations
788    * @return maxGasLimit global max for request gas limit
789    * @return s_provingKeyHashes list of registered key hashes
790    */
791   function getRequestConfig()
792     external
793     view
794     returns (
795       uint16,
796       uint32,
797       bytes32[] memory
798     );
799 
800   /**
801    * @notice Request a set of random words.
802    * @param keyHash - Corresponds to a particular oracle job which uses
803    * that key for generating the VRF proof. Different keyHash's have different gas price
804    * ceilings, so you can select a specific one to bound your maximum per request cost.
805    * @param subId  - The ID of the VRF subscription. Must be funded
806    * with the minimum subscription balance required for the selected keyHash.
807    * @param minimumRequestConfirmations - How many blocks you'd like the
808    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
809    * for why you may want to request more. The acceptable range is
810    * [minimumRequestBlockConfirmations, 200].
811    * @param callbackGasLimit - How much gas you'd like to receive in your
812    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
813    * may be slightly less than this amount because of gas used calling the function
814    * (argument decoding etc.), so you may need to request slightly more than you expect
815    * to have inside fulfillRandomWords. The acceptable range is
816    * [0, maxGasLimit]
817    * @param numWords - The number of uint256 random values you'd like to receive
818    * in your fulfillRandomWords callback. Note these numbers are expanded in a
819    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
820    * @return requestId - A unique identifier of the request. Can be used to match
821    * a request to a response in fulfillRandomWords.
822    */
823   function requestRandomWords(
824     bytes32 keyHash,
825     uint64 subId,
826     uint16 minimumRequestConfirmations,
827     uint32 callbackGasLimit,
828     uint32 numWords
829   ) external returns (uint256 requestId);
830 
831   /**
832    * @notice Create a VRF subscription.
833    * @return subId - A unique subscription id.
834    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
835    * @dev Note to fund the subscription, use transferAndCall. For example
836    * @dev  LINKTOKEN.transferAndCall(
837    * @dev    address(COORDINATOR),
838    * @dev    amount,
839    * @dev    abi.encode(subId));
840    */
841   function createSubscription() external returns (uint64 subId);
842 
843   /**
844    * @notice Get a VRF subscription.
845    * @param subId - ID of the subscription
846    * @return balance - LINK balance of the subscription in juels.
847    * @return reqCount - number of requests for this subscription, determines fee tier.
848    * @return owner - owner of the subscription.
849    * @return consumers - list of consumer address which are able to use this subscription.
850    */
851   function getSubscription(uint64 subId)
852     external
853     view
854     returns (
855       uint96 balance,
856       uint64 reqCount,
857       address owner,
858       address[] memory consumers
859     );
860 
861   /**
862    * @notice Request subscription owner transfer.
863    * @param subId - ID of the subscription
864    * @param newOwner - proposed new owner of the subscription
865    */
866   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
867 
868   /**
869    * @notice Request subscription owner transfer.
870    * @param subId - ID of the subscription
871    * @dev will revert if original owner of subId has
872    * not requested that msg.sender become the new owner.
873    */
874   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
875 
876   /**
877    * @notice Add a consumer to a VRF subscription.
878    * @param subId - ID of the subscription
879    * @param consumer - New consumer which can use the subscription
880    */
881   function addConsumer(uint64 subId, address consumer) external;
882 
883   /**
884    * @notice Remove a consumer from a VRF subscription.
885    * @param subId - ID of the subscription
886    * @param consumer - Consumer to remove from the subscription
887    */
888   function removeConsumer(uint64 subId, address consumer) external;
889 
890   /**
891    * @notice Cancel a subscription
892    * @param subId - ID of the subscription
893    * @param to - Where to send the remaining LINK to
894    */
895   function cancelSubscription(uint64 subId, address to) external;
896 }
897 
898 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Contract module that helps prevent reentrant calls to a function.
907  *
908  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
909  * available, which can be applied to functions to make sure there are no nested
910  * (reentrant) calls to them.
911  *
912  * Note that because there is a single `nonReentrant` guard, functions marked as
913  * `nonReentrant` may not call one another. This can be worked around by making
914  * those functions `private`, and then adding `external` `nonReentrant` entry
915  * points to them.
916  *
917  * TIP: If you would like to learn more about reentrancy and alternative ways
918  * to protect against it, check out our blog post
919  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
920  */
921 abstract contract ReentrancyGuard {
922     // Booleans are more expensive than uint256 or any type that takes up a full
923     // word because each write operation emits an extra SLOAD to first read the
924     // slot's contents, replace the bits taken up by the boolean, and then write
925     // back. This is the compiler's defense against contract upgrades and
926     // pointer aliasing, and it cannot be disabled.
927 
928     // The values being non-zero value makes deployment a bit more expensive,
929     // but in exchange the refund on every call to nonReentrant will be lower in
930     // amount. Since refunds are capped to a percentage of the total
931     // transaction's gas, it is best to keep them low in cases like this one, to
932     // increase the likelihood of the full refund coming into effect.
933     uint256 private constant _NOT_ENTERED = 1;
934     uint256 private constant _ENTERED = 2;
935 
936     uint256 private _status;
937 
938     constructor() {
939         _status = _NOT_ENTERED;
940     }
941 
942     /**
943      * @dev Prevents a contract from calling itself, directly or indirectly.
944      * Calling a `nonReentrant` function from another `nonReentrant`
945      * function is not supported. It is possible to prevent this from happening
946      * by making the `nonReentrant` function external, and making it call a
947      * `private` function that does the actual work.
948      */
949     modifier nonReentrant() {
950         // On the first call to nonReentrant, _notEntered will be true
951         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
952 
953         // Any calls to nonReentrant after this point will fail
954         _status = _ENTERED;
955 
956         _;
957 
958         // By storing the original value once again, a refund is triggered (see
959         // https://eips.ethereum.org/EIPS/eip-2200)
960         _status = _NOT_ENTERED;
961     }
962 }
963 
964 // File: @openzeppelin/contracts/utils/Strings.sol
965 
966 
967 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
968 
969 pragma solidity ^0.8.0;
970 
971 /**
972  * @dev String operations.
973  */
974 library Strings {
975     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
976 
977     /**
978      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
979      */
980     function toString(uint256 value) internal pure returns (string memory) {
981         // Inspired by OraclizeAPI's implementation - MIT licence
982         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
983 
984         if (value == 0) {
985             return "0";
986         }
987         uint256 temp = value;
988         uint256 digits;
989         while (temp != 0) {
990             digits++;
991             temp /= 10;
992         }
993         bytes memory buffer = new bytes(digits);
994         while (value != 0) {
995             digits -= 1;
996             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
997             value /= 10;
998         }
999         return string(buffer);
1000     }
1001 
1002     /**
1003      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1004      */
1005     function toHexString(uint256 value) internal pure returns (string memory) {
1006         if (value == 0) {
1007             return "0x00";
1008         }
1009         uint256 temp = value;
1010         uint256 length = 0;
1011         while (temp != 0) {
1012             length++;
1013             temp >>= 8;
1014         }
1015         return toHexString(value, length);
1016     }
1017 
1018     /**
1019      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1020      */
1021     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1022         bytes memory buffer = new bytes(2 * length + 2);
1023         buffer[0] = "0";
1024         buffer[1] = "x";
1025         for (uint256 i = 2 * length + 1; i > 1; --i) {
1026             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1027             value >>= 4;
1028         }
1029         require(value == 0, "Strings: hex length insufficient");
1030         return string(buffer);
1031     }
1032 }
1033 
1034 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1035 
1036 
1037 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1038 
1039 pragma solidity ^0.8.0;
1040 
1041 
1042 /**
1043  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1044  *
1045  * These functions can be used to verify that a message was signed by the holder
1046  * of the private keys of a given address.
1047  */
1048 library ECDSA {
1049     enum RecoverError {
1050         NoError,
1051         InvalidSignature,
1052         InvalidSignatureLength,
1053         InvalidSignatureS,
1054         InvalidSignatureV
1055     }
1056 
1057     function _throwError(RecoverError error) private pure {
1058         if (error == RecoverError.NoError) {
1059             return; // no error: do nothing
1060         } else if (error == RecoverError.InvalidSignature) {
1061             revert("ECDSA: invalid signature");
1062         } else if (error == RecoverError.InvalidSignatureLength) {
1063             revert("ECDSA: invalid signature length");
1064         } else if (error == RecoverError.InvalidSignatureS) {
1065             revert("ECDSA: invalid signature 's' value");
1066         } else if (error == RecoverError.InvalidSignatureV) {
1067             revert("ECDSA: invalid signature 'v' value");
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the address that signed a hashed message (`hash`) with
1073      * `signature` or error string. This address can then be used for verification purposes.
1074      *
1075      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1076      * this function rejects them by requiring the `s` value to be in the lower
1077      * half order, and the `v` value to be either 27 or 28.
1078      *
1079      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1080      * verification to be secure: it is possible to craft signatures that
1081      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1082      * this is by receiving a hash of the original message (which may otherwise
1083      * be too long), and then calling {toEthSignedMessageHash} on it.
1084      *
1085      * Documentation for signature generation:
1086      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1087      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1088      *
1089      * _Available since v4.3._
1090      */
1091     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1092         // Check the signature length
1093         // - case 65: r,s,v signature (standard)
1094         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1095         if (signature.length == 65) {
1096             bytes32 r;
1097             bytes32 s;
1098             uint8 v;
1099             // ecrecover takes the signature parameters, and the only way to get them
1100             // currently is to use assembly.
1101             assembly {
1102                 r := mload(add(signature, 0x20))
1103                 s := mload(add(signature, 0x40))
1104                 v := byte(0, mload(add(signature, 0x60)))
1105             }
1106             return tryRecover(hash, v, r, s);
1107         } else if (signature.length == 64) {
1108             bytes32 r;
1109             bytes32 vs;
1110             // ecrecover takes the signature parameters, and the only way to get them
1111             // currently is to use assembly.
1112             assembly {
1113                 r := mload(add(signature, 0x20))
1114                 vs := mload(add(signature, 0x40))
1115             }
1116             return tryRecover(hash, r, vs);
1117         } else {
1118             return (address(0), RecoverError.InvalidSignatureLength);
1119         }
1120     }
1121 
1122     /**
1123      * @dev Returns the address that signed a hashed message (`hash`) with
1124      * `signature`. This address can then be used for verification purposes.
1125      *
1126      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1127      * this function rejects them by requiring the `s` value to be in the lower
1128      * half order, and the `v` value to be either 27 or 28.
1129      *
1130      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1131      * verification to be secure: it is possible to craft signatures that
1132      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1133      * this is by receiving a hash of the original message (which may otherwise
1134      * be too long), and then calling {toEthSignedMessageHash} on it.
1135      */
1136     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1137         (address recovered, RecoverError error) = tryRecover(hash, signature);
1138         _throwError(error);
1139         return recovered;
1140     }
1141 
1142     /**
1143      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1144      *
1145      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1146      *
1147      * _Available since v4.3._
1148      */
1149     function tryRecover(
1150         bytes32 hash,
1151         bytes32 r,
1152         bytes32 vs
1153     ) internal pure returns (address, RecoverError) {
1154         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1155         uint8 v = uint8((uint256(vs) >> 255) + 27);
1156         return tryRecover(hash, v, r, s);
1157     }
1158 
1159     /**
1160      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1161      *
1162      * _Available since v4.2._
1163      */
1164     function recover(
1165         bytes32 hash,
1166         bytes32 r,
1167         bytes32 vs
1168     ) internal pure returns (address) {
1169         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1170         _throwError(error);
1171         return recovered;
1172     }
1173 
1174     /**
1175      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1176      * `r` and `s` signature fields separately.
1177      *
1178      * _Available since v4.3._
1179      */
1180     function tryRecover(
1181         bytes32 hash,
1182         uint8 v,
1183         bytes32 r,
1184         bytes32 s
1185     ) internal pure returns (address, RecoverError) {
1186         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1187         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1188         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1189         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1190         //
1191         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1192         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1193         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1194         // these malleable signatures as well.
1195         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1196             return (address(0), RecoverError.InvalidSignatureS);
1197         }
1198         if (v != 27 && v != 28) {
1199             return (address(0), RecoverError.InvalidSignatureV);
1200         }
1201 
1202         // If the signature is valid (and not malleable), return the signer address
1203         address signer = ecrecover(hash, v, r, s);
1204         if (signer == address(0)) {
1205             return (address(0), RecoverError.InvalidSignature);
1206         }
1207 
1208         return (signer, RecoverError.NoError);
1209     }
1210 
1211     /**
1212      * @dev Overload of {ECDSA-recover} that receives the `v`,
1213      * `r` and `s` signature fields separately.
1214      */
1215     function recover(
1216         bytes32 hash,
1217         uint8 v,
1218         bytes32 r,
1219         bytes32 s
1220     ) internal pure returns (address) {
1221         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1222         _throwError(error);
1223         return recovered;
1224     }
1225 
1226     /**
1227      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1228      * produces hash corresponding to the one signed with the
1229      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1230      * JSON-RPC method as part of EIP-191.
1231      *
1232      * See {recover}.
1233      */
1234     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1235         // 32 is the length in bytes of hash,
1236         // enforced by the type signature above
1237         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1238     }
1239 
1240     /**
1241      * @dev Returns an Ethereum Signed Message, created from `s`. This
1242      * produces hash corresponding to the one signed with the
1243      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1244      * JSON-RPC method as part of EIP-191.
1245      *
1246      * See {recover}.
1247      */
1248     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1249         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1250     }
1251 
1252     /**
1253      * @dev Returns an Ethereum Signed Typed Data, created from a
1254      * `domainSeparator` and a `structHash`. This produces hash corresponding
1255      * to the one signed with the
1256      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1257      * JSON-RPC method as part of EIP-712.
1258      *
1259      * See {recover}.
1260      */
1261     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1262         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1263     }
1264 }
1265 
1266 // File: @openzeppelin/contracts/utils/Context.sol
1267 
1268 
1269 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 /**
1274  * @dev Provides information about the current execution context, including the
1275  * sender of the transaction and its data. While these are generally available
1276  * via msg.sender and msg.data, they should not be accessed in such a direct
1277  * manner, since when dealing with meta-transactions the account sending and
1278  * paying for execution may not be the actual sender (as far as an application
1279  * is concerned).
1280  *
1281  * This contract is only required for intermediate, library-like contracts.
1282  */
1283 abstract contract Context {
1284     function _msgSender() internal view virtual returns (address) {
1285         return msg.sender;
1286     }
1287 
1288     function _msgData() internal view virtual returns (bytes calldata) {
1289         return msg.data;
1290     }
1291 }
1292 
1293 // File: contracts/ERC721A.sol
1294 
1295 
1296 // Creator: Chiru Labs
1297 
1298 pragma solidity ^0.8.4;
1299 
1300 error ApprovalCallerNotOwnerNorApproved();
1301 error ApprovalQueryForNonexistentToken();
1302 error ApproveToCaller();
1303 error ApprovalToCurrentOwner();
1304 error BalanceQueryForZeroAddress();
1305 error MintedQueryForZeroAddress();
1306 error BurnedQueryForZeroAddress();
1307 error AuxQueryForZeroAddress();
1308 error MintToZeroAddress();
1309 error MintZeroQuantity();
1310 error OwnerIndexOutOfBounds();
1311 error OwnerQueryForNonexistentToken();
1312 error TokenIndexOutOfBounds();
1313 error TransferCallerNotOwnerNorApproved();
1314 error TransferFromIncorrectOwner();
1315 error TransferToNonERC721ReceiverImplementer();
1316 error TransferToZeroAddress();
1317 error URIQueryForNonexistentToken();
1318 
1319 /**
1320  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1321  * the Metadata extension. Built to optimize for lower gas during batch mints.
1322  *
1323  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1324  *
1325  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1326  *
1327  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1328  */
1329 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1330     using Address for address;
1331     using Strings for uint256;
1332 
1333     // Compiler will pack this into a single 256bit word.
1334     struct TokenOwnership {
1335         // The address of the owner.
1336         address addr;
1337         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1338         uint64 startTimestamp;
1339         // Whether the token has been burned.
1340         bool burned;
1341     }
1342 
1343     // Compiler will pack this into a single 256bit word.
1344     struct AddressData {
1345         // Realistically, 2**64-1 is more than enough.
1346         uint64 balance;
1347         // Keeps track of mint count with minimal overhead for tokenomics.
1348         uint64 numberMinted;
1349         // Keeps track of burn count with minimal overhead for tokenomics.
1350         uint64 numberBurned;
1351         // For miscellaneous variable(s) pertaining to the address
1352         // (e.g. number of whitelist mint slots used).
1353         // If there are multiple variables, please pack them into a uint64.
1354         uint64 aux;
1355     }
1356 
1357     // The tokenId of the next token to be minted.
1358     uint256 internal _currentIndex;
1359 
1360     // The number of tokens burned.
1361     uint256 internal _burnCounter;
1362 
1363     // Token name
1364     string private _name;
1365 
1366     // Token symbol
1367     string private _symbol;
1368 
1369     // Mapping from token ID to ownership details
1370     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1371     mapping(uint256 => TokenOwnership) internal _ownerships;
1372 
1373     // Mapping owner address to address data
1374     mapping(address => AddressData) private _addressData;
1375 
1376     // Mapping from token ID to approved address
1377     mapping(uint256 => address) private _tokenApprovals;
1378 
1379     // Mapping from owner to operator approvals
1380     mapping(address => mapping(address => bool)) private _operatorApprovals;
1381 
1382     constructor(string memory name_, string memory symbol_) {
1383         _name = name_;
1384         _symbol = symbol_;
1385         _currentIndex = _startTokenId();
1386     }
1387 
1388     /**
1389      * To change the starting tokenId, please override this function.
1390      */
1391     function _startTokenId() internal view virtual returns (uint256) {
1392         return 0;
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-totalSupply}.
1397      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1398      */
1399     function totalSupply() public view returns (uint256) {
1400         // Counter underflow is impossible as _burnCounter cannot be incremented
1401         // more than _currentIndex - _startTokenId() times
1402         unchecked {
1403             return _currentIndex - _burnCounter - _startTokenId();
1404         }
1405     }
1406 
1407     /**
1408      * Returns the total amount of tokens minted in the contract.
1409      */
1410     function _totalMinted() internal view returns (uint256) {
1411         // Counter underflow is impossible as _currentIndex does not decrement,
1412         // and it is initialized to _startTokenId()
1413         unchecked {
1414             return _currentIndex - _startTokenId();
1415         }
1416     }
1417 
1418     /**
1419      * @dev See {IERC165-supportsInterface}.
1420      */
1421     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1422         return
1423             interfaceId == type(IERC721).interfaceId ||
1424             interfaceId == type(IERC721Metadata).interfaceId ||
1425             super.supportsInterface(interfaceId);
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-balanceOf}.
1430      */
1431     function balanceOf(address owner) public view override returns (uint256) {
1432         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1433         return uint256(_addressData[owner].balance);
1434     }
1435 
1436     /**
1437      * Returns the number of tokens minted by `owner`.
1438      */
1439     function _numberMinted(address owner) internal view returns (uint256) {
1440         if (owner == address(0)) revert MintedQueryForZeroAddress();
1441         return uint256(_addressData[owner].numberMinted);
1442     }
1443 
1444     /**
1445      * Returns the number of tokens burned by or on behalf of `owner`.
1446      */
1447     function _numberBurned(address owner) internal view returns (uint256) {
1448         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1449         return uint256(_addressData[owner].numberBurned);
1450     }
1451 
1452     /**
1453      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1454      */
1455     function _getAux(address owner) internal view returns (uint64) {
1456         if (owner == address(0)) revert AuxQueryForZeroAddress();
1457         return _addressData[owner].aux;
1458     }
1459 
1460     /**
1461      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1462      * If there are multiple variables, please pack them into a uint64.
1463      */
1464     function _setAux(address owner, uint64 aux) internal {
1465         if (owner == address(0)) revert AuxQueryForZeroAddress();
1466         _addressData[owner].aux = aux;
1467     }
1468 
1469     /**
1470      * Gas spent here starts off proportional to the maximum mint batch size.
1471      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1472      */
1473     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1474         uint256 curr = tokenId;
1475 
1476         unchecked {
1477             if (_startTokenId() <= curr && curr < _currentIndex) {
1478                 TokenOwnership memory ownership = _ownerships[curr];
1479                 if (!ownership.burned) {
1480                     if (ownership.addr != address(0)) {
1481                         return ownership;
1482                     }
1483                     // Invariant:
1484                     // There will always be an ownership that has an address and is not burned
1485                     // before an ownership that does not have an address and is not burned.
1486                     // Hence, curr will not underflow.
1487                     while (true) {
1488                         curr--;
1489                         ownership = _ownerships[curr];
1490                         if (ownership.addr != address(0)) {
1491                             return ownership;
1492                         }
1493                     }
1494                 }
1495             }
1496         }
1497         revert OwnerQueryForNonexistentToken();
1498     }
1499 
1500     /**
1501      * @dev See {IERC721-ownerOf}.
1502      */
1503     function ownerOf(uint256 tokenId) public view override returns (address) {
1504         return ownershipOf(tokenId).addr;
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Metadata-name}.
1509      */
1510     function name() public view virtual override returns (string memory) {
1511         return _name;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Metadata-symbol}.
1516      */
1517     function symbol() public view virtual override returns (string memory) {
1518         return _symbol;
1519     }
1520 
1521     /**
1522      * @dev See {IERC721Metadata-tokenURI}.
1523      */
1524     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1525         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1526 
1527         string memory baseURI = _baseURI();
1528         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1529     }
1530 
1531     /**
1532      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1533      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1534      * by default, can be overriden in child contracts.
1535      */
1536     function _baseURI() internal view virtual returns (string memory) {
1537         return '';
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-approve}.
1542      */
1543     function approve(address to, uint256 tokenId) public override {
1544         address owner = ERC721A.ownerOf(tokenId);
1545         if (to == owner) revert ApprovalToCurrentOwner();
1546 
1547         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1548             revert ApprovalCallerNotOwnerNorApproved();
1549         }
1550 
1551         _approve(to, tokenId, owner);
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-getApproved}.
1556      */
1557     function getApproved(uint256 tokenId) public view override returns (address) {
1558         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1559 
1560         return _tokenApprovals[tokenId];
1561     }
1562 
1563     /**
1564      * @dev See {IERC721-setApprovalForAll}.
1565      */
1566     function setApprovalForAll(address operator, bool approved) public override {
1567         if (operator == _msgSender()) revert ApproveToCaller();
1568 
1569         _operatorApprovals[_msgSender()][operator] = approved;
1570         emit ApprovalForAll(_msgSender(), operator, approved);
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-isApprovedForAll}.
1575      */
1576     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1577         return _operatorApprovals[owner][operator];
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-transferFrom}.
1582      */
1583     function transferFrom(
1584         address from,
1585         address to,
1586         uint256 tokenId
1587     ) public virtual override {
1588         _transfer(from, to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-safeTransferFrom}.
1593      */
1594     function safeTransferFrom(
1595         address from,
1596         address to,
1597         uint256 tokenId
1598     ) public virtual override {
1599         safeTransferFrom(from, to, tokenId, '');
1600     }
1601 
1602     /**
1603      * @dev See {IERC721-safeTransferFrom}.
1604      */
1605     function safeTransferFrom(
1606         address from,
1607         address to,
1608         uint256 tokenId,
1609         bytes memory _data
1610     ) public virtual override {
1611         _transfer(from, to, tokenId);
1612         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1613             revert TransferToNonERC721ReceiverImplementer();
1614         }
1615     }
1616 
1617     /**
1618      * @dev Returns whether `tokenId` exists.
1619      *
1620      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1621      *
1622      * Tokens start existing when they are minted (`_mint`),
1623      */
1624     function _exists(uint256 tokenId) internal view returns (bool) {
1625         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1626             !_ownerships[tokenId].burned;
1627     }
1628 
1629     function _safeMint(address to, uint256 quantity) internal {
1630         _safeMint(to, quantity, '');
1631     }
1632 
1633     /**
1634      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1635      *
1636      * Requirements:
1637      *
1638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1639      * - `quantity` must be greater than 0.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _safeMint(
1644         address to,
1645         uint256 quantity,
1646         bytes memory _data
1647     ) internal {
1648         _mint(to, quantity, _data, true);
1649     }
1650 
1651     /**
1652      * @dev Mints `quantity` tokens and transfers them to `to`.
1653      *
1654      * Requirements:
1655      *
1656      * - `to` cannot be the zero address.
1657      * - `quantity` must be greater than 0.
1658      *
1659      * Emits a {Transfer} event.
1660      */
1661     function _mint(
1662         address to,
1663         uint256 quantity,
1664         bytes memory _data,
1665         bool safe
1666     ) internal {
1667         uint256 startTokenId = _currentIndex;
1668         if (to == address(0)) revert MintToZeroAddress();
1669         if (quantity == 0) revert MintZeroQuantity();
1670 
1671         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1672 
1673         // Overflows are incredibly unrealistic.
1674         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1675         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1676         unchecked {
1677             _addressData[to].balance += uint64(quantity);
1678             _addressData[to].numberMinted += uint64(quantity);
1679 
1680             _ownerships[startTokenId].addr = to;
1681             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1682 
1683             uint256 updatedIndex = startTokenId;
1684             uint256 end = updatedIndex + quantity;
1685 
1686             if (safe && to.isContract()) {
1687                 do {
1688                     emit Transfer(address(0), to, updatedIndex);
1689                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1690                         revert TransferToNonERC721ReceiverImplementer();
1691                     }
1692                 } while (updatedIndex != end);
1693                 // Reentrancy protection
1694                 if (_currentIndex != startTokenId) revert();
1695             } else {
1696                 do {
1697                     emit Transfer(address(0), to, updatedIndex++);
1698                 } while (updatedIndex != end);
1699             }
1700             _currentIndex = updatedIndex;
1701         }
1702         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1703     }
1704 
1705     /**
1706      * @dev Transfers `tokenId` from `from` to `to`.
1707      *
1708      * Requirements:
1709      *
1710      * - `to` cannot be the zero address.
1711      * - `tokenId` token must be owned by `from`.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _transfer(
1716         address from,
1717         address to,
1718         uint256 tokenId
1719     ) private {
1720         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1721 
1722         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1723             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1724             getApproved(tokenId) == _msgSender());
1725 
1726         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1727         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1728         if (to == address(0)) revert TransferToZeroAddress();
1729 
1730         _beforeTokenTransfers(from, to, tokenId, 1);
1731 
1732         // Clear approvals from the previous owner
1733         _approve(address(0), tokenId, prevOwnership.addr);
1734 
1735         // Underflow of the sender's balance is impossible because we check for
1736         // ownership above and the recipient's balance can't realistically overflow.
1737         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1738         unchecked {
1739             _addressData[from].balance -= 1;
1740             _addressData[to].balance += 1;
1741 
1742             _ownerships[tokenId].addr = to;
1743             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1744 
1745             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1746             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1747             uint256 nextTokenId = tokenId + 1;
1748             if (_ownerships[nextTokenId].addr == address(0)) {
1749                 // This will suffice for checking _exists(nextTokenId),
1750                 // as a burned slot cannot contain the zero address.
1751                 if (nextTokenId < _currentIndex) {
1752                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1753                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1754                 }
1755             }
1756         }
1757 
1758         emit Transfer(from, to, tokenId);
1759         _afterTokenTransfers(from, to, tokenId, 1);
1760     }
1761 
1762     /**
1763      * @dev Destroys `tokenId`.
1764      * The approval is cleared when the token is burned.
1765      *
1766      * Requirements:
1767      *
1768      * - `tokenId` must exist.
1769      *
1770      * Emits a {Transfer} event.
1771      */
1772     function _burn(uint256 tokenId) internal virtual {
1773         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1774 
1775         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1776 
1777         // Clear approvals from the previous owner
1778         _approve(address(0), tokenId, prevOwnership.addr);
1779 
1780         // Underflow of the sender's balance is impossible because we check for
1781         // ownership above and the recipient's balance can't realistically overflow.
1782         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1783         unchecked {
1784             _addressData[prevOwnership.addr].balance -= 1;
1785             _addressData[prevOwnership.addr].numberBurned += 1;
1786 
1787             // Keep track of who burned the token, and the timestamp of burning.
1788             _ownerships[tokenId].addr = prevOwnership.addr;
1789             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1790             _ownerships[tokenId].burned = true;
1791 
1792             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1793             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1794             uint256 nextTokenId = tokenId + 1;
1795             if (_ownerships[nextTokenId].addr == address(0)) {
1796                 // This will suffice for checking _exists(nextTokenId),
1797                 // as a burned slot cannot contain the zero address.
1798                 if (nextTokenId < _currentIndex) {
1799                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1800                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1801                 }
1802             }
1803         }
1804 
1805         emit Transfer(prevOwnership.addr, address(0), tokenId);
1806         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1807 
1808         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1809         unchecked {
1810             _burnCounter++;
1811         }
1812     }
1813 
1814     /**
1815      * @dev Approve `to` to operate on `tokenId`
1816      *
1817      * Emits a {Approval} event.
1818      */
1819     function _approve(
1820         address to,
1821         uint256 tokenId,
1822         address owner
1823     ) private {
1824         _tokenApprovals[tokenId] = to;
1825         emit Approval(owner, to, tokenId);
1826     }
1827 
1828     /**
1829      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1830      *
1831      * @param from address representing the previous owner of the given token ID
1832      * @param to target address that will receive the tokens
1833      * @param tokenId uint256 ID of the token to be transferred
1834      * @param _data bytes optional data to send along with the call
1835      * @return bool whether the call correctly returned the expected magic value
1836      */
1837     function _checkContractOnERC721Received(
1838         address from,
1839         address to,
1840         uint256 tokenId,
1841         bytes memory _data
1842     ) private returns (bool) {
1843         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1844             return retval == IERC721Receiver(to).onERC721Received.selector;
1845         } catch (bytes memory reason) {
1846             if (reason.length == 0) {
1847                 revert TransferToNonERC721ReceiverImplementer();
1848             } else {
1849                 assembly {
1850                     revert(add(32, reason), mload(reason))
1851                 }
1852             }
1853         }
1854     }
1855 
1856     /**
1857      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1858      * And also called before burning one token.
1859      *
1860      * startTokenId - the first token id to be transferred
1861      * quantity - the amount to be transferred
1862      *
1863      * Calling conditions:
1864      *
1865      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1866      * transferred to `to`.
1867      * - When `from` is zero, `tokenId` will be minted for `to`.
1868      * - When `to` is zero, `tokenId` will be burned by `from`.
1869      * - `from` and `to` are never both zero.
1870      */
1871     function _beforeTokenTransfers(
1872         address from,
1873         address to,
1874         uint256 startTokenId,
1875         uint256 quantity
1876     ) internal virtual {}
1877 
1878     /**
1879      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1880      * minting.
1881      * And also called after one token has been burned.
1882      *
1883      * startTokenId - the first token id to be transferred
1884      * quantity - the amount to be transferred
1885      *
1886      * Calling conditions:
1887      *
1888      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1889      * transferred to `to`.
1890      * - When `from` is zero, `tokenId` has been minted for `to`.
1891      * - When `to` is zero, `tokenId` has been burned by `from`.
1892      * - `from` and `to` are never both zero.
1893      */
1894     function _afterTokenTransfers(
1895         address from,
1896         address to,
1897         uint256 startTokenId,
1898         uint256 quantity
1899     ) internal virtual {}
1900 }
1901 // File: @openzeppelin/contracts/access/Ownable.sol
1902 
1903 
1904 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1905 
1906 pragma solidity ^0.8.0;
1907 
1908 
1909 /**
1910  * @dev Contract module which provides a basic access control mechanism, where
1911  * there is an account (an owner) that can be granted exclusive access to
1912  * specific functions.
1913  *
1914  * By default, the owner account will be the one that deploys the contract. This
1915  * can later be changed with {transferOwnership}.
1916  *
1917  * This module is used through inheritance. It will make available the modifier
1918  * `onlyOwner`, which can be applied to your functions to restrict their use to
1919  * the owner.
1920  */
1921 abstract contract Ownable is Context {
1922     address private _owner;
1923 
1924     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1925 
1926     /**
1927      * @dev Initializes the contract setting the deployer as the initial owner.
1928      */
1929     constructor() {
1930         _transferOwnership(_msgSender());
1931     }
1932 
1933     /**
1934      * @dev Returns the address of the current owner.
1935      */
1936     function owner() public view virtual returns (address) {
1937         return _owner;
1938     }
1939 
1940     /**
1941      * @dev Throws if called by any account other than the owner.
1942      */
1943     modifier onlyOwner() {
1944         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1945         _;
1946     }
1947 
1948     /**
1949      * @dev Leaves the contract without owner. It will not be possible to call
1950      * `onlyOwner` functions anymore. Can only be called by the current owner.
1951      *
1952      * NOTE: Renouncing ownership will leave the contract without an owner,
1953      * thereby removing any functionality that is only available to the owner.
1954      */
1955     function renounceOwnership() public virtual onlyOwner {
1956         _transferOwnership(address(0));
1957     }
1958 
1959     /**
1960      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1961      * Can only be called by the current owner.
1962      */
1963     function transferOwnership(address newOwner) public virtual onlyOwner {
1964         require(newOwner != address(0), "Ownable: new owner is the zero address");
1965         _transferOwnership(newOwner);
1966     }
1967 
1968     /**
1969      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1970      * Internal function without access restriction.
1971      */
1972     function _transferOwnership(address newOwner) internal virtual {
1973         address oldOwner = _owner;
1974         _owner = newOwner;
1975         emit OwnershipTransferred(oldOwner, newOwner);
1976     }
1977 }
1978 
1979 // File: contracts/ZombieClubToken.sol
1980 
1981 
1982 pragma solidity ^0.8.0;
1983 
1984 error InvalidTotalMysteryBoxes();
1985 error ReachedMaxSupply();
1986 error TransactionExpired();
1987 error SignatureAlreadyUsed();
1988 error ExceedMaxAllowedMintAmount();
1989 error IncorrectSignature();
1990 error InsufficientPayments();
1991 error RevealNotAllowed();
1992 error MerkleTreeRootNotSet();
1993 error InvalidMerkleTreeProof();
1994 error RequestRevealNotOwner();
1995 error RevealAlreadyRequested();
1996 error IncorrectRevealIndex();
1997 error TokenAlreadyRevealed();
1998 error MerkleTreeProofFailed();
1999 error IncorrectRevealManyLength();
2000 error TokenRevealQueryForNonexistentToken();
2001 
2002 
2003 /// @title ZombieClubToken
2004 /// @author Teahouse Finance
2005 contract ZombieClubToken is ERC721A, Ownable, ReentrancyGuard, VRFConsumerBaseV2 {
2006     using Strings for uint256;
2007     using ECDSA for bytes32;
2008 
2009     struct ChainlinkParams {
2010         bytes32 keyHash;
2011         uint64 subId;
2012         uint32 gasLimit;
2013         uint16 requestConfirms;
2014     }
2015 
2016     struct TokenReveal {
2017         bool requested;     // token reveal requested
2018         uint64 revealId;
2019     }
2020 
2021     struct TokenInternalInfo {
2022         bool requested;     // token reveal requested
2023         uint64 revealId;
2024         uint64 lastTransferTime;
2025         uint64 stateChangePeriod;
2026     }
2027 
2028     // Chainlink info
2029     VRFCoordinatorV2Interface immutable public COORDINATOR;   
2030     ChainlinkParams public chainlinkParams;
2031 
2032     address private signer;
2033     uint256 public price = 0.666 ether;
2034     uint256 public maxCollection;
2035     uint64 public presaleEndTime;
2036 
2037     string public unrevealURI;
2038     bool public allowReveal = false;
2039     bytes32 public hashMerkleRoot;
2040     uint256 public revealedTokens;
2041     uint256 public totalMysteryBoxes;
2042 
2043     // state change period (second)
2044     uint256 constant stateChangePeriod = 2397600;
2045     uint256 constant stateChangeVariation = 237600;
2046     uint256 constant numOfStates = 4;
2047 
2048     mapping(uint256 => uint256) private tokenIdMap;
2049     mapping(uint256 => bytes32[numOfStates]) private tokenBaseURIHashes;
2050     mapping(uint256 => uint256) public chainlinkTokenId;
2051     mapping(uint256 => TokenInternalInfo) private tokenInternalInfo;
2052     mapping(bytes32 => bool) public signatureUsed;
2053 
2054     event RevealRequested(uint256 indexed tokenId, uint256 requestId);
2055     event RevealReceived(uint256 indexed tokenId, uint256 revealId);
2056     event Revealed(uint256 indexed tokenId);
2057 
2058     constructor(
2059         string memory _name,
2060         string memory _symbol,
2061         address _initSigner,            // whitelist signer address
2062         uint256 _maxCollection,         // total supply
2063         uint256 _totalMysteryBoxes,     // number of all mystery boxes available
2064         address _vrfCoordinator,        // Chainlink VRF coordinator address
2065         ChainlinkParams memory _chainlinkParams
2066     ) ERC721A(_name, _symbol) VRFConsumerBaseV2(_vrfCoordinator) {
2067         if (_totalMysteryBoxes < _maxCollection) revert InvalidTotalMysteryBoxes();
2068 
2069         COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
2070         signer = _initSigner;
2071         maxCollection = _maxCollection;
2072         totalMysteryBoxes = _totalMysteryBoxes;
2073         chainlinkParams = _chainlinkParams;
2074     }
2075 
2076     function setPresaleEndTime(uint64 _newTime) external onlyOwner {
2077         presaleEndTime = _newTime;
2078     }
2079 
2080     function setPrice(uint256 _newPrice) external onlyOwner {
2081         price = _newPrice;
2082     }
2083 
2084     function setSigner(address _newSigner) external onlyOwner {
2085         signer = _newSigner;
2086     }
2087 
2088     function setChainlinkParams(ChainlinkParams memory _chainlinkParams) external onlyOwner {
2089         chainlinkParams = _chainlinkParams;
2090     }
2091 
2092     function setUnrevealURI(string calldata _newURI) external onlyOwner {
2093         unrevealURI = _newURI;
2094     }
2095 
2096     function setMerkleRoot(bytes32 _hashMerkleRoot) public onlyOwner {
2097         require(revealedTokens == 0);               // can't be changed after someone requested reveal
2098         hashMerkleRoot = _hashMerkleRoot;
2099     }
2100 
2101     function setAllowReveal(bool _allowReveal) external onlyOwner {
2102         allowReveal = _allowReveal;
2103     }
2104 
2105     function withdraw(address payable _to) external payable onlyOwner {
2106         (bool success, ) = _to.call{value: address(this).balance}("");
2107         require(success);
2108 	}
2109 
2110     function isAuthorized(
2111         address _sender,
2112         uint32 _allowAmount,
2113         uint64 _expireTime,
2114         bytes memory _signature
2115     ) private view returns (bool) {
2116         bytes32 hashMsg = keccak256(abi.encodePacked(_sender, _allowAmount, _expireTime));
2117         bytes32 ethHashMessage = hashMsg.toEthSignedMessageHash();
2118 
2119         return ethHashMessage.recover(_signature) == signer;
2120     }
2121 
2122     function mint(uint32 _amount, uint32 _allowAmount, uint64 _expireTime, bytes calldata _signature) external payable {
2123         if (totalSupply() + _amount > maxCollection) revert ReachedMaxSupply();
2124         if (block.timestamp > _expireTime) revert TransactionExpired();
2125 
2126         if (block.timestamp > presaleEndTime) {
2127             // PUBLIC SALE mode
2128             // does not limit how many tokens one can mint in total,
2129             // only limit how many tokens one can mint in one go
2130             // also, make sure one signature can only be used once
2131             if (_amount > _allowAmount) revert ExceedMaxAllowedMintAmount();
2132 
2133             bytes32 sigHash = keccak256(abi.encodePacked(_signature));
2134             if (signatureUsed[sigHash]) revert SignatureAlreadyUsed();
2135             signatureUsed[sigHash] = true;
2136         }
2137         else {
2138             // WHITELIST SALE mode
2139             // limit how many tokens one can mint in total
2140             if (_numberMinted(msg.sender) + _amount > _allowAmount) revert ExceedMaxAllowedMintAmount();
2141         }
2142 
2143         if (!isAuthorized(msg.sender, _allowAmount, _expireTime, _signature)) revert IncorrectSignature();
2144 
2145         uint256 finalPrice = price * _amount;
2146         if (msg.value < finalPrice) revert InsufficientPayments();
2147         
2148         _safeMint(msg.sender, _amount);
2149     }
2150 
2151     function devMint(uint256 _amount, address _to) external onlyOwner {
2152         if (totalSupply() + _amount > maxCollection) revert ReachedMaxSupply();
2153 
2154         _safeMint(_to, _amount);
2155     }
2156 
2157     function requestReveal(uint256 _tokenId) external nonReentrant {
2158         if (!allowReveal) revert RevealNotAllowed();
2159         if (ownerOf(_tokenId) != msg.sender) revert RequestRevealNotOwner();
2160         if (tokenInternalInfo[_tokenId].requested) revert RevealAlreadyRequested();
2161         if (hashMerkleRoot == bytes32(0)) revert MerkleTreeRootNotSet();
2162 
2163         uint256 requestId = COORDINATOR.requestRandomWords(
2164             chainlinkParams.keyHash,
2165             chainlinkParams.subId,
2166             chainlinkParams.requestConfirms,
2167             chainlinkParams.gasLimit,
2168             1
2169         );
2170 
2171         tokenInternalInfo[_tokenId].requested = true;
2172         chainlinkTokenId[requestId] = _tokenId;
2173 
2174         emit RevealRequested(_tokenId, requestId);
2175     }
2176 
2177     function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
2178         uint256 tokenId = chainlinkTokenId[requestId];
2179         if (tokenInternalInfo[tokenId].requested && tokenInternalInfo[tokenId].revealId == 0) {
2180             uint256 randomIndex = randomWords[0] % (totalMysteryBoxes - revealedTokens) + revealedTokens;
2181             uint256 revealId = _tokenIdMap(randomIndex);
2182             uint256 currentId = _tokenIdMap(revealedTokens);
2183 
2184             tokenIdMap[randomIndex] = currentId;
2185             tokenInternalInfo[tokenId].revealId = uint64(revealId);
2186             revealedTokens ++;
2187 
2188             emit RevealReceived(tokenId, revealId);
2189         }
2190     }
2191 
2192     function reveal(uint256 _tokenId, bytes32[numOfStates] memory _tokenBaseURIHashes, uint256 _index, bytes32 _salt, bytes32[] memory _proof) public {       
2193         if (hashMerkleRoot == bytes32(0)) revert MerkleTreeRootNotSet();
2194         if (_index == 0 || tokenInternalInfo[_tokenId].revealId != _index) revert IncorrectRevealIndex();
2195         if (tokenBaseURIHashes[_tokenId][0] != 0) revert TokenAlreadyRevealed();
2196 
2197         // perform merkle root proof verification
2198         bytes32 hash = keccak256(abi.encodePacked(_tokenBaseURIHashes, _index, _salt));
2199         if (!MerkleProof.verify(_proof, hashMerkleRoot, hash)) revert MerkleTreeProofFailed();
2200 
2201         tokenBaseURIHashes[_tokenId] = _tokenBaseURIHashes;
2202         _setTokenTimeInfo(_tokenId);
2203 
2204         emit Revealed(_tokenId);
2205     }
2206 
2207     function revealMany(uint256[] memory _tokenIds, bytes32[numOfStates][] memory _tokenBaseURIHashes, uint256[] memory _indexes, bytes32[] memory _salts, bytes32[][] memory _prooves) public {
2208         if (hashMerkleRoot == bytes32(0)) revert MerkleTreeRootNotSet();
2209         if (_tokenIds.length != _tokenBaseURIHashes.length) revert IncorrectRevealManyLength();
2210         if (_tokenIds.length != _indexes.length) revert IncorrectRevealManyLength();
2211         if (_tokenIds.length != _salts.length) revert IncorrectRevealManyLength();
2212         if (_tokenIds.length != _prooves.length) revert IncorrectRevealManyLength();
2213 
2214         uint256 i;
2215         uint256 length = _tokenIds.length;
2216         for (i = 0; i < length; i++) {
2217             if (tokenBaseURIHashes[_tokenIds[i]][0] == 0) {
2218                 // only calls reveal for those not revealed yet
2219                 // this is to revent the case where one revealed token will cause the entire batch to revert
2220                 // we only check for "revealed" but not for other situation as the entire batch is supposed to have
2221                 // correct parameters
2222                 reveal(_tokenIds[i], _tokenBaseURIHashes[i], _indexes[i], _salts[i], _prooves[i]);
2223             }
2224         }
2225     }
2226 
2227     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2228 	    if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
2229         
2230         if (tokenBaseURIHashes[_tokenId][0] == 0) {
2231             return unrevealURI;
2232         }
2233         else {
2234             bytes32 hash = tokenBaseURIHashes[_tokenId][_getZombieState(_tokenId)];
2235             return string(abi.encodePacked("ipfs://", IPFSConvert.cidv0FromBytes32(hash)));
2236         }
2237 	}
2238 
2239     function totalMinted() external view returns (uint256) {
2240         return _totalMinted();
2241     }
2242 
2243     function numberMinted(address _minter) external view returns (uint256) {
2244         return _numberMinted(_minter);
2245     }
2246 
2247     function tokenReveal(uint256 _tokenId) external view returns (TokenReveal memory) {
2248         if (!_exists(_tokenId)) revert TokenRevealQueryForNonexistentToken();
2249 
2250         return TokenReveal({
2251             requested: tokenInternalInfo[_tokenId].requested,
2252             revealId: tokenInternalInfo[_tokenId].revealId
2253         });
2254     }
2255 
2256     function ownedTokens(address _addr, uint256 _startId, uint256 _endId) external view returns (uint256[] memory, uint256) {
2257         if (_endId == 0) {
2258             _endId = _currentIndex - 1;
2259         }
2260 
2261         if (_startId < _startTokenId() || _endId >= _currentIndex) revert TokenIndexOutOfBounds();
2262 
2263         uint256 i;
2264         uint256 balance = balanceOf(_addr);
2265         if (balance == 0) {
2266             return (new uint256[](0), _endId + 1);
2267         }
2268 
2269         if (balance > 256) {
2270             balance = 256;
2271         }
2272 
2273         uint256[] memory results = new uint256[](balance);
2274         uint256 idx = 0;
2275         
2276         address owner = ownerOf(_startId);
2277         for (i = _startId; i <= _endId; i++) {
2278             if (_ownerships[i].addr != address(0)) {
2279                 owner = _ownerships[i].addr;
2280             }
2281 
2282             if (!_ownerships[i].burned && owner == _addr) {
2283                 results[idx] = i;
2284                 idx++;
2285 
2286                 if (idx == balance) {
2287                     if (balance == balanceOf(_addr)) {
2288                         return (results, _endId + 1);
2289                     }
2290                     else {
2291                         return (results, i + 1);
2292                     }
2293                 }
2294             }
2295         }
2296 
2297         uint256[] memory partialResults = new uint256[](idx);
2298         for (i = 0; i < idx; i++) {
2299             partialResults[i] = results[i];
2300         }        
2301 
2302         return (partialResults, _endId + 1);
2303     }
2304 
2305     function unrevealedTokens(uint256 _startId, uint256 _endId) external view returns (uint256[] memory, uint256) {
2306         if (_endId == 0) {
2307             _endId = _currentIndex - 1;
2308         }
2309 
2310         if (_startId < _startTokenId() || _endId >= _currentIndex) revert TokenIndexOutOfBounds();
2311 
2312         uint256 i;
2313         uint256[] memory results = new uint256[](256);
2314         uint256 idx = 0;
2315         
2316         for (i = _startId; i <= _endId; i++) {
2317             if (tokenInternalInfo[i].revealId != 0 && tokenBaseURIHashes[i][0] == 0) {
2318                 // reveal received but not revealed
2319                 results[idx] = i;
2320                 idx++;
2321 
2322                 if (idx == 256) {
2323                     return (results, i + 1);
2324                 }
2325             }
2326         }
2327 
2328         uint256[] memory partialResults = new uint256[](idx);
2329         for (i = 0; i < idx; i++) {
2330             partialResults[i] = results[i];
2331         }
2332 
2333         return (partialResults, _endId + 1);
2334     }
2335 
2336     function _startTokenId() override internal view virtual returns (uint256) {
2337         return 1;
2338     }
2339 
2340     function _tokenIdMap(uint256 _index) private view returns (uint256) {
2341         if (tokenIdMap[_index] == 0) {
2342             return _index + 1;
2343         }
2344         else {
2345             return tokenIdMap[_index];
2346         }
2347     }
2348 
2349     function _getZombieState(uint256 _tokenId) internal view returns (uint256) {
2350         uint256 duration = block.timestamp - tokenInternalInfo[_tokenId].lastTransferTime;
2351         uint256 state = duration / tokenInternalInfo[_tokenId].stateChangePeriod;
2352         if (state >= numOfStates) {
2353             state = numOfStates - 1;
2354         }
2355 
2356         while(tokenBaseURIHashes[_tokenId][state] == 0) {
2357             state--;
2358         }
2359 
2360         return state;
2361     }
2362     
2363     function _afterTokenTransfers(
2364         address from, 
2365         address to,
2366         uint256 startTokenId,
2367         uint256 /*quantity*/) internal override {
2368 
2369         // only reset token time info when actually transfering the token
2370         // not when minting
2371         // so "quantity" should always be 1
2372         if (from != address(0) && to != address(0)) {
2373             _setTokenTimeInfo(startTokenId);
2374         }
2375     }
2376 
2377     function _setTokenTimeInfo(uint256 _tokenId) private {
2378         tokenInternalInfo[_tokenId].lastTransferTime = uint64(block.timestamp);
2379         tokenInternalInfo[_tokenId].stateChangePeriod = uint64(stateChangePeriod + _randomNumber() % stateChangeVariation);
2380     }
2381 
2382     function _randomNumber() internal view returns (uint256) {
2383         return uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
2384     }
2385 }